&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.



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


DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-CodDiv AS CHARACTER.
DEFINE SHARED VARIABLE s-CodDoc AS CHARACTER.
DEFINE SHARED VARIABLE lh_handle AS HANDLE.
DEFINE SHARED VARIABLE s-user-id AS CHAR.

DEFINE VARIABLE cCurrency AS CHAR NO-UNDO.
DEFINE VAR x-NroRef AS CHAR FORMAT 'x(20)' NO-UNDO.

&GLOBAL-DEFINE CONDICION ( ~
    FacCPedi.CodCia = s-CodCia AND ~
    FacCPedi.CodDoc = s-CodDoc AND ~
    FacCPedi.DivDes = s-CodDiv AND ~
    FacCPedi.FlgEst = "P" AND ~
    FacCPedi.FlgSit = "C" AND ~
    (RADIO-SET-TipDoc = "FAC" OR FacCPedi.Cmpbnte = "FAC")~
    )

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
&Scoped-define INTERNAL-TABLES FacCPedi FacDPedi gn-ConVt GN-DIVI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDoc FacCPedi.NroPed ~
FacCPedi.NomCli FacCPedi.FchPed fGetCurr(FacCPedi.CodMon) @ cCurrency ~
STRING(FacCPedi.Libre_c02, 'x(3)') + ' ' + STRING(FacCPedi.Libre_c03, 'x(10)') @ x-NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo ~
      AND (RADIO-SET-TipDoc = "FAC" OR gn-ConVt.Libre_l01 = TRUE) NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi ~
      WHERE (RADIO-SET-TipDoc = "FAC" OR GN-DIVI.flgrep = TRUE) NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo ~
      AND (RADIO-SET-TipDoc = "FAC" OR gn-ConVt.Libre_l01 = TRUE) NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi ~
      WHERE (RADIO-SET-TipDoc = "FAC" OR GN-DIVI.flgrep = TRUE) NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi FacDPedi gn-ConVt GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacDPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-ConVt
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table GN-DIVI


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-TipDoc br_table 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-TipDoc 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGetCurr B-table-Win 
FUNCTION fGetCurr RETURNS CHARACTER
  ( INPUT iParaCodMon AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE RADIO-SET-TipDoc AS CHARACTER INITIAL "FAC" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Facturas Normales", "FAC",
"Facturas Internas", "FAI"
     SIZE 33 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi, 
      FacDPedi, 
      gn-ConVt, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U WIDTH 4
      FacCPedi.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U WIDTH 9.57
            COLUMN-FONT 0
      FacCPedi.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "x(50)":U
            WIDTH 44
      FacCPedi.FchPed COLUMN-LABEL "Fecha deEmisión" FORMAT "99/99/9999":U
      fGetCurr(FacCPedi.CodMon) @ cCurrency COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      STRING(FacCPedi.Libre_c02, 'x(3)') + ' ' + STRING(FacCPedi.Libre_c03, 'x(10)') @ x-NroRef COLUMN-LABEL "Referencia"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 96 BY 8.08
         FONT 4
         TITLE "ORDENES DE DESPACHO PARA FACTURAR".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-TipDoc AT ROW 1 COL 14 NO-LABEL WIDGET-ID 2
     br_table AT ROW 1.96 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "SHARED" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 9.15
         WIDTH              = 104.86.
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
/* BROWSE-TAB br_table RADIO-SET-TipDoc F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.FacDPedi OF INTEGRAL.FacCPedi,INTEGRAL.gn-ConVt WHERE INTEGRAL.FacCPedi ...,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST, FIRST, FIRST"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.NroPed|no"
     _Where[1]         = "{&CONDICION}"
     _JoinCode[3]      = "gn-ConVt.Codig = FacCPedi.FmaPgo"
     _Where[3]         = "(RADIO-SET-TipDoc = ""FAC"" OR gn-ConVt.Libre_l01 = TRUE)"
     _Where[4]         = "(RADIO-SET-TipDoc = ""FAC"" OR GN-DIVI.flgrep = TRUE)"
     _FldNameList[1]   > INTEGRAL.FacCPedi.CodDoc
"FacCPedi.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Número" ? "character" ? ? 0 ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre del Cliente" ? "character" ? ? ? ? ? ? no ? no no "44" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha deEmisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fGetCurr(FacCPedi.CodMon) @ cCurrency" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"STRING(FacCPedi.Libre_c02, 'x(3)') + ' ' + STRING(FacCPedi.Libre_c03, 'x(10)') @ x-NroRef" "Referencia" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main /* ORDENES DE DESPACHO PARA FACTURAR */
DO:
    RUN proc_GeneraGuia.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* ORDENES DE DESPACHO PARA FACTURAR */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* ORDENES DE DESPACHO PARA FACTURAR */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* ORDENES DE DESPACHO PARA FACTURAR */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-TipDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-TipDoc B-table-Win
ON VALUE-CHANGED OF RADIO-SET-TipDoc IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fraccionar-Orden B-table-Win 
PROCEDURE Fraccionar-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR rpta AS CHAR.

    IF NOT AVAILABLE FacCPedi OR
        {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
        MESSAGE
            "Seleccione una Orden de Despacho"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF Faccpedi.Libre_c02 = "O/D" THEN DO:
        MESSAGE 'NO se puede volver a fraccionar esta Orden'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Facdpedi THEN DO:
        MESSAGE 'La Orden ya tiene atenciones parciales' SKIP
            'No se puede fraccionar'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    RUN vtagn/p-TpoPed ( ROWID(Faccpedi) ).
    IF RETURN-VALUE = "LF" THEN DO:
        MESSAGE 'Acceso Denegado' SKIP 'Lista Express Web' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    RUN vta2/d-distribucion-factura-cred ( ROWID(Faccpedi), OUTPUT rpta ).
    IF rpta = 'ADM-ERROR' THEN RETURN.

    /* Se procede a fraccionar la Orden de Despacho */
    RUN vta2/pFraccionarOrden ( ROWID(Faccpedi), INPUT TABLE PEDI).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GeneraGuia B-table-Win 
PROCEDURE proc_GeneraGuia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT AVAILABLE FacCPedi OR
        {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
        MESSAGE
            "Seleccione una Orden de Despacho"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    CASE RADIO-SET-TipDoc:
        WHEN "FAC" THEN RUN sunat\dgeneracionfactcredito-v31 ( ROWID(FacCPedi), 'A', "CREDITO", "" ).       /* AUTOMATICA */
        WHEN "FAI" THEN RUN sunat\dgeneracionfactcredito-v31 ( ROWID(FacCPedi), 'FA', "CREDITO", "" ).       /* AUTOMATICA */
    END CASE.
/*     IF s-user-id = 'ADMIN' THEN DO:                                                                                              */
/*         CASE RADIO-SET-TipDoc:                                                                                                   */
/*             WHEN "FAC" THEN RUN sunat\dgeneracionfactcredito-v3 ( ROWID(FacCPedi), 'A', "CREDITO", "" ).       /* AUTOMATICA */  */
/*             WHEN "FAI" THEN RUN sunat\dgeneracionfactcredito-v3 ( ROWID(FacCPedi), 'FA', "CREDITO", "" ).       /* AUTOMATICA */ */
/*         END CASE.                                                                                                                */
/*     END.                                                                                                                         */
/*     ELSE DO:                                                                                                                     */
/*         CASE RADIO-SET-TipDoc:                                                                                                   */
/*             WHEN "FAC" THEN RUN sunat\dgeneracionfactcredito-v2 ( ROWID(FacCPedi), 'A', "CREDITO", "" ).       /* AUTOMATICA */  */
/*             WHEN "FAI" THEN RUN sunat\dgeneracionfactcredito-v2 ( ROWID(FacCPedi), 'FA', "CREDITO", "" ).       /* AUTOMATICA */ */
/*         END CASE.                                                                                                                */
/*     END.                                                                                                                         */
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GeneraGuiaManual B-table-Win 
PROCEDURE proc_GeneraGuiaManual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR rpta AS CHAR.

    IF NOT AVAILABLE FacCPedi OR
        {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
        MESSAGE
            "Seleccione una Orden de Despacho"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF Faccpedi.Libre_c02 = "O/D" THEN DO:
        MESSAGE "Esta Orden SOLO se puede hacer en formar AUTOMATICA"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF FacCPedi.Cmpbnte = "TCK" THEN DO:
        MESSAGE "Esta Orden SOLO se puede hacer en formar AUTOMATICA"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    RUN vta2/d-distribucion-factura-cred ( ROWID(Faccpedi), OUTPUT rpta ).
    IF rpta = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

    CASE RADIO-SET-TipDoc:
        WHEN "FAC" THEN RUN sunat\dgeneracionfactcredito-v31 ( ROWID(FacCPedi), 'M', "CREDITO", "" ).       /* AUTOMATICA */
        WHEN "FAI" THEN RUN sunat\dgeneracionfactcredito-v31 ( ROWID(FacCPedi), 'FM', "CREDITO", "" ).       /* AUTOMATICA */
    END CASE.
/*     IF s-user-id = 'ADMIN' THEN DO:                                                                                              */
/*         CASE RADIO-SET-TipDoc:                                                                                                   */
/*             WHEN "FAC" THEN RUN sunat\dgeneracionfactcredito-v3 ( ROWID(FacCPedi), 'M', "CREDITO", "" ).       /* AUTOMATICA */  */
/*             WHEN "FAI" THEN RUN sunat\dgeneracionfactcredito-v3 ( ROWID(FacCPedi), 'FM', "CREDITO", "" ).       /* AUTOMATICA */ */
/*         END CASE.                                                                                                                */
/*     END.                                                                                                                         */
/*     ELSE DO:                                                                                                                     */
/*         CASE RADIO-SET-TipDoc:                                                                                                   */
/*             WHEN "FAC" THEN RUN sunat\dgeneracionfactcredito-v2 ( ROWID(FacCPedi),  'M', "CREDITO", "" ).       /* AUTOMATICA */ */
/*             WHEN "FAI" THEN RUN sunat\dgeneracionfactcredito-v2 ( ROWID(FacCPedi), 'FM', "CREDITO", "" ).       /* AUTOMATICA */ */
/*         END CASE.                                                                                                                */
/*     END.                                                                                                                         */

    RUN dispatch IN THIS-PROCEDURE ('open-query').

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
  {src/adm/template/snd-list.i "FacDPedi"}
  {src/adm/template/snd-list.i "gn-ConVt"}
  {src/adm/template/snd-list.i "GN-DIVI"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGetCurr B-table-Win 
FUNCTION fGetCurr RETURNS CHARACTER
  ( INPUT iParaCodMon AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF iParaCodMon = 1 THEN RETURN "S/.".
    ELSE RETURN "US$".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

