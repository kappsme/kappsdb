
ALTER TABLE `kapps_db`.`kapps_modules_cat` 
ADD COLUMN `code` VARCHAR(45) NULL AFTER `parent_id`;

UPDATE `kapps_db`.`kapps_modules_cat` SET `code` = 'tll' WHERE (`id` = '1');
UPDATE `kapps_db`.`kapps_modules_cat` SET `code` = 'tnd' WHERE (`id` = '2');
UPDATE `kapps_db`.`kapps_modules_cat` SET `code` = 'inv' WHERE (`id` = '3');
UPDATE `kapps_db`.`kapps_modules_cat` SET `code` = 'cdx' WHERE (`id` = '4');
UPDATE `kapps_db`.`kapps_modules_cat` SET `code` = 'dpt' WHERE (`id` = '5');





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