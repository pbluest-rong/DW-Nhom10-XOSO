package com.lottery;

import com.lottery.entity.Config;
import com.lottery.service.ControlService;
import com.lottery.service.CrawlService;
import com.lottery.service.LoadToStagingService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.time.LocalDate;

@SpringBootApplication
@EnableScheduling
@RequiredArgsConstructor
public class Application {
    @Value("${etl.isManualETL}")
    private boolean isManualETL = false;

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Bean
    public CommandLineRunner run(ManualETLRunner manualETLRunner) {
        return args -> {
            if (isManualETL) {
                manualETLRunner.runETLProcess();
            }
        };
    }
}
