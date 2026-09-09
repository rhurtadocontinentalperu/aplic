&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-PL-PERS LIKE PL-PERS.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cb-codcia AS INTE.

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
&Scoped-define INTERNAL-TABLES t-PL-PERS PL-TABLA

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-PL-PERS.codper t-PL-PERS.lmilit ~
t-PL-PERS.TpoDocId PL-TABLA.Nombre t-PL-PERS.NroDocId t-PL-PERS.nomper ~
t-PL-PERS.patper t-PL-PERS.matper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-PL-PERS NO-LOCK, ~
      FIRST PL-TABLA WHERE PL-TABLA.Codigo = t-PL-PERS.TpoDocId ~
      AND PL-TABLA.CodCia = 0 ~
 AND PL-TABLA.Tabla = "03" OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-PL-PERS NO-LOCK, ~
      FIRST PL-TABLA WHERE PL-TABLA.Codigo = t-PL-PERS.TpoDocId ~
      AND PL-TABLA.CodCia = 0 ~
 AND PL-TABLA.Tabla = "03" OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-PL-PERS PL-TABLA
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-PL-PERS
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 PL-TABLA


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON_Import BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Archivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON_Actualizar 
     LABEL "ACTUALIZAR PROGRESS" 
     SIZE 27 BY 1.12.

DEFINE BUTTON BUTTON_Import 
     LABEL "IMPORTAR EXCEL" 
     SIZE 17 BY 1.12.

DEFINE VARIABLE FILL-IN_Archivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo Excel" 
     VIEW-AS FILL-IN 
     SIZE 77 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-PL-PERS, 
      PL-TABLA SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-PL-PERS.codper COLUMN-LABEL "Código!PROGRESS" FORMAT "X(12)":U
      t-PL-PERS.lmilit COLUMN-LABEL "Código!ALVISOFT" FORMAT "X(12)":U
            WIDTH 12.43
      t-PL-PERS.TpoDocId COLUMN-LABEL "Tipo Doc. Ident." FORMAT "x(8)":U
      PL-TABLA.Nombre COLUMN-LABEL "Descripción" FORMAT "x(40)":U
            WIDTH 30
      t-PL-PERS.NroDocId COLUMN-LABEL "Nro. Doc. Identi." FORMAT "x(15)":U
      t-PL-PERS.nomper FORMAT "X(40)":U WIDTH 20
      t-PL-PERS.patper FORMAT "X(40)":U WIDTH 30
      t-PL-PERS.matper FORMAT "X(40)":U WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 161 BY 20.73
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON_Import AT ROW 1.27 COL 14 WIDGET-ID 2
     BUTTON_Actualizar AT ROW 2.35 COL 123 WIDGET-ID 6
     FILL-IN_Archivo AT ROW 2.62 COL 12 COLON-ALIGNED WIDGET-ID 4
     BROWSE-2 AT ROW 3.96 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 164.29 BY 24.19
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-PL-PERS T "?" ? INTEGRAL PL-PERS
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR PERSONAL"
         HEIGHT             = 24.19
         WIDTH              = 164.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN_Archivo F-Main */
/* SETTINGS FOR BUTTON BUTTON_Actualizar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Archivo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-PL-PERS,INTEGRAL.PL-TABLA WHERE Temp-Tables.t-PL-PERS ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _JoinCode[2]      = "INTEGRAL.PL-TABLA.Codigo = Temp-Tables.t-PL-PERS.TpoDocId"
     _Where[2]         = "INTEGRAL.PL-TABLA.CodCia = 0
 AND INTEGRAL.PL-TABLA.Tabla = ""03"""
     _FldNameList[1]   > Temp-Tables.t-PL-PERS.codper
"t-PL-PERS.codper" "Código!PROGRESS" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-PL-PERS.lmilit
"t-PL-PERS.lmilit" "Código!ALVISOFT" "X(12)" "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-PL-PERS.TpoDocId
"t-PL-PERS.TpoDocId" "Tipo Doc. Ident." "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PL-TABLA.Nombre
"PL-TABLA.Nombre" "Descripción" ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-PL-PERS.NroDocId
"t-PL-PERS.NroDocId" "Nro. Doc. Identi." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-PL-PERS.nomper
"t-PL-PERS.nomper" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-PL-PERS.patper
"t-PL-PERS.patper" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-PL-PERS.matper
"t-PL-PERS.matper" ? ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR PERSONAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR PERSONAL */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Actualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Actualizar W-Win
ON CHOOSE OF BUTTON_Actualizar IN FRAME F-Main /* ACTUALIZAR PROGRESS */
DO:
  MESSAGE 'Procedemos a ctualizar la base de datos?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Actualizar-Progress.
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
  EMPTY TEMP-TABLE t-pl-pers.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  FILL-IN_Archivo = "".
  DISPLAY FILL-IN_Archivo WITH FRAME {&FRAME-NAME}.
  BUTTON_Actualizar:SENSITIVE = NO.
  BUTTON_Import:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Import W-Win
