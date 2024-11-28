package com.lottery;

import com.lottery.service.CrawlService;
import com.lottery.service.ETLRun;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.time.LocalDate;

@SpringBootApplication
@EnableScheduling
public class EtlApplication {

    public static void main(String[] args) {
        SpringApplication.run(EtlApplication.class, args);
    }

    @Bean
    public CommandLineRunner run(ETLRun etlRun) {
        return args -> {
            etlRun.runETLProcess();
        };
    }

}
