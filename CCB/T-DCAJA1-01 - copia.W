&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEFINE SHARED VAR s-amortiza-letras AS LOG INIT NO NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.
DEFINE SHARED VARIABLE s-coddiv AS CHAR.
DEFINE SHARED VARIABLE s-tipo AS CHARACTER.
DEFINE SHARED VARIABLE lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE s-codcli LIKE gn-clie.codcli.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-FlgSit AS CHAR.

DEFINE VARIABLE L-CODREF AS CHAR NO-UNDO.
DEFINE VARIABLE L-NROREF AS CHAR NO-UNDO.

DEFINE SHARED TEMP-TABLE t-ccbdcaja LIKE ccbdcaja.

DEFINE BUFFER DCAJA FOR t-ccbdcaja.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CcbDCaja CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-CcbDCaja.CodRef T-CcbDCaja.NroRef CcbCDocu.FchDoc CcbCDocu.FchVto T-CcbDCaja.CodDoc CcbCDocu.SdoAct T-CcbDCaja.ImpTot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-CcbDCaja.CodRef ~
T-CcbDCaja.NroRef ~
T-CcbDCaja.ImpTot   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-CcbDCaja
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-CcbDCaja
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH T-CcbDCaja NO-LOCK, ~
             FIRST CcbCDocu WHERE CcbCDocu.CodCia = T-CcbDCaja.CodCia       AND CcbCDocu.CodCli = T-CcbDCaja.CodCli       AND CcbCDocu.CodDoc = T-CcbDCaja.CodRef       AND CcbCDocu.NroDoc = T-CcbDCaja.NroRef NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH T-CcbDCaja NO-LOCK, ~
             FIRST CcbCDocu WHERE CcbCDocu.CodCia = T-CcbDCaja.CodCia       AND CcbCDocu.CodCli = T-CcbDCaja.CodCli       AND CcbCDocu.CodDoc = T-CcbDCaja.CodRef       AND CcbCDocu.NroDoc = T-CcbDCaja.NroRef NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table T-CcbDCaja CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-CcbDCaja
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-10 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-TotMn FILL-IN-TotMe FILL-IN-Mora 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "img\print":U
     LABEL "Button 10" 
     SIZE 4 BY .96 TOOLTIP "Sustento de Mora".

DEFINE VARIABLE FILL-IN-Mora AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe Mora" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .81
     BGCOLOR 15 FGCOLOR 1 FONT 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotMe AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Total US$" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotMn AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Total S/." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-CcbDCaja, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      T-CcbDCaja.CodRef COLUMN-LABEL  "Tipo  "
      T-CcbDCaja.NroRef COLUMN-LABEL "  Documento  " FORMAT "x(12)"
      CcbCDocu.FchDoc   COLUMN-LABEL "    Fecha    !    Emisión    "
      CcbCDocu.FchVto   COLUMN-LABEL "    Fecha    ! Vencimiento"
      T-CcbDCaja.CodDoc COLUMN-LABEL "Moneda" FORMAT "x(3)"
      CcbCDocu.SdoAct   COLUMN-LABEL "Saldo ! Actual"
      T-CcbDCaja.ImpTot COLUMN-LABEL "Importe ! a Pagar"
  ENABLE
      T-CcbDCaja.CodRef
      T-CcbDCaja.NroRef
      T-CcbDCaja.ImpTot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 66 BY 6.5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-TotMn AT ROW 7.73 COL 33 COLON-ALIGNED
     FILL-IN-TotMe AT ROW 7.73 COL 51.57 COLON-ALIGNED
     FILL-IN-Mora AT ROW 8.69 COL 33 COLON-ALIGNED
     BUTTON-10 AT ROW 8.69 COL 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 8.88
         WIDTH              = 66.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Mora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotMe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotMn IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
 OPEN QUERY {&SELF-NAME} FOR EACH T-CcbDCaja NO-LOCK,
      FIRST CcbCDocu WHERE CcbCDocu.CodCia = T-CcbDCaja.CodCia
      AND CcbCDocu.CodCli = T-CcbDCaja.CodCli
      AND CcbCDocu.CodDoc = T-CcbDCaja.CodRef
      AND CcbCDocu.NroDoc = T-CcbDCaja.NroRef NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:

  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 B-table-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Button 10 */
DO:

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   
       
    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn2}.
        RUN Formato.
        PAGE STREAM REPORT .
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  TRIGGERS DE CONTROL  *************************** */

