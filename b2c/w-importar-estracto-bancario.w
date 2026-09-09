&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t_estrac_bancario NO-UNDO LIKE estrac_bancario.



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
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-file-excel AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t_estrac_bancario

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 t_estrac_bancario.cod_operacion ~
t_estrac_bancario.fech_operacion t_estrac_bancario.movimiento ~
t_estrac_bancario.detalle t_estrac_bancario.canal t_estrac_bancario.abono 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH t_estrac_bancario NO-LOCK ~
    BY t_estrac_bancario.fech_operacion INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH t_estrac_bancario NO-LOCK ~
    BY t_estrac_bancario.fech_operacion INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 t_estrac_bancario
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 t_estrac_bancario


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-4 BUTTON-5 BROWSE-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     LABEL "Importar Excel del ESTRACTO BANCARIO" 
     SIZE 40 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Grabar Informacion" 
     SIZE 17 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      t_estrac_bancario SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      t_estrac_bancario.cod_operacion COLUMN-LABEL "Cod!Operacion" FORMAT "x(25)":U
            WIDTH 20.43
      t_estrac_bancario.fech_operacion COLUMN-LABEL "Fecha!Operacion" FORMAT "99/99/9999":U
            WIDTH 11.43
      t_estrac_bancario.movimiento COLUMN-LABEL "Tipo!Movimiento" FORMAT "x(50)":U
            WIDTH 22.43
      t_estrac_bancario.detalle COLUMN-LABEL "Detalle" FORMAT "x(150)":U
            WIDTH 54
      t_estrac_bancario.canal COLUMN-LABEL "Canal" FORMAT "x(25)":U
            WIDTH 17
      t_estrac_bancario.abono COLUMN-LABEL "Importe!Abonado" FORMAT "->>,>>>,>>9.99":U
            WIDTH 16.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 148 BY 17.12
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 1.38 COL 3 WIDGET-ID 2
     BUTTON-5 AT ROW 1.38 COL 96 WIDGET-ID 4
     BROWSE-4 AT ROW 2.92 COL 3 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 150.14 BY 19.81
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t_estrac_bancario T "?" NO-UNDO INTEGRAL estrac_bancario
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR EXCEL DEL ESTRACTO BANCARIO"
         HEIGHT             = 19.81
         WIDTH              = 150.14
         MAX-HEIGHT         = 20.42
         MAX-WIDTH          = 158.86
         VIRTUAL-HEIGHT     = 20.42
         VIRTUAL-WIDTH      = 158.86
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
/* BROWSE-TAB BROWSE-4 BUTTON-5 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.t_estrac_bancario"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.t_estrac_bancario.fech_operacion|yes"
     _FldNameList[1]   > Temp-Tables.t_estrac_bancario.cod_operacion
"t_estrac_bancario.cod_operacion" "Cod!Operacion" ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t_estrac_bancario.fech_operacion
"t_estrac_bancario.fech_operacion" "Fecha!Operacion" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t_estrac_bancario.movimiento
"t_estrac_bancario.movimiento" "Tipo!Movimiento" ? "character" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t_estrac_bancario.detalle
"t_estrac_bancario.detalle" "Detalle" ? "character" ? ? ? ? ? ? no ? no no "54" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t_estrac_bancario.canal
"t_estrac_bancario.canal" "Canal" ? "character" ? ? ? ? ? ? no ? no no "17" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t_estrac_bancario.abono
"t_estrac_bancario.abono" "Importe!Abonado" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "16.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR EXCEL DEL ESTRACTO BANCARIO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR EXCEL DEL ESTRACTO BANCARIO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Importar Excel del ESTRACTO BANCARIO */
DO:
    DEF VAR lNuevoFile AS LOG NO-UNDO.
    DEF VAR lFIleXls   AS CHAR NO-UNDO.
    DEF VAR x-Archivo  AS CHAR NO-UNDO.

    DEFINE VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE x-Archivo
        FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx"
        MUST-EXIST
        TITLE "Seleccione archivo..."
        UPDATE OKpressed.   

    IF OKpressed = NO THEN RETURN NO-APPLY.
    lFileXls = x-Archivo.
    lNuevoFile = NO.

    x-file-excel = lFileXls.

    RUN temporal-de-excel.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Grabar Informacion */
DO:
  RUN grabar-informacion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
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
  ENABLE BUTTON-4 BUTTON-5 BROWSE-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-informacion W-Win 
PROCEDURE grabar-informacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST t_estrac_bancario NO-LOCK NO-ERROR.

IF NOT AVAILABLE t_estrac_bancario THEN DO:
    MESSAGE "No hay informacion para grabar"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

