package com.lottery;

import com.lottery.entity.Config;
import com.lottery.service.ControlService;
import com.lottery.service.CrawlService;
import com.lottery.service.LoadToDWService;
import com.lottery.service.LoadToStagingService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cglib.core.Local;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class ScheduleETLRunner {
    private final ControlService controlService;
    private final CrawlService crawlService;
    private final LoadToDWService loadToDWService;
    private final LoadToStagingService loadToStagingService;

    @Component
    public class ETLScheduler {
        @Scheduled(cron = "0 45 15 * * ?")
        public void scheduleAutoCreateConfig() {
            controlService.autoCreateConfigs(LocalDate.now());
        }

        @Scheduled(cron = "0 15 16 * * ?")
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

        @Scheduled(cron = "0 20 16 * * ?")
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

        @Scheduled(cron = "0 25 16 * * ?")
        public void scheduleLoadDWProcess() {
            // Lấy danh sách cấu hình chưa hoàn thành
            List<Config> configList = controlService.getUnfinishedConfigs();
            // Duyệt qua từng cấu hình và thực thi ETL
            for (Config config : configList) {
                switch (config.getType()) {
                    case LOAD_TO_DW:
                        loadToDWService.transformAndLoadDataToWarehouse(config);
                        break;
                }
            }
        }
    }
}
