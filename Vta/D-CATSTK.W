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
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

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
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS f-familia f-subfam f-marca R-Tipo C-Filtro ~
C-Orden C-Sortea Btn_OK Btn_Cancel RECT-58 RECT-59 RECT-60 
&Scoped-Define DISPLAYED-OBJECTS x-mensaje f-familia f-desfam f-subfam ~
f-dessub f-marca f-desmar R-Tipo C-Filtro C-Orden C-Sortea 

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

DEFINE VARIABLE C-Filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Linea" 
     LABEL "Quiebre" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Linea","Linea-Sublinea","Marca" 
     DROP-DOWN-LIST
     SIZE 13.14 BY .81 NO-UNDO.

DEFINE VARIABLE C-Orden AS CHARACTER FORMAT "X(256)":U INITIAL "Codigo" 
     LABEL "Orden" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Codigo","Descripcion" 
     DROP-DOWN-LIST
     SIZE 11.57 BY .81 NO-UNDO.

DEFINE VARIABLE C-Sortea AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Con-Stock","Sin-Stock" 
     DROP-DOWN-LIST
     SIZE 11.57 BY .81 NO-UNDO.

DEFINE VARIABLE f-desfam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-desmar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-dessub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-familia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69 NO-UNDO.

DEFINE VARIABLE f-subfam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Linea" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 33 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 4.69.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 2.42.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 59 BY 1.77
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-mensaje AT ROW 7.19 COL 1.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     f-familia AT ROW 1.58 COL 11.86 COLON-ALIGNED
     f-desfam AT ROW 1.58 COL 18.72 COLON-ALIGNED NO-LABEL
     f-subfam AT ROW 2.31 COL 11.86 COLON-ALIGNED
     f-dessub AT ROW 2.31 COL 18.72 COLON-ALIGNED NO-LABEL
     f-marca AT ROW 3.08 COL 11.86 COLON-ALIGNED
     f-desmar AT ROW 3.08 COL 18.72 COLON-ALIGNED NO-LABEL
     R-Tipo AT ROW 4.08 COL 14 NO-LABEL
     C-Filtro AT ROW 6 COL 8 COLON-ALIGNED
     C-Orden AT ROW 6 COL 28 COLON-ALIGNED
     C-Sortea AT ROW 6 COL 46.43 COLON-ALIGNED
     Btn_OK AT ROW 8.42 COL 37.72
     Btn_Cancel AT ROW 8.42 COL 49.14
     "Estado" VIEW-AS TEXT
          SIZE 6 BY .69 AT ROW 4.23 COL 7
          FONT 1
     RECT-58 AT ROW 1.15 COL 2
     RECT-59 AT ROW 5.85 COL 2
     RECT-60 AT ROW 8.27 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.14 BY 9.31
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
         TITLE              = "Catalogo de Stock"
         HEIGHT             = 9.31
         WIDTH              = 61.14
         MAX-HEIGHT         = 9.31
         MAX-WIDTH          = 61.14
         VIRTUAL-HEIGHT     = 9.31
         VIRTUAL-WIDTH      = 61.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
   Custom                                                               */
/* SETTINGS FOR FILL-IN f-desfam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-desmar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-dessub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Catalogo de Stock */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Catalogo de Stock */
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


&Scoped-define SELF-NAME f-familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-familia W-Win
ON LEAVE OF f-familia IN FRAME F-Main /* Linea */
DO:
  assign f-familia.
  IF F-familia <> "" THEN DO: 
     FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND Almtfami.Codfam = F-familia NO-LOCK NO-ERROR.
     IF AVAILABLE Almtfami THEN F-desfam = Almtfami.desfam.
  END.
  DISPLAY F-desfam WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-marca W-Win
ON LEAVE OF f-marca IN FRAME F-Main /* Marca */
DO:
  assign f-marca.
  IF f-marca <> "" THEN DO: 
     FIND AlmTabla WHERE AlmTabla.tabla = "MK" AND AlmTabla.codigo = f-marca NO-LOCK NO-ERROR.
     IF AVAILABLE AlmTabla THEN F-desmar = AlmTabla.Nombre.
  END.
  DISPLAY f-desmar WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-subfam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-subfam W-Win
