package soxo.get_datasources;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class GetDataToCSV {
    public static void run(String csvFilePath) {
        WebCrawler.PROVINCE_URLS.forEach((province, url) -> {
            CSVHelper.loadAndWrite(csvFilePath, url, province);
        });
    }
}