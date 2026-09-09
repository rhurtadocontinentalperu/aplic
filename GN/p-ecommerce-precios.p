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
         HEIGHT             = 3.77
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pPreNew AS DEC.
DEF INPUT PARAMETER pPreOld AS DEC.
DEF INPUT PARAMETER pOrigen AS CHAR.
DEF INPUT PARAMETER pTpoCmb AS DEC.
DEF INPUT PARAMETER pMonVta AS INT.
DEF INPUT PARAMETER pUser-Id AS CHAR.

IF pPreNew = pPreOld THEN RETURN.
IF TRUE <> (pCodMat > '') THEN RETURN.

/* Conectar la base de datos primero */
CREATE ecommerce.ec_precios.
ASSIGN
    ecommerce.ec_precios.CodCia = pCodCia
    ecommerce.ec_precios.CodMat = pCodMat
    ecommerce.ec_precios.FlagFechaHora = NOW
    ecommerce.ec_precios.FlagMigracion = "N"
    ecommerce.ec_precios.FlagUsuario = pUser-Id
    ecommerce.ec_precios.LogDate = TODAY
    ecommerce.ec_precios.LogTime = STRING(TIME,'HH:MM:SS')
    ecommerce.ec_precios.LogUser = pUser-Id
    ecommerce.ec_precios.TpoCmb = pTpoCmb
    ecommerce.ec_precios.MonVta = pMonVta
    ecommerce.ec_precios.Origen = pOrigen.

DEF BUFFER B-ListaMinGn FOR INTEGRAL.VtaListaMinGn.
DEF BUFFER B-ListaMay FOR INTEGRAL.VtaListaMay.

DEF VAR x-PreUtilex LIKE B-ListaMinGn.PreOfi.
DEF VAR x-Pre506    LIKE B-ListaMay.PreOfi.
CASE pOrigen:
    WHEN "E" THEN DO:   /* El origen es la lista de precio 00506 de la tabla vtalistamay */
        ecommerce.ec_precios.PreOfi506 = pPreNew.
        FIND B-ListaMinGn WHERE B-ListaMinGn.CodCia = pCodCia AND 
            B-ListaMinGn.codmat = pCodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-ListaMinGn THEN DO:
            x-PreUtilex = B-ListaMinGn.PreOfi.
            IF B-ListaMinGn.MonVta = 2 THEN x-PreUtilex = x-PreUtilex * B-ListaMinGn.TpoCmb.
            ecommerce.ec_precios.PreOfiUtilex = x-PreUtilex.
        END.
    END.
    WHEN "U" THEN DO:   /* El origen es la lista de precio UTILEX de la tabla vtalistamingn */
        ecommerce.ec_precios.PreOfiUtilex = pPreNew.
        FIND B-ListaMay WHERE B-ListaMay.CodCia = pCodCia AND
            B-ListaMay.CodDiv = "00506" AND
            B-ListaMay.CodMat = pCodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-ListaMay THEN ecommerce.ec_precios.PreOfi506 = B-ListaMay.PreOfi.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


