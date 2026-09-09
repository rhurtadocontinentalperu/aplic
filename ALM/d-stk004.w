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
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

DEFINE VAR pv-codcia AS INT.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

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
    FIELD Stk03  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Ucayali */
    FIELD Stk04  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Andahuaylas */
    FIELD Stk05  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Paruro */
    FIELD Stk11  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Ate */
    FIELD Stk12  AS DEC FORMAT '->>>,>>>,>>9.99'    
    FIELD Stk16  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Tda San Miguel */
    FIELD Stk15  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Expolibreria */
    FIELD Stk19  AS DEC FORMAT '->>>,>>>,>>9.99'    
    FIELD Stk30  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Satelite Lima */
    FIELD Stk83  AS DEC FORMAT '->>>,>>>,>>9.99'    /* Andahuaylas */
    FIELD Stk83b AS DEC FORMAT '->>>,>>>,>>9.99'    /* Andahuaylas */
    FIELD Stk85  AS DEC FORMAT '->>>,>>>,>>9.99'   
    FIELD Stk130 AS DEC FORMAT '->>>,>>>,>>9.99'   
    FIELD Stk131 AS DEC FORMAT '->>>,>>>,>>9.99'   
    FIELD Stk152 AS DEC FORMAT '->>>,>>>,>>9.99'   
    FIELD Stk160 AS DEC FORMAT '->>>,>>>,>>9.99'   
    FIELD StkOtr AS DEC FORMAT '->>>,>>>,>>9.99'    /* El resto */
    FIELD CtoUni AS DEC FORMAT '->>>,>>>,>>9.99'
    FIELD CodAlm LIKE Almmmate.CodAlm
    FIELD StkAct LIKE Almmmate.StkAct
    INDEX DETA01 AS PRIMARY CodCia CodMat.

DEF VAR s-SubTit AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 x-CodAlm DFecha cCategoria DesdeC ~
HastaC c-CodFam x-CodPro R-Costo RADIO-SET-1 TOGGLE-1 Btn_OK Btn_Cancel ~
Btn_Cancel-2 
&Scoped-Define DISPLAYED-OBJECTS x-CodAlm DFecha cCategoria FILL-IN-Nombre ~
DesdeC HastaC c-CodFam x-CodPro R-Costo RADIO-SET-1 TOGGLE-1 x-mensaje 

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

DEFINE BUTTON Btn_Cancel-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5 TOOLTIP "Detallado por material y todos los almacenes"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE x-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-CodFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE cCategoria AS CHARACTER FORMAT "X(3)":U 
     LABEL "Categoria Contable" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DFecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nombre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 72.14 BY .81 NO-UNDO.

DEFINE VARIABLE R-Costo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Promedio", 1,
"Reposición", 2
     SIZE 20 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Detallado por material", 1,
"Resumido por linea", 2,
"Detallado y agrupado por clasificacion contable", 3,
"Resumido por categoria contable", 4,
"Resumido por proveedor", 5
     SIZE 36 BY 3.46 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.92
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 12.46.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Solo los que tiene costo cero" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodAlm AT ROW 1.77 COL 18 COLON-ALIGNED
     DFecha AT ROW 2.92 COL 18 COLON-ALIGNED
     cCategoria AT ROW 3.69 COL 18 COLON-ALIGNED
     FILL-IN-Nombre AT ROW 3.69 COL 28 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 4.46 COL 18 COLON-ALIGNED
     HastaC AT ROW 4.46 COL 33 COLON-ALIGNED
     c-CodFam AT ROW 5.23 COL 18 COLON-ALIGNED
     x-CodPro AT ROW 6 COL 18 COLON-ALIGNED
     R-Costo AT ROW 6.77 COL 20 NO-LABEL
     RADIO-SET-1 AT ROW 7.92 COL 20 NO-LABEL
     TOGGLE-1 AT ROW 11.38 COL 20
     x-mensaje AT ROW 12.31 COL 2.86 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 13.85 COL 45.29
     Btn_Cancel AT ROW 13.85 COL 57
     Btn_Cancel-2 AT ROW 13.85 COL 68.72
     "Valorización:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 6.96 COL 11
     "Formato:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 8.12 COL 14
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-57 AT ROW 1.19 COL 1.43
     RECT-46 AT ROW 13.62 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.86 BY 14.62
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
         TITLE              = "VALORIZACION DEL STOCK LOGISTICO POR ALMACEN"
         HEIGHT             = 14.62
         WIDTH              = 80.86
         MAX-HEIGHT         = 14.62
         MAX-WIDTH          = 80.86
         VIRTUAL-HEIGHT     = 14.62
         VIRTUAL-WIDTH      = 80.86
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
/* SETTINGS FOR FILL-IN FILL-IN-Nombre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
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
ON END-ERROR OF W-Win /* VALORIZACION DEL STOCK LOGISTICO POR ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VALORIZACION DEL STOCK LOGISTICO POR ALMACEN */
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