MESSAGE 'Seguro de GRABAR el ESTRACTO BANCARIO?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH t_estrac_bancario :
    /* Valido Cod Operacion si existe */
    FIND FIRST estrac_bancario WHERE estrac_bancario.codcia = s-codcia AND
                                        estrac_bancario.cod_operacion = t_estrac_bancario.cod_operacion NO-LOCK NO-ERROR.

    ASSIGN t_estrac_bancario.libre_char[10] = "X".
    IF AVAILABLE estrac_bancario THEN DO:        
        NEXT.
    END.
        

    CREATE estrac_bancario.
    ASSIGN estrac_bancario.codcia = s-codcia
            estrac_bancario.cod_operacion = t_estrac_bancario.cod_operacion
            estrac_bancario.abono = t_estrac_bancario.abono
            estrac_bancario.fech_operacion = t_estrac_bancario.fech_operacion
            estrac_bancario.movimiento = t_estrac_bancario.movimiento
            estrac_bancario.detalle = t_estrac_bancario.detalle
            estrac_bancario.canal = t_estrac_bancario.canal
            estrac_bancario.libre_char[1] = s-user-id
            estrac_bancario.libre_char[2] = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS").

        ASSIGN
            t_estrac_bancario.libre_char[10] = "".
            .
        RELEASE estrac_bancario.
END.

FOR EACH t_estrac_bancario :
    IF t_estrac_bancario.libre_char[10] = "" THEN DELETE t_estrac_bancario.
END.

{&open-query-browse-4}

SESSION:SET-WAIT-STATE("").


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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "t_estrac_bancario"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE temporal-de-excel W-Win 
PROCEDURE temporal-de-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lFileXls                 AS CHARACTER.
        DEFINE VARIABLE lNuevoFile               AS LOG.

    DEFINE VAR xCaso AS CHAR.
    DEFINE VAR lLinea AS INT.
    DEFINE VAR dValor AS DEC.
    DEFINE VAR cValor AS CHAR.
    DEFINE VAR fValor AS DATE.
    DEFINE VAR iValor AS INT.

        lFileXls = x-file-excel.                /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
        lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

        {lib\excel-open-file.i}

    lMensajeAlTerminar = YES. /*  */
    lCerrarAlTerminar = YES.     /* Si permanece abierto el Excel luego de concluir el proceso */

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
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /*
        /* NUEVO */
        chWorkbook = chExcelApplication:Workbooks:Add().
        chWorkSheet = chExcelApplication:Sheets:Item(1).
    */

        iColumn = 1.
    lLinea = 19.


    SESSION:SET-WAIT-STATE("GENERAL").

    cColumn = STRING(lLinea).
    REPEAT lLinea = 19 TO 65000 :
        cColumn = STRING(lLinea).

        cRange = "A" + cColumn.
        xCaso = chWorkSheet:Range(cRange):TEXT.

        IF xCaso = "" OR xCaso = ? THEN LEAVE.    /* FIN DE DATOS */

        /* Si el Abono es mayor a cero*/
        cRange = "I" + cColumn.
        cValor = TRIM(chWorkSheet:Range(cRange):TEXT).
        cValor = REPLACE(cValor,",","").
        cValor = REPLACE(cValor,"S/","").
        
        dValor = DECIMAL(cValor).
        IF dValor <= 0 THEN NEXT.

        /* Solo lo Movimientos */
        cRange = "C" + cColumn.
        cValor = CAPS(TRIM(chWorkSheet:Range(cRange):TEXT)).
        /*IF LOOKUP(cValor,"DEP.EFECTIVO,PAGO ESTABLECIMENTOS,RECAUDACION") = 0 THEN NEXT.*/
        IF LOOKUP(cValor,"PAGO ESTABLECIMENTOS") = 0 THEN NEXT.

        /* Si esta vacio Cod.Operacion Salir */
        cRange = "E" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        IF cValor = "" OR cValor = ? THEN NEXT.
        IF LENGTH(cValor) < 2 THEN NEXT.

        /* Valido Cod Operacion si existe */
        FIND FIRST estrac_bancario WHERE estrac_bancario.codcia = s-codcia AND
                                            estrac_bancario.cod_operacion = cvalor NO-LOCK NO-ERROR.

        IF AVAILABLE estrac_bancario THEN NEXT.

        FIND FIRST t_estrac_bancario WHERE t_estrac_bancario.codcia = s-codcia AND
                                            t_estrac_bancario.cod_operacion = cvalor NO-LOCK NO-ERROR.

        IF AVAILABLE t_estrac_bancario THEN NEXT.


        CREATE t_estrac_bancario.
            ASSIGN t_estrac_bancario.codcia = s-codcia
                t_estrac_bancario.cod_operacion = cValor
                t_estrac_bancario.abono = dValor.

        /* Fecha Operacion */
        cRange = "A" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        fValor = DATE(cValor) NO-ERROR.
        ASSIGN t_estrac_bancario.fech_operacion = fValor.

        /* Movimiento */
        cRange = "C" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_estrac_bancario.movimiento = cValor.
        
        /* Detalle */
        cRange = "D" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_estrac_bancario.detalle = cValor.

        /* Canal */
        cRange = "F" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_estrac_bancario.canal = cValor.

    END.    
    {&open-query-browse-4}

    SESSION:SET-WAIT-STATE("").

        {lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

