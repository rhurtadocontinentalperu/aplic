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
    FIELDS FchMod AS DATE
    FIELDS Implin AS DECIMAL EXTENT 10
    FIELDS AnoDUA AS CHARACTER
    FIELDS NroTra AS CHAR
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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-NroMes FILL-IN-CodOpe RADIO-CodMon ~
Btn_OK BtnDone 
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

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.73
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-NroMes AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodOpe AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operación" 
     VIEW-AS FILL-IN 
     SIZE 31 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 65.43 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-CodMon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 8 BY 1.62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-NroMes AT ROW 1.19 COL 12 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-CodOpe AT ROW 1.19 COL 23.14 WIDGET-ID 34
     RADIO-CodMon AT ROW 2.15 COL 14 NO-LABEL WIDGET-ID 40
     x-mensaje AT ROW 4.08 COL 4 NO-LABEL WIDGET-ID 8
     Btn_OK AT ROW 5.23 COL 4 WIDGET-ID 26
     BtnDone AT ROW 5.23 COL 17 WIDGET-ID 56
     " Moneda:" VIEW-AS TEXT
          SIZE 7 BY .65 AT ROW 2.15 COL 7 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.86 BY 7.04
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
         WIDTH              = 73.86
         MAX-HEIGHT         = 7.04
         MAX-WIDTH          = 78.72
         VIRTUAL-HEIGHT     = 7.04
         VIRTUAL-WIDTH      = 78.72
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN
        COMBO-BOX-NroMes FILL-IN-CodOpe RADIO-CodMon.
    RUN Texto.
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

    EMPTY TEMP-TABLE Registro.
    DO ind = 1 TO NUM-ENTRIES(FILL-IN-CodOpe):
        cCodOpe = ENTRY(ind, FILL-IN-CodOpe).
        FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.CodCia = s-CodCia 
            AND cb-cmov.Periodo = s-Periodo 
            AND cb-cmov.NroMes = COMBO-BOX-NroMes
            AND cb-cmov.CodOpe = cCodOpe
            BREAK BY cb-cmov.NroAst:
            x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                "Operación: " + cb-cmov.codope + 
                " Asiento: " + cb-cmov.nroast.
            IF cb-cmov.flgest = "A" THEN DO:
                CREATE Registro.
                ASSIGN
                    Registro.CodDiv = cb-cmov.CodDiv
                    Registro.NroAst = cb-cmov.NroAst
                    Registro.CodOpe = cCodOpe
                    Registro.NomPro = "*** ANULADO ***".
                NEXT.
            END.
            FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.CodCia = cb-cmov.CodCia 
                AND cb-dmov.Periodo = cb-cmov.Periodo 
                AND cb-dmov.NroMes = cb-cmov.NroMes 
                AND cb-dmov.CodOpe = cb-cmov.CodOpe 
                AND cb-dmov.NroAst = cb-cmov.NroAst
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
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  ENABLE COMBO-BOX-NroMes FILL-IN-CodOpe RADIO-CodMon Btn_OK BtnDone 
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

  /* Code placed here will execute PRIOR to standard behavior. */

    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        FIND cb-cfgg WHERE
            cb-cfgg.CodCia = s-CodCia AND
            cb-cfgg.CODCFG = "R01" NO-LOCK NO-ERROR.
        IF AVAILABLE cb-cfgg THEN
            FILL-IN-CodOpe = cb-cfgg.codope.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cArchivo AS CHARACTER NO-UNDO.
DEFINE VARIABLE lRpta AS LOGICAL NO-UNDO.

cArchivo = 'Reg_Compras.txt'.
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

RUN Carga-Temporal.

DEFINE VARIABLE cNroSer AS CHAR NO-UNDO.
DEFINE VARIABLE cNroDoc AS CHAR NO-UNDO.
DEFINE VARIABLE cSerRef AS CHAR NO-UNDO.
DEFINE VARIABLE cNroRef AS CHAR NO-UNDO.
DEFINE VARIABLE cNroDocND AS CHARACTER NO-UNDO.

OUTPUT STREAM REPORT TO VALUE(cArchivo).
PUT STREAM REPORT UNFORMATTED
    "CMES|CNUMREGOPE|CFECCOM|CFECVENPAG|CTIPDOCCOM|CNUMSER|CEMIDUADSI|CNUMDCODFV|"
    "COSDCREFIS|CTIPDIDPRO|CNUMDIDPRO|CNOMRSOPRO|CBASIMPGRA|CIGVGRA|"
    "CBASIMPGNG|CIGVGRANGV|CBASIMPSCF|CIGVSCF|CIMPTOTNGV|CISC|COTRTRICGO|"
    "CIMPTOTCOM|CTIPCAM|CFECMOD|CTIPDOCMOD|CNUMSERMOD|CNUMDOCMOD|CCOMNODOMI|"
    "CEMIDEPDET|CCOMPGORET"
    SKIP.
FOR EACH Registro NO-LOCK BREAK BY Registro.CodOpe BY Registro.NroAst:
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
    IF LOOKUP(Registro.CodDoc, "91,98") > 0 AND Registro.Imports THEN DO:
        ASSIGN
            cNroDocND = cNroDoc
            cNroDoc   = "".
    END.
    IF Registro.CodDoc = "35" AND Registro.Imports THEN DO:
        ASSIGN
            cNroDocND = cNroRef
            cNroRef   = "".
    END.
    PUT STREAM REPORT
        COMBO-BOX-NroMes FORMAT '99' '|'
        Registro.CodOpe FORMAT 'x(3)' 
        Registro.NroAst '|'
        Registro.FchDoc FORMAT '99/99/9999' '|'
        Registro.FchVto FORMAT '99/99/9999' '|'
        Registro.CodDoc FORMAT 'x(2)' '|'
        cNroSer '|'
        Registro.AnoDUA '|'
        cNroDoc '|'
        '|'
        '6|'
        Registro.Ruc FORMAT 'x(11)' '|'
        Registro.NomPro FORMAT 'x(60)' '|'
        Registro.ImpLin[1] FORMAT '->>>>>>>>>>>9.99' '|'
        Registro.ImpLin[5] FORMAT '->>>>>>>>>>>9.99' '|'
        Registro.ImpLin[2] FORMAT '->>>>>>>>>>>9.99' '|'
        Registro.ImpLin[6] FORMAT '->>>>>>>>>>>9.99' '|'
        Registro.ImpLin[3] FORMAT '->>>>>>>>>>>9.99' '|'
        Registro.ImpLin[7] FORMAT '->>>>>>>>>>>9.99' '|'
        Registro.ImpLin[4] FORMAT '->>>>>>>>>>>9.99' '|'
        '0.00' '|'
        '0.00' '|'
        Registro.ImpLin[10] FORMAT '->>>>>>>>>>>9.99' '|'
        Registro.TpoCmb FORMAT '9.999' '|'
        Registro.FchRef FORMAT '99/99/9999' '|'
        Registro.CodRef '|'
        SUBSTRING(Registro.NroRef,1,3) '|'
        SUBSTRING(Registro.NroRef,5) '|'
        cNroDocND '|'
        Registro.FchMod FORMAT '99/99/9999' '|'
        Registro.NroTra 
        SKIP.
END. /* FOR EACH Registro... */
OUTPUT STREAM REPORT CLOSE.
MESSAGE 'Proceso Terminado'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