&Scoped-define SELF-NAME Btn_Cancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel-2 W-Win
ON CHOOSE OF Btn_Cancel-2 IN FRAME F-Main /* Cancelar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Excel.
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
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cCategoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCategoria W-Win
ON LEAVE OF cCategoria IN FRAME F-Main /* Categoria Contable */
DO:
  FILL-IN-Nombre:SCREEN-VALUE = ''.
  FIND Almtabla WHERE almtabla.tabla = 'CC'
    AND almtabla.codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN FILL-IN-Nombre:SCREEN-VALUE = almtabla.nombre.
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
    ASSIGN 
        DesdeC HastaC DFecha RADIO-SET-1 R-Costo 
        cCategoria TOGGLE-1 c-CodFam x-codalm
        x-CodPro.
    IF HastaC = "" THEN HastaC = "999999".
    IF DesdeC = ""
    THEN DO:
        FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DesdeC = ALmmmatg.codmat.
    END.
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
  DEF VAR F-Saldo  AS DEC NO-UNDO.
  DEF VAR F-CtoUni AS DEC NO-UNDO.
  DEF VAR x-Total  AS DEC NO-UNDO.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  FOR EACH Almmmatg WHERE Almmmatg.codcia = s-codcia 
      AND Almmmatg.codmat >= DesdeC
      AND Almmmatg.codmat <= HastaC 
      AND Almmmatg.codfam BEGINS c-CodFam
      AND Almmmatg.catconta[1] BEGINS cCategoria
      AND Almmmatg.codpr1 BEGINS x-CodPro NO-LOCK:

      /*
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
        FORMAT "X(8)" WITH FRAME F-Proceso.
      */

      DISPLAY "Codigo de Articulo " + Almmmatg.CodMat @ x-mensaje
          WITH FRAME {&FRAME-NAME}.

      /* CARGAMOS TEMPORAL */
      FIND DETALLE OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE DETALLE 
          THEN CREATE DETALLE.
      BUFFER-COPY Almmmatg TO DETALLE.

      /* ***************** */
      /* Saldo Logistico */
      FOR EACH Almacen WHERE almacen.codcia = s-codcia
          AND almacen.flgrep = YES 
          AND (x-codalm = 'Todos' OR Almacen.codalm = x-codalm)
          /*AND Almacen.codalm <> '79'*/
          NO-LOCK:
          
          IF Almacen.AlmCsg = YES THEN NEXT.
          ASSIGN F-Saldo  = 0.
          FIND LAST AlmStkAl WHERE almstkal.codcia = s-codcia
              AND almstkal.codalm = almacen.codalm
              AND almstkal.codmat = almmmatg.codmat
              AND almstkal.fecha <= DFecha
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almstkal THEN DO:
              F-Saldo = almstkal.stkact.
          END.

          CASE Almacen.codalm:
              WHEN '03' THEN DETALLE.Stk03 = F-Saldo.
              WHEN '04' THEN DETALLE.Stk04 = F-Saldo.
              WHEN '05' THEN DETALLE.Stk05 = F-Saldo.
              WHEN '11' THEN DETALLE.Stk11 = F-Saldo.
/*            WHEN '12' THEN DETALLE.Stk12 = F-Saldo.*/
              WHEN '16' THEN DETALLE.Stk16 = F-Saldo.
              WHEN '15' THEN DETALLE.Stk15 = F-Saldo.
/*            WHEN '19' THEN DETALLE.Stk19 = F-Saldo.*/
              WHEN '30' THEN DETALLE.Stk30 = F-Saldo.
