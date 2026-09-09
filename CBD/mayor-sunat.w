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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.

DEFINE VAR s-NroMes AS INT.
DEFINE VAR x-Div    AS CHAR.
DEFINE VAR c-CodMon AS INT INIT 1.      /* Soles */

DEFINE TEMP-TABLE Detalle
    FIELD MMES          AS INT FORMAT '99'
    FIELD MNUMASIOPE    AS CHAR FORMAT 'x(15)'
    FIELD MNUMCTACON    AS CHAR FORMAT 'x(24)'
    FIELD MFECOPE       AS CHAR FORMAT 'x(10)'
    FIELD MGLOSA        AS CHAR FORMAT 'x(100)'
    FIELD MCENCOS       AS CHAR FORMAT 'x(10)'
    FIELD MDEBE         AS DEC FORMAT '-99999999999.99'
    FIELD MHABER        AS DEC FORMAT '-99999999999.99'
    FIELD MINTREG       AS CHAR FORMAT 'x(20)'
    INDEX Llave01 AS PRIMARY MMES.

DEFINE VARIABLE Max-Digitos AS INTEGER NO-UNDO.
DEFINE VARIABLE Ult-Nivel   AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE cb-niveles  AS CHARACTER.

ASSIGN
    Ult-Nivel   = NUM-ENTRIES(cb-niveles)
    Max-Digitos = INTEGER( ENTRY( Ult-Nivel, cb-niveles) ).

DEFINE VARIABLE x-moneda   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-fchast   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-fchdoc   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-fchvto   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-clfaux   LIKE cb-dmov.clfaux NO-UNDO.
DEFINE VARIABLE x-codaux   LIKE cb-dmov.codaux NO-UNDO.
DEFINE VARIABLE x-nroast   LIKE cb-dmov.nroast NO-UNDO.
DEFINE VARIABLE x-codope   LIKE cb-dmov.codope NO-UNDO.
DEFINE VARIABLE x-coddoc   LIKE cb-dmov.coddoc NO-UNDO.
DEFINE VARIABLE x-nrodoc   LIKE cb-dmov.nrodoc NO-UNDO.
DEFINE VARIABLE x-nroref   LIKE cb-dmov.nroref NO-UNDO.
DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc NO-UNDO.
DEFINE VARIABLE x-CodCta   LIKE cb-dmov.CodCta NO-UNDO.
DEFINE VARIABLE x-Cco      LIKE cb-dmov.Cco    NO-UNDO.
DEFINE VARIABLE x-coddiv   LIKE cb-dmov.coddiv.
DEFINE VARIABLE x-importe  AS DECIMAL.
DEFINE VARIABLE x-codmon   AS INTEGER INIT 1.
DEFINE VARIABLE x-debe     AS DECIMAL NO-UNDO. 
DEFINE VARIABLE x-haber    AS DECIMAL NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS s-Periodo BUTTON-3 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS s-Periodo FILL-IN-Mensaje 

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
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE s-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Seleccione el periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     s-Periodo AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Mensaje AT ROW 5.31 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BUTTON-3 AT ROW 5.31 COL 48 WIDGET-ID 8
     BtnDone AT ROW 5.31 COL 63 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.19 WIDGET-ID 100.


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
         TITLE              = "LIBRO MAYOR - SUNAT"
         HEIGHT             = 7.19
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
ON END-ERROR OF wWin /* LIBRO MAYOR - SUNAT */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* LIBRO MAYOR - SUNAT */
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 wWin
ON CHOOSE OF BUTTON-3 IN FRAME fMain /* Button 3 */
DO:
    DEF VAR pArchivo AS CHAR INIT "mayor".
    DEF VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE pArchivo
        FILTERS "Archivo (txt)" "*.txt"
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION LC(".txt")
        RETURN-TO-START-DIR 
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = NO THEN RETURN NO-APPLY.

    RUN Texto.

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    OUTPUT TO VALUE(pArchivo).
    PUT UNFORMATTED
            'MMES'
        '|' 'MNUMASIOPE'
        '|' 'MNUMCTACON'
        '|' 'MFECOPE'
        '|' 'MGLOSA'
        '|' 'MCENCOS'
        '|' 'MDEBE'
        '|' 'MHABER'
        '|' 'MINTREG'
        SKIP.
    FOR EACH Detalle NO-LOCK:
        PUT /*UNFORMATTED*/
            MMES          '|'
            MNUMASIOPE    '|'
            MNUMCTACON    '|'
            MFECOPE       '|'
            MGLOSA        '|'
            MCENCOS       '|'
            MDEBE         '|'
            MHABER        '|'
            MINTREG
            SKIP.
    END.
    OUTPUT CLOSE.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-Periodo wWin