ON LEAVE OF f-subfam IN FRAME F-Main /* Sub-Linea */
DO:
  assign f-subfam.
  IF f-subfam <> "" THEN DO: 
     FIND AlmSfami WHERE AlmSfami.CodCia = S-CODCIA AND AlmSfami.Codfam = f-familia AND
     AlmSFami.subfam = f-subfam NO-LOCK NO-ERROR.
     IF AVAILABLE AlmSfami THEN F-dessub = AlmSFami.dessub.
  END.
  DISPLAY F-dessub WITH FRAME {&FRAME-NAME}.
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
  ASSIGN F-familia F-subfam F-marca C-Sortea C-Filtro R-Tipo C-Orden.

END.

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
  DISPLAY x-mensaje f-familia f-desfam f-subfam f-dessub f-marca f-desmar R-Tipo 
          C-Filtro C-Orden C-Sortea 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE f-familia f-subfam f-marca R-Tipo C-Filtro C-Orden C-Sortea Btn_OK 
         Btn_Cancel RECT-58 RECT-59 RECT-60 
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
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct <> 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.CodMat :

     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */
     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.
  
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
        Almmmatg.TipArt
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-C-L-Des W-Win 
PROCEDURE Formato-C-L-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct <> 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Desmat 
           ON ERROR UNDO, LEAVE:
     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

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
        Almmmatg.TipArt
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-C-LS-Codigo W-Win 
PROCEDURE Formato-C-LS-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct <> 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Subfam
           BY Almmmatg.CodMat :
    
     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */
     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

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
      /*********  x SubFamilia  **********/
      X-DesSub = "".
      IF FIRST-OF(Almmmatg.Subfam) THEN DO:
         FIND AlmSfami WHERE AlmSfami.Codcia = S-CODCIA AND 
                             AlmSfami.CodFam = Almmmatg.CodFam AND 
                             AlmSfami.Subfam = Almmmatg.Subfam 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmSfami THEN X-dessub = AlmSfami.DesSub.                    
         DISPLAY STREAM REPORT
         Almmmatg.SubFam + "- " + CAPS(X-Dessub) @ Almmmatg.desmat  WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Subfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.
     IF LAST-OF(Almmmatg.Codfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-C-LS-Des W-Win 
PROCEDURE Formato-C-LS-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct <> 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Subfam
           BY Almmmatg.Desmat :
     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

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
      /*********  x SubFamilia  **********/
      X-DesSub = "".
      IF FIRST-OF(Almmmatg.Subfam) THEN DO:
         FIND AlmSfami WHERE AlmSfami.Codcia = S-CODCIA AND 
                             AlmSfami.CodFam = Almmmatg.CodFam AND 
                             AlmSfami.Subfam = Almmmatg.Subfam 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmSfami THEN X-dessub = AlmSfami.DesSub.                    
         DISPLAY STREAM REPORT
         Almmmatg.SubFam + "- " + CAPS(X-Dessub) @ Almmmatg.desmat  WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Subfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.
     IF LAST-OF(Almmmatg.Codfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-C-M-Codigo W-Win 
PROCEDURE Formato-C-M-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct <> 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.CodMar
           BY Almmmatg.CodMat 
           ON ERROR UNDO, LEAVE:
     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  x Marca  ***********/
      IF FIRST-OF(Almmmatg.Codmar) THEN DO:
         X-desmar = "".
         FIND AlmTabla WHERE AlmTabla.tabla = "MK" AND 
                             AlmTabla.codigo = Almmmatg.CodMar 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN X-desmar = AlmTabla.Nombre.
      
         DISPLAY STREAM REPORT
         {&PRN2} + {&PRN6A} + Almmmatg.Codmar + "- " + CAPS(X-desmar) + {&PRN6B} + {&PRN4} @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
      
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Codmar) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-C-M-Des W-Win 
PROCEDURE Formato-C-M-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct <> 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.CodMar
           BY Almmmatg.Desmat 
           ON ERROR UNDO, LEAVE:

     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  x Marca  ***********/
      IF FIRST-OF(Almmmatg.Codmar) THEN DO:
         X-desmar = "".
         FIND AlmTabla WHERE AlmTabla.tabla = "MK" AND 
                             AlmTabla.codigo = Almmmatg.CodMar 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN X-desmar = AlmTabla.Nombre.
      
         DISPLAY STREAM REPORT
         {&PRN2} + {&PRN6A} + Almmmatg.Codmar + "- " + CAPS(X-desmar) + {&PRN6B} + {&PRN4} @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
      
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Codmar) THEN DO:
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
  CASE C-FILTRO:
       WHEN "Linea" THEN DO:
            CASE C-ORDEN:
                 WHEN "Codigo" THEN RUN Formato-C-L-Codigo.
                 WHEN "Descripcion" THEN RUN Formato-C-L-Des.
            END.
       END.
       WHEN "Linea-Sublinea" THEN DO:
            CASE C-ORDEN:
                 WHEN "Codigo" THEN RUN Formato-C-LS-Codigo.
                 WHEN "Descripcion" THEN RUN Formato-C-LS-Des.
            END.
       END.
       WHEN "Marca" THEN DO:
            CASE C-ORDEN:
                 WHEN "Codigo" THEN RUN Formato-C-M-Codigo.
                 WHEN "Descripcion" THEN RUN Formato-C-M-Des.
            END.
       END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-S-L-Codigo W-Win 
