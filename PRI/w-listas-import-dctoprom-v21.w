&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE A-MATG NO-UNDO LIKE Almmmatg
       INDEX Idx00 AS PRIMARY CodMat.
DEFINE NEW SHARED TEMP-TABLE E-MATG NO-UNDO LIKE Almmmatg
       INDEX Idx00 AS PRIMARY CodMat FchPrmD.
DEFINE NEW SHARED TEMP-TABLE T-DPROM LIKE VtaDctoProm.
DEFINE NEW SHARED TEMP-TABLE T-MATG LIKE Almmmatg
       INDEX Idx00 AS PRIMARY CodMat FchPrmD.



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
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.

DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE k               AS INTEGER NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER NO-UNDO.
DEFINE VARIABLE RADIO-SET-2 AS INTEGER NO-UNDO.

DEF VAR pMensaje AS CHAR NO-UNDO.

/* VARIABLE PARA CONTROL LA ACTUALIZACION DE UNA DIVISION O TODAS LAS DIVISIONES */
DEF VAR x-MetodoActualizacion AS INT INIT 1 NO-UNDO.
/* 
1: Todas las divisiones
2: División seleccionada
*/

DEF VAR f-Division AS CHAR NO-UNDO.
DEF VAR f-FechaD AS DATE NO-UNDO FORMAT '99/99/9999'.
DEF VAR f-FechaH AS DATE NO-UNDO FORMAT '99/99/9999'.

DEF TEMP-TABLE TT-MATG LIKE T-MATG.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 BtnDone BUTTON-1 TOGGLE-Reemplazar 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-Reemplazar txtCodMat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_t-listas-import-dctoprom-det AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-listas-import-dctoprom-v2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "CAPTURAR EXCEL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GRABAR DESCUENTOS" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE txtCodMat AS CHARACTER FORMAT "X(10)":U 
     LABEL "Art" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 141 BY 1.92
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE TOGGLE-Reemplazar AS LOGICAL INITIAL no 
     LABEL "REEMPLAZAR PROMOCIONES" 
     VIEW-AS TOGGLE-BOX
     SIZE 55 BY .77
     BGCOLOR 11 FGCOLOR 0 FONT 8 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.19 COL 132 WIDGET-ID 6
     BUTTON-1 AT ROW 1.38 COL 82 WIDGET-ID 2
     BUTTON-2 AT ROW 1.38 COL 107 WIDGET-ID 4
     TOGGLE-Reemplazar AT ROW 1.54 COL 18 WIDGET-ID 36
     txtCodMat AT ROW 17.73 COL 95 COLON-ALIGNED WIDGET-ID 34
     RECT-3 AT ROW 1 COL 1 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141.14 BY 21.08 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: A-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY CodMat
      END-FIELDS.
      TABLE: E-MATG T "NEW SHARED" NO-UNDO INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY CodMat FchPrmD
      END-FIELDS.
      TABLE: T-DPROM T "NEW SHARED" ? INTEGRAL VtaDctoProm
      TABLE: T-MATG T "NEW SHARED" ? INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY CodMat FchPrmD
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR DESCUENTOS PROMOCIONALES - MAYORISTA y  POR DIVISION"
         HEIGHT             = 21.08
         WIDTH              = 141.14
         MAX-HEIGHT         = 21.54
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 21.54
         VIRTUAL-WIDTH      = 142.29
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
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtCodMat IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR DESCUENTOS PROMOCIONALES - MAYORISTA y  POR DIVISION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR DESCUENTOS PROMOCIONALES - MAYORISTA y  POR DIVISION */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CAPTURAR EXCEL */
DO:
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls)" "*.xls,*xlsx", "Todos (*.*)" "*.*"
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
    pMensaje = ''.
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
        BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    MESSAGE 'Carga terminada' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR DESCUENTOS */
