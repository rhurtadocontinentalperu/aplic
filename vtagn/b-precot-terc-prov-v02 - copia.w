&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DATOS NO-UNDO LIKE AlmCatVtaD
       Fields ImpUnit AS DEC
       Fields PreUniRef as DEC
       INDEX Llave01 AS PRIMARY CodCia CodDiv CodPro NroPag NroSec
       INDEX Llave02 CodCia CodPro NroPag CodMat
       
       .
DEFINE SHARED TEMP-TABLE PEDI2 NO-UNDO LIKE VtaDDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEFINE SHARED VAR s-task-no AS INT.
DEFINE SHARED VAR s-codpro AS CHAR.
DEFINE SHARED VAR s-tpocmb AS DEC.
DEFINE SHARED VAR s-codmon AS INT.
DEFINE SHARED VAR s-nrocot AS CHAR.
DEFINE SHARED VAR s-codcli AS CHAR.
DEFINE SHARED VAR s-cndvta AS CHAR.
DEFINE SHARED VAR s-TpoPed AS CHAR.
DEFINE SHARED VAR s-NroDec AS INT.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VAR pv-codcia AS INT.

/* Definicion de variables compartidas */
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM AS CHAR.
DEFINE SHARED VARIABLE s-coddiv AS CHAR.
DEFINE SHARED VARIABLE pCodDiv  AS CHAR.

DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.
DEFINE VARIABLE I-NROITM AS INTEGER.

DEFINE VARIABLE x-signo   AS INTEGER     NO-UNDO.
DEFINE VARIABLE f-TotSol  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-TotDol  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dImpLCred AS DECIMAL     NO-UNDO.
DEFINE VARIABLE t-Resultado AS DEC NO-UNDO.


/* Preprocesadores para condiciones */
&SCOPED-DEFINE CONDICION ( w-report.task-no = s-task-no)
&SCOPED-DEFINE CODIGO w-report.Llave-c

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( (w-report.Campo-C[1] BEGINS FILL-IN-filtro) )
&SCOPED-DEFINE FILTRO2 ( (INDEX ( w-report.Llave-C , FILL-IN-filtro ) <> 0) )

/****/
DEFINE VARIABLE dImpLin AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dTotImp AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dTotCan AS DECIMAL     NO-UNDO.

DEFINE VARIABLE x-canPed AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-factor AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-PreBas AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-PreVta AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-Dsctos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE y-Dsctos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE z-Dsctos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DECI NO-UNDO.

DEFINE FRAME F-Mensaje
    " Procesando informacion " SKIP
    " Espere un momento por favor..." SKIP
    WITH VIEW-AS DIALOG-BOX CENTERED OVERLAY WIDTH 40 TITLE 'Mensaje'.

