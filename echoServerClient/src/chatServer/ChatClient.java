package chatServer;

import java.io.*;
import java.net.*;

public class ChatClient {
    private static final String SERVER_ADDRESS = "192.168.30.215"; // 서버 주소
    private static final int PORT = 12345; // 포트 번호

    public static void main(String[] args) {
        try (Socket socket = new Socket(SERVER_ADDRESS, PORT)) {
            System.out.println("서버에 연결됨...");
            InputStream in = socket.getInputStream();
            OutputStream out = socket.getOutputStream();
            BufferedReader consoleReader = new BufferedReader(new InputStreamReader(System.in));

            // 서버에서 오는 메시지를 수신하는 스레드
            new Thread(() -> {
                byte[] buffer = new byte[1024];
                int bytesRead;
                try {
                    while ((bytesRead = in.read(buffer)) != -1) {
                        String message = new String(buffer, 0, bytesRead);
                        if(message.contains(socket.getLocalAddress()+":"+socket.getLocalPort())) {
                        	message = message.replace(socket.getLocalAddress()+":"+socket.getLocalPort(),"\t\t\t\t나");
                        }
                        System.out.println(message);
                    }
                } catch (IOException e) {
                    System.err.println("메시지 수신 스레드 예외발생 : " + e.getMessage());
                    return;
                }
            }).start();

            // 사용자 입력을 서버로 전송
            String userInput;
            while ((userInput = consoleReader.readLine()) != null) {
                out.write(userInput.getBytes());
                out.flush();
            }
        } catch (IOException e) {
        	System.err.println("Socket에러) "+e.getMessage());
        }
    }
}
