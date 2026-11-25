-- =====================================================================
-- SANDBOX (GoDaddy): desactivar máquinas/productos y bitácora de cambios para tx_pre + kapps_db_pre.
-- Generado con: sh sql_ambiente.sh kapps_db_pre (sección «2026-11-24 Activar/desactivar máquinas…» de SQL_DDL_DML_UPDATES.sql).
-- Solo agrega: 2 filas de ctz_base, la tabla bitacora_cambios, 1 parámetro en kapps_db_pre.tx_params_cat
-- y el índice idx_fecha de inv_lotes_log. Idempotente. Correr en phpMyAdmin con tx_pre seleccionada.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 2026-11-24  Activar/desactivar máquinas (DESPACHO) y productos (INVENTARIO)
--             + bitácora de cambios
--   * Campo de sistema ACTIVO: Admin › Campos lo activa por KAPP en la
--     pantalla CLIENTE de Despacho (20) y/o PRODUCTO (21). Sin fila de
--     dato = activo; valor '0' = desactivado. TX usa estos ids fijos.
--   * bitacora_cambios: altas y modificaciones de productos, lotes y
--     máquinas (los movimientos de inventario siguen en inv_lotes_log).
--   * Parámetro "Bitácora de cambios" (CONFIGURACION). Desactivar y
--     reactivar se registran siempre.
--   * Índice por fecha en inv_lotes_log (MyISAM): bloquea escrituras unos
--     segundos mientras se crea; aplicar fuera del horario de despachos.
--   Solo agrega: no modifica ni borra datos existentes.
-- ---------------------------------------------------------------------
SET NAMES utf8mb4;  -- el nombre del parámetro lleva tilde: que no dependa del cliente con que se aplique
INSERT INTO ctz_base (id, id_module_cat, id_module_screen, field_name, id_field_type, is_customizable, is_active)
SELECT 20, 5, 4, 'ACTIVO', 4, 1, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ctz_base WHERE id = 20);

INSERT INTO ctz_base (id, id_module_cat, id_module_screen, field_name, id_field_type, is_customizable, is_active)
SELECT 21, 3, 1, 'ACTIVO', 4, 1, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ctz_base WHERE id = 21);

CREATE TABLE IF NOT EXISTS bitacora_cambios (
    id          INT NOT NULL AUTO_INCREMENT,
    kapp_id     INT NOT NULL,
    entidad     VARCHAR(10) NOT NULL COMMENT 'producto | lote | maquina',
    entidad_id  INT NOT NULL,
    accion      VARCHAR(12) NOT NULL COMMENT 'crear | modificar | desactivar | reactivar | parlevel',
    id_usuario  INT NULL,
    fecha       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'hora de la sesión (-6:00), igual que inv_lotes_log',
    detalle     JSON NULL COMMENT '[{campo, antes, despues}]',
    PRIMARY KEY (id),
    KEY ix_bitacora_kapp_fecha (kapp_id, fecha),
    KEY ix_bitacora_entidad (kapp_id, entidad, entidad_id, fecha)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

INSERT INTO kapps_db_pre.tx_params_cat
    (module_id, nombre, descripcion, estado, html_type, category, customizable, required, `system`, default_value)
SELECT 6, 'Bitácora de cambios', 'Registra cambios de productos y máquinas', 1, 'CHECKBOX', 'PARAMETERS', 1, 1, 1, '0'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM kapps_db_pre.tx_params_cat WHERE module_id = 6 AND nombre = 'Bitácora de cambios');

SET @ill_idx := (SELECT COUNT(*) FROM information_schema.statistics
                 WHERE table_schema = DATABASE() AND table_name = 'inv_lotes_log' AND index_name = 'idx_fecha');
SET @ill_sql := IF(@ill_idx = 0, 'ALTER TABLE inv_lotes_log ADD INDEX idx_fecha (fecha)', 'SELECT 1');
PREPARE ill_stmt FROM @ill_sql;
EXECUTE ill_stmt;
DEALLOCATE PREPARE ill_stmt;
