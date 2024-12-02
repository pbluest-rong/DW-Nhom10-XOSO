package com.lottery.service;

import com.lottery.entity.Config;
import com.lottery.entity.Log;
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
public class LoadToDWService {
    private final JdbcTemplate jdbcTemplate;
    private final ControlService controlService;

    public void transformAndLoadDataToWarehouse(Config config) {
        try {
            // 1. Thực thi thủ tục lưu trữ 'transform_load_data_to_warehouse' trong cơ sở dữ liệu
            jdbcTemplate.execute("CALL transform_load_data_to_warehouse()");
            // 2. Ghi log trạng thái thành công
            controlService.insertLog(
                    config, "", LocalDate.now(),
                    Log.LogStatus.SUCCESS,
                    null,
                    null,
                    "transform and load data to warehouse đã được thực thi thành công."
            );
        } catch (Exception e) {
            // 3. Ghi log trạng thái thất bại nếu có lỗi
            controlService.insertLog(config, "", LocalDate.now(),
                    Log.LogStatus.FAILURE, null, null, "Lỗi khi thực thi thủ tục chuyển dữ liệu vào data warehouse: " + e.getMessage());
        }
    }
}
