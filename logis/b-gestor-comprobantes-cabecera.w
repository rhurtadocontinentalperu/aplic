&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE TEMP-TABLE tcontrolOD LIKE ControlOD.
DEFINE TEMP-TABLE tFacCPedi NO-UNDO LIKE FacCPedi.



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

DEFINE SHARED VARIABLE S-TIPMOV   AS CHAR.  /* ELECTRONICA o MANUAL */

DEFINE VARIABLE cCurrency AS CHAR NO-UNDO.
DEFINE VAR x-NroRef AS CHAR FORMAT 'x(20)' NO-UNDO.

/* Forzado NO 11D */

&GLOBAL-DEFINE CONDICION ( ~
    FacCPedi.CodCia = s-CodCia AND ~
    FacCPedi.DivDes = s-CodDiv AND ~
    FacCPedi.CodDoc = s-CodDoc AND ~
    FacCPedi.FlgEst = "P" AND ~
    FacCPedi.CodAlm <> '11D' AND ~
    FacCPedi.FlgSit = "C" AND ~
    (RADIO-SET-TipDoc = "FAC" OR FacCPedi.Cmpbnte = "FAC")~
    )

DEF VAR x-Reprogramado AS LOGICAL FORMAT "SI/NO" NO-UNDO.

DEF VAR cNroPHR AS CHAR NO-UNDO.    /* Filtro por PHR */

define var x-sort-column-current as char.

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
&Scoped-define INTERNAL-TABLES tFacCPedi FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table fReprogramado() @ x-Reprogramado ~
tFacCPedi.CrossDocking tFacCPedi.CodDoc tFacCPedi.NroPed tFacCPedi.NomCli ~
tFacCPedi.FchPed fGetCurr(FacCPedi.CodMon) @ cCurrency ~
fGetODOrigen() @ x-NroRef tFacCPedi.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH tFacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF tFacCPedi NO-LOCK ~
    BY tFacCPedi.FchPed DESCENDING ~
       BY tFacCPedi.NroPed DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tFacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST FacCPedi OF tFacCPedi NO-LOCK ~
    BY tFacCPedi.FchPed DESCENDING ~
       BY tFacCPedi.NroPed DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table tFacCPedi FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tFacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-TipDoc br_table 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-TipDoc FILL-IN_Info 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fGetODOrigen B-table-Win 
FUNCTION fGetODOrigen RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fReprogramado B-table-Win 
FUNCTION fReprogramado RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN_Info AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 81 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-TipDoc AS CHARACTER INITIAL "FAC" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Facturas Normales", "FAC",
"Facturas Internas", "FAI"
     SIZE 33 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tFacCPedi, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      fReprogramado() @ x-Reprogramado COLUMN-LABEL "Rep."
      tFacCPedi.CrossDocking FORMAT "SI/NO":U WIDTH 10.72
      tFacCPedi.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U WIDTH 4.43
      tFacCPedi.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U WIDTH 9.43
      tFacCPedi.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "x(100)":U
            WIDTH 39.43
      tFacCPedi.FchPed COLUMN-LABEL "Fecha deEmisión" FORMAT "99/99/9999":U
            WIDTH 11.43
      fGetCurr(FacCPedi.CodMon) @ cCurrency COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      fGetODOrigen() @ x-NroRef COLUMN-LABEL "Referencia" WIDTH 12
      tFacCPedi.Libre_c01 COLUMN-LABEL "# PHR" FORMAT "x(15)":U
            WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 118.57 BY 7.38
         FONT 4
         TITLE "ORDENES DE DESPACHO PARA FACTURAR" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-TipDoc AT ROW 1 COL 14 NO-LABEL WIDGET-ID 2
     br_table AT ROW 1.96 COL 1.43
     FILL-IN_Info AT ROW 9.35 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 6
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
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
      TABLE: tcontrolOD T "?" ? INTEGRAL ControlOD
      TABLE: tFacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
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
         HEIGHT             = 11.38
         WIDTH              = 134.29.
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

ASSIGN 
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_Info IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tFacCPedi,INTEGRAL.FacCPedi OF Temp-Tables.tFacCPedi"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.tFacCPedi.FchPed|no,Temp-Tables.tFacCPedi.NroPed|no"
     _FldNameList[1]   > "_<CALC>"
