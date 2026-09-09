&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE BUFFER b-facdpedi FOR facdpedi.

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
&Scoped-Define ENABLED-OBJECTS x-nroped-1 BUTTON-1 x-nroped-2 rs-porigv ~
BUTTON-2 rs-coddoc 
&Scoped-Define DISPLAYED-OBJECTS x-nroped-1 x-nroped-2 rs-porigv rs-coddoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 2" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE x-nroped-1 AS CHARACTER FORMAT "X(9)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-nroped-2 AS CHARACTER FORMAT "X(9)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE rs-coddoc AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pedidos", "PED",
"Facturas", "FAC",
"Boletas", "BOL"
     SIZE 35 BY 1.38 NO-UNDO.

DEFINE VARIABLE rs-porigv AS DECIMAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "18 % ", 18,
"19 % ", 19
     SIZE 19 BY 1.35 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-nroped-1 AT ROW 2.62 COL 17 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 2.88 COL 55 WIDGET-ID 8
     x-nroped-2 AT ROW 3.69 COL 17 COLON-ALIGNED WIDGET-ID 16
     rs-porigv AT ROW 5.04 COL 14 NO-LABEL WIDGET-ID 12
     BUTTON-2 AT ROW 5.04 COL 55 WIDGET-ID 10
     rs-coddoc AT ROW 6.42 COL 14 NO-LABEL WIDGET-ID 20
     "Rango de Documentos" VIEW-AS TEXT
          SIZE 22 BY .88 AT ROW 1.54 COL 8 WIDGET-ID 18
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72 BY 8.35 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Actualiza IGV"
         HEIGHT             = 8.35
         WIDTH              = 72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 83.72
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 83.72
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
ON END-ERROR OF W-Win /* Actualiza IGV */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Actualiza IGV */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN x-nroped-1 x-nroped-2 rs-porigv rs-coddoc.
    
    CASE rs-coddoc:
        WHEN 'PED' THEN RUN Recalcula-IGV-Ped.
        WHEN 'FAC' THEN RUN Recalcula-IGV-Fac.
        WHEN 'BOL' THEN RUN Recalcula-IGV-Fac.
    END CASE.
    
    MESSAGE '!!Actualizacion Finalizada!!'
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
  
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
  DISPLAY x-nroped-1 x-nroped-2 rs-porigv rs-coddoc 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-nroped-1 BUTTON-1 x-nroped-2 rs-porigv BUTTON-2 rs-coddoc 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcula-IGV-Fac W-Win 
PROCEDURE Recalcula-IGV-Fac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lRet AS LOGICAL     NO-UNDO .
            
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddiv = s-coddiv
        AND ccbcdocu.coddoc = rs-coddoc
        AND ccbcdocu.nrodoc >= x-nroped-1
        AND ccbcdocu.nrodoc <= x-nroped-2 :

        IF ccbcdocu.flgest = 'A' THEN DO:
            MESSAGE 'Documento ' + ccbcdocu.nrodoc  + ' se encuentra Anulado'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            NEXT.
        END.

        lRet = NO.
        /*Valida Fechas*/
        CASE rs-porigv:
            WHEN 19.00 THEN IF ccbcdocu.fchdoc >= 03/01/2011 THEN lRet = YES.
            WHEN 18.00 THEN IF ccbcdocu.fchdoc < 03/01/2011 THEN lRet = YES.
        END CASE.
        IF lRet THEN DO:
            MESSAGE 
                '    % IGV Incorrecto para este Documento    ' SKIP
                'Documento ' + faccpedi.nroped + ' no se podra actualizar'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.        
            NEXT.
        END.
        
        /*Recalcula igv detalle*/
        FOR EACH ccbddocu OF ccbcdocu:
            IF ccbddocu.AftIgv THEN
                ccbddocu.ImpIgv = ccbddocu.ImpLin - 
                    ROUND( ccbddocu.ImpLin  / ( 1 + (rs-porigv / 100) ), 4 ).
        END.
        ASSIGN ccbcdocu.PorIgv = rs-porigv.
        
        {vta/graba-totales-fac.i}
        f-igv = 0.
        f-isc = 0.
    
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcula-IGV-Ped W-Win 
PROCEDURE Recalcula-IGV-Ped :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
DEFINE VARIABLE lRet  AS LOGICAL NO-UNDO INIT NO.

FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
    AND faccpedi.coddiv = s-coddiv
    AND faccpedi.coddoc = rs-coddoc
    AND faccpedi.nroped >= x-nroped-1
    AND faccpedi.nroped <= x-nroped-2
    AND faccpedi.flgest <> 'A' EXCLUSIVE-LOCK:

    IF faccpedi.flgest = 'F' THEN DO:
        MESSAGE 'Documento ' + faccpedi.nroped + ' ya fue facturado' SKIP
                '        Corregir Factura    '
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        NEXT.
    END.
    
    lRet = NO.
    /*Valida Fechas*/
    CASE rs-porigv:
        WHEN 19.00 THEN IF faccpedi.fchped >= 03/01/2011 THEN lRet = YES.
        WHEN 18.00 THEN IF faccpedi.fchped < 03/01/2011 THEN lRet = YES.
    END CASE.
    IF lRet THEN DO:
        MESSAGE 
            '    % IGV Incorrecto para este Documento    ' SKIP
            'Documento ' + faccpedi.nroped + ' no se podra actualizar'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.        
        NEXT.
    END.
    /*Recalcula igv detalle*/
    FOR EACH b-facdpedi OF faccpedi:
        IF b-facdpedi.AftIgv THEN
            b-facdpedi.ImpIgv = b-facdpedi.ImpLin - 
                ROUND( b-facdpedi.ImpLin  / ( 1 + (rs-PorIgv / 100) ), 4 ).
    END.

    ASSIGN
        FacCPedi.ImpDto = 0
        FacCPedi.ImpIgv = 0
        FacCPedi.ImpIsc = 0
        FacCPedi.ImpTot = 0
        FacCPedi.ImpExo = 0.
     
    F-Igv = 0.
    F-Isc = 0.
    FOR EACH FacDPedi OF FacCPedi NO-LOCK: 
        ASSIGN
            F-Igv = F-Igv + Facdpedi.ImpIgv
            F-Isc = F-Isc + Facdpedi.ImpIsc
            FacCPedi.ImpTot = FacCPedi.ImpTot + Facdpedi.ImpLin.
        IF NOT Facdpedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + Facdpedi.ImpLin.
        IF Facdpedi.AftIgv = YES
        THEN FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(Facdpedi.ImpDto / (1 + rs-PorIgv / 100), 2).
        ELSE FacCPedi.ImpDto = FacCPedi.ImpDto + Facdpedi.ImpDto.
    END.
    ASSIGN
        FacCPedi.PorIgv = rs-porigv
        FacCPedi.ImpIgv = ROUND(F-IGV,2)
        FacCPedi.ImpIsc = ROUND(F-ISC,2)
        FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv.
    /* RHC 22.12.06 */
    IF FacCPedi.PorDto > 0 THEN DO:
        FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND((FacCPedi.ImpVta + FacCPedi.ImpExo) * FacCPedi.PorDto / 100, 2).
        FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2).
        FacCPedi.ImpVta = ROUND(FacCPedi.ImpVta * (1 - FacCPedi.PorDto / 100),2).
        FacCPedi.ImpExo = ROUND(FacCPedi.ImpExo * (1 - FacCPedi.PorDto / 100),2).
        FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpVta.
    END.  
    FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpIsc + FacCPedi.ImpDto + FacCPedi.ImpExo.

END.



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

