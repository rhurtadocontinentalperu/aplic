&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
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

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/*{bin/s-global.i}*/
{cbd/cbglobal.i}
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.



/* Definiendo Tablas Temporales                                         */

DEFINE TEMP-TABLE Temporal
       FIELD CodDiv AS CHARACTER
       FIELD CtaPas AS CHARACTER
       FIELD CtaAct AS CHARACTER
       FIELD SdoPas AS DECIMAL
       FIELD SdoAct AS DECIMAL
       INDEX IDX01 CodDiv.

DEFINE BUFFER DETALLE FOR cb-dmov.
DEFINE BUFFER CUENTAS FOR cb-ctas.

/* Local Variable Definitions ---                                       */

DEF VAR XsCodCta-67 AS CHAR.
DEF VAR XsCodCta-77 AS CHAR.
DEF VAR XsCodCta-79 AS CHAR.
DEF VAR XsCodAux-67 AS CHAR.
DEF VAR XsCodAux-77 AS CHAR.
DEF VAR XsCodCco-67 AS CHAR.
DEF VAR XsCodCco-77 AS CHAR.


DEF VAR XsCodOpe    AS CHAR.
DEF VAR XsNroAst    AS CHAR INITIAL "000002".
DEF VAR Xftpocmb   LIKE cb-dmov.tpocmb.

DEF VAR x-msg1 AS CHAR FORMAT "X(35)".
DEF VAR x-msg2 AS CHAR FORMAT "X(35)".
DEF VAR x-msg3 AS CHAR FORMAT "X(35)".
DEF VAR x-msg4 AS CHAR FORMAT "X(35)".

DEFINE FRAME F-MENSAJE 
       x-msg1 NO-LABEL  SKIP
       x-msg2 NO-LABEL  SKIP
       x-msg3 NO-LABEL  SKIP
       x-msg4 NO-LABEL 
       WITH CENTERED
       TITLE "Espere un Momento por Favor" 
       VIEW-AS DIALOG-BOX KEEP-TAB-ORDER  
       SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
       BGCOLOR 15 FGCOLOR 0.  
             
DEF VAR  XfImpMn1  AS DECIMAL INITIAL 0.
DEF VAR  XfImpMn2  AS DECIMAL INITIAL 0.
DEF VAR  XfSdoMn1  AS DECIMAL INITIAL 0.
DEF VAR  XfSdoMn2  AS DECIMAL INITIAL 0.
DEF VAR  XfSdoAct  AS DECIMAL INITIAL 0.
DEF VAR  XfSdoPas  AS DECIMAL INITIAL 0.
DEF VAR  XiNroItm  AS INTEGER INITIAL 0.
DEF VAR  XoCodMon  AS INTEGER INITIAL 1.
         
DEF VAR  x-CodCta  LIKE cb-dmov.CodCta.
DEF VAR  x-ClfAux  LIKE cb-dmov.clfaux.
DEF VAR  x-CodAux  LIKE cb-dmov.codaux.
DEF VAR  x-CodDoc  LIKE cb-dmov.coddoc.
DEF VAR  x-NroDoc  LIKE cb-dmov.nrodoc.
DEF VAR  x-NroRef  LIKE cb-dmov.nroref.
DEF VAR  x-FchDoc  LIKE cb-dmov.fchdoc.
DEF VAR  x-FchVto  LIKE cb-dmov.fchvto.
DEF VAR  x-TpoItm  LIKE cb-dmov.TpoItm.
DEF VAR  x-CodDiv  LIKE cb-dmov.Coddiv.
DEF VAR  x-Cco     LIKE cb-dmov.Cco.
DEF VAR  x-TpoMov  AS LOGICAL.
DEF VAR  x-GloDoc  AS CHAR.
DEF VAR  x-CodMon  AS INTEGER INITIAL 2.
DEF VAR  x-TpoCmb  AS DECIMAL.
DEF VAR  x-ImpMn1  AS DECIMAL.
DEF VAR  x-ImpMn2  AS DECIMAL.
DEF VAR  x-NroItm  AS INTEGER INITIAL 1.

/****CONFIGURACION DE VARIABLES******/

/*
IF S-NROMES = 0 THEN DO:
   MESSAGE "En el mes de apertura no existe " skip
           "diferencia de cambio"
  VIEW-AS ALERT-BOX INFORMA.
  RETURN.         
END.
*/

cb-codcia = 0.
FIND EMPRESAS WHERE EMPRESAS.CodCia = s-codcia NO-LOCK .
IF EMPRESAS.Campo-CodCbd = FALSE THEN cb-codcia = s-codcia.
FIND CB-PERI WHERE CB-PERI.CODCIA  = S-CODCIA AND
                   CB-PERI.PERIODO = S-PERIODO
                   NO-LOCK .
IF CB-PERI.mescie[S-NROMES + 1 ] THEN DO:
   MESSAGE "...Mes cerrado..."
   VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.                   


FIND CB-CFGG WHERE cb-cfgg.CodCia = cb-codcia AND 
                   cb-cfgg.CodCfg = "C02" NO-LOCK NO-ERROR.
