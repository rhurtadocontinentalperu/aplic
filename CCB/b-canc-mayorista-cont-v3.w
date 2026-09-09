&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-VVALE NO-UNDO LIKE VtaVVale.



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
DEFINE VARIABLE cNomcli AS CHAR NO-UNDO.
DEFINE VARIABLE L-OK  AS LOGICAL NO-UNDO.

/* BUFFERS DE TRABAJO */
DEFINE BUFFER B-CPEDM FOR FacCPedi.
DEFINE BUFFER B-DPEDM FOR FacDPedi.

DEFINE SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

/* TEMPORALES DE ORDENES DE DESPACHO */
DEFINE TEMP-TABLE T-CODES LIKE FacCPedi.
DEFINE TEMP-TABLE T-DODES LIKE FacDPedi.

/* TEMPORALES DE COMPROBANTES */
DEFINE TEMP-TABLE T-CDOCU /*NO-UNDO*/ LIKE CcbCDocu.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedi.
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedi.

/* Definicion de variables compartidas */
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
DEFINE SHARED VARIABLE s-codcja     AS CHAR.
DEFINE SHARED VARIABLE s-codcli     LIKE gn-clie.codcli.
DEFINE SHARED VARIABLE CL-CODCIA    AS INT.

DEFINE VAR cCodAlm AS CHAR NO-UNDO.
DEFINE VAR Fac_Rowid AS ROWID NO-UNDO.     /* COntrol de Cabecera de Comprobantes */

/* Se usa para las retenciones */
DEFINE NEW SHARED TEMP-TABLE wrk_ret NO-UNDO
    FIELDS CodCia LIKE CcbDCaja.CodCia
    FIELDS CodCli LIKE CcbCDocu.CodCli
    FIELDS CodDoc LIKE CcbCDocu.CodDoc COLUMN-LABEL "Tipo  "
    FIELDS NroDoc LIKE CcbCDocu.NroDoc COLUMN-LABEL "Documento " FORMAT "x(10)"
    FIELDS CodRef LIKE CcbDCaja.CodRef
    FIELDS NroRef LIKE CcbDCaja.NroRef
    FIELDS FchDoc LIKE CcbCDocu.FchDoc COLUMN-LABEL "    Fecha    !    Emisión    "
    FIELDS FchVto LIKE CcbCDocu.FchVto COLUMN-LABEL "    Fecha    ! Vencimiento"
    FIELDS CodMon AS CHARACTER COLUMN-LABEL "Moneda" FORMAT "x(3)"
    FIELDS ImpTot LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe Total"
    FIELDS ImpRet LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe!a Retener"
    FIELDS FchRet AS DATE
    FIELDS NroRet AS CHARACTER
    INDEX ind01 CodRef NroRef.

/* Se usa para las N/C */
DEFINE NEW SHARED TEMP-TABLE wrk_dcaja NO-UNDO LIKE ccbdcaja.

/* Preprocesadores para condiciones */
&SCOPED-DEFINE CONDICION ~
    (FacCPedi.CodCia = S-CODCIA AND FacCPedi.CodDoc = "P/M" ~
    AND FacCPedi.FlgEst = "P" AND FacCPedi.CodDiv = S-CODDIV AND ~
    FacCPedi.FchPed = TODAY AND FacCPedi.Cmpbnte BEGINS radio-set-1)
&SCOPED-DEFINE CODIGO FacCPedi.NroPed


/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 (FacCPedi.NomCli BEGINS FILL-IN-filtro)
&SCOPED-DEFINE FILTRO2 (INDEX(FacCPedi.NomCli, FILL-IN-filtro) <> 0 )

/* VARIABLES PARA LA CANCELACION */
DEFINE VARIABLE list_docs   AS CHARACTER.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.
DEF VAR cMess   AS CHAR    NO-UNDO.
DEF VAR x-ImpTot LIKE ccbcdocu.imptot NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartLookup
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.NroPed FacCPedi.NomCli ~
C-MON @ C-MON FacCPedi.ImpTot + FacCPedi.AcuBon[5] @ x-ImpTot ~
FacCPedi.FchPed FacCPedi.Hora FacCPedi.Cmpbnte FacCPedi.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY FacCPedi.Hora INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY FacCPedi.Hora INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 CMB-filtro FILL-IN-filtro RADIO-SET-1 ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS CMB-filtro FILL-IN-filtro RADIO-SET-1 ~
FILL-IN_T_Venta FILL-IN_T_Compra FILL-IN-TotMn FILL-IN-TotMe 

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
Nombres que inicien con|y||integral.FacCPedi.NomCli
Nombres que contengan|y||integral.FacCPedi.NomCli
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
Nombre|y||integral.FacCPedi.CodCia|yes,integral.FacCPedi.NomCli|yes
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
     DROP-DOWN-LIST
     SIZE 21.29 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotMe AS DECIMAL FORMAT "->>,>>9.99":U INITIAL ? 
     LABEL "Total US$" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotMn AS DECIMAL FORMAT "->>,>>9.99":U INITIAL ? 
     LABEL "Total S/." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN_T_Compra AS DECIMAL FORMAT "->>,>>9.999" INITIAL 0 
     LABEL "T/C Compra" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .69
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN_T_Venta AS DECIMAL FORMAT "->>,>>9.999" INITIAL 0 
     LABEL "T/C Venta" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .69
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE RADIO-SET-1 AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "",
"Fac", "FAC":U,
"Bol", "BOL":U,
"Tck", "TCK":U
     SIZE 23.29 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 15.77.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.NroPed FORMAT "XXX-XXXXXXXX":U
      FacCPedi.NomCli COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(35)":U
            WIDTH 29.29
      C-MON @ C-MON COLUMN-LABEL "Mon" FORMAT "X(4)":U COLUMN-FONT 1
      FacCPedi.ImpTot + FacCPedi.AcuBon[5] @ x-ImpTot COLUMN-LABEL "Importe Total" FORMAT "->>>>,>>9.99":U
      FacCPedi.FchPed COLUMN-LABEL "Fecha de     !Emision" FORMAT "99/99/9999":U
      FacCPedi.Hora COLUMN-LABEL "Hora!Emision" FORMAT "X(5)":U
      FacCPedi.Cmpbnte COLUMN-LABEL "Com." FORMAT "X(3)":U
      FacCPedi.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
            WIDTH 7.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 82 BY 13.04
         BGCOLOR 15 FGCOLOR 0 FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CMB-filtro AT ROW 1.38 COL 3.14 NO-LABEL
     FILL-IN-filtro AT ROW 1.42 COL 24.57 NO-LABEL
     RADIO-SET-1 AT ROW 1.42 COL 60.29 NO-LABEL
     br_table AT ROW 2.31 COL 3
     FILL-IN_T_Venta AT ROW 15.62 COL 15 COLON-ALIGNED
     FILL-IN_T_Compra AT ROW 15.62 COL 35 COLON-ALIGNED
     FILL-IN-TotMn AT ROW 15.62 COL 52 COLON-ALIGNED
     FILL-IN-TotMe AT ROW 15.62 COL 71 COLON-ALIGNED
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
   Temp-Tables and Buffers:
      TABLE: T-VVALE T "NEW SHARED" NO-UNDO INTEGRAL VtaVVale
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
  CREATE WINDOW L-table-Win ASSIGN
         HEIGHT             = 15.77
         WIDTH              = 86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB L-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW L-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table RADIO-SET-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-TotMe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotMn IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_T_Compra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_T_Venta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _OrdList          = "integral.FacCPedi.Hora|yes"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > integral.FacCPedi.NroPed
