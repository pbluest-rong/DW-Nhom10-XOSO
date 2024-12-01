-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 30, 2024 at 01:43 PM
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
                          `destination_table_dw` varchar(255) DEFAULT NULL,
                          `destination_table_staging` varchar(255) DEFAULT NULL,
                          `name` varchar(255) NOT NULL,
                          `procedure_name` varchar(255) DEFAULT NULL,
                          `province` varchar(255) DEFAULT NULL,
                          `source` varchar(255) DEFAULT NULL,
                          `source_location` varchar(255) DEFAULT NULL,
                          `type` enum('CRAWL_DATA','LOAD_TO_DW','LOAD_TO_STAGING') DEFAULT NULL
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
                       `count` varchar(255) DEFAULT NULL,
                       `date` date NOT NULL,
                       `dt_update` date NOT NULL,
                       `file_size` float NOT NULL,
                       `filename` varchar(255) DEFAULT NULL,
                       `message` varchar(255) DEFAULT NULL,
                       `status` enum('FAILURE','IN_PROGRESS','PENDING','SUCCESS') DEFAULT NULL,
                       `id_config` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lottery`
--

CREATE TABLE `lottery` (
                           `id` bigint(20) NOT NULL,
                           `created_at` datetime(6) DEFAULT NULL,
                           `date_delete` datetime(6) DEFAULT NULL,
                           `date_insert` datetime(6) DEFAULT NULL,
                           `date_id` bigint(20) DEFAULT NULL,
                           `expired_date` datetime(6) DEFAULT NULL,
                           `is_delete` bit(1) NOT NULL,
                           `prize_eight` varchar(255) DEFAULT NULL,
                           `prize_five` varchar(255) DEFAULT NULL,
                           `prize_four` varchar(255) DEFAULT NULL,
                           `prize_one` varchar(255) DEFAULT NULL,
                           `prize_seven` varchar(255) DEFAULT NULL,
                           `prize_six` varchar(255) DEFAULT NULL,
                           `prize_special` varchar(255) DEFAULT NULL,
                           `prize_three` varchar(255) DEFAULT NULL,
                           `prize_two` varchar(255) DEFAULT NULL,
                           `province_id` bigint(20) DEFAULT NULL
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
                                   `created_at` varchar(255) DEFAULT NULL,
                                   `date` varchar(255) DEFAULT NULL,
                                   `prize_eight` varchar(255) DEFAULT NULL,
                                   `prize_five` varchar(255) DEFAULT NULL,
                                   `prize_four` varchar(255) DEFAULT NULL,
                                   `prize_one` varchar(255) DEFAULT NULL,
                                   `prize_seven` varchar(255) DEFAULT NULL,
                                   `prize_six` varchar(255) DEFAULT NULL,
                                   `prize_special` varchar(255) DEFAULT NULL,
                                   `prize_three` varchar(255) DEFAULT NULL,
                                   `prize_two` varchar(255) DEFAULT NULL,
                                   `province` varchar(255) DEFAULT NULL
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

-- Chuyển sang cơ sở dữ liệu 'lottery_db'
USE lottery_db;

-- Xóa thủ tục nếu nó đã tồn tại
DROP PROCEDURE IF EXISTS transform_load_data_to_warehouse;

DELIMITER $$

-- Tạo thủ tục transform_load_data_to_warehouse
CREATE PROCEDURE transform_load_data_to_warehouse()
BEGIN
    DECLARE curr_date DATE;
    SET curr_date = CURDATE(); -- Lấy ngày hiện tại

    -- Bước 1: Chèn các tỉnh duy nhất vào bảng 'province' nếu chưa có
INSERT INTO province (name)
SELECT DISTINCT province
FROM staging_lottery
WHERE province NOT IN (SELECT name FROM province);

-- Bước 2: Chèn các ngày duy nhất vào bảng 'date' nếu chưa có
INSERT INTO date (day, month, year)
SELECT DISTINCT
    DAY(STR_TO_DATE(date, '%d/%m/%Y')) AS day,
    MONTH(STR_TO_DATE(date, '%d/%m/%Y')) AS month,
    YEAR(STR_TO_DATE(date, '%d/%m/%Y')) AS year
FROM staging_lottery
WHERE (DAY(STR_TO_DATE(date, '%d/%m/%Y')),
    MONTH(STR_TO_DATE(date, '%d/%m/%Y')),
    YEAR(STR_TO_DATE(date, '%d/%m/%Y')))
    NOT IN (SELECT day, month, year FROM date);

-- Bước 3: Cập nhật các bản ghi đã xóa trong bảng 'lottery'
UPDATE lottery AS l
    LEFT JOIN staging_lottery AS stg
ON l.province_id = (SELECT id FROM province WHERE name = stg.province)
    AND l.date_id = (SELECT id FROM date
    WHERE day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y')))
    SET l.is_delete = TRUE, -- Đánh dấu bản ghi là đã xóa
        l.expired_date = curr_date,
        l.date_delete = curr_date
WHERE stg.id IS NULL AND l.is_delete = FALSE;

-- Bước 4: Chèn các bản ghi mới vào bảng 'lottery'
INSERT INTO lottery (
    province_id, date_id, prize_special, prize_one, prize_two, prize_three,
    prize_four, prize_five, prize_six, prize_seven, prize_eight,
    created_at, date_insert, is_delete
)
SELECT
    (SELECT id FROM province WHERE name = stg.province) AS province_id,
    (SELECT id FROM date
     WHERE day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
           AND month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
           AND year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y'))) AS date_id,
        stg.prize_special, stg.prize_one, stg.prize_two, stg.prize_three,
        stg.prize_four, stg.prize_five, stg.prize_six, stg.prize_seven, stg.prize_eight,
        NOW() AS created_at, NOW() AS date_insert, FALSE AS is_delete
FROM staging_lottery AS stg
    LEFT JOIN lottery AS l
ON (SELECT id FROM province WHERE name = stg.province) = l.province_id
    AND (SELECT id FROM date
    WHERE day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y'))) = l.date_id
WHERE l.id IS NULL;

-- Bước 5: Cập nhật các bản ghi trong bảng 'lottery' nếu có thay đổi
UPDATE lottery AS l
    INNER JOIN staging_lottery AS stg
ON l.province_id = (SELECT id FROM province WHERE name = stg.province)
    AND l.date_id = (SELECT id FROM date
    WHERE day = DAY(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND month = MONTH(STR_TO_DATE(stg.date, '%d/%m/%Y'))
    AND year = YEAR(STR_TO_DATE(stg.date, '%d/%m/%Y')))
    SET l.prize_special = stg.prize_special,
        l.prize_one = stg.prize_one,
        l.prize_two = stg.prize_two,
        l.prize_three = stg.prize_three,
        l.prize_four = stg.prize_four,
        l.prize_five = stg.prize_five,
        l.prize_six = stg.prize_six,
        l.prize_seven = stg.prize_seven,
        l.prize_eight = stg.prize_eight,
        l.expired_date = NULL, -- Reset ngày hết hạn
        l.is_delete = FALSE; -- Đánh dấu là không bị xóa

END$$

DELIMITER ;
