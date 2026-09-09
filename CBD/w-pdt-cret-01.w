&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DETALLE NO-UNDO LIKE CCBCMOV.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.

DEF VAR s-Procesar AS LOG INIT YES.

DEF STREAM s-Texto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DETALLE

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 DETALLE.CodCli DETALLE.DocRef ~
DETALLE.dec__01 DETALLE.CodDoc DETALLE.NroDoc DETALLE.FchDoc DETALLE.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH DETALLE NO-LOCK ~
    BY DETALLE.CodCia ~
       BY DETALLE.CodCli ~
        BY DETALLE.FchRef ~
         BY DETALLE.DocRef
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH DETALLE NO-LOCK ~
    BY DETALLE.CodCia ~
       BY DETALLE.CodCli ~
        BY DETALLE.FchRef ~
         BY DETALLE.DocRef.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 DETALLE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 DETALLE


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-period BUTTON-Procesa BUTTON-Salir ~
COMBO-month BROWSE-1 BUTTON-9 
&Scoped-Define DISPLAYED-OBJECTS COMBO-period COMBO-month 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-9 
     LABEL "Eliminar" 
     SIZE 9 BY 1.12.

DEFINE BUTTON BUTTON-Genera 
     IMAGE-UP FILE "adeicon\rbuild%":U
     IMAGE-INSENSITIVE FILE "adeicon\badsmo":U
     LABEL "Button 2" 
     SIZE 11 BY 1.73 TOOLTIP "Genera Texto".

DEFINE BUTTON BUTTON-Procesa 
     IMAGE-UP FILE "img\proces":U
     LABEL "Button 1" 
     SIZE 11 BY 1.73.

DEFINE BUTTON BUTTON-Salir 
     IMAGE-UP FILE "img\exit":U
     LABEL "Button 3" 
     SIZE 8 BY 1.73 TOOLTIP "Salir".

DEFINE VARIABLE COMBO-month AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-period AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      DETALLE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      DETALLE.CodCli FORMAT "x(11)":U
      DETALLE.DocRef COLUMN-LABEL "Comprobante!de Retención" FORMAT "XXXX-XXXXXXXXXX":U
      DETALLE.dec__01 COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
      DETALLE.CodDoc COLUMN-LABEL "Documento" FORMAT "X(3)":U
      DETALLE.NroDoc COLUMN-LABEL "Comprobante!de Pago" FORMAT "XXX-XXXXXX":U
      DETALLE.FchDoc COLUMN-LABEL "Fecha!Emisión" FORMAT "99/99/99":U
      DETALLE.ImpTot FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 89.72 BY 11.15
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-period AT ROW 1.77 COL 17 COLON-ALIGNED
     BUTTON-Procesa AT ROW 1.77 COL 37
     BUTTON-Genera AT ROW 1.77 COL 49
     BUTTON-Salir AT ROW 1.77 COL 61
     COMBO-month AT ROW 2.73 COL 17 COLON-ALIGNED
     BROWSE-1 AT ROW 4.27 COL 3
     BUTTON-9 AT ROW 7.92 COL 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103.29 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DETALLE T "?" NO-UNDO INTEGRAL CCBCMOV
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PDT - CERTIFICADO DE RETENCIONES - ATE"
         HEIGHT             = 14.81
         WIDTH              = 103.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 103.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 103.29
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 COMBO-month F-Main */
/* SETTINGS FOR BUTTON BUTTON-Genera IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.DETALLE"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.DETALLE.CodCia|yes,Temp-Tables.DETALLE.CodCli|yes,Temp-Tables.DETALLE.FchRef|yes,Temp-Tables.DETALLE.DocRef|yes"
     _FldNameList[1]   = Temp-Tables.DETALLE.CodCli
     _FldNameList[2]   > Temp-Tables.DETALLE.DocRef
"DETALLE.DocRef" "Comprobante!de Retención" "XXXX-XXXXXXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.DETALLE.dec__01
"DETALLE.dec__01" "Importe" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.DETALLE.CodDoc
"DETALLE.CodDoc" "Documento" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.DETALLE.NroDoc
"DETALLE.NroDoc" "Comprobante!de Pago" "XXX-XXXXXX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.DETALLE.FchDoc
"DETALLE.FchDoc" "Fecha!Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.DETALLE.ImpTot
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PDT - CERTIFICADO DE RETENCIONES - ATE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PDT - CERTIFICADO DE RETENCIONES - ATE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Eliminar */
DO:
    RUN Elimina-Items.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Genera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Genera W-Win
