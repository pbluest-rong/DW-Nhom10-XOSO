CREATE
DATABASE IF NOT EXISTS `lottery_dw_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE
`lottery_dw_db`;

CREATE TABLE `date`
(
    `id`    INT(11) NOT NULL AUTO_INCREMENT,
    `day`   INT(11) DEFAULT NULL,
    `month` INT(11) DEFAULT NULL,
    `year`  INT(11) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `file_configs`
(
    `config_id`       INT(11) NOT NULL AUTO_INCREMENT,
    `type`            ENUM('CRAWL_DATA','LOAD_TO_STAGING','LOAD_TO_DW') NOT NULL,
    `province`        VARCHAR(255) DEFAULT NULL,
    `date`            DATE         DEFAULT NULL,
    `url`             VARCHAR(255) DEFAULT NULL,
    `file_path`   VARCHAR(255) DEFAULT NULL,
    `table_warehouse` VARCHAR(50)  NOT NULL,
    `table_staging`   VARCHAR(50)  NOT NULL,
    `schedule`        BIGINT(20) NOT NULL,
    PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `file_logs`
(
    `log_id`     INT(11) NOT NULL AUTO_INCREMENT,
    `config_id`  INT(11) NOT NULL,
    `start_time` DATETIME NOT NULL,
    `end_time`   DATETIME NOT NULL,
    `status`     ENUM('SUCCESS','ERROR', 'FAIL') NOT NULL,
    `error`      VARCHAR(255) DEFAULT NULL,
    `isDeletedFile` BIT DEFAULT 0,
    PRIMARY KEY (`log_id`),
    KEY          `fk_config_id` (`config_id`),
    FOREIGN KEY (`config_id`) REFERENCES `file_configs` (`config_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `lottery`
(
    `id`            INT(11) NOT NULL AUTO_INCREMENT,
    `province_id`   INT(11) NOT NULL,
    `date_id`       INT(11) NOT NULL,
    `prize_special` VARCHAR(255) DEFAULT NULL,
    `prize_one`     VARCHAR(255) DEFAULT NULL,
    `prize_two`     VARCHAR(255) DEFAULT NULL,
    `prize_three`   VARCHAR(255) DEFAULT NULL,
    `prize_four`    VARCHAR(255) DEFAULT NULL,
    `prize_five`    VARCHAR(255) DEFAULT NULL,
    `prize_six`     VARCHAR(255) DEFAULT NULL,
    `prize_seven`   VARCHAR(255) DEFAULT NULL,
    `prize_eight`   VARCHAR(255) DEFAULT NULL,
    `expire_date`   DATETIME     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY             `province_id` (`province_id`),
    KEY             `date_id` (`date_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `province`
(
    `id`   INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `staging_lottery`
(
    `id`            INT(11) NOT NULL AUTO_INCREMENT,
    `province`      VARCHAR(50)  NOT NULL,
    `prize_special` VARCHAR(255) DEFAULT NULL,
    `prize_one`     VARCHAR(255) DEFAULT NULL,
    `prize_two`     VARCHAR(255) DEFAULT NULL,
    `prize_three`   VARCHAR(255) DEFAULT NULL,
    `prize_four`    VARCHAR(255) DEFAULT NULL,
    `prize_five`    VARCHAR(255) DEFAULT NULL,
    `prize_six`     VARCHAR(255) DEFAULT NULL,
    `prize_seven`   VARCHAR(255) DEFAULT NULL,
    `prize_eight`   VARCHAR(255) DEFAULT NULL,
    `date`          VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `file_logs`
    ADD CONSTRAINT `fk_config_id` FOREIGN KEY (`config_id`) REFERENCES `file_configs` (`config_id`);

ALTER TABLE `lottery`
    ADD CONSTRAINT `lottery_ibfk_1` FOREIGN KEY (`province_id`) REFERENCES `province` (`id`),
    ADD CONSTRAINT `lottery_ibfk_2` FOREIGN KEY (`date_id`) REFERENCES `date` (`id`);
COMMIT;