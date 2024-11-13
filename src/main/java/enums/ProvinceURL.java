package enums;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

public enum ProvinceURL {
    MIEN_BAC("Miền Bắc", "mien-bac"),
    AN_GIANG("An Giang", "an-giang"),
    BAC_LIEU("Bạc Liêu", "bac-lieu"),
    BEN_TRE("Bến Tre", "ben-tre"),
    BINH_DINH("Bình Định", "binh-dinh"),
    BINH_DUONG("Bình Dương", "binh-duong"),
    BINH_PHUOC("Bình Phước", "binh-phuoc"),
    BINH_THUAN("Bình Thuận", "binh-thuan"),
    CA_MAU("Cà Mau", "ca-mau"),
    CAN_THO("Cần Thơ", "can-tho"),
    DA_LAT("Đà Lạt", "da-lat"),
    DA_NANG("Đà Nẵng", "da-nang"),
    DAK_LAK("Đắk Lắk", "dak-lak"),
    DAK_NONG("Đắk Nông", "dak-nong"),
    DONG_NAI("Đồng Nai", "dong-nai"),
    DONG_THAP("Đồng Tháp", "dong-thap"),
    GIA_LAI("Gia Lai", "gia-lai"),
    HAU_GIANG("Hậu Giang", "hau-giang"),
    KHANH_HOA("Khánh Hòa", "khanh-hoa"),
    KIEN_GIANG("Kiên Giang", "kien-giang"),
    KON_TUM("Kon Tum", "kon-tum"),
    LONG_AN("Long An", "long-an"),
    NINH_THUAN("Ninh Thuận", "ninh-thuan"),
    PHU_YEN("Phú Yên", "phu-yen"),
    QUANG_BINH("Quảng Bình", "quang-binh"),
    QUANG_NAM("Quảng Nam", "quang-nam"),
    QUANG_NGAI("Quảng Ngãi", "quang-ngai"),
    QUANG_TRI("Quảng Trị", "quang-tri"),
    SOC_TRANG("Sóc Trăng", "soc-trang"),
    TAY_NINH("Tây Ninh", "tay-ninh"),
    THUA_THIEN_HUE("Thừa Thiên Huế", "thua-thien-hue"),
    TIEN_GIANG("Tiền Giang", "tien-giang"),
    TP_HCM("TP. HCM", "tp-hcm"),
    TRA_VINH("Trà Vinh", "tra-vinh"),
    VINH_LONG("Vĩnh Long", "vinh-long"),
    VUNG_TAU("Vũng Tàu", "vung-tau");

    private final String name;
    private final String url;

    // Constructor
    ProvinceURL(String name, String url) {
        this.name = name;
        this.url = url;
    }

    // Getter for name
    public String getName() {
        return name;
    }

    // Getter for url
    public String getUrl() {
        return url;
    }

    // Static method to get URL by province name
    public static String getUrlByName(String province) {
        for (ProvinceURL p : values()) {
            if (p.getName().equalsIgnoreCase(province)) {
                return p.getUrl();
            }
        }
        return null; // return null if province name not found
    }

    public static String getFullURL(String province, LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        String formattedDate = date.format(formatter);
        String provinceInURL = getUrlByName(province);
        return (provinceInURL == null) ? null : "https://www.xoso.net/getkqxs/" + provinceInURL + "/" + formattedDate + ".js";
    }
}
