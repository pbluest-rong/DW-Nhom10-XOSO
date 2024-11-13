package soxo.load_data;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;
import db.Dao;
import entity.FileLog;
import enums.ConfigStatus;
import enums.ConfigType;
import soxo.get_data.WebCrawler;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

public class LoadDataToStaging {
    public static void run(String csvFilePath, long schedule) {
        // connect database
        Dao dao;
        try {
            dao = Dao.getInstance();
        } catch (Exception e) {
            System.out.println("Kết nối database không thành công!");
            return;
        }
        File file = new File(csvFilePath);
        if (!file.exists()) {
            LocalDateTime startTime = LocalDateTime.now();
            Integer configId = dao.insertFileConfig(ConfigType.LOAD_TO_STAGING, null, null, null, csvFilePath, "lottery", "staging_lottery", schedule);
            LocalDateTime endTime = LocalDateTime.now();
            dao.insertFileLog(configId, startTime, endTime, ConfigStatus.FAIL, "Không tìm thấy file: " + csvFilePath);
            //cập nhật file log thành xóa
            dao.markFileLogAsDeletedByFilePath(csvFilePath);
            return;
        }
        try (CSVReader reader = new CSVReader(new FileReader(csvFilePath))) {
            String[] line;
            // duyệt từng record trong file
            reader.readNext();
            while ((line = reader.readNext()) != null) {
                if (line.length <= 11) {
                    // insert staging_lottery
                    Integer configId = null;
                    String error = "";
                    LocalDateTime startTime = LocalDateTime.now();
                    try {
                        dao.insertStagingLottery(line[0], line[1], line[2], line[3], line[4], line[5], line[6], line[7], line[8], line[9], line[10]);
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                        configId = dao.insertFileConfig(ConfigType.LOAD_TO_STAGING, line[0], LocalDate.parse(line[10], formatter), null, csvFilePath, "lottery", "staging_lottery", schedule);
                    } catch (Exception e) {
                        e.printStackTrace();
                        error += "Không thể ghi record: " + line[0] + ";\n";
                    }
                    LocalDateTime endTime = LocalDateTime.now();
                    if (configId == null || !error.isEmpty()) {
                        dao.insertFileConfig(ConfigType.LOAD_TO_STAGING, null, null, null, csvFilePath, "lottery", "staging_lottery", schedule);
                        dao.insertFileLog(configId, startTime, endTime, ConfigStatus.ERROR, error);
                    } else
                        dao.insertFileLog(configId, startTime, endTime, ConfigStatus.SUCCESS, null);
                }
            }
        } catch (IOException | CsvValidationException e) {
            System.out.println("Lỗi đọc file!");
        }
    }
}