ON CHOOSE OF BUTTON-Genera IN FRAME F-Main /* Button 2 */
DO:

    RUN Genera-Texto.
    BUTTON-Procesa:LOAD-IMAGE-UP('img/proces').  
    COMBO-period:SENSITIVE = YES.
    COMBO-month:SENSITIVE = YES.
    BUTTON-Genera:SENSITIVE = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Procesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Procesa W-Win
ON CHOOSE OF BUTTON-Procesa IN FRAME F-Main /* Button 1 */
DO:

    IF s-Procesar = YES THEN DO:
        ASSIGN COMBO-period COMBO-month.
        RUN Carga-Temporal.
        {&OPEN-QUERY-{&BROWSE-NAME}}
        COMBO-month:SENSITIVE = NO.
        COMBO-period:SENSITIVE = NO.
        BUTTON-Genera:SENSITIVE = YES.
        BUTTON-Procesa:LOAD-IMAGE-UP('adeicon/stop-u').
        s-Procesar = NO.
    END.
    ELSE DO:
        BUTTON-Procesa:LOAD-IMAGE-UP('img/proces').
        COMBO-period:SENSITIVE = YES.
        COMBO-month:SENSITIVE = YES.
        BUTTON-Genera:SENSITIVE = NO.
        s-Procesar = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Salir W-Win
