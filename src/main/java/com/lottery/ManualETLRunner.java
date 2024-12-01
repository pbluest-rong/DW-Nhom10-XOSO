package com.lottery;

import com.lottery.entity.Config;
import com.lottery.service.ControlService;
import com.lottery.service.CrawlService;
import com.lottery.service.LoadToDWService;
import com.lottery.service.LoadToStagingService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cglib.core.Local;
import org.springframework.stereotype.Service;

import java.io.File;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ManualETLRunner {
    private final CrawlService crawlService;
    private final LoadToDWService loadToDWService;
    private final LoadToStagingService loadToStagingService;

    public void runETLProcess(Config config) {
        if (config != null)
            switch (config.getType()) {
                case CRAWL_DATA:
                    crawlService.crawlDataAndExportCSV(config);
                    break;
                case LOAD_TO_STAGING:
                    loadToStagingService.loadDataToStaging(config);
                    break;
                case LOAD_TO_DW:
                    loadToDWService.transformAndLoadDataToWarehouse(config);
                    break;
            }
    }
}
