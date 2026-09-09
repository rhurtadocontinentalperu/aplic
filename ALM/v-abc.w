&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES INTEGRAL.AlmCfg
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.AlmCfg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.AlmCfg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.AlmCfg.UtilPes ~
INTEGRAL.AlmCfg.UtilFecI INTEGRAL.AlmCfg.UtilfecF INTEGRAL.AlmCfg.VentPes ~
INTEGRAL.AlmCfg.VentFecI INTEGRAL.AlmCfg.VentFecF INTEGRAL.AlmCfg.CrecPes ~
INTEGRAL.AlmCfg.CrecFecI[1] INTEGRAL.AlmCfg.CrecFecF[1] ~
INTEGRAL.AlmCfg.CrecFecI[2] INTEGRAL.AlmCfg.CrecFecF[2] ~
INTEGRAL.AlmCfg.CateA INTEGRAL.AlmCfg.CateB INTEGRAL.AlmCfg.CateC ~
INTEGRAL.AlmCfg.CateD INTEGRAL.AlmCfg.CateE INTEGRAL.AlmCfg.CateF ~
INTEGRAL.AlmCfg.Factor-A[1] INTEGRAL.AlmCfg.Factor-B[1] ~
INTEGRAL.AlmCfg.Factor-C[1] INTEGRAL.AlmCfg.Factor-D[1] ~
INTEGRAL.AlmCfg.Factor-E[1] INTEGRAL.AlmCfg.Factor-F[1] ~
INTEGRAL.AlmCfg.Factor-A[2] INTEGRAL.AlmCfg.Factor-B[2] ~
INTEGRAL.AlmCfg.Factor-C[2] INTEGRAL.AlmCfg.Factor-D[2] ~
INTEGRAL.AlmCfg.Factor-E[2] INTEGRAL.AlmCfg.Factor-F[2] ~
INTEGRAL.AlmCfg.Factor-A[3] INTEGRAL.AlmCfg.Factor-B[3] ~
INTEGRAL.AlmCfg.Factor-C[3] INTEGRAL.AlmCfg.Factor-D[3] ~
INTEGRAL.AlmCfg.Factor-E[3] INTEGRAL.AlmCfg.Factor-F[3] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}UtilPes ~{&FP2}UtilPes ~{&FP3}~
 ~{&FP1}UtilFecI ~{&FP2}UtilFecI ~{&FP3}~
 ~{&FP1}UtilfecF ~{&FP2}UtilfecF ~{&FP3}~
 ~{&FP1}VentPes ~{&FP2}VentPes ~{&FP3}~
 ~{&FP1}VentFecI ~{&FP2}VentFecI ~{&FP3}~
 ~{&FP1}VentFecF ~{&FP2}VentFecF ~{&FP3}~
 ~{&FP1}CrecPes ~{&FP2}CrecPes ~{&FP3}~
 ~{&FP1}CrecFecI[1] ~{&FP2}CrecFecI[1] ~{&FP3}~
 ~{&FP1}CrecFecF[1] ~{&FP2}CrecFecF[1] ~{&FP3}~
 ~{&FP1}CrecFecI[2] ~{&FP2}CrecFecI[2] ~{&FP3}~
 ~{&FP1}CrecFecF[2] ~{&FP2}CrecFecF[2] ~{&FP3}~
 ~{&FP1}CateA ~{&FP2}CateA ~{&FP3}~
 ~{&FP1}CateB ~{&FP2}CateB ~{&FP3}~
 ~{&FP1}CateC ~{&FP2}CateC ~{&FP3}~
 ~{&FP1}CateD ~{&FP2}CateD ~{&FP3}~
 ~{&FP1}CateE ~{&FP2}CateE ~{&FP3}~
 ~{&FP1}CateF ~{&FP2}CateF ~{&FP3}~
 ~{&FP1}Factor-A[1] ~{&FP2}Factor-A[1] ~{&FP3}~
 ~{&FP1}Factor-B[1] ~{&FP2}Factor-B[1] ~{&FP3}~
 ~{&FP1}Factor-C[1] ~{&FP2}Factor-C[1] ~{&FP3}~
 ~{&FP1}Factor-D[1] ~{&FP2}Factor-D[1] ~{&FP3}~
 ~{&FP1}Factor-E[1] ~{&FP2}Factor-E[1] ~{&FP3}~
 ~{&FP1}Factor-F[1] ~{&FP2}Factor-F[1] ~{&FP3}~
 ~{&FP1}Factor-A[2] ~{&FP2}Factor-A[2] ~{&FP3}~
 ~{&FP1}Factor-B[2] ~{&FP2}Factor-B[2] ~{&FP3}~
 ~{&FP1}Factor-C[2] ~{&FP2}Factor-C[2] ~{&FP3}~
 ~{&FP1}Factor-D[2] ~{&FP2}Factor-D[2] ~{&FP3}~
 ~{&FP1}Factor-E[2] ~{&FP2}Factor-E[2] ~{&FP3}~
 ~{&FP1}Factor-F[2] ~{&FP2}Factor-F[2] ~{&FP3}~
 ~{&FP1}Factor-A[3] ~{&FP2}Factor-A[3] ~{&FP3}~
 ~{&FP1}Factor-B[3] ~{&FP2}Factor-B[3] ~{&FP3}~
 ~{&FP1}Factor-C[3] ~{&FP2}Factor-C[3] ~{&FP3}~
 ~{&FP1}Factor-D[3] ~{&FP2}Factor-D[3] ~{&FP3}~
 ~{&FP1}Factor-E[3] ~{&FP2}Factor-E[3] ~{&FP3}~
 ~{&FP1}Factor-F[3] ~{&FP2}Factor-F[3] ~{&FP3}
