package soxo.get_datasources;

import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;
import com.opencsv.exceptions.CsvValidationException;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class CSVHelper {

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

    public static void writeCSV(String filePath, List<String[]> records) {
        try (CSVWriter writer = new CSVWriter(new FileWriter(filePath))) {
            writer.writeAll(records);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void updateCSVIfNewData(String csvFilePath, String xoSoUrl, String provinceName) {
        List<String[]> csvData = CSVHelper.readCSV(csvFilePath);

        String[] newRecord = WebSrawler.getDataFromWebsite(provinceName, xoSoUrl); // Crawl dữ liệu mới (hàm bạn đã viết)

        // Kiểm tra xem đã có dữ liệu cho ngày này chưa
        boolean isNewRecord = csvData.stream().noneMatch(record -> record[0].equals(provinceName) && record[10].equals(newRecord[newRecord.length - 1]));

        if (isNewRecord) {
            // Nếu có dữ liệu mới thì thêm vào
            csvData.add(newRecord);
            CSVHelper.writeCSV(csvFilePath, csvData);
            System.out.println("New record added for " + provinceName);
        } else {
            System.out.println("Data already exists for " + provinceName + " on " + newRecord[newRecord.length - 1]);
        }
    }
}

