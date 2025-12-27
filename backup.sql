-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: localhost    Database: katariadb
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bill_items_gst`
--

DROP TABLE IF EXISTS `bill_items_gst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_items_gst` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `item_total_price` decimal(10,2) NOT NULL,
  `price_per_sqft` decimal(10,2) NOT NULL,
  `product_image_url` varchar(500) DEFAULT NULL,
  `product_name` varchar(200) NOT NULL,
  `product_type` varchar(50) DEFAULT NULL,
  `sqft_ordered` decimal(10,2) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `bill_id` int NOT NULL,
  `product_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_items_gst`
--

LOCK TABLES `bill_items_gst` WRITE;
/*!40000 ALTER TABLE `bill_items_gst` DISABLE KEYS */;
INSERT INTO `bill_items_gst` VALUES (1,'2025-12-27 09:54:15.147476',200.00,200.00,NULL,'Black Counter top','counter top',1.00,'sqr ft',1,2),(2,'2025-12-27 10:12:53.382848',2650.00,2650.00,NULL,'Ganesh Temple','other',1.00,'piece',2,1);
/*!40000 ALTER TABLE `bill_items_gst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_items_non_gst`
--

DROP TABLE IF EXISTS `bill_items_non_gst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_items_non_gst` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `item_total_price` decimal(10,2) NOT NULL,
  `price_per_sqft` decimal(10,2) NOT NULL,
  `product_image_url` varchar(500) DEFAULT NULL,
  `product_name` varchar(200) NOT NULL,
  `product_type` varchar(50) DEFAULT NULL,
  `sqft_ordered` decimal(10,2) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `bill_id` int NOT NULL,
  `product_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_items_non_gst`
--

LOCK TABLES `bill_items_non_gst` WRITE;
/*!40000 ALTER TABLE `bill_items_non_gst` DISABLE KEYS */;
/*!40000 ALTER TABLE `bill_items_non_gst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bills_gst`
--

DROP TABLE IF EXISTS `bills_gst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bills_gst` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill_date` date NOT NULL,
  `bill_number` varchar(50) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `discount_amount` decimal(10,2) NOT NULL,
  `notes` text,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` enum('PENDING','PARTIAL','PAID','CANCELLED') NOT NULL,
  `service_charge` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) NOT NULL,
  `tax_rate` decimal(5,2) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `total_sqft` decimal(10,2) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `customer_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_ajgegv2pw3p6k3x5kv1qb4nim` (`bill_number`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bills_gst`
--

