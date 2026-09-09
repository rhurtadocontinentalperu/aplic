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
DEFINE SHARED VAR pv-CODCIA AS INTEGER.
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
Almmmatg.Licencia[1] Almmmatg.CodMar Almmmatg.Chr__02 Almmmatg.codfam ~
Almmmatg.TpoPro Almmmatg.subfam Almmmatg.Chr__03 Almmmatg.AftIgv ~
Almmmatg.Detalle Almmmatg.AftIsc Almmmatg.PorIsc Almmmatg.CodBrr ~
Almmmatg.Dec__03 Almmmatg.UndBas Almmmatg.UndA Almmmatg.UndB Almmmatg.UndC ~
Almmmatg.CanEmp Almmmatg.UndCmp Almmmatg.Pesmat Almmmatg.Chr__01 ~
Almmmatg.UndStk Almmmatg.Libre_d02 Almmmatg.UndAlt[1] Almmmatg.CodPr1 ~
Almmmatg.usuario 
&Scoped-define ENABLED-TABLES Almmmatg
&Scoped-define FIRST-ENABLED-TABLE Almmmatg
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 RECT-4 RECT-7 RECT-12 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.TpoArt Almmmatg.Licencia[1] Almmmatg.TipArt ~
Almmmatg.CodMar Almmmatg.Chr__02 Almmmatg.codfam Almmmatg.TpoPro ~
Almmmatg.subfam Almmmatg.Chr__03 Almmmatg.AftIgv Almmmatg.Detalle ~
Almmmatg.AftIsc Almmmatg.PorIsc Almmmatg.CodBrr Almmmatg.Dec__03 ~
Almmmatg.UndBas Almmmatg.UndA Almmmatg.UndB Almmmatg.UndC Almmmatg.CanEmp ~
Almmmatg.UndCmp Almmmatg.Pesmat Almmmatg.Chr__01 Almmmatg.UndStk ~
Almmmatg.Libre_d02 Almmmatg.UndAlt[1] Almmmatg.CodPr1 Almmmatg.CodPr2 ~
Almmmatg.almacenes Almmmatg.usuario Almmmatg.FchAct 
&Scoped-define DISPLAYED-TABLES Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE Almmmatg
&Scoped-Define DISPLAYED-OBJECTS F-destado FILL-IN-DesFam F-DesSub ~
FILL-IN-NomPro1 FILL-IN-NomPro2 

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
     SIZE 11.14 BY .69
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

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

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.43 BY 6.35.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 19.86 BY 3.58.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 57.14 BY 3.54.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 6.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almmmatg.codmat AT ROW 1.15 COL 8.29 COLON-ALIGNED NO-LABEL FORMAT "X(6)"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .69
          BGCOLOR 15 FONT 0
     Almmmatg.DesMat AT ROW 1.19 COL 18.29 COLON-ALIGNED NO-LABEL FORMAT "X(45)"
          VIEW-AS FILL-IN 
          SIZE 45.72 BY .69
     F-destado AT ROW 1.19 COL 65 COLON-ALIGNED NO-LABEL
     Almmmatg.DesMar AT ROW 2.15 COL 15.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 27 BY .69
          FONT 0
     Almmmatg.TpoArt AT ROW 2.15 COL 50.29 COLON-ALIGNED
          LABEL "Estado"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .69
          BGCOLOR 15 
     Almmmatg.Licencia[1] AT ROW 2.15 COL 60.29 COLON-ALIGNED
          LABEL "Licencia" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .69
          BGCOLOR 15 
     Almmmatg.TipArt AT ROW 2.15 COL 73 COLON-ALIGNED
          LABEL "Rotacion"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .65
          BGCOLOR 15 
     Almmmatg.CodMar AT ROW 2.19 COL 8.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     FILL-IN-DesFam AT ROW 3.08 COL 15.14 COLON-ALIGNED NO-LABEL
     Almmmatg.Chr__02 AT ROW 3.08 COL 52.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Propio", "P":U,
