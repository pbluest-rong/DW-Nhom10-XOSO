package soxo.get_datasources;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

public class WebSrawler {
    public static final String TPHCM_URL = "https://www.xoso.net/getkqxs/tp-hcm";
    public static final String DONGTHAP_URL = "https://www.xoso.net/getkqxs/dong-thap";
    public static final String CAMAU_URL = "https://www.xoso.net/getkqxs/ca-mau";

    public static String[] getDataFromWebsite(String province, String xoSoUrl) {
        String[] data = new String[11];
        try {
            LocalDate today = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
            String formattedDate = today.format(formatter);

            // Crawl dữ liệu từ trang web
            Document doc = Jsoup.connect(xoSoUrl + "/" + formattedDate + ".js").get();
            String[] targetClasses = {"giaidb", "giai1", "giai2", "giai3", "giai4", "giai5", "giai6", "giai7", "giai8"};
            data[0] = province; // Ví dụ: TPHCM, Đồng Tháp, v.v.
            int index = 1;

            for (String className : targetClasses) {
                Elements tds = doc.select("td." + className);
                for (Element td : tds) {
                    data[index++] = td.text(); // Lưu nội dung giải vào mảng
                }
            }
            Element selectElement = doc.getElementById("box_kqxs_ngay");
            Element selectedOption = selectElement.selectFirst("option[selected]");
            String selectedDateText;
            if (selectedOption != null) {
                selectedDateText = selectedOption.text();
            } else {
                selectedDateText = "";
            }
            data[10] = selectedDateText; // Ngày tháng

        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

    public static void main(String[] args) {
        System.out.println(Arrays.toString(WebSrawler.getDataFromWebsite("TPHCM_URL", TPHCM_URL)));
    }
}
