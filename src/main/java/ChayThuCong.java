import enums.ProvinceURL;
import lottery.get_data.GetDataToCSV;
import lottery.load_to_mart.GetDataMart;
import lottery.load_to_staging.LoadDataToStaging;
import lottery.load_to_DW.LoadDataToDW;

import java.time.LocalDate;

public class ChayThuCong {
    public static void main(String[] args) {
        // get data source
//        String filePath1 = "csv-data-sources/" + GetDataToCSV.generateFileNameWithDate(LocalDate.of(2024, 11, 7));
//        GetDataToCSV.run(filePath1, ProvinceURL.QUANG_TRI.getName(), LocalDate.of(2024, 11, 7), 5000);

        String filePath2 = "csv-data-sources/" + GetDataToCSV.generateFileNameWithDate(LocalDate.now());
        GetDataToCSV.run(filePath2, ProvinceURL.QUANG_TRI.getName(), 5000);
        GetDataToCSV.run(filePath2, ProvinceURL.TP_HCM.getName(), 5000);
        for (ProvinceURL province : ProvinceURL.values()) {
            GetDataToCSV.run(filePath2, province.getName(), 5000);
        }

        // load data to staging
//        loadDataToStaging(filePath1);
        loadDataToStaging(filePath2);

        // load data to dw
        loadDataToDW();

        //get data mart
        GetDataMart.getLotteryTodayGUI();
    }

    private static void loadDataToStaging(String csvFilePath) {
        LoadDataToStaging.run(csvFilePath, 5000);
    }

    private static void loadDataToDW() {
        LoadDataToDW.run(5000);
    }
}