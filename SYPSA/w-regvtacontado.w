&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE t-wmigrv LIKE wmigrv.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

/*
    Modificó    : Miguel Landeo (ML01)
    Fecha       : 03/Oct/2009
    Objetivo    : Carga RUC de ccbcdocu.
*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
SESSION:DATE-FORMAT = "dmy".

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia  AS INTEGER.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR cl-codcia AS INTEGER.
DEFINE SHARED VAR s-nomcia  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.

DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR p-periodo AS INTE NO-UNDO.
DEFINE VAR p-mes     AS INTE NO-UNDO.
DEFINE VAR x-ctaigv  AS CHAR NO-UNDO.
DEFINE VAR x-ctadto  AS CHAR NO-UNDO.
DEFINE VAR x-ctaisc  AS CHAR NO-UNDO.
DEFINE VAR x-codope  AS CHAR NO-UNDO.
DEFINE VAR x-ctagan  AS CHAR NO-UNDO.
DEFINE VAR x-ctaper  AS CHAR NO-UNDO.
DEFINE VAR x-rndgan  AS CHAR NO-UNDO.
DEFINE VAR x-rndper  AS CHAR NO-UNDO.

DEFINE VAR FILL-IN-fchast AS DATE NO-UNDO.

/*ML01*/ DEFINE VARIABLE cRuc AS CHARACTER NO-UNDO.

/* DEFINE TEMP-TABLE T-CDOC LIKE CCBCDOCU      /* ARCHIVO DE TRABAJO */ */
/*     INDEX LLAVE01 CodDiv Cco NroDoc.                                 */
/*                                                                      */
/* DEFINE NEW SHARED TEMP-TABLE t-prev LIKE cb-dmov                     */
/*     FIELD fchast LIKE cb-cmov.fchast.                                */
/*                                                                      */
/* DEFINE BUFFER B-prev  FOR t-prev.                                    */
/* DEFINE BUFFER B-CDocu FOR CcbCDocu.                                  */
/* DEFINE BUFFER B-Docum FOR FacDocum.                                  */

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VARIABLE s-NroMesCie AS LOGICAL INITIAL YES.
DEFINE VAR X-nrodoc1 AS CHAR INITIAL '' NO-UNDO.
DEFINE VAR X-nrodoc2 AS CHAR INITIAL '' NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(50)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS x-Periodo x-NroMes f-Division B-filtro 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-NroMes f-Division ~
FILL-IN-fchast-1 FILL-IN-fchast-2 FILL-IN-Tpocmb FILL-IN-TcCompra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-regvtacontado AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-filtro 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Button 5" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON B-Transferir 
     IMAGE-UP FILE "img\climnu1":U
     LABEL "Transferir Asiento" 
     SIZE 6.43 BY 1.62.

DEFINE VARIABLE f-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE x-NroMes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS CHARACTER FORMAT "9999":U 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-fchast-1 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fchast-2 AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TcCompra AS DECIMAL FORMAT ">>9.999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-Tpocmb AS DECIMAL FORMAT ">>9.999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Periodo AT ROW 1.19 COL 9 COLON-ALIGNED
     x-NroMes AT ROW 2.15 COL 9 COLON-ALIGNED
     f-Division AT ROW 3.12 COL 9 COLON-ALIGNED
     FILL-IN-fchast-1 AT ROW 1.85 COL 22 COLON-ALIGNED NO-LABEL
     FILL-IN-fchast-2 AT ROW 1.85 COL 34 COLON-ALIGNED NO-LABEL
     FILL-IN-Tpocmb AT ROW 3.27 COL 22 COLON-ALIGNED NO-LABEL
     FILL-IN-TcCompra AT ROW 3.27 COL 34.43 COLON-ALIGNED NO-LABEL
     B-filtro AT ROW 2.35 COL 112.57
     B-Transferir AT ROW 2.35 COL 120.72
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 3.92 COL 121.14
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4 COL 112
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.46 COL 121.72
     " REGISTRO  DE  VENTAS CONTADO MENSUAL" VIEW-AS TEXT
          SIZE 45 BY .85 AT ROW 1.27 COL 48
          FONT 12
     "Fecha de Proceso" VIEW-AS TEXT
          SIZE 13.43 BY .5 AT ROW 1.27 COL 28
     "T.C.Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.81 COL 24.57
     "T.C.Compra" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.81 COL 36.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-wmigrv T "NEW SHARED" ? INTEGRAL wmigrv
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Generacion de Asiento Contable Mensual por Centro de Costo"
         HEIGHT             = 14.23
         WIDTH              = 144
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 144
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 144
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON B-Transferir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-fchast-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-fchast-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TcCompra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Tpocmb IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de Asiento Contable Mensual por Centro de Costo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Asiento Contable Mensual por Centro de Costo */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-filtro W-Win
ON CHOOSE OF B-filtro IN FRAME F-Main /* Button 5 */
DO:
  ASSIGN
     FILL-IN-fchast-1 FILL-IN-fchast-2 
     FILL-IN-Tpocmb FILL-IN-TcCompra 
     F-Division x-Periodo x-NroMes.

  IF FILL-IN-tpocmb = 0 THEN DO:
     MESSAGE 'Tipo de cambio no registrado' VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO FILL-IN-tpocmb.
  END.

