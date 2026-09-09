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
DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR Cb-CodCia AS INTEGER.
DEFINE SHARED VAR Cl-CodCia AS INTEGER.
DEFINE SHARED VAR s-NroMes  AS INTEGER.
DEFINE SHARED VAR s-NomCia  AS CHARACTER.
DEFINE SHARED VAR s-Periodo AS INTEGER.
DEFINE SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE STREAM REPORT.

DEFINE VAR C-BIMP AS CHAR.
DEFINE VAR C-ISC  AS CHAR.
DEFINE VAR C-IGV  AS CHAR.
DEFINE VAR C-TOT  AS CHAR.

DEF VAR s-task-no LIKE w-report.task-no NO-UNDO.
DEF VAR s-titulo1 AS CHAR NO-UNDO.
DEF VAR s-titulo2 AS CHAR NO-UNDO.
DEF VAR s-titulo3 AS CHAR NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

/* BUSCANDO LAS CONFIGURACIONES DEL LIBRO DE VENTAS */
FIND cb-cfgg WHERE
    cb-cfgg.CODCIA = cb-codcia AND
    cb-cfgg.CODCFG = "R02"
    NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfgg THEN DO:
    MESSAGE
        "No esta configurado el registro de Ventas"
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Configuraciones */
C-BIMP = cb-cfgg.CODCTA[1].
C-ISC  = cb-cfgg.CODCTA[2].
C-IGV  = cb-cfgg.CODCTA[3].
C-TOT  = cb-cfgg.CODCTA[4].

/* Definicion del Frame de Imprsión y sus Variables  */

DEFINE VAR x-CodDiv AS CHAR.
DEFINE VAR x-FchDoc AS DATE.
DEFINE VAR x-CodDoc AS CHAR.
DEFINE VAR x-NroDoc AS CHAR.
DEFINE VAR x-Ruc    AS CHAR.
DEFINE VAR x-NomCli AS CHAR.
DEFINE VAR x-Import AS DECIMAL EXTENT 10.
DEFINE VAR x-CodRef AS CHAR.
DEFINE VAR x-NroRef AS CHAR.
DEFINE VAR x-CodMon AS CHAR.
DEFINE VAR x-CodOpe AS CHAR.
DEFINE VAR x-DesMes AS CHAR.

DEFINE TEMP-TABLE Registro NO-UNDO
    FIELD CodOpe AS CHAR
    FIELD CodCia AS CHAR
    FIELD CodDiv AS CHAR
    FIELD NroAst AS CHAR
    FIELD FchDoc AS DATE
    FIELD CodDoc AS CHAR
    FIELD NroDoc AS CHAR
    FIELD CodRef AS CHAR
    FIELD NroRef AS CHAR
    FIELD NotDeb AS CHAR
    FIELD NotCre AS CHAR
    FIELD Ruc    AS CHAR
    FIELD NomCli AS CHAR
    FIELD CodMon AS CHAR
    FIELD Cco    AS CHAR
    FIELD Implin AS DECIMAL EXTENT 10.

DEFINE IMAGE IMAGE-2 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-2 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor..." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
        SKIP
    Fi-Mensaje NO-LABEL FONT 6
        SKIP     
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
&Scoped-Define ENABLED-OBJECTS RECT-2 RADIO-CodMon FILL-IN-coddiv ~
FILL-IN-CodOpe TOGGLE-summary Btn_Print Btn_Done Btn_Excel 
&Scoped-Define DISPLAYED-OBJECTS RADIO-CodMon FILL-IN-coddiv FILL-IN-CodOpe ~
TOGGLE-summary 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Salir" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Excel" 
     SIZE 12 BY 1.5 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE BUTTON Btn_Print 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 12 BY 1.5.

DEFINE VARIABLE FILL-IN-coddiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodOpe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operaciones" 
     VIEW-AS FILL-IN 
     SIZE 22.29 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 9 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY .04.

