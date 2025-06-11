-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 11, 2025 at 11:39 AM
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
-- Database: `e-commerce`
--

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `address_id` int(11) NOT NULL,
  `address_userid` int(11) NOT NULL,
  `address_city` varchar(255) NOT NULL,
  `address_street` varchar(255) NOT NULL,
  `address_long` double NOT NULL,
  `address_lat` double NOT NULL,
  `address_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`address_id`, `address_userid`, `address_city`, `address_street`, `address_long`, `address_lat`, `address_name`) VALUES
(15, 53, 'Mountain View', 'Google Building 44', -122.0833954252984, 37.42026300747497, 'kaka'),
(16, 66, 'Mountain View', 'Google Building 43', -122.084, 37.421998333333335, 'all aàa'),
(17, 72, 'Mountain View', '1600 Amphitheatre Pkwy Building 43', -122.08369771264934, 37.420002924100615, 'Home');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `cart_itemsid` int(11) NOT NULL,
  `cart_userid` int(11) NOT NULL,
  `cart_orders` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cart_id`, `cart_itemsid`, `cart_userid`, `cart_orders`) VALUES
(161, 3, 53, 43),
(162, 3, 53, 43),
(163, 3, 53, 43),
(172, 5, 53, 45),
(173, 5, 53, 45),
(180, 2, 53, 50),
(181, 2, 53, 50),
(182, 3, 53, 50),
(184, 5, 53, 51),
(185, 3, 53, 51),
(186, 5, 53, 54),
(187, 3, 53, 54),
(188, 2, 53, 54),
(189, 2, 53, 57),
(190, 3, 53, 73),
(191, 5, 53, 73),
(192, 5, 53, 73),
(193, 5, 53, 82),
(194, 5, 53, 82),
(195, 3, 53, 82),
(196, 2, 53, 82),
(197, 5, 53, 84),
(198, 5, 53, 87),
(199, 5, 53, 87),
(200, 5, 53, 92),
(201, 5, 53, 92),
(202, 3, 53, 102),
(203, 3, 53, 102),
(204, 2, 53, 106),
(205, 5, 53, 107),
(206, 4, 53, 108),
(207, 3, 53, 109),
(208, 2, 53, 110),
(209, 2, 53, 110),
(210, 2, 53, 110),
(211, 2, 53, 110),
(212, 2, 53, 110),
(213, 2, 53, 110),
(214, 2, 53, 110),
(215, 2, 53, 110),
(216, 2, 53, 110),
(217, 2, 53, 110),
(218, 2, 53, 110),
(219, 2, 53, 110),
(220, 2, 53, 110),
(221, 2, 53, 110),
(222, 2, 53, 110),
(223, 2, 53, 111),
(224, 2, 53, 111),
(225, 2, 53, 111),
(226, 2, 53, 112),
(227, 2, 53, 112),
(228, 2, 53, 113),
(229, 2, 53, 113),
(230, 2, 53, 114),
(231, 2, 53, 114),
(232, 2, 53, 114),
(233, 5, 53, 115),
(234, 5, 53, 115),
(235, 5, 53, 115),
(236, 5, 53, 115),
(237, 2, 53, 116),
(238, 2, 53, 116),
(239, 2, 53, 116),
(240, 5, 53, 117),
(241, 5, 53, 117),
(242, 5, 53, 117),
(243, 5, 53, 117),
(244, 5, 53, 0),
(245, 5, 72, 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `cartview`
-- (See below for the actual view)
--
CREATE TABLE `cartview` (
`itemsprice` double
,`countitems` bigint(21)
,`cart_id` int(11)
,`cart_itemsid` int(11)
,`cart_userid` int(11)
,`cart_orders` int(11)
,`items_id` int(11)
,`items_name` varchar(100)
,`items_name_ar` varchar(100)
,`items_desc` varchar(255)
,`items_desc_ar` varchar(255)
,`items_image` varchar(255)
,`items_count` int(11)
,`items_active` tinyint(4)
,`items_price` float
,`items_discount` smallint(6)
,`items_date` timestamp
,`items_cat` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `categories_id` int(11) NOT NULL,
  `categories_name` varchar(100) NOT NULL,
  `categories_name_ar` varchar(100) NOT NULL,
  `categories_image` varchar(255) NOT NULL,
  `categories_datetime` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`categories_id`, `categories_name`, `categories_name_ar`, `categories_image`, `categories_datetime`) VALUES
(1, 'laptop', 'لابتوب', 'laptop.svg', '2024-10-14 11:47:06'),
(2, 'camera', 'كاميرا', 'camera.svg', '2024-10-14 11:47:06'),
(3, 'mobile', 'موبايل', 'mobile.svg', '2024-10-14 11:47:37'),
(4, 'shoes', 'احذية', 'shoes.svg', '2024-10-14 11:50:41'),
(5, 'dress', 'فستان', 'dress.svg', '2024-10-14 11:51:17');

-- --------------------------------------------------------

--
-- Table structure for table `coupon`
--

CREATE TABLE `coupon` (
  `coupon_id` int(11) NOT NULL,
  `coupon_name` varchar(50) NOT NULL,
  `coupon_count` int(11) NOT NULL,
  `coupon_expiredate` datetime NOT NULL,
  `coupon_discount` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `coupon`
--

INSERT INTO `coupon` (`coupon_id`, `coupon_name`, `coupon_count`, `coupon_expiredate`, `coupon_discount`) VALUES
(1, 'fuckmedady', 4, '2024-12-07 13:14:22', 30),
(2, 'nono', 0, '2024-11-07 13:21:52', 20);

-- --------------------------------------------------------

--
-- Table structure for table `favorite`
--

CREATE TABLE `favorite` (
  `favorite_id` int(11) NOT NULL,
  `favorite_usersid` int(11) NOT NULL,
  `favorite_itemsid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `favorite`
--

INSERT INTO `favorite` (`favorite_id`, `favorite_usersid`, `favorite_itemsid`) VALUES
(82, 53, 3),
(83, 53, 2),
(84, 66, 3),
(85, 66, 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `favoriteview`
-- (See below for the actual view)
--
CREATE TABLE `favoriteview` (
`favorite_id` int(11)
,`favorite_usersid` int(11)
,`favorite_itemsid` int(11)
,`items_id` int(11)
,`items_name` varchar(100)
,`items_name_ar` varchar(100)
,`items_desc` varchar(255)
,`items_desc_ar` varchar(255)
,`items_image` varchar(255)
,`items_count` int(11)
,`items_active` tinyint(4)
,`items_price` float
,`items_discount` smallint(6)
,`items_date` timestamp
,`items_cat` int(11)
,`users_id` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `items_id` int(11) NOT NULL,
  `items_name` varchar(100) NOT NULL,
  `items_name_ar` varchar(100) NOT NULL,
  `items_desc` varchar(255) NOT NULL,
  `items_desc_ar` varchar(255) NOT NULL,
  `items_image` varchar(255) NOT NULL,
  `items_count` int(11) NOT NULL,
  `items_active` tinyint(4) NOT NULL DEFAULT 1,
  `items_price` float NOT NULL,
  `items_discount` smallint(6) NOT NULL,
  `items_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `items_cat` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`items_id`, `items_name`, `items_name_ar`, `items_desc`, `items_desc_ar`, `items_image`, `items_count`, `items_active`, `items_price`, `items_discount`, `items_date`, `items_cat`) VALUES
(2, 'xaiuomi note 12 pro', 'شاومي نوت 12 برو ', '128 rom storage\r\n12 gb ram', '128 غيغا رام \r\n12 غيغارام', 'xaumi.jpeg', 4, 1, 120, 10, '2024-10-16 09:10:57', 3),
(3, 'Canon Camera v5', 'كاميرا كانون الاصدار 5', 'new version of canon camera support 100x zoom and infrared', 'اصدار جديد من الكاميرا مع دعم لتكبير 100اكس مع اشعة تحت حمراء', 'camera.png', 3, 1, 1500, 20, '2024-10-16 09:13:00', 2),
(4, 'Canon Camera v4', 'كاميرا كانون الاصدار 4', 'new version of canon camera support 100x zoom and infrared', 'اصدار جديد من الكاميرا مع دعم لتكبير 100اكس مع اشعة تحت حمراء', 'camera.png', 3, 1, 1500, 0, '2024-10-16 09:16:17', 2),
(5, 'Asus Rog Strix G15', 'اسوس روج سترايكس جي 15', 'A laptop with superior specifications, 16 GB RAM, a storage space of up to 2 TB, a 14th generation processor, and a 4080 RTX graphics card.', 'لابتوب بمواصفات خارقة 16 غيغا بايت رام و مساحة تخزين تصل الى 2 تيرا بايت ومعالج الجيل الرابع عشر وكرت شاشة 4080 ار تي اكس', 'laptopasus.png', 4, 1, 1344, 0, '2024-10-29 16:47:32', 1),
(6, 'Black Dress', 'فستان اسود', 'wided black dress', 'فستان اسود عريض', 'blackdress.jpg', 3, 1, 345, 10, '2024-11-06 10:53:04', 5);

-- --------------------------------------------------------

--
-- Stand-in structure for view `itemsview1`
-- (See below for the actual view)
--
CREATE TABLE `itemsview1` (
`items_id` int(11)
,`items_name` varchar(100)
,`items_name_ar` varchar(100)
,`items_desc` varchar(255)
,`items_desc_ar` varchar(255)
,`items_image` varchar(255)
,`items_count` int(11)
,`items_active` tinyint(4)
,`items_price` float
,`items_discount` smallint(6)
,`items_date` timestamp
,`items_cat` int(11)
,`categories_id` int(11)
,`categories_name` varchar(100)
,`categories_name_ar` varchar(100)
,`categories_image` varchar(255)
,`categories_datetime` timestamp
);

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `notification_id` int(11) NOT NULL,
  `notification_title` varchar(255) NOT NULL,
  `notification_body` varchar(255) NOT NULL,
  `notification_userid` int(11) NOT NULL,
  `notification_datetime` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`notification_id`, `notification_title`, `notification_body`, `notification_userid`, `notification_datetime`) VALUES
(3, 'success', 'The Order 109 Has Been Approved', 53, '2024-11-19 19:00:47'),
(4, 'success', 'The Order 82 Has Been Approved', 53, '2024-11-19 19:03:11'),
(5, 'success', 'The Order 83 Has Been Approved', 53, '2024-11-19 19:03:27'),
(6, 'success', 'The Order 84 Has Been Approved', 53, '2024-11-19 19:03:54');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `orders_id` int(11) NOT NULL,
  `orders_userid` int(11) NOT NULL,
  `orders_address` int(11) NOT NULL,
  `orders_type` tinyint(4) NOT NULL COMMENT '0 for delivery; 1: for receive',
  `orders_pricedelivery` int(11) NOT NULL DEFAULT 0,
  `orders_price` int(11) NOT NULL,
  `orders_coupon` int(11) NOT NULL DEFAULT 0,
  `orders_time` datetime NOT NULL DEFAULT current_timestamp(),
  `orders_paymentmethod` tinyint(4) NOT NULL DEFAULT 0 COMMENT ' 0 : is cash ;1 is card',
  `orders_fullprice` double NOT NULL DEFAULT 0,
  `orders_status` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orders_id`, `orders_userid`, `orders_address`, `orders_type`, `orders_pricedelivery`, `orders_price`, `orders_coupon`, `orders_time`, `orders_paymentmethod`, `orders_fullprice`, `orders_status`) VALUES
(117, 53, 0, 1, 10, 5376, 0, '2024-11-21 14:40:45', 0, 5386, 4);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ordersdetailsview`
-- (See below for the actual view)
--
CREATE TABLE `ordersdetailsview` (
`itemsprice` double
,`countitems` bigint(21)
,`cart_id` int(11)
,`cart_itemsid` int(11)
,`cart_userid` int(11)
,`cart_orders` int(11)
,`items_id` int(11)
,`items_name` varchar(100)
,`items_name_ar` varchar(100)
,`items_desc` varchar(255)
,`items_desc_ar` varchar(255)
,`items_image` varchar(255)
,`items_count` int(11)
,`items_active` tinyint(4)
,`items_price` float
,`items_discount` smallint(6)
,`items_date` timestamp
,`items_cat` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ordersview`
-- (See below for the actual view)
--
CREATE TABLE `ordersview` (
`orders_id` int(11)
,`orders_userid` int(11)
,`orders_address` int(11)
,`orders_type` tinyint(4)
,`orders_pricedelivery` int(11)
,`orders_price` int(11)
,`orders_coupon` int(11)
,`orders_time` datetime
,`orders_paymentmethod` tinyint(4)
,`orders_fullprice` double
,`orders_status` tinyint(4)
,`address_id` int(11)
,`address_userid` int(11)
,`address_city` varchar(255)
,`address_street` varchar(255)
,`address_long` double
,`address_lat` double
,`address_name` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `users_id` int(11) NOT NULL,
  `users_name` varchar(100) NOT NULL,
  `users_email` varchar(100) NOT NULL,
  `users_phone` varchar(100) NOT NULL,
  `users_verifycode` int(11) NOT NULL,
  `users_approve` tinyint(4) NOT NULL DEFAULT 0,
  `users_create` timestamp NOT NULL DEFAULT current_timestamp(),
  `users_password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`users_id`, `users_name`, `users_email`, `users_phone`, `users_verifycode`, `users_approve`, `users_create`, `users_password`) VALUES
(53, 'laka', 'laka@gmail.com', '5432344564', 67667, 1, '2024-10-13 10:32:34', '43e62a25f445a25ec3cf8f3befafe9569217fa2c'),
(54, 'jamal', 'jamal@gmail.com', '09974689976', 13223, 1, '2024-10-21 09:30:03', 'aq1sw2de3'),
(55, 'fuck', 'fucker@gmail.com', '0997456743', 63595, 1, '2024-10-23 08:59:09', '23cc30fda09620e85ee75f973a31673f377447ee'),
(56, 'othman', 'othman@gmail.com', '1234566543345', 92907, 0, '2024-10-23 09:13:57', '23cc30fda09620e85ee75f973a31673f377447ee'),
(57, 'yamen', 'yamen@gmail.com', '456456456456', 45511, 0, '2024-10-23 09:37:20', '23cc30fda09620e85ee75f973a31673f377447ee'),
(58, 'rape', 'rapeporn@gmail.com', '123434345676', 87783, 0, '2024-10-23 09:57:49', '23cc30fda09620e85ee75f973a31673f377447ee'),
(59, 'jamal', 'jamale@gmail.com', '3232454556565', 68024, 1, '2024-10-23 10:05:23', '23cc30fda09620e85ee75f973a31673f377447ee'),
(60, 'mama', 'mama@gmail.com', '12345678901', 82598, 1, '2024-10-23 10:10:06', 'f7c3bc1d808e04732adf679965ccc34ca7ae3441'),
(61, 'laka', 'laka@gmail.org', '54323445642', 99814, 1, '2024-10-23 14:20:26', '23cc30fda09620e85ee75f973a31673f377447ee'),
(62, 'hello', 'rooltion@gmail.com', '0997468997', 40584, 0, '2025-01-01 15:04:52', '23cc30fda09620e85ee75f973a31673f377447ee'),
(63, 'hello', 'dsklasdal@gmail.com', '09985555555', 97611, 0, '2025-01-01 15:26:13', '23cc30fda09620e85ee75f973a31673f377447ee'),
(64, 'mdsff', 'ldskfjk@gmail.com', '455646646', 73913, 0, '2025-01-01 15:28:09', '23cc30fda09620e85ee75f973a31673f377447ee'),
(65, 'jjjj', 'kakamaka@gmail.com', '0997689998', 56220, 0, '2025-02-05 05:23:24', '9d9875bcf6c387efc74cc53287584bc0a3020266'),
(66, 'mohammed', 'mohammed123@gmail.com', '09974689978', 22873, 1, '2025-02-05 05:27:44', 'b6baa5f7cdedec6ab656bbb5fe4be1e0301041f4'),
(67, 'Mohammed', 'jamalx1@gmail.com', '1212122122', 99601, 0, '2025-06-10 16:56:09', '9d9875bcf6c387efc74cc53287584bc0a3020266'),
(68, 'Jasemsuleyman', 'jasemsuleyman@gmail.com', '0987567423', 81084, 0, '2025-06-11 06:11:21', 'f7c3bc1d808e04732adf679965ccc34ca7ae3441'),
(69, 'Rasha', 'rasha@gmail.com', '0997465778', 60751, 0, '2025-06-11 06:14:57', '9d9875bcf6c387efc74cc53287584bc0a3020266'),
(70, '', '', '', 23199, 0, '2025-06-11 06:16:14', 'da39a3ee5e6b4b0d3255bfef95601890afd80709'),
(71, 'rasha', 'rasha1@gmail.com', '566654454', 63493, 0, '2025-06-11 06:17:09', '9d9875bcf6c387efc74cc53287584bc0a3020266'),
(72, 'hussam', 'hussam@gmail.com', '099756565', 29083, 1, '2025-06-11 06:18:18', '9d9875bcf6c387efc74cc53287584bc0a3020266');

-- --------------------------------------------------------

--
-- Structure for view `cartview`
--
DROP TABLE IF EXISTS `cartview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cartview`  AS SELECT sum(`items`.`items_price` - `items`.`items_price` * `items`.`items_discount` / 100) AS `itemsprice`, count(`cart`.`cart_itemsid`) AS `countitems`, `cart`.`cart_id` AS `cart_id`, `cart`.`cart_itemsid` AS `cart_itemsid`, `cart`.`cart_userid` AS `cart_userid`, `cart`.`cart_orders` AS `cart_orders`, `items`.`items_id` AS `items_id`, `items`.`items_name` AS `items_name`, `items`.`items_name_ar` AS `items_name_ar`, `items`.`items_desc` AS `items_desc`, `items`.`items_desc_ar` AS `items_desc_ar`, `items`.`items_image` AS `items_image`, `items`.`items_count` AS `items_count`, `items`.`items_active` AS `items_active`, `items`.`items_price` AS `items_price`, `items`.`items_discount` AS `items_discount`, `items`.`items_date` AS `items_date`, `items`.`items_cat` AS `items_cat` FROM (`cart` join `items` on(`items`.`items_id` = `cart`.`cart_itemsid`)) WHERE `cart`.`cart_orders` = 0 GROUP BY `cart`.`cart_itemsid`, `cart`.`cart_userid`, `cart`.`cart_orders` ;

-- --------------------------------------------------------

--
-- Structure for view `favoriteview`
--
DROP TABLE IF EXISTS `favoriteview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `favoriteview`  AS SELECT `favorite`.`favorite_id` AS `favorite_id`, `favorite`.`favorite_usersid` AS `favorite_usersid`, `favorite`.`favorite_itemsid` AS `favorite_itemsid`, `items`.`items_id` AS `items_id`, `items`.`items_name` AS `items_name`, `items`.`items_name_ar` AS `items_name_ar`, `items`.`items_desc` AS `items_desc`, `items`.`items_desc_ar` AS `items_desc_ar`, `items`.`items_image` AS `items_image`, `items`.`items_count` AS `items_count`, `items`.`items_active` AS `items_active`, `items`.`items_price` AS `items_price`, `items`.`items_discount` AS `items_discount`, `items`.`items_date` AS `items_date`, `items`.`items_cat` AS `items_cat`, `users`.`users_id` AS `users_id` FROM ((`favorite` join `users` on(`users`.`users_id` = `favorite`.`favorite_usersid`)) join `items` on(`items`.`items_id` = `favorite`.`favorite_itemsid`)) ;

-- --------------------------------------------------------

--
-- Structure for view `itemsview1`
--
DROP TABLE IF EXISTS `itemsview1`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `itemsview1`  AS SELECT `items`.`items_id` AS `items_id`, `items`.`items_name` AS `items_name`, `items`.`items_name_ar` AS `items_name_ar`, `items`.`items_desc` AS `items_desc`, `items`.`items_desc_ar` AS `items_desc_ar`, `items`.`items_image` AS `items_image`, `items`.`items_count` AS `items_count`, `items`.`items_active` AS `items_active`, `items`.`items_price` AS `items_price`, `items`.`items_discount` AS `items_discount`, `items`.`items_date` AS `items_date`, `items`.`items_cat` AS `items_cat`, `categories`.`categories_id` AS `categories_id`, `categories`.`categories_name` AS `categories_name`, `categories`.`categories_name_ar` AS `categories_name_ar`, `categories`.`categories_image` AS `categories_image`, `categories`.`categories_datetime` AS `categories_datetime` FROM (`items` join `categories` on(`items`.`items_cat` = `categories`.`categories_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `ordersdetailsview`
--
DROP TABLE IF EXISTS `ordersdetailsview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ordersdetailsview`  AS SELECT sum(`items`.`items_price` - `items`.`items_price` * `items`.`items_discount` / 100) AS `itemsprice`, count(`cart`.`cart_itemsid`) AS `countitems`, `cart`.`cart_id` AS `cart_id`, `cart`.`cart_itemsid` AS `cart_itemsid`, `cart`.`cart_userid` AS `cart_userid`, `cart`.`cart_orders` AS `cart_orders`, `items`.`items_id` AS `items_id`, `items`.`items_name` AS `items_name`, `items`.`items_name_ar` AS `items_name_ar`, `items`.`items_desc` AS `items_desc`, `items`.`items_desc_ar` AS `items_desc_ar`, `items`.`items_image` AS `items_image`, `items`.`items_count` AS `items_count`, `items`.`items_active` AS `items_active`, `items`.`items_price` AS `items_price`, `items`.`items_discount` AS `items_discount`, `items`.`items_date` AS `items_date`, `items`.`items_cat` AS `items_cat` FROM ((`cart` join `items` on(`items`.`items_id` = `cart`.`cart_itemsid`)) join `ordersview` on(`ordersview`.`orders_id` = `cart`.`cart_orders`)) WHERE `cart`.`cart_orders` <> 0 GROUP BY `cart`.`cart_itemsid`, `cart`.`cart_userid` ;

-- --------------------------------------------------------

--
-- Structure for view `ordersview`
--
DROP TABLE IF EXISTS `ordersview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ordersview`  AS SELECT `orders`.`orders_id` AS `orders_id`, `orders`.`orders_userid` AS `orders_userid`, `orders`.`orders_address` AS `orders_address`, `orders`.`orders_type` AS `orders_type`, `orders`.`orders_pricedelivery` AS `orders_pricedelivery`, `orders`.`orders_price` AS `orders_price`, `orders`.`orders_coupon` AS `orders_coupon`, `orders`.`orders_time` AS `orders_time`, `orders`.`orders_paymentmethod` AS `orders_paymentmethod`, `orders`.`orders_fullprice` AS `orders_fullprice`, `orders`.`orders_status` AS `orders_status`, `address`.`address_id` AS `address_id`, `address`.`address_userid` AS `address_userid`, `address`.`address_city` AS `address_city`, `address`.`address_street` AS `address_street`, `address`.`address_long` AS `address_long`, `address`.`address_lat` AS `address_lat`, `address`.`address_name` AS `address_name` FROM (`orders` left join `address` on(`address`.`address_id` = `orders`.`orders_address`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`address_id`),
  ADD KEY `address_userid` (`address_userid`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`categories_id`);

--
-- Indexes for table `coupon`
--
ALTER TABLE `coupon`
  ADD PRIMARY KEY (`coupon_id`),
  ADD UNIQUE KEY `coupon_name` (`coupon_name`);

--
-- Indexes for table `favorite`
--
ALTER TABLE `favorite`
  ADD PRIMARY KEY (`favorite_id`),
  ADD KEY `favorite_ibfk_1` (`favorite_itemsid`),
  ADD KEY `favorite_ibfk_2` (`favorite_usersid`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`items_id`),
  ADD KEY `items_cat` (`items_cat`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`notification_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orders_id`),
  ADD KEY `orders_address` (`orders_address`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`users_id`),
  ADD UNIQUE KEY `users_email` (`users_email`),
  ADD UNIQUE KEY `users_phone` (`users_phone`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=246;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `categories_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `coupon`
--
ALTER TABLE `coupon`
  MODIFY `coupon_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `favorite`
--
ALTER TABLE `favorite`
  MODIFY `favorite_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `items_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `orders_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `users_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `address`
--
ALTER TABLE `address`
  ADD CONSTRAINT `address_ibfk_1` FOREIGN KEY (`address_userid`) REFERENCES `users` (`users_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `favorite`
--
ALTER TABLE `favorite`
  ADD CONSTRAINT `favorite_ibfk_1` FOREIGN KEY (`favorite_itemsid`) REFERENCES `items` (`items_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `favorite_ibfk_2` FOREIGN KEY (`favorite_usersid`) REFERENCES `users` (`users_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`items_cat`) REFERENCES `categories` (`categories_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