/*   FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND                   */
/*                      cb-peri.Periodo = YEAR(FILL-IN-fchast-1) NO-LOCK. */
/*   IF AVAILABLE cb-peri THEN                                            */
/*      s-NroMesCie = cb-peri.MesCie[MONTH(FILL-IN-fchast-1) + 1].        */
/*                                                                        */
/*   IF s-NroMesCie THEN DO:                                              */
/*      MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX WARNING.            */
/*   END.                                                                 */

  RUN Carga-Temporal.
  B-Transferir:SENSITIVE = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Transferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Transferir W-Win
ON CHOOSE OF B-Transferir IN FRAME F-Main /* Transferir Asiento */
DO:
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").  
  /* BLOQUEAMOS Sí o Sí el correlativo */
  REPEAT:
      FIND wmigcorr WHERE wmigcorr.Proceso = "RV"
          AND wmigcorr.Periodo = INTEGER(x-Periodo)
          AND wmigcorr.Mes = INTEGER(x-NroMes)
          EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE wmigcorr THEN DO:
          IF NOT LOCKED wmigcorr THEN DO:
              /* CREAMOS EL CONTROL */
              CREATE wmigcorr.
              ASSIGN
                  wmigcorr.Correlativo = 1
                  wmigcorr.Periodo = INTEGER(x-Periodo)
                  wmigcorr.Mes = INTEGER(x-NroMes)
                  wmigcorr.Proceso = "RV".
              LEAVE.
          END.
          ELSE UNDO, RETRY.
      END.
      LEAVE.
  END.
  FOR EACH T-WMIGRV NO-LOCK:
      CREATE WMIGRV.
      BUFFER-COPY T-WMIGRV
          TO WMIGRV
          ASSIGN
          wmigrv.FlagFecha = DATETIME(TODAY, MTIME)
          wmigrv.FlagTipo = "I"
          wmigrv.FlagUsuario = s-user-id
          wmigrv.wcorre = STRING(wmigcorr.Periodo, '9999') + STRING(wmigcorr.Mes, '99') + 
                          STRING(wmigcorr.Correlativo, '9999')
          wmigrv.wsecue = 0001
          wmigrv.wvejer = INTEGER(x-Periodo)
          wmigrv.wvperi = INTEGER(x-NroMes).
  END.
  IF AVAILABLE(wmigcorr) THEN RELEASE wmigcorr.
  IF AVAILABLE(wmigrv)   THEN RELEASE wmigrv.
  EMPTY TEMP-TABLE T-WMIGRV.
  RUN dispatch IN h_b-regvtacontado ('open-query':U).
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-fchast-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fchast-1 W-Win
ON LEAVE OF FILL-IN-fchast-1 IN FRAME F-Main
DO:
  ASSIGN
     FILL-IN-fchast-1.
  p-periodo = YEAR(FILL-IN-fchast-1).
  p-mes     = MONTH(FILL-IN-fchast-1).
  FIND gn-tcmb WHERE gn-tcmb.fecha = FILL-IN-fchast-1 NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO:
     FILL-IN-tpocmb:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(gn-tcmb.venta, '999.999').
     FILL-IN-TcCompra:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(gn-tcmb.compra, '999.999').
  END.
