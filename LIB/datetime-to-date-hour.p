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

DEF INPUT PARAMETER pdDateTime AS DATETIME NO-UNDO.
DEF OUTPUT PARAMETER pdTime AS DATE NO-UNDO.
DEF OUTPUT PARAMETER pcHour AS CHAR NO-UNDO.

pdTime = DATE(pdDateTime).

DEF VAR iSegundosTotal AS INTEGER NO-UNDO.
DEF VAR iHora          AS INTEGER NO-UNDO.
DEF VAR iMinuto        AS INTEGER NO-UNDO.
DEF VAR iSegundo       AS INTEGER NO-UNDO.

/* 1. MTIME extrae los milisegundos desde la medianoche y los pasamos a segundos */
iSegundosTotal = TRUNCATE(MTIME(pdDateTime) / 1000, 0).

/* 2. Desglosamos las porciones de tiempo */
iHora    = TRUNCATE(iSegundosTotal / 3600, 0).
iMinuto  = TRUNCATE((iSegundosTotal MOD 3600) / 60, 0).
iSegundo = iSegundosTotal MOD 60.

/* 3. Concatenamos usando formato numérico de dos dígitos "99" */
pcHour = STRING(iHora, "99") + ":" + 
    STRING(iMinuto, "99") + ":" + 
    STRING(iSegundo, "99").

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


