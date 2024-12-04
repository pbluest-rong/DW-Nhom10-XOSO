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


--
-- Dumping data for table `config`
--

INSERT INTO `config` (`id`, `type`, `create_at`, `name`, `province`, `source`, `source_location`, `procedure_name`, `destination_table_dw`, `destination_table_staging`) VALUES
(1, 'CRAWL_DATA', '2024-12-01', 'Crawl Bến Tre', 'Bến Tre', 'https://www.xoso.net/getkqxs/ben-tre/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(2, 'CRAWL_DATA', '2024-12-01', 'Crawl Cần Thơ', 'Cần Thơ', 'https://www.xoso.net/getkqxs/can-tho/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(3, 'CRAWL_DATA', '2024-12-01', 'Crawl Cà Mau', 'Cà Mau', 'https://www.xoso.net/getkqxs/ca-mau/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(4, 'CRAWL_DATA', '2024-12-01', 'Crawl Đắk Nông', 'Đắk Nông', 'https://www.xoso.net/getkqxs/dak-nong/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(5, 'CRAWL_DATA', '2024-12-01', 'Crawl Bình Dương', 'Bình Dương', 'https://www.xoso.net/getkqxs/binh-duong/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(6, 'CRAWL_DATA', '2024-12-01', 'Crawl Đồng Nai', 'Đồng Nai', 'https://www.xoso.net/getkqxs/dong-nai/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(7, 'CRAWL_DATA', '2024-12-01', 'Crawl Đồng Tháp', 'Đồng Tháp', 'https://www.xoso.net/getkqxs/dong-thap/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(8, 'CRAWL_DATA', '2024-12-01', 'Crawl Miền Bắc', 'Miền Bắc', 'https://www.xoso.net/getkqxs/mien-bac/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(9, 'CRAWL_DATA', '2024-12-01', 'Crawl Bình Định', 'Bình Định', 'https://www.xoso.net/getkqxs/binh-dinh/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(10, 'CRAWL_DATA', '2024-12-01', 'Crawl Bình Thuận', 'Bình Thuận', 'https://www.xoso.net/getkqxs/binh-thuan/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(11, 'CRAWL_DATA', '2024-12-01', 'Crawl Bình Phước', 'Bình Phước', 'https://www.xoso.net/getkqxs/binh-phuoc/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(12, 'CRAWL_DATA', '2024-12-01', 'Crawl Đắk Lắk', 'Đắk Lắk', 'https://www.xoso.net/getkqxs/dak-lak/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(13, 'CRAWL_DATA', '2024-12-01', 'Crawl Bạc Liêu', 'Bạc Liêu', 'https://www.xoso.net/getkqxs/bac-lieu/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(14, 'CRAWL_DATA', '2024-12-01', 'Crawl An Giang', 'An Giang', 'https://www.xoso.net/getkqxs/an-giang/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(15, 'CRAWL_DATA', '2024-12-01', 'Crawl Đà Lạt', 'Đà Lạt', 'https://www.xoso.net/getkqxs/da-lat/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(16, 'CRAWL_DATA', '2024-12-01', 'Crawl Đà Nẵng', 'Đà Nẵng', 'https://www.xoso.net/getkqxs/da-nang/01-12-2024.js', 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(17, 'LOAD_TO_STAGING', '2024-12-01', 'Load staging ', NULL, NULL, 'D:\\DW\\01-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(18, 'LOAD_TO_DW', '2024-12-01', 'Load DW', NULL, NULL, NULL, NULL, 'lottery', 'staging_lottery'),
(19, 'CRAWL_DATA', '2024-12-02', 'Crawl Kon Tum', 'Kon Tum', 'https://www.xoso.net/getkqxs/kon-tum/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(20, 'CRAWL_DATA', '2024-12-02', 'Crawl Quảng Bình', 'Quảng Bình', 'https://www.xoso.net/getkqxs/quang-binh/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(21, 'CRAWL_DATA', '2024-12-02', 'Crawl Vĩnh Long', 'Vĩnh Long', 'https://www.xoso.net/getkqxs/vinh-long/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(22, 'CRAWL_DATA', '2024-12-02', 'Crawl Quảng Trị', 'Quảng Trị', 'https://www.xoso.net/getkqxs/quang-tri/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(23, 'CRAWL_DATA', '2024-12-02', 'Crawl Vũng Tàu', 'Vũng Tàu', 'https://www.xoso.net/getkqxs/vung-tau/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(24, 'CRAWL_DATA', '2024-12-02', 'Crawl Phú Yên', 'Phú Yên', 'https://www.xoso.net/getkqxs/phu-yen/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(25, 'CRAWL_DATA', '2024-12-02', 'Crawl Tiền Giang', 'Tiền Giang', 'https://www.xoso.net/getkqxs/tien-giang/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(26, 'CRAWL_DATA', '2024-12-02', 'Crawl Ninh Thuận', 'Ninh Thuận', 'https://www.xoso.net/getkqxs/ninh-thuan/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(27, 'CRAWL_DATA', '2024-12-02', 'Crawl Trà Vinh', 'Trà Vinh', 'https://www.xoso.net/getkqxs/tra-vinh/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(28, 'CRAWL_DATA', '2024-12-02', 'Crawl Quảng Nam', 'Quảng Nam', 'https://www.xoso.net/getkqxs/quang-nam/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(29, 'CRAWL_DATA', '2024-12-02', 'Crawl TP. HCM', 'TP. HCM', 'https://www.xoso.net/getkqxs/tp-hcm/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(30, 'CRAWL_DATA', '2024-12-02', 'Crawl Long An', 'Long An', 'https://www.xoso.net/getkqxs/long-an/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(31, 'CRAWL_DATA', '2024-12-02', 'Crawl Hậu Giang', 'Hậu Giang', 'https://www.xoso.net/getkqxs/hau-giang/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(32, 'CRAWL_DATA', '2024-12-02', 'Crawl Quảng Ngãi', 'Quảng Ngãi', 'https://www.xoso.net/getkqxs/quang-ngai/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(33, 'CRAWL_DATA', '2024-12-02', 'Crawl Tây Ninh', 'Tây Ninh', 'https://www.xoso.net/getkqxs/tay-ninh/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(34, 'CRAWL_DATA', '2024-12-02', 'Crawl Kiên Giang', 'Kiên Giang', 'https://www.xoso.net/getkqxs/kien-giang/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(35, 'CRAWL_DATA', '2024-12-02', 'Crawl Gia Lai', 'Gia Lai', 'https://www.xoso.net/getkqxs/gia-lai/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(36, 'CRAWL_DATA', '2024-12-02', 'Crawl Sóc Trăng', 'Sóc Trăng', 'https://www.xoso.net/getkqxs/soc-trang/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(37, 'CRAWL_DATA', '2024-12-02', 'Crawl Khánh Hòa', 'Khánh Hòa', 'https://www.xoso.net/getkqxs/khanh-hoa/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(38, 'CRAWL_DATA', '2024-12-02', 'Crawl Thừa Thiên Huế', 'Thừa Thiên Huế', 'https://www.xoso.net/getkqxs/thua-thien-hue/02-12-2024.js', 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(39, 'LOAD_TO_STAGING', '2024-12-02', 'Load staging ', NULL, NULL, 'D:\\DW\\02-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(40, 'LOAD_TO_DW', '2024-12-02', 'Load DW', NULL, NULL, NULL, NULL, 'lottery', 'staging_lottery'),
(41, 'CRAWL_DATA', '2024-12-04', 'Crawl Kon Tum', 'Kon Tum', 'https://www.xoso.net/getkqxs/kon-tum/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(42, 'CRAWL_DATA', '2024-12-04', 'Crawl Bến Tre', 'Bến Tre', 'https://www.xoso.net/getkqxs/ben-tre/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(43, 'CRAWL_DATA', '2024-12-04', 'Crawl Quảng Trị', 'Quảng Trị', 'https://www.xoso.net/getkqxs/quang-tri/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(44, 'CRAWL_DATA', '2024-12-04', 'Crawl Tiền Giang', 'Tiền Giang', 'https://www.xoso.net/getkqxs/tien-giang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(45, 'CRAWL_DATA', '2024-12-04', 'Crawl Cần Thơ', 'Cần Thơ', 'https://www.xoso.net/getkqxs/can-tho/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(46, 'CRAWL_DATA', '2024-12-04', 'Crawl Bình Dương', 'Bình Dương', 'https://www.xoso.net/getkqxs/binh-duong/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(47, 'CRAWL_DATA', '2024-12-04', 'Crawl Ninh Thuận', 'Ninh Thuận', 'https://www.xoso.net/getkqxs/ninh-thuan/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(48, 'CRAWL_DATA', '2024-12-04', 'Crawl Trà Vinh', 'Trà Vinh', 'https://www.xoso.net/getkqxs/tra-vinh/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(49, 'CRAWL_DATA', '2024-12-04', 'Crawl Quảng Nam', 'Quảng Nam', 'https://www.xoso.net/getkqxs/quang-nam/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(50, 'CRAWL_DATA', '2024-12-04', 'Crawl Long An', 'Long An', 'https://www.xoso.net/getkqxs/long-an/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(51, 'CRAWL_DATA', '2024-12-04', 'Crawl Bình Định', 'Bình Định', 'https://www.xoso.net/getkqxs/binh-dinh/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(52, 'CRAWL_DATA', '2024-12-04', 'Crawl Bình Phước', 'Bình Phước', 'https://www.xoso.net/getkqxs/binh-phuoc/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(53, 'CRAWL_DATA', '2024-12-04', 'Crawl Bạc Liêu', 'Bạc Liêu', 'https://www.xoso.net/getkqxs/bac-lieu/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(54, 'CRAWL_DATA', '2024-12-04', 'Crawl Tây Ninh', 'Tây Ninh', 'https://www.xoso.net/getkqxs/tay-ninh/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(55, 'CRAWL_DATA', '2024-12-04', 'Crawl Kiên Giang', 'Kiên Giang', 'https://www.xoso.net/getkqxs/kien-giang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(56, 'CRAWL_DATA', '2024-12-04', 'Crawl Sóc Trăng', 'Sóc Trăng', 'https://www.xoso.net/getkqxs/soc-trang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(57, 'CRAWL_DATA', '2024-12-04', 'Crawl Đà Lạt', 'Đà Lạt', 'https://www.xoso.net/getkqxs/da-lat/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(58, 'CRAWL_DATA', '2024-12-04', 'Crawl Đà Nẵng', 'Đà Nẵng', 'https://www.xoso.net/getkqxs/da-nang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(59, 'CRAWL_DATA', '2024-12-04', 'Crawl Khánh Hòa', 'Khánh Hòa', 'https://www.xoso.net/getkqxs/khanh-hoa/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(60, 'CRAWL_DATA', '2024-12-04', 'Crawl Thừa Thiên Huế', 'Thừa Thiên Huế', 'https://www.xoso.net/getkqxs/thua-thien-hue/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(61, 'CRAWL_DATA', '2024-12-04', 'Crawl Quảng Bình', 'Quảng Bình', 'https://www.xoso.net/getkqxs/quang-binh/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(62, 'CRAWL_DATA', '2024-12-04', 'Crawl Vĩnh Long', 'Vĩnh Long', 'https://www.xoso.net/getkqxs/vinh-long/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(63, 'CRAWL_DATA', '2024-12-04', 'Crawl Vũng Tàu', 'Vũng Tàu', 'https://www.xoso.net/getkqxs/vung-tau/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(64, 'CRAWL_DATA', '2024-12-04', 'Crawl Phú Yên', 'Phú Yên', 'https://www.xoso.net/getkqxs/phu-yen/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(65, 'CRAWL_DATA', '2024-12-04', 'Crawl Cà Mau', 'Cà Mau', 'https://www.xoso.net/getkqxs/ca-mau/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(66, 'CRAWL_DATA', '2024-12-04', 'Crawl Đắk Nông', 'Đắk Nông', 'https://www.xoso.net/getkqxs/dak-nong/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(67, 'CRAWL_DATA', '2024-12-04', 'Crawl Đồng Nai', 'Đồng Nai', 'https://www.xoso.net/getkqxs/dong-nai/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(68, 'CRAWL_DATA', '2024-12-04', 'Crawl Đồng Tháp', 'Đồng Tháp', 'https://www.xoso.net/getkqxs/dong-thap/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(69, 'CRAWL_DATA', '2024-12-04', 'Crawl TP. HCM', 'TP. HCM', 'https://www.xoso.net/getkqxs/tp-hcm/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(70, 'CRAWL_DATA', '2024-12-04', 'Crawl Miền Bắc', 'Miền Bắc', 'https://www.xoso.net/getkqxs/mien-bac/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(71, 'CRAWL_DATA', '2024-12-04', 'Crawl Bình Thuận', 'Bình Thuận', 'https://www.xoso.net/getkqxs/binh-thuan/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(72, 'CRAWL_DATA', '2024-12-04', 'Crawl Đắk Lắk', 'Đắk Lắk', 'https://www.xoso.net/getkqxs/dak-lak/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(73, 'CRAWL_DATA', '2024-12-04', 'Crawl Hậu Giang', 'Hậu Giang', 'https://www.xoso.net/getkqxs/hau-giang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(74, 'CRAWL_DATA', '2024-12-04', 'Crawl Quảng Ngãi', 'Quảng Ngãi', 'https://www.xoso.net/getkqxs/quang-ngai/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(75, 'CRAWL_DATA', '2024-12-04', 'Crawl Gia Lai', 'Gia Lai', 'https://www.xoso.net/getkqxs/gia-lai/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(76, 'CRAWL_DATA', '2024-12-04', 'Crawl An Giang', 'An Giang', 'https://www.xoso.net/getkqxs/an-giang/04-12-2024.js', 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(77, 'LOAD_TO_STAGING', '2024-12-04', 'Load staging ', NULL, NULL, 'D:\\DW\\04-12-2024_XSVN.csv', NULL, 'lottery', 'staging_lottery'),
(78, 'LOAD_TO_DW', '2024-12-04', 'Load DW', NULL, NULL, NULL, NULL, 'lottery', 'staging_lottery');

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