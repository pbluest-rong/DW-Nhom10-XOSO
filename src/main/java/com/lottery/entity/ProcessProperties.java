package com.lottery.entity;

import jakarta.persistence.*;
import lombok.*;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Entity
@Table(name = "process_properties")
public class ProcessProperties {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "property_id")
    private Long propertyId;

    @Column(nullable = false)
    private String name;

    @Column(name = "header_csv", columnDefinition = "TEXT")
    private String headerCsv;

    @Column(columnDefinition = "TEXT")
    private String value;

    @Column(name = "last_modified")
    private LocalDateTime lastModified;
}
