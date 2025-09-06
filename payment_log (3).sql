-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 30, 2025 at 11:15 PM
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
-- Table structure for table `payment_log`
--

CREATE TABLE `payment_log` (
  `id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `total_amount_paid` decimal(18,2) DEFAULT NULL,
  `description` varchar(1000) NOT NULL,
  `amount_newly_paid` decimal(18,2) DEFAULT NULL,
  `balance` decimal(18,2) DEFAULT NULL,
  `payment_method_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `session_id` varchar(100) NOT NULL,
  `term_id` varchar(100) NOT NULL,
  `class_id` varchar(100) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `date_paid` date NOT NULL,
  `createdby` int(11) NOT NULL,
  `datecreated` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_log`
--

INSERT INTO `payment_log` (`id`, `bill_id`, `total_amount_paid`, `description`, `amount_newly_paid`, `balance`, `payment_method_id`, `student_id`, `school_id`, `session_id`, `term_id`, `class_id`, `status`, `date_paid`, `createdby`, `datecreated`) VALUES
(8, 38, 100.00, '100 paid', 100.00, 945.81, 1, 246, 13, '2', '1', '44', 2, '2025-06-24', 57, '2025-06-24 21:16:05');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `payment_log`
--
ALTER TABLE `payment_log`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `payment_log`
--
ALTER TABLE `payment_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
