package db;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;

import java.sql.SQLException;
import java.sql.SQLOutput;

public class JDBIConnector {
   private static Jdbi jdbi;

   public static void connect(){
       MysqlDataSource mysqlDataSource = new MysqlDataSource();
       mysqlDataSource.setURL("jdbc:mysql://" + DBProperties.host+":" + DBProperties.port + "/" + DBProperties.name );
       mysqlDataSource.setUser(DBProperties.username);
       mysqlDataSource.setPassword(DBProperties.password);
       try {
           mysqlDataSource.setAutoReconnect(true);
           mysqlDataSource.setUseCompression(true);
       } catch (SQLException e) {
           System.out.println("ERROR! Kết nối database thất bại.");
           throw new RuntimeException(e);
       }
       jdbi = Jdbi.create(mysqlDataSource);
       System.out.println("Kết nối database thành công!");
   }

    public JDBIConnector() {
    }
    public static Jdbi me(){
       if(jdbi==null) connect();
       return jdbi;
    }
}
