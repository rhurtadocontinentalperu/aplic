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
DEF SHARED VAR s-codcia AS INT.
DEF STREAM REPORT.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cAlmacen LIKE almacen.codalm   NO-UNDO.
DEFINE VARIABLE x-Almacenes AS CHAR NO-UNDO.


DEFINE TEMP-TABLE tmp-datos
    FIELDS codalm LIKE almacen.codalm
    FIELDS desalm LIKE almacen.descripcion
    FIELDS nropag AS INTEGER
    FIELDS codres AS CHARACTER FORMAT 'X(50)'.

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
&Scoped-Define ENABLED-OBJECTS cb-almacen b-busca rs-cont Btn_OK Btn_Cancel ~
BUTTON-1 RECT-72 
&Scoped-Define DISPLAYED-OBJECTS cb-almacen rs-cont 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-busca 
     LABEL "..." 
     SIZE 3 BY .81.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 13 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "OK" 
     SIZE 13 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "Button 1" 
     SIZE 12 BY 1.5.

DEFINE VARIABLE cb-almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE rs-cont AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Conteo", 1,
"Reconteo", 2
     SIZE 20 BY 1.08 NO-UNDO.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 5.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     cb-almacen AT ROW 2.62 COL 12 COLON-ALIGNED WIDGET-ID 8
     b-busca AT ROW 2.62 COL 57 WIDGET-ID 28
     rs-cont AT ROW 3.69 COL 14 NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 5.31 COL 37
     Btn_Cancel AT ROW 5.31 COL 50
     BUTTON-1 AT ROW 5.31 COL 25 WIDGET-ID 32
     RECT-72 AT ROW 1.27 COL 2 WIDGET-ID 30
     SPACE(1.13) SKIP(0.53)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Paginas sin ingresos en Inventario"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Paginas sin ingresos en Inventario */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-busca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-busca D-Dialog
ON CHOOSE OF b-busca IN FRAME D-Dialog /* ... */
DO:
    RUN alm/d-repalm (INPUT-OUTPUT x-Almacenes).
    cAlmacen = x-Almacenes. 
    cb-Almacen = x-Almacenes.
    DISPLAY cAlmacen @ cb-Almacen WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN 
      rs-cont
      cb-almacen.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* Button 1 */
