package selectorchat;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketException;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.util.Scanner;

public class SelectorChatClient {
	public static void main(String[] args) {
		Thread systemIn;
		Thread systemOut;

		// 서버 IP와 포트로 연결되는 소켓채널 생성(I/O)
		try (SocketChannel socket = SocketChannel.open(new InetSocketAddress("192.168.30.215", 12345))) {

			// 출력을 담당할 스레드 생성 및 실행
			systemOut = new Thread(new SystemOut(socket));
			// 입력을 담당할 스레드 생성 및 실행
			systemIn = new Thread(new SystemIn(socket));

			systemIn.start();
			systemOut.start();

			// 메인 스레드가 두 스레드가 종료될 때까지 대기
			try {
				systemIn.join();
				systemOut.join();
			} catch (InterruptedException e) {
				System.err.println("Thread Join 에러" + e.getMessage());
				e.printStackTrace();
			}
		} catch (IOException e) {
			System.out.println("서버와의 연결이 종료되었습니다." + e.getMessage());
			e.printStackTrace();
		}
	}
}

//출력을 담당하는 스레드
class SystemOut implements Runnable {
	private SocketChannel socketChannel;

	SystemOut(SocketChannel socketChannel) {
		this.socketChannel = socketChannel;
	}

	@Override
	public void run() {
		ByteBuffer buf = ByteBuffer.allocate(1024); // JVM의 힙 영역에 버퍼를 할당합니다.
		try {
			while (socketChannel != null) {
				buf.clear();
				int bytesRead = socketChannel.read(buf);
				if (bytesRead == -1) {
					break; // 서버가 연결을 종료한 경우
				}
				buf.flip(); // 버퍼를 읽기 모드로 전환
				String receiveMessage = new String(buf.array(), 0, bytesRead); // 받은 메시지
				System.out.print(receiveMessage);
			}
		} catch (SocketException e) {
			System.out.println("서버 연결 해제 " + e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			System.out.println("출력 중 에러 발생 " + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				socketChannel.close();
			} catch (IOException e) {
				System.err.println("입력 스레드 자원해제 중 예외발생 :" + e.getMessage());
				e.printStackTrace();
			}
		}
	}
}

//입력을 담당하는 클래스
class SystemIn implements Runnable {
	private SocketChannel socketChannel;

	SystemIn(SocketChannel socketChannel) {
		this.socketChannel = socketChannel;
	}

	@Override
	public void run() {

		ByteBuffer buf = ByteBuffer.allocate(1024);
		String sendMessage = "";
		try (Scanner scanner = new Scanner(System.in);) {
			while (socketChannel != null) {
				sendMessage = scanner.nextLine();
				if (sendMessage.equalsIgnoreCase("exit")) {
					break; // "exit" 입력 시 종료
				}
				buf = ByteBuffer.wrap(sendMessage.getBytes());
				socketChannel.write(buf);
				buf.clear();
			}
		} catch (IOException e) {
			System.err.println("채팅 불가. " + e.getMessage());
		} finally {
			try {
				System.out.println("입력도중 연결이 끊어졌습니다.");
				socketChannel.close();
			} catch (IOException e) {
				System.err.println("입력스레드 자원 해제 중 예외발생 :" + e.getMessage());
			}
		}
	}
}
