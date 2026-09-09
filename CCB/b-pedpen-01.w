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

DEFINE BUFFER B-CPEDM FOR FacCPedm.
DEFINE SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedm
   FIELD CodRef LIKE CcbCDocu.CodRef
   FIELD NroRef LIKE CcbCDocu.NroRef.
DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedm.

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
DEFINE SHARED VARIABLE cl-codcia    AS INT.

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

/* Preprocesadores para condiciones */  
&SCOPED-DEFINE CONDICION ~
    (Faccpedm.CodCia = S-CODCIA AND Faccpedm.CodDoc = "P/M" ~
    AND Faccpedm.FlgEst = "P" AND Faccpedm.CodDiv = S-CODDIV AND ~
    Faccpedm.FchPed = TODAY AND FaccPedm.Cmpbnte BEGINS radio-set-1)

&SCOPED-DEFINE CODIGO Faccpedm.NroPed

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 (Faccpedm.NomCli BEGINS FILL-IN-filtro)
&SCOPED-DEFINE FILTRO2 (INDEX(Faccpedm.NomCli, FILL-IN-filtro) <> 0 )

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
&Scoped-define INTERNAL-TABLES Faccpedm

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Faccpedm.NroPed Faccpedm.NomCli ~
C-MON @ C-MON Faccpedm.ImpTot Faccpedm.FchPed Faccpedm.Hora ~
Faccpedm.Cmpbnte Faccpedm.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH Faccpedm WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY Faccpedm.Hora INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Faccpedm WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY Faccpedm.Hora INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table Faccpedm
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Faccpedm


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RADIO-SET-1 FILL-IN-filtro ~
CMB-filtro RECT-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-TotMe FILL-IN-TotMn RADIO-SET-1 ~
FILL-IN-filtro CMB-filtro 

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
      Faccpedm SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table L-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Faccpedm.NroPed FORMAT "XXX-XXXXXXXX":U
      Faccpedm.NomCli COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(35)":U
      C-MON @ C-MON COLUMN-LABEL "Mon" FORMAT "X(4)":U COLUMN-FONT 1
      Faccpedm.ImpTot FORMAT "->>>>,>>9.99":U COLUMN-FONT 1
      Faccpedm.FchPed COLUMN-LABEL "Fecha de     !Emision" FORMAT "99/99/9999":U
      Faccpedm.Hora COLUMN-LABEL "Hora!Emision" FORMAT "X(5)":U
      Faccpedm.Cmpbnte COLUMN-LABEL "Com." FORMAT "X(3)":U
      Faccpedm.usuario FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 82 BY 13.04
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.31 COL 3
     FILL-IN-TotMe AT ROW 15.62 COL 71 COLON-ALIGNED
     FILL-IN-TotMn AT ROW 15.62 COL 52 COLON-ALIGNED
     RADIO-SET-1 AT ROW 1.42 COL 60.29 NO-LABEL
     FILL-IN-filtro AT ROW 1.42 COL 24.57 NO-LABEL
     CMB-filtro AT ROW 1.38 COL 3.14 NO-LABEL
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table 1 F-Main */
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
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.Faccpedm"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _OrdList          = "integral.Faccpedm.Hora|yes"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > integral.Faccpedm.NroPed
"Faccpedm.NroPed" ? "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.Faccpedm.NomCli
"Faccpedm.NomCli" "Nombre o Razon Social" "x(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"C-MON @ C-MON" "Mon" "X(4)" ? ? ? 1 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.Faccpedm.ImpTot
"Faccpedm.ImpTot" ? "->>>>,>>9.99" "decimal" ? ? 1 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.Faccpedm.FchPed
"Faccpedm.FchPed" "Fecha de     !Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.Faccpedm.Hora
"Faccpedm.Hora" "Hora!Emision" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.Faccpedm.Cmpbnte
"Faccpedm.Cmpbnte" "Com." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


ON FIND OF FacCPedm DO:
    C-MON = "S/.".
    IF Faccpedm.CodMon = 2 THEN C-MON = "US$".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaBD L-table-Win 
