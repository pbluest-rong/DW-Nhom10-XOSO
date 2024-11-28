package com.lottery.service;

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
    private final LoggingService loggingService;

    @Value("${etl.head-url}")
    private String headURL = "https://www.xoso.net/getkqxs/";
    @Value("${etl.tail-url}")
    private String tailURL = ".js";

    private static Map<String, String> provinceInURL = new HashMap<String, String>();

    static {
        provinceInURL.put("mien-bac", "Miền Bắc");
        provinceInURL.put("an-giang", "An Giang");
        provinceInURL.put("bac-lieu", "Bạc Liêu");
        provinceInURL.put("ben-tre", "Bến Tre");
        provinceInURL.put("binh-dinh", "Bình Định");
        provinceInURL.put("binh-duong", "Bình Dương");
        provinceInURL.put("binh-phuoc", "Bình Phước");
        provinceInURL.put("binh-thuan", "Bình Thuận");
        provinceInURL.put("ca-mau", "Cà Mau");
        provinceInURL.put("can-tho", "Cần Thơ");
        provinceInURL.put("da-lat", "Đà Lạt");
        provinceInURL.put("da-nang", "Đà Nẵng");
        provinceInURL.put("dak-lak", "Đắk Lắk");
        provinceInURL.put("dak-nong", "Đắk Nông");
        provinceInURL.put("dong-nai", "Đồng Nai");
        provinceInURL.put("dong-thap", "Đồng Tháp");
        provinceInURL.put("gia-lai", "Gia Lai");
        provinceInURL.put("hau-giang", "Hậu Giang");
        provinceInURL.put("khanh-hoa", "Khánh Hòa");
        provinceInURL.put("kien-giang", "Kiên Giang");
        provinceInURL.put("kon-tum", "Kon Tum");
        provinceInURL.put("long-an", "Long An");
        provinceInURL.put("ninh-thuan", "Ninh Thuận");
        provinceInURL.put("phu-yen", "Phú Yên");
        provinceInURL.put("quang-binh", "Quảng Bình");
        provinceInURL.put("quang-nam", "Quảng Nam");
        provinceInURL.put("quang-ngai", "Quảng Ngãi");
        provinceInURL.put("quang-tri", "Quảng Trị");
        provinceInURL.put("soc-trang", "Sóc Trăng");
        provinceInURL.put("tay-ninh", "Tây Ninh");
        provinceInURL.put("thua-thien-hue", "Thừa Thiên Huế");
        provinceInURL.put("tien-giang", "Tiền Giang");
        provinceInURL.put("tp-hcm", "TP. HCM");
        provinceInURL.put("tra-vinh", "Trà Vinh");
        provinceInURL.put("vinh-long", "Vĩnh Long");
        provinceInURL.put("vung-tau", "Vũng Tàu");
    }

    private final List<String> CSV_HEADER = Arrays.asList(
            "province", "prize_special", "prize_one", "prize_two", "prize_three",
            "prize_four", "prize_five", "prize_six", "prize_seven", "prize_eight", "date"
    );

    public void crawlDataAndExportCSV(String csvFilePath, LocalDate date) {
        for (Map.Entry<String, String> entry : provinceInURL.entrySet()) {
            String provinceURL = entry.getKey();
            String provinceName = entry.getValue();
            try {
                File csvFile = new File(csvFilePath);
                // Nếu file không tồn tại, tạo mới file và ghi header (nếu cần thiết)
                if (!csvFile.exists()) {
                    try {
                        csvFile.createNewFile();
                        try (
//                                CSVWriter writer = new CSVWriter(new FileWriter(csvFilePath))
                                CSVWriter writer = (CSVWriter) new CSVWriterBuilder(new FileWriter(csvFilePath))
                                        .withQuoteChar(CSVWriter.NO_QUOTE_CHARACTER)  // Tắt dấu ngoặc kép
                                        .build();
                        ) {
                            writer.writeNext(CSV_HEADER.toArray(new String[0]));
                            String[] newRecord = getDataFromWebsite(provinceURL, date);
                            System.out.println(newRecord);
                            if (newRecord != null && newRecord[newRecord.length - 1] != null) {
                                if (newRecord[newRecord.length - 1] != null)
                                    if (newRecord != null) {
                                        List<String[]> csvData = new ArrayList<>();
                                        csvData.add(newRecord);
                                        writer.writeAll(csvData);
                                    }
                            }
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
                    String[] newRecord = getDataFromWebsite(provinceURL, date);
                    System.out.println(newRecord);
                    if (newRecord != null && newRecord[newRecord.length - 1] != null) {
                        // Kiểm tra xem đã có dữ liệu xổ số cho ngày này chưa
                        boolean isNewRecord = csvData.stream().noneMatch(record -> record[0].equals(provinceName) && record[10].equals(newRecord[newRecord.length - 1]));
                        if (isNewRecord) {
                            // Nếu có dữ liệu mới thì thêm vào
                            csvData.add(newRecord);
                            try (
//                                CSVWriter writer = new CSVWriter(new FileWriter(csvFilePath))
                                    CSVWriter writer = (CSVWriter) new CSVWriterBuilder(new FileWriter(csvFilePath))
                                            .withQuoteChar(CSVWriter.NO_QUOTE_CHARACTER)  // Tắt dấu ngoặc kép
                                            .build();
                            ) {
                                writer.writeAll(csvData);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            System.out.println("Thêm 1 dữ liệu mới vào file: " + provinceName);
                        } else {
                            System.out.println("Dữ liệu của " + provinceName + " vào " + date + " đã tồn tại trong file: " + newRecord[newRecord.length - 1]);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }

    private String getFullURL(String province, LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        String formattedDate = date.format(formatter);
        return (province == null) ? null : headURL + province + "/" + formattedDate + tailURL;
    }

    private String[] getDataFromWebsite(String province, LocalDate date) {
        String[] data = new String[11];
        try {
            String url = getFullURL(province, date);
            if (url == null) return data;

            // Kết nối để lấy dữ liệu => dữ liệu lưu trữ trong mảng targetClasses
            Document doc = Jsoup.connect(url).get();
            String[] targetClasses = {"giaidb", "giai1", "giai2", "giai3", "giai4", "giai5", "giai6", "giai7", "giai8"};
            data[0] = provinceInURL.get(province);
            int index = 1;

            for (String className : targetClasses) {
                Elements tds = doc.select("td." + className);
                for (Element td : tds) {
                    data[index++] = td.text(); // Lưu nội dung giải vào mảng
                }
            }
            Element selectElement = doc.getElementById("box_kqxs_ngay");
            Element selectedOption = selectElement.selectFirst("option[selected]");
            String selectedDateText = null;
            if (selectedOption != null) {
                selectedDateText = selectedOption.text();
            } else {
                selectedDateText = null;
            }
////            // Kiểm tra nếu selectedDateText là null hoặc không khớp với LocalDate date
//            if (selectedDateText == null) {
//                return null; // Nếu selectedDateText là null, trả về null
//            }
//            System.out.println("date: "+selectedDateText);
////
//            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
//            LocalDate selectedDate = LocalDate.parse(selectedDateText, formatter);
////
//            // Nếu selectedDate không khớp với date, trả về null
//            if (!selectedDate.equals(date)) {
//                return null;
//            }
            data[10] = selectedDateText;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

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
}
