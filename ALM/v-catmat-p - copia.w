&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-matg FOR Almmmatg.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEFINE SHARED VAR S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE BUFFER MATG FOR Almtmatg.
DEFINE VAR C-DESMAT LIKE Almtmatg.DesMat NO-UNDO.
DEFINE VAR C-NUEVO  AS CHAR NO-UNDO.
DEFINE SHARED VAR S-NROSER AS INTEGER.

DEF VAR x-Acceso AS LOG INIT YES NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES almtmatg
&Scoped-define FIRST-EXTERNAL-TABLE almtmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR almtmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS almtmatg.DesMat almtmatg.Licencia[1] ~
almtmatg.CodMar almtmatg.Chr__02 almtmatg.codfam almtmatg.TpoPro ~
almtmatg.subfam almtmatg.Chr__03 almtmatg.AftIgv almtmatg.CodSSFam ~
almtmatg.PorIsc almtmatg.AftIsc almtmatg.Detalle almtmatg.TpoMrg ~
almtmatg.CodBrr almtmatg.CodAnt almtmatg.UndA almtmatg.UndB almtmatg.UndC ~
almtmatg.UndBas almtmatg.CanEmp almtmatg.UndCmp almtmatg.Pesmat ~
almtmatg.UndAlt[1] almtmatg.Dec__03 almtmatg.CodPr1 almtmatg.almacenes ~
almtmatg.usuario 
&Scoped-define ENABLED-TABLES almtmatg
&Scoped-define FIRST-ENABLED-TABLE almtmatg
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-7 RECT-4 RECT-6 RECT-12 
&Scoped-Define DISPLAYED-FIELDS almtmatg.codmat almtmatg.DesMat ~
almtmatg.DesMar almtmatg.Licencia[1] almtmatg.TipArt almtmatg.CodMar ~
almtmatg.Chr__02 almtmatg.codfam almtmatg.TpoPro almtmatg.subfam ~
almtmatg.Chr__03 almtmatg.AftIgv almtmatg.CodSSFam almtmatg.PorIsc ~
almtmatg.AftIsc almtmatg.Detalle almtmatg.TpoMrg almtmatg.CodBrr ~
almtmatg.CodAnt almtmatg.UndA almtmatg.UndB almtmatg.UndC almtmatg.UndBas ~
almtmatg.CanEmp almtmatg.Chr__01 almtmatg.UndCmp almtmatg.Pesmat ~
almtmatg.UndAlt[1] almtmatg.UndStk almtmatg.Dec__03 almtmatg.CodPr1 ~
almtmatg.CodPr2 almtmatg.almacenes almtmatg.usuario almtmatg.FchAct 
&Scoped-define DISPLAYED-TABLES almtmatg
&Scoped-define FIRST-DISPLAYED-TABLE almtmatg
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DesFam F-DesSub F-DesSubSub ~
x-DesMat-2 FILL-IN-NomPro1 FILL-IN-NomPro2 f-Estado 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSubSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .69 NO-UNDO.

DEFINE VARIABLE f-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .69 NO-UNDO.

DEFINE VARIABLE x-DesMat-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 10.29 BY 1.27.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 6.35.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 3.58.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 56.72 BY 3.54.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 8.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     almtmatg.codmat AT ROW 1.15 COL 8.29 COLON-ALIGNED
          LABEL "Correlativo" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .69
          BGCOLOR 15 FONT 0
     almtmatg.DesMat AT ROW 1.19 COL 18.29 COLON-ALIGNED NO-LABEL FORMAT "X(42)"
          VIEW-AS FILL-IN 
          SIZE 45.72 BY .69
     almtmatg.DesMar AT ROW 2.15 COL 15.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 27 BY .69
          FONT 0
     almtmatg.Licencia[1] AT ROW 2.15 COL 60.29 COLON-ALIGNED
          LABEL "Licencia" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .69
          BGCOLOR 15 
     almtmatg.TipArt AT ROW 2.15 COL 73 COLON-ALIGNED
          LABEL "Rotacion"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .65
          BGCOLOR 15 
     almtmatg.CodMar AT ROW 2.19 COL 8.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     FILL-IN-DesFam AT ROW 3.08 COL 15.14 COLON-ALIGNED NO-LABEL
     almtmatg.Chr__02 AT ROW 3.08 COL 52.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Propio", "P":U,
