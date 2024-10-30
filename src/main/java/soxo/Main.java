package soxo;

import soxo.get_datasources.GetDataToCSV;
import soxo.load_datasource_to_staging.LoadDataToStaging;
import soxo.transform_data_to_dw.TransformData;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class Main {
    public static void main(String[] args) {
        getDataToCSV();
        loadDataToStaging("csv-data-sources/29102024_XSVN.csv");
        transformData();
    }

    // 1. get Data Sources ( lấy data hôm nay)
    private static void getDataToCSV() {
        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("ddMMyyyy");
        String formattedDate = today.format(formatter);
        String newFileName = formattedDate + "_XSVN.csv";
        String csvFilePath = "csv-data-sources/" + newFileName;
        GetDataToCSV.run(csvFilePath);
    }

    // 2. load data to staging_lottery
    private static void loadDataToStaging(String csvFilePath) {
        LoadDataToStaging.run(csvFilePath);
    }

    // 3. transform data: insert lottery, date, province, file_log, file_config
    private static void transformData() {
        TransformData.run();
    }
}