&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-OOMoviAlmacen FOR OOMoviAlmacen.



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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF INPUT PARAMETER pTipo AS CHAR NO-UNDO.      /* SE PR */
DEF OUTPUT PARAMETER pZona AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pBultos AS INTE NO-UNDO.
DEF OUTPUT PARAMETER pOk AS LOG NO-UNDO.

pZona = 0.
pBultos = 0.
pOk = NO.       /* Por defecto */

/* Movimiento de salida de almacén S-03 */
FIND OOMoviAlmacen WHERE ROWID(OOMoviAlmacen) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE OOMoviAlmacen THEN RETURN.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Bultos Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_Zona FILL-IN-Bultos ~
FILL-IN_FchPed FILL-IN_CodCli FILL-IN_NomCli FILL-IN_Items 

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
     SIZE 18 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 18 BY 2.15
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX_Zona AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "ZONA" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1",0
     DROP-DOWN-LIST
     SIZE 28 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Bultos AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "INGRESE EL # DE BULTOS" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.38
     BGCOLOR 14 FGCOLOR 0 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.38.

DEFINE VARIABLE FILL-IN_FchPed AS DATE FORMAT "99/99/9999" 
     LABEL "Fecha de Emisión" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.38.

DEFINE VARIABLE FILL-IN_Items AS INTEGER FORMAT ">,>>9" INITIAL 0 
     LABEL "# de Items" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY 1.38.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(100)" 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 86 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX_Zona AT ROW 1.27 COL 51 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-Bultos AT ROW 2.62 COL 51 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_FchPed AT ROW 4.23 COL 51 COLON-ALIGNED WIDGET-ID 12
     FILL-IN_CodCli AT ROW 5.85 COL 51 COLON-ALIGNED HELP
          "C¢digo del Cliente" WIDGET-ID 8
     FILL-IN_NomCli AT ROW 7.46 COL 51 COLON-ALIGNED HELP
          "Nombre del Cliente" WIDGET-ID 16
     FILL-IN_Items AT ROW 9.08 COL 51 COLON-ALIGNED WIDGET-ID 14
     Btn_OK AT ROW 11.77 COL 3 WIDGET-ID 36
     Btn_Cancel AT ROW 11.77 COL 22 WIDGET-ID 34
     SPACE(103.42) SKIP(0.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 9
         TITLE "RECEPCION DE BULTOS DE DISTRIBUCION" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: b-OOMoviAlmacen B "?" ? INTEGRAL OOMoviAlmacen
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

/* SETTINGS FOR COMBO-BOX COMBO-BOX_Zona IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchPed IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Items IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* RECEPCION DE BULTOS DE DISTRIBUCION */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  pOk = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    ASSIGN
          COMBO-BOX_Zona FILL-IN-Bultos.

      /* Control de bultos */
      IF FILL-IN-Bultos = 0 THEN DO:
          MESSAGE 'Vuelva a contar los bultos por favor' VIEW-AS ALERT-BOX WARNING.
          APPLY 'ENTRY':U TO FILL-IN-Bultos.
          RETURN NO-APPLY.
      END.
      pZona = COMBO-BOX_Zona.
      pBultos = FILL-IN-Bultos.
      pOk = YES.

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
  DISPLAY COMBO-BOX_Zona FILL-IN-Bultos FILL-IN_FchPed FILL-IN_CodCli 
          FILL-IN_NomCli FILL-IN_Items 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN-Bultos Btn_OK Btn_Cancel 
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
      COMBO-BOX_Zona:DELIMITER = "|".
      COMBO-BOX_Zona:DELETE(1).
      FOR EACH logiszonadist NO-LOCK WHERE logiszonadist.codcia = s-codcia
          AND logiszonadist.coddiv = s-coddiv
          BY logiszonadist.Zona DESC:
          COMBO-BOX_Zona:ADD-LAST(STRING(logiszonadist.Zona) + " - " + logiszonadist.Descripcion, logiszonadist.Zona).
          COMBO-BOX_Zona = logiszonadist.Zona.
      END.

      /* Pintamos Cross Docking */
      FILL-IN_FchPed = OOMoviAlmacen.FchDoc.
      FILL-IN_CodCli = OOMoviAlmacen.AlmFinal.
      FIND Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = OOMoviAlmacen.AlmFinal
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN FILL-IN_NomCli = Almacen.Descripcion.

      FOR EACH b-OOMoviAlmacen NO-LOCK WHERE b-OOMoviAlmacen.CodCia = OOMoviAlmacen.CodCia 
          AND b-OOMoviAlmacen.CodAlm = OOMoviAlmacen.CodAlm 
          AND b-OOMoviAlmacen.TipMov = OOMoviAlmacen.TipMov 
          AND b-OOMoviAlmacen.CodMov = OOMoviAlmacen.CodMov 
          AND b-OOMoviAlmacen.NroSer = OOMoviAlmacen.NroSer 
          AND b-OOMoviAlmacen.NroDoc = OOMoviAlmacen.NroDoc:
          FILL-IN_Items = FILL-IN_Items + 1.
      END.
      /* Solo PR: Picking por Rutas */
      IF pTipo = "PR" THEN COMBO-BOX_Zona:SENSITIVE = YES.
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

