package soxo.load_datasource_to_staging;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;
import db.Dao;

import java.io.FileReader;
import java.io.IOException;

public class LoadDataToStaging {
    public static void run(String filePath) {
        try (CSVReader reader = new CSVReader(new FileReader(filePath))) {
            String[] line;
            reader.readNext();
            while ((line = reader.readNext()) != null) {
                if (line.length <= 11)
                    Dao.getInstance().insertStagingLottery(line[0], line[1], line[2], line[3], line[4], line[5], line[6], line[7], line[8], line[9], line[10]);
            }
        } catch (IOException | CsvValidationException e) {
            e.printStackTrace();
        }
    }

}
