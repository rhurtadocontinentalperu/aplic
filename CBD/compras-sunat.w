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
DEF SHARED VAR pv-codcia AS INT.

DEFINE VAR s-NroMes AS INT.
DEFINE VAR x-CodOpe AS CHAR.
DEFINE VAR x-NroAst AS CHAR.
DEFINE VAR x-Div    AS CHAR.
DEFINE VAR c-CodMon AS INT INIT 1.      /* Soles */

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
DEFINE VAR x-TpoCmb AS DECIMAL.

DEFINE TEMP-TABLE Registro NO-UNDO
   FIELD CodDiv AS CHAR
   FIELD CodOpe AS CHAR
   FIELD NroAst AS CHAR
   FIELD FchDoc AS DATE
   FIELD FchVto AS DATE
   FIELD CodDoc AS CHAR
   FIELD NroDoc AS CHAR
   FIELD TpoCmb AS DECIMAL 
   FIELD CodRef AS CHAR
   FIELD NroRef AS CHAR
   FIELD Ruc    AS CHAR
   FIELD NomCli AS CHAR
   FIELD CodMon AS CHAR
   FIELD NroTra AS CHAR
   FIELD FchMod AS DATE
   FIELD Implin AS DECIMAL EXTENT 10.

DEFINE TEMP-TABLE Detalle
    FIELD CMES          AS INT FORMAT '99'
    FIELD CNUMREGOPE    AS CHAR FORMAT 'x(40)'
    FIELD CFECCOM       AS CHAR FORMAT 'x(10)'
    FIELD CFECVENPAG    AS CHAR FORMAT 'x(10)'
    FIELD CTIPDOCCOM    AS CHAR FORMAT 'x(2)'
    FIELD CNUMSER       AS CHAR FORMAT 'x(20)'
    FIELD CEMIDUADSI    AS CHAR FORMAT 'x(4)'
    FIELD CNUMDCODFV    AS CHAR FORMAT 'x(20)'
    FIELD COSDCREFIS    AS CHAR FORMAT 'x(20)'
    FIELD CTIPDIDPRO    AS CHAR FORMAT 'x'
    FIELD CNUMDIDPRO    AS CHAR FORMAT 'x(15)'
    FIELD CNOMRSOPRO    AS CHAR FORMAT 'x(60)'
    FIELD CVALFACIMP    AS DEC FORMAT '-99999999999.99'
    FIELD CBASIMPGRA    AS DEC FORMAT '-99999999999.99'
    FIELD CIGVGRA       AS DEC FORMAT '-99999999999.99'
    FIELD CBASIMPGNG    AS DEC FORMAT '-99999999999.99'
    FIELD CIGVGRANGV    AS DEC FORMAT '-99999999999.99'
    FIELD CBASIMPSCF    AS DEC FORMAT '-99999999999.99'
    FIELD CIGVSCF       AS DEC FORMAT '-99999999999.99'
    FIELD CIMPTOTNGV    AS DEC FORMAT '-99999999999.99'
    FIELD CISC          AS DEC FORMAT '-99999999999.99'
    FIELD COTRTRICGO    AS DEC FORMAT '-99999999999.99'
    FIELD CIMPTOTCOM    AS DEC FORMAT '-99999999999.99'
    FIELD CTIPCAM       AS DEC FORMAT '9.999'
    FIELD CCOMNODOMI    AS CHAR FORMAT 'x(20)'
    FIELD CEMIDEPDET    AS CHAR FORMAT 'x(10)'
    FIELD CCOMPGORET    AS CHAR FORMAT 'x'
    FIELD CINTDIAMAY    AS CHAR FORMAT 'x(20)'
    FIELD CINTKARDEX    AS CHAR FORMAT 'x(20)'
    FIELD CINTREG       AS CHAR FORMAT 'x(20)'
    INDEX Llave01 AS PRIMARY CMES.

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
&Scoped-Define ENABLED-OBJECTS s-Periodo s-CodOpe BUTTON-3 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS s-Periodo s-CodOpe FILL-IN-Mensaje 

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

