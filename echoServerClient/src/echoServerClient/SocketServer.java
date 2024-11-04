package echoServerClient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;

public class SocketServer {
	private ServerSocket serverSocket; 				// 서버 소켓
	private BufferedReader bufferedReader; 			// 클라이언트로부터 받은 메시지를 읽기 위한 버퍼 메모리
	private PrintWriter printWriter; 				// 클라이언트에게 메시지를 전달하는 출력 스트림
	private Socket clientSocket; 					// 클라이언트 소켓
	private final int port; 						// 포트번호
	private String readData; 						// 클라이언트로부터 읽을 데이터를 저장할 변수
	private Scanner scanner;
	
	public SocketServer() { 						// 서버 생성자
		System.out.print("포트번호 입력 : ");
		scanner = new Scanner(System.in);
		port = Integer.parseInt(scanner.nextLine());
		init(port); 								// PORT번호를 사용한 에코서버를 오픈하는 함수
	}

	public void init(int port) {
		try {
			serverSocket = new ServerSocket(port); // 현재 IP로 port를 포트번호로 사용하여 서버를 오픈
			System.out.println("Server is ready on port: " + port);
			System.out.println("Waiting for client connection...");

			clientSocket = serverSocket.accept(); // 클라이언트의 연결 요청을 수락
			System.out.println("Client connected from: " + clientSocket.getInetAddress().toString()); // 연결된 클라이언트
																										// IP 주소 확인
			bufferedReader = new BufferedReader(new InputStreamReader(clientSocket.getInputStream())); // 클라이언트로부터
																										// 데이터를 읽기
																										// 위한 준비
			printWriter = new PrintWriter(clientSocket.getOutputStream(), true); // 자동 flush를 활성화하여 메시지를 즉시 전송

			while ((readData = bufferedReader.readLine()) != null) {
				System.out.println("from Client> " + readData);
				printWriter.println(readData); // 읽은 메시지를 그대로 클라이언트에 다시 보냄
			}
			System.out.println("Client disconnected.");

		} catch (IOException e) {
			System.err.println("Port " + port + " is already in use. Trying next port...");
            port++; // 포트 번호를 증가시켜 재시도
		} finally {
			// 자원 해제
			try {
				if(scanner != null) 
					scanner.close();
				if (bufferedReader != null)
					bufferedReader.close();
				if (printWriter != null)
					printWriter.close();
				if (clientSocket != null)
					clientSocket.close();
				if (serverSocket != null)
					serverSocket.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	public static void main(String[] args) {
		new SocketServer();
	}
}