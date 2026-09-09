&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE TEMP-TABLE Reporte  
    FIELDS CodMat LIKE Almmmate.Codmat
    FIELDS DesMat LIKE Almmmatg.DesMat
    FIELDS CodPro LIKE Almmmatg.CodPr1
    FIELDS CanEmp LIKE Almmmatg.CanEmp
    FIELDS CodMar LIKE Almmmate.CodMar
    FIELDS DesMar LIKE Almmmatg.DesMar FORMAT "X(11)" 
    FIELDS UndBas LIKE Almmmatg.UndBas
    FIELDS TpoArt LIKE Almmmatg.TpoArt
    FIELDS TipArt LIKE Almmmatg.TipArt
    FIELDS StkAct LIKE Almmmate.StkAct
    FIELDS StkMin LIKE Almmmate.StkMin
    FIELDS StkMax LIKE Almmmate.StkMax
    FIELDS StkRep LIKE Almmmate.StkRep
    FIELDS Stk03  LIKE Almmmate.StkAct COLUMN-LABEL "Disponible 03"
    FIELDS Stk04  LIKE Almmmate.StkAct COLUMN-LABEL "Disponible 04"
    FIELDS Stk05  LIKE Almmmate.StkAct COLUMN-LABEL "Disponible 05"
    FIELDS Stk11  LIKE Almmmate.StkAct COLUMN-LABEL "Disponible 11"
    FIELDS Stk17  LIKE Almmmate.StkAct COLUMN-LABEL "Disponible 17"
    FIELDS Stk35A LIKE Almmmate.StkAct COLUMN-LABEL "Stock 35A"
    FIELDS Stk15  LIKE Almmmate.StkAct COLUMN-LABEL "Stock 15".

DEFINE VAR C-OP     AS CHAR.
DEFINE VAR F-PESALM AS DECIMAL NO-UNDO.

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
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE VAR F-STKGEN  AS DECIMAL NO-UNDO.
DEFINE VAR F-PESGEN  AS DECIMAL NO-UNDO.
DEFINE VAR F-VALCTO  AS DECIMAL NO-UNDO.
DEFINE VAR F-PRECTO  AS DECIMAL NO-UNDO.
DEFINE VAR C-MONEDA  AS CHARACTER FORMAT "X(20)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR S-SUBTIT-1 AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-STKALM  AS DECIMAL NO-UNDO.
DEFINE VAR CATEGORIA AS CHAR INIT "MD".
DEFINE VAR x-nompro AS CHAR FORMAT "X(30)".
DEFINE VAR x-codpro AS CHAR FORMAT "X(11)".

DEFINE BUFFER B-Mate FOR Almmmate.
DEFINE BUFFER T-MATE FOR Almmmate.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almacen ImCOCmp Almmmatg

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 Almacen.CodAlm Almacen.Descripcion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH Almacen ~
      WHERE Almacen.CodAlm = "03" OR  ~
Almacen.CodAlm = "04" OR ~
Almacen.CodAlm = "05" OR ~
Almacen.CodAlm = "11" OR ~
Almacen.CodAlm = "15" OR ~
Almacen.CodAlm = "17" OR ~
Almacen.CodAlm = "35A" NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH Almacen ~
      WHERE Almacen.CodAlm = "03" OR  ~
Almacen.CodAlm = "04" OR ~
Almacen.CodAlm = "05" OR ~
Almacen.CodAlm = "11" OR ~
Almacen.CodAlm = "15" OR ~
Almacen.CodAlm = "17" OR ~
Almacen.CodAlm = "35A" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 Almacen


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}
&Scoped-define QUERY-STRING-F-Main FOR EACH ImCOCmp SHARE-LOCK, ~
      EACH Almmmatg WHERE TRUE /* Join to ImCOCmp incomplete */ SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH ImCOCmp SHARE-LOCK, ~
      EACH Almmmatg WHERE TRUE /* Join to ImCOCmp incomplete */ SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main ImCOCmp Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main ImCOCmp
