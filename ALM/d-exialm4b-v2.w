&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.



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
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

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

/****************/
DEFINE VAR F-STKGEN  AS DECIMAL NO-UNDO.
DEFINE VAR F-PESGEN  AS DECIMAL NO-UNDO.
DEFINE VAR F-VALCTO  AS DECIMAL NO-UNDO.
DEFINE VAR F-PRECTO  AS DECIMAL NO-UNDO.
DEFINE VAR C-MONEDA  AS CHARACTER FORMAT "X(20)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE VAR CATEGORIA AS CHAR INIT "MD".
DEFINE VAR x-nompro AS CHAR FORMAT "X(30)".
DEFINE VAR x-codpro AS CHAR FORMAT "X(11)".

/*****************/

DEF TEMP-TABLE Detalle
    FIELD CodFam LIKE Almmmatg.codfam COLUMN-LABEL 'FAMILIA'
    FIELD DesFam LIKE Almtfami.desfam COLUMN-LABEL 'NOM. FAM.'
    FIELD SubFam LIKE Almmmatg.codfam COLUMN-LABEL 'SUB-FAMILIA'
    FIELD DesSub LIKE Almsfami.dessub COLUMN-LABEL 'NOM. SUB-FAM.'
    FIELD CodPro AS CHAR FORMAT 'x(11)' COLUMN-LABEL 'PROVEEDOR' INIT ""
    FIELD NomPro AS CHAR FORMAT 'x(30)' COLUMN-LABEL 'NOM. PROVEE.' INIT ""
    FIELD CodMat LIKE Almmmatg.codmat COLUMN-LABEL 'CODIGO'
    FIELD DesMat LIKE Almmmatg.desmat COLUMN-LABEL 'DESCRIPCION'
    FIELD DesMar LIKE Almmmatg.desmar COLUMN-LABEL 'MARCA'
    FIELD UndStk LIKE Almmmatg.undstk COLUMN-LABEL 'UNIDAD'
    FIELD CodAlm LIKE Almacen.codalm COLUMN-LABEL 'ALMACEN'
    FIELD NomAlm LIKE Almacen.Descripcion COLUMN-LABEL 'NOM. ALM.'
    FIELD StkAct LIKE Almmmate.stkact COLUMN-LABEL 'STOCK'
    FIELD StkCom AS DEC COLUMN-LABEL 'STOCK COMPROMETIDO'   INIT 0
    FIELD StkDis AS DEC COLUMN-LABEL "Stock Disponible" INIT 0
    FIELD StkTra AS DEC COLUMN-LABEL 'Transito por Transferencia'   INIT 0
    FIELD StkCmp AS DEC COLUMN-LABEL 'Transito por Compras' INIT 0
    FIELD MaxCampana   LIKE Almmmate.VCtMn1 COLUMN-LABEL 'MAX. CAMPAÑA'
    FIELD MaxNoCampana LIKE Almmmate.VCtMn2 COLUMN-LABEL 'MAX.NO CAMPAÑA'
    FIELD EmpRepo   AS DEC  COLUMN-LABEL "Empaque Reposicion" INIT 0
    FIELD EmpInn    AS DEC  COLUMN-LABEL "Empaque Inner" INIT 0
    FIELD EmpMas    AS DEC  COLUMN-LABEL "Empaque Master" INIT 0
    FIELD flgcomercial    AS CHAR   FORMAT 'x(30)'  COLUMN-LABEL "Indice Comercial" INIT ""
    FIELD cmpClfGrl AS CHAR FORMAT 'x(3)'  COLUMN-LABEL "Campaña-Clasf Gral"   INIT ""
    FIELD cmpClfUti AS CHAR FORMAT 'x(3)'  COLUMN-LABEL "Campaña-Clasf Utilex" INIT ""
    FIELD cmpClfMay AS CHAR FORMAT 'x(3)'  COLUMN-LABEL "Campaña-Clasf Mayorista"  INIT ""    
    FIELD nocmpClfGrl AS CHAR FORMAT 'x(3)'  COLUMN-LABEL "NO Campaña-Clasf Gral"   INIT ""
    FIELD nocmpClfUti AS CHAR FORMAT 'x(3)'  COLUMN-LABEL "NO Campaña-Clasf Utilex" INIT ""
    FIELD nocmpClfMay AS CHAR FORMAT 'x(3)'  COLUMN-LABEL "NO Campaña-Clasf Mayorista"  INIT ""    
    FIELD CostoKardex    AS DEC  COLUMN-LABEL "Costo Kardex" INIT 0
    .


DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

/*codmat*/

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodFam R-Tipo FILL-IN-SubFam DesdeC ~
F-marca1 F-provee1 EDITOR-CodAlm BUTTON-3 BUTTON-5 TipoStk BUTTON-4 ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodFam R-Tipo FILL-IN-SubFam ~
DesdeC HastaC F-marca1 F-marca2 F-provee1 F-provee2 EDITOR-CodAlm ~
FILL-IN-Archivo TipoStk 

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
     SIZE 13 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .96.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-5 
     LABEL "..." 
     SIZE 4 BY 1.12.

DEFINE VARIABLE EDITOR-CodAlm AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 49 BY 2.42 NO-UNDO.

DEFINE VARIABLE D-Corte AS DATE FORMAT "99/99/9999":U 
     LABEL "Corte Al" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-marca1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-marca2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-provee1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-provee2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Archivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo texto de productos" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 12.86 BY 2.31 NO-UNDO.

DEFINE VARIABLE TipoStk AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo Articulos con Stock", 1,
"Todos los Seleccionados", 2
     SIZE 43 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodFam AT ROW 1.38 COL 20 COLON-ALIGNED
     R-Tipo AT ROW 1.38 COL 63 NO-LABEL
     FILL-IN-SubFam AT ROW 2.35 COL 20 COLON-ALIGNED
     DesdeC AT ROW 3.31 COL 20 COLON-ALIGNED
     HastaC AT ROW 3.31 COL 35 COLON-ALIGNED
     F-marca1 AT ROW 4.27 COL 20 COLON-ALIGNED
     F-marca2 AT ROW 4.27 COL 35 COLON-ALIGNED
     D-Corte AT ROW 4.27 COL 61 COLON-ALIGNED
     F-provee1 AT ROW 5.23 COL 20 COLON-ALIGNED
     F-provee2 AT ROW 5.23 COL 35 COLON-ALIGNED
     EDITOR-CodAlm AT ROW 6.12 COL 22 NO-LABEL WIDGET-ID 14
     BUTTON-3 AT ROW 6.12 COL 71
     FILL-IN-Archivo AT ROW 8.54 COL 20 COLON-ALIGNED WIDGET-ID 8
     BUTTON-5 AT ROW 8.54 COL 71 WIDGET-ID 10
     TipoStk AT ROW 10.15 COL 22 NO-LABEL
     BUTTON-4 AT ROW 11.23 COL 3 WIDGET-ID 6
     Btn_Cancel AT ROW 11.23 COL 18
     "Almacenes:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 6.12 COL 13 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.35
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Existencias por Proveedor"
         HEIGHT             = 12.35
         WIDTH              = 80
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
/* SETTINGS FOR FILL-IN D-Corte IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       D-Corte:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN F-marca2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-provee2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Archivo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN HastaC IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Existencias por Proveedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Existencias por Proveedor */
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = EDITOR-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    EDITOR-CodAlm:SCREEN-VALUE = x-almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  RUN Asigna-Variables.
  /* CONSISTENCIA */
  IF NUM-ENTRIES(EDITOR-CodAlm) = 0 THEN DO:
    MESSAGE 'Debe seleccionar al menos 1 almacén'
        VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
