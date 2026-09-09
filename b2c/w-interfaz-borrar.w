&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-INTERFASE LIKE b2c-interfase.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

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
&Scoped-define INTERNAL-TABLES T-INTERFASE

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-INTERFASE.Fecha_de_Proceso ~
T-INTERFASE.Tipo_Operacion T-INTERFASE.Tarjeta T-INTERFASE.Tipo_Tarjeta ~
T-INTERFASE.Moneda T-INTERFASE.Importe T-INTERFASE.Estado ~
T-INTERFASE.Autorizacion T-INTERFASE.Id_Unico T-INTERFASE.Pedido_Cliente 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-INTERFASE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-INTERFASE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-INTERFASE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-INTERFASE


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Niubiz BUTTON-Grabar BROWSE-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Grabar 
     LABEL "GRABAR IMPORTACION" 
     SIZE 25 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-Niubiz 
     LABEL "IMPORTAR NIUBIZ" 
     SIZE 19 BY 1.12
     FONT 6.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-INTERFASE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-INTERFASE.Fecha_de_Proceso COLUMN-LABEL "Fecha de!Proceso" FORMAT "99/99/9999":U
            WIDTH 8.43
      T-INTERFASE.Tipo_Operacion COLUMN-LABEL "Tipo de!Operacion" FORMAT "x(10)":U
            WIDTH 8.43
      T-INTERFASE.Tarjeta FORMAT "x(20)":U
      T-INTERFASE.Tipo_Tarjeta COLUMN-LABEL "Tipo Tarjeta" FORMAT "x(20)":U
            WIDTH 10.86
      T-INTERFASE.Moneda FORMAT "x(8)":U
      T-INTERFASE.Importe FORMAT "->>>,>>>,>>9.99":U
      T-INTERFASE.Estado FORMAT "x(15)":U
      T-INTERFASE.Autorizacion FORMAT "x(10)":U
      T-INTERFASE.Id_Unico COLUMN-LABEL "Id Unico" FORMAT "x(20)":U
      T-INTERFASE.Pedido_Cliente COLUMN-LABEL "Pedido Cliente" FORMAT "x(20)":U
            WIDTH 15.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 116 BY 21
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Niubiz AT ROW 1.27 COL 3 WIDGET-ID 2
     BUTTON-Grabar AT ROW 1.27 COL 24 WIDGET-ID 4
     BROWSE-2 AT ROW 2.62 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 180.14 BY 22.69
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-INTERFASE T "?" ? INTEGRAL b2c-interfase
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR EXCEL - LISTA EXPRESS"
         HEIGHT             = 22.69
         WIDTH              = 118.29
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
/* BROWSE-TAB BROWSE-2 BUTTON-Grabar F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-INTERFASE"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-INTERFASE.Fecha_de_Proceso
"Fecha_de_Proceso" "Fecha de!Proceso" ? "date" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-INTERFASE.Tipo_Operacion
"Tipo_Operacion" "Tipo de!Operacion" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.T-INTERFASE.Tarjeta
     _FldNameList[4]   > Temp-Tables.T-INTERFASE.Tipo_Tarjeta
"Tipo_Tarjeta" "Tipo Tarjeta" ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.T-INTERFASE.Moneda
     _FldNameList[6]   = Temp-Tables.T-INTERFASE.Importe
     _FldNameList[7]   = Temp-Tables.T-INTERFASE.Estado
     _FldNameList[8]   = Temp-Tables.T-INTERFASE.Autorizacion
     _FldNameList[9]   > Temp-Tables.T-INTERFASE.Id_Unico
"Id_Unico" "Id Unico" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-INTERFASE.Pedido_Cliente
"Pedido_Cliente" "Pedido Cliente" ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR EXCEL - LISTA EXPRESS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR EXCEL - LISTA EXPRESS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Grabar W-Win
ON CHOOSE OF BUTTON-Grabar IN FRAME F-Main /* GRABAR IMPORTACION */
DO:
  MESSAGE 'Procedemos a grabar la información?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  DEF VAR pMensaje AS CHAR NO-UNDO.
  RUN Grabar (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Niubiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Niubiz W-Win
ON CHOOSE OF BUTTON-Niubiz IN FRAME F-Main /* IMPORTAR NIUBIZ */
DO:
  RUN Importar-Niubiz.
  {&OPEN-QUERY-{&BROWSE-NAME}}
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
  ENABLE BUTTON-Niubiz BUTTON-Grabar BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar W-Win 
PROCEDURE Grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Se actualiza la información si ya está registrada */
/* ------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR cEvento AS CHAR NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-INTERFASE EXCLUSIVE-LOCK WHERE T-INTERFASE.CodCia = s-CodCia:
        FIND FIRST b2c-interfase OF T-INTERFASE NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b2c-interfase THEN DO:
            CREATE b2c-interfase.
            cEvento = "CREATE".
        END.
        ELSE DO:
            {lib/lock-genericov3.i ~
                &Tabla="b2c-interfase" ~
                &Alcance="FIRST" ~
                &Condicion="b2c-interfase.CodCia = T-INTERFASE.CodCia AND ~
                b2c-interfase.Pedido_Cliente = T-INTERFASE.Pedido_Cliente" ~
                &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
                &Accion="RETRY" ~
                &Mensaje="NO" ~
                &txtMensaje="pMensaje" ~
                &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"}
            cEvento = "UPDATE".
            /* RHC 24/06/2020 NO regrabar si ya está cerrado */
            IF b2c-interfase.FlgEst = "C" THEN NEXT.
        END.
        BUFFER-COPY T-INTERFASE 
            EXCEPT 
            T-INTERFASE.FchAprobacion 
            T-INTERFASE.HoraAprobacion 
            T-INTERFASE.FlgEst 
            T-INTERFASE.UsrAprobacion
            TO b2c-interfase NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            b2c-interfase.Dia = TODAY
            b2c-interfase.Hora = STRING(TIME, 'HH:MM:SS')
            b2c-interfase.Usuario = s-user-id
            b2c-interfase.Evento = cEvento.
    END.
    EMPTY TEMP-TABLE T-INTERFASE.
    RELEASE b2c-interfase.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Niubiz W-Win 
PROCEDURE Importar-Niubiz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR lNuevoFile AS LOG NO-UNDO.
DEF VAR lFIleXls   AS CHAR NO-UNDO.
DEF VAR x-Archivo  AS CHAR NO-UNDO.

DEFINE VAR OKpressed AS LOG.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx"
    MUST-EXIST
    TITLE "Seleccione archivo..."
    UPDATE OKpressed.   

IF OKpressed = NO THEN RETURN.
lFileXls = x-Archivo.
lNuevoFile = NO.

{lib/excel-open-file.i}
chExcelApplication:Visible = FALSE.
lMensajeAlTerminar = YES.
lCerrarAlTerminar = YES.

DEF VAR t-Col AS INT NO-UNDO.
DEF VAR t-Row AS INT NO-UNDO.
DEF VAR cValue AS CHAR NO-UNDO.
DEF VAR fValue AS DATE NO-UNDO.
DEF VAR dValue AS DEC  NO-UNDO.

ASSIGN
    t-Col = 0
    t-Row = 3.    
EMPTY TEMP-TABLE T-INTERFASE.
SESSION:SET-WAIT-STATE('GENERAL').
REPEAT:
    ASSIGN
        t-Col = 5
        t-Row = t-Row + 1.      /* 4 */
    t-Col = t-Col + 1.          /* F */
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* ***************************************************************************** */
    /* VERIFICAMOS QUE SEA UNA VENTA */
    /* ***************************************************************************** */
    IF chWorkSheet:Cells(t-Row, 7):VALUE <> "Venta" THEN NEXT.
    /* ***************************************************************************** */
    /* ***************************************************************************** */
    CREATE T-INTERFASE.
    /* Fecha de Proceso */
    ASSIGN
        T-INTERFASE.Fecha_de_Proceso = DATE(cValue)
        NO-ERROR.
    /* Tipo de Operación (G) */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Tipo_Operacion = cValue.
    /* Tarjeta (I) */
    t-Col = t-Col + 2.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Tarjeta = cValue.
    /* Tipo de Tarjeta (K) */
    t-Col = t-Col + 2.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Tipo_Tarjeta = cValue.
    /* Moneda (M) */
    t-Col = t-Col + 2.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Moneda = cValue.
    /* Importe Transaccion(N) */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Importe = DECIMAL(cValue) NO-ERROR.

    /* Comisión (P) */
    t-Col = t-Col + 2.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Comision = DECIMAL(cValue) NO-ERROR.

    /* Neto Abonar (S) */
    t-Col = t-Col + 3.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.neto_abonar = DECIMAL(cValue) NO-ERROR.
    
    /* Estado (T) */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Estado = cValue.

    /* Feha de Abono (U) */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Fecha_Abono = DATE(cValue) NO-ERROR.

    /* Autorizacion (V) */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Autorizacion = cValue.

    /* ID Unico (W) */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Id_Unico = cValue.

    /* Pedido del Cliente (Z) */
    t-Col = t-Col + 3.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Pedido_Cliente = cValue.

    /* Cuenta (AB) */
    t-Col = t-Col + 2.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Cuenta = cValue.

    /* Banco (AC) */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN 
        T-INTERFASE.Banco = cValue.

    /* Valores Calculados */
    ASSIGN
        T-INTERFASE.CodCia = s-CodCia
        T-INTERFASE.CodMon = (IF T-INTERFASE.Moneda <> "Soles" THEN 2 ELSE 1).

END.
SESSION:SET-WAIT-STATE('').
{lib/excel-close-file.i}


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
  {src/adm/template/snd-list.i "T-INTERFASE"}

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

