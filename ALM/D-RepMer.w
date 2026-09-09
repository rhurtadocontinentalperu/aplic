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
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE VAR S-NROSER AS INTEGER.
DEFINE SHARED VAR S-USER-ID AS CHAR.


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
DEFINE VAR S-SUBTIT5  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR X-Items   AS INTEGER NO-UNDO.


DEFINE VAR I  AS INTEGER.
DEFINE VAR X-CODFAM AS CHAR NO-UNDO.
DEFINE VAR X-STKACT AS DECI NO-UNDO.

define buffer b-mate for almmmate.

define temp-table repo
  field codmat like almmmatg.codmat
  field desmat like almmmatg.desmat
  field desmar like almmmatg.desmar
  field codpr1 like almmmatg.codpr1
  field catego like almmmatg.tipart
  field canemp like almmmatg.canemp
  field catcon like almmmatg.catconta
  field codfam like almmmatg.codfam
  field despro like gn-prov.NomPro
  field undbas AS CHAR FORMAT 'x(7)' /*like almmmatg.undbas*/
  field codalm like almmmate.codalm
  field almdes like almcmov.almdes
  field stkact like almmmate.stkact
  field stkdes like almmmate.stkact
  field stkmin like almmmate.stkmin
  field factor like almmmate.stkmin
  field candes like ccbddocu.candes
  field canate like ccbddocu.candes
  field canocp like ccbddocu.candes.

define temp-table compra
  field codmat like almmmatg.codmat
  field desmat like almmmatg.desmat
  field codpr1 like almmmatg.codpr1
  field catconta like almmmatg.catconta
  field despro like gn-prov.NomPro
  field undbas AS CHAR FORMAT 'x(7)' /*like almmmatg.undbas*/
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
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-57 F-Dias F-AlmDes F-Items R-Tipo ~
T-Trasla TOGGLE-Familia Btn_Genera Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-CodAlm F-Dias F-AlmDes F-Items R-Tipo ~
T-Trasla TOGGLE-Familia FILL-IN-CodFam 

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

DEFINE BUTTON Btn_Genera 
     IMAGE-UP FILE "img\proces":U
     LABEL "Aceptar" 
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

DEFINE VARIABLE F-CodAlm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Alm.Solicitante" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-Dias AS INTEGER FORMAT ">9":U INITIAL 5 
     LABEL "Dias de Reposicion" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69 NO-UNDO.

DEFINE VARIABLE F-Items AS INTEGER FORMAT ">9":U INITIAL 16 
     LABEL "# Items x Requerimiento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER INITIAL "A" 
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
     SIZE 59.57 BY 6.42.

DEFINE VARIABLE T-Trasla AS LOGICAL INITIAL yes 
     LABEL "Considerar unidad de traslado" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Familia AS LOGICAL INITIAL no 
     LABEL "Procesar por Familia" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodAlm AT ROW 1.88 COL 18 COLON-ALIGNED
     F-Dias AT ROW 1.96 COL 46 COLON-ALIGNED
     F-AlmDes AT ROW 2.69 COL 18 COLON-ALIGNED
     F-Items AT ROW 2.73 COL 46 COLON-ALIGNED
     R-Tipo AT ROW 3.65 COL 19.72 NO-LABEL
     T-Trasla AT ROW 5.62 COL 20
     TOGGLE-Familia AT ROW 6.58 COL 20
     FILL-IN-CodFam AT ROW 6.58 COL 45 COLON-ALIGNED
     Btn_Genera AT ROW 7.88 COL 22.57
     Btn_OK AT ROW 7.88 COL 35
     Btn_Cancel AT ROW 7.88 COL 47.43
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 4.15 COL 13
          FONT 1
     RECT-46 AT ROW 7.73 COL 1
     RECT-57 AT ROW 1.27 COL 1.29
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
         TITLE              = "Reposicion de Mercaderia"
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodFam IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Reposicion de Mercaderia */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reposicion de Mercaderia */
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


&Scoped-define SELF-NAME Btn_Genera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Genera W-Win
ON CHOOSE OF Btn_Genera IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  RUN Inhabilita.
  RUN Genera.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
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


