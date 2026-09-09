&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-Matg NO-UNDO LIKE Almmmatg.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE STREAM txtRpt.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE x-almacenes AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-FchCorte  AS DATE        NO-UNDO.
DEFINE VARIABLE c-ArtDesde  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ArtHasta  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-Almacenes AS CHARACTER   NO-UNDO.

DEF TEMP-TABLE Detalle NO-UNDO LIKE integral.Almmmate 
    FIELDS DesFam       AS CHAR 
    FIELDS SubFam       AS CHAR 
    /*FIELDS CtoPro       AS DEC DECIMALS 4 FORMAT '->>,>>>,>>9.9999'*/
    FIELDS CtoRep       AS DEC DECIMALS 4 FORMAT '->>,>>>,>>9.9999'
    FIELDS Categoria    AS CHAR
    FIELDS CatConta     AS CHAR.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

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
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-3 rs-tipo txt-Desde txt-Hasta ~
txt-fchcorte txt-codfam txt-subfam txt-Proveedor Btn-Excel BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-CodAlm rs-tipo txt-Desde txt-Hasta ~
txt-fchcorte tg-stock rs-estado txt-codfam txt-subfam txt-Proveedor ~
F-mensaje F-mnje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Excel 
     IMAGE-UP FILE "img\list.ico":U
     LABEL "Button 6" 
     SIZE 8 BY 1.62 TOOLTIP "Exportar a Texto".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62 TOOLTIP "Salir".

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .96 TOOLTIP "Seleccionar almacenes".

DEFINE VARIABLE EDITOR-CodAlm AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 64 BY 4
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88
     BGCOLOR 8 FGCOLOR 14 FONT 0 NO-UNDO.

DEFINE VARIABLE F-mnje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88
     BGCOLOR 8 FGCOLOR 14 FONT 0 NO-UNDO.

DEFINE VARIABLE txt-codfam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Línea" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Desde AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-fchcorte AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Corte" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Hasta AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Proveedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Algun Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE txt-subfam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-Línea" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE rs-estado AS CHARACTER INITIAL "T" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activo", "A",
"Baja Rotación", "B",
"Desactivo", "D",
"Todos", "T"
     SIZE 47 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-tipo AS CHARACTER INITIAL "D" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Detallado", "D",
"Resumen", "R"
     SIZE 21 BY 1.69 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 13.65.

