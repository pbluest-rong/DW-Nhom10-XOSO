package com.lottery.service;

import com.lottery.entity.ProvinceDim;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class LoadService {
    private final JdbcTemplate jdbcTemplate;
    private final LoggingService loggingService;

    public void loadDataToStaging() {
        // Lấy file path trong config
        String filePath = "csv-data-sources/27112024_XSVN.csv";
        insertLotteryDataFromCSV(filePath);
    }

    public void transformAndLoadDataToWarehouse() {
        loggingService.logProcess("Load Data", "Starting data loading to warehouse", "IN_PROGRESS");
        try {
            jdbcTemplate.execute("CALL transform_load_data_to_warehouse()");

            loggingService.logProcess("Load Data", "Successfully loaded data to warehouse", "SUCCESS");

        } catch (Exception e) {
            loggingService.logProcess("Load Data", "Error loading data to warehouse: " + e.getMessage(), "ERROR");
        }
    }

    private void insertLotteryDataFromCSV(String csvFilePath) {
        SimpleJdbcCall simpleJdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("load_To_staging_lottery");

        try (BufferedReader br = new BufferedReader(new FileReader(csvFilePath))) {
            String line;
            br.readLine(); // Bỏ qua dòng tiêu đề

            while ((line = br.readLine()) != null) {
                String[] values = line.split(",");

                // Kiểm tra số lượng cột
                if (values.length < 11) {
                    System.err.println("Dòng không hợp lệ: " + line);
                    continue;
                }

                // Tạo tham số đầu vào cho Stored Procedure
                Map<String, Object> params = new HashMap<>();
                params.put("p_province", values[0].trim());
                params.put("p_prize_special", values[1].trim());
                params.put("p_prize_one", values[2].trim());
                params.put("p_prize_two", values[3].trim());
                params.put("p_prize_three", values[4].trim());
                params.put("p_prize_four", values[5].trim());
                params.put("p_prize_five", values[6].trim());
                params.put("p_prize_six", values[7].trim());
                params.put("p_prize_seven", values[8].trim());
                params.put("p_prize_eight", values[9].trim().isEmpty() ? null : values[9].trim());
                params.put("p_date", values[10].trim());

                try {
                    // Gọi Stored Procedure
                    simpleJdbcCall.execute(params);
                } catch (Exception e) {
                    System.err.println("Lỗi khi gọi procedure cho dòng: " + line);
                    e.printStackTrace();
                }
            }
            System.out.println("Dữ liệu đã được thêm vào bảng staging_lottery.");
        } catch (Exception e) {
            System.err.println("Lỗi khi đọc file CSV.");
            e.printStackTrace();
        }
    }
}
