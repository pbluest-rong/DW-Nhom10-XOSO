package soxo;

import enums.ProvinceURL;
import soxo.get_data.GetDataToCSV;
import soxo.load_data.LoadDataToStaging;
import soxo.transform_data.TransformData;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class Main {
    public static void main(String[] args) {
        // get data source
        String filePath = "csv-data-sources/" + GetDataToCSV.generateFileNameWithDate(LocalDate.of(2024, 11, 7));
//        GetDataToCSV.run(filePath, ProvinceURL.QUANG_TRI.getName(), LocalDate.of(2024, 11, 7), 5000);
////
//        filePath = "csv-data-sources/" + GetDataToCSV.generateFileNameWithDate(LocalDate.now());
//        GetDataToCSV.run(filePath, ProvinceURL.QUANG_TRI.getName(), 5000);
//        GetDataToCSV.run(filePath, ProvinceURL.TP_HCM.getName(), 5000);

        // load data to staging
//        loadDataToStaging("csv-data-sources/07112024_XSVN.csv");
//        loadDataToStaging("csv-data-sources/13112024_XSVN.csv");
        transformData();
    }

    // 2. load data to staging_lottery
    private static void loadDataToStaging(String csvFilePath) {
        LoadDataToStaging.run(csvFilePath, 5000);
    }

//     3. transform data: insert lottery, date, province, file_log, file_config
    private static void transformData() {
        TransformData.run(5000);
    }
}