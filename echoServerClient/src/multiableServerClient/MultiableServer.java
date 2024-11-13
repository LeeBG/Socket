package multiableServerClient;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.LinkedBlockingQueue;

public class MultiableServer { // 다중 접속 서버/클라이언트
	private static final int PORT = 12345; // 서버가 수신할 포트 번호
	private static final int MAX_CONNECTION = 5; // 최대 연결 가능한 클라이언트 수
	private static final ConcurrentHashMap<Integer, Socket> clientSocketMap = new ConcurrentHashMap<>(); // 클라이언트 관리용 맵
	private static final ConcurrentHashMap<Integer, Boolean> availableClientIds = new ConcurrentHashMap<>(); // 사용 가능한
																											
	private static final BlockingQueue<Socket> waitingQueue = new LinkedBlockingQueue<>(); // 블로킹 큐를 사용한 초과 클라이언트 대기 큐
	private ServerSocket serverSocket; // 서버 소켓 객체

	// 서버 시작 및 클라이언트 연결을 처리하는 메서드
	public void multiServerStart() {
		try {
			serverSocket = new ServerSocket(PORT); // 서버 소켓 생성
			System.out.println("다중 서버 연결을 시작하겠습니다.\n" + "=================================\n" + "ServerIP: "
					+ serverSocket.getInetAddress() + "\nServerPort: " + PORT);

			// 빈 ID 관리 초기화
			for (int i = 1; i <= MAX_CONNECTION; i++) {
				availableClientIds.put(i, true); // 모든 ID는 처음에 사용 가능 (id = 1~5번 사용가능)
			}

			// 대기열 처리기 스레드 시작
			new Thread(new WaitingQueueHandler()).start();

			while (true) { // 클라이언트 연결 처리
				try {
					Socket clientSocket = serverSocket.accept(); // 클라이언트 연결 대기
					Integer availableId = getAvailableClientId();
					
					// 최대 연결 갯수 초과 이전
					if (clientSocketMap.size() < MAX_CONNECTION) {
						// 연결 가능 시 바로 처리
						availableId = getAvailableClientId(); // 빈 ID 찾기

						// 해당 ID로 클라이언트 연결 관리
						clientSocketMap.put(availableId, clientSocket);
						availableClientIds.put(availableId, false); // 해당 ID는 사용 중으로 설정(false는 사용중)
						new ClientHandler(clientSocket, availableId);
						System.out.println("새로운 접속 : [" + availableId + "]" + clientSocket.getInetAddress() + ":"
								+ clientSocket.getPort());
					} else {
						// 초과된 연결은 대기열에 추가
						waitingQueue.offer(clientSocket);
						System.out.println("클라이언트가 대기열에 추가되었습니다.");
					}
					showCurrentConnects(); // 현재 연결된 클라이언트 출력
				} catch (IOException e) {
					System.err.println("클라이언트 연결 처리 중 에러 발생: " + e.getMessage());
				}
			}
		} catch (IOException e) {
			System.err.println("서버 소켓 생성 중 에러 발생: " + e.getMessage());
		} finally {
			closeAllResources(); // 모든자원해제
			System.out.println("서버 종료");
		}
	}

	// 사용 가능한 클라이언트 ID를 찾는 메서드
	private Integer getAvailableClientId() {
		for (Integer clientId : availableClientIds.keySet()) {
			if (availableClientIds.get(clientId)) {
				return clientId; // 사용 가능한 ID 반환
			}
		}
		return null; // 더 이상 사용 가능한 ID가 없음
	}

	// 현재 연결된 클라이언트를 콘솔에 출력하는 함수
	public static void showCurrentConnects() {
		System.out.println("현재 연결된 클라이언트:");
		if (clientSocketMap.isEmpty()) {
			System.out.println("없음");
		} else {
			clientSocketMap.values().forEach(socket -> {
				if (socket != null && !socket.isClosed()) {
					System.out.println("[" + socket.getRemoteSocketAddress() + "]");
				}
			});
		}
	}

	// 자원 해제
	private void closeAllResources() {
		try {
			// 클라이언트 소켓 종료
			for (Socket socket : clientSocketMap.values()) {
				if (socket != null && !socket.isClosed()) {
					socket.close();
				}
			}
			clientSocketMap.clear(); // 클라이언트 소켓 맵 초기화

			// 서버 소켓 종료
			if (serverSocket != null && !serverSocket.isClosed()) {
				serverSocket.close();
			}
		} catch (IOException e) {
			System.err.println("자원 해제 중 에러 발생: " + e.getMessage());
		}
	}

	public static void main(String[] args) {
		new MultiableServer().multiServerStart();
	}

