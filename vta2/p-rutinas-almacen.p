&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Librerias generales para actualizar el almacén x facturación

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE SHARED VAR s-user-id AS CHAR.

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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-act_alm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE act_alm Procedure 
PROCEDURE act_alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-ROWID AS ROWID.
DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = "".

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN "OK".

/* PEDIDO MOSTRADOR YA HA DESCARGADO STOCK EN CAJA */
IF CcbCDocu.CodDoc = "G/R" AND CcbCDocu.CodPed = "P/M" THEN RETURN "OK".
IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,TCK') = 0 THEN RETURN "OK".

DEF VAR s-NroSer AS INT NO-UNDO.
DEF VAR s-NroDoc AS INT64 NO-UNDO.

ASSIGN
    s-NroSer = 0
    s-NroDoc = 0.
FIND gn-divi WHERE gn-divi.codcia = ccbcdocu.codcia 
    AND gn-divi.coddiv = ccbcdocu.coddiv
    NO-LOCK NO-ERROR.                                                                    
/* ************************************************************************** */
/* RHC 17/08/2015 RUTINA GENERAL: SOLO FAC BOL GENERAN MOVIMIENTOS DE ALMACEN */
/* ************************************************************************** */
ASSIGN 
    s-NroSer = INTEGER(SUBSTRING(Ccbcdocu.nrodoc,1,3)).
CASE Ccbcdocu.coddoc:
    WHEN 'FAC' THEN s-NroDoc = 10000000.
    WHEN 'BOL' THEN s-NroDoc = 30000000.
END CASE.
s-NroDoc = s-NroDoc + INTEGER(SUBSTRING(Ccbcdocu.nrodoc,4)).

DEF VAR i               AS INTEGER INITIAL 1    NO-UNDO.
DEF VAR LocalCounter    AS INTEGER INITIAL 0    NO-UNDO.
DEF VAR x-CorrSal       LIKE Almacen.CorrSal    NO-UNDO.

pMensaje = ''.
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.implin >= 0
        BREAK BY Ccbddocu.AlmDes:
        IF FIRST-OF(Ccbddocu.AlmDes) THEN DO:
            CREATE almcmov.
            ASSIGN Almcmov.CodCia  = CcbDDocu.CodCia 
                   Almcmov.CodAlm  = CcbDDocu.AlmDes
                   Almcmov.TipMov  = "S"
                   Almcmov.CodMov  = 02     
                   Almcmov.NroSer  = s-NroSer
                   Almcmov.NroDoc  = s-NroDoc 
                   Almcmov.FchDoc  = CcbCDocu.FchDoc
                   Almcmov.HorSal  = STRING(TIME, "HH:MM:SS")
                   Almcmov.CodVen  = ccbcdocu.CodVen
                   Almcmov.CodCli  = ccbcdocu.CodCli
                   Almcmov.Nomref  = ccbcdocu.NomCli
                   Almcmov.CodRef  = ccbcdocu.CodDoc
                   Almcmov.NroRef  = ccbcdocu.nrodoc
                   Almcmov.NroRf1  = CcbCDocu.CodDoc + CcbCDocu.NroDoc
                   Almcmov.NroRf2  = CcbCDocu.CodPed + CcbCDocu.NroPed
                   Almcmov.usuario = s-user-id
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                RUN show-errors (OUTPUT pMensaje).
                UNDO PRINCIPAL, LEAVE PRINCIPAL.
            END.
        END.
        /* DETALLE */
        CREATE Almdmov.
        ASSIGN 
            Almdmov.CodCia = Almcmov.CodCia
            Almdmov.CodAlm = Almcmov.CodAlm
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroSer = almcmov.nroser
            Almdmov.NroDoc = almcmov.nrodoc
            Almdmov.AftIgv = ccbddocu.aftigv
            Almdmov.AftIsc = ccbddocu.aftisc
            Almdmov.CanDes = ccbddocu.candes
            Almdmov.codmat = ccbddocu.codmat
            Almdmov.CodMon = ccbcdocu.codmon
            Almdmov.CodUnd = ccbddocu.undvta
            Almdmov.Factor = ccbddocu.factor
            Almdmov.FchDoc = CcbCDocu.FchDoc
            Almdmov.ImpDto = ccbddocu.impdto
            Almdmov.ImpIgv = ccbddocu.impigv
            Almdmov.ImpIsc = ccbddocu.impisc
            Almdmov.ImpLin = ccbddocu.implin
            Almdmov.NroItm = i
            Almdmov.PorDto = ccbddocu.pordto
            Almdmov.PreBas = ccbddocu.prebas
            Almdmov.PreUni = ccbddocu.preuni
            Almdmov.TipMov = "S"
            Almdmov.TpoCmb = ccbcdocu.tpocmb
            Almcmov.TotItm = i
            Almdmov.HraDoc = Almcmov.HorSal
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            RUN show-errors (OUTPUT pMensaje).
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
        ASSIGN i = i + 1.
        RUN alm/almdcstk (ROWID(almdmov)).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "NO se pudo descargar el almacén".
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
        /* RHC 05.04.04 ACTIVAMOS KARDEX POR ALMACEN */
        RUN alm/almacpr1 (ROWID(almdmov), 'U').
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "NO se pudo actualizar el kardex de almacén".
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
    END.
END.
IF AVAILABLE(Almacen) THEN RELEASE Almacen.
IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
IF pMensaje <> "" THEN DO:
    /*MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR TITLE "ERROR actualizando el almacén".*/
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-show-errors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-errors Procedure 
PROCEDURE show-errors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pMensaje AS CHAR.

    DEFINE VARIABLE        cntr                  AS INTEGER   NO-UNDO.

    pMensaje = ''.
    DO cntr = 1 TO ERROR-STATUS:NUM-MESSAGES:
        pMensaje = pMensaje + (IF pMensaje > '' THEN CHR(10) ELSE '') +
                    ERROR-STATUS:GET-MESSAGE(cntr) .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

