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

DEF SHARED VAR s-codfam AS CHAR.
DEF SHARED VAR s-Parametro AS CHAR.

DEF BUFFER b-almt1 FOR almmmat1.
DEF BUFFER b-almtgext FOR almmmatgext.
DEF BUFFER b-almtg FOR almmmatg.

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
&Scoped-define EXTERNAL-TABLES Almmmat1 Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Almmmat1


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmat1, Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almmmatg.CodBrr Almmmatg.Pesmat ~
Almmmatg.Largo Almmmatg.Alto Almmmatg.Ancho Almmmatg.Libre_d02 ~
Almmmat1.Barras[1] Almmmat1.Equival[1] Almmmat1.Barras[2] ~
Almmmat1.Equival[2] Almmmat1.Barras[3] Almmmat1.Equival[3] ~
Almmmat1.Barras[4] Almmmat1.Equival[4] 
&Scoped-define ENABLED-TABLES Almmmatg Almmmat1
&Scoped-define FIRST-ENABLED-TABLE Almmmatg
&Scoped-define SECOND-ENABLED-TABLE Almmmat1
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN_peso1 FILL-IN_largo1 ~
FILL-IN_alto1 FILL-IN_ancho1 FILL-IN_peso2 FILL-IN_largo2 FILL-IN_alto2 ~
FILL-IN_ancho2 FILL-IN_peso3 FILL-IN_largo3 FILL-IN_alto3 FILL-IN_ancho3 ~
FILL-IN_peso4 FILL-IN_largo4 FILL-IN_alto4 FILL-IN_ancho4 ~
FILL-IN-codartprov 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.CodBrr Almmmatg.Pesmat ~
Almmmatg.Largo Almmmatg.Alto Almmmatg.Ancho Almmmatg.Libre_d02 ~
Almmmat1.Barras[1] Almmmat1.Equival[1] Almmmat1.Barras[2] ~
Almmmat1.Equival[2] Almmmat1.Barras[3] Almmmat1.Equival[3] ~
Almmmat1.Barras[4] Almmmat1.Equival[4] 
&Scoped-define DISPLAYED-TABLES Almmmatg Almmmat1
&Scoped-define FIRST-DISPLAYED-TABLE Almmmatg
&Scoped-define SECOND-DISPLAYED-TABLE Almmmat1
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codean FILL-IN-codean-2 ~
FILL-IN-codean-3 FILL-IN-codean-4 FILL-IN-codean-5 FILL-IN-codean-6 ~
FILL-IN-codean-7 FILL-IN_peso1 FILL-IN_largo1 FILL-IN_alto1 FILL-IN_ancho1 ~
FILL-IN_volumen1 FILL-IN_peso2 FILL-IN_largo2 FILL-IN_alto2 FILL-IN_ancho2 ~
FILL-IN_volumen2 FILL-IN_peso3 FILL-IN_largo3 FILL-IN_alto3 FILL-IN_ancho3 ~
FILL-IN_volumen3 FILL-IN_peso4 FILL-IN_largo4 FILL-IN_alto4 FILL-IN_ancho4 ~
FILL-IN_volumen4 FILL-IN-codartprov 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCalcula-volumen V-table-Win 
FUNCTION fCalcula-volumen RETURNS DECIMAL
  ( INPUT pLargo AS DEC, INPUT pAlto AS DEC, INPUT pAncho AS DEC, INPUT pEquival AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-codartprov AS CHARACTER FORMAT "X(25)":U 
     LABEL "Codigo Articulo del Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-codean AS CHARACTER FORMAT "X(15)":U INITIAL "COD-EAN" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-codean-2 AS CHARACTER FORMAT "X(15)":U INITIAL "Equivalencia" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 10 NO-UNDO.

DEFINE VARIABLE FILL-IN-codean-3 AS CHARACTER FORMAT "X(15)":U INITIAL "Peso (Kgr)" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-codean-4 AS CHARACTER FORMAT "X(15)":U INITIAL "Largo (cm)" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-codean-5 AS CHARACTER FORMAT "X(15)":U INITIAL "Alto (cm)" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-codean-6 AS CHARACTER FORMAT "X(15)":U INITIAL "Ancho (cm)" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-codean-7 AS CHARACTER FORMAT "X(15)":U INITIAL "Vol (cm3)" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_alto1 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 7 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_alto2 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 12 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_alto3 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_alto4 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 9 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_alto5 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_ancho1 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 7 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ancho2 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 12 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ancho3 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_ancho4 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 9 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ancho5 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_largo1 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 7 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_largo2 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 12 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_largo3 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_largo4 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 9 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_largo5 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_peso1 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN_peso2 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 12 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_peso3 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_peso4 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 9 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_peso5 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_volumen1 AS DECIMAL FORMAT "->>,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 7 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_volumen2 AS DECIMAL FORMAT "->>,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 12 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_volumen3 AS DECIMAL FORMAT "->>,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_volumen4 AS DECIMAL FORMAT "->>,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 9 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_volumen5 AS DECIMAL FORMAT "->>,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .81
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98.86 BY 8.85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codean AT ROW 1.38 COL 8.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-codean-2 AT ROW 1.38 COL 23.86 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-codean-3 AT ROW 1.38 COL 38.14 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     FILL-IN-codean-4 AT ROW 1.38 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     FILL-IN-codean-5 AT ROW 1.38 COL 61.86 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     FILL-IN-codean-6 AT ROW 1.38 COL 72.72 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     FILL-IN-codean-7 AT ROW 1.38 COL 85.43 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     Almmmatg.CodBrr AT ROW 2.5 COL 8 COLON-ALIGNED WIDGET-ID 78
          LABEL "EAN 13" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
     Almmmatg.Pesmat AT ROW 2.54 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 84 FORMAT "->>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.Largo AT ROW 2.54 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 80 FORMAT "->>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.Alto AT ROW 2.54 COL 60.72 COLON-ALIGNED NO-LABEL WIDGET-ID 74 FORMAT "->>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.Ancho AT ROW 2.54 COL 72.57 COLON-ALIGNED NO-LABEL WIDGET-ID 76 FORMAT "->>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     Almmmatg.Libre_d02 AT ROW 2.54 COL 84.14 COLON-ALIGNED NO-LABEL WIDGET-ID 82 FORMAT "->>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .81
     Almmmat1.Barras[1] AT ROW 3.5 COL 8 COLON-ALIGNED
          LABEL "1.- Inner" FORMAT "X(14)"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
          BGCOLOR 7 FGCOLOR 15 
     Almmmat1.Equival[1] AT ROW 3.5 COL 24.43 COLON-ALIGNED NO-LABEL FORMAT "ZZZ,ZZ9.9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 7 FGCOLOR 15 
     FILL-IN_peso1 AT ROW 3.5 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     FILL-IN_largo1 AT ROW 3.5 COL 48.86 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN_alto1 AT ROW 3.5 COL 60.72 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN_ancho1 AT ROW 3.5 COL 72.43 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN_volumen1 AT ROW 3.5 COL 84.14 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     Almmmat1.Barras[2] AT ROW 4.35 COL 8 COLON-ALIGNED
          LABEL "2.- Inner1" FORMAT "X(14)"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
          BGCOLOR 12 FGCOLOR 14 
     Almmmat1.Equival[2] AT ROW 4.35 COL 24.43 COLON-ALIGNED NO-LABEL FORMAT "ZZZ,ZZ9.9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 12 FGCOLOR 14 
     FILL-IN_peso2 AT ROW 4.35 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     FILL-IN_largo2 AT ROW 4.35 COL 48.86 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN_alto2 AT ROW 4.35 COL 60.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN_ancho2 AT ROW 4.35 COL 72.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN_volumen2 AT ROW 4.35 COL 84.14 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     Almmmat1.Barras[3] AT ROW 5.19 COL 8 COLON-ALIGNED
          LABEL "3.- Master" FORMAT "X(14)"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
          BGCOLOR 11 FGCOLOR 4 
     Almmmat1.Equival[3] AT ROW 5.19 COL 24.43 COLON-ALIGNED NO-LABEL FORMAT "ZZZ,ZZ9.9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 4 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FILL-IN_peso3 AT ROW 5.19 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     FILL-IN_largo3 AT ROW 5.19 COL 48.86 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     FILL-IN_alto3 AT ROW 5.19 COL 60.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     FILL-IN_ancho3 AT ROW 5.19 COL 72.43 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN_volumen3 AT ROW 5.19 COL 84.14 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     Almmmat1.Barras[4] AT ROW 6.04 COL 8 COLON-ALIGNED WIDGET-ID 2
          LABEL "4.- Pallet" FORMAT "X(14)"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
          BGCOLOR 9 FGCOLOR 15 
     Almmmat1.Equival[4] AT ROW 6.04 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6 FORMAT "ZZZ,ZZ9.9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 9 FGCOLOR 15 
     FILL-IN_peso4 AT ROW 6.04 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     FILL-IN_largo4 AT ROW 6.04 COL 48.86 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     FILL-IN_alto4 AT ROW 6.04 COL 60.72 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN_ancho4 AT ROW 6.04 COL 72.43 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN_volumen4 AT ROW 6.04 COL 84.14 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     Almmmat1.Barras[5] AT ROW 6.88 COL 8 COLON-ALIGNED WIDGET-ID 4
          LABEL "5.- Otros" FORMAT "X(14)"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY .81
          BGCOLOR 14 FGCOLOR 0 
     Almmmat1.Equival[5] AT ROW 6.88 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8 FORMAT "ZZZ,ZZ9.9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 14 FGCOLOR 0 
     FILL-IN_peso5 AT ROW 6.88 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     FILL-IN_largo5 AT ROW 6.88 COL 48.86 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     FILL-IN_alto5 AT ROW 6.88 COL 60.72 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN_ancho5 AT ROW 6.88 COL 72.43 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     FILL-IN_volumen5 AT ROW 6.88 COL 84.14 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     FILL-IN-codartprov AT ROW 8.31 COL 30 COLON-ALIGNED WIDGET-ID 86
     RECT-1 AT ROW 1 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.Almmmat1,INTEGRAL.Almmmatg
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
         HEIGHT             = 9.08
         WIDTH              = 100.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.Alto IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Ancho IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Barras[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Barras[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Barras[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Barras[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Barras[5] IN FRAME F-Main
   NO-DISPLAY NO-ENABLE EXP-LABEL EXP-FORMAT                            */
ASSIGN 
       Almmmat1.Barras[5]:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.CodBrr IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Equival[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Equival[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Equival[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Equival[4] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmat1.Equival[5] IN FRAME F-Main
   NO-DISPLAY NO-ENABLE EXP-LABEL EXP-FORMAT                            */
ASSIGN 
       Almmmat1.Equival[5]:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-codean IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-codean-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-codean-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-codean-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-codean-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-codean-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-codean-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_alto5 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN_alto5:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_ancho5 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN_ancho5:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_largo5 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN_largo5:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_peso5 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN_peso5:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_volumen1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_volumen2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_volumen3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_volumen4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_volumen5 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN_volumen5:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.Largo IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Libre_d02 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.Pesmat IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME Almmmatg.Alto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.Alto V-table-Win
ON LEAVE OF Almmmatg.Alto IN FRAME F-Main /* Ancho */
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Largo no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO almmmatg.largo IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 1.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(almmmatg.largo:SCREEN-VALUE)).
        x-alto = x-valor.
        x-ancho = DECIMAL(TRIM(almmmatg.ancho:SCREEN-VALUE)).
        x-equival = 1.
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        almmmatg.libre_d02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        almmmatg.libre_d02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.Ancho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.Ancho V-table-Win
ON LEAVE OF Almmmatg.Ancho IN FRAME F-Main /* Ancho */
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Largo no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO almmmatg.largo IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 1.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(almmmatg.largo:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(almmmatg.alto:SCREEN-VALUE)).
        x-ancho = x-valor.
        x-equival = 1.
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        almmmatg.libre_d02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        almmmatg.libre_d02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmat1.Equival[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmat1.Equival[1] V-table-Win
ON LEAVE OF Almmmat1.Equival[1] IN FRAME F-Main /* Equivalencia[1] */
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 1.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo1:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto1:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho1:SCREEN-VALUE)).
        x-equival = x-valor.
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmat1.Equival[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmat1.Equival[2] V-table-Win
ON LEAVE OF Almmmat1.Equival[2] IN FRAME F-Main /* Equivalencia[2] */
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 2.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo2:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto2:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho2:SCREEN-VALUE)).
        x-equival = x-valor.
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmat1.Equival[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmat1.Equival[3] V-table-Win
ON LEAVE OF Almmmat1.Equival[3] IN FRAME F-Main /* Equivalencia[3] */
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 3.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo3:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto3:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho3:SCREEN-VALUE)).
        x-equival = x-valor.
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmat1.Equival[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmat1.Equival[4] V-table-Win
ON LEAVE OF Almmmat1.Equival[4] IN FRAME F-Main /* Equivalencia[4] */
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 4.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo4:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto4:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho4:SCREEN-VALUE)).
        x-equival = x-valor.
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmat1.Equival[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmat1.Equival[5] V-table-Win
ON LEAVE OF Almmmat1.Equival[5] IN FRAME F-Main /* Equivalencia[5] */
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 5.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo5:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto5:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho5:SCREEN-VALUE)).
        x-equival = x-valor.
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_alto1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_alto1 V-table-Win
ON LEAVE OF FILL-IN_alto1 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Alto no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_alto1 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 1.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo1:SCREEN-VALUE)).
        x-alto = x-valor.
        x-ancho = DECIMAL(TRIM(fill-in_ancho1:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[1]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_alto2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_alto2 V-table-Win
ON LEAVE OF FILL-IN_alto2 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Alto no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_alto2 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 2.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo2:SCREEN-VALUE)).
        x-alto = x-valor.
        x-ancho = DECIMAL(TRIM(fill-in_ancho2:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[2]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_alto3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_alto3 V-table-Win
ON LEAVE OF FILL-IN_alto3 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Alto no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_alto3 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 3.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo3:SCREEN-VALUE)).
        x-alto = x-valor.
        x-ancho = DECIMAL(TRIM(fill-in_ancho3:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[3]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_alto4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_alto4 V-table-Win
ON LEAVE OF FILL-IN_alto4 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Alto no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_alto4 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 4.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo4:SCREEN-VALUE)).
        x-alto = x-valor.
        x-ancho = DECIMAL(TRIM(fill-in_ancho4:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[4]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_alto5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_alto5 V-table-Win
ON LEAVE OF FILL-IN_alto5 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Alto no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_alto5 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 5.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo5:SCREEN-VALUE)).
        x-alto = x-valor.
        x-ancho = DECIMAL(TRIM(fill-in_ancho5:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[5]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ancho1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ancho1 V-table-Win
ON LEAVE OF FILL-IN_ancho1 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Ancho no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_ancho1 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 1.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo1:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto1:SCREEN-VALUE)).
        x-ancho = x-valor.
        x-equival = DECIMAL(TRIM(almmmat1.equival[1]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ancho2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ancho2 V-table-Win
ON LEAVE OF FILL-IN_ancho2 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Ancho no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_ancho2 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 2.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo2:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto2:SCREEN-VALUE)).
        x-ancho = x-valor.
        x-equival = DECIMAL(TRIM(almmmat1.equival[2]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ancho3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ancho3 V-table-Win
ON LEAVE OF FILL-IN_ancho3 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Ancho no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_ancho3 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 3.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo3:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto3:SCREEN-VALUE)).
        x-ancho = x-valor.
        x-equival = DECIMAL(TRIM(almmmat1.equival[3]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ancho4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ancho4 V-table-Win
ON LEAVE OF FILL-IN_ancho4 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Ancho no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_ancho4 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 4.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo4:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto4:SCREEN-VALUE)).
        x-ancho = x-valor.
        x-equival = DECIMAL(TRIM(almmmat1.equival[4]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ancho5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ancho5 V-table-Win
ON LEAVE OF FILL-IN_ancho5 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Ancho no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_ancho5 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 5.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = DECIMAL(TRIM(fill-in_largo5:SCREEN-VALUE)).
        x-alto = DECIMAL(TRIM(fill-in_alto5:SCREEN-VALUE)).
        x-ancho = x-valor.
        x-equival = DECIMAL(TRIM(almmmat1.equival[5]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_largo1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_largo1 V-table-Win
ON LEAVE OF FILL-IN_largo1 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Largo no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_largo1 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 1.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = x-valor.
        x-alto = DECIMAL(TRIM(fill-in_alto1:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho1:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[1]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_largo2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_largo2 V-table-Win
ON LEAVE OF FILL-IN_largo2 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El largo no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_largo2 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 2.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = x-valor.
        x-alto = DECIMAL(TRIM(fill-in_alto2:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho2:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[2]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_largo3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_largo3 V-table-Win
ON LEAVE OF FILL-IN_largo3 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El largo no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_largo3 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 3.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = x-valor.
        x-alto = DECIMAL(TRIM(fill-in_alto3:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho3:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[3]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_largo4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_largo4 V-table-Win
ON LEAVE OF FILL-IN_largo4 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El largo no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_largo4 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 4.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = x-valor.
        x-alto = DECIMAL(TRIM(fill-in_alto4:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho4:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[4]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_largo5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_largo5 V-table-Win
ON LEAVE OF FILL-IN_largo5 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El largo no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_largo5 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 5.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = x-valor.
        x-alto = DECIMAL(TRIM(fill-in_alto5:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(fill-in_ancho5:SCREEN-VALUE)).
        x-equival = DECIMAL(TRIM(almmmat1.equival[5]:SCREEN-VALUE)).
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        fill-in_volumen5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        fill-in_volumen5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_peso1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_peso1 V-table-Win
ON LEAVE OF FILL-IN_peso1 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "Peso no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_peso1 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_peso2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_peso2 V-table-Win
ON LEAVE OF FILL-IN_peso2 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "Peso no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_peso2 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_peso3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_peso3 V-table-Win
ON LEAVE OF FILL-IN_peso3 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "Peso no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_peso3 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_peso4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_peso4 V-table-Win
ON LEAVE OF FILL-IN_peso4 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "Peso no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_peso4 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_peso5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_peso5 V-table-Win
ON LEAVE OF FILL-IN_peso5 IN FRAME F-Main
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "Peso no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO fill-in_peso5 IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.Largo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.Largo V-table-Win
ON LEAVE OF Almmmatg.Largo IN FRAME F-Main /* Largo */
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "El Largo no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO almmmatg.largo IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-volumen AS DEC.
    DEFINE VAR x-pos AS INT INIT 1.

    DEFINE VAR x-largo AS DEC.
    DEFINE VAR x-alto AS DEC.
    DEFINE VAR x-ancho AS DEC.
    DEFINE VAR x-equival AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        x-largo = x-valor.
        x-alto = DECIMAL(TRIM(almmmatg.alto:SCREEN-VALUE)).
        x-ancho = DECIMAL(TRIM(almmmatg.ancho:SCREEN-VALUE)).
        x-equival = 1.
    END.
    
    x-volumen = fCalcula-volumen(INPUT x-largo, INPUT x-alto, 
                                    INPUT x-ancho, 
                                 INPUT x-equival).

    IF x-volumen >= 0 THEN DO:
        almmmatg.libre_d02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-volumen,"->>,>>>,>>9.9999").
    END.
    ELSE DO:
        almmmatg.libre_d02:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.0000".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.Pesmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.Pesmat V-table-Win
ON LEAVE OF Almmmatg.Pesmat IN FRAME F-Main /* Peso */
DO:
    DEFINE VAR x-valor AS DEC.

    x-valor = DECIMAL(TRIM(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF x-valor < 0 THEN DO:
        MESSAGE "Peso no debe ser negativo!!" VIEW-AS ALERT-BOX INFORMATION.
        APPLY 'entry':u TO almmmatg.pesmat IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
  
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
  {src/adm/template/row-list.i "Almmmat1"}
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almmmat1"}
  {src/adm/template/row-find.i "Almmmatg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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
  IF AVAILABLE Almmmat1 THEN RETURN 'ADM-ERROR'.
  CASE s-Parametro:
      WHEN '+' THEN DO:
          IF LOOKUP(Almmmatg.codfam, s-codfam) = 0 THEN DO:
              MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
      WHEN '-' THEN DO:
          IF LOOKUP(Almmmatg.codfam, s-codfam) > 0 THEN DO:
              MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
  END CASE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    Almmmat1.codcia = Almmmatg.codcia
    Almmmat1.codmat = Almmmatg.codmat.

  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN FILL-IN_peso1 FILL-IN_peso2 FILL-IN_peso3 FILL-IN_peso4 FILL-IN_peso5.
      ASSIGN FILL-IN_largo1 FILL-IN_largo2 FILL-IN_largo3 FILL-IN_largo4 FILL-IN_largo5.
      ASSIGN FILL-IN_alto1 FILL-IN_alto2 FILL-IN_alto3 FILL-IN_alto4 FILL-IN_alto5.
      ASSIGN FILL-IN_ancho1 FILL-IN_ancho2 FILL-IN_ancho3 FILL-IN_ancho4 FILL-IN_ancho5.
      ASSIGN FILL-IN_volumen1 FILL-IN_volumen2 FILL-IN_volumen3 FILL-IN_volumen4 FILL-IN_volumen5.
      ASSIGN FILL-IN-codartprov.
  END. 

  FIND FIRST AlmmmatgExt WHERE AlmmmatgExt.codcia = Almmmatg.codcia AND 
      AlmmmatgExt.codmat = Almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE AlmmmatgExt THEN DO:
      CREATE AlmmmatgExt.
      ASSIGN 
          AlmmmatgExt.codcia = Almmmatg.codcia
          AlmmmatgExt.codmat = Almmmatg.codmat NO-ERROR.
  END.
  ASSIGN AlmmmatgExt.codintpr1 = TRIM(FILL-IN-codartprov).

  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE "1.- " + ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX INFORMATION.
      APPLY 'ENTRY':U TO Almmmat1.Barras[1] IN FRAME {&FRAME-NAME}.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  DO k = 1 TO 4:
      /* 5: Otros, no esta contemplado en la tabla AlmmmtgExt */
      CASE k:
        WHEN 1 THEN DO:
            ASSIGN AlmmmatgExt.pesoinner = FILL-IN_peso1
                  AlmmmatgExt.largoinner = FILL-IN_largo1
                  AlmmmatgExt.altoinner = FILL-IN_alto1
                  AlmmmatgExt.anchoinner = FILL-IN_ancho1
                  AlmmmatgExt.volinner = FILL-IN_volumen1 NO-ERROR.
        END.
        WHEN 2 THEN DO:
            ASSIGN AlmmmatgExt.pesoinner2 = FILL-IN_peso2
                  AlmmmatgExt.largoinner2 = FILL-IN_largo2
                  AlmmmatgExt.altoinner2 = FILL-IN_alto2
                  AlmmmatgExt.anchoinner2 = FILL-IN_ancho2
                  AlmmmatgExt.volinner2 = FILL-IN_volumen2 NO-ERROR.

        END.
        WHEN 3 THEN DO:
            ASSIGN AlmmmatgExt.pesomaster = FILL-IN_peso3
                  AlmmmatgExt.largomaster = FILL-IN_largo3
                  AlmmmatgExt.altomaster = FILL-IN_alto3
                  AlmmmatgExt.anchomaster = FILL-IN_ancho3
                  AlmmmatgExt.volmaster = FILL-IN_volumen3 NO-ERROR.

        END.
        WHEN 4 THEN DO:
            ASSIGN AlmmmatgExt.pesopallet = FILL-IN_peso4
                  AlmmmatgExt.largopallet = FILL-IN_largo4
                  AlmmmatgExt.altopallet = FILL-IN_alto4
                  AlmmmatgExt.anchopallet = FILL-IN_ancho4
                  AlmmmatgExt.volpallet = FILL-IN_volumen4 NO-ERROR.

        END.
      END CASE.        
      IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE "2.- " + ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX INFORMATION.
          APPLY 'ENTRY':U TO Almmmat1.Barras[1] IN FRAME {&FRAME-NAME}.
          UNDO, RETURN 'ADM-ERROR'.
      END.        
  END.

  RELEASE AlmmmatgExt.

  DO k = 1 TO 5:
      RUN gn/verifica-ean-repetido ( 'EAN14',
                                     k,
                                     Almmmat1.codmat,
                                     Almmmat1.Barras[k],
                                     OUTPUT pError).
      IF pError > '' THEN DO:
          MESSAGE pError VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO Almmmat1.Barras[1] IN FRAME {&FRAME-NAME}.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

END PROCEDURE.

/*
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    Almmmat1.codcia = Almmmatg.codcia
    Almmmat1.codmat = Almmmatg.codmat.

  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN FILL-IN_peso1 FILL-IN_peso2 FILL-IN_peso3 FILL-IN_peso4 FILL-IN_peso5.
      ASSIGN FILL-IN_largo1 FILL-IN_largo2 FILL-IN_largo3 FILL-IN_largo4 FILL-IN_largo5.
      ASSIGN FILL-IN_alto1 FILL-IN_alto2 FILL-IN_alto3 FILL-IN_alto4 FILL-IN_alto5.
      ASSIGN FILL-IN_ancho1 FILL-IN_ancho2 FILL-IN_ancho3 FILL-IN_ancho4 FILL-IN_ancho5.
      ASSIGN FILL-IN_volumen1 FILL-IN_volumen2 FILL-IN_volumen3 FILL-IN_volumen4 FILL-IN_volumen5.
      ASSIGN FILL-IN-codartprov.
  END. 

  FIND FIRST AlmmmatgExt WHERE AlmmmatgExt.codcia = Almmmatg.codcia AND 
      AlmmmatgExt.codmat = Almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE AlmmmatgExt THEN DO:
      CREATE AlmmmatgExt.
      ASSIGN 
          AlmmmatgExt.codcia = Almmmatg.codcia
          AlmmmatgExt.codmat = Almmmatg.codmat NO-ERROR.
  END.
  ASSIGN AlmmmatgExt.codintpr1 = TRIM(FILL-IN-codartprov).

  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE "1.- " + ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX INFORMATION.
      APPLY 'ENTRY':U TO Almmmat1.Barras[1] IN FRAME {&FRAME-NAME}.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  DO k = 1 TO 4:
      /* 5: Otros, no esta contemplado en la tabla AlmmmtgExt */
      IF NOT (TRUE <> (Almmmat1.Barras[k] > "")) THEN DO:
        CASE k:
          WHEN 1 THEN DO:
              ASSIGN AlmmmatgExt.pesoinner = FILL-IN_peso1
                    AlmmmatgExt.largoinner = FILL-IN_largo1
                    AlmmmatgExt.altoinner = FILL-IN_alto1
                    AlmmmatgExt.anchoinner = FILL-IN_ancho1
                    AlmmmatgExt.volinner = FILL-IN_volumen1 NO-ERROR.
          END.
          WHEN 2 THEN DO:
              ASSIGN AlmmmatgExt.pesoinner2 = FILL-IN_peso2
                    AlmmmatgExt.largoinner2 = FILL-IN_largo2
                    AlmmmatgExt.altoinner2 = FILL-IN_alto2
                    AlmmmatgExt.anchoinner2 = FILL-IN_ancho2
                    AlmmmatgExt.volinner2 = FILL-IN_volumen2 NO-ERROR.

          END.
          WHEN 3 THEN DO:
              ASSIGN AlmmmatgExt.pesomaster = FILL-IN_peso3
                    AlmmmatgExt.largomaster = FILL-IN_largo3
                    AlmmmatgExt.altomaster = FILL-IN_alto3
                    AlmmmatgExt.anchomaster = FILL-IN_ancho3
                    AlmmmatgExt.volmaster = FILL-IN_volumen3 NO-ERROR.

          END.
          WHEN 4 THEN DO:
              ASSIGN AlmmmatgExt.pesopallet = FILL-IN_peso4
                    AlmmmatgExt.largopallet = FILL-IN_largo4
                    AlmmmatgExt.altopallet = FILL-IN_alto4
                    AlmmmatgExt.anchopallet = FILL-IN_ancho4
                    AlmmmatgExt.volpallet = FILL-IN_volumen4 NO-ERROR.

          END.
        END CASE.        
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE "2.- " + ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX INFORMATION.
            APPLY 'ENTRY':U TO Almmmat1.Barras[1] IN FRAME {&FRAME-NAME}.
            UNDO, RETURN 'ADM-ERROR'.
        END.        

      END.
  END.

  RELEASE AlmmmatgExt.

  DO k = 1 TO 5:
      RUN gn/verifica-ean-repetido ( 'EAN14',
                                     k,
                                     Almmmat1.codmat,
                                     Almmmat1.Barras[k],
                                     OUTPUT pError).
      IF pError > '' THEN DO:
          MESSAGE pError VIEW-AS ALERT-BOX ERROR.
          APPLY 'ENTRY':U TO Almmmat1.Barras[1] IN FRAME {&FRAME-NAME}.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

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
  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN_peso1:SCREEN-VALUE = "0.0000".
      FILL-IN_peso2:SCREEN-VALUE = "0.0000".
      FILL-IN_peso3:SCREEN-VALUE = "0.0000".
      FILL-IN_peso4:SCREEN-VALUE = "0.0000".
      FILL-IN_peso5:SCREEN-VALUE = "0.0000".
    
      FILL-IN_largo1:SCREEN-VALUE = "0.0000".
      FILL-IN_largo2:SCREEN-VALUE = "0.0000".
      FILL-IN_largo3:SCREEN-VALUE = "0.0000".
      FILL-IN_largo4:SCREEN-VALUE = "0.0000".
      FILL-IN_largo5:SCREEN-VALUE = "0.0000".
    
      FILL-IN_alto1:SCREEN-VALUE = "0.0000".
      FILL-IN_alto2:SCREEN-VALUE = "0.0000".
      FILL-IN_alto3:SCREEN-VALUE = "0.0000".
      FILL-IN_alto4:SCREEN-VALUE = "0.0000".
      FILL-IN_alto5:SCREEN-VALUE = "0.0000".
    
      FILL-IN_ancho1:SCREEN-VALUE = "0.0000".
      FILL-IN_ancho2:SCREEN-VALUE = "0.0000".
      FILL-IN_ancho3:SCREEN-VALUE = "0.0000".
      FILL-IN_ancho4:SCREEN-VALUE = "0.0000".
      FILL-IN_ancho5:SCREEN-VALUE = "0.0000".
    
      FILL-IN_volumen1:SCREEN-VALUE = "0.0000".
      FILL-IN_volumen2:SCREEN-VALUE = "0.0000".
      FILL-IN_volumen3:SCREEN-VALUE = "0.0000".
      FILL-IN_volumen4:SCREEN-VALUE = "0.0000".
      FILL-IN_volumen5:SCREEN-VALUE = "0.0000".
  END.

  FIND FIRST b-almtgext WHERE b-almtgext.codcia = almmmatg.codcia AND
                                b-almtgext.codmat = almmmatg.codmat NO-LOCK NO-ERROR.
  IF AVAILABLE b-almtgext THEN DO:
      DO WITH FRAME {&FRAME-NAME}:
          FILL-IN_peso1:SCREEN-VALUE = STRING(b-almtgext.pesoinner,"->>,>>>,>>9.9999").
          FILL-IN_peso2:SCREEN-VALUE = STRING(b-almtgext.pesoinner2,"->>,>>>,>>9.9999").
          FILL-IN_peso3:SCREEN-VALUE = STRING(b-almtgext.pesomaster,"->>,>>>,>>9.9999").
          FILL-IN_peso4:SCREEN-VALUE = STRING(b-almtgext.pesopallet,"->>,>>>,>>9.9999").
          FILL-IN_peso5:SCREEN-VALUE = "0.0000".
          
          FILL-IN_largo1:SCREEN-VALUE = STRING(b-almtgext.largoinner,"->>,>>>,>>9.9999").
          FILL-IN_largo2:SCREEN-VALUE = STRING(b-almtgext.largoinner2,"->>,>>>,>>9.9999").
          FILL-IN_largo3:SCREEN-VALUE = STRING(b-almtgext.largomaster,"->>,>>>,>>9.9999").
          FILL-IN_largo4:SCREEN-VALUE = STRING(b-almtgext.largopallet,"->>,>>>,>>9.9999").
          FILL-IN_largo5:SCREEN-VALUE = "0.0000".

          FILL-IN_alto1:SCREEN-VALUE = STRING(b-almtgext.altoinner,"->>,>>>,>>9.9999").
          FILL-IN_alto2:SCREEN-VALUE = STRING(b-almtgext.altoinner2,"->>,>>>,>>9.9999").
          FILL-IN_alto3:SCREEN-VALUE = STRING(b-almtgext.altomaster,"->>,>>>,>>9.9999").
          FILL-IN_alto4:SCREEN-VALUE = STRING(b-almtgext.altopallet,"->>,>>>,>>9.9999").
          FILL-IN_alto5:SCREEN-VALUE = "0.0000".

          FILL-IN_ancho1:SCREEN-VALUE = STRING(b-almtgext.anchoinner,"->>,>>>,>>9.9999").
          FILL-IN_ancho2:SCREEN-VALUE = STRING(b-almtgext.anchoinner2,"->>,>>>,>>9.9999").
          FILL-IN_ancho3:SCREEN-VALUE = STRING(b-almtgext.anchomaster,"->>,>>>,>>9.9999").
          FILL-IN_ancho4:SCREEN-VALUE = STRING(b-almtgext.anchopallet,"->>,>>>,>>9.9999").
          FILL-IN_ancho5:SCREEN-VALUE = "0.0000".

          FILL-IN_volumen1:SCREEN-VALUE = STRING(b-almtgext.volinner,"->>,>>>,>>9.9999").
          FILL-IN_volumen2:SCREEN-VALUE = STRING(b-almtgext.volinner2,"->>,>>>,>>9.9999").
          FILL-IN_volumen3:SCREEN-VALUE = STRING(b-almtgext.volmaster,"->>,>>>,>>9.9999").
          FILL-IN_volumen4:SCREEN-VALUE = STRING(b-almtgext.volpallet,"->>,>>>,>>9.9999").
          FILL-IN_volumen5:SCREEN-VALUE = "0.0000".

          fill-in-codartprov:SCREEN-VALUE = b-almtgext.codintpr1.
      END.
  END.

  DO WITH FRAME {&FRAME-NAME}:  
      DISABLE FILL-IN_peso1.
      DISABLE FILL-IN_peso2.
      DISABLE FILL-IN_peso3.
      DISABLE FILL-IN_peso4.
      DISABLE FILL-IN_peso5.
    
      DISABLE FILL-IN_largo1.
      DISABLE FILL-IN_largo2.
      DISABLE FILL-IN_largo3.
      DISABLE FILL-IN_largo4.
      DISABLE FILL-IN_largo5.
    
      DISABLE FILL-IN_alto1.
      DISABLE FILL-IN_alto2.
      DISABLE FILL-IN_alto3.
      DISABLE FILL-IN_alto4.
      DISABLE FILL-IN_alto5.
    
      DISABLE FILL-IN_ancho1.
      DISABLE FILL-IN_ancho2.
      DISABLE FILL-IN_ancho3.
      DISABLE FILL-IN_ancho4.
      DISABLE FILL-IN_ancho5.
    
      DISABLE FILL-IN_volumen1.
      DISABLE FILL-IN_volumen2.
      DISABLE FILL-IN_volumen3.
      DISABLE FILL-IN_volumen4.
      DISABLE FILL-IN_volumen5.

      DISABLE fill-in-codartprov.
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
  DO WITH FRAME {&FRAME-NAME}:
      ENABLE FILL-IN_peso1.
      ENABLE FILL-IN_peso2.
      ENABLE FILL-IN_peso3.
      ENABLE FILL-IN_peso4.
      /*ENABLE FILL-IN_peso5.*/
    
      ENABLE FILL-IN_largo1.
      ENABLE FILL-IN_largo2.
      ENABLE FILL-IN_largo3.
      ENABLE FILL-IN_largo4.
      /*ENABLE FILL-IN_largo5.*/
    
      ENABLE FILL-IN_alto1.
      ENABLE FILL-IN_alto2.
      ENABLE FILL-IN_alto3.
      ENABLE FILL-IN_alto4.
      /*ENABLE FILL-IN_alto5.*/
    
      ENABLE FILL-IN_ancho1.
      ENABLE FILL-IN_ancho2.
      ENABLE FILL-IN_ancho3.
      ENABLE FILL-IN_ancho4.
      /*ENABLE FILL-IN_ancho5.*/
    
      ENABLE FILL-IN_volumen1.
      ENABLE FILL-IN_volumen2.
      ENABLE FILL-IN_volumen3.
      ENABLE FILL-IN_volumen4.
      /*ENABLE FILL-IN_volumen5.*/

      ENABLE fill-in-codartprov.
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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "Almmmat1"}
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
DEF VAR k AS INT.

/*
    Ic - 19May2017, Martin Salcedo, el codigo EAN14 debe ser de 13 digitos para arriba
    Ic - 13Jun2017, Martin Salcedo, el codigo EAN14 debe ser 14 Digitos o 12 UPC
    Ic - 22Jun2017, Martin Salcedo, el codigo EAN14 tambien debe tener 13 digitos
*/

DEFINE VAR lMinLenCodEan AS INT.
DEFINE VAR lMinLenCodEan13 AS INT.
DEFINE VAR lMinLenCodUPC AS INT.

DEFINE VAR lCodBarras AS CHAR EXTENT 10.
DEF VAR k1 AS INT.
DEFINE VAR lCodEan13 AS CHAR.

lMinLenCodEan13 = 13.
lMinLenCodEan = 14.
lMinLenCodUPC = 12.

DO WITH FRAME {&FRAME-NAME}:

    lCodEan13 = TRIM(almmmatg.codbrr:SCREEN-VALUE).
    lCodBarras[1] = TRIM(Almmmat1.Barras[1]:SCREEN-VALUE).
    lCodBarras[2] = TRIM(Almmmat1.Barras[2]:SCREEN-VALUE).
    lCodBarras[3] = TRIM(Almmmat1.Barras[3]:SCREEN-VALUE).
    lCodBarras[4] = TRIM(Almmmat1.Barras[4]:SCREEN-VALUE).
    lCodBarras[5] = TRIM(Almmmat1.Barras[5]:SCREEN-VALUE).

    IF lCodEan13 <> '' AND 
              (LENGTH (lCodEan13) < lMinLenCodUPC OR 
              LENGTH (lCodEan13) > lMinLenCodEan) THEN DO:
        MESSAGE 'El código EAN13 debe tener 12,13 ó 14 caracteres' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Barras[1].
        RETURN "ADM-ERROR".
    END.

    IF Almmmat1.Barras[1]:SCREEN-VALUE <> '' AND 
              (LENGTH (Almmmat1.Barras[1]:SCREEN-VALUE) < lMinLenCodUPC OR 
              LENGTH (Almmmat1.Barras[1]:SCREEN-VALUE) > lMinLenCodEan) THEN DO:
        MESSAGE 'El código EAN14-1 debe tener 12,13 ó 14 caracteres' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Barras[1].
        RETURN "ADM-ERROR".
    END.
    IF Almmmat1.Barras[2]:SCREEN-VALUE <> '' AND 
        (LENGTH (Almmmat1.Barras[2]:SCREEN-VALUE) < lMinLenCodUPC OR 
        LENGTH (Almmmat1.Barras[2]:SCREEN-VALUE) > lMinLenCodEan) THEN DO:
        MESSAGE 'El código EAN14-2 debe tener 12,13 ó 14 caracteres' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Barras[2].
        RETURN "ADM-ERROR".
    END.
    IF Almmmat1.Barras[3]:SCREEN-VALUE <> '' AND 
        (LENGTH (Almmmat1.Barras[3]:SCREEN-VALUE) < lMinLenCodUPC OR 
        LENGTH (Almmmat1.Barras[3]:SCREEN-VALUE) > lMinLenCodEan) THEN DO:

        MESSAGE 'El código EAN14-3 debe tener 12,13 ó 14 caracteres' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Barras[3].
        RETURN "ADM-ERROR".
    END.
    IF Almmmat1.Barras[4]:SCREEN-VALUE <> '' AND 
        (LENGTH (Almmmat1.Barras[4]:SCREEN-VALUE) < lMinLenCodUPC OR 
        LENGTH (Almmmat1.Barras[4]:SCREEN-VALUE) > lMinLenCodEan) THEN DO:

        MESSAGE 'El código EAN14-4 debe tener 12,13 ó 14 caracteres' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Barras[4].
        RETURN "ADM-ERROR".
    END.
    IF Almmmat1.Barras[5]:SCREEN-VALUE <> '' AND 
        (LENGTH (Almmmat1.Barras[5]:SCREEN-VALUE) < lMinLenCodUPC OR 
        LENGTH (Almmmat1.Barras[5]:SCREEN-VALUE) > lMinLenCodEan) THEN DO:

        MESSAGE 'El código EAN14-5 debe tener 12,13 ó 14 caracteres' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Barras[5].
        RETURN "ADM-ERROR".
    END.

    IF Almmmat1.Barras[1]:SCREEN-VALUE <> '' AND ( DECIMAL(Almmmat1.Equival[1]:SCREEN-VALUE) = 0
        /*OR DECIMAL(Almmmat1.Equival[1]:SCREEN-VALUE) = 1*/ )THEN DO:
        MESSAGE 'El factor de equivalencia no puede ser 0' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Equival[1].
        RETURN "ADM-ERROR".
    END.
    IF Almmmat1.Barras[2]:SCREEN-VALUE <> '' AND ( DECIMAL(Almmmat1.Equival[2]:SCREEN-VALUE) = 0
        /*OR DECIMAL(Almmmat1.Equival[2]:SCREEN-VALUE) = 1*/ )THEN DO:
        MESSAGE 'El factor de equivalencia no puede ser 0' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Equival[2].
        RETURN "ADM-ERROR".
    END.
    IF Almmmat1.Barras[3]:SCREEN-VALUE <> '' AND ( DECIMAL(Almmmat1.Equival[3]:SCREEN-VALUE) = 0
        /*OR DECIMAL(Almmmat1.Equival[3]:SCREEN-VALUE) = 1*/ )THEN DO:
        MESSAGE 'El factor de equivalencia no puede ser 0' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Equival[3].
        RETURN "ADM-ERROR".
    END.
    IF Almmmat1.Barras[4]:SCREEN-VALUE <> '' AND ( DECIMAL(Almmmat1.Equival[4]:SCREEN-VALUE) ) = 0
        THEN DO:
        MESSAGE 'El factor de equivalencia no puede ser 0' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Equival[4].
        RETURN "ADM-ERROR".
    END.
    IF Almmmat1.Barras[5]:SCREEN-VALUE <> '' AND ( DECIMAL(Almmmat1.Equival[5]:SCREEN-VALUE) ) = 0
        THEN DO:
        MESSAGE 'El factor de equivalencia no puede ser 0' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO Almmmat1.Equival[5].
        RETURN "ADM-ERROR".
    END.
    
/*     IF Almmmat1.Barras[1]:SCREEN-VALUE <> "" THEN DO:                                      */
/*         DO k = 1 TO 5:                                                                     */
/*             FIND FIRST b-almt1 WHERE b-almt1.CodCia = Almmmatg.CodCia                      */
/*                 AND b-almt1.CodMat <> Almmmatg.CodMat                                      */
/*                 AND b-almt1.Barras[k] = Almmmat1.Barras[1]:SCREEN-VALUE NO-LOCK NO-ERROR.  */
/*             IF AVAILABLE b-almt1 THEN DO:                                                  */
/*                 MESSAGE 'El código ingresado ya esta asignado al artículo ' b-almt1.CodMat */
/*                     VIEW-AS ALERT-BOX ERROR.                                               */
/*                 APPLY 'entry':U TO Almmmat1.Barras[1].                                     */
/*                 RETURN "ADM-ERROR".                                                        */
/*             END.                                                                           */
/*         END.                                                                               */
/*     END.                                                                                   */
/*                                                                                            */
/*     IF Almmmat1.Barras[2]:SCREEN-VALUE <> "" THEN DO:                                      */
/*         DO k = 1 TO 5:                                                                     */
/*             FIND FIRST b-almt1 WHERE b-almt1.CodCia = Almmmatg.CodCia                      */
/*                 AND b-almt1.CodMat <> Almmmatg.CodMat                                      */
/*                 AND b-almt1.Barras[k] = Almmmat1.Barras[2]:SCREEN-VALUE NO-LOCK NO-ERROR.  */
/*             IF AVAILABLE b-almt1 THEN DO:                                                  */
/*                 MESSAGE 'El código ingresado ya esta asignado al artículo ' b-almt1.CodMat */
/*                     VIEW-AS ALERT-BOX ERROR.                                               */
/*                 APPLY 'entry':U TO Almmmat1.Barras[2].                                     */
/*                 RETURN "ADM-ERROR".                                                        */
/*             END.                                                                           */
/*         END.                                                                               */
/*     END.                                                                                   */
/*                                                                                            */
/*     IF Almmmat1.Barras[3]:SCREEN-VALUE <> "" THEN DO:                                      */
/*         DO k = 1 TO 5:                                                                     */
/*             FIND FIRST b-almt1 WHERE b-almt1.CodCia = Almmmatg.CodCia                      */
/*                 AND b-almt1.CodMat <> Almmmatg.CodMat                                      */
/*                 AND b-almt1.Barras[k] = Almmmat1.Barras[3]:SCREEN-VALUE NO-LOCK NO-ERROR.  */
/*             IF AVAILABLE b-almt1 THEN DO:                                                  */
/*                 MESSAGE 'El código ingresado ya esta asignado al artículo ' b-almt1.CodMat */
/*                     VIEW-AS ALERT-BOX ERROR.                                               */
/*                 APPLY 'entry':U TO Almmmat1.Barras[3].                                     */
/*                 RETURN "ADM-ERROR".                                                        */
/*             END.                                                                           */
/*         END.                                                                               */
/*     END.                                                                                   */
/*                                                                                            */
/*     IF Almmmat1.Barras[4]:SCREEN-VALUE <> "" THEN DO:                                      */
/*         DO k = 1 TO 5:                                                                     */
/*             FIND FIRST b-almt1 WHERE b-almt1.CodCia = Almmmatg.CodCia                      */
/*                 AND b-almt1.CodMat <> Almmmatg.CodMat                                      */
/*                 AND b-almt1.Barras[k] = Almmmat1.Barras[4]:SCREEN-VALUE NO-LOCK NO-ERROR.  */
/*             IF AVAILABLE b-almt1 THEN DO:                                                  */
/*                 MESSAGE 'El código ingresado ya esta asignado al artículo ' b-almt1.CodMat */
/*                     VIEW-AS ALERT-BOX ERROR.                                               */
/*                 APPLY 'entry':U TO Almmmat1.Barras[4].                                     */
/*                 RETURN "ADM-ERROR".                                                        */
/*             END.                                                                           */
/*         END.                                                                               */
/*     END.                                                                                   */
/*                                                                                            */
/*     IF Almmmat1.Barras[5]:SCREEN-VALUE <> "" THEN DO:                                      */
/*         DO k = 1 TO 5:                                                                     */
/*             FIND FIRST b-almt1 WHERE b-almt1.CodCia = Almmmatg.CodCia                      */
/*                 AND b-almt1.CodMat <> Almmmatg.CodMat                                      */
/*                 AND b-almt1.Barras[k] = Almmmat1.Barras[5]:SCREEN-VALUE NO-LOCK NO-ERROR.  */
/*             IF AVAILABLE b-almt1 THEN DO:                                                  */
/*                 MESSAGE 'El código ingresado ya esta asignado al artículo ' b-almt1.CodMat */
/*                     VIEW-AS ALERT-BOX ERROR.                                               */
/*                 APPLY 'entry':U TO Almmmat1.Barras[5].                                     */
/*                 RETURN "ADM-ERROR".                                                        */
/*             END.                                                                           */
/*         END.                                                                               */
/*     END.                                                                                   */

    /* 
        Ic - 19May2017, validar que no repitan el CODIGO EAN en el mismo articulo
        Ademas que el EAN13 no se parte de los EAN14
    */

    DO k1 = 1 TO 5:
        IF lCodBarras[k1] <> "" THEN DO:
            IF lCodEan13 <> lCodBarras[k1] THEN DO:
                DO k = 1 TO 5:
                    IF lCodBarras[k] <> "" THEN DO:
                        IF k1 <> k THEN DO:
                            IF lCodBarras[k] = lCodBarras[k1]  THEN DO:
                                MESSAGE 'El código EAN ' + lCodBarras[k1] + ' no debe repetirse en el mismo Articulo'
                                    VIEW-AS ALERT-BOX ERROR.
                                APPLY 'entry':U TO Almmmat1.Barras[1].
                                RETURN "ADM-ERROR".
                            END.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                MESSAGE 'El código EAN ' + lCodBarras[k1] + ' Es el codigo EAN13 del articulo'
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'entry':U TO Almmmat1.Barras[1].
                RETURN "ADM-ERROR".
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
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE Almmmat1 THEN DO:
    MESSAGE 'NO hay registros a modificar' SKIP
        'Primero debe ADICIONAR un registro'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.
  CASE s-Parametro:
      WHEN '+' THEN DO:
          IF LOOKUP(Almmmatg.codfam, s-codfam) = 0 THEN DO:
              MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
      WHEN '-' THEN DO:
          IF LOOKUP(Almmmatg.codfam, s-codfam) > 0 THEN DO:
              MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
  END CASE.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCalcula-volumen V-table-Win 
FUNCTION fCalcula-volumen RETURNS DECIMAL
  ( INPUT pLargo AS DEC, INPUT pAlto AS DEC, INPUT pAncho AS DEC, INPUT pEquival AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS DEC INIT 0.

    IF pEquival > 0 THEN x-retval = (pLargo * pAlto * pAncho) / pEquival.

    RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

