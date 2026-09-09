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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.

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

/*******/
/*DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.*/

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE T-TITULO AS CHAR INIT "".
DEFINE VARIABLE T-TITUL1 AS CHAR INIT "".
DEFINE VARIABLE T-FAMILI AS CHAR INIT "".
DEFINE VARIABLE T-SUBFAM AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-DESMAR AS CHAR INIT "".
DEFINE VARIABLE X-DESFAM AS CHAR INIT "".
DEFINE VARIABLE X-DESSUB AS CHAR INIT "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-61 RECT-62 f-almacen l-catego C-Orden ~
C-Sortea Btn_OK R-Tipo-2 Btn_Cancel R-Tipo 
&Scoped-Define DISPLAYED-OBJECTS f-almacen l-catego C-Orden C-Sortea ~
R-Tipo-2 R-Tipo 

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

DEFINE VARIABLE C-Orden AS CHARACTER FORMAT "X(256)":U INITIAL "Codigo" 
     LABEL "Orden" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Codigo","Descripcion" 
     SIZE 13.29 BY .81 NO-UNDO.

DEFINE VARIABLE C-Sortea AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Con-Stock","Sin-Stock" 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE f-almacen AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .81 NO-UNDO.

DEFINE VARIABLE l-catego AS CHARACTER FORMAT "X(2)":U 
     LABEL "Categ.Contable" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.14 BY 1.73 NO-UNDO.

DEFINE VARIABLE R-Tipo-2 AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ambos", "",
"Con Stocks", "C",
"Sin Stocks", "S"
     SIZE 11.29 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 13.43 BY 3.23.

DEFINE RECTANGLE RECT-62
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 14.72 BY 3.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-almacen AT ROW 1.5 COL 11.57 COLON-ALIGNED
     l-catego AT ROW 2.54 COL 11.72 COLON-ALIGNED
     C-Orden AT ROW 3.69 COL 11.86 COLON-ALIGNED
     C-Sortea AT ROW 4.85 COL 12 COLON-ALIGNED
     Btn_OK AT ROW 6.54 COL 15.29
     R-Tipo-2 AT ROW 2.54 COL 32.29 NO-LABEL
     Btn_Cancel AT ROW 6.5 COL 34.14
     R-Tipo AT ROW 2.62 COL 48.43 NO-LABEL
     RECT-61 AT ROW 1.35 COL 47.86
     "Stocks" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 1.5 COL 31.86
          FONT 1
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 1.5 COL 48.72
          FONT 1
     RECT-62 AT ROW 1.38 COL 30.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.29 BY 7.42
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
         TITLE              = "Articulos x Categoria Contable"
         HEIGHT             = 7.54
         WIDTH              = 61.72
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.29
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
                                                                        */
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
ON END-ERROR OF W-Win /* Articulos x Categoria Contable */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Articulos x Categoria Contable */
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
/*{src/adm/template/cntnrwin.i}*/

/* Include custom  Main Block code for SmartWindows. */

/*{src/adm/template/windowmn.i}*/

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
  ASSIGN  C-Sortea L-CATEGO R-Tipo C-Orden R-Tipo-2.

END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-categoria W-Win 
PROCEDURE carga-categoria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  L-CATEGO = "".
  FOR EACH Almtabla WHERE Almtabla.Tabla  = "CC" :
        IF L-CATEGO = "" THEN L-CATEGO = "   ," + Almtabla.Codigo.
        ELSE L-CATEGO = L-CATEGO + "," + Almtabla.Codigo.
  END.
  DO WITH FRAME {&FRAME-NAME}:
    L-CATEGO:LIST-ITEMS = L-CATEGO.
    L-CATEGO = ENTRY(1,L-CATEGO:LIST-ITEMS).
    DISPLAY L-CATEGO.
  END.
  
