-- 1. Tạo cơ sở dữ liệu `data_mart`
CREATE DATABASE IF NOT EXISTS `data_mart`
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- 2. Sử dụng cơ sở dữ liệu `data_mart`
USE `data_mart`;

-- 3. Tạo bảng `dim_province`
CREATE TABLE IF NOT EXISTS `dim_province` (
    `province_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `province_name` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`province_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 4. Tạo bảng `dim_date`
CREATE TABLE IF NOT EXISTS `dim_date` (
    `date_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `day` INT(11) NOT NULL,
    `month` INT(11) NOT NULL,
    `year` INT(11) NOT NULL,
    PRIMARY KEY (`date_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `dim_lottery_prize` (
    `prize_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `prize_name` VARCHAR(255) NOT NULL,
    `prize_value` DECIMAL(15, 2) DEFAULT 0,
    `prize_description` VARCHAR(500) DEFAULT NULL,  -- Thêm cột mô tả giải thưởng
    PRIMARY KEY (`prize_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 6. Tạo bảng fact `fact_lottery`
CREATE TABLE IF NOT EXISTS `fact_lottery` (
    `fact_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `province_id` BIGINT(20) NOT NULL,
    `date_id` BIGINT(20) NOT NULL,
    `prize_special_id` BIGINT(20) DEFAULT NULL,
    `prize_one_id` BIGINT(20) DEFAULT NULL,
    `prize_two_id` BIGINT(20) DEFAULT NULL,
    `prize_three_id` BIGINT(20) DEFAULT NULL,
    `prize_four_id` BIGINT(20) DEFAULT NULL,
    `prize_five_id` BIGINT(20) DEFAULT NULL,
    `prize_six_id` BIGINT(20) DEFAULT NULL,
    `prize_seven_id` BIGINT(20) DEFAULT NULL,
    `prize_eight_id` BIGINT(20) DEFAULT NULL,
    `modify_date` DATE DEFAULT NULL,
    PRIMARY KEY (`fact_id`),
    FOREIGN KEY (`province_id`) REFERENCES `dim_province`(`province_id`),
    FOREIGN KEY (`date_id`) REFERENCES `dim_date`(`date_id`),
    FOREIGN KEY (`prize_special_id`) REFERENCES `dim_lottery_prize`(`prize_id`),
    FOREIGN KEY (`prize_one_id`) REFERENCES `dim_lottery_prize`(`prize_id`),
    FOREIGN KEY (`prize_two_id`) REFERENCES `dim_lottery_prize`(`prize_id`),
    FOREIGN KEY (`prize_three_id`) REFERENCES `dim_lottery_prize`(`prize_id`),
    FOREIGN KEY (`prize_four_id`) REFERENCES `dim_lottery_prize`(`prize_id`),
    FOREIGN KEY (`prize_five_id`) REFERENCES `dim_lottery_prize`(`prize_id`),
    FOREIGN KEY (`prize_six_id`) REFERENCES `dim_lottery_prize`(`prize_id`),
    FOREIGN KEY (`prize_seven_id`) REFERENCES `dim_lottery_prize`(`prize_id`),
    FOREIGN KEY (`prize_eight_id`) REFERENCES `dim_lottery_prize`(`prize_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 7. Tạo bảng tạm thời để chứa dữ liệu từ `lottery_db` (ETL)
CREATE TABLE IF NOT EXISTS `staging_lottery` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `province` VARCHAR(255) DEFAULT NULL,
    `date` VARCHAR(255) DEFAULT NULL,
    `prize_special` VARCHAR(255) DEFAULT NULL,
    `prize_one` VARCHAR(255) DEFAULT NULL,
    `prize_two` VARCHAR(255) DEFAULT NULL,
    `prize_three` VARCHAR(255) DEFAULT NULL,
    `prize_four` VARCHAR(255) DEFAULT NULL,
    `prize_five` VARCHAR(255) DEFAULT NULL,
    `prize_six` VARCHAR(255) DEFAULT NULL,
    `prize_seven` VARCHAR(255) DEFAULT NULL,
    `prize_eight` VARCHAR(255) DEFAULT NULL,
    `modify_date` DATE DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
-- 7. Chèn dữ liệu từ nguồn `lottery_db` vào bảng tạm thời `staging_lottery`
INSERT INTO `staging_lottery` 
(`province`, `date`, `prize_special`, `prize_one`, `prize_two`, `prize_three`, `prize_four`, 
 `prize_five`, `prize_six`, `prize_seven`, `prize_eight`, `modify_date`)
SELECT 
    p.`name` AS `province`,  -- Cột `name` trong bảng `province` thay cho `province_name`
    STR_TO_DATE(CONCAT(d.`year`, '-', d.`month`, '-', d.`day`), '%Y-%m-%d') AS `date`,  -- Kết hợp year, month, day thành một ngày hợp lệ
    l.`prize_special`,      -- Giải đặc biệt từ bảng `lottery_db.lottery`
    l.`prize_one`,          -- Giải nhất từ bảng `lottery_db.lottery`
    l.`prize_two`,          -- Giải nhì từ bảng `lottery_db.lottery`
    l.`prize_three`,        -- Giải ba từ bảng `lottery_db.lottery`
    l.`prize_four`,         -- Giải tư từ bảng `lottery_db.lottery`
    l.`prize_five`,         -- Giải năm từ bảng `lottery_db.lottery`
    l.`prize_six`,          -- Giải sáu từ bảng `lottery_db.lottery`
    l.`prize_seven`,        -- Giải bảy từ bảng `lottery_db.lottery`
    l.`prize_eight`,        -- Giải tám từ bảng `lottery_db.lottery`
    l.`modify_date`         -- Lấy giá trị `modify_date` từ bảng `lottery_db.lottery`
FROM 
    `lottery_db`.`lottery` l
JOIN 
    `lottery_db`.`province` p ON l.province_id = p.id  -- Nối với cột `id` trong bảng `province`
JOIN 
    `lottery_db`.`date` d ON l.date_id = d.id;          -- Nối với cột `id` trong bảng `date`

-- 8. Insert dữ liệu vào `dim_province` từ `lottery_db.province`
INSERT INTO `dim_province` (`province_name`)
SELECT DISTINCT `name`
FROM `lottery_db`.`province`;

-- 9. Insert dữ liệu vào `dim_date` từ `lottery_db.date`
INSERT INTO `dim_date` (`day`, `month`, `year`)
SELECT `day`, `month`, `year`
FROM `lottery_db`.`date`;

INSERT INTO `dim_lottery_prize` (`prize_name`, `prize_description`)
SELECT DISTINCT `prize_special`, 'prize_special' FROM `lottery_db`.`lottery` WHERE `prize_special` IS NOT NULL
UNION
SELECT DISTINCT `prize_one`, 'prize_one' FROM `lottery_db`.`lottery` WHERE `prize_one` IS NOT NULL
UNION
SELECT DISTINCT `prize_two`, 'prize_two' FROM `lottery_db`.`lottery` WHERE `prize_two` IS NOT NULL
UNION
SELECT DISTINCT `prize_three`, 'prize_three' FROM `lottery_db`.`lottery` WHERE `prize_three` IS NOT NULL
UNION
SELECT DISTINCT `prize_four`, 'prize_four' FROM `lottery_db`.`lottery` WHERE `prize_four` IS NOT NULL
UNION
SELECT DISTINCT `prize_five`, 'prize_five' FROM `lottery_db`.`lottery` WHERE `prize_five` IS NOT NULL
UNION
SELECT DISTINCT `prize_six`, 'prize_six' FROM `lottery_db`.`lottery` WHERE `prize_six` IS NOT NULL
UNION
SELECT DISTINCT `prize_seven`, 'prize_seven' FROM `lottery_db`.`lottery` WHERE `prize_seven` IS NOT NULL
UNION
SELECT DISTINCT `prize_eight`, 'prize_eight' FROM `lottery_db`.`lottery` WHERE `prize_eight` IS NOT NULL;


CREATE TABLE IF NOT EXISTS `lottery_prize_values` (
    `prize_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `prize_name` VARCHAR(255) NOT NULL, -- Tên giải thưởng, ví dụ: 'Đặc Biệt', 'Nhất', ...
    `prize_value` DECIMAL(15, 2) NOT NULL, -- Giá trị giải thưởng, ví dụ: 2000000000, 30000000,...
    PRIMARY KEY (`prize_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=UTF8MB4_GENERAL_CI;

-- 11. Insert giải thưởng vào bảng `lottery_prize_values` 
INSERT INTO `lottery_prize_values` (`prize_name`, `prize_value`)
VALUES
    ('prize_special', 2000000000),  -- Giải đặc biệt (6 số)
    ('prize_one', 30000000),        -- Giải nhất (5 số)
    ('prize_two', 15000000),        -- Giải nhì (5 số)
    ('prize_three', 10000000),      -- Giải ba (5 số)
    ('prize_four', 3000000),        -- Giải tư (5 số)
    ('prize_five', 1000000),        -- Giải năm (4 số)
    ('prize_six', 400000),          -- Giải sáu (4 số)
    ('prize_seven', 200000),        -- Giải bảy (3 số)
    ('prize_eight', 100000),        -- Giải tám (2 số)
    ('prize_special_bonus', 50000000), -- Giải phụ đặc biệt
    ('prize_consolation', 6000000);  -- Giải khuyến khích


-- 12. Insert dữ liệu vào `fact_lottery` từ `lottery_db.lottery` và bảng dimension
INSERT INTO `fact_lottery` 
    (`province_id`, `date_id`, `prize_special_id`, `prize_one_id`, `prize_two_id`, `prize_three_id`, `prize_four_id`, `prize_five_id`, `prize_six_id`, `prize_seven_id`, `prize_eight_id`, `modify_date`)
SELECT 
    p.`province_id`,
    d.`date_id`, 
    ps.`prize_id` AS `prize_special_id`,
    p1.`prize_id` AS `prize_one_id`,
    p2.`prize_id` AS `prize_two_id`,
    p3.`prize_id` AS `prize_three_id`,
    p4.`prize_id` AS `prize_four_id`,
    p5.`prize_id` AS `prize_five_id`,
    p6.`prize_id` AS `prize_six_id`,
    p7.`prize_id` AS `prize_seven_id`,
    p8.`prize_id` AS `prize_eight_id`,
    l.`modify_date`
FROM 
    `staging_lottery` l
JOIN `dim_province` p ON p.`province_name` = l.`province`
JOIN `dim_date` d ON d.`year` = YEAR(STR_TO_DATE(l.`date`, '%Y-%m-%d')) 
                  AND d.`month` = MONTH(STR_TO_DATE(l.`date`, '%Y-%m-%d')) 
                  AND d.`day` = DAY(STR_TO_DATE(l.`date`, '%Y-%m-%d'))
LEFT JOIN `dim_lottery_prize` ps ON ps.`prize_name` = l.`prize_special`
LEFT JOIN `dim_lottery_prize` p1 ON p1.`prize_name` = l.`prize_one`
LEFT JOIN `dim_lottery_prize` p2 ON p2.`prize_name` = l.`prize_two`
LEFT JOIN `dim_lottery_prize` p3 ON p3.`prize_name` = l.`prize_three`
LEFT JOIN `dim_lottery_prize` p4 ON p4.`prize_name` = l.`prize_four`
LEFT JOIN `dim_lottery_prize` p5 ON p5.`prize_name` = l.`prize_five`
LEFT JOIN `dim_lottery_prize` p6 ON p6.`prize_name` = l.`prize_six`
LEFT JOIN `dim_lottery_prize` p7 ON p7.`prize_name` = l.`prize_seven`
LEFT JOIN `dim_lottery_prize` p8 ON p8.`prize_name` = l.`prize_eight`;

UPDATE `dim_lottery_prize` dlp
JOIN `lottery_prize_values` lpv ON dlp.`prize_description` = lpv.`prize_name`
SET dlp.`prize_value` = lpv.`prize_value`;



-- 13. Tạo bảng `summary_lottery` để tóm tắt dữ liệu
CREATE TABLE IF NOT EXISTS `summary_lottery` (
    `province_name` VARCHAR(255) NOT NULL,
    `year` INT(11) NOT NULL,
    `month` INT(11) NOT NULL,
    `total_lottery_draws` INT(11) DEFAULT 0,
    PRIMARY KEY (`province_name`, `year`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- 14. Cập nhật bảng `summary_lottery` từ bảng `fact_lottery`
UPDATE `summary_lottery` s
JOIN (
    SELECT 
        p.province_name,
        d.year,
        d.month,
        COUNT(f.fact_id) AS total_lottery_draws
    FROM 
        fact_lottery f
    JOIN 
        dim_province p ON f.province_id = p.province_id
    JOIN 
        dim_date d ON f.date_id = d.date_id
    GROUP BY 
        p.province_name, d.year, d.month
) AS summary_data
ON s.province_name = summary_data.province_name
AND s.year = summary_data.year
AND s.month = summary_data.month
SET 
    s.total_lottery_draws = summary_data.total_lottery_draws;


-- 15. Insert dữ liệu mới vào `summary_lottery` nếu chưa tồn tại
INSERT INTO `summary_lottery` (`province_name`, `year`, `month`, `total_lottery_draws`)
SELECT 
    p.province_name,
    d.year,
    d.month,
    COUNT(f.fact_id) AS total_lottery_draws
FROM 
    fact_lottery f
JOIN 
    dim_province p ON f.province_id = p.province_id
JOIN 
    dim_date d ON f.date_id = d.date_id
GROUP BY 
    p.province_name, d.year, d.month
ON DUPLICATE KEY UPDATE
    total_lottery_draws = VALUES(total_lottery_draws);
