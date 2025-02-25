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


SELECT id_elemento,
GROUP_CONCAT( if( ctz.field_name = 'FECHA', IF(ctz.id_field_type=6,value,valor), NULL ) ) AS 'FECHA',
GROUP_CONCAT( if( ctz.field_name = 'CATEGORIA', IF(ctz.id_field_type=6,value,valor), NULL ) ) AS 'CATEGORIA',
GROUP_CONCAT( if( ctz.field_name = 'DESCRIPCION', IF(ctz.id_field_type=6,value,valor), NULL ) ) AS 'DESCRIPCION',
GROUP_CONCAT( if( ctz.field_name = 'MONTO', IF(ctz.id_field_type=6,value,valor), NULL ) ) AS 'MONTO'
			-- ctz.field_name, IF(ctz.id_field_type=6,value,valor) valor
                from tx.elementos_datos ed left join tx.elementos e on e.id=ed.id_elemento
                left join tx.ctz on ctz.id=ed.id_ctz
                left join tx.ctz_fto fto on valor=fto.id 
 where e.id_kapp=1
and e.id in (select id_elemento from tx.elementos_datos where id_ctz in (10,11,12,13))
group by id_elemento order by id_elemento desc limit 10