package multiableServerClient;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.NetworkInterface;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MultiableServer { // 다중 접속 서버/클라이언트
    static Map<Integer, Socket> clientSocketMap = new HashMap<>(); // 클라이언트를 번호로 관리하는 해시맵
    private static final int PORT = 12345; // 서버가 수신할 포트 번호
    private static final int MAX_CONNECTION = 5; // 최대 연결 가능한 클라이언트 수
    private int conn_count = 0; // 현재 연결된 클라이언트 수
    private ServerSocket serverSocket; // 서버 소켓 객체
//    private ExecutorService executorService; // 스레드 풀
    
    // 기본 생성자
    public MultiableServer() {
        multiServerStart(); // 서버 시작 및 클라이언트 연결 처리메서드
//        executorService = Executors.newFixedThreadPool(MAX_CONNECTION); // 스레드 풀 생성(미리 생성할 최대 스레드 갯수 설정)
    }

    // 현재 연결된 클라이언트를 콘솔에 출력하는 함수
    public static void showCurrentConnects() {
        System.out.println("clients : " + (clientSocketMap.isEmpty() ? "empty" : ""));
        for (Socket socket : clientSocketMap.values()) {
            if (socket != null && !socket.isClosed()) {
                System.out.println("[" + socket.getRemoteSocketAddress() + "]");
            }
        }
    }

    // 서버 시작 및 클라이언트 연결을 처리하는 메서드
    public void multiServerStart() {
        try {
            serverSocket = new ServerSocket(PORT); // 서버 소켓 생성
            System.out.println("다중 서버 연결을 시작하겠습니다.\n" +
                    "=================================\n" +
                    "ServerIP:" + serverSocket.getInetAddress() +
                    "\nServerport = " + PORT);
            while (true) { // 클라이언트 연결 처리
                try {
                    Socket clientSocket = serverSocket.accept(); // 클라이언트 연결 대기
                    
                    synchronized (clientSocketMap) { // 동기화 블록
                        if (clientSocketMap.size() >= MAX_CONNECTION) {
                            System.out.println("최대 연결 가능한 클라이언트의 갯수를 초과했습니다.");
                            if (!clientSocket.isClosed())
                                clientSocket.close();
                            continue;
                        }
                        
                        conn_count++; // 클라이언트 수 증가
                        clientSocketMap.put(conn_count, clientSocket);
                        showCurrentConnects(); // 현재 연결된 클라이언트 출력
                    }
                    
                    System.out.println("새로운 접속 : [" + conn_count + "]" + clientSocket.getInetAddress() + ":" + clientSocket.getPort());
                    new ClientHandler(clientSocket, conn_count).start(); // 스레드 풀에 작업 제출
                } catch (SocketException e) {
                    System.err.println("while) accept() 도중 연결 문제 발생 : " + e.getMessage());
                } catch (IOException e) {
                    System.err.println("while) Socket " + e.getMessage());
                }
            }
        } catch (UnknownHostException e) {
            System.err.println("Exception!!) Host 이름 및 IP주소 확인불가능한 에러 " + e.getMessage());
        } catch (IOException e) {
            System.err.println("Exception!!) Socket에러 " + e.getMessage());
        } finally {
            // 자원해제
            closeAllResources();
            System.out.println("서버 종료");
        }
    }
    
    // 자원해제
    private void closeAllResources() {
        // 클라이언트 소켓 종료
        synchronized (clientSocketMap) {
            for (Integer key : clientSocketMap.keySet()) {
                try {
                	if(clientSocketMap.get(key) != null) {
                		clientSocketMap.get(key).close(); // 클라이언트 소켓 자원 해제
                	}
                } catch (IOException e) {
                    System.err.println("소켓 종료 중 에러 발생 : " + e.getMessage());
                }
            }
            clientSocketMap.clear(); // 클라이언트 소켓 맵 초기화
        }

        // 서버 소켓 종료
        if (serverSocket != null && !serverSocket.isClosed()) {
            try {
                serverSocket.close();
            } catch (IOException e) {
                System.err.println("서버 소켓 종료 중 에러 발생 : " + e.getMessage());
            }
        }
    }

    public static void main(String[] args) {
        new MultiableServer();
    }
}

class ClientHandler extends Thread { // ClientHandler
    private Socket clientSocket; // 클라이언트 소켓
    private int clientId; // 클라이언트 ID

    public ClientHandler(Socket clientSocket, int clientId) { // 소켓과 Map의 클라이언트 키
        this.clientSocket = clientSocket;
        this.clientId = clientId;
    }
    
    @Override
    public void run() { // 스레드 동작 메서드
        try {
            InputStream input = clientSocket.getInputStream(); // 입력 스트림
            OutputStream output = clientSocket.getOutputStream(); // 출력 스트림
            while (true) {
                String message = readMessage(input);
                if (message == null) break; // 클라이언트가 연결 종료
                System.out.println("클라이언트[" + clientSocket.getRemoteSocketAddress() + "]로부터 수신된 메시지 : " + message);
                sendMessage(output, message);
            }
        } catch (IOException e) {
            System.err.println(" Exception!!) 소켓 처리 중 에러" + e.getMessage());
        } finally {
            closeResources();
        }
    }

    
 // 클라이언트로부터 들어온 메시지 읽기
    private String readMessage(InputStream input) {
        byte[] buffer = new byte[1024]; // 버퍼
        int bytesRead;
        try {
            bytesRead = input.read(buffer);  
            if (bytesRead == -1) return null; // 클라이언트가 연결 종료
            return new String(buffer, 0, bytesRead);
        } catch (IOException e) {
            System.err.println("데이터 수신 문제가 발생했습니다. : " + e.getMessage());
            return null;
        }
    }
    
 // 클라이언트에게 메시지 전송
    private void sendMessage(OutputStream output, String message) {
        try {
            output.write(message.getBytes()); // 데이터 전송
            output.flush();
        } catch (SocketException e) {
            System.err.println("응답 데이터 전송 중 클라이언트 연결 종료)" + e.getMessage());
        } catch (IOException e) {
            System.err.println("데이터 전송 중 오류 발생)" + e.getMessage());
        }
    }
    
    // 자원 해제 메서드
    private void closeResources() {
    	try {
            if (clientSocket != null && !clientSocket.isClosed()) clientSocket.close();
        } catch (IOException e) {
            System.err.println("소켓 종료 중 에러 발생 : " + e.getMessage());
        } finally {
            synchronized (MultiableServer.class) { // 동기화
                MultiableServer.clientSocketMap.remove(clientId); // Map에서 제거
                System.out.println("클라이언트 [" + clientId + "] 연결이 종료되었습니다.");
                MultiableServer.showCurrentConnects(); // 연결 상태 재확인
            }
        }
    }
}