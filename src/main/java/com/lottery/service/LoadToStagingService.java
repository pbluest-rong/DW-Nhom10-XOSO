package com.lottery.service;

import com.lottery.entity.Config;
import com.lottery.entity.Log;
import com.lottery.entity.StagingLottery;
import com.lottery.repository.StagingLotteryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.FileReader;
import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class LoadToStagingService {
    private final JdbcTemplate jdbcTemplate;
    private final ControlService controlService;
    private final StagingLotteryRepository stagingLotteryRepository;

    // Phương thức load dữ liệu vào bảng staging từ file CSV
    public void loadDataToStaging(Config config) {
        // 6. Lấy đường dẫn file CSV từ config
        String csvFilePath = config.getSourceLocation();

        // 7. START Transaction
        jdbcTemplate.execute("START TRANSACTION");
        // 8. Tiến hành đọc file
        try (BufferedReader br = new BufferedReader(new FileReader(csvFilePath))) {
            // 9. Bỏ qua dòng tiêu đề
            String line;
            br.readLine();

            // 10. Tạo vòng lặp đọc từng dòng của file
            // 11. Kiểm tra hết dòng trong file
            while ((line = br.readLine()) != null) {
                String[] values = line.split(",");
                // 12. Kiểm tra số cột của dòng < 11
                if (values.length < 11) {
                    // 13. Ném ngoại lệ
                    throw new RuntimeException("Số lượng cột không đủ ở dòng: " + line);
                }
                // 14. Lưu xuống staging tương ứng với 1 dòng
                try {
                    StagingLottery stagingLottery = new StagingLottery();
                    stagingLottery.setProvince(values[0].trim());
                    stagingLottery.setPrizeSpecial(values[1].trim());
                    stagingLottery.setPrizeOne(values[2].trim());
                    stagingLottery.setPrizeTwo(values[3].trim());
                    stagingLottery.setPrizeThree(values[4].trim());
                    stagingLottery.setPrizeFour(values[5].trim());
                    stagingLottery.setPrizeFive(values[6].trim());
                    stagingLottery.setPrizeSix(values[7].trim());
                    stagingLottery.setPrizeSeven(values[8].trim());
                    stagingLottery.setPrizeEight(values[9].trim().isEmpty() ? null : values[9].trim());
                    stagingLottery.setDate(values[10].trim());
                    stagingLottery.setCreateAt(LocalDate.now());
                    stagingLotteryRepository.save(stagingLottery);
                }
                // 15. Xảy ra lỗi
                catch (Exception e) {
                    // 16. Ném ngoại lệ
                    throw new RuntimeException("Lỗi khi xử lý dòng: " + line, e);
                }
            }

            // 17. COMMIT Transaction
            jdbcTemplate.execute("COMMIT");

            // 18. Ghi log thành công
            controlService.insertLog(config, null, LocalDate.now(),
                    Log.LogStatus.SUCCESS, null, null, "Toàn bộ dữ liệu đã được load thành công.");
        } catch (Exception e) {
            // 19. ROLLBACK Transaction
            jdbcTemplate.execute("ROLLBACK");

            // 20.Ghi log thất bại
            controlService.insertLog(config, null, LocalDate.now(),
                    Log.LogStatus.FAILURE, null, null, "Lỗi khi xử lý file CSV: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