"fReprogramado() @ x-Reprogramado" "Rep." ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tFacCPedi.CrossDocking
"tFacCPedi.CrossDocking" ? "SI/NO" "logical" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tFacCPedi.CodDoc
"tFacCPedi.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tFacCPedi.NroPed
"tFacCPedi.NroPed" "Número" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tFacCPedi.NomCli
"tFacCPedi.NomCli" "Nombre del Cliente" ? "character" ? ? ? ? ? ? no ? no no "39.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tFacCPedi.FchPed
"tFacCPedi.FchPed" "Fecha deEmisión" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fGetCurr(FacCPedi.CodMon) @ cCurrency" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fGetODOrigen() @ x-NroRef" "Referencia" ? ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tFacCPedi.Libre_c01
"tFacCPedi.Libre_c01" "# PHR" "x(15)" "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main /* ORDENES DE DESPACHO PARA FACTURAR */
DO:
  /* RHC 17/10/2022: Avisar si viene de una anulación de comprobante */
  IF AVAILABLE tFaccpedi THEN DO:
      FIND LAST Ccbcdocu WHERE CcbCDocu.CodCia = tFaccpedi.codcia AND
          CcbCDocu.CodPed = tFaccpedi.codref AND
          CcbCDocu.NroPed = tFaccpedi.nroref AND
          CcbCDocu.Libre_c01 = tFaccpedi.coddoc AND      /* Cuando una orden se fracciona */
          CcbCDocu.Libre_c02 = tFaccpedi.nroped AND
          CcbCDocu.CodCli = tFaccpedi.codcli AND
          CcbCDocu.FlgEst = "A" AND
          LOOKUP(CcbCDocu.CodDoc, 'FAC,BOL') > 0
          NO-LOCK NO-ERROR.
      IF AVAILABLE Ccbcdocu THEN DO:
          tFaccpedi.CodDoc:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          tFaccpedi.CodDoc:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
          tFaccpedi.FchPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          tFaccpedi.FchPed:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
          tFaccpedi.NomCli:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          tFaccpedi.NomCli:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
          tFaccpedi.NroPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          tFaccpedi.NroPed:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
      END.
  END.
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
ON START-SEARCH OF br_table IN FRAME F-Main /* ORDENES DE DESPACHO PARA FACTURAR */
DO:
    DEFINE VAR x-sql AS CHAR.

    x-sql = "for EACH tFacCPedi NO-LOCK,FIRST FacCPedi OF tFacCPedi NO-LOCK ".

    {gn/sort-browse.i &ThisBrowse="br_table" &ThisSQL = x-SQL}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* ORDENES DE DESPACHO PARA FACTURAR */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
      
    IF AVAILABLE Faccpedi THEN DO:
      FIND LAST Ccbcdocu WHERE CcbCDocu.CodCia = Faccpedi.codcia AND
          CcbCDocu.CodPed = Faccpedi.codref AND
          CcbCDocu.NroPed = Faccpedi.nroref AND
          CcbCDocu.CodCli = Faccpedi.codcli AND
          CcbCDocu.FlgEst = "A" AND
          LOOKUP(CcbCDocu.CodDoc, 'FAC,BOL') > 0
          NO-LOCK NO-ERROR.
      IF AVAILABLE Ccbcdocu THEN DO:
          FILL-IN_Info:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "*** COMPROBANTE ANULADO POR " +
              Ccbcdocu.UsuAnu + " " + STRING(Ccbcdocu.FchAnu) + " ***".
      END.
      ELSE DO:
          FILL-IN_Info:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
      END.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Filtro B-table-Win 
PROCEDURE Captura-Filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pNroPHR AS CHAR.

cNroPHR = pNroPHR.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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

EMPTY TEMP-TABLE tFaccpedi.