"FacCPedi.NroPed" ? "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre o Razon Social" "x(35)" "character" ? ? ? ? ? ? no ? no no "29.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"C-MON @ C-MON" "Mon" "X(4)" ? ? ? 1 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"FacCPedi.ImpTot + FacCPedi.AcuBon[5] @ x-ImpTot" "Importe Total" "->>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha de     !Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.FacCPedi.Hora
"FacCPedi.Hora" "Hora!Emision" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.FacCPedi.Cmpbnte
"FacCPedi.Cmpbnte" "Com." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.FacCPedi.usuario
"FacCPedi.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table L-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
OR "RETURN":U OF br_table DO:
    RUN proc_CanPed.
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
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE AND
        Radio-Set-1 = Radio-Set-1:SCREEN-VALUE THEN RETURN.

    ASSIGN
        FILL-IN-filtro
        CMB-filtro
        Radio-Set-1.
        
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).

    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN proc_CalTot.

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


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 L-table-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK L-table-Win 


ON FIND OF FacCPedi DO:
    C-MON = "S/.".
    IF FacCPedi.CodMon = 2 THEN C-MON = "US$".
END.

/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases L-table-Win  adm/support/_adm-opn.p
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
           &Scope SORTBY-PHRASE BY FacCPedi.CodCia BY FacCPedi.NomCli
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
           &Scope SORTBY-PHRASE BY FacCPedi.CodCia BY FacCPedi.NomCli
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
           &Scope SORTBY-PHRASE BY FacCPedi.CodCia BY FacCPedi.NomCli
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available L-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Comprobantes L-table-Win 
PROCEDURE Crea-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-items AS INT NO-UNDO.
DEFINE VARIABLE X_cto1 AS DEC NO-UNDO.
DEFINE VARIABLE X_cto2 AS DEC NO-UNDO.
DEFINE VARIABLE x-ImporteAcumulado AS DEC NO-UNDO.

