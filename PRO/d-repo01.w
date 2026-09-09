&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

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

/* Local Variable Definitions ---                                       */
DEF TEMP-TABLE CONSUMOS
    FIELD CanDes AS DEC EXTENT 30  FORMAT '->>>,>>9.99'
    FIELD Fecha  AS DATE EXTENT 30 FORMAT '99/99/99'.

DEF TEMP-TABLE PRODUCTOS
    FIELD CodCia LIKE almmmatg.codcia
    FIELD CodMat LIKE almmmatg.codmat
    FIELD DesMat LIKE almmmatg.desmat
    INDEX Llave01 AS PRIMARY CodMat.

DEF VAR x-Promedio AS DEC NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodMat FILL-IN-Fecha Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat FILL-IN-DesMat ~
FILL-IN-Fecha 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.73
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Insumo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Al Día" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodMat AT ROW 1.58 COL 10 COLON-ALIGNED
     FILL-IN-DesMat AT ROW 1.58 COL 19 COLON-ALIGNED NO-LABEL
     FILL-IN-Fecha AT ROW 2.54 COL 10 COLON-ALIGNED
     Btn_OK AT ROW 4.85 COL 7
     Btn_Cancel AT ROW 4.85 COL 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 63.86 BY 8.5
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
         TITLE              = "Productos relacionados y consumos"
         HEIGHT             = 6.31
         WIDTH              = 64
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
   UNDERLINE L-To-R                                                     */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Productos relacionados y consumos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Productos relacionados y consumos */
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
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat W-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Insumo */
DO:
  IF SELF:SCREEN-VALUE <> ''
  THEN DO:
    ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
        NO-ERROR.
    FIND almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg
    THEN FILL-IN-DesMat:SCREEN-VALUE = almmmatg.desmat.
    ELSE FILL-IN-DesMat:SCREEN-VALUE = ''.
  END.
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
  ASSIGN FILL-IN-CodMat FILL-IN-Fecha FILL-IN-DesMat.
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
  DEF VAR i AS INT NO-UNDO.
  DEF VAR x-Fecha AS DATE NO-UNDO.
  
  FOR EACH PRODUCTOS:
    DELETE PRODUCTOS.
  END.
  FOR EACH CONSUMOS:
    DELETE CONSUMOS.
  END.
  CREATE CONSUMOS.

  x-Promedio = 0.
  DO i = 1 TO 20:
    x-Fecha = FILL-IN-Fecha - i + 1.
    CONSUMOS.Fecha[i]  = x-Fecha.
    /* RASTREAMOS LAS SALIDAS POR TRANSFERENCIA DEL
        ALMACEN 11 AL 12 */
    FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
            AND almcmov.codalm = '11'
            AND almcmov.tipmov = 'S'
            AND almcmov.codmov = 03     /* Transferencia */
            AND almcmov.almdes = '12'
            AND almcmov.fchdoc = x-Fecha,
            EACH almdmov OF almcmov NO-LOCK WHERE almdmov.codmat = FILL-IN-CodMat:
        DISPLAY STRING(x-Fecha, '99/99/9999') @ Fi-Mensaje LABEL "Procesando dia "
            FORMAT "X(11)" 
            WITH FRAME F-Proceso.
        CONSUMOS.CanDes[i] = CONSUMOS.CanDes[i] + almdmov.candes * almdmov.factor.
        x-Promedio = x-Promedio + almdmov.candes * almdmov.factor.
    END.            
  END.
  x-Promedio = x-Promedio / (i - 1).
  
  FOR EACH PR-FORMD NO-LOCK WHERE PR-FORMD.codcia = s-codcia
        AND PR-FORMD.codmat = FILL-IN-CodMat,
        FIRST PR-FORMC OF PR-FORMD NO-LOCK:
    DISPLAY PR-FORMC.codart @ Fi-Mensaje LABEL "Formulas "
        FORMAT "X(11)" 
        WITH FRAME F-Proceso.
    FIND PRODUCTOS WHERE PRODUCTOS.codmat = PR-FORMC.codart NO-ERROR.
    IF NOT AVAILABLE PRODUCTOS
    THEN CREATE PRODUCTOS.
    PRODUCTOS.codmat = PR-FORMC.codart.
    FIND almmmatg WHERE almmmatg.codcia = s-codcia 
        AND almmmatg.codmat = PRODUCTOS.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg
    THEN PRODUCTOS.desmat = almmmatg.desmat.
  END.
  HIDE FRAME F-PROCESO.
  
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
  DISPLAY FILL-IN-CodMat FILL-IN-DesMat FILL-IN-Fecha 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodMat FILL-IN-Fecha Btn_OK Btn_Cancel 
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
  FIND FIRST CONSUMOS.
  
  DEFINE FRAME F-Hdr
        HEADER
        S-NOMCIA FORMAT "X(50)" AT 1 SKIP
        "PRODUCTOS POR INSUMO" AT 30
        "Pagina :" TO 70 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
        "Fecha  :" TO 70 TODAY FORMAT "99/99/9999" SKIP
        "Hora   :" TO 70 STRING(TIME,"HH:MM") SKIP
        "INSUMO:" FILL-IN-CodMat FORMAT 'x(6)' FILL-IN-DesMat FORMAT 'x(60)' SKIP
        "---------------------------------------------------------------------" SKIP
        "Producto Descripcion                                                 " SKIP
        "---------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  DEFINE FRAME F-Ftr
        HEADER
        "CONSUMOS LOS ULTIMOS VEINTE DIAS A PARTIR DEL" FILL-IN-Fecha SKIP
        "-----------------------------------------------------------------------------------------" SKIP
        "Dia         Cantidad   Dia         Cantidad   Dia         Cantidad   Dia         Cantidad" SKIP
        "-----------------------------------------------------------------------------------------" SKIP
