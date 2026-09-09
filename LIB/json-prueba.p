
DEFINE VARIABLE cJsonString AS CHARACTER NO-UNDO.
DEFINE VARIABLE iKeyCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iStartPos AS INTEGER NO-UNDO.
DEFINE VARIABLE iCurrentPos AS INTEGER NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

cJsonString = '{ "data": { "nombre": "Juan", "apellido": "Perez" } }'.
iKeyCount = 0.
iStartPos = 0.

/* Buscar la posición de la llave que quieres */
iStartPos = R-INDEX(cJsonString, '"data":') + 8. /* +8 para saltar a '{' */

DO WHILE iCurrentPos <= LENGTH(cJsonString):
    iCurrentPos = iCurrentPos + 1.
    IF SUBSTRING(cJsonString, iCurrentPos, 1) = '{' THEN
        iKeyCount = iKeyCount + 1.
    ELSE IF SUBSTRING(cJsonString, iCurrentPos, 1) = '}' THEN
        iKeyCount = iKeyCount - 1.

    /* Cuando el contador llega a cero, significa que hemos cerrado la llave del objeto */
    IF iKeyCount = 0 AND iStartPos > 0 THEN DO:
        cValue = SUBSTRING(cJsonString, iStartPos, iCurrentPos - iStartPos + 1).
        LEAVE.
    END.
END.

MESSAGE "El valor del objeto 'data' es: " + cValue VIEW-AS ALERT-BOX.
