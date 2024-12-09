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

        // 1. Chạy Scheduler quá trình crawl dữ liệu vào lúc 16:30
        @Scheduled(cron = "0 30 16 * * ?")
        public void scheduleCrawlProcess() {
            // 2. Lấy danh sách config chưa có log trang thái hoàn thành
            List<Config> configList = controlService.getUnfinishedConfigs();
            // 3. Tạo vòng lặp để duyệt từng config
            for (Config config : configList) {
                // 4. Kiểm tra type của config là CRAW_DATA
                if (config.getType() == Config.Type.CRAWL_DATA)
                    crawlService.crawlDataAndExportCSV(config);
            }
        }

        // 1. Chạy Scheduler tải dữ liệu vào Staging vào lúc 16h40 hằng ngày
        @Scheduled(cron = "0 40 16 * * ?")
        public void scheduleLoadStagingProcess() {
            // 2. Lấy danh sách config chưa có log trang thái hoàn thành
            List<Config> configList = controlService.getUnfinishedConfigs();
            // 3. Tạo vòng lặp để duyệt từng config
            // 4. Kiểm tra đã duyệt hết danh sách config
            for (Config config : configList) {
                //5. Kiểm tra type của config là LOAD_TO_STAGING
                if (config.getType() == Config.Type.LOAD_TO_STAGING)
                    loadToStagingService.loadDataToStaging(config);
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
