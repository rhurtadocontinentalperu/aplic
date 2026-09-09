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
DEF INPUT  PARAMETER pCodPer AS CHAR.
DEF OUTPUT PARAMETER pCodPed AS CHAR.
DEF OUTPUT PARAMETER pNroPed AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

pEstado = 'ADM-ERROR'.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodPed FILL-IN-NroPed Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-UsrChq x-NomChq COMBO-BOX-CodPed ~
FILL-IN-NroPed FILL-IN-NroRef FILL-IN-Cliente 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-Estado-Orden-ok D-Dialog 
FUNCTION f-Estado-Orden-ok RETURNS LOGICAL
  ( INPUT pCodDoc AS CHAR , INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/error.ico":U
     LABEL "Cancel" 
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/ok.ico":U
     LABEL "OK" 
     SIZE 15 BY 1.73
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-CodPed AS CHARACTER FORMAT "X(256)":U INITIAL "O/D" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "SUB-ORDEN DE DESPACHO","O/D",
                     "SUB-ORDEN DE TRANSFERENCIA","OTR",
                     "SUB-ORDEN MOSTRADOR","O/M",
                     "SUB-ORDEN DESPACHO CONSOLIDADA","ODC",
                     "SUB-ORDEN TRANSFERENCIA CONSOLIDADA","OTC"
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 64 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(256)":U 
     LABEL "# de Sub-Orden" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "X(256)":U 
     LABEL "# Pedido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-UsrChq AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sacador" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 0 FGCOLOR 14 FONT 6 NO-UNDO.

DEFINE VARIABLE x-NomChq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81
     BGCOLOR 0 FGCOLOR 14 FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-UsrChq AT ROW 1.19 COL 13 COLON-ALIGNED WIDGET-ID 8
     x-NomChq AT ROW 1.19 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     COMBO-BOX-CodPed AT ROW 2.15 COL 13 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NroPed AT ROW 3.12 COL 13 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-NroRef AT ROW 4.08 COL 13 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Cliente AT ROW 5.04 COL 13 COLON-ALIGNED WIDGET-ID 12
     Btn_OK AT ROW 6.38 COL 3
     Btn_Cancel AT ROW 6.38 COL 18
     SPACE(50.28) SKIP(0.38)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "ASIGNACION DE TAREA"
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

/* SETTINGS FOR FILL-IN FILL-IN-Cliente IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroRef IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UsrChq IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomChq IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* ASIGNACION DE TAREA */
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
  pEstado = 'ADM-ERROR'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN COMBO-BOX-CodPed FILL-IN-NroPed.
  IF FILL-IN-NroPed = '' THEN DO:
      MESSAGE 'NO ha registrador el número de la sub-orden' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-NroPed.
      RETURN NO-APPLY.
  END.
  pCodPed = COMBO-BOX-CodPed.
  pNroPed = FILL-IN-NroPed.
  pEstado = 'OK'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodPed D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-CodPed IN FRAME D-Dialog /* Documento */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed D-Dialog
ON LEAVE OF FILL-IN-NroPed IN FRAME D-Dialog /* # de Sub-Orden */
OR RETURN OF FILL-IN-NroPed DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE,"'","-").    

    ASSIGN {&SELF-NAME}.    
    IF LENGTH(FILL-IN-NroPed) > 12 THEN DO:
        /* Transformamos el número */
        FIND Facdocum WHERE Facdocum.codcia = s-codcia AND 
            Facdocum.codcta[8] = SUBSTRING(FILL-IN-NroPed,1,3)
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN DO:
            COMBO-BOX-CodPed = Facdocum.coddoc.
            FILL-IN-NroPed = SUBSTRING(FILL-IN-NroPed,4).
            DISPLAY FILL-IN-NroPed COMBO-BOX-CodPed WITH FRAME {&FRAME-NAME}.            
        END.
    END.
    ASSIGN FILL-IN-NroPed COMBO-BOX-CodPed.
    /* Buscamos Sub-Orden */
    FIND Vtacdocu WHERE Vtacdocu.codcia = s-codcia 
        AND Vtacdocu.codped = COMBO-BOX-CodPed
        AND Vtacdocu.nroped = FILL-IN-NroPed
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        MESSAGE 'Sub-Orden NO registrada ' COMBO-BOX-CodPed FILL-IN-NroPed VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF Vtacdocu.flgest = "X" THEN DO:
        MESSAGE 'La Sub-Orden se encuentra CONSOLIDADA' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    /* Ic - Verifica estado de la ORDEN */
    IF f-estado-orden-ok(Vtacdocu.codped, ENTRY(1,Vtacdocu.nroped,"-")) = NO THEN DO:
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.

    /*RD01- Verifica si la sub-orden ya ha sido chequeada*/
    IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'T') THEN DO:
        MESSAGE 'Sub-Orden YA fue cerrada' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF VtaCDocu.UsrImpOd = '' THEN DO:
        MESSAGE 'Sub-Orden aún NO ha sido impresa' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF VtaCDocu.FecSac <> ? THEN DO:
        MESSAGE 'Sub-Orden YA asignada para sacado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF Vtacdocu.DivDes <> s-CodDiv THEN DO:
        MESSAGE "NO tiene almacenes de despacho pertenecientes a esta división"
            VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.

    /* Verificamos que esté bajo el control del supervisor */
    FIND PikSupervisores WHERE PikSupervisores.CodCia = s-codcia
        AND PikSupervisores.CodDiv = s-coddiv
        AND PikSupervisores.Usuario = s-user-id
        NO-LOCK NO-ERROR.
    IF AVAILABLE PikSupervisores THEN DO:
        IF LOOKUP(ENTRY(2,VtaCDocu.nroped,"-"),PikSupervisores.Sector) = 0 THEN DO:
            MESSAGE 'El supervisor NO tiene asignado este sector a su cargo'
                VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = ''.
            RETURN NO-APPLY.
        END.
    END.
    /* Verificamos que el Sacador esté en este sector */
    FIND PikSacadores WHERE PikSacadores.CodCia = s-codcia
        AND PikSacadores.CodDiv = s-coddiv
        AND PikSacadores.CodPer = pCodPer
        AND PikSacadores.FlgEst = "A"   /* ACTIVO */
        NO-LOCK.    
    IF AVAILABLE PikSacadores AND LOOKUP(ENTRY(2,FILL-IN-NroPed,"-"),Piksacadores.sector) = 0 THEN DO:
        MESSAGE 'Pickeador no esta disponible para este SECTOR'
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    ASSIGN
        FILL-IN-Cliente:SCREEN-VALUE = Vtacdocu.codcli + ' ' + Vtacdocu.nomcli
        FILL-IN-NroRef:SCREEN-VALUE = Vtacdocu.nroref.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-UsrChq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-UsrChq D-Dialog