&Scoped-define SELF-NAME TOGGLE-Familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-Familia W-Win
ON VALUE-CHANGED OF TOGGLE-Familia IN FRAME F-Main /* Procesar por Familia */
DO:
  ASSIGN {&SELF-NAME}.
  IF {&SELF-NAME} = NO
  THEN ASSIGN
            FILL-IN-CodFam:SCREEN-VALUE = ''
            FILL-IN-CodFam:SENSITIVE = NO.
  ELSE DO:
    ASSIGN
        FILL-IN-CodFam:SENSITIVE = YES.
    APPLY 'ENTRY' TO FILL-IN-CodFam.
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
  ASSIGN F-Codalm F-AlmDes R-Tipo F-Dias F-Items T-Trasla FILL-IN-CodFam TOGGLE-Familia.

  IF F-Codalm = "" THEN DO:
    MESSAGE "Almacen no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" To F-Codalm.
    RETURN 'ADM-ERROR'.
  END.

  IF F-AlmDes = "" THEN DO:
    MESSAGE "Almacen Despacho no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" To F-AlmDes.
    RETURN 'ADM-ERROR'.
  END.
  IF F-Items = 0 THEN DO:
    MESSAGE "Numero de Registros no puede ser Cero" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" To F-Items.
    RETURN 'ADM-ERROR'.
  END.
  IF FILL-IN-CodFam <> ''
  THEN DO:
    FIND Almtfami WHERE Almtfami.codcia = s-codcia
        AND Almtfami.codfam = FILL-IN-CodFam NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami
    THEN DO:
        MESSAGE 'Codigo de familia no registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO FILL-IN-CodFam.
        RETURN 'ADM-ERROR'.
    END.
  END.
     
  S-SUBTIT2 = "Almacen Solicitante " + F-Codalm.
  S-SUBTIT3 = "Almacen Despacho    " + F-AlmDes.
  S-SUBTIT4 = "Dias de Reposicion  " + STRING(F-Dias,"99").
  S-SUBTIT5 = IF T-Trasla Then "Requerimiento considerando unidad de traslado" ELSE "Requerimiento sin considerar unidad de traslado".  
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
  FOR EACH Repo:
   DELETE Repo.
  END.
  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA AND
           Almmmate.CodAlm = S-CODALM AND 
           Almmmate.StkAct < Almmmate.StkMin * F-Dias,
           FIRST Almmmatg OF Almmmate NO-LOCK WHERE Almmmatg.codfam BEGINS FILL-IN-CodFam:
    FIND b-mate WHERE b-mate.codcia = s-codcia AND
                      b-mate.codalm = f-almdes AND
                      b-mate.codmat = Almmmate.CodMat 
                      No-LOCK NO-ERROR.
    x-stkact = IF AVAILABLE b-mate then b-mate.stkact else 0.     
    DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
          FORMAT "X(8)" WITH FRAME F-Proceso.
    FIND repo WHERE 
         repo.codmat = Almmmate.codmat NO-ERROR.
    IF NOT AVAILABLE repo THEN DO:
        IF ROUND(((Almmmate.StkMin * F-Dias - Almmmate.StkAct)),0) > 0 THEN DO:
            CREATE repo.
            ASSIGN
              repo.codmat = almmmatg.codmat
              repo.desmat = almmmatg.desmat
              repo.desmar = almmmatg.desmar
              repo.undbas = almmmatg.undbas
              repo.codpr1 = almmmatg.codpr1
              repo.canemp = almmmatg.canemp
              repo.codfam = almmmatg.codfam
              repo.catcon[1] = almmmatg.catconta[1]
              repo.codalm = f-codalm
              repo.factor = f-dias
              repo.almdes = f-almdes
              repo.stkdes = x-stkact
              repo.stkmin = almmmate.stkmin
              repo.stkact = almmmate.stkact
              repo.catego = almmmatg.tipart
              repo.candes = ROUND(((almmmate.stkmin * f-dias) - almmmate.stkact),0)
              repo.canate = if repo.candes > repo.stkdes then repo.stkdes else repo.candes. 
            IF T-Trasla THEN DO:
               repo.candes = IF repo.candes > repo.canemp then ROUND((repo.candes / repo.canemp ),0) * repo.canemp Else 0.
               repo.canate = if repo.candes > repo.stkdes then (repo.stkdes - (repo.stkdes MODULO repo.canemp )) else repo.candes.                                
            END.
        END.       
    END.
  END.
  HIDE FRAME F-PROCESO.