/* CONSISTENCIA */
FOR EACH T-CODES NO-LOCK, FIRST FacCPedi WHERE FacCPedi.codcia = T-CODES.codcia
    AND FacCPedi.coddiv = T-CODES.coddiv
    AND FacCPedi.coddoc = T-CODES.coddoc
    AND FacCPedi.nroped = T-CODES.nroped
    NO-LOCK:
    /* Verifica Detalle */
    FOR EACH FacDPedi OF FacCPedi NO-LOCK BY FacDPedi.NroItm:
        FIND Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia 
            AND Almmmate.CodAlm = FacDPedi.AlmDes 
            AND Almmmate.codmat = FacDPedi.CodMat 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            MESSAGE "Artículo" FacDPedi.CodMat "NO está asignado al almacén" Faccpedi.codalm SKIP
                'Proceso abortado'
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
/*  FIN DE CONSISTENCIA */
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FILL-IN-items = 999.
IF s-coddoc = 'BOL' THEN FILL-IN-items = FacCfgGn.Items_Boleta.
IF s-coddoc = 'FAC' THEN FILL-IN-items = FacCfgGn.Items_Factura.
/* ***************************************************************************** */
TRLOOP:    
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    EMPTY TEMP-TABLE T-CDOCU.
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = s-CodDoc AND
        FacCorre.NroSer = s-PtoVta
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquear el correlativo para' s-coddoc SKIP
            'de la serie' s-ptovta SKIP
            'proceso abortado'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FOR EACH T-CODES NO-LOCK, FIRST FacCPedi NO-LOCK WHERE FacCPedi.codcia = T-CODES.codcia
        AND FacCPedi.coddiv = T-CODES.coddiv
        AND FacCPedi.coddoc = T-CODES.coddoc
        AND FacCPedi.nroped = T-CODES.nroped:
        ASSIGN
            lCreaHeader = TRUE
            lItemOk     = FALSE.
        FOR EACH FacDPedi OF FacCPedi NO-LOCK,
            FIRST Almmmatg OF FacDPedi NO-LOCK,
            FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = FacDPedi.CodCia 
                AND Almmmate.CodAlm = FacDPedi.AlmDes
                AND Almmmate.CodMat = FacDPedi.CodMat
            BREAK BY FacDPedi.CodCia BY FacDPedi.CodMat:
            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera del Comprobante */
                RUN proc_CreaCabecera.
                ASSIGN
                    x_cto1 = 0
                    x_cto2 = 0
                    iCountItem = 1
                    lCreaHeader = FALSE
                    x-ImporteAcumulado = 0.
            END.
            /* Crea Detalle */
            FIND CcbCDocu WHERE ROWID(CcbCDocu) = Fac_Rowid.
            CREATE CcbDDocu.
            BUFFER-COPY Facdpedi 
                TO CcbDDocu
                ASSIGN
                    CcbDDocu.NroItm = iCountItem
                    CcbDDocu.CodCia = CcbCDocu.CodCia
                    CcbDDocu.Coddoc = CcbCDocu.Coddoc
                    CcbDDocu.NroDoc = CcbCDocu.NroDoc 
                    CcbDDocu.FchDoc = CcbCDocu.FchDoc
                    CcbDDocu.CodDiv = CcbcDocu.CodDiv
                    Ccbddocu.CanDes = Facdpedi.CanPed
                    Ccbddocu.Factor = Facdpedi.Factor
                    Ccbddocu.UndVta = Facdpedi.UndVta
                    Ccbddocu.ImpIgv = Facdpedi.ImpIgv
                    Ccbddocu.ImpIsc = Facdpedi.ImpIsc
                    Ccbddocu.ImpDto = Facdpedi.ImpDto
                    Ccbddocu.ImpLin = Facdpedi.ImpLin.
            /* *********************************************** */
            x-ImporteAcumulado = x-ImporteAcumulado + Facdpedi.ImpLin.
            /* Contador de registros válidos */
            iCountItem = iCountItem + 1.
            /* Guarda Costos */
            IF almmmatg.monvta = 1 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor,2).
                x_cto2 = ROUND((Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor) / Almmmatg.Tpocmb,2).
            END.
            IF almmmatg.monvta = 2 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor * Almmmatg.TpoCmb, 2).
                x_cto2 = ROUND((Almmmatg.Ctotot * CcbDDocu.CanDes * CcbDDocu.Factor), 2).
            END.
            ASSIGN
                CcbDDocu.ImpCto = ( IF CcbCDocu.Codmon = 1 THEN x_cto1 ELSE x_cto2 )
                CcbCDocu.ImpCto = CcbCDocu.ImpCto + CcbDDocu.ImpCto.
            /* ************** */
            IF iCountItem > FILL-IN-items OR LAST-OF(FacDPedi.CodCia) THEN DO:
                RUN Graba-Totales-Factura.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
            END.
            IF iCountItem > FILL-IN-items THEN DO:
                iCountItem = 1.
                lCreaHeader = TRUE.
            END.
        END. /* FOR EACH FacDPedi... */
    END.    /* FOR EACH T-CODES */
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Ordenes L-table-Win 
PROCEDURE Crea-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x_igv AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x_isc AS DECIMAL NO-UNDO.
    DEFINE VARIABLE i_NPed   AS INTEGER INIT 0.
    DEFINE VARIABLE i_NItem  AS INTEGER INIT 0.

    DEFINE VARIABLE s-NroSer LIKE FacCorre.NroSer.

    EMPTY TEMP-TABLE T-CODES.
    EMPTY TEMP-TABLE T-DODES.

    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

    DEFINE VARIABLE s-CodDoc AS CHAR NO-UNDO.
    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
    DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
    DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.

    /* GENERAMOS UNA O/M POR CADA ALMACÉN */
    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
        ASSIGN
            s-CodDoc = "O/M".               /* ORDEN DE DESPACHO MOSTRADOR */
        FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
            FacCorre.CodDoc = S-CODDOC AND
            FacCorre.CodDiv = s-CodDiv AND
            FacCorre.FlgEst = YES
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccorre THEN DO:
            MESSAGE 'NO está configurado el correlativo para el documento' s-coddoc SKIP
                'para la división' s-coddiv
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            s-NroSer = FacCorre.NroSer.
        /* Barremos el P/M */
        FOR EACH B-DPEDM OF B-CPEDM NO-LOCK,
            FIRST Almacen NO-LOCK WHERE Almacen.codcia = B-DPEDM.codcia
            AND Almacen.codalm = B-DPEDM.almdes
            BREAK BY Almacen.codalm: 
            IF FIRST-OF(Almacen.CodAlm) THEN DO:
                {vtagn/i-faccorre-01.i &Codigo = s-CodDoc &Serie = s-NroSer }
                I-NITEM = 0.
                CREATE FacCPedi.
                BUFFER-COPY B-CPEDM
                    EXCEPT 
                    B-CPEDM.FlgEst
                    B-CPEDM.FlgSit
                    TO FacCPedi
                    ASSIGN 
                    FacCPedi.CodCia = S-CODCIA
                    FacCPedi.CodDiv = S-CODDIV
                    FacCPedi.CodDoc = s-coddoc 
                    FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                    FacCorre.Correlativo = FacCorre.Correlativo + 1
                    FacCPedi.DivDes = Almacen.CodDiv    /* <<< OJO <<< */
                    FacCPedi.CodAlm = Almacen.CodAlm    /* <<< OJO <<< */
                    FacCPedi.FlgEst = 'P'               
                    FacCPedi.CodRef = B-CPEDM.CodDoc    /* El Pedido */
                    FacCPedi.NroRef = B-CPEDM.NroPed
                    FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
                    FacCPedi.Hora = STRING(TIME,"HH:MM")
                    FacCPedi.FchPed = TODAY
                    FacCPedi.FchVen = TODAY.
                /* RHC solo cuando es por enviar */
                IF FacCPedi.FlgEnv = YES THEN DO:
                    FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
                        AND gn-divi.coddiv = Faccpedi.divdes
                        NO-LOCK.
                    ASSIGN
                        s-FlgPicking = GN-DIVI.FlgPicking
                        s-FlgBarras  = GN-DIVI.FlgBarras
                        FacCPedi.FchVen = TODAY + GN-DIVI.DiasVtoO_D.
                    IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pickear */
                    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
                    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Picking OK */
                END.
                ELSE FacCPedi.FlgSit = "C".    /* Barras OK */
                /* ****************************** */
                /* TRACKING */
                RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                                        Faccpedi.CodDiv,
                                        Faccpedi.CodRef,
                                        Faccpedi.NroRef,
                                        s-User-Id,
                                        'GOD',
                                        'P',
                                        DATETIME(TODAY, MTIME),
                                        DATETIME(TODAY, MTIME),
                                        Faccpedi.CodDoc,
                                        Faccpedi.NroPed,
                                        Faccpedi.CodRef,
                                        Faccpedi.NroRef).
            END.
            I-NITEM = I-NITEM + 1.
            CREATE FacDPedi. 
            BUFFER-COPY B-DPEDM 
                EXCEPT B-DPEDM.CanAte
                TO FacDPedi
                ASSIGN  
                FacDPedi.CodCia  = FacCPedi.CodCia 
                FacDPedi.coddiv  = FacCPedi.coddiv 
                FacDPedi.coddoc  = FacCPedi.coddoc 
                FacDPedi.NroPed  = FacCPedi.NroPed 
                FacDPedi.FchPed  = FacCPedi.FchPed
                FacDPedi.Hora    = FacCPedi.Hora 
                FacDPedi.FlgEst  = FacCPedi.FlgEst
                FacDPedi.NroItm  = I-NITEM
                FacDPedi.CanPick = B-DPEDM.CanPed.     /* <<< OJO <<< */
            /* ******************************************* */
            CREATE T-DODES.
            BUFFER-COPY FacDPedi TO T-DODES.
            IF LAST-OF(Almacen.CodAlm) THEN DO:
                {vta2/graba-totales-cotizacion-cred.i}
                /* TEMPORAL DE CONTROL */
                CREATE T-CODES.
                BUFFER-COPY FacCPedi TO T-CODES.
            END.
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI L-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Documentos-Anexos L-table-Win 
PROCEDURE Documentos-Anexos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cliename    LIKE Gn-Clie.Nomcli.
DEFINE VARIABLE clieruc     LIKE Gn-Clie.Ruc.
DEFINE VARIABLE NroDocCja   AS CHARACTER.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND FIRST T-CcbCCaja.
    /* Genera Cheque */
    IF ((T-CcbCCaja.Voucher[2] <> "") AND
        (T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2]) > 0) OR
        ((T-CcbCCaja.Voucher[3] <> "") AND
        (T-CcbCCaja.ImpNac[3] + T-CcbCCaja.ImpUsa[3]) > 0) THEN DO:
        FIND Gn-Clie WHERE
            Gn-Clie.Codcia = cl-codcia AND
            Gn-Clie.CodCli = T-CcbCCaja.Voucher[10]
            NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-Clie THEN
            ASSIGN
                cliename = Gn-Clie.Nomcli
                clieruc = Gn-Clie.Ruc.
        CREATE CcbCDocu.
        ASSIGN
            CcbCDocu.CodCia = S-CodCia
            CcbCDocu.CodDiv = S-CodDiv
            CcbCDocu.CodDoc = "CHC"
            CcbCDocu.CodCli = T-CcbCCaja.Voucher[10]
            CcbCDocu.NomCli = cliename
            CcbCDocu.RucCli = clieruc
            CcbCDocu.FlgEst = "P"
            CcbCDocu.Usuario = s-User-Id
            CcbCDocu.TpoCmb = T-CcbCCaja.TpoCmb
            CcbCDocu.FchDoc = TODAY.
        IF T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2] > 0 THEN
            ASSIGN
                CcbCDocu.NroDoc = T-CcbCCaja.Voucher[2]
                CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[2] <> 0 THEN 1 ELSE 2
                CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                    T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
                CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                    T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
                CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                    T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
                CcbCDocu.FchVto = T-CcbCCaja.FchVto[2].
        ELSE
            ASSIGN
                CcbCDocu.NroDoc = T-CcbCCaja.Voucher[3]
                CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[3] <> 0 THEN 1 ELSE 2
                CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                    T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
                CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                    T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
                CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                    T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
                CcbCDocu.FchVto = T-CcbCCaja.FchVto[3].
    END.

    /* Cancelacion del documento */
    NroDocCja = "".
    RUN proc_IngCja(OUTPUT NroDocCja).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    /* Actualiza la Boleta de Deposito */
    IF T-CcbCCaja.Voucher[5] <> "" AND
        (T-CcbCCaja.ImpNac[5] + T-CcbCCaja.ImpUsa[5]) > 0 THEN DO:
        RUN proc_AplicaDoc(
            "BD",
            T-CcbCCaja.Voucher[5],
            NroDocCja,
            T-CcbCCaja.tpocmb,
            T-CcbCCaja.ImpNac[5],
            T-CcbCCaja.ImpUsa[5]
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.

    /* Aplica Nota de Credito */
    IF CAN-FIND(FIRST wrk_dcaja) THEN DO:
        FOR EACH wrk_dcaja NO-LOCK,
            FIRST CcbCDocu WHERE CcbCDocu.CodCia = wrk_dcaja.CodCia
            AND CcbCDocu.CodCli = wrk_dcaja.CodCli
            AND CcbCDocu.CodDoc = wrk_dcaja.CodRef
            AND CcbCDocu.NroDoc = wrk_dcaja.NroRef NO-LOCK:
            RUN proc_AplicaDoc(
                CcbCDocu.CodDoc,
                CcbCDocu.NroDoc,
                NroDocCja,
                T-CcbCCaja.tpocmb,
                IF CcbCDocu.CodMon = 1 THEN wrk_dcaja.Imptot ELSE 0,
                IF CcbCDocu.CodMon = 2 THEN wrk_dcaja.Imptot ELSE 0
                ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
    END.

    /* Aplica de Anticipo */
    IF T-CcbCCaja.Voucher[7] <> "" AND
        (T-CcbCCaja.ImpNac[7] + T-CcbCCaja.ImpUsa[7]) > 0 THEN DO:
        RUN proc_AplicaDoc(
            "A/R",
            T-CcbCCaja.Voucher[7],
            NroDocCja,
            T-CcbCCaja.tpocmb,
            T-CcbCCaja.ImpNac[7],
            T-CcbCCaja.ImpUsa[7]
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.

    /* Retenciones */
    IF CAN-FIND(FIRST wrk_ret) THEN DO:
        FOR EACH wrk_ret:
            wrk_ret.NroRef = NroDocCja.
        END.
        RUN proc_CreaRetencion.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.

    /* PRE-PERCEPCIONES */
    RUN ccb/genera-prepercepciones ("I/C", NroDocCja).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales-Factura L-table-Win 
PROCEDURE Graba-Totales-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND CcbCDocu WHERE ROWID(CcbCDocu) = Fac_Rowid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE CcbCDocu THEN DO:
        MESSAGE 'NO se pudo actualizar los totales del comprobante' SKIP
            'Proceso abortado'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
                                                  
    /* graba totales de la factura */
    {vta2/graba-totales-factura-conta.i}

    /* Consistencia importe cero */
    IF Ccbcdocu.ImpTot <= 0 THEN DO:
        /* Verificamos si existen items en el comprobante */
        FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbddocu THEN DO:
            MESSAGE 'NO se ha grabado el detalle para la' Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
                'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        /* Verificamos importes del detalle */
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
            IF Ccbddocu.ImpLin > 0 THEN DO:
                MESSAGE 'Problemas con los totales de la' Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
                    'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
    END.

    /* Control de documentos */
    CREATE T-CDOCU.
    BUFFER-COPY CcbCDocu TO T-CDOCU.
    /* Descarga de Almacen */
    RUN vta2/act_alm (ROWID(CcbCDocu)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* ********* RHC 15/08/2012 MIGRACION A SYPSA ********* */
/*     RUN sypsa/registroventascontado ( ROWID(Ccbcdocu), "I", YES ) NO-ERROR. */
/*     IF ERROR-STATUS:ERROR THEN DO:                                          */
/*         MESSAGE 'ERROR al migrar la información a SYPSA' SKIP               */
/*             'Salir del sistema y volver a intentarlo'                       */
/*             VIEW-AS ALERT-BOX ERROR.                                        */
/*         UNDO, RETURN 'ADM-ERROR'.                                           */
/*     END.                                                                    */
    /* **************************************************** */
    RETURN 'OK'.

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
        
  {&BROWSE-NAME}:REFRESHABLE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query L-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN proc_CalTot.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc L-table-Win 
PROCEDURE proc_AplicaDoc :
/*------------------------------------------------------------------------------
  Purpose:     Crea INGRESO DE CAJA según parámetros
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    DEFINE BUFFER B-CDocu FOR CcbCDocu.

    /* Tipo de Documento */
    FIND FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = para_CodDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
            para_CodDoc 'NO CONFIGURADO'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        FIND FIRST B-CDocu WHERE
            B-CDocu.CodCia = s-codcia AND
            B-CDocu.CodDoc = para_CodDoc AND
            B-CDocu.NroDoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDocu THEN DO:
            MESSAGE
                "DOCUMENTO" para_CodDoc para_NroDoc "NO REGISTRADO"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = s-CodCja
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.
        IF FacDoc.TpoDoc THEN
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct + CCBDMOV.ImpTot.
        ELSE
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct - CCBDMOV.ImpTot.
        /* Cancela Documento */
        IF B-CDocu.SdoAct = 0 THEN
            ASSIGN 
                B-CDocu.FlgEst = "C"
                B-CDocu.FchCan = TODAY.
        ELSE
            ASSIGN
                B-CDocu.FlgEst = "P"
                B-CDocu.FchCan = ?.
        RELEASE B-CDocu.
        RELEASE Ccbdmov.
    END. /* DO TRANSACTION... */
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AsgPto L-table-Win 
PROCEDURE proc_AsgPto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR X_POR AS DECI INIT 0.

    FOR EACH T-CPEDM:
        X_POR = 0.
        T-CPEDM.AcuBon[1] = ROUND((T-CPEDM.imptot / 25 ),2) .
        IF T-CPEDM.CodMon = 2 THEN
            T-CPEDM.AcuBon[1] = ROUND(((T-CPEDM.imptot * T-CPEDM.Tpocmb) / 25 ),2).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CalTot L-table-Win 
PROCEDURE proc_CalTot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-SdoNac AS DEC NO-UNDO.
    DEF VAR x-SdoUsa AS DEC NO-UNDO.

    ASSIGN
        FILL-IN-TotMe = 0
        FILL-IN-TotMn = 0.

    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
    GET FIRST {&BROWSE-NAME}.

    REPEAT WHILE AVAILABLE FacCPedi:
        IF AVAILABLE Gn-Tccja THEN DO:    
            IF FacCPedi.codmon = 1 THEN
                ASSIGN
                    X-SdoNac = FacCPedi.imptot
                    X-SdoUsa = ROUND(FacCPedi.imptot / ROUND(Gn-Tccja.Compra,3),2).
            ELSE
                ASSIGN
                    X-SdoUsa = FacCPedi.imptot
                    X-SdoNac = ROUND(FacCPedi.imptot * ROUND(Gn-Tccja.Venta,3),2).
        END.
        ELSE DO:
            IF FacCPedi.codmon = 1 THEN
                ASSIGN
                    X-SdoNac = FacCPedi.imptot
                    X-SdoUsa = 0.
            ELSE
                ASSIGN
                    X-SdoUsa = FacCPedi.imptot
                    X-SdoNac = 0.
        END.
        ASSIGN
            FILL-IN-TotMn = FILL-IN-TotMn + x-SdoNac
            FILL-IN-TotMe = FILL-IN-TotMe + x-SdoUsa.
        GET NEXT {&BROWSE-NAME}.
    END.
    DISPLAY
        FILL-IN-TotMn
        FILL-IN-TotMe
        WITH FRAME {&FRAME-NAME}.

    /* Tipo de Cambio Caja */
    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-TcCja 
    THEN DISPLAY
            Gn-Tccja.Compra @ FILL-IN_T_Compra 
            Gn-Tccja.Venta  @ FILL-IN_T_Venta WITH FRAME {&FRAME-NAME}.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CanPed L-table-Win 
PROCEDURE proc_CanPed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE i           AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE d_rowid     AS ROWID NO-UNDO.
DEFINE VARIABLE monto_ret   AS DECIMAL NO-UNDO.

/* Importe del pedido en pantalla */
DEFINE VARIABLE x-Importe-Control   AS DEC NO-UNDO. 

/* PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

ASSIGN
    s-FechaI = DATETIME(TODAY, MTIME)
    list_docs = ''.

/* 09.09.09 CONSISTENCIA DEL PEDIDO MOSTRADOR */
IF NOT AVAILABLE FacCPedi THEN RETURN.
d_rowid = ROWID(FacCPedi).

/* AVISO DEL ADMINISTRADOR */
DEF VAR pRpta AS CHAR.
RUN ccb/d-msgblo (FacCPedi.codcli, FacCPedi.nrocard, OUTPUT pRpta).
IF pRpta = 'ADM-ERROR' THEN RETURN.
/* *********************** */

/* Verifica SENCILLO EN CAJA */
RUN proc_verifica_ic.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
FIND B-CPEDM WHERE ROWID(B-CPEDM) = d_rowid NO-LOCK NO-ERROR. 

/* NUMERO DE SERIE DEL COMPROBANTE PARA TERMINAL */
s-CodDoc = B-CPEDM.Cmpbnte.
FIND FIRST ccbdterm WHERE
    CcbDTerm.CodCia = s-codcia AND
    CcbDTerm.CodDiv = s-coddiv AND
    CcbDTerm.CodDoc = s-CodDoc AND
    CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm THEN DO:
    MESSAGE "DOCUMENTO" s-CodDoc "NO ESTA CONFIGURADO EN ESTE TERMINAL"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-PtoVta = Ccbdterm.nroser.
FIND faccorre WHERE faccorre.codcia = s-codcia AND
    faccorre.coddoc = s-Coddoc AND
    faccorre.coddiv = s-Coddiv AND
    faccorre.NroSer = s-ptovta NO-LOCK NO-ERROR.
IF NOT AVAILABLE faccorre THEN DO:
    MESSAGE "DOCUMENTO:" s-CodDoc "SERIE:" s-ptovta SKIP
        "NO ESTA CONFIGURADO SU CORRELATIVO PARA LA DIVISION" s-coddiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

FIND FacDocum WHERE facdocum.codcia = s-codcia AND
    facdocum.coddoc = s-CodDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum THEN DO:
    MESSAGE "NO ESTA DEFINIDO EL DOCUMENTO" s-CodDoc                    
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-CodMov = Facdocum.codmov.
FIND almtmovm WHERE Almtmovm.CodCia = s-codcia AND
    Almtmovm.Codmov = s-codmov AND
    Almtmovm.Tipmov = "S"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE almtmovm THEN DO:
    MESSAGE "NO ESTA DEFINIDO EL MOVIMIENTO DE SALIDA" s-codmov
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-codCli = B-CPEDM.CodCli.
/* 09.09.09 Control de Vigencia del Pedido Mostrador */
/* Tiempo por defecto fuera de campaña */
FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
    (FacCfgGn.Hora-Res * 3600) + 
    (FacCfgGn.Minu-Res * 60).
/* Tiempo dentro de campaña */
FIND FIRST FacCfgVta WHERE Faccfgvta.codcia = s-codcia
    AND Faccfgvta.coddoc = B-CPEDM.CodDoc
    AND TODAY >= Faccfgvta.fechad
    AND TODAY <= Faccfgvta.fechah
    NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgVta 
    THEN TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
                    (FacCfgVta.Hora-Res * 3600) + 
                    (FacCfgVta.Minu-Res * 60).
IF TimeOut > 0 THEN DO:
    TimeNow = (TODAY - B-CPEDM.FchPed) * 24 * 3600.
    TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(B-CPEDM.Hora, 1, 2)) * 3600) +
                                 (INTEGER(SUBSTRING(B-CPEDM.Hora, 4, 2)) * 60) ).
    IF TimeNow > TimeOut THEN DO:
        MESSAGE 'El Pedido' B-CPEDM.NroPed 'está VENCIDO' SKIP
            'Fue generado el' B-CPEDM.FchPed 'a las' B-CPEDM.Hora 'horas'
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
END.
/* **************************************************** */

/* Retenciones y N/C */
RUN Temporal-de-Retenciones.

/* CALCULAMOS PERCEPCION */
RUN vta2/percepcion-por-pedido ( ROWID(B-CPEDM) ).

/* VENTANA DE CANCELACIÓN */
x-Importe-Control = B-CPEDM.ImpTot.      /* OJO */
RUN ccb/d-canc-mayorista-cont-v2 (
    B-CPEDM.codmon,     /* Moneda Documento */
    (B-CPEDM.imptot + B-CPEDM.acubon[5]),     /* Importe Total */
    monto_ret,          /* Retención */
    B-CPEDM.NomCli,     /* Nombre Cliente */
    TRUE,               /* Venta Contado */
    B-CPEDM.FlgSit,     /* Pago con Tarjeta de Crédito */
    OUTPUT L-OK).       /* Flag Retorno */
IF L-OK = NO THEN RETURN "ADM-ERROR".

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* FIJAMOS EL PEDIDO EN UN PUNTERO DEL BUFFER */
    FIND B-CPEDM WHERE ROWID(B-CPEDM) = d_rowid EXCLUSIVE-LOCK NO-ERROR. 
    IF NOT AVAILABLE B-CPEDM THEN DO:
        MESSAGE 'NO se pudo bloquear el' B-CPEDM.coddoc B-CPEDM.nroped SKIP
            'Cancelación abortada'
            VIEW-AS ALERT-BOX ERROR.
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* CONTROL DE SITUACION DEL PEDIDO AL CONTADO */
    IF B-CPEDM.FlgEst <> "P" THEN DO:
        MESSAGE "Pedido mostrador ya no esta PENDIENTE"
            VIEW-AS ALERT-BOX ERROR.
        RELEASE B-CPEDM.
        RUN dispatch IN THIS-PROCEDURE ('open-query':U).
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    IF B-CPEDM.ImpTot <> x-Importe-Control THEN DO:
        MESSAGE 'El IMPORTE del pedido ha sido cambiado por el vendedor' SKIP
            'Proceso cancelado' VIEW-AS ALERT-BOX WARNING.
        RELEASE B-CPEDM.
        RUN dispatch IN THIS-PROCEDURE ('open-query':U).
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* CREACION DE LAS ORDENES DE DESPACHO */
    RUN Crea-Ordenes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    /* CREACION DE COMPROBANTES A PARTIR DE LAS ORDENES DE DESPACHO */
    RUN Crea-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    /* Actualiza Flag del pedido */
    ASSIGN B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
    FOR EACH FacDPedi OF B-CPEDM:
        FacDPedi.canate = FacDPedi.canped.
    END.
    /* CREACION DEL I/C Y DE OTROS DOCUMENTOS ANEXOS, INCLUSIVE LA PRE-PERCEPCION */
    RUN Documentos-Anexos.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    /* liberamos tablas */
    IF AVAILABLE(B-CPEDM) THEN RELEASE B-CPEDM.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.
    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
    IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
END. /* DO TRANSACTION... */
/* *********************** */
DO ON ENDKEY UNDO, LEAVE:
    list_docs = ''.
    FOR EACH T-CDOCU NO-LOCK:
        /* Lista de Docs para el Message */
        IF list_docs = "" THEN list_docs = T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
        ELSE list_docs = list_docs + CHR(10) + T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
    END.
    MESSAGE list_docs SKIP "CONFIRMAR IMPRESION DE DOCUMENTO(S)" VIEW-AS ALERT-BOX INFORMATION.
END.
/* IMPRIME FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO */
FOR EACH T-CDOCU NO-LOCK BY T-CDOCU.NroDoc:
    FIND CcbCDocu OF T-CDOCU NO-LOCK NO-ERROR. 
    IF AVAILABLE CcbCDocu THEN DO:
        IF Ccbcdocu.CodDoc = "FAC" THEN DO:
            CASE Ccbcdocu.coddiv:
                /*WHEN '00003' THEN RUN ccb/r-fact01-1 (ROWID(ccbcdocu)).*/
                /*WHEN '00061' THEN RUN ccb/r-fact02-1m (ROWID(ccbcdocu)).*/
                OTHERWISE RUN ccb/r-fact02-1 (ROWID(ccbcdocu)).
            END CASE.
        END.
        IF Ccbcdocu.CodDoc = "BOL" THEN DO: 
            CASE Ccbcdocu.coddiv:
                /*WHEN '00026' THEN RUN ccb/r-bole01-2 (ROWID(ccbcdocu)).*/
                /*WHEN '00061' THEN RUN ccb/r-bole01-1m (ROWID(ccbcdocu)).*/
                OTHERWISE RUN ccb/r-bole01-1 (ROWID(ccbcdocu)).
            END CASE.

        END.
        IF Ccbcdocu.CodDoc = "TCK" THEN RUN ccb/r-tick500 (ROWID(ccbcdocu), "O").
        FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
        IF AVAIL CcbDdocu THEN DO:
            RUN vtamay/r-odesp-001a (ROWID(ccbcdocu), CcbCDocu.CodAlm, 'ORIGINAL').
        END.
    END.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaCabecera L-table-Win 
PROCEDURE proc_CreaCabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE CcbCDocu.
    ASSIGN
        CcbCDocu.CodCia = s-CodCia
        CcbCDocu.CodDiv = s-CodDiv   
        CcbCDocu.DivOri = FacCPedi.CodDiv       /* OJO: division de estadisticas */
        CcbCDocu.CodAlm = FacCPedi.CodAlm       /* Almacén de descarga */
        CcbCDocu.CodDoc = s-CodDoc              /* FAC BOL TCK */
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.CodMov = s-CodMov
        CcbCDocu.CodRef = FacCPedi.CodDoc           /* CONTROL POR DEFECTO */
        CcbCDocu.NroRef = FacCPedi.NroPed
        CcbCDocu.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
        CcbCDocu.Libre_c02 = FacCPedi.NroPed
        Ccbcdocu.CodPed = B-CPEDM.CodDoc           /* NUMERO DE PEDIDO */
        Ccbcdocu.NroPed = B-CPEDM.NroPed
        CcbCDocu.Tipo   = s-Tipo
        CcbCDocu.FchVto = TODAY
        CcbCDocu.CodCli = FacCPedi.CodCli
        Ccbcdocu.NomCli = FacCPedi.NomCli
        Ccbcdocu.RucCli = FacCPedi.RucCli
        CcbCDocu.CodAnt = FacCPedi.Atencion     /* DNI */
        Ccbcdocu.DirCli = FacCPedi.DirCli
        CcbCDocu.CodVen = FacCPedi.CodVen
        CcbCDocu.TipVta = "1"
        CcbCDocu.TpoFac = "CO"                  /* CONTADO */
        CcbCDocu.FmaPgo = FacCPedi.FmaPgo
        CcbCDocu.CodMon = FacCPedi.CodMon
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.PorIgv = FacCPedi.PorIgv
        CcbCDocu.NroOrd = FacCPedi.ordcmp
        CcbCDocu.FlgEst = "P"                   /* PENDIENTE */
        CcbCDocu.FlgSit = "P"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = STRING(TIME,'hh:mm')
        /* INFORMACION DE LA TIQUETERA */
        CcbCDocu.libre_c03 = FacCorre.NroImp
        /* INFORMACION DEL P/M */
        CcbCDocu.Glosa     = B-CPEDM.Glosa
        CcbCDocu.TipBon[1] = B-CPEDM.TipBon[1]
        CcbCDocu.NroCard   = B-CPEDM.NroCard 
        CcbCDocu.FlgEnv    = B-CPEDM.FlgEnv /* OJO Control de envio de documento */
        CcbCDocu.FlgCbd    = B-CPEDM.FlgIgv.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* PUNTERO DE LA FACTURA */
    ASSIGN
        Fac_Rowid = ROWID(Ccbcdocu).
    /* ********************* */

    FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    END.
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = CcbCDocu.CodCli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
        ASSIGN
            CcbCDocu.CodDpto = gn-clie.CodDept 
            CcbCDocu.CodProv = gn-clie.CodProv 
            CcbCDocu.CodDist = gn-clie.CodDist.
    END.
    /* ******************************** */
    IF cMess <> "" THEN ASSIGN CcbCDocu.Libre_c05 = cMess.        

    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN ccbcdocu.cco = gn-ven.cco.
    /* TRACKING FACTURAS */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            Ccbcdocu.CodPed,
                            Ccbcdocu.NroPed,
                            s-User-Id,
                            'EFAC',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Ccbcdocu.coddoc,
                            Ccbcdocu.nrodoc,
                            CcbCDocu.Libre_c01,
                            CcbCDocu.Libre_c02).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaRetencion L-table-Win 
