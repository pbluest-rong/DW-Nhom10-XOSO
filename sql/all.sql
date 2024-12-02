-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 02, 2024 at 07:40 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lottery_db`
--
CREATE DATABASE IF NOT EXISTS `lottery_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `lottery_db`;

-- --------------------------------------------------------

--
-- Table structure for table `config`
--

CREATE TABLE `config` (
                          `id` bigint(20) NOT NULL,
                          `type` enum('CRAWL_DATA','LOAD_TO_DW','LOAD_TO_STAGING') DEFAULT NULL,
                          `create_at` date DEFAULT NULL,
                          `name` varchar(255) NOT NULL,
                          `province` varchar(255) DEFAULT NULL,
                          `source` varchar(255) DEFAULT NULL,
                          `source_location` varchar(255) DEFAULT NULL,
                          `procedure_name` varchar(255) DEFAULT NULL,
                          `destination_table_dw` varchar(255) DEFAULT NULL,
                          `destination_table_staging` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `date`
--

CREATE TABLE `date` (
                        `id` bigint(20) NOT NULL,
                        `day` int(11) NOT NULL,
                        `month` int(11) NOT NULL,
                        `year` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
                       `id` bigint(20) NOT NULL,
                       `id_config` bigint(20) NOT NULL,
                       `date` date NOT NULL,
                       `province` varchar(255) DEFAULT NULL,
                       `status` enum('FAILURE','IN_PROGRESS','PENDING','SUCCESS') DEFAULT NULL,
                       `count` int(11) DEFAULT NULL,
                       `file_size` bigint(20) DEFAULT NULL,
                       `message` varchar(255) DEFAULT NULL,
                       `dt_update` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lottery`
--

CREATE TABLE `lottery` (
                           `id` bigint(20) NOT NULL,
                           `province_id` bigint(20) DEFAULT NULL,
                           `date_id` bigint(20) DEFAULT NULL,
                           `prize_special` varchar(255) DEFAULT NULL,
                           `prize_one` varchar(255) DEFAULT NULL,
                           `prize_two` varchar(255) DEFAULT NULL,
                           `prize_three` varchar(255) DEFAULT NULL,
                           `prize_four` varchar(255) DEFAULT NULL,
                           `prize_five` varchar(255) DEFAULT NULL,
                           `prize_six` varchar(255) DEFAULT NULL,
                           `prize_seven` varchar(255) DEFAULT NULL,
                           `prize_eight` varchar(255) DEFAULT NULL,
                           `date_delete` datetime(6) DEFAULT NULL,
                           `modify_date` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `province`
--

CREATE TABLE `province` (
                            `id` bigint(20) NOT NULL,
                            `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staging_lottery`
--

CREATE TABLE `staging_lottery` (
                                   `id` bigint(20) NOT NULL,
                                   `province` varchar(255) DEFAULT NULL,
                                   `date` varchar(255) DEFAULT NULL,
                                   `prize_special` varchar(255) DEFAULT NULL,
                                   `prize_one` varchar(255) DEFAULT NULL,
                                   `prize_two` varchar(255) DEFAULT NULL,
                                   `prize_three` varchar(255) DEFAULT NULL,
                                   `prize_four` varchar(255) DEFAULT NULL,
                                   `prize_five` varchar(255) DEFAULT NULL,
                                   `prize_six` varchar(255) DEFAULT NULL,
                                   `prize_seven` varchar(255) DEFAULT NULL,
                                   `prize_eight` varchar(255) DEFAULT NULL,
                                   `create_at` date DEFAULT NULL
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
DELIMITER $$

CREATE PROCEDURE transform_load_data_to_warehouse()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        ROLLBACK;

    -- Bắt đầu giao dịch
START TRANSACTION;

-- Bước 1: Chèn các tỉnh duy nhất vào bảng 'province' nếu chưa có
INSERT IGNORE INTO province (name)
SELECT DISTINCT province
FROM staging_lottery;

-- Bước 2: Chèn các ngày duy nhất vào bảng 'date' nếu chưa có
INSERT IGNORE INTO date (day, month, year)
SELECT DISTINCT
    DAY(STR_TO_DATE(date, '%d/%m/%Y')) AS day,
    MONTH(STR_TO_DATE(date, '%d/%m/%Y')) AS month,
    YEAR(STR_TO_DATE(date, '%d/%m/%Y')) AS year
FROM staging_lottery;

-- Bước 3: Chèn hoặc cập nhật vào bảng 'lottery'
INSERT INTO lottery (
    province_id, date_id, prize_special, prize_one, prize_two, prize_three,
    prize_four, prize_five, prize_six, prize_seven, prize_eight,
    date_delete, modify_date
)
SELECT
    p.id AS province_id,
    d.id AS date_id,
    stg.prize_special, stg.prize_one, stg.prize_two, stg.prize_three,
    stg.prize_four, stg.prize_five, stg.prize_six, stg.prize_seven, stg.prize_eight,
    NULL AS date_delete,
    NOW() AS modify_date
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
    AND l.prize_eight = stg.prize_eight
WHERE l.id IS NULL; -- Chỉ chèn nếu không có bản ghi nào hoàn toàn trùng khớp

-- Bước 4: Xóa các bản ghi đã xử lý trong bảng 'staging_lottery'
DELETE stg
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