PROCEDURE proc_AplicaBD :
/*------------------------------------------------------------------------------
  Purpose:     Crea INGRESO DE CAJA según parámetros
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_NroDoc LIKE CCBDMOV.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CCBDMOV.NroDoc.
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CcbCDocu.tpocmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CCBDMOV.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CCBDMOV.ImpTot.
    DEFINE INPUT PARAMETER para_CodBco LIKE CCBDMOV.CodBco.

    /* Tipo de Documento */
    FIND FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = "BD"
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
           'BOLETA DE DEPOSITO NO CONFIGURADO'
                VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

        FIND ccbboldep WHERE
            ccbboldep.CodCia = s-CodCia AND
            ccbboldep.CodDoc = "BD" AND
            ccbboldep.nrodoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE CcbBolDep THEN DO:
            MESSAGE
                "BOLETA DE DEPOSITO" para_NroDoc "NO EXISTE"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.

        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.NroDoc = ccbboldep.NroDoc
            CCBDMOV.CodDoc = ccbboldep.CodDoc
            CCBDMOV.CodMon = ccbboldep.CodMon
            CCBDMOV.CodRef = s-CodCja
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = ccbboldep.CodCli
            CCBDMOV.FchDoc = ccbboldep.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.CodBco = para_CodBco
            CCBDMOV.usuario = s-User-ID.

        IF ccbboldep.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.

        ASSIGN CcbBolDep.SdoAct = CcbBolDep.SdoAct - CCBDMOV.ImpTot.

        IF CcbBolDep.SdoAct <= 0 THEN
            ASSIGN
                CcbBolDep.FchCan = TODAY
                CcbBolDep.FlgEst = "C".

    END. /* DO TRANSACTION... */

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

    END. /* DO TRANSACTION... */

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

    REPEAT WHILE AVAILABLE FacCPedm:
        IF AVAILABLE Gn-Tccja THEN DO:    
            IF FacCPedm.codmon = 1 THEN
                ASSIGN
                    X-SdoNac = FacCPedm.imptot
                    X-SdoUsa = ROUND(FacCPedm.imptot / ROUND(Gn-Tccja.Compra,3),2).
            ELSE
                ASSIGN
                    X-SdoUsa = FacCPedm.imptot
                    X-SdoNac = ROUND(FacCPedm.imptot * ROUND(Gn-Tccja.Venta,3),2).
        END.
        ELSE DO:
            IF FacCPedm.codmon = 1 THEN
                ASSIGN
                    X-SdoNac = FacCPedm.imptot
                    X-SdoUsa = 0.
            ELSE
                ASSIGN
                    X-SdoUsa = FacCPedm.imptot
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
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CanPed L-table-Win 
PROCEDURE proc_CanPed :
/*------------------------------------------------------------------------------
  Purpose:     Impresion de documentos generados
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i           AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE d_rowid     AS ROWID NO-UNDO.
    DEFINE VARIABLE x_cto1      AS DECIMAL INITIAL 0.
    DEFINE VARIABLE x_cto2      AS DECIMAL INITIAL 0.
    DEFINE VARIABLE list_docs   AS CHARACTER.
    DEFINE VARIABLE NroDocCja   AS CHARACTER.
    DEFINE VARIABLE cliename    LIKE Gn-Clie.Nomcli.
    DEFINE VARIABLE clieruc     LIKE Gn-Clie.Ruc.
    DEFINE VARIABLE monto_ret   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dTpoCmb     LIKE CcbcCaja.TpoCmb NO-UNDO.

    IF NOT AVAILABLE FacCPedm THEN RETURN.
    d_rowid = ROWID(FacCPedm).

    /* Verifica I/C por sencillo */
    RUN proc_verifica_ic.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

    FIND B-CPEDM WHERE ROWID(B-CPEDM) = d_rowid NO-LOCK NO-ERROR. 

    /* SOLO CONTADO Y CONTADO ANTICIPADO GENERAN INGRESO A CAJA */

    /* NUMERO DE SERIE DEL COMPROBANTE PARA TERMINAL */
    s-CodDoc = B-CPEDM.Cmpbnte.
    FIND FIRST ccbdterm WHERE
        CcbDTerm.CodCia = s-codcia AND
        CcbDTerm.CodDiv = s-coddiv AND
        CcbDTerm.CodDoc = s-CodDoc AND
        CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbdterm THEN DO:
        MESSAGE
            "DOCUMENTO" s-CodDoc "NO ESTA CONFIGURADO EN ESTE TERMINAL"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    s-PtoVta = Ccbdterm.nroser.

    /* COMPROBANTE */
    FIND FacDocum WHERE
        facdocum.codcia = s-codcia AND
        facdocum.coddoc = s-CodDoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDocum THEN DO:
        MESSAGE
            "NO ESTA DEFINIDO EL DOCUMENTO" s-CodDoc
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    s-CodMov = Facdocum.codmov.

    IF LOOKUP(B-CPEDM.FmaPgo,"000,001") > 0 THEN DO:
        /* MOVIMIENTO DE ALMACEN */
        FIND almtmovm WHERE
            Almtmovm.CodCia = s-codcia AND
            Almtmovm.Codmov = s-codmov AND
            Almtmovm.Tipmov = "S"
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtmovm THEN DO:
            MESSAGE
                "NO ESTA DEFINIDO EL MOVIMIENTO DE SALIDA" s-codmov
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.

    IF LOOKUP(B-CPEDM.FmaPgo,"000,002") > 0 THEN DO:

        /* Retenciones */
        FOR EACH wrk_ret:
            DELETE wrk_ret.
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
                RUN ccb/d-retenc-01(OUTPUT l-ok, OUTPUT monto_ret).
                IF l-ok = NO THEN RETURN "ADM-ERROR".
            END.
        END.

        /* VENTANA DE CANCELACIÓN */
        RUN ccb/d-canped-01(
            B-CPEDM.codmon,     /* Moneda Documento */
            B-CPEDM.imptot,     /* Importe Total */
            monto_ret,          /* Retención */
            B-CPEDM.CodCli,     /* Código Cliente */
            B-CPEDM.NomCli,     /* Nombre Cliente */
            TRUE,               /* Venta Contado */
            B-CPEDM.FlgSit,     /* Pago con Tarjeta de Crédito */
            OUTPUT L-OK).       /* Flag Retorno */
    END.
    ELSE L-OK = YES.

    IF L-OK = NO THEN RETURN "ADM-ERROR".

    RUN proc_CreTmp.

    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND B-CPEDM WHERE ROWID(B-CPEDM) = d_rowid EXCLUSIVE-LOCK NO-ERROR. 
        IF NOT AVAILABLE B-CPEDM THEN UNDO, RETURN 'ADM-ERROR'.
        FOR EACH T-CPEDM:
            S-CodAlm = TRIM(T-CPEDM.CodAlm).   /* << OJO << lo tomamos del pedido */
            FIND faccorre WHERE
                faccorre.codcia = s-codcia AND  
                faccorre.coddoc = s-CodDoc AND  
                faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
            /* Crea Documento */
            CREATE CcbCDocu.
            ASSIGN
                CcbCDocu.CodCia = S-CodCia
                CcbCDocu.CodDiv = S-CodDiv
                CcbCDocu.CodDoc = s-CodDoc
                Ccbcdocu.nrodoc = STRING(faccorre.nroser, "999") +
                    STRING(FacCorre.Correlativo, "999999")
                Faccorre.correlativo = Faccorre.correlativo + 1.
            RELEASE faccorre.
            ASSIGN
                T-CPEDM.CodRef    = s-CodDoc
                T-CPEDM.NroRef    = ccbcdocu.nrodoc
                CcbCDocu.FchDoc   = TODAY
                CcbCDocu.usuario  = S-User-Id
                CcbCDocu.usrdscto = T-CPEDM.usrdscto 
                CcbCDocu.Tipo     = S-Tipo
                CcbCDocu.CodAlm   = S-CodAlm
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
                CcbCDocu.NroPed   = B-CPEDM.NroPed
                CcbCDocu.PorIgv   = T-CPEDM.porigv 
                CcbCDocu.PorDto   = T-CPEDM.PorDto
                CcbCDocu.SdoAct   = T-CPEDM.imptot
                CcbCDocu.TpoCmb   = T-CPEDM.tpocmb
                CcbCDocu.Glosa    = T-CPEDM.Glosa
                CcbCDocu.TipBon[1] = T-CPEDM.TipBon[1]
                CcbCDocu.NroCard  = T-CPEDM.NroCard 
                CcbCDocu.FlgEnv   = B-CPEDM.FlgEnv. /* OJO Control de envio de documento */