DO:
  ASSIGN 
      rs-cont
      cb-almacen.
  RUN Imprime.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos D-Dialog 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH tmp-datos:
        DELETE tmp-datos.
    END.

    cAlmacen = cb-almacen.    
    IF rs-cont = 1 THEN DO:
        FOR EACH Almacen WHERE Almacen.codcia = s-codcia
            AND LOOKUP(TRIM(Almacen.codalm),cAlmacen) > 0 NO-LOCK
            BREAK BY almacen.codalm:
            FOR EACH AlmCInv WHERE AlmCInv.CodCia = Almacen.CodCia
                AND AlmCInv.CodAlm = Almacen.CodAlm  
                AND AlmCInv.NomCia = "CONTI"
                AND AlmCInv.SwConteo = NO NO-LOCK:
                FIND FIRST tmp-datos WHERE tmp-datos.CodAlm = AlmCInv.codalm
                    AND tmp-datos.nropag = Almcinv.nropagina NO-LOCK NO-ERROR.
                IF NOT AVAIL tmp-datos THEN DO:
                    CREATE tmp-datos.
                    ASSIGN tmp-datos.codalm = almcinv.codalm
                           tmp-datos.desalm = almacen.descripcion
                           tmp-datos.nropag = almcinv.nropagina.
                    IF almcinv.swdiferencia THEN 
                        ASSIGN tmp-datos.codres = 'No presenta diferencias'.                    
                END.
            END.
        END.
    END.
    ELSE IF rs-cont = 2 THEN DO:
        FOR EACH Almacen WHERE Almacen.codcia = s-codcia
            AND LOOKUP(TRIM(Almacen.codalm),cAlmacen) > 0 NO-LOCK
            BREAK BY almacen.codalm:
            FOR EACH AlmCInv WHERE AlmCInv.CodCia = Almacen.CodCia
                AND AlmCInv.CodAlm = Almacen.CodAlm  
                AND AlmCInv.NomCia = "CONTI"
                AND AlmCInv.SwReConteo = NO NO-LOCK:
                FIND FIRST tmp-datos WHERE tmp-datos.CodAlm = AlmCInv.codalm
                     AND tmp-datos.nropag = Almcinv.nropagina NO-LOCK NO-ERROR.
                IF NOT AVAIL tmp-datos THEN DO:
                    CREATE tmp-datos.
                    ASSIGN tmp-datos.codalm = almcinv.codalm
                           tmp-datos.desalm = almacen.descripcion
                           tmp-datos.nropag = almcinv.nropagina.
                    IF almcinv.swdiferencia THEN 
                        ASSIGN tmp-datos.codres = 'No presenta diferencias'.                    
                END.
            END.
        END.
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
  DISPLAY cb-almacen rs-cont 
      WITH FRAME D-Dialog.
  ENABLE cb-almacen b-busca rs-cont Btn_OK Btn_Cancel BUTTON-1 RECT-72 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel D-Dialog 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
    DEFINE VARIABLE chChart                 AS COM-HANDLE.
    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
    DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
    DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE cCond AS CHARACTER   NO-UNDO.
    
    RUN Carga-Datos.
    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.
    
    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().
    
    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    IF rs-cont = 1 THEN  cCond = 'CONTEO'.
    ELSE cCond = 'RECONTEO'.
    
    /*Header del Excel */
    cRange = "B" + '2'.
    chWorkSheet:Range(cRange):Value = "PAGINAS QUE NO HAN TENIDO " + cCond.
    
    
    /*Formato*/
    chWorkSheet:Columns("A"):NumberFormat = "@".
    
    /* set the column names for the Worksheet */
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Almc.".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro.Pag".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Obsrv.".

    FOR EACH tmp-datos:
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-datos.codalm.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-datos.desalm.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-datos.nropag.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-datos.codres.
    END.
    
    /* launch Excel so it is visible to the user */
     chExcelApplication:Visible = TRUE.
    
    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato D-Dialog 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE FRAME f-det
        tmp-datos.codalm COLUMN-LABEL "CodAlm"
        tmp-datos.desalm COLUMN-LABEL "Almacen"
        tmp-datos.nropag COLUMN-LABEL "Nro Pagina"
        tmp-datos.codres COLUMN-LABEL "Observaciones"
        WITH WIDTH 320 NO-BOX STREAM-IO DOWN. 
                        
    DEFINE FRAME f-header
      HEADER
      SKIP 2
      "PAGINA SIN INGRESO DE INVENTARIO" AT 20 
      "Pagina :" TO 100 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
      "Fecha :" TO 100 TODAY FORMAT "99/99/9999" SKIP
      WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

    FOR EACH tmp-datos:
        VIEW STREAM REPORT FRAME f-header.
        DISPLAY STREAM REPORT
            tmp-datos.codalm 
            tmp-datos.desalm
            tmp-datos.nropag 
            tmp-datos.codres 
            WITH FRAME f-det.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime D-Dialog 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN Carga-Datos.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto D-Dialog 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE x-Archivo AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE x-rpta    AS LOGICAL     NO-UNDO.
   
  x-Archivo = 'PagSinIngreso.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.
  OUTPUT STREAM REPORT TO VALUE(x-Archivo).
  PUT STREAM REPORT
      "Almc|" 
      "Descripcion|"
      "Nro.Pag|"                              
      "Obsrv." SKIP.
  FOR EACH tmp-datos:
      PUT STREAM REPORT
          tmp-datos.codalm "|"
          tmp-datos.desalm "|"
          tmp-datos.nropag "|"
          tmp-datos.codres SKIP.
  END.
  
  OUTPUT STREAM REPORT CLOSE.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

