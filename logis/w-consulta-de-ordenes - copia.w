&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEFINE NEW SHARED VAR ltxtDesde AS DATE.
DEFINE NEW SHARED VAR ltxtHasta AS DATE.
DEFINE NEW SHARED VAR lChequeados AS LOGICAL.
DEFINE NEW SHARED VAR s-CodDoc AS CHAR INIT 'O/D'.

DEFINE SHARED VAR s-codcia AS INT.

DEFINE NEW SHARED VARIABLE lMsgRetorno  AS CHAR.

DEFINE NEW SHARED VAR lh_Handle AS HANDLE.

DEFINE BUFFER i-faccpedi FOR faccpedi.
DEFINE BUFFER i-ccbcdocu FOR ccbcdocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[10] ~
tt-w-report.Campo-D[1] tt-w-report.Campo-D[2] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] tt-w-report.Campo-C[7] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-5 BtnDone 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-5 
       MENU-ITEM m_Revisar_GR   LABEL "Revisar G/R"   
       MENU-ITEM m_Revisar_Factura LABEL "Revisar Factura"
       MENU-ITEM m_Revisar_HR   LABEL "Revisar H/R"   .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-consulta-de-ordenes AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-consulta-pickings AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "T.Doc." FORMAT "X(5)":U
      tt-w-report.Campo-C[2] COLUMN-LABEL "Nro. Docto" FORMAT "X(15)":U
            WIDTH 8.14
      tt-w-report.Campo-C[3] COLUMN-LABEL "H.Ruta" FORMAT "X(15)":U
            WIDTH 8.43
      tt-w-report.Campo-C[10] COLUMN-LABEL "Estado" FORMAT "X(5)":U
            WIDTH 5.43
      tt-w-report.Campo-D[1] COLUMN-LABEL "Salida" FORMAT "99/99/9999":U
      tt-w-report.Campo-D[2] COLUMN-LABEL "Cierre" FORMAT "99/99/9999":U
            WIDTH 10
      tt-w-report.Campo-C[4] COLUMN-LABEL "Comprobante" FORMAT "X(20)":U
      tt-w-report.Campo-C[5] COLUMN-LABEL "FlgEst" FORMAT "X(2)":U
      tt-w-report.Campo-C[6] COLUMN-LABEL "Parte de Ingreso" FORMAT "X(20)":U
      tt-w-report.Campo-C[7] COLUMN-LABEL "N/C" FORMAT "X(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 51 BY 7.54
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-5 AT ROW 6.38 COL 92 WIDGET-ID 200
     BtnDone AT ROW 1.27 COL 136 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 178 BY 26.54 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA DE ORDENES"
         HEIGHT             = 26.54
         WIDTH              = 178
         MAX-HEIGHT         = 27.54
         MAX-WIDTH          = 185.14
         VIRTUAL-HEIGHT     = 27.54
         VIRTUAL-WIDTH      = 185.14
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-5 1 F-Main */
ASSIGN 
       BROWSE-5:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-5:HANDLE
       BROWSE-5:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "T.Doc." "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Nro. Docto" "X(15)" "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "H.Ruta" "X(15)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[10]
"tt-w-report.Campo-C[10]" "Estado" "X(5)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-D[1]
"tt-w-report.Campo-D[1]" "Salida" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-D[2]
"tt-w-report.Campo-D[2]" "Cierre" ? "date" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Comprobante" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "FlgEst" "X(2)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "Parte de Ingreso" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-C[7]
"tt-w-report.Campo-C[7]" "N/C" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA DE ORDENES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DE ORDENES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Revisar_Factura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Revisar_Factura W-Win
ON CHOOSE OF MENU-ITEM m_Revisar_Factura /* Revisar Factura */
DO:
    IF NOT AVAILABLE tt-w-report OR tt-w-report.Campo-C[1] <> "G/R" THEN RETURN.
    RUN logis/d-revisar-fac.r (tt-w-report.Campo-C[1], tt-w-report.Campo-C[2]).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Revisar_GR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Revisar_GR W-Win
ON CHOOSE OF MENU-ITEM m_Revisar_GR /* Revisar G/R */
DO:
  IF NOT AVAILABLE tt-w-report OR tt-w-report.Campo-C[1] <> "G/R" THEN RETURN.
  RUN logis/d-revisar-gr.r (tt-w-report.Campo-C[1], tt-w-report.Campo-C[2]).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Revisar_HR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Revisar_HR W-Win
ON CHOOSE OF MENU-ITEM m_Revisar_HR /* Revisar H/R */
DO:  
  IF NOT AVAILABLE tt-w-report OR (TRUE <> (tt-w-report.Campo-C[3] > "")) THEN RETURN.
  RUN logis/d-revisar-hr.r (tt-w-report.Campo-C[3]).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

