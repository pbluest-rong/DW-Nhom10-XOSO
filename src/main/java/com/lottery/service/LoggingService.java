package com.lottery.service;

import com.lottery.entity.ETLLog;
import com.lottery.repository.ETLLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;

@Service
@RequiredArgsConstructor
public class LoggingService {
    private final ETLLogRepository etlLogRepository;

    public void logProcess(String processName, String message, String status) {
        ETLLog log = new ETLLog();
        log.setProcessName(processName);
        log.setLogMessage(message);
        log.setStatus(status);
        log.setTimestamp(new Timestamp(System.currentTimeMillis()));
        etlLogRepository.save(log);
    }
}
