&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
SESSION:DATE-FORMAT = "dmy".

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia  AS INTEGER.
DEFINE SHARED VAR s-nomcia  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .

DEFINE VAR cb-codcia AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VAR x-codope  AS CHAR NO-UNDO.
DEFINE VAR x-ctagan  AS CHAR NO-UNDO.
DEFINE VAR x-ctaper  AS CHAR NO-UNDO.
DEFINE VAR x-rndgan  AS CHAR NO-UNDO.
DEFINE VAR x-rndper  AS CHAR NO-UNDO.
DEFINE VAR x-tcajus  AS DECI NO-UNDO.
DEFINE VAR x-tvajus  AS DECI NO-UNDO.
DEFINE VAR x-ctagas  AS CHAR NO-UNDO.
DEFINE VAR x-ctaint  AS CHAR NO-UNDO.
DEFINE VAR x-ctapro  AS CHAR NO-UNDO.

DEFINE NEW SHARED TEMP-TABLE t-prev
    FIELD Tipo   AS CHAR
    FIELD Banco   LIKE cb-dmov.CodBco
    FIELD Periodo LIKE cb-dmov.periodo
    FIELD NroMes LIKE cb-dmov.nromes
    FIELD Codope LIKE cb-dmov.codope
    FIELD Codcta LIKE cb-dmov.codcta
    FIELD CodDiv LIKE cb-dmov.coddiv
    FIELD Codmon LIKE cb-dmov.codmon
    FIELD Fchdoc LIKE cb-dmov.fchdoc
    FIELD Fchvta LIKE cb-dmov.fchvto
    FIELD Coddoc LIKE cb-dmov.coddoc
    FIELD Nrodoc LIKE cb-dmov.nrodoc
    FIELD Nroref LIKE cb-dmov.nroref
    FIELD Glodoc LIKE cb-dmov.glodoc
    FIELD Tpocmb LIKE cb-dmov.tpocmb
    FIELD TpoMov LIKE cb-dmov.tpomov
    FIELD ImpMn1 LIKE cb-dmov.impmn1 
    FIELD ImpMn2 LIKE cb-dmov.impmn2
    FIELD clfaux LIKE cb-dmov.Clfaux
    FIELD codaux LIKE cb-dmov.Codaux
    INDEX IDX01 Tipo.


DEFINE BUFFER B-prev  FOR t-prev.
DEFINE BUFFER B-Docum FOR FacDocum.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VAR s-NroMesCie AS LOGICAL INITIAL YES.
DEFINE VAR x-fchini AS DATE NO-UNDO.
DEFINE VAR x-fchfin AS DATE NO-UNDO.
DEFINE VAR x-tpocmb AS DECI NO-UNDO.
DEFINE VAR x-list   AS CHAR INITIAL '' NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

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

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-42 P-periodo P-Mes F-Tpocmb B-filtro 
&Scoped-Define DISPLAYED-OBJECTS C-Tipo P-periodo P-Mes F-Tpocmb 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ccbcbd AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-filtro 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Button 5" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON B-Imprimir 
     IMAGE-UP FILE "img\b-print":U
     LABEL "Button 1" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON B-Transferir 
     IMAGE-UP FILE "img\climnu1":U
     LABEL "Transferir Asiento" 
     SIZE 6.43 BY 1.62.

DEFINE VARIABLE C-Tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Canje de Letras" 
     SIZE 26.72 BY 1 NO-UNDO.

DEFINE VARIABLE P-Mes AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     SIZE 5.72 BY 1 NO-UNDO.

