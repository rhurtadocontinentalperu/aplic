&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE E-MATG NO-UNDO LIKE Almmmatg.
DEFINE NEW SHARED TEMP-TABLE T-MATG LIKE Almmmatg
       /*INDEX Idx00 AS PRIMARY CodMat FchPrmD*/.
DEFINE NEW SHARED TEMP-TABLE T-TABLA LIKE VtaTabla.



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
/* DEF SHARED VAR s-coddiv AS CHAR. */
DEF VAR s-coddiv AS CHAR NO-UNDO.

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

DEFINE VARIABLE RADIO-SET-2 AS INTEGER NO-UNDO.

DEF VAR pMensaje AS CHAR NO-UNDO.

/* VARIABLE PARA CONTROL LA ACTUALIZACION DE UNA DIVISION O TODAS LAS DIVISIONES */
DEF VAR x-MetodoActualizacion AS INT INIT 1 NO-UNDO.
/* 
1: Todas las divisiones
2: División seleccionada
*/

DEF VAR f-Division AS CHAR NO-UNDO.
DEF VAR f-FechaD AS DATE NO-UNDO.
DEF VAR f-FechaH AS DATE NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-div-expo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_butilexdctoprom-05 AS HANDLE NO-UNDO.

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

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.27 COL 71 WIDGET-ID 2
     BUTTON-2 AT ROW 1.27 COL 96 WIDGET-ID 4
     BtnDone AT ROW 1.27 COL 137 WIDGET-ID 6
     FILL-IN-Mensaje AT ROW 6.38 COL 69 COLON-ALIGNED NO-LABEL WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.14 BY 25.69 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: E-MATG T "NEW SHARED" NO-UNDO INTEGRAL Almmmatg
      TABLE: T-MATG T "NEW SHARED" ? INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          /*INDEX Idx00 AS PRIMARY CodMat FchPrmD*/
      END-FIELDS.
      TABLE: T-TABLA T "NEW SHARED" ? INTEGRAL VtaTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CARGA DESCUENTOS PROMOCIONALES - SOLO EVENTOS"
         HEIGHT             = 25.69
         WIDTH              = 144.14
         MAX-HEIGHT         = 25.69
         MAX-WIDTH          = 144.14
         VIRTUAL-HEIGHT     = 25.69
         VIRTUAL-WIDTH      = 144.14
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
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CARGA DESCUENTOS PROMOCIONALES - SOLO EVENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CARGA DESCUENTOS PROMOCIONALES - SOLO EVENTOS */
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

    RUN Devuelve-Lista IN h_b-div-expo ( OUTPUT s-CodDiv /* CHARACTER */).
    IF TRUE <> (s-CodDiv > '') THEN RETURN NO-APPLY.

    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls *.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        /*RETURN-TO-START-DIR */
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
        BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
     RUN dispatch IN h_b-div-expo ('disable':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR DESCUENTOS */
DO:
    RUN Grabar-Descuentos.
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
             INPUT  'gn/b-div-expo-listas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-div-expo ).
       RUN set-position IN h_b-div-expo ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-div-expo ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/butilexdctoprom-05.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_butilexdctoprom-05 ).
       RUN set-position IN h_butilexdctoprom-05 ( 8.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_butilexdctoprom-05 ( 18.31 , 141.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-div-expo ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_butilexdctoprom-05 ,
             FILL-IN-Mensaje:HANDLE IN FRAME F-Main , 'AFTER':U ).
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
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.

IF NOT (cValue BEGINS s-coddiv + " - DESCUENTOS PROMOCIONALES") THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
cNombreLista = cValue.

ASSIGN
    t-Row    = t-Row + 1
    t-column = t-Column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "CODIGO" THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
t-column = t-column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "DESCRIPCION" THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
CASE TRUE:
    WHEN INDEX(cNombreLista, "- PORCENTAJES") > 0 THEN RADIO-SET-2 = 1.
    WHEN INDEX(cNombreLista, "- IMPORTES") > 0 THEN RADIO-SET-2 = 2.
    OTHERWISE RETURN.
END CASE.

/* Verificamos y Cargamos Divisiones */
ASSIGN
    t-column = t-column + 7
    f-Division = ""
    f-FechaD = ?
    f-FechaH = ?.
/* Cargamos las divisiones inscritas en la hoja Excel */
f-Division = ENTRY(1, cNombreLista, '-').
IF f-Division <> s-CodDiv THEN DO:
    pMensaje = 'No puede actualizar la división ' + f-Division + CHR(10) +
        'La división que le corresponde es la ' + s-coddiv.
    RETURN.
END.
/* ********************************** */
/* Cargamos temporal */
DEF VAR x-Contador AS INT NO-UNDO.

EMPTY TEMP-TABLE T-MATG.
EMPTY TEMP-TABLE T-TABLA.
ASSIGN
    pMensaje = ""
    x-Contador = 0
    t-Column = 0
    t-Row = 2.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    CREATE T-MATG.
    ASSIGN
        T-MATG.codcia = s-codcia
        T-MATG.codmat = cValue.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.desmat = cValue.
    
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
    ASSIGN
        T-MATG.FchPrmD = f-FechaD
        T-MATG.FchPrmH = f-FechaH.
    /* DESCUENTOS PROMOCIONALES */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = ? THEN cValue = '0'.
    ASSIGN
        T-MATG.Libre_d01  = DECIMAL(cValue) NO-ERROR.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = ? THEN cValue = '0'.
    ASSIGN
        T-MATG.Libre_d02  = DECIMAL(cValue) NO-ERROR.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = ? THEN cValue = '0'.
    ASSIGN
        T-MATG.Libre_d03  = DECIMAL(cValue) NO-ERROR.
    /* Contador */
    x-Contador = x-Contador + 1.
    IF x-Contador > 1 AND (x-Contador MODULO 10) = 0 THEN DO:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
            "PROCESANDO LINEA: " + STRING(t-Row).
    END.
END.
/* EN CASO DE ERROR */
IF pMensaje <> "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    RETURN.
END.
/* Cargamos precios actuales */
x-Contador = 1.
FOR EACH T-MATG:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia
        AND VtaListaMay.coddiv = s-coddiv
        AND VtaListaMay.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN NEXT.
    IF NOT AVAILABLE VtaListaMay   THEN NEXT.
    ASSIGN
        T-MATG.MonVta = Almmmatg.MonVta 
        T-MATG.TpoCmb = Almmmatg.TpoCmb
        T-MATG.CtoTot = Almmmatg.CtoTot
        T-MATG.UndBas = Almmmatg.UndBas
        T-MATG.CHR__02 = Almmmatg.CHR__02.
    ASSIGN
        T-MATG.Chr__01   = VtaListaMay.Chr__01 
        T-MATG.PreOfi    = VtaListaMay.PreOfi 
        T-MATG.Prevta[1] = VtaListaMay.PreOfi.
    IF T-MATG.MonVta = 2 THEN
        ASSIGN
        T-MATG.PreOfi    = T-MATG.PreOfi * T-MATG.TpoCmb
        T-MATG.Prevta[1] = T-MATG.PreVta[1] * T-MATG.TpoCmb
        T-MATG.CtoTot    = T-MATG.CtoTot * T-MATG.TpoCmb.
    /* Corregimos de acuerdo al método de cálculo */
    IF RADIO-SET-2 = 2 THEN DO:     /* VALORES */
        IF T-MATG.Libre_d01 > 0 THEN T-MATG.Libre_d01 = ROUND ( ( 1 -  T-MATG.Libre_d01 / T-MATG.PreVta[1]  ) * 100, 4 ).
        IF T-MATG.Libre_d02 > 0 THEN T-MATG.Libre_d02 = ROUND ( ( 1 -  T-MATG.Libre_d02 / T-MATG.PreVta[1]  ) * 100, 4 ).
        IF T-MATG.Libre_d03 > 0 THEN T-MATG.Libre_d03 = ROUND ( ( 1 -  T-MATG.Libre_d03 / T-MATG.PreVta[1]  ) * 100, 4 ).
    END.
    /* Contador */
    x-Contador = x-Contador + 1.
    IF x-Contador > 1 AND (x-Contador MODULO 10) = 0 THEN DO:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
            "PROCESANDO ARTICULO: " + T-MATG.codmat.
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
FIND FIRST T-MATG NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-MATG THEN DO:
    pMensaje = 'No hay registros que procesar'.
END.

ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

RUN dispatch IN h_butilexdctoprom-05 ('open-query':U).

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  DISPLAY FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 BtnDone 
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

FIND FIRST E-MATG NO-LOCK NO-ERROR.
IF NOT AVAILABLE E-MATG THEN RETURN.
MESSAGE 'Los siguientes producto NO se han actualizado' SKIP
    'Se mostrará una lista de errores en Excel'
    VIEW-AS ALERT-BOX WARNING.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR x-CtoTot LIKE Almmmatg.ctotot NO-UNDO.
DEF VAR x-PreVta LIKE Almmmatg.prevta NO-UNDO.
DEF VAR x-PreOfi LIKE Almmmatg.preofi NO-UNDO.

ASSIGN
    chWorkSheet:Range("A1"):Value = "ERRORES - PRECIOS"
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Range("B2"):Value = "DESCRIPCION"
    chWorkSheet:Range("C2"):Value = "ERROR".
ASSIGN
    t-Row = 2.
FOR EACH E-MATG:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = E-MATG.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = E-MATG.desmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = E-MATG.Libre_c01.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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

MESSAGE 'Procedemos a grabar los descuentos promocionales?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF VAR pError AS CHAR NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR x-PreUni AS DEC NO-UNDO.

DEF VAR k AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.

/* ERRORES */
EMPTY TEMP-TABLE E-MATG.
FOR EACH T-MATG NO-LOCK:
    /* Por margenes de utilidad */
    /* VIP */
    IF T-MATG.Libre_d01 > 0 THEN DO:
        x-PreUni = T-MATG.Libre_d01.
        RUN Margen-de-Utilidad (s-CodDiv,
                                T-MATG.CodMat,
                                x-PreUni,
                                T-MATG.CHR__01,
                                T-MATG.TpoCmb,
                                OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                ).
        IF pError = "ADM-ERROR" THEN DO:
            CREATE E-MATG.
            BUFFER-COPY T-MATG 
                TO E-MATG
                ASSIGN 
                E-MATG.Libre_c01 = "Margen de utilidad VIP NO debe ser menor a " +
                TRIM(STRING(x-Limite, ">>>,>>9.99")).
            DELETE T-MATG.
            NEXT.
        END.
    END.
    /* Mesa Redonda */
    IF T-MATG.Libre_d02 > 0 THEN DO:
        x-PreUni = T-MATG.Libre_d02.
        RUN Margen-de-Utilidad (s-CodDiv,
                                T-MATG.CodMat,
                                x-PreUni,
                                T-MATG.CHR__01,
                                T-MATG.TpoCmb,
                                OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                ).
        IF pError = "ADM-ERROR" THEN DO:
            CREATE E-MATG.
            BUFFER-COPY T-MATG 
                TO E-MATG
                ASSIGN 
                E-MATG.Libre_c01 = "Margen de utilidad MESA REDONDA NO debe ser menor a " +
                TRIM(STRING(x-Limite, ">>>,>>9.99")).
            DELETE T-MATG.
            NEXT.
        END.
    END.
    /* Varios */
    IF T-MATG.Libre_d03 > 0 THEN DO:
        x-PreUni = T-MATG.Libre_d03.
        RUN Margen-de-Utilidad (s-CodDiv,
                                T-MATG.CodMat,
                                x-PreUni,
                                T-MATG.CHR__01,
                                T-MATG.TpoCmb,
                                OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                ).
        IF pError = "ADM-ERROR" THEN DO:
            CREATE E-MATG.
            BUFFER-COPY T-MATG 
                TO E-MATG
                ASSIGN 
                E-MATG.Libre_c01 = "Margen de utilidad VARIOS NO debe ser menor a " +
                TRIM(STRING(x-Limite, ">>>,>>9.99")).
            DELETE T-MATG.
            NEXT.
        END.
    END.
END.

FOR EACH T-MATG NO-LOCK,
    FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-CodCia AND
    VtaListaMay.CodMat = T-MATG.CodMat AND 
    VtaListaMay.CodDiv = s-coddiv EXCLUSIVE-LOCK:
    /* Por margenes de utilidad */
    /* Limpiamos informacion */
    ASSIGN
        VtaListaMay.Libre_d01 = 0
        VtaListaMay.Libre_d02 = 0
        VtaListaMay.Libre_d03 = 0
        VtaListaMay.PromFchD = ?
        VtaListaMay.PromFchH = ?.
    /* Cargamos informacion */
    ASSIGN
        VtaListaMay.PromFchD = T-MATG.FchPrmD
        VtaListaMay.PromFchH = T-MATG.FchPrmH.
    ASSIGN
        VtaListaMay.Libre_d01 = T-MATG.Libre_d01
        VtaListaMay.Libre_d02 = T-MATG.Libre_d02
        VtaListaMay.Libre_d03 = T-MATG.Libre_d03
        VtaListaMay.PromDto = T-MATG.Libre_d03.     /* Por defecto el de otros */
    VtaListaMay.fchact = TODAY.
END.
EMPTY TEMP-TABLE T-MATG.
IF AVAILABLE(VtaListaMay) THEN RELEASE VtaListaMay.
RUN dispatch IN h_butilexdctoprom-05 ('open-query':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Margen-de-Utilidad W-Win 
PROCEDURE Margen-de-Utilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pPreUni AS DEC.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER pTpoCmb AS DEC.
DEF OUTPUT PARAMETER x-Limite AS DEC.
DEF OUTPUT PARAMETER pError AS CHAR.

DEF VAR x-Margen AS DEC NO-UNDO.    /* Margen de utilidad */

pError = ''.

RUN vtagn/p-margen-utilidad-v2 (pCodDiv,
                                pCodMat,
                                pPreUni,
                                pUndVta,
                                1,                      /* Moneda */
                                pTpoCmb,
                                NO,                     /* Muestra error? */
                                "",                     /* Almacén */
                                OUTPUT x-Margen,        /* Margen de utilidad */
                                OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                ).

IF RETURN-VALUE = 'ADM-ERROR' THEN pError = 'ADM-ERROR'.

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

