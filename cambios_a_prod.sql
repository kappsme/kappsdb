INSERT INTO `kapps_db`.`tx_params_cat` (`id`, `module_id`, `nombre`, `estado`, `html_type`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES ('51', '2', 'Recibe Pagos', '1', 'CHECKBOX', 'PAGOS', '1', '1', '1', '1');
INSERT INTO `kapps_db`.`tx_params_cat` (`id`, `module_id`, `nombre`, `estado`, `html_type`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES ('52', '2', 'Efectivo', '1', 'CHECKBOX', 'PAGOS', '1', '1', '1', '1');
INSERT INTO `kapps_db`.`tx_params_cat` (`id`, `module_id`, `nombre`, `estado`, `html_type`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES ('53', '2', 'SINPE', '1', 'CHECKBOX', 'PAGOS', '1', '1', '1', '1');
INSERT INTO `kapps_db`.`tx_params_cat` (`id`, `module_id`, `nombre`, `estado`, `html_type`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES ('54', '2', 'Tarjeta', '1', 'CHECKBOX', 'PAGOS', '1', '1', '1', '1');
INSERT INTO `kapps_db`.`tx_params_cat` (`id`, `module_id`, `nombre`, `estado`, `html_type`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES ('55', '2', 'A Crédito', '1', 'CHECKBOX', 'PAGOS', '1', '1', '1', '1');



create table tx.tnd_ventas
(id int primary key auto_increment,
id_kapp int,
id_cliente int,
fecha datetime default now(),
id_usuario int);

 create table tx.tnd_ventas_datos
 (id int primary key auto_increment,
 id_venta int,
 id_producto int,
 unidades int,
 precio_unitario decimal,
 id_lote int,
 monto_total decimal,
 descuento decimal,
 impuesto decimal
 );

INSERT INTO `tx`.`ctz_base` (`id_module_cat`, `id_module_screen`, `field_name`, `id_field_type`, `is_customizable`, `is_active`) VALUES ('2', '3', 'NOMBRE', '1', '1', '1');
INSERT INTO `tx`.`ctz_base` (`id_module_cat`, `id_module_screen`, `field_name`, `id_field_type`, `is_customizable`, `is_active`) VALUES ('2', '3', 'APELLIDO', '1', '1', '1');
INSERT INTO `tx`.`ctz_base` (`id_module_cat`, `id_module_screen`, `field_name`, `id_field_type`, `is_customizable`, `is_active`) VALUES ('2', '3', 'TELEFONO', '2', '1', '1');

INSERT INTO `kapps_db`.`tx_params_cat` (`id`, `module_id`, `nombre`, `estado`, `html_type`, `category`, `customizable`, `required`, `system`, `default_value`) VALUES ('56', '2', 'Sección de Gastos', '1', 'CHECKBOX', 'PARAMETERS', '1', '1', '1', '0');


UPDATE `kapps_db`.`tx_params_cat` SET `category` = 'LABELS' WHERE (`id` = '50');
UPDATE `kapps_db`.`tx_params_cat` SET `category` = 'LABELS' WHERE (`id` = '37');

INSERT INTO `tx`.`ctz_module_screens` (`id`, `id_module_cat`, `screen_name`, `is_active`) VALUES ('5', '2', 'GASTOS', '1');

INSERT INTO `tx`.`ctz_base` (`id`, `id_module_cat`, `id_module_screen`, `field_name`, `id_field_type`, `is_customizable`, `is_active`) VALUES ('10', '2', '5', 'FECHA', '3', '1', '1');

INSERT INTO `tx`.`ctz_base` (`id`, `id_module_cat`, `id_module_screen`, `field_name`, `id_field_type`, `is_customizable`, `is_active`) VALUES ('11', '2', '5', 'CATEGORIA', '8', '1', '1');
INSERT INTO `tx`.`ctz_base` (`id`, `id_module_cat`, `id_module_screen`, `field_name`, `id_field_type`, `is_customizable`, `is_active`) VALUES ('12', '2', '5', 'DESCRIPCION', '1', '1', '1');
INSERT INTO `tx`.`ctz_base` (`id`, `id_module_cat`, `id_module_screen`, `field_name`, `id_field_type`, `is_customizable`, `is_active`) VALUES ('13', '2', '5', 'MONTO', '2', '1', '1');