PROCEDURE proc_CreaRetencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST T-CcbCCaja NO-ERROR.
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FOR EACH wrk_ret NO-LOCK:
            FIND FIRST CCBCMOV WHERE
                CCBCMOV.CodCia = wrk_ret.CodCia AND
                CCBCMOV.CodDoc = wrk_ret.CodDoc AND
                CCBCMOV.NroDoc = wrk_ret.NroDoc
                NO-LOCK NO-ERROR.
            IF AVAILABLE CCBCMOV THEN DO:
                MESSAGE
                    "YA EXISTE RETENCION PARA DOCUMENTO"
                    CCBCMOV.CodDoc CCBCMOV.NroDoc SKIP
                    "CREADO POR:" CCBCMOV.usuario SKIP
                    "FECHA:" CCBCMOV.FchMov SKIP
                    "HORA:" CCBCMOV.HraMov
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            CREATE CCBCMOV.
            ASSIGN
                CCBCMOV.CodCia = wrk_ret.CodCia
                CCBCMOV.CodDoc = wrk_ret.CodDoc
                CCBCMOV.NroDoc = wrk_ret.NroDoc
                CCBCMOV.CodRef = wrk_ret.CodRef
                CCBCMOV.NroRef = wrk_ret.NroRef
                CCBCMOV.CodCli = wrk_ret.CodCli
                CCBCMOV.CodDiv = s-CodDiv
                CCBCMOV.CodMon = 1                  /* Ojo: Siempre en Soles */
                CCBCMOV.TpoCmb = T-CcbCCaja.TpoCmb
                CCBCMOV.FchDoc = wrk_ret.FchDoc
                CCBCMOV.ImpTot = wrk_ret.ImpTot
                CCBCMOV.DocRef = wrk_ret.NroRet     /* Comprobante */
                CCBCMOV.FchRef = wrk_ret.FchRet     /* Fecha */
                CCBCMOV.ImpRef = wrk_ret.ImpRet     /* Importe */
                CCBCMOV.FchMov = TODAY
                CCBCMOV.HraMov = STRING(TIME,"HH:MM:SS")
                CCBCMOV.usuario = s-User-ID
                CCBCMOV.chr__01 = cNomcli.
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_IngCja L-table-Win 
PROCEDURE proc_IngCja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER para_nrodoccja LIKE CcbCCaja.NroDoc.
    DEFINE VARIABLE x_NumDoc AS CHARACTER.

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND Faccorre WHERE
            FacCorre.CodCia = s-codcia AND
            FacCorre.CodDiv = s-coddiv AND
            FacCorre.CodDoc = s-codcja AND
            FacCorre.NroSer = s-sercja
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'.
        FIND FIRST T-CcbCCaja.
        /* Crea Cabecera de Caja */
        CREATE CcbCCaja.
        ASSIGN
            CcbCCaja.CodCia     = s-CodCia
            CcbCCaja.CodDiv     = s-CodDiv 
            CcbCCaja.CodDoc     = s-CodCja
            CcbCCaja.NroDoc     = STRING(FacCorre.NroSer,"999") +
                STRING(FacCorre.Correlativo,"999999")
            FacCorre.Correlativo = FacCorre.Correlativo + 1
            CcbCCaja.CodCaja    = s-CodTer
            CcbCCaja.usuario    = s-user-id
            CcbCCaja.CodCli     = B-CPEDM.codcli
            CcbCCaja.NomCli     = B-CPEDM.NomCli
            CcbCCaja.CodMon     = B-CPEDM.CodMon
            CcbCCaja.FchDoc     = TODAY
            CcbCCaja.CodBco[2]  = T-CcbCCaja.CodBco[2]
            CcbCCaja.CodBco[3]  = T-CcbCCaja.CodBco[3]
            CcbCCaja.CodBco[4]  = T-CcbCCaja.CodBco[4]
            CcbCCaja.CodBco[5]  = T-CcbCCaja.CodBco[5]
            CcbCCaja.CodBco[8]  = T-CcbCCaja.CodBco[8]
            CcbCCaja.ImpNac[1]  = T-CcbCCaja.ImpNac[1]
            CcbCCaja.ImpNac[2]  = T-CcbCCaja.ImpNac[2]
            CcbCCaja.ImpNac[3]  = T-CcbCCaja.ImpNac[3]
            CcbCCaja.ImpNac[4]  = T-CcbCCaja.ImpNac[4]
            CcbCCaja.ImpNac[5]  = T-CcbCCaja.ImpNac[5]
            CcbCCaja.ImpNac[6]  = T-CcbCCaja.ImpNac[6]
            CcbCCaja.ImpNac[7]  = T-CcbCCaja.ImpNac[7]            
            CcbCCaja.ImpNac[8]  = T-CcbCCaja.ImpNac[8]
            CcbCCaja.ImpNac[9]  = T-CcbCCaja.ImpNac[9]
            CcbCCaja.ImpNac[10] = T-CcbCCaja.ImpNac[10]
            CcbCCaja.ImpUsa[1]  = T-CcbCCaja.ImpUsa[1]
            CcbCCaja.ImpUsa[2]  = T-CcbCCaja.ImpUsa[2]
            CcbCCaja.ImpUsa[3]  = T-CcbCCaja.ImpUsa[3]
            CcbCCaja.ImpUsa[4]  = T-CcbCCaja.ImpUsa[4] 
            CcbCCaja.ImpUsa[5]  = T-CcbCCaja.ImpUsa[5]
            CcbCCaja.ImpUsa[6]  = T-CcbCCaja.ImpUsa[6]
            CcbCCaja.ImpUsa[7]  = T-CcbCCaja.ImpUsa[7]
            CcbCCaja.ImpUsa[8]  = T-CcbCCaja.ImpUsa[8]
            CcbCCaja.ImpUsa[9]  = T-CcbCCaja.ImpUsa[9]
            CcbCCaja.ImpUsa[10] = T-CcbCCaja.ImpUsa[10]
            CcbCCaja.Tipo       = s-Tipo
            CcbCCaja.TpoCmb     = T-CcbCCaja.TpoCmb
            CcbCCaja.Voucher[2] = T-CcbCCaja.Voucher[2]
            CcbCCaja.Voucher[3] = T-CcbCCaja.Voucher[3]
            CcbCCaja.Voucher[4] = T-CcbCCaja.Voucher[4] 
            CcbCCaja.Voucher[5] = T-CcbCCaja.Voucher[5] 
            CcbCCaja.Voucher[6] = T-CcbCCaja.Voucher[6]
            CcbCCaja.Voucher[7] = T-CcbCCaja.Voucher[7]
            CcbCCaja.Voucher[8] = T-CcbCCaja.Voucher[8]
            CcbCCaja.Voucher[9] = T-CcbCCaja.Voucher[9]
            CcbCCaja.Voucher[10] = T-CcbCCaja.Voucher[10]
            CcbCCaja.FchVto[2]  = T-CcbCCaja.FchVto[2]
            CcbCCaja.FchVto[3]  = T-CcbCCaja.FchVto[3]
            CcbCCaja.VueNac     = T-CcbCCaja.VueNac 
            CcbCCaja.VueUsa     = T-CcbCCaja.VueUsa
            CcbCCaja.FLGEST     = "C".
        /*RELEASE faccorre.*/
        /* Crea Detalle de Caja */
        FOR EACH T-CDOCU NO-LOCK BY T-CDOCU.NroDoc:
            FIND CcbCDocu WHERE CcbCDocu.CodCia = T-CDOCU.CodCia
                AND CcbCDocu.CodDoc = T-CDOCU.CodDoc
                AND CcbCDocu.NroDoc = T-CDOCU.NroDoc
                EXCLUSIVE-LOCK NO-ERROR. 
            IF NOT AVAILABLE Ccbcdocu THEN UNDO trloop, RETURN 'ADM-ERROR'.
            CREATE CcbDCaja.
            ASSIGN
                CcbDCaja.CodCia = CcbCCaja.CodCia
                CcbdCaja.CodDiv = CcbCCaja.CodDiv
                CcbDCaja.CodDoc = CcbCCaja.CodDoc
                CcbDCaja.NroDoc = CcbCCaja.NroDoc
                CcbDCaja.CodRef = CcbCDocu.CodDoc
                CcbDCaja.NroRef = CcbCDocu.NroDoc
                CcbDCaja.CodCli = CcbCDocu.CodCli
                CcbDCaja.CodMon = CcbCDocu.CodMon
                CcbDCaja.FchDoc = CcbCCaja.FchDoc
                CcbDCaja.ImpTot = CcbCDocu.ImpTot
                CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
            ASSIGN
                CcbCDocu.FlgEst = "C"
                CcbCDocu.FchCan = TODAY
                CcbCDocu.SdoAct = 0.
        END.
        /* Cancelación por Cheque */
        IF T-CcbCCaja.Voucher[2] <> "" OR T-CcbCCaja.Voucher[3] <> "" THEN DO:
            IF T-CcbCCaja.Voucher[2] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[2].
            IF T-CcbCCaja.Voucher[3] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[3].       
            FIND CcbCDocu WHERE 
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDiv = S-CodDiv AND
                CcbCDocu.CodDoc = "CHC" AND
                CcbCDocu.NroDoc = x_NumDoc
                EXCLUSIVE-LOCK NO-ERROR. 
            IF AVAILABLE CcbCDocu THEN
                ASSIGN
                    CcbCDocu.CodRef = CcbCCaja.CodDoc 
                    CcbCDocu.NroRef = CcbCCaja.NroDoc.               
        END.
        /* Captura Nro de Caja */
        para_nrodoccja = CcbCCaja.NroDoc.
    END.
    RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_verifica_ic L-table-Win 
