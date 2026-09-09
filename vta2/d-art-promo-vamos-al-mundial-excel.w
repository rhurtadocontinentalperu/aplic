&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-VtaTabla NO-UNDO LIKE VtaTabla.



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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-VtaTabla Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-VtaTabla.Llave_c1 ~
Almmmatg.DesMat tt-VtaTabla.Valor[1] tt-VtaTabla.Valor[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-VtaTabla NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = s-codcia and ~
 Almmmatg.codmat =  tt-VtaTabla.Llave_c1 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-VtaTabla NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = s-codcia and ~
 Almmmatg.codmat =  tt-VtaTabla.Llave_c1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-VtaTabla Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-VtaTabla
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 BUTTON-3 ~
Btn_Cancel Btn_Help BROWSE-2 Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 ~
FILL-IN-7 FILL-IN-10 FILL-IN-5 FILL-IN-8 FILL-IN-11 FILL-IN-6 FILL-IN-9 ~
FILL-IN-12 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDialogCues" D-Dialog _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartDialog,ab,49267
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
     LABEL "Grabar" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     LABEL "Excel" 
     SIZE 14.72 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "  CODIGO" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-10 AS CHARACTER FORMAT "X(256)":U INITIAL "     1.00" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-11 AS CHARACTER FORMAT "X(256)":U INITIAL "     1.00" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-12 AS CHARACTER FORMAT "X(256)":U INITIAL "     10.00" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U INITIAL "  VALOR S/" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U INITIAL "  PUNTOS" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U INITIAL "053151" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U INITIAL "002907" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U INITIAL "000994" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS CHARACTER FORMAT "X(256)":U INITIAL "      3.5" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS CHARACTER FORMAT "X(256)":U INITIAL "     10.00" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE VARIABLE FILL-IN-9 AS CHARACTER FORMAT "X(256)":U INITIAL "     3.5" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.29 BY 7.12.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14 BY 7.12.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14 BY 7.12.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.29 BY 1.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-VtaTabla, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-VtaTabla.Llave_c1 COLUMN-LABEL "CODIGO" FORMAT "x(8)":U
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 27.86
      tt-VtaTabla.Valor[1] COLUMN-LABEL "VALOR S/" FORMAT "->>,>>9.99":U
            WIDTH 10.43
      tt-VtaTabla.Valor[2] COLUMN-LABEL "PUNTOS" FORMAT "->>,>>9.99":U
            WIDTH 14.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 67 BY 12.12 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-1 AT ROW 1.54 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-2 AT ROW 1.54 COL 14.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-3 AT ROW 1.54 COL 28.57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     BUTTON-3 AT ROW 1.58 COL 48.29 WIDGET-ID 38
     Btn_Cancel AT ROW 2.81 COL 48
     FILL-IN-4 AT ROW 2.88 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-7 AT ROW 2.88 COL 15.14 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-10 AT ROW 2.88 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-5 AT ROW 3.65 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     FILL-IN-8 AT ROW 3.65 COL 15.14 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-11 AT ROW 3.65 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-6 AT ROW 4.42 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-9 AT ROW 4.42 COL 15.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-12 AT ROW 4.42 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     Btn_Help AT ROW 4.81 COL 48
     BROWSE-2 AT ROW 8.88 COL 4 WIDGET-ID 200
     Btn_OK AT ROW 21.23 COL 53
     "tener el Excel, para la carga" VIEW-AS TEXT
          SIZE 38 BY 1.04 AT ROW 6.88 COL 4.29 WIDGET-ID 36
          FGCOLOR 9 FONT 11
     "Este es el formato que debe" VIEW-AS TEXT
          SIZE 38 BY .62 AT ROW 6.19 COL 4.29 WIDGET-ID 34
          FGCOLOR 9 FONT 11
     RECT-1 AT ROW 1.38 COL 3 WIDGET-ID 2
     RECT-2 AT ROW 1.38 COL 15.72 WIDGET-ID 4
     RECT-3 AT ROW 1.38 COL 29.29 WIDGET-ID 6
     RECT-4 AT ROW 1.38 COL 3 WIDGET-ID 8
     SPACE(29.84) SKIP(19.95)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Vamos al Mundial - Excel"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-VtaTabla T "?" NO-UNDO INTEGRAL VtaTabla
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
/* BROWSE-TAB BROWSE-2 Btn_Help D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-11 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-12 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-VtaTabla,INTEGRAL.Almmmatg WHERE Temp-Tables.tt-VtaTabla ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.CodCia = s-codcia and
 INTEGRAL.Almmmatg.codmat =  Temp-Tables.tt-VtaTabla.Llave_c1"
     _FldNameList[1]   > Temp-Tables.tt-VtaTabla.Llave_c1
"Temp-Tables.tt-VtaTabla.Llave_c1" "CODIGO" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "27.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-VtaTabla.Valor[1]
"Temp-Tables.tt-VtaTabla.Valor[1]" "VALOR S/" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-VtaTabla.Valor[2]
"Temp-Tables.tt-VtaTabla.Valor[2]" "PUNTOS" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Vamos al Mundial - Excel */
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
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Grabar */
DO:
  	MESSAGE 'Deseas GRABAR los articulos?' VIEW-AS ALERT-BOX QUESTION
	        BUTTONS YES-NO UPDATE rpta AS LOG.
	IF rpta = NO THEN RETURN NO-APPLY.

    DEFINE BUFFER z-vtatabla FOR vtatabla.

    SESSION:SET-WAIT-STAT("GENERAL").

    FOR EACH tt-vtatabla :

        FIND FIRST z-vtatabla WHERE z-vtatabla.codcia = s-codcia AND 
                                    z-vtatabla.tabla = 'VAMOS_AL_MUNDIAL' AND
                                    z-vtatabla.llave_c1 = tt-vtatabla.llave_c1 EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE z-vtatabla THEN DO:
            CREATE z-vtatabla.
                    ASSIGN z-vtatabla.codcia = s-codcia
                                z-vtatabla.tabla = 'VAMOS_AL_MUNDIAL'
                                z-vtatabla.llave_c1 = tt-vtatabla.llave_c1
                                z-vtatabla.libre_c01 = "CREADO|" + s-user-id + "|" + STRING(NOW,"99/99/9999 HH:MM:SS").
        END.
        ASSIGN z-vtatabla.valor[1] = tt-vtatabla.valor[1]
                z-vtatabla.valor[2] = tt-vtatabla.valor[2]
                z-vtatabla.libre_c02 = "MODIFICADO|" + s-user-id + "|" + STRING(NOW,"99/99/9999 HH:MM:SS").

    END.

    RELEASE z-vtatabla.

    SESSION:SET-WAIT-STAT("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 D-Dialog
ON CHOOSE OF BUTTON-3 IN FRAME D-Dialog /* Excel */
DO:
    DEFINE VAR X-archivo AS CHAR.
    DEFINE VAR rpta AS LOG.

	SYSTEM-DIALOG GET-FILE x-Archivo
	    FILTERS 'Excel (*.xls,xlsx)' '*.xls,*.xlsx'
	    DEFAULT-EXTENSION '.xls'
	    RETURN-TO-START-DIR
	    TITLE 'Importar Excel'
	    UPDATE rpta.
	IF rpta = NO OR x-Archivo = '' THEN RETURN.

    EMPTY TEMP-TABLE tt-vtatabla.

    DEFINE VARIABLE lFileXls                 AS CHARACTER.
	DEFINE VARIABLE lNuevoFile               AS LOG.

    DEFINE VAR xCaso AS CHAR.
    DEFINE VAR xCodMat AS CHAR.
    DEFINE VAR lLinea AS INT.
    DEFINE VAR dValor AS DEC.
    DEFINE VAR lTpoCmb AS DEC.
    DEFINE VAR x-errores AS INT.

	lFileXls = x-archivo.		/* Nombre el archivo a abrir o crear, vacio solo para nuevos */
	lNuevoFile = NO.	                    /* Si va crear un nuevo archivo o abrir */

	{lib\excel-open-file.i}

    lMensajeAlTerminar = NO. /*  */
    lCerrarAlTerminar = YES.	/* Si permanece abierto el Excel luego de concluir el proceso */


    SESSION:SET-WAIT-STAT("GENERAL").

	iColumn = 1.
    lLinea = 1.
    x-errores  = 0.

    cColumn = STRING(lLinea).
    REPEAT iColumn = 2 TO 65000 :
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        xCaso = chWorkSheet:Range(cRange):TEXT.

        IF xCaso = "" OR xCaso = ? THEN LEAVE.    /* FIN DE DATOS */

        xCodmat = xCaso.
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                    almmmatg.codmat = xCodMat 
                                    NO-LOCK NO-ERROR.

        IF AVAILABLE almmmatg THEN DO:
            CREATE tt-vtatabla.
                ASSIGN tt-vtatabla.llave_c1 = xCodmat.
            cRange = "B" + cColumn.
            ASSIGN tt-vtatabla.valor[1] = chWorkSheet:Range(cRange):VALUE.
            cRange = "C" + cColumn.
            ASSIGN tt-vtatabla.valor[2] = chWorkSheet:Range(cRange):VALUE.
        END.
        ELSE DO:
            x-errores = x-errores + 1.
        END.

    END.

	{lib\excel-close-file.i}

    SESSION:SET-WAIT-STAT("").

    {&OPEN-QUERY-BROWSE-2}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DISPLAY FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 FILL-IN-7 FILL-IN-10 FILL-IN-5 
          FILL-IN-8 FILL-IN-11 FILL-IN-6 FILL-IN-9 FILL-IN-12 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 RECT-3 RECT-4 BUTTON-3 Btn_Cancel Btn_Help BROWSE-2 
         Btn_OK 
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-VtaTabla"}
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

