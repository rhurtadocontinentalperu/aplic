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

DEFINE SHARED VAR s-codcia AS INT.

DEFINE TEMP-TABLE ttInvitados
    FIELDS ttSec AS INT INIT 0
    FIELDS ttCodClie AS CHAR FORMAT 'x(15)' INIT ''
    FIELDS ttNomClie AS CHAR FORMAT 'x(100)' INIT ''
    FIELDS ttDirec AS CHAR FORMAT 'x(120)' INIT ''
    FIELDS ttDpto AS CHAR FORMAT 'x(50)' INIT ''
    FIELDS ttProvincia AS CHAR FORMAT 'x(50)' INIT ''
    FIELDS ttDistrito AS CHAR FORMAT 'x(50)' INIT ''.

DEFINE VAR rpta AS LOG.
DEF STREAM REPORTE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttInvitados

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ttInvitados.ttSec ttInvitados.ttCodClie ttInvitados.ttNomClie ttInvitados.ttDirec ttInvitados.ttDpto ttInvitados.ttProvincia ttInvitados.ttDistrito   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ttInvitados
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH ttInvitados.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ttInvitados
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ttInvitados


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 btnImpresion btnExcel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnExcel 
     LABEL "Excel...." 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnImpresion 
     LABEL "Imprimir Etiquetas" 
     SIZE 19.72 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ttInvitados SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _FREEFORM
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ttInvitados.ttSec COLUMN-LABEL "Sec" FORMAT ">>>>9":U
ttInvitados.ttCodClie COLUMN-LABEL "Cod.Cliente" FORMAT "x(15)":U
ttInvitados.ttNomClie COLUMN-LABEL "Nombre Cliente" FORMAT "x(50)":U
ttInvitados.ttDirec COLUMN-LABEL "Direccion" FORMAT "x(80)":U
ttInvitados.ttDpto COLUMN-LABEL "Departamento" FORMAT "x(25)":U
ttInvitados.ttProvincia COLUMN-LABEL "Provincia" FORMAT "x(25)":U
ttInvitados.ttDistrito COLUMN-LABEL "Distrito" FORMAT "x(25)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 107 BY 18.23 ROW-HEIGHT-CHARS .65 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 2.77 COL 2 WIDGET-ID 200
     btnImpresion AT ROW 21.27 COL 87.29 WIDGET-ID 4
     btnExcel AT ROW 21.31 COL 64 WIDGET-ID 6
     "     Impresion de etiquetas INVITADOS EXPOLIBRERIA" VIEW-AS TEXT
          SIZE 79 BY .96 AT ROW 1.19 COL 10 WIDGET-ID 2
          FGCOLOR 1 FONT 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111.72 BY 21.62 WIDGET-ID 100.


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
         TITLE              = "Impresion de Etiquetas INVITADOS EXPOLIBRERIA"
         HEIGHT             = 21.65
         WIDTH              = 109.57
         MAX-HEIGHT         = 21.88
         MAX-WIDTH          = 114.57
         VIRTUAL-HEIGHT     = 21.88
         VIRTUAL-WIDTH      = 114.57
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 TEXT-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttInvitados.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.ControlOD.FchChq|no,INTEGRAL.ControlOD.HorChq|no"
     _Where[1]         = "{&CONDICION}"
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Impresion de Etiquetas INVITADOS EXPOLIBRERIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Impresion de Etiquetas INVITADOS EXPOLIBRERIA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcel W-Win
ON CHOOSE OF btnExcel IN FRAME F-Main /* Excel.... */
DO:

    DEFINE VAR X-archivo AS CHAR.

        SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'Excel (*.xls)' '*.xls,*.xlsx'
            DEFAULT-EXTENSION '.xls'
            RETURN-TO-START-DIR
            TITLE 'Importar Excel'
            UPDATE rpta.
        IF rpta = NO OR x-Archivo = '' THEN RETURN.

    /* ----------------------------------------------------------------- */

        DEFINE VARIABLE lFileXls                 AS CHARACTER.
        DEFINE VARIABLE lNuevoFile               AS LOG.
    DEFINE VARIABLE cValue AS CHAR.

        lFileXls = X-archivo.           /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
        lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

        {lib\excel-open-file.i}

        chExcelApplication:Visible = FALSE.

        lMensajeAlTerminar = YES. /*  */
        lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

        chWorkSheet = chExcelApplication:Sheets:Item(1).

        iColumn = 1.

        REPEAT iColumn = 2 TO 65000:
            cRange = "A" + TRIM(STRING(iColumn)).
            cValue = chWorkSheet:Range(cRange):VALUE.

            IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */

        CREATE ttInvitados.
            cRange = "A" + TRIM(STRING(iColumn)).
            ASSIGN ttSec = chWorkSheet:Range(cRange):VALUE.
            cRange = "B" + TRIM(STRING(iColumn)).
            ASSIGN ttCodClie = chWorkSheet:Range(cRange):VALUE.
            cRange = "C" + TRIM(STRING(iColumn)).
            ASSIGN ttNomClie = chWorkSheet:Range(cRange):VALUE.
            cRange = "D" + TRIM(STRING(iColumn)).
            ASSIGN ttDirec = chWorkSheet:Range(cRange):VALUE.
            cRange = "E" + TRIM(STRING(iColumn)).
            ASSIGN ttDpto = chWorkSheet:Range(cRange):VALUE.
            cRange = "F" + TRIM(STRING(iColumn)).
            ASSIGN ttProvincia = chWorkSheet:Range(cRange):VALUE.
            cRange = "G" + TRIM(STRING(iColumn)).
            ASSIGN ttDistrito = chWorkSheet:Range(cRange):VALUE.
        END.

    {lib\excel-close-file.i}

    {&OPEN-QUERY-BROWSE-2}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnImpresion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnImpresion W-Win
