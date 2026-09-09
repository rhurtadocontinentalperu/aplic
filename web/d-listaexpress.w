&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.



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

DEF INPUT-OUTPUT PARAMETER TABLE FOR ITEM.
DEF OUTPUT PARAMETER pOk AS LOG.

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-codalm AS CHAR.

pOk = NO.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_Categoria BUTTON_Limpiar ~
COMBO-BOX_SubCategoria COMBO-BOX_EtapaEscolar FILL-IN_Producto Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_Categoria COMBO-BOX_SubCategoria ~
COMBO-BOX_EtapaEscolar FILL-IN_Producto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-listaexpress AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.42
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.42
     BGCOLOR 8 .

DEFINE BUTTON BUTTON_Limpiar 
     LABEL "LIMPIAR FILTROS" 
     SIZE 35 BY 1.62
     FONT 8.

DEFINE VARIABLE COMBO-BOX_Categoria AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "Categoría" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEMS "TODOS" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_EtapaEscolar AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "Etapa Escolar" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEMS "TODOS" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_SubCategoria AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "Sub Categoría" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEMS "TODOS" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_Producto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Producto" 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX_Categoria AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 2
     BUTTON_Limpiar AT ROW 2.08 COL 75 WIDGET-ID 10
     COMBO-BOX_SubCategoria AT ROW 2.35 COL 11 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX_EtapaEscolar AT ROW 3.42 COL 11 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_Producto AT ROW 4.5 COL 11 COLON-ALIGNED WIDGET-ID 8
     Btn_OK AT ROW 25.23 COL 3
     Btn_Cancel AT ROW 25.23 COL 19
     SPACE(77.28) SKIP(0.22)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE ""
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
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
ON WINDOW-CLOSE OF FRAME D-Dialog
DO:  
    MESSAGE 'Desea salir SIN GRABAR?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  MESSAGE 'Desea salir SIN GRABAR?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  RUN Devuelve-Temporal IN h_b-listaexpress ( OUTPUT TABLE ITEM).

  DEF VAR x-Item AS INTE NO-UNDO.
  FOR EACH ITEM WHERE ITEM.CanPed <= 0 OR ITEM.CanPed = ?:
      DELETE ITEM.
  END.
  FOR EACH ITEM, FIRST listaexpressarticulos WHERE listaexpressarticulos.codcia = s-codcia AND
      listaexpressarticulos.codprodpremium = ITEM.codmat NO-LOCK
      BY ITEM.NroItm:
      IF TRUE <> (ITEM.AlmDes > '') THEN ITEM.AlmDes = ENTRY(1, s-CodAlm).
      x-Item = x-Item + 1.
      ITEM.NroItm = x-Item.
      ITEM.CodMatWeb = listaexpressarticulos.codprodstandard.
      ITEM.DesMatWeb = listaexpressarticulos.nomprodstandard.
  END.

  pOk = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Limpiar D-Dialog
