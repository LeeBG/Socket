package udpEchoServerClient;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.Scanner;

public class UdpSocketClient {
    public static void main(String[] args) {
        final String SERVER_ADDRESS = "localhost"; // 서버 주소
        final int SERVER_PORT = 9876; // 서버 포트 번호
        Scanner scanner = null;
        DatagramSocket datagramSocket = null;
        try {
            // DatagramSocket 객체 생성
            datagramSocket = new DatagramSocket();

            scanner = new Scanner(System.in);
            System.out.println("서버에 보낼 메시지를 입력하세요 (종료하려면 'exit' 입력):");

            while (true) {
                // 사용자 입력 받기
                String message = scanner.nextLine();
                
                // 종료 조건
                if (message.equalsIgnoreCase("exit")) {
                    System.out.println("클라이언트를 종료합니다.");
                    break;
                }

                // 메시지를 바이트 배열로 변환
                byte[] sendBuffer = message.getBytes();

                // 서버로 전송할 패킷 생성
                DatagramPacket sendPacket = new DatagramPacket(
                    sendBuffer, 
                    sendBuffer.length, 
                    InetAddress.getByName(SERVER_ADDRESS), 
                    SERVER_PORT
                );

                // 데이터 전송
                datagramSocket.send(sendPacket);
                System.out.println("서버에 전송한 데이터: " + message);

                // 수신 버퍼 생성
                byte[] receiveBuffer = new byte[1024];

                // 응답 패킷 생성
                DatagramPacket receivePacket = new DatagramPacket(receiveBuffer, receiveBuffer.length);

                // 서버로부터 응답 수신
                datagramSocket.receive(receivePacket);
                
                // 수신된 데이터 출력
                String receivedData = new String(receivePacket.getData(), 0, receivePacket.getLength());
                System.out.println("서버로부터 수신된 데이터: " + receivedData);
            }

            // 자원 해제
            datagramSocket.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	if (scanner != null) scanner.close();
        	if(datagramSocket != null) datagramSocket.close();
        }
    }
}