/*MLR 08/02/2008 *
            WHEN '83' THEN DETALLE.Stk83 = F-Saldo.
            WHEN '83b' THEN DETALLE.Stk83b = F-Saldo.
*/
              WHEN '35' THEN DETALLE.Stk83 = F-Saldo.     /* Junin */
              WHEN '40' THEN DETALLE.Stk83b = F-Saldo.    /* Frutales */
              WHEN '85' THEN DETALLE.Stk85 = F-Saldo.
              WHEN '130' THEN DETALLE.Stk130 = F-Saldo.
              WHEN '131' THEN DETALLE.Stk131 = F-Saldo.
              WHEN '152' THEN DETALLE.Stk152 = F-Saldo.
              WHEN '160' THEN DETALLE.Stk160 = F-Saldo.
              OTHERWISE DETALLE.StkOtr = DETALLE.StkOtr + F-Saldo.
          END CASE.

      END.
      x-Total = ABSOLUTE(detalle.stk03) + ABSOLUTE(detalle.stk04) +
          ABSOLUTE(detalle.stk05) + ABSOLUTE(detalle.stk11) +
          ABSOLUTE(detalle.stk16) + ABSOLUTE(detalle.stk83) +
          ABSOLUTE(detalle.stk15) + ABSOLUTE(detalle.stk30) +
          ABSOLUTE(detalle.stkotr)+
          ABSOLUTE(detalle.stk12) + ABSOLUTE(detalle.stk85) +
          ABSOLUTE(detalle.stk130) + ABSOLUTE(detalle.stk152) +
          ABSOLUTE(detalle.stk160) + ABSOLUTE(detalle.stk83b) +
          ABSOLUTE(detalle.stk19) + ABSOLUTE(detalle.stk131).

      IF x-Total = 0 THEN DO:
          DELETE DETALLE.
          NEXT.
      END.

      /* Costo Unitario */
      ASSIGN F-CtoUni = 0.
      CASE R-COSTO:
          WHEN 1 THEN DO:
              FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
                  AND almstkge.codmat = almmmatg.codmat
                  AND almstkge.fecha <= DFecha NO-LOCK NO-ERROR.
              IF AVAILABLE AlmStkGe THEN F-CtoUni = almstkge.ctouni.
          END.
          WHEN 2 THEN DO:
              F-CtoUni = Almmmatg.CtoLis.
              IF Almmmatg.MonVta = 2 THEN DO:
                  IF Almmmatg.TpoCmb = 0 OR Almmmatg.TpoCmb = ? THEN DO:
                      MESSAGE 'El código' Almmmatg.CodMat 'tiene un error en el tipo de cambio' SKIP
                          'T.C.=' Almmmatg.tpocmb
                          VIEW-AS ALERT-BOX ERROR.
                  END.
                  F-CtoUni = F-CtoUni * Almmmatg.TpoCmb. 
              END.
          END.
      END CASE.

      ASSIGN
          DETALLE.CtoUni = F-CtoUni
          DETALLE.CtoTot = ( detalle.stk03 + detalle.stk04 + detalle.stk05 + detalle.stk12 +
                             detalle.stk11 + detalle.stk16 + detalle.stk83 +
                             detalle.stk15 + detalle.stk30 + detalle.stk83b +
                             detalle.stk85 + detalle.stk130 + detalle.stk131 +
                             detalle.stk152 + detalle.stk160 + detalle.stk19 +
                             detalle.stkotr ) * detalle.ctouni.

      /* EN CASO DE MOSTRAR IMPORTES */
      IF RADIO-SET-1 = 2 OR RADIO-SET-1 = 4 OR RADIO-SET-1 = 5 THEN 
          ASSIGN
            DETALLE.Stk03 = DETALLE.Stk03 * F-CtoUni
            DETALLE.Stk04 = DETALLE.Stk04 * F-CtoUni
            DETALLE.Stk05 = DETALLE.Stk05 * F-CtoUni
            DETALLE.Stk11 = DETALLE.Stk11 * F-CtoUni
            DETALLE.Stk12 = DETALLE.Stk12 * F-CtoUni
            DETALLE.Stk16 = DETALLE.Stk16 * F-CtoUni
            DETALLE.Stk15 = DETALLE.Stk15 * F-CtoUni
            DETALLE.Stk30 = DETALLE.Stk30 * F-CtoUni
            DETALLE.Stk83 = DETALLE.Stk83 * F-CtoUni
            DETALLE.Stk83b= DETALLE.Stk83b * F-CtoUni
            DETALLE.Stk85 = DETALLE.Stk85 * F-CtoUni
            DETALLE.Stk130 = DETALLE.Stk130 * F-CtoUni
            DETALLE.Stk131 = DETALLE.Stk131 * F-CtoUni
            DETALLE.Stk152 = DETALLE.Stk152 * F-CtoUni
            DETALLE.Stk160 = DETALLE.Stk160 * F-CtoUni
            DETALLE.Stk19  = DETALLE.Stk19 * F-CtoUni
            DETALLE.StkOtr = DETALLE.StkOtr * F-CtoUni.
      x-Total = ABSOLUTE(detalle.stk03) + ABSOLUTE(detalle.stk04) +
                ABSOLUTE(detalle.stk05) + ABSOLUTE(detalle.stk11) +
                ABSOLUTE(detalle.stk16) + ABSOLUTE(detalle.stk83) +
                ABSOLUTE(detalle.stk15) + ABSOLUTE(detalle.stk30) +
                ABSOLUTE(detalle.stkotr)+
                ABSOLUTE(detalle.stk12) + ABSOLUTE(detalle.stk83b) +
                ABSOLUTE(detalle.stk85) + ABSOLUTE(detalle.stk130) +
                ABSOLUTE(detalle.stk131) + ABSOLUTE(detalle.stk152) +
                ABSOLUTE(detalle.stk160) + ABSOLUTE(detalle.stk19).
      IF TOGGLE-1 = NO AND x-Total = 0   THEN DELETE DETALLE.
      IF TOGGLE-1 = YES AND x-Total <> 0 THEN DELETE DETALLE.
  END.
  /*
  HIDE FRAME F-Proceso.
  */
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Excel W-Win 
PROCEDURE Carga-Temporal-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR F-Saldo  AS DEC NO-UNDO.
  DEF VAR F-CtoUni AS DEC NO-UNDO.
  DEF VAR x-Total  AS DEC NO-UNDO.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia 
        AND Almmmatg.codmat >= DesdeC
        AND Almmmatg.codmat <= HastaC ,
        EACH Almmmate OF Almmmatg NO-LOCK WHERE (x-codalm = 'Todos' OR Almmmate.codalm = x-codalm),
        FIRST Almacen OF Almmmate NO-LOCK WHERE Almacen.FlgRep = YES 
            AND Almacen.AlmCsg = NO:
      IF NOT (c-CodFam = '' OR Almmmatg.codfam = c-CodFam) THEN NEXT.
      IF NOT (cCategoria = '' OR Almmmatg.catconta[1] = cCategoria) THEN NEXT.
      IF NOT (x-CodPro = '' OR Almmmatg.codpr1 = x-CodPro) THEN NEXT.
      DISPLAY "Codigo de Articulo: " +  Almmmatg.CodMat @ x-mensaje
          WITH FRAME {&FRAME-NAME}.

      /* CARGAMOS TEMPORAL */
      FIND DETALLE OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
      CREATE DETALLE.
      BUFFER-COPY Almmmatg TO DETALLE
          ASSIGN DETALLE.CodAlm = Almmmate.codalm.
      /* ***************** */
      /* Saldo Logistico */
      ASSIGN
          F-Saldo  = 0.
      FIND LAST AlmStkAl WHERE almstkal.codcia = s-codcia
          AND almstkal.codalm = almacen.codalm
          AND almstkal.codmat = almmmatg.codmat
          AND almstkal.fecha <= DFecha
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almstkal THEN F-Saldo = almstkal.stkact.
      DETALLE.StkAct = F-Saldo.
      /* Costo Unitario */
      ASSIGN
          F-CtoUni = 0.
      CASE R-COSTO:
          WHEN 1 THEN DO:
              FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
                  AND almstkge.codmat = almmmatg.codmat
                  AND almstkge.fecha <= DFecha
                  NO-LOCK NO-ERROR.
              IF AVAILABLE AlmStkGe THEN F-CtoUni = almstkge.ctouni.
          END.
          WHEN 2 THEN DO:
              F-CtoUni = Almmmatg.CtoLis.
              IF Almmmatg.MonVta = 2 THEN DO:
                  IF Almmmatg.TpoCmb = 0 OR Almmmatg.TpoCmb = ? THEN DO:
                    MESSAGE 'El código' Almmmatg.CodMat 'tiene un error en el tipo de cambio' SKIP
                        'T.C.=' Almmmatg.tpocmb
                        VIEW-AS ALERT-BOX ERROR.
                END.
                F-CtoUni = F-CtoUni * Almmmatg.TpoCmb. 
            END.
        END.
    END CASE.
    ASSIGN
        DETALLE.CtoUni = F-CtoUni.
    PAUSE 0.
  END.
  /*
  HIDE FRAME F-Proceso.
  */

  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY x-CodAlm DFecha cCategoria FILL-IN-Nombre DesdeC HastaC c-CodFam 
          x-CodPro R-Costo RADIO-SET-1 TOGGLE-1 x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 x-CodAlm DFecha cCategoria DesdeC HastaC c-CodFam x-CodPro 
         R-Costo RADIO-SET-1 TOGGLE-1 Btn_OK Btn_Cancel Btn_Cancel-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE cCodFam AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSubFam AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cProve1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cProve2 AS CHARACTER   NO-UNDO.