PROCEDURE Formato-S-L-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct = 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.CodMat :

     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.
  
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
        Almmmatg.TipArt
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-S-L-Des W-Win 
PROCEDURE Formato-S-L-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct = 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Desmat: 

     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

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
        Almmmatg.TipArt
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-S-LS-Codigo W-Win 
PROCEDURE Formato-S-LS-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct = 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Subfam
           BY Almmmatg.CodMat: 
    /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
    */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

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
      /*********  x SubFamilia  **********/
      X-DesSub = "".
      IF FIRST-OF(Almmmatg.Subfam) THEN DO:
         FIND AlmSfami WHERE AlmSfami.Codcia = S-CODCIA AND 
                             AlmSfami.CodFam = Almmmatg.CodFam AND 
                             AlmSfami.Subfam = Almmmatg.Subfam 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmSfami THEN X-dessub = AlmSfami.DesSub.                    
         DISPLAY STREAM REPORT
         Almmmatg.SubFam + "- " + CAPS(X-Dessub) @ Almmmatg.desmat  WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Subfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.
     IF LAST-OF(Almmmatg.Codfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-S-LS-Des W-Win 
PROCEDURE Formato-S-LS-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct = 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Subfam
           BY Almmmatg.Desmat: 

     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     VIEW STREAM REPORT FRAME F-HEADER.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.
     
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
      /*********  x SubFamilia  **********/
      X-DesSub = "".
      IF FIRST-OF(Almmmatg.Subfam) THEN DO:
         FIND AlmSfami WHERE AlmSfami.Codcia = S-CODCIA AND 
                             AlmSfami.CodFam = Almmmatg.CodFam AND 
                             AlmSfami.Subfam = Almmmatg.Subfam 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmSfami THEN X-dessub = AlmSfami.DesSub.                    
         DISPLAY STREAM REPORT
         Almmmatg.SubFam + "- " + CAPS(X-Dessub) @ Almmmatg.desmat  WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Subfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.
     IF LAST-OF(Almmmatg.Codfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-S-M-Codigo W-Win 
PROCEDURE Formato-S-M-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct = 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.CodMar
           BY Almmmatg.CodMat 
           ON ERROR UNDO, LEAVE:
     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  x Marca  ***********/
      IF FIRST-OF(Almmmatg.Codmar) THEN DO:
         X-desmar = "".
         FIND AlmTabla WHERE AlmTabla.tabla = "MK" AND 
                             AlmTabla.codigo = Almmmatg.CodMar 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN X-desmar = AlmTabla.Nombre.
      
         DISPLAY STREAM REPORT
         {&PRN2} + {&PRN6A} + Almmmatg.Codmar + "- " + CAPS(X-desmar) + {&PRN6B} + {&PRN4} @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
      
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Codmar) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-S-M-Des W-Win 
PROCEDURE Formato-S-M-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM AND
                         Almmmate.StkAct = 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.CodMar
           BY Almmmatg.Desmat 
           ON ERROR UNDO, LEAVE:
     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  x Marca  ***********/
      IF FIRST-OF(Almmmatg.Codmar) THEN DO:
         X-desmar = "".
         FIND AlmTabla WHERE AlmTabla.tabla = "MK" AND 
                             AlmTabla.codigo = Almmmatg.CodMar 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN X-desmar = AlmTabla.Nombre.
      
         DISPLAY STREAM REPORT
         {&PRN2} + {&PRN6A} + Almmmatg.Codmar + "- " + CAPS(X-desmar) + {&PRN6B} + {&PRN4} @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
      
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Codmar) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Sin W-Win 
PROCEDURE Formato-Sin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  CASE C-FILTRO:
       WHEN "Linea" THEN DO:
            CASE C-ORDEN:
                 WHEN "Codigo" THEN RUN Formato-S-L-Codigo.
                 WHEN "Descripcion" THEN RUN Formato-S-L-Des.
            END.
       END.
       WHEN "Linea-Sublinea" THEN DO:
            CASE C-ORDEN:
                 WHEN "Codigo" THEN RUN Formato-S-LS-Codigo.
                 WHEN "Descripcion" THEN RUN Formato-S-LS-Des.
            END.
       END.
       WHEN "Marca" THEN DO:
            CASE C-ORDEN:
                 WHEN "Codigo" THEN RUN Formato-S-M-Codigo.
                 WHEN "Descripcion" THEN RUN Formato-S-M-Des.
            END.
       END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-T-L-Codigo W-Win 
