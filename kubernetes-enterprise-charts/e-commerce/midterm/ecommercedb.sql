-- phpMyAdmin SQL Dump
-- version 4.4.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jan 27, 2016 at 06:47 AM
-- Server version: 5.6.26
-- PHP Version: 5.5.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommercedb`
--

-- --------------------------------------------------------

--
-- Table structure for table `tblautonumber`
--

CREATE TABLE IF NOT EXISTS `tblautonumber` (
  `ID` int(11) NOT NULL,
  `AUTOSTART` varchar(11) NOT NULL,
  `AUTOINC` int(11) NOT NULL,
  `AUTOEND` int(11) NOT NULL,
  `AUTOKEY` varchar(12) NOT NULL,
  `AUTONUM` int(30) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tblautonumber`
--

INSERT INTO `tblautonumber` (`ID`, `AUTOSTART`, `AUTOINC`, `AUTOEND`, `AUTOKEY`, `AUTONUM`) VALUES
(1, '0', 1, 52, 'PROID', 10),
(2, '0', 1, 111, 'ordernumber', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tblcategory`
--

CREATE TABLE IF NOT EXISTS `tblcategory` (
  `CATEGID` int(11) NOT NULL,
  `CATEGORIES` varchar(255) NOT NULL,
  `USERID` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tblcategory`
--

INSERT INTO `tblcategory` (`CATEGID`, `CATEGORIES`, `USERID`) VALUES
(3, 'DOOR AND WINDOW', 0),
(4, 'ELECTRICAL AND LIGHTING', 0),
(5, 'FLOOR AND WALL', 0),
(6, 'HARDWARE AND TOOLS', 0),
(8, 'HOME APPLIANCES', 0),
(9, 'Paint and Sundries', 0),
(10, 'Plumbing ', 0),
(11, 'Roofing and building Materials', 0),
(12, 'Sanitary', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tblcustomer`
--

CREATE TABLE IF NOT EXISTS `tblcustomer` (
  `CUSTOMERID` int(11) NOT NULL,
  `FNAME` varchar(30) NOT NULL,
  `LNAME` varchar(30) NOT NULL,
  `MNAME` varchar(30) NOT NULL,
  `CUSHOMENUM` varchar(90) NOT NULL,
  `STREETADD` text NOT NULL,
  `BRGYADD` text NOT NULL,
  `CITYADD` text NOT NULL,
  `PROVINCE` varchar(80) NOT NULL,
  `COUNTRY` varchar(30) NOT NULL,
  `DBIRTH` date NOT NULL,
  `GENDER` varchar(10) NOT NULL,
  `PHONE` varchar(20) NOT NULL,
  `EMAILADD` varchar(40) NOT NULL,
  `ZIPCODE` int(6) NOT NULL,
  `CUSUNAME` varchar(20) NOT NULL,
  `CUSPASS` varchar(90) NOT NULL,
  `CUSPHOTO` varchar(255) NOT NULL,
  `TERMS` tinyint(4) NOT NULL,
  `DATEJOIN` date NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tblcustomer`
--

INSERT INTO `tblcustomer` (`CUSTOMERID`, `FNAME`, `LNAME`, `MNAME`, `CUSHOMENUM`, `STREETADD`, `BRGYADD`, `CITYADD`, `PROVINCE`, `COUNTRY`, `DBIRTH`, `GENDER`, `PHONE`, `EMAILADD`, `ZIPCODE`, `CUSUNAME`, `CUSPASS`, `CUSPHOTO`, `TERMS`, `DATEJOIN`) VALUES
(1, 'Jayson', 'Tadeo', '', '321', 'san jose', 'salong', 'Kabankalan City', 'Negros Occidental', 'Philippines', '0000-00-00', 'Male', '09123586545', '', 6111, 'Jay@yahoo.com', '803d734da37173b09d39012fb384533cd122f9ca', 'customer_image/10329236_874204835938922_6636897990257224477_n.jpg', 1, '2015-11-26'),
(2, 'Mark Anthony', 'Geasin', '', '1234', 'paglaom', 'dancalan', 'ilog', 'negros occ', 'philippines', '0000-00-00', '', '091023333234', '', 6111, 'bboy', '0377588176145a8f0d837ff6e9bf0c1616268387', 'customer_image/10801930_959054964122877_391305007291646162_n.jpg', 1, '2015-11-26'),
(3, 'Jayson', 'Tadeo', '', '434-7766', 'San Jose', 'Salong', 'Kabankalan City', 'Neg. OCcc', 'PH', '0000-00-00', 'Male', '09463786545', '', 611, 'J@gmail.com', 'dd94709528bb1c83d08f3088d4043f4742891f4f', 'customer_image/chibi_dota_2___queen_of_pain_by_hothanhlamleok-d6ln52v.jpg', 1, '2016-01-22');

-- --------------------------------------------------------

--
-- Table structure for table `tblorder`
--

CREATE TABLE IF NOT EXISTS `tblorder` (
  `ORDERID` int(11) NOT NULL,
  `PROID` int(11) NOT NULL,
  `ORDEREDQTY` int(11) NOT NULL,
  `ORDEREDPRICE` double NOT NULL,
  `ORDEREDNUM` int(11) NOT NULL,
  `USERID` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tblorder`
--

INSERT INTO `tblorder` (`ORDERID`, `PROID`, `ORDEREDQTY`, `ORDEREDPRICE`, `ORDEREDNUM`, `USERID`) VALUES
(4, 1, 1, 8000, 95, 0),
(5, 3, 5, 35950, 96, 0),
(6, 1, 1, 8000, 97, 0),
(7, 1, 1, 8000, 98, 0),
(8, 1, 1, 8000, 99, 0),
(9, 1, 1, 8000, 100, 0),
(10, 1, 1, 8000, 101, 0),
(11, 49, 1, 500, 102, 0),
(12, 1, 1, 8000, 103, 0),
(13, 38, 1, 4000, 104, 0),
(14, 5, 1, 7000, 104, 0),
(15, 5, 1, 7000, 105, 0),
(16, 5, 1, 7000, 106, 0),
(17, 5, 1, 7000, 107, 0),
(18, 5, 1, 7000, 108, 0),
(19, 44, 1, 978000, 109, 0),
(20, 47, 1, 150, 110, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tblproduct`
--

CREATE TABLE IF NOT EXISTS `tblproduct` (
  `PROID` int(11) NOT NULL,
  `PROMODEL` varchar(30) DEFAULT NULL,
  `PROBRAND` varchar(255) DEFAULT NULL,
  `PRONAME` varchar(255) DEFAULT NULL,
  `PRODESC` varchar(255) DEFAULT NULL,
  `PROQTY` int(11) DEFAULT NULL,
  `PROPRICE` double DEFAULT NULL,
  `CATEGID` int(11) DEFAULT NULL,
  `IMAGES` varchar(255) DEFAULT NULL,
  `PROSTATS` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tblproduct`
--

INSERT INTO `tblproduct` (`PROID`, `PROMODEL`, `PROBRAND`, `PRONAME`, `PRODESC`, `PROQTY`, `PROPRICE`, `CATEGID`, `IMAGES`, `PROSTATS`) VALUES
(1, 'Stand Fan Sf-1601 Nb', 'Mayaka ', 'Mayaka ', 'Height - 1,25 Meter,Display size=16                    \r\n\r\n                                                                                                                                                                                                    ', 10, 8000, 8, 'uploaded_photos/2.jpg', 'Available'),
(4, 'ES-D708', NULL, 'Sharp', 'Spin Dryer 7kg                       \r\n\r\n                                                                                                                                                          ', 38, 4998, 6, 'uploaded_photos/COC-war-base-design.jpg', 'Available'),
(5, 'Trf-1800 Nb', 'Mayaka', 'Mayaka', ' Floor Fan ', 15, 7000, 8, 'uploaded_photos/1.jpg', 'Available'),
(38, 'GN-300 mp', NULL, 'Multipro Genset', '7 hp, Displacement:200cm, Starteer:Manual, Fuel Tank Cap. 15 L.           \r\n\r\n                                            ', 29, 4000, 6, 'uploaded_photos/B0012.GN_3000-MP.jpg', 'Available'),
(39, 'CW660JW/F White', NULL, 'Toto', ' Dual Flush Toilet (4.5/3 liters)  ,\r\nBowl Shape : Round Rough In : 230 mm\r\n\r\n                      ', 25, 1600, 0, 'uploaded_photos/B0039.toto-cw660.jpg', 'Available'),
(43, 'CW660JWF White', NULL, 'Toto', 'Bowl Shape : Round Rough In : 230 mm,\r\nDual Flush Toilet (4.5/3 liters)\r\n                                                                  ', 30, 1600, 12, 'uploaded_photos/B0039.toto-cw660.jpg', 'Available'),
(44, 'A626 Closet Two Piece Putih', NULL, 'Oulu', 'S-Trap, 305 mm roughing-in,\r\nHydrolic; Siphonic two-piece closet                        \r\n\r\n                                                                  ', 29, 3780, 12, 'uploaded_photos/B0040.020401404874.jpg', 'Available'),
(45, 'SG8', NULL, 'Supergrout', '1 kg                   \r\n\r\n                      ', 20, 7000, 11, 'uploaded_photos/B0034.super grout.jpg', 'Available'),
(46, 'Semen Regular', NULL, 'Tiga Roda', '1 sack,\r\n50kg                        \r\n\r\n                      ', 30, 700, 11, 'uploaded_photos/B0035.5539257_typei.jpg', 'Available'),
(47, 'FITTING ELBOW (AW) 3/4', NULL, 'Rucika', 'Dimension:3/4                        \r\n\r\n                                            ', 39, 150, 10, 'uploaded_photos/B0023.rucika.jpg', 'Available'),
(48, 'Wavin', NULL, 'Pipa PVC 1/2', '                        \r\n\r\n                      ', 90, 200, 10, 'uploaded_photos/B0024.10016629 Wavin Pipa PVC TH_Standard.jpg', 'Available'),
(49, 'Vinilex (Nippon Paint', NULL, 'Super Vinilex 300 Easy Wash (White)', '1 Gal                     \r\n\r\n                      ', 119, 500, 9, 'uploaded_photos/B0027.Supervivilex.png', 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `tblpromopro`
--

CREATE TABLE IF NOT EXISTS `tblpromopro` (
  `PROMOID` int(11) NOT NULL,
  `PROID` int(11) NOT NULL,
  `PRODISCOUNT` double NOT NULL,
  `PRODISPRICE` double NOT NULL,
  `PROBANNER` tinyint(4) NOT NULL,
  `PRONEW` tinyint(4) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tblpromopro`
--

INSERT INTO `tblpromopro` (`PROMOID`, `PROID`, `PRODISCOUNT`, `PRODISPRICE`, `PROBANNER`, `PRONEW`) VALUES
(1, 1, 0, 0, 1, 0),
(4, 4, 0, 0, 0, 0),
(5, 5, 0, 0, 0, 0),
(6, 6, 0, 0, 0, 0),
(7, 16, 0, 0, 0, 0),
(8, 17, 0, 0, 0, 0),
(9, 18, 0, 0, 0, 0),
(11, 20, 0, 0, 0, 0),
(12, 21, 0, 0, 0, 0),
(13, 22, 0, 0, 0, 0),
(14, 23, 0, 0, 0, 0),
(15, 24, 0, 0, 0, 0),
(16, 25, 0, 0, 0, 0),
(17, 26, 0, 0, 0, 0),
(18, 27, 0, 0, 0, 0),
(19, 28, 0, 0, 0, 0),
(20, 29, 0, 0, 0, 0),
(21, 30, 0, 0, 0, 0),
(22, 31, 0, 0, 0, 0),
(23, 32, 0, 0, 0, 0),
(24, 33, 0, 0, 0, 0),
(25, 34, 0, 0, 0, 0),
(26, 35, 0, 0, 0, 0),
(27, 36, 0, 0, 0, 0),
(29, 38, 0, 0, 0, 0),
(30, 39, 0, 0, 0, 0),
(32, 41, 0, 0, 0, 0),
(33, 42, 0, 0, 0, 0),
(34, 43, 0, 0, 0, 0),
(35, 44, 0, 0, 0, 0),
(36, 45, 0, 0, 0, 0),
(37, 46, 0, 0, 0, 0),
(38, 47, 0, 0, 0, 0),
(39, 48, 0, 0, 0, 0),
(40, 49, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tblstockin`
--

CREATE TABLE IF NOT EXISTS `tblstockin` (
  `STOCKINID` int(11) NOT NULL,
  `STOCKDATE` datetime DEFAULT NULL,
  `PROID` int(11) DEFAULT NULL,
  `STOCKQTY` int(11) DEFAULT NULL,
  `STOCKPRICE` double DEFAULT NULL,
  `USERID` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tblstockin`
--

INSERT INTO `tblstockin` (`STOCKINID`, `STOCKDATE`, `PROID`, `STOCKQTY`, `STOCKPRICE`, `USERID`) VALUES
(1, '2015-11-26 04:42:29', 1, 8, 33298, 126),
(4, '2015-11-26 08:02:50', 4, 5, 4998, 126),
(5, '2015-11-26 08:03:04', 4, 5, 4998, 126),
(6, '2015-11-26 08:05:12', 1, 8, 33298, 126),
(7, '2015-11-26 08:09:31', 1, 8, 33298, 126);

-- --------------------------------------------------------

--
-- Table structure for table `tblsummary`
--

CREATE TABLE IF NOT EXISTS `tblsummary` (
  `SUMMARYID` int(11) NOT NULL,
  `ORDEREDDATE` datetime NOT NULL,
  `CUSTOMERID` int(11) NOT NULL,
  `ORDEREDNUM` int(11) NOT NULL,
  `PAYMENT` double NOT NULL,
  `PAYMENTMETHOD` varchar(30) NOT NULL,
  `ORDEREDSTATS` varchar(30) NOT NULL,
  `ORDEREDREMARKS` varchar(125) NOT NULL,
  `CLAIMEDADTE` datetime NOT NULL,
  `HVIEW` tinyint(4) NOT NULL,
  `USERID` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tblsummary`
--

INSERT INTO `tblsummary` (`SUMMARYID`, `ORDEREDDATE`, `CUSTOMERID`, `ORDEREDNUM`, `PAYMENT`, `PAYMENTMETHOD`, `ORDEREDSTATS`, `ORDEREDREMARKS`, `CLAIMEDADTE`, `HVIEW`, `USERID`) VALUES
(2, '2016-01-22 00:00:00', 1, 86, 33298, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '2016-01-25 00:00:00', 0, 128),
(6, '2016-01-26 10:30:39', 3, 95, 8000, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 1, 0),
(7, '2016-01-26 12:01:00', 3, 96, 35950, 'Cash on Pickup', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 1, 0),
(8, '2016-01-26 12:04:06', 3, 97, 8025, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 1, 0),
(9, '2016-01-26 12:05:29', 3, 98, 8025, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 1, 0),
(10, '2016-01-26 12:06:06', 3, 99, 8025, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 1, 0),
(11, '2016-01-26 12:08:46', 3, 100, 8025, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 1, 0),
(12, '2016-01-26 04:17:20', 3, 101, 8025, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 1, 0),
(13, '2016-01-27 02:55:55', 3, 102, 525, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 1, 0),
(14, '2016-01-27 03:12:28', 3, 103, 8025, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 0, 0),
(15, '2016-01-27 03:22:20', 3, 104, 11000, 'Cash on Pickup', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 0, 0),
(16, '2016-01-27 04:54:04', 3, 105, 7000, 'Cash on Pickup', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 0, 0),
(17, '2016-01-27 04:55:27', 3, 106, 7025, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 0, 0),
(18, '2016-01-27 04:56:54', 3, 107, 7000, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 0, 0),
(19, '2016-01-27 04:58:55', 3, 108, 7000, 'Cash on Pickup', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 0, 0),
(20, '2016-01-27 05:00:05', 3, 109, 978000, 'Cash on Pickup', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 0, 0),
(21, '2016-01-27 06:04:18', 3, 110, 175, 'Cash on Delivery', 'Confirmed', 'Your order has been confirmed.', '0000-00-00 00:00:00', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbluseraccount`
--

CREATE TABLE IF NOT EXISTS `tbluseraccount` (
  `USERID` int(11) NOT NULL,
  `U_NAME` varchar(122) NOT NULL,
  `U_USERNAME` varchar(122) NOT NULL,
  `U_PASS` varchar(122) NOT NULL,
  `U_ROLE` varchar(30) NOT NULL,
  `USERIMAGE` varchar(255) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbluseraccount`
--

INSERT INTO `tbluseraccount` (`USERID`, `U_NAME`, `U_USERNAME`, `U_PASS`, `U_ROLE`, `USERIMAGE`) VALUES
(126, 'Reynaldo Garcia', 'Reyn', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'Staff', 'photos/418769.JPG'),
(128, 'Jayson Tadeo', 'J@gmail.com', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'Administrator', 'photos/chibi_dota_2___queen_of_pain_by_hothanhlamleok-d6ln52v.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tblautonumber`
--
ALTER TABLE `tblautonumber`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tblcategory`
--
ALTER TABLE `tblcategory`
  ADD PRIMARY KEY (`CATEGID`);

--
-- Indexes for table `tblcustomer`
--
ALTER TABLE `tblcustomer`
  ADD PRIMARY KEY (`CUSTOMERID`);

--
-- Indexes for table `tblorder`
--
ALTER TABLE `tblorder`
  ADD PRIMARY KEY (`ORDERID`),
  ADD KEY `USERID` (`USERID`),
  ADD KEY `PROID` (`PROID`),
  ADD KEY `ORDEREDNUM` (`ORDEREDNUM`);

--
-- Indexes for table `tblproduct`
--
ALTER TABLE `tblproduct`
  ADD PRIMARY KEY (`PROID`),
  ADD UNIQUE KEY `PROMODEL` (`PROMODEL`),
  ADD KEY `CATEGID` (`CATEGID`);

--
-- Indexes for table `tblpromopro`
--
ALTER TABLE `tblpromopro`
  ADD PRIMARY KEY (`PROMOID`),
  ADD UNIQUE KEY `PROID` (`PROID`);

--
-- Indexes for table `tblstockin`
--
ALTER TABLE `tblstockin`
  ADD PRIMARY KEY (`STOCKINID`),
  ADD KEY `PROID` (`PROID`,`USERID`),
  ADD KEY `USERID` (`USERID`);

--
-- Indexes for table `tblsummary`
--
ALTER TABLE `tblsummary`
  ADD PRIMARY KEY (`SUMMARYID`),
  ADD UNIQUE KEY `ORDEREDNUM` (`ORDEREDNUM`),
  ADD KEY `CUSTOMERID` (`CUSTOMERID`),
  ADD KEY `USERID` (`USERID`);

--
-- Indexes for table `tbluseraccount`
--
ALTER TABLE `tbluseraccount`
  ADD PRIMARY KEY (`USERID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tblautonumber`
--
ALTER TABLE `tblautonumber`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tblcategory`
--
ALTER TABLE `tblcategory`
  MODIFY `CATEGID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `tblcustomer`
--
ALTER TABLE `tblcustomer`
  MODIFY `CUSTOMERID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `tblorder`
--
ALTER TABLE `tblorder`
  MODIFY `ORDERID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `tblpromopro`
--
ALTER TABLE `tblpromopro`
  MODIFY `PROMOID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=41;
--
-- AUTO_INCREMENT for table `tblstockin`
--
ALTER TABLE `tblstockin`
  MODIFY `STOCKINID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `tblsummary`
--
ALTER TABLE `tblsummary`
  MODIFY `SUMMARYID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT for table `tbluseraccount`
--
ALTER TABLE `tbluseraccount`
  MODIFY `USERID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=129;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
