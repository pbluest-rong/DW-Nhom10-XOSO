package entity;

import enums.ConfigType;

import java.time.LocalDate;

public class FileConfig {

    private int configId;
    private ConfigType type;
    private String province;
    private String date; // Dùng String để lưu trữ ngày theo định dạng YYYY-MM-DD
    private String url;
    private String filePath;
    private String tableWarehouse;
    private String tableStaging;
    private long schedule;

    // Constructor
    public FileConfig(int configId, ConfigType type, String province, String date, String url,
                      String filePath, String tableWarehouse, String tableStaging, long schedule) {
        this.configId = configId;
        this.type = type;
        this.province = province;
        this.date = date;
        this.url = url;
        this.filePath = filePath;
        this.tableWarehouse = tableWarehouse;
        this.tableStaging = tableStaging;
        this.schedule = schedule;
    }

    // Getters and Setters
    public int getConfigId() {
        return configId;
    }

    public void setConfigId(int configId) {
        this.configId = configId;
    }

    public ConfigType getType() {
        return type;
    }

    public void setType(ConfigType type) {
        this.type = type;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getTableWarehouse() {
        return tableWarehouse;
    }

    public void setTableWarehouse(String tableWarehouse) {
        this.tableWarehouse = tableWarehouse;
    }

    public String getTableStaging() {
        return tableStaging;
    }

    public void setTableStaging(String tableStaging) {
        this.tableStaging = tableStaging;
    }

    public long getSchedule() {
        return schedule;
    }

    public void setSchedule(long schedule) {
        this.schedule = schedule;
    }
}
