package soxo.transform_data;

import db.Dao;
import entity.StagingLottery;
import enums.ConfigStatus;
import enums.ConfigType;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 1. select data from staging_lottery table
 * 2. transform data: date table, province table
 * 3. insert for lottery table
 * 4. insert to file_log, file_config
 */
public class TransformData {
    public static void run(long schedule) {
        Integer configId = null;
        Dao dao = Dao.getInstance();
        // 2. select data from staging_lottery table
        List<StagingLottery> stagingLotteries = dao.selectStagingLottery();
        // 2. Transform => insert date table, province table
        for (StagingLottery sl : stagingLotteries) {
            LocalDateTime startTime = LocalDateTime.now();
            String[] dateParts = sl.getDate().split("/");
            // Lấy ngày, tháng, năm từ mảng dateParts
            String day = dateParts[0];
            String month = dateParts[1];
            String year = dateParts[2];

            int dayInt = Integer.parseInt(day);
            int monthInt = Integer.parseInt(month);
            int yearInt = Integer.parseInt(year);

            try {
                dao.insertDate(dayInt, monthInt, yearInt);
                dao.insertProvince(sl.getProvince());
                // 3. insert lottery table với các giá trị lấy từ staging_lottery
                Integer dateId = dao.getDateId(dayInt, monthInt, yearInt);
                Integer provinceId = dao.getProvinceId(sl.getProvince());

                // dw chưa có (dựa vào ngày, tỉnh) -> insert
                // dw có rồi (dựa vào ngày, tỉnh) -> update = insert + ngày thêm
                if (dateId != null && provinceId != null) {
                    dao.insertLottery(provinceId, dateId, sl.getPrizeSpecial(), sl.getPrizeOne(), sl.getPrizeTwo(),
                            sl.getPrizeThree(), sl.getPrizeFour(), sl.getPrizeFive(), sl.getPrizeSix(),
                            sl.getPrizeSeven(), sl.getPrizeEight(), LocalDateTime.now());
                }
                LocalDateTime endTime = LocalDateTime.now();
                configId = dao.insertFileConfig(ConfigType.LOAD_TO_DW, sl.getProvince(), LocalDate.of(yearInt, monthInt, dayInt), null, null, "lottery", "staging_lottery", schedule);
                dao.insertFileLog(configId, startTime, endTime, ConfigStatus.SUCCESS, null);
            } catch (Exception e) {
                String error = "Lỗi khi lưu dữ liệu vào dim và fact";
                LocalDateTime endTime = LocalDateTime.now();
                if (configId == null) {
                    configId = dao.insertFileConfig(ConfigType.LOAD_TO_DW, sl.getProvince(), LocalDate.of(yearInt, monthInt, dayInt), null, null, "lottery", "staging_lottery", schedule);
                }
                if (configId != null) {
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.ERROR, error);
                }
            }
        }
    }

    public static void main(String[] args) {
        run(5000);
    }
}
