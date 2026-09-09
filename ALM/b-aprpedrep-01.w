&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

DEF VAR s-TipMov AS CHAR INIT 'A'.
DEF VAR s-FlgEst AS CHAR INIT 'P'.
DEF VAR s-FlgSit AS CHAR INIT 'P'.
/*
DEF SHARED VAR s-TipMov AS CHAR.
DEF SHARED VAR s-FlgEst AS CHAR.
DEF SHARED VAR s-FlgSit AS CHAR.
*/
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.

DEF SHARED VAR s-user-id AS CHAR.

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
&Scoped-define INTERNAL-TABLES almcrepo Almacen

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table almcrepo.CodAlm Almacen.Descripcion ~
almcrepo.Usuario almcrepo.FchDoc almcrepo.Hora almcrepo.Fecha ~
almcrepo.FchVto almcrepo.NroSer almcrepo.NroDoc almcrepo.Glosa ~
almcrepo.FchApr almcrepo.HorApr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH almcrepo WHERE ~{&KEY-PHRASE} ~
      AND almcrepo.CodCia = s-codcia ~
 AND almcrepo.AlmPed = s-codalm ~
 /*AND almcrepo.TipMov = s-tipmov*/ ~
 AND almcrepo.FlgEst = s-flgest ~
 AND almcrepo.FlgSit = s-flgsit ~
 AND (COMBO-BOX-CodAlm = 'Todos' OR almcrepo.CodAlm = COMBO-BOX-CodAlm) NO-LOCK, ~
      FIRST Almacen OF almcrepo NO-LOCK ~
    BY almcrepo.FchDoc DESCENDING ~
       BY almcrepo.CodAlm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH almcrepo WHERE ~{&KEY-PHRASE} ~
      AND almcrepo.CodCia = s-codcia ~
 AND almcrepo.AlmPed = s-codalm ~
 /*AND almcrepo.TipMov = s-tipmov*/ ~
 AND almcrepo.FlgEst = s-flgest ~
 AND almcrepo.FlgSit = s-flgsit ~
 AND (COMBO-BOX-CodAlm = 'Todos' OR almcrepo.CodAlm = COMBO-BOX-CodAlm) NO-LOCK, ~
      FIRST Almacen OF almcrepo NO-LOCK ~
    BY almcrepo.FchDoc DESCENDING ~
       BY almcrepo.CodAlm.
&Scoped-define TABLES-IN-QUERY-br_table almcrepo Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-br_table almcrepo
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almacen


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-FlgEst x-FlgSit COMBO-BOX-CodAlm br_table 
&Scoped-Define DISPLAYED-OBJECTS x-FlgEst x-FlgSit COMBO-BOX-CodAlm 

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
DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE x-FlgEst AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Emitido", "P",
"Atendido", "C",
"Anulado", "A",
"Cerrado", "M"
     SIZE 47 BY .77 NO-UNDO.

DEFINE VARIABLE x-FlgSit AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por aprobar", "P",
"Aprobado", "A",
"Rechazado", "R"
     SIZE 32 BY .96 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      almcrepo, 
      Almacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      almcrepo.CodAlm FORMAT "x(3)":U
      Almacen.Descripcion COLUMN-LABEL "Solicitante" FORMAT "X(40)":U
      almcrepo.Usuario COLUMN-LABEL "Usuario" FORMAT "x(8)":U WIDTH 9.57
      almcrepo.FchDoc COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      almcrepo.Hora FORMAT "x(5)":U WIDTH 3.86
      almcrepo.Fecha COLUMN-LABEL "Entrega" FORMAT "99/99/99":U
      almcrepo.FchVto FORMAT "99/99/9999":U
      almcrepo.NroSer FORMAT "999":U
      almcrepo.NroDoc FORMAT "999999":U
      almcrepo.Glosa FORMAT "x(60)":U
      almcrepo.FchApr COLUMN-LABEL "Fecha!Aprob." FORMAT "99/99/99":U
      almcrepo.HorApr COLUMN-LABEL "Hor!Aprob." FORMAT "x(5)":U
            WIDTH 5.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 137 BY 6.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-FlgEst AT ROW 1.19 COL 7 NO-LABEL WIDGET-ID 10
     x-FlgSit AT ROW 1.96 COL 7 NO-LABEL WIDGET-ID 6
     COMBO-BOX-CodAlm AT ROW 1.96 COL 64 COLON-ALIGNED WIDGET-ID 16
     br_table AT ROW 2.92 COL 2
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
         HEIGHT             = 9.88
         WIDTH              = 144.14.
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
/* BROWSE-TAB br_table COMBO-BOX-CodAlm F-Main */
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
     _TblList          = "INTEGRAL.almcrepo,INTEGRAL.Almacen OF INTEGRAL.almcrepo"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "INTEGRAL.almcrepo.FchDoc|no,INTEGRAL.almcrepo.CodAlm|yes"
     _Where[1]         = "almcrepo.CodCia = s-codcia
 AND almcrepo.AlmPed = s-codalm
 /*AND almcrepo.TipMov = s-tipmov*/
 AND almcrepo.FlgEst = s-flgest
 AND almcrepo.FlgSit = s-flgsit
 AND (COMBO-BOX-CodAlm = 'Todos' OR almcrepo.CodAlm = COMBO-BOX-CodAlm)"
     _FldNameList[1]   = INTEGRAL.almcrepo.CodAlm
     _FldNameList[2]   > INTEGRAL.Almacen.Descripcion
