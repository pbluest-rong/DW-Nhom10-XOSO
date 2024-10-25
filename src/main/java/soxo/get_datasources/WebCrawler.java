package soxo.get_datasources;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class WebCrawler {
    public static final Map<String, String> PROVINCE_URLS = new HashMap<String, String>();

    static {
        PROVINCE_URLS.put("Miền Bắc", "mien-bac");
        PROVINCE_URLS.put("An Giang", "an-giang");
        PROVINCE_URLS.put("Bạc Liêu", "bac-lieu");
        PROVINCE_URLS.put("Bến Tre", "ben-tre");
        PROVINCE_URLS.put("Bình Định", "binh-dinh");
        PROVINCE_URLS.put("Bình Dương", "binh-duong");
        PROVINCE_URLS.put("Bình Phước", "binh-phuoc");
        PROVINCE_URLS.put("Bình Thuận", "binh-thuan");
        PROVINCE_URLS.put("Cà Mau", "ca-mau");
        PROVINCE_URLS.put("Cần Thơ", "can-tho");
        PROVINCE_URLS.put("Đà Lạt", "da-lat");
        PROVINCE_URLS.put("Đà Nẵng", "da-nang");
        PROVINCE_URLS.put("Đắk Lắk", "dak-lak");
        PROVINCE_URLS.put("Đắk Nông", "dak-nong");
        PROVINCE_URLS.put("Đồng Nai", "dong-nai");
        PROVINCE_URLS.put("Đồng Tháp", "dong-thap");
        PROVINCE_URLS.put("Gia Lai", "gia-lai");
        PROVINCE_URLS.put("Hậu Giang", "hau-giang");
        PROVINCE_URLS.put("Khánh Hòa", "khanh-hoa");
        PROVINCE_URLS.put("Kiên Giang", "kien-giang");
        PROVINCE_URLS.put("Kon Tum", "kon-tum");
        PROVINCE_URLS.put("Long An", "long-an");
        PROVINCE_URLS.put("Ninh Thuận", "ninh-thuan");
        PROVINCE_URLS.put("Phú Yên", "phu-yen");
        PROVINCE_URLS.put("Quảng Bình", "quang-binh");
        PROVINCE_URLS.put("Quảng Nam", "quang-nam");
        PROVINCE_URLS.put("Quảng Ngãi", "quang-ngai");
        PROVINCE_URLS.put("Quảng Trị", "quang-tri");
        PROVINCE_URLS.put("Sóc Trăng", "soc-trang");
        PROVINCE_URLS.put("Tây Ninh", "tay-ninh");
        PROVINCE_URLS.put("Thừa Thiên Huế", "thua-thien-hue");
        PROVINCE_URLS.put("Tiền Giang", "tien-giang");
        PROVINCE_URLS.put("TP. HCM", "tp-hcm");
        PROVINCE_URLS.put("Trà Vinh", "tra-vinh");
        PROVINCE_URLS.put("Vĩnh Long", "vinh-long");
        PROVINCE_URLS.put("Vũng Tàu", "vung-tau");
    }

    public static String[] getDataFromWebsite(String province, String provinceInURL) {
        String[] data = new String[11];
        try {
            LocalDate today = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
            String formattedDate = today.format(formatter);

            // Crawl dữ liệu từ trang web
            Document doc = Jsoup.connect("https://www.xoso.net/getkqxs/" + provinceInURL + "/" + formattedDate + ".js").get();
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
        System.out.println(Arrays.toString(WebCrawler.getDataFromWebsite("TPHCM_URL", "tp-hcm")));
    }
}
