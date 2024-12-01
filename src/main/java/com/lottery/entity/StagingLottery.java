package com.lottery.entity;

import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "staging_lottery")
public class StagingLottery {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String province;
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
    private String date;
}