&Scoped-define SECOND-TABLE-IN-QUERY-F-Main Almmmatg


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-68 RECT-67 RECT-66 RECT-71 RECT-69 ~
RECT-70 RECT-72 FILL-IN-CodFam F-CodMat R-Tipo FILL-IN-SubFam F-marca1 ~
F-Prov COMBO-BOX-TipArt COMBO-BOX-Ordenar BROWSE-1 R-Tipo2 Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodFam F-CodMat R-Tipo ~
FILL-IN-SubFam F-marca1 F-Prov COMBO-BOX-TipArt COMBO-BOX-Ordenar R-Tipo2 

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

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 13 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-Ordenar AS CHARACTER FORMAT "X(256)":U INITIAL "Código" 
     LABEL "Ordenar por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Código","Marca" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-TipArt AS CHARACTER FORMAT "X(1)" 
     LABEL "Tipo Articulo" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "A","B","C","D","E","F" 
     DROP-DOWN-LIST
     SIZE 5 BY 1.

DEFINE VARIABLE F-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-marca1 AS CHARACTER FORMAT "X(4)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE F-Prov AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 12.86 BY 2.31 NO-UNDO.

DEFINE VARIABLE R-Tipo2 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Menor o igual al stock mínimo", 1,
"Mayor al Stock mínimo", 2,
"Todos", 3
     SIZE 24 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 3.46.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22 BY 3.46.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 3.46.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 6.15.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY .96.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 6.15.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 2.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      Almacen SCROLLING.

DEFINE QUERY F-Main FOR 
      ImCOCmp, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      Almacen.CodAlm COLUMN-LABEL "<<Almacén>>" FORMAT "x(3)":U
      Almacen.Descripcion FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS SEPARATORS MULTIPLE SIZE 37 BY 3.65
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodFam AT ROW 1.58 COL 11 COLON-ALIGNED
     F-CodMat AT ROW 1.58 COL 28 COLON-ALIGNED
     R-Tipo AT ROW 2.35 COL 47 NO-LABEL
     FILL-IN-SubFam AT ROW 2.54 COL 11 COLON-ALIGNED
     F-marca1 AT ROW 2.54 COL 28 COLON-ALIGNED
     F-Prov AT ROW 3.5 COL 28 COLON-ALIGNED
     COMBO-BOX-TipArt AT ROW 3.69 COL 11 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Ordenar AT ROW 6.19 COL 52 COLON-ALIGNED
     BROWSE-1 AT ROW 6.58 COL 4
     R-Tipo2 AT ROW 7.35 COL 46 NO-LABEL
     Btn_OK AT ROW 11.96 COL 19
     Btn_Cancel AT ROW 11.96 COL 39
     "Estado" VIEW-AS TEXT
          SIZE 7.14 BY .69 AT ROW 1.58 COL 47
          FONT 1
     "Seleccione Almacén:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 5.42 COL 4
     "Nota: Debe seleccionar división." VIEW-AS TEXT
          SIZE 23 BY .77 AT ROW 10.42 COL 4
     RECT-68 AT ROW 1.38 COL 44
     RECT-67 AT ROW 1.38 COL 21
     RECT-66 AT ROW 1.38 COL 3
     RECT-71 AT ROW 5.23 COL 44
     RECT-69 AT ROW 5.23 COL 3
     RECT-70 AT ROW 5.23 COL 3
     RECT-72 AT ROW 11.58 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.72 BY 13.31
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
         TITLE              = "Campaña - Reporte de Artículos vs Stock Mínimo y Reposición"
         HEIGHT             = 13.31
         WIDTH              = 71.72
         MAX-HEIGHT         = 13.31
         MAX-WIDTH          = 71.72
         VIRTUAL-HEIGHT     = 13.31
         VIRTUAL-WIDTH      = 71.72
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 COMBO-BOX-Ordenar F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.Almacen"
     _Where[1]         = "Almacen.CodAlm = ""03"" OR 
