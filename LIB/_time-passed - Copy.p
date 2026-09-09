&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Calcula el tiempo transcurrido 

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

DEF INPUT PARAMETER pTimeFirst AS DATETIME.
DEF INPUT PARAMETER pTimeLast  AS DATETIME.
DEF OUTPUT PARAMETER pTimeCharacter AS CHAR.


DEF VAR Ts AS INT NO-UNDO.
DEF VAR Tm AS INT NO-UNDO.
DEF VAR Th AS INT NO-UNDO.


Ts = ( pTimeLast - pTimeFirst ) / 1000.     /* En segundos */
Th = TRUNCATE(Ts / 3600, 0).                /* En horas */
Ts = Ts - ( Th * 3600 ).                    /* Segundos remanentes */
Tm = TRUNCATE(Ts / 60, 0).                  /* En minutos */
Ts = Ts - ( Tm * 60 ).                      /* Segundos remanentes */

IF Th > 0 THEN pTimeCharacter = STRING(Th, '>>9') + ' hora' + (IF Th <> 1 THEN 's ' ELSE ' ').
IF Tm > 0 THEN pTimeCharacter = pTimeCharacter + STRING(Tm, '>9') + ' minuto' + (IF Tm <> 1 THEN 's ' ELSE ' ').
IF Ts > 0 THEN pTimeCharacter = pTimeCharacter + STRING(Ts, '>9') + ' segundo' + (IF Ts <> 1 THEN 's' ELSE '').
/*                                                                                                           
pTimeCharacter = STRING(Th, '>>9') + ' hora' + (IF Th <> 1 THEN 's ' ELSE ' ') +
                STRING(Tm, '>9') + ' minuto' + (IF Tm <> 1 THEN 's ' ELSE ' ') +
                STRING(Ts, '>9') + ' segundo' + (IF Ts <> 1 THEN 's' ELSE '').
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


