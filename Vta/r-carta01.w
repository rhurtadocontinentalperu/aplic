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

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cFecha AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMeses AS CHARACTER NO-UNDO INITIAL
    "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEFINE VARIABLE Word AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE cl-CodCia AS INTEGER NO-UNDO.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

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
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando..." FONT 7.

FIND FIRST Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE Empresas THEN DO:
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
END.

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
&Scoped-Define ENABLED-OBJECTS RADIO-SET-sort FILL-IN-Codcli FILL-IN-fecdoc ~
BUTTON-print BUTTON-exit RADIO-SET-option FILL-IN-Codcli-2 RECT-2 ~
FILL-IN-Nomcli FILL-IN-NomCli-2 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-sort FILL-IN-Codcli ~
FILL-IN-fecdoc RADIO-SET-option FILL-IN-Codcli-2 FILL-IN-Nomcli ~
FILL-IN-NomCli-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-exit 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Salir" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-print 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE FILL-IN-Codcli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Codcli-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecdoc AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nomcli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-option AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Carta", 1,
"Sobre", 2
     SIZE 12 BY 1.62 NO-UNDO.

DEFINE VARIABLE RADIO-SET-sort AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Código", 1,
"Nombre", 2
     SIZE 12 BY 1.88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 7.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-sort AT ROW 1.81 COL 15 NO-LABEL WIDGET-ID 16
     FILL-IN-Codcli AT ROW 3.96 COL 12 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-fecdoc AT ROW 6.12 COL 12 COLON-ALIGNED
     BUTTON-print AT ROW 9.08 COL 59
     BUTTON-exit AT ROW 9.08 COL 75
     RADIO-SET-option AT ROW 6.65 COL 56 NO-LABEL WIDGET-ID 8
     FILL-IN-Codcli-2 AT ROW 3.96 COL 53 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Nomcli AT ROW 5.04 COL 12 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-NomCli-2 AT ROW 5.04 COL 53 COLON-ALIGNED WIDGET-ID 24
     "Formato:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 7.19 COL 49 WIDGET-ID 14
     "Ordenado por:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 2.35 COL 4 WIDGET-ID 20
     RECT-2 AT ROW 1.27 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.14 BY 10.15
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
         TITLE              = "Carta a Clientes Agentes Retenedores"
         HEIGHT             = 10.15
         WIDTH              = 92.14
         MAX-HEIGHT         = 10.15
         MAX-WIDTH          = 92.14
         VIRTUAL-HEIGHT     = 10.15
         VIRTUAL-WIDTH      = 92.14
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
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Carta a Clientes Agentes Retenedores */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Carta a Clientes Agentes Retenedores */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-exit W-Win
ON CHOOSE OF BUTTON-exit IN FRAME F-Main /* Salir */
DO:
    RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-print W-Win
ON CHOOSE OF BUTTON-print IN FRAME F-Main /* Imprimir */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-codcli
            FILL-IN-fecdoc
            FILL-IN-Codcli-2
            RADIO-SET-option
            FILL-IN-Nomcli
            FILL-IN-NomCli-2
            RADIO-SET-sort.
        cFecha = "Ate, " + STRING(DAY(FILL-IN-fecdoc)) + " de " +
            ENTRY(MONTH(FILL-IN-fecdoc),cMeses) + " del " + STRING(YEAR(FILL-IN-fecdoc)).
        IF FILL-IN-Codcli-2 = "" THEN
            FILL-IN-Codcli-2 = "99999999999".
        IF FILL-IN-Nomcli-2 = "" THEN
            FILL-IN-Nomcli-2 = "ZZZZZZZZZZZ".
    END.

    RUN proc_print.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-sort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-sort W-Win
