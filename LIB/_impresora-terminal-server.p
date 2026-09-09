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

DEFINE INPUT-OUTPUT PARAMETER pNombreImpresora AS CHAR.
DEFINE OUTPUT PARAMETER pPuertoImpresora AS CHAR.

/* Impresora Terminal Server */
DEFINE VARIABLE mpPrinterEnum   AS MEMPTR       NO-UNDO.
DEFINE VARIABLE iFlags          AS INTEGER      NO-UNDO.
DEFINE VARIABLE cName           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iLevel          AS INTEGER      NO-UNDO.
DEFINE VARIABLE ipcbNeeded      AS INTEGER      NO-UNDO.
DEFINE VARIABLE ipcReturned     AS INTEGER      NO-UNDO.
DEFINE VARIABLE iResult         AS INTEGER      NO-UNDO.

DEFINE VARIABLE xPrinterTS           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE xPrinterName           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE xPrinterPort           AS CHARACTER    NO-UNDO.


&GLOBAL-DEFINE PRINTER_INFO_1_SIZE 16
&GLOBAL-DEFINE PRINTER_INFO_2_SIZE 84

&IF PROVERSION < '8' &THEN  /* OE 10+ */

    &IF PROVERSION >= '11.3' &THEN   /* PROCESS-ARCHITECTURE function is available */
    
        &IF PROCESS-ARCHITECTURE = 32 &THEN /* 32-bit pointers */
            &GLOBAL-DEFINE POINTERTYPE 'LONG'
            &GLOBAL-DEFINE POINTERBYTES 4
            MESSAGE '11.3+ 32-bit' VIEW-AS ALERT-BOX.
        &ELSEIF PROCESS-ARCHITECTURE = 64 &THEN /* 64-bit pointers */
            &GLOBAL-DEFINE POINTERTYPE 'INT64'
            &GLOBAL-DEFINE POINTERBYTES 8 
            /* MESSAGE '11.3+ 64-bit' VIEW-AS ALERT-BOX. */
        &ENDIF  /* PROCESS-ARCHITECTURE */
        
    &ELSE   /* Can't check architecture pre-11.3 so default to 32-bit */
        &GLOBAL-DEFINE POINTERTYPE 'LONG'
        &GLOBAL-DEFINE POINTERBYTES 4
        /*MESSAGE 'pre-11.3 -- defaulting to 32-bit' VIEW-AS ALERT-BOX.*/

        /* TTY 10.2A - 11.2 client might be 64-bit, so alert user if not in batch mode.
            Batch mode clients cannot respond to alert, but messages will appear in
            standard output to aid in debugging if code is run on wrong platform. */
        &IF PROVERSION >= '10.2A' &THEN
        
            &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                MESSAGE
                    'WARNING: Defaulting to 32-bit printer enumeration' SKIP
                    'This procedure will not operate correctly in an OpenEdge'
                    PROVERSION '64-bit client' SKIP 'Proceed?'
                    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lProceed AS LOGICAL.
                IF NOT lProceed THEN QUIT.
                /*MESSAGE 'Proceeding...' VIEW-AS ALERT-BOX.*/
            &ENDIF  /* WINDOW-SYSTEM */
            
        &ENDIF  /* PROVERSION > 10.2A */
        
    &ENDIF  /* PROVERSION > 11.3 */
    
&ELSE   /* pre-OE10 always 32-bit on Windows */
    /*MESSAGE 'pre-OE10 -- defaulting to 32-bit' VIEW-AS ALERT-BOX.*/
    &GLOBAL-DEFINE POINTERTYPE 'LONG'
    &GLOBAL-DEFINE POINTERBYTES 4
&ENDIF  /* PROVERSION < 8 */

&GLOBAL-DEFINE PRINTER_ENUM_LOCAL       2
&GLOBAL-DEFINE PRINTER_ENUM_CONNECTIONS 4
&GLOBAL-DEFINE PRINTER_ENUM_REMOTE      16
&GLOBAL-DEFINE PRINTER_ENUM_NAME        8
 
&GLOBAL-DEFINE PRINTER_INFO_1           1
&GLOBAL-DEFINE PRINTER_INFO_2           2

xPrinterName = "".
xPrinterPort = "".

iFlags = 0.
/*
iFlags = iFlags + {&PRINTER_ENUM_CONNECTIONS}. /* Connected Printers */
*/

iFlags = iFlags + {&PRINTER_ENUM_LOCAL}.   /* Impresora locales */

xPrinterTS = pNombreImpresora.
cName   = "".
iLevel  = 2.

pNombreImpresora = "".
pPuertoImpresora = "".

RUN enumeratePrinters.

pNombreImpresora = xPrinterName.
pPuertoImpresora = xPrinterPort.

/*
IF xPrinterName <> "" THEN DO:
    MESSAGE xPrinterName xPrinterPort.
END.
ELSE DO:
    MESSAGE "Ninguna impresora se detecto".
END.
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
         HEIGHT             = 5.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-enumerateprinters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enumerateprinters Procedure 
PROCEDURE enumerateprinters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* Get the correct size of the mpPrinterEnum buffer needed */
SET-SIZE(mpPrinterEnum)= 1.
 
