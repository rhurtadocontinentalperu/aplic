&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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

DEFINE NEW SHARED TEMP-TABLE t-prev
    FIELD Tipo    AS CHAR
    FIELD Banco   LIKE cb-dmov.CodBco
    FIELD Periodo LIKE cb-dmov.periodo
    FIELD NroMes LIKE cb-dmov.nromes
    FIELD Codope LIKE cb-dmov.codope
    FIELD Codcta LIKE cb-dmov.codcta
    FIELD CodDiv LIKE cb-dmov.coddiv
    FIELD Codmon LIKE cb-dmov.codmon
    FIELD Fchdoc LIKE cb-dmov.fchdoc
    FIELD Fchvto LIKE cb-dmov.fchvto
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

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VAR s-NroMesCie AS LOGICAL INITIAL YES.
DEFINE VAR x-tpocmb AS DECI NO-UNDO.
DEFINE VAR x-periodo AS INTEGER NO-UNDO.
DEFINE VAR x-nromes  AS INTEGER NO-UNDO.
DEFINE VAR x-codcta  AS CHAR    NO-UNDO.

DEFINE VAR x-tpomov  AS LOGICAL NO-UNDO.
/*DEFINE VAR x-codcbd  AS CHAR    NO-UNDO.
DEFINE VAR x-glodoc  AS CHAR    NO-UNDO.*/

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
&Scoped-Define ENABLED-OBJECTS RECT-42 F-Fecha B-filtro 
&Scoped-Define DISPLAYED-OBJECTS F-Fecha F-Tpocmb 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cjacb2 AS HANDLE NO-UNDO.
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