ON CHOOSE OF BUTTON_Limpiar IN FRAME D-Dialog /* LIMPIAR FILTROS */
DO:
  COMBO-BOX_Categoria = 'TODOS'.
  COMBO-BOX_EtapaEscolar = 'TODOS'.
  COMBO-BOX_SubCategoria = 'TODOS'.
  FILL-IN_Producto = ''.

  DISPLAY 
      COMBO-BOX_Categoria COMBO-BOX_EtapaEscolar COMBO-BOX_SubCategoria FILL-IN_Producto
      WITH FRAME {&FRAME-NAME}.

  RUN Aplicar-Filtros IN h_b-listaexpress
    ( INPUT COMBO-BOX_Categoria /* CHARACTER */,
      INPUT COMBO-BOX_SubCategoria /* CHARACTER */,
      INPUT COMBO-BOX_EtapaEscolar /* CHARACTER */,
      INPUT FILL-IN_Producto /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_Categoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_Categoria D-Dialog
ON VALUE-CHANGED OF COMBO-BOX_Categoria IN FRAME D-Dialog /* Categoría */
DO:
  ASSIGN {&SELF-NAME}.
  RUN Aplicar-Filtros IN h_b-listaexpress
    ( INPUT COMBO-BOX_Categoria /* CHARACTER */,
      INPUT COMBO-BOX_SubCategoria /* CHARACTER */,
      INPUT COMBO-BOX_EtapaEscolar /* CHARACTER */,
      INPUT FILL-IN_Producto /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_EtapaEscolar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_EtapaEscolar D-Dialog
ON VALUE-CHANGED OF COMBO-BOX_EtapaEscolar IN FRAME D-Dialog /* Etapa Escolar */
DO:
    ASSIGN {&SELF-NAME}.
    RUN Aplicar-Filtros IN h_b-listaexpress
      ( INPUT COMBO-BOX_Categoria /* CHARACTER */,
        INPUT COMBO-BOX_SubCategoria /* CHARACTER */,
        INPUT COMBO-BOX_EtapaEscolar /* CHARACTER */,
        INPUT FILL-IN_Producto /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_SubCategoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_SubCategoria D-Dialog
ON VALUE-CHANGED OF COMBO-BOX_SubCategoria IN FRAME D-Dialog /* Sub Categoría */
DO:
    ASSIGN {&SELF-NAME}.
    RUN Aplicar-Filtros IN h_b-listaexpress
      ( INPUT COMBO-BOX_Categoria /* CHARACTER */,
        INPUT COMBO-BOX_SubCategoria /* CHARACTER */,
        INPUT COMBO-BOX_EtapaEscolar /* CHARACTER */,
        INPUT FILL-IN_Producto /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Producto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Producto D-Dialog
ON LEAVE OF FILL-IN_Producto IN FRAME D-Dialog /* Producto */
DO:
    ASSIGN {&SELF-NAME}.
    RUN Aplicar-Filtros IN h_b-listaexpress
      ( INPUT COMBO-BOX_Categoria /* CHARACTER */,
        INPUT COMBO-BOX_SubCategoria /* CHARACTER */,
        INPUT COMBO-BOX_EtapaEscolar /* CHARACTER */,
        INPUT FILL-IN_Producto /* CHARACTER */).
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
             INPUT  'aplic/web/b-listaexpress.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-listaexpress ).
       RUN set-position IN h_b-listaexpress ( 5.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-listaexpress ( 19.65 , 107.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-listaexpress ,
             FILL-IN_Producto:HANDLE , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
  DISPLAY COMBO-BOX_Categoria COMBO-BOX_SubCategoria COMBO-BOX_EtapaEscolar 
          FILL-IN_Producto 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX_Categoria BUTTON_Limpiar COMBO-BOX_SubCategoria 
         COMBO-BOX_EtapaEscolar FILL-IN_Producto Btn_OK Btn_Cancel 
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_Categoria:DELIMITER = '|'.
      COMBO-BOX_SubCategoria:DELIMITER = '|'.
      COMBO-BOX_EtapaEscolar:DELIMITER = '|'.
      FOR EACH listaexpressarticulos NO-LOCK WHERE listaexpressarticulos.codcia = s-codcia:
          IF listaexpressarticulos.categoria > '' AND
              LOOKUP(listaexpressarticulos.categoria, COMBO-BOX_Categoria:LIST-ITEMS, '|') = 0
              THEN DO:
              COMBO-BOX_Categoria:ADD-LAST(listaexpressarticulos.categoria).
          END.
          IF listaexpressarticulos.subcategoria > '' AND
              LOOKUP(listaexpressarticulos.subcategoria, COMBO-BOX_SubCategoria:LIST-ITEMS, '|') = 0
              THEN DO:
              COMBO-BOX_SubCategoria:ADD-LAST(listaexpressarticulos.subcategoria).
          END.
          IF listaexpressarticulos.etapaescolar > '' AND
              LOOKUP(listaexpressarticulos.etapaescolar, COMBO-BOX_etapaescolar:LIST-ITEMS, '|') = 0
              THEN DO:
              COMBO-BOX_etapaescolar:ADD-LAST(listaexpressarticulos.etapaescolar).
          END.
      END.
      RUN Captura-Temporal IN h_b-listaexpress ( INPUT TABLE ITEM).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

