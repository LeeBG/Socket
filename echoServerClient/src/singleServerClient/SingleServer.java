package singleServerClient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

public class SingleServer {

    public static void main(String[] args) {
        int port = 12345; // 사용할 포트 번호
        try (ServerSocket serverSocket = new ServerSocket(port)) {
            System.out.println("서버가 시작되었습니다. 클라이언트를 기다립니다...");

            while (true) {
                try (Socket clientSocket = serverSocket.accept()) {
                    System.out.println("클라이언트가 접속했습니다: " + clientSocket.getInetAddress());

                    // 클라이언트와의 입출력 스트림 생성
                    PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);
                    BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));

                    String inputLine;
                    // 클라이언트로부터 메시지를 수신하고 에코 응답
                    while ((inputLine = in.readLine()) != null) {
                    	if(inputLine.equalsIgnoreCase("exit")) {
                    		System.out.println("접속 종료");
                    		clientSocket.close(); // 닫힘
                    	}
                        System.out.println("클라이언트로부터 수신: " + inputLine);
                        out.println(inputLine); // 에코 응답
                    }
                } catch (IOException e) {
                    System.out.println("클라이언트와의 통신 중 오류 발생: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.out.println("서버 소켓을 생성할 수 없습니다: " + e.getMessage());
        }
    }
}


