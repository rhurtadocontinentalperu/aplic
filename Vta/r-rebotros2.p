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

DEFINE TEMP-TABLE ttsup_det NO-UNDO
    FIELDS CodCli LIKE supmmate.CodCli
    FIELDS Sede LIKE supmmate.sede
    FIELDS codmat LIKE supmmate.codmat   COLUMN-LABEL "Artículo"
    FIELDS codartcli LIKE supmmatg.codartcli
    FIELDS StkAct LIKE supmmate.StkAct
    FIELDS descr AS CHARACTER FORMAT "x(50)" LABEL "Descripción"
    INDEX idx01 IS PRIMARY CodCli codartcli.

DEFINE TEMP-TABLE ttss_mstr NO-UNDO
    FIELDS ttss_cell AS CHARACTER
    FIELDS ttss_sede LIKE Gn-ClieD.sede
    FIELDS ttss_sedeclie LIKE Gn-ClieD.sedeclie
    INDEX idx01 IS PRIMARY ttss_cell.

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

DEFINE TEMP-TABLE tt-rebade NO-UNDO
    FIELDS t-sec     AS INT
    FIELDS t-impa    AS DEC
    FIELDS t-impb    AS DEC
    FIELDS t-factor  AS DEC EXTENT 4
    FIELDS t-rebate AS DEC .

DEFINE TEMP-TABLE tt-docu NO-UNDO
    FIELDS t-codcli LIKE gn-clie.codcli
    FIELDS t-ruccli LIKE ccbcdocu.ruc
    FIELDS t-nomcli LIKE ccbcdocu.nomcli
    FIELDS t-totped AS DECIMAL FORMAT "->>>,>>>,>>9.99" EXTENT 3
    FIELDS t-totcan AS DECIMAL FORMAT "->>>,>>>,>>9.99" EXTENT 3
    FIELDS t-totdev AS DECIMAL FORMAT "->>>,>>>,>>9.99" EXTENT 3
    FIELDS t-totnex AS DECIMAL FORMAT "->>>,>>>,>>9.99" EXTENT 3
    FIELDS t-rebped AS DECIMAL 
    FIELDS t-rebcan AS DECIMAL 
    FIELDS t-rebnex AS DECIMAL
    FIELDS t-nrosec AS DECIMAL.



DEFINE BUFFER b-docu FOR tt-docu.

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
     fDesde AT ROW 2.65 COL 28.29 COLON-ALIGNED WIDGET-ID 30
     fHasta AT ROW 2.65 COL 47.29 COLON-ALIGNED WIDGET-ID 32
     fDesde-2 AT ROW 3.65 COL 28.29 COLON-ALIGNED WIDGET-ID 40
     fHasta-2 AT ROW 3.65 COL 47.29 COLON-ALIGNED WIDGET-ID 42
     fDesde-3 AT ROW 4.65 COL 28.29 COLON-ALIGNED WIDGET-ID 44
     fHasta-3 AT ROW 4.65 COL 47.29 COLON-ALIGNED WIDGET-ID 46
     txt-msj AT ROW 6.38 COL 2 NO-LABEL WIDGET-ID 38
     BUTTON-ok AT ROW 7.35 COL 53
     BUTTON-cancel AT ROW 7.35 COL 61
     "Campaña Actual" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 4.85 COL 6 WIDGET-ID 52
          FONT 6
     "Campaña Anterior 1" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 3.85 COL 6 WIDGET-ID 50
          FONT 6
     "Campaña Anterior 2" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 2.85 COL 6 WIDGET-ID 48
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
    RUN Excel.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Rebades W-Win 
