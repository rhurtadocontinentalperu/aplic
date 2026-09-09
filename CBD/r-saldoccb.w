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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.
DEFINE SHARED VAR cl-codcia AS INT.

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
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
&Scoped-Define ENABLED-OBJECTS FILL-IN-date-1 FILL-IN-date-2 FILL-IN-CodCli ~
Btn_Excel Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-date-1 FILL-IN-date-2 ~
FILL-IN-CodCli FILL-IN-NomCli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5 TOOLTIP "Cancelar"
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5 TOOLTIP "Aceptar"
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-date-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-date-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-date-1 AT ROW 1.38 COL 11 COLON-ALIGNED
     FILL-IN-date-2 AT ROW 1.38 COL 27 COLON-ALIGNED
     FILL-IN-CodCli AT ROW 2.54 COL 11 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NomCli AT ROW 2.54 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     Btn_Excel AT ROW 3.69 COL 31
     Btn_OK AT ROW 3.69 COL 43
     Btn_Cancel AT ROW 3.69 COL 55
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.29 BY 4.69
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
         TITLE              = "Reporte de Saldo de Documentos a una Fecha"
         HEIGHT             = 4.69
         WIDTH              = 68.29
         MAX-HEIGHT         = 5.38
         MAX-WIDTH          = 75.14
         VIRTUAL-HEIGHT     = 5.38
         VIRTUAL-WIDTH      = 75.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
ASSIGN 
       Btn_Excel:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Saldo de Documentos a una Fecha */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Saldo de Documentos a una Fecha */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:

    ASSIGN FILL-IN-date-1 FILL-IN-date-2.
    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:

    ASSIGN FILL-IN-date-1 FILL-IN-date-2 FILL-IN-CodCli.
    RUN Imprime.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo W-Win 
PROCEDURE Carga-Tempo :
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
  DISPLAY FILL-IN-date-1 FILL-IN-date-2 FILL-IN-CodCli FILL-IN-NomCli 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-date-1 FILL-IN-date-2 FILL-IN-CodCli Btn_Excel Btn_OK 
         Btn_Cancel 
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

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1.
    DEFINE VARIABLE cColumn            AS CHARACTER.
    DEFINE VARIABLE cRange             AS CHARACTER.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE DETRACCIONES".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "ASIENTO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CUENTA".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "AUXILIAR".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "GLOSA".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "CD".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOCUMENTO".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "% DETRACCION".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE S/.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "DETRACCION S/.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO S/.".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "TIPO CAMBIO".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE US$".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "DETRACCION US$".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO US$".

    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("G"):NumberFormat = "@".
    chWorkSheet:Columns("H"):NumberFormat = "@".
    chWorkSheet:Columns("E"):ColumnWidth = 45.
    chWorkSheet:Columns("F"):ColumnWidth = 45.
    chWorkSheet:Range("A1:P2"):Font:Bold = TRUE.

