package com.lottery.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Entity
@Table(name = "configs")
public class Configs {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer configId;

    private String saveLocation;
    private String tbleWarehouse;
    private String tbleStaging;
    private String url;
    private String fileName;
    private Long schedule;

    @Column(columnDefinition = "TEXT")
    private String stagingFields;

    @Column(columnDefinition = "TEXT")
    private String dwFields;

    private String fieldsTerminatedBy;
    private String optionallyEnclosedBy;
    private String linesTerminatedBy;
    private Integer ignoreRows;
    private String stagingTable;

    private Integer propertyId;
}
