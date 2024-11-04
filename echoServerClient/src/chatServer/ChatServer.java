package chatServer;

import java.io.*;
import java.net.*;
import java.util.*;

public class ChatServer {
    private static final int PORT = 12345; // 포트 번호
    private static Set<OutputStream> clientOutputs = Collections.synchronizedSet(new HashSet<>()); // 클라이언트 출력 스트림 관리

    public static void main(String[] args) throws UnknownHostException {
        System.out.println("채팅 채팅 서버 시작...");
        System.out.println("서버 IP : " + InetAddress.getLocalHost().getHostAddress()+":"+PORT);
        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            while (true) {
            	Socket socket = serverSocket.accept();
            	System.out.println(socket.getInetAddress() + ":"+socket.getPort()+"님이 접속했습니다.");
                new ClientHandler(socket).start(); // 클라이언트 연결 시 핸들러 스레드 시작
            }
        } catch (IOException e) {
        	System.err.println("main() 중 예외발생)" + e.getMessage());
        } finally {
        	if(!clientOutputs.isEmpty())
        		clientOutputs.clear();
        }
    }

    // 클라이언트를 처리하는 내부 클래스
    private static class ClientHandler extends Thread {
        private Socket socket;
        private OutputStream out;
        private InputStream in;

        public ClientHandler(Socket socket) {
            this.socket = socket;
        }

        public void run() {
            try {
                in = socket.getInputStream();
                out = socket.getOutputStream();
                synchronized (clientOutputs) {
                    clientOutputs.add(out); // 새 클라이언트 추가
                }

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    String message = new String(buffer, 0, bytesRead);
                    message = socket.getInetAddress()+":"+socket.getPort()+":"+message;
                    System.out.println("\n" + message + "\n");
                    broadcast(message.getBytes()); // 메시지 브로드캐스트
                }
            } catch (IOException e) {
                System.err.println("클라이언트 소켓 종료 : " + e.getMessage());
            } finally {
                try {
                	System.out.println(socket.getInetAddress()+":"+socket.getPort()+"의 접속을 종료했습니다.");
                    socket.close();
                } catch (IOException e) {
                    System.err.println("run() 중 예외발생)" + e.getMessage());
                }
                synchronized (clientOutputs) {
                    clientOutputs.remove(out); // 클라이언트 제거
                }
            }
        }

        // 모든 클라이언트에게 메시지 전송
        private void broadcast(byte[] message) {
            synchronized (clientOutputs) {
                for (OutputStream writer : clientOutputs) {
                    try {
                        writer.write(message);
                        writer.flush();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}