RUN Carga-Temporal-Excel.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Familia".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Sub Familia".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Proveedor 01".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Proveedor 02".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "CC".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Und".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Unitario".


i-Column = 74.                   /* Letra J */
j-Column = 0.
FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
        AND Almacen.FlgRep = YES AND Almacen.AlmCsg = NO:
    i-Column = i-Column + 1.
    IF i-Column > 90            /* 'Z' */
    THEN ASSIGN
            i-Column = 65       /* 'A' */
            j-Column = IF j-Column = 0 THEN 65 ELSE j-Column + 1.
    IF j-Column = 0
    THEN cRange = CHR(i-Column) + cColumn.
    ELSE cRange = CHR(j-Column) + CHR(i-Column) + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Almacen.CodAlm.
END.

DEF BUFFER B-DETALLE FOR DETALLE.
FOR EACH DETALLE NO-LOCK BREAK BY DETALLE.codmat:
    IF FIRST-OF(DETALLE.codmat) THEN DO:
        /*Carga Familia, sub familia y proveedor*/
        FIND FIRST almtfam WHERE almtfam.codcia = s-codcia
            AND almtfam.codfam = detalle.codfam NO-LOCK NO-ERROR.
        IF AVAIL almtfam THEN cCodFam = almtfam.codfam + '-' + almtfam.desfam.
        ELSE cCodFam = detalle.codfam.

        FIND FIRST almsfam WHERE almsfam.codcia = s-codcia
            AND almsfam.codfam = detalle.codfam 
            AND almsfam.subfam = detalle.subfam NO-LOCK NO-ERROR.
        IF AVAIL almsfam THEN cSubFam = almsfam.subfam + '-' + almsfam.dessub.
        ELSE cSubFam = detalle.subfam.

        FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = detalle.codpr1 NO-LOCK NO-ERROR.
        IF AVAIL gn-prov THEN cProve1 = gn-prov.codpro + '-' + gn-prov.nompro.
        ELSE cProve1 = detalle.codpr1.

        FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = detalle.codpr2 NO-LOCK NO-ERROR.
        IF AVAIL gn-prov THEN cProve2 = gn-prov.codpro + '-' + gn-prov.nompro.
        ELSE cProve2 = detalle.codpr2.


        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + DETALLE.codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.desmat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.desmar.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = cCodFam.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = cSubFam.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = cProve1.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = cProve2.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.catconta[1].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.undbas.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.ctouni.


        i-Column = 74.                   /* Letra J */
        j-Column = 0.
        FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
                AND Almacen.FlgRep = YES AND Almacen.AlmCsg = NO:
            i-Column = i-Column + 1.
            IF i-Column > 90            /* 'Z' */
            THEN ASSIGN
                    i-Column = 65       /* 'A' */
                    j-Column = IF j-Column = 0 THEN 65 ELSE j-Column + 1.
            FIND B-DETALLE WHERE B-DETALLE.CodCia = DETALLE.CodCia
                AND B-DETALLE.CodMat = DETALLE.CodMat
                AND B-DETALLE.CodAlm = Almacen.CodAlm
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-DETALLE THEN NEXT.
            IF j-Column = 0
            THEN cRange = CHR(i-Column) + cColumn.
            ELSE cRange = CHR(j-Column) + CHR(i-Column) + cColumn.
            chWorkSheet:Range(cRange):Value = B-DETALLE.StkAct.
        END.
        PAUSE 0.
    END.
END.
MESSAGE 'Reporte Terminado'.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/*
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia 
        BREAK BY Almmmatg.codmat:
    FIND FIRST DETALLE OF Almmmatg NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN NEXT.
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + DETALLE.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.desmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.catconta[1].
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.undbas.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE.ctouni.
    
    i-Column = 70.                   /* Letra F */
    j-Column = 0.
    IF FIRST-OF(Almmmatg.codmat) THEN DO:
        FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
                AND Almacen.FlgRep = YES AND Almacen.AlmCsg = NO:
            i-Column = i-Column + 1.
            IF i-Column > 90            /* 'Z' */
            THEN ASSIGN
                    i-Column = 65       /* 'A' */
                    j-Column = IF j-Column = 0 THEN 65 ELSE j-Column + 1.
            FIND DETALLE OF Almmmatg WHERE DETALLE.CodAlm = Almacen.CodAlm
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE DETALLE THEN NEXT.
            IF j-Column = 0
            THEN cRange = CHR(i-Column) + cColumn.
            ELSE cRange = CHR(j-Column) + CHR(i-Column) + cColumn.
            chWorkSheet:Range(cRange):Value = DETALLE.StkAct.
        END.
    END.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-StkTot AS DEC NO-UNDO.
  
  DEFINE FRAME F-DETALLE
    DETALLE.codmat      COLUMN-LABEL "Codigo"
    DETALLE.desmat      COLUMN-LABEL "Descripcion"          FORMAT 'X(34)'
    DETALLE.desmar      COLUMN-LABEL "Marca"                FORMAT 'X(10)'
    DETALLE.catconta[1] COLUMN-LABEL "CC"                   FORMAT 'X(2)'
    DETALLE.undbas      COLUMN-LABEL "Und"                  FORMAT 'X(7)'       
    DETALLE.stk03       COLUMN-LABEL "Stock!Ucayali"        FORMAT '->,>>9.99'
    DETALLE.stk04       COLUMN-LABEL "Stock!Andahuaylas"    FORMAT '->>,>>9.99'
    DETALLE.stk05       COLUMN-LABEL "Stock!Paruro"         FORMAT '->,>>9.99'
    DETALLE.stk11       COLUMN-LABEL "Stock!Sta. Raquel"    FORMAT '->>,>>9.99'
