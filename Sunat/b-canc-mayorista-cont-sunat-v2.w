&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
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
DEFINE BUFFER B-CDocu FOR CcbCDocu.

DEFINE SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

/* TEMPORALES DE ORDENES DE DESPACHO */
DEFINE TEMP-TABLE T-CODES LIKE FacCPedi.
DEFINE TEMP-TABLE T-DODES LIKE FacDPedi.

/* TEMPORALES DE COMPROBANTES */
DEFINE TEMP-TABLE T-CDOCU LIKE CcbCDocu.
DEFINE TEMP-TABLE T-DDOCU LIKE CcbDDocu.

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
    FacCPedi.FchPed = TODAY AND (RADIO-SET-1 = '' OR FacCPedi.Cmpbnte = RADIO-SET-1) )
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

DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE d_rowid     AS ROWID NO-UNDO.
DEFINE VARIABLE x-Importe-Control   AS DEC NO-UNDO. 
DEFINE VARIABLE NroDocCja   AS CHARACTER.

define stream log-epos.
DEFINE VAR x-log-epos AS LOG INIT YES.  /* NO = no inserta trama en log TXT */

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
(IF FacCPedi.CodMon = 1 THEN 'S/.' ELSE 'US$') @ c-Mon ~
FacCPedi.ImpTot + FacCPedi.AcuBon[5] @ x-ImpTot FacCPedi.FchPed ~
FacCPedi.Hora FacCPedi.Cmpbnte FacCPedi.usuario 
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
Hora|y||integral.FacCPedi.Hora|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'Hora' + '",
     SortBy-Case = ':U + 'Hora').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES></FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fadd-log-txt L-table-Win 
FUNCTION fadd-log-txt RETURNS CHARACTER
      (INPUT pTexto AS CHAR)  FORWARD.

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
"FAC", "FAC":U,
"BOL", "BOL":U,
"TCK", "TCK":U
     SIZE 25.72 BY .85 NO-UNDO.

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
      (IF FacCPedi.CodMon = 1 THEN 'S/.' ELSE 'US$') @ c-Mon COLUMN-LABEL "Mon" FORMAT "x(4)":U
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
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
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
"(IF FacCPedi.CodMon = 1 THEN 'S/.' ELSE 'US$') @ c-Mon" "Mon" "x(4)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF


/* ************************************************** */
/* RHC 27/04/2016 RUTINAS GENERALES DE CAJA COBRANZAS */
/* ************************************************** */
{sunat\i-canc-mayorista-cont-v2.i}
/* ************************************************** */

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
         WHEN 'Hora':U THEN DO:
           &Scope SORTBY-PHRASE BY FacCPedi.Hora
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
         WHEN 'Hora':U THEN DO:
           &Scope SORTBY-PHRASE BY FacCPedi.Hora
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
         WHEN 'Hora':U THEN DO:
           &Scope SORTBY-PHRASE BY FacCPedi.Hora
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancelar-Pedido L-table-Win 
PROCEDURE Cancelar-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR cReturnValue AS CHAR INIT "" NO-UNDO.
    
    pMensaje = "".
    RUN proc_CanPed.
    cReturnValue = RETURN-VALUE.

    /* liberamos tablas */
    IF AVAILABLE(CcbCCaja) THEN RELEASE CcbCCaja.
    IF AVAILABLE(CcbDCaja) THEN RELEASE CcbDCaja.
    IF AVAILABLE(B-CPEDM) THEN RELEASE B-CPEDM.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.
    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
    IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
    IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDocu.
    IF AVAILABLE(Ccbdmov) THEN RELEASE Ccbdmov.

    IF cReturnValue = "ANULA-CANCELACION" THEN RETURN.

    IF cReturnValue = "ADM-ERROR" THEN DO:
        IF pMensaje <> "" THEN DO:
            MESSAGE pMensaje SKIP (1)
                "SE VA A CERRAR EL SISTEMA. Volver a entrar y repita el proceso."
                VIEW-AS ALERT-BOX ERROR.
        END.
        QUIT.
    END.
    /* *********************** */
    list_docs = ''.
    FOR EACH T-CDOCU NO-LOCK:
        /* Lista de Docs para el Message */
        IF list_docs = "" THEN list_docs = T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
        ELSE list_docs = list_docs + CHR(10) + T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
    END.
    MESSAGE list_docs SKIP "CONFIRMAR IMPRESION DE DOCUMENTO(S)" VIEW-AS ALERT-BOX INFORMATION.
    /* IMPRIME FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO */
    FOR EACH T-CDOCU NO-LOCK BY T-CDOCU.NroDoc:
        FIND CcbCDocu OF T-CDOCU NO-LOCK NO-ERROR. 
        IF AVAILABLE CcbCDocu THEN DO:
            RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), 'ORIGINAL', YES).
            FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
            IF AVAIL CcbDdocu THEN RUN vtamay/r-odesp-001a (ROWID(ccbcdocu), CcbCDocu.CodAlm, 'ORIGINAL') NO-ERROR.
        END.
    END.
    /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION L-table-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR.

