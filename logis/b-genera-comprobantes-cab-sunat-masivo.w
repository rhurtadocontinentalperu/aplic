&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE TEMP-TABLE tFacCPedi LIKE FacCPedi
       field trowid as rowid.



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

/* Forzado NO 11D */

&GLOBAL-DEFINE CONDICION ( ~
    FacCPedi.CodCia = s-CodCia AND ~
    FacCPedi.CodDoc = s-CodDoc AND ~
    FacCPedi.DivDes = s-CodDiv AND ~
    FacCPedi.CodAlm <> '11D' AND ~
    FacCPedi.FlgEst = "P" AND ~
    FacCPedi.FlgSit = "C" AND ~
    (RADIO-SET-TipDoc = "FAC" OR FacCPedi.Cmpbnte = "FAC")~
    )
/* &GLOBAL-DEFINE CONDICION ( ~                                */
/*     FacCPedi.CodCia = s-CodCia AND ~                        */
/*     FacCPedi.CodDoc = s-CodDoc AND ~                        */
/*     FacCPedi.DivDes = s-CodDiv AND ~                        */
/*     FacCPedi.FlgEst = "P" AND ~                             */
/*     FacCPedi.FlgSit = "C" AND ~                             */
/*     (RADIO-SET-TipDoc = "FAC" OR FacCPedi.Cmpbnte = "FAC")~ */
/*     )                                                       */

DEF VAR x-Reprogramado AS LOGICAL FORMAT "SI/NO" NO-UNDO.

DEFINE VAR lIsDisplay AS LOG INIT YES.
DEFINE VAR iradio-set-cuales AS INT INIT 1.

DEFINE VAR iTopeMaximoRegSeleccionados AS INT INIT 0.
DEFINE VAR iRegSeleccionados AS INT INIT 0.
DEFINE VAR cCodDocSeleccionados AS CHAR.

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
&Scoped-define FIELDS-IN-QUERY-br_table fReprogramado() @ x-Reprogramado ~
FacCPedi.CrossDocking FacCPedi.CodDoc FacCPedi.NroPed FacCPedi.NomCli ~
FacCPedi.FchPed fGetCurr(FacCPedi.CodMon) @ cCurrency ~
STRING(FacCPedi.Libre_c02, 'x(3)') + ' ' + STRING(FacCPedi.Libre_c03, 'x(10)') @ x-NroRef ~
FacCPedi.Cmpbnte FacCPedi.Cliente_Recoge FacCPedi.TipVta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo ~
      AND ((RADIO-SET-TipDoc = "FAI" AND gn-ConVt.Libre_l01 = TRUE) OR ~
(RADIO-SET-TipDoc = "FAC" AND gn-ConVt.Libre_l01 = FALSE)) NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi ~
      WHERE (RADIO-SET-TipDoc = "FAC" OR GN-DIVI.flgrep = TRUE) NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo ~
      AND ((RADIO-SET-TipDoc = "FAI" AND gn-ConVt.Libre_l01 = TRUE) OR ~
(RADIO-SET-TipDoc = "FAC" AND gn-ConVt.Libre_l01 = FALSE)) NO-LOCK, ~
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
&Scoped-Define ENABLED-OBJECTS RADIO-SET-cuales RADIO-SET-TipDoc br_table 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-cuales RADIO-SET-TipDoc ~
FILL-IN_Info FILL-IN-msg1 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fReprogramado B-table-Win 
FUNCTION fReprogramado RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 32.57 BY .62
     FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-msg1 AS CHARACTER FORMAT "X(100)":U INITIAL "DOBLECLICK selecciona registro" 
      VIEW-AS TEXT 
     SIZE 27.57 BY .62
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_Info AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75.43 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cuales AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Seleccionados", 2,
"NO seleccionados", 3
     SIZE 37.86 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-TipDoc AS CHARACTER INITIAL "FAC" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Facturas Normales", "FAC",