DEFINE VARIABLE s-CodOpe AS CHARACTER FORMAT "X(256)":U INITIAL "060,081" 
     LABEL "Operaciones" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     s-Periodo AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 2
     s-CodOpe AT ROW 3.15 COL 29 COLON-ALIGNED WIDGET-ID 4
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
         TITLE              = "REGISTRO DE COMPRAS - SUNAT"
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
ON END-ERROR OF wWin /* REGISTRO DE COMPRAS - SUNAT */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* REGISTRO DE COMPRAS - SUNAT */
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
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR INIT "reg_compras".
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

    ASSIGN
        s-CodOpe s-Periodo.
    ASSIGN
      pOptions = "FileType:TXT" + CHR(1) + ~
                "Grid:Ver" + CHR(1) + ~ 
                "Labels:Yes".

    RUN Texto.

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    /*RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).*/
    OUTPUT TO VALUE(pArchivo).
    PUT UNFORMATTED
            'CMES'
        '|' 'CNUMREGOPE'
        '|' 'CFECCOM'
        '|' 'CFECVENPAG'
        '|' 'CTIPDOCCOM'
        '|' 'CNUMSER'
        '|' 'CEMIDUADSI'
        '|' 'CNUMDCODFV'
        '|' 'COSDCREFIS'
        '|' 'CTIPDIDPRO'
        '|' 'CNUMDIDPRO'
        '|' 'CNOMRSOPRO'
        '|' 'CVALFACIMP'
        '|' 'CBASIMPGRA'
        '|' 'CIGVGRA'
        '|' 'CBASIMPGNG'
        '|' 'CIGVGRANGV'
        '|' 'CBASIMPSCF'
        '|' 'CIGVSCF'
        '|' 'CIMPTOTNGV'
        '|' 'CISC'
        '|' 'COTRTRICGO'
        '|' 'CIMPTOTCOM'
        '|' 'CTIPCAM'
        '|' 'CCOMNODOMI'
        '|' 'CEMIDEPDET'
        '|' 'CCOMPGORET'
        '|' 'CINTDIAMAY'
        '|' 'CINTKARDEX'
        '|' 'CINTREG'
        SKIP.
    FOR EACH Detalle NO-LOCK:
        PUT /*UNFORMATTED*/
            CMES          '|'
            CNUMREGOPE    '|'
            CFECCOM       '|'
            CFECVENPAG    '|'
            CTIPDOCCOM    '|'
            CNUMSER       '|'
            CEMIDUADSI    '|'
            CNUMDCODFV    '|'
            COSDCREFIS    '|'
            CTIPDIDPRO    '|'
            CNUMDIDPRO    '|'
            CNOMRSOPRO    '|'
            CVALFACIMP    '|'
            CBASIMPGRA    '|'
            CIGVGRA       '|'
            CBASIMPGNG    '|'
            CIGVGRANGV    '|'
            CBASIMPSCF    '|'
            CIGVSCF       '|'
            CIMPTOTNGV    '|'
            CISC          '|'
            COTRTRICGO    '|'
            CIMPTOTCOM    '|'
            CTIPCAM       '|'
            CCOMNODOMI    '|'
            CEMIDEPDET    '|'
            CCOMPGORET    '|'
            CINTDIAMAY    '|'
            CINTKARDEX    '|'
            CINTREG
            SKIP.
    END.
    OUTPUT CLOSE.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura wWin 