DEFINE VARIABLE tg-stock AS LOGICAL INITIAL yes 
     LABEL "Solo Con Stock" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-CodAlm AT ROW 1.73 COL 17.43 NO-LABEL WIDGET-ID 42
     BUTTON-3 AT ROW 1.73 COL 82.43 WIDGET-ID 6
     rs-tipo AT ROW 6.31 COL 18.43 NO-LABEL WIDGET-ID 8
     txt-Desde AT ROW 8.23 COL 16.43 COLON-ALIGNED WIDGET-ID 12
     txt-Hasta AT ROW 8.23 COL 43.43 COLON-ALIGNED WIDGET-ID 14
     txt-fchcorte AT ROW 9.31 COL 16.43 COLON-ALIGNED WIDGET-ID 16
     tg-stock AT ROW 9.35 COL 45.43 WIDGET-ID 32
     rs-estado AT ROW 10.15 COL 45.43 NO-LABEL WIDGET-ID 34
     txt-codfam AT ROW 10.42 COL 16.43 COLON-ALIGNED WIDGET-ID 30
     txt-subfam AT ROW 11.5 COL 16.43 COLON-ALIGNED WIDGET-ID 38
     txt-Proveedor AT ROW 11.5 COL 43.86 COLON-ALIGNED WIDGET-ID 40
     Btn-Excel AT ROW 12.85 COL 55.72 WIDGET-ID 18
     BUTTON-2 AT ROW 12.85 COL 63.57 WIDGET-ID 28
     F-mensaje AT ROW 13.38 COL 4.43 NO-LABEL WIDGET-ID 20
     F-mnje AT ROW 13.38 COL 73.43 NO-LABEL WIDGET-ID 24
     "Almacenes:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 1.73 COL 6.43 WIDGET-ID 44
     RECT-1 AT ROW 1.27 COL 3 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95.14 BY 14.54 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-Matg T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte Articulos"
         HEIGHT             = 14.54
         WIDTH              = 95.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 102.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 102.57
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
/* SETTINGS FOR EDITOR EDITOR-CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-mnje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RADIO-SET rs-estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-stock IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Articulos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Excel W-Win
ON CHOOSE OF Btn-Excel IN FRAME F-Main /* Button 6 */
DO:
  
    ASSIGN 
        EDITOR-CodAlm
        txt-Desde txt-Hasta txt-fchcorte rs-tipo txt-codfam txt-subfam
        tg-stock rs-estado txt-proveedor.

    IF txt-fchcorte = ? OR txt-fchcorte >= TODAY THEN DO:
        MESSAGE 'La Fecha de Corte debe ser menor que' TODAY
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO txt-fchcorte.
        RETURN NO-APPLY.
    END.

    IF TRUE <> (EDITOR-CodAlm > '') THEN DO:
        MESSAGE 'Debe seleccionar al menos un almacén' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
        
    CASE rs-tipo:
        WHEN "D" THEN RUN ue-texto.
        WHEN "R" THEN RUN ue-texto-R.
    END CASE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = EDITOR-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).

    /* Verificar almacenes: tiene que cuadrar con el reporte RP38 alm/d-stk004v2 */
    DEF VAR x-Final AS CHAR NO-UNDO.
    DEF VAR k AS INTE NO-UNDO.

    IF x-Almacenes > '' THEN DO:
        DO k = 1 TO NUM-ENTRIES(x-Almacenes):
            FIND Almacen WHERE Almacen.codcia = s-codcia AND
                Almacen.codalm = ENTRY(k, x-Almacenes)
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almacen THEN NEXT.
            IF Almacen.almcsg = YES THEN NEXT.
            IF Almacen.flgrep = NO  THEN NEXT.
            x-Final = x-Final + 
                    (IF TRUE <> (x-Final > '') THEN '' ELSE ',') +
                    ENTRY(k, x-Almacenes).
        END.
    END.
    EDITOR-CodAlm:SCREEN-VALUE = x-Final.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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

    DEFINE VARIABLE x-Orden AS INTEGER     NO-UNDO.
    /*DEFINE VARIABLE cDesFam AS CHARACTER   NO-UNDO.*/
    /*DEFINE VARIABLE cDesSub AS CHARACTER   NO-UNDO.*/
    /*DEFINE VARIABLE dTpoCmb AS DECIMAL     NO-UNDO.*/
    /*DEFINE VARIABLE dPorIgv AS DECIMAL     NO-UNDO.*/

    c-almacenes = EDITOR-CodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

    /* STOCKS CONTI */
    DEF VAR k AS INTE NO-UNDO.

    /* Barremos los artículos de acuerdo a los filtros seleccionados */
    /* 1ro cargamos un temporal con los artículos seleccionado */
    EMPTY TEMP-TABLE t-Matg.
