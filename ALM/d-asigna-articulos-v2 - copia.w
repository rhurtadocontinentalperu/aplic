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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR pv-codcia AS INTE.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Linea COMBO-BOX-Sublinea ~
FILL-IN-CodMat FILL-IN-CodPro FILL-IN-CodMar Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Linea COMBO-BOX-Sublinea ~
FILL-IN-CodMat FILL-IN-DesMat FILL-IN-CodPro FILL-IN-NomPro FILL-IN-CodMar ~
FILL-IN-DesMar FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "TODAS","TODAS"
     DROP-DOWN-LIST
     SIZE 87 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Sublinea AS CHARACTER FORMAT "X(256)":U INITIAL "TODAS" 
     LABEL "Sublinea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "TODAS","TODAS"
     DROP-DOWN-LIST
     SIZE 87 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMar AS CHARACTER FORMAT "X(8)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(15)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX-Linea AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Sublinea AT ROW 3.15 COL 12 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-CodMat AT ROW 4.23 COL 12 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-DesMat AT ROW 4.23 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-CodPro AT ROW 5.31 COL 12 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NomPro AT ROW 5.31 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-CodMar AT ROW 6.38 COL 12 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-DesMar AT ROW 6.38 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     Btn_OK AT ROW 8.54 COL 3
     Btn_Cancel AT ROW 8.54 COL 18
     FILL-IN-Mensaje AT ROW 8.81 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     SPACE(15.56) SKIP(0.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "ASIGNACION AUTOMATICA DE ARTICULOS POR ALMACEN"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-DesMar IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* ASIGNACION AUTOMATICA DE ARTICULOS POR ALMACEN */
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
    ASSIGN COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodMat.
    ASSIGN FILL-IN-CodPro FILL-IN-CodMar.


    DEFINE VAR pMensaje AS CHAR NO-UNDO.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN alm/almacen-library PERSISTENT SET hProc.

    CASE TRUE:
        WHEN FILL-IN-CodMat > '' THEN DO:
            RUN ALM_Materiales-por-Almacen IN hProc ("",
                                                     INPUT FILL-IN-CodMat,
                                                     INPUT "A",
                                                     OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
                RETURN NO-APPLY.
            END.
        END.
        OTHERWISE DO:
            FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = s-CodCia
                AND Almmmatg.TpoArt <> "D"      /* NO Desactivados */
                AND (COMBO-BOX-Linea = 'TODAS' OR Almmmatg.codfam = COMBO-BOX-Linea)
                AND (COMBO-BOX-Sublinea = 'TODAS' OR Almmmatg.subfam = COMBO-BOX-Sublinea)
                AND (TRUE <> (FILL-IN-CodPro > '') OR Almmmatg.CodPr1 = FILL-IN-CodPro)
                AND (TRUE <> (FILL-IN-CodMar > '') OR Almmmatg.CodMar = FILL-IN-CodMar):
                /*AND TRUE <> (Almmmatg.Almacenes > ''):*/
                FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PROCESANDO: ' + Almmmatg.codmat.
                RUN ALM_Materiales-por-Almacen IN hProc (INPUT "",      /* TODOS los almacenes */
                                                         INPUT Almmmatg.CodMat,
                                                         INPUT "A",     /* Solo automáticos */
                                                         OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    MESSAGE pMensaje SKIP(1)
                        'Se continuará el proceso con el siguiente artículo'
                        VIEW-AS ALERT-BOX WARNING.
                END.
            END.
        END.
    END CASE.
    DELETE PROCEDURE hProc.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Linea D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-Linea IN FRAME D-Dialog /* Linea */
DO:
  ASSIGN COMBO-BOX-Linea.

  DEF VAR k AS INTE NO-UNDO.
  DO k = 1 TO COMBO-BOX-Sublinea:NUM-ITEMS:
      COMBO-BOX-Sublinea:DELETE(1).
  END.
  COMBO-BOX-Sublinea:ADD-LAST("TODAS","TODAS").
  COMBO-BOX-Sublinea:SCREEN-VALUE = "TODAS".
  FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
      AND Almsfami.codfam = COMBO-BOX-Linea:
      COMBO-BOX-Sublinea:ADD-LAST(AlmSFami.subfam + " - " + AlmSFami.dessub,AlmSFami.subfam).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Sublinea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Sublinea D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-Sublinea IN FRAME D-Dialog /* Sublinea */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMar D-Dialog
ON LEAVE OF FILL-IN-CodMar IN FRAME D-Dialog /* Marca */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND almtabla WHERE almtabla.Tabla = "MK" AND
      almtabla.Codigo = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtabla THEN DO:
      MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-DesMar:SCREEN-VALUE = almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat D-Dialog
ON LEAVE OF FILL-IN-CodMat IN FRAME D-Dialog /* Artículo */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
      AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE 'Artículo no registrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-DesMat:SCREEN-VALUE = Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro D-Dialog
ON LEAVE OF FILL-IN-CodPro IN FRAME D-Dialog /* Proveedor */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
      AND gn-prov.CodPro = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-prov THEN DO:
      MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
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
  DISPLAY COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodMat FILL-IN-DesMat 
          FILL-IN-CodPro FILL-IN-NomPro FILL-IN-CodMar FILL-IN-DesMar 
          FILL-IN-Mensaje 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX-Linea COMBO-BOX-Sublinea FILL-IN-CodMat FILL-IN-CodPro 
         FILL-IN-CodMar Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
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
      COMBO-BOX-Linea:DELIMITER = '|'.
      COMBO-BOX-Sublinea:DELIMITER = '|'.
      FOR EACH Almtfami NO-LOCK WHERE ALmtfami.codcia = s-codcia:
          COMBO-BOX-Linea:ADD-LAST(Almtfami.codfam + " - " + Almtfami.desfam,Almtfami.codfam).
      END.
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
        WHEN "FILL-IN-CodMar" THEN ASSIGN input-var-1 = "MK".
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

