&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEF SHARED VAR s-Periodo AS INT.
DEF VAR l-CodPln AS INT.
DEF VAR l-CodPln-m AS INT.

DEFINE VARIABLE db-work AS CHARACTER NO-UNDO.

DEFINE VARIABLE FILL-IN-msj   AS CHARACTER FORMAT "X(256)":U 
    VIEW-AS FILL-IN SIZE 45.57 BY .81 NO-UNDO.

DEFINE FRAME F-mensaje
    FILL-IN-msj AT ROW 1.73 COL 2 NO-LABEL
    "Procesando para:" VIEW-AS TEXT
    SIZE 12.72 BY .5 AT ROW 1.15 COL 2
    SPACE(34.13) SKIP(1.19)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE FONT 4
    TITLE "Espere un momento por favor..." CENTERED.

DEFINE TEMP-TABLE DETALLE LIKE PL-FLG-MES
    FIELD Nombre AS CHAR FORMAT 'x(40)'
    FIELD FecNac LIKE PL-PERS.fecnac
    FIELD SexPer LIKE PL-PERS.sexper
    INDEX LLAVE01 AS PRIMARY CodCia CodPer fecIng VContr.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.PL-PERS

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 INTEGRAL.PL-PERS.codper ~
INTEGRAL.PL-PERS.patper INTEGRAL.PL-PERS.matper INTEGRAL.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH INTEGRAL.PL-PERS NO-LOCK ~
    BY INTEGRAL.PL-PERS.patper ~
       BY INTEGRAL.PL-PERS.matper ~
        BY INTEGRAL.PL-PERS.nomper
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH INTEGRAL.PL-PERS NO-LOCK ~
    BY INTEGRAL.PL-PERS.patper ~
       BY INTEGRAL.PL-PERS.matper ~
        BY INTEGRAL.PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 INTEGRAL.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 INTEGRAL.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-1 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Seleccionar", 2
     SIZE 21 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      INTEGRAL.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      INTEGRAL.PL-PERS.codper COLUMN-LABEL "<Código>" FORMAT "X(6)":U
      INTEGRAL.PL-PERS.patper FORMAT "X(40)":U
      INTEGRAL.PL-PERS.matper FORMAT "X(40)":U
      INTEGRAL.PL-PERS.nomper FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 62 BY 12.12
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-1 AT ROW 1.58 COL 5 NO-LABEL
     BROWSE-1 AT ROW 2.92 COL 3
     Btn_OK AT ROW 12.54 COL 67
     Btn_Cancel AT ROW 13.73 COL 67
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
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
         TITLE              = "HISTORICO DE CONTRATOS DE PERSONAL"
         HEIGHT             = 14.81
         WIDTH              = 80.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 81.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 81.14
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 RADIO-SET-1 F-Main */
/* SETTINGS FOR BROWSE BROWSE-1 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.PL-PERS"
     _OrdList          = "INTEGRAL.PL-PERS.patper|yes,INTEGRAL.PL-PERS.matper|yes,INTEGRAL.PL-PERS.nomper|yes"
     _FldNameList[1]   > INTEGRAL.PL-PERS.codper
"PL-PERS.codper" "<Código>" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.PL-PERS.patper
     _FldNameList[3]   = INTEGRAL.PL-PERS.matper
     _FldNameList[4]   = INTEGRAL.PL-PERS.nomper
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* HISTORICO DE CONTRATOS DE PERSONAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* HISTORICO DE CONTRATOS DE PERSONAL */
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
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN
    RADIO-SET-1.
    
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 W-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
  CASE SELF:SCREEN-VALUE:
    WHEN '1' THEN BROWSE-1:SENSITIVE = NO.
    WHEN '2' THEN BROWSE-1:SENSITIVE = YES.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
    
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  
  IF RADIO-SET-1 = 1 THEN DO:
    FOR EACH PL-PERS NO-LOCK WHERE PL-PERS.codcia = s-codcia:
      FILL-IN-msj = PL-PERS.codper + " " +
          PL-PERS.PATPER + " " +
          PL-PERS.MATPER + ", " +
          PL-PERS.NOMPER.
      DISPLAY FILL-IN-msj WITH FRAME F-mensaje.
      FOR EACH PL-FLG-MES NO-LOCK WHERE PL-FLG-MES.codcia = s-codcia
              AND PL-FLG-MES.codper = PL-PERS.codper
              AND PL-FLG-MES.codpln = 01
              AND PL-FLG-MES.fecing <> ?
              AND PL-FLG-MES.vcontr <> ?:
          FIND DETALLE WHERE DETALLE.codcia = PL-FLG-MES.codcia
              AND DETALLE.codper = PL-FLG-MES.codper
              AND DETALLE.fecing = PL-FLG-MES.fecing
              AND DETALLE.vcontr = PL-FLG-MES.vcontr
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE DETALLE THEN DO:
                CREATE DETALLE.
                BUFFER-COPY PL-FLG-MES TO DETALLE
                   ASSIGN   
                       DETALLE.FecNac = PL-PERS.FecNac
                       DETALLE.SexPer = PL-PERS.SexPer
                       DETALLE.Nombre = TRIM(PL-PERS.PatPer) + ' ' +
                                       TRIM(PL-PERS.MatPer) + ', ' +
                                       PL-PERS.NomPer.
          END.
      END.            
      FOR EACH PL-FLG-SEM NO-LOCK WHERE PL-FLG-SEM.codcia = s-codcia
              AND PL-FLG-SEM.codper = PL-PERS.codper
              AND PL-FLG-SEM.codpln = 02
              AND PL-FLG-SEM.fecing <> ?
              AND PL-FLG-SEM.vcontr <> ?:
          FIND DETALLE WHERE DETALLE.codcia = PL-FLG-SEM.codcia
              AND DETALLE.codper = PL-FLG-SEM.codper
              AND DETALLE.fecing = PL-FLG-SEM.fecing
              AND DETALLE.vcontr = PL-FLG-SEM.vcontr
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE DETALLE THEN DO:
                CREATE DETALLE.
                BUFFER-COPY PL-FLG-SEM TO DETALLE
                   ASSIGN
                       DETALLE.FecNac = PL-PERS.FecNac
                       DETALLE.SexPer = PL-PERS.SexPer
                       DETALLE.Nombre = TRIM(PL-PERS.PatPer) + ' ' +
                                       TRIM(PL-PERS.MatPer) + ', ' +
                                       PL-PERS.NomPer.
          END.
      END.            
    END.
    HIDE FRAME f-Mensaje.  
  END.    
  IF RADIO-SET-1 = 2 THEN DO WITH FRAME {&FRAME-NAME}:
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            FILL-IN-msj = PL-PERS.codper + " " +
                PL-PERS.PATPER + " " +
                PL-PERS.MATPER + ", " +
                PL-PERS.NOMPER.
            DISPLAY FILL-IN-msj WITH FRAME F-mensaje.
            FOR EACH PL-FLG-MES NO-LOCK WHERE PL-FLG-MES.codcia = s-codcia
                    AND PL-FLG-MES.codper = PL-PERS.codper
                    AND PL-FLG-MES.codpln = 01:
                FIND DETALLE WHERE DETALLE.codcia = PL-FLG-MES.codcia
                    AND DETALLE.codper = PL-FLG-MES.codper
                    AND DETALLE.fecing = PL-FLG-MES.fecing
                    AND DETALLE.vcontr = PL-FLG-MES.vcontr
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE DETALLE THEN DO:
                        CREATE DETALLE.
                        BUFFER-COPY PL-FLG-MES TO DETALLE
                           ASSIGN
                               DETALLE.FecNac = PL-PERS.FecNac
                               DETALLE.SexPer = PL-PERS.SexPer
                               DETALLE.Nombre = TRIM(PL-PERS.PatPer) + ' ' +
                                               TRIM(PL-PERS.MatPer) + ', ' +
                                               PL-PERS.NomPer.
                END.
            END.            
            FOR EACH PL-FLG-SEM NO-LOCK WHERE PL-FLG-SEM.codcia = s-codcia
                    AND PL-FLG-SEM.codper = PL-PERS.codper
                    AND PL-FLG-SEM.codpln = 02:
                FIND DETALLE WHERE DETALLE.codcia = PL-FLG-SEM.codcia
                    AND DETALLE.codper = PL-FLG-SEM.codper
                    AND DETALLE.fecing = PL-FLG-SEM.fecing
                    AND DETALLE.vcontr = PL-FLG-SEM.vcontr
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE DETALLE THEN DO:
                        CREATE DETALLE.
                        BUFFER-COPY PL-FLG-SEM TO DETALLE
                           ASSIGN
                               DETALLE.FecNac = PL-PERS.FecNac
                               DETALLE.SexPer = PL-PERS.SexPer
                               DETALLE.Nombre = TRIM(PL-PERS.PatPer) + ' ' +
                                               TRIM(PL-PERS.MatPer) + ', ' +
                                               PL-PERS.NomPer.
                END.
            END.    
        END.
    END.
    HIDE FRAME f-Mensaje.  
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
  DISPLAY RADIO-SET-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-1 Btn_OK Btn_Cancel 
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
  DEFINE FRAME F-Cab
    DETALLE.CodPer      COLUMN-LABEL 'Codigo'
    DETALLE.Nombre      COLUMN-LABEL 'Nombre'
    DETALLE.FecIng      COLUMN-LABEL 'Ingreso'
    DETALLE.VContr      COLUMN-LABEL 'Salida'
    DETALLE.FecNac      COLUMN-LABEL 'Fec. Nac.'
    DETALLE.SexPer      COLUMN-LABEL 'Sexo'
    DETALLE.Cargo       COLUMN-LABEL 'Puesto'
    DETALLE.Seccion     COLUMN-LABEL 'Area'
    HEADER
        S-NOMCIA FORMAT 'X(50)' SKIP
        "HISTORICO DE CONTRATOS DEL PERSONAL" AT 20
        "Pag.  : " AT 80 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha : " AT 80 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        "Hora  : " AT 80 STRING(TIME,"HH:MM") SKIP(1)
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN.         

  FOR EACH DETALLE BY DETALLE.CodPer BY DETALLE.FecIng BY DETALLE.VContr DESC:
    DISPLAY STREAM REPORT
        DETALLE.CodPer      
        DETALLE.Nombre      
        DETALLE.FecIng      
        DETALLE.VContr      
        DETALLE.FecNac
        DETALLE.Sexper
        DETALLE.Cargo
        DETALLE.Seccion
        WITH FRAME F-Cab.
  END.

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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "INTEGRAL.PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

