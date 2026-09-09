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
         HEIGHT             = 3.08
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE INPUT  PARAMETER Fecha-Ingreso AS DATE.
DEFINE INPUT  PARAMETER Fecha-Cese    AS DATE.
DEFINE OUTPUT PARAMETER ANOS          AS INTEGER.
DEFINE OUTPUT PARAMETER MESES         AS INTEGER.
DEFINE OUTPUT PARAMETER DIAS          AS INTEGER.

DEF VAR x-Fecha-1 AS DATE.
DEF VAR x-Fecha-2 AS DATE.
DEF VAR x-Fecha   AS DATE.
DEF VAR DIAS-XX AS INT.

 ASSIGN
    x-Fecha-1 = Fecha-Ingreso + 1
    x-Fecha-2 = Fecha-Cese
    ANOS = 0
    MESES = 0
    DIAS = 0.

/* 1ro. diferencia a 30 dias */
IF MONTH(x-Fecha-1) = MONTH(x-Fecha-2) AND YEAR(x-Fecha-1) = YEAR(x-Fecha-2)
THEN DO:
    DIAS = x-Fecha-2 - x-Fecha-1 + 1.
    RETURN.
END.
DIAS = 30 - DAY(x-Fecha-1) + 1.
/* 2do. pasamos al siguiente mes */
x-Fecha = x-Fecha-1.
VUELTA:
REPEAT:
    IF MONTH(x-Fecha) < 12
    THEN x-Fecha = DATE(MONTH(x-Fecha) + 1, 01, YEAR(x-Fecha)).
    ELSE x-Fecha = DATE(01, 01, YEAR(x-Fecha) + 1).
    IF MONTH(x-Fecha) = MONTH(x-Fecha-2) AND YEAR(x-Fecha) = YEAR(x-Fecha-2)
    THEN DO:
        DIAS = DIAS + DAY(x-Fecha-2).
        LEAVE VUELTA.
    END.
    ELSE DIAS = DIAS + 30.
END.
IF DIAS > 30 THEN DO:
    MESES = ( DIAS - (DIAS MODULO 30) ) / 30.
    DIAS = DIAS - (MESES * 30).
END.    
IF MESES > 12 THEN DO:
    ANOS = ( MESES - (MESES MODULO 12) ) / 12.
    MESES = MESES - (ANOS * 12).
END.

/*    
DO x-Fecha = x-Fecha-1 TO x-Fecha-2:
    DIAS = DIAS + 1.
    IF x-Fecha <> x-Fecha-1 THEN DO:
        CASE (MONTH(x-Fecha)):
          WHEN 2 
            THEN DIAS-XX = IF ( YEAR(FECHA-CESE) MODULO 4 ) = 0 THEN 29 ELSE 28.
          WHEN 1 OR WHEN 3 OR WHEN 5 OR WHEN 7 OR WHEN 8 OR WHEN 10 OR WHEN 12
            THEN DIAS-XX = 31.
          OTHERWISE           
                 DIAS-XX = 30.
        END CASE.
        IF DAY(x-Fecha-1) > DIAS-XX THEN DO:
            IF DAY(x-Fecha) = DIAS-XX
            THEN ASSIGN
                    DIAS = 0
                    MESES = MESES + 1.
        END.
        ELSE
            IF DAY(x-Fecha) = DAY(x-Fecha-1) 
            THEN ASSIGN
                    DIAS = 0
                    MESES = MESES + 1.
    END.
END.
IF MESES >= 12
THEN DO:
    ANOS = TRUNCATE(MESES / 12, 0).
    MESES = MESES - ( ANOS * 12 ).
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


