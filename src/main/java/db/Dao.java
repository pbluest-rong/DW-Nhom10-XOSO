package db;

import org.jdbi.v3.core.Jdbi;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Dao {
    private final Jdbi jdbi;
    private static Dao instance;

    public static Dao getInstance() {
        if (instance == null)
            instance = new Dao();
        return instance;
    }

    private Dao() {
        this.jdbi = JDBIConnector.me();
    }

    // Convert the date format from "dd/MM/yyyy" to "yyyy-MM-dd"
   public String convertDateForInsert(String date){
       String formattedDate = "";
       try {
           SimpleDateFormat inputFormat = new SimpleDateFormat("dd/MM/yyyy");
           SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
           Date parsedDate = inputFormat.parse(date);
           formattedDate = outputFormat.format(parsedDate);
       } catch (ParseException e) {
           e.printStackTrace();
       }
       return formattedDate;
   }
    // Insert method for table `date`
    public void insertDate(int id, int day, int month, int year) {
        String sql = "INSERT INTO date (id, day, month, year) VALUES (:id, :day, :month, :year)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .bind("day", day)
                        .bind("month", month)
                        .bind("year", year)
                        .execute()
        );
    }

    // Insert method for table `province`
    public void insertProvince(int id, String name) {
        String sql = "INSERT INTO province (id, name) VALUES (:id, :name)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .bind("name", name)
                        .execute()
        );
    }

    // Insert method for table `file_config`
    public void insertFileConfig(int id, String phase, String source, String sourceName, String area,
                                 String pathToSave, String fileNameFormat, String fileType, String timeGetData,
                                 int interval, String createDate, String updateDate, String description, int status) {
        String sql = "INSERT INTO file_config (id, phase, source, source_name, area, path_to_save, file_name_format, " +
                "file_type, time_get_data, interval, create_date, update_date, description, status) " +
                "VALUES (:id, :phase, :source, :source_name, :area, :path_to_save, :file_name_format, :file_type, " +
                ":time_get_data, :interval, :create_date, :update_date, :description, :status)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .bind("phase", phase)
                        .bind("source", source)
                        .bind("source_name", sourceName)
                        .bind("area", area)
                        .bind("path_to_save", pathToSave)
                        .bind("file_name_format", fileNameFormat)
                        .bind("file_type", fileType)
                        .bind("time_get_data", timeGetData)
                        .bind("interval", interval)
                        .bind("create_date", createDate)
                        .bind("update_date", updateDate)
                        .bind("description", description)
                        .bind("status", status)
                        .execute()
        );
    }

    // Insert method for table `file_log`
    public void insertFileLog(int id, String trackingDateTime, String source, int connectStatus,
                              String destination, String phase, String result, String detail, boolean isDelete) {
        String sql = "INSERT INTO file_log (id, tracking_date_time, source, connect_status, destination, phase, result, " +
                "detail, is_delete) VALUES (:id, :tracking_date_time, :source, :connect_status, :destination, :phase, " +
                ":result, :detail, :is_delete)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .bind("tracking_date_time", trackingDateTime)
                        .bind("source", source)
                        .bind("connect_status", connectStatus)
                        .bind("destination", destination)
                        .bind("phase", phase)
                        .bind("result", result)
                        .bind("detail", detail)
                        .bind("is_delete", isDelete)
                        .execute()
        );
    }

    // Insert method for table `lottery`
    public void insertLottery(int id, int provinceId, int dateId, String prizeSpecial, String prizeOne,
                              String prizeTwo, String prizeThree, String prizeFour, String prizeFive,
                              String prizeSix, String prizeSeven, String prizeEight) {
        String sql = "INSERT INTO lottery (id, province_id, date_id, prize_special, prize_one, prize_two, prize_three, " +
                "prize_four, prize_five, prize_six, prize_seven, prize_eight) " +
                "VALUES (:id, :province_id, :date_id, :prize_special, :prize_one, :prize_two, :prize_three, " +
                ":prize_four, :prize_five, :prize_six, :prize_seven, :prize_eight)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .bind("province_id", provinceId)
                        .bind("date_id", dateId)
                        .bind("prize_special", prizeSpecial)
                        .bind("prize_one", prizeOne)
                        .bind("prize_two", prizeTwo)
                        .bind("prize_three", prizeThree)
                        .bind("prize_four", prizeFour)
                        .bind("prize_five", prizeFive)
                        .bind("prize_six", prizeSix)
                        .bind("prize_seven", prizeSeven)
                        .bind("prize_eight", prizeEight)
                        .execute()
        );
    }

    // Insert method for table `staging_lottery`
    public void insertStagingLottery(String province, String prizeSpecial, String prizeOne,
                                     String prizeTwo, String prizeThree, String prizeFour, String prizeFive,
                                     String prizeSix, String prizeSeven, String prizeEight, String date) {

        String sql = "INSERT INTO staging_lottery (province, prize_special, prize_one, prize_two, prize_three, " +
                "prize_four, prize_five, prize_six, prize_seven, prize_eight, date) " +
                "VALUES (:province, :prize_special, :prize_one, :prize_two, :prize_three, :prize_four, " +
                ":prize_five, :prize_six, :prize_seven, :prize_eight, :date)";

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("province", province)
                        .bind("prize_special", prizeSpecial)
                        .bind("prize_one", prizeOne)
                        .bind("prize_two", prizeTwo)
                        .bind("prize_three", prizeThree)
                        .bind("prize_four", prizeFour)
                        .bind("prize_five", prizeFive)
                        .bind("prize_six", prizeSix)
                        .bind("prize_seven", prizeSeven)
                        .bind("prize_eight", prizeEight)
                        .bind("date", convertDateForInsert(date)) // Use the formatted date
                        .execute()
        );
    }
}
