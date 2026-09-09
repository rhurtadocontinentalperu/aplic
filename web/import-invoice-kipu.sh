#!/bin/bash
# Nombre: import-invoice-kipu.sh

# Ruta del Progress
DLC="/usr/progress10"
export DLC
export PATH="$DLC/bin:$PATH"

MBPRO="$DLC/bin/mbpro"

if [ ! -x "$MBPRO" ]; then
    log "ERROR: no se encontró el ejecutable $MBPRO"
    exit 1
fi

# Variables de control
LOCKFILE="/tmp/importinvoicekipu.lock"
LOGDIR="/var/log"
LOGPREFIX="importinvoicekipu"
LOGFILE="${LOGDIR}/${LOGPREFIX}-$(date '+%Y-%m-%d').txt"
WORKDIR="/v/IN/ON_IN_CO/prg"

log() {
    printf '%s - %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOGFILE"
}

# Validar acceso al directorio de logs
if [ ! -d "$LOGDIR" ]; then
    exit 1
fi

# Abrir el archivo de lock en el descriptor 9
exec 9>>"$LOCKFILE" || exit 1

# Evitar ejecuciones concurrentes
if ! flock -n 9; then
    log "Proceso omitido: ya existe una ejecución en curso."
    exit 0
fi

# Conservar únicamente los logs de los últimos 30 días
find "$LOGDIR" -maxdepth 1 -type f -name "${LOGPREFIX}-*.txt" \
    -daystart -mtime +29 -delete

log "------------------------------------------"
log "INICIO"

if ! cd "$WORKDIR"; then
    log "ERROR: no se pudo acceder a $WORKDIR"
    exit 1
fi

# Rutina Principal
"$MBPRO" -pf integral.pf -p import-invoice-kipu >> "$LOGFILE" 2>&1

status=$?

if [ "$status" -eq 0 ]; then
    log "FIN: proceso finalizado correctamente."
else
    log "FIN CON ERROR: mbpro terminó con código $status."
fi

exit "$status"

