&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t_pago_efectivo NO-UNDO LIKE pago_efectivo.



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
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t_pago_efectivo

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 t_pago_efectivo.orden_comercio ~
t_pago_efectivo.nro_cip t_pago_efectivo.fecha_emision ~
t_pago_efectivo.fecha_cancelacion t_pago_efectivo.concepto_pago ~
t_pago_efectivo.monto t_pago_efectivo.origen_cancelacion ~
t_pago_efectivo.agencia t_pago_efectivo.tipo_docmnto ~
t_pago_efectivo.nro_docmnto t_pago_efectivo.cliente_nombre ~
t_pago_efectivo.cliente_apellidos 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH t_pago_efectivo NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH t_pago_efectivo NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 t_pago_efectivo
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 t_pago_efectivo


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-4 BUTTON-5 BROWSE-6 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     LABEL "Importar Excel del PAGOEFECTIVO" 
     SIZE 30 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Grabar Informacion" 
     SIZE 17 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "CARGAR EXCEL DE PAGOEFECTIVO ( CIPs pagados )" 
     VIEW-AS FILL-IN 
     SIZE 70.43 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 9 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      t_pago_efectivo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 W-Win _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      t_pago_efectivo.orden_comercio COLUMN-LABEL "Orden" FORMAT "x(50)":U
            WIDTH 12
      t_pago_efectivo.nro_cip COLUMN-LABEL "C.I.P" FORMAT "x(25)":U
            WIDTH 13.43
      t_pago_efectivo.fecha_emision COLUMN-LABEL "Fecha!Emision" FORMAT "99/99/9999":U
      t_pago_efectivo.fecha_cancelacion COLUMN-LABEL "Fecha!Cancelacion" FORMAT "99/99/9999":U
            WIDTH 11.43
      t_pago_efectivo.concepto_pago COLUMN-LABEL "Concepto!Pago" FORMAT "x(50)":U
            WIDTH 20.43
      t_pago_efectivo.monto COLUMN-LABEL "Monto" FORMAT "->>,>>>,>>9.99":U
            WIDTH 10.43
      t_pago_efectivo.origen_cancelacion COLUMN-LABEL "Origen" FORMAT "x(25)":U
            WIDTH 15.43
      t_pago_efectivo.agencia COLUMN-LABEL "Agencia" FORMAT "x(50)":U
            WIDTH 18.86
      t_pago_efectivo.tipo_docmnto COLUMN-LABEL "Tipo!Docmnto" FORMAT "x(15)":U
            WIDTH 8.86
      t_pago_efectivo.nro_docmnto COLUMN-LABEL "Numero!Docmnto" FORMAT "x(25)":U
            WIDTH 14.29
      t_pago_efectivo.cliente_nombre COLUMN-LABEL "Nombre" FORMAT "x(100)":U
            WIDTH 22.43
      t_pago_efectivo.cliente_apellidos COLUMN-LABEL "Apellidos" FORMAT "x(100)":U
            WIDTH 36.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 150 BY 16.92
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-1 AT ROW 1.31 COL 45.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BUTTON-4 AT ROW 1.38 COL 3 WIDGET-ID 2
     BUTTON-5 AT ROW 1.38 COL 131 WIDGET-ID 4
     BROWSE-6 AT ROW 3.31 COL 1.43 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 151.72 BY 19.81
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t_pago_efectivo T "?" NO-UNDO INTEGRAL pago_efectivo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR EXCEL DE PAGEFECTIVO"
         HEIGHT             = 19.81
         WIDTH              = 151.72
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
/* BROWSE-TAB BROWSE-6 BUTTON-5 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.t_pago_efectivo"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t_pago_efectivo.orden_comercio
"t_pago_efectivo.orden_comercio" "Orden" ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t_pago_efectivo.nro_cip
"t_pago_efectivo.nro_cip" "C.I.P" ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t_pago_efectivo.fecha_emision
"t_pago_efectivo.fecha_emision" "Fecha!Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t_pago_efectivo.fecha_cancelacion
"t_pago_efectivo.fecha_cancelacion" "Fecha!Cancelacion" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t_pago_efectivo.concepto_pago
"t_pago_efectivo.concepto_pago" "Concepto!Pago" ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t_pago_efectivo.monto
"t_pago_efectivo.monto" "Monto" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t_pago_efectivo.origen_cancelacion
"t_pago_efectivo.origen_cancelacion" "Origen" ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t_pago_efectivo.agencia
"t_pago_efectivo.agencia" "Agencia" ? "character" ? ? ? ? ? ? no ? no no "18.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t_pago_efectivo.tipo_docmnto
"t_pago_efectivo.tipo_docmnto" "Tipo!Docmnto" ? "character" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t_pago_efectivo.nro_docmnto
"t_pago_efectivo.nro_docmnto" "Numero!Docmnto" ? "character" ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.t_pago_efectivo.cliente_nombre
"t_pago_efectivo.cliente_nombre" "Nombre" ? "character" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.t_pago_efectivo.cliente_apellidos
"t_pago_efectivo.cliente_apellidos" "Apellidos" ? "character" ? ? ? ? ? ? no ? no no "36.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR EXCEL DE PAGEFECTIVO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR EXCEL DE PAGEFECTIVO */
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
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Importar Excel del PAGOEFECTIVO */
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


