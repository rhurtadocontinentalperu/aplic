&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE TEMP-TABLE T-DREPO NO-UNDO LIKE almdrepo.



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

DEF SHARED VAR s-codcia AS INT.

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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DREPO

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-DREPO.Item T-DREPO.AlmPed ~
T-DREPO.StkAct T-DREPO.CanReq T-DREPO.CanGen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-DREPO NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-DREPO NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-DREPO
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-DREPO


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-CodAlm x-CodMat BUTTON-5 BUTTON-3 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS x-CodAlm x-CodMat x-StkAct pVentaDiaria ~
x-StockMinimo pReposicion x-CanEmp pCodAlm 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .96.

DEFINE BUTTON BUTTON-5 
     LABEL "CALCULO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE pCodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Considerar stock de" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE pReposicion AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Reposicion" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE pVentaDiaria AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Venta Diaria" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE x-CanEmp AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Empaque" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodAlm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMat AS CHARACTER FORMAT "x(6)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE x-StkAct AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Stock Actual" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE x-StockMinimo AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Stock Minimo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-DREPO SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-DREPO.Item FORMAT ">,>>9":U
      T-DREPO.AlmPed FORMAT "x(3)":U
      T-DREPO.StkAct FORMAT "(ZZZ,ZZZ,ZZ9.99)":U WIDTH 11.29
      T-DREPO.CanReq FORMAT "ZZZ,ZZ9.9999":U
      T-DREPO.CanGen FORMAT "ZZZ,ZZ9.9999":U WIDTH 13.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54 BY 9.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     x-CodAlm AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     x-CodMat AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-5 AT ROW 2.08 COL 54 WIDGET-ID 6
     x-StkAct AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 20
     pVentaDiaria AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 22
     x-StockMinimo AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 24
     pReposicion AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 26
     x-CanEmp AT ROW 6.12 COL 19 COLON-ALIGNED WIDGET-ID 28
     BUTTON-3 AT ROW 6.92 COL 70 WIDGET-ID 16
     pCodAlm AT ROW 7.12 COL 19 COLON-ALIGNED WIDGET-ID 18
     BROWSE-2 AT ROW 8.27 COL 11 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17.73
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: T-DREPO T "?" NO-UNDO INTEGRAL almdrepo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 17.73
         WIDTH              = 80
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" wWin _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* BROWSE-TAB BROWSE-2 pCodAlm fMain */
/* SETTINGS FOR FILL-IN pCodAlm IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pReposicion IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pVentaDiaria IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-CanEmp IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-StkAct IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-StockMinimo IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-DREPO"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.T-DREPO.Item
     _FldNameList[2]   = Temp-Tables.T-DREPO.AlmPed
     _FldNameList[3]   > Temp-Tables.T-DREPO.StkAct
"StkAct" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.T-DREPO.CanReq
     _FldNameList[5]   > Temp-Tables.T-DREPO.CanGen
"CanGen" ? ? "decimal" ? ? ? ? ? ? no ? no no "13.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 wWin
ON CHOOSE OF BUTTON-3 IN FRAME fMain /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = pCodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    pCodAlm:SCREEN-VALUE = x-almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 wWin
ON CHOOSE OF BUTTON-5 IN FRAME fMain /* CALCULO */
DO:
  ASSIGN
      x-codalm
      x-codmat.
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
      MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pRowid AS ROWID.
DEF VAR pDiasUtiles AS INT.
/*DEF VAR pVentaDiaria AS DEC.*/
DEF VAR pDiasMinimo AS INT.
/*DEF VAR pReposicion AS DEC.*/
DEF VAR pComprometido AS DEC.

/*DEF VAR x-StockMinimo AS DEC NO-UNDO.*/
DEF VAR x-StockDisponible AS DEC NO-UNDO.
/*DEF VAR x-Item AS INT INIT 1 NO-UNDO.*/
DEF VAR x-CanReq AS DEC NO-UNDO.
/*DEF VAR x-StkAct LIKE Almmmate.StkAct NO-UNDO.*/
DEF VAR k AS INT NO-UNDO.

DEF VAR s-codalm AS CHAR.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    pDiasMinimo = AlmCfgGn.DiasMinimo
    pDiasUtiles = AlmCfgGn.DiasUtiles
    s-codalm = x-codalm.