PROCEDURE Captura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR i        AS INTEGER NO-UNDO.
  DEFINE VAR x-Debe   AS DECIMAL NO-UNDO.
  DEFINE VAR x-Haber  AS DECIMAL NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL").
  DO i = 1 TO NUM-ENTRIES(s-CodOpe) :
      x-codope = ENTRY(i, s-CodOpe).
      FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.CodCia  = s-CodCia  AND
                                     cb-cmov.Periodo = s-Periodo AND
                                     cb-cmov.NroMes  = s-NroMes  AND
                                     cb-cmov.CodOpe  = x-CodOpe
                                     BY cb-cmov.NroAst :
        IF cb-cmov.flgest = "A" THEN DO:
            CREATE Registro.
            ASSIGN
                Registro.CodDiv = cb-cmov.CodDiv
                Registro.NroAst = cb-cmov.NroAst
                Registro.CodOpe = x-codope
                Registro.NomCli = "*** ANULADO ***".
            NEXT.
        END.

          x-NroAst = cb-cmov.NroAst.
          FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia  = cb-cmov.CodCia  AND
                                         cb-dmov.Periodo = cb-cmov.Periodo AND
                                         cb-dmov.NroMes  = cb-cmov.NroMes  AND
                                         cb-dmov.CodOpe  = cb-cmov.CodOpe  AND
                                         cb-dmov.NroAst  = cb-cmov.NroAst  AND
                                         cb-dmov.CodDiv  BEGINS x-Div 
                                         BREAK BY cb-dmov.NroAst :
              IF FIRST-OF (cb-dmov.NroAst) THEN DO:
                 x-FchDoc = ?.
                 x-FchVto = ?.
                 x-CodDoc = "".
                 x-NroDoc = "".
                 x-CodMon = "".
                 x-NomCli = "".
                 x-Ruc    = "".
                 x-NroRef = "".
                 x-CodRef = "".
                 x-TpoCmb = 0.

                 x-Import[1] = 0.
                 x-Import[2] = 0.
                 x-Import[3] = 0.
                 x-Import[4] = 0.
                 x-Import[5] = 0.
                 x-Import[6] = 0.
                 x-Import[7] = 0.
                 x-Import[8] = 0.
                 x-Import[9] = 0.
                 x-Import[10] = 0.                 
                 x-CodDiv = cb-dmov.CodDiv.
              END.
              IF NOT tpomov THEN DO:
                 CASE c-codmon:
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
                  CASE c-codmon:
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

              CASE cb-dmov.TM :
                   WHEN 3 THEN x-Import[1] = x-Import[1] + (x-Debe - x-Haber).
                   WHEN 5 THEN x-Import[3] = x-Import[3] + (x-Debe - x-Haber).
                   WHEN 4 THEN x-Import[4] = x-Import[4] + (x-Debe - x-Haber).
                   WHEN 6 THEN x-Import[5] = x-Import[5] + (x-Debe - x-Haber).                   
                   WHEN 10 THEN x-Import[7] = x-Import[7] + (x-Debe - x-Haber).
                   WHEN 7 THEN x-Import[8] = x-Import[8] + (x-Debe - x-Haber).                   
                   WHEN 8 OR WHEN 11 THEN DO :                          
                          x-Import[10] = x-Import[10] + (x-Haber - x-Debe).
                          IF x-Import[10] < 0 THEN DO:
                             IF cb-dmov.CodMon = 2 THEN 
                                ASSIGN x-Import[9] = x-Import[9] + cb-dmov.ImpMn2 * -1
                                          x-TpoCmb = cb-dmov.TpoCmb.                        
                           END.
                          ELSE DO:
                             IF cb-dmov.CodMon = 2 THEN 
                                ASSIGN x-Import[9] = x-Import[9] + cb-dmov.ImpMn2 
                                          x-TpoCmb = cb-dmov.TpoCmb.                                  
                           END.
                          x-FchDoc = cb-dmov.FchDoc.
                          x-CodDoc = cb-dmov.CodDoc.
                          x-NroDoc = cb-dmov.NroDoc.
                          x-FchVto = IF x-CodDoc = '14' THEN cb-dmov.FchVto ELSE ?.
                          x-CodMon = IF cb-dmov.CodMon = 1 THEN "S/." ELSE "US$".                         
                          x-Ruc    = cb-dmov.NroRuc.
                          x-NroRef = cb-dmov.Nroref.
                          x-CodRef = cb-dmov.CodRef.

                          FIND GN-PROV WHERE GN-PROV.CodCia = pv-codcia AND
                                             GN-PROV.codPro = cb-dmov.CodAux NO-LOCK NO-ERROR.
                          IF AVAILABLE GN-PROV THEN x-NomCli = GN-PROV.NomPro.
                             ELSE x-NomCli = cb-dmov.GloDoc.                   
                   END.

              END CASE.
              IF LAST-OF (cb-dmov.NroAst) THEN DO :
                 CREATE Registro.
                 Registro.CodDiv = x-CodDiv.
                 Registro.NroAst = x-NroAst.
                 Registro.CodOpe = x-codope.
                 Registro.FchDoc = x-FchDoc.
                 Registro.FchVto = x-FchVto.
                 Registro.CodDoc = x-CodDoc.
                 Registro.NroDoc = x-NroDoc.
                 Registro.CodRef = x-CodRef.
                 Registro.NroRef = x-NroRef.
                 Registro.Ruc    = x-Ruc.
                 Registro.NomCli = x-NomCli.
                 Registro.CodMon = x-CodMon.
                 Registro.TpoCmb = x-TpoCmb.
                 Registro.ImpLin[1] = x-Import[1].
                 Registro.ImpLin[2] = x-Import[2].
                 Registro.ImpLin[3] = x-Import[3].
                 Registro.ImpLin[4] = x-Import[4].
                 Registro.ImpLin[5] = x-Import[5].
                 Registro.ImpLin[6] = x-Import[6].
                 Registro.ImpLin[7] = x-Import[7].
                 Registro.ImpLin[8] = x-Import[8].
                 Registro.ImpLin[9] = x-Import[9].
                 Registro.ImpLin[10] = x-Import[10].
                 registro.NroTra     = cb-cmov.Nrotra.
                 Registro.FchMod     = cb-cmov.fchmod.
              END.

          END. /* FIN DEL FOR cb-dmov */        

      END. /* FIN DEL FOR cb-cmov */

   END. /* FIN DEL DO */

   SESSION:SET-WAIT-STATE("").

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
  DISPLAY s-Periodo s-CodOpe FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE s-Periodo s-CodOpe BUTTON-3 BtnDone 
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
DEFINE VAR x-NroSer AS CHAR.
DEFINE VAR x-NroDoc AS CHAR.
DEFINE VAR x-SerRef AS CHAR.
DEFINE VAR x-NroRef AS CHAR.

