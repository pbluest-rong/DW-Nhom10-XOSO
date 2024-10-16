package soxo.get_datasources;

public class DataSourcesRun {
    public static void main(String[] args) {
        String csvFilePath = "sources/XSMN.csv";
        CSVHelper.updateCSVIfNewData(csvFilePath, WebSrawler.TPHCM_URL, "TP Hồ Chí Minh");
        CSVHelper.updateCSVIfNewData(csvFilePath, WebSrawler.DONGTHAP_URL, "Đồng Tháp");
        CSVHelper.updateCSVIfNewData(csvFilePath, WebSrawler.CAMAU_URL, "Cà Mau");
    }
}