DO:
    ASSIGN TOGGLE-Reemplazar.

    DEF VAR pMensaje AS CHAR NO-UNDO.
    RUN Grabar-Descuentos (OUTPUT pMensaje).

    IF h_t-listas-import-dctoprom-v2 <> ? THEN RUN dispatch IN h_t-listas-import-dctoprom-v2 ('open-query':U).
    IF h_t-listas-import-dctoprom-det <> ? THEN RUN dispatch IN h_t-listas-import-dctoprom-det ('open-query':U).

    ASSIGN
        BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES
        BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    RUN Excel-de-Errores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PRI/t-listas-import-dctoprom-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-listas-import-dctoprom-v2 ).
       RUN set-position IN h_t-listas-import-dctoprom-v2 ( 2.92 , 1.00 ) NO-ERROR.
       RUN set-size IN h_t-listas-import-dctoprom-v2 ( 19.04 , 87.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PRI/t-listas-import-dctoprom-det-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-listas-import-dctoprom-det ).
       RUN set-position IN h_t-listas-import-dctoprom-det ( 2.92 , 88.00 ) NO-ERROR.
       RUN set-size IN h_t-listas-import-dctoprom-det ( 12.88 , 50.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-listas-import-dctoprom-det. */
       RUN add-link IN adm-broker-hdl ( h_t-listas-import-dctoprom-v2 , 'Record':U , h_t-listas-import-dctoprom-det ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-listas-import-dctoprom-v2 ,
             TOGGLE-Reemplazar:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-listas-import-dctoprom-det ,
             h_t-listas-import-dctoprom-v2 , 'AFTER':U ).
    END. /* Page 1 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
PROCEDURE Carga-Temporal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cNombreLista AS CHAR NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */
cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

IF NOT (cValue BEGINS "CONTINENTAL - DESCUENTOS PROMOCIONALES"
        OR cValue BEGINS "UTILEX - DESCUENTOS PROMOCIONALES"
        OR cValue BEGINS "POR DIVISION - DESCUENTOS PROMOCIONALES"
        )
    THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
cNombreLista = cValue.

ASSIGN
    t-Row    = t-Row + 1
    t-column = t-Column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "CODIGO" THEN DO:
    pmensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
t-column = t-column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "DESCRIPCION" THEN DO:
    pMensaje =  'Formato del archivo Excel errado'.
    RETURN.
END.

CASE TRUE:
    WHEN cNombreLista BEGINS "CONTINENTAL - DESCUENTOS PROMOCIONALES"  THEN RADIO-SET-1 = 1.
    WHEN cNombreLista BEGINS "UTILEX - DESCUENTOS PROMOCIONALES"       THEN RADIO-SET-1 = 2.
    WHEN cNombreLista BEGINS "POR DIVISION - DESCUENTOS PROMOCIONALES" THEN RADIO-SET-1 = 3.
    OTHERWISE RETURN.
END CASE.
CASE TRUE:
    WHEN INDEX(cNombreLista, "- PORCENTAJES") > 0 THEN RADIO-SET-2 = 1.
    WHEN INDEX(cNombreLista, "- IMPORTES") > 0 THEN RADIO-SET-2 = 2.
    OTHERWISE RETURN.
END CASE.
/* Verificamos y Cargamos Divisiones */
DEF VAR x-Division AS CHAR NO-UNDO.
ASSIGN
    t-column = t-column + 7
    f-Division = ""
    x-Division = ""
    f-FechaD = ?
    f-FechaH = ?.
/* Cargamos las divisiones inscritas en la hoja Excel */
REPEAT:
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = cValue
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN DO:
        pMensaje = 'División ' + cValue + ' errada'.
        RETURN.
    END.
    IF TRUE <> (f-Division > "") THEN f-Division = cValue.
    ELSE f-Division = f-Division + ',' + cValue.
END.
/* CONTROL DE UNA O VARIAS DIVISIONES */
x-MetodoActualizacion = 1.  /* Todas */
x-Division = f-Division.
CASE RADIO-SET-1:
    WHEN 1 THEN DO:
        RUN vta2/dutilexdctoprom-02 (INPUT-OUTPUT x-Division, OUTPUT x-MetodoActualizacion).
        IF x-Division = '' THEN RETURN.
    END.
    WHEN 2 THEN DO:
        RUN vta2/dutilexdctoprom-02 (INPUT-OUTPUT x-Division, OUTPUT x-MetodoActualizacion).
        IF x-Division = '' THEN RETURN.
        RUN Pinta-Titulo IN h_t-listas-import-dctoprom-v2 ( "UTILEX - DESCUENTOS PROMOCIONALES - DIVISION ESPECIFICA" ).
    END.
END CASE.
/* ********************************** */

/* Cargamos temporal */
EMPTY TEMP-TABLE T-MATG.
EMPTY TEMP-TABLE T-DPROM.
ASSIGN
    pMensaje = ""
    t-Column = 0
    t-Row = 2.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 

    ASSIGN
        cValue = STRING(DECIMAL(cValue), '999999') NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.

    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = cValue NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "CODIGO".
        LEAVE.
    END.
    FIND T-MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.

    CREATE T-MATG.
    ASSIGN
        T-MATG.codcia = s-codcia
        T-MATG.codmat = cValue.

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.desmat = cValue.
    IF cValue = '' OR cValue = '' THEN DO:
        FIND Almmmatg OF T-MATG NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN T-MATG.desmat = Almmmatg.desmat.
    END.
    
    /* FECHAS */
    t-Column = t-Column + 6.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        f-FechaD = DATE(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Fecha Inicio".
        LEAVE.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        f-FechaH = DATE(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Fecha Fin".
        LEAVE.
    END.
    
    IF f-FechaD <> ? AND f-FechaH <> ? AND f-FechaD > f-FechaH THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Fecha Inicial es mayor que la Fecha Fin".
        LEAVE.
    END.

    /* DESCUENTOS PROMOCIONALES */
    DO iCountLine = 1 TO NUM-ENTRIES(f-Division):
        t-Column = t-Column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = ? OR DECIMAL(cValue) = 0 THEN NEXT.
        /* En caso de seleccionar 1 division */
        IF x-MetodoActualizacion = 2 AND x-Division <> ENTRY(iCountLine, f-Division)  THEN NEXT.     
        CREATE T-DPROM.
        ASSIGN
            T-DPROM.CodCia = s-codcia
            T-DPROM.CodDiv = ENTRY(iCountLine, f-Division) 
            T-DPROM.CodMat = T-MATG.CodMat
            T-DPROM.Descuento = DECIMAL(cValue)
            T-DPROM.FchIni = f-FechaD
            T-DPROM.FchFin = f-FechaH.
    END.
END.
/* EN CASO DE ERROR */
IF pMensaje > "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    RETURN.
END.
f-Division = x-Division.    /* OJO: NOS QUEDAMOS CON UNA O TODAS LAS DIVISIONES */
/* Limpiamos repetidos */
EMPTY TEMP-TABLE TT-MATG.
FOR EACH T-MATG BREAK BY T-MATG.CodMat:
    IF FIRST-OF(T-MATG.CodMat) THEN DO:
        CREATE TT-MATG.
        BUFFER-COPY T-MATG TO TT-MATG.
    END.
END.
EMPTY TEMP-TABLE T-MATG.
FOR EACH TT-MATG:
    CREATE T-MATG.
    BUFFER-COPY TT-MATG TO T-MATG.
END.
/* Cargamos precios actuales */
FOR EACH T-MATG:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        DELETE T-MATG.
        NEXT.
    END.
    IF TRUE <> (T-MATG.DesMat > '') THEN T-MATG.DesMat = Almmmatg.DesMat.
    FIND VtaListaMinGn WHERE VtaListaMinGn.codcia = s-codcia
        AND VtaListaMinGn.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    FIND FIRST VtaListaMay WHERE VtaListaMay.codcia = s-codcia
        AND LOOKUP(VtaListaMay.coddiv, f-Division) > 0
        AND VtaListaMay.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    IF RADIO-SET-1 = 2 AND NOT AVAILABLE VtaListaMinGn THEN DO:
        DELETE T-MATG.
        NEXT.
    END.
    IF RADIO-SET-1 = 3 AND NOT AVAILABLE VtaListaMay   THEN DO:
        DELETE T-MATG.
        NEXT.
    END.
    ASSIGN
        T-MATG.MonVta = Almmmatg.MonVta 
        T-MATG.TpoCmb = Almmmatg.TpoCmb
        T-MATG.CtoTot = Almmmatg.CtoTot
        T-MATG.UndBas = Almmmatg.UndBas
        T-MATG.CHR__02 = Almmmatg.CHR__02.
    CASE RADIO-SET-1:
        WHEN 1 THEN DO:
            ASSIGN
                T-MATG.Chr__01   = Almmmatg.Chr__01 
                T-MATG.PreOfi    = Almmmatg.PreOfi 
                T-MATG.Prevta[1] = Almmmatg.PreVta[1].
        END.
        WHEN 2 THEN DO:
            ASSIGN
                T-MATG.Chr__01   = VtaListaMinGn.Chr__01 
                T-MATG.PreOfi    = VtaListaMinGn.PreOfi 
                T-MATG.Prevta[1] = VtaListaMinGn.PreOfi.
        END.
        WHEN 3 THEN DO:
            ASSIGN
                T-MATG.Chr__01   = VtaListaMay.Chr__01 
                T-MATG.PreOfi    = VtaListaMay.PreOfi 
                T-MATG.Prevta[1] = VtaListaMay.PreOfi.
        END.
    END CASE.
    /* Corregimos de acuerdo al método de cálculo */
    IF RADIO-SET-2 = 1 THEN DO:     /* PORCENTAJES */
        FOR EACH T-DPROM WHERE T-DPROM.CodMat = T-MATG.CodMat:
            T-DPROM.Precio = ROUND(T-MATG.Prevta[1] * ( 1 - ( T-DPROM.Descuento / 100 ) ),4).
        END.
    END.
    IF RADIO-SET-2 = 2 THEN DO:     /* VALORES */
        FOR EACH T-DPROM WHERE T-DPROM.CodMat = T-MATG.CodMat:
            T-DPROM.Precio = T-DPROM.Descuento.
            T-DPROM.Descuento = ROUND ( ( 1 - T-DPROM.Precio / T-MATG.PreVta[1] ) * 100, 4).
        END.
    END.
END.
/* Filtramos solo lineas autorizadas */
FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK:
    FIND Vtatabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = "LP"
        AND Vtatabla.llave_c1 = s-user-id
        AND Vtatabla.llave_c2 = Almmmatg.codfam
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtatabla THEN DELETE T-MATG.
END.
/* ******************************************** */
/* ****** RHC 29/02/2016 NO % negativos ******* */
/* ******************************************** */
CICLO:
FOR EACH T-MATG:
    DO k = 1 TO 10:
        IF T-MATG.PromDto[k] < 0 THEN DO:
            DELETE T-MATG.
            NEXT CICLO.
        END.
    END.
END.
/* ******************************************** */

FIND FIRST T-MATG NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-MATG THEN MESSAGE 'No hay registros que procesar' VIEW-AS ALERT-BOX ERROR.

ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

RUN dispatch IN h_t-listas-import-dctoprom-v2 ('open-query':U).
RUN dispatch IN h_t-listas-import-dctoprom-det ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consistencia W-Win 
PROCEDURE Consistencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-Margen AS DECI NO-UNDO.
DEFINE VAR x-Limite AS DECI NO-UNDO.
DEFINE VAR pError AS CHAR NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.

/* CONSISTENCIA DE DATOS */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    trloop:
    FOR EACH T-MATG EXCLUSIVE-LOCK:
        FOR EACH T-DPROM NO-LOCK WHERE T-DPROM.CodMat = T-MATG.CodMat AND T-DPROM.Descuento <> 0:
            /* ****************************************************************************************************** */
            /* Control Margen de Utilidad */
            /* ****************************************************************************************************** */
            /* 1ro. Calculamos el margen de utilidad */
            RUN PRI_Margen-Utilidad IN hProc (INPUT T-DPROM.CodDiv,
                                              INPUT T-MATG.CodMat,
                                              INPUT T-MATG.CHR__01,
                                              INPUT T-MATG.PreVta[1] * ( 1 - (T-DPROM.Descuento / 100) ),
                                              INPUT T-MATG.MonVta,      /*INPUT 1,*/
                                              OUTPUT x-Margen,
                                              OUTPUT x-Limite,
                                              OUTPUT pError).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                /* Error crítico */
                CREATE E-MATG.
                BUFFER-COPY T-MATG TO E-MATG ASSIGN E-MATG.Libre_c01 = pError.
                DELETE T-MATG.
                NEXT trloop.
            END.
            /* Controlamos si el margen de utilidad está bajo a través de la variable pError */
            IF pError > '' THEN DO:
                /* Error por margen de utilidad */
                /* 2do. Verificamos si solo es una ALERTA, definido por GG */
                DEF VAR pAlerta AS LOG NO-UNDO.
                RUN PRI_Alerta-de-Margen IN hProc (INPUT T-MATG.CodMat, OUTPUT pAlerta).
                IF pAlerta = YES THEN DO:
                    CREATE A-MATG.
                    BUFFER-COPY T-MATG TO A-MATG ASSIGN A-MATG.Libre_c01 = pError.
                END.
                ELSE DO:
                    CREATE E-MATG.
                    BUFFER-COPY T-MATG TO E-MATG ASSIGN E-MATG.Libre_c01 = pError.
                    DELETE T-MATG.
                    NEXT trloop.
                END.
            END.
        END.
    END.
END.
DELETE PROCEDURE hProc.

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
  DISPLAY TOGGLE-Reemplazar txtCodMat 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-3 BtnDone BUTTON-1 TOGGLE-Reemplazar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-de-Errores W-Win 
PROCEDURE Excel-de-Errores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN pri/pri-librerias PERSISTENT SET hProc.
RUN PRI_Excel-Errores IN hProc (INPUT TABLE E-MATG,
                                INPUT TABLE A-MATG).
DELETE PROCEDURE hProc.


/* FIND FIRST E-MATG NO-LOCK NO-ERROR.                                           */
/* FIND FIRST A-MATG NO-LOCK NO-ERROR.                                           */
/* IF NOT AVAILABLE E-MATG AND NOT AVAILABLE A-MATG THEN RETURN.                 */
/* MESSAGE 'Los siguientes producto NO se han actualizado o hay una ALERTA' SKIP */
/*     'Se mostrará una lista en Excel'                                          */
/*     VIEW-AS ALERT-BOX INFORMATION.                                            */
/*                                                                               */
/* DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.                        */
/* DEFINE VARIABLE chWorkbook              AS COM-HANDLE.                        */
/* DEFINE VARIABLE chWorksheet             AS COM-HANDLE.                        */
/* DEFINE VARIABLE chChart                 AS COM-HANDLE.                        */
/* DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.                        */
/* DEFINE VARIABLE cColumn                 AS CHARACTER.                         */
/* DEFINE VARIABLE cRange                  AS CHARACTER.                         */
/* DEFINE VARIABLE t-Column                AS INTEGER INIT 1.                    */
/* DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.                    */
/*                                                                               */
/* /* create a new Excel Application object */                                   */
/* CREATE "Excel.Application" chExcelApplication.                                */
/*                                                                               */
/* /* create a new Workbook */                                                   */
/* chWorkbook = chExcelApplication:Workbooks:Add().                              */
/*                                                                               */
/* /* get the active Worksheet */                                                */
/* chWorkSheet = chExcelApplication:Sheets:Item(1).                              */
/*                                                                               */
/* /* set the column names for the Worksheet */                                  */
/* DEF VAR x-CtoTot LIKE Almmmatg.ctotot NO-UNDO.                                */
/* DEF VAR x-PreVta LIKE Almmmatg.prevta NO-UNDO.                                */
/* DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.                                */
/*                                                                               */
/* ASSIGN                                                                        */
/*     chWorkSheet:Range("A1"):Value = "ERRORES - PRECIOS"                       */
/*     chWorkSheet:Range("A2"):Value = "CODIGO"                                  */
/*     chWorkSheet:Columns("A"):NumberFormat = "@"                               */
/*     chWorkSheet:Range("B2"):Value = "DESCRIPCION"                             */
/*     chWorkSheet:Range("C2"):Value = "ERROR".                                  */
/* ASSIGN                                                                        */
/*     t-Row = 2.                                                                */
/* FOR EACH E-MATG:                                                              */
/*     ASSIGN                                                                    */
/*         t-Column = 0                                                          */
/*         t-Row    = t-Row + 1.                                                 */
/*     ASSIGN                                                                    */
/*         t-Column = t-Column + 1                                               */
/*         chWorkSheet:Cells(t-Row, t-Column):VALUE = E-MATG.codmat.             */
/*     ASSIGN                                                                    */
/*         t-Column = t-Column + 1                                               */
/*         chWorkSheet:Cells(t-Row, t-Column):VALUE = E-MATG.desmat.             */
/*     ASSIGN                                                                    */
/*         t-Column = t-Column + 1                                               */
/*         chWorkSheet:Cells(t-Row, t-Column):VALUE = E-MATG.Libre_c01.          */
/* END.                                                                          */
/* /* 2do ALERTAS */                                                             */
/* /* get the active Worksheet */                                                */
/* chWorkSheet = chExcelApplication:Sheets:Item(2).                              */
/* ASSIGN                                                                        */
/*     chWorkSheet:Range("A1"):Value = "ALERTAS - PRECIOS"                       */
/*     chWorkSheet:Range("A2"):Value = "CODIGO"                                  */
/*     chWorkSheet:Columns("A"):NumberFormat = "@"                               */
/*     chWorkSheet:Range("B2"):Value = "DESCRIPCION"                             */
/*     chWorkSheet:Range("C2"):Value = "ALERTA".                                 */
/* ASSIGN                                                                        */
/*     t-Row = 2.                                                                */
/* FOR EACH A-MATG:                                                              */
/*     ASSIGN                                                                    */
/*         t-Column = 0                                                          */
/*         t-Row    = t-Row + 1.                                                 */
/*     ASSIGN                                                                    */
/*         t-Column = t-Column + 1                                               */
/*         chWorkSheet:Cells(t-Row, t-Column):VALUE = A-MATG.codmat.             */
/*     ASSIGN                                                                    */
/*         t-Column = t-Column + 1                                               */
/*         chWorkSheet:Cells(t-Row, t-Column):VALUE = A-MATG.desmat.             */
/*     ASSIGN                                                                    */
/*         t-Column = t-Column + 1                                               */
/*         chWorkSheet:Cells(t-Row, t-Column):VALUE = A-MATG.Libre_c01.          */
/* END.                                                                          */
/* chExcelApplication:VISIBLE = TRUE.                                            */
/* /* release com-handles */                                                     */
/* RELEASE OBJECT chExcelApplication.                                            */
/* RELEASE OBJECT chWorkbook.                                                    */
/* RELEASE OBJECT chWorksheet.                                                   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Descuentos W-Win 
PROCEDURE Grabar-Descuentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

MESSAGE 'Procedemos a grabar los descuentos promocionales?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN 'OK'.

/* CONSISTENCIA DE DATOS */
RUN Consistencia.

/* LOGICA PRINCIPAL:
    Por cada registro procesado se borra T-MATG y T-DPROM
    Si hay un error pasa al siguiente registro y repinta la pantalla
    */

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.

EMPTY TEMP-TABLE E-MATG.
EMPTY TEMP-TABLE A-MATG.

RLOOP:
FOR EACH T-MATG EXCLUSIVE-LOCK:
    /* " Tablas: Una exclusivamente para Utilex y la otra Continental */
    CASE RADIO-SET-1:
        WHEN 2 THEN DO:     /* Solo UTILEX */
            RUN PRI_Graba-Dscto-Prom-Min IN hProc (INPUT TOGGLE-Reemplazar,
                                                   INPUT T-MATG.CodMat,
                                                   INPUT-OUTPUT TABLE T-DPROM,
                                                   INPUT x-MetodoActualizacion,
                                                   INPUT f-Division,
                                                   OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-RROR' THEN NEXT RLOOP.
        END.
        OTHERWISE DO:   /* MAYORISTAS */
            RUN PRI_Graba-Dscto-Prom-May IN hProc (INPUT TOGGLE-Reemplazar,
                                                   INPUT T-MATG.CodMat,
                                                   INPUT-OUTPUT TABLE T-DPROM,
                                                   INPUT x-MetodoActualizacion,
                                                   INPUT f-Division,
                                                   OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-RROR' THEN NEXT RLOOP.
        END.
    END CASE.
    DELETE  T-MATG.     /* Artículo Procesado */
END.
DELETE PROCEDURE hProc.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

