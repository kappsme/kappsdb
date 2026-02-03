INSERT INTO `kapps_db`.`kapps_modules_cat` (`id`, `type`, `name`, `description`, `active`, `code`) VALUES ('0', 'MAIN', 'CONFIGURACION', 'Configuración General de la KAPP', '1', 'man');


ALTER TABLE `kapps_db`.`accounts` ADD COLUMN `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;