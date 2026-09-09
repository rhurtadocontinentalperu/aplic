&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

DEFINE        VAR C-OP     AS CHAR.
/*DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.*/

DEFINE VAR F-STKGEN  AS DECIMAL NO-UNDO.
/*DEFINE VAR F-STKALM  AS DECIMAL NO-UNDO.*/
DEFINE VAR F-VALCTO  AS DECIMAL NO-UNDO.
DEFINE VAR F-PRECTO  AS DECIMAL NO-UNDO.
DEFINE VAR C-MONEDA  AS CHARACTER FORMAT "X(20)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.
DEFINE BUFFER T-MATE FOR Almmmate.

DEFINE VARIABLE x-cierre AS DATE NO-UNDO FORMAT "99/99/9999".

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
&Scoped-Define ENABLED-OBJECTS RECT-57 Zona-D Zona-H R-STOCK R-TIPO Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS Zona-D F-DesZonD Zona-H F-DesZonH R-STOCK ~
R-TIPO 

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
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE F-DesZonD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesZonH AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69 NO-UNDO.

DEFINE VARIABLE Zona-D AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zona Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE Zona-H AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zona Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE R-STOCK AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Con Stock", 1,
"Sin Stock", 2,
"Todos", 3
     SIZE 12 BY 1.88 NO-UNDO.

DEFINE VARIABLE R-TIPO AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 14.57 BY 1.81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 9.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Zona-D AT ROW 2.5 COL 16.86 COLON-ALIGNED
     F-DesZonD AT ROW 2.5 COL 27.86 COLON-ALIGNED NO-LABEL
     Zona-H AT ROW 3.31 COL 16.86 COLON-ALIGNED
     F-DesZonH AT ROW 3.31 COL 27.86 COLON-ALIGNED NO-LABEL
     R-STOCK AT ROW 4.5 COL 44 NO-LABEL WIDGET-ID 2
     R-TIPO AT ROW 4.54 COL 18.72 NO-LABEL
     Btn_OK AT ROW 10.31 COL 43.86
     Btn_Cancel AT ROW 10.31 COL 56.29
     "Estado" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.88 COL 10.29
          FONT 1
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5
          FONT 6
     RECT-57 AT ROW 1.19 COL 1
     RECT-46 AT ROW 10.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.29 BY 11.5
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
         TITLE              = "Listado de Marbetes"
         HEIGHT             = 10.92
         WIDTH              = 68.29
         MAX-HEIGHT         = 11.5
         MAX-WIDTH          = 68.29
         VIRTUAL-HEIGHT     = 11.5
         VIRTUAL-WIDTH      = 68.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN F-DesZonD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesZonH IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Listado de Marbetes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Listado de Marbetes */
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
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN Zona-D Zona-H R-tipo R-STOCK.
  
  IF Zona-H = "" THEN Zona-H = "ZZZZZZZZZZZ".

END.

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
  DISPLAY Zona-D F-DesZonD Zona-H F-DesZonH R-STOCK R-TIPO 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 Zona-D Zona-H R-STOCK R-TIPO Btn_OK Btn_Cancel 
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
DEFINE VARIABLE buena AS CHARACTER INITIAL "______________" FORMAT "X(14)" NO-UNDO.
DEFINE VARIABLE deter AS CHARACTER INITIAL "______________" FORMAT "X(14)" NO-UNDO.
DEFINE VARIABLE total AS CHARACTER INITIAL "______________" FORMAT "X(14)" NO-UNDO.
DEFINE VARIABLE x-zona AS CHARACTER NO-UNDO.

   FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                        AND  InvConfig.CodAlm = S-CODALM 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE InvConfig THEN ASSIGN x-cierre = InvConfig.FchInv.


  DEFINE FRAME F-FOOTER
      HEADER
      SKIP(2)
      "    -----------------       -----------------       -----------------"  AT 15 SKIP
      "         Conteo                  Reconteo               Supervisor   "  AT 15 SKIP
     WITH PAGE-BOTTOM WIDTH 180 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.
  
  DEFINE FRAME F-REPORTE
         SPACE(5)
         Almmmate.CodUbi COLUMN-LABEL "Zona" FORMAT "X(6)"
         Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(8)"
         Almmmatg.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(40)"
         Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(16)"
         Almmmatg.UndStk COLUMN-LABEL "UNI!med"
         buena
         deter
         total
        WITH WIDTH 180 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.

FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA
                   AND Almmmate.CodAlm = S-CODALM
                   AND  (Almmmate.CodUbi >= Zona-D
                   AND   Almmmate.CodUbi <= Zona-H)
                   AND (r-Stock = 3 OR r-Stock = 1 AND Almmmate.stkact > 0 OR r-Stock = 2 AND Almmmate.stkact = 0),
      FIRST Almmmatg OF Almmmate WHERE
                       Almmmatg.TpoArt BEGINS R-tipo NO-LOCK 
                  BREAK BY Almmmate.CodCia
                        BY Almmmate.CodAlm
                        BY Almmmate.CodUbi
                        BY Almmmate.CodMat:
    DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      
    x-zona = Almmmate.CodUbi.
    
    DEFINE FRAME F-HEADER
           HEADER
           S-NOMCIA AT 6 FORMAT "X(50)" SKIP
           "PRODUCTOS PARA INVENTARIAR - ZONA : " + TRIM(x-zona) AT 40 FORMAT "X(50)"
           "Pagina : " TO 113 PAGE-NUMBER(REPORT) TO 123 FORMAT "ZZZZZ9" SKIP
           "PTO.:" AT 5 S-DESALM AT 11 FORMAT "X(40)"
           " Fecha : " TO 113 TODAY TO 123 FORMAT "99/99/9999" SKIP
           "CIERRE DE INVENTARIO AL : " + TRIM(STRING(x-cierre, "99/99/9999")) AT 40 FORMAT "X(39)"
           "  Hora : " TO 113 STRING(TIME,"HH:MM:SS") TO 123 SKIP
           "     -------------------------------------------------------------------------------------------------------------------------" SKIP
           "     ZONA   CODIGO                                                             UNI    CANTIDAD        CANTIDAD      CANTIDAD  " SKIP
           "            PRODUCTO   D E S C R I P C I O N                  MARCA            BAS      BUENA        DETERIORADA      TOTAL   " SKIP
           "     -------------------------------------------------------------------------------------------------------------------------" SKIP
          WITH PAGE-TOP WIDTH 180 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.
      
    VIEW STREAM REPORT FRAME F-HEADER.
    VIEW STREAM REPORT FRAME F-FOOTER.
    DISPLAY STREAM REPORT 
             Almmmate.CodUbi
             Almmmatg.codmat 
             Almmmatg.DesMat 
             Almmmatg.DesMar
             Almmmatg.UndStk 
             buena
             deter
             total
             WITH FRAME F-REPORTE.
    IF LAST-OF(Almmmate.codubi) THEN DO:
        PAGE STREAM REPORT.
        HIDE STREAM REPORT FRAME F-FOOTER.
    END.
    IF LAST-OF(Almmmate.codcia) THEN DO:
        PAGE STREAM REPORT.
        HIDE STREAM REPORT FRAME F-FOOTER.
    END.
END.
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE buena AS CHARACTER INITIAL "______________" FORMAT "X(14)" NO-UNDO.
DEFINE VARIABLE deter AS CHARACTER INITIAL "______________" FORMAT "X(14)" NO-UNDO.
DEFINE VARIABLE total AS CHARACTER INITIAL "______________" FORMAT "X(14)" NO-UNDO.
DEFINE VARIABLE x-zona AS CHARACTER NO-UNDO.

   FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                        AND  InvConfig.CodAlm = S-CODALM 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE InvConfig THEN ASSIGN x-cierre = InvConfig.FchInv.


  DEFINE FRAME F-FOOTER
      HEADER
      SKIP(2)
      "    -----------------       -----------------       -----------------"  AT 15 SKIP
      "         Conteo                  Reconteo               Supervisor   "  AT 15 SKIP
     WITH PAGE-BOTTOM WIDTH 180 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.
  
  DEFINE FRAME F-REPORTE
         SPACE(5)
         Almmmate.CodUbi COLUMN-LABEL "Zona" FORMAT "X(6)"
         Almmmatg.codmat COLUMN-LABEL "Codigo" FORMAT "X(8)"
         Almmmatg.DesMat COLUMN-LABEL "Descripcion" FORMAT "X(40)"
         Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(16)"
         Almmmatg.UndStk COLUMN-LABEL "UNI!med"
         buena
         deter
         total
        WITH WIDTH 180 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.

  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA AT 6 FORMAT "X(50)" SKIP
         "Pagina : " TO 113 PAGE-NUMBER(REPORT) TO 123 FORMAT "ZZZZZ9" SKIP
         "PTO.:" AT 5 S-DESALM AT 11 FORMAT "X(40)"
         " Fecha : " TO 113 TODAY TO 123 FORMAT "99/99/9999" SKIP
         "CIERRE DE INVENTARIO AL : " + TRIM(STRING(x-cierre, "99/99/9999")) AT 40 FORMAT "X(39)"
         "  Hora : " TO 113 STRING(TIME,"HH:MM:SS") TO 123 SKIP
         "     -------------------------------------------------------------------------------------------------------------------------" SKIP
         "     ZONA   CODIGO                                                             UNI    CANTIDAD        CANTIDAD      CANTIDAD  " SKIP
         "            PRODUCTO   D E S C R I P C I O N                  MARCA            BAS      BUENA        DETERIORADA      TOTAL   " SKIP
         "     -------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH PAGE-TOP WIDTH 180 NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO DOWN.