ON VALUE-CHANGED OF s-Periodo IN FRAME fMain /* Seleccione el periodo */
DO:
  ASSIGN {&self-name}.
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
  DISPLAY s-Periodo FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE s-Periodo BUTTON-3 BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH cb-peri NO-LOCK WHERE codcia = s-codcia WITH FRAME {&FRAME-NAME}:
       s-Periodo:ADD-LAST(STRING(CB-PERI.Periodo, '9999')).
       s-Periodo = CB-PERI.Periodo.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto wWin 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.
DEF BUFFER B-CTAS FOR CB-CTAS.

DO s-NroMes = 00 TO 12:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESANDO MES ' + STRING(s-NroMes, '99').
    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.CodCta <> ""
        AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
        BY Cb-ctas.codcta:
        x-CodCta = cb-ctas.CodCta.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
            AND cb-dmov.periodo = s-periodo 
            AND cb-dmov.nromes  = s-nromes
            AND cb-dmov.codcta  = x-CodCta
            BREAK BY cb-dmov.CodOpe BY cb-dmov.NroAst BY cb-dmov.NroItm:
            /* Buscando la cabecera correspondiente */
            x-fchast = ?.
            FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                AND cb-cmov.periodo = cb-dmov.periodo 
                AND cb-cmov.nromes  = cb-dmov.nromes
                AND cb-cmov.codope  = cb-dmov.codope
                AND cb-cmov.nroast  = cb-dmov.nroast
                NO-LOCK NO-ERROR.
            IF AVAILABLE cb-cmov THEN x-fchast = STRING(cb-cmov.fchast).
            ASSIGN 
                x-glodoc = cb-dmov.glodoc
                x-NroAst = cb-dmov.NroAst
                x-CodOpe = cb-dmov.CodOpe
                x-codaux = cb-dmov.codaux
                x-NroDoc = cb-dmov.NroDoc
                x-NroRef = cb-dmov.NroRef
                x-coddiv = cb-dmov.CodDiv
                x-clfaux = cb-dmov.clfaux
                x-coddoc = cb-dmov.coddoc
                x-cco    = cb-dmov.cco.
            IF x-glodoc = "" THEN IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
            IF x-glodoc = "" THEN DO:
                CASE cb-dmov.clfaux:
                    WHEN "@CL" THEN DO:
                        FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                                        AND gn-clie.CodCia = cl-codcia
                                    NO-LOCK NO-ERROR. 
                        IF AVAILABLE gn-clie THEN
                            x-glodoc = gn-clie.nomcli.
                    END.
                    WHEN "@PV" THEN DO:
                        FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                        AND gn-prov.CodCia = pv-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE gn-prov THEN 
                            x-glodoc = gn-prov.nompro.
                    END.
                    WHEN "@CT" THEN DO:
                        FIND b-ctas WHERE b-ctas.codcta = cb-dmov.codaux
                            AND b-ctas.CodCia = cb-codcia
                            NO-LOCK NO-ERROR.                      
                        IF AVAILABLE b-ctas THEN x-glodoc = b-ctas.nomcta.
                    END.
                    OTHERWISE DO:
                        FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                                        AND cb-auxi.codaux = cb-dmov.codaux
                                        AND cb-auxi.CodCia = cb-codcia
                                    NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-auxi THEN 
                            x-glodoc = cb-auxi.nomaux.
                    END.
                END CASE.
            END.
            IF NOT tpomov THEN DO:
                x-importe = ImpMn1.
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = ImpMn1.
                        x-haber = 0.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = ImpMn2.
                        x-haber = 0.
                    END.
                END CASE.
            END.
            ELSE DO:
                x-importe = ImpMn1 * -1.
                CASE x-codmon:
                    WHEN 1 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn1.
                    END.
                    WHEN 2 THEN DO:
                        x-debe  = 0.
                        x-haber = ImpMn2.
                    END.
                END CASE.            
            END.
            IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
                ASSIGN
                    x-fchdoc = STRING(cb-dmov.fchdoc)
                    x-fchvto = STRING(cb-dmov.fchvto).
                x-glodoc = REPLACE(X-glodoc,CHR(10)," ").
                CREATE Detalle.
                ASSIGN
                    MMES = s-NroMes
                    MNUMASIOPE = x-nroast
                    MNUMCTACON = x-codcta
                    MFECOPE = STRING(x-fchast, '99/99/9999')
                    MGLOSA = x-glodoc
                    MCENCOS = cb-dmov.cco
                    MDEBE = x-debe
                    MHABER = x-haber.
            END.            
        END.    /* cb-dmov */
    END.    /* cb-ctas */
END.    /* s-nromes */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