IF NOT AVAIL CB-CFGG THEN DO:
   MESSAGE "No Configurado el proceso " SKIP
           "de Traslación" 
           VIEW-AS ALERT-BOX ERROR.
   RETURN.        
END.                   

XsCodCta-67 = cb-cfgg.CodCta[1] .
XsCodCta-77 = cb-cfgg.CodCta[2] . 
XsCodCta-79 = cb-cfgg.CodCta[3].
XsCodAux-67 = cb-cfgg.CodAux[1] .
XsCodAux-77 = cb-cfgg.CodAux[2] .
XsCodCco-67 = cb-cfgg.Cco[1] .
XsCodCco-77 = cb-cfgg.CCo[2] .

XsCodOpe    = cb-cfgg.CodOpe.

FIND FIRST cb-cmov WHERE cb-cmov.CODCIA   = s-codcia AND
                         cb-cmov.PERIODO  = s-periodo    AND
                         cb-cmov.NROMES   = s-NroMes
                         NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cmov THEN DO:
   MESSAGE "No Existen Movimientos " SKIP
           "en este Mes" 
           VIEW-AS ALERT-BOX ERROR.
   RETURN.        
END.

FIND cb-cfga WHERE cb-cfga.CODCIA = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfga THEN DO:
             MESSAGE "No existe configuraci¢n Principal" SKIP
                          "del Sistema (Plan de Cuentas)"
             VIEW-AS ALERT-BOX ERROR.
             RETURN.
             END.

DEFINE VAR u-dia-mes AS DATE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Empresas Cb-cmov Cb-cfgG

/* Definitions for FRAME F-Main                                         */
&Scoped-define FIELDS-IN-QUERY-F-Main cb-cfgg.Codope cb-cfgg.codcta[1] ~
cb-cfgg.codaux[1] cb-cfgg.codcta[3] cb-cfgg.codcta[2] cb-cfgg.codaux[2] 
&Scoped-define QUERY-STRING-F-Main FOR EACH Empresas SHARE-LOCK, ~
      EACH Cb-cmov WHERE TRUE /* Join to Empresas incomplete */ SHARE-LOCK, ~
      EACH Cb-cfgG WHERE Cb-cfgG.CodCia = cb-codcia ~
  AND Cb-cfgG.Codcfg = "C02" SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH Empresas SHARE-LOCK, ~
      EACH Cb-cmov WHERE TRUE /* Join to Empresas incomplete */ SHARE-LOCK, ~
      EACH Cb-cfgG WHERE Cb-cfgG.CodCia = cb-codcia ~
  AND Cb-cfgG.Codcfg = "C02" SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main Empresas Cb-cmov Cb-cfgG
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main Empresas
&Scoped-define SECOND-TABLE-IN-QUERY-F-Main Cb-cmov
&Scoped-define THIRD-TABLE-IN-QUERY-F-Main Cb-cfgG


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-14 F-CodDiv XfTC-Cmp XfTC-Vta B-ACEPTAR ~
B-Cancelar 
&Scoped-Define DISPLAYED-FIELDS cb-cfgg.Codope cb-cfgg.codcta[1] ~
cb-cfgg.codaux[1] cb-cfgg.codcta[3] cb-cfgg.codcta[2] cb-cfgg.codaux[2] 
&Scoped-define DISPLAYED-TABLES cb-cfgg
&Scoped-define FIRST-DISPLAYED-TABLE cb-cfgg
&Scoped-Define DISPLAYED-OBJECTS f-NomCia f-Periodo F-Nromes F-CodDiv ~
EDITOR-1 XfTC-Cmp XfTC-Vta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-ACEPTAR AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 13 BY 1.69.

DEFINE BUTTON B-Cancelar AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 13 BY 1.69.

DEFINE VARIABLE EDITOR-1 AS CHARACTER INITIAL "Este Proceso tiene por finalidad  Generar   Automaticamente un Asiento Mensual de Diferencia de Cambio.   Ajusta los Saldos de las Cuentas de Caja Bancos en D¢lares y Todos los Saldos de los Documentos en D¢lares de las Cuentas Corrientes." 
     VIEW-AS EDITOR
     SIZE 63.14 BY 2.04
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Divisionaria" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .69 NO-UNDO.

DEFINE VARIABLE f-NomCia AS CHARACTER FORMAT "x(40)" 
     LABEL "Descripci¢n" 
     VIEW-AS FILL-IN 
     SIZE 55.43 BY .69
     BGCOLOR 8 FGCOLOR 0 .

DEFINE VARIABLE F-Nromes AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Mes Contable" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69
     BGCOLOR 7 .

DEFINE VARIABLE f-Periodo AS INTEGER FORMAT "->>>9" INITIAL 0 
     LABEL "Periodo Contable" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .69
     BGCOLOR 7 .