DEFINE VARIABLE F-Tpocmb AS DECIMAL FORMAT ">>9.999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE P-periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6.29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.57 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     C-Tipo AT ROW 4.73 COL 1.14 COLON-ALIGNED NO-LABEL
     P-periodo AT ROW 3.5 COL 22.43 COLON-ALIGNED NO-LABEL
     P-Mes AT ROW 3.5 COL 34.57 COLON-ALIGNED NO-LABEL
     F-Tpocmb AT ROW 3.5 COL 46.43 COLON-ALIGNED NO-LABEL
     B-filtro AT ROW 2.42 COL 64
     B-Transferir AT ROW 2.42 COL 72.14
     B-Imprimir AT ROW 2.42 COL 80.29
     RECT-42 AT ROW 2.62 COL 20.14
     "Periodo" VIEW-AS TEXT
          SIZE 5.86 BY .5 AT ROW 2.85 COL 24.57
     "T.Cambio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.85 COL 49
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4.08 COL 63.43
     "CUENTAS   POR   COBRAR" VIEW-AS TEXT
          SIZE 36.57 BY .85 AT ROW 1.23 COL 28.57
          FONT 12
     "Mes de Proceso" VIEW-AS TEXT
          SIZE 11.43 BY .5 AT ROW 2.85 COL 33.14
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.54 COL 73.14
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4 COL 72.57
     "Imprimir" VIEW-AS TEXT
          SIZE 5.43 BY .5 AT ROW 4.15 COL 80.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89 BY 17
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
         TITLE              = "Generacion de Asiento Contable"
         HEIGHT             = 14.23
         WIDTH              = 88.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 89
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 89
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR BUTTON B-Imprimir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON B-Transferir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX C-Tipo IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       C-Tipo:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de Asiento Contable */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Asiento Contable */
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
     P-Mes F-Tpocmb P-periodo.

  IF P-Mes = 0 THEN DO:
     MESSAGE 'El mes no ha sido seleccionado' VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO P-Mes.
     RETURN NO-APPLY.
  END.
  IF F-tpocmb = 0 THEN DO:
     MESSAGE 'Tipo de cambio no registrado' VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO F-tpocmb.
     RETURN NO-APPLY.
  END.

  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                     cb-peri.Periodo = P-Periodo NO-LOCK.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[P-Mes + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  
  x-fchini = DATE( P-mes, 01, P-periodo).
  IF P-mes = 12 THEN x-fchfin = DATE(P-mes, 31, P-periodo).
  ELSE x-fchfin = DATE( P-mes + 1, 01, P-periodo) - 1.
  
  RUN Carga-Temporal.
  C-Tipo:SENSITIVE = YES.
  B-Transferir:SENSITIVE = YES.
  B-Imprimir:SENSITIVE   = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir W-Win
ON CHOOSE OF B-Imprimir IN FRAME F-Main /* Button 1 */
DO:
  RUN Pre-impresion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Transferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Transferir W-Win
ON CHOOSE OF B-Transferir IN FRAME F-Main /* Transferir Asiento */
DO:
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                     cb-peri.Periodo = P-Periodo NO-LOCK.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[P-Mes + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

  RUN Transferir-asiento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Tipo W-Win
ON VALUE-CHANGED OF C-Tipo IN FRAME F-Main
DO:
  RUN Abrir-Browse IN h_b-ccbcbd (INPUT SUBSTRING(SELF:SCREEN-VALUE,1,3)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME P-Mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL P-Mes W-Win
ON LEAVE OF P-Mes IN FRAME F-Main
DO:
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN P-periodo.
     x-fchfin = DATE(INTEGER(SELF:SCREEN-VALUE), 01, P-periodo) - 1.
     FIND gn-tcmb WHERE gn-tcmb.fecha = x-fchfin NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN
        ASSIGN
           x-tcajus = gn-tcmb.compra
           x-tvajus = gn-tcmb.venta.
     ELSE DO:
        MESSAGE 'No existe tipo de cambio del mes anterior' SKIP
                '(para realizar el ajuste por dif.cambio)' VIEW-AS ALERT-BOX.
        APPLY 'ENTRY':U TO P-Mes.
        RETURN NO-APPLY.
     END.
     
     IF INTEGER(SELF:SCREEN-VALUE) = 12 THEN x-fchfin = DATE(12,31, P-periodo).
     ELSE x-fchfin = DATE(INTEGER(SELF:SCREEN-VALUE) + 1, 01, P-periodo) - 1.
     FIND gn-tcmb WHERE gn-tcmb.fecha = x-fchfin NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN
        DISPLAY 
           gn-tcmb.compra @ F-Tpocmb.
  END.
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
   FOR EACH FacDocum WHERE FacDocum.CodCia = s-codcia NO-LOCK:
       IF FacDocum.FlgCbd AND LOOKUP(FacDocum.CodDoc, 'FAC,BOL,N/C,N/D') = 0 THEN DO:
          CASE FacDocum.CodDoc:
             WHEN 'ASG' THEN 
                FOR EACH CcbDcaja WHERE CcbDCaja.CodCia = s-codcia AND
                    CcbDCaja.CodDoc = 'N/C' AND 
                    CcbDCaja.FchDoc >= x-fchini AND CcbDCaja.FchDoc >= x-fchfin :
                    FIND cb-control WHERE cb-control.codcia = s-codcia AND
                         cb-control.tipo = '@CCB' AND 
                         cb-control.tipmov = FacDocum.Coddoc AND Periodo = p-periodo AND
                         cb-control.nromes = p-mes NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-control THEN
                       ASSIGN 
                          CcbDCaja.FchCbd = TODAY
                          CcbDCaja.FlgCbd = TRUE.
                    RELEASE CcbDCaja.
                END.
             OTHERWISE
                FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
                    CcbCMvto.Coddoc = FacDocum.CodDoc AND CcbCMvto.Fchdoc >= x-fchini AND
                    CcbCMvto.Fchdoc <= x-fchfin:
                    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
                    FIND cb-control WHERE cb-control.codcia = s-codcia AND
                         cb-control.tipo = '@CCB' AND 
                         cb-control.tipmov = FacDocum.Coddoc AND cb-control.Periodo = p-periodo AND
                         cb-control.nromes = p-mes NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-control THEN DO:
                       ASSIGN
                          CcbCMvto.FlgCbd = TRUE
                          CcbCMvto.FchCbd = TODAY.
                       /* Solo en el caso de canje de letras se marcan las letras    */
                       /* como trasferidas a contabilidad                            */
                       /* Caso de renovaciones                                       */
                       CASE FacDocum.CodDoc:
                          WHEN 'CJE' THEN 
                            FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
                                CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
                                CcbDMvto.NroDoc = CcbCMvto.NroDoc AND 
                                CcbDMvto.TpoRef = 'L' NO-LOCK:
                                FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
                                     CcbCDocu.CodDoc = CcbDMvto.CodRef AND
                                     CcbCDocu.NroDoc = CcbDMvto.NroRef NO-ERROR.
                                IF AVAILABLE CcbCDocu THEN 
                                   ASSIGN
                                      CcbCDocu.FlgCbd = TRUE
                                      CcbCDocu.FchCbd = TODAY
                                      CcbCDocu.Codope = cb-control.Codope 
                                      CcbCDocu.NroMes = cb-control.Nromes 
                                      CcbCDocu.Nroast = cb-control.Nroast.
                                RELEASE CcbCDocu.
                            END.  
                          WHEN 'RNV' THEN 
                            FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
                                CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
                                CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK:
                                FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
                                     CcbCDocu.CodDoc = CcbDMvto.CodRef AND
                                     CcbCDocu.NroDoc = CcbDMvto.NroRef NO-ERROR.
                                IF AVAILABLE CcbCDocu THEN 
                                   ASSIGN
                                      CcbCDocu.FlgCbd = TRUE
                                      CcbCDocu.FchCbd = TODAY
                                      CcbCDocu.Codope = cb-control.Codope 
                                      CcbCDocu.NroMes = cb-control.Nromes 
                                      CcbCDocu.Nroast = cb-control.Nroast.
                                RELEASE CcbCDocu.
                            END.  
                       END CASE.
                       RELEASE CcbCMvto.
                    END.
                END.
          END CASE.
       END.
   END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
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
             INPUT  'aplic/ccb/b-ccbcbd.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ccbcbd ).
       RUN set-position IN h_b-ccbcbd ( 5.65 , 1.29 ) NO-ERROR.
       /* Size in UIB:  ( 7.88 , 87.57 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv10.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 13.31 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.69 , 45.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-ccbcbd. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-ccbcbd ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ccbcbd ,
             C-Tipo:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             h_b-ccbcbd , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anula-asto W-Win 
PROCEDURE anula-asto :
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.

DEFINE BUFFER C-DMOV FOR CB-DMOV.

FOR EACH CB-DMOV WHERE
    CB-DMOV.codcia  = p-codcia AND
    CB-DMOV.periodo = p-periodo AND
    CB-DMOV.nromes  = p-mes AND
    CB-DMOV.codope  = p-codope AND
    CB-DMOV.nroast  = p-nroast:
    FOR EACH C-DMOV WHERE C-DMOV.RELACION = RECID(CB-DMOV) :
        RUN cbd/cb-acmd.p(RECID(C-DMOV),NO,YES).
        DELETE C-DMOV.
    END.
    RUN cbd/cb-acmd.p(RECID(CB-DMOV),NO,YES).
    DELETE CB-DMOV.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anula-temporal W-Win 
PROCEDURE anula-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.
FOR EACH T-CB-DMOV WHERE
    T-CB-DMOV.codcia  = p-codcia AND
    T-CB-DMOV.periodo = p-periodo AND
    T-CB-DMOV.nromes  = p-mes AND
    T-CB-DMOV.codope  = p-codope AND
    T-CB-DMOV.nroast  = p-nroast:
    DELETE T-CB-DMOV.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ajuste W-Win 
PROCEDURE Carga-Ajuste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-codcbd  AS CHAR.
DEFINE INPUT PARAMETER X-codcta  AS CHAR.
DEFINE INPUT PARAMETER X-importe AS DECIMAL.
DEFINE INPUT PARAMETER X-tipo    AS CHAR.
DEFINE INPUT PARAMETER X-codmon  AS INTEGER.
DEFINE INPUT PARAMETER X-glodoc  AS CHAR.

DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
DEFINE VAR x-ajuste AS DECIMAL NO-UNDO.
DEFINE VAR x-tpomov AS LOGICAL NO-UNDO.

FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
     cb-ctas.Codcta = x-codcta NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-ctas THEN DO:
   MESSAGE 'Cuenta contable ' + x-codcta + ' no existe' VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
END.

IF NOT cb-ctas.AftDcb THEN RETURN.

IF cb-ctas.Codmon = 1 THEN x-tpocmb = x-tcajus.
ELSE x-tpocmb = x-tvajus.

IF CcbCDocu.Fchdoc >= x-fchini THEN x-tpocmb = CcbCDocu.tpocmb.

IF CcbCDocu.codmon = 1 THEN 
   x-ajuste = ROUND((x-importe / x-tpocmb) - (x-importe / CcbCMvto.tpocmb), 2).
ELSE 
   x-ajuste = ROUND((x-importe * x-tpocmb) - (x-importe * CcbCMvto.tpocmb), 2).

IF x-ajuste <> 0 THEN DO:
   IF x-ajuste > 0 THEN x-tpomov = TRUE.
   ELSE x-tpomov = FALSE.
   CREATE t-prev.
   ASSIGN
      t-prev.tipo    = x-tipo
      t-prev.periodo = p-periodo
      t-prev.nromes  = p-mes
      t-prev.codope  = x-codope
      t-prev.coddiv  = CcbCDocu.CodDiv 
      t-prev.codmon  = x-codmon
      t-prev.codcta  = x-codcta
      t-prev.fchdoc  = CcbCMvto.FchApr
      t-prev.tpomov  = x-tpomov
      t-prev.clfaux  = '@CL'
      t-prev.codaux  = CcbCDocu.Codcli
      t-prev.coddoc  = X-CodCbd
      t-prev.nrodoc  = CcbCDocu.NroDoc.
      
   IF CcbCMvto.CodMon = 1 THEN
      ASSIGN
         t-prev.impmn2 = ABSOLUTE(x-ajuste).
   ELSE 
      ASSIGN
         t-prev.impmn1 = ABSOLUTE(x-ajuste).
   ASSIGN
      t-prev.Tpocmb  = CcbCMvto.TpoCmb
      t-prev.glodoc  = x-glodoc.
   RELEASE t-prev.

   IF x-ajuste > 0 THEN x-codcta = x-ctagan.
   ELSE x-codcta = x-ctaper.
   CREATE t-prev.
   ASSIGN
      t-prev.tipo    = x-tipo
      t-prev.periodo = p-periodo
      t-prev.nromes  = p-mes
      t-prev.codope  = x-codope
      t-prev.coddiv  = CcbCDocu.CodDiv 
      t-prev.codmon  = 1
      t-prev.codcta  = x-codcta
      t-prev.fchdoc  = CcbCMvto.FchApr
      t-prev.tpomov  = NOT x-tpomov
      t-prev.clfaux  = '@CL'
      t-prev.codaux  = CcbCDocu.Codcli
      t-prev.coddoc  = X-CodCbd
      t-prev.nrodoc  = CcbCDocu.NroDoc.
      
   IF CcbCMvto.CodMon = 1 THEN
      ASSIGN
         t-prev.impmn2 = ABSOLUTE(x-ajuste).
   ELSE 
      ASSIGN
         t-prev.impmn1 = ABSOLUTE(x-ajuste).
   ASSIGN
      t-prev.Tpocmb  = CcbCMvto.TpoCmb
      t-prev.glodoc  = 'Ajuste por Dif.Cambio'.
   
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-ASG W-Win 
PROCEDURE Carga-ASG :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbDcaja WHERE CcbDCaja.CodCia = s-codcia AND
    CcbDCaja.CodDoc = 'N/C' AND CcbDCaja.FchDoc = x-fecha NO-LOCK:
    DISPLAY CcbDCaja.CodDoc + '-' + CcbDCaja.NroDoc @ Fi-Mensaje LABEL "Asignaciones"
            FORMAT "X(16)" WITH FRAME F-Proceso.

    FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
         B-Docum.CodDoc = 'N/C' NO-LOCK NO-ERROR.
    IF AVAILABLE B-Docum THEN DO:
       x-codcbd = B-Docum.CodCbd.
       x-tpomov = B-Docum.TpoDoc.
    END.
    FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
         CcbCDocu.CodDoc = CcbDCaja.Coddoc AND
         CcbCDocu.NroDoc = CcbDCaja.Nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
       IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
       ELSE x-codcta = B-Docum.CodCta[2].
       x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
    END.
    RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
        CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbDCaja.tpocmb).
    /**/
    FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
         B-Docum.CodDoc = CcbDcaja.Codref NO-LOCK NO-ERROR.
    IF AVAILABLE B-Docum THEN DO:
       x-codcbd = B-Docum.CodCbd.
       x-tpomov = B-Docum.TpoDoc.
    END.
    FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
         CcbCDocu.CodDoc = CcbDCaja.Codref AND
         CcbCDocu.NroDoc = CcbDCaja.Nroref NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
       IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
       ELSE x-codcta = B-Docum.CodCta[2].
       x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
    END.

    RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
        CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbDCaja.tpocmb).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-B/C W-Win 
PROCEDURE Carga-B/C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
    DISPLAY CcbCMvto.Coddoc + '-' + CcbCMvto.Nrodoc @ Fi-Mensaje LABEL "Banco Cobranza"
            FORMAT "X(16)" WITH FRAME F-Proceso.
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK :
        x-codcbd = ''.
        FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
             B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE B-Docum THEN DO:
           x-codcbd = B-Docum.CodCbd.
           x-tpomov = NOT B-Docum.TpoDoc.
        END.
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
             CcbCDocu.CodDoc = CcbDMvto.CodRef AND
             CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
           IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
           ELSE x-codcta = B-Docum.CodCta[2].
           x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
           RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
               CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).
           RUN Carga-Ajuste(x-codcbd, x-codcta, CcbDMvto.ImpDoc, x-tipo, CcbCDocu.codmon, x-glodoc).
           /**/
           IF CcbCMvto.Codmon = 1 THEN x-codcta = FacDocum.CodCta[1].
           ELSE x-codcta = FacDocum.CodCta[2].
           x-codcta = IF x-codcta = '' THEN  FacDocum.CodCta[1] ELSE x-codcta.
           RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
               CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).
        END.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-B/D W-Win 