/* RUN dispatch IN THIS-PROCEDURE ('open-query':U)  .*/
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-tempo W-Win 
PROCEDURE Carga-tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*DEFINE VAR L-Ubica  AS LOGICAL NO-UNDO INIT YES.
 * DEFINE VAR F-pesini AS DECIMAL NO-UNDO.
 * 
 * IF HastaC = "" THEN HastaC = "999999".
 * I-NROITM = 0.
 * 
 * FOR EACH tmp-report :
 *     DELETE tmp-report.
 * END.
 *     
 * FOR EACH Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
 *                    AND  (Almmmatg.CodMat >= DesdeC  
 *                    AND   Almmmatg.CodMat <= HastaC)
 *                   NO-LOCK USE-INDEX Matg01:
 *     DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Articulo "
 *             FORMAT "X(11)" WITH FRAME F-Proceso.
 *     /* BUSCAMOS SI TIENE MOVIMEINTOS ANTERIORES A DesdeF */
 *     FIND LAST Almdmov WHERE Almdmov.CodCia = Almmmatg.CodCia 
 *                        AND  Almdmov.CodMat = Almmmatg.CodMat 
 *                        AND  Almdmov.FchDoc < DesdeF 
 *                       USE-INDEX Almd02 NO-LOCK NO-ERROR.
 *     /* BUSCAMOS SI TIENE MOVIMEINTOS POSTERIORES A DesdeF */
 *     FIND FIRST DMOV WHERE DMOV.CodCia = Almmmatg.CodCia 
 *                      AND  DMOV.CodMat = Almmmatg.CodMat 
 *                      AND  (DMOV.FchDoc >= DesdeF 
 *                      AND   DMOV.FchDoc <= HastaF)
 *                     USE-INDEX Almd02 NO-LOCK NO-ERROR.
 *     /* SOLO PASAN LOS MATERIALES QUE HAN TENIDO MOVIMIENTO */
 *     IF AVAILABLE Almdmov OR AVAILABLE DMOV THEN DO:
 *        RUN Peso-Inicial(Almmmatg.codmat, OUTPUT F-PesIni).
 *        I-NROITM = I-NROITM + 1.
 *        F-STKGEN = 0.
 *        IF AVAILABLE Almdmov THEN DO:
 *           F-STKGEN = Almdmov.StkAct.
 *           F-VALCTO = IF nCodMon = 1 THEN Almdmov.VctoMn1 ELSE Almdmov.VctoMn2.
 *        END.
 *        F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
 *        F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,2).
 *        /* CREAMOS REGISTRO DE SALDO ANTERIOR */
 *        IF F-STKGEN > 0 THEN DO:
 *           CREATE tmp-report.
 *           ASSIGN tmp-report.Llave-I     = INTEGER(Almmmatg.CodMat)
 *                  tmp-report.Llave-c     = "A"
 *                  tmp-report.Campo-c[1]  = " S.I."
 *                  tmp-report.Campo-c[12] = Almmmatg.DesMat
 *                  tmp-report.Campo-c[11] = Almmmatg.UndStk
 *                  tmp-report.Campo-f[7]  = F-STKGEN
 *                  tmp-report.Campo-f[8]  = F-PRECIO
 *                  tmp-report.Campo-f[9]  = F-VALCTO
 *                  tmp-report.Campo-f[10] = F-PesIni.
 *                  tmp-report.Campo-d[1]  = DesdeF - 1.
 *        END.
 *        FOR EACH DMOV WHERE DMOV.CodCia = Almmmatg.CodCia 
 *                       AND  DMOV.CodMat = Almmmatg.CodMat 
 *                       AND  (DMOV.FchDoc >= DesdeF 
 *                       AND   DMOV.FchDoc <= HastaF)
 *                      USE-INDEX Almd02 NO-LOCK:
 *            FIND Almcmov WHERE Almcmov.CodCia = DMOV.CodCia 
 *                          AND  Almcmov.CodAlm = DMOV.CodAlm 
 *                          AND  Almcmov.TipMov = DMOV.TipMov 
 *                          AND  Almcmov.CodMov = DMOV.CodMov 
 *                          AND  Almcmov.NroDoc = DMOV.NroDoc 
 *                         NO-LOCK NO-ERROR.
 *            /* CREAMOS REGISTRO DE MOVIMIENTO */
 *            F-STKGEN = DMOV.StkAct.
 *            F-VALCTO = IF nCodMon = 1 THEN DMOV.VctoMn1 ELSE DMOV.VctoMn2.
 *            F-VALCTO = IF F-STKGEN = 0 THEN 0 ELSE F-VALCTO.
 *            F-PRECIO = IF F-STKGEN = 0 THEN 0 ELSE ROUND(F-VALCTO / F-STKGEN,2).
 *            CREATE tmp-report.
 *            ASSIGN tmp-report.Llave-I    = INTEGER(Almmmatg.CodMat)
 *                   tmp-report.Llave-c    = DMOV.TipMov
 *                   tmp-report.Campo-c[1] = DMOV.CodAlm
 *                   tmp-report.Campo-c[2] = STRING(DMOV.CodMov,"99")
 *                   tmp-report.Campo-c[3] = STRING(DMOV.NroDoc,"999999")
 *                   tmp-report.Campo-f[7] = F-STKGEN
 *                   tmp-report.Campo-f[8] = F-PRECIO
 *                   tmp-report.Campo-f[9] = F-VALCTO
 *                   tmp-report.Campo-c[12] = Almmmatg.DesMat
 *                   tmp-report.Campo-c[11] = Almmmatg.UndStk
 *                   tmp-report.Campo-d[1]  = DMOV.FchDoc.
 *            IF AVAILABLE Almcmov THEN 
 *               ASSIGN tmp-report.Campo-c[4] = Almcmov.CodPro
 *                      tmp-report.Campo-c[5] = Almcmov.CodCli
 *                      tmp-report.Campo-c[6] = IF Almcmov.NroRf1 <> "" THEN Almcmov.NroRf1 ELSE Almcmov.NroRf2.
 *            IF LOOKUP(DMOV.TipMov,"I,U") > 0 THEN 
 *                     ASSIGN tmp-report.Campo-f[1] = DMOV.CanDes 
 *                            tmp-report.Campo-f[2] = DMOV.PreUni 
 *                            tmp-report.Campo-f[3] = DMOV.ImpCto
 *                            tmp-report.Campo-f[10] = DMOV.Candes * DMOV.Pesmat.
 *            IF LOOKUP(DMOV.TipMov,"S,T") > 0 THEN 
 *                     ASSIGN tmp-report.Campo-f[4] = DMOV.CanDes 
 *                            tmp-report.Campo-f[5] = F-PRECIO 
 *                            tmp-report.Campo-f[6] = ROUND(F-PRECIO * DMOV.CanDes,2)
 *                            tmp-report.Campo-f[10] = (DMOV.Candes * DMOV.Pesmat) * -1.
 *        END.
 *     END.
 * END.
 * HIDE FRAME F-PROCESO.*/

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
  DISPLAY f-almacen l-catego C-Orden C-Sortea R-Tipo-2 R-Tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 RECT-62 f-almacen l-catego C-Orden C-Sortea Btn_OK R-Tipo-2 
         Btn_Cancel R-Tipo 
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
  
