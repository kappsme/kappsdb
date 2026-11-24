-- =====================================================================
-- SQL_DDL_DML_UPDATES.sql
-- Bitácora de cambios (DDL/DML) a la base de datos de KAPPS.
-- Convención:
--   * Una sección por cambio, con fecha (AAAA-MM-DD) y motivo.
--   * Scripts idempotentes: se pueden correr más de una vez sin duplicar datos.
--   * Los cambios nuevos se agregan al FINAL del archivo, nunca se editan los anteriores.
--   * Esquemas (desde 2026-11-20 el sandbox ya no comparte kapps_db con producción):
--       producción: tx + kapps_db        sandbox: tx_pre + kapps_db_pre
--   * Las tablas de datos NUNCA llevan el esquema escrito (nada de tx.tabla ni
--     table_schema = 'tx'): se usa la base seleccionada (USE tx; o USE tx_pre;)
--     y DATABASE(). Así el mismo script sirve para producción y para el sandbox.
--   * Las de administración se escriben SIEMPRE como kapps_db.tabla (y
--     table_schema = 'kapps_db'). Para el sandbox se traduce con
--     ./sql_ambiente.sh kapps_db_pre > updates_pre.sql  y se corre con tx_pre
--     seleccionada. Las apps hacen la misma traducción con MYSQL_DB_KAPPS.
-- =====================================================================



