&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttFacDPedi NO-UNDO LIKE FacDPedi.



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
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroPed AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR x-cantidad-x-atender AS DEC.

DEFINE VAR x-cotizacion AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-7

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttFacDPedi Almmmatg

/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 ttFacDPedi.codmat Almmmatg.DesMat ~
Almmmatg.DesMar ttFacDPedi.CanPed ttFacDPedi.canate ~
(ttfacdpedi.canped - ttfacdpedi.canate) @ x-cantidad-x-atender 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH ttFacDPedi NO-LOCK, ~
      FIRST Almmmatg OF ttFacDPedi NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH ttFacDPedi NO-LOCK, ~
      FIRST Almmmatg OF ttFacDPedi NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 ttFacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 ttFacDPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-7 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel BROWSE-7 Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-nro-pco FILL-IN-cotizacion ~
FILL-IN-CodCLie FILL-IN-nomcli 

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

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Adicionar Items Seleccionados" 
     SIZE 29.14 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-CodCLie AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-cotizacion AS CHARACTER FORMAT "X(15)":U 
     LABEL "Nro de Cotizacion" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1
     FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-nomcli AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-nro-pco AS CHARACTER FORMAT "X(15)":U 
     LABEL "Nro. de PCO" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-7 FOR 
      ttFacDPedi, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 D-Dialog _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      ttFacDPedi.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U
      Almmmatg.DesMat COLUMN-LABEL "Articulo" FORMAT "X(45)":U
            WIDTH 36.86
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 23.29
      ttFacDPedi.CanPed COLUMN-LABEL "Cotizado" FORMAT ">,>>>,>>9.9999":U
      ttFacDPedi.canate COLUMN-LABEL "Atendido" FORMAT ">,>>>,>>9.9999":U
      (ttfacdpedi.canped - ttfacdpedi.canate) @ x-cantidad-x-atender COLUMN-LABEL "x Atender" FORMAT "->>,>>>,>>9.99":U
            WIDTH 11.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 115 BY 20.77 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-nro-pco AT ROW 1.19 COL 16 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-cotizacion AT ROW 1.19 COL 56 COLON-ALIGNED WIDGET-ID 4
     Btn_OK AT ROW 1.19 COL 108.29
     FILL-IN-CodCLie AT ROW 2.42 COL 16 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-nomcli AT ROW 2.42 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Btn_Cancel AT ROW 2.62 COL 121
     BROWSE-7 AT ROW 3.85 COL 3 WIDGET-ID 200
     Btn_Help AT ROW 4.62 COL 121
     SPACE(4.56) SKIP(19.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Validacion y verificacion, adicion de Items"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttFacDPedi T "?" NO-UNDO INTEGRAL FacDPedi
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
/* BROWSE-TAB BROWSE-7 Btn_Cancel D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodCLie IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-cotizacion IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nomcli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nro-pco IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.ttFacDPedi,INTEGRAL.Almmmatg OF Temp-Tables.ttFacDPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > Temp-Tables.ttFacDPedi.codmat
"ttFacDPedi.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "36.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "23.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttFacDPedi.CanPed
"ttFacDPedi.CanPed" "Cotizado" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttFacDPedi.canate
"ttFacDPedi.canate" "Atendido" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"(ttfacdpedi.canped - ttfacdpedi.canate) @ x-cantidad-x-atender" "x Atender" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Validacion y verificacion, adicion de Items */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Adicionar Items Seleccionados */
DO:
  RUN adicionar-items.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adicionar-items D-Dialog 
PROCEDURE adicionar-items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-items AS INT INIT 0.
DEFINE VAR x-Items-ok AS INT INIT 0.
DEFINE VAR x-sec AS INT INIT 0.

DEFINE VAR x-codmat AS CHAR.
DEFINE VAR x-nroped AS CHAR.
DEFINE VAR x-msgerror AS CHAR.

DEFINE VAR x-canped AS DEC.
DEFINE VAR x-canate AS DEC.

DEFINE BUFFER b-facdpedi FOR facdpedi.

DO WITH FRAME {&FRAME-NAME}:
    x-items = browse-7:NUM-SELECTED-ROWS.

    IF x-items < 1 THEN DO:
        MESSAGE "Debe seleccionar al menos 1 a mas Items".
        RETURN.
    END.
    MESSAGE 'Seguro de Adicionar los ' + STRING(x-items) + ' Item(es) ?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN.

   DO TRANSACTION ON ERROR UNDO, LEAVE:
        DO x-sec = 1 TO x-items:
            IF browse-7:FETCH-SELECTED-ROW(x-sec) THEN DO:
                x-codmat = {&FIRST-TABLE-IN-QUERY-browse-7}.codmat.
                x-canped = {&FIRST-TABLE-IN-QUERY-browse-7}.canped.
                x-canate = {&FIRST-TABLE-IN-QUERY-browse-7}.canate.
                IF (x-canped - x-canate) > 0 THEN DO:
                    /* Busco el item en cotizacion */
                    FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND
                                                facdpedi.coddoc = 'COT' AND
                                                facdpedi.nroped = x-cotizacion AND 
                                                facdpedi.codmat = x-codmat EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE facdpedi THEN DO:
                        ASSIGN facdpedi.canate = facdpedi.canate + (x-canped - x-canate).
                        /**/
                        CREATE b-facdpedi.
                        BUFFER-COPY facdpedi EXCEPT coddoc nroped TO b-facdpedi.
                        ASSIGN  b-facdpedi.coddoc = pCodDoc
                                b-facdpedi.nroped = pNroPed
                                b-facdpedi.libre_d05 = facdpedi.canped
                                b-facdpedi.canped = (x-canped - x-canate).

                        x-Items-ok = x-Items-ok + 1.
                    END.
                END.
            END.
        END.
   END.
    MESSAGE "Se procesaron " + STRING(x-items-ok) + " de " + 
        STRING(x-items) + " items seleecionadas".

END.


END PROCEDURE.
/*
    x-proceso-ok = NO.
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        CREATE b-faccpedi.
        BUFFER-COPY faccpedi EXCEPT coddoc nroped TO b-faccpedi.

        x-nroped = faccpedi.nroped + "-" + STRING(x-corre).
        ASSIGN b-faccpedi.coddoc = 'PCO'
                b-faccpedi.nroped = x-nroped
                b-faccpedi.codref = faccpedi.coddoc
                b-faccpedi.nroref = faccpedi.nroped
                b-faccpedi.fchped = TODAY
                b-faccpedi.fchent = txtFechaEntrega
                b-faccpedi.libre_f01 = txtEntregaTentativa  /* abastecimiento */
                b-faccpedi.libre_f02 = txtFechaTope   /* fecha tope */
                b-faccpedi.hora = STRING(TIME,"HH:MM:SS")
                b-faccpedi.usuario = s-user-id                
                b-faccpedi.flgest  = 'G'.

        FOR EACH ttfacdpedi WHERE ttfacdpedi.cansol > 0 ON ERROR UNDO, THROW:
            FIND FIRST facdpedi WHERE facdpedi.codcia = ttfacdpedi.codcia AND
                                        facdpedi.coddoc = faccpedi.coddoc AND
                                        facdpedi.nroped = faccpedi.nroped AND 
                                        facdpedi.codmat = ttfacdpedi.codmat EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE facdpedi THEN DO:
                ASSIGN facdpedi.canate = facdpedi.canate + ttfacdpedi.cansol.
                /**/
                CREATE b-facdpedi.
                BUFFER-COPY ttfacdpedi EXCEPT coddoc nroped TO b-facdpedi.
                ASSIGN  b-facdpedi.coddoc = b-faccpedi.coddoc
                        b-facdpedi.nroped = b-faccpedi.nroped
                        b-facdpedi.libre_d05 = ttfacdpedi.canped
                        b-facdpedi.canped = ttfacdpedi.cansol.
            END.
        END.
        x-proceso-ok = YES.
    END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-info D-Dialog 
PROCEDURE cargar-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ttfacdpedi.

DEFINE BUFFER x-faccpedi FOR faccpedi.           
DEFINE BUFFER x-facdpedi FOR facdpedi.
           
/* Busco la PCO */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                            faccpedi.coddoc = pCodDoc AND
                            faccpedi.nroped = pNroPed NO-LOCK NO-ERROR.
                  
IF NOT AVAILABLE faccpedi THEN RETURN.

/* Ubnico la Cotizacion */
FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                            x-faccpedi.coddoc = faccpedi.codref AND 
                            x-faccpedi.nroped = faccpedi.nroref AND
                            x-faccpedi.flgest <> 'A'
                            NO-LOCK NO-ERROR.

IF NOT AVAILABLE x-faccpedi THEN RETURN.

x-cotizacion = faccpedi.nroref.

SESSION:SET-WAIT-STATE("GENERAL").

FILL-IN-nro-pco:SCREEN-VALUE IN FRAME {&FRAME-NAME} = faccpedi.nroped.
FILL-IN-cotizacion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-faccpedi.nroped.
FILL-IN-codclie:SCREEN-VALUE IN FRAME {&FRAME-NAME} = faccpedi.codcli.
FILL-IN-nomcli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = faccpedi.nomcli.

FOR EACH x-facdpedi OF x-faccpedi NO-LOCK:
    /* Buscar que NO exista en la PCO  */
    FIND FIRST facdpedi OF faccpedi WHERE facdpedi.codmat = x-facdpedi.codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE facdpedi THEN DO:
        CREATE ttfacdpedi.
        BUFFER-COPY x-facdpedi TO ttfacdpedi.
    END.
END.

SESSION:SET-WAIT-STATE("").

{&OPEN-QUERY-BROWSE-7}

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
  DISPLAY FILL-IN-nro-pco FILL-IN-cotizacion FILL-IN-CodCLie FILL-IN-nomcli 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK Btn_Cancel BROWSE-7 Btn_Help 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN cargar-info.

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
  {src/adm/template/snd-list.i "ttFacDPedi"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