CASE C-SORTEA :
     WHEN "Todos"  THEN DO: 
          T-TITULO = "  CATALOGO STOCKS DE ARTICULOS ".
          RUN Formato-Todos.
     END.  
     WHEN "Con-Stock" THEN DO:    
          T-TITULO = "CATALOGO DE ARTICULOS CON STOCKS".
          RUN Formato-Con.
     END.     
     WHEN "Sin-Stock" THEN DO: 
          T-TITULO = "CATALOGO DE ARTICULOS SIN STOCKS".
          RUN Formato-Sin.
     END.    
END CASE.           
  
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-C-L-Codigo W-Win 
PROCEDURE Formato-C-L-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmate.CodMat    AT 2   FORMAT "X(6)"
        Almmmatg.DesMat    AT 10  FORMAT "X(50)"
        Almmmatg.DesMar    AT 61  FORMAT "X(15)"
        Almmmatg.UndBas    AT 78  FORMAT "X(4)"
        Almmmate.FacEqu    AT 84  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    AT 100  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    AT 119 FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    AT 134 FORMAT "->,>>>,>>9.99"
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + F-ALMACEN + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO                                                                          F A C T O R                S    T    O    C    K    S           " SKIP
        "ARTICULO  D E S C R I P C I O N                            MARCA       UNIDAD    EQUIVALENCIA     A C T U A L       M I N I M O     M A X I M O  " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = F-ALMACEN AND
                         Almmmate.StkAct <> 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.CodMat :

     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
  
     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  x Familia  ***********/
      X-DesFam = "".
      IF FIRST-OF(Almmmatg.Codfam) THEN DO:
         FIND AlmTfami WHERE AlmTfami.Codcia = S-CODCIA AND 
                             AlmTfami.CodFam = Almmmatg.CodFam
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTfami THEN X-DesFam = AlmTfami.Desfam .                    
         DISPLAY STREAM REPORT
         {&PRN2} + {&PRN6A} + Almmmatg.CodFam + "- " + CAPS(AlmTfami.Desfam) + {&PRN6B} + {&PRN4} @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
          
     DISPLAY STREAM REPORT
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Codfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.
     
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Con W-Win 
PROCEDURE Formato-Con :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Todos W-Win 
PROCEDURE Formato-Todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
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
    ENABLE ALL EXCEPT .
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
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").

/*  IF s-salida-impresion = 1 THEN 
 *      s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".*/
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
  ASSIGN  L-CATEGO C-Sortea R-Tipo R-Tipo-2 C-orden.

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
    
    /*Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "l-catego" THEN input-var-1 = "CC".
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