x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - INICIO").
    
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ************************************************** */
    /* NOTA: Todos los documentos se graban en TEMPORALES */
    /* ************************************************** */
    /* FIJAMOS EL PEDIDO EN UN PUNTERO DEL BUFFER */
    
    x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - Bloqueando B-CPEDM").

    {lib\lock-genericov3.i ~
        &Tabla="B-CPEDM" ~
        &Condicion="ROWID(B-CPEDM) = d_rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje"
        &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" }
    /* CONTROL DE SITUACION DEL PEDIDO AL CONTADO */
    IF B-CPEDM.FlgEst <> "P" THEN DO:

        x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - Pedido no esta pendiente").

        pMensaje = "Pedido mostrador ya no esta PENDIENTE".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    IF B-CPEDM.ImpTot <> x-Importe-Control THEN DO:

        x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - IMPORTE del pedido cambiado por el vendedor").

        pMensaje = 'El IMPORTE del pedido ha sido cambiado por el vendedor' + CHR(10) +
            'Proceso cancelado' .
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* CREACION DE LAS ORDENES DE DESPACHO */
    EMPTY TEMP-TABLE T-CODES.
    EMPTY TEMP-TABLE T-DODES.

    x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - Creando Ordenes").

    RUN Crea-Ordenes.

    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:

        x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - No se pudo crear las O/D").

        IF pMensaje = "" THEN pMensaje = "NO se pudo crear la Orden de Despacho".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* CREACION DE COMPROBANTES A PARTIR DE LAS ORDENES DE DESPACHO */
    EMPTY TEMP-TABLE T-CDOCU.
    EMPTY TEMP-TABLE T-DDOCU.

    x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - Creando Comprobantes").

    RUN Crea-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:

        x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - No se pudo crear el comprobante temporal").

        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear el Comprobante Temporal".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.
    /* CREACION DEL INGRESO A CAJA EN CcbCCaja */

    x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - Creando Ingreso a Caja").

    NroDocCja = "".
    RUN proc_IngCja (OUTPUT NroDocCja).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:

        x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - No se pudo crear ingreso a caja").

        IF pMensaje = "" THEN pMensaje = "NO se pudo crear el Ingreso a Caja".
        UNDO RLOOP, RETURN "ADM-ERROR".
    END.

    /* GRABACION DE LOS COMPROBANTES: ACTUALIZA ALMACENES */

    x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - Grabando comprobantes").

    RUN Graba-Comprobantes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo crear el Comprobante".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.

    /* GRABA ORDENES DE DESPACHO */

    x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - Graba ordenes").

    RUN Graba-Ordenes.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:

        x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - No se pudo grabar las O/D").

        IF pMensaje = "" THEN pMensaje = "NO se pudo crear las grabar de Despacho".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.

    /* CREACION DE OTROS DOCUMENTOS ANEXOS */

    x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - Documentos anexos").

    RUN Documentos-Anexos (NroDocCja).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:

        x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - No se pudo crear los documentos anexos").

        IF pMensaje = "" THEN pMensaje = "NO se pudieron crear los Documentos Anexos".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CERRAMOS PEDIDO MOSTRADOR */
    ASSIGN 
        B-CPEDM.flgest = "C".        /* Pedido Mostrador CERRADO */
    FOR EACH FacDPedi OF B-CPEDM:
        FacDPedi.canate = FacDPedi.canped.  /* Atendido al 100% */
    END.
END.

x-retval = fadd-log-txt("FIRST-TRANSACTION : " + B-CPEDM.coddoc + " " + B-CPEDM.nroped + " - FINAL").

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores L-table-Win 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

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

  FIND T-CDOCU WHERE ROWID(T-CDOCU) = Fac_Rowid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF NOT AVAILABLE T-CDOCU THEN DO:
      MESSAGE 'NO se pudo actualizar los totales del comprobante' SKIP
          'Proceso abortado'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
                                                  
  /* graba totales de la factura */
  DEFINE VARIABLE F-IGV LIKE T-CDOCU.ImpIgv NO-UNDO.
  DEFINE VARIABLE F-ISC LIKE T-CDOCU.ImpIsc NO-UNDO.

  ASSIGN
      T-CDOCU.ImpDto = 0
      T-CDOCU.ImpIgv = 0
      T-CDOCU.ImpIsc = 0
      T-CDOCU.ImpTot = 0
      T-CDOCU.ImpExo = 0
      F-IGV = 0
      F-ISC = 0.
  FOR EACH T-DDOCU OF T-CDOCU:
      ASSIGN
          F-Igv = F-Igv + T-DDOCU.ImpIgv
          F-Isc = F-Isc + T-DDOCU.ImpIsc
          T-CDOCU.ImpTot = T-CDOCU.ImpTot + T-DDOCU.ImpLin.
      /* Importe Inafecto o Exonerado */
      IF T-DDOCU.ImpIgv = 0 THEN T-CDOCU.ImpExo = T-CDOCU.ImpExo + T-DDOCU.ImpLin.
  END.
  ASSIGN
      T-CDOCU.ImpIgv = ROUND(F-IGV,2)
      T-CDOCU.ImpIsc = ROUND(F-ISC,2)
      T-CDOCU.ImpVta = T-CDOCU.ImpTot - T-CDOCU.ImpExo - T-CDOCU.ImpIgv
      T-CDOCU.ImpBrt = T-CDOCU.ImpVta + T-CDOCU.ImpIsc + T-CDOCU.ImpDto + T-CDOCU.ImpExo
      T-CDOCU.SdoAct = T-CDOCU.ImpTot.
  /* ********************************************************************************************** */
  /* RHC 22/08/2016 Nuevo cálculo */
  /* ********************************************************************************************** */
  ASSIGN
      T-CDOCU.ImpVta = ROUND ( (T-CDOCU.ImpTot - T-CDOCU.ImpExo) / (1 + T-CDOCU.PorIgv / 100), 2 ).
  IF T-CDOCU.ImpExo = 0 THEN T-CDOCU.ImpIgv = T-CDOCU.ImpTot - T-CDOCU.ImpVta.
  ELSE T-CDOCU.ImpIgv = ROUND(T-CDOCU.ImpVta * T-CDOCU.PorIgv / 100, 2).
  ASSIGN
      T-CDOCU.ImpBrt = T-CDOCU.ImpVta + T-CDOCU.ImpDto + T-CDOCU.ImpIsc
      T-CDOCU.SdoAct = T-CDOCU.ImpTot.
  /* ********************************************************************************************** */
  /* ********************************************************************************************** */
  IF T-CDOCU.PorIgv = 0.00     /* VENTA INAFECTA */
      THEN ASSIGN
            T-CDOCU.ImpIgv = 0
            T-CDOCU.ImpVta = T-CDOCU.ImpExo
            T-CDOCU.ImpBrt = T-CDOCU.ImpExo.
  /* Consistencia importe cero */
  IF T-CDOCU.ImpTot <= 0 THEN DO:
      /* Verificamos si existen items en el comprobante */
      FIND FIRST T-DDOCU OF T-CDOCU NO-LOCK NO-ERROR.
      IF NOT AVAILABLE T-DDOCU THEN DO:
          pMensaje = 'NO se ha grabado el detalle para la ' + T-CDOCU.coddoc + ' ' + T-CDOCU.nrodoc + CHR(10) +
              'Proceso Abortado'.
          RETURN 'ADM-ERROR'.
      END.
      /* Verificamos importes del detalle */
      FOR EACH T-DDOCU OF T-CDOCU NO-LOCK:
          IF T-DDOCU.ImpLin > 0 THEN DO:
              pMensaje = 'Problemas con los totales de la ' + T-CDOCU.coddoc + ' ' + T-CDOCU.nrodoc + CHR(10) +
                  'Proceso Abortado'.
              UNDO, RETURN 'ADM-ERROR'.
          END.
      END.
  END.
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
    DO WITH FRAME {&FRAME-NAME}:
        IF TODAY >= DATE(07,04,2016) OR s-user-id = 'ADMIN'
            THEN RADIO-SET-1:RADIO-BUTTONS = "Todos,,FAC,FAC,BOL,BOL".
    END.

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
/* DEFINE VARIABLE d_rowid     AS ROWID NO-UNDO. */
DEFINE VARIABLE monto_ret   AS DECIMAL NO-UNDO.
/* DEFINE VARIABLE NroDocCja   AS CHARACTER. */

/* Importe del pedido en pantalla */
/* DEFINE VARIABLE x-Importe-Control   AS DEC NO-UNDO. */

/* PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

ASSIGN
    s-FechaI = DATETIME(TODAY, MTIME)
    list_docs = ''.

/* 09.09.09 CONSISTENCIA DEL PEDIDO MOSTRADOR */
IF NOT AVAILABLE FacCPedi THEN RETURN "ANULA-CANCELACION".
d_rowid = ROWID(FacCPedi).

/* AVISO DEL ADMINISTRADOR */
DEF VAR pRpta AS CHAR.
RUN ccb/d-msgblo (FacCPedi.codcli, FacCPedi.nrocard, OUTPUT pRpta).
IF pRpta = 'ADM-ERROR' THEN RETURN "ANULA-CANCELACION".
/* *********************** */

/* Verifica SENCILLO EN CAJA */
RUN proc_verifica_ic.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ANULA-CANCELACION".
FIND B-CPEDM WHERE ROWID(B-CPEDM) = d_rowid NO-LOCK NO-ERROR. 

/* NUMERO DE SERIE DEL COMPROBANTE PARA TERMINAL */
s-CodDoc = B-CPEDM.Cmpbnte.

FIND FIRST ccbdterm WHERE 
    CcbDTerm.CodCia = s-codcia AND
    CcbDTerm.CodDiv = s-coddiv AND
    CcbDTerm.CodDoc = s-CodDoc AND
    CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm THEN DO:
    MESSAGE "DOCUMENTO" s-CodDoc "NO ESTA CONFIGURADO EN ESTE TERMINAL:" s-CodTer
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ANULA-CANCELACION".
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
    RETURN "ANULA-CANCELACION".
END.

FIND FacDocum WHERE facdocum.codcia = s-codcia AND
    facdocum.coddoc = s-CodDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum THEN DO:
    MESSAGE "NO ESTA DEFINIDO EL DOCUMENTO" s-CodDoc                    
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ANULA-CANCELACION".
END.
s-CodMov = Facdocum.codmov.
FIND almtmovm WHERE Almtmovm.CodCia = s-codcia AND
    Almtmovm.Codmov = s-codmov AND
    Almtmovm.Tipmov = "S"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE almtmovm THEN DO:
    MESSAGE "NO ESTA DEFINIDO EL MOVIMIENTO DE SALIDA" s-codmov
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ANULA-CANCELACION".
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
        RETURN "ANULA-CANCELACION".
    END.
END.
/* **************************************************** */

/* Retenciones y N/C */
RUN Temporal-de-Retenciones.

/* CALCULAMOS PERCEPCION */
RUN vta2/percepcion-por-pedido ( ROWID(B-CPEDM) ).

/* VENTANA DE CANCELACIÓN */
x-Importe-Control = B-CPEDM.ImpTot.      /* OJO */
RUN ccb\d-canc-mayorista-cont-v2 (
    B-CPEDM.codmon,     /* Moneda Documento */
    (B-CPEDM.imptot + B-CPEDM.acubon[5]),     /* Importe Total */
    monto_ret,          /* Retención */
    B-CPEDM.NomCli,     /* Nombre Cliente */
    TRUE,               /* Venta Contado */
    B-CPEDM.FlgSit,     /* Pago con Tarjeta de Crédito */
    OUTPUT L-OK).       /* Flag Retorno */
IF L-OK = NO THEN RETURN "ANULA-CANCELACION".

DEFINE VAR x-retval AS CHAR.
x-retval = fadd-log-txt("Inicio de grabacion").

/* NOTA: VAMOS A DIVIDIR LAS TRANSACCIONES EN SUB-TRANSACCIONES */
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
    /* 1ra. TRANSACCION: CABECERA INGRESO A CAJA Y COMPROBANTE */
    RUN FIRST-TRANSACTION.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    /* 2da. TRANSACCION: FACTURACION ELECTRONICA */
    RUN SECOND-TRANSACTION.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante en SUNAT" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR DE E-POS: No se pudo confirmar el comprobante en SUNAT" .
        RUN THIRD-TRANSACTION.  /* EXTORNO */
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            pMensaje = pMensaje + CHR(10) +
                        "AVISO IMPORTANTE: HAY UN ERROR EN EL EXTORNO DE LOS COMPROBANTES. AVISAR A SISTEMAS.".
        END.
        LEAVE RLOOP.
    END.
END.
/* liberamos tablas */
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
IF AVAILABLE(CcbCCaja) THEN RELEASE CcbCCaja.
IF AVAILABLE(CcbDCaja) THEN RELEASE CcbDCaja.
IF AVAILABLE(B-CPEDM) THEN RELEASE B-CPEDM.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDocu.
IF AVAILABLE(Ccbdmov) THEN RELEASE Ccbdmov.
IF pMensaje > "" THEN DO:
    MESSAGE pMensaje SKIP (1)
        "SE VA A CERRAR EL SISTEMA. Volver a entrar y repita el proceso."
        VIEW-AS ALERT-BOX ERROR.
    QUIT.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RETURN 'ADM-ERROR'.
END.
/* *********************** */
/*DO ON ENDKEY UNDO, LEAVE:*/
    list_docs = ''.
    FOR EACH T-CDOCU NO-LOCK:
        /* Lista de Docs para el Message */
        IF list_docs = "" THEN list_docs = T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
        ELSE list_docs = list_docs + CHR(10) + T-CDOCU.coddoc + " " + T-CDOCU.nrodoc.
    END.
    MESSAGE list_docs SKIP "CONFIRMAR IMPRESION DE DOCUMENTO(S)" VIEW-AS ALERT-BOX INFORMATION.
/*END.*/
/* IMPRIME FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO */
FOR EACH T-CDOCU NO-LOCK BY T-CDOCU.NroDoc:
    FIND CcbCDocu OF T-CDOCU NO-LOCK NO-ERROR. 
    IF AVAILABLE CcbCDocu THEN DO:

        /* Ic - 23Dic2017, Impresion QR */
        /*
        /* Documento electronico */
        IF Ccbcdocu.coddiv = '00005' THEN RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), 'ORIGINAL', NO).
        ELSE RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), 'ORIGINAL', YES).
        */

        /*-----------------------------------------------*/

        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
                   gn-divi.coddiv = CcbCDocu.coddiv NO-LOCK NO-ERROR.
    
        IF AVAILABLE gn-divi THEN DO:
            IF gn-divi.campo-log[7] = YES THEN DO:
                /* Configurado para QR */
                DEFINE VAR x-version AS CHAR.
                DEFINE VAR x-formato-tck AS LOG.
                DEFINE VAR x-imprime-directo AS LOG.
                DEFINE VAR x-nombre-impresora AS CHAR.

                x-version = 'L'.
                x-formato-tck = NO.        /* YES : Formato Ticket,  NO : Formato A4 */
                x-imprime-directo = YES.
                x-nombre-impresora = "".

                /* pVersion: "O": ORIGINAL "C": COPIA "R": RE-IMPRESION "L" : CLiente "A" : Control Administrativo */

                /* CLIENTE */
                RUN sunat\r-impresion-doc-electronico(INPUT CcbCDocu.CodDiv, 
                                                      INPUT CcbCDocu.coddoc, 
                                                      INPUT CcbCDocu.nrodoc,
                                                      INPUT x-version,
                                                      INPUT x-formato-tck,
                                                      INPUT x-imprime-directo,
                                                      INPUT x-nombre-impresora).
                /* Si la venta no es al contado, emitir CONTROL ADMINISTRATIVO */
                IF ccbcdocu.fmapgo <> '000' THEN DO:
                    /* CONTROL ADMINISTRATIVO */
                    x-version = 'A'.
                    RUN sunat\r-impresion-doc-electronico(INPUT CcbCDocu.CodDiv, 
                                                          INPUT CcbCDocu.coddoc, 
                                                          INPUT CcbCDocu.nrodoc,
                                                          INPUT x-version,
                                                          INPUT x-formato-tck,
                                                          INPUT x-imprime-directo,
                                                          INPUT x-nombre-impresora).
                END.
            END.
            ELSE DO:
                /* Documento electronico MATRICIAL SIN QR*/
                IF Ccbcdocu.coddiv = '00005' THEN RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), 'ORIGINAL', NO).
                ELSE RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), 'ORIGINAL', YES).                
            END.
        END.
        ELSE DO:
            /*MESSAGE "La division(" + S-CodDiv + ") a la que pertenece el documento NO EXISTE".*/
        END.

        /*-----------------------------------------------*/

        /* Orden de Despacho */
        FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
        IF AVAIL CcbDdocu THEN DO:
            IF Ccbcdocu.coddiv = '00005' THEN RUN vtamay/r-odesp-001a (ROWID(ccbcdocu), CcbCDocu.CodAlm, 'ORIGINAL',NO) NO-ERROR.
            ELSE RUN vtamay/r-odesp-001a (ROWID(ccbcdocu), CcbCDocu.CodAlm, 'ORIGINAL', YES) NO-ERROR.
        END.
    END.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RETURN "OK".

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

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-CodCia
        T-CDOCU.CodDiv = s-CodDiv   
        T-CDOCU.DivOri = T-CODES.CodDiv       /* OJO: division de estadisticas */
        T-CDOCU.CodAlm = T-CODES.CodAlm       /* Almacén de descarga */
        T-CDOCU.CodDoc = s-CodDoc              /* FAC BOL TCK */
        T-CDOCU.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
        T-CDOCU.FchDoc = TODAY
        T-CDOCU.CodMov = s-CodMov
        T-CDOCU.CodRef = T-CODES.CodDoc           /* CONTROL POR DEFECTO */
        T-CDOCU.NroRef = T-CODES.NroPed
        T-CDOCU.Libre_c01 = T-CODES.CodDoc        /* CONTROL ADICIONAL */
        T-CDOCU.Libre_c02 = T-CODES.NroPed
        T-CDOCU.CodPed = B-CPEDM.CodDoc           /* NUMERO DE PEDIDO */
        T-CDOCU.NroPed = B-CPEDM.NroPed
        T-CDOCU.Tipo   = s-Tipo
        T-CDOCU.CodCaja= s-CodTer
        T-CDOCU.FchVto = TODAY
        T-CDOCU.CodCli = T-CODES.CodCli
        T-CDOCU.NomCli = T-CODES.NomCli
        T-CDOCU.RucCli = T-CODES.RucCli
        T-CDOCU.CodAnt = T-CODES.Atencion     /* DNI */
        T-CDOCU.DirCli = T-CODES.DirCli
        T-CDOCU.CodVen = T-CODES.CodVen
        T-CDOCU.TipVta = "1"
        T-CDOCU.TpoFac = "CO"                  /* CONTADO */
        T-CDOCU.FmaPgo = T-CODES.FmaPgo
        T-CDOCU.CodMon = T-CODES.CodMon
        T-CDOCU.TpoCmb = FacCfgGn.TpoCmb[1]
        T-CDOCU.PorIgv = T-CODES.PorIgv
        T-CDOCU.NroOrd = T-CODES.ordcmp
        T-CDOCU.FlgEst = "P"                   /* PENDIENTE */
        T-CDOCU.FlgSit = "P"
        T-CDOCU.usuario = S-USER-ID
        T-CDOCU.HorCie = STRING(TIME,'hh:mm')
        /* INFORMACION DE LA TIQUETERA */
        T-CDOCU.libre_c03 = FacCorre.NroImp
        /* INFORMACION DEL P/M */
        T-CDOCU.Glosa     = B-CPEDM.Glosa
        T-CDOCU.TipBon[1] = B-CPEDM.TipBon[1]
        T-CDOCU.NroCard   = B-CPEDM.NroCard 
        T-CDOCU.FlgEnv    = B-CPEDM.FlgEnv /* OJO Control de envio de documento */
        T-CDOCU.FlgCbd    = B-CPEDM.FlgIgv
        /* RHC 18/01/2016 TCK Factura */
        T-CDOCU.Libre_c04 = B-CPEDM.Cmpbnte
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "NO se pudo generar el temporal de comprobantes".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* PUNTERO DE LA FACTURA */
    ASSIGN
        Fac_Rowid = ROWID(T-CDOCU).
    /* ********************* */

    FIND gn-convt WHERE gn-convt.Codig = T-CDOCU.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        T-CDOCU.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        T-CDOCU.FchVto = T-CDOCU.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    END.
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = T-CDOCU.CodCli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
        ASSIGN
            T-CDOCU.CodDpto = gn-clie.CodDept 
            T-CDOCU.CodProv = gn-clie.CodProv 
            T-CDOCU.CodDist = gn-clie.CodDist.
    END.
    /* ******************************** */
    IF cMess <> "" THEN ASSIGN T-CDOCU.Libre_c05 = cMess.        

    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = T-CDOCU.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN T-CDOCU.cco = gn-ven.cco.
    /* TRACKING FACTURAS */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            T-CDOCU.CodPed,
                            T-CDOCU.NroPed,
                            s-User-Id,
                            'EFAC',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            T-CDOCU.coddoc,
                            T-CDOCU.nrodoc,
                            T-CDOCU.Libre_c01,
                            T-CDOCU.Libre_c02).
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION L-table-Win 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Segundo Generamos los comprobantes que faltan */
DEF VAR iNroOrden AS INT NO-UNDO.