/*     DEF QUERY q-Matg FOR Almmmatg.                                                 */
/*     OPEN QUERY q-Matg FOR EACH Almmmatg WHERE Almmmatg.codcia = s-codcia AND ~     */
/*         (TRUE <> (txt-Desde > '') OR Almmmatg.codmat >= txt-Desde) AND ~           */
/*         (TRUE <> (txt-Hasta > '') OR Almmmatg.codmat <= txt-Hasta) AND ~           */
/*         (TRUE <> (txt-codfam > '') OR almmmatg.codfam = txt-codfam) AND ~          */
/*         (TRUE <> (txt-subfam > '') OR almmmatg.subfam = txt-subfam) AND ~          */
/*         /*(rs-estado = 'T' OR Almmmatg.tpoart = rs-estado) AND ~*/                 */
/*         (TRUE <> (txt-proveedor > '') OR almmmatg.CodPr1 = txt-proveedor) NO-LOCK. */
/*     GET FIRST q-Matg.                                                              */
/*     DO WHILE NOT QUERY-OFF-END('q-Matg'):                                          */
/*         CREATE t-Matg.                                                             */
/*         BUFFER-COPY Almmmatg USING codcia codmat TO t-Matg.                        */
/*         GET NEXT q-Matg.                                                           */
/*     END.                                                                           */
/*     CLOSE QUERY q-Matg.                                                            */
    /* Es más rápido que el QUERY */
    FOR EACH Almmmatg WHERE Almmmatg.codcia = 001 AND ~
            (TRUE <> (txt-Desde > '') OR Almmmatg.codmat >= txt-Desde) AND ~
            (TRUE <> (txt-Hasta > '') OR Almmmatg.codmat <= txt-Hasta) AND ~
            (TRUE <> (txt-codfam > '') OR almmmatg.codfam = txt-codfam) AND ~
            (TRUE <> (txt-subfam > '') OR almmmatg.subfam = txt-subfam) AND ~
            /*(rs-estado = 'T' OR Almmmatg.tpoart = rs-estado) AND ~*/
            (TRUE <> (txt-proveedor > '') OR almmmatg.CodPr1 = txt-proveedor) NO-LOCK:
        CREATE t-Matg.
        BUFFER-COPY Almmmatg USING codcia codmat TO t-Matg.
    END.

    /* 2do barremos cada almacén y gargamos el temporal */
    EMPTY TEMP-TABLE detalle.
    DEF VAR x-CodAlm AS CHAR NO-UNDO.
    DEF VAR x-Items AS INT64 NO-UNDO.
    FOR EACH t-Matg NO-LOCK, FIRST Almmmatg OF t-Matg NO-LOCK, FIRST Almtfam OF Almmmatg NO-LOCK, FIRST Almsfam OF Almmmatg NO-LOCK:
        /*IF Almmmatg.MonVta <> 1 THEN dTpoCmb = Almmmatg.tpocmb. ELSE dTpoCmb = 1.*/
        /*dPorIgv = FacCfgGn.PorIgv.
        IF Almmmatg.AftIgv = NO THEN dPorIgv = 0.*/
        DO k = 1 TO NUM-ENTRIES(c-almacenes):
            x-CodAlm = ENTRY(k, c-almacenes).
            FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
                AND Almmmate.codmat = t-Matg.codmat
                AND Almmmate.codalm = x-CodAlm:
                x-Items = x-Items + 1.
                IF x-Items MODULO 100 = 0 THEN DO:
                    DISPLAY
                        "  Procesando: " + Almmmate.codmat + ' ' + Almmmate.codalm @ Fi-Mensaje WITH FRAME F-Proceso.
                END.
                /*
                IF x-Items MODULO 1000 = 0 THEN DO:
                    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Conti >> ' +
                        Almmmate.codalm + ' ' +
                        Almmmatg.codmat + ' ' +
                        Almmmatg.desmat.
                    f-mnje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' .... '.
                END.
                */
                FIND FIRST detalle OF Almmmate EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE detalle THEN CREATE detalle.
                BUFFER-COPY Almmmate 
                    EXCEPT Almmmate.StkAct
                    TO detalle
                    ASSIGN 
                    Detalle.DesFam        = almtfam.codfam + "-" + almtfam.desfam
                    Detalle.SubFam        = almsfam.subfam + "-" + almsfam.dessub
                    /*
                    Detalle.CtoPro        = Almmmatg.CtoLis * dTpoCmb   /*(Almmmatg.CtoTot / (1 + dPorIgv / 100)) * dTpoCmb*/
                    */
                    Detalle.Categoria     = Almmmatg.tiprot[1]
                    Detalle.CatConta      = Almmmatg.CatConta[1]
                    .
                IF txt-fchcorte = TODAY THEN ASSIGN Detalle.StkAct = Almmmate.StkAct.
                ELSE DO:
                    FIND LAST Almstkal USE-INDEX Llave01 WHERE AlmStkal.CodCia = Almmmate.codcia
                        AND AlmStkal.CodAlm = Almmmate.codalm
                        AND AlmStkal.codmat = Almmmate.codmat
                        AND AlmStkal.Fecha <= txt-fchcorte
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almstkal THEN ASSIGN Detalle.StkAct = AlmStkal.StkAct.
                END.
                IF Detalle.StkAct > 0 THEN DO:
                    FIND LAST Almstkge USE-INDEX Llave01 WHERE Almstkge.codcia = s-codcia
                        AND Almstkge.codmat = Almmmatg.codmat
                        AND Almstkge.fecha <= txt-fchcorte NO-LOCK NO-ERROR.
                    IF AVAIL Almstkge THEN Detalle.CtoRep = Almstkge.CtoUni.
                END.
            END.
        END.
    END.
/*     FOR EACH Detalle:                                           */
/*         IF tg-stock AND Detalle.stkact = 0 THEN DELETE Detalle. */
/*     END.                                                        */
    f-mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    HIDE FRAME F-Proceso NO-PAUSE.

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
  DISPLAY EDITOR-CodAlm rs-tipo txt-Desde txt-Hasta txt-fchcorte tg-stock 
          rs-estado txt-codfam txt-subfam txt-Proveedor F-mensaje F-mnje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 BUTTON-3 rs-tipo txt-Desde txt-Hasta txt-fchcorte txt-codfam 
         txt-subfam txt-Proveedor Btn-Excel BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
      ASSIGN txt-fchcorte = TODAY - 1 .
      DISPLAY txt-fchcorte.
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
        WHEN "txt-subfam" THEN
            ASSIGN
                input-var-1 = txt-codfam:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                input-var-2 = ""
                input-var-3 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-texto W-Win 