/*
            /* Puntos Bonus */
            ASSIGN
                CcbCDocu.AcuBon[1] = T-CPEDM.AcuBon[1]
                CcbCDocu.AcuBon[2] = T-CPEDM.Importe[1]
                CcbCDocu.AcuBon[3] = T-CPEDM.Importe[2].
*/
            /* Lista de Docs para el Message */
            IF list_docs = "" THEN list_docs = ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc.
            ELSE list_docs = list_docs + CHR(10) + ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc.

            /* Guarda Centro de Costo */
            FIND gn-ven WHERE
                gn-ven.codcia = s-codcia AND
                gn-ven.codven = ccbcdocu.codven
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-ven THEN ccbcdocu.cco = gn-ven.cco.

            /* Guarda Tipo de Entrega */
            ASSIGN
                CcbCDocu.CodAge = T-CPEDM.CodTrans
                CcbCDocu.FlgSit = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE ""
                CcbCDocu.FlgCon = IF T-CPEDM.DocDesp = "GUIA" THEN "G" ELSE "".
            IF B-CPEDM.FmaPgo = "001" THEN CcbCDocu.FlgCon = "E".
            IF B-CPEDM.FmaPgo = "002" THEN CcbCDocu.FlgCon = "A".

            /* Actualiza Detalle */
            i = 1.
            FOR EACH T-DPEDM OF T-CPEDM BY nroitm:
                CREATE CcbDDocu.
                ASSIGN
                    CcbDDocu.CodCia = ccbcdocu.codcia
                    CcbDDocu.CodDiv = ccbcdocu.coddiv
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
                    CcbDDocu.Por_Dsctos[1] = T-DPEDM.Por_Dsctos[1]
                    CcbDDocu.Por_Dsctos[2] = T-DPEDM.Por_Dsctos[2]
                    CcbDDocu.Por_Dsctos[3] = T-DPEDM.Por_Dsctos[3]
                    CcbDDocu.Flg_factor = T-DPEDM.Flg_factor
                    CcbDDocu.FchDoc = TODAY.
                i = i + 1.

                /* Guarda Costos */
                FIND Almmmatg WHERE
                    Almmmatg.CodCia = S-CODCIA AND
                    Almmmatg.codmat = CcbDDocu.Codmat 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almmmatg THEN DO: 
                    IF almmmatg.monvta = 1 THEN DO:
                        x_cto1 = ROUND(Almmmatg.Ctotot *
                            CcbDDocu.CanDes * CcbDDocu.Factor,2).
                        x_cto2 = ROUND((Almmmatg.Ctotot *
                            CcbDDocu.CanDes * CcbDDocu.Factor) / Almmmatg.Tpocmb,2).
                    END.
                    IF almmmatg.monvta = 2 THEN DO:
                        x_cto1 = ROUND(Almmmatg.Ctotot * CcbDDocu.CanDes *
                            CcbDDocu.Factor * Almmmatg.TpoCmb, 2).
                        x_cto2 = ROUND((Almmmatg.Ctotot * CcbDDocu.CanDes *
                            CcbDDocu.Factor), 2).
                    end.
                    CcbDDocu.ImpCto =
                        IF CcbCDocu.Codmon = 1 THEN x_cto1 ELSE x_cto2.
                END.
                CcbCDocu.ImpCto = CcbCDocu.ImpCto + CcbDDocu.ImpCto.

            END. /* FOR EACH T-DPEDM OF... */

            /* CALCULO DE PUNTOS BONUS */
            RUN vta/puntosbonus(
                ccbcdocu.codcia,
                ccbcdocu.coddoc,
                ccbcdocu.coddiv,
                ccbcdocu.nrodoc).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        END. /* FOR EACH T-CPEDM... */

        /* Actualiza Flag del pedido */
        ASSIGN B-CPEDM.flgest = "C".

        IF LOOKUP(B-CPEDM.FmaPgo,"000,002") > 0 THEN DO:

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
                RUN proc_AplicaBD(
                    T-CcbCCaja.Voucher[5],
                    NroDocCja,
                    T-CcbCCaja.tpocmb,
                    T-CcbCCaja.ImpNac[5],
                    T-CcbCCaja.ImpUsa[5],
                    T-CcbCCaja.CodBco[5]
                    ).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            END.

            /* Aplica de Nota de Credito */
            IF T-CcbCCaja.Voucher[6] <> "" AND
                (T-CcbCCaja.ImpNac[6] + T-CcbCCaja.ImpUsa[6]) > 0 THEN DO:
                RUN proc_AplicaDoc(
                    "N/C",
                    T-CcbCCaja.Voucher[6],
                    NroDocCja,
                    T-CcbCCaja.tpocmb,
                    T-CcbCCaja.ImpNac[6],
                    T-CcbCCaja.ImpUsa[6]
                    ).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
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

        END. /* IF LOOKUP(B-CPEDM.FmaPgo,"000,002")... */

        /**** SOLO CONTADO Y CONTRA ENTREGA DESCARGAN DEL ALMACEN ****/
        IF LOOKUP(B-CPEDM.FmaPgo,"000,001") > 0 THEN DO:
            RUN proc_DesAlm.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
        END.
        IF LOOKUP(B-CPEDM.FmaPgo,"002") > 0 THEN DO:
            RUN Proc_OrdDes.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN ERROR.
        END.

        /* Actualiza Control de Vales de Compras */
        FOR EACH T-VVALE:
            CREATE VtaVVale.
            BUFFER-COPY T-VVALE TO VtaVVale
            ASSIGN
                VtaVVale.CodCia = s-codcia
                VtaVVale.CodDiv = s-coddiv
                VtaVVale.CodRef = s-CodCja
                VtaVVale.NroRef = NroDocCja
                VtaVVale.Fecha = TODAY
                VtaVVale.Hora = STRING(TIME,'HH:MM').
        END.

    END. /* DO TRANSACTION... */

    DO ON ENDKEY UNDO, LEAVE:
        MESSAGE
            list_docs SKIP
            "CONFIRMAR IMPRESION DE DOCUMENTO(S)"
            VIEW-AS ALERT-BOX INFORMATION.
    END.

    /* IMPRIME FACTURAS O BOLETAS Y SUS ORDENES DE DESPACHO */
    FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
        FIND CcbCDocu WHERE
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDiv = S-CodDiv AND
            CcbCDocu.CodDoc = T-CPEDM.CodRef AND
            CcbCDocu.NroDoc = T-CPEDM.NroRef
            NO-LOCK NO-ERROR. 
        IF AVAILABLE CcbCDocu THEN DO:
            IF Ccbcdocu.CodDoc = "FAC" THEN RUN ccb/r-fact01 (ROWID(ccbcdocu)).
            IF Ccbcdocu.CodDoc = "BOL" THEN RUN ccb/r-bole01 (ROWID(ccbcdocu)).
            IF Ccbcdocu.CodDoc = "TCK" THEN RUN ccb/r-tick500 (ROWID(ccbcdocu)).
            FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
                IF AVAIL CcbDdocu THEN
                    RUN ccb/r-odesp (ROWID(ccbcdocu), CcbDDocu.AlmDes).
        END.
    END.

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).

    GET FIRST {&BROWSE-NAME}.

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

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreTmp L-table-Win 
PROCEDURE proc_CreTmp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x_igv AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x_isc AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x_NewPed AS LOGICAL INIT YES NO-UNDO.
    DEFINE VARIABLE i_NPed   AS INTEGER INIT 0.
    DEFINE VARIABLE i_NItem  AS INTEGER INIT 0.

    FOR EACH T-CPEDM:
        DELETE T-CPEDM.
    END.
    FOR EACH T-DPEDM:
        DELETE T-DPEDM.
    END.

    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

    FOR EACH FacDPedm OF FacCPedm
        BREAK BY FacDPedm.CodCia BY TRIM(FacDPedm.AlmDes): 
        IF FIRST-OF(TRIM(FacDPedm.AlmDes)) OR x_NewPed THEN DO:
            i_NPed = i_NPed + 1.
            CREATE T-CPEDM.
            BUFFER-COPY FacCPedm TO T-CPEDM
                ASSIGN
                    T-CPEDM.NroPed =
                        SUBSTRING(FacCPedm.NroPed,1,3) + STRING(i_NPed,"999999")
                    T-CPEDM.CodAlm = TRIM(FacDPedm.AlmDes)        /* OJO */
                    T-CPEDM.ImpBrt = 0
                    T-CPEDM.ImpDto = 0
                    T-CPEDM.ImpExo = 0
                    T-CPEDM.ImpIgv = 0
                    T-CPEDM.ImpIsc = 0
                    T-CPEDM.ImpTot = 0
                    T-CPEDM.ImpVta = 0
                    T-CPEDM.NroCard = FacCPedm.NroCard.
            x_igv = 0.
            x_isc = 0.
            x_NewPed = NO.
            i_NItem = 0.
        END.

        ASSIGN
            x_igv = x_igv + FacDPedm.ImpIgv
            x_isc = x_isc + FacDPedm.ImpIsc
            T-CPEDM.ImpTot = T-CPEDM.ImpTot + FacDPedm.ImpLin.

        /* No Imponible */
        IF NOT FacDPedm.AftIgv THEN DO:
            T-CPEDM.ImpExo = T-CPEDM.ImpExo + FacDPedm.ImpLin.
            T-CPEDM.ImpDto = T-CPEDM.ImpDto + FacDPedm.ImpDto.
        END.
        /* Imponible */
        ELSE DO:
            T-CPEDM.ImpDto = T-CPEDM.ImpDto +
                ROUND(FacDPedm.ImpDto / (1 + FacCPedm.PorIgv / 100),2).
        END.

        CREATE T-DPEDM.
            BUFFER-COPY FacDPedm TO T-DPEDM
                ASSIGN T-DPEDM.NroPed = T-CPEDM.NroPed.

        i_NItem = i_NItem + 1.
        IF (T-CPEDM.Cmpbnte = "BOL" AND i_NItem >= FacCfgGn.Items_Boleta) OR
            (T-CPEDM.Cmpbnte = "FAC" AND i_NItem >= FacCfgGn.Items_Factura) THEN DO:
            x_NewPed = YES.
        END.

        IF LAST-OF(TRIM(FacDPedm.AlmDes)) OR x_NewPed THEN DO:
            ASSIGN 
                T-CPEDM.ImpIgv = ROUND(x_igv,2)
                T-CPEDM.ImpIsc = ROUND(x_isc,2)
                T-CPEDM.ImpVta = T-CPEDM.ImpTot - T-CPEDM.ImpExo - T-CPEDM.ImpIgv.
            /*** DESCUENTO GLOBAL ****/
            IF T-CPEDM.PorDto > 0 THEN DO:
                ASSIGN
                    T-CPEDM.ImpDto = T-CPEDM.ImpDto +
                        ROUND((T-CPEDM.ImpVta + T-CPEDM.ImpExo) *
                        T-CPEDM.PorDto / 100,2)
                    T-CPEDM.ImpTot = ROUND(T-CPEDM.ImpTot *
                        (1 - T-CPEDM.PorDto / 100),2)
                    T-CPEDM.ImpVta = ROUND(T-CPEDM.ImpVta *
                        (1 - T-CPEDM.PorDto / 100),2)
                    T-CPEDM.ImpExo = ROUND(T-CPEDM.ImpExo *
                        (1 - T-CPEDM.PorDto / 100),2)
                    T-CPEDM.ImpIgv =
                        T-CPEDM.ImpTot - T-CPEDM.ImpExo - T-CPEDM.ImpVta.
            END.
            T-CPEDM.ImpBrt =
                T-CPEDM.ImpVta + T-CPEDM.ImpIsc + T-CPEDM.ImpDto + T-CPEDM.ImpExo.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_DesAlm L-table-Win 
