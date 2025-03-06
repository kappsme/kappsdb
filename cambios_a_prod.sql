DROP TABLE IF EXISTS `tx`.`tnd_ventas_pagos`;
create table `tnd_ventas_pagos`
(`id` int primary key auto_increment,
`fecha` datetime default now(),
`id_kapp` int,
`id_module_cat` int,
`id_venta` int,
`monto` decimal,
`medio` int,
`id_usuario_creacion` int,
`estado` int default 1,
`id_usuario_modifica` int
);

INSERT INTO `tx`.`ctz_base` (`id`, `id_module_cat`, `id_module_screen`, `field_name`, `id_field_type`, `is_customizable`, `is_active`) VALUES ('15', '2', '5', 'ESTADO', '4', '1', '1');


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