DEFINE VARIABLE XfTC-Cmp AS DECIMAL FORMAT "ZZZZ9.9999":U INITIAL 0 
     LABEL "Compra" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE XfTC-Vta AS DECIMAL FORMAT "ZZZZ9.9999":U INITIAL 0 
     LABEL "Venta" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.14 BY 3.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      Empresas, 
      Cb-cmov, 
      Cb-cfgG SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-NomCia AT ROW 1.23 COL 1 HELP
          "Nombre/Raz½n Social de la Empresa"
     f-Periodo AT ROW 2.35 COL 12.43 COLON-ALIGNED
     F-Nromes AT ROW 2.35 COL 31.29 COLON-ALIGNED HELP
          "Ingrese el Mes Contable"
     F-CodDiv AT ROW 2.35 COL 54 COLON-ALIGNED
     EDITOR-1 AT ROW 3.27 COL 2 NO-LABEL
     cb-cfgg.Codope AT ROW 5.62 COL 15.29 COLON-ALIGNED HELP
          "Codigo de la Operacion"
          LABEL "Operaci¢n" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
          BGCOLOR 7 
     cb-cfgg.codcta[1] AT ROW 6.62 COL 15.29 COLON-ALIGNED HELP
          ""
          LABEL "Cuenta Perdida D.C" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
          BGCOLOR 7 
     cb-cfgg.codaux[1] AT ROW 6.62 COL 26 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
          BGCOLOR 7 
     cb-cfgg.codcta[3] AT ROW 6.62 COL 36.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
          BGCOLOR 7 
     XfTC-Cmp AT ROW 6.62 COL 52.72 COLON-ALIGNED
     cb-cfgg.codcta[2] AT ROW 7.62 COL 15.29 COLON-ALIGNED HELP
          ""
          LABEL "Cuenta Ganacia D.C" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
          BGCOLOR 7 
     cb-cfgg.codaux[2] AT ROW 7.62 COL 26 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .69
          BGCOLOR 7 
     XfTC-Vta AT ROW 7.62 COL 52.86 COLON-ALIGNED
     B-ACEPTAR AT ROW 9.12 COL 17
     B-Cancelar AT ROW 9.12 COL 36.86
     "TIPO DE CAMBIO" VIEW-AS TEXT
          SIZE 13.14 BY .54 AT ROW 5.62 COL 48.86
     RECT-14 AT ROW 5.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.46
         FONT 4.


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
         TITLE              = "Ajuste por Traslación"
         HEIGHT             = 10.04
         WIDTH              = 65
         MAX-HEIGHT         = 17.69
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17.69
         VIRTUAL-WIDTH      = 91.43
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
/* SETTINGS FOR FILL-IN cb-cfgg.codaux[1] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codaux[2] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[1] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[2] IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[3] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.Codope IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN f-NomCia IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-Nromes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Periodo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "integral.Empresas,integral.Cb-cmov WHERE integral.Empresas ...,integral.Cb-cfgG WHERE integral.Empresas ..."
     _JoinCode[3]      = "integral.Cb-cfgG.CodCia = cb-codcia
  AND integral.Cb-cfgG.Codcfg = ""C02"""
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ajuste por Traslación */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ajuste por Traslación */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-ACEPTAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ACEPTAR W-Win
ON CHOOSE OF B-ACEPTAR IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN XfTC-Cmp XfTC-Vta F-CodDiv.
  IF XfTC-Cmp = 0 OR XfTC-Vta = 0 THEN DO:
     MESSAGE "Tipo de Cambio de Ajuste no " SKIP
             "no puede ser Cero (0)"
             VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO XfTC-Vta.
     RETURN NO-APPLY.        
  END.
  RUN PROCESO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Cancelar W-Win
