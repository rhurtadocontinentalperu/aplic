&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
&Scoped-define EXTERNAL-TABLES integral.Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE integral.Almmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 RECT-4 RECT-7 RECT-12 RECT-13 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.Almmmatg.codmat ~
INTEGRAL.Almmmatg.DesMat INTEGRAL.Almmmatg.CodMar INTEGRAL.Almmmatg.DesMar ~
INTEGRAL.Almmmatg.TpoArt INTEGRAL.Almmmatg.Licencia[1] ~
INTEGRAL.Almmmatg.TipArt INTEGRAL.Almmmatg.codfam INTEGRAL.Almmmatg.TpoPro ~
INTEGRAL.Almmmatg.Chr__02 INTEGRAL.Almmmatg.subfam ~
INTEGRAL.Almmmatg.Chr__03 INTEGRAL.Almmmatg.AftIgv ~
INTEGRAL.Almmmatg.Libre_c01 INTEGRAL.Almmmatg.PorIsc ~
INTEGRAL.Almmmatg.AftIsc INTEGRAL.Almmmatg.Detalle INTEGRAL.Almmmatg.TpoMrg ~
INTEGRAL.Almmmatg.CodBrr INTEGRAL.Almmmatg.catconta[1] ~
INTEGRAL.Almmmatg.CodDigesa INTEGRAL.Almmmatg.VtoDigesa ~
INTEGRAL.Almmmatg.Libre_d01 INTEGRAL.Almmmatg.Libre_d02 ~
INTEGRAL.Almmmatg.Pesmat INTEGRAL.Almmmatg.UndBas INTEGRAL.Almmmatg.UndA ~
INTEGRAL.Almmmatg.UndB INTEGRAL.Almmmatg.UndC INTEGRAL.Almmmatg.CanEmp ~
INTEGRAL.Almmmatg.UndCmp INTEGRAL.Almmmatg.Chr__01 INTEGRAL.Almmmatg.UndStk ~
INTEGRAL.Almmmatg.Dec__03 INTEGRAL.Almmmatg.UndAlt[1] ~
INTEGRAL.Almmmatg.CodPr1 INTEGRAL.Almmmatg.CodPr2 ~
INTEGRAL.Almmmatg.almacenes INTEGRAL.Almmmatg.usuario ~
INTEGRAL.Almmmatg.FchAct 
&Scoped-define DISPLAYED-TABLES INTEGRAL.Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE INTEGRAL.Almmmatg
&Scoped-Define DISPLAYED-OBJECTS F-destado FILL-IN-DesFam F-DesSub ~
f-SubTipo FILL-IN-NomPro1 FILL-IN-NomPro2 

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

DEFINE VARIABLE F-destado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE f-SubTipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 10.29 BY 1.27.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.35.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.86 BY 6.35.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 19.86 BY 3.58.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 57.57 BY 3.54.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 9.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.Almmmatg.codmat AT ROW 1.15 COL 8.29 COLON-ALIGNED NO-LABEL FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .69
          BGCOLOR 15 FONT 0
     INTEGRAL.Almmmatg.DesMat AT ROW 1.19 COL 18.29 COLON-ALIGNED NO-LABEL FORMAT "X(42)"
          VIEW-AS FILL-IN 
          SIZE 45.72 BY .69
     F-destado AT ROW 1.27 COL 64 COLON-ALIGNED NO-LABEL
     INTEGRAL.Almmmatg.CodMar AT ROW 2.12 COL 8.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     INTEGRAL.Almmmatg.DesMar AT ROW 2.12 COL 15.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 27 BY .69
          FONT 0
     INTEGRAL.Almmmatg.TpoArt AT ROW 2.12 COL 50.29 COLON-ALIGNED
          LABEL "Estado"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .69
          BGCOLOR 15 
     INTEGRAL.Almmmatg.Licencia[1] AT ROW 2.12 COL 60.29 COLON-ALIGNED
          LABEL "Licencia" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .69
          BGCOLOR 15 
     INTEGRAL.Almmmatg.TipArt AT ROW 2.12 COL 73 COLON-ALIGNED
          LABEL "Rotacion"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .65
          BGCOLOR 15 
     INTEGRAL.Almmmatg.codfam AT ROW 3 COL 8.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     FILL-IN-DesFam AT ROW 3 COL 15.14 COLON-ALIGNED NO-LABEL
     INTEGRAL.Almmmatg.TpoPro AT ROW 3 COL 63.43 COLON-ALIGNED NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "Nacional","Importado" 
          DROP-DOWN-LIST
          SIZE 11 BY .81
     INTEGRAL.Almmmatg.Chr__02 AT ROW 3.08 COL 52.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Propio", "P":U,
