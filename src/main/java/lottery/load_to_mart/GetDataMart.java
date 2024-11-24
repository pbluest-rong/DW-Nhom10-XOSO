package lottery.load_to_mart;

import db.Dao;
import entity.DataMart;

import javax.swing.*;
import java.time.LocalDate;
import java.util.List;

public class GetDataMart {
    public static List<DataMart> getLottery(LocalDate date) {
        Dao dao = Dao.getInstance();
        return dao.getDataMart(date);
    }

    public static List<DataMart> getLotteryToday() {
        return getLottery(LocalDate.now());
    }

    public static void getLotteryTodayGUI() {
        SwingUtilities.invokeLater(() -> {
            LotteryTableFrame frame = new LotteryTableFrame(getLottery(LocalDate.now()));
            frame.setVisible(true);
        });
    }

    public static void getLotteryGUI(LocalDate date) {
        SwingUtilities.invokeLater(() -> {
            LotteryTableFrame frame = new LotteryTableFrame(getLottery(date));
            frame.setVisible(true);
        });
    }

    public static void main(String[] args) {
        getLotteryTodayGUI();
    }
}
