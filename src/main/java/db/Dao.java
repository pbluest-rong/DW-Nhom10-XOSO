package db;

import entity.StagingLottery;
import org.jdbi.v3.core.Jdbi;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
    public void insertDate(int day, int month, int year) {
        String checkSql = "SELECT COUNT(*) FROM date WHERE day = :day AND month = :month AND year = :year";
        String insertSql = "INSERT INTO date (day, month, year) VALUES (:day, :month, :year)";

        jdbi.useHandle(handle -> {
            int count = handle.createQuery(checkSql)
                    .bind("day", day)
                    .bind("month", month)
                    .bind("year", year)
                    .mapTo(Integer.class)
                    .one();

            if (count == 0) {
                handle.createUpdate(insertSql)
                        .bind("day", day)
                        .bind("month", month)
                        .bind("year", year)
                        .execute();
            }
        });
    }


    // Insert method for table `province`
    public void insertProvince(String name) {
        String checkSql = "SELECT COUNT(*) FROM province WHERE name = :name";
        String insertSql = "INSERT INTO province (name) VALUES (:name)";

        jdbi.useHandle(handle -> {
            int count = handle.createQuery(checkSql)
                    .bind("name", name)
                    .mapTo(Integer.class)
                    .one();

            if (count == 0) {
                handle.createUpdate(insertSql)
                        .bind("name", name)
                        .execute();
            }
        });
    }


    // Insert method for table `file_config`
    public void insertFileConfig(String phase, String source, String sourceName, String area,
                                 String pathToSave, String fileNameFormat, String fileType, String timeGetData,
                                 int interval, String createDate, String updateDate, String description, int status) {
        String sql = "INSERT INTO file_config (phase, source, source_name, area, path_to_save, file_name_format, " +
                "file_type, time_get_data, `interval`, create_date, update_date, description, status) " +
                "VALUES (:phase, :source, :source_name, :area, :path_to_save, :file_name_format, :file_type, " +
                ":time_get_data, :interval, :create_date, :update_date, :description, :status)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
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
    public void insertFileLog(String trackingDateTime, String source, int connectStatus,
                              String destination, String phase, String result, String detail, boolean isDelete) {
        String sql = "INSERT INTO file_log (tracking_date_time, source, connect_status, destination, phase, result, " +
                "detail, is_delete) VALUES (:tracking_date_time, :source, :connect_status, :destination, :phase, " +
                ":result, :detail, :is_delete)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
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
    public void insertLottery(int provinceId, int dateId, String prizeSpecial, String prizeOne,
                              String prizeTwo, String prizeThree, String prizeFour, String prizeFive,
                              String prizeSix, String prizeSeven, String prizeEight) {
        String sql = "INSERT INTO lottery (province_id, date_id, prize_special, prize_one, prize_two, prize_three, " +
                "prize_four, prize_five, prize_six, prize_seven, prize_eight) " +
                "VALUES (:province_id, :date_id, :prize_special, :prize_one, :prize_two, :prize_three, " +
                ":prize_four, :prize_five, :prize_six, :prize_seven, :prize_eight)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
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
    // Phương thức để truy vấn dữ liệu từ bảng staging_lottery
    public List<StagingLottery> selectStagingLottery() {
        String sql = "SELECT id, province, prize_special AS prizeSpecial, prize_one AS prizeOne, " +
                "prize_two AS prizeTwo, prize_three AS prizeThree, prize_four AS prizeFour, " +
                "prize_five AS prizeFive, prize_six AS prizeSix, prize_seven AS prizeSeven, " +
                "prize_eight AS prizeEight, date FROM staging_lottery";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(StagingLottery.class) // Ánh xạ kết quả vào class StagingLottery
                        .list()
        );
    }
    public Integer getProvinceId(String name) {
        String sql = "SELECT id FROM province WHERE name = :name";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("name", name)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(null)
        );
    }
    public Integer getDateId(int day, int month, int year) {
        String sql = "SELECT id FROM date WHERE day = :day AND month = :month AND year = :year";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("day", day)
                        .bind("month", month)
                        .bind("year", year)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(null)
        );
    }
    public void clearStagingLottery() {
        String sql = "DELETE FROM staging_lottery";

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .execute()
        );
    }
}