/**/

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
&Scoped-define INTERNAL-TABLES w-report

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table w-report.Llave-C ~
w-report.Campo-C[4] w-report.Campo-C[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH w-report WHERE ~{&KEY-PHRASE} ~
      AND w-report.Task-No = s-task-no NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH w-report WHERE ~{&KEY-PHRASE} ~
      AND w-report.Task-No = s-task-no NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table w-report
&Scoped-define FIRST-TABLE-IN-QUERY-br_table w-report


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-58 FILL-IN-codigo CMB-filtro ~
FILL-IN-filtro br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codigo CMB-filtro FILL-IN-filtro 

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
Nombres que inicien con|y||INTEGRAL.w-report.Llave-C
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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
<SORTBY-OPTIONS></SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Nombres que inicien con" 
     DROP-DOWN-LIST
     SIZE 21.29 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(11)":U 
     LABEL "Código" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73.43 BY 8.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      w-report.Llave-C COLUMN-LABEL "Código" FORMAT "x(11)":U WIDTH 9.43
      w-report.Campo-C[4] COLUMN-LABEL "Nombre Corto" FORMAT "X(20)":U
      w-report.Campo-C[1] COLUMN-LABEL "Proveedor" FORMAT "X(40)":U
            WIDTH 37.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 70.86 BY 6.15
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codigo AT ROW 1.38 COL 12 COLON-ALIGNED WIDGET-ID 2
     CMB-filtro AT ROW 1.38 COL 27 NO-LABEL WIDGET-ID 8
     FILL-IN-filtro AT ROW 1.38 COL 49 NO-LABEL WIDGET-ID 10
     br_table AT ROW 2.35 COL 3
     "F3: Ingresar Promotor" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 8.69 COL 3 WIDGET-ID 14
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Proveedor" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 1 COL 3 WIDGET-ID 12
          FONT 6
     RECT-58 AT ROW 1.12 COL 1.57 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DATOS T "SHARED" NO-UNDO INTEGRAL AlmCatVtaD
      ADDITIONAL-FIELDS:
          Fields ImpUnit AS DEC
          Fields PreUniRef as DEC
          INDEX Llave01 AS PRIMARY CodCia CodDiv CodPro NroPag NroSec
          INDEX Llave02 CodCia CodPro NroPag CodMat
          
          
      END-FIELDS.
      TABLE: PEDI2 T "SHARED" NO-UNDO INTEGRAL VtaDDocu
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.27
         WIDTH              = 74.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table FILL-IN-filtro F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
ASSIGN 
       CMB-filtro:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
ASSIGN 
       FILL-IN-filtro:HIDDEN IN FRAME F-Main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.w-report"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "w-report.Task-No = s-task-no"
     _FldNameList[1]   > INTEGRAL.w-report.Llave-C
"w-report.Llave-C" "Código" "x(11)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.w-report.Campo-C[4]
"w-report.Campo-C[4]" "Nombre Corto" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.w-report.Campo-C[1]
"w-report.Campo-C[1]" "Proveedor" "X(40)" "character" ? ? ? ? ? ? no ? no no "37.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON F3 OF br_table IN FRAME F-Main
DO:
  DEF VAR pPromotor AS INT NO-UNDO.

  ASSIGN
      input-var-1 = 'EXPOPROMOTOR'
      input-var-2 = s-coddiv
      input-var-3 = w-report.Llave-C.
  
  /*RUN lkup/c-promotor ('Seleccione el Promotor').*/
  RUN vtagn/c-promotor-v01 ('Seleccione el Promotor').
  
  IF output-var-1 <> ? THEN DO:
      FIND CURRENT w-report EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE w-report THEN 
          ASSIGN
          w-report.campo-c[2] = output-var-2    /* Nombre Promotor */
          w-report.campo-c[3] = output-var-3.   /* Proveedor|Promotor|Equipo */
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
      FIND CURRENT w-report NO-LOCK NO-ERROR.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON MOUSE-SELECT-CLICK OF br_table IN FRAME F-Main
DO:
    ASSIGN s-codpro = STRING(w-report.llave-c,'X(11)'). 
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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
  /*
    ASSIGN
        wh = br_table:CURRENT-COLUMN
        FILL-IN-chr:VISIBLE IN FRAME Dialog-Frame = FALSE
        FILL-IN-date:VISIBLE = FALSE
        FILL-IN-int:VISIBLE = FALSE
        FILL-IN-dec:VISIBLE = FALSE
        FILL-IN-buscar = wh:LABEL
        CMB-condicion:LIST-ITEMS = "".

    CASE wh:DATA-TYPE:
        WHEN "CHARACTER" THEN DO:
            ASSIGN
                FILL-IN-chr:VISIBLE = TRUE
                CMB-condicion:LIST-ITEMS = "=,Inicie con,Que contenga".
            IF LOOKUP(CMB-condicion, CMB-condicion:LIST-ITEMS) = 0 THEN
                ASSIGN CMB-condicion = CMB-condicion:ENTRY(1).
            DISPLAY FILL-IN-buscar WITH FRAME Dialog-Frame.
            UPDATE
                CMB-condicion
                FILL-IN-chr
                Btn_OK
                Btn_Cancel
                WITH FRAME Dialog-Frame.
        END.
        WHEN "INTEGER" THEN DO:
            ASSIGN
                FILL-IN-int:VISIBLE = TRUE
                CMB-condicion:LIST-ITEMS = "=,>,<,>=,<=".
            IF LOOKUP(CMB-condicion, CMB-condicion:LIST-ITEMS) = 0 THEN
                ASSIGN CMB-condicion = CMB-condicion:ENTRY(1).
            DISPLAY FILL-IN-buscar WITH FRAME Dialog-Frame.
            UPDATE
                CMB-condicion
                FILL-IN-int
                Btn_OK
                Btn_Cancel
                WITH FRAME Dialog-Frame.
        END.
        WHEN "DECIMAL" THEN DO:
            ASSIGN
                FILL-IN-dec:VISIBLE = TRUE
                CMB-condicion:LIST-ITEMS = "=,>,<,>=,<=".
            IF LOOKUP(CMB-condicion, CMB-condicion:LIST-ITEMS) = 0 THEN
                ASSIGN CMB-condicion = CMB-condicion:ENTRY(1).
            DISPLAY FILL-IN-buscar WITH FRAME Dialog-Frame.
            UPDATE
                CMB-condicion
                FILL-IN-dec
                Btn_OK
                Btn_Cancel
                WITH FRAME Dialog-Frame.
        END.
        WHEN "DATE" THEN DO:
            ASSIGN
                FILL-IN-date:VISIBLE = TRUE
                CMB-condicion:LIST-ITEMS = "=,>,<,>=,<=".
            IF LOOKUP(CMB-condicion, CMB-condicion:LIST-ITEMS) = 0 THEN
                ASSIGN CMB-condicion = CMB-condicion:ENTRY(1).
            DISPLAY FILL-IN-buscar WITH FRAME Dialog-Frame.
            UPDATE
                CMB-condicion
                FILL-IN-date
                Btn_OK
                Btn_Cancel
                WITH FRAME Dialog-Frame.
        END.
    END CASE.

    RUN busqueda-secuencial.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

  /* CARGAMOS TODO EL CATALOGO DEL PROVEEDOR */
  VIEW FRAME f-mensaje.
  FIND FIRST almcatvtac WHERE almcatvtac.codcia = s-codcia
      AND almcatvtac.coddiv = pCodDiv
      AND almcatvtac.codpro = w-report.llave-c  NO-LOCK NO-ERROR.
  IF AVAIL almcatvtac THEN DO:      
      CARGADATOS:
      FOR EACH almcatvtad USE-INDEX Index01 NO-LOCK WHERE almcatvtad.codcia = s-codcia
          AND almcatvtad.coddiv = pCodDiv
          AND almcatvtad.codpro = almcatvtac.codpro,
          FIRST almmmatg OF Almcatvtad NO-LOCK:
          FIND FIRST datos WHERE datos.codcia = s-codcia
              AND datos.codpro = almcatvtad.codpro
              AND datos.nropag = almcatvtad.nropag
              AND datos.codmat = almcatvtad.codmat NO-LOCK NO-ERROR.
          IF NOT AVAIL datos THEN DO:
              CREATE DATOS.
              BUFFER-COPY AlmCatVtaD 
                  TO DATOS.
              /* Valida Maestro Productos x Almacen */
              ASSIGN 
                  S-UNDVTA = Almmmatg.CHR__01                  
                  F-FACTOR = 1
                  X-CANPED = 1.
              ASSIGN 
                  Datos.UndBas = s-UndVta
                  Datos.Prealt[5] = f-PreBas
                  Datos.prealt[4] = F-PREVTA + f-FleteUnitario  /* <<< OJO <<< */
                  Datos.PorDto    = F-Dsctos
                  Datos.Por_Dsctos[2] = z-Dsctos
                  Datos.Por_Dsctos[3] = y-Dsctos
                  Datos.PreAlt[6] = f-FleteUnitario.
              /* RHC 21/12/16 Tomamos Mínimo y Empaque Expo del catálogo de materiales */
              ASSIGN
                  DATOS.Libre_d02 = Almmmatg.StkMax
                  DATOS.Libre_d03 = Almmmatg.Libre_d03.
          END.
          PAUSE 0.
      END.
  END.
  RUN Procesa-Handle IN lh_handle ('Open-Query-3':U).
  HIDE FRAME f-mensaje.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro B-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main
DO:
    IF CMB-Filtro = CMB-Filtro:SCREEN-VALUE 
        AND FILL-IN-Filtro = FILL-IN-Filtro:SCREEN-VALUE THEN RETURN.
    ASSIGN
        FILL-IN-Filtro
        CMB-filtro.
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
    /*RUN Procesa-Handle IN lh_handle ('Open-Query-2':U).*/
    /*RUN Procesa-Handle IN lh_handle ('Open-Query-3':U).*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo B-table-Win
ON LEAVE OF FILL-IN-codigo IN FRAME F-Main /* Código */
DO:
    IF INPUT FILL-IN-codigo = "" THEN RETURN.
    &IF "{&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}" &THEN
        FIND FIRST {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
            {&CONDICION} AND
            ( {&CODIGO} = INPUT FILL-IN-codigo )
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            BELL.
            MESSAGE "Registro no encontrado" VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = "".
            RETURN.
        END.
        REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE
                "Registro no se encuentra en el filtro actual" SKIP
                "       Deshacer la actual selección ?       "
                VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO TITLE "Pregunta"
                UPDATE answ AS LOGICAL.
            IF answ THEN DO:
                ASSIGN
                    FILL-IN-filtro:SCREEN-VALUE = ""
                    CMB-filtro:SCREEN-VALUE = CMB-filtro:ENTRY(1).
                APPLY "VALUE-CHANGED" TO CMB-filtro.
                RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
                REPOSITION {&BROWSE-NAME} TO ROWID ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} ) NO-ERROR.
            END.
        END.
        ASSIGN SELF:SCREEN-VALUE = "".
    &ENDIF
    APPLY "VALUE-CHANGED" TO BROWSE {&BROWSE-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro B-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
OR "RETURN":U OF FILL-IN-filtro
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

RUN Carga-Temporal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Nombres que inicien con':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que inicien con */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* CARGAMOS LOS PROVEEDORES CON HOJAS DE PEDIDOS */
IF s-task-no = 0 THEN DO:
    NUMERO:
    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) 
            THEN LEAVE NUMERO.
    END.