"Facturas Internas", "FAI"
     SIZE 34.57 BY .77
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

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
      fReprogramado() @ x-Reprogramado COLUMN-LABEL "Rep."
      FacCPedi.CrossDocking FORMAT "SI/NO":U WIDTH 10.14
      FacCPedi.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U WIDTH 4
      FacCPedi.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U WIDTH 9.57
            COLUMN-FONT 0
      FacCPedi.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "x(100)":U
            WIDTH 39.72
      FacCPedi.FchPed COLUMN-LABEL "Fecha deEmisión" FORMAT "99/99/9999":U
      fGetCurr(FacCPedi.CodMon) @ cCurrency COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      STRING(FacCPedi.Libre_c02, 'x(3)') + ' ' + STRING(FacCPedi.Libre_c03, 'x(10)') @ x-NroRef COLUMN-LABEL "Referencia"
            WIDTH 17
      FacCPedi.Cmpbnte COLUMN-LABEL "Cmpte a!Generar" FORMAT "X(3)":U
            WIDTH 8.14
      FacCPedi.Cliente_Recoge COLUMN-LABEL "Cliente!Recoge" FORMAT "yes/no":U
            WIDTH 7.43
      FacCPedi.TipVta COLUMN-LABEL "Tramite!Docmn" FORMAT "X(2)":U
            WIDTH 6.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 134.57 BY 10
         FONT 4
         TITLE "ORDENES DE DESPACHO PARA FACTURAR" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-cuales AT ROW 1.04 COL 74.43 NO-LABEL WIDGET-ID 8
     RADIO-SET-TipDoc AT ROW 1.15 COL 2.43 NO-LABEL WIDGET-ID 2
     br_table AT ROW 2 COL 1.43
     FILL-IN_Info AT ROW 12.12 COL 2.57 NO-LABEL WIDGET-ID 6
     FILL-IN-msg1 AT ROW 1.19 COL 36.57 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-msg AT ROW 12.23 COL 77.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     "Mostrar :" VIEW-AS TEXT
          SIZE 5.86 BY .5 AT ROW 1.27 COL 68.14 WIDGET-ID 12
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
      TABLE: tFacCPedi T "?" ? INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          field trowid as rowid
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
         HEIGHT             = 12.12
         WIDTH              = 136.14.
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

/* SETTINGS FOR FILL-IN FILL-IN-msg IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-msg1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Info IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.FacDPedi OF INTEGRAL.FacCPedi,INTEGRAL.gn-ConVt WHERE INTEGRAL.FacCPedi ...,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST, FIRST, FIRST, FIRST OUTER"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.NroPed|no"
     _Where[1]         = "{&CONDICION}"
     _JoinCode[3]      = "gn-ConVt.Codig = FacCPedi.FmaPgo"
     _Where[3]         = "((RADIO-SET-TipDoc = ""FAI"" AND gn-ConVt.Libre_l01 = TRUE) OR
(RADIO-SET-TipDoc = ""FAC"" AND gn-ConVt.Libre_l01 = FALSE))"
     _Where[4]         = "(RADIO-SET-TipDoc = ""FAC"" OR GN-DIVI.flgrep = TRUE)"
     _FldNameList[1]   > "_<CALC>"
"fReprogramado() @ x-Reprogramado" "Rep." ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.CrossDocking
"FacCPedi.CrossDocking" ? "SI/NO" "logical" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.CodDoc
"FacCPedi.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Número" ? "character" ? ? 0 ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre del Cliente" ? "character" ? ? ? ? ? ? no ? no no "39.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha deEmisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fGetCurr(FacCPedi.CodMon) @ cCurrency" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"STRING(FacCPedi.Libre_c02, 'x(3)') + ' ' + STRING(FacCPedi.Libre_c03, 'x(10)') @ x-NroRef" "Referencia" ? ? ? ? ? ? ? ? no ? no no "17" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.Cmpbnte
"FacCPedi.Cmpbnte" "Cmpte a!Generar" ? "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCPedi.Cliente_Recoge
"FacCPedi.Cliente_Recoge" "Cliente!Recoge" ? "logical" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCPedi.TipVta
"FacCPedi.TipVta" "Tramite!Docmn" "X(2)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    /*
    RUN proc_GeneraGuia.
    RETURN NO-APPLY.
    */
    IF AVAILABLE faccpedi THEN DO:
        FIND FIRST tfaccpedi WHERE tfaccpedi.trowid = ROWID(faccpedi) EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE tfaccpedi THEN DO:

            IF iRegSeleccionados < iTopeMaximoRegSeleccionados THEN DO:
                CREATE tfaccpedi.
                BUFFER-COPY faccpedi TO tfaccpedi.  
                ASSIGN tfaccpedi.trowid = ROWID(faccpedi)
                        tFaccpedi.usrdscto = "".
                iRegSeleccionados = iRegSeleccionados + 1.

            END.
            ELSE DO:
                MESSAGE "Supero el tope maximo de registros a seleccionar" VIEW-AS ALERT-BOX INFORMATION.
            END.
        END.
        ELSE DO:
            DELETE tfaccpedi.
            iRegSeleccionados = iRegSeleccionados - 1.
        END.
    END.
    br_table:REFRESH() IN FRAME {&FRAME-NAME}.

    IF iRegSeleccionados < 0 THEN iRegSeleccionados = 0.

    RUN showmsg.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-DISPLAY OF br_table IN FRAME F-Main /* ORDENES DE DESPACHO PARA FACTURAR */
