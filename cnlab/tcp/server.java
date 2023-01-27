import java.util.*;

import java.net.*;

import java.io.*;




public class tcpserver {

            public static void main(String[] args)

            {

                        try

                        {

                                    ServerSocket s=new ServerSocket(1472);

                                    System.out.println("Server Ready\nwaiting for connection .....");

                                    Socket s1=s.accept();

                                    DataOutputStream dos= new DataOutputStream(s1.getOutputStream());

                                    DataInputStream dis= new DataInputStream(s1.getInputStream());

                                    System.out.println(dis.readUTF());

                                    String path= dis.readUTF();

                                    System.out.println("Request Recieved");

                                    try

                                    {

                                                File myFile= new File(path);

                                                Scanner scn=new Scanner(myFile);

                                                String st=scn.nextLine();

                                                st="The contents of the file is"+st;

                                                while(scn.hasNextLine())

                                                {

                                                            st=st+"\n"+scn.nextLine();

                                                }

                                                dos.writeUTF(st);

                                                dos.close();

                                                s1.close();

                                                s.close();

                                                scn.close();

                                    }

                                    catch(FileNotFoundException e)

                                    {

                                                System.out.println("ERROR! FILE NOT FOUND");

                                                dos.writeUTF("ERROR! FILE NOT FOUND");

                                    }

                        }

                        catch(IOException e)

                        {

                                    System.out.println("IO:"+e.getMessage());

                        }

                        finally

                        {

                                    System.out.println("Connection Terminated");

                                    }

            }

}
