&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TDMOV NO-UNDO LIKE Almdmov
       FIELD Observ LIKE Almcmov.Observ
       FIELD Usuario LIKE Almcmov.Usuario
       FIELD NroRf1 LIKE Almcmov.NroRf1
       FIELD NroRf2 LIKE Almcmov.NroRf2.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */

/* VARIABLES GENERALES DEL EXCEL */
DEFINE VARIABLE FILL-IN-Archivo AS CHAR         NO-UNDO.
DEFINE VARIABLE OKpressed       AS LOG          NO-UNDO.
DEFINE VARIABLE chExcelApplication          AS COM-HANDLE.
DEFINE VARIABLE chWorkbook                  AS COM-HANDLE.
DEFINE VARIABLE chWorksheet                 AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE pMensaje        AS CHAR         NO-UNDO.

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
&Scoped-define INTERNAL-TABLES TDMOV Almmmatg

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 TDMOV.codmat Almmmatg.DesMat ~
Almmmatg.DesMar TDMOV.CodUnd TDMOV.CanDes TDMOV.Factor 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH TDMOV NO-LOCK, ~
      EACH Almmmatg OF TDMOV NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH TDMOV NO-LOCK, ~
      EACH Almmmatg OF TDMOV NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 TDMOV Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 TDMOV
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-6 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-1 BtnDone BROWSE-6 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_CodAlm FILL-IN_DesAlm ~
FILL-IN_NroSer FILL-IN_NroDoc FILL-IN_FchDoc FILL-IN_AlmDes FILL-IN_DesDes ~
FILL-IN_NroRf1 FILL-IN_Observ FILL-IN_NroRf2 FILL-IN_usuario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "IMPORTAR EXCEL" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GRABAR MOVIMIENTO" 
     SIZE 19 BY 1.12.

