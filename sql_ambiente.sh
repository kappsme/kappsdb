#!/bin/sh
# Traduce un SQL escrito para producción (esquema kapps_db) al esquema de administración de otro ambiente.
# SQL_DDL_DML_UPDATES.sql siempre se escribe con kapps_db; las apps hacen la misma traducción con
# MYSQL_DB_KAPPS (tx/esquemas.py). Cambia kapps_db. , `kapps_db`. y 'kapps_db' (table_schema = 'kapps_db').
# El esquema de datos (tx / tx_pre) no se traduce: el SQL no lo lleva escrito, se elige con USE o con mysql <base>.
#
# Uso:
#   sql_ambiente.sh <esquema_destino> [-o salida.sql] [entrada.sql]
#   (entrada por defecto: SQL_DDL_DML_UPDATES.sql junto a este script; sin -o escribe en la pantalla/stdout)
#
# Desde Git Bash (o Linux/Mac):
#   ./sql_ambiente.sh kapps_db_pre -o updates_pre.sql
#   ./sql_ambiente.sh kapps_db_pre | mysql ... tx_pre                 (aplicar directo)
# Desde PowerShell: NO usar .\sql_ambiente.sh (Windows lo abre en otra ventana de Git Bash y no devuelve nada),
# ni bash a secas (es WSL), ni > (PowerShell 5.1 guarda en UTF-16). Usar el bash de Git y -o:
#   & "C:\Program Files\Git\bin\bash.exe" ./sql_ambiente.sh kapps_db_pre -o updates_pre.sql
#
# En el sandbox de GoDaddy: generar updates_pre.sql y correrlo en phpMyAdmin con tx_pre seleccionada.
set -eu

uso() { echo "uso: $0 <esquema_destino> [-o salida.sql] [entrada.sql]   (esquema: solo letras, números y _)" >&2; exit 2; }

destino=${1:-}
case "$destino" in
  ''|*[!A-Za-z0-9_]*) uso ;;
esac
shift
salida=""
archivo="$(dirname "$0")/SQL_DDL_DML_UPDATES.sql"
while [ $# -gt 0 ]; do
  case "$1" in
    -o) [ $# -ge 2 ] || uso; salida=$2; shift 2 ;;
    -*) uso ;;
    *) archivo=$1; shift ;;
  esac
done
[ -f "$archivo" ] || { echo "no existe $archivo" >&2; exit 2; }

traducir() {
  # (^|no-palabra) + kapps_db + (. | `. | '): kapps_db_pre y similares no coinciden
  sed -E \
    -e "s/(^|[^A-Za-z0-9_\$])kapps_db\./\1${destino}./g" \
    -e "s/(^|[^A-Za-z0-9_\$])\`kapps_db\`\./\1\`${destino}\`./g" \
    -e "s/'kapps_db'/'${destino}'/g" \
    "$archivo"
}

if [ -n "$salida" ]; then
  traducir > "$salida"
  echo "listo: $salida ($(grep -c '' "$salida") líneas, kapps_db -> $destino, desde $archivo)" >&2
else
  traducir
fi