PROCEDURE Asigna-Rebades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VARIABLE iInt    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dPorReb AS DECIMAL     NO-UNDO EXTENT 5.
    DEFINE VARIABLE dFacA   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dFacB   AS DECIMAL     NO-UNDO.
    /*
    t-sec    
    t-impa   
    t-impb   
    t-factor 
    t-rebate 
    */
    FOR EACH tt-docu NO-LOCK:      
        dFacA = (tt-docu.t-totped[1] / tt-docu.t-totped[2]).
        dFacB = (tt-docu.t-totped[3] / tt-docu.t-totped[2]).
        
        FOR EACH tt-rebade NO-LOCK 
            WHERE tt-rebade.t-impa <= tt-docu.t-totped[3] 
            AND tt-rebade.t-impb >=  tt-docu.t-totped[3] 
            AND tt-rebade.t-factor[1] <= dFacA 
            AND tt-rebade.t-factor[2] >= dFacA :            
            IF dFacB >= tt-rebade.t-factor[3]
                AND dFacB <= tt-rebade.t-factor[4] THEN 
                ASSIGN 
                    tt-docu.t-rebped = tt-rebade.t-rebate
                    tt-docu.t-nrosec = tt-rebade.t-sec.
        END.
        DISPLAY "Asignando Rebades..." @ txt-msj
            WITH FRAME {&FRAME-NAME}.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporales W-Win 
PROCEDURE Borra-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-rebade:
        DELETE tt-rebade.
    END.

    FOR EACH tt-docu:
        DELETE tt-docu.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-1 W-Win 
PROCEDURE Carga-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dTpoCmb AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cCodCli AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE dFactor AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE cMotivos AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-TpoCmbCmp AS DECIMAL  NO-UNDO.
    
    cMotivos = "00006,00009,00010,00011,00014".
    
    Docs:
    FOR EACH ccbcdocu USE-INDEX Llave13
        WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.fchdoc >= fDesde-3
        AND ccbcdocu.fchdoc <= fHasta-3
        AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C") > 0
        AND ccbcdocu.codcli BEGINS FILL-IN-codcli
        /*AND ccbcdocu.codcli = "20411033458"*/
        AND CcbCdocu.TpoFac <> 'A'      /* NO facturas adelantadas */       
        AND ccbcdocu.flgest <> "A" NO-LOCK:
         
        /*IF CcbCDocu.TpoFac = "S" THEN NEXT Docs.*/

        /*No considerar Factura de servicios*/
        IF CcbCDocu.CodDoc = "N/C" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE lookup(CcbDDocu.CodMat,cMotivos) > 0 NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN NEXT Docs.
        END.
        ELSE IF CcbCDocu.CodDoc = "FAC" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE CcbDDocu.CodMat = "00012" NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN NEXT Docs.
        END.

        /*Calcula Tipo de Cambio*/
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN ASSIGN x-TpoCmbCmp = Gn-Tcmb.Compra.

        IF ccbcdocu.codmon = 1 THEN dTpoCmb = 1 / x-TpoCmbCmp. ELSE dTpoCmb = 1.       
        IF CcbCDocu.CodDoc = "N/C" THEN dfactor = - 1. ELSE dfactor = 1.

        cCodCli = CcbCDocu.CodCli.

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = cCodCli NO-LOCK NO-ERROR.

        FIND FIRST tt-docu WHERE tt-docu.t-codcli = cCodCli  NO-ERROR.
        IF NOT AVAIL tt-docu THEN DO:
            CREATE tt-docu.
            ASSIGN
                tt-docu.t-codcli = cCodCli
                tt-docu.t-ruccli = cCodCli.
            IF AVAIL gn-clie THEN tt-docu.t-nomcli = gn-clie.nomcli.
        END.
        ASSIGN tt-docu.t-totped[3] = tt-docu.t-totped[3] + (ccbcdocu.imptot * dTpoCmb * dFactor).
        PAUSE 0.

