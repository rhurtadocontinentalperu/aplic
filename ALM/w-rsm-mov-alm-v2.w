&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
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

DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-archivo AS CHAR.

DEFINE TEMP-TABLE tt-resumen NO-UNDO
    FIELDS  tcodalm     AS CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Almacen"
    FIELDS  tcodzona    AS CHAR    FORMAT 'x(25)'   COLUMN-LABEL "Zona Geografica"
    FIELDS  tyear       AS INT     FORMAT '>>>9'   COLUMN-LABEL "Año"
    FIELDS  tmes        AS INT     FORMAT '>9'     COLUMN-LABEL "Mes"
    FIELDS  tlinea      AS CHAR    FORMAT 'x(80)'  COLUMN-LABEL "Linea"
    FIELDS  tsublinea   AS CHAR    FORMAT 'x(80)'  COLUMN-LABEL "SubLinea"
    FIELDS  tproveedor  AS CHAR    FORMAT 'x(80)'  COLUMN-LABEL "Proveedor"
    FIELDS  tcodmat     AS CHAR    FORMAT 'x(60)'  COLUMN-LABEL "Codigo"
    FIELDS  tdesmat     AS CHAR    FORMAT 'x(80)'  COLUMN-LABEL "Descripcion"
    FIELDS  tmarca      AS CHAR    FORMAT 'x(60)'  COLUMN-LABEL "Marca"
    FIELDS  tund        AS CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Unidad"
    FIELDS  tclsfG      AS CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Clasf G"
    FIELDS  tclsfM      AS CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Clasf M"
    FIELDS  tclsfU      AS CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Clasf U"
    FIELD   tproter     AS CHAR    FORMAT 'x(3)'   COLUMN-LABEL "Propios/Terceros"
    FIELDS  tCostoRep   AS DEC     FORMAT '->,>>>,>>9.999' COLUMN-LABEL "Costo Repos"   INIT 0
    FIELDS  tStkMax     AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Maximo"  INIT 0
    FIELDS  tStkSeg     AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Seguridad"  INIT 0
    FIELD   temprep     AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Empaque Reposicion" INIT 0
    FIELDS  tstkini     AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Inicial" INIT 0
    FIELDS  tstkfin     AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Final"   INIT 0
    FIELDS  tingtrans   AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Ing x Trans"   INIT 0
    FIELDS  tingcomp    AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Ing x Compras" INIT 0
    FIELDS  tingdevcli  AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Ing x Dev Clie"    INIT 0
    FIELDS  tingrecla   AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Ing x Reclasif"    INIT 0
    FIELDS  tingotros   AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Otros Ingresos"    INIT 0
    FIELDS  tsaltrans   AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Salida x Trans"    INIT 0
    FIELDS  tsalusoadm  AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Salida x Uso Adm"  INIT 0
    FIELDS  tsalrecla   AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Salida x Reclasif" INIT 0
    FIELDS  tsalvta     AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Salida x Venta"    INIT 0
    FIELDS  tsalotros   AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Otras Salidas" INIT 0
    FIELDS  tguiasrepo  AS INT     FORMAT '>>,>>9'         COLUMN-LABEL "No Guias x Repos"  INIT 0
    FIELDS  tvtasant    AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Ventas Año pasado" INIT 0
    FIELDS  tvtamesant  AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Ventas Mes pasado" INIT 0
    FIELDS  tstkinimesant  AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Inicial mes pasado" INIT 0
    FIELDS  tstkfinmesant  AS DEC     FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Final mes pasado" INIT 0
    FIELDS  tvtasmesantpas   AS DEC      FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Ventas mes ante pasado" INIT 0
    FIELDS  tstkinimesantpas   AS DEC      FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Inicial mes ante pasado" INIT 0
    FIELDS  tstkfinmesantpas   AS DEC      FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Final mes ante pasado" INIT 0
    FIELDS  tvtasmsigapas      AS DEC      FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Venta mes siguiente año pasado" INIT 0
    INDEX idx01 tcodalm tyear tmes tcodmat.
    /*INDEX idx01 IS PRIMARY tcodalm tyear tmes tcodmat.*/

DEFINE TEMP-TABLE   tt-control NO-UNDO
    FIELDS  ttcodalm    LIKE    almdmov.codalm
    FIELDS  tttipmov    LIKE    almdmov.tipmov
    FIELDS  ttcodmov    LIKE    almdmov.codmov
    FIELDS  ttnroser    LIKE    almdmov.nroser
    FIELDS  ttnrodoc    LIKE    almdmov.nrodoc
    INDEX idx02 IS PRIMARY ttcodalm tttipmov ttcodmov ttnroser ttnrodoc.

DEFINE TEMP-TABLE tt-totalizado NO-UNDO LIKE tt-resumen .

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
&Scoped-Define ENABLED-OBJECTS rbCuales txtYearDesde txtMesDesde ~
txtYearHasta txtMesHasta EDITOR-CodAlm BUTTON-1 BUTTON-3 RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS rbCuales txtYearDesde txtMesDesde ~
txtYearHasta txtMesHasta EDITOR-CodAlm 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .96.

