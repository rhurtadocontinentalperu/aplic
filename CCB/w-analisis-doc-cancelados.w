&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER LETRAS FOR CcbCDocu.



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
DEF SHARED VAR s-codcia AS INTE.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF TEMP-TABLE Detalle
    FIELD coddoc LIKE ccbcdocu.coddoc
    FIELD nrodoc LIKE ccbcdocu.nrodoc
    FIELD fchdoc LIKE ccbcdocu.fchdoc
    FIELD imptot LIKE ccbcdocu.imptot
    FIELD codcli LIKE ccbcdocu.codcli
    FIELD nomcli LIKE ccbcdocu.nomcli
    FIELD ruccli LIKE ccbcdocu.ruccli
    FIELD fchcan LIKE ccbcdocu.fchcan

    .

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
&Scoped-Define ENABLED-OBJECTS FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 ~
FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/proces.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN_FchDoc-1 AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_FchDoc-2 AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 5.31 COL 4 WIDGET-ID 6
     FILL-IN-Mensaje AT ROW 5.58 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 8.27 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: LETRAS B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 8.27
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
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
  ASSIGN FILL-IN_FchDoc-1 FILL-IN_FchDoc-2.

  /* Pantalla de Impresión */
  DEF VAR pOptions AS CHAR.
  DEF VAR pArchivo AS CHAR.
  DEF VAR cArchivo AS CHAR.

  RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
  IF pOptions = "" THEN RETURN NO-APPLY.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').

  FIND FIRST Detalle NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Detalle THEN DO:
      MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  cArchivo = LC(pArchivo).
  SESSION:SET-WAIT-STATE('GENERAL').
  IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
  RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
  SESSION:DATE-FORMAT = "dmy".
  SESSION:SET-WAIT-STATE('').
  /* ******************************************************* */

  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
  FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cDocumentos AS CHAR NO-UNDO.
DEF VAR pFchCan AS DATE NO-UNDO.
DEF VAR cNomCli AS CHAR NO-UNDO.

cDocumentos = "FAC,BOL,N/C".

DEF VAR iItem AS INTE NO-UNDO.

PRINCIPAL:
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia AND
    ccbcdocu.fchdoc >= FILL-IN_FchDoc-1 AND
    ccbcdocu.fchdoc <= FILL-IN_FchDoc-2:
    IF NOT ( LOOKUP(ccbcdocu.coddoc, cDocumentos) > 0 AND ccbcdocu.flgest = "C" ) THEN NEXT.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO >>> " + ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc.
    CREATE detalle.
    BUFFER-COPY ccbcdocu EXCEPT ccbcdocu.fchcan TO detalle.
    RUN lib/limpiar-texto-abc (INPUT ccbcdocu.nomcli, INPUT '', OUTPUT cNomCli).
    detalle.nomcli = cNomCli.
    RUN fDameFecha (INPUT ccbcdocu.coddoc, INPUT ccbcdocu.nrodoc, OUTPUT pFchCan).
    detalle.fchcan = pFchCan.
END.


END PROCEDURE.

PROCEDURE fDameFecha:

    DEF INPUT PARAMETER pCodRef AS CHAR.
    DEF INPUT PARAMETER pNroRef AS CHAR.
    DEF OUTPUT PARAMETER pFchCan AS DATE.

    FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = s-codcia AND
        ccbdcaja.codref = pCodRef AND 
        ccbdcaja.nroref = pNroRef
        BY ccbdcaja.fchdoc DESC:
        CASE TRUE:
            WHEN LOOKUP(ccbdcaja.coddoc, 'CJE,CLA,RNV,REF') > 0 THEN DO:   /* Canje por letra */
                RUN fDameFechaLetras (INPUT ccbdcaja.coddoc, INPUT ccbdcaja.nrodoc, OUTPUT pFchCan).
            END.
            OTHERWISE DO:
                pFchCan = ccbdcaja.fchdoc.
            END.
        END CASE.
        LEAVE.  /* SOlo el primer documento */
    END.

END PROCEDURE.