/*         /*Hallando Documentos Cancelados*/                                                  */
/*         FOR EACH Ccbdcaja NO-LOCK USE-INDEX Llave02                                         */
/*             WHERE Ccbdcaja.codcia = CcbCDocu.CodCia                                         */
/*             AND Ccbcdocu.coddoc = Ccbdcaja.codref                                           */
/*             AND Ccbcdocu.nrodoc = Ccbdcaja.nroref :                                         */
/*             IF CcbDCaja.CodMon = 2 THEN dTpoCmb = CcbDCaja.TpoCmb. ELSE dTpoCmb = 1.        */
/*             ASSIGN tt-docu.t-totcan[3] = tt-docu.t-totcan[3] + (CcbDCaja.ImpTot * dTpoCmb). */
/*         END.                                                                                */

        DISPLAY "Cargando: " + CcbcDocu.CodDoc + " - " + CcbCDocu.NroDoc @ txt-msj 
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
    
    DEFINE VARIABLE dTpoCmb     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cCodCli     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cMotivos    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dFactor     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-TpoCmbCmp AS DECIMAL     NO-UNDO.
    cMotivos = "00006,00009,00010,00011,00014".

    Docs:
    FOR EACH tt-docu NO-LOCK 
        WHERE tt-docu.t-totped[3] >= 10000,
        EACH ccbcdocu USE-INDEX Llave06
        WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.codcli = tt-docu.t-codcli
        AND ccbcdocu.flgest <> "A"
        AND ccbcdocu.fchdoc >= fDesde-2
        AND ccbcdocu.fchdoc <= fHasta-2
        AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C") > 0        
        AND CcbCdocu.TpoFac <> 'A'      /* NO facturas adelantadas */ NO-LOCK:
        
        /*No considerar Factura de servicios*/
        IF CcbCDocu.CodDoc = "N/C" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE lookup(CcbDDocu.CodMat,cMotivos) > 0 NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN NEXT Docs.
        END.
        ELSE IF CcbCDocu.CodDoc = "FAC" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE CcbDDocu.CodMat = "00012" NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN NEXT Docs.
        END.

        /*Calcula Tipo de Cambio*/
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN ASSIGN x-TpoCmbCmp = Gn-Tcmb.Compra.

        IF ccbcdocu.codmon = 1 THEN dTpoCmb = 1 / x-TpoCmbCmp. ELSE dTpoCmb = 1.       
        IF CcbCDocu.CodDoc = "N/C" THEN dfactor = - 1. ELSE dfactor = 1.
        
        /*Verifica Codigos asociados*/
        FIND FIRST b-docu WHERE b-docu.t-codcli = CcbCDocu.CodCli NO-ERROR.
        IF AVAIL b-docu THEN 
            ASSIGN b-docu.t-totped[2] = b-docu.t-totped[2] + (ccbcdocu.imptot * dTpoCmb * dFactor).
        PAUSE 0.

