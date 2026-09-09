&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE E-MATG NO-UNDO LIKE Almmmatg
       INDEX Idx00 AS PRIMARY CodMat FchPrmD.
DEFINE NEW SHARED TEMP-TABLE T-DVOL LIKE PriDctoVol.
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

DEFINE VARIABLE RADIO-SET-1 AS INTEGER NO-UNDO.
DEFINE VARIABLE RADIO-SET-2 AS INTEGER NO-UNDO.

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-3 BtnDone COMBO-BOX-Division BUTTON-1 ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-huancayo-import-dctovol AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-huancayo-import-dctovol AS HANDLE NO-UNDO.

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

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 67 BY 1
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 151 BY 1.92
     BGCOLOR 11 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.27 COL 145 WIDGET-ID 6
     COMBO-BOX-Division AT ROW 1.38 COL 12 COLON-ALIGNED WIDGET-ID 32
     BUTTON-1 AT ROW 1.38 COL 82 WIDGET-ID 2
     BUTTON-2 AT ROW 1.38 COL 107 WIDGET-ID 4
     RECT-3 AT ROW 1 COL 1 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 152.14 BY 21.42 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: E-MATG T "NEW SHARED" NO-UNDO INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY CodMat FchPrmD
      END-FIELDS.
      TABLE: T-DVOL T "NEW SHARED" ? INTEGRAL PriDctoVol
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
         TITLE              = "DESCUENTOS POR VOLUMEN"
         HEIGHT             = 21.42
         WIDTH              = 152.14
         MAX-HEIGHT         = 21.42
         MAX-WIDTH          = 159.14
         VIRTUAL-HEIGHT     = 21.42
         VIRTUAL-WIDTH      = 159.14
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DESCUENTOS POR VOLUMEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DESCUENTOS POR VOLUMEN */
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
    IF OKpressed = FALSE THEN RETURN.

    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    SESSION:SET-WAIT-STATE('GENERAL').
    pMensaje = ''.
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').

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
        COMBO-BOX-Division:SENSITIVE IN FRAME {&FRAME-NAME} = NO
        BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division W-Win
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME F-Main /* División */
DO:
  ASSIGN {&self-name}.
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
             INPUT  'PRI/b-huancayo-import-dctovol.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-huancayo-import-dctovol ).
       RUN set-position IN h_b-huancayo-import-dctovol ( 2.92 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-huancayo-import-dctovol ( 19.04 , 108.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PRI/v-huancayo-import-dctovol.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-huancayo-import-dctovol ).
       RUN set-position IN h_v-huancayo-import-dctovol ( 3.15 , 110.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.96 , 42.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 14.12 , 111.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartViewer h_v-huancayo-import-dctovol. */
       RUN add-link IN adm-broker-hdl ( h_b-huancayo-import-dctovol , 'Record':U , h_v-huancayo-import-dctovol ).
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_v-huancayo-import-dctovol ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-huancayo-import-dctovol ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-huancayo-import-dctovol ,
             h_b-huancayo-import-dctovol , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             h_v-huancayo-import-dctovol , 'AFTER':U ).
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

DEF VAR cNombreLista AS CHAR NO-UNDO.
DEF VAR k         AS INT NO-UNDO.
DEF VAR x-DtoVolR AS DEC NO-UNDO.
DEF VAR x-DtoVolD AS DEC NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.

IF NOT (cValue BEGINS "CONTINENTAL - DESCUENTOS POR VOLUMEN"
        OR cValue BEGINS "UTILEX - DESCUENTOS POR VOLUMEN"
        OR cValue BEGINS "POR DIVISION - DESCUENTOS POR VOLUMEN"
        )
    THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
cNombreLista = cValue.

ASSIGN
    t-Row    = t-Row + 1
    t-column = t-column + 1.
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
    WHEN cNombreLista BEGINS "CONTINENTAL - DESCUENTOS POR VOLUMEN" THEN RADIO-SET-1 = 1.
    WHEN cNombreLista BEGINS "UTILEX - DESCUENTOS POR VOLUMEN"      THEN RADIO-SET-1 = 2.
    WHEN cNombreLista BEGINS "POR DIVISION - DESCUENTOS POR VOLUMEN" THEN RADIO-SET-1 = 3.
    OTHERWISE RETURN.
END CASE.
CASE TRUE:
    WHEN INDEX(cNombreLista, "- PORCENTAJES") > 0 THEN RADIO-SET-2 = 1.
    WHEN INDEX(cNombreLista, "- IMPORTES") > 0 THEN RADIO-SET-2 = 2.
    OTHERWISE RETURN.
END CASE.
RUN Pinta-Titulo IN h_b-huancayo-import-dctovol ( INPUT cNombreLista /* CHARACTER */).

/* Cargamos temporal */
EMPTY TEMP-TABLE T-MATG.
EMPTY TEMP-TABLE T-DVOL.
ASSIGN
    t-Column = 0
    t-Row = 2.     /* Saltamos el encabezado de los campos */
RLOOP:
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE RLOOP.    /* FIN DE DATOS */ 

    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
        Almmmatg.codmat = cValue NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "CODIGO".
        LEAVE RLOOP.
    END.

    FIND T-MATG WHERE T-MATG.CodCia = s-CodCia AND T-MATG.CodMat = cValue EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MATG THEN CREATE T-MATG.
    ASSIGN
        T-MATG.codcia = s-codcia
        T-MATG.codmat = cValue.

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.desmat = cValue.
    /* División */
    CREATE T-DVOL.
    ASSIGN
        T-DVOL.CodCia = T-MATG.CodCia
        T-DVOL.CodMat = T-MATG.CodMat.
    t-Column = t-Column + 7.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DVOL.CodDiv = cValue.
    /* Vigencia */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DVOL.FchIni = DATE(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR OR T-DVOL.FchIni = ? THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "DESDE".
        LEAVE RLOOP.
    END.
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DVOL.FchFin = DATE(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR OR T-DVOL.FchFin = ? THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "HASTA".
        LEAVE RLOOP.
    END.
    /* Cargamos Descuentos por Volumen */
    k = 1.
    DO iCountLine = 1 TO 5:
        t-Column = t-Column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            x-DtoVolR = DECIMAL(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "Rango".
            LEAVE RLOOP.
        END.

        t-Column = t-Column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            x-DtoVolD = DECIMAL(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "Descuento".
            LEAVE RLOOP.
        END.

        IF x-DtoVolR = ? OR x-DtoVolR = 0 OR x-DtoVolR < 0
            OR x-DtoVolD = ? OR x-DtoVolD = 0 OR x-DtoVolD < 0 THEN NEXT.
        ASSIGN
            T-DVOL.DtoVolR[k]  = x-DtoVolR
            T-DVOL.DtoVolD[k]  = x-DtoVolD.
        k = k + 1.
    END.
END.

/* EN CASO DE ERROR */
IF pMensaje <> "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    EMPTY TEMP-TABLE T-DVOL.
    RETURN.
END.
/* Cargamos precios actuales */
RLOOP:
FOR EACH T-MATG, EACH T-DVOL WHERE T-DVOL.CodMat = T-MATG.CodMat:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    FIND VtaListaMinGn WHERE VtaListaMinGn.codcia = s-codcia
        AND VtaListaMinGn.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia
        AND VtaListaMay.codmat = T-MATG.codmat
        AND VtaListaMay.coddiv = COMBO-BOX-Division
        NO-LOCK NO-ERROR.
    ASSIGN
        T-MATG.CtoTot = Almmmatg.CtoTot
        T-MATG.MonVta = Almmmatg.MonVta
        T-MATG.TpoCmb = Almmmatg.TpoCmb.
    CASE RADIO-SET-1:
        WHEN 1 THEN DO:
            ASSIGN
                T-MATG.Chr__01 = Almmmatg.Chr__01 
                T-MATG.PreOfi = Almmmatg.PreOfi 
                T-MATG.Prevta[1] = Almmmatg.PreOfi.
        END.
        WHEN 2 THEN DO:
            IF NOT AVAILABLE VtaListaMinGn THEN DO:
                DELETE T-MATG.
                NEXT RLOOP.
            END.
            ASSIGN
                T-MATG.Chr__01 = VtaListaMinGn.Chr__01 
                T-MATG.PreOfi = VtaListaMinGn.PreOfi 
                T-MATG.Prevta[1] = VtaListaMinGn.PreOfi.
        END.
        WHEN 3 THEN DO:
            IF NOT AVAILABLE VtaListaMay THEN DO:
                DELETE T-MATG.
                NEXT RLOOP.
            END.
            ASSIGN
                T-MATG.Chr__01 = VtaListaMay.Chr__01 
                T-MATG.PreOfi = VtaListaMay.PreOfi 
                T-MATG.Prevta[1] = VtaListaMay.PreOfi.
        END.
    END CASE.
    IF T-MATG.MonVta = 2 THEN
        ASSIGN
        T-MATG.CtoTot = T-MATG.CtoTot * Almmmatg.TpoCmb
        T-MATG.PreOfi = T-MATG.PreOfi * Almmmatg.TpoCmb
        T-MATG.Prevta[1] = T-MATG.Prevta[1] * Almmmatg.TpoCmb.
    /* Corregimos de acuerdo al método de cálculo */
    IF RADIO-SET-2 = 2 THEN DO:
        DO iValue = 1 TO 5:
            IF T-DVOL.DtoVolD[iValue] > 0 THEN
            T-DVOL.DtoVolD[iValue] = ROUND ( ( 1 -  T-DVOL.DtoVolD[iValue] / T-MATG.PreVta[1]  ) * 100, 6 ).
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

/* Actualizamos precios */
FOR EACH T-MATG, EACH T-DVOL WHERE T-DVOL.CodMat = T-MATG.CodMat:
    DO iValue = 1 TO 10:
        T-DVOL.DtoVolP[iValue] = ROUND(T-MATG.PreVta[1] * (1 - (T-DVOL.DtoVolD[iValue] / 100)), 4).
    END.
END.

ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

RUN dispatch IN h_b-huancayo-import-dctovol ('open-query':U).

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
  DISPLAY COMBO-BOX-Division 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-3 BtnDone COMBO-BOX-Division BUTTON-1 BUTTON-2 
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

DEF VAR pError AS CHAR NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR x-PreUni AS DEC NO-UNDO.
DEF VAR iCuentaRangos AS INT NO-UNDO.

DEF VAR k AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.

MESSAGE 'Procedemos a grabar los descuentos por volumen?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

/* *************************************************************************** */
/* ERRORES */
/* *************************************************************************** */
EMPTY TEMP-TABLE E-MATG.
trloop:
FOR EACH T-MATG NO-LOCK, EACH T-DVOL NO-LOCK WHERE T-DVOL.CodMat = T-MATG.CodMat:
    /* Cargamos informacion */
    DO k = 1 TO 10:
        IF T-DVOL.DtoVolD[k] <> 0 THEN DO:
            RUN vtagn/p-margen-utilidad (
                T-MATG.CodMat,
                T-MATG.PreVta[1] * ( 1 - (T-DVOL.DtoVolD[k] / 100) ),
                T-MATG.CHR__01,
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
                    E-MATG.Libre_c01 = "Margen de utilidad NO debe ser menor a " + TRIM(STRING(x-Limite, ">>>,>>9.99")).
                DELETE T-MATG.
                NEXT trloop.
            END.
        END.
    END.
END.
/* CONSISTENCIA CANTIDAD DE RANGOS */
trloop:
FOR EACH T-MATG NO-LOCK, EACH T-DVOL NO-LOCK WHERE T-DVOL.CodMat = T-MATG.CodMat:
    /* Cargamos informacion */
    iCuentaRangos = 0.
    DO k = 1 TO 10:
        IF T-DVOL.DtoVolR[k] <> 0 THEN iCuentaRangos = iCuentaRangos + 1.
    END.
    IF iCuentaRangos = 0 THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN 
            E-MATG.Libre_c01 = "Debe definir al menos un rango".
        DELETE T-DVOL.
        NEXT trloop.
    END.
END.
/* CONSISTENCIA DE MENOR A MAYOR */
trloop:
FOR EACH T-MATG NO-LOCK, EACH T-DVOL NO-LOCK WHERE T-DVOL.CodMat = T-MATG.CodMat:
    /* Cargamos informacion */
    iCuentaRangos = 0.
    DO k = 1 TO 10:
        IF iCuentaRangos > 0 AND T-DVOL.DtoVolR[k] > 0
            AND T-DVOL.DtoVolR[k] < iCuentaRangos 
            THEN DO:
            CREATE E-MATG.
            BUFFER-COPY T-MATG 
                TO E-MATG
                ASSIGN 
                E-MATG.Libre_c01 = "Debe definir los rangos de menor a mayor".
            DELETE T-MATG.
            NEXT trloop.
        END.
        iCuentaRangos = T-DVOL.DtoVolR[k].
    END.
END.
/* *************************************************************************** */
/* *************************************************************************** */
FOR EACH T-MATG, 
    EACH T-DVOL NO-LOCK WHERE T-DVOL.CodMat = T-MATG.CodMat,
    FIRST gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = T-DVOL.CodDiv
    ON STOP UNDO, RETURN ON ERROR UNDO, RETURN:
    /* Limpiamos informacion */
    FOR EACH PRIDctoVol EXCLUSIVE-LOCK WHERE PRIDctoVol.CodCia = s-CodCia AND
        PRIDctoVol.CodDiv = T-DVOL.CodDiv AND
        PRIDctoVol.CodMat = T-DVOL.CodMat AND
/*         PriDctoVol.Canal = GN-DIVI.CanalVenta AND    */
/*         PriDctoVol.Grupo = GN-DIVI.Grupo_Divi_GG AND */
        (TODAY >= PRIDctoVol.FchIni OR TODAY <= PRIDctoVol.FchFin):
        DELETE PRIDctoVol.
    END.
END.
FOR EACH T-MATG, 
    EACH T-DVOL NO-LOCK WHERE T-DVOL.CodMat = T-MATG.CodMat,
    FIRST gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = T-DVOL.CodDiv 
    ON STOP UNDO, RETURN ON ERROR UNDO, RETURN:
    CREATE PRIDctoVol.
    ASSIGN
        PRIDctoVol.CodCia = T-MATG.CodCia
        PRIDctoVol.CodMat = T-MATG.CodMat
        PRIDctoVol.CodDiv = T-DVOL.CodDiv
/*         PriDctoVol.Canal = GN-DIVI.CanalVenta    */
/*         PriDctoVol.Grupo = GN-DIVI.Grupo_Divi_GG */
        PRIDctoVol.FchIni = T-DVOL.FchIni
        PRIDctoVol.FchFin = T-DVOL.FchFin
        PRIDctoVol.FchCreacion = TODAY
        PRIDctoVol.UsrCreacion = s-user-id
        PRIDctoVol.HoraCreacion = STRING(TIME, 'HH:MM:SS').
    /* TODO EN SOLES */
    x-PreUni = T-MATG.PreVta[1].
    IF T-MATG.MonVta = 2 THEN x-PreUni = x-PreUni * T-MATG.TpoCmb.
    DO k = 1 TO 10:
        ASSIGN
            PRIDctoVol.DtoVolR[k] = 0
            PRIDctoVol.DtoVolD[k] = 0
            PRIDctoVol.DtoVolP[k] = 0.
    END.
    /* Cargamos informacion */
    DO k = 1 TO 10:
        ASSIGN
            PRIDctoVol.DtoVolR[k] = T-DVOL.DtoVolR[k]
            PRIDctoVol.DtoVolD[k] = T-DVOL.DtoVolD[k]
            PRIDctoVol.DtoVolP[k] = ROUND(x-PreUni * (1 - (PRIDctoVol.DtoVolD[k] / 100)), 4).
    END.
    DO k = 1 TO 10:
        IF PRIDctoVol.DtoVolR[k] = 0 OR PRIDctoVol.DtoVolD[k] = 0
        THEN ASSIGN
                  PRIDctoVol.DtoVolR[k] = 0
                  PRIDctoVol.DtoVolD[k] = 0
            PRIDctoVol.DtoVolP[k] = 0.
    END.
END.
EMPTY TEMP-TABLE T-MATG.
EMPTY TEMP-TABLE T-DVOL.

RUN dispatch IN h_b-huancayo-import-dctovol ('open-query':U).

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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Division:DELETE(1).
/*       FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia                                  */
/*           AND gn-divi.campo-log[1] = no                                                         */
/*           AND LOOKUP(gn-divi.CanalVenta, "ATL,HOR,INS,PRO,TDA") > 0                             */
/*           AND GN-DIVI.VentaMayorista = 2:                                                       */
/*           COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv, gn-divi.coddiv). */
/*       END.                                                                                      */
/*       COMBO-BOX-Division = s-coddiv.                                                            */
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = '00072'
          AND gn-divi.campo-log[1] = NO:
          COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv, gn-divi.coddiv).
          COMBO-BOX-Division = gn-divi.coddiv.
      END.
  END.

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

