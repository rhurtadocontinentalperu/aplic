&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Generar una COTiZACION x TRANSFERENCIA DE SALDOS

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT  PARAMETER pRowidI AS ROWID.
DEF INPUT  PARAMETER pCodDiv AS CHAR.
DEF INPUT  PARAMETER s-user-id AS CHAR.
DEF OUTPUT PARAMETER pRowidS AS ROWID.

DEF BUFFER COTIZACION FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.

FIND COTIZACION WHERE ROWID(COTIZACION) = pRowidI NO-LOCK NO-ERROR.
IF NOT AVAILABLE COTIZACION THEN RETURN.

/* CONSISTENCIA */
IF COTIZACION.FlgEst <> "P" THEN DO:
    MESSAGE 'La' COTIZACION.coddoc COTIZACION.nroped 'NO está pendiente'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
FIND FIRST Facdpedi OF COTIZACION WHERE facdpedi.CanAte > 0 NO-LOCK NO-ERROR.
IF NOT AVAILABLE Facdpedi THEN DO:
    MESSAGE 'La' COTIZACION.coddoc COTIZACION.nroped 'NO tiene NINGUNA atención'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* BLOQUEAR SI SE HA TRABAJADO CON OTRA LISTA DE PRECIOS */
IF pCodDiv <> COTIZACION.Libre_c01 THEN DO:
    MESSAGE 'NO se puede TRANSFERIR SALDO de una Cotización generada con otra lista de precios'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
pRowidS = ?.
MESSAGE '¿Procedemos a TRANSFERIR SALDOS?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF SHARED VAR cl-codcia AS INT.

DEF VAR s-coddoc LIKE Faccpedi.coddoc NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR s-codcia AS INT NO-UNDO.
DEF VAR s-coddiv AS CHAR NO-UNDO.

DEF VAR s-codmon AS INT.
DEF VAR s-CodCli AS CHAR.
DEF VAR s-porigv AS DEC.
DEF VAR s-cndvta AS CHAR.
DEF VAR s-tpocmb AS DEC.
DEF VAR s-nrodec AS INT.
DEF VAR s-tpoped AS CHAR.
DEF VAR s-flgigv AS LOG.
DEF VAR s-codalm AS CHAR.
DEF VAR S-NROPED AS CHAR.
DEF VAR S-CMPBNTE  AS CHAR.
DEF VAR s-import-ibc AS LOG.
DEF VAR s-import-cissac AS LOG.

ASSIGN
    s-TpoPed = COTIZACION.TpoPed
    s-CodAlm = COTIZACION.CodAlm
    S-CODMON = COTIZACION.CodMon
    S-CODCLI = COTIZACION.CodCli
    S-TPOCMB = COTIZACION.TpoCmb
    S-CNDVTA = COTIZACION.FmaPgo
    s-PorIgv = COTIZACION.porigv
    s-NroDec = (IF COTIZACION.Libre_d01 <= 0 THEN 2 ELSE COTIZACION.Libre_d01)
    s-FlgIgv = COTIZACION.FlgIgv
    s-nroped = COTIZACION.nroped
    S-CMPBNTE = COTIZACION.Cmpbnte.

DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.73
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR I-NITEM  AS INT NO-UNDO INIT 0.

ASSIGN
    s-coddoc = COTIZACION.coddoc
    s-nroser = INTEGER(SUBSTRING(COTIZACION.nroped,1,3))
    s-codcia = COTIZACION.codcia
    s-coddiv = COTIZACION.coddiv.

/* 
    Ic - 19Set2017, la fecha de entrega de la nueva cotizacion :
        Si la cotizacion fue procesada x Lucy = Ultima dia de proceso
        Si ya la cotizacion aun no fue procesada x Lucy = Ultima dia de proceso + 7
*/

DEFINE VAR lFechEnt AS DATE.
DEFINE VAR lFechVen AS DATE.

DEFINE BUFFER ic-vtatabla FOR vtatabla.

lFechEnt = TODAY + (COTIZACION.FchEnt - COTIZACION.FchPed).
lFechVen = TODAY + (COTIZACION.FchVen - COTIZACION.FchPed).

IF AVAILABLE cotizacion THEN DO:

    FIND FIRST ic-vtatabla WHERE ic-vtatabla.codcia = s-codcia AND 
                                ic-vtatabla.tabla = 'DSTRB' AND 
                                ic-vtatabla.llave_c1 = '2016' NO-LOCK NO-ERROR.
    IF AVAILABLE ic-vtatabla THEN DO:        
        IF CAPS(cotizacion.libre_c01) = 'PROCESADO' THEN DO:           
            lFechEnt = ic-vtatabla.rango_fecha[2].
            lFechVen = ic-vtatabla.rango_fecha[2] + 7.
        END.
        ELSE DO:
            lFechEnt = ic-vtatabla.rango_fecha[2] + 7.
            lFechVen = ic-vtatabla.rango_fecha[2] + 15.
        END.
    END.
END.
/* Ic - 19Set2017, la fecha de entrega */

DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    FIND CURRENT COTIZACION EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE COTIZACION THEN RETURN.

    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
    
    CREATE Faccpedi.
    BUFFER-COPY COTIZACION 
        TO Faccpedi
        ASSIGN 
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.FchEnt = lFechEnt                  /* TODAY + (COTIZACION.FchEnt - COTIZACION.FchPed) */
        FacCPedi.FchVen = lFechven                  /* TODAY + (COTIZACION.FchVen - COTIZACION.FchPed) */
        FacCPedi.FlgEst = "P"       /* APROBADO */
        FacCPedi.CodRef = COTIZACION.CodDoc
        FacCPedi.Nroref = COTIZACION.NroPed.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.

    ASSIGN 
        FacCPedi.Hora = STRING(TIME,"HH:MM").
    
    ASSIGN
        COTIZACION.FlgEst = "ST"
        COTIZACION.Glosa  = "SALDOS TRANSFERIDOS A LA " + Faccpedi.coddoc + ' ' + Faccpedi.nroped
        pRowidS = ROWID(FacCPedi).

    FOR EACH B-DPEDI OF COTIZACION NO-LOCK WHERE B-DPEDI.CanPed - B-DPEDI.CanAte > 0
        BY B-DPEDI.NroItm:
        CREATE Facdpedi.
        BUFFER-COPY B-DPEDI
            TO Facdpedi
            ASSIGN
            FacDPedi.coddoc = FacCPedi.coddoc
            FacDPedi.NroPed = FacCPedi.NroPed
            FacDPedi.FchPed = FacCPedi.FchPed
            FacDPedi.Hora   = FacCPedi.Hora 
            FacDPedi.FlgEst = FacCPedi.FlgEst
            FacDPedi.NroItm = I-NITEM
            Facdpedi.Canped = B-DPEDI.CanPed - B-DPEDI.CanAte
            Facdpedi.CanAte = 0.
    END.

    /* Recargamos y Recalculamos */
    EMPTY TEMP-TABLE ITEM.
    FOR EACH Facdpedi OF Faccpedi:
        CREATE ITEM.
        BUFFER-COPY Facdpedi TO ITEM.
        DELETE Facdpedi.
    END.
    {vta2/recalcularprecioscreditomay.i}
    FOR EACH ITEM:
        CREATE Facdpedi.
        BUFFER-COPY ITEM TO Facdpedi.
    END.

    {vta2/graba-totales-cotizacion-cred.i}

    FIND CURRENT COTIZACION NO-LOCK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


