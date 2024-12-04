-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 02, 2024 at 07:40 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET
SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET
time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lottery_db`
--
CREATE
DATABASE IF NOT EXISTS `lottery_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE
`lottery_db`;

-- --------------------------------------------------------

--
-- Table structure for table `config`
--

CREATE TABLE `config`
(
    `id`                        bigint(20) NOT NULL,
    `type`                      enum('CRAWL_DATA','LOAD_TO_DW','LOAD_TO_STAGING') DEFAULT NULL,
    `create_at`                 date         DEFAULT NULL,
    `name`                      varchar(255) NOT NULL,
    `province`                  varchar(255) DEFAULT NULL,
    `source`                    varchar(255) DEFAULT NULL,
    `source_location`           varchar(255) DEFAULT NULL,
    `procedure_name`            varchar(255) DEFAULT NULL,
    `destination_table_dw`      varchar(255) DEFAULT NULL,
    `destination_table_staging` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `date`
--

CREATE TABLE `date`
(
    `id`    bigint(20) NOT NULL,
    `day`   int(11) NOT NULL,
    `month` int(11) NOT NULL,
    `year`  int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log`
(
    `id`        bigint(20) NOT NULL,
    `id_config` bigint(20) NOT NULL,
    `date`      date NOT NULL,
    `province`  varchar(255) DEFAULT NULL,
    `status`    enum('FAILURE','IN_PROGRESS','PENDING','SUCCESS') DEFAULT NULL,
    `count`     int(11) DEFAULT NULL,
    `file_size` bigint(20) DEFAULT NULL,
    `message`   varchar(255) DEFAULT NULL,
    `dt_update` date         DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lottery`
--

CREATE TABLE `lottery`
(
    `id`            bigint(20) NOT NULL,
    `province_id`   bigint(20) DEFAULT NULL,
    `date_id`       bigint(20) DEFAULT NULL,
    `prize_special` varchar(255) DEFAULT NULL,
    `prize_one`     varchar(255) DEFAULT NULL,
    `prize_two`     varchar(255) DEFAULT NULL,
    `prize_three`   varchar(255) DEFAULT NULL,
    `prize_four`    varchar(255) DEFAULT NULL,
    `prize_five`    varchar(255) DEFAULT NULL,
    `prize_six`     varchar(255) DEFAULT NULL,
    `prize_seven`   varchar(255) DEFAULT NULL,
    `prize_eight`   varchar(255) DEFAULT NULL,
    `date_delete`   datetime(6) DEFAULT NULL,
    `modify_date`   datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `province`
--

CREATE TABLE `province`
(
    `id`   bigint(20) NOT NULL,
    `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staging_lottery`
--

CREATE TABLE `staging_lottery`
(
    `id`            bigint(20) NOT NULL,
    `province`      varchar(255) DEFAULT NULL,
    `date`          varchar(255) DEFAULT NULL,
    `prize_special` varchar(255) DEFAULT NULL,
    `prize_one`     varchar(255) DEFAULT NULL,
    `prize_two`     varchar(255) DEFAULT NULL,
    `prize_three`   varchar(255) DEFAULT NULL,
    `prize_four`    varchar(255) DEFAULT NULL,
    `prize_five`    varchar(255) DEFAULT NULL,
    `prize_six`     varchar(255) DEFAULT NULL,
    `prize_seven`   varchar(255) DEFAULT NULL,
    `prize_eight`   varchar(255) DEFAULT NULL,
    `create_at`     date         DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `config`
--
ALTER TABLE `config`
    ADD PRIMARY KEY (`id`);

--
-- Indexes for table `date`
--
ALTER TABLE `date`
    ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
    ADD PRIMARY KEY (`id`),
  ADD KEY `FKdmieh9bb8m60anxhuqqhrse5w` (`id_config`);

--
-- Indexes for table `lottery`
--
ALTER TABLE `lottery`
    ADD PRIMARY KEY (`id`),
  ADD KEY `FKbov2b8or3mn851dcw08q5udot` (`date_id`),
  ADD KEY `FKe91r3lyevqqmtnomehhyck7ne` (`province_id`);

--
-- Indexes for table `province`
--
ALTER TABLE `province`
    ADD PRIMARY KEY (`id`);

--
-- Indexes for table `staging_lottery`
--
ALTER TABLE `staging_lottery`
    ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `config`
--
ALTER TABLE `config`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `date`
--
ALTER TABLE `date`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log`
--
ALTER TABLE `log`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lottery`
--
ALTER TABLE `lottery`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `province`
--
ALTER TABLE `province`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `staging_lottery`
--
ALTER TABLE `staging_lottery`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `log`
--
ALTER TABLE `log`
    ADD CONSTRAINT `FKdmieh9bb8m60anxhuqqhrse5w` FOREIGN KEY (`id_config`) REFERENCES `config` (`id`);

--
-- Constraints for table `lottery`
--
ALTER TABLE `lottery`
    ADD CONSTRAINT `FKbov2b8or3mn851dcw08q5udot` FOREIGN KEY (`date_id`) REFERENCES `date` (`id`),
  ADD CONSTRAINT `FKe91r3lyevqqmtnomehhyck7ne` FOREIGN KEY (`province_id`) REFERENCES `province` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

DROP PROCEDURE IF EXISTS transform_load_data_to_warehouse;
DELIMITER
$$

CREATE PROCEDURE transform_load_data_to_warehouse()
BEGIN
    DECLARE
EXIT HANDLER FOR SQLEXCEPTION
        ROLLBACK;

    -- Bắt đầu giao dịch
START TRANSACTION;

-- Bước 1: Chèn các tỉnh duy nhất vào bảng 'province' nếu chưa có
INSERT
IGNORE INTO province (name)
SELECT DISTINCT province
FROM staging_lottery;

-- Bước 2: Chèn các ngày duy nhất vào bảng 'date' nếu chưa có
INSERT
IGNORE INTO date (day, month, year)
SELECT DISTINCT
    DAY (STR_TO_DATE(date, '%d/%m/%Y')) AS day, MONTH (STR_TO_DATE(date, '%d/%m/%Y')) AS month, YEAR (STR_TO_DATE(date, '%d/%m/%Y')) AS year
FROM staging_lottery;

-- Bước 3: Chèn hoặc cập nhật vào bảng 'lottery'
INSERT INTO lottery (province_id, date_id, prize_special, prize_one, prize_two, prize_three,
                     prize_four, prize_five, prize_six, prize_seven, prize_eight,
                     date_delete, modify_date)
SELECT p.id  AS province_id,
       d.id  AS date_id,
       stg.prize_special,
       stg.prize_one,
       stg.prize_two,
       stg.prize_three,
       stg.prize_four,
       stg.prize_five,
       stg.prize_six,
       stg.prize_seven,
       stg.prize_eight,
       NULL  AS date_delete,
       NOW() AS modify_date
FROM staging_lottery stg
         INNER JOIN province p ON p.name = stg.province
         INNER JOIN date d ON d.day = DAY (STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND d.month = MONTH (STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND d.year = YEAR (STR_TO_DATE(stg.date, '%d/%m/%Y'))
    LEFT JOIN lottery l
ON l.province_id = p.id
    AND l.date_id = d.id
    AND l.prize_special = stg.prize_special
    AND l.prize_one = stg.prize_one
    AND l.prize_two = stg.prize_two
    AND l.prize_three = stg.prize_three
    AND l.prize_four = stg.prize_four
    AND l.prize_five = stg.prize_five
    AND l.prize_six = stg.prize_six
    AND l.prize_seven = stg.prize_seven
    AND l.prize_eight = stg.prize_eight
WHERE l.id IS NULL;
-- Chỉ chèn nếu không có bản ghi nào hoàn toàn trùng khớp

-- Bước 4: Xóa các bản ghi đã xử lý trong bảng 'staging_lottery'
DELETE
stg
FROM staging_lottery stg
INNER JOIN province p ON p.name = stg.province
INNER JOIN date d ON d.day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
                  AND d.month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
                  AND d.year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y'))
LEFT JOIN lottery l ON l.province_id = p.id
                   AND l.date_id = d.id
                   AND l.prize_special = stg.prize_special
                   AND l.prize_one = stg.prize_one
                   AND l.prize_two = stg.prize_two
                   AND l.prize_three = stg.prize_three
                   AND l.prize_four = stg.prize_four
                   AND l.prize_five = stg.prize_five
                   AND l.prize_six = stg.prize_six
                   AND l.prize_seven = stg.prize_seven
                   AND (l.prize_eight = stg.prize_eight OR (l.prize_eight IS NULL AND stg.prize_eight IS NULL)) -- Điều chỉnh này sẽ xử lý NULL
WHERE l.id IS NOT NULL;


    -- Kết thúc giao dịch
COMMIT;
END$$

DELIMITER ;




--
-- Dumping data for table `config`
--

INSERT INTO `config` (`id`, `type`, `create_at`, `name`, `province`, `source`, `source_location`, `procedure_name`,
                      `destination_table_dw`, `destination_table_staging`)
VALUES (1, 'CRAWL_DATA', '2024-12-01', 'Crawl Bến Tre', 'Bến Tre', 'https://www.xoso.net/getkqxs/ben-tre/01-12-2024.js',
        'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
       (2, 'CRAWL_DATA', '2024-12-01', 'Crawl Cần Thơ', 'Cần Thơ', 'https://www.xoso.net/getkqxs/can-tho/01-12-2024.js',
        'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
       (3, 'CRAWL_DATA', '2024-12-01', 'Crawl Cà Mau', 'Cà Mau', 'https://www.xoso.net/getkqxs/ca-mau/01-12-2024.js',
        'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
       (4, 'CRAWL_DATA', '2024-12-01', 'Crawl Đắk Nông', 'Đắk Nông',
        'https://www.xoso.net/getkqxs/dak-nong/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (5, 'CRAWL_DATA', '2024-12-01', 'Crawl Bình Dương', 'Bình Dương',
        'https://www.xoso.net/getkqxs/binh-duong/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (6, 'CRAWL_DATA', '2024-12-01', 'Crawl Đồng Nai', 'Đồng Nai',
        'https://www.xoso.net/getkqxs/dong-nai/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (7, 'CRAWL_DATA', '2024-12-01', 'Crawl Đồng Tháp', 'Đồng Tháp',
        'https://www.xoso.net/getkqxs/dong-thap/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (8, 'CRAWL_DATA', '2024-12-01', 'Crawl Miền Bắc', 'Miền Bắc',
        'https://www.xoso.net/getkqxs/mien-bac/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (9, 'CRAWL_DATA', '2024-12-01', 'Crawl Bình Định', 'Bình Định',
        'https://www.xoso.net/getkqxs/binh-dinh/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (10, 'CRAWL_DATA', '2024-12-01', 'Crawl Bình Thuận', 'Bình Thuận',
        'https://www.xoso.net/getkqxs/binh-thuan/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (11, 'CRAWL_DATA', '2024-12-01', 'Crawl Bình Phước', 'Bình Phước',
        'https://www.xoso.net/getkqxs/binh-phuoc/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (12, 'CRAWL_DATA', '2024-12-01', 'Crawl Đắk Lắk', 'Đắk Lắk',
        'https://www.xoso.net/getkqxs/dak-lak/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (13, 'CRAWL_DATA', '2024-12-01', 'Crawl Bạc Liêu', 'Bạc Liêu',
        'https://www.xoso.net/getkqxs/bac-lieu/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (14, 'CRAWL_DATA', '2024-12-01', 'Crawl An Giang', 'An Giang',
        'https://www.xoso.net/getkqxs/an-giang/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (15, 'CRAWL_DATA', '2024-12-01', 'Crawl Đà Lạt', 'Đà Lạt', 'https://www.xoso.net/getkqxs/da-lat/01-12-2024.js',
        'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
       (16, 'CRAWL_DATA', '2024-12-01', 'Crawl Đà Nẵng', 'Đà Nẵng',
        'https://www.xoso.net/getkqxs/da-nang/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (17, 'LOAD_TO_STAGING', '2024-12-01', 'Load staging ', NULL, NULL, 'D:\\DW\\01-12-2024_XSVN.csv', NULL,
        'lottery', 'staging_lottery'),
       (18, 'LOAD_TO_DW', '2024-12-01', 'Load DW', NULL, NULL, NULL, NULL, 'lottery', 'staging_lottery'),
       (19, 'CRAWL_DATA', '2024-12-02', 'Crawl Kon Tum', 'Kon Tum',
        'https://www.xoso.net/getkqxs/kon-tum/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (20, 'CRAWL_DATA', '2024-12-02', 'Crawl Quảng Bình', 'Quảng Bình',
        'https://www.xoso.net/getkqxs/quang-binh/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (21, 'CRAWL_DATA', '2024-12-02', 'Crawl Vĩnh Long', 'Vĩnh Long',
        'https://www.xoso.net/getkqxs/vinh-long/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (22, 'CRAWL_DATA', '2024-12-02', 'Crawl Quảng Trị', 'Quảng Trị',
        'https://www.xoso.net/getkqxs/quang-tri/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (23, 'CRAWL_DATA', '2024-12-02', 'Crawl Vũng Tàu', 'Vũng Tàu',
        'https://www.xoso.net/getkqxs/vung-tau/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (24, 'CRAWL_DATA', '2024-12-02', 'Crawl Phú Yên', 'Phú Yên',
        'https://www.xoso.net/getkqxs/phu-yen/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (25, 'CRAWL_DATA', '2024-12-02', 'Crawl Tiền Giang', 'Tiền Giang',
        'https://www.xoso.net/getkqxs/tien-giang/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (26, 'CRAWL_DATA', '2024-12-02', 'Crawl Ninh Thuận', 'Ninh Thuận',
        'https://www.xoso.net/getkqxs/ninh-thuan/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (27, 'CRAWL_DATA', '2024-12-02', 'Crawl Trà Vinh', 'Trà Vinh',
        'https://www.xoso.net/getkqxs/tra-vinh/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (28, 'CRAWL_DATA', '2024-12-02', 'Crawl Quảng Nam', 'Quảng Nam',
        'https://www.xoso.net/getkqxs/quang-nam/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (29, 'CRAWL_DATA', '2024-12-02', 'Crawl TP. HCM', 'TP. HCM', 'https://www.xoso.net/getkqxs/tp-hcm/02-12-2024.js',
        'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
       (30, 'CRAWL_DATA', '2024-12-02', 'Crawl Long An', 'Long An',
        'https://www.xoso.net/getkqxs/long-an/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (31, 'CRAWL_DATA', '2024-12-02', 'Crawl Hậu Giang', 'Hậu Giang',
        'https://www.xoso.net/getkqxs/hau-giang/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (32, 'CRAWL_DATA', '2024-12-02', 'Crawl Quảng Ngãi', 'Quảng Ngãi',
        'https://www.xoso.net/getkqxs/quang-ngai/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (33, 'CRAWL_DATA', '2024-12-02', 'Crawl Tây Ninh', 'Tây Ninh',
        'https://www.xoso.net/getkqxs/tay-ninh/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (34, 'CRAWL_DATA', '2024-12-02', 'Crawl Kiên Giang', 'Kiên Giang',
        'https://www.xoso.net/getkqxs/kien-giang/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (35, 'CRAWL_DATA', '2024-12-02', 'Crawl Gia Lai', 'Gia Lai',
        'https://www.xoso.net/getkqxs/gia-lai/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (36, 'CRAWL_DATA', '2024-12-02', 'Crawl Sóc Trăng', 'Sóc Trăng',
        'https://www.xoso.net/getkqxs/soc-trang/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (37, 'CRAWL_DATA', '2024-12-02', 'Crawl Khánh Hòa', 'Khánh Hòa',
        'https://www.xoso.net/getkqxs/khanh-hoa/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (38, 'CRAWL_DATA', '2024-12-02', 'Crawl Thừa Thiên Huế', 'Thừa Thiên Huế',
        'https://www.xoso.net/getkqxs/thua-thien-hue/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (39, 'LOAD_TO_STAGING', '2024-12-02', 'Load staging ', NULL, NULL, 'D:\\DW\\02-12-2024_XSVN.csv', NULL,
        'lottery', 'staging_lottery'),
       (40, 'LOAD_TO_DW', '2024-12-02', 'Load DW', NULL, NULL, NULL, NULL, 'lottery', 'staging_lottery'),
       (41, 'CRAWL_DATA', '2024-12-04', 'Crawl Kon Tum', 'Kon Tum',
        'https://www.xoso.net/getkqxs/kon-tum/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (42, 'CRAWL_DATA', '2024-12-04', 'Crawl Bến Tre', 'Bến Tre',
        'https://www.xoso.net/getkqxs/ben-tre/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (43, 'CRAWL_DATA', '2024-12-04', 'Crawl Quảng Trị', 'Quảng Trị',
        'https://www.xoso.net/getkqxs/quang-tri/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (44, 'CRAWL_DATA', '2024-12-04', 'Crawl Tiền Giang', 'Tiền Giang',
        'https://www.xoso.net/getkqxs/tien-giang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (45, 'CRAWL_DATA', '2024-12-04', 'Crawl Cần Thơ', 'Cần Thơ',
        'https://www.xoso.net/getkqxs/can-tho/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (46, 'CRAWL_DATA', '2024-12-04', 'Crawl Bình Dương', 'Bình Dương',
        'https://www.xoso.net/getkqxs/binh-duong/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (47, 'CRAWL_DATA', '2024-12-04', 'Crawl Ninh Thuận', 'Ninh Thuận',
        'https://www.xoso.net/getkqxs/ninh-thuan/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (48, 'CRAWL_DATA', '2024-12-04', 'Crawl Trà Vinh', 'Trà Vinh',
        'https://www.xoso.net/getkqxs/tra-vinh/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (49, 'CRAWL_DATA', '2024-12-04', 'Crawl Quảng Nam', 'Quảng Nam',
        'https://www.xoso.net/getkqxs/quang-nam/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (50, 'CRAWL_DATA', '2024-12-04', 'Crawl Long An', 'Long An',
        'https://www.xoso.net/getkqxs/long-an/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (51, 'CRAWL_DATA', '2024-12-04', 'Crawl Bình Định', 'Bình Định',
        'https://www.xoso.net/getkqxs/binh-dinh/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (52, 'CRAWL_DATA', '2024-12-04', 'Crawl Bình Phước', 'Bình Phước',
        'https://www.xoso.net/getkqxs/binh-phuoc/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (53, 'CRAWL_DATA', '2024-12-04', 'Crawl Bạc Liêu', 'Bạc Liêu',
        'https://www.xoso.net/getkqxs/bac-lieu/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (54, 'CRAWL_DATA', '2024-12-04', 'Crawl Tây Ninh', 'Tây Ninh',
        'https://www.xoso.net/getkqxs/tay-ninh/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (55, 'CRAWL_DATA', '2024-12-04', 'Crawl Kiên Giang', 'Kiên Giang',
        'https://www.xoso.net/getkqxs/kien-giang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (56, 'CRAWL_DATA', '2024-12-04', 'Crawl Sóc Trăng', 'Sóc Trăng',
        'https://www.xoso.net/getkqxs/soc-trang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (57, 'CRAWL_DATA', '2024-12-04', 'Crawl Đà Lạt', 'Đà Lạt', 'https://www.xoso.net/getkqxs/da-lat/04-12-2024.js',
        'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
       (58, 'CRAWL_DATA', '2024-12-04', 'Crawl Đà Nẵng', 'Đà Nẵng',
        'https://www.xoso.net/getkqxs/da-nang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (59, 'CRAWL_DATA', '2024-12-04', 'Crawl Khánh Hòa', 'Khánh Hòa',
        'https://www.xoso.net/getkqxs/khanh-hoa/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (60, 'CRAWL_DATA', '2024-12-04', 'Crawl Thừa Thiên Huế', 'Thừa Thiên Huế',
        'https://www.xoso.net/getkqxs/thua-thien-hue/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (61, 'CRAWL_DATA', '2024-12-04', 'Crawl Quảng Bình', 'Quảng Bình',
        'https://www.xoso.net/getkqxs/quang-binh/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (62, 'CRAWL_DATA', '2024-12-04', 'Crawl Vĩnh Long', 'Vĩnh Long',
        'https://www.xoso.net/getkqxs/vinh-long/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (63, 'CRAWL_DATA', '2024-12-04', 'Crawl Vũng Tàu', 'Vũng Tàu',
        'https://www.xoso.net/getkqxs/vung-tau/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (64, 'CRAWL_DATA', '2024-12-04', 'Crawl Phú Yên', 'Phú Yên',
        'https://www.xoso.net/getkqxs/phu-yen/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (65, 'CRAWL_DATA', '2024-12-04', 'Crawl Cà Mau', 'Cà Mau', 'https://www.xoso.net/getkqxs/ca-mau/04-12-2024.js',
        'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
       (66, 'CRAWL_DATA', '2024-12-04', 'Crawl Đắk Nông', 'Đắk Nông',
        'https://www.xoso.net/getkqxs/dak-nong/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (67, 'CRAWL_DATA', '2024-12-04', 'Crawl Đồng Nai', 'Đồng Nai',
        'https://www.xoso.net/getkqxs/dong-nai/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (68, 'CRAWL_DATA', '2024-12-04', 'Crawl Đồng Tháp', 'Đồng Tháp',
        'https://www.xoso.net/getkqxs/dong-thap/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (69, 'CRAWL_DATA', '2024-12-04', 'Crawl TP. HCM', 'TP. HCM', 'https://www.xoso.net/getkqxs/tp-hcm/04-12-2024.js',
        'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
       (70, 'CRAWL_DATA', '2024-12-04', 'Crawl Miền Bắc', 'Miền Bắc',
        'https://www.xoso.net/getkqxs/mien-bac/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (71, 'CRAWL_DATA', '2024-12-04', 'Crawl Bình Thuận', 'Bình Thuận',
        'https://www.xoso.net/getkqxs/binh-thuan/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (72, 'CRAWL_DATA', '2024-12-04', 'Crawl Đắk Lắk', 'Đắk Lắk',
        'https://www.xoso.net/getkqxs/dak-lak/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (73, 'CRAWL_DATA', '2024-12-04', 'Crawl Hậu Giang', 'Hậu Giang',
        'https://www.xoso.net/getkqxs/hau-giang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (74, 'CRAWL_DATA', '2024-12-04', 'Crawl Quảng Ngãi', 'Quảng Ngãi',
        'https://www.xoso.net/getkqxs/quang-ngai/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (75, 'CRAWL_DATA', '2024-12-04', 'Crawl Gia Lai', 'Gia Lai',
        'https://www.xoso.net/getkqxs/gia-lai/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (76, 'CRAWL_DATA', '2024-12-04', 'Crawl An Giang', 'An Giang',
        'https://www.xoso.net/getkqxs/an-giang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery',
        'staging_lottery'),
       (77, 'LOAD_TO_STAGING', '2024-12-04', 'Load staging ', NULL, NULL, 'D:\\DW\\04-12-2024_XSVN.csv', NULL,
        'lottery', 'staging_lottery'),
       (78, 'LOAD_TO_DW', '2024-12-04', 'Load DW', NULL, NULL, NULL, NULL, 'lottery', 'staging_lottery');


INSERT INTO `log` (`id`, `id_config`, `date`, `province`, `status`, `count`, `file_size`, `message`, `dt_update`)
VALUES (1, 1, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (2, 2, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (3, 3, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (4, 4, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'SUCCESS', 3, 0,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (5, 5, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'SUCCESS', 4, 0,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (6, 6, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (7, 7, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (8, 8, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'SUCCESS', 5, 401,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (9, 9, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'SUCCESS', 6, 401,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (10, 10, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'SUCCESS', 7, 401,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (11, 11, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'SUCCESS', 8, 980,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (12, 12, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (13, 13, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (14, 14, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'SUCCESS', 9, 980,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (15, 15, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'SUCCESS', 10, 980,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (16, 16, '2024-12-04', 'D:\\DW\\01-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (17, 19, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 1, 0,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (18, 20, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 4, 0,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (19, 21, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 5, 512,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (20, 22, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 6, 512,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (21, 23, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (22, 24, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 7, 512,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (23, 25, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 8, 512,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (24, 26, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 9, 1024,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (25, 27, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 10, 1024,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (26, 28, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (27, 29, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 11, 1024,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (28, 30, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 12, 1024,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (29, 31, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 13, 1536,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (30, 32, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 14, 1536,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (31, 33, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'SUCCESS', 15, 1536,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (32, 34, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'FAILURE', NULL, NULL,
        'Lỗi khi ghi dữ liệu vào file CSV: D:\\DW\\02-12-2024_XSVN.csv (The process cannot access the file because it is being used by another process)',
        '2024-12-04'),
       (33, 35, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'FAILURE', NULL, NULL,
        'Lỗi khi ghi dữ liệu vào file CSV: D:\\DW\\02-12-2024_XSVN.csv (The process cannot access the file because it is being used by another process)',
        '2024-12-04'),
       (34, 36, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (35, 37, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'FAILURE', NULL, NULL, 'Lỗi lấy dữ liệu từ URL.',
        '2024-12-04'),
       (36, 38, '2024-12-04', 'D:\\DW\\02-12-2024_XSVN.csv', 'FAILURE', NULL, NULL,
        'Lỗi khi ghi dữ liệu vào file CSV: D:\\DW\\02-12-2024_XSVN.csv (The process cannot access the file because it is being used by another process)',
        '2024-12-04'),
       (37, 41, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 1, 0,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (38, 42, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 4, 0,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (39, 43, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 5, 512,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (40, 44, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 6, 512,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (41, 45, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 7, 512,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (42, 46, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 8, 512,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (43, 47, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 9, 1024,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (44, 48, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 10, 1024,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (45, 49, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 11, 1024,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (46, 50, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 12, 1024,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (47, 51, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 13, 1536,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (48, 52, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 14, 1536,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (49, 53, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 15, 1536,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (50, 54, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 16, 2048,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (51, 55, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 17, 2048,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (52, 56, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 18, 2048,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (53, 57, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 19, 2048,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (54, 58, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 20, 2560,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (55, 59, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 21, 2560,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (56, 60, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 22, 2560,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (57, 61, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 23, 3072,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (58, 62, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 24, 3072,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (59, 63, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 25, 3072,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (60, 64, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 26, 3072,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (61, 65, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 27, 3584,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (62, 66, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 28, 3584,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (63, 67, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 29, 3584,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (64, 68, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 30, 3584,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (65, 69, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 31, 4096,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (66, 70, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 32, 4201,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (67, 71, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 33, 4201,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (68, 72, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 34, 4201,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (69, 73, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 35, 4780,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (70, 74, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 36, 4780,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (71, 75, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 37, 4780,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (72, 76, '2024-12-04', 'D:\\DW\\04-12-2024_XSVN.csv', 'SUCCESS', 38, 4780,
        'Crawl dữ liệu và ghi vào file CSV thành công.', '2024-12-04'),
       (73, 17, '2024-12-04', NULL, 'SUCCESS', NULL, NULL, 'Toàn bộ dữ liệu đã được load thành công.', '2024-12-04'),
       (74, 39, '2024-12-04', NULL, 'SUCCESS', NULL, NULL, 'Toàn bộ dữ liệu đã được load thành công.', '2024-12-04'),
       (75, 77, '2024-12-04', NULL, 'SUCCESS', NULL, NULL, 'Toàn bộ dữ liệu đã được load thành công.', '2024-12-04'),
       (76, 18, '2024-12-04', '', 'SUCCESS', NULL, NULL,
        'transform and load data to warehouse đã được thực thi thành công.', '2024-12-04'),
       (77, 40, '2024-12-04', '', 'SUCCESS', NULL, NULL,
        'transform and load data to warehouse đã được thực thi thành công.', '2024-12-04'),
       (78, 78, '2024-12-04', '', 'SUCCESS', NULL, NULL,
        'transform and load data to warehouse đã được thực thi thành công.', '2024-12-04');


INSERT INTO `date` (`id`, `day`, `month`, `year`)
VALUES (1, 30, 11, 2024),
       (2, 29, 11, 2024),
       (3, 1, 12, 2024),
       (4, 28, 11, 2024),
       (5, 2, 12, 2024),
       (6, 3, 12, 2024),
       (7, 4, 12, 2024);


INSERT INTO `province` (`id`, `name`)
VALUES (1, 'Đắk Nông'),
       (2, 'Bình Dương'),
       (3, 'Miền Bắc'),
       (4, 'Bình Định'),
       (5, 'Bình Thuận'),
       (6, 'Bình Phước'),
       (7, 'An Giang'),
       (8, 'Đà Lạt'),
       (9, 'Kon Tum'),
       (10, 'Quảng Bình'),
       (11, 'Vĩnh Long'),
       (12, 'Quảng Trị'),
       (13, 'Phú Yên'),
       (14, 'Tiền Giang'),
       (15, 'Ninh Thuận'),
       (16, 'Trà Vinh'),
       (17, 'TP. HCM'),
       (18, 'Long An'),
       (19, 'Hậu Giang'),
       (20, 'Quảng Ngãi'),
       (21, 'Tây Ninh'),
       (22, 'Bến Tre'),
       (23, 'Cần Thơ'),
       (24, 'Quảng Nam'),
       (25, 'Bạc Liêu'),
       (26, 'Kiên Giang'),
       (27, 'Sóc Trăng'),
       (28, 'Đà Nẵng'),
       (29, 'Khánh Hòa'),
       (30, 'Thừa Thiên Huế'),
       (31, 'Vũng Tàu'),
       (32, 'Cà Mau'),
       (33, 'Đồng Nai'),
       (34, 'Đồng Tháp'),
       (35, 'Đắk Lắk'),
       (36, 'Gia Lai');

INSERT INTO `lottery` (`id`, `province_id`, `date_id`, `prize_special`, `prize_one`, `prize_two`, `prize_three`,
                       `prize_four`, `prize_five`, `prize_six`, `prize_seven`, `prize_eight`, `date_delete`,
                       `modify_date`)
VALUES (1, 1, 1, '613708', '72858', '33356', '06945 - 70036', '19676 - 21440 - 66247 - 85170 - 66115 - 29635 - 10534',
        '0514', '7426 - 5933 - 4366', '071', '43', NULL, '2024-12-04 20:04:14.000000'),
       (2, 2, 2, '211942', '63281', '41737', '14787 - 19832', '39187 - 11849 - 68998 - 44615 - 53216 - 50734 - 22208',
        '8107', '4508 - 0160 - 1662', '053', '20', NULL, '2024-12-04 20:04:14.000000'),
       (3, 3, 3, '24735', '50844', '55402 - 90127', '58339 - 26595 - 50625 - 46931 - 25712 - 14804',
        '4560 - 7943 - 1461 - 4194', '7494 - 3723 - 6911 - 5978 - 0609 - 8373', '282 - 121 - 772', '59 - 28 - 39 - 55',
        NULL, NULL, '2024-12-04 20:04:14.000000'),
       (4, 4, 4, '398179', '85974', '11274', '03220 - 27715', '31348 - 59899 - 51269 - 62663 - 96887 - 49937 - 53415',
        '9332', '0483 - 9346 - 8892', '732', '19', NULL, '2024-12-04 20:04:14.000000'),
       (5, 5, 4, '838992', '98899', '06754', '80112 - 98791', '24494 - 68331 - 62164 - 16423 - 43208 - 30307 - 23444',
        '9506', '8681 - 3865 - 7136', '366', '65', NULL, '2024-12-04 20:04:14.000000'),
       (6, 6, 1, '208677', '40950', '64224', '80443 - 96020', '65942 - 74477 - 47017 - 20077 - 04550 - 17813 - 20947',
        '8239', '1429 - 4678 - 4307', '352', '05', NULL, '2024-12-04 20:04:14.000000'),
       (7, 7, 4, '668983', '68078', '09979', '97460 - 81310', '05188 - 74104 - 75674 - 35002 - 08825 - 06441 - 12832',
        '5917', '4566 - 2148 - 9909', '555', '69', NULL, '2024-12-04 20:04:14.000000'),
       (8, 8, 3, '174941', '60484', '56741', '05133 - 95754', '02811 - 45651 - 90422 - 62148 - 23617 - 25827 - 52054',
        '4866', '6504 - 6518 - 1382', '865', '53', NULL, '2024-12-04 20:04:14.000000'),
       (9, 9, 3, '303033', '53298', '91246', '88181 - 62950', '31093 - 09526 - 29959 - 76413 - 75187 - 42382 - 40775',
        '8075', '4599 - 5065 - 3015', '625', '46', NULL, '2024-12-04 20:04:14.000000'),
       (10, 10, 4, '040518', '40244', '16802', '91243 - 92480', '98607 - 04236 - 04242 - 79261 - 42963 - 17876 - 90534',
        '6033', '4325 - 6930 - 9290', '276', '32', NULL, '2024-12-04 20:04:14.000000'),
       (11, 11, 2, '766403', '20421', '95982', '10101 - 44304', '36610 - 12809 - 54136 - 01400 - 12363 - 16288 - 50333',
        '0491', '3302 - 7194 - 7197', '638', '85', NULL, '2024-12-04 20:04:14.000000'),
       (12, 12, 4, '260871', '45018', '54178', '10195 - 35132', '60422 - 03292 - 74274 - 94240 - 82095 - 47479 - 69559',
        '7230', '3490 - 4916 - 4792', '689', '18', NULL, '2024-12-04 20:04:14.000000'),
       (13, 13, 5, '910758', '38943', '83196', '27818 - 98745', '60469 - 60108 - 60303 - 51470 - 54658 - 26391 - 27979',
        '1499', '0551 - 1792 - 3674', '349', '07', NULL, '2024-12-04 20:04:14.000000'),
       (14, 14, 3, '310354', '54260', '72924', '26366 - 66190', '76116 - 12719 - 35412 - 37520 - 04833 - 54111 - 04905',
        '0726', '8933 - 4968 - 1228', '331', '03', NULL, '2024-12-04 20:04:14.000000'),
       (15, 15, 2, '229799', '68014', '78733', '38633 - 87229', '03231 - 40839 - 80626 - 60153 - 86555 - 06394 - 55708',
        '2297', '9196 - 6215 - 8914', '680', '45', NULL, '2024-12-04 20:04:14.000000'),
       (16, 16, 2, '850657', '62966', '25140', '42281 - 43479', '79763 - 67930 - 16985 - 97596 - 96375 - 74381 - 14353',
        '5247', '9749 - 3201 - 6354', '880', '84', NULL, '2024-12-04 20:04:14.000000'),
       (17, 17, 5, '340805', '69509', '15531', '40622 - 70861', '72877 - 60323 - 07267 - 46542 - 85866 - 74394 - 15968',
        '3412', '0089 - 2755 - 0182', '190', '32', NULL, '2024-12-04 20:04:14.000000'),
       (18, 18, 1, '042858', '95788', '92590', '64535 - 79400', '20886 - 82133 - 83932 - 56534 - 47784 - 96933 - 30636',
        '4744', '3961 - 0579 - 0862', '199', '36', NULL, '2024-12-04 20:04:14.000000'),
       (19, 19, 1, '965779', '87216', '59160', '06144 - 20176', '55195 - 84121 - 87328 - 87996 - 53263 - 94181 - 80948',
        '0693', '7227 - 7276 - 7005', '193', '37', NULL, '2024-12-04 20:04:14.000000'),
       (20, 20, 1, '304879', '86021', '83510', '32200 - 19546', '53310 - 95733 - 11210 - 24974 - 28115 - 62565 - 55993',
        '7706', '8006 - 6486 - 9935', '433', '61', NULL, '2024-12-04 20:04:14.000000'),
       (21, 21, 4, '542451', '04890', '51523', '63960 - 43119', '91483 - 60070 - 13322 - 33480 - 96431 - 97241 - 15900',
        '7099', '5390 - 9932 - 2325', '637', '50', NULL, '2024-12-04 20:04:14.000000'),
       (22, 9, 3, '303033', '53298', '91246', '88181 - 62950', '31093 - 09526 - 29959 - 76413 - 75187 - 42382 - 40775',
        '8075', '4599 - 5065 - 3015', '625', '46', NULL, '2024-12-04 20:04:14.000000'),
       (23, 22, 6, '341516', '11075', '30638', '99479 - 46928', '51722 - 45661 - 02688 - 59036 - 57430 - 70271 - 06908',
        '8895', '7581 - 5060 - 3694', '294', '62', NULL, '2024-12-04 20:04:14.000000'),
       (24, 12, 4, '260871', '45018', '54178', '10195 - 35132', '60422 - 03292 - 74274 - 94240 - 82095 - 47479 - 69559',
        '7230', '3490 - 4916 - 4792', '689', '18', NULL, '2024-12-04 20:04:14.000000'),
       (25, 14, 3, '310354', '54260', '72924', '26366 - 66190', '76116 - 12719 - 35412 - 37520 - 04833 - 54111 - 04905',
        '0726', '8933 - 4968 - 1228', '331', '03', NULL, '2024-12-04 20:04:14.000000'),
       (26, 23, 7, '565797', '10911', '30366', '18346 - 14117', '82708 - 81767 - 39259 - 17453 - 00094 - 51962 - 18485',
        '3368', '5249 - 7506 - 1255', '715', '63', NULL, '2024-12-04 20:04:14.000000'),
       (27, 2, 2, '211942', '63281', '41737', '14787 - 19832', '39187 - 11849 - 68998 - 44615 - 53216 - 50734 - 22208',
        '8107', '4508 - 0160 - 1662', '053', '20', NULL, '2024-12-04 20:04:14.000000'),
       (28, 15, 2, '229799', '68014', '78733', '38633 - 87229', '03231 - 40839 - 80626 - 60153 - 86555 - 06394 - 55708',
        '2297', '9196 - 6215 - 8914', '680', '45', NULL, '2024-12-04 20:04:14.000000'),
       (29, 16, 2, '850657', '62966', '25140', '42281 - 43479', '79763 - 67930 - 16985 - 97596 - 96375 - 74381 - 14353',
        '5247', '9749 - 3201 - 6354', '880', '84', NULL, '2024-12-04 20:04:14.000000'),
       (30, 24, 6, '456532', '94907', '72905', '14366 - 27800', '75605 - 15275 - 06916 - 49983 - 90361 - 57101 - 74737',
        '2917', '8909 - 1805 - 5522', '068', '78', NULL, '2024-12-04 20:04:14.000000'),
       (31, 18, 1, '042858', '95788', '92590', '64535 - 79400', '20886 - 82133 - 83932 - 56534 - 47784 - 96933 - 30636',
        '4744', '3961 - 0579 - 0862', '199', '36', NULL, '2024-12-04 20:04:14.000000'),
       (32, 4, 4, '398179', '85974', '11274', '03220 - 27715', '31348 - 59899 - 51269 - 62663 - 96887 - 49937 - 53415',
        '9332', '0483 - 9346 - 8892', '732', '19', NULL, '2024-12-04 20:04:14.000000'),
       (33, 6, 1, '208677', '40950', '64224', '80443 - 96020', '65942 - 74477 - 47017 - 20077 - 04550 - 17813 - 20947',
        '8239', '1429 - 4678 - 4307', '352', '05', NULL, '2024-12-04 20:04:14.000000'),
       (34, 25, 6, '928667', '35722', '12273', '57868 - 41254', '31536 - 93075 - 19630 - 91935 - 24357 - 50598 - 80557',
        '8904', '6857 - 0336 - 5031', '822', '06', NULL, '2024-12-04 20:04:14.000000'),
       (35, 21, 4, '542451', '04890', '51523', '63960 - 43119', '91483 - 60070 - 13322 - 33480 - 96431 - 97241 - 15900',
        '7099', '5390 - 9932 - 2325', '637', '50', NULL, '2024-12-04 20:04:14.000000'),
       (36, 26, 3, '066278', '36775', '40763', '77553 - 00901', '91660 - 26288 - 35391 - 23568 - 74753 - 05563 - 79965',
        '3398', '6312 - 8909 - 3691', '238', '03', NULL, '2024-12-04 20:04:14.000000'),
       (37, 27, 7, '932312', '54182', '66099', '59967 - 36542', '33425 - 85082 - 54394 - 38412 - 52953 - 29844 - 45810',
        '4661', '9950 - 5605 - 4462', '464', '05', NULL, '2024-12-04 20:04:14.000000'),
       (38, 8, 3, '174941', '60484', '56741', '05133 - 95754', '02811 - 45651 - 90422 - 62148 - 23617 - 25827 - 52054',
        '4866', '6504 - 6518 - 1382', '865', '53', NULL, '2024-12-04 20:04:14.000000'),
       (39, 28, 7, '894937', '89077', '34801', '95280 - 85745', '99532 - 06299 - 27041 - 15214 - 84449 - 18286 - 29841',
        '7006', '3370 - 8331 - 6094', '450', '79', NULL, '2024-12-04 20:04:14.000000'),
       (40, 29, 7, '889586', '98981', '30396', '75398 - 04110', '99698 - 29084 - 50017 - 95497 - 29641 - 08384 - 55359',
        '1826', '8808 - 0188 - 3330', '429', '07', NULL, '2024-12-04 20:04:14.000000'),
       (41, 30, 5, '229734', '78830', '23438', '54445 - 16198', '13934 - 54623 - 88999 - 87177 - 91871 - 98477 - 53088',
        '4129', '0218 - 6359 - 8404', '050', '51', NULL, '2024-12-04 20:04:14.000000'),
       (42, 10, 4, '040518', '40244', '16802', '91243 - 92480', '98607 - 04236 - 04242 - 79261 - 42963 - 17876 - 90534',
        '6033', '4325 - 6930 - 9290', '276', '32', NULL, '2024-12-04 20:04:14.000000'),
       (43, 11, 2, '766403', '20421', '95982', '10101 - 44304', '36610 - 12809 - 54136 - 01400 - 12363 - 16288 - 50333',
        '0491', '3302 - 7194 - 7197', '638', '85', NULL, '2024-12-04 20:04:14.000000'),
       (44, 31, 6, '734172', '61543', '33503', '71263 - 02707', '67034 - 54005 - 38036 - 44149 - 17327 - 36297 - 46885',
        '9890', '9767 - 4792 - 2488', '373', '02', NULL, '2024-12-04 20:04:14.000000'),
       (45, 13, 5, '910758', '38943', '83196', '27818 - 98745', '60469 - 60108 - 60303 - 51470 - 54658 - 26391 - 27979',
        '1499', '0551 - 1792 - 3674', '349', '07', NULL, '2024-12-04 20:04:14.000000'),
       (46, 32, 5, '491288', '91549', '58495', '47697 - 73323', '99214 - 56043 - 32467 - 17278 - 16965 - 19644 - 06135',
        '5672', '5018 - 3194 - 9968', '371', '65', NULL, '2024-12-04 20:04:14.000000'),
       (47, 1, 1, '613708', '72858', '33356', '06945 - 70036', '19676 - 21440 - 66247 - 85170 - 66115 - 29635 - 10534',
        '0514', '7426 - 5933 - 4366', '071', '43', NULL, '2024-12-04 20:04:14.000000'),
       (48, 33, 7, '711691', '79399', '55469', '76609 - 81615', '84011 - 59127 - 47034 - 85659 - 55730 - 92637 - 95242',
        '3243', '7271 - 7050 - 3315', '737', '92', NULL, '2024-12-04 20:04:14.000000'),
       (49, 34, 5, '728636', '74427', '89133', '60243 - 06547', '14646 - 30989 - 01331 - 91543 - 98644 - 38653 - 95282',
        '7902', '7892 - 9256 - 5060', '190', '10', NULL, '2024-12-04 20:04:14.000000'),
       (50, 17, 5, '340805', '69509', '15531', '40622 - 70861', '72877 - 60323 - 07267 - 46542 - 85866 - 74394 - 15968',
        '3412', '0089 - 2755 - 0182', '190', '32', NULL, '2024-12-04 20:04:14.000000'),
       (51, 3, 7, '34086', '56378', '47228 - 16867', '55484 - 71800 - 37420 - 93477 - 78700 - 15479',
        '6906 - 0875 - 3634 - 0786', '2140 - 5531 - 5576 - 9138 - 0466 - 9379', '479 - 435 - 895', '70 - 32 - 50 - 04',
        NULL, NULL, '2024-12-04 20:04:14.000000'),
       (52, 5, 4, '838992', '98899', '06754', '80112 - 98791', '24494 - 68331 - 62164 - 16423 - 43208 - 30307 - 23444',
        '9506', '8681 - 3865 - 7136', '366', '65', NULL, '2024-12-04 20:04:14.000000'),
       (53, 35, 6, '634513', '88264', '85554', '91057 - 43011', '93379 - 79816 - 50535 - 21705 - 87105 - 09600 - 13490',
        '0618', '4600 - 9182 - 7546', '600', '12', NULL, '2024-12-04 20:04:14.000000'),
       (54, 19, 1, '965779', '87216', '59160', '06144 - 20176', '55195 - 84121 - 87328 - 87996 - 53263 - 94181 - 80948',
        '0693', '7227 - 7276 - 7005', '193', '37', NULL, '2024-12-04 20:04:14.000000'),
       (55, 20, 1, '304879', '86021', '83510', '32200 - 19546', '53310 - 95733 - 11210 - 24974 - 28115 - 62565 - 55993',
        '7706', '8006 - 6486 - 9935', '433', '61', NULL, '2024-12-04 20:04:14.000000'),
       (56, 36, 2, '127104', '29341', '75011', '16592 - 14409', '55157 - 50981 - 37092 - 53265 - 72300 - 04906 - 96124',
        '6755', '2521 - 0859 - 5703', '879', '45', NULL, '2024-12-04 20:04:14.000000'),
       (57, 7, 4, '668983', '68078', '09979', '97460 - 81310', '05188 - 74104 - 75674 - 35002 - 08825 - 06441 - 12832',
        '5917', '4566 - 2148 - 9909', '555', '69', NULL, '2024-12-04 20:04:14.000000');

