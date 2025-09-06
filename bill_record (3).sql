-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 30, 2025 at 11:11 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ss360`
--

-- --------------------------------------------------------

--
-- Table structure for table `bill_record`
--

CREATE TABLE `bill_record` (
  `id` int(11) NOT NULL,
  `bill_type` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `term_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `amount` decimal(12,2) DEFAULT NULL COMMENT 'subtotal',
  `amount_due` decimal(18,2) DEFAULT NULL,
  `createdby` int(11) NOT NULL,
  `datecreated` datetime NOT NULL,
  `updatedby` int(11) NOT NULL,
  `dateupdated` datetime NOT NULL,
  `bill_items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `deduction_purpose` varchar(500) NOT NULL,
  `deduction_percentage` decimal(5,2) DEFAULT NULL,
  `notes` varchar(1000) NOT NULL,
  `terms` varchar(1000) NOT NULL,
  `tax` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bill_record`
--

INSERT INTO `bill_record` (`id`, `bill_type`, `student_id`, `school_id`, `class_id`, `term_id`, `session_id`, `amount`, `amount_due`, `createdby`, `datecreated`, `updatedby`, `dateupdated`, `bill_items`, `deduction_purpose`, `deduction_percentage`, `notes`, `terms`, `tax`) VALUES
(34, 9, 245, 13, 44, 1, 2, 10000.00, 9720.00, 57, '2025-06-21 00:35:25', 57, '2025-06-21 00:35:25', '[{\"Shirt\":3000},{\"Bicylc\":6000}]', '0', 9.99, '0', 'terms edited', 8.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bill_record`
--
ALTER TABLE `bill_record`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bill_record`
--
ALTER TABLE `bill_record`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