PROCEDURE proc_DesAlm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i AS INTEGER INITIAL 1 NO-UNDO.

    FOR EACH T-CPEDM NO-LOCK
        BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":

        FIND FIRST CcbCDocu WHERE 
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDoc = T-CPEDM.CodRef AND
            CcbCDocu.NroDoc = T-CPEDM.NroRef AND
            CcbCDocu.CodAlm = TRIM(T-CPEDM.CodAlm)
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT. 
        IF NOT AVAILABLE CcbCDocu THEN DO:
            RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
            UNDO, RETURN 'ADM-ERROR'.
        END.
        /* Correlativo de Salida */
        FIND Almacen WHERE 
            Almacen.CodCia = CcbCDocu.CodCia AND  
            Almacen.CodAlm = TRIM(CcbCDocu.CodAlm)
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
            UNDO, RETURN 'ADM-ERROR'.
        END.
        CREATE Almcmov.
        ASSIGN
            Almcmov.CodCia  = CcbCDocu.CodCia
            Almcmov.CodAlm  = trim(CcbCDocu.CodAlm)
            Almcmov.TipMov  = "S"
            Almcmov.CodMov  = CcbCDocu.CodMov
            Almcmov.NroSer  = s-PtoVta
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
            ASSIGN
                Almdmov.CodCia = AlmCmov.CodCia
                Almdmov.CodAlm = trim(AlmCmov.CodAlm)
                Almdmov.TipMov = trim(AlmCmov.TipMov)
                Almdmov.CodMov = AlmCmov.CodMov
                Almdmov.NroSer = Almcmov.NroSer
                Almdmov.NroDoc = Almcmov.NroDoc
                Almdmov.FchDoc = Almcmov.FchDoc
                Almdmov.NroItm = i
                Almdmov.codmat = trim(ccbddocu.codmat)
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
                Almdmov.Por_Dsctos[1] = ccbddocu.Por_Dsctos[1]
                Almdmov.Por_Dsctos[2] = ccbddocu.Por_Dsctos[2]
                Almdmov.Por_Dsctos[3] = ccbddocu.Por_Dsctos[3]
                Almdmov.Flg_factor = ccbddocu.Flg_factor
                Almdmov.Hradoc = STRING(TIME, "HH:MM:SS")
                Almcmov.TotItm = i
                i = i + 1.
            RUN alm/almdcstk (ROWID(almdmov)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
            RUN alm/almacpr1 (ROWID(almdmov), 'U').
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        END.
    END.

    RELEASE almcmov.
    RELEASE almdmov.

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

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':

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

        RELEASE faccorre.
    
        /* Crea Detalle de Caja */
        FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed:
            FIND CcbCDocu WHERE
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDiv = S-CodDiv AND
                CcbCDocu.CodDoc = T-CPEDM.CodRef AND
                CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR. 
            IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.
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
                CcbDCaja.TpoCmb = CcbCCaja.TpoCmb
                CcbCDocu.FlgEst = "C"
                CcbCDocu.FchCan = TODAY
                CcbCDocu.SdoAct = 0.
            RELEASE CcbCDocu.
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

        RELEASE ccbccaja.
        RELEASE ccbdcaja.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_OrdDes L-table-Win 
PROCEDURE proc_OrdDes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR F-CODDOC AS CHAR NO-UNDO.
    DEFINE VAR I-Nroped AS INTEGER NO-UNDO.
    DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.

    F-CODDOC = 'O/D'.
    FOR EACH T-CPEDM NO-LOCK BY T-CPEDM.NroPed ON ERROR UNDO, RETURN "ADM-ERROR":
        FIND FIRST CcbCDocu WHERE
            CcbCDocu.CodCia = S-CodCia AND
            CcbCDocu.CodDoc = T-CPEDM.CodRef AND
            CcbCDocu.NroDoc = T-CPEDM.NroRef EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
            /* RHC 29.05.04 se usa el correlativo del almacen de descarga */
            FIND FIRST FacCorre WHERE
                faccorre.codcia = s-codcia AND
                faccorre.coddoc = f-coddoc AND
                faccorre.codalm = ccbcdocu.codalm
                EXCLUSIVE-LOCK NO-ERROR.                             
            IF AVAILABLE FacCorre THEN DO:
                I-NroPed = FacCorre.Correlativo.
                CREATE FacCPedi NO-ERROR.
                ASSIGN
                    FacCPedi.CodCia = S-CodCia
                    FacCPedi.CodDoc = F-CodDoc
                    FacCPedi.NroPed = STRING(s-ptovta,"999") + STRING(I-NroPed,"999999")
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
                RELEASE FacCorre.
                ASSIGN
                    FacCPedi.FchPed = CcbCDocu.FchDoc
                    FacCPedi.CodAlm = trim(CcbCDocu.CodAlm)
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
                    ASSIGN
                        FacDPedi.CodCia = FacCPedi.CodCia 
                        FacDPedi.coddoc = FacCPedi.coddoc 
                        FacDPedi.NroPed = FacCPedi.NroPed 
                        FacDPedi.FchPed = FacCPedi.FchPed
                        FacDPedi.Hora   = FacCPedi.Hora 
                        FacDPedi.FlgEst = FacCPedi.FlgEst
                        FacDPedi.codmat = trim(CcbDDocu.codmat) 
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
                        FacDPedi.PreBas = CcbDDocu.PreBas
                        FacDPedi.Por_Dsctos[1] = CcbDDocu.Por_Dsctos[1]
                        FacDPedi.Por_Dsctos[2] = CcbDDocu.Por_Dsctos[2]
                        FacDPedi.Por_Dsctos[3] = CcbDDocu.Por_Dsctos[3]
                        FacDPedi.Flg_factor = CcbDDocu.Flg_factor.
                END.
                ASSIGN
                    CcbCDocu.CodRef = FacCPedi.CodDoc
                    CcbCDocu.NroRef = FacCPedi.NroPed.
                RELEASE FacDPedi.
                RELEASE FacCPedi.       
            END.
        END.
        RELEASE CcbCDocu.
    END.

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

