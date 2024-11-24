package lottery.load_to_DW;

import db.Dao;
import entity.StagingLottery;
import enums.ConfigStatus;
import enums.ConfigType;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class LoadDataToDW {
    public static void run(long schedule) {
        // Tải config.properties và kết nối database
        Dao dao = Dao.getInstance();
        // Lấy dữ liệu danh sách từ bảng staging_lottery
        List<StagingLottery> stagingLotteries = dao.selectStagingLottery();
        // Transform dữ liệu cho field: date, province
        for (StagingLottery sl : stagingLotteries) {
            LocalDateTime startTime = LocalDateTime.now();
            String[] dateParts = sl.getDate().split("/");
            String day = dateParts[0];
            String month = dateParts[1];
            String year = dateParts[2];

            int dayInt = Integer.parseInt(day);
            int monthInt = Integer.parseInt(month);
            int yearInt = Integer.parseInt(year);
            // Ghi config
            Integer configId = dao.insertFileConfig(ConfigType.LOAD_TO_DW, sl.getProvince(), LocalDate.of(yearInt, monthInt, dayInt), null, null, "lottery", "staging_lottery", schedule);
            try {
                // Ghi dữ liệu date
                dao.insertDate(dayInt, monthInt, yearInt);
                // Ghi dữ liệu province
                dao.insertProvince(sl.getProvince());
                // Ghi dữ liệu lottery theo thời gian
                Integer dateId = dao.getDateId(dayInt, monthInt, yearInt);
                Integer provinceId = dao.getProvinceId(sl.getProvince());
                if (dateId != null && provinceId != null) {
                    dao.insertLottery(provinceId, dateId, sl.getPrizeSpecial(), sl.getPrizeOne(), sl.getPrizeTwo(),
                            sl.getPrizeThree(), sl.getPrizeFour(), sl.getPrizeFive(), sl.getPrizeSix(),
                            sl.getPrizeSeven(), sl.getPrizeEight(), LocalDateTime.now());
                }
                LocalDateTime endTime = LocalDateTime.now();
                // Ghi log với status SUCCESS
                dao.insertFileLog(configId, startTime, endTime, ConfigStatus.SUCCESS, null);
                // Xóa record trong staging
                dao.removeStagingLottery(sl.getId());
            } catch (Exception e) {
                // Ghi log với status ERROR
                String error = "Lỗi khi lưu dữ liệu vào dim và fact";
                LocalDateTime endTime = LocalDateTime.now();
                if (configId != null)
                    dao.insertFileLog(configId, startTime, endTime, ConfigStatus.ERROR, error);
            }
        }
    }

    public static void main(String[] args) {
        run(5000);
    }
}
