package soxo.get_datasources;

public class DataSourcesRun {
    public static void main(String[] args) {
        String csvFilePath = "sources/XSVN.csv";
        WebCrawler.PROVINCE_URLS.forEach((province, url) -> {
            CSVHelper.updateCSVIfNewData(csvFilePath, url, province);
        });
    }
}