PROCEDURE Formato-T-L-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.CodMat :

     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

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
        Almmmatg.TipArt
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-T-L-Des W-Win 
PROCEDURE Formato-T-L-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Desmat :
     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

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
        Almmmatg.TipArt
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-T-LS-Codigo W-Win 
PROCEDURE Formato-T-LS-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Subfam
           BY Almmmatg.CodMat :

     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

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
      /*********  x SubFamilia  **********/
      X-DesSub = "".
      IF FIRST-OF(Almmmatg.Subfam) THEN DO:
         FIND AlmSfami WHERE AlmSfami.Codcia = S-CODCIA AND 
                             AlmSfami.CodFam = Almmmatg.CodFam AND 
                             AlmSfami.Subfam = Almmmatg.Subfam 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmSfami THEN X-dessub = AlmSfami.DesSub.                    
         DISPLAY STREAM REPORT
         Almmmatg.SubFam + "- " + CAPS(X-Dessub) @ Almmmatg.desmat  WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Subfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.
     IF LAST-OF(Almmmatg.Codfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-T-LS-Des W-Win 
PROCEDURE Formato-T-LS-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Codfam
           BY Almmmatg.Subfam
           BY Almmmatg.Desmat: 
     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

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
      /*********  x SubFamilia  **********/
      X-DesSub = "".
      IF FIRST-OF(Almmmatg.Subfam) THEN DO:
         FIND AlmSfami WHERE AlmSfami.Codcia = S-CODCIA AND 
                             AlmSfami.CodFam = Almmmatg.CodFam AND 
                             AlmSfami.Subfam = Almmmatg.Subfam 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmSfami THEN X-dessub = AlmSfami.DesSub.                    
         DISPLAY STREAM REPORT
         Almmmatg.SubFam + "- " + CAPS(X-Dessub) @ Almmmatg.desmat  WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Subfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.
     IF LAST-OF(Almmmatg.Codfam) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-T-M-Codigo W-Win 
PROCEDURE Formato-T-M-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.CodMar
           BY Almmmatg.CodMat 
           ON ERROR UNDO, LEAVE:

     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     */

     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  x Marca  ***********/
      IF FIRST-OF(Almmmatg.Codmar) THEN DO:
         X-desmar = "".
         FIND AlmTabla WHERE AlmTabla.tabla = "MK" AND 
                             AlmTabla.codigo = Almmmatg.CodMar 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN X-desmar = AlmTabla.Nombre.
      
         DISPLAY STREAM REPORT
         {&PRN2} + {&PRN6A} + Almmmatg.Codmar + "- " + CAPS(X-desmar) + {&PRN6B} + {&PRN4} @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
      
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Codmar) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-T-M-Des W-Win 
PROCEDURE Formato-T-M-Des :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME F-REPORTE
        Almmmatg.TipArt           FORMAT 'X'
        Almmmate.CodMat    AT 3   FORMAT "X(6)"
        Almmmatg.DesMat    /*AT 10*/  FORMAT "X(50)"
        Almmmatg.DesMar    /*AT 61*/  FORMAT "X(15)"
        Almmmatg.UndBas    /*AT 78*/  FORMAT "X(10)"
        Almmmate.FacEqu    /*AT 84*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    /*AT 100*/  FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    /*AT 119*/ FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    /*AT 134*/ FORMAT "->,>>>,>>9.99"
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 /*FORMAT "X(10)"*/ PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + S-CODALM + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 /*FORMAT "X(10)"*/ STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "   CODIGO                                                                                  F A C T O R             S    T    O    C    K    S      " SKIP
        "  ARTICULO  D E S C R I P C I O N                               MARCA           UNIDAD     EQUIVALENCIA    A C T U A L   M I N I M O   M A X I M O " SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
