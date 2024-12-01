package com.lottery.service;

import com.lottery.entity.Config;
import com.lottery.entity.Log;
import com.lottery.repository.ConfigRepository;
import com.lottery.repository.LogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ControlService {
    private final ConfigRepository configRepository;
    private final LogRepository logRepository;

    public List<Config> getUnfinishedConfigs() {
        return configRepository.findUnfinishedConfigs();
    }

    public List<Config> getUnfinishedConfigs(LocalDate createdAt) {
        return configRepository.findUnfinishedConfigs(createdAt);
    }

    public Config getConfigById(Long id) {
        return configRepository.findById(id).orElse(null);
    }


    public Log insertLog(Config config, String province, LocalDate date, Log.LogStatus status,
                         Integer count, Long fileSize, String message) {
        Log log = new Log();
        log.setConfig(config);
        log.setProvince(province);
        log.setDate(date);
        log.setStatus(status);
        log.setCount(count);
        log.setFileSize(fileSize);
        log.setDtUpdate(LocalDate.now());
        log.setMessage(message);

        return logRepository.save(log);
    }

    public Config saveConfig(Config config) {
        return configRepository.save(config);
    }
}
