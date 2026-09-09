&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

/* Stamdard */
DEF TEMP-TABLE Detalle
    FIELD codmat    AS CHAR FORMAT 'x(6)'
    FIELD Producto  AS CHAR FORMAT 'x(60)'
    FIELD Linea     AS CHAR FORMAT 'x(60)'
    FIELD Sublinea  AS CHAR FORMAT 'x(60)'
    FIELD Marca     AS CHAR FORMAT 'x(20)'
    FIELD Unidad    AS CHAR FORMAT 'x(10)'
    FIELD Licencia  AS CHAR FORMAT 'x(60)'
    FIELD CanxMes   AS DEC  LABEL "Cantidad"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMe AS DEC  LABEL "Ventas US$"  FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMn AS DEC  LABEL "Ventas S/."  FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoxMesMe AS DEC  LABEL "Costo US$"   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoxMesMn AS DEC  LABEL "Costo S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD ProxMesMe AS DEC  LABEL "Promedio US$"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD proxMesMn AS DEC  LABEL "Promedio S/."    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMn_ant AS DEC  LABEL "Ventas Ant S/."  FORMAT '->>>,>>>,>>>,>>9.99'        
    FIELD CtoxMesMn_ant AS DEC  LABEL "Costo Ant S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMn_act AS DEC  LABEL "Ventas S/."  FORMAT '->>>,>>>,>>>,>>9.99'        
    FIELD CtoxMesMn_act AS DEC  LABEL "Costo S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD margen_ant AS DEC  LABEL "Ganancia Ant S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD margen_act AS DEC  LABEL "Ganancia S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD fcrecimiento AS DEC  LABEL "Crecimiento S/."   FORMAT '->>>,>>9.9999'
    FIELD fventas AS DEC  LABEL "Factor Vtas"   FORMAT '->>>,>>9.999999'
    FIELD fmargen AS DEC  LABEL "Factor Margen"   FORMAT '->>>,>>9.999999'
    FIELD fcreci AS DEC  LABEL "Factor Crecimiento"   FORMAT '->>>,>>9.999999'
    FIELD fventas1 AS DEC  LABEL "Factor Vtas"   FORMAT '->>>,>>9.999999'
    FIELD fmargen1 AS DEC  LABEL "Factor Margen"   FORMAT '->>>,>>9.999999'
    FIELD fcreci1 AS DEC  LABEL "Factor Crecimiento"   FORMAT '->>>,>>9.999999'
    FIELD sumafactor AS DEC  LABEL "Suma de factores de Crecimiento"   FORMAT '->>>,>>9.999999'
    FIELD clasificacion AS CHAR FORMAT 'X(2)' 
    FIELD iranking AS INT  LABEL "Ranking"   FORMAT '->>>,>>9.999999'
    FIELD tpoart    AS CHAR FORMAT "x(2)"

    INDEX IdxKey01 AS PRIMARY codmat
    INDEX IdxVtas VtaxMesMn_act DESCENDING
    INDEX IdxMargen margen_act DESCENDING
    INDEX IdxCreci fcrecimiento DESCENDING
    INDEX IdxSumFac sumafactor DESCENDING.

DEF VAR cProducto  LIKE Detalle.Producto.
DEF VAR cCodMat    LIKE Detalle.CodMat.
DEF VAR cLinea     LIKE Detalle.Linea.
DEF VAR cSublinea  LIKE Detalle.Sublinea.
DEF VAR cMarca     LIKE Detalle.Marca.
DEF VAR cUnidad    LIKE Detalle.Unidad.
DEF VAR cLicencia  LIKE Detalle.Licencia.

DEFINE VAR dDesde_ant AS DATE.
DEFINE VAR dHasta_ant AS DATE.
DEFINE VAR lFamiExo AS CHAR.
DEFINE VAR lDivisiones AS CHAR.
DEFINE STREAM report.

DEFINE VAR lTpoConsumido AS CHARACTER.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR xQArt AS INT INIT 0.  /* Cantidad de Articulos Especiales */
DEFINE VAR xQTotArt AS INT INIT 0.  /* Cantidad de Articulos Normales */

DEFINE VAR lGrupo AS INT. /* Grupo del Proceso (1:General 2:Utilex e Inst 3 : Mayorista) */
DEFINE VAR lCampana AS INT. /* 0 : Campaña    3 : No Campaña*/
DEFINE VAR lFileTxt AS CHAR.
DEFINE VAR lTabla AS CHAR INIT "RANKVTA".

/* Especiales */
DEF TEMP-TABLE Detalle-esp
    FIELD codmat    AS CHAR FORMAT 'x(6)'
    FIELD Producto  AS CHAR FORMAT 'x(60)'
    FIELD Linea     AS CHAR FORMAT 'x(60)'
    FIELD Sublinea  AS CHAR FORMAT 'x(60)'
    FIELD Marca     AS CHAR FORMAT 'x(20)'
    FIELD Unidad    AS CHAR FORMAT 'x(10)'
    FIELD Licencia  AS CHAR FORMAT 'x(60)'
    FIELD CanxMes   AS DEC  LABEL "Cantidad"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMe AS DEC  LABEL "Ventas US$"  FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMn AS DEC  LABEL "Ventas S/."  FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoxMesMe AS DEC  LABEL "Costo US$"   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD CtoxMesMn AS DEC  LABEL "Costo S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD ProxMesMe AS DEC  LABEL "Promedio US$"    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD proxMesMn AS DEC  LABEL "Promedio S/."    FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMn_ant AS DEC  LABEL "Ventas Ant S/."  FORMAT '->>>,>>>,>>>,>>9.99'        
    FIELD CtoxMesMn_ant AS DEC  LABEL "Costo Ant S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD VtaxMesMn_act AS DEC  LABEL "Ventas S/."  FORMAT '->>>,>>>,>>>,>>9.99'        
    FIELD CtoxMesMn_act AS DEC  LABEL "Costo S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD margen_ant AS DEC  LABEL "Ganancia Ant S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD margen_act AS DEC  LABEL "Ganancia S/."   FORMAT '->>>,>>>,>>>,>>9.99'
    FIELD fcrecimiento AS DEC  LABEL "Crecimiento S/."   FORMAT '->>>,>>9.9999'
    FIELD fventas AS DEC  LABEL "Factor Vtas"   FORMAT '->>>,>>9.999999'
    FIELD fmargen AS DEC  LABEL "Factor Margen"   FORMAT '->>>,>>9.999999'
    FIELD fcreci AS DEC  LABEL "Factor Crecimiento"   FORMAT '->>>,>>9.999999'
    FIELD fventas1 AS DEC  LABEL "Factor Vtas"   FORMAT '->>>,>>9.999999'
    FIELD fmargen1 AS DEC  LABEL "Factor Margen"   FORMAT '->>>,>>9.999999'
    FIELD fcreci1 AS DEC  LABEL "Factor Crecimiento"   FORMAT '->>>,>>9.999999'
    FIELD sumafactor AS DEC  LABEL "Suma de factores de Crecimiento"   FORMAT '->>>,>>9.999999'
    FIELD clasificacion AS CHAR FORMAT 'X(2)' 
    FIELD iranking AS INT  LABEL "Ranking"   FORMAT '->>>,>>9.999999'
    FIELD tpoart    AS CHAR FORMAT "x(2)"

    INDEX IdxKey01 AS PRIMARY codmat
    INDEX IdxVtas VtaxMesMn_act DESCENDING
    INDEX IdxMargen margen_act DESCENDING
    INDEX IdxCreci fcrecimiento DESCENDING
    INDEX IdxSumFac sumafactor DESCENDING.


