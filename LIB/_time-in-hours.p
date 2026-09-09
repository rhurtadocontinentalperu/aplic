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
         HEIGHT             = 4.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pTimeInSeconds AS DEC.
DEF OUTPUT PARAMETER pTimeCharacter AS CHAR.


DEF VAR Ts AS INT NO-UNDO.
DEF VAR Tm AS INT NO-UNDO.
DEF VAR Th AS INT NO-UNDO.
DEF VAR Td AS INT NO-UNDO.


Ts = pTimeInSeconds.                            /* En segundos */
Td = TRUNCATE(Ts / 86400, 0).                   /* En dias */
Ts = Ts - ( Td * 86400 ).                       /* Segundos remanentes */
Th = TRUNCATE(Ts / 3600, 0).                    /* En horas */
Ts = Ts - ( Th * 3600 ).                        /* Segundos remanentes */
Tm = TRUNCATE(Ts / 60, 0).                      /* En minutos */
Ts = Ts - ( Tm * 60 ).                          /* Segundos remanentes */

IF Td > 0 THEN pTimeCharacter = STRING(Td, '>>9') + 'd ' .
IF Th > 0 THEN pTimeCharacter = pTimeCharacter + STRING(Th, '>>9') + 'h ' .
IF Tm > 0 THEN pTimeCharacter = pTimeCharacter + STRING(Tm, '>9') + 'm ' .
IF Ts > 0 THEN pTimeCharacter = pTimeCharacter + STRING(Ts, '>9') + 's' .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


