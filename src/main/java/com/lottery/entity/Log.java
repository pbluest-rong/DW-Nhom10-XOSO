package com.lottery.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Entity
@Table(name = "log")
@Data
public class Log {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_config", nullable = false) // Khóa ngoại
    private Config config;

    @Column(nullable = false)
    private LocalDate date;

    @Column(length = 255)
    private String province;

    @Enumerated(EnumType.STRING) // Đánh dấu sử dụng enum
    @Column(length = 50)
    private LogStatus status; // Sử dụng enum cho status

    @Column(length = 255)
    private Integer count;

    @Column(name = "file_size")
    private Long fileSize;

    @Column(name = "dt_update")
    private LocalDate dtUpdate;

    @Column(length = 255)
    private String message;

    public enum LogStatus {
        SUCCESS,
        FAILURE,
        PENDING,
        IN_PROGRESS
    }
}