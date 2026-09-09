&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 xselectionlist BUTTON-1 chbticket ~
cboTipoDoc txtnrodoc BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS xselectionlist txtOS txt-print-name ~
txt-printer-hdc txt-print-port txt-printer-control-handle chbticket ~
cboTipoDoc txtnrodoc txtImpte 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Impresoras" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Imprimir" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE cboTipoDoc AS CHARACTER FORMAT "X(45)":U INITIAL "BOL" 
     LABEL "Tipo Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "BOLETA","BOl",
                     "FACTURA","FAC"
     DROP-DOWN-LIST
     SIZE 15 BY .92 NO-UNDO.

DEFINE VARIABLE txt-print-name AS CHARACTER FORMAT "X(256)":U 
     LABEL "Print Name" 
     VIEW-AS FILL-IN 
     SIZE 47.29 BY 1 NO-UNDO.

DEFINE VARIABLE txt-print-port AS CHARACTER FORMAT "X(256)":U 
     LABEL "Port" 
     VIEW-AS FILL-IN 
     SIZE 47.29 BY 1 NO-UNDO.

DEFINE VARIABLE txt-printer-control-handle AS CHARACTER FORMAT "X(256)":U 
     LABEL "Control Handler" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE txt-printer-hdc AS CHARACTER FORMAT "X(256)":U 
     LABEL "HDC" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE txtImpte AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE txtnrodoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE txtOS AS CHARACTER FORMAT "X(256)":U 
     LABEL "S.O." 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 4.04.

DEFINE VARIABLE xselectionlist AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 92 BY 10.38 NO-UNDO.

DEFINE VARIABLE chbticket AS LOGICAL INITIAL yes 
     LABEL "Imprimir en Ticketera" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     xselectionlist AT ROW 1.77 COL 3 NO-LABEL WIDGET-ID 2
     txtOS AT ROW 13.31 COL 8 COLON-ALIGNED WIDGET-ID 6
     txt-print-name AT ROW 13.31 COL 40.72 COLON-ALIGNED WIDGET-ID 14
     txt-printer-hdc AT ROW 14.58 COL 8 COLON-ALIGNED WIDGET-ID 8
     txt-print-port AT ROW 14.58 COL 40.72 COLON-ALIGNED WIDGET-ID 12
     txt-printer-control-handle AT ROW 16 COL 16 COLON-ALIGNED WIDGET-ID 10
     BUTTON-1 AT ROW 16.38 COL 74 WIDGET-ID 4
     chbticket AT ROW 18.88 COL 43 WIDGET-ID 26
     cboTipoDoc AT ROW 19 COL 20 COLON-ALIGNED WIDGET-ID 18
     txtnrodoc AT ROW 20.54 COL 14 COLON-ALIGNED WIDGET-ID 20
     txtImpte AT ROW 20.54 COL 46 COLON-ALIGNED WIDGET-ID 22
     BUTTON-2 AT ROW 20.54 COL 72 WIDGET-ID 24
     "..." VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 12.35 COL 80 WIDGET-ID 30
     RECT-1 AT ROW 18.31 COL 3 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95.43 BY 22.19 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Lista de Impresoras"
         HEIGHT             = 22.31
         WIDTH              = 95.43
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txt-print-name IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-print-port IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-printer-control-handle IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-printer-hdc IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtImpte IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtOS IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Lista de Impresoras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Lista de Impresoras */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Impresoras */
DO:
  
    DEFINE VAR x-sec AS INT.

    REPEAT x-sec = 1 TO xselectionlist:NUM-ITEMS:
            xselectionlist:DELETE(x-sec).
    END.

    xPrinterName = "".
    xPrinterPort = "".

    iFlags = 0.
    /*
    iFlags = iFlags + {&PRINTER_ENUM_CONNECTIONS}. /* Connected Printers */
    */

    iFlags = iFlags + {&PRINTER_ENUM_LOCAL}.   /* Impresora locales */

    xPrinterTS = "".
    cName   = "".
    iLevel  = 2.

    

    RUN enumeratePrinters.

    RUN show-attributos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Imprimir */