/*         /*Hallando Documentos Cancelados*/                                           */
/*         FOR EACH Ccbdcaja NO-LOCK USE-INDEX Llave02                                  */
/*             WHERE Ccbdcaja.codcia = CcbCDocu.CodCia                                  */
/*             AND Ccbcdocu.coddoc = Ccbdcaja.codref                                    */
/*             AND Ccbcdocu.nrodoc = Ccbdcaja.nroref :                                  */
/*             IF CcbDCaja.CodMon = 2 THEN dTpoCmb = CcbDCaja.TpoCmb. ELSE dTpoCmb = 1. */
/*             ASSIGN b-docu.t-totcan = b-docu.t-totcan + (CcbDCaja.ImpTot * dTpoCmb).  */
/*         END.                                                                         */

        DISPLAY "Cargando: " + CcbcDocu.CodDoc + " - " + CcbCDocu.NroDoc @ txt-msj 
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
    
    DEFINE VARIABLE dTpoCmb     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cCodCli     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cMotivos    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dFactor     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-TpoCmbCmp AS DECIMAL     NO-UNDO.

    cMotivos = "00006,00009,00010,00011,00014".

    Docs:
    FOR EACH tt-docu NO-LOCK 
        WHERE tt-docu.t-totped[3] >= 10000,
        EACH ccbcdocu USE-INDEX Llave06
        WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.codcli = tt-docu.t-codcli
        AND ccbcdocu.flgest <> "A"
        AND ccbcdocu.fchdoc >= fDesde
        AND ccbcdocu.fchdoc <= fHasta
        AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C") > 0        
        AND CcbCdocu.TpoFac <> 'A'      /* NO facturas adelantadas */ NO-LOCK:
        
        IF ccbcdocu.codmon = 1 THEN dTpoCmb = 1 / CcbCDocu.TpoCmb.
        ELSE dTpoCmb = 1.
        
        /*No considerar Factura de servicios*/
        IF CcbCDocu.CodDoc = "N/C" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE lookup(CcbDDocu.CodMat,cMotivos) > 0 NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN NEXT Docs.
        END.
        ELSE IF CcbCDocu.CodDoc = "FAC" THEN DO:
            FIND FIRST CcbDDocu OF CcbCDocu 
                WHERE CcbDDocu.CodMat = "00012" NO-LOCK NO-ERROR.
            IF AVAIL CcbDDocu THEN NEXT Docs.
        END.

        /*Calcula Tipo de Cambio*/
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN ASSIGN x-TpoCmbCmp = Gn-Tcmb.Compra.

        IF ccbcdocu.codmon = 1 THEN dTpoCmb = 1 / x-TpoCmbCmp. ELSE dTpoCmb = 1.       
        IF CcbCDocu.CodDoc = "N/C" THEN dFactor = -1. ELSE dFactor = 1.         

        /*Verifica Codigos asociados*/
        FIND FIRST b-docu WHERE b-docu.t-codcli = CcbCDocu.CodCli NO-ERROR.
        IF AVAIL b-docu THEN 
            ASSIGN b-docu.t-totped[1] = b-docu.t-totped[1] + (ccbcdocu.imptot * dTpoCmb * dFactor).
        PAUSE 0.

/*         /*Hallando Documentos Cancelados*/                                           */
/*         FOR EACH Ccbdcaja NO-LOCK USE-INDEX Llave02                                  */
/*             WHERE Ccbdcaja.codcia = CcbCDocu.CodCia                                  */
/*             AND Ccbcdocu.coddoc = Ccbdcaja.codref                                    */
/*             AND Ccbcdocu.nrodoc = Ccbdcaja.nroref :                                  */
/*             IF CcbDCaja.CodMon = 2 THEN dTpoCmb = CcbDCaja.TpoCmb. ELSE dTpoCmb = 1. */
/*             ASSIGN b-docu.t-totcan = b-docu.t-totcan + (CcbDCaja.ImpTot * dTpoCmb).  */
/*         END.                                                                         */

        DISPLAY "Cargando: " + CcbcDocu.CodDoc + " - " + CcbCDocu.NroDoc @ txt-msj 
            WITH FRAME {&FRAME-NAME}.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b-rebade FOR tt-rebade.   
    DEFINE VARIABLE x-doc AS CHARACTER   NO-UNDO.

    
    GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Doc .
    x-doc = x-doc + "Rebade0.txt".
    
/*
    INPUT FROM "O:\on_in_co\Plantillas\Rebade0.txt".
*/
    INPUT FROM VALUE(x-doc).    

    REPEAT:
        CREATE tt-rebade.
        IMPORT DELIMITER "|" tt-rebade NO-ERROR.
        DISPLAY "Cargando Información..." @ txt-msj
            WITH FRAME {&FRAME-NAME}.
    END.
    INPUT CLOSE.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Documentos W-Win 