/*
    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.codcia = s-codcia AND
        cb-dmov.periodo = COMBO-periodo AND
        cb-dmov.nromes >= iNroMes AND
        cb-dmov.nromes <= iNroMes-1 AND
        cb-dmov.codope = cCodOpe AND
        LOOKUP(cb-dmov.codcta,cListCta) > 0 AND
        cb-dmov.codaux >= FILL-IN-CodAux AND
        cb-dmov.codaux <= FILL-IN-CodAux-1,
        FIRST cb-cmov NO-LOCK WHERE
            cb-cmov.codcia = cb-dmov.codcia AND
            cb-cmov.periodo = cb-dmov.periodo AND
            cb-cmov.nromes = cb-dmov.nromes AND
            cb-cmov.codope = cb-dmov.codope AND
            cb-cmov.nroast = cb-dmov.nroast
        BREAK BY cb-dmov.nromes BY cb-dmov.nroast:
        IF FIRST-OF(cb-dmov.nroast) THEN DO:
            IF NUM-ENTRIES(cb-cmov.GloAst,"-") > 1 THEN
                dPordet = DECIMAL(ENTRY(1,cb-cmov.GloAst,"-")) NO-ERROR.
            ELSE dPordet = DECIMAL(cb-cmov.GloAst) NO-ERROR.
            dTotImp1 = 0.
        END.
        IF cb-dmov.TM = 8 THEN dTotImp1 = dTotImp1 + ImpMn1.
        IF LAST-OF(cb-dmov.nroast) AND
            dPordet <> 0 AND dTotImp1 <> 0 THEN DO:
            dDetImp1 = ROUND((dTotImp1 * (dPordet / 100)),0).
            dSalImp1 = dTotImp1 - dDetImp1.
            IF cb-cmov.codmon = 2 THEN DO:
                dTotImp2 = ROUND((dTotImp1 / cb-cmov.tpocmb),2).
                dDetImp2 = ROUND((dDetImp1 / cb-cmov.tpocmb),2).
                dSalImp2 = dTotImp2 - dDetImp2.
            END.
            ELSE DO:
                dTotImp2 = 0.
                dDetImp2 = 0.
                dSalImp2 = 0.
            END.
            cNomAux = "".
            CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    cTipAux = "Cliente".
                    FIND gn-clie WHERE
                        gn-clie.codcli = cb-dmov.codaux AND
                        gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-clie THEN cNomAux = gn-clie.nomcli.
                END.
                WHEN "@PV" THEN DO:
                    cTipAux = "Proveedor".
                    FIND gn-prov WHERE
                        gn-prov.codpro = cb-dmov.codaux AND
                        gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN cNomAux = gn-prov.nompro.
                END.
                WHEN "@CT" THEN DO:
                    cTipAux = "Cuenta".
                    find cb-ctas WHERE
                        cb-ctas.codcta = cb-dmov.codaux AND
                        cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN cNomAux = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    cTipAux = "Otro".
                    FIND cb-auxi WHERE
                        cb-auxi.clfaux = cb-dmov.clfaux AND
                        cb-auxi.codaux = cb-dmov.codaux AND
                        cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-auxi THEN cNomAux = cb-auxi.nomaux.
                END.
            END CASE.

            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.codcta.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.codaux.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = cNomAux.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.glodoc.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.coddoc.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.nrodoc.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = dPordet.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotImp1.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = dDetImp1.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = dSalImp1.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.tpocmb.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotImp2.
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = dDetImp2.
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = dSalImp2.

            DISPLAY
                "   " + cTipAux + ": " + cb-dmov.codaux @ FI-MENSAJE
                WITH FRAME F-PROCESO.
        END.
    END.
*/

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

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

    DEFINE VARIABLE cMoneda AS CHARACTER FORMAT "XXX" LABEL "Mon" NO-UNDO.
    DEFINE VARIABLE dSdoAct LIKE ccbcdocu.sdoact COLUMN-LABEL "Saldo" NO-UNDO.
    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
    DEF VAR pEstado AS CHAR FORMAT 'x(20)' NO-UNDO.

    DEFINE FRAME f-cab
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-nomcia + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(80)" SKIP
        "REPORTE SALDO DE DOCUMENTOS AL" FORMAT "x(30)" AT 56 FILL-IN-date-2
        "Página :" AT 132 PAGE-NUMBER(report) FORMAT "ZZ9" SKIP
        "Fecha  :" AT 132 STRING(TODAY,"99/99/99")
        "Hora   :" AT 132 STRING(TIME,"HH:MM:SS") SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    VIEW STREAM report FRAME f-cab.

    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddiv <> "" AND
        (FILL-IN-CodCli = "" OR ccbcdocu.codcli = FILL-IN-CodCli) AND
        ccbcdocu.fchdoc >= FILL-IN-date-1 AND
        ccbcdocu.fchdoc <= FILL-IN-date-2 AND
        LOOKUP(ccbcdocu.coddoc,"A/R,FAC,BOL,LET,N/C,N/D,BD,CHQ") > 0 AND
        ccbcdocu.nrodoc >= "" AND
        ccbcdocu.flgest <> "A" NO-LOCK
        WITH FRAME f-det WIDTH 400:
        IF Ccbcdocu.flgest = "S" THEN NEXT.
        /* RHC 16/11/2015 En caso de LET NO deben aparecer hasta la fecha 
           en que fueron aprobadas */
        IF Ccbcdocu.coddoc = 'LET' THEN DO:
            FIND Ccbcmvto WHERE Ccbcmvto.codcia = Ccbcdocu.codcia
                AND Ccbcmvto.coddoc = Ccbcdocu.codref
                AND Ccbcmvto.nrodoc = Ccbcdocu.nroref
                NO-LOCK NO-ERROR.
            IF NOT (AVAILABLE Ccbcmvto AND Ccbcmvto.flgest = 'E'
                AND Ccbcmvto.FchApr >= FILL-IN-date-1
                AND Ccbcmvto.FchApr <= FILL-IN-date-2) THEN NEXT.
        END.
        /* ************************************************************** */
        

        IF ccbcdocu.fchcan <= FILL-IN-date-2 THEN NEXT.
        dSdoAct = ccbcdocu.imptot.
        lOk = FALSE.

        /* Amortización */
        IF LOOKUP(ccbcdocu.coddoc,"BD,A/R,N/C") > 0 THEN DO:
            IF CAN-FIND(FIRST ccbdmov WHERE
                ccbdmov.codcia = ccbcdocu.codcia AND
                ccbdmov.coddoc = ccbcdocu.coddoc AND
                ccbdmov.nrodoc = ccbcdocu.nrodoc) THEN DO:
                lOk = TRUE.
            END.
            FOR EACH ccbdmov NO-LOCK WHERE
                ccbdmov.codcia = ccbcdocu.codcia AND
                ccbdmov.coddoc = ccbcdocu.coddoc AND
                ccbdmov.nrodoc = ccbcdocu.nrodoc AND
                ccbdmov.FchMov <= FILL-IN-date-2:
                dSdoAct = dSdoAct - ccbdmov.ImpTot.
            END.
        END.
        ELSE FOR EACH ccbdcaja NO-LOCK WHERE
            ccbdcaja.codcia = ccbcdocu.codcia AND
            ccbdcaja.codref = ccbcdocu.coddoc AND
            ccbdcaja.nroref = ccbcdocu.nrodoc AND
            ccbdcaja.fchdoc <= FILL-IN-date-2:
            dSdoAct = dSdoAct - ccbdcaja.imptot.
            lOk = TRUE.
        END.
        IF NOT lOk AND ccbcdocu.coddoc = "N/C" THEN
            dSdoAct = ccbcdocu.sdoact.
        IF ccbcdocu.coddoc = "BD" AND LOOKUP(ccbcdocu.FlgEst,"X") > 0 THEN NEXT.
        IF NOT lOk AND ccbcdocu.coddoc = "BD" AND LOOKUP(ccbcdocu.FlgEst,"C") > 0 THEN NEXT.
        IF dSdoAct <= 0 THEN NEXT.

        cMoneda = IF ccbcdocu.codmon = 1 THEN "S/." ELSE "US$".

        RUN gn/fFlgEstCCBv2 (ccbcdocu.coddoc,
                     ccbcdocu.flgest,
                     OUTPUT pEstado).

        DISPLAY STREAM report
            ccbcdocu.codcli
            ccbcdocu.nomcli
            ccbcdocu.coddoc COLUMN-LABEL "Cod"
            ccbcdocu.nrodoc FORMAT 'x(15)'
            ccbcdocu.fchdoc FORMAT "99/99/99" COLUMN-LABEL "Emisión"
            ccbcdocu.FchVto FORMAT "99/99/99" COLUMN-LABEL "Vencto"
            cMoneda
            ccbcdocu.imptot COLUMN-LABEL "Importe"
            dSdoAct
            pEstado COLUMN-LABEL 'Estado Actual'
            ccbcdocu.divori FORMAT 'X(6)' COLUMN-LABEL 'Division Origen'
            WITH STREAM-IO.
        DISPLAY
            ccbcdocu.nrodoc @ FI-MENSAJE LABEL "    Documento"
            WITH FRAME F-PROCESO.

    END.
    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
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

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-date-1 = DATE(MONTH(TODAY),1,YEAR(TODAY))
            FILL-IN-date-2 = TODAY.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    Btn_Excel:VISIBLE = FALSE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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
        WHEN "F-Catconta" THEN ASSIGN input-var-1 = "CC".
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "" THEN ASSIGN input-var-1 = "".
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

