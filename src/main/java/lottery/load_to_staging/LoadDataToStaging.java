package lottery.load_to_staging;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;
import db.Dao;
import enums.ConfigStatus;
import enums.ConfigType;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LoadDataToStaging {
    public static void run(String csvFilePath, long schedule) {
        // Tải file config.properties và bắt đầu kết nối
        Dao dao;
        try {
            dao = Dao.getInstance();
        } catch (Exception e) {
            // Kết nối thất bại -> kết thúc
            System.out.println("Kết nối database không thành công!");
            return;
        }
        // Kết nối database thành công
        // Kiểm tra file có tồn tại
        File file = new File(csvFilePath);
        // Nếu file không tồn tại
        if (!file.exists()) {
            // Ghi 1 config của process này
            LocalDateTime startTime = LocalDateTime.now();
            Integer configId = dao.insertFileConfig(ConfigType.LOAD_TO_STAGING, null, null, null, csvFilePath, "lottery", "staging_lottery", schedule);
            LocalDateTime endTime = LocalDateTime.now();
            // Ghi log với trạng thái FAIL
            dao.insertFileLog(configId, startTime, endTime, ConfigStatus.FAIL, "Không tìm thấy file: " + csvFilePath);
            // Cập nhật trạng thái log của file sang đã xóa
            dao.markFileLogAsDeletedByFilePath(csvFilePath);
            return;
        }
        try (CSVReader reader = new CSVReader(new FileReader(csvFilePath))) {
            // Tạo vòng lặp đọc tuần tự từng record
            String[] line;
            reader.readNext();
            // Kiểm tra đã duyệt hết record trong file
            while ((line = reader.readNext()) != null) {
                // Nếu chưa duyệt hết
                if (line.length <= 11) {
                    String error = "";
                    // Ghi 1 config tương ứng 1 record
                    Integer configId = dao.insertFileConfig(ConfigType.LOAD_TO_STAGING, null, null, null, csvFilePath, "lottery", "staging_lottery", schedule);
                    LocalDateTime startTime = LocalDateTime.now();
                    try {
                        // Ghi dữ liệu vào staging_lottery
                        dao.insertStagingLottery(line[0], line[1], line[2], line[3], line[4], line[5], line[6], line[7], line[8], line[9], line[10]);
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                        LocalDateTime endTime = LocalDateTime.now();
                        // Nếu load thành công -> Ghi log với status là SUCCESS
                        dao.insertFileLog(configId, startTime, endTime, ConfigStatus.SUCCESS, null);
                    } catch (Exception e) {
                        // Nếu load thất bại -> Ghi log với status là ERROR
                        LocalDateTime endTime = LocalDateTime.now();
                        e.printStackTrace();
                        error += "Không thể ghi record: " + line[0] + ";\n";
                        dao.insertFileLog(configId, startTime, endTime, ConfigStatus.ERROR, error);
                    }
                }
            }
        } catch (IOException | CsvValidationException e) {
            System.out.println("Lỗi đọc file!");
        }
    }
}