DEF TEMP-TABLE art-esp
    FIELD codmat    AS CHAR FORMAT 'x(6)'
    FIELD Producto  AS CHAR FORMAT 'x(60)'
    FIELD clasificacion AS CHAR FORMAT 'X(2)' 
    FIELD tpoart AS CHAR FORMAT 'X(1)' 
    FIELD fching AS DATE
    
    INDEX IdxKey01 AS PRIMARY codmat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS pVenta pMargen pCreci pFactor qValor_A ~
qValor_B qValor_C qValor_D qValor_E dDesde dHasta FamiliaNoConsideradas ~
ChkBx-General Chkbx-Utilex-Inst ChkBx-todos-menos-inst optGrpCampana ~
chk_saveranking btnProcesar RECT-1 RECT-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS txt-msg pVenta pMargen pCreci pTotal ~
pFactor qValor_A qValor_B qValor_C qValor_D qValor_E qValor_F qTot_Arti ~
dDesde dHasta FamiliaNoConsideradas ChkBx-General Chkbx-Utilex-Inst ~
ChkBx-todos-menos-inst optGrpCampana chk_saveranking rb_cuales 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnRecalcularQtyArt 
     LABEL "Recalcular Cantidad Articulos" 
     SIZE 28 BY 1.12.

DEFINE VARIABLE dDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE dHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FamiliaNoConsideradas AS CHARACTER FORMAT "X(256)":U INITIAL "008,009,020,015,050,888,999,081,082,083,084,085" 
     LABEL "Familias NO consideradas" 
     VIEW-AS FILL-IN 
     SIZE 52.57 BY 1 NO-UNDO.

DEFINE VARIABLE pCreci AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 3 
     LABEL "% Crecimiento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE pFactor AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 5 
     LABEL "Factor de Crecimiento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE pMargen AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 50 
     LABEL "% Margen" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE pTotal AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 100 
     LABEL "% Total" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE pVenta AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 47 
     LABEL "% Venta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE qTot_Arti AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Total Articulos" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE qValor_A AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 500 
     LABEL "(A)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE qValor_B AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 600 
     LABEL "(B)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE qValor_C AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1000 
     LABEL "(C)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE qValor_D AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 2000 
     LABEL "(D)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE qValor_E AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 3000 
     LABEL "(E)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE qValor_F AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "(F)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-msg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75.14 BY 1 NO-UNDO.

DEFINE VARIABLE optGrpCampana AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Campaña", 1,
"NO - Campaña", 2
     SIZE 23 BY 1.73 NO-UNDO.

DEFINE VARIABLE rb_cuales AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "General", 1,
"Solo Utilex e Institucionales", 2,
"Todos - Menos Utilex e Institucionales", 3
     SIZE 35 BY 2.04 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 5.54.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24.29 BY 7.88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.14 BY 2.69.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 1.96.

DEFINE VARIABLE ChkBx-General AS LOGICAL INITIAL no 
     LABEL "General" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE ChkBx-todos-menos-inst AS LOGICAL INITIAL no 
     LABEL "General - Menos Utilex e Institucionales" 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .77 NO-UNDO.

DEFINE VARIABLE Chkbx-Utilex-Inst AS LOGICAL INITIAL no 
     LABEL "Solo Utilex e Institucionales" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .77 NO-UNDO.

DEFINE VARIABLE chk_saveranking AS LOGICAL INITIAL yes 
     LABEL "Grabar Ranking en los Articulos" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txt-msg AT ROW 15.23 COL 8 NO-LABEL WIDGET-ID 42
     pVenta AT ROW 2.5 COL 24.57 COLON-ALIGNED WIDGET-ID 2
     pMargen AT ROW 3.65 COL 24.43 COLON-ALIGNED WIDGET-ID 4
     pCreci AT ROW 4.85 COL 24.43 COLON-ALIGNED WIDGET-ID 6
     pTotal AT ROW 6.15 COL 24.43 COLON-ALIGNED WIDGET-ID 8
     pFactor AT ROW 8.19 COL 24.72 COLON-ALIGNED WIDGET-ID 28
     qValor_A AT ROW 1.96 COL 58.29 COLON-ALIGNED WIDGET-ID 12
     qValor_B AT ROW 3.15 COL 58.29 COLON-ALIGNED WIDGET-ID 14
     qValor_C AT ROW 4.38 COL 58.29 COLON-ALIGNED WIDGET-ID 16
     qValor_D AT ROW 5.62 COL 58.29 COLON-ALIGNED WIDGET-ID 18
     qValor_E AT ROW 6.81 COL 58.29 COLON-ALIGNED WIDGET-ID 20
     qValor_F AT ROW 8.04 COL 58.29 COLON-ALIGNED WIDGET-ID 22
     qTot_Arti AT ROW 9.46 COL 58 COLON-ALIGNED WIDGET-ID 26
     dDesde AT ROW 13.69 COL 23 COLON-ALIGNED WIDGET-ID 30
     dHasta AT ROW 13.69 COL 47.57 COLON-ALIGNED WIDGET-ID 32
     FamiliaNoConsideradas AT ROW 12.15 COL 2.28 WIDGET-ID 38
     ChkBx-General AT ROW 16.88 COL 7.14 WIDGET-ID 54
     Chkbx-Utilex-Inst AT ROW 17.65 COL 7.14 WIDGET-ID 56
     ChkBx-todos-menos-inst AT ROW 18.42 COL 7.14 WIDGET-ID 58
     optGrpCampana AT ROW 17.27 COL 52.86 NO-LABEL WIDGET-ID 62
     chk_saveranking AT ROW 21 COL 32 WIDGET-ID 48
     btnProcesar AT ROW 20.81 COL 64 WIDGET-ID 34
     btnRecalcularQtyArt AT ROW 10.69 COL 49.29 WIDGET-ID 36
     rb_cuales AT ROW 9.54 COL 4 NO-LABEL WIDGET-ID 50
     "% Asignacion" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 1.77 COL 14 WIDGET-ID 44
     "Ranking" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.19 COL 55.57 WIDGET-ID 46
     RECT-1 AT ROW 2.04 COL 12 WIDGET-ID 10
     RECT-2 AT ROW 1.42 COL 54 WIDGET-ID 24
     RECT-3 AT ROW 16.77 COL 5 WIDGET-ID 66
     RECT-4 AT ROW 17.15 COL 52 WIDGET-ID 68
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 1
         SIZE 89.43 BY 21.46 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Estadisticas de Ventas (Pareto)"
         HEIGHT             = 21.46
         WIDTH              = 89.57
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.81
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON btnRecalcularQtyArt IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FamiliaNoConsideradas IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN pTotal IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN qTot_Arti IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN qValor_F IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rb_cuales IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msg IN FRAME fMain
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Estadisticas de Ventas (Pareto) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Estadisticas de Ventas (Pareto) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar wWin
ON CHOOSE OF btnProcesar IN FRAME fMain /* Procesar */
DO:   
    DEFINE VAR lYear AS INT.
   
    DO WITH FRAME {&FRAME-NAME} : 
        ASSIGN dDesde
                dHasta
                pFactor
                qTot_arti
                qValor_f
                pTotal
                pVenta
                pMargen
                pCreci
                pFactor
                qValor_A
                qValor_B
                qValor_C
                qValor_D
                qValor_E
                qValor_F
                chk_saveranking
                familiaNoConsideradas
                rb_cuales
                Chkbx-General
                Chkbx-Utilex-inst
                Chkbx-todos-menos-inst
                OptGrpCampana.
    END.

    IF pTotal <> 100 THEN DO:
        MESSAGE '%Total de Asignacion debe ser 100%' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    IF NOT (pFactor >= 0 AND pFactor <= 10) THEN DO:
        MESSAGE 'Factor de Ajuste debe tener valores entre 0..10' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    /*
    IF qTot_arti < 1  THEN DO:
        MESSAGE 'Recalcule Cantidad de Articulos...' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    
    IF qTot_arti = qValor_f THEN DO:
        MESSAGE 'Ingrese valores para A, B, C, D, E' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    */
  
    lYear = YEAR(dDesde).
    IF ((lYear MODULO 4) = 0 AND (lYear MODULO 100) <> 0) OR (lyear MODULO 400)=0 THEN DO:
        /* Año bisiesto */
        dDesde_ant = dDesde - 366.
    END.
    ELSE DO:
        dDesde_ant = dDesde - 365.
    END.

    lYear = YEAR(dHasta).
    IF ((lYear MODULO 4) = 0 AND (lYear MODULO 100) <> 0) OR (lyear MODULO 400)=0 THEN DO:
        /* Año bisiesto */
        dHasta_ant = dHasta - 366.
    END.
    ELSE DO:
        dHasta_ant = dHasta - 365.
    END.

    lTpoConsumido = STRING(NOW).

    SESSION:SET-WAIT-STATE('GENERAL').    

    lFileTxt = "Resto-campana".
    lCampana = 0.  /* Campaña */
    IF optgrpCampana = 2 THEN DO:
        lCampana = 3.  /* NO Campaña */
        lFileTxt = "Resto-no-campana".
    END.

    /* Clasificacion General */
    IF ChkBx-General = YES THEN DO:
        ASSIGN lGrupo = 1.
        lFileTxt = lFileTxt + "-General".
        RUN ue-procesar.
    END.
    /* Clasificacion Utilex e institucionales */
    IF ChkBx-Utilex-Inst = YES THEN DO:
        ASSIGN lGrupo = 2.
        lFileTxt = lFileTxt + "-utilex".
        RUN ue-procesar.
    END.
    /* Clasificacion General */
    IF ChkBx-Todos-menos-inst = YES THEN DO:
        ASSIGN lGrupo = 3.
        lFileTxt = lFileTxt + "-mayorista".
        RUN ue-procesar.
    END.

    SESSION:SET-WAIT-STATE('').

    lTpoConsumido = lTpoConsumido + " / " + STRING(NOW).
    txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lTpoConsumido.


    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRecalcularQtyArt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRecalcularQtyArt wWin
