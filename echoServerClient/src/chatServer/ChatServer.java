package chatServer;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.LinkedBlockingQueue;

public class ChatServer { // 다중 접속 서버/클라이언트
	private static final int PORT = 12345; // 서버가 수신할 포트 번호
	private static final int MAX_CONNECTION = 5; // 최대 연결 가능한 클라이언트 수
	private static final ConcurrentHashMap<Integer, ServerReceiverSender> clientHandlers = new ConcurrentHashMap<>(); // 클라이언트 스레드 관리용 맵
	private static final ConcurrentHashMap<Integer, Boolean> availableClientIds = new ConcurrentHashMap<>(); // 사용 가능한
	private ServerSocket serverSocket; // 서버 소켓 객체
	
	public ServerSocket getServerSocket() {
		return serverSocket;
	}

	public static int getMaxConnection() {
		return MAX_CONNECTION;
	}

	public static ConcurrentHashMap<Integer, ServerReceiverSender> getClienthandlers() {
		return clientHandlers;
	}

	public static ConcurrentHashMap<Integer, Boolean> getAvailableclientids() {
		return availableClientIds;
	}
	
	// 서버 시작 및 클라이언트 연결을 처리하는 메서드
	public void serverStart() {
		try {
			serverSocket = new ServerSocket(PORT); // 서버 소켓 생성
			System.out.println("다중 서버 연결을 시작하겠습니다.\n" + "=================================");

			// 빈 ID 관리 초기화
			for (int i = 1; i <= MAX_CONNECTION; i++) {
				availableClientIds.put(i, true); // 모든 ID는 처음에 사용 가능 (id = 1~5번 사용가능)
			}

			
			while (true) { // 클라이언트 연결 처리
				try {
					Socket clientSocket = serverSocket.accept(); // 클라이언트 연결 대기
					System.out.println("serverIp:"+clientSocket.getLocalAddress()+":"+clientSocket.getLocalPort()+"\n");
					ServerReceiverSender handler = null;
					// 최대 연결 갯수 초과 이전
					if (clientHandlers.size() < MAX_CONNECTION) {
						Integer availableId = getAvailableClientId();
						handler = new ServerReceiverSender(clientSocket, availableId);
						clientHandlers.put(availableId, handler);
						availableClientIds.put(availableId, false); // 해당 ID는 사용 중으로 설정(false는 사용중)
						System.out.println("새로운 접속 : [" + availableId + "]" + clientSocket.getInetAddress() + ":"
								+ clientSocket.getPort());
					} else {
						System.out.println("연결 갯수 초과");
						continue;
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
		if (clientHandlers.isEmpty()) {
			System.out.println("없음");
		} else {
			clientHandlers.values().forEach(handler -> {
				Socket socket = handler.getClientSocket();
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
			for (ServerReceiverSender handler : clientHandlers.values()) {
				handler.closeResources();
			}
			clientHandlers.clear(); // 클라이언트 소켓 맵 초기화

			// 서버 소켓 종료
			if (serverSocket != null && !serverSocket.isClosed()) {
				serverSocket.close();
			}
		} catch (IOException e) {
			System.err.println("자원 해제 중 에러 발생: " + e.getMessage());
		}
	}

	// 메시지 브로드캐스트
	public static void broadcastMessage(String message, int senderId) {
		clientHandlers.forEach((clientId, handler) -> {
			handler.sendMessageToClient(message);
		});
	}

	public static void main(String[] args) {
		new ChatServer().serverStart();
	}
}

class ServerReceiverSender {
    private final Socket clientSocket;
    private final int clientId;
    private final BlockingQueue<String> messageQueue = new LinkedBlockingQueue<>(); // 송신 대기열

    public ServerReceiverSender(Socket clientSocket, int clientId) {
        this.clientSocket = clientSocket;
        this.clientId = clientId;

        // 수신 스레드 // 메시지 큐
        new Thread(new ReceiverThread()).start();
        
        // 송신 스레드
        new Thread(new SenderThread()).start();
    }

    public Socket getClientSocket() {
        return clientSocket;
    }

    // 수신 스레드
    private class ReceiverThread extends Thread {
        @Override
        public void run() {
            try (InputStream input = clientSocket.getInputStream()) {
                String message;
                while ((message = readMessage(input)) != null) {
                    System.out.println("클라이언트[" + clientId + "]로부터 수신된 메시지: " + message);
                    ChatServer.broadcastMessage("클라이언트[" + clientId + "]:" + message, clientId); // 다른 클라이언트들에게 브로드캐스트
                    if(message.equalsIgnoreCase("exit")) {
                		System.out.println("["+clientId+"]"+"클라이언트 접속 종료");
                		break;
                	}
                }
            } catch (IOException e) {
                System.err.println("수신 스레드에서 에러 발생: " + e.getMessage());
            } finally {
                closeResources();
            }
        }

        private String readMessage(InputStream input) throws IOException {
            byte[] buffer = new byte[1024];
            int bytesRead = input.read(buffer);
            return (bytesRead == -1) ? null : new String(buffer, 0, bytesRead);
        }
    }

//
    private class SenderThread extends Thread {
        @Override
        public void run() {
            try (OutputStream output = clientSocket.getOutputStream()) {
                while (true) {
                    String message = messageQueue.take(); // 대기열에서 메시지 꺼내기
                    sendMessage(output, message);
                    Thread.sleep(100);
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

    public void sendMessageToClient(String message) {
    	if(!message.equalsIgnoreCase("exit"))
    		messageQueue.offer(message); // 메시지를 송신 대기열에 추가
    }

    public synchronized void closeResources() {
        try {
            if (clientSocket != null && !clientSocket.isClosed()) {
                clientSocket.close();
            }
            System.out.println("클라이언트 [" + clientId + "] 연결 종료됨.");
            ChatServer.getAvailableclientids().put(clientId, true); // ID를 다시 사용 가능으로 설정
            ChatServer.getClienthandlers().remove(clientId);
            ChatServer.showCurrentConnects();
        } catch (IOException e) {
            System.err.println("자원 해제 중 에러 발생: " + e.getMessage());
        }
    }
}


