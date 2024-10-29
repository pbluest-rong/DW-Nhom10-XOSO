-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 29, 2024 at 07:47 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lottery_dw_db`
--
CREATE DATABASE IF NOT EXISTS `lottery_dw_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `lottery_dw_db`;

-- --------------------------------------------------------

--
-- Table structure for table `date`
--

CREATE TABLE IF NOT EXISTS `date` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `day` int(11) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `file_config`
--

CREATE TABLE IF NOT EXISTS `file_config` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `phase` varchar(50) DEFAULT NULL,
  `source` text DEFAULT NULL,
  `source_name` varchar(30) DEFAULT NULL,
  `area` varchar(20) DEFAULT NULL,
  `path_to_save` varchar(20) DEFAULT NULL,
  `file_name_format` varchar(13) DEFAULT NULL,
  `file_type` varchar(30) DEFAULT NULL,
  `time_get_data` datetime DEFAULT NULL,
  `interval` int(11) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `file_log`
--

CREATE TABLE IF NOT EXISTS `file_log` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `tracking_date_time` datetime DEFAULT NULL,
  `source` text DEFAULT NULL,
  `connect_status` tinyint(4) DEFAULT NULL,
  `destination` varchar(50) DEFAULT NULL,
  `phase` varchar(50) DEFAULT NULL,
  `result` varchar(30) DEFAULT NULL,
  `detail` varchar(100) DEFAULT NULL,
  `is_delete` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lottery`
--

CREATE TABLE IF NOT EXISTS `lottery` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `province_id` int(11) NOT NULL,
  `date_id` int(11) NOT NULL,
  `prize_special` varchar(255) DEFAULT NULL,
  `prize_one` varchar(255) DEFAULT NULL,
  `prize_two` varchar(255) DEFAULT NULL,
  `prize_three` varchar(255) DEFAULT NULL,
  `prize_four` varchar(255) DEFAULT NULL,
  `prize_five` varchar(255) DEFAULT NULL,
  `prize_six` varchar(255) DEFAULT NULL,
  `prize_seven` varchar(255) DEFAULT NULL,
  `prize_eight` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
  KEY `province_id` (`province_id`),
  KEY `date_id` (`date_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `province`
--

CREATE TABLE IF NOT EXISTS `province` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staging_lottery`
--

CREATE TABLE IF NOT EXISTS `staging_lottery` (
  `id` int(11) AUTO_INCREMENT NOT NULL,
  `province` varchar(50) NOT NULL,
  `prize_special` varchar(255) NOT NULL,
  `prize_one` varchar(255) NOT NULL,
  `prize_two` varchar(255) NOT NULL,
  `prize_three` varchar(255) NOT NULL,
  `prize_four` varchar(255) NOT NULL,
  `prize_five` varchar(255) NOT NULL,
  `prize_six` varchar(255) NOT NULL,
  `prize_seven` varchar(255) NOT NULL,
  `prize_eight` varchar(255) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `lottery`
--
ALTER TABLE `lottery`
  ADD CONSTRAINT `lottery_ibfk_1` FOREIGN KEY (`province_id`) REFERENCES `province` (`id`),
  ADD CONSTRAINT `lottery_ibfk_2` FOREIGN KEY (`date_id`) REFERENCES `date` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