"Tercero", "T":U
          SIZE 9 BY 1.12
     almtmatg.codfam AT ROW 3.12 COL 8.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     almtmatg.TpoPro AT ROW 3.15 COL 63.43 COLON-ALIGNED NO-LABEL FORMAT "X(10)"
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "Nacional","Importado" 
          DROP-DOWN-LIST
          SIZE 11 BY 1
     almtmatg.subfam AT ROW 3.96 COL 8.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     F-DesSub AT ROW 3.96 COL 15.14 COLON-ALIGNED NO-LABEL
     almtmatg.Chr__03 AT ROW 4.08 COL 67 COLON-ALIGNED
          LABEL "IP" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     almtmatg.AftIgv AT ROW 4.38 COL 52.57
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 11.72 BY .69
     almtmatg.CodSSFam AT ROW 4.85 COL 8.29 COLON-ALIGNED WIDGET-ID 18
          LABEL "Sub-subfam"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     F-DesSubSub AT ROW 4.85 COL 15.14 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     almtmatg.PorIsc AT ROW 4.92 COL 64.14 COLON-ALIGNED
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .69
     almtmatg.AftIsc AT ROW 5 COL 52.57
          LABEL "Afecto a ISC"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .69
     almtmatg.Detalle AT ROW 5.62 COL 10.57 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 34.72 BY 1.92
     almtmatg.TpoMrg AT ROW 5.85 COL 66 NO-LABEL WIDGET-ID 8
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ambos", "",
"Mayoristas", "1":U,
"Minoristas", "2":U
          SIZE 10 BY 1.62
          BGCOLOR 15 FGCOLOR 0 
     almtmatg.CodBrr AT ROW 7.73 COL 15 COLON-ALIGNED
          LABEL "Codigo de Barras" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .69
          BGCOLOR 15 FONT 0
     almtmatg.CodAnt AT ROW 8.54 COL 15 COLON-ALIGNED WIDGET-ID 2
          LABEL "Codigo Relacionado"
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.43 BY 18.42
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     x-DesMat-2 AT ROW 8.54 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     almtmatg.UndA AT ROW 9.65 COL 36.72 COLON-ALIGNED
          LABEL "A" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .65
          BGCOLOR 15 
     almtmatg.UndB AT ROW 9.65 COL 50.14 COLON-ALIGNED
          LABEL "B" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .65
          BGCOLOR 15 
     almtmatg.UndC AT ROW 9.65 COL 63.14 COLON-ALIGNED
          LABEL "C" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .65
          BGCOLOR 15 
     almtmatg.UndBas AT ROW 10.23 COL 11 COLON-ALIGNED FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .65
          BGCOLOR 15 
     almtmatg.CanEmp AT ROW 10.46 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
          BGCOLOR 15 
     almtmatg.Chr__01 AT ROW 10.54 COL 37.29 COLON-ALIGNED
          LABEL "" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .65
          BGCOLOR 15 
     almtmatg.UndCmp AT ROW 10.92 COL 11 COLON-ALIGNED
          LABEL "U.M. Compra" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .65
          BGCOLOR 15 
     almtmatg.Pesmat AT ROW 11.12 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
     almtmatg.UndAlt[1] AT ROW 11.31 COL 37.29 COLON-ALIGNED NO-LABEL FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
     almtmatg.UndStk AT ROW 11.62 COL 11 COLON-ALIGNED
          LABEL "U.M. Stock" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .65
          BGCOLOR 15 
     almtmatg.Dec__03 AT ROW 11.77 COL 70 COLON-ALIGNED
          LABEL "Minimo de Venta" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
          BGCOLOR 15 FGCOLOR 12 
     almtmatg.CodPr1 AT ROW 13.08 COL 10.57 COLON-ALIGNED
          LABEL "Proveedor A"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
          BGCOLOR 15 
     FILL-IN-NomPro1 AT ROW 13.08 COL 21.57 COLON-ALIGNED NO-LABEL
     almtmatg.CodPr2 AT ROW 13.85 COL 10.57 COLON-ALIGNED
          LABEL "Proveedor B"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
          BGCOLOR 15 
     FILL-IN-NomPro2 AT ROW 13.85 COL 21.57 COLON-ALIGNED NO-LABEL
     almtmatg.almacenes AT ROW 14.62 COL 12.57 NO-LABEL
          VIEW-AS EDITOR
          SIZE 65 BY 3.31
          BGCOLOR 15 
     almtmatg.usuario AT ROW 18.12 COL 11 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
          BGCOLOR 15 
     almtmatg.FchAct AT ROW 18.12 COL 38 COLON-ALIGNED
          LABEL "Ultima Modificacion" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .81
          BGCOLOR 15 
     f-Estado AT ROW 18.12 COL 57 COLON-ALIGNED
     "Oficina" VIEW-AS TEXT
          SIZE 10.57 BY .69 AT ROW 10.58 COL 26.57
          FONT 1
     "Unidades Logística" VIEW-AS TEXT
          SIZE 18 BY .69 AT ROW 9.46 COL 1.86
          FGCOLOR 4 FONT 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.43 BY 18.42
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Almacenes:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 14.81 COL 4.57
     "Al por menor" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 11.38 COL 26.43
          FONT 1
     "Unidades Venta" VIEW-AS TEXT
          SIZE 16.14 BY .69 AT ROW 12.04 COL 35
          FGCOLOR 9 FONT 1
     "Mostrador" VIEW-AS TEXT
          SIZE 10.57 BY .69 AT ROW 9.62 COL 25.86
          FONT 1
     "Detalles" VIEW-AS TEXT
          SIZE 6.57 BY .5 AT ROW 5.77 COL 1.72
     "Solo para Almacenes:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 5.85 COL 51 WIDGET-ID 12
          BGCOLOR 15 FGCOLOR 0 
     RECT-5 AT ROW 9.35 COL 1
     RECT-7 AT ROW 1 COL 1
     RECT-4 AT ROW 12.92 COL 1
     RECT-6 AT ROW 9.38 COL 25.29
     RECT-12 AT ROW 2.96 COL 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.43 BY 18.42
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.almtmatg
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-matg B "?" ? INTEGRAL Almmmatg
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 18.42
         WIDTH              = 81.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME L-To-R                                        */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX almtmatg.AftIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX almtmatg.AftIsc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almtmatg.Chr__01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN almtmatg.Chr__03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN almtmatg.CodAnt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almtmatg.CodBrr IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN almtmatg.codmat IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN almtmatg.CodPr1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almtmatg.CodPr2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN almtmatg.CodSSFam IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almtmatg.Dec__03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN almtmatg.DesMar IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN almtmatg.DesMat IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSubSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almtmatg.FchAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almtmatg.Licencia[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN almtmatg.PorIsc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almtmatg.TipArt IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX almtmatg.TpoPro IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almtmatg.UndA IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN almtmatg.UndAlt[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN almtmatg.UndB IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN almtmatg.UndBas IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almtmatg.UndC IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN almtmatg.UndCmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN almtmatg.UndStk IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN almtmatg.usuario IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN x-DesMat-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME almtmatg.Chr__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.Chr__01 V-table-Win
ON LEAVE OF almtmatg.Chr__01 IN FRAME F-Main
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.CodAnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.CodAnt V-table-Win
ON LEAVE OF almtmatg.CodAnt IN FRAME F-Main /* Codigo Relacionado */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
      SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
      NO-ERROR.
  x-DesMat-2:SCREEN-VALUE = ''.
  FIND almmmatg WHERE almmmatg.codcia = s-codcia
    AND almmmatg.codmat = almtmatg.CodAnt:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE almmmatg THEN x-DesMat-2:SCREEN-VALUE = almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.codfam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.codfam V-table-Win
ON LEAVE OF almtmatg.codfam IN FRAME F-Main /* Familia */
DO:
   IF INPUT Almtmatg.codfam = "" THEN RETURN.
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND 
                       Almtfami.codfam = SELF:SCREEN-VALUE NO-ERROR.
   IF AVAILABLE Almtfami THEN
      DISPLAY Almtfami.desfam @ FILL-IN-DesFam WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.codfam V-table-Win
ON LEFT-MOUSE-DBLCLICK OF almtmatg.codfam IN FRAME F-Main /* Familia */
OR F8 OF almtmatg.codfam
DO:
  ASSIGN
      input-var-1 = "LP"
      input-var-2 = s-user-id
      input-var-3 = "".
  RUN lkup/c-uservslinea ("Familias").
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.CodMar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.CodMar V-table-Win
ON LEAVE OF almtmatg.CodMar IN FRAME F-Main /* Marca */
DO:
     IF SELF:SCREEN-VALUE = "" THEN RETURN.
     FIND almtabla WHERE almtabla.Tabla = "MK" AND
          almtabla.Codigo = Almtmatg.CodMar:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        DISPLAY almtabla.Nombre @ Almtmatg.DesMar WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.CodPr1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.CodPr1 V-table-Win
ON LEAVE OF almtmatg.CodPr1 IN FRAME F-Main /* Proveedor A */
DO:
  IF INPUT Almtmatg.CodPr1 = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND 
                     gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN
     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
                     gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN
         DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.
      ELSE DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.CodPr2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.CodPr2 V-table-Win
ON LEAVE OF almtmatg.CodPr2 IN FRAME F-Main /* Proveedor B */
DO:
  IF INPUT Almtmatg.CodPr2 = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND 
                     gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN
     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro2 WITH FRAME {&FRAME-NAME}.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
                     gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN
         DISPLAY gn-prov.NomPro @ FILL-IN-NomPro2 WITH FRAME {&FRAME-NAME}.
      ELSE DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.CodSSFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.CodSSFam V-table-Win
ON LEAVE OF almtmatg.CodSSFam IN FRAME F-Main /* Sub-subfam */
DO:
  FIND AlmsSFami WHERE AlmsSFami.CodCia = S-CODCIA 
      AND AlmsSFami.codfam = Almtmatg.codfam:SCREEN-VALUE 
      AND AlmsSFami.subfam = Almtmatg.subfam:SCREEN-VALUE 
      AND AlmsSFami.codssfam = Almtmatg.codssfam:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF AVAILABLE AlmsSFami THEN  DISPLAY AlmSSFami.DscSSFam @ F-DesSubSub WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.DesMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.DesMat V-table-Win
ON LEFT-MOUSE-DBLCLICK OF almtmatg.DesMat IN FRAME F-Main /* Descripción */
OR F8 OF Almtmatg.DesMat DO:
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' AND SELF:SCREEN-VALUE = '' THEN DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-catart ('Catalogo de articulos').
    IF output-var-1 <> ? THEN DO:
        FIND Almmmatg WHERE ROWID(Almmmatg) = output-var-1 NO-LOCK.
        ASSIGN
            almtmatg.AftIgv
            almtmatg.AftIsc 
            almtmatg.CanEmp:SCREEN-VALUE = STRING(almmmatg.canemp)
            almtmatg.Chr__01:SCREEN-VALUE = almmmatg.chr__01
            almtmatg.Chr__02:SCREEN-VALUE = almmmatg.chr__02
            almtmatg.Chr__03:SCREEN-VALUE = almmmatg.chr__03
            almtmatg.CodBrr:SCREEN-VALUE = almmmatg.codbrr
            almtmatg.codfam:SCREEN-VALUE = almmmatg.codfam
            almtmatg.CodMar:SCREEN-VALUE = almmmatg.codmar
            almtmatg.CodPr1:SCREEN-VALUE = almmmatg.codpr1
            almtmatg.CodPr2:SCREEN-VALUE = almmmatg.codpr2
            almtmatg.Dec__03:SCREEN-VALUE = STRING(almmmatg.dec__03)
            almtmatg.DesMar:SCREEN-VALUE = almmmatg.desmar
            almtmatg.DesMat:SCREEN-VALUE = almmmatg.desmat
            almtmatg.Detalle:SCREEN-VALUE = almmmatg.detalle
            almtmatg.Licencia[1]:SCREEN-VALUE = almmmatg.licencia[1]
            almtmatg.Pesmat:SCREEN-VALUE = STRING(almmmatg.pesmat)
            almtmatg.PorIsc:SCREEN-VALUE = STRING(almmmatg.porisc)
            almtmatg.subfam:SCREEN-VALUE = almmmatg.subfam
            almtmatg.TipArt:SCREEN-VALUE = almmmatg.tipart
            almtmatg.TpoPro:SCREEN-VALUE = almmmatg.tpopro
            almtmatg.UndA:SCREEN-VALUE = almmmatg.unda
            almtmatg.UndAlt[1]:SCREEN-VALUE = almmmatg.undalt[1]
            almtmatg.UndB:SCREEN-VALUE = almmmatg.undb
            almtmatg.UndBas:SCREEN-VALUE = almmmatg.undbas
            almtmatg.UndC:SCREEN-VALUE = almmmatg.undc
            almtmatg.UndCmp:SCREEN-VALUE = almmmatg.undcmp
            almtmatg.UndStk:SCREEN-VALUE = almmmatg.undstk.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.Licencia[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.Licencia[1] V-table-Win
ON LEAVE OF almtmatg.Licencia[1] IN FRAME F-Main /* Licencia */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
     FIND almtabla WHERE almtabla.Tabla = "LC" AND
          almtabla.Codigo = Almtmatg.Licencia[1]:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE almtabla THEN DO:
      MESSAGE "Codigo de Licencia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
     END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.subfam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.subfam V-table-Win
ON LEAVE OF almtmatg.subfam IN FRAME F-Main /* Sub-Familia */
DO:
/*   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA AND
        AlmSFami.codfam = Almtmatg.codfam:SCREEN-VALUE AND
        AlmSFami.subfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE AlmSFami THEN 
      DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END. */
    FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
        AND AlmSFami.codfam = Almtmatg.codfam:SCREEN-VALUE 
        AND AlmSFami.subfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE AlmSFami THEN  DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.UndA
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.UndA V-table-Win
ON LEAVE OF almtmatg.UndA IN FRAME F-Main /* A */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.UndAlt[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.UndAlt[1] V-table-Win
ON LEAVE OF almtmatg.UndAlt[1] IN FRAME F-Main /* UndAlt[1] */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.UndB
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.UndB V-table-Win
ON LEAVE OF almtmatg.UndB IN FRAME F-Main /* B */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.UndC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.UndC V-table-Win
ON LEAVE OF almtmatg.UndC IN FRAME F-Main /* C */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.UndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.UndCmp V-table-Win
ON LEAVE OF almtmatg.UndCmp IN FRAME F-Main /* U.M. Compra */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almtmatg.UndStk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almtmatg.UndStk V-table-Win
ON LEAVE OF almtmatg.UndStk IN FRAME F-Main /* U.M. Stock */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* CONSULTA DE UNIDADES VALIDAS */
ON F8 OF almtmatg.Chr__01,
    almtmatg.UndA, 
    almtmatg.UndAlt[1], 
    almtmatg.UndB, 
    almtmatg.UndBas, 
    almtmatg.UndC, 
    almtmatg.UndCmp, 
    almtmatg.UndStk 
    OR LEFT-MOUSE-DBLCLICK OF almtmatg.Chr__01,
    almtmatg.UndA, 
    almtmatg.UndAlt[1], 
    almtmatg.UndB, 
    almtmatg.UndBas, 
    almtmatg.UndC, 
    almtmatg.UndCmp, 
    almtmatg.UndStk 
    DO:
    input-var-1 = ''.
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-unidad-activa ('UNIDADES ACTIVAS').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

ON 'LEAVE':U OF almtmatg.Chr__01,
    almtmatg.UndA, 
    almtmatg.UndAlt[1], 
    almtmatg.UndB, 
    almtmatg.UndBas, 
    almtmatg.UndC, 
    almtmatg.UndCmp, 
    almtmatg.UndStk 
    DO:
    IF SELF:SCREEN-VALUE > '' THEN DO:
        SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
        FIND Unidades WHERE Unidades.Codunid = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Unidades OR Unidades.Libre_l01 = YES THEN DO:
           MESSAGE "Unidad no válida ..." VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
        END.
        Almtmatg.UndStk:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ACTUALIZA-MAT-x-ALM V-table-Win 
PROCEDURE ACTUALIZA-MAT-x-ALM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF C-NUEVO = 'YES' OR (C-NUEVO = 'NO' AND C-DESMAT <> Almtmatg.DesMat) THEN DO:
     FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = Almtmatg.codcia AND
         Almacen.TdoArt:
         FIND Almmmate WHERE Almmmate.CodCia = Almtmatg.codcia AND 
              Almmmate.CodAlm = Almacen.CodAlm AND 
              Almmmate.CodMat = Almtmatg.CodMat NO-ERROR.
         IF NOT AVAILABLE Almmmate THEN DO:
            CREATE Almmmate.
            ASSIGN Almmmate.CodCia = Almtmatg.codcia
                   Almmmate.CodAlm = Almacen.CodAlm
                   Almmmate.CodMat = Almtmatg.CodMat.
         END.
         ASSIGN Almmmate.DesMat = Almtmatg.DesMat
                Almmmate.FacEqu = Almtmatg.FacEqu
                Almmmate.UndVta = Almtmatg.UndStk
                Almmmate.CodMar = Almtmatg.CodMar.
         FIND FIRST almautmv WHERE 
              almautmv.CodCia = Almtmatg.codcia AND
              almautmv.CodFam = Almtmatg.codfam AND
              almautmv.CodMar = Almtmatg.codMar AND
              almautmv.Almsol = Almmmate.CodAlm NO-LOCK NO-ERROR.
         IF AVAILABLE almautmv THEN 
            ASSIGN Almmmate.AlmDes = almautmv.Almdes
                   Almmmate.CodUbi = almautmv.CodUbi.
         RELEASE Almmmate.
     END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "almtmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "almtmatg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE barras V-table-Win 
PROCEDURE barras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER x_tipo AS INTEGER. 
DEFINE VAR X-BARRA AS CHAR FORMAT "X(15)".
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).


IF LOOKUP("Barras", s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " "Barras"" no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

s-port-name = ENTRY(LOOKUP("Barras", s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").

X-BARRA = STRING(SUBSTRING(Almtmatg.CodBrr,1,15),"x(15)").

OUTPUT TO PRINTER VALUE(s-port-name) .

put control chr(27) + '^XA^LH000,012'.  /*&& Inicio de formato*/
put control chr(27) + '^FO155,00'.  /*&& Coordenadas de origen campo1  DESPRO1*/
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + Almtmatg.desmat.
put control chr(27) + '^FS'.  /*&& Fin de Campo1*/
put control chr(27) + '^FO130,00'.  /*&& Coordenadas de origen campo2  DESPRO2*/
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + Almtmatg.desmar + " " + Almtmatg.undbas.
put control chr(27) + '^FS'.  /*&& Fin de Campo2*/
put control chr(27) + '^FO55,30'.  /*&& Coordenadas de origen barras  CODPRO*/
if x_tipo = 1 then 
 do:
 put control chr(27) + '^BCR,80'.  
 put control chr(27) + '^FD' + codmat.
 end.
else
 do:
 put control chr(27) + '^BER,80'.  
 put control chr(27) + '^FD' + X-BARRA .
 end.
put control chr(27) + '^FS'. 
 
put control chr(27) + '^LH210,012'.  /*&& Inicio de formato*/
put control chr(27) + '^FO155,00'.  /*&& Coordenadas de origen campo1  DESPRO1*/
put control chr(27) + '^A0R,25,15'.
put control chr(27) + '^FD' + desmat.
put control chr(27) + '^FS'.  
put control chr(27) + '^FO130,00'.  
put control chr(27) + '^A0R,25,15'.
put control chr(27) + '^FD' + desmar.
put control chr(27) + '^FS'.  
put control chr(27) + '^FO55,30'.  
if x_tipo = 1 then 
 do:
 put control chr(27) + '^BCR,80'.  
 put control chr(27) + '^FD' + codmat.
 end.
else
 do:
 put control chr(27) + '^BER,80'.  
 put control chr(27) + '^FD' + TRIM(codbrr).
 end.
put control chr(27) + '^FS'. 

put control chr(27) + '^LH420,12'. 
put control chr(27) + '^FO155,00'. 
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + desmat.
put control chr(27) + '^FS'.
put control chr(27) + '^FO130,00'. 
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + desmar.
put control chr(27) + '^FS'.
put control chr(27) + '^FO55,30'.
put control chr(27) + '^BY2'.  
if x_tipo = 1 then 
 do:
 put control chr(27) + '^BCR,80'.  
 put control chr(27) + '^FD' + codmat.
 end.
else
 do:
 put control chr(27) + '^BER,80'.  
 put control chr(27) + '^FD' + TRIM(codbrr).
 end.
put control chr(27) + '^FS'.  


put control chr(27) + '^LH630,012'.  
put control chr(27) + '^FO155,00'.  
put control chr(27) + '^A0R,25,15'.
put control chr(27) + '^FD' + desmat.
put control chr(27) + '^FS'.  
put control chr(27) + '^FO130,00'.  
put control chr(27) + '^A0R,25,15'.
put control chr(27) + '^FD' + desmar.
put control chr(27) + '^FS'.  
put control chr(27) + '^FO55,30'.  
put control chr(27) + '^BY2'.  
if x_tipo = 1 then
 do:
  put control chr(27) + '^BCR,80'.  
  put control chr(27) + '^FD' + codmat.
 end.
else
 do:
  put control chr(27) + '^BER,80'.  
  put control chr(27) + '^FD' + TRIM(codbrr).
 end.
put control chr(27)  + '^FS'.  




put control chr(27) + '^PQ' + string(S-NROSER,"x(99)"). /*&&Cantidad a imprimir*/
put control chr(27) + '^PR' + '2'.   /*&&Velocidad de impresion Pulg/seg*/
put control chr(27) + '^XZ'.  /*&& Fin de formato*/

output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
   DO WITH FRAME {&FRAME-NAME}:
       DISPLAY "" @ Almtmatg.TipArt.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-OrdSub AS INTEGER NO-UNDO.
  DEFINE VAR x-OrdMat AS INTEGER NO-UNDO.
  DEFINE VAR x-NroCor AS INTEGER NO-UNDO.
  DEFINE VAR C-ALM    AS CHAR NO-UNDO.
  DEFINE VAR x-TpoArt AS CHAR INIT '' NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  IF C-NUEVO = "YES" THEN DO WITH FRAME {&FRAME-NAME}:
      FIND LAST MATG WHERE MATG.CodCia = S-CODCIA NO-LOCK NO-ERROR.
      IF AVAILABLE MATG THEN x-NroCor = INTEGER(MATG.codmat) + 1.
      ELSE x-NroCor = 1.
  END.
  ELSE x-TpoArt = Almtmatg.TpoArt.      /* MODIFICAR */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF C-NUEVO = "YES" THEN DO:
      ASSIGN 
          Almtmatg.CodCia  = S-CODCIA
          Almtmatg.FchIng  = TODAY
          Almtmatg.codmat  = STRING(x-NroCor,"999999")
          Almtmatg.orden   = x-ordmat
          Almtmatg.ordlis  = x-ordmat.
      x-TpoArt = Almtmatg.TpoArt.         /* CREAR */

      /*Cat Contable Familia*/
      FIND AlmTFami WHERE AlmTFami.CodCia = s-codcia
          AND AlmTFami.CodFam = Almtmatg.CodFam NO-LOCK NO-ERROR.
      IF AVAIL AlmTFami THEN Almtmatg.catconta[1] = AlmTFami.Libre_c01.      
  END.
  /* PARCHE */
  ASSIGN
      Almtmatg.UndStk = Almtmatg.UndBas
      Almtmatg.CHR__01 = Almtmatg.UndBas.

  IF almtmatg.Descripcion-Larga = '' THEN almtmatg.Descripcion-Larga = almtmatg.DesMat.
  
  ASSIGN /*Almtmatg.UndCmp = Almtmatg.UndStk*/
         Almtmatg.FchAct = TODAY
         Almtmatg.usuario = S-USER-ID.
  FIND Almtconv WHERE Almtconv.CodUnid = Almtmatg.UndBas 
                 AND  Almtconv.Codalter = Almtmatg.UndStk 
                NO-LOCK NO-ERROR.
  IF AVAILABLE Almtconv THEN Almtmatg.FacEqu = Almtconv.Equival.
  
  FIND almtabla WHERE almtabla.Tabla = "MK" 
                 AND  almtabla.Codigo = Almtmatg.CodMar 
                NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla THEN ASSIGN Almtmatg.DesMar = almtabla.Nombre.
  
  /* Actualizamos la lista de Almacenes */ 
  C-ALM = TRIM(Almtmatg.almacenes).
  FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = Almtmatg.codcia 
                            AND  Almacen.TdoArt:
      /* Ic - 26May2015 - Parche 11M es Almacen excepcional 
            No debe asignarse a los articulos
      */
      IF TRIM(Almacen.CodAlm) <> '11M' THEN DO:
          IF C-ALM = "" THEN C-ALM = TRIM(Almacen.CodAlm).
          IF LOOKUP(TRIM(Almacen.CodAlm),C-ALM) = 0 THEN C-ALM = C-ALM + "," + TRIM(Almacen.CodAlm).
      END.
  END.
  ASSIGN Almtmatg.almacenes = C-ALM
         Almtmatg.TipArt = Almtmatg.TipArt:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  IF c-Nuevo = 'YES' THEN DO:
      /* RHC 26.11.09 Registro para estadisticas */
      CREATE VtaPMatg.
      BUFFER-COPY AlmTMatg TO VtaPMatg
          ASSIGN
            vtapmatg.Periodo = YEAR(TODAY)
            VtaPMatg.CodMat = 'T' + AlmTMatg.CodMat
            VTaPMatg.Tipo = 'E'.
      RELEASE VtaPMatg.
  END.
  /* Verificamos ATRIBUTOS */
  FIND Vtactabla WHERE VtaCTabla.CodCia = Almtmatg.codcia 
      AND VtaCTabla.Tabla = 'PATTR'
      AND VtaCTabla.Llave = AlmSSFami.CodPlantilla
      NO-LOCK NO-ERROR.
  IF AVAILABLE Vtactabla AND Vtactabla.Libre_L01 = YES THEN Almtmatg.DesMat = "** DEBE DEFINIR LOS ATRIBUTOS **".
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        Almtmatg.TipArt:SCREEN-VALUE = ''
        Almtmatg.CodMat:SCREEN-VALUE = ''.
  END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF LOOKUP(Almtmatg.FlgAut, 'A,R') > 0 THEN DO:
    MESSAGE 'Aprobado o Rechazado' SKIP
        'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* RHC 26.11.09 Registro para estadisticas */
  FIND Vtapmatg WHERE Vtapmatg.codcia = Almtmatg.codcia
      AND Vtapmatg.codmat = "T" + Almtmatg.codmat
      EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE Vtapmatg THEN DELETE Vtapmatg.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almtmatg THEN DO WITH FRAME {&FRAME-NAME}:
     FIND Almtfami OF Almtmatg NO-LOCK NO-ERROR.
     IF AVAILABLE Almtfami THEN FILL-IN-DesFam :SCREEN-VALUE = Almtfami.desfam.
     FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                    AND  AlmSFami.codfam = Almtmatg.codfam 
                    AND  AlmSFami.subfam = Almtmatg.subfam 
                   NO-LOCK NO-ERROR.
     IF AVAILABLE AlmSFami THEN 
        DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
     FIND AlmSSFami WHERE AlmSSFami.CodCia = S-CODCIA 
         AND AlmSSFami.codfam = Almtmatg.codfam 
         AND AlmSSFami.subfam = Almtmatg.subfam 
         AND AlmSSFami.CodSSFam = Almtmatg.codssfam
         NO-LOCK NO-ERROR.
     IF AVAILABLE AlmSSFami THEN 
        DISPLAY AlmSSFami.DscSSFam @ F-DesSubSub WITH FRAME {&FRAME-NAME}.
     FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                   AND  gn-prov.CodPro = Almtmatg.CodPr1 
                  NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-prov THEN
        FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                      AND  gn-prov.CodPro = Almtmatg.CodPr1 
                     NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
          DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.
     FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                   AND  gn-prov.CodPro = Almtmatg.CodPr2 
                  NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-prov THEN
        FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                      AND  gn-prov.CodPro = Almtmatg.CodPr2 
                     NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
          DISPLAY gn-prov.NomPro @ FILL-IN-NomPro2 WITH FRAME {&FRAME-NAME}.
    CASE Almtmatg.FlgAut:
        WHEN 'P' THEN f-Estado:SCREEN-VALUE = 'PENDIENTE'.
        WHEN 'A' THEN f-Estado:SCREEN-VALUE = 'APROBADO'.
        WHEN 'R' THEN f-Estado:SCREEN-VALUE = 'RECHAZADO'.
    END CASE.
    x-DesMat-2:SCREEN-VALUE = ''.
    FIND almmmatg WHERE almmmatg.codcia = s-codcia
      AND almmmatg.codmat = almtmatg.CodAnt
      NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN x-DesMat-2:SCREEN-VALUE = almmmatg.desmat.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' AND x-Acceso = NO
  THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        Almtmatg.UndBas:SENSITIVE = NO
        Almtmatg.UndCmp:SENSITIVE = NO
        Almtmatg.UndStk:SENSITIVE = NO
        Almtmatg.CodBrr:SENSITIVE = NO.
/*        Almtmatg.DesMat:SENSITIVE = NO
 *         Almtmatg.DesMat:SENSITIVE = NO.
 *     IF Almtmatg.Chr__01 <> '' THEN Almtmatg.Chr__01:SENSITIVE = NO.
 *     IF Almtmatg.UndA <> '' THEN Almtmatg.UndA:SENSITIVE = NO.
 *     IF Almtmatg.UndB <> '' THEN Almtmatg.UndB:SENSITIVE = NO.
 *     IF Almtmatg.UndC <> '' THEN Almtmatg.UndC:SENSITIVE = NO.*/
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

/*  RUN ALM\D-CATMAT.R. */
    RUN ALM\D-CATART.R.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  RUN get-attribute('ADM-NEW-RECORD').
  ASSIGN 
    C-NUEVO = RETURN-VALUE
    C-DESMAT = "".
  IF RETURN-VALUE = 'NO' THEN ASSIGN C-DESMAT = Almtmatg.DesMat.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*  RUN ACTUALIZA-MAT-x-ALM.  */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  FIND Vtactabla WHERE VtaCTabla.CodCia = Almtmatg.codcia 
      AND VtaCTabla.Tabla = 'PATTR'
      AND VtaCTabla.Llave = AlmSSFami.CodPlantilla
      NO-LOCK NO-ERROR.
  IF AVAILABLE Vtactabla AND Vtactabla.Libre_L01 = YES THEN RUN Procesa-handle IN lh_handle ('Pagina-2').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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
    DO WITH FRAME {&FRAME-NAME}:
        CASE HANDLE-CAMPO:name:
            WHEN "subfam" THEN ASSIGN input-var-1 = Almtmatg.codfam:SCREEN-VALUE.
            WHEN "codssfam" THEN ASSIGN input-var-1 = Almtmatg.codfam:SCREEN-VALUE
                input-var-2 = Almtmatg.subfam:SCREEN-VALUE.
            WHEN "UndStk" THEN ASSIGN input-var-1 = Almtmatg.UndBas:SCREEN-VALUE.
            WHEN "CodMar" THEN ASSIGN input-var-1 = "MK".
            WHEN "Licencia" THEN ASSIGN input-var-1 = "LC".
            WHEN "Chr__03" THEN ASSIGN input-var-1 = "IP".
            /*
              ASSIGN
                    input-var-1 = ""
                    input-var-2 = ""
                    input-var-3 = "".
             */      
        END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "almtmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND
        Almtfami.codfam = Almtmatg.codfam:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almtfami THEN DO:
      MESSAGE "Codigo de Familia no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.CodFam.
      RETURN "ADM-ERROR".   
   END.
   FIND Vtatabla WHERE Vtatabla.codcia = s-codcia
       AND Vtatabla.tabla = "LP"
       AND Vtatabla.llave_c1 = s-user-id
       AND Vtatabla.llave_c2 = Almtmatg.codfam:SCREEN-VALUE
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE VtaTabla THEN DO:
      MESSAGE "Codigo de Familia NO configurada para este usuario" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.CodFam.
      RETURN "ADM-ERROR".   
   END.

   FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA AND
        Almsfami.codfam = Almtmatg.codfam:SCREEN-VALUE AND
        AlmSFami.subfam = Almtmatg.subfam:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmSFami THEN DO:
      MESSAGE "Codigo de Familia no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.SubFam.
      RETURN "ADM-ERROR".   
   END.

   FIND Almssfami WHERE Almssfami.CodCia = S-CODCIA 
       AND Almssfami.codfam = Almtmatg.codfam:SCREEN-VALUE 
       AND AlmSsFami.subfam = Almtmatg.subfam:SCREEN-VALUE 
       AND AlmSSFami.CodSSFam = almtmatg.CodSSFam:SCREEN-VALUE 
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmSSFami THEN DO:
      MESSAGE "Codigo de Sub Sub Familia no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO almtmatg.CodSSFam.
      RETURN "ADM-ERROR".   
   END.

   IF Almtmatg.DesMat:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Descripcion de articulo en blanco ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.DesMat.
      RETURN "ADM-ERROR".   
   END.

   IF Almtmatg.CodPr1:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Proveedor en blanco ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.CodPr1.
      RETURN "ADM-ERROR".   
   END.
   FIND Unidades WHERE Unidades.Codunid = Almtmatg.UndBas:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Unidades THEN DO:
      MESSAGE "Unidad Base no registrada ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.UndBas.
      RETURN "ADM-ERROR".   
   END.
/*    FIND Almtconv WHERE Almtconv.CodUnid = Almtmatg.UndBas:SCREEN-VALUE AND           */
/*         Almtconv.Codalter = Almtmatg.UndStk:SCREEN-VALUE NO-LOCK NO-ERROR.           */
/*    IF NOT AVAILABLE Almtconv THEN DO:                                                */
/*       MESSAGE "Equivalencia Unidad Stock no registrada ..." VIEW-AS ALERT-BOX ERROR. */
/*       APPLY "ENTRY" TO Almtmatg.UndStk.                                              */
/*       RETURN "ADM-ERROR".                                                            */
/*    END.                                                                              */
   IF almtmatg.codfam:SCREEN-VALUE = '010' THEN DO:
       FIND almtabla WHERE almtabla.Tabla = "LC" 
           AND almtabla.Codigo = Almtmatg.Licencia[1]:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE almtabla THEN DO:
           MESSAGE "Codigo de Licencia no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN "ADM-ERROR".
       END.
   END.
   IF almtmatg.CodAnt:SCREEN-VALUE <> '' THEN DO:
       FIND almmmatg WHERE almmmatg.codcia = s-codcia
           AND almmmatg.codmat = almtmatg.CodAnt:SCREEN-VALUE
           NO-LOCK NO-ERROR.
       IF NOT AVAILABLE almmmatg THEN DO:
           MESSAGE 'El código relacionado NO existe' VIEW-AS ALERT-BOX ERROR.
           APPLY 'entry':U TO almtmatg.CodAnt.
           RETURN "ADM-ERROR".
       END.
   END.
   IF almtmatg.CodPr1:SCREEN-VALUE <> ''  THEN DO:
       FIND gn-prov WHERE gn-prov.CodCia = pv-CODCIA 
           AND gn-prov.CodPro = almtmatg.CodPr1:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
           APPLY 'entry' TO almtmatg.CodPr1.
           RETURN 'ADM-ERROR'.
       END.
   END.
   /* RHC 21/08/2015 Validación de unidades */
   FIND Unidades WHERE Unidades.Codunid = Almtmatg.UndCmp:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF Almtmatg.UndCmp:SCREEN-VALUE <> '' AND NOT AVAILABLE Unidades THEN DO:
      MESSAGE "Unidad Compra no registrada ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.UndCmp.
      RETURN "ADM-ERROR".   
   END.
   FIND Unidades WHERE Unidades.Codunid = Almtmatg.UndA:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF Almtmatg.UndA:SCREEN-VALUE <> '' AND NOT AVAILABLE Unidades THEN DO:
      MESSAGE "Unidad A no registrada ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.UndA.
      RETURN "ADM-ERROR".   
   END.
   FIND Unidades WHERE Unidades.Codunid = Almtmatg.UndB:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF Almtmatg.UndB:SCREEN-VALUE <> '' AND NOT AVAILABLE Unidades THEN DO:
      MESSAGE "Unidad B no registrada ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.UndB.
      RETURN "ADM-ERROR".   
   END.
   FIND Unidades WHERE Unidades.Codunid = Almtmatg.UndC:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF Almtmatg.UndC:SCREEN-VALUE <> '' AND NOT AVAILABLE Unidades THEN DO:
      MESSAGE "Unidad C no registrada ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almtmatg.UndC.
      RETURN "ADM-ERROR".   
   END.
   IF almtmatg.UndA:SCREEN-VALUE = almtmatg.UndB:SCREEN-VALUE
       AND almtmatg.UndA:SCREEN-VALUE <> ""
       THEN DO:
       MESSAGE 'Las unidades de venta NO pueden ser iguales' VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO almtmatg.UndA.
       RETURN 'ADM-ERROR'.
   END.
   IF almtmatg.UndA:SCREEN-VALUE = almtmatg.UndC:SCREEN-VALUE
       AND almtmatg.UndA:SCREEN-VALUE <> ""
       THEN DO:
       MESSAGE 'Las unidades de venta NO pueden ser iguales' VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO almtmatg.UndA.
       RETURN 'ADM-ERROR'.
   END.
   IF almtmatg.UndB:SCREEN-VALUE = almtmatg.UndC:SCREEN-VALUE
       AND almtmatg.UndB:SCREEN-VALUE <> ""
       THEN DO:
       MESSAGE 'Las unidades de venta NO pueden ser iguales' VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO almtmatg.UndB.
       RETURN 'ADM-ERROR'.
   END.

   /* RHC 09/09/2015 Consistencia del código de barras */
   IF almtmatg.CodBrr:SCREEN-VALUE <> '' THEN DO:
       FIND FIRST b-matg WHERE b-matg.codcia = s-codcia
           AND b-matg.codbrr = almtmatg.CodBrr:SCREEN-VALUE
           NO-LOCK NO-ERROR.
       IF AVAILABLE b-matg THEN DO:
           MESSAGE 'Código de barra YA registrado en el material' b-matg.codmat
               VIEW-AS ALERT-BOX WARNING.
           APPLY 'ENTRY' TO almtmatg.CodBrr.
           RETURN 'ADM-ERROR'.
       END.
   END.

END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR RPTA AS CHAR INIT ''.

  IF Almtmatg.FlgAut = 'A' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

