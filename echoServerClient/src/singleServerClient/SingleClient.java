package singleServerClient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class SingleClient {

    public static void main(String[] args) {
        String serverAddress = "localhost"; // 서버 주소
        int port = 12345; // 서버 포트 번호

        try (Socket socket = new Socket(serverAddress, port)) {
            // 서버와의 입출력 스트림 생성
            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));

            System.out.println("서버에 연결되었습니다. 메시지를 입력하세요:");

            String userMessage;
            // 사용자로부터 메시지를 입력받아 서버로 전송
            while ((userMessage = userInput.readLine()) != null) {
                out.println(userMessage); // 서버로 메시지 전송
                String response = in.readLine(); // 서버로부터 에코 응답 수신
                System.out.println("서버 응답: " + response);
            }

        } catch (IOException e) {
            System.out.println("서버와의 연결 중 오류 발생: " + e.getMessage());
        }
    }
}