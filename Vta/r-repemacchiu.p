&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.
DEFINE SHARED VARIABLE s-user-id AS CHARACTER.

DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0 NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
        SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

FOR Empresas FIELDS
    (Empresas.CodCia Empresas.Campo-CodCli) WHERE
    Empresas.CodCia = S-CODCIA NO-LOCK:
END.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = S-CODCIA.

DEFINE TEMP-TABLE t-docs LIKE ccbcdocu
    FIELDS t-tot    AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELDS t-tpocmb AS DECIMAL
    FIELDS t-totmn  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELDS t-totme  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELDS t-var    AS CHAR
    FIELDS t-camp   AS CHAR FORMAT "X(50)".

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-codcli fDesde fHasta fDesde-2 ~
fHasta-2 fDesde-3 fHasta-3 BUTTON-ok BUTTON-cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-nomcli fDesde fHasta fDesde-2 ~
fHasta-2 fDesde-3 fHasta-3 txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-cancel 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Cancelar" 
     SIZE 8 BY 1.81 TOOLTIP "Salir".

DEFINE BUTTON BUTTON-ok 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "&Aceptar" 
     SIZE 8 BY 1.81 TOOLTIP "Imprimir".

DEFINE VARIABLE fDesde AS DATE FORMAT "99/99/9999":U INITIAL 01/01/08 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE fDesde-2 AS DATE FORMAT "99/99/9999":U INITIAL 01/01/09 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE fDesde-3 AS DATE FORMAT "99/99/9999":U INITIAL 12/01/09 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE fHasta AS DATE FORMAT "99/99/9999":U INITIAL 04/30/08 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE fHasta-2 AS DATE FORMAT "99/99/9999":U INITIAL 04/30/09 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE fHasta-3 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-codcli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codcli AT ROW 1.54 COL 14 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-nomcli AT ROW 1.54 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     fDesde AT ROW 2.88 COL 28.14 COLON-ALIGNED WIDGET-ID 30
     fHasta AT ROW 2.88 COL 47.14 COLON-ALIGNED WIDGET-ID 32
     fDesde-2 AT ROW 3.96 COL 28.14 COLON-ALIGNED WIDGET-ID 40
     fHasta-2 AT ROW 3.96 COL 47.14 COLON-ALIGNED WIDGET-ID 42
     fDesde-3 AT ROW 5.08 COL 28.29 COLON-ALIGNED WIDGET-ID 44
     fHasta-3 AT ROW 5.08 COL 47.29 COLON-ALIGNED WIDGET-ID 46
     txt-msj AT ROW 6.38 COL 2 NO-LABEL WIDGET-ID 38
     BUTTON-ok AT ROW 7.35 COL 53
     BUTTON-cancel AT ROW 7.35 COL 61
     "Campaña Anterior 1" VIEW-AS TEXT
          SIZE 16.86 BY .5 AT ROW 4.12 COL 6.14 WIDGET-ID 50
          FONT 6
     "Campaña Actual" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 5.23 COL 6.14 WIDGET-ID 48
          FONT 6
     "Campaña Anterior 2" VIEW-AS TEXT
          SIZE 16.86 BY .5 AT ROW 3.08 COL 6.14 WIDGET-ID 52
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 8.5
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
         TITLE              = "Rebade-Otros"
         HEIGHT             = 8.5
         WIDTH              = 71.86
         MAX-HEIGHT         = 10.88
         MAX-WIDTH          = 71.86
         VIRTUAL-HEIGHT     = 10.88
         VIRTUAL-WIDTH      = 71.86
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
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-codcli IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-nomcli:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Rebade-Otros */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Rebade-Otros */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-cancel W-Win
ON CHOOSE OF BUTTON-cancel IN FRAME F-Main /* Cancelar */
DO:
    RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-ok W-Win
ON CHOOSE OF BUTTON-ok IN FRAME F-Main /* Aceptar */
DO:

    ASSIGN FILL-IN-codcli fDesde fHasta fDesde-2 fDesde-3 fHasta-2 fHasta-3.    
    RUN Excel-a.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codcli W-Win
