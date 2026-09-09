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

/* PROGRAMA BASE QUE DISPARA EL PROGRAMA DE ACUERDO A LA CONFIGURACION
    DE LAS TABLAS 
*/

DEF VAR x-Sloting AS LOG INIT NO NO-UNDO.
DEF VAR x-BarrCode AS LOG INIT NO NO-UNDO.  /* YES Barrcode  NO Manual */

/* Buscamos la configuracion en las tablas */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

FIND FIRST TabGener WHERE TabGener.CodCia = s-CodCia
    AND TabGener.Clave = 'CFGINC'
    AND TabGener.Codigo = s-CodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    MESSAGE 'Hay un problema con la configuración de esta división' SKIP
        'Avisar a ABASTECIMIENTOS INTERNO' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    x-Sloting = TabGener.Libre_L03
    x-BarrCode = (IF TabGener.Libre_l01 = YES THEN YES ELSE NO).

CASE TRUE:
    WHEN x-Sloting = YES AND x-BarrCode = YES THEN RUN alm/w-chk-ingreso-dev-otr-v2.w ("BC").
    WHEN x-Sloting = YES AND x-BarrCode = NO  THEN RUN alm/w-chk-ingreso-dev-otr-v2.w ("M").
    WHEN x-Sloting = NO  AND x-BarrCode = YES THEN RUN alm/w-chk-ingreso-dev-otr.w ("BC").
    WHEN x-Sloting = NO  AND x-BarrCode = NO  THEN RUN alm/w-chk-ingreso-dev-otr.w ("M").
END CASE.

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
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


