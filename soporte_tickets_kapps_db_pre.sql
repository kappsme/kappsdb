-- =====================================================================
-- SANDBOX (GoDaddy): tickets de soporte para kapps_db_pre.
-- Generado con: sh sql_ambiente.sh kapps_db_pre (sección «2026-11-26 SOPORTE: tickets» de SQL_DDL_DML_UPDATES.sql).
-- Solo agrega 3 tablas y 7 filas de parámetros; idempotente. Correr en phpMyAdmin con tx_pre seleccionada.
-- =====================================================================

-- 2026-11-26  SOPORTE: tickets de los usuarios de TX, atendidos en Admin.
--   SOLO AGREGA 3 tablas nuevas en kapps_db (compartidas por todas las
--   KAPP, como accounts) y 7 filas en kapps_db_pre.tx_params_cat: el parámetro
--   «Correo de tickets» (categoría TICKETS) de cada módulo, vacío por
--   defecto, que Admin muestra en la configuración de cada KAPP. No
--   modifica tablas ni parámetros existentes.
--   Fechas en UTC. Idempotente.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS kapps_db_pre.soporte_tickets (
    id                  INT NOT NULL AUTO_INCREMENT,
    kapp_id             INT NOT NULL,
    cuenta_id           INT NOT NULL COMMENT 'kapps_db_pre.accounts.id de quien lo creó',
    modulo_id           INT NOT NULL COMMENT 'kapps_db_pre.kapps_modules_cat.id abierto al crearlo',
    titulo              VARCHAR(120) NOT NULL,
    descripcion         TEXT NOT NULL,
    estado              VARCHAR(12) NOT NULL DEFAULT 'enviado' COMMENT 'enviado | recibido | en_proceso | esperando | resuelto',
    pagina              VARCHAR(255) NULL COMMENT 'Ruta de TX desde la que se reportó',
    navegador           VARCHAR(255) NULL,
    correo_aviso        VARCHAR(200) NULL COMMENT 'A dónde se avisó al crearlo',
    creado_utc          DATETIME NOT NULL,
    actualizado_utc     DATETIME NOT NULL,
    resuelto_utc        DATETIME NULL,
    ultimo_soporte_utc  DATETIME NULL COMMENT 'Último cambio visible hecho por soporte',
    visto_usuario_utc   DATETIME NULL COMMENT 'Cuándo lo vio por última vez quien lo creó',
    PRIMARY KEY (id),
    KEY ix_soporte_estado (estado, creado_utc),
    KEY ix_soporte_kapp (kapp_id),
    KEY ix_soporte_cuenta (cuenta_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS kapps_db_pre.soporte_ticket_eventos (
    id            INT NOT NULL AUTO_INCREMENT,
    ticket_id     INT NOT NULL,
    autor         VARCHAR(8) NOT NULL COMMENT 'usuario | soporte | sistema',
    cuenta_id     INT NULL,
    tipo          VARCHAR(8) NOT NULL COMMENT 'mensaje | estado',
    estado_nuevo  VARCHAR(12) NULL,
    texto         TEXT NULL,
    interno       TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = nota de soporte que el usuario no ve',
    fecha_utc     DATETIME NOT NULL,
    PRIMARY KEY (id),
    KEY ix_soporte_ev_ticket (ticket_id, id),
    CONSTRAINT fk_soporte_ev_ticket FOREIGN KEY (ticket_id) REFERENCES kapps_db_pre.soporte_tickets (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS kapps_db_pre.soporte_ticket_adjuntos (
    id         INT NOT NULL AUTO_INCREMENT,
    ticket_id  INT NOT NULL,
    mime       VARCHAR(40) NOT NULL,
    datos      MEDIUMBLOB NOT NULL,
    bytes      INT NOT NULL,
    fecha_utc  DATETIME NOT NULL,
    PRIMARY KEY (id),
    KEY ix_soporte_adj_ticket (ticket_id),
    CONSTRAINT fk_soporte_adj_ticket FOREIGN KEY (ticket_id) REFERENCES kapps_db_pre.soporte_tickets (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

INSERT INTO kapps_db_pre.tx_params_cat
    (module_id, nombre, descripcion, estado, html_type, html_additional, category, customizable, required, `system`, default_value)
SELECT c.id, 'Correo de tickets', 'Recibe los tickets de soporte del módulo', 1, 'email', 'multiple maxlength=200', 'TICKETS', 1, 0, 1, ''
FROM kapps_db_pre.kapps_modules_cat c
WHERE c.id IN (1, 2, 3, 4, 5, 6, 9)
  AND NOT EXISTS (SELECT 1 FROM kapps_db_pre.tx_params_cat p WHERE p.module_id = c.id AND p.category = 'TICKETS');
