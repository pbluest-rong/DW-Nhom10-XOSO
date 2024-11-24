package lottery.get_data;

import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;
import com.opencsv.exceptions.CsvValidationException;
import enums.ProvinceURL;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;

public class WebCrawler {
    private static final List<String> HEADER = Arrays.asList(
            "province", "prize_special", "prize_one", "prize_two", "prize_three",
            "prize_four", "prize_five", "prize_six", "prize_seven", "prize_eight", "date"
    );

    public static String[] getDataFromWebsite(String province, LocalDate date) {
        String[] data = new String[11];
        try {
            String url = ProvinceURL.getFullURL(province, date);
            if (url == null) return data;

            // Kết nối để lấy dữ liệu => dữ liệu lưu trữ trong mảng targetClasses
            Document doc = Jsoup.connect(url).get();
            String[] targetClasses = {"giaidb", "giai1", "giai2", "giai3", "giai4", "giai5", "giai6", "giai7", "giai8"};
            data[0] = province;
            int index = 1;

            for (String className : targetClasses) {
                Elements tds = doc.select("td." + className);
                for (Element td : tds) {
                    data[index++] = td.text(); // Lưu nội dung giải vào mảng
                }
            }
            Element selectElement = doc.getElementById("box_kqxs_ngay");
            Element selectedOption = selectElement.selectFirst("option[selected]");
            String selectedDateText;
            if (selectedOption != null) {
                selectedDateText = selectedOption.text();
            } else {
                selectedDateText = "";
            }
            data[10] = selectedDateText; // Ngày tháng
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

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

    public static File loadAndWrite(String csvFilePath, String province, LocalDate date) {
        File csvFile = new File(csvFilePath);
        // Nếu file không tồn tại, tạo mới file và ghi header (nếu cần thiết)
        if (!csvFile.exists()) {
            try {
                csvFile.createNewFile();
                try (CSVWriter writer = new CSVWriter(new FileWriter(csvFilePath))) {
                    writer.writeNext(HEADER.toArray(new String[0])); // Ghi dòng header
                    String[] newRecord = WebCrawler.getDataFromWebsite(province, date);
                    List<String[]> csvData = new ArrayList<>();
                    csvData.add(newRecord);
                    writer.writeAll(csvData);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        // Nếu file đã tồn tại
        else {
            //Load dữ liệu của file
            List<String[]> csvData = readCSV(csvFilePath);
            String[] newRecord = WebCrawler.getDataFromWebsite(province, date);
            // Kiểm tra xem đã có dữ liệu xổ số cho ngày này chưa
            boolean isNewRecord = csvData.stream().noneMatch(record -> record[0].equals(province) && record[10].equals(newRecord[newRecord.length - 1]));
            if (isNewRecord) {
                // Nếu có dữ liệu mới thì thêm vào
                csvData.add(newRecord);
                try (CSVWriter writer = new CSVWriter(new FileWriter(csvFilePath))) {
                    writer.writeAll(csvData);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                System.out.println("Thêm 1 dữ liệu mới vào file: " + province);
            } else {
                System.out.println("Dữ liệu của " + province + " vào " + date + " đã tồn tại trong file: " + newRecord[newRecord.length - 1]);
            }
        }
        return csvFile;
    }
}
