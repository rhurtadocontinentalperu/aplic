&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED TEMP-TABLE RMOV LIKE cb-dmov.
DEFINE SHARED TEMP-TABLE VMOV LIKE cb-cmov.
DEFINE BUFFER CMOV FOR cb-cmov.

DEFINE {&NEW} SHARED VAR S-CODCIA AS INTEGER.
DEFINE {&NEW} SHARED VAR S-PERIODO AS INTEGER.
DEFINE {&NEW} SHARED VAR S-NROMES  AS INTEGER.
DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER.
DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
     
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0 NO-UNDO.
/* DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0 NO-UNDO. */

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.
/* IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia. */

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
      NO-LOCK  NO-ERROR.

/* VARIABLES DE IMPRESION */
DEFINE STREAM REPORT.
DEFINE var X-PAG AS CHAR FORMAT "999" NO-UNDO. 
DEFINE VARIABLE X-NomCta   AS CHAR LABEL "Descripcion" NO-UNDO.
DEFINE VARIABLE X-Mon      AS CHAR NO-UNDO.
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)" NO-UNDO.
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)" NO-UNDO.
DEFINE VARIABLE x-codmon   AS CHAR FORMAT "X(3)" NO-UNDO.
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-TotDeb   AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)" NO-UNDO.
DEFINE VARIABLE x-TotHab   AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)" NO-UNDO.
DEFINE VARIABLE x-TotGen   AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)" NO-UNDO.
DEFINE VARIABLE x-nrocta   AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE x-NomOpe   AS CHAR FORMAT "X(30)" NO-UNDO.

RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9,999" ).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cb-cmov
&Scoped-define FIRST-EXTERNAL-TABLE cb-cmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-cmov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 
&Scoped-Define DISPLAYED-FIELDS cb-cmov.NroAst cb-cmov.FchAst ~
cb-cmov.CodDiv cb-cmov.TpoCmb cb-cmov.GloAst cb-cmov.CodMon 
&Scoped-define DISPLAYED-TABLES cb-cmov
&Scoped-define FIRST-DISPLAYED-TABLE cb-cmov
&Scoped-Define DISPLAYED-OBJECTS F-DesDiv 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.29 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.86 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-cmov.NroAst AT ROW 1.15 COL 8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
     cb-cmov.FchAst AT ROW 1.15 COL 57.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .69
     cb-cmov.CodDiv AT ROW 1.85 COL 8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.72 BY .69
     F-DesDiv AT ROW 1.85 COL 17.29 COLON-ALIGNED NO-LABEL
     cb-cmov.TpoCmb AT ROW 1.85 COL 57.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .69
     cb-cmov.GloAst AT ROW 2.54 COL 10 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 35.57 BY .69
     cb-cmov.CodMon AT ROW 2.54 COL 59.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.86 BY .73
     "Glosa :" VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 2.65 COL 4.72
     "Moneda" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 2.65 COL 51.72
     RECT-7 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.cb-cmov
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 2.42
         WIDTH              = 71.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cb-cmov.CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET cb-cmov.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.FchAst IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.GloAst IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL                                          */