PROCEDURE Carga-B/D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
    DISPLAY CcbCMvto.Coddoc + '-' + CcbCMvto.Nrodoc @ Fi-Mensaje LABEL "Banco Descuento"
            FORMAT "X(16)" WITH FRAME F-Proceso.
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK :
        x-codcbd = ''.
        FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
             B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE B-Docum THEN DO:
           x-codcbd = B-Docum.CodCbd.
           x-tpomov = B-Docum.TpoDoc.
        END.
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
             CcbCDocu.CodDoc = CcbDMvto.CodRef AND
             CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN 
           IF CcbCMvto.codmon = 1 THEN DO:
              x-codcta = B-Docum.CodCta[1].
              RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              x-codcta = FacDocum.CodCta[1].
              RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              x-codcta = FacDocum.CodCta[3].
              RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              END.
           ELSE DO:
              x-codcta = B-Docum.CodCta[2].
              RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              x-codcta = FacDocum.CodCta[2].
              RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
              x-codcta = FacDocum.CodCta[4].
              RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                  CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).           
           END.
    END.
    RUN Graba-Documento(x-CodCbd, CcbCMvto.CodCta, FALSE, (CcbCMvto.ImpTot - CcbCMvto.ImpInt),
        x-tipo, CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, '', x-fecha, CcbCMvto.tpocmb).           
    RUN Graba-Documento(x-CodCbd, x-ctagas, FALSE, CcbCMvto.ImpInt,
        x-tipo, CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, '', x-fecha, CcbCMvto.tpocmb).           
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-CJE W-Win 
PROCEDURE Carga-CJE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.FchApr = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
    DISPLAY CcbCMvto.Coddoc + '-' + CcbCMvto.Nrodoc @ Fi-Mensaje LABEL "Canje Letras"
            FORMAT "X(16)" WITH FRAME F-Proceso.
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK BREAK BY CcbDMvto.tporef:
        CASE CcbDMvto.TpoRef:
           WHEN 'O' THEN DO:
              x-codcbd = ''.
              FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
                   B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
              IF AVAILABLE B-Docum THEN DO:
                 x-codcbd = B-Docum.CodCbd.
                 x-tpomov = NOT B-Docum.TpoDoc.
              END.
              FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
                   CcbCDocu.CodDoc = CcbDMvto.CodRef AND
                   CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
              IF AVAILABLE CcbCDocu THEN DO:
                 IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
                 ELSE x-codcta = B-Docum.CodCta[2].
                 x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
                 RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                     CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).
                 RUN Carga-Ajuste(x-codcbd, x-codcta, CcbDMvto.ImpDoc, x-tipo, CcbCDocu.codmon, x-glodoc).
              END.
           END.
           WHEN 'L' THEN DO:
              x-codcbd = ''.
              FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
                   B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
              IF AVAILABLE B-Docum THEN DO:
                 x-codcbd = B-Docum.CodCbd.
                 x-tpomov = NOT B-Docum.TpoDoc.
              END.
              FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
                   CcbCDocu.CodDoc = CcbDMvto.CodRef AND
                   CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
              IF AVAILABLE CcbCDocu THEN DO:
                  IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
                 ELSE x-codcta = B-Docum.CodCta[2].
                 x-codcta = IF x-codcta = '' THEN B-Docum.CodCta[1] ELSE x-codcta.
                 RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
                     CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).
              END.
           END.
        END CASE.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-N/B W-Win 