END.
FOR EACH VtaCatVenta NO-LOCK WHERE VtaCatVenta.CodCia = s-codcia
        AND VtaCatVenta.CodDiv = pCodDiv,
    FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = VtaCatVenta.codpro NO-LOCK:
    FIND FIRST w-report WHERE w-report.task-no = s-task-no
        AND w-report.llave-c = gn-prov.codpro NO-LOCK NO-ERROR.
    IF NOT AVAIL w-report THEN DO:
        CREATE w-report.
        ASSIGN 
            w-report.task-no = s-task-no
            w-report.llave-c = gn-prov.codpro
            w-report.campo-c[1] = gn-prov.nompro
            w-report.campo-c[4] = gn-prov.locpro.
        FOR EACH PEDI2 WHERE NUM-ENTRIES(PEDI2.Libre_C03,'|') = 3:
            IF ENTRY(1,PEDI2.Libre_C03,'|') = gn-prov.codpro THEN DO:
                FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                    AND VtaTabla.Tabla = 'EXPOPROMOTOR'
                    AND VtaTabla.Llave_c1 = ENTRY(1,PEDI2.Libre_C03,'|')
                    AND VtaTabla.Llave_c2 = ENTRY(2,PEDI2.Libre_C03,'|')
                    NO-LOCK NO-ERROR.
                IF AVAILABLE VtaTabla 
                    THEN ASSIGN 
                    w-report.Campo-C[2] = VtaTabla.Libre_c01
                    w-report.Campo-C[3] = VtaTabla.Llave_c1 + '|' + VtaTabla.Llave_c2 + '|' + VtaTabla.Libre_c02.
                LEAVE.
            END.
        END.
    END.
    PAUSE 0.