DEFINE VARIABLE EDITOR-CodAlm AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 54 BY 3.96
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE txtMesDesde AS INTEGER FORMAT ">9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE txtMesHasta AS INTEGER FORMAT ">9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE txtYearDesde AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE txtYearHasta AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE rbCuales AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Solo articulos activos", 2
     SIZE 32 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY .19.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 4.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rbCuales AT ROW 3.27 COL 8.86 NO-LABEL WIDGET-ID 80
     txtYearDesde AT ROW 2 COL 6.86 COLON-ALIGNED WIDGET-ID 2
     txtMesDesde AT ROW 2.04 COL 14.86 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     txtYearHasta AT ROW 2.04 COL 29.86 COLON-ALIGNED WIDGET-ID 4
     txtMesHasta AT ROW 2 COL 37.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     EDITOR-CodAlm AT ROW 5.42 COL 4 NO-LABEL WIDGET-ID 76
     BUTTON-1 AT ROW 1.58 COL 47 WIDGET-ID 12
     BUTTON-3 AT ROW 5.81 COL 59.29 WIDGET-ID 78
     "Año        / Mes" VIEW-AS TEXT
          SIZE 12.57 BY .62 AT ROW 1.31 COL 32.57 WIDGET-ID 14
     "Año        / Mes" VIEW-AS TEXT
          SIZE 12.57 BY .62 AT ROW 1.31 COL 9.29 WIDGET-ID 10
     "  SELECCIONE UNO O MAS ALMACENES" VIEW-AS TEXT
          SIZE 37 BY .77 AT ROW 4.54 COL 5 WIDGET-ID 44
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 4.23 COL 1 WIDGET-ID 16
     RECT-2 AT ROW 4.96 COL 3 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.14 BY 9.15 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Resumen movimientos mensual de articulos"
         HEIGHT             = 9.15
         WIDTH              = 71.14
         MAX-HEIGHT         = 21.42
         MAX-WIDTH          = 133.14
         VIRTUAL-HEIGHT     = 21.42
         VIRTUAL-WIDTH      = 133.14
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
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen movimientos mensual de articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen movimientos mensual de articulos */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:
    ASSIGN txtYearDesde txtYearHasta txtMesDesde txtMesHasta EDITOR-codalm
        rbCuales.

    DEFINE VAR lInicio AS DATETIME.
    DEFINE VAR lFinal AS DATETIME.

    IF txtYearDesde > 2010 AND txtYearDesde > txtYEarHasta  THEN DO:
        MESSAGE "Rango de Año esta errado (debe ser mayor al 2010)".
        RETURN NO-APPLY.
    END.
    IF txtMesDesde < 1 OR txtMesDesde > 12  THEN DO:
        MESSAGE "Mes Desde esta ERRADO".
        RETURN NO-APPLY.
    END.
    IF txtMesHasta < 1 OR txtMesHasta > 12  THEN DO:
        MESSAGE "Mes Hasta esta ERRADO".
        RETURN NO-APPLY.
    END.
    IF txtYearDesde = txtYearHasta THEN DO:
        IF txtMesDesde > txtMesHasta THEN DO:
            MESSAGE "Rango de Mes esta Errado".
            RETURN NO-APPLY.
        END.
    END.

    IF EDITOR-CodAlm = "" THEN DO:
        MESSAGE "Ingrese al menos un almacén" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

        
    DEFINE VAR rpta AS LOG.

        SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'Excel (*.xlsx)' '*.xlsx'
            ASK-OVERWRITE
            CREATE-TEST-FILE
            DEFAULT-EXTENSION '.xlsx'
            RETURN-TO-START-DIR
            SAVE-AS
            TITLE 'Exportar a Excel'
            UPDATE rpta.
        IF rpta = NO OR x-Archivo = '' THEN RETURN.

    /*  ---   */
    lInicio = NOW.
    RUN procesar.
    RUN ventas-anteriores.
    RUN articulos-constk-sinmov.
    RUN articulos-constkmax-sinmov.
    RUN ventas-mes-pasado.
    /**/
    RUN ventas-mes-antepasado.
    RUN ventas-mes-sgte-anno-pasado.

    /* Mas de un almacen generar archivo totalizados */
    IF NUM-ENTRIES(EDITOR-codalm,",") > 1 THEN RUN totalizar-x-zona.

    RUN envio-excel.
    lFinal = NOW.

    MESSAGE "Proceso concluido".

    /*MESSAGE lInicio lFinal.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = EDITOR-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    EDITOR-CodAlm:SCREEN-VALUE = x-almacenes.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE articulos-constk-sinmov W-Win 
PROCEDURE articulos-constk-sinmov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR xFechaDesde AS DATE.
DEFINE VAR xFechaHasta AS DATE.
DEFINE VAR xFecha AS DATE.
DEFINE VAR xFechaStk AS DATE.

DEFINE VAR xAAAA AS INT.
DEFINE VAR xMM AS INT.
DEFINE VAR lCant AS DEC.

DEFINE VAR xMesIni AS INT.
DEFINE VAR xMesFin AS INT.

DEFINE VAR lSec AS INT.
DEFINE VAR lCodAlm AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').

/* Solo Activos */
FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia AND
                        almmmatg.TpoArt <> 'D' NO-LOCK:

    /*IF rbCuales = 2 AND  THEN*/

    REPEAT lSec = 1 TO NUM-ENTRIES(EDITOR-codalm,","):
        lCodAlm = ENTRY(lSec,EDITOR-codalm,",").
        /* ------------------------------------------------------------------- */
        REPEAT xAAAA = txtYearDesde TO txtYearHasta:
            IF txtYearDesde = txtYearHasta THEN DO:
                xMesIni = txtMesDesde.
                xMesFin = txtMesHasta.
            END.
            ELSE DO:
                xMesIni = 1.
                xMesFin = 12.
                IF xAAAA = txtYearDesde THEN DO:
                    xMesIni = txtMesDesde.
                    xMesFin = 12.
                END.
                IF xAAAA = txtYearHasta THEN DO:
                    xMesIni = 1.
                    xMesFin = txtMesHasta.
                END.
            END.
            
            REPEAT xMM = xMesIni TO xMesFin:
                
                FIND FIRST tt-resumen WHERE tt-resumen.tcodalm = lCodAlm AND 
                                            tt-resumen.tyear = xAAAA AND 
                                            tt-resumen.tmes = xMM AND 
                                            tt-resumen.tcodmat = almmmatg.codmat NO-ERROR.
                IF NOT AVAILABLE tt-resumen THEN DO:
                    /* Stocks inicial */
                    xFechaStk = DATE(xMM,1,xAAAA).
                    FIND LAST AlmStkAl WHERE AlmStkAl.codcia = s-codcia AND
                                                AlmStkAl.codalm = lCodAlm AND 
                                                AlmstkAl.codmat = almmmatg.codmat AND
                                                AlmstkAl.fecha < xFechaStk NO-LOCK NO-ERROR.

                    IF AVAILABLE AlmStkAl AND AlmstkAl.stkact <> 0 THEN DO:                                            
                        /**/
                        FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
                        FIND FIRST almsfam OF almmmatg NO-LOCK NO-ERROR.
    
                        CREATE tt-resumen.
                        ASSIGN  tcodalm     = lCodAlm
                                tyear       = xAAAA
                                tMes        = xMM
                                tCodMat     = almmmatg.codmat
                                tLinea      = if(AVAILABLE almtfam) THEN (TRIM(almtfam.codfam) + " " + TRIM(almtfam.desfam)) ELSE (almmmatg.codfam + " ** ERROR **")
                                tsublinea   = if(AVAILABLE almsfam) THEN (TRIM(almsfam.subfam) + " " + TRIM(almsfam.dessub)) ELSE (almmmatg.subfam + " ** ERROR **")
                                tdesmat     = TRIM(almmmatg.desmat)
                                tmarca      = TRIM(almmmatg.desmar)
                                tund        = TRIM(almmmatg.undbas)
                                tcostorep   = almmmatg.ctolis * (IF (almmmatg.monvta = 2) THEN almmmatg.tpocmb ELSE 1)
                                tproter     = IF (almmmatg.CHR__02 = 'P') THEN almmmatg.CHR__02 ELSE "T"
                                /*tcostorep   = almmmatg.ctolis*/
                                tstkini     = AlmstkAl.stkact
                                tstkfin     = AlmstkAl.stkact.
        
                        FIND FIRST gn-prov WHERE  gn-prov.codcia = 0 AND 
                                                    gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.
                        IF AVAILABLE gn-prov THEN DO:
                            ASSIGN tproveedor = TRIM(gn-prov.nompro).
                        END.
                        /* Maximo */
                        FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND 
                                                    almmmate.codalm = lCodAlm AND 
                                                    almmmate.codmat = almmmatg.codmat NO-LOCK NO-ERROR.
                        IF AVAILABLE almmmate THEN DO:
                            FIND FIRST almcfggn NO-ERROR.
                            IF AVAILABLE almcfggn THEN DO:
                                IF almcfggn.temporada = 'C' THEN DO:
                                    ASSIGN tt-resumen.tStkMax = almmmate.vctmn1.
                                END.
                                ELSE ASSIGN tt-resumen.tStkMax = almmmate.vctmn2.
                            END.
                            ELSE ASSIGN tt-resumen.tStkMax = almmmate.vctmn2.    
                            /* Seguridad */
                            ASSIGN tt-resumen.tStkSeg = almmmate.StockSeg
                            tt-resumen.temprep  = almmmate.stkmax.
                        END.
                        /* Ranking */
                        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                                                    factabla.tabla = 'RANKVTA' AND 
                                                    factabla.codigo = almmmatg.codmat NO-LOCK NO-ERROR.
                        IF AVAILABLE factabla THEN DO:
                            ASSIGN tt-resumen.tclsfG = factabla.campo-c[1]
                                    tt-resumen.tclsfM = factabla.campo-c[3]
                                    tt-resumen.tclsfU = factabla.campo-c[2].
                        END.

                    END.
                END.                
            END.
        END.
    END.
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE articulos-constkmax-sinmov W-Win 
PROCEDURE articulos-constkmax-sinmov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR xFechaDesde AS DATE.
DEFINE VAR xFechaHasta AS DATE.
DEFINE VAR xFecha AS DATE.
DEFINE VAR xFechaStk AS DATE.

