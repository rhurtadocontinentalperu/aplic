&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje FORMAT 'x(30)' NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEF TEMP-TABLE T-MOV-I LIKE ALMCMOV.
DEF TEMP-TABLE T-MOV-S LIKE ALMCMOV.

DEF TEMP-TABLE REPORTE LIKE ALMCMOV.

DEF TEMP-TABLE DETALLE LIKE Almmmatg
    FIELD StkCbd AS DEC
    FIELD StkLog AS DEC
    INDEX DETA01 AS PRIMARY CodCia CodMat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-57 xFecha DFecha Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS xFecha DFecha 

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

DEFINE VARIABLE DFecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .69 NO-UNDO.

DEFINE VARIABLE xFecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Del" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.86 BY 8.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     xFecha AT ROW 2.15 COL 18 COLON-ALIGNED
     DFecha AT ROW 2.15 COL 33 COLON-ALIGNED
     Btn_OK AT ROW 10.35 COL 53.72
     Btn_Cancel AT ROW 10.35 COL 66.14
     RECT-46 AT ROW 10.23 COL 1
     RECT-57 AT ROW 1.19 COL 1.14
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.5
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
         TITLE              = "INCONSISTENCIAS DE TRANSFERENCIAS"
         HEIGHT             = 10.92
         WIDTH              = 80
         MAX-HEIGHT         = 11.5
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 11.5
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Custom                                                               */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* INCONSISTENCIAS DE TRANSFERENCIAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* INCONSISTENCIAS DE TRANSFERENCIAS */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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
    ASSIGN DFecha xFecha.
  END.

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
  FOR EACH T-MOV-I:
    DELETE T-MOV-I.
  END.
  FOR EACH T-MOV-S:
    DELETE T-MOV-S.
  END.
  FOR EACH REPORTE:
    DELETE REPORTE.
  END.

  /* CARGAMOS LOS INGRESOS Y SALIDAS POR TRANSFERENCIA */
  FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
    FOR EACH Almtmov NO-LOCK WHERE Almtmov.codcia = s-codcia
            AND Almtmov.MovTrf = YES:
        FOR EACH ALMCMOV NO-LOCK WHERE almcmov.codcia = s-codcia
              AND almcmov.codalm = Almacen.codalm
              AND almcmov.fchdoc >= xFecha
              AND almcmov.fchdoc <= DFecha
              AND almcmov.tipmov = almtmov.tipmov
              AND almcmov.codmov = almtmov.codmov
              AND almcmov.tipmov = 'I'
              AND almcmov.flgest <> 'A':
          DISPLAY almcmov.codalm + '-' + almcmov.tipmov + '-' + STRING(almcmov.nrodoc) @ Fi-Mensaje WITH FRAME F-Proceso.
          CREATE T-MOV-I.
          BUFFER-COPY ALMCMOV TO T-MOV-I.
        END.
        FOR EACH ALMCMOV NO-LOCK WHERE almcmov.codcia = s-codcia
              AND almcmov.codalm = Almacen.codalm
              AND almcmov.fchdoc >= xFecha
              AND almcmov.fchdoc <= DFecha
              AND almcmov.tipmov = almtmov.tipmov
              AND almcmov.codmov = almtmov.codmov
              AND almcmov.tipmov = 'S'
              AND almcmov.flgest <> 'A':
          DISPLAY almcmov.codalm + '-' + almcmov.tipmov + '-' + STRING(almcmov.nrodoc) @ Fi-Mensaje WITH FRAME F-Proceso.
          CREATE T-MOV-S.
          BUFFER-COPY ALMCMOV TO T-MOV-S.
        END.
    END.
  END.
  
  /* BORRAMOS LOS QUE CUMPLEN */
  /* MOVIMIENTOS DE INGRESO */
  FOR EACH T-MOV-I WHERE T-MOV-I.CodMov = 03:
    FIND FIRST T-MOV-S WHERE T-MOV-S.CODCIA = T-MOV-I.CODCIA
        AND T-MOV-S.CODMOV = 03
        AND T-MOV-S.NROSER = INTEGER(SUBSTRING(T-MOV-I.NRORF1,1,3))
        AND T-MOV-S.NRODOC = INTEGER(SUBSTRING(T-MOV-I.NRORF1,4))
        AND T-MOV-S.CODALM = T-MOV-I.ALMDES
        NO-ERROR.
    IF AVAILABLE T-MOV-S
    THEN DO:
        DELETE T-MOV-S.
        DELETE T-MOV-I.
    END.
  END.
  /* MOVIMIENTOS DE SALIDA */
  FOR EACH T-MOV-S WHERE T-MOV-S.CodMov = 03:
    FIND FIRST T-MOV-I WHERE T-MOV-I.CODCIA = T-MOV-S.CODCIA
        AND T-MOV-I.CODMOV = 03
        AND T-MOV-I.NRODOC = INTEGER(T-MOV-S.NRORF2)
        AND T-MOV-I.CODALM = T-MOV-S.ALMDES
        NO-ERROR.
    IF AVAILABLE T-MOV-I
    THEN DO:
        DELETE T-MOV-I.
        DELETE T-MOV-S.
    END.
  END.

  /* INGRESOS */  
  FOR EACH T-MOV-I WHERE T-MOV-I.CodMov <> 03:
    FIND FIRST T-MOV-S WHERE T-MOV-S.CODCIA = T-MOV-I.CODCIA
        AND T-MOV-S.NROSER = INTEGER(SUBSTRING(T-MOV-I.NRORF1,1,3))
        AND T-MOV-S.NRODOC = INTEGER(SUBSTRING(T-MOV-I.NRORF1,5))
        AND T-MOV-S.CODALM = T-MOV-I.ALMDES
        NO-ERROR.
    IF AVAILABLE T-MOV-S
    THEN DO:
        DELETE T-MOV-S.
        DELETE T-MOV-I.
    END.
  END.

  /* CARGAMOS LA TABLA RESUMEN */
  FOR EACH T-MOV-I:
    CREATE REPORTE.
    BUFFER-COPY T-MOV-I TO REPORTE.
  END.
  FOR EACH T-MOV-S:
    CREATE REPORTE.
    BUFFER-COPY T-MOV-S TO REPORTE.
  END.
  HIDE FRAME F-Proceso.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY xFecha DFecha 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 xFecha DFecha Btn_OK Btn_Cancel 
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
  DEFINE FRAME F-REPORTE
    REPORTE.tipmov  COLUMN-LABEL 'Tipo'
    REPORTE.codmov  COLUMN-LABEL 'Codigo'
    REPORTE.codalm  COLUMN-LABEL 'Alm!Origen'
    REPORTE.almdes  COLUMN-LABEL 'Alm!Destino'
    REPORTE.fchdoc  COLUMN-LABEL 'Fecha'
    REPORTE.nroser  COLUMN-LABEL 'Serie'
    REPORTE.nrodoc  COLUMN-LABEL 'Numero'
    REPORTE.nrorf1  COLUMN-LABEL 'Referencia'
    REPORTE.nrorf2  COLUMN-LABEL 'Referencia'
    REPORTE.flgsit  COLUMN-LABEL 'Est'