FOR EACH Faccpedi NO-LOCK WHERE {&Condicion}:
    FIND FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo AND
        ((RADIO-SET-TipDoc = "FAI" AND gn-ConVt.Libre_l01 = TRUE) OR
         (RADIO-SET-TipDoc = "FAC" AND gn-ConVt.Libre_l01 = FALSE))
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-convt THEN NEXT.
    FIND FIRST GN-DIVI OF FacCPedi WHERE (RADIO-SET-TipDoc = "FAC" OR GN-DIVI.flgrep = TRUE)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN NEXT.

    /* Buscamos PHR */
    IF cNroPHR > '' THEN DO:
        FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = s-codcia AND 
            DI-RutaD.CodDoc = "PHR" AND
            DI-RutaD.CodRef = Faccpedi.coddoc AND
            DI-RutaD.NroRef = Faccpedi.nroped AND
            DI-RutaD.NroDoc = cNroPHR AND
            CAN-FIND(FIRST Di-RutaC OF Di-RutaD WHERE Di-RutaC.flgest <> "A" NO-LOCK)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Di-RutaD THEN NEXT.
    END.
    
    CREATE tFaccpedi.
    BUFFER-COPY Faccpedi TO tFaccpedi.
    tFaccpedi.libre_c01 = "".
    FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = s-codcia AND 
            DI-RutaD.CodDoc = "PHR" AND
            DI-RutaD.CodRef = Faccpedi.coddoc AND
            DI-RutaD.NroRef = Faccpedi.nroped AND
            CAN-FIND(FIRST Di-RutaC OF Di-RutaD WHERE Di-RutaC.flgest <> "A" NO-LOCK)
            NO-LOCK NO-ERROR.
    IF AVAILABLE Di-RutaD THEN tFaccpedi.libre_c01 = Di-RutaD.NroDoc.

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
    /* 26/8/24: NO usar porque se cruza con MIBANCO */