/* ************************ */
PROCEDURE fDameFechaLetras:
/* ************************ */

    DEF INPUT PARAMETER pCodRef AS CHAR.
    DEF INPUT PARAMETER pNroRef AS CHAR.
    DEF OUTPUT PARAMETER pFchCan AS DATE NO-UNDO.

    /* Si un documento ha sido canjeado por letra hay que analizar letra x letra */
    DEF BUFFER b-ccbdcaja FOR ccbdcaja.
    DEF BUFFER LETRAS FOR ccbcdocu.

    FIND FIRST LETRAS WHERE LETRAS.codcia = s-codcia AND
        LETRAS.coddoc = "LET" AND
        LETRAS.codref = pCodRef AND
        LETRAS.nroref = pNroRef AND
        LETRAS.flgest <> "C" NO-LOCK NO-ERROR.
    IF AVAILABLE LETRAS THEN RETURN.
    FOR EACH LETRAS NO-LOCK WHERE LETRAS.codcia = s-codcia AND
            LETRAS.coddoc = "LET" AND
            LETRAS.codref = pCodRef AND
            LETRAS.nroref = pNroRef,
        EACH b-ccbdcaja NO-LOCK WHERE b-ccbdcaja.codcia = s-codcia AND
            b-ccbdcaja.codref = LETRAS.coddoc AND 
            b-ccbdcaja.nroref = LETRAS.nrodoc
        BY b-ccbdcaja.fchdoc DESC:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO >>> " + LETRAS.coddoc + ' ' + LETRAS.nrodoc.
        CASE TRUE:
            WHEN LOOKUP(b-ccbdcaja.coddoc, 'CJE,CLA,RNV,REF') > 0 THEN DO:   /* Canje por letra */
                RUN fDameFechaLetrasDeep (INPUT b-ccbdcaja.coddoc, INPUT b-ccbdcaja.nrodoc, OUTPUT pFchCan).
            END.
            OTHERWISE DO:
                pFchCan = b-ccbdcaja.fchdoc.
            END.
        END CASE.
        LEAVE.  /* SOlo el primer documento */
    END.

END PROCEDURE.


/* ************************ */
PROCEDURE fDameFechaLetrasDeep:
/* ************************ */

    DEF INPUT PARAMETER pCodRef AS CHAR.
    DEF INPUT PARAMETER pNroRef AS CHAR.
    DEF OUTPUT PARAMETER pFchCan AS DATE NO-UNDO.

    /* Si un documento ha sido canjeado por letra hay que analizar letra x letra */
    DEF BUFFER b-ccbdcaja FOR ccbdcaja.
    DEF BUFFER LETRAS FOR ccbcdocu.

    FIND FIRST LETRAS WHERE LETRAS.codcia = s-codcia AND
        LETRAS.coddoc = "LET" AND
        LETRAS.codref = pCodRef AND
        LETRAS.nroref = pNroRef AND
        LETRAS.flgest <> "C" NO-LOCK NO-ERROR.
    IF AVAILABLE LETRAS THEN RETURN.
    FOR EACH LETRAS NO-LOCK WHERE LETRAS.codcia = s-codcia AND
            LETRAS.coddoc = "LET" AND
            LETRAS.codref = pCodRef AND
            LETRAS.nroref = pNroRef,
        EACH b-ccbdcaja NO-LOCK WHERE b-ccbdcaja.codcia = s-codcia AND
            b-ccbdcaja.codref = LETRAS.coddoc AND 
            b-ccbdcaja.nroref = LETRAS.nrodoc
        BY b-ccbdcaja.fchdoc DESC:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO >>> " + LETRAS.coddoc + ' ' + LETRAS.nrodoc.
        CASE TRUE:
            WHEN LOOKUP(b-ccbdcaja.coddoc, 'CJE,CLA,RNV,REF') > 0 THEN DO:   /* Canje por letra */
                /*RUN fDameFechaLetrasDeep (OUTPUT pFchCan).*/
            END.
            OTHERWISE DO:
                pFchCan = b-ccbdcaja.fchdoc.
            END.
        END CASE.
        LEAVE.  /* SOlo el primer documento */
    END.

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
  DISPLAY FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 BUTTON-1 
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

