-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: inventario_ct
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Current Database: `inventario_ct`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `inventario_ct` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `inventario_ct`;

--
-- Table structure for table `componentes`
--

DROP TABLE IF EXISTS `componentes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `componentes` (
  `id_componente` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id_componente`),
  UNIQUE KEY `componentes` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `componentes`
--

LOCK TABLES `componentes` WRITE;
/*!40000 ALTER TABLE `componentes` DISABLE KEYS */;
INSERT INTO `componentes` VALUES (130,'74HC00 compuerta NAND'),(128,'74HC04 inversor logico'),(129,'74HC08 compuerta AND'),(127,'74HC595 registro de desplazamiento'),(200,'Bateria CR2032'),(191,'Bobina 1 mH'),(168,'Bornera 2 pines'),(169,'Bornera 3 pines'),(180,'Buzzer activo 5V'),(181,'Buzzer pasivo 5V'),(49,'Capacitor ceramico 1 nF'),(53,'Capacitor ceramico 1 uF'),(50,'Capacitor ceramico 10 nF'),(45,'Capacitor ceramico 10 pF'),(54,'Capacitor ceramico 10 uF'),(51,'Capacitor ceramico 100 nF'),(48,'Capacitor ceramico 100 pF'),(46,'Capacitor ceramico 22 pF'),(52,'Capacitor ceramico 220 nF'),(47,'Capacitor ceramico 47 pF'),(68,'Capacitor de poliester 1 uF'),(65,'Capacitor de poliester 100 nF'),(66,'Capacitor de poliester 220 nF'),(67,'Capacitor de poliester 470 nF'),(69,'Capacitor de polipropileno 100 nF'),(55,'Capacitor electrolitico 1 uF 16V'),(56,'Capacitor electrolitico 10 uF 16V'),(59,'Capacitor electrolitico 100 uF 16V'),(62,'Capacitor electrolitico 1000 uF 25V'),(57,'Capacitor electrolitico 22 uF 25V'),(60,'Capacitor electrolitico 220 uF 25V'),(63,'Capacitor electrolitico 2200 uF 25V'),(58,'Capacitor electrolitico 47 uF 25V'),(61,'Capacitor electrolitico 470 uF 25V'),(64,'Capacitor electrolitico 4700 uF 50V'),(131,'CD4017 contador decimal'),(132,'CD4047 multivibrador'),(172,'Conector DC Jack 5.5mm'),(176,'Conector Dupont hembra'),(175,'Conector Dupont macho'),(170,'Conector JST XH 2 pines'),(171,'Conector JST XH 3 pines'),(173,'Conector USB tipo A'),(174,'Conector USB tipo C'),(142,'Convertidor boost MT3608'),(141,'Convertidor buck LM2596'),(178,'Cristal oscilador 16 MHz'),(179,'Cristal oscilador 20 MHz'),(177,'Cristal oscilador 8 MHz'),(74,'Diodo de señal 1N4148'),(70,'Diodo rectificador 1N4001'),(71,'Diodo rectificador 1N4004'),(72,'Diodo rectificador 1N4007'),(73,'Diodo rectificador 1N5408'),(75,'Diodo Schottky 1N5819'),(76,'Diodo Schottky SS14'),(80,'Diodo Zener 12V'),(81,'Diodo Zener 24V'),(77,'Diodo Zener 3.3V'),(78,'Diodo Zener 5.1V'),(79,'Diodo Zener 6.2V'),(165,'Final de carrera'),(186,'Fusible 1 A'),(187,'Fusible 2 A'),(188,'Fusible 5 A'),(185,'Fusible 500 mA'),(167,'Header hembra 1x40 pines'),(166,'Header macho 1x40 pines'),(189,'Inductor 10 uH'),(190,'Inductor 100 uH'),(163,'Interruptor DIP 4 posiciones'),(164,'Interruptor DIP 8 posiciones'),(161,'Interruptor DPDT'),(160,'Interruptor SPDT'),(159,'Interruptor SPST'),(123,'L293D driver de motores'),(124,'L298N driver de motores'),(90,'LED amarillo 5mm'),(88,'LED azul 3mm'),(89,'LED azul 5mm'),(91,'LED blanco 5mm'),(97,'LED de alta potencia 1W blanco'),(93,'LED infrarrojo'),(92,'LED RGB 5mm'),(84,'LED rojo 3mm'),(85,'LED rojo 5mm'),(96,'LED SMD 0805 azul'),(94,'LED SMD 0805 rojo'),(95,'LED SMD 0805 verde'),(86,'LED verde 3mm'),(87,'LED verde 5mm'),(119,'LM324 amplificador operacional'),(118,'LM358 amplificador operacional'),(122,'LM386 amplificador de audio'),(121,'LM393 comparador'),(120,'LM741 amplificador operacional'),(162,'Microinterruptor'),(112,'MOSFET canal N 2N7000'),(115,'MOSFET canal N AO3400A'),(111,'MOSFET canal N IRF540N'),(109,'MOSFET canal N IRFZ44N'),(110,'MOSFET canal N IRLZ44N'),(114,'MOSFET canal P IRF4905'),(113,'MOSFET canal P IRF9540N'),(197,'Motor DC 12V'),(196,'Motor DC 3V-6V'),(198,'Motor paso a paso 28BYJ-48'),(116,'NE555 temporizador'),(117,'NE556 doble temporizador'),(195,'Optoacoplador PC817'),(126,'PC817 optoacoplador'),(201,'Portapilas AA'),(36,'Potenciometro 1 KOhm'),(41,'Potenciometro 1 MOhm'),(37,'Potenciometro 10 KOhms'),(39,'Potenciometro 100 KOhms'),(38,'Potenciometro 50 KOhms'),(40,'Potenciometro 500 KOhms'),(202,'Protoboard 400 puntos'),(203,'Protoboard 830 puntos'),(82,'Puente rectificador DB107'),(83,'Puente rectificador KBPC5010'),(157,'Pulsador normalmente abierto'),(158,'Pulsador normalmente cerrado'),(133,'Regulador 7805 5V'),(134,'Regulador 7809 9V'),(135,'Regulador 7812 12V'),(136,'Regulador 7815 15V'),(139,'Regulador AMS1117 3.3V'),(140,'Regulador AMS1117 5V'),(137,'Regulador LM317 ajustable'),(138,'Regulador LM337 ajustable negativo'),(183,'Relevador 12V 1 canal'),(182,'Relevador 5V 1 canal'),(184,'Relevador 5V 2 canales'),(44,'Reostato 100 Ohms'),(6,'Resistencia 0 Ohms'),(18,'Resistencia 1 KOhm'),(30,'Resistencia 1 MOhm'),(7,'Resistencia 1 Ohm'),(19,'Resistencia 1.5 KOhms'),(24,'Resistencia 10 KOhms'),(31,'Resistencia 10 MOhms'),(9,'Resistencia 10 Ohms'),(27,'Resistencia 100 KOhms'),(12,'Resistencia 100 Ohms'),(13,'Resistencia 150 Ohms'),(20,'Resistencia 2.2 KOhms'),(25,'Resistencia 22 KOhms'),(10,'Resistencia 22 Ohms'),(28,'Resistencia 220 KOhms'),(14,'Resistencia 220 Ohms'),(21,'Resistencia 3.3 KOhms'),(15,'Resistencia 330 Ohms'),(22,'Resistencia 4.7 KOhms'),(8,'Resistencia 4.7 Ohms'),(26,'Resistencia 47 KOhms'),(11,'Resistencia 47 Ohms'),(29,'Resistencia 470 KOhms'),(16,'Resistencia 470 Ohms'),(23,'Resistencia 6.8 KOhms'),(17,'Resistencia 680 Ohms'),(35,'Resistencia de potencia 10W 10 Ohms'),(34,'Resistencia de potencia 5W 100 Ohms'),(32,'Resistencia SMD 1 KOhm'),(33,'Resistencia SMD 10 KOhms'),(155,'Sensor de corriente ACS712'),(153,'Sensor de efecto Hall A3144'),(152,'Sensor de gas MQ-135'),(151,'Sensor de gas MQ-2'),(145,'Sensor de humedad DHT11'),(146,'Sensor de humedad DHT22'),(149,'Sensor de luz LDR'),(148,'Sensor de movimiento PIR HC-SR501'),(156,'Sensor de presion BMP280'),(150,'Sensor de sonido KY-038'),(144,'Sensor de temperatura DS18B20'),(143,'Sensor de temperatura LM35'),(154,'Sensor infrarrojo TCRT5000'),(147,'Sensor ultrasonico HC-SR04'),(192,'Termistor NTC 10 KOhms'),(193,'Termistor PTC'),(108,'Transistor Darlington TIP120'),(100,'Transistor NPN 2N2222'),(101,'Transistor NPN 2N3904'),(98,'Transistor NPN BC547'),(99,'Transistor NPN BC548'),(102,'Transistor NPN TIP31C'),(103,'Transistor NPN TIP41C'),(105,'Transistor PNP 2N2907'),(106,'Transistor PNP 2N3906'),(104,'Transistor PNP BC557'),(107,'Transistor PNP TIP32C'),(42,'Trimmer 10 KOhms'),(43,'Trimmer 100 KOhms'),(125,'ULN2003 driver de motores'),(194,'Varistor 14D471K'),(199,'Ventilador 12V');
/*!40000 ALTER TABLE `componentes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleados`
--

DROP TABLE IF EXISTS `empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleados` (
  `id_empleado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(40) NOT NULL,
  `puesto` varchar(20) DEFAULT NULL,
  `nfc_id` varchar(30) DEFAULT NULL,
  `contrasena` varchar(30) NOT NULL,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `empleado` (`nfc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleados`
--

LOCK TABLES `empleados` WRITE;
/*!40000 ALTER TABLE `empleados` DISABLE KEYS */;
INSERT INTO `empleados` VALUES (6,'Jimmy','CEO','698A00F4','elpapu67');
/*!40000 ALTER TABLE `empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_pedidos`
--

DROP TABLE IF EXISTS `historial_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_pedidos` (
  `id_historial` int NOT NULL AUTO_INCREMENT,
  `id_componente` int NOT NULL,
  `id_empleado` int NOT NULL,
  `cantidad` int NOT NULL,
  `fecha_hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recibido` tinyint(1) NOT NULL,
  `id_pedido` int NOT NULL,
  PRIMARY KEY (`id_historial`),
  KEY `id_componente` (`id_componente`),
  KEY `fk_empleado` (`id_empleado`),
  KEY `idx_id_pedido` (`id_pedido`),
  CONSTRAINT `fk_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  CONSTRAINT `fk_historial_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`),
  CONSTRAINT `historial_pedidos_ibfk_1` FOREIGN KEY (`id_componente`) REFERENCES `componentes` (`id_componente`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_pedidos`
--

LOCK TABLES `historial_pedidos` WRITE;
/*!40000 ALTER TABLE `historial_pedidos` DISABLE KEYS */;
INSERT INTO `historial_pedidos` VALUES (11,53,6,1,'2026-11-17 04:31:07',1,1),(12,51,6,3,'2026-11-17 04:31:07',1,1),(13,56,6,1,'2026-11-17 04:31:07',1,1),(14,180,6,1,'2026-11-17 04:59:57',1,2),(15,53,6,2,'2026-11-17 04:59:57',1,2),(16,141,6,2,'2026-11-17 04:59:57',1,2),(17,168,6,4,'2026-11-17 05:05:51',1,3),(18,168,6,3,'2026-11-17 05:12:28',1,4),(19,180,6,1,'2026-11-17 05:12:48',1,5),(20,14,6,1,'2026-11-17 14:14:20',1,6),(21,180,6,1,'2026-11-17 14:14:20',1,6),(22,59,6,2,'2026-11-17 14:14:20',1,6),(23,180,6,1,'2026-11-17 22:03:47',1,7),(24,56,6,1,'2026-11-17 22:03:47',1,7),(25,174,6,3,'2026-11-17 22:03:47',1,7),(26,168,6,3,'2026-11-17 22:06:01',1,8),(27,53,6,1,'2026-11-17 22:06:01',1,8),(28,56,6,2,'2026-11-17 22:06:01',1,8),(29,59,6,1,'2026-11-17 22:06:01',1,8),(30,141,6,2,'2026-11-17 22:06:01',1,8),(31,178,6,1,'2026-11-17 22:06:01',1,8),(32,75,6,1,'2026-11-17 22:06:01',1,8),(33,78,6,2,'2026-11-17 22:06:01',1,8),(34,166,6,2,'2026-11-17 22:06:01',1,8),(35,159,6,1,'2026-11-17 22:06:01',1,8),(36,186,6,1,'2026-11-17 22:06:01',1,8),(37,92,6,1,'2026-11-17 22:06:01',1,8),(38,85,6,2,'2026-11-17 22:06:01',1,8),(39,87,6,2,'2026-11-17 22:06:01',1,8),(40,137,6,1,'2026-11-17 22:06:01',1,8),(41,182,6,1,'2026-11-17 22:06:01',1,8),(42,18,6,1,'2026-11-17 22:06:01',1,8),(43,139,6,3,'2026-11-17 22:06:01',1,8),(44,104,6,1,'2026-11-17 22:06:01',1,8),(45,98,6,1,'2026-11-17 22:06:01',1,8),(46,100,6,2,'2026-11-17 22:06:01',1,8),(47,113,6,2,'2026-11-17 22:06:54',1,9),(48,196,6,2,'2026-11-17 22:06:54',1,9),(49,109,6,1,'2026-11-17 22:06:54',1,9),(50,110,6,1,'2026-11-17 22:06:54',1,9),(51,133,6,1,'2026-11-17 22:06:54',1,9),(52,162,6,2,'2026-11-17 22:09:38',1,10),(53,168,6,1,'2026-11-18 03:20:25',1,11),(54,51,6,1,'2026-11-19 23:46:38',1,12),(55,56,6,1,'2026-11-19 23:46:38',1,12);
/*!40000 ALTER TABLE `historial_pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `id_inventario` int NOT NULL AUTO_INCREMENT,
  `id_componente` int NOT NULL,
  `cantidad` int NOT NULL DEFAULT '0',
  `ubicacion` varchar(10) NOT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_inventario`),
  KEY `id_componente` (`id_componente`),
  CONSTRAINT `inventario_ibfk_1` FOREIGN KEY (`id_componente`) REFERENCES `componentes` (`id_componente`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES (6,14,149,'A1',0.50),(7,15,120,'A1',0.50),(8,18,199,'A1',0.50),(9,24,180,'A2',0.50),(10,27,100,'A2',0.60),(11,30,80,'A2',0.60),(12,37,25,'A3',8.50),(13,51,149,'B1',1.00),(14,53,79,'B1',1.50),(15,56,46,'B2',1.50),(16,59,67,'B2',2.50),(17,62,30,'B2',8.00),(18,72,100,'C1',1.00),(19,74,80,'C1',0.80),(20,75,39,'C1',2.50),(21,78,48,'C2',1.50),(22,85,98,'D1',0.80),(23,87,78,'D1',0.80),(24,89,70,'D1',1.20),(25,91,60,'D1',1.20),(26,92,29,'D2',3.50),(27,100,38,'E1',3.00),(28,98,49,'E1',2.50),(29,104,29,'E1',2.50),(30,108,15,'E2',12.00),(31,109,19,'E2',18.00),(32,110,14,'E2',20.00),(33,113,8,'E2',22.00),(34,116,30,'F1',5.00),(35,118,25,'F1',6.00),(36,119,20,'F1',8.00),(37,122,15,'F1',12.00),(38,123,12,'F2',25.00),(39,124,10,'F2',35.00),(40,126,40,'F2',3.50),(41,133,29,'G1',5.00),(42,137,19,'G1',8.00),(43,139,22,'G1',4.50),(44,141,13,'G2',25.00),(45,143,10,'H1',20.00),(46,144,12,'H1',25.00),(47,145,10,'H1',35.00),(48,147,15,'H2',30.00),(49,148,10,'H2',25.00),(50,151,8,'H2',40.00),(51,157,50,'I1',2.00),(52,159,24,'I1',5.00),(53,162,18,'I1',6.00),(54,166,28,'J1',8.00),(55,168,18,'J1',5.00),(56,174,12,'J2',12.00),(57,178,19,'K1',5.00),(58,180,17,'K1',8.00),(59,182,14,'K2',15.00),(60,186,39,'K2',2.50),(61,196,8,'K3',25.00),(62,203,8,'K3',85.00);
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id_pedido` int NOT NULL AUTO_INCREMENT,
  `id_empleado` int NOT NULL,
  `fecha_hora` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` enum('pendiente','cancelado','completado','retirado') DEFAULT 'pendiente',
  `comentarios` text,
  PRIMARY KEY (`id_pedido`),
  KEY `idx_empleado_estado` (`id_empleado`,`estado`),
  CONSTRAINT `fk_pedido_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,6,'2026-11-17 04:31:07','retirado',''),(2,6,'2026-11-17 04:59:57','retirado',''),(3,6,'2026-11-17 05:05:51','retirado',''),(4,6,'2026-11-17 05:12:28','retirado',''),(5,6,'2026-11-17 05:12:48','retirado',''),(6,6,'2026-11-17 14:14:20','retirado',''),(7,6,'2026-11-17 22:03:47','retirado',''),(8,6,'2026-11-17 22:06:01','retirado',''),(9,6,'2026-11-17 22:06:54','retirado',''),(10,6,'2026-11-17 22:09:38','retirado',''),(11,6,'2026-11-18 03:20:25','retirado',''),(12,6,'2026-11-19 23:46:38','retirado','');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'inventario_ct'
--

--
-- Dumping routines for database 'inventario_ct'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-21 19:45:28