/*  ELSE do: 
 *   message "No se ha registrado el tipo de cambio "  skip
 *           "para la fecha ingresada (" FILL-IN-fchast ")" view-as alert-box.
 *   APPLY 'ENTRY':U TO FILL-IN-fchast.
 *   return no-apply.
 *   end.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroMes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroMes W-Win
ON VALUE-CHANGED OF x-NroMes IN FRAME F-Main /* Mes */
DO:
  ASSIGN {&SELF-NAME}.
  RUN src/bin/_dateif(x-NroMes,x-Periodo, OUTPUT FILL-IN-fchast-1, OUTPUT FILL-IN-fchast-2).
  DISPLAY 
    FILL-IN-fchast-1 FILL-IN-fchast-2
    WITH FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO FILL-IN-fchast-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Periodo W-Win
ON VALUE-CHANGED OF x-Periodo IN FRAME F-Main /* Periodo */
DO:
  ASSIGN {&SELF-NAME}.
  RUN src/bin/_dateif(x-NroMes,x-Periodo, OUTPUT FILL-IN-fchast-1, OUTPUT FILL-IN-fchast-2).
  DISPLAY 
    FILL-IN-fchast-1 FILL-IN-fchast-2
    WITH FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO FILL-IN-fchast-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-flag W-Win 
PROCEDURE Actualiza-flag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* FOR EACH CcbCDocu WHERE CcbCDocu.codcia = s-codcia AND      */
/*                         CcbCDocu.Coddiv = F-DIVISION AND    */
/*                         CcbCDocu.CodDoc = t-prev.Coddoc AND */
/*                         CcbCDocu.Nrodoc = t-prev.Nrodoc AND */
/*                         CcbCdocu.FchDoc = t-prev.fchdoc:    */
/*        ASSIGN                                               */
/*           CcbCDocu.NroMes = Cb-Cmov.Nromes                  */
/*           CcbCDocu.Codope = Cb-Cmov.Codope                  */
/*           CcbCDocu.Nroast = Cb-Cmov.Nroast                  */
/*           CcbCDocu.FchCbd = TODAY                           */
/*           CcbCDocu.FlgCbd = TRUE.                           */
/*        RELEASE CcbCDocu.                                    */
/* END.                                                        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
             INPUT  'aplic/sypsa/b-regvtacontado.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-regvtacontado ).
       RUN set-position IN h_b-regvtacontado ( 5.04 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-regvtacontado ( 9.69 , 140.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-regvtacontado ,
             x-Periodo:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-FAC-BOL W-Win 
PROCEDURE Carga-FAC-BOL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-codcta AS CHAR.
DEF VAR x-codigv AS CHAR.
DEF VAR x-ctadto AS CHAR.
DEF VAR x-ctaisc AS CHAR.
DEF VAR x-ctaigv AS CHAR.
DEF VAR x-fchvto AS DATE.
DEF VAR x-coddoc AS CHAR.
DEF VAR x-nrodoc AS CHAR.
DEF VAR x-codcli AS CHAR.
DEF VAR x-codmon AS INT.
DEF VAR x-fchdoc AS INT.

DEFINE VAR x-detalle AS LOGICAL NO-UNDO.
DEFINE VAR x-cco     AS CHAR    NO-UNDO.

/* CARGAMOS LA INFORMACION EN EL TEMPORAL */
FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia 
    AND cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfgg THEN RETURN.

FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.codcia = s-codcia 
    AND CcbCDocu.Coddiv = f-Division 
    AND CcbCDocu.Tipo = "MOSTRADOR"
    AND CcbCDocu.FchDoc = FILL-IN-fchast 
    AND CcbCDocu.CodDoc = FacDocum.CodDoc:
    /* PARCHE: Boletas anuladas NO deben pasar */
    IF LOOKUP(Ccbcdocu.coddoc, 'BOL,TCK') > 0 AND Ccbcdocu.flgest = 'A' THEN NEXT.
    /* *************************************** */
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ccbcdocu.codcli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN RETURN.
    FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.coddep
        AND TabDistr.CodProvi = gn-clie.codprov
        AND TabDistr.CodDistr = gn-clie.coddist
        NO-LOCK NO-ERROR.
    FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = Ccbcdocu.Codcia 
        AND Cb-cfgrv.CodDiv = Ccbcdocu.Coddiv 
        AND Cb-cfgrv.Coddoc = Ccbcdocu.Coddoc 
        AND Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo 
        AND Cb-cfgrv.Codmon = Ccbcdocu.Codmon 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" 
        THEN ASSIGN
                x-detalle = YES
                x-codcta = (IF ccbcdocu.codmon = 1 THEN FacDocum.CodCta[1] ELSE FacDocum.CodCta[2]).
        ELSE ASSIGN
                x-detalle = Cb-cfgrv.Detalle
                x-codcta = Cb-cfgrv.codcta.
    ASSIGN
        x-ctaisc = cb-cfgg.codcta[2] 
        x-ctaigv = cb-cfgg.codcta[3]
        x-ctadto = cb-cfgg.codcta[10]
        x-fchvto = (IF ccbcdocu.fchvto < ccbcdocu.fchdoc THEN ccbcdocu.fchdoc ELSE ccbcdocu.fchvto)
        x-coddoc = Ccbcdocu.coddoc
        x-nrodoc = Ccbcdocu.nrodoc
        x-codcli = Ccbcdocu.codcli
        x-codmon = (IF ccbcdocu.codmon = 1 THEN 00 ELSE 01)
        x-fchdoc = YEAR(ccbcdocu.fchdoc) * 10000 + MONTH(ccbcdocu.fchdoc) * 100 + DAY(ccbcdocu.fchdoc).
    CASE ccbcdocu.coddoc:
        WHEN 'FAC' THEN x-coddoc = "FC".
        WHEN 'BOL' THEN x-coddoc = "BV".
        WHEN 'TCK' THEN x-coddoc = "TK".
        WHEN 'LET' THEN x-coddoc = "LT".
        WHEN 'N/C' THEN x-coddoc = "NC".
        WHEN 'N/D' THEN x-coddoc = "ND".
        WHEN 'CHQ' THEN x-coddoc = "CD".
    END CASE.
    IF x-Detalle = NO THEN DO:
        /* UN SOLO NUMERO DE DOCUMENTO (SIN DETALLE) */
        ASSIGN
            X-NRODOC = SUBSTRING(Ccbcdocu.Nrodoc,1,3) + "111111"
            X-CODCLI = '1111111111'.
    END.
    ELSE DO:
        x-codcli = (IF gn-clie.codant = '' THEN SUBSTRING(gn-clie.codcli,1,10) ELSE gn-clie.codant).
    END.
    IF Ccbcdocu.FlgEst = "A" THEN x-codcta = (IF Ccbcdocu.Coddoc = "FAC" THEN "12122100" ELSE "12121140").

    FIND T-WMIGRV WHERE T-WMIGRV.wvtdoc = x-coddoc
        AND T-WMIGRV.wvndoc = x-nrodoc
        AND T-WMIGRV.wvmone = x-codmon
        AND T-WMIGRV.wvcpvt = x-codcta
        AND T-WMIGRV.wvfech = x-FchDoc
        NO-ERROR.
    IF NOT AVAILABLE T-WMIGRV THEN CREATE T-WMIGRV.
    ASSIGN
        T-WMIGRV.FlagTipo = "I"
        T-WMIGRV.FlagUsuario = s-user-id.
    ASSIGN
        T-WMIGRV.wsecue = 0001
        T-WMIGRV.wvejer = YEAR(ccbcdocu.fchdoc)
        T-WMIGRV.wvperi = MONTH(ccbcdocu.fchdoc)
        T-WMIGRV.wvtdoc = x-CodDoc
        T-WMIGRV.wvndoc = x-NroDoc
        T-WMIGRV.wvfech = x-FchDoc
        T-WMIGRV.wvccli = x-codcli
        T-WMIGRV.wvclie = SUBSTRING (gn-clie.nomcli, 1, 40)
        T-WMIGRV.wvcdir = (IF gn-clie.dircli <> '' THEN SUBSTRING (gn-clie.dircli, 1, 40) ELSE 'LIMA')
        T-WMIGRV.wvcdis = (IF AVAILABLE TabDistr THEN SUBSTRING (TabDistr.NomDistr, 1, 40) ELSE 'LIMA')
        T-WMIGRV.wvref3 = (IF ccbcdocu.codcli BEGINS '2' THEN "PJ" ELSE "NI")
        T-WMIGRV.wvtido = (IF ccbcdocu.codcli BEGINS '2' THEN "RU" ELSE "")
        T-WMIGRV.wvnudo = (IF ccbcdocu.codcli BEGINS '2' THEN gn-clie.ruc ELSE SUBSTRING(gn-clie.codcli, 3, 8))
        T-WMIGRV.wvmone = x-codmon
        T-WMIGRV.wvtcam = 0.00.            /* ccbcdocu.tpocmb. */
    IF Ccbcdocu.flgest = "A" THEN DO:       /* ANULADO */
