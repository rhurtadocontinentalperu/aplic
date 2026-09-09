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

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE SHARED VARIABLE s-codcia AS INTEGER.

DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodOpe AS CHARACTER NO-UNDO.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0 NO-UNDO.

DEFINE TEMP-TABLE tt_ret NO-UNDO
    FIELDS tt_nroret AS CHARACTER FORMAT "x(9)"
    FIELDS tt_fchast LIKE cb-cmov.fchast
    FIELDS tt_nroast LIKE cb-cmov.nroast
    FIELDS tt_codpro LIKE gn-prov.CodPro
    FIELDS tt_coddoc AS CHARACTER FORMAT "x(2)"
    FIELDS tt_serie AS CHARACTER FORMAT "x(3)"
    FIELDS tt_nrodoc AS CHARACTER FORMAT "x(7)"
    FIELDS tt_fchdoc AS DATE
    FIELDS tt_imptot AS DECIMAL FORMAT "->,>>>,>>9.99"
    FIELDS tt_impret AS DECIMAL FORMAT "->,>>>,>>9.99"
    FIELDS tt_codmon AS INTEGER
    FIELDS tt_tpocmb AS CHARACTER FORMAT "x(20)"
    INDEX tt_idx1 AS PRIMARY tt_nroret.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor..." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando..." FONT 7.

FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

