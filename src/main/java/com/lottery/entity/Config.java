package com.lottery.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Entity
@Table(name = "config")
@Data
public class Config {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private Type type;

    @Column(length = 255)
    private String source;

    @Column(name = "create_at")
    private LocalDate createAt;

    @Column(length = 255)
    private String province;


    @Column(name = "source_location", length = 255)
    private String sourceLocation;

    @Column(name = "procedure_name", length = 255)
    private String procedureName;

    @Column(name = "destination_table_staging", length = 255)
    private String destinationTableStaging;

    @Column(name = "destination_table_DW", length = 255)
    private String destinationTableDW;


    public enum Type {
        CRAWL_DATA,
        LOAD_TO_STAGING,
        LOAD_TO_DW
    }

    @Override
    public String toString() {
        return "Config{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", type=" + type +
                ", source='" + source + '\'' +
                ", createAt=" + createAt +
                ", province='" + province + '\'' +
                ", sourceLocation='" + sourceLocation + '\'' +
                ", procedureName='" + procedureName + '\'' +
                ", destinationTableStaging='" + destinationTableStaging + '\'' +
                ", destinationTableDW='" + destinationTableDW + '\'' +
                '}';
    }
}
