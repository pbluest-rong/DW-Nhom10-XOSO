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
        controlService.autoCreateConfigs(LocalDate.of(2024, 11, 30));
        // Lấy danh sách unfinished configs
        List<Config> unfinishedConfigs = controlService.getUnfinishedConfigs();
        System.out.println(unfinishedConfigs);

        // Nhóm configs theo Type
        Map<Config.Type, List<Config>> groupedConfigs = unfinishedConfigs.stream()
                .filter(Objects::nonNull) // Lọc bỏ các config null
                .collect(Collectors.groupingBy(Config::getType));

        // Xử lý từng nhóm
        groupedConfigs.getOrDefault(Config.Type.CRAWL_DATA, List.of())
                .forEach(crawlService::crawlDataAndExportCSV);

        groupedConfigs.getOrDefault(Config.Type.LOAD_TO_STAGING, List.of())
                .forEach(loadToStagingService::loadDataToStaging);

        groupedConfigs.getOrDefault(Config.Type.LOAD_TO_DW, List.of())
                .forEach(loadToDWService::transformAndLoadDataToWarehouse);
    }
}