/*
  IF FILL-IN-Archivo = "" THEN DO:
      IF DesdeC = "" AND f-Marca1 = "" AND f-provee1 = "" THEN DO:
          MESSAGE 'Debe ingresar al menos Articulo y/o Marca y/o Proveedor'
              VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
*/
  RUN Inhabilita.

  /* Archivo de Salida */
  DEF VAR c-csv-file AS CHAR NO-UNDO.
  DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
  DEF VAR rpta AS LOG INIT NO NO-UNDO.

  SYSTEM-DIALOG GET-FILE c-xls-file
      FILTERS 'Libro de Excel' '*.xlsx'
      INITIAL-FILTER 1
      ASK-OVERWRITE
      CREATE-TEST-FILE
      DEFAULT-EXTENSION ".xlsx"
      SAVE-AS
      TITLE "Guardar como"
      USE-FILENAME
      UPDATE rpta.
  IF rpta = YES THEN DO:
      /* Cargamos la informacion al temporal */
      SESSION:SET-WAIT-STATE('GENERAL').
      EMPTY TEMP-TABLE DETALLE.
      RUN Carga-Temporal-1.
      IF NOT CAN-FIND(FIRST DETALLE NO-LOCK) THEN DO:
          SESSION:SET-WAIT-STATE('').
          MESSAGE 'Fin de Archivo' VIEW-AS ALERT-BOX WARNING.
          RETURN NO-APPLY.
      END.
      /* Variable de memoria */
      DEFINE VAR hProc AS HANDLE NO-UNDO.
      /* Levantamos la libreria a memoria */
      RUN lib\Tools-to-excel PERSISTENT SET hProc.
      /* Programas que generan el Excel */
      RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                        INPUT c-xls-file,
                                        OUTPUT c-csv-file) .

      RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                        INPUT  c-csv-file,
                                        OUTPUT c-xls-file) .

      /* Borramos librerias de la memoria */
      DELETE PROCEDURE hProc.
      SESSION:SET-WAIT-STATE('').
      MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
  END.
  RUN Habilita.
  RUN Inicializa-Variables.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Archivo AS CHAR.
  DEF VAR rpta AS LOG.

  SYSTEM-DIALOG GET-FILE x-Archivo
      FILTERS '*.txt' '*.txt'
      DEFAULT-EXTENSION 'txt'  
      RETURN-TO-START-DIR 
      TITLE 'Seleccione el archivo de texto'
      UPDATE rpta.
  IF rpta = YES THEN FILL-IN-Archivo:SCREEN-VALUE = x-Archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
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


&Scoped-define SELF-NAME F-marca1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-marca1 W-Win
ON LEAVE OF F-marca1 IN FRAME F-Main /* Marca */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND almtabla WHERE almtabla.Tabla = "MK" 
                  AND  almtabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE almtabla THEN DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-marca2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-marca2 W-Win
ON LEAVE OF F-marca2 IN FRAME F-Main /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND almtabla WHERE almtabla.Tabla = "MK" 
                  AND  almtabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE almtabla THEN DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-provee1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-provee1 W-Win
ON LEAVE OF F-provee1 IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN do:
/*     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.*/
  END.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                    AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-provee2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-provee2 W-Win
ON LEAVE OF F-provee2 IN FRAME F-Main /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN do:
/*     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.*/
  END.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                    AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
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
  ASSIGN D-Corte DesdeC
         /*HastaC*/ TipoStk R-Tipo
         F-marca1 /*F-marca2*/ F-provee1 /*F-provee2 */
         FILL-IN-CodFam FILL-IN-SubFam
         EDITOR-CodAlm
         FILL-IN-Archivo.
  
  S-SUBTIT = "Materiales del " + DesdeC.
  /*
  IF HastaC <> "" THEN S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
  IF F-marca2 = "" THEN F-marca2 = "ZZZZZZZZZZZZZ".
  IF F-provee2 = "" THEN F-provee2 = "ZZZZZZZZZZZZZ".
  */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-1 W-Win 
PROCEDURE Carga-Temporal-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR F-STKALM  AS DECIMAL NO-UNDO.
  DEF VAR x-CodAlm LIKE Almacen.codalm NO-UNDO.
  DEF VAR x-Linea  AS CHAR FORMAT 'x(100)'.
  DEF VAR x-Item   AS INT NO-UNDO.
  DEF VAR pComprometido AS DEC NO-UNDO.
  DEF VAR pTransito AS DEC NO-UNDO.
  DEF VAR x-CodMat AS CHAR FORMAT 'x(1000)'.

  DEFINE VAR lComp-x-llegar AS DEC.

  EMPTY TEMP-TABLE Detalle.
  EMPTY TEMP-TABLE T-MATG.
  ASSIGN
      x-CodMat = ''
      x-Item = 1.
  
  IF FILL-IN-Archivo <> "" THEN DO:
      INPUT FROM VALUE(FILL-IN-Archivo).
      REPEAT:
          IMPORT UNFORMATTED x-Linea.
          IF x-Linea <> '' THEN DO:
              FIND T-MATG WHERE T-MATG.codcia = s-codcia
                  AND T-MATG.codmat = x-Linea
                  NO-LOCK NO-ERROR.
              IF NOT AVAILABLE T-MATG THEN DO:
                  CREATE T-MATG.
                  ASSIGN
                      T-MATG.codcia = s-codcia
                      T-MATG.codmat = x-Linea.
              END.
