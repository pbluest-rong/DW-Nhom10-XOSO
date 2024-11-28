-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2024 at 05:03 AM
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
-- Table structure for table `configs`
--

CREATE TABLE `configs` (
                           `config_id` int(11) NOT NULL,
                           `dw_fields` text DEFAULT NULL,
                           `fields_terminated_by` varchar(255) DEFAULT NULL,
                           `file_name` varchar(255) DEFAULT NULL,
                           `ignore_rows` int(11) DEFAULT NULL,
                           `lines_terminated_by` varchar(255) DEFAULT NULL,
                           `optionally_enclosed_by` varchar(255) DEFAULT NULL,
                           `property_id` int(11) DEFAULT NULL,
                           `save_location` varchar(255) DEFAULT NULL,
                           `schedule` bigint(20) DEFAULT NULL,
                           `staging_fields` text DEFAULT NULL,
                           `staging_table` varchar(255) DEFAULT NULL,
                           `tble_staging` varchar(255) DEFAULT NULL,
                           `tble_warehouse` varchar(255) DEFAULT NULL,
                           `url` varchar(255) DEFAULT NULL
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
-- Table structure for table `etl_logs`
--

CREATE TABLE `etl_logs` (
                            `id` bigint(20) NOT NULL,
                            `process_name` varchar(255) DEFAULT NULL,
                            `log_message` varchar(255) DEFAULT NULL,
                            `status` varchar(255) DEFAULT NULL,
                            `timestamp` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `etl_logs`
--

-- --------------------------------------------------------

--
-- Table structure for table `file_logs`
--

CREATE TABLE `file_logs` (
                             `file_log_id` int(11) NOT NULL,
                             `config_id` int(11) DEFAULT NULL,
                             `count` int(11) DEFAULT NULL,
                             `end_time` datetime(6) DEFAULT NULL,
                             `file_path` varchar(255) DEFAULT NULL,
                             `file_size` decimal(38,2) DEFAULT NULL,
                             `start_time` datetime(6) DEFAULT NULL,
                             `status` enum('C_E','C_FE','C_RE','C_SE','L_CE','L_FE','L_P','L_RE','L_SE') NOT NULL,
                             `time` varchar(255) DEFAULT NULL,
                             `update_at` datetime(6) DEFAULT NULL
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
                           `created_at` datetime(6) DEFAULT NULL,
                           `date_insert` datetime(6) DEFAULT NULL,
                           `is_delete` bit(1) NOT NULL,
                           `date_delete` datetime(6) DEFAULT NULL,
                           `expired_date` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `process_properties`
--

CREATE TABLE `process_properties` (
                                      `property_id` bigint(20) NOT NULL,
                                      `name` varchar(255) NOT NULL,
                                      `header_csv` text DEFAULT NULL,
                                      `value` text DEFAULT NULL,
                                      `last_modified` datetime(6) DEFAULT NULL
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
                                   `created_at` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `configs`
--
ALTER TABLE `configs`
    ADD PRIMARY KEY (`config_id`);

--
-- Indexes for table `date`
--
ALTER TABLE `date`
    ADD PRIMARY KEY (`id`);

--
-- Indexes for table `etl_logs`
--
ALTER TABLE `etl_logs`
    ADD PRIMARY KEY (`id`);

--
-- Indexes for table `file_logs`
--
ALTER TABLE `file_logs`
    ADD PRIMARY KEY (`file_log_id`);

--
-- Indexes for table `lottery`
--
ALTER TABLE `lottery`
    ADD PRIMARY KEY (`id`),
  ADD KEY `FKbov2b8or3mn851dcw08q5udot` (`date_id`),
  ADD KEY `FKe91r3lyevqqmtnomehhyck7ne` (`province_id`);

--
-- Indexes for table `process_properties`
--
ALTER TABLE `process_properties`
    ADD PRIMARY KEY (`property_id`);

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
-- AUTO_INCREMENT for table `configs`
--
ALTER TABLE `configs`
    MODIFY `config_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `date`
--
ALTER TABLE `date`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `etl_logs`
--
ALTER TABLE `etl_logs`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `file_logs`
--
ALTER TABLE `file_logs`
    MODIFY `file_log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lottery`
--
ALTER TABLE `lottery`
    MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `process_properties`
--
ALTER TABLE `process_properties`
    MODIFY `property_id` bigint(20) NOT NULL AUTO_INCREMENT;

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
-- Constraints for table `lottery`
--
ALTER TABLE `lottery`
    ADD CONSTRAINT `FKbov2b8or3mn851dcw08q5udot` FOREIGN KEY (`date_id`) REFERENCES `date` (`id`),
  ADD CONSTRAINT `FKe91r3lyevqqmtnomehhyck7ne` FOREIGN KEY (`province_id`) REFERENCES `province` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