DEFINE VARIABLE FILL-IN_AlmDes AS CHARACTER FORMAT "x(3)" 
     LABEL "Almacén Origen" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodAlm AS CHARACTER FORMAT "x(3)" 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesAlm AS CHARACTER FORMAT "x(254)" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesDes AS CHARACTER FORMAT "x(3)" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc AS DATE FORMAT "99/99/9999" INITIAL 02/17/14 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS INTEGER FORMAT "999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroRf1 AS CHARACTER FORMAT "x(10)" 
     LABEL "Referencia 1" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroRf2 AS CHARACTER FORMAT "x(10)" 
     LABEL "Referencia 2" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroSer AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "No. Documento" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Observ AS CHARACTER FORMAT "X(50)" 
     LABEL "Observaciones" 
     VIEW-AS FILL-IN 
     SIZE 37.14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_usuario AS CHARACTER FORMAT "x(8)" 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 93 BY 5.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      TDMOV, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 W-Win _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      TDMOV.codmat COLUMN-LABEL "Codigo!Articulo" FORMAT "X(6)":U
            WIDTH 6.43
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 41.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      TDMOV.CodUnd COLUMN-LABEL "Unidad" FORMAT "X(10)":U WIDTH 7.57
      TDMOV.CanDes FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U WIDTH 9.43
      TDMOV.Factor FORMAT "ZZZ,ZZZ,ZZ9.9999":U WIDTH 7.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 93 BY 10.19
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1 COL 2 WIDGET-ID 44
     BUTTON-2 AT ROW 1 COL 17 WIDGET-ID 46
     BtnDone AT ROW 1 COL 88 WIDGET-ID 48
     FILL-IN_CodAlm AT ROW 2.54 COL 12 COLON-ALIGNED HELP
          "Código de almacén" WIDGET-ID 22
     FILL-IN_DesAlm AT ROW 2.54 COL 17 COLON-ALIGNED HELP
          "Código de almacén" NO-LABEL WIDGET-ID 38
     FILL-IN_NroSer AT ROW 3.5 COL 12 COLON-ALIGNED WIDGET-ID 32
     FILL-IN_NroDoc AT ROW 3.5 COL 16 COLON-ALIGNED HELP
          "Número de documento" NO-LABEL WIDGET-ID 26
     FILL-IN_FchDoc AT ROW 3.5 COL 73 COLON-ALIGNED HELP
          "Fecha de documento" WIDGET-ID 24
     FILL-IN_AlmDes AT ROW 4.46 COL 12 COLON-ALIGNED HELP
          "Almacén destino" WIDGET-ID 20
     FILL-IN_DesDes AT ROW 4.46 COL 17 COLON-ALIGNED HELP
          "Almacén destino" NO-LABEL WIDGET-ID 40
     FILL-IN_NroRf1 AT ROW 4.46 COL 73 COLON-ALIGNED HELP
          "Número de referencia 1" WIDGET-ID 28
     FILL-IN_Observ AT ROW 5.42 COL 12 COLON-ALIGNED HELP
          "Observaciones" WIDGET-ID 34
     FILL-IN_NroRf2 AT ROW 5.42 COL 73 COLON-ALIGNED HELP
          "Número de referencia 2" WIDGET-ID 30
     FILL-IN_usuario AT ROW 6.38 COL 12 COLON-ALIGNED WIDGET-ID 36
     BROWSE-6 AT ROW 7.54 COL 2 WIDGET-ID 200
     RECT-1 AT ROW 2.35 COL 2 WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.72 BY 17
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: TDMOV T "?" NO-UNDO INTEGRAL Almdmov
      ADDITIONAL-FIELDS:
          FIELD Observ LIKE Almcmov.Observ
          FIELD Usuario LIKE Almcmov.Usuario
          FIELD NroRf1 LIKE Almcmov.NroRf1
          FIELD NroRf2 LIKE Almcmov.NroRf2
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR EXCEL DE INGRESO POR TRANSFERENCIA"
         HEIGHT             = 17
         WIDTH              = 96.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 96.72
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 96.72
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
/* BROWSE-TAB BROWSE-6 FILL-IN_usuario F-Main */
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_AlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroRf1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroRf2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroSer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Observ IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_usuario IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.TDMOV,INTEGRAL.Almmmatg OF Temp-Tables.TDMOV"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.TDMOV.codmat
"TDMOV.codmat" "Codigo!Articulo" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "41.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.TDMOV.CodUnd
"TDMOV.CodUnd" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.TDMOV.CanDes
"TDMOV.CanDes" ? ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.TDMOV.Factor
"TDMOV.Factor" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR EXCEL DE INGRESO POR TRANSFERENCIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR EXCEL DE INGRESO POR TRANSFERENCIA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
    /* RUTINA GENERAL */
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.

    /* CREAMOS LA HOJA EXCEL */
    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').

    /* CERRAMOS EL EXCEL */
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    /* Mensaje de error de carga */
    IF pMensaje <> "" THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    ASSIGN
        BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO
        BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR MOVIMIENTO */
DO:
    RUN Grabar.
    ASSIGN
        BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES
        BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cNombreLista AS CHAR NO-UNDO.

ASSIGN
    t-Column = 0
    t-Row = 1.    
/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
IF NOT cValue = "CONTINENTAL - INGRESO POR TRANSFERENCIA" THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
cNombreLista = cValue.
/* ******************* */
ASSIGN
    t-Row    = t-Row + 1
    t-column = t-Column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "ALMACEN" THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