DEFINE VAR x-retval AS CHAR.

x-retval = fadd-log-txt("SECOND-TRANSACTION : " + T-CDOCU.CodDiv + " " + T-CDOCU.CodDoc + " " + T-CDOCU.nroDoc + " - INICIO") NO-ERROR.

pMensaje = "".
iNroOrden = 0.
TERCERO:
FOR EACH T-CDOCU NO-LOCK ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    iNroOrden = iNroOrden + 1.
    FIND Ccbcdocu OF T-CDOCU NO-LOCK NO-ERROR.
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat\progress-to-ppll-v3 ( INPUT Ccbcdocu.CodDiv,
                                    INPUT Ccbcdocu.CodDoc,
                                    INPUT Ccbcdocu.NroDoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT pMensaje ).
    /* RHC 09/04/2018 En todos los casos de error ANULAMOS los movimientos */
    IF RETURN-VALUE <> "OK" THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR confirmación de ePos".
        RETURN "ERROR-EPOS".
    END.
/*     CASE TRUE:                                                                                                        */
/*         WHEN iNroOrden = 1 AND RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                    */
/*             /* Falló al primer comprobante => Roll Back */                                                            */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR conexión de ePos".   */
/*             IF RETURN-VALUE = 'ERROR-EPOS' THEN IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR grabación de ePos". */
/*             RETURN 'ADM-ERROR'.     /* ROLL-BACK */                                                                   */
/*         END.                                                                                                          */
/*         WHEN iNroOrden > 1 AND RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                    */
/*             IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR grabación de ePos".                                     */
/*             RETURN 'ERROR-EPOS'.     /* EXTORNO */                                                                    */
/*         END.                                                                                                          */
/*         WHEN RETURN-VALUE = 'ERROR-EPOS' THEN DO:                                                                     */
/*             IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR confirmación de ePos".                                  */
/*             RETURN 'ERROR-EPOS'.     /* EXTORNO */                                                                    */
/*         END.                                                                                                          */
/*     END CASE.                                                                                                         */
END.

