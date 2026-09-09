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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
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
     Fi-Mensaje FORMAT 'x(30)' NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEF TEMP-TABLE DETALLE LIKE Almmmatg
    FIELD nompro  LIKE Gn-Prov.Nompro
    FIELD Inv03  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Ucayali */
    FIELD Inv04  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Andahuaylas */
    FIELD Inv05  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Paruro */
    FIELD Inv11  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Ate */
    FIELD Inv16  AS DEC FORMAT '->>>,>>>,>>9.99'    /* San Miguel */
    FIELD Inv83  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Andahuaylas */
    FIELD InvOtr AS DEC FORMAT '->>>,>>>,>>9.99'    /* El resto */
    FIELD Stk03  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Ucayali */
    FIELD Stk04  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Andahuaylas */
    FIELD Stk05  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Paruro */
    FIELD Stk11  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Ate */
    FIELD Stk16  AS DEC FORMAT '->>>,>>>,>>9.99'    /* San Miguel */
    FIELD Stk83  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Andahuaylas */
    FIELD StkOtr AS DEC FORMAT '->>>,>>>,>>9.99'    /* El resto */
    FIELD CtoUni AS DEC FORMAT '->>>,>>>,>>9.99'
    INDEX DETA01 AS PRIMARY CodCia CodMat
    INDEX DETA02 CodCia CodPr1 CodMat.

DEF VAR s-SubTit AS CHAR NO-UNDO.

DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codpro  LIKE Almmmatg.Codpr1
    FIELD t-nompro  LIKE Gn-Prov.Nompro 
    FIELD t-codalm  LIKE FacCpedi.Codalm
    FIELD t-codcli  LIKE FacCpedi.Codcli
    FIELD t-nomcli  LIKE FacCpedi.Nomcli
    FIELD t-codmat  LIKE FacDpedi.codmat.

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
&Scoped-Define ENABLED-OBJECTS x-FchCie DFecha HFecha DesdeC HastaC Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-FchCie DFecha HFecha DesdeC HastaC ~
DesdeP HastaP 

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

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeP AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DFecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Inventarios desde el" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaP AS CHARACTER FORMAT "X(11)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HFecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .69 NO-UNDO.

DEFINE VARIABLE x-FchCie AS DATE FORMAT "99/99/9999":U 
     LABEL "Stock a la fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-FchCie AT ROW 2.54 COL 23 COLON-ALIGNED
     DFecha AT ROW 3.88 COL 23 COLON-ALIGNED
     HFecha AT ROW 3.88 COL 44 COLON-ALIGNED
     DesdeC AT ROW 5.23 COL 23 COLON-ALIGNED
     HastaC AT ROW 5.23 COL 44 COLON-ALIGNED
     DesdeP AT ROW 6.19 COL 23 COLON-ALIGNED
     HastaP AT ROW 6.19 COL 44 COLON-ALIGNED
     Btn_OK AT ROW 10.42 COL 44
     Btn_Cancel AT ROW 10.42 COL 56.43
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1.38 COL 5.43
          FONT 6
     RECT-46 AT ROW 10.23 COL 1
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
         TITLE              = "REPORTE DE SALDOS ANTES DE INVENTARIO"
         HEIGHT             = 10.96
         WIDTH              = 67.14
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
/* SETTINGS FOR FILL-IN DesdeP IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN HastaP IN FRAME F-Main
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
ON END-ERROR OF W-Win /* REPORTE DE SALDOS ANTES DE INVENTARIO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE SALDOS ANTES DE INVENTARIO */
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
  ASSIGN DFecha HFecha DesdeC HastaC DesdeP HastaP x-FchCie.
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeP W-Win
ON LEAVE OF DesdeP IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov where gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-prov THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaP W-Win
ON LEAVE OF HastaP IN FRAME F-Main /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE gn-prov THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
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
    ASSIGN DesdeC HastaC DesdeP HastaP DFecha HFecha.
    IF HastaC = "" THEN HastaC = "999999".
    IF DesdeC = ""
    THEN DO:
        FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DesdeC = ALmmmatg.codmat.
    END.
    
    IF DesdeP = ''
    THEN DO:
        FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DesdeP = gn-prov.codPro.
    END.
    IF HastaP = ''
    THEN DO:
        FIND LAST gn-prov WHERE gn-prov.codcia = pv-codcia NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN HastaP = gn-prov.codPro.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Proveedor W-Win 