/* SETTINGS FOR FILL-IN cb-cmov.NroAst IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "cb-cmov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-cmov"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Detalle-Cuenta V-table-Win 
PROCEDURE Imprime-Detalle-Cuenta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND cb-oper WHERE cb-oper.CodCia = 0 AND
     cb-oper.Codope = cb-cmov.codope NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-oper THEN
   FIND cb-oper WHERE cb-oper.CodCia = cb-cmov.codcia AND
        cb-oper.Codope = cb-cmov.codope NO-LOCK NO-ERROR.

DEFINE BUFFER DMOV FOR cb-dmov.

IF cb-cmov.codmon = 1 THEN  x-Mon = "S/.".
ELSE x-Mon = "US$".

x-NomOpe = "                              " + cb-oper.Nomope.
x-NomOpe = SUBSTRING(x-NomOpe,INTEGER((30 + LENGTH(cb-oper.Nomope, "CHARACTER")) / 2 )).

DEFINE FRAME f-cab
  cb-dmov.codcta 
  cb-dmov.codDoc AT 11
  cb-dmov.NroDoc AT 16 FORMAT "X(20)"
  X-NomCta       FORMAT "X(40)" AT 37
  x-CodMon       AT 78
  cb-dmov.ImpMn2 AT 82 FORMAT ">>,>>>,>>9.99" 
  x-debe         AT 97
  x-haber        AT 117 
  HEADER
       empresas.nomcia
       x-NomOpe AT  50
       "FECHA : " TO 119 cb-cmov.fchast FORMAT "99/99/9999" SKIP 
       "ASIENTO No: " AT 55 cb-cmov.codope "-" cb-cmov.nroast 
                "HORA : " TO 119 STRING(TIME, "HH:MM AM") SKIP
       "MONEDA : " TO 119 x-Mon SKIP
       "Glosa     : " cb-cmov.GloAst FORMAT "X(80)" VIEW-AS TEXT 
       "TIPO CAMBIO : " TO 119 cb-cmov.TpoCmb FORMAT ">,>>9.9999" SKIP(1)
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP
       " Cuenta   Doc  Numero               Fecha Vcto Descripcion                                               Cargos            Abonos " SKIP
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 130 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.    

/* OUTPUT STREAM report TO C:\TMP\PRUEBA1.PRN PAGED PAGE-SIZE 33.    */
OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 33.   
PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33) .
 
PUT STREAM report CONTROL "~033x" NULL "~017~033P".

FOR EACH DMOV NO-LOCK WHERE DMOV.codcia = cb-cmov.codcia
                AND DMOV.periodo = cb-cmov.periodo
                AND DMOV.nromes  = cb-cmov.NroMes
                AND DMOV.codope  = cb-cmov.codope
                AND DMOV.nroast  = cb-cmov.nroast
                AND DMOV.tpomov
    BY DMOV.nroast 
    BY NOT DMOV.tpomov   ON ERROR UNDO, LEAVE:
    IF DMOV.tpoitm = "A" THEN NEXT.
    X-TotDeb = 0.
    X-TotHab = 0.
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = cb-cmov.codcia
                    AND cb-dmov.periodo = cb-cmov.periodo
                    AND cb-dmov.nromes  = cb-cmov.NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BY cb-dmov.nroast 
        BY NOT cb-dmov.tpomov   ON ERROR UNDO, LEAVE:
        x-NomCta = "".
        FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
             cb-ctas.codcta = cb-dmov.CodCta NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-ctas THEN 
           FIND cb-ctas WHERE cb-ctas.CodCia = S-CODCIA AND
                cb-ctas.codcta = cb-dmov.CodCta NO-LOCK NO-ERROR.
        IF AVAILABLE cb-ctas THEN x-NomCta  = cb-ctas.nomcta.
        IF cb-dmov.tpomov THEN DO:
            x-debe  = 0.
            x-haber = cb-dmov.ImpMn1.
        END.
        ELSE DO:
            x-debe  = cb-dmov.ImpMn1.
            x-haber = 0.
        END.
        IF cb-dmov.codmon = 2 THEN  x-CodMon = "US$".
        ELSE  x-CodMon = "".
        DISPLAY STREAM report 
                cb-dmov.codcta
                cb-dmov.CodDoc   
                cb-dmov.NroDoc   
                x-NomCta
                x-Codmon
                cb-dmov.ImpMn2 WHEN (cb-dmov.CodMon = 2)
                x-debe WHEN (x-debe > 0)
                x-haber WHEN (x-haber > 0) WITH FRAME f-cab.
        X-TotDeb = X-TotDeb + x-debe.
        X-TotHab = X-TotHab + x-Haber.
    END.
        PUT STREAM report "----------------" AT 97  "----------------" AT 115 SKIP.
    PUT STREAM report X-TotDeb AT 97    X-TotHab AT 115 SKIP.
    PUT STREAM report "----------------" AT 97  "----------------" AT 115 SKIP(1).
    
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
       PUT STREAM report "" skip.
    END.
    PUT STREAM report "                         -----------------       -----------------       -----------------      "  AT 20 SKIP.
    PUT STREAM report "                              HECHO                   REVISADO.           Vo.Bo.GERENCIA        "  AT 20 SKIP.
    PUT STREAM report pinta-mes.
    PAGE STREAM report.