ON LEAVE OF FILL-IN-codcli IN FRAME F-Main /* Cliente */
DO:

    DISPLAY "" @ FILL-IN-nomcli WITH FRAME {&FRAME-NAME}.
    IF FILL-IN-codcli:SCREEN-VALUE = "" THEN RETURN.
    
    FOR gn-clie FIELDS
        (gn-clie.codcia gn-clie.codcli gn-clie.nomcli gn-clie.canal) WHERE
        gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = FILL-IN-codcli:SCREEN-VALUE NO-LOCK:
    END.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE
            "Código de cliente no existe"
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    DISPLAY gn-clie.nomcli @ FILL-IN-nomcli WITH FRAME {&FRAME-NAME}.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga W-Win 
PROCEDURE Carga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dTpoCmb     AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cCodCli     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE dFactor     AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cMotivos    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE x-TpoCmbCmp AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE x-TpoCmbVta AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE TpoCmbCmp   AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cVar        AS CHAR         NO-UNDO.
    
    cMotivos = "00006,00009,00010,00011,00014".

    Docs:
    FOR EACH ccbcdocu USE-INDEX Llave06
        WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.fchdoc >= fDesde-3
        AND ccbcdocu.fchdoc <= fHasta-3
        AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C") > 0
        AND ccbcdocu.codcli BEGINS FILL-IN-codcli
        /*AND ccbcdocu.codcli = "20411033458"*/
        AND CcbCdocu.TpoFac <> 'A'      /* NO facturas adelantadas */       
        AND ccbcdocu.flgest <> "A" NO-LOCK:
         
        cVar = "Si".

        /*No considerar Factura de servicios*/
        IF CcbCDocu.CodDoc = "N/C" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE lookup(CcbDDocu.CodMat,cMotivos) > 0 NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN cVar = "No".
        END.
        ELSE IF CcbCDocu.CodDoc = "FAC" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE CcbDDocu.CodMat = "00012" NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN cVar = "No".
        END.

        /*Calcula Tipo de Cambio*/
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN 
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta
                TpoCmbCmp   = Gn-Tcmb.Compra.
        
        IF ccbcdocu.codmon = 1 THEN dTpoCmb = 1 / x-TpoCmbCmp. ELSE dTpoCmb = 1.       
        IF CcbCDocu.CodDoc = "N/C" THEN dfactor = - 1. ELSE dfactor = 1.

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = cCodCli NO-LOCK NO-ERROR.

        CREATE t-docs.
        BUFFER-COPY ccbcdocu TO t-docs.
        ASSIGN 
            t-docs.imptot   = (ccbcdocu.imptot * dFactor) 
            t-docs.t-tot    = (ccbcdocu.imptot * dTpoCmb * dFactor)
            t-docs.t-tpocmb = TpoCmbCmp
            t-docs.t-var    = cVar
            t-docs.t-camp   = string(YEAR(fHasta-3)).
        
        CASE ccbcdocu.codmon:
            WHEN 1 THEN 
                ASSIGN 
                    t-docs.t-totmn = (ccbcdocu.imptot * dFactor)
                    t-docs.t-totme = (ccbcdocu.imptot / x-TpoCmbCmp * dFactor).
            WHEN 2 THEN
                ASSIGN 
                    t-docs.t-totmn = (ccbcdocu.imptot * x-TpoCmbVta * dFactor)
                    t-docs.t-totme = (ccbcdocu.imptot * dFactor).
        END CASE.

        DISPLAY "Cargando: " + ccbcdocu.CodDoc + " - " + ccbcdocu.NroDoc @ txt-msj 
            WITH FRAME {&FRAME-NAME}.

    END.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-2 W-Win 
