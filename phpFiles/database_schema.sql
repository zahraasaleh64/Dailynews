-- Database: 4717132_fatima
-- Host: fdb1032.awardspace.net

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `cid` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE IF NOT EXISTS `news` (
  `nid` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `content` TEXT NOT NULL,
  `image_url` VARCHAR(255) DEFAULT NULL,
  `published_date` DATETIME DEFAULT NULL,
  `cid` INT DEFAULT NULL,
  CONSTRAINT `fk_category` FOREIGN KEY (`cid`) REFERENCES `categories` (`cid`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
