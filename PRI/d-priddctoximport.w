&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
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
DEF SHARED VAR s-codcia  AS INTE.
DEF SHARED VAR pv-codcia AS INTE.
/* Local Variable Definitions ---                                       */

DEF OUTPUT PARAMETER pTipo AS CHAR.
DEF OUTPUT PARAMETER pLlave_c1 AS CHAR.
DEF OUTPUT PARAMETER pLlave_c2 AS CHAR.

pTipo = ''.
pLlave_c1 = ''.
pLlave_c2 = ''.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_Tipo FILL-IN_Llave_c1 ~
FILL-IN_Llave_c2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_Tipo FILL-IN_Llave_c1 ~
FILL-IN_Name_c1 FILL-IN_Llave_c2 FILL-IN_Name_c2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX_Tipo AS CHARACTER FORMAT "X(256)":U INITIAL "LINEA" 
     LABEL "Seleccione" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "SKU","LINEA","PROVEEDOR","MARCA" 
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_Llave_c1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Línea" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Llave_c2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Linea" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Name_c1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Name_c2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX_Tipo AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_Llave_c1 AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_Name_c1 AT ROW 2.62 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN_Llave_c2 AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_Name_c2 AT ROW 3.69 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     Btn_OK AT ROW 5.31 COL 3
     Btn_Cancel AT ROW 5.31 COL 18
     SPACE(66.42) SKIP(0.44)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "INGRESE LOS DATOS SOLICITADOS"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
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

/* SETTINGS FOR FILL-IN FILL-IN_Name_c1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Name_c2 IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* INGRESE LOS DATOS SOLICITADOS */
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
  ASSIGN COMBO-BOX_Tipo FILL-IN_Llave_c1 FILL-IN_Llave_c2.
  /* Consistencias */
  CASE COMBO-BOX_Tipo:
      WHEN 'SKU' THEN DO:
          FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
              Almmmatg.codmat = FILL-IN_Llave_c1
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almmmatg THEN DO:
              MESSAGE 'Artículo NO registrado' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO FILL-IN_Llave_c1.
              RETURN NO-APPLY.
          END.
      END.
      WHEN 'LINEA' THEN DO:
          FIND Almtfami WHERE Almtfami.codcia = s-codcia AND
              Almtfami.codfam = FILL-IN_Llave_c1
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almtfami THEN DO:
              MESSAGE 'Línea NO registrada' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO FILL-IN_Llave_c1.
              RETURN NO-APPLY.
          END.
          IF FILL-IN_Llave_c2 > '' THEN DO:
              FIND Almsfami WHERE AlmSFami.CodCia = s-codcia AND 
                  AlmSFami.codfam = FILL-IN_Llave_c1 AND
                  AlmSFami.subfam = FILL-IN_Llave_c2
                  NO-LOCK NO-ERROR.
              IF NOT AVAILABLE Almsfami THEN DO:
                  MESSAGE 'Sub-Línea NO registrada' VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO FILL-IN_Llave_c2.
                  RETURN NO-APPLY.
              END.
          END.
      END.
      WHEN 'PROVEEDOR' THEN DO:
          FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
              gn-prov.CodPro = FILL-IN_Llave_c1
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-prov THEN DO:
              MESSAGE 'Proveedor NO registrado' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO FILL-IN_Llave_c1.
              RETURN NO-APPLY.
          END.
      END.
      WHEN 'MARCA' THEN DO:
          FIND Almtabla WHERE Almtabla.Tabla = "MK" AND
              Almtabla.Codigo = FILL-IN_Llave_c1:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almtabla THEN DO:
              MESSAGE 'Marca NO registrada' VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO FILL-IN_Llave_c1.
              RETURN NO-APPLY.
          END.
      END.
  END CASE.
  ASSIGN
      pTipo = COMBO-BOX_Tipo 
      pLlave_c1 = FILL-IN_Llave_c1 
      pLlave_c2 = FILL-IN_Llave_c2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_Tipo D-Dialog
