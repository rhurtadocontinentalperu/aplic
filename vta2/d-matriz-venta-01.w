&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE T-DMatriz NO-UNDO LIKE VtaDMatriz.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcli AS CHAR.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-tpocmb AS DEC.
DEF SHARED VAR s-flgsit AS CHAR.
DEF SHARED VAR s-nrodec AS INT.

DEF VAR c-FgColor AS INT EXTENT 5.
DEF VAR c-BgColor AS INT EXTENT 5.
ASSIGN
    c-FgColor[1] = 9
    c-FgColor[2] = 0
    c-FgColor[3] = 15
    c-FgColor[4] = 15
    c-FgColor[5] = 15.
ASSIGN
    c-BgColor[1] = 10
    c-BgColor[2] = 14
    c-BgColor[3] = 1
    c-BgColor[4] = 5
    c-BgColor[5] = 13.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Almacen-1 FILL-IN-Almacen-2 ~
FILL-IN-Almacen-3 FILL-IN-Almacen-4 FILL-IN-Almacen-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPreUni D-Dialog 
FUNCTION fPreUni RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR,
    INPUT pUndVta AS CHAR,
    INPUT pAlmDes AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-vtacmatrizactiva AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-vtadmatriz AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-vtadmatriz-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-vtadmatriz-02 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Almacen-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1
     BGCOLOR 10 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen-4 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1
     BGCOLOR 5 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen-5 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1
     BGCOLOR 13 FGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-Almacen-1 AT ROW 1.38 COL 78 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Almacen-2 AT ROW 2.54 COL 78 COLON-ALIGNED WIDGET-ID 4
     Btn_OK AT ROW 3.12 COL 50
     FILL-IN-Almacen-3 AT ROW 3.69 COL 78 COLON-ALIGNED WIDGET-ID 6
     Btn_Cancel AT ROW 4.65 COL 50
     FILL-IN-Almacen-4 AT ROW 4.85 COL 78 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Almacen-5 AT ROW 6 COL 78 COLON-ALIGNED WIDGET-ID 10
     SPACE(12.56) SKIP(19.30)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "MATRIZ DE VENTAS"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
      TABLE: T-DMatriz T "NEW SHARED" NO-UNDO INTEGRAL VtaDMatriz
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Almacen-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Almacen-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Almacen-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Almacen-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Almacen-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* MATRIZ DE VENTAS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
   RUN Graba-Registros IN h_t-vtadmatriz.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
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
             INPUT  'aplic/vta2/b-vtacmatrizactiva.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-vtacmatrizactiva ).
       RUN set-position IN h_b-vtacmatrizactiva ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-vtacmatrizactiva ( 6.69 , 47.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/folder.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Cantidades|Precios|Stock Disponi' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 7.73 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 18.46 , 144.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-vtacmatrizactiva ,
             FILL-IN-Almacen-1:HANDLE , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             FILL-IN-Almacen-5:HANDLE , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  't-vtadmatriz-a.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-vtadmatriz ).
       RUN set-position IN h_t-vtadmatriz ( 8.88 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-vtadmatriz ( 15.88 , 142.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-vtadmatriz. */
       RUN add-link IN adm-broker-hdl ( h_b-vtacmatrizactiva , 'Record':U , h_t-vtadmatriz ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-vtadmatriz ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/t-vtadmatriz-01.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-vtadmatriz-01 ).
       RUN set-position IN h_t-vtadmatriz-01 ( 9.08 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-vtadmatriz-01 ( 13.27 , 142.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-vtadmatriz-01. */
       RUN add-link IN adm-broker-hdl ( h_b-vtacmatrizactiva , 'Record':U , h_t-vtadmatriz-01 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-vtadmatriz-01 ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/t-vtadmatriz-02.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-vtadmatriz-02 ).
       RUN set-position IN h_t-vtadmatriz-02 ( 9.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-vtadmatriz-02 ( 14.54 , 142.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-vtadmatriz-02. */
       RUN add-link IN adm-broker-hdl ( h_b-vtacmatrizactiva , 'Record':U , h_t-vtadmatriz-02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-vtadmatriz-02 ,
             h_folder , 'AFTER':U ).
    END. /* Page 3 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR pCodMat AS CHAR NO-UNDO.
  DEF VAR pAlmDes AS CHAR NO-UNDO.
  DEF VAR pUndVta AS CHAR NO-UNDO.
  DEF VAR pPreUni AS DEC NO-UNDO.
  DEF VAR pStkAct AS DEC NO-UNDO.

  EMPTY TEMP-TABLE T-DMatriz.
  FOR EACH Vtacmatriz WHERE Vtacmatriz.codcia = s-codcia
      AND VtaCMatriz.FlgActivo = YES,
      EACH Vtadmatriz OF Vtacmatriz NO-LOCK:
      CREATE T-DMatriz.
      BUFFER-COPY Vtadmatriz TO T-DMatriz.
      /* Valores por defecto */
      IF T-DMatriz.codmat[1] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[1],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[1] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[1] = pUndVta
              T-DMatriz.PreUni[1] = pPreUni
              T-DMatriz.StkAct[1] = pStkAct.
      END.
      IF T-DMatriz.codmat[2] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[2],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[2] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[2] = pUndVta
              T-DMatriz.PreUni[2] = pPreUni
              T-DMatriz.StkAct[2] = pStkAct.
      END.
      IF T-DMatriz.codmat[3] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[3],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[3] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[3] = pUndVta
              T-DMatriz.PreUni[3] = pPreUni
              T-DMatriz.StkAct[3] = pStkAct.
      END.
      IF T-DMatriz.codmat[4] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[4],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[4] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[4] = pUndVta
              T-DMatriz.PreUni[4] = pPreUni
              T-DMatriz.StkAct[4] = pStkAct.
      END.
      IF T-DMatriz.codmat[5] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[5],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[5] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[5] = pUndVta
              T-DMatriz.PreUni[5] = pPreUni
              T-DMatriz.StkAct[5] = pStkAct.
      END.
      IF T-DMatriz.codmat[6] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[6],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[6] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[6] = pUndVta
              T-DMatriz.PreUni[6] = pPreUni
              T-DMatriz.StkAct[6] = pStkAct.
      END.
      IF T-DMatriz.codmat[7] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[7],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[7] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[7] = pUndVta
              T-DMatriz.PreUni[7] = pPreUni
              T-DMatriz.StkAct[7] = pStkAct.
      END.
      IF T-DMatriz.codmat[8] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[8],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[8] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[8] = pUndVta
              T-DMatriz.PreUni[8] = pPreUni
              T-DMatriz.StkAct[8] = pStkAct.
      END.
      IF T-DMatriz.codmat[9] <> "" THEN DO:
          FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
              AND Almmmatg.codmat = T-DMatriz.codmat[9]
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmatg THEN
              ASSIGN
              T-DMatriz.AlmDes[9] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[9] = Almmmatg.UndA
              T-DMatriz.PreUni[9] = fPreUni(T-DMatriz.codmat[9], T-DMatriz.UndVta[9], T-DMatriz.AlmDes[9]).
          IF AVAILABLE Almmmatg AND Almmmatg.UndB <> "" THEN
              ASSIGN
              T-DMatriz.AlmDes[9] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[9] = Almmmatg.UndB
              T-DMatriz.PreUni[9] = fPreUni(T-DMatriz.codmat[9], T-DMatriz.UndVta[9], T-DMatriz.AlmDes[9]).
      END.
      IF T-DMatriz.codmat[10] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[10],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[10] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[10] = pUndVta
              T-DMatriz.PreUni[10] = pPreUni
              T-DMatriz.StkAct[10] = pStkAct.
      END.
      IF T-DMatriz.codmat[11] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[11],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[11] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[11] = pUndVta
              T-DMatriz.PreUni[11] = pPreUni
              T-DMatriz.StkAct[11] = pStkAct.
      END.
      IF T-DMatriz.codmat[12] <> "" THEN DO:
          RUN Carga-Temporal-Detalle (T-DMatriz.codmat[12],
                                      ENTRY(1, s-codalm),
                                      OUTPUT pUndVta,
                                      OUTPUT pPreUni,
                                      OUTPUT pStkAct).
          ASSIGN
              T-DMatriz.AlmDes[12] = ENTRY(1, s-codalm)
              T-DMatriz.UndVta[12] = pUndVta
              T-DMatriz.PreUni[12] = pPreUni
              T-DMatriz.StkAct[12] = pStkAct.
      END.
  END.

  /* Cargamos valores ya grabados */
  BlockLoop:
  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK:
      FOR EACH T-DMatriz:
          IF ITEM.codmat = T-DMatriz.codmat[1] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[1] = ITEM.CanPed
                  T-DMatriz.Importe[1] = ITEM.ImpLin
                  T-DMatriz.AlmDes[1] = ITEM.AlmDes
                  T-DMatriz.UndVta[1] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[2] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[2] = ITEM.CanPed
                  T-DMatriz.Importe[2] = ITEM.ImpLin
                  T-DMatriz.AlmDes[2] = ITEM.AlmDes
                  T-DMatriz.UndVta[2] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[3] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[3] = ITEM.CanPed
                  T-DMatriz.Importe[3] = ITEM.ImpLin
                  T-DMatriz.AlmDes[3] = ITEM.AlmDes
                  T-DMatriz.UndVta[3] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[4] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[4] = ITEM.CanPed
                  T-DMatriz.Importe[4] = ITEM.ImpLin
                  T-DMatriz.AlmDes[4] = ITEM.AlmDes
                  T-DMatriz.UndVta[4] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[5] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[5] = ITEM.CanPed
                  T-DMatriz.Importe[5] = ITEM.ImpLin
                  T-DMatriz.AlmDes[5] = ITEM.AlmDes
                  T-DMatriz.UndVta[5] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[6] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[6] = ITEM.CanPed
                  T-DMatriz.Importe[6] = ITEM.ImpLin
                  T-DMatriz.AlmDes[6] = ITEM.AlmDes
                  T-DMatriz.UndVta[6] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[7] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[7] = ITEM.CanPed
                  T-DMatriz.Importe[7] = ITEM.ImpLin
                  T-DMatriz.AlmDes[7] = ITEM.AlmDes
                  T-DMatriz.UndVta[7] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[8] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[8] = ITEM.CanPed
                  T-DMatriz.Importe[8] = ITEM.ImpLin
                  T-DMatriz.AlmDes[8] = ITEM.AlmDes
                  T-DMatriz.UndVta[8] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[9] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[9] = ITEM.CanPed
                  T-DMatriz.Importe[9] = ITEM.ImpLin
                  T-DMatriz.AlmDes[9] = ITEM.AlmDes
                  T-DMatriz.UndVta[9] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[10] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[10] = ITEM.CanPed
                  T-DMatriz.Importe[10] = ITEM.ImpLin
                  T-DMatriz.AlmDes[10] = ITEM.AlmDes
                  T-DMatriz.UndVta[10] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[11] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[11] = ITEM.CanPed
                  T-DMatriz.Importe[11] = ITEM.ImpLin
                  T-DMatriz.AlmDes[11] = ITEM.AlmDes
                  T-DMatriz.UndVta[11] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
          IF ITEM.codmat = T-DMatriz.codmat[12] THEN DO:
              ASSIGN
                  T-DMatriz.Cantidad[12] = ITEM.CanPed
                  T-DMatriz.Importe[12] = ITEM.ImpLin
                  T-DMatriz.AlmDes[12] = ITEM.AlmDes
                  T-DMatriz.UndVta[12] = ITEM.UndVta.
              NEXT BlockLoop.
          END.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Detalle D-Dialog 
PROCEDURE Carga-Temporal-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pAlmDes AS CHAR.
DEF OUTPUT PARAMETER pUndVta AS CHAR.
DEF OUTPUT PARAMETER pPreUni AS DEC.
DEF OUTPUT PARAMETER pStkAct AS DEC.

DEF VAR pStkComprometido AS DEC NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN
    ASSIGN
    pUndVta = Almmmatg.UndA
    pPreUni = fPreUni(pCodMat, pUndVta, pAlmDes).
IF AVAILABLE Almmmatg AND Almmmatg.UndB <> "" THEN
    ASSIGN
    pUndVta = Almmmatg.UndB
    pPreUni = fPreUni(pCodMat, pUndVta, pAlmDes).

/*
FIND Almmmate WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codmat = pCodMat
    AND Almmmate.codalm = pAlmDes
    NO-LOCK NO-ERROR.
IF AVAILABLE Almmmate THEN pStkAct = Almmmate.StkAct.
RUN vta2/Stock-Comprometido (pCodMat, 
                             pAlmDes, 
                             OUTPUT pStkComprometido).
pStkAct = pStkAct - pStkComprometido.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-Almacen-1 FILL-IN-Almacen-2 FILL-IN-Almacen-3 
          FILL-IN-Almacen-4 FILL-IN-Almacen-5 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR k AS INT NO-UNDO.

  RUN Carga-Temporal.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO k = 1 TO NUM-ENTRIES(s-CodAlm) WITH FRAME {&FRAME-NAME}:
      FIND Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = ENTRY(k, s-CodAlm)
          NO-LOCK.
      CASE k:
          WHEN 1 THEN ASSIGN FILL-IN-Almacen-1:FGCOLOR = c-FgColor[k] FILL-IN-Almacen-1:BGCOLOR = c-BgColor[k].
          WHEN 2 THEN ASSIGN FILL-IN-Almacen-2:FGCOLOR = c-FgColor[k] FILL-IN-Almacen-2:BGCOLOR = c-BgColor[k].
          WHEN 3 THEN ASSIGN FILL-IN-Almacen-3:FGCOLOR = c-FgColor[k] FILL-IN-Almacen-3:BGCOLOR = c-BgColor[k].
          WHEN 4 THEN ASSIGN FILL-IN-Almacen-4:FGCOLOR = c-FgColor[k] FILL-IN-Almacen-4:BGCOLOR = c-BgColor[k].
          WHEN 5 THEN ASSIGN FILL-IN-Almacen-5:FGCOLOR = c-FgColor[k] FILL-IN-Almacen-5:BGCOLOR = c-BgColor[k].
      END CASE.
      CASE k:
          WHEN 1 THEN ASSIGN FILL-IN-Almacen-1:SCREEN-VALUE = Almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
          WHEN 2 THEN ASSIGN FILL-IN-Almacen-2:SCREEN-VALUE = Almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
          WHEN 3 THEN ASSIGN FILL-IN-Almacen-3:SCREEN-VALUE = Almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
          WHEN 4 THEN ASSIGN FILL-IN-Almacen-4:SCREEN-VALUE = Almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
          WHEN 5 THEN ASSIGN FILL-IN-Almacen-5:SCREEN-VALUE = Almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
      END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPreUni D-Dialog 
FUNCTION fPreUni RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR,
    INPUT pUndVta AS CHAR,
    INPUT pAlmDes AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE f-Factor LIKE Facdpedi.factor NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN 0.
IF pCodMat = "" THEN RETURN 0.

RUN vta2/PrecioMayorista-Cont (s-CodCia,
                               s-CodDiv,
                               s-CodCli,
                               s-CodMon,
                               s-TpoCmb,
                               OUTPUT f-Factor,
                               pCodMat,
                               s-FlgSit,
                               pUndVta,
                               1,
                               s-NroDec,
                               pAlmDes,
                               OUTPUT f-PreBas,
                               OUTPUT f-PreVta,
                               OUTPUT f-Dsctos,
                               OUTPUT y-Dsctos,
                               OUTPUT x-TipDto
                               ).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 0.
RETURN f-PreVta.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

