&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

    DEFINE SHARED VAR s-CodCia  AS INTEGER.
    DEFINE SHARED VAR Cb-CodCia AS INTEGER.
    DEFINE SHARED VAR Cl-CodCia AS INTEGER.
    DEFINE SHARED VAR s-NroMes  AS INTEGER.
    DEFINE SHARED VAR s-NomCia  AS CHARACTER.
    DEFINE SHARED VAR s-Periodo AS INTEGER.
    DEFINE SHARED VAR s-user-id AS CHAR.

    DEFINE STREAM REPORT.
    DEF VAR s-task-no LIKE w-report.task-no NO-UNDO.
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
    DEFINE VAR C-BIMP AS CHAR.
    DEFINE VAR C-ISC  AS CHAR.
    DEFINE VAR C-IGV  AS CHAR.
    DEFINE VAR C-TOT  AS CHAR.

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
        FIELD Implin AS DECIMAL EXTENT 10.

    /*DEFINE IMAGE IMAGE-2 FILENAME "IMG\print" SIZE 5 BY 1.5.*/
    DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.

    DEFINE FRAME F-Proceso
        /*IMAGE-2 AT ROW 1.5 COL 5*/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-CodMon FILL-IN-coddiv FILL-IN-CodOpe ~
x-Periodo x-NroMes BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS RADIO-CodMon FILL-IN-coddiv FILL-IN-CodOpe ~
x-Periodo x-NroMes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.54 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 1" 
     SIZE 9 BY 1.54 TOOLTIP "Exportar a texto".