PROCEDURE Carga-Documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    DEFINE VARIABLE dTpoCmb AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE cCodCli AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMotivos AS CHARACTER   NO-UNDO.
    cMotivos = "00006,00009,00010,00011,00014".

    FOR EACH tt-rebade NO-LOCK:
        Docs:
        FOR EACH ccbcdocu USE-INDEX Llave13
            WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.fchdoc >= fDesde
            AND ccbcdocu.fchdoc <= fHasta
            AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C") > 0
            AND ccbcdocu.codcli = tt-rebade.t-ruc
            AND CcbCdocu.TpoFac <> 'A'      /* NO facturas adelantadas */       
            AND ccbcdocu.flgest <> "A" NO-LOCK:
            
            /*No considerar Factura de servicios*/
            /*IF CcbCDocu.TpoFac = "S" THEN*/
            IF CcbCDocu.CodDoc = "N/C" THEN DO:
                FIND FIRST CcbDDocu OF CcbCDocu 
                    WHERE lookup(CcbDDocu.CodMat,cMotivos) > 0 NO-LOCK NO-ERROR.
                IF AVAIL CcbDDocu THEN NEXT Docs.
            END.
            ELSE IF CcbCDocu.CodDoc = "FAC" THEN DO:
                FIND FIRST CcbDDocu OF CcbCDocu 
                    WHERE CcbDDocu.CodMat = "00012" NO-LOCK NO-ERROR.
                IF AVAIL CcbDDocu THEN NEXT Docs.
            END.

            cCodCli = CcbCDocu.CodCli.
            /*Verifica Codigos asociados*/
            IF tt-rebade.t-ruc2 <> "" THEN cCodCli = tt-rebade.t-ruc2.
            FIND FIRST tt-docu WHERE tt-docu.t-codcli = cCodCli NO-ERROR.
            IF NOT AVAIL tt-docu THEN DO:
                CREATE tt-docu.
                ASSIGN
                    tt-docu.t-codcli = cCodCli
                    tt-docu.t-ruccli = cCodCli
                    tt-docu.t-nomcli = ccbcdocu.nomcli.
            END.

            IF ccbcdocu.codmon = 2 THEN dTpoCmb = CcbCDocu.TpoCmb.
            ELSE dTpoCmb = 1.

            IF CcbcDocu.CodDoc <> "N/C" THEN
                ASSIGN tt-docu.t-totped = tt-docu.t-totped + (ccbcdocu.imptot * dTpoCmb ).
            ELSE ASSIGN tt-docu.t-totdev = tt-docu.t-totdev + (ccbcdocu.imptot * dTpoCmb * -1 ).
            PAUSE 0.

            /*Hallando Documentos Cancelados*/
            FOR EACH Ccbdcaja NO-LOCK USE-INDEX Llave02
                WHERE Ccbdcaja.codcia = CcbCDocu.CodCia
                AND Ccbcdocu.coddoc = Ccbdcaja.codref
                AND Ccbcdocu.nrodoc = Ccbdcaja.nroref :
                IF CcbDCaja.CodMon = 2 THEN dTpoCmb = CcbDCaja.TpoCmb. ELSE dTpoCmb = 1.
                ASSIGN tt-docu.t-totcan = tt-docu.t-totcan + (CcbDCaja.ImpTot * dTpoCmb).            
            END.

            DISPLAY "Cargando: " + CcbcDocu.CodDoc + " - " + CcbCDocu.NroDoc @ txt-msj 
                WITH FRAME {&FRAME-NAME}.
        END.
    END.
