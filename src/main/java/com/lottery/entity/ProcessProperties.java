package com.lottery.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "process_properties")
@Data
@NoArgsConstructor
@AllArgsConstructor
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
