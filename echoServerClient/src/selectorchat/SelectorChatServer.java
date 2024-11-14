package selectorchat;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

// 채팅 서버(SelectorChatServer)
public class SelectorChatServer {
	private Selector selector; // Selector 객체: 여러 채널을 관리
	private ServerSocketChannel serverChannel;
	private final static Integer MAX_CONN = 5; // 최대 연결 가능 횟수를 5회로 제한
	private final static Integer MAX_READY = 5; // 대기열 최대 채널 갯수
	private Set<SocketChannel> allClient = Collections.synchronizedSet(new HashSet<>()); // 동기화 HashSet
	private BlockingQueue<SocketChannel> waitingQueue = new LinkedBlockingQueue<>(MAX_READY); // 대기 중인 클라이언트 목록
	private Set<String> nicknames = Collections.synchronizedSet(new HashSet<>()); // 현재 사용중인 닉네임 중복입력 제거를 위한 동기화 HashSet

	// 생성자 - 초기화
	public SelectorChatServer(int port) {
		try {
			// Selector 생성
			selector = Selector.open();
			// 서버 소켓 채널 생성
			serverChannel = ServerSocketChannel.open();
			// 지정된 포트에 바인딩
			serverChannel.bind(new InetSocketAddress(port));
			// 서버 채널은 비차단 모드로 설정
			serverChannel.configureBlocking(false);
			// Selector에 서버 소켓 채널 등록, 클라이언트 연결 수신을 위해 OP_ACCEPT 이벤트를 설정
			serverChannel.register(selector, SelectionKey.OP_ACCEPT);
		} catch (IOException e) {
			System.err.println("서버 생성자 초기화 예외 발생 : " + e.getMessage());
			try {
				if (serverChannel != null && serverChannel.isOpen())
					serverChannel.close();
				if (selector != null && selector.isOpen())
					selector.close();
			} catch (IOException e1) {
				System.out.println("생성자 자원 해제 중 에러 발생" + e.getMessage());
				e.printStackTrace();
			}
		}
		System.out.println("Chat server started on port: " + port);
	}

