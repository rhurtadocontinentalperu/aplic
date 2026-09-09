&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR s-acceso-total  AS LOG.

DEFINE BUFFER AMATE FOR Almmmate.
DEFINE VAR S-UNDSTK AS CHAR NO-UNDO.
DEFINE VAR F-CODMAR AS CHAR NO-UNDO.
DEFINE VAR S-DESMAR AS CHAR NO-UNDO.


DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg Almmmate

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmate.codmat Almmmate.desmat ~
S-DesMar @ S-DesMar Almmmatg.TpoArt Almmmate.StkAct Almmmate.CodUbi ~
Almmmate.StkRep 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Almmmate.codmat ~
Almmmate.desmat 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Almmmate
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define QUERY-STRING-br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND Almmmatg.CodCia = s-CodCia ~
 AND (TRUE <> (F-CodMat > '') OR Almmmatg.codmat = F-CodMat) ~
 AND (TRUE <> (F-Filtro > '') OR INDEX(Almmmatg.DesMat,F-Filtro) > 0) ~
 AND Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK, ~
      EACH Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-CodAlm NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND Almmmatg.CodCia = s-CodCia ~
 AND (TRUE <> (F-CodMat > '') OR Almmmatg.codmat = F-CodMat) ~
 AND (TRUE <> (F-Filtro > '') OR INDEX(Almmmatg.DesMat,F-Filtro) > 0) ~
 AND Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK, ~
      EACH Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-CodAlm NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatg Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmate


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table F-CodMat F-Filtro R-Tipo RECT-18 
&Scoped-Define DISPLAYED-OBJECTS F-CodMat F-Filtro R-Tipo 

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
Codigo|y||INTEGRAL.Almmmatg.CodCia|yes,INTEGRAL.Almmmatg.codmat|yes
Descripcion|||INTEGRAL.Almmmatg.CodCia|yes,INTEGRAL.Almmmatg.DesMat|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'Codigo,Descripcion' + '",
     SortBy-Case = ':U + 'Codigo').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE F-Filtro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripcion" 
     VIEW-AS FILL-IN 
     SIZE 49.29 BY .88 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activos", "A",
"Inactivos", "D",
"Ambos", ""
     SIZE 31 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110.57 BY 2.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatg, 
      Almmmate SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmate.codmat FORMAT "X(6)":U WIDTH 6.43
      Almmmate.desmat COLUMN-LABEL "Descripcion" FORMAT "x(60)":U
            WIDTH 50.86
      S-DesMar @ S-DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U
      Almmmatg.TpoArt FORMAT "X(1)":U
      Almmmate.StkAct COLUMN-LABEL "Stock!Actual" FORMAT "(>>>>>>>>9.9999)":U
            COLUMN-FONT 4
      Almmmate.CodUbi COLUMN-LABEL "Zonas o!Ubicación" FORMAT "x(7)":U
      Almmmate.StkRep COLUMN-LABEL "Stock de!Reposición" FORMAT "ZZZ,ZZ9.99":U
            WIDTH 10.29
  ENABLE
      Almmmate.codmat
      Almmmate.desmat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 110.43 BY 13.08
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 3.81 COL 1.57
     F-CodMat AT ROW 1.23 COL 9 COLON-ALIGNED
     F-Filtro AT ROW 1.23 COL 29 COLON-ALIGNED
     R-Tipo AT ROW 2.35 COL 12.86 NO-LABEL
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.46 COL 5.43
          FONT 4
     RECT-18 AT ROW 1.08 COL 1.43
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 16.08
         WIDTH              = 112.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almmmatg,INTEGRAL.Almmmate OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "Almmmatg.CodCia = s-CodCia
 AND (TRUE <> (F-CodMat > '') OR Almmmatg.codmat = F-CodMat)
 AND (TRUE <> (F-Filtro > '') OR INDEX(Almmmatg.DesMat,F-Filtro) > 0)
 AND Almmmatg.TpoArt BEGINS R-Tipo"
     _Where[2]         = "Almmmate.CodAlm = s-CodAlm"
     _FldNameList[1]   > integral.Almmmate.codmat
