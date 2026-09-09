&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM AS CHAR.
DEFINE VARIABLE I-ORDEN AS INTEGER INIT 1 NO-UNDO.
DEFINE VAR R-ROWID    AS ROWID   NO-UNDO.
DEFINE VAR F-STKGEN   AS DECIMAL NO-UNDO.
DEFINE VAR F-STKSUB   AS DECIMAL NO-UNDO.
DEFINE VAR F-CODMAR AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatg.CodMat Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndStk F-STKSUB @ F-STKSUB F-STKGEN @ F-STKGEN   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table CASE I-ORDEN:      WHEN 1 THEN DO:           OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg                WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?                AND (LOOKUP(S-CODALM, ~
      Almmmatg.almacenes) <> 0) NO-LOCK                BY Almmmatg.CodCia                  BY Almmmatg.CodMat.      END.      WHEN 2 THEN DO:           OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg                WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?                AND (LOOKUP(S-CODALM, ~
      Almmmatg.almacenes) <> 0) NO-LOCK                BY Almmmatg.CodCia                  BY Almmmatg.DesMat.      END.      WHEN 3 THEN DO:           OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg                WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?                AND (LOOKUP(S-CODALM, ~
      Almmmatg.almacenes) <> 0)                AND Almmmatg.CodMar BEGINS F-CodMar NO-LOCK                BY Almmmatg.CodCia                  BY Almmmatg.CodMar.      END.      WHEN 11 THEN DO:           OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg                WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?                AND (LOOKUP(S-CODALM, ~
      Almmmatg.almacenes) <> 0)                AND INDEX(Almmmatg.DesMat , ~
       F-Filtro) <> 0                AND Almmmatg.CodMar BEGINS F-CodMar NO-LOCK                BY Almmmatg.CodCia                  BY Almmmatg.DesMat.      END.      WHEN 12 THEN DO:           OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg                WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?                AND (LOOKUP(S-CODALM, ~
      Almmmatg.almacenes) <> 0)                AND Almmmatg.DesMat BEGINS F-Filtro                AND Almmmatg.CodMar BEGINS F-CodMar NO-LOCK                BY Almmmatg.CodCia                  BY Almmmatg.DesMat.      END.      WHEN 21 THEN DO:           OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg                WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?                AND (LOOKUP(S-CODALM, ~
      Almmmatg.almacenes) <> 0)                AND Almmmatg.CodPr1 = F-Provee NO-LOCK                BY Almmmatg.CodCia                  BY Almmmatg.CodMat.      END. END CASE.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-16 RECT-17 F-CodMat F-Marca CB-Orden ~
CB-Filtro F-Filtro F-Provee br_table 
&Scoped-Define DISPLAYED-OBJECTS F-CodMat F-Marca CB-Orden CB-Filtro ~
F-Filtro F-Provee F-XUndM1 F-XUndM2 FILL-IN_UndBas RADIO-SET_TipArt ~
FILL-IN_CanEmp FILL-IN_FchIng EDITOR_Detalle FILL-IN_Pesmat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE CB-Filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Contengan" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Contengan","Inicien" 
     SIZE 11.86 BY 1 NO-UNDO.

DEFINE VARIABLE CB-Orden AS CHARACTER FORMAT "X(256)":U INITIAL "Codigo" 
     LABEL "Ordenado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Codigo","Descripcion","Marca" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR_Detalle AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
     SIZE 31.57 BY 1.73.

DEFINE VARIABLE F-CodMat AS CHARACTER FORMAT "X(9)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-Filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 21.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-Provee AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE F-XUndM1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-XUndM2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_CanEmp AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Empaque" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69.

DEFINE VARIABLE FILL-IN_FchIng AS DATE FORMAT "99/99/9999" INITIAL ? 
     LABEL "Fch.Ing." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE VARIABLE FILL-IN_Pesmat AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69.

DEFINE VARIABLE FILL-IN_UndBas AS CHARACTER FORMAT "X(4)" 
     LABEL "Und.Bas." 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69.