EMPTY TEMP-TABLE TDMOV.
ASSIGN
    pMensaje = ""
    t-Row = 2.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* ALMACEN */
    CREATE TDMOV.
    ASSIGN
        TDMOV.codcia = s-codcia
        TDMOV.tipmov = "I"
        TDMOV.codmov = 03
        TDMOV.codalm = cValue.
    /* SERIE */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.nroser = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "SERIE".
        LEAVE.
    END.
    /* NUMERO */        
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.nrodoc = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "NUMERO".
        LEAVE.
    END.
    /* FECHA */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.fchdoc = DATE(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "FECHA".
        LEAVE.
    END.
    /* ORIGEN */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.almori = cValue.
    /* OBSERVACIONES */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.observ = cValue.
    /* USUARIO */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.usuario = cValue.
    /* REFERENCIA 1 */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.nrorf1 = cValue.
    ASSIGN
        TDMOV.nrorf1 = STRING(INTEGER(cValue)) NO-ERROR.
    /* REFERENCIA 2 */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.nrorf2 = cValue.
    ASSIGN
        TDMOV.nrorf2 = STRING(INTEGER(cValue)) NO-ERROR.
    /* ARTICULO */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.codmat = cValue.
    /* CANTIDAD */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.candes = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "CANTIDAD".
        LEAVE.
    END.
    /* UNIDAD */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.codund = cValue.
    /* FACTOR */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        TDMOV.factor = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "FACTOR".
        LEAVE.
    END.
END.
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH TDMOV WHERE TDMOV.codalm <> s-codalm:
    DELETE TDMOV.
END.
FIND FIRST TDMOV NO-LOCK NO-ERROR.
IF NOT AVAILABLE TDMOV THEN DO:
    pMensaje = 'NO hay registros'.
END.
IF pMensaje <> "" THEN DO:
    RETURN.
END.

DISPLAY
    TDMOV.almori @ FILL-IN_AlmDes 
    TDMOV.codalm @ FILL-IN_CodAlm 
    TDMOV.fchdoc @ FILL-IN_FchDoc 
    TDMOV.nrodoc @ FILL-IN_NroDoc 
    TDMOV.nrorf1 @ FILL-IN_NroRf1 
    TDMOV.nrorf2 @ FILL-IN_NroRf2 
    TDMOV.nroser @ FILL-IN_NroSer 
    TDMOV.observ @ FILL-IN_Observ 
    TDMOV.usuario @ FILL-IN_usuario
    WITH FRAME {&FRAME-NAME}.

{&OPEN-QUERY-{&BROWSE-NAME}}


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
  DISPLAY FILL-IN_CodAlm FILL-IN_DesAlm FILL-IN_NroSer FILL-IN_NroDoc 
          FILL-IN_FchDoc FILL-IN_AlmDes FILL-IN_DesDes FILL-IN_NroRf1 
          FILL-IN_Observ FILL-IN_NroRf2 FILL-IN_usuario 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 BUTTON-1 BtnDone BROWSE-6 
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
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR r-Rowid AS ROWID NO-UNDO.

FIND FIRST TDMOV NO-LOCK NO-ERROR.
IF NOT AVAILABLE TDMOV THEN RETURN.

ASSIGN FRAME {&FRAME-NAME}
    FILL-IN_AlmDes FILL-IN_CodAlm FILL-IN_DesAlm FILL-IN_DesDes 
    FILL-IN_FchDoc FILL-IN_NroDoc FILL-IN_NroRf1 FILL-IN_NroRf2 
    FILL-IN_NroSer FILL-IN_Observ FILL-IN_usuario.

DISABLE TRIGGERS FOR LOAD OF Almcmov.
DISABLE TRIGGERS FOR LOAD OF Almdmov.

FIND Almcmov WHERE Almcmov.CodCia = s-codcia
    AND Almcmov.CodAlm = s-codalm
    AND Almcmov.Tipmov = "I"
    AND Almcmov.CodMov = 03
    AND Almcmov.NroSer = FILL-IN_NroSer
    AND Almcmov.NroDoc = FILL-IN_NroDoc 
    NO-LOCK NO-ERROR.
IF AVAILABLE Almcmov THEN DO:
    MESSAGE 'Movimiento YA registrado en almacén' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE Almcmov.
    ASSIGN
        Almcmov.CodCia = s-codcia
        Almcmov.CodAlm = s-codalm
        Almcmov.Tipmov = "I"
        Almcmov.CodMov = 03
        Almcmov.NroSer = FILL-IN_NroSer
        Almcmov.NroDoc = FILL-IN_NroDoc 
        Almcmov.AlmDes = FILL-IN_AlmDes
        Almcmov.FchDoc = FILL-IN_FchDoc
        Almcmov.NroRf1 = FILL-IN_NroRf1
        Almcmov.NroRf2 = FILL-IN_NroRf2
        Almcmov.Observ = FILL-IN_Observ
        Almcmov.usuario = FILL-IN_usuario.
    FOR EACH TDMOV:
        CREATE Almdmov.
        BUFFER-COPY TDMOV TO Almdmov.
        DELETE TDMOV.
        /* ACTUALIZAMOS STOCKS POR ALMACEN */
        R-ROWID = ROWID(Almdmov).
        RUN ALM\ALMACSTK (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        RUN alm/almacpr1 (R-ROWID, 'U').
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.
CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
{&OPEN-QUERY-{&BROWSE-NAME}}

RETURN 'OK'.

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
  {src/adm/template/snd-list.i "TDMOV"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

