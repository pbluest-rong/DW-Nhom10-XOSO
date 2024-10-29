package soxo.get_datasources;

import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;
import com.opencsv.exceptions.CsvValidationException;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class CSVHelper {
    private static final List<String> HEADER = Arrays.asList(
            "province", "prize_special", "prize_one", "prize_two", "prize_three",
            "prize_four", "prize_five", "prize_six", "prize_seven", "prize_eight", "date"
    );

    public static List<String[]> readCSV(String filePath) {
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

    public static void loadAndWrite(String csvFilePath, String xoSoUrl, String provinceName) {
        // Nếu file không tồn tại, tạo mới file và ghi header (nếu cần thiết)
        File csvFile = new File(csvFilePath);
        if (!csvFile.exists()) {
            try {
                csvFile.createNewFile();
                try (CSVWriter writer = new CSVWriter(new FileWriter(csvFilePath))) {
                    writer.writeNext(HEADER.toArray(new String[0])); // Ghi dòng header
                    String[] newRecord = WebCrawler.getDataFromWebsite(provinceName, xoSoUrl);
                    List<String[]> csvData = new ArrayList<>();
                    csvData.add(newRecord);
                    writer.writeAll(csvData);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        } else {
            //update
            List<String[]> csvData = CSVHelper.readCSV(csvFilePath);
            String[] newRecord = WebCrawler.getDataFromWebsite(provinceName, xoSoUrl);
            // Kiểm tra xem đã có dữ liệu cho ngày này chưa
            boolean isNewRecord = csvData.stream().noneMatch(record -> record[0].equals(provinceName) && record[10].equals(newRecord[newRecord.length - 1]));
            if (isNewRecord) {
                // Nếu có dữ liệu mới thì thêm vào
                csvData.add(newRecord);
                try (CSVWriter writer = new CSVWriter(new FileWriter(csvFilePath))) {
                    writer.writeAll(csvData);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                System.out.println("New record added for " + provinceName);
            } else {
                System.out.println("Data already exists for " + provinceName + " on " + newRecord[newRecord.length - 1]);
            }
        }
    }
}