/*
  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA AND
           Almmmate.CodAlm = S-CODALM AND 
           Almmmate.StkAct < Almmmate.StkMin * F-Dias:
      FIND b-mate WHERE b-mate.codcia = s-codcia AND
                        b-mate.codalm = f-almdes AND
                        b-mate.codmat = Almmmate.CodMat
                        No-LOCK NO-ERROR.
      x-stkact = IF AVAILABLE b-mate then b-mate.stkact else 0.     
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(8)" WITH FRAME F-Proceso.
      FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND
           Almmmatg.codmat = Almmmate.codmat NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatg THEN DO:
            FIND repo WHERE 
                 repo.codmat = Almmmate.codmat NO-ERROR.
            IF NOT AVAILABLE repo THEN DO:
                  IF ROUND(((Almmmate.StkMin * F-Dias - Almmmate.StkAct)),0) > 0 THEN DO:
                           create repo.
                           assign
                           repo.codmat = almmmatg.codmat
                           repo.desmat = almmmatg.desmat
                           repo.desmar = almmmatg.desmar
                           repo.undbas = almmmatg.undbas
                           repo.codpr1 = almmmatg.codpr1
                           repo.canemp = almmmatg.canemp
                           repo.codalm = f-codalm
                           repo.factor = f-dias
                           repo.almdes = f-almdes
                           repo.stkdes = x-stkact
                           repo.stkmin = almmmate.stkmin
                           repo.stkact = almmmate.stkact
                           repo.catego = almmmatg.tipart
                           repo.candes = ROUND(((almmmate.stkmin * f-dias) - almmmate.stkact),0)
                           repo.canate = if repo.candes > repo.stkdes then repo.stkdes else repo.candes. 
                           IF T-Trasla THEN DO:
                              repo.candes = IF repo.candes > repo.canemp then ROUND((repo.candes / repo.canemp ),0) * repo.canemp Else 0.
                              repo.canate = if repo.candes > repo.stkdes then (repo.stkdes - (repo.stkdes MODULO repo.canemp )) else repo.candes.                                
                           END.
                           
                  END.       
            END.
      END.   
  END.
  HIDE FRAME F-PROCESO.
*/
  
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
  DISPLAY F-CodAlm F-Dias F-AlmDes F-Items R-Tipo T-Trasla TOGGLE-Familia 
          FILL-IN-CodFam 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 F-Dias F-AlmDes F-Items R-Tipo T-Trasla TOGGLE-Familia 
         Btn_Genera Btn_OK Btn_Cancel 
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
         repo.undbas FORMAT 'x(7)'
         repo.catego
         repo.canate formaT "->>>>>>>>>>9"
         repo.candes formaT "->>>>>>>>>>9"
         repo.stkmin formaT "->>>>>>>>>>9"
         repo.stkact formaT "->>>>>>>>>>9"
         repo.stkdes formaT "->>>>>>>>>>9" 
         repo.catcon formaT "x(2)"

  WITH WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
                
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
         S-SUBTIT5 AT 1       SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod                                                                              Cantidad     Cantidad         Stock       Stock   Stock      Cat.     " SKIP
         "Alm       Articulo                                    Marca          UM  Cat.    x Atender    Requerida        Minimo      Actual  Alm.Despa. Contable " SKIP
         "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
       
    FOR EACH Repo WHERE Repo.canate > 0 break by 
                        Repo.Codalm by
                        Repo.Codpr1 by
                        Repo.DesMar by
                        Repo.Desmat :
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
                 Repo.CanAte
                 Repo.CanDes
                 repo.stkmin
                 repo.stkact
                 repo.catego
                 repo.stkdes
                 repo.catcon
                 WITH FRAME F-REPORTE.
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

  RUN Carga-Datos.
  
  DEFINE FRAME F-REPORTE
         repo.codmat AT 5 
         repo.desmat
         repo.desmar format "x(12)"
         repo.undbas FORMAT 'x(7)'
         repo.catego
         repo.canate formaT "->>>>>>>>>>9"
         repo.candes formaT "->>>>>>>>>>9"
         repo.stkmin formaT "->>>>>>>>>>9"
         repo.stkact formaT "->>>>>>>>>>9"
         repo.stkdes formaT "->>>>>>>>>>9"
         repo.catcon format "x(2)"

  WITH WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
                
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
         S-SUBTIT5 AT 1       SKIP
         "--------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         "Cod                                                                              Cantidad     Cantidad         Stock       Stock   Stock       Cat.     " SKIP
         "Alm       Articulo                                    Marca          UM  Cat.    x Atender    Requerida        Minimo      Actual  Alm.Despa.  Contable " SKIP
         "--------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 280 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
       
    FOR EACH Repo WHERE Repo.canate > 0 break by 
                        Repo.Codalm by
                        Repo.Codfam by
                        Repo.Desmat :
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
                 Repo.CanAte
                 Repo.CanDes
                 repo.stkmin
                 repo.stkact
                 repo.catego
                 repo.stkdes
                 repo.catcon
                 WITH FRAME F-REPORTE.
    END.    
  
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera W-Win 
PROCEDURE Genera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAr X-NRODOC AS CHAR No-UNDO.
 DEFINE VAr X AS INTEGER NO-UNDO.
 DEFINE VAR X-LOG AS LOGICAL NO-UNDO.
 
 RUN Carga-Datos.

 X = 1.
 X-Items = 0.
 X-LOG = False.
 x-nrodoc = "".
 FOR EACH Repo WHERE Repo.canate > 0 :
     X-Log = TRUE.
     X-Items = X-Items + 1.
     IF X-Items = F-Items Then 
     ASSIGN
     X-Items = 0
     x = x + 1.
 END.
 IF NOT X-LOG THEN DO:
    MESSAGE "No Existen Items a Generar" VIEW-AS ALERT-BOX ERROR.
    RETURN .
 END.

 MESSAGE "Se van a generar " + STRING(x,"999") + " Requerimientos "  SKIP
         "Esta Seguro .............." 
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          TITLE "" UPDATE choice AS LOGICAL.
 CASE choice:
    WHEN FALSE THEN /* No */
      DO:
         MESSAGE "Generacion Cancelada"
                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
         RETURN .
      END.
 END. 

  
 FIND FIRST FacCorre WHERE 
            FacCorre.CodCia = S-CODCIA AND 
            FacCorre.CodDiv = S-CODDIV AND 
            FacCorre.CodDoc = "REP"    AND 
            FacCorre.CodAlm = F-CODALM NO-LOCK NO-ERROR.

 IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE "Correlativo de pedidos de reposicion no configurado" VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
 END.

 S-NROSER = FacCorre.NroSer.
 X-Items = F-Items.

  IF TOGGLE-Familia = NO
  THEN DO:
    FOR EACH Repo WHERE Repo.canate > 0 break by
                    Repo.Codalm by
                    Repo.Codpr1 by
                    Repo.DesMar by
                    Repo.Desmat :
        {alm/i-repmer.i}
    END.
  END.
  ELSE DO:
    FOR EACH Repo WHERE Repo.canate > 0 break by
                    Repo.Codalm by
                    Repo.Codfam by
                    Repo.Desmat :
        {alm/i-repmer.i}
    END.
  END.