cCodDoc = "RET".
cCodOpe = "002,005".

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchAst COMBO-BOX-serie ~
FILL-IN-NroComp FILL-IN-NroComp-2 BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchAst COMBO-BOX-serie ~
FILL-IN-NroComp FILL-IN-NroComp-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE COMBO-BOX-serie AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchAst AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroComp AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroComp-2 AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchAst AT ROW 1.54 COL 13 COLON-ALIGNED WIDGET-ID 8
     COMBO-BOX-serie AT ROW 2.62 COL 13 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NroComp AT ROW 3.69 COL 13 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NroComp-2 AT ROW 3.69 COL 32 COLON-ALIGNED WIDGET-ID 14
     BUTTON-1 AT ROW 5.04 COL 28
     BUTTON-2 AT ROW 5.04 COL 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62 BY 6
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
         TITLE              = "Impresión de Comprobantes de Retención"
         HEIGHT             = 6
         WIDTH              = 62
         MAX-HEIGHT         = 6
         MAX-WIDTH          = 62
         VIRTUAL-HEIGHT     = 6
         VIRTUAL-WIDTH      = 62
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

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Impresión de Comprobantes de Retención */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Impresión de Comprobantes de Retención */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:

    ASSIGN COMBO-BOX-serie FILL-IN-FchAst FILL-IN-NroComp FILL-IN-NroComp-2.
    RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cNroComp AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNroComp1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPorRetencion AS DECIMAL NO-UNDO.
    DEF VAR x-Factor AS INT NO-UNDO.

    DEFINE BUFFER b_cb-dmov FOR cb-dmov.

    ASSIGN
        cNroComp = COMBO-BOX-serie + STRING(FILL-IN-NroComp,"999999")
        cNroComp1 = COMBO-BOX-serie + STRING(FILL-IN-NroComp-2,"999999").

    FOR EACH tt_ret:
        DELETE tt_ret.
    END.

    /* Determina % de Retención */
    FIND FIRST cb-tabl WHERE cb-tabl.Tabla = "RET" NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl THEN
        ASSIGN
            dPorRetencion = DECIMAL(cb-tabl.Codigo) NO-ERROR.

    FOR EACH cb-cmov FIELDS
        (cb-cmov.CodCia cb-cmov.Periodo cb-cmov.NroMes
        cb-cmov.CodOpe cb-cmov.FchAst cb-cmov.codmon cb-cmov.tpocmb) WHERE
        cb-cmov.CodCia = s-CodCia AND
        cb-cmov.Periodo = YEAR(FILL-IN-FchAst) AND
        cb-cmov.NroMes = MONTH(FILL-IN-FchAst) AND
        LOOKUP(cb-cmov.CodOpe,cCodOpe) > 0 AND
        cb-cmov.FchAst = FILL-IN-FchAst NO-LOCK,
        EACH cb-dmov FIELDS
        (cb-dmov.CodCia cb-dmov.Periodo cb-dmov.NroMes cb-dmov.CodOpe
        cb-dmov.NroAst cb-dmov.chr_01 cb-dmov.codaux cb-dmov.coddoc cb-dmov.CodCta
        cb-dmov.nrodoc cb-dmov.fchdoc cb-dmov.ImpMn1 cb-dmov.TpoMov) WHERE
        cb-dmov.CodCia = cb-cmov.CodCia AND
        cb-dmov.Periodo = cb-cmov.Periodo AND
        cb-dmov.NroMes = cb-cmov.NroMes AND
        cb-dmov.CodOpe = cb-cmov.CodOpe AND
        cb-dmov.NroAst = cb-cmov.NroAst AND
        cb-dmov.chr_01 <> "" NO-LOCK:

        DISPLAY
            cb-dmov.NroAst @ Fi-Mensaje LABEL " Nro Asiento" FORMAT "X(11)"
            WITH FRAME F-Proceso.

        IF cb-dmov.TpoMov = YES THEN x-Factor = 1. ELSE x-Factor = -1.
        IF cb-dmov.chr_01 >= cNroComp AND
            cb-dmov.chr_01 <= cNroComp1 THEN DO:
            CREATE tt_ret.
            ASSIGN
                tt_nroret = cb-dmov.chr_01
                tt_fchast = cb-cmov.fchast
                tt_nroast = cb-cmov.nroast
                tt_codpro = cb-dmov.codaux
                tt_coddoc = cb-dmov.coddoc
                tt_fchdoc = cb-dmov.fchdoc
                tt_codmon = cb-cmov.codmon
                tt_impret = cb-dmov.ImpMn1 * x-Factor.
            IF tt_coddoc = "37" THEN DO:
                tt_serie = "".
                tt_nrodoc = cb-dmov.nrodoc.
            END.
            ELSE DO:
                IF NUM-ENTRIES(cb-dmov.nrodoc,"-") > 1 THEN DO:
                    tt_serie = ENTRY(1,cb-dmov.nrodoc,"-").
                    tt_nrodoc = ENTRY(2,cb-dmov.nrodoc,"-").
                END.
                ELSE DO:
                    tt_serie = SUBSTRING(cb-dmov.nrodoc,1,3).
                    tt_nrodoc = SUBSTRING(cb-dmov.nrodoc,4).
                END.
            END.
            /* Busca el Monto Pagado */
            IF cb-cmov.CodOpe = "002" THEN FOR EACH b_cb-dmov
                FIELDS (b_cb-dmov.CodCia b_cb-dmov.Periodo b_cb-dmov.NroMes b_cb-dmov.CodOpe
                    b_cb-dmov.NroAst b_cb-dmov.CodCta b_cb-dmov.CodAux b_cb-dmov.CodDoc
                    b_cb-dmov.NroDoc b_cb-dmov.ImpMn1 b_cb-dmov.ImpMn2 b_cb-dmov.TpoMov)
                WHERE b_cb-dmov.CodCia = cb-dmov.CodCia
                AND b_cb-dmov.Periodo = cb-dmov.Periodo
                AND b_cb-dmov.NroMes = cb-dmov.NroMes
                AND b_cb-dmov.CodOpe = cb-dmov.CodOpe
                AND b_cb-dmov.NroAst = cb-dmov.NroAst
                NO-LOCK:
                IF b_cb-dmov.TpoMov = NO THEN x-Factor = 1. ELSE x-Factor = -1.
                IF b_cb-dmov.CodCta <> cb-dmov.CodCta AND
                    b_cb-dmov.CodAux = cb-dmov.CodAux AND
                    b_cb-dmov.CodDoc = cb-dmov.CodDoc AND
                    b_cb-dmov.NroDoc = cb-dmov.NroDoc THEN
                    IF cb-cmov.codmon = 1 THEN
                        tt_imptot = b_cb-dmov.ImpMn1 * x-Factor.
                    ELSE
                        tt_imptot = b_cb-dmov.ImpMn2 * x-Factor.
            END.
            ELSE DO:
                IF cb-dmov.TpoMov = NO THEN x-Factor = 1. ELSE x-Factor = -1.
                IF cb-cmov.codmon = 1 THEN
                    tt_imptot = ROUND(((cb-dmov.ImpMn1 * 100) / dPorRetencion),2) * x-Factor.
                ELSE
                    tt_imptot = ROUND(((cb-dmov.ImpMn2 * 100) / dPorRetencion),2) * x-Factor.
            END.

            /* Tipo de Cambio */
            IF cb-cmov.tpocmb <> 0 THEN
                tt_tpocmb = "TPO. CAMBIO: " + STRING(cb-cmov.tpocmb,">>9.9<<").
        END.
    END.

    HIDE FRAME F-PROCESO.

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
  DISPLAY FILL-IN-FchAst COMBO-BOX-serie FILL-IN-NroComp FILL-IN-NroComp-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-FchAst COMBO-BOX-serie FILL-IN-NroComp FILL-IN-NroComp-2 
         BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
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

    DEFINE VARIABLE cNomPro LIKE gn-prov.NomPro NO-UNDO.
    DEFINE VARIABLE cRuc LIKE gn-prov.Ruc NO-UNDO.
    DEFINE VARIABLE iInd AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCounReg AS INTEGER NO-UNDO.
    DEFINE VARIABLE cSymbol AS CHARACTER FORMAT "x(3)" NO-UNDO.
    DEFINE VARIABLE cSymRet AS CHARACTER FORMAT "x(4)" INITIAL " S/." NO-UNDO.
    DEFINE VARIABLE dTotal AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cImpLet AS CHARACTER FORMAT "x(80)" NO-UNDO.

    FIND FIRST tt_ret NO-LOCK NO-ERROR.

    DEFINE FRAME F-REPORTE
        tt_coddoc AT 5
        tt_serie  AT 14
        tt_nrodoc AT 28
        tt_fchdoc AT 48
        cSymbol AT 60
        tt_imptot AT 64
        cSymRet
        tt_impret
        WITH WIDTH 200 NO-BOX NO-LABELS STREAM-IO DOWN.

    DEFINE FRAME F-HEADER
        HEADER
        "" SKIP(5)
        cNomPro AT 10 SKIP
        cRuc AT 6 SKIP
        tt_tpocmb TO 46 SKIP
        tt_fchast AT 14
        tt_nroret TO 46 tt_nroast SKIP(3)
        WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO.

    FOR EACH tt_ret
        BREAK BY tt_nroret:
        IF FIRST-OF(tt_nroret) THEN DO:
            FOR gn-prov
                FIELDS (gn-prov.CodCia gn-prov.CodPro gn-prov.NomPro gn-prov.Ruc)
                WHERE gn-prov.CodCia = pv-CodCia
                AND gn-prov.CodPro = tt_codpro
                NO-LOCK:
            END.
            IF AVAILABLE gn-prov THEN DO:
                cNomPro = gn-prov.NomPro.
                cRuc = gn-prov.Ruc.
            END.
            ELSE DO:
                cNomPro = "".
                cRuc = "".
            END.
            iCounReg = 0.
            cSymbol = IF tt_codmon = 1 THEN "S/." ELSE "US$".
            VIEW STREAM REPORT FRAME F-HEADER.
        END.

        ACCUMULATE tt_imptot (TOTAL BY tt_nroret).
        ACCUMULATE tt_impret (TOTAL BY tt_nroret).
        iCounReg = iCounReg + 1.

        DISPLAY STREAM REPORT
            tt_coddoc
            tt_serie
            tt_nrodoc
            tt_fchdoc
            cSymbol
            tt_imptot
            cSymRet
            tt_impret
            WITH FRAME F-REPORTE.

        IF LAST-OF(tt_nroret) THEN DO:
            DO iInd = (iCounReg + 1) TO 10:
                PUT STREAM REPORT "" SKIP.
            END.
            DOWN 1 STREAM REPORT WITH FRAME F-REPORTE.
            dTotal = ACCUM TOTAL BY tt_nroret tt_impret.

            RUN bin/_numero.p(dTotal, 2, 1, OUTPUT cImpLet).

            DISPLAY STREAM REPORT
                cSymbol
                cSymRet
                ACCUM TOTAL BY tt_nroret tt_imptot @ tt_imptot
                ACCUM TOTAL BY tt_nroret tt_impret @ tt_impret
                WITH FRAME F-REPORTE.

            DOWN 1 STREAM REPORT WITH FRAME F-REPORTE.
            cImpLet = cImpLet + " " + "NUEVOS SOLES".

            PUT STREAM REPORT UNFORMATTED cImpLet SKIP.
            PAGE.
        END.

    END.

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
    DEFINE VARIABLE lRpta AS LOGICAL INITIAL TRUE NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

    FIND FIRST tt_ret NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt_ret THEN DO:
        MESSAGE
            "No existen Comprobantes a Imprimir"
            VIEW-AS ALERT-BOX INFORMA.
        RETURN.
    END.
    MESSAGE
        "Va a comenzar a Imprimir desde el Nro" tt_nroret SKIP
        "¿Desea Continuar?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE lRpta.
    IF lRpta <> TRUE THEN RETURN.

    IF s-salida-impresion = 1 THEN
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 33.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 33. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn2}.
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

    DEFINE VARIABLE cListSer AS CHARACTER NO-UNDO.

    FOR EACH faccorre WHERE
        faccorre.codcia = s-codcia AND
        faccorre.coddoc = cCodDoc AND
        faccorre.NroSer >= 0 NO-LOCK:
        IF FlgEst THEN DO:
            IF cListSer = "" THEN cListSer = STRING(faccorre.NroSer,"999").
            ELSE cListSer = cListSer + "," + STRING(faccorre.NroSer,"999").
            FILL-IN-NroComp = faccorre.correlativo.
        END.
    END.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-FchAst = TODAY
            FILL-IN-NroComp-2 = FILL-IN-NroComp
            COMBO-BOX-serie:LIST-ITEMS = cListSer
            COMBO-BOX-serie = ENTRY(1,cListSer).
    END.

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
        WHEN "FILL-IN-CCosto" THEN 
            ASSIGN
                input-var-1 = "CCO"
                input-var-2 = ""
                input-var-3 = "".
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