"Tercero", "T":U
          SIZE 9 BY 1.12
     INTEGRAL.Almmmatg.subfam AT ROW 3.81 COL 8.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     F-DesSub AT ROW 3.81 COL 15.14 COLON-ALIGNED NO-LABEL
     INTEGRAL.Almmmatg.Chr__03 AT ROW 4.08 COL 67 COLON-ALIGNED
          LABEL "IP" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     INTEGRAL.Almmmatg.AftIgv AT ROW 4.38 COL 52.57
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 11.72 BY .69
     INTEGRAL.Almmmatg.Libre_c01 AT ROW 4.62 COL 8.29 COLON-ALIGNED WIDGET-ID 24
          LABEL "Subtipo" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     f-SubTipo AT ROW 4.62 COL 15.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     INTEGRAL.Almmmatg.PorIsc AT ROW 4.92 COL 64.14 COLON-ALIGNED
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .69
     INTEGRAL.Almmmatg.AftIsc AT ROW 5 COL 52.57
          LABEL "Afecto a ISC"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .69
     INTEGRAL.Almmmatg.Detalle AT ROW 5.31 COL 10.29 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 34.72 BY 1.92
     INTEGRAL.Almmmatg.TpoMrg AT ROW 5.85 COL 66 NO-LABEL WIDGET-ID 12
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
         SIZE 78.29 BY 20.58
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     INTEGRAL.Almmmatg.CodBrr AT ROW 7.38 COL 14.43 COLON-ALIGNED
          LABEL "Codigo de Barras" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .69
          BGCOLOR 15 FONT 0
     INTEGRAL.Almmmatg.catconta[1] AT ROW 8.12 COL 14.43 COLON-ALIGNED WIDGET-ID 6
          LABEL "Cat. Contable"
          VIEW-AS FILL-IN 
          SIZE 3.86 BY .69
     INTEGRAL.Almmmatg.CodDigesa AT ROW 8.92 COL 14.43 COLON-ALIGNED WIDGET-ID 8
          LABEL "Cod. Digesa"
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     INTEGRAL.Almmmatg.VtoDigesa AT ROW 8.92 COL 48.43 COLON-ALIGNED WIDGET-ID 10
          LABEL "Vcmto. Digesa"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.Almmmatg.Libre_d01 AT ROW 10.42 COL 15 COLON-ALIGNED WIDGET-ID 18
          LABEL "Múltiplo de fracción" FORMAT ">.99"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     INTEGRAL.Almmmatg.Libre_d02 AT ROW 10.42 COL 38.72 COLON-ALIGNED WIDGET-ID 20
          LABEL "Volumen en cm3" FORMAT ">>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.Almmmatg.Pesmat AT ROW 10.42 COL 65.72 COLON-ALIGNED
          LABEL "Peso por Unidad"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.Almmmatg.UndBas AT ROW 12.38 COL 11 COLON-ALIGNED FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     INTEGRAL.Almmmatg.UndA AT ROW 12.62 COL 32.86 COLON-ALIGNED
          LABEL "A" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     INTEGRAL.Almmmatg.UndB AT ROW 12.62 COL 42.14 COLON-ALIGNED
          LABEL "B" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     INTEGRAL.Almmmatg.UndC AT ROW 12.62 COL 51.14 COLON-ALIGNED
          LABEL "C" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     INTEGRAL.Almmmatg.CanEmp AT ROW 12.62 COL 66.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
          BGCOLOR 15 
     INTEGRAL.Almmmatg.UndCmp AT ROW 13.08 COL 11 COLON-ALIGNED
          LABEL "U.M. Compra" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     INTEGRAL.Almmmatg.Chr__01 AT ROW 13.35 COL 32.86 COLON-ALIGNED
          LABEL "" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     INTEGRAL.Almmmatg.UndStk AT ROW 13.77 COL 11 COLON-ALIGNED
          LABEL "U.M. Stock" FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     INTEGRAL.Almmmatg.Dec__03 AT ROW 13.92 COL 66.57 COLON-ALIGNED
          LABEL "Mínimo de Venta" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
          BGCOLOR 15 FGCOLOR 12 
     INTEGRAL.Almmmatg.UndAlt[1] AT ROW 14.12 COL 32.86 COLON-ALIGNED NO-LABEL FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
     INTEGRAL.Almmmatg.CodPr1 AT ROW 15.23 COL 10.57 COLON-ALIGNED
          LABEL "Proveedor A"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
          BGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.29 BY 20.58
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FILL-IN-NomPro1 AT ROW 15.23 COL 21.57 COLON-ALIGNED NO-LABEL
     INTEGRAL.Almmmatg.CodPr2 AT ROW 16 COL 10.57 COLON-ALIGNED
          LABEL "Proveedor B"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
          BGCOLOR 15 
     FILL-IN-NomPro2 AT ROW 16 COL 21.57 COLON-ALIGNED NO-LABEL
     INTEGRAL.Almmmatg.almacenes AT ROW 16.77 COL 12.57 NO-LABEL
          VIEW-AS EDITOR
          SIZE 65 BY 3.31
          BGCOLOR 15 
     INTEGRAL.Almmmatg.usuario AT ROW 20.27 COL 11 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
          BGCOLOR 15 
     INTEGRAL.Almmmatg.FchAct AT ROW 20.27 COL 48 COLON-ALIGNED
          LABEL "Ultima Modificacion" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .81
          BGCOLOR 15 
     "Almacenes:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 16.96 COL 4.57
     "Unidades Logística" VIEW-AS TEXT
          SIZE 18 BY .69 AT ROW 11.62 COL 1.86
          FONT 1
     "Al por menor" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 14.12 COL 22
          FONT 1
     "Detalles" VIEW-AS TEXT
          SIZE 6.57 BY .5 AT ROW 5.85 COL 2
     "Solo para Almacenes:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 5.85 COL 51 WIDGET-ID 16
          BGCOLOR 15 FGCOLOR 0 
     "Mostrador" VIEW-AS TEXT
          SIZE 10.57 BY .69 AT ROW 12.38 COL 22
          FONT 1
     "Artículo" VIEW-AS TEXT
          SIZE 7.72 BY .69 AT ROW 1.08 COL 1.43
          FONT 1
     "Unidades Venta" VIEW-AS TEXT
          SIZE 16.14 BY .69 AT ROW 11.62 COL 22.29
          FONT 1
     "Oficina" VIEW-AS TEXT
          SIZE 10.57 BY .69 AT ROW 13.27 COL 22.14
          FONT 1
     RECT-5 AT ROW 11.5 COL 1
     RECT-6 AT ROW 11.54 COL 21.43
     RECT-4 AT ROW 15.08 COL 1.14
     RECT-7 AT ROW 1 COL 1
     RECT-12 AT ROW 2.96 COL 52
     RECT-13 AT ROW 10.15 COL 1 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.29 BY 20.58
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
         HEIGHT             = 20.58
         WIDTH              = 78.29.
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

