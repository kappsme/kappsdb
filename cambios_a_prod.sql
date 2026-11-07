
-- PARLEVEL: carga de Prekitting (CSV ProntoSnack)
CREATE TABLE tx.parlevel_productos_prekiting (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_carga CHAR(36) NOT NULL,
  id_kapp INT NOT NULL,
  id_usuario INT NOT NULL,
  nombre_archivo VARCHAR(255),
  fecha_proceso DATETIME DEFAULT CURRENT_TIMESTAMP,
  daily_route VARCHAR(20), planned_for DATE, route VARCHAR(100), location VARCHAR(150),
  asset VARCHAR(50), machine VARCHAR(100), transaccion VARCHAR(20), prekit_alias VARCHAR(20),
  cst_id VARCHAR(20), product VARCHAR(200), price DECIMAL(12,4), prekit_quantity INT,
  parlevel INT, filler_username VARCHAR(100), delivery_sequence INT,
  id_producto INT NULL,
  existencia INT NULL,
  requerido_total INT NULL,
  estado_disponibilidad VARCHAR(20),
  id_cliente INT NULL,
  KEY ix_carga (id_carga), KEY ix_kapp_fecha (id_kapp, planned_for, daily_route)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tx.parlevel_maquinas_map (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_kapp INT NOT NULL,
  parlevel_machine VARCHAR(100) NOT NULL,
  id_cliente INT NOT NULL,
  UNIQUE KEY uq_kapp_machine (id_kapp, parlevel_machine),
  UNIQUE KEY uq_kapp_cliente (id_kapp, id_cliente)  -- 1 a 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Relacion 1 a 1 de productos (la tabla ya existe; ajustar nombres de columnas si difieren).
-- Antes de correrlo, revisar que no haya duplicados:
--   SELECT id_kapp, parlevel_nombre, COUNT(*) FROM tx.parlevel_productos_map GROUP BY 1,2 HAVING COUNT(*)>1;
--   SELECT id_kapp, id_producto, COUNT(*) FROM tx.parlevel_productos_map GROUP BY 1,2 HAVING COUNT(*)>1;
ALTER TABLE tx.parlevel_productos_map
  ADD UNIQUE KEY uq_kapp_nombre (id_kapp, parlevel_nombre),
  ADD UNIQUE KEY uq_kapp_producto (id_kapp, id_producto);
