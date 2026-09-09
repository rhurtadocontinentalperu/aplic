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
DEFINE BUFFER T-MATE FOR Almmmate.

/*******/
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR F-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreIng  AS DECIMAL FORMAT "(>>,>>>,>>9.9999)" NO-UNDO.
DEFINE VAR F-TotIng  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreSal  AS DECIMAL FORMAT "(>>,>>>,>>9.9999)" NO-UNDO.
DEFINE VAR F-TotSal  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-VALCTO  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-STKGEN  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PRECIO  AS DECIMAL FORMAT "(>,>>>,>>9.9999)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR S-SUBTIT2  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR S-SUBTIT3  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR S-SUBTIT4  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.


DEFINE VAR I  AS INTEGER.
DEFINE VAR X-CODFAM AS CHAR NO-UNDO.

define buffer b-mate for almmmate.

define temp-table repo
  field codmat like almmmatg.codmat
  field desmat like almmmatg.desmat
  field desmar like almmmatg.desmar
  field codpr1 like almmmatg.codpr1
  field catego like almmmatg.tipart
  field despro like gn-prov.NomPro
  field undbas like almmmatg.undbas
  field codalm like almmmate.codalm
  field almdes like almcmov.almdes
  field stkact like almmmate.stkact
  field stkmin like almmmate.stkmin
  field factor like almmmate.stkmin
  field candes like ccbddocu.candes
  field canate like ccbddocu.candes
  field canocp like ccbddocu.candes.

define temp-table compra
  field codmat like almmmatg.codmat
  field desmat like almmmatg.desmat
  field codpr1 like almmmatg.codpr1
  field despro like gn-prov.NomPro
  field undbas like almmmatg.undbas
  field codalm like almmmate.codalm
  field almdes like almcmov.almdes
  field stkact like almmmate.stkact
  field stkmin like almmmate.stkmin
  field factor like almmmate.stkmin
  field candes like ccbddocu.candes
  field canate like ccbddocu.candes
  field canocp like ccbddocu.candes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-58 RECT-57 F-CodFam F-CodAlm F-AlmDes ~
R-Tipo Btn_OK F-DiaRep Btn_Cancel F-Items 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-CodAlm F-AlmDes R-Tipo F-DiaRep ~
F-Items 

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

DEFINE VARIABLE F-AlmDes AS CHARACTER FORMAT "X(3)":U INITIAL "83" 
     LABEL "Alm Despacho" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "03,04,05" 
     LABEL "Alm.Solicitante" 
     VIEW-AS FILL-IN 
     SIZE 36.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "000,001,002" 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .69 NO-UNDO.

DEFINE VARIABLE F-DiaRep AS INTEGER FORMAT ">9":U INITIAL 5 
     LABEL "Dias de Reposicion" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69 NO-UNDO.

DEFINE VARIABLE F-Items AS INTEGER FORMAT ">9":U INITIAL 15 
     LABEL "# Items x Requerimiento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.72 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 60 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.57 BY 6.35.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23.43 BY 1.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.85 COL 18 COLON-ALIGNED
     F-CodAlm AT ROW 2.69 COL 18 COLON-ALIGNED
     F-AlmDes AT ROW 3.5 COL 18 COLON-ALIGNED
     R-Tipo AT ROW 5.23 COL 20 NO-LABEL
     Btn_OK AT ROW 7.88 COL 35
     F-DiaRep AT ROW 3.5 COL 48.86 COLON-ALIGNED
     Btn_Cancel AT ROW 7.88 COL 47.43
     F-Items AT ROW 6.23 COL 49.72 COLON-ALIGNED
     RECT-58 AT ROW 5.96 COL 33.57
     RECT-46 AT ROW 7.73 COL 1
     RECT-57 AT ROW 1.23 COL 1.14
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 5.85 COL 12
          FONT 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 10.92
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
         TITLE              = "Requerimiento de Mercaderia"
         HEIGHT             = 8.5
         WIDTH              = 60
         MAX-HEIGHT         = 20.31
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.31
         VIRTUAL-WIDTH      = 114.29
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
ON END-ERROR OF W-Win /* Requerimiento de Mercaderia */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Requerimiento de Mercaderia */
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