PROCEDURE Carga-Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR F-Saldo  AS DEC NO-UNDO.
  DEF VAR F-CtoUni AS DEC NO-UNDO.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
    FOR EACH InvConfig WHERE invconfig.codcia = s-codcia
            AND invconfig.codalm = almacen.codalm
            AND fchinv >= DFecha 
            AND fchinv <= HFecha
            NO-LOCK:
        FOR EACH InvRecont WHERE invrecont.codcia = s-codcia
                AND invrecont.codalm = almacen.codalm
                AND invrecont.fchinv = invconfig.fchinv
                NO-LOCK,
                FIRST Almmmatg OF InvRecont NO-LOCK WHERE
                    Almmmatg.CodPr1 >= DesdeP
                    AND Almmmatg.CodPr1 <= HastaP:
            DISPLAY Almacen.codalm @ Fi-Mensaje LABEL "Almacen "
                FORMAT "X(8)" WITH FRAME F-Proceso.
            FIND DETALLE WHERE DETALLE.codcia = Almmmatg.codcia
                AND DETALLE.CodPr1 = Almmmatg.codpr1
                AND DETALLE.CodMat = Almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE DETALLE 
            THEN CREATE DETALLE.
            BUFFER-COPY Almmmatg TO DETALLE.
            CASE Almacen.codalm:
                WHEN '03' THEN DETALLE.Stk03 = DETALLE.Stk03 + InvRecont.CanInv.
                WHEN '04' THEN DETALLE.Stk04 = DETALLE.Stk04 + InvRecont.CanInv.
                WHEN '05' THEN DETALLE.Stk05 = DETALLE.Stk05 + InvRecont.CanInv.
                WHEN '11' THEN DETALLE.Stk11 = DETALLE.Stk11 + InvRecont.CanInv.
                WHEN '16' THEN DETALLE.Stk16 = DETALLE.Stk16 + InvRecont.CanInv.
                WHEN '83' THEN DETALLE.Stk83 = DETALLE.Stk83 + InvRecont.CanInv.
                OTHERWISE DETALLE.StkOtr = DETALLE.StkOtr + InvRecont.CanInv.
            END CASE.
        END.
    END.
  END.
  HIDE FRAME F-Proceso.
  
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
  DEF VAR F-Saldo  AS DEC NO-UNDO.
  DEF VAR F-CtoUni AS DEC NO-UNDO.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
    FOR EACH InvConfig WHERE invconfig.codcia = s-codcia
            AND invconfig.codalm = almacen.codalm
            AND fchinv >= DFecha 
            AND fchinv <= HFecha
            NO-LOCK:
        FOR EACH InvRecont WHERE invrecont.codcia = s-codcia
                AND invrecont.codalm = almacen.codalm
                AND invrecont.fchinv = invconfig.fchinv
                AND invrecont.codmat >= DesdeC
                AND invrecont.codmat <= HastaC
                NO-LOCK,
                FIRST Almmmatg OF InvRecont NO-LOCK:
            DISPLAY Almacen.codalm @ Fi-Mensaje LABEL "Almacen "
                FORMAT "X(8)" WITH FRAME F-Proceso.
            FIND DETALLE OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE DETALLE 
            THEN CREATE DETALLE.
            BUFFER-COPY Almmmatg TO DETALLE.
            CASE Almacen.codalm:
                WHEN '03' THEN DETALLE.Inv03 = DETALLE.Inv03 + InvRecont.CanInv.
                WHEN '04' THEN DETALLE.Inv04 = DETALLE.Inv04 + InvRecont.CanInv.
                WHEN '05' THEN DETALLE.Inv05 = DETALLE.Inv05 + InvRecont.CanInv.
                WHEN '11' THEN DETALLE.Inv11 = DETALLE.Inv11 + InvRecont.CanInv.
                WHEN '16' THEN DETALLE.Inv16 = DETALLE.Inv16 + InvRecont.CanInv.
                WHEN '83' THEN DETALLE.Inv83 = DETALLE.Inv83 + InvRecont.CanInv.
                OTHERWISE DETALLE.InvOtr = DETALLE.InvOtr + InvRecont.CanInv.
            END CASE.
        END.
    END.
  END.
  /* CARGAMOS EL INVENTARIO A LA FECHA */
  FOR EACH Almmmatg WHERE Almmmatg.codcia = s-codcia 
        AND Almmmatg.codmat >= DesdeC AND Almmmatg.codmat <= HastaC
        NO-LOCK:
    FOR EACH Almacen WHERE Almacen.codcia = Almmmatg.codcia NO-LOCK:
        FIND LAST Almstkal WHERE Almstkal.codcia = Almmmatg.codcia
            AND Almstkal.codalm = Almacen.codalm
            AND Almstkal.codmat = Almmmatg.codmat
            AND Almstkal.fecha <= x-FchCie
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkal
        THEN DO:
            FIND DETALLE OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE DETALLE 
            THEN CREATE DETALLE.
            BUFFER-COPY Almmmatg TO DETALLE.
            CASE Almacen.codalm:
                WHEN '03' THEN DETALLE.Stk03 = DETALLE.Stk03 + AlmStkal.StkAct.
                WHEN '04' THEN DETALLE.Stk04 = DETALLE.Stk04 + AlmStkal.StkAct.
                WHEN '05' THEN DETALLE.Stk05 = DETALLE.Stk05 + AlmStkal.StkAct.
                WHEN '11' THEN DETALLE.Stk11 = DETALLE.Stk11 + AlmStkal.StkAct.
                WHEN '16' THEN DETALLE.Stk16 = DETALLE.Stk16 + AlmStkal.StkAct.
                WHEN '83' THEN DETALLE.Stk83 = DETALLE.Stk83 + AlmStkal.StkAct.
                OTHERWISE DETALLE.StkOtr = DETALLE.StkOtr + AlmStkal.StkAct.
            END CASE.
        END.
    END.
  END.
  /* AJUSTAMOS POR EL MOVIMIENTO DE INVENTARIO */
  FOR EACH DETALLE:
    FOR EACH Almdmov WHERE Almdmov.codcia = s-codcia
            AND Almdmov.codmat = DETALLE.codmat
            AND (Almdmov.tipmov = 'I' OR Almdmov.tipmov = 'S')
            AND Almdmov.codmov = 01
            AND Almdmov.fchdoc >= DFecha AND Almdmov.fchdoc <= HFecha
            NO-LOCK:
        CASE Almdmov.codalm:
            WHEN '03' THEN DETALLE.Stk03 = DETALLE.Stk03 + (IF Almdmov.tipmov = 'I' THEN -1 ELSE 1) * Almdmov.candes.
            WHEN '04' THEN DETALLE.Stk04 = DETALLE.Stk04 + (IF Almdmov.tipmov = 'I' THEN -1 ELSE 1) * Almdmov.candes.
            WHEN '05' THEN DETALLE.Stk05 = DETALLE.Stk05 + (IF Almdmov.tipmov = 'I' THEN -1 ELSE 1) * Almdmov.candes.
            WHEN '11' THEN DETALLE.Stk11 = DETALLE.Stk11 + (IF Almdmov.tipmov = 'I' THEN -1 ELSE 1) * Almdmov.candes.
            WHEN '16' THEN DETALLE.Stk16 = DETALLE.Stk16 + (IF Almdmov.tipmov = 'I' THEN -1 ELSE 1) * Almdmov.candes.
            WHEN '83' THEN DETALLE.Stk83 = DETALLE.Stk83 + (IF Almdmov.tipmov = 'I' THEN -1 ELSE 1) * Almdmov.candes.
            OTHERWISE DETALLE.StkOtr = DETALLE.StkOtr + (IF Almdmov.tipmov = 'I' THEN -1 ELSE 1) * Almdmov.candes.
        END CASE.
    END.            
  END.
  HIDE FRAME F-Proceso.
  
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
  DISPLAY x-FchCie DFecha HFecha DesdeC HastaC DesdeP HastaP 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-FchCie DFecha HFecha DesdeC HastaC Btn_OK Btn_Cancel 
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
  DEF VAR x-CanInv AS DEC NO-UNDO.
  
  DEFINE FRAME F-DETALLE
    DETALLE.codmat      COLUMN-LABEL "Codigo"
    DETALLE.desmat      COLUMN-LABEL "Descripcion"          FORMAT 'X(35)'
    DETALLE.desmar      COLUMN-LABEL "Marca"                FORMAT 'X(10)'
    DETALLE.catconta[1] COLUMN-LABEL "CC"                   FORMAT 'X(2)'
    DETALLE.stk03       COLUMN-LABEL "Stock!Ucayali"        FORMAT '->>,>>9.99'
    DETALLE.inv03       COLUMN-LABEL "Inventario!Ucayali"   FORMAT '->>,>>9.99'
    DETALLE.stk04       COLUMN-LABEL "Stock!Andahuaylas"    FORMAT '->>,>>9.99'
    DETALLE.inv04       COLUMN-LABEL "Inventario!Andahuaylas"    FORMAT '->>,>>9.99'
    DETALLE.stk05       COLUMN-LABEL "Stock!Paruro"         FORMAT '->>,>>9.99'
    DETALLE.inv05       COLUMN-LABEL "Inventario!Paruro"    FORMAT '->>,>>9.99'
    DETALLE.stk11       COLUMN-LABEL "Stock!Sta. Raquel"    FORMAT '->>,>>9.99'
    DETALLE.inv11       COLUMN-LABEL "Inventario!Sta. Raquel"    FORMAT '->>,>>9.99'
    DETALLE.stk16       COLUMN-LABEL "Stock!San Miguel"     FORMAT '->>,>>9.99'
    DETALLE.inv16       COLUMN-LABEL "Inventario!San Miguel"     FORMAT '->>,>>9.99'
    DETALLE.stk83       COLUMN-LABEL "Stock!83"             FORMAT '->>,>>9.99'
    DETALLE.inv83       COLUMN-LABEL "Inventario!83"        FORMAT '->>,>>9.99'
    DETALLE.stkOtr      COLUMN-LABEL "Stock!Otros"          FORMAT '->>,>>9.99'
    DETALLE.invOtr      COLUMN-LABEL "Inventario!Otros"     FORMAT '->>,>>9.99'
  WITH WIDTH 320 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "REPORTE DE SALDOS ANTES DE INVENTARIO" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeC "HASTA EL CODIGO" HastaC SKIP
    s-SubTit FORMAT 'x(100)' SKIP
  WITH PAGE-TOP WIDTH 210 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.catconta[1] BY DETALLE.desmat:
    VIEW STREAM REPORT FRAME F-HEADER.
    x-CanInv = stk03 + stk04 + stk05 + stk11 + stk16 + stk83 + stkotr.
    DISPLAY STREAM REPORT 
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar
        DETALLE.catconta[1] 
        DETALLE.stk03       
        DETALLE.stk04       
        DETALLE.stk05       
        DETALLE.stk11       
        DETALLE.stk16       
        DETALLE.stk83       
        DETALLE.stkOtr      
        DETALLE.inv03       
        DETALLE.inv04       
        DETALLE.inv05       
        DETALLE.inv11       
        DETALLE.inv16       
        DETALLE.inv83       
        DETALLE.invOtr      
        WITH FRAME F-DETALLE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 W-Win 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-CanInv AS DEC NO-UNDO.
  
  DEFINE FRAME F-DETALLE
    DETALLE.codmat      COLUMN-LABEL "Codigo"               FORMAT 'x(10)'
    DETALLE.desmat      COLUMN-LABEL "Descripcion"          FORMAT 'X(35)'
    DETALLE.desmar      COLUMN-LABEL "Marca"                FORMAT 'X(10)'
    DETALLE.catconta[1] COLUMN-LABEL "CC"                   FORMAT 'X(2)'
    DETALLE.stk03       COLUMN-LABEL "Stock!Ucayali"        FORMAT '->>,>>9.99'
    DETALLE.stk04       COLUMN-LABEL "Stock!Andahuaylas"    FORMAT '->>,>>9.99'
    DETALLE.stk05       COLUMN-LABEL "Stock!Paruro"         FORMAT '->>,>>9.99'
    DETALLE.stk11       COLUMN-LABEL "Stock!Sta. Raquel"    FORMAT '->>,>>9.99'
    DETALLE.stk16       COLUMN-LABEL "Stock!San Miguel"     FORMAT '->>,>>9.99'
    DETALLE.stk83       COLUMN-LABEL "Stock!83"             FORMAT '->>,>>9.99'
    DETALLE.stkOtr      COLUMN-LABEL "Stock!Otros"          FORMAT '->>,>>9.99'
    x-CanInv            COLUMN-LABEL "Stock!Total"          FORMAT '->>>,>>9.99'
  WITH WIDTH 210 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "INVENTARIOS CONSOLIDADOS POR PROVEEDOR" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeP "HASTA EL CODIGO" HastaP
    s-SubTit FORMAT 'x(51)' SKIP
    
  WITH PAGE-TOP WIDTH 210 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
    
    VIEW STREAM REPORT FRAME F-HEADER.
    
    FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.codpr1:
        DOWN STREAM REPORT 1 WITH FRAME F-DETALLE.
    IF FIRST-OF(DETALLE.Codpr1) THEN DO:
       PUT STREAM REPORT "PROVEEDOR  : "  DETALLE.Codpr1 "  " DETALLE.Nompro  SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.

    
  /*FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.codpr1:
 *     VIEW STREAM REPORT FRAME F-HEADER.
 *     IF FIRST-OF(DETALLE.CodPr1) THEN DO:
 *        DISPLAY STREAM REPORT 
 *             "Proveedor:" @ DETALLE.codmat
 *             DETALLE.CodPr1 @ DETALLE.desmat 
 *             WITH FRAME F-DETALLE.
 *        UNDERLINE STREAM REPORT 
 *             DETALLE.codmat 
 *             DETALLE.desmat 
 *             WITH FRAME F-DETALLE.
 *        DOWN STREAM REPORT 1 WITH FRAME F-DETALLE.
 *      END.*/
    
    x-CanInv = stk03 + stk04 + stk05 + stk11 + stk16 + stk83 + stkotr.
    DISPLAY STREAM REPORT 
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar
        DETALLE.catconta[1] 
        DETALLE.stk03       
        DETALLE.stk04       
        DETALLE.stk05       
        DETALLE.stk11       
        DETALLE.stk16       
        DETALLE.stk83       
        DETALLE.stkOtr      
        x-CanInv
        WITH FRAME F-DETALLE.
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
        ASSIGN
                DesdeP:VISIBLE = NO
                HastaP:VISIBLE = NO
                DesdeP:SENSITIVE = NO
                HastaP:SENSITIVE = NO.
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
   
  s-SubTit = "INVENTARIOS DESDE EL " + STRING(DFecha, '99/99/9999') +
            " HASTA EL " + STRING(HFecha, '99/99/9999') +
            " FECHA DE CORTE " + STRING(x-FchCie, '99/99/9999').
    RUN FORMATO.
    
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
    ASSIGN DesdeC HastaC DFecha HFecha DesdeP HastaP.
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
    x-FchCie = TODAY
    DFecha = TODAY
    HFEcha = TODAY.

      /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
                DesdeP:VISIBLE = NO
                HastaP:VISIBLE = NO.
