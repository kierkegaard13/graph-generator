CREATE DATABASE  IF NOT EXISTS `test` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `test`;
-- MySQL dump 10.13  Distrib 5.5.40, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: test
-- ------------------------------------------------------
-- Server version	5.5.40-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `abilities`
--

DROP TABLE IF EXISTS `abilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `abilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `cost` int(11) NOT NULL DEFAULT '0',
  `required_level` int(11) NOT NULL DEFAULT '0',
  `description` text,
  `scalable` int(11) NOT NULL DEFAULT '1',
  `scale` float NOT NULL DEFAULT '1',
  `standard` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abilities`
--

LOCK TABLES `abilities` WRITE;
/*!40000 ALTER TABLE `abilities` DISABLE KEYS */;
INSERT INTO `abilities` VALUES (1,'rew1',150,1,'It has a description',1,2,0);
/*!40000 ALTER TABLE `abilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chats`
--

DROP TABLE IF EXISTS `chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin_id` int(11) NOT NULL DEFAULT '-1',
  `live` int(11) NOT NULL DEFAULT '1',
  `details` text COLLATE utf8_unicode_ci,
  `raw_details` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'public',
  `upvotes` int(11) NOT NULL DEFAULT '0',
  `downvotes` int(11) NOT NULL DEFAULT '0',
  `link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `site_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `views` int(11) NOT NULL DEFAULT '0',
  `removed` int(11) NOT NULL DEFAULT '0',
  `members` int(11) NOT NULL DEFAULT '0',
  `group` int(11) NOT NULL DEFAULT '0',
  `nsfw` int(11) NOT NULL DEFAULT '0',
  `pinned` int(11) NOT NULL DEFAULT '0',
  `seen` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats`
--