/*                1         2         3         4         5         6         7         8         9
         123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         1 1234567890 12345678901234567890123456789012345678901234567890 123456789012345 1234567890 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 
*/         
        WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = S-CODALM 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.Codfam BEGINS f-familia AND 
                         Almmmatg.Subfam BEGINS f-subfam AND
                         Almmmatg.Codmar BEGINS f-marca  AND
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.CodMar
           BY Almmmatg.Desmat 
           ON ERROR UNDO, LEAVE:

     /*
     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
             */
     DISPLAY "Codigo de Articulo: " + Almmmate.CodMat @ x-mensaje
         WITH FRAME {&FRAME-NAME}.

     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  x Marca  ***********/
      IF FIRST-OF(Almmmatg.Codmar) THEN DO:
         X-desmar = "".
         FIND AlmTabla WHERE AlmTabla.tabla = "MK" AND 
                             AlmTabla.codigo = Almmmatg.CodMar 
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN X-desmar = AlmTabla.Nombre.
      
         DISPLAY STREAM REPORT
         {&PRN2} + {&PRN6A} + Almmmatg.Codmar + "- " + CAPS(X-desmar) + {&PRN6B} + {&PRN4} @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
      
     DISPLAY STREAM REPORT
        Almmmatg.TipArt
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Codmar) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
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
  CASE C-FILTRO:
       WHEN "Linea" THEN DO:
            CASE C-ORDEN:
                 WHEN "Codigo" THEN RUN Formato-T-L-Codigo.
                 WHEN "Descripcion" THEN RUN Formato-T-L-Des.
            END.
       END.
       WHEN "Linea-Sublinea" THEN DO:
            CASE C-ORDEN:
                 WHEN "Codigo" THEN RUN Formato-T-LS-Codigo.
                 WHEN "Descripcion" THEN RUN Formato-T-LS-Des.
            END.
       END.
       WHEN "Marca" THEN DO:
            CASE C-ORDEN:
                 WHEN "Codigo" THEN RUN Formato-T-M-Codigo.
                 WHEN "Descripcion" THEN RUN Formato-T-M-Des.
            END.
       END.
        
  
  
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
    ENABLE ALL EXCEPT F-DesFam F-DesSub F-desmar x-mensaje.
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
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
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
  ASSIGN F-familia F-subfam F-marca C-Sortea C-Filtro R-Tipo C-orden.

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
     ASSIGN F-familia = ""
            F-Subfam  = ""
            F-Marca   =  "" .
            
     DISPLAY F-familia F-subfam F-marca.
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
    
    /*Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "F-marca" THEN input-var-1 = "MK".
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-familia:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca"  THEN ASSIGN input-var-1 = "MK".
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

