package com.lottery;

import com.lottery.entity.Config;
import com.lottery.service.ControlService;
import com.lottery.service.CrawlService;
import com.lottery.service.LoadToDWService;
import com.lottery.service.LoadToStagingService;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import java.time.LocalDate;
import java.util.List;

@Component
@RequiredArgsConstructor
public class ScheduleETLRunner {
    private final ControlService controlService;
    public final CrawlService crawlService;
    private final LoadToDWService loadToDWService;
    private final LoadToStagingService loadToStagingService;

    @Component
    public class ETLScheduler {
        // Tự động tạo configs hàng ngày vào lúc 15:45
        @Scheduled(cron = "0 45 15 * * ?")
        public void scheduleAutoCreateConfig() {
            controlService.autoCreateConfigs(LocalDate.now());
        }
        // Thực thi quá trình crawl dữ liệu vào lúc 16:30
        @Scheduled(cron = "0 30 16 * * ?")
        public void scheduleCrawlProcess() {
            // Lấy danh sách cấu hình chưa hoàn thành
            List<Config> configList = controlService.getUnfinishedConfigs();
            // Duyệt qua từng cấu hình và thực thi ETL
            for (Config config : configList) {
                switch (config.getType()) {
                    case CRAWL_DATA:
                        crawlService.crawlDataAndExportCSV(config);
                        break;
                }
            }
        }
        // Thực thi quá trình tải dữ liệu vào Staging lúc 16:40
        @Scheduled(cron = "0 40 16 * * ?")
        public void scheduleLoadStagingProcess() {
            // Lấy danh sách cấu hình chưa hoàn thành
            List<Config> configList = controlService.getUnfinishedConfigs();
            // Duyệt qua từng cấu hình và thực thi ETL
            for (Config config : configList) {
                switch (config.getType()) {
                    case LOAD_TO_STAGING:
                        loadToStagingService.loadDataToStaging(config);
                        break;
                }
            }
        }
        // 1.Thực thi quá trình tải dữ liệu vào Data Warehouse lúc 16:50
        @Scheduled(cron = "0 50 16 * * ?")
        public void scheduleLoadDWProcess() {
            // 2.Lấy danh sách và kiểm tra cấu hình chưa hoàn thành
            List<Config> configList = controlService.getUnfinishedConfigs();
            // 3.Tạo vòng lặp for
            // 3.1.Duyệt qua từng config trong list
            for (Config config : configList) {
                // 3.2.Kiểm tra loại của config bằng switch-case
                switch (config.getType()) {
                    // 3.3.Nếu đúng config thì sẽ gọi phương thức 'transform_load_data_to_warehouse'
                    case LOAD_TO_DW:
                        loadToDWService.transformAndLoadDataToWarehouse(config);
                        //4.Kết thúc vòng lặp
                        break;
                }
            }
        }
    }
}