ON CHOOSE OF btnRecalcularQtyArt IN FRAME fMain /* Recalcular Cantidad Articulos */
DO:
  DEFINE VAR lQtyArt AS INT.
  DEFINE VAR lFamiExo AS CHAR.
  DEFINE VAR lRowId AS ROWID.

 DO WITH FRAME {&FRAME-NAME} : 
    ASSIGN dDesde
            dHasta
            pFactor
            qTot_arti
            qValor_f
            pTotal
            pVenta
            pMargen
            pCreci
            pFactor
            qValor_A
            qValor_B
            qValor_C
            qValor_D
            qValor_E
            qValor_F
            chk_saveranking
            FamiliaNoConsideradas
            rb_cuales.
END.

lFamiExo = familianoconsideradas:SCREEN-VALUE.

/*
 Para considerarlo como articulo ESPECIAL,
 estamos asumiendo que son los articulos creados despues de la ultima fecha de proceso 
*/
lQtyArt   = 0.
xQArt     = 0. /* Cantidad articulos especiales */
SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH almmmatg WHERE /*tpoart = 'A' AND */ almmmatg.codcia = s-codcia AND 
    LOOKUP (codfam, lFamiExo ) = 0 NO-LOCK:
    IF almmmatg.tpoart <> 'A' THEN DO:
        lQtyArt = lQtyArt + 1.
        xQArt = xQArt + IF (almmmatg.fching <= dHasta) THEN 0 ELSE 1.
    END.

    CREATE art-esp.
        ASSIGN art-esp.codmat = almmmatg.codmat
            art-esp.producto = almmmatg.desmat
            art-esp.tpoart = almmmatg.tpoart
            art-esp.fching = almmmatg.fching
            art-esp.clasificacion = ''.
    /*
    IF (almmmatg.fching <= dHasta) THEN DO:
        ASSIGN art-esp.clasificacion = 'XF'.
    END.
    ELSE DO:
        ASSIGN art-esp.clasificacion = 'NF'.
    END.
    */
END.

  qtot_arti:SCREEN-VALUE = STRING(lQtyArt,"999999").
  SESSION:SET-WAIT-STATE('').  

  RUN pCalcula_F.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pCreci
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pCreci wWin
ON LEAVE OF pCreci IN FRAME fMain /* % Crecimiento */
DO:
  RUN pTotal_suma.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pMargen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pMargen wWin
ON LEAVE OF pMargen IN FRAME fMain /* % Margen */
DO:
  RUN pTotal_suma.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pVenta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pVenta wWin
ON LEAVE OF pVenta IN FRAME fMain /* % Venta */
DO:
 
    RUN pTotal_suma.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME qValor_A
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL qValor_A wWin
ON LEAVE OF qValor_A IN FRAME fMain /* (A) */
DO:
  RUN pCalcula_F.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME qValor_B
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL qValor_B wWin
ON LEAVE OF qValor_B IN FRAME fMain /* (B) */
DO:
  RUN pCalcula_F.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME qValor_C
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL qValor_C wWin
ON LEAVE OF qValor_C IN FRAME fMain /* (C) */
DO:
  RUN pCalcula_F.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME qValor_D
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL qValor_D wWin
ON LEAVE OF qValor_D IN FRAME fMain /* (D) */
DO:
  RUN pCalcula_F.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME qValor_E
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL qValor_E wWin
ON LEAVE OF qValor_E IN FRAME fMain /* (E) */
DO:
  RUN pCalcula_F.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}


ASSIGN dDesde = TODAY.
/*ASSIGN txt-msg = STRING(NOW,"dd/mm/yyyy hh:mm:ss").*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY txt-msg pVenta pMargen pCreci pTotal pFactor qValor_A qValor_B 
          qValor_C qValor_D qValor_E qValor_F qTot_Arti dDesde dHasta 
          FamiliaNoConsideradas ChkBx-General Chkbx-Utilex-Inst 
          ChkBx-todos-menos-inst optGrpCampana chk_saveranking rb_cuales 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE pVenta pMargen pCreci pFactor qValor_A qValor_B qValor_C qValor_D 
         qValor_E dDesde dHasta FamiliaNoConsideradas ChkBx-General 
         Chkbx-Utilex-Inst ChkBx-todos-menos-inst optGrpCampana chk_saveranking 
         btnProcesar RECT-1 RECT-2 RECT-3 RECT-4 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

/* Code placed here will execute AFTER standard behavior.    */
    ASSIGN dDesde = TODAY - 30.
    ASSIGN dHasta = TODAY.
/**/
RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pCalcula_F wWin 
PROCEDURE pCalcula_F :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lTotal AS INT.
DEFINE VAR lTotArt AS INT.
DEFINE VAR lqValorA AS INT.
DEFINE VAR lqValorB AS INT.
DEFINE VAR lqValorC AS INT.
DEFINE VAR lqValorD AS INT.
DEFINE VAR lqValorE AS INT.
DEFINE VAR lqValorF AS INT.

