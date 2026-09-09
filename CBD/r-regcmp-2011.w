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

{cbd\cbglobal.i}

DEFINE NEW SHARED VARIABLE lh_Handle AS HANDLE.

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-NomCia AS CHARACTER.
DEFINE SHARED VARIABLE pv-codcia AS INT.

DEFINE STREAM REPORT.

DEFINE TEMP-TABLE Registro NO-UNDO
    FIELDS CodDiv AS CHARACTER
    FIELDS CodOpe AS CHARACTER
    FIELDS NroAst AS CHARACTER
    FIELDS FchDoc AS DATE
    FIELDS FchVto AS DATE
    FIELDS CodDoc AS CHARACTER
    FIELDS NroDoc AS CHARACTER
    FIELDS TpoCmb AS DECIMAL 
    FIELDS CodRef AS CHARACTER
    FIELDS NroRef AS CHARACTER
    FIELDS FchRef AS DATE
    FIELDS TpoDoc AS CHARACTER
    FIELDS Ruc    AS CHARACTER
    FIELDS NomPro AS CHARACTER
    FIELDS CodMon AS CHARACTER
    FIELDS Implin AS DECIMAL EXTENT 10
    FIELDS AnoDUA AS CHARACTER
    FIELDS NroTra AS CHAR
    FIELDS FchMod AS DATE
    FIELDS imports AS LOGICAL
    INDEX idx01 IS PRIMARY CodOpe NroAst.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RADIO-CodMon ~
