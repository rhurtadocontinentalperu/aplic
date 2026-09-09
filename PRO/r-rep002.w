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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-nomcia AS CHAR.

DEF TEMP-TABLE REPORTE
    FIELD codcia AS INT
    FIELD numord LIKE Pr-OdpC.NumOrd
    FIELD fchord LIKE Pr-OdpC.FchOrd
    FIELD numliq LIKE Pr-LiqC.NumLiq
    FIELD fchliq LIKE Pr-LiqC.FchLiq
    FIELD codmat LIKE Almmmatg.CodMat
    FIELD desmat LIKE Almmmatg.DesMat
    FIELD desmar LIKE Almmmatg.DesMar
    FIELD codund LIKE PR-LIQCX.CodUnd 
    FIELD canfin LIKE PR-LIQCX.CanFin
    INDEX Llave01 AS PRIMARY codcia numord numliq codmat.

DEF FRAME F-Progreso    
    SPACE(1) SKIP(1)
    "Procesando información, espere un momento..." SKIP(1)
    WITH CENTERED NO-LABELS VIEW-AS DIALOG-BOX OVERLAY.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
FILL-IN-CodFam FILL-IN-SubFam COMBO-BOX-Licencia BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
FILL-IN-CodFam FILL-IN-DesFam FILL-IN-SubFam FILL-IN-DesSub ~
COMBO-BOX-Licencia 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 9" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 10" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE COMBO-BOX-Licencia AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Licencia" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     LIST-ITEMS "Todas" 
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "O/P desde el" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta el" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-SubFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Subfamilia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Fecha-1 AT ROW 1.38 COL 13 COLON-ALIGNED
     FILL-IN-Fecha-2 AT ROW 1.38 COL 29 COLON-ALIGNED
     FILL-IN-CodFam AT ROW 2.35 COL 13 COLON-ALIGNED
     FILL-IN-DesFam AT ROW 2.35 COL 20 COLON-ALIGNED NO-LABEL
     FILL-IN-SubFam AT ROW 3.31 COL 13 COLON-ALIGNED
     FILL-IN-DesSub AT ROW 3.31 COL 20 COLON-ALIGNED NO-LABEL
     COMBO-BOX-Licencia AT ROW 4.27 COL 13 COLON-ALIGNED
     BUTTON-1 AT ROW 6.19 COL 6
     BUTTON-2 AT ROW 6.19 COL 23
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.58
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
         TITLE              = "MATERIALES POR O/P LIQUIDADAS"
         HEIGHT             = 7.69
         WIDTH              = 71.86
         MAX-HEIGHT         = 25.88
         MAX-WIDTH          = 137.14
         VIRTUAL-HEIGHT     = 25.88
         VIRTUAL-WIDTH      = 137.14
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN FILL-IN-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesSub IN FRAME F-Main
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
ON END-ERROR OF W-Win /* MATERIALES POR O/P LIQUIDADAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* MATERIALES POR O/P LIQUIDADAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 9 */
DO:
  ASSIGN
    COMBO-BOX-Licencia FILL-IN-CodFam 
    FILL-IN-DesFam FILL-IN-DesSub 
    FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-SubFam.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 10 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodFam W-Win
ON LEAVE OF FILL-IN-CodFam IN FRAME F-Main /* Familia */
DO:
  FILL-IN-DesFam:SCREEN-VALUE = ''.
  FIND AlmTFami WHERE almtfami.codcia = s-codcia
    AND almtfami.codfam = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE almtfami
  THEN FILL-IN-DesFam:SCREEN-VALUE = Almtfami.desfam.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-SubFam W-Win
