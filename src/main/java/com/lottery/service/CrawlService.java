package com.lottery.service;

import com.lottery.entity.Config;
import com.lottery.entity.Log;
import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;
import com.opencsv.CSVWriterBuilder;
import com.opencsv.exceptions.CsvValidationException;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

import lombok.RequiredArgsConstructor;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CrawlService {
    private final ControlService controlService;
    private final List<String> CSV_HEADER = Arrays.asList(
            "province", "prize_special", "prize_one", "prize_two", "prize_three",
            "prize_four", "prize_five", "prize_six", "prize_seven", "prize_eight", "date"
    );

    /**
     * Phương thức crawl dữ liệu từ website và xuất dữ liệu vào file CSV.
     *
     * @param config cấu hình cần crawl
     */
    public void crawlDataAndExportCSV(Config config) {
        if (config.getType() == Config.Type.CRAWL_DATA) {
            String url = config.getSource();
            String csvFilePath = config.getSourceLocation();
            String province = config.getProvince();

            try {
                File csvFile = new File(csvFilePath);
                // Nếu file không tồn tại, tạo mới file và ghi header
                if (!csvFile.exists()) {
                    try {
                        csvFile.createNewFile();
                        try (
                                CSVWriter writer = (CSVWriter) new CSVWriterBuilder(new FileWriter(csvFilePath))
                                        .withQuoteChar(CSVWriter.NO_QUOTE_CHARACTER)  // Tắt dấu ngoặc kép
                                        .build();
                        ) {
                            // Ghi header vào file CSV
                            writer.writeNext(CSV_HEADER.toArray(new String[0]));
                            // Lấy dữ liệu từ website
                            String[] newRecord = getDataFromWebsite(config);
                            System.out.println(newRecord);
                            if (newRecord != null && newRecord[newRecord.length - 1] != null) {
                                if (newRecord[newRecord.length - 1] != null)
                                    if (newRecord != null) {
                                        List<String[]> csvData = new ArrayList<>();
                                        csvData.add(newRecord);
                                        // Ghi dữ liệu vào file CSV
                                        writer.writeAll(csvData);
                                        // Ghi log thành công vào bảng log thông qua controlService
                                        Long fileSize = csvFile.length();
                                        controlService.insertLog(config, csvFilePath, LocalDate.now(),
                                                Log.LogStatus.SUCCESS, 1,
                                                fileSize, "Crawl dữ liệu và ghi vào file CSV thành công.");
                                    }
                            }
                        } catch (IOException e) {
                            controlService.insertLog(config, config.getSourceLocation(), LocalDate.now(), Log.LogStatus.FAILURE, null, null, "Lỗi khi ghi dữ liệu vào file CSV: " + e.getMessage());
                        }
                    } catch (IOException e) {
                        // Log lỗi khi không tạo được file CSV
                        controlService.insertLog(config, config.getSourceLocation(), LocalDate.now(), Log.LogStatus.FAILURE, null, null, "Không thể tạo file CSV: " + e.getMessage());
                    }
                }
                // Nếu file CSV đã tồn tại, đọc dữ liệu và thêm dữ liệu mới
                else {
                    //Load dữ liệu của file
                    List<String[]> csvData = readCSV(csvFilePath);
                    String[] newRecord = getDataFromWebsite(config);
                    System.out.println(newRecord);
                    if (newRecord != null && newRecord[newRecord.length - 1] != null) {
                        // Nếu có dữ liệu mới thì thêm vào
                        if (isRecordExist(csvData, newRecord))
                            csvData.add(newRecord);
                        try (
                                CSVWriter writer = (CSVWriter) new CSVWriterBuilder(new FileWriter(csvFilePath))
                                        .withQuoteChar(CSVWriter.NO_QUOTE_CHARACTER)  // Tắt dấu ngoặc kép
                                        .build();
                        ) {
                            // Ghi dữ liệu vào file CSV
                            writer.writeAll(csvData);
                            // Ghi log thành công vào bảng log thông qua controlService
                            Long fileSize = csvFile.length();
                            controlService.insertLog(config, csvFilePath, LocalDate.now(),
                                    Log.LogStatus.SUCCESS, csvData.size() + 1,
                                    fileSize, "Crawl dữ liệu và ghi vào file CSV thành công.");
                        } catch (IOException e) {
                            // Log lỗi khi ghi dữ liệu vào file CSV
                            controlService.insertLog(config, config.getSourceLocation(), LocalDate.now(), Log.LogStatus.FAILURE, null, null, "Lỗi khi ghi dữ liệu vào file CSV: " + e.getMessage());
                        }
                    }
                }
            } catch (Exception e) {
                // Log lỗi tổng quan trong quá trình crawl dữ liệu
                controlService.insertLog(config, config.getSourceLocation(), LocalDate.now(), Log.LogStatus.FAILURE, null, null, "Lỗi khi crawl dữ liệu từ website: " + e.getMessage());
            }
        }
    }

    /**
     * Phương thức lấy dữ liệu từ website và trả về mảng các chuỗi.
     *
     * @param config config
     * @return mảng các chuỗi chứa dữ liệu từ website
     */
    private String[] getDataFromWebsite(Config config) {
        String url = config.getSource();
        String province = config.getProvince();
        String[] data = new String[11];
        try {
            if (url == null) return data;
            System.out.println("URL: " + url);
            Document doc = Jsoup.connect(url).get();
            String[] targetClasses = {"giaidb", "giai1", "giai2", "giai3", "giai4", "giai5", "giai6", "giai7", "giai8"};
            data[0] = province;
            int index = 1;
            // Lấy dữ liệu từ các lớp HTML tương ứng với giải thưởng
            for (String className : targetClasses) {
                Elements tds = doc.select("td." + className);
                for (Element td : tds) {
                    data[index++] = td.text(); // Lưu nội dung giải vào mảng
                }
            }
            // Lấy ngày quay thưởng từ phần tử HTML
            Element selectElement = doc.getElementById("box_kqxs_ngay");
            Element selectedOption = selectElement.selectFirst("option[selected]");
            String selectedDateText = null;
            if (selectedOption != null) {
                selectedDateText = selectedOption.text();
            } else {
                selectedDateText = null;
            }
            data[10] = selectedDateText;
        } catch (Exception e) {// Log lỗi khi không thể lấy dữ liệu từ website
            controlService.insertLog(config, config.getSourceLocation(), LocalDate.now(), Log.LogStatus.FAILURE, null, null, "Lỗi khi lấy dữ liệu từ website: " + e.getMessage());
        }
        return data;
    }

    /**
     * Đọc dữ liệu từ file CSV.
     *
     * @param filePath đường dẫn đến file CSV
     * @return danh sách các dòng dữ liệu trong file CSV
     */
    private static List<String[]> readCSV(String filePath) {
        List<String[]> records = new ArrayList<>();
        try (CSVReader reader = new CSVReader(new FileReader(filePath))) {
            String[] line;
            while ((line = reader.readNext()) != null) {
                records.add(line);
            }
        } catch (IOException | CsvValidationException e) {
            e.printStackTrace();
        }
        return records;
    }

    /**
     * Phương thức kiểm tra xem bản ghi đã tồn tại trong file CSV hay chưa.
     *
     * @param csvData   danh sách dữ liệu đã đọc từ file CSV
     * @param newRecord bản ghi mới cần kiểm tra
     * @return true nếu bản ghi đã tồn tại, false nếu chưa tồn tại
     */
    private boolean isRecordExist(List<String[]> csvData, String[] newRecord) {
        for (String[] record : csvData) {
            boolean isDuplicate = true;
            // Kiểm tra tất cả các cột
            for (int i = 0; i < record.length; i++) {
                if (!record[i].equals(newRecord[i])) {
                    isDuplicate = false;
                    break; // Nếu có bất kỳ cột nào khác nhau, không phải là bản sao
                }
            }
            if (isDuplicate) {
                return true; // Nếu tất cả các cột giống nhau, là bản sao
            }
        }
        return false; // Nếu không tìm thấy bản sao
    }
}