"Almmmate.codmat" ? ? "character" ? ? ? ? ? ? yes ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.Almmmate.desmat
"Almmmate.desmat" "Descripcion" "x(60)" "character" ? ? ? ? ? ? yes ? no no "50.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"S-DesMar @ S-DesMar" "Marca" "X(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = integral.Almmmatg.TpoArt
     _FldNameList[5]   > integral.Almmmate.StkAct
"Almmmate.StkAct" "Stock!Actual" "(>>>>>>>>9.9999)" "decimal" ? ? 4 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.Almmmate.CodUbi
"Almmmate.CodUbi" "Zonas o!Ubicación" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.Almmmate.StkRep
"Almmmate.StkRep" "Stock de!Reposición" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
  /*RETURN NO-APPLY.*/
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmate.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmate.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmate.codmat IN BROWSE br_table /* Codigo!Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
        Almmmatg.CodMat = SELF:SCREEN-VALUE   NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodMat B-table-Win
ON LEAVE OF F-CodMat IN FRAME F-Main /* Codigo */
DO:
  /*IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.*/
  IF SELF:SCREEN-VALUE > '' THEN
      ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
        NO-ERROR.
  ASSIGN F-CodMat. 
  RUN dispatch IN THIS-PROCEDURE ('open-query':U)  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Filtro B-table-Win
ON LEAVE OF F-Filtro IN FRAME F-Main /* Descripcion */
OR "RETURN":U OF F-Filtro
DO:
  IF F-Filtro = F-Filtro:SCREEN-VALUE THEN RETURN.
  ASSIGN F-Filtro .
  RUN dispatch IN THIS-PROCEDURE ('open-query':U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Tipo B-table-Win
ON VALUE-CHANGED OF R-Tipo IN FRAME F-Main
DO:
  assign r-tipo.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/*ON "RETURN":U OF Almmmate.CodMat,Almmmate.CodUbi,almmmate.StkMax,almmmate.StkMin, Almmmate.StkRep*/
ON "RETURN":U OF Almmmate.CodMat,Almmmate.CodUbi,Almmmate.StkRep
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.
ON FIND OF Almmmate
DO:
  FIND almtabla WHERE almtabla.Tabla = "MK" AND
       almtabla.Codigo = Almmmate.CodMar NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla THEN S-DesMar = almtabla.Nombre.
  ELSE S-DesMar = "".
  
  FIND Almmmatg OF Almmmate NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN
    S-DesMar = Almmmatg.DesMar.
  ELSE S-DesMar = "". 
END.

/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Lista-Almacen B-table-Win 
PROCEDURE Actualiza-Lista-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     /* Actualizamos la lista de Almacenes */ 
     FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
          Almmmatg.CodMat = Almmmate.CodMat EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE Almmmatg THEN DO:
        IF Almmmatg.almacenes = "" THEN Almmmatg.almacenes = TRIM(Almmmate.CodAlm).
        IF LOOKUP(Almmmate.CodAlm,Almmmatg.almacenes) = 0 THEN
           ASSIGN Almmmatg.almacenes = TRIM(Almmmatg.almacenes) + "," + 
                                        TRIM(Almmmate.CodAlm).
     END.
     RELEASE Almmmatg.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'Codigo':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.codmat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Descripcion':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.CodCia BY Almmmatg.DesMat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Articulos B-table-Win 
PROCEDURE Asigna-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSige AS CHAR.

/* 25May2015 - Ic, validacion para almacen 11M */
lSige = 'SI'.
IF S-CODALM = '11M' THEN DO: 
    lSige = 'NO'.
    FIND almtabla WHERE almtabla.tabla = S-CODALM AND
         almtabla.codigo = Almmmatg.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla THEN DO:
        lSige = 'SI'.
    END.
END.

DEFINE VAR pMensaje AS CHAR NO-UNDO.
DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN alm/almacen-library.p PERSISTENT SET hProc.
IF lSige = 'SI' THEN DO:
    RUN ALM_Materiales-por-Almacen IN hProc (INPUT S-CODALM,
                                             INPUT Almmmatg.CodMat,
                                             "M",
                                             OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
/*     FIND AMATE WHERE AMATE.CodCia = Almmmatg.CodCia AND                                                       */
/*          AMATE.CodAlm = S-CODALM AND                                                                          */
/*          AMATE.CodMat = Almmmatg.CodMat NO-LOCK NO-ERROR.                                                     */
/*     IF NOT AVAILABLE AMATE THEN DO:                                                                           */
/*        DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo : " FORMAT "X(8)" WITH FRAME F-Proceso. */
/*        CREATE AMATE.                                                                                          */
/*        ASSIGN AMATE.CodCia = Almmmatg.CodCia                                                                  */
/*               AMATE.CodAlm = S-CODALM                                                                         */
/*               AMATE.CodMat = Almmmatg.CodMat                                                                  */
/*               AMATE.DesMat = Almmmatg.DesMat                                                                  */
/*               AMATE.UndVta = Almmmatg.UndStk                                                                  */
/*               AMATE.CodMar = Almmmatg.CodMar                                                                  */
/*               AMATE.FacEqu = Almmmatg.FacEqu.                                                                 */
/*        FIND FIRST almautmv WHERE                                                                              */
/*             almautmv.CodCia = Almmmatg.codcia AND                                                             */
/*             almautmv.CodFam = Almmmatg.codfam AND                                                             */
/*             almautmv.CodMar = Almmmatg.codMar AND                                                             */
/*             almautmv.Almsol = AMATE.CodAlm NO-LOCK NO-ERROR.                                                  */
/*        IF AVAILABLE almautmv THEN                                                                             */
/*           ASSIGN AMATE.AlmDes = almautmv.Almdes                                                               */
/*                  AMATE.CodUbi = almautmv.CodUbi.                                                              */
/*        /* Actualizamos la lista de Almacenes */                                                               */
/*        IF Almmmatg.almacenes = "" THEN Almmmatg.almacenes = TRIM(AMATE.CodAlm).                               */
/*        IF LOOKUP(TRIM(AMATE.CodAlm),Almmmatg.almacenes) = 0 THEN                                              */
/*           ASSIGN Almmmatg.almacenes = TRIM(Almmmatg.almacenes) + "," +                                        */
/*                                      TRIM(AMATE.CodAlm).                                                      */
/*     END.                                                                                                      */

END.
DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-por-Articulos B-table-Win 
PROCEDURE Asigna-por-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Consistencia 28/10/2022 */
  FIND Almacen WHERE Almacen.codcia = s-codcia AND
      Almacen.codalm = s-codalm NO-LOCK.
/*   IF Almacen.TdoArt = YES THEN DO:                                       */
/*       MESSAGE 'El almacén está configurado como "Asignación Automática"' */
/*           VIEW-AS ALERT-BOX ERROR.                                       */
/*       RETURN.                                                            */
/*   END.                                                                   */
  
  ASSIGN 
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
  RUN ALM\C-ASIGNA ("Asignacion de Articulos").
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  IF output-var-2 > '' THEN DO:
      DEF BUFFER b-matg FOR Almmmatg.
      FIND b-matg WHERE b-matg.codcia = s-codcia AND b-matg.codmat = output-var-2
          NO-LOCK NO-ERROR.
      IF AVAILABLE b-matg THEN REPOSITION {&browse-name} TO ROWID ROWID(b-matg) NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-por-Familia B-table-Win 
PROCEDURE Asigna-por-Familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Consistencia 28/10/2022 */
  FIND Almacen WHERE Almacen.codcia = s-codcia AND
      Almacen.codalm = s-codalm NO-LOCK.
  IF Almacen.TdoArt = YES THEN DO:
      MESSAGE 'El almacén está configurado como "Asignación Automática"'
          VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.

RUN LKUP\C-Famili.r("Maestro de Familias").
IF output-var-1 <> ? AND output-var-2 <> "" THEN DO:
   FOR EACH Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
       Almmmatg.codfam = output-var-2 AND
       Almmmatg.TpoArt = "A":       /* 10/06/2024: Juan Ponte Solo ACTIVADOS */
       RUN Asigna-Articulos.
   END.
END.
HIDE FRAME F-Proceso.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-por-Marca B-table-Win 
PROCEDURE Asigna-por-Marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Consistencia 28/10/2022 */
  FIND Almacen WHERE Almacen.codcia = s-codcia AND
      Almacen.codalm = s-codalm NO-LOCK.
  IF Almacen.TdoArt = YES THEN DO:
      MESSAGE 'El almacén está configurado como "Asignación Automática"'
          VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.

input-var-1 = "MK".
RUN LKUP\C-almtab.r("Marcas").
IF output-var-1 <> ? AND output-var-2 <> "" THEN DO:
   FOR EACH Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
       Almmmatg.codmar = output-var-2 AND
       Almmmatg.TpoArt = "A":       /* 10/06/2024: Juan Ponte Solo ACTIVADOS */
       RUN Asigna-Articulos.
   END.
END.
HIDE FRAME F-Proceso.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-por-Proveedor B-table-Win 
PROCEDURE Asigna-por-Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Consistencia 28/10/2022 */
  FIND Almacen WHERE Almacen.codcia = s-codcia AND
      Almacen.codalm = s-codalm NO-LOCK.
  IF Almacen.TdoArt = YES THEN DO:
      MESSAGE 'El almacén está configurado como "Asignación Automática"'
          VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.

RUN CBD\C-provee.r("Maestro de Proveedores").
IF output-var-1 <> ? AND output-var-2 <> "" THEN DO:
   FOR EACH Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
       Almmmatg.CodPr1 = output-var-2 AND
       Almmmatg.TpoArt = "A":       /* 10/06/2024: Juan Ponte Solo ACTIVADOS */
       RUN Asigna-Articulos.
   END.
END.
HIDE FRAME F-Proceso.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-acceso-total = NO THEN RETURN 'ADM-ERROR'.
  Almmmate.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
  APPLY "ENTRY":U TO Almmmate.codmat IN BROWSE {&BROWSE-NAME} . 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN Almmmate.CodCia = S-CODCIA
         Almmmate.CodAlm = S-CODALM.
  FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia 
                 AND  Almmmatg.CodMat = Almmmate.CodMat 
                NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
     ASSIGN Almmmate.DesMat = Almmmatg.DesMat
            Almmmate.FacEqu = Almmmatg.FacEqu
            Almmmate.UndVta = Almmmatg.UndStk
            Almmmate.CodMar = Almmmatg.CodMar.
     FIND FIRST almautmv WHERE almautmv.CodCia = Almmmate.codcia 
                          AND  almautmv.CodFam = Almmmatg.codfam 
                          AND  almautmv.CodMar = Almmmatg.codMar 
                          AND  almautmv.Almsol = Almmmate.CodAlm 
                         NO-LOCK NO-ERROR.
     IF AVAILABLE almautmv THEN DO:
        ASSIGN Almmmate.CodUbi = almautmv.CodUbi.
        IF Almmmate.AlmDes = "" THEN ASSIGN Almmmate.AlmDes = almautmv.Almdes.
     END.
  END.

  /* Consistencia de ubicaciones */

    
    IF Almmmate.CodUbi <> '' AND Almmmate.CodUbi <> "G-0" THEN DO:
        FIND Almtubic WHERE Almtubic.codcia = s-codcia
            AND Almtubic.codalm = s-codalm
            AND Almtubic.codubi = Almmmate.CodUbi NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtubic THEN DO:
            MESSAGE 'Código de ubicación NO registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY' TO Almmmate.CodUbi IN BROWSE {&browse-name}.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.

/*   ENABLE                      */
/*     f-codmat                  */
/*     f-filtro                  */
/*     WITH FRAME {&FRAME-NAME}. */

    
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
     FIND AMATE WHERE AMATE.CodCia = S-CODCIA AND 
          AMATE.CodAlm = S-CODALM AND 
          AMATE.CodMat = F-CodMat NO-LOCK NO-ERROR.
     
     IF AVAILABLE AMATE THEN OUTPUT-VAR-1 = ROWID(AMATE).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  ENABLE 
    f-codmat 
    f-filtro
    WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-current-changed B-table-Win 
PROCEDURE local-current-changed :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'current-changed':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-acceso-total = NO THEN RETURN 'ADM-ERROR'.
 
  DEFINE VAR C-ALM AS CHAR NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
  FIND Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia AND 
                     Almdmov.CodAlm = Almmmate.CodAlm AND
                     Almdmov.CodMat = Almmmate.CodMat NO-LOCK NO-ERROR.
  IF AVAILABLE Almdmov THEN DO:
     MESSAGE "Material tiene movimientos" SKIP "No se puede eliminar" 
              VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".   
  END.
  
  /* Verificamos que no exista stock actual */
  IF Almmmate.StkAct > 0 THEN DO:
     MESSAGE "Material con stock actual" SKIP "No se puede eliminar" 
              VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".   
  END.
  
  /* Actualizamos la lista de Almacenes */ 
  FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
       Almmmatg.CodMat = Almmmate.CodMat NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
     C-ALM = TRIM(Almmmate.CodAlm) + ",".
     IF INDEX(Almmmatg.almacenes,C-ALM) = 0 THEN C-ALM = TRIM(Almmmate.CodAlm).
     ASSIGN Almmmatg.almacenes = REPLACE(Almmmatg.almacenes,C-ALM,"").
     RELEASE Almmmatg.
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          F-CodMat:SENSITIVE = YES
          R-Tipo:SENSITIVE = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
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
      ASSIGN
          F-CodMat:SENSITIVE = NO
          R-Tipo:SENSITIVE = NO.
/*       IF s-acceso-total = NO THEN                                   */
/*           ASSIGN                                                    */
/*           Almmmate.StkMax:READ-ONLY IN BROWSE {&browse-name} = YES  */
/*           Almmmate.StkMin:READ-ONLY IN BROWSE {&browse-name} = YES. */
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

/*MLR* ***
  RUN ALM\D-MATALM.R.
* ***/

  RUN alm/w-stock-minimo-maximo.r('CERO').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.  */

  /*MESSAGE 'Inicio Browse' VIEW-AS ALERT-BOX WARNING.*/

 RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ).
  /* Code placed here will execute AFTER standard behavior.    */

  /*MESSAGE 'Fin de Browse' VIEW-AS ALERT-BOX WARNING.*/

  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available B-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


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
  IF RETURN-VALUE = "adm-error" THEN UNDO, RETURN "adm-error".
  
  RUN Actualiza-Lista-Almacen.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
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
  {src/adm/template/snd-list.i "Almmmate"}

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

  

  IF p-state = 'update-begin':U THEN RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
  
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
      Almmmate.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
      APPLY "ENTRY":U TO Almmmate.codubi IN BROWSE {&BROWSE-NAME}.
  END.

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
IF INTEGER(Almmmate.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Codigo no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY":U TO Almmmate.CodMat.
   RETURN "ADM-ERROR".   
END.
FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
     Almmmatg.CodMat = Almmmate.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
   MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY":U TO Almmmate.CodMat.
   RETURN "ADM-ERROR".   
END.
FIND AMATE WHERE AMATE.CodCia = S-CODCIA AND 
     AMATE.CodAlm = S-CODALM AND 
     AMATE.CodMat = Almmmate.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
     NO-LOCK NO-ERROR.
IF AVAILABLE AMATE AND  ROWID(AMATE) <> ROWID(Almmmate) THEN DO:
   MESSAGE "Codigo ya esta asignado al almacen" S-CODALM VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY":U TO Almmmate.CodMat.
   RETURN "ADM-ERROR".   
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
   RETURN "ADM-ERROR".
END.
  IF s-acceso-total = NO THEN RETURN 'ADM-ERROR'.

DISABLE 
    f-codmat 
    f-filtro
    WITH FRAME {&FRAME-NAME}.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