PROCEDURE proc_verifica_ic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lFoundIC AS LOGICAL NO-UNDO.

    /* Busca I/C tipo "Sencillo" Activo */
    IF NOT s-codter BEGINS "ATE" THEN DO:
        lFoundIC = FALSE.
        FOR EACH ccbccaja WHERE
            ccbccaja.codcia = s-codcia AND
            ccbccaja.coddiv >= "" AND
            ccbccaja.coddoc = "I/C" AND
            ccbccaja.tipo = "SENCILLO" AND
            ccbccaja.codcaja = s-codter AND
            ccbccaja.flgcie = "P" NO-LOCK:
            IF CcbCCaja.FlgEst <> "A" THEN lFoundIC = TRUE.
        END.
        IF NOT lFoundIC THEN DO:
            MESSAGE
                "Se debe ingresar el I/C SENCILLO como primer movimiento"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key L-table-Win  adm/support/_key-snd.p
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records L-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacCPedi"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Temporal-de-Retenciones L-table-Win 
PROCEDURE Temporal-de-Retenciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dTpoCmb     LIKE CcbcCaja.TpoCmb NO-UNDO.

    /* Retenciones */
    FOR EACH wrk_ret:
        DELETE wrk_ret.
    END.
    /* N/C */
    FOR EACH wrk_dcaja:
        DELETE wrk_dcaja.
    END.
    IF B-CPEDM.CodDoc = "FAC" AND       /* Solo Facturas */
        B-CPEDM.ImpTot > 0 THEN DO WITH FRAME {&FRAME-NAME}:
        /* Tipo de Cambio Caja */
        dTpoCmb = 1.
        FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-tccja THEN DO:
            IF B-CPEDM.Codmon = 1 THEN dTpoCmb = Gn-tccja.Compra.
            ELSE dTpoCmb = Gn-tccja.Venta.
        END.
        FIND gn-clie WHERE
            gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = B-CPEDM.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.rucold = "Si" THEN DO:     /* AGENTE RETENEDOR */
            CREATE wrk_ret.
            ASSIGN
                wrk_ret.CodCia = B-CPEDM.Codcia
                wrk_ret.CodCli = B-CPEDM.CodCli
                wrk_ret.CodDoc = B-CPEDM.CodDoc
                wrk_ret.NroDoc = B-CPEDM.NroPed
                wrk_ret.FchDoc = B-CPEDM.FchPed
                wrk_ret.CodRef = s-CodCja                    
                wrk_ret.NroRef = ""
                wrk_ret.CodMon = "S/."
                cNomcli = gn-clie.nomcli.
            /* OJO: Cálculo de Retenciones Siempre en Soles */
            IF B-CPEDM.Codmon = 1 THEN DO:
                wrk_ret.ImpTot = B-CPEDM.imptot.
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
            ELSE DO:
                wrk_ret.ImpTot = ROUND((B-CPEDM.imptot * dTpoCmb),2).
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