x-retval = fadd-log-txt("SECOND-TRANSACTION : " + T-CDOCU.CodDiv + " " + T-CDOCU.CodDoc + " " + T-CDOCU.nroDoc + " - FINAL") NO-ERROR.

RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE THIRD-TRANSACTION L-table-Win 
PROCEDURE THIRD-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR.

x-retval = fadd-log-txt("THIRD-TRANSACTION : " + s-CodDiv + " " + s-CodCja + " " + NroDocCja + " - INICIO").

FIND Ccbccaja WHERE CcbCCaja.CodCia = s-CodCia
/*     AND CcbCCaja.CodDiv = s-CodDiv */
    AND CcbCCaja.CodDoc = s-CodCja
    AND CcbCCaja.NroDoc = NroDocCja
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbccaja THEN DO:
    /*RUN sunat\p-extorna-ic-sunat ( ROWID(CcbCCaja) ).*/
    RUN sunat/p-extorna-ic-sunat ( CcbCCaja.coddiv, CcbCCaja.coddoc, CcbCCaja.nrodoc).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
END.
x-retval = fadd-log-txt("THIRD-TRANSACTION : " + s-CodDiv + " " + s-CodCja + " " + NroDocCja + " - FIN").
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fadd-log-txt L-table-Win 
FUNCTION fadd-log-txt RETURNS CHARACTER
      (INPUT pTexto AS CHAR) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    /* NO escribir en el LOG TXT */
    IF x-log-epos = NO THEN RETURN "".

    DEFINE BUFFER x-factabla FOR factabla.

    /* IP de la PC */
    DEFINE VAR x-ip AS CHAR.
    DEFINE VAR x-pc AS CHAR.

    RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

    /* ---- */
    DEFINE VAR lClientComputerName  AS CHAR.
    DEFINE VAR lClientName          AS CHAR.
    DEFINE VAR lComputerName        AS CHAR.

    DEFINE VAR lPCName AS CHAR.

    lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME").
    lClientName         = OS-GETENV ( "CLIENTNAME").
    lComputerName       = OS-GETENV ( "COMPUTERNAME").

    lPcName = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
    lPCName = IF (CAPS(lPCName) = "CONSOLE") THEN "" ELSE lPCName.
    lPCName = IF (lPCName = ? OR lPCName = "") THEN lComputerName ELSE lPCName.
    /* ------ */

    FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia 
                                and x-factabla.tabla = 'TXTLOGEPOS'
                                and x-factabla.codigo = 'ALL'
                                NO-LOCK NO-ERROR.

    IF AVAILABLE x-factabla AND x-factabla.campo-l[1] = YES THEN DO:
        DEFINE VAR x-archivo AS CHAR.
        DEFINE VAR x-file AS CHAR.
        DEFINE VAR x-linea AS CHAR.

        x-file = STRING(TODAY,"99/99/9999").
        /*x-file = x-file + "-" + STRING(TIME,"HH:MM:SS").*/

        x-file = REPLACE(x-file,"/","").
        x-file = REPLACE(x-file,":","").

        x-archivo = session:TEMP-DIRECTORY + "conect-epos-" + x-file + ".txt".

        OUTPUT STREAM log-epos TO VALUE(x-archivo) APPEND.

        x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " (" + lPCName + "-" + x-pc + ":" + x-ip + ") - " + TRIM(pTexto).

        PUT STREAM log-epos x-linea FORMAT 'x(300)' SKIP.

        OUTPUT STREAM LOG-epos CLOSE.
    END.

    RETURN "".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