ON CHOOSE OF B-Cancelar IN FRAME F-Main /* Cancelar */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Ajuste W-Win 
PROCEDURE Calcula-Ajuste :
/*------------------------------------------------------------------------------
  Purpose: CALCULA EL AJUSTE DE CUENTAS SIN AUXILIAR
  Parameters:  <none>
  Notes:WRC      
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-CodCta  AS CHARACTER.
  
  /* VARIABLES DEL PROCEDIMIENTO */
  DEFINE VAR x-DbeSol AS DECIMAL.
  DEFINE VAR x-HbeSol AS DECIMAL.
  DEFINE VAR x-DbeDol AS DECIMAL.
  DEFINE VAR x-HbeDol AS DECIMAL.
  DEFINE VAR x-Saldo  AS DECIMAL.
  DEFINE VAR x-SdoAjt AS DECIMAL.
  DEFINE VAR l-MonCta AS INTEGER.
  DEFINE VAR l-CmbCta AS INTEGER.
  DEFINE VAR x-SdoAct AS INTEGER.
  DEFINE VAR x-SdoPas AS INTEGER.
  
  x-CodCta = p-CodCta.
  l-MonCta = cb-ctas.CodMon.
  l-CmbCta = cb-ctas.TpoCmb.
  
  
  FIND FIRST CB-DMOV WHERE  cb-dmov.codcia  = s-codcia   AND
                            cb-dmov.periodo = s-periodo  AND                          
                            cb-dmov.codcta  = x-codcta   NO-ERROR.
          
  x-msg2 = "Cuenta   : " + x-CodCta.
  x-msg1 = "División : " + F-CodDiv.
  DISPLAY x-msg1 x-msg2 WITH FRAME F-MENSAJE.
  PAUSE 0.
  XfSdoMn1 = 0.
  XfSdoMn2 = 0.
  x-Saldo  = 0.
  x-DbeSol = 0.
  x-HbeSol = 0.
  x-DbeDol = 0.
  x-HbeDol = 0.       
  x-CodDiv = F-CodDiv.
  x-ClfAux = "".
  x-CodAux = "".
  x-Cco    = "".
  x-CodDoc = "".
  x-NroDoc = "".          
  XoCodMon = IF l-MonCta = 1 THEN 1 ELSE cb-dmov.CodMon.                               
  
  FOR EACH cb-dmov  NO-LOCK
                    WHERE  cb-dmov.codcia  = s-codcia   AND
                           cb-dmov.periodo = s-periodo  AND
                           cb-dmov.codcta  = x-codcta   AND
                           cb-dmov.nromes  <= s-NroMes  :
                 
      IF NOT cb-dmov.TpoMov THEN x-DbeSol = x-DbeSol + cb-dmov.ImpMn1.
      ELSE x-HbeSol = x-HbeSol + cb-dmov.ImpMn1.        
      
      IF NOT cb-dmov.TpoMov THEN x-DbeDol = x-DbeDol + cb-dmov.ImpMn2.
      ELSE x-HbeDol = x-HbeDol + cb-dmov.ImpMn2.
  
  END.
  
  XfSdoMn1 = x-DbeSol - x-HbeSol.
  XfSdoMn2 = x-DbeDol - x-HbeDol.
  IF l-CmbCta = 3 THEN DO :        
     IF XfSdoMn1 > 0 THEN x-TpoCmb = XfTC-Cmp.
     ELSE x-TpoCmb = XfTC-Vta.
  END.   
  x-GloDoc = "AJUSTE X TRASLACION/" + STRING(x-TpoCmb,">>.9999").
  x-Saldo = XfSdoMn1 / x-TpoCmb.
  x-SdoAjt = ROUND( x-Saldo - XfSdoMn2 , 2 ).
  IF ABSOLUTE(x-SdoAjt) > 0 AND XoCodMon = 1 THEN DO :
       IF x-SdoAjt > 0 THEN DO :
          x-SdoAct = x-SdoAct + x-SdoAjt.
          FIND FIRST Temporal WHERE Temporal.CodDiv = x-CodDiv NO-ERROR.
               IF NOT AVAILABLE temporal THEN DO :
                  CREATE temporal.
                  Temporal.CodDiv = x-CodDiv.
               END.   
               Temporal.SdoAct = Temporal.SdoAct + x-SdoAjt.
       END.    
       ELSE DO: 
          x-SdoPas = x-SdoPas + x-SdoAjt.
          FIND FIRST Temporal WHERE Temporal.CodDiv = x-CodDiv NO-ERROR.
          IF NOT AVAILABLE temporal THEN DO :
             CREATE temporal.
             Temporal.CodDiv = x-CodDiv.
          END.   
          Temporal.SdoPas = Temporal.SdoPas + x-SdoAjt.
       END. 
       IF x-SdoAjt > 0 THEN DO :
          x-ImpMn1 = 0.
          x-ImpMn2 = ABS(x-SdoAjt).
       END.
       ELSE DO :
          x-ImpMn1 = 0.
          x-ImpMn2 = ABS(x-SdoAjt) * -1.
       END.                   
       RUN GrabaMov.
  END.            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Ajuste-CtaCte W-Win 
