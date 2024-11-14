package selectorchat;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.util.Scanner;

public class SelectorChatClient {
    public static void main(String[] args) {
        try (SocketChannel socket = SocketChannel.open(new InetSocketAddress("192.168.30.215", 12345))) {
            Thread systemOut = new Thread(new SystemOut(socket));
            Thread systemIn = new Thread(new SystemIn(socket));

            systemOut.start();
            systemIn.start();

            systemOut.join();
            systemIn.join();
        } catch (IOException e) {
            System.err.println("서버와의 연결 실패: " + e.getMessage());
        } catch (InterruptedException e) {
            System.err.println("스레드 종료 대기 중 오류 발생: " + e.getMessage());
        }
    }
}

// 출력을 담당하는 스레드
class SystemOut implements Runnable {
    private final SocketChannel socketChannel;

    SystemOut(SocketChannel socketChannel) {
        this.socketChannel = socketChannel;
    }

    @Override
    public void run() {
        ByteBuffer buffer = ByteBuffer.allocate(1024);
        try {
            while (socketChannel.isOpen()) {
                buffer.clear();
                int bytesRead = socketChannel.read(buffer);
                if (bytesRead == -1) break;

                buffer.flip();
                String receivedMessage = new String(buffer.array(), 0, bytesRead);
                System.out.print(receivedMessage);
            }
        } catch (IOException e) {
            System.out.println("출력 중 오류 발생: " + e.getMessage());
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
            System.err.println("출력 스레드 자원 해제 중 오류 발생: " + e.getMessage());
        }
    }
}

// 입력을 담당하는 스레드
class SystemIn implements Runnable {
    private final SocketChannel socketChannel;

    SystemIn(SocketChannel socketChannel) {
        this.socketChannel = socketChannel;
    }

    @Override
    public void run() {
        ByteBuffer buffer;
        try (Scanner scanner = new Scanner(System.in)) {
            while (socketChannel.isOpen()) {
                String sendMessage = scanner.nextLine();
                if ("exit".equalsIgnoreCase(sendMessage)) break;

                buffer = ByteBuffer.wrap(sendMessage.getBytes());
                socketChannel.write(buffer);
            }
        } catch (IOException e) {
            System.err.println("입력 중 오류 발생: " + e.getMessage());
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
            System.err.println("입력 스레드 자원 해제 중 오류 발생: " + e.getMessage());
        }
    }
}