/*               IF x-CodMat = ''                                             */
/*                   THEN x-CodMat = SUBSTRING(x-linea,1,6).                  */
/*                   ELSE x-CodMat = x-CodMat + ',' + SUBSTRING(x-linea,1,6). */
          END.
          x-Item = x-Item + 1.
      END.
  END.
  ELSE DO:
      FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
          AND (f-Marca1 = "" OR Almmmatg.CodMar = F-marca1)
          AND (f-provee1 = "" OR Almmmatg.CodPr1 = F-provee1)
          AND (R-Tipo = '' OR Almmmatg.TpoArt = R-Tipo)
          AND almmmatg.codfam BEGINS FILL-IN-CodFam
          AND almmmatg.subfam BEGINS FILL-IN-SubFam
          AND (DesdeC = "" OR almmmatg.codmat = DesdeC)
          AND almmmatg.fchces = ?,
          FIRST Almtfami OF Almmmatg NO-LOCK,
          FIRST Almsfami OF Almmmatg NO-LOCK:
          CREATE T-MATG.
          ASSIGN
              T-MATG.codcia = Almmmatg.codcia
              T-MATG.codmat = Almmmatg.codmat.
      END.
  END.

  FOR EACH T-MATG NO-LOCK, FIRST Almmmatg OF T-MATG NO-LOCK,
      FIRST Almtfami OF Almmmatg NO-LOCK,
      FIRST Almsfami OF Almmmatg NO-LOCK:
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
          FORMAT "X(11)" WITH FRAME F-Proceso.
      ALMACENES:
      DO x-Item = 1 TO NUM-ENTRIES(EDITOR-CodAlm):
          x-CodAlm = ENTRY(x-Item, EDITOR-CodAlm).
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = x-CodAlm
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almacen THEN NEXT ALMACENES.
          ASSIGN
              F-STKALM = 0
              X-NOMPRO = "SIN PROVEEDOR".

          FIND FIRST Almmmate OF Almmmatg WHERE Almmmate.codalm = x-CodAlm NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmate THEN f-StkAlm = Almmmate.stkact.

          IF TipoStk = 1 AND F-STKALM = 0 THEN NEXT ALMACENES.

          /* Ic - 06Nov2017, Max Ramos desde Chiclayo */
          /* ACUMULAMOS STOCK COMPROMETIDO */
          RUN gn/stock-comprometido-v2 (Almmmatg.CodMat, 
                                        x-CodAlm, 
                                        NO,
                                        OUTPUT pComprometido).