DEFINE VARIABLE RADIO-SET_TipArt AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "A", "A":U,
"B", "B":U,
"C", "C":U
     SIZE 4.29 BY 1.54.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.43 BY 2.08.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.43 BY 2.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      Almmmatg.CodMat COLUMN-LABEL "Codigo!Articulo"
      Almmmatg.DesMat FORMAT "X(45)"
      Almmmatg.DesMar FORMAT "X(15)"
      Almmmatg.UndStk COLUMN-LABEL "Und.!Med." FORMAT "X(4)"
      F-STKSUB @ F-STKSUB COLUMN-LABEL "Stock!Almacen" FORMAT "->,>>>,>>9.9999"
      F-STKGEN @ F-STKGEN COLUMN-LABEL "Stock!General" FORMAT "->,>>>,>>9.9999"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 80.43 BY 11.19
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodMat AT ROW 1.12 COL 7 COLON-ALIGNED
     F-Marca AT ROW 1.12 COL 28.14 COLON-ALIGNED
     CB-Orden AT ROW 1.12 COL 60 COLON-ALIGNED
     CB-Filtro AT ROW 2.04 COL 2.86 NO-LABEL
     F-Filtro AT ROW 2.04 COL 13.86 COLON-ALIGNED NO-LABEL
     F-Provee AT ROW 2.04 COL 60 COLON-ALIGNED
     F-XUndM1 AT ROW 14.54 COL 41.43 COLON-ALIGNED NO-LABEL
     F-XUndM2 AT ROW 15.35 COL 20 COLON-ALIGNED NO-LABEL
     FILL-IN_UndBas AT ROW 15.35 COL 12.57 COLON-ALIGNED
     RADIO-SET_TipArt AT ROW 14.54 COL 2.72 NO-LABEL
     FILL-IN_CanEmp AT ROW 14.54 COL 32.29 COLON-ALIGNED
     FILL-IN_FchIng AT ROW 14.54 COL 12.57 COLON-ALIGNED
     EDITOR_Detalle AT ROW 14.54 COL 49.14 NO-LABEL
     FILL-IN_Pesmat AT ROW 15.35 COL 32.29 COLON-ALIGNED NO-LABEL
     br_table AT ROW 3.15 COL 1
     RECT-16 AT ROW 1 COL 1
     RECT-17 AT ROW 14.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 15.46
         WIDTH              = 80.43.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CB-Filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR EDITOR EDITOR_Detalle IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-XUndM1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-XUndM2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CanEmp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchIng IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Pesmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndBas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET_TipArt IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
CASE I-ORDEN:
     WHEN 1 THEN DO:
          OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg
               WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?
               AND (LOOKUP(S-CODALM,Almmmatg.almacenes) <> 0) NO-LOCK
               BY Almmmatg.CodCia
                 BY Almmmatg.CodMat.
     END.
     WHEN 2 THEN DO:
          OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg
               WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?
               AND (LOOKUP(S-CODALM,Almmmatg.almacenes) <> 0) NO-LOCK
               BY Almmmatg.CodCia
                 BY Almmmatg.DesMat.
     END.
     WHEN 3 THEN DO:
          OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg
               WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?
               AND (LOOKUP(S-CODALM,Almmmatg.almacenes) <> 0)
               AND Almmmatg.CodMar BEGINS F-CodMar NO-LOCK
               BY Almmmatg.CodCia
                 BY Almmmatg.CodMar.
     END.
     WHEN 11 THEN DO:
          OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg
               WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?
               AND (LOOKUP(S-CODALM,Almmmatg.almacenes) <> 0)
               AND INDEX(Almmmatg.DesMat , F-Filtro) <> 0
               AND Almmmatg.CodMar BEGINS F-CodMar NO-LOCK
               BY Almmmatg.CodCia
                 BY Almmmatg.DesMat.
     END.
     WHEN 12 THEN DO:
          OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg
               WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?
               AND (LOOKUP(S-CODALM,Almmmatg.almacenes) <> 0)
               AND Almmmatg.DesMat BEGINS F-Filtro
               AND Almmmatg.CodMar BEGINS F-CodMar NO-LOCK
               BY Almmmatg.CodCia
                 BY Almmmatg.DesMat.
     END.
     WHEN 21 THEN DO:
          OPEN QUERY {&SELF-NAME} FOR EACH Almmmatg
               WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.fchCes = ?
               AND (LOOKUP(S-CODALM,Almmmatg.almacenes) <> 0)
               AND Almmmatg.CodPr1 = F-Provee NO-LOCK
               BY Almmmatg.CodCia
                 BY Almmmatg.CodMat.
     END.
END CASE.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON END OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
   /* This ADM trigger code must be preserved in order to notify other
      objects when the browser's current row changes. */
   {src/adm/template/brschnge.i}
   IF AVAILABLE Almmmatg THEN DO:
      RADIO-SET_TipArt = Almmmatg.TipArt.
      EDITOR_Detalle   = Almmmatg.Detalle.
      DISPLAY Almmmatg.CanEmp @ FILL-IN_CanEmp 
              Almmmatg.FchIng @ FILL-IN_FchIng 
              Almmmatg.Pesmat @ FILL-IN_Pesmat 
              Almmmatg.UndBas @ FILL-IN_UndBas 
              RADIO-SET_TipArt
              EDITOR_Detalle
              Almmmatg.UndStk @ F-XUndM1
              "Peso Kg/" + Almmmatg.UndStk @ F-XUndM2 WITH FRAME {&FRAME-NAME}.

   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-Orden B-table-Win