EMPTY TEMP-TABLE Detalle.
DO s-NroMes = 1 TO 12:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESANDO MES ' + STRING(s-NroMes, '99').
    EMPTY TEMP-TABLE Registro.
    RUN Captura.
    FOR EACH Registro:
        ASSIGN
            x-NroSer = ''
            x-NroDoc = ''
            x-SerRef = ''
            x-NroRef = ''.
        ASSIGN
            x-NroDoc = Registro.NroDoc
            x-NroRef = Registro.NroRef.
        IF INDEX(x-NroDoc, '-') > 0 THEN DO:
            x-NroSer = SUBSTRING(x-NroDoc, 1 , INDEX(x-NroDoc, '-') - 1).
            x-NroDoc = SUBSTRING(x-NroDoc, INDEX(x-NroDoc, '-') + 1).
        END.
        IF INDEX(x-NroRef, '-') > 0 THEN DO:
            x-SerRef = SUBSTRING(x-NroRef, 1 , INDEX(x-NroRef, '-') - 1).
            x-NroRef = SUBSTRING(x-NroRef, INDEX(x-NroRef, '-') + 1).
        END.
        CREATE Detalle.
        ASSIGN
            Detalle.CMES          = s-NroMes
            Detalle.CNUMREGOPE    = Registro.NroAst
            Detalle.CFECCOM       = (IF Registro.FchDoc = ? THEN '' ELSE STRING(Registro.FchDoc, '99/99/9999'))
            /*Detalle.CFECVENPAG    */
            Detalle.CTIPDOCCOM    = Registro.CodDoc
            Detalle.CNUMSER       = x-NroSer
            /*Detalle.CEMIDUADSI    */
            Detalle.CNUMDCODFV    = x-NroDoc
            /*Detalle.COSDCREFIS    */
            Detalle.CTIPDIDPRO    = '6'
            Detalle.CNUMDIDPRO    = Registro.Ruc
            Detalle.CNOMRSOPRO    = Registro.NomCli
            /*Detalle.CVALFACIMP    */
            Detalle.CBASIMPGRA    = Registro.ImpLin[1]
            /*Detalle.CIGVGRA       */
            Detalle.CBASIMPGNG    = Registro.ImpLin[2]
            Detalle.CIGVGRANGV    = Registro.ImpLin[5]
            Detalle.CBASIMPSCF    = Registro.ImpLin[3]
            /*Detalle.CIGVSCF       */
            Detalle.CIMPTOTNGV    = Registro.ImpLin[4]
            /*Detalle.CISC          */
            Detalle.COTRTRICGO    = Registro.ImpLin[6]
            Detalle.CIMPTOTCOM    = Registro.ImpLin[10]
            Detalle.CTIPCAM       = Registro.TpoCmb
/*             Detalle.CCOMNODOMI */
/*             Detalle.CEMIDEPDET */
/*             Detalle.CCOMPGORET */
/*             Detalle.CINTDIAMAY */
/*             Detalle.CINTKARDEX */
/*             Detalle.CINTREG    */
            .
    END.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