VIEW STREAM REPORT FRAME F-HEADER.
FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA
                   AND Almmmate.CodAlm = S-CODALM
                   AND  (Almmmate.CodUbi >= Zona-D
                   AND   Almmmate.CodUbi <= Zona-H)
                   AND (r-Stock = 3 OR r-Stock = 1 AND Almmmate.stkact > 0 OR r-Stock = 2 AND Almmmate.stkact = 0),
      FIRST Almmmatg OF Almmmate WHERE
                       Almmmatg.TpoArt BEGINS R-tipo NO-LOCK 
                  BREAK BY Almmmate.CodCia
                        BY Almmmate.CodAlm
                        BY Almmmate.CodUbi
                        BY Almmmate.CodMat:
    DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
      
    VIEW STREAM REPORT FRAME F-FOOTER.
    IF FIRST-OF(Almmmate.codubi) THEN DO:
        OUTPUT STREAM Report CLOSE.
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 25.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 25. /* Impresora */
        END CASE.
        PAGE STREAM Report.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn3}.
        VIEW STREAM REPORT FRAME F-HEADER.
    END.
    DISPLAY STREAM REPORT 
             Almmmate.CodUbi
             Almmmatg.codmat 
             Almmmatg.DesMat 
             Almmmatg.DesMar
             Almmmatg.UndStk 
             buena
             deter
             total
             WITH FRAME F-REPORTE.
    IF LAST-OF(Almmmate.codubi) THEN DO:
        PAGE STREAM REPORT.
        HIDE STREAM REPORT FRAME F-FOOTER.
    END.
    IF LAST-OF(Almmmate.codcia) THEN DO:
        PAGE STREAM REPORT.
        HIDE STREAM REPORT FRAME F-FOOTER.
    END.
END.
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL EXCEPT F-DesZonD F-DesZonH.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 25.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 25. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn3}.
        RUN Formato-1.
/*         PAGE STREAM REPORT. */
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN Zona-D Zona-H .
  
  IF Zona-H <> "" THEN Zona-H = "".

END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
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
/*        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Header W-Win 
PROCEDURE _Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
titulo = "REPORTE DE MOVIMIENTOS POR DIA".

mens1 = "TIPO Y CODIGO DE MOVIMIENTO : " + C-TipMov + "-" + STRING(I-CodMov, "99") + " " + D-Movi:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
mens2 = "MATERIAL : " + DesdeC + " A: " + HastaC .
mens3 = "FECHA : " + STRING(F-FchDes, "99/99/9999") + " A: " + STRING(F-FchHas, "99/99/9999").

titulo = S-NomCia + fill(" ", (INT((90 - length(titulo)) / 2)) - length(S-NomCia)) + titulo.
mens1 = fill(" ", INT((90 - length(mens1)) / 2)) + mens1.
mens2 = fill(" ", INT((90 - length(mens2)) / 2)) + mens2.
mens3 = C-condicion:SCREEN-VALUE + fill(" ", INT((90 - length(mens3)) / 2) - LENGTH(C-condicion:SCREEN-VALUE)) + mens3.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

