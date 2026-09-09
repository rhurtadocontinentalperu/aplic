&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.



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
DEF TEMP-TABLE t-w-report LIKE w-report.

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

DEF VAR s-task-no LIKE t-w-report.task-no NO-UNDO.
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
DEFINE VAR x-FchVto AS DATE.
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
DEFINE VAR x-TpoCmb AS DEC.

DEFINE TEMP-TABLE Registro NO-UNDO
    FIELD CodOpe AS CHAR
    FIELD CodCia AS CHAR
    FIELD CodDiv AS CHAR
    FIELD NroAst AS CHAR
    FIELD FchDoc AS DATE
    FIELD FchVto AS DATE
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
    FIELD Implin AS DECIMAL EXTENT 10
    FIELD otrostrib AS DECIMAL INIT 0
    .

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

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-NroMes FILL-IN-CodOpe RADIO-CodMon ~
Btn_Excel BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-NroMes FILL-IN-CodOpe ~
RADIO-CodMon x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Excel" 
     SIZE 12 BY 1.69 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-NroMes AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodOpe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operaciones" 
     VIEW-AS FILL-IN 
     SIZE 22.29 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 65.43 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 9 BY 1.62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-NroMes AT ROW 1.19 COL 18 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-CodOpe AT ROW 1.19 COL 29.57 WIDGET-ID 58
     RADIO-CodMon AT ROW 2.15 COL 20 NO-LABEL
     x-mensaje AT ROW 4.08 COL 3 NO-LABEL WIDGET-ID 8
     Btn_Excel AT ROW 5.42 COL 3
     BtnDone AT ROW 5.42 COL 16 WIDGET-ID 56
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .65 AT ROW 2.15 COL 13
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.29 BY 6.62
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Registro de Ventas Detallado"
         HEIGHT             = 6.62
         WIDTH              = 72.29
         MAX-HEIGHT         = 6.62
         MAX-WIDTH          = 72.29
         VIRTUAL-HEIGHT     = 6.62
         VIRTUAL-WIDTH      = 72.29
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Registro de Ventas Detallado */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Registro de Ventas Detallado */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
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
    ASSIGN COMBO-BOX-NroMes RADIO-CodMon FILL-IN-CodOpe.
    RUN Texto.
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
  DISPLAY COMBO-BOX-NroMes FILL-IN-CodOpe RADIO-CodMon x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-NroMes FILL-IN-CodOpe RADIO-CodMon Btn_Excel BtnDone 
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
    DEFINE VARIABLE x-NroFin AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNomcli AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRUC AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTpoDoc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodRef AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNroref AS CHARACTER NO-UNDO.
    DEFINE VARIABLE fFchRef AS DATE NO-UNDO.
    DEFINE VAR lEstDoc AS CHAR.

    DEFINE VAR x-prefijo-doc AS CHAR.

    RUN proc_carga-temp.

    s-task-no = 0.
    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST t-w-report WHERE t-w-report.task-no = s-task-no 
                        AND t-w-report.Llave-C = s-user-id NO-LOCK) 
            THEN LEAVE.
    END.
    FOR EACH Registro 
        BREAK BY Registro.CodCia BY Registro.CodDiv BY Registro.CodDoc BY Registro.NroDoc:

        x-prefijo-doc = "".

        CASE Registro.CodDoc:
            WHEN '01' THEN x-coddoc = 'FAC'.
            WHEN '03' THEN x-coddoc = 'BOL'.
            WHEN '12' THEN x-coddoc = 'TCK'.
            WHEN '07' THEN x-coddoc = 'N/C'.
            WHEN '08' THEN x-coddoc = 'N/D'.
            OTHERWISE x-coddoc = ''.
        END CASE.

        lEstDoc = "".
        FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia 
            AND ccbcdocu.coddoc = x-coddoc 
            AND ccbcdocu.nrodoc = Registro.nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            lEstDoc = ccbcdocu.FlgEst.
            IF LOOKUP(ccbcdocu.coddoc, "FAC,N/C,N/D") > 0 AND
                Registro.Ruc = "" THEN Registro.Ruc = ccbcdocu.ruc.

            IF LOOKUP(x-coddoc,"FAC,BOL") > 0 THEN DO:
                x-prefijo-doc = SUBSTRING(x-coddoc,1,1).
            END.
            ELSE DO:
                 IF LOOKUP(ccbcdocu.codref,"FAC,BOL") > 0 THEN DO:
                    x-prefijo-doc = SUBSTRING(ccbcdocu.codref,1,1).
                 END.
            END.

        END.

        IF LENGTH(Registro.RUC) = 11 THEN DO:
            IF SUBSTRING(Registro.RUC,1,2) = "10" OR 
                SUBSTRING(Registro.RUC,1,2) = "20" OR 
                SUBSTRING(Registro.RUC,1,2) = "15" OR 
                SUBSTRING(Registro.RUC,1,2) = "17" THEN cTpoDoc = "6".
            ELSE cTpoDoc = "0".
        END.
        ELSE cTpoDoc = "0".
        /* Referencia */
        fFchRef = ?.
        IF Registro.CodRef <> '' THEN DO:
            CASE Registro.CodRef:
                WHEN '01' THEN cCodRef = 'FAC'.
                WHEN '03' THEN cCodRef = 'BOL'.
                WHEN '12' THEN cCodRef = 'TCK'.
                WHEN '37' THEN cCodRef = 'LET'.
                OTHERWISE cCodref = ''.
            END CASE.
            IF cCodRef <> '' THEN DO:
                FIND B-CDOCU WHERE
                    B-CDOCU.codcia = s-codcia AND
                    B-CDOCU.coddoc = cCodRef AND
                    B-CDOCU.nrodoc = Registro.NroRef
                    NO-LOCK NO-ERROR.

                /*IF AVAILABLE ccbcdocu THEN fFchRef = B-CDOCU.fchdoc. Ic - 27Set2016 */ 

                /* Ic - 27Set2016 */ 
                IF AVAILABLE B-CDOCU THEN fFchRef = B-CDOCU.fchdoc.
            END.
        END.
        /* ******************** RHC 16/10/2014 Parche para N/C y N/D ******************* */
        cCodRef = Registro.CodRef.
        cNroRef = Registro.NroRef.
        IF LOOKUP(x-CodDoc, 'N/C,N/D') > 0 AND AVAILABLE Ccbcdocu AND Registro.codref = '' THEN DO:
            FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
                AND B-CDOCU.coddoc = Ccbcdocu.codref
                AND B-CDOCU.nrodoc = Ccbcdocu.nroref
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-CDOCU THEN DO:
                CASE B-CDOCU.coddoc:
                    WHEN 'FAC' THEN cCodRef = '01'.
                    WHEN 'BOL' THEN cCodRef = '03'.
                    WHEN 'TCK' THEN cCodref = '12'.
                    WHEN 'LET' THEN cCodref = '37'.
                END CASE.
                ASSIGN
                    fFchRef = B-CDOCU.fchdoc
                    cNroRef = B-CDOCU.nrodoc.
            END.
        END.
        /* ***************************************************************************** */
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
            x-NroDoc = SUBSTRING(Registro.NroDoc,4)
            x-NroFin = "".
        IF Registro.CodDiv = '00012' AND
            Registro.NomCli BEGINS 'TCK' THEN
            ASSIGN
                x-NroSer = 'A4UK'
                x-NroDoc = '016216'.

        /* CASO DE BOLETAS Y TICKETS RESUMIDOS */
        IF LOOKUP(x-coddoc, "BOL,TCK") > 0 THEN DO:
            ASSIGN
                x-NroDoc = "0"
                x-NroFin = "0".
            FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
                AND Ccbcdocu.coddoc = x-coddoc
                AND Ccbcdocu.nrodoc BEGINS x-nroser
                AND Ccbcdocu.fchdoc = Registro.fchdoc
                AND Ccbcdocu.flgest <> "A"
                BY Ccbcdocu.nrodoc:
                IF x-NroDoc = "0" THEN x-NroDoc = SUBSTRING(Ccbcdocu.nrodoc,4).
                x-NroFin = SUBSTRING(Ccbcdocu.nrodoc,4).
            END.
        END.
        /* ********************************** */

        CREATE t-w-report.
        ASSIGN
            t-w-report.Task-No = s-task-no
            t-w-report.Llave-C = s-user-id
            t-w-report.Campo-C[1] = Registro.CodCia
            t-w-report.Campo-C[2] = Registro.CodDiv
            t-w-report.Campo-C[3] = Registro.CodDoc
            /*t-w-report.Campo-C[4] = if( lEstDoc = "A") THEN "-" ELSE cTpoDoc*/
            t-w-report.Campo-C[4] = if( lEstDoc = "A") THEN "0" ELSE cTpoDoc
            t-w-report.Campo-C[5] = Registro.NroAst
            t-w-report.Campo-C[6] = x-prefijo-doc + x-NroSer
            t-w-report.Campo-C[7] = IF (x-NroDoc = ? OR x-NroDoc = '') THEN "0" ELSE x-NroDoc
            t-w-report.Campo-C[16] = IF (x-NroFin = ? OR x-NroFin = '') THEN "0" ELSE x-NroFin
            t-w-report.Campo-C[8] = IF (cCodRef = ? OR cCodRef = "" OR lEstDoc = "A") 
                                        THEN "00" ELSE cCodRef
            t-w-report.Campo-C[9] = IF (cNroRef = ? OR cNroRef = "" OR lEstDoc = "A") 
                                        THEN "-" ELSE "0" + SUBSTRING(cNroRef,1,3)
            t-w-report.Campo-C[10] = IF (cNroRef = ? OR cNroRef = "" OR lEstDoc = "A") 
                                            THEN "-" ELSE SUBSTRING(cNroRef,4)
            t-w-report.Campo-C[11] = IF NOT (Registro.CodDoc = '03' OR
                (AVAILABLE ccbcdocu AND ccbcdocu.codref = 'BOL')) THEN Registro.Ruc ELSE "-" 
            /* Ic 24Mar2014*/
            t-w-report.Campo-C[11] = IF (lEstDoc = "A" OR Registro.CodDoc = 'BOL' OR Registro.CodDoc = 'TCK' ) THEN '-' ELSE t-w-report.Campo-C[11]
            t-w-report.Campo-C[12] = cNomCli
            t-w-report.Campo-C[12] = IF (Registro.CodDoc = 'BOL' OR Registro.CodDoc = 'TCK') THEN "-" ELSE t-w-report.Campo-C[12]
            t-w-report.Campo-D[1] = Registro.FchDoc
            t-w-report.Campo-D[2] = Registro.FchVto
            t-w-report.Campo-F[1] = Registro.ImpLin[1] 
            t-w-report.Campo-F[2] = Registro.ImpLin[2] 
            t-w-report.Campo-F[3] = Registro.ImpLin[3] 
            t-w-report.Campo-F[4] = Registro.ImpLin[4] 
            t-w-report.Campo-F[5] = Registro.ImpLin[5] 
            t-w-report.Campo-F[6] = Registro.ImpLin[6] 
            t-w-report.Campo-F[9] = (IF Registro.ImpLin[9] > 0 THEN Registro.ImpLin[9] ELSE 0)    /* Importe en US$ */
            t-w-report.Campo-F[10] = (IF Registro.ImpLin[9] > 0 THEN Registro.ImpLin[10] ELSE 0)  /* Tpo de Cambio */
            t-w-report.Campo-C[13] = (IF t-w-report.Campo-F[10] > 0 THEN STRING(t-w-report.Campo-F[10], ">>9.999<") ELSE "0.000")
            t-w-report.Campo-C[14] = IF fFchRef <> ? THEN STRING(fFchRef,"99/99/99") ELSE "01/01/0001"
            t-w-report.Campo-C[14] = IF ( lEstDoc = "A") THEN "01/01/0001" ELSE t-w-report.Campo-C[14]
            t-w-report.Campo-L[1] = NOT LAST(Registro.CodCia)
            t-w-report.Campo-C[15] = (IF t-w-report.Campo-F[9] > 0 THEN STRING(t-w-report.Campo-F[9], ">>>,>>9.99") ELSE "")
            t-w-report.Campo-C[17] = IF (lEstDoc = "A") THEN "2" ELSE "1"   
            t-w-report.Campo-F[11] = Registro.otrostrib.
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

    DEFINE VAR x-otros-tributos AS DEC.

    EMPTY TEMP-TABLE Registro.
    DO i = 1 TO NUM-ENTRIES(FILL-IN-CodOpe):
        x-codope = ENTRY(i, FILL-IN-CodOpe).

        x-otros-tributos = 0.

        FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.CodCia  = s-CodCia 
            AND cb-cmov.Periodo = s-Periodo 
            AND cb-cmov.NroMes  = COMBO-BOX-NroMes 
            AND cb-cmov.CodOpe  = x-CodOpe
            BREAK BY cb-cmov.NroAst:
            x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cb-cmov.codope + ' ' + cb-cmov.NroAst.
            FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = cb-cmov.CodCia 
                AND cb-dmov.Periodo = cb-cmov.Periodo 
                AND cb-dmov.NroMes = cb-cmov.NroMes 
                AND cb-dmov.CodOpe = cb-cmov.CodOpe 
                AND cb-dmov.NroAst = cb-cmov.NroAst 
                AND cb-dmov.coddoc <> ''            
                BREAK BY cb-dmov.CodDoc BY cb-dmov.nrodoc:                
                IF FIRST-OF(cb-dmov.CodDoc) OR FIRST-OF(cb-dmov.nrodoc) THEN DO :
                    x-Import[1] = 0.
                    x-Import[2] = 0.
                    x-Import[3] = 0.
                    x-Import[4] = 0.
                    x-Import[5] = 0.
                    x-Import[6] = 0.
                    x-Import[9] = 0.
                    x-CodDiv = cb-dmov.CodDiv.
                    x-CodDoc = cb-dmov.CodDoc.
                    x-Cco = ''.
                    x-TpoCmb = 0.
                END.

                /* Tributo de bolsas plasticas */
                IF cb-dmov.CodCta = '40111600' THEN DO:
                    x-otros-tributos = x-otros-tributos + cb-dmov.impmn1.
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
                        IF cb-dmov.TM = 9 THEN DO :
                            x-Import[3] = x-Import[3] + (x-Haber - x-Debe).
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
                        x-FchVto = (IF cb-dmov.FchVto = ? THEN cb-dmov.FchDoc ELSE cb-dmov.FchVto).
                        x-CodDoc = cb-dmov.CodDoc.
                        x-NroDoc = cb-dmov.NroDoc.
                        x-CodMon = IF cb-dmov.CodMon = 1 THEN "S/." ELSE "US$".
                        x-NomCli = cb-dmov.GloDoc.
                        x-Ruc    = cb-dmov.NroRuc.
                        x-CodRef = cb-dmov.CodRef.
                        x-NroRef = cb-dmov.NroRef.
                        x-TpoCmb = cb-dmov.TpoCmb.
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
                IF LAST-OF(cb-dmov.CodDoc) OR LAST-OF(cb-dmov.nrodoc) THEN DO:
                    CREATE Registro.
                    Registro.CodDiv = x-CodDiv.
                    Registro.NroAst = cb-cmov.CodOpe + cb-cmov.NroAst.
                    Registro.FchDoc = x-FchDoc.
                    Registro.FchVto = x-FchVto.
                    Registro.CodDoc = x-CodDoc.

                    Registro.otrostrib = x-otros-tributos.

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
                    Registro.ImpLin[10] = x-TpoCmb.
                    /* RHC 30/10/2013 PARCHE PARA TRANSFERENCIAS GRATUITAS 
                    LA UNICA FORMA DE PESCARLO ES POR EL LIBRO */
                    IF cb-cmov.codope = "066" THEN
                        ASSIGN
                        Registro.ImpLin[1] = 0
                        Registro.ImpLin[2] = 0
                        Registro.ImpLin[3] = 0
                        Registro.ImpLin[4] = 0
                        Registro.ImpLin[5] = 0
                        Registro.ImpLin[6] = 0
                        Registro.ImpLin[9] = 0.
                END.
            END. /* FIN DEL FOR cb-dmov */        
        END. /* FIN DEL FOR cb-cmov */
    END. /* FIN DEL DO */
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
    DEFINE VAR lFiler AS CHAR.
    DEFINE VAR lCorrela AS INT.

    cArchivo = 'Reg_Ventas.txt'.
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
    /* VNUMREGOPE   */
    OUTPUT STREAM REPORT TO VALUE(cArchivo).
    PUT STREAM REPORT UNFORMATTED
        "VMES|CORRELATIVO|VFECCOM|VFECVENPAG|VTIPDOCCOM|VNUMSER|VNUMDOCCOI|VNUMDOCCOF|"
        "VTIPDIDCLI|VNUMDIDCLI|VAPENOMRSO|VVALFACEXP|VBASIMPGRA|VIMPTOTEXO|"
        "VIMPTOTINA|VISC|VIGVIPM|VBASIMIVAP|BIVAP|VOTRTRICGO|VIMPTOTCOM|VTIPCAM|"
        "VFECMOD|VTIPDOCMOD|VNUMSERMOD|VNUMDOCMOD|SITDOC|ASIENTO"
        SKIP.

    lFiler = '00'.
    lCorrela = 1.
    FOR EACH t-w-report NO-LOCK WHERE t-w-report.task-no = s-task-no 
        AND t-w-report.Llave-C = s-user-id
        BREAK BY t-w-report.Campo-C[2]
        BY t-w-report.Campo-C[3]
        BY t-w-report.Campo-C[6]
        BY t-w-report.Campo-C[7]
        WITH FRAME b WIDTH 320 NO-BOX STREAM-IO:
        PUT STREAM REPORT
            STRING(s-periodo,"9999") FORMAT "9999"
            COMBO-BOX-NroMes FORMAT "99"
            lfiler FORMAT "99" '|'
            STRING(lCorrela,"999999") FORMAT "999999" '|'
            t-w-report.Campo-D[1] FORMAT '99/99/9999' '|'
            t-w-report.Campo-D[2] FORMAT '99/99/9999' '|'
            t-w-report.Campo-C[3] FORMAT "x(2)" '|'
            t-w-report.Campo-C[6] FORMAT "x(4)" '|'
            t-w-report.Campo-C[7] FORMAT "x(10)" '|'
            t-w-report.Campo-C[16] FORMAT "x(10)" '|'
            t-w-report.Campo-C[4] FORMAT 'x' '|'
            t-w-report.Campo-C[11] FORMAT "x(11)" '|'
            t-w-report.Campo-C[12] FORMAT "x(60)" '|'
            t-w-report.Campo-F[3] FORMAT "->>>>>>>>>>9.99" '|'
            t-w-report.Campo-F[4] FORMAT "->>>>>>>>>>9.99" '|'
            '0.00' '|'
            t-w-report.Campo-F[2] FORMAT "->>>>>>>>>>9.99" '|'
            '0.00' '|'
            t-w-report.Campo-F[5] FORMAT "->>>>>>>>>>9.99" '|'
            '0.00' '|'
            '0.00' '|'
            t-w-report.Campo-F[11] '|'
            t-w-report.Campo-F[6]  FORMAT "->>>>>>>>>>9.99" '|'
            t-w-report.Campo-C[13] FORMAT "x(8)" '|'
            t-w-report.Campo-C[14] FORMAT "x(10)" '|'
            t-w-report.Campo-C[8]  FORMAT "x(2)" '|'
            t-w-report.Campo-C[9]  FORMAT "x(4)" '|'
            t-w-report.Campo-C[10] FORMAT "x(11)" '|'
            t-w-report.Campo-C[17] FORMAT "x(1)" '|'
            t-w-report.Campo-C[5]  FORMAT 'x(9)' 
            SKIP.
            lCorrela = lCorrela + 1.
    END.                                             
    OUTPUT STREAM REPORT CLOSE.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