"Almacen.Descripcion" "Solicitante" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.almcrepo.Usuario
"almcrepo.Usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.almcrepo.FchDoc
"almcrepo.FchDoc" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.almcrepo.Hora
"almcrepo.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "3.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.almcrepo.Fecha
"almcrepo.Fecha" "Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.almcrepo.FchVto
     _FldNameList[8]   = INTEGRAL.almcrepo.NroSer
     _FldNameList[9]   = INTEGRAL.almcrepo.NroDoc
     _FldNameList[10]   = INTEGRAL.almcrepo.Glosa
     _FldNameList[11]   > INTEGRAL.almcrepo.FchApr
"almcrepo.FchApr" "Fecha!Aprob." ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.almcrepo.HorApr
"almcrepo.HorApr" "Hor!Aprob." ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME F-Main /* Filtrar por Almacén */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FlgEst B-table-Win
ON VALUE-CHANGED OF x-FlgEst IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  s-FlgEst = INPUT {&SELF-NAME}.
  RUN adm-open-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FlgSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FlgSit B-table-Win
ON VALUE-CHANGED OF x-FlgSit IN FRAME F-Main
DO:
    ASSIGN {&self-name}.
    s-FlgSit = INPUT {&SELF-NAME}.
    RUN adm-open-query.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar B-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE almcrepo THEN RETURN.
IF NOT (almcrepo.flgest = 'P' AND almcrepo.flgsit = 'P') THEN DO:
    MESSAGE 'Este pedido NO se encuentra pendiente de aprobación' VIEW-AS ALERT-BOX WARNING.
    RUN dispatch IN THIS-PROCEDURE ('open-query').
    RETURN.
END.
FIND CURRENT almcrepo EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE almcrepo THEN RETURN.
/* RHC 06/06/2014 Generacion del STR (Solicitud de Transferencia) */
/* RUN alm/genera-str (ROWID(Almcrepo)).       */
/* IF RETURN-VALUE = 'ADM-ERROR' THEN DO:      */
/*     FIND CURRENT almcrepo NO-LOCK NO-ERROR. */
/*     RETURN.                                 */
/* END.                                        */
ASSIGN
    almcrepo.FchApr = TODAY
    almcrepo.FlgSit = 'A'
    almcrepo.HorApr = STRING(TIME, 'HH:MM')
    almcrepo.UsrApr = s-user-id.
FIND CURRENT almcrepo NO-LOCK NO-ERROR.
RUN dispatch IN THIS-PROCEDURE ('open-query').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-Manual B-table-Win 
PROCEDURE Cierre-Manual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE almcrepo THEN RETURN.
IF NOT (almcrepo.flgest = 'P' AND almcrepo.flgsit = 'A') THEN DO:
    MESSAGE 'Este pedido NO se encuentra aprobado' VIEW-AS ALERT-BOX WARNING.
    RUN dispatch IN THIS-PROCEDURE ('open-query').
    RETURN.
END.
/* RHC 27.08.2014 NO debe haber STR en tránsito */
FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = 'STR'
    AND Faccpedi.flgest = 'P'
    AND FacCPedi.CodCli = Almcrepo.CodAlm
    AND FacCPedi.CodRef = "R/A"
    AND FacCPedi.NroRef = STRING(almcrepo.NroSer, '999') + STRING(almcrepo.NroDoc)
    NO-LOCK NO-ERROR.
