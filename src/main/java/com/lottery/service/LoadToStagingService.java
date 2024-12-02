package com.lottery.service;

import com.lottery.entity.Config;
import com.lottery.entity.Log;
import com.lottery.entity.StagingLottery;
import com.lottery.repository.StagingLotteryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.FileReader;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class LoadToStagingService {
    private final JdbcTemplate jdbcTemplate;
    private final ControlService controlService;
    private final StagingLotteryRepository stagingLotteryRepository;

    // Phương thức load dữ liệu vào bảng staging từ file CSV
    public void loadDataToStaging(Config config) {
        if (config.getType() == Config.Type.LOAD_TO_STAGING) {
            String csvFilePath = config.getSourceLocation();

            // Bắt đầu giao dịch
            jdbcTemplate.execute("START TRANSACTION");

            try (BufferedReader br = new BufferedReader(new FileReader(csvFilePath))) {
                String line;
                br.readLine(); // Bỏ qua dòng tiêu đề
                // Đọc từng dòng trong file CSV
                while ((line = br.readLine()) != null) {
                    String[] values = line.split(",");
                    // Kiểm tra số lượng cột trong mỗi dòng
                    if (values.length < 11) {
                        controlService.insertLog(config, null, LocalDate.now(),
                                Log.LogStatus.FAILURE, null, null, "Dòng không hợp lệ: " + line);
                        throw new RuntimeException("Số lượng cột không đủ ở dòng: " + line);
                    }

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
                    } catch (Exception e) {
                        // Log lỗi nếu có lỗi với một record
                        controlService.insertLog(config, values[0].trim(), LocalDate.now(),
                                Log.LogStatus.FAILURE, null, null, "Lỗi ở dòng: " + line);
                        throw new RuntimeException("Lỗi khi xử lý dòng: " + line, e);
                    }
                }

                // Commit nếu không có lỗi nào
                jdbcTemplate.execute("COMMIT");

                // Log thành công khi dữ liệu đã được load vào bảng staging_lottery
                controlService.insertLog(config, null, LocalDate.now(),
                        Log.LogStatus.SUCCESS, null, null, "Toàn bộ dữ liệu đã được load thành công.");
            } catch (Exception e) {
                // Rollback nếu có bất kỳ lỗi nào
                jdbcTemplate.execute("ROLLBACK");

                // Log lỗi khi có lỗi trong quá trình đọc file CSV hoặc xử lý dữ liệu
                controlService.insertLog(config, null, LocalDate.now(),
                        Log.LogStatus.FAILURE, null, null, "Lỗi khi xử lý file CSV: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
}