*/
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
/*
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cCellArrary AS CHARACTER NO-UNDO
    EXTENT 26 INITIAL [
    "A","B","C","D","E","F","G","H",
    "I","J","K","L","M","N","O","P","Q",
    "R","S","T","U","V","W","X","Y","Z"
    ].
DEFINE VARIABLE cCell AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCountCell AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountArray AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountColumn AS INTEGER NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodArtCli AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodMat AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDesMat AS CHARACTER NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

FOR EACH ttsup_det:
    DELETE ttsup_det.
END.

FOR EACH ttss_mstr:
    DELETE ttss_mstr.
END.

REPEAT:

    iCountCell = 0.
    iCountArray = 0.
    cCell = "".
    iCountColumn = 0.
    iCountLine = iCountLine + 1.
    cRange = cCellArrary[1] + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.

    IF cValue = "" OR cValue = ? THEN LEAVE.

    DISPLAY
        iCountLine @ FI-MENSAJE LABEL "  Leyendo línea" FORMAT "X(12)"
        WITH FRAME F-PROCESO.

    REPEAT:

        IF iCountCell >= 26 THEN DO:
            iCountCell = 0.
            iCountArray = iCountArray + 1.
            cCell = cCellArrary[iCountArray].
        END.

        iCountCell = iCountCell + 1.
        cRange = cCell + cCellArrary[iCountCell] + TRIM(STRING(iCountLine)).

        cValue = chWorkSheet:Range(cRange):VALUE.

        /* Primera Linea - Carga Códigos de Tiendas */
        IF iCountLine = 1 THEN DO:

            IF cValue = "" OR cValue = ? THEN LEAVE.

            /* Máximo de columnas */
            IF iTotalColumn + 1 > 256 THEN LEAVE.

            FIND Gn-ClieD WHERE
                Gn-ClieD.codcia = cl-codcia AND
                Gn-ClieD.codcli = FILL-IN-codcli AND
                Gn-ClieD.sedeClie = cValue NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-ClieD THEN DO:
                CREATE ttss_mstr.
                ASSIGN
                    ttss_cell = cCell + cCellArrary[iCountCell]
                    ttss_sede = Gn-ClieD.sede
                    ttss_sedeclie = Gn-ClieD.sedeClie.
            END.

            iTotalColumn = iTotalColumn + 1.

        END.

        /* A partir de la segunda línea... */
        ELSE DO:
            iCountColumn = iCountColumn + 1.
            IF iCountColumn > iTotalColumn THEN LEAVE.
            IF cValue = "" OR cValue = ? THEN cValue = "0".
            /* Primera Celda - Artículo Cliete ó Código EAN13 */
            IF iCountColumn = 1 THEN DO:
                /* Busca Código de Artículo */
                IF INDEX(cValue,".") > 0 THEN
                    cValue = SUBSTRING(cValue,1,INDEX(cValue,".") - 1).
                FIND supmmatg WHERE
                    supmmatg.CodCia = s-CodCia AND
                    supmmatg.CodCli = FILL-IN-codcli AND
                    supmmatg.codartcli = cValue
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE supmmatg THEN DO:
                    cDesMat = "NO CARGADO!!!".
                    cCodMat = "".
                END.
                ELSE DO:
                    FOR almmmatg FIELDS
                        (almmmatg.codcia almmmatg.codmat almmmatg.desmat) WHERE
                        almmmatg.codcia = s-CodCia AND
                        almmmatg.codmat = supmmatg.codmat NO-LOCK:
                    END.
                    IF AVAILABLE almmmatg THEN
                        cDesMat = almmmatg.desmat.
                    cCodMat = supmmatg.codmat.
                END.
                cCodArtCli = cValue.
            END.
            ELSE DO:
                FIND FIRST ttss_mstr WHERE
                    ttss_cell = cCell + cCellArrary[iCountCell] NO-LOCK NO-ERROR.
                IF AVAILABLE ttss_mstr THEN DO:
                    CREATE ttsup_det.
                    ASSIGN
                        ttsup_det.CodCli = FILL-IN-codcli
                        ttsup_det.Sede = ttss_sede
                        ttsup_det.codartcli = cCodArtCli
                        ttsup_det.StkAct = INTEGER(cValue)
                        ttsup_det.Descr = cDesMat
                        ttsup_det.codmat = cCodMat NO-ERROR.
                END.
            END.
        END.

    END.
END.

/*
chExcelApplication:VISIBLE = TRUE.
*/

/* liberar com-handles */

chExcelApplication:QUIT().

RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

HIDE FRAME F-PROCESO.
*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
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

chWorkSheet:Range("A2"):Value = "Codigo".
chWorkSheet:Range("B2"):Value = "RUC".
chWorkSheet:Range("C2"):Value = "Razón Social".
chWorkSheet:Range("D2"):Value = "Importe Campaña " + STRING(YEAR(today) - 2).
chWorkSheet:Range("E2"):Value = "Importe Campaña " + STRING(YEAR(today) - 1).
chWorkSheet:Range("F2"):Value = STRING(YEAR(today) - 2) + "/" + STRING(YEAR(today) - 1).
chWorkSheet:Range("G2"):Value = "Importe Campaña " + STRING(YEAR(today)).
chWorkSheet:Range("H2"):Value = STRING(YEAR(today)) + "/" + STRING(YEAR(today) - 1).
chWorkSheet:Range("I2"):Value = "% Rebade".
chWorkSheet:Range("J2"):Value = "NroSec".