&Scoped-define ENABLED-TABLES INTEGRAL.AlmCfg
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.AlmCfg
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-11 RECT-12 RECT-19 RECT-20 ~
RECT-21 RECT-9 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.AlmCfg.UtilPes ~
INTEGRAL.AlmCfg.UtilFecI INTEGRAL.AlmCfg.UtilfecF INTEGRAL.AlmCfg.VentPes ~
INTEGRAL.AlmCfg.VentFecI INTEGRAL.AlmCfg.VentFecF INTEGRAL.AlmCfg.CrecPes ~
INTEGRAL.AlmCfg.CrecFecI[1] INTEGRAL.AlmCfg.CrecFecF[1] ~
INTEGRAL.AlmCfg.CrecFecI[2] INTEGRAL.AlmCfg.CrecFecF[2] ~
INTEGRAL.AlmCfg.CateA INTEGRAL.AlmCfg.CateB INTEGRAL.AlmCfg.CateC ~
INTEGRAL.AlmCfg.CateD INTEGRAL.AlmCfg.CateE INTEGRAL.AlmCfg.CateF ~
INTEGRAL.AlmCfg.Factor-A[1] INTEGRAL.AlmCfg.Factor-B[1] ~
INTEGRAL.AlmCfg.Factor-C[1] INTEGRAL.AlmCfg.Factor-D[1] ~
INTEGRAL.AlmCfg.Factor-E[1] INTEGRAL.AlmCfg.Factor-F[1] ~
INTEGRAL.AlmCfg.Factor-A[2] INTEGRAL.AlmCfg.Factor-B[2] ~
INTEGRAL.AlmCfg.Factor-C[2] INTEGRAL.AlmCfg.Factor-D[2] ~
INTEGRAL.AlmCfg.Factor-E[2] INTEGRAL.AlmCfg.Factor-F[2] ~
INTEGRAL.AlmCfg.Factor-A[3] INTEGRAL.AlmCfg.Factor-B[3] ~
INTEGRAL.AlmCfg.Factor-C[3] INTEGRAL.AlmCfg.Factor-D[3] ~
INTEGRAL.AlmCfg.Factor-E[3] INTEGRAL.AlmCfg.Factor-F[3] 

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
DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 1.15.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 1.92.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 67 BY 1.73
     BGCOLOR 1 FGCOLOR 15 .

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 67 BY 1.35
     BGCOLOR 1 FGCOLOR 15 .

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 21 BY 4.81.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 67 BY 2.69.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 1.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.AlmCfg.UtilPes AT ROW 3.5 COL 9 COLON-ALIGNED
          LABEL "Utilidad"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.AlmCfg.UtilFecI AT ROW 3.5 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.AlmCfg.UtilfecF AT ROW 3.5 COL 34 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.AlmCfg.VentPes AT ROW 4.65 COL 9 COLON-ALIGNED
          LABEL "Ventas"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.AlmCfg.VentFecI AT ROW 4.65 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.AlmCfg.VentFecF AT ROW 4.65 COL 34 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.AlmCfg.CrecPes AT ROW 5.81 COL 9 COLON-ALIGNED
          LABEL "Crecimiento"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.AlmCfg.CrecFecI[1] AT ROW 5.81 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.AlmCfg.CrecFecF[1] AT ROW 5.81 COL 34 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.AlmCfg.CrecFecI[2] AT ROW 6.58 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.AlmCfg.CrecFecF[2] AT ROW 6.58 COL 34 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     INTEGRAL.AlmCfg.CateA AT ROW 2.73 COL 55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.AlmCfg.CateB AT ROW 3.54 COL 55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.AlmCfg.CateC AT ROW 4.35 COL 55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.AlmCfg.CateD AT ROW 5.04 COL 55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.AlmCfg.CateE AT ROW 5.85 COL 55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.AlmCfg.CateF AT ROW 6.65 COL 55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.AlmCfg.Factor-A[1] AT ROW 9.08 COL 11 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-B[1] AT ROW 9.08 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-C[1] AT ROW 9.08 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-D[1] AT ROW 9.08 COL 38 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-E[1] AT ROW 9.08 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-F[1] AT ROW 9.08 COL 56 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-A[2] AT ROW 9.85 COL 11 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-B[2] AT ROW 9.85 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-C[2] AT ROW 9.85 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     INTEGRAL.AlmCfg.Factor-D[2] AT ROW 9.85 COL 38 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-E[2] AT ROW 9.85 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-F[2] AT ROW 9.85 COL 56 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-A[3] AT ROW 10.62 COL 11 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-B[3] AT ROW 10.62 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-C[3] AT ROW 10.62 COL 29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-D[3] AT ROW 10.62 COL 38 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-E[3] AT ROW 10.62 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     INTEGRAL.AlmCfg.Factor-F[3] AT ROW 10.62 COL 56 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     RECT-10 AT ROW 4.46 COL 1
     RECT-11 AT ROW 5.62 COL 1
     RECT-12 AT ROW 1 COL 1
     RECT-19 AT ROW 7.54 COL 1
     RECT-20 AT ROW 2.73 COL 47
     RECT-21 AT ROW 8.88 COL 1
     RECT-9 AT ROW 2.73 COL 1
     "Rubro" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 1.96 COL 3
          BGCOLOR 1 FGCOLOR 15 
     "E" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.08 COL 48
     "D" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.23 COL 48
     "A" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.92 COL 48
     "Peso en %" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.96 COL 11
          BGCOLOR 1 FGCOLOR 15 
     "C" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.46 COL 48
     "E" VIEW-AS TEXT
          SIZE 2 BY .5 AT ROW 8.31 COL 50
          BGCOLOR 1 FGCOLOR 15 
     "Categoria" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.96 COL 48
          BGCOLOR 1 FGCOLOR 15 
     "B" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.69 COL 48
     "Factores de Distribucion de Categorias" VIEW-AS TEXT
          SIZE 27 BY .5 AT ROW 7.73 COL 26
          BGCOLOR 1 FGCOLOR 15 
     "C" VIEW-AS TEXT
          SIZE 2 BY .5 AT ROW 8.31 COL 32
          BGCOLOR 1 FGCOLOR 15 
     "Final" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 6.77 COL 21
     "B" VIEW-AS TEXT
          SIZE 2 BY .5 AT ROW 8.31 COL 23
          BGCOLOR 1 FGCOLOR 15 
     "A" VIEW-AS TEXT
          SIZE 2 BY .5 AT ROW 8.31 COL 15
          BGCOLOR 1 FGCOLOR 15 
     "Crecimiento (%)" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 10.81 COL 2
     "F" VIEW-AS TEXT
          SIZE 2 BY .5 AT ROW 8.31 COL 59
          BGCOLOR 1 FGCOLOR 15 
     "Factores Globales de Distribucion" VIEW-AS TEXT
          SIZE 24 BY .5 AT ROW 1.19 COL 24
          BGCOLOR 1 FGCOLOR 15 
     "Utilidad" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.04 COL 2
     "Peso en %" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.96 COL 57
          BGCOLOR 1 FGCOLOR 15 
     "D" VIEW-AS TEXT
          SIZE 2 BY .5 AT ROW 8.31 COL 41
          BGCOLOR 1 FGCOLOR 15 
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Inicial" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 6 COL 21
     "Desde el dia" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 1.96 COL 27
          BGCOLOR 1 FGCOLOR 15 
     "F" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.85 COL 48
     "Ventas" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.27 COL 2
     "Hasta el dia" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 1.96 COL 37
          BGCOLOR 1 FGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.AlmCfg
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 12.88
         WIDTH              = 79.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.CateA IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.CrecPes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.UtilPes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.VentPes IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "INTEGRAL.AlmCfg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.AlmCfg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "INTEGRAL.AlmCfg"}

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
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

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

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