"Tercero", "T":U
          SIZE 9 BY 1.12
     Almmmatg.codfam AT ROW 3.12 COL 8.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     Almmmatg.TpoPro AT ROW 3.15 COL 63.43 COLON-ALIGNED NO-LABEL
          VIEW-AS COMBO-BOX INNER-LINES 2
          LIST-ITEMS "Nacional","Importado" 
          DROP-DOWN-LIST
          SIZE 11 BY 1
     F-DesSub AT ROW 3.81 COL 15.14 COLON-ALIGNED NO-LABEL
     Almmmatg.subfam AT ROW 3.96 COL 8.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .69
          BGCOLOR 15 
     Almmmatg.Chr__03 AT ROW 4.08 COL 67 COLON-ALIGNED
          LABEL "IP" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     Almmmatg.AftIgv AT ROW 4.38 COL 52.57
          LABEL "Afecto a IGV"
          VIEW-AS TOGGLE-BOX
          SIZE 11.72 BY .69
     Almmmatg.Detalle AT ROW 4.81 COL 10.57 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 34.72 BY 1.92
     Almmmatg.AftIsc AT ROW 5 COL 52.57
          LABEL "Afecto a ISC"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .69
     Almmmatg.PorIsc AT ROW 5.04 COL 67 COLON-ALIGNED
          LABEL "%"
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .69
     Almmmatg.CodBrr AT ROW 6.15 COL 56.86 COLON-ALIGNED
          LABEL "Codigo de Barras" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .69
          BGCOLOR 15 FONT 0
     Almmmatg.Dec__03 AT ROW 7.35 COL 66.57 COLON-ALIGNED
          LABEL "Minimo de Venta" FORMAT ">>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
          BGCOLOR 15 FGCOLOR 12 
     Almmmatg.UndBas AT ROW 7.92 COL 11 COLON-ALIGNED FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     Almmmatg.UndA AT ROW 8.15 COL 32.86 COLON-ALIGNED
          LABEL "A" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.86 BY 16.12
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     Almmmatg.UndB AT ROW 8.15 COL 42.14 COLON-ALIGNED
          LABEL "B" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     Almmmatg.UndC AT ROW 8.15 COL 51.14 COLON-ALIGNED
          LABEL "C" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     Almmmatg.CanEmp AT ROW 8.15 COL 66.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
          BGCOLOR 15 
     Almmmatg.UndCmp AT ROW 8.62 COL 11 COLON-ALIGNED
          LABEL "U.M. Compra" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     Almmmatg.Pesmat AT ROW 8.81 COL 66.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
     Almmmatg.Chr__01 AT ROW 8.88 COL 32.86 COLON-ALIGNED
          LABEL "" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     Almmmatg.UndStk AT ROW 9.31 COL 11 COLON-ALIGNED
          LABEL "U.M. Stock" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .65
          BGCOLOR 15 
     Almmmatg.Libre_d02 AT ROW 9.58 COL 66.57 COLON-ALIGNED WIDGET-ID 6
          LABEL "Volum." FORMAT ">,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     Almmmatg.UndAlt[1] AT ROW 9.65 COL 32.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .65
     Almmmatg.CodPr1 AT ROW 10.77 COL 10.57 COLON-ALIGNED
          LABEL "Proveedor A"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
          BGCOLOR 15 
     FILL-IN-NomPro1 AT ROW 10.77 COL 21.57 COLON-ALIGNED NO-LABEL
     Almmmatg.CodPr2 AT ROW 11.54 COL 10.57 COLON-ALIGNED
          LABEL "Proveedor B"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
          BGCOLOR 15 
     FILL-IN-NomPro2 AT ROW 11.54 COL 21.57 COLON-ALIGNED NO-LABEL
     Almmmatg.almacenes AT ROW 12.31 COL 12.57 NO-LABEL
          VIEW-AS EDITOR
          SIZE 65 BY 3.31
          BGCOLOR 15 
     Almmmatg.usuario AT ROW 15.81 COL 11 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .69
          BGCOLOR 15 
     Almmmatg.FchAct AT ROW 15.81 COL 48 COLON-ALIGNED
          LABEL "Ultima Modificacion" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .81
          BGCOLOR 15 
     "Oficina" VIEW-AS TEXT
          SIZE 10.57 BY .69 AT ROW 8.81 COL 22.14
          FONT 1
     "Al por menor" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 9.65 COL 22
          FONT 1
     "Detalles" VIEW-AS TEXT
          SIZE 6.57 BY .5 AT ROW 4.96 COL 1.72
     "Artículo" VIEW-AS TEXT
          SIZE 7.72 BY .69 AT ROW 1.08 COL 1.43
          FONT 1
     "Almacenes:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 12.5 COL 4.57
     "Unidades Logística" VIEW-AS TEXT
          SIZE 18 BY .69 AT ROW 7.15 COL 1.86
          FONT 1
     "Mostrador" VIEW-AS TEXT
          SIZE 10.57 BY .69 AT ROW 7.92 COL 22
          FONT 1
     "Unidades Venta" VIEW-AS TEXT
          SIZE 16.14 BY .69 AT ROW 7.15 COL 22.29
          FONT 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.86 BY 16.12
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RECT-5 AT ROW 7.04 COL 1
     RECT-6 AT ROW 7.08 COL 21.43
     RECT-4 AT ROW 10.62 COL 1.14
     RECT-7 AT ROW 1 COL 1
     RECT-12 AT ROW 2.96 COL 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.86 BY 16.12
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
         HEIGHT             = 16.12
         WIDTH              = 79.86.
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
/* SETTINGS FOR EDITOR Almmmatg.almacenes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.Chr__01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Chr__03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.CodBrr IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almmmatg.CodPr1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.CodPr2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almmmatg.Dec__03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.DesMar IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-destado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.FchAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.Libre_d02 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Licencia[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.PorIsc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.TipArt IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almmmatg.TpoArt IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.UndA IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndAlt[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.UndB IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndBas IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN Almmmatg.UndC IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndCmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.UndStk IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.usuario IN FRAME F-Main
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


&Scoped-define SELF-NAME Almmmatg.CodPr2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.CodPr2 V-table-Win
ON LEAVE OF Almmmatg.CodPr2 IN FRAME F-Main /* Proveedor B */
DO:
  IF INPUT Almmmatg.CodPr2 = "" THEN RETURN.
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.TpoArt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.TpoArt V-table-Win
ON LEAVE OF Almmmatg.TpoArt IN FRAME F-Main /* Estado */
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