ON VALUE-CHANGED OF RADIO-SET-sort IN FRAME F-Main
DO:
    CASE SELF:SCREEN-VALUE:
        WHEN "1" THEN DO:
            FILL-IN-Codcli:SENSITIVE = TRUE.
            FILL-IN-Codcli-2:SENSITIVE = TRUE.
            FILL-IN-Nomcli:SENSITIVE = FALSE.
            FILL-IN-NomCli-2:SENSITIVE = FALSE.
        END.
        WHEN "2" THEN DO:
            FILL-IN-Codcli:SENSITIVE = FALSE.
            FILL-IN-Codcli-2:SENSITIVE = FALSE.
            FILL-IN-Nomcli:SENSITIVE = TRUE.
            FILL-IN-NomCli-2:SENSITIVE = TRUE.
        END.
    END CASE.
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
  DISPLAY RADIO-SET-sort FILL-IN-Codcli FILL-IN-fecdoc RADIO-SET-option 
          FILL-IN-Codcli-2 FILL-IN-Nomcli FILL-IN-NomCli-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-sort FILL-IN-Codcli FILL-IN-fecdoc BUTTON-print BUTTON-exit 
         RADIO-SET-option FILL-IN-Codcli-2 RECT-2 FILL-IN-Nomcli 
         FILL-IN-NomCli-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

   DEFINE VARIABLE pto AS LOGICAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN FILL-IN-fecdoc = TODAY.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    DO WITH FRAME {&FRAME-NAME}:
        APPLY "VALUE-CHANGED":U TO RADIO-SET-sort.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_print W-Win 
PROCEDURE proc_print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cProvincia AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDistrito AS CHARACTER NO-UNDO.
    DEFINE VARIABLE icount AS INTEGER NO-UNDO.

    IF RADIO-SET-sort = 1 THEN FOR EACH gn-clie
        FIELDS (gn-clie.codcia gn-clie.codcli gn-clie.nomcli gn-clie.dircli
            gn-clie.flgsit gn-clie.rucold gn-clie.CodDept gn-clie.codprov gn-clie.coddist)
        WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli >= FILL-IN-Codcli
        AND gn-clie.codcli <= FILL-IN-Codcli-2
        AND gn-clie.flgsit = "A"
        AND gn-clie.rucold = "Si"
        NO-LOCK:

        DISPLAY
            gn-clie.codcli @ Fi-Mensaje LABEL "  Cliente" FORMAT "X(24)"
            WITH FRAME F-Proceso.

        FIND Tabprovi
            WHERE Tabprovi.CodDepto = gn-clie.CodDept
            AND Tabprovi.Codprovi = gn-clie.codprov
            NO-LOCK NO-ERROR.
        IF AVAILABLE Tabprovi THEN 
            cProvincia = Tabprovi.Nomprovi.
        ELSE
            cProvincia = "".

        /* Captura Distrito */
        FIND Tabdistr
            WHERE Tabdistr.CodDepto = gn-clie.CodDept
            AND Tabdistr.Codprovi = gn-clie.codprov
            AND Tabdistr.Coddistr = gn-clie.coddist
            NO-LOCK NO-ERROR.
        IF AVAILABLE Tabdistr
        THEN cDistrito = Tabdistr.Nomdistr .
        ELSE cDistrito = "".

        IF cDistrito <> "" THEN
            cProvincia = cDistrito + " - " + cProvincia.
        IF cProvincia = "" THEN
            cProvincia = "LIMA".

        CASE RADIO-SET-option:
            WHEN 1 THEN RUN proc_print_letter(gn-clie.nomcli,gn-clie.dircli,cProvincia).
            WHEN 2 THEN RUN proc_print_sobre(gn-clie.nomcli,gn-clie.dircli,cProvincia).
        END CASE.

        icount = icount + 1.

    END.
    ELSE FOR EACH gn-clie
        FIELDS (gn-clie.codcia gn-clie.codcli gn-clie.nomcli gn-clie.dircli
            gn-clie.flgsit gn-clie.rucold gn-clie.CodDept gn-clie.codprov gn-clie.coddist)
        WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.nomcli >= FILL-IN-nomcli
        AND gn-clie.nomcli <= FILL-IN-nomcli-2
        AND gn-clie.flgsit = "A"
        AND gn-clie.rucold = "Si"
        NO-LOCK BY gn-clie.nomcli:

        DISPLAY
            gn-clie.nomcli @ Fi-Mensaje LABEL "  Cliente" FORMAT "X(24)"
            WITH FRAME F-Proceso.

        FIND Tabprovi
            WHERE Tabprovi.CodDepto = gn-clie.CodDept
            AND Tabprovi.Codprovi = gn-clie.codprov
            NO-LOCK NO-ERROR.
        IF AVAILABLE Tabprovi THEN 
            cProvincia = Tabprovi.Nomprovi.
        ELSE
            cProvincia = "".

        /* Captura Distrito */
        FIND Tabdistr
            WHERE Tabdistr.CodDepto = gn-clie.CodDept
            AND Tabdistr.Codprovi = gn-clie.codprov
            AND Tabdistr.Coddistr = gn-clie.coddist
            NO-LOCK NO-ERROR.
        IF AVAILABLE Tabdistr
        THEN cDistrito = Tabdistr.Nomdistr .
        ELSE cDistrito = "".

        IF cDistrito <> "" THEN
            cProvincia = cDistrito + " - " + cProvincia.
        IF cProvincia = "" THEN
            cProvincia = "LIMA".

        CASE RADIO-SET-option:
            WHEN 1 THEN RUN proc_print_letter(gn-clie.nomcli,gn-clie.dircli,cProvincia).
            WHEN 2 THEN RUN proc_print_sobre(gn-clie.nomcli,gn-clie.dircli,cProvincia).
        END CASE.

        icount = icount + 1.

    END.

    HIDE FRAME F-Proceso.

    MESSAGE
        "Se ha impreso" icount "registros"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_print_letter W-Win 
