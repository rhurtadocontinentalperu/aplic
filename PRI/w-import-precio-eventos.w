&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE A-MATG NO-UNDO LIKE Almmmatg
       INDEX Idx00 AS PRIMARY CodMat.
DEFINE TEMP-TABLE E-MATG NO-UNDO LIKE Almmmatg.
DEFINE NEW SHARED TEMP-TABLE T-MATG LIKE Almmmatg.



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

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR radio-set-1 AS INT NO-UNDO.

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

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 
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
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-import-precio-eventos AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CAPTURAR EXCEL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GRABAR PRECIOS" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.19 COL 84 WIDGET-ID 2
     BUTTON-2 AT ROW 1.19 COL 109 WIDGET-ID 4
     FILL-IN-Mensaje AT ROW 6.38 COL 69 COLON-ALIGNED NO-LABEL WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.43 BY 25.54 WIDGET-ID 100.


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
      TABLE: E-MATG T "?" NO-UNDO INTEGRAL Almmmatg
      TABLE: T-MATG T "NEW SHARED" ? INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "IMPORTAR PRECIOS DE VENTA POR DIVISION"
         HEIGHT             = 25.54
         WIDTH              = 142.43
         MAX-HEIGHT         = 27.23
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.23
         VIRTUAL-WIDTH      = 146.29
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
ON END-ERROR OF W-Win /* IMPORTAR PRECIOS DE VENTA POR DIVISION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR PRECIOS DE VENTA POR DIVISION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CAPTURAR EXCEL */
DO:
    RUN Devuelve-Lista IN h_b-div-expo ( OUTPUT s-CodDiv /* CHARACTER */).
    IF TRUE <> (s-CodDiv > '') THEN RETURN NO-APPLY.

    /* RUTINA GENERAL */
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
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
    IF pMensaje > "" THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    ASSIGN
        BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    RUN dispatch IN h_b-div-expo ('disable':U).
    MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION.

    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR PRECIOS */
