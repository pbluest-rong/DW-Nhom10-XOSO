package entity;

import java.time.LocalDate;

public class StagingLottery {
    private int id;
    private String province;
    private String prizeSpecial;
    private String prizeOne;
    private String prizeTwo;
    private String prizeThree;
    private String prizeFour;
    private String prizeFive;
    private String prizeSix;
    private String prizeSeven;
    private String prizeEight;
    private LocalDate date;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getPrizeSpecial() {
        return prizeSpecial;
    }

    public void setPrizeSpecial(String prizeSpecial) {
        this.prizeSpecial = prizeSpecial;
    }

    public String getPrizeOne() {
        return prizeOne;
    }

    public void setPrizeOne(String prizeOne) {
        this.prizeOne = prizeOne;
    }

    public String getPrizeTwo() {
        return prizeTwo;
    }

    public void setPrizeTwo(String prizeTwo) {
        this.prizeTwo = prizeTwo;
    }

    public String getPrizeThree() {
        return prizeThree;
    }

    public void setPrizeThree(String prizeThree) {
        this.prizeThree = prizeThree;
    }

    public String getPrizeFour() {
        return prizeFour;
    }

    public void setPrizeFour(String prizeFour) {
        this.prizeFour = prizeFour;
    }

    public String getPrizeFive() {
        return prizeFive;
    }

    public void setPrizeFive(String prizeFive) {
        this.prizeFive = prizeFive;
    }

    public String getPrizeSix() {
        return prizeSix;
    }

    public void setPrizeSix(String prizeSix) {
        this.prizeSix = prizeSix;
    }

    public String getPrizeSeven() {
        return prizeSeven;
    }

    public void setPrizeSeven(String prizeSeven) {
        this.prizeSeven = prizeSeven;
    }

    public String getPrizeEight() {
        return prizeEight;
    }

    public void setPrizeEight(String prizeEight) {
        this.prizeEight = prizeEight;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    @Override
    public String toString() {
        return "StagingLottery{" +
                "id=" + id +
                ", province='" + province + '\'' +
                ", prizeSpecial='" + prizeSpecial + '\'' +
                ", prizeOne='" + prizeOne + '\'' +
                ", prizeTwo='" + prizeTwo + '\'' +
                ", prizeThree='" + prizeThree + '\'' +
                ", prizeFour='" + prizeFour + '\'' +
                ", prizeFive='" + prizeFive + '\'' +
                ", prizeSix='" + prizeSix + '\'' +
                ", prizeSeven='" + prizeSeven + '\'' +
                ", prizeEight='" + prizeEight + '\'' +
                ", date='" + date + '\'' +
                '}' +"\n";
    }
}