/*                1         2         3         4         5         6         7         8         9        10        11        12
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         99/99/99 ->>>,>>9.99   99/99/99 ->>>,>>9.99   99/99/99 ->>>,>>9.99   99/99/99 ->>>,>>9.99 
*/
        CONSUMOS.Fecha[1] CONSUMOS.CanDes[1] SPACE(3)
        CONSUMOS.Fecha[2] CONSUMOS.CanDes[2] SPACE(3)
        CONSUMOS.Fecha[3] CONSUMOS.CanDes[3] SPACE(3)
        CONSUMOS.Fecha[4] CONSUMOS.CanDes[4] SKIP
        CONSUMOS.Fecha[5] CONSUMOS.CanDes[5] SPACE(3)
        CONSUMOS.Fecha[6] CONSUMOS.CanDes[6] SPACE(3)
        CONSUMOS.Fecha[7] CONSUMOS.CanDes[7] SPACE(3)
        CONSUMOS.Fecha[8] CONSUMOS.CanDes[8] SKIP
        CONSUMOS.Fecha[9] CONSUMOS.CanDes[9] SPACE(3)
        CONSUMOS.Fecha[10] CONSUMOS.CanDes[10] SPACE(3)
        CONSUMOS.Fecha[11] CONSUMOS.CanDes[11] SPACE(3)
        CONSUMOS.Fecha[12] CONSUMOS.CanDes[12] SKIP
        CONSUMOS.Fecha[13] CONSUMOS.CanDes[13] SPACE(3)
        CONSUMOS.Fecha[14] CONSUMOS.CanDes[14] SPACE(3)
        CONSUMOS.Fecha[15] CONSUMOS.CanDes[15] SPACE(3)
        CONSUMOS.Fecha[16] CONSUMOS.CanDes[16] SKIP
        CONSUMOS.Fecha[17] CONSUMOS.CanDes[17] SPACE(3)
        CONSUMOS.Fecha[18] CONSUMOS.CanDes[18] SPACE(3)
        CONSUMOS.Fecha[19] CONSUMOS.CanDes[19] SPACE(3)
        CONSUMOS.Fecha[20] CONSUMOS.CanDes[20] SKIP
        "VALOR PROMEDIO >>>" x-Promedio FORMAT '->>>,>>>,>>9.99'
  WITH PAGE-BOTTOM WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  
  DEFINE FRAME F-Detalle
    PRODUCTOS.codmat SPACE(2)
    PRODUCTOS.desmat FORMAT 'x(60)'
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  FOR EACH PRODUCTOS BREAK BY PRODUCTOS.CodCia:
    VIEW STREAM REPORT FRAME F-Hdr.                      
    VIEW STREAM REPORT FRAME F-Ftr.
    DISPLAY  STREAM REPORT 
        PRODUCTOS.codmat
        PRODUCTOS.desmat
        WITH FRAME F-Detalle.
    IF LAST-OF(PRODUCTOS.CodCia)
    THEN PAGE STREAM REPORT.
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
    ENABLE ALL EXCEPT FILL-IN-DesMat.
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

    RUN Carga-Temporal.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn2}.
        RUN Formato.
        PAGE STREAM report.
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
  ASSIGN FILL-IN-CodMat FILL-IN-DesMat FILL-IN-Fecha.
  IF FILL-IN-codmat <> "" THEN DO:
     FILL-IN-CodMat = "".
     FILL-IN-DesMat = "".
  END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN FILL-IN-Fecha = TODAY.
     DISPLAY FILL-IN-Fecha.
  END.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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


