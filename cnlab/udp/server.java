import java.util.*;

import java.net.*;

import java.io.*;




public class udpserver

{

               public static void main(String args[])

               {

                               DatagramSocket aSocket=null;

                               Scanner scan=new Scanner(System.in);

                               int ServerPort=1221;

                               System.out.println("Server ready  \n Waiting for connection…………..\n");

                               try

                               {

                                              aSocket=new DatagramSocket(ServerPort);

                                              byte[] buffer=new byte[1000];

                                              byte[] buff=new byte[1000];

                                              DatagramPacket data1=new DatagramPacket(buff,buff.length);

                                              aSocket.receive(data1);

                                              byte[] msg=new byte[1000];

                                              msg=data1.getData();

                                              System.out.println(new String(msg,0,data1.getLength()));

                                              System.out.println("\nEnter message to be sent:");

                                              String str=scan.nextLine();

                                              buffer=str.getBytes();

                                              DatagramPacket data=new DatagramPacket(buffer,buffer.length,InetAddress.getLocalHost(),1220);

                                              aSocket.send(data);

                                             

                                             

                               }

                              

                               catch(SocketException e)

                               {

                                              System.out.println("Socket "+e.getMessage());

                                             

                               }

                               catch(IOException o)

                               {

                                              System.out.println("IO :"+o.getMessage());

                               }

                              

                               finally

                               {

                                              System.out.println("\nMessage sent\nconnection terminated\n");

                                              if(aSocket!=null)

                                                             aSocket.close();

                                              scan.close();

                               }

               }

}
