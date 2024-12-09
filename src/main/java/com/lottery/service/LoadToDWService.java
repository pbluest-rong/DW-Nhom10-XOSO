package com.lottery.service;

import com.lottery.entity.*;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.*;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.io.*;
import java.util.*;

@Service
@RequiredArgsConstructor
public class LoadToDWService {
    private final JdbcTemplate jdbcTemplate;
    private final ControlService controlService;

    public void transformAndLoadDataToWarehouse(Config config) {
        // 3.3.1.Đặt các bước của quá trình vào mảng
        String[] process = {"transform_load_data_to_warehouse"};
        // 3.3.2.Tạo vòng lặp duyệt từng thủ tục trong mảng để thông báo trạng thái thực thi
        // (Loop through process steps)
        for (String processSteps : process) {
            // 3.3.3.Kiểm tra trạng thái thực thi
            try {
                jdbcTemplate.execute("CALL " + processSteps + "()");
                // 3.3.3.1.Ghi log Success thực thi thành công,
                controlService.insertLog(
                        config, "", LocalDate.now(),
                        Log.LogStatus.SUCCESS,
                        null,
                        null,
                        // Thông báo "Transform and load data to warehouse thực thi thành công"
                        "Transform and load data to warehouse thực thi thành công.");
                // 3.3.4 Kết thúc quá trình
                break;
            } catch (Exception e) {
                // 3.3.3.2.Ghi log Failure lỗi thực thi,
                // Thông báo "Lỗi trong quá trình thực thi thủ tục chuyển dữ liệu vào data warehouse"
                controlService.insertLog(
                        config, "", LocalDate.now(),
                        Log.LogStatus.FAILURE,
                        null,
                        null,
                        "Lỗi khi thực thi thủ tục chuyển dữ liệu vào data warehouse: " + e.getMessage());
                // 3.3.4 Kết thúc quá trình
                break;
            }
        }
    }
}
