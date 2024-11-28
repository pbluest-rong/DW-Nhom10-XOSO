package com.lottery.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
public class ETLRun {
    @Value("${etl.datasources-hub}")
    private String datasourcesHub;

    private final CrawlService crawlService;
    private final LoadService loadService;
    private final LoggingService loggingService;

    public static String generateFileNameWithDate(LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("ddMMyyyy");
        String formattedDate = date.format(formatter);
        return formattedDate + "_XSVN.csv";
    }

    public void runETLProcess() {
        try {
            // 1. Crawl Data
            LocalDate date = LocalDate.of(2024, 11, 27);
            crawlService.crawlDataAndExportCSV(datasourcesHub + generateFileNameWithDate(date), date);

            // 2. load data to Staging
            loadService.loadDataToStaging();

            // 3. Load Data to Warehouse
            loadService.transformAndLoadDataToWarehouse();

            // Kết thúc quá trình ETL
            loggingService.logProcess("ETL Process", "ETL process completed successfully", "SUCCESS");

        } catch (Exception e) {
            loggingService.logProcess("ETL Process", "ETL process failed: " + e.getMessage(), "ERROR");
        }
    }
}
