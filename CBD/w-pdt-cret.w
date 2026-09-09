&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DETALLE NO-UNDO LIKE INTEGRAL.CcbCDocu
       INDEX LLAVE01 AS PRIMARY CodCia CodDoc NroDoc.


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
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.

DEF VAR s-Procesar AS LOG INIT YES.

DEF STREAM s-Texto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DETALLE CcbCDocu

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 DETALLE.CodCli DETALLE.NroDoc ~
DETALLE.ImpTot CcbCDocu.CodDoc CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH DETALLE NO-LOCK, ~
      EACH CcbCDocu WHERE CcbCDocu.CodCia = DETALLE.CodCia ~
  AND CcbCDocu.CodDoc = DETALLE.CodRef ~
  AND CcbCDocu.NroDoc = DETALLE.NroRef NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 DETALLE CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 DETALLE


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 x-Periodo x-Meses BUTTON-Procesa ~
BUTTON-Salir BUTTON-9 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-Meses 

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
     SIZE 10 BY 1.12.

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

DEFINE VARIABLE x-Meses AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 8 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      DETALLE, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      DETALLE.CodCli
      DETALLE.NroDoc COLUMN-LABEL "Comprobante!de Retencion" FORMAT "XXXX-XXXXXXXX"
      DETALLE.ImpTot COLUMN-LABEL "Importe"
      CcbCDocu.CodDoc COLUMN-LABEL "Documento"
      CcbCDocu.NroDoc COLUMN-LABEL "Comprobante!de Pago" FORMAT "XXX-XXXXXX"
      CcbCDocu.FchDoc COLUMN-LABEL "Fecha de!Emision"
      CcbCDocu.ImpTot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 89 BY 10.77
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-1 AT ROW 4.27 COL 3
     x-Periodo AT ROW 1.77 COL 17 COLON-ALIGNED
     x-Meses AT ROW 2.73 COL 17 COLON-ALIGNED
     BUTTON-Procesa AT ROW 1.77 COL 37
     BUTTON-Genera AT ROW 1.77 COL 49
     BUTTON-Salir AT ROW 1.77 COL 61
     BUTTON-9 AT ROW 7.92 COL 93
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
      TABLE: DETALLE T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          INDEX LLAVE01 AS PRIMARY CodCia CodDoc NroDoc
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PDT - CERTIFICADO DE RETENCIONES"
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB BROWSE-1 1 F-Main */
/* SETTINGS FOR BUTTON BUTTON-Genera IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.DETALLE,INTEGRAL.CcbCDocu WHERE Temp-Tables.DETALLE ..."
     _Options          = "NO-LOCK"
     _JoinCode[2]      = "INTEGRAL.CcbCDocu.CodCia = Temp-Tables.DETALLE.CodCia
  AND INTEGRAL.CcbCDocu.CodDoc = Temp-Tables.DETALLE.CodRef
  AND INTEGRAL.CcbCDocu.NroDoc = Temp-Tables.DETALLE.NroRef"
     _FldNameList[1]   = Temp-Tables.DETALLE.CodCli
     _FldNameList[2]   > Temp-Tables.DETALLE.NroDoc
"INTEGRAL.DETALLE.NroDoc" "Comprobante!de Retencion" "XXXX-XXXXXXXX" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > Temp-Tables.DETALLE.ImpTot
"INTEGRAL.DETALLE.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[4]   > INTEGRAL.CcbCDocu.CodDoc
"INTEGRAL.CcbCDocu.CodDoc" "Documento" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > INTEGRAL.CcbCDocu.NroDoc
"INTEGRAL.CcbCDocu.NroDoc" "Comprobante!de Pago" "XXX-XXXXXX" "character" ? ? ? ? ? ? no ?
     _FldNameList[6]   > INTEGRAL.CcbCDocu.FchDoc
"INTEGRAL.CcbCDocu.FchDoc" "Fecha de!Emision" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[7]   = INTEGRAL.CcbCDocu.ImpTot
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PDT - CERTIFICADO DE RETENCIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PDT - CERTIFICADO DE RETENCIONES */
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
  x-Meses:SENSITIVE = YES.
  x-Periodo:SENSITIVE = YES.
  BUTTON-Genera:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Procesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Procesa W-Win