&Scoped-define SELF-NAME F-AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-AlmDes W-Win
ON LEAVE OF F-AlmDes IN FRAME F-Main /* Alm Despacho */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
    DO I = 1 To NUM-ENTRIES(SELF:SCREEN-VALUE):
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND  
                        Almacen.codalm = ENTRY(I,SELF:SCREEN-VALUE) 
                        NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE "Codigo " + ENTRY(I,SELF:SCREEN-VALUE) + " no Existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.                            
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodAlm W-Win
ON LEAVE OF F-CodAlm IN FRAME F-Main /* Alm.Solicitante */
DO:

   IF SELF:SCREEN-VALUE = "" THEN RETURN.
    DO I = 1 To NUM-ENTRIES(SELF:SCREEN-VALUE):
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND  
                        Almacen.codalm = ENTRY(I,SELF:SCREEN-VALUE) 
                        NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE "Codigo " + ENTRY(I,SELF:SCREEN-VALUE) + " no Existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.                            
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Linea */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
    DO I = 1 To NUM-ENTRIES(SELF:SCREEN-VALUE):
     FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND  
                         Almtfami.codfam = ENTRY(I,SELF:SCREEN-VALUE) 
                         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE AlmtFami THEN DO:
        MESSAGE "Codigo " + ENTRY(I,SELF:SCREEN-VALUE) + " no Existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.                            
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
  ASSIGN F-Codalm F-AlmDes F-CodFam R-Tipo F-Diarep.
  IF F-Codalm = "" THEN DO:
    MESSAGE "Almacen no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" To F-Codfam.
    RETURN NO-APPLY.
  END.

  IF F-AlmDes = "" THEN DO:
    MESSAGE "Almacen Despacho no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" To F-AlmDes.
    RETURN NO-APPLY.
  END.
  X-CODFAM = "".
  IF F-CodFam = "" THEN DO:
     FOR EACH Almtfami WHERE Almtfami.Codcia = S-CODCIA :
        IF X-CODFAM = "" THEN X-CODFAM = Almtfami.Codfam.
        ELSE X-CODFAM = X-CODFAM + "," + Almtfami.Codfam.
     END.
  END.
  ELSE X-CODFAM = F-CodFam.
  
     
  S-SUBTIT = "Lineas Evaluadas " + X-Codfam .
  S-SUBTIT2 = "Almacen Solicitante " + F-Codalm.
  S-SUBTIT3 = "Almacen Despacho    " + F-AlmDes.
  S-SUBTIT4 = "Dias de Reposicion  " + STRING(F-DiaRep,"99").
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-DISPO AS DECI INIT 0 NO-UNDO.
DEFINE VAR II AS INTEGER NO-UNDO.
DEFINE VAR X-FACTOR AS DECI INIT 0 NO-UNDO.
DEFINE VAR X-CANDES AS DECI INIT 0 NO-UNDO.
DEFINE VAR X-TOT    AS DECI INIT 0 NO-UNDO.

x-factor = f-diarep.

do I = 1 to num-entries(x-codfam):
    for each almmmatg no-lock where almmmatg.codcia = s-codcia and
                            almmmatg.codfam = ENTRY(I,x-codfam) and
                            almmmatg.tpoart BEGINS R-Tipo :
        /*****Inicia Almacenes de Tiendas Vs Almacen Central*********************/
        x-dispo = 0.
        find b-mate where b-mate.codcia = s-codcia and
                          b-mate.codalm = TRIM(f-almdes) and
                          b-mate.codmat = almmmatg.codmat
                          no-lock no-error.
        if available b-mate and b-mate.stkact > 0 then x-dispo = b-mate.stkact.
        if x-dispo > 0 then do:
            do ii = 1 to num-entries(f-codalm):
               find almmmate where almmmate.codcia = s-codcia and
                                   almmmate.codalm = entry(ii,f-codalm) and
                                   almmmate.codmat = almmmatg.codmat 
                                   no-lock no-error.
               if available almmmate and almmmate.stkact < almmmate.stkmin * x-factor then do:
                     IF ROUND(((almmmate.stkmin * x-factor) - almmmate.stkact),0) > 0 THEN DO:
                        find repo where repo.codmat = almmmatg.codmat and
                                        repo.codalm = entry(ii,f-codalm) and
                                        repo.almdes = f-almdes
                                        no-error.
                        if not available repo then do:
                           create repo.
                           assign
                           repo.codmat = almmmatg.codmat
                           repo.desmat = almmmatg.desmat
                           repo.desmar = almmmatg.desmar
                           repo.undbas = almmmatg.undbas
                           repo.codpr1 = almmmatg.codpr1
                           repo.codalm = entry(ii,f-codalm)
                           repo.factor = x-factor
                           repo.almdes = f-almdes
                           repo.stkmin = almmmate.stkmin
                           repo.stkact = almmmate.stkact
                           repo.catego = almmmatg.tipart
                           repo.candes = ROUND(((almmmate.stkmin * x-factor) - almmmate.stkact),0).
   .
   
                        end.
   
                        x-candes = ROUND(((almmmate.stkmin * x-factor) - almmmate.stkact),0) .
   
                        if x-dispo > 0 then do:
                           if x-dispo < x-candes then x-candes = x-dispo.
   
                           x-dispo = x-dispo - x-candes.
                           repo.canate = x-candes.
                        end.
                     END.
               end.

            end.
        end.
        /*****Fin Almacenes de Tiendas Vs Almacen Central*********************/
    end.