END.
OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Voucher V-table-Win 
PROCEDURE Imprime-Voucher :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE cb-cmov THEN RETURN.
IF cb-cmov.FlgEst = "A" THEN RETURN.

FIND cb-oper WHERE cb-oper.CodCia = 0 AND
     cb-oper.Codope = cb-cmov.codope NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-oper THEN
   FIND cb-oper WHERE cb-oper.CodCia = cb-cmov.codcia AND
        cb-oper.Codope = cb-cmov.codope NO-LOCK NO-ERROR.

X-TotDeb = 0.
X-TotHab = 0.
x-nrocta = 0.
IF cb-cmov.codmon = 1 THEN  x-Mon = "S/.".
ELSE x-Mon = "US$".
x-NomOpe = "                              " + cb-oper.Nomope.
x-NomOpe = SUBSTRING(x-NomOpe,INTEGER((30 + LENGTH(cb-oper.Nomope, "CHARACTER")) / 2 )).
    
DEFINE FRAME f-cab
  cb-dmov.codcta 
  cb-dmov.codDoc AT 11
  cb-dmov.NroDoc AT 16 FORMAT "X(20)"
  X-NomCta       FORMAT "X(40)" AT 37
  x-CodMon       AT 78
  cb-dmov.ImpMn2 AT 82 FORMAT ">>,>>>,>>9.99" 
  x-debe         AT 97
  x-haber        AT 117 
  HEADER
       empresas.nomcia
       x-NomOpe AT 50 
       "FECHA : " TO 119 cb-cmov.fchast FORMAT "99/99/9999" SKIP 
       "ASIENTO No: " AT 55 cb-cmov.codope "-" cb-cmov.nroast 
                "HORA : " TO 119 STRING(TIME, "HH:MM AM") SKIP
       "MONEDA : " TO 119 x-Mon SKIP
       "Glosa     : " cb-cmov.GloAst FORMAT "X(80)" VIEW-AS TEXT 
       "TIPO CAMBIO : " TO 119 cb-cmov.TpoCmb FORMAT ">,>>9.9999" SKIP(1)
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP
       " Cuenta   Doc  Numero               Descripcion                                                          Cargos            Abonos " SKIP
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH WIDTH 130 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

/*OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 33.    */
OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 33.   
PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33) .
PUT STREAM report CONTROL "~033x" NULL "~017~033P".
FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = cb-cmov.codcia
                AND cb-dmov.periodo = cb-cmov.periodo
                AND cb-dmov.nromes  = cb-cmov.NroMes
                AND cb-dmov.codope  = cb-cmov.codope
                AND cb-dmov.nroast  = cb-cmov.nroast
    BY cb-dmov.nroast 
    BY NOT cb-dmov.tpomov   ON ERROR UNDO, LEAVE:
    /*IF cb-dmov.tpoitm = "A" THEN NEXT.*/
    x-NomCta = "".
    FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
         cb-ctas.codcta = cb-dmov.CodCta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN 
       FIND cb-ctas WHERE cb-ctas.CodCia = S-CODCIA AND
            cb-ctas.codcta = cb-dmov.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN x-NomCta  = cb-ctas.nomcta.
    IF cb-dmov.tpomov THEN DO:
        IF cb-dmov.codcta BEGINS "104" AND cb-dmov.CodDoc = "CH" THEN x-nrocta = x-nrocta + 1.
        x-debe  = 0.
        x-haber = cb-dmov.ImpMn1.
    END.
    ELSE DO:
        x-debe  = cb-dmov.ImpMn1.
        x-haber = 0.
    END.
    IF cb-dmov.codmon = 2 THEN  x-CodMon = "US$".
    ELSE  x-CodMon = "".
    DISPLAY STREAM report 
            cb-dmov.codcta
            cb-dmov.CodDoc   
            cb-dmov.NroDoc   
            x-NomCta
            x-CodMon 
            cb-dmov.ImpMn2 WHEN (cb-dmov.CodMon = 2)
            x-debe WHEN (x-debe > 0)
            x-haber WHEN (x-haber > 0) WITH FRAME f-cab.
    X-TotDeb = X-TotDeb + x-debe.
    X-TotHab = X-TotHab + x-Haber.