DEFINE VAR xAAAA AS INT.
DEFINE VAR xMM AS INT.
DEFINE VAR lCant AS DEC.

DEFINE VAR xMesIni AS INT.
DEFINE VAR xMesFin AS INT.

DEFINE VAR lSec AS INT.
DEFINE VAR lCodAlm AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').

/* Solo ACTIVOS */
FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia AND 
                        almmmatg.TpoArt <> 'D'NO-LOCK:

    REPEAT lSec = 1 TO NUM-ENTRIES(EDITOR-codalm,","):
        lCodAlm = ENTRY(lSec,EDITOR-codalm,",").
        /* ------------------------------------------------------------------- */
        REPEAT xAAAA = txtYearDesde TO txtYearHasta:
            IF txtYearDesde = txtYearHasta THEN DO:
                xMesIni = txtMesDesde.
                xMesFin = txtMesHasta.
            END.
            ELSE DO:
                xMesIni = 1.
                xMesFin = 12.
                IF xAAAA = txtYearDesde THEN DO:
                    xMesIni = txtMesDesde.
                    xMesFin = 12.
                END.
                IF xAAAA = txtYearHasta THEN DO:
                    xMesIni = 1.
                    xMesFin = txtMesHasta.
                END.
            END.
            
            REPEAT xMM = xMesIni TO xMesFin:
                FIND FIRST tt-resumen WHERE tt-resumen.tcodalm = lCodAlm AND 
                                            tt-resumen.tyear = xAAAA AND 
                                            tt-resumen.tmes = xMM AND 
                                            tt-resumen.tcodmat = almmmatg.codmat NO-ERROR.
                IF NOT AVAILABLE tt-resumen THEN DO:
                    FIND LAST Almmmate WHERE Almmmate.codcia = s-codcia AND
                                                Almmmate.codalm = lCodAlm AND 
                                                Almmmate.codmat = almmmatg.codmat
                                                NO-LOCK NO-ERROR.

                    IF AVAILABLE Almmmate AND Almmmate.StockMax > 0 THEN DO:                                            
                        /**/
                        FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
                        FIND FIRST almsfam OF almmmatg NO-LOCK NO-ERROR.
    
                        CREATE tt-resumen.
                        ASSIGN  tcodalm     = lCodAlm
                                tyear       = xAAAA
                                tMes        = xMM
                                tCodMat     = almmmatg.codmat
                                tLinea      = if(AVAILABLE almtfam) THEN (TRIM(almtfam.codfam) + " " + TRIM(almtfam.desfam)) ELSE (almmmatg.codfam + " ** ERROR **")
                                tsublinea   = if(AVAILABLE almsfam) THEN (TRIM(almsfam.subfam) + " " + TRIM(almsfam.dessub)) ELSE (almmmatg.subfam + " ** ERROR **")
                                tdesmat     = TRIM(almmmatg.desmat)
                                tmarca      = TRIM(almmmatg.desmar)
                                tund        = TRIM(almmmatg.undstk)
                                /*tcostorep   = almmmatg.ctolis*/
                                tcostorep   = almmmatg.ctolis * (IF (almmmatg.monvta = 2) THEN almmmatg.tpocmb ELSE 1)
                                tproter     = IF (almmmatg.CHR__02 = 'P') THEN almmmatg.CHR__02 ELSE "T"
                                tstkini     = 0
                                tstkfin     = 0.
        
                        FIND FIRST gn-prov WHERE  gn-prov.codcia = 0 AND 
                                                    gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.
                        IF AVAILABLE gn-prov THEN DO:
                            ASSIGN tproveedor = TRIM(gn-prov.nompro).
                        END.
                        /* Maximo */
                        FIND FIRST almcfggn NO-ERROR.
                        IF AVAILABLE almcfggn THEN DO:
                            IF almcfggn.temporada = 'C' THEN DO:
                                ASSIGN tt-resumen.tStkMax = almmmate.vctmn1.
                            END.
                            ELSE ASSIGN tt-resumen.tStkMax = almmmate.vctmn2.
                        END.
                        ELSE ASSIGN tt-resumen.tStkMax = almmmate.vctmn2.   
                        /* Seguridad */
                        ASSIGN tt-resumen.tStkSeg = almmmate.StockSeg
                            tt-resumen.temprep  = almmmate.stkmax.

                        /* Ranking */
                        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                                                    factabla.tabla = 'RANKVTA' AND 
                                                    factabla.codigo = almmmatg.codmat NO-LOCK NO-ERROR.
                        IF AVAILABLE factabla THEN DO:
                            ASSIGN tt-resumen.tclsfG = factabla.campo-c[1]
                                    tt-resumen.tclsfM = factabla.campo-c[3]
                                    tt-resumen.tclsfU = factabla.campo-c[2].
                        END.

                    END.
                END.                
            END.
        END.
    END.
