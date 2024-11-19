package soxo.get_data;

import db.Dao;
import entity.FileConfig;
import enums.ConfigStatus;
import enums.ConfigType;
import enums.ProvinceURL;

import java.io.File;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class GetDataToCSV {
    public static String generateFileNameWithDate(LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("ddMMyyyy");
        String formattedDate = date.format(formatter);
        return formattedDate + "_XSVN.csv";
    }

    public static void run(String csvFilePath, String province, LocalDate date, long schedule) {
        //Tạo đường dẫn url để lấy dữ liệu
        String url = ProvinceURL.getFullURL(province, date);
        String error = null;
        try {
            // kết nối database
            Dao dao = Dao.getInstance();
            // Load config
            FileConfig fileConfig = dao.selectFileConfigByUrl(url);
            // Kiểm tra process này đã chạy thành công trước đó hay chưa
            if (fileConfig != null && dao.hasFileConfigSucceeded(fileConfig.getConfigId())) {
                System.out.println("Trước đó, url này đã đươc crawl thành công!");
            } else {
                // Nếu process chưa chạy thành công trước đó
                // Ghi config
                Integer configId = dao.insertFileConfig(ConfigType.CRAWL_DATA, province, date, url, csvFilePath, "lottery", "staging_lottery", schedule);
                // Crawl dữ liệu
                File file = null;
                LocalDateTime startTime = LocalDateTime.now();
                try {
                    file = WebCrawler.loadAndWrite(csvFilePath, province, date);
                } catch (Exception e) {
                    error = "crawl và lưu xuống csv file thất bại";
                }
                LocalDateTime endTime = LocalDateTime.now();
                // Kiểm tra crawl có thành công
                if (file == null) {
                    // Nếu thất bại, ghi 1 log với trạng thái ERROR
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.ERROR, error);
                } else {
                    // Nếu thành công, ghi 1 log với trạng thái SUCCESS
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.SUCCESS, null);
                }
            }
        } catch (Exception e) {
            System.out.println("Crawl data thất bại: " + province + date);
            e.printStackTrace();
        }
    }
    public static void run(String csvFilePath, String province, long schedule) {
        //Tạo đường dẫn url để lấy dữ liệu
        LocalDate date = LocalDate.now();
        String url = ProvinceURL.getFullURL(province, date);
        String error = null;
        try {
            // kết nối database
            Dao dao = Dao.getInstance();
            // Load config
            FileConfig fileConfig = dao.selectFileConfigByUrl(url);
            // Kiểm tra process này đã chạy thành công trước đó hay chưa
            if (fileConfig != null && dao.hasFileConfigSucceeded(fileConfig.getConfigId())) {
                System.out.println("Trước đó, url này đã đươc crawl thành công!");
            } else {
                // Nếu process chưa chạy thành công trước đó
                // Ghi config
                Integer configId = dao.insertFileConfig(ConfigType.CRAWL_DATA, province, date, url, csvFilePath, "lottery", "staging_lottery", schedule);
                // Crawl dữ liệu
                File file = null;
                LocalDateTime startTime = LocalDateTime.now();
                try {
                    file = WebCrawler.loadAndWrite(csvFilePath, province, date);
                } catch (Exception e) {
                    error = "crawl và lưu xuống csv file thất bại";
                }
                LocalDateTime endTime = LocalDateTime.now();
                // Kiểm tra crawl có thành công
                if (file == null) {
                    // Nếu thất bại, ghi 1 log với trạng thái ERROR
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.ERROR, error);
                } else {
                    // Nếu thành công, ghi 1 log với trạng thái SUCCESS
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.SUCCESS, null);
                }
            }
        } catch (Exception e) {
            System.out.println("Crawl data thất bại: " + province + date);
            e.printStackTrace();
        }
    }

}