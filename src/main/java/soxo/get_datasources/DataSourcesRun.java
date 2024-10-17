package soxo.get_datasources;

public class DataSourcesRun {
    public static void main(String[] args) {
        String csvFilePath = "sources/XSMN.csv";
        CSVHelper.updateCSVIfNewData(csvFilePath, WebCrawler.TPHCM_URL, "TP Hồ Chí Minh");
        CSVHelper.updateCSVIfNewData(csvFilePath, WebCrawler.DONGTHAP_URL, "Đồng Tháp");
        CSVHelper.updateCSVIfNewData(csvFilePath, WebCrawler.CAMAU_URL, "Cà Mau");
    }
}
