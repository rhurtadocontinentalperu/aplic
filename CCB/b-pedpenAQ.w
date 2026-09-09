&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS L-table-Win 
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


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE C-MON AS CHAR NO-UNDO.
DEFINE VARIABLE C-HOR AS CHAR NO-UNDO.
DEFINE VARIABLE L-OK  AS LOGICAL NO-UNDO.

DEFINE BUFFER B-PedM  FOR FacCPedm.
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER B-CPEDM FOR FacCPedm.

DEFINE SHARED TEMP-TABLE T-CcbDDocu LIKE CcbDDocu.
DEFINE SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedm
   FIELD CodRef LIKE CcbCDocu.CodRef
   FIELD NroRef LIKE CcbCDocu.NroRef.
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedm.

/* Definicion de variables compartidas */
DEFINE VARIABLE input-var-1  AS CHARACTER.
DEFINE VARIABLE input-var-2  AS CHARACTER.
DEFINE VARIABLE input-var-3  AS CHARACTER.
DEFINE VARIABLE output-var-1 AS ROWID.
DEFINE VARIABLE output-var-2 AS CHARACTER.
DEFINE VARIABLE output-var-3 AS CHARACTER.

DEFINE SHARED VARIABLE S-CODCIA     AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV     AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDOC     AS CHARACTER.
DEFINE SHARED VARIABLE S-CODALM     AS CHARACTER.
DEFINE SHARED VARIABLE S-PTOVTA     AS INTEGER.
DEFINE SHARED VARIABLE S-SERCJA     AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID    AS CHARACTER.
DEFINE SHARED VARIABLE s-tipo       AS CHARACTER.
DEFINE SHARED VARIABLE s-codmov     LIKE Almtmovm.Codmov.
DEFINE SHARED VARIABLE s-codter     LIKE ccbcterm.codter.

/* Definición de variables locales */
DEFINE VARIABLE whpadre AS WIDGET-HANDLE.
DEFINE VARIABLE wh      AS WIDGET-HANDLE.
DEFINE VARIABLE curr-record AS RECID.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* Preprocesadores para condiciones */
&SCOPED-DEFINE CONDICION ( Faccpedm.CodCia = S-CODCIA AND Faccpedm.CodDoc = "P/M" ~
                           AND Faccpedm.FlgEst = "P" AND Faccpedm.CodDiv = S-CODDIV AND Faccpedm.FchPed = TODAY )

/*&SCOPED-DEFINE CONDICION ( Faccpedm.CodCia = S-CODCIA AND Faccpedm.CodDoc = "P/M" ~
 *                            AND Faccpedm.FlgEst = "P" AND Faccpedm.CodDiv = S-CODDIV  )*/

&SCOPED-DEFINE CODIGO Faccpedm.NroPed

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( Faccpedm.NomCli BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( Faccpedm.NomCli , FILL-IN-filtro ) <> 0 )

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY .88
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 10 BY .88
     BGCOLOR 8 .

DEFINE VARIABLE CMB-condicion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-buscar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Buscar" 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-chr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-date AS DATE FORMAT "99/99/9999":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-dec AS DECIMAL FORMAT "->>>>>9,99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-int AS INTEGER FORMAT "->>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55.14 BY 1.35.

