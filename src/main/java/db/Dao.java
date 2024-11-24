package db;

import entity.DataMart;
import entity.FileConfig;
import entity.FileLog;
import entity.StagingLottery;
import enums.ConfigStatus;
import enums.ConfigType;
import org.jdbi.v3.core.Jdbi;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class Dao {
    private final Jdbi jdbi;
    private static Dao instance;

    // tải file config.properties và thiết lập kết nối
    public static Dao getInstance() {
        if (instance == null)
            instance = new Dao();
        return instance;
    }

    private Dao() {
        this.jdbi = JDBIConnector.me();
    }

    public FileConfig selectFileConfigByUrl(String url) {
        String sql = "SELECT config_id AS configId, type, province, date, url, file_path AS filePath, " +
                "table_warehouse AS tableWarehouse, table_staging AS tableStaging, schedule " +
                "FROM file_configs WHERE url = :url";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("url", url) // Liên kết tham số URL
                        .mapToBean(FileConfig.class) // Ánh xạ kết quả vào đối tượng FileConfig
                        .findOne() // Lấy kết quả duy nhất hoặc trả về null nếu không có dữ liệu
                        .orElse(null) // Nếu không tìm thấy, trả về null
        );
    }

    public boolean hasFileConfigSucceeded(int configId) {
        String sql = "SELECT status FROM file_logs WHERE config_id = :configId ORDER BY log_id DESC LIMIT 1";

        return jdbi.withHandle(handle -> {
            String status = handle.createQuery(sql)
                    .bind("configId", configId)
                    .mapTo(String.class)
                    .findOne()
                    .orElse("ERROR"); // Nếu không có log, mặc định là 'ERROR'
            return "SUCCESS".equals(status); // Kiểm tra xem trạng thái là SUCCESS không
        });
    }

    // Phương thức để chèn dữ liệu vào bảng file_configs và trả về id của bản ghi
    public Integer insertFileConfig(ConfigType type, String province, LocalDate date, String url, String filePath,
                                    String tableWarehouse, String tableStaging, long schedule) {
        // Truy vấn kiểm tra xem file_config đã tồn tại chưa
        String checkSql = "SELECT COUNT(*) FROM file_configs WHERE type = :type AND province = :province AND date = :date";
        // Truy vấn chèn dữ liệu vào bảng file_configs
        String insertSql = "INSERT INTO file_configs (type, province, date, url, file_path, table_warehouse, " +
                "table_staging, schedule) VALUES (:type, :province, :date, :url, :filePath, :tableWarehouse, " +
                ":tableStaging, :schedule)";

        return jdbi.withHandle(handle -> {
            // Chuyển LocalDate thành chuỗi
            String dateString = date == null ? null : date.toString();  // Ví dụ: "2024-11-13"

            // Kiểm tra sự tồn tại của file_config với type, province và date
            int count = handle.createQuery(checkSql)
                    .bind("type", type.name())  // Convert enum to string using `name()`
                    .bind("province", province)
                    .bind("date", dateString)  // Sử dụng chuỗi ngày đã chuyển đổi
                    .mapTo(Integer.class)
                    .one();

            // Nếu không tồn tại, tiến hành chèn dữ liệu mới và trả về id của bản ghi mới
            if (count == 0) {
                // Chèn bản ghi và lấy id của bản ghi mới
                return handle.createUpdate(insertSql)
                        .bind("type", type.name())  // Convert enum to string using `name()`
                        .bind("province", province)
                        .bind("date", dateString)  // Sử dụng chuỗi ngày đã chuyển đổi
                        .bind("url", url)
                        .bind("filePath", filePath)
                        .bind("tableWarehouse", tableWarehouse)
                        .bind("tableStaging", tableStaging)
                        .bind("schedule", schedule)
                        .executeAndReturnGeneratedKeys("config_id")  // Lấy key tự động (id)
                        .mapTo(Integer.class)
                        .one();
            } else {
                // Nếu đã tồn tại, trả về null hoặc giá trị khác tùy yêu cầu của bạn
                return null;
            }
        });
    }

    public void updateFileConfigProvinceAndDate(int configId, String province, LocalDate date) {
        String sql = "UPDATE file_configs SET province = :province, date = :date WHERE config_id = :configId";

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("configId", configId)
                        .bind("province", province)
                        .bind("date", date == null ? null : date.toString()) // Chuyển LocalDate thành chuỗi hoặc null
                        .execute()
        );
    }

    // Phương thức để chèn dữ liệu vào bảng file_logs và trả về id của bản ghi
    public Integer insertFileLog(Integer fileConfigId, LocalDateTime startTime, LocalDateTime endTime,
                                 ConfigStatus status, String errorMessage) {
        // Truy vấn chèn dữ liệu vào bảng file_logs
        String insertSql = "INSERT INTO file_logs (config_id, start_time, end_time, status, error) " +
                "VALUES (:fileConfigId, :startTime, :endTime, :status, :error)";

        return jdbi.withHandle(handle -> {
            // Chuyển LocalDateTime thành chuỗi theo định dạng cần thiết (yyyy-MM-dd HH:mm:ss)
            String startTimeString = startTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            String endTimeString = endTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

            // Nếu có lỗi, chèn thông điệp lỗi vào trường `error`; nếu không, giá trị sẽ là null
            String error = (!status.equals("SUCCESS")) ? errorMessage : null;

            // Chèn bản ghi và trả về id của bản ghi mới
            return handle.createUpdate(insertSql)
                    .bind("fileConfigId", fileConfigId)
                    .bind("startTime", startTimeString)  // Chuyển thời gian thành chuỗi
                    .bind("endTime", endTimeString)      // Chuyển thời gian thành chuỗi
                    .bind("status", status.name())
                    .bind("error", error)  // Chỉ chèn thông điệp lỗi nếu trạng thái là "ERROR"
                    .executeAndReturnGeneratedKeys("log_id")  // Lấy key tự động (id)
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public List<FileLog> selectFileLogsByFilePathAndNotDeleted(String filePath) {
        String sql = "SELECT f.log_id, f.config_id, f.start_time, f.end_time, f.status, f.error, f.isDeletedFile " +
                "FROM file_logs f " +
                "JOIN file_configs c ON f.config_id = c.config_id " +
                "WHERE c.file_path = :filePath AND f.isDeletedFile = 0";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("filePath", filePath)
                        .mapToBean(FileLog.class)  // Ánh xạ kết quả truy vấn thành đối tượng FileLog
                        .list()  // Sử dụng `list()` để lấy tất cả các bản ghi khớp
        );
    }

    public void markFileLogAsDeletedByFilePath(String filePath) {
        String sql = "UPDATE file_logs f " +
                "JOIN file_configs c ON f.config_id = c.config_id " +
                "SET f.isDeletedFile = 1 " +
                "WHERE c.file_path = :filePath AND f.isDeletedFile = 0";

        // Sử dụng jdbi để thực hiện cập nhật
        jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("filePath", filePath)
                        .execute()  // Thực hiện câu lệnh cập nhật
        );
    }

    private String convertDateForSQL(LocalDateTime datetime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return datetime.format(formatter);
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

    // Insert method for table `lottery`
    public void insertLottery(int provinceId, int dateId, String prizeSpecial, String prizeOne,
                              String prizeTwo, String prizeThree, String prizeFour, String prizeFive,
                              String prizeSix, String prizeSeven, String prizeEight, LocalDateTime expireDate) {
        String expire_date = convertDateForSQL(expireDate);
        String sql = "INSERT INTO lottery (province_id, date_id, prize_special, prize_one, prize_two, prize_three, " +
                "prize_four, prize_five, prize_six, prize_seven, prize_eight, expire_date) " +
                "VALUES (:province_id, :date_id, :prize_special, :prize_one, :prize_two, :prize_three, " +
                ":prize_four, :prize_five, :prize_six, :prize_seven, :prize_eight, :expire_date)";
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
                        .bind("expire_date", expire_date)
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
                        .bind("date", date)
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

    public List<DataMart> getDataMart(LocalDate date) {
        String sql = "SELECT l.id, p.name AS province, " +
                "       l.prize_special AS prizeSpecial, l.prize_one AS prizeOne, " +
                "       l.prize_two AS prizeTwo, l.prize_three AS prizeThree, " +
                "       l.prize_four AS prizeFour, l.prize_five AS prizeFive, " +
                "       l.prize_six AS prizeSix, l.prize_seven AS prizeSeven, " +
                "       l.prize_eight AS prizeEight " +
                "FROM lottery l " +
                "JOIN province p ON l.province_id = p.id " +
                "JOIN date d ON l.date_id = d.id " +
                "WHERE d.day = :day AND d.month = :month AND d.year = :year";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("day", date.getDayOfMonth())
                        .bind("month", date.getMonthValue())
                        .bind("year", date.getYear())
                        .mapToBean(DataMart.class)
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

    public void removeStagingLottery(int id) {
        String sql = "DELETE FROM staging_lottery where id=:id";

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
    }
}
