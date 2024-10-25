package soxo.get_datasources;

public class GetDataToCSV {
    public static void run(String csvFilePath) {
        WebCrawler.PROVINCE_URLS.forEach((province, url) -> {
            CSVHelper.updateCSVIfNewData(csvFilePath, url, province);
        });
    }

    public static void main(String[] args) {
        String csvFilePath = "sources/XSVN.csv";
        GetDataToCSV.run(csvFilePath);
    }
}