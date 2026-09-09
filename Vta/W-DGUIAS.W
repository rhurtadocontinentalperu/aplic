&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEF SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

/* Definimos Variables de impresoras */
DEFINE VARIABLE s-printer-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-name AS CHAR format "x(20)" NO-UNDO.
DEFINE VARIABLE s-printer-count AS INTEGER NO-UNDO.
DEFINE NEW SHARED VARIABLE s-pagina-final     AS INTEGER.
DEFINE NEW SHARED VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE NEW SHARED VARIABLE s-salida-impresion AS INTEGER.
DEFINE NEW SHARED VARIABLE s-printer-name     AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-print-file       AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-nro-copias       AS INTEGER.
DEFINE NEW SHARED VARIABLE s-orientacion      AS INTEGER.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE C-FLGEST AS CHAR NO-UNDO.
DEFINE STREAM REPORT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-40 Btn_OK C-Condic Fechad fechah ~
Btn_Cancel numeroh numerod 
&Scoped-Define DISPLAYED-OBJECTS C-Condic Fechad fechah numeroh numerod 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 2
     BGCOLOR 8 .

DEFINE VARIABLE C-Condic AS CHARACTER FORMAT "X(256)":U 
     LABEL "Condicion" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos ","Pendientes","Facturados","Anulados" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE Fechad AS DATE FORMAT "99/99/9999":U 
     LABEL "Periodo desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE fechah AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE numerod AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documentos del" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE numeroh AS CHARACTER FORMAT "X(256)":U 
     LABEL "al" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.43 BY 5.65.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_OK AT ROW 2.12 COL 50
     C-Condic AT ROW 2.5 COL 17.86 COLON-ALIGNED
     Fechad AT ROW 4.31 COL 16.72 COLON-ALIGNED
     fechah AT ROW 4.31 COL 33.57 COLON-ALIGNED
     Btn_Cancel AT ROW 4.62 COL 50
     numeroh AT ROW 5.96 COL 33.72 COLON-ALIGNED
     numerod AT ROW 6 COL 16.72 COLON-ALIGNED
     "  Ingrese parametros" VIEW-AS TEXT
          SIZE 14.72 BY .62 AT ROW 1.42 COL 5
          BGCOLOR 1 FGCOLOR 15 
     RECT-40 AT ROW 1.65 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.43 BY 6.62
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Resumen de Guias"
         HEIGHT             = 6.65
         WIDTH              = 62.29
         MAX-HEIGHT         = 6.65
         MAX-WIDTH          = 62.43
         VIRTUAL-HEIGHT     = 6.65
         VIRTUAL-WIDTH      = 62.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen de Guias */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen de Guias */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN C-Condic fechad fechah numerod numeroh.
  IF C-Condic = "Todos" THEN C-FlgEst = "".
  ELSE C-FlgEst = SUBSTRING(C-Condic,1,1).
  IF numeroh = "" THEN numeroh = "999999999".
  If fechad > fechah then do:
     Message "Rango de fechas mal ingresado" view-as alert-box.
     APPLY "ENTRY":U to fechad.
     RETURN NO-APPLY.
  END.

  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY C-Condic Fechad fechah numeroh numerod 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-40 Btn_OK C-Condic Fechad fechah Btn_Cancel numeroh numerod 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR x-ImpMn1 AS DECIMAL FORMAT ">>>,>>>,>>>9.99" COLUMN-LABEL "Importe S/.".
 DEFINE VAR x-ImpMn2 AS DECIMAL FORMAT ">>>,>>>,>>>9.99" COLUMN-LABEL "Importe US$".
 DEFINE FRAME f-cab
        CcbCDocu.NroDoc 
        CcbCDocu.NroPed 
        CcbCDocu.NroRef COLUMN-LABEL "Factura"
        CcbCDocu.FchDoc
        Gn-Clie.NomCli  FORMAT "X(40)"
        x-ImpMn1
        x-ImpMn2
        HEADER
        S-NOMCIA
        "RESUMEN DE GUIAS" TO 75
        "PAGINA : " TO 100 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "DESDE : " FechaD  " AL " FechaH
        "FECHA : " TO 100 TODAY SKIP(2)
         WITH WIDTH 165 NO-BOX STREAM-IO DOWN.
 
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL CHR(27) "@" CHR(27) "C" CHR(66) CHR(18) CHR(27) "M".
 
 FOR EACH CcbCDocu NO-LOCK WHERE
          CcbCDocu.CodCia = S-CODCIA AND
          CcbCDocu.CodDoc = "G/R" AND
          CcbCDocu.FchDoc >= FechaD AND
          CcbCDocu.FchDoc <= FechaH AND
          CcbCDocu.NroDoc >= NumeroD AND
          CcbCDocu.NroDoc <= NumeroH AND
          CcbCDocu.FlgEst BEGINS C-FlgEst
     BREAK BY CcbCDocu.CodCia
            BY CcbCDocu.CodCli
             BY CcbCDocu.FchDoc:
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
          gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
     IF CcbCDocu.CodMon = 1 THEN 
        ASSIGN x-ImpMn1 = CcbCDocu.ImpTot
               x-ImpMn2 = ROUND(CcbCDocu.ImpTot / CcbCDocu.TpoCmb,2).
     ELSE
        ASSIGN x-ImpMn1 = ROUND(CcbCDocu.ImpTot * CcbCDocu.TpoCmb,2)
               x-ImpMn2 = CcbCDocu.ImpTot.
     DISPLAY STREAM REPORT 
            CcbCDocu.NroDoc 
            CcbCDocu.NroPed 
            CcbCDocu.NroRef 
            CcbCDocu.FchDoc
            Gn-Clie.NomCli 
            x-ImpMn1 
            x-ImpMn2 WITH FRAME F-Cab.
     ACCUMULATE x-ImpMn1 (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE x-ImpMn2 (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE x-ImpMn1 (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE x-ImpMn2 (SUB-TOTAL BY CcbCDocu.CodCli).
     IF LAST-OF(CcbCDocu.CodCli) THEN DO:
        DISPLAY STREAM REPORT 
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) x-ImpMn1 @ x-ImpMn1
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) x-ImpMn2 @ x-ImpMn2
                WITH FRAME F-Cab.
        DOWN 1.
     END.
     IF LAST-OF(CcbCDocu.CodCia) THEN DO:
        DISPLAY STREAM REPORT 
                ACCUM TOTAL BY (CcbCDocu.CodCia) x-ImpMn1 @ x-ImpMn1
                ACCUM TOTAL BY (CcbCDocu.CodCia) x-ImpMn2 @ x-ImpMn2
                WITH FRAME F-Cab.
        DOWN 1.
     END.
 END.
 PAGE STREAM REPORT.
 OUTPUT STREAM REPORT CLOSE.
 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file). 
 END CASE. 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
  
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  RUN Formato.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN 
      FechaD:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - DAY(TODAY) + 1).
      fechaH:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