end.

x-tot = 0.
for each repo where repo.canate < repo.candes
                    break by repo.codmat :

    x-tot = x-tot + repo.candes - repo.canate.
    if last-of(repo.codmat) then do:
        create compra.
        assign
        compra.codmat = repo.codmat
        compra.desmat = repo.desmat
        compra.undbas = repo.undbas
        compra.codpr1 = repo.codpr1
        compra.canate = x-tot.
        x-tot = 0.
    end.

end.








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
  DISPLAY F-CodFam F-CodAlm F-AlmDes R-Tipo F-DiaRep F-Items 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-58 RECT-57 F-CodFam F-CodAlm F-AlmDes R-Tipo Btn_OK F-DiaRep 
         Btn_Cancel F-Items 
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

  RUN Carga-Datos.
  
  DEFINE FRAME F-REPORTE
         repo.codmat AT 5 
         repo.desmat
         repo.desmar format "x(12)"
         repo.undbas
         repo.catego
         repo.canate formaT "->>>>>>>>>>9"
         repo.stkmin formaT "->>>>>>>>>>9"
         repo.stkact formaT "->>>>>>>>>>9"
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
                
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "REQUERIMIENTO DE MERCADERIA" AT 30
         "Pagina :" TO 108 PAGE-NUMBER(REPORT) TO 120 FORMAT "ZZZZZ9" SKIP
         "Fecha :" TO 108 TODAY TO 120 FORMAT "99/99/9999" SKIP
         "Hora :" TO 108 STRING(TIME,"HH:MM") TO 120 SKIP
         S-SUBTIT  AT 1       SKIP
         S-SUBTIT2 AT 1       SKIP
         S-SUBTIT3 AT 1       SKIP
         S-SUBTIT4 AT 1       SKIP
         "---------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod                                                                                                  Stock   Stock   " SKIP
         "Alm       Articulo                                    Marca          UM  Cat.    Cantidad            Minimo  Actual ." SKIP
         "---------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
       

  FOR EACH Repo WHERE Repo.canate > 0 break by 
                      Repo.Codalm by
                      Repo.Codmat :
            

      DISPLAY Repo.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" 
              WITH FRAME F-Proceso.
              
      VIEW STREAM REPORT FRAME F-HEADER.
            
      IF FIRST-OF(Repo.Codalm) THEN DO:
         FIND Almacen WHERE ALmacen.Codcia = S-CODCIA AND
                            Almacen.CodAlm = Repo.Codalm
                            NO-LOCK NO-ERROR.
         PUT STREAM REPORT Repo.Codalm FORMAT "X(3)" AT 1.
         PUT STREAM REPORT Almacen.Descripcion FORMAT "X(40)" AT 5 SKIP.
         PUT STREAM REPORT "--------------------------------------"  FORMAT "X(45)" AT 1 SKIP.                                    
                            
      END.
      
      
      DISPLAY STREAM REPORT 
               Repo.Codmat
               Repo.Desmat
               Repo.Desmar
               Repo.Undbas
               Repo.Canate
               repo.stkmin
               repo.stkact
               repo.catego
               WITH FRAME F-REPORTE.
      

  
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
    ENABLE ALL .
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
  ASSIGN F-CodFam F-Codalm F-Almdes R-Tipo F-Diarep F-Items .
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
     R-Tipo = ''.
     DISPLAY R-Tipo.
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
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


