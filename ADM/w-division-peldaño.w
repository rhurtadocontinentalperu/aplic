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
DEFINE SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEFINE VAR x-tabla AS CHAR.

x-tabla = 'GRUPO_DIVGG'.

DEFINE TEMP-TABLE t-w-report LIKE w-report.
DEFINE BUFFER b-gn-divi FOR gn-divi.
DEFINE BUFFER b-factabla FOR factabla.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-division-peldao AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "Actualizar peldaño desde PRICING" 
     SIZE 28 BY 1.12.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 55 BY 3.5 TOOLTIP "Muestra las 6 últimas actualizaciones"
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 17.96 COL 3 WIDGET-ID 2
     EDITOR-1 AT ROW 17.96 COL 31 NO-LABEL WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.86 BY 20.69
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "Division peldaño de precios"
         HEIGHT             = 20.69
         WIDTH              = 108.86
         MAX-HEIGHT         = 20.69
         MAX-WIDTH          = 118.72
         VIRTUAL-HEIGHT     = 20.69
         VIRTUAL-WIDTH      = 118.72
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
/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Division peldaño de precios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Division peldaño de precios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Actualizar peldaño desde PRICING */
DO:
    MESSAGE 'Seguro de Actualizar los peldaños?' VIEW-AS ALERT-BOX QUESTION
           BUTTONS YES-NO UPDATE rpta AS LOG.
   IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE("GENERAL").
RUN actualizar.
SESSION:SET-WAIT-STATE("").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualizar W-Win 
PROCEDURE actualizar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

RUN lib\API_consumo.r PERSISTENT SET hProc.

DEFINE VAR x-api AS LONGCHAR.
DEFINE VAR x-resultado AS LONGCHAR.

/* Procedimientos */
RUN API_tabla IN hProc (INPUT "OFFICE", OUTPUT x-api).

IF TRUE<>(x-api > "") THEN DO:
    DELETE PROCEDURE hProc.
    MESSAGE "NO se pudo ubicar la API para Office" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

DEFINE VAR x-FieldList AS CHAR.
DEFINE VAR x-RetVal AS CHAR.

x-FieldList = "Code,SalesChannel".

x-api = x-api + "&FieldName=" + x-FieldList /* + "&State=1"*/.

RUN API_consumir IN hProc (INPUT x-api, OUTPUT x-resultado).
IF x-resultado BEGINS "ERROR:" THEN DO:
    DELETE PROCEDURE hProc.
    MESSAGE "Hubo problemas al consumir la API" SKIP
          STRING(x-resultado) VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.
IF index(lower(x-resultado),"not content") > 0 THEN DO:
    DELETE PROCEDURE hProc.
    MESSAGE "No existe informacion " VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

/**/
RUN XML-TO-TEMP IN hProc (INPUT x-resultado, INPUT x-FieldList, OUTPUT TABLE t-w-report, OUTPUT x-retval).

DELETE PROCEDURE hProc.

/*x-fields = "Code,SalesChannel".*/
DEFINE VAR x-Position AS CHAR.
DEFINE VAR x-Codigo AS CHAR.

FOR EACH t-w-report:
    x-codigo = t-w-report.campo-c[1].
    x-Position = t-w-report.campo-c[2].
    IF LENGTH(x-Position) = 1 THEN DO:
        x-Position = "0" + x-Position.
    END.
    
    FIND FIRST b-gn-divi WHERE b-gn-divi.codcia = s-codcia AND
                                b-gn-divi.coddiv = x-codigo EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b-gn-divi THEN DO:
        ASSIGN b-gn-divi.grupo_divi_gg = x-position.
    END.

    RELEASE b-gn-divi.    
END.

RUN dispatch IN h_b-division-peldao ('open-query':U).

/* ************************************ */
/* 9-8-2023: SLeon LOG de actualización */
/* ************************************ */
RUN lib/logtabla (INPUT 'GN-DIVI',
                  INPUT '',
                  INPUT 'IMPORT_STEP__PRICING').
RUN Pinta-Log.
/* ************************************ */
/* ************************************ */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualizar-tabla-peldaño W-Win 
PROCEDURE actualizar-tabla-peldaño :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

RUN lib\API_consumo.r PERSISTENT SET hProc.

DEFINE VAR x-api AS LONGCHAR.
DEFINE VAR x-resultado AS LONGCHAR.

