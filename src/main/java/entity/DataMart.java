package entity;

public class DataMart {
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

    public DataMart() {
    }

    public DataMart(int id, String province, String prizeSpecial, String prizeOne, String prizeTwo, String prizeThree, String prizeFour, String prizeFive, String prizeSix, String prizeSeven, String prizeEight) {
        this.id = id;
        this.province = province;
        this.prizeSpecial = prizeSpecial;
        this.prizeOne = prizeOne;
        this.prizeTwo = prizeTwo;
        this.prizeThree = prizeThree;
        this.prizeFour = prizeFour;
        this.prizeFive = prizeFive;
        this.prizeSix = prizeSix;
        this.prizeSeven = prizeSeven;
        this.prizeEight = prizeEight;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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
}