/*         ASSIGN                                                                */
/*             T-WMIGRV.wvpvta = 0.00                                            */
/*             T-WMIGRV.wvcpvt = x-codcta                                        */
/*             T-WMIGRV.wvmpvt = (IF ccbcdocu.coddoc = "N/C" THEN "A" ELSE "C"). */
        ASSIGN
            T-WMIGRV.wvfepr = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY)
            T-WMIGRV.wvfeve = YEAR(x-fchvto) * 10000 + MONTH(x-fchvto) * 100 + DAY(x-fchvto)
            T-WMIGRV.wvruc = ccbcdocu.ruccli
            T-WMIGRV.wvndom = (IF T-WMIGRV.wvruc = '' THEN "N" ELSE (IF T-WMIGRV.wvref3 = "PJ" THEN "S" ELSE "N"))
            T-WMIGRV.wvcpag = ccbcdocu.fmapgo
            T-WMIGRV.wvsitu = "99"        /* ANULADO */
            T-WMIGRV.wvcost = "9999999"
            T-WMIGRV.wvcven = ccbcdocu.codven
            T-WMIGRV.wvacti = ccbcdocu.coddiv
            T-WMIGRV.wvnbco = ''  /* ver ticketeras */
            T-WMIGRV.wvusin = ccbcdocu.usuario
            T-WMIGRV.wvfein = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY).
        NEXT.
    END.
    IF ccbcdocu.impbrt > 0 
        THEN ASSIGN
                T-WMIGRV.wvvalv = T-WMIGRV.wvvalv + CcbCDocu.ImpBrt
                T-WMIGRV.wvcval = cb-cfgg.codcta[5]
                T-WMIGRV.wvmval = (IF ccbcdocu.coddoc = "N/C" THEN "C" ELSE "A").
    IF ccbcdocu.impexo > 0 
        THEN ASSIGN
                T-WMIGRV.wvvali = T-WMIGRV.wvvali + ccbcdocu.impexo
                T-WMIGRV.wvcvai = cb-cfgg.codcta[6]
                T-WMIGRV.wvmvai = ( IF ccbcdocu.coddoc = "N/C" THEN "C" ELSE "A" ).
    IF ccbcdocu.impdto > 0 
        THEN ASSIGN
                T-WMIGRV.wvdsct = T-WMIGRV.wvdsct + ccbcdocu.impdto
                T-WMIGRV.wvcdsc = x-ctadto
                T-WMIGRV.wvmdsc = (IF ccbcdocu.coddoc = "N/C" THEN "A" ELSE "C").
    IF ccbcdocu.impigv > 0 
        THEN ASSIGN
                T-WMIGRV.wvigv = T-WMIGRV.wvigv + ccbcdocu.impigv
                T-WMIGRV.wvcigv = x-ctaigv
                T-WMIGRV.wvmigv = (IF ccbcdocu.coddoc = "N/C" THEN "C" ELSE "A").
    ASSIGN
        T-WMIGRV.wvpvta = T-WMIGRV.wvpvta + ccbcdocu.imptot
        T-WMIGRV.wvcpvt = x-codcta
        T-WMIGRV.wvmpvt = (IF ccbcdocu.coddoc = "N/C" THEN "A" ELSE "C").
    IF ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D' THEN DO:
        CASE ccbcdocu.codref:
            WHEN 'FAC' THEN T-WMIGRV.wvtref = "FC".
            WHEN 'BOL' THEN T-WMIGRV.wvtref = "BV".
            WHEN 'TCK' THEN T-WMIGRV.wvtref = "TK".
            WHEN 'LET' THEN T-WMIGRV.wvtref = "LT".
            WHEN 'N/C' THEN T-WMIGRV.wvtref = "NC".
            WHEN 'N/D' THEN T-WMIGRV.wvtref = "ND".
            WHEN 'CHQ' THEN T-WMIGRV.wvtref = "CD".
        END CASE.
        ASSIGN
            T-WMIGRV.wvnref = ccbcdocu.nroref.
    END.
    ELSE DO:
        IF Ccbcdocu.codped = "PED" 
            THEN ASSIGN
                    T-WMIGRV.wvtref = "PD"
                    T-WMIGRV.wvnref = Ccbcdocu.nroped.
    END.
    ASSIGN
        T-WMIGRV.wvfepr = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY)
        T-WMIGRV.wvfeve = YEAR(x-fchvto) * 10000 + MONTH(x-fchvto) * 100 + DAY(x-fchvto)
        T-WMIGRV.wvruc = ccbcdocu.ruccli
        T-WMIGRV.wvndom = (IF T-WMIGRV.wvruc = '' THEN "N" ELSE (IF T-WMIGRV.wvref3 = "PJ" THEN "S" ELSE "N"))
        T-WMIGRV.wvcpag = ccbcdocu.fmapgo
        T-WMIGRV.wvsitu = "01"        /* NO Graba en Cuentas por Cobrar */
        T-WMIGRV.wvcost = "9999999"
        T-WMIGRV.wvcven = ccbcdocu.codven
        T-WMIGRV.wvacti = ccbcdocu.coddiv
        T-WMIGRV.wvnbco = ''  /* ver ticketeras */
        T-WMIGRV.wvusin = ccbcdocu.usuario
        T-WMIGRV.wvfein = YEAR(TODAY) * 10000 + MONTH(TODAY) * 100 + DAY(TODAY).