/*
  FOR EACH Repo WHERE Repo.canate > 0 break by
                  Repo.Codalm by
                  Repo.Codpr1 by
                  Repo.DesMar by
                  Repo.Desmat :
    IF X-Items = F-Items THEN DO:
      FIND FIRST FacCorre WHERE 
           FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDoc = "REP"    AND
           FacCorre.CodDiv = S-CODDIV AND
           FacCorre.NroSer = S-NROSER  EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN DO:
         CREATE Almcrequ.
         ASSIGN 
         Almcrequ.CodCia = S-CODCIA
         Almcrequ.CodAlm = F-CODALM
         Almcrequ.Almdes = F-Almdes
         Almcrequ.NroSer = S-NROSER
         Almcrequ.FchDoc = TODAY
         Almcrequ.Usuario = S-USER-ID
         Almcrequ.HorGen = STRING(TIME,"HH:MM")
         Almcrequ.NroSer = FacCorre.NroSer
         Almcrequ.NroDoc = FacCorre.Correlativo
         Almcrequ.Observ = Almcrequ.Observ + "/ " + STRING(f-dias) + " Dias /" + s-subtit5
         FacCorre.Correlativo = FacCorre.Correlativo + 1.
      END.
      RELEASE FacCorre.
      X-Items = 0.
      IF x-nrodoc = "" THEN x-nrodoc = STRING(Almcrequ.NroDoc,"999999").
      ELSE x-Nrodoc = x-nrodoc + "," + STRING(Almcrequ.NroDoc,"999999").
    END.
    X-Items = X-Items + 1. 
    CREATE Almdrequ.
    ASSIGN Almdrequ.CodCia = Almcrequ.CodCia
          Almdrequ.CodAlm = Almcrequ.CodAlm
          Almdrequ.NroSer = Almcrequ.NroSer
          Almdrequ.NroDoc = Almcrequ.NroDoc
          Almdrequ.codmat = Repo.codmat
          Almdrequ.CanReq = Repo.canate
          Almdrequ.AlmDes = Almcrequ.AlmDes.
  END.
*/
  MESSAGE "Requerimiento(s) Generado(s)" SKIP
        X-NRODOC VIEW-AS ALERT-BOX INFORMATION.


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
    ENABLE ALL except f-codalm FILL-IN-CodFam.
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
        IF NOT TOGGLE-Familia THEN RUN Formato.
        ELSE RUN Formato-1.
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
  ASSIGN  F-Codalm F-Almdes R-Tipo F-Dias F-Items T-Trasla.
  ASSIGN
    FILL-IN-CodFam = ''.
    TOGGLE-Familia = NO.
  DISPLAY FILL-IN-CodFam TOGGLE-Familia WITH FRAME {&FRAME-NAME}.
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
  f-codalm = s-codalm.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY 
             t-Trasla
             s-codalm @ f-codalm.
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

