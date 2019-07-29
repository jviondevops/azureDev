import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;


public class RunShellScript {

  
public static void main(String[] args) {
        
        
Process p;
  try {
   String[] cmd = { "sh", "/home/ec2-user/test.sh"};
   p = Runtime.getRuntime().exec(cmd); 
   p.waitFor(); 
   BufferedReader reader=new BufferedReader(new InputStreamReader(
    p.getInputStream())); 
   String line; 
   while((line = reader.readLine()) != null) { 
    System.out.println(line);
   } 
  } catch (IOException e) {
   
   e.printStackTrace();
  } catch (InterruptedException e) {
   
   e.printStackTrace();
  }
        
    }
    
}

