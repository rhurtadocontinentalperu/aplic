&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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


DEFINE INPUT PARAMETER TABLE FOR tt-w-report.

DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oXMLBody AS com-HANDLE NO-UNDO.

DEFINE VAR x-url-consulta AS CHAR.
DEFINE VAR x-url-update AS CHAR.

/* http://192.168.1.201/CONTIENTERPRISE/public/api/electronicdocument/show/ */

DEFINE VAR cIPorigen AS CHAR.
DEFINE VAR cIPdestino AS CHAR.
DEFINE VAR cOtrosDatos AS CHAR.

cIPorigen = "192.168.100.221".

RUN lib/redireccionar-ip(cIPorigen, cOtrosDatos, OUTPUT cIPdestino).

/*x-url-consulta = "http://192.168.100.221:7000/api/electronicdocument/show/".*/
/*x-url-update = "http://192.168.100.221:7000/api/electronicdocument/update/".*/

x-url-consulta = "http://" + cIPdestino + ":7000/api/electronicdocument/show/".
x-url-update = "http://" + cIPdestino + ":7000/api/electronicdocument/update/".

/*http://192.168.100.221:7000*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 tt-w-report


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-6 Btn_Cancel BUTTON-1 Btn_OK 

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
     LABEL "CAMBIAR" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "Enviar Excel" 
     SIZE 15 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 D-Dialog _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Cod.Doc" FORMAT "X(5)":U
            WIDTH 6.14
      tt-w-report.Campo-C[2] COLUMN-LABEL "Nro.Doc" FORMAT "X(11)":U
            WIDTH 11.43
      tt-w-report.Campo-C[3] COLUMN-LABEL "Emision" FORMAT "X(10)":U
            WIDTH 8.43
      tt-w-report.Campo-C[4] COLUMN-LABEL "Segun PSE/OSE" FORMAT "X(100)":U
            WIDTH 47.86
      tt-w-report.Campo-C[5] COLUMN-LABEL "Nombre correcto" FORMAT "X(100)":U
            WIDTH 54.29
      tt-w-report.Campo-C[10] COLUMN-LABEL "Cod.Ref" FORMAT "X(5)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 133.72 BY 12.19
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-6 AT ROW 1.31 COL 2.29 WIDGET-ID 200
     Btn_Help AT ROW 14.08 COL 26
     Btn_Cancel AT ROW 14.08 COL 73.57
     BUTTON-1 AT ROW 14.12 COL 92.72 WIDGET-ID 2
     Btn_OK AT ROW 14.12 COL 111
     SPACE(11.99) SKIP(0.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Corregir razon social" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
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
/* BROWSE-TAB BROWSE-6 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Cod.Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no "6.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Nro.Doc" "X(11)" "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Emision" "X(10)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Segun PSE/OSE" "X(100)" "character" ? ? ? ? ? ? no ? no no "47.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Nombre correcto" "X(100)" "character" ? ? ? ? ? ? no ? no no "54.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[10]
"tt-w-report.Campo-C[10]" "Cod.Ref" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Corregir razon social */
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
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* CAMBIAR */
DO:
  
    btn_ok:AUTO-GO = NO.        /* del Boton OK */      
    MESSAGE 'Seguro de grabar el proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = YES THEN DO:
       
        RUN actualizar-razonsocial.
       btn_ok:AUTO-GO = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* Enviar Excel */
DO:
  RUN ToExcel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualizar-razonsocial D-Dialog 
PROCEDURE actualizar-razonsocial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR.                                                                              
                                                                              
SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH tt-w-report :
    x-retval = "".
    RUN webservice-update(INPUT tt-w-report.campo-c[1], 
                   INPUT tt-w-report.campo-c[2],
                   INPUT tt-w-report.campo-c[10],
                   INPUT tt-w-report.campo-c[5],                  
                   OUTPUT x-retval).
    ASSIGN tt-w-report.campo-c[4] = x-retval.
END.

{&open-query-browse-6}