FOR EACH T-DREPO:
    DELETE T-DREPO.
END.

FOR EACH almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia 
    AND Almmmate.codmat = x-codmat
    AND Almmmate.codalm = s-codalm,
    FIRST almmmatg OF almmmate NO-LOCK:
    /* Venta Diaria */
    pRowid = ROWID(Almmmate).
    RUN gn/venta-diaria (pRowid, pDiasUtiles, pCodAlm, OUTPUT pVentaDiaria).
    /* Stock Minimo */
    x-StockMinimo = pDiasMinimo * pVentaDiaria.
    x-StkAct = Almmmate.StkAct.
    IF pCodAlm <> '' THEN DO:
        DO k = 1 TO NUM-ENTRIES(pCodAlm):
            IF ENTRY(k, pCodAlm) = s-codalm THEN NEXT.   /* NO del almacen activo */
            FIND B-MATE WHERE B-MATE.codcia = s-codcia
                AND B-MATE.codalm = ENTRY(k, pCodAlm)
                AND B-MATE.codmat = Almmmate.codmat
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-MATE THEN x-StkAct = x-StkAct + B-MATE.StkAct.
        END.
    END.
    DISPLAY 
        x-stkact 
        pVentaDiaria
        x-StockMinimo
        almmmatg.canemp @ x-canemp
        WITH FRAME {&FRAME-NAME}.
    IF x-StkAct >= x-StockMinimo THEN NEXT.

    /* Cantidad de Reposicion */
    RUN gn/cantidad-de-reposicion (pRowid, pVentaDiaria, OUTPUT pReposicion).
    DISPLAY 
        pReposicion
        WITH FRAME {&FRAME-NAME}.
    IF pReposicion <= 0 THEN NEXT.

    /* distribuimos el pedido entre los almacenes de despacho */
    FOR EACH Almrepos NO-LOCK WHERE  almrepos.CodCia = s-codcia
        AND almrepos.TipMat = Almmmatg.Chr__02      /* Propios o Terceros */
        AND almrepos.CodAlm = Almmmate.codalm 
        AND almrepos.AlmPed <> Almmmate.codalm
        AND pReposicion > 0 /* <<< OJO <<< */
        BY almrepos.Orden:
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codmat = Almmmate.codmat
            AND B-MATE.codalm = Almrepos.almped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN NEXT.
        RUN gn/stock-comprometido (Almmmate.codmat, Almrepos.almped, OUTPUT pComprometido).
        x-StockDisponible = B-MATE.StkAct - x-StockMinimo - pComprometido.
        IF x-StockDisponible <= 0 THEN DO:
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Item = almrepos.orden
                T-DREPO.AlmPed = Almrepos.almped
                T-DREPO.CanReq = x-CanReq
                T-DREPO.StkAct = x-StockDisponible
                T-DREPO.CanGen = pReposicion.
            NEXT.
        END.
        /* Se solicitará la reposición de acuerdo al empaque del producto */
        x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
        IF Almmmatg.CanEmp > 0 THEN DO:
            x-CanReq = TRUNCATE(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq <= 0 THEN DO:
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Item = almrepos.orden
                T-DREPO.AlmPed = Almrepos.almped
                T-DREPO.CanReq = x-CanReq
                T-DREPO.StkAct = x-StockDisponible
                T-DREPO.CanGen = pReposicion.
            NEXT.    /* Menos que la cantidad por empaque */
        END.
        /* Redondeamos la cantidad a enteros */
        IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
            x-CanReq = TRUNCATE(x-CanReq,0) + 1.
        END.
         
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Item = almrepos.orden
            T-DREPO.AlmPed = Almrepos.almped
            T-DREPO.CanReq = x-CanReq
            T-DREPO.StkAct = x-StockDisponible
            T-DREPO.CanGen = pReposicion.
        ASSIGN
            pReposicion = pReposicion - T-DREPO.CanReq.
            
    END.
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
  DISPLAY x-CodAlm x-CodMat x-StkAct pVentaDiaria x-StockMinimo pReposicion 
          x-CanEmp pCodAlm 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE x-CodAlm x-CodMat BUTTON-5 BUTTON-3 BROWSE-2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
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