LOCK TABLES `bills_gst` WRITE;
/*!40000 ALTER TABLE `bills_gst` DISABLE KEYS */;
INSERT INTO `bills_gst` VALUES (1,'2025-12-27','1','2025-12-27 09:54:15.095033',0.00,NULL,NULL,'PAID',0.00,200.00,36.00,18.00,236.00,1.00,'2025-12-27 09:54:15.095033',1),(2,'2025-12-27','2','2025-12-27 10:12:53.369198',0.00,NULL,NULL,'PAID',0.00,2650.00,477.00,18.00,3127.00,1.00,'2025-12-27 10:12:53.369198',2);
/*!40000 ALTER TABLE `bills_gst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bills_non_gst`
--

DROP TABLE IF EXISTS `bills_non_gst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bills_non_gst` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill_date` date NOT NULL,
  `bill_number` varchar(50) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `discount_amount` decimal(10,2) NOT NULL,
  `notes` text,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` enum('PENDING','PARTIAL','PAID','CANCELLED') NOT NULL,
  `service_charge` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `total_sqft` decimal(10,2) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `customer_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_39k3rt6edm3xaxt8j20cemqa2` (`bill_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bills_non_gst`
--

LOCK TABLES `bills_non_gst` WRITE;
/*!40000 ALTER TABLE `bills_non_gst` DISABLE KEYS */;
/*!40000 ALTER TABLE `bills_non_gst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_type` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` text,
  `display_order` int NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `is_active` bit(1) NOT NULL,
  `name` varchar(100) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'tiles','2025-12-27 09:12:40.248987','Polished and Non Polished Tiles',1,'https://www.kajariaceramics.com/storage/product_attributes/bathroom-floor-tiles-3.webp',_binary '','Bathroom','2025-12-27 09:12:40.248987'),(2,'counter top','2025-12-27 09:13:25.272650','Hand crafted Counter Top',2,'https://www.kajariaceramics.com/storage/product_attributes/kitechen-countertop.webp',_binary '','Kitchen','2025-12-27 09:13:25.272650'),(3,'tiles','2025-12-27 09:14:57.009507','Wall and Floor Tiles',3,'https://www.kajariaceramics.com/storage/concept-picture/E00000001058.jpg',_binary '','Living Room','2025-12-27 09:14:57.009507'),(4,'marble','2025-12-27 09:17:23.859434','Machine Polish Marble',4,'https://i.pinimg.com/736x/d7/91/64/d79164552fc5f4226d4e2b1efefec8d6.jpg',_binary '','Marble','2025-12-27 09:17:23.859434'),(5,'tables','2025-12-27 09:18:45.754970','Modern Stylish Tables',5,'https://i.pinimg.com/736x/b5/73/71/b573712283184f81c6ad2961edc478b3.jpg',_binary '','Tables','2025-12-27 09:18:45.754970'),(6,'chair','2025-12-27 09:19:57.631233','Style and Designed Chair',6,'https://i.pinimg.com/1200x/aa/5b/e5/aa5be5f56934ab064a804e9b59e1ce03.jpg',_binary '','Standerd Chair','2025-12-27 09:19:57.631233'),(7,'temple','2025-12-27 09:23:14.243555','Hand made marble temple',7,'https://i.pinimg.com/736x/10/8c/eb/108cebcb1b94cb523abb0db7c5e93afe.jpg',_binary '','Marble Temple','2025-12-27 09:23:14.243555'),(8,'granite','2025-12-27 09:24:40.070199','Polished and well design Granite Slabs',8,'https://i.pinimg.com/1200x/ae/73/8e/ae738e873c9d00f691f75f39f8893393.jpg',_binary '','Granite Slab','2025-12-27 09:24:40.070784');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_purchase_payments`
--

DROP TABLE IF EXISTS `client_purchase_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_purchase_payments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) NOT NULL,
  `client_id` varchar(200) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `date` date NOT NULL,
  `notes` text,
  `payment_method` varchar(50) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `client_purchase_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK4e50r962pdpojdwstdnmjdn8l` (`client_purchase_id`),
  CONSTRAINT `FK4e50r962pdpojdwstdnmjdn8l` FOREIGN KEY (`client_purchase_id`) REFERENCES `client_purchases` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_purchase_payments`
--

LOCK TABLES `client_purchase_payments` WRITE;
/*!40000 ALTER TABLE `client_purchase_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_purchase_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_purchases`
--

DROP TABLE IF EXISTS `client_purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_purchases` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_name` varchar(200) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `location` varchar(50) NOT NULL,
  `notes` text,
  `purchase_date` date NOT NULL,
  `purchase_description` text NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_purchases`
--

LOCK TABLES `client_purchases` WRITE;
/*!40000 ALTER TABLE `client_purchases` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_purchases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address` text,
  `created_at` datetime(6) NOT NULL,
  `customer_name` varchar(200) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `gstin` varchar(15) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_m3iom37efaxd5eucmxjqqcbe9` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Lakhan Majra, Mehem, Haryana - 124514','2025-12-27 09:54:14.904622','Manjit Sharma','itsofficialformanjit@gmail.com',NULL,'Bhondsi',NULL,'8152864826','2025-12-27 09:54:14.904622'),(2,'Lakhan Majra, Mehem, Haryana - 124514','2025-12-27 10:12:53.280499','Manjit Sharma','itsofficialformanjit@gmail.com',NULL,'Bhondsi',NULL,'9996657779','2025-12-27 10:12:53.280499');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `employee_name` varchar(200) NOT NULL,
  `joining_date` date NOT NULL,
  `location` varchar(50) NOT NULL,
  `salary_amount` decimal(10,2) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) NOT NULL,
  `category` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `date` date NOT NULL,
  `description` text,
  `employee_id` bigint DEFAULT NULL,
  `employee_name` varchar(200) DEFAULT NULL,
  `location` varchar(50) NOT NULL,
  `month` varchar(20) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `settled` bit(1) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hero_slides`
--

DROP TABLE IF EXISTS `hero_slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hero_slides` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `display_order` int NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `is_active` bit(1) NOT NULL,
  `subtitle` varchar(500) DEFAULT NULL,
  `title` varchar(500) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hero_slides`
--

LOCK TABLES `hero_slides` WRITE;
/*!40000 ALTER TABLE `hero_slides` DISABLE KEYS */;
INSERT INTO `hero_slides` VALUES (1,'2025-12-27 09:01:04.460048',1,'https://www.kajariaceramics.com/storage/banner/kajaria-living-desktop-2.webp',_binary '','Set the tone of your space with tiles that go beyond function','Shaping Dream Into Living Spaces','2025-12-27 09:01:04.460048'),(2,'2025-12-27 09:06:12.474598',2,'https://www.kajariaceramics.com/storage/banner/kajaria-kitchen-dektop.webp',_binary '','Where stone meet culinary craft','Counter Top','2025-12-27 09:06:12.474598'),(3,'2025-12-27 09:07:04.332980',3,'https://www.kajariaceramics.com/storage/banner/kajaria-bathroom-desktop.webp',_binary '','Timeless Tiles for Tranquil Spaces','Bathroom tiles','2025-12-27 09:07:04.332980'),(4,'2025-12-27 09:08:18.829435',4,'https://www.kajariaceramics.com/storage/banner/kajaria-outdoor-dektop1.webp',_binary '','Beauty That last beyong Seasons','Outdoor Tiles','2025-12-27 09:08:18.829435');
/*!40000 ALTER TABLE `hero_slides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `damage_expenses` decimal(10,2) DEFAULT NULL,
  `description` text,
  `is_active` bit(1) NOT NULL,
  `is_featured` bit(1) NOT NULL,
  `labour_charges` decimal(10,2) DEFAULT NULL,
  `location` varchar(50) NOT NULL,
  `meta_keywords` varchar(500) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `others_expenses` decimal(10,2) DEFAULT NULL,
  `price_per_sqft_after` decimal(10,2) DEFAULT NULL,
  `price_per_sqft` decimal(10,2) NOT NULL,
  `primary_image_url` varchar(500) NOT NULL,
  `product_type` varchar(100) NOT NULL,
  `total_sqft_stock` decimal(10,2) NOT NULL,
  `rto_fees` decimal(10,2) DEFAULT NULL,
  `slug` varchar(250) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_ostq1ec3toafnjok09y9l7dox` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,NULL,'white','2025-12-27 09:27:46.879066',1500.00,NULL,_binary '',_binary '\0',2000.00,'Bhondsi',NULL,'Ganesh Temple',1999.98,2650.00,2000.00,'https://i.pinimg.com/736x/a5/d5/db/a5d5db1761ba9315c996e009b605a254.jpg','other',9.00,1000.00,'ganesh-temple','piece','2025-12-27 10:12:53.393651'),(2,NULL,'black','2025-12-27 09:52:59.807908',0.00,NULL,_binary '',_binary '\0',0.00,'Bhondsi',NULL,'Black Counter top',0.00,200.00,200.00,'https://i.pinimg.com/1200x/be/f2/1c/bef21c202f014bde82205f21c6ff214c.jpg','counter top',2999.00,0.00,'black-counter-top','sqr ft','2025-12-27 09:54:15.198135');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sellers`
--

DROP TABLE IF EXISTS `sellers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sellers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_no` varchar(50) DEFAULT NULL,
  `address` text,
  `bank_name` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `gst_no` varchar(15) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `sub_header` varchar(200) DEFAULT NULL,
  `terms` text,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sellers`
--

LOCK TABLES `sellers` WRITE;
/*!40000 ALTER TABLE `sellers` DISABLE KEYS */;
INSERT INTO `sellers` VALUES (1,'123456789012','Bhondsi, Sonha Road, Gurgraon, Haryana','State Bank of India','2025-12-27 11:01:31','29ABCDE1234F1Z5','SBIN0001234','8107707064','Kataria Stone World','Wholesale Supplier','Payment within 30 days','2025-12-27 11:01:31');
/*!40000 ALTER TABLE `sellers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state_gst_master`
--

DROP TABLE IF EXISTS `state_gst_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `state_gst_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gst_code` varchar(10) NOT NULL,
  `state_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state_gst_master`
--

LOCK TABLES `state_gst_master` WRITE;
/*!40000 ALTER TABLE `state_gst_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `state_gst_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `email` varchar(255) NOT NULL,
  `location` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_6dotkott2kjsp8vw4d0m25fb7` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'2025-12-23 12:49:15','john@example.com','Bhondsi','John Doe','$2a$10$mDzgKk4awc.l8NN5Fu16meO1/ca2V2N97kcnwp.iuxhzH9j/Rbr22','user','2025-12-23 12:49:15'),(2,'2025-12-27 08:55:46','vrinda@test.com','Bhondsi','Vrinda','$2a$10$3KDR89oR1l8LbSWvIRro6ueCSVdKR7dkPCVVGCA2y/VkxcIln8exW','admin','2025-12-27 08:58:42');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'katariadb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-27 12:46:05