PROCEDURE Calcula-Ajuste-CtaCte :
/*------------------------------------------------------------------------------
  Purpose: CALCULA EL AJUSTE 
  Parameters:  <none>
  Notes:WRC      
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-CodCta  AS CHARACTER.
  
  /* VARIABLES DEL PROCEDIMIENTO */
  DEFINE VAR x-DbeSol AS DECIMAL.
  DEFINE VAR x-HbeSol AS DECIMAL.
  DEFINE VAR x-DbeDol AS DECIMAL.
  DEFINE VAR x-HbeDol AS DECIMAL.
  DEFINE VAR x-Saldo  AS DECIMAL.
  DEFINE VAR x-SdoAjt AS DECIMAL.
  DEFINE VAR l-MonCta AS INTEGER.
  DEFINE VAR l-CmbCta AS INTEGER.
  DEFINE VAR x-SdoAct AS INTEGER.
  DEFINE VAR x-SdoPas AS INTEGER.
  
  x-CodCta = p-CodCta.
  l-MonCta = cb-ctas.CodMon.
  l-CmbCta = cb-ctas.TpoCmb.
  
  
  FIND FIRST CB-DMOV WHERE  cb-dmov.codcia  = s-codcia   AND
                            cb-dmov.periodo = s-periodo  AND                          
                            cb-dmov.codcta  = x-codcta   NO-ERROR.
                              
  FOR EACH cb-dmov  NO-LOCK 
                    WHERE  cb-dmov.codcia  = s-codcia   AND
                           cb-dmov.periodo = s-periodo  AND
                           cb-dmov.codcta  = x-codcta   AND
                           cb-dmov.nromes  <= s-NroMes   
                           BREAK
                           BY cb-dmov.ClfAux
                           BY cb-dmov.codaux  
                           BY cb-dmov.coddoc 
                           BY cb-dmov.nrodoc 
                           BY cb-dmov.fchdoc :
                                         
       IF FIRST-OF(cb-dmov.NroDoc) THEN DO :
          x-msg1 = "Divisi¢n  : " + F-CodDiv.
          x-msg2 = "Cuenta    : " + x-CodCta.          
          x-msg3 = "Documento : " + cb-dmov.nrodoc.
          DISPLAY x-msg1 x-msg2 x-msg3 WITH FRAME F-MENSAJE.
          PAUSE 0.

          XfSdoMn1 = 0.
          XfSdoMn2 = 0.
          x-Saldo  = 0.
          x-DbeSol = 0.
          x-HbeSol = 0.
          x-DbeDol = 0.
          x-HbeDol = 0.       
          x-ClfAux = cb-dmov.ClfAux.
          x-CodAux = cb-dmov.CodAux.
          x-CodDoc = cb-dmov.CodDoc.
          x-NroDoc = cb-dmov.NroDoc.
          x-CodDiv = F-CodDiv.
          x-Cco    = cb-dmov.Cco.
          XoCodMon = IF l-MonCta = 1 THEN 1 ELSE cb-dmov.CodMon. 
       END.        
       
       IF NOT cb-dmov.TpoMov THEN x-DbeSol = x-DbeSol + cb-dmov.ImpMn1.
       ELSE x-HbeSol = x-HbeSol + cb-dmov.ImpMn1.
  
       IF NOT cb-dmov.TpoMov THEN x-DbeDol = x-DbeDol + cb-dmov.ImpMn2.
       ELSE x-HbeDol = x-HbeDol + cb-dmov.ImpMn2.
  
       IF LAST-OF(cb-dmov.NroDoc) THEN DO :
          XfSdoMn1 = x-DbeSol - x-HbeSol.
          XfSdoMn2 = x-DbeDol - x-HbeDol.
          IF l-CmbCta = 3 THEN DO :        
             IF XfSdoMn1 > 0 THEN x-TpoCmb = XfTC-Cmp.
             ELSE x-TpoCmb = XfTC-Vta.
          END.   
          x-GloDoc = "AJUSTE X TRASLACION/" + STRING(x-TpoCmb,">>.9999").
          x-Saldo = (XfSdoMn1 / x-TpoCmb).
          x-SdoAjt = ROUND( x-Saldo - XfSdoMn2 , 2 ).
          IF ABSOLUTE(x-SdoAjt) > 0 AND XoCodMon = 1 THEN DO :
             IF x-SdoAjt > 0 THEN DO :
                x-SdoAct = x-SdoAct + x-SdoAjt.
                FIND FIRST Temporal WHERE Temporal.CodDiv = x-CodDiv NO-ERROR.
                IF NOT AVAILABLE temporal THEN DO :
                   CREATE temporal.
                   Temporal.CodDiv = x-CodDiv.
                END.   
                Temporal.SdoAct = Temporal.SdoAct + x-SdoAjt.
             END.    
             ELSE DO: 
                x-SdoPas = x-SdoPas + x-SdoAjt.
                FIND FIRST Temporal WHERE Temporal.CodDiv = x-CodDiv NO-ERROR.
                IF NOT AVAILABLE temporal THEN DO :
                   CREATE temporal.
                   Temporal.CodDiv = x-CodDiv.
                END.   
                Temporal.SdoPas = Temporal.SdoPas + x-SdoAjt.
             END. 
             IF x-SdoAjt > 0 THEN DO :
                x-ImpMn1 = 0.
                x-ImpMn2 = ABS(x-SdoAjt).
             END.
             ELSE DO :
                x-ImpMn1 = 0.
                x-ImpMn2 = ABS(x-SdoAjt) * -1.
             END. 
             RUN GrabaMov.
          END.
       END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREA-CONTRA W-Win 