ON CHOOSE OF BUTTON-Procesa IN FRAME F-Main /* Button 1 */
DO:
  IF s-Procesar = YES THEN DO:
    ASSIGN
      x-Meses x-Periodo.
    RUN Carga-Temporal.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    x-Meses:SENSITIVE = NO.
    x-Periodo:SENSITIVE = NO.
    BUTTON-Genera:SENSITIVE = YES.
    BUTTON-Procesa:LOAD-IMAGE-UP('adeicon/stop-u').
    s-Procesar = NO.
  END.
  ELSE DO:
    BUTTON-Procesa:LOAD-IMAGE-UP('img/proces').
    x-Meses:SENSITIVE = YES.
    x-Periodo:SENSITIVE = YES.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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
  DEF VAR x-FchIni AS DATE NO-UNDO.
  DEF VAR x-FchFin AS DATE NO-UNDO.
  DEF VAR x-Mes AS INT.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  x-Mes = LOOKUP(x-Meses, x-Meses:LIST-ITEMS IN FRAME {&FRAME-NAME}).  
  RUN bin/_dateif (x-Mes, x-Periodo, OUTPUT x-FchIni, OUTPUT x-FchFin).
  FOR EACH Ccbdcaja WHERE Ccbdcaja.codcia = 001
        AND Ccbdcaja.coddoc = 'RET'
        AND Ccbdcaja.fchdoc >= x-fchini
        AND Ccbdcaja.fchdoc <= x-fchfin NO-LOCK,
        FIRST Ccbcdocu WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
            AND Ccbcdocu.coddoc = Ccbdcaja.coddoc
            AND Ccbcdocu.nrodoc = Ccbdcaja.nrodoc NO-LOCK:
    CREATE DETALLE.
    BUFFER-COPY Ccbcdocu TO DETALLE
        ASSIGN
            DETALLE.codref = Ccbdcaja.codref
            DETALLE.nroref = Ccbdcaja.nroref.
            /*DETALLE.imptot = Ccbdcaja.imptot.            */
  END.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY x-Periodo x-Meses 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-1 x-Periodo x-Meses BUTTON-Procesa BUTTON-Salir BUTTON-9 
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
  DEF VAR x-Nombre AS CHAR FORMAT 'x(30)'.
  DEF VAR x-Mes AS INT.
  DEF VAR x-Cadena AS CHAR FORMAT 'x(100)'.
  DEF VAR x-Rpta AS LOG INIT NO.
  DEF VAR x-ImpRet AS DEC.
  DEF VAR x-ImpDoc AS DEC.
  
  FIND GN-CIAS WHERE GN-CIAS.codcia = s-codcia NO-LOCK.
  
  x-Mes = LOOKUP(x-Meses, x-Meses:LIST-ITEMS IN FRAME {&FRAME-NAME}).  
  x-Nombre = '0621' + 
            STRING(GN-CIAS.Libre-c[1], 'x(11)') +
            STRING(x-Periodo, '9999') + 
            STRING(x-Mes, '99') + 'R.TXT'.

  SYSTEM-DIALOG GET-FILE x-Nombre    ASK-OVERWRITE 
    CREATE-TEST-FILE    DEFAULT-EXTENSION '.TXT'    INITIAL-DIR 'c:\tmp'    SAVE-AS    TITLE 'Guardar como...'
    USE-FILENAME
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.
  
  /* armamos la cadena de caracteres */
  OUTPUT STREAM s-Texto TO VALUE(x-Nombre).
  GET FIRST {&BROWSE-NAME}.
  REPEAT WHILE AVAILABLE DETALLE:
    /* Importes en soles */
    ASSIGN
        x-ImpRet = DETALLE.ImpTot
        x-ImpDoc = Ccbcdocu.ImpTot.
    IF DETALLE.CodMon = 2 THEN x-ImpRet = x-ImpRet * DETALLE.TpoCmb.
    IF Ccbcdocu.CodMon = 2 THEN x-ImpDoc = x-ImpDoc * Ccbcdocu.TpoCmb.
    x-Cadena = TRIM(ccbcdocu.ruccli) + '|' +
               TRIM(SUBSTRING(DETALLE.nrodoc, 1, 4)) + '|' +
               TRIM(SUBSTRING(DETALLE.nrodoc, 5)) + '|' +
               STRING(DETALLE.fchdoc, '99/99/9999') + '|' +
               TRIM(STRING(x-ImpRet, '>>>>>>>>9.99')) + '|'.
    FIND Facdocum WHERE Facdocum.codcia = ccbcdocu.codcia
        AND Facdocum.coddoc = ccbcdocu.coddoc NO-LOCK.
    x-Cadena = x-Cadena +
                TRIM(FacDocum.CodCbd) + '|' +
                TRIM(SUBSTRING(Ccbcdocu.nrodoc, 1, 3)) + '|' +
                TRIM(SUBSTRING(Ccbcdocu.nrodoc, 4)) + '|' +
                STRING(Ccbcdocu.fchdoc, '99/99/9999') + '|' +
                TRIM(STRING(x-ImpDoc, '>>>>>>>>9.99')) + '|'.
    DISPLAY STREAM s-Texto x-Cadena WITH STREAM-IO NO-LABELS NO-BOX WIDTH 200.
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
    x-Periodo:DELETE(1).
    FOR EACH Cb-Peri WHERE Cb-peri.codcia = s-codcia NO-LOCK:
        x-Periodo:ADD-LAST(STRING(CB-PERI.Periodo, '9999')).
    END.
    x-Periodo = s-Periodo.
    x-Meses = ENTRY(s-nromes, x-Meses:LIST-ITEMS).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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
  {src/adm/template/snd-list.i "CcbCDocu"}

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