ON VALUE-CHANGED OF CB-Orden IN FRAME F-Main /* Ordenado */
DO:
  ASSIGN CB-Orden.
  I-ORDEN = LOOKUP(CB-Orden,CB-Orden:LIST-ITEMS).
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodMat B-table-Win
ON ENTRY OF F-CodMat IN FRAME F-Main /* Codigo */
DO:
  ASSIGN F-CodMat = "".
  DISPLAY F-CodMat WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodMat B-table-Win
ON LEAVE OF F-CodMat IN FRAME F-Main /* Codigo */
DO:
  IF INPUT F-CodMat = "" THEN RETURN.
  ASSIGN F-CodMat.
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND 
       Almmmate.CodAlm = S-CODALM AND 
       Almmmate.CodMat = F-CodMat NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmate THEN DO:
     FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
          Almmmatg.CodMat = F-CodMat NO-LOCK NO-ERROR.
     IF AVAILABLE Almmmatg THEN DO:
        R-ROWID = ROWID(Almmmatg).
        REPOSITION {&BROWSE-NAME} TO ROWID R-ROWID.
        RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Filtro B-table-Win
ON LEAVE OF F-Filtro IN FRAME F-Main
DO:
  ASSIGN CB-Filtro F-Filtro F-Marca.
  IF F-Filtro NE "" THEN I-ORDEN = 10 + LOOKUP(CB-Filtro,CB-Filtro:LIST-ITEMS).
  ELSE DO:
       IF F-Marca = "" THEN I-ORDEN = 1.
       ELSE I-ORDEN = 3.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Marca B-table-Win
ON LEAVE OF F-Marca IN FRAME F-Main /* Marca */
OR "RETURN":U OF F-Marca
DO:
  IF F-Marca = F-Marca:SCREEN-VALUE THEN RETURN.
  ASSIGN F-Marca F-Filtro CB-Filtro.
  IF F-Marca = "" THEN DO:
     F-CodMar = "".
     I-ORDEN = 1.
     RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
  ELSE DO:
     FIND FIRST almtabla WHERE almtabla.Tabla = "MK" AND
                almtabla.Nombre BEGINS F-Marca NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN DO:
        F-CodMar = almtabla.Codigo.
        FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
             Almmmatg.CodMar BEGINS F-CodMar NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN 
           IF F-Filtro = "" THEN I-ORDEN = 3.
           ELSE I-ORDEN = 10 + LOOKUP(CB-Filtro,CB-Filtro:LIST-ITEMS).
           RUN dispatch IN THIS-PROCEDURE ('open-query':U).
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Marca B-table-Win
ON MOUSE-SELECT-DBLCLICK OF F-Marca IN FRAME F-Main /* Marca */
OR F8 OF F-Marca
DO:
  ASSIGN input-var-1 = "MK".
  RUN LKUP\C-AlmTab.R ("Marcas").
  IF output-var-1 <> ? THEN 
     F-Marca:SCREEN-VALUE = output-var-3. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Provee
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Provee B-table-Win
ON LEAVE OF F-Provee IN FRAME F-Main /* Proveedor */
DO:
  IF INPUT F-Provee = "" THEN RETURN.
  ASSIGN F-Provee.
  I-ORDEN = 21.
  FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
       Almmmatg.CodPr1 = F-Provee NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN 
     RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  ASSIGN F-Provee = "".
  DISPLAY F-Provee WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON FIND OF Almmmatg DO:
     ASSIGN F-STKSUB = 0
            F-STKGEN = 0.
     FIND Almmmate WHERE Almmmate.CodCia = Almmmatg.CodCia AND
          Almmmate.CodAlm = S-CODALM AND
          Almmmate.CodMat = Almmmatg.CodMat NO-LOCK NO-ERROR.
     IF AVAILABLE Almmmate THEN ASSIGN F-STKSUB = Almmmate.StkAct.
     FOR EACH Almmmate NO-LOCK WHERE  
              Almmmate.CodCia = Almmmatg.CodCia AND
              Almmmate.CodMat = Almmmatg.CodMat: 
         F-STKGEN = F-STKGEN + Almmmate.StkAct.
     END.
END.
/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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
        WHEN "F-Marca" THEN ASSIGN input-var-1 = "MK".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