PROCEDURE CREA-CONTRA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST TEMPORAL NO-LOCK NO-ERROR.
IF AVAILABLE TEMPORAL THEN DO :
    FOR EACH TEMPORAL :
        IF TEMPORAL.SdoPas <> 0 THEN DO :    
           FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
                              cb-ctas.CodCta = XsCodCta-67 NO-LOCK NO-ERROR.
           x-msg1 = "Creando Contracuentas ... ".
           x-msg2 = XsCodCta-67.
           x-msg3 = "". 
           DISPLAY x-msg1 x-msg2 x-msg3 WITH FRAME F-MENSAJE.
           PAUSE 0.
           x-CodDiv = temporal.CodDiv.
           x-ClfAux = cb-ctas.ClfAux.
           x-CodAux = XsCodAux-67.
           x-CodDoc = "".
           x-NroDoc = "".
           x-CodCta = XsCodCta-67.
           x-Cco    = XsCodCco-67.
           IF TEMPORAL.SdoPas > 0 THEN x-ImpMn2 = ABS(Temporal.SdoPas) * -1.
           ELSE x-ImpMn2 = ABS(Temporal.SdoPas).
           x-ImpMn1 = 0.
           RUN GrabaMov.   
        END.       
        IF TEMPORAL.SdoAct <> 0 THEN DO :    
           FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
                              cb-ctas.CodCta = XsCodCta-77 NO-LOCK NO-ERROR.           
           x-msg1 = "Creando Contracuentas ... ".
           x-msg2 = XsCodCta-77.
           x-msg3 = "".
           DISPLAY x-msg1 x-msg2 x-msg3 WITH FRAME F-MENSAJE.
           PAUSE 0.
           x-CodDiv = temporal.CodDiv.
           x-ClfAux = cb-ctas.ClfAux.
           x-CodAux = XsCodAux-77.
           x-Cco    = XsCodCCo-77.
           x-CodDoc = "".
           x-NroDoc = "".
           x-CodCta = XsCodCta-77.
           IF TEMPORAL.SdoAct > 0 THEN x-ImpMn2 = ABS(Temporal.SdoAct) * -1.
           ELSE x-ImpMn2 = ABS(Temporal.SdoAct).
           x-ImpMn1 = 0.
           RUN GrabaMov.   
        END.       
    END.
END.
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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY f-NomCia f-Periodo F-Nromes F-CodDiv EDITOR-1 XfTC-Cmp XfTC-Vta 
      WITH FRAME F-Main IN WINDOW W-Win.
  IF AVAILABLE cb-cfgg THEN 
    DISPLAY cb-cfgg.Codope cb-cfgg.codcta[1] cb-cfgg.codaux[1] cb-cfgg.codcta[3] 
          cb-cfgg.codcta[2] cb-cfgg.codaux[2] 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-14 F-CodDiv XfTC-Cmp XfTC-Vta B-ACEPTAR B-Cancelar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GrabaMov W-Win 