END.
SESSION:SET-WAIT-STATE('').

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
  DISPLAY rbCuales txtYearDesde txtMesDesde txtYearHasta txtMesHasta 
          EDITOR-CodAlm 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rbCuales txtYearDesde txtMesDesde txtYearHasta txtMesHasta 
         EDITOR-CodAlm BUTTON-1 BUTTON-3 RECT-1 RECT-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envio-excel W-Win 
PROCEDURE envio-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lFiler AS CHAR.
DEFINE VAR lPos AS INT.


DEFINE VAR hProc AS HANDLE NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-Archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-resumen:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-resumen:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/* mas de un almacen */
IF NUM-ENTRIES(EDITOR-codalm,",") > 0 THEN DO:
    lPos = INDEX(x-archivo,".").
    lFiler = SUBSTRING(x-archivo, 1, lPos - 1) + "-totalizado" + 
                SUBSTRING(x-archivo,lPos).
    /**/
    c-xls-file = lFiler.

    run pi-crea-archivo-csv IN hProc (input  buffer tt-totalizado:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer tt-totalizado:handle,
                            input  c-csv-file,
                            output c-xls-file) .

END.

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').


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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txtYearDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(YEAR(TODAY),'>>>9').
  txtYearHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(YEAR(TODAY),'>>>9').
  txtMesDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(MONTH(TODAY),'>9').
  txtMesHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(MONTH(TODAY),'>9').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR xFechaDesde AS DATE.
DEFINE VAR xFechaHasta AS DATE.
DEFINE VAR xFecha AS DATE.
DEFINE VAR xFechaStk AS DATE.

DEFINE VAR xAAAA AS INT.
DEFINE VAR xMM AS INT.
DEFINE VAR lCant AS DEC.

DEFINE VAR lSec AS INT.
DEFINE VAR lCodAlm AS CHAR.
DEFINE VAR lCodAlmX AS CHAR.

/* Desde */
xFechaDesde = DATE(txtMesDesde,1,txtYearDesde).

/* Hasta */
xAAAA = IF(TxtMesHasta = 12) THEN (txtYearHasta + 1) ELSE txtYearHasta.
xMM = IF(TxtMesHasta = 12) THEN 1 ELSE (txtMesHasta + 1).

xFechaHasta = DATE(xMM,1,xAAAA).
xFechaHasta = XFechaHasta - 1.

EMPTY TEMP-TABLE tt-resumen.

