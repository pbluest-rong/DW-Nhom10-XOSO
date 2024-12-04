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
        // 1. Lấy đường dẫn file CSV từ config
        String csvFilePath = config.getSourceLocation();

        // 2. Bắt đầu giao dịch
        jdbcTemplate.execute("START TRANSACTION");

        try (BufferedReader br = new BufferedReader(new FileReader(csvFilePath))) {
            // 3. Bỏ qua dòng tiêu đề
            String line;
            br.readLine();

            // 4. Đọc từng dòng dữ liệu trong file CSV
            while ((line = br.readLine()) != null) {
                // 4.1 Tách dữ liệu của dòng thành mảng các giá trị
                String[] values = line.split(",");

                // 4.2 Kiểm tra số lượng cột
                if (values.length < 11) {
                    // 4.2.1 Log lỗi và dừng lại nếu số cột không đủ
                    controlService.insertLog(config, null, LocalDate.now(),
                            Log.LogStatus.FAILURE, null, null, "Dòng không hợp lệ: " + line);
                    throw new RuntimeException("Số lượng cột không đủ ở dòng: " + line);
                }

                try {
                    // 5. Tạo đối tượng `StagingLottery` và gán dữ liệu từ dòng
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

                    // 5.1 Lưu record vào bảng staging
                    stagingLotteryRepository.save(stagingLottery);
                } catch (Exception e) {
                    // 6. Log lỗi nếu gặp lỗi khi lưu record
                    controlService.insertLog(config, values[0].trim(), LocalDate.now(),
                            Log.LogStatus.FAILURE, null, null, "Lỗi ở dòng: " + line);
                    throw new RuntimeException("Lỗi khi xử lý dòng: " + line, e);
                }
            }

            // 7. Commit giao dịch nếu không có lỗi
            jdbcTemplate.execute("COMMIT");

            // 8. Log thành công khi toàn bộ dữ liệu đã được load vào bảng staging
            controlService.insertLog(config, null, LocalDate.now(),
                    Log.LogStatus.SUCCESS, null, null, "Toàn bộ dữ liệu đã được load thành công.");
        } catch (Exception e) {
            // 9. Rollback giao dịch nếu gặp bất kỳ lỗi nào
            jdbcTemplate.execute("ROLLBACK");

            // 10. Log lỗi khi xử lý file CSV hoặc lưu dữ liệu
            controlService.insertLog(config, null, LocalDate.now(),
                    Log.LogStatus.FAILURE, null, null, "Lỗi khi xử lý file CSV: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