PROCEDURE GrabaMov :
/*------------------------------------------------------------------------------
  Purpose: GRABA EL MOVIMIENTO GENERADO POR CADA BARRIDA
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-CtaAut AS CHAR.
DEFINE VAR x-CtrCta AS CHAR.
DEFINE VAR x-GenAut AS INTEGER.
DEFINE VAR x-Recid  AS RECID.
DEFINE VAR i AS INTEGER.

CREATE Detalle.
  x-nroitm = x-nroitm + 1.
  IF (x-ImpMn2 > 0 ) THEN x-tpomov = NO.
                     ELSE x-tpomov = YES.
                      
  x-ImpMn1 = ABS(x-ImpMn1).
  x-ImpMn2 = ABS(x-ImpMn2).
  
  ASSIGN Detalle.CodCia   = s-CodCia
         Detalle.Periodo  = s-Periodo
         Detalle.coddiv   = x-CodDiv
         Detalle.Codcta   = x-CodCta
         Detalle.Codmon   = x-codmon
         Detalle.Codope   = XsCodOpe
         Detalle.Glodoc   = x-glodoc
         Detalle.ImpMn1   = x-ImpMn1
         Detalle.ImpMn2   = x-IMpMn2
         Detalle.Nroast   = XsNroAst
         Detalle.Nroitm   = x-nroitm
         Detalle.NroMes   = s-NroMes
         Detalle.Tpocmb   = x-tpocmb
         Detalle.clfaux   = x-clfaux
         Detalle.codaux   = x-codaux
         Detalle.Cco      = x-Cco
         Detalle.coddoc   = x-coddoc
         Detalle.nrodoc   = x-nrodoc
         Detalle.TpoMov   = x-tpomov.
        
  IF DETALLE.TPOMOV THEN cb-cmov.HBEMN2 = cb-cmov.HBEMN2 + DETALLE.IMPMN2.
                    ELSE cb-cmov.DBEMN2 = cb-cmov.DBEMN2 + DETALLE.IMPMN2.         
                      
  x-Recid = RECID(Detalle).      
  
  RUN cbd/cb-acmd.p(RECID(Detalle), YES, YES).

  /* Preparando para Autom ticas */
  
  x-GenAut = 0.
  
  /* Verificamos si la Cuenta genera automaticas de Clase 9 */
  
  DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
     IF x-Codcta  BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
        IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
           x-GenAut = 1.
           LEAVE.
        END.
     END.
  END.
  
  /* Verificamos si la Cuenta genera automaticas de Clase 6 */
  
  DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
     IF x-CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
        IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
           x-GenAut = 2.
           LEAVE.
        END.
     END.
  END.
  
  /* Verificamos si la Cuenta genera automaticas de otro tipo */
  
  DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
     IF x-CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
        IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
           x-GenAut = 3.
           LEAVE.
        END.
     END.
  END.
  
  x-CtaAut = "".
  x-CtrCta = "".
  
  FIND FIRST cb-ctas WHERE cb-ctas.codcia = cb-CodCia AND 
                           cb-ctas.CodCta = x-CodCta NO-LOCK NO-ERROR.
  CASE x-GenAut:
       /* Genera Cuentas Clase 9 */
       WHEN 1 THEN DO:
            x-CtrCta = cb-ctas.Cc1Cta.
            IF cb-ctas.ClfAux = "@CT" THEN x-CtaAut = x-CodAux.
               ELSE x-CtaAut = cb-ctas.An1Cta.
            IF x-CtrCta = "" THEN x-CtrCta = cb-cfga.Cc1Cta9.
       END.
       /* Genera Cuentas Clase 6 */
       WHEN 2 THEN DO:
            x-CtrCta = cb-ctas.Cc1Cta.            
            IF cb-ctas.ClfAux = "@CT" THEN x-CtaAut = x-CodAux.
               ELSE x-CtaAut = cb-ctas.An1Cta.

            IF x-CtrCta = "" THEN x-CtrCta = cb-cfga.Cc1Cta6.
       END.
       
       WHEN 3 THEN DO:
            x-CtaAut = cb-ctas.An1Cta.
            x-CtrCta = cb-ctas.Cc1Cta.
       END.
  END CASE.
  
  /* Chequendo las cuentas a generar en forma autom tica */
  
  IF x-GenAut > 0 THEN DO:
     FIND FIRST cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND cb-ctas.CodCta = x-CtaAut NO-LOCK NO-ERROR.
     IF NOT AVAILABLE cb-ctas THEN DO:
        BELL.
        MESSAGE "Cuentas Autom ticas a generar" SKIP
                "Tienen mal registro, Cuenta" x-CtaAut "no existe"
                VIEW-AS ALERT-BOX ERROR.
                x-CtaAut = "".
     END.
        
     FIND FIRST cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND cb-ctas.CodCta = x-CtrCta NO-LOCK NO-ERROR.
     IF NOT AVAILABLE cb-ctas THEN DO:
        BELL.
        MESSAGE "Cuentas Autom ticas a generar" SKIP
                "Tienen mal registro, Contra Cuenta" x-CtrCta "no existe"
                VIEW-AS ALERT-BOX ERROR.
                x-CtrCta = "".
     END.
  END. /*Fin del x-genaut > 0 */
  
  IF x-CtaAut <> "" AND x-CtrCta <> "" THEN DO:
     x-nroitm = x-nroitm + 1.
     CREATE Detalle.
     ASSIGN Detalle.CodCia   = s-CodCia
            Detalle.Periodo  = s-Periodo
            Detalle.coddiv   = x-CodDiv
            Detalle.Codcta   = x-CtaAut
            Detalle.TpoItm   = "A"
            Detalle.Relacion = x-Recid
            Detalle.Codmon   = x-codmon
            Detalle.Codope   = XsCodOpe
            Detalle.Glodoc   = x-glodoc
            Detalle.ImpMn1   = x-ImpMn1
            Detalle.ImpMn2   = x-IMpMn2
            Detalle.Nroast   = XsNroAst
            Detalle.Nroitm   = x-nroitm
            Detalle.NroMes   = s-NroMes
            Detalle.Tpocmb   = x-tpocmb
            Detalle.clfaux   = x-clfaux
            Detalle.codaux   = x-codaux
            Detalle.coddoc   = x-coddoc
            Detalle.nrodoc   = x-nrodoc
            Detalle.TpoMov   = x-tpomov.

     RUN cbd/cb-acmd.p(RECID(Detalle), YES ,YES).
     
     IF DETALLE.TPOMOV THEN cb-cmov.HBEMN1 = cb-cmov.HBEMN1 + DETALLE.IMPMN1.
                       ELSE cb-cmov.DBEMN1 = cb-cmov.DBEMN1 + DETALLE.IMPMN1.         
                      
     x-nroitm = x-nroitm + 1.
     
     CREATE DETALLE.
     ASSIGN Detalle.CodCia   = s-CodCia
            Detalle.Periodo  = s-Periodo
            Detalle.coddiv   = x-CodDiv
            Detalle.Codcta   = x-CtaAut
            Detalle.TpoItm   = "A"
            Detalle.Relacion = x-Recid
            Detalle.Codmon   = x-codmon
            Detalle.Codope   = XsCodOpe
            Detalle.Glodoc   = x-glodoc
            Detalle.ImpMn1   = x-ImpMn1
            Detalle.ImpMn2   = x-IMpMn2
            Detalle.Nroast   = XsNroAst
            Detalle.Nroitm   = x-nroitm
            Detalle.NroMes   = s-NroMes
            Detalle.Tpocmb   = x-tpocmb
            Detalle.clfaux   = x-clfaux
            Detalle.codaux   = x-codaux
            Detalle.coddoc   = x-coddoc
            Detalle.nrodoc   = x-nrodoc
            Detalle.TpoMov   = NOT x-tpomov.

     RUN cbd/cb-acmd.p(RECID(Detalle), YES ,YES).

     IF DETALLE.TPOMOV THEN cb-cmov.HBEMN2 = cb-cmov.HBEMN2 + DETALLE.IMPMN2.
                       ELSE cb-cmov.DBEMN2 = cb-cmov.DBEMN2 + DETALLE.IMPMN2.         
     