/*    DETALLE.stk12       COLUMN-LABEL "Stock!Fabrica"        FORMAT '->>,>>9.99'*/
    DETALLE.stk16       COLUMN-LABEL "Stock!San Miguel"     FORMAT '->,>>9.99'
    DETALLE.stk15       COLUMN-LABEL "Stock!Expolibreria"   FORMAT '->>>>,>>9.99'
    DETALLE.stk30       COLUMN-LABEL "Stock!Satelite Lima"  FORMAT '->>>>,>>9.99'
    DETALLE.stk83       COLUMN-LABEL "Stock!Junin"          FORMAT '->>,>>9.99'
    DETALLE.stk83b      COLUMN-LABEL "Stock!Frutales"       FORMAT '->>,>>9.99'
    DETALLE.stk85       COLUMN-LABEL "Stock!85"             FORMAT '->>,>>9.99'
    DETALLE.stk130      COLUMN-LABEL "Stock!130"            FORMAT '->>,>>9.99'
    DETALLE.stk131      COLUMN-LABEL "Stock!131"            FORMAT '->>,>>9.99'
    DETALLE.stk152      COLUMN-LABEL "Stock!152"            FORMAT '->>,>>9.99'
    DETALLE.stk160      COLUMN-LABEL "Stock!160"            FORMAT '->>,>>9.99'
    DETALLE.stkOtr      COLUMN-LABEL "Stock!Otros"          FORMAT '->>,>>9.99'
    x-StkTot            COLUMN-LABEL "Stock!Total"          FORMAT '->>,>>9.99'
    DETALLE.CtoUni      COLUMN-LABEL "Costo!Unitario"       FORMAT '->,>>9.99'
    DETALLE.CtoTot      COLUMN-LABEL "Total"                FORMAT '->,>>>,>>9.99'
  WITH WIDTH 320 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "VALORIZACION DEL STOCK LOGISTICO POR ALMACEN" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeC "HASTA EL CODIGO" HastaC "HASTA EL" DFecha SKIP
    "Almacenes: 03,04,05,11,16 y Otros" SKIP
    s-SubTit FORMAT 'x(50)' SKIP
  WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.catconta[1] BY DETALLE.desmat:
    VIEW STREAM REPORT FRAME F-HEADER.
    x-StkTot = DETALLE.stk03 + DETALLE.stk04 + DETALLE.stk05 + DETALLE.stk11 + DETALLE.stk16 + DETALLE.stk15 +
                DETALLE.stk12 + DETALLE.stk83b + DETALLE.stk85 + DETALLE.stk130 + DETALLE.stk131 +
                DETALLE.stk30 + DETALLE.stk83 + DETALLE.stk19 +
                DETALLE.stk152 + DETALLE.stk160 + DETALLE.stkotr.
    DISPLAY STREAM REPORT 
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar
        DETALLE.catconta[1] 
        DETALLE.undbas
        DETALLE.stk03       
        DETALLE.stk04       
        DETALLE.stk05       
        DETALLE.stk11       