LOCK TABLES `chats` WRITE;
/*!40000 ALTER TABLE `chats` DISABLE KEYS */;
INSERT INTO `chats` VALUES (1,'A new test chat','Omnium',1,1,NULL,NULL,'2014-01-12 05:59:23','2015-02-05 01:09:34','open',0,0,NULL,NULL,NULL,57,1,0,0,0,0,1),(2,'A test chat','Omnium',1,0,'','','2014-01-12 22:02:41','2015-03-10 19:24:23','public',0,0,NULL,NULL,NULL,955,0,0,0,0,0,1),(3,'Testing images','Omnium',1,1,'Just a test description with some <em>markdown</em> basics in it and a link<br />\nto the author of course <a class=\'chat_link\' href=\'\\/\\/mutualcog.com/u/Omnium\'>/u/Omnium</a><br />\nwhat happens if I put another line in here? <strong>hmmmm</strong>','Just a test description with some *markdown* basics in it and a link\r\nto the author of course /p/Omnium\r\nwhat happens if I put another line in here? **hmmmm**','2014-03-10 16:28:56','2015-03-10 19:56:03','public',0,0,'http://i.imgur.com/LJ8zguP.jpg','http://i.imgur.com/LJ8zguP.jpg','i.imgur.com',296,0,0,0,0,0,1),(4,'Testing the advanced controls and stuff','Omnium',1,0,'Just a description <em>with</em> some markdown <a class=\'chat_link\' href=\'\\/\\/mutualcog.com/u/Omnium\'>/u/Omnium</a>','Just a description *with* some markdown /p/Omnium','2014-03-13 03:26:10','2015-03-10 19:55:40','public',100,0,NULL,NULL,NULL,45,0,0,0,0,0,1),(5,'Creating a static chat','Omnium',1,1,'Hello <a class=\'chat_link\' href=\'\\/\\/mutualcog.com/p/Omnium\'>@Omnium</a>','Hello @Omnium','2014-03-13 03:29:03','2014-08-05 04:46:07','public',0,0,NULL,NULL,NULL,459,1,0,0,0,0,1),(6,'testing static stuff','Omnium',1,1,'a chat about testing and stuff','a chat about testing and stuff','2014-03-13 03:37:28','2015-03-10 19:23:56','public',0,0,NULL,NULL,NULL,363,0,0,0,0,0,1),(8,'A second chat','Bob',4,1,'Stuff I need to look at','Stuff I need to look at','2014-04-06 20:35:38','2015-03-10 19:53:44','public',0,0,NULL,NULL,NULL,501,0,0,0,0,1,1),(11,'Spam and stuff','Omnium',1,1,'lots of spam','lots of spam','2014-09-03 17:50:50','2014-10-31 22:11:06','public',0,0,'http://imgur.com/gallery/jOnfC','//i.imgur.com/RVrn058.jpg?1','imgur.com',13,0,0,0,0,0,1),(12,'Lots and lots of philosophy','Omnium',1,1,'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<strong>aaaaaaaaaa</strong>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa','aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa**aaaaaaaaaa**aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa','2014-10-16 18:07:13','2015-02-09 21:14:38','public',0,0,NULL,NULL,NULL,133,0,0,0,0,0,1),(13,'High level thought','Omnium',1,1,'Blah de blah de existentialism blah','Blah de blah de existentialism blah','2014-10-16 18:07:55','2014-11-27 20:59:19','public',0,0,NULL,NULL,NULL,2,0,0,0,1,0,1),(14,'My first post','Bob',2,1,'A post  about science and philosophy and math','A post  about science and philosophy and math','2014-10-17 19:19:26','2015-03-10 19:56:09','public',1,0,NULL,NULL,NULL,72,0,0,0,0,0,1),(16,'Kittenses','Omnium',1,1,'cuteness','cuteness','2014-10-22 01:31:05','2015-03-10 19:56:16','public',0,0,'http://www.youtube.com/watch?v=_zqn6FtdDGc','http://localhost/laravel/YouTube-logo-full_color.png','www.youtube.com',29,0,0,0,0,0,1),(17,'Testing a post with a really long title Testing a post with a really long title Testing a post with a really long title Testing a post with a really long title Testing a post with a really long title Testing a post with a really long title ','Omnium',1,1,'lots of words in this one','lots of words in this one','2015-02-05 23:46:53','2015-02-17 20:07:00','public',-1,1,'',NULL,NULL,39,0,0,0,0,0,1),(18,NULL,NULL,-1,1,NULL,NULL,'2015-03-19 01:35:00','2015-03-19 01:40:52','private',0,0,NULL,NULL,NULL,7,0,0,0,0,0,0);
/*!40000 ALTER TABLE `chats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chats_to_communities`
--

DROP TABLE IF EXISTS `chats_to_communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chats_to_communities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `community_id` int(11) NOT NULL,
  `removed` int(11) NOT NULL DEFAULT '0',
  `pinned` int(11) NOT NULL DEFAULT '0',
  `upvotes` int(11) NOT NULL DEFAULT '0',
  `downvotes` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`,`community_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats_to_communities`
--

LOCK TABLES `chats_to_communities` WRITE;
/*!40000 ALTER TABLE `chats_to_communities` DISABLE KEYS */;
INSERT INTO `chats_to_communities` VALUES (1,1,1,0,0,0,0),(2,2,2,0,1,0,0),(3,3,2,0,0,0,0),(4,4,2,0,0,0,0),(5,5,3,0,0,0,0),(6,5,4,0,0,0,0),(7,5,5,0,0,0,0),(8,6,6,0,0,0,0),(9,6,7,0,0,0,0),(10,6,8,0,0,0,0),(11,6,9,0,0,0,0),(12,8,10,0,0,0,0),(13,8,11,0,0,0,0),(14,8,12,0,0,0,0),(15,8,13,0,0,0,0),(18,11,1,0,0,0,0),(19,12,1,0,0,0,0),(20,13,1,0,0,0,0),(21,14,1,0,0,0,0),(23,16,1,0,0,0,0),(25,18,1,0,0,0,0),(26,19,1,0,0,0,0),(27,20,1,0,0,0,0),(28,21,1,0,0,0,0),(29,22,1,0,0,0,0),(30,1,1,0,0,0,0),(31,2,2,0,0,0,0),(32,3,1,0,0,0,0),(33,4,1,0,0,0,0),(34,5,1,0,0,0,0),(35,6,1,0,1,0,0),(36,7,1,0,0,0,0),(37,8,1,0,0,0,0),(41,11,15,0,0,0,0),(42,12,4,0,0,0,0),(43,13,3,0,0,0,0),(44,14,5,0,0,0,0),(45,14,6,0,0,1,0),(47,16,16,0,0,0,0),(48,17,1,0,0,-1,1);
/*!40000 ALTER TABLE `chats_to_communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chats_voted`
--

DROP TABLE IF EXISTS `chats_voted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chats_voted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats_voted`
--

LOCK TABLES `chats_voted` WRITE;
/*!40000 ALTER TABLE `chats_voted` DISABLE KEYS */;
INSERT INTO `chats_voted` VALUES (1,12,1,1,'2014-10-16 18:07:13','2014-10-24 16:45:27'),(2,13,1,1,'2014-10-16 18:07:55','2014-10-16 18:07:55'),(3,14,2,1,'2014-10-17 19:19:26','2014-10-17 19:19:26'),(4,15,1,1,'2014-10-22 01:15:57','2014-10-22 01:15:57'),(5,16,1,1,'2014-10-22 01:31:05','2014-10-22 01:31:05'),(6,6,1,0,'2014-10-24 16:27:53','2014-10-24 16:45:18'),(7,17,1,-1,'2014-10-29 19:06:10','2015-02-10 23:56:28'),(9,14,1,1,'2015-02-10 23:27:31','2015-02-10 23:27:31');
/*!40000 ALTER TABLE `chats_voted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communities`
--

DROP TABLE IF EXISTS `communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `popularity` int(11) NOT NULL DEFAULT '1',
  `admin` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `admin_id` int(11) NOT NULL DEFAULT '0',
  `description` text COLLATE utf8_unicode_ci,
  `info` text COLLATE utf8_unicode_ci,
  `raw_info` text COLLATE utf8_unicode_ci,
  `nsfw` int(11) NOT NULL DEFAULT '0',
  `concept_id` int(11) NOT NULL,
  `tier` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tag` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communities`
--

LOCK TABLES `communities` WRITE;
/*!40000 ALTER TABLE `communities` DISABLE KEYS */;
INSERT INTO `communities` VALUES (1,'testing',NULL,'2015-02-10 23:56:28',21,'Omnium',0,'','<strong>General Info</strong><br />\nA community for:</p>\n<ol>\n<li>testing</li>\n<li>more testing</li>\n<li>even more testing</li>\n</ol>','**General Info**\r\nA community for:\r\n1. testing\r\n2. more testing\r\n3. even more testing\r\n\r\n\r\n\r\n',0,0,0),(2,'test',NULL,'2014-08-25 23:36:20',4,'Omnium',0,'','','',0,0,0),(3,'science',NULL,'2014-10-16 18:07:55',2,'Omnium',0,NULL,NULL,'',0,0,0),(4,'philosophy',NULL,'2014-10-24 16:45:27',1,'0',0,NULL,NULL,'',0,0,0),(5,'nature',NULL,'2015-02-10 23:27:31',2,'0',0,NULL,NULL,'',0,0,0),(6,'something',NULL,'2015-02-10 23:27:31',2,'0',0,NULL,NULL,'',0,0,0),(7,'technology',NULL,'2014-10-24 16:45:16',0,'0',0,NULL,NULL,'',0,0,0),(8,'physics',NULL,'2014-10-24 16:45:16',0,'0',0,NULL,NULL,'',0,0,0),(9,'probability',NULL,'2014-10-24 16:45:16',0,'0',0,NULL,NULL,'',0,0,0),(10,'asfasdfasdfasdf',NULL,NULL,0,'0',0,NULL,NULL,'',0,0,0),(11,'asffdsweffdwe',NULL,NULL,0,'0',0,NULL,NULL,'',0,0,0),(12,'sdfwefdsasdfwf',NULL,NULL,0,'0',0,NULL,NULL,'',0,0,0),(13,'sdfewfasdwef',NULL,NULL,0,'0',0,NULL,NULL,'',0,0,0),(14,'asdfsdfdsfewdffs',NULL,NULL,0,'0',0,NULL,NULL,'',0,0,0),(15,'spam','2014-09-03 17:28:47','2014-09-03 17:50:50',3,'0',0,NULL,NULL,NULL,0,0,0),(16,'aww','2014-10-22 01:15:57','2014-10-22 01:31:05',2,'0',0,NULL,NULL,NULL,0,0,0),(17,'tag','2014-10-29 19:06:10','2014-10-29 19:06:10',1,'0',0,NULL,NULL,NULL,0,0,0);
/*!40000 ALTER TABLE `communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `concepts`
--

DROP TABLE IF EXISTS `concepts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `concepts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concepts`
--

LOCK TABLES `concepts` WRITE;
/*!40000 ALTER TABLE `concepts` DISABLE KEYS */;
/*!40000 ALTER TABLE `concepts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entities_to_concepts`
--

DROP TABLE IF EXISTS `entities_to_concepts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entities_to_concepts` (
  `id` int(11) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `concept_id` int(11) NOT NULL,
  `entity_type` varchar(255) NOT NULL DEFAULT 'user',
  `similarity` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `concept_idx` (`concept_id`),
  KEY `entity_idx` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entities_to_concepts`
--

LOCK TABLES `entities_to_concepts` WRITE;
/*!40000 ALTER TABLE `entities_to_concepts` DISABLE KEYS */;
/*!40000 ALTER TABLE `entities_to_concepts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interaction_users`
--

DROP TABLE IF EXISTS `interaction_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `interaction_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `friended` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `bond` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`),
  KEY `interaction_idx` (`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interaction_users`
--

LOCK TABLES `interaction_users` WRITE;
/*!40000 ALTER TABLE `interaction_users` DISABLE KEYS */;
INSERT INTO `interaction_users` VALUES (1,1,2,0,1,'2014-10-09 14:51:00','2015-03-19 01:35:05',0.91),(2,2,1,0,1,'2015-02-10 23:27:31','2015-02-10 23:27:31',0.72),(3,2,3,0,1,'2014-10-20 18:57:30','2015-02-03 23:32:17',0.7),(4,3,2,0,1,'2014-10-20 18:57:30','2014-10-20 18:58:18',1);
/*!40000 ALTER TABLE `interaction_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text COLLATE utf8_unicode_ci NOT NULL,
  `chat_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `responseto` int(11) NOT NULL,
  `parent` int(11) NOT NULL DEFAULT '0',
  `y_dim` int(11) NOT NULL DEFAULT '0',
  `res_num` int(11) NOT NULL DEFAULT '0',
  `responses` int(11) NOT NULL DEFAULT '0',
  `author` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `serial` int(11) DEFAULT NULL,
  `upvotes` int(11) NOT NULL DEFAULT '0',
  `downvotes` int(11) NOT NULL DEFAULT '0',
  `path` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'public',
  `raw_message` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`,`user_id`),
  KEY `member_idx` (`user_id`),
  KEY `responseto` (`responseto`),
  KEY `author` (`author`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'<em>This message has been deleted</em>',8,1,'2015-02-05 20:56:23','2015-02-05 20:56:23',0,0,0,0,0,'Omnium',29298943,0,0,'0.00000001','public',''),(2,'<em>This message has been deleted</em>',8,1,'2015-02-05 20:57:02','2015-02-05 20:57:02',0,0,0,0,0,'Omnium',29298943,0,0,'0.00000002','public',''),(3,'<em>This message has been deleted</em>',8,1,'2015-02-05 21:01:32','2015-02-05 21:01:32',0,0,0,0,0,'Omnium',29298943,0,0,'0.00000003','public',''),(4,'<em>This message has been deleted</em>',8,1,'2015-02-05 21:02:35','2015-02-05 21:02:35',0,0,0,0,0,'Omnium',29298943,0,0,'0.00000004','public',''),(5,'<em>This message has been deleted</em>',8,1,'2015-02-05 21:05:51','2015-02-05 21:05:51',0,0,0,0,0,'Omnium',29298943,0,0,'0.00000005','public',''),(6,'<em>This message has been deleted</em>',8,1,'2015-02-05 21:06:29','2015-02-05 21:06:29',0,0,0,0,0,'Omnium',29298943,0,0,'0.00000006','public',''),(7,'<em>This message has been deleted</em>',8,1,'2015-02-05 21:07:18','2015-02-05 21:07:18',0,0,0,0,0,'Omnium',29298943,0,0,'0.00000007','public',''),(8,'<em>This message has been deleted</em>',8,1,'2015-02-05 21:08:14','2015-02-05 21:08:14',0,0,0,0,0,'Omnium',29298943,0,0,'0.00000008','public',''),(9,'<em>This message has been deleted</em>',8,1,'2015-02-05 21:10:48','2015-02-05 21:10:48',0,0,0,0,0,'Omnium',29298943,0,0,'0.00000009','public',''),(10,'testing',4,1,'2015-02-05 23:23:44','2015-02-05 23:30:35',0,0,0,0,1,'Omnium',41473384,0,0,'0.00000010','public',''),(11,'more testing',4,1,'2015-02-05 23:30:35','2015-02-05 23:30:35',10,10,1,1,0,'Omnium',41473384,0,0,'0.00000010.00000011','public',''),(12,'test1',6,1,'2015-02-12 20:07:36','2015-02-12 20:07:36',0,0,0,0,0,'Omnium',21260305,0,0,'0.00000012','public',''),(13,'test2',6,1,'2015-02-12 20:07:38','2015-02-12 20:07:38',0,0,0,0,0,'Omnium',21260305,0,0,'0.00000013','public',''),(14,'test3',6,1,'2015-02-12 20:07:40','2015-02-12 20:07:40',0,0,0,0,0,'Omnium',21260305,0,0,'0.00000014','public',''),(15,'a static test message',2,1,'2015-02-12 20:25:20','2015-02-12 20:44:09',0,0,0,0,1,'Omnium',21260305,0,0,'0.00000015','public',''),(16,'a static reply',2,1,'2015-02-12 20:44:09','2015-02-12 20:51:16',15,15,1,1,1,'Omnium',21260305,0,0,'0.00000015.00000016','public',''),(17,'a third tier reply',2,1,'2015-02-12 20:51:16','2015-02-12 20:51:16',16,15,2,1,0,'Omnium',21260305,0,0,'0.00000015.00000016.00000017','public',''),(18,'&amp;gt;blockquotes<br />\n&amp;gt;are<br />\n&amp;gt;interesting',2,1,'2015-02-12 20:51:54','2015-02-12 20:51:54',0,0,0,0,0,'Omnium',21260305,0,0,'0.00000018','public',''),(19,'<strong>some</strong> markdown',2,1,'2015-02-12 20:52:34','2015-02-12 20:52:34',0,0,0,0,0,'Omnium',21260305,0,0,'0.00000019','public',''),(20,'<strong>some</strong> markdown',2,1,'2015-02-12 20:55:35','2015-02-12 20:55:35',0,0,0,0,0,'Omnium',21260305,0,0,'0.00000020','public','**some** markdown'),(21,'<strong>some</strong> markdown',2,1,'2015-02-12 20:56:19','2015-02-12 20:56:19',0,0,0,0,0,'Omnium',21260305,0,0,'0.00000021','public','**some** markdown'),(22,'&amp;gt;maybe\n&amp;gt;blockquotes\n&amp;gt;work?',2,1,'2015-02-12 21:06:23','2015-02-12 21:06:23',0,0,0,0,0,'Omnium',21260305,0,0,'0.00000022','public','&gt;maybe\r\n&gt;blockquotes\r\n&gt;work?'),(23,'gotta test',17,1,'2015-02-12 23:33:57','2015-02-12 23:33:57',0,0,0,0,0,'Omnium',37357277,0,0,'0.00000023','public',''),(24,'some',17,1,'2015-02-12 23:33:58','2015-02-12 23:33:58',0,0,0,0,0,'Omnium',37357277,0,0,'0.00000024','public',''),(25,'messages',17,1,'2015-02-12 23:34:00','2015-02-12 23:34:00',0,0,0,0,1,'Omnium',37357277,0,0,'0.00000025','public',''),(26,'testing',17,2,'2015-02-12 23:39:39','2015-02-12 23:39:39',0,0,0,0,1,'Bob',37357277,0,0,'0.00000026','public',''),(27,'test',17,1,'2015-02-12 23:46:32','2015-02-12 23:46:32',0,0,0,0,0,'Omnium',37357277,0,0,'0.00000027','public',''),(28,'more test',17,1,'2015-02-12 23:47:24','2015-02-12 23:47:24',0,0,0,0,0,'Omnium',37357277,0,0,'0.00000028','public',''),(29,'test',17,1,'2015-02-13 00:01:54','2015-02-13 00:01:54',0,0,0,0,0,'Omnium',37357277,0,0,'0.00000029','public',''),(30,'hey bob',17,1,'2015-02-13 00:02:29','2015-02-13 00:02:29',26,26,1,1,0,'Omnium',37357277,0,0,'0.00000026.00000030','public',''),(31,'test',17,1,'2015-02-13 00:12:45','2015-02-13 00:12:45',25,25,1,1,1,'Omnium',37357277,0,0,'0.00000025.00000031','public',''),(32,'more testing',17,1,'2015-02-13 00:13:13','2015-02-13 00:13:13',31,25,2,1,0,'Omnium',37357277,0,0,'0.00000025.00000031.00000032','public',''),(33,'hello world',4,1,'2015-02-17 20:17:31','2015-02-17 20:17:31',0,0,0,0,0,'Omnium',168632806,0,0,'0.00000033','public','hello world'),(34,'test',4,1,'2015-02-17 20:26:34','2015-02-17 20:26:34',0,0,0,0,0,'Omnium',168632806,0,0,'0.00000034','public','test'),(35,'test',8,51,'2015-03-10 19:43:24','2015-03-10 19:43:24',0,0,0,0,0,'148557453',148557453,0,0,'0.00000035','public',''),(36,'reply',8,50,'2015-03-10 19:43:31','2015-03-10 19:43:31',0,0,0,0,1,'49314861',49314861,0,0,'0.00000036','public',''),(37,'a reply to a reply',8,51,'2015-03-10 19:43:39','2015-03-10 19:43:39',36,36,1,1,0,'148557453',148557453,0,0,'0.00000036.00000037','public',''),(38,'test\n',18,1,'2015-03-19 01:35:05','2015-03-19 01:35:05',0,0,0,0,0,'Omnium',NULL,0,0,'0','public',''),(39,'test',18,1,'2015-03-19 01:40:49','2015-03-19 01:40:49',0,0,0,0,0,'Omnium',69691946,0,0,'0.00000039','public','');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages_voted`
--

DROP TABLE IF EXISTS `messages_voted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages_voted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages_voted`
--

LOCK TABLES `messages_voted` WRITE;
/*!40000 ALTER TABLE `messages_voted` DISABLE KEYS */;
INSERT INTO `messages_voted` VALUES (1,1,1,1,'2014-12-31 17:56:50','2014-12-31 17:56:50'),(2,2,2,1,'2014-12-31 18:06:47','2014-12-31 18:06:47'),(3,3,2,1,'2014-12-31 18:06:48','2014-12-31 18:06:48'),(4,4,2,1,'2014-12-31 18:06:49','2014-12-31 18:06:49'),(5,5,2,1,'2014-12-31 18:06:50','2014-12-31 18:06:50'),(6,6,2,1,'2014-12-31 18:06:51','2014-12-31 18:06:51'),(7,7,2,1,'2014-12-31 18:06:52','2014-12-31 18:06:52'),(8,8,2,1,'2014-12-31 18:06:53','2014-12-31 18:06:53'),(9,9,2,1,'2014-12-31 18:06:55','2014-12-31 18:06:55'),(10,10,2,1,'2014-12-31 18:06:56','2014-12-31 18:06:56'),(11,11,2,1,'2014-12-31 18:06:57','2014-12-31 18:06:57'),(12,12,2,1,'2014-12-31 18:06:59','2014-12-31 18:06:59'),(13,13,2,1,'2014-12-31 18:07:01','2014-12-31 18:07:01'),(14,14,2,1,'2014-12-31 18:07:25','2014-12-31 18:07:25'),(15,15,2,1,'2014-12-31 18:07:41','2014-12-31 18:07:41'),(16,16,2,1,'2015-01-01 16:04:09','2015-01-01 16:04:09'),(17,17,2,1,'2015-01-01 16:07:40','2015-01-01 16:07:40'),(18,18,2,1,'2015-01-01 16:11:14','2015-01-01 16:11:14'),(19,19,2,1,'2015-01-01 16:25:24','2015-01-01 16:25:24'),(20,20,2,1,'2015-01-01 16:25:30','2015-01-01 16:25:30'),(21,21,2,1,'2015-01-01 16:25:49','2015-01-01 16:25:49'),(22,22,1,1,'2015-02-03 23:06:04','2015-02-03 23:06:04'),(23,23,1,1,'2015-02-03 23:09:56','2015-02-03 23:09:56'),(24,28,1,1,'2015-02-03 23:31:56','2015-02-03 23:31:56'),(25,29,1,1,'2015-02-03 23:32:41','2015-02-03 23:32:41'),(26,30,1,1,'2015-02-03 23:32:59','2015-02-03 23:32:59'),(27,31,1,1,'2015-02-03 23:40:57','2015-02-05 20:48:53'),(28,32,1,1,'2015-02-03 23:58:57','2015-02-03 23:58:57'),(29,33,1,1,'2015-02-04 00:00:49','2015-02-04 00:00:49'),(30,34,1,1,'2015-02-04 00:02:18','2015-02-04 00:02:18'),(31,35,1,1,'2015-02-05 20:49:45','2015-02-05 20:49:45'),(32,1,1,1,'2015-02-05 20:56:23','2015-02-05 20:56:23'),(33,2,1,1,'2015-02-05 20:57:02','2015-02-05 20:57:02'),(34,3,1,1,'2015-02-05 21:01:32','2015-02-05 21:01:32'),(35,4,1,1,'2015-02-05 21:02:35','2015-02-05 21:02:35'),(36,5,1,1,'2015-02-05 21:05:51','2015-02-05 21:05:51'),(37,6,1,1,'2015-02-05 21:06:29','2015-02-05 21:06:29'),(38,7,1,1,'2015-02-05 21:07:18','2015-02-05 21:07:18'),(39,8,1,1,'2015-02-05 21:08:14','2015-02-05 21:08:14'),(40,9,1,1,'2015-02-05 21:10:48','2015-02-05 21:10:48'),(41,10,1,1,'2015-02-05 23:23:44','2015-02-05 23:23:44'),(42,11,1,1,'2015-02-05 23:30:35','2015-02-05 23:30:35'),(43,12,1,1,'2015-02-12 20:07:37','2015-02-12 20:07:37'),(44,13,1,1,'2015-02-12 20:07:39','2015-02-12 20:07:39'),(45,14,1,1,'2015-02-12 20:07:40','2015-02-12 20:07:40'),(46,15,1,1,'2015-02-12 20:25:20','2015-02-12 20:25:20'),(47,16,1,1,'2015-02-12 20:44:09','2015-02-12 20:44:09'),(48,17,1,1,'2015-02-12 20:51:16','2015-02-12 20:51:16'),(49,18,1,1,'2015-02-12 20:51:54','2015-02-12 20:51:54'),(50,19,1,1,'2015-02-12 20:52:34','2015-02-12 20:52:34'),(51,20,1,1,'2015-02-12 20:55:35','2015-02-12 20:55:35'),(52,22,1,1,'2015-02-12 21:06:23','2015-02-12 21:06:23'),(53,23,1,1,'2015-02-12 23:33:57','2015-02-12 23:33:57'),(54,24,1,1,'2015-02-12 23:33:58','2015-02-12 23:33:58'),(55,25,1,1,'2015-02-12 23:34:00','2015-02-12 23:34:00'),(56,26,2,1,'2015-02-12 23:39:39','2015-02-12 23:39:39'),(57,27,1,1,'2015-02-12 23:46:32','2015-02-12 23:46:32'),(58,28,1,1,'2015-02-12 23:47:24','2015-02-12 23:47:24'),(59,29,1,1,'2015-02-13 00:01:54','2015-02-13 00:01:54'),(60,30,1,1,'2015-02-13 00:02:29','2015-02-13 00:02:29'),(61,31,1,1,'2015-02-13 00:12:45','2015-02-13 00:12:45'),(62,32,1,1,'2015-02-13 00:13:13','2015-02-13 00:13:13'),(63,33,1,1,'2015-02-17 20:17:31','2015-02-17 20:17:31'),(64,34,1,1,'2015-02-17 20:26:34','2015-02-17 20:26:34'),(65,39,1,1,'2015-03-19 01:40:49','2015-03-19 01:40:49');
/*!40000 ALTER TABLE `messages_voted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `migration` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node_auth`
--

DROP TABLE IF EXISTS `node_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `serial_id` int(11) NOT NULL,
  `sid` text NOT NULL,
  `authorized` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `node_auth`
--

LOCK TABLES `node_auth` WRITE;
/*!40000 ALTER TABLE `node_auth` DISABLE KEYS */;
INSERT INTO `node_auth` VALUES (10,1,'Omnium','49314861',50,'16b530d3e12de8a5ccc17c5afcf88eb25fc2ee0d',1),(11,1,'Omnium','254520258',52,'8c7623f49ca6188181b488e3395b3371c0a28e5a',1),(12,1,'Omnium','236122253',53,'d1f78b076f71e9024cbf15f6fc9fb61987c6d9fb',1),(13,1,'Omnium','261311829',54,'7aafa0a03aa4ee40c6b055e2fb0bdc564b251008',1),(14,1,'Omnium','69691946',55,'5047ce13e728b02435b39e8aec412302312b7015',1);
/*!40000 ALTER TABLE `node_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT '0',
  `global_type` varchar(255) DEFAULT NULL,
  `message` text,
  `seen` int(11) NOT NULL DEFAULT '0',
  `sender_id` int(11) NOT NULL DEFAULT '0',
  `sender` varchar(255) DEFAULT NULL,
  `sender_type` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,'2015-03-19 03:25:39','2015-03-19 03:25:39',3,2,NULL,'<div class=\'request_cont\'> <div class=\'request_text\'> <a class=\'chat_link\' href=\'//mutualcog.com/u/Omnium\'>Omnium</a> has requested your friendship </div> <div class=\'request_text\'> <a class=\'chat_link accept_request\' id=\'accept_friendship_1\' href=\'//mutualcog.com/profile/accept/1\'>Accept</a> / <a class=\'chat_link decline_request\' id=\'decline_friendship_1\' href=\'//mutualcog.com/profile/decline/1\'>Decline</a> </div> </div>',0,1,'Omnium',0);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serials`
--

DROP TABLE IF EXISTS `serials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_post` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `ip_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `welcomed` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serials`
--

LOCK TABLES `serials` WRITE;
/*!40000 ALTER TABLE `serials` DISABLE KEYS */;
INSERT INTO `serials` VALUES (1,104085737,'2014-12-29 00:37:15','2014-12-29 00:37:15','0','127.0.0.1',0),(2,19740191,'2014-12-30 01:32:29','2014-12-30 01:32:29','0','127.0.0.1',0),(3,28062106,'2014-12-30 18:43:22','2014-12-30 19:31:30','0','127.0.0.1',0),(4,222120717,'2014-12-30 20:52:11','2014-12-30 21:27:13','0','127.0.0.1',0),(5,181413442,'2014-12-30 20:52:38','2014-12-30 21:23:05','0','127.0.0.1',0),(6,53045638,'2014-12-31 17:44:24','2014-12-31 17:56:50','0','127.0.0.1',0),(7,36529634,'2014-12-31 18:04:40','2014-12-31 18:07:41','0','127.0.0.1',0),(8,25934691,'2014-12-31 22:06:58','2014-12-31 22:06:58','0','127.0.0.1',0),(9,223861519,'2015-01-01 15:36:53','2015-01-01 16:25:49','0','127.0.0.1',0),(10,229825087,'2015-01-21 21:33:38','2015-01-21 21:33:38','0','127.0.0.1',0),(11,115711051,'2015-01-22 23:06:51','2015-01-22 23:06:51','0','127.0.0.1',0),(12,227847438,'2015-01-27 20:03:42','2015-01-27 20:03:42','0','127.0.0.1',0),(13,247959843,'2015-01-28 20:24:48','2015-01-28 20:24:48','0','127.0.0.1',0),(14,101264493,'2015-01-28 21:09:51','2015-01-28 21:09:51','0','127.0.0.1',0),(15,233935849,'2015-01-28 21:09:52','2015-01-28 21:09:52','0','127.0.0.1',0),(16,14857961,'2015-01-29 20:07:08','2015-01-29 20:07:08','0','127.0.0.1',0),(17,218440419,'2015-01-29 20:55:00','2015-01-29 20:55:00','0','127.0.0.1',0),(18,185002141,'2015-02-03 23:04:28','2015-02-04 00:02:18','0','127.0.0.1',0),(19,100116974,'2015-02-03 23:32:17','2015-02-03 23:32:17','0','127.0.0.1',0),(20,53016195,'2015-02-05 00:53:06','2015-02-05 00:53:06','0','127.0.0.1',0),(21,29298943,'2015-02-05 20:04:39','2015-02-05 21:10:48','0','127.0.0.1',0),(22,145227891,'2015-02-05 20:04:39','2015-02-05 20:04:39','0','127.0.0.1',0),(23,41473384,'2015-02-05 23:03:11','2015-02-05 23:46:53','2015-02-05T23:46:53+00:00','127.0.0.1',0),(24,229794598,'2015-02-09 21:14:38','2015-02-09 21:14:38','0','127.0.0.1',0),(25,170765496,'2015-02-10 20:08:05','2015-02-10 20:08:05','0','127.0.0.1',0),(26,141320844,'2015-02-10 23:05:17','2015-02-10 23:05:17','0','127.0.0.1',0),(27,21260305,'2015-02-12 20:06:58','2015-02-12 20:07:40','0','127.0.0.1',0),(28,197821656,'2015-02-12 23:02:26','2015-02-12 23:02:26','0','127.0.0.1',0),(29,263260704,'2015-02-12 23:02:45','2015-02-12 23:02:45','0','127.0.0.1',0),(30,56863335,'2015-02-12 23:03:20','2015-02-12 23:03:20','0','127.0.0.1',0),(31,74803178,'2015-02-12 23:03:39','2015-02-12 23:03:39','0','127.0.0.1',0),(32,229027714,'2015-02-12 23:03:54','2015-02-12 23:03:54','0','127.0.0.1',0),(33,259439270,'2015-02-12 23:04:17','2015-02-12 23:04:17','0','127.0.0.1',0),(34,3692141,'2015-02-12 23:05:12','2015-02-12 23:05:12','0','127.0.0.1',0),(35,64781515,'2015-02-12 23:06:14','2015-02-12 23:06:14','0','127.0.0.1',0),(36,159169871,'2015-02-12 23:06:29','2015-02-12 23:06:29','0','127.0.0.1',0),(37,210087985,'2015-02-12 23:06:41','2015-02-12 23:06:41','0','127.0.0.1',0),(38,147808949,'2015-02-12 23:09:12','2015-02-12 23:09:12','0','127.0.0.1',0),(39,194947784,'2015-02-12 23:09:47','2015-02-12 23:09:47','0','127.0.0.1',0),(40,210037859,'2015-02-12 23:10:08','2015-02-12 23:10:08','0','127.0.0.1',0),(41,35448596,'2015-02-12 23:10:29','2015-02-12 23:10:29','0','127.0.0.1',0),(42,160021700,'2015-02-12 23:10:50','2015-02-12 23:10:50','0','127.0.0.1',0),(43,37357277,'2015-02-12 23:20:52','2015-02-13 00:13:13','0','127.0.0.1',0),(44,168632806,'2015-02-17 20:06:08','2015-02-17 20:06:08','0','127.0.0.1',0),(45,74469231,'2015-02-17 23:14:59','2015-02-17 23:14:59','0','127.0.0.1',0),(46,79607796,'2015-02-19 23:06:55','2015-02-19 23:06:55','0','127.0.0.1',0),(47,133883944,'2015-03-10 19:03:38','2015-03-10 19:03:38','0','127.0.0.1',0),(48,93771155,'2015-03-10 19:03:38','2015-03-10 19:03:38','0','127.0.0.1',0),(49,126273256,'2015-03-10 19:03:40','2015-03-10 19:03:40','0','127.0.0.1',0),(50,49314861,'2015-03-10 19:03:41','2015-03-10 19:43:31','0','127.0.0.1',0),(51,148557453,'2015-03-10 19:43:07','2015-03-10 19:43:39','0','127.0.0.1',0),(52,254520258,'2015-03-19 01:09:19','2015-03-19 01:09:19','0','127.0.0.1',0),(53,236122253,'2015-03-19 01:09:20','2015-03-19 01:09:20','0','127.0.0.1',0),(54,261311829,'2015-03-19 01:09:20','2015-03-19 01:09:20','0','127.0.0.1',0),(55,69691946,'2015-03-19 01:09:21','2015-03-19 01:40:49','0','127.0.0.1',0);
/*!40000 ALTER TABLE `serials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `serial_id` int(11) NOT NULL DEFAULT '0',
  `cognizance` int(11) NOT NULL DEFAULT '0',
  `total_cognizance` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `next_level` int(11) NOT NULL DEFAULT '120',
  `last_login` datetime NOT NULL,
  `is_admin` int(11) NOT NULL DEFAULT '0',
  `page` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'home',
  `chat_id` int(11) NOT NULL DEFAULT '0',
  `anonymous` int(11) NOT NULL DEFAULT '0',
  `evaluated` int(11) NOT NULL DEFAULT '1',
  `disconnecting` int(11) NOT NULL DEFAULT '0',
  `disconnect_time` datetime DEFAULT NULL,
  `online` int(11) NOT NULL DEFAULT '0',
  `ip_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `community_mod` int(11) NOT NULL DEFAULT '0',
  `community_admin` int(11) NOT NULL DEFAULT '0',
  `remember_token` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `passive` int(11) NOT NULL DEFAULT '0',
  `l_menu_status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`,`level`,`is_admin`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'2014-10-09 14:47:29','2015-03-19 03:25:42','Omnium','eyJpdiI6IndPMUExaVc1am1QVWh6RERrQmJaTkpJTnhCY1dLVXRBMnR6TUtPcUlEbXM9IiwidmFsdWUiOiJrNFpGanFHZ21YTUcyMVhxUmpGdW1XeUk5V1NYNlwvb2srdFBMd3NxbXFHVT0iLCJtYWMiOiJiNzZmOWNjMDUyOTUwNzBlNjFkOTBkN2Y1MWE4YzY1YjJkODY4NDUwNjc2NzIxZDFiYTNmMTBmMzAzMzA3NzE0In0=','vdyvdqva@sharklasers.com',55,270,409,1,300,'2015-03-10 19:51:45',1,'home',0,0,1,0,'2015-03-19 03:25:37',1,'127.0.0.1',0,0,'UR7F0QvjF8mvkVPun0FK1CTWuMG9GTriD8MSIBVf87hyIejuz7LkEI5X32qk',5,0),(2,'2014-10-09 14:50:28','2015-02-12 23:39:47','Bob','eyJpdiI6ImtuK1ZYWWs1TnBxNExodHkrUkNwXC90bytoNzNyNGtNMXZLalNmNlljQldJPSIsInZhbHVlIjoiaHpWUk1CQk5maGs0OFc3MjZWSVBJSVlqRVJyUEg1cDVjMEtSSzRhRnJKbz0iLCJtYWMiOiJiNTU4YzY4MzIzZGE3MzcwYjIxNmQxYmU5MDU5ZjM4Y2RmZDU4ZmE4MGQyOGUwYzFjNDJmN2ZhYmVhMjI1MjRiIn0=',NULL,43,33,35,0,120,'2015-02-12 23:39:27',0,'home',17,0,1,0,'2015-02-12 23:39:47',0,'127.0.0.1',0,0,'dKu9g7LjP1VWnweWlNXCsXEh30nqZZXWQzhzVgxxLHXofXKPdULRIAMxvONm',7,0),(3,'2014-10-09 18:24:23','2014-11-13 15:43:12','Test','eyJpdiI6IjVrTTB2blA0SGs4azI0ZEhPUEdlUEZFWjhcLzdcL2Qzc1lldzBKakFWMG4wWT0iLCJ2YWx1ZSI6IkhDTkxQNVhJYWZwK0ZZNWMwblRMR0xmWE1xd29CcUR0YVZnbEZsK25pbm89IiwibWFjIjoiOWE2OTlhODhlODZiNWRhNDgzNDAzOWRiODMxOTlkNTk4OWQ0ZjU2MmU1NzY2NGQ3N2I2ODQzNTY5NmQ3OGM5YiJ9',NULL,38,0,0,0,120,'2014-11-13 15:42:55',0,'home',0,0,1,1,'2014-11-13 15:43:13',0,'127.0.0.1',0,0,'OhJmYli0EQR6f3GM2z2LerHLuzIXOpPh62r7aXLbI1Hk0FUiIWOeZvJaAJk6',0,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_to_abilities`
--

DROP TABLE IF EXISTS `users_to_abilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_to_abilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `ability_id` int(11) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `unlocked` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_to_abilities`
--

LOCK TABLES `users_to_abilities` WRITE;
/*!40000 ALTER TABLE `users_to_abilities` DISABLE KEYS */;
INSERT INTO `users_to_abilities` VALUES (1,1,1,0,2,'2014-12-22 22:42:41','2014-12-24 00:16:39',1);
/*!40000 ALTER TABLE `users_to_abilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_to_chats`
--

DROP TABLE IF EXISTS `users_to_chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_to_chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_mod` int(11) DEFAULT NULL,
  `is_admin` int(11) DEFAULT NULL,
  `user` varchar(255) DEFAULT NULL,
  `active` int(11) NOT NULL DEFAULT '0',
  `banned` int(11) NOT NULL DEFAULT '0',
  `ip_address` varchar(255) DEFAULT NULL,
  `is_user` int(11) DEFAULT NULL,
  `live` int(11) NOT NULL DEFAULT '1',
  `visible` int(11) NOT NULL DEFAULT '1',
  `minimized` int(11) NOT NULL DEFAULT '0',
  `unseen` int(11) NOT NULL DEFAULT '0',
  `entity_id` int(11) DEFAULT NULL,
  `entity_type` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`,`user_id`),
  KEY `author` (`user`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_to_chats`
--

LOCK TABLES `users_to_chats` WRITE;
/*!40000 ALTER TABLE `users_to_chats` DISABLE KEYS */;
INSERT INTO `users_to_chats` VALUES (1,6,1,0,1,'Omnium',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(2,6,38,0,0,'198339714',0,0,'127.0.0.1',0,1,1,0,0,NULL,0),(3,6,2,0,0,'Bob',1,0,'127.0.0.1',1,1,1,0,0,NULL,0),(4,6,43,0,0,'134689452',1,0,'127.0.0.1',0,1,1,0,0,NULL,0),(5,8,1,0,0,'Omnium',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(6,8,44,0,0,'91166710',0,0,'127.0.0.1',0,1,1,0,0,NULL,0),(7,8,2,0,1,'Bob',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(8,16,2,0,0,'Bob',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(9,14,2,0,1,'Bob',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(10,13,2,0,0,'Bob',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(11,2,2,0,0,'Bob',0,0,'',0,1,1,0,0,NULL,0),(12,1,1,0,1,'Omnium',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(13,4,2,0,0,'Bob',0,0,'',0,0,1,0,0,NULL,0),(14,16,1,0,1,'Omnium',1,0,'127.0.0.1',1,1,1,0,0,NULL,0),(15,14,1,0,0,'Omnium',0,1,'127.0.0.1',1,1,1,0,0,NULL,0),(16,4,1,0,1,'Omnium',0,0,'',0,0,1,0,0,NULL,0),(17,4,1,0,1,'Omnium',0,0,'127.0.0.1',1,0,1,0,0,NULL,0),(18,17,1,0,1,'Omnium',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(19,12,1,0,1,'Omnium',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(20,2,1,0,1,'Omnium',0,0,'',0,1,1,0,0,NULL,0),(21,17,2,1,0,'Bob',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(22,17,43,0,0,'37357277',0,0,'127.0.0.1',0,1,1,0,0,NULL,0),(23,8,50,0,0,'49314861',0,0,'127.0.0.1',0,1,1,0,0,NULL,0),(24,8,51,0,0,'148557453',0,0,'127.0.0.1',0,1,1,0,0,NULL,0),(25,3,1,NULL,1,'Omnium',0,0,'127.0.0.1',1,1,1,0,0,NULL,0),(27,18,2,NULL,NULL,NULL,0,0,NULL,NULL,1,0,0,0,1,0),(29,18,1,NULL,NULL,'Omnium',0,0,'127.0.0.1',1,1,1,0,0,NULL,0);
/*!40000 ALTER TABLE `users_to_chats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_to_communities`
--

DROP TABLE IF EXISTS `users_to_communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_to_communities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `community_id` int(11) NOT NULL,
  `score` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_mod` int(11) NOT NULL DEFAULT '0',
  `is_admin` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_idx` (`user_id`),
  KEY `tag_idx` (`community_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_to_communities`
--

LOCK TABLES `users_to_communities` WRITE;
/*!40000 ALTER TABLE `users_to_communities` DISABLE KEYS */;
INSERT INTO `users_to_communities` VALUES (1,1,1,140,'2014-10-16 18:18:57','2015-02-17 20:26:04',0,1),(2,2,3,39,'2014-11-27 20:42:11','2015-01-29 20:13:53',0,1),(4,2,1,43,'2014-11-27 21:38:30','2015-01-29 20:13:36',0,0),(5,2,6,2,'2014-12-19 23:51:31','2014-12-19 23:51:31',0,0),(6,2,11,2,'2014-12-19 23:51:36','2014-12-19 23:51:36',0,0);
/*!40000 ALTER TABLE `users_to_communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_to_saved`
--

DROP TABLE IF EXISTS `users_to_saved`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_to_saved` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `saved_id` int(11) NOT NULL,
  `saved_type` varchar(255) NOT NULL DEFAULT 'chats',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_to_saved`
--

LOCK TABLES `users_to_saved` WRITE;
/*!40000 ALTER TABLE `users_to_saved` DISABLE KEYS */;
INSERT INTO `users_to_saved` VALUES (1,1,8,'chats','2015-02-10 20:30:34','2015-02-10 20:30:34'),(2,1,16,'chats','2015-02-10 20:30:38','2015-02-10 20:30:38'),(3,1,4,'chats','2015-02-17 20:26:49','2015-02-17 20:26:49');
/*!40000 ALTER TABLE `users_to_saved` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-03-18 22:27:26