IF AVAILABLE Faccpedi THEN DO:
    MESSAGE 'NO se puede hacer el cierre' SKIP
        'Aún no se ha hecho la G/R por Transferencia' SKIP
        'Rerferencia:' Faccpedi.coddoc Faccpedi.nroped
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
DEF BUFFER B-OTR FOR Faccpedi.
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = 'STR'
    AND FacCPedi.CodCli = Almcrepo.CodAlm
    AND FacCPedi.CodRef = "R/A"
    AND FacCPedi.NroRef = STRING(almcrepo.NroSer, '999') + STRING(almcrepo.NroDoc),
    EACH B-OTR NO-LOCK WHERE B-OTR.codcia = s-codcia
    AND B-OTR.coddoc = 'OTR'
    AND B-OTR.codref = Faccpedi.coddoc
    AND B-OTR.nroref = Faccpedi.nroped:
    IF B-OTR.flgest = "P" THEN DO:
        MESSAGE 'NO se puede hacer el cierre' SKIP
            'Aún no se ha hecho la G/R por Transferencia' SKIP
            'Referencia:' B-OTR.coddoc B-OTR.nroped
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.

FIND CURRENT almcrepo EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE almcrepo THEN RETURN.
ASSIGN
    almcrepo.FchApr = TODAY
    /*almcrepo.FlgSit = 'M'*/       /* ¿? */
    almcrepo.FlgEst = 'M'
    almcrepo.HorApr = STRING(TIME, 'HH:MM')
    almcrepo.UsrApr = s-user-id.
FIND CURRENT almcrepo NO-LOCK NO-ERROR.
RUN dispatch IN THIS-PROCEDURE ('open-query').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.
    
    IF almcrepo.FlgEst = 'A' THEN DO:
        MESSAGE 'Documento Anulado'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'adm-error'.
    END.
        

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ALM\RBALM.PRL"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "almcrepo.CodCia = " + STRING(s-codcia) +
                    " AND almcrepo.AlmPed = '" + STRING(s-codalm) + "'" +
                    " AND almcrepo.TipMov = '" + STRING(s-tipmov) + "'" + 
                    " AND almcrepo.FlgEst = '" + STRING(x-flgest) + "'" +
                    " AND almcrepo.FlgSit = '" + STRING(x-flgsit) + "'".
/*
    MESSAGE 'RB-Filter: ' SKIP rb-filter
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
        
/*                                                                                  */
/*                                                                                  */
/*         "Almcrepo.CodCia = " + STRING(s-codcia) +                                */
/*                     " AND Almcrepo.CodAlm = '" + STRING(almcrepo.CodAlm) + "'" + */
/*                     " AND Almcrepo.TipMov = '" + STRING(almcrepo.TipMov) + "'" + */
/*                     " AND Almcrepo.NroSer = " + string(almcrepo.NroSer) +        */
/*                     " AND Almcrepo.NroDoc = " + string(almcrepo.NroDoc) .        */

    RB-OTHER-PARAMETERS = "".  
    RB-REPORT-NAME = "Consulta de Pedido".
    
    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      x-FlgEst = s-FlgEst
      x-FlgSit = s-FlgSit.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-CodAlm:DELIMITER = '|'.
      FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia
          AND Almacen.Campo-C[9] <> "I" 
          AND Almacen.Campo-C[6] = "SI" 
          AND almacen.codalm <> s-codalm:
          COMBO-BOX-CodAlm:ADD-LAST( Almacen.CodAlm + ' - ' + Almacen.Descripcion, Almacen.CodAlm ).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar B-table-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE almcrepo THEN RETURN.
IF NOT (almcrepo.flgest = 'P' AND almcrepo.flgsit = 'P') THEN DO:
    MESSAGE 'Este pedido NO se encuentra pendiente de aprobacion' VIEW-AS ALERT-BOX WARNING.
    RUN adm-open-query.
    RETURN.
END.
FIND CURRENT almcrepo EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE almcrepo THEN RETURN.
ASSIGN
    almcrepo.FchApr = TODAY
    almcrepo.FlgSit = 'R'
    almcrepo.HorApr = STRING(TIME, 'HH:MM')
    almcrepo.UsrApr = s-user-id.
FIND CURRENT almcrepo NO-LOCK NO-ERROR.
RUN adm-open-query.

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
  {src/adm/template/snd-list.i "almcrepo"}
  {src/adm/template/snd-list.i "Almacen"}

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

