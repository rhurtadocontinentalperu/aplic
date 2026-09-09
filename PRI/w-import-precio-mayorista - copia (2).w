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
DEF SHARED VAR s-coddiv AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS RECT-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_t-import-precio-mayorista-1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-import-precio-mayorista-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-import-precio-mayorista-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-import-precio-mayorista-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-import-precio-mayorista-5 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CAPTURAR EXCEL" 
     SIZE 25 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GRABAR PRECIOS" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 78 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 142.43 BY 1.54
     BGCOLOR 11 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Division AT ROW 1.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-1 AT ROW 1.19 COL 84 WIDGET-ID 2
     BUTTON-2 AT ROW 1.19 COL 109 WIDGET-ID 4
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.43 BY 18.31 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
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
         TITLE              = "IMPORTAR PRECIOS XMAYOR Y XMENOR"
         HEIGHT             = 18.31
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
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPORTAR PRECIOS XMAYOR Y XMENOR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPORTAR PRECIOS XMAYOR Y XMENOR */
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
    MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR PRECIOS */
DO:
    CASE RADIO-SET-1:
        WHEN 1 THEN RUN Grabar-Precios-Conti.
        WHEN 2 THEN RUN Grabar-Precios-Utilex.
        WHEN 3 THEN RUN Grabar-Precios-Division.
        WHEN 4 THEN RUN Grabar-Precios-Marco.
        WHEN 5 THEN RUN Grabar-Precios-Remate.
    END CASE.
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
             INPUT  'PRI/t-import-precio-mayorista-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-import-precio-mayorista-1 ).
       RUN set-position IN h_t-import-precio-mayorista-1 ( 2.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-import-precio-mayorista-1 ( 16.35 , 140.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-import-precio-mayorista-1 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PRI/t-import-precio-mayorista-2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-import-precio-mayorista-2 ).
       RUN set-position IN h_t-import-precio-mayorista-2 ( 2.54 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-import-precio-mayorista-2 ( 16.35 , 135.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-import-precio-mayorista-2 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PRI/t-import-precio-mayorista-3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-import-precio-mayorista-3 ).
       RUN set-position IN h_t-import-precio-mayorista-3 ( 2.54 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-import-precio-mayorista-3 ( 16.35 , 139.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-import-precio-mayorista-3 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PRI/t-import-precio-mayorista-4.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-import-precio-mayorista-4 ).
       RUN set-position IN h_t-import-precio-mayorista-4 ( 2.54 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-import-precio-mayorista-4 ( 16.35 , 138.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-import-precio-mayorista-4 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PRI/t-import-precio-mayorista-5.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-import-precio-mayorista-5 ).
       RUN set-position IN h_t-import-precio-mayorista-5 ( 2.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-import-precio-mayorista-5 ( 16.35 , 138.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-import-precio-mayorista-5 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 5 */

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
IF NOT (cValue = "CONTINENTAL - PRECIOS"
        OR cValue = "UTILEX - PRECIOS" 
        OR cValue = s-coddiv + " - PRECIOS"
        OR cValue = "CONTRATO MARCO - PRECIOS"
        OR cValue = "REMATE - PRECIOS")
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
    WHEN "CONTINENTAL - PRECIOS"    THEN RADIO-SET-1 = 1.
    WHEN "UTILEX - PRECIOS"         THEN RADIO-SET-1 = 2.
    WHEN s-coddiv + " - PRECIOS"    THEN RADIO-SET-1 = 3.
    WHEN "CONTRATO MARCO - PRECIOS" THEN RADIO-SET-1 = 4.
    WHEN "REMATE - PRECIOS"         THEN RADIO-SET-1 = 5.
    OTHERWISE RETURN.
END CASE.

CASE RADIO-SET-1:
    WHEN 1 THEN RUN Carga-Temporal-Conti.
    WHEN 2 THEN RUN Carga-Temporal-Utilex.
    WHEN 3 THEN RUN Carga-Temporal-Division.
    WHEN 4 THEN RUN Carga-Temporal-Marco.
    WHEN 5 THEN RUN Carga-Temporal-Remate.
END CASE.
/* Filtramos solo lineas autorizadas */
FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK:
    FIND Vtatabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = "LP"
        AND Vtatabla.llave_c1 = s-user-id
        AND Vtatabla.llave_c2 = Almmmatg.codfam
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtatabla THEN DELETE T-MATG.
END.
ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

/* RECALCULAMOS Y PINTAMOS RESULTADOS */
CASE RADIO-SET-1:
    WHEN 1 THEN DO:
        RUN select-page ('1').
        RUN Recalcular IN h_t-import-precio-mayorista-1.
        RUN dispatch IN h_t-import-precio-mayorista-1 ('open-query':U).
    END.
    WHEN 2 THEN DO:
        RUN select-page ('2').
        RUN Recalcular IN h_t-import-precio-mayorista-2.
        RUN dispatch IN h_t-import-precio-mayorista-2 ('open-query':U).
    END.
    WHEN 3 THEN DO: 
        RUN select-page ('3').
        RUN Recalcular IN h_t-import-precio-mayorista-3.
        RUN dispatch IN h_t-import-precio-mayorista-3 ('open-query':U).
    END.
    WHEN 4 THEN DO: 
        RUN select-page ('4').
        RUN Recalcular IN h_t-import-precio-mayorista-4.
        RUN dispatch IN h_t-import-precio-mayorista-4 ('open-query':U).
    END.
    WHEN 5 THEN DO: 
        RUN select-page ('5').
        RUN Recalcular IN h_t-import-precio-mayorista-5.
        RUN dispatch IN h_t-import-precio-mayorista-5 ('open-query':U).
    END.
END CASE.

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

EMPTY TEMP-TABLE T-MATG.
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
    /* MONEDA DE VENTA */        
    t-Column = t-Column + 19.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    CASE cValue:
        WHEN "S/." THEN T-MATG.MonVta = 1.
        WHEN "US$" THEN T-MATG.MonVta = 2.
        OTHERWISE DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "La Moneda de Venta debe ser S/. o US$".
            LEAVE.
        END.
    END CASE.
    /* PRECIOS */        
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.Prevta[1] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio Lista".
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
IF pMensaje <> "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    RETURN.
END.
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE (T-MATG.Prevta[1] = 0 OR T-MATG.Prevta[1] = ?)
    OR (T-MATG.Prevta[2] = 0 OR T-MATG.Prevta[2] = ?):
    DELETE T-MATG.
END.
FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK WHERE (Almmmatg.CtoLis = 0 OR Almmmatg.CtoLis = ?)
    OR (Almmmatg.CtoTot = 0 OR Almmmatg.CtoTot = ?)
    OR (Almmmatg.TpoCmb = 0 OR Almmmatg.TpoCmb = ?)
    OR Almmmatg.MonVta = 0:
    DELETE T-MATG.
END.
/* Cargamos importes actuales A LA MONEDA DE LA LP */
FOR EACH T-MATG, 
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = T-MATG.codmat
    NO-LOCK:
    ASSIGN
        T-MATG.CodCia  = Almmmatg.CodCia
        T-MATG.UndBas  = Almmmatg.UndBas
        T-MATG.DesMar  = Almmmatg.DesMar
        T-MATG.AftIgv  = Almmmatg.AftIgv
        T-MATG.Chr__01 = Almmmatg.Chr__01 
        T-MATG.Chr__02 = Almmmatg.Chr__02 
        T-MATG.Dec__01 = Almmmatg.Dec__01 
        /*T-MATG.MonVta = Almmmatg.MonVta */    /* La Moneda LP viene desde el Excel */
        T-MATG.TpoCmb = Almmmatg.TpoCmb
        T-MATG.CtoLis = Almmmatg.CtoLis
        T-MATG.CtoTot = Almmmatg.CtoTot
        T-MATG.UndA = Almmmatg.UndA
        T-MATG.UndB = Almmmatg.UndB
        T-MATG.UndC = Almmmatg.UndC
        T-MATG.PreVta[1] = (IF T-MATG.PreVta[1] = ? THEN 0 ELSE T-MATG.PreVta[1])
        T-MATG.PreVta[2] = (IF T-MATG.PreVta[2] = ? THEN 0 ELSE T-MATG.PreVta[2])
        T-MATG.PreVta[3] = (IF T-MATG.PreVta[3] = ? THEN 0 ELSE T-MATG.PreVta[3])
        T-MATG.PreVta[4] = (IF T-MATG.PreVta[4] = ? THEN 0 ELSE T-MATG.PreVta[4]).
    /* RHC Limpiamos información en exceso */
    IF T-MATG.UndC = '' THEN ASSIGN T-MATG.MrgUti-C = 0 T-MATG.Prevta[4] = 0.
    IF T-MATG.UndB = '' THEN ASSIGN T-MATG.MrgUti-B = 0 T-MATG.Prevta[3] = 0.
    IF T-MATG.UndA = '' THEN ASSIGN T-MATG.MrgUti-A = 0 T-MATG.Prevta[2] = 0.
END.

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
        T-MATG.codmat = STRING(DECIMAL(cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Código " + cValue.
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
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio de Oficina " + cValue.
        LEAVE.
    END.
END.
IF pMensaje <> "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    RETURN.
END.
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE (T-MATG.PreOfi = 0 OR T-MATG.PreOfi = ?):
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Marco W-Win 
PROCEDURE Carga-Temporal-Marco :
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
        T-MATG.PreOfi = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio Oficina".
        LEAVE.
    END.

    t-Column = t-Column + 3.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.CtoTot = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Costo MARCO".
        LEAVE.
    END.
END.
IF pMensaje <> "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    RETURN.
END.
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE T-MATG.PreOfi = 0 OR T-MATG.PreOfi = ?
    OR T-MATG.CtoTot = 0 OR T-MATG.CtoTot = ?:
    DELETE T-MATG.
END.
/* *********************************** */
/* Cargamos precios actuales */
FOR EACH T-MATG:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat
        NO-LOCK.
    FIND Almmmatp WHERE Almmmatp.codcia = s-codcia
        AND Almmmatp.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    ASSIGN
        T-MATG.CodCia  = Almmmatg.CodCia
        T-MATG.UndBas  = Almmmatg.UndBas
        T-MATG.DesMar  = Almmmatg.DesMar
        T-MATG.CHR__01 = Almmmatg.Chr__01
        T-MATG.MonVta  = Almmmatg.MonVta
        T-MATG.TpoCmb  = Almmmatg.TpoCmb.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Remate W-Win 
PROCEDURE Carga-Temporal-Remate :
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
        T-MATG.PreOfi = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio Oficina".
        LEAVE.
    END.

    t-Column = t-Column + 3.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.CtoTot = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Costo MARCO".
        LEAVE.
    END.
END.
IF pMensaje <> "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    RETURN.
END.
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
    ASSIGN
        T-MATG.CodCia  = Almmmatg.CodCia
        T-MATG.UndBas  = Almmmatg.UndBas
        T-MATG.DesMar  = Almmmatg.DesMar
        T-MATG.CHR__01 = Almmmatg.Chr__01
        T-MATG.MonVta  = Almmmatg.MonVta
        T-MATG.TpoCmb  = Almmmatg.TpoCmb.
END.

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
    CREATE T-MATG.
    ASSIGN
        T-MATG.codcia = s-codcia
        T-MATG.codmat = STRING(INTEGER(cValue), '999999').

    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.desmat = cValue.
    
    t-Column = t-Column + 6.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-MATG.PreAlt[1] = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
            + "Precio de Lista".
        LEAVE.
    END.
END.
IF pMensaje <> "" THEN DO:
    EMPTY TEMP-TABLE T-MATG.
    RETURN.
END.
/* DEPURAMOS LOS QUE NO TIENEN PRECIO */
FOR EACH T-MATG WHERE T-MATG.PreAlt[1] = 0 OR T-MATG.PreAlt[1] = ?:
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
  DISPLAY FILL-IN-Division 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 BUTTON-1 
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
DEF VAR f-Factor AS DECI NO-UNDO.

/* CONSISTENCIAS FINALES */
EMPTY TEMP-TABLE E-MATG.
EMPTY TEMP-TABLE A-MATG.
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
            ASSIGN E-MATG.Libre_c01 = "Error en el Precio de Lista".
        DELETE T-MATG.
        NEXT.
    END.
    IF T-MATG.PreOfi <= 0 THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Error en el Precio de Oficina".
        DELETE T-MATG.
        NEXT.
    END.
    /* Por margenes de utilidad */
    IF T-MATG.MrgUti-A < 0 THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Margen de utilidad para la lista A NO debe ser negativo".
        DELETE T-MATG.
        NEXT.
    END.
    IF T-MATG.MrgUti-B < 0 THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Margen de utilidad para la lista B NO debe ser negativo".
        DELETE T-MATG.
        NEXT.
    END.
    IF T-MATG.MrgUti-C < 0 THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Margen de utilidad para la lista C NO debe ser negativo".
        DELETE T-MATG.
        NEXT.
    END.
    IF T-MATG.DEC__01 < 0 THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Margen de utilidad de Oficina NO debe ser negativo".
        DELETE T-MATG.
        NEXT.
    END.
    IF T-MATG.MrgUti-C > T-MATG.MrgUti-B THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Margen de util. C as mayor que el margen de util. B".
        DELETE T-MATG.
        NEXT.
    END.
    IF T-MATG.MrgUti-B > T-MATG.MrgUti-A THEN DO:
        CREATE E-MATG.
        BUFFER-COPY T-MATG 
            TO E-MATG
            ASSIGN E-MATG.Libre_c01 = "Margen de util. B as mayor que el margen de util. A".
        DELETE T-MATG.
        NEXT.
    END.
    /* ****************************************************************************************************** */
    /* Control Margen de Utilidad */
    /* ****************************************************************************************************** */
    IF T-MATG.Prevta[1] > 0 THEN DO:
        F-Factor = 1.                    
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas AND Almtconv.Codalter = T-MATG.UndStk NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        x-PreUni = T-MATG.PreVta[1] / f-Factor.
        RUN Verifica-Margen (INPUT x-PreUni, OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            CREATE E-MATG.
            BUFFER-COPY T-MATG TO E-MATG
                ASSIGN E-MATG.Libre_c01 = 'Precio de Lista: ' + pError.
            DELETE T-MATG.
            NEXT.
        END.
        IF pError > '' THEN DO:
            CREATE A-MATG.
            BUFFER-COPY T-MATG TO A-MATG
                ASSIGN A-MATG.Libre_c01 = 'Precio de Lista: ' + pError.
            NEXT.
        END.
    END.
    IF T-MATG.Prevta[2] > 0 THEN DO:
        F-Factor = 1.                    
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas AND Almtconv.Codalter = T-MATG.UndA NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        x-PreUni = T-MATG.PreVta[2] / f-Factor.
        RUN Verifica-Margen (INPUT x-PreUni, OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            CREATE E-MATG.
            BUFFER-COPY T-MATG TO E-MATG
                ASSIGN E-MATG.Libre_c01 = 'Precio A: ' + pError.
            DELETE T-MATG.
            NEXT.
        END.
        IF pError > '' THEN DO:
            CREATE A-MATG.
            BUFFER-COPY T-MATG TO A-MATG
                ASSIGN A-MATG.Libre_c01 = 'Precio A: ' + pError.
            NEXT.
        END.
    END.
    IF T-MATG.Prevta[3] > 0 THEN DO:
        F-Factor = 1.                    
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas AND Almtconv.Codalter = T-MATG.UndB NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        x-PreUni = T-MATG.PreVta[3] / f-Factor.
        RUN Verifica-Margen (INPUT x-PreUni, OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            CREATE E-MATG.
            BUFFER-COPY T-MATG TO E-MATG
                ASSIGN E-MATG.Libre_c01 = 'Precio B: ' + pError.
            DELETE T-MATG.
            NEXT.
        END.
        IF pError > '' THEN DO:
            CREATE A-MATG.
            BUFFER-COPY T-MATG TO A-MATG
                ASSIGN E-MATG.Libre_c01 = 'Precio B: ' + pError.
            NEXT.
        END.
    END.
    IF T-MATG.Prevta[4] > 0 THEN DO:
        F-Factor = 1.                    
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas AND Almtconv.Codalter = T-MATG.UndC NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        x-PreUni = T-MATG.PreVta[4] / f-Factor.
        RUN Verifica-Margen (INPUT x-PreUni, OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            CREATE E-MATG.
            BUFFER-COPY T-MATG TO E-MATG
                ASSIGN E-MATG.Libre_c01 = 'Precio C: ' + pError.
            DELETE T-MATG.
            NEXT.
        END.
        IF pError > '' THEN DO:
            CREATE A-MATG.
            BUFFER-COPY T-MATG TO A-MATG
                ASSIGN E-MATG.Libre_c01 = 'Precio C: ' + pError.
            NEXT.
        END.
    END.
END.
/* ****************************************************************************************************** */
FOR EACH T-MATG ON STOP UNDO, RETURN ON ERROR UNDO, RETURN:
    FIND Almmmatg OF T-MATG EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN.
    END.
    FIND AlmmmatgExt OF Almmmatg NO-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmmmatgExt THEN DO:
        RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
        UNDO, RETURN.
    END.
    /* SE GRABA TODO EN MONEDA LP */
    ASSIGN
        Almmmatg.MrgUti    = T-MATG.MrgUti
        Almmmatg.Dsctos[1] = T-MATG.Dsctos[1]
        Almmmatg.Dsctos[2] = T-MATG.Dsctos[2]
        Almmmatg.Dsctos[3] = T-MATG.Dsctos[3]
        Almmmatg.PreVta[1] = T-MATG.PreVta[1]
        Almmmatg.MrgUti-A  = T-MATG.MrgUti-A
        Almmmatg.Prevta[2] = T-MATG.Prevta[2]
        Almmmatg.MrgUti-B  = T-MATG.MrgUti-B
        Almmmatg.PreVta[3] = T-MATG.Prevta[3]
        Almmmatg.MrgUti-C  = T-MATG.MrgUti-C
        Almmmatg.PreVta[4] = T-MATG.Prevta[4]
        Almmmatg.Dec__01   = T-MATG.Dec__01
        Almmmatg.PreOfi    = T-MATG.PreOfi.
    /* ****************************************************************************************************** */
    /* ACTUALIZAMOS LA MONEDA DE VENTA */
    /* ****************************************************************************************************** */
    DEF VAR f-PorIgv AS DECI NO-UNDO.
    f-PorIgv = 0.
    IF Almmmatg.CtoLis > 0 THEN f-PorIgv = ( (Almmmatg.CtoTot / Almmmatg.CtoLis) - 1 ) * 100.
    ASSIGN
        Almmmatg.MonVta = T-MATG.MonVta.
    IF Almmmatg.MonVta = Almmmatg.DsctoProm[1] THEN     /* MOneda LP vs Moneda de Compra */
        ASSIGN
        Almmmatg.CtoTot = Almmmatg.DsctoProm[2].
    ELSE IF Almmmatg.MonVta = 1 THEN
        ASSIGN
        Almmmatg.CtoTot = Almmmatg.DsctoProm[2] * Almmmatg.TpoCmb.
    ELSE ASSIGN
        Almmmatg.CtoTot = Almmmatg.DsctoProm[2] / Almmmatg.TpoCmb.
    ASSIGN
        Almmmatg.CtoLis = Almmmatg.DsctoPro[2] / ( 1 + ( f-PorIgv / 100) ).
    /* ****************************************************************************************************** */
    /* ****************************************************************************************************** */
    ASSIGN
        Almmmatg.FchmPre[1] = TODAY
        Almmmatg.Usuario = S-USER-ID
        Almmmatg.FchAct  = TODAY.
END.
EMPTY TEMP-TABLE T-MATG.

RUN dispatch IN h_t-import-precio-mayorista-1 ('open-query':U).

END PROCEDURE.

PROCEDURE Verifica-Margen:
/* ********************** */

    DEF INPUT PARAMETER x-PreUni AS DECI.
    DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

    DEFINE VAR x-Margen AS DECI NO-UNDO.
    DEFINE VAR x-Limite AS DECI NO-UNDO.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    /* 1ro. Calculamos el margen de utilidad */
    RUN pri/pri-librerias PERSISTENT SET hProc.

    RUN PRI_Margen-Utilidad IN hProc (INPUT "",                                                     /* OJO */
                                      INPUT T-MATG.codmat,
                                      INPUT T-MATG.UndBas,
                                      INPUT x-PreUni,
                                      INPUT T-MATG.MonVta,
                                      OUTPUT x-Margen,
                                      OUTPUT x-Limite,
                                      OUTPUT pError).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    /* Controlamos si el margen de utilidad está bajo a través de la variable pError */
    IF pError > '' THEN DO:
        /* Error por margen de utilidad */
        /* 2do. Verificamos si solo es una ALERTA, definido por GG */
        DEF VAR pAlerta AS LOG NO-UNDO.
        RUN PRI_Alerta-de-Margen IN hProc (INPUT T-MATG.codmat, OUTPUT pAlerta).
        IF pAlerta = NO THEN RETURN 'ADM-ERROR'.
    END.
    DELETE PROCEDURE hProc.
    RETURN 'OK'.

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
                                      INPUT 1,
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
    /* ****************************************************************************************************** */
    FIND FIRST VtaListaMay OF T-MATG WHERE VtaListaMay.CodDiv = s-CodDiv NO-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE VtaListaMay THEN DO:
        CREATE VtaListaMay.
        ASSIGN
            VtaListaMay.CodCia = s-codcia
            VtaListaMay.CodDiv = s-coddiv
            VtaListaMay.codmat = Almmmatg.codmat.
    END.
    ELSE DO:
        FIND FIRST VtaListaMay OF T-MATG WHERE VtaListaMay.CodDiv = s-CodDiv EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pError"}
            /* Error crítico */
            CREATE E-MATG.
            BUFFER-COPY T-MATG TO E-MATG ASSIGN E-MATG.Libre_c01 = pError.
            DELETE T-MATG.
            NEXT.
        END.
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
    ASSIGN VtaListaMay.Dec__01 = ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100.
END.
EMPTY TEMP-TABLE T-MATG.
DELETE PROCEDURE hProc.

RUN dispatch IN h_t-import-precio-mayorista-3 ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Precios-Marco W-Win 
PROCEDURE Grabar-Precios-Marco :
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

EMPTY TEMP-TABLE E-MATG.
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
    FIND Almmmatp OF T-MATG NO-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE Almmmatp THEN DO:
        CREATE Almmmatp.
        ASSIGN
            Almmmatp.CodCia = Almmmatg.codcia
            Almmmatp.codmat = Almmmatg.codmat
            Almmmatp.FchIng = TODAY.
    END.
    ELSE DO:
        FIND Almmmatp OF T-MATG EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pError"}
            /* Error crítico */
            CREATE E-MATG.
            BUFFER-COPY T-MATG TO E-MATG ASSIGN E-MATG.Libre_c01 = pError.
            DELETE T-MATG.
            NEXT.
        END.
    END.
    ASSIGN
        Almmmatp.MonVta  = T-MATG.MonVta
        Almmmatp.TpoCmb  = T-MATG.TpoCmb
        Almmmatp.Chr__01 = T-MATG.Chr__01
        Almmmatp.PreOfi  = T-MATG.PreOfi
        Almmmatp.CtoTot  = T-MATG.CtoTot.
    ASSIGN
        Almmmatp.FchAct  = TODAY
        Almmmatp.usuario = s-user-id.
    /* Calculamos el margen */
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = Almmmatp.Chr__01
        NO-LOCK NO-ERROR.
    f-Factor = 1.
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
    END.  
    ASSIGN
        Almmmatp.Dec__01 = ( (Almmmatp.PreOfi / (Almmmatp.Ctotot * f-Factor) ) - 1 ) * 100.
    RELEASE Almmmatp.
END.
EMPTY TEMP-TABLE T-MATG.

RUN dispatch IN h_t-import-precio-mayorista-4 ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Precios-Remate W-Win 
PROCEDURE Grabar-Precios-Remate :
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

EMPTY TEMP-TABLE E-MATG.
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
    FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
        AND VtaTabla.Tabla = "REMATES"
        AND VtaTabla.Llave_c1 = T-MATG.codmat NO-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE VtaTabla THEN DO:
        CREATE VtaTabla.
        ASSIGN
            VtaTabla.CodCia = Almmmatg.codcia
            VtaTabla.Tabla = "REMATES"
            VtaTabla.Llave_c1 = T-MATG.codmat.
    END.
    ELSE DO:
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
            AND VtaTabla.Tabla = "REMATES"
            AND VtaTabla.Llave_c1 = T-MATG.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pError"}
            CREATE E-MATG.
            BUFFER-COPY T-MATG TO E-MATG ASSIGN E-MATG.Libre_c01 = pError.
            DELETE T-MATG.
            NEXT.
        END.
    END.
    ASSIGN
        VtaTabla.Libre_c01 = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        VtaTabla.Libre_c02 = s-user-id
        VtaTabla.Valor[1]  = T-MATG.PreOfi.
    RELEASE VtaTabla.
END.
EMPTY TEMP-TABLE T-MATG.

RUN dispatch IN h_t-import-precio-mayorista-5 ('open-query':U).

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

DEF VAR pError AS CHAR NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR x-PreUni AS DEC NO-UNDO.

EMPTY TEMP-TABLE E-MATG.
EMPTY TEMP-TABLE A-MATG.

DEFINE VAR hProc AS HANDLE NO-UNDO.
/* 1ro. Calculamos el margen de utilidad */
RUN pri/pri-librerias PERSISTENT SET hProc.

FOR EACH T-MATG, FIRST Almmmatg OF T-MATG NO-LOCK ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    /* Por Precio de Lista */
    IF T-MATG.PreAlt[1] <= 0 THEN DO:
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
    pError = "".
    RUN PRI_Margen-Utilidad IN hProc (INPUT "",
                                      INPUT T-MATG.CodMat,
                                      INPUT T-MATG.UndAlt[1],
                                      INPUT T-MATG.PreAlt[1],
                                      INPUT 1,
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
    /* ****************************************************************************************************** */
    FIND FIRST VtaListaMinGn OF T-MATG NO-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE VtaListaMinGn THEN DO:
        CREATE VtaListaMinGn.
        ASSIGN
            VtaListaMinGn.CodCia = Almmmatg.codcia
            VtaListaMinGn.codmat = Almmmatg.codmat
            VtaListaMinGn.FchIng = TODAY.
    END.
    ELSE DO:
        FIND FIRST VtaListaMinGn OF T-MATG EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pError"}
            CREATE E-MATG.
            BUFFER-COPY T-MATG TO E-MATG ASSIGN E-MATG.Libre_c01 = pError.
            DELETE T-MATG.
            NEXT.
        END.
    END.
    ASSIGN
        VtaListaMinGn.MonVta  = T-MATG.MonVta
        VtaListaMinGn.TpoCmb  = T-MATG.TpoCmb
        VtaListaMinGn.Chr__01 = T-MATG.UndAlt[1]
        VtaListaMinGn.PreOfi  = T-MATG.PreAlt[1].
    ASSIGN
        VtaListaMinGn.FchAct  = TODAY
        VtaListaMinGn.usuario = s-user-id.
    /* Calculamos el margen */
    x-CtoTot = Almmmatg.CtoTot.
    F-FACTOR = 1.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = VtaListaMinGn.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
    END.  
    ASSIGN
        VtaListaMinGn.Dec__01 = ( (VtaListaMinGn.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100.
    RELEASE VtaListaMinGn.
END.
EMPTY TEMP-TABLE T-MATG.
DELETE PROCEDURE hProc.

RUN dispatch IN h_t-import-precio-mayorista-2 ('open-query':U).

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


/* DEF VAR x-Margen AS DEC NO-UNDO.    /* Margen de utilidad */                                           */
/*                                                                                                        */
/* pError = ''.                                                                                           */
/*     RUN vtagn/p-margen-utilidad-v2 (pCodDiv,                                                           */
/*                                     pCodMat,                                                           */
/*                                     pPreUni,                                                           */
/*                                     pUndVta,                                                           */
/*                                     1,                      /* Moneda */                               */
/*                                     pTpoCmb,                                                           */
/*                                     NO,                     /* Muestra error? */                       */
/*                                     "",                     /* Almacén */                              */
/*                                     OUTPUT x-Margen,        /* Margen de utilidad */                   */
/*                                     OUTPUT x-Limite,        /* Margen mínimo de utilidad */            */
/*                                     OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */ */
/*                                     ).                                                                 */
/* IF RETURN-VALUE = 'ADM-ERROR' THEN pError = 'ADM-ERROR'.                                               */

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

