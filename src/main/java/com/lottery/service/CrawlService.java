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
        // 5. Lấy dữ liệu từ config: url, source_location, province
        String url = config.getSource();
        String csvFilePath = config.getSourceLocation();
        String province = config.getProvince();

        File csvFile = new File(csvFilePath);
        // 6. Kiểm tra tồn tại File với đường dẫn source_location từ config
        if (!csvFile.exists()) {
            try {
                // 7. Tạo mới file, ghi header
                csvFile.createNewFile();
                // 8. Lấy dữ liệu từ url của config
                try (
                        CSVWriter writer = (CSVWriter) new CSVWriterBuilder(new FileWriter(csvFilePath))
                                .withQuoteChar(CSVWriter.NO_QUOTE_CHARACTER)
                                .build();
                ) {
                    writer.writeNext(CSV_HEADER.toArray(new String[0]));
                    String[] newRecord = getDataFromWebsite(config);
                    // 9. Kiểm tra dữ liệu có tồn tại
                    if (newRecord != null && newRecord[newRecord.length - 1] != null) {
                        // 10. Ghi bản ghi vào file
                        List<String[]> csvData = new ArrayList<>();
                        csvData.add(newRecord);
                        writer.writeAll(csvData);
                        // 11. Ghi log thành công
                        Long fileSize = csvFile.length();
                        controlService.insertLog(config, csvFilePath, LocalDate.now(),
                                Log.LogStatus.SUCCESS, 1,
                                fileSize, "Crawl dữ liệu và ghi vào file CSV thành công.");
                    } else {
                        // 12. Ném ngoại lệ
                        throw new RuntimeException("Lỗi lấy dữ liệu từ URL");
                    }
                }
                //13. Xảy ra lỗi
                catch (IOException e) {
                    // 14. Ném ngoại lệ
                    throw new RuntimeException("Lỗi khi ghi dữ liệu vào file CSV");
                }
            } catch (Exception e) {
                // 15. Ghi log thất bại
                controlService.insertLog(config, config.getSourceLocation(), LocalDate.now(), Log.LogStatus.FAILURE, null, null, e.getMessage());
            }
        } else {
            // 16. Đọc dữ liệu từ file CSV hiện có
            List<String[]> csvData = readCSV(csvFilePath);
            // 17. Lấy dữ liệu từ url của config
            String[] newRecord = getDataFromWebsite(config);
            // 18. Kiểm tra dữ liệu có tồn tại
            if (newRecord != null && newRecord[newRecord.length - 1] != null) {
                // 19. Kiểm tra dữ liệu đã có trong file
                if (!isRecordExist(csvData, newRecord)) {
                    // 20. Ghi bản ghi vào file
                    csvData.add(newRecord);
                    try (
                            CSVWriter writer = (CSVWriter) new CSVWriterBuilder(new FileWriter(csvFilePath))
                                    .withQuoteChar(CSVWriter.NO_QUOTE_CHARACTER)
                                    .build();
                    ) {
                        writer.writeAll(csvData);
                        // 21. Ghi log thành công
                        Long fileSize = csvFile.length();
                        controlService.insertLog(config, csvFilePath, LocalDate.now(),
                                Log.LogStatus.SUCCESS, csvData.size() + 1,
                                fileSize, "Crawl dữ liệu và ghi vào file CSV thành công.");
                    }
                    //22. Xảy ra lỗi
                    catch (IOException e) {
                        // 23. Ghi log thất bại
                        controlService.insertLog(config, config.getSourceLocation(), LocalDate.now(), Log.LogStatus.FAILURE, null, null, "Lỗi khi ghi dữ liệu vào file CSV: " + e.getMessage());
                    }
                } else {
                    // 24. Ghi log thành công
                    Long fileSize = csvFile.length();
                    controlService.insertLog(config, csvFilePath, LocalDate.now(),
                            Log.LogStatus.SUCCESS, csvData.size() + 1,
                            fileSize, "Dữ liệu đã tồn tại, không cần ghi thêm.");
                }
            } else {
                // 25. Ghi log thất bại
                controlService.insertLog(config, config.getSourceLocation(), LocalDate.now(), Log.LogStatus.FAILURE, null, null, "Lỗi lấy dữ liệu từ URL.");
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
