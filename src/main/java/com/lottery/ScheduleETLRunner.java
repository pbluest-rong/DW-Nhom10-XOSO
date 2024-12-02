package com.lottery;

import com.lottery.entity.Config;
import com.lottery.service.ControlService;
import com.lottery.service.CrawlService;
import com.lottery.service.LoadToDWService;
import com.lottery.service.LoadToStagingService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cglib.core.Local;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class ScheduleETLRunner {
    private final ControlService controlService;
    private final CrawlService crawlService;
    private final LoadToDWService loadToDWService;
    private final LoadToStagingService loadToStagingService;


    @Value("${etl.resource-parent}")
    private boolean resourceParentPath;

    @Component
    public class ETLScheduler {
        @Scheduled(cron = "0 45 15 * * ?")
        public void scheduleCreateConfig() {
            LocalDate today = LocalDate.now();
            createCrawlConfigs(today);
            boolean isNow = false;
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
            List<Config> configList = controlService.getUnfinishedConfigs(today);
            if (!configList.isEmpty()) {
                Config config = configList.get(0);
                Config c = new Config();
                c.setName("Load staging ");
                c.setType(Config.Type.LOAD_TO_STAGING);
                c.setCreateAt(LocalDate.now());
                c.setSourceLocation(config.getSourceLocation());
                c.setDestinationTableStaging(config.getDestinationTableStaging());
                c.setDestinationTableDW(config.getDestinationTableDW());
                controlService.saveConfig(c);
            }
            Config config_dw = new Config();
            config_dw.setName("Load DW");
            config_dw.setType(Config.Type.LOAD_TO_DW);
            config_dw.setCreateAt(LocalDate.now());
            config_dw.setDestinationTableStaging("staging_lottery");
            config_dw.setDestinationTableDW("lotterry");
            controlService.saveConfig(config_dw);
        }

        @Scheduled(cron = "0 15 16 * * ?")
        public void scheduleCrawlProcess() {
            // Lấy danh sách cấu hình chưa hoàn thành
            List<Config> configList = controlService.getUnfinishedConfigs();
            // Duyệt qua từng cấu hình và thực thi ETL
            for (Config config : configList) {
                switch (config.getType()) {
                    case CRAWL_DATA:
                        crawlService.crawlDataAndExportCSV(config);
                        break;
                }
            }
        }

        @Scheduled(cron = "0 20 16 * * ?")
        public void scheduleLoadStagingProcess() {
            // Lấy danh sách cấu hình chưa hoàn thành
            List<Config> configList = controlService.getUnfinishedConfigs();
            // Duyệt qua từng cấu hình và thực thi ETL
            for (Config config : configList) {
                switch (config.getType()) {
                    case LOAD_TO_STAGING:
                        loadToStagingService.loadDataToStaging(config);
                        break;
                }
            }
        }

        @Scheduled(cron = "0 25 16 * * ?")
        public void scheduleLoadDWProcess() {
            // Lấy danh sách cấu hình chưa hoàn thành
            List<Config> configList = controlService.getUnfinishedConfigs();
            // Duyệt qua từng cấu hình và thực thi ETL
            for (Config config : configList) {
                switch (config.getType()) {
                    case LOAD_TO_DW:
                        loadToDWService.transformAndLoadDataToWarehouse(config);
                        break;
                }
            }
        }
    }

    public void createCrawlConfigs(LocalDate date) {
        Map<String, String> provinceInURL = new HashMap<String, String>();
        provinceInURL.put("mien-bac", "Miền Bắc");
        provinceInURL.put("an-giang", "An Giang");
        provinceInURL.put("bac-lieu", "Bạc Liêu");
        provinceInURL.put("ben-tre", "Bến Tre");
        provinceInURL.put("binh-dinh", "Bình Định");
        provinceInURL.put("binh-duong", "Bình Dương");
        provinceInURL.put("binh-phuoc", "Bình Phước");
        provinceInURL.put("binh-thuan", "Bình Thuận");
        provinceInURL.put("ca-mau", "Cà Mau");
        provinceInURL.put("can-tho", "Cần Thơ");
        provinceInURL.put("da-lat", "Đà Lạt");
        provinceInURL.put("da-nang", "Đà Nẵng");
        provinceInURL.put("dak-lak", "Đắk Lắk");
        provinceInURL.put("dak-nong", "Đắk Nông");
        provinceInURL.put("dong-nai", "Đồng Nai");
        provinceInURL.put("dong-thap", "Đồng Tháp");
        provinceInURL.put("gia-lai", "Gia Lai");
        provinceInURL.put("hau-giang", "Hậu Giang");
        provinceInURL.put("khanh-hoa", "Khánh Hòa");
        provinceInURL.put("kien-giang", "Kiên Giang");
        provinceInURL.put("kon-tum", "Kon Tum");
        provinceInURL.put("long-an", "Long An");
        provinceInURL.put("ninh-thuan", "Ninh Thuận");
        provinceInURL.put("phu-yen", "Phú Yên");
        provinceInURL.put("quang-binh", "Quảng Bình");
        provinceInURL.put("quang-nam", "Quảng Nam");
        provinceInURL.put("quang-ngai", "Quảng Ngãi");
        provinceInURL.put("quang-tri", "Quảng Trị");
        provinceInURL.put("soc-trang", "Sóc Trăng");
        provinceInURL.put("tay-ninh", "Tây Ninh");
        provinceInURL.put("thua-thien-hue", "Thừa Thiên Huế");
        provinceInURL.put("tien-giang", "Tiền Giang");
        provinceInURL.put("tp-hcm", "TP. HCM");
        provinceInURL.put("tra-vinh", "Trà Vinh");
        provinceInURL.put("vinh-long", "Vĩnh Long");
        provinceInURL.put("vung-tau", "Vũng Tàu");

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
            config.setCreateAt(LocalDate.now());
            config.setProvince(provinceName);
            config.setSourceLocation(resourceParentPath +"\\" + formattedDate + "_XSVN.csv");
            config.setDestinationTableStaging("staging_lottery");
            config.setDestinationTableDW("lotterry");
            controlService.saveConfig(config);
        }
    }
}