	public static int getPort() {
		return PORT;
	}

	public static int getMaxConnection() {
		return MAX_CONNECTION;
	}

	public static BlockingQueue<Socket> getWaitingqueue() {
		return waitingQueue;
	}

	public ServerSocket getServerSocket() {
		return serverSocket;
	}

	public static ConcurrentHashMap<Integer, Socket> getClientsocketmap() {
		return clientSocketMap;
	}

	public static ConcurrentHashMap<Integer, Boolean> getAvailableclientids() {
		return availableClientIds;
	}
}

class ClientHandler {
    private final Socket clientSocket;
    private final int clientId;
    private final BlockingQueue<String> messageQueue = new LinkedBlockingQueue<>(); // 송신 대기열

    public ClientHandler(Socket clientSocket, int clientId) {
        this.clientSocket = clientSocket;
        this.clientId = clientId;

        // 수신 스레드와 송신 스레드 시작
        new Thread(new ReceiverThread()).start();
        new Thread(new SenderThread()).start();
    }

    // 수신 스레드(하나의 
    private class ReceiverThread extends Thread {
        @Override
        public void run() {
            try (InputStream input = clientSocket.getInputStream()) {
                String message;
                while ((message = readMessage(input)) != null) {
                    System.out.println("클라이언트[" + clientId + "]로부터 수신된 메시지: " + message);
                    messageQueue.offer(message); // 수신 메시지를 송신 대기열에 추가
                }
            } catch (IOException e) {
                System.err.println("수신 스레드에서 에러 발생: " + e.getMessage());
            } finally {
                closeResources();
            }
        }
        
        
        // 클라이언트 메시지 읽기
        private String readMessage(InputStream input){
            byte[] buffer = new byte[1024];
            int bytesRead;
			try {
				bytesRead = input.read(buffer);
				 if (bytesRead == -1) return null;
		            return new String(buffer, 0, bytesRead);
			} catch (IOException e) {
				System.err.println("readMessage에러) " + e.getMessage());
			}
			return null;
        }
    }

    // 송신 스레드
    private class SenderThread extends Thread {
        @Override
        public void run() {
            try (OutputStream output = clientSocket.getOutputStream()) {
                while (true) {
                    String message = messageQueue.take(); // 대기열에서 메시지 꺼내기
                    sendMessage(output, message);
                }
            } catch (IOException | InterruptedException e) {
                System.err.println("송신 스레드에서 에러 발생: " + e.getMessage());
            } finally {
                closeResources();
            }
        }

        private void sendMessage(OutputStream output, String message) throws IOException {
            output.write(message.getBytes());
            output.flush();
        }
    }

    private synchronized void closeResources() {
        try {
            if (clientSocket != null && !clientSocket.isClosed()) {
                clientSocket.close();
            }
            System.out.println("클라이언트 [" + clientId + "] 연결 종료됨.");
            MultiableServer.getClientsocketmap().remove(clientId);
            MultiableServer.getAvailableclientids().put(clientId,true);
        } catch (IOException e) {
            System.err.println("자원 해제 중 에러 발생: " + e.getMessage());
        }
    }
}


//대기열 처리기 클래스
class WaitingQueueHandler extends Thread {
	@Override
	public void run() {
		while (true) {
			try {
				// 최대 갯수보다 작으면 대기큐에서 연결 추가
				if (MultiableServer.getClientsocketmap().size() < MultiableServer.getMaxConnection()) {
					// 큐에서 poll
					Socket clientSocket = MultiableServer.getWaitingqueue().poll();
					if (clientSocket != null) {
						Integer availableId = getAvailableClientId();
						if (availableId != null) {
							MultiableServer.getClientsocketmap().put(availableId, clientSocket);
							MultiableServer.getAvailableclientids().put(availableId, false);
							new ClientHandler(clientSocket, availableId);
							System.out.println("대기열에서 클라이언트 [" + availableId + "] 연결 처리됨: "
									+ clientSocket.getInetAddress() + ":" + clientSocket.getPort());
							MultiableServer.showCurrentConnects();
						}
					}
				}
				Thread.sleep(100); // 짧은 대기 시간 추가
			} catch (InterruptedException e) {
				System.err.println("대기열 처리 중 인터럽트 발생: " + e.getMessage());
			}
		}
	}

	// 사용가능 ClientID를 찾는 메서드
	private Integer getAvailableClientId() {
		for (Integer clientId : MultiableServer.getAvailableclientids().keySet()) {
			if (MultiableServer.getAvailableclientids().get(clientId)) {
				return clientId;
			}
		}
		return null;
	}
}
