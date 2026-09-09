DEF VAR s-codcia AS INTE INIT 001.
DEF VAR pcodmat AS CHAR INIT "079812".
DEF VAR pcodalm AS CHAR INIT "03".
DEF VAR fDesde AS DATE.

/* 1 Stock Actual */
SELECT stkact
    FROM almmmate
    WHERE almmmate.codcia = s-codcia AND almmmate.codalm = pCodAlm AND almmmate.codmat = pCodMat

/* Ordenes de Despacho */
SELECT SUM((facdpedi.canped - facdpedi.canate) * facdpedi.factor)
    FROM facdpedi
    JOIN faccpedi ON
    faccpedi.codcia = facdpedi.codcia 
    AND faccpedi.coddiv = facdpedi.coddiv
    AND faccpedi.coddoc = facdpedi.coddoc
    AND faccpedi.nroped = facdpedi.nroped
    AND faccpedi.codalm = pCodAlm
    AND faccpedi.FlgEst = "P"
    WHERE facdpedi.codcia = s-CodCia
    AND facdpedi.codmat = pCodMat
    AND facdpedi.coddoc = "O/D"
    AND facdpedi.flgest = "P"
    .



fDesde = TODAY - 30.

/* Definimos rango de fecha y hora */
DEF VAR dtDesde AS DATETIME NO-UNDO.
DEF VAR cHora  AS CHAR NO-UNDO.

/* Tiempo por defecto fuera de campaña (segundos) */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
DEF VAR TimeLimit AS CHARACTER NO-UNDO.

FIND FIRST FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR. 
FIND FIRST FacCfgVta WHERE FacCfgVta.CodCia = s-codcia AND
    FacCfgVta.CodDoc = "P/M" AND
    (TODAY >= FacCfgVta.FechaD AND TODAY <= FacCfgVta.FechaH)
    NO-LOCK NO-ERROR.

TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).
IF AVAILABLE FacCfgVta THEN 
    TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
                (FacCfgVta.Hora-Res * 3600) + 
                (FacCfgVta.Minu-Res * 60).

dtDesde = ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds').
fDesde = DATE(dtDesde).
cHora  = ENTRY(2,STRING(dtDesde, '99/99/9999 HH:MM'), ' ').

/* Ventas Contado */
SELECT SUM(facdpedi.canped * facdpedi.factor)
    FROM facdpedi
    JOIN faccpedi ON
    faccpedi.codcia = facdpedi.codcia 
    AND faccpedi.coddiv = facdpedi.coddiv
    AND faccpedi.coddoc = facdpedi.coddoc
    AND faccpedi.nroped = facdpedi.nroped
    AND faccpedi.FlgEst = "P"
    WHERE facdpedi.codcia = s-CodCia
    AND facdpedi.codmat = pCodMat
    AND facdpedi.coddoc = 'P/M'
    AND facdpedi.flgest = 'P'
    AND facdpedi.almdes = pCodAlm
    AND (facdpedi.fchped >= fDesde AND facdpedi.fchped <= TODAY)
    AND NOT (facdpedi.fchped = fDesde AND facdpedi.hora < cHora)
    .


/* Ordenes de Transferencia */
SELECT SUM((facdpedi.canped - facdpedi.canate) * facdpedi.factor)
    FROM facdpedi
    JOIN faccpedi ON
    faccpedi.codcia = facdpedi.codcia 
    AND faccpedi.coddiv = facdpedi.coddiv
    AND faccpedi.coddoc = facdpedi.coddoc
    AND faccpedi.nroped = facdpedi.nroped
    AND faccpedi.codalm = pCodAlm
    AND faccpedi.FlgEst = "P"
    WHERE facdpedi.codcia = s-CodCia
    AND facdpedi.codmat = pCodMat
    AND facdpedi.coddoc = "OTR"
    AND facdpedi.flgest = "P"
    .

/* Pedidos Logísticos */
DEF VAR LocalDiasComprometido AS DECI INIT 30 NO-UNDO.      /* Exagerando */

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia AND 
    VtaTabla.Tabla = 'CONFIG-VTAS' AND 
    VtaTabla.Llave_c1 = 'STOCK-COMPROMETIDO'
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla AND VtaTabla.Valor[01] > 0 THEN LocalDiasComprometido = VtaTabla.Valor[01].

DEFINE VAR x-flg-reserva-stock AS CHAR.
DEFINE VAR x-fecha AS DATE.

x-flg-reserva-stock = "G,X,P,W,WX,WL".

x-fecha = (TODAY - LocalDiasComprometido).

SELECT SUM((facdpedi.canped - facdpedi.canate) * facdpedi.factor)
    FROM facdpedi
    JOIN faccpedi ON 
    faccpedi.codcia = facdpedi.codcia
    AND faccpedi.coddiv = facdpedi.coddiv
    AND faccpedi.coddoc = facdpedi.coddoc
    AND faccpedi.nroped = facdpedi.nroped
    AND LOOKUP(faccpedi.FlgEst, x-flg-reserva-stock) > 0
    WHERE facdpedi.codcia = s-CodCia
    AND facdpedi.almdes = pCodAlm
    AND facdpedi.codmat = pCodMat
    AND facdpedi.coddoc = "PED"
    AND facdpedi.flgest = 'P'
    AND facdpedi.FchPed >= x-fecha
    .


/* Pedidos Comerciales */
SELECT SUM((facdpedi.canped - facdpedi.canate) * facdpedi.factor)
    FROM faccpedi 

    JOIN facdpedi ON
    facdpedi.codcia = faccpedi.codcia AND
    facdpedi.coddiv = faccpedi.coddiv AND
    facdpedi.coddoc = faccpedi.coddoc AND
    facdpedi.nroped = faccpedi.nroped AND 
    facdpedi.flgest = "P" AND
    facdpedi.almdes = pCodAlm

    WHERE faccpedi.codcia = s-codcia AND
    faccpedi.coddiv = facdpedi.coddiv AND
    faccpedi.coddoc = "COT" AND
    faccpedi.nroped = facdpedi.nroped AND
    faccpedi.flgest IN (
        SELECT vtatabla.llave_c4
        FROM vtatabla
        JOIN factabla ON
        factabla.codcia = 001 AND
        factabla.tabla = 'GN-DIVI' AND
        factabla.campo-L[2] = YES AND
        factabla.valor[1] > 0 AND
        FacTabla.Codigo = vtatabla.llave_c3 
        WHERE vtatabla.codcia = 001 AND
        vtatabla.tabla = "CONFIG-VTAS" AND
        vtatabla.llave_c1 = "PEDIDO.COMERCIAL" AND
        vtatabla.llave_c2 = "FLG.RESERVA.STOCK" AND
        vtatabla.llave_c4 > ""
        )