/* Procedimientos */
RUN API_tabla IN hProc (INPUT "PELDAÑOS", OUTPUT x-api).

IF TRUE<>(x-api > "") THEN DO:
    DELETE PROCEDURE hProc.
    MESSAGE "NO se pudo ubicar la API para validar el peldaño del articulo" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

DEFINE VAR x-FieldList AS CHAR.
DEFINE VAR x-RetVal AS CHAR.

x-FieldList = "Position,Name,TypeChannel,PartOfThePriceLadder".

x-api = x-api + "&FieldName=" + x-FieldList + "&State=1".

RUN API_consumir IN hProc (INPUT x-api, OUTPUT x-resultado).
IF x-resultado BEGINS "ERROR:" THEN DO:
    DELETE PROCEDURE hProc.
    MESSAGE "Hubo problemas al consumir la API" SKIP
          STRING(x-resultado) VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.
IF index(lower(x-resultado),"not content") > 0 THEN DO:
    DELETE PROCEDURE hProc.
    MESSAGE "No existe informacion " VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

/**/
RUN XML-TO-TEMP IN hProc (INPUT x-resultado, INPUT x-FieldList, OUTPUT TABLE t-w-report, OUTPUT x-retval).

DELETE PROCEDURE hProc.

/*x-fields = "Position,Name,TypeChannel,PartOfThePriceLadder".*/
DEFINE VAR x-Position AS CHAR.
DEFINE VAR x-Name AS CHAR.
DEFINE VAR x-TypeChannel AS CHAR.
DEFINE VAR x-PartOfThePriceLadder AS LOG.

FOR EACH t-w-report:
    x-Position = t-w-report.campo-c[1].
    IF LENGTH(x-Position) = 1 THEN DO:
        x-Position = "0" + x-Position.
    END.

    /* Para syncronizar */
    ASSIGN t-w-report.campo-c[30] = x-Position.

    x-Name = t-w-report.campo-c[2].
    x-PartOfThePriceLadder = NO.
    IF t-w-report.campo-c[4] = "1" THEN DO:
        x-PartOfThePriceLadder =YES.
    END.
    
    FIND FIRST b-factabla WHERE b-factabla.codcia = s-codcia AND
                                b-factabla.tabla = x-Tabla AND
                                b-factabla.codigo = x-position EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE b-factabla THEN DO:
        CREATE b-factabla.
        ASSIGN b-factabla.codcia = s-codcia
                b-factabla.tabla = x-tabla
                b-factabla.codigo = x-position
            .
    END.
    ASSIGN b-factabla.nombre = CAPS(x-name)
            b-factabla.campo-l[1] = x-PartOfThePriceLadder.

    RELEASE b-factabla.    
END.

FOR EACH factabla WHERE factabla.codcia = s-codcia AND
                                factabla.tabla = x-Tabla NO-LOCK:
    FIND FIRST t-w-report WHERE t-w-report.campo-c[30] = factabla.codigo NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-w-report THEN DO:
        FIND FIRST b-factabla WHERE ROWID(b-factabla) = ROWID(factabla) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-factabla THEN DO:
            DELETE b-factabla.
        END.
        RELEASE b-factabla.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
             INPUT  'aplic/adm/b-division-peldaño.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-division-peldao ).
       RUN set-position IN h_b-division-peldao ( 1.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-division-peldao ( 16.54 , 84.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-division-peldao ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'BEFORE':U ).
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
  DISPLAY EDITOR-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Pinta-Log.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Log W-Win 
PROCEDURE Pinta-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i AS INTE NO-UNDO.

EDITOR-1 = "".

FOR EACH LogTabla NO-LOCK WHERE logtabla.codcia = s-codcia AND
    logtabla.Evento = 'IMPORT_STEP__PRICING' AND
    logtabla.Tabla = 'GN-DIVI' AND
    logtabla.ValorLlave = ''
    BY logtabla.Dia DESC BY logtabla.Hora DESC:
    EDITOR-1 = EDITOR-1 +
                " DIA : " + STRING(logtabla.Dia) + " " +
                "HORA : " + logtabla.Hora + " " +
                "USUARIO : " + logtabla.Usuario + CHR(10).
    i = i + 1.
    IF i > 6 THEN LEAVE.
END.
DISPLAY EDITOR-1 WITH FRAME {&FRAME-NAME}.

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

