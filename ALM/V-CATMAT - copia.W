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

DEFINE BUFFER MATG FOR Almmmatg.
DEFINE VAR C-DESMAT LIKE Almmmatg.DesMat NO-UNDO.
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
&Scoped-define EXTERNAL-TABLES Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almmmatg.DesMat Almmmatg.TpoArt ~
Almmmatg.CodMar Almmmatg.Chr__02 Almmmatg.TpoPro Almmmatg.codfam ~
Almmmatg.Licencia[1] Almmmatg.subfam Almmmatg.AftIgv Almmmatg.Chr__03 ~
Almmmatg.CodSSFam Almmmatg.AftIsc Almmmatg.PorIsc Almmmatg.Detalle ~
Almmmatg.FlgComercial Almmmatg.TpoMrg Almmmatg.CodBrr Almmmatg.catconta[1] ~
Almmmatg.Libre_c01 Almmmatg.CodDigesa Almmmatg.Libre_d02 Almmmatg.VtoDigesa ~
Almmmatg.Pesmat Almmmatg.UndBas Almmmatg.UndA Almmmatg.UndB Almmmatg.UndC ~
Almmmatg.Dec__03 Almmmatg.UndCmp Almmmatg.StkMin Almmmatg.CanEmp ~
Almmmatg.UndAlt[1] Almmmatg.StkRep Almmmatg.CodPr1 Almmmatg.PesoBruto ~
Almmmatg.Paquete Almmmatg.almacenes Almmmatg.StkMax Almmmatg.Libre_d03 ~
Almmmatg.PP Almmmatg.usuario 
&Scoped-define ENABLED-TABLES Almmmatg
&Scoped-define FIRST-ENABLED-TABLE Almmmatg
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-15 RECT-16 RECT-17 RECT-18 ~
RECT-19 RECT-69 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.TpoArt Almmmatg.CodMar Almmmatg.DesMar Almmmatg.Chr__02 ~
Almmmatg.TpoPro Almmmatg.codfam Almmmatg.Licencia[1] Almmmatg.subfam ~
Almmmatg.AftIgv Almmmatg.Chr__03 Almmmatg.CodSSFam Almmmatg.AftIsc ~
Almmmatg.PorIsc Almmmatg.Detalle Almmmatg.FlgComercial Almmmatg.TpoMrg ~
Almmmatg.CodBrr Almmmatg.catconta[1] Almmmatg.Libre_c01 Almmmatg.CodDigesa ~
Almmmatg.Libre_d02 Almmmatg.VtoDigesa Almmmatg.Pesmat Almmmatg.UndBas ~
Almmmatg.UndA Almmmatg.UndB Almmmatg.UndC Almmmatg.Dec__03 Almmmatg.UndCmp ~
Almmmatg.Chr__01 Almmmatg.StkMin Almmmatg.CanEmp Almmmatg.UndStk ~
Almmmatg.UndAlt[1] Almmmatg.StkRep Almmmatg.CodPr1 Almmmatg.PesoBruto ~
Almmmatg.CodPr2 Almmmatg.Paquete Almmmatg.almacenes Almmmatg.StkMax ~
Almmmatg.Libre_d03 Almmmatg.PP Almmmatg.FchAct Almmmatg.usuario ~
Almmmatg.FchIng Almmmatg.FlgPre 
&Scoped-define DISPLAYED-TABLES Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE Almmmatg
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DesFam F-DesSub F-DesSubSub ~
f-SubTipo FILL-IN-NomPro1 FILL-IN-NomPro2 FILL-IN-UsrCreacion 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fValida-excepcion V-table-Win 
FUNCTION fValida-excepcion RETURNS CHARACTER
  ( INPUT pArticulo AS CHAR, INPUT pAlmacen AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE F-DesSubSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE f-SubTipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-UsrCreacion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 105 BY 10.96.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.88.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 2.88.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 105 BY 5.38.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 105 BY 2.12.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.69.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almmmatg.codmat AT ROW 1.19 COL 11 COLON-ALIGNED
          LABEL "Artículo" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
          BGCOLOR 15 FONT 0
     Almmmatg.DesMat AT ROW 1.19 COL 21 COLON-ALIGNED NO-LABEL FORMAT "X(42)"
          VIEW-AS FILL-IN 
          SIZE 45.72 BY .81
     Almmmatg.TpoArt AT ROW 2.15 COL 13 NO-LABEL WIDGET-ID 34
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activado", "A":U,
"Desactivado", "D":U,
"Baja Rotación", "B":U,
"?", ""
          SIZE 39 BY .81
     Almmmatg.TipArt AT ROW 2.15 COL 69 COLON-ALIGNED
          LABEL "Categoría"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .81
          BGCOLOR 15 
     Almmmatg.CodMar AT ROW 3.12 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
          BGCOLOR 15 
     Almmmatg.DesMar AT ROW 3.12 COL 17 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 27 BY .81
          FONT 0
     Almmmatg.Chr__02 AT ROW 3.12 COL 46.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Propio", "P":U,
"Tercero", "T":U,
"<Ninguno>", ""
          SIZE 27.14 BY .81
     Almmmatg.TpoPro AT ROW 3.81 COL 69 COLON-ALIGNED NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "Nacional","Importado" 
          DROP-DOWN-LIST
          SIZE 11 BY 1
     Almmmatg.codfam AT ROW 3.88 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
          BGCOLOR 15 
     FILL-IN-DesFam AT ROW 3.88 COL 17 COLON-ALIGNED NO-LABEL
     Almmmatg.Licencia[1] AT ROW 3.88 COL 52 COLON-ALIGNED
          LABEL "Licencia" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .81
          BGCOLOR 15 
     Almmmatg.subfam AT ROW 4.65 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
          BGCOLOR 15 
     F-DesSub AT ROW 4.65 COL 17 COLON-ALIGNED NO-LABEL
     Almmmatg.AftIgv AT ROW 4.65 COL 54
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 11.72 BY .81
     Almmmatg.Chr__03 AT ROW 4.65 COL 69 COLON-ALIGNED
          LABEL "IP" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     Almmmatg.CodSSFam AT ROW 5.42 COL 11 COLON-ALIGNED WIDGET-ID 56
          LABEL "SubSubFam"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
          BGCOLOR 15 
     F-DesSubSub AT ROW 5.42 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     Almmmatg.AftIsc AT ROW 5.42 COL 54
          LABEL "Afecto a ISC"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .81
     Almmmatg.PorIsc AT ROW 5.42 COL 69 COLON-ALIGNED
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .81
     Almmmatg.Detalle AT ROW 6.38 COL 13 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 34.72 BY 1.92
     Almmmatg.FlgComercial AT ROW 6.38 COL 69 COLON-ALIGNED WIDGET-ID 88
          LABEL "Indicador Comercial"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "<Ninguno>","' '"
          DROP-DOWN-LIST
          SIZE 22 BY 1
     Almmmatg.TpoMrg AT ROW 7.35 COL 71 NO-LABEL WIDGET-ID 12
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ambos", "",
"Mayoristas", "1":U,
"Minoristas", "2":U
          SIZE 10 BY 1.62
          BGCOLOR 15 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.29 BY 21.46
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     Almmmatg.CodBrr AT ROW 8.54 COL 18 COLON-ALIGNED
          LABEL "Codigo de Barras" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .81
          BGCOLOR 15 FONT 0
     Almmmatg.catconta[1] AT ROW 9.35 COL 18 COLON-ALIGNED WIDGET-ID 6
          LABEL "Cat. Contable"
          VIEW-AS FILL-IN 
          SIZE 3.86 BY .81
     Almmmatg.Libre_c01 AT ROW 9.35 COL 69 COLON-ALIGNED WIDGET-ID 24
          LABEL "Subtipo" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
          BGCOLOR 15 
     f-SubTipo AT ROW 9.35 COL 75 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     Almmmatg.CodDigesa AT ROW 10.15 COL 18 COLON-ALIGNED WIDGET-ID 8
          LABEL "Cod. Digesa" FORMAT "x(30)"
          VIEW-AS FILL-IN 
          SIZE 23 BY .81
     Almmmatg.Libre_d02 AT ROW 10.15 COL 69 COLON-ALIGNED WIDGET-ID 20
          LABEL "Volumen en cm3" FORMAT ">>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.VtoDigesa AT ROW 10.96 COL 18 COLON-ALIGNED WIDGET-ID 10
          LABEL "Vcmto. Digesa"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almmmatg.Pesmat AT ROW 10.96 COL 69 COLON-ALIGNED
          LABEL "Peso por Unidad en Kg." FORMAT ">>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     Almmmatg.UndBas AT ROW 12.35 COL 12 COLON-ALIGNED FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 
     Almmmatg.UndA AT ROW 12.35 COL 37.57 COLON-ALIGNED
          LABEL "A" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .81
          BGCOLOR 15 
     Almmmatg.UndB AT ROW 12.35 COL 49 COLON-ALIGNED
          LABEL "B" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .81
          BGCOLOR 15 
     Almmmatg.UndC AT ROW 12.35 COL 60 COLON-ALIGNED
          LABEL "C" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .81
          BGCOLOR 15 
     Almmmatg.Dec__03 AT ROW 12.35 COL 94 COLON-ALIGNED
          LABEL "Mínimo Venta Mayorista" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          BGCOLOR 15 FGCOLOR 12 
     Almmmatg.UndCmp AT ROW 13.12 COL 12 COLON-ALIGNED
          LABEL "U.M. Compra" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 
     Almmmatg.Chr__01 AT ROW 13.12 COL 37.57 COLON-ALIGNED
          LABEL "" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .81
          BGCOLOR 15 
     Almmmatg.StkMin AT ROW 13.12 COL 94 COLON-ALIGNED WIDGET-ID 60
          LABEL "Mínimo Venta Minorista" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          BGCOLOR 15 FGCOLOR 12 
     Almmmatg.CanEmp AT ROW 13.15 COL 64 COLON-ALIGNED
          LABEL "Empaque Master" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          BGCOLOR 15 
     Almmmatg.UndStk AT ROW 13.88 COL 12 COLON-ALIGNED
          LABEL "U.M. Stock" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.29 BY 21.46
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     Almmmatg.UndAlt[1] AT ROW 13.88 COL 37.57 COLON-ALIGNED NO-LABEL FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .81
     Almmmatg.StkRep AT ROW 13.92 COL 64 COLON-ALIGNED WIDGET-ID 64
          LABEL "Empaque Inner" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     Almmmatg.CodPr1 AT ROW 15.04 COL 12 COLON-ALIGNED
          LABEL "Proveedor A"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 
     FILL-IN-NomPro1 AT ROW 15.04 COL 24 COLON-ALIGNED NO-LABEL
     Almmmatg.PesoBruto AT ROW 15.42 COL 93 COLON-ALIGNED WIDGET-ID 70
          LABEL "Mínimo de Ventas" FORMAT ">>>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     Almmmatg.CodPr2 AT ROW 15.81 COL 12 COLON-ALIGNED
          LABEL "Proveedor B"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
          BGCOLOR 15 
     FILL-IN-NomPro2 AT ROW 15.81 COL 24 COLON-ALIGNED NO-LABEL
     Almmmatg.Paquete AT ROW 16.38 COL 93 COLON-ALIGNED WIDGET-ID 68
          LABEL "Incremento (+)" FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     Almmmatg.almacenes AT ROW 16.77 COL 14 NO-LABEL
          VIEW-AS EDITOR
          SIZE 65 BY 3.31
          BGCOLOR 15 
     Almmmatg.StkMax AT ROW 18.12 COL 92 COLON-ALIGNED WIDGET-ID 62
          LABEL "Mínimo Venta" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          BGCOLOR 15 FGCOLOR 12 
     Almmmatg.Libre_d03 AT ROW 18.88 COL 92 COLON-ALIGNED WIDGET-ID 74
          LABEL "Empaque" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          BGCOLOR 15 FGCOLOR 12 
     Almmmatg.PP AT ROW 20.38 COL 75 WIDGET-ID 30
          LABEL "NO incluirlo compras CONTI - CISSAC"
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .81
          BGCOLOR 14 FGCOLOR 0 
     Almmmatg.FchAct AT ROW 20.42 COL 16 COLON-ALIGNED
          LABEL "Ultima Modificacion" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 15 
     Almmmatg.usuario AT ROW 20.42 COL 35 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
          BGCOLOR 15 
     Almmmatg.FchIng AT ROW 21.19 COL 16 COLON-ALIGNED WIDGET-ID 50
          LABEL "Fecha Creación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-UsrCreacion AT ROW 21.19 COL 35 COLON-ALIGNED WIDGET-ID 52
     Almmmatg.FlgPre AT ROW 21.35 COL 75 WIDGET-ID 90
          LABEL "Productos VIP"
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .77
          BGCOLOR 14 FGCOLOR 0 
     "Detalles:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 6.38 COL 7 WIDGET-ID 40
     "Mostrador" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 12.54 COL 28.43
          FONT 1
     "Solo para Almacenes:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 7.35 COL 56 WIDGET-ID 16
          BGCOLOR 15 FGCOLOR 0 
     "EXPOLIBRERIA" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 17.54 COL 82 WIDGET-ID 76
          BGCOLOR 9 FGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.29 BY 21.46
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "CHICLAYO" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 14.85 COL 82 WIDGET-ID 72
          BGCOLOR 9 FGCOLOR 15 
     "Oficina" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 13.31 COL 28.43
          FONT 1
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.35 COL 7 WIDGET-ID 38
     "Utilex" VIEW-AS TEXT
          SIZE 9.57 BY .5 AT ROW 14.08 COL 28.43
          FONT 1
     "Unidades Venta" VIEW-AS TEXT
          SIZE 12.29 BY .5 AT ROW 11.77 COL 32.57
          BGCOLOR 9 FGCOLOR 15 FONT 1
     "Almacenes:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 16.96 COL 6
     "Unidades Logística" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 11.77 COL 3
          BGCOLOR 9 FGCOLOR 15 FONT 1
     RECT-14 AT ROW 1 COL 2 WIDGET-ID 42
     RECT-15 AT ROW 11.96 COL 2 WIDGET-ID 44
     RECT-16 AT ROW 11.96 COL 27 WIDGET-ID 46
     RECT-17 AT ROW 14.85 COL 2 WIDGET-ID 48
     RECT-18 AT ROW 20.23 COL 2 WIDGET-ID 54
     RECT-19 AT ROW 15.04 COL 81 WIDGET-ID 66
     RECT-69 AT ROW 17.73 COL 81 WIDGET-ID 78
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.29 BY 21.46
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almmmatg
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
         HEIGHT             = 21.46
         WIDTH              = 107.29.
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

/* SETTINGS FOR TOGGLE-BOX Almmmatg.AftIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almmmatg.AftIsc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.CanEmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.catconta[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.Chr__01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almmmatg.Chr__03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.CodBrr IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.CodDigesa IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almmmatg.CodPr1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.CodPr2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almmmatg.CodSSFam IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.Dec__03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.DesMar IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSubSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-SubTipo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.FchAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almmmatg.FchIng IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UsrCreacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX Almmmatg.FlgComercial IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almmmatg.FlgPre IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almmmatg.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Libre_d02 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Libre_d03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Licencia[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Paquete IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Pesmat IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.PesoBruto IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.PorIsc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX Almmmatg.PP IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.StkMax IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.StkMin IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.StkRep IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.TipArt IN FRAME F-Main
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
ASSIGN 
       Almmmatg.TipArt:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.UndA IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndAlt[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndB IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndBas IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.UndC IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndCmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndStk IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almmmatg.usuario IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.VtoDigesa IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME Almmmatg.codfam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.codfam V-table-Win
ON LEAVE OF Almmmatg.codfam IN FRAME F-Main /* Familia */
DO:
   IF INPUT Almmmatg.codfam = "" THEN RETURN.
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA AND 
                       Almtfami.codfam = SELF:SCREEN-VALUE NO-ERROR.
   IF AVAILABLE Almtfami THEN
      DISPLAY Almtfami.desfam @ FILL-IN-DesFam WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF SELF:SCREEN-VALUE = '010' THEN Almmmatg.Libre_c01:SENSITIVE = YES.
   ELSE Almmmatg.Libre_c01:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.CodMar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.CodMar V-table-Win
ON LEAVE OF Almmmatg.CodMar IN FRAME F-Main /* Marca */
DO:
     IF SELF:SCREEN-VALUE = "" THEN RETURN.
     FIND almtabla WHERE almtabla.Tabla = "MK" AND
          almtabla.Codigo = Almmmatg.CodMar:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        DISPLAY almtabla.Nombre @ Almmmatg.DesMar WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.CodPr1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.CodPr1 V-table-Win
ON LEAVE OF Almmmatg.CodPr1 IN FRAME F-Main /* Proveedor A */
DO:
  IF INPUT Almmmatg.CodPr1 = "" THEN RETURN.
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
                     gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN
         DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.
      ELSE DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.CodPr2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.CodPr2 V-table-Win
ON LEAVE OF Almmmatg.CodPr2 IN FRAME F-Main /* Proveedor B */
DO:
  IF INPUT Almmmatg.CodPr2 = "" THEN RETURN.
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
                     gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN
         DISPLAY gn-prov.NomPro @ FILL-IN-NomPro2 WITH FRAME {&FRAME-NAME}.
      ELSE DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.CodSSFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.CodSSFam V-table-Win
ON LEAVE OF Almmmatg.CodSSFam IN FRAME F-Main /* SubSubFam */
DO:
  FIND AlmsSFami WHERE AlmsFami.CodCia = S-CODCIA 
      AND AlmsSFami.codfam = Almmmatg.codfam:SCREEN-VALUE 
      AND AlmsSFami.subfam = Almmmatg.subfam:SCREEN-VALUE 
      AND AlmsSFami.codssfam = Almmmatg.codssfam:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
    IF AVAILABLE AlmsSFami THEN DISPLAY AlmSSFami.DscSSFam @ F-DesSubSub WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.Libre_c01 V-table-Win
ON LEAVE OF Almmmatg.Libre_c01 IN FRAME F-Main /* Subtipo */
DO:
  FIND almtabla WHERE almtabla.Tabla = "ST"
      AND almtabla.Codigo = self:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla THEN f-SubTipo:SCREEN-VALUE = almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.Licencia[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.Licencia[1] V-table-Win
ON LEAVE OF Almmmatg.Licencia[1] IN FRAME F-Main /* Licencia */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
     FIND almtabla WHERE almtabla.Tabla = "LC" AND
          almtabla.Codigo = Almmmatg.Licencia[1]:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE almtabla THEN DO:
      MESSAGE "Codigo de Licencia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
     END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.subfam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.subfam V-table-Win
ON LEAVE OF Almmmatg.subfam IN FRAME F-Main /* Sub-Familia */
DO:
/*   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA AND
        AlmSFami.codfam = Almmmatg.codfam:SCREEN-VALUE AND
        AlmSFami.subfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE AlmSFami THEN 
      DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END. */
    FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
        AND AlmSFami.codfam = Almmmatg.codfam:SCREEN-VALUE 
        AND AlmSFami.subfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE AlmSFami THEN DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.UndA
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.UndA V-table-Win
ON LEFT-MOUSE-DBLCLICK OF Almmmatg.UndA IN FRAME F-Main /* A */
OR F8 OF {&self-name}
DO:
    input-var-1 = ''.
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-unidad-activa ('UNIDADES ACTIVAS').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.UndAlt[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.UndAlt[1] V-table-Win
ON LEFT-MOUSE-DBLCLICK OF Almmmatg.UndAlt[1] IN FRAME F-Main /* UndAlt[1] */
OR F8 OF {&self-name}
DO:
    input-var-1 = ''.
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-unidad-activa ('UNIDADES ACTIVAS').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.UndB
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.UndB V-table-Win
ON LEFT-MOUSE-DBLCLICK OF Almmmatg.UndB IN FRAME F-Main /* B */
OR F8 OF {&self-name}
DO:
    input-var-1 = ''.
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-unidad-activa ('UNIDADES ACTIVAS').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.UndBas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.UndBas V-table-Win
ON LEFT-MOUSE-DBLCLICK OF Almmmatg.UndBas IN FRAME F-Main /* Unidad Basica */
OR F8 OF {&self-name}
DO:
    input-var-1 = ''.
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-unidad-activa ('UNIDADES ACTIVAS').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.UndC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.UndC V-table-Win
ON LEFT-MOUSE-DBLCLICK OF Almmmatg.UndC IN FRAME F-Main /* C */
OR F8 OF {&self-name}
DO:
    input-var-1 = ''.
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-unidad-activa ('UNIDADES ACTIVAS').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.UndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.UndCmp V-table-Win
ON LEFT-MOUSE-DBLCLICK OF Almmmatg.UndCmp IN FRAME F-Main /* U.M. Compra */
OR F8 OF {&self-name}
DO:
    input-var-1 = ''.
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-unidad-activa ('UNIDADES ACTIVAS').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
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
/*   IF C-NUEVO = 'YES' OR (C-NUEVO = 'NO' AND C-DESMAT <> Almmmatg.DesMat) THEN DO: */
     FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = Almmmatg.codcia AND
         Almacen.TdoArt:
         /* CONSISTENCIA POR PRODUCTO Y ALMACEN */
         IF Almmmatg.TpoMrg <> '' AND Almacen.Campo-c[2] <> '' THEN DO:
             IF Almmmatg.TpoMrg <> Almacen.Campo-c[2] THEN NEXT.
         END.
         /* *********************************** */
         FIND Almmmate WHERE Almmmate.CodCia = Almmmatg.codcia AND 
              Almmmate.CodAlm = Almacen.CodAlm AND 
              Almmmate.CodMat = Almmmatg.CodMat NO-ERROR.
         IF NOT AVAILABLE Almmmate THEN DO:
            CREATE Almmmate.
            ASSIGN Almmmate.CodCia = Almmmatg.codcia
                   Almmmate.CodAlm = Almacen.CodAlm
                   Almmmate.CodMat = Almmmatg.CodMat.
         END.
         ASSIGN Almmmate.DesMat = Almmmatg.DesMat
                Almmmate.FacEqu = Almmmatg.FacEqu
                Almmmate.UndVta = Almmmatg.UndStk
                Almmmate.CodMar = Almmmatg.CodMar.
         FIND FIRST almautmv WHERE 
              almautmv.CodCia = Almmmatg.codcia AND
              almautmv.CodFam = Almmmatg.codfam AND
              almautmv.CodMar = Almmmatg.codMar AND
              almautmv.Almsol = Almmmate.CodAlm NO-LOCK NO-ERROR.
         IF AVAILABLE almautmv THEN 
            ASSIGN Almmmate.AlmDes = almautmv.Almdes
                   Almmmate.CodUbi = almautmv.CodUbi.
     END.
/*   END. */
     RELEASE Almmmate.
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
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almmmatg"}

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

/*MLR* 08/11/07 ***
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
* ***/

RUN lib/_port-name('Barras', OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.
IF s-OpSys = 'WinVista' OR s-OpSys = 'WinXP'
THEN OUTPUT TO PRINTER VALUE(s-port-name).
ELSE OUTPUT TO VALUE(s-port-name).

X-BARRA = STRING(SUBSTRING(Almmmatg.CodBrr,1,15),"x(15)").

put control chr(27) + '^XA^LH000,012'.  /*&& Inicio de formato*/
put control chr(27) + '^FO155,00'.  /*&& Coordenadas de origen campo1  DESPRO1*/
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + Almmmatg.desmat.
put control chr(27) + '^FS'.  /*&& Fin de Campo1*/
put control chr(27) + '^FO130,00'.  /*&& Coordenadas de origen campo2  DESPRO2*/
put control chr(27) + '^A0R,25,15'.
put control chr(27) +  '^FD' + Almmmatg.desmar + " " + Almmmatg.undbas.
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
  RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  /*DISPLAY TODAY @ Almmmatg.FchIng WITH FRAME {&FRAME-NAME}.*/
   DO WITH FRAME {&FRAME-NAME}:
    DISPLAY "" @ Almmmatg.TipArt.
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

  DEFINE VAR lValidacionOK AS CHAR.
  DEFINE VAR lSec AS INT.
  DEFINE VAR lAlms AS CHAR.
  DEFINE VAR Almx AS CHAR.
  DEFINE VAR lComa AS CHAR.

/*   /* RHC 26/11/2015 SOLO se va a actualizar el TC si estaba con cero */ */
/*   DEF VAR x-TpoCmbOld LIKE Almmmatg.TpoCmb NO-UNDO.                     */
/*   x-TpoCmbOld = Almmmatg.TpoCmb.                                        */
/*   MESSAGE 'inicio' x-TpoCmbOld.                                         */

  /* Code placed here will execute PRIOR to standard behavior. */
  IF C-NUEVO = "YES" THEN DO WITH FRAME {&FRAME-NAME}:
     FIND LAST MATG WHERE MATG.CodCia = S-CODCIA NO-LOCK NO-ERROR.
     IF AVAILABLE MATG THEN x-NroCor = INTEGER(MATG.codmat) + 1.
     ELSE x-NroCor = 1.
     FIND LAST MATG WHERE MATG.Codcia = S-CODCIA 
                     AND  MATG.CodFam = Almmmatg.Codfam:SCREEN-VALUE 
                    USE-INDEX Matg08 NO-LOCK NO-ERROR.
     IF AVAILABLE MATG THEN x-ordmat = MATG.Orden + 3.
     ELSE x-ordmat = 1.
  END.
  ELSE x-TpoArt = Almmmatg.TpoArt.      /* MODIFICAR */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF C-NUEVO = "YES" THEN DO:
     ASSIGN Almmmatg.CodCia  = S-CODCIA
            Almmmatg.FchIng  = TODAY
            Almmmatg.codmat  = STRING(x-NroCor,"999999")
            Almmmatg.orden   = x-ordmat
            Almmmatg.ordlis  = x-ordmat.
    x-TpoArt = Almmmatg.TpoArt.         /* CREAR */
  END.

  /*RD01 - Mayuscula para todas las descripciones*/
  ASSIGN 
      Almmmatg.DesMat = CAPS(Almmmatg.DesMat)
      Almmmatg.TpoArt = CAPS(Almmmatg.TpoArt).
  /**********************************************/

  
  ASSIGN /*Almmmatg.UndCmp = Almmmatg.UndStk*/
      Almmmatg.FchAct = TODAY
      Almmmatg.usuario = S-USER-ID
      Almmmatg.UndStk = Almmmatg.UndBas
      Almmmatg.CHR__01 = Almmmatg.UndBas.

  FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
      AND  Almtconv.Codalter = Almmmatg.UndStk 
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtconv THEN Almmmatg.FacEqu = Almtconv.Equival.
  
  FIND almtabla WHERE almtabla.Tabla = "MK" 
                 AND  almtabla.Codigo = Almmmatg.CodMar 
                NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla THEN ASSIGN Almmmatg.DesMar = almtabla.Nombre.
  
  /* Actualizamos la lista de Almacenes */ 
  C-ALM = TRIM(Almmmatg.almacenes).
  lAlms = C-ALM.
  C-ALM = "".
  lComa = "".
  DO lSec = 1 TO NUM-ENTRIES(lAlms):
                Almx = ENTRY(lSec,lAlms,",").
        /*IF almx <> '11M' THEN DO:*/
            C-ALM = C-ALM + lComa + Almx.
            lComa = ",".
        /*END.*/
 END.
 FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = Almmmatg.codcia
                            AND  Almacen.TdoArt:
      lValidacionOK = 'SI'.
/*       IF almacen.codalm = '11M' THEN DO:                                      */
/*           lValidacionOK = 'NO'.                                               */
/*           lValidacionOK = fValida-excepcion(Almmmatg.codmat, almacen.codalm). */
/*       END.                                                                    */

      IF lValidacionOK = 'SI' THEN DO:
          /* CONSISTENCIA POR PRODUCTO Y ALMACEN */
          IF Almmmatg.TpoMrg <> '' AND Almacen.Campo-c[2] <> '' THEN DO:
              IF Almmmatg.TpoMrg <> Almacen.Campo-c[2] THEN NEXT.
          END.
          /* *********************************** */
          IF C-ALM = "" THEN C-ALM = TRIM(Almacen.CodAlm).
          IF LOOKUP(TRIM(Almacen.CodAlm),C-ALM) = 0 THEN C-ALM = C-ALM + "," + TRIM(Almacen.CodAlm).
      END.
  END.
  ASSIGN Almmmatg.almacenes = C-ALM
         Almmmatg.TipArt = Almmmatg.TipArt:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
              
  /* PARCHE */
  IF Almmmatg.CodFam <> "010" THEN Almmmatg.Libre_c01 = "".

  /* RHC 19.11.04 LOG del catalogo */
/*   IF x-TpoArt <> Almmmatg.TpoArt THEN x-TpoArt = '*'. */
/*   RUN lib/logtabla ('almmmatg',                       */
/*                     almmmatg.codmat + '|' + x-TpoArt, */
/*                     'CATALOGO').                      */

  /* RHC 24/10/2015 */
  FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
/*   IF x-TpoCmbOld = 0 AND AVAILABLE Almtfami AND Almtfami.TpoCmb > 0 */
/*       THEN ASSIGN Almmmatg.tpocmb = Almtfami.TpoCmb.                */
/*   MESSAGE 'final' almmmatg.tpocmb.                                  */
  IF AVAILABLE Almtfami AND Almtfami.TpoCmb > 0 THEN ASSIGN Almmmatg.tpocmb = Almtfami.TpoCmb.

  /* Ic 23Feb2016, Verificar Categoria Contable */
  IF almmmatg.catconta[1] = ? OR almmmatg.catconta[1] = ''  THEN DO:
      IF Almtfami.libre_c01 <> ? AND Almtfami.libre_c01 <> '' THEN DO:
          ASSIGN almmmatg.catconta[1] = Almtfami.libre_c01.
      END.
  END.

  /* Todas las unidades en mayusculas */
  ASSIGN
      Almmmatg.Chr__01   = CAPS(Almmmatg.Chr__01)
      Almmmatg.UndA      = CAPS(Almmmatg.UndA)
      Almmmatg.UndAlt[1] = CAPS(Almmmatg.UndAlt[1])
      Almmmatg.UndB      = CAPS(Almmmatg.UndB) 
      Almmmatg.UndBas    = CAPS(Almmmatg.UndBas) 
      Almmmatg.UndC      = CAPS(Almmmatg.UndC) 
      Almmmatg.UndCmp    = CAPS(Almmmatg.UndCmp) 
      Almmmatg.UndStk    = CAPS(Almmmatg.UndStk).
  
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
        Almmmatg.TipArt:SCREEN-VALUE = ''
        Almmmatg.CodMat:SCREEN-VALUE = ''.
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
/*   FIND Almdmov WHERE Almdmov.CodCia = S-CODCIA AND                      */
/*                      Almdmov.CodMat = Almmmatg.CodMat NO-LOCK NO-ERROR. */
/*   IF AVAILABLE Almdmov THEN DO:                                         */
/*      MESSAGE "Material tiene movimientos" SKIP "No se puede eliminar"   */
/*               VIEW-AS ALERT-BOX ERROR.                                  */
/*      RETURN "ADM-ERROR".                                                */
/*   END.                                                                  */
/*   FOR EACH Almmmate WHERE Almmmate.CodCia = S-CODCIA AND                */
/*            Almmmate.CodMat = Almmmatg.CodMat:                           */
/*         DELETE Almmmate.                                                */
/*   END.                                                                  */

  MESSAGE 'Los productos NO se pueden anular, solo se pueden DESACTIVAR'
      VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.

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
  
  ASSIGN Almmmatg.flgComercial:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  IF AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
/*       CASE Almmmatg.TpoArt:                                                           */
/*           WHEN 'A' THEN DISPLAY "Activado" @ F-destado WITH FRAME {&FRAME-NAME}.      */
/*           WHEN 'B' THEN DISPLAY "Baja Rotacion" @ F-destado WITH FRAME {&FRAME-NAME}. */
/*           OTHERWISE DISPLAY "Desactivado" @ F-destado WITH FRAME {&FRAME-NAME}.       */
/*       END CASE.                                                                       */
     FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
                    AND  Almtfami.codfam = Almmmatg.codfam 
                   NO-LOCK NO-ERROR.
     IF AVAILABLE Almtfami THEN DISPLAY Almtfami.desfam @ FILL-IN-DesFam WITH FRAME {&FRAME-NAME}.
     FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                    AND  AlmSFami.codfam = Almmmatg.codfam 
                    AND  AlmSFami.subfam = Almmmatg.subfam 
                   NO-LOCK NO-ERROR.
     IF AVAILABLE AlmSFami THEN DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
     FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                   AND  gn-prov.CodPro = Almmmatg.CodPr1 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.
     FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                   AND  gn-prov.CodPro = Almmmatg.CodPr2 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN DISPLAY gn-prov.NomPro @ FILL-IN-NomPro2 WITH FRAME {&FRAME-NAME}.
/*      x-DesMat-2:SCREEN-VALUE = ''.                                 */
/*      FIND matg WHERE matg.codcia = s-codcia                        */
/*        AND matg.codmat = almmmatg.CodAnt                           */
/*        NO-LOCK NO-ERROR.                                           */
/*      IF AVAILABLE matg THEN x-DesMat-2:SCREEN-VALUE = matg.desmat. */
     FIND Almtabla WHERE Almtabla.tabla = "ST"
         AND Almtabla.codig = Almmmatg.libre_c01
         NO-LOCK NO-ERROR.
     IF AVAILABLE Almtabla THEN DISPLAY almtabla.Nombre @  f-SubTipo.

      FILL-IN-UsrCreacion = ENTRY(1, Almmmatg.Libre_c05).
      DISPLAY FILL-IN-UsrCreacion WITH FRAME {&FRAME-NAME}.
      /*  */      
      IF almmmatg.flgComercial = ? OR almmmatg.flgComercial = "" THEN DO:
          
          ASSIGN flgComercial:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
          
      END.

  END.
  /* Code placed here will execute AFTER standard behavior.    */
        /*ASSIGN flgComercial.*/
  /*
        DEFINE VAR lx1 AS INT.
    DEFINE VAR txtVal AS CHAR.

        lx1 = flgComercial:LOOKUP(flgComercial).
        txtVal = ENTRY( lx1 * 2 - 1 , flgComercial:LIST-ITEM-PAIRS ) NO-ERROR.

    flgComercial:SCREEN-VALUE = txtVal.
  */

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
  IF RETURN-VALUE = 'NO' THEN DO WITH FRAME {&FRAME-NAME}:
      IF x-Acceso = NO THEN DO:
          ASSIGN
              Almmmatg.UndBas:SENSITIVE = NO
              Almmmatg.UndCmp:SENSITIVE = NO
              Almmmatg.UndStk:SENSITIVE = NO
              Almmmatg.CodBrr:SENSITIVE = NO
              Almmmatg.UndAlt[1]:SENSITIVE = NO
              .
          IF Almmmatg.UndA = '' THEN Almmmatg.UndA:SENSITIVE = YES.
          IF Almmmatg.UndB = '' THEN Almmmatg.UndB:SENSITIVE = YES.
          IF Almmmatg.UndC = '' THEN Almmmatg.UndC:SENSITIVE = YES.
          
      END.
      FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
      IF AVAILABLE Almsfami AND Almsfami.SwDigesa = NO 
          THEN ASSIGN
                    Almmmatg.CodDigesa:SENSITIVE = NO
                    Almmmatg.VtoDigesa:SENSITIVE = NO.
      IF Almmmatg.CodFam <> '010' THEN Almmmatg.Libre_c01:SENSITIVE = NO.
      /* RHC 16/07/18 Correo Daniel Llican */
      /*IF Almmmatg.TpoArt = "D" THEN Almmmatg.TpoArt:SENSITIVE = NO.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
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
    REPEAT WHILE Almmmatg.FlgComercial:NUM-ITEMS > 0:
        FlgComercial:DELETE(1).
    END.

    flgComercial:ADD-LAST('<Ninguno>',' ' ).
    FOR EACH almtabla WHERE almtabla.tabla = 'IN_CO' NO-LOCK:
        flgComercial:ADD-LAST(almtabla.nombre,almtabla.codigo ).
    END.

  END.

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
  ASSIGN C-NUEVO = RETURN-VALUE
         C-DESMAT = "".
  IF RETURN-VALUE = 'NO' THEN ASSIGN C-DESMAT = Almmmatg.DesMat.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN ACTUALIZA-MAT-x-ALM.  
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
            WHEN "subfam" THEN ASSIGN input-var-1 = Almmmatg.codfam:SCREEN-VALUE.
            WHEN "CodSSFam" THEN ASSIGN input-var-1 = Almmmatg.codfam:SCREEN-VALUE
                input-var-2 = Almmmatg.subfam:SCREEN-VALUE.
            WHEN "UndStk" THEN ASSIGN input-var-1 = Almmmatg.UndBas:SCREEN-VALUE.
            WHEN "CodMar" THEN ASSIGN input-var-1 = "MK".
            WHEN "Licencia" THEN ASSIGN input-var-1 = "LC".
            WHEN "Chr__03" THEN ASSIGN input-var-1 = "IP".
            WHEN "CatConta" THEN ASSIGN input-var-1 = "CC".
            WHEN "Libre_c01" THEN ASSIGN input-var-1 = "ST".
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
  {src/adm/template/snd-list.i "Almmmatg"}

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
        Almtfami.codfam = Almmmatg.codfam:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almtfami THEN DO:
      MESSAGE "Codigo de Familia no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almmmatg.CodFam.
      RETURN "ADM-ERROR".   
   END.
   FIND Almsfami WHERE Almsfami.CodCia = S-CODCIA AND
        Almsfami.codfam = Almmmatg.codfam:SCREEN-VALUE AND
        AlmSFami.subfam = Almmmatg.subfam:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmSFami THEN DO:
      MESSAGE "Codigo de Familia no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almmmatg.SubFam.
      RETURN "ADM-ERROR".   
   END.
   FIND Almssfami WHERE Almssfami.CodCia = S-CODCIA 
       AND Almssfami.codfam = Almmmatg.codfam:SCREEN-VALUE 
       AND AlmsSFami.subfam = Almmmatg.subfam:SCREEN-VALUE 
       AND AlmSSFami.CodSSFam = Almmmatg.codssfam:SCREEN-VALUE 
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmsSFami THEN DO:
      MESSAGE "Codigo de Sub Sub Familia no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almmmatg.codssfam.
      RETURN "ADM-ERROR".   
   END.
   IF Almmmatg.DesMat:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Descripcion de articulo en blanco ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almmmatg.DesMat.
      RETURN "ADM-ERROR".   
   END.
   IF Almmmatg.CodPr1:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Proveedor en blanco ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almmmatg.CodPr1.
      RETURN "ADM-ERROR".   
   END.
   FIND Unidades WHERE Unidades.Codunid = Almmmatg.UndBas:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Unidades THEN DO:
      MESSAGE "Unidad Basica no válida ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almmmatg.UndBas.
      RETURN "ADM-ERROR".   
   END.
   FIND Unidades WHERE Unidades.Codunid = Almmmatg.UndCmp:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Unidades THEN DO:
      MESSAGE "Unidad de compra no válida ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almmmatg.UndCmp.
      RETURN "ADM-ERROR".   
   END.
   FIND Unidades WHERE Unidades.Codunid = Almmmatg.UndAlt[1]:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF Almmmatg.UndAlt[1]:SCREEN-VALUE > '' AND
       (NOT AVAILABLE Unidades )
       THEN DO:
       MESSAGE "Unidad al por menor no válida ..." VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Almmmatg.UndAlt[1].
       RETURN "ADM-ERROR".   
   END.
   /*TpoArt solo puede ser A,D y B*/
   IF LOOKUP(Almmmatg.TpoArt:SCREEN-VALUE,"A,D,B") = 0 THEN DO:
       MESSAGE "Estado Inválido"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       APPLY "ENTRY" TO Almmmatg.TpoArt.
       RETURN "ADM-ERROR".   
   END.

   IF Almmmatg.TpoArt:SCREEN-VALUE = 'D'
   THEN DO:
        /* Verificamos el stock */
        FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codmat = Almmmatg.codmat:SCREEN-VALUE:
            /*FIRST Almacen OF Almmmate NO-LOCK WHERE Almacen.AutMov = YES:*/
            IF Almmmate.stkact <> 0 THEN DO:
                MESSAGE 'No puede desactivar un material que aún tiene stock en el almacén' almmmate.codalm
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO Almmmatg.tpoart.
                RETURN 'ADM-ERROR'.
            END.
        END.
   END.
   IF almmmatg.codfam:SCREEN-VALUE = '010' AND Almmmatg.Licencia[1]:SCREEN-VALUE <> '' THEN DO:
       FIND almtabla WHERE almtabla.Tabla = "LC" 
           AND almtabla.Codigo = Almmmatg.Licencia[1]:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE almtabla THEN DO:
           MESSAGE "Codigo de Licencia no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN "ADM-ERROR".
       END.
   END.
   IF Almmmatg.catconta[1]:SCREEN-VALUE = '' THEN DO:
       MESSAGE "Categoria Contable en blanco...." VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Almmmatg.catconta[1].
      RETURN "ADM-ERROR". 
   END.
   ELSE DO:
       FIND AlmTabla WHERE AlmTabla.Tabla = 'CC' 
           AND AlmTabla.Codigo = Almmmatg.catconta[1]:SCREEN-VALUE
           NO-LOCK NO-ERROR.
       IF NOT AVAILABLE AlmTabla THEN DO:
           MESSAGE "Categoria Contable no registrada" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO Almmmatg.catconta[1].
          RETURN "ADM-ERROR". 
       END.
   END.
   FIND Almsfami WHERE Almsfami.codcia = s-codcia
       AND ALmsfami.codfam = Almmmatg.codfam:SCREEN-VALUE
       AND Almsfami.subfam = Almmmatg.subfam:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE Almsfami AND Almsfami.SwDigesa = YES THEN DO:
       IF Almmmatg.CodDigesa:SCREEN-VALUE = ''
           OR INPUT Almmmatg.VtoDigesa = ? THEN DO:
           MESSAGE 'Ingrese datos de DIGESA' VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO Almmmatg.CodDigesa.
           RETURN "ADM-ERROR". 
       END.
   END.

   IF Almmmatg.CodPr1:SCREEN-VALUE <> '' THEN DO:
       FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
           AND gn-prov.CodPro = Almmmatg.CodPr1:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
           APPLY 'entry' TO Almmmatg.CodPr1.
           RETURN 'ADM-ERROR'.
       END.
   END.

   IF Almmmatg.codfam:SCREEN-VALUE = '010' 
       AND Almmmatg.Libre_c01:SCREEN-VALUE <> ""
       THEN DO:
       FIND almtabla WHERE almtabla.tabla = "ST"
           AND almtabla.codig = Almmmatg.Libre_c01:SCREEN-VALUE
           NO-LOCK NO-ERROR.
       IF NOT AVAILABLE almtabla THEN DO:
           MESSAGE "SUBTIPO no registrado" VIEW-AS ALERT-BOX ERROR.
           APPLY 'entry' TO Almmmatg.Libre_c01.
           RETURN 'ADM-ERROR'.
       END.
   END.

   FIND Unidades WHERE Unidades.Codunid = Almmmatg.UndA:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF Almmmatg.UndA:SCREEN-VALUE > '' AND 
       (NOT AVAILABLE Unidades )
       THEN DO:
       MESSAGE "Unidad A no válida" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Almmmatg.UndA.
       RETURN "ADM-ERROR".   
   END.
   FIND Unidades WHERE Unidades.Codunid = Almmmatg.UndB:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF Almmmatg.UndB:SCREEN-VALUE > '' AND 
       (NOT AVAILABLE Unidades )
       THEN DO:
       MESSAGE "Unidad B no válida" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Almmmatg.UndB.
       RETURN "ADM-ERROR".   
   END.
   FIND Unidades WHERE Unidades.Codunid = Almmmatg.UndC:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF Almmmatg.UndC:SCREEN-VALUE > '' AND 
       (NOT AVAILABLE Unidades )
       THEN DO:
       MESSAGE "Unidad C no válida" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO Almmmatg.UndC.
       RETURN "ADM-ERROR".   
   END.
   IF Almmmatg.UndA:SCREEN-VALUE = Almmmatg.UndB:SCREEN-VALUE
       AND Almmmatg.UndA:SCREEN-VALUE <> ""
       THEN DO:
       MESSAGE 'Las unidades de venta NO pueden ser iguales' VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO Almmmatg.UndA.
       RETURN 'ADM-ERROR'.
   END.
   IF Almmmatg.UndA:SCREEN-VALUE = Almmmatg.UndC:SCREEN-VALUE
       AND Almmmatg.UndA:SCREEN-VALUE <> ""
       THEN DO:
       MESSAGE 'Las unidades de venta NO pueden ser iguales' VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO Almmmatg.UndA.
       RETURN 'ADM-ERROR'.
   END.
   IF Almmmatg.UndB:SCREEN-VALUE = Almmmatg.UndC:SCREEN-VALUE
       AND Almmmatg.UndB:SCREEN-VALUE <> ""
       THEN DO:
       MESSAGE 'Las unidades de venta NO pueden ser iguales' VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO Almmmatg.UndB.
       RETURN 'ADM-ERROR'.
   END.
   IF almmmatg.CodBrr:SCREEN-VALUE <> '' THEN DO:
       FIND FIRST b-matg WHERE b-matg.codcia = s-codcia
                   AND b-matg.codbrr = almmmatg.CodBrr:SCREEN-VALUE 
                   AND b-matg.codmat <> Almmmatg.codmat:SCREEN-VALUE
           NO-LOCK NO-ERROR.
       IF AVAILABLE b-matg THEN DO:
           MESSAGE 'Código de barra YA registrado en el material' b-matg.codmat
               VIEW-AS ALERT-BOX WARNING.
           APPLY 'ENTRY' TO almmmatg.CodBrr.
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

IF Almmmatg.FchIng < (TODAY - 15)   /* (TODAY - 3) */
THEN DO:
    x-Acceso = NO.      /* Acceso limitado */
END.    
ELSE x-Acceso = YES.

x-Acceso = YES.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fValida-excepcion V-table-Win 
FUNCTION fValida-excepcion RETURNS CHARACTER
  ( INPUT pArticulo AS CHAR, INPUT pAlmacen AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lRet AS CHAR.

    lRet = 'NO'.
    FIND FIRST almtabla WHERE almtabla.tabla = '11M' AND 
                                almtabla.codigo = pArticulo
                        NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla THEN DO:
        lRet = 'SI'.
    END.
    
    RETURN lRet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