lh_Handle = THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-consulta-de-ordenes.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consulta-de-ordenes ).
       RUN set-position IN h_b-consulta-de-ordenes ( 14.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-consulta-de-ordenes ( 12.92 , 176.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/b-consulta-pickings.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = FchPed':U ,
             OUTPUT h_b-consulta-pickings ).
       RUN set-position IN h_b-consulta-pickings ( 1.23 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-consulta-pickings ( 12.69 , 109.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-consulta-de-ordenes. */
       RUN add-link IN adm-broker-hdl ( h_b-consulta-pickings , 'Record':U , h_b-consulta-de-ordenes ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consulta-de-ordenes ,
             BROWSE-5:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consulta-pickings ,
             BtnDone:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE BROWSE-5 BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-w-report"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-guias-hruta W-Win 
PROCEDURE ue-guias-hruta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-RowId AS ROWID    NO-UNDO.

EMPTY TEMP-TABLE tt-w-report.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR dt1 AS DATETIME.
DEFINE VAR dt2 AS DATETIME.

dt1 = NOW.

FIND FIRST i-faccpedi WHERE ROWID(i-faccpedi) = p-RowId NO-LOCK NO-ERROR.

IF AVAILABLE i-faccpedi THEN DO:
    /* Guias de la orden de despacho */ 
    IF i-faccpedi.coddoc = 'O/D' THEN DO:
        CONSULTA0:
        FOR EACH i-ccbcdocu USE-INDEX llave15 WHERE i-ccbcdocu.codcia = s-codcia AND 
                                i-ccbcdocu.codped = i-faccpedi.codref AND 
                                i-ccbcdocu.nroped = i-faccpedi.nroref NO-LOCK :
            IF i-ccbcdocu.coddoc <> 'G/R' THEN NEXT.
            IF i-ccbcdocu.libre_c01 = i-faccpedi.coddoc AND 
                i-ccbcdocu.libre_c02 = i-faccpedi.nroped THEN DO:
                CREATE tt-w-report.
                    ASSIGN 
                        tt-w-report.campo-c[1] = i-ccbcdocu.coddoc
                        tt-w-report.campo-c[2] = i-ccbcdocu.nrodoc
                        tt-w-report.campo-c[10] = i-ccbcdocu.flgest
                        tt-w-report.campo-c[4] = SUBSTRING(i-ccbcdocu.codref,1,1) + '-' + i-ccbcdocu.nroref.
                /* Hoja de Ruta */
                FIND FIRST di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia AND 
                                            di-rutaD.coddoc = 'H/R' AND 
                                            di-rutaD.codref = i-ccbcdocu.coddoc AND 
                                            di-rutaD.nroref = i-ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaD THEN DO:
                    tt-w-report.campo-c[3] = di-rutaD.nrodoc.
                    /*FIND FIRST Di-RutaC OF Di-RutaD NO-LOCK NO-ERROR.*/
                    FIND FIRST Di-RutaC WHERE Di-RutaC.codcia = di-rutaD.codcia AND
                                                di-rutaC.coddiv = di-rutaD.coddiv AND
                                                di-rutaC.coddoc = di-rutaD.coddoc AND
                                                di-rutaC.nrodoc = di-rutaD.nrodoc NO-LOCK NO-ERROR.
                    IF AVAILABLE Di-RutaC THEN
                        ASSIGN
                        tt-w-report.campo-d[1] = DATE(DI-RutaC.FchSal)
                        tt-w-report.campo-d[2] = DATE(DI-RutaC.FchCierre).
                    tt-w-report.campo-c[5] = DI-RutaD.FlgEst.
                END.
                /* Parte de Ingreso y N/C */
                FIND FIRST Almcmov WHERE Almcmov.codcia = s-codcia AND
                    Almcmov.codref = i-ccbcdocu.codref AND
                    Almcmov.nroref = i-ccbcdocu.nroref AND
                    Almcmov.tipmov = 'I' AND
                    Almcmov.codmov = 09 AND
                    Almcmov.flgest <> 'A' NO-LOCK NO-ERROR.
                IF AVAILABLE Almcmov THEN DO:
                    tt-w-report.campo-c[6] = STRING(Almcmov.nroser, '999') + '-' + STRING(Almcmov.nrodoc, '999999999').
                    /* Buscamos N/C */
                    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
                        Ccbcdocu.coddoc = 'N/C' AND
                        Ccbcdocu.codcli = Almcmov.codcli AND
                        Ccbcdocu.codref = Almcmov.codref AND
                        Ccbcdocu.nroref = Almcmov.nroref AND
                        Ccbcdocu.nroped = STRING(Almcmov.nrodoc) AND
                        Ccbcdocu.flgest <> 'A'
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Ccbcdocu THEN tt-w-report.campo-c[7] = Ccbcdocu.nrodoc.
                END.
                /**/
                /*LEAVE CONSULTA0.*/
            END.
        END.
    END.

    /* Guias de Transferencias */
    IF i-faccpedi.coddoc = 'OTR' THEN DO:
        FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = 'OTR' AND 
                                almcmov.nroref = i-faccpedi.nroped 
                                NO-LOCK :
            CREATE tt-w-report.
                ASSIGN 
                    tt-w-report.campo-c[1] = 'G/R'
                    tt-w-report.campo-c[2] = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999")
                    tt-w-report.campo-c[10] = almcmov.flgest.

            FIND FIRST di-rutaG WHERE DI-RutaG.codcia  = almcmov.codcia  AND                 
                                di-rutaG.codalm = almcmov.codalm  AND
                                di-rutaG.tipmov = almcmov.tipmov AND
                                di-rutaG.codmov = almcmov.codmov AND                                
                                di-rutaG.serref = almcmov.nroser AND
                                di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaG THEN DO:
                tt-w-report.campo-c[3] = di-rutaG.nrodoc.
                FIND FIRST Di-RutaC OF Di-RutaD NO-LOCK NO-ERROR.
                IF AVAILABLE Di-RutaC THEN
                    ASSIGN
                    tt-w-report.campo-d[1] = DATE(DI-RutaC.FchSal)
                    tt-w-report.campo-d[2] = DATE(DI-RutaC.FchCierre).
            END.

        END.
    END.

END.

dt2 = NOW.
/*
MESSAGE dt1 SKIP
    dt2.
*/
/**/
/*
almcmov = codcia = 1 and codref = 'OTR' and nroref = '508000063'
*/

RELEASE i-faccpedi.
RELEASE i-ccbcdocu.
{&OPEN-QUERY-BROWSE-5}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

