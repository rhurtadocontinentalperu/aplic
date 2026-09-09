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

DEF INPUT PARAMETER pLineas AS CHAR.
DEF OUTPUT PARAMETER pFmaPgo AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INTE.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
pFmaPgo = ''.
FOR EACH VtaTabla NO-LOCK WHERE VtaTabla.CodCia = s-codcia 
    AND VtaTabla.Tabla = 'CONFIG-VTAS'
    AND VtaTabla.Llave_c1 = 'COND.VTA-LINEA-PLAZO'
    AND VtaTabla.Llave_c6 = "ACTIVO"
    AND (TODAY >= VtaTabla.Rango_fecha[1] AND TODAY <= VtaTabla.Rango_fecha[2])
    AND LOOKUP(TRIM(VtaTabla.Llave_c3), pLineas) > 0,
    FIRST gn-ConVt NO-LOCK WHERE gn-ConVt.Codig = VtaTabla.Llave_c2:
    IF TRUE <> (pFmaPgo > '') THEN pFmaPgo = VtaTabla.Llave_c2.
    ELSE DO:
        IF LOOKUP(TRIM(VtaTabla.Llave_c2), pFmaPgo) = 0 
            THEN pFmaPgo = pFmaPgo + ',' + VtaTabla.Llave_c2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