&Scoped-define BROWSE-NAME BROWSE-6
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
  DISPLAY FILL-IN-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-4 BUTTON-5 BROWSE-6 
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

FIND FIRST t_pago_efectivo NO-LOCK NO-ERROR.

IF NOT AVAILABLE t_pago_efectivo THEN DO:
    MESSAGE "No hay informacion para grabar"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

MESSAGE 'Seguro de GRABAR el PAGOEFECTIVO?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH t_pago_efectivo :
    /* Valido Cod Operacion si existe */
    FIND FIRST pago_efectivo WHERE pago_efectivo.codcia = s-codcia AND
                                        pago_efectivo.orden_comercio = t_pago_efectivo.orden_comercio NO-LOCK NO-ERROR.

    ASSIGN t_pago_efectivo.libre_char[10] = "X".
    IF AVAILABLE pago_efectivo THEN DO:        
        NEXT.
    END.
        

    CREATE pago_efectivo.

    ASSIGN pago_efectivo.codcia = s-codcia
            pago_efectivo.orden_comercio = t_pago_efectivo.orden_comercio
            pago_efectivo.nro_cip = t_pago_efectivo.nro_cip
            pago_efectivo.monto = t_pago_efectivo.monto
            pago_efectivo.fecha_emision = t_pago_efectivo.fecha_emision
            pago_efectivo.fecha_cancelacion = t_pago_efectivo.fecha_cancelacion
            pago_efectivo.origen_cancelacion = t_pago_efectivo.origen_cancelacion
            pago_efectivo.agencia = t_pago_efectivo.agencia
            pago_efectivo.cliente_nombre = t_pago_efectivo.cliente_nombre
            pago_efectivo.cliente_Apellido = t_pago_efectivo.cliente_Apellido
            pago_efectivo.tipo_docmnto = t_pago_efectivo.tipo_docmnto
            pago_efectivo.nro_docmnto = t_pago_efectivo.nro_docmnto
            pago_efectivo.concepto_pago = t_pago_efectivo.concepto_pago
            pago_efectivo.libre_char[1] = s-user-id
            pago_efectivo.libre_char[2] = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS").

        ASSIGN
            t_pago_efectivo.libre_char[10] = "".
            .
        RELEASE pago_efectivo.
END.

FOR EACH t_pago_efectivo :
    IF t_pago_efectivo.libre_char[10] = "" THEN DELETE t_pago_efectivo.
END.

{&open-query-browse-6}

SESSION:SET-WAIT-STATE("").


END PROCEDURE.