-- ---------------------------------------------------------------------
-- 2026-11-06  Mapeo de productos KAPP <-> PARLEVEL (por tenant)
--   PARLEVEL entrega un archivo con movimientos de inventario, pero sus
--   identificadores no coinciden con los de KAPPS. Esta tabla guarda, para
--   cada KAPP (tenant), a qué producto de KAPPS corresponde cada nombre de
--   producto de PARLEVEL.
--
--   Los productos NO están en una tabla propia: son registros de tx.elementos
--   con id_module_cat = 3 (INVENTARIO) cuyos datos (nombre, marca, categoría...)
--   están en tx.elementos_datos, definidos por tx.ctz (pantalla 1 = PRODUCTO).
--   El nombre del producto es el campo ctz.id_ctz_base = 1 ('PRODUCTO').
--
--   Reglas:
--     * kapp_id identifica al tenant (= tx.elementos.id_kapp).
--     * producto_id = tx.elementos.id (con FK; elementos es InnoDB).
--     * Un nombre de PARLEVEL se asigna a UN solo producto por KAPP
--       (UNIQUE kapp_id + parlevel_nombre).
--     * Un producto de KAPPS puede tener varios nombres en PARLEVEL (alias).
--     * Que el elemento pertenezca realmente a kapp_id y sea un producto
--       (no un lote) lo valida la aplicación.
--   NOTA: si una versión anterior de esta tabla (producto_id VARCHAR(6)) ya se
--   creó, está vacía: ejecutar antes  DROP TABLE parlevel_productos_map;
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS parlevel_productos_map (
    id                 INT NOT NULL AUTO_INCREMENT,
    kapp_id            INT NOT NULL                                   COMMENT 'ID de la KAPP (tenant): kapps_db.kapps.id = tx.elementos.id_kapp',
    producto_id        INT NOT NULL                                   COMMENT 'ID del producto en KAPPS: tx.elementos.id (id_module_cat = 3)',
    parlevel_nombre    VARCHAR(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
                                                                      COMMENT 'Nombre del producto en PARLEVEL',
    estado             TINYINT(1) NOT NULL DEFAULT 1                  COMMENT '1 = activo, 0 = inactivo',
    id_usuario         INT NULL                                       COMMENT 'kapps_db.accounts.id de quien creó el mapeo',
    fecha_creacion     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_parlevel_kapp_nombre (kapp_id, parlevel_nombre),
    KEY ix_parlevel_kapp_producto (kapp_id, producto_id),
    CONSTRAINT fk_parlevel_map_elemento FOREIGN KEY (producto_id) REFERENCES elementos (id) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = 'Mapeo de productos KAPPS <-> PARLEVEL por KAPP';


-- ---------------------------------------------------------------------
-- 2026-11-06  Contraseñas con hash (migración gradual)
--   Hasta ahora las contraseñas se guardaban con aes_encrypt (reversible).
--   La aplicación ahora valida con password_hash (pbkdf2-sha256). Si la cuenta aún
--   no tiene hash, valida con la clave antigua (password2) y, si es correcta,
--   guarda el hash en ese mismo ingreso. password2 NO se borra aquí porque
--   otras aplicaciones del ecosistema (tx) podrían seguir leyéndola.
--   La app funciona aunque esta columna aún no exista (usa solo password2).
-- ---------------------------------------------------------------------
-- Idempotente (2026-11-18: antes daba error 1060 si la columna ya existía, lo que
-- detenía el script completo al aplicarlo sobre una base que ya la tenía).
SET @acc_col := (SELECT COUNT(*) FROM information_schema.columns
                  WHERE table_schema = 'kapps_db' AND table_name = 'accounts' AND column_name = 'password_hash');
SET @acc_sql := IF(@acc_col = 0, 'ALTER TABLE kapps_db.accounts ADD COLUMN password_hash VARCHAR(255) NULL AFTER password2', 'SELECT 1');
PREPARE acc_stmt FROM @acc_sql;
EXECUTE acc_stmt;
DEALLOCATE PREPARE acc_stmt;

-- OPCIONAL, cuando TODOS los administradores (kapp_id = 0) ya tengan hash y
-- se confirme que ninguna otra aplicación lee su password2:
-- UPDATE kapps_db.accounts SET password2 = NULL WHERE kapp_id = 0 AND password_hash IS NOT NULL;


-- ---------------------------------------------------------------------
-- 2026-11-06  Límite de intentos de login en base de datos
--   Antes el contador vivía en memoria de cada proceso (no se compartía
--   entre workers). Ahora se guarda aquí: 5 fallos por IP+usuario o 20 por IP
--   en 5 minutos bloquean el ingreso temporalmente. Si la tabla no existe, la
--   app usa el contador en memoria.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS kapps_db.login_intentos (
    id      BIGINT NOT NULL AUTO_INCREMENT,
    ip      VARCHAR(45) NOT NULL,
    usuario VARCHAR(60) NOT NULL,
    fecha   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY ix_login_intentos_ip_usuario_fecha (ip, usuario, fecha),
    KEY ix_login_intentos_fecha (fecha)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


-- ---------------------------------------------------------------------
-- 2026-11-09  Parámetro por kapp: mostrar errores 500 en pantalla (TX)
--   Para diagnosticar a un solo cliente sin afectar a los demás. Apagado
--   por defecto. Se enciende y apaga en Admin > kapp > módulo
--   CONFIGURACION (la kapp debe tener ese módulo activo). TX lo lee por
--   nombre: no cambiar el nombre.
-- ---------------------------------------------------------------------
INSERT INTO kapps_db.tx_params_cat
    (module_id, nombre, descripcion, estado, html_type, category, customizable, required, `system`, default_value)
SELECT 6, 'Mostrar Errores en Pantalla', 'Muestra el detalle del error 500 (temporal)', 1, 'CHECKBOX', 'PARAMETERS', 1, 1, 1, '0'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM kapps_db.tx_params_cat WHERE module_id = 6 AND nombre = 'Mostrar Errores en Pantalla');


-- ---------------------------------------------------------------------
-- 2026-11-10  Módulo BARBERÍAS (administración multi-barbería y reservas)
--   Módulo nuevo de TX (código 'brb'). Se habilita por KAPP desde Admin
--   (Configuración de módulos), igual que los demás. La KAPP es la
--   organización: un propietario (cuenta nivel 1) administra todas sus
--   barberías; los demás roles se asignan en brb_roles o vinculando una
--   cuenta a un barbero (brb_barberos.cuenta_id).
--
--   Convenciones de estas tablas:
--     * Todas llevan prefijo brb_ y viven en el esquema de datos (tx).
--       Ejecutar esta sección con ese esquema seleccionado (USE tx; o USE tx_pre; en el sandbox).
--     * Fechas/horas de citas y bloqueos se guardan en UTC (columnas *_utc);
--       la app las muestra en la zona horaria de cada barbería.
--     * Horarios semanales: dia_semana 0 = lunes ... 6 = domingo.
--     * No toca ninguna tabla de los otros módulos.
--   Documentación: tx/docs/modules/barberias/
-- ---------------------------------------------------------------------
INSERT INTO kapps_db.kapps_modules_cat (type, name, description, active, code)
SELECT 'MAIN', 'BARBERIA', 'Administración de barberías y reservas de clientes', 1, 'brb'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM kapps_db.kapps_modules_cat WHERE code = 'brb');

CREATE TABLE IF NOT EXISTS brb_barberias (
    id                    INT NOT NULL AUTO_INCREMENT,
    kapp_id               INT NOT NULL COMMENT 'Organización dueña: kapps_db.kapps.id',
    nombre                VARCHAR(80) NOT NULL,
    slug                  VARCHAR(60) NOT NULL COMMENT 'URL pública: /reservar/<slug>',
    descripcion           VARCHAR(400) NULL,
    logo                  VARCHAR(120) NULL COMMENT 'Archivo en static/brb/uploads',
    direccion             VARCHAR(200) NULL,
    telefono              VARCHAR(20) NULL,
    correo                VARCHAR(100) NULL,
    zona_horaria          VARCHAR(40) NOT NULL DEFAULT 'America/Costa_Rica',
    activo                TINYINT(1) NOT NULL DEFAULT 1,
    multi_servicio        TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = el cliente puede elegir varios servicios',
    requiere_aprobacion   TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = las reservas nacen pendientes',
    intervalo_min         SMALLINT NOT NULL DEFAULT 15 COMMENT 'Cada cuántos minutos se ofrece un horario',
    buffer_min            SMALLINT NOT NULL DEFAULT 0 COMMENT 'Minutos libres entre citas',
    anticipacion_min      SMALLINT NOT NULL DEFAULT 60 COMMENT 'Minutos mínimos de anticipación para reservar',
    anticipacion_max_dias SMALLINT NOT NULL DEFAULT 30,
    limite_cambios_horas  SMALLINT NOT NULL DEFAULT 2 COMMENT 'Horas antes de la cita hasta las que el cliente puede cancelar o reprogramar',
    politica_cancelacion  VARCHAR(500) NULL,
    politica_menores      VARCHAR(15) NOT NULL DEFAULT 'responsable' COMMENT 'responsable | no | libre',
    edad_mayoria          TINYINT NOT NULL DEFAULT 18,
    telefono_obligatorio  TINYINT(1) NOT NULL DEFAULT 0,
    notif_email           TINYINT(1) NOT NULL DEFAULT 1,
    notif_sms             TINYINT(1) NOT NULL DEFAULT 0,
    recordatorio_horas    SMALLINT NOT NULL DEFAULT 24 COMMENT '0 = sin recordatorio',
    fecha_creacion        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_brb_barberias_slug (slug),
    KEY ix_brb_barberias_kapp (kapp_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_barberos (
    id           INT NOT NULL AUTO_INCREMENT,
    kapp_id      INT NOT NULL,
    cuenta_id    INT NULL COMMENT 'kapps_db.accounts.id si el barbero ingresa a TX a ver su agenda',
    nombre       VARCHAR(80) NOT NULL,
    foto         VARCHAR(120) NULL,
    descripcion  VARCHAR(300) NULL,
    especialidad VARCHAR(80) NULL,
    telefono     VARCHAR(20) NULL,
    correo       VARCHAR(100) NULL,
    activo       TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    KEY ix_brb_barberos_kapp (kapp_id),
    KEY ix_brb_barberos_cuenta (cuenta_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_barbero_barberia (
    barbero_id  INT NOT NULL,
    barberia_id INT NOT NULL,
    PRIMARY KEY (barbero_id, barberia_id),
    KEY ix_brb_bb_barberia (barberia_id),
    CONSTRAINT fk_brb_bb_barbero FOREIGN KEY (barbero_id) REFERENCES brb_barberos (id) ON DELETE CASCADE,
    CONSTRAINT fk_brb_bb_barberia FOREIGN KEY (barberia_id) REFERENCES brb_barberias (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_servicios (
    id           INT NOT NULL AUTO_INCREMENT,
    barberia_id  INT NOT NULL,
    categoria    VARCHAR(60) NULL,
    nombre       VARCHAR(80) NOT NULL,
    descripcion  VARCHAR(300) NULL,
    precio       DECIMAL(10,2) NOT NULL DEFAULT 0,
    duracion_min SMALLINT NOT NULL,
    imagen       VARCHAR(120) NULL,
    activo       TINYINT(1) NOT NULL DEFAULT 1,
    orden        SMALLINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY ix_brb_servicios_barberia (barberia_id),
    CONSTRAINT fk_brb_servicios_barberia FOREIGN KEY (barberia_id) REFERENCES brb_barberias (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_barbero_servicio (
    barbero_id   INT NOT NULL,
    servicio_id  INT NOT NULL,
    precio       DECIMAL(10,2) NULL COMMENT 'NULL = precio del servicio',
    duracion_min SMALLINT NULL COMMENT 'NULL = duración del servicio',
    PRIMARY KEY (barbero_id, servicio_id),
    KEY ix_brb_bs_servicio (servicio_id),
    CONSTRAINT fk_brb_bs_barbero FOREIGN KEY (barbero_id) REFERENCES brb_barberos (id) ON DELETE CASCADE,
    CONSTRAINT fk_brb_bs_servicio FOREIGN KEY (servicio_id) REFERENCES brb_servicios (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_horarios (
    id          INT NOT NULL AUTO_INCREMENT,
    barberia_id INT NOT NULL,
    barbero_id  INT NULL COMMENT 'NULL = horario de apertura de la barbería',
    tipo        VARCHAR(10) NOT NULL DEFAULT 'trabajo' COMMENT 'trabajo | descanso (descanso solo aplica a barberos)',
    dia_semana  TINYINT NOT NULL COMMENT '0 = lunes ... 6 = domingo',
    hora_inicio TIME NOT NULL,
    hora_fin    TIME NOT NULL,
    PRIMARY KEY (id),
    KEY ix_brb_horarios (barberia_id, barbero_id, dia_semana),
    CONSTRAINT fk_brb_horarios_barberia FOREIGN KEY (barberia_id) REFERENCES brb_barberias (id) ON DELETE CASCADE,
    CONSTRAINT fk_brb_horarios_barbero FOREIGN KEY (barbero_id) REFERENCES brb_barberos (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_bloqueos (
    id          INT NOT NULL AUTO_INCREMENT,
    kapp_id     INT NOT NULL,
    barberia_id INT NULL COMMENT 'Con barbero_id NULL: cierre de toda la barbería (feriado)',
    barbero_id  INT NULL COMMENT 'Con valor: tiempo no disponible del barbero (en todas sus barberías)',
    tipo        VARCHAR(12) NOT NULL DEFAULT 'bloqueo' COMMENT 'feriado | vacaciones | libre | bloqueo',
    estado      VARCHAR(12) NOT NULL DEFAULT 'aprobado' COMMENT 'aprobado | solicitado (solo aprobado afecta la disponibilidad)',
    inicio_utc  DATETIME NOT NULL,
    fin_utc     DATETIME NOT NULL,
    motivo      VARCHAR(200) NULL,
    creado_por  INT NULL COMMENT 'kapps_db.accounts.id',
    PRIMARY KEY (id),
    KEY ix_brb_bloqueos_barberia (barberia_id, inicio_utc),
    KEY ix_brb_bloqueos_barbero (barbero_id, inicio_utc),
    CONSTRAINT fk_brb_bloqueos_barberia FOREIGN KEY (barberia_id) REFERENCES brb_barberias (id) ON DELETE CASCADE,
    CONSTRAINT fk_brb_bloqueos_barbero FOREIGN KEY (barbero_id) REFERENCES brb_barberos (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_roles (
    id          INT NOT NULL AUTO_INCREMENT,
    cuenta_id   INT NOT NULL COMMENT 'kapps_db.accounts.id',
    barberia_id INT NOT NULL,
    rol         VARCHAR(10) NOT NULL DEFAULT 'admin' COMMENT 'admin = administrador de esa barbería',
    PRIMARY KEY (id),
    UNIQUE KEY uq_brb_roles (cuenta_id, barberia_id, rol),
    CONSTRAINT fk_brb_roles_barberia FOREIGN KEY (barberia_id) REFERENCES brb_barberias (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_clientes (
    id               INT NOT NULL AUTO_INCREMENT,
    kapp_id          INT NOT NULL,
    nombre           VARCHAR(80) NOT NULL,
    correo           VARCHAR(100) NULL,
    telefono         VARCHAR(20) NULL,
    google_sub       VARCHAR(64) NULL COMMENT 'Identificador estable de Google (claim sub)',
    acepta_marketing TINYINT(1) NOT NULL DEFAULT 0,
    notif_email      TINYINT(1) NOT NULL DEFAULT 1,
    notif_sms        TINYINT(1) NOT NULL DEFAULT 1,
    anonimizado      TINYINT(1) NOT NULL DEFAULT 0,
    fecha_creacion   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_brb_clientes_google (kapp_id, google_sub),
    KEY ix_brb_clientes_correo (kapp_id, correo),
    KEY ix_brb_clientes_telefono (kapp_id, telefono)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_citas (
    id                  INT NOT NULL AUTO_INCREMENT,
    kapp_id             INT NOT NULL,
    barberia_id         INT NOT NULL,
    barbero_id          INT NOT NULL,
    cliente_id          INT NOT NULL,
    codigo              VARCHAR(10) NOT NULL COMMENT 'Identificador que ve el cliente',
    token               CHAR(32) NOT NULL COMMENT 'Secreto del enlace para ver/cancelar la reserva',
    idem_key            CHAR(32) NULL COMMENT 'Evita duplicar la reserva si el formulario se envía dos veces',
    inicio_utc          DATETIME NOT NULL,
    fin_utc             DATETIME NOT NULL,
    duracion_min        SMALLINT NOT NULL,
    precio_total        DECIMAL(10,2) NOT NULL DEFAULT 0,
    estado              VARCHAR(12) NOT NULL DEFAULT 'confirmada' COMMENT 'pendiente | confirmada | completada | cancelada | ausente',
    origen              VARCHAR(8) NOT NULL DEFAULT 'web' COMMENT 'web | admin',
    es_menor            TINYINT(1) NOT NULL DEFAULT 0,
    nombre_menor        VARCHAR(80) NULL,
    notas               VARCHAR(300) NULL,
    fecha_creacion      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_brb_citas_codigo (codigo),
    UNIQUE KEY uq_brb_citas_token (token),
    UNIQUE KEY uq_brb_citas_idem (idem_key),
    KEY ix_brb_citas_barbero (barbero_id, inicio_utc),
    KEY ix_brb_citas_barberia (barberia_id, inicio_utc),
    KEY ix_brb_citas_cliente (cliente_id),
    CONSTRAINT fk_brb_citas_barberia FOREIGN KEY (barberia_id) REFERENCES brb_barberias (id),
    CONSTRAINT fk_brb_citas_barbero FOREIGN KEY (barbero_id) REFERENCES brb_barberos (id),
    CONSTRAINT fk_brb_citas_cliente FOREIGN KEY (cliente_id) REFERENCES brb_clientes (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_cita_servicios (
    id           INT NOT NULL AUTO_INCREMENT,
    cita_id      INT NOT NULL,
    servicio_id  INT NULL,
    nombre       VARCHAR(80) NOT NULL COMMENT 'Copia al momento de reservar',
    precio       DECIMAL(10,2) NOT NULL,
    duracion_min SMALLINT NOT NULL,
    PRIMARY KEY (id),
    KEY ix_brb_cs_cita (cita_id),
    CONSTRAINT fk_brb_cs_cita FOREIGN KEY (cita_id) REFERENCES brb_citas (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_consentimientos (
    id         INT NOT NULL AUTO_INCREMENT,
    kapp_id    INT NOT NULL,
    cliente_id INT NOT NULL,
    cita_id    INT NULL,
    tipo       VARCHAR(20) NOT NULL COMMENT 'privacidad | terminos | marketing | mayoria_edad | responsable_menor',
    version    VARCHAR(20) NOT NULL COMMENT 'Versión del texto aceptado',
    aceptado   TINYINT(1) NOT NULL,
    ip         VARCHAR(45) NULL,
    fecha_utc  DATETIME NOT NULL,
    PRIMARY KEY (id),
    KEY ix_brb_consent_cliente (cliente_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_notificaciones (
    id            INT NOT NULL AUTO_INCREMENT,
    kapp_id       INT NOT NULL,
    cita_id       INT NOT NULL,
    canal         VARCHAR(6) NOT NULL COMMENT 'email | sms',
    tipo          VARCHAR(14) NOT NULL COMMENT 'confirmacion | recordatorio | modificacion | cancelacion',
    destino       VARCHAR(100) NOT NULL,
    estado        VARCHAR(10) NOT NULL DEFAULT 'pendiente' COMMENT 'pendiente | enviado | fallido',
    error         VARCHAR(300) NULL,
    intentos      TINYINT NOT NULL DEFAULT 0,
    fecha_utc     DATETIME NOT NULL,
    fecha_envio_utc DATETIME NULL,
    PRIMARY KEY (id),
    KEY ix_brb_notif_cita (cita_id),
    KEY ix_brb_notif_estado (kapp_id, estado)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_auditoria (
    id          INT NOT NULL AUTO_INCREMENT,
    kapp_id     INT NOT NULL,
    barberia_id INT NULL,
    cita_id     INT NULL,
    actor       VARCHAR(10) NOT NULL COMMENT 'cliente | staff | sistema',
    cuenta_id   INT NULL COMMENT 'kapps_db.accounts.id cuando actor = staff',
    accion      VARCHAR(30) NOT NULL,
    detalle     VARCHAR(400) NULL,
    fecha_utc   DATETIME NOT NULL,
    PRIMARY KEY (id),
    KEY ix_brb_auditoria_cita (cita_id),
    KEY ix_brb_auditoria_barberia (barberia_id, fecha_utc)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_solicitudes_datos (
    id            INT NOT NULL AUTO_INCREMENT,
    kapp_id       INT NOT NULL,
    cliente_id    INT NOT NULL,
    tipo          VARCHAR(14) NOT NULL COMMENT 'acceso | rectificacion | eliminacion',
    detalle       VARCHAR(400) NULL,
    estado        VARCHAR(10) NOT NULL DEFAULT 'pendiente' COMMENT 'pendiente | atendida',
    fecha_utc     DATETIME NOT NULL,
    atendida_por  INT NULL,
    fecha_atencion_utc DATETIME NULL,
    PRIMARY KEY (id),
    KEY ix_brb_solicitudes (kapp_id, estado)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


-- ---------------------------------------------------------------------
-- 2026-11-10  Tabla inv_favoritos (productos favoritos de Tienda/Inventario)
--   El código la usa desde que existen los favoritos (crud_elementos.get_favoritos
--   y save_favoritos) pero nunca quedó en ningún script: en una base nueva la
--   Tienda fallaba con "Table inv_favoritos doesn't exist".
--   Guarda QUÉ productos son favoritos de cada KAPP y en qué orden.
--   No confundir con ctz_inv_favoritos, que guarda qué CAMPOS del producto se
--   muestran en el botón de cada favorito.
--   Ejecutar con el esquema de datos seleccionado (USE tx; o USE tx_pre; en el sandbox). Si la tabla ya
--   existe (producción), no hace nada.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS inv_favoritos (
    id          INT NOT NULL AUTO_INCREMENT,
    kapp_id     INT NOT NULL,
    screen_id   INT NOT NULL COMMENT 'ctz_module_screens.id (1 = PRODUCTO)',
    elemento_id INT NOT NULL COMMENT 'elementos.id del producto',
    ranking     INT NOT NULL COMMENT 'Posición en la lista: 1 = primero',
    PRIMARY KEY (id),
    UNIQUE KEY uq_inv_favoritos (kapp_id, screen_id, elemento_id),
    KEY ix_inv_favoritos_orden (kapp_id, screen_id, ranking)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


-- ---------------------------------------------------------------------
-- 2026-11-10  Licencias de barberías por KAPP: parámetro de configuración (módulo BARBERIA)
--   Cuántas barberías ACTIVAS puede tener una KAPP. Es un dato comercial
--   (va ligado al precio): se configura en Admin, en la configuración de cada
--   KAPP (Parámetros > BARBERIA > LICENCIAS), igual que los demás parámetros.
--   El administrador de la KAPP en TX ve cuántas usa y no puede cambiarlas
--   (TX no escribe en tx_params).
--   Reglas: solo cuentan las barberías activas (brb_barberias.activo = 1).
--   Una KAPP que ya está por encima del límite no pierde nada: sigue
--   operando, pero no puede crear ni activar más.
--   Valor inicial 1 (default_value). El parámetro solo aparece en Admin para
--   las KAPPs que tienen activo el módulo BARBERIA.
--   TX lo busca por módulo + categoría 'LICENCIAS': no cambiar la categoría.
--   Idempotente. Una versión anterior de este cambio usaba una columna en
--   kapps_db.kapps; se descartó. Si esa columna llegó a crearse (todas las KAPP
--   con su valor inicial 1), el último paso la elimina.
-- ---------------------------------------------------------------------
INSERT INTO kapps_db.tx_params_cat
    (module_id, nombre, descripcion, estado, html_type, html_additional, category, customizable, required, `system`, default_value)
SELECT c.id, 'Licencias de Barberías', 'Barberías activas permitidas', 1, 'number', 'min=0 max=999 step=1', 'LICENCIAS', 1, 1, 1, '1'
FROM kapps_db.kapps_modules_cat c
WHERE c.code = 'brb'
  AND NOT EXISTS (SELECT 1 FROM kapps_db.tx_params_cat p WHERE p.module_id = c.id AND p.category = 'LICENCIAS');

SET @brb_col := (SELECT COUNT(*) FROM information_schema.columns
                  WHERE table_schema = 'kapps_db' AND table_name = 'kapps' AND column_name = 'licencias_barberias');
SET @brb_sql := IF(@brb_col = 1, 'ALTER TABLE kapps_db.kapps DROP COLUMN licencias_barberias', 'SELECT 1');
PREPARE brb_stmt FROM @brb_sql;
EXECUTE brb_stmt;
DEALLOCATE PREPARE brb_stmt;


-- ---------------------------------------------------------------------
-- 2026-11-11  PARLEVEL: mapeo de máquinas y tabla de la carga del Prekitting (módulo DESPACHO)
--   Estas dos tablas ya se usan en el código (mod_dispatch.parlevel_guardar) y están
--   definidas en kappsDB/cambios_a_prod.sql, pero no en este archivo: una base nueva
--   no las tenía y la carga del Prekitting fallaba. Aquí se crean de forma idempotente
--   (si ya existen en producción no se toca nada).
--
--   parlevel_maquinas_map: a qué máquina de KAPPS (tx.clientes, id_module_cat = 5)
--     corresponde cada nombre de máquina de PARLEVEL.
--     Mapeo 1 a 1: un nombre de PARLEVEL por máquina y una máquina por nombre
--     (UNIQUE id_kapp + parlevel_machine, y UNIQUE id_kapp + id_cliente).
--   parlevel_productos_map (ver sección 2026-11-06): desde esta versión TX también lo
--     escribe y mantiene 1 a 1 (un nombre por producto) en la aplicación; la tabla
--     no cambia (puede haber alias viejos creados desde Admin: TX los reemplaza al
--     guardar el producto).
--   parlevel_productos_prekiting: filas de cada archivo Prekitting cargado.
--
--   La integración se activa por KAPP con el parámetro "Integración con PARLEVEL"
--   (módulo DESPACHO, ya existente). Sin él TX no muestra nada de esto.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS parlevel_maquinas_map (
    id               INT NOT NULL AUTO_INCREMENT,
    id_kapp          INT NOT NULL                                   COMMENT 'ID de la KAPP (tenant)',
    parlevel_machine VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
                                                                    COMMENT 'Nombre de la máquina en PARLEVEL',
    id_cliente       INT NOT NULL                                   COMMENT 'ID de la máquina en KAPPS: tx.clientes.id (id_module_cat = 5)',
    PRIMARY KEY (id),
    UNIQUE KEY uq_kapp_machine (id_kapp, parlevel_machine),
    UNIQUE KEY uq_kapp_cliente (id_kapp, id_cliente)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = 'Mapeo de máquinas KAPPS <-> PARLEVEL por KAPP';

CREATE TABLE IF NOT EXISTS parlevel_productos_prekiting (
    id                    INT NOT NULL AUTO_INCREMENT,
    id_carga              CHAR(36) NOT NULL,
    id_kapp               INT NOT NULL,
    id_usuario            INT NOT NULL,
    nombre_archivo        VARCHAR(255) NULL,
    fecha_proceso         DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
    daily_route           VARCHAR(20) NULL,
    planned_for           DATE NULL,
    route                 VARCHAR(100) NULL,
    location              VARCHAR(150) NULL,
    asset                 VARCHAR(50) NULL,
    machine               VARCHAR(100) NULL,
    transaccion           VARCHAR(20) NULL,
    prekit_alias          VARCHAR(20) NULL,
    cst_id                VARCHAR(20) NULL,
    product               VARCHAR(200) NULL,
    price                 DECIMAL(12,4) NULL,
    prekit_quantity       INT NULL,
    parlevel              INT NULL,
    filler_username       VARCHAR(100) NULL,
    delivery_sequence     INT NULL,
    id_producto           INT NULL,
    existencia            INT NULL,
    requerido_total       INT NULL,
    estado_disponibilidad VARCHAR(20) NULL,
    id_cliente            INT NULL,
    PRIMARY KEY (id),
    KEY ix_carga (id_carga),
    KEY ix_kapp_fecha (id_kapp, planned_for, daily_route)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = 'Filas de cada archivo Prekitting de PARLEVEL cargado';


-- ---------------------------------------------------------------------
-- 2026-11-18  PARLEVEL: despacho de una carga del Prekitting (módulo DESPACHO)
--   «Continuar con el despacho» crea un despacho (tnd_ventas, id_modulo 5) por
--   máquina con todos sus productos, en una sola transacción: o se despachan
--   todas las máquinas y productos, o ninguno. Estas columnas guardan qué carga
--   se despachó, con qué despacho cada máquina, cuándo y quién; impiden
--   despachar dos veces la misma carga o la misma ruta y fecha.
--   El índice acelera la búsqueda de cargas ya despachadas por ruta y fecha.
--   Idempotente (cada columna/índice solo se crea si no existe).
-- ---------------------------------------------------------------------
SET @pl_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'parlevel_productos_prekiting' AND column_name = 'id_venta');
SET @pl_sql := IF(@pl_col = 0, 'ALTER TABLE parlevel_productos_prekiting ADD COLUMN id_venta INT NULL COMMENT ''tnd_ventas.id del despacho de esta máquina''', 'SELECT 1');
PREPARE pl_stmt FROM @pl_sql;
EXECUTE pl_stmt;
DEALLOCATE PREPARE pl_stmt;

SET @pl_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'parlevel_productos_prekiting' AND column_name = 'fecha_despacho');
SET @pl_sql := IF(@pl_col = 0, 'ALTER TABLE parlevel_productos_prekiting ADD COLUMN fecha_despacho DATETIME NULL COMMENT ''Cuándo se despachó la carga (NULL = sin despachar)''', 'SELECT 1');
PREPARE pl_stmt FROM @pl_sql;
EXECUTE pl_stmt;
DEALLOCATE PREPARE pl_stmt;

SET @pl_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'parlevel_productos_prekiting' AND column_name = 'id_usuario_despacho');
SET @pl_sql := IF(@pl_col = 0, 'ALTER TABLE parlevel_productos_prekiting ADD COLUMN id_usuario_despacho INT NULL COMMENT ''kapps_db.accounts.id de quien despachó''', 'SELECT 1');
PREPARE pl_stmt FROM @pl_sql;
EXECUTE pl_stmt;
DEALLOCATE PREPARE pl_stmt;

SET @pl_idx := (SELECT COUNT(*) FROM information_schema.statistics
                 WHERE table_schema = DATABASE() AND table_name = 'parlevel_productos_prekiting' AND index_name = 'ix_kapp_despacho');
SET @pl_sql := IF(@pl_idx = 0, 'ALTER TABLE parlevel_productos_prekiting ADD KEY ix_kapp_despacho (id_kapp, daily_route, planned_for, fecha_despacho)', 'SELECT 1');
PREPARE pl_stmt FROM @pl_sql;
EXECUTE pl_stmt;
DEALLOCATE PREPARE pl_stmt;

-- ---------------------------------------------------------------------
-- 2026-11-19  Ingreso a TX con Google ("Continuar con Google")
--   Parámetro por kapp 'Login con Google' (módulo 6 CONFIGURACION,
--   apagado por defecto): se enciende en Admin > kapp > CONFIGURACION o
--   en TX > Usuarios (administrador nivel 1). TX lo lee por nombre: no
--   cambiar el nombre.
--   accounts.google_login: el usuario puede entrar con Google (1 = sí).
--   accounts.google_sub: cuenta de Google vinculada (claim sub). Se llena
--   en el primer ingreso, buscando por el correo del usuario; se borra al
--   cambiar el correo o al quitarle el permiso.
--   Idempotente.
-- ---------------------------------------------------------------------
INSERT INTO kapps_db.tx_params_cat
    (module_id, nombre, descripcion, estado, html_type, category, customizable, required, `system`, default_value)
SELECT 6, 'Login con Google', 'Permite ingresar con una cuenta de Google', 1, 'CHECKBOX', 'PARAMETERS', 1, 1, 1, '0'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM kapps_db.tx_params_cat WHERE module_id = 6 AND nombre = 'Login con Google');

SET @gl_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = 'kapps_db' AND table_name = 'accounts' AND column_name = 'google_login');
SET @gl_sql := IF(@gl_col = 0, 'ALTER TABLE kapps_db.accounts ADD COLUMN google_login TINYINT(1) NOT NULL DEFAULT 1 COMMENT ''Puede ingresar con Google (si la kapp lo permite)''', 'SELECT 1');
PREPARE gl_stmt FROM @gl_sql;
EXECUTE gl_stmt;
DEALLOCATE PREPARE gl_stmt;

SET @gl_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = 'kapps_db' AND table_name = 'accounts' AND column_name = 'google_sub');
SET @gl_sql := IF(@gl_col = 0, 'ALTER TABLE kapps_db.accounts ADD COLUMN google_sub VARCHAR(64) NULL COMMENT ''Cuenta de Google vinculada (claim sub)''', 'SELECT 1');
PREPARE gl_stmt FROM @gl_sql;
EXECUTE gl_stmt;
DEALLOCATE PREPARE gl_stmt;

SET @gl_idx := (SELECT COUNT(*) FROM information_schema.statistics
                 WHERE table_schema = 'kapps_db' AND table_name = 'accounts' AND index_name = 'uq_accounts_google');
SET @gl_sql := IF(@gl_idx = 0, 'ALTER TABLE kapps_db.accounts ADD UNIQUE KEY uq_accounts_google (kapp_id, google_sub)', 'SELECT 1');
PREPARE gl_stmt FROM @gl_sql;
EXECUTE gl_stmt;
DEALLOCATE PREPARE gl_stmt;


-- ---------------------------------------------------------------------
-- 2026-11-19  Procedimiento reportes_data_temporal sin esquema fijo
--   La versión anterior leía de tx.elementos_datos, tx.ctz y tx.inv_lotes_log
--   con el esquema escrito: en el sandbox (tx_pre) el reporte de existencias
--   de Inventario tomaba datos de PRODUCCIÓN. Esta versión usa las tablas de
--   la base donde se crea el procedimiento.
--   Ejecutar UNA VEZ EN CADA BASE de datos: con USE tx; y con USE tx_pre;
--   (en phpMyAdmin: elegir la base y usar el delimitador $$).
--   Idempotente (DROP + CREATE).
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS reportes_data_temporal;
DELIMITER $$
CREATE PROCEDURE reportes_data_temporal (IN par_kapp_id INT, IN par_reporte_id INT, IN fecha_inicio DATE, IN fecha_fin DATE)
BEGIN
    delete from reportes_data_temporal where kapp_id=par_kapp_id AND reporte_id=par_reporte_id;

    insert into reportes_data_temporal (kapp_id, reporte_id, valor1, valor2)
    select par_kapp_id, par_reporte_id, ed.valor, ed3.valor
        from elementos_datos ed
            left join elementos_datos ed2 on ed2.id_elemento = ed.id_elemento and ed2.id_ctz = (select id from ctz where id_kapp=par_kapp_id and id_ctz_base=14)
            left join elementos_datos ed3 on ed3.id_elemento = ed.id_elemento and ed3.id_ctz = (select id from ctz where id_kapp=par_kapp_id and id_ctz_base=19)
        where ed.id_ctz = (select id from ctz where id_kapp=par_kapp_id and id_ctz_base=3) and ed2.valor>0
        group by ed.valor, ed3.valor
    union
    select par_kapp_id, par_reporte_id, ed2.valor id_producto, ed4.valor
        from elementos e
            inner join elementos_datos ed on ed.id_elemento=e.id and ed.id_ctz = (select id from ctz where id_kapp = par_kapp_id and id_ctz_base=6)
            inner join elementos_datos ed2 on ed2.id_elemento=e.id and ed2.id_ctz = (select id from ctz where id_kapp = par_kapp_id and id_ctz_base=3)
            inner join elementos_datos ed4 on ed4.id_elemento=e.id and ed4.id_ctz = (select id from ctz where id_kapp = par_kapp_id and id_ctz_base=19)
        where id_kapp = par_kapp_id and ed.valor between fecha_inicio and fecha_fin
        group by ed2.valor, ed4.valor
    union
    select par_kapp_id, par_reporte_id, id_producto, edx.valor
        from inv_lotes_log ll
            left join elementos_datos edx on edx.id_elemento=ll.id_lote
                and edx.id_ctz = (SELECT id FROM ctz where id_kapp=par_kapp_id and id_ctz_base=19)
        where fecha between fecha_inicio and fecha_fin and tipo=5
        group by id_producto, edx.valor;

    COMMIT;
END$$
DELIMITER ;


-- ---------------------------------------------------------------------
-- 2026-11-19  Perfil de usuario: edad, privacidad, tema y foto
--   accounts.fecha_nacimiento: la registra CADA usuario al entrar; menores
--     de 18 años no ingresan (TX y Admin).
--   accounts.politica_version / politica_fecha: versión de la política de
--     privacidad (Ley 8968) que el usuario aceptó y cuándo. Si TX publica una
--     versión nueva, se le pide aceptarla de nuevo.
--   accounts.tema: tema de color elegido (bosque, arrecife, manglar, volcan,
--     paramo). NULL = bosque.
--   accounts_foto: foto de perfil reducida en el navegador (máx. 200 KB).
--   Esquema kapps_db (compartido por producción y sandbox). Idempotente.
-- ---------------------------------------------------------------------
SET @pf_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = 'kapps_db' AND table_name = 'accounts' AND column_name = 'fecha_nacimiento');
SET @pf_sql := IF(@pf_col = 0, 'ALTER TABLE kapps_db.accounts ADD COLUMN fecha_nacimiento DATE NULL COMMENT ''La registra el propio usuario; menores de 18 no ingresan''', 'SELECT 1');
PREPARE pf_stmt FROM @pf_sql;
EXECUTE pf_stmt;
DEALLOCATE PREPARE pf_stmt;

SET @pf_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = 'kapps_db' AND table_name = 'accounts' AND column_name = 'politica_version');
SET @pf_sql := IF(@pf_col = 0, 'ALTER TABLE kapps_db.accounts ADD COLUMN politica_version VARCHAR(20) NULL COMMENT ''Versión de la política de privacidad aceptada''', 'SELECT 1');
PREPARE pf_stmt FROM @pf_sql;
EXECUTE pf_stmt;
DEALLOCATE PREPARE pf_stmt;

SET @pf_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = 'kapps_db' AND table_name = 'accounts' AND column_name = 'politica_fecha');
SET @pf_sql := IF(@pf_col = 0, 'ALTER TABLE kapps_db.accounts ADD COLUMN politica_fecha DATETIME NULL COMMENT ''Cuándo aceptó la política''', 'SELECT 1');
PREPARE pf_stmt FROM @pf_sql;
EXECUTE pf_stmt;
DEALLOCATE PREPARE pf_stmt;

SET @pf_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = 'kapps_db' AND table_name = 'accounts' AND column_name = 'tema');
SET @pf_sql := IF(@pf_col = 0, 'ALTER TABLE kapps_db.accounts ADD COLUMN tema VARCHAR(20) NULL COMMENT ''Tema de color de la interfaz''', 'SELECT 1');
PREPARE pf_stmt FROM @pf_sql;
EXECUTE pf_stmt;
DEALLOCATE PREPARE pf_stmt;

CREATE TABLE IF NOT EXISTS kapps_db.accounts_foto (
    id_account   INT          NOT NULL PRIMARY KEY COMMENT 'kapps_db.accounts.id',
    mime         VARCHAR(20)  NOT NULL                COMMENT 'image/jpeg, image/png o image/webp',
    datos        MEDIUMBLOB   NOT NULL                COMMENT 'Imagen reducida (máx. 200 KB)',
    actualizado  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Foto de perfil de cada usuario';


-- ---------------------------------------------------------------------
-- 2026-11-20  Ingreso con Google sin código de negocio
--   Una cuenta de Google identifica a UN solo usuario de KAPPS: TX busca el
--   negocio por google_sub (o, la primera vez, por el correo). Al guardar un
--   usuario con "Puede entrar con Google", TX y Admin rechazan un correo que
--   otro usuario ya tenga con Google. Aquí: google_sub único en toda la base.
--   Si dos usuarios quedaron vinculados a la misma cuenta de Google, se
--   conserva el vínculo del más antiguo (el otro se vuelve a vincular al
--   entrar, si corresponde). Idempotente.
-- ---------------------------------------------------------------------
UPDATE kapps_db.accounts a
  JOIN (SELECT google_sub, MIN(id) conservar FROM kapps_db.accounts
         WHERE google_sub IS NOT NULL GROUP BY google_sub HAVING COUNT(*) > 1) d
    ON d.google_sub = a.google_sub AND a.id <> d.conservar
   SET a.google_sub = NULL;

SET @gs_idx := (SELECT COUNT(*) FROM information_schema.statistics
                 WHERE table_schema = 'kapps_db' AND table_name = 'accounts' AND index_name = 'uq_accounts_google_sub');
SET @gs_sql := IF(@gs_idx = 0, 'ALTER TABLE kapps_db.accounts ADD UNIQUE KEY uq_accounts_google_sub (google_sub)', 'SELECT 1');
PREPARE gs_stmt FROM @gs_sql;
EXECUTE gs_stmt;
DEALLOCATE PREPARE gs_stmt;


-- ---------------------------------------------------------------------
-- 2026-11-23  BARBERÍAS: Caja (cobros, ticket, devoluciones), encuestas de
--   satisfacción, clientes recurrentes y máximo de reservas configurable.
--   SOLO AGREGA: 6 tablas nuevas brb_* y 14 columnas nuevas en brb_barberias
--   (todas con valor por defecto o NULL; el código escribe esa tabla siempre
--   con lista de columnas). No modifica ni borra datos existentes y no toca
--   tablas de otros módulos ni de kapps_db.
--   El rol de caja se guarda en brb_roles con rol = 'caja' (sin cambio de
--   estructura; las consultas existentes filtran rol = 'admin').
--   Ejecutar con el esquema de datos seleccionado (USE tx; o USE tx_pre;).
--   Idempotente. Orden en producción: correr este SQL y DESPUÉS desplegar TX.
--   Documentación: tx/docs/modules/barberias/README.md (sección Caja).
-- ---------------------------------------------------------------------
SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'max_citas_cliente');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN max_citas_cliente TINYINT NOT NULL DEFAULT 2 COMMENT ''Reservas vigentes que un cliente puede tener a la vez (en toda la organización)''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_nombre_comercial');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_nombre_comercial VARCHAR(80) NULL COMMENT ''Ticket: nombre comercial (vacío = nombre de la barbería)''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_razon_social');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_razon_social VARCHAR(120) NULL COMMENT ''Ticket: nombre o razón social del contribuyente''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_tipo_cedula');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_tipo_cedula VARCHAR(10) NULL COMMENT ''Ticket: fisica | juridica | dimex | nite''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_cedula');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_cedula VARCHAR(20) NULL COMMENT ''Ticket: número de identificación del contribuyente''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_regimen');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_regimen VARCHAR(12) NOT NULL DEFAULT ''tradicional'' COMMENT ''tradicional | simplificado''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_iva_pct');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_iva_pct DECIMAL(5,2) NOT NULL DEFAULT 13.00 COMMENT ''Tarifa de IVA de los servicios''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_precios_con_iva');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_precios_con_iva TINYINT(1) NOT NULL DEFAULT 1 COMMENT ''1 = los precios ya incluyen el IVA''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_direccion');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_direccion VARCHAR(200) NULL COMMENT ''Ticket: dirección (vacío = la de la barbería)''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_telefono');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_telefono VARCHAR(20) NULL COMMENT ''Ticket: teléfono (vacío = el de la barbería)''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_correo');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_correo VARCHAR(100) NULL COMMENT ''Ticket: correo (vacío = el de la barbería)''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_mostrar_cliente');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_mostrar_cliente TINYINT(1) NOT NULL DEFAULT 1 COMMENT ''1 = el ticket muestra el nombre del cliente si se conoce''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'tk_leyenda');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN tk_leyenda VARCHAR(300) NULL COMMENT ''Ticket: mensaje adicional al pie''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

SET @cj_col := (SELECT COUNT(*) FROM information_schema.columns
                 WHERE table_schema = DATABASE() AND table_name = 'brb_barberias' AND column_name = 'encuesta_activa');
SET @cj_sql := IF(@cj_col = 0, 'ALTER TABLE brb_barberias ADD COLUMN encuesta_activa TINYINT(1) NOT NULL DEFAULT 0 COMMENT ''1 = enviar encuesta de satisfacción por correo después de cada cobro''', 'SELECT 1');
PREPARE cj_stmt FROM @cj_sql;
EXECUTE cj_stmt;
DEALLOCATE PREPARE cj_stmt;

CREATE TABLE IF NOT EXISTS brb_cobros (
    id              INT NOT NULL AUTO_INCREMENT,
    kapp_id         INT NOT NULL,
    barberia_id     INT NOT NULL,
    consecutivo     INT NOT NULL COMMENT 'Número del ticket, consecutivo por barbería',
    cita_id         INT NULL COMMENT 'Reserva que se cobra (NULL = cliente sin reserva)',
    cliente_id      INT NULL,
    cliente_nombre  VARCHAR(80) NULL,
    cliente_correo  VARCHAR(100) NULL,
    barbero_id      INT NULL COMMENT 'Quién atendió',
    forma_pago      VARCHAR(14) NOT NULL COMMENT 'efectivo | sinpe | tarjeta | transferencia',
    referencia      VARCHAR(60) NULL COMMENT 'Comprobante SINPE, transferencia o voucher',
    monto_recibido  DECIMAL(10,2) NULL COMMENT 'Efectivo entregado por el cliente',
    subtotal        DECIMAL(10,2) NOT NULL COMMENT 'Sin IVA, después del descuento',
    descuento       DECIMAL(10,2) NOT NULL DEFAULT 0,
    iva             DECIMAL(10,2) NOT NULL DEFAULT 0,
    total           DECIMAL(10,2) NOT NULL,
    iva_pct         DECIMAL(5,2) NOT NULL DEFAULT 0,
    emisor          TEXT NULL COMMENT 'JSON: datos del ticket al momento del cobro (razón social, cédula, régimen...)',
    notas           VARCHAR(200) NULL,
    idem_key        CHAR(32) NULL COMMENT 'Evita duplicar el cobro si el formulario se envía dos veces',
    cuenta_id       INT NOT NULL COMMENT 'kapps_db.accounts.id de quien cobró',
    fecha_utc       DATETIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_brb_cobros_consecutivo (barberia_id, consecutivo),
    UNIQUE KEY uq_brb_cobros_idem (idem_key),
    KEY ix_brb_cobros_fecha (barberia_id, fecha_utc),
    KEY ix_brb_cobros_cita (cita_id),
    KEY ix_brb_cobros_barbero (barbero_id, fecha_utc),
    CONSTRAINT fk_brb_cobros_barberia FOREIGN KEY (barberia_id) REFERENCES brb_barberias (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_cobro_lineas (
    id              INT NOT NULL AUTO_INCREMENT,
    cobro_id        INT NOT NULL,
    servicio_id     INT NULL,
    descripcion     VARCHAR(120) NOT NULL,
    cantidad        SMALLINT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL COMMENT 'Como se cobra (con IVA si la barbería tiene precios con IVA)',
    total           DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    KEY ix_brb_cl_cobro (cobro_id),
    CONSTRAINT fk_brb_cl_cobro FOREIGN KEY (cobro_id) REFERENCES brb_cobros (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_devoluciones (
    id                 INT NOT NULL AUTO_INCREMENT,
    kapp_id            INT NOT NULL,
    barberia_id        INT NOT NULL,
    cobro_id           INT NOT NULL,
    monto              DECIMAL(10,2) NOT NULL,
    forma_pago         VARCHAR(14) NOT NULL COMMENT 'Cómo se devolvió el dinero',
    justificacion      VARCHAR(400) NOT NULL,
    cuenta_id          INT NOT NULL COMMENT 'Quién hizo la devolución',
    fecha_utc          DATETIME NOT NULL,
    estado             VARCHAR(10) NOT NULL DEFAULT 'pendiente' COMMENT 'pendiente | revisada',
    revisada_por       INT NULL,
    fecha_revision_utc DATETIME NULL,
    nota_revision      VARCHAR(300) NULL,
    aviso_estado       VARCHAR(12) NULL COMMENT 'Correo al administrador: enviado | fallido | sin_destino',
    aviso_error        VARCHAR(300) NULL,
    PRIMARY KEY (id),
    KEY ix_brb_dev_cobro (cobro_id),
    KEY ix_brb_dev_barberia (barberia_id, estado, fecha_utc),
    CONSTRAINT fk_brb_dev_cobro FOREIGN KEY (cobro_id) REFERENCES brb_cobros (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_encuestas (
    id                  INT NOT NULL AUTO_INCREMENT,
    kapp_id             INT NOT NULL,
    barberia_id         INT NOT NULL,
    cobro_id            INT NOT NULL,
    cliente_id          INT NULL,
    correo              VARCHAR(100) NOT NULL,
    token               CHAR(32) NOT NULL COMMENT 'Secreto del enlace de la encuesta',
    barbero_id          INT NULL COMMENT 'Barbero que atendió según el cobro (el que aparece elegido)',
    barbero_calificado  INT NULL COMMENT 'Barbero que el cliente calificó',
    estrellas           TINYINT NULL COMMENT '1 a 5; NULL = sin responder',
    comentario          VARCHAR(500) NULL,
    envio_estado        VARCHAR(10) NOT NULL DEFAULT 'pendiente' COMMENT 'pendiente | enviado | fallido',
    envio_error         VARCHAR(300) NULL,
    intentos            TINYINT NOT NULL DEFAULT 0,
    fecha_utc           DATETIME NOT NULL,
    fecha_envio_utc     DATETIME NULL,
    fecha_respuesta_utc DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_brb_encuestas_token (token),
    UNIQUE KEY uq_brb_encuestas_cobro (cobro_id),
    KEY ix_brb_encuestas_barbero (barbero_calificado, fecha_respuesta_utc),
    CONSTRAINT fk_brb_encuestas_cobro FOREIGN KEY (cobro_id) REFERENCES brb_cobros (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_recurrentes (
    id             INT NOT NULL AUTO_INCREMENT,
    kapp_id        INT NOT NULL,
    barberia_id    INT NOT NULL,
    cliente_id     INT NOT NULL,
    con_espacio    TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = tiene un espacio fijo reservado',
    barbero_id     INT NULL,
    servicio_id    INT NULL,
    dia_semana     TINYINT NULL COMMENT '0 = lunes ... 6 = domingo',
    hora           TIME NULL,
    frecuencia     VARCHAR(10) NULL COMMENT 'semanal | quincenal',
    fecha_inicio   DATE NOT NULL COMMENT 'Fecha en que se agregó: desde ahí se cuentan las semanas',
    activo         TINYINT(1) NOT NULL DEFAULT 1,
    notas          VARCHAR(200) NULL,
    creado_por     INT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    generado_hasta DATE NULL COMMENT 'Último día hasta el que ya se crearon las citas',
    PRIMARY KEY (id),
    KEY ix_brb_rec_barberia (barberia_id, activo),
    KEY ix_brb_rec_cliente (cliente_id),
    CONSTRAINT fk_brb_rec_barberia FOREIGN KEY (barberia_id) REFERENCES brb_barberias (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_recurrente_citas (
    recurrente_id INT NOT NULL,
    fecha         DATE NOT NULL,
    cita_id       INT NULL COMMENT 'NULL = no se pudo reservar ese día (ver motivo)',
    motivo        VARCHAR(200) NULL,
    PRIMARY KEY (recurrente_id, fecha),
    KEY ix_brb_rc_cita (cita_id),
    CONSTRAINT fk_brb_rc_recurrente FOREIGN KEY (recurrente_id) REFERENCES brb_recurrentes (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


-- ---------------------------------------------------------------------
-- 2026-11-23  BARBERÍAS: la Caja es una función ADICIONAL que se activa
--   por KAPP desde Admin (Parámetros > BARBERIA > CAJA > "Caja de
--   Barberías"). Apagada por defecto: las KAPP que ya usan Barberías no
--   ven ningún cambio hasta que se les active.
--   SOLO AGREGA una fila al catálogo kapps_db.tx_params_cat (módulo
--   BARBERIA). No cambia estructuras ni datos. TX solo lo lee (busca por
--   módulo + categoría 'CAJA': no cambiar la categoría).
--   Idempotente.
-- ---------------------------------------------------------------------
INSERT INTO kapps_db.tx_params_cat
    (module_id, nombre, descripcion, estado, html_type, category, customizable, required, `system`, default_value)
SELECT c.id, 'Caja de Barberías', 'Cobros, ticket, devoluciones y encuesta', 1, 'CHECKBOX', 'CAJA', 1, 1, 1, '0'
FROM kapps_db.kapps_modules_cat c
WHERE c.code = 'brb'
  AND NOT EXISTS (SELECT 1 FROM kapps_db.tx_params_cat p WHERE p.module_id = c.id AND p.category = 'CAJA');


-- ---------------------------------------------------------------------
-- 2026-11-24  BARBERÍAS: Resumen personalizable por usuario.
--   SOLO AGREGA la tabla brb_preferencias (orden y bloques visibles del
--   Resumen de cada usuario, en JSON). No modifica tablas existentes ni
--   datos, y no toca otros módulos. Si falta, TX usa el orden de fábrica.
--   Ejecutar con el esquema de datos seleccionado (USE tx; o USE tx_pre;).
--   Idempotente.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS brb_preferencias (
    cuenta_id       INT NOT NULL COMMENT 'kapps_db.accounts.id',
    clave           VARCHAR(40) NOT NULL COMMENT 'inicio = orden del Resumen',
    valor           TEXT NOT NULL COMMENT 'JSON',
    actualizado_utc DATETIME NOT NULL,
    PRIMARY KEY (cuenta_id, clave)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


-- ---------------------------------------------------------------------
-- 2026-11-24  BARBERÍAS: Pendientes de pago (el cliente paga después).
--   SOLO AGREGA 2 tablas nuevas brb_*. No modifica tablas existentes ni
--   datos, y no toca otros módulos ni kapps_db.
--   Un pendiente guarda los servicios y precios del día en que se atendió.
--   No es ingreso: el ingreso nace cuando se paga (se crea un cobro normal
--   en brb_cobros, con su ticket, y el pendiente queda 'pagado' con su
--   cobro_id). 'regalia' = el negocio decidió no cobrarlo (con motivo).
--   Ejecutar con el esquema de datos seleccionado (USE tx; o USE tx_pre;).
--   Idempotente.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS brb_pendientes (
    id                INT NOT NULL AUTO_INCREMENT,
    kapp_id           INT NOT NULL,
    barberia_id       INT NOT NULL,
    cliente_id        INT NOT NULL COMMENT 'Obligatorio: quién debe',
    barbero_id        INT NULL COMMENT 'Quién atendió',
    subtotal          DECIMAL(10,2) NOT NULL,
    descuento         DECIMAL(10,2) NOT NULL DEFAULT 0,
    iva               DECIMAL(10,2) NOT NULL DEFAULT 0,
    total             DECIMAL(10,2) NOT NULL,
    iva_pct           DECIMAL(5,2) NOT NULL DEFAULT 0,
    notas             VARCHAR(200) NULL,
    estado            VARCHAR(10) NOT NULL DEFAULT 'pendiente' COMMENT 'pendiente | pagado | regalia',
    cobro_id          INT NULL COMMENT 'brb_cobros.id con el que se pagó',
    motivo_regalia    VARCHAR(300) NULL,
    cerrado_por       INT NULL COMMENT 'kapps_db.accounts.id de quien lo cobró o lo dio en regalía',
    fecha_cierre_utc  DATETIME NULL,
    idem_key          CHAR(32) NULL COMMENT 'Evita duplicar si el formulario se envía dos veces',
    cuenta_id         INT NOT NULL COMMENT 'kapps_db.accounts.id de quien lo registró',
    fecha_utc         DATETIME NOT NULL COMMENT 'Cuándo se atendió y quedó pendiente',
    PRIMARY KEY (id),
    UNIQUE KEY uq_brb_pendientes_idem (idem_key),
    KEY ix_brb_pendientes_barberia (barberia_id, estado, fecha_utc),
    KEY ix_brb_pendientes_cliente (cliente_id, estado),
    KEY ix_brb_pendientes_cobro (cobro_id),
    CONSTRAINT fk_brb_pendientes_barberia FOREIGN KEY (barberia_id) REFERENCES brb_barberias (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_pendiente_lineas (
    id              INT NOT NULL AUTO_INCREMENT,
    pendiente_id    INT NOT NULL,
    servicio_id     INT NULL,
    descripcion     VARCHAR(120) NOT NULL,
    cantidad        SMALLINT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    total           DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    KEY ix_brb_pl_pendiente (pendiente_id),
    CONSTRAINT fk_brb_pl_pendiente FOREIGN KEY (pendiente_id) REFERENCES brb_pendientes (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


-- ---------------------------------------------------------------------
-- 2026-11-25  BARBERÍAS: Abonos a los pendientes de pago y ajustes de la
--   organización.
--   SOLO AGREGA 2 tablas nuevas brb_*. No modifica tablas existentes ni
--   datos, y no toca otros módulos ni kapps_db.
--   brb_pendiente_abonos: cada pago de un pendiente (parcial o el último)
--   es un cobro normal en brb_cobros, con su ticket; esta tabla lo liga al
--   pendiente. Saldo = brb_pendientes.total - suma de sus abonos.
--   brb_ajustes: ajustes de la organización que decide su administrador
--   general en TX (hoy: 'abonos' = permitir abonos). Sin fila = valor de
--   fábrica (abonos permitidos).
--   Ejecutar con el esquema de datos seleccionado (USE tx; o USE tx_pre;).
--   Idempotente. Requiere la sección «Pendientes de pago».
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS brb_pendiente_abonos (
    id            INT NOT NULL AUTO_INCREMENT,
    pendiente_id  INT NOT NULL,
    cobro_id      INT NOT NULL COMMENT 'brb_cobros.id del pago (con su ticket)',
    monto         DECIMAL(10,2) NOT NULL,
    cuenta_id     INT NOT NULL COMMENT 'kapps_db.accounts.id de quien lo cobró',
    fecha_utc     DATETIME NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_brb_pa_cobro (cobro_id),
    KEY ix_brb_pa_pendiente (pendiente_id),
    CONSTRAINT fk_brb_pa_pendiente FOREIGN KEY (pendiente_id) REFERENCES brb_pendientes (id) ON DELETE CASCADE,
    CONSTRAINT fk_brb_pa_cobro FOREIGN KEY (cobro_id) REFERENCES brb_cobros (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS brb_ajustes (
    kapp_id          INT NOT NULL,
    clave            VARCHAR(40) NOT NULL COMMENT 'abonos = permitir abonos a los pendientes de pago (1/0)',
    valor            VARCHAR(200) NOT NULL,
    cuenta_id        INT NOT NULL COMMENT 'kapps_db.accounts.id de quien lo cambió',
    actualizado_utc  DATETIME NOT NULL,
    PRIMARY KEY (kapp_id, clave)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
