DEFINE INPUT PARAMETER pReemplazar AS LOG.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pCodMat AS CHAR.
DEFINE INPUT PARAMETER pPreOfi AS DECI.
DEFINE INPUT PARAMETE  pFchPrmD AS DATE.
DEFINE INPUT PARAMETER pFchPrmH AS DATE.
DEFINE INPUT PARAMETER pDescuentoVIP AS DECI.
DEFINE INPUT PARAMETER pDescuentoMR  AS DECI.
DEFINE INPUT PARAMETER pDescuento    AS DECI.
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR x-PreUni AS DECI NO-UNDO.
DEFINE VAR pCuenta AS INTE NO-UNDO.
    
x-PreUni = pPreOfi.
CASE pReemplazar:
    WHEN NO THEN DO:
        /* 1ro. Limpiamos información vigente */
        FOR EACH {&Tabla} EXCLUSIVE-LOCK WHERE {&Tabla}.CodCia = s-CodCia AND
            {&Tabla}.CodDiv = pCodDiv AND 
            {&Tabla}.CodMat = pCodMat AND
            {&Tabla}.FchIni = pFchPrmD AND 
            {&Tabla}.FchFin = pFchPrmH AND
            {&Tabla}.FlgEst = "A":
            ASSIGN
                {&Tabla}.FlgEst  = "I"
                {&Tabla}.FchAnulacion  = TODAY
                {&Tabla}.HoraAnulacion = STRING(TIME, 'HH:MM:SS')
                {&Tabla}.UsrAnulacion = s-user-id.
        END.
        /* todas las promociones por producto */
        CREATE {&Tabla}.
        ASSIGN
            {&Tabla}.CodCia = s-CodCia 
            {&Tabla}.CodDiv = pCodDiv 
            {&Tabla}.CodMat = pCodMat
            {&Tabla}.FchIni = pFchPrmD
            {&Tabla}.FchFin = pFchPrmH
            {&Tabla}.DescuentoVIP = pDescuentoVIP
            {&Tabla}.DescuentoMR = pDescuentoMR
            {&Tabla}.Descuento = pDescuento
            {&Tabla}.UsrCreacion = s-User-Id
            {&Tabla}.FchCreacion = TODAY
            {&Tabla}.HoraCreacion = STRING(TIME, 'HH:MM:SS')
            {&Tabla}.Tipo = "CONVIVIR".
        IF {&Tabla}.DescuentoVIP > 0 THEN {&Tabla}.PrecioVIP = ROUND(x-PreUni * (1 - ({&Tabla}.DescuentoVIP / 100)), 4).
        IF {&Tabla}.DescuentoMR  > 0 THEN {&Tabla}.PrecioMR  = ROUND(x-PreUni * (1 - ({&Tabla}.DescuentoMR / 100)), 4).
        IF {&Tabla}.Descuento    > 0 THEN {&Tabla}.Precio    = ROUND(x-PreUni * (1 - ({&Tabla}.Descuento / 100)), 4).
    END.
    WHEN YES THEN DO:
        /* ****************************************************************************************** */
        /* 1ro. Buscamos promoción que cuya fecha de inicio se encuentre dentro de la nueva promoción */
        /* ****************************************************************************************** */
        FOR EACH {&b-Tabla} EXCLUSIVE-LOCK WHERE {&b-Tabla}.CodCia = s-CodCia
            AND {&b-Tabla}.CodDiv = pCodDiv
            AND {&b-Tabla}.CodMat = pCodMat
            AND {&b-Tabla}.FlgEst = "A"
            AND {&b-Tabla}.FchIni >= pFchPrmD
            AND {&b-Tabla}.FchIni <= pFchPrmH:
            IF {&b-Tabla}.FchFin <= pFchPrmH THEN DO:
                /* La promoción se encuentra dentro de la nueva promoción => es absorvida por la nueva promoción */
                ASSIGN
                    {&b-Tabla}.FlgEst = "I"
                    {&b-Tabla}.FchAnulacion = TODAY 
                    {&b-Tabla}.UsrAnulacion = s-user-id
                    {&b-Tabla}.HoraAnulacion = STRING(TIME, 'HH:MM:SS').
            END.
            ELSE DO:
                /* Se inactiva y se genera una nueva con nuevos vencimientos */
                CREATE {&Tabla}.
                BUFFER-COPY {&b-Tabla} TO {&Tabla}
                    ASSIGN
                    {&Tabla}.FlgEst = "A"
                    {&Tabla}.FchIni = pFchPrmH + 1       /* OJO */
                    {&Tabla}.HoraCreacion = STRING(TIME, 'HH:MM:SS')
                    {&Tabla}.FchCreacion = TODAY
                    {&Tabla}.UsrCreacion = s-user-id.
                ASSIGN
                    {&b-Tabla}.FlgEst = "I"
                    {&b-Tabla}.FchAnulacion = TODAY 
                    {&b-Tabla}.UsrAnulacion = s-user-id
                    {&b-Tabla}.HoraAnulacion = STRING(TIME, 'HH:MM:SS').
            END.
        END.
        /* ****************************************************************************************** */
        /* 2do. Buscamos promoción que cuya fecha de fin sea >= de la de fin de la nueva promoción    */
        /* ****************************************************************************************** */
        FOR EACH {&b-Tabla} EXCLUSIVE-LOCK WHERE {&b-Tabla}.CodCia = s-CodCia
            AND {&b-Tabla}.CodDiv = pCodDiv
            AND {&b-Tabla}.CodMat = pCodMat
            AND {&b-Tabla}.FlgEst = "A"
            AND {&b-Tabla}.FchIni < pFchPrmD 
            AND {&b-Tabla}.FchFin >= pFchPrmD:
            /* Se inactiva y se generan hasta 2 una con nuevos vencimientos */
            CREATE {&Tabla}.
            BUFFER-COPY {&b-Tabla} TO {&Tabla}
                ASSIGN
                {&Tabla}.FlgEst = "A"
                {&Tabla}.FchFin = pFchPrmD - 1       /* OJO */
                {&Tabla}.HoraCreacion = STRING(TIME, 'HH:MM:SS')
                {&Tabla}.FchCreacion = TODAY
                {&Tabla}.UsrCreacion = s-user-id.
            IF {&b-Tabla}.FchFin > pFchPrmH THEN DO:
                CREATE {&Tabla}.
                BUFFER-COPY {&b-Tabla} TO {&Tabla}
                    ASSIGN
                    {&Tabla}.FlgEst = "A"
                    {&Tabla}.FchIni = pFchPrmH + 1       /* OJO */
                    {&Tabla}.HoraCreacion = STRING(TIME, 'HH:MM:SS')
                    {&Tabla}.FchCreacion = TODAY
                    {&Tabla}.UsrCreacion = s-user-id.
            END.
            ASSIGN
                {&b-Tabla}.FlgEst = "I"
                {&b-Tabla}.FchAnulacion = TODAY 
                {&b-Tabla}.UsrAnulacion = s-user-id
                {&b-Tabla}.HoraAnulacion = STRING(TIME, 'HH:MM:SS').
        END.
        /* ****************************************************************************************** */
        /* 3ro. Grabamos la nueva promoción */
        /* ****************************************************************************************** */
        CREATE {&Tabla}.
        ASSIGN
            {&Tabla}.codcia = s-CodCia 
            {&Tabla}.FlgEst = "A"
            {&Tabla}.CodDiv = pCodDiv
            {&Tabla}.CodMat = pCodMat 
            {&Tabla}.FchIni = pFchPrmD
            {&Tabla}.FchFin = pFchPrmH 
            {&Tabla}.FchCreacion = TODAY
            {&Tabla}.HoraCreacion = STRING(TIME, 'HH:MM:SS')
            {&Tabla}.UsrCreacion = s-user-id
            {&Tabla}.Descuento    = pDescuento 
            {&Tabla}.DescuentoMR  = pDescuentoMR 
            {&Tabla}.DescuentoVIP = pDescuentoVIP
            {&Tabla}.Tipo = "REEMPLAZAR".
        IF {&Tabla}.DescuentoVIP > 0 THEN {&Tabla}.PrecioVIP = ROUND(x-PreUni * (1 - ({&Tabla}.DescuentoVIP / 100)), 4).
        IF {&Tabla}.DescuentoMR  > 0 THEN {&Tabla}.PrecioMR  = ROUND(x-PreUni * (1 - ({&Tabla}.DescuentoMR / 100)), 4).
        IF {&Tabla}.Descuento    > 0 THEN {&Tabla}.Precio    = ROUND(x-PreUni * (1 - ({&Tabla}.Descuento / 100)), 4).
    END.
END CASE.
