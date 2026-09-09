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
DEFINE INPUT PARAMETER cLista  AS CHARACTER NO-UNDO.


DEFINE VARIABLE cLibrary AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTpoPln  AS INTEGER   NO-UNDO.
DEFINE VARIABLE cNomRep  AS CHARACTER NO-UNDO.

cLibrary = ENTRY(1, cLista ).
cTpoPln  = INTEGER( ENTRY(2, cLista ) ).
cNomRep  = ENTRY(3, cLista ).

DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
DEFINE VARIABLE db-work  AS CHARACTER NO-UNDO.
DEFINE VARIABLE db-model AS CHARACTER NO-UNDO.

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


/* ***************************  Main Block  *************************** */
  DEFINE VARIABLE L-OK AS LOGICAL.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    IF CONNECTED( "db-work")
    THEN DISCONNECT db-work.
    FILE-INFO:FILE-NAME = ".".
    db-model = FILE-INFO:FULL-PATHNAME + "/APLIC/pln/db-work".
      
    db-work = SESSION:TEMP-DIRECTORY + "PL-" +
                    STRING(NEXT-VALUE(sec-arc,integral)) + ".db".
  
    CREATE DATABASE db-work FROM db-model REPLACE.
    CONNECT VALUE( db-work ) -1 -ld db-work.
  END.  
  L-OK = NO.
  RUN pln/w-rpl-2.w( cLibrary, cTpoPln, TRUE, cNomRep, OUTPUT L-OK).
  
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
  IF CONNECTED( "db-work")  THEN DISCONNECT db-work.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