/*
        CREATE t_pago_efectivo.
            ASSIGN t_pago_efectivo.codcia = s-codcia
                t_pago_efectivo.orden_comercio = cValor.

        /* CIP */
        cRange = "A" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.nro_cip = cValor.

        /* Monto */
        cRange = "H" + cColumn.
        cValor = TRIM(chWorkSheet:Range(cRange):TEXT).
        cValor = REPLACE(cValor,",","").
        cValor = REPLACE(cValor,"S/","").
        
        dValor = DECIMAL(cValor).
        ASSIGN t_pago_efectivo.monto = dvalor

        /* Fecha emision */
        cRange = "J" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        fValor = DATE(cValor) NO-ERROR.
        ASSIGN t_pago_efectivo.fecha_emision = fValor.

        /* Fecha cancelacion */
        cRange = "L" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        fValor = DATE(cValor) NO-ERROR.
        ASSIGN t_pago_efectivo.fecha_cancelacion = fValor.

        /* Origen */
        cRange = "M" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.origen_cancelacion = cValor.
        
        /* Agencia */
        cRange = "N" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.agencia = cValor.

        /* Cliente_nombre */
        cRange = "O" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.cliente_nombre = cValor.

        /* Cliente_apellido */
        cRange = "P" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.cliente_Apellido = cValor.

        /* Tipo documento */
        cRange = "R" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.tipo_docmnto = cValor.

        /* nro documento */
        cRange = "S" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.nro_docmnto = cValor.

        /* Concepto Pago */
        cRange = "V" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.concepto_pago = cValor.


*/

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
  {src/adm/template/snd-list.i "t_pago_efectivo"}

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

    lMensajeAlTerminar = NO. /*  */
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

    DEFINE VAR x-registros AS INT.
    DEFINE VAR x-registros-validos AS INT.


    SESSION:SET-WAIT-STATE("GENERAL").

    cColumn = STRING(lLinea).
    REPEAT lLinea = 17 TO 65000 :
        cColumn = STRING(lLinea).

        cRange = "B" + cColumn.
        xCaso = chWorkSheet:Range(cRange):TEXT.

        IF xCaso = "" OR xCaso = ? THEN LEAVE.    /* FIN DE DATOS */

        x-registros = x-registros + 1.

        /* Orden */
        cRange = "E" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        IF cValor = "" OR cValor = ? THEN NEXT.
        IF LENGTH(cValor) < 2 THEN NEXT.

        /* Valido Cod Orden si existe */
        FIND FIRST pago_efectivo WHERE pago_efectivo.codcia = s-codcia AND
                                            pago_efectivo.orden_comercio = cvalor NO-LOCK NO-ERROR.

        IF AVAILABLE pago_efectivo THEN NEXT.

        FIND FIRST t_pago_efectivo WHERE t_pago_efectivo.codcia = s-codcia AND
                                            t_pago_efectivo.orden_comercio = cvalor NO-LOCK NO-ERROR.

        IF AVAILABLE t_pago_efectivo THEN NEXT.


        CREATE t_pago_efectivo.
            ASSIGN t_pago_efectivo.codcia = s-codcia
                t_pago_efectivo.orden_comercio = cValor.

        x-registros-validos = x-registros-validos + 1.

        /* CIP */
        cRange = "B" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.nro_cip = cValor.

        /* Monto */
        cRange = "I" + cColumn.
        cValor = TRIM(chWorkSheet:Range(cRange):TEXT).
        cValor = REPLACE(cValor,",","").
        cValor = REPLACE(cValor,"S/","").
        
        dValor = DECIMAL(cValor).
        ASSIGN t_pago_efectivo.monto = dvalor

        /* Fecha emision */
        cRange = "K" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        fValor = DATE(cValor) NO-ERROR.
        ASSIGN t_pago_efectivo.fecha_emision = fValor.

        /* Fecha cancelacion */
        cRange = "M" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        fValor = DATE(cValor) NO-ERROR.
        ASSIGN t_pago_efectivo.fecha_cancelacion = fValor.

        /* Origen */
        cRange = "N" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.origen_cancelacion = cValor.
        
        /* Agencia */
        cRange = "O" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.agencia = cValor.

        /* Cliente_nombre */
        cRange = "P" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.cliente_nombre = cValor.

        /* Cliente_apellido */
        cRange = "Q" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.cliente_Apellido = cValor.

        /* Tipo documento */
        cRange = "S" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.tipo_docmnto = cValor.

        /* nro documento */
        cRange = "T" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.nro_docmnto = cValor.

        /* Concepto Pago */
        cRange = "W" + cColumn.
        cValor = trim(chWorkSheet:Range(cRange):TEXT).
        ASSIGN t_pago_efectivo.concepto_pago = cValor.

    END.    
    {&open-query-browse-6}

    SESSION:SET-WAIT-STATE("").

        {lib\excel-close-file.i}


    MESSAGE "Se cargaron " + STRING(x-registros-validos) + " registros" SKIP 
            "del total de " + STRING(x-registros) + " que tiene el Excel"
            VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