RUN Borra-Temporales. 
RUN Carga-Datos.      
/* RUN Carga-Documentos. */
RUN Carga-1.
RUN Carga-2.
RUN Carga-3.
RUN Asigna-Rebades.   


FOR EACH tt-docu NO-LOCK
    WHERE tt-docu.t-totped[3] >= 10000 :
    
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-codcli.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-ruccli.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-nomcli.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-totped[1].
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-totped[2].
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-docu.t-totped[1] / tt-docu.t-totped[2]).
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-totped[3].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-docu.t-totped[3] / tt-docu.t-totped[2]).
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-rebped.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-nrosec.

    /*
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-docu.t-totped + tt-docu.t-totdev).
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-docu.t-totcan + tt-docu.t-totdev).   
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-rebped.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-rebcan.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = ((tt-docu.t-totped + tt-docu.t-totdev) * tt-docu.t-rebped / 100 ).
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = ((tt-docu.t-totcan + tt-docu.t-totdev) * tt-docu.t-rebcan / 100 ).
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-totnex.
    cRange = "N" + cColumn.
    IF tt-docu.t-totnex <> 0 THEN 
        chWorkSheet:Range(cRange):Value = tt-docu.t-totnex - tt-docu.t-totped.
    ELSE chWorkSheet:Range(cRange):Value = 0. 
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-docu.t-rebnex.
    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    DEFINE VARIABLE cTitle  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dTotPed AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dTotCan AS DECIMAL     NO-UNDO.

    cTitle = "REPORTE STOCK PARA SUPERMERCADOS".

    DEFINE FRAME F-REPORTE
        tt-docu.t-codcli    COLUMN-LABEL "Codigo"
        tt-docu.t-ruccli    COLUMN-LABEL "RUC"
        tt-docu.t-nomcli    COLUMN-LABEL "Nombre y Apellidos"
        tt-docu.t-totped    COLUMN-LABEL "Imp. Total Pedido"
        tt-docu.t-rebped    COLUMN-LABEL "% Rebade"
        dTotPed             COLUMN-LABEL "Tot Rebade Pedido"
        tt-docu.t-totcan    COLUMN-LABEL "Imp. Total Cancelado"
        tt-docu.t-rebcan    COLUMN-LABEL "% Rebade"
        dTotCan             COLUMN-LABEL "Tot Rebade Cancelado"
        WITH WIDTH 250 NO-BOX STREAM-IO DOWN.

    DEFINE FRAME F-HEADER       
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + cTitle FORMAT 'x(100)'
        {&PRN3} + {&PRN6B} + "Pagina : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 100 STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)"
        {&PRN4} + "Hora  : " AT 120 STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    VIEW STREAM REPORT FRAME F-HEADER.

    FOR EACH tt-docu NO-LOCK:
        DISPLAY STREAM REPORT
            tt-docu.t-codcli           
            tt-docu.t-ruccli           
            tt-docu.t-nomcli           
            tt-docu.t-totped           
            tt-docu.t-rebped 
            (tt-docu.t-totped * tt-docu.t-rebped / 100 ) @ dTotPed
            tt-docu.t-totcan           
            tt-docu.t-rebcan           
            (tt-docu.t-totcan * tt-docu.t-rebcan / 100 ) @ dTotCan
            WITH FRAME F-REPORTE.
    END.

    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
*/
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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    /*RUN Carga-Temporal.*/
    RUN Borra-Temporales.
    RUN Carga-Datos.
    RUN Carga-Documentos.   
    RUN Asigna-Rebades.

    FIND FIRST tt-docu NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-docu THEN DO:
        MESSAGE
            "No hay registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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