ON CHOOSE OF BUTTON-Salir IN FRAME F-Main /* Button 3 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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

    DEFINE VARIABLE x-FchIni AS DATE NO-UNDO.
    DEFINE VARIABLE x-FchFin AS DATE NO-UNDO.
    DEFINE VARIABLE x-Mes AS INT NO-UNDO.
    DEFINE VARIABLE ImpTotRet AS DECIMAL NO-UNDO.

    FOR EACH DETALLE:
        DELETE DETALLE.
    END.

    x-Mes = LOOKUP(COMBO-month, COMBO-month:LIST-ITEMS IN FRAME {&FRAME-NAME}).  
    RUN bin/_dateif (x-Mes, COMBO-period, OUTPUT x-FchIni, OUTPUT x-FchFin).

    FOR EACH CcbCMov WHERE
        CcbCMov.codcia = s-codcia AND
        CcbCMov.codcli >= '' AND
        CcbCMov.fchref <> ? AND
        CcbCMov.docref >= "" AND
        CcbCMov.fchmov >= x-fchini AND
        CcbCMov.fchmov <= x-fchfin NO-LOCK
        BREAK BY CcbCMov.codcia
            BY CcbCMov.codcli
            BY CcbCMov.fchref
            BY CcbCMov.docref:
        IF FIRST-OF(CcbCMov.docref) THEN DO:
            ImpTotRet = 0.
            RUN proc_calc_tot(
                CcbCMov.codcli,
                CcbCMov.fchref,
                CcbCMov.docref,
                OUTPUT ImpTotRet).
        END.
        CREATE DETALLE.
        BUFFER-COPY CcbCMov TO DETALLE
        ASSIGN DETALLE.dec__01 = ImpTotRet.
  END.        

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Elimina-Items W-Win 
PROCEDURE Elimina-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i AS INT.

    DO WITH FRAME {&FRAME-NAME}:
        DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
                FIND CURRENT DETALLE EXCLUSIVE-LOCK.
                DELETE DETALLE.
            END.
        END.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
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
  DISPLAY COMBO-period COMBO-month 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-period BUTTON-Procesa BUTTON-Salir COMBO-month BROWSE-1 BUTTON-9 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Texto W-Win 
PROCEDURE Genera-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cFile-Name AS CHAR FORMAT 'x(30)' NO-UNDO.
    DEFINE VARIABLE iMonth AS INT NO-UNDO.
    DEFINE VARIABLE cString AS CHAR FORMAT 'x(100)' NO-UNDO.
    DEFINE VARIABLE lAnswer AS LOG INIT NO NO-UNDO.

    FIND GN-CIAS WHERE GN-CIAS.codcia = s-codcia NO-LOCK.

    iMonth = LOOKUP(COMBO-month, COMBO-month:LIST-ITEMS IN FRAME {&FRAME-NAME}).  
    cFile-Name = '0621' + 
        STRING(GN-CIAS.Libre-c[1], 'x(11)') +
        STRING(COMBO-period, '9999') + 
        STRING(iMonth, '99') + 'R.TXT'.

    SYSTEM-DIALOG GET-FILE cFile-Name
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION '.TXT'
        INITIAL-DIR 'c:\tmp'
        SAVE-AS
        TITLE 'Guardar como...'
        USE-FILENAME
        UPDATE lAnswer.
    IF lAnswer = NO THEN RETURN.

    /* armamos la cadena de caracteres */
    OUTPUT STREAM s-Texto TO VALUE(cFile-Name).
    GET FIRST {&BROWSE-NAME}.
    REPEAT WHILE AVAILABLE DETALLE:

        FIND gn-clie WHERE
            gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = DETALLE.codcli
            NO-LOCK NO-ERROR.
        cString =
            TRIM(gn-clie.Ruc) + '|' +
            TRIM(SUBSTRING(DETALLE.docref, 1, 4)) + '|' +
            TRIM(SUBSTRING(DETALLE.docref, 5)) + '|' +
            STRING(DETALLE.fchref, '99/99/9999') + '|' +
            TRIM(STRING(DETALLE.dec__01, '->>>>>>>>9.99')) + '|'.
        FIND Facdocum WHERE
            Facdocum.codcia = DETALLE.codcia AND
            Facdocum.coddoc = DETALLE.coddoc NO-LOCK.
        cString = cString +
            TRIM(FacDocum.CodCbd) + '|' +
            TRIM(SUBSTRING(DETALLE.nrodoc, 1, 3)) + '|' +
            TRIM(SUBSTRING(DETALLE.nrodoc, 4)) + '|' +
            STRING(DETALLE.fchdoc, '99/99/9999') + '|' +
            TRIM(STRING(DETALLE.ImpTot, '->>>>>>>>9.99')) + '|'.
        DISPLAY STREAM s-Texto
            cString
            WITH STREAM-IO NO-LABELS NO-BOX WIDTH 200.
        GET NEXT {&BROWSE-NAME}.

    END.
    OUTPUT STREAM s-Texto CLOSE.

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
    COMBO-period:DELETE(1).
    FOR EACH Cb-Peri WHERE Cb-peri.codcia = s-codcia NO-LOCK:
        COMBO-period:ADD-LAST(STRING(CB-PERI.Periodo, '9999')).
    END.
    COMBO-period = s-Periodo.
    COMBO-month = ENTRY(s-nromes, COMBO-month:LIST-ITEMS).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_calc_tot W-Win 
PROCEDURE proc_calc_tot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_codcli LIKE CcbCMov.codcli NO-UNDO.
    DEFINE INPUT PARAMETER para_fchref LIKE CcbCMov.fchref NO-UNDO.
    DEFINE INPUT PARAMETER para_docref LIKE CcbCMov.docref NO-UNDO.
    DEFINE OUTPUT PARAMETER para_total_ret AS DECIMAL NO-UNDO.

    DEFINE BUFFER b_ret FOR CcbCMov.

    FOR EACH b_ret WHERE
        b_ret.codcia = s-codcia AND
        b_ret.codcli = para_codcli AND
        b_ret.fchref = para_fchref AND
        b_ret.docref = para_docref NO-LOCK:
        para_total_ret = para_total_ret + b_ret.impref.
    END.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "DETALLE"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