	public void start() throws IOException {
		// 서버가 동작하는 동안 계속 실행
		while (true) {
			// 준비된 채널을 감지(준비 완료 이벤트가 있을 때까지 대기)blocking
			selector.select();
			Set<SelectionKey> selectedKeys = selector.selectedKeys(); // 선택된 키 집합
			Iterator<SelectionKey> iterator = selectedKeys.iterator(); // 키집합을 순회하는 Iterator

			// 선택된 키를 반복
			while (iterator.hasNext()) {
				SelectionKey key = iterator.next();
				try {
					if (key.isAcceptable()) {
						// 새로운 클라이언트 연결 수락
						acceptConnection(key);
					} else if (key.isReadable()) {
						// 클라이언트로부터 메시지 읽기
						readMessage(key);
					}
				} catch (IOException e) {
					System.err.println("클라이언트 연결 관련 예외 발생 : " + e.getMessage());
					closeClientConnection(key);
				}
				iterator.remove(); // 처리한 키는 제거
			}
			try {
				Thread.sleep(50);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

	// 클라이언트 연결 종료 및 자원 해제
	private void closeClientConnection(SelectionKey key) {
		SocketChannel clientChannel = (SocketChannel) key.channel();
		if (clientChannel != null) {
			try {
				allClient.remove(clientChannel);
				Client removeClient = (Client) key.attachment();
				nicknames.remove(removeClient.getNick());
				System.out.println("닉네임 목록:" + nicknames);
				System.out.println("Client disconnected: " + clientChannel.getRemoteAddress());
				if (clientChannel != null) {
					clientChannel.close();
				}
				// 대기 큐에서 다음 클라이언트 연결
				if (!waitingQueue.isEmpty()) {
					SocketChannel nextClient = waitingQueue.poll(); // 대기열에서 연결가능 클라이언트
					if (nextClient != null) {
						nextClient.configureBlocking(false);
						nextClient.register(selector, SelectionKey.OP_READ, new Client());
						allClient.add(nextClient);
						System.out.println("다음 클라이언트가 대기열에서 빠져나와 연결됨 : " + nextClient.getRemoteAddress());

						// 클라이언트에게 닉네임 입력 요청
						ByteBuffer buffer = ByteBuffer.wrap("닉네임을 입력해주세요: ".getBytes());

						nextClient.write(buffer);
					}
				}
			} catch (IOException e) {
				System.err.println("클라이언트 연결 종료 중 예외: " + e.getMessage());
				try {
					clientChannel.close();
				} catch (IOException e1) {
					System.err.println("clientChannel close() 중 예외 발생 " + e.getMessage());
					e1.printStackTrace();
				}
			} finally {
				System.err.println("waiting Queue : " + waitingQueue);
			}
		} else { // clientChannel == null인 경우
			System.out.println("socketChannel is null");
		}
	}

	// 서버 소켓 채널 연결 수락 메서드
	private void acceptConnection(SelectionKey key) throws IOException {
		// 서버 소켓 채널에서 클라이언트 연결 수락
		ServerSocketChannel serverChannel = (ServerSocketChannel) key.channel();
		// Selector는 Accept이벤트를 감지하게 된다.
		SocketChannel clientChannel = serverChannel.accept();
		// 비차단 모드로 설정
		clientChannel.configureBlocking(false);

		// 사이즈를 확인하는 동안에 다른 스레드가 클라이언트를 추가/제거할 수 있기 때문에 동기화
		synchronized (allClient) {
			if (allClient.size() >= MAX_CONN) {
				try {
					if(waitingQueue.size() < SelectorChatServer.MAX_READY) {
						waitingQueue.put(clientChannel);
					}else {
						clientChannel.write(ByteBuffer.wrap("대기열이 가득 찼습니다. 연결종료\n".getBytes()));
						clientChannel.close();
						return;
					}
					System.out.println("클라이언트 연결 대기 : " + clientChannel.getRemoteAddress());
					clientChannel.write(ByteBuffer.wrap("현재 최대 연결 수를 초과했습니다. 대기중\n".getBytes()));
					return;
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		}

		// Selector에 클라이언트 소켓 채널 등록, 읽기 이벤트를 감지
		clientChannel.register(selector, SelectionKey.OP_READ, new Client());
		allClient.add(clientChannel);
		System.out.println("새 클라이언트 연결: " + clientChannel.getRemoteAddress());

		// 대기열에 있던 클라이언트에게 닉네임 입력 요청
		ByteBuffer buffer = ByteBuffer.wrap("닉네임을 입력해주세요: ".getBytes());
		clientChannel.write(buffer);
		buffer.clear();
	}

	// 메시지 읽기 메소드
	private void readMessage(SelectionKey key) throws IOException {
		SocketChannel clientChannel = (SocketChannel) key.channel();
		ByteBuffer buffer = ByteBuffer.allocate(1024);
		int bytesRead = 0;

		try {
			if (clientChannel != null && clientChannel.isOpen()) {
				bytesRead = clientChannel.read(buffer);
			}
		} catch (IOException e) {
			System.out.println("Read 예외 발생 : " + e.getMessage());
			closeClientConnection(key);
			return;
		}

		if (bytesRead == -1) {
			System.out.println("클라이언트 연결이 끊어졌습니다.: " + clientChannel.getRemoteAddress());
			closeClientConnection(key);
			return;
		}

		String message = new String(buffer.array()).trim();

		// 닉네임 설정
		Client client = (Client) key.attachment();
		if (client.isNick()) {
			// 닉네임 중복 처리 부분
			// 닉네임 중복체크와 닉네임 등록을 하는 과정에서 nicknames Set에 대한 접근은 동기화 되어있지만
			// 닉네임 메시지 전송과정에서 동기화 필요
			synchronized (nicknames) {
				if (!nicknames.isEmpty() && nicknames.contains(message)) {
					System.out.println(message + "은 이미 사용중인 닉네임입니다.");
					buffer = ByteBuffer.wrap((message + "은 사용할 수 없는 닉네임입니다. 다시 입력하세요:").getBytes());
					clientChannel.write(buffer); // 클라이언트에게 메시지 전송
					buffer.clear();
				} else {
					client.setNick(message); // 닉네임 저장
					System.out.println("Client set nickname: " + message);
					client.setCheck(); // 닉네임 등록 완료 isNick() = false
					broadcastMessage(clientChannel, message + "님이 입장하셨습니다.\n");
					nicknames.add(message);
				}
			}
			return;
		}

		// "exit" 메시지를 받으면 해당 클라이언트 종료
		if ("exit".equalsIgnoreCase(message)) {
			System.out.println("클라이언트의 종료 요청: " + clientChannel.getRemoteAddress());
			closeClientConnection(key); // 자원해제
			return;
		}

		broadcastMessage(clientChannel, client.getNick() + ": " + message + "\n");
	}

	// 채팅 발송
	private void broadcastMessage(SocketChannel sender, String message) throws IOException {
		// 채팅 발송 도중 새로운 클라이언트가 연결이 추가/제거 될 수 있기 때문에 동기화
		synchronized (allClient) {
			// 모든 연결된 클라이언트에게 메시지를 전송
			for (SocketChannel recipient : allClient) {
				if (recipient != sender) {
					ByteBuffer buffer = ByteBuffer.wrap(message.getBytes());
					recipient.write(buffer); // 클라이언트에게 메시지 전송
				}
			}
		}
	}

	// 메인
	public static void main(String[] args) {
		try {
			// 서버를 지정된 포트에서 시작
			SelectorChatServer server = new SelectorChatServer(12345);
			server.start(); // 서버 실행
		} catch (IOException e) {
			System.err.println("메인함수 스레드 중 예외발생 :" + e.getMessage());
			e.printStackTrace(); // 예외 처리
		}
	}
}