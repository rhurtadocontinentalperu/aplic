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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* CALCULO DE LA CANTIDAD DE REPOSICION */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pVentaDiaria AS DEC.
DEF OUTPUT PARAMETER pReposicion AS DEC.

FIND Almmmate WHERE ROWID(Almmmate) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN RETURN.

FIND Almcfggn WHERE Almcfggn.codcia = Almmmate.codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN RETURN.

DEF VAR x-Reposicion-1 AS DEC NO-UNDO.
DEF VAR x-Reposicion-2 AS DEC NO-UNDO.

x-Reposicion-1 = AlmCfgGn.DiasMaximo * pVentaDiaria - Almmmate.StkAct.
/*x-Reposicion-2 = Almmmate.StkMax - Almmmate.StkAct.*/
x-Reposicion-2 = DECIMAL(Almmmate.Libre_c03) - Almmmate.StkAct.

IF x-Reposicion-1 <= 0 
THEN pReposicion = x-Reposicion-2.
ELSE pReposicion = MINIMUM(x-Reposicion-1, x-Reposicion-2).

/* Redondeamos a enteros */
IF pReposicion <> TRUNCATE(pReposicion, 0)
THEN pReposicion = TRUNCATE(pReposicion, 0) + 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


