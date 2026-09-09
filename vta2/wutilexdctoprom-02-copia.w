&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
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
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-1 RECT-2 BtnDone BUTTON-1 ~
RADIO-SET-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division RADIO-SET-1 RADIO-SET-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_butilexdctoprom-02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vutilexdctoprom-02 AS HANDLE NO-UNDO.

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

DEFINE VARIABLE RADIO-SET-2 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Porcentajes", 1,
"Importe", 2
     SIZE 14 BY 2.12 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 2.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 141 BY 1.92
     BGCOLOR 11 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.19 COL 133 WIDGET-ID 6
     FILL-IN-Division AT ROW 1.38 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     BUTTON-1 AT ROW 3.12 COL 80 WIDGET-ID 2
     RADIO-SET-1 AT ROW 3.31 COL 18 NO-LABEL WIDGET-ID 14
     RADIO-SET-2 AT ROW 3.31 COL 64 NO-LABEL WIDGET-ID 8
     BUTTON-2 AT ROW 4.27 COL 80 WIDGET-ID 4
     "Lista de Precios:" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 3.5 COL 3 WIDGET-ID 18
     "Método de cálculo:" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 3.5 COL 47 WIDGET-ID 12
     RECT-3 AT ROW 1 COL 1 WIDGET-ID 30
     RECT-1 AT ROW 3.12 COL 2 WIDGET-ID 20
     RECT-2 AT ROW 3.12 COL 46 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141.14 BY 21.54 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATG T "NEW SHARED" ? INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DESCUENTOS PROMOCIONALES - UTILEX"
         HEIGHT             = 21.54
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
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DESCUENTOS PROMOCIONALES - UTILEX */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DESCUENTOS PROMOCIONALES - UTILEX */
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
    ASSIGN
        RADIO-SET-1 RADIO-SET-2.
    RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR DESCUENTOS */
