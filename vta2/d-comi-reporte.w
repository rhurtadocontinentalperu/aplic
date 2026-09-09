&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEF SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEF INPUT PARAMETER pDivisiones AS CHAR.
DEF INPUT PARAMETER pDesde AS DATE.
DEF INPUT PARAMETER pHasta AS DATE.

DEFINE TEMP-TABLE Detalle LIKE ComiDetail.

{lib/tt-file.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ComiConfig

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define QUERY-STRING-D-Dialog FOR EACH ComiConfig SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH ComiConfig SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog ComiConfig
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog ComiConfig


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-27 EDITOR_Divisiones BUTTON-1 ~
FILL-IN_Desde FILL-IN_Hasta COMBO-BOX-CanalVenta Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS EDITOR_Divisiones FILL-IN_Desde ~
FILL-IN_Hasta COMBO-BOX-CanalVenta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Cancel" 
     SIZE 8 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "OK" 
     SIZE 9 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE COMBO-BOX-CanalVenta AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Canal de Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR_Divisiones AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 50 BY 5.19.

DEFINE VARIABLE FILL-IN_Desde AS DATE FORMAT "99/99/9999" 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81.

DEFINE VARIABLE FILL-IN_Hasta AS DATE FORMAT "99/99/9999" 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 8.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      ComiConfig SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     EDITOR_Divisiones AT ROW 2.15 COL 17 NO-LABEL WIDGET-ID 16
     BUTTON-1 AT ROW 2.15 COL 68 WIDGET-ID 24
     FILL-IN_Desde AT ROW 7.54 COL 15 COLON-ALIGNED WIDGET-ID 20
     FILL-IN_Hasta AT ROW 7.54 COL 40 COLON-ALIGNED WIDGET-ID 22
     COMBO-BOX-CanalVenta AT ROW 8.5 COL 15 COLON-ALIGNED WIDGET-ID 30
     Btn_OK AT ROW 10.04 COL 2
     Btn_Cancel AT ROW 10.04 COL 11
     "Filtros" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.19 COL 3 WIDGET-ID 26
          BGCOLOR 9 FGCOLOR 15 
     "Divisiones:" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 2.35 COL 6 WIDGET-ID 28
     RECT-27 AT ROW 1.38 COL 2 WIDGET-ID 32
     SPACE(0.85) SKIP(2.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "REPORTE DE COMISIONES"
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.ComiConfig"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* REPORTE DE COMISIONES */
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

    ASSIGN
         COMBO-BOX-CanalVenta EDITOR_Divisiones FILL-IN_Desde FILL-IN_Hasta.
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.
    DEF VAR zArchivo AS CHAR.
    DEF VAR cComando AS CHAR.
    DEF VAR pDirectorio AS CHAR.
    DEF VAR lOptions AS CHAR.

    DEFINE VAR lFldHandle AS HANDLE.
    
    lFldHandle = CanalVentaDiv:HANDLE IN BUFFER Detalle.
    
    lFldHandle:LABEL = "CanalVtaDiv.".
    
    RUN lib/tt-file-to-text-7zip (OUTPUT pOptions, OUTPUT pArchivo, OUTPUT pDirectorio).
    IF pOptions = "" THEN RETURN.

        SESSION:SET-WAIT-STATE('GENERAL').
        IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
        RUN Carga-Temporal.
        SESSION:DATE-FORMAT = "dmy".
        SESSION:SET-WAIT-STATE('').

        FIND FIRST Detalle NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle THEN DO:
            MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
            RETURN.
        END.

        pOptions = pOptions + CHR(1) + "SkipList:CodCia".
        /* El archivo se va a generar en un archivo temporal de trabajo antes 
        de enviarlo a su directorio destino */
        pArchivo = REPLACE(pArchivo, '.', STRING(RANDOM(1,9999), '9999') + ".").
        cArchivo = LC(SESSION:TEMP-DIRECTORY + pArchivo).
        SESSION:SET-WAIT-STATE('GENERAL').
        IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
        RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
        SESSION:DATE-FORMAT = "dmy".
        SESSION:SET-WAIT-STATE('').
        /* Secuencia de comandos para encriptar el archivo con 7zip */
        IF INDEX(cArchivo, ".xls") > 0 THEN zArchivo = REPLACE(cArchivo, ".xls", ".zip").
        IF INDEX(cArchivo, ".txt") > 0 THEN zArchivo = REPLACE(cArchivo, ".txt", ".zip").
        cComando = '"C:\Archivos de programa\7-Zip\7z.exe" a ' + zArchivo + ' ' + cArchivo.
        OS-COMMAND 
            SILENT 
            VALUE ( cComando ).
        IF SEARCH(zArchivo) = ? THEN DO:
            MESSAGE 'NO se pudo encriptar el archivo' SKIP
                'Avise a sistemas'
                VIEW-AS ALERT-BOX ERROR.
            RETURN.
        END.
        OS-DELETE VALUE(cArchivo).

        IF INDEX(cArchivo, '.xls') > 0 THEN cArchivo = REPLACE(pArchivo, ".xls", ".zip").
        IF INDEX(cArchivo, '.txt') > 0 THEN cArchivo = REPLACE(pArchivo, ".txt", ".zip").
        cComando = "copy " + zArchivo + ' ' + TRIM(pDirectorio) + TRIM(cArchivo).
        OS-COMMAND 
            SILENT 
            /*NO-WAIT */
            /*NO-CONSOLE */
            VALUE(cComando).
        OS-DELETE VALUE(zArchivo).
        /* ******************************************************* */

        MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = EDITOR_Divisiones:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  EDITOR_Divisiones:SCREEN-VALUE = x-Divisiones.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

FOR EACH ComiDetail NO-LOCK WHERE ComiDetail.CodCia = s-codcia
    AND LOOKUP(ENTRY(1,ComiDetail.CodDiv,' - '), EDITOR_Divisiones) > 0
    AND ComiDetail.FchDoc >= FILL-IN_Desde 
    AND ComiDetail.FchDoc <= FILL-IN_Hasta
    AND (COMBO-BOX-CanalVenta = 'Todos' OR ComiDetail.CanalVenta = COMBO-BOX-CanalVenta):
    CREATE Detalle.
    BUFFER-COPY ComiDetail TO Detalle.
END.

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
  DISPLAY EDITOR_Divisiones FILL-IN_Desde FILL-IN_Hasta COMBO-BOX-CanalVenta 
      WITH FRAME D-Dialog.
  ENABLE RECT-27 EDITOR_Divisiones BUTTON-1 FILL-IN_Desde FILL-IN_Hasta 
         COMBO-BOX-CanalVenta Btn_OK Btn_Cancel 
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
  ASSIGN
      EDITOR_Divisiones = pDivisiones
      FILL-IN_Desde = pDesde
      FILL-IN_Hasta = pHasta.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Vtamcanal NO-LOCK WHERE Vtamcanal.Codcia = s-codcia:
          COMBO-BOX-CanalVenta:ADD-LAST(Vtamcanal.CanalVenta + ' - ' + Vtamcanal.Descrip, Vtamcanal.CanalVenta).
      END.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ComiConfig"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