COMBO-mesini COMBO-mesfin COMBO-TipDoc FILL-IN-CodOpe Btn_OK Btn_Cancel ~
Btn_Excel 
&Scoped-Define DISPLAYED-OBJECTS RADIO-CodMon COMBO-mesini COMBO-mesfin ~
COMBO-TipDoc FILL-IN-CodOpe 

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
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 12 BY 1.5 TOOLTIP "Migrar a Excel".

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-mesfin AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Mes Fin" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-mesini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Mes Inicio" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-TipDoc AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Tipo Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodOpe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operación" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-CodMon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 8 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 4.04
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 2.42
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66 BY 2.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-CodMon AT ROW 1.81 COL 55 NO-LABEL WIDGET-ID 40
     COMBO-mesini AT ROW 2.08 COL 14 COLON-ALIGNED WIDGET-ID 30
     COMBO-mesfin AT ROW 2.08 COL 34 COLON-ALIGNED WIDGET-ID 28
     COMBO-TipDoc AT ROW 2.88 COL 14 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-CodOpe AT ROW 3.69 COL 8.14 WIDGET-ID 34
     Btn_OK AT ROW 6.12 COL 28 WIDGET-ID 26
     Btn_Cancel AT ROW 6.12 COL 41 WIDGET-ID 24
     Btn_Excel AT ROW 6.12 COL 54 WIDGET-ID 22
     " Moneda" VIEW-AS TEXT
          SIZE 7.14 BY .65 AT ROW 1 COL 54 WIDGET-ID 50
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 44
     RECT-2 AT ROW 1.27 COL 53 WIDGET-ID 46
     RECT-3 AT ROW 5.58 COL 1 WIDGET-ID 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.14 BY 7.04
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
         TITLE              = "Libro de Compras - 2011"
         HEIGHT             = 7.04
         WIDTH              = 66.14
         MAX-HEIGHT         = 7.04
         MAX-WIDTH          = 66.14
         VIRTUAL-HEIGHT     = 7.04
         VIRTUAL-WIDTH      = 66.14
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
/* SETTINGS FOR FILL-IN FILL-IN-CodOpe IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Libro de Compras - 2011 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Libro de Compras - 2011 */
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
    RUN local-exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            RADIO-CodMon
            COMBO-TipDoc
            FILL-IN-CodOpe
            COMBO-mesfin
            COMBO-mesini.
    END.
    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            RADIO-CodMon
            COMBO-TipDoc
            FILL-IN-CodOpe
            COMBO-mesfin
            COMBO-mesini.
    END.
    RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}
{lib/def-prn2.i}

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

    DEFINE VARIABLE cCodOpe AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ind AS INTEGER NO-UNDO.
    DEFINE VARIABLE dDebe AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dHaber AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cNomPro AS CHARACTER NO-UNDO.
    DEFINE VARIABLE fFchDoc AS DATE NO-UNDO.
    DEFINE VARIABLE fFchVto AS DATE NO-UNDO.
    DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNroDoc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodRef AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNroRef AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRuc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMoneda AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dTpoCmb AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dImpLin AS DECIMAL EXTENT 10 NO-UNDO.
    DEFINE VARIABLE lImports AS LOGICAL NO-UNDO.
    DEFINE VARIABLE fFchRef AS DATE NO-UNDO.

    DISPLAY WITH FRAME F-Mensaje.

    FOR EACH Registro:
        DELETE Registro.
    END.

    DO ind = 1 TO NUM-ENTRIES(FILL-IN-CodOpe):
        cCodOpe = ENTRY(ind, FILL-IN-CodOpe).
        FOR EACH cb-cmov NO-LOCK WHERE
            cb-cmov.CodCia = s-CodCia AND
            cb-cmov.Periodo = s-Periodo AND
            cb-cmov.NroMes >= COMBO-mesini AND
            cb-cmov.NroMes <= COMBO-mesfin AND
            cb-cmov.CodOpe = cCodOpe
            BREAK BY cb-cmov.NroAst:
            IF cb-cmov.flgest = "A" THEN DO:
                CREATE Registro.
                ASSIGN
                    Registro.CodDiv = cb-cmov.CodDiv
                    Registro.NroAst = cb-cmov.NroAst
                    Registro.CodOpe = cCodOpe
                    Registro.NomPro = "*** ANULADO ***".
                NEXT.
            END.
            FOR EACH cb-dmov NO-LOCK WHERE
                cb-dmov.CodCia = cb-cmov.CodCia AND
                cb-dmov.Periodo = cb-cmov.Periodo AND
                cb-dmov.NroMes = cb-cmov.NroMes AND
                cb-dmov.CodOpe = cb-cmov.CodOpe AND
                (cb-dmov.CodDoc = COMBO-TipDoc OR
                COMBO-TipDoc = "Todos") AND
                cb-dmov.NroAst = cb-cmov.NroAst
                BREAK BY cb-dmov.NroAst:
                IF FIRST-OF (cb-dmov.NroAst) THEN DO:
                     fFchDoc = ?.
                     fFchVto = ?.
                     cCodDoc = "".
                     cNroDoc = "".
                     cMoneda = "".
                     cNomPro = "".
                     cRuc = "".
                     cNroRef = "".
                     cCodRef = "".
                     dTpoCmb = 0.
                     dImpLin = 0.
                     lImports = FALSE.
                END.
                IF NOT tpomov THEN DO:
                    CASE RADIO-codmon:
                    WHEN 1 THEN DO:
                        dDebe  = ImpMn1.
                        dHaber = 0.
                    END.
                    WHEN 2 THEN DO:
                        dDebe  = ImpMn2.
                        dHaber = 0.
                    END.
                    END CASE.
                END.
                ELSE DO:      
                    CASE RADIO-codmon:
                    WHEN 1 THEN DO:
                        dDebe  = 0.
                        dHaber = ImpMn1.
                    END.
                    WHEN 2 THEN DO:
                        dDebe  = 0.
                        dHaber = ImpMn2.
                    END.
                    END CASE.
                END.
                CASE cb-dmov.TM :
                    WHEN 3 THEN dImpLin[1] = dImpLin[1] + (dDebe - dHaber).
                    WHEN 5 THEN dImpLin[3] = dImpLin[3] + (dDebe - dHaber).
                    WHEN 4 THEN dImpLin[4] = dImpLin[4] + (dDebe - dHaber).
                    WHEN 6 THEN dImpLin[5] = dImpLin[5] + (dDebe - dHaber).
                    WHEN 10 THEN dImpLin[7] = dImpLin[7] + (dDebe - dHaber).
                    WHEN 7 THEN dImpLin[8] = dImpLin[8] + (dDebe - dHaber).
                    WHEN 8 OR WHEN 11 THEN DO:
                        dImpLin[10] = dImpLin[10] + (dHaber - dDebe).
                        IF dImpLin[10] < 0 THEN DO:
                            IF cb-dmov.CodMon = 2 THEN 
                                ASSIGN
                                    dImpLin[9] = dImpLin[9] + cb-dmov.ImpMn2 * -1
                                    dTpoCmb = cb-dmov.TpoCmb.                        
                        END.
                        ELSE DO:
                            IF cb-dmov.CodMon = 2 THEN 
                                ASSIGN
                                    dImpLin[9] = dImpLin[9] + cb-dmov.ImpMn2
                                    dTpoCmb = cb-dmov.TpoCmb.
                        END.
                        fFchDoc = cb-dmov.FchDoc.
                        cCodDoc = cb-dmov.CodDoc.
                        cNroDoc = cb-dmov.NroDoc.
                        /*fFchVto = IF cCodDoc = "14" OR cCodDoc = "50" THEN cb-dmov.FchVto ELSE ?.*/
                        fFchVto = cb-dmov.FchVto.
                        cMoneda = IF cb-dmov.CodMon = 1 THEN "S/." ELSE "US$".
                        cRuc = cb-dmov.NroRuc.
                        cNroRef = cb-dmov.Nroref.
                        cCodRef = cb-dmov.CodRef.
                        fFchRef = cb-dmov.dte_01.
                        FIND GN-PROV WHERE
                            GN-PROV.CodCia = pv-codcia AND
                            GN-PROV.codPro = cb-dmov.CodAux
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE GN-PROV THEN cNomPro = GN-PROV.NomPro.
                        ELSE cNomPro = cb-dmov.GloDoc.
                        IF cb-dmov.TM = 11 THEN lImports = TRUE.
                    END.
                END CASE.
                IF LAST-OF (cb-dmov.NroAst) THEN DO:
                    CREATE Registro.
                    Registro.CodDiv = cb-dmov.CodDiv.
                    Registro.NroAst = cb-dmov.NroAst.
                    Registro.CodOpe = cCodOpe.
                    Registro.FchDoc = fFchDoc.
                    Registro.FchVto = fFchVto.
                    Registro.CodDoc = cCodDoc.
                    Registro.NroDoc = cNroDoc.
                    Registro.CodRef = cCodRef.
                    Registro.NroRef = cNroRef.
                    Registro.FchRef = fFchRef.
                    Registro.Ruc = cRuc.
                    Registro.NomPro = cNomPro.
                    Registro.CodMon = cMoneda.
                    Registro.TpoCmb = dTpoCmb.
                    Registro.ImpLin[1] = dImpLin[1].
                    Registro.ImpLin[2] = dImpLin[2].
                    Registro.ImpLin[3] = dImpLin[3].
                    Registro.ImpLin[4] = dImpLin[4].
                    Registro.ImpLin[5] = dImpLin[5].
                    Registro.ImpLin[6] = dImpLin[6].
                    Registro.ImpLin[7] = dImpLin[7].
                    Registro.ImpLin[8] = dImpLin[8].
                    Registro.ImpLin[9] = dImpLin[9].
                    Registro.ImpLin[10] = dImpLin[10].
                    registro.NroTra = cb-cmov.Nrotra.
                    Registro.FchMod = cb-cmov.fchmod.
                    Registro.imports = lImports.
                    CASE Registro.CodDoc:
                        WHEN "50" THEN DO:
                            IF NUM-ENTRIES(Registro.NroDoc, "-") > 2 THEN
                                Registro.AnoDua = ENTRY(3,Registro.NroDoc, "-").
                        END.
                    END CASE.
                    IF LENGTH(Registro.Ruc) = 11 THEN Registro.TpoDoc = "06". ELSE Registro.TpoDoc = "00".
                END.
            END. /* FIN DEL FOR cb-dmov */
        END. /* FIN DEL FOR cb-cmov */
    END. /* FIN DEL DO */

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
  DISPLAY RADIO-CodMon COMBO-mesini COMBO-mesfin COMBO-TipDoc FILL-IN-CodOpe 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 RECT-3 RADIO-CodMon COMBO-mesini COMBO-mesfin 
         COMBO-TipDoc FILL-IN-CodOpe Btn_OK Btn_Cancel Btn_Excel 
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

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 2 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cTitulo AS CHARACTER FORMAT "X(50)" NO-UNDO.
    DEFINE VARIABLE cNroSer AS CHAR NO-UNDO.
    DEFINE VARIABLE cNroDoc AS CHAR NO-UNDO.
    DEFINE VARIABLE cSerRef AS CHAR NO-UNDO.
    DEFINE VARIABLE cNroRef AS CHAR NO-UNDO.
    DEFINE VARIABLE cNroDocND AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMes1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMes2 AS CHARACTER NO-UNDO.

    RUN bin/_mes.p (INPUT COMBO-mesini, 1, OUTPUT cMes1).
    IF COMBO-mesini <> COMBO-mesfin THEN
        RUN bin/_mes.p (INPUT COMBO-mesfin, 1, OUTPUT cMes2).

    IF cMes2 = "" THEN
        cTitulo = "MES DE " + cMes1 + " DE " + STRING(S-PERIODO,"9999").
    ELSE
        cTitulo = "DEL MES DE " + cMes1 + " AL MES " + cMes2 + " DE " + STRING(S-PERIODO,"9999").
    cTitulo = "REGISTRO DE COMPRAS " + cTitulo +
        " EXPRESADO EN " + IF RADIO-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".

    RUN Carga-Temporal.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:ADD().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    chWorkSheet:Range("A1"):VALUE = cTitulo.
    chWorkSheet:Range("A2"):VALUE = "Asiento".
    chWorkSheet:Range("B2"):VALUE = "Fch Emisión".
    chWorkSheet:Range("C2"):VALUE = "Fch Vencto".
    chWorkSheet:Range("D2"):VALUE = "CD".
    chWorkSheet:Range("E2"):VALUE = "Serie".
    chWorkSheet:Range("F2"):VALUE = "Año DUA".
    chWorkSheet:Range("G2"):VALUE = "Nro Compte".
    chWorkSheet:Range("H2"):VALUE = "TD".
    chWorkSheet:Range("I2"):VALUE = "Nro Proveedor".
    chWorkSheet:Range("J2"):VALUE = "Nombre/Razón Social".
    chWorkSheet:Range("K2"):VALUE = "Base Imp (A)".
    chWorkSheet:Range("L2"):VALUE = "Base Imp (B)".
    chWorkSheet:Range("M2"):VALUE = "Base Imp (C)".
    chWorkSheet:Range("N2"):VALUE = "No Gravadas".
    chWorkSheet:Range("O2"):VALUE = "I.G.V. A".
    chWorkSheet:Range("P2"):VALUE = "I.G.V. B".
    chWorkSheet:Range("Q2"):VALUE = "I.G.V. C".
    chWorkSheet:Range("R2"):VALUE = "Total".
    chWorkSheet:Range("S2"):VALUE = "Nro no Domic".
    chWorkSheet:Range("T2"):VALUE = "Tpo Cambio".
    chWorkSheet:Range("U2"):VALUE = "Fch Refer".
    chWorkSheet:Range("V2"):VALUE = "CD".
    chWorkSheet:Range("W2"):VALUE = "Serie".
    chWorkSheet:Range("X2"):VALUE = "Número".
    chWorkSheet:Range("Y2"):VALUE = "Operación".

    chWorkSheet:COLUMNS("A"):NumberFormat = "@".
    chWorkSheet:COLUMNS("D"):NumberFormat = "@".
    chWorkSheet:COLUMNS("E"):NumberFormat = "@".
    chWorkSheet:COLUMNS("F"):NumberFormat = "@".
    chWorkSheet:COLUMNS("G"):NumberFormat = "@".
    chWorkSheet:COLUMNS("H"):NumberFormat = "@".
    chWorkSheet:COLUMNS("I"):NumberFormat = "@".
    chWorkSheet:COLUMNS("V"):NumberFormat = "@".
    chWorkSheet:COLUMNS("W"):NumberFormat = "@".
    chWorkSheet:COLUMNS("X"):NumberFormat = "@".
    chWorkSheet:COLUMNS("D"):ColumnWidth = 5.
    chWorkSheet:COLUMNS("E"):ColumnWidth = 5.
    chWorkSheet:COLUMNS("H"):ColumnWidth = 5.
    chWorkSheet:COLUMNS("D"):ColumnWidth = 12.
    chWorkSheet:COLUMNS("V"):ColumnWidth = 5.
    chWorkSheet:COLUMNS("J"):ColumnWidth = 50.
    chWorkSheet:Range("A1:X2"):FONT:Bold = TRUE.

    loop:
    FOR EACH Registro NO-LOCK
        BREAK BY Registro.CodOpe
        BY Registro.NroAst
        ON ERROR UNDO, RETURN ERROR:
        ASSIGN
            cNroSer = ''
            cSerRef = ''
            cNroDoc = Registro.NroDoc
            cNroRef = Registro.NroRef.
        IF INDEX(cNroDoc, '-') > 0 THEN DO:
            cNroSer = SUBSTRING(cNroDoc, 1, INDEX(cNroDoc, '-') - 1).
            cNroDoc = ENTRY(2, cNroDoc, '-').
        END.         
        IF INDEX(cNroRef, '-') > 0 THEN DO:
            cSerRef = SUBSTRING(cNroRef, 1, INDEX(cNroRef, '-') - 1).
            cNroRef = ENTRY(2, cNroRef, '-').
        END.
        cNroDocND = "".
        IF Registro.CodDoc = "91" AND
            Registro.Imports THEN DO:
                cNroDocND = cNroDoc.
                cNroDoc = "".
        END.

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.NroAst.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.FchDoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.FchVto.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.CodDoc.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = cNroSer.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.AnoDUA.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = cNroDoc.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.TpoDoc.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.Ruc.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.NomPro.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.ImpLin[1].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.ImpLin[2].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.ImpLin[3].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.ImpLin[4].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.ImpLin[5].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.ImpLin[6].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.ImpLin[7].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.ImpLin[10].
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):VALUE = cNroDocND.
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.TpoCmb.
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.FchRef.
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.CodRef.
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):VALUE = cSerRef.
        cRange = "X" + cColumn.
        chWorkSheet:Range(cRange):VALUE = cNroRef.
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):VALUE = Registro.CodOpe.

        READKEY PAUSE 0.
        IF LASTKEY = KEYCODE("F10") THEN LEAVE loop.

    END. /* FOR EACH Registro... */

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-Mensaje.

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

    DEFINE VARIABLE cTitulo1 AS CHARACTER FORMAT "X(50)" NO-UNDO.
    DEFINE VARIABLE cTitulo2 AS CHARACTER FORMAT "X(260)" NO-UNDO.
    DEFINE VARIABLE cTitulo3 AS CHARACTER FORMAT "X(260)" NO-UNDO.
    DEFINE VARIABLE dVan AS DECIMAL EXTENT 10 NO-UNDO.
    DEFINE VARIABLE lKey AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cNroSer AS CHAR NO-UNDO.
    DEFINE VARIABLE cNroDoc AS CHAR NO-UNDO.
    DEFINE VARIABLE cSerRef AS CHAR NO-UNDO.
    DEFINE VARIABLE cNroRef AS CHAR NO-UNDO.
    DEFINE VARIABLE cNroDocND AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMes1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMes2 AS CHARACTER NO-UNDO.

    RUN bin/_mes.p (INPUT COMBO-mesini, 1, OUTPUT cMes1).
    IF COMBO-mesini <> COMBO-mesfin THEN
        RUN bin/_mes.p (INPUT COMBO-mesfin, 1, OUTPUT cMes2).

    cTitulo1 = "R E G I S T R O   D E   C O M P R A S".
    IF cMes2 = "" THEN
        cTitulo2 = "MES DE " + cMes1 + " DE " + STRING(S-PERIODO,"9999").
    ELSE
        cTitulo2 = "DEL MES DE " + cMes1 + " AL MES " + cMes2 + " DE " + STRING(S-PERIODO,"9999").
    cTitulo3 = "EXPRESADO EN " + IF RADIO-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
 
    RUN BIN/_centrar.p (INPUT cTitulo1, 50, OUTPUT cTitulo1).
    RUN BIN/_centrar.p (INPUT cTitulo2, 260, OUTPUT cTitulo2).
    RUN BIN/_centrar.p (INPUT cTitulo3, 260, OUTPUT cTitulo3).

    DEFINE FRAME f-cab
        Registro.NroAst     FORMAT "x(6)"
        Registro.FchDoc     FORMAT "99/99/99"
        Registro.FchVto     FORMAT "99/99/99"
        Registro.CodDoc     FORMAT "XX"
        cNroSer             FORMAT "X(5)"
        Registro.AnoDUA     FORMAT "X(4)"
        cNroDoc             FORMAT "x(8)"
        Registro.TpoDoc     FORMAT "XX"
        Registro.Ruc        FORMAT "X(11)"
        Registro.NomPro     FORMAT "X(20)"
        Registro.ImpLin[1]  FORMAT "->>,>>>,>>9.99"
        Registro.ImpLin[2]  FORMAT "->>,>>>,>>9.99"
        Registro.ImpLin[3]  FORMAT "->>,>>>,>>9.99"
        Registro.ImpLin[4]  FORMAT "->>,>>>,>>9.99"
        Registro.ImpLin[5]  FORMAT "->>,>>>,>>9.99"
        Registro.ImpLin[6]  FORMAT "->>,>>>,>>9.99"
        Registro.ImpLin[7]  FORMAT "->>,>>>,>>9.99"
        Registro.ImpLin[10] FORMAT "->>,>>>,>>9.99"
        cNroDocND           FORMAT "x(8)"
        Registro.NroTra     FORMAT 'x(10)'
        Registro.FchMod     FORMAT '99/99/9999'
        Registro.TpoCmb     FORMAT ">>9.999"
        Registro.FchRef     FORMAT "99/99/99"
        Registro.CodRef     FORMAT "XX"
        cSerRef             FORMAT "X(5)"
        cNroRef             FORMAT "X(8)"
        HEADER
        S-NOMCIA FORMAT "X(60)" AT 1
        SKIP
        cTitulo1 AT 106 "PAGINA : " TO 255 c-Pagina FORMAT ">>>9" SKIP
        cTitulo2 SKIP 
        cTitulo3 SKIP(1)
        "------ -------- -------- ------------- -------- ----------------------------------- -------------- -------------- -------------- -------------- -------------- -------------- -------------- -------------- -------- --------------------- ------- --------------------------"
        "Numero                   Comp. de Pago                  Infor. del Proveedor        BASE IMPONIBLE BASE IMPONIBLE BASE IMPONIBLE                    I.G.V.         I.G.V.         I.G.V.                                                              Documento Referencia   "   
        "Asto.                       Serie      Numero                                       DESTINA.A OPE- DESTINA.A OPE- POR OPERACIONE ADQUISICIONES                                                              Numero   Constancia de         Tipo de                           " 
        "Codigo                      Cod.   _    Comp.       Numero                          RACIONES  GRA- RACIONES GRAB. QUE NO DAN DE-  NO GRAVADAS         A              B              C          T O T A L     Comp.   Deposito de Detraccion Cambio                           " 
        "Unico   Fecha    Fecha   Cd Depen Ano  Pgo Doc      Docum.                          VADAS Y EXPOR- EXPORT, O  NO  RECHO A CREDIT                                                                            Pgo Suj                         Usado           Cd               "
        "Oprac. Emision  Vencto.  Dc Aduan Dua    DUA    TD  Proveedor  Nomb/Razon Social    TACION (A)     GRABADAS (B)         (C)                                                                                 No Domic Numero     Emision             Fecha   Dc Serie Numero  "
        "------ -------- -------- -- ----- ---- -------- -- ----------- -------------------- -------------- -------------- -------------- -------------- -------------- -------------- -------------- -------------- -------- --------------------- ------- -------- -- ----- --------"
       /*123456 99/99/99 99/99/99 xx 12345 1234 12345678 xx 12345678901 12345678901234567890 ->>,>>>,>>9.99 ->>,>>>,>>9.99 ->>,>>>,>>9.99 ->>,>>>,>>9.99 ->>,>>>,>>9.99 ->>,>>>,>>9.99 ->>,>>>,>>9.99 ->>,>>>,>>9.99 12345678 1234567890 99/99/9999 >>9.999 99/99/99 XX 12345 12345678
       */
        WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    RUN Carga-Temporal.

    loop:
    FOR EACH Registro NO-LOCK
        BREAK BY Registro.CodOpe
        BY Registro.NroAst
        ON ERROR UNDO, RETURN ERROR:
        IF c-Pagina > 1 AND lKey = TRUE THEN DO:
            {&NEW-PAGE}.
            DOWN STREAM REPORT 1 WITH FRAME F-cab.
            DISPLAY STREAM REPORT  
                 "V I E N E N  . . . ."  @ Registro.NomPro
                 dVan[1] @ Registro.ImpLin[1] 
                 dVan[2] @ Registro.ImpLin[2] 
                 dVan[3] @ Registro.ImpLin[3] 
                 dVan[4] @ Registro.ImpLin[4] 
                 dVan[5] @ Registro.ImpLin[5] 
                 dVan[6] @ Registro.ImpLin[6] 
                 dVan[7] @ Registro.ImpLin[7] 
                 dVan[10] @ Registro.ImpLin[10]
                 WITH FRAME F-cab.
            DOWN STREAM REPORT 2 WITH FRAME F-cab.
            lKey = FALSE.
        END.
        ASSIGN
            cNroSer = ''
            cSerRef = ''
            cNroDoc = Registro.NroDoc
            cNroRef = Registro.NroRef.
        IF INDEX(cNroDoc, '-') > 0 THEN DO:
            cNroSer = SUBSTRING(cNroDoc, 1, INDEX(cNroDoc, '-') - 1).
            cNroDoc = ENTRY(2, cNroDoc, '-').
        END.         
        IF INDEX(cNroRef, '-') > 0 THEN DO:
            cSerRef = SUBSTRING(cNroRef, 1, INDEX(cNroRef, '-') - 1).
            cNroRef = ENTRY(2, cNroRef, '-').
        END.
        cNroDocND = "".
        IF Registro.CodDoc = "91" AND Registro.Imports THEN DO:
            ASSIGN
                cNroDocND = cNroDoc
                cNroDoc   = "".
        END.
        IF Registro.CodDoc = "35" AND Registro.Imports THEN DO:
            ASSIGN
                cNroDocND = cNroRef
                cNroRef   = "".
        END.
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT  
            Registro.NroAst
            Registro.FchDoc
            Registro.FchVto
            Registro.CodDoc
            cNroSer
            Registro.AnoDUA
            cNroDoc
            cNroDocND
            Registro.FchRef
            Registro.CodRef
            cSerRef
            cNroRef
            Registro.TpoDoc
            Registro.Ruc
            Registro.NomPro 
            Registro.ImpLin[1] 
            Registro.ImpLin[2] 
            Registro.ImpLin[3] 
            Registro.ImpLin[4] 
            Registro.ImpLin[5] 
            Registro.ImpLin[6] 
            Registro.ImpLin[7] 
            Registro.ImpLin[10]
            Registro.NroTra
            Registro.FchMod
            Registro.TpoCmb WHEN Registro.TpoCmb <> 0
            WITH FRAME F-CAB.

        ACCUMULATE Registro.ImpLin[1] ( TOTAL ).
        ACCUMULATE Registro.ImpLin[2] ( TOTAL ).
        ACCUMULATE Registro.ImpLin[3] ( TOTAL ).
        ACCUMULATE Registro.ImpLin[4] ( TOTAL ).
        ACCUMULATE Registro.ImpLin[5] ( TOTAL ).
        ACCUMULATE Registro.ImpLin[6] ( TOTAL ).
        ACCUMULATE Registro.ImpLin[7] ( TOTAL ).
        ACCUMULATE Registro.ImpLin[10] ( TOTAL ).

        ACCUMULATE Registro.ImpLin[1] ( SUB-TOTAL BY Registro.CodOpe ).
        ACCUMULATE Registro.ImpLin[2] ( SUB-TOTAL BY Registro.CodOpe ).
        ACCUMULATE Registro.ImpLin[3] ( SUB-TOTAL BY Registro.CodOpe ).
        ACCUMULATE Registro.ImpLin[4] ( SUB-TOTAL BY Registro.CodOpe ).
        ACCUMULATE Registro.ImpLin[5] ( SUB-TOTAL BY Registro.CodOpe ).
        ACCUMULATE Registro.ImpLin[6] ( SUB-TOTAL BY Registro.CodOpe ).
        ACCUMULATE Registro.ImpLin[7] ( SUB-TOTAL BY Registro.CodOpe ).
        ACCUMULATE Registro.ImpLin[10] ( SUB-TOTAL BY Registro.CodOpe ).

        dVan[1] = dVan[1] + Registro.ImpLin[1].
        dVan[2] = dVan[2] + Registro.ImpLin[2].
        dVan[3] = dVan[3] + Registro.ImpLin[3].
        dVan[4] = dVan[4] + Registro.ImpLin[4].
        dVan[5] = dVan[5] + Registro.ImpLin[5].
        dVan[6] = dVan[6] + Registro.ImpLin[6].
        dVan[7] = dVan[7] + Registro.ImpLin[7].
        dVan[10] = dVan[10] + Registro.ImpLin[10].

        IF LINE-COUNTER(Report) > (P-Largo - 9) THEN DO:
            lKey = TRUE.
            DO WHILE LINE-COUNTER(Report) < P-Largo - 8:
                PUT STREAM Report "" SKIP.
            END.
            {&NEW-PAGE}.
            UNDERLINE STREAM REPORT 
                Registro.NomPro
                Registro.ImpLin[1] 
                Registro.ImpLin[2] 
                Registro.ImpLin[3] 
                Registro.ImpLin[4] 
                Registro.ImpLin[5] 
                Registro.ImpLin[6] 
                Registro.ImpLin[7] 
                Registro.ImpLin[10]
                WITH FRAME F-CAB.
            DISPLAY STREAM REPORT
                "V A N  . . . . . . ."  @ Registro.NomPro
                dVan[1] @ Registro.ImpLin[1] 
                dVan[2] @ Registro.ImpLin[2] 
                dVan[3] @ Registro.ImpLin[3] 
                dVan[4] @ Registro.ImpLin[4] 
                dVan[5] @ Registro.ImpLin[5] 
                dVan[6] @ Registro.ImpLin[6] 
                dVan[7] @ Registro.ImpLin[7] 
                dVan[10] @ Registro.ImpLin[10]
                WITH FRAME F-cab.
            DOWN STREAM REPORT 2 WITH FRAME F-cab.
            RUN NEW-PAGE.
        END.
        IF LAST-OF (Registro.CodOpe) THEN DO:
            {&NEW-PAGE}.
            UNDERLINE STREAM REPORT 
                Registro.NomPro
                Registro.ImpLin[1] 
                Registro.ImpLin[2] 
                Registro.ImpLin[3] 
                Registro.ImpLin[4] 
                Registro.ImpLin[5] 
                Registro.ImpLin[6] 
                Registro.ImpLin[7] 
                Registro.ImpLin[10]
                WITH FRAME F-CAB. 
            {&NEW-PAGE}.
            DISPLAY STREAM REPORT
                "TOT. POR OPER. " + Registro.CodOpe @ Registro.NomPro
                ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[1]  @ Registro.ImpLin[1] 
                ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[2]  @ Registro.ImpLin[2] 
                ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[3]  @ Registro.ImpLin[3] 
                ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[4]  @ Registro.ImpLin[4] 
                ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[5]  @ Registro.ImpLin[5] 
                ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[6]  @ Registro.ImpLin[6] 
                ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[7]  @ Registro.ImpLin[7] 
                ACCUM SUB-TOTAL BY Registro.CodOpe Registro.ImpLin[10] @ Registro.ImpLin[10]
                WITH FRAME F-CAB.
            DOWN STREAM REPORT 2 WITH FRAME F-CAB.
        END.
        IF LAST (Registro.CodOpe) THEN DO:
            {&NEW-PAGE}.
            UNDERLINE STREAM REPORT               
                Registro.NomPro
                Registro.ImpLin[1] 
                Registro.ImpLin[2] 
                Registro.ImpLin[3] 
                Registro.ImpLin[4] 
                Registro.ImpLin[5] 
                Registro.ImpLin[6] 
                Registro.ImpLin[7] 
                Registro.ImpLin[10]
                WITH FRAME F-CAB.
            {&NEW-PAGE}.
            DISPLAY STREAM REPORT
                "TOTAL GENERAL" @ Registro.NomPro
                ACCUM TOTAL Registro.ImpLin[1] @ Registro.ImpLin[1] 
                ACCUM TOTAL Registro.ImpLin[2] @ Registro.ImpLin[2] 
                ACCUM TOTAL Registro.ImpLin[3] @ Registro.ImpLin[3] 
                ACCUM TOTAL Registro.ImpLin[4] @ Registro.ImpLin[4] 
                ACCUM TOTAL Registro.ImpLin[5] @ Registro.ImpLin[5] 
                ACCUM TOTAL Registro.ImpLin[6] @ Registro.ImpLin[6] 
                ACCUM TOTAL Registro.ImpLin[7] @ Registro.ImpLin[7] 
                ACCUM TOTAL Registro.ImpLin[10] @ Registro.ImpLin[10]
                WITH FRAME F-CAB.        
            {&NEW-PAGE}.
            UNDERLINE STREAM REPORT
                Registro.NomPro
                Registro.ImpLin[1]
                Registro.ImpLin[2]
                Registro.ImpLin[3]
                Registro.ImpLin[4]
                Registro.ImpLin[5]
                Registro.ImpLin[6]
                Registro.ImpLin[7]
                Registro.ImpLin[10]
                WITH FRAME F-CAB.
        END.
    END. /* FOR EACH Registro... */

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

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    ASSIGN
        P-Largo = 66
        P-reset = {&Prn0}
        P-flen = {&Prn5A} + CHR(66)
        P-config = {&Prn4} + {&PrnD}.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN Formato.
        OUTPUT STREAM report CLOSE.        
    END.
    OUTPUT STREAM report CLOSE.
    HIDE FRAME F-Mensaje.

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

    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        FIND cb-cfgg WHERE
            cb-cfgg.CodCia = s-CodCia AND
            cb-cfgg.CODCFG = "R01" NO-LOCK NO-ERROR.
        IF AVAILABLE cb-cfgg THEN
            FILL-IN-CodOpe = cb-cfgg.codope.
        COMBO-mesini = s-NroMes.
        COMBO-mesfin = s-NroMes.
    END.

    COMBO-TipDoc:LIST-ITEMS = "Todos".
    FOR EACH FACDOCUM WHERE
        FACDOCUM.FLGCBD = YES AND
        FACDOCUM.TPODOC <> ? AND
        FACDOCUM.CODCBD <> "" NO-LOCK:
        lOk = COMBO-TipDoc:ADD-LAST(FacDocum.CodDoc).
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