PROCEDURE ue-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE x-Archivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-rpta    AS LOGICAL     NO-UNDO.

DEFINE VAR lCodBar1 AS CHAR.
DEFINE VAR lCodBar2 AS CHAR.
DEFINE VAR lCodBar3 AS CHAR.
DEFINE VAR lFactBar1 AS DEC.
DEFINE VAR lFactBar2 AS DEC.
DEFINE VAR lFactBar3 AS DEC.
   
  x-Archivo = 'Detalle-rpt.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Temporal.
SESSION:SET-WAIT-STATE('').

OUTPUT STREAM txtRpt TO VALUE(x-Archivo).
  PUT STREAM txtRpt UNFORMATTED   
      "Material|"
      "Descripcion|"
      "Marca|"
      "Unidad|"
      "Linea|"
      "Sub-linea|"
      "Almacen|"
      "Stock|"
      /*"Costo Unitario sin IGV (S/.)|"*/
      "Costo Promedio Kardex sin IGV|"
      "Estado|"
      "Categoria|" 
      "Cat.Contable"
      SKIP.

FOR EACH Detalle NO-LOCK, FIRST Almmmatg OF Detalle NO-LOCK BY Detalle.CodAlm BY Detalle.CodMat:
    lCodBar1 = "".
    lCodBar2 = "".
    lCodBar3 = "".
    lFactBar1 = 0.
    lFactBar1 = 0.
    lFactBar1 = 0.
    PUT STREAM txtRpt UNFORMATTED
        Detalle.CodMat "|"
        Almmmatg.DesMat "|"
        Almmmatg.DesMar "|"
        Almmmatg.UndBas "|"
        Detalle.DesFam "|"
        Detalle.SubFam "|"
        Detalle.CodAlm "|"
        Detalle.StkAct "|"
        /*Detalle.CtoPro "|"*/
        Detalle.CtoRep "|"
        Almmmatg.TpoArt "|"
        Detalle.Categoria "|"
        Detalle.CatConta
        SKIP.
END.    

OUTPUT STREAM txtRpt CLOSE.

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-texto-r W-Win 
PROCEDURE ue-texto-r :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE x-Archivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-rpta    AS LOGICAL     NO-UNDO.

DEFINE VAR lCodBar1 AS CHAR.
DEFINE VAR lCodBar2 AS CHAR.
DEFINE VAR lCodBar3 AS CHAR.
DEFINE VAR lAcumTot AS DEC.
   
x-Archivo = 'Resumen-rpt.txt'.
SYSTEM-DIALOG GET-FILE x-Archivo
  FILTERS 'Texto' '*.txt'
  ASK-OVERWRITE
  CREATE-TEST-FILE
  DEFAULT-EXTENSION '.txt'
  INITIAL-DIR 'c:\tmp'
  RETURN-TO-START-DIR 
  USE-FILENAME
  SAVE-AS
  UPDATE x-rpta.
IF x-rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Temporal.
SESSION:SET-WAIT-STATE('').

OUTPUT STREAM txtRpt TO VALUE(x-Archivo).
PUT STREAM txtRpt UNFORMATTED
      "Material|"
      "Descripcion|"
      "Marca|" 
      "Unidad|"
      "Linea|"
      "Sub-linea|"
      "Stock|"
      /*"Costo Unitario sin IGV (S/.)|"*/
      "Costo Promedio Kardex sin Igv|"
      "Estado|"
      "Categoria|" 
      "Cat.Contable"
    SKIP.

loopREP:
FOR EACH Detalle, FIRST Almmmatg OF Detalle NO-LOCK BREAK BY Detalle.CodMat:
  ACCUMULATE Detalle.StkAct (TOTAL BY Detalle.codmat).

  IF LAST-OF(Detalle.CodMat) THEN DO:

      lAcumTot = ACCUM TOTAL BY Detalle.codmat Detalle.StkAct.

      PUT STREAM txtRpt UNFORMATTED
          Detalle.CodMat "|"
          Almmmatg.DesMat "|"
          Almmmatg.DesMar "|"
          Almmmatg.UndBas "|"
          Detalle.DesFam "|"
          Detalle.SubFam "|"
          lAcumTot "|"
          /*Detalle.CtoPro "|"*/
          Detalle.CtoRep "|"
          Almmmatg.TpoArt "|"
          Detalle.Categoria "|"
          Detalle.CatConta
          SKIP.
  END.
END.    
OUTPUT STREAM txtRpt CLOSE.


MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