/*    WITH PAGE-TOP WIDTH 110 NO-BOX STREAM-IO DOWN. 
 * 
 *   DEF FRAME F-HEADER*/
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn1} FORMAT "X(50)" AT 1 SKIP
    "INCONSISTENCIA DE TRANSFERENCIAS" AT 20 
    "Pagina :" TO 65 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 65 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 65 STRING(TIME,"HH:MM") SKIP(1)
/*
              1         2         3         4         5         6         7         8         9        10        11        12    
     12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     123456   99/99/9999 123     123     1 12   123    123456 ->>>,>>>,>>9.99 123
*/    

    WITH /*PAGE-TOP*/ WIDTH 110 NO-BOX /*NO-LABELS NO-UNDERLINE*/ STREAM-IO DOWN. 

  FOR EACH REPORTE:
/*    VIEW STREAM REPORT FRAME F-HEADER.*/
    DISPLAY STREAM REPORT 
    REPORTE.codalm
    REPORTE.almdes
    REPORTE.fchdoc 
    REPORTE.tipmov 
    REPORTE.codmov 
    REPORTE.nroser
    REPORTE.nrodoc 
    REPORTE.nrorf1
    REPORTE.nrorf2
    REPORTE.flgsit
    WITH FRAME F-REPORTE.
  END.

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
    ENABLE ALL EXCEPT.
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
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  RUN Carga-Temporal.

  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").

  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
   
  RUN Formato.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
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
    ASSIGN DFecha.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
    DFecha = TODAY
    xFecha = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
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
        WHEN "" THEN .
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