/*           RUN vta2/stock-comprometido-v2 (Almmmatg.CodMat,       */
/*                                           x-CodAlm,              */
/*                                           OUTPUT pComprometido). */
          /* En Tránsito */
          RUN alm/p-articulo-en-transito (
              Almmmatg.CodCia,
              x-CodAlm,
              Almmmatg.CodMat,
              INPUT-OUTPUT TABLE tmp-tabla,
              OUTPUT pTransito).
          /**/
          lComp-x-llegar = 0.
          RUN compras-x-llegar(INPUT x-CodAlm, INPUT almmmatg.codmat, 
                               OUTPUT lComp-x-llegar).

          IF TipoStk = 2 THEN DO:

              IF NOT AVAILABLE almmmate THEN NEXT ALMACENES.

              IF (f-StkAlm - pComprometido) = 0 AND     /* Disponible */
                    pTransito = 0 AND                   /* Transito x transferencas */
                    lComp-x-llegar = 0 AND              /* Compras x llegar */
                    Almmmate.VCtMn1 = 0 AND             /* Maximo CAMPAÑA */
                    Almmmate.VCtMn2 = 0 AND             /* Maximo NO CAMPAÑA */
                    almmmate.stkmax = 0                /* Emapque reposicion */
                    THEN DO:
                    NEXT ALMACENES.
              END.
          END.
          /* Ic - 06Nov2017 - Fin */

          FIND Gn-Prov WHERE 
              Gn-Prov.Codcia = pv-codcia AND
              Gn-Prov.CodPro = Almmmatg.CodPr1 
              NO-LOCK NO-ERROR.
          IF AVAILABLE Gn-Prov THEN x-nompro = Gn-Prov.NomPro.
          /* GRABAMOS LA INFORMACION */
          CREATE DETALLE.
          BUFFER-COPY Almmmatg 
              TO DETALLE
              ASSIGN
              DETALLE.DesFam = Almtfami.desfam
              DETALLE.DesSub = Almsfami.dessub
              DETALLE.CodPro = Almmmatg.CodPr1
              DETALLE.NomPro = x-NomPro
              DETALLE.CodAlm = x-CodAlm
              DETALLE.NomAlm = Almacen.Descripcion
              DETALLE.StkAct = f-StkAlm.

          /* Ic - 11Set2018, INDICE COMERCIAL, correo lucy mesia del 10set2018 */
          FIND FIRST almtabla WHERE almtabla.tabla = 'IN_CO' AND 
                                    almtabla.codigo = almmmatg.flgcomercial 
                                    NO-LOCK NO-ERROR.
          IF AVAILABLE almtabla THEN ASSIGN DETALLE.flgcomercial = almtabla.nombre.
          /* ------ */
          
          /* Ranking */
          FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                                    factabla.tabla = 'RANKVTA' AND
                                    factabla.codigo = detalle.codmat 
                                    NO-LOCK NO-ERROR.
          IF AVAILABLE factabla THEN DO:
                ASSIGN detalle.cmpclfGrl = factabla.campo-c[1]
                        detalle.cmpclfMay = factabla.campo-c[2]
                        detalle.cmpclfUti = factabla.campo-c[3].
                ASSIGN detalle.nocmpclfGrl = factabla.campo-c[4]
                        detalle.nocmpclfMay = factabla.campo-c[5]
                        detalle.nocmpclfUti = factabla.campo-c[6].

          END.
          
          ASSIGN
              DETALLE.StkCom = pComprometido.
          ASSIGN
              DETALLE.StkTra = pTransito.
          /* RHC 10/04/17 Max Ramos */
          IF AVAILABLE Almmmate THEN
              ASSIGN
              DETALLE.MaxCampana   = Almmmate.VCtMn1
              DETALLE.MaxNoCampana = Almmmate.VCtMn2.
        
          ASSIGN detalle.StkDis = detalle.stkact - detalle.stkcom
                detalle.StkCmp = lComp-x-llegar
                detalle.EmpRepo = IF (AVAILABLE Almmmate) THEN almmmate.stkmax ELSE 0
                detalle.empinn  = almmmatg.stkrep
                detalle.empmas  = almmmatg.canemp.

        /* Ic - 12Jun2019, Indicacion de Daniel a pedido de Ana Ruiz*/
        /* Costo Promedio Kardex  */

        FIND LAST almstkge WHERE almstkge.codcia = s-codcia AND
                                    almstkge.codmat = Almmmatg.CodMat AND
                                    almstkge.fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE almstkge THEN DO:
            ASSIGN detalle.CostoKardex = almstkge.ctouni.
        END.

      END.
  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/*
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
      AND (f-Marca1 = "" OR Almmmatg.CodMar = F-marca1)
      AND (f-provee1 = "" OR Almmmatg.CodPr1 = F-provee1)
      AND (R-Tipo = '' OR Almmmatg.TpoArt = R-Tipo)
      AND almmmatg.codfam BEGINS FILL-IN-CodFam
      AND almmmatg.subfam BEGINS FILL-IN-SubFam
      AND (DesdeC = "" OR almmmatg.codmat = DesdeC)
      AND almmmatg.fchces = ?,
      FIRST Almtfami OF Almmmatg NO-LOCK,
      FIRST Almsfami OF Almmmatg NO-LOCK:

      IF FILL-IN-Archivo <> "" AND LOOKUP(almmmatg.codmat, x-codmat) = 0 THEN NEXT.
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
          FORMAT "X(11)" WITH FRAME F-Proceso.
      ALMACENES:
      DO x-Item = 1 TO NUM-ENTRIES(EDITOR-CodAlm):
          x-CodAlm = ENTRY(x-Item, EDITOR-CodAlm).
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = x-CodAlm
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almacen THEN NEXT ALMACENES.
          ASSIGN
              F-STKALM = 0
              X-NOMPRO = "SIN PROVEEDOR".
          FIND Almmmate OF Almmmatg WHERE Almmmate.codalm = x-CodAlm NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmate THEN f-StkAlm = Almmmate.stkact.

          IF TipoStk = 1 AND F-STKALM = 0 THEN NEXT ALMACENES.
          FIND Gn-Prov WHERE 
              Gn-Prov.Codcia = pv-codcia AND
              Gn-Prov.CodPro = Almmmatg.CodPr1 
              NO-LOCK NO-ERROR.
          IF AVAILABLE Gn-Prov THEN x-nompro = Gn-Prov.NomPro.
          /* GRABAMOS LA INFORMACION */
          CREATE DETALLE.
          BUFFER-COPY Almmmatg 
              TO DETALLE
              ASSIGN
              DETALLE.DesFam = Almtfami.desfam
              DETALLE.DesSub = Almsfami.dessub
              DETALLE.CodPro = Almmmatg.CodPr1
              DETALLE.NomPro = x-NomPro
              DETALLE.CodAlm = x-CodAlm
              DETALLE.NomAlm = Almacen.Descripcion
              DETALLE.StkAct = f-StkAlm.
          
          /* Ranking */
          FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                                    factabla.tabla = 'RANKVTA' AND
                                    factabla.codigo = detalle.codmat 
                                    NO-LOCK NO-ERROR.
          IF AVAILABLE factabla THEN DO:
                ASSIGN detalle.clfGrl = factabla.campo-c[1]
                        detalle.clfMay = factabla.campo-c[3]
                        detalle.clfUti = factabla.campo-c[2].
          END.
          
          /* ACUMULAMOS STOCK COMPROMETIDO */
          RUN vta2/stock-comprometido-v2 (Almmmatg.CodMat, 
                                          x-CodAlm, 
                                          OUTPUT pComprometido).
          ASSIGN
              DETALLE.StkCom = pComprometido.
          /* En Tránsito */
          RUN alm/p-articulo-en-transito (
              Almmmatg.CodCia,
              x-CodAlm,
              Almmmatg.CodMat,
              INPUT-OUTPUT TABLE tmp-tabla,
              OUTPUT pComprometido).
          ASSIGN
              DETALLE.StkTra = pComprometido.
          /* RHC 10/04/17 Max Ramos */
          IF AVAILABLE Almmmate THEN
              ASSIGN
              DETALLE.MaxCampana   = Almmmate.VCtMn1
              DETALLE.MaxNoCampana = Almmmate.VCtMn2.
        
          /**/
          lComp-x-llegar = 0.
          RUN compras-x-llegar(INPUT detalle.codalm, INPUT detalle.codmat, OUTPUT lComp-x-llegar).

          ASSIGN detalle.StkDis = detalle.stkact - detalle.stkcom
                detalle.StkCmp = lComp-x-llegar
                detalle.EmpRepo = IF (AVAILABLE Almmmate) THEN almmmate.stkmax ELSE 0
                detalle.empinn  = almmmatg.stkrep
                detalle.empmas  = almmmatg.canemp.

      END.
  END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compras-x-llegar W-Win 