DEFINE VARIABLE F-Fecha AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Fecha de Autorizacion" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-Tpocmb AS DECIMAL FORMAT ">>9.999":U INITIAL 0 
     LABEL "Tpo.Cambio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56.72 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Fecha AT ROW 3.19 COL 21.43 COLON-ALIGNED
     F-Tpocmb AT ROW 3.19 COL 43.72 COLON-ALIGNED
     B-filtro AT ROW 2.46 COL 64.29
     B-Transferir AT ROW 2.42 COL 72.14
     B-Imprimir AT ROW 2.42 COL 80.29
     RECT-42 AT ROW 2.62 COL 4
     "BOLETAS  DE  DEPOSITO" VIEW-AS TEXT
          SIZE 35 BY .85 AT ROW 1.31 COL 28.86
          FONT 12
     "Pre-asiento" VIEW-AS TEXT
          SIZE 8.14 BY .65 AT ROW 4.08 COL 63.43
     "Tranferir" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 4 COL 72.57
     "Asiento" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 4.54 COL 73.14
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
         HEIGHT             = 13.73
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
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
/* SETTINGS FOR BUTTON B-Imprimir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON B-Transferir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Tpocmb IN FRAME F-Main
   NO-ENABLE                                                            */
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
     F-Fecha F-Tpocmb.

  IF F-Fecha = ?  THEN DO:
     MESSAGE 'Fecha no registrada' VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO F-Fecha.
     RETURN NO-APPLY.
  END.
  
  x-periodo = YEAR(F-Fecha).
  x-nromes  = MONTH(F-Fecha).
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                     cb-peri.Periodo = x-periodo NO-LOCK.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[x-nromes + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

  FIND FIRST cb-control WHERE 
             cb-control.CodCia = s-codcia AND
             cb-control.tipo   = '@CJ3' AND
             cb-control.fchpro = INPUT F-Fecha  NO-LOCK NO-ERROR.
  IF AVAILABLE cb-control THEN DO:
     MESSAGE "Asiento contable ha sido generado" SKIP
             "Desea reprocesarlo? " VIEW-AS ALERT-BOX WARNING
             BUTTONS YES-NO UPDATE sigue AS LOGICAL.
     IF NOT sigue THEN RETURN.
  END.
 
  RUN Carga-Temporal.
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
                     cb-peri.Periodo = x-Periodo NO-LOCK.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[x-nromes + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

  RUN Transferir-asiento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha W-Win
ON LEAVE OF F-Fecha IN FRAME F-Main /* Fecha de Autorizacion */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN F-fecha.
     FIND gn-tcmb WHERE gn-tcmb.fecha = F-fecha NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN
        ASSIGN
           x-tcajus = gn-tcmb.compra
           x-tvajus = gn-tcmb.venta.
     ELSE DO:
        MESSAGE 'No existe tipo de cambio ' VIEW-AS ALERT-BOX.
        APPLY 'ENTRY':U TO F-Fecha.
        RETURN NO-APPLY.
     END.
     x-tpocmb = gn-tcmb.venta.
     DISPLAY 
        gn-tcmb.venta @ F-Tpocmb.
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
/*FIND cb-control WHERE cb-control.CodCia  = s-codcia  AND
     cb-control.tipo = '@CJ3' AND
     cb-control.fchpro  = F-Fecha  NO-LOCK NO-ERROR.
IF AVAILABLE cb-control THEN 
   FOR EACH CcbBolDep WHERE CcbBolDep.CodCia = s-codcia AND
      CcbBolDep.Coddoc = 'BD' AND CcbBolDep.FchAut = F-Fecha NO-LOCK:
      IF CcbBolDep.FlgEst = 'A' THEN NEXT.
      ASSIGN
         CcbBolDep.FlgCbd = TRUE
         CcbBolDep.FchCbd = TODAY
         CcbBolDep.Codope = cb-control.Codope 
         CcbBolDep.NroMes = cb-control.Nromes 
         CcbBolDep.Nroast = cb-control.Nroast.
       RELEASE CcbBolDep.
   END.
*/  
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
  DEFINE VARIABLE adm-current-page AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-cjacb2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cjacb2 ).
       RUN set-position IN h_b-cjacb2 ( 5.23 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 9.23 , 87.57 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv10.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 12.88 , 2.57 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.69 , 45.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cjacb2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-cjacb2 ).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      Transferencia de movimientos correspondientes a cuentas por cobrar
------------------------------------------------------------------------------*/
DEFINE VAR x-coddoc AS CHAR NO-UNDO.
x-coddoc = 'EFE'.
FOR EACH t-prev:
  DELETE t-prev.
END.

FOR EACH CcbBolDep WHERE 
         CcbBolDep.CodCia = s-codcia AND
         CcbBolDep.Coddoc = 'BD'     AND 
         CcbBolDep.FchAut = F-Fecha NO-LOCK:
    IF CcbBolDep.FlgEst = 'A' THEN NEXT.
    DISPLAY CcbBolDep.NroDoc @ Fi-Mensaje LABEL "Boletas de Deposito"
            FORMAT "X(16)" WITH FRAME F-Proceso.
    IF CcbBolDep.CodMon = 1 THEN DO:
       /* Cargar los movimientos a la cuenta de Bancos */
       x-tpomov = FALSE.
       x-codcta = CcbBolDep.CodCta.
       x-coddoc = IF CcbBolDep.TipDep = '' THEN 'EFE' ELSE CcbBolDep.TipDep.
       RUN Graba-Documento (CcbBolDep.CodDiv, 1, CcbBolDep.ImpTot, '@CL', CcbBolDep.CodCli,
           x-coddoc, CcbBolDep.nroref, 'Boleta de Deposito').
       /* Descargar los movimiento de Anticipos   */
       x-tpomov = TRUE.
       x-codcta = cb-cfgg.codaux[5].
       RUN Graba-Documento (CcbBolDep.CodDiv, 1, CcbBolDep.ImpTot, '@CL', CcbBolDep.CodCli,
           x-coddoc, CcbBolDep.nroref, 'Boleta de Deposito').
       END.
    ELSE DO:
       /* Cargar los movimientos a la cuenta de Bancos */
       x-tpomov = FALSE.
       x-codcta = CcbBolDep.CodCta.
       x-coddoc = IF CcbBolDep.TipDep = '' THEN 'EFE' ELSE CcbBolDep.TipDep.
       RUN Graba-Documento (CcbBolDep.CodDiv, 2, CcbBolDep.ImpTot, '@CL', CcbBolDep.CodCli,
           x-coddoc, CcbBolDep.nroref, 'Boleta de Deposito').
       /* Descargar los movimiento de Anticipos   */
       x-tpomov = TRUE.
       x-codcta = cb-cfgg.codcta[5].
       RUN Graba-Documento (CcbBolDep.CodDiv, 2, CcbBolDep.ImpTot, '@CL', CcbBolDep.CodCli,
           x-coddoc, CcbBolDep.nroref, 'Boleta de Deposito').
    END.
END.

RUN Graba-Redondeo.
HIDE FRAME F-Proceso.

RUN dispatch IN h_b-cjacb2 ('open-query':U).
RUN Totales IN h_b-cjacb2.

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
  DISPLAY F-Fecha F-Tpocmb 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-42 F-Fecha B-filtro 
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
DEFINE INPUT PARAMETER x-coddiv AS CHAR.
DEFINE INPUT PARAMETER x-codmon AS INTEGER.
DEFINE INPUT PARAMETER x-import AS DECIMAL.
DEFINE INPUT PARAMETER x-clfaux AS CHAR.
DEFINE INPUT PARAMETER x-codaux AS CHAR.
DEFINE INPUT PARAMETER x-codcbd AS CHAR.
DEFINE INPUT PARAMETER x-nrodoc AS CHAR.
DEFINE INPUT PARAMETER x-glodoc AS CHAR.
 CREATE t-prev.
 ASSIGN
    t-prev.tipo    = ' '
    t-prev.banco   = CcbBolDep.CodCta
    t-prev.periodo = x-periodo
    t-prev.nromes  = x-nromes
    t-prev.codope  = x-codope
    t-prev.coddiv  = x-CodDiv 
    t-prev.codmon  = x-codmon
    t-prev.codcta  = x-codcta
    t-prev.fchdoc  = CcbBolDep.FchDoc
    t-prev.tpomov  = x-tpomov
    t-prev.clfaux  = x-clfaux
    t-prev.codaux  = x-codaux
    t-prev.coddoc  = x-Codcbd
    t-prev.nrodoc  = x-nrodoc
    t-prev.Tpocmb  = F-Tpocmb
    t-prev.glodoc  = x-glodoc
    t-prev.nroref  = CcbBolDep.NroDoc.
    
 IF x-codmon = 1 THEN
    ASSIGN
       t-prev.impmn1  = t-prev.impmn1 + x-import
       t-prev.impmn2  = t-prev.impmn2 + ROUND((x-import / F-TpoCmb),2).
 ELSE 
    ASSIGN
       t-prev.impmn2  = t-prev.impmn2 + x-import
       t-prev.impmn1  = t-prev.impmn1 + ROUND((x-import * F-TpoCmb),2).

 RELEASE t-prev.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Redondeo W-Win 
PROCEDURE Graba-Redondeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-s AS DECIMAL NO-UNDO.
DEFINE VAR x-d AS DECIMAL NO-UNDO.
DEFINE BUFFER B-prev FOR t-prev.

FOR EACH t-prev NO-LOCK BREAK BY t-prev.tipo BY t-prev.nroref BY t-prev.codcta :
    IF FIRST-OF(t-prev.tipo) THEN DO:
       x-s = 0.
       x-d = 0.
    END.
    x-s = x-s + (t-prev.ImpMn1 * IF t-prev.tpomov THEN -1 ELSE 1).
    x-d = x-d + (t-prev.ImpMn2 * IF t-prev.tpomov THEN -1 ELSE 1).
    IF LAST-OF(t-prev.tipo) THEN DO:
       IF x-s <> 0  THEN DO:
          x-tpomov = x-s > 0.
          x-codcta = IF x-s > 0 THEN x-rndgan ELSE x-rndper.
          RUN Graba-Rnd (1, ABS(x-s)).
       END.
       IF x-d <> 0  THEN DO:
          x-tpomov = x-d > 0.
          x-codcta = IF x-d > 0 THEN x-rndgan ELSE x-rndper.
          RUN Graba-Rnd (2, ABS(x-d)).
       END.
    END.
END.
END PROCEDURE.

PROCEDURE Graba-Rnd:
/******************/
DEFINE INPUT PARAMETER x-codmon AS INTEGER.
DEFINE INPUT PARAMETER x-import AS DECIMAL.

 CREATE B-prev.
 ASSIGN
    B-prev.tipo    = t-prev.tipo
    B-prev.banco   = t-prev.banco
    B-prev.periodo = x-periodo
    B-prev.nromes  = x-nromes
    B-prev.codope  = x-codope
    B-prev.coddiv  = t-prev.CodDiv 
    B-prev.codmon  = x-codmon
    B-prev.codcta  = x-codcta
    B-prev.fchdoc  = t-prev.fchdoc
    B-prev.tpomov  = x-tpomov
    B-prev.Tpocmb  = t-prev.TpoCmb
    B-prev.glodoc  = 'Diferencia por Redondeo'
    B-prev.nroref  = '999999999'. /* Solo por presentacion */
    
 IF x-codmon = 1 THEN ASSIGN B-prev.impmn1  = x-import.
 ELSE ASSIGN B-prev.impmn2  = x-import.

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
DEFINE VAR x-codcja  AS CHAR    NO-UNDO.
DEFINE VAR x-opera   AS CHAR    NO-UNDO.
RUN bin\_mes.p(x-nromes, 1, OUTPUT x-nommes).

DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 105 TODAY FORMAT '99/99/9999' SKIP(1)
    {&PRN6A} + "BOLETA DE DEPOSITO" + {&PRN6B} + {&PRND} AT 50 FORMAT "X(45)" SKIP(1)
    "Caja           : " x-codcja SKIP
    "Operacion      : " x-opera FORMAT 'X(40)' SKIP
    "Fecha          : " F-Fecha  SPACE(10) "Tipo de cambio : " AT 100 x-tpocmb FORMAT '>>>9.999' SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "           CUENTA   CLF  CODIGO   COD.  NUMERO                                                        TIP              S O L E S        " SKIP
    "DIVISION  CONTABLE  AUX AUXILIAR  DOC. DOCUMENTO   FECHA       C O N C E P T O                   US$  MOV          DEBE          HABER  " SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-Detalle
    I-NroItm       AT 1   FORMAT ">>9" 
    t-prev.coddiv  
    t-prev.codcta  
    t-prev.clfaux  
    t-prev.codaux
    t-prev.coddoc
    t-prev.nrodoc
    t-prev.fchdoc
    t-prev.glodoc
    x-dolares FORMAT ">>>,>>9.99" 
    t-prev.tpomov
    x-debe  FORMAT ">>>>,>>>,>>9.99" 
    x-haber FORMAT ">>>>,>>>,>>9.99" 
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 

 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.

I-NroItm = 0.
FOR EACH t-prev BREAK BY t-prev.tipo BY t-prev.banco BY t-prev.nroref BY t-prev.codcta:
    x-opera = ''.
    FIND cb-oper WHERE cb-oper.CodCia = cb-codcia AND
         cb-oper.Codope = t-prev.codope NO-LOCK NO-ERROR.
    IF AVAILABLE cb-oper THEN 
       x-opera = cb-oper.codope + ' - ' + cb-oper.Nomope.
    x-codcja = t-prev.tipo.
    VIEW FRAME F-Header.
    IF FIRST-OF(t-prev.tipo) THEN I-Nroitm = 0.
    IF FIRST-OF(t-prev.banco) THEN DO:
       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
            cb-ctas.Codcta = t-prev.banco NO-LOCK NO-ERROR.
       IF AVAILABLE cb-ctas THEN DO:
          PUT t-prev.banco
              space(3)
              cb-ctas.Nomcta SKIP.
          DOWN WITH FRAME F-Detalle.
       END.
    END.
    I-Nroitm = I-Nroitm + 1.
    x-debe   = 0.
    x-haber  = 0.
    x-dolares = t-prev.impmn2.
    IF t-prev.tpomov THEN x-haber = t-prev.impmn1.
    ELSE x-debe = t-prev.impmn1.
    ACCUMULATE x-debe (SUB-TOTAL BY t-prev.banco).
    ACCUMULATE x-haber (SUB-TOTAL BY t-prev.banco).
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
        t-prev.fchdoc
        t-prev.glodoc
        x-dolares 
        t-prev.tpomov
        x-debe  WHEN x-debe <> 0
        x-haber WHEN x-haber <> 0
        WITH FRAME F-Detalle.
    IF LAST-OF(t-prev.banco) THEN DO:
        UNDERLINE 
            x-debe
            x-haber
            WITH FRAME F-Detalle.
        DISPLAY 
            "        TOTAL "    @ t-prev.glodoc
            ACCUM SUB-TOTAL BY t-prev.banco x-debe  @ x-debe
            ACCUM SUB-TOTAL BY t-prev.banco x-haber @ x-haber
            WITH FRAME F-Detalle.
        DOWN(2).
    END.
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
OUTPUT CLOSE.
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
     MESSAGE 'Configuracion de Cuentas de Diferencia de Cambio no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.

  FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR.
  
  /* Verifico la configuracion de las cuentas de Ingreso a Caja */
  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'CJA' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN x-codope = cb-cfgg.Codope.
  ELSE DO:
     MESSAGE 'Configuracion de Ctas de Ingreso a Caja no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.
  
  RUN dispatch IN h_p-updv10 ('hide':U).
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY 
        TODAY @ F-Fecha.
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
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
   
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
   
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
   
  RUN Imprimir.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
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
DEFINE VAR p-mes     AS INTE NO-UNDO.
DEFINE VAR p-periodo AS INTE NO-UNDO.
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
p-periodo = x-periodo.
p-mes     = x-nromes.

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
 FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia AND
     cb-control.tipo = '@CJ3' AND
     cb-control.fchpro  = F-Fecha  NO-LOCK NO-ERROR.
 IF AVAILABLE cb-control THEN DO:
    MESSAGE "Asiento contable ya existe ¨Desea reemplazarlo? " VIEW-AS ALERT-BOX WARNING
             BUTTONS YES-NO UPDATE sigue AS LOGICAL.
    IF NOT sigue THEN RETURN.
 END.
 FOR EACH cb-control WHERE cb-control.CodCia  = s-codcia AND
     cb-control.tipo = '@CJ3' AND
     cb-control.fchpro  = F-Fecha NO-LOCK :
     FIND cb-cmov WHERE cb-cmov.codcia  = p-codcia AND
         cb-cmov.PERIODO = x-periodo AND
         cb-cmov.NROMES  = x-nromes  AND
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
   
FOR EACH t-prev BREAK BY t-prev.tipo BY t-prev.nroref BY t-prev.coddiv:
    IF FIRST-OF(t-prev.tipo) THEN DO:
       /* Verifico si el movimiento se realiz¢ anteriormente */
       FIND cb-control WHERE cb-control.CodCia  = s-codcia AND
            cb-control.tipo = '@CJ3' AND
            cb-control.fchpro  = F-Fecha  AND 
            cb-control.tipmov  = t-prev.tipo NO-ERROR.
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
             cb-control.tipo    = '@CJ3'
             cb-control.CodCia  = p-codcia
             cb-control.Periodo = x-periodo
             cb-control.Nromes  = x-nromes 
             cb-control.fchpro  = F-Fecha
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
        Cb-dmov.Nroref  = t-prev.nroref.
        CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        CB-DMOV.GLODOC  = t-prev.glodoc.
        CB-DMOV.tpomov  = t-prev.tpomov.
        CB-DMOV.impmn1  = t-prev.impmn1.
        CB-DMOV.impmn2  = t-prev.impmn2.
        CB-DMOV.FCHDOC  = p-fchast.
        CB-DMOV.FCHVTO  = p-fchast.
        CB-DMOV.FLGACT  = TRUE.
        CB-DMOV.RELACION = 0.
        CB-DMOV.codmon  = 1.
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
        T-CB-DMOV.Nroref  = t-prev.nroref.
        T-CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        T-CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        T-CB-DMOV.GLODOC  = t-prev.glodoc.
        T-CB-DMOV.tpomov  = t-prev.tpomov.
        T-CB-DMOV.impmn1  = t-prev.impmn1.
        T-CB-DMOV.impmn2  = t-prev.impmn2.
        T-CB-DMOV.FCHDOC  = p-fchast.
        T-CB-DMOV.FCHVTO  = p-fchast.
        T-CB-DMOV.FLGACT  = TRUE.
        T-CB-DMOV.RELACION = 0.
        T-CB-DMOV.codmon  = 1.
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
       cb-cmov.Fchast = F-Fecha.
       cb-cmov.TOTITM = J.
       cb-cmov.CODMON = 1.
       cb-cmov.TPOCMB = x-Tpocmb.
       cb-cmov.DBEMN1 = d-uno.
       cb-cmov.DBEMN2 = d-dos.
       cb-cmov.HBEMN1 = h-uno.
       cb-cmov.HBEMN2 = h-dos.
       cb-cmov.NOTAST = t-prev.glodoc.
       cb-cmov.GLOAST = t-prev.glodoc.
    END.
END.
RUN Actualiza-Flag.
MESSAGE ' PROCESO CONCLUIDO  ' SKIP
        'Periodo : ' + STRING(cb-control.periodo, '9999') SKIP
        'Mes     : ' + STRING(cb-control.nromes, '99') SKIP 
        'Asiento : ' + cb-control.codope + '-' + cb-control.nroast
        VIEW-AS ALERT-BOX INFORMATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


