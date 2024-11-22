package selectorchat;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketException;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Queue;
import java.util.Set;
import java.util.concurrent.ConcurrentLinkedQueue;

// 채팅 서버(SelectorChatServer)
public class SelectorChatServer {
	private Selector selector; // Selector 객체: 여러 채널을 관리
	private ServerSocketChannel serverChannel;
	private final static Integer MAX_CONN = 5; // 최대 연결 가능 횟수를 5회로 제한
	private final static Integer MAX_READY = 5; // 대기열 최대 채널 갯수
	
	// 동기화 HashSet 래퍼(채팅 중인 SocketChannel 목록)
	private Set<SocketChannel> ChattingClients = Collections.synchronizedSet(new HashSet<>()); 
	// 스레드 안전한 큐 (대기 중인 클라이언트 목록)
	private Queue<SocketChannel> waitingQueue = new ConcurrentLinkedQueue<>(); 
	// 현재 사용중인 닉네임 중복입력 제거를 위한 동기화 HashSet 래퍼
	private Set<String> nicknames = Collections.synchronizedSet(new HashSet<>());
	

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
			System.err.println("[에러] 서버 생성자 초기화 예외 발생 : " + e.getMessage());
			e.printStackTrace();
			try {
				if (serverChannel != null && serverChannel.isOpen())
					serverChannel.close();
				if (selector != null && selector.isOpen())
					selector.close();
			} catch (IOException e1) {
				System.out.println("[에러] 생성자 자원 해제 중 에러 발생" + e.getMessage());
				e.printStackTrace();
			}
		}
		System.out.println("채팅서버가 시작됩니다.: " + port);
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
						readBroadcastMessage(key);
					}
				} catch (IOException e) {
					System.err.println("[에러] 클라이언트 연결 관련 예외 발생 : " + e.getMessage());
					e.printStackTrace();
					closeClientConnection(key);
				}
				iterator.remove(); // 처리한 키는 제거
			}
		}
	}

	// 클라이언트 연결 종료 및 자원 해제
	private void closeClientConnection(SelectionKey key) {
		SocketChannel clientChannel = (SocketChannel) key.channel();
		if (clientChannel != null) {
			try {
				// 연결된 클라이언트와 닉네임 정보를 제거
				ChattingClients.remove(clientChannel);
				Client removeClient = (Client) key.attachment();
				if (removeClient != null) {
					String nickname = removeClient.getNick();
					nicknames.remove(nickname);
					System.out.println("[알림] 클라이언트 '" + nickname + "'의 연결이 종료되었습니다. (주소: "
							+ clientChannel.getRemoteAddress() + ")");
					System.out.println("[현재 닉네임 목록]: " + nicknames);
				} else {
					System.out.println("[알림] 익명 클라이언트의 연결이 종료되었습니다. (주소: " + clientChannel.getRemoteAddress() + ")");
				}

				// 채널 닫기
				if (clientChannel.isOpen()) {
					clientChannel.close();
				}

				// 대기 큐에서 다음 클라이언트를 처리
				SocketChannel nextClient = waitingQueue.poll();
				if (nextClient != null) {
					nextClient.configureBlocking(false);
					nextClient.register(selector, SelectionKey.OP_READ, new Client());
					ChattingClients.add(nextClient);
					System.out.println("[알림] 대기 중이던 클라이언트가 연결되었습니다. (주소: " + nextClient.getRemoteAddress() + ")");
					// 클라이언트에게 닉네임 입력 요청
					ByteBuffer buffer = ByteBuffer.wrap(("[알림]입장 대기가 끝났습니다. 채팅창에 입장합니다."+System.lineSeparator()+"닉네임을 입력해주세요: ").getBytes());
					nextClient.write(buffer);
				}
			} catch (IOException e) {
				System.err.println("[오류] 대기 중 클라이언트 연결 종료 중 예외 발생: " + e.getMessage());
				e.printStackTrace();
			} finally {
				System.out.println("[현재 대기 중인 클라이언트]: " + waitingQueue);
			}
		} else {
			System.out.println("[경고] 닫으려는 SocketChannel이 null입니다.");
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
		synchronized (ChattingClients) {
			if (ChattingClients.size() >= MAX_CONN) {
				if (waitingQueue.size() < SelectorChatServer.MAX_READY) {
					waitingQueue.offer(clientChannel);
				} else {
					clientChannel.write(ByteBuffer.wrap("[알림]대기열이 가득 찼습니다. 연결종료\n".getBytes()));
					clientChannel.close();
					return;
				}
				System.out.println("[대기]클라이언트 연결 대기 : " + clientChannel.getRemoteAddress());
				clientChannel.write(ByteBuffer.wrap(("[대기]현재 최대 연결 수를 초과했습니다.대기중... 대기번호["+(waitingQueue.size())+"] \n").getBytes()));
				return;
			}
		}

		// Selector에 클라이언트 소켓 채널 등록, 읽기 이벤트를 감지
		clientChannel.register(selector, SelectionKey.OP_READ, new Client());
		ChattingClients.add(clientChannel);
		System.out.println("[연결] 새 클라이언트 연결: " + clientChannel.getRemoteAddress());

		// 대기열에 있던 클라이언트에게 닉네임 입력 요청
		ByteBuffer buffer = ByteBuffer.wrap(("[알림] 채팅창에 입장합니다."+System.lineSeparator() +"닉네임을 입력해주세요: ").getBytes());
		clientChannel.write(buffer);
		buffer.clear();
	}

	// 메시지 읽기 메소드
	private void readBroadcastMessage(SelectionKey key) throws IOException {
	    SocketChannel clientChannel = (SocketChannel) key.channel();
	    ByteBuffer buffer = ByteBuffer.allocate(4096);
	    
	    try {
	        if (clientChannel != null && clientChannel.isOpen()) {
	            int bytesRead = clientChannel.read(buffer);
	            
	            if (bytesRead == -1) {
	                System.out.println("[알림] 클라이언트가 연결을 종료했습니다. (주소: " 
	                                   + clientChannel.getRemoteAddress() + ")");
	                closeClientConnection(key);
	                return;
	            }

	            buffer.flip(); // 데이터를 읽을 준비
	            String message = new String(buffer.array(), 0, bytesRead, StandardCharsets.UTF_8).trim();

	            if (message.length() > 1024) {
	                System.out.println("[경고] 클라이언트가 너무 긴 메시지를 보냈습니다. (주소: " 
	                                   + clientChannel.getRemoteAddress() + ")");
	                ByteBuffer responseBuffer = ByteBuffer.wrap("[알림] 메시지 길이는 최대 1024자로 제한됩니다.".getBytes());
	                clientChannel.write(responseBuffer);
	                return;
	            }

	            Client client = (Client) key.attachment();
	            // 닉네임 설정 처리
	            handleNickname(clientChannel, client, message);

	            if ("exit".equalsIgnoreCase(message)) {
	                System.out.println("[알림] 클라이언트 '" + client.getNick() 
	                                   + "'가 종료를 요청했습니다. (주소: " + clientChannel.getRemoteAddress() + ")");
	                closeClientConnection(key);
	                return;
	            }

	            // 메시지 브로드캐스팅
	            if(!message.equals(client.getNick())) {
	            	broadcastMessage(clientChannel, client.getNick() + ": " + message + "\n");
	            }
	        }
	    } catch (SocketException e) {
	        // 소켓 리셋 예외를 정상적인 종료로 간주
	        System.out.println("[알림] 클라이언트가 연결을 종료했습니다. (주소: " + clientChannel.getRemoteAddress() + ")");
	        closeClientConnection(key);
	    } catch (IOException e) {
	        System.out.println("[오류] 클라이언트 데이터 읽기 중 IO 예외발생. (주소: " + clientChannel.getRemoteAddress() + ")");
	        closeClientConnection(key);
	    }
	}

	
	private void handleNickname(SocketChannel clientChannel, Client client, String message) throws IOException {
		// 닉네임이 설정되어 있지 않다면
		if (client.isNick()) {
			synchronized (nicknames) {
				if (!nicknames.isEmpty() && nicknames.contains(message)) {
					System.out.println("[알림] 닉네임 '" + message + "'은 이미 사용 중입니다.");
					ByteBuffer buffer = ByteBuffer.wrap((message + "은 사용할 수 없는 닉네임입니다. 다시 입력하세요:").getBytes());
					clientChannel.write(buffer);
					buffer.clear();
				} else {
					client.setNick(message);
					System.out.println("[알림] 클라이언트의 닉네임이 '" + message + "'으로 설정되었습니다.");
					client.setCheck();
					broadcastMessage(clientChannel, "[알림]" + message + "님이 입장하셨습니다.\n");
					nicknames.add(message);
				}
			}
		}
	}
	

	// 채팅 발송
	private void broadcastMessage(SocketChannel sender, String message) throws IOException {
		synchronized (ChattingClients) {
			for (SocketChannel recipient : ChattingClients) {
				if (recipient != sender) {
					ByteBuffer buffer = ByteBuffer.wrap(message.getBytes());
					recipient.write(buffer);
				}
			}
		}
	}

	// 메인
	public static void main(String[] args) {
		try {
			SelectorChatServer server = new SelectorChatServer(12345);
			server.start();
		} catch (IOException e) {
			System.err.println("[에러] 메인함수 스레드 중 예외발생 :" + e.getMessage());
			e.printStackTrace();
		}
	}
}
