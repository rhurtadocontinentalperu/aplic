&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
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
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division RADIO-SET-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_butilexprecios-02a AS HANDLE NO-UNDO.
DEFINE VARIABLE h_butilexprecios-02b AS HANDLE NO-UNDO.
DEFINE VARIABLE h_butilexprecios-02c AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97-3 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CAPTURAR EXCEL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GRABAR DESCUENTOS" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 78 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Lista Mayorista - Continental", 1,
"Lista Minorista - Utilex", 2,
"Lista Mayorista - por División", 3
     SIZE 27 BY 2.12 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 142.43 BY 1.35
     BGCOLOR 11 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Division AT ROW 1.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-1 AT ROW 2.54 COL 80 WIDGET-ID 2
     RADIO-SET-1 AT ROW 2.73 COL 18 NO-LABEL WIDGET-ID 24
     BUTTON-2 AT ROW 3.69 COL 80 WIDGET-ID 4
     "Lista de Precios:" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 2.92 COL 3 WIDGET-ID 30
     RECT-1 AT ROW 2.54 COL 2 WIDGET-ID 28
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.43 BY 19.54 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
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
         TITLE              = "CARGA PRECIOS DE VENTA"
         HEIGHT             = 19.54
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
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-1 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CARGA PRECIOS DE VENTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CARGA PRECIOS DE VENTA */
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
    ASSIGN
        RADIO-SET-1.
    CASE RADIO-SET-1:
        WHEN 1 THEN RUN Carga-Temporal-Conti.
        WHEN 2 THEN RUN Carga-Temporal-Utilex.
        WHEN 3 THEN RUN Carga-Temporal-Division.
    END CASE.
    IF pMensaje <> "" THEN DO:
        EMPTY TEMP-TABLE T-MATG.
        RUN dispatch IN h_butilexprecios-02a ('open-query':U).
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR DESCUENTOS */
DO:
    CASE RADIO-SET-1:
        WHEN 1 THEN RUN Grabar-Precios-Conti.
        WHEN 2 THEN RUN Grabar-Precios-Utilex.
        WHEN 3 THEN RUN Grabar-Precios-Division.
    END CASE.

    /* RUTINA GENERAL */
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.

    /* CREAMOS LA HOJA EXCEL */
    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    RUN Carga-Temporal.

    /* CERRAMOS EL EXCEL */
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 W-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
  RUN select-page (SELF:SCREEN-VALUE).
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
             INPUT  'aplic/vta2/butilexprecios-02a.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = Familia':U ,
             OUTPUT h_butilexprecios-02a ).
       RUN set-position IN h_butilexprecios-02a ( 5.04 , 2.00 ) NO-ERROR.
       RUN set-size IN h_butilexprecios-02a ( 13.65 , 140.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97-2 ).
       RUN set-position IN h_p-updv97-2 ( 18.69 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97-2 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_butilexprecios-02a. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97-2 , 'TableIO':U , h_butilexprecios-02a ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_butilexprecios-02a ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97-2 ,
             h_butilexprecios-02a , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/butilexprecios-02b.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_butilexprecios-02b ).
       RUN set-position IN h_butilexprecios-02b ( 5.04 , 2.00 ) NO-ERROR.
       RUN set-size IN h_butilexprecios-02b ( 13.65 , 135.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 18.69 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_butilexprecios-02b. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_butilexprecios-02b ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_butilexprecios-02b ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             h_butilexprecios-02b , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/butilexprecios-02c.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_butilexprecios-02c ).
       RUN set-position IN h_butilexprecios-02c ( 5.04 , 2.00 ) NO-ERROR.
       RUN set-size IN h_butilexprecios-02c ( 13.65 , 139.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97-3 ).
       RUN set-position IN h_p-updv97-3 ( 18.69 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97-3 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_butilexprecios-02c. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97-3 , 'TableIO':U , h_butilexprecios-02c ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_butilexprecios-02c ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97-3 ,
             h_butilexprecios-02c , 'AFTER':U ).
    END. /* Page 3 */

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

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
IF cValue <> "CONTINENTAL - PRECIOS" THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
ASSIGN
    t-Row    = t-Row + 1.
t-column = t-column + 1.
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
                       
/* Cargamos temporal */
EMPTY TEMP-TABLE T-MATG.
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
    /* CODIGO */
    CREATE T-MATG.
    ASSIGN
        T-MATG.codcia = s-codcia
        T-MATG.codmat = cValue.
    /* DESCRIPCION */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.desmat = cValue.
    /* PRECIOS */        
    t-Column = t-Column + 19.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[1] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio de Lista".
        LEAVE.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[2] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio A".
        LEAVE.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[3] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio B".
        LEAVE.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[4] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio C".
        LEAVE.
    END.
