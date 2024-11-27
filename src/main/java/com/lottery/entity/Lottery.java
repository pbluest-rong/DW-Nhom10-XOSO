package com.lottery.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.util.Date;

@Entity
@Table(name = "lottery")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Lottery {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long province_id;
    private Long date_id;
    @Column(name = "prize_special")
    private String prizeSpecial;
    @Column(name = "prize_one")
    private String prizeOne;
    @Column(name = "prize_two")
    private String prizeTwo;
    @Column(name = "prize_three")
    private String prizeThree;
    @Column(name = "prize_four")
    private String prizeFour;
    @Column(name = "prize_five")
    private String prizeFive;
    @Column(name = "prize_six")
    private String prizeSix;
    @Column(name = "prize_seven")
    private String prizeSeven;
    @Column(name = "prize_eight")
    private String prizeEight;
    @Column(name = "created_at", updatable = false)
    private Date createdAt;

    private boolean isDelete;

    @Column(name = "date_delete")
    private Date dateDelete;

    @Column(name = "date_insert")
    private Timestamp dateInsert;

    @Column(name = "expired_date")
    private Date expiredDate;
}
