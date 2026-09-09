&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : RedondearMas  
    Purpose     :

    Syntax      :

    Description : Redondea u número hacia arriba en dirección contraria al cero

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Sintaxis:
    
    RedondearMas (INPUT Número, INPUT Decimales, OUTPUT Resultado)
    
*/
DEF INPUT PARAMETER Numero AS DEC.
DEF INPUT PARAMETER Decimales AS INT.
DEF OUTPUT PARAMETER Resultado AS DEC.

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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR X AS INT INIT 1 NO-UNDO.
DEF VAR k AS INT NO-UNDO.

IF Decimales > 10 THEN Decimales = 10.
/* Contamos los decimales */
DO k = 1 TO Decimales:
    X = X * 10.
END.
/*X = 10000.*/
Resultado = ROUND(Numero * X, 0).
Resultado = ROUND(Resultado / X, Decimales).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