END.
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE T-MATG.Prevta[1] = 0 OR T-MATG.Prevta[1] = ?:
    DELETE T-MATG.
END.
/* ********************************** */

IF pMensaje <> "" THEN RETURN.

/* Cargamos precios actuales */
FOR EACH T-MATG:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat
        NO-LOCK.
    ASSIGN
        T-MATG.CodCia  = Almmmatg.CodCia
        T-MATG.UndBas  = Almmmatg.UndBas
        T-MATG.DesMar  = Almmmatg.DesMar
        T-MATG.Chr__01 = Almmmatg.Chr__01 
        T-MATG.Chr__02 = Almmmatg.Chr__02 
        T-MATG.Dec__01 = Almmmatg.Dec__01 
        T-MATG.MonVta = Almmmatg.MonVta 
        T-MATG.TpoCmb = Almmmatg.TpoCmb
        T-MATG.CtoLis = Almmmatg.CtoLis
        T-MATG.CtoTot = Almmmatg.CtoTot
        T-MATG.UndA = Almmmatg.UndA
        T-MATG.UndB = Almmmatg.UndB
        T-MATG.UndC = Almmmatg.UndC.
    IF Almmmatg.MonVta = 2 THEN
        ASSIGN
        T-MATG.CtoLis = Almmmatg.CtoLis * Almmmatg.TpoCmb
        T-MATG.CtoTot = Almmmatg.CtoTot * Almmmatg.TpoCmb.
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
IF NOT AVAILABLE T-MATG THEN MESSAGE 'No hay registros que procesar' VIEW-AS ALERT-BOX ERROR.
ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    RADIO-SET-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
RUN Recalcular IN h_butilexprecios-02a.
RUN dispatch IN h_butilexprecios-02a ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Conti W-Win 
PROCEDURE Carga-Temporal-Conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    /*RETURN-TO-START-DIR */
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

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

CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
IF cValue <> "CONTINENTAL - PRECIOS" THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
ASSIGN
    t-Row    = t-Row + 1.
t-column = t-column + 1.
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
/* Cargamos temporal */
EMPTY TEMP-TABLE T-MATG.
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
    /* CODIGO */
    CREATE T-MATG.
    ASSIGN
        T-MATG.codcia = s-codcia
        T-MATG.codmat = cValue.
    /* DESCRIPCION */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.desmat = cValue.
    /* PRECIOS */        
    t-Column = t-Column + 19.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[1] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio de Lista".
        LEAVE.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[2] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio A".
        LEAVE.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[3] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio B".
        LEAVE.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[4] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio C".
        LEAVE.
    END.
END.
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE T-MATG.Prevta[1] = 0 OR T-MATG.Prevta[1] = ?:
    DELETE T-MATG.
END.
/* ********************************** */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

IF pMensaje <> "" THEN RETURN.

/* Cargamos precios actuales */
FOR EACH T-MATG:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat
        NO-LOCK.
    ASSIGN
        T-MATG.CodCia  = Almmmatg.CodCia
        T-MATG.UndBas  = Almmmatg.UndBas
        T-MATG.DesMar  = Almmmatg.DesMar
        T-MATG.Chr__01 = Almmmatg.Chr__01 
        T-MATG.Chr__02 = Almmmatg.Chr__02 
        T-MATG.Dec__01 = Almmmatg.Dec__01 
        T-MATG.MonVta = Almmmatg.MonVta 
        T-MATG.TpoCmb = Almmmatg.TpoCmb
        T-MATG.CtoLis = Almmmatg.CtoLis
        T-MATG.CtoTot = Almmmatg.CtoTot
        T-MATG.UndA = Almmmatg.UndA
        T-MATG.UndB = Almmmatg.UndB
        T-MATG.UndC = Almmmatg.UndC.
    IF Almmmatg.MonVta = 2 THEN
        ASSIGN
        T-MATG.CtoLis = Almmmatg.CtoLis * Almmmatg.TpoCmb
        T-MATG.CtoTot = Almmmatg.CtoTot * Almmmatg.TpoCmb.
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
IF NOT AVAILABLE T-MATG THEN MESSAGE 'No hay registros que procesar' VIEW-AS ALERT-BOX ERROR.
ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    RADIO-SET-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
RUN Recalcular IN h_butilexprecios-02a.
RUN dispatch IN h_butilexprecios-02a ('open-query':U).

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

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    /*RETURN-TO-START-DIR */
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

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

CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
IF cValue <> s-coddiv + " - PRECIOS" THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
ASSIGN
    t-Row    = t-Row + 1
    t-column = t-column + 1.
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
/* Cargamos temporal */
EMPTY TEMP-TABLE T-MATG.
ASSIGN
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
    
    t-Column = t-Column + 5.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.PreOfi = DECIMAL(cValue).
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE T-MATG.PreOfi = 0 OR T-MATG.PreOfi = ?:
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
    IF T-MATG.MonVta = 2 THEN
        ASSIGN
        T-MATG.CtoLis = Almmmatg.CtoLis * Almmmatg.TpoCmb
        T-MATG.CtoTot = Almmmatg.CtoTot * Almmmatg.TpoCmb.
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
IF NOT AVAILABLE T-MATG THEN MESSAGE 'No hay registros que procesar' VIEW-AS ALERT-BOX ERROR.
ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    RADIO-SET-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
RUN Recalcular IN h_butilexprecios-02c.
RUN dispatch IN h_butilexprecios-02c ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Utilex W-Win 
PROCEDURE Carga-Temporal-Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    /*RETURN-TO-START-DIR */
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

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

CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
IF cValue <> "UTILEX - PRECIOS" THEN DO:
    MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

ASSIGN
    t-Row    = t-Row + 1.
t-column = t-column + 1.
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
/* Cargamos temporal */
EMPTY TEMP-TABLE T-MATG.
ASSIGN
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
    
    t-Column = t-Column + 6.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.PreAlt[1] = DECIMAL(cValue).
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE T-MATG.PreAlt[1] = 0 OR T-MATG.PreAlt[1] = ?:
    DELETE T-MATG.
END.
/* *********************************** */

/* Cargamos precios actuales */
FOR EACH T-MATG:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat
        NO-LOCK.
    FIND Vtalistamingn WHERE Vtalistamingn.codcia = s-codcia
        AND Vtalistamingn.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    ASSIGN
        T-MATG.CodCia  = Almmmatg.CodCia
        T-MATG.UndBas  = Almmmatg.UndBas
        T-MATG.DesMar  = Almmmatg.DesMar
        T-MATG.UndAlt[1] = (IF AVAILABLE VtaListaMinGn THEN Vtalistamingn.Chr__01 ELSE Almmmatg.Chr__01)
        T-MATG.MonVta  = Almmmatg.MonVta 
        T-MATG.TpoCmb  = Almmmatg.TpoCmb
        T-MATG.CtoLis  = Almmmatg.CtoLis
        T-MATG.CtoTot  = Almmmatg.CtoTot.
    IF Almmmatg.MonVta = 2 THEN
        ASSIGN
        T-MATG.CtoLis = Almmmatg.CtoLis * Almmmatg.TpoCmb
        T-MATG.CtoTot = Almmmatg.CtoTot * Almmmatg.TpoCmb.
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
IF NOT AVAILABLE T-MATG THEN MESSAGE 'No hay registros que procesar' VIEW-AS ALERT-BOX ERROR.
ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    RADIO-SET-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
RUN Recalcular IN h_butilexprecios-02b.
RUN dispatch IN h_butilexprecios-02b ('open-query':U).

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
  DISPLAY FILL-IN-Division RADIO-SET-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Precios-Conti W-Win 
PROCEDURE Grabar-Precios-Conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Procedemos a grabar los precios?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF VAR pError AS CHAR NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR x-PreUni AS DEC NO-UNDO.

/* CONSISTENCIAS FINALES */
EMPTY TEMP-TABLE E-MATG.
FOR EACH T-MATG:
    /* Por código */
    FIND Almmmatg OF T-MATG NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = 'Artículo ' +  TRIM(T-MATG.codmat) + ' no registrado en la lista de precios'.
        DELETE T-MATG.
        NEXT.
    END.
    /* Por Precio de Lista */
    IF T-MATG.PreVta[1] <= 0 THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Error en el Precio de Lista ".
        DELETE T-MATG.
        NEXT.
    END.
    /* Por margenes de utilidad */
    /* Lista A */
    x-PreUni = Almmmatg.Prevta[2].
    RUN vtagn/p-margen-utilidad (
        T-MATG.CodMat,
        x-PreUni,
        T-MATG.UndA,
        1,                      /* Moneda */
        T-MATG.TpoCmb,
        NO,                     /* Muestra error? */
        "",                     /* Almacén */
        OUTPUT x-Margen,        /* Margen de utilidad */
        OUTPUT x-Limite,        /* Margen mínimo de utilidad */
        OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
        ).
    IF pError = "ADM-ERROR" THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN 
            E-MATG.Libre_c01 = "Margen de utilidad para la lista A NO debe ser menor a " +
            TRIM(STRING(x-Limite, ">>>,>>9.99")).
        DELETE T-MATG.
        NEXT.
    END.
END.
/* ********************* */
RETURN.