PROCEDURE Carga-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dTpoCmb     AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cCodCli     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE dFactor     AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cMotivos    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE x-TpoCmbCmp AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE x-TpoCmbVta AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE TpoCmbCmp   AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cVar        AS CHAR         NO-UNDO.
    
    cMotivos = "00006,00009,00010,00011,00014".

    Docs:
    FOR EACH ccbcdocu USE-INDEX Llave06
        WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.fchdoc >= fDesde-2
        AND ccbcdocu.fchdoc <= fHasta-2
        AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C") > 0
        AND ccbcdocu.codcli BEGINS FILL-IN-codcli
        /*AND ccbcdocu.codcli = "20411033458"*/
        AND CcbCdocu.TpoFac <> 'A'      /* NO facturas adelantadas */       
        AND ccbcdocu.flgest <> "A" NO-LOCK:
         
        cVar = "Si".

        /*No considerar Factura de servicios*/
        IF CcbCDocu.CodDoc = "N/C" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE lookup(CcbDDocu.CodMat,cMotivos) > 0 NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN cVar = "No".
        END.
        ELSE IF CcbCDocu.CodDoc = "FAC" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE CcbDDocu.CodMat = "00012" NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN cVar = "No".
        END.

        /*Calcula Tipo de Cambio*/
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN 
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta
                TpoCmbCmp   = Gn-Tcmb.Compra.

        IF ccbcdocu.codmon = 1 THEN dTpoCmb = 1 / x-TpoCmbCmp. ELSE dTpoCmb = 1.       
        IF CcbCDocu.CodDoc = "N/C" THEN dfactor = - 1. ELSE dfactor = 1.

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = cCodCli NO-LOCK NO-ERROR.

        CREATE t-docs.
        BUFFER-COPY ccbcdocu TO t-docs.
        ASSIGN
            t-docs.imptot = (ccbcdocu.imptot * dFactor) 
            t-docs.t-tot  = (ccbcdocu.imptot * dTpoCmb * dFactor)
            t-docs.t-tpocmb = TpoCmbCmp
            t-docs.t-var = cVar
            t-docs.t-camp = string(YEAR(fHasta-2)).

        CASE ccbcdocu.codmon:
            WHEN 1 THEN 
                ASSIGN 
                    t-docs.t-totmn = (ccbcdocu.imptot * dFactor)
                    t-docs.t-totme = (ccbcdocu.imptot / x-TpoCmbCmp * dFactor).
            WHEN 2 THEN
                ASSIGN 
                    t-docs.t-totmn = (ccbcdocu.imptot * x-TpoCmbVta * dFactor)
                    t-docs.t-totme = (ccbcdocu.imptot * dFactor).
        END CASE.

        DISPLAY "Cargando: " + ccbcdocu.CodDoc + " - " + ccbcdocu.NroDoc @ txt-msj 
            WITH FRAME {&FRAME-NAME}.
    END.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-3 W-Win 
