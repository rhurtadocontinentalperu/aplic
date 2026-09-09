#!/bin/bash

####################################################### FACTURA DE RESERVA ##############################################################
# Nombre del Shell 	: facturadereserva2sap.sh
# cron			: */5 * * * * /ruta/del/script/facturadereserva2sap.sh
# curl			: curl -X 'GET' 'http://localhost:9500/interfacesatelite2sap/ventas/facturareserva' -H 'accept: application/json'
##########################################################################################################################################

# 1. Definición de rutas y variables
LOCKFILE="/tmp/facturadereserva2sap.lock"
LOGFILE="/var/log/facturadereserva2sap.txt"
URL="http://192.168.100.222:9500/interfacesatelite2sap/ventas/facturareserva"

# 2. Comprobar si el proceso existe
if [ -f "$LOCKFILE" ]; then
    # Opcional: Si el archivo tiene más de 1 hora, quizá el proceso murió.
    # Aquí simplemente avisamos y salimos.
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Proceso omitido: El candado ya existe." >> "$LOGFILE"
    exit 0
fi

# 3. Crear proceso y asegurar limpieza al salir
# El trap ejecutará rm -f incluso si el script es cancelado
touch "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT

# 4. Ejecución del CURL
echo "------------------------------------------" >> "$LOGFILE"
echo "INICIO: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOGFILE"

# -s: silencioso, -S: muestra errores, -f: falla en errores HTTP (ej 404, 500)
/usr/bin/curl -sS -X 'GET' "$URL" -H 'accept: application/json' >> "$LOGFILE" 2>&1

echo -e "\nFIN: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOGFILE"