DO:
  /* RHC 17/10/2022: Avisar si viene de una anulación de comprobante */
  IF AVAILABLE Faccpedi THEN DO:
      FIND LAST Ccbcdocu WHERE CcbCDocu.CodCia = Faccpedi.codcia AND
          CcbCDocu.CodPed = Faccpedi.codref AND
          CcbCDocu.NroPed = Faccpedi.nroref AND
          CcbCDocu.CodCli = Faccpedi.codcli AND
          CcbCDocu.FlgEst = "A" AND
          LOOKUP(CcbCDocu.CodDoc, 'FAC,BOL') > 0
          NO-LOCK NO-ERROR.
      IF AVAILABLE Ccbcdocu THEN DO:
          FacCPedi.CodDoc:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          FacCPedi.CodDoc:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
          FacCPedi.FchPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          FacCPedi.FchPed:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
          FacCPedi.NomCli:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          FacCPedi.NomCli:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
          FacCPedi.NroPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
          FacCPedi.NroPed:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
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


&Scoped-define SELF-NAME RADIO-SET-cuales
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-cuales B-table-Win
ON VALUE-CHANGED OF RADIO-SET-cuales IN FRAME F-Main
DO:
   ASSIGN radio-set-cuales .
    iradio-set-cuales = radio-set-cuales.   

    {&open-query-br_table}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-TipDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-TipDoc B-table-Win
ON VALUE-CHANGED OF RADIO-SET-TipDoc IN FRAME F-Main
DO:
  ASSIGN {&self-name}.

  EMPTY TEMP-TABLE tfaccpedi.

  iRegSeleccionados = 0.

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

  RUN showmsg.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

DEF VAR celda_br AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
 DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
 DEF VAR n_cols_browse AS INT NO-UNDO.
 DEF VAR col_act AS INT NO-UNDO.
 DEF VAR t_col_br AS INT NO-UNDO INITIAL 11.            /* Color del background de la celda ( 2 : Verde, 4:Rojo)*/
 DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 28.        /* Color del la letra de la celda (15 : Blanco) */      


ON FIND OF faccpedi DO:     
    
    IF lIsDisplay = YES THEN DO:
        /*MESSAGE iradio-set-cuales.*/
        FIND FIRST tfaccpedi WHERE tfaccpedi.trowid = ROWID(faccpedi) NO-LOCK NO-ERROR.

        CASE TRUE:
            WHEN iradio-set-cuales = 1 THEN DO:
                /* Mostrar todos los registros */
            END.
            WHEN iradio-set-cuales = 2 THEN DO:
                /* Solo los seleccionados */
                IF NOT AVAILABLE tfaccpedi THEN DO:
                    RETURN ERROR .
                END.
            END.
            WHEN iradio-set-cuales = 3 THEN DO:
                /* Solo los NO seleccionados */
                IF AVAILABLE tfaccpedi THEN DO:
                    RETURN ERROR .
                END.
            END.
        END CASE.
    END.

    /*
    If Condicion Then do:
        return error.
    end.
    */
    RETURN.
