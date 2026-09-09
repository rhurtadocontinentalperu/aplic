/* JSON recibido 
[
    {
        "DocumentoNumero":"F001-123456",
        "DocumentoTotal":1500.75,
        "Moneda":"SOL",
        "Fecha":"2026-07-09"
    }
]
*/

/*------------------------------------------------------------*/
/* Ejemplo simple de uso de json-utils.p                      */
/*------------------------------------------------------------*/

DEF VAR hJson      AS HANDLE NO-UNDO.
DEF VAR hJsonUtils AS HANDLE NO-UNDO.

DEF VAR cJson      AS LONGCHAR NO-UNDO.
DEF VAR cError     AS CHAR NO-UNDO.

DEF VAR iArrayId   AS INTE NO-UNDO.
DEF VAR iItems     AS INTE NO-UNDO.
DEF VAR iItemId    AS INTE NO-UNDO.

DEF VAR cNumero    AS CHAR NO-UNDO.
DEF VAR dImporte   AS DECI NO-UNDO.
DEF VAR iMoneda    AS INTE NO-UNDO.
DEF VAR dFecha     AS DATE NO-UNDO.

DEF VAR lOk        AS LOG NO-UNDO.


/*------------------------------------------------------------*/
/* Inicializamos librerías                                    */
/*------------------------------------------------------------*/

RUN lib/json10.p PERSISTENT SET hJson.
RUN lib/json-utils.p PERSISTENT SET hJsonUtils.


/*------------------------------------------------------------*/
/* JSON de prueba                                             */
/*------------------------------------------------------------*/

cJson =
'[
   {
      "DocumentoNumero":"F001-123456",
      "DocumentoTotal":1500.75,
      "Moneda":"SOL",
      "Fecha":"2026-07-09"
   }
]'.


/*------------------------------------------------------------*/
/* Inicializar parser                                         */
/*------------------------------------------------------------*/

RUN JsonInit IN hJsonUtils (
        INPUT  hJson,
        INPUT  cJson,
        OUTPUT iArrayId,
        OUTPUT iItems,
        OUTPUT cError).

IF cError > "" THEN DO:
    MESSAGE cError
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.


/*------------------------------------------------------------*/
/* Leer primer registro                                       */
/*------------------------------------------------------------*/

RUN JsonGetItem IN hJsonUtils (
        INPUT  iArrayId,
        INPUT  1,
        OUTPUT iItemId,
        OUTPUT lOk).

IF lOk THEN DO:

    RUN JsonGetChar IN hJsonUtils (
            INPUT  iItemId,
            INPUT  "DocumentoNumero",
            OUTPUT cNumero).

    RUN JsonGetDecimal IN hJsonUtils (
            INPUT  iItemId,
            INPUT  "DocumentoTotal",
            OUTPUT dImporte).

    RUN JsonGetCurrency IN hJsonUtils (
            INPUT  iItemId,
            INPUT  "Moneda",
            OUTPUT iMoneda).

    RUN JsonGetDate IN hJsonUtils (
            INPUT  iItemId,
            INPUT  "Fecha",
            OUTPUT dFecha).

    DISPLAY
        cNumero LABEL "Documento"
        dImporte LABEL "Importe"
        iMoneda LABEL "Moneda"
        dFecha LABEL "Fecha"
        WITH FRAME fDatos.
END.


/*------------------------------------------------------------*/
/* Liberar recursos                                           */
/*------------------------------------------------------------*/

RUN JsonDestroy IN hJsonUtils.

DELETE PROCEDURE hJsonUtils.
DELETE PROCEDURE hJson.

