-- =====================================================================
-- SOLO DOCKER LOCAL. NUNCA correr en producción ni en el sandbox de GoDaddy.
-- Lo aplica kappsdbsetup (tx/docker-compose.yml) después de SQL_DDL_DML_UPDATES.sql,
-- en kapps_db y, traducido con sql_ambiente.sh, en kapps_db_pre. Idempotente.
-- =====================================================================

-- Usuarios de desarrollo kenny y kenny1 (kapp_id 0): edad y política ya registradas,
-- para no pasar por /bienvenida. Solo llena lo que falta; no cambia lo que ya tengan.
-- Si sube perfil.POLITICA_VERSION, /bienvenida volverá a pedir aceptar la política.
UPDATE kapps_db.accounts
   SET fecha_nacimiento = COALESCE(fecha_nacimiento, '1991-01-29'),
       politica_version = COALESCE(politica_version, '2026-11-19'),
       politica_fecha   = COALESCE(politica_fecha, NOW())
 WHERE kapp_id = 0 AND username IN ('kenny', 'kenny1');

-- Tenant de pruebas TXPR: solo Configuración, Inventario, Despacho y Barberías.
DELETE m FROM kapps_db.kapps_modules m
  JOIN kapps_db.kapps k ON k.id = m.kapp_id
 WHERE k.clave = 'TXPR'
   AND m.module_id NOT IN (SELECT id FROM kapps_db.kapps_modules_cat WHERE code IN ('inv', 'dpt', 'brb') OR id = 6);

INSERT INTO kapps_db.kapps_modules (kapp_id, module_id)
SELECT k.id, c.id
  FROM kapps_db.kapps k
  JOIN kapps_db.kapps_modules_cat c ON c.code IN ('inv', 'dpt', 'brb') OR c.id = 6
 WHERE k.clave = 'TXPR'
   AND NOT EXISTS (SELECT 1 FROM kapps_db.kapps_modules m WHERE m.kapp_id = k.id AND m.module_id = c.id);

-- TXPR con la Caja de Barberías activa (parámetro categoría CAJA del módulo brb; en Admin se puede apagar).
UPDATE kapps_db.tx_params p
  JOIN kapps_db.kapps k ON k.id = p.kapp_id
  JOIN kapps_db.tx_params_cat c ON c.id = p.tx_params_cat_id
  JOIN kapps_db.kapps_modules_cat mc ON mc.id = c.module_id
   SET p.valor = '1'
 WHERE k.clave = 'TXPR' AND c.category = 'CAJA' AND mc.code = 'brb';

INSERT INTO kapps_db.tx_params (kapp_id, tx_params_cat_id, valor)
SELECT k.id, c.id, '1'
  FROM kapps_db.kapps k
  JOIN kapps_db.tx_params_cat c ON c.category = 'CAJA'
  JOIN kapps_db.kapps_modules_cat mc ON mc.id = c.module_id AND mc.code = 'brb'
 WHERE k.clave = 'TXPR'
   AND NOT EXISTS (SELECT 1 FROM kapps_db.tx_params p WHERE p.kapp_id = k.id AND p.tx_params_cat_id = c.id);
