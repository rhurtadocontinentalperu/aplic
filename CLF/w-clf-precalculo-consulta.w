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

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(60)" .

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
    SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
    SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

DEFINE TEMP-TABLE tclf_calculo NO-UNDO
    FIELD codmat                   LIKE Clf_Temp_Calculos.codmat
    FIELD descripcion              LIKE Clf_Temp_Calculos.descripcion      
    FIELD marca                    LIKE Clf_Temp_Calculos.marca            
    FIELD undstk                   LIKE Clf_Temp_Calculos.undstk   
    FIELD CtgCtble                 LIKE Clf_Temp_Calculos.CtgCtble
    FIELD ventas                   LIKE Clf_Temp_Calculos.ventas           
    FIELD utilidad                 LIKE Clf_Temp_Calculos.utilidad         
    FIELD cantidad_act             LIKE Clf_Temp_Calculos.cantidad_act     
    FIELD importe_act              LIKE Clf_Temp_Calculos.importe_act      
    FIELD cantidad_ant             LIKE Clf_Temp_Calculos.cantidad_ant     
    FIELD importe_ant              LIKE Clf_Temp_Calculos.importe_ant      
    FIELD cantidad                 LIKE Clf_Temp_Calculos.cantidad         
    FIELD importe                  LIKE Clf_Temp_Calculos.importe          
    FIELD puntajeventas            LIKE Clf_Temp_Calculos.puntajeventas    
    FIELD puntajeutilidad          LIKE Clf_Temp_Calculos.puntajeutilidad  
    FIELD puntajecantidad          LIKE Clf_Temp_Calculos.puntajecantidad  
    FIELD puntajeimporte           LIKE Clf_Temp_Calculos.puntajeimporte   
    FIELD sumapuntaje              LIKE Clf_Temp_Calculos.sumapuntaje      
    FIELD pesoventas               LIKE Clf_Temp_Calculos.pesoventas       
    FIELD pesoutilidad             LIKE Clf_Temp_Calculos.pesoutilidad     
    FIELD pesocantidad             LIKE Clf_Temp_Calculos.pesocantidad     
    FIELD pesoimporte              LIKE Clf_Temp_Calculos.pesoimporte      
    FIELD pesoacumulado            LIKE Clf_Temp_Calculos.pesoacumulado    
    FIELD pesopuntajefinal         LIKE Clf_Temp_Calculos.pesopuntajefinal 
    FIELD clasificacion            LIKE Clf_Temp_Calculos.clasificacion    
    FIELD Origen                   LIKE Clf_Temp_Calculos.Origen           
    .

DEF NEW SHARED VAR lh_handle AS HANDLE.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-Excel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-clf_temp_calculos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-Clf_Temp_Parameters AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-Clf_Temp_Parameters AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6.29 BY 1.65 TOOLTIP "Exportar a EXCEL".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Excel AT ROW 8.27 COL 186 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.15 WIDGET-ID 100.


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
         TITLE              = "CONSULTA DEL PRE-CALCULO"
         HEIGHT             = 26.15
         WIDTH              = 191.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
ON END-ERROR OF W-Win /* CONSULTA DEL PRE-CALCULO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DEL PRE-CALCULO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel W-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* Button 1 */
DO:
  DEF VAR pRowid AS ROWID NO-UNDO.

  RUN Capture-Rowid IN h_b-Clf_Temp_Parameters
    ( OUTPUT pRowid /* ROWID */).

  IF pRowid = ? THEN DO:
      MESSAGE 'NO hay información a exportar' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  RUN Export-Excel (INPUT pRowid).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

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
             INPUT  'CLF/b-Clf_Temp_Parameters.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-Clf_Temp_Parameters ).
       RUN set-position IN h_b-Clf_Temp_Parameters ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-Clf_Temp_Parameters ( 6.69 , 163.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'CLF/v-Clf_Temp_Parameters.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-Clf_Temp_Parameters ).
       RUN set-position IN h_v-Clf_Temp_Parameters ( 1.00 , 165.00 ) NO-ERROR.
       /* Size in UIB:  ( 6.73 , 27.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/clf/b-clf_temp_calculos.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-clf_temp_calculos ).
       RUN set-position IN h_b-clf_temp_calculos ( 8.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-clf_temp_calculos ( 16.96 , 184.00 ) NO-ERROR.

       /* Links to SmartViewer h_v-Clf_Temp_Parameters. */
       RUN add-link IN adm-broker-hdl ( h_b-Clf_Temp_Parameters , 'Record':U , h_v-Clf_Temp_Parameters ).

       /* Links to SmartBrowser h_b-clf_temp_calculos. */
       RUN add-link IN adm-broker-hdl ( h_b-Clf_Temp_Parameters , 'Record':U , h_b-clf_temp_calculos ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-Clf_Temp_Parameters ,
             BUTTON-Excel:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-Clf_Temp_Parameters ,
             h_b-Clf_Temp_Parameters , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-clf_temp_calculos ,
             h_v-Clf_Temp_Parameters , 'AFTER':U ).
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
  ENABLE BUTTON-Excel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Export-Excel W-Win 
PROCEDURE Export-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.

FIND Clf_Temp_Parameters WHERE ROWID(Clf_Temp_Parameters) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Clf_Temp_Parameters THEN RETURN.

DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR NO-UNDO.
DEF VAR rpta AS LOG NO-UNDO.

c-xls-file = "PruebaClasificacion" + " " +
    Clf_Temp_Parameters.Descripcion + " " +
    Clf_Temp_Parameters.Codigo + " " +
    Clf_Temp_Parameters.Tipo_Calculo + 
    ".xlsx"
    .
c-xls-file = REPLACE(c-xls-file," ","_").

SYSTEM-DIALOG GET-FILE 
    c-xls-file  
    FILTERS "Excel (*.xlsx)" "*.xlsx"
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION "*.xlsx"
    SAVE-AS
    TITLE "Defina el archivo de salida"
    USE-FILENAME
    UPDATE rpta
    .
IF rpta = NO THEN RETURN.

DISPLAY "PREPARANDO INFORMACION" @ Fi-Mensaje WITH FRAME F-Proceso.
EMPTY TEMP-TABLE tclf_calculo.
FOR EACH Clf_Temp_Calculos WHERE Clf_Temp_Calculos.Id_Agrupador = Clf_Temp_Parameters.Id_Agrupador
    AND Clf_Temp_Calculos.Id_Periodo = Clf_Temp_Parameters.Id_Periodo NO-LOCK
    BY Clf_Temp_Calculos.CodMat:
    CREATE tclf_calculo.
    BUFFER-COPY Clf_Temp_Calculos TO tclf_calculo NO-ERROR.
END.
HIDE FRAME F-Proceso.

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN lib\Tools-to-excel PERSISTENT SET hProc.

DISPLAY "EXPORTANDO A EXCEL" @ Fi-Mensaje WITH FRAME F-Proceso.
RUN pi-crea-archivo-csv IN hProc (
    INPUT  BUFFER tclf_calculo:HANDLE,
    INPUT c-xls-file,
    OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls  IN hProc (
    INPUT  BUFFER tclf_calculo:HANDLE,
    INPUT  c-csv-file,
    OUTPUT c-xls-file) .

DELETE PROCEDURE hProc.
HIDE FRAME F-Proceso.

MESSAGE 'Exportar Exitosa' VIEW-AS ALERT-BOX INFORMATION.

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

