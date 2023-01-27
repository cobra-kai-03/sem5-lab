import java.util.*;

import java.net.*;

import java.io.*;




public class tcpclient

{

            public static void main(String args[])

            {

                        try

                        {

                                    Scanner scn=new Scanner(System.in);

                                    Socket s=new Socket("10.24.30.7",1472);

                                    DataOutputStream dos = new DataOutputStream(s.getOutputStream());

                                    DataInputStream dis=new DataInputStream(s.getInputStream());

                                    dos.writeUTF("connected to 10.24.30.7 \n");

                                    System.out.println("\n Enter the full path of file to be displayed\n");

                                    String path=scn.nextLine();

                                    dos.writeUTF(path);

                                    System.out.println(new String(dis.readUTF()));

                                    dis.close();

                                    dos.close();

                                    s.close();

                                    scn.close();

                        }

                        catch(IOException e)

                        {

                                    System.out.println("IO :"+e.getMessage());

                        }

            }

}
