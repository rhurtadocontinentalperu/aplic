&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
DEFINE SHARED VARIABLE s-pagina-final     AS INTEGER.
DEFINE SHARED VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE SHARED VARIABLE s-salida-impresion AS INTEGER.
DEFINE SHARED VARIABLE s-printer-name     AS CHARACTER.
DEFINE SHARED VARIABLE s-printer-port     AS CHARACTER.
DEFINE SHARED VARIABLE s-print-file       AS CHARACTER.
DEFINE SHARED VARIABLE s-nro-copias       AS INTEGER.
DEFINE SHARED VARIABLE s-orientacion      AS INTEGER.

DEFINE VARIABLE cPrinter-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPort-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPrinter-count AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

ASSIGN
    s-printer-name = ""
    s-printer-port = ""
    s-print-file = "".
IF s-nro-copias <= 0 THEN s-nro-copias = 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-8 Btn-down-3 RECT-7 IMAGE-1 RECT-6 ~
R-salida COMBO-print R-rango FILL-IN-copias Btn_OK Btn_Cancel Btn-up-3 
&Scoped-Define DISPLAYED-OBJECTS R-salida COMBO-print FILL-IN-archivo ~
R-rango FILL-IN-pagini FILL-IN-pagfin FILL-IN-copias 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-archivos 
     IMAGE-UP FILE "img\pvpegar":U
     LABEL "&Arc..." 
     SIZE 3.57 BY 1.

DEFINE BUTTON Btn-down-1 
     IMAGE-UP FILE "img\b-down":U NO-FOCUS
     LABEL "" 
     SIZE 1.86 BY .5.

DEFINE BUTTON Btn-down-2 
     IMAGE-UP FILE "img\b-down":U NO-FOCUS
     LABEL "" 
     SIZE 1.86 BY .5.

DEFINE BUTTON Btn-down-3 
     IMAGE-UP FILE "img\b-down":U NO-FOCUS
     LABEL "" 
     SIZE 1.86 BY .5.

DEFINE BUTTON Btn-up-1 
     IMAGE-UP FILE "img\b-up":U NO-FOCUS
     LABEL "" 
     SIZE 1.86 BY .5.

DEFINE BUTTON Btn-up-2 
     IMAGE-UP FILE "img\b-up":U NO-FOCUS
     LABEL "" 
     SIZE 1.86 BY .5.

DEFINE BUTTON Btn-up-3 
     IMAGE-UP FILE "img\b-up":U NO-FOCUS
     LABEL "" 
     SIZE 1.86 BY .5.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-print AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-archivo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81
     BGCOLOR 15 FGCOLOR 0 FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-copias AS INTEGER FORMAT "ZZ9":U INITIAL 1 
     LABEL "Número de copias" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .81
     BGCOLOR 15 FGCOLOR 0 FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-pagfin AS INTEGER FORMAT "ZZZZ9":U INITIAL 1 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .81
     BGCOLOR 15 FGCOLOR 0 FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-pagini AS INTEGER FORMAT "ZZZZ9":U INITIAL 1 
     LABEL "De" 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .81
     BGCOLOR 15 FGCOLOR 0 FONT 2 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "img\continental":U
     SIZE 48 BY 3.65.

DEFINE VARIABLE R-rango AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo", 1,
"Paginas", 2
     SIZE 8.72 BY 1.58 NO-UNDO.