DO:
  IF xPrinterName = "" THEN DO:
      MESSAGE "Seleccione Impresor por favor".
      RETURN NO-APPLY.
  END.


  DEFINE VAR x-coddoc AS CHAR.
  DEFINE VAR x-nrodoc AS CHAR.

  ASSIGN cbotipodoc.

  x-coddoc = cbotipodoc.
  x-nrodoc = txtnrodoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

   txtImpte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(-99.00).

  FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND 
                            ccbcdocu.coddoc = x-coddoc AND
                            ccbcdocu.nrodoc = x-nrodoc NO-LOCK NO-ERROR.

  IF AVAILABLE ccbcdocu THEN DO:

      ASSIGN chbticket.

      txtImpte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ccbcdocu.imptot,"->,>>>,>>9.99").


      RUN sunat/r-impresion-doc-electronico(INPUT ccbcdocu.coddiv, 
                                            INPUT ccbcdocu.coddoc,
                                            INPUT ccbcdocu.nrodoc,
                                            INPUT 'O',
                                            INPUT chbticket,
                                            INPUT YES,
                                            INPUT  xPrinterName).

  END.
  ELSE DO:
      MESSAGE "Documento NO EXISTE".
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtnrodoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtnrodoc wWin
ON LEAVE OF txtnrodoc IN FRAME fMain /* Numero */
DO:
  DEFINE VAR x-coddoc AS CHAR.
  DEFINE VAR x-nrodoc AS CHAR.

  ASSIGN cbotipodoc.

  x-coddoc = cbotipodoc.
  x-nrodoc = txtnrodoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

   txtImpte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(-99.00).

  FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND 
                            ccbcdocu.coddoc = x-coddoc AND
                            ccbcdocu.nrodoc = x-nrodoc NO-LOCK NO-ERROR.

  IF AVAILABLE ccbcdocu THEN DO:
      txtImpte:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(ccbcdocu.imptot,"->,>>>,>>9.99").
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME xselectionlist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL xselectionlist wWin
ON MOUSE-SELECT-DBLCLICK OF xselectionlist IN FRAME fMain
DO:

  DEFINE VAR x-filer1 AS CHAR.
  DEFINE VAR x-filer2 AS CHAR.
  DEFINE VAR x-filer3 AS CHAR.

  x-filer3 =  xSelectionList:SCREEN-VALUE.

  x-filer1  = ENTRY(1,x-filer3,"|").
  /*x-filer2  = ENTRY(2,x-filer3,"|").*/

  xPrinterName = x-filer1.
  /*xPrinterPort = x-filer2.*/

  /*OUTPUT TO PRINTER VALUE(xPrinterName).*/

  RUN show-attributos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-impresoras wWin 
PROCEDURE carga-impresoras :
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

    xselectionlist:ADD-LAST(cPrinterName + " | " + cPortName) IN FRAME {&FRAME-NAME}.

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

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY xselectionlist txtOS txt-print-name txt-printer-hdc txt-print-port 
          txt-printer-control-handle chbticket cboTipoDoc txtnrodoc txtImpte 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-1 xselectionlist BUTTON-1 chbticket cboTipoDoc txtnrodoc BUTTON-2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enumerateprinters wWin 
PROCEDURE enumerateprinters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
                                                             
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
    RUN carga-impresoras.
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

*/

DEFINE VAR x-impresoras AS LONGCHAR.
DEFINE VAR x-sec AS INT.
DEFINE VAR x-printer AS CHAR.

x-impresoras = SESSION:GET-PRINTERS().

REPEAT x-sec = 1 TO NUM-ENTRIES(x-impresoras,","):
    x-printer = ENTRY(x-sec,x-impresoras,",").
    /*MESSAGE x-printer.*/
    xselectionlist:ADD-LAST(x-printer) IN FRAME {&FRAME-NAME}.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-attributos wWin 
PROCEDURE show-attributos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

txtos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SESSION:WINDOW-SYSTEM.
txt-printer-hdc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(SESSION:PRINTER-HDC).
txt-printer-control-handle:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(SESSION:PRINTER-CONTROL-HANDLE).
txt-print-name:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SESSION:PRINTER-NAME.
txt-print-port:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SESSION:PRINTER-PORT.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

