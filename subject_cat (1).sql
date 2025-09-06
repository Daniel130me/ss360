-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 22, 2025 at 10:52 AM
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
-- Table structure for table `subject_cat`
--

CREATE TABLE `subject_cat` (
  `id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `createdby` int(11) NOT NULL,
  `datecreated` datetime NOT NULL,
  `dateupdated` datetime NOT NULL,
  `updatedby` int(11) NOT NULL,
  `subject_ids` varchar(200) NOT NULL,
  `school_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subject_cat`
--

INSERT INTO `subject_cat` (`id`, `category_name`, `createdby`, `datecreated`, `dateupdated`, `updatedby`, `subject_ids`, `school_id`) VALUES
(1, 'Primary', 0, '2024-08-20 12:29:49', '0000-00-00 00:00:00', 0, '65,92,4,16,62,2,23,15,58,1,14,19', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `subject_cat`
--
ALTER TABLE `subject_cat`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `subject_cat`
--
ALTER TABLE `subject_cat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