DO:
    RUN Grabar-Precios-Division.
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

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'gn/b-div-expo-listas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-div-expo ).
       RUN set-position IN h_b-div-expo ( 1.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-div-expo ( 6.69 , 66.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-div-expo ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PRI/t-import-precio-eventos.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-import-precio-eventos ).
       RUN set-position IN h_t-import-precio-eventos ( 8.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-import-precio-eventos ( 16.35 , 139.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 24.69 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-import-precio-eventos. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_t-import-precio-eventos ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-import-precio-eventos ,
             FILL-IN-Mensaje:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             h_t-import-precio-eventos , 'AFTER':U ).
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
IF NOT (cValue = s-coddiv + " - PRECIOS")
    THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
cNombreLista = cValue.
/* ******************* */
ASSIGN
    t-Row    = t-Row + 1
    t-column = t-Column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "CODIGO" THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
t-column = t-column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "DESCRIPCION" THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* CARGAMOS TEMPORALES */
CASE cNombreLista:
    WHEN s-coddiv + " - PRECIOS"    THEN RADIO-SET-1 = 3.
    OTHERWISE RETURN.
END CASE.
CASE RADIO-SET-1:
    WHEN 3 THEN RUN Carga-Temporal-Division.
END CASE.
/* Filtramos solo lineas autorizadas */
FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK:
    FIND Vtatabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = "LP"
        AND Vtatabla.llave_c1 = s-user-id
        AND Vtatabla.llave_c2 = Almmmatg.codfam
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtatabla THEN DO:
        pMensaje = "LINEA NO AUTORIZADA:" + T-MATG.CodMat.
        DELETE T-MATG.
    END.
END.
ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

/* RECALCULAMOS Y PINTAMOS RESULTADOS */
RUN Recalcular IN h_t-import-precio-eventos.
RUN dispatch IN h_t-import-precio-eventos ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Division W-Win 
PROCEDURE Carga-Temporal-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-MATG.
ASSIGN
    pMensaje = ""
    t-Column = 0
    t-Row = 2.     /* Saltamos el encabezado de los campos */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "*** INICIO DE PROCESO ***".
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 

    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO FILA: " + STRING(t-Row).

    CREATE T-MATG.
    ASSIGN
        T-MATG.codcia = s-codcia
        T-MATG.codmat = STRING(DECIMAL(cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Código " + cValue.
        LEAVE.
    END.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = T-MATG.CodMat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Código " + T-MATG.CodMat.
        LEAVE.
    END.

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.desmat = cValue.
    
    t-Column = t-Column + 6.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.PreOfi = ROUND(DECIMAL(cValue),4)
        NO-ERROR.
    IF ERROR-STATUS:ERROR OR (T-MATG.PreOfi = 0 OR T-MATG.PreOfi = ?) THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio de Oficina Errado".
        LEAVE.
    END.
    /* Condig. de Desctos.*/
    t-Column = t-Column + 4.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue BEGINS 'SIN DESC' THEN T-MATG.Orden = 1.
    ELSE T-MATG.Orden = 0.
END.
IF pMensaje > "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    RETURN.
END.
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE T-MATG.PreOfi = 0 OR T-MATG.PreOfi = ?:
    DELETE T-MATG.
END.
FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK WHERE (Almmmatg.CtoLis = 0 OR Almmmatg.CtoLis = ?)
    OR (Almmmatg.CtoTot = 0 OR Almmmatg.CtoTot = ?)
    OR (Almmmatg.TpoCmb = 0 OR Almmmatg.TpoCmb = ?)
    OR Almmmatg.MonVta = 0:
    DELETE T-MATG.
END.
/* *********************************** */
/* Cargamos precios actuales */
FOR EACH T-MATG:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat
        NO-LOCK.
    FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia
        AND VtaListaMay.coddiv = s-coddiv
        AND VtaListaMay.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    ASSIGN
        T-MATG.CodCia  = Almmmatg.CodCia
        T-MATG.UndBas  = Almmmatg.UndBas
        T-MATG.DesMar  = Almmmatg.DesMar
        T-MATG.MonVta  = Almmmatg.MonVta 
        T-MATG.TpoCmb  = Almmmatg.TpoCmb
        T-MATG.CtoLis  = Almmmatg.CtoLis
        T-MATG.CtoTot  = Almmmatg.CtoTot
        T-MATG.Chr__01 = (IF AVAILABLE VtaListaMay THEN VtaListaMay.Chr__01 ELSE Almmmatg.CHR__01).
END.

FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK:
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = T-MATG.Chr__01
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv OR Almtconv.Equival = 0 THEN DELETE T-MATG.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consistencias W-Win 
PROCEDURE Consistencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  ENABLE BUTTON-1 
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
/* /* 1ro ERRORES */                                                             */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Precios-Division W-Win 
PROCEDURE Grabar-Precios-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CToTot AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

MESSAGE 'Procedemos a grabar los precios?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF VAR pError AS CHAR NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR x-PreUni AS DEC NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.

EMPTY TEMP-TABLE E-MATG.    /* ERRORES CRITICOS */
EMPTY TEMP-TABLE A-MATG.    /* ALERTAS */
FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    /* Por Precio de Lista */
    IF T-MATG.PreOfi <= 0 THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Error en el Precio de Lista".
        DELETE T-MATG.
        NEXT.
    END.
    /* ****************************************************************************************************** */
    /* Control Margen de Utilidad */
    /* ****************************************************************************************************** */
    /* 1ro. Calculamos el margen de utilidad */
    RUN PRI_Margen-Utilidad IN hProc (INPUT s-CodDiv,
                                      INPUT T-MATG.CodMat,
                                      INPUT T-MATG.CHR__01,
                                      INPUT T-MATG.PreOfi,
                                      INPUT T-MATG.MonVta,      /*INPUT 1,*/
                                      OUTPUT x-Margen,
                                      OUTPUT x-Limite,
                                      OUTPUT pError).

    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        /* Error crítico */
        CREATE E-MATG.
        BUFFER-COPY T-MATG TO E-MATG ASSIGN E-MATG.Libre_c01 = pError.
        DELETE T-MATG.
        NEXT.
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
            NEXT.
        END.
    END.
    FIND FIRST VtaListaMay OF T-MATG WHERE VtaListaMay.CodDiv = s-CodDiv EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaListaMay THEN DO:
        CREATE VtaListaMay.
        ASSIGN
            VtaListaMay.CodCia = s-codcia
            VtaListaMay.CodDiv = s-coddiv
            VtaListaMay.codmat = Almmmatg.codmat.
    END.
    ASSIGN
        VtaListaMay.MonVta  = T-MATG.MonVta
        VtaListaMay.TpoCmb  = T-MATG.TpoCmb
        VtaListaMay.CHR__01 = T-MATG.CHR__01
        VtaListaMay.PreOfi  = T-MATG.PreOfi.
    ASSIGN
        VtaListaMay.FchAct  = TODAY
        VtaListaMay.usuario = s-user-id.
    /* MARGEN */
    x-CtoTot = Almmmatg.CtoTot.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = VtaListaMay.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    ASSIGN
        VtaListaMay.Dec__01 = ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100.
    /* Config. de Desctos. */
    ASSIGN
        VtaListaMay.FlagDesctos = T-MATG.Orden.
END.
EMPTY TEMP-TABLE T-MATG.
DELETE PROCEDURE hProc.

RUN dispatch IN h_t-import-precio-eventos ('open-query':U).

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

RUN vtagn/p-margen-utilidad-v11 (pCodDiv,
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

/* RUN vtagn/p-margen-utilidad-v2 (pCodDiv,                                                           */
/*                                 pCodMat,                                                           */
/*                                 pPreUni,                                                           */
/*                                 pUndVta,                                                           */
/*                                 1,                      /* Moneda */                               */
/*                                 pTpoCmb,                                                           */
/*                                 NO,                     /* Muestra error? */                       */
/*                                 "",                     /* Almacén */                              */
/*                                 OUTPUT x-Margen,        /* Margen de utilidad */                   */
/*                                 OUTPUT x-Limite,        /* Margen mínimo de utilidad */            */
/*                                 OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */ */
/*                                 ).                                                                 */

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

