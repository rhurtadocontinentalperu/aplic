&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT  PARAMETER FECHA-INGRESO  AS DATE.
DEFINE INPUT  PARAMETER FECHA-CESE     AS DATE.
DEFINE OUTPUT PARAMETER MESES          AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* RUTINA PARA DETERMINAR LOS MESES COMPLETOS TRABAJADOS PARA EL PAGO 
    DE GRATIFICACIONES TRUNCAS */
/* ***************************  Main Block  *************************** */
DEF VAR x-FchIng AS DATE.
DEF VAR x-FchCse AS DATE.

ASSIGN
    x-FchIng = FECHA-INGRESO
    x-FchCse = FECHA-CESE.

DEF VAR x-Fecha AS DATE.
DEF VAR x-Dias  AS INT INIT 0 NO-UNDO.
DEF VAR x-Meses AS INT INIT 0 NO-UNDO.
DEF VAR x-Flag  AS LOG INIT NO NO-UNDO.
DEF VAR x-DiasMes  AS INT INIT 0 NO-UNDO.

DO x-Fecha = x-FchIng TO x-FchCse:
    IF DAY(x-Fecha) = 01 
    THEN ASSIGN x-Flag = YES.
    IF MONTH(x-Fecha) <> MONTH(x-Fecha + 1) AND x-Flag = YES
    THEN ASSIGN x-Meses = x-Meses + 1
                x-Flag = NO.
END.
MESES = x-Meses.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