/*        DETALLE.stk12       */
        DETALLE.stk16
        DETALLE.stk15
        DETALLE.stk30
        DETALLE.stk83       
        DETALLE.stk83b 
        DETALLE.stk85
        DETALLE.stk130
        DETALLE.stk131 
        DETALLE.stk152
        DETALLE.stk160 
        DETALLE.stkOtr      
        x-StkTot
        DETALLE.CtoUni      
        DETALLE.CtoTot      
        WITH FRAME F-DETALLE.
    ACCUMULATE DETALLE.ctotot (TOTAL BY DETALLE.codcia).
    IF LAST-OF(DETALLE.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>>" @ DETALLE.desmat
            ACCUM TOTAL BY DETALLE.codcia DETALLE.CtoTot @ DETALLE.ctotot
            WITH FRAME F-DETALLE.
    END.
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
  DEFINE FRAME F-DETALLE
    DETALLE.codfam      COLUMN-LABEL "Familia"             
    DETALLE.undbas      COLUMN-LABEL "Und"                  FORMAT 'X(7)'       
    DETALLE.stk03       COLUMN-LABEL "Total!Ucayali"        FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk04       COLUMN-LABEL "Total!Andahuaylas"    FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk05       COLUMN-LABEL "Total!Paruro"         FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk11       COLUMN-LABEL "Total!Sta. Raquel"    FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk16       COLUMN-LABEL "Total!San Miguel"     FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk15       COLUMN-LABEL "Total!Expolibreria"   FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk30       COLUMN-LABEL "Total!Satelite Lima"  FORMAT '->>>>,>>>,>>9.99'
    /*DETALLE.stk83       COLUMN-LABEL "Total!83"             FORMAT '->>>>,>>>,>>9.99'*/
    DETALLE.stkOtr      COLUMN-LABEL "Total!Otros"          FORMAT '->>>>,>>>,>>9.99'
    DETALLE.CtoTot      COLUMN-LABEL "Total"                FORMAT '->>>>,>>>,>>9.99'
  WITH WIDTH 210 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "VALORIZACION DEL STOCK LOGISTICO POR ALMACEN" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeC "HASTA EL CODIGO" HastaC "HASTA EL" DFecha SKIP
    "Almacenes: 03,04,05,11,16 y Otros" SKIP
    s-SubTit FORMAT 'x(50)' SKIP
  WITH PAGE-TOP WIDTH 210 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.codfam:
    VIEW STREAM REPORT FRAME F-HEADER.
    ACCUMULATE DETALLE.stk03  (TOTAL BY DETALLE.codfam BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk04  (TOTAL BY DETALLE.codfam BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk05  (TOTAL BY DETALLE.codfam BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk11  (TOTAL BY DETALLE.codfam BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk16  (TOTAL BY DETALLE.codfam BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk15  (TOTAL BY DETALLE.codfam BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk30  (TOTAL BY DETALLE.codfam BY DETALLE.codcia).
    /*ACCUMULATE DETALLE.stk83  (TOTAL BY DETALLE.codfam BY DETALLE.codcia).*/
    ACCUMULATE DETALLE.stkotr (TOTAL BY DETALLE.codfam BY DETALLE.codcia).
    ACCUMULATE DETALLE.ctotot (TOTAL BY DETALLE.codfam BY DETALLE.codcia).
    IF LAST-OF(DETALLE.codfam)
    THEN DO:
        DISPLAY STREAM REPORT 
            DETALLE.codfam
            ACCUM TOTAL BY DETALLE.codfam DETALLE.stk03  @ DETALLE.stk03       
            ACCUM TOTAL BY DETALLE.codfam DETALLE.stk04  @ DETALLE.stk04       
            ACCUM TOTAL BY DETALLE.codfam DETALLE.stk05  @ DETALLE.stk05       
            ACCUM TOTAL BY DETALLE.codfam DETALLE.stk11  @ DETALLE.stk11       
            ACCUM TOTAL BY DETALLE.codfam DETALLE.stk16  @ DETALLE.stk16       
            ACCUM TOTAL BY DETALLE.codfam DETALLE.stk15  @ DETALLE.stk15       
            ACCUM TOTAL BY DETALLE.codfam DETALLE.stk30  @ DETALLE.stk30
            /*ACCUM TOTAL BY DETALLE.codfam DETALLE.stk83  @ DETALLE.stk83       */
            ACCUM TOTAL BY DETALLE.codfam DETALLE.stkotr @ DETALLE.stkOtr      
            ACCUM TOTAL BY DETALLE.codfam DETALLE.ctotot @ DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
    END.
    IF LAST-OF(DETALLE.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.stk03
            DETALLE.stk04
            DETALLE.stk05
            DETALLE.stk11
            DETALLE.stk16
            DETALLE.stk15
            DETALLE.stk30
            /*DETALLE.stk83*/
            DETALLE.stkotr
            DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk03  @ DETALLE.stk03       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk04  @ DETALLE.stk04       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk05  @ DETALLE.stk05       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk11  @ DETALLE.stk11       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk16  @ DETALLE.stk16
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk15  @ DETALLE.stk15
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk30  @ DETALLE.stk30
            /*ACCUM TOTAL BY DETALLE.codcia DETALLE.stk83  @ DETALLE.stk83       */
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stkotr @ DETALLE.stkOtr      
            ACCUM TOTAL BY DETALLE.codcia DETALLE.CtoTot @ DETALLE.ctotot
            WITH FRAME F-DETALLE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-3 W-Win 
PROCEDURE Formato-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-DETALLE
    DETALLE.catconta[1] COLUMN-LABEL "CC"                   FORMAT 'X(2)'
    DETALLE.codmat      COLUMN-LABEL "Codigo"
    DETALLE.desmat      COLUMN-LABEL "Descripcion"          FORMAT 'X(35)'
    DETALLE.desmar      COLUMN-LABEL "Marca"                FORMAT 'X(10)'
    DETALLE.undbas      COLUMN-LABEL "Und"                  FORMAT 'X(7)'
    DETALLE.stk03       COLUMN-LABEL "Stock!Ucayali"        FORMAT '->,>>9.99'
    DETALLE.stk04       COLUMN-LABEL "Stock!Andahuaylas"    FORMAT '->>,>>9.99'
    DETALLE.stk05       COLUMN-LABEL "Stock!Paruro"         FORMAT '->,>>9.99'
    DETALLE.stk11       COLUMN-LABEL "Stock!Sta. Raquel"    FORMAT '->>,>>9.99'
    DETALLE.stk16       COLUMN-LABEL "Stock!San Miguel"     FORMAT '->,>>9.99'
    DETALLE.stk15       COLUMN-LABEL "Stock!Expolibreria"   FORMAT '->>>>,>>9.99'
    DETALLE.stk30       COLUMN-LABEL "Stock!Satelite Lima"  FORMAT '->>>>,>>9.99'
    /*DETALLE.stk83       COLUMN-LABEL "Stock!83"             FORMAT '->>,>>9.99'*/
    DETALLE.stkOtr      COLUMN-LABEL "Stock!Otros"          FORMAT '->>,>>9.99'
    DETALLE.CtoUni      COLUMN-LABEL "Costo!Unitario"       FORMAT '->,>>9.99'
    DETALLE.CtoTot      COLUMN-LABEL "Total"                FORMAT '->,>>>,>>9.99'
  WITH WIDTH 210 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "VALORIZACION DEL STOCK LOGISTICO POR ALMACEN" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeC "HASTA EL CODIGO" HastaC "HASTA EL" DFecha SKIP
    "Almacenes: 03,04,05,11,16 y Otros" SKIP
    s-SubTit FORMAT 'x(50)' SKIP
  WITH PAGE-TOP WIDTH 210 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.catconta[1] BY DETALLE.desmat:
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY STREAM REPORT 
        DETALLE.catconta[1] 
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar
        DETALLE.undbas
        DETALLE.stk03       
        DETALLE.stk04       
        DETALLE.stk05       
        DETALLE.stk11       
        DETALLE.stk16
        DETALLE.stk15
        DETALLE.stk30
        /*DETALLE.stk83       */
        DETALLE.stkOtr      
        DETALLE.CtoUni      
        DETALLE.CtoTot      
        WITH FRAME F-DETALLE.
    ACCUMULATE DETALLE.ctotot (TOTAL BY DETALLE.codcia BY DETALLE.catconta[1]).
    IF LAST-OF(DETALLE.catconta[1])
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            ("SUB-TOTAL CATEGORIA " + DETALLE.catconta[1] + " >>>") @ DETALLE.desmat
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.CtoTot @ DETALLE.ctotot
            WITH FRAME F-DETALLE.
        PUT STREAM REPORT " " SKIP.
    END.
    IF LAST-OF(DETALLE.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>>" @ DETALLE.desmat
            ACCUM TOTAL BY DETALLE.codcia DETALLE.CtoTot @ DETALLE.ctotot
            WITH FRAME F-DETALLE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-4 W-Win 
PROCEDURE Formato-4 :
/*------------------------------------------------------------------------------
  Purpose:     Resumido por categoria contable
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Nombre AS CHAR NO-UNDO.
  
  DEFINE FRAME F-DETALLE
    DETALLE.undbas      COLUMN-LABEL "Und"                  FORMAT 'X(7)'       
    DETALLE.catconta[1] COLUMN-LABEL "CC."
    x-nombre            COLUMN-LABEL "Descripcion"          FORMAT 'x(20)'
    DETALLE.stk03       COLUMN-LABEL "Total!Ucayali"        FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk04       COLUMN-LABEL "Total!Andahuaylas"    FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk05       COLUMN-LABEL "Total!Paruro"         FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk11       COLUMN-LABEL "Total!Sta. Raquel"    FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk16       COLUMN-LABEL "Total!San Miguel"     FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk15       COLUMN-LABEL "Total!Expolibreria"   FORMAT '->>>>,>>>,>>9.99'
    DETALLE.stk30       COLUMN-LABEL "Total!Satelite Lima"  FORMAT '->>>>,>>>,>>9.99'
    /*DETALLE.stk83       COLUMN-LABEL "Total!83"             FORMAT '->>>>,>>>,>>9.99'*/
    DETALLE.stkOtr      COLUMN-LABEL "Total!Otros"          FORMAT '->>>>,>>>,>>9.99'
    DETALLE.CtoTot      COLUMN-LABEL "Total"                FORMAT '->>>>,>>>,>>9.99'
  WITH WIDTH 210 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "VALORIZACION DEL STOCK LOGISTICO POR ALMACEN" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeC "HASTA EL CODIGO" HastaC "HASTA EL" DFecha SKIP
    "Almacenes: 03,04,05,11,16 y Otros" SKIP
    s-SubTit FORMAT 'x(50)' SKIP
  WITH PAGE-TOP WIDTH 210 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.catconta[1]:
    x-Nombre = 'SIN CATEGORIA'.
    FIND Almtabla WHERE almtabla.tabla = 'CC' 
        AND almtabla.codigo = DETALLE.catconta[1] NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN x-Nombre = almtabla.Nombre.
    VIEW STREAM REPORT FRAME F-HEADER.
    ACCUMULATE DETALLE.stk03  (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk04  (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk05  (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk11  (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk16  (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk15  (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk30  (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).
    /*ACCUMULATE DETALLE.stk83  (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).*/
    ACCUMULATE DETALLE.stkotr (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).
    ACCUMULATE DETALLE.ctotot (TOTAL BY DETALLE.catconta[1] BY DETALLE.codcia).
    IF LAST-OF(DETALLE.catconta[1])
    THEN DO:
        DISPLAY STREAM REPORT 
            DETALLE.catconta[1]
            x-nombre
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.stk03  @ DETALLE.stk03       
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.stk04  @ DETALLE.stk04       
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.stk05  @ DETALLE.stk05       
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.stk11  @ DETALLE.stk11       
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.stk16  @ DETALLE.stk16
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.stk15  @ DETALLE.stk15
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.stk30  @ DETALLE.stk30
            /*ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.stk83  @ DETALLE.stk83       */
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.stkotr @ DETALLE.stkOtr      
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.ctotot @ DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
    END.
    IF LAST-OF(DETALLE.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.stk03
            DETALLE.stk04
            DETALLE.stk05
            DETALLE.stk11
            DETALLE.stk16
            DETALLE.stk15
            DETALLE.stk30
            /*DETALLE.stk83*/
            DETALLE.stkotr
            DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk03  @ DETALLE.stk03       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk04  @ DETALLE.stk04       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk05  @ DETALLE.stk05       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk11  @ DETALLE.stk11       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk16  @ DETALLE.stk16
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk15  @ DETALLE.stk15
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk30  @ DETALLE.stk30
            /*ACCUM TOTAL BY DETALLE.codcia DETALLE.stk83  @ DETALLE.stk83       */
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stkotr @ DETALLE.stkOtr      
            ACCUM TOTAL BY DETALLE.codcia DETALLE.CtoTot @ DETALLE.ctotot
            WITH FRAME F-DETALLE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-5 W-Win 
PROCEDURE Formato-5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-ClfPro AS CHAR NO-UNDO.
  DEF VAR x-NomPro AS CHAR NO-UNDO.
  
  DEFINE FRAME F-DETALLE
    DETALLE.undbas      COLUMN-LABEL "Und"                  FORMAT 'X(7)'       
    x-clfpro            COLUMN-LABEL "F"
    DETALLE.codpr1      COLUMN-LABEL "Proveedor"             
    x-nompro            COLUMN-LABEL "Nombre"
    DETALLE.stk03       COLUMN-LABEL "Total!Ucayali"        FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk04       COLUMN-LABEL "Total!Andahuaylas"    FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk05       COLUMN-LABEL "Total!Paruro"         FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk11       COLUMN-LABEL "Total!Sta. Raquel"    FORMAT '->>>>>>>>,>>9.99'
/*    DETALLE.stk12       COLUMN-LABEL "Total!Fabrica"        FORMAT '->>>>>>>>>,>>9.99'*/
    DETALLE.stk16       COLUMN-LABEL "Total!San Miguel"     FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk15       COLUMN-LABEL "Total!Expolibreria"   FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk30       COLUMN-LABEL "Total!Satelite Lima"  FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk83       COLUMN-LABEL "Total!Junin"          FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk83b      COLUMN-LABEL "Total!Frutales"       FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk85       COLUMN-LABEL "Total!85"             FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk130      COLUMN-LABEL "Total!130"            FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk131      COLUMN-LABEL "Total!131"            FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk152      COLUMN-LABEL "Total!152"            FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stk160      COLUMN-LABEL "Total!160"            FORMAT '->>>>>>>>,>>9.99'
    DETALLE.stkOtr      COLUMN-LABEL "Total!Otros"          FORMAT '->>>>>>>>,>>9.99'
    DETALLE.CtoTot      COLUMN-LABEL "Total"                FORMAT '->>>>>>>>>,>>9.99'
  WITH WIDTH 320 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "VALORIZACION DEL STOCK LOGISTICO POR ALMACEN" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeC "HASTA EL CODIGO" HastaC "HASTA EL" DFecha SKIP
    "Almacenes: 03,04,05,11,16 y Otros" SKIP
    s-SubTit FORMAT 'x(50)' SKIP
  WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.codpr1:
    ASSIGN
        x-ClfPro = ''
        x-NomPro = 'SIN PROVEEDOR'.
    FIND GN-PROV WHERE GN-PROV.codcia = pv-codcia
        AND GN-PROV.codpro = DETALLE.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-PROV
    THEN ASSIGN
            x-ClfPro = GN-PROV.ClfPro
            x-NomPro = GN-PROV.NomPro.
    VIEW STREAM REPORT FRAME F-HEADER.
    ACCUMULATE DETALLE.stk03  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk04  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk05  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk11  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
/*    ACCUMULATE DETALLE.stk12  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).*/
    ACCUMULATE DETALLE.stk16  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk15  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk30  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk83  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk83b (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk85  (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk130 (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk131 (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk152 (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stk160 (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.stkotr (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    ACCUMULATE DETALLE.ctotot (TOTAL BY DETALLE.codpr1 BY DETALLE.codcia).
    IF LAST-OF(DETALLE.codpr1)
    THEN DO:
        DISPLAY STREAM REPORT 
            x-clfpro
            DETALLE.codpr1
            x-nompro
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk03  @ DETALLE.stk03       
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk04  @ DETALLE.stk04       
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk05  @ DETALLE.stk05       
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk11  @ DETALLE.stk11       
/*            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk12  @ DETALLE.stk12*/
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk16  @ DETALLE.stk16       
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk15  @ DETALLE.stk15       
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk30  @ DETALLE.stk30
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk83  @ DETALLE.stk83       
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk83b @ DETALLE.stk83b 
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk85  @ DETALLE.stk85
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk130 @ DETALLE.stk130
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk131 @ DETALLE.stk131
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk152 @ DETALLE.stk152
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stk160 @ DETALLE.stk160
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.stkotr @ DETALLE.stkOtr      
            ACCUM TOTAL BY DETALLE.codpr1 DETALLE.ctotot @ DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
    END.
    IF LAST-OF(DETALLE.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.stk03
            DETALLE.stk04
            DETALLE.stk05
            DETALLE.stk11
/*            DETALLE.stk12*/
            DETALLE.stk16
            DETALLE.stk15
            DETALLE.stk30
            DETALLE.stk83
            DETALLE.stk83b
            DETALLE.stk85
            DETALLE.stk130
            DETALLE.stk131
            DETALLE.stk152
            DETALLE.stk160
            DETALLE.stkotr
            DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk03  @ DETALLE.stk03       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk04  @ DETALLE.stk04       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk05  @ DETALLE.stk05       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk11  @ DETALLE.stk11       
/*            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk12  @ DETALLE.stk12*/
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk16  @ DETALLE.stk16
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk15  @ DETALLE.stk15
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk30  @ DETALLE.stk30
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk83  @ DETALLE.stk83       
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk83b @ DETALLE.stk83b
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk85  @ DETALLE.stk85      
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk130 @ DETALLE.stk130
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk131 @ DETALLE.stk131
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk152 @ DETALLE.stk152
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stk160 @ DETALLE.stk160
            ACCUM TOTAL BY DETALLE.codcia DETALLE.stkotr @ DETALLE.stkOtr      
            ACCUM TOTAL BY DETALLE.codcia DETALLE.CtoTot @ DETALLE.ctotot
            WITH FRAME F-DETALLE.
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
    ENABLE ALL EXCEPT FILL-IN-Nombre x-mensaje.
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

    RUN Carga-Temporal.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    s-SubTit = IF R-COSTO = 1 THEN
        'EN NUEVOS SOLES AL COSTO PROMEDIO'
    ELSE
        'EN NUEVOS SOLES AL VALOR DE MERCADO'.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        CASE RADIO-SET-1:
            WHEN 1 THEN RUN Formato.
            WHEN 2 THEN RUN Formato-2.
            WHEN 3 THEN RUN Formato-3.
            WHEN 4 THEN RUN Formato-4.
            WHEN 5 THEN RUN Formato-5.
        END CASE.
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
    ASSIGN DesdeC HastaC DFecha cCategoria RADIO-SET-1 R-Costo TOGGLE-1 c-CodFam x-codalm.
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
    DFecha = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Almacen WHERE almacen.codcia = s-codcia
            AND almacen.flgrep = YES NO-LOCK:
        IF Almacen.AlmCsg = YES THEN NEXT.
        x-CodAlm:ADD-LAST(Almacen.codalm).
    END.
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

