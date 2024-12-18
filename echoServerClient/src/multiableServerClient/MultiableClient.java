package multiableServerClient;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Scanner;

public class MultiableClient {
    private final String serverAddress = "192.168.30.215"; // 원격지 서버의 주소
    private static final int PORT = 12345; // 고정 PORT 번호
    private Socket clientSocket; // 클라이언트 소켓
    private String userInputData; // 사용자 입력 데이터를 저장할 문자열 변수
    private InputStream input; // 입력스트림
    private OutputStream output; // 출력스트림
    private Scanner scanner; // 사용자 입력을 받기 위한 스캐너

    // 생성자: 클라이언트 소켓을 생성
    public MultiableClient() {
        createClientSocket(); // 클라이언트 소켓 생성 및 통신
    }

    // 클라이언트 소켓 생성 및 연결 처리
    public void createClientSocket() {
        try {
            System.out.println("=== 클라이언트 실행 ===");
            System.out.println(
                    "연결 시도중... \n서버: " + serverAddress + "<===> 클라이언트: " + InetAddress.getLocalHost().getHostAddress());
            // 서버에 소켓 연결
            clientSocket = new Socket(serverAddress, PORT);
            try {
                // 입력 및 출력 스트림 초기화
                input = clientSocket.getInputStream();
                output = clientSocket.getOutputStream();
                scanner = new Scanner(System.in); // 사용자 입력을 위한 스캐너 초기화

                byte[] buffer = new byte[1024]; // 서버로부터 수신할 데이터 버퍼
                int bytesRead; // 읽은 바이트 수

                // 무한 루프: 사용자 입력을 처리
                while (true) {
                    System.out.print("서버와 연결되었습니다. 메시지를 입력하세요 >> ");
                    userInputData = scanner.nextLine(); // 사용자 입력 받기
                    if (userInputData.equalsIgnoreCase("exit")) { // "exit" 입력 시 종료
                        break;
                    }
                    
                    // 사용자 입력을 서버로 전송
                    output.write(userInputData.getBytes());
                    output.flush(); // 출력 스트림을 강제로 비우기

                    // 서버로부터 응답 받기
                    bytesRead = input.read(buffer); // 데이터를 읽고
                    
                    if (bytesRead == -1) { // 읽은 바이트 수가 -1인 경우
                        System.out.println("서버가 연결을 종료했습니다."); // 연결 종료 메시지 출력
                        break;
                    }
                    
                    String responseData = new String(buffer, 0, bytesRead); // 바이트 배열을 문자열로 변환
                    System.out.println("서버로부터 받은 응답 메시지 : " + responseData); // 응답 출력
                }
            } catch (SocketException e) {
                System.out.println("연결가능 소켓 갯수 초과 에러 : " + e.getMessage());
            } catch (IOException e) {
                System.err.println("스트림 처리 중 문제 발생: " + e.getMessage());
            }
        } catch (UnknownHostException e) {
            System.err.println("네트워크 연결 문제입니다: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("소켓 관련 문제입니다: " + e.getMessage());
        } finally {
            closeResources(); // 자원 해제 메서드
        }
    }

    // 메인 메서드: 클라이언트 프로그램 시작점
    public static void main(String[] args) {
        new MultiableClient(); // 클라이언트 인스턴스 생성
    }

    // 자원 해제 메서드
    private void closeResources() {
        if (scanner != null) {
            scanner.close(); // 스캐너 닫기
        }
        try {
            if (output != null) {
                output.close(); // 출력 스트림 닫기
            }
            if (input != null) {
                input.close(); // 입력 스트림 닫기
            }
            if (clientSocket != null && !clientSocket.isClosed()) {
                clientSocket.close(); // 클라이언트 소켓 닫기
            }
        } catch (IOException e) {
            System.err.println("자원 해제 중 문제 발생: " + e.getMessage());
        }
        System.out.println("클라이언트 종료"); // 종료 메시지 출력
    }
}