ON "RETURN":U OF T-CcbDCaja.CodRef, T-CcbDCaja.NroRef, T-CcbDCaja.ImpTot DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON LEAVE OF T-CcbDCaja.CodRef DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    T-CcbDCaja.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = CAPS(SELF:SCREEN-VALUE).
    FIND FIRST facdocum WHERE
        FacDocum.CodCia = s-codcia AND
        FacDocum.CodDoc = T-CcbDCaja.CodRef:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE facdocum OR NOT FacDocum.TpoDoc THEN DO:
        MESSAGE
            "Solo se permiten documentos de cargo"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF T-CcbDCaja.NroRef DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    T-CcbDCaja.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SELF:SCREEN-VALUE.
    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddoc = t-ccbdcaja.codref:SCREEN-VALUE AND
        ccbcdocu.nrodoc = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        ASSIGN
            ccbcdocu.fchdoc:SCREEN-VALUE = STRING(ccbcdocu.fchdoc)
            ccbcdocu.fchvto:SCREEN-VALUE = STRING(ccbcdocu.fchvto)
            t-ccbdcaja.coddoc:SCREEN-VALUE = (IF ccbcdocu.codmon = 1 THEN "S/." ELSE "US$")
            ccbcdocu.sdoact:SCREEN-VALUE = STRING(ccbcdocu.sdoact)
            t-ccbdcaja.imptot:SCREEN-VALUE = STRING(ccbcdocu.sdoact).
        /* LETRAS N BANCO */
        IF Ccbcdocu.coddoc = 'LET' AND Ccbcdocu.flgubi <> 'C' THEN DO:
            MESSAGE 'La letra NO está en CARTERA' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        ASSIGN
            ccbcdocu.fchdoc:SCREEN-VALUE = ""
            ccbcdocu.fchvto:SCREEN-VALUE = ""
            t-ccbdcaja.coddoc:SCREEN-VALUE = ""
            ccbcdocu.sdoact:SCREEN-VALUE = ""
            t-ccbdcaja.imptot:SCREEN-VALUE = "".
        MESSAGE
            "El documento de referencia no es un documento por cobrar"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.            
    END.      
END.

/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Mora B-table-Win 
PROCEDURE Calcula-Mora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.
    ASSIGN FILL-IN-Mora = 0.
    FOR EACH T-ccbdcaja:
        FIND ccbcdocu WHERE
            ccbcdocu.codcia = s-codcia AND
            ccbcdocu.coddoc = t-ccbdcaja.codref AND
            ccbcdocu.nrodoc = t-ccbdcaja.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu AND
            ccbcdocu.fchvto < TODAY THEN
            FILL-IN-Mora = FILL-IN-Mora + 
                t-ccbdcaja.imptot * (TODAY - ccbcdocu.fchvto) *
                FacCfgGn.PorMora / 100.
    END.
    DISPLAY FILL-IN-Mora WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Totales B-table-Win 