RUN EnumPrintersA(
    INPUT iFlags,
    INPUT cName,
    INPUT iLevel,
    INPUT-OUTPUT mpPrinterEnum,
    INPUT GET-SIZE(mpPrinterEnum),
    OUTPUT ipcbNeeded,
    OUTPUT ipcReturned,
    OUTPUT iResult).
 
IF ipcbNeeded > 0 THEN
DO:
    /* Set the correct size of the mpPrinterEnum buffer as needed */
    SET-SIZE(mpPrinterEnum)= 0.  
    SET-SIZE(mpPrinterEnum)= ipcbNeeded.
 
    /* Get printer information into the mpPrinterEnum buffer */
    RUN EnumPrintersA(
        INPUT iFlags,
        INPUT cName,
        INPUT iLevel,
        INPUT-OUTPUT mpPrinterEnum,
        INPUT GET-SIZE(mpPrinterEnum),
        OUTPUT ipcbNeeded,
        OUTPUT ipcReturned,
        OUTPUT iResult).
END.
ELSE                       
    /*MESSAGE 'There are no printers or servers of this type to display'
        VIEW-AS ALERT-BOX*/.
 
/* Display printer information from the structure that was returned. */
IF iLevel = 2 THEN
    RUN valida-impresora.
ELSE
    /*RUN display_PRINTER_INFO_1.*/
     
END PROCEDURE.
 
PROCEDURE EnumPrintersA EXTERNAL "winspool.drv":
/*------------------------------------------------------------------------------
  Purpose:     External call to Windows Print Spooler API
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     DEFINE INPUT PARAMETER Flags AS LONG.
     DEFINE INPUT PARAMETER Name  AS CHARACTER.
     DEFINE INPUT PARAMETER Level AS LONG.
     DEFINE INPUT-OUTPUT PARAMETER pPrinterEnum AS MEMPTR.
     DEFINE INPUT PARAMETER cdBuf AS LONG.
     DEFINE OUTPUT PARAMETER pcbNeeded AS LONG.
     DEFINE OUTPUT PARAMETER pcReturned AS LONG.
     DEFINE RETURN PARAMETER iResult  AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valida-impresora) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-impresora Procedure 
PROCEDURE valida-impresora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iCounter        AS INTEGER  NO-UNDO.
DEFINE VARIABLE mpPrinterInfo2  AS MEMPTR   NO-UNDO.
DEFINE VARIABLE mBuffer         AS MEMPTR   NO-UNDO.

DEFINE VARIABLE cServerName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPrinterName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cShareName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPortName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDriverName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cComment     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLocation    AS CHARACTER  NO-UNDO.


SET-SIZE(mBuffer) ={&PRINTER_INFO_2_SIZE}.
DO iCounter = 0 TO ipcReturned - 1:
    SET-POINTER-VALUE(mpPrinterInfo2) = GET-POINTER-VALUE(mpPrinterEnum) +
        (iCounter * {&PRINTER_INFO_2_SIZE} ).

    SET-POINTER-VALUE(mBuffer) = GET-LONG(mpPrinterInfo2,1).
    cServerName = GET-STRING(mBuffer,1) NO-ERROR.

    SET-POINTER-VALUE(mBuffer) = GET-LONG(mpPrinterInfo2,5).
    cPrinterName = GET-STRING(mBuffer,1) NO-ERROR.

    SET-POINTER-VALUE(mBuffer) = GET-LONG(mpPrinterInfo2,9).
    cShareName = GET-STRING(mBuffer,1) NO-ERROR.
    
    SET-POINTER-VALUE(mBuffer) = GET-LONG(mpPrinterInfo2,13).
    cPortName = GET-STRING(mBuffer,1) NO-ERROR.
   
    SET-POINTER-VALUE(mBuffer) = GET-LONG(mpPrinterInfo2,17).
    cDriverName = GET-STRING(mBuffer,1) NO-ERROR.

    SET-POINTER-VALUE(mBuffer) = GET-LONG(mpPrinterInfo2,21).
    cComment = GET-STRING(mBuffer,1) NO-ERROR.
    
    SET-POINTER-VALUE(mBuffer) = GET-LONG(mpPrinterInfo2,25).
    cLocation = GET-STRING(mBuffer,1) NO-ERROR.

    /*
    MESSAGE
        "Server Name:" "~t" cServerName "~n"
        "Printer Name:" "~t" cPrinterName "~n"
        "Share Name:" "~t" cShareName "~n"
        "Port Name:" "~t" cPortName "~n"
        "Driver Name:" "~t" cDriverNAME "~n"
        "Comment:" "~t" cComment "~n"
        "Location:" "~t" cLocation "~n"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     */

    IF INDEX(cPrinterName,xPrinterTS) > 0 THEN DO:
        xPrinterName = cPrinterName.
        xPrinterPort = cPortName.                        
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

