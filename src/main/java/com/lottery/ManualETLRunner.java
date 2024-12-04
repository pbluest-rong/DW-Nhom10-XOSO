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
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ManualETLRunner {
    private final ControlService controlService;
    private final CrawlService crawlService;
    private final LoadToDWService loadToDWService;
    private final LoadToStagingService loadToStagingService;

    public void runETLProcess() {
        // 1. Lấy danh sách cấu hình chưa hoàn thành
        List<Config> unfinishedConfigs = controlService.getUnfinishedConfigs();
        // 2. Nhóm các cấu hình theo loại
        Map<Config.Type, List<Config>> groupedConfigs = unfinishedConfigs.stream()
                .filter(Objects::nonNull) // Lọc bỏ các config null
                .collect(Collectors.groupingBy(Config::getType));
        // 2.1 CRAWL_DATA
//        groupedConfigs.getOrDefault(Config.Type.CRAWL_DATA, List.of())
//                .forEach(crawlService::crawlDataAndExportCSV);
        // 2.2 LOAD_TO_STAGING
//        groupedConfigs.getOrDefault(Config.Type.LOAD_TO_STAGING, List.of())
//                .forEach(loadToStagingService::loadDataToStaging);
//        // 2.3 LOAD_TO_DW
        groupedConfigs.getOrDefault(Config.Type.LOAD_TO_DW, List.of())
                .forEach(loadToDWService::transformAndLoadDataToWarehouse);
    }
}