PROCEDURE compras-x-llegar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodAlm AS CHAR.
DEFINE INPUT PARAMETER pCodmat AS CHAR.
DEFINE OUTPUT PARAMETER pCant AS DEC.

pCant = 0.

FOR EACH OOComPend WHERE OOComPend.codalm = pCodAlm AND 
                            OOComPend.codmat = pCodMat NO-LOCK:
    pCant = pCant + (OOComPend.CanPed - OOComPend.CanAte).
END.

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
  DISPLAY FILL-IN-CodFam R-Tipo FILL-IN-SubFam DesdeC HastaC F-marca1 F-marca2 
          F-provee1 F-provee2 EDITOR-CodAlm FILL-IN-Archivo TipoStk 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodFam R-Tipo FILL-IN-SubFam DesdeC F-marca1 F-provee1 
         EDITOR-CodAlm BUTTON-3 BUTTON-5 TipoStk BUTTON-4 Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
    ENABLE ALL EXCEPT D-Corte FILL-IN-Archivo.
END.

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
  ASSIGN D-Corte DesdeC 
         /*HastaC*/ TipoStk R-Tipo
         F-marca1 /*F-marca2*/ F-provee1 /*F-provee2*/ FILL-IN-Archivo.
  
  /*
  IF HastaC <> "" THEN HastaC = "".
  IF F-marca2 <> "" THEN F-marca2 = "".
  IF F-provee2 <> "" THEN F-provee2 = "".
  */
  FILL-IN-Archivo = ''.
  DISPLAY /**HastaC f-Marca2 f-Provee2*/ FILL-IN-Archivo.
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
     D-Corte:SENSITIVE = NO.
     D-Corte = TODAY.
     FILL-IN-Archivo = ''.
     /*DISPLAY D-Corte R-Tipo FILL-IN-Archivo.*/
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
        WHEN "FILL-IN-SubFam" THEN input-var-1 = FILL-IN-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
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