SESSION:SET-WAIT-STATE('GENERAL').
/*
FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia NO-LOCK,
    FIRST almtfam OF almmmatg NO-LOCK, 
    FIRST almsfam OF almmmatg NO-LOCK:

    EMPTY TEMP-TABLE tt-control.
*/
    REPEAT lSec = 1 TO NUM-ENTRIES(EDITOR-codalm,","):
        lCodAlm = ENTRY(lSec,EDITOR-codalm,",").
        /* ------------------------------------------------------------------- */
        RangoFechas:
        REPEAT xFecha = xFechaDesde TO xFechaHasta:
            FOR EACH almdmov USE-INDEX almd04
                    WHERE almdmov.codcia = s-codcia AND 
                            almdmov.codalm = lCodAlm AND 
                            almdmov.fchdoc = xFecha NO-LOCK:

                FIND FIRST almcmov OF almdmov NO-LOCK NO-ERROR.
                FIND FIRST almmmatg OF almdmov NO-LOCK NO-ERROR.
                FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
                FIND FIRST almsfam OF almmmatg NO-LOCK NO-ERROR.

                /* Solo Articulos Activos */
                IF rbCuales = 2 AND almmmatg.tpoart <> 'A' THEN NEXT.
    
                xAAAA = YEAR(xFecha).
                xMM = MONTH(xFecha).

                lCodAlmX = lCodAlm.

                FIND FIRST tt-resumen WHERE tt-resumen.tcodalm = lCodAlmX AND
                                            tt-resumen.tyear = xAAAA AND
                                            tt-resumen.tmes = xMM AND 
                                            tt-resumen.tcodmat = almdmov.codmat NO-ERROR.
                IF NOT AVAILABLE tt-resumen THEN DO:
                    CREATE tt-resumen.
                    ASSIGN  tcodalm     = lCodAlmX
                            tyear       = xAAAA
                            tMes        = xMM
                            tCodMat     = almdmov.codmat
                            tLinea      = if(AVAILABLE almtfam) THEN (TRIM(almtfam.codfam) + " " + TRIM(almtfam.desfam)) ELSE (almmmatg.codfam + " ** ERROR **")
                            tsublinea   = if(AVAILABLE almsfam) THEN (TRIM(almsfam.subfam) + " " + TRIM(almsfam.dessub)) ELSE (almmmatg.subfam + " ** ERROR **")
                            tdesmat     = TRIM(almmmatg.desmat)
                            tmarca      = TRIM(almmmatg.desmar)
                            tund        = TRIM(almmmatg.undbas)
                            tcostorep   = almmmatg.ctolis * (IF (almmmatg.monvta = 2) THEN almmmatg.tpocmb ELSE 1)
                            tproter     = IF (almmmatg.CHR__02 = 'P') THEN almmmatg.CHR__02 ELSE "T"
                            temprep     = 0.
    
                    FIND FIRST gn-prov WHERE  gn-prov.codcia = 0 AND 
                                                gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN DO:
                        ASSIGN tproveedor = TRIM(gn-prov.nompro).
                    END.
                    /* Ranking */
                    FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                                                factabla.tabla = 'RANKVTA' AND 
                                                factabla.codigo = almdmov.codmat NO-LOCK NO-ERROR.
                    IF AVAILABLE factabla THEN DO:
                        ASSIGN tt-resumen.tclsfG = factabla.campo-c[1]
                                tt-resumen.tclsfM = factabla.campo-c[3]
                                tt-resumen.tclsfU = factabla.campo-c[2].
                    END.
                
                    /* Maximo */
                    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND 
                                                almmmate.codalm = almdmov.codalm AND 
                                                almmmate.codmat = almdmov.codmat NO-LOCK NO-ERROR.
                    IF AVAILABLE almmmate THEN DO:
                        FIND FIRST almcfggn NO-ERROR.
                        IF AVAILABLE almcfggn THEN DO:
                            IF almcfggn.temporada = 'C' THEN DO:
                                ASSIGN tt-resumen.tStkMax = tt-resumen.tStkMax + almmmate.vctmn1.
                            END.
                            ELSE ASSIGN tt-resumen.tStkMax = tt-resumen.tStkMax + almmmate.vctmn2.
                        END.
                        ELSE ASSIGN tt-resumen.tStkMax = tt-resumen.tStkMax + almmmate.vctmn2.     
    
                        /* Seguridad */
                        ASSIGN tt-resumen.tStkSeg = tt-resumen.tStkSeg + almmmate.StockSeg
                        tt-resumen.temprep  = almmmate.stkmax.
                    END.
                    /* Stocks inicial */
                    xFechaStk = DATE(xMM,1,xAAAA).
                    FIND LAST AlmStkAl WHERE AlmStkAl.codcia = s-codcia AND
                                                AlmStkAl.codalm = almdmov.codalm AND 
                                                AlmstkAl.codmat = almdmov.codmat AND
                                                AlmstkAl.fecha < xFechaStk NO-LOCK NO-ERROR.
                    IF AVAILABLE AlmStkAl THEN DO:
                        ASSIGN tt-resumen.tstkini   = tt-resumen.tstkini + AlmstkAl.stkact.
                    END.
                    /* Stocks final */
                    xAAAA = IF(xMM = 12) THEN (xAAAA + 1) ELSE xAAAA.
                    xMM = IF(xMM = 12) THEN 1 ELSE (xMM + 1).
                    xFechaStk = DATE(xMM,1,xAAAA) - 1.
    
                    FIND LAST AlmStkAl WHERE AlmStkAl.codcia = s-codcia AND
                                                AlmStkAl.codalm = almdmov.codalm AND 
                                                AlmstkAl.codmat = almdmov.codmat AND
                                                AlmstkAl.fecha <= xFechaStk NO-LOCK NO-ERROR.
                    IF AVAILABLE AlmStkAl THEN DO:
                        ASSIGN tt-resumen.tstkfin   = tt-resumen.tstkfin + AlmstkAl.stkact.
                    END.
                END.                
    
                /* INGRESOS */
                lCant = 0.
                IF almdmov.tipmov = 'I' and almdmov.codmov = 3 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.                    
                    /* Transferencias Recepcionadas */
                    IF almcmov.flgsit <> 'T' THEN DO:
                        ASSIGN tt-resumen.tguiasrepo = tt-resumen.tguiasrepo + 1
                                tt-resumen.tingtrans = tt-resumen.tingtrans + lCant.
                    END.
                END.
                IF almdmov.tipmov = 'I' and almdmov.codmov = 90 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tingcomp = tt-resumen.tingcomp + lCant.
                END.
                IF almdmov.tipmov = 'I' and almdmov.codmov = 9 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tingdevcli = tt-resumen.tingdevcli + lCant.
                END.
                IF almdmov.tipmov = 'I' and almdmov.codmov = 13 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tingrecla = tt-resumen.tingrecla + lCant.
                END.
                IF almdmov.tipmov = 'I' and almdmov.codmov = 14 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tingrecla = tt-resumen.tingrecla + lCant.
                END.
                IF almdmov.tipmov = 'I' AND lCant = 0 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tingotros = tt-resumen.tingotros + lCant.
                END.
                /* SALIDAS */
                lCant = 0.
                IF almdmov.tipmov = 'S' and almdmov.codmov = 3 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tsaltrans = tt-resumen.tsaltrans + lCant.
                END.
                IF almdmov.tipmov = 'S' and almdmov.codmov = 4 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tsalusoadm = tt-resumen.tsalusoadm + lCant.
                END.
                IF almdmov.tipmov = 'S' and almdmov.codmov = 13 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tsalrecla = tt-resumen.tsalrecla + lCant.
                END.
                IF almdmov.tipmov = 'S' and almdmov.codmov = 14 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tsalrecla = tt-resumen.tsalrecla + lCant.
                END.
                IF almdmov.tipmov = 'S' and almdmov.codmov = 2 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tsalvta = tt-resumen.tsalvta + lCant.
                END.
                IF almdmov.tipmov = 'S' AND lCant = 0 THEN DO:
                    lCant = almdmov.candes * almdmov.factor.
                    ASSIGN tt-resumen.tsalotros = tt-resumen.tsalotros + lCant.
                END.
    
            END.
        END.
    END.
