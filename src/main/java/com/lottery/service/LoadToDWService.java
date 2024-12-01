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

    /**
     * Phương thức này gọi thủ tục transform_load_data_to_warehouse() để chuyển dữ liệu
     * từ staging_lottery vào bảng data warehouse (lottery).
     * Quy trình bao gồm các bước như chèn tỉnh mới, ngày mới, cập nhật dữ liệu cũ và
     * chèn các bản ghi mới vào bảng 'lottery'.
     *
     * @param config: Tham số cấu hình cần thiết cho quá trình load dữ liệu.
     */
    public void transformAndLoadDataToWarehouse(Config config) {
        if (config.getType() == Config.Type.LOAD_TO_DW) {
            try {
                // Thực thi thủ tục lưu trữ 'transform_load_data_to_warehouse' trong cơ sở dữ liệu
                jdbcTemplate.execute("CALL transform_load_data_to_warehouse()");
                controlService.insertLog(
                        config, "", LocalDate.now(),
                        Log.LogStatus.SUCCESS,
                        null,
                        null,
                        "Thủ tục 'transform_load_data_to_warehouse' đã được thực thi thành công."  // Mô tả chi tiết
                );
            } catch (Exception e) {
                controlService.insertLog(config, "", LocalDate.now(),
                        Log.LogStatus.FAILURE, null, null, "Lỗi khi thực thi thủ tục chuyển dữ liệu vào data warehouse: " + e.getMessage());
            }
        }
    }
}