ON LEAVE OF FILL-IN-SubFam IN FRAME F-Main /* Subfamilia */
DO:
  FILL-IN-DesSub:SCREEN-VALUE = ''.
  FIND AlmSFami WHERE almsfami.codcia = s-codcia
    AND almsfami.codfam = FILL-IN-CodFam:SCREEN-VALUE
    AND almsfami.subfam = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE AlmSFami
  THEN FILL-IN-DesSub:SCREEN-VALUE = AlmSFami.dessub.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Licencia AS CHAR.
  
  FOR EACH REPORTE:
    DELETE REPORTE.
  END.

  VIEW FRAME F-Progreso.  
  x-Licencia = SUBSTRING(COMBO-BOX-Licencia, 1, INDEX(COMBO-BOX-Licencia, ' ')).
  FOR EACH PR-LIQC NO-LOCK WHERE pr-liqc.codcia = s-codcia
        AND pr-liqc.flgest <> 'A',
        FIRST PR-ODPC OF PR-LIQC NO-LOCK WHERE pr-odpc.fchord >= FILL-IN-Fecha-1
            AND pr-odpc.fchord <= FILL-IN-Fecha-2,
        EACH PR-LIQCX OF PR-LIQC NO-LOCK,
        FIRST Almmmatg NO-LOCK WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = pr-liqcx.codart
            AND almmmatg.codfam BEGINS FILL-IN-CodFam
            AND almmmatg.codfam BEGINS FILL-IN-SubFam
            AND (COMBO-BOX-Licencia = 'Todas' OR almmmatg.licencia[1] = x-Licencia):
    CREATE REPORTE.
    ASSIGN
        reporte.codcia = s-codcia
        reporte.numord = Pr-OdpC.NumOrd
        reporte.fchord = Pr-OdpC.FchOrd
        reporte.numliq = Pr-LiqC.NumLiq
        reporte.fchliq = Pr-LiqC.FchLiq
        reporte.codmat = Almmmatg.CodMat
        reporte.desmat = Almmmatg.DesMat
        reporte.desmar = Almmmatg.DesMar
        reporte.codund = PR-LIQCX.CodUnd 
        reporte.canfin = PR-LIQCX.CanFin.
  END.
  HIDE FRAME F-Progreso.
          
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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-CodFam FILL-IN-DesFam 
          FILL-IN-SubFam FILL-IN-DesSub COMBO-BOX-Licencia 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-CodFam FILL-IN-SubFam 
         COMBO-BOX-Licencia BUTTON-1 BUTTON-2 
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
  DEF VAR x-Licencia AS CHAR FORMAT 'x(30)'.
  x-Licencia = COMBO-BOX-Licencia.

  DEFINE FRAME F-Cab
    reporte.numord COLUMN-LABEL 'Orden'
    reporte.fchord COLUMN-LABEL 'Fecha'
    reporte.numliq COLUMN-LABEL 'Liquidacion'
    reporte.fchliq COLUMN-LABEL 'Fecha'
    reporte.codmat COLUMN-LABEL 'Articulo'
    reporte.desmat COLUMN-LABEL 'Descripcion'
    reporte.desmar COLUMN-LABEL 'Marca'         FORMAT 'x(20)'
    reporte.codund COLUMN-LABEL 'Unidad'
    reporte.canfin COLUMN-LABEL 'Cantidad' SKIP
    HEADER
        S-NOMCIA FORMAT "X(50)" SKIP
        "MATERIALES POR O/P LIQUIDADAS" AT 30
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        "Hora  : " AT 120 STRING(TIME,"HH:MM:SS") SKIP
        "DESDE EL" FILL-IN-Fecha-1 "HASTA EL" FILL-IN-Fecha-2 SKIP
        "LICENCIA(s):" x-Licencia SKIP(1)
    WITH WIDTH 165 NO-BOX STREAM-IO DOWN.         

  FOR EACH Reporte BREAK BY Reporte.numord:
    DISPLAY STREAM REPORT
        reporte.numord WHEN FIRST-OF(Reporte.numord)
        reporte.fchord WHEN FIRST-OF(Reporte.numord)
        reporte.numliq
        reporte.fchliq
        reporte.codmat
        reporte.desmat
        reporte.desmar
        reporte.codund
        reporte.canfin
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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
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
  DO WITH FRAME {&FRAME-NAME}:
    /* cargamos las licencia */
    FOR EACH AlmTabla WHERE almtabla.tabla = 'LC' NO-LOCK:
        COMBO-BOX-Licencia:ADD-LAST(Almtabla.codigo + ' ' + almtabla.Nombre).
    END.
    RUN bin/_dateif (MONTH(TODAY), YEAR(TODAY), OUTPUT FILL-IN-Fecha-1, OUTPUT FILL-IN-Fecha-2).
  END.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE HANDLE-CAMPO:name:
        WHEN "FILL-IN-SubFam" 
            THEN ASSIGN 
                    input-var-1 = FILL-IN-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                    input-var-2 = ""
                    input-var-3 = "".
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