END.    

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

FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia 
    AND cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfgg THEN DO:
    MESSAGE 'NO está configurado R02' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

EMPTY TEMP-TABLE t-wmigrv.
/* POR TODO EL MES */
FOR EACH FacDocum NO-LOCK WHERE FacDocum.CodCia = s-codcia 
    AND LOOKUP(FacDocum.CodDoc, 'FAC,BOL,TCK') > 0:
    IF FacDocum.CodCta[1] = '' THEN DO:
       MESSAGE 'Cuenta contable de ' + FacDocum.Coddoc + ' no configurada' VIEW-AS ALERT-BOX.
       NEXT.
    END.
    DO FILL-IN-fchast = FILL-IN-fchast-1 TO FILL-IN-fchast-2:
        RUN Carga-Fac-Bol.
    END.
END.
HIDE FRAME F-Proceso.

RUN dispatch IN h_b-regvtacontado ('open-query':U).
RUN Totales  IN h_b-regvtacontado.

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
  DISPLAY x-Periodo x-NroMes f-Division FILL-IN-fchast-1 FILL-IN-fchast-2 
          FILL-IN-Tpocmb FILL-IN-TcCompra 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Periodo x-NroMes f-Division B-filtro 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  x-NroMes  = STRING(MONTH(TODAY), '99').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'RND' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN
     ASSIGN
        x-rndgan = cb-cfgg.codcta[1] 
        x-rndper = cb-cfgg.codcta[2].
  ELSE DO:
     MESSAGE 'Configuracion de Cuentas de Redondeo no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'C01' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN
     ASSIGN
        x-ctagan = cb-cfgg.codcta[1] 
        x-ctaper = cb-cfgg.codcta[2].
  ELSE DO:
     MESSAGE 'Configuracion de Cuentas de Redondeo no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.
  
  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN DO:
     ASSIGN
        x-ctaisc = cb-cfgg.codcta[2] 
        x-ctaigv = cb-cfgg.codcta[3]
        x-ctadto = cb-cfgg.codcta[10]
        x-codope = cb-cfgg.Codope.
     END.
  ELSE DO:
     MESSAGE 'Configuracion de Registro de Ventas no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

  FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.

  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Cb-Peri NO-LOCK WHERE Cb-peri.codcia = s-codcia:
        x-Periodo:ADD-LAST(STRING(Cb-peri.periodo)).
    END.
    x-Periodo = STRING(YEAR(TODAY), '9999').
    FOR EACH Gn-Divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
        f-Division:ADD-LAST(Gn-divi.coddiv).
    END.
    F-DIVISION = S-CODDIV.
    RUN src/bin/_dateif(x-NroMes,x-Periodo, OUTPUT FILL-IN-fchast-1, OUTPUT FILL-IN-fchast-2).
    DISPLAY 
        F-DIVISION
        x-Periodo
        FILL-IN-fchast-1 FILL-IN-fchast-2.
    APPLY 'LEAVE':U TO FILL-IN-fchast-1.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pre-impresion W-Win 
PROCEDURE Pre-impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN Imprimir.
        PAGE.
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/D-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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