DO:
    RUN Grabar-Descuentos.
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
             INPUT  'aplic/vta2/vutilexdctoprom-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vutilexdctoprom-02 ).
       RUN set-position IN h_vutilexdctoprom-02 ( 5.81 , 88.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.15 , 53.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/butilexdctoprom-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_butilexdctoprom-02 ).
       RUN set-position IN h_butilexdctoprom-02 ( 6.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_butilexdctoprom-02 ( 14.62 , 86.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 16.96 , 90.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartViewer h_vutilexdctoprom-02. */
       RUN add-link IN adm-broker-hdl ( h_butilexdctoprom-02 , 'Record':U , h_vutilexdctoprom-02 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_vutilexdctoprom-02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_vutilexdctoprom-02 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_butilexdctoprom-02 ,
             h_vutilexdctoprom-02 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             h_butilexdctoprom-02 , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
DEFINE VARIABLE k               AS INTEGER NO-UNDO.

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
CASE RADIO-SET-1:
    WHEN 1 THEN IF NOT cValue BEGINS "CONTINENTAL - DESCUENTOS PROMOCIONALES" THEN DO:
        MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    WHEN 2 THEN IF NOT cValue BEGINS "UTILEX - DESCUENTOS PROMOCIONALES"  THEN DO:
        MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    WHEN 3 THEN IF NOT cValue BEGINS s-coddiv + " - DESCUENTOS PROMOCIONALES"  THEN DO:
        MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END CASE.
IF INDEX(cValue, "- PORCENTAJES") > 0 THEN RADIO-SET-2 = 1.
IF INDEX(cValue, "- IMPORTES") > 0 THEN RADIO-SET-2 = 2.
DISPLAY radio-set-2 WITH FRAME {&FRAME-NAME}.

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
/* Verificamos y Cargamos Divisiones Divisiones */
DEF VAR f-Division AS CHAR INIT "" NO-UNDO.
DEF VAR f-FechaD AS DATE NO-UNDO.
DEF VAR f-FechaH AS DATE NO-UNDO.

t-column = t-column + 7.
REPEAT:
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = cValue
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN DO:
        MESSAGE 'División' cValue 'errada' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF f-Division = "" THEN f-Division = cValue.
    ELSE f-Division = f-Division + ',' + cValue.
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
        f-FechaD = DATE(cValue).

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        f-FechaH = DATE(cValue).

    /* Cargamos Descuentos Promocionales */
    k = 1.
    DO iCountLine = 1 TO NUM-ENTRIES(f-Division):
        t-Column = t-Column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = ? OR DECIMAL(cValue) = 0 THEN NEXT.
        ASSIGN
            T-MATG.PromDivi[k] = ENTRY(iCountLine, f-Division) 
            T-MATG.PromDto[k]  = DECIMAL(cValue)
            T-MATG.PromFchD[k] = f-FechaD
            T-MATG.PromFchH[k] = f-FechaH.
        IF cValue = ? THEN T-MATG.PromDto[k] = 0.
        k = k + 1.
    END.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 
/* Cargamos precios actuales */
FOR EACH T-MATG:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    FIND VtaListaMinGn WHERE VtaListaMinGn.codcia = s-codcia
        AND VtaListaMinGn.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia
        AND VtaListaMay.coddiv = s-coddiv
        AND VtaListaMay.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN NEXT.
    IF RADIO-SET-1 = 2 AND NOT AVAILABLE VtaListaMinGn THEN NEXT.
    IF RADIO-SET-1 = 3 AND NOT AVAILABLE VtaListaMay   THEN NEXT.
    ASSIGN
        T-MATG.MonVta = Almmmatg.MonVta 
        T-MATG.TpoCmb = Almmmatg.TpoCmb.
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
    IF T-MATG.MonVta = 2 THEN
        ASSIGN
        T-MATG.PreOfi    = T-MATG.PreOfi * T-MATG.TpoCmb
        T-MATG.Prevta[1] = T-MATG.PreVta[1] * T-MATG.TpoCmb.

    /* Corregimos de acuerdo al método de cálculo */
    IF RADIO-SET-2 = 2 THEN DO:
        DO iValue = 1 TO 10:
            IF T-MATG.PromDto[iValue] > 0 THEN
            T-MATG.PromDto[iValue] = ROUND ( ( 1 -  T-MATG.PromDto[iValue] / T-MATG.PreVta[1]  ) * 100, 4 ).
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
FIND FIRST T-MATG NO-LOCK NO-ERROR.
IF NOT AVAILABLE T-MATG THEN MESSAGE 'No hay registros que procesar' VIEW-AS ALERT-BOX ERROR.

ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    RADIO-SET-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    RADIO-SET-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

RUN dispatch IN h_butilexdctoprom-02 ('open-query':U).

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
  DISPLAY FILL-IN-Division RADIO-SET-1 RADIO-SET-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-3 RECT-1 RECT-2 BtnDone BUTTON-1 RADIO-SET-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

DEF VAR k AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.

CASE RADIO-SET-1:
    WHEN 1 THEN DO:
        {vta2/wutilexdctoprom-02.i &Tabla=Almmmatg}
    END.
    WHEN 2 THEN DO:
        {vta2/wutilexdctoprom-02.i &Tabla=Vtalistamingn}
    END.
    WHEN 3 THEN DO:
        FOR EACH T-MATG ON STOP UNDO, RETURN:
            FIND VtaListaMay OF T-MATG WHERE VtaListaMay.CodDiv = s-coddiv EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaListaMay THEN UNDO, RETURN.
            /* Limpiamos informacion */
            ASSIGN
                VtaListaMay.PromDto = 0
                VtaListaMay.PromFchD = ?
                VtaListaMay.PromFchH = ?.
            /* Cargamos informacion */
            j = 0.
            DO k = 1 TO 1:
                IF T-MATG.PromDto[k] <> 0 THEN DO:
                    j = j + 1.
                    ASSIGN
                        VtaListaMay.PromDto = T-MATG.PromDto[k]
                        VtaListaMay.PromFchD = T-MATG.PromFchD[k]
                        VtaListaMay.PromFchH = T-MATG.PromFchH[k].
                END.
            END.
            VtaListaMay.fchact = TODAY.
        END.
        EMPTY TEMP-TABLE T-MATG.
    END.
END CASE.

RUN dispatch IN h_butilexdctoprom-02 ('open-query':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Descuentos-Utilex W-Win 
PROCEDURE Grabar-Descuentos-Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.

MESSAGE 'Procedemos a grabar los decuentos promocionales?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.
FOR EACH T-MATG ON STOP UNDO, RETURN:
    FIND VtaListaMinGn OF T-MATG EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaListaMinGn THEN UNDO, RETURN.
    /* Limpiamos informacion */
    DO k = 1 TO 10:
        ASSIGN
            VtaListaMinGn.PromDivi[k] = ""
            VtaListaMinGn.PromDto[k] = 0
            VtaListaMinGn.PromFchD[k] = ?
            VtaListaMinGn.PromFchH[k] = ?.
    END.
    /* Cargamos informacion */
    j = 0.
    DO k = 1 TO 10:
        IF T-MATG.PromDto[k] <> 0 THEN DO:
            j = j + 1.
            ASSIGN
                VtaListaMinGn.PromDivi[j] = T-MATG.PromDiv[k]
                VtaListaMinGn.PromDto[j] = T-MATG.PromDto[k]
                VtaListaMinGn.PromFchD[j] = T-MATG.PromFchD[k]
                VtaListaMinGn.PromFchH[j] = T-MATG.PromFchH[k].
        END.
    END.
END.
EMPTY TEMP-TABLE T-MATG.
RUN dispatch IN h_butilexdctoprom-02 ('open-query':U).

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

