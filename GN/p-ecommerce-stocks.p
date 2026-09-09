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
         HEIGHT             = 4.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodAlm AS CHAR.                                  
DEF INPUT PARAMETER pCodMat AS CHAR.

IF pCodAlm <> "506" THEN RETURN.    /* Solo almacén 506 e-commerce (lista express) */

DEF BUFFER B-MATE FOR Almmmate.

FIND B-MATE WHERE B-MATE.CodCia = pCodCia AND
    B-MATE.CodAlm = pCodAlm AND
    B-MATE.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATE THEN RETURN.

DEF VAR pComprometido AS DEC NO-UNDO.
RUN gn/stock-comprometido-v2.p (pCodMat, pCodAlm, NO, OUTPUT pComprometido).
REPEAT:
    FIND ecommerce.ec_stock_alm WHERE ecommerce.ec_stock_alm.CodCia = pCodCia AND 
        ecommerce.ec_stock_alm.CodAlm = pCodAlm AND
        ecommerce.ec_stock_alm.CodMat = pCodMat
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE ecommerce.ec_stock_alm THEN DO:
        IF NOT LOCKED ecommerce.ec_stock_alm THEN DO:
            CREATE ecommerce.ec_stock_alm.
            ASSIGN
                ecommerce.ec_stock_alm.CodAlm = pCodAlm
                ecommerce.ec_stock_alm.CodCia = pCodCia
                ecommerce.ec_stock_alm.CodMat = pCodMat
                ecommerce.ec_stock_alm.LogDate = TODAY
                ecommerce.ec_stock_alm.LogTime = STRING(TIME,'HH:MM:SS')
                .
        END.
        ELSE UNDO, RETRY.
    END.
    ASSIGN
        ecommerce.ec_stock_alm.StkAct = B-MATE.StkAct
        ecommerce.ec_stock_alm.Reservado = pComprometido.
    RELEASE ecommerce.ec_stock_alm.
    LEAVE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