ON CHOOSE OF BUTTON_Import IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
  DEF VAR rpta AS LOG NO-UNDO.

  SYSTEM-DIALOG GET-FILE FILL-IN_Archivo
      FILTERS "*.xlsx,*xls" "*.xlsx,*xls"
      INITIAL-FILTER 1
      TITLE "Seleccione el archivo Excel"
      UPDATE rpta.
  IF rpta = NO THEN RETURN NO-APPLY.
  DISPLAY FILL-IN_Archivo WITH FRAME {&FRAME-NAME}.

  DEF VAR pcReturn AS CHAR NO-UNDO.

  RUN Carga-Temporal (INPUT FILL-IN_Archivo, OUTPUT pcReturn).
  IF pcReturn > '' THEN DO:
      MESSAGE pcReturn VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  BUTTON_Actualizar:SENSITIVE = YES.
  BUTTON_Import:SENSITIVE = NO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualizar-Contabilidad W-Win 
PROCEDURE Actualizar-Contabilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CodAux AS CHAR NO-UNDO.              
DEF VAR x-NomAux AS CHAR NO-UNDO.
DEF VAR x-ClfAux LIKE cb-auxi.clfaux INIT 'PE' NO-UNDO.
DEF VAR l-Existe   AS LOGICAL NO-UNDO.

ASSIGN
    x-NomAux = TRIM(PL-PERS.patper) + ' ' + TRIM(PL-PERS.matper) + ', ' + TRIM(PL-PERS.nomper)
    x-CodAux = PL-PERS.CodPer.

/* 1. Verificación rápida de existencia con un FIND AMBIGUOUS/NO-LOCK acotado */
l-Existe = CAN-FIND(cb-auxi WHERE cb-auxi.codcia = cb-codcia
                             AND cb-auxi.clfaux = x-clfaux
                             AND cb-auxi.codaux = x-codaux).