FOR EACH T-MATG ON STOP UNDO, RETURN ON ERROR UNDO, RETURN:
    FIND Almmmatg OF T-MATG EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN.
    END.
    ASSIGN
        Almmmatg.PreVta[1] = T-MATG.PreVta[1]
        Almmmatg.MrgUti-A  = T-MATG.MrgUti-A
        Almmmatg.Prevta[2] = T-MATG.Prevta[2]
        Almmmatg.MrgUti-B  = T-MATG.MrgUti-B
        Almmmatg.PreVta[3] = T-MATG.Prevta[3]
        Almmmatg.MrgUti-C  = T-MATG.MrgUti-C
        Almmmatg.PreVta[4] = T-MATG.Prevta[4]
        Almmmatg.Dec__01   = T-MATG.Dec__01
        Almmmatg.PreOfi    = T-MATG.PreOfi.
    /* REGRABAMOS EN LA MONEDA DE VENTA */
    IF Almmmatg.MonVta = 2 THEN DO:
        ASSIGN
            Almmmatg.Prevta[1] = Almmmatg.PreVta[1] / Almmmatg.TpoCmb
            Almmmatg.Prevta[2] = Almmmatg.PreVta[2] / Almmmatg.TpoCmb
            Almmmatg.Prevta[3] = Almmmatg.PreVta[3] / Almmmatg.TpoCmb
            Almmmatg.Prevta[4] = Almmmatg.PreVta[4] / Almmmatg.TpoCmb
            Almmmatg.PreOfi    = Almmmatg.PreOfi    / Almmmatg.TpoCmb.
    END.
    ASSIGN
        Almmmatg.FchmPre[1] = TODAY
        Almmmatg.Usuario = S-USER-ID
        Almmmatg.FchAct  = TODAY.
END.
EMPTY TEMP-TABLE T-MATG.

RUN dispatch IN h_butilexprecios-02a ('open-query':U).

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

FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    FIND VtaListaMay OF T-MATG WHERE VtaListaMay.CodDiv = s-CodDiv EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaListaMay THEN DO:
/*         MESSAGE 'Artículo' T-MATG.codmat 'no registrado en la lista de precios' SKIP */
/*             'Actualización abortada'                                                 */
/*             VIEW-AS ALERT-BOX WARNING.                                               */
/*         UNDO, RETURN.                                                                */
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
    /* REGRABAMOS EN LA MONEDA DE VENTA */
    IF Almmmatg.MonVta = 2 THEN VtaListaMay.PreOfi = VtaListaMay.PreOfi / Almmmatg.TpoCmb.
    /* MARGEN */
    IF Almmmatg.monvta = Vtalistamay.monvta THEN x-CtoTot = Almmmatg.CtoTot.
    ELSE IF Vtalistamay.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
    ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = VtaListaMay.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    ASSIGN
        VtaListaMay.Dec__01 = ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100.
END.
EMPTY TEMP-TABLE T-MATG.

RUN dispatch IN h_butilexprecios-02c ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Precios-Utilex W-Win 
PROCEDURE Grabar-Precios-Utilex :
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

FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    FIND VtaListaMinGn OF T-MATG EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaListaMinGn THEN DO:
/*         MESSAGE 'Artículo' T-MATG.codmat 'no registrado en la lista de precios' SKIP */
/*             'Actualización abortada'                                                 */
/*             VIEW-AS ALERT-BOX WARNING.                                               */
/*         UNDO, RETURN.                                                                */
        CREATE VtaListaMinGn.
        ASSIGN
            VtaListaMinGn.CodCia = Almmmatg.codcia
            VtaListaMinGn.codmat = Almmmatg.codmat
            VtaListaMinGn.FchIng = TODAY.
    END.
    ASSIGN
        VtaListaMinGn.MonVta  = T-MATG.MonVta
        VtaListaMinGn.TpoCmb  = T-MATG.TpoCmb
        VtaListaMinGn.Chr__01 = T-MATG.UndAlt[1]
        VtaListaMinGn.PreOfi  = T-MATG.PreAlt[1].
    ASSIGN
        VtaListaMinGn.FchAct  = TODAY
        VtaListaMinGn.usuario = s-user-id.
    /* REGRABAMOS EN LA MONEDA DE VENTA */
    IF Almmmatg.MonVta = 2 THEN VtaListaMinGn.PreOfi  = VtaListaMinGn.PreOfi / Almmmatg.TpoCmb.
    /* Calculamos el margen */
    IF Almmmatg.monvta = VtaListaMinGn.monvta THEN x-CtoTot = Almmmatg.CtoTot.
    ELSE IF VtaListaMinGn.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
    ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = VtaListaMinGn.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    END.  
    ASSIGN
        VtaListaMinGn.Dec__01 = ( (VtaListaMinGn.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100.
    RELEASE VtaListaMinGn.
END.
EMPTY TEMP-TABLE T-MATG.

RUN dispatch IN h_butilexprecios-02b ('open-query':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = s-coddiv
      NO-LOCK.
  FILL-IN-Division = "DIVISIÓN: " + gn-divi.coddiv + " " + GN-DIVI.DesDiv.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

