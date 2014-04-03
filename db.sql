CREATE TABLE IF NOT EXISTS `admins` (
  `ckey` varchar(255) NOT NULL,
  `rank` int(2) NOT NULL,
  PRIMARY KEY  (`ckey`)
) DEFAULT CHARACTER=latin1;

CREATE TABLE `library` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `author` TEXT NOT NULL ,
  `title` TEXT NOT NULL ,
  `content` TEXT NOT NULL ,
  `category` TEXT NOT NULL ,
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER=latin1;
