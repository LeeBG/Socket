package chatServer;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.Scanner;

public class ChatClient {
    private static final String SERVER_IP = "192.168.30.215"; // 서버 IP
    private static final int SERVER_PORT = 12345; // 서버 포트
    private Socket socket;
    private OutputStream output;
    private InputStream input;
    
    // 메인스레드
    public static void main(String[] args) {
        ChatClient client = new ChatClient();
        client.client_main();
    }
    
    public void client_main() {
        try {
            // 서버에 연결
            socket = new Socket(SERVER_IP, SERVER_PORT);
            System.out.println("서버에 연결되었습니다: " + SERVER_IP + ":" + SERVER_PORT);

            output = socket.getOutputStream();
            input = socket.getInputStream();

            // 메시지 송신 스레드 시작
            new Thread(new ClientSender()).start();
            // 메시지 수신 스레드 시작
            new Thread(new ClientReceiver()).start();
            
        } catch (IOException e) {
            System.err.println("서버에 연결 실패: " + e.getMessage());
            closeResources();
        }
    }

    // 서버로 메시지 전송
    private void sendMessage(String message) {
        try {
            output.write(message.getBytes());
            output.flush();
        } catch (IOException e) {
            System.err.println("메시지 전송 중 오류 발생: " + e.getMessage());
            closeResources();
        }
    }

    // 자원 해제
    private void closeResources() {
        try {
            if (input != null) input.close();
            if (output != null) output.close();
            if (socket != null && !socket.isClosed()) socket.close();
            System.out.println("클라이언트 연결 종료됨.");
        } catch (IOException e) {
            System.err.println("자원 해제 중 에러 발생: " + e.getMessage());
        }
    }

    // 메시지 송신 스레드
    private class ClientSender extends Thread {
        @Override
        public void run() {
            Scanner scanner = new Scanner(System.in);
            try {
                while (true) {
                    System.out.print("입력: ");
                    String message = scanner.nextLine();
                    if(message.equals(null) || message.equalsIgnoreCase("exit")) {
                    	break;
                    }
                    sendMessage(message);
                }
            }catch (Exception e) {
				System.err.println("입력예외 : "+ e.getMessage());
			} finally {
				if(scanner!=null)
					scanner.close();
                closeResources();
            }
        }
    }

    // 메시지 수신 스레드
    private class ClientReceiver extends Thread {
        @Override
        public void run() {
            try {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    String message = new String(buffer, 0, bytesRead);
                    System.out.println("");
                    System.out.println(message);
                }
            } catch (IOException e) {
                System.err.println("메시지 수신 중 오류 발생: " + e.getMessage());
            }finally {
				closeResources();
			}
        }
    }
}