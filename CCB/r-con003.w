&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER FACTURA FOR CcbCDocu.



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
DEF SHARED VAR s-nomcia AS CHAR.

DEF NEW SHARED VAR s-coddiv AS CHAR.
DEF NEW SHARED VAR s-coddoc AS CHAR.
DEF NEW SHARED VAR s-nrodoc AS CHAR.

DEFINE NEW SHARED TEMP-TABLE DOCU LIKE CcbCDocu.
DEFINE NEW SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR. 
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE NEW SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE NEW SHARED VAR lh_handle AS HANDLE.
DEFINE NEW SHARED VAR s-nroser AS INT.

/* Variables para migrar a Excel */
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 RECT-58 RECT-59 RECT-60 BUTTON-1 ~
BUTTON-2 COMBO-BOX-CodDoc FILL-IN-NroDoc 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDoc FILL-IN-NroDoc ~
FILL-IN-FchDoc FILL-IN-FchVto FILL-IN-CodCli FILL-IN-NomCli FILL-IN-ImpTot ~
FILL-IN-CodRef FILL-IN-NroRef 

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
DEFINE VARIABLE h_bcanjexletra-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcanjexletra-02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-con003 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vcanjexletra AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Buscar Canje" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 6 BY 1.54.

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "LET" 
     LABEL "Doc" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "LET","FAC" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodRef AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Canje" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Emisión" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "X(256)":U 
     LABEL "N° Canje" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 111 BY 5.77.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 111 BY 4.04.

DEFINE RECTANGLE RECT-59
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 15.38.

