-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 10, 2025 at 02:59 PM
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
-- Database: `gxzpywmy_skulz3`
--

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` int(11) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `datecreated` varchar(11) NOT NULL,
  `dateupdate` varchar(11) NOT NULL,
  `createdby` int(11) NOT NULL,
  `updatedby` int(11) NOT NULL,
  `subject_order` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `subject`, `datecreated`, `dateupdate`, `createdby`, `updatedby`, `subject_order`) VALUES
(1, 'Mathematics', '', '', 0, 0, 1),
(2, 'English Language', '', '', 0, 0, 1),
(3, 'ICT', '', '', 0, 0, 0),
(4, 'Basic Science', '', '', 0, 0, 0),
(12, 'Basic Technology', '', '', 0, 0, 0),
(13, 'Basic Science and Technology', '', '', 0, 0, 0),
(14, 'Physical and Health Education', '', '', 0, 0, 0),
(15, 'Information Technology', '', '', 0, 0, 0),
(16, 'Christian Religious Studies', '', '', 0, 0, 0),
(18, 'Civic Education', '', '', 0, 0, 0),
(19, 'Social Studies', '', '', 0, 0, 0),
(20, 'Security Education', '', '', 0, 0, 0),
(23, 'Home Economics', '', '', 0, 0, 0),
(26, 'Igbo', '', '', 0, 0, 0),
(28, 'French', '', '', 0, 0, 0),
(31, 'Store Management', '', '', 0, 0, 0),
(34, 'Physics', '', '', 0, 0, 0),
(35, 'Further Mathematics', '', '', 0, 0, 0),
(38, 'Geography', '', '', 0, 0, 0),
(39, 'Technical Drawing', '', '', 0, 0, 0),
(40, 'Basic Electronics', '', '', 0, 0, 0),
(41, 'Basic Electricity', '', '', 0, 0, 0),
(45, 'History', '', '', 0, 0, 0),
(47, 'Economics', '', '', 0, 0, 0),
(48, 'Commerce', '', '', 0, 0, 0),
(52, 'Theatre Arts', '', '', 0, 0, 0),
(58, 'Islamic Religious Studies', '', '', 0, 0, 0),
(62, 'Cultural and Creative Arts', '', '', 0, 0, 0),
(63, 'Business Studies', '', '', 0, 0, 0),
(65, 'Agricultural Science', '', '', 0, 0, 0),
(66, 'Yoruba', '', '', 0, 0, 0),
(68, 'Hausa', '', '', 0, 0, 0),
(70, 'Data Processing', '', '', 0, 0, 0),
(71, 'Marketing', '', '', 0, 0, 0),
(73, 'Biology', '', '', 0, 0, 0),
(74, 'Chemistry', '', '', 0, 0, 0),
(78, 'Health Education', '', '', 0, 0, 0),
(83, 'Food and Nutrition', '', '', 0, 0, 0),
(84, 'Home Management', '', '', 0, 0, 0),
(85, 'Literature in English', '', '', 0, 0, 0),
(87, 'Government', '', '', 0, 0, 0),
(90, 'Fine Arts', '', '', 0, 0, 0),
(91, 'Music', '', '', 0, 0, 0),
(92, 'Arabic', '', '', 0, 0, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
