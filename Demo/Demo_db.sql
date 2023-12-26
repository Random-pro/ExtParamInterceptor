-- --------------------------------------------------------
-- 主机:                           localhost
-- 服务器版本:                        8.1.0 - MySQL Community Server - GPL
-- 服务器操作系统:                      Linux
-- HeidiSQL 版本:                  11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- 导出  表 live.a 结构
CREATE TABLE IF NOT EXISTS `a` (
  `id` int DEFAULT NULL,
  `value` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `update_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 正在导出表  live.a 的数据：~12 rows (大约)
DELETE FROM `a`;
/*!40000 ALTER TABLE `a` DISABLE KEYS */;
INSERT INTO `a` (`id`, `value`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
	(1, 'rt', NULL, NULL, NULL, NULL),
	(3, NULL, NULL, NULL, NULL, NULL),
	(4, NULL, NULL, NULL, NULL, NULL),
	(2, NULL, NULL, NULL, NULL, NULL),
	(5, NULL, NULL, NULL, NULL, NULL),
	(6, 'tt10011', NULL, NULL, NULL, NULL),
	(7, NULL, NULL, NULL, NULL, NULL),
	(8, '666', NULL, NULL, 'RANDOM-PRO', '2023-12-16 01:02:12'),
	(10, NULL, NULL, NULL, NULL, NULL),
	(11, NULL, NULL, NULL, NULL, NULL),
	(12, NULL, NULL, NULL, NULL, NULL),
	(13, '2w111', NULL, NULL, NULL, NULL),
	(321, 'VALUE1', NULL, NULL, NULL, NULL),
	(123, '888', 'RANDOM-PRO', '2023-12-25 10:49:09', 'RANDOM-PRO', '2023-12-25 11:57:42'),
	(123, '888', 'RANDOM-PRO', '2023-12-25 10:51:32', 'RANDOM-PRO', '2023-12-25 11:57:42'),
	(123, '888', 'RANDOM-PRO', '2023-12-25 10:51:48', 'RANDOM-PRO', '2023-12-25 11:57:42'),
	(123, '888', 'RANDOM-PRO', '2023-12-25 12:57:12', NULL, NULL),
	(123, '888', 'RANDOM-PRO', '2023-12-25 12:57:44', NULL, NULL);
/*!40000 ALTER TABLE `a` ENABLE KEYS */;

-- 导出  表 live.base 结构
CREATE TABLE IF NOT EXISTS `base` (
  `id` int NOT NULL AUTO_INCREMENT,
  `base_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `base_path` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_by` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 正在导出表  live.base 的数据：~2 rows (大约)
DELETE FROM `base`;
/*!40000 ALTER TABLE `base` DISABLE KEYS */;
INSERT INTO `base` (`id`, `base_name`, `base_path`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
	(1, 'baseName1', 'basePath1', 'sun_base', '2023-12-18 15:59:29', 'random_base', '2023-12-18 16:00:09'),
	(2, 'baseName2', 'basePath2', 'sun2_base', '2023-12-18 15:59:30', 'randompro_base', '2023-12-18 16:00:09');
/*!40000 ALTER TABLE `base` ENABLE KEYS */;

-- 导出  表 live.child 结构
CREATE TABLE IF NOT EXISTS `child` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `path` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  `create_by` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 正在导出表  live.child 的数据：~3 rows (大约)
DELETE FROM `child`;
/*!40000 ALTER TABLE `child` DISABLE KEYS */;
INSERT INTO `child` (`id`, `name`, `path`, `parent_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
	(1, 'childName1_1', 'childPath1_1', 1, 'sun11', '2023-12-18 15:58:58', 'random', '2023-12-18 15:59:19'),
	(2, 'childName1_2', 'childPath1_2', 1, 'sun12', '2023-12-18 15:58:59', 'RANDOM', '2023-12-18 15:59:20'),
	(3, 'childName2_1', 'childPath2_2', 2, 'sun21', '2023-12-18 15:59:00', 'randompro', '2023-12-18 15:59:21');
/*!40000 ALTER TABLE `child` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