/*
END.
*/

SESSION:SET-WAIT-STATE('').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE totalizar-x-zona W-Win 
PROCEDURE totalizar-x-zona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-totalizado.                     

DEFINE VAR lCodZona AS CHAR.
                     
SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH tt-resumen :
    lCodZona = 'SIN ZONA'.
    FIND FIRST tabgener WHERE tabgener.codcia = s-codcia AND 
                                tabgener.clave = 'ZG' AND 
                                tabgener.libre_c01 = tt-resumen.tcodalm
                                NO-LOCK NO-ERROR.
    IF AVAILABLE tabgener THEN lCodZona = tabgener.codigo.

    FIND FIRST tt-totalizado WHERE tt-totalizado.tcodzona = lCodZona AND 
        tt-totalizado.tcodmat = tt-resumen.tcodmat AND
        tt-totalizado.tyear = tt-resumen.tyear AND 
        tt-totalizado.tmes = tt-resumen.tmes NO-ERROR.
    IF NOT AVAILABLE tt-totalizado THEN DO:
        CREATE tt-totalizado.
        ASSIGN  
            tt-totalizado.tcodzona      = lCodZona
            tt-totalizado.tcodmat       = tt-resumen.tcodmat
            tt-totalizado.tyear         = tt-resumen.tyear
            tt-totalizado.tmes          = tt-resumen.tmes
            tt-totalizado.tlinea        = tt-resumen.tlinea
            tt-totalizado.tsublinea     = tt-resumen.tsublinea
            tt-totalizado.tproveedor    = tt-resumen.tproveedor
            tt-totalizado.tdesmat       = tt-resumen.tdesmat
            tt-totalizado.tmarca        = tt-resumen.tmarca
            tt-totalizado.tund          = tt-resumen.tund
            tt-totalizado.tclsfG        = tt-resumen.tclsfG
            tt-totalizado.tclsfM        = tt-resumen.tclsfM
            tt-totalizado.tclsfU        = tt-resumen.tclsfU
            tt-totalizado.tCostoRep     = tt-resumen.tCostoRep
            tt-totalizado.tproter       = tt-resumen.tproter.
    END.
    ASSIGN 
        /*tt-totalizado.tCostoRep = tt-totalizado.tCostoRep + tt-resumen.tCostoRep*/
        tt-totalizado.tStkMax = tt-totalizado.tStkMax + tt-resumen.tStkMax
        tt-totalizado.tStkSeg = tt-totalizado.tStkSeg + tt-resumen.tStkSeg
        tt-totalizado.tstkini = tt-totalizado.tstkini + tt-resumen.tstkini
        tt-totalizado.tstkfin = tt-totalizado.tstkfin + tt-resumen.tstkfin
        tt-totalizado.tingtrans = tt-totalizado.tingtrans + tt-resumen.tingtrans
        tt-totalizado.tingcomp = tt-totalizado.tingcomp + tt-resumen.tingcomp
        tt-totalizado.tingdevcli = tt-totalizado.tingdevcli + tt-resumen.tingdevcli
        tt-totalizado.tingrecla = tt-totalizado.tingrecla + tt-resumen.tingrecla
        tt-totalizado.tingotros = tt-totalizado.tingotros + tt-resumen.tingotros
        tt-totalizado.tsaltrans = tt-totalizado.tsaltrans + tt-resumen.tsaltrans
        tt-totalizado.tsalusoadm = tt-totalizado.tsalusoadm + tt-resumen.tsalusoadm
        tt-totalizado.tsalrecla = tt-totalizado.tsalrecla + tt-resumen.tsalrecla
        tt-totalizado.tsalvta = tt-totalizado.tsalvta + tt-resumen.tsalvta
        tt-totalizado.tsalotros = tt-totalizado.tsalotros + tt-resumen.tsalotros
        tt-totalizado.tguiasrepo = tt-totalizado.tguiasrepo + tt-resumen.tguiasrepo
        tt-totalizado.tvtasant = tt-totalizado.tvtasant + tt-resumen.tvtasant
        tt-totalizado.tvtamesant = tt-totalizado.tvtamesant + tt-resumen.tvtamesant
        tt-totalizado.tstkinimesant = tt-totalizado.tstkinimesant + tt-resumen.tstkinimesant
        tt-totalizado.tstkfinmesant = tt-totalizado.tstkfinmesant + tt-resumen.tstkfinmesant

        tt-totalizado.tvtasmesantpas = tt-totalizado.tvtasmesantpas + tt-resumen.tvtasmesantpas
        tt-totalizado.tstkinimesantpas = tt-totalizado.tstkinimesantpas + tt-resumen.tstkinimesantpas
        tt-totalizado.tstkfinmesantpas = tt-totalizado.tstkfinmesantpas + tt-resumen.tstkfinmesantpas
        tt-totalizado.tvtasmsigapas = tt-totalizado.tvtasmsigapas + tt-resumen.tvtasmsigapas.
    /* -- */
    ASSIGN  tt-resumen.tcodzona = lCodZona.
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ventas-anteriores W-Win 
PROCEDURE ventas-anteriores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR xFechaDesde AS DATE.
DEFINE VAR xFechaHasta AS DATE.
DEFINE VAR xFecha AS DATE.

