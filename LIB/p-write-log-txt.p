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

DEFINE INPUT PARAMETER pProceso AS CHAR.
DEFINE INPUT PARAMETER pTexto AS CHAR.

DEFINE VAR cProceso AS CHAR.

/*DEFINE BUFFER x-factabla FOR factabla.*/

DEFINE STREAM sFileTxt.
define stream log-epos.     /* Trama del ePOS */

cProceso = pProceso.
cProceso = REPLACE(cProceso," ","").
cProceso = REPLACE(cProceso,"/","").

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

/* IP de la PC */
DEFINE VAR x-ip AS CHAR.
DEFINE VAR x-pc AS CHAR.

RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

/* ---- */
DEFINE VAR lClientComputerName  AS CHAR.
DEFINE VAR lClientName          AS CHAR.
DEFINE VAR lComputerName        AS CHAR.

DEFINE VAR lPCName AS CHAR.
 
lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME"). 
lClientName         = OS-GETENV ( "CLIENTNAME").
lComputerName       = OS-GETENV ( "COMPUTERNAME").

lPcName = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lPCName = IF (CAPS(lPCName) = "CONSOLE") THEN "" ELSE lPCName.
lPCName = IF (lPCName = ? OR lPCName = "") THEN lComputerName ELSE lPCName.

/* ------ */
DEFINE VAR x-archivo AS CHAR.
DEFINE VAR x-file AS CHAR.
DEFINE VAR x-linea AS CHAR.

x-file = STRING(TODAY,"99/99/9999").

x-file = REPLACE(x-file,"/","").
x-file = REPLACE(x-file,":","").

IF SESSION:WINDOW-SYSTEM = "TTY" THEN DO:
    IF lPCName = ? THEN lPCName = "SERVER/LINUX".
END.
IF lPCName = ? THEN lPCName = "...".

x-archivo = session:TEMP-DIRECTORY + "LOG-" + cProceso + "-" + x-file + ".txt".

OUTPUT STREAM log-epos TO VALUE(x-archivo) APPEND.

x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " (" + lPCName + "-" + x-pc + ":" + x-ip + ") - " + TRIM(pTexto).

PUT STREAM log-epos x-linea FORMAT 'x(300)' SKIP.

OUTPUT STREAM LOG-epos CLOSE.


RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