END.  

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
  
  DO WITH FRAME {&FRAME-NAME}:
      f-NomCia:screen-value = s-NomCia.
      f-NroMes:screen-value = STRING(s-Nromes).
      f-Periodo:screen-value = STRING(s-periodo).
      DEF VAR U-DIA-MES AS DATE.
      IF S-NROMES = 12 THEN U-DIA-MES = DATE(12,31,S-PERIODO).  
         ELSE U-DIA-MES = DATE(S-NROMES + 1, 1 , S-PERIODO) - 1.
      FIND GN-TCMB WHERE GN-TCMB.FECHA = U-DIA-MES NO-LOCK NO-ERROR.
      IF AVAIL GN-TCMB THEN ASSIGN XfTC-Cmp:SCREEN-VALUE = STRING(GN-TCMB.COMPRA)
                                   XfTC-Vta:SCREEN-VALUE = STRING(GN-TCMB.VENTA).
      FIND FIRST GN-DIVI WHERE gn-divi.CodCia = s-CodCia NO-LOCK NO-ERROR.
      IF AVAIL GN-DIVI THEN F-CodDiv:SCREEN-VALUE = GN-DIVI.CodDiv.                                         
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO W-Win 
PROCEDURE PROCESO :
/*------------------------------------------------------------------------------
  Purpose: PROCESA LA DIFERENCIA POR DIFERENCIA DE CAMBIO
  Parameters:  <none>
  Notes:WRC       
------------------------------------------------------------------------------*/
/* PRIMERO ELIMINAMOS ASIENTO QUE SE GENERO */

  x-msg1 = "Eliminando Movimiento Anterior".
  DISPLAY x-msg1 WITH FRAME F-MENSAJE.
  PAUSE 0.

FOR EACH cb-dmov WHERE cb-dmov.Codcia  = s-codcia  AND
                       cb-dmov.Periodo = s-periodo AND
                       cb-dmov.NroMes  = s-NroMes  AND
                       cb-dmov.CodOpe  = XsCodOpe  AND
                       cb-dmov.NroAst  = XsNroAst :
    RUN cbd/cb-acmd(RECID(cb-dmov),NO,YES).
    DELETE cb-dmov.                       
END.

FIND cb-cmov WHERE cb-cmov.CodCia  = s-codcia  AND
                   cb-cmov.Periodo = s-periodo AND
                   cb-cmov.NroMes  = s-NroMes  AND
                   cb-cmov.CodOPe  = XsCodOpe  AND
                   cb-cmov.NroAst  = XsNroAst
                   NO-ERROR.
                   
IF NOT AVAIL cb-cmov THEN CREATE cb-cmov.

   ASSIGN cb-cmov.CodCia  = s-codcia
          cb-cmov.Periodo = s-periodo
          cb-cmov.NroMes  = s-NroMes
          cb-cmov.CodOPe  = XsCodOpe
          cb-cmov.NroAst  = XsNroAst
          cb-cmov.NotAst  = "ASIENTO AUTOMATICO TRASLACION"
          cb-cmov.GloAst  = "ASIENTO AUTOMATICO TRASLACION"
          cb-cmov.fchast  = u-dia-mes
          cb-cmov.usuario = s-user-id
          cb-cmov.DbeMn1 = 0
          cb-cmov.DbeMn2 = 0
          cb-cmov.DbeMn3 = 0
          cb-cmov.HbeMn1 = 0
          cb-cmov.HbeMn2 = 0
          cb-cmov.HbeMn3 = 0.


/* COPIAMOS LOS CODIGOS DE DIVISIONARIA AL TEMPORAL */

FOR EACH GN-DIVI WHILE LENGTH(GN-DIVI.CodDiv) = 5 :
    CREATE Temporal.
    Temporal.CodDiv = GN-DIVI.CodDiv.
END.

/* BARREMOS EL PLAN DE CUENTAS */

FOR EACH CB-CTAS WHERE CB-CTAS.CODCIA  = CB-CODCIA AND
    LENGTH(CB-CTAS.CODCTA) = CB-MAXNIVEL AND cb-ctas.AftDcb = YES :
    
    IF cb-ctas.Codmon = 1 THEN DO :
       IF cb-ctas.TpoCmb = 1 THEN 
          x-TpoCmb = XfTC-Cmp.
          
       IF cb-ctas.TpoCmb = 2 THEN 
          x-TpoCmb = XfTC-Vta.
          
       IF cb-ctas.PidAux = YES THEN RUN Calcula-Ajuste-CtaCte(cb-ctas.CodCta).
       ELSE RUN Calcula-Ajuste(cb-ctas.CodCta).
    END.   
END.

/* CREANDO LAS CONTRACUENTAS POR DIVISION */

RUN CREA-CONTRA.
                                                                           
HIDE FRAME F-MENSAJE.
MESSAGE "PROCESO CONCLUIDO ...".
RUN dispatch IN THIS-PROCEDURE ('exit':U).
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Empresas"}
  {src/adm/template/snd-list.i "Cb-cmov"}
  {src/adm/template/snd-list.i "Cb-cfgG"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