END.
PUT STREAM report "----------------" AT 97  "----------------" AT 115 SKIP.
PUT STREAM report X-TotDeb AT 97    X-TotHab AT 115 SKIP.
PUT STREAM report "----------------" AT 97  "----------------" AT 115 SKIP(1).

DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
   PUT STREAM report "" skip.
END.
PUT STREAM report "                         -----------------       -----------------       -----------------      "  AT 20 SKIP.
PUT STREAM report "                              HECHO                   REVISADO.           Vo.Bo.GERENCIA        "  AT 20 SKIP.
PUT STREAM report pinta-mes.
PAGE STREAM report.
OUTPUT STREAM report CLOSE.

/* IF x-nrocta > 0 THEN RUN Imprime-Detalle-Cuenta. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   IF cb-cmov.FlgEst = "A" THEN DO:
      MESSAGE "Registro Anulado " VIEW-AS ALERT-BOX ERROR.
      RETURN ERROR.
   END.
   
   FOR EACH cb-dmov WHERE cb-dmov.Codcia  = cb-CMOV.Codcia AND
            cb-dmov.periodo = cb-CMOV.periodo AND
            cb-dmov.Nromes  = cb-CMOV.Nromes  AND
            cb-dmov.Codope  = cb-CMOV.Codope  AND
            cb-dmov.Nroast  = cb-CMOV.Nroast:
         /* Des-actulizando saldos acumulados */ 
         RUN cbd/cb-acmd.p(RECID(cb-dmov), NO , YES).
         /* Borrando el detalle del Documento */ 
         DELETE cb-dmov.
   END.
  /* Dispatch standard ADM method.                             */
  FIND CMOV WHERE CMOV.Codcia  = cb-CMOV.Codcia AND
       CMOV.periodo = cb-CMOV.periodo AND
       CMOV.Nromes  = cb-CMOV.Nromes  AND
       CMOV.Codope  = cb-CMOV.Codope  AND
       CMOV.Nroast  = cb-CMOV.Nroast NO-ERROR.
  ASSIGN CMOV.Flgest = "A"
         CMOV.GloAst = "A  N  U  L  A  D  O" + cb-CMOV.GloAst.
  RELEASE CMOV.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  IF AVAILABLE cb-cmov THEN DO:
     FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
          GN-DIVI.CodDiv = cb-cmov.CodDiv NO-LOCK NO-ERROR.
     IF AVAILABLE GN-DIVI THEN 
         DISPLAY GN-DIVI.DesDiv @ F-DesDiv WITH FRAME {&FRAME-NAME}.
     ELSE DISPLAY "" @ F-DesDiv WITH FRAME {&FRAME-NAME}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

  SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
  IF answer THEN RUN Imprime-Voucher.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Modifica V-table-Win 
PROCEDURE Modifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE cb-cmov THEN RETURN ERROR.
IF cb-cmov.FlgEst = "A" THEN DO:
   MESSAGE "Registro Anulado " VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
