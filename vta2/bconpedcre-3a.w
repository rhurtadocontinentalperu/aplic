&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDIDO LIKE FacCPedi.
DEFINE TEMP-TABLE tt-vtadtrkped NO-UNDO LIKE vtadtrkped
       field f-situacion as char
       field f-estado as char
       field f-motivo as char
       field f-nro-hr as char
       field f-fcha-hr as date
       field f-nrobultos as int
       field f-peso as dec
       field f-volumen as dec
       field f-ubicacion as char.



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

/* Local Variable Definitions ---                                       */

DEF VAR x-Situacion AS CHAR NO-UNDO.

DEF VAR x-Estado AS CHAR NO-UNDO.
DEF VAR x-Motivo AS CHAR NO-UNDO.

DEF VAR x-NroBultos AS INT NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.

DEFINE VAR x-ubicacion AS CHAR.
DEFINE VAR x-nro-hr AS CHAR.
DEFINE VAR x-fcha-hr AS DATE.

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-di-rutaC FOR di-rutaC.
DEFINE BUFFER x-di-rutaD FOR di-rutaD.
DEFINE BUFFER x-vtacdocu FOR vtacdocu.
DEFINE BUFFER x-logtrkdocs FOR logtrkdocs.
DEFINE BUFFER x-tabtrkdocs FOR tabtrkdocs.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-vtadtrkped

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-vtadtrkped.CodDiv ~
tt-vtadtrkped.CodRef tt-vtadtrkped.NroRef tt-vtadtrkped.FechaI ~
tt-vtadtrkped.FechaT f-ubicacion @ x-ubicacion f-Situacion @ x-Situacion ~
f-nro-hr @ x-nro-hr x-fcha-hr @ x-fcha-hr f-Estado @ x-Estado ~
f-motivo @ x-Motivo f-NroBultos @ x-NroBultos f-Peso @ x-Peso ~
f-Volumen @ x-Volumen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH tt-vtadtrkped OF FacCPedi WHERE ~{&KEY-PHRASE} OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tt-vtadtrkped OF FacCPedi WHERE ~{&KEY-PHRASE} OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tt-vtadtrkped
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-vtadtrkped


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstadoDet B-table-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fFlgSit B-table-Win 
FUNCTION fFlgSit RETURNS CHARACTER
  ( INPUT pFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroBultos B-table-Win 
FUNCTION fNroBultos RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-vtadtrkped SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      tt-vtadtrkped.CodDiv FORMAT "x(5)":U
      tt-vtadtrkped.CodRef FORMAT "x(3)":U
      tt-vtadtrkped.NroRef FORMAT "X(9)":U WIDTH 11.14
      tt-vtadtrkped.FechaI COLUMN-LABEL "Inicio" FORMAT "99/99/9999 HH:MM:SS.SSS":U
            WIDTH 12.57
      tt-vtadtrkped.FechaT COLUMN-LABEL "Termino" FORMAT "99/99/9999 HH:MM:SS.SSS":U
            WIDTH 11.43
      f-ubicacion @ x-ubicacion COLUMN-LABEL "Ubicacion" FORMAT "x(40)":U
            WIDTH 20.29
      f-Situacion @ x-Situacion COLUMN-LABEL "Situación" FORMAT "x(20)":U
      f-nro-hr @ x-nro-hr COLUMN-LABEL "Hoja de Ruta" FORMAT "x(12)":U
      x-fcha-hr @ x-fcha-hr COLUMN-LABEL "Fecha HR"
      f-Estado @ x-Estado COLUMN-LABEL "Situacion" FORMAT "x(15)":U
      f-motivo @ x-Motivo COLUMN-LABEL "Motivo" FORMAT "x(20)":U
      f-NroBultos @ x-NroBultos COLUMN-LABEL "No. Bultos"
      f-Peso @ x-Peso COLUMN-LABEL "Peso kg"
      f-Volumen @ x-Volumen COLUMN-LABEL "Vol. m3"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 88 BY 8.23
         FONT 4
         TITLE "TRACKING PEDIDOS".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDIDO T "SHARED" ? INTEGRAL FacCPedi
      TABLE: tt-vtadtrkped T "?" NO-UNDO INTEGRAL vtadtrkped
      ADDITIONAL-FIELDS:
          field f-situacion as char
          field f-estado as char
          field f-motivo as char
          field f-nro-hr as char
          field f-fcha-hr as date
          field f-nrobultos as int
          field f-peso as dec
          field f-volumen as dec
          field f-ubicacion as char
      END-FIELDS.
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
         HEIGHT             = 9.12
         WIDTH              = 144.86.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tt-vtadtrkped OF INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = "OUTER, FIRST OUTER, FIRST OUTER"
     _FldNameList[1]   = Temp-Tables.tt-vtadtrkped.CodDiv
     _FldNameList[2]   = Temp-Tables.tt-vtadtrkped.CodRef
     _FldNameList[3]   > Temp-Tables.tt-vtadtrkped.NroRef
"tt-vtadtrkped.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-vtadtrkped.FechaI
"tt-vtadtrkped.FechaI" "Inicio" ? "datetime" ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-vtadtrkped.FechaT
"tt-vtadtrkped.FechaT" "Termino" ? "datetime" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"f-ubicacion @ x-ubicacion" "Ubicacion" "x(40)" ? ? ? ? ? ? ? no ? no no "20.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"f-Situacion @ x-Situacion" "Situación" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"f-nro-hr @ x-nro-hr" "Hoja de Ruta" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"x-fcha-hr @ x-fcha-hr" "Fecha HR" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"f-Estado @ x-Estado" "Situacion" "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"f-motivo @ x-Motivo" "Motivo" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"f-NroBultos @ x-NroBultos" "No. Bultos" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"f-Peso @ x-Peso" "Peso kg" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"f-Volumen @ x-Volumen" "Vol. m3" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* TRACKING PEDIDOS */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* TRACKING PEDIDOS */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* TRACKING PEDIDOS */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-data B-table-Win 
PROCEDURE cargar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-vtadtrkped.

SESSION:SET-WAIT-STATE("GENERAL").

DEFINE VAR x-sec AS INT INIT 0.

FOR EACH INTEGRAL.vtadtrkped WHERE INTEGRAL.vtadtrkped.CodCia = FacCPedi.CodCia
            AND INTEGRAL.vtadtrkped.CodDoc = FacCPedi.CodDoc
            AND INTEGRAL.vtadtrkped.NroPed = FacCPedi.NroPed NO-LOCK:
    
    CREATE tt-vtadtrkped.
    BUFFER-COPY vtadtrkped TO tt-vtadtrkped.

    ASSIGN tt-vtadtrkped.f-situacion = fFlgSit(tt-vtadtrkped.FlgSit).
    ASSIGN tt-vtadtrkped.f-estado = fEstado().
    ASSIGN tt-vtadtrkped.f-motivo = fEstadoDet().
    ASSIGN tt-vtadtrkped.f-NroBultos = fNroBultos().
    ASSIGN tt-vtadtrkped.f-peso = fPeso().
    ASSIGN tt-vtadtrkped.f-volumen = fVolumen().

    FIND FIRST TabGener WHERE TabGener.CodCia = tt-vtadtrkped.CodCia
                                AND TabGener.Clave = "TRKPED"
                                AND TabGener.Codigo = tt-vtadtrkped.CodUbic
                                NO-LOCK NO-ERROR.
    IF AVAILABLE TabGener THEN ASSIGN tt-vtadtrkped.f-ubicacion = TabGener.descripcion.

    FIND FIRST DI-RutaC WHERE DI-RutaC.CodCia = tt-vtadtrkped.CodCia
                            AND DI-RutaC.CodDiv = tt-vtadtrkped.CodDiv
                            AND DI-RutaC.CodDoc = tt-vtadtrkped.Libre_c01
                            AND DI-RutaC.NroDoc = tt-vtadtrkped.Libre_c02
                            NO-LOCK NO-ERROR.
    IF AVAILABLE di-rutaC THEN DO:
        ASSIGN tt-vtadtrkped.f-nro-hr = DI-RutaC.NroDoc
                tt-vtadtrkped.f-fcha-hr = DI-RutaC.fchdoc.
                
    END.

    x-sec = x-sec + 1.
END.

/*  */
FOR EACH x-faccpedi WHERE x-faccpedi.codcia = faccpedi.codcia AND
                    x-faccpedi.coddoc = 'O/D' AND
                    x-faccpedi.codref = faccpedi.coddoc AND
                    x-faccpedi.nroref = faccpedi.nroped AND
                    x-faccpedi.flgest <> "A" NO-LOCK:
    /* Ubico las PHR */
    FOR EACH x-di-rutaD WHERE x-di-rutaD.codcia = faccpedi.codcia AND
                            x-di-rutaD.coddoc = 'PHR' AND
                            x-di-rutaD.codref = x-faccpedi.coddoc AND
                            x-di-rutaD.nroref = x-faccpedi.nroped NO-LOCK:
        FIND FIRST x-di-rutaC OF x-di-rutaD WHERE x-di-rutaC.flgest <> "A"  NO-LOCK NO-ERROR.
        IF AVAILABLE x-di-rutaC THEN DO:
            /* Los HPK */
            FOR EACH x-vtacdocu WHERE x-vtacdocu.codcia = faccpedi.codcia AND
                                        x-vtacdocu.codped = 'HPK' AND
                                        x-vtacdocu.codori = x-di-rutaD.coddoc AND
                                        x-vtacdocu.nroori = x-di-rutaD.nrodoc AND   /* PHR */
                                        x-vtacdocu.codref = x-faccpedi.coddoc AND
                                        x-vtacdocu.nroref = x-faccpedi.nroped NO-LOCK:      /* O/D */
                /* El Tracking */
                FOR EACH x-logtrkdocs WHERE x-logtrkdocs.codcia = faccpedi.codcia AND
                                            x-logtrkdocs.coddoc = x-faccpedi.coddoc AND
                                            x-logtrkdocs.nrodoc = x-faccpedi.nroped AND     /* O/D */
                                            x-logtrkdocs.clave = 'TRCKHPK' BY orden:
                    FIND FIRST x-tabtrkdocs WHERE x-tabtrkdocs.codcia = faccpedi.codcia AND
                                                    x-tabtrkdocs.clave = x-logtrkdocs.clave AND 
                                                    x-tabtrkdocs.orden = x-logtrkdocs.orden AND
                                                    x-tabtrkdocs.codigo = x-logtrkdocs.codigo NO-LOCK NO-ERROR.
                    IF AVAILABLE x-tabtrkdocs THEN DO:
                        /**/
                    END.
                END.
            END.
        END.                           
    END.
END.

{&open-query-br_table}

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/*
      FIRST INTEGRAL.TabGener WHERE TabGener.CodCia = vtadtrkped.CodCia
  AND TabGener.Codigo = vtadtrkped.CodUbic
      AND TabGener.Clave = "TRKPED" OUTER-JOIN NO-LOCK,

*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN cargar-data.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "tt-vtadtrkped"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tracking-a-excel B-table-Win 
PROCEDURE tracking-a-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
define VAR cValue as char.


lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */


{lib\excel-open-file.i}

chExcelApplication:Visible = NO.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */
/*cColList - Array Columnas (A,B,C...AA,AB,AC...) */

chWorkSheet = chExcelApplication:Sheets:Item(1).  
iRow = 1.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE BUFFER b-pedido FOR pedido.
DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-vtadtrkped FOR vtadtrkped.
DEFINE BUFFER b-tabgener FOR tabgener.
DEFINE BUFFER b-di-rutaC FOR di-rutaC.

/* Cabecera */
cRange = "A" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Origen".
cRange = "B" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Lista**".
cRange = "C" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Numero".
cRange = "D" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "PDD".
cRange = "E" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Emision".
cRange = "F" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Vcto".
cRange = "G" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Entrega".
cRange = "H" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "O/D".
cRange = "I" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Cliente".
cRange = "J" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Nombre / Razon Social".
cRange = "K" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Vendedor".
cRange = "L" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Importe".
cRange = "M" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Estado".
cRange = "N" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "% Avance".
cRange = "O" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Total Items".
cRange = "P" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Total Peso Kgrs".
cRange = "Q" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Imp. Atendido".
cRange = "R" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Imp x Atender".

/* Detalle */
cRange = "S" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Division".
cRange = "T" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Codigo".
cRange = "U" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Numero".
cRange = "V" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Inicion".
cRange = "W" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Termino".
cRange = "X" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Ubicacion".
cRange = "Y" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Situacion".
cRange = "Z" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Hoja de Ruta".
cRange = "AA" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Fecha H/R".
cRange = "AB" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Situacion".
cRange = "AC" + TRIM(STRING(iRow)).
chWorkSheet:Range(cRange):VALUE = "Motivos".

iRow = iRow + 1.


/* Los Pedidos */ 
FOR EACH b-PEDIDO NO-LOCK,
      FIRST b-FacCPedi OF b-PEDIDO NO-LOCK :

    /* Tracking */
    FOR EACH b-vtadtrkped WHERE b-vtadtrkped.CodCia = b-FacCPedi.CodCia
                                AND b-vtadtrkped.CodDoc = b-FacCPedi.CodDoc
                                AND b-vtadtrkped.NroPed = b-FacCPedi.NroPed NO-LOCK :
        /* Cabecera */
        cRange = "A" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-faccpedi.coddiv.
        cRange = "B" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-pedido.libre_c01.
        cRange = "C" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-faccpedi.nroped.
        cRange = "D" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-faccpedi.codalm.
        cRange = "E" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-faccpedi.fchped.
        cRange = "F" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-faccpedi.fchven.
        cRange = "G" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-faccpedi.fchent.
        cRange = "H" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-pedido.ncmpbnte.
        cRange = "I" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-faccpedi.codcli.
        cRange = "J" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-faccpedi.nomcli.
        cRange = "K" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-faccpedi.codven.
        cRange = "L" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-faccpedi.imptot.
        cRange = "M" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-pedido.libre_c02.
        cRange = "N" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-pedido.libre_d01.
        cRange = "O" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-pedido.acubon[2].
        cRange = "P" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-pedido.acubon[3].
        cRange = "Q" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-pedido.acubon[4].
        cRange = "R" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-pedido.acubon[5].


        FIND FIRST b-TabGener WHERE b-TabGener.CodCia = b-vtadtrkped.CodCia
                            AND b-TabGener.Codigo = b-vtadtrkped.CodUbic
                            AND b-TabGener.Clave = "TRKPED" NO-LOCK NO-ERROR.

        FIND FIRST b-DI-RutaC WHERE b-DI-RutaC.CodCia = b-vtadtrkped.CodCia
                            AND b-DI-RutaC.CodDiv = b-vtadtrkped.CodDiv
                            AND b-DI-RutaC.CodDoc = b-vtadtrkped.Libre_c01
                            AND b-DI-RutaC.NroDoc = b-vtadtrkped.Libre_c02 NO-LOCK NO-ERROR.
        /* Detalle */
        cRange = "S" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-vtadtrkped.coddiv.
        cRange = "T" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-vtadtrkped.codref.
        cRange = "U" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + b-vtadtrkped.nroref.
        cRange = "V" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-vtadtrkped.fechaI.
        cRange = "W" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = b-vtadtrkped.fechaT.
        cRange = "X" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = if(AVAILABLE b-tabgener) THEN b-tabgener.descripcion ELSE "".
        cRange = "Y" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = fFlgSit(b-vtadtrkped.flgsit).
        cRange = "Z" + TRIM(STRING(iRow)).
        chWorkSheet:Range(cRange):VALUE = "'" + (if(AVAILABLE b-di-rutac) THEN b-di-rutac.nrodoc ELSE "").
        cRange = "AA" + TRIM(STRING(iRow)).
        IF AVAILABLE b-di-rutac THEN DO:
            chWorkSheet:Range(cRange):VALUE =  b-di-rutac.fchdoc.
            cValue = "".
            RUN alm/f-flgrut ("D", b-vtadtrkped.Libre_c03, OUTPUT cValue).

            cRange = "AB" + TRIM(STRING(iRow)).
            chWorkSheet:Range(cRange):VALUE = "'" + cValue.

            cRange = "AC" + TRIM(STRING(iRow)).
            FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
                AND AlmTabla.Codigo = b-vtadtrkped.Libre_c04
                AND almtabla.NomAnt = 'N'
                NO-LOCK NO-ERROR.
            IF AVAILABLE AlmTabla THEN chWorkSheet:Range(cRange):VALUE = "'" + almtabla.Nombre.

        END.
        iRow = iRow + 1.
    END.
END.
chExcelApplication:Visible = TRUE.
{lib\excel-close-file.i} 

SESSION:SET-WAIT-STATE('').

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF AVAILABLE Di-RutaC THEN DO:
      RUN alm/f-flgrut ("D", tt-vtadtrkped.Libre_c03, OUTPUT x-Estado).
      RETURN x-Estado.
/*       FIND Di-RutaD OF Di-RutaC WHERE Di-RutaD.codref = vtadtrkped.CodRef */
/*           AND Di-RutaD.nroref = vtadtrkped.NroRef                         */
/*           NO-LOCK NO-ERROR.                                               */
/*       IF AVAILABLE Di-RutaD THEN DO:                                      */
/*           RUN alm/f-flgrut ("D", Di-RutaD.flgest, OUTPUT x-Estado).       */
/*           RETURN x-Estado.                                                */
/*       END.                                                                */
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstadoDet B-table-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF AVAILABLE Di-RutaC THEN DO:
    FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
        AND AlmTabla.Codigo = tt-vtadtrkped.Libre_c04
        AND almtabla.NomAnt = 'N'
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.
/*     FIND Di-RutaD OF Di-RutaC WHERE Di-RutaD.codref = vtadtrkped.CodRef */
/*         AND Di-RutaD.nroref = vtadtrkped.NroRef                         */
/*         NO-LOCK NO-ERROR.                                               */
/*     IF AVAILABLE Di-RutaD THEN DO:                                      */
/*         FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'                       */
/*             AND AlmTabla.Codigo = DI-RutaD.FlgEstDet                    */
/*             AND almtabla.NomAnt = 'N'                                   */
/*             NO-LOCK NO-ERROR.                                           */
/*         IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.              */
/*     END.                                                                */
END.
RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fFlgSit B-table-Win 
FUNCTION fFlgSit RETURNS CHARACTER
  ( INPUT pFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.

RUN gn/fFlgSitTracking(pFlgSIt, OUTPUT pEstado).

RETURN pEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroBultos B-table-Win 
FUNCTION fNroBultos RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pParam AS INT NO-UNDO.

  FOR EACH Ccbcbult NO-LOCK WHERE CcbCBult.CodCia = tt-vtadtrkped.CodCia
      AND CcbCBult.CodDoc = tt-vtadtrkped.CodRef 
      AND CcbCBult.NroDoc = tt-vtadtrkped.NroRef :
      pParam = pParam + CcbCBult.Bultos.
  END.
  RETURN pParam.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pParam AS DEC NO-UNDO.

  FOR EACH Facdpedi NO-LOCK WHERE FacDPedi.CodCia = tt-vtadtrkped.CodCia
      AND FacDPedi.CodDoc = tt-vtadtrkped.CodRef
      AND FacDPedi.NroPed = tt-vtadtrkped.NroRef,
      FIRST Almmmatg OF Facdpedi NO-LOCK:
      pParam = pParam + (Facdpedi.canped * Facdpedi.factor * Almmmatg.Pesmat).
  END.
  RETURN pParam.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pParam AS DEC NO-UNDO.

  FOR EACH Facdpedi NO-LOCK WHERE FacDPedi.CodCia = tt-vtadtrkped.CodCia
      AND FacDPedi.CodDoc = tt-vtadtrkped.CodRef
      AND FacDPedi.NroPed = tt-vtadtrkped.NroRef,
      FIRST Almmmatg OF Facdpedi NO-LOCK:
      pParam = pParam + (Facdpedi.canped * Facdpedi.factor * Almmmatg.Libre_d02).
  END.
  RETURN (pParam / 1000000).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