ON VALUE-CHANGED OF COMBO-BOX_Tipo IN FRAME D-Dialog /* Seleccione */
DO:
  CASE SELF:SCREEN-VALUE:
      WHEN  "SKU" THEN DO:
          FILL-IN_Llave_c1:LABEL = "Artículo".
          FILL-IN_Llave_c2:LABEL = "".
          FILL-IN_Llave_c2:VISIBLE = NO.
      END.
      WHEN  "LINEA" THEN DO:
          FILL-IN_Llave_c1:LABEL = "Línea".
          FILL-IN_Llave_c2:LABEL = "Sub-Línea".
          FILL-IN_Llave_c2:VISIBLE = YES.
      END.
      WHEN  "PROVEEDOR" THEN DO:
          FILL-IN_Llave_c1:LABEL = "Proveedor".
          FILL-IN_Llave_c2:LABEL = "".
          FILL-IN_Llave_c2:VISIBLE = NO.
      END.
      WHEN  "MARCA" THEN DO:
          FILL-IN_Llave_c1:LABEL = "Marca".
          FILL-IN_Llave_c2:LABEL = "".
          FILL-IN_Llave_c2:VISIBLE = NO.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Llave_c1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Llave_c1 D-Dialog
ON LEAVE OF FILL-IN_Llave_c1 IN FRAME D-Dialog /* Línea */
DO:
  CASE COMBO-BOX_Tipo:SCREEN-VALUE:
      WHEN 'SKU' THEN DO:
          FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
              Almmmatg.codmat = FILL-IN_Llave_c1:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmatg THEN DISPLAY Almmmatg.desmat @ FILL-IN_Name_c1 WITH FRAME {&FRAME-NAME}.
      END.
      WHEN 'LINEA' THEN DO:
          FIND Almtfami WHERE Almtfami.codcia = s-codcia AND
              Almtfami.codfam = FILL-IN_Llave_c1:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtfami THEN DISPLAY ALmtfami.desfam @ FILL-IN_Name_c1 WITH FRAME {&FRAME-NAME}.
      END.
      WHEN 'PROVEEDOR' THEN DO:
          FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
              gn-prov.CodPro = FILL-IN_Llave_c1:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF AVAILABLE gn-prov THEN DISPLAY gn-prov.nompro @ FILL-IN_Name_c1 WITH FRAME {&FRAME-NAME}.
      END.
      WHEN 'MARCA' THEN DO:
          FIND Almtabla WHERE Almtabla.Tabla = "MK" AND
              Almtabla.Codigo = FILL-IN_Llave_c1:SCREEN-VALUE
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtabla THEN DISPLAY almtabla.Nombre @ FILL-IN_Name_c1 WITH FRAME {&FRAME-NAME}.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Llave_c1 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_Llave_c1 IN FRAME D-Dialog /* Línea */
OR F8 OF FILL-IN_Llave_c1 DO:
  ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  CASE COMBO-BOX_Tipo:SCREEN-VALUE:
      WHEN 'LINEA' THEN DO:
          RUN lkup/c-famili02.w('LINEAS').
          IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
      END.
      WHEN 'SKU' THEN DO:
          RUN lkup/c-catart.w('ARTICULOS').
          IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
      END.
      WHEN 'MARCA' THEN DO:
          input-var-1 = "MK".
          RUN lkup/c-almtab.w('MARCAS').
          IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
      END.
      WHEN 'PROVEEDOR' THEN DO:
          RUN lkup/c-provee.w('PROVEEDORES').
          IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Llave_c2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Llave_c2 D-Dialog
ON LEAVE OF FILL-IN_Llave_c2 IN FRAME D-Dialog /* Sub-Linea */
DO:
  FIND Almsfami WHERE AlmSFami.CodCia = s-codcia AND 
      AlmSFami.codfam = FILL-IN_Llave_c1:SCREEN-VALUE AND
      AlmSFami.subfam = FILL-IN_Llave_c2:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almsfami THEN FILL-IN_Name_c2:SCREEN-VALUE = AlmSFami.dessub.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Llave_c2 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_Llave_c2 IN FRAME D-Dialog /* Sub-Linea */
OR F8 OF FILL-IN_Llave_c2 DO:
    ASSIGN
        input-var-1 = FILL-IN_Llave_c1:SCREEN-VALUE
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-subfam.w('SUB-LINEAS').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.

  
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
  DISPLAY COMBO-BOX_Tipo FILL-IN_Llave_c1 FILL-IN_Name_c1 FILL-IN_Llave_c2 
          FILL-IN_Name_c2 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX_Tipo FILL-IN_Llave_c1 FILL-IN_Llave_c2 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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

