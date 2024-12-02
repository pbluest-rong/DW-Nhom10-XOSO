package com.lottery.service;

import com.lottery.entity.Config;
import com.lottery.entity.Log;
import com.lottery.repository.ConfigRepository;
import com.lottery.repository.LogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ControlService {
    private final ConfigRepository configRepository;
    private final LogRepository logRepository;

    @Value("${etl.resource-parent}")
    private String resourceParentPath = "";
    @Value("${etl.destination-table-staging}")
    private String destinationTableStaging;
    @Value("${etl.destination-table-dw}")
    private String destinationTableDW;

    public List<Config> getUnfinishedConfigs() {
        return configRepository.findUnfinishedConfigs();
    }

    public List<Config> getUnfinishedConfigs(LocalDate createdAt) {
        return configRepository.findUnfinishedConfigs(createdAt);
    }

    public Config getConfigById(Long id) {
        return configRepository.findById(id).orElse(null);
    }


    public Log insertLog(Config config, String province, LocalDate date, Log.LogStatus status,
                         Integer count, Long fileSize, String message) {
        Log log = new Log();
        log.setConfig(config);
        log.setProvince(province);
        log.setDate(date);
        log.setStatus(status);
        log.setCount(count);
        log.setFileSize(fileSize);
        log.setDtUpdate(LocalDate.now());
        log.setMessage(message);

        return logRepository.save(log);
    }

    public Config saveConfig(Config config) {
        return configRepository.save(config);
    }

    public void autoCreateConfigs(LocalDate date){
        createCrawlConfigs(date);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        List<Config> configList = getUnfinishedConfigs(date);
        if (!configList.isEmpty()) {
            Config config = configList.get(0);
            Config c = new Config();
            c.setName("Load staging ");
            c.setType(Config.Type.LOAD_TO_STAGING);
            c.setCreateAt(date);
            c.setSourceLocation(config.getSourceLocation());
            c.setDestinationTableStaging(config.getDestinationTableStaging());
            c.setDestinationTableDW(config.getDestinationTableDW());
            saveConfig(c);
        }
        Config config_dw = new Config();
        config_dw.setName("Load DW");
        config_dw.setType(Config.Type.LOAD_TO_DW);
        config_dw.setCreateAt(date);
        config_dw.setDestinationTableStaging(destinationTableStaging);
        config_dw.setDestinationTableDW(destinationTableDW);
        saveConfig(config_dw);
    }
    private void createCrawlConfigs(LocalDate date) {
        Map<String, String> provinceInURL = new HashMap<String, String>();
        provinceInURL.put("mien-bac", "Miền Bắc");
        provinceInURL.put("an-giang", "An Giang");
        provinceInURL.put("bac-lieu", "Bạc Liêu");
        provinceInURL.put("ben-tre", "Bến Tre");
        provinceInURL.put("binh-dinh", "Bình Định");
        provinceInURL.put("binh-duong", "Bình Dương");
        provinceInURL.put("binh-phuoc", "Bình Phước");
        provinceInURL.put("binh-thuan", "Bình Thuận");
//        provinceInURL.put("ca-mau", "Cà Mau");
//        provinceInURL.put("can-tho", "Cần Thơ");
//        provinceInURL.put("da-lat", "Đà Lạt");
//        provinceInURL.put("da-nang", "Đà Nẵng");
//        provinceInURL.put("dak-lak", "Đắk Lắk");
//        provinceInURL.put("dak-nong", "Đắk Nông");
//        provinceInURL.put("dong-nai", "Đồng Nai");
//        provinceInURL.put("dong-thap", "Đồng Tháp");
//        provinceInURL.put("gia-lai", "Gia Lai");
//        provinceInURL.put("hau-giang", "Hậu Giang");
//        provinceInURL.put("khanh-hoa", "Khánh Hòa");
//        provinceInURL.put("kien-giang", "Kiên Giang");
//        provinceInURL.put("kon-tum", "Kon Tum");
//        provinceInURL.put("long-an", "Long An");
//        provinceInURL.put("ninh-thuan", "Ninh Thuận");
//        provinceInURL.put("phu-yen", "Phú Yên");
//        provinceInURL.put("quang-binh", "Quảng Bình");
//        provinceInURL.put("quang-nam", "Quảng Nam");
//        provinceInURL.put("quang-ngai", "Quảng Ngãi");
//        provinceInURL.put("quang-tri", "Quảng Trị");
//        provinceInURL.put("soc-trang", "Sóc Trăng");
//        provinceInURL.put("tay-ninh", "Tây Ninh");
//        provinceInURL.put("thua-thien-hue", "Thừa Thiên Huế");
//        provinceInURL.put("tien-giang", "Tiền Giang");
//        provinceInURL.put("tp-hcm", "TP. HCM");
//        provinceInURL.put("tra-vinh", "Trà Vinh");
//        provinceInURL.put("vinh-long", "Vĩnh Long");
//        provinceInURL.put("vung-tau", "Vũng Tàu");

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        for (Map.Entry<String, String> entry : provinceInURL.entrySet()) {
            String provinceURL = entry.getKey();
            String provinceName = entry.getValue();

            String formattedDate = date.format(formatter);
            String url = (provinceURL == null) ? null : ("https://www.xoso.net/getkqxs/" + provinceURL + "/" + formattedDate + ".js");

            Config config = new Config();
            config.setName("Crawl " + provinceName);
            config.setType(Config.Type.CRAWL_DATA);
            config.setSource(url);
            config.setCreateAt(date);
            config.setProvince(provinceName);
            config.setSourceLocation(resourceParentPath +"\\" + formattedDate + "_XSVN.csv");
            config.setDestinationTableStaging(destinationTableStaging);
            config.setDestinationTableDW(destinationTableDW);
            saveConfig(config);
        }
    }
}
