CREATE TABLE `inv_proveedores_conf_ingreso` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_proveedor` int DEFAULT NULL,
  `id_producto` int DEFAULT NULL,
  `unidades` int DEFAULT NULL,
  `id_usuario` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