PROCEDURE Carga-N/B :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'P' THEN NEXT.
    DISPLAY CcbCMvto.Coddoc + '-' + CcbCMvto.Nrodoc @ Fi-Mensaje LABEL "Notas Banc."
            FORMAT "X(16)" WITH FRAME F-Proceso.
       FOR EACH CcbDcaja WHERE CcbDCaja.CodCia = s-codcia AND
          CcbDCaja.CodDoc = CcbCMvto.Coddoc AND 
          CcbDCaja.NroDoc = CcbCMvto.Nrodoc NO-LOCK:
          FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
               B-Docum.CodDoc = CcbDCaja.Codref NO-LOCK NO-ERROR.
          IF AVAILABLE B-Docum THEN DO:
             x-codcbd = B-Docum.CodCbd.
             x-tpomov = B-Docum.TpoDoc.
          END.
          FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
               CcbCDocu.CodDoc = CcbDCaja.Codref AND
               CcbCDocu.NroDoc = CcbDCaja.Nroref NO-LOCK NO-ERROR.
          IF AVAILABLE CcbCDocu THEN DO:
             IF CcbCDocu.FlgSit = 'D' THEN DO:
                FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
                     B-Docum.CodDoc = 'B/D' NO-LOCK NO-ERROR.
                IF AVAILABLE B-Docum THEN DO:
                   IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[3].
                   ELSE x-codcta = B-Docum.CodCta[4].
                   RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
                       CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbDCaja.tpocmb).
                   IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
                   ELSE x-codcta = B-Docum.CodCta[2].
                   RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDCaja.ImpTot, x-tipo, 
                       CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbDCaja.tpocmb).
                   END.
                END.
             ELSE DO:
               IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
               ELSE x-codcta = B-Docum.CodCta[2].
               x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
               RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
                   CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbDCaja.tpocmb).
               RUN Carga-Ajuste(x-codcbd, x-codcta, CcbDCaja.Imptot, x-tipo, CcbCDocu.codmon, x-glodoc).
               /**/
               RUN Graba-Documento(x-CodCbd, CcbCMvto.CodCta, NOT x-tpomov, CcbDCaja.ImpTot, x-tipo, 
                   CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, CcbCMvto.tpocmb).
             END.
          END.
       END.

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-P/C W-Win 
PROCEDURE Carga-P/C :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
    DISPLAY CcbCMvto.Coddoc + '-' + CcbCMvto.Nrodoc @ Fi-Mensaje LABEL "Protesto Cobranza"
            FORMAT "X(16)" WITH FRAME F-Proceso.
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK :
        x-codcbd = ''.
        FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
             B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE B-Docum THEN DO:
           x-codcbd = B-Docum.CodCbd.
           x-tpomov = B-Docum.TpoDoc.
        END.
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
             CcbCDocu.CodDoc = CcbDMvto.Codref AND
             CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
           IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
           ELSE x-codcta = B-Docum.CodCta[2].
           x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
        END.
            
        CASE x-tipo:
            WHEN 'P/C' THEN DO:
                FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
                     B-Docum.CodDoc = 'B/C' NO-LOCK NO-ERROR.
                IF AVAILABLE B-Docum THEN DO:
                   IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
                   ELSE x-codcta = B-Docum.CodCta[2].
                   x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
                END.
            END.
            WHEN 'P/G' THEN DO:
                FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
                     B-Docum.CodDoc = 'B/G' NO-LOCK NO-ERROR.
                IF AVAILABLE B-Docum THEN DO:
                   IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
                   ELSE x-codcta = B-Docum.CodCta[2].
                   x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
                END.
            END.
        END CASE.
        RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
            CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbDMvto.nroref, x-fecha, CcbCMvto.tpocmb).

        IF CcbCDocu.Codmon = 1 THEN x-codcta = FacDocum.CodCta[1].
        ELSE x-codcta = FacDocum.CodCta[2].
        x-codcta = IF x-codcta = '' THEN  FacDocum.CodCta[1] ELSE x-codcta.
        RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
            CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbDMvto.nroref, x-fecha, CcbCMvto.tpocmb).
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-P/D W-Win 
PROCEDURE Carga-P/D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
    DISPLAY CcbCMvto.Coddoc + '-' + CcbCMvto.Nrodoc @ Fi-Mensaje LABEL "Protesto Dscto."
            FORMAT "X(16)" WITH FRAME F-Proceso.
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK :
        x-codcbd = ''.
        FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
             B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE B-Docum THEN DO:
           x-codcbd = B-Docum.CodCbd.
           x-tpomov = B-Docum.TpoDoc.
        END.
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
             CcbCDocu.CodDoc = CcbDMvto.Codref AND
             CcbCDocu.NroDoc = CcbDMvto.NroRef NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
           IF CcbCDocu.Codmon = 1 THEN x-codcta = FacDocum.CodCta[1].
           ELSE x-codcta = FacDocum.CodCta[2].
           x-codcta = IF x-codcta = '' THEN  FacDocum.CodCta[1] ELSE x-codcta.
           RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
               CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbDMvto.nroref, x-fecha, CcbCMvto.tpocmb).
        END.
    END.
    RUN Graba-Documento(x-CodCbd, x-ctagas, FALSE, CcbCMvto.ImpInt,
        x-tipo, CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, '', x-fecha, CcbCMvto.tpocmb).           
    RUN Graba-Documento(x-CodCbd, CcbCMvto.CodCta, TRUE, (CcbCMvto.ImpInt + CcbCMvto.ImpTot),
        x-tipo, CcbCMvto.codmon, CcbCMvto.codmon, x-glodoc, '', x-fecha, CcbCMvto.tpocmb).           
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ret W-Win 
PROCEDURE Carga-Ret :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.
DEFINE VAR x-Factor AS INT INIT 1 NO-UNDO.

FOR EACH CcbDcaja WHERE CcbDCaja.CodCia = s-codcia AND
        CcbDCaja.CodDoc = 'RET' AND CcbDCaja.FchDoc = x-fecha NO-LOCK,
        FIRST CcbCDocu WHERE ccbcdocu.codcia = ccbdcaja.codcia
            AND ccbcdocu.coddoc = ccbdcaja.codref
            AND ccbcdocu.nrodoc = ccbdcaja.nroref NO-LOCK:
    DISPLAY CcbDCaja.CodDoc + '-' + CcbDCaja.NroDoc @ Fi-Mensaje LABEL "Retenciones IGV"
            FORMAT "X(16)" WITH FRAME F-Proceso.
    FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
         B-Docum.CodDoc = 'RET' NO-LOCK NO-ERROR.
    IF AVAILABLE B-Docum 
    THEN ASSIGN
            x-codcbd = B-Docum.CodCbd
            x-tpomov = B-Docum.TpoDoc
            x-codcta = B-Docum.CodCta[1].
    FIND B-CDocu WHERE B-CDocu.CodCia = CcbDCaja.codcia AND
         B-CDocu.CodDoc = CcbDCaja.CodDoc AND
         B-CDocu.NroDoc = CcbDCaja.NroDoc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN NEXT.
    x-Factor = 1.
    IF B-CDocu.CodRef = 'N/C' THEN DO:
        x-Factor = -1.
        x-TpoMov = IF x-TpoMov = Yes THEN No ELSE Yes.
    END.
    RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
        01, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, 0, B-CDocu.CodDiv).
    /**/
    FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = S-CODCIA AND
                        Cb-cfgrv.CodDiv = CcbCdocu.Coddiv AND
                        Cb-cfgrv.Coddoc = CcbCdocu.Coddoc AND
                        Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo AND
                        Cb-cfgrv.Codmon = Ccbcdocu.Codmon 
                        NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" 
     THEN DO:
       MESSAGE 'Cuenta No Configurada Para ' + CcbCDocu.Coddoc + ' ' + CcbCDocu.Nrodoc  VIEW-AS ALERT-BOX.
       NEXT .
     END.
     X-codcta = Cb-cfgrv.Codcta .       
    FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
         B-Docum.CodDoc = CcbDcaja.Codref NO-LOCK NO-ERROR.
    IF AVAILABLE B-Docum 
    THEN ASSIGN
            x-codcbd = B-Docum.CodCbd
            x-tpomov = B-Docum.TpoDoc.
    RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
        CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nroref, x-fecha, CcbDCaja.tpocmb, CcbCDocu.CodDiv).