END.

ON ROW-DISPLAY OF br_table
DO:
  IF AVAILABLE faccpedi THEN DO:
      FIND FIRST tfaccpedi WHERE tfaccpedi.trowid = ROWID(faccpedi) NO-LOCK NO-ERROR.
      IF AVAILABLE tfaccpedi THEN DO:
          DO col_act = 1 TO n_cols_browse.
              
             cual_celda = celda_br[col_act].
             cual_celda:BGCOLOR = t_col_br.
             /**/
             cual_celda:BGCOLOR = 4.
             cual_celda:FGCOLOR = 15.
          END.
      END.
  END.
END.

DO n_cols_browse = 1 TO br_table:NUM-COLUMNS.
   celda_br[n_cols_browse] = br_table:GET-BROWSE-COLUMN(n_cols_browse).
   cual_celda = celda_br[n_cols_browse].
     
   IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
   /*IF n_cols_browse = 15 THEN LEAVE.*/
END.

n_cols_browse = br_table:NUM-COLUMNS.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

DEFINE VAR cValorDeRetorno AS CHAR.

RUN gn/parametro-config-vtatabla("CONFIG-GRE",
                                "PARAMETRO",
                                "GENERACION_COMPROBANTES",
                                "MAXIMOREGISTROS_SELECCIONADOS",
                                "Generacion de comprobantes, Maximo de registros a seleccionar",
                                "N",
                                "10",
                                OUTPUT cValorDeRetorno).

If cValorDeRetorno = "ERROR" THEN DO:
    iTopeMaximoRegSeleccionados = 0.
    MESSAGE "Hubo problemas al intentar recuperar el tope maximo de registros a selecciionar" SKIP
            "Por favor salir de la venta y volver a ingresar" VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE DO:
    iTopeMaximoRegSeleccionados = INTEGER(cValorDeRetorno).
END.

RUN showmsg.

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

/* GRE */
DEFINE VAR lGRE_ONLINE AS LOG.

    RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).

    IF NOT AVAILABLE FacCPedi OR
        {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
        MESSAGE
            "Seleccione una Orden de Despacho"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF lGRE_ONLINE = YES THEN DO:
        CASE RADIO-SET-TipDoc:
            WHEN "FAC" THEN RUN logis\d-genera-comprobantes-sunat-gre.r ( ROWID(FacCPedi), 'A', "CREDITO", "" ).       /* AUTOMATICA */
            WHEN "FAI" THEN RUN logis\d-genera-comprobantes-sunat-gre.r ( ROWID(FacCPedi), 'FA', "CREDITO", "" ).       /* AUTOMATICA */
            /*WHEN "FAI" THEN RUN logis\d-genera-comprobantes-v2.r ( ROWID(FacCPedi), 'FA', "CREDITO", "" ).       /* AUTOMATICA */*/
        END CASE.
    END.
    ELSE DO:
        CASE RADIO-SET-TipDoc:
            WHEN "FAC" THEN RUN logis\d-genera-comprobantes-sunat.r ( ROWID(FacCPedi), 'A', "CREDITO", "" ).       /* AUTOMATICA */
            WHEN "FAI" THEN RUN logis\d-genera-comprobantes-sunat.r ( ROWID(FacCPedi), 'FA', "CREDITO", "" ).       /* AUTOMATICA */
            /*WHEN "FAI" THEN RUN logis\d-genera-comprobantes-v2.r ( ROWID(FacCPedi), 'FA', "CREDITO", "" ).       /* AUTOMATICA */*/
        END CASE.
    END.

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

    /* GRE */
    DEFINE VAR lGRE_ONLINE AS LOG.

    RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).


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

    /*
    CASE RADIO-SET-TipDoc:
        WHEN "FAC" THEN RUN logis\d-genera-comprobantes-sunat.r ( ROWID(FacCPedi), 'M', "CREDITO", "" ).       /* AUTOMATICA */
        WHEN "FAI" THEN RUN logis\d-genera-comprobantes-sunat.r ( ROWID(FacCPedi), 'FM', "CREDITO", "" ).       /* AUTOMATICA */
        /*WHEN "FAI" THEN RUN logis\d-genera-comprobantes-v2.r ( ROWID(FacCPedi), 'FM', "CREDITO", "" ).       /* AUTOMATICA */*/
    END CASE.
    */
    IF lGRE_ONLINE = YES THEN DO:
        CASE RADIO-SET-TipDoc:
            WHEN "FAC" THEN RUN logis\d-genera-comprobantes-sunat-gre.r ( ROWID(FacCPedi), 'M', "CREDITO", "" ).       /* AUTOMATICA */
            WHEN "FAI" THEN RUN logis\d-genera-comprobantes-sunat-gre.r ( ROWID(FacCPedi), 'FM', "CREDITO", "" ).       /* AUTOMATICA */
            /*WHEN "FAI" THEN RUN logis\d-genera-comprobantes-v2.r ( ROWID(FacCPedi), 'FA', "CREDITO", "" ).       /* AUTOMATICA */*/
        END CASE.
    END.
    ELSE DO:
        CASE RADIO-SET-TipDoc:
            WHEN "FAC" THEN RUN logis\d-genera-comprobantes-sunat.r ( ROWID(FacCPedi), 'M', "CREDITO", "" ).       /* AUTOMATICA */
            WHEN "FAI" THEN RUN logis\d-genera-comprobantes-sunat.r ( ROWID(FacCPedi), 'FM', "CREDITO", "" ).       /* AUTOMATICA */
            /*WHEN "FAI" THEN RUN logis\d-genera-comprobantes-v2.r ( ROWID(FacCPedi), 'FA', "CREDITO", "" ).       /* AUTOMATICA */*/
        END CASE.
    END.

    RUN dispatch IN THIS-PROCEDURE ('open-query').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GenerarComprobanteMasivo B-table-Win 