ON CHOOSE OF btnImpresion IN FRAME F-Main /* Imprimir Etiquetas */
DO:
  RUN ue-imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  ENABLE BROWSE-2 btnImpresion btnExcel 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ttInvitados"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imp-etiqueta W-Win 
PROCEDURE ue-imp-etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSec AS INT.
DEFINE VAR lCod AS CHAR.
DEFINE VAR lNom AS CHAR.
DEFINE VAR lDire AS CHAR.
DEFINE VAR lDpto AS CHAR.
DEFINE VAR lProv AS CHAR.
DEFINE VAR lDist AS CHAR.
DEFINE VAR lUbigeo AS CHAR INIT ''.

lSec = ttInvitados.ttSec.
lCod = trim(ttInvitados.ttCodCLie).
lnom = trim(ttInvitados.ttNomCLie).
lDire = trim(ttInvitados.ttDirec).
lDpto = TRIM(ttInvitados.ttDpto).
lProv = TRIM(ttInvitados.ttProvincia).
lDist = TRIM(ttInvitados.ttDistrito).

lUbigeo = lDpto + " - " + lProv + " - " + lDist.

/*PUT STREAM REPORTE '^XA^LH000,012' SKIP.*/
PUT STREAM REPORTE '^XA^LH000,008' SKIP.
PUT STREAM REPORTE '^JMA^JS' SKIP.

PUT STREAM REPORTE '^FO50,0' SKIP.
PUT STREAM REPORTE '^A0N,20,20' SKIP.
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  lnom FORMAT 'x(80)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

PUT STREAM REPORTE '^FO50,20' SKIP.
PUT STREAM REPORTE '^A0N,20,20' SKIP.
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  ldire FORMAT 'x(80)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

PUT STREAM REPORTE '^FO50,40' SKIP.
PUT STREAM REPORTE '^A0N,20,20' SKIP.
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE lUbigeo FORMAT 'x(80)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

PUT STREAM REPORTE '^FO60,80' SKIP.
PUT STREAM REPORTE '^BY2^BCN,70,Y,N,N' SKIP.
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  lCod FORMAT 'x(11)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

PUT STREAM REPORTE '^FO700,80' SKIP.
PUT STREAM REPORTE '^GB60,35,2' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

PUT STREAM REPORTE '^FO705,85' SKIP.
PUT STREAM REPORTE '^A0N,25,20' SKIP.
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  lSec FORMAT '>>>9' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

PUT STREAM REPORTE '^PQ1' SKIP.
PUT STREAM REPORTE '^PR6' SKIP.
PUT STREAM REPORTE '^XZ' SKIP.

/*
/*Empresa*/
PUT STREAM REPORTE '^XA^LH000,012' SKIP.
PUT STREAM REPORTE '^FO50,05' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
PUT STREAM REPORTE '^FDCONTINENTAL S.A.C.^FS' SKIP.
/* */
PUT STREAM REPORTE '^FO700,05' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  tt-regLPN.tt4digi FORMAT 'x(6)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.
/* Barras */
PUT STREAM REPORTE '^FO50,40' SKIP.
PUT STREAM REPORTE '^BY2^BCN,70,Y,N,N' SKIP.
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  tt-regLPN.ttCodLPN FORMAT 'x(18)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

/*PUT STREAM REPORTE '^FD500071009490520003^FS' SKIP.*/
/*Fecha entrega*/
PUT STREAM REPORTE '^FO550,50' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
PUT STREAM REPORTE '^FDFECHA ENTREGA^FS' SKIP.
PUT STREAM REPORTE '^FO580,90' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
/*PUT STREAM REPORTE '^FD99/99/9999^FS' SKIP.*/
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  tt-regLPN.ttfchent FORMAT '99/99/9999' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

/* Tienda */
PUT STREAM REPORTE '^FO50,140' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
/*PUT STREAM REPORTE '^FDP119 SPSA PVEA PUENTE PIEDRA^FS' SKIP.*/
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  'TDA :' + tt-regLPN.ttTienda FORMAT 'x(80)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

PUT STREAM REPORTE '^PQ1' SKIP.
PUT STREAM REPORTE '^PR6' SKIP.
PUT STREAM REPORTE '^XZ' SKIP.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imprimir W-Win 
PROCEDURE ue-imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iTCont AS INT INIT 0.                  
DEFINE VAR iCont AS INT INIT 0.                  
DEFINE VAR lOD AS CHAR.
DEFINE VAR lPED AS CHAR.
DEFINE VAR lCOT AS CHAR.
DEFINE VAR lNroEtq AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    iTCont = BROWSE-2:NUM-SELECTED-ROWS.

    IF iTCont > 0 THEN DO:
        SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
        IF rpta = NO THEN RETURN.
        OUTPUT STREAM REPORTE TO PRINTER.
    END.

    DO iCont = 1 TO iTCont :
        IF BROWSE-2:FETCH-SELECTED-ROW(icont) THEN DO:
            RUN ue-imp-etiqueta.
        END.
    END.

    IF iTCont > 0 THEN DO:
        OUTPUT STREAM REPORTE CLOSE.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

