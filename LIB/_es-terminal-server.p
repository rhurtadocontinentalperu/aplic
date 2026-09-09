&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : _es-terminal-server.p
    Purpose     : Determina si la session de Progress esta en TERMINAL SERVER 

    Syntax      : RUN lib/_es-terminal-server(output pRetval).

    Description : pRetVal = YES, si la session es TERMINAL SERVER

    Author(s)   : Cesar Iman
    Created     : 19mar2018
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/*------------------------------------------------------------------------------
  Purpose   :                  
  Parameters:  
  Notes     :  
                
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pRetVal AS LOG NO-UNDO.

DEFINE VAR lClientComputerName  AS CHAR.
DEFINE VAR lClientName          AS CHAR.
DEFINE VAR lComputerName        AS CHAR.
DEFINE VAR lRemote-user         AS CHAR.
DEFINE VAR lUserName            AS CHAR.
DEFINE VAR lxClientName         AS CHAR.
DEFINE VAR lTerminalServer AS CHAR.

pRetVal = NO.

lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME").
lClientName         = OS-GETENV ( "CLIENTNAME").
lComputerName       = OS-GETENV ( "COMPUTERNAME").
lRemote-user        = OS-GETENV ( "REMOTE_USER").
lUserName           = OS-GETENV ( "USERNAME").

lxClientName        = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lxClientName        = IF (CAPS(lxClientName) = "CONSOLE") THEN "" ELSE lxClientName.
lxClientName        = IF (lxClientName = ? OR lxClientName = "") THEN lComputerName ELSE lxClientName.

lTerminalServer = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lTerminalServer = IF (TRIM(lTerminalServer) = ?) THEN "" ELSE TRIM(lTerminalServer).   /* Vacio:OE, NOVacio:TerminalServer */

pRetVal = IF(lTerminalServer = "") THEN NO ELSE YES.



/*
MESSAGE "PCRemoto    = " lFiler SKIP
        "PCCliente   = " lComputerName.
*/

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