PROCEDURE Calcula-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-SdoNac AS DEC NO-UNDO.
    DEF VAR x-SdoUsa AS DEC NO-UNDO.

    ASSIGN
        FILL-IN-TotMe = 0
        FILL-IN-TotMn = 0.
    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
    GET FIRST {&BROWSE-NAME}.
    REPEAT WHILE AVAILABLE T-CcbDCaja:
        IF AVAILABLE Gn-Tccja THEN DO:    
            IF CcbCDocu.codmon = 1 THEN
                ASSIGN
                    X-SdoNac = T-CcbDCaja.imptot
                    X-SdoUsa = ROUND(T-CcbDCaja.imptot /
                        ROUND(Gn-Tccja.Compra, 3), 2).
            ELSE
                ASSIGN
                    X-SdoUsa = T-CcbDCaja.imptot
                    X-SdoNac = ROUND(T-CcbDCaja.imptot *
                    ROUND(Gn-Tccja.Venta, 3), 2).
        END.
        ELSE DO:
            IF FacCPedm.codmon = 1 THEN
                ASSIGN
                    X-SdoNac = T-CcbDCaja.imptot
                    X-SdoUsa = 0.
            ELSE
                ASSIGN
                    X-SdoUsa = T-CcbDCaja.imptot
                    X-SdoNac = 0.
        END.
        ASSIGN
            FILL-IN-TotMn = FILL-IN-TotMn + x-SdoNac
            FILL-IN-TotMe = FILL-IN-TotMe + x-SdoUsa.
        GET NEXT {&BROWSE-NAME}.
    END.
    DISPLAY FILL-IN-TotMn FILL-IN-TotMe WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato B-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND GN-CLIE WHERE
        gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = s-codcli
        NO-LOCK NO-ERROR.

    DEFINE FRAME F-REPORTE
        T-CcbDCaja.CodRef COLUMN-LABEL "Tipo"
        T-CcbDCaja.NroRef COLUMN-LABEL "Documento " FORMAT "x(10)"
        CcbCDocu.FchDoc   COLUMN-LABEL "    Fecha    !    Emisión    "
        CcbCDocu.FchVto   COLUMN-LABEL "    Fecha    ! Vencimiento"
        T-CcbDCaja.CodDoc COLUMN-LABEL "Moneda" FORMAT "x(3)"
        CcbCDocu.SdoAct   COLUMN-LABEL "Saldo ! Actual"
        T-CcbDCaja.ImpTot COLUMN-LABEL "Importe ! a Pagar"
        WITH WIDTH 120 NO-BOX STREAM-IO DOWN.

    DEFINE FRAME F-HEADER 
        HEADER
        S-NOMCIA AT 6 FORMAT "X(50)" SKIP
        "SUSTENTO DE LA MORA" AT 20  SKIP(1)
        "Fecha:" AT 60 TODAY SKIP
        "Cliente:" s-codcli gn-clie.nomcli FORMAT 'x(100)' SKIP
        "   Mora:" FILL-IN-Mora SKIP(1)
        WITH PAGE-TOP WIDTH 120 NO-LABELS NO-BOX STREAM-IO DOWN.

    FOR EACH T-CcbDCaja NO-LOCK,
        FIRST CcbCDocu WHERE
        CcbCDocu.CodCia = T-CcbDCaja.CodCia AND
        CcbCDocu.CodCli = T-CcbDCaja.CodCli AND
        CcbCDocu.CodDoc = T-CcbDCaja.CodRef AND
        CcbCDocu.NroDoc = T-CcbDCaja.NroRef NO-LOCK:
        VIEW STREAM REPORT FRAME F-HEADER.
        DISPLAY STREAM REPORT
            T-CcbDCaja.CodRef 
            T-CcbDCaja.NroRef 
            CcbCDocu.FchDoc   
            CcbCDocu.FchVto   
            T-CcbDCaja.CodDoc 
            CcbCDocu.SdoAct   
            T-CcbDCaja.ImpTot 
            WITH FRAME F-REPORTE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Procesa-Handle IN lh_handle ('Disable').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    ASSIGN
        T-CcbDCaja.CodCia = S-CODCIA
        T-CcbDCaja.CodCli = S-CodCli
        T-CcbDCaja.codref = L-CODREF
        T-CcbDCaja.nroref = L-NROREF.

    FIND ccbcdocu WHERE
        ccbcdocu.codcia = s-codcia AND
        ccbcdocu.codcli = s-codcli AND
        ccbcdocu.coddoc = t-ccbdcaja.codref AND
        ccbcdocu.nrodoc = t-ccbdcaja.nroref
        NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        ASSIGN
            T-CcbDCaja.CodCli = ccbcdocu.codcli
            T-CcbDCaja.CodMon = ccbcdocu.codmon
            T-CcbDCaja.CodDoc = IF ccbcdocu.codmon = 1 THEN "S/." ELSE "US$".
    END.

    RUN Calcula-Totales.
    RUN Calcula-Mora.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Procesa-Handle IN lh_handle ('Enable').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN Calcula-Totales.
  RUN Calcula-Mora.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Calcula-Totales.
  RUN Calcula-Mora.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

    CASE HANDLE-CAMPO:name:
        WHEN "CodRef" THEN 
            ASSIGN
                input-var-1 = "CARGO"
                input-var-2 = ""
                input-var-3 = "".
        WHEN "NroRef" THEN 
            ASSIGN
                input-var-1 = t-ccbdcaja.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                input-var-2 = s-codcli
                input-var-3 = "P".
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-CcbDCaja"}
  {src/adm/template/snd-list.i "CcbCDocu"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
    /* consistencia del documento */

    L-CODREF = t-ccbdcaja.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    L-NROREF = t-ccbdcaja.nroref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

    FIND FIRST facdocum WHERE
        FacDocum.CodCia = s-codcia AND
        FacDocum.CodDoc = L-CODREF AND
        FacDocum.TpoDoc = YES
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE facdocum THEN DO:
        MESSAGE
            "El documento de referencia no es un documento cargo"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.codref.
        RETURN "ADM-ERROR".
    END.

    DEF VAR x-CodDoc AS CHAR INIT "FAC,BOL,N/D,CHQ,DCO,LET" NO-UNDO.

    IF LOOKUP(l-CodRef, x-CodDoc) = 0 THEN DO:
        MESSAGE 'Documento NO válido' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.codref.
        RETURN "ADM-ERROR".
    END.

    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddoc = L-CODREF AND
        ccbcdocu.nrodoc = L-NROREF NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcdocu THEN DO:
        MESSAGE
            "Documento de referencia no registrado"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    IF ccbcdocu.codcli NE s-codcli  THEN DO:
        MESSAGE
            "Este documento no pertenece al cliente"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    IF ccbcdocu.flgest NE "P" THEN DO:
        MESSAGE
            "El documento de referencia no esta pendiente de pago"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    /* *********************************************** */
    /* RHC 11/03/2016 Restriccione para tiendas utilex */
/*     FIND gn-divi WHERE gn-divi.codcia = ccbcdocu.codcia                      */
/*         AND gn-divi.coddiv = ccbcdocu.coddiv                                 */
/*         NO-LOCK.                                                             */
/*     IF GN-DIVI.CanalVenta = "MIN"                                            */
/*         AND ccbcdocu.coddiv <> s-coddiv                                      */
/*         THEN DO:                                                             */
/*         MESSAGE 'El documento ha sido registrado en las tiendas UTILEX' SKIP */
/*             'División:' Ccbcdocu.coddiv VIEW-AS ALERT-BOX ERROR.             */
/*         APPLY "ENTRY":U TO t-ccbdcaja.nroref.                                */
/*         RETURN "ADM-ERROR".                                                  */
/*     END.                                                                     */
    /* *********************************************** */
    IF DECIMAL(t-ccbdcaja.imptot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0
        THEN DO:
        MESSAGE 'Importe NO puede ser cero' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO t-ccbdcaja.imptot.
        RETURN 'ADM-ERROR'.
    END.

    /* LETRAS N BANCO */
    IF Ccbcdocu.coddoc = 'LET' AND Ccbcdocu.flgubi <> 'C' THEN DO:
        MESSAGE 'La letra NO está en CARTERA' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    /* documento con canje de letras pendiente de aprobar */
    IF Ccbcdocu.flgsit = 'X' THEN DO:
        MESSAGE 'Documento con canje por letra pendiente de aprobar' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    /* ************************************************** */
    IF DECIMAL(t-ccbdcaja.imptot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) >
        ccbcdocu.sdoact THEN DO:
        MESSAGE
            "El importe a pagar es mayor que la deuda"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.imptot.
        RETURN "ADM-ERROR".
    END.
    FIND FIRST DCAJA WHERE
        DCaja.codref = L-CODREF AND 
        DCaja.nroref = L-NROREF NO-LOCK NO-ERROR.
    IF AVAILABLE DCAJA AND ROWID(DCAJA) <> ROWID(t-ccbdcaja) THEN DO:
        MESSAGE
            "Documento repetido"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    /* Ic - 22Ene2018, correo del 19Ene2018, autorizacion de Julissa Calderon, dejar sin efecto 
    /* RHC 13/07/2017 */
    IF LOOKUP(Ccbcdocu.coddoc,"FAC,BOL") > 0 AND Ccbcdocu.tpofac = "V" THEN DO:
        MESSAGE 'Esta es una factura por VENTA ANTICIPADA' SKIP
            'Solo se puede canjear por una letra' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.codref.
        RETURN "ADM-ERROR".
    END.
    */

    /*  Ic - 10Dic2019
        Ticket 68704, 
                Daniel:
                    Lo que sí puede hacer en estos momentos es cerrar la funcionalidad en el sistema progress:
                    * Una nota de crédito no puede ser aplicada a una letra        
    */
    DEFINE VAR x-hay-letras AS LOG INIT NO.
    DEFINE VAR x-hay-nc AS LOG INIT NO.

    RECORRIDO:
    FOR EACH DCAJA NO-LOCK:
        IF DCAJA.codref = 'LET' THEN x-hay-letras = YES.
        IF (DCAJA.codref = 'N/C' OR DCAJA.codref = 'NCI') THEN x-hay-nc = YES.
        IF x-hay-letras = YES AND x-hay-nc = YES THEN DO:
            LEAVE RECORRIDO.
        END.
    END.
    IF x-hay-letras = YES AND x-hay-nc = YES THEN DO:
        MESSAGE "En una liquidacion donde se esta cancelando LETRAS, " SKIP 
                "no esta permitido la aplicacion de NOTAS DE CREDITO"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO t-ccbdcaja.codref.
        RETURN "ADM-ERROR".
    END.


    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE T-CcbDCaja 
    OR T-CcbDCaja.CodRef = "N/C"
    THEN RETURN "ADM-ERROR".
RUN Procesa-Handle IN lh_handle ('Disable').
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

