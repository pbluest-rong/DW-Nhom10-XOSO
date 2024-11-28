package com.lottery;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

public class AutoScheduler {

    @Component
    public class ETLScheduler {
        // Lên lịch chạy ETL Process mỗi ngày vào 1h sáng
        @Scheduled(cron = "0 0 1 * * ?")  // Lịch chạy: mỗi ngày vào lúc 1h sáng
        public void scheduleETLProcess() {

        }
    }
}
