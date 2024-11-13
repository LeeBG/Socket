package chatServer;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.net.InetSocketAddress;
import java.util.Iterator;
import java.util.Set;

public class ChatServerSelector {
    private Selector selector; // Selector 객체: 여러 채널을 관리
    // 자바의 NIO(New IO)의 Selector는 내부적으로 epoll을 사용하여 다수의 채널을 효과적으로 관리하는 기법
    public ChatServerSelector(int port) throws IOException {
        // Selector 생성
        selector = Selector.open();
        // 서버 소켓 채널 생성
        ServerSocketChannel serverChannel = ServerSocketChannel.open();
        // 지정된 포트에 바인딩
        serverChannel.bind(new InetSocketAddress(port));
        // 비차단 모드로 설정
        serverChannel.configureBlocking(false);
        // Selector에 서버 소켓 채널 등록, 클라이언트 연결 수신을 위해 OP_ACCEPT 이벤트를 설정
        serverChannel.register(selector, SelectionKey.OP_ACCEPT);
        System.out.println("Chat server started on port: " + port);
    }

    public void start() throws IOException {
        // 서버가 동작하는 동안 계속 실행
        while (true) {
            // 준비된 채널을 감지
            selector.select();
            Set<SelectionKey> selectedKeys = selector.selectedKeys(); // 선택된 키 집합
            Iterator<SelectionKey> iterator = selectedKeys.iterator(); // 키집합을 순회하는 Iterator

            // 선택된 키를 반복
            while (iterator.hasNext()) {
                SelectionKey key = iterator.next();
                if (key.isAcceptable()) {
                    // 새로운 클라이언트 연결 수락
                    acceptConnection(key);
                } else if (key.isReadable()) {
                    // 클라이언트로부터 메시지 읽기
                    readMessage(key);
                }
                iterator.remove(); // 처리한 키는 제거
            }
        }
    }
    // 서버 소켓 채널 연결 수락 메서드
    private void acceptConnection(SelectionKey key) throws IOException {
        // 서버 소켓 채널에서 클라이언트 연결 수락
        ServerSocketChannel serverChannel = (ServerSocketChannel) key.channel();
        SocketChannel clientChannel = serverChannel.accept();
        // 비차단 모드로 설정
        clientChannel.configureBlocking(false);
        // Selector에 클라이언트 소켓 채널 등록, 읽기 이벤트를 감지
        clientChannel.register(selector, SelectionKey.OP_READ);
        System.out.println("New client connected: " + clientChannel.getRemoteAddress());
    }

    // 메시지 읽기
    private void readMessage(SelectionKey key) throws IOException {
    	System.out.println(key);
        SocketChannel clientChannel = (SocketChannel) key.channel();
        ByteBuffer buffer = ByteBuffer.allocate(1024);
        int bytesRead;

        try {
            bytesRead = clientChannel.read(buffer);
        } catch (IOException e) {
            System.out.println("Error reading from client: " + e.getMessage());
            clientChannel.close();
            return;
        }

        if (bytesRead == -1) {
            System.out.println("Client disconnected: " + clientChannel.getRemoteAddress());
            clientChannel.close();
            return;
        }

        String message = new String(buffer.array()).trim();
        System.out.println("Received: " + message);

        // "exit" 메시지를 받으면 해당 클라이언트 종료
        if ("exit".equalsIgnoreCase(message)) {
            System.out.println("Client requested to exit: " + clientChannel.getRemoteAddress());
            clientChannel.close();
            return;
        }

        broadcastMessage(clientChannel, message);
    }


    // 채팅 발송
    private void broadcastMessage(SocketChannel sender, String message) throws IOException {
        // 모든 연결된 클라이언트에게 메시지를 전송
        for (SelectionKey key : selector.keys()) {
            Channel channel = key.channel();
            // 채널
            if (channel instanceof SocketChannel && channel != sender) {
                // 보낸 클라이언트를 제외한 클라이언트에게 메시지 전송
                SocketChannel recipient = (SocketChannel) channel;
                ByteBuffer buffer = ByteBuffer.wrap(message.getBytes()); // 메시지를 바이트 배열로 변환
                recipient.write(buffer); // 클라이언트에게 메시지 전송
            }
        }
    }

    public static void main(String[] args) {
        try {
            // 서버를 지정된 포트에서 시작
            ChatServerSelector server = new ChatServerSelector(12345);
            server.start(); // 서버 실행
        } catch (IOException e) {
            e.printStackTrace(); // 예외 처리
        }
    }
}