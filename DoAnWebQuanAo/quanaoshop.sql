-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: quanaoshop
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '2a0babbd-b023-11f0-8e80-005056c00001:1-1583';

--
-- Table structure for table `chitietdonhang`
--

DROP TABLE IF EXISTS `chitietdonhang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chitietdonhang` (
  `ChiTietID` int NOT NULL AUTO_INCREMENT,
  `DonHangID` int NOT NULL,
  `PhienBanID` int NOT NULL,
  `SoLuong` int NOT NULL,
  `GiaLucMua` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ChiTietID`),
  KEY `DonHangID` (`DonHangID`),
  KEY `PhienBanID` (`PhienBanID`),
  CONSTRAINT `chitietdonhang_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE,
  CONSTRAINT `chitietdonhang_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`),
  CONSTRAINT `chitietdonhang_chk_1` CHECK ((`SoLuong` > 0)),
  CONSTRAINT `chitietdonhang_chk_2` CHECK ((`GiaLucMua` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietdonhang`
--

LOCK TABLES `chitietdonhang` WRITE;
/*!40000 ALTER TABLE `chitietdonhang` DISABLE KEYS */;
INSERT INTO `chitietdonhang` VALUES (64,1051,5014,1,324000.00),(65,1052,5008,2,405000.00),(66,1052,5016,2,432000.00),(67,1052,5022,1,540000.00),(68,1052,5013,2,230000.00),(69,1052,5029,2,1170000.00),(70,1053,5020,2,297000.00),(71,1053,5007,1,450000.00),(72,1054,5021,1,243000.00),(73,1054,5027,2,1350000.00),(74,1054,5007,2,450000.00),(75,1055,5002,1,99000.00),(76,1055,5004,1,180000.00),(77,1056,5014,2,324000.00),(78,1056,5022,1,540000.00),(79,1056,5029,1,1170000.00),(80,1057,5032,1,315000.00),(81,1057,5022,1,540000.00),(82,1058,5019,1,252000.00),(83,1058,5006,2,270000.00),(84,1058,5022,1,540000.00),(85,1058,5028,1,450000.00),(86,1059,5027,2,1350000.00),(87,1059,5026,2,270000.00),(88,1060,5016,1,432000.00),(89,1061,5023,2,279000.00),(90,1061,5013,2,230000.00),(91,1061,5016,1,432000.00),(92,1061,5029,2,1170000.00),(93,1061,5029,1,1170000.00),(94,1062,5020,1,297000.00),(95,1062,5022,1,540000.00),(96,1062,5020,1,297000.00),(97,1063,5024,2,234000.00),(98,1063,5026,2,270000.00),(99,1063,5027,2,1350000.00),(100,1064,5015,2,162000.00),(101,1064,5006,2,270000.00),(102,1065,5019,2,252000.00),(103,1065,5022,2,540000.00),(104,1066,5026,1,270000.00),(105,1067,5010,1,225000.00),(106,1067,5027,1,1350000.00),(107,1068,5032,2,315000.00),(108,1068,5015,2,162000.00),(109,1069,5027,1,1350000.00),(110,1069,5029,1,1170000.00),(111,1070,5032,2,315000.00),(112,1071,5026,1,270000.00),(113,1071,5028,2,450000.00),(114,1071,5013,1,230000.00),(115,1071,5017,2,351000.00),(116,1071,5024,2,234000.00),(117,1072,5032,2,315000.00),(118,1072,5006,2,270000.00),(119,1073,5031,2,630000.00),(120,1073,5006,1,270000.00),(121,1073,5023,2,279000.00),(122,1074,5029,2,1170000.00),(123,1074,5025,2,405000.00),(124,1075,5027,2,1350000.00),(125,1076,5010,2,225000.00),(126,1076,5006,2,270000.00),(127,1077,5024,2,234000.00),(128,1077,5018,2,468000.00),(129,1078,5002,1,99000.00),(130,1078,5006,1,270000.00),(131,1079,5019,2,252000.00),(132,1079,5016,2,432000.00),(133,1079,5004,2,180000.00),(134,1080,5016,1,432000.00),(135,1080,5028,2,450000.00),(136,1081,5025,1,405000.00),(137,1081,5008,2,405000.00),(138,1082,5008,1,405000.00),(139,1082,5028,1,450000.00),(140,1083,5001,2,99000.00),(141,1084,5023,2,279000.00),(142,1084,5027,1,1350000.00),(143,1085,5009,1,495000.00),(144,1085,5022,2,540000.00),(145,1085,5022,1,540000.00),(146,1086,5026,2,270000.00),(147,1086,5016,1,432000.00),(148,1086,5022,1,540000.00),(149,1087,5016,1,432000.00),(150,1087,5016,2,432000.00),(151,1087,5019,2,252000.00),(152,1087,5016,1,432000.00),(153,1088,5026,2,270000.00),(154,1088,5023,1,279000.00),(155,1089,5025,2,405000.00),(156,1089,5031,2,630000.00),(157,1089,5009,2,495000.00),(158,1090,5033,2,45000.00),(159,1090,5033,1,45000.00),(160,1091,5009,1,495000.00),(161,1092,5027,2,1350000.00),(162,1093,5015,1,162000.00),(163,1093,5009,2,495000.00),(164,1093,5023,2,279000.00),(165,1094,5006,1,270000.00),(166,1095,5027,1,1350000.00),(167,1095,5012,2,378000.00),(168,1095,5012,1,378000.00),(169,1096,5031,2,630000.00),(170,1096,5019,1,252000.00),(171,1096,5023,2,279000.00),(172,1097,5028,2,450000.00),(173,1098,5028,2,450000.00),(174,1098,5010,2,225000.00),(175,1098,5027,1,1350000.00),(176,1098,5010,1,225000.00),(177,1099,5033,2,45000.00),(178,1099,5033,1,45000.00),(179,1099,5033,2,45000.00),(180,1100,5028,2,450000.00),(181,1100,5016,2,432000.00),(182,1100,5010,2,225000.00),(183,1100,5018,1,468000.00),(184,1101,5006,1,270000.00),(185,1101,5013,2,230000.00),(186,1101,5032,1,315000.00),(187,1102,5031,2,630000.00),(188,1102,5020,2,297000.00),(189,1103,5026,2,270000.00),(190,1103,5026,2,270000.00),(191,1104,5018,2,468000.00),(192,1104,5020,2,297000.00),(193,1105,5014,1,324000.00),(194,1105,5014,2,324000.00),(195,1105,5033,1,45000.00),(196,1106,5024,2,234000.00),(197,1106,5006,2,270000.00),(198,1107,5018,2,468000.00),(199,1107,5024,2,234000.00),(200,1108,5029,1,1170000.00),(201,1108,5025,2,405000.00),(202,1108,5033,1,45000.00),(203,1109,5027,1,1350000.00),(204,1109,5004,1,180000.00),(205,1110,5025,2,405000.00),(206,1110,5016,2,432000.00),(207,1111,5033,2,45000.00),(208,1112,5032,1,315000.00),(209,1112,5016,2,432000.00),(210,1112,5016,1,432000.00),(211,1113,5021,2,243000.00),(212,1113,5002,2,99000.00),(213,1114,5026,2,270000.00),(214,1114,5018,2,468000.00),(215,1114,5016,1,432000.00),(216,1115,5020,2,297000.00),(217,1115,5020,1,297000.00);
/*!40000 ALTER TABLE `chitietdonhang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chitietgiohang`
--

DROP TABLE IF EXISTS `chitietgiohang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chitietgiohang` (
  `GioHangID` int NOT NULL,
  `PhienBanID` int NOT NULL,
  `SoLuong` int NOT NULL,
  PRIMARY KEY (`GioHangID`,`PhienBanID`),
  KEY `PhienBanID` (`PhienBanID`),
  CONSTRAINT `chitietgiohang_ibfk_1` FOREIGN KEY (`GioHangID`) REFERENCES `giohang` (`NguoiDungID`) ON DELETE CASCADE,
  CONSTRAINT `chitietgiohang_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE,
  CONSTRAINT `chitietgiohang_chk_1` CHECK ((`SoLuong` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietgiohang`
--

LOCK TABLES `chitietgiohang` WRITE;
/*!40000 ALTER TABLE `chitietgiohang` DISABLE KEYS */;
/*!40000 ALTER TABLE `chitietgiohang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chitietphienban`
--

DROP TABLE IF EXISTS `chitietphienban`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chitietphienban` (
  `PhienBanID` int NOT NULL,
  `GiaTriID` int NOT NULL,
  PRIMARY KEY (`PhienBanID`,`GiaTriID`),
  KEY `GiaTriID` (`GiaTriID`),
  CONSTRAINT `chitietphienban_ibfk_1` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE,
  CONSTRAINT `chitietphienban_ibfk_2` FOREIGN KEY (`GiaTriID`) REFERENCES `giatrithuoctinh` (`GiaTriID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietphienban`
--

LOCK TABLES `chitietphienban` WRITE;
/*!40000 ALTER TABLE `chitietphienban` DISABLE KEYS */;
INSERT INTO `chitietphienban` VALUES (5001,3001),(5003,3001),(5002,3002),(5004,3002),(5005,3002),(5006,3002),(5007,3002),(5008,3002),(5009,3002),(5010,3002),(5012,3002),(5013,3002),(5014,3002),(5015,3002),(5016,3002),(5017,3002),(5018,3002),(5019,3002),(5020,3002),(5021,3002),(5022,3002),(5023,3002),(5024,3002),(5025,3002),(5026,3002),(5027,3002),(5050,3002),(5058,3002),(5004,3003),(5005,3003),(5006,3003),(5007,3003),(5008,3003),(5009,3003),(5010,3003),(5012,3003),(5013,3003),(5014,3003),(5015,3003),(5016,3003),(5017,3003),(5018,3003),(5019,3003),(5020,3003),(5021,3003),(5022,3003),(5023,3003),(5024,3003),(5025,3003),(5026,3003),(5027,3003),(5029,3003),(5030,3003),(5031,3003),(5032,3003),(5033,3003),(5034,3003),(5001,3004),(5002,3004),(5050,3004),(5003,3005),(5049,3006),(5057,3006),(5057,3009),(5058,3009),(5029,3011),(5028,3013),(5049,3013),(5030,3014),(5033,3014),(5034,3019);
/*!40000 ALTER TABLE `chitietphienban` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chitietreturns`
--

DROP TABLE IF EXISTS `chitietreturns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chitietreturns` (
  `ReturnID` int NOT NULL,
  `PhienBanID` int NOT NULL,
  `SoLuongTra` int NOT NULL,
  `GiaHoanTra` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ReturnID`,`PhienBanID`),
  KEY `PhienBanID` (`PhienBanID`),
  CONSTRAINT `chitietreturns_ibfk_1` FOREIGN KEY (`ReturnID`) REFERENCES `returns` (`ReturnID`) ON DELETE CASCADE,
  CONSTRAINT `chitietreturns_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`),
  CONSTRAINT `chitietreturns_chk_1` CHECK ((`SoLuongTra` > 0)),
  CONSTRAINT `chitietreturns_chk_2` CHECK ((`GiaHoanTra` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietreturns`
--

LOCK TABLES `chitietreturns` WRITE;
/*!40000 ALTER TABLE `chitietreturns` DISABLE KEYS */;
/*!40000 ALTER TABLE `chitietreturns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `danhgia`
--

DROP TABLE IF EXISTS `danhgia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danhgia` (
  `DanhGiaID` int NOT NULL AUTO_INCREMENT,
  `PhienBanID` int NOT NULL,
  `NguoiDungID` int NOT NULL,
  `DiemSo` int NOT NULL,
  `BinhLuan` text COLLATE utf8mb4_general_ci,
  `HinhAnhURL` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `HinhAnhPublicID` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VideoURL` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VideoPublicID` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  `NgayCapNhat` datetime DEFAULT NULL,
  `PhanHoi` text COLLATE utf8mb4_general_ci,
  `NgayPhanHoi` datetime DEFAULT NULL,
  PRIMARY KEY (`DanhGiaID`),
  KEY `NguoiDungID` (`NguoiDungID`),
  KEY `idx_danhgia_phienban` (`PhienBanID`),
  CONSTRAINT `danhgia_ibfk_1` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`),
  CONSTRAINT `danhgia_ibfk_2` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`),
  CONSTRAINT `danhgia_chk_1` CHECK ((`DiemSo` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danhgia`
--

LOCK TABLES `danhgia` WRITE;
/*!40000 ALTER TABLE `danhgia` DISABLE KEYS */;
INSERT INTO `danhgia` VALUES (12,5008,23,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2024-01-14 19:40:08',NULL,NULL,NULL),(13,5016,23,3,'Chất vải hơi mỏng.',NULL,NULL,NULL,NULL,'2024-01-15 19:40:08',NULL,NULL,NULL),(14,5013,23,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2024-01-15 19:40:08',NULL,NULL,NULL),(15,5029,23,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2024-01-13 19:40:08',NULL,NULL,NULL),(16,5020,23,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2024-01-08 19:07:35',NULL,NULL,NULL),(17,5021,55,4,'Mặc vừa vặn, khá thích.',NULL,NULL,NULL,NULL,'2024-02-16 20:25:22',NULL,NULL,NULL),(18,5027,55,4,'Đóng gói chưa đẹp lắm nhưng áo thì ok.',NULL,NULL,NULL,NULL,'2024-02-15 20:25:22',NULL,NULL,NULL),(19,5007,55,5,'Chất vải mềm mịn, mặc rất thoải mái.',NULL,NULL,NULL,NULL,'2024-02-15 20:25:22',NULL,NULL,NULL),(20,5002,29,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2024-02-16 11:47:04',NULL,NULL,NULL),(21,5004,29,3,'Bình thường, không quá đặc sắc.',NULL,NULL,NULL,NULL,'2024-02-16 11:47:04',NULL,NULL,NULL),(22,5014,52,5,'Giao hàng nhanh, đóng gói cẩn thận.',NULL,NULL,NULL,NULL,'2024-03-05 11:39:19',NULL,NULL,NULL),(23,5022,52,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2024-03-02 11:39:19',NULL,NULL,NULL),(24,5032,43,5,'Chất vải mềm mịn, mặc rất thoải mái.',NULL,NULL,NULL,NULL,'2024-02-07 15:47:49',NULL,NULL,NULL),(25,5022,43,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2024-02-11 15:47:49',NULL,NULL,NULL),(26,5006,59,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2024-03-07 12:47:20',NULL,NULL,NULL),(27,5022,59,4,'Đóng gói chưa đẹp lắm nhưng áo thì ok.',NULL,NULL,NULL,NULL,'2024-03-09 12:47:20',NULL,NULL,NULL),(28,5028,59,4,'Mặc vừa vặn, khá thích.',NULL,NULL,NULL,NULL,'2024-03-09 12:47:20',NULL,NULL,NULL),(29,5027,29,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2024-03-29 16:11:43',NULL,NULL,NULL),(30,5016,22,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2024-04-15 15:52:16',NULL,NULL,NULL),(31,5023,62,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2024-04-07 09:35:10',NULL,NULL,NULL),(32,5029,62,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2024-04-10 09:35:10',NULL,NULL,NULL),(33,5029,62,5,'Áo đẹp, form chuẩn, giá hợp lý.',NULL,NULL,NULL,NULL,'2024-04-06 09:35:10',NULL,NULL,NULL),(34,5020,59,3,'Bình thường, không quá đặc sắc.',NULL,NULL,NULL,NULL,'2024-05-24 10:48:58',NULL,NULL,NULL),(35,5024,27,5,'Áo đẹp, form chuẩn, giá hợp lý.',NULL,NULL,NULL,NULL,'2024-05-17 19:26:01',NULL,NULL,NULL),(36,5027,27,4,'Hàng ổn, giao hơi chậm xíu.',NULL,NULL,NULL,NULL,'2024-05-20 19:26:01',NULL,NULL,NULL),(37,5015,46,5,'Giao hàng nhanh, đóng gói cẩn thận.',NULL,NULL,NULL,NULL,'2024-05-30 17:09:50',NULL,NULL,NULL),(38,5019,30,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2024-06-30 15:15:35',NULL,NULL,NULL),(39,5022,30,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2024-06-30 15:15:35',NULL,NULL,NULL),(40,5026,68,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2024-06-08 09:21:49',NULL,NULL,NULL),(41,5010,36,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2024-06-25 17:34:02',NULL,NULL,NULL),(42,5027,36,4,'Hàng ổn, giao hơi chậm xíu.',NULL,NULL,NULL,NULL,'2024-06-22 17:34:02',NULL,NULL,NULL),(43,5032,47,4,'Mặc vừa vặn, khá thích.',NULL,NULL,NULL,NULL,'2024-07-13 21:05:07',NULL,NULL,NULL),(44,5015,47,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2024-07-09 21:05:07',NULL,NULL,NULL),(45,5027,21,5,'Áo đẹp, form chuẩn, giá hợp lý.',NULL,NULL,NULL,NULL,'2024-07-09 12:44:59',NULL,NULL,NULL),(46,5029,21,3,'Giao hàng lâu, sản phẩm tạm được.',NULL,NULL,NULL,NULL,'2024-07-07 12:44:59',NULL,NULL,NULL),(47,5032,51,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2024-08-05 17:09:47',NULL,NULL,NULL),(48,5026,36,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2024-08-15 18:31:38',NULL,NULL,NULL),(49,5032,47,4,'Đóng gói chưa đẹp lắm nhưng áo thì ok.',NULL,NULL,NULL,NULL,'2024-08-08 19:16:16',NULL,NULL,NULL),(50,5023,56,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2024-09-05 10:14:14',NULL,NULL,NULL),(51,5010,50,4,'Mặc vừa vặn, khá thích.',NULL,NULL,NULL,NULL,'2024-10-13 14:12:35',NULL,NULL,NULL),(52,5006,50,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2024-10-12 14:12:35',NULL,NULL,NULL),(53,5024,65,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2024-11-12 13:58:14',NULL,NULL,NULL),(54,5002,62,4,'Vải được, nhưng màu hơi nhạt so với hình.',NULL,NULL,NULL,NULL,'2024-11-14 17:34:04',NULL,NULL,NULL),(55,5016,65,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2024-11-24 19:54:19',NULL,NULL,NULL),(56,5004,65,5,'Chất vải mềm mịn, mặc rất thoải mái.',NULL,NULL,NULL,NULL,'2024-11-22 19:54:19',NULL,NULL,NULL),(57,5016,58,5,'Áo đẹp, form chuẩn, giá hợp lý.',NULL,NULL,NULL,NULL,'2024-12-15 20:07:05',NULL,NULL,NULL),(58,5008,36,3,'Giao hàng lâu, sản phẩm tạm được.',NULL,NULL,NULL,NULL,'2024-12-11 10:14:14',NULL,NULL,NULL),(59,5028,36,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2024-12-14 10:14:14',NULL,NULL,NULL),(60,5001,33,5,'Chất vải mềm mịn, mặc rất thoải mái.',NULL,NULL,NULL,NULL,'2025-01-30 15:47:33',NULL,NULL,NULL),(61,5023,55,4,'Đóng gói chưa đẹp lắm nhưng áo thì ok.',NULL,NULL,NULL,NULL,'2025-01-19 13:50:51',NULL,NULL,NULL),(62,5027,55,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2025-01-19 13:50:51',NULL,NULL,NULL),(63,5016,21,3,'Giao hàng lâu, sản phẩm tạm được.',NULL,NULL,NULL,NULL,'2025-02-19 11:25:22',NULL,NULL,NULL),(64,5022,21,5,'Giao hàng nhanh, đóng gói cẩn thận.',NULL,NULL,NULL,NULL,'2025-02-16 11:25:22',NULL,NULL,NULL),(65,5016,47,3,'Bình thường, không quá đặc sắc.',NULL,NULL,NULL,NULL,'2025-02-24 20:07:05',NULL,NULL,NULL),(66,5016,47,5,'Chất vải mềm mịn, mặc rất thoải mái.',NULL,NULL,NULL,NULL,'2025-02-22 20:07:05',NULL,NULL,NULL),(67,5019,47,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2025-02-23 20:07:05',NULL,NULL,NULL),(68,5016,47,5,'Áo đẹp, form chuẩn, giá hợp lý.',NULL,NULL,NULL,NULL,'2025-02-24 20:07:05',NULL,NULL,NULL),(69,5026,47,5,'Giao hàng nhanh, đóng gói cẩn thận.',NULL,NULL,NULL,NULL,'2025-02-13 20:46:17',NULL,NULL,NULL),(70,5025,56,3,'Bình thường, không quá đặc sắc.',NULL,NULL,NULL,NULL,'2025-03-28 16:54:19',NULL,NULL,NULL),(71,5033,27,4,'Tạm ổn trong tầm giá.',NULL,NULL,NULL,NULL,'2025-03-18 18:04:15',NULL,NULL,NULL),(72,5033,27,4,'Đóng gói chưa đẹp lắm nhưng áo thì ok.',NULL,NULL,NULL,NULL,'2025-03-18 18:04:15',NULL,NULL,NULL),(73,5009,57,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2025-03-07 14:45:07',NULL,NULL,NULL),(74,5027,38,5,'Chất vải mềm mịn, mặc rất thoải mái.',NULL,NULL,NULL,NULL,'2025-04-21 10:25:29',NULL,NULL,NULL),(75,5015,31,3,'Bình thường, không quá đặc sắc.',NULL,NULL,NULL,NULL,'2025-04-20 13:58:14',NULL,NULL,NULL),(76,5009,31,5,'Áo đẹp, form chuẩn, giá hợp lý.',NULL,NULL,NULL,NULL,'2025-04-18 13:58:14',NULL,NULL,NULL),(77,5023,31,3,'Giao hàng lâu, sản phẩm tạm được.',NULL,NULL,NULL,NULL,'2025-04-20 13:58:14',NULL,NULL,NULL),(78,5027,23,5,'Áo đẹp, form chuẩn, giá hợp lý.',NULL,NULL,NULL,NULL,'2025-05-08 12:44:59',NULL,NULL,NULL),(79,5012,23,3,'Chất vải hơi mỏng.',NULL,NULL,NULL,NULL,'2025-05-09 12:44:59',NULL,NULL,NULL),(80,5031,60,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2025-05-25 10:48:58',NULL,NULL,NULL),(81,5019,60,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2025-05-21 10:48:58',NULL,NULL,NULL),(82,5028,68,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2025-06-28 15:15:35',NULL,NULL,NULL),(83,5028,25,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2025-06-09 13:00:15',NULL,NULL,NULL),(84,5010,25,3,'Giao hàng lâu, sản phẩm tạm được.',NULL,NULL,NULL,NULL,'2025-06-12 13:00:15',NULL,NULL,NULL),(85,5010,25,4,'Hàng ổn, giao hơi chậm xíu.',NULL,NULL,NULL,NULL,'2025-06-10 13:00:15',NULL,NULL,NULL),(86,5033,41,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2025-07-31 12:59:06',NULL,NULL,NULL),(87,5033,41,4,'Mặc vừa vặn, khá thích.',NULL,NULL,NULL,NULL,'2025-07-31 12:59:06',NULL,NULL,NULL),(88,5016,36,4,'Mặc vừa vặn, khá thích.',NULL,NULL,NULL,NULL,'2025-07-21 11:29:43',NULL,NULL,NULL),(89,5010,36,5,'Giao hàng nhanh, đóng gói cẩn thận.',NULL,NULL,NULL,NULL,'2025-07-22 11:29:43',NULL,NULL,NULL),(90,5018,36,5,'Áo đẹp, form chuẩn, giá hợp lý.',NULL,NULL,NULL,NULL,'2025-07-21 11:29:43',NULL,NULL,NULL),(91,5006,37,4,'Vải được, nhưng màu hơi nhạt so với hình.',NULL,NULL,NULL,NULL,'2025-07-14 19:40:48',NULL,NULL,NULL),(92,5013,37,4,'Đóng gói chưa đẹp lắm nhưng áo thì ok.',NULL,NULL,NULL,NULL,'2025-07-10 19:40:48',NULL,NULL,NULL),(93,5032,37,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2025-07-12 19:40:48',NULL,NULL,NULL),(94,5031,65,3,'Giao hàng lâu, sản phẩm tạm được.',NULL,NULL,NULL,NULL,'2025-08-10 13:00:15',NULL,NULL,NULL),(95,5020,65,5,'Giao hàng nhanh, đóng gói cẩn thận.',NULL,NULL,NULL,NULL,'2025-08-12 13:00:15',NULL,NULL,NULL),(96,5026,31,5,'Sẽ ủng hộ shop dài dài.',NULL,NULL,NULL,NULL,'2025-08-18 11:21:52',NULL,NULL,NULL),(97,5018,30,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2025-08-24 09:25:27',NULL,NULL,NULL),(98,5014,30,4,'Vải được, nhưng màu hơi nhạt so với hình.',NULL,NULL,NULL,NULL,'2025-09-06 21:04:15',NULL,NULL,NULL),(99,5014,30,5,'Chất vải mềm mịn, mặc rất thoải mái.',NULL,NULL,NULL,NULL,'2025-09-09 21:04:15',NULL,NULL,NULL),(100,5024,52,5,'Chất vải mềm mịn, mặc rất thoải mái.',NULL,NULL,NULL,NULL,'2025-09-27 12:13:32',NULL,NULL,NULL),(101,5033,62,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2025-10-30 09:44:41',NULL,NULL,NULL),(102,5027,39,3,'Chất vải hơi mỏng.',NULL,NULL,NULL,NULL,'2025-10-12 08:55:06',NULL,NULL,NULL),(103,5004,39,5,'Chất vải mềm mịn, mặc rất thoải mái.',NULL,NULL,NULL,NULL,'2025-10-09 08:55:06',NULL,NULL,NULL),(104,5025,35,5,'Sản phẩm rất đẹp, đúng như mô tả.',NULL,NULL,NULL,NULL,'2025-11-27 18:03:00',NULL,NULL,NULL),(105,5016,60,5,'Rất hài lòng với chất lượng sản phẩm.',NULL,NULL,NULL,NULL,'2025-11-13 17:34:04',NULL,NULL,NULL);
/*!40000 ALTER TABLE `danhgia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `danhmuc`
--

DROP TABLE IF EXISTS `danhmuc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danhmuc` (
  `DanhMucID` int NOT NULL AUTO_INCREMENT,
  `TenDanhMuc` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `Slug` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `DanhMucChaID` int DEFAULT NULL,
  `MoTa` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`DanhMucID`),
  UNIQUE KEY `TenDanhMuc` (`TenDanhMuc`),
  UNIQUE KEY `Slug` (`Slug`),
  KEY `DanhMucChaID` (`DanhMucChaID`),
  KEY `idx_danhmuc_slug` (`Slug`),
  CONSTRAINT `danhmuc_ibfk_1` FOREIGN KEY (`DanhMucChaID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=447 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danhmuc`
--

LOCK TABLES `danhmuc` WRITE;
/*!40000 ALTER TABLE `danhmuc` DISABLE KEYS */;
INSERT INTO `danhmuc` VALUES (401,'Đồ Nam','do-nam',NULL,NULL),(402,'Đồ Nữ','do-nu',NULL,NULL),(403,'Đồ Thể Thao','do-the-thao',NULL,NULL),(404,'Đồ Da','do-da',NULL,NULL),(405,'Phụ Kiện','phu-kien',NULL,NULL),(406,'Áo Thun Nam','ao-thun-nam',401,NULL),(407,'Áo Sơ Mi Nam','ao-so-mi-nam',401,NULL),(408,'Áo Polo Nam','ao-polo-nam',401,NULL),(409,'Áo Khoác Nam','ao-khoac-nam',401,NULL),(410,'Áo Hoodie Nam','ao-hoodie-nam',401,NULL),(411,'Quần Jean Nam','quan-jean-nam',401,NULL),(412,'Quần Short Nam','quan-short-nam',401,NULL),(413,'Quần Kaki Nam','quan-kaki-nam',401,NULL),(414,'Quần Tây Nam','quan-tay-nam',401,NULL),(415,'Áo Thun Nữ','ao-thun-nu',402,NULL),(416,'Áo Sơ Mi Nữ','ao-so-mi-nu',402,NULL),(417,'Áo Croptop','ao-croptop',402,NULL),(418,'Áo Hoodie Nữ','ao-hoodie-nu',402,NULL),(419,'Áo Khoác Nữ','ao-khoac-nu',402,NULL),(420,'Quần Jean Nữ','quan-jean-nu',402,NULL),(421,'Quần Short Nữ','quan-short-nu',402,NULL),(422,'Quần Ống Rộng','quan-ong-rong',402,NULL),(423,'Chân Váy','chan-vay',402,NULL),(424,'Váy & Đầm','dam-nu',402,NULL),(425,'Quần Áo Tập Gym','quan-ao-tap-gym',403,NULL),(426,'Đồ Chạy Bộ','do-chay-bo',403,NULL),(427,'Đồ Bơi','do-boi',403,NULL),(428,'Áo Khoác Thể Thao','ao-khoac-the-thao',403,NULL),(429,'Áo Khoác Da','ao-khoac-da',404,NULL),(430,'Ví Da','vi-da',404,NULL),(431,'Giày Da','giay-da',404,NULL),(432,'Mũ & Nón','mu-non',405,NULL),(433,'Túi & Balo','tui-balo',405,NULL),(434,'Kính Mát','kinh-mat',405,NULL),(435,'Tất & Vớ','tat-vo',405,NULL),(436,'Thắt Lưng','that-lung',405,NULL),(439,'Áo mùa thu','ao-mua-thu',401,NULL);
/*!40000 ALTER TABLE `danhmuc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diachigiaohang`
--

DROP TABLE IF EXISTS `diachigiaohang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diachigiaohang` (
  `DiaChiID` int NOT NULL AUTO_INCREMENT,
  `NguoiDungID` int NOT NULL,
  `TenNguoiNhan` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `DienThoaiNhan` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `DiaChiChiTiet` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `PhuongXa` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `QuanHuyen` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `TinhThanh` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `MacDinh` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`DiaChiID`),
  KEY `NguoiDungID` (`NguoiDungID`),
  CONSTRAINT `diachigiaohang_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diachigiaohang`
--

LOCK TABLES `diachigiaohang` WRITE;
/*!40000 ALTER TABLE `diachigiaohang` DISABLE KEYS */;
INSERT INTO `diachigiaohang` VALUES (155,21,'Khách hàng 21','090123421','Số 56 Nguyễn Trãi','Phường Bến Thành','Quận 1','Hồ Chí Minh',1),(156,22,'Khách hàng 22','090123422','Số 89 Lê Lợi','Phường Thạch Thang','Quận Hải Châu','Đà Nẵng',1),(157,23,'Khách hàng 23','090123423','Số 12 Cầu Giấy','Phường Quan Hoa','Quận Cầu Giấy','Hà Nội',1),(158,24,'Khách hàng 24','090123424','Số 34 Đường 3/2','Phường Xuân Khánh','Quận Ninh Kiều','Cần Thơ',1),(159,25,'Khách hàng 25','090123425','Số 78 Lê Chân','Phường An Biên','Quận Lê Chân','Hải Phòng',1),(160,26,'Khách hàng 26','090123426','Số 90 Nguyễn Huệ','Phường Bến Nghé','Quận 1','Hồ Chí Minh',1),(161,27,'Khách hàng 27','090123427','Số 23 Hùng Vương','Phường Hải Châu 1','Quận Hải Châu','Đà Nẵng',1),(162,28,'Khách hàng 28','090123428','Số 45 Đội Cấn','Phường Đội Cấn','Quận Ba Đình','Hà Nội',1),(163,29,'Khách hàng 29','090123429','Số 67 Mậu Thân','Phường An Phú','Quận Ninh Kiều','Cần Thơ',1),(164,30,'Khách hàng 30','090123430','Số 11 Tô Hiệu','Phường Trại Cau','Quận Lê Chân','Hải Phòng',1),(165,31,'Khách hàng 31','090123431','Số 33 Pastuer','Phường Bến Nghé','Quận 1','Hồ Chí Minh',1),(166,32,'Khách hàng 32','090123432','Số 55 Bạch Đằng','Phường Hải Châu 2','Quận Hải Châu','Đà Nẵng',1),(167,33,'Khách hàng 33','090123433','Số 77 Kim Mã','Phường Kim Mã','Quận Ba Đình','Hà Nội',1),(168,34,'Khách hàng 34','090123434','Số 99 Nguyễn Văn Cừ','Phường An Hòa','Quận Ninh Kiều','Cần Thơ',1),(169,35,'Khách hàng 35','090123435','Số 21 Lạch Tray','Phường Lạch Tray','Quận Ngô Quyền','Hải Phòng',1),(170,36,'Khách hàng 36','090123436','Số 43 Trần Hưng Đạo','Phường Cầu Kho','Quận 1','Hồ Chí Minh',1),(171,37,'Khách hàng 37','090123437','Số 65 Phan Chu Trinh','Phường Hải Châu 1','Quận Hải Châu','Đà Nẵng',1),(172,38,'Khách hàng 38','090123438','Số 87 Giảng Võ','Phường Cát Linh','Quận Đống Đa','Hà Nội',1),(173,39,'Khách hàng 39','090123439','Số 9 Ba Tháng Hai','Phường Hưng Lợi','Quận Ninh Kiều','Cần Thơ',1),(174,40,'Khách hàng 40','090123440','Số 31 Cầu Đất','Phường Cầu Đất','Quận Ngô Quyền','Hải Phòng',1),(175,41,'Khách hàng 41','090123441','Số 53 Hàm Nghi','Phường Bến Nghé','Quận 1','Hồ Chí Minh',1),(176,42,'Khách hàng 42','090123442','Số 75 Hoàng Diệu','Phường Phước Ninh','Quận Hải Châu','Đà Nẵng',1),(177,43,'Khách hàng 43','090123443','Số 97 Láng Hạ','Phường Láng Hạ','Quận Đống Đa','Hà Nội',1),(178,44,'Khách hàng 44','090123444','Số 19 Võ Văn Kiệt','Phường An Hòa','Quận Ninh Kiều','Cần Thơ',1),(179,45,'Khách hàng 45','090123445','Số 41 Đình Đông','Phường Đông Hải','Quận Lê Chân','Hải Phòng',1),(180,46,'Khách hàng 46','090123446','Số 63 Đồng Khởi','Phường Bến Nghé','Quận 1','Hồ Chí Minh',1),(181,47,'Khách hàng 47','090123447','Số 85 Ông Ích Khiêm','Phường Thanh Bình','Quận Hải Châu','Đà Nẵng',1),(182,48,'Khách hàng 48','090123448','Số 7 Thái Hà','Phường Trung Liệt','Quận Đống Đa','Hà Nội',1),(183,49,'Khách hàng 49','090123449','Số 29 Trần Hưng Đạo','Phường An Phú','Quận Ninh Kiều','Cần Thơ',1),(184,50,'Khách hàng 50','090123450','Số 51 Hai Bà Trưng','Phường An Biên','Quận Lê Chân','Hải Phòng',1),(185,51,'Khách hàng 51','090123451','Số 73 Hai Bà Trưng','Phường Bến Nghé','Quận 1','Hồ Chí Minh',1),(186,52,'Khách hàng 52','090123452','Số 95 Nguyễn Văn Linh','Phường Nam Dương','Quận Hải Châu','Đà Nẵng',1),(187,53,'Khách hàng 53','090123453','Số 17 Xã Đàn','Phường Phương Liên','Quận Đống Đa','Hà Nội',1),(188,54,'Khách hàng 54','090123454','Số 39 Lý Tự Trọng','Phường An Cư','Quận Ninh Kiều','Cần Thơ',1),(189,55,'Khách hàng 55','090123455','Số 61 Nguyễn Đức Cảnh','Phường An Biên','Quận Lê Chân','Hải Phòng',1),(190,56,'Khách hàng 56','090123456','Số 83 Lê Duẩn','Phường Bến Nghé','Quận 1','Hồ Chí Minh',1),(191,57,'Khách hàng 57','090123457','Số 5 Trưng Nữ Vương','Phường Bình Hiên','Quận Hải Châu','Đà Nẵng',1),(192,58,'Khách hàng 58','090123458','Số 27 Chùa Bộc','Phường Quang Trung','Quận Đống Đa','Hà Nội',1),(193,59,'Khách hàng 59','090123459','Số 49 Trần Phú','Phường Cái Khế','Quận Ninh Kiều','Cần Thơ',1),(194,60,'Khách hàng 60','090123460','Số 71 Lạch Tray','Phường Lạch Tray','Quận Ngô Quyền','Hải Phòng',1),(195,61,'Khách hàng 61','090123461','Số 93 Tôn Đức Thắng','Phường Bến Nghé','Quận 1','Hồ Chí Minh',1),(196,62,'Khách hàng 62','090123462','Số 15 Duy Tân','Phường Hòa Thuận Tây','Quận Hải Châu','Đà Nẵng',1),(197,63,'Khách hàng 63','090123463','Số 37 Tây Sơn','Phường Quang Trung','Quận Đống Đa','Hà Nội',1),(198,64,'Khách hàng 64','090123464','Số 59 Hùng Vương','Phường Thới Bình','Quận Ninh Kiều','Cần Thơ',1),(199,65,'Khách hàng 65','090123465','Số 81 Cầu Đất','Phường Cầu Đất','Quận Ngô Quyền','Hải Phòng',1),(200,66,'Khách hàng 66','090123466','Số 3 Lý Tự Trọng','Phường Bến Nghé','Quận 1','Hồ Chí Minh',1),(201,67,'Khách hàng 67','090123467','Số 25 Nguyễn Văn Linh','Phường Nam Dương','Quận Hải Châu','Đà Nẵng',1),(202,68,'Khách hàng 68','090123468','Số 47 Nguyễn Lương Bằng','Phường Nam Đồng','Quận Đống Đa','Hà Nội',1),(203,69,'Khách hàng 69','090123469','Số 69 Trần Văn Hoài','Phường Xuân Khánh','Quận Ninh Kiều','Cần Thơ',1),(204,70,'Khách hàng 70','090123470','Số 91 Tô Hiệu','Phường Trại Cau','Quận Lê Chân','Hải Phòng',1);
/*!40000 ALTER TABLE `diachigiaohang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donhang`
--

DROP TABLE IF EXISTS `donhang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donhang` (
  `DonHangID` int NOT NULL AUTO_INCREMENT,
  `NguoiDungID` int NOT NULL,
  `DiaChiGiaoHangID` int NOT NULL,
  `MaKhuyenMai` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PhuongThucID` int DEFAULT NULL,
  `NgayDatHang` datetime DEFAULT CURRENT_TIMESTAMP,
  `TongTienHang` decimal(10,2) NOT NULL,
  `PhiVanChuyen` decimal(10,2) DEFAULT '0.00',
  `TongThanhToan` decimal(10,2) NOT NULL,
  `TrangThai` enum('CHUA_THANH_TOAN','DANG_XU_LY','DANG_GIAO','DA_GIAO','DA_HUY','DOI_TRA') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DANG_XU_LY',
  `GhiChu` text COLLATE utf8mb4_general_ci,
  `NgayCapNhat` datetime DEFAULT NULL,
  `NguoiCapNhat` int DEFAULT NULL,
  PRIMARY KEY (`DonHangID`),
  KEY `DiaChiGiaoHangID` (`DiaChiGiaoHangID`),
  KEY `MaKhuyenMai` (`MaKhuyenMai`),
  KEY `PhuongThucID` (`PhuongThucID`),
  KEY `idx_donhang_trangthai` (`TrangThai`),
  KEY `idx_donhang_nguoidung` (`NguoiDungID`),
  CONSTRAINT `donhang_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`),
  CONSTRAINT `donhang_ibfk_2` FOREIGN KEY (`DiaChiGiaoHangID`) REFERENCES `diachigiaohang` (`DiaChiID`),
  CONSTRAINT `donhang_ibfk_3` FOREIGN KEY (`MaKhuyenMai`) REFERENCES `khuyenmai` (`MaKhuyenMai`),
  CONSTRAINT `donhang_ibfk_4` FOREIGN KEY (`PhuongThucID`) REFERENCES `phuongthucvanchuyen` (`PhuongThucID`),
  CONSTRAINT `donhang_chk_1` CHECK ((`TongTienHang` >= 0)),
  CONSTRAINT `donhang_chk_2` CHECK ((`PhiVanChuyen` >= 0)),
  CONSTRAINT `donhang_chk_3` CHECK ((`TongThanhToan` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=1128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donhang`
--

LOCK TABLES `donhang` WRITE;
/*!40000 ALTER TABLE `donhang` DISABLE KEYS */;
INSERT INTO `donhang` VALUES (1051,63,197,NULL,601,'2024-01-26 15:02:16',324000.00,30000.00,354000.00,'DA_GIAO','Đơn hàng tự động','2024-01-26 15:02:16',NULL),(1052,23,157,NULL,601,'2024-01-08 19:40:08',5014000.00,30000.00,3180000.00,'DA_GIAO','Đơn hàng tự động','2024-01-08 19:40:08',NULL),(1053,23,157,NULL,602,'2024-01-01 19:07:35',1044000.00,50000.00,1031000.00,'DA_GIAO','Đơn hàng tự động','2024-01-01 19:07:35',NULL),(1054,55,189,NULL,601,'2024-02-09 20:25:22',3843000.00,30000.00,1731000.00,'DA_GIAO','Đơn hàng tự động','2024-02-09 20:25:22',NULL),(1055,29,163,NULL,601,'2024-02-12 11:47:04',279000.00,30000.00,219000.00,'DA_GIAO','Đơn hàng tự động','2024-02-12 11:47:04',NULL),(1056,52,186,NULL,601,'2024-02-28 11:39:19',2358000.00,30000.00,1686000.00,'DA_GIAO','Đơn hàng tự động','2024-02-28 11:39:19',NULL),(1057,43,177,NULL,601,'2024-02-04 15:47:49',855000.00,30000.00,885000.00,'DA_GIAO','Đơn hàng tự động','2024-02-04 15:47:49',NULL),(1058,59,193,NULL,602,'2024-03-03 12:47:20',1782000.00,50000.00,2165000.00,'DA_GIAO','Đơn hàng tự động','2024-03-03 12:47:20',NULL),(1059,29,163,NULL,601,'2024-03-24 16:11:43',3240000.00,30000.00,1794000.00,'DA_GIAO','Đơn hàng tự động','2024-03-24 16:11:43',NULL),(1060,22,156,NULL,601,'2024-04-11 15:52:16',432000.00,30000.00,462000.00,'DA_GIAO','Đơn hàng tự động','2024-04-11 15:52:16',NULL),(1061,62,196,NULL,602,'2024-04-03 09:35:10',4960000.00,50000.00,4532000.00,'DA_GIAO','Đơn hàng tự động','2024-04-03 09:35:10',NULL),(1062,59,193,NULL,601,'2024-05-18 10:48:58',1134000.00,30000.00,1164000.00,'DA_GIAO','Đơn hàng tự động','2024-05-18 10:48:58',NULL),(1063,27,161,NULL,601,'2024-05-13 19:26:01',3708000.00,30000.00,2046000.00,'DA_GIAO','Đơn hàng tự động','2024-05-13 19:26:01',NULL),(1064,46,180,NULL,601,'2024-05-24 17:09:50',864000.00,30000.00,390000.00,'DA_GIAO','Đơn hàng tự động','2024-05-24 17:09:50',NULL),(1065,30,164,NULL,601,'2024-06-25 15:15:35',1584000.00,30000.00,1614000.00,'DA_GIAO','Đơn hàng tự động','2024-06-25 15:15:35',NULL),(1066,68,202,NULL,602,'2024-06-03 09:21:49',270000.00,50000.00,320000.00,'DA_GIAO','Đơn hàng tự động','2024-06-03 09:21:49',NULL),(1067,36,170,NULL,602,'2024-06-18 17:34:02',1575000.00,50000.00,1625000.00,'DA_GIAO','Đơn hàng tự động','2024-06-18 17:34:02',NULL),(1068,47,181,NULL,602,'2024-07-06 21:05:07',954000.00,50000.00,1004000.00,'DA_GIAO','Đơn hàng tự động','2024-07-06 21:05:07',NULL),(1069,21,155,NULL,602,'2024-07-02 12:44:59',2520000.00,50000.00,2534000.00,'DA_GIAO','Đơn hàng tự động','2024-07-02 12:44:59',NULL),(1070,51,185,NULL,602,'2024-08-01 17:09:47',630000.00,50000.00,680000.00,'DA_GIAO','Đơn hàng tự động','2024-08-01 17:09:47',NULL),(1071,36,170,NULL,602,'2024-08-10 18:31:38',2570000.00,50000.00,2957000.00,'DA_GIAO','Đơn hàng tự động','2024-08-10 18:31:38',NULL),(1072,47,181,NULL,601,'2024-08-01 19:16:16',1170000.00,30000.00,1002000.00,'DA_GIAO','Đơn hàng tự động','2024-08-01 19:16:16',NULL),(1073,56,190,NULL,601,'2024-09-02 10:14:14',2088000.00,30000.00,1866000.00,'DA_GIAO','Đơn hàng tự động','2024-09-02 10:14:14',NULL),(1074,53,187,NULL,602,'2024-09-07 19:12:48',3150000.00,50000.00,2165000.00,'DA_GIAO','Đơn hàng tự động','2024-09-07 19:12:48',NULL),(1075,59,193,NULL,601,'2024-10-25 10:20:13',2700000.00,30000.00,2730000.00,'DA_GIAO','Đơn hàng tự động','2024-10-25 10:20:13',NULL),(1076,50,184,NULL,601,'2024-10-06 14:12:35',990000.00,30000.00,1020000.00,'DA_GIAO','Đơn hàng tự động','2024-10-06 14:12:35',NULL),(1077,65,199,NULL,602,'2024-11-06 13:58:14',1404000.00,50000.00,1454000.00,'DA_GIAO','Đơn hàng tự động','2024-11-06 13:58:14',NULL),(1078,62,196,NULL,602,'2024-11-08 17:34:04',369000.00,50000.00,419000.00,'DA_GIAO','Đơn hàng tự động','2024-11-08 17:34:04',NULL),(1079,65,199,NULL,602,'2024-11-17 19:54:19',1728000.00,50000.00,1994000.00,'DA_GIAO','Đơn hàng tự động','2024-11-17 19:54:19',NULL),(1080,58,192,NULL,601,'2024-12-09 20:07:05',1332000.00,30000.00,1362000.00,'DA_GIAO','Đơn hàng tự động','2024-12-09 20:07:05',NULL),(1081,65,199,NULL,602,'2024-12-05 13:58:14',1215000.00,50000.00,1265000.00,'DA_GIAO','Đơn hàng tự động','2024-12-05 13:58:14',NULL),(1082,36,170,NULL,601,'2024-12-07 10:14:14',855000.00,30000.00,885000.00,'DA_GIAO','Đơn hàng tự động','2024-12-07 10:14:14',NULL),(1083,33,167,NULL,601,'2025-01-26 15:47:33',198000.00,30000.00,228000.00,'DA_GIAO','Đơn hàng tự động','2025-01-26 15:47:33',NULL),(1084,55,189,NULL,601,'2025-01-15 13:50:51',1908000.00,30000.00,1938000.00,'DA_GIAO','Đơn hàng tự động','2025-01-15 13:50:51',NULL),(1085,30,164,NULL,601,'2025-01-07 16:51:30',2115000.00,30000.00,2145000.00,'DA_GIAO','Đơn hàng tự động','2025-01-07 16:51:30',NULL),(1086,21,155,NULL,602,'2025-02-12 11:25:22',1512000.00,50000.00,1562000.00,'DA_GIAO','Đơn hàng tự động','2025-02-12 11:25:22',NULL),(1087,47,181,NULL,602,'2025-02-18 20:07:05',2232000.00,50000.00,2210000.00,'DA_GIAO','Đơn hàng tự động','2025-02-18 20:07:05',NULL),(1088,47,181,NULL,602,'2025-02-09 20:46:17',819000.00,50000.00,311000.00,'DA_GIAO','Đơn hàng tự động','2025-02-09 20:46:17',NULL),(1089,56,190,NULL,601,'2025-03-24 16:54:19',3060000.00,30000.00,3054000.00,'DA_GIAO','Đơn hàng tự động','2025-03-24 16:54:19',NULL),(1090,27,161,NULL,601,'2025-03-12 18:04:15',135000.00,30000.00,84000.00,'DA_GIAO','Đơn hàng tự động','2025-03-12 18:04:15',NULL),(1091,57,191,NULL,602,'2025-03-03 14:45:07',495000.00,50000.00,545000.00,'DA_GIAO','Đơn hàng tự động','2025-03-03 14:45:07',NULL),(1092,38,172,NULL,601,'2025-04-18 10:25:29',2700000.00,30000.00,2730000.00,'DA_GIAO','Đơn hàng tự động','2025-04-18 10:25:29',NULL),(1093,31,165,NULL,602,'2025-04-15 13:58:14',1710000.00,50000.00,1679000.00,'DA_GIAO','Đơn hàng tự động','2025-04-15 13:58:14',NULL),(1094,63,197,NULL,601,'2025-05-18 16:11:41',270000.00,30000.00,300000.00,'DA_GIAO','Đơn hàng tự động','2025-05-18 16:11:41',NULL),(1095,23,157,NULL,602,'2025-05-02 12:44:59',2484000.00,50000.00,2534000.00,'DA_GIAO','Đơn hàng tự động','2025-05-02 12:44:59',NULL),(1096,60,194,NULL,602,'2025-05-18 10:48:58',2070000.00,50000.00,2048000.00,'DA_GIAO','Đơn hàng tự động','2025-05-18 10:48:58',NULL),(1097,68,202,NULL,601,'2025-06-25 15:15:35',900000.00,30000.00,930000.00,'DA_GIAO','Đơn hàng tự động','2025-06-25 15:15:35',NULL),(1098,25,159,NULL,602,'2025-06-05 13:00:15',2925000.00,50000.00,2975000.00,'DA_GIAO','Đơn hàng tự động','2025-06-05 13:00:15',NULL),(1099,41,175,NULL,602,'2025-07-26 12:59:06',225000.00,50000.00,275000.00,'DA_GIAO','Đơn hàng tự động','2025-07-26 12:59:06',NULL),(1100,36,170,NULL,602,'2025-07-16 11:29:43',2682000.00,50000.00,2768000.00,'DA_GIAO','Đơn hàng tự động','2025-07-16 11:29:43',NULL),(1101,37,171,NULL,602,'2025-07-07 19:40:48',1045000.00,50000.00,1094000.00,'DA_GIAO','Đơn hàng tự động','2025-07-07 19:40:48',NULL),(1102,65,199,NULL,602,'2025-08-05 13:00:15',1854000.00,50000.00,1886000.00,'DA_GIAO','Đơn hàng tự động','2025-08-05 13:00:15',NULL),(1103,31,165,NULL,602,'2025-08-11 11:21:52',1080000.00,50000.00,932000.00,'DA_GIAO','Đơn hàng tự động','2025-08-11 11:21:52',NULL),(1104,30,164,NULL,601,'2025-08-20 09:25:27',1530000.00,30000.00,1560000.00,'DA_GIAO','Đơn hàng tự động','2025-08-20 09:25:27',NULL),(1105,30,164,NULL,601,'2025-09-02 21:04:15',1017000.00,30000.00,1047000.00,'DA_GIAO','Đơn hàng tự động','2025-09-02 21:04:15',NULL),(1106,52,186,NULL,601,'2025-09-20 12:13:32',1008000.00,30000.00,912000.00,'DA_GIAO','Đơn hàng tự động','2025-09-20 12:13:32',NULL),(1107,30,164,NULL,601,'2025-09-21 16:32:20',1404000.00,30000.00,1434000.00,'DA_GIAO','Đơn hàng tự động','2025-09-21 16:32:20',NULL),(1108,62,196,NULL,602,'2025-10-27 09:44:41',2025000.00,50000.00,2075000.00,'DA_GIAO','Đơn hàng tự động','2025-10-27 09:44:41',NULL),(1109,39,173,NULL,602,'2025-10-06 08:55:06',1530000.00,50000.00,1580000.00,'DA_GIAO','Đơn hàng tự động','2025-10-06 08:55:06',NULL),(1110,35,169,NULL,602,'2025-11-20 18:03:00',1674000.00,50000.00,1706000.00,'DA_GIAO','Đơn hàng tự động','2025-11-20 18:03:00',NULL),(1111,44,178,NULL,601,'2025-11-06 17:34:39',90000.00,30000.00,84000.00,'DA_GIAO','Đơn hàng tự động','2025-11-06 17:34:39',NULL),(1112,60,194,NULL,601,'2025-11-08 17:34:04',1611000.00,30000.00,1641000.00,'DA_GIAO','Đơn hàng tự động','2025-11-08 17:34:04',NULL),(1113,22,156,NULL,602,'2025-12-11 12:12:35',684000.00,50000.00,734000.00,'DANG_XU_LY','Đơn hàng tự động','2025-12-11 12:12:35',NULL),(1114,46,180,NULL,601,'2025-12-07 10:14:14',1908000.00,30000.00,1938000.00,'DANG_XU_LY','Đơn hàng tự động','2025-12-07 10:14:14',NULL),(1115,62,196,NULL,602,'2025-12-11 11:21:52',891000.00,50000.00,932000.00,'DANG_GIAO','Đơn hàng tự động','2025-12-11 11:21:52',NULL);
/*!40000 ALTER TABLE `donhang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `giatrithuoctinh`
--

DROP TABLE IF EXISTS `giatrithuoctinh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giatrithuoctinh` (
  `GiaTriID` int NOT NULL AUTO_INCREMENT,
  `ThuocTinhID` int NOT NULL,
  `GiaTri` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`GiaTriID`),
  UNIQUE KEY `ThuocTinhID` (`ThuocTinhID`,`GiaTri`),
  CONSTRAINT `giatrithuoctinh_ibfk_1` FOREIGN KEY (`ThuocTinhID`) REFERENCES `thuoctinh` (`ThuocTinhID`)
) ENGINE=InnoDB AUTO_INCREMENT=3023 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giatrithuoctinh`
--

LOCK TABLES `giatrithuoctinh` WRITE;
/*!40000 ALTER TABLE `giatrithuoctinh` DISABLE KEYS */;
INSERT INTO `giatrithuoctinh` VALUES (3006,301,'L'),(3002,301,'M'),(3001,301,'S'),(3007,301,'XL'),(3008,301,'XXL'),(3013,302,'Nâu'),(3004,302,'Trắng'),(3009,302,'Vàng'),(3005,302,'Xanh'),(3003,302,'Đen'),(3010,302,'Đỏ'),(3015,303,'39'),(3011,303,'40'),(3012,303,'41'),(3016,303,'42'),(3017,303,'43'),(3020,304,'100cm'),(3021,304,'110cm'),(3022,304,'120cm'),(3018,304,'80cm'),(3019,304,'90cm'),(3014,305,'Freesize');
/*!40000 ALTER TABLE `giatrithuoctinh` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `giohang`
--

DROP TABLE IF EXISTS `giohang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giohang` (
  `NguoiDungID` int NOT NULL,
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  `NgayCapNhat` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`NguoiDungID`),
  CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giohang`
--

LOCK TABLES `giohang` WRITE;
/*!40000 ALTER TABLE `giohang` DISABLE KEYS */;
/*!40000 ALTER TABLE `giohang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hinhanhsanpham`
--

DROP TABLE IF EXISTS `hinhanhsanpham`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hinhanhsanpham` (
  `HinhAnhID` int NOT NULL AUTO_INCREMENT,
  `SanPhamID` int NOT NULL,
  `PhienBanID` int DEFAULT NULL,
  `URL` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `MoTa` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LaAnhChinh` tinyint(1) DEFAULT '0',
  `ViTri` int DEFAULT '0',
  PRIMARY KEY (`HinhAnhID`),
  KEY `SanPhamID` (`SanPhamID`),
  KEY `fk_hinhanh_phienban` (`PhienBanID`),
  CONSTRAINT `fk_hinhanh_phienban` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE,
  CONSTRAINT `hinhanhsanpham_ibfk_1` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE CASCADE,
  CONSTRAINT `hinhanhsanpham_chk_1` CHECK ((`ViTri` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hinhanhsanpham`
--

LOCK TABLES `hinhanhsanpham` WRITE;
/*!40000 ALTER TABLE `hinhanhsanpham` DISABLE KEYS */;
INSERT INTO `hinhanhsanpham` VALUES (1,201,NULL,'https://img.lazcdn.com/g/p/d60951be1736ed5fc99ba5da947642cf.png_720x720q80.png',NULL,1,0),(2,201,NULL,'https://product.hstatic.net/200000404243/product/a3mn140r2-vnma026-2010-n-1_6644379e77504eedbec568889885df35.jpg',NULL,0,0),(3,202,NULL,'https://bizweb.dktcdn.net/100/396/594/products/img-1742.jpg?v=1708922250740',NULL,1,0),(97,203,NULL,'https://product.hstatic.net/200000471735/product/mts205s5-2-n01__2__c717a7ec0141485093264be148632b79.jpg',NULL,1,0),(98,203,NULL,'https://colo.com.vn/wp-content/uploads/2023/10/ao-thun-nam-co-tron-den-1.jpeg',NULL,0,0),(99,204,NULL,'https://product.hstatic.net/200000588671/product/ao-so-mi-nam-tay-dai-cong-so-bamboo-mau-xanh-den-1_15a13335f0b74f48a7e2f4d50aed2e01.jpg',NULL,1,0),(100,204,NULL,'https://pos.nvncdn.com/492284-9176/ps/20241110_WeY0twVLPU.jpeg?v=1731229011',NULL,0,0),(101,205,NULL,'https://cf.shopee.vn/file/c93a40ed8dc173297fa4bcd78d767186',NULL,1,0),(102,205,NULL,'https://down-vn.img.susercontent.com/file/34acd5e930c8a21e1c3a70d3cf2a70c5',NULL,0,0),(103,206,NULL,'https://lados.vn/wp-content/uploads/2024/09/3-kem-ld2107.jpg',NULL,1,0),(104,206,NULL,'https://product.hstatic.net/1000369857/product/akd903_1_tui_1200x1200_0002_layer_21_c8306b98e3604f5890c8446b99cf2a9b.jpg',NULL,0,0),(105,207,NULL,'https://product.hstatic.net/200000370509/product/1481_66c8e86d83a73540f408618b2cde78c7_66fa80d9d6d7434c8cdacfef45c12072_64843aa2f0ac499fbe30e2951a529139_large.jpg',NULL,1,0),(106,207,NULL,'https://product.hstatic.net/200000370449/product/hdr_den_sau_ec2123b4a8b447cb92efe95165691a12_master.jpg',NULL,0,0),(107,208,NULL,'https://4menshop.com/images/thumbs/2020/09/quan-jean-rach-goi-qj004-mau-den-15557.png',NULL,1,0),(108,208,NULL,'https://4menshop.com/images/thumbs/2020/05/quan-jean-slimfit-qj1645-mau-den-15196.png',NULL,0,0),(109,209,NULL,'https://product.hstatic.net/1000096703/product/kenta183__1__8d9f2bf14a22446db4465d2d8725ba92_master.jpg',NULL,1,0),(110,209,NULL,'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/03/quan-short-nam-lacoste-kaki-slim-mau-xanh-navy-size-33-65ebbcff03d96-09032024083559.jpg',NULL,0,0),(111,210,NULL,'https://4menshop.com/images/thumbs/2019/11/quan-kaki-slimfit-xanh-qk181-14848.jpg',NULL,1,0),(112,210,NULL,'https://product.hstatic.net/200000370509/product/6916_a5d3f55ffc09c0874577cff4e5bb5ebc_78b074ca40724ce8a8acb5822b6e0da9_54ccd36cf22f4768a70eef7fb85dabe2_master.jpg',NULL,0,0),(113,211,NULL,'https://dongphucbonmua.com/wp-content/uploads/2019/08/dong-phuc-quan-au-cong-so-nam-mau-den.jpg',NULL,1,0),(114,211,NULL,'https://img.lazcdn.com/g/p/f6e3792965cd962a40e3ef7dfc07c605.jpg_720x720q80.jpg',NULL,0,0),(115,212,NULL,'https://product.hstatic.net/1000075554/product/9460c38f30ccd4928ddd_b4132579e54b40b8ab58b0f2666221e4_c711a95222af4888b2e684edddb2500d_master.jpg',NULL,1,0),(116,212,NULL,'https://bizweb.dktcdn.net/100/287/440/products/ao-thun-nu-form-rong-tay-lo-3-acb92174-46f9-4781-bc5b-a084b1772cea.jpg?v=1622792317307',NULL,0,0),(117,213,NULL,'https://down-vn.img.susercontent.com/file/f8fcb87f54dd698447a9f1375bd22ac4',NULL,1,0),(118,213,NULL,'https://cache.maydep.vn/wp-content/uploads/2022/01/ao-so-mi-dong-phuc-nu-vai-lua.jpg',NULL,0,0),(119,214,NULL,'https://cdn.kkfashion.vn/9820-home_default/ao-croptop-tay-phong-mau-den-asm06-10.jpg',NULL,1,0),(120,214,NULL,'https://dosi-in.com/images/detailed/409/dosiin-fiin-ao-croptop-tay-phong-co-vuong-mau-tron-kieu-han-quoc-xinh-xan-cho-nu-form-rong-made-409631.jpg',NULL,0,0),(121,215,NULL,'https://m.media-amazon.com/images/I/61sC0yq4TaL._AC_UL1500_.jpg',NULL,1,0),(122,215,NULL,'https://salt.tikicdn.com/cache/w300/ts/product/45/a7/8d/53aa40a18ba18bd40efcc43355bda7f8.jpg',NULL,0,0),(123,216,NULL,'https://airui.store/wp-content/uploads/2023/12/Ao-Cardigan-Len-Nu-Dinh-Hoa-No-Mau-Trang-Be-Ao-Khoac-Len-Hang-Dep.jpg',NULL,1,0),(124,216,NULL,'https://airui.store/wp-content/uploads/2023/12/Ao-Cardigan-Len-Nu-Tui-Gau-Trang-Be-Ao-Khoac-Len-Hang-Dep.jpg',NULL,0,0),(125,217,NULL,'https://bizweb.dktcdn.net/100/484/513/products/b47934d387842cda7595.jpg?v=1714290125787',NULL,1,0),(126,217,NULL,'https://cdn.kkfashion.vn/24708-large_default/quan-jeans-dai-lung-cao-ong-loe-mau-den-qj-10.jpg',NULL,0,0),(127,218,NULL,'https://pos.nvncdn.com/d0f3ca-7136/ps/20240911_yFTGsCX5D1.jpeg',NULL,1,0),(128,218,NULL,'https://down-vn.img.susercontent.com/file/vn-11134201-23030-v0kixvlg9uov2d',NULL,0,0),(129,219,NULL,'https://salt.tikicdn.com/ts/product/a6/f2/7f/19276df6361713a219f18c7507ec74ad.jpg',NULL,1,0),(130,219,NULL,'https://vn-live-01.slatic.net/p/8a333daa8fdd139ebbeba0484576d603.jpg',NULL,0,0),(131,220,NULL,'https://img.lazcdn.com/g/p/00e36b5cc7acff00e9db8d97c8d45780.jpg_720x720q80.jpg',NULL,1,0),(132,220,NULL,'https://bizweb.dktcdn.net/100/422/076/products/z6067499164890-e77feaa745b98efca173ce2ad4864039.jpg?v=1732523012753',NULL,0,0),(133,221,NULL,'https://product.hstatic.net/200000788335/product/dav.0181-mo1_054c9f9aa1304904b4379b329e9e5652_master.jpg',NULL,1,0),(134,221,NULL,'https://thoitrangnuhoang.com/data/Product/z3590473691163_ea0dc85af12d6224e3e53827bcbbd927_1658644449.jpg',NULL,0,0),(135,222,NULL,'https://htsport.vn/wp-content/uploads/2021/12/quan-tap-gym-yoga-nu-poly-khong-tui-QG02.jpg',NULL,1,0),(136,222,NULL,'https://fitme.vn/cdn/shop/files/quan-legging-nu-tap-gym-co-tui-an-theta-qdtt-den_3.jpg?v=1710225312&width=2048',NULL,0,0),(137,223,NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMgPXAT34XuoWh2gXuDBXGUfqUCsfN_KgAdA&s',NULL,1,0),(138,223,NULL,'https://bizweb.dktcdn.net/100/509/297/products/2-xanh-duong.jpg?v=1725873125720',NULL,0,0),(139,224,NULL,'https://supersports.com.vn/cdn/shop/files/8-134710001-1_1200x1200.jpg?v=1691402716',NULL,1,0),(140,224,NULL,'https://product.hstatic.net/200000642151/product/wo-ss24s-swi004__3__6c539eba2e5841389356b2eb889aa210_master.jpg',NULL,0,0),(141,225,NULL,'https://yeepvn.sgp1.digitaloceanspaces.com/2023/04/5445760f3dafaaf84cbb0999dd32d269.jpg',NULL,1,0),(142,225,NULL,'https://product.hstatic.net/1000308345/product/img_2108_d9dc647ef3b24c649b5d1efdfbf39d5c_master.jpg',NULL,0,0),(143,226,NULL,'https://cdn0199.cdn4s.com/media/cd9731b5125acb04924b.jpg',NULL,1,0),(144,226,NULL,'https://ann.com.vn/wp-content/uploads/22118-clean-bia-ak077.png',NULL,0,0),(145,227,NULL,'https://vuadasaigon.com/images/detailed/5/vi_da_bo_may_thu_cong_vd80_3.jpg',NULL,1,0),(146,227,NULL,'https://www.gento.vn/wp-content/uploads/2022/09/vi-nam-da-bo-2-600x600.jpg',NULL,0,0),(147,228,NULL,'https://product.hstatic.net/1000355922/product/giay-da-nam-cong-so-ngoai-co-4382045__5__61ce577b6d28424bb853106ba1ff457a_master.jpg',NULL,1,0),(148,228,NULL,'https://cdn.shopify.com/s/files/1/1404/4249/files/23112018-giay-tay-nam-dong-hai-G0703d_grande.JPG?v=1542961434',NULL,0,0),(149,229,NULL,'https://zerdio.com.vn/wp-content/uploads/2020/07/non-ket-nam-den-2.jpg',NULL,1,0),(150,229,NULL,'https://zerdio.com.vn/wp-content/uploads/2020/12/mu-luoi-trai-den-tron-9-247x247.jpg',NULL,0,0),(151,230,NULL,'https://gubag.vn/wp-content/uploads/2022/10/balo-dung-laptop-17-inch-chong-nuoc-cao-cap-gb-bl57-2-1.webp',NULL,1,0),(152,230,NULL,'https://zongvietnam.com/wp-content/uploads/2023/10/balo-laptop-du-lich-phuot-chong-tham-nuoc-tangcool-705-14-156-inch.jpg',NULL,0,0),(153,231,NULL,'https://desmonshop.com/wp-content/uploads/2021/10/photo_2021-10-28_01-09-08-2.jpg',NULL,1,0),(154,231,NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStPCAqYGbSXR11XHlnKMsgqN8EkUFNhD9gUw&s',NULL,0,0),(155,232,NULL,'https://bizweb.dktcdn.net/100/460/898/products/1-a49b2a2e-8e05-4d5d-ad35-1e9bee4ac959.png?v=1712463597310',NULL,1,0),(156,232,NULL,'https://pos.nvncdn.com/cba2a3-7534/ps/20240701_VKbpZRjPmC.jpeg?v=1719843719',NULL,0,0),(157,233,NULL,'https://www.gento.vn/wp-content/uploads/2021/10/day-lung-nam-da-that-D40197.jpg',NULL,1,0),(158,233,NULL,'https://lavatino.com/wp-content/uploads/2020/01/That-lung-da-bo-cong-so-TINO-04-D02-TRANG-3-1-1000x1000-1.jpg',NULL,0,0);
/*!40000 ALTER TABLE `hinhanhsanpham` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `khuyenmai`
--

DROP TABLE IF EXISTS `khuyenmai`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `khuyenmai` (
  `MaKhuyenMai` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `TenKhuyenMai` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `LoaiGiamGia` enum('PHANTRAM','SOTIEN') COLLATE utf8mb4_general_ci NOT NULL,
  `GiaTriGiam` decimal(10,2) NOT NULL,
  `ApDungToiThieu` decimal(10,2) DEFAULT '0.00',
  `DanhMucID` int DEFAULT NULL,
  `SanPhamID` int DEFAULT NULL,
  `NgayBatDau` datetime NOT NULL,
  `NgayKetThuc` datetime NOT NULL,
  `SoLuongToiDa` int DEFAULT '0',
  `TrangThai` enum('ACTIVE','INACTIVE') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`MaKhuyenMai`),
  KEY `DanhMucID` (`DanhMucID`),
  KEY `SanPhamID` (`SanPhamID`),
  CONSTRAINT `khuyenmai_ibfk_1` FOREIGN KEY (`DanhMucID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE SET NULL,
  CONSTRAINT `khuyenmai_ibfk_2` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE SET NULL,
  CONSTRAINT `khuyenmai_chk_1` CHECK ((`GiaTriGiam` >= 0)),
  CONSTRAINT `khuyenmai_chk_2` CHECK ((`ApDungToiThieu` >= 0)),
  CONSTRAINT `khuyenmai_chk_3` CHECK ((`SoLuongToiDa` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `khuyenmai`
--

LOCK TABLES `khuyenmai` WRITE;
/*!40000 ALTER TABLE `khuyenmai` DISABLE KEYS */;
INSERT INTO `khuyenmai` VALUES ('Sale10k','Sale 10k cho áo thun nữ form rộng','SOTIEN',10000.00,50000.00,NULL,212,'2025-12-11 07:00:00','2025-12-31 07:00:00',10,'ACTIVE'),('Sale50K','Sale lớn cuối năm 2025','SOTIEN',50000.00,100000.00,NULL,NULL,'2025-12-11 07:00:00','2025-12-31 07:00:00',10,'ACTIVE'),('SaleDoNam30K','Sale 30k cho sản phẩm đồ nam','SOTIEN',30000.00,150000.00,401,NULL,'2025-12-11 07:00:00','2025-12-31 07:00:00',100,'ACTIVE');
/*!40000 ALTER TABLE `khuyenmai` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lichsudonhang`
--

DROP TABLE IF EXISTS `lichsudonhang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lichsudonhang` (
  `LichSuID` int NOT NULL AUTO_INCREMENT,
  `DonHangID` int NOT NULL,
  `TrangThaiCu` enum('CHUA_THANH_TOAN','DANG_XU_LY','DANG_GIAO','DA_GIAO','DA_HUY','DOI_TRA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TrangThaiMoi` enum('CHUA_THANH_TOAN','DANG_XU_LY','DANG_GIAO','DA_GIAO','DA_HUY','DOI_TRA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ThoiGian` datetime DEFAULT CURRENT_TIMESTAMP,
  `GhiChu` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`LichSuID`),
  KEY `DonHangID` (`DonHangID`),
  CONSTRAINT `lichsudonhang_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lichsudonhang`
--

LOCK TABLES `lichsudonhang` WRITE;
/*!40000 ALTER TABLE `lichsudonhang` DISABLE KEYS */;
INSERT INTO `lichsudonhang` VALUES (1,1051,NULL,'DANG_XU_LY','2024-01-26 15:02:16','Đơn hàng mới được tạo'),(2,1051,'DANG_XU_LY','DANG_GIAO','2024-01-27 09:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(3,1051,'DANG_GIAO','DA_GIAO','2024-01-29 14:30:00','Giao hàng thành công'),(4,1052,NULL,'DANG_XU_LY','2024-01-08 19:40:08','Đơn hàng mới được tạo'),(5,1052,'DANG_XU_LY','DANG_GIAO','2024-01-09 08:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(6,1052,'DANG_GIAO','DA_GIAO','2024-01-11 16:15:00','Giao hàng thành công'),(7,1053,NULL,'DANG_XU_LY','2024-01-01 19:07:35','Đơn hàng mới được tạo'),(8,1053,'DANG_XU_LY','DANG_GIAO','2024-01-02 10:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(9,1053,'DANG_GIAO','DA_GIAO','2024-01-04 15:45:00','Giao hàng thành công'),(10,1054,NULL,'DANG_XU_LY','2024-02-09 20:25:22','Đơn hàng mới được tạo'),(11,1054,'DANG_XU_LY','DANG_GIAO','2024-02-10 09:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(12,1054,'DANG_GIAO','DA_GIAO','2024-02-13 11:20:00','Giao hàng thành công'),(13,1055,NULL,'DANG_XU_LY','2024-02-12 11:47:04','Đơn hàng mới được tạo'),(14,1055,'DANG_XU_LY','DANG_GIAO','2024-02-13 08:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(15,1055,'DANG_GIAO','DA_GIAO','2024-02-15 14:10:00','Giao hàng thành công'),(16,1056,NULL,'DANG_XU_LY','2024-02-28 11:39:19','Đơn hàng mới được tạo'),(17,1056,'DANG_XU_LY','DANG_GIAO','2024-02-29 10:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(18,1056,'DANG_GIAO','DA_GIAO','2024-03-03 16:50:00','Giao hàng thành công'),(19,1057,NULL,'DANG_XU_LY','2024-02-04 15:47:49','Đơn hàng mới được tạo'),(20,1057,'DANG_XU_LY','DANG_GIAO','2024-02-05 09:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(21,1057,'DANG_GIAO','DA_GIAO','2024-02-08 13:40:00','Giao hàng thành công'),(22,1058,NULL,'DANG_XU_LY','2024-03-03 12:47:20','Đơn hàng mới được tạo'),(23,1058,'DANG_XU_LY','DANG_GIAO','2024-03-04 08:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(24,1058,'DANG_GIAO','DA_GIAO','2024-03-06 17:20:00','Giao hàng thành công'),(25,1059,NULL,'DANG_XU_LY','2024-03-24 16:11:43','Đơn hàng mới được tạo'),(26,1059,'DANG_XU_LY','DANG_GIAO','2024-03-25 11:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(27,1059,'DANG_GIAO','DA_GIAO','2024-03-28 10:30:00','Giao hàng thành công'),(28,1060,NULL,'DANG_XU_LY','2024-04-11 15:52:16','Đơn hàng mới được tạo'),(29,1060,'DANG_XU_LY','DANG_GIAO','2024-04-12 09:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(30,1060,'DANG_GIAO','DA_GIAO','2024-04-15 15:10:00','Giao hàng thành công'),(31,1061,NULL,'DANG_XU_LY','2024-04-03 09:35:10','Đơn hàng mới được tạo'),(32,1061,'DANG_XU_LY','DANG_GIAO','2024-04-04 08:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(33,1061,'DANG_GIAO','DA_GIAO','2024-04-07 14:25:00','Giao hàng thành công'),(34,1062,NULL,'DANG_XU_LY','2024-05-18 10:48:58','Đơn hàng mới được tạo'),(35,1062,'DANG_XU_LY','DANG_GIAO','2024-05-19 09:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(36,1062,'DANG_GIAO','DA_GIAO','2024-05-22 16:00:00','Giao hàng thành công'),(37,1063,NULL,'DANG_XU_LY','2024-05-13 19:26:01','Đơn hàng mới được tạo'),(38,1063,'DANG_XU_LY','DANG_GIAO','2024-05-14 10:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(39,1063,'DANG_GIAO','DA_GIAO','2024-05-16 11:30:00','Giao hàng thành công'),(40,1064,NULL,'DANG_XU_LY','2024-05-24 17:09:50','Đơn hàng mới được tạo'),(41,1064,'DANG_XU_LY','DANG_GIAO','2024-05-25 08:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(42,1064,'DANG_GIAO','DA_GIAO','2024-05-28 15:20:00','Giao hàng thành công'),(43,1065,NULL,'DANG_XU_LY','2024-06-25 15:15:35','Đơn hàng mới được tạo'),(44,1065,'DANG_XU_LY','DANG_GIAO','2024-06-26 09:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(45,1065,'DANG_GIAO','DA_GIAO','2024-06-29 13:45:00','Giao hàng thành công'),(46,1066,NULL,'DANG_XU_LY','2024-06-03 09:21:49','Đơn hàng mới được tạo'),(47,1066,'DANG_XU_LY','DANG_GIAO','2024-06-04 08:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(48,1066,'DANG_GIAO','DA_GIAO','2024-06-07 16:10:00','Giao hàng thành công'),(49,1067,NULL,'DANG_XU_LY','2024-06-18 17:34:02','Đơn hàng mới được tạo'),(50,1067,'DANG_XU_LY','DANG_GIAO','2024-06-19 10:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(51,1067,'DANG_GIAO','DA_GIAO','2024-06-22 14:00:00','Giao hàng thành công'),(52,1068,NULL,'DANG_XU_LY','2024-07-06 21:05:07','Đơn hàng mới được tạo'),(53,1068,'DANG_XU_LY','DANG_GIAO','2024-07-07 09:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(54,1068,'DANG_GIAO','DA_GIAO','2024-07-09 11:50:00','Giao hàng thành công'),(55,1069,NULL,'DANG_XU_LY','2024-07-02 12:44:59','Đơn hàng mới được tạo'),(56,1069,'DANG_XU_LY','DANG_GIAO','2024-07-03 08:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(57,1069,'DANG_GIAO','DA_GIAO','2024-07-06 15:40:00','Giao hàng thành công'),(58,1070,NULL,'DANG_XU_LY','2024-08-01 17:09:47','Đơn hàng mới được tạo'),(59,1070,'DANG_XU_LY','DANG_GIAO','2024-08-02 10:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(60,1070,'DANG_GIAO','DA_GIAO','2024-08-05 13:25:00','Giao hàng thành công'),(61,1071,NULL,'DANG_XU_LY','2024-08-10 18:31:38','Đơn hàng mới được tạo'),(62,1071,'DANG_XU_LY','DANG_GIAO','2024-08-11 09:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(63,1071,'DANG_GIAO','DA_GIAO','2024-08-14 16:15:00','Giao hàng thành công'),(64,1072,NULL,'DANG_XU_LY','2024-08-01 19:16:16','Đơn hàng mới được tạo'),(65,1072,'DANG_XU_LY','DANG_GIAO','2024-08-02 08:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(66,1072,'DANG_GIAO','DA_GIAO','2024-08-05 11:00:00','Giao hàng thành công'),(67,1073,NULL,'DANG_XU_LY','2024-09-02 10:14:14','Đơn hàng mới được tạo'),(68,1073,'DANG_XU_LY','DANG_GIAO','2024-09-03 09:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(69,1073,'DANG_GIAO','DA_GIAO','2024-09-06 14:30:00','Giao hàng thành công'),(70,1074,NULL,'DANG_XU_LY','2024-09-07 19:12:48','Đơn hàng mới được tạo'),(71,1074,'DANG_XU_LY','DANG_GIAO','2024-09-08 10:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(72,1074,'DANG_GIAO','DA_GIAO','2024-09-11 15:50:00','Giao hàng thành công'),(73,1075,NULL,'DANG_XU_LY','2024-10-25 10:20:13','Đơn hàng mới được tạo'),(74,1075,'DANG_XU_LY','DANG_GIAO','2024-10-26 08:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(75,1075,'DANG_GIAO','DA_GIAO','2024-10-29 12:15:00','Giao hàng thành công'),(76,1076,NULL,'DANG_XU_LY','2024-10-06 14:12:35','Đơn hàng mới được tạo'),(77,1076,'DANG_XU_LY','DANG_GIAO','2024-10-07 09:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(78,1076,'DANG_GIAO','DA_GIAO','2024-10-10 16:40:00','Giao hàng thành công'),(79,1077,NULL,'DANG_XU_LY','2024-11-06 13:58:14','Đơn hàng mới được tạo'),(80,1077,'DANG_XU_LY','DANG_GIAO','2024-11-07 08:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(81,1077,'DANG_GIAO','DA_GIAO','2024-11-10 14:20:00','Giao hàng thành công'),(82,1078,NULL,'DANG_XU_LY','2024-11-08 17:34:04','Đơn hàng mới được tạo'),(83,1078,'DANG_XU_LY','DANG_GIAO','2024-11-09 10:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(84,1078,'DANG_GIAO','DA_GIAO','2024-11-12 15:30:00','Giao hàng thành công'),(85,1079,NULL,'DANG_XU_LY','2024-11-17 19:54:19','Đơn hàng mới được tạo'),(86,1079,'DANG_XU_LY','DANG_GIAO','2024-11-18 09:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(87,1079,'DANG_GIAO','DA_GIAO','2024-11-21 16:50:00','Giao hàng thành công'),(88,1080,NULL,'DANG_XU_LY','2024-12-09 20:07:05','Đơn hàng mới được tạo'),(89,1080,'DANG_XU_LY','DANG_GIAO','2024-12-10 08:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(90,1080,'DANG_GIAO','DA_GIAO','2024-12-13 13:10:00','Giao hàng thành công'),(91,1081,NULL,'DANG_XU_LY','2024-12-05 13:58:14','Đơn hàng mới được tạo'),(92,1081,'DANG_XU_LY','DANG_GIAO','2024-12-06 09:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(93,1081,'DANG_GIAO','DA_GIAO','2024-12-08 15:45:00','Giao hàng thành công'),(94,1082,NULL,'DANG_XU_LY','2024-12-07 10:14:14','Đơn hàng mới được tạo'),(95,1082,'DANG_XU_LY','DANG_GIAO','2024-12-08 08:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(96,1082,'DANG_GIAO','DA_GIAO','2024-12-11 11:20:00','Giao hàng thành công'),(97,1083,NULL,'DANG_XU_LY','2025-01-26 15:47:33','Đơn hàng mới được tạo'),(98,1083,'DANG_XU_LY','DANG_GIAO','2025-01-27 09:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(99,1083,'DANG_GIAO','DA_GIAO','2025-01-30 14:15:00','Giao hàng thành công'),(100,1084,NULL,'DANG_XU_LY','2025-01-15 13:50:51','Đơn hàng mới được tạo'),(101,1084,'DANG_XU_LY','DANG_GIAO','2025-01-16 08:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(102,1084,'DANG_GIAO','DA_GIAO','2025-01-19 16:30:00','Giao hàng thành công'),(103,1085,NULL,'DANG_XU_LY','2025-01-07 16:51:30','Đơn hàng mới được tạo'),(104,1085,'DANG_XU_LY','DANG_GIAO','2025-01-08 10:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(105,1085,'DANG_GIAO','DA_GIAO','2025-01-11 13:20:00','Giao hàng thành công'),(106,1086,NULL,'DANG_XU_LY','2025-02-12 11:25:22','Đơn hàng mới được tạo'),(107,1086,'DANG_XU_LY','DANG_GIAO','2025-02-13 09:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(108,1086,'DANG_GIAO','DA_GIAO','2025-02-16 15:40:00','Giao hàng thành công'),(109,1087,NULL,'DANG_XU_LY','2025-02-18 20:07:05','Đơn hàng mới được tạo'),(110,1087,'DANG_XU_LY','DANG_GIAO','2025-02-19 08:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(111,1087,'DANG_GIAO','DA_GIAO','2025-02-22 14:50:00','Giao hàng thành công'),(112,1088,NULL,'DANG_XU_LY','2025-02-09 20:46:17','Đơn hàng mới được tạo'),(113,1088,'DANG_XU_LY','DANG_GIAO','2025-02-10 10:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(114,1088,'DANG_GIAO','DA_GIAO','2025-02-13 16:10:00','Giao hàng thành công'),(115,1089,NULL,'DANG_XU_LY','2025-03-24 16:54:19','Đơn hàng mới được tạo'),(116,1089,'DANG_XU_LY','DANG_GIAO','2025-03-25 09:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(117,1089,'DANG_GIAO','DA_GIAO','2025-03-28 13:45:00','Giao hàng thành công'),(118,1090,NULL,'DANG_XU_LY','2025-03-12 18:04:15','Đơn hàng mới được tạo'),(119,1090,'DANG_XU_LY','DANG_GIAO','2025-03-13 08:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(120,1090,'DANG_GIAO','DA_GIAO','2025-03-16 15:30:00','Giao hàng thành công'),(121,1091,NULL,'DANG_XU_LY','2025-03-03 14:45:07','Đơn hàng mới được tạo'),(122,1091,'DANG_XU_LY','DANG_GIAO','2025-03-04 10:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(123,1091,'DANG_GIAO','DA_GIAO','2025-03-07 14:20:00','Giao hàng thành công'),(124,1092,NULL,'DANG_XU_LY','2025-04-18 10:25:29','Đơn hàng mới được tạo'),(125,1092,'DANG_XU_LY','DANG_GIAO','2025-04-19 09:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(126,1092,'DANG_GIAO','DA_GIAO','2025-04-22 16:40:00','Giao hàng thành công'),(127,1093,NULL,'DANG_XU_LY','2025-04-15 13:58:14','Đơn hàng mới được tạo'),(128,1093,'DANG_XU_LY','DANG_GIAO','2025-04-16 08:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(129,1093,'DANG_GIAO','DA_GIAO','2025-04-19 13:10:00','Giao hàng thành công'),(130,1094,NULL,'DANG_XU_LY','2025-05-18 16:11:41','Đơn hàng mới được tạo'),(131,1094,'DANG_XU_LY','DANG_GIAO','2025-05-19 10:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(132,1094,'DANG_GIAO','DA_GIAO','2025-05-22 15:25:00','Giao hàng thành công'),(133,1095,NULL,'DANG_XU_LY','2025-05-02 12:44:59','Đơn hàng mới được tạo'),(134,1095,'DANG_XU_LY','DANG_GIAO','2025-05-03 08:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(135,1095,'DANG_GIAO','DA_GIAO','2025-05-06 14:15:00','Giao hàng thành công'),(136,1096,NULL,'DANG_XU_LY','2025-05-18 10:48:58','Đơn hàng mới được tạo'),(137,1096,'DANG_XU_LY','DANG_GIAO','2025-05-19 09:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(138,1096,'DANG_GIAO','DA_GIAO','2025-05-22 16:50:00','Giao hàng thành công'),(139,1097,NULL,'DANG_XU_LY','2025-06-25 15:15:35','Đơn hàng mới được tạo'),(140,1097,'DANG_XU_LY','DANG_GIAO','2025-06-26 08:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(141,1097,'DANG_GIAO','DA_GIAO','2025-06-29 13:40:00','Giao hàng thành công'),(142,1098,NULL,'DANG_XU_LY','2025-06-05 13:00:15','Đơn hàng mới được tạo'),(143,1098,'DANG_XU_LY','DANG_GIAO','2025-06-06 10:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(144,1098,'DANG_GIAO','DA_GIAO','2025-06-09 15:20:00','Giao hàng thành công'),(145,1099,NULL,'DANG_XU_LY','2025-07-26 12:59:06','Đơn hàng mới được tạo'),(146,1099,'DANG_XU_LY','DANG_GIAO','2025-07-27 09:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(147,1099,'DANG_GIAO','DA_GIAO','2025-07-30 14:10:00','Giao hàng thành công'),(148,1100,NULL,'DANG_XU_LY','2025-07-16 11:29:43','Đơn hàng mới được tạo'),(149,1100,'DANG_XU_LY','DANG_GIAO','2025-07-17 08:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(150,1100,'DANG_GIAO','DA_GIAO','2025-07-20 16:30:00','Giao hàng thành công'),(151,1101,NULL,'DANG_XU_LY','2025-07-07 19:40:48','Đơn hàng mới được tạo'),(152,1101,'DANG_XU_LY','DANG_GIAO','2025-07-08 10:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(153,1101,'DANG_GIAO','DA_GIAO','2025-07-11 15:45:00','Giao hàng thành công'),(154,1102,NULL,'DANG_XU_LY','2025-08-05 13:00:15','Đơn hàng mới được tạo'),(155,1102,'DANG_XU_LY','DANG_GIAO','2025-08-06 09:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(156,1102,'DANG_GIAO','DA_GIAO','2025-08-09 13:25:00','Giao hàng thành công'),(157,1103,NULL,'DANG_XU_LY','2025-08-11 11:21:52','Đơn hàng mới được tạo'),(158,1103,'DANG_XU_LY','DANG_GIAO','2025-08-12 08:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(159,1103,'DANG_GIAO','DA_GIAO','2025-08-15 14:50:00','Giao hàng thành công'),(160,1104,NULL,'DANG_XU_LY','2025-08-20 09:25:27','Đơn hàng mới được tạo'),(161,1104,'DANG_XU_LY','DANG_GIAO','2025-08-21 10:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(162,1104,'DANG_GIAO','DA_GIAO','2025-08-24 16:10:00','Giao hàng thành công'),(163,1105,NULL,'DANG_XU_LY','2025-09-02 21:04:15','Đơn hàng mới được tạo'),(164,1105,'DANG_XU_LY','DANG_GIAO','2025-09-03 08:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(165,1105,'DANG_GIAO','DA_GIAO','2025-09-06 13:30:00','Giao hàng thành công'),(166,1106,NULL,'DANG_XU_LY','2025-09-20 12:13:32','Đơn hàng mới được tạo'),(167,1106,'DANG_XU_LY','DANG_GIAO','2025-09-21 09:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(168,1106,'DANG_GIAO','DA_GIAO','2025-09-24 15:15:00','Giao hàng thành công'),(169,1107,NULL,'DANG_XU_LY','2025-09-21 16:32:20','Đơn hàng mới được tạo'),(170,1107,'DANG_XU_LY','DANG_GIAO','2025-09-22 10:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(171,1107,'DANG_GIAO','DA_GIAO','2025-09-25 14:00:00','Giao hàng thành công'),(172,1108,NULL,'DANG_XU_LY','2025-10-27 09:44:41','Đơn hàng mới được tạo'),(173,1108,'DANG_XU_LY','DANG_GIAO','2025-10-28 08:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(174,1108,'DANG_GIAO','DA_GIAO','2025-10-31 16:30:00','Giao hàng thành công'),(175,1109,NULL,'DANG_XU_LY','2025-10-06 08:55:06','Đơn hàng mới được tạo'),(176,1109,'DANG_XU_LY','DANG_GIAO','2025-10-07 09:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(177,1109,'DANG_GIAO','DA_GIAO','2025-10-10 13:40:00','Giao hàng thành công'),(178,1110,NULL,'DANG_XU_LY','2025-11-20 18:03:00','Đơn hàng mới được tạo'),(179,1110,'DANG_XU_LY','DANG_GIAO','2025-11-21 10:15:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(180,1110,'DANG_GIAO','DA_GIAO','2025-11-24 15:25:00','Giao hàng thành công'),(181,1111,NULL,'DANG_XU_LY','2025-11-06 17:34:39','Đơn hàng mới được tạo'),(182,1111,'DANG_XU_LY','DANG_GIAO','2025-11-07 08:45:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(183,1111,'DANG_GIAO','DA_GIAO','2025-11-10 14:10:00','Giao hàng thành công'),(184,1112,NULL,'DANG_XU_LY','2025-11-08 17:34:04','Đơn hàng mới được tạo'),(185,1112,'DANG_XU_LY','DANG_GIAO','2025-11-09 09:30:00','Đơn hàng đã được giao cho đơn vị vận chuyển'),(186,1112,'DANG_GIAO','DA_GIAO','2025-11-12 16:20:00','Giao hàng thành công'),(187,1113,NULL,'DANG_XU_LY','2025-12-11 12:12:35','Đơn hàng mới được tạo'),(188,1114,NULL,'DANG_XU_LY','2025-12-07 10:14:14','Đơn hàng mới được tạo'),(189,1115,NULL,'DANG_XU_LY','2025-12-11 11:21:52','Đơn hàng mới được tạo'),(190,1115,'DANG_XU_LY','DANG_GIAO','2025-12-11 13:00:00','Đơn hàng đã được giao cho đơn vị vận chuyển');
/*!40000 ALTER TABLE `lichsudonhang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nguoidung`
--

DROP TABLE IF EXISTS `nguoidung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nguoidung` (
  `NguoiDungID` int NOT NULL AUTO_INCREMENT,
  `Email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `GoogleID` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MatKhauHash` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `LoaiXacThuc` enum('LOCAL','GOOGLE') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'LOCAL',
  `HoTen` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `DienThoai` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NgaySinh` date DEFAULT NULL,
  `GioiTinh` enum('Nam','Nu','Khac') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `VaiTro` enum('KHACHHANG','ADMIN') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'KHACHHANG',
  `TrangThai` enum('ACTIVE','INACTIVE') COLLATE utf8mb4_general_ci DEFAULT 'ACTIVE',
  `MatKhauResetToken` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `MatKhauResetTokenExpires` datetime DEFAULT NULL,
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`NguoiDungID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `GoogleID` (`GoogleID`),
  KEY `idx_email` (`Email`),
  KEY `idx_google_id` (`GoogleID`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nguoidung`
--

LOCK TABLES `nguoidung` WRITE;
/*!40000 ALTER TABLE `nguoidung` DISABLE KEYS */;
INSERT INTO `nguoidung` VALUES (4,'admin@gmail.com',NULL,'$2b$10$zFfCAFMhVTzxiEAwZxysOuR9cTBAOS67ZHUoa8zcf573L6dwfsswy','LOCAL','Quản Trị Viên','1234567890','2004-01-29','Nam','ADMIN','ACTIVE',NULL,NULL,'2025-11-01 15:47:44'),(21,'An@gmail.com',NULL,'$2b$10$WheB8hnbBg0TeFWO21OKMOgydxwwuBK3Yodz/.udBxu5Nz4p3Lxru','LOCAL','Nguyen An',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 11:59:27'),(22,'Binh@gmail.com',NULL,'$2b$10$dQd1szCMTjjbH/W1pWT1h.AmZY07DtwMDEur7X767XXk.aJ860YIC','LOCAL','Tran Binh',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 11:59:48'),(23,'Chi@gmail.com',NULL,'$2b$10$rAhXg.f809K669pd2lD2rewpSZRnvoEigJAWX2ZFeiuGkjcvS.pfa','LOCAL','Le Chi',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:00:12'),(24,'Dung@gmail.com',NULL,'$2b$10$iBPJzuY6gEF0hKPX6VvhI.nMbgCEgBFXbS4V/Ap2XMfjfA0iI4pAi','LOCAL','Pham Dung',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:00:28'),(25,'Huy@gmail.com',NULL,'$2b$10$JgRWCjeuBXWDRsMWqNgq6.1QLFvzFcd5Ewu4C6FGlyoIezLulhjZi','LOCAL','Hoang Huy',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:00:43'),(26,'Khoa@gmail.com',NULL,'$2b$10$d1SV3StMrIEJwX7P3h.V7eaaaVjZ8Hw5DAw5PHqPsUuIr2F5a8ib.','LOCAL','Vo Khoa',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:01:03'),(27,'Long@gmail.com',NULL,'$2b$10$ng0ULNusol9iLk4F4CRMWeCi72nzZrnIUcVv/./yHSXk4l3yHJAtS','LOCAL','Phan Long',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:01:23'),(28,'Minh@gmail.com',NULL,'$2b$10$u0a2CTRNLKCYLpIVJEFnDO0dyzhrZ8EtxpUi3Ez974oK3aBbMfVYu','LOCAL','Dang Minh',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:01:40'),(29,'Nam@gmail.com',NULL,'$2b$10$0G.TxdidsasCkfCxuIPhGuYjT/VrJ7RIQ8L.HCoLY.S60aKIp6nHy','LOCAL','Bui Nam',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:01:57'),(30,'Phong@gmail.com',NULL,'$2b$10$7158b38uQcYmsgEIl3ZsQ.xfKvYcMZCIKiBriq1y3ik8ThreVy4gq','LOCAL','Ngo Phong',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:02:13'),(31,'Quang@gmail.com',NULL,'$2b$10$5Pwi4WTM3wfT/BxLKh3pJukrH9xdgP4Y67ujBaR.3M6G4AMqGnFxG','LOCAL','Truong Quang',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:02:31'),(32,'Sang@gmail.com',NULL,'$2b$10$L83bqrk0mtWflUB.rq9XBOk3hOzeEpBIBBNb9RwgH3u2Fd/CdVaMu','LOCAL','Ly Sang',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:02:47'),(33,'Tam@gmail.com',NULL,'$2b$10$NRZqBxQfTb02HKZOlXQ/uOS7p51ZwceJfrNnSJEa4yKsN3yYvlYZu','LOCAL','Do Tam',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:03:02'),(34,'Trang@gmail.com',NULL,'$2b$10$C.S.1TaQQWvtDgyWhw2Oiu1K3aBnfSicwmFvCFl4abicwspOTDSmy','LOCAL','Nguyen Trang',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:03:21'),(35,'Thanh@gmail.com',NULL,'$2b$10$jdY08Nhpvj0Hc5x1v7MmyeqL1QcgjI0/AiHdbTPEf7zJp/nMIP7OO','LOCAL','Tran Thanh',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:03:38'),(36,'Thao@gmail.com',NULL,'$2b$10$EaLVQkt3AdMXfkW4ILKBlepEngax5J0lo2i3Ru9phCtBU3wRBInz.','LOCAL','Le Thao',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:03:56'),(37,'Tien@gmail.com',NULL,'$2b$10$VEyZkr5kClIT54.o7gL6qeVW9ckoTnjo5xggSsvsWgjkAQjNUiQiW','LOCAL','Pham Tien',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:04:17'),(38,'Truc@gmail.com',NULL,'$2b$10$RMr0S9V2zyH9ytD8HEdY.OpHq2TbS8GX.h2ZxL/1QCFq3MFWU75wm','LOCAL','Hoang Truc',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:04:37'),(39,'Yen@gmail.com',NULL,'$2b$10$cC3VvtYX8wswYrzEqNdh0.dFznf08qJvZ0ho02SnlbO/uAh4x2NFq','LOCAL','Vo Yen',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:04:57'),(40,'Lan@gmail.com',NULL,'$2b$10$iiNHi.qM64vsv5L6l3kw8.rnFNyMcR7jJncsUJ//r/xVxpktR6Wje','LOCAL','Phan Lan',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:05:14'),(41,'Hoang2@gmail.com',NULL,'$2b$10$TfM8/aaIGfBuqg/FnwK26OHi7.ywtTU5YNCw2QnKvhg05xEGTNysW','LOCAL','Dang Hoang',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:05:39'),(42,'Hieu@gmail.com',NULL,'$2b$10$cSnqK79Rq0rV895nysKWguJvNjiqfwPajQfGh8ry4nK8NJdIq9wdK','LOCAL','Bui Hieu',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:05:59'),(43,'Hai@gmail.com',NULL,'$2b$10$BGrxOcgieSofsrs35R9r2uWSRF1FFqV92kEGAaws2RO1uLNNHwTi2','LOCAL','Ngo Hai',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:06:16'),(44,'Han@gmail.com',NULL,'$2b$10$3TYtr5CUyqXB/SjDwNtREuMZLhkCxgxx6.W7plpvxII1jVdd2C1rW','LOCAL','Do Han',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:06:32'),(45,'Hanh@gmail.com',NULL,'$2b$10$NAnXOor3CldZTMyjxVYWOuEJmz3F6VwV8JH3XeG87clmoeQJGQKgS','LOCAL','Nguyen Hanh',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:06:47'),(46,'Ha@gmail.com',NULL,'$2b$10$gnF8rwFusPvjI3s7.mJIk.QL2vOw6nt5zLi4.sDqietZ3pbBy7pvG','LOCAL','Tran Ha',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:07:02'),(47,'My@gmail.com',NULL,'$2b$10$dO7CD6zsKhp8FSVnr9KoR.aIZ0Jx4BwyPy7LWZAxWkUawTy20.9py','LOCAL','Le My',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:07:20'),(48,'Nga@gmail.com',NULL,'$2b$10$W4KdK8Q8sXC2q6guLO7G4eXLiDT4CLmH5H30geME26OV1sxfGDopG','LOCAL','Pham Nga',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:07:42'),(49,'Nhi@gmail.com',NULL,'$2b$10$BdtMOu56nRftrpTfK9LVRuYJm39uk7v863CZxKpK7nEEnhk/e.kAa','LOCAL','Vo Nhi',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:07:59'),(50,'Nhung@gmail.com',NULL,'$2b$10$j20mNF8Hdq5ypKakyX5Y3uCiAVisILf9jxady4XmSE7zCpT1bs70K','LOCAL','Phan Nhung',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:08:15'),(51,'Thinh@gmail.com',NULL,'$2b$10$Z3Gy6Sd8ITcMfcVQXIGI6Ooq.0O86O/NTYgxCwbQHvlCWPKy8Ujbq','LOCAL','Hoang Thinh',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:08:40'),(52,'Truong2@gmail.com',NULL,'$2b$10$HT838AoGjKfwgdIZS5I0jOtDG9XDXPMIJu7AfIYBYX1w2Amds/GFC','LOCAL','Bui Truong',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:08:54'),(53,'Duc@gmail.com',NULL,'$2b$10$/mSzq3Wy4SBfOTN28ZqKkuARaNOr6woZpsWEfDDygStgpjakhEOw2','LOCAL','Ngo Duc',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:09:11'),(54,'Phuc@gmail.com',NULL,'$2b$10$hfbIlrFzq26vwga8KH3vk.OwB6zVxLIPdq5Stbi1i0sY7ge2IEW.e','LOCAL','Do Phuc',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:09:28'),(55,'Khang@gmail.com',NULL,'$2b$10$uqBFhheTQ2oVIOQm9e0qpuaaP5j8bOaGvK/S0zn/qvVIMLVMBYKCq','LOCAL','Nguyen Khang',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:09:44'),(56,'Duy@gmail.com',NULL,'$2b$10$mHZeG0IfktuS3Z.NxqM1ROASNJRCKd35dwjCosdhVDz4ZLPU.Iqd2','LOCAL','Tran Duy',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:09:59'),(57,'Tuan@gmail.com',NULL,'$2b$10$mJeEZAkXq9f4iRDZPyhyg.cPDonOZv1BZfC1kUfyK9zb0SnqRITne','LOCAL','Le Tuan',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:10:14'),(58,'Vi@gmail.com',NULL,'$2b$10$ymW.zDpG/mV3T3B5qZvPteEUipOGv4v4OKZZz8zPX7GUZEhKWcz0K','LOCAL','Pham Vi',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:10:29'),(59,'Vy@gmail.com',NULL,'$2b$10$nb4yQz7wfSRSSGGqXCf3sOt0WnhGa647tWibrOPps6jFIb12OE3vS','LOCAL','Vo Vy',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:10:45'),(60,'Huong@gmail.com',NULL,'$2b$10$nc1uJg2R6rwvhsrJMmX5EO5z7Z.rbn0O72egAJqjA4rNO7hcRnIIK','LOCAL','Phan Huong',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:11:00'),(61,'Linh@gmail.com',NULL,'$2b$10$5.yhNDdzqZO.YxZWkY1e5eJEUmA3j5ziY7PQEkWCOJLU4ljUS9AoC','LOCAL','Dang Linh',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:11:19'),(62,'Mai@gmail.com',NULL,'$2b$10$C2cwGie//fIYKu8bjrs8kO78VogXJLNoakhwzLRMxZEGi7VI5A.lm','LOCAL','Bui Mai',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:11:35'),(63,'Dao@gmail.com',NULL,'$2b$10$ppJwxwabdP4tSivMj.KYN.MDGm6obbsu3gsPSH48PjWh1ooSchItm','LOCAL','Ngo Dao',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:11:50'),(64,'Son@gmail.com',NULL,'$2b$10$sXnWMzcgwqyIq6WdVJiTueJxCde4NqZzu9YDG0rugxZnsvaO8JTOa','LOCAL','Do Son',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:12:09'),(65,'Luan@gmail.com',NULL,'$2b$10$AvYJR8Kia/YNs8iNX8SjD.poaHZtY070TqSiK82FZHNgQgu0XT7EW','LOCAL','Nguyen Luan',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:12:22'),(66,'Giang@gmail.com',NULL,'$2b$10$jNgGtW38CJ3SGbB5EC/xBe5I0372Ym2qCyAiKkx7PHFijJAMsfteG','LOCAL','Tran Giang',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:12:36'),(67,'Phuong@gmail.com',NULL,'$2b$10$NuxUxtma/DMptvVeuEd1ce.5AO81Aib2ex8wZ..dcAsbmzTcTG72G','LOCAL','Le Phuong',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:12:55'),(68,'Uyen@gmail.com',NULL,'$2b$10$LiUA7381LZRbQ26ed.OL0.PGowJ4aS1ZELRBN3W2q8tWBtIol8dGe','LOCAL','Pham Uyen',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:13:11'),(69,'Tinh@gmail.com',NULL,'$2b$10$2ue/pzGyIWDR1GeR69H5NO2spMQmOo.eJoWm2L8PWOpQUZqqC51JK','LOCAL','Vo Tinh',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:13:27'),(70,'Tam2@gmail.com',NULL,'$2b$10$0W6A57GZcCGF6IBkad0CS.qqThEm02kfjspQwbnPm6L7F7RqDh1c6','LOCAL','Phan Tam',NULL,NULL,NULL,'KHACHHANG','ACTIVE',NULL,NULL,'2025-12-11 12:13:44');
/*!40000 ALTER TABLE `nguoidung` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nguoidung_voucher`
--

DROP TABLE IF EXISTS `nguoidung_voucher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nguoidung_voucher` (
  `NguoiDungID` int NOT NULL,
  `MaKhuyenMai` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `NgayNhan` datetime DEFAULT CURRENT_TIMESTAMP,
  `TrangThai` enum('DA_NHAN','DA_SU_DUNG') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DA_NHAN',
  PRIMARY KEY (`NguoiDungID`,`MaKhuyenMai`),
  KEY `MaKhuyenMai` (`MaKhuyenMai`),
  CONSTRAINT `nguoidung_voucher_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE,
  CONSTRAINT `nguoidung_voucher_ibfk_2` FOREIGN KEY (`MaKhuyenMai`) REFERENCES `khuyenmai` (`MaKhuyenMai`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nguoidung_voucher`
--

LOCK TABLES `nguoidung_voucher` WRITE;
/*!40000 ALTER TABLE `nguoidung_voucher` DISABLE KEYS */;
/*!40000 ALTER TABLE `nguoidung_voucher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paymentmethods`
--

DROP TABLE IF EXISTS `paymentmethods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paymentmethods` (
  `MethodID` int NOT NULL AUTO_INCREMENT,
  `TenPhuongThuc` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `MoTa` text COLLATE utf8mb4_general_ci,
  `Active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`MethodID`),
  UNIQUE KEY `TenPhuongThuc` (`TenPhuongThuc`)
) ENGINE=InnoDB AUTO_INCREMENT=705 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paymentmethods`
--

LOCK TABLES `paymentmethods` WRITE;
/*!40000 ALTER TABLE `paymentmethods` DISABLE KEYS */;
INSERT INTO `paymentmethods` VALUES (701,'COD','Thanh toán khi nhận hàng',1),(702,'VNPAY','Thanh toán qua cổng VNPAY',1),(703,'MOMO','Thanh toán qua ví MoMo',1);
/*!40000 ALTER TABLE `paymentmethods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phienbansanpham`
--

DROP TABLE IF EXISTS `phienbansanpham`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phienbansanpham` (
  `PhienBanID` int NOT NULL AUTO_INCREMENT,
  `SanPhamID` int NOT NULL,
  `SKU` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `GiaBan` decimal(10,2) NOT NULL,
  `SoLuongTonKho` int DEFAULT '0',
  PRIMARY KEY (`PhienBanID`),
  UNIQUE KEY `SKU` (`SKU`),
  KEY `idx_phienban_sanpham` (`SanPhamID`),
  CONSTRAINT `phienbansanpham_ibfk_1` FOREIGN KEY (`SanPhamID`) REFERENCES `sanpham` (`SanPhamID`) ON DELETE CASCADE,
  CONSTRAINT `phienbansanpham_chk_1` CHECK ((`GiaBan` >= 0)),
  CONSTRAINT `phienbansanpham_chk_2` CHECK ((`SoLuongTonKho` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5072 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phienbansanpham`
--

LOCK TABLES `phienbansanpham` WRITE;
/*!40000 ALTER TABLE `phienbansanpham` DISABLE KEYS */;
INSERT INTO `phienbansanpham` VALUES (5001,201,'ATCB-S-TRANG',99000.00,198),(5002,201,'ATCB-M-TRANG',99000.00,196),(5003,202,'QJSF-S-XANH',399000.00,200),(5004,203,'ATCT-M-DEN',180000.00,196),(5005,204,'ASMNTD-M-DEN',360000.00,200),(5006,205,'APNVCS-M-DEN',270000.00,186),(5007,206,'AKND-M-DEN',450000.00,197),(5008,207,'AHNNB-M-DEN',405000.00,195),(5009,208,'QJNRG-M-DEN',495000.00,194),(5010,209,'QSNK-M-DEN',225000.00,192),(5012,211,'QTNOD-M-DEN',378000.00,197),(5013,212,'ATNFR-M-DEN',230000.00,193),(5014,213,'ASMNL-M-DEN',324000.00,194),(5015,214,'ACTP-M-DEN',162000.00,195),(5016,215,'AHNTM-M-DEN',432000.00,180),(5017,216,'AKNC-M-DEN',351000.00,198),(5018,217,'QJNOL-M-DEN',468000.00,191),(5019,218,'QSNJ-M-DEN',252000.00,192),(5020,219,'QORNVT-M-DEN',297000.00,189),(5021,220,'CVCA-M-DEN',243000.00,197),(5022,221,'VDMV-M-DEN',540000.00,189),(5023,222,'QLGN-M-DEN',279000.00,189),(5024,223,'QSCB2L-M-DEN',234000.00,190),(5025,224,'DBN1M-M-DEN',405000.00,191),(5026,225,'AKTTCN-M-DEN',270000.00,184),(5027,226,'AKDLB-M-DEN',1350000.00,184),(5028,227,'VDBT-NAU',450000.00,188),(5029,228,'GDNCS-40-DEN',1170000.00,190),(5030,229,'MLT-FREE-DEN',135000.00,200),(5031,230,'BLCN-DEN',630000.00,192),(5032,231,'KMGT-DEN',315000.00,191),(5033,232,'TCC-FREE-DEN',45000.00,188),(5034,233,'TLDN-90CM-DEN',360000.00,200),(5049,210,'SKU-1762558064268',380000.00,200),(5050,210,'SKU-1762558067561',380000.00,200),(5057,222,'SKU-1763049245073',310000.00,200),(5058,211,'SKU-1763812075315',400000.00,200);
/*!40000 ALTER TABLE `phienbansanpham` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phiendangnhap`
--

DROP TABLE IF EXISTS `phiendangnhap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phiendangnhap` (
  `PhienID` int NOT NULL AUTO_INCREMENT,
  `NguoiDungID` int NOT NULL,
  `Token` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  `HetHan` datetime DEFAULT NULL,
  PRIMARY KEY (`PhienID`),
  KEY `NguoiDungID` (`NguoiDungID`),
  CONSTRAINT `phiendangnhap_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phiendangnhap`
--

LOCK TABLES `phiendangnhap` WRITE;
/*!40000 ALTER TABLE `phiendangnhap` DISABLE KEYS */;
INSERT INTO `phiendangnhap` VALUES (123,52,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTIsInZhaVRybyI6IktIQUNISEFORyIsImlhdCI6MTc2NTQzMjU4MSwiZXhwIjoxNzY4MDI0NTgxfQ.koNL8ImewUm8n2MxqdwrKrgmLImJYFCWB84jUOIWV0E','2025-12-11 12:56:21','2026-01-10 12:56:21');
/*!40000 ALTER TABLE `phiendangnhap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phuongthucvanchuyen`
--

DROP TABLE IF EXISTS `phuongthucvanchuyen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phuongthucvanchuyen` (
  `PhuongThucID` int NOT NULL AUTO_INCREMENT,
  `TenPhuongThuc` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `PhiCoDinh` decimal(10,2) DEFAULT '0.00',
  `MoTa` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`PhuongThucID`),
  UNIQUE KEY `TenPhuongThuc` (`TenPhuongThuc`),
  CONSTRAINT `phuongthucvanchuyen_chk_1` CHECK ((`PhiCoDinh` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=603 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phuongthucvanchuyen`
--

LOCK TABLES `phuongthucvanchuyen` WRITE;
/*!40000 ALTER TABLE `phuongthucvanchuyen` DISABLE KEYS */;
INSERT INTO `phuongthucvanchuyen` VALUES (601,'Giao hàng Tiết kiệm',30000.00,NULL),(602,'Giao hàng Hỏa tốc',50000.00,NULL);
/*!40000 ALTER TABLE `phuongthucvanchuyen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `returns`
--

DROP TABLE IF EXISTS `returns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `returns` (
  `ReturnID` int NOT NULL AUTO_INCREMENT,
  `DonHangID` int NOT NULL,
  `Reason` text COLLATE utf8mb4_general_ci NOT NULL,
  `Status` enum('PENDING','APPROVED','REJECTED','COMPLETED') COLLATE utf8mb4_general_ci DEFAULT 'PENDING',
  `RefundAmount` decimal(10,2) DEFAULT NULL,
  `NgayYeuCau` datetime DEFAULT CURRENT_TIMESTAMP,
  `NgayCapNhat` datetime DEFAULT NULL,
  `NguoiCapNhat` int DEFAULT NULL,
  PRIMARY KEY (`ReturnID`),
  KEY `DonHangID` (`DonHangID`),
  CONSTRAINT `returns_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE,
  CONSTRAINT `returns_chk_1` CHECK ((`RefundAmount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `returns`
--

LOCK TABLES `returns` WRITE;
/*!40000 ALTER TABLE `returns` DISABLE KEYS */;
/*!40000 ALTER TABLE `returns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sanpham`
--

DROP TABLE IF EXISTS `sanpham`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sanpham` (
  `SanPhamID` int NOT NULL AUTO_INCREMENT,
  `DanhMucID` int DEFAULT NULL,
  `TenSanPham` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `Slug` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `MoTa` text COLLATE utf8mb4_general_ci,
  `ThuongHieu` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ChatLieu` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `GiaGoc` decimal(10,2) DEFAULT NULL,
  `TrangThai` enum('ACTIVE','DRAFT','ARCHIVED','HET_HANG') COLLATE utf8mb4_general_ci DEFAULT 'DRAFT',
  `BanChay` tinyint(1) DEFAULT '0',
  `LuotXem` int DEFAULT '0',
  `NgayTao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`SanPhamID`),
  UNIQUE KEY `Slug` (`Slug`),
  KEY `idx_sanpham_slug` (`Slug`),
  KEY `idx_sanpham_danhmuc` (`DanhMucID`),
  CONSTRAINT `sanpham_ibfk_1` FOREIGN KEY (`DanhMucID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE SET NULL,
  CONSTRAINT `sanpham_chk_1` CHECK ((`GiaGoc` >= 0)),
  CONSTRAINT `sanpham_chk_2` CHECK ((`LuotXem` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sanpham`
--

LOCK TABLES `sanpham` WRITE;
/*!40000 ALTER TABLE `sanpham` DISABLE KEYS */;
INSERT INTO `sanpham` VALUES (201,406,'Áo Thun Cotton Cơ Bản','ao-thun-cotton-co-ban','Thông tin sản phẩm Áo Thun:\n- Hàng chuẩn sản xuất, với những mẫu áo ý nghĩa, hài hước và độc đáo.\n- Chất liệu: thun cotton 100%, co giãn 2 chiều, vải mềm, vải mịn, thoáng mát, không xù lông.\n- Đường may chuẩn chỉnh, tỉ mỉ, chắc chắn.\n- Họa tiết được in bằng bằng công nghệ Pet Kĩ thuật số, rất chi tiết và bền màu.\n- Thiết kế với những mẫu in độc đáo!\nCó đủ các size từ   S, M, L, XL Chuẩn Form Oversize, Định Lượng 260GSM\nHướng dẫn sử dụng sản phẩm:\n- Nhớ lộn trái áo khi giặt máy và không ngâm lâu trong nước giặt\n- Không sử dụng thuốc tẩy\n- Khi phơi lộn trái và không phơi trực tiếp dưới ánh nắng mặt trời để bảo quản hình trên áo luôn đẹp\n Điều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm) \n- Hàng hoá sai mẫu mã do người gửi\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất \nCách Thức Về Đổi Trả Sản Phẩm\n- Chúng mình chỉ nhận đổi trả sản phẩm trong vòng 7 ngày \"kể từ khi bạn nhận được hàng\", và lỗi về thiết kế hoặc chất lượng áo, Chúng mình không hỗ trợ đổi trả khi khách hàng chọn sai kích thước \" size áo \". Nếu bạn cảm thấy khó trong vấn đề chọn size thì đừng ngừng ngại Inbox cho tụi mình nhé.\nDo màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 2-5%','BLANK CANVAS','Cotton 100%',120000.00,'ACTIVE',0,0,'2025-11-01 15:40:00'),(202,411,'Quần Jean Slim Fit','quan-jean-slim-fit','Thông tin sản phẩm Quần Jean Slim Fit:\r\n- Hàng thiết kế và sản xuất bởi DenimPro, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Jean Cotton cao cấp, co giãn nhẹ, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Jean Slim Fit hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Cotton.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DenimPro','Vải Jean Cotton',450000.00,'ARCHIVED',0,0,'2025-11-02 15:40:00'),(203,406,'Áo Thun Nam Cổ Tròn','ao-thun-nam-co-tron','Thông tin sản phẩm Áo Thun Nam Cổ Tròn:\r\n- Hàng thiết kế và sản xuất bởi UrbanFlex, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Cotton 4 chiều cao cấp, siêu co giãn, thấm hút mồ hôi, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Thun Nam Cổ Tròn hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Cotton 4 chiều.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','UrbanFlex','Cotton 4 chiều',200000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(204,407,'Áo Sơ Mi Nam Tay Dài','ao-so-mi-nam-tay-dai','Thông tin sản phẩm Áo Sơ Mi Nam Tay Dài:\n- Hàng thiết kế và sản xuất bởi Elegante, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kate Lụa cao cấp, chống nhăn, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Sơ Mi Nam Tay Dài hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kate Lụa.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','Elegante','Vải Kate Lụa',400000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(205,408,'Áo Polo Nam Vải Cá Sấu','ao-polo-nam-vai-ca-sau','Thông tin sản phẩm Áo Polo Nam Vải Cá Sấu:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Cotton Pique (Cá Sấu) cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Polo Nam Vải Cá Sấu hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Cotton Pique (Cá Sấu).\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Cotton Pique (Cá Sấu)',300000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(206,409,'Áo Khoác Nam Dù','ao-khoac-nam-du','Thông tin sản phẩm Áo Khoác Nam Dù:\n- Hàng thiết kế và sản xuất bởi WindBreaker, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Dù 2 lớp cao cấp, chống gió, trượt nước nhẹ, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Nam Dù hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Dù 2 lớp.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','WindBreaker','Vải Dù 2 lớp',500000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(207,410,'Áo Hoodie Nam Nỉ Bông','ao-hoodie-nam-ni-bong','Thông tin sản phẩm Áo Hoodie Nam Nỉ Bông:\r\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Nỉ Bông Dày cao cấp, ấm áp, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Hoodie Nam Nỉ Bông hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Nỉ Bông Dày.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Vải Nỉ Bông Dày',450000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(208,411,'Quần Jean Nam Rách Gối','quan-jean-nam-rach-goi','Thông tin sản phẩm Quần Jean Nam Rách Gối:\n- Hàng thiết kế và sản xuất bởi RippedStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Bụi cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Jean Nam Rách Gối hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Bụi.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','RippedStyle','Vải Jean Bụi',550000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(209,412,'Quần Short Nam Kaki','quan-short-nam-kaki','Thông tin sản phẩm Quần Short Nam Kaki:\r\n- Hàng thiết kế và sản xuất bởi UrbanFlex, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Kaki Cotton cao cấp, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Short Nam Kaki hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kaki Cotton.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','UrbanFlex','Vải Kaki Cotton',250000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(210,413,'Quần Kaki Nam Dáng Slim','quan-kaki-nam-dang-slim','','','',380000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(211,414,'Quần Tây Nam Ống Đứng','quan-tay-nam-ong-dung','Thông tin sản phẩm Quần Tây Nam Ống Đứng:\r\n- Hàng thiết kế và sản xuất bởi OfficeStyle, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Tây Cao Cấp cao cấp, chống nhăn, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Tây Nam Ống Đứng hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Tây Cao Cấp.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','OfficeStyle','Vải Tây Cao Cấp',420000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(212,415,'Áo Thun Nữ Form Rộng','ao-thun-nu-form-rong','Thông tin sản phẩm Áo Thun Nữ Form Rộng:\r\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Cotton 100% 2 chiều cao cấp, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Thun Nữ Form Rộng hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Cotton 100% 2 chiều.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Cotton 100% 2 chiều',220000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(213,416,'Áo Sơ Mi Nữ Lụa','ao-so-mi-nu-lua','Thông tin sản phẩm Áo Sơ Mi Nữ Lụa:\r\n- Hàng thiết kế và sản xuất bởi SilkSation, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Lụa Satin cao cấp, mềm mịn, thoáng mát, giữ form, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Áo Sơ Mi Nữ Lụa hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Lụa Satin.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','SilkySation','Vải Lụa Satin',360000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(214,417,'Áo Croptop Tay Phồng','ao-croptop-tay-phong','Thông tin sản phẩm Áo Croptop Tay Phồng:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kate Forrm cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Croptop Tay Phồng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kate Forrm.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Vải Kate Forrm',180000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(215,418,'Áo Hoodie Nữ Tai Mèo','ao-hoodie-nu-tai-meo','Thông tin sản phẩm Áo Hoodie Nữ Tai Mèo:\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Nỉ Bông Mịn cao cấp, ấm áp, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Hoodie Nữ Tai Mèo hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Nỉ Bông Mịn.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Vải Nỉ Bông Mịn',480000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(216,419,'Áo Khoác Nữ Cardigan','ao-khoac-nu-cardigan','Thông tin sản phẩm Áo Khoác Nữ Cardigan:\n- Hàng thiết kế và sản xuất bởi CozyWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Len Dệt Kim cao cấp, mềm mại, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Nữ Cardigan hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Len Dệt Kim.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Vải Len Dệt Kim',390000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(217,420,'Quần Jean Nữ Ống Loe','quan-jean-nu-ong-loe','Thông tin sản phẩm Quần Jean Nữ Ống Loe:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Co Giãn cao cấp, tôn dáng, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Jean Nữ Ống Loe hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Co Giãn.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Vải Jean Co Giãn',520000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(218,421,'Quần Short Nữ Jean','quan-short-nu-jean','Thông tin sản phẩm Quần Short Nữ Jean:\n- Hàng thiết kế và sản xuất bởi DenimPro, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Jean Cotton cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Short Nữ Jean hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Jean Cotton.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DenimPro','Vải Jean Cotton',280000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(219,422,'Quần Ống Rộng Nữ Vải Tuyết','quan-ong-rong-nu-vai-tuyet','Thông tin sản phẩm Quần Ống Rộng Nữ Vải Tuyết:\n- Hàng thiết kế và sản xuất bởi Elegante, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Tuyết Mưa cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Ống Rộng Nữ Vải Tuyết hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Tuyết Mưa.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','Elegante','Vải Tuyết Mưa',330000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(220,423,'Chân Váy Chữ A','chan-vay-chu-a','Thông tin sản phẩm Chân Váy Chữ A:\n- Hàng thiết kế và sản xuất bởi DivaStyle, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Kaki Mềm cao cấp, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Chân Váy Chữ A hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Kaki Mềm.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','DivaStyle','Vải Kaki Mềm',270000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(221,424,'Váy Đầm Maxi Voan','vay-dam-maxi-voan','Thông tin sản phẩm Váy Đầm Maxi Voan:\n- Hàng thiết kế và sản xuất bởi SilkSation, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Voan Lụa 2 Lớp cao cấp, bay bổng, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Váy Đầm Maxi Voan hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Voan Lụa 2 Lớp.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','SilkySation','Vải Voan Lụa 2 Lớp',600000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(222,425,'Quần Legging Gym Nữ','quan-legging-gym-nu','Thông tin sản phẩm Quần Legging Gym Nữ:\r\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\r\n- Chất liệu: Vải Thun Lạnh 4 Chiều cao cấp, co giãn tối đa, thấm hút mồ hôi, và thân thiện với da.\r\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\r\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\r\n- Thiết kế Quần Legging Gym Nữ hiện đại, trẻ trung, dễ dàng phối đồ.\r\n\r\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Thun Lạnh 4 Chiều.\r\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\r\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\r\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Thun Lạnh 4 Chiều',310000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(223,426,'Quần Short Chạy Bộ 2 Lớp','quan-short-chay-bo-2-lop','Thông tin sản phẩm Quần Short Chạy Bộ 2 Lớp:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Dù Lót Lưới cao cấp, siêu nhẹ, thoáng mát, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Quần Short Chạy Bộ 2 Lớp hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Dù Lót Lưới.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Dù Lót Lưới',260000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(224,427,'Đồ Bơi Nữ Một Mảnh','do-boi-nu-mot-manh','Thông tin sản phẩm Đồ Bơi Nữ Một Mảnh:\n- Hàng thiết kế và sản xuất bởi AquaFit, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Lycra Bơi Lội cao cấp, co giãn, chống UV, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Đồ Bơi Nữ Một Mảnh hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Lycra Bơi Lội.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','AquaFit','Vải Lycra Bơi Lội',450000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(225,428,'Áo Khoác Thể Thao Chống Nắng','ao-khoac-the-thao-chong-nang','Thông tin sản phẩm Áo Khoác Thể Thao Chống Nắng:\n- Hàng thiết kế và sản xuất bởi ActiveWear, đảm bảo chất lượng và form dáng.\n- Chất liệu: Vải Thun Lạnh (UPF 50+) cao cấp, thoáng mát, chống tia UV, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Thể Thao Chống Nắng hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Vải Thun Lạnh (UPF 50+).\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','ActiveWear','Vải Thun Lạnh (UPF 50+)',300000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(226,429,'Áo Khoác Da Lót Lông','ao-khoac-da-lot-long','Thông tin sản phẩm Áo Khoác Da Lót Lông:\n- Hàng thiết kế và sản xuất bởi LeatherLux, đảm bảo chất lượng và form dáng.\n- Chất liệu: Da PU Cao Cấp Lót Lông Cừu cao cấp, siêu ấm, giữ form, và thân thiện với da.\n- Đường may tỉ mỉ, tinh tế, không chỉ thừa, đạt tiêu chuẩn xuất khẩu.\n- Phù hợp mặc đi làm, đi chơi, dạo phố hoặc các sự kiện quan trọng.\n- Thiết kế Áo Khoác Da Lót Lông hiện đại, trẻ trung, dễ dàng phối đồ.\n\nCó đủ các size từ S, M, L, XL, XXL (Vui lòng tham khảo bảng size chi tiết).\n\nHướng dẫn sử dụng sản phẩm:\n- Ưu tiên giặt tay ở nhiệt độ thường để giữ độ bền của Da PU Cao Cấp Lót Lông Cừu.\n- Hạn chế giặt máy. Nếu giặt máy, nên lộn trái sản phẩm và cho vào túi giặt.\n- Không sử dụng thuốc tẩy hoặc ngâm sản phẩm quá lâu.\n- Phơi ở nơi thoáng mát, tránh ánh nắng mặt trời trực tiếp.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','LeatherLux','Da PU Cao Cấp Lót Lông Cừu',1500000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(227,430,'Ví Da Bò Thật','vi-da-bo-that','Thông tin sản phẩm Ví Da Bò Thật:\n- Hàng thiết kế cao cấp bởi LeatherLux.\n- Chất liệu: Da Bò Thật 100% siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','LeatherLux','Da Bò Thật 100%',500000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(228,431,'Giày Da Nam Công Sở','giay-da-nam-cong-so','Thông tin sản phẩm Giày Da Nam Công Sở:\n- Hàng thiết kế cao cấp bởi Elegante.\n- Chất liệu: Da Bò Nhập Khẩu siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','Elegante','Da Bò Nhập Khẩu',1300000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(229,432,'Mũ Lưỡi Trai (Nón Kết)','mu-luoi-trai-non-ket','Thông tin sản phẩm Mũ Lưỡi Trai (Nón Kết):\n- Hàng thiết kế cao cấp bởi UrbanFlex.\n- Chất liệu: Vải Kaki Cotton siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','UrbanFlex','Vải Kaki Cotton',150000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(230,433,'Balo Laptop Chống Nước','balo-laptop-chong-nuoc','Thông tin sản phẩm Balo Laptop Chống Nước:\n- Hàng thiết kế cao cấp bởi PackSafe.\n- Chất liệu: Vải Oxford Chống Thấm siêu bền, chống mài mòn và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','PackSafe','Vải Oxford Chống Thấm',700000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(231,434,'Kính Mát Gọng Tròn','kinh-mat-gong-tron','Thông tin sản phẩm Kính Mát Gọng Tròn:\n- Hàng thiết kế cao cấp bởi SunShade.\n- Chất liệu: Gọng Hợp Kim & Tròng Kính Polarized siêu bền, chống UV400, và chịu lực tốt.\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\n\nHướng dẫn bảo quản sản phẩm:\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\n\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\n\nLưu ý:\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','SunShade','Gọng Hợp Kim & Tròng Kính Polarized',350000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(232,435,'Tất Cổ Cao (Vớ)','tat-co-cao-vo','Thông tin sản phẩm Tất Cổ Cao (Vớ):\r\n- Hàng thiết kế cao cấp bởi CozyWear.\r\n- Chất liệu: Cotton 100% siêu bền, thoáng khí, khử mùi và chịu lực tốt.\r\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\r\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\r\n\r\nHướng dẫn bảo quản sản phẩm:\r\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\r\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\r\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\r\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','CozyWear','Cotton 100%',50000.00,'ACTIVE',0,0,'2025-11-04 18:11:41'),(233,436,'Thắt Lưng Da Nam','that-lung-da-nam','Thông tin sản phẩm Thắt Lưng Da Nam:\r\n- Hàng thiết kế cao cấp bởi GentleWear.\r\n- Chất liệu: Da Bò Cao Cấp siêu bền, chống mài mòn và chịu lực tốt.\r\n- Đường may/khóa kéo/mối nối tỉ mỉ, tinh tế, không chi tiết thừa.\r\n- Thiết kế đa dụng, vừa thời trang vừa tiện lợi, phù hợp cho mọi hoàn cảnh.\r\n\r\nHướng dẫn bảo quản sản phẩm:\r\n- Để sản phẩm ở nơi khô ráo, thoáng mát.\r\n- Không để sản phẩm tiếp xúc trực tiếp với hóa chất, xà phòng.\r\n- Vệ sinh sản phẩm bằng khăn ẩm, lau nhẹ nhàng.\r\n- Tránh phơi trực tiếp dưới ánh nắng mặt trời gắt.\r\n\r\nĐiều kiện áp dụng đổi sản phẩm (trong vòng 07 ngày kể từ khi nhận sản phẩm):\r\n- Hàng hoá còn mới, chưa qua sử dụng, còn nguyên tem mác.\r\n- Hàng hoá bị lỗi hoặc hư hỏng do vận chuyển hoặc do nhà sản xuất.\r\n\r\nLưu ý:\r\n- Do màn hình và điều kiện ánh sáng khác nhau, màu sắc thực tế của sản phẩm có thể chênh lệch khoảng 3-5%.','GentleWear','Da Bò Cao Cấp',400000.00,'ACTIVE',0,0,'2025-11-04 18:11:41');
/*!40000 ALTER TABLE `sanpham` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sizechart`
--

DROP TABLE IF EXISTS `sizechart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sizechart` (
  `SizeChartID` int NOT NULL AUTO_INCREMENT,
  `DanhMucID` int DEFAULT NULL,
  `MoTa` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`SizeChartID`),
  KEY `DanhMucID` (`DanhMucID`),
  CONSTRAINT `sizechart_ibfk_1` FOREIGN KEY (`DanhMucID`) REFERENCES `danhmuc` (`DanhMucID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sizechart`
--

LOCK TABLES `sizechart` WRITE;
/*!40000 ALTER TABLE `sizechart` DISABLE KEYS */;
INSERT INTO `sizechart` VALUES (1,435,'{\"type\":\"freesize\",\"content\":\"Sản phẩm này là Freesize, phù hợp với mọi kích cỡ.\"}'),(2,406,'{\"headers\":[\"Size\",\"Chiều cao (cm)\",\"Cân nặng (kg)\",\"Dài áo (cm)\",\"Rộng ngực (cm)\"],\"rows\":[[\"S\",\"1.60-1.65\",\"50-58\",\"66\",\"48\"],[\"M\",\"1.66-1.70\",\"59-68\",\"68\",\"50\"],[\"L\",\"1.71-1.75\",\"69-76\",\"70\",\"52\"],[\"XL\",\"1.76-1.80\",\"77-85\",\"72\",\"54\"],[\"XXL\",\">1.80\",\">85\",\"74\",\"56\"]]}'),(3,436,'{\"headers\":[\"Size\"],\"rows\":[[\"Freesize (phù hợp với mọi size)\"]]}'),(4,430,'{\"headers\":[\"Size\"],\"rows\":[[\"Freesize\"]]}'),(5,431,'{\"headers\":[\"Size\",\"Dài chn (cm)\"],\"rows\":[[\"S\",\"18-20\"]]}'),(6,433,'{\"headers\":[\"Size\",\"Chiều cao (cm)\",\"Cân nặng (kg)\"],\"rows\":[[\"S\",\"150 - 160\",\"45 - 55\"],[\"M\",\"160 - 170\",\"55 - 65\"],[\"L\",\"170 - 175\",\"65 - 75\"],[\"XL\",\"175 - 180\",\"75 - 85\"]]}');
/*!40000 ALTER TABLE `sizechart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thanhtoan`
--

DROP TABLE IF EXISTS `thanhtoan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thanhtoan` (
  `ThanhToanID` int NOT NULL AUTO_INCREMENT,
  `DonHangID` int NOT NULL,
  `MethodID` int NOT NULL,
  `SoTienThanhToan` decimal(10,2) NOT NULL,
  `NgayThanhToan` datetime DEFAULT CURRENT_TIMESTAMP,
  `TrangThai` enum('PENDING','SUCCESS','FAILED') COLLATE utf8mb4_general_ci NOT NULL,
  `MaGiaoDich` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`ThanhToanID`),
  UNIQUE KEY `DonHangID` (`DonHangID`),
  KEY `MethodID` (`MethodID`),
  CONSTRAINT `thanhtoan_ibfk_1` FOREIGN KEY (`DonHangID`) REFERENCES `donhang` (`DonHangID`) ON DELETE CASCADE,
  CONSTRAINT `thanhtoan_ibfk_2` FOREIGN KEY (`MethodID`) REFERENCES `paymentmethods` (`MethodID`),
  CONSTRAINT `thanhtoan_chk_1` CHECK ((`SoTienThanhToan` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thanhtoan`
--

LOCK TABLES `thanhtoan` WRITE;
/*!40000 ALTER TABLE `thanhtoan` DISABLE KEYS */;
INSERT INTO `thanhtoan` VALUES (49,1051,701,354000.00,'2024-01-26 15:02:16','SUCCESS',NULL),(50,1052,702,3180000.00,'2024-01-08 19:40:08','SUCCESS','VNPay-20240108-1052'),(51,1053,701,1031000.00,'2024-01-01 19:07:35','SUCCESS',NULL),(52,1054,703,1731000.00,'2024-02-09 20:25:22','SUCCESS','Momo-20240209-1054'),(53,1055,701,219000.00,'2024-02-12 11:47:04','SUCCESS',NULL),(54,1056,701,1686000.00,'2024-02-28 11:39:19','SUCCESS',NULL),(55,1057,702,885000.00,'2024-02-04 15:47:49','SUCCESS','VNPay-20240204-1057'),(56,1058,703,2165000.00,'2024-03-03 12:47:20','SUCCESS','Momo-20240303-1058'),(57,1059,701,1794000.00,'2024-03-24 16:11:43','SUCCESS',NULL),(58,1060,701,462000.00,'2024-04-11 15:52:16','SUCCESS',NULL),(59,1061,702,4532000.00,'2024-04-03 09:35:10','SUCCESS','VNPay-20240403-1061'),(60,1062,701,1164000.00,'2024-05-18 10:48:58','SUCCESS',NULL),(61,1063,703,2046000.00,'2024-05-13 19:26:01','SUCCESS','Momo-20240513-1063'),(62,1064,701,390000.00,'2024-05-24 17:09:50','SUCCESS',NULL),(63,1065,701,1614000.00,'2024-06-25 15:15:35','SUCCESS',NULL),(64,1066,702,320000.00,'2024-06-03 09:21:49','SUCCESS','VNPay-20240603-1066'),(65,1067,701,1625000.00,'2024-06-18 17:34:02','SUCCESS',NULL),(66,1068,703,1004000.00,'2024-07-06 21:05:07','SUCCESS','Momo-20240706-1068'),(67,1069,701,2534000.00,'2024-07-02 12:44:59','SUCCESS',NULL),(68,1070,701,680000.00,'2024-08-01 17:09:47','SUCCESS',NULL),(69,1071,702,2957000.00,'2024-08-10 18:31:38','SUCCESS','VNPay-20240810-1071'),(70,1072,701,1002000.00,'2024-08-01 19:16:16','SUCCESS',NULL),(71,1073,703,1866000.00,'2024-09-02 10:14:14','SUCCESS','Momo-20240902-1073'),(72,1074,701,2165000.00,'2024-09-07 19:12:48','SUCCESS',NULL),(73,1075,701,2730000.00,'2024-10-25 10:20:13','SUCCESS',NULL),(74,1076,702,1020000.00,'2024-10-06 14:12:35','SUCCESS','VNPay-20241006-1076'),(75,1077,701,1454000.00,'2024-11-06 13:58:14','SUCCESS',NULL),(76,1078,703,419000.00,'2024-11-08 17:34:04','SUCCESS','Momo-20241108-1078'),(77,1079,701,1994000.00,'2024-11-17 19:54:19','SUCCESS',NULL),(78,1080,701,1362000.00,'2024-12-09 20:07:05','SUCCESS',NULL),(79,1081,702,1265000.00,'2024-12-05 13:58:14','SUCCESS','VNPay-20241205-1081'),(80,1082,701,885000.00,'2024-12-07 10:14:14','SUCCESS',NULL),(81,1083,703,228000.00,'2025-01-26 15:47:33','SUCCESS','Momo-20250126-1083'),(82,1084,701,1938000.00,'2025-01-15 13:50:51','SUCCESS',NULL),(83,1085,701,2145000.00,'2025-01-07 16:51:30','SUCCESS',NULL),(84,1086,702,1562000.00,'2025-02-12 11:25:22','SUCCESS','VNPay-20250212-1086'),(85,1087,701,2210000.00,'2025-02-18 20:07:05','SUCCESS',NULL),(86,1088,703,311000.00,'2025-02-09 20:46:17','SUCCESS','Momo-20250209-1088'),(87,1089,701,3054000.00,'2025-03-24 16:54:19','SUCCESS',NULL),(88,1090,701,84000.00,'2025-03-12 18:04:15','SUCCESS',NULL),(89,1091,702,545000.00,'2025-03-03 14:45:07','SUCCESS','VNPay-20250303-1091'),(90,1092,701,2730000.00,'2025-04-18 10:25:29','SUCCESS',NULL),(91,1093,703,1679000.00,'2025-04-15 13:58:14','SUCCESS','Momo-20250415-1093'),(92,1094,701,300000.00,'2025-05-18 16:11:41','SUCCESS',NULL),(93,1095,701,2534000.00,'2025-05-02 12:44:59','SUCCESS',NULL),(94,1096,702,2048000.00,'2025-05-18 10:48:58','SUCCESS','VNPay-20250518-1096'),(95,1097,701,930000.00,'2025-06-25 15:15:35','SUCCESS',NULL),(96,1098,703,2975000.00,'2025-06-05 13:00:15','SUCCESS','Momo-20250605-1098'),(97,1099,701,275000.00,'2025-07-26 12:59:06','SUCCESS',NULL),(98,1100,701,2768000.00,'2025-07-16 11:29:43','SUCCESS',NULL),(99,1101,702,1094000.00,'2025-07-07 19:40:48','SUCCESS','VNPay-20250707-1101'),(100,1102,701,1886000.00,'2025-08-05 13:00:15','SUCCESS',NULL),(101,1103,703,932000.00,'2025-08-11 11:21:52','SUCCESS','Momo-20250811-1103'),(102,1104,701,1560000.00,'2025-08-20 09:25:27','SUCCESS',NULL),(103,1105,701,1047000.00,'2025-09-02 21:04:15','SUCCESS',NULL),(104,1106,702,912000.00,'2025-09-20 12:13:32','SUCCESS','VNPay-20250920-1106'),(105,1107,701,1434000.00,'2025-09-21 16:32:20','SUCCESS',NULL),(106,1108,703,2075000.00,'2025-10-27 09:44:41','SUCCESS','Momo-20251027-1108'),(107,1109,701,1580000.00,'2025-10-06 08:55:06','SUCCESS',NULL),(108,1110,701,1706000.00,'2025-11-20 18:03:00','SUCCESS',NULL),(109,1111,702,84000.00,'2025-11-06 17:34:39','SUCCESS','VNPay-20251106-1111'),(110,1112,701,1641000.00,'2025-11-08 17:34:04','SUCCESS',NULL),(111,1113,703,734000.00,'2025-12-11 12:12:35','SUCCESS','Momo-20251211-1113'),(112,1114,701,1938000.00,'2025-12-07 10:14:14','PENDING',NULL),(113,1115,701,932000.00,'2025-12-11 11:21:52','PENDING',NULL);
/*!40000 ALTER TABLE `thanhtoan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thuoctinh`
--

DROP TABLE IF EXISTS `thuoctinh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thuoctinh` (
  `ThuocTinhID` int NOT NULL AUTO_INCREMENT,
  `TenThuocTinh` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `Slug` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`ThuocTinhID`),
  UNIQUE KEY `TenThuocTinh` (`TenThuocTinh`)
) ENGINE=InnoDB AUTO_INCREMENT=306 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thuoctinh`
--

LOCK TABLES `thuoctinh` WRITE;
/*!40000 ALTER TABLE `thuoctinh` DISABLE KEYS */;
INSERT INTO `thuoctinh` VALUES (301,'Kích Cỡ','kich-co'),(302,'Màu Sắc','mau-sac'),(303,'Kích Cỡ Giày','kich-co-giay'),(304,'Kích Cỡ Thắt Lưng','kich-co-that-lung'),(305,'Kích Cỡ Chung','kich-co-chung');
/*!40000 ALTER TABLE `thuoctinh` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yeuthich`
--

DROP TABLE IF EXISTS `yeuthich`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yeuthich` (
  `NguoiDungID` int NOT NULL,
  `PhienBanID` int NOT NULL,
  `NgayThem` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`NguoiDungID`,`PhienBanID`),
  KEY `PhienBanID` (`PhienBanID`),
  CONSTRAINT `yeuthich_ibfk_1` FOREIGN KEY (`NguoiDungID`) REFERENCES `nguoidung` (`NguoiDungID`) ON DELETE CASCADE,
  CONSTRAINT `yeuthich_ibfk_2` FOREIGN KEY (`PhienBanID`) REFERENCES `phienbansanpham` (`PhienBanID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yeuthich`
--

LOCK TABLES `yeuthich` WRITE;
/*!40000 ALTER TABLE `yeuthich` DISABLE KEYS */;
/*!40000 ALTER TABLE `yeuthich` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-11 13:12:05