DEFINE VAR xAAAA AS INT.
DEFINE VAR xMM AS INT.
DEFINE VAR xCant AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH tt-resumen :
    /* Inicio */
    xAAAA = tt-resumen.tyear - 1.
    xMM = tt-resumen.tmes.
    xFechaDesde = DATE(xMM,1,xAAAA).

    /* Final */
    xAAAA = IF(xMM = 12) THEN (xAAAA + 1) ELSE xAAAA.
    xMM = IF(xMM = 12) THEN 1 ELSE (xMM + 1).
    xFechaHasta = DATE(xMM,1,xAAAA) - 1.

    xCant = 0.
    REPEAT xFecha = xFechaDesde TO xFechaHasta :
        FOR EACH almdmov USE-INDEX almd03
                WHERE almdmov.codcia = s-codcia
                        AND almdmov.codalm = tt-resumen.tcodalm
                        AND almdmov.codmat = tt-resumen.tcodmat
                        AND almdmov.fchdoc = xFecha 
                        AND almdmov.tipmov = 'S'
                        AND almdmov.codmov = 2 NO-LOCK:
            /**/
            xCant = xCant + (almdmov.candes * almdmov.factor).            
        END.
    END.
    ASSIGN tt-resumen.tvtasant = tt-resumen.tvtasant + xCant.
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ventas-mes-antepasado W-Win 
PROCEDURE ventas-mes-antepasado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR xFechaDesde AS DATE.
DEFINE VAR xFechaHasta AS DATE.
DEFINE VAR xFecha AS DATE.

DEFINE VAR xAAAA AS INT.
DEFINE VAR xMM AS INT.
DEFINE VAR xCant AS DEC.
/*
    FIELDS  tvtasmesantpas   AS DEC      FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Ventas mes ante pasado"
    FIELDS  tstkinimesantpas   AS DEC      FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Inicial mes ante pasado"
    FIELDS  tstkfinmesantpas   AS DEC      FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Stock Final mes ante pasado"
*/

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH tt-resumen :
    /* Del mes antepasado */
    xAAAA = tt-resumen.tyear.
    xMM = tt-resumen.tmes.

    /* Fecha DESDE, del mes antepasado */
    xMM = xMM - 2.
    xAAAA = IF (xMM <= 0) THEN (xAAAA - 1) ELSE xAAAA.
    xMM = IF(xMM <= 0) THEN (xMM + 12) ELSE xMM.
    xFechaDesde = DATE(xMM,1,xAAAA).

    /* Fecha HASTA */
    xAAAA = IF(xMM = 12) THEN (xAAAA + 1) ELSE xAAAA.
    xMM = IF(xMM = 12) THEN 1 ELSE (xMM + 1).
    xFechaHasta = DATE(xMM,1,xAAAA) - 1.

    xCant = 0.
    REPEAT xFecha = xFechaDesde TO xFechaHasta :
        FOR EACH almdmov USE-INDEX almd03
                WHERE almdmov.codcia = s-codcia
                        AND almdmov.codalm = tt-resumen.tcodalm
                        AND almdmov.codmat = tt-resumen.tcodmat
                        AND almdmov.fchdoc = xFecha 
                        AND almdmov.tipmov = 'S'
                        AND almdmov.codmov = 2 NO-LOCK:
            /**/
            xCant = xCant + (almdmov.candes * almdmov.factor).            
        END.
    END.
    ASSIGN tt-resumen.tvtasmesantpas = tt-resumen.tvtasmesantpas + xCant.

    /* Stock Mes Ante Pasado */
    /* Inicio */    
    FIND LAST AlmStkAl WHERE AlmStkAl.codcia = s-codcia AND
                                AlmStkAl.codalm = tt-resumen.tcodalm AND 
                                AlmstkAl.codmat = tt-resumen.tcodmat AND
                                AlmstkAl.fecha < xFechaDesde NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkAl THEN DO:
        ASSIGN tt-resumen.tstkinimesantpas   = tt-resumen.tstkinimesantpas + AlmstkAl.stkact.
    END.
    /* final */
    FIND LAST AlmStkAl WHERE AlmStkAl.codcia = s-codcia AND
                                AlmStkAl.codalm = tt-resumen.tcodalm AND 
                                AlmstkAl.codmat = tt-resumen.tcodmat AND
                                AlmstkAl.fecha <= xFechaHasta NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkAl THEN DO:
        ASSIGN tt-resumen.tstkfinmesantpas   = tt-resumen.tstkfinmesantpas + AlmstkAl.stkact.
    END.

