SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `kapps_db` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `kapps_db`;

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `name` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `phone1` varchar(17) DEFAULT NULL,
  `phone2` varchar(17) DEFAULT NULL,
  `kapp_id` int(11) NOT NULL,
  `nivel` int(11) DEFAULT NULL,
  `estado` int(11) DEFAULT 1,
  `bloqueo` int(11) DEFAULT 0,
  `vigencia` int(11) DEFAULT 600,
  `password_reset` int(11) DEFAULT 0,
  `password2` blob DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

INSERT INTO `accounts` (`id`, `username`, `password`, `email`, `name`, `lastname`, `phone1`, `phone2`, `kapp_id`, `nivel`, `estado`, `bloqueo`, `vigencia`, `password_reset`, `password2`, `fecha_creacion`) VALUES
(3, 'kenny', 'testxkr', 'kenny_carcamo@hotmail.com', 'Kenny', 'rodriguez carcamo', NULL, NULL, 0, 1, 1, 0, 1800, 0, 0x2adf9e29423c5dcc234d7e1238759f46, '2026-02-13 21:02:48'),
(4, 'gerardo1', 'alejandra1', 'lajgtor@hotmail.com', 'Gerardo', 'Torres', NULL, NULL, 2, 1, 1, 0, 7200, 0, 0xc362f5cbca8614b1a5a80a3a2e37c44e, '2026-02-13 21:02:48'),
(5, 'kenny3', 'testxkr', 'kenny_carcamo@hotmail.com', 'Kenny', 'rodriguez carcamo', NULL, NULL, 3, 1, 2, 0, 600, 0, 0xfea04175f39ed399cf9358ade78d7691, '2026-02-13 21:02:48'),
(6, 'josue', 'lcsv&30', 'josue_ing89@hotmail.com', 'Josué', 'Rodríguez', NULL, NULL, 3, 1, 0, 0, 600, 0, 0x862d6237bc7a7a1039f22c5af0953f74, '2026-02-13 21:02:48'),
(8, 'alejandra1', 'gerardo1', 'lajgtor@hotmail.com', 'Alejandra', 'Torres', NULL, NULL, 2, 1, 0, 0, 3000, 0, 0x76f96213aa6765f121cd542d99f072b2, '2026-02-13 21:02:48'),
(9, 'oscar1', 'Ovsd2020', 'kenny_carcamo@hotmail.com', 'Oscar', 'Alfaro', '50689199259', NULL, 2, 2, 0, 0, 600, 0, 0xeedce447b89c40d50bc1f46625fc9f4e, '2026-02-13 21:02:48'),
(10, 'wesly1', 'wwtof20', 'westalleralajuela@gmail.com', 'Wesly', 'Torres', '50687938023', NULL, 2, 2, 1, 1, 7200, 0, 0x8a34739838cc8d54e234541a2f998ff5, '2026-02-13 21:02:48'),
(11, 'susana1', 'rewS245', 'susanamgj2007@gmail.com', 'Susana', 'Gonzalez', '50686046496', NULL, 2, 2, 0, 1, 7200, 0, 0xb2d23ca6676ffc1ad9f5904114134e17, '2026-02-13 21:02:48'),
(12, 'alexa1', 'Xeal+45', 'aleisalopez04@gmail.com', 'Alexa', 'López', '50660850280', NULL, 2, 2, 0, 1, 7200, 0, 0xc2e5518d325082ff856245f54194f76d, '2026-02-13 21:02:48'),
(13, 'jonathan1', 'j', 'sebas0010011@outlook.com', 'Jonathan', 'Chavarria Garita', '50661399016', NULL, 2, 2, 0, 0, 3000, 0, 0xed7bb33ef755e5901528d85e1745e4dc, '2026-02-13 21:02:48'),
(14, 'blanca1', '', 'blancanmy15@gmail.com', 'Blanca', 'López', NULL, NULL, 2, 2, 0, 0, 3000, 0, 0x1b5a57cca6ae913fe092dfef0ee7eaec, '2026-02-13 21:02:48'),
(15, 'adrian1', '', 'adrian.chinchi1974@gmail.com', 'Adrián', 'Chinchilla', '50670166350', NULL, 2, 2, 0, 1, 3000, 0, 0x3ccfa6d45920fcd3bbd162ef68087737, '2026-02-13 21:02:48'),
(16, 'bryan1', '', 'lajgtor@hotmail.com', 'Bryan', 'Torres', '50685388463', NULL, 2, 2, 0, 0, 7200, 0, 0xb4f6fc45e6ae44bef5eacf4863cb37a0, '2026-02-13 21:02:48'),
(17, 'olmanm1', '', 'lajgtor@hotmail.com', 'olman', 'madrigal', NULL, NULL, 2, 2, 0, 1, 1200, 1, 0x77f7ffceaeed192e2b52bf65fcf77947, '2026-02-13 21:02:48'),
(18, 'olmanm2', '', 'lajgtor@hotmail.com', 'olman', 'madrigal', NULL, NULL, 2, 2, 0, 0, 7200, 1, 0x7184726bbdd18e695ed30b91c63c2f8b, '2026-02-13 21:02:48'),
(19, 'angelas1', '', 'angelasan766@gmail.com', 'angela', 'sanchez', NULL, NULL, 2, 2, 0, 0, 1200, 1, 0xe5aa5c25f942a2896eb90e487287059f, '2026-02-13 21:02:48'),
(20, 'hellens1', '', 'HELLENSERRANOUGALDE@GMAIL.COM', 'hellen', 'serrano', NULL, NULL, 2, 1, 0, 1, 7200, 1, 0x198f5bb97360ed708d06ecac44264bc6, '2026-02-13 21:02:48'),
(21, 'hilaryg1', '', 'hilla86g@gmail.com', 'hilary', 'gutierrez', NULL, NULL, 2, 2, 0, 0, 1200, 1, 0x00c9875ded816236a2a6a389503438c0, '2026-02-13 21:02:48'),
(22, 'mayrar1', '', 'lajgtor@hotmail.com', 'mayra', 'ruiz herrera', NULL, NULL, 2, 2, 0, 1, 1200, 1, 0x08360f288e37facf7116b31b7a65e5e7, '2026-02-13 21:02:48'),
(23, 'perlat1', '', 'lajgtor@hotmail.com', 'perla', 'taisigue', NULL, NULL, 2, 1, 0, 1, 7200, 1, 0x51cb696702eb8c55f003b583257b9361, '2026-02-13 21:02:48'),
(24, 'evelync1', '', 'evelyn.cadiz@hotmail.com', 'evelyn', 'cadiz', NULL, NULL, 2, 1, 0, 1, 6000, 1, 0xf5c18807af5ecd528eb32b80b81d8476, '2026-02-13 21:02:48'),
(25, 'joset1', '', 'lajgtor@hotmail.com', 'jose', 'torres', NULL, NULL, 2, 2, 0, 0, 1200, 1, 0x2f25baf4560be45d4c253e2137a31238, '2026-02-13 21:02:48'),
(26, 'brallant1', '', 'lajgtor@hotmail.com', 'brallan', 'torres', NULL, NULL, 4, 1, 0, 0, 7200, 1, 0x5963af13780b0843ffb52312f52e2a44, '2026-02-13 21:02:48'),
(27, 'gerardot1', '', 'lajgtor@hotmail.com', 'gerardo', 'torres', NULL, NULL, 4, 1, 0, 0, 7200, 1, 0xb29036e789df59e1764187719f824298, '2026-02-13 21:02:48'),
(28, 'rocíol1', '', 'lajgtor@hotmail.com', 'rocío', 'laurito', NULL, NULL, 2, 1, 0, 0, 3600, 1, 0xe5aed9c6de6ede5f292d3771795fd85c, '2026-02-13 21:02:48'),
(29, 'angelt1', '', 'torresdiaz1953@hotmail.com', 'angel', 'torres diaz', NULL, NULL, 4, 1, 0, 0, 7200, 1, 0x46a47696d1d0f304532b0e8dde369b22, '2026-02-13 21:02:48'),
(30, 'bryant1', '', 'electrotorrescr@outlook.com', 'bryan', 'torrs', NULL, NULL, 4, 1, 1, 0, 7200, 1, 0xe46809231c65b2f3bd0493910fddd786, '2026-02-13 21:02:48'),
(31, 'edeleyc1', '', 'lajgtor@hotmail.com', 'edeley', 'cadiz', NULL, NULL, 2, 2, 0, 0, 7200, 1, 0xe047dc907a74dac4bfc3aae439b136df, '2026-02-13 21:02:48'),
(32, 'omarg1', '', 'omar_4566@hotmail.com', 'omar', 'gutierrez', NULL, NULL, 2, 2, 0, 0, 3600, 1, 0xfb0101b5a42fc5c5bd463db42663f012, '2026-02-13 21:02:48'),
(33, 'tallert1', '', 'comprastorrescr@hotmail.com', 'taller', 'torres', NULL, NULL, 4, 1, 1, 0, 1200, 1, 0xb91b2ccb01376051ae65a98c443190c0, '2026-02-13 21:02:48'),
(34, 'sebastian1', '', 'sebas0010011@outlook.com', 'Sebastián', 'Rojas', '', NULL, 2, 2, 0, 1, 3600, 0, 0xa52915cc7fa4460ea9241f5c5d3f115b, '2026-02-13 21:02:48'),
(35, 'anthony1', '', 'anthony.0104@hotmail.com', 'Anthony', 'Fonseca', NULL, NULL, 2, 2, 0, 1, 7200, 1, 0xf6e4ff890e03e99bec66f092417ab89e, '2026-02-13 21:02:48'),
(36, 'veronicar1', NULL, 'lajgtor@hotmail.com', 'veronica', 'rojas amador', NULL, NULL, 2, 1, 0, 0, 7200, 1, 0x35609dde08d8af536d824a93cefaf07c, '2026-02-13 21:02:48'),
(37, 'wesly2', 'wwtof20', 'westalleralajuela@gmail.com', 'Wesly', 'Torres', '50687938023', NULL, 5, 1, 1, 0, 1200, 0, 0x8a34739838cc8d54e234541a2f998ff5, '2026-02-13 21:02:48'),
(38, 'rebecar1', NULL, 'reberetanaespi1386@gmail.com', 'rebeca', 'retana', NULL, NULL, 5, 2, 1, 0, 1200, 0, 0x8a34739838cc8d54e234541a2f998ff5, '2026-02-13 21:02:48'),
(39, 'eelctronicat1', NULL, 'lajgtor@hotmail.com', 'eelctronica', 'torres', NULL, NULL, 2, 1, 1, 0, 3600, 1, 0xaa311f204b33f9e04f320f16d48ffde9, '2026-02-13 21:02:48'),
(43, 'arlyna1', 'testxkr', 'arlynalfaro@grupoarfra.com', 'Arlyn', 'Alfaro', NULL, NULL, 6, 1, 1, 0, 1500, 0, 0xaebf130e28a42084f96f39d461c8f747, '2026-02-13 21:02:48'),
(46, 'kennyr1', NULL, 'Kenny.rodriguez.carcamo@gmail.com', 'kenny', 'rodriguez carcamo', NULL, NULL, 1, 2, 1, 0, 1200, 1, 0x4b4b61a94e36d2a99c1c803783f5b23e, '2026-02-13 21:02:48'),
(47, 'Kennynr1', 'alejandra1', 'Kenny_carcamo@hotmail.com', 'Kenny', 'Rodriguez', NULL, NULL, 1, 1, 1, 0, 7200, 0, NULL, '2026-02-13 21:02:48'),
(48, 'cristophern1', NULL, 'cristophernava2008@gmail.com', 'cristopher', 'navarrete', NULL, NULL, 2, 1, 0, 1, 7200, 1, 0xa1581b89d9bd6e59aa7e3dd4542ce1a9, '2026-02-13 21:02:48'),
(49, 'kenny1', '', 'kenny_carcamo@hotmail.com', 'Kenny1', 'rodriguez carcamo', NULL, NULL, 0, 1, 1, 0, 1800, 0, 0x3826f7553ea62641f192866af216d659, '2026-02-13 21:02:48'),
(50, 'anlleryv1', NULL, 'anlleryvt15@hotmail.com', 'anllery', 'vargas', NULL, NULL, 6, 2, 1, 0, 1200, 1, 0xa620605ead46c296df73cbe83d49996a, '2026-02-13 21:02:48'),
(51, 'edwing1', NULL, 'kenny_carcamo@hotmail.com', 'edwin', 'garcía', NULL, NULL, 7, 1, 1, 0, 300, 1, 0x4e0e73bd0a53ea8f16881921782c77b6, '2026-02-13 21:02:48'),
(52, 'tatianac1', NULL, 'kenny_carcamo@hotmail.com', 'tatiana', 'conde', NULL, NULL, 6, 2, 0, 0, 1200, 0, 0x22e14b42c06ace88ffc5d8b972670d41, '2026-02-13 21:02:48'),
(57, 'kennym1', NULL, 'kenny_carcamo@hotmail.com', 'kenny', 'mejia carcamo', NULL, NULL, 1, 2, 1, 0, 1200, 1, 0x444de9715f992f018e322c7da738786d, '2026-02-13 21:02:48'),
(58, 'rodrigok1', NULL, 'kenny_carcamo@hotmail.com', 'rodrigo', 'kenn', NULL, NULL, 1, 2, 1, 0, 1200, 1, 0x65c7ab6ff50562b69706e2c4d70a20c5, '2026-02-13 21:02:48'),
(63, 'leandros1', NULL, 'salazarleandro629@gmail.com', 'leandro', 'salazar', NULL, NULL, 2, 2, 0, 1, 7200, 1, 0xe52cb4fe8c9273231e1c1f81607c49c0, '2026-03-27 15:38:19'),
(64, 'brandonc1', NULL, 'carvajalquirosbrandon@gmail.com', 'brandon', 'carvajal', NULL, NULL, 2, 1, 1, 0, 3600, 1, 0x9313b40ad07552db182fc7d17f79884f, '2026-06-17 10:07:16');

