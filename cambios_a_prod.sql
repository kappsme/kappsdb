create table kapps_db.accounts_session_resets
(id int primary key auto_increment,
user_id int,
codigo varchar(12),
estado int default 1,
fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
fecha_uso timestamp);



INSERT INTO `kapps_db`.`tx_params_cat` (`id`, `module_id`, `nombre`, `estado`, `html_type`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES ('65', '0', 'Vencimiento de Sesion', '1', 'CHECKBOX', 'PARAMETERS', '1', '1', '1', '1');
INSERT INTO `kapps_db`.`kapps_modules_cat` (`id`, `type`, `name`, `description`, `active`, `code`) VALUES ('0', 'MAIN', 'CONFIGURACION', 'Configuración General de la KAPP', '1', 'man');
INSERT INTO `kapps_db`.`tx_params_cat` (`id`, `module_id`, `nombre`, `estado`, `html_type`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES ('66', '2', 'Sección de Catálogo', '1', 'CHECKBOX', 'PARAMETERS', '1', '1', '1', '1');
INSERT INTO `kapps_db`.`tx_params_cat` (`id`, `module_id`, `nombre`, `estado`, `html_type`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES ('67', '2', 'Hacer Cliente Mandatorio en registro de Venta', '1', 'CHECKBOX', 'PARAMETERS', '1', '1', '1', '1');