SESSION:SET-WAIT-STATE("").


END PROCEDURE.

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
  ENABLE BROWSE-6 Btn_Cancel BUTTON-1 Btn_OK 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extrae-nombre D-Dialog 
PROCEDURE extrae-nombre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR.                                                                              
                                                                              
SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH tt-w-report :
    x-retval = "".
    RUN webservice-consulta(INPUT tt-w-report.campo-c[1], 
                   INPUT tt-w-report.campo-c[2], 
                   INPUT tt-w-report.campo-c[10], 
                   OUTPUT x-retval).
    ASSIGN tt-w-report.campo-c[4] = x-retval.
END.

{&open-query-browse-6}

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry D-Dialog 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN extrae-nombre.

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
  {src/adm/template/snd-list.i "tt-w-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ToExcel D-Dialog 
PROCEDURE ToExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lFileXls                 AS CHARACTER.
        DEFINE VARIABLE lNuevoFile               AS LOG.

    DEFINE VAR xCaso AS CHAR.
    DEFINE VAR xFamilia AS CHAR.
    DEFINE VAR xSubFamilia AS CHAR.
    DEFINE VAR lLinea AS INT.
    DEFINE VAR dValor AS DEC.
    DEFINE VAR lTpoCmb AS DEC.

        lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
        lNuevoFile = YES.                           /* Si va crear un nuevo archivo o abrir */

        {lib\excel-open-file.i}

    lMensajeAlTerminar = YES. /*  */
    lCerrarAlTerminar = NO.     /* Si permanece abierto el Excel luego de concluir el proceso */

    /*
    /* Open an Excel document  */
    chExcel:Workbooks:Open("c:\temp\test1.xlsx"). 
    chExcel:visible = true.
    
    /* Sets the number of sheets that will be   automatically inserted into new workbooks */
    chExcel:SheetsInNewWorkbook = 5.
    
    /* Add a new workbook */
    chWorkbook = chExcel:Workbooks:Add().
    
    /* Add a new worksheet as the last sheet */
    chWorksheet = chWorkbook:Worksheets(5).
    chWorkbook:Worksheets:add(, chWorksheet).
    RELEASE OBJECT chWorksheet.
    
    /* Select a worksheet */
    chWorkbook:Worksheets(2):Activate.
    chWorksheet = chWorkbook:Worksheets(2).
    
    /* Rename the worksheet */
    chWorkSheet:NAME = "test".
    */

    /* Adiciono  */
   /* 
        chWorkbook = chExcelApplication:Workbooks:Add().               
   */

    /* get the active Worksheet */
    /*chWorkSheet = chExcelApplication:Sheets:Item(1).*/

    /*
        /* NUEVO */
        chWorkbook = chExcelApplication:Workbooks:Add().
        chWorkSheet = chExcelApplication:Sheets:Item(1).
    */

    chWorkSheet = chExcelApplication:Sheets:Item(1).

        iColumn = 1.
    lLinea = 1.

    cColumn = STRING(lLinea).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange) = "CodDoc".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange) = "Nro.Doc.".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange) = "Emision".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange) = "Razon Social".

    iColumn = 2.
    FOR EACH tt-w-report NO-LOCK:
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange) = "'" + tt-w-report.campo-c[1].
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange) = "'" + tt-w-report.campo-c[2].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange) = "'" + tt-w-report.campo-c[3].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange) = "'" + tt-w-report.campo-c[5].

        iColumn = iColumn + 1.
    END.

        {lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE webservice-consulta D-Dialog 
PROCEDURE webservice-consulta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Tipo-Doc AS CHAR.
DEFINE INPUT PARAMETER p-nro-Doc AS CHAR.
DEFINE INPUT PARAMETER p-Tipo-ref AS CHAR.
DEFINE OUTPUT PARAMETER p-retval AS CHAR.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" x-oXMLBody.

DEFINE VAR x-url AS CHAR.

x-url = x-url-consulta.

IF LOOKUP(p-Tipo-Doc,"N/C,N/D") > 0 THEN DO:
    x-url = x-url + SUBSTRING(p-Tipo-ref,1,1) + SUBSTRING(p-nro-Doc,1,3) + "-" + SUBSTRING(p-nro-Doc,4).
END.
ELSE DO:
    x-url = x-url + SUBSTRING(p-Tipo-Doc,1,1) + SUBSTRING(p-nro-Doc,1,3) + "-" + SUBSTRING(p-nro-Doc,4).
END.

IF USERID("DICTDB") = 'ADMIN' OR USERID("DICTDB") = 'master' THEN DO:
    /*MESSAGE x-url.*/
END.
        
x-oXmlHttp:OPEN( "GET", x-URL, NO ) .    
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml" ).
/*x-oXmlHttp:setRequestHeader( "Content-Length", LENGTH(lEnvioXML)).    */

x-oXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/             
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    btn_ok:VISIBLE IN FRAME {&FRAME-NAME} = NO .
    p-retval = "SIN CONEXION|No hay conexion con el PSE (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
    RETURN "ADM-ERROR".
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    btn_ok:VISIBLE IN FRAME {&FRAME-NAME} = NO .
    p-retval = "ERROR 200|" + x-oXmlHttp:responseText.
    RETURN "ADM-ERROR".
END.
  
/* Respuesta */
DEFINE var x-oMsg AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oRspta AS COM-HANDLE NO-UNDO.

DEFINE VAR x-rspta AS CHAR.
DEFINE VAR x-status AS CHAR.
DEFINE VAR x-status-descripcion AS CHAR.
DEFINE VAR x-status-documento AS CHAR.
DEFINE VAR x-status-sunat AS CHAR.

CREATE "MSXML2.DOMDocument.6.0" x-oRspta. 

x-rspta = x-oXmlHttp:responseText.

x-oRspta:LoadXML(x-oXmlHttp:responseText).
x-oMsg = x-oRspta:selectSingleNode( "//error" ).
x-status = TRIM(x-oMsg:TEXT) NO-ERROR.
x-status = CAPS(x-status).

IF x-status = "NO ERROR" THEN DO:
    x-oMsg = x-oRspta:selectSingleNode( "//razonsocialadquiriente" ).
    p-retval = TRIM(x-oMsg:TEXT) NO-ERROR.
END.
ELSE DO:
    btn_ok:VISIBLE IN FRAME {&FRAME-NAME} = NO .
    p-retval = "ERROR : El webservice".
END.

/*
x-oMsg = x-oRspta:selectSingleNode( "//descriptionDetail" ).
x-status-descripcion = TRIM(x-oMsg:TEXT) NO-ERROR.
/* Sunat */
x-oMsg = x-oRspta:selectSingleNode( "//statusSunat" ).
x-status-sunat = TRIM(x-oMsg:TEXT) NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//statusDocument" ).
x-status-documento = TRIM(x-oMsg:TEXT) NO-ERROR.
*/

/*
IF x-status = ? THEN x-status = "".
IF x-status-descripcion = ? THEN x-status-descripcion = "".
IF x-status-sunat = ? THEN x-status-sunat = "".
IF x-status-documento = ? THEN x-status-documento = "".

p-Retval = x-status + "|" + x-status-descripcion.
*/

RELEASE OBJECT x-oXmlHttp NO-ERROR.
RELEASE OBJECT x-oXMLBody NO-ERROR.
RELEASE OBJECT x-oRspta NO-ERROR.
RELEASE OBJECT x-oMsg NO-ERROR.
/*
MESSAGE "pEstadoBizLinks " pEstadoBizLinks SKIP
        "pEstadoSunat " pEstadoSunat.

*/

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE webservice-update D-Dialog 
PROCEDURE webservice-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Tipo-Doc AS CHAR.
DEFINE INPUT PARAMETER p-nro-Doc AS CHAR.
DEFINE INPUT PARAMETER p-Tipo-ref AS CHAR.
DEFINE INPUT PARAMETER p-nueva-razonsocial AS CHAR.
DEFINE OUTPUT PARAMETER p-retval AS CHAR.

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" x-oXMLBody.

DEFINE VAR x-url AS CHAR.
DEFINE VAR x-nueva-razonsocial AS CHAR.

x-url = x-url-update.

IF LOOKUP(p-Tipo-Doc,"N/C,N/D") > 0 THEN DO:
    x-url = x-url + SUBSTRING(p-Tipo-ref,1,1) + SUBSTRING(p-nro-Doc,1,3) + "-" + SUBSTRING(p-nro-Doc,4).
END.
ELSE DO:
    x-url = x-url + SUBSTRING(p-Tipo-Doc,1,1) + SUBSTRING(p-nro-Doc,1,3) + "-" + SUBSTRING(p-nro-Doc,4).
END.

x-nueva-razonsocial = TRIM(p-nueva-razonsocial).

x-url = x-url + "/" + x-nueva-razonsocial.
        
x-oXmlHttp:OPEN( "GET", x-URL, NO ) .    
x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml" ).
/*x-oXmlHttp:setRequestHeader( "Content-Length", LENGTH(lEnvioXML)).    */

x-oXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/             
x-oXmlHttp:SEND() NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:
    p-retval = "SIN CONEXION|No hay conexion con el PSE (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
    RETURN "ADM-ERROR".
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    p-retval = "ERROR 200|" + x-oXmlHttp:responseText.
    RETURN "ADM-ERROR".
END.
  
/* Respuesta */
DEFINE var x-oMsg AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oRspta AS COM-HANDLE NO-UNDO.

DEFINE VAR x-rspta AS CHAR.
DEFINE VAR x-status AS CHAR.
DEFINE VAR x-status-descripcion AS CHAR.
DEFINE VAR x-status-documento AS CHAR.
DEFINE VAR x-status-sunat AS CHAR.

CREATE "MSXML2.DOMDocument.6.0" x-oRspta. 

x-rspta = x-oXmlHttp:responseText.

/*MESSAGE x-rspta. */

x-oRspta:LoadXML(x-oXmlHttp:responseText).
x-oMsg = x-oRspta:selectSingleNode( "//error" ).
x-status = TRIM(x-oMsg:TEXT) NO-ERROR.
x-status = CAPS(x-status).

IF x-status = "NO ERROR" THEN DO:
    x-oMsg = x-oRspta:selectSingleNode( "//razonsocialadquiriente" ).
    p-retval = TRIM(x-oMsg:TEXT) NO-ERROR.
END.
ELSE DO:
    p-retval = "ERROR : El webservice".
END.

/*
x-oMsg = x-oRspta:selectSingleNode( "//descriptionDetail" ).
x-status-descripcion = TRIM(x-oMsg:TEXT) NO-ERROR.
/* Sunat */
x-oMsg = x-oRspta:selectSingleNode( "//statusSunat" ).
x-status-sunat = TRIM(x-oMsg:TEXT) NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//statusDocument" ).
x-status-documento = TRIM(x-oMsg:TEXT) NO-ERROR.
*/

/*
IF x-status = ? THEN x-status = "".
IF x-status-descripcion = ? THEN x-status-descripcion = "".
IF x-status-sunat = ? THEN x-status-sunat = "".
IF x-status-documento = ? THEN x-status-documento = "".

p-Retval = x-status + "|" + x-status-descripcion.
*/

RELEASE OBJECT x-oXmlHttp NO-ERROR.
RELEASE OBJECT x-oXMLBody NO-ERROR.
RELEASE OBJECT x-oRspta NO-ERROR.
RELEASE OBJECT x-oMsg NO-ERROR.
/*
MESSAGE "pEstadoBizLinks " pEstadoBizLinks SKIP
        "pEstadoSunat " pEstadoSunat.

*/

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

