package soxo.transform_data_to_dw;

import db.Dao;
import entity.StagingLottery;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 1. select data from staging_lottery table
 * 2. transform data: date table, province table
 * 3. insert for lottery table
 * 4. insert to file_log, file_config
 */
public class TransformData {
    public static void run() {
        Dao dao = Dao.getInstance();
        // 2. select data from staging_lottery table
        List<StagingLottery> stagingLotteries = dao.selectStagingLottery();
        // 2. Transform => insert date table, province table
        for (StagingLottery sl : stagingLotteries) {
            dao.insertDate(sl.getDate().getDayOfMonth(), sl.getDate().getMonthValue(), sl.getDate().getYear());
            dao.insertProvince(sl.getProvince());
            // 3. insert lottery table với các giá trị lấy từ staging_lottery
            Integer dateId = dao.getDateId(sl.getDate().getDayOfMonth(), sl.getDate().getMonthValue(), sl.getDate().getYear());
            Integer provinceId = dao.getProvinceId(sl.getProvince());

            if (dateId != null && provinceId != null) {
                dao.insertLottery(provinceId, dateId, sl.getPrizeSpecial(), sl.getPrizeOne(), sl.getPrizeTwo(),
                        sl.getPrizeThree(), sl.getPrizeFour(), sl.getPrizeFive(), sl.getPrizeSix(),
                        sl.getPrizeSeven(), sl.getPrizeEight());
            }
            // 4. insert to file_log, file_config
            String trackingDateTime = LocalDateTime.now().toString(); // or any appropriate timestamp
            String source = "YourSource"; // Define the source based on your requirements
            int connectStatus = 1; // Assuming success
            String destination = "YourDestination"; // Define based on your logic
            String phase = "Insert"; // Define the phase based on your process
            String result = "Success"; // Define the result based on your logic
            String detail = "Inserted lottery data"; // Additional detail for the log
            boolean isDelete = false; // Specify if this is a delete operation

            dao.insertFileLog(trackingDateTime, source, connectStatus, destination, phase, result, detail, isDelete);

            // 6. Insert into file_config (modify as necessary based on your logic)
            // Assuming you have values for file_config attributes
            String phaseConfig = "Phase"; // Define this value based on your logic
            String sourceName = "SourceName"; // Define this value based on your logic
            String area = "Area"; // Define this value based on your logic
            String pathToSave = "Path/To/Save"; // Define the save path
            String fileNameFormat = "file_format"; // Define the file name format
            String fileType = "csv"; // Define the file type
            String timeGetData =trackingDateTime; // Define the time for getting data
            int interval = 30; // Define the interval
            String createDate = LocalDateTime.now().toString(); // Set the current time as create date
            String updateDate = createDate; // Set the same for update date
            String description = "Config description"; // Define the description
            int status = 1; // Define the status

            dao.insertFileConfig(phaseConfig, source, sourceName, area, pathToSave, fileNameFormat,
                    fileType, timeGetData, interval, createDate, updateDate, description, status);
        }
    }

    public static void main(String[] args) {
        run();
    }
}
