package com.lottery.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "file_logs")
public class FileLogs {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer fileLogId;

    private Integer configId;
    private String time;
    private String filePath;
    private Integer count;

    private LocalDateTime startTime;
    private LocalDateTime endTime;

    private BigDecimal fileSize;
    private LocalDateTime updateAt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Status status;

    public enum Status {
        C_RE, C_E, C_SE, C_FE, L_RE, L_P, L_SE, L_FE, L_CE
    }
}