/* SETTINGS FOR TOGGLE-BOX INTEGRAL.Almmmatg.AftIgv IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX INTEGRAL.Almmmatg.AftIsc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR EDITOR INTEGRAL.Almmmatg.almacenes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.CanEmp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.catconta[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.Chr__01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR RADIO-SET INTEGRAL.Almmmatg.Chr__02 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.Chr__03 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.CodBrr IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.CodDigesa IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.codfam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.CodMar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.codmat IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.CodPr1 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.CodPr2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.Dec__03 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.DesMar IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.DesMat IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR EDITOR INTEGRAL.Almmmatg.Detalle IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-destado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-SubTipo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.FchAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.Libre_c01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.Libre_d01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.Libre_d02 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.Licencia[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.Pesmat IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.PorIsc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.subfam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.TipArt IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.TpoArt IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET INTEGRAL.Almmmatg.TpoMrg IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX INTEGRAL.Almmmatg.TpoPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.UndA IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.UndAlt[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.UndB IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.UndBas IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.UndC IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.UndCmp IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.UndStk IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN INTEGRAL.Almmmatg.VtoDigesa IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME INTEGRAL.Almmmatg.codfam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.Almmmatg.codfam V-table-Win
ON LEAVE OF INTEGRAL.Almmmatg.codfam IN FRAME F-Main /* Familia */
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