END.                              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prn-Proveedor W-Win 
PROCEDURE Prn-Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-CanInv AS DEC NO-UNDO.
  
  DEFINE FRAME F-DETALLE
    DETALLE.codmat      COLUMN-LABEL "Codigo"
    DETALLE.desmat      COLUMN-LABEL "Descripcion"          FORMAT 'X(35)'
    DETALLE.desmar      COLUMN-LABEL "Marca"                FORMAT 'X(10)'
    DETALLE.catconta[1] COLUMN-LABEL "CC"                   FORMAT 'X(2)'
    DETALLE.stk03       COLUMN-LABEL "Stock!Ucayali"        FORMAT '->>,>>9.99'
    DETALLE.stk04       COLUMN-LABEL "Stock!Andahuaylas"    FORMAT '->>,>>9.99'
    DETALLE.stk05       COLUMN-LABEL "Stock!Paruro"         FORMAT '->>,>>9.99'
    DETALLE.stk11       COLUMN-LABEL "Stock!Sta. Raquel"    FORMAT '->>,>>9.99'
    DETALLE.stk16       COLUMN-LABEL "Stock!San Miguel"     FORMAT '->>,>>9.99'
    DETALLE.stk83       COLUMN-LABEL "Stock!83"             FORMAT '->>,>>9.99'
    DETALLE.stkOtr      COLUMN-LABEL "Stock!Otros"          FORMAT '->>,>>9.99'
    x-CanInv            COLUMN-LABEL "Stock!Total"          FORMAT '->>>,>>9.99'
  WITH WIDTH 210 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "INVENTARIOS CONSOLIDADOS" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeP "HASTA EL CODIGO" HastaP
    s-SubTit FORMAT 'x(50)' SKIP
  WITH PAGE-TOP WIDTH 210 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DISPLAY STREAM REPORT WITH FRAME F-DETALLE.
  
    VIEW STREAM REPORT FRAME F-HEADER.      
FOR EACH DETALLE BREAK BY DETALLE.codcia:                   
    x-CanInv = stk03 + stk04 + stk05 + stk11 + stk16 + stk83 + stkotr.

      
  FOR EACH tmp-tempo BREAK BY tmp-tempo.t-codpro:
    

    IF FIRST-OF(tmp-tempo.t-Codpro) THEN DO:
       PUT STREAM REPORT "PROVEEDOR  : "  tmp-tempo.t-Codpro  "  " tmp-tempo.t-Nompro SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.
    
    DISPLAY STREAM REPORT 
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar
        DETALLE.catconta[1] 
        DETALLE.stk03       
        DETALLE.stk04       
        DETALLE.stk05       
        DETALLE.stk11       
        DETALLE.stk16       
        DETALLE.stk83       
        DETALLE.stkOtr      
        x-CanInv
        WITH FRAME F-DETALLE.
  END.
end.

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

