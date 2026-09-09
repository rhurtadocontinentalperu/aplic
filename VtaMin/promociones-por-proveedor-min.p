&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* PROMOCIONES PARA PEDIDOS CREDITO MINORISTA */
/* NO VERIFICAMOS STOCK */

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-codcia AS INT.

FIND FacCPedi WHERE ROWID(FacCPedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN.
IF LOOKUP (FacCPedi.FmaPgo, '900,999') > 0 THEN RETURN.

DEF TEMP-TABLE Detalle
    FIELD codmat LIKE FacDPedi.codmat
    FIELD canped LIKE FacDPedi.canped
    FIELD implin LIKE FacDPedi.implin
    FIELD impmin AS DEC         /* Importes y cantidades minimas */
    FIELD canmin AS DEC.

DEF TEMP-TABLE Promocion LIKE FacDPedi.

DEF VAR x-ImpLin AS DEC.
DEF VAR x-CanDes AS DEC.
DEF VAR x-ImpMin AS DEC.
DEF VAR x-CanMin AS DEC.
DEF VAR x-Factor AS INT.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE SW-LOG1  AS LOGI NO-UNDO.
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.
DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

/* Barremos las promociones activas */
{vta2/promociones-por-proveedor.i}

/* Cargamos las promociones al pedido */
i-nItem = 0.
FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    i-nItem = i-nItem + 1.
END.

FOR EACH Promocion, FIRST Almmmatg OF Promocion NO-LOCK:
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedi.
    BUFFER-COPY Promocion TO FacDPedi
    ASSIGN
        FacDPedi.CodCia = FacCPedi.CodCia
        FacDPedi.coddoc = FacCPedi.coddoc
        FacDPedi.NroPed = FacCPedi.NroPed
        FacDPedi.FchPed = FacCPedi.FchPed
        FacDPedi.Hora   = FacCPedi.Hora 
        FacDPedi.FlgEst = FacCPedi.FlgEst
        FacDPedi.NroItm = I-NITEM
        FacDPedi.CanPick = FacDPedi.CanPed.   /* OJO */
    RELEASE FacDPedi.
END.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


