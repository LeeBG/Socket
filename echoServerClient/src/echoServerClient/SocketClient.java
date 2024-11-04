package echoServerClient;

import java.io.BufferedReader; // 서버로부터 데이터를 읽기 위한 클래스
import java.io.IOException; // 입출력 예외 처리를 위한 클래스
import java.io.InputStreamReader; // 바이트 스트림을 문자 스트림으로 변환하기 위한 클래스
import java.io.PrintWriter; // 서버로 데이터를 전송하기 위한 클래스
import java.net.Socket; // 클라이언트 소켓을 생성하기 위한 클래스
import java.net.UnknownHostException; // 호스트를 찾을 수 없는 경우 발생하는 예외 클래스
import java.util.Scanner; // 사용자 입력을 처리하기 위한 클래스

public class SocketClient {
	private Socket clientSocket; // 클라이언트 소켓
	private PrintWriter printWriter; // 서버로 데이터를 보내기 위한 출력 스트림
	private BufferedReader bufferedReader; // 서버로부터 데이터를 받기 위한 입력 스트림
	private Scanner scanner; // 사용자 입력을 받기 위한 Scanner
	private final int port; // 서버 포트 번호
	
	public static void main(String[] args) {
		new SocketClient(); // SocketClient 객체 생성 및 실행
	}
	
	public SocketClient() {
		System.out.print("포트번호 입력 : ");
		scanner = new Scanner(System.in);
		port = Integer.parseInt(scanner.nextLine());
		init(port); // 초기화 메서드 호출
	}
	
	public void init(int port) {
		try {
			// 지정한 포트로 서버에 연결
			clientSocket = new Socket("localhost", port); 
			System.out.println("Server Connect..."); // 서버에 연결되었음을 알림
			
			// 서버로부터 데이터를 읽기 위한 BufferedReader 초기화
			bufferedReader = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
			// 서버로 데이터 전송을 위한 PrintWriter 초기화 (자동 플러시 비활성화)
			printWriter = new PrintWriter(clientSocket.getOutputStream());
			
			// 사용자 입력을 받기 위한 Scanner 초기화
			scanner = new Scanner(System.in);
			
			String sendData = ""; // 보낼 데이터 초기화
			
			// 'exit' 입력 전까지 또는 100바이트 이하의 데이터가 입력될 때까지 반복
			while(!sendData.equals("exit") && sendData.getBytes().length <= 100) {
				System.out.print("to Server: ");
				System.out.print("Input text [Limit 100byte]: "); // 사용자에게 입력 요청
				sendData = scanner.nextLine(); // 보낼 내용을 입력받음 (next()는 하나의 단어를 입력받음)
				
				// 입력받은 내용을 서버로 전송
				printWriter.println(sendData); // 입력받은 내용을 서버로 전송
				printWriter.flush(); // 내부 버퍼를 플러시하여 데이터 전송

				// 서버로부터 받은 데이터를 출력
				System.out.println("from Server: " + bufferedReader.readLine()); // 서버의 응답을 읽어 출력
			}
			
			System.out.println("Client...end"); // 클라이언트 종료 메시지
		} catch (UnknownHostException e) {
			e.printStackTrace(); // 호스트를 찾을 수 없는 경우 예외 처리
		} catch (IOException e) {
			e.printStackTrace(); // 입출력 예외 처리
		} finally {
			// 자원 해제를 위해 무조건 실행되는 영역
			try {
				if (scanner != null)
					scanner.close(); // Scanner 닫기
				if (clientSocket != null)
					clientSocket.close(); // 소켓 닫기
				if (bufferedReader != null)
					bufferedReader.close(); // BufferedReader 닫기
				if (printWriter != null)
					printWriter.close(); // PrintWriter 닫기
			} catch (IOException e) {
				e.printStackTrace(); // 자원 해제 중 예외 처리
			}
		}
	}
}