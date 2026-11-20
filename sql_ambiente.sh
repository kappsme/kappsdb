#!/bin/sh
# Traduce un SQL escrito para producción (esquema kapps_db) al esquema de administración de otro ambiente.
# SQL_DDL_DML_UPDATES.sql siempre se escribe con kapps_db; las apps hacen la misma traducción con
# MYSQL_DB_KAPPS (tx/esquemas.py). Cambia kapps_db. , `kapps_db`. y 'kapps_db' (table_schema = 'kapps_db').
# El esquema de datos (tx / tx_pre) no se traduce: el SQL no lo lleva escrito, se elige con USE o con mysql <base>.
#
# Uso:
#   ./sql_ambiente.sh kapps_db_pre                          > updates_pre.sql   (SQL_DDL_DML_UPDATES.sql)
#   ./sql_ambiente.sh kapps_db_pre otro.sql                 > otro_pre.sql
#   ./sql_ambiente.sh kapps_db_pre | mysql ... tx_pre                           (aplicar directo)
# En el sandbox de GoDaddy: generar updates_pre.sql y correrlo en phpMyAdmin con tx_pre seleccionada.
set -eu

destino=${1:-}
archivo=${2:-$(dirname "$0")/SQL_DDL_DML_UPDATES.sql}
case "$destino" in
  ''|*[!A-Za-z0-9_]*) echo "uso: $0 <esquema_kapps_destino> [archivo.sql]   (solo letras, números y _)" >&2; exit 2 ;;
esac
[ -f "$archivo" ] || { echo "no existe $archivo" >&2; exit 2; }

# (^|no-palabra) + kapps_db + (. | `. | '): kapps_db_pre y similares no coinciden
sed -E \
  -e "s/(^|[^A-Za-z0-9_\$])kapps_db\./\1${destino}./g" \
  -e "s/(^|[^A-Za-z0-9_\$])\`kapps_db\`\./\1\`${destino}\`./g" \
  -e "s/'kapps_db'/'${destino}'/g" \
  "$archivo"