END.
SESSION:SET-WAIT-STATE('').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ventas-mes-pasado W-Win 
PROCEDURE ventas-mes-pasado :
DEFINE VAR xFechaDesde AS DATE.
DEFINE VAR xFechaHasta AS DATE.
DEFINE VAR xFecha AS DATE.

DEFINE VAR xAAAA AS INT.
DEFINE VAR xMM AS INT.
DEFINE VAR xCant AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH tt-resumen :
    /* Mes Anterior */
    xAAAA = tt-resumen.tyear.
    xMM = tt-resumen.tmes.

    /* Fecha hastaaaa */
    xFechaHasta = DATE(xMM,1,xAAAA) - 1.

    /* Fecha desde */
    xAAAA = IF(xMM = 1) THEN (xAAAA - 1) ELSE xAAAA.
    xMM = IF(xMM = 1) THEN 12 ELSE (xMM - 1).
    xFechaDesde = DATE(xMM,1,xAAAA).

    xCant = 0.
    REPEAT xFecha = xFechaDesde TO xFechaHasta :
        FOR EACH almdmov USE-INDEX almd03
                WHERE almdmov.codcia = s-codcia
                        AND almdmov.codalm = tt-resumen.tcodalm
                        AND almdmov.codmat = tt-resumen.tcodmat
                        AND almdmov.fchdoc = xFecha 
                        AND almdmov.tipmov = 'S'
                        AND almdmov.codmov = 2 NO-LOCK:
            /**/
            xCant = xCant + (almdmov.candes * almdmov.factor).            
        END.
    END.
    ASSIGN tt-resumen.tvtamesant = tt-resumen.tvtamesant + xCant.

    /* Stock Mes Pasado */
    /* Inicio */    
    FIND LAST AlmStkAl WHERE AlmStkAl.codcia = s-codcia AND
                                AlmStkAl.codalm = tt-resumen.tcodalm AND 
                                AlmstkAl.codmat = tt-resumen.tcodmat AND
                                AlmstkAl.fecha < xFechaDesde NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkAl THEN DO:
        ASSIGN tt-resumen.tstkinimesant   = tt-resumen.tstkinimesant + AlmstkAl.stkact.
    END.
    /* final */
    FIND LAST AlmStkAl WHERE AlmStkAl.codcia = s-codcia AND
                                AlmStkAl.codalm = tt-resumen.tcodalm AND 
                                AlmstkAl.codmat = tt-resumen.tcodmat AND
                                AlmstkAl.fecha <= xFechaHasta NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkAl THEN DO:
        ASSIGN tt-resumen.tstkfinmesant   = tt-resumen.tstkfinmesant + AlmstkAl.stkact.
    END.

END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ventas-mes-sgte-anno-pasado W-Win 
PROCEDURE ventas-mes-sgte-anno-pasado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR xFechaDesde AS DATE.
DEFINE VAR xFechaHasta AS DATE.
DEFINE VAR xFecha AS DATE.

DEFINE VAR xAAAA AS INT.
DEFINE VAR xMM AS INT.
DEFINE VAR xCant AS DEC.
/*
    FIELDS  tvtasmsigapas      AS DEC      FORMAT '->,>>>,>>9.99'  COLUMN-LABEL "Venta mes siguiente año pasado" INIT 0    
*/

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH tt-resumen :
    /* Del año pasado mes siguiente */
    xAAAA = tt-resumen.tyear - 1.
    xMM = tt-resumen.tmes + 1.
    xAAAA = IF(xMM > 12) THEN (xAAAA + 1) ELSE xAAAA.
    xMM = IF(xMM > 12) THEN (xMM - 12) ELSE xMM.

    /* Fecha DESDE */
    xFechaDesde = DATE(xMM,1,xAAAA).

    /* Fecha HASTA */
    xAAAA = IF(xMM = 12) THEN (xAAAA + 1) ELSE xAAAA.
    xMM = IF(xMM = 12) THEN 1 ELSE (xMM + 1).
    xFechaHasta = DATE(xMM,1,xAAAA) - 1.

    xCant = 0.
    REPEAT xFecha = xFechaDesde TO xFechaHasta :
        FOR EACH almdmov USE-INDEX almd03
                WHERE almdmov.codcia = s-codcia
                        AND almdmov.codalm = tt-resumen.tcodalm
                        AND almdmov.codmat = tt-resumen.tcodmat
                        AND almdmov.fchdoc = xFecha 
                        AND almdmov.tipmov = 'S'
                        AND almdmov.codmov = 2 NO-LOCK:
            /**/
            xCant = xCant + (almdmov.candes * almdmov.factor).            
        END.
    END.
    ASSIGN tt-resumen.tvtasmsigapas = tt-resumen.tvtasmsigapas + xCant.
END.
SESSION:SET-WAIT-STATE('').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