DEFINE VARIABLE R-salida AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 1,
"Impresora", 2,
"Archivo", 3
     SIZE 11 BY 3.23 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 2.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 2.5.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 5.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn-down-1 AT ROW 9.15 COL 23.29
     Btn-down-2 AT ROW 9.15 COL 33.57
     Btn-down-3 AT ROW 9.15 COL 58.57
     R-salida AT ROW 3.69 COL 4 NO-LABEL
     COMBO-print AT ROW 5.23 COL 13 COLON-ALIGNED NO-LABEL
     Btn-up-1 AT ROW 8.69 COL 23.29
     Btn-archivos AT ROW 6 COL 59
     FILL-IN-archivo AT ROW 6.19 COL 13 COLON-ALIGNED NO-LABEL
     R-rango AT ROW 8.12 COL 4 NO-LABEL
     FILL-IN-pagini AT ROW 8.77 COL 15 COLON-ALIGNED
     FILL-IN-pagfin AT ROW 8.77 COL 25.29 COLON-ALIGNED
     Btn-up-2 AT ROW 8.69 COL 33.57
     FILL-IN-copias AT ROW 8.77 COL 52 COLON-ALIGNED
     Btn_OK AT ROW 10.42 COL 38
     Btn_Cancel AT ROW 10.42 COL 52
     Btn-up-3 AT ROW 8.69 COL 58.57
     " Salida a:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.19 COL 4
     " Copias:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 7.35 COL 41
     " Rango de Impresión:" VIEW-AS TEXT
          SIZE 15.14 BY .5 AT ROW 7.35 COL 4
     RECT-8 AT ROW 1.38 COL 2
     RECT-7 AT ROW 7.54 COL 39
     IMAGE-1 AT ROW 1.58 COL 15
     RECT-6 AT ROW 7.54 COL 2
     SPACE(27.99) SKIP(1.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 FONT 4
         TITLE "Imprimir"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn-archivos IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn-down-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn-down-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn-up-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn-up-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-pagfin IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-pagini IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Imprimir */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-archivos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-archivos D-Dialog
ON CHOOSE OF Btn-archivos IN FRAME D-Dialog /* Arc... */
DO:
    SYSTEM-DIALOG GET-FILE FILL-IN-archivo
    FILTERS
        "Archivo Impresión (*.txt)" "*.txt"
    ASK-OVERWRITE CREATE-TEST-FILE
    DEFAULT-EXTENSION 'txt'
    RETURN-TO-START-DIR SAVE-AS
    TITLE   "Archivo(s) de Impresión..."
    USE-FILENAME
    UPDATE OKpressed.
    IF OKpressed = TRUE THEN FILL-IN-archivo:SCREEN-VALUE = FILL-IN-archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-down-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-down-1 D-Dialog
ON CHOOSE OF Btn-down-1 IN FRAME D-Dialog
DO:
    IF INPUT R-rango = 1 THEN RETURN.
    IF INPUT FILL-IN-pagini - 1 <= 0 THEN RETURN NO-APPLY.
    ELSE DISPLAY INPUT FILL-IN-pagini - 1 @ FILL-IN-pagini WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-down-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-down-2 D-Dialog
ON CHOOSE OF Btn-down-2 IN FRAME D-Dialog
DO:
    IF INPUT R-rango = 1 THEN RETURN.
    IF INPUT FILL-IN-pagfin - 1 <= 0 THEN RETURN NO-APPLY.
    ELSE DISPLAY INPUT FILL-IN-pagfin - 1 @ FILL-IN-pagfin WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-down-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-down-3 D-Dialog
ON CHOOSE OF Btn-down-3 IN FRAME D-Dialog
DO:
    IF INPUT R-salida <> 2 THEN RETURN.
    IF INPUT FILL-IN-copias - 1 <= 0 THEN RETURN NO-APPLY.
    ELSE DISPLAY INPUT FILL-IN-copias - 1 @ FILL-IN-copias WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-up-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-up-1 D-Dialog
ON CHOOSE OF Btn-up-1 IN FRAME D-Dialog
DO:
    IF INPUT R-rango = 1 THEN RETURN.
    IF INPUT FILL-IN-pagini + 1 > 99999 THEN RETURN NO-APPLY.
    ELSE DISPLAY INPUT FILL-IN-pagini + 1 @ FILL-IN-pagini WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-up-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-up-2 D-Dialog
ON CHOOSE OF Btn-up-2 IN FRAME D-Dialog
DO:
    IF INPUT R-rango = 1 THEN RETURN.
    IF INPUT FILL-IN-pagfin + 1 > 99999 THEN RETURN NO-APPLY.
    ELSE DISPLAY INPUT FILL-IN-pagfin + 1 @ FILL-IN-pagfin WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-up-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-up-3 D-Dialog
ON CHOOSE OF Btn-up-3 IN FRAME D-Dialog
DO:
    IF INPUT R-salida <> 2 THEN RETURN.
    IF INPUT FILL-IN-copias + 1 > 999 THEN RETURN NO-APPLY.
    ELSE DISPLAY INPUT FILL-IN-copias + 1 @ FILL-IN-copias WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
    ASSIGN s-salida-impresion = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:

    ASSIGN
        R-salida
        R-rango
        COMBO-print
        FILL-IN-copias
        FILL-IN-pagini
        FILL-IN-pagfin
        FILL-IN-archivo.

    IF R-rango = 1 THEN
        ASSIGN
            s-pagina-inicial = 1
            s-pagina-final   = 999999.
    ELSE
        ASSIGN
            s-pagina-inicial = FILL-IN-pagini
            s-pagina-final   = FILL-IN-pagfin.

    CASE R-Salida:
        WHEN 3 THEN DO:
            IF FILL-IN-archivo = "" THEN DO:
                BELL.
                MESSAGE "Ingrese nombre del archivo de impresión"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO FILL-IN-archivo.
                RETURN NO-APPLY.
            END.
        END.
    END CASE.

    IF COMBO-print <> "" THEN DO:
        s-printer-port = ENTRY(LOOKUP(COMBO-print,cPrinter-list),cPort-list).
        s-printer-name = COMBO-print.
    END.

    ASSIGN
        FILL-IN-archivo:SCREEN-VALUE = FILL-IN-archivo
        s-salida-impresion           = R-salida
        s-print-file                 = FILL-IN-archivo
        s-nro-copias                 = FILL-IN-copias
        s-orientacion                = 1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-archivo D-Dialog
ON ANY-PRINTABLE OF FILL-IN-archivo IN FRAME D-Dialog
DO:
    IF R-INDEX( "abcdefghijklmn¤opqrstuvwxyz1234567890:./\\" ,
        CAPS( CHR( LASTKEY ) ) ) = 0 THEN DO:  
        BELL.
        RETURN NO-APPLY.
    END.
    APPLY CAPS(CHR(LASTKEY)).
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-rango
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-rango D-Dialog
ON VALUE-CHANGED OF R-rango IN FRAME D-Dialog
DO:
    IF INPUT R-rango = 1 THEN
        ASSIGN
            FILL-IN-pagfin:SENSITIVE = FALSE
            FILL-IN-pagini:SENSITIVE = FALSE
            Btn-down-1:SENSITIVE     = FALSE
            Btn-down-2:SENSITIVE     = FALSE
            Btn-up-1:SENSITIVE       = FALSE
            Btn-up-2:SENSITIVE       = FALSE.
    ELSE
        ASSIGN
            FILL-IN-pagfin:SENSITIVE = TRUE
            FILL-IN-pagini:SENSITIVE = TRUE
            Btn-down-1:SENSITIVE     = TRUE
            Btn-down-2:SENSITIVE     = TRUE
            Btn-up-1:SENSITIVE       = TRUE
            Btn-up-2:SENSITIVE       = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-salida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-salida D-Dialog
ON VALUE-CHANGED OF R-salida IN FRAME D-Dialog
DO:
    ASSIGN
        Btn-archivos:SENSITIVE    = TRUE
        FILL-IN-archivo:SENSITIVE = TRUE
        FILL-IN-copias:SENSITIVE  = TRUE
        Btn-down-3:SENSITIVE      = FALSE
        Btn-up-3:SENSITIVE        = FALSE.

  CASE INPUT R-Salida:
    WHEN 1 THEN DO:
        ASSIGN
            COMBO-print:SENSITIVE     = TRUE
            Btn-archivos:SENSITIVE    = FALSE
            FILL-IN-Archivo:SENSITIVE = FALSE
            FILL-IN-Copias:SENSITIVE  = FALSE.
        DISPLAY 1 @ FILL-IN-Copias WITH FRAME {&FRAME-NAME}.
    END.
    WHEN 2 THEN DO:
        ASSIGN
            COMBO-print:SENSITIVE     = TRUE
            Btn-archivos:SENSITIVE    = FALSE
            FILL-IN-archivo:SENSITIVE = FALSE
            Btn-down-3:SENSITIVE      = TRUE
            Btn-up-3:SENSITIVE        = TRUE.
        DISPLAY s-nro-copias @ FILL-IN-Copias WITH FRAME {&FRAME-NAME}.
    END.
    WHEN 3 THEN DO:
        ASSIGN
            COMBO-print:SENSITIVE     = FALSE
            FILL-IN-Copias:SENSITIVE  = FALSE.
        DISPLAY 1 @ FILL-IN-Copias WITH FRAME {&FRAME-NAME}.
    END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY R-salida COMBO-print FILL-IN-archivo R-rango FILL-IN-pagini 
          FILL-IN-pagfin FILL-IN-copias 
      WITH FRAME D-Dialog.
  ENABLE RECT-8 Btn-down-3 RECT-7 IMAGE-1 RECT-6 R-salida COMBO-print R-rango 
         FILL-IN-copias Btn_OK Btn_Cancel Btn-up-3 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:

    RUN aderb/_prlist(
        OUTPUT cPrinter-list,
        OUTPUT cPort-list,
        OUTPUT iPrinter-count).

    IF iPrinter-count = 0 THEN DO:
        MESSAGE
            "No existen impresoras configuradas"
            VIEW-AS ALERT-BOX WARNING.
    END.
    ELSE DO:
        DO iPrinter-count = 1 TO NUM-ENTRIES(cPrinter-list):
            lOk = COMBO-print:ADD-LAST(ENTRY(iPrinter-count,cPrinter-list)).
        END.
        COMBO-print = ENTRY(1,COMBO-print:LIST-ITEMS).
        s-printer-port = ENTRY(1,cPort-list).
        DISPLAY COMBO-print.
    END.
    APPLY 'VALUE-CHANGED':U TO R-salida.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

