package udpEchoServerClient;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

public class UdpSocketServer {
    public static void main(String[] args) {
        final int SERVER_PORT = 9876; // 서버가 사용할 포트 번호
        DatagramSocket datagramSocket = null; 
        
        try {
            // DatagramSocket 객체 생성
            datagramSocket = new DatagramSocket(SERVER_PORT);
            System.out.println("UDP 에코 서버가 시작되었습니다. 포트: " + SERVER_PORT);

            byte[] receiveBuffer = new byte[1024]; // 수신 버퍼 1024바이트 제한

            while (true) {
                // 수신 패킷 생성
            	DatagramPacket receivePacket = new DatagramPacket(receiveBuffer, receiveBuffer.length);
                
                // 데이터 수신
                datagramSocket.receive(receivePacket);
                
                // 수신된 데이터와 클라이언트 정보 출력
                String receivedData = new String(receivePacket.getData(), 0, receivePacket.getLength());
                System.out.println("수신된 데이터: " + receivedData);
                
                // 클라이언트 주소와 포트
                InetAddress clientAddress = receivePacket.getAddress();
                int clientPort = receivePacket.getPort();

                // 에코 응답 패킷 생성
                DatagramPacket sendPacket = new DatagramPacket(
                    receivePacket.getData(), 
                    receivePacket.getLength(), 
                    clientAddress, 
                    clientPort
                );

                // 데이터 전송
                datagramSocket.send(sendPacket);
                System.out.println("에코 응답 전송: " + receivedData);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
			if(datagramSocket != null) datagramSocket.close();
		}
    }
}