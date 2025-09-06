-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 22, 2025 at 06:19 AM
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
-- Table structure for table `lesson_note`
--

CREATE TABLE `lesson_note` (
  `id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `term_id` int(11) NOT NULL,
  `class_id` varchar(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `week_id` varchar(11) NOT NULL,
  `theme` varchar(100) NOT NULL,
  `topic` varchar(500) NOT NULL,
  `content` varchar(5000) NOT NULL,
  `school_id` int(11) NOT NULL,
  `filedata` longtext NOT NULL,
  `aim` varchar(500) NOT NULL,
  `objective` varchar(1000) NOT NULL,
  `presentation` varchar(1) NOT NULL,
  `evaluation` varchar(1000) NOT NULL,
  `conclusion` varchar(1000) NOT NULL,
  `summary` varchar(1000) NOT NULL,
  `refr` varchar(1000) NOT NULL,
  `subtheme` varchar(1000) NOT NULL,
  `previous_knowledge` varchar(1000) NOT NULL,
  `teaching_aid` varchar(1000) NOT NULL,
  `assignment` varchar(1000) NOT NULL,
  `teacher_remark` varchar(1000) NOT NULL,
  `createdby` int(11) NOT NULL,
  `datecreated` datetime NOT NULL,
  `updatedby` int(11) NOT NULL,
  `dateupdated` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lesson_note`
--

INSERT INTO `lesson_note` (`id`, `session_id`, `term_id`, `class_id`, `subject_id`, `week_id`, `theme`, `topic`, `content`, `school_id`, `filedata`, `aim`, `objective`, `presentation`, `evaluation`, `conclusion`, `summary`, `refr`, `subtheme`, `previous_knowledge`, `teaching_aid`, `assignment`, `teacher_remark`, `createdby`, `datecreated`, `updatedby`, `dateupdated`) VALUES
(27, 2, 2, '45', 1, '3', '', 'hi now hee3', '<p>mowe3</p>', 13, '1735224537lesson_note28byn1ip.png', '', '', '', '', '', '', '', '', '', '', '', '', 57, '2024-12-24 23:08:14', 57, '2024-12-28 17:16:15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `lesson_note`
--
ALTER TABLE `lesson_note`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `lesson_note`
--
ALTER TABLE `lesson_note`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