DEFINE RECTANGLE RECT-60
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 15.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.19 COL 54 WIDGET-ID 4
     BUTTON-2 AT ROW 1.19 COL 113 WIDGET-ID 26
     COMBO-BOX-CodDoc AT ROW 1.38 COL 11 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-NroDoc AT ROW 1.38 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     FILL-IN-FchDoc AT ROW 2.35 COL 18 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-FchVto AT ROW 2.35 COL 46 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-CodCli AT ROW 3.31 COL 18 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NomCli AT ROW 3.31 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-ImpTot AT ROW 4.27 COL 18 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-CodRef AT ROW 5.42 COL 18 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-NroRef AT ROW 5.42 COL 34 COLON-ALIGNED WIDGET-ID 22
     RECT-57 AT ROW 1 COL 1 WIDGET-ID 16
     RECT-58 AT ROW 6.77 COL 1 WIDGET-ID 18
     RECT-59 AT ROW 10.81 COL 89 WIDGET-ID 28
     RECT-60 AT ROW 10.81 COL 1 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 167.43 BY 25.19 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: FACTURA B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA DE CANJES POR LETRAS"
         HEIGHT             = 25.19
         WIDTH              = 164.57
         MAX-HEIGHT         = 27.31
         MAX-WIDTH          = 167.43
         VIRTUAL-HEIGHT     = 27.31
         VIRTUAL-WIDTH      = 167.43
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
/* SETTINGS FOR FILL-IN FILL-IN-CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA DE CANJES POR LETRAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DE CANJES POR LETRAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Buscar Canje */
DO:
  ASSIGN COMBO-BOX-CodDoc FILL-IN-NroDoc.
  
  FIND ccbcdocu WHERE codcia = s-codcia
      AND coddoc = COMBO-BOX-CodDoc
      AND nrodoc = FILL-IN-NroDoc
      NO-LOCK NO-ERROR.
  CASE COMBO-BOX-CodDoc:
      WHEN "LET" THEN DO:
          /*
          IF NOT AVAILABLE ccbcdocu THEN DO:
              MESSAGE 'Letra no registrada' VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
          END.
          */
          IF AVAILABLE ccbcdocu THEN DO:
              DISPLAY
                  ccbcdocu.fchdoc @ FILL-IN-FchDoc
                  ccbcdocu.fchvto @ FILL-IN-FchVto
                  ccbcdocu.codcli @ FILL-IN-CodCli
                  ccbcdocu.nomcli @ FILL-IN-NomCli
                  ccbcdocu.imptot @ FILL-IN-ImpTot
                  ccbcdocu.codref @ FILL-IN-CodRef
                  ccbcdocu.nroref @ FILL-IN-NroRef
                  WITH FRAME {&FRAME-NAME}.
              ASSIGN
                  s-coddiv = ccbcdocu.coddiv
                  s-coddoc = ccbcdocu.codref
                  s-nrodoc = ccbcdocu.nroref.
          END.
          ELSE DO:
              DISPLAY
                  "" @ FILL-IN-FchDoc
                  "" @ FILL-IN-FchVto
                  "" @ FILL-IN-CodCli
                  "" @ FILL-IN-NomCli
                  0 @ FILL-IN-ImpTot
                  "" @ FILL-IN-CodRef
                  "" @ FILL-IN-NroRef
                  WITH FRAME {&FRAME-NAME}.

              s-coddiv = "***".
              s-coddoc = "***".
              s-nrodoc = "********".

              RUN dispatch IN h_q-con003 ('open-query':U).
              RUN dispatch IN h_b-aderec ('open-query':U).
              RUN dispatch IN h_b-con003 ('open-query':U).
          END.
      END.
      WHEN "FAC" THEN DO:
          /*
          IF NOT AVAILABLE ccbcdocu THEN DO:
              MESSAGE 'Factura no registrada' VIEW-AS ALERT-BOX ERROR.
              RETURN NO-APPLY.
          END.
          */
          IF AVAILABLE ccbcdocu THEN DO:
              DISPLAY
                  ccbcdocu.fchdoc @ FILL-IN-FchDoc
                  ccbcdocu.fchvto @ FILL-IN-FchVto
                  ccbcdocu.codcli @ FILL-IN-CodCli
                  ccbcdocu.nomcli @ FILL-IN-NomCli
                  ccbcdocu.imptot @ FILL-IN-ImpTot
                  WITH FRAME {&FRAME-NAME}.
              /* buscamos si hay letra de por medio */
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
                      ASSIGN
                          s-coddiv = ccbcmvto.coddiv
                          s-coddoc = ccbcmvto.coddoc
                          s-nrodoc = ccbcmvto.nrodoc.
                      DISPLAY
                          ccbcmvto.coddoc @ FILL-IN-CodRef
                          ccbcmvto.nrodoc @ FILL-IN-NroRef
                          WITH FRAME {&FRAME-NAME}.
                      LEAVE.
                  END.
              END.
          END.
          ELSE DO:
              /* No existe Blanqueo */
              DISPLAY
                  "" @ FILL-IN-FchDoc
                  "" @ FILL-IN-FchVto
                  "" @ FILL-IN-CodCli
                  "" @ FILL-IN-NomCli
                  0 @ FILL-IN-ImpTot
                  WITH FRAME {&FRAME-NAME}.

              DISPLAY
                  "" @ FILL-IN-CodRef
                  "" @ FILL-IN-NroRef
                  WITH FRAME {&FRAME-NAME}.

              RUN dispatch IN h_q-con003 ('open-query':U).
              RUN dispatch IN h_b-aderec ('open-query':U).
              RUN dispatch IN h_b-con003 ('open-query':U).
          END.
      END.
  END CASE.
  RUN dispatch IN h_q-con003 ('open-query':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    FIND ccbcdocu WHERE codcia = s-codcia
        AND coddoc = COMBO-BOX-CodDoc
        AND nrodoc = FILL-IN-NroDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN RETURN NO-APPLY.
    FIND Ccbcmvto WHERE Ccbcmvto.codcia = s-codcia
        AND Ccbcmvto.coddiv = s-coddiv
        AND Ccbcmvto.coddoc = s-coddoc
        AND Ccbcmvto.nrodoc = s-nrodoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcmvto THEN RETURN NO-APPLY.
    /* Excel */
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Excel.
    SESSION:SET-WAIT-STATE('').
    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

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
             INPUT  'aplic/ccb/vcanjexletra.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vcanjexletra ).
       RUN set-position IN h_vcanjexletra ( 7.15 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.31 , 102.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/bcanjexletra-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjexletra-01 ).
       RUN set-position IN h_bcanjexletra-01 ( 11.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_bcanjexletra-01 ( 6.38 , 85.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-aderec.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-aderec ).
       RUN set-position IN h_b-aderec ( 11.19 , 90.00 ) NO-ERROR.
       RUN set-size IN h_b-aderec ( 4.04 , 59.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-con003.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-con003 ).
       RUN set-position IN h_b-con003 ( 15.42 , 90.00 ) NO-ERROR.
       RUN set-size IN h_b-con003 ( 10.00 , 56.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/bcanjexletra-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcanjexletra-02 ).
       RUN set-position IN h_bcanjexletra-02 ( 17.73 , 2.00 ) NO-ERROR.
       RUN set-size IN h_bcanjexletra-02 ( 7.92 , 62.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/q-con003.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-con003 ).
       RUN set-position IN h_q-con003 ( 1.19 , 73.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_vcanjexletra. */
       RUN add-link IN adm-broker-hdl ( h_q-con003 , 'Record':U , h_vcanjexletra ).

       /* Links to SmartBrowser h_bcanjexletra-01. */
       RUN add-link IN adm-broker-hdl ( h_q-con003 , 'Record':U , h_bcanjexletra-01 ).

       /* Links to SmartBrowser h_b-aderec. */
       RUN add-link IN adm-broker-hdl ( h_q-con003 , 'Record':U , h_b-aderec ).

       /* Links to SmartBrowser h_b-con003. */
       RUN add-link IN adm-broker-hdl ( h_b-aderec , 'Record':U , h_b-con003 ).

       /* Links to SmartBrowser h_bcanjexletra-02. */
       RUN add-link IN adm-broker-hdl ( h_q-con003 , 'Record':U , h_bcanjexletra-02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_vcanjexletra ,
             FILL-IN-NroRef:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjexletra-01 ,
             h_vcanjexletra , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-aderec ,
             h_bcanjexletra-01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-con003 ,
             h_b-aderec , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcanjexletra-02 ,
             h_b-con003 , 'AFTER':U ).
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
  DISPLAY COMBO-BOX-CodDoc FILL-IN-NroDoc FILL-IN-FchDoc FILL-IN-FchVto 
          FILL-IN-CodCli FILL-IN-NomCli FILL-IN-ImpTot FILL-IN-CodRef 
          FILL-IN-NroRef 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 RECT-58 RECT-59 RECT-60 BUTTON-1 BUTTON-2 COMBO-BOX-CodDoc 
         FILL-IN-NroDoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
chWorkSheet:Range("A2"):VALUE = "DOC :".
chWorkSheet:Range("B2"):VALUE = COMBO-BOX-coddoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " " +
            FILL-IN-NroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("A3"):VALUE = "Emision :".
chWorkSheet:Range("B3"):VALUE = FILL-IN-FchDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("C3"):VALUE = "Vencimiento :".
chWorkSheet:Range("D3"):VALUE = FILL-IN-fchvto:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("A4"):VALUE = "Cliente :".
chWorkSheet:Range("B4"):VALUE = "'" + FILL-IN-CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
            " " + FILL-IN-NomCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} .
chWorkSheet:Range("A5"):VALUE = "Importe :".
chWorkSheet:Range("B5"):VALUE = FILL-IN-ImpTot:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("A6"):VALUE = "Tipo Canje :".
chWorkSheet:Range("B6"):VALUE = FILL-IN-CodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
chWorkSheet:Range("C6"):VALUE = "Nro Canje :".
chWorkSheet:Range("D6"):VALUE = "'" + FILL-IN-NroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

/**/

DEFINE VAR lnFila AS INT.
DEFINE VAR lnFilaRet AS INT.

lnFila = 8.
RUN ue-excel IN h_vcanjexletra(INPUT lnFila, INPUT chWorkSheet, OUTPUT lnFilaRet).

lnFila = lnFilaRet + 1.
RUN ue-excel-doctos IN h_bcanjexletra-01(INPUT lnFila, INPUT chWorkSheet, OUTPUT lnFilaRet).

lnFila = lnFilaRet + 1.
RUN ue-excel IN h_bcanjexletra-02(INPUT lnFila, INPUT chWorkSheet, OUTPUT lnFilaRet).

lnFila = lnFilaRet + 1.
RUN ue-excel IN h_b-aderec(INPUT lnFila, INPUT chWorkSheet, OUTPUT lnFilaRet).

lnFila = lnFilaRet + 2.
RUN ue-excel IN h_b-con003(INPUT lnFila, INPUT chWorkSheet, OUTPUT lnFilaRet).

chExcelApplication:VISIBLE = TRUE.

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

