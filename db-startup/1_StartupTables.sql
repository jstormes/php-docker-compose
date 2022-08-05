-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: May 13, 2021 at 07:00 PM
-- Server version: 10.5.9-MariaDB-1:10.5.9+maria~focal
-- PHP Version: 7.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `database_name`
--

-- --------------------------------------------------------

--
-- Table structure for table `SomeTable`
--

CREATE TABLE `SomeTable` (
                             `id` int(11) NOT NULL,
                             `SomeText` text DEFAULT NULL,
                             `SomeInt` int(11) DEFAULT NULL,
                             `DateCreate` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='This is comment on the table';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `SomeTable`
--
ALTER TABLE `SomeTable`
    ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `SomeTable`
--
ALTER TABLE `SomeTable`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;