PROCEDURE proc_GenerarComprobanteMasivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcSerieFAC AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcSerieBOL AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcSerieFAI AS CHAR NO-UNDO.

DEFINE VAR cSerieCmpte AS CHAR.
DEFINE VAR cCmptesGenerados AS CHAR.
DEFINE VAR cCmpteGenerado AS CHAR.
DEFINE VAR cRetval AS CHAR.
DEFINE VAR cFiler AS CHAR.
DEFINE VAR iCmptesGenerados AS INT.

DEFINE VAR cOrdenesErrores AS CHAR.

lIsDisplay = NO.

iRegSeleccionados = 0.
cCodDocSeleccionados = "".
FOR EACH tFaccpedi NO-LOCK:
    IF cCodDocSeleccionados <> "" THEN cCodDocSeleccionados = cCodDocSeleccionados + ",".
    cCodDocSeleccionados = cCodDocSeleccionados + tFacCPedi.Cmpbnte.
    iRegSeleccionados = iRegSeleccionados + 1.
END.

IF iRegSeleccionados < 1 THEN DO:
    lIsDisplay = YES.
    RETURN.
END.  

IF LOOKUP('FAC',cCodDocSeleccionados) > 0 THEN DO:
    IF TRUE <> (pcSerieFAC > "") THEN DO:
        MESSAGE "La serie de la FACTURA no es la correcta" VIEW-AS ALERT-BOX INFORMATION.
        lIsDisplay = YES.
        RETURN.
    END.
END.
IF LOOKUP('BOL',cCodDocSeleccionados) > 0 THEN DO:
    IF TRUE <> (pcSerieBOL > "") THEN DO:
        MESSAGE "La serie de la BOLETA DE VENTA no es la correcta" VIEW-AS ALERT-BOX INFORMATION.
        lIsDisplay = YES.
        RETURN.
    END.
END.
IF LOOKUP('FAI',cCodDocSeleccionados) > 0 THEN DO:
    IF TRUE <> (pcSerieFAI > "") THEN DO:
        MESSAGE "La serie de la FACTURA INTERNA no es la correcta" VIEW-AS ALERT-BOX INFORMATION.
        lIsDisplay = YES.
        RETURN.
    END.
END.

