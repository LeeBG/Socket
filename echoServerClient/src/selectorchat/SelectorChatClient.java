package selectorchat;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

public class SelectorChatClient {
	public static volatile boolean isNickNameInput = true; // 닉네임 입력 상태 플래그
    public static void main(String[] args) {
        try (SocketChannel socket = SocketChannel.open(new InetSocketAddress("127.0.0.1", 12345))) {
            Thread systemOut = new Thread(new ReceiveChat(socket));
            Thread systemIn = new Thread(new SendChat(socket));

            systemOut.start();
            systemIn.start();

            systemOut.join();
            systemIn.join();
        } catch (IOException e) {
            System.err.println("[에러] 서버와의 연결 실패: " + e.getMessage());
        } catch (InterruptedException e) {
            System.err.println("[에러] 스레드 종료 대기 중 오류 발생: " + e.getMessage());
        }
    }
}

// 출력을 담당하는 스레드
class ReceiveChat implements Runnable {
    private final SocketChannel socketChannel;

    ReceiveChat(SocketChannel socketChannel) {
        this.socketChannel = socketChannel;
    }

    @Override
    public void run() {
        ByteBuffer buffer = ByteBuffer.allocate(4096);
        try {
            while (socketChannel != null && socketChannel.isOpen()) {
                buffer.clear();
                int bytesRead = socketChannel.read(buffer);
                if (bytesRead == -1) {
                    // 서버가 소켓을 닫은 경우 정상적으로 종료
                    System.out.println("[알림] 서버 연결이 종료되었습니다.");
                    break;
                }

                buffer.flip();
                String receivedMessage = new String(buffer.array(), 0, bytesRead, StandardCharsets.UTF_8);
                receivedMessage = receivedMessage.replace("\\n", "\n").replace("\\r", "\r");
                if(receivedMessage.contains("[알림]") ||!SelectorChatClient.isNickNameInput) {
                	 System.out.print(receivedMessage);
                }
            }
        } catch (IOException e) {
            // Null-safe 예외 메시지 처리
            String errorMessage = e.getMessage() != null ? e.getMessage() : "서버와 연결이 종료되었습니다.";
            if (errorMessage.equalsIgnoreCase("서버와 연결이 종료되었습니다.")) {
                System.out.println("[알림] 서버와의 연결이 종료되었습니다.");
            } else {
                System.out.println("[에러] 출력 중 오류 발생: " + errorMessage);
            }
        } finally {
            closeChannel();
        }
    }


    private void closeChannel() {
        try {
            if (socketChannel.isOpen()) {
                socketChannel.close();
            }
        } catch (IOException e) {
            System.err.println("[에러] 출력 스레드 자원 해제 중 오류 발생: " + e.getMessage());
        }
    }
}

// 입력을 담당하는 스레드
class SendChat implements Runnable {
    private final SocketChannel socketChannel;

    SendChat(SocketChannel socketChannel) {
        this.socketChannel = socketChannel;
    }

    @Override
    public void run() {
    	ByteBuffer buffer = ByteBuffer.allocate(4096);
        try (Scanner scanner = new Scanner(System.in)) {
            while (socketChannel != null && socketChannel.isOpen()) {
                String sendMessage = scanner.nextLine();
                
                if ("exit".equalsIgnoreCase(sendMessage)) break;
                // 닉네임 설정
                if (SelectorChatClient.isNickNameInput) {
                	System.out.println("[알림] 닉네임을 \' "+ sendMessage+"\'으로 설정합니다.");
                	SelectorChatClient.isNickNameInput = false;
                }
                // 데이터 전송
                sendMessageToServer(buffer, sendMessage);
            }
        } catch (IOException e) {
        	String errorMessage = e.getMessage() != null ? e.getMessage() : "알 수 없는 오류";
            if ("Connection reset".equalsIgnoreCase(errorMessage)) {
                System.out.println("[알림] 서버와의 연결이 종료되었습니다.");
            } else {
                System.out.println("[에러] 입력 중 오류 발생: " + errorMessage);
            }
        } finally {
            closeChannel();
        }
    }

    // 데이터 전송
    private void sendMessageToServer(ByteBuffer buffer,String message) throws IOException {
    	buffer.clear();
        buffer = ByteBuffer.wrap(message.getBytes());
        socketChannel.write(buffer);
    }

    private void closeChannel() {
        try {
            if (socketChannel != null && socketChannel.isOpen()) {
                socketChannel.close();
            }
        } catch (IOException e) {
            System.err.println("[에러] 입력 스레드 자원 해제 중 오류 발생: " + e.getMessage());
        }
    }
}