ON LEAVE OF FILL-IN-UsrChq IN FRAME D-Dialog /* Sacador */
OR RETURN OF FILL-IN-UsrChq
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
      SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
      NO-ERROR.

  x-NomCHq:SCREEN-VALUE = "".

  /* Buscar Pikeador LIBRE */
  FIND FIRST piksacadores   WHERE piksacadores.codcia = s-codcia AND 
                                    piksacadores.coddiv = s-coddiv AND 
                                    piksacadores.codper = SELF:SCREEN-VALUE AND 
                                    piksacadores.flgtarea = 'L' AND 
                                    piksacadores.flgest = 'A'
                                    NO-LOCK NO-ERROR.

  IF AVAILABLE piksacadores THEN DO:
      FIND Pl-pers WHERE Pl-pers.codcia = s-codcia 
           AND Pl-pers.codper = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAILABLE Pl-pers THEN x-NomCHq:SCREEN-VALUE = TRIM(Pl-pers.patper) + ' ' +
                                                        TRIM(Pl-pers.matper) + ',' +
                                                        TRIM(PL-pers.nomper).

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-UsrChq D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-UsrChq IN FRAME D-Dialog /* Sacador */
DO:
  ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  RUN pln/c-plnper.
  IF output-var-1 <> ? 
  THEN ASSIGN
            SELF:SCREEN-VALUE = output-var-2
            x-NomChq:SCREEN-VALUE = output-var-3.
  
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
  DISPLAY FILL-IN-UsrChq x-NomChq COMBO-BOX-CodPed FILL-IN-NroPed FILL-IN-NroRef 
          FILL-IN-Cliente 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX-CodPed FILL-IN-NroPed Btn_OK Btn_Cancel 
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
  FIND pl-pers WHERE pl-pers.codcia = s-codcia
      AND pl-pers.codper = pCodPer
      NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN DO:
      FILL-IN-UsrChq = pCodPer.
      x-NomChq = TRIM(pl-pers.patper) + ' ' + TRIM(pl-pers.matper) + ', ' + TRIM(pl-pers.nomper).
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-Estado-Orden-ok D-Dialog 
FUNCTION f-Estado-Orden-ok RETURNS LOGICAL
  ( INPUT pCodDoc AS CHAR , INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
IF pCodDoc = "ODC" THEN RETURN YES.
IF pCodDoc = "OTC" THEN RETURN YES.

 DEFINE VAR lRetVal AS LOG.

 DEFINE BUFFER x-faccpedi FOR faccpedi.

 lRetval = NO.
 FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                            x-faccpedi.coddoc = pCodDoc AND 
                            x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
 IF NOT AVAILABLE x-faccpedi THEN DO:
     MESSAGE pCodDoc + " - " + pNroDoc + " No existe".
 END.
 ELSE DO:
     IF x-faccpedi.flgest = 'A' THEN DO:
         MESSAGE pCodDoc + " - " + pNroDoc + " esta ANULADO".
     END.
     ELSE DO:
         lRetVal = YES.
     END.
 END.
 
 RETURN lRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