MESSAGE '¿ Seguro de generar comprobante de la(s) ' + STRING(iRegSeleccionados) + ' orden(es) seleccionada(s) ?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN DO:
    lIsDisplay = YES.
    RETURN.
END.    

DEFINE VAR lGRE_ONLINE AS LOG.

RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).

/* Procesamos la generacion de comprobantes */
cCmptesGenerados = "".
cRetval = "".
iCmptesGenerados = 0.

FOR EACH tFaccpedi /*NO-LOCK*/:
    IF lGRE_ONLINE = YES THEN DO:

        IF LOOKUP(CAPS(tFacCPedi.Cmpbnte),'FAC,BOL,FAI') > 0  THEN DO:

            cCmpteGenerado = "".
            cFiler = "A".
            
            IF RADIO-SET-TipDoc = 'FAC' THEN DO:
                IF tFacCPedi.Cmpbnte = 'FAC' THEN cSerieCmpte = pcSerieFAC.
                IF tFacCPedi.Cmpbnte = 'BOL' THEN cSerieCmpte = pcSerieBOL.
            END.
            ELSE DO:
                cSerieCmpte = pcSerieFAI.
                cFiler = 'FA'.
            END.

            RUN sunat/generacion-comprobante-de-venta.r(tFacCPedi.trowid,cFiler,'CREDITO','',cSerieCmpte, OUTPUT cCmpteGenerado, OUTPUT cRetVal).
            /*
            MESSAGE "tFacCPedi.Cmpbnte :" tFacCPedi.Cmpbnte SKIP
                    "cRetVal :" cRetVal SKIP
                    "cCmpteGenerado :" cCmpteGenerado.
            */
            IF RETURN-VALUE = 'OK' THEN DO:
                iCmptesGenerados = iCmptesGenerados + 1.
                cCmptesGenerados = cCmptesGenerados + cCmpteGenerado.
                ASSIGN tFaccpedi.usrdscto = "X".
            END.
            ELSE DO:
                cOrdenesErrores = cOrdenesErrores + tfaccpedi.coddoc + " " + tfaccpedi.nroped + " :" + cRetVal + CHR(10).
            END.
        END.
    END.
    ELSE DO:
        /**/
    END.

END.

IF iCmptesGenerados > 0 THEN DO:
    MESSAGE "Se procesaron " + STRING(iCmptesGenerados) + " orden(es) de un total de " + STRING(iRegSeleccionados) SKIP
            "Los comprobantes generados son los siguientes " SKIP
            cCmptesGenerados VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE DO:
    MESSAGE "No se genero ningun comprobante " SKIP
        "<Enter> para visualizar las inconsistencias!!"
        VIEW-AS ALERT-BOX INFORMATION.
END.

IF iCmptesGenerados < iRegSeleccionados THEN DO:
    MESSAGE cOrdenesErrores VIEW-AS ALERT-BOX INFORMATION.
END.

iRegSeleccionados = 0.
FOR EACH tfaccpedi:
    IF tFaccpedi.usrdscto = "X" THEN DO:
        DELETE tfaccpedi.
    END.
    ELSE DO:
        iRegSeleccionados = iRegSeleccionados + 1.
    END.
END.

IF iRegSeleccionados < 0 THEN iRegSeleccionados = 0.

RUN showmsg.

lIsDisplay = YES.

END PROCEDURE.

/*
DEFINE INPUT PARAMETER rwParaRowID AS ROWID.
DEFINE INPUT PARAMETER pTipoGuia   AS CHAR.
DEFINE INPUT PARAMETER pOrigen AS CHAR.
DEFINE INPUT PARAMETER pCodTer AS CHAR.
DEFINE INPUT PARAMETER pSerie AS CHAR.
DEFINE OUTPUT PARAMETER pNroCmpteGenerado   AS CHAR.
DEFINE OUTPUT PARAMETER pRetval   AS CHAR.

*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showmsg B-table-Win 
PROCEDURE showmsg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    fill-in-msg:SCREEN-VALUE = STRING(iRegSeleccionados) + " de un maximo de " + STRING(iTopeMaximoRegSeleccionados).
END.

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

