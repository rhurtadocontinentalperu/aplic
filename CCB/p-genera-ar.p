&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-CcbCCaja FOR CcbCCaja.
DEFINE BUFFER b-FacCorre FOR FacCorre.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
      TABLE: b-CcbCCaja B "?" ? INTEGRAL CcbCCaja
      TABLE: b-FacCorre B "?" ? INTEGRAL FacCorre
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF SHARED VAR s-user-id AS CHAR.

DEF INPUT PARAMETER pRowid  AS ROWID.
DEF INPUT PARAMETER pCodMon AS INTE.

DEF OUTPUT PARAMETER pNroAR   AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND b-Ccbccaja WHERE ROWID(b-Ccbccaja) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-Ccbccaja THEN DO:
    pMensaje = "No pudo ubicar el I/C".
    RETURN 'ADM-ERROR'. 
END.

DEF VAR s-CodDoc AS CHAR INIT 'A/R' NO-UNDO.

DEFINE VAR x-serie-numero AS CHAR.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="b-FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="b-FacCorre.CodCia = b-Ccbccaja.codcia AND ~
        b-FacCorre.Coddiv = b-Ccbccaja.coddiv AND ~
        b-FacCorre.CodDoc = s-coddoc" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    ASSIGN
        x-serie-numero = STRING(b-FacCorre.nroser, "999") + STRING(b-FacCorre.correlativo, "999999").
    ASSIGN 
        b-FacCorre.Correlativo = b-FacCorre.Correlativo + 1.
    RELEASE b-FacCorre.

    CREATE CcbCDocu.
    ASSIGN
        CcbCDocu.Codcia = b-Ccbccaja.CODCIA
        CcbCDocu.CodDiv = b-Ccbccaja.CODDIV
        CcbCDocu.Coddoc = s-CODDOC
        CcbCDocu.NroDoc = x-serie-numero
        CcbCDocu.CodCli = b-CcbCcaja.Codcli
        CcbCDocu.NomCli = b-CcbCcaja.Nomcli
        CcbCDocu.CodRef = b-CcbCcaja.CodDoc
        CcbCDocu.NroRef = b-CcbCcaja.NroDoc
        CcbCDocu.fmapgo = b-CcbCcaja.Codcta[10]         /* Condicion de venta */
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = TODAY
        CcbCDocu.CodMon = pCODMON
        CcbCDocu.TpoCmb = b-CcbCcaja.TpoCmb
        CcbCDocu.Usuario = S-USER-ID            
        CcbCDocu.FlgEst = "P"
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error al genera el A/R".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        pNroAR = STRING(s-Coddoc,"X(3)") + CcbCDocu.NroDoc.

    IF pCodMon = 2 THEN DO:
        ASSIGN
            CcbCDocu.ImpTot = b-CcbCcaja.ImpUsa[1] + b-CcbCcaja.ImpUsa[4] .
            CcbCDocu.SdoAct = b-CcbCcaja.ImpUsa[1] + b-CcbCcaja.ImpUsa[4] .
    END.
    IF pCodMon = 1 THEN DO:
        ASSIGN
            CcbCDocu.ImpTot = b-CcbCcaja.ImpNac[1] + b-CcbCcaja.ImpNac[4] + b-ccbccaja.ImpNac[3]. /* Billetera electronica */
            CcbCDocu.SdoAct = b-CcbCcaja.ImpNac[1] + b-CcbCcaja.ImpNac[4] + b-ccbccaja.ImpNac[3]. /* Billetera electronica */
    END.
    RELEASE CcbCDocu.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