DEFINE FRAME Dialog-Frame
     FILL-IN-buscar AT ROW 1.23 COL 6.14 COLON-ALIGNED
     CMB-condicion AT ROW 1.19 COL 21 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 2.62 COL 34.29
     FILL-IN-chr AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     FILL-IN-date AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     FILL-IN-int AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     FILL-IN-dec AT ROW 1.23 COL 34.43 COLON-ALIGNED NO-LABEL
     Btn_Cancel AT ROW 2.62 COL 44.86
     RECT-2 AT ROW 1 COL 1
     SPACE(0.00) SKIP(1.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         FONT 4 TITLE "Condiciones de Búsqueda"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel CENTERED.

DEFINE VAR F-CODDOC AS CHAR NO-UNDO.

DEFINE TEMP-TABLE temporal
    FIELD t-CodCia LIKE ccbddocu.CodCia 
    FIELD t-CodAlm LIKE ccbddocu.AlmDes
    FIELD t-NroDoc LIKE ccbddocu.nrodoc
    FIELD t-CodMat LIKE ccbddocu.CodMat
    FIELD t-rowid AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartLookup

&Scoped-define ADM-SUPPORTED-LINKS                                                 Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Faccpedm

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Faccpedm.NroPed Faccpedm.NomCli ~
C-MON @ C-MON Faccpedm.ImpTot Faccpedm.FchPed Faccpedm.Hora ~
Faccpedm.Cmpbnte Faccpedm.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Faccpedm WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table Faccpedm
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Faccpedm


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-filtro CMB-filtro br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-filtro CMB-filtro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" L-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
Nombres que inicien con|y||integral.Faccpedm.NomCli
Nombres que contengan|y||integral.Faccpedm.NomCli
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con,Nombres que contengan",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" L-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
Nombre|y||integral.Faccpedm.CodCia|yes,integral.Faccpedm.NomCli|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "Nombre",
     Sort-Case = Nombre':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES></FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     SIZE 21.29 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.57 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82.43 BY 14.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Faccpedm SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Faccpedm.NroPed FORMAT "XXX-XXXXXXXX"
      Faccpedm.NomCli COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(35)"
      C-MON @ C-MON COLUMN-LABEL "Mon" FORMAT "X(4)" COLUMN-FONT 1
      Faccpedm.ImpTot FORMAT "->>>>,>>9.99" COLUMN-FONT 1
      Faccpedm.FchPed COLUMN-LABEL "Fecha de!Emision"
      Faccpedm.Hora COLUMN-LABEL "Hora!Emision"
      Faccpedm.Cmpbnte COLUMN-LABEL "Com."
      Faccpedm.usuario
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 80.57 BY 13.04
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-filtro AT ROW 1.19 COL 23.29 NO-LABEL
     CMB-filtro AT ROW 1.15 COL 1.86 NO-LABEL
     br_table AT ROW 2.08 COL 2
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartLookup
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: External-Tables
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
  CREATE WINDOW L-table-Win ASSIGN
         HEIGHT             = 14.31
         WIDTH              = 83.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW L-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
/* BROWSE-TAB br_table CMB-filtro F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.Faccpedm"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > integral.Faccpedm.NroPed
"Faccpedm.NroPed" ? "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.Faccpedm.NomCli
"Faccpedm.NomCli" "Nombre o Razon Social" "x(35)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > "_<CALC>"
"C-MON @ C-MON" "Mon" "X(4)" ? ? ? 1 ? ? ? no ?
     _FldNameList[4]   > integral.Faccpedm.ImpTot
"Faccpedm.ImpTot" ? "->>>>,>>9.99" "decimal" ? ? 1 ? ? ? no ?
     _FldNameList[5]   > integral.Faccpedm.FchPed
"Faccpedm.FchPed" "Fecha de!Emision" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[6]   > integral.Faccpedm.Hora
"Faccpedm.Hora" "Hora!Emision" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[7]   > integral.Faccpedm.Cmpbnte
"Faccpedm.Cmpbnte" "Com." ? "character" ? ? ? ? ? ? no ?
     _FldNameList[8]   = integral.Faccpedm.usuario
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB L-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
OR "RETURN":U OF br_table
DO:
    RUN Cancelar-Pedido.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
    RETURN NO-APPLY.
    /* This code displays initial values for newly added or copied rows. */
    {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON START-SEARCH OF br_table IN FRAME F-Main
DO:

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

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro L-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main
DO:
    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE THEN RETURN.
    ASSIGN
        FILL-IN-filtro
        CMB-filtro.
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro L-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


ON FIND OF FacCPedm
DO:
   C-MON = "S/.".
   IF Faccpedm.CodMon = 2 THEN C-MON = "US$".
/*
   /* ------ Verifica Hora de Retención --------*/
   
   DEFINE VAR XPEDHORAS AS CHAR.
   DEFINE VAR XACTUAL   AS CHAR.
   DEFINE VAR FTIME_H1  AS INTEGER.
   DEFINE VAR FTIME_M1  AS INTEGER.
   DEFINE VAR FHORA_11  AS INTEGER.
   DEFINE VAR FHORA_12  AS INTEGER.
   DEFINE VAR FTIME_H2  AS INTEGER.
   DEFINE VAR FTIME_M2  AS INTEGER.
   DEFINE VAR FHORA_1   AS DECIMAL.
   DEFINE VAR XFECH     AS CHAR.
   DEFINE VAR XMINUT    AS CHAR.
   DEFINE VAR XRESTA    AS INTEGER.
   
   XPEDHORAS = FACCPEDM.HORA.
   XACTUAL   = STRING(TIME,"99:99:99").
   FTIME_H1  = INTEGER(SUBSTRING(XPEDHORAS,1,2)).
   FTIME_M1  = INTEGER(SUBSTRING(XPEDHORAS,1,2)) / 100.
   FHORA_11  = FTIME_H1 + FTIME_M1.  
    
   FTIME_H2  = INTEGER(SUBSTRING(XACTUAL,1,2)).
   FTIME_M2  = INTEGER(SUBSTRING(XACTUAL,1,2)) / 100.
  
   IF FTIME_H2 > FTIME_H1 THEN
      FHORA_12 = FTIME_H2 - 1 + IF FTIME_M2 < 10 THEN 0.6 + (FTIME_M2) ELSE FTIME_M2. 
   ELSE    
      FHORA_12 = FTIME_H2 + FTIME_M2.
   
   FHORA_1  = IF FHORA_12 > FHORA_11 THEN FHORA_12 - FHORA_11 
              ELSE FHORA_11 - FHORA_12. 
   FHORA_1  = FHORA_12 - FHORA_11. 
   XFECH    = STRING(FHORA_1,"99999.99").
   XMINUT   = SUBSTRING(XFECH,7,2).

   IF INTEGER(XMINUT) >= 60 THEN DO:
      XRESTA  = INTEGER(XMINUT) - 60.
      FHORA_1 = 1 + ( FHORA_1 - 0.60).
      END.   

   C-HOR = STRING(,"99") + ":" + string(,"99").*/

END.

/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases L-table-Win adm/support/_adm-opn.p
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
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Nombre':U THEN DO:
           &Scope SORTBY-PHRASE BY Faccpedm.CodCia BY Faccpedm.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que inicien con */
    WHEN 'Nombres que contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Nombre':U THEN DO:
           &Scope SORTBY-PHRASE BY Faccpedm.CodCia BY Faccpedm.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'Nombre':U THEN DO:
           &Scope SORTBY-PHRASE BY Faccpedm.CodCia BY Faccpedm.NomCli
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available L-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busqueda-secuencial L-table-Win 
PROCEDURE busqueda-secuencial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED (FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) > 0 &THEN

DEFINE VARIABLE pto AS LOGICAL NO-UNDO.
pto = SESSION:SET-WAIT-STATE("GENERAL").

ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

lazo:
DO WHILE AVAILABLE({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) ON STOP UNDO, LEAVE lazo:

    GET NEXT {&BROWSE-NAME}.

    IF QUERY-OFF-END("{&BROWSE-NAME}") THEN GET FIRST {&BROWSE-NAME}.

    REPOSITION br_table TO ROWID ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

    IF RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = curr-record THEN LEAVE lazo.

    CASE wh:DATA-TYPE:
    WHEN "INTEGER" THEN DO:
        CASE CMB-condicion:
        WHEN "=" THEN
            IF INTEGER(wh:SCREEN-VALUE) = FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">" THEN
            IF INTEGER(wh:SCREEN-VALUE) > FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">=" THEN
            IF INTEGER(wh:SCREEN-VALUE) >= FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<" THEN
            IF INTEGER(wh:SCREEN-VALUE) <  FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<=" THEN
            IF INTEGER(wh:SCREEN-VALUE) <= FILL-IN-int THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    END.
    WHEN "DECIMAL" THEN DO:
        CASE CMB-condicion:
        WHEN "=" THEN
            IF DECIMAL(wh:SCREEN-VALUE) = FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">" THEN
            IF DECIMAL(wh:SCREEN-VALUE) > FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">=" THEN
            IF DECIMAL(wh:SCREEN-VALUE) >= FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<" THEN
            IF DECIMAL(wh:SCREEN-VALUE) <  FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<=" THEN
            IF DECIMAL(wh:SCREEN-VALUE) <= FILL-IN-dec THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    END.
    WHEN "DATE" THEN DO:
        CASE CMB-condicion:
        WHEN "=" THEN
            IF DATE(wh:SCREEN-VALUE) = FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">" THEN
            IF DATE(wh:SCREEN-VALUE) > FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN ">=" THEN
            IF DATE(wh:SCREEN-VALUE) >= FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<" THEN
            IF DATE(wh:SCREEN-VALUE) <  FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "<=" THEN
            IF DATE(wh:SCREEN-VALUE) <= FILL-IN-date THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    END.
    WHEN "CHARACTER" THEN
        CASE CMB-condicion:
        WHEN "=" THEN
            IF wh:SCREEN-VALUE = FILL-IN-chr THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "Inicie con" THEN
            IF wh:SCREEN-VALUE BEGINS FILL-IN-chr THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        WHEN "Que contenga" THEN
            IF INDEX(wh:SCREEN-VALUE, FILL-IN-chr) > 0 THEN DO:
                ASSIGN curr-record = RECID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
                LEAVE lazo.
            END.
        END CASE.
    OTHERWISE LEAVE lazo.
    END CASE.
END.

pto = SESSION:SET-WAIT-STATE("").

REPOSITION {&BROWSE-NAME} TO RECID curr-record.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Pedido L-table-Win 
PROCEDURE Cancelar-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i       AS INTEGER INITIAL 1 NO-UNDO.
  DEFINE VARIABLE D-ROWID AS ROWID NO-UNDO.
  
  D-ROWID = ROWID(faccpedm).
  
  FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID NO-LOCK NO-ERROR. 
  
  /**** SOLO CONTADO Y CONTADO ANTICIPADO GENERAN INGRESO A CAJA ****/
  
  IF LOOKUP(B-PedM.FmaPgo,"000,002") > 0 THEN 
       RUN ccb\Canc_Ped ( D-ROWID, OUTPUT L-OK).
  ELSE L-OK = YES.
  
  IF L-OK = NO THEN RETURN "ADM-ERROR".
  
  S-CODDOC = B-PedM.Cmpbnte.
  
  RUN Crea-Temporal.
  
  DO TRANSACTION ON ERROR UNDO, RETURN ERROR:
     FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID EXCLUSIVE-LOCK . 
      
     FOR EACH T-CPEDM:
         S-CodAlm = T-CPEDM.CodAlm.   /* << OJO << lo tomamos del pedido */
         CREATE CcbCDocu.
         FIND faccorre WHERE 
              faccorre.codcia = s-codcia AND  
              faccorre.coddoc = s-coddoc AND  
              faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE faccorre THEN 
            ASSIGN ccbcdocu.nrodoc = STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
                   faccorre.correlativo = faccorre.correlativo + 1.
         RELEASE faccorre.
         ASSIGN T-CPEDM.CodRef    = S-CodDoc
                T-CPEDM.NroRef    = ccbcdocu.nrodoc
                CcbCDocu.CodCia   = S-CodCia
                CcbCDocu.CodDoc   = S-CodDoc
                CcbCDocu.FchDoc   = TODAY
                CcbCDocu.usuario  = S-User-Id
                CcbCDocu.usrdscto = T-CPEDM.usrdscto 
                CcbCDocu.Tipo     = S-Tipo
                CcbCDocu.CodAlm   = S-CodAlm
                CcbCDocu.CodDiv   = S-CodDiv
                CcbCDocu.CodCli   = T-CPEDM.Codcli
                CcbCDocu.RucCli   = T-CPEDM.RucCli
                CcbCDocu.NomCli   = T-CPEDM.Nomcli
                CcbCDocu.DirCli   = T-CPEDM.DirCli
                CcbCDocu.CodMon   = T-CPEDM.codmon
                CcbCDocu.CodMov   = S-CodMov
                CcbCDocu.CodPed   = T-CPEDM.coddoc
                CcbCDocu.CodVen   = T-CPEDM.codven
                CcbCDocu.FchCan   = TODAY
                CcbCDocu.FchVto   = TODAY
                CcbCDocu.ImpBrt   = T-CPEDM.impbrt
                CcbCDocu.ImpDto   = T-CPEDM.impdto
                CcbCDocu.ImpExo   = T-CPEDM.impexo
                CcbCDocu.ImpIgv   = T-CPEDM.impigv
                CcbCDocu.ImpIsc   = T-CPEDM.impisc
                CcbCDocu.ImpTot   = T-CPEDM.imptot
                CcbCDocu.ImpVta   = T-CPEDM.impvta
                CcbCDocu.TipVta   = "1" 
                CcbCDocu.TpoFac   = "C"
                CcbCDocu.FlgEst   = "P"
                CcbCDocu.FmaPgo   = T-CPEDM.FmaPgo
                CcbCDocu.NroPed   = B-PedM.NroPed
                CcbCDocu.PorIgv   = T-CPEDM.porigv 
                CcbCDocu.SdoAct   = T-CPEDM.imptot
                CcbCDocu.TpoCmb   = T-CPEDM.tpocmb
                CcbCDocu.Glosa    = T-CPEDM.Glosa.
                
                /* POR AHORA GRABAMOS EL TIPO DE ENTREGA */
                CcbCDocu.CodAge   = T-CPEDM.CodTrans.
                CcbCDocu.FlgSit   = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "".
                CcbCDocu.FlgCon   = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "".
                IF B-PedM.FmaPgo  = "001" THEN CcbCDocu.FlgCon = "E".
                IF B-PedM.FmaPgo  = "002" THEN CcbCDocu.FlgCon = "A".
         /* actualizamos el detalle */
         FOR EACH T-DPEDM OF T-CPEDM BY nroitm:
             CREATE ccbDDocu.
             ASSIGN CcbDDocu.CodCia = ccbcdocu.codcia
                    CcbDDocu.CodDoc = ccbcdocu.coddoc
                    CcbDDocu.NroDoc = ccbcdocu.nrodoc
                    CcbDDocu.codmat = T-DPEDM.codmat
                    CcbDDocu.Factor = T-DPEDM.factor
                    CcbDDocu.ImpDto = T-DPEDM.impdto
                    CcbDDocu.ImpIgv = T-DPEDM.impigv
                    CcbDDocu.ImpIsc = T-DPEDM.impisc
                    CcbDDocu.ImpLin = T-DPEDM.implin
                    CcbDDocu.AftIgv = T-DPEDM.aftigv
                    CcbDDocu.AftIsc = T-DPEDM.aftisc
                    CcbDDocu.CanDes = T-DPEDM.canped
                    CcbDDocu.NroItm = i
                    CcbDDocu.PorDto = T-DPEDM.pordto
                    CcbDDocu.PreBas = T-DPEDM.prebas
                    CcbDDocu.PreUni = T-DPEDM.preuni
                    CcbDDocu.PreVta[1] = T-DPEDM.prevta[1]
                    CcbDDocu.PreVta[2] = T-DPEDM.prevta[2]
                    CcbDDocu.PreVta[3] = T-DPEDM.prevta[3]
                    CcbDDocu.UndVta = T-DPEDM.undvta
                    CcbDDocu.AlmDes = T-DPEDM.AlmDes
             i = i + 1.
         END.
     END.
     /**** ACTUALIZAMOS FLAG DEL PEDIDO  DE MOSTRADOR COMO ATENDIDO ****/
     ASSIGN  B-PedM.flgest = "C".
     /**** SOLO CONTADO Y CONTADO ANTICIPADO GENERAN INGRESO A CAJA ****/
     IF LOOKUP(B-PedM.FmaPgo,"000,002") > 0 THEN DO:
        /* Cancelacion del documento */
        RUN Ingreso-a-Caja.
        /* Generar Asignacion de Nota de Credito */
        IF T-CcbCCaja.Voucher[6] <> ' ' AND
           (T-CcbCCaja.ImpNac[6] + T-CcbCCaja.ImpUsa[6]) > 0 THEN 
           RUN Cancelar_Documento.
     END.
     /**** SOLO CONTADO Y CONTRA ENTREGA DESCARGAN DEL ALMACEN ****/
     IF LOOKUP(B-PedM.FmaPgo,"000,001") > 0 THEN RUN Descarga-de-Almacen.
     IF LOOKUP(B-PedM.FmaPgo,"002") > 0 THEN RUN Genera-Orden-Despacho.
  END.
  RELEASE B-PedM.
  
  /**** IMPRIMIMOS LAS FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO ****/
  FOR EACH T-CPEDM NO-LOCK 
           BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND CcbCDocu WHERE 
           CcbCDocu.CodCia = S-CodCia AND
           CcbCDocu.CodDoc = T-CPEDM.CodRef AND
           CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
      IF AVAILABLE CcbCDocu THEN  DO:
         IF Ccbcdocu.CodDoc = "FAC" THEN RUN ccb/r-fact01 (ROWID(ccbcdocu)).
         IF Ccbcdocu.CodDoc = "BOL" THEN RUN ccb/r-bole01 (ROWID(ccbcdocu)).
         FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
         IF AVAIL CcbDdocu THEN
            RUN ccb/r-odesp (ROWID(ccbcdocu), CcbDDocu.AlmDes).
      END.
  END.

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Pedido-ANT L-table-Win 
PROCEDURE Cancelar-Pedido-ANT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE D-ROWID AS ROWID NO-UNDO.
  
  /****     Borra Temporal  ****/
  FOR EACH temporal:
    DELETE temporal.
  END.
  
  /****  Add by C.Q. 24/01/2000  ****/
  /****  para poder direccionar la guia de despacho a su respectivo almacen  ****/
  FOR EACH FacDPedm OF FacCPedm BY nroitm:
     FIND temporal WHERE t-CodCia = FacDPedm.CodCia 
                    AND  t-CodAlm = FacDPedm.AlmDes
                    AND  t-NroDoc = FacDPedm.nroped
                   NO-ERROR.
     IF NOT AVAIL temporal THEN DO:
         CREATE temporal.
         ASSIGN t-CodCia = FacDPedm.CodCia 
                t-CodAlm = FacDPedm.AlmDes
                t-NroDoc = FacDPedm.nroped.
     END.
  END.
  /***********************************/
  
  D-ROWID = ROWID(faccpedm).
  
  FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID NO-LOCK NO-ERROR. 
  
  IF B-PedM.TipVta = "1" THEN RUN ccb\Canc_Ped ( D-ROWID, OUTPUT L-OK).
  ELSE L-OK = YES.
  
  IF L-OK = NO THEN RETURN "ADM-ERROR".
  
  S-CODDOC = B-PedM.Cmpbnte.
  
  DO TRANSACTION ON ERROR UNDO, RETURN ERROR:
     /****  Temporal para poder desglosar la factura con su respectivo en su respectivo almacen ****/
     FOR EACH temporal NO-LOCK:
         RUN Captura-Configuracion.
         
         FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID EXCLUSIVE-LOCK . 
         s-codalm = B-PedM.codalm.   /* << OJO << lo tomamos del pedido */
         
         CREATE CcbCDocu.
         FIND faccorre WHERE faccorre.codcia = s-codcia 
                        AND  faccorre.coddoc = s-coddoc 
                        AND  faccorre.NroSer = s-ptovta 
                       EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE faccorre THEN 
            ASSIGN
                 ccbcdocu.nrodoc = STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
                 faccorre.correlativo = faccorre.correlativo + 1.
         RELEASE faccorre.
    
         ASSIGN 
           CcbCDocu.CodCia = s-codcia
           CcbCDocu.CodDoc = s-coddoc
           CcbCDocu.usuario= s-user-id
           CcbCDocu.usrdscto = B-PedM.usrdscto 
           CcbCDocu.Tipo   = s-tipo
           CcbCDocu.CodAlm = s-codalm
           CcbCDocu.CodDiv = s-coddiv
           CcbCDocu.CodCli = B-PedM.Codcli
           CcbCDocu.RucCli = B-PedM.RucCli
           CcbCDocu.NomCli = B-PedM.Nomcli
           CcbCDocu.DirCli = B-PedM.DirCli
           CcbCDocu.CodMon = B-PedM.codmon
           CcbCDocu.CodMov = s-codmov
           CcbCDocu.CodPed = B-PedM.coddoc
           CcbCDocu.CodVen = B-PedM.codven
           CcbCDocu.FchCan = TODAY
           CcbCDocu.FchDoc = TODAY
           CcbCDocu.FchVto = TODAY
           CcbCDocu.ImpBrt = B-PedM.impbrt
           CcbCDocu.ImpDto = B-PedM.impdto
           CcbCDocu.ImpExo = B-PedM.impexo
           CcbCDocu.ImpIgv = B-PedM.impigv
           CcbCDocu.ImpIsc = B-PedM.impisc
           CcbCDocu.ImpTot = B-PedM.imptot
           CcbCDocu.ImpVta = B-PedM.impvta
           CcbCDocu.TipVta = "1" 
           CcbCDocu.TpoFac = "C"
           CcbCDocu.FmaPgo = "000"
           CcbCDocu.NroPed = B-PedM.nroped
           CcbCDocu.PorIgv = B-PedM.porigv 
           CcbCDocu.SdoAct = B-PedM.imptot
           CcbCDocu.TpoCmb = B-PedM.tpocmb.
           /* POR AHORA GRABAMOS EL TIPO DE ENTREGA */
           CcbCDocu.CodAge =  B-PedM.CodTrans.
           CcbCDocu.FlgSit =  IF B-PedM.DocDesp = "GUIA" THEN "G" ELSE "".
           CcbCDocu.FlgCon =  IF B-PedM.DocDesp = "GUIA" THEN "G" ELSE "".
          
         /* ACTUALIZAMOS EL PEDIDO  DE MOSTRADOR */
         ASSIGN  B-PedM.flgest = "C".
         
         /* actualizamos el detalle */
         DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
         FOR EACH facdpedm OF B-PedM BY nroitm:
            IF facdpedm.AlmDes = t-CodAlm THEN DO:
                CREATE ccbDDocu.
                ASSIGN
                    CcbDDocu.CodCia = ccbcdocu.codcia
                    CcbDDocu.CodDoc = ccbcdocu.coddoc
                    CcbDDocu.NroDoc = ccbcdocu.nrodoc
                    CcbDDocu.codmat = facdpedm.codmat
                    CcbDDocu.Factor = facdpedm.factor
                    CcbDDocu.ImpDto = facdpedm.impdto
                    CcbDDocu.ImpIgv = facdpedm.impigv
                    CcbDDocu.ImpIsc = facdpedm.impisc
                    CcbDDocu.ImpLin = facdpedm.implin
                    CcbDDocu.AftIgv = facdpedm.aftigv
                    CcbDDocu.AftIsc = facdpedm.aftisc
                    CcbDDocu.CanDes = facdpedm.canped
                    CcbDDocu.NroItm = i
                    CcbDDocu.PorDto = facdpedm.pordto
                    CcbDDocu.PreBas = facdpedm.prebas
                    CcbDDocu.PreUni = facdpedm.preuni
                    CcbDDocu.PreVta[1] = facdpedm.prevta[1]
                    CcbDDocu.PreVta[2] = facdpedm.prevta[2]
                    CcbDDocu.PreVta[3] = facdpedm.prevta[3]
                    CcbDDocu.UndVta = facdpedm.undvta
                    CcbDDocu.AlmDes = facdpedm.AlmDes
                    i = i + 1.
            END.
         END.
   
         /****     Graba Totales   ****/
         DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
         DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
         FIND B-CPEDM WHERE ROWID(B-CPEDM) = ROWID(Faccpedm) EXCLUSIVE-LOCK NO-ERROR.
         CcbCDocu.ImpDto = 0.
         CcbCDocu.ImpIgv = 0.
         CcbCDocu.ImpIsc = 0.
         CcbCDocu.ImpTot = 0.
         CcbCDocu.ImpExo = 0.
         CcbCDocu.ImpBrt = 0.
         F-IGV = 0.
         F-ISC = 0.

         FOR EACH facdpedm OF B-PedM BY nroitm:
            IF facdpedm.AlmDes = t-CodAlm THEN DO:
                CcbCDocu.ImpDto = CcbCDocu.ImpDto + facdpedm.ImpDto.
                         F-IGV = F-IGV + facdpedm.ImpIgv.
                         F-ISC = F-ISC + facdpedm.ImpIsc.
                CcbCDocu.ImpTot = CcbCDocu.ImpTot + facdpedm.ImpLin.
                IF NOT facdpedm.AftIgv THEN CcbCDocu.ImpExo = CcbCDocu.ImpExo + facdpedm.ImpLin.
            END.
         END.
         CcbCDocu.ImpIgv = ROUND(F-IGV,2).
         CcbCDocu.ImpIsc = ROUND(F-ISC,2).
         CcbCDocu.ImpBrt = CcbCDocu.ImpTot - CcbCDocu.ImpIgv - CcbCDocu.ImpIsc + 
                           CcbCDocu.ImpDto - CcbCDocu.ImpExo.
         CcbCDocu.ImpVta = CcbCDocu.ImpBrt - CcbCDocu.ImpDto.
         
         T-ROWID = ROWID(CcbCDocu).
         
         /*****************************/
         
         RELEASE B-PedM.
     END.
     /****      Fin de Proceso  ****/
  END.
  /****  Add by C.Q. 24/01/2000  ****/
  /**** CONTROLAMOS LOS PEDIDOS CONTRA ENTRAGA ****/
  FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID NO-LOCK NO-ERROR.
  IF B-PedM.TipVta = "1" THEN DO:
     /* Cancelacion del documento */
        RUN Ingreso-a-Caja.
     /* Orden de despacho al almacen */
     /*      RUN Orden-de-despacho.*/
     /* Generar Asignacion de Nota de Credito */
     IF T-CcbCCaja.Voucher[6] <> ' ' AND
        (T-CcbCCaja.ImpNac[6] + T-CcbCCaja.ImpUsa[6]) > 0 THEN 
        RUN Cancelar_Documento.
  END.
  FOR EACH temporal NO-LOCK:
      FIND CcbCDocu WHERE ROWID(CcbCDocu) = T-ROWID NO-ERROR. 
      IF AVAILABLE CcbCDocu THEN  DO:
/*         CASE Ccbcdocu.CodDoc:
 *                 WHEN "FAC" THEN
 *                       RUN ccb/r-fact01 (ROWID(ccbcdocu)).
 *                 WHEN "BOL" THEN
 *                       RUN ccb/r-bole01 (ROWID(ccbcdocu)).
 *          END CASE.*/

/*         RUN ccb/r-guides  (ROWID(ccbcdocu)).*/
    /*     RUN ccb/r-odesp  (ROWID(ccbcdocu)).*/
      END.
  END.
  
  /****  Add by C.Q. 24/01/2000  ****/
  /****  para poder direccionar la guia de despacho a su respectivo almacen  ****/
  FOR EACH temporal NO-LOCK:
     FIND CcbCDocu WHERE ROWID(CcbCDocu) = T-ROWID NO-ERROR. 
     IF AVAILABLE CcbCDocu THEN
     RUN Orden-de-Despacho-Almacen (t-CodCia,
                                    t-CodAlm,
                                    T-ROWID
                                    ).
  END.
  /**********************************/
  
/*  /* ORDEN DE DESPACHO */
 *   s-coddoc = 'O/D'.
 *   RUN Captura-Configuracion.
 *   RUN Genera-Orden-Despacho. */
  
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar_Documento L-table-Win 
PROCEDURE Cancelar_Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND B-CDocu WHERE B-CDocu.CodCia = s-codcia 
                AND  B-CDocu.CodDoc = 'N/C' 
                AND  B-CDocu.NroDoc = T-CcbCCaja.Voucher[6] 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDocu THEN DO:
     MESSAGE 'Nota de Credito no se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  CREATE CcbDCaja.
  ASSIGN 
     CcbDCaja.CodCia = s-CodCia
     CcbDCaja.CodDoc = 'N/C'
     CcbDCaja.NroDoc = T-CcbCCaja.Voucher[6]
     CcbDCaja.CodMon = B-CDocu.CodMon
     CcbDCaja.TpoCmb = CcbCDocu.tpocmb
     CcbDCaja.CodCli = CcbCDocu.CodCli
     CcbDCaja.CodRef = B-CDocu.CodDoc
     CcbDCaja.NroRef = B-CDocu.NroDoc
     CcbDCaja.FchDoc = CcbCDocu.FchDoc.
  IF B-CDocu.CodMon = 1 THEN
     ASSIGN 
        CcbDCaja.ImpTot = T-CcbCCaja.ImpNac[6].
  ELSE
     ASSIGN 
        CcbDCaja.ImpTot = T-CcbCCaja.ImpUsa[6].

  RUN Cancelar_Nota_Credito ( s-CodCia, CcbDCaja.CodRef, CcbDCaja.NroRef, CcbDCaja.CodMon,
                              CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).
  RUN Cancelar_Nota_Credito ( s-CodCia, CcbDCaja.CodDoc, CcbDCaja.NroDoc, CcbDCaja.CodMon,
                              CcbDCaja.TpoCmb, CcbDCaja.ImpTot, FALSE ).    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar_Nota_Credito L-table-Win 
PROCEDURE Cancelar_Nota_Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER iCodCia AS INTEGER.
DEFINE INPUT PARAMETER cCodDoc AS CHAR.
DEFINE INPUT PARAMETER cNroDoc AS CHAR.
DEFINE INPUT PARAMETER iCodMon AS INTEGER.
DEFINE INPUT PARAMETER fTpoCmb AS DECIMAL.
DEFINE INPUT PARAMETER fImpTot AS DECIMAL.
DEFINE INPUT PARAMETER LSumRes AS LOGICAL.

DEFINE VAR XfImport AS DECIMAL INITIAL 0.

FIND FIRST B-CDocu WHERE B-CDocu.CodCia = iCodCia 
                    AND  B-CDocu.CodDoc = cCodDoc 
                    AND  B-CDocu.NroDoc = cNroDoc 
                   EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE B-CDocu THEN DO :
   XfImport = fImpTot.
   IF B-CDocu.CodMon <> iCodMon THEN DO:
      IF B-CDocu.CodMon = 1 THEN 
         ASSIGN XfImport = ROUND( fImpTot * fTpoCmb , 2 ).
      ELSE ASSIGN XfImport = ROUND( fImpTot / fTpoCmb , 2 ).
   END.
   
   IF LSumRes THEN ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct + XfImport.
   ELSE ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct - XfImport.
   
   IF B-CDocu.SdoAct <= 0 THEN ASSIGN B-CDocu.FlgEst = "C".
   ELSE ASSIGN B-CDocu.FlgEst = "P".
   RELEASE B-CDocu.
END.                          
ELSE MESSAGE "Nota de Credito no registrada " VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Configuracion L-table-Win 
PROCEDURE Captura-Configuracion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Saca la Serie Factura/Boleta por terminal */
  FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia 
                       AND  CcbDTerm.CodDiv = s-coddiv 
                       AND  CcbDTerm.CodDoc = s-coddoc 
                       AND  CcbDTerm.CodTer = s-codter 
                      NO-LOCK NO-ERROR.
       s-ptovta = ccbdterm.nroser.
       
  /* Control de correlativos */
  FIND FacDocum WHERE facdocum.codcia = s-codcia 
                 AND  facdocum.coddoc = s-coddoc
                NO-LOCK NO-ERROR.
  s-codmov = facdocum.codmov.
  FIND FacCorre WHERE faccorre.codcia = s-codcia 
                 AND  faccorre.coddoc = s-coddoc 
                 AND  faccorre.nroser = s-ptovta 
                NO-LOCK NO-ERROR.
  s-codalm = faccorre.codalm.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE captura-datos L-table-Win 
PROCEDURE captura-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF DEFINED (FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) > 0 &THEN

IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
    ASSIGN
        output-var-1 = ROWID( {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} )
        output-var-2 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroPed
        output-var-3 = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.nomcli.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Temporal L-table-Win 
PROCEDURE Crea-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
  FOR EACH T-CPEDM:
      DELETE T-CPEDM.
  END.
  FOR EACH T-DPEDM:
      DELETE T-DPEDM.
  END.
  DEFINE VARIABLE L-NewPed AS LOGICAL INIT YES NO-UNDO.
  DEFINE VARIABLE I-NPED   AS INTEGER INIT 0.
  DEFINE VARIABLE I-NItem  AS INTEGER INIT 0.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  FOR EACH FacDPedm OF FacCPedm 
           BREAK BY FacDPedm.CodCia
                 BY FacDPedm.AlmDes : 
      IF FIRST-OF(FacDPedm.AlmDes) OR L-NewPed THEN DO:
         I-NPED = I-NPED + 1.
         CREATE T-CPEDM.
         ASSIGN T-CPEDM.NroPed   = SUBSTRING(FacCPedm.NroPed,1,3) + STRING(I-NPED,"999999")
                T-CPEDM.CodAlm   = FacDPedm.AlmDes
                T-CPEDM.Cmpbnte  = Faccpedm.Cmpbnte 
                T-CPEDM.CodAlm   = Faccpedm.CodAlm
                T-CPEDM.CodCia   = Faccpedm.CodCia 
                T-CPEDM.CodCli   = Faccpedm.CodCli 
                T-CPEDM.CodDiv   = Faccpedm.CodDiv 
                T-CPEDM.CodDoc   = Faccpedm.CodDoc 
                T-CPEDM.CodMon   = Faccpedm.CodMon 
                T-CPEDM.CodTrans = Faccpedm.CodTrans 
                T-CPEDM.CodVen   = Faccpedm.CodVen 
                T-CPEDM.DirCli   = Faccpedm.DirCli 
                T-CPEDM.DocDesp  = Faccpedm.DocDesp 
                T-CPEDM.FchPed   = Faccpedm.FchPed 
                T-CPEDM.FlgEst   = Faccpedm.FlgEst 
                T-CPEDM.FmaPgo   = Faccpedm.FmaPgo 
                T-CPEDM.Glosa    = Faccpedm.Glosa 
                T-CPEDM.Hora     = Faccpedm.Hora 
                T-CPEDM.LugEnt   = Faccpedm.LugEnt
                T-CPEDM.NomCli   = Faccpedm.NomCli 
                T-CPEDM.PorDto   = Faccpedm.PorDto 
                T-CPEDM.PorIgv   = Faccpedm.PorIgv
                T-CPEDM.RucCli   = Faccpedm.RucCli 
                T-CPEDM.TipVta   = Faccpedm.TipVta 
                T-CPEDM.TpoCmb   = Faccpedm.TpoCmb 
                T-CPEDM.UsrDscto = Faccpedm.UsrDscto 
                T-CPEDM.usuario  = Faccpedm.usuario
                T-CPEDM.ImpBrt   = 0
                T-CPEDM.ImpDto   = 0
                T-CPEDM.ImpExo   = 0
                T-CPEDM.ImpIgv   = 0
                T-CPEDM.ImpIsc   = 0
                T-CPEDM.ImpTot   = 0
                T-CPEDM.ImpVta   = 0.
         F-IGV = 0.
         F-ISC = 0.
         L-NewPed = NO.
         I-NItem = 0.
      END.
      T-CPEDM.ImpDto = T-CPEDM.ImpDto + FacDPedm.ImpDto.
               F-IGV = F-IGV + FacDPedm.ImpIgv.
               F-ISC = F-ISC + FacDPedm.ImpIsc.
      T-CPEDM.ImpTot = T-CPEDM.ImpTot + FacDPedm.ImpLin.
      IF NOT FacDPedm.AftIgv THEN T-CPEDM.ImpExo = T-CPEDM.ImpExo + FacDPedm.ImpLin.
      CREATE T-DPEDM.
      RAW-TRANSFER FacDPedm TO T-DPEDM.
      ASSIGN T-DPEDM.NroPed = T-CPEDM.NroPed.
      I-NItem = I-NItem + 1.
      IF ( T-CPEDM.Cmpbnte = "BOL" AND I-NItem >= FacCfgGn.Items_Boleta ) OR 
         ( T-CPEDM.Cmpbnte = "FAC" AND I-NItem >= FacCfgGn.Items_Factura ) THEN DO:
         L-NewPed = YES.
      END.
      IF LAST-OF(FacDPedm.AlmDes) OR L-NewPed THEN DO:
         ASSIGN T-CPEDM.ImpIgv = ROUND(F-IGV,2).
                T-CPEDM.ImpIsc = ROUND(F-ISC,2).
                T-CPEDM.ImpBrt = T-CPEDM.ImpTot - T-CPEDM.ImpIgv - T-CPEDM.ImpIsc + 
                                 T-CPEDM.ImpDto - T-CPEDM.ImpExo.
                T-CPEDM.ImpVta = T-CPEDM.ImpBrt - T-CPEDM.ImpDto.
      END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descarga-de-Almacen L-table-Win 
PROCEDURE Descarga-de-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
   DEF VAR 
   FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
       FIND CcbCDocu WHERE 
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDoc = T-CPEDM.CodRef AND
            CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
       IF AVAILABLE CcbCDocu THEN  DO:
          /* Correlativo de Salida */
          FIND Almacen WHERE 
               Almacen.CodCia = CcbCDocu.CodCia AND  
               Almacen.CodAlm = CcbCDocu.CodAlm  EXCLUSIVE-LOCK NO-ERROR.
          CREATE Almcmov.
          ASSIGN Almcmov.CodCia  = CcbCDocu.CodCia
                 Almcmov.CodAlm  = CcbCDocu.CodAlm
                 Almcmov.TipMov  = "S"
                 Almcmov.CodMov  = CcbCDocu.CodMov
                 Almcmov.NroSer  = S-PtoVta
                 Almcmov.NroDoc  = Almacen.CorrSal
                 Almcmov.CodRef  = CcbCDocu.CodDoc
                 Almcmov.NroRef  = CcbCDocu.NroDoc
                 Almcmov.NroRf1  = SUBSTRING(CcbCDocu.CodDoc,1,1) + CcbCDocu.NroDoc
                 Almcmov.NroRf2  = CcbCDocu.NroPed
                 Almcmov.Nomref  = CcbCDocu.NomCli
                 Almcmov.FchDoc  = TODAY
                 Almcmov.HorSal  = STRING(TIME, "HH:MM:SS")
                 Almcmov.CodVen  = Ccbcdocu.CodVen
                 Almcmov.CodCli  = Ccbcdocu.CodCli
                 Almcmov.usuario = S-User-Id
                 CcbcDocu.NroSal = STRING(Almcmov.NroDoc,"999999").
                 Almacen.CorrSal = Almacen.CorrSal + 1.
          RELEASE Almacen.
          FOR EACH ccbddocu OF ccbcdocu NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
              CREATE Almdmov.
              ASSIGN Almdmov.CodCia = AlmCmov.CodCia
                     Almdmov.CodAlm = AlmCmov.CodAlm
                     Almdmov.TipMov = AlmCmov.TipMov
                     Almdmov.CodMov = AlmCmov.CodMov
                     Almdmov.NroSer = Almcmov.NroSer
                     Almdmov.NroDoc = Almcmov.NroDoc
                     Almdmov.FchDoc = Almcmov.FchDoc
                     Almdmov.NroItm = i
                     Almdmov.codmat = ccbddocu.codmat
                     Almdmov.CanDes = ccbddocu.candes
                     Almdmov.AftIgv = ccbddocu.aftigv
                     Almdmov.AftIsc = ccbddocu.aftisc
                     Almdmov.CodMon = ccbcdocu.codmon
                     Almdmov.CodUnd = ccbddocu.undvta
                     Almdmov.Factor = ccbddocu.factor
                     Almdmov.ImpDto = ccbddocu.impdto
                     Almdmov.ImpIgv = ccbddocu.impigv
                     Almdmov.ImpIsc = ccbddocu.impisc
                     Almdmov.ImpLin = ccbddocu.implin
                     Almdmov.PorDto = ccbddocu.pordto
                     Almdmov.PreBas = ccbddocu.prebas
                     Almdmov.PreUni = ccbddocu.preuni
                     Almdmov.TpoCmb = ccbcdocu.tpocmb
                     Almcmov.TotItm = i
                     
                     i = i + 1.
              RUN alm/almdgstk (ROWID(almdmov)).
          END.
       END.
   END.
   RELEASE almcmov.
   RELEASE almdmov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI L-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden-Despacho L-table-Win 
PROCEDURE Genera-Orden-Despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR I-Nroped AS INTEGER NO-UNDO.
  DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
  F-CODDOC = 'O/D'.
  FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND CcbCDocu WHERE 
           CcbCDocu.CodCia = S-CodCia AND
           CcbCDocu.CodDoc = T-CPEDM.CodRef AND
           CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
      IF AVAILABLE CcbCDocu THEN  DO:
         FIND FacCorre WHERE 
              FacCorre.CodCia = S-CODCIA AND  
              FacCorre.CodDoc = F-CODDOC AND  
              FacCorre.CodDiv = S-CODDIV AND  
              Faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE FacCorre THEN DO:
           I-NroPed = FacCorre.Correlativo.
           CREATE FacCPedi.
           ASSIGN FacCPedi.CodCia = S-CodCia
                  FacCPedi.CodDoc = F-CodDoc
                  FacCPedi.NroPed = STRING(s-ptovta,"999") + STRING(I-NroPed,"999999")
                  FacCorre.Correlativo = FacCorre.Correlativo + 1.
         END.
         RELEASE FacCorre.
         ASSIGN FacCPedi.FchPed = CcbCDocu.FchDoc
                FacCPedi.CodAlm = CcbCDocu.CodAlm
                FacCPedi.PorIgv = CcbCDocu.PorIgv 
                FacCPedi.TpoCmb = CcbCDocu.TpoCmb
                FacCPedi.CodDiv = CcbCDocu.CodDiv
                FacCPedi.Nroref = CcbCDocu.NroPed
                FacCPedi.Tpoped = 'MOSTRADOR'
                FacCPedi.Hora   = STRING(TIME,"HH:MM")
                FacCPedi.TipVta = CcbCDocu.Tipvta
                FacCPedi.Codcli = CcbCDocu.Codcli
                FacCPedi.NomCli = CcbCDocu.Nomcli
                FacCPedi.DirCli = CcbCDocu.DirCli
                FacCPedi.Codven = CcbCDocu.Codven
                FacCPedi.Fmapgo = CcbCDocu.Fmapgo
                FacCPedi.Glosa  = CcbCDocu.Glosa
                FacCPedi.LugEnt = CcbCDocu.Lugent
                FacCPedi.ImpBrt = CcbCDocu.ImpBrt
                FacCPedi.ImpDto = CcbCDocu.ImpDto
                FacCPedi.ImpVta = CcbCDocu.ImpVta
                FacCPedi.ImpExo = CcbCDocu.ImpExo
                FacCPedi.ImpIgv = CcbCDocu.ImpIgv
                FacCPedi.ImpIsc = CcbCDocu.ImpIsc
                FacCPedi.ImpTot = CcbCDocu.ImpTot
                FacCPedi.Flgest = 'F'
                FacCPedi.Cmpbnte  = CcbCDocu.CodDoc
                FacCPedi.NCmpbnte = CcbCDocu.Nrodoc
                FacCPedi.CodTrans = CcbCDocu.CodAge
                FacCPedi.Usuario  = S-USER-ID.
         FOR EACH CcbDDocu OF CcbCDocu BY NroItm:
             CREATE FacDPedi. 
             ASSIGN FacDPedi.CodCia = FacCPedi.CodCia 
                    FacDPedi.coddoc = FacCPedi.coddoc 
                    FacDPedi.NroPed = FacCPedi.NroPed 
                    FacDPedi.FchPed = FacCPedi.FchPed
                    FacDPedi.Hora   = FacCPedi.Hora 
                    FacDPedi.FlgEst = FacCPedi.FlgEst
                    FacDPedi.codmat = CcbDDocu.codmat 
                    FacDPedi.Factor = CcbDDocu.Factor 
                    FacDPedi.CanPed = CcbDDocu.CanDes
                    FacDPedi.ImpDto = CcbDDocu.ImpDto 
                    FacDPedi.ImpLin = CcbDDocu.ImpLin 
                    FacDPedi.PorDto = CcbDDocu.PorDto 
                    FacDPedi.PorDto2 = CcbDDocu.PorDto2 
                    FacDPedi.PreUni = CcbDDocu.PreUni 
                    FacDPedi.UndVta = CcbDDocu.UndVta 
                    FacDPedi.AftIgv = CcbDDocu.AftIgv 
                    FacDPedi.AftIsc = CcbDDocu.AftIsc 
                    FacDPedi.ImpIgv = CcbDDocu.ImpIgv 
                    FacDPedi.ImpIsc = CcbDDocu.ImpIsc 
                    FacDPedi.PreBas = CcbDDocu.PreBas. 
         END.
         ASSIGN CcbCDocu.CodRef = FacCPedi.CodDoc
                CcbCDocu.NroRef = FacCPedi.NroPed.
      END.
      RELEASE CcbCDocu.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-a-Caja L-table-Win 
PROCEDURE Ingreso-a-Caja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO ON ERROR UNDO, RETURN "ADM-ERROR":
       FIND Faccorre WHERE 
            FacCorre.CodCia = s-codcia AND  
            FacCorre.CodDoc = "I/C"    AND  
            FacCorre.NroSer = s-sercja AND  
            FacCorre.CodDiv = s-coddiv EXCLUSIVE-LOCK NO-ERROR.
           
       FIND FIRST T-CcbCCaja.
       
       CREATE CcbCCaja.
       ASSIGN CcbCCaja.CodCia    = S-CodCia
              CcbCCaja.CodDiv    = S-CodDiv 
              CcbCCaja.CodDoc    = "I/C"
              CcbCCaja.NroDoc    = STRING(FacCorre.NroSer, "999") + STRING(FacCorre.Correlativo, "999999")
              FacCorre.Correlativo = FacCorre.Correlativo + 1
              CcbCCaja.CodCli     = B-PedM.codcli
              CcbCCaja.NomCli     = B-PedM.NomCli
              CcbCCaja.CodMon     = B-PedM.CodMon
              CcbCCaja.FchDoc     = TODAY
              CcbCCaja.CodBco[2]  = T-CcbCCaja.CodBco[2] 
              CcbCCaja.CodBco[3]  = T-CcbCCaja.CodBco[3] 
              CcbCCaja.CodBco[4]  = T-CcbCCaja.CodBco[4] 
              CcbCCaja.CodBco[5]  = T-CcbCCaja.CodBco[5] 
              CcbCCaja.ImpNac[1]  = T-CcbCCaja.ImpNac[1] 
              CcbCCaja.ImpNac[2]  = T-CcbCCaja.ImpNac[2] 
              CcbCCaja.ImpNac[3]  = T-CcbCCaja.ImpNac[3] 
              CcbCCaja.ImpNac[4]  = T-CcbCCaja.ImpNac[4] 
              CcbCCaja.ImpNac[5]  = T-CcbCCaja.ImpNac[5] 
              CcbCCaja.ImpNac[6]  = T-CcbCCaja.ImpNac[6] 
              CcbCCaja.ImpUsa[1]  = T-CcbCCaja.ImpUsa[1] 
              CcbCCaja.ImpUsa[2]  = T-CcbCCaja.ImpUsa[2] 
              CcbCCaja.ImpUsa[3]  = T-CcbCCaja.ImpUsa[3]
              CcbCCaja.ImpUsa[4]  = T-CcbCCaja.ImpUsa[4] 
              CcbCCaja.ImpUsa[5]  = T-CcbCCaja.ImpUsa[5] 
              CcbCCaja.ImpUsa[6]  = T-CcbCCaja.ImpUsa[6] 
              CcbCcaja.Tipo       = IF S-CODDOC = "FAC" THEN "CAFA" ELSE "CABO" 
              CcbCCaja.CodCaja    = S-CODTER
              CcbCCaja.TpoCmb     = T-CcbCCaja.TpoCmb
              CcbCCaja.usuario    = s-user-id
              CcbCCaja.Voucher[2] = T-CcbCCaja.Voucher[2]
              CcbCCaja.Voucher[3] = T-CcbCCaja.Voucher[3]
              CcbCCaja.Voucher[4] = T-CcbCCaja.Voucher[4] 
              CcbCCaja.Voucher[5] = T-CcbCCaja.Voucher[5] 
              CcbCCaja.Voucher[6] = T-CcbCCaja.Voucher[6] 
              CcbCCaja.FchVto[2]  = T-CcbCCaja.FchVto[2]
              CcbCCaja.FchVto[3]  = T-CcbCCaja.FchVto[3]
              CcbCCaja.VueNac     = T-CcbCCaja.VueNac 
              CcbCCaja.VueUsa     = T-CcbCCaja.VueUsa
              CcbCCaja.FLGEST     = "C".
       RELEASE faccorre.
       FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
           FIND CcbCDocu WHERE 
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDoc = T-CPEDM.CodRef AND
                CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
           IF AVAILABLE CcbCDocu THEN  DO:
              CREATE CcbDCaja.
              ASSIGN CcbDCaja.CodCia = S-CodCia
                     CcbDCaja.CodDoc = CcbCCaja.CodDoc
                     CcbDCaja.NroDoc = CcbCCaja.NroDoc
                     CcbDCaja.CodRef = CcbCDocu.CodDoc
                     CcbDCaja.NroRef = CcbCDocu.NroDoc
                     CcbDCaja.CodCli = CcbCDocu.CodCli
                     CcbDCaja.CodMon = CcbCDocu.CodMon
                     CcbDCaja.FchDoc = CcbCCaja.FchDoc
                     CcbDCaja.ImpTot = CcbCDocu.ImpTot
                     CcbDCaja.TpoCmb = CcbCCaja.TpoCmb
                     CcbCDocu.FlgEst = "C"
                     CcbCDocu.FchCan = TODAY
                     CcbCDocu.SdoAct = 0.
           END.
           RELEASE CcbCDocu.
       END.
       RELEASE ccbccaja.
       RELEASE ccbdcaja.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize L-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    RUN get-attribute ('Keys-Accepted').

    IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            CMB-filtro:LIST-ITEMS = CMB-filtro:LIST-ITEMS + "," + RETURN-VALUE.
        CMB-filtro = ENTRY(2,CMB-filtro:LIST-ITEMS).
    END.
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN
        output-var-1 = ?
        output-var-2 = ?
        output-var-3 = ?.
        
  {&BROWSE-NAME}:REFRESHABLE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key L-table-Win adm/support/_key-snd.p
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records L-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Faccpedm"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed L-table-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toma-handle L-table-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _xxxxxx L-table-Win 
PROCEDURE _xxxxxx :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  DEFINE VARIABLE D-ROWID AS ROWID NO-UNDO.
 *   
 *   /****     Borra Temporal  ****/
 *   FOR EACH temporal:
 *     DELETE temporal.
 *   END.
 *   /*****************************/
 *   
 *   D-ROWID = ROWID(faccpedm).
 *   
 *   FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID NO-LOCK NO-ERROR. 
 *   
 *   RUN ccb\Canc_Ped ( D-ROWID, OUTPUT L-OK).
 *  
 *   IF L-OK = NO THEN RETURN "ADM-ERROR".
 *   
 *   S-CODDOC = B-PedM.Cmpbnte.
 *   
 *   DO TRANSACTION ON ERROR UNDO, RETURN ERROR:
 *      RUN Captura-Configuracion.
 *      
 *      FIND B-PedM WHERE ROWID(B-PedM) = D-ROWID EXCLUSIVE-LOCK . 
 *      s-codalm = B-PedM.codalm.   /* << OJO << lo tomamos del pedido */
 * 
 *      CREATE CcbCDocu.
 *      FIND faccorre WHERE faccorre.codcia = s-codcia 
 *                     AND  faccorre.coddoc = s-coddoc 
 *                     AND  faccorre.NroSer = s-ptovta 
 *                    EXCLUSIVE-LOCK NO-ERROR.
 *      IF AVAILABLE faccorre THEN 
 *         ASSIGN
 *              ccbcdocu.nrodoc = STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999")
 *              faccorre.correlativo = faccorre.correlativo + 1.
 *      RELEASE faccorre.
 * 
 *      ASSIGN 
 *         CcbCDocu.CodCia = s-codcia
 *         CcbCDocu.CodDoc = s-coddoc
 *         CcbCDocu.usuario= s-user-id
 *         CcbCDocu.usrdscto = B-PedM.usrdscto 
 *         CcbCDocu.Tipo   = s-tipo
 *         CcbCDocu.CodAlm = s-codalm
 *         CcbCDocu.CodDiv = s-coddiv
 *         CcbCDocu.CodCli = B-PedM.Codcli
 *         CcbCDocu.RucCli = B-PedM.RucCli
 *         CcbCDocu.NomCli = B-PedM.Nomcli
 *         CcbCDocu.DirCli = B-PedM.DirCli
 *         CcbCDocu.CodMon = B-PedM.codmon
 *         CcbCDocu.CodMov = s-codmov
 *         CcbCDocu.CodPed = B-PedM.coddoc
 *         CcbCDocu.CodVen = B-PedM.codven
 *         CcbCDocu.FchCan = TODAY
 *         CcbCDocu.FchDoc = TODAY
 *         CcbCDocu.FchVto = TODAY
 *         CcbCDocu.ImpBrt = B-PedM.impbrt
 *         CcbCDocu.ImpDto = B-PedM.impdto
 *         CcbCDocu.ImpExo = B-PedM.impexo
 *         CcbCDocu.ImpIgv = B-PedM.impigv
 *         CcbCDocu.ImpIsc = B-PedM.impisc
 *         CcbCDocu.ImpTot = B-PedM.imptot
 *         CcbCDocu.ImpVta = B-PedM.impvta
 *         CcbCDocu.TipVta = "1"
 *         CcbCDocu.TpoFac = "C"
 *         CcbCDocu.FmaPgo = "000"
 *         CcbCDocu.NroPed = B-PedM.nroped
 *         CcbCDocu.PorIgv = B-PedM.porigv 
 *         CcbCDocu.SdoAct = B-PedM.imptot
 *         CcbCDocu.TpoCmb = B-PedM.tpocmb.
 *         /* POR AHORA GRABAMOS EL TIPO DE ENTREGA */
 *         CcbCDocu.CodAge =  B-PedM.CodTrans.
 *         CcbCDocu.FlgSit =  IF B-PedM.DocDesp = "GUIA" THEN "G" ELSE "".
 *         CcbCDocu.FlgCon =  IF B-PedM.DocDesp = "GUIA" THEN "G" ELSE "".
 *        
 *       /* ACTUALIZAMOS EL PEDIDO  DE MOSTRADOR */
 *       ASSIGN  B-PedM.flgest = "C".
 *       
 *       /* actualizamos el detalle */
 *       DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.
 *       FOR EACH facdpedm OF B-PedM BY nroitm:
 *           CREATE ccbDDocu.
 *           ASSIGN
 *               CcbDDocu.CodCia = ccbcdocu.codcia
 *               CcbDDocu.CodDoc = ccbcdocu.coddoc
 *               CcbDDocu.NroDoc = ccbcdocu.nrodoc
 *               CcbDDocu.codmat = facdpedm.codmat
 *               CcbDDocu.Factor = facdpedm.factor
 *               CcbDDocu.ImpDto = facdpedm.impdto
 *               CcbDDocu.ImpIgv = facdpedm.impigv
 *               CcbDDocu.ImpIsc = facdpedm.impisc
 *               CcbDDocu.ImpLin = facdpedm.implin
 *               CcbDDocu.AftIgv = facdpedm.aftigv
 *               CcbDDocu.AftIsc = facdpedm.aftisc
 *               CcbDDocu.CanDes = facdpedm.canped
 *               CcbDDocu.NroItm = i
 *               CcbDDocu.PorDto = facdpedm.pordto
 *               CcbDDocu.PreBas = facdpedm.prebas
 *               CcbDDocu.PreUni = facdpedm.preuni
 *               CcbDDocu.PreVta[1] = facdpedm.prevta[1]
 *               CcbDDocu.PreVta[2] = facdpedm.prevta[2]
 *               CcbDDocu.PreVta[3] = facdpedm.prevta[3]
 *               CcbDDocu.UndVta = facdpedm.undvta
 *               CcbDDocu.AlmDes = facdpedm.AlmDes
 *               i = i + 1.
 *       END.
 *       
 *       RELEASE B-PedM.
 *       
 *       /* Cancelacion del documento */
 *       RUN Ingreso-a-Caja.
 *       /* Orden de despacho al almacen */
 * /*      RUN Orden-de-despacho.*/
 *       /* Generar Asignacion de Nota de Credito */
 *       IF T-CcbCCaja.Voucher[6] <> ' ' AND
 *          (T-CcbCCaja.ImpNac[6] + T-CcbCCaja.ImpUsa[6]) > 0 THEN 
 *          RUN Cancelar_Documento.
 *   END.
 *   
 *   IF AVAILABLE CcbCDocu THEN  DO:
 *      CASE Ccbcdocu.CodDoc:
 *             WHEN "FAC" THEN
 *                   RUN ccb/r-fact01 (ROWID(ccbcdocu)).
 *             WHEN "BOL" THEN
 *                   RUN ccb/r-bole01 (ROWID(ccbcdocu)).
 *      END CASE.
 *      
 *      /****  Add by C.Q. 24/01/2000  ****/
 *      /****  para poder direccionar la guia de despacho a su respectivo almacen  ****/
 *      FOR EACH ccbDdocu OF ccbcdocu BY nroitm:
 *         FIND temporal WHERE t-CodCia = ccbDdocu.CodCia 
 *                        AND  t-CodAlm = ccbDdocu.AlmDes
 *                        AND  t-NroDoc = ccbDdocu.nrodoc
 *                       NO-ERROR.
 *         IF NOT AVAIL temporal THEN DO:
 *             CREATE temporal.
 *             ASSIGN t-CodCia = ccbDdocu.CodCia 
 *                    t-CodAlm = ccbDdocu.AlmDes
 *                    t-NroDoc = ccbDdocu.nrodoc.
 *         END.
 *      END.
 *      
 *      FOR EACH temporal NO-LOCK:
 *         RUN Orden-de-Despacho-Almacen (t-CodCia,
 *                                        t-CodAlm
 *                                        ).
 *      END.
 *      /**********************************/
 * /*     RUN ccb/r-guides  (ROWID(ccbcdocu)).*/
 * /*     RUN ccb/r-odesp  (ROWID(ccbcdocu)).*/
 *   END.
 * 
 * /*  /* ORDEN DE DESPACHO */
 *  *   s-coddoc = 'O/D'.
 *  *   RUN Captura-Configuracion.
 *  *   RUN Genera-Orden-Despacho. */
 *   
 *   RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