DEFINE VARIABLE TOGGLE-summary AS LOGICAL INITIAL no 
     LABEL "Solo Resumen por División" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.43 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-CodMon AT ROW 2.15 COL 13 NO-LABEL
     FILL-IN-coddiv AT ROW 2.27 COL 36.57 COLON-ALIGNED
     FILL-IN-CodOpe AT ROW 3.04 COL 29.14
     TOGGLE-summary AT ROW 4 COL 38.57
     Btn_Print AT ROW 5.81 COL 19
     Btn_Done AT ROW 5.81 COL 34
     Btn_Excel AT ROW 5.81 COL 49
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .65 AT ROW 2.15 COL 6
     RECT-2 AT ROW 5.23 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.43 BY 6.62
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
         TITLE              = "LIBRO VENTAS SUNAT 2009"
         HEIGHT             = 6.62
         WIDTH              = 65.43
         MAX-HEIGHT         = 6.62
         MAX-WIDTH          = 65.43
         VIRTUAL-HEIGHT     = 6.62
         VIRTUAL-WIDTH      = 65.43
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
ON END-ERROR OF W-Win /* LIBRO VENTAS SUNAT 2009 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* LIBRO VENTAS SUNAT 2009 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:
    ASSIGN FILL-IN-coddiv FILL-IN-CodOpe RADIO-CodMon TOGGLE-summary.
    RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Print W-Win
ON CHOOSE OF Btn_Print IN FRAME F-Main /* Imprimir */
DO:
    ASSIGN FILL-IN-coddiv FILL-IN-CodOpe RADIO-CodMon TOGGLE-summary.
    RUN Imprimir.
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
  DISPLAY RADIO-CodMon FILL-IN-coddiv FILL-IN-CodOpe TOGGLE-summary 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RADIO-CodMon FILL-IN-coddiv FILL-IN-CodOpe TOGGLE-summary 
         Btn_Print Btn_Done Btn_Excel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  Modifico  : Rosa Díaz P /*RD01*/
  Fecha     : 28/10/2009
  Motivo    : Cambio Tipo de Documento
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x-CodDoc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE x-NroSer AS CHARACTER NO-UNDO.
    DEFINE VARIABLE x-NroDoc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNomcli AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRUC AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTpoDoc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodRef AS CHARACTER NO-UNDO.
    DEFINE VARIABLE fFchRef AS DATE NO-UNDO.

    RUN proc_carga-temp.
    RUN bin/_mes.p (INPUT s-NroMes, 1, OUTPUT x-DesMes).
 
    s-titulo1 = "R E G I S T R O  D E  V E N T A S".
    s-titulo2 = "DEL MES DE " + x-DesMes.
    s-titulo3 = "EXPRESADO EN " + IF RADIO-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
    s-task-no = 0.

    FOR EACH Registro BREAK BY
        Registro.CodCia BY
        Registro.CodDiv BY
        Registro.CodDoc BY
        Registro.NroDoc:

        CASE Registro.CodDoc:
            WHEN '01' THEN x-coddoc = 'FAC'.
            WHEN '03' THEN x-coddoc = 'BOL'.
            WHEN '07' THEN x-coddoc = 'N/C'.
            WHEN '08' THEN x-coddoc = 'N/D'.
            OTHERWISE x-coddoc = ''.
        END CASE.
        FIND ccbcdocu WHERE
            ccbcdocu.codcia = s-codcia AND
            ccbcdocu.coddoc = x-coddoc AND
            ccbcdocu.nrodoc = Registro.nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            IF LOOKUP(ccbcdocu.coddoc, "FAC,N/C,N/D") > 0 AND
                Registro.Ruc = "" THEN Registro.Ruc = ccbcdocu.ruc.
        END.