/* Bloque transaccional único */
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":

    IF l-Existe THEN DO:
        /* 2. Si el registro EXISTE, llamamos al include para bloquearlo de forma segura */
        {lib/lock-genericov3.i ~
            &Tabla="cb-auxi" ~
            &Condicion="cb-auxi.codcia = cb-codcia AND cb-auxi.clfaux = x-clfaux AND cb-auxi.codaux = x-codaux" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    END.
    ELSE DO:
        /* 3. Si NO EXISTE, lo creamos directamente (Progress le asigna EXCLUSIVE-LOCK por defecto) */
        CREATE cb-auxi.
        ASSIGN
            cb-auxi.codcia = cb-codcia
            cb-auxi.clfaux = x-clfaux
            cb-auxi.codaux = x-codaux.
    END.

    /* 4. Asignación de campos comunes */
    ASSIGN 
        cb-auxi.nomaux = x-nomaux.

END. /* Fin de la transacción: se confirma en la BD y se liberan los bloqueos */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualizar-Progress W-Win 
PROCEDURE Actualizar-Progress :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH t-pl-pers NO-LOCK:
    FIND FIRST pl-pers WHERE pl-pers.codper = t-pl-pers.codper NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        CREATE pl-pers.
        BUFFER-COPY t-pl-pers TO pl-pers NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN UNDO, NEXT.
        RUN Actualizar-Contabilidad.
        /* Si hay error NO lo controlamos */
    END.
    ELSE DO:
        FIND CURRENT pl-pers EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN UNDO, NEXT.
        ASSIGN pl-pers.lmilit = t-pl-pers.lmilit.
    END.
END.
IF AVAILABLE pl-pers THEN RELEASE pl-pers.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pcArchivoExcel AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pcReturn AS CHAR NO-UNDO.


/* Determinamos si exite el archivo */
DEFINE VARIABLE cFoundPath AS CHARACTER NO-UNDO.

/* Usa SEARCH para verificar la existencia del archivo */
ASSIGN cFoundPath = SEARCH(pcArchivoExcel).

IF TRUE <> (cFoundPath > '') THEN DO:
    pcReturn = "Error: " + "El archivo NO existe en la ruta: " + pcArchivoExcel.
    RETURN.
END.

DEFINE VARIABLE chExcelApplication          AS COM-HANDLE.
DEFINE VARIABLE chWorkbook                  AS COM-HANDLE.
DEFINE VARIABLE chWorksheet                 AS COM-HANDLE.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(pcArchivoExcel).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

SESSION:SET-WAIT-STATE('GENERAL').

ASSIGN
    t-Column = 0
    t-Row = 1.    
/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    pcReturn = "Error: " + 'Formato del archivo Excel errado'.
    RETURN.
END.

DEF VAR cCodPer AS CHAR NO-UNDO.
DEF VAR cTpoDocId AS CHAR NO-UNDO.
DEF VAR cNroDocId AS CHAR NO-UNDO.
DEF VAR cNombre AS CHAR NO-UNDO.
DEF VAR dFchIng AS DATE NO-UNDO.
DEF VAR dFchCese AS DATE NO-UNDO.
DEF VAR cPatPer AS CHAR NO-UNDO.
DEF VAR cMatPer AS CHAR NO-UNDO.
DEF VAR cNomPer AS CHAR NO-UNDO.
DEF VAR iInicio AS INTE NO-UNDO.
DEF VAR x-CodAux AS CHAR NO-UNDO.

EMPTY TEMP-TABLE t-pl-pers.
DEF BUFFER B-Pers FOR pl-pers.

ASSIGN
    t-Row = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-Row    = t-Row + 1.
    /* CODIGO */
    t-column = 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    cCodPer = cValue.
    /* Tipo de documento */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    CASE cValue:
        WHEN "DOC. NACIONAL DE IDENTIDAD" THEN cTpoDocId = "01".
        WHEN "CARNÉ DE EXTRANJERÍA" THEN cTpoDocId = "04".
        WHEN "REG. UNICO DE CONTRIBUYENTES" THEN cTpoDocId = "06".
        WHEN "PASAPORTE" THEN cTpoDocId = "07".
        WHEN "PARTIDA DE NACIMIENTO" THEN cTpoDocId = "11".
        OTHERWISE cTpoDocId = cValue.
    END CASE.
    /* Nro. de documento */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    cNroDocId = cValue.
    /* Trabajador */
    t-Column = t-Column + 1.
    cValue = TRIM(chWorkSheet:Cells(t-Row, t-Column):VALUE).
    cNombre = cValue.
    cNomPer = TRIM(ENTRY(2,cNombre,", ")).
    cPatPer = TRIM(ENTRY(1,cNombre," ")).
    cMatPer = "".
    iInicio = LENGTH(cPatPer) + 2. 
    REPEAT:
        cMatPer = cMatPer + SUBSTRING(cNombre,iInicio,1).
        iInicio = iInicio + 1.
        IF SUBSTRING(cNombre,iInicio,1) = ","  THEN LEAVE.
        IF iInicio > 100 THEN LEAVE.
    END.
    /* Fecha de Ingreso */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    dFchIng = DATE(cValue) NO-ERROR.
    /* Fecha de Cese */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    dFchCese = DATE(cValue) NO-ERROR.

    /* VERIFICAMOS LA PLANILLA CONTINENTAL */
    FIND FIRST pl-pers WHERE pl-pers.tpodocid = cTpoDocId AND pl-pers.nrodocid = cNroDocId NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
        /* Actualizamos Alvisoft */
        CREATE t-pl-pers.
        BUFFER-COPY pl-pers TO t-pl-pers NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN UNDO, NEXT.
        t-pl-pers.lmilit = cCodPer.
    END.
    ELSE DO:
        FIND LAST B-Pers WHERE B-Pers.CodPer > "" AND INTEGER(B-Pers.CodPer) < 999998
            NO-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE B-Pers THEN x-CodAux = '000001'.
        ELSE x-CodAux = STRING(INTEGER(B-Pers.CodPer) + 1, '999999').
        /* Qué pasa si ya está registrado en el temporal */
        REPEAT:
            FIND FIRST t-pl-pers WHERE t-pl-pers.codcia = s-codcia 
                AND t-pl-pers.codper = x-CodAux
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE t-pl-pers THEN LEAVE.
            x-CodAux = STRING(INTEGER(x-CodAux) + 1, '999999').
        END.
        /* ********************************************* */
        CREATE t-pl-pers.
        ASSIGN
            t-pl-pers.codcia = s-codcia
            t-pl-pers.codper = x-CodAux
            t-pl-pers.tpodocid = cTpoDocId
            t-pl-pers.nrodocid = cNroDocId
            t-pl-pers.nomper = cNomPer
            t-pl-pers.patper = cPatPer
            t-pl-pers.matper = cMatPer
            t-pl-pers.lmilit = cCodPer
            NO-ERROR
            .
        IF ERROR-STATUS:ERROR = YES THEN UNDO, NEXT.
    END.
END.
SESSION:SET-WAIT-STATE('').

/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 


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
  DISPLAY FILL-IN_Archivo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON_Import BROWSE-2 
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
  {src/adm/template/snd-list.i "t-PL-PERS"}
  {src/adm/template/snd-list.i "PL-TABLA"}

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

