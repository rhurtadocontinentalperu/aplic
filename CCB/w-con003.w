&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME W-Win
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
DEF SHARED VAR s-codcia AS INT.


DEFINE NEW SHARED TEMP-TABLE DOCU LIKE CcbCDocu.
DEFINE NEW SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR. 
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE NEW SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE NEW SHARED VAR lh_handle AS HANDLE.
DEFINE NEW SHARED VAR s-nroser AS INT.
DEF NEW SHARED VAR s-coddoc AS CHAR.
DEF NEW SHARED VAR s-nrodoc AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 COMBO-BOX-CodDoc FILL-IN-NroDoc ~
BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDoc FILL-IN-NroDoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-aderec AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-con003 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-consu3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-consu4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-dcaja01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-dcaja02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcanjexletra-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcanjexletra-02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-canjes AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-comprobante AS HANDLE NO-UNDO.
DEFINE VARIABLE h_qccaja01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-comprobante AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vcanjexletra AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "ACTUALIZAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     LIST-ITEM-PAIRS "Factura","FAC",
                     "Boleta","BOL",
                     "Letra","LET",
                     "Nota de Crédito","N/C",
                     "Nota de Débito","N/D",
                     "Boleta de Depósito","BD",
                     "Anticipo","A/R",
                     "Anticipo de Campaña","A/C",
                     "Ticket","TCK"
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(15)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "adeicon/blank":U
     SIZE 9.14 BY 2.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodDoc AT ROW 1.38 COL 11 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NroDoc AT ROW 1.38 COL 41 COLON-ALIGNED WIDGET-ID 4
     BUTTON-3 AT ROW 1.38 COL 59 WIDGET-ID 6
     IMAGE-1 AT ROW 10.42 COL 60 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 163.43 BY 26.77
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA GENERAL DEL COMPROBANTE"
         HEIGHT             = 26.77
         WIDTH              = 163.43
         MAX-HEIGHT         = 27.38
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 27.38
         VIRTUAL-WIDTH      = 182.86
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
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA GENERAL DEL COMPROBANTE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA GENERAL DEL COMPROBANTE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ACTUALIZAR */
DO:
  ASSIGN
      COMBO-BOX-CodDoc FILL-IN-NroDoc.
  FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.coddoc = COMBO-BOX-CodDoc
      AND Ccbcdocu.nrodoc = FILL-IN-NroDoc
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu THEN RETURN NO-APPLY.
  RUN Carga-Parametros IN h_q-comprobante
    ( INPUT Ccbcdocu.CodCia /* INTEGER */,
      INPUT Ccbcdocu.CodDiv /* CHARACTER */,
      INPUT Ccbcdocu.CodDoc /* CHARACTER */,
      INPUT Ccbcdocu.NroDoc /* CHARACTER */).
  
  RUN dispatch IN h_qccaja01 ('open-query':U).
  /* Buscamos el Canje por Letra Relacionado */
  CASE COMBO-BOX-CodDoc:
      WHEN "LET" THEN DO:
          RUN Carga-Parametros IN h_q-canjes
              ( INPUT Ccbcdocu.CodCia /* INTEGER */,
                INPUT Ccbcdocu.CodDiv /* CHARACTER */,
                INPUT Ccbcdocu.CodRef /* CHARACTER */,
                INPUT Ccbcdocu.NroRef /* CHARACTER */).
      END.
      WHEN "A/R" THEN DO:
          FIND Ccbcmvto WHERE Ccbcmvto.codcia = s-codcia
              AND Ccbcmvto.coddiv = Ccbcdocu.coddiv
              AND Ccbcmvto.coddoc = Ccbcdocu.codref
              AND Ccbcmvto.nrodoc = Ccbcdocu.nroref
              NO-LOCK NO-ERROR.
          IF AVAILABLE Ccbcmvto THEN 
                  RUN Carga-Parametros IN h_q-canjes
                      ( INPUT Ccbcmvto.CodCia /* INTEGER */,
                        INPUT Ccbcmvto.CodDiv /* CHARACTER */,
                        INPUT Ccbcmvto.CodDoc /* CHARACTER */,
                        INPUT Ccbcmvto.NroDoc /* CHARACTER */).
      END.
      OTHERWISE DO:
          /* buscamos si hay letra de por medio */
          RUN Carga-Parametros IN h_q-canjes
              ( INPUT s-CodCia /* INTEGER */,
                INPUT '' /* CHARACTER */,
                INPUT '' /* CHARACTER */,
                INPUT '' /* CHARACTER */).
          FOR EACH ccbcmvto NO-LOCK WHERE ccbcmvto.codcia = s-codcia
              AND ccbcmvto.coddoc = 'CJE'
              AND ccbcmvto.codcli = ccbcdocu.codcli
              AND ccbcmvto.flgest <> 'A'
              AND ccbcmvto.fchdoc >= ccbcdocu.fchdoc:
              FIND FIRST ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia
                  AND ccbdmvto.coddiv = ccbcmvto.coddiv
                  AND ccbdmvto.coddoc = ccbcmvto.coddoc
                  AND ccbdmvto.nrodoc = ccbcmvto.nrodoc
                  AND ccbdmvto.tporef = "O"
                  AND ccbdmvto.codref = ccbcdocu.coddoc
                  AND ccbdmvto.nroref = ccbcdocu.nrodoc
                  NO-LOCK NO-ERROR.
              IF AVAILABLE ccbdmvto THEN DO:
                  RUN Carga-Parametros IN h_q-canjes
                      ( INPUT Ccbcmvto.CodCia /* INTEGER */,
                        INPUT Ccbcmvto.CodDiv /* CHARACTER */,
                        INPUT Ccbcmvto.CodDoc /* CHARACTER */,
                        INPUT Ccbcmvto.NroDoc /* CHARACTER */).
                  LEAVE.
              END.
          END.
      END.
  END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

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
             INPUT  'aplic/gn/v-comprobante.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-comprobante ).
       RUN set-position IN h_v-comprobante ( 2.92 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.08 , 160.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Mov de Caja|Mov de Canjes':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 7.73 , 2.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 20.00 , 160.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/q-comprobante.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-comprobante ).
       RUN set-position IN h_q-comprobante ( 1.00 , 103.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/qccaja01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_qccaja01 ).
       RUN set-position IN h_qccaja01 ( 1.00 , 112.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/q-canjes.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-canjes ).
       RUN set-position IN h_q-canjes ( 1.00 , 121.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_v-comprobante. */
       RUN add-link IN adm-broker-hdl ( h_q-comprobante , 'Record':U , h_v-comprobante ).

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_qccaja01. */
       RUN add-link IN adm-broker-hdl ( h_b-consu3 , 'Record':U , h_qccaja01 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-comprobante ,
             BUTTON-3:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             h_v-comprobante , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-consu3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consu3 ).
       RUN set-position IN h_b-consu3 ( 8.88 , 5.00 ) NO-ERROR.
       RUN set-size IN h_b-consu3 ( 6.73 , 53.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/b-dcaja01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-dcaja01 ).
       RUN set-position IN h_b-dcaja01 ( 8.88 , 60.00 ) NO-ERROR.
       RUN set-size IN h_b-dcaja01 ( 8.54 , 41.29 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-consu4.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consu4 ).
       RUN set-position IN h_b-consu4 ( 18.88 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-consu4 ( 6.73 , 53.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/b-dcaja02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-dcaja02 ).
       RUN set-position IN h_b-dcaja02 ( 18.88 , 60.00 ) NO-ERROR.
       RUN set-size IN h_b-dcaja02 ( 8.54 , 41.29 ) NO-ERROR.

       /* Links to SmartBrowser h_b-consu3. */
       RUN add-link IN adm-broker-hdl ( h_q-comprobante , 'Record':U , h_b-consu3 ).

       /* Links to SmartBrowser h_b-dcaja01. */
       RUN add-link IN adm-broker-hdl ( h_qccaja01 , 'Record':U , h_b-dcaja01 ).

       /* Links to SmartBrowser h_b-consu4. */
       RUN add-link IN adm-broker-hdl ( h_q-comprobante , 'Record':U , h_b-consu4 ).

       /* Links to SmartBrowser h_b-dcaja02. */
       RUN add-link IN adm-broker-hdl ( h_b-consu4 , 'Record':U , h_b-dcaja02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consu3 ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-dcaja01 ,
             h_b-consu3 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consu4 ,
             h_b-dcaja01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-dcaja02 ,
             h_b-consu4 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/vcanjexletra.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vcanjexletra ).
       RUN set-position IN h_vcanjexletra ( 8.88 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.31 , 102.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/bcanjexletra-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjexletra-01 ).
       RUN set-position IN h_bcanjexletra-01 ( 12.54 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bcanjexletra-01 ( 6.38 , 85.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-aderec.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-aderec ).
       RUN set-position IN h_b-aderec ( 12.54 , 91.00 ) NO-ERROR.
       RUN set-size IN h_b-aderec ( 4.04 , 59.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-con003.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-con003 ).
       RUN set-position IN h_b-con003 ( 16.77 , 91.00 ) NO-ERROR.
       RUN set-size IN h_b-con003 ( 10.00 , 56.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/bcanjexletra-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjexletra-02 ).
       RUN set-position IN h_bcanjexletra-02 ( 19.27 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bcanjexletra-02 ( 7.92 , 62.00 ) NO-ERROR.

       /* Links to SmartViewer h_vcanjexletra. */
       RUN add-link IN adm-broker-hdl ( h_q-canjes , 'Record':U , h_vcanjexletra ).

       /* Links to SmartBrowser h_bcanjexletra-01. */
       RUN add-link IN adm-broker-hdl ( h_q-canjes , 'Record':U , h_bcanjexletra-01 ).

       /* Links to SmartBrowser h_b-aderec. */
       RUN add-link IN adm-broker-hdl ( h_q-canjes , 'Record':U , h_b-aderec ).

       /* Links to SmartBrowser h_b-con003. */
       RUN add-link IN adm-broker-hdl ( h_b-aderec , 'Record':U , h_b-con003 ).

       /* Links to SmartBrowser h_bcanjexletra-02. */
       RUN add-link IN adm-broker-hdl ( h_q-canjes , 'Record':U , h_bcanjexletra-02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_vcanjexletra ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjexletra-01 ,
             h_vcanjexletra , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-aderec ,
             h_bcanjexletra-01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-con003 ,
             h_b-aderec , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjexletra-02 ,
             h_b-con003 , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  DISPLAY COMBO-BOX-CodDoc FILL-IN-NroDoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE IMAGE-1 COMBO-BOX-CodDoc FILL-IN-NroDoc BUTTON-3 
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

