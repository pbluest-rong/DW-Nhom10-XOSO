package entity;

import enums.ConfigStatus;

import java.util.Date;

public class FileLog {

    private int logId;
    private int configId;
    private Date startTime;
    private Date endTime;
    private ConfigStatus status;
    private String error;
    private boolean isDeletedFile;  // Trường mới để lưu trạng thái xóa

    // Constructor
    public FileLog(int logId, int configId, Date startTime, Date endTime, ConfigStatus status, String error, boolean isDeletedFile) {
        this.logId = logId;
        this.configId = configId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
        this.error = error;
        this.isDeletedFile = isDeletedFile;
    }

    // Getters and Setters
    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getConfigId() {
        return configId;
    }

    public void setConfigId(int configId) {
        this.configId = configId;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public ConfigStatus getStatus() {
        return status;
    }

    public void setStatus(ConfigStatus status) {
        this.status = status;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public boolean isDeletedFile() {
        return isDeletedFile;
    }

    public void setDeletedFile(boolean deletedFile) {
        isDeletedFile = deletedFile;
    }
}