lqValorA = INTEGER(qValor_A:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
lqValorB = INTEGER(qValor_B:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
lqValorC = INTEGER(qValor_C:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
lqValorD = INTEGER(qValor_D:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
lqValorE = INTEGER(qValor_E:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
/*lTotArt = INTEGER(qTot_Arti:SCREEN-VALUE IN FRAME {&FRAME-NAME}).*/
qTot_Arti:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(xqTotArt,">>>,>>>,>>9").
lTotArt = xqTotArt .

ltotal = lqValorA + lqValorB + lqValorC + lqValorD + lqValorE.
IF lTotArt > 0 AND (ltotArt - lTotal) > 0 THEN DO:
    ASSIGN qValor_F:SCREEN-VALUE = STRING(ltotArt - lTotal,"9999999").
END.
ELSE ASSIGN qValor_F:SCREEN-VALUE = STRING(0,"9999999").

ASSIGN qValor_F qTot_Arti.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-excel-resto wWin 
PROCEDURE proc-excel-resto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-archivo AS CHAR.

X-archivo = "c:\ciman\data-paretro-resto.txt".

OUTPUT STREAM REPORT TO VALUE(x-Archivo).

PUT STREAM REPORT
    "CodArt|"
    "Nombre Articulo|"
    "Clasif|"
    "Fecha Ing|"
    "Stat" SKIP.

FOR EACH art-esp NO-LOCK :
    PUT STREAM REPORT 
        art-esp.codmat "|"
        art-esp.Producto "|"
        art-esp.clasificacion "|"
        art-esp.fching "|"
        art-esp.tpoart SKIP.
END.

OUTPUT STREAM REPORT CLOSE.


/*

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

iColumn = 1.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "CodArt".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre Articulo".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Clasif".

FOR EACH art-esp NO-LOCK :
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + art-esp.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + art-esp.Producto.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + art-esp.clasificacion.
END.

chWorkSheet:SaveAs("c:\ciman\data-paretro-resto.xls").

chExcelApplication:DisplayAlerts = False.
chExcelApplication:Quit().

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR.         
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-gen-txt wWin 
PROCEDURE proc-gen-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-especial      AS LOG NO-UNDO.

DEFINE VAR X-archivo AS CHAR.

IF p-especial = NO THEN DO:
    X-archivo = "c:\ciman\"+ lFileTxt + "-standard.txt".
END.
ELSE DO:
    X-archivo = "c:\ciman\" + lFileTxt + "-especial.txt".
END.

OUTPUT STREAM REPORT TO VALUE(x-Archivo).

PUT STREAM REPORT
    "CodArt|"
    "Nombre Articulo|"
    "Linea|"
    "SubLinea|"
    "Marca|"
    "Unidad|"
    "Licencia|"
    "Vtas Anterior S/.|"
    "Costo Anterior  S/.|"
    "Ganancia Anterior S/.|"
    "Vtas Actual  S/.|"
    "Costo Actual  S/.|"
    "Ganancia Actual S/.|"
    "F.Crecimiento|"
    "Factor Vtas|"
    "Factor Margen|"
    "Factor Crecim.|"
    "Asig.Factor Vtas|"
    "Asig.Factor Margen|"
    "Asig.Factor Crecim.|"
    "Suma Factores|"
    "Clase|"
    "Ranking|"
    "Estado" SKIP.

IF p-especial = NO THEN DO:
    FOR EACH Detalle NO-LOCK :
        PUT STREAM REPORT 
            detalle.codmat "|"
            Detalle.Producto "|"
            Detalle.Linea "|"
            Detalle.Sublinea "|"
            Detalle.Marca "|"
            Detalle.Unidad "|"
            Detalle.Licencia "|"
            Detalle.VtaxMesMn_ant "|"
            Detalle.CtoxMesMn_ant "|"
            Detalle.margen_ant "|"
            Detalle.VtaxMesMn_act "|"
            Detalle.CtoxMesMn_act "|"
            Detalle.margen_act "|"
            Detalle.fcrecimiento "|"
            Detalle.fventas "|"
            Detalle.fmargen "|"
            Detalle.fcreci "|"
            Detalle.fventas1 "|"
            Detalle.fmargen1 "|"
            Detalle.fcreci1 "|"
            Detalle.sumafactor "|"
            Detalle.clasificacion "|"
            Detalle.iranking "|"
            Detalle.tpoart SKIP.
    END.
END.
ELSE DO:
    FOR EACH Detalle-esp NO-LOCK :
        PUT STREAM REPORT 
            detalle-esp.codmat "|"
            Detalle-esp.Producto "|"
            Detalle-esp.Linea "|"
            Detalle-esp.Sublinea "|"
            Detalle-esp.Marca "|"
            Detalle-esp.Unidad "|"
            Detalle-esp.Licencia "|"
            Detalle-esp.VtaxMesMn_ant "|"
            Detalle-esp.CtoxMesMn_ant "|"
            Detalle-esp.margen_ant "|"
            Detalle-esp.VtaxMesMn_act "|"
            Detalle-esp.CtoxMesMn_act "|"
            Detalle-esp.margen_act "|"
            Detalle-esp.fcrecimiento "|"
            Detalle-esp.fventas "|"
            Detalle-esp.fmargen "|"
            Detalle-esp.fcreci "|"
            Detalle-esp.fventas1 "|"
            Detalle-esp.fmargen1 "|"
            Detalle-esp.fcreci1 "|"
            Detalle-esp.sumafactor "|"
            Detalle-esp.clasificacion "|"
            Detalle-esp.iranking "|"
            detalle-esp.tpoart SKIP.
    END.
END.
  
OUTPUT STREAM REPORT CLOSE.
/*MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_calc_factores wWin 
PROCEDURE proc_calc_factores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-especial  AS LOG NO-UNDO.

DEFINE VAR lMaxVtas AS DECIMAL.
DEFINE VAR lMaxMargen AS DECIMAL.
DEFINE VAR lMaxFCreci AS DECIMAL.

DEFINE VAR lRanking AS INT.
DEFINE VAR lRank AS CHAR.
DEFINE VAR lRegsRank AS INT.
DEFINE VAR lRegCount AS INT.

DEFINE VAR lCount AS INT.

DEFINE VAR lqValor_A AS INT.
DEFINE VAR lqValor_B AS INT.
DEFINE VAR lqValor_C AS INT.
DEFINE VAR lqValor_D AS INT.
DEFINE VAR lqValor_E AS INT.
DEFINE VAR lqValor_F AS INT.

IF p-especial = YES THEN DO:

    lqValor_A = ROUND((ROUND(qValor_A / xQTotArt,6) * xQArt),0).
    lqValor_B = ROUND((ROUND(qValor_B / xQTotArt,6) * xQArt),0).
    lqValor_C = ROUND((ROUND(qValor_C / xQTotArt,6) * xQArt),0).
    lqValor_D = ROUND((ROUND(qValor_D / xQTotArt,6) * xQArt),0).
    lqValor_E = ROUND((ROUND(qValor_E / xQTotArt,6) * xQArt),0).

    lqValor_F = xQArt - (lqValor_A + lqValor_B + lqValor_C + lqValor_D + lqValor_E).

    {est\proc-calc-factores.i &tabla="detalle-esp"}.
END.
ELSE DO:

    lqValor_A = qValor_A.
    lqValor_B = qValor_B.
    lqValor_C = qValor_C.
    lqValor_D = qValor_D.
    lqValor_E = qValor_E.
    lqValor_F = qValor_F.

    {est\proc-calc-factores.i &tabla="detalle"}.
END.

/*

lMaxVtas = 0.
lMaxMargen = 0.
lMaxFCreci = 0.
lCount = 1.

/* Maximo de Ventas */
FOR EACH detalle USE-INDEX IdxVtas :
    lMaxVtas = VtaxMesMn_act.
    IF lMaxVtas > 0 THEN LEAVE.
END.

/* Maximo de Margen */
FOR EACH detalle USE-INDEX IdxMargen :
    lMaxMargen = margen_act.
    IF lMaxMargen > 0 THEN LEAVE.
END.

/* Factor de Crecimiento */
FOR EACH detalle USE-INDEX IdxCreci :
    IF lCount = pFactor THEN DO:
        lMaxFCreci = detalle.fcrecimiento.
    END.
    lCount = lCount + 1.
END.

/* Calculo lo Factores de todos los Articulos*/
FOR EACH detalle :
    /*
    txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "FASE #2 - FACTORES..." + ' / ' + 
        detalle.codmat + ' ' + detalle.producto. 
    */
    /* Ventas */
    ASSIGN fVentas = ROUND( VtaxMesMn_act / lMaxVtas , 6).
    /* Margen */
    ASSIGN fMargen = ROUND( margen_act / lMaxMargen , 6).
    /* Factor Crecimiento */
    IF fcrecimiento >= lMaxFCreci THEN DO:
        ASSIGN fcreci = 1.
    END.
    ELSE DO:
        ASSIGN fcreci = ROUND( fcrecimiento / lMaxFCreci , 6).
    END.
    ASSIGN fVentas1 = ROUND( fVentas * (pVenta / 100) , 6)
            fMargen1 = ROUND( fMargen * (pMargen / 100) , 6)
            fCreci1 = ROUND( fCreci * (pCreci / 100) , 6).
    ASSIGN sumafactor = fVentas1 + fMargen1 + fCreci1.
END.

lRanking    = 0.    /* Nivel de cada ranking A, B, C, D,...F */
lRank       = "".  /* Clasificacion */
lRegsRank   = -1.
lRegCount   = 0.
lCount      = 1.    /* El Ranking */

FOR EACH detalle USE-INDEX IdxSumFac :
    IF lRegsRank < lRegCount THEN DO:
        lRanking = lRanking + 1.
        IF lRanking <= 1 AND qValor_A > 0 THEN DO:
            /* Nivel del Ranking A */
           lRegsRank = qValor_A.
           lRank = 'A'.
           lRegCount = 1.   /* Reseteo contador de cada ranking */
           lRanking = 1.   /* Reseteo contador de cada ranking */
        END.
        ELSE  DO:
            IF lRanking <= 2 AND qValor_B > 0 THEN DO:
                /* Nivel del Ranking B */
                lRegsRank = qValor_B.
                lRank = 'B'.
                lRegCount = 1.
                lRanking = 2.
            END.
            ELSE DO:
                IF lRanking <= 3 AND qValor_C > 0 THEN DO:
                    /* Nivel del Ranking C */
                    lRegsRank = qValor_C.
                    lRank = 'C'.
                    lRegCount = 1.
                    lRanking = 3.
                END.
                ELSE DO:
                    IF lRanking <= 4 AND qValor_D > 0 THEN DO:
                        /* Nivel del Ranking D */
                        lRegsRank = qValor_D.
                        lRank = 'D'.
                        lRegCount = 1.
                        lRanking = 4.
                    END.
                    ELSE DO:
                        IF lRanking <= 5 AND qValor_E > 0 THEN DO:
                            /* Nivel del Ranking E */
                            lRegsRank = qValor_E.
                            lRank = 'E'.
                            lRegCount = 1.
                            lRanking = 5.
                        END.
                        ELSE DO:
                            IF lRanking <= 6 AND qValor_F > 0 THEN DO:
                                /* Nivel del Ranking F */
                                lRegsRank = qValor_F.
                                lRank = 'F'.
                                lRegCount = 1.
                                lRanking = 7.
                            END.
                            ELSE DO:
                                lRegsRank = 99999999.
                                lRank = 'X'.
                                lRegCount = 1.
                                lRanking = 9.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
    IF lRegsRank > 0 THEN DO:
        ASSIGN clasificacion = lRank.        
        lRegCount = lRegCount + 1.   /* Incremento contador del ranking */
    END.
    ELSE lRegCount = 999999.

    ASSIGN iRanking = lCount.
    lCount = lCount + 1.
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_detalle2 wWin 
PROCEDURE proc_detalle2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-especial AS LOG NO-UNDO.

DEFINE VAR lConteo AS INT.  

txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "FACTORES...". 

lConteo = 0.
IF p-especial = NO THEN DO:    
    FOR EACH detalle :
    
        lConteo = lConteo + 1.
    
        IF (lConteo MODULO 250) = 0 THEN DO:
            txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Van STANDARD...(" + STRING(lConteo,">>>,>>>,>>9") + ")". 
        END.
    
        detalle.margen_ant = Detalle.VtaxMesMn_ant - Detalle.CtoxMesMn_ant.
        detalle.margen_act = Detalle.VtaxMesMn_act - Detalle.CtoxMesMn_act.
        IF Detalle.VtaxMesMn_ant <> 0 THEN 
            detalle.fcrecimiento = ROUND ( Detalle.VtaxMesMn_act / Detalle.VtaxMesMn_ant , 6).
    
    END.
END.
ELSE DO:
    FOR EACH detalle-esp :
    
        lConteo = lConteo + 1.
    
        IF (lConteo MODULO 250) = 0 THEN DO:
            txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Van ESPECIAL...(" + STRING(lConteo,">>>,>>>,>>9") + ")". 
        END.
    
        detalle-esp.margen_ant = Detalle-esp.VtaxMesMn_ant - Detalle-esp.CtoxMesMn_ant.
        detalle-esp.margen_act = Detalle-esp.VtaxMesMn_act - Detalle-esp.CtoxMesMn_act.
        IF Detalle-esp.VtaxMesMn_ant <> 0 THEN 
            detalle-esp.fcrecimiento = ROUND ( Detalle-esp.VtaxMesMn_act / Detalle-esp.VtaxMesMn_ant , 6).
    
    END.
END.
txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Total...(" + STRING(lConteo,">>>,>>>,>>9") + ")". 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_genexcel wWin 
PROCEDURE proc_genexcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-espcial      AS LOG NO-UNDO.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

iColumn = 1.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "CodArt".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre Articulo".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Linea".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "SubLinea".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidad".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Licencia".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Vtas Anterior S/.".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Costo Anterior  S/.".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Ganancia Anterior S/.".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Vtas Actual  S/.".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Costo Actual  S/.".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Ganancia Actual S/.".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "F.Crecimiento".

cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "Factor Vtas".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "Factor Margen".
cRange = "Q" + cColumn.
chWorkSheet:Range(cRange):Value = "Factor Crecim.".
cRange = "R" + cColumn.
chWorkSheet:Range(cRange):Value = "Asig.Factor Vtas".
cRange = "S" + cColumn.
chWorkSheet:Range(cRange):Value = "Asig.Factor Margen".
cRange = "T" + cColumn.
chWorkSheet:Range(cRange):Value = "Asig.Factor Crecim.".
cRange = "U" + cColumn.
chWorkSheet:Range(cRange):Value = "Suma Factores".

cRange = "V" + cColumn.
chWorkSheet:Range(cRange):Value = "Clase".

cRange = "W" + cColumn.
chWorkSheet:Range(cRange):Value = "Ranking".

iIndex = 0.

IF p-espcial = NO THEN DO:
    /* Standard */
    FOR EACH Detalle NO-LOCK :
        iIndex = iIndex + 1.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + detalle.codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle.Producto.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle.Linea.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle.Sublinea.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle.Marca.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle.Unidad.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle.Licencia.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.VtaxMesMn_ant.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.CtoxMesMn_ant.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.margen_ant.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.VtaxMesMn_act.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.CtoxMesMn_act.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.margen_act.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.fcrecimiento.

        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.fventas.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.fmargen.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.fcreci.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.fventas1.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.fmargen1.
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.fcreci1.
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.sumafactor.

        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.clasificacion.
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.iranking.

    END.
END.
ELSE DO:
    FOR EACH Detalle-esp NO-LOCK :
        iIndex = iIndex + 1.
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + detalle-esp.codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle-esp.Producto.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle-esp.Linea.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle-esp.Sublinea.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle-esp.Marca.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle-esp.Unidad.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle-esp.Licencia.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.VtaxMesMn_ant.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.CtoxMesMn_ant.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.margen_ant.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.VtaxMesMn_act.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.CtoxMesMn_act.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.margen_act.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.fcrecimiento.

        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.fventas.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.fmargen.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.fcreci.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.fventas1.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.fmargen1.
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.fcreci1.
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.sumafactor.

        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.clasificacion.
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle-esp.iranking.
    END.
END.

IF p-espcial = NO THEN DO:
    chWorkSheet:SaveAs("c:\ciman\data-paretro-standard.xls").
END.
ELSE DO:
    chWorkSheet:SaveAs("c:\ciman\data-paretro-especial.xls").
END.

chExcelApplication:DisplayAlerts = False.
chExcelApplication:Quit().

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR.         


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_grabar_ranking wWin 
PROCEDURE proc_grabar_ranking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-especial      AS LOG NO-UNDO.

/*
    Reemplazado por ue-grabar
*/


RETURN NO-APPLY.

/*  ---------------------------------------------  */

DEFINE VAR lRowId AS ROWID.

IF p-especial = NO THEN DO:
    /* Blanqueo los estados anteriores  */
    DEF BUFFER B-almmmatg FOR almmmatg.
    
    FOR EACH almmmatg WHERE almmmatg.tpoart = 'A' AND LOOKUP (almmmatg.codfam, lFamiExo ) = 0 NO-LOCK:
    
        IF chk_saveranking = YES THEN DO:
            lRowId = ROWID(almmmatg).
            FIND B-almmmatg WHERE ROWID(B-almmmatg) = lRowId EXCLUSIVE NO-ERROR.
    
            IF AVAILABLE b-almmmatg THEN DO:
                CASE rb_cuales:
                    WHEN 1 THEN DO:
                        /* Todas las divisiones */
                        ASSIGN b-almmmatg.tiprot[1] = IF (b-almmmatg.fching <= dHasta) THEN "XF" ELSE ""
                                b-almmmatg.ordtmp = 0.
                    END.
                    WHEN 2 THEN DO:
                        /* Solo Utilex y Institucionales */
                        ASSIGN b-almmmatg.undalt[3] = IF (b-almmmatg.fching <= dHasta) THEN "XF" ELSE ""
                                b-almmmatg.libre_d04 = 0.
                    END.
                    WHEN 3 THEN DO:
                        /* Todos menos Utilex e institucionales (Mayoristas) */
                        ASSIGN b-almmmatg.undalt[4] = IF (b-almmmatg.fching <= dHasta) THEN "XF" ELSE ""
                                b-almmmatg.libre_d05 = 0.
    
                    END.
                END CASE.
            END.
        END.
    END.
    
    RELEASE B-almmmatg.

    /* Standarrd */
    FOR EACH Detalle NO-LOCK :
    
        txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Guardando RANKING STANDARD..." + ' / ' + 
        detalle.codmat + ' ' + detalle.producto. 
    
    
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = detalle.codmat EXCLUSIVE NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            CASE rb_cuales:
                WHEN 1 THEN DO:
                    /* Todas las divisiones */
                    ASSIGN almmmatg.tiprot[1] = Detalle.clasificacion
                            almmmatg.ordtmp = Detalle.iranking.
                END.
                WHEN 2 THEN DO:
                    /* Solo Utilex y Institucionales */
                    ASSIGN almmmatg.undalt[3] = Detalle.clasificacion
                            almmmatg.libre_d04 = Detalle.iranking.
                END.
                WHEN 3 THEN DO:
                    /* Todos menos Utilex e institucionales (Mayoristas) */
                    ASSIGN almmmatg.undalt[4] = Detalle.clasificacion
                            almmmatg.libre_d05 = Detalle.iranking.
    
                END.
            END CASE.
        END.    
    END.
END.
ELSE DO:
    /* Especial */
    FOR EACH Detalle-esp NO-LOCK :
    
        txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Guardando RANKING ESPECIAL..." + ' / ' + 
        detalle-esp.codmat + ' ' + detalle-esp.producto. 
    
    
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = detalle-esp.codmat EXCLUSIVE NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            CASE rb_cuales:
                WHEN 1 THEN DO:
                    /* Todas las divisiones */
                    ASSIGN almmmatg.tiprot[1] = Detalle-esp.clasificacion
                            almmmatg.ordtmp = Detalle-esp.iranking.
                END.
                WHEN 2 THEN DO:
                    /* Solo Utilex y Institucionales */
                    ASSIGN almmmatg.undalt[3] = Detalle-esp.clasificacion
                            almmmatg.libre_d04 = Detalle-esp.iranking.
                END.
                WHEN 3 THEN DO:
                    /* Todos menos Utilex e institucionales (Mayoristas) */
                    ASSIGN almmmatg.undalt[4] = Detalle-esp.clasificacion
                            almmmatg.libre_d05 = Detalle-esp.iranking.
    
                END.
            END CASE.
        END.    
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_movimientos wWin 
PROCEDURE proc_movimientos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-Desde AS DATE NO-UNDO.
DEFINE INPUT PARAMETER p-Hasta AS DATE NO-UNDO.
DEFINE INPUT PARAMETER p-Llave AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-especial AS LOG NO-UNDO.

/*pVenta:SCREEN-VALUE IN FRAME {&FRAME-NAME}).*/

DEFINE VAR lCalcula AS LOGICAL.
DEFINE VAR lConteo AS INT.
lFamiExo = familianoconsideradas:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' . 

lConteo = 0.
txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Van...(" + STRING(lConteo,">>>,>>>,>>9") + 
            " " + IF(p-especial = YES) THEN "Especial" ELSE "Standard" + ") ".

FOR EACH VentasxProducto NO-LOCK WHERE VentasxProducto.Datekey >= p-Desde AND 
    ventasxproducto.datekey <= p-Hasta AND 
    ((rb_cuales = 2 AND lookup(ventasxproducto.coddiv,lDivisiones) > 0) OR      /* Utilex e Institucionales  */
     (lookup(ventasxproducto.coddiv,lDivisiones) = 0)) ,                        /* Todos o Mayoristas */
    FIRST dimProducto OF VentasxProducto NO-LOCK , 
    FIRST DimLinea OF DimProducto NO-LOCK WHERE LOOKUP (DimProducto.codfam, lFamiExo ) = 0,
    FIRST DimSubLinea OF DimProducto NO-LOCK:

    /* Ic - 18Jun2015, Segun Macchiu para NO CAMPAÑA excluir 01Nov204 hasta 31Mar2015 */
    IF optGrpCampana = 2 THEN DO:
        IF ventasxproducto.datekey >= 11/01/2014 AND ventasxproducto.datekey <= 03/31/2015 THEN NEXT.
        IF ventasxproducto.datekey >= 11/01/2013 AND ventasxproducto.datekey <= 03/31/2014 THEN NEXT.
    END.
    
    ASSIGN
            cCodMat = ''
            cProducto = ''            
            cLinea = ''
            cSublinea = ''
            cMarca = ''
            cUnidad = ''
            cLicencia = ''.

    lConteo = lConteo + 1.
    IF (lConteo MODULO 500) = 0 THEN DO:
        txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Van...( " + STRING(lConteo,">>>,>>>,>>9") + 
           " " + IF(p-especial = YES) THEN "Especial" ELSE "Standard" + ") " NO-ERROR.
    END.

    ASSIGN 
        cCodMat = VentasxProducto.codmat
        cProducto = DimProducto.DesMat            
        cLinea = DimProducto.codfam + ' ' + DimLinea.NomFam 
        cSublinea = DimProducto.subfam + ' ' + DimSubLinea.NomSubFam
        cMarca = DimProducto.desmar
        cUnidad = DimProducto.undstk
        cLicencia = DimProducto.licencia.

    lCalcula = NO.

    IF p-especial = NO THEN DO:
        /* Standard */
        FIND Detalle WHERE detalle.codmat = cCodMat USE-INDEX IdxKey01 NO-ERROR.
        IF NOT AVAILABLE Detalle THEN DO:

            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                almmmatg.codmat = cCodMat NO-LOCK NO-ERROR.

            CREATE Detalle.
            ASSIGN detalle.codmat = cCodmat
                Detalle.Producto = cProducto
                Detalle.Linea = cLinea
                Detalle.Sublinea = cSublinea
                Detalle.Marca = cMarca
                Detalle.Unidad = cUnidad
                Detalle.Licencia = cLicencia
                detalle.tpoart = IF (AVAILABLE almmmatg) THEN almmmatg.tpoart ELSE "X".

            xQTotArt = xQTotArt + 1.  /* Almaceno la cantidad de articulos */
        END.
        ELSE lCalcula = YES.
    
        IF p-Llave = 'ACTUAL' THEN DO:
            Detalle.VtaxMesMn_act = Detalle.VtaxMesMn_act + VentasxProducto.ImpNacCIGV.
            Detalle.CtoxMesMn_act = Detalle.CtoxMesMn_act + VentasxProducto.CostoNacCIGV.
        END.
        ELSE DO:
            Detalle.VtaxMesMn_ant = Detalle.VtaxMesMn_ant + VentasxProducto.ImpNacCIGV.
            Detalle.CtoxMesMn_ant = Detalle.CtoxMesMn_ant + VentasxProducto.CostoNacCIGV.
        END.
        /* Lo elimino */
        FIND art-esp WHERE art-esp.codmat = cCodMat USE-INDEX IdxKey01 NO-ERROR.
        IF AVAILABLE art-esp THEN DO:
            DELETE art-esp.
        END.
    END.
    ELSE DO:
        /* Especial */

        /* Solo aquellos que no esten trabajados en el calculo Standard */
        FIND Detalle WHERE detalle.codmat = cCodMat USE-INDEX IdxKey01 NO-ERROR.   
        IF NOT AVAILABLE detalle THEN DO:        
            /* Solo articulos nuevos */
            FIND art-esp WHERE art-esp.codmat = cCodMat AND art-esp.fching > dHasta NO-ERROR.
            IF AVAILABLE art-esp THEN DO:
                FIND Detalle-esp WHERE detalle-esp.codmat = cCodMat USE-INDEX IdxKey01 NO-ERROR.
                IF NOT AVAILABLE Detalle-esp THEN DO:

                    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                        almmmatg.codmat = cCodMat NO-LOCK NO-ERROR.

                    CREATE Detalle-esp.
                    ASSIGN detalle-esp.codmat = cCodmat
                        Detalle-esp.Producto = cProducto
                        Detalle-esp.Linea = cLinea
                        Detalle-esp.Sublinea = cSublinea
                        Detalle-esp.Marca = cMarca
                        Detalle-esp.Unidad = cUnidad
                        Detalle-esp.Licencia = cLicencia
                        Detalle-esp.tpoart = IF (AVAILABLE almmmatg) THEN almmmatg.tpoart ELSE "x".

                        xQArt = xQArt + 1. /* Especiales */

                END.
                ELSE lCalcula = YES.

                IF p-Llave = 'ACTUAL' THEN DO:
                    Detalle-esp.VtaxMesMn_act = Detalle-esp.VtaxMesMn_act + VentasxProducto.ImpNacCIGV.
                    Detalle-esp.CtoxMesMn_act = Detalle-esp.CtoxMesMn_act + VentasxProducto.CostoNacCIGV.
                END.
                ELSE DO:
                    Detalle-esp.VtaxMesMn_ant = Detalle-esp.VtaxMesMn_ant + VentasxProducto.ImpNacCIGV.
                    Detalle-esp.CtoxMesMn_ant = Detalle-esp.CtoxMesMn_ant + VentasxProducto.CostoNacCIGV.
                END.
                /* Lo Marco para eliminarlo */
                /*DELETE art-esp.*/
                ASSIGN art-esp.tpoart = 'D'.
            END.
        END.
    END.
END.

txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Proceso Concluidooo....'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pTotal_suma wWin 
PROCEDURE pTotal_suma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
DEFINE VAR lTotal AS DECIMAL.
DEFINE VAR lVenta AS DECIMAL.
DEFINE VAR lMargen AS DECIMAL.
DEFINE VAR lCreci AS DECIMAL.

lVenta = DECIMAL(pVenta:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
lMargen = DECIMAL(pMargen:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
lCreci = DECIMAL(pCreci:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  
ltotal = lVenta + lMargen + lCreci.
ASSIGN pTotal:SCREEN-VALUE = STRING(ltotal,"9999.99").
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-especiales wWin 
PROCEDURE ue-especiales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lxDesde AS DATE.
DEFINE VAR lxHasta AS DATE.
DEFINE VAR lxDesde_ant AS DATE.
DEFINE VAR lxHasta_ant AS DATE.

DEFINE VAR lYEAR AS INT.

/* Desde */
lxDesde = dDesde + 1.
lYear = YEAR(lxDesde).
IF ((lYear MODULO 4) = 0 AND (lYear MODULO 100) <> 0) OR (lyear MODULO 400)=0 THEN DO:
    /* Año bisiesto */
    lxDesde_ant = lxDesde - 366.
END.
ELSE DO:
    lxDesde_ant = lxDesde - 365.
END.

/* Hasta */
lxHasta = TODAY.  /* Hoy */
lxHasta = DATE(MONTH(lxHasta),1,YEAR(lxHasta)).  /* Primer dia del Mes actual */
lxHasta = lxHasta - 1. /* Ultimo dia del mes anterior */

lYear = YEAR(lxHasta).
IF ((lYear MODULO 4) = 0 AND (lYear MODULO 100) <> 0) OR (lyear MODULO 400)=0 THEN DO:
    /* Año bisiesto */
    lxHasta_ant = lxHasta - 366.
END.
ELSE DO:
    lxHasta_ant = lxHasta - 365.
END.

/*
lTpoConsumido = STRING(NOW).
SESSION:SET-WAIT-STATE('GENERAL').
*/

/* Rango de Fecha  */
RUN proc_movimientos (lxDesde, lxHasta, 'ACTUAL', YES).

/* Rango de Fecha Año anterior */
RUN proc_movimientos (lxDesde_ant, lxHasta_ant, 'ANTERIOR',YES).

/* Calcula factor de crecimiento */
RUN proc_detalle2 (YES).


FOR EACH art-esp :

    cCodMat = art-esp.codmat.

    IF art-esp.tpoart <> 'A' THEN DO:
        /* Si esta anulado */
        DELETE art-esp.
    END.
    ELSE DO:
        IF art-esp.fching <= dDesde THEN DO:
            ASSIGN art-esp.clasificacion = 'XF'.
        END.
        ELSE DO:
            /*------------------*/
            FIND Detalle WHERE detalle.codmat = cCodMat USE-INDEX IdxKey01 NO-ERROR.   
            IF NOT AVAILABLE detalle THEN DO:        
                FIND Detalle-esp WHERE detalle-esp.codmat = cCodMat USE-INDEX IdxKey01 NO-ERROR.
                IF NOT AVAILABLE Detalle-esp THEN DO:

                   FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                           almmmatg.codmat = cCodMat NO-LOCK NO-ERROR.

                    CREATE Detalle-esp.
                    ASSIGN detalle-esp.codmat = cCodmat
                        Detalle-esp.Producto = almmmatg.desmat
                        Detalle-esp.Linea = almmmatg.codfam
                        Detalle-esp.Sublinea = almmmatg.subfam
                        Detalle-esp.Marca = almmmatg.codmar
                        Detalle-esp.Unidad = ""
                        Detalle-esp.Licencia = ""
                        Detalle-esp.tpoart = IF (AVAILABLE almmmatg) THEN almmmatg.tpoart ELSE "x"
                        Detalle-esp.sumafactor = 0.

                        xQArt = xQArt + 1.  /* Cantidad de Articulos Especiales */
                END.
            END.
            /*-------------------*/
            /*ASSIGN art-esp.clasificacion = 'NF'.*/
            DELETE art-esp.            
        END.
    END.
END.

/* Calcula Factores segun MAXIMOS */
RUN proc_calc_factores (YES).

IF chk_saveranking = YES THEN DO:
    /*RUN proc_grabar_ranking (YES).*/
    RUN ue-grabar (YES).
END.

/*RUN proc_genexcel (YES). Obsoleto*/
/*RUN proc-gen-txt (YES). Solo para propositos de prueba*/

SESSION:SET-WAIT-STATE('').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar wWin 
PROCEDURE ue-grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-especial      AS LOG NO-UNDO.

/* Sin trigger */
DISABLE TRIGGERS FOR LOAD OF factabla.

IF p-especial = NO THEN DO:
    /* Blanqueo los estados anteriores  */
    FOR EACH almmmatg WHERE almmmatg.tpoart = 'A' AND LOOKUP (almmmatg.codfam, lFamiExo ) = 0 NO-LOCK:
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND factabla.tabla = ltabla AND
                                factabla.codigo = almmmatg.codmat EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE factabla THEN DO:
            CREATE factabla.
                ASSIGN factabla.codcia = s-codcia 
                        factabla.tabla = lTabla
                        factabla.codigo = almmmatg.codmat
                        factabla.nombre = STRING(NOW,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS").
        END.
        ASSIGN factabla.campo-c[lGrupo + lCampana] = IF (almmmatg.fching <= dHasta) THEN "XF" ELSE ""
                factabla.valor[lGrupo + lCampana] = 0.
    END.
    /*   */
    /* Standarrd */
    FOR EACH Detalle NO-LOCK :
    
        txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Guardando RANKING STANDARD..." + ' / ' + 
        detalle.codmat + ' ' + detalle.producto. 
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND factabla.tabla = ltabla AND
                                factabla.codigo = detalle.codmat EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE factabla THEN DO:
            CREATE factabla.
                ASSIGN factabla.codcia = s-codcia 
                        factabla.tabla = lTabla
                        factabla.codigo = detalle.codmat
                        factabla.nombre = STRING(NOW,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS").
        END.
        ASSIGN factabla.campo-c[lGrupo + lCampana] = Detalle.clasificacion
                factabla.valor[lGrupo + lCampana] = Detalle.iranking.
    END.
END.
ELSE DO:
    /* Especial */
    FOR EACH Detalle-esp NO-LOCK :
    
        txt-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Guardando RANKING ESPECIAL..." + ' / ' + 
        detalle-esp.codmat + ' ' + detalle-esp.producto. 
    
        FIND FIRST factabla WHERE factabla.codcia = s-codcia AND factabla.tabla = ltabla AND
                                factabla.codigo = detalle-esp.codmat EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE factabla THEN DO:
            CREATE factabla.
                ASSIGN factabla.codcia = s-codcia 
                        factabla.tabla = lTabla
                        factabla.codigo = detalle-esp.codmat
                        factabla.nombre = STRING(NOW,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS").
        END.
        ASSIGN factabla.campo-c[lGrupo + lCampana] = Detalle-esp.clasificacion
                factabla.valor[lGrupo + lCampana] = Detalle-esp.iranking.
    
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar wWin 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Reseteo variables Y FILES TEMPORALES */
/* Cantidad de Articulos Normales */
xQTotArt = 0.  
/* Utilex + institucionales */
lDivisiones = "00023,00027,00501,00502,00503,00504,00506,00507,00508,00024".    

IF lGrupo = 1 THEN lDivisiones = "*AAA*,*BBB*".      /* Todos o General*/

EMPTY TEMP-TABLE detalle.
EMPTY TEMP-TABLE Detalle-esp.
EMPTY TEMP-TABLE art-esp.

/* Tabla de Articulos */
FOR EACH almmmatg WHERE /*tpoart = 'A' AND */ almmmatg.codcia = s-codcia AND 
    LOOKUP (codfam, lFamiExo ) = 0 NO-LOCK:
    CREATE art-esp.
        ASSIGN art-esp.codmat = almmmatg.codmat
            art-esp.producto = almmmatg.desmat
            art-esp.tpoart = almmmatg.tpoart
            art-esp.fching = almmmatg.fching
            art-esp.clasificacion = ''.
END.

/* Rango de Fecha  */
RUN proc_movimientos (dDesde, dHasta, 'ACTUAL', NO).

/* Rango de Fecha Año anterior */
RUN proc_movimientos (dDesde_ant, dHasta_ant, 'ANTERIOR', NO).

/*  */
RUN pCalcula_F.

/* Calcula factor de crecimiento */
RUN proc_detalle2 (NO).

/* Calcula Factores segun MAXIMOS */
RUN proc_calc_factores (NO).

IF chk_saveranking = YES THEN DO:
    /*RUN proc_grabar_ranking  (NO).*/
    RUN ue-grabar (NO).
END.

/*RUN proc_genexcel (NO). Obsoleto*/
/*RUN proc-gen-txt (NO). solo para proposito de pruebas*/

/* Los Articulos ESPECIALES */

xQArt = 0.  /* Cantidad de Articulos Especiales */

RUN ue-especiales.
RUN proc-excel-resto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