CREATE VMOV.
ASSIGN VMOV.C-Fcaja = cb-cmov.C-Fcaja
       VMOV.Codaux = cb-cmov.Codaux
       VMOV.Codcia = cb-cmov.Codcia
       VMOV.CodDiv = cb-cmov.CodDiv
       VMOV.Coddoc = cb-cmov.Coddoc
       VMOV.Codmon = cb-cmov.Codmon
       VMOV.Codope = cb-cmov.Codope
       VMOV.Ctacja = cb-cmov.Ctacja
       VMOV.DbeMn1 = cb-cmov.DbeMn1
       VMOV.DbeMn2 = cb-cmov.DbeMn2
       VMOV.DbeMn3 = cb-cmov.DbeMn3
       VMOV.Fchast = cb-cmov.Fchast
       VMOV.FchMod = cb-cmov.FchMod
       VMOV.Flgest = cb-cmov.Flgest
       VMOV.Girado = cb-cmov.Girado
       VMOV.GloAst = cb-cmov.GloAst
       VMOV.HbeMn1 = cb-cmov.HbeMn1
       VMOV.HbeMn2 = cb-cmov.HbeMn2
       VMOV.HbeMn3 = cb-cmov.HbeMn3
       VMOV.Impchq = cb-cmov.Impchq
       VMOV.Notast = cb-cmov.Notast
       VMOV.Nroast = cb-cmov.Nroast
       VMOV.Nrochq = cb-cmov.Nrochq
       VMOV.Nromes = cb-cmov.Nromes
       VMOV.NroTra = cb-cmov.NroTra
       VMOV.Nrovou = cb-cmov.Nrovou
       VMOV.Periodo = cb-cmov.Periodo
       VMOV.Totitm = cb-cmov.Totitm
       VMOV.Tpocmb = cb-cmov.Tpocmb
       VMOV.Usuario = cb-cmov.Usuario.
FOR EACH cb-dmov WHERE cb-dmov.CodCia = cb-cmov.CodCia AND
    cb-dmov.Periodo = cb-cmov.Periodo AND
    cb-dmov.NroMes = cb-cmov.NroMes AND
    cb-dmov.Codope = cb-cmov.Codope AND
    cb-dmov.Nroast = cb-cmov.Nroast:
    IF cb-dmov.TpoItm = "A" THEN NEXT.
    CREATE RMOV.
    ASSIGN RMOV.C-Fcaja = cb-dmov.C-Fcaja
           RMOV.C-Fcaja = cb-dmov.C-Fcaja
           RMOV.cco = cb-dmov.cco 
           RMOV.Clfaux = cb-dmov.Clfaux
           RMOV.CndCmp = cb-dmov.CndCmp
           RMOV.Codaux = cb-dmov.Codaux
           RMOV.CodCia = cb-dmov.CodCia
           RMOV.Codcta = cb-dmov.Codcta
           RMOV.CodDiv = cb-dmov.CodDiv
           RMOV.Coddoc = cb-dmov.Coddoc
           RMOV.Codmon = cb-dmov.Codmon
           RMOV.Codope = cb-dmov.Codope
           RMOV.Codref = cb-dmov.Codref
           RMOV.CtaAut = cb-dmov.CtaAut
           RMOV.CtrCta = cb-dmov.CtrCta
           RMOV.DisCCo = cb-dmov.DisCCo
           RMOV.Fchdoc = cb-dmov.Fchdoc
           RMOV.Fchvto = cb-dmov.Fchvto
           RMOV.flgact = cb-dmov.flgact
           RMOV.Glodoc = cb-dmov.Glodoc
           RMOV.ImpMn1 = cb-dmov.ImpMn1
           RMOV.ImpMn2 = cb-dmov.ImpMn2
           RMOV.ImpMn3 = cb-dmov.ImpMn3
           RMOV.Nroast = cb-dmov.Nroast
           RMOV.Nrodoc = cb-dmov.Nrodoc
           RMOV.Nroitm = cb-dmov.Nroitm
           RMOV.NroMes = cb-dmov.NroMes
           RMOV.Nroref = cb-dmov.Nroref
           RMOV.Nroruc = cb-dmov.Nroruc
           RMOV.OrdCmp = cb-dmov.OrdCmp
           RMOV.Periodo = cb-dmov.Periodo
           RMOV.rel-ac-cb = cb-dmov.rel-ac-cb
           RMOV.Relacion = cb-dmov.Relacion
           RMOV.tm = cb-dmov.tm
           RMOV.Tpocmb = cb-dmov.Tpocmb
           RMOV.TpoItm = cb-dmov.TpoItm
           RMOV.TpoMov = cb-dmov.TpoMov.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cb-cmov"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

