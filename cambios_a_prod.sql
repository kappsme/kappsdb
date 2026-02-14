INSERT INTO `kapps_db`.`kapps_modules_cat` (`id`, `type`, `name`, `description`, `active`, `code`) VALUES ('0', 'MAIN', 'CONFIGURACION', 'Configuración General de la KAPP', '1', 'man');

INSERT INTO `tx_params_cat`(`id`, `module_id`,`nombre`,`descripcion`,`estado`,`html_type`,`category`,`customizable`,`required`,`system`,`default_value`) VALUES(68, 6,'Sesión Única','Se mantiene la sesión hasta el logout',1,'CHECKBOX','PARAMETERS',1,1,1,'1');

ALTER TABLE `kapps_db`.`accounts` ADD COLUMN `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