DROP TABLE IF EXISTS `accounts_log`;
CREATE TABLE `accounts_log` (
  `id_account` int(11) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `token` varchar(20) DEFAULT NULL,
  `ultimo_request` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `accounts_log` (`id_account`, `fecha`, `token`, `ultimo_request`) VALUES
(4, '2026-08-21 11:51:55', '21105155063748705', '2026-08-21 11:53:14'),
(50, '2026-08-24 08:03:32', '24070332504409936', '2026-08-24 08:17:53'),
(37, '2026-08-22 12:23:55', '2211235546085292', '2026-08-22 12:26:56'),
(64, '2026-08-22 10:28:01', '22092801259607422', '2026-08-22 12:03:07'),
(38, '2026-08-22 10:17:04', '22091704928633912', '2026-08-22 10:20:59');

DROP TABLE IF EXISTS `accounts_recovers`;
CREATE TABLE `accounts_recovers` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL,
  `clave` varchar(60) DEFAULT NULL,
  `boton` varchar(2) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `estado` int(11) DEFAULT NULL,
  `clave_link` varchar(8) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `accounts_recovers` (`id`, `id_usuario`, `email`, `clave`, `boton`, `fecha_creacion`, `estado`, `clave_link`) VALUES
(1, 4, 'lajgtor@hotmail.com', 'gyoarpcktidbsrsmejtzmhqwyexijbkzhjvcloselcrafzkulsewsww', NULL, '2020-09-01 22:33:29', 0, NULL),
(2, 4, 'lajgtor@hotmail.com', 'cbjahikqkxarvxmbpgcpzbxqrobpnwhdjddncdpcqrbhjnudgtvknyr', NULL, '2020-09-01 22:33:32', 0, NULL),
(3, 4, 'lajgtor@hotmail.com', 'toucjdcfkexjxqejjdxckkhfmmbbjlrwyzugnlkqqipzoblqwpigxsw', NULL, '2020-09-01 22:33:39', 0, NULL),
(4, 4, 'lajgtor@hotmail.com', 'vjvpulpfauhxlfmtuvatggylxqonyqtlwggmcuzfrfnvgjsjzcdfgwa', NULL, '2020-09-01 22:33:41', 0, NULL),
(5, 3, 'kenny_carcamo@hotmail.com', 'kpbysgugfrmvfjdiasbpozoyxnsgqsnzfzqnnkhcpyxbwuxhdndsmnb', NULL, '2020-09-23 21:15:14', 0, NULL),
(6, 3, 'kenny_carcamo@hotmail.com', 'xbwdnpsrvgigfgshhqntyrkeoxomexqmvhmfdhwrvtvgrrpgokzsouk', NULL, '2020-09-23 21:15:33', 0, NULL),
(7, 3, 'kenny_carcamo@hotmail.com', 'hhdrmpifilaxkouemffvggiaefunvtzdbtzcigxmxjlfglrtofflrnm', NULL, '2020-09-23 21:16:12', 0, NULL),
(8, 3, 'kenny_carcamo@hotmail.com', 'gfmfhkrvjbnucdhbbpvktqhtfgydlvgczousxgshveylwztfuzzoomq', NULL, '2020-09-23 21:16:37', 0, NULL),
(9, 3, 'kenny_carcamo@hotmail.com', 'sniniakrhxujuublzcxmmcndyembgkramuynwiwflxpdaotwvhxvznj', NULL, '2020-09-23 21:17:15', 0, NULL),
(10, 3, 'kenny_carcamo@hotmail.com', 'aggrxlvxlhkkmvwtvdneasuagnimpgmfpptmojgvaxhpjbialnfvunf', NULL, '2020-09-23 21:18:09', 0, NULL),
(11, 3, 'kenny_carcamo@hotmail.com', 'ifukqksawnxnvsnshfxltwiftvcdxfcfowjwthvodhsyknyytezspof', NULL, '2020-09-23 21:18:42', 0, NULL),
(12, 3, 'kenny_carcamo@hotmail.com', 'vgycbuznvphauwhbtvuqyerlsssiobwhkxpgkpbnwaovriceploxsyn', NULL, '2020-09-23 21:19:55', 0, NULL),
(13, 3, 'kenny_carcamo@hotmail.com', 'zikzkimckmlbwwxgxurbneyrfhpkysnydnqtbsgnbcdxtogawqoqvoz', NULL, '2020-09-23 21:24:56', 0, NULL),
(14, 3, 'kenny_carcamo@hotmail.com', 'mgpqfzilyabluuztvyvvtlnedghjlzusaqxduzxiwvyhzuhbyqlwfkp', NULL, '2020-09-23 21:25:37', 0, NULL),
(15, 3, 'kenny_carcamo@hotmail.com', 'msxefpfpcturiywvyhtiflidzekldswkeippbkkkmcfugapwskfolad', NULL, '2020-09-23 21:44:06', 0, NULL),
(16, 3, 'kenny_carcamo@hotmail.com', 'LLV22', '1', '2020-10-22 04:48:03', 0, 'EZEZPNQM'),
(17, 3, 'kenny_carcamo@hotmail.com', 'AWE67', '3', '2020-10-29 14:44:34', 0, 'RJJVJPLP'),
(18, 13, 'jonnathan.chava@gmail.com', 'HMM42', '2', '2020-10-29 23:28:16', 0, 'EWZWSDBM'),
(19, 13, 'jonnathan.chava@gmail.com', 'GOZ04', '2', '2020-10-29 23:30:33', 0, 'URNGEDYL'),
(20, 19, 'lajgtor@hotmail.com', 'CSX67', '2', '2021-04-07 11:19:34', 0, 'HSJSXAZS'),
(21, 3, 'kenny_carcamo@hotmail.com', 'EPT19', '2', '2021-04-07 11:23:53', 0, 'FQNJRWUM'),
(22, 19, 'lajgtor@hotmail.com', 'KFF86', '2', '2021-04-07 11:27:04', 0, 'YXQGEFYZ'),
(23, 3, 'kenny_carcamo@hotmail.com', 'LMS88', '1', '2021-04-07 11:27:23', 0, 'ACWKZBGT'),
(24, 16, 'torresbryant89@hotmail.com', 'XDD16', '1', '2021-04-13 10:21:07', 0, 'YXHHIPUR'),
(25, 16, 'torresbryant89@hotmail.com', 'JGO00', '1', '2021-04-13 10:28:40', 0, 'TICYGOER'),
(26, 16, 'torresbryant89@hotmail.com', 'ZOO11', '1', '2021-06-22 17:26:14', 0, 'FRQBLESJ'),
(27, 16, 'torresbryant89@hotmail.com', 'KKP36', '2', '2021-06-22 17:26:26', 0, 'NTCWHNWC'),
(28, 4, 'lajgtor@hotmail.com', 'OWF22', '1', '2021-07-01 07:59:15', 0, 'CEZYESSP'),
(29, 19, 'angelasan766@gmail.com', 'FYC26', '3', '2021-07-27 10:15:14', 0, 'NKPTRRIK'),
(30, 16, 'torresbryant89@hotmail.com', 'QSJ71', '3', '2021-08-10 15:32:10', 0, 'LXLYMCAC'),
(31, 3, 'kenny_carcamo@hotmail.com', 'XDZ65', '1', '2021-11-05 12:29:20', 0, 'IXOAUMFG'),
(32, 16, 'torresbryant89@hotmail.com', 'FUS73', '3', '2021-12-21 10:03:23', 0, 'USOJOOEZ'),
(33, 16, 'torresbryant89@hotmail.com', 'HNF27', '3', '2021-12-21 10:06:03', 0, 'KFVDKQUO'),
(34, 16, 'torresbryant89@hotmail.com', 'YML27', '1', '2021-12-21 10:06:25', 0, 'NGTYIIUB'),
(35, 3, 'kenny_carcamo@hotmail.com', 'MDE78', '2', '2021-12-21 10:17:50', 0, 'LYEUNBFU'),
(36, 16, 'torresbryant89@hotmail.com', 'XZA84', '2', '2021-12-21 11:10:00', 0, 'LUTHQVOW'),
(37, 8, 'acosta_april@hotmail.com', 'SDB09', '1', '2022-03-10 09:08:31', 0, 'BTDBZEYE'),
(38, 8, 'lajgtor@hotmail.com', 'MMG42', '1', '2022-03-11 15:37:26', 0, 'TCLBQJIA'),
(39, 9, 'kenny_carcamo@hotmail.com', 'SSN77', '2', '2022-03-11 16:19:40', 1, 'VMLFPYRN'),
(40, 8, 'lajgtor@hotmail.com', 'ORL96', '2', '2022-03-15 13:14:48', 0, 'KNURKPJP'),
(41, 22, 'mayra.ruiz.herrera@gmail.com', 'BPS03', '3', '2022-04-20 11:33:54', 0, 'YFKBUDAJ'),
(42, 4, 'lajgtor@hotmail.com', 'BDG94', '2', '2022-04-20 11:41:09', 0, 'VNAOVTCS'),
(43, 8, 'lajgtor@hotmail.com', 'NKX43', '1', '2022-04-20 11:47:08', 0, 'ONUEHNDC'),
(44, 22, 'mayra.ruiz.herrera@gmail.com', 'ECQ41', '1', '2022-04-20 11:51:13', 0, 'AYWEMHQX'),
(45, 22, 'mayra.ruiz.herrera@gmail.com', 'MYU75', '2', '2022-04-20 11:53:09', 0, 'PVPYTVSG'),
(46, 22, 'lajgtor@hotmail.com', 'UGY89', '1', '2022-04-20 11:59:29', 0, 'UODCFUXS'),
(47, 22, 'lajgtor@hotmail.com', 'OBP52', '3', '2022-05-04 14:01:42', 0, 'TTJNHLXW'),
(48, 23, 'taisigue.perla08@gmail.com', 'ADP62', '1', '2022-05-17 10:31:48', 0, 'NXXNTYYE'),
(49, 23, 'lajgtor@hotmail.com', 'LXZ30', '1', '2022-05-17 10:48:52', 0, 'AUWCIPBM'),
(50, 24, 'evelyn.cadiz@hotmail.com', 'GQO51', '3', '2022-06-20 10:36:13', 0, 'HKHHTQQR'),
(51, 25, 'lajgtor@hotmail.com', 'PNZ63', '3', '2022-07-07 23:07:41', 0, 'BCAHCKCA'),
(52, 25, 'lajgtor@hotmail.com', 'GAP49', '3', '2022-07-07 23:15:59', 0, 'EBSIMGHC'),
(53, 3, 'kenny_carcamo@hotmail.com', 'AAS65', '3', '2022-07-10 22:16:38', 0, 'IQLNODBL'),
(54, 25, 'lajgtor@hotmail.com', 'MDY51', '2', '2022-07-11 19:25:52', 0, 'GLHVQJNY'),
(55, 16, 'lajgtor@hotmail.com', 'DIJ62', '2', '2022-07-11 19:36:45', 0, 'FLYHJLWT'),
(56, 26, 'electrotorrescr@outlook.com', 'DZQ92', '3', '2022-07-11 21:12:40', 0, 'FPEZYJTR'),
(57, 18, 'lajgtor@hotmail.com', 'XAU32', '3', '2022-07-14 11:22:17', 0, 'TVLHSNQY'),
(58, 26, 'electrotorrescr@outlook.com', 'ANR29', '2', '2022-07-14 18:10:20', 0, 'ZFLVAAHZ'),
(59, 27, 'lajgtor@hotmail.com', 'VCR31', '3', '2022-07-14 18:17:14', 0, 'AOBZFORN'),
(60, 28, 'rlauritos@yahoo.es', 'ODQ76', '3', '2022-07-14 22:13:10', 0, 'HDHLJUTR'),
(61, 28, 'rlauritos@yahoo.es', 'AEL45', '2', '2022-07-14 22:54:31', 0, 'JGEIHDNE'),
(62, 28, 'rlauritos@yahoo.es', 'SDQ16', '2', '2022-07-14 22:55:44', 0, 'TWOUGDFS'),
(63, 16, 'lajgtor@hotmail.com', 'ZJQ59', '1', '2022-07-15 16:03:16', 0, 'HXBQSVOD'),
(64, 16, 'lajgtor@hotmail.com', 'FSY76', '3', '2022-07-15 16:12:41', 0, 'UBPTEZVK'),
(65, 16, 'lajgtor@hotmail.com', 'XPJ63', '2', '2022-07-15 16:14:19', 0, 'CVIUSMWQ'),
(66, 16, 'lajgtor@hotmail.com', 'FOL16', '2', '2022-07-15 16:21:12', 0, 'FTKVLUXL'),
(67, 27, 'lajgtor@hotmail.com', 'ZOE27', '2', '2022-07-15 16:39:20', 0, 'AIFJOZNW'),
(68, 26, 'electrotorrescr@outlook.com', 'SRK31', '1', '2022-07-18 14:01:15', 0, 'SRARHERK'),
(69, 26, 'lajgtor@hotmail.com', 'STB06', '1', '2022-07-18 14:04:06', 0, 'KSXMIOLS'),
(70, 30, 'electrotorrescr@outlook.com', 'OHP03', '2', '2022-07-18 14:23:40', 0, 'JJIVMFYV'),
(71, 30, 'electrotorrescr@outlook.com', 'UWS54', '1', '2022-07-18 14:29:21', 0, 'SRLYZGLU'),
(72, 29, 'joseangeltorresdiaz43@gmail.com', 'WQL50', '1', '2022-07-18 15:45:07', 0, 'GOFJUOGC'),
(73, 28, 'rlauritos@yahoo.es', 'RUU21', '3', '2022-07-18 20:17:14', 0, 'IHNKMBAJ'),
(74, 28, 'lajgtor@hotmail.com', 'OKM30', '2', '2022-07-18 20:21:30', 0, 'UEDQONHH'),
(75, 29, 'torresdiaz1953@hotmail.com', 'FRQ45', '3', '2022-07-19 08:47:51', 0, 'POVSBAFR'),
(76, 31, 'edeleycadiz@gmail.com', 'SLH78', '2', '2022-08-12 09:27:15', 0, 'OITIFTIK'),
(77, 31, 'lajgtor@hotmail.com', 'TPR96', '1', '2022-08-12 09:30:15', 0, 'UEEVUIVX'),
(78, 30, 'electrotorrescr@outlook.com', 'TZZ98', '2', '2022-09-27 13:27:50', 0, 'OWXFQHPD'),
(79, 30, 'electrotorrescr@outlook.com', 'NMB44', '2', '2022-11-10 12:10:29', 1, 'VIOQRFPU'),
(80, 32, 'omar_4566@hotmail.com', 'FHR88', '1', '2022-12-15 17:35:26', 0, 'MGNFBVUP'),
(81, 32, 'omar_4566@hotmail.com', 'BKP48', '2', '2022-12-15 17:39:17', 0, 'MQPROMSP'),
(82, 3, 'kenny_carcamo@hotmail.com', 'GFG57', '2', '2023-01-13 18:51:48', 0, 'JWTBFGKD'),
(83, 3, 'kenny_carcamo@hotmail.com', 'YIC11', '1', '2023-01-15 19:51:08', 0, 'CLFDUXJG'),
(84, 3, 'kenny_carcamo@hotmail.com', 'OWP71', '2', '2023-01-15 21:22:30', 0, 'MDMXJXSD'),
(85, 3, 'kenny_carcamo@hotmail.com', 'BSA06', '1', '2023-01-15 21:41:19', 0, 'HQXYFVZY'),
(86, 3, 'kenny_carcamo@hotmail.com', 'NPM25', '2', '2023-01-28 22:36:35', 0, 'JXFXWFWV'),
(87, 13, 'sebas0010011@outlook.com', 'NAO87', '1', '2023-04-11 12:49:24', 0, 'KSPUJXFN'),
(88, 16, 'lajgtor@hotmail.com', 'QBL10', '2', '2023-04-11 12:52:52', 1, 'EGQUJZGM'),
(89, 13, 'sebas0010011@outlook.com', 'GIB14', '3', '2023-04-11 12:56:27', 0, 'SPEBBSCT'),
(90, 34, 'sebas0010011@outlook.com', 'ETS30', '2', '2023-04-12 11:57:45', 0, 'AFEISIDL'),
(91, 35, 'anthony.0104@hotmail.com', 'FXC01', '3', '2023-04-28 09:00:15', 0, 'UFNTQTKQ'),
(92, 35, 'anthony.0104@hotmail.com', 'KCV24', '2', '2023-04-28 09:00:17', 0, 'ISTTGOGV'),
(93, 35, 'anthony.0104@hotmail.com', 'ZGX40', '1', '2023-04-28 09:05:33', 0, 'RTNPHFEO'),
(94, 35, 'anthony.0104@hotmail.com', 'ZRU66', '2', '2023-04-28 09:07:22', 0, 'QIAKXWQI'),
(95, 3, 'kenny_carcamo@hotmail.com', 'YFB76', '3', '2023-04-29 14:04:03', 0, 'VKZJGKMP'),
(96, 24, 'evelyn.cadiz@hotmail.com', 'JQU29', '2', '2023-05-22 15:14:30', 1, 'GWITSBAI'),
(97, 3, 'kenny_carcamo@hotmail.com', 'IRU50', '2', '2024-01-09 09:41:14', 0, 'VFCILYYU'),
(98, 36, 'veronicarojasamador@gmail.com', 'ZJB20', '2', '2024-01-09 09:44:03', 0, 'SCWEMPFP'),
(99, 36, 'lajgtor@hotmail.com', 'RHC80', '2', '2024-01-09 09:48:39', 0, 'EXHOKUSA'),
(100, 3, 'kenny_carcamo@hotmail.com', 'YEE01', '2', '2024-01-09 12:50:57', 0, 'ETGETFGV'),
(101, 33, 'comprastorrescr@hotmail.com', 'QAZ86', '3', '2024-01-11 07:38:08', 0, 'WCYARRKZ'),
(102, 33, 'comprastorrescr@hotmail.com', 'QNH44', '3', '2024-01-16 07:18:49', 0, 'IYNPNOLX'),
(103, 33, 'comprastorrescr@hotmail.com', 'TWR94', '1', '2024-05-07 13:27:06', 0, 'CXGKKJLQ'),
(104, 39, 'lajgtor@hotmail.com', 'YHX34', '3', '2024-07-08 15:44:44', 0, 'QGDXZFOP'),
(105, 39, 'lajgtor@hotmail.com', 'DBO07', '1', '2024-07-08 15:47:06', 0, 'YKZPGFPD'),
(106, 39, 'lajgtor@hotmail.com', 'BZM01', '3', '2024-10-18 17:33:00', 0, 'GSEXQQCQ'),
(107, 39, 'lajgtor@hotmail.com', 'URL60', '2', '2024-12-26 09:40:41', 0, 'DJWJSPFH'),
(108, 39, 'lajgtor@hotmail.com', 'ZFC16', '3', '2024-12-26 09:42:27', 0, 'DATFIPON'),
(109, 3, 'kenny_carcamo@hotmail.com', 'JRE14', '1', '2025-02-11 12:23:15', 0, 'SQGVAZFX'),
(110, 3, 'kenny_carcamo@hotmail.com', 'UMB37', '1', '2025-02-11 13:50:38', 0, 'XDDDWSPU'),
(111, 3, 'kenny_carcamo@hotmail.com', 'MNY51', '3', '2025-02-11 13:54:09', 0, 'RUEPTMEB'),
(112, 48, 'cristophernava2008@gmail.com', 'ZLE96', '3', '2025-02-27 11:25:28', 1, 'SNHCBUJK'),
(113, 8, 'lajgtor@hotmail.com', 'BGM09', '1', '2025-04-11 13:50:51', 1, 'MCWNMEIV'),
(114, 49, 'kenny_carcamo@hotmail.com', 'DHK07', '1', '2025-06-06 15:55:38', 0, 'MSXMZJTF'),
(115, 3, 'kenny_carcamo@hotmail.com', 'VKD11', '2', '2025-06-06 17:17:23', 0, 'DHLNGCRK'),
(116, 3, 'kenny_carcamo@hotmail.com', 'IPF15', '1', '2025-06-06 17:25:29', 0, 'OGBTCBBL'),
(117, 49, 'kenny_carcamo@hotmail.com', 'KAF46', '2', '2025-06-06 17:33:53', 0, 'WWITBBTG'),
(118, 49, 'kenny_carcamo@hotmail.com', 'BEA64', '1', '2025-06-06 17:34:45', 0, 'NPULPMJQ'),
(119, 49, 'kenny_carcamo@hotmail.com', 'JZZ87', '2', '2025-06-06 20:37:08', 1, 'IHGRAVNS'),
(120, 3, 'kenny_carcamo@hotmail.com', 'XUT76', '3', '2025-06-06 23:54:52', 0, 'EQUOLGBL'),
(121, 3, 'kenny_carcamo@hotmail.com', 'JDI54', '1', '2026-01-19 11:46:14', 0, 'DJBZIUVT'),
(122, 3, 'kenny_carcamo@hotmail.com', 'AKJ53', '1', '2026-02-03 14:39:40', 0, 'HQXXHVUD'),
(123, 3, 'kenny_carcamo@hotmail.com', 'ZDR12', '1', '2026-02-10 18:36:27', 0, 'ETZHGMIO'),
(124, 3, 'kenny_carcamo@hotmail.com', 'WPN17', '1', '2026-03-05 09:55:34', 1, 'LAKFODIF'),
(125, 63, 'salazarleandro629@gmail.com', 'EHV01', '3', '2026-03-27 15:41:30', 0, 'BRFOJYXV'),
(126, 64, 'carvajalquirosbrandon@gmail.com', 'KCU31', '1', '2026-06-17 10:09:54', 0, 'BQHDUVOX'),
(127, 64, 'carvajalquirosbrandon@gmail.com', 'PMV77', '2', '2026-06-17 13:54:13', 0, 'XTGTQYMO'),
(128, 64, 'carvajalquirosbrandon@gmail.com', 'VEJ62', '3', '2026-06-17 13:57:40', 1, 'HYVNMTXS');

DROP TABLE IF EXISTS `accounts_session_resets`;
CREATE TABLE `accounts_session_resets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `codigo` varchar(12) DEFAULT NULL,
  `estado` int(11) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_uso` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `accounts_session_resets` (`id`, `user_id`, `codigo`, `estado`, `fecha_creacion`, `fecha_uso`) VALUES
(1, 50, 'RRGPGMYV', 0, '2026-02-02 18:56:51', '2026-02-02 18:59:23'),
(2, 3, 'LRYZMSCZ', 1, '2026-02-02 18:57:46', '0000-00-00 00:00:00'),
(3, 3, 'WAVNONHF', 1, '2026-02-14 03:40:59', '0000-00-00 00:00:00'),
(4, 50, 'FFSCAKRF', 1, '2026-05-14 17:22:28', '0000-00-00 00:00:00'),
(5, 50, 'UWZWXWYJ', 0, '2026-05-14 17:23:11', '2026-05-14 17:29:52'),
(6, 50, 'AQYBOVMZ', 1, '2026-05-14 17:28:39', '0000-00-00 00:00:00'),
(7, 50, 'EGEPOXGO', 0, '2026-06-08 14:54:57', '2026-06-08 15:05:18'),
(8, 50, 'PEFWFPZG', 0, '2026-06-22 14:27:37', '2026-06-22 14:30:26'),
(9, 50, 'RRMLIEVS', 1, '2026-06-22 14:29:34', '0000-00-00 00:00:00');

DROP TABLE IF EXISTS `kapps`;
CREATE TABLE `kapps` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `owner` varchar(60) NOT NULL,
  `created_date` datetime NOT NULL,
  `state` varchar(10) NOT NULL,
  `clave` varchar(5) DEFAULT NULL,
  `licencias` int(11) DEFAULT NULL,
  `fecha_cobro` datetime DEFAULT NULL,
  `mensualidad` int(11) DEFAULT NULL,
  `correo_factura` varchar(45) DEFAULT NULL,
  `info` varchar(150) DEFAULT NULL,
  `dias_vencimiento` int(11) NOT NULL DEFAULT 5
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `kapps` (`id`, `name`, `owner`, `created_date`, `state`, `clave`, `licencias`, `fecha_cobro`, `mensualidad`, `correo_factura`, `info`, `dias_vencimiento`) VALUES
(2, 'Electrónica Torres', 'Gerardo Torres', '2020-01-23 00:00:00', 'ACTIVE', 'ETGA', 5, '2020-06-25 00:00:00', NULL, NULL, NULL, 15),
(3, 'La Crepera SV', 'Josue Rodriguez', '2020-01-23 00:00:00', 'INACTIVE', 'LCSV', 4, '2020-01-01 00:00:00', NULL, NULL, NULL, 5),
(4, 'Electrónica Torres Guanacaste', 'Gerardo Torres GU', '2022-07-10 00:00:00', 'INACTIVE', 'ETGU', 5, '2022-07-11 00:00:00', NULL, NULL, NULL, 5),
(1, 'Pruebas', 'Kenny Rodriguez', '2020-01-23 00:00:00', 'ACTIVE', 'TXPR', 3, '2025-01-01 00:00:00', 0, NULL, NULL, 5),
(5, 'Electrónica Torres WT', 'Wesly Torres', '2022-07-10 00:00:00', 'ACTIVE', 'ETWT', 5, '2024-06-06 00:00:00', NULL, NULL, NULL, 5),
(6, 'ProntoSnack', 'Arlyn Alfaro', '2025-02-03 00:00:00', 'ACTIVE', 'PTSN', 5, '2025-05-01 00:00:00', 9500, 'arlynalfaro@grupoarfra.com', NULL, 5),
(7, 'Memin Barber Shop', 'Edwin García', '2025-03-06 01:16:21', 'INACTIVE', 'MMIN', 2, '2025-04-30 00:00:00', 9000, 'kenny_carcamo@hotmail.com', NULL, 5);

DROP TABLE IF EXISTS `kapps_modules`;
CREATE TABLE `kapps_modules` (
  `id` int(11) NOT NULL,
  `kapp_id` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `kapps_modules` (`id`, `kapp_id`, `module_id`) VALUES
(5, 2, 3),
(6, 2, 4),
(12, 0, 2),
(13, 0, 3),
(14, 0, 5),
(25, 7, 2),
(26, 7, 3),
(30, 6, 0),
(36, 1, 2),
(37, 1, 3),
(38, 1, 4),
(39, 1, 5),
(46, 6, 3),
(47, 6, 5),
(48, 6, 6);

DROP TABLE IF EXISTS `kapps_modules_cat`;
CREATE TABLE `kapps_modules_cat` (
  `id` int(11) NOT NULL,
  `type` char(15) DEFAULT NULL,
  `name` char(20) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `code` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `kapps_modules_cat` (`id`, `type`, `name`, `description`, `active`, `parent_id`, `code`) VALUES
(0, 'MAIN', 'CONFIGURACION', 'Configuración General de la KAPP', 1, NULL, 'man'),
(1, 'MAIN', 'TALLER', 'Módulo para dar seguimiento a Boletas de Servicio', 1, NULL, 'tll'),
(2, 'MAIN', 'TIENDA', 'Venta de Artículos', 1, NULL, 'tnd'),
(3, 'MAIN', 'INVENTARIO', 'Inventario de Productos', 1, NULL, 'inv'),
(4, 'MAIN', 'CREDIX', 'Sistema de Crédito en Abastecedores, Pulperías, etc.', 1, NULL, 'cdx'),
(5, 'MAIN', 'DESPACHO', 'Gestiòn de Puntos de Ventas Usando el Inventario', 1, NULL, 'dpt'),
(6, 'MAIN', 'CONFIGURACION', 'Configuración General de la KAPP', 1, NULL, 'man');

DROP TABLE IF EXISTS `kapp_conf_cat`;
CREATE TABLE `kapp_conf_cat` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(15) DEFAULT NULL,
  `estado` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `kapp_conf_cat` (`id`, `descripcion`, `estado`) VALUES
(0, 'Taller', 1),
(1, 'Tienda', 1),
(2, 'Inventario', 1),
(4, 'Crepera', 1);

DROP TABLE IF EXISTS `padron_cr`;
CREATE TABLE `padron_cr` (
  `cedula` int(11) NOT NULL,
  `nombres` varchar(30) DEFAULT NULL,
  `apellido1` varchar(30) DEFAULT NULL,
  `apellido2` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

DROP TABLE IF EXISTS `padron_cr2`;
CREATE TABLE `padron_cr2` (
  `cedula` int(11) NOT NULL,
  `nombres` varchar(30) DEFAULT NULL,
  `apellido1` varchar(30) DEFAULT NULL,
  `apellido2` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

DROP TABLE IF EXISTS `pagos`;
CREATE TABLE `pagos` (
  `id` int(11) NOT NULL,
  `kapp_id` int(11) DEFAULT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `periodo` varchar(6) DEFAULT NULL,
  `monto` int(11) DEFAULT NULL,
  `estado` int(11) DEFAULT 1,
  `userid` int(11) DEFAULT NULL,
  `userid_elimina` int(11) DEFAULT NULL,
  `fecha_elimina` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `pagos` (`id`, `kapp_id`, `fecha_registro`, `periodo`, `monto`, `estado`, `userid`, `userid_elimina`, `fecha_elimina`) VALUES
(1, 2, '2021-04-26 14:47:50', '202101', 17000, 1, NULL, NULL, NULL),
(2, 2, '2021-04-26 14:47:50', '202102', 17000, 1, NULL, NULL, NULL),
(3, 2, '2021-04-26 14:47:51', '202103', 17000, 1, NULL, NULL, NULL),
(5, 2, '2021-04-28 07:23:46', '202104', 24000, 1, NULL, NULL, NULL),
(6, 2, '2021-06-03 10:51:01', '202105', 24845, 1, NULL, NULL, NULL),
(7, 2, '2021-07-05 09:10:26', '202106', 26918, 1, NULL, NULL, NULL),
(8, 2, '2021-09-06 08:35:56', '202107', 27000, 1, NULL, NULL, NULL),
(9, 2, '2021-10-07 08:35:57', '202108', 27000, 1, NULL, NULL, NULL),
(14, 2, '2022-01-20 12:00:00', '202110', 27000, 1, NULL, NULL, NULL),
(13, 2, '2021-10-14 12:58:16', '202109', 27000, 1, NULL, NULL, NULL),
(15, 2, '2022-01-20 12:00:00', '202111', 27000, 1, NULL, NULL, NULL),
(16, 2, '2022-02-04 12:00:00', '202112', 27000, 1, NULL, NULL, NULL),
(17, 2, '2022-08-11 12:00:00', '202201', 29068, 1, NULL, NULL, NULL),
(18, 4, '2022-08-11 12:00:00', '202207', 12000, 1, NULL, NULL, NULL),
(19, 4, '2022-08-11 12:00:00', '202206', 0, 1, NULL, NULL, NULL),
(20, 4, '2022-08-11 12:00:00', '202205', 0, 1, NULL, NULL, NULL),
(21, 4, '2022-08-11 12:00:00', '202208', 0, 1, NULL, NULL, NULL),
(22, 4, '2022-09-19 12:00:00', '202209', 12000, 1, NULL, NULL, NULL),
(23, 2, '2022-09-19 12:00:00', '202202', 29068, 1, NULL, NULL, NULL),
(24, 2, '2022-09-19 12:00:00', '202203', 29068, 1, NULL, NULL, NULL),
(25, 4, '2022-10-18 12:00:00', '202210', 12000, 1, NULL, NULL, NULL),
(26, 4, '2022-11-14 12:00:00', '202211', 12000, 1, NULL, NULL, NULL),
(27, 4, '2022-12-12 12:00:00', '202212', 12000, 1, NULL, NULL, NULL),
(28, 4, '2023-01-12 12:00:00', '202301', 12000, 1, NULL, NULL, NULL),
(29, 2, '2023-01-23 12:00:00', '202204', 22810, 1, NULL, NULL, NULL),
(30, 2, '2023-01-23 12:00:00', '202205', 22810, 1, NULL, NULL, NULL),
(31, 2, '2023-01-23 12:00:00', '202206', 22810, 1, NULL, NULL, NULL),
(32, 4, '2023-02-15 01:00:00', '202302', 12000, 1, NULL, NULL, NULL),
(33, 2, '2023-03-06 00:00:00', '202207', 29025, 1, 3, NULL, NULL),
(34, 2, '2023-03-06 00:00:00', '202208', 27993, 1, 3, NULL, NULL),
(35, 4, '2023-03-23 00:00:00', '202303', 12000, 1, 3, NULL, NULL),
(36, 2, '2023-04-04 00:00:00', '202209', 30240, 1, 3, NULL, NULL),
(37, 4, '2023-04-12 00:00:00', '202304', 12000, 1, 3, NULL, NULL),
(38, 0, '2023-04-12 00:00:00', '202304', 1, 1, 3, NULL, NULL),
(39, 0, '2023-04-12 00:00:00', '202305', 1, 1, 3, NULL, NULL),
(40, 1, '2021-04-26 14:47:50', '202101', 17000, 1, NULL, NULL, NULL),
(41, 1, '2021-04-26 14:47:50', '202102', 17000, 1, NULL, NULL, NULL),
(42, 1, '2021-04-26 14:47:51', '202103', 17000, 1, NULL, NULL, NULL),
(43, 1, '2021-04-28 07:23:46', '202104', 24000, 1, NULL, NULL, NULL),
(44, 1, '2021-06-03 10:51:01', '202105', 24845, 1, NULL, NULL, NULL),
(45, 1, '2021-07-05 09:10:26', '202106', 26918, 1, NULL, NULL, NULL),
(46, 1, '2021-09-06 08:35:56', '202107', 27000, 1, NULL, NULL, NULL),
(47, 1, '2021-10-07 08:35:57', '202108', 27000, 1, NULL, NULL, NULL),
(48, 1, '2022-01-20 12:00:00', '202110', 27000, 1, NULL, NULL, NULL),
(49, 1, '2021-10-14 12:58:16', '202109', 27000, 1, NULL, NULL, NULL),
(50, 1, '2022-01-20 12:00:00', '202111', 27000, 1, NULL, NULL, NULL),
(51, 1, '2022-02-04 12:00:00', '202112', 27000, 1, NULL, NULL, NULL),
(52, 1, '2022-08-11 12:00:00', '202201', 29068, 1, NULL, NULL, NULL),
(53, 1, '2022-09-19 12:00:00', '202202', 29068, 1, NULL, NULL, NULL),
(54, 1, '2022-09-19 12:00:00', '202203', 29068, 0, NULL, 3, '2025-03-24 12:59:11'),
(55, 1, '2023-01-23 12:00:00', '202204', 22810, 0, NULL, 3, '2025-03-24 12:59:18'),
(56, 1, '2023-01-23 12:00:00', '202205', 22810, 1, NULL, NULL, NULL),
(57, 1, '2023-01-23 12:00:00', '202206', 22810, 1, NULL, NULL, NULL),
(58, 1, '2023-03-06 00:00:00', '202207', 29025, 1, 3, NULL, NULL),
(59, 1, '2023-03-06 00:00:00', '202208', 27993, 1, 3, NULL, NULL),
(60, 1, '2023-04-04 00:00:00', '202209', 30240, 1, 3, NULL, NULL),
(61, 2, '2023-04-30 00:00:00', '202210', 26789, 1, 3, NULL, NULL),
(62, 4, '2023-05-15 00:00:00', '202305', 12000, 1, 3, NULL, NULL),
(63, 4, '2023-06-13 00:00:00', '202306', 12000, 1, 3, NULL, NULL),
(64, 2, '2023-06-21 00:00:00', '202211', 26101, 1, 3, NULL, NULL),
(65, 2, '2023-06-21 00:00:00', '202212', 25112, 1, 3, NULL, NULL),
(66, 4, '2023-07-13 00:00:00', '202307', 12000, 1, 3, NULL, NULL),
(67, 2, '2023-07-04 00:00:00', '202301', 25112, 1, 3, NULL, NULL),
(68, 4, '2023-08-29 00:00:00', '202308', 12000, 1, 3, NULL, NULL),
(69, 4, '2023-09-25 00:00:00', '202309', 12000, 1, 3, NULL, NULL),
(70, 4, '2023-10-19 00:00:00', '202310', 12000, 1, 3, NULL, NULL),
(71, 2, '2023-10-19 00:00:00', '202302', 24311, 1, 3, NULL, NULL),
(72, 2, '2023-10-19 00:00:00', '202303', 23538, 1, 3, NULL, NULL),
(73, 2, '2023-10-19 00:00:00', '202304', 23075, 1, 3, NULL, NULL),
(74, 2, '2023-10-19 00:00:00', '202305', 23354, 1, 3, NULL, NULL),
(75, 4, '2023-11-16 00:00:00', '202311', 9000, 1, 3, NULL, NULL),
(76, 2, '2023-11-16 00:00:00', '202306', 23516, 1, 3, NULL, NULL),
(77, 2, '2023-11-16 00:00:00', '202307', 23325, 1, 3, NULL, NULL),
(78, 2, '2023-11-16 00:00:00', '202308', 23435, 1, 3, NULL, NULL),
(79, 2, '2023-11-16 00:00:00', '202309', 23374, 1, 3, NULL, NULL),
(82, 2, '2023-12-01 00:00:00', '202311', 18500, 1, 3, NULL, NULL),
(81, 2, '2023-11-16 00:00:00', '202310', 18500, 1, 3, NULL, NULL),
(83, 4, '2023-12-13 00:00:00', '202312', 9000, 1, 3, NULL, NULL),
(84, 2, '2024-01-01 00:00:00', '202312', 18500, 1, 3, NULL, NULL),
(85, 2, '2024-01-30 00:00:00', '202401', 18500, 1, 3, NULL, NULL),
(86, 4, '2024-02-14 00:00:00', '202401', 10000, 1, 3, NULL, NULL),
(87, 4, '2024-02-14 00:00:00', '202402', 10000, 1, 3, NULL, NULL),
(88, 2, '2024-02-26 00:00:00', '202402', 18000, 1, 3, NULL, NULL),
(89, 2, '2024-03-31 00:00:00', '202403', 18000, 1, 3, NULL, NULL),
(90, 4, '2024-04-15 00:00:00', '202403', 9000, 1, 3, NULL, NULL),
(91, 4, '2024-04-15 00:00:00', '202404', 9000, 1, 3, NULL, NULL),
(92, 2, '2024-05-09 00:00:00', '202404', 18000, 1, 3, NULL, NULL),
(93, 2, '2024-05-31 00:00:00', '202405', 18000, 1, 3, NULL, NULL),
(94, 5, '2024-06-04 00:00:00', '202406', 28000, 1, 3, NULL, NULL),
(95, 2, '2024-07-01 00:00:00', '202406', 18000, 1, 3, NULL, NULL),
(96, 5, '2024-07-09 00:00:00', '202407', 8000, 1, 3, NULL, NULL),
(97, 2, '2024-07-30 00:00:00', '202407', 18000, 1, 3, NULL, NULL),
(98, 5, '2024-08-12 00:00:00', '202408', 8000, 1, 3, NULL, NULL),
(99, 2, '2024-08-30 00:00:00', '202408', 18000, 1, 3, NULL, NULL),
(100, 5, '2024-09-11 00:00:00', '202409', 8000, 1, 3, NULL, NULL),
(101, 2, '2024-09-27 00:00:00', '202409', 18000, 1, 3, NULL, NULL),
(102, 5, '2024-10-12 00:00:00', '202410', 8000, 1, 3, NULL, NULL),
(103, 2, '2024-10-29 00:00:00', '202410', 18000, 1, 3, NULL, NULL),
(104, 5, '2024-11-12 00:00:00', '202411', 8000, 1, 3, NULL, NULL),
(105, 2, '2024-11-30 00:00:00', '202411', 18000, 1, 3, NULL, NULL),
(106, 5, '2024-12-11 00:00:00', '202412', 8000, 1, 3, NULL, NULL),
(107, 2, '2025-01-01 00:00:00', '202412', 18000, 1, 3, NULL, NULL),
(108, 5, '2025-01-11 00:00:00', '202501', 8000, 1, 3, NULL, NULL),
(109, 1, '2025-01-15 00:00:00', '202412', 14000, 1, 3, NULL, NULL),
(110, 1, '2025-01-15 00:00:00', '202501', 14000, 1, 3, NULL, NULL),
(111, 0, '2025-01-16 00:00:00', '202306', 1, 1, 3, NULL, NULL),
(112, 0, '2025-01-16 00:00:00', '202312', 1, 1, 3, NULL, NULL),
(113, 0, '2025-01-16 00:00:00', '202412', 1, 1, 3, NULL, NULL),
(114, 0, '2025-01-16 00:00:00', '202501', 1, 1, 3, NULL, NULL),
(115, 6, '2025-01-01 00:00:00', '202501', 1, 0, 3, 3, '2025-01-17 15:25:49'),
(116, 6, '2025-01-17 00:00:00', '202412', 1, 1, 3, NULL, NULL),
(117, 6, '2025-01-17 00:00:00', '202411', 1, 1, 3, NULL, NULL),
(118, 6, '2025-01-17 00:00:00', '202410', 1, 1, 3, NULL, NULL),
(119, 2, '2025-01-30 00:00:00', '202501', 18000, 1, 3, NULL, NULL),
(120, 1, '2025-02-07 00:00:00', '202502', 1, 1, 3, NULL, NULL),
(121, 5, '2025-02-11 00:00:00', '202502', 8000, 1, 3, NULL, NULL),
(122, 2, '2025-03-03 00:00:00', '202502', 18000, 1, 3, NULL, NULL),
(123, 5, '2025-03-11 00:00:00', '202503', 8000, 1, 3, NULL, NULL),
(124, 1, '2025-03-24 00:00:00', '202503', 1, 1, 3, NULL, NULL),
(125, 1, '2025-03-24 00:00:00', '202504', 1, 1, 3, NULL, NULL),
(126, 2, '2025-04-05 00:00:00', '202503', 18000, 1, 3, NULL, NULL),
(127, 1, '2025-04-05 00:00:00', '202505', 1, 1, 3, NULL, NULL),
(128, 1, '2025-04-05 00:00:00', '202506', 1, 1, 3, NULL, NULL),
(129, 5, '2025-04-09 00:00:00', '202504', 8000, 1, 3, NULL, NULL),
(130, 7, '2025-04-21 00:00:00', '202504', 1, 0, 49, 49, '2025-04-21 18:14:06'),
(138, 7, '2025-04-21 00:00:00', '202503', 1, 1, 49, NULL, NULL),
(136, 7, '2025-04-21 00:00:00', '202501', 1, 1, 49, NULL, NULL),
(137, 7, '2025-04-21 00:00:00', '202502', 1, 1, 49, NULL, NULL),
(139, 6, '2025-04-21 00:00:00', '202501', 1, 1, 49, NULL, NULL),
(140, 6, '2025-04-21 00:00:00', '202502', 1, 1, 49, NULL, NULL),
(141, 6, '2025-04-21 00:00:00', '202503', 1, 1, 49, NULL, NULL),
(142, 2, '2025-04-30 00:00:00', '202504', 18000, 1, 3, NULL, NULL),
(143, 7, '2025-05-01 00:00:00', '202504', 9000, 1, 3, NULL, NULL),
(144, 6, '2025-05-05 00:00:00', '202504', 1, 0, 3, 3, '2025-06-11 07:23:31'),
(145, 6, '2025-05-12 00:00:00', '202505', 1, 0, 3, 3, '2025-06-11 07:23:21'),
(146, 5, '2025-05-13 00:00:00', '202505', 8000, 1, 3, NULL, NULL),
(147, 2, '2025-05-30 00:00:00', '202505', 18000, 1, 3, NULL, NULL),
(148, 6, '2025-06-11 00:00:00', '202504', 1, 1, 3, NULL, NULL),
(149, 6, '2025-06-11 00:00:00', '202505', 9000, 1, 3, NULL, NULL),
(150, 6, '2025-06-11 00:00:00', '202506', 1, 0, 3, 3, '2025-06-14 20:50:05'),
(151, 5, '2025-06-12 00:00:00', '202506', 8000, 1, 3, NULL, NULL),
(152, 6, '2025-06-14 00:00:00', '202506', 9000, 1, 3, NULL, NULL),
(153, 2, '2025-06-30 00:00:00', '202506', 18000, 1, 3, NULL, NULL),
(154, 5, '2025-07-10 00:00:00', '202507', 8000, 1, 3, NULL, NULL),
(155, 7, '2025-07-11 00:00:00', '202505', 1, 1, 3, NULL, NULL),
(156, 6, '2025-07-11 00:00:00', '202507', 1, 1, 3, NULL, NULL),
(157, 1, '2025-07-27 00:00:00', '202507', 1, 1, 3, NULL, NULL),
(158, 2, '2025-07-29 00:00:00', '202507', 18000, 1, 3, NULL, NULL),
(159, 6, '2025-08-07 00:00:00', '202508', 9000, 1, 3, NULL, NULL),
(160, 5, '2025-08-11 00:00:00', '202508', 8000, 1, 3, NULL, NULL),
(161, 2, '2025-08-30 00:00:00', '202508', 18000, 1, 3, NULL, NULL),
(162, 5, '2025-09-10 00:00:00', '202509', 8000, 1, 3, NULL, NULL),
(163, 6, '2025-09-11 00:00:00', '202509', 9000, 1, 3, NULL, NULL),
(164, 1, '2025-09-16 00:00:00', '202508', 1, 1, 3, NULL, NULL),
(165, 1, '2025-09-16 00:00:00', '202509', 1, 1, 3, NULL, NULL),
(166, 2, '2025-09-30 00:00:00', '202509', 18000, 1, 3, NULL, NULL),
(167, 6, '2025-10-09 00:00:00', '202510', 9000, 1, 3, NULL, NULL),
(168, 5, '2025-10-13 00:00:00', '202510', 8000, 1, 3, NULL, NULL),
(169, 1, '2025-10-14 00:00:00', '202510', 1, 1, 3, NULL, NULL),
(170, 2, '2025-10-30 00:00:00', '202510', 18000, 1, 3, NULL, NULL),
(171, 6, '2025-11-07 00:00:00', '202511', 9000, 1, 3, NULL, NULL),
(172, 5, '2025-11-11 00:00:00', '202511', 8000, 1, 3, NULL, NULL),
(173, 1, '2025-11-11 00:00:00', '202511', 1, 1, 3, NULL, NULL),
(174, 1, '2025-11-11 00:00:00', '202512', 1, 1, 3, NULL, NULL),
(175, 2, '2025-12-02 00:00:00', '202511', 18000, 1, 3, NULL, NULL),
(176, 6, '2025-12-05 00:00:00', '202512', 9000, 1, 3, NULL, NULL),
(177, 5, '2025-12-11 00:00:00', '202512', 8000, 1, 3, NULL, NULL),
(178, 2, '2025-12-30 00:00:00', '202512', 18000, 1, 3, NULL, NULL),
(179, 6, '2026-01-07 00:00:00', '202601', 9000, 1, 3, NULL, NULL),
(180, 5, '2026-01-13 00:00:00', '202601', 8000, 1, 3, NULL, NULL),
(181, 2, '2026-01-30 00:00:00', '202601', 18000, 1, 3, NULL, NULL),
(182, 6, '2026-02-09 00:00:00', '202602', 9000, 1, 3, NULL, NULL),
(183, 5, '2026-02-11 00:00:00', '202602', 8000, 1, 3, NULL, NULL),
(184, 2, '2026-03-03 00:00:00', '202602', 18000, 1, 3, NULL, NULL),
(185, 6, '2026-03-05 00:00:00', '202603', 9000, 1, 3, NULL, NULL),
(186, 5, '2026-03-14 00:00:00', '202603', 8000, 1, 3, NULL, NULL),
(187, 1, '2026-03-14 00:00:00', '202601', 1, 1, 3, NULL, NULL),
(188, 1, '2026-03-14 00:00:00', '202602', 1, 1, 3, NULL, NULL),
(189, 1, '2026-03-14 00:00:00', '202603', 1, 1, 3, NULL, NULL),
(190, 1, '2026-03-14 00:00:00', '202604', 1, 1, 3, NULL, NULL),
(191, 2, '2026-04-07 00:00:00', '202603', 18000, 1, 3, NULL, NULL),
(192, 6, '2026-04-07 00:00:00', '202604', 9000, 1, 3, NULL, NULL),
(193, 5, '2026-04-14 00:00:00', '202604', 8000, 1, 3, NULL, NULL),
(194, 2, '2026-04-30 00:00:00', '202604', 18000, 1, 3, NULL, NULL),
(195, 6, '2026-05-06 00:00:00', '202605', 9000, 1, 3, NULL, NULL),
(196, 5, '2026-05-23 00:00:00', '202605', 8000, 1, 3, NULL, NULL),
(197, 2, '2026-05-30 00:00:00', '202605', 18000, 1, 3, NULL, NULL),
(198, 6, '2026-06-04 00:00:00', '202606', 9000, 1, 3, NULL, NULL),
(199, 5, '2026-06-11 00:00:00', '202606', 8000, 1, 3, NULL, NULL),
(200, 2, '2026-06-30 00:00:00', '202606', 18000, 1, 3, NULL, NULL),
(201, 6, '2026-07-03 00:00:00', '202607', 9000, 1, 3, NULL, NULL),
(202, 5, '2026-07-13 00:00:00', '202607', 8000, 1, 3, NULL, NULL),
(203, 6, '2026-08-10 00:00:00', '202608', 9000, 1, 3, NULL, NULL),
(204, 5, '2026-08-11 00:00:00', '202608', 8000, 1, 3, NULL, NULL),
(205, 2, '2026-08-23 00:00:00', '202607', 18000, 1, 3, NULL, NULL),
(206, 1, '2026-08-23 00:00:00', '202605', 1, 1, 3, NULL, NULL),
(207, 1, '2026-08-23 00:00:00', '202606', 1, 1, 3, NULL, NULL),
(208, 1, '2026-08-23 00:00:00', '202607', 1, 1, 3, NULL, NULL),
(209, 1, '2026-08-23 00:00:00', '202608', 1, 1, 3, NULL, NULL),
(210, 1, '2026-08-23 00:00:00', '202609', 1, 1, 3, NULL, NULL);

DROP TABLE IF EXISTS `tx_params`;
CREATE TABLE `tx_params` (
  `id` int(11) NOT NULL,
  `kapp_id` int(11) NOT NULL,
  `tx_params_cat_id` varchar(45) DEFAULT NULL,
  `valor` varchar(1500) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `tx_params` (`id`, `kapp_id`, `tx_params_cat_id`, `valor`) VALUES
(1, 1, '1', 'Al ser las Hhora del Ddia, entre nosotros, Gerardo Torres Castro, en representación de Electrónica Torres, que en adelante se le conocerá como EL TALLER, y Ccliente, que se conocerá como EL CLIENTE, se suscribe el siguiente convenio de servicios al amparo del Código del Comercio:\n1. Todo articulo paga revisión por adelantado\r 2. Después de notificado el presupuesto, si este NO ES ACEPTADO, EL CLIENTE\r contara con 7 días naturales para retirar el artículo.\r 3. Todo artículo debe ser retirado con este recibo/boleta.\r 4. Una vez aprobado el presupuesto, EL CLIENTE tendra 7 días naturales para cancelar el 50% de la reparación. De lo contrario debera retirarlo. Una vez reparado tendrá 7 días naturales para hacer el pago del 50% restante o saldo y retirar el artículo.\r 5. En caso de que no se retire el artículo en las fechas establecidas, EL TALLER hará uso de este para cubrir los gastos o para desecharlo.\r 6. En caso de que haya transcurrido el tiempo para retirar el articulo, y EL TALLER todavía no haya desechado o utilizado el artículo, EL CLIENTE podrá retirar el artículo si cubre los gastos de bodegaje y mano de obra. (Bodega 500 colones por día después de la fecha límite)\r 7. EL TALLER y EL CLIENTE suscriben el siguiente convenio a partir del momento de formalización del contrato de servicio y conocedores de todos los efectos legales que de ello deriva.'),
(2, 1, '2', '* Nuestro trabajo es garantizado por 30 días.\n* Este comprobante es necesario para hacer efectiva la garantía\n* El artículo es garantizado si viene con el mismo daño por el cual se reparó siempre que la avería no sea consecuencia de un mal uso del artículo por parte del usuario.\n* No se cubren garantías por daños causados por rayos o descargas de alto voltaje\n\nEste comprobante no puede ser utilizado para fines tributarios, por lo cual no se permitirá su uso para respaldo de créditos o gastos'),
(3, 1, '3', '14'),
(4, 1, '4', '30'),
(5, 1, '5', '500'),
(6, 1, '6', '13'),
(7, 1, '7', '5.8'),
(8, 1, '8', '0'),
(9, 1, '9', '13'),
(10, 1, '10', 'Estimado cliente\r %0A%0A\r Electrónica Torres le informa que cuenta con 15 días naturales para retirar su artículo. Después de transcurrido ese tiempo se procederá a generar cobro por bodegaje. (¢500 colones por día)\r %0ASi desea que su artículo sea procesado para su desecho, favor confimarlo. O por favor proporcoine la fecha del retiro.%0A%0ALe deseamos un buen día'),
(11, 1, '11', 'www.kapps.me/etgu/'),
(12, 1, '12', 'Estimado cliente, para proceder a realizar sus reparaciones, se deberá cancelar el 50% por adelantado. Sólo en caso de que el costo de su reparación sea menor a 40,000 colones no deberá hacer el adelanto.\r\n\r\nNuestras cuentas de Banco\r\n\r\nBANCO NACIONAL\r\nCuenta IBAN: CR79015106220010187788\r\n\r\nNúmero de SINPE móvil 8669-9904\r\n\r\nA nombre de: Bryan Torres Castro\r\n'),
(13, 1, '13', 'Estimado cliente, por favor vea nuestra Política de garantía en nuestra página web:\r https://electronicatorres.minidux.com/contents/9/politica-de-garantia'),
(14, 1, '14', '13'),
(15, 1, '15', '1'),
(16, 1, '16', 'Kenny Rodriguez'),
(17, 1, '17', 'C11875516180'),
(18, 1, '18', 'TEL. 4080-4841 / 6022-6611'),
(19, 1, '19', 'NUEVA'),
(20, 1, '20', 'DIAGNOSTICO'),
(21, 1, '21', 'COTIZACION'),
(22, 1, '22', 'CONFIRMACION CLIENTE'),
(23, 1, '23', 'REPARACION'),
(24, 1, '24', 'LISTO PARA RETIRO'),
(25, 1, '25', 'FACTURAR'),
(26, 1, '26', 'RETIRADO SIN FACTURAR'),
(27, 1, '27', 'RECHAZOS'),
(28, 1, '28', 'BODEGAJE'),
(29, 1, '29', ''),
(30, 1, '30', ''),
(31, 1, '37', 'Solicitud de Retiro de Inventario'),
(33, 6, '38', '1'),
(35, 6, '37', 'Solicitud de Despacho de Inventario'),
(36, 1, '56', '1'),
(37, 7, '31', '0'),
(38, 7, '56', '1'),
(39, 7, '50', 'Venta'),
(40, 1, '49', '1'),
(41, 1, '31', '1'),
(42, 1, '57', '1'),
(43, 6, '57', '1'),
(44, 6, '58', '1'),
(45, 6, '60', '1'),
(46, 6, '61', 'Máquinas'),
(47, 1, '58', '1'),
(48, 6, '62', '4'),
(49, 1, '61', 'Máquina'),
(50, 1, '38', '1'),
(51, 6, '68', '1');

DROP TABLE IF EXISTS `tx_params_cat`;
CREATE TABLE `tx_params_cat` (
  `id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `descripcion` varchar(45) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL,
  `html_type` varchar(25) DEFAULT NULL,
  `html_additional` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `customizable` tinyint(1) DEFAULT 0,
  `required` tinyint(1) DEFAULT 1,
  `system` tinyint(1) DEFAULT 0,
  `default_value` varchar(1500) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `tx_params_cat` (`id`, `module_id`, `nombre`, `descripcion`, `estado`, `html_type`, `html_additional`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES
(1, 1, 'pdf boleta', NULL, 1, 'textarea', 'rows=10 style=width:100%', 'PARAMETERS', 1, 1, 0, '1'),
(2, 1, 'pdf comprobante', NULL, 1, 'textarea', 'rows=10 style=width:100%', 'PARAMETERS', 1, 1, 0, '1'),
(3, 1, 'dias rechazo bodega', NULL, 1, 'number', '', 'PARAMETERS', 1, 1, 0, '1'),
(4, 1, 'dias facturacion bodega', NULL, 1, 'number', '', 'PARAMETERS', 1, 1, 0, '1'),
(5, 1, 'Cobro Bodegaje', NULL, 1, 'number', '', 'PARAMETERS', 1, 1, 0, '1'),
(6, 1, 'Impuesto Repuesto Nuevo', NULL, 1, 'number', '', 'PARAMETERS', 1, 1, 0, '1'),
(7, 1, 'Impuesto Repuesto Usado', NULL, 1, 'number', '', 'PARAMETERS', 1, 1, 0, '1'),
(8, 1, 'Impuesto Bodegaje', NULL, 1, 'number', '', 'PARAMETERS', 1, 1, 0, '1'),
(9, 1, 'Impuesto Servicio Reparación', NULL, 1, 'number', '', 'PARAMETERS', 1, 1, 0, '1'),
(10, 1, 'MSG - Notificación de Rechazo', NULL, 1, 'textarea', 'rows=10 style=width:100%', 'PARAMETERS', 1, 1, 0, '1'),
(11, 1, 'Ruta Servidor', NULL, 1, 'text', '', 'PARAMETERS', 1, 1, 0, '1'),
(12, 1, 'Cuentas Bancarias', NULL, 1, 'textarea', 'rows=10 style=width:100%', 'PARAMETERS', 1, 1, 0, '1'),
(13, 1, 'Pdf Comprobante Ventas', NULL, 1, 'textarea', 'rows=10 style=width:100%', 'PARAMETERS', 1, 1, 0, '1'),
(14, 1, 'Impuesto Servicio Técnico', NULL, 1, 'number', '', 'PARAMETERS', 1, 1, 0, '1'),
(15, 1, 'Impuesto Genérico 0%', NULL, 1, 'number', '', 'PARAMETERS', 1, 1, 0, '1'),
(16, 1, 'Representante NOMBRE', NULL, 1, 'text', '', 'PARAMETERS', 1, 1, 0, '1'),
(17, 1, 'Representante ID', NULL, 1, 'text', '', 'PARAMETERS', 1, 1, 0, '1'),
(18, 1, 'Contacto', NULL, 1, 'text', '', 'PARAMETERS', 1, 1, 0, '1'),
(19, 1, 'STAGE1', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(20, 1, 'STAGE2', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(21, 1, 'STAGE3', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(22, 1, 'STAGE4', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(23, 1, 'STAGE5', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(24, 1, 'STAGE6', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(25, 1, 'STAGE7', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(26, 1, 'STAGE8', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(27, 1, 'STAGE9', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(28, 1, 'STAGE10', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(29, 1, 'STAGE11', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(30, 1, 'STAGE12', NULL, 1, 'text', 'maxlength=20', 'STAGES', 1, 1, 0, '1'),
(57, 3, 'Descarga de Inventario', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '0'),
(37, 5, 'Nombre Carrito de Compras', NULL, 1, 'text', 'maxlength=50', 'LABELS', 1, 1, 1, 'Carrito de Compras'),
(38, 5, 'Descarga de Inventario', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '0'),
(39, 1, 'correo_contacto', NULL, 1, 'email', '', 'COMUNICACION', 1, 1, 1, 'noreply@kapps.me'),
(40, 1, 'correo_contacto_password', NULL, 1, 'text', '', 'COMUNICACION', 1, 1, 1, 'Qw@uUhF3B!HK'),
(41, 2, 'correo_contacto', NULL, 1, 'email', '', 'COMUNICACION', 1, 1, 1, 'noreply@kapps.me'),
(42, 2, 'correo_contacto_password', NULL, 1, 'text', '', 'COMUNICACION', 1, 1, 1, 'Qw@uUhF3B!HK'),
(43, 3, 'correo_contacto', NULL, 1, 'email', '', 'COMUNICACION', 1, 1, 1, 'noreply@kapps.me'),
(44, 3, 'correo_contacto_password', NULL, 1, 'text', '', 'COMUNICACION', 1, 1, 1, 'Qw@uUhF3B!HK'),
(45, 4, 'correo_contacto', NULL, 1, 'email', '', 'COMUNICACION', 1, 1, 1, 'noreply@kapps.me'),
(46, 4, 'correo_contacto_password', NULL, 1, 'text', '', 'COMUNICACION', 1, 1, 1, 'Qw@uUhF3B!HK'),
(47, 5, 'correo_contacto', NULL, 1, 'email', '', 'COMUNICACION', 1, 1, 1, 'noreply@kapps.me'),
(48, 5, 'correo_contacto_password', NULL, 1, 'text', '', 'COMUNICACION', 1, 1, 1, 'Qw@uUhF3B!HK'),
(49, 2, 'Descarga de Inventario', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '0'),
(50, 2, 'Nombre Carrito de Compras', NULL, 1, 'text', 'maxlength=50', 'LABELS', 1, 1, 1, 'Carrito de Compras'),
(51, 2, 'Recibe Pagos', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '1'),
(52, 2, 'Efectivo', NULL, 1, 'CHECKBOX', NULL, 'PAGOS', 1, 1, 1, '1'),
(53, 2, 'SINPE', NULL, 1, 'CHECKBOX', NULL, 'PAGOS', 1, 1, 1, '1'),
(54, 2, 'Tarjeta', NULL, 1, 'CHECKBOX', NULL, 'PAGOS', 1, 1, 1, '1'),
(55, 2, 'A Crédito', NULL, 1, 'CHECKBOX', NULL, 'PAGOS', 1, 1, 1, '1'),
(56, 2, 'Sección de Gastos', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '0'),
(58, 3, 'Uso de Proveedores', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '0'),
(60, 5, 'Base de Productos Por Cliente', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '1'),
(61, 5, 'Nombre Boton Edicion Cliente', NULL, 1, 'text', NULL, 'LABELS', 1, 1, 1, '1'),
(59, 2, 'Sección de Crédito', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '1'),
(62, 3, 'Semanas para TRP', NULL, 1, 'number', NULL, 'PARAMETERS', 1, 1, 1, '12'),
(63, 2, 'Sección de Favoritos', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '1'),
(64, 2, 'Cantidad de Favoritos', NULL, 1, 'number', NULL, 'PARAMETERS', 1, 1, 1, '6'),
(65, 0, 'Vencimiento de Sesion', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '1'),
(66, 2, 'Sección de Catálogo', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '1'),
(67, 2, 'Cliente Mandatorio en Registro de Venta', NULL, 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '1'),
(68, 6, 'Sesión Única', 'Se mantiene la sesión hasta el logout', 1, 'CHECKBOX', NULL, 'PARAMETERS', 1, 1, 1, '1');


ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `accounts_log`
  ADD PRIMARY KEY (`id_account`);

ALTER TABLE `accounts_recovers`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `accounts_session_resets`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `kapps`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `kapps_modules`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `kapps_modules_cat`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `kapp_conf_cat`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `padron_cr`
  ADD PRIMARY KEY (`cedula`);

ALTER TABLE `padron_cr2`
  ADD PRIMARY KEY (`cedula`);

ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `tx_params`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `tx_params_cat`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

ALTER TABLE `accounts_recovers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

ALTER TABLE `accounts_session_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

ALTER TABLE `kapps_modules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

ALTER TABLE `kapps_modules_cat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

ALTER TABLE `pagos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=211;

ALTER TABLE `tx_params`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

ALTER TABLE `tx_params_cat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