DEFINE VARIABLE x-NroMes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE x-Periodo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY .81 NO-UNDO.

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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     RADIO-CodMon AT ROW 2.15 COL 13 NO-LABEL WIDGET-ID 20
     FILL-IN-coddiv AT ROW 2.15 COL 37 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-CodOpe AT ROW 2.92 COL 29.57 WIDGET-ID 18
     x-Periodo AT ROW 3.69 COL 37 COLON-ALIGNED WIDGET-ID 30
     x-NroMes AT ROW 4.65 COL 37 COLON-ALIGNED WIDGET-ID 32
     BUTTON-1 AT ROW 6.58 COL 61 WIDGET-ID 2
     BtnDone AT ROW 6.58 COL 70 WIDGET-ID 28
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .65 AT ROW 2.15 COL 6 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.31
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "SUNAT - VENTAS"
         HEIGHT             = 7.31
         WIDTH              = 80
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-CodOpe IN FRAME fMain
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* SUNAT - VENTAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* SUNAT - VENTAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
   
  ASSIGN FILL-IN-coddiv FILL-IN-CodOpe RADIO-CodMon.
  ASSIGN x-NroMes x-Periodo.

  DEFINE VARIABLE cArchivo AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lRpta AS LOGICAL NO-UNDO.

  cArchivo = 'Ventas' + x-Periodo + x-NroMes + '.txt'.
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

  SESSION:SET-WAIT-STATE('GENERAL').
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
      PUT STREAM REPORT UNFORMATTED
          x-Periodo x-NroMes '00' '|'
          STRING(w-report.Campo-C[5], "x(6)") '|'
          STRING(w-report.Campo-D[1], "99/99/9999") '|'
          STRING(w-report.Campo-D[2], "99/99/9999") '|'
          STRING(w-report.Campo-C[3], "x(2)") '|'
          STRING(w-report.Campo-C[6], "x(4)") '|'
          STRING(w-report.Campo-C[7], "x(6)") '|'
          '0|'
          STRING(INTEGER(w-report.Campo-C[4]), "9") '|'
          STRING(w-report.Campo-C[11], "x(11)") '|'
          STRING(w-report.Campo-C[12], "x(60)") '|'
          '0.00|'
          STRING(w-report.Campo-F[4], "(>>>>>>>>>9.99)") '|'
          STRING(w-report.Campo-F[2], "(>>>>>>>>>9.99)") '|'
          '0.00|'
          '0.00|'
          '0.00|'
          STRING(w-report.Campo-F[6], "(>>>>>>>>>9.99)") '|'
          STRING(DECIMAL(w-report.Campo-C[13]), "9.999") '|'
          STRING(w-report.Campo-C[14], "x(10)") '|'
          STRING(w-report.Campo-C[8], "x(2)") '|'
          STRING(w-report.Campo-C[9], "x(3)") '|'
          STRING(w-report.Campo-C[10], "x(6)") '|'
          '1|'
          SKIP.
  END.
  OUTPUT STREAM REPORT CLOSE.

  FOR EACH w-report WHERE
      w-report.task-no = s-task-no AND
      w-report.Llave-C = s-user-id.
      DELETE w-report.
  END.
  SESSION:SET-WAIT-STATE('').

  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY RADIO-CodMon FILL-IN-coddiv FILL-IN-CodOpe x-Periodo x-NroMes 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RADIO-CodMon FILL-IN-coddiv FILL-IN-CodOpe x-Periodo x-NroMes BUTTON-1 
         BtnDone 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato wWin 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
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
        FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia 
            AND ccbcdocu.coddoc = x-coddoc 
            AND ccbcdocu.nrodoc = Registro.nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu THEN DO:
            IF LOOKUP(ccbcdocu.coddoc, "FAC,N/C,N/D") > 0 AND
                Registro.Ruc = "" THEN Registro.Ruc = ccbcdocu.ruc.
        END.
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
            w-report.Campo-D[2] = Registro.FchVto
            w-report.Campo-F[1] = Registro.ImpLin[1] 
            w-report.Campo-F[2] = Registro.ImpLin[2] 
            w-report.Campo-F[3] = Registro.ImpLin[3] 
            w-report.Campo-F[4] = Registro.ImpLin[4] 
            w-report.Campo-F[5] = Registro.ImpLin[5] 
            w-report.Campo-F[6] = Registro.ImpLin[6] 
            w-report.Campo-F[9] = (IF Registro.ImpLin[9] > 0 THEN Registro.ImpLin[9] ELSE 0)    /* Importe en US$ */
            w-report.Campo-F[10] = (IF Registro.ImpLin[9] > 0 THEN Registro.ImpLin[10] ELSE 0)  /* Tpo de Cambio */
            w-report.Campo-C[13] = (IF w-report.Campo-F[10] > 0 THEN STRING(w-report.Campo-F[10], ">>9.999<") ELSE "")
            w-report.Campo-C[14] = IF fFchRef <> ? THEN STRING(fFchRef,"99/99/9999") ELSE ""
            w-report.Campo-L[1] = NOT LAST(Registro.CodCia)
            w-report.Campo-C[15] = (IF w-report.Campo-F[9] > 0 THEN STRING(w-report.Campo-F[9], ">>>,>>9.99") ELSE "").
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND cb-cfgg WHERE
      cb-cfgg.CODCIA = cb-codcia AND
      cb-cfgg.CODCFG = "R02"
      NO-LOCK NO-ERROR.
  IF AVAIL cb-cfgg THEN
      FILL-IN-CodOpe = cb-cfgg.codope.
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH cb-peri NO-LOCK WHERE cb-peri.codcia = s-codcia
          AND cb-peri.periodo <> 0:
          x-Periodo:ADD-LAST(STRING(cb-peri.periodo, '9999')).
      END.
      x-Periodo = STRING(s-Periodo, '9999').
      x-NroMes = STRING(s-NroMes, '99').
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-temp wWin 
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
    DEFINE VAR iPeriodo LIKE s-Periodo NO-UNDO.
    DEFINE VAR iNroMes  LIKE s-NroMes  NO-UNDO.

    ASSIGN
        iPeriodo = INTEGER(x-Periodo)
        iNroMes  = INTEGER(x-NroMes).

    DISPLAY WITH FRAME F-Proceso.

    EMPTY TEMP-TABLE Registro.
    DO i = 1 TO NUM-ENTRIES(FILL-IN-CodOpe):
        x-codope = ENTRY(i, FILL-IN-CodOpe).
        FOR EACH cb-cmov NO-LOCK WHERE
            cb-cmov.CodCia  = s-CodCia AND
            cb-cmov.Periodo = iPeriodo AND
            cb-cmov.NroMes  = iNroMes AND
            cb-cmov.CodOpe  = x-CodOpe
            BREAK BY cb-cmov.NroAst:
            DISPLAY cb-cmov.NroAst @ Fi-Mensaje WITH FRAME F-Proceso.
            FOR EACH cb-dmov NO-LOCK WHERE
                cb-dmov.CodCia = cb-cmov.CodCia AND
                cb-dmov.Periodo = cb-cmov.Periodo AND
                cb-dmov.NroMes = cb-cmov.NroMes AND
                cb-dmov.CodOpe = cb-cmov.CodOpe AND
                cb-dmov.NroAst = cb-cmov.NroAst AND
                cb-dmov.coddoc <> ''            AND
                cb-dmov.CodDiv BEGINS FILL-IN-coddiv
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
                    x-Cco = ''.
                    x-TpoCmb = 0.
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
                    Registro.NroAst = cb-cmov.NroAst.
                    Registro.FchDoc = x-FchDoc.
                    Registro.FchVto = x-FchVto.
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
                    Registro.ImpLin[10] = x-TpoCmb.
                END.
            END. /* FIN DEL FOR cb-dmov */        
        END. /* FIN DEL FOR cb-cmov */
    END. /* FIN DEL DO */
    HIDE FRAME F-Proceso.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