Almacen.CodAlm = ""04"" OR
Almacen.CodAlm = ""05"" OR
Almacen.CodAlm = ""11"" OR
Almacen.CodAlm = ""15"" OR
Almacen.CodAlm = ""17"" OR
Almacen.CodAlm = ""35A"""
     _FldNameList[1]   > INTEGRAL.Almacen.CodAlm
"Almacen.CodAlm" "<<Almacén>>" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almacen.Descripcion
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "INTEGRAL.ImCOCmp,INTEGRAL.Almmmatg WHERE INTEGRAL.ImCOCmp ..."
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Campaña - Reporte de Artículos vs Stock Mínimo y Reposición */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Campaña - Reporte de Artículos vs Stock Mínimo y Reposición */
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

    DO WITH FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN DO:
            MESSAGE
                "Debe Seleccionar por lo menos un Almacén."
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.

    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Imprime.
    RUN Habilita.
    RUN Inicializa-Variables.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-marca1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-marca1 W-Win
ON LEAVE OF F-marca1 IN FRAME F-Main /* Marca */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"9999").
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


&Scoped-define BROWSE-NAME BROWSE-1
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
        R-Tipo2
        F-marca1 
        F-Prov
        F-CodMat
        R-tipo 
        FILL-IN-CodFam 
        FILL-IN-SubFam
        COMBO-BOX-Ordenar
        COMBO-BOX-TipArt.
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

    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
    DEFINE VARIABLE ind AS INTEGER NO-UNDO.

    DEFINE BUFFER b_Almmmate FOR Almmmate.

    FOR EACH Reporte:
        DELETE Reporte.
    END.

    DISPLAY WITH FRAME F-PROCESO.

    FOR EACH Almmmatg NO-LOCK WHERE
        Almmmatg.codcia = s-codcia AND
        Almmmatg.TpoArt BEGINS R-Tipo AND 
        Almmmatg.CodFam BEGINS FILL-IN-CodFam AND
        Almmmatg.SubFam BEGINS FILL-IN-SubFam AND
        Almmmatg.CodMar BEGINS F-marca1 AND
        Almmmatg.CodPr1 BEGINS F-Prov AND
        Almmmatg.CodMat BEGINS F-CodMat  AND
        Almmmatg.TipArt BEGINS COMBO-BOX-TipArt :
        DISPLAY Almmmatg.codmat @ Fi-Mensaje WITH FRAME F-PROCESO.
        DO ind = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
            lOk = {&BROWSE-NAME}:FETCH-SELECTED-ROW(ind).
            IF NOT lOk THEN NEXT.
            FIND Almmmate WHERE Almmmate.codcia = s-codcia
                AND Almmmate.codalm = Almacen.codalm
                AND Almmmate.codmat = Almmmatg.codmat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmate THEN NEXT.
           
            FIND FIRST Reporte WHERE
                Reporte.CodMat = Almmmate.CodMat NO-ERROR.
            IF NOT AVAILABLE Reporte THEN DO:

                CREATE Reporte.
                ASSIGN
                    Reporte.CodMat = Almmmate.CodMat
                    Reporte.DesMat = Almmmatg.DesMat
                    Reporte.CodPro = Almmmatg.CodPr1
                    Reporte.CanEmp = Almmmatg.CanEmp
                    Reporte.CodMar = Almmmate.CodMar
                    Reporte.DesMar = Almmmatg.DesMar
                    Reporte.UndBas = Almmmatg.UndBas
                    Reporte.TpoArt = Almmmatg.TpoArt
                    Reporte.TipArt = Almmmatg.TipArt.
                
                /* Almacén 03 */
                IF Almacen.codalm <> "03" THEN DO:
                    FIND b_Almmmate WHERE b_Almmmate.codcia = s-codcia
                        AND b_Almmmate.codalm = "03"
                        AND b_Almmmate.codmat = Almmmatg.codmat
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE b_Almmmate THEN
                        Reporte.Stk03 = b_Almmmate.StkAct - b_Almmmate.StkMin.
                END.
                /* Almacén 04 */
                IF Almacen.codalm <> "04" THEN DO:
                    FIND b_Almmmate WHERE b_Almmmate.codcia = s-codcia
                        AND b_Almmmate.codalm = "04"
                        AND b_Almmmate.codmat = Almmmatg.codmat
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE b_Almmmate THEN
                        Reporte.Stk04 = b_Almmmate.StkAct - b_Almmmate.StkMin.
                END.
                /* Almacén 05 */
                IF Almacen.codalm <> "05" THEN DO:
                    FIND b_Almmmate WHERE b_Almmmate.codcia = s-codcia
                        AND b_Almmmate.codalm = "05"
                        AND b_Almmmate.codmat = Almmmatg.codmat
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE b_Almmmate THEN
                        Reporte.Stk05 = b_Almmmate.StkAct - b_Almmmate.StkMin.
                END.
                /* Almacén 11 */
                IF Almacen.codalm <> "11" THEN DO:
                    FIND b_Almmmate WHERE b_Almmmate.codcia = s-codcia
                        AND b_Almmmate.codalm = "11"
                        AND b_Almmmate.codmat = Almmmatg.codmat
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE b_Almmmate THEN
                        Reporte.Stk11 = b_Almmmate.StkAct - b_Almmmate.StkMin.
                END.
                /* Almacén 17 */
                IF Almacen.codalm <> "17" THEN DO:
                    FIND b_Almmmate WHERE b_Almmmate.codcia = s-codcia
                        AND b_Almmmate.codalm = "17"
                        AND b_Almmmate.codmat = Almmmatg.codmat
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE b_Almmmate THEN
                        Reporte.Stk17 = b_Almmmate.StkAct - b_Almmmate.StkMin.
                END.
                /* Almacén 35A */
                IF Almacen.codalm <> "35A" THEN DO:
                    FIND b_Almmmate WHERE b_Almmmate.codcia = s-codcia
                        AND b_Almmmate.codalm = "35A"
                        AND b_Almmmate.codmat = Almmmatg.codmat
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE b_Almmmate THEN
                        Reporte.Stk35A = b_Almmmate.StkAct.
                END.
                 /* Almacén 15 */
                IF Almacen.codalm <> "15" THEN DO:
                    FIND b_Almmmate WHERE b_Almmmate.codcia = s-codcia
                        AND b_Almmmate.codalm = "15"
                        AND b_Almmmate.codmat = Almmmatg.codmat
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE b_Almmmate THEN
                        Reporte.Stk15 = b_Almmmate.StkAct.
                END.
            END.
           
            ASSIGN
                Reporte.StkAct = Reporte.StkAct + Almmmate.StkAct
                Reporte.StkMin = Reporte.StkMin + Almmmate.StkMin
                Reporte.StkMax = Reporte.StkMax + Almmmate.StkMax
                /*Reporte.StkRep = Reporte.StkRep + Almmmate.StkRep*/.
            IF Reporte.StkMax > 0 THEN DO:
                ASSIGN Reporte.StkRep = Reporte.StkMax - Reporte.StkAct .
            END.
        END.
    END.

    FOR EACH Reporte:
        CASE R-tipo2:
            WHEN 1 THEN DO:
                if not Reporte.StkAct <= Reporte.StkMin THEN DO:
                    delete reporte.
                    NEXT.
                END.
            END.    
            WHEN 2 THEN DO:
                IF Reporte.StkAct <= Reporte.StkMin THEN DO:
                    delete reporte.
                    NEXT.
                END.
            END.
         END CASE.
         IF Reporte.StkMin = 0 THEN DELETE Reporte.
    END.

    HIDE FRAME F-PROCESO.

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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY FILL-IN-CodFam F-CodMat R-Tipo FILL-IN-SubFam F-marca1 F-Prov 
          COMBO-BOX-TipArt COMBO-BOX-Ordenar R-Tipo2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-68 RECT-67 RECT-66 RECT-71 RECT-69 RECT-70 RECT-72 FILL-IN-CodFam 
         F-CodMat R-Tipo FILL-IN-SubFam F-marca1 F-Prov COMBO-BOX-TipArt 
         COMBO-BOX-Ordenar BROWSE-1 R-Tipo2 Btn_OK Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 W-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE FRAME F-REPORTE
        Reporte.DesMar       COLUMN-LABEL "Descripción!Marca"
        Reporte.CodMat       COLUMN-LABEL "Código!Material"  
        Reporte.DesMat       COLUMN-LABEL "Descripción!Material"
       /* Reporte.CodPro       COLUMN-LABEL "Proveedor" */
        Reporte.CanEmp       COLUMN-LABEL "Empaque" 
        Reporte.UndBas       COLUMN-LABEL "Und!Bas" 
        /*Reporte.TpoArt       COLUMN-LABEL "Tipo!Art" */
        Reporte.TipArt       COLUMN-LABEL "Tipo!Rot" 
        Reporte.StkAct       COLUMN-LABEL "Stock!Actual" 
        Reporte.StkMin       COLUMN-LABEL "Stock!Mínimo" 
        Reporte.StkRep       COLUMN-LABEL "Stock!Reposi"
        Reporte.StkMax       COLUMN-LABEL "Stock!Maximo"
        Reporte.Stk03
        Reporte.Stk04
        Reporte.Stk05
        Reporte.Stk11
        Reporte.Stk17
        Reporte.Stk35A
        Reporte.Stk15
        HEADER
        "REPORTE DE ARTICULOS VS STOCK MÍNIMO Y REPOSICIÓN" AT 50 SKIP(2)
        WITH STREAM-IO NO-BOX DOWN WIDTH 320.
 
    FOR EACH Reporte NO-LOCK
        BREAK BY Reporte.CodMar:
        DISPLAY STREAM report
            Reporte.DesMar 
            Reporte.CodMat 
            Reporte.DesMat FORMAT "X(15)" 
            /*Reporte.CodPro */
            Reporte.CanEmp
            Reporte.UndBas 
            /*Reporte.TpoArt*/
            Reporte.TipArt
            Reporte.StkAct 
            Reporte.StkMin
            Reporte.StkRep
            Reporte.StkMax
            Reporte.Stk03  WHEN Reporte.Stk03  <> 0
            Reporte.Stk04  WHEN Reporte.Stk04  <> 0
            Reporte.Stk05  WHEN Reporte.Stk05  <> 0
            Reporte.Stk11  WHEN Reporte.Stk11  <> 0
            Reporte.Stk17  WHEN Reporte.Stk17  <> 0
            Reporte.Stk35A WHEN Reporte.Stk35A <> 0
            Reporte.Stk15  WHEN Reporte.Stk15  <> 0
            WITH FRAME F-REPORTE.
        DISPLAY
            Reporte.Codmat @ FI-MENSAJE LABEL " Artículo"
            WITH FRAME F-PROCESO.
    END.
    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Sin el almacen 83 ni 83b y costo unitario
------------------------------------------------------------------------------*/
 
    DEFINE FRAME F-REPORTE
        Reporte.CodMat       COLUMN-LABEL "Código!Material"  
        Reporte.DesMat       COLUMN-LABEL "Descripción!Material"  
        Reporte.DesMar       COLUMN-LABEL "Descripción!Marca"
        /*Reporte.CodPro       COLUMN-LABEL "Proveedor" */
        Reporte.CanEmp       COLUMN-LABEL "Empaque"
        Reporte.UndBas       COLUMN-LABEL "Und!Bas" 
        /*Reporte.TpoArt       COLUMN-LABEL "Tipo!Art" */
        Reporte.TipArt       COLUMN-LABEL "Tipo!Rot" 
        Reporte.StkAct       COLUMN-LABEL "Stock!Actual" 
        Reporte.StkMin       COLUMN-LABEL "Stock!Mínimo" 
        Reporte.StkRep       COLUMN-LABEL "Stock!Reposi"
        Reporte.StkMax       COLUMN-LABEL "Stock!Maximo"
        Reporte.Stk03
        Reporte.Stk04
        Reporte.Stk05
        Reporte.Stk11
        Reporte.Stk17
        Reporte.Stk35A
        Reporte.Stk15
        HEADER
        "REPORTE DE ARTICULOS VS STOCK MÍNIMO Y REPOSICIÓN" AT 50 SKIP(2)
        WITH STREAM-IO NO-BOX DOWN WIDTH 320.
 
    FOR EACH Reporte BREAK BY Reporte.CodMat:
        DISPLAY STREAM report
            Reporte.CodMat  WHEN FIRST-OF (Reporte.CodMat) 
            Reporte.DesMat  WHEN FIRST-OF (Reporte.CodMat)
            Reporte.DesMar  WHEN FIRST-OF (Reporte.CodMat)
           /* Reporte.CodPro*/
            Reporte.CanEmp  WHEN FIRST-OF (Reporte.CodMat)
            Reporte.UndBas  WHEN FIRST-OF (Reporte.CodMat)
            /*Reporte.TpoArt  WHEN FIRST-OF (Reporte.CodMat)*/
            Reporte.TipArt  WHEN FIRST-OF (Reporte.CodMat)
            Reporte.StkAct  WHEN FIRST-OF (Reporte.CodMat)
            Reporte.StkMin  WHEN FIRST-OF (Reporte.CodMat)
            Reporte.StkRep  WHEN FIRST-OF (Reporte.CodMat)
            Reporte.StkMax  WHEN FIRST-OF (Reporte.CodMat)
            Reporte.Stk03  WHEN Reporte.Stk03  <> 0 AND FIRST-OF (Reporte.CodMat)
            Reporte.Stk04  WHEN Reporte.Stk04  <> 0 AND FIRST-OF (Reporte.CodMat)
            Reporte.Stk05  WHEN Reporte.Stk05  <> 0 AND FIRST-OF (Reporte.CodMat)
            Reporte.Stk11  WHEN Reporte.Stk11  <> 0 AND FIRST-OF (Reporte.CodMat)
            Reporte.Stk17  WHEN Reporte.Stk17  <> 0 AND FIRST-OF (Reporte.CodMat)
            Reporte.Stk35A WHEN Reporte.Stk35A <> 0 AND FIRST-OF (Reporte.CodMat)
            Reporte.Stk15  WHEN Reporte.Stk15  <> 0 AND FIRST-OF (Reporte.CodMat)
            WITH FRAME F-REPORTE. 
        DISPLAY
            Reporte.Codmat @ FI-MENSAJE LABEL " Artículo"
            WITH FRAME F-PROCESO.
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
    ENABLE ALL.
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

    RUN Carga-Temporal.  
    IF not Can-find (First Reporte) then do:
        message "No hay registros a imprimir" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
          
    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
    DO c-Copias = 1 TO s-nro-copias:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file).
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn2}.
        CASE COMBO-BOX-Ordenar:
            WHEN "Código" then
                RUN Formato2.
            WHEN "Marca" then 
                RUN Formato1.
        end case.
/*         CASE COMBO-BOX-TipArt: */
/*             WHEN "A" then      */
/*                 RUN Formato2.  */
/*             WHEN "B" then      */
/*                 RUN Formato1.  */
/*             WHEN "C" then      */
/*                 RUN Formato1.  */
/*         end case.              */
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
  ASSIGN 
         R-Tipo
         F-marca1.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ImCOCmp"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almacen"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

