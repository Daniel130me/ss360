-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 22, 2025 at 10:53 AM
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
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `middlename` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `photo` varchar(200) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `dob` date NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `createdby` int(11) NOT NULL,
  `updatedby` int(11) NOT NULL,
  `datecreated` datetime(6) NOT NULL,
  `dateupdated` datetime(4) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `passw` varchar(500) NOT NULL,
  `admission_no` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `firstname`, `middlename`, `lastname`, `photo`, `parent_id`, `school_id`, `class_id`, `gender`, `dob`, `phone`, `email`, `createdby`, `updatedby`, `datecreated`, `dateupdated`, `status`, `passw`, `admission_no`) VALUES
(54, 'David', 'Ojonugwa', 'Ata', 'avatar.png', 52, 13, 44, 'Male', '2002-01-20', '08063244568', 'oloyede@gmail.com', 57, 57, '2024-08-20 12:32:51.000000', '2025-03-12 10:20:31.0000', 1, '', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=341;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
