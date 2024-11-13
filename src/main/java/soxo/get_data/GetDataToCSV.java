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
        //url: trong trường hợp này chỉ để ghi log
        String url = ProvinceURL.getFullURL(province, date);
        String error = null;
        try {
            // 1 kết nối database
            Dao dao = Dao.getInstance();
            // 2 get config
            FileConfig fileConfig = dao.selectFileConfigByUrl(url);
            // 3 thoát
            if (fileConfig != null && dao.hasFileConfigSucceeded(fileConfig.getConfigId())) {
                System.out.println("Trước đó, url này đã đươc crawl thành công!");
            } else {
                // 5 crawl -> csv file
                File file = null;
                LocalDateTime startTime = LocalDateTime.now();
                try {
                    file = WebCrawler.loadAndWrite(csvFilePath, province, date);
                } catch (Exception e) {
                    error = "crawl và lưu xuống csv file thất bại";
                }
                LocalDateTime endTime = LocalDateTime.now();
                // 6 ghi control
                Integer configId = dao.insertFileConfig(ConfigType.CRAWL_DATA, province, date, url, csvFilePath, "lottery", "staging_lottery", schedule);
                // 4 insert logs
                if (file == null) {
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.ERROR, error);
                } else {
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.SUCCESS, null);
                }
            }
        } catch (Exception e) {
            System.out.println("Crawl data thất bại: " + province + date);
            e.printStackTrace();
        }
    }

    public static void run(String csvFilePath, String province, long schedule) {
        //url: trong trường hợp này chỉ để ghi log
        LocalDate date = LocalDate.now();
        String url = ProvinceURL.getFullURL(province, date);
        String error = null;
        try {
            // 1 kết nối database
            Dao dao = Dao.getInstance();
            // 2 get config
            FileConfig fileConfig = dao.selectFileConfigByUrl(url);
            // 3 thoát
            if (fileConfig != null && dao.hasFileConfigSucceeded(fileConfig.getConfigId())) {
                System.out.println("Trước đó, url này đã đươc crawl thành công!");
            } else {
                // 5 crawl -> csv file
                File file = null;
                LocalDateTime startTime = LocalDateTime.now();
                try {
                    file = WebCrawler.loadAndWrite(csvFilePath, province, date);
                } catch (Exception e) {
                    error = "crawl và lưu xuống csv file thất bại";
                }
                LocalDateTime endTime = LocalDateTime.now();
                // 6 ghi config
                Integer configId = dao.insertFileConfig(ConfigType.CRAWL_DATA, province, date, url, csvFilePath, "lottery", "staging_lottery", schedule);
                // 4 insert logs
                if (file == null) {
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.ERROR, error);
                } else {
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.SUCCESS, null);
                }
            }
        } catch (Exception e) {
            System.out.println("Crawl data thất bại: " + province + date);
            e.printStackTrace();
        }
    }

}