END.
END PROCEDURE.

/* PROGRAMA ANTERIOR
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbDcaja WHERE CcbDCaja.CodCia = s-codcia AND
        CcbDCaja.CodDoc = 'RET' AND CcbDCaja.FchDoc = x-fecha NO-LOCK:
    DISPLAY CcbDCaja.CodDoc + '-' + CcbDCaja.NroDoc @ Fi-Mensaje LABEL "Retenciones IGV"
            FORMAT "X(16)" WITH FRAME F-Proceso.

    FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
         B-Docum.CodDoc = 'RET' NO-LOCK NO-ERROR.
    IF AVAILABLE B-Docum THEN DO:
       x-codcbd = B-Docum.CodCbd.
       x-tpomov = B-Docum.TpoDoc.
       x-codcta = B-Docum.CodCta[1].
    END.

    FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
         CcbCDocu.CodDoc = CcbDCaja.CodDoc AND
         CcbCDocu.NroDoc = CcbDCaja.NroDoc NO-LOCK NO-ERROR.

    RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
        01, CcbDcaja.codmon, x-glodoc, CcbDCaja.nrodoc, x-fecha, 0).
    /**/

    FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
         CcbCDocu.CodDoc = CcbDCaja.CodRef AND
         CcbCDocu.NroDoc = CcbDCaja.Nroref NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
       FIND Cb-cfgrv WHERE Cb-cfgrv.Codcia = S-CODCIA AND
                           Cb-cfgrv.CodDiv = CcbCdocu.Coddiv AND
                           Cb-cfgrv.Coddoc = CcbCdocu.Coddoc AND
                           Cb-cfgrv.Fmapgo = Ccbcdocu.Fmapgo AND
                           Cb-cfgrv.Codmon = Ccbcdocu.Codmon 
                           NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Cb-cfgrv OR Cb-cfgrv.Codcta = "" THEN DO:
          MESSAGE 'Cuenta No Configurada Para ' + CcbCDocu.Coddoc + ' ' + CcbCDocu.Nrodoc  VIEW-AS ALERT-BOX.
          NEXT .
        END.
        X-codcta = Cb-cfgrv.Codcta .       
    END.
    
    FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
         B-Docum.CodDoc = CcbDcaja.Codref NO-LOCK NO-ERROR.
    IF AVAILABLE B-Docum THEN DO:
       x-codcbd = B-Docum.CodCbd.
       x-tpomov = B-Docum.TpoDoc.
    END.

    RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbDCaja.ImpTot, x-tipo, 
        CcbCDocu.codmon, CcbDcaja.codmon, x-glodoc, CcbDCaja.nroref, x-fecha, CcbDCaja.tpocmb).
END.
******************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-RNV W-Win 
PROCEDURE Carga-RNV :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER X-Tipo  AS CHAR.
DEFINE INPUT PARAMETER X-fecha AS DATE.
DEFINE INPUT PARAMETER X-glodoc AS CHAR.

DEFINE VAR x-codcta AS CHAR NO-UNDO.
DEFINE VAR x-tpomov AS LOGI NO-UNDO.
DEFINE VAR x-codcbd AS CHAR NO-UNDO.

FOR EACH CcbCMvto WHERE CcbCMvto.codcia = s-codcia AND
    CcbCMvto.Coddoc = X-Tipo AND CcbCMvto.Fchdoc = x-fecha NO-LOCK:
    IF CcbCMvto.FlgEst <> 'E' THEN NEXT.
    DISPLAY CcbCMvto.Coddoc + '-' + CcbCMvto.Nrodoc @ Fi-Mensaje LABEL "Renovacion"
            FORMAT "X(16)" WITH FRAME F-Proceso.
    FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
         B-Docum.CodDoc = 'LET' NO-LOCK NO-ERROR.
    IF AVAILABLE B-Docum THEN DO:
       x-codcbd = B-Docum.CodCbd.
       x-tpomov = B-Docum.TpoDoc.
    END.
    FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
         CcbCDocu.CodDoc = 'LET' AND
         CcbCDocu.NroDoc = CcbCMvto.NroRef NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
       IF CcbCDocu.Codmon = 1 THEN x-codcta = B-Docum.CodCta[1].
       ELSE x-codcta = B-Docum.CodCta[2].
       x-codcta = IF x-codcta = '' THEN  B-Docum.CodCta[1] ELSE x-codcta.
    END.
    RUN Graba-Documento(x-CodCbd, x-codcta, x-tpomov, CcbCMvto.ImpTot, x-tipo, 
        CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbCDocu.nrodoc, x-fecha, CcbCMvto.tpocmb).
    
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = s-codcia AND
        CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
        CcbDMvto.NroDoc = CcbCMvto.NroDoc NO-LOCK :
        x-codcbd = ''.
        FIND B-Docum WHERE B-Docum.CodCia = s-codcia AND
             B-Docum.CodDoc = CcbDMvto.CodRef NO-LOCK NO-ERROR.
        IF AVAILABLE B-Docum THEN DO:
           x-codcbd = B-Docum.CodCbd.
           x-tpomov = B-Docum.TpoDoc.
        END.
        RUN Graba-Documento(x-CodCbd, x-codcta, NOT x-tpomov, CcbDMvto.ImpDoc, x-tipo, 
            CcbCDocu.codmon, CcbCMvto.codmon, x-glodoc, CcbDMvto.nroref, x-fecha, CcbCMvto.tpocmb).
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      Transferencia de movimientos correspondientes a cuentas por cobrar
------------------------------------------------------------------------------*/
DEFINE VAR i AS DATE NO-UNDO.
FOR EACH t-prev:
  DELETE t-prev.
END.

DO i = x-fchini TO x-fchfin:
   FOR EACH FacDocum WHERE FacDocum.CodCia = s-codcia NO-LOCK:
       IF FacDocum.FlgCbd THEN DO:
          x-codope = FacDocum.codope.
          CASE FacDocum.CodDoc:
             /*
             WHEN 'CJE' THEN RUN Carga-CJE (FacDocum.CodDoc, i, FacDocum.NomDoc). 
             WHEN 'B/D' THEN RUN Carga-B/D (FacDocum.Coddoc, i, FacDocum.nomdoc).
             WHEN 'B/C' OR WHEN 'B/G' THEN RUN Carga-B/C (FacDocum.Coddoc, i, FacDocum.nomdoc).
             WHEN 'RNV' THEN RUN Carga-RNV (FacDocum.Coddoc, i, FacDocum.nomdoc).
             WHEN 'P/C' OR WHEN 'P/G' THEN RUN Carga-P/C (FacDocum.Coddoc, i, FacDocum.nomdoc).
             WHEN 'P/D' THEN RUN Carga-P/D (FacDocum.Coddoc, i, FacDocum.nomdoc).
             WHEN 'ASG' THEN RUN Carga-ASG (FacDocum.Coddoc, i, FacDocum.nomdoc).             
             WHEN 'N/B' THEN RUN Carga-N/B (FacDocum.Coddoc, i, FacDocum.nomdoc).             
             */
             WHEN 'RET' THEN RUN Carga-Ret (FacDocum.Coddoc, i, FacDocum.nomdoc).             
          END CASE.
       END.
   END.    