PROCEDURE proc_print_letter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_nomcli AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER para_dircli AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER para_distri AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.

    CREATE "Word.Application" Word.
    Word:Documents:ADD("cartacliente01").

    RUN proc_Reemplazo(
        INPUT "FECDOC",
        INPUT cFecha,
        INPUT 0).
    RUN proc_Reemplazo(
        INPUT "NOMCLI",
        INPUT para_nomcli,
        INPUT 0).
    RUN proc_Reemplazo(
        INPUT "DIRCLI",
        INPUT para_dircli,
        INPUT 0).
    RUN proc_Reemplazo(
        INPUT "DISTRI",
        INPUT para_distri,
        INPUT 0).

    Word:ActiveDocument:PrintOut().
    cFile = "cartacliente01".
    Word:ChangeFileOpenDirectory("N:\").
    Word:ActiveDocument:SaveAs(cFile).
    Word:QUIT().
    RELEASE OBJECT Word NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_print_sobre W-Win 
PROCEDURE proc_print_sobre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_nomcli AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER para_dircli AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER para_distri AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.

    CREATE "Word.Application" Word.
    Word:Documents:ADD("sobrecliente01").

    RUN proc_Reemplazo(
        INPUT "NOMCLI",
        INPUT para_nomcli,
        INPUT 0).
    RUN proc_Reemplazo(
        INPUT "DIRCLI",
        INPUT para_dircli,
        INPUT 0).
    RUN proc_Reemplazo(
        INPUT "DISTRI",
        INPUT para_distri,
        INPUT 0).

    Word:ActiveDocument:PrintOut().
    cFile = "sobrecliente01".
    Word:ChangeFileOpenDirectory("N:\").
    Word:ActiveDocument:SaveAs(cFile).
    Word:QUIT().
    RELEASE OBJECT Word NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Reemplazo W-Win 
PROCEDURE proc_Reemplazo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_Campo AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER para_Registro AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER mayuscula AS LOGICAL NO-UNDO.

    DEFINE VARIABLE cBuffer AS CHARACTER NO-UNDO.

    Word:SELECTION:GOTO(-1 BY-VARIANT-POINTER,,,para_Campo BY-VARIANT-POINTER).
    Word:SELECTION:SELECT().
    IF mayuscula = TRUE THEN cBuffer = CAPS(para_Registro).
    ELSE cBuffer = para_Registro.

    Word:SELECTION:Typetext(cBuffer).

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

    CASE HANDLE-CAMPO:NAME:
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