/*RD01****
        cTpoDoc = IF SUBSTRING(Registro.Ruc,1,1) = "1" OR
            SUBSTRING(Registro.Ruc,1,1) = " " THEN "01" ELSE "02".
*RD01****/     
        IF LENGTH(Registro.RUC) = 11 THEN DO:
            IF SUBSTRING(Registro.RUC,1,2) = "10" OR 
                SUBSTRING(Registro.RUC,1,2) = "20" THEN cTpoDoc = "06".
            ELSE cTpoDoc = "01".
        END.
        ELSE cTpoDoc = "01".

        /* Referencia */
        fFchRef = ?.
        IF Registro.CodRef <> '' THEN DO:
            CASE Registro.CodRef:
                WHEN '01' THEN cCodRef = 'FAC'.
                WHEN '03' THEN cCodRef = 'BOL'.
                OTHERWISE cCodref = ''.
            END CASE.
            IF cCodRef <> '' THEN DO:
                FIND ccbcdocu WHERE
                    ccbcdocu.codcia = s-codcia AND
                    ccbcdocu.coddoc = cCodRef AND
                    ccbcdocu.nrodoc = Registro.NroRef
                    NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcdocu THEN
                    fFchRef = ccbcdocu.fchdoc.
            END.
        END.

        cNomCli = Registro.NomCli.
        IF Registro.NomCli = "" AND
            Registro.Ruc <> "" THEN DO:
            IF NOT Registro.Ruc BEGINS '1111' THEN DO:
                FIND GN-CLIE WHERE 
                    GN-CLIE.CodCia = cl-codcia AND
                    GN-CLIE.codcli = Registro.Ruc
                    NO-LOCK NO-ERROR.
                IF AVAILABLE GN-CLIE THEN cNomCli = GN-CLIE.NomCli.
            END.
        END.
        ASSIGN
            x-NroSer = SUBSTRING(Registro.NroDoc,1,3)
            x-NroDoc = SUBSTRING(Registro.NroDoc,4).
        IF Registro.CodDiv = '00012' AND
            Registro.NomCli BEGINS 'TCK' THEN
            ASSIGN
                x-NroSer = 'A4UK'
                x-NroDoc = '016216'.

        IF s-task-no = 0 THEN REPEAT:
            s-task-no = RANDOM(1, 999999).
            IF NOT CAN-FIND(FIRST w-report WHERE
                w-report.task-no = s-task-no AND
                w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
        END.
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Campo-C[1] = Registro.CodCia
            w-report.Campo-C[2] = Registro.CodDiv
            w-report.Campo-C[3] = Registro.CodDoc
            w-report.Campo-C[4] = cTpoDoc
            w-report.Campo-C[5] = Registro.NroAst
            w-report.Campo-C[6] = x-NroSer
            w-report.Campo-C[7] = x-NroDoc
            w-report.Campo-C[8] = Registro.CodRef
            w-report.Campo-C[9] = SUBSTRING(Registro.NroRef,1,3)
            w-report.Campo-C[10] = SUBSTRING(Registro.NroRef,4)
            w-report.Campo-C[11] = IF NOT (Registro.CodDoc = '03' OR
                (AVAILABLE ccbcdocu AND ccbcdocu.codref = 'BOL')) THEN Registro.Ruc ELSE ""
            w-report.Campo-C[12] = cNomCli
            w-report.Campo-D[1] = Registro.FchDoc
            w-report.Campo-F[1] = Registro.ImpLin[1] 
            w-report.Campo-F[2] = Registro.ImpLin[2] 
            w-report.Campo-F[3] = Registro.ImpLin[3] 
            w-report.Campo-F[4] = Registro.ImpLin[4] 
            w-report.Campo-F[5] = Registro.ImpLin[5] 
            w-report.Campo-F[6] = Registro.ImpLin[6] 
            w-report.Campo-F[9] = IF Registro.ImpLin[9] > 0 THEN
                Registro.ImpLin[9] ELSE 0
            w-report.Campo-C[13] = IF Registro.ImpLin[10] <> 0 THEN
                STRING(Registro.ImpLin[10],">>9.999<") ELSE ""
            w-report.Campo-C[14] = IF fFchRef <> ? THEN
                STRING(fFchRef,"99/99/99") ELSE ""
            w-report.Campo-L[1] = NOT LAST(Registro.CodCia).

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

    RUN Formato.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "No existen registros para imprimirse" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "CBD\RBCBD.PRL"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "w-report.task-no = " + STRING(s-task-no) +
            " AND w-report.Llave-C = '" + s-user-id + "'"
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo1 = " + s-titulo1 +
            "~ns-titulo2 = " + s-titulo2 +
            "~ns-titulo3 = " + s-titulo3.

    IF TOGGLE-summary THEN RB-REPORT-NAME = "REGISTRO DE VENTAS 2009 DRAFT II".
    ELSE RB-REPORT-NAME = "REGISTRO DE VENTAS 2009 DRAFT".

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id.
        DELETE w-report.
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

    FIND cb-cfgg WHERE
        cb-cfgg.CODCIA = cb-codcia AND
        cb-cfgg.CODCFG = "R02"
        NO-LOCK NO-ERROR.
    IF AVAIL cb-cfgg THEN
        FILL-IN-CodOpe = cb-cfgg.codope.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-temp W-Win 
PROCEDURE proc_carga-temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR i        AS INTEGER NO-UNDO.
    DEFINE VAR ii       AS INTEGER NO-UNDO.
    DEFINE VAR iii      AS INTEGER NO-UNDO.
    DEFINE VAR x-Debe   AS DECIMAL NO-UNDO.
    DEFINE VAR x-Haber  AS DECIMAL NO-UNDO.
    DEFINE VAR y-Debe   AS DECIMAL NO-UNDO.
    DEFINE VAR y-Haber  AS DECIMAL NO-UNDO.
    DEFINE VAR x-Cco    AS CHAR    NO-UNDO.
    DEFINE VAR x-CodCta AS CHAR    NO-UNDO.

    DISPLAY WITH FRAME F-Proceso.

    FOR EACH Registro:
        DELETE Registro.
    END.

    DO i = 1 TO NUM-ENTRIES(FILL-IN-CodOpe):
        x-codope = ENTRY(i, FILL-IN-CodOpe).
        FOR EACH cb-cmov NO-LOCK WHERE
            cb-cmov.CodCia  = s-CodCia AND
            cb-cmov.Periodo = s-Periodo AND
            cb-cmov.NroMes  = s-NroMes AND
            cb-cmov.CodOpe  = x-CodOpe
            BREAK BY cb-cmov.NroAst:
            DISPLAY cb-cmov.NroAst @ Fi-Mensaje WITH FRAME F-Proceso.
            FOR EACH cb-dmov NO-LOCK WHERE
                cb-dmov.CodCia = cb-cmov.CodCia AND
                cb-dmov.Periodo = cb-cmov.Periodo AND
                cb-dmov.NroMes = cb-cmov.NroMes AND
                cb-dmov.CodOpe = cb-cmov.CodOpe AND
                cb-dmov.NroAst = cb-cmov.NroAst AND
                cb-dmov.CodDiv BEGINS FILL-IN-coddiv
                BREAK BY cb-dmov.CodDoc BY cb-dmov.nrodoc:
                IF /* FIRST-OF(cb-dmov.CodDoc) OR */
                    FIRST-OF(cb-dmov.nrodoc) THEN DO :
                    x-Import[1] = 0.
                    x-Import[2] = 0.
                    x-Import[3] = 0.
                    x-Import[4] = 0.
                    x-Import[5] = 0.
                    x-Import[6] = 0.
                    x-Import[9] = 0.
                    x-CodDiv = cb-dmov.CodDiv.
                    x-Cco = ''.
                END.
                IF NOT tpomov THEN DO:
                    y-debe = ImpMn2.
                    y-haber = 0.
                    CASE RADIO-codmon:
                        WHEN 1 THEN DO:
                            x-debe = ImpMn1.
                            x-haber = 0.
                        END.
                        WHEN 2 THEN DO:
                            x-debe = ImpMn2.
                            x-haber = 0.
                        END.
                    END CASE.
                END.
                ELSE DO:      
                    y-haber = ImpMn2.
                    y-Debe = 0.
                    CASE RADIO-codmon:
                        WHEN 1 THEN DO:
                            x-debe = 0.
                            x-haber = ImpMn1.
                        END.
                        WHEN 2 THEN DO:
                            x-debe = 0.
                            x-haber = ImpMn2.
                        END.
                    END CASE.            
                END.
                x-Cco = IF x-Cco = '' THEN Cb-Dmov.Cco ELSE x-Cco.

                DO ii = 1 TO NUM-ENTRIES(C-BIMP):
                    x-CodCta = ENTRY(ii,C-BIMP).
                    IF cb-dmov.CodCta BEGINS x-CodCta THEN DO:
                        IF cb-dmov.TM = 1 THEN DO:
                            x-Import[1] = x-Import[1] + (x-Haber - x-Debe).
                            x-Import[4] = x-Import[4] + (x-Haber - x-Debe).
                        END.
                        IF cb-dmov.TM = 2 THEN DO :
                            x-Import[2] = x-Import[2] + (x-Haber - x-Debe).
                        END.
                    END.
                END.

                IF cb-dmov.CodCta BEGINS C-IGV OR 
                    LOOKUP(cb-dmov.CodCta,C-IGV) > 0 THEN DO :
                    x-Import[5] = x-Import[5] + (x-Haber - x-Debe).
                END.

                DO iii = 1 TO NUM-ENTRIES(C-TOT):
                    x-CodCta = ENTRY(iii,C-TOT).
                    IF Cb-dmov.codcta BEGINS x-CodCta THEN DO:
                        x-Import[6] = x-Import[6] + (x-Debe - x-Haber).
                        x-import[9] = x-import[9] + (y-Debe - y-Haber).
                        x-FchDoc = cb-dmov.FchDoc.
                        x-CodDoc = cb-dmov.CodDoc.
                        x-NroDoc = cb-dmov.NroDoc.
                        x-CodMon = IF cb-dmov.CodMon = 1 THEN "S/." ELSE "US$".
                        x-NomCli = cb-dmov.GloDoc.
                        x-Ruc    = cb-dmov.NroRuc.
                        x-CodRef = cb-dmov.CodRef.
                        x-NroRef = cb-dmov.NroRef.
                        FIND GN-CLIE WHERE
                            GN-CLIE.CodCia = cl-codcia AND
                            /****
                            GN-CLIE.codcli = cb-dmov.CodAux and 
                            ****/
/*RD01*/                    GN-CLIE.codcli = cb-dmov.NroRuc and 
                            GN-CLIE.codcli <> '' NO-LOCK NO-ERROR.
                        IF AVAILABLE GN-CLIE THEN x-NomCli = GN-CLIE.NomCli.
                        ELSE x-NomCli = cb-dmov.GloDoc.                        
                    END.
                END.
                IF /* LAST-OF(cb-dmov.CodDoc) OR */ LAST-OF(cb-dmov.nrodoc) THEN DO:
                    CREATE Registro.
                    Registro.CodDiv = x-CodDiv.
                    Registro.NroAst = cb-cmov.NroAst.
                    Registro.FchDoc = x-FchDoc.
                    Registro.CodDoc = x-CodDoc.
                    CASE x-CodDoc:
                        WHEN "08" THEN Registro.NotDeb = x-NroDoc.
                        WHEN "07" THEN Registro.NotCre = x-NroDoc.
                        OTHERWISE Registro.NroDoc = x-NroDoc.
                    END CASE.
                    Registro.NroDoc = x-NroDoc.
                    Registro.CodRef = x-CodRef.
                    Registro.NroRef = x-NroRef.
                    Registro.Ruc    = x-Ruc.
                    Registro.NomCli = x-NomCli.
                    Registro.CodMon = x-CodMon.
                    Registro.Cco    = x-Cco.
                    Registro.ImpLin[1] = x-Import[1].
                    Registro.ImpLin[2] = x-Import[2].
                    Registro.ImpLin[3] = x-Import[3].
                    Registro.ImpLin[4] = x-Import[4].
                    Registro.ImpLin[5] = x-Import[5].
                    Registro.ImpLin[6] = x-Import[6].
                    Registro.ImpLin[9] = x-Import[9].
                    Registro.ImpLin[1] = Registro.ImpLin[2] + Registro.ImpLin[3] + Registro.ImpLin[4].
                    IF Registro.NomCli = "" THEN Registro.NomCli = cb-dmov.Glodoc.
                    IF cb-cmov.CodMon = 1 THEN Registro.ImpLin[10] = 0.
                    ELSE Registro.ImpLin[10] = cb-cmov.TpoCmb.
                END.
            END. /* FIN DEL FOR cb-dmov */        
        END. /* FIN DEL FOR cb-cmov */
    END. /* FIN DEL DO */
    HIDE FRAME F-Proceso.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cArchivo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lRpta AS LOGICAL NO-UNDO.

    cArchivo = 'Ventas' + STRING(s-Periodo, '9999') + STRING(s-NroMes, '99') + '.txt'.
    SYSTEM-DIALOG GET-FILE cArchivo
        FILTERS 'Texto' '*.txt'
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION '.txt'
        RETURN-TO-START-DIR 
        USE-FILENAME
        SAVE-AS
        UPDATE lrpta.
    IF lrpta = NO THEN RETURN.

    RUN Formato.

    OUTPUT STREAM REPORT TO VALUE(cArchivo).
    FOR EACH w-report NO-LOCK WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id
        BREAK BY w-report.Campo-C[2]
        BY w-report.Campo-C[3]
        BY w-report.Campo-C[6]
        BY w-report.Campo-C[7]
        WITH FRAME b WIDTH 320 NO-BOX STREAM-IO:
        DISPLAY STREAM REPORT
            w-report.Campo-C[2] FORMAT "x(5)" COLUMN-LABEL "Div"
            w-report.Campo-C[5] FORMAT "x(6)" COLUMN-LABEL "Nro!Asto"
            w-report.Campo-D[1] FORMAT "99/99/99" COLUMN-LABEL "Fecha!Emisión"
            w-report.Campo-C[3] FORMAT "xx" COLUMN-LABEL "TD"
            w-report.Campo-C[6] FORMAT "x(12)" COLUMN-LABEL "Número!Serie"
            w-report.Campo-C[7] FORMAT "x(6)" COLUMN-LABEL "Número!Cmpbte"
            w-report.Campo-C[4] FORMAT "xx" COLUMN-LABEL "TD"
            w-report.Campo-C[11] FORMAT "x(11)" COLUMN-LABEL "Número"
            w-report.Campo-C[12] FORMAT "x(53)"
                COLUMN-LABEL "Apellidos Nombres/Denominación/Razón Social"
            w-report.Campo-F[4] FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Base Imponible"
            w-report.Campo-F[2] FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Importe!Exonerado"
            w-report.Campo-F[5] FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "I.G.V.!I.P.M."
            w-report.Campo-F[6] FORMAT "->>>,>>>,>>9.99" COLUMN-LABEL "Importe Total"
            w-report.Campo-C[13] FORMAT "x(8)" COLUMN-LABEL "Tipo de!Cambio"
            w-report.Campo-C[14] FORMAT "x(8)" COLUMN-LABEL "Fecha!Refer"
            w-report.Campo-C[8] FORMAT "xx" COLUMN-LABEL "TD"
            w-report.Campo-C[9] FORMAT "x(3)" COLUMN-LABEL "Nro!Ser"
            w-report.Campo-C[10] FORMAT "x(6)" COLUMN-LABEL "Número!Refer"
            WITH STREAM-IO.
    END.
    OUTPUT STREAM REPORT CLOSE.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id.
        DELETE w-report.
    END.

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