END.
HIDE FRAME F-Proceso.

RUN Abrir-Browse IN h_b-ccbcbd (INPUT SUBSTRING(ENTRY(1,x-list),1,3)).
RUN Totales IN h_b-ccbcbd.

FIND FIRST t-prev NO-LOCK NO-ERROR.
IF AVAILABLE t-prev THEN
   RUN dispatch IN h_p-updv10 ('view':U).
ELSE
   RUN dispatch IN h_p-updv10 ('hide':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY C-Tipo P-periodo P-Mes F-Tpocmb 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-42 P-periodo P-Mes F-Tpocmb B-filtro 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Documento W-Win 
PROCEDURE Graba-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER X-codcbd  AS CHAR.
 DEFINE INPUT PARAMETER X-codcta  AS CHAR.
 DEFINE INPUT PARAMETER X-tpomov  AS LOGICAL.
 DEFINE INPUT PARAMETER X-importe AS DECIMAL.
 DEFINE INPUT PARAMETER X-tipo    AS CHAR.
 DEFINE INPUT PARAMETER X-monori  AS INTEGER.
 DEFINE INPUT PARAMETER X-codmon  AS INTEGER.
 DEFINE INPUT PARAMETER X-glodoc  AS CHAR.
 DEFINE INPUT PARAMETER X-nrodoc  AS CHAR.
 DEFINE INPUT PARAMETER X-fchdoc  AS DATE.
 DEFINE INPUT PARAMETER X-tpocmb  AS DECIMAL.
 DEFINE INPUT PARAMETER x-CodDiv  AS CHAR.
 
  IF x-CodCbd = '20' THEN DO:       /* Comprobante de retencion */
    FIND t-prev WHERE t-prev.tipo = x-tipo
        AND t-prev.codope = x-codope
        AND t-prev.coddiv = x-coddiv
        AND t-prev.codmon = x-monori
        AND t-prev.codcta = x-codcta
        AND t-prev.tpomov = x-tpomov
        AND t-prev.codaux = Ccbcdocu.ruc
        AND t-prev.coddoc = x-codcbd
        AND t-prev.nrodoc = x-nrodoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE t-prev THEN CREATE t-prev.
  END.
  ELSE CREATE t-prev.
/*  CREATE t-prev.*/
  ASSIGN
    t-prev.tipo    = x-tipo
    t-prev.periodo = p-periodo
    t-prev.nromes  = p-mes
    t-prev.codope  = x-codope
    t-prev.coddiv  = x-CodDiv 
    t-prev.codmon  = x-monori
    t-prev.codcta  = x-codcta
    t-prev.fchdoc  = x-fchdoc 
    t-prev.tpomov  = x-tpomov
    t-prev.clfaux  = '@CL'
    t-prev.codaux  = Ccbcdocu.Ruc
    t-prev.coddoc  = X-CodCbd
    t-prev.nrodoc  = x-NroDoc.
    
 IF x-CodMon = 1 THEN
    ASSIGN
       t-prev.impmn1  = t-prev.impmn1 + x-importe
       t-prev.impmn2  = t-prev.impmn2 + ROUND((x-importe / x-TpoCmb),2).
 ELSE 
    ASSIGN
       t-prev.impmn2  = t-prev.impmn2 + x-importe
       t-prev.impmn1  = t-prev.impmn1 + ROUND((x-importe * x-TpoCmb),2).


 ASSIGN
    t-prev.Tpocmb  = x-TpoCmb
    t-prev.glodoc  = x-glodoc.
 
    t-prev.impmn2 = IF x-monori = 1 then 0 else t-prev.impmn2.
 
 RELEASE t-prev.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Documento-Back W-Win 
PROCEDURE Graba-Documento-Back :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER X-codcbd  AS CHAR.
 DEFINE INPUT PARAMETER X-codcta  AS CHAR.
 DEFINE INPUT PARAMETER X-tpomov  AS LOGICAL.
 DEFINE INPUT PARAMETER X-importe AS DECIMAL.
 DEFINE INPUT PARAMETER X-tipo    AS CHAR.
 DEFINE INPUT PARAMETER X-monori  AS INTEGER.
 DEFINE INPUT PARAMETER X-codmon  AS INTEGER.
 DEFINE INPUT PARAMETER X-glodoc  AS CHAR.
 DEFINE INPUT PARAMETER X-nrodoc  AS CHAR.
 DEFINE INPUT PARAMETER X-fchdoc  AS DATE.
 DEFINE INPUT PARAMETER X-tpocmb  AS DECIMAL.
 
 CREATE t-prev.
 ASSIGN
    t-prev.tipo    = x-tipo
    t-prev.periodo = p-periodo
    t-prev.nromes  = p-mes
    t-prev.codope  = x-codope
    t-prev.coddiv  = CcbCDocu.CodDiv 
    t-prev.codmon  = x-monori
    t-prev.codcta  = x-codcta
    t-prev.fchdoc  = x-fchdoc 
    t-prev.tpomov  = x-tpomov
    t-prev.clfaux  = '@CL'
    t-prev.codaux  = IF LOOKUP(X-CodCbd, '01 ,03 ') > 0 THEN FacCfgGn.CliVar ELSE CcbCDocu.Codcli
    t-prev.coddoc  = X-CodCbd
    t-prev.nrodoc  = x-NroDoc.
    
 IF x-CodMon = 1 THEN
    ASSIGN
       t-prev.impmn1  = t-prev.impmn1 + x-importe
       t-prev.impmn2  = t-prev.impmn2 + ROUND((x-importe / x-TpoCmb),2).
 ELSE 
    ASSIGN
       t-prev.impmn2  = t-prev.impmn2 + x-importe
       t-prev.impmn1  = t-prev.impmn1 + ROUND((x-importe * x-TpoCmb),2).
 ASSIGN
    t-prev.Tpocmb  = x-TpoCmb
    t-prev.glodoc  = x-glodoc.
 RELEASE t-prev.
 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR I-nroitm  AS INTEGER NO-UNDO.
DEFINE VAR x-debe    AS DECIMAL NO-UNDO.
DEFINE VAR x-haber   AS DECIMAL NO-UNDO.
DEFINE VAR x-dolares AS DECIMAL NO-UNDO.
DEFINE VAR x-nommes  AS CHAR    NO-UNDO.
DEFINE VAR x-opera   AS CHAR    NO-UNDO.
RUN bin/_mes.p(P-Mes, 1, OUTPUT x-nommes).

DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 99 TODAY SKIP(1)
    {&PRN6A} + "CUENTAS POR COBRAR" + {&PRN6B} + {&PRND} AT 50 FORMAT "X(45)" SKIP(1)
    "Operacion      : " x-opera FORMAT 'X(40)' SKIP
    "Mes            : " x-nommes SPACE(10) "Tipo de cambio : " AT 95 F-tpocmb SKIP
    "------------------------------------------------------------------------------------------------------------------------------" SKIP
    "           CUENTA   CLF  CODIGO   COD.  NUMERO                                             TIP               S O L E S        " SKIP
    "DIVISION  CONTABLE  AUX AUXILIAR  DOC. DOCUMENTO     C O N C E P T O                   US$ MOV           DEBE          HABER  " SKIP
    "------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-Detalle
    I-NroItm       AT 1   FORMAT ">>9" 
    t-prev.coddiv  
    t-prev.codcta  
    t-prev.clfaux  
    t-prev.codaux
    t-prev.coddoc
    t-prev.nrodoc
    t-prev.glodoc
    x-dolares FORMAT ">>>,>>9.99" 
    t-prev.tpomov
    x-debe  FORMAT ">>>>,>>>,>>9.99" 
    x-haber FORMAT ">>>>,>>>,>>9.99" 
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 

/*MLR* 15/11/07 ***
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.
* ***/

I-NroItm = 0.
FOR EACH t-prev BREAK BY t-prev.tipo BY t-prev.coddiv:
    x-opera = ''.
    FIND cb-oper WHERE cb-oper.CodCia = cb-codcia AND
         cb-oper.Codope = t-prev.codope NO-LOCK NO-ERROR.
    IF AVAILABLE cb-oper THEN 
       x-opera = cb-oper.codope + ' - ' + cb-oper.Nomope.
    VIEW FRAME F-Header.
    IF FIRST-OF(t-prev.tipo) THEN  I-Nroitm = 0.
    I-Nroitm = I-Nroitm + 1.
    x-debe   = 0.
    x-haber  = 0.
    x-dolares = t-prev.impmn2.
    IF t-prev.tpomov THEN x-haber = t-prev.impmn1.
    ELSE x-debe = t-prev.impmn1.
    ACCUMULATE x-debe (TOTAL BY t-prev.tipo).
    ACCUMULATE x-haber (TOTAL BY t-prev.tipo).
    DISPLAY 
        I-NroItm       AT 1   FORMAT ">>9" 
        t-prev.coddiv  
        t-prev.codcta  
        t-prev.clfaux  
        t-prev.codaux
        t-prev.coddoc
        t-prev.nrodoc
        t-prev.glodoc
        x-dolares 
        t-prev.tpomov
        x-debe  WHEN x-debe <> 0
        x-haber WHEN x-haber <> 0
        WITH FRAME F-Detalle.
    IF LAST-OF(t-prev.tipo) THEN DO:
        UNDERLINE 
            x-debe
            x-haber
            WITH FRAME F-Detalle.
        DISPLAY 
            "        TOTAL "    @ t-prev.glodoc
            ACCUM TOTAL BY t-prev.tipo x-debe  @ x-debe
            ACCUM TOTAL BY t-prev.tipo x-haber @ x-haber
            WITH FRAME F-Detalle.
        PAGE.
    END.
END.    

/*MLR* 15/11/07 ***
OUTPUT CLOSE.
* ***/

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
       cb-cfgg.Codcfg = 'GAS' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN
     ASSIGN
        x-ctagas = cb-cfgg.codcta[1].
  ELSE DO:
     MESSAGE 'Configuracion de Cuentas de Gastos no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'INT' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN
     ASSIGN
        x-ctaint = cb-cfgg.codcta[1].
  ELSE DO:
     MESSAGE 'Configuracion de Cuentas de Intereses no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'PRO' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN
     ASSIGN
        x-ctapro = cb-cfgg.codcta[1].
  ELSE DO:
     MESSAGE 'Configuracion de Cuentas de Protesto no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia  NO-LOCK NO-ERROR.
  
  RUN dispatch IN h_p-updv10 ('hide':U).
  
  FOR EACH FacDocum WHERE FacDocum.CodCia = s-codcia AND
      FacDocum.FlgCbd AND LOOKUP(FacDocum.CodDoc, 'FAC,BOL,N/C,N/D') = 0 NO-LOCK:
      IF x-list = '' THEN x-list = FacDocum.CodDoc + '-' + FacDocum.NomDoc.
      ELSE x-list = x-list + ',' + FacDocum.CodDoc + '-' + FacDocum.NomDoc.
  END.

  DO WITH FRAME {&FRAME-NAME}:
     C-Tipo:LIST-ITEMS = x-list.
     C-Tipo:SCREEN-VALUE = ENTRY(1,x-list).
     DISPLAY 
        YEAR(TODAY) @ P-periodo.
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
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
        END CASE.
        PUT CONTROL {&Prn0} {&Prn5A} CHR(66) {&Prn3}.
        RUN Imprimir.
        PAGE.
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferir-asiento W-Win 
PROCEDURE Transferir-asiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR p-codcia  AS INTE NO-UNDO.
DEFINE VAR p-codope  AS CHAR NO-UNDO.
DEFINE VAR p-nroast  AS CHAR NO-UNDO.
DEFINE VAR x-nroast  AS INTE NO-UNDO.
DEFINE VAR p-fchast  AS DATE NO-UNDO.
DEFINE VAR d-uno     AS DECI NO-UNDO.
DEFINE VAR d-dos     AS DECI NO-UNDO.
DEFINE VAR h-uno     AS DECI NO-UNDO.
DEFINE VAR h-dos     AS DECI NO-UNDO.
DEFINE VAR x-clfaux  AS CHAR NO-UNDO.
DEFINE VAR x-genaut  AS INTE NO-UNDO.
DEFINE VAR I         AS INTE NO-UNDO.
DEFINE VAR J         AS INTE NO-UNDO.
DEFINE VAR x-coddoc  AS LOGI NO-UNDO.

DEFINE BUFFER detalle FOR CB-DMOV.

p-codcia  = s-codcia.

FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
   BELL.
   MESSAGE "No se ha generado " SKIP "ning£n preasiento" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
   BELL.
   MESSAGE "Plan de cuentas no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

/* Limpio la informaci¢n de los movimientos transferidos anteriormente
   a contabilidad                                                   */
 FIND FIRST cb-control WHERE cb-control.tipo = '@CCB' AND
     cb-control.CodCia  = s-codcia AND
     cb-control.periodo = P-periodo AND
     cb-control.nromes  = P-Mes NO-LOCK NO-ERROR.
 IF AVAILABLE cb-control THEN DO:
    MESSAGE
        "Asientos contables del mes ya existen "  SKIP
        "        ¨Desea reemplazarlo? "
        VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE sigue AS LOGICAL.
    IF NOT sigue THEN RETURN.
 END.
 FOR EACH cb-control WHERE cb-control.tipo = '@CCB' AND
     cb-control.CodCia  = s-codcia AND
     cb-control.periodo = P-periodo AND
     cb-control.nromes  = P-Mes NO-LOCK :
     FIND cb-cmov WHERE
          cb-cmov.codcia  = p-codcia AND
          cb-cmov.PERIODO = p-periodo AND
          cb-cmov.NROMES  = p-mes AND
          cb-cmov.CODOPE  = cb-control.codope AND
          cb-cmov.NROAST  = cb-control.nroast NO-ERROR.
     IF AVAILABLE cb-cmov THEN 
        RUN anula-asto(
            p-codcia,
            p-periodo,
            p-mes,
            cb-control.codope,
            cb-control.nroast ).
     /* Elimino la informacion del temporal */
     RUN anula-temporal(
         p-codcia,
         p-periodo,
         p-mes,
         cb-control.codope,
         cb-control.nroast ).
 END.   
   
FOR EACH t-prev BREAK BY t-prev.tipo BY t-prev.coddiv:
    IF FIRST-OF(t-prev.tipo) THEN DO:
       /* Verifico si el movimiento se realiz¢ anteriormente */
       FIND cb-control WHERE cb-control.tipo = '@CCB' AND
            cb-control.CodCia  = s-codcia AND
            cb-control.tipmov  = t-prev.tipo AND 
            cb-control.periodo = P-periodo AND
            cb-control.nromes  = P-Mes NO-ERROR.
       IF AVAILABLE cb-control THEN 
          ASSIGN
             p-Codope = cb-control.Codope 
             p-nroast = cb-control.Nroast.
       ELSE DO:
          p-codope = t-prev.codope.
          RUN cbd/cbdnast.p(cb-codcia,
                            p-codcia, 
                            p-periodo, 
                            p-Mes, 
                            p-codope, 
                            OUTPUT x-nroast). 
          p-nroast = STRING(x-nroast, '999999').
          CREATE cb-control.
          ASSIGN
             cb-control.tipo    = '@CCB'
             cb-control.CodCia  = p-codcia
             cb-control.Periodo = p-periodo
             cb-control.Nromes  = p-mes 
             cb-control.Codope  = p-Codope
             cb-control.Nroast  = p-nroast
             cb-control.tipmov  = t-prev.tipo.
       END.
       ASSIGN
          cb-control.Usuario = s-user-id
          cb-control.Hora    = STRING(TIME,'HH:MM:SS')
          cb-control.fecha   = TODAY.
       d-uno  = 0.
       d-dos  = 0.
       h-uno  = 0.
       h-dos  = 0.
    END.
    FIND cb-ctas WHERE
        cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN NEXT.
    x-clfaux = cb-ctas.clfaux.
    x-coddoc = cb-ctas.piddoc.
    IF t-prev.impmn1 > 0 OR t-prev.impmn2 > 0 THEN DO:
        J = J + 1.
        CREATE CB-DMOV.
        CB-DMOV.codcia  = p-codcia.
        CB-DMOV.PERIODO = p-periodo.
        CB-DMOV.NROMES  = p-mes.
        CB-DMOV.CODOPE  = p-codope.
        CB-DMOV.NROAST  = p-nroast.
        CB-DMOV.NROITM  = J.
        CB-DMOV.codcta  = t-prev.codcta.
        CB-DMOV.coddiv  = t-prev.coddiv.
        Cb-dmov.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.
        Cb-dmov.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.
        CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        CB-DMOV.GLODOC  = t-prev.glodoc.
        CB-DMOV.tpomov  = t-prev.tpomov.
        CB-DMOV.impmn1  = t-prev.impmn1.
        CB-DMOV.impmn2  = t-prev.impmn2.
        CB-DMOV.FCHDOC  = t-prev.fchdoc.
        CB-DMOV.FCHVTO  = t-prev.fchdoc.
        CB-DMOV.FLGACT  = TRUE.
        CB-DMOV.RELACION = 0.
        CB-DMOV.codmon  = t-prev.codmon.
        CB-DMOV.tpocmb  = t-prev.tpocmb.
        RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
        IF CB-DMOV.tpomov THEN DO:
            h-uno = h-uno + CB-DMOV.impmn1.
            h-dos = h-dos + CB-DMOV.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + CB-DMOV.impmn1.
            d-dos = d-dos + CB-DMOV.impmn2.
        END.

        /* Cargamos la tabla temporal */
        CREATE T-CB-DMOV.
        T-CB-DMOV.codcia  = p-codcia.
        T-CB-DMOV.PERIODO = p-periodo.
        T-CB-DMOV.NROMES  = p-mes.
        T-CB-DMOV.CODOPE  = p-codope.
        T-CB-DMOV.NROAST  = p-nroast.
        T-CB-DMOV.NROITM  = J.
        T-CB-DMOV.codcta  = t-prev.codcta.
        T-CB-DMOV.coddiv  = t-prev.coddiv.
        T-CB-DMOV.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.
        T-CB-DMOV.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.
        T-CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        T-CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        T-CB-DMOV.GLODOC  = t-prev.glodoc.
        T-CB-DMOV.tpomov  = t-prev.tpomov.
        T-CB-DMOV.impmn1  = t-prev.impmn1.
        T-CB-DMOV.impmn2  = t-prev.impmn2.
        T-CB-DMOV.FCHDOC  = t-prev.fchdoc.
        T-CB-DMOV.FCHVTO  = t-prev.fchdoc.
        T-CB-DMOV.FLGACT  = TRUE.
        T-CB-DMOV.RELACION = 0.
        T-CB-DMOV.codmon  = t-prev.codmon.
        T-CB-DMOV.tpocmb  = t-prev.tpocmb.

        x-GenAut = 0.
        /* Preparando para Autom ticas */
        /* Verificamos si la Cuenta genera automaticas de Clase 9 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
                    x-GenAut = 1.
                    LEAVE.
                END.
            END.
        END.
        /* Verificamos si la Cuenta genera automaticas de Clase 6 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
                    x-GenAut = 2.
                    LEAVE.
                END.
           END.
        END.
        /* Verificamos si la Cuenta genera automaticas de otro tipo */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
                    x-GenAut = 3.
                    LEAVE.
                END.
           END.
        END.
        cb-dmov.CtaAut = "".
        cb-dmov.CtrCta = "".
        CASE x-GenAut:
            /* Genera Cuentas Clase 9 */
            WHEN 1 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
            END.
            /* Genera Cuentas Clase 6 */
            WHEN 2 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN
                    cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
            END.
            WHEN 3 THEN DO:
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            END.
        END CASE.
        /* Chequendo las cuentas a generar en forma autom tica */
        IF x-GenAut > 0 THEN DO:
            IF NOT CAN-FIND(FIRST cb-ctas WHERE
                cb-ctas.CodCia = cb-codcia AND
                cb-ctas.CodCta = cb-dmov.CtaAut) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Cuenta" cb-dmov.CtaAut "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtaAut = "".
            END.
            IF NOT CAN-FIND( cb-ctas WHERE
                cb-ctas.CodCia = cb-codcia AND
                cb-ctas.CodCta = cb-dmov.CtrCta ) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Contra Cuenta" cb-dmov.CtrCta "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtrCta = "".
            END.
        END. /*Fin del x-genaut > 0 */
        IF cb-dmov.CtaAut <> "" AND cb-dmov.CtrCta <> "" THEN DO:
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.CtaAut.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = cb-dmov.TpoMov.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.Ctrcta.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = NOT cb-dmov.TpoMov.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
    END.
    IF LAST-OF(t-prev.tipo) THEN DO:
       FIND cb-cmov WHERE
           cb-cmov.codcia  = p-codcia AND
           cb-cmov.PERIODO = p-periodo AND
           cb-cmov.NROMES  = p-mes AND
           cb-cmov.CODOPE  = p-codope AND
           cb-cmov.NROAST  = p-nroast NO-ERROR.
       IF NOT AVAILABLE cb-cmov THEN DO:
           CREATE cb-cmov.
           cb-cmov.codcia  = p-codcia.
           cb-cmov.PERIODO = p-periodo.
           cb-cmov.NROMES  = p-mes.
           cb-cmov.CODOPE  = p-codope.
           cb-cmov.NROAST  = p-nroast. 
       END.
       cb-cmov.Coddiv = t-prev.coddiv.
       cb-cmov.Fchast = x-fchfin.
       cb-cmov.TOTITM = J.
       cb-cmov.CODMON = 1.
       cb-cmov.TPOCMB = F-Tpocmb.
       cb-cmov.DBEMN1 = d-uno.
       cb-cmov.DBEMN2 = d-dos.
       cb-cmov.HBEMN1 = h-uno.
       cb-cmov.HBEMN2 = h-dos.
       cb-cmov.NOTAST = t-prev.glodoc.
       cb-cmov.GLOAST = t-prev.glodoc.
    END.
END.
RUN Actualiza-Flag.
MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