RUN lib/_port-name ("Barras", OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.

X-BARRA = STRING(SUBSTRING(Almmmatg.CodBrr,1,15),"x(15)").

OUTPUT TO PRINTER VALUE(s-port-name) .

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
      IF C-ALM = "" THEN C-ALM = TRIM(Almacen.CodAlm).
      IF LOOKUP(TRIM(Almacen.CodAlm),C-ALM) = 0 THEN C-ALM = C-ALM + "," + TRIM(Almacen.CodAlm).
  END.
  ASSIGN Almmmatg.almacenes = C-ALM
         Almmmatg.TipArt = Almmmatg.TipArt:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
              
  /* RHC 19.11.04 LOG del catalogo */
  IF x-TpoArt <> Almmmatg.TpoArt THEN x-TpoArt = '*'.
  RUN lib/logtabla ('almmmatg',
                    almmmatg.codmat + '|' + x-TpoArt,
                    'CATALOGO').

  /* RHC: CREAMOS EN OFIMAX POR AHORA 12.07.2005 */
  IF s-codcia = 001 /*AND TODAY <= DATE(09,30,2005)*/
  THEN DO:
    DEF BUFFER OFIMAX FOR Almmmatg.
    FIND OFIMAX WHERE OFIMAX.codcia = 003 
        AND OFIMAX.codmat = Almmmatg.codmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE OFIMAX THEN CREATE OFIMAX.
    BUFFER-COPY Almmmatg TO OFIMAX
        ASSIGN OFIMAX.codcia = 003.
  END.
  
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
  FIND Almdmov WHERE Almdmov.CodCia = S-CODCIA AND 
                     Almdmov.CodMat = Almmmatg.CodMat NO-LOCK NO-ERROR.
  IF AVAILABLE Almdmov THEN DO:
     MESSAGE "Material tiene movimientos" SKIP "No se puede eliminar" 
              VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".   
  END.
  FOR EACH Almmmate WHERE Almmmate.CodCia = S-CODCIA AND 
           Almmmate.CodMat = Almmmatg.CodMat:
        DELETE Almmmate.
  END.

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
     IF Almmmatg.TpoArt = "A" THEN 
          DISPLAY "Activado" @ F-destado WITH FRAME {&FRAME-NAME}.
     ELSE
          DISPLAY "Desactivado" @ F-destado WITH FRAME {&FRAME-NAME}.
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
     IF NOT AVAILABLE gn-prov THEN
        FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                      AND  gn-prov.CodPro = Almmmatg.CodPr1 
                     NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
          DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.
     FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                   AND  gn-prov.CodPro = Almmmatg.CodPr2 
                  NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-prov THEN
        FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                      AND  gn-prov.CodPro = Almmmatg.CodPr2 
                     NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
          DISPLAY gn-prov.NomPro @ FILL-IN-NomPro2 WITH FRAME {&FRAME-NAME}.
     /*DISPLAY Almmmatg.UndStk @ F-XUndM1
             "Peso Kg/" + Almmmatg.UndStk @ F-XUndM2 WITH FRAME {&FRAME-NAME}.*/
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
  IF RETURN-VALUE = 'NO' AND x-Acceso = NO
  THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        Almmmatg.UndBas:SENSITIVE = NO
        Almmmatg.UndCmp:SENSITIVE = NO
        Almmmatg.UndStk:SENSITIVE = NO
        Almmmatg.CodBrr:SENSITIVE = NO
        Almmmatg.DesMat:SENSITIVE = NO
        Almmmatg.UndA:SENSITIVE = NO
        Almmmatg.UndB:SENSITIVE = NO.
/*         Almmmatg.DesMat:SENSITIVE = NO.
 *     IF Almmmatg.Chr__01 <> '' THEN Almmmatg.Chr__01:SENSITIVE = NO.
 *     IF Almmmatg.UndA <> '' THEN Almmmatg.UndA:SENSITIVE = NO.
 *     IF Almmmatg.UndB <> '' THEN Almmmatg.UndB:SENSITIVE = NO.
 *     IF Almmmatg.UndC <> '' THEN Almmmatg.UndC:SENSITIVE = NO.*/
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
   IF Almmmatg.TpoArt:SCREEN-VALUE = 'D'
   THEN DO:
        /* Verificamos el stock */
        FOR EACH Almmmate WHERE Almmmate.codcia = s-codcia
                AND Almmmate.codmat = Almmmatg.codmat:SCREEN-VALUE
                NO-LOCK:
            IF Almmmate.stkact <> 0
            THEN DO:
                MESSAGE 'No puede desactivar un material que aún tiene stock en el almacen' almmmate.codalm
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO Almmmatg.tpoart.
                RETURN 'ADM-ERROR'.
            END.
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