&Scoped-define SELF-NAME INTEGRAL.Almmmatg.CodMar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.Almmmatg.CodMar V-table-Win
ON LEAVE OF INTEGRAL.Almmmatg.CodMar IN FRAME F-Main /* Marca */
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


&Scoped-define SELF-NAME INTEGRAL.Almmmatg.CodPr1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.Almmmatg.CodPr1 V-table-Win
ON LEAVE OF INTEGRAL.Almmmatg.CodPr1 IN FRAME F-Main /* Proveedor A */
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


&Scoped-define SELF-NAME INTEGRAL.Almmmatg.CodPr2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.Almmmatg.CodPr2 V-table-Win
ON LEAVE OF INTEGRAL.Almmmatg.CodPr2 IN FRAME F-Main /* Proveedor B */
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


&Scoped-define SELF-NAME INTEGRAL.Almmmatg.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.Almmmatg.Libre_c01 V-table-Win
ON LEAVE OF INTEGRAL.Almmmatg.Libre_c01 IN FRAME F-Main /* Subtipo */
DO:
  FIND almtabla WHERE almtabla.Tabla = "ST"
      AND almtabla.Codigo = self:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla THEN f-SubTipo:SCREEN-VALUE = almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.Almmmatg.Licencia[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.Almmmatg.Licencia[1] V-table-Win
ON LEAVE OF INTEGRAL.Almmmatg.Licencia[1] IN FRAME F-Main /* Licencia */
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


&Scoped-define SELF-NAME INTEGRAL.Almmmatg.subfam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.Almmmatg.subfam V-table-Win
ON LEAVE OF INTEGRAL.Almmmatg.subfam IN FRAME F-Main /* Sub-Familia */
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME INTEGRAL.Almmmatg.TpoArt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.Almmmatg.TpoArt V-table-Win
ON LEAVE OF INTEGRAL.Almmmatg.TpoArt IN FRAME F-Main /* Estado */
DO:

       IF Almmmatg.TpoArt:screen-value = "A" THEN 
          DISPLAY "Activado" @ F-destado WITH FRAME {&FRAME-NAME}.
     ELSE
          DISPLAY "Desactivado" @ F-destado WITH FRAME {&FRAME-NAME}.
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
  IF C-NUEVO = 'YES' OR (C-NUEVO = 'NO' AND C-DESMAT <> Almmmatg.DesMat) THEN DO:
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
  {src/adm/template/row-list.i "integral.Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.Almmmatg"}

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
         Almmmatg.usuario = S-USER-ID.
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
  FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = Almmmatg.codcia 
                            AND  Almacen.TdoArt:
      /* CONSISTENCIA POR PRODUCTO Y ALMACEN */
      IF Almmmatg.TpoMrg <> '' AND Almacen.Campo-c[2] <> '' THEN DO:
          IF Almmmatg.TpoMrg <> Almacen.Campo-c[2] THEN NEXT.
      END.
      /* *********************************** */
      IF C-ALM = "" THEN C-ALM = TRIM(Almacen.CodAlm).
      IF LOOKUP(TRIM(Almacen.CodAlm),C-ALM) = 0 THEN C-ALM = C-ALM + "," + TRIM(Almacen.CodAlm).
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

  /* RHC: CREAMOS EN OFIMAX POR AHORA 12.07.2005 */
/*   IF s-codcia = 001 /*AND TODAY <= DATE(09,30,2005)*/ */
/*   THEN DO:                                            */
/*     DEF BUFFER OFIMAX FOR Almmmatg.                   */
/*     FIND OFIMAX WHERE OFIMAX.codcia = 003             */
/*         AND OFIMAX.codmat = Almmmatg.codmat           */
/*         EXCLUSIVE-LOCK NO-ERROR.                      */
/*     IF NOT AVAILABLE OFIMAX THEN CREATE OFIMAX.       */
/*     BUFFER-COPY Almmmatg TO OFIMAX                    */
/*         ASSIGN OFIMAX.codcia = 003.                   */
/*   END.                                                */
  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  IF AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
      CASE Almmmatg.TpoArt:
          WHEN 'A' THEN DISPLAY "Activado" @ F-destado WITH FRAME {&FRAME-NAME}.
          WHEN 'B' THEN DISPLAY "Baja Rotacion" @ F-destado WITH FRAME {&FRAME-NAME}.
          OTHERWISE DISPLAY "Desactivado" @ F-destado WITH FRAME {&FRAME-NAME}.
      END CASE.
     FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
                    AND  Almtfami.codfam = Almmmatg.codfam 
                   NO-LOCK NO-ERROR.
     IF AVAILABLE Almtfami THEN
          DISPLAY Almtfami.desfam @ FILL-IN-DesFam WITH FRAME {&FRAME-NAME}.
     FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                    AND  AlmSFami.codfam = Almmmatg.codfam 
                    AND  AlmSFami.subfam = Almmmatg.subfam 
                   NO-LOCK NO-ERROR.
     IF AVAILABLE AlmSFami THEN 
        DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
     FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                   AND  gn-prov.CodPro = Almmmatg.CodPr1 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
          DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.
     FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                   AND  gn-prov.CodPro = Almmmatg.CodPr2 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
          DISPLAY gn-prov.NomPro @ FILL-IN-NomPro2 WITH FRAME {&FRAME-NAME}.
/*      x-DesMat-2:SCREEN-VALUE = ''.                                 */
/*      FIND matg WHERE matg.codcia = s-codcia                        */
/*        AND matg.codmat = almmmatg.CodAnt                           */
/*        NO-LOCK NO-ERROR.                                           */
/*      IF AVAILABLE matg THEN x-DesMat-2:SCREEN-VALUE = matg.desmat. */
     FIND Almtabla WHERE Almtabla.tabla = "ST"
         AND Almtabla.codig = Almmmatg.libre_c01
         NO-LOCK NO-ERROR.
     IF AVAILABLE Almtabla THEN DISPLAY almtabla.Nombre @  f-SubTipo.
  END.
  /* Code placed here will execute AFTER standard behavior.    */

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
              Almmmatg.UndA:SENSITIVE = NO
              Almmmatg.UndB:SENSITIVE = NO
              Almmmatg.UndC:SENSITIVE = NO.
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
  {src/adm/template/snd-list.i "integral.Almmmatg"}

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
      MESSAGE "Unidad no registrada ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almmmatg.UndBas.
      RETURN "ADM-ERROR".   
   END.
   FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas:SCREEN-VALUE AND
        Almtconv.Codalter = Almmmatg.UndStk:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE "Unidad no registrada ..." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almmmatg.UndStk.
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
            AND Almmmate.codmat = Almmmatg.codmat:SCREEN-VALUE,
            FIRST Almacen OF Almmmate NO-LOCK WHERE Almacen.AutMov = YES:
            IF Almmmate.stkact <> 0
            THEN DO:
                MESSAGE 'No puede desactivar un material que aún tiene stock en el almacen' almmmate.codalm
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
/*    IF almmmatg.CodAnt:SCREEN-VALUE <> '' THEN DO:                             */
/*        FIND matg WHERE matg.codcia = s-codcia                                 */
/*            AND matg.codmat = almmmatg.CodAnt:SCREEN-VALUE                     */
/*            NO-LOCK NO-ERROR.                                                  */
/*        IF NOT AVAILABLE matg THEN DO:                                         */
/*            MESSAGE 'El código relacionado NO existe' VIEW-AS ALERT-BOX ERROR. */
/*            APPLY 'entry':U TO almmmatg.CodAnt.                                */
/*            RETURN "ADM-ERROR".                                                */
/*        END.                                                                   */
/*    END.                                                                       */

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

IF Almmmatg.FchIng < (TODAY - 3)
THEN DO:
/*  RHC 19.11.04 
    RUN alm/d-clave ('PRODUCTOS', OUTPUT RPTA).
    /*IF RPTA = 'ERROR' THEN RETURN 'ADM-ERROR'.*/
    x-Acceso = YES.
    IF RPTA = 'ERROR' 
    THEN DO:
        MESSAGE 'Su acceso es limitado' VIEW-AS ALERT-BOX WARNING.
        x-Acceso = NO.
    END.
*/
    x-Acceso = NO.      /* Acceso limitado */
END.    
ELSE x-Acceso = YES.
/* SOLO PARA EL USUARIO ADMIN */
IF s-User-Id = 'ADMIN' OR s-User-Id BEGINS 'ARR' THEN x-Acceso = YES.

/*
    Modificado por  : Miguel Landeo
    Fecha           : 26/09/2007
    Objetivo        : Habilitación de campo Código de Barras
                      para el Sr. Roiny Chumpitaz por autorización
                      de la gerencia general.
*/
IF s-User-Id BEGINS 'RGCA' THEN x-Acceso = TRUE.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