/*     IF Faccpedi.Libre_c02 = "O/D" THEN DO:                   */
/*         MESSAGE 'NO se puede volver a fraccionar esta Orden' */
/*             VIEW-AS ALERT-BOX ERROR.                         */
/*         RETURN.                                              */
/*     END.                                                     */
    /* 26/08/2024: Nuevo control para FRACCIONAMIENTO */
    FIND FIRST LogisLogControl WHERE LogisLogControl.CodCia = s-codcia AND
        LogisLogControl.CodDiv = Faccpedi.coddiv AND
        LogisLogControl.CodDoc = Faccpedi.coddoc AND
        LogisLogControl.NroDoc = Faccpedi.nroped AND
        LogisLogControl.Evento = "OD_FRACCIONADA"
        NO-LOCK NO-ERROR.
    IF AVAILABLE LogisLogControl THEN DO:
        MESSAGE 'NO se puede volver a fraccionar esta Orden'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    /* ********************************************** */

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

    /* 21/04/2026: Migrando rutinas de productivo */
    DEF VAR pNroBultos AS INT NO-UNDO.
    DEF VAR cProcesoLogistico AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tcontrolOD.    /* Los bultos para la nueva orden */

    /* Verificamos si la division es Picking por Sector o Picking por Ruta */

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia 
        AND gn-divi.coddiv = s-CodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN cProcesoLogistico = gn-divi.campo-char[6].
    IF TRUE <> (cProcesoLogistico > "") THEN cProcesoLogistico = "".    /* Si es nullo */

    IF cProcesoLogistico = 'SE' THEN DO:  /* Picking por Sectores */
        RUN vta2/d-distribucion-factura-cred ( ROWID(Faccpedi), OUTPUT pNroBultos, OUTPUT rpta ).
        IF rpta = 'ADM-ERROR' THEN RETURN.
    END.
    ELSE DO:        
        DEFINE VAR cNuevaOrden AS CHAR.
    
        RUN logis/d-distribucion-fraccionamiento-ordenes.r(ROWID(Faccpedi), 
                                                           OUTPUT pNroBultos, 
                                                           OUTPUT rpta,
                                                           OUTPUT TABLE tcontrolOD  ).
        IF rpta = 'ADM-ERROR' THEN RETURN.
    END.

    /* Se procede a fraccionar la Orden de Despacho */
    DEF VAR pMensaje AS CHAR NO-UNDO.

    RUN vta2/pFraccionarOrden ( INPUT ROWID(Faccpedi), 
                                INPUT TABLE PEDI, 
                                INPUT pNroBultos,
                                OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    END.

    IF NUM-ENTRIES(pMensaje,"|") >= 2 THEN cNuevaOrden = ENTRY(2,pMensaje,"|").

    /* Actualizo los bultos con la nueva orden */
    FOR EACH tControlOD NO-LOCK:
        FIND FIRST ControlOD WHERE ControlOD.codcia = tControlOD.codcia AND
                                    controlOD.coddoc = tcontrolOD.coddoc AND
                                    controlOD.nrodoc = tcontrolOD.nrodoc AND
                                    controlOD.nroetq = tcontrolOD.nroetq EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE controlOD THEN DO:
            ASSIGN controlOD.ordCmp = cNuevaOrden.
        END.
    END.

    pMensaje = "".


/* **
    DEF VAR pNroBultos AS INTE NO-UNDO.

    RUN vta2/d-distribucion-factura-cred ( ROWID(Faccpedi), OUTPUT pNroBultos, OUTPUT rpta ).
    IF rpta = 'ADM-ERROR' THEN RETURN.

    /* Se procede a fraccionar la Orden de Despacho */
    DEF VAR pMensaje AS CHAR NO-UNDO.

    RUN vta2/pFraccionarOrden ( INPUT ROWID(Faccpedi), 
                                INPUT TABLE PEDI, 
                                INPUT pNroBultos,
                                OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    END.
** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Faccpedi THEN DO:
    FIND LAST Ccbcdocu WHERE CcbCDocu.CodCia = Faccpedi.codcia AND
        CcbCDocu.CodPed = Faccpedi.codref AND
        CcbCDocu.NroPed = Faccpedi.nroref AND
        CcbCDocu.CodCli = Faccpedi.codcli AND
        CcbCDocu.FlgEst = "A" AND
        LOOKUP(CcbCDocu.CodDoc, 'FAC,BOL') > 0
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        FILL-IN_Info:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "*** COMPROBANTE ANULADO POR " +
            Ccbcdocu.UsuAnu + " " + STRING(Ccbcdocu.FchAnu) + " ***".
    END.
    ELSE DO:
        FILL-IN_Info:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
  END.

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
  RUN Carga-Temporal.

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
    WHEN "FAC" THEN RUN logis\d-gestor-comprobantes.w ( BUFFER Faccpedi, 'A', "CREDITO").       /* AUTOMATICA */
    WHEN "FAI" THEN RUN logis\d-gestor-comprobantes.w ( BUFFER Faccpedi, 'FA', "CREDITO").       /* AUTOMATICA */
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
  {src/adm/template/snd-list.i "tFacCPedi"}
  {src/adm/template/snd-list.i "FacCPedi"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fGetODOrigen B-table-Win 
FUNCTION fGetODOrigen RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR x-Origen AS CHAR NO-UNDO.
  FIND FIRST LogisLogControl WHERE LogisLogControl.CodCia = s-codcia AND
      LogisLogControl.CodDiv = Faccpedi.coddiv AND
      LogisLogControl.CodDoc = Faccpedi.coddoc AND
      LogisLogControl.NroDoc = Faccpedi.nroped AND
      LogisLogControl.Evento = "OD_FRACCIONADA"
      NO-LOCK NO-ERROR.
  IF AVAILABLE LogisLogControl THEN x-Origen = LogisLogControl.Libre_c01 + " " + LogisLogControl.Libre_c02.
  ELSE DO:
      IF FacCPedi.Libre_c02 = 'O/D' THEN x-Origen = STRING(FacCPedi.Libre_c02, 'x(3)') + ' ' + STRING(FacCPedi.Libre_c03, 'x(10)').
  END.
  RETURN x-Origen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fReprogramado B-table-Win 
FUNCTION fReprogramado RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF CAN-FIND(LAST AlmCDocu WHERE AlmCDocu.CodCia = s-codcia AND
              AlmCDocu.CodLlave = s-CodDiv AND 
              AlmCDocu.CodDoc = Faccpedi.CodDoc AND
              AlmCDocu.NroDoc = Faccpedi.NroPed AND 
              AlmCDocu.FlgEst = "C" NO-LOCK)
        THEN RETURN YES.
  ELSE RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

