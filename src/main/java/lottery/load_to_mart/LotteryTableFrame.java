package lottery.load_to_mart;

import entity.DataMart;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.time.LocalDate;
import java.util.List;

public class LotteryTableFrame extends JFrame {
    public LotteryTableFrame(List<DataMart> dataMartList) {
        setTitle("Lottery Data " + LocalDate.now());
        setSize(1200, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Cấu hình bảng
        String[] columnNames = {
                "ID", "Province", "Prize Special", "Prize One", "Prize Two",
                "Prize Three", "Prize Four", "Prize Five", "Prize Six",
                "Prize Seven", "Prize Eight"
        };

        DefaultTableModel model = new DefaultTableModel(columnNames, 0);
        for (DataMart data : dataMartList) {
            model.addRow(new Object[]{
                    data.getId(), data.getProvince(), data.getPrizeSpecial(), data.getPrizeOne(),
                    data.getPrizeTwo(), data.getPrizeThree(), data.getPrizeFour(), data.getPrizeFive(),
                    data.getPrizeSix(), data.getPrizeSeven(), data.getPrizeEight()
            });
        }

        JTable table = new JTable(model);
        JScrollPane scrollPane = new JScrollPane(table);

        // Thêm bảng vào JFrame
        add(scrollPane, BorderLayout.CENTER);
    }
}
