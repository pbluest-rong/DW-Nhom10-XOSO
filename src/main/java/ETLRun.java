import com.lottery.service.CleanService;
import com.lottery.service.CrawlService;
import com.lottery.service.LoadService;
import com.lottery.service.LoggingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
public class ETLRun {
    private final CrawlService crawlService;
    private final CleanService cleanService;
    private final LoadService loadService;
    private final LoggingService loggingService;

    public static String generateFileNameWithDate(LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("ddMMyyyy");
        String formattedDate = date.format(formatter);
        return formattedDate + "_XSVN.csv";
    }

    public void runETLProcess() {
        try {
            // Bắt đầu quy trình ETL

            // 1. Crawl Data
            String path = "csv-data-sources/"+generateFileNameWithDate(LocalDate.of(2024,1,1));
            System.out.println("path: "+path);
            crawlService.crawlDataAndExportCSV(path, LocalDate.of(2024,1,1));

            // 2. Clean Data
            cleanService.cleanData();

            // 3. Load Data to Warehouse
            loadService.loadDataToWarehouse();

            // Kết thúc quá trình ETL
            loggingService.logProcess("ETL Process", "ETL process completed successfully", "SUCCESS");

        } catch (Exception e) {
            loggingService.logProcess("ETL Process", "ETL process failed: " + e.getMessage(), "ERROR");
        }
    }

    public static void main(String[] args) {
        CrawlService crawlService = new CrawlService();
        String path = "csv-data-sources/"+generateFileNameWithDate(LocalDate.of(2024,1,1));
        crawlService.crawlDataAndExportCSV(path, LocalDate.of(2024,11,27));
//        crawlService.crawlDataAndExportCSV("csv-data-sources/"+generateFileNameWithDate(LocalDate.now()), LocalDate.now());
    }
}