PROCEDURE Carga-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dTpoCmb     AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cCodCli     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE dFactor     AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cMotivos    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE x-TpoCmbCmp AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE x-TpoCmbVta AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE TpoCmbCmp   AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cVar        AS CHAR         NO-UNDO.
    
    cMotivos = "00006,00009,00010,00011,00014".

    Docs:
    FOR EACH ccbcdocu USE-INDEX Llave06
        WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.fchdoc >= fDesde
        AND ccbcdocu.fchdoc <= fHasta
        AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C") > 0
        AND ccbcdocu.codcli BEGINS FILL-IN-codcli
        /*AND ccbcdocu.codcli = "20411033458"*/
        AND CcbCdocu.TpoFac <> 'A'      /* NO facturas adelantadas */       
        AND ccbcdocu.flgest <> "A" NO-LOCK:
         
        cVar = "Si".

        /*No considerar Factura de servicios*/
        IF CcbCDocu.CodDoc = "N/C" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE lookup(CcbDDocu.CodMat,cMotivos) > 0 NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN cVar = "No".
        END.
        ELSE IF CcbCDocu.CodDoc = "FAC" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE CcbDDocu.CodMat = "00012" NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN cVar = "No".
        END.

        /*Calcula Tipo de Cambio*/
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN 
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta
                TpoCmbCmp   = Gn-Tcmb.Compra.

        IF ccbcdocu.codmon = 1 THEN dTpoCmb = 1 / x-TpoCmbCmp. ELSE dTpoCmb = 1.       
        IF CcbCDocu.CodDoc = "N/C" THEN dfactor = - 1. ELSE dfactor = 1.

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = cCodCli NO-LOCK NO-ERROR.

        CREATE t-docs.
        BUFFER-COPY ccbcdocu TO t-docs.
        ASSIGN 
            t-docs.imptot = (ccbcdocu.imptot * dFactor) 
            t-docs.t-tot  = (ccbcdocu.imptot * dTpoCmb * dFactor)
            t-docs.t-tpocmb = TpoCmbCmp
            t-docs.t-var = cVar
            t-docs.t-camp = string(YEAR(fHasta)).

        CASE ccbcdocu.codmon:
            WHEN 1 THEN 
                ASSIGN 
                    t-docs.t-totmn = (ccbcdocu.imptot * dFactor)
                    t-docs.t-totme = (ccbcdocu.imptot / x-TpoCmbCmp * dFactor).
            WHEN 2 THEN
                ASSIGN 
                    t-docs.t-totmn = (ccbcdocu.imptot * x-TpoCmbVta * dFactor)
                    t-docs.t-totme = (ccbcdocu.imptot * dFactor).
        END CASE.

        DISPLAY "Cargando: " + ccbcdocu.CodDoc + " - " + ccbcdocu.NroDoc @ txt-msj 
            WITH FRAME {&FRAME-NAME}.
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
  DISPLAY FILL-IN-nomcli fDesde fHasta fDesde-2 fHasta-2 fDesde-3 fHasta-3 
          txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-codcli fDesde fHasta fDesde-2 fHasta-2 fDesde-3 fHasta-3 
         BUTTON-ok BUTTON-cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-a W-Win 
PROCEDURE Excel-a :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
    DEFINE VARIABLE chChart                 AS COM-HANDLE.
    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE t-Column                AS INTEGER INIT 2.
    
    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.
    
    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().
    
    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).
    
    chWorkSheet:Range("A2"):Value = "Div".
    chWorkSheet:Range("B2"):Value = "Codigo".
    chWorkSheet:Range("C2"):Value = "Nro Documento".
    chWorkSheet:Range("D2"):Value = "Fecha".
    chWorkSheet:Range("E2"):Value = "Cod.Ref".
    chWorkSheet:Range("F2"):Value = "Nro Ref".
    chWorkSheet:Range("G2"):Value = "Moneda".
    chWorkSheet:Range("H2"):Value = "Importe Documento".
    chWorkSheet:Range("I2"):Value = "Tipo Cambio".
    chWorkSheet:Range("J2"):Value = "Importe Soles".
    chWorkSheet:Range("K2"):Value = "Importe Dolares".
    chWorkSheet:Range("L2"):Value = "¿Considerado?".
    chWorkSheet:Range("M2"):Value = "Campaña".

    FOR EACH t-docs:
        DELETE t-docs.
    END.
    
    RUN Carga.
    RUN Carga-2.
    RUN Carga-3.

    Docs:
    FOR EACH t-docs NO-LOCK:      

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + t-docs.coddiv.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = t-docs.coddoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + t-docs.nrodoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = t-docs.fchdoc.

        IF t-docs.coddoc = "N/C" THEN DO:
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = t-docs.codref.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + t-docs.nroref.
        END.
        cRange = "G" + cColumn.
        IF t-docs.codmon = 1 THEN
            chWorkSheet:Range(cRange):Value = "S/.".
        ELSE chWorkSheet:Range(cRange):Value = "$".
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = t-docs.imptot .
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = t-docs.t-tpocmb.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = t-docs.t-totmn.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = t-docs.t-totme.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = t-docs.t-var.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = t-docs.t-camp.

        DISPLAY "Cargando: " + t-docs.CodDoc + " - " + t-docs.NroDoc @ txt-msj 
            WITH FRAME {&FRAME-NAME}.

    END.

    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

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

    ASSIGN 
        fHasta-3 = TODAY.
    DISPLAY fHasta-3 WITH FRAME {&FRAME-NAME}.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
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