END.

/* CARGAMOS LAS VENTAS YA DIGITADAS (EN CASO DE MODIFICAR UNA PRECOTIZACION) */
EMPTY TEMP-TABLE Datos.
FOR EACH PEDI2 NO-LOCK:
    FIND FIRST datos WHERE datos.codcia = s-codcia
        AND datos.codpro = ENTRY(1,PEDI2.Libre_c03,'|')
        AND datos.codmat = PEDI2.codmat NO-LOCK NO-ERROR.
    IF NOT AVAIL datos THEN DO:
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = PEDI2.codmat NO-LOCK NO-ERROR.
        CREATE datos.
        ASSIGN 
            datos.codcia = s-codcia
            datos.coddiv = pCodDiv
            datos.codpro = ENTRY(1,PEDI2.Libre_c03,'|')
            datos.codmat = PEDI2.codmat            
            datos.PorDto = PEDI2.pordto
            datos.PorDto2 = PEDI2.pordto2
            datos.Por_Dsctos[2] = PEDI2.Por_Dsctos[2]
            datos.Por_Dsctos[3] = PEDI2.Por_Dsctos[3]
            datos.prealt[5] = PEDI2.prebas
            datos.prealt[4] = PEDI2.preuni
            datos.libre_d01 = PEDI2.CanPed
            datos.nropag    = INT(PEDI2.libre_c01)
            datos.nrosec    = INT(PEDI2.libre_c02)
            datos.undbas    = PEDI2.undvta
            datos.impunit   = PEDI2.implin.
        IF (PEDI2.implin / PEDI2.canped ) = ? THEN datos.preuniref = 0.
        ELSE datos.preuniref = PEDI2.implin / PEDI2.canped.
        IF AVAIL almmmatg THEN datos.desmat = almmmatg.desmat.
    END.
END.


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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-changed B-table-Win 
PROCEDURE local-row-changed :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-changed':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   APPLY 'value-changed' TO {&browse-name} IN FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "w-report"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toma-handle B-table-Win 
PROCEDURE toma-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-handle AS WIDGET-HANDLE.
    
    ASSIGN whpadre = p-handle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

