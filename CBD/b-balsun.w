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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR cb-codcia AS INT.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED VAR S-NROMES  AS INTEGER.
DEFINE SHARED VAR S-CODBAL  AS INTEGER.
DEFINE BUFFER B-cfgbal  FOR cb-cfgbal.

DEFINE VAR x-archivo AS CHARACTER FORMAT "X(20)".

DEFINE VAR x-lin AS CHARACTER FORMAT "X(110)".
DEFINE VAR I AS INTEGER. 
DEFINE VARIABLE impca1     AS DECIMAL.
DEFINE VARIABLE impca2     AS DECIMAL.
DEFINE VARIABLE impca3     AS DECIMAL.
DEFINE VARIABLE impca4     AS DECIMAL.
DEFINE VARIABLE impca5     AS DECIMAL.
DEFINE VARIABLE impca6     AS DECIMAL.


FIND Empresas WHERE Empresas.Codcia = S-CODCIA 
     NO-LOCK NO-ERROR.

DEFINE IMAGE IMAGE-1
     FILENAME "IMG/print"
     SIZE 5 BY 1.5.

DEFINE FRAME F-Mensaje
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          font 4
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          font 4
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          font 4          
     SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ...".

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
&Scoped-define INTERNAL-TABLES cb-cfgbal

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table cb-cfgbal.Codcta cb-cfgbal.Nomcta ~
cb-cfgbal.Tipo cb-cfgbal.ReiD cb-cfgbal.ReiH cb-cfgbal.MayorD ~
cb-cfgbal.MayorH cb-cfgbal.TransfeD cb-cfgbal.TransfeH 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table cb-cfgbal.Codcta ~
cb-cfgbal.Nomcta cb-cfgbal.Tipo cb-cfgbal.ReiD cb-cfgbal.ReiH ~
cb-cfgbal.MayorD cb-cfgbal.MayorH cb-cfgbal.TransfeD cb-cfgbal.TransfeH 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table cb-cfgbal
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table cb-cfgbal
&Scoped-define QUERY-STRING-br_table FOR EACH cb-cfgbal WHERE ~{&KEY-PHRASE} ~
      AND cb-cfgbal.CodCia = S-CODCIA ~
 AND cb-cfgbal.Periodo = s-periodo ~
 AND cb-cfgbal.NroMes = s-nromes NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH cb-cfgbal WHERE ~{&KEY-PHRASE} ~
      AND cb-cfgbal.CodCia = S-CODCIA ~
 AND cb-cfgbal.Periodo = s-periodo ~
 AND cb-cfgbal.NroMes = s-nromes NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table cb-cfgbal
&Scoped-define FIRST-TABLE-IN-QUERY-br_table cb-cfgbal


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS F-MayorD F-MayorH 

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
DEFINE VARIABLE F-MayorD AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "MayorD" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE F-MayorH AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "MayorH" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 1.27.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE .86 BY .15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      cb-cfgbal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      cb-cfgbal.Codcta FORMAT "x(10)":U
      cb-cfgbal.Nomcta FORMAT "x(60)":U
      cb-cfgbal.Tipo FORMAT "9":U
      cb-cfgbal.ReiD COLUMN-LABEL "Apertura!Debe" FORMAT "->>>,>>>,>>9.99":U
      cb-cfgbal.ReiH COLUMN-LABEL "Apertura!Haber" FORMAT "->>>,>>>,>>9.99":U
      cb-cfgbal.MayorD COLUMN-LABEL "Movimientos!Debe" FORMAT "->>>,>>>,>>9.99":U
      cb-cfgbal.MayorH COLUMN-LABEL "Movimientos!Haber" FORMAT "->>>,>>>,>>9.99":U
      cb-cfgbal.TransfeD COLUMN-LABEL "Transferencias!Debe" FORMAT "->>>,>>>,>>9.99":U
      cb-cfgbal.TransfeH COLUMN-LABEL "Transferencias!Haber" FORMAT "->>>,>>>,>>9.99":U
  ENABLE
      cb-cfgbal.Codcta
      cb-cfgbal.Nomcta
      cb-cfgbal.Tipo
      cb-cfgbal.ReiD
      cb-cfgbal.ReiH
      cb-cfgbal.MayorD
      cb-cfgbal.MayorH
      cb-cfgbal.TransfeD
      cb-cfgbal.TransfeH
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 94.43 BY 15.19
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-MayorD AT ROW 16.38 COL 58 COLON-ALIGNED
     F-MayorH AT ROW 16.38 COL 78 COLON-ALIGNED
     "Totales ----->" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 16.58 COL 37
     RECT-1 AT ROW 16.19 COL 32
     RECT-2 AT ROW 12.73 COL 44
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
         HEIGHT             = 16.46
         WIDTH              = 94.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
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

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* SETTINGS FOR FILL-IN F-MayorD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-MayorH IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.cb-cfgbal"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "INTEGRAL.cb-cfgbal.CodCia = S-CODCIA
 AND INTEGRAL.cb-cfgbal.Periodo = s-periodo
 AND INTEGRAL.cb-cfgbal.NroMes = s-nromes"
     _FldNameList[1]   > INTEGRAL.cb-cfgbal.Codcta
"cb-cfgbal.Codcta" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.cb-cfgbal.Nomcta
"cb-cfgbal.Nomcta" ? "x(60)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.cb-cfgbal.Tipo
"cb-cfgbal.Tipo" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.cb-cfgbal.ReiD
"cb-cfgbal.ReiD" "Apertura!Debe" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.cb-cfgbal.ReiH
"cb-cfgbal.ReiH" "Apertura!Haber" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.cb-cfgbal.MayorD
"cb-cfgbal.MayorD" "Movimientos!Debe" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.cb-cfgbal.MayorH
"cb-cfgbal.MayorH" "Movimientos!Haber" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.cb-cfgbal.TransfeD
"cb-cfgbal.TransfeD" "Transferencias!Debe" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.cb-cfgbal.TransfeH
"cb-cfgbal.TransfeH" "Transferencias!Haber" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF codcta, nomcta, tipo, reid, reih, mayord,mayorh,transfed,transfeh
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF codcta
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia /*S-CODCIA*/ 
                  AND cb-ctas.codcta = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-ctas THEN DO:
      MESSAGE "Cuenta no existe en plan de cuentas" VIEW-AS ALERT-BOX INFORMATION.
   END.
   ELSE DO:
     DISPLAY 
      cb-ctas.nomcta @ cb-cfgbal.nomcta
     WITH BROWSE {&BROWSE-NAME}.
 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Txt B-table-Win 
PROCEDURE Genera-Txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-archivo = "c:\" + "0658" + TRIM(Empresas.Ruc) + STRING(S-PERIODO,"9999") + ".txt" .


OUTPUT TO VALUE(x-archivo).

FOR EACH b-cfgbal WHERE b-cfgbal.codcia  = S-CODCIA AND
                        b-cfgbal.periodo = S-PERIODO AND
                        b-cfgbal.nromes  = S-NROMES:
 x-lin = "".
/*
 x-lin = TRIM(codcta) +
         "|" +
         STRING(INTEGER(MayorD),"ZZZZZZZZZZZZ") +
         "|" + 
         STRING(INTEGER(MayorH),"ZZZZZZZZZZZZ") +
         "|" + 
         STRING(INTEGER(TransfeD),"ZZZZZZZZZZZZ") +
         "|" + 
         STRING(INTEGER(TransfeH),"ZZZZZZZZZZZZ") +
         "|" + 
         STRING(INTEGER(Adiciones),"ZZZZZZZZZZZZ") +
         "|" + 
         STRING(INTEGER(Deduce),"ZZZZZZZZZZZZ") +
         "|" + 
         STRING(INTEGER(ReiD),"ZZZZZZZZZZZZ") +
         "|" + 
         STRING(INTEGER(ReiH),"ZZZZZZZZZZZZ") +
         "|"  .
*/
 x-lin = x-lin + TRIM(codcta) +
         "|" .
 x-lin = x-lin + IF STRING(INTEGER(ReiD)) = "0" THEN "|" ELSE STRING(INTEGER(ReiD)) +
         "|" .
 x-lin = x-lin + IF STRING(INTEGER(ReiH)) = "0" THEN "|" ELSE STRING(INTEGER(ReiH)) +
         "|"  .

 x-lin = x-lin + STRING(INTEGER(MayorD)) +
         "|" .
 x-lin = x-lin + STRING(INTEGER(MayorH)) +
         "|" .
 x-lin = x-lin + STRING(INTEGER(TransfeD)) +
         "|" .
 x-lin = x-lin + STRING(INTEGER(TransfeH)) +
         "|" .

 DISPLAY x-lin WITH WIDTH 120 NO-BOX NO-LABELS NO-UNDERLINE.


END.

OUTPUT CLOSE.

MESSAGE "Archivo de texto se genero con exito " skip
        x-archivo        
        VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

F-MayorD = 0.
F-MayorH = 0.

FOR EACH b-cfgbal WHERE b-cfgbal.codcia  = S-CODCIA AND
                        b-cfgbal.periodo = S-PERIODO AND
                        b-cfgbal.nromes  = S-NROMES:
    F-MayorD = F-MayorD + b-cfgbal.MayorD.
    F-MayorH = F-MayorH + b-cfgbal.MayorH.
END.

DISPLAY F-MayorD F-MayorH .
    
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   ASSIGN
   cb-cfgbal.codcia  = S-CODCIA
   cb-cfgbal.periodo = S-PERIODO 
   cb-cfgbal.nromes  = S-NROMES.
   
   RUN Imp-total.
   
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa B-table-Win 
PROCEDURE Procesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*

FOR EACH b-cfgbal WHERE b-cfgbal.codcia  = S-CODCIA AND
                        b-cfgbal.periodo = S-PERIODO AND
                        b-cfgbal.nromes  = S-NROMES:
    FOR EACH cb-acmd WHERE cb-acmd.codcia  = S-CODCIA AND
                           cb-acmd.periodo = S-PERIODO AND
                           cb-acmd.codcta  begins b-cfgbal.codcta AND
                           length(cb-acmd.codcta) = 6:
        ASSIGN
        b-cfgbal.MayorD    = b-cfgbal.MayorD + DbeMn1[S-NROMES + 1]
        b-cfgbal.MayorH    = b-cfgbal.MayorH + HbeMn1[S-NROMES + 1]
        b-cfgbal.TransfeD  = 0 /*DbeMn1[S-NROMES + 1]*/
        b-cfgbal.TransfeH  = 0 /*HbeMn1[S-NROMES + 1]*/
        b-cfgbal.Adiciones = 0 /*DbeMn1[S-NROMES + 1]*/
        b-cfgbal.Deduce    = 0 /*DbeMn1[S-NROMES + 1]*/
        b-cfgbal.ReiD      = 0 /*DbeMn1[S-NROMES + 1]*/
        b-cfgbal.ReiH      = 0 /*DbeMn1[S-NROMES + 1]*/.
        
    END.

END.
*/
FOR EACH b-cfgbal WHERE b-cfgbal.codcia = S-CODCIA AND
                        b-cfgbal.periodo = S-PERIODO AND
                        b-cfgbal.nromes  = S-NROMES :
 DELETE b-cfgbal.

END.

RELEASE b-cfgbal.                         


FOR EACH cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
                LENGTH(cb-ctas.codcta) = s-codbal :
      /***  Apertura ***/  
      RUN cbd/cbd_imp.p ( INPUT  s-codcia, 
                         cb-ctas.codcta,
                         "", 
                         s-periodo, 
                         0,
                         1,
                        OUTPUT impca1, 
                        OUTPUT impca2, 
                        OUTPUT impca3,
                        OUTPUT impca4, 
                        OUTPUT impca5, 
                        OUTPUT impca6 ).

        FIND b-cfgbal WHERE b-cfgbal.codcia = S-CODCIA AND
                            b-cfgbal.periodo = S-PERIODO AND
                            b-cfgbal.nromes  = S-NROMES AND
                            b-cfgbal.codcta = cb-ctas.codcta
                            NO-ERROR.
                            
        IF NOT AVAILABLE b-cfgbal THEN DO:                    
           CREATE b-cfgbal.                  
           ASSIGN
           b-cfgbal.codcia = S-CODCIA 
           b-cfgbal.codcta = cb-ctas.codcta 
           b-cfgbal.nomcta = cb-ctas.nomcta 
           b-cfgbal.periodo = S-PERIODO 
           b-cfgbal.nromes  = S-NROMES .           
        END.  
        ASSIGN
        b-cfgbal.ReiD      = b-cfgbal.ReiD + impca4
        b-cfgbal.ReiH      = b-cfgbal.ReiH + impca5.


    If S-NroMes <> 0 THEN DO:
      RUN cbd/cbd_imp.p ( INPUT  s-codcia, 
                         cb-ctas.codcta,
                         "", 
                         s-periodo, 
                         s-NroMes,
                         1,
                        OUTPUT impca1, 
                        OUTPUT impca2, 
                        OUTPUT impca3,
                        OUTPUT impca4, 
                        OUTPUT impca5, 
                        OUTPUT impca6 ).

        FIND b-cfgbal WHERE b-cfgbal.codcia = S-CODCIA AND
                            b-cfgbal.periodo = S-PERIODO AND
                            b-cfgbal.nromes  = S-NROMES AND
                            b-cfgbal.codcta = cb-ctas.codcta
                            NO-ERROR.
        DISPLAY cb-ctas.codcta cb-ctas.nomcta WITH FRAME f-mensaje.
                            
        IF NOT AVAILABLE b-cfgbal THEN DO:                    
           CREATE b-cfgbal.                  
           ASSIGN
           b-cfgbal.codcia = S-CODCIA 
           b-cfgbal.codcta = cb-ctas.codcta 
           b-cfgbal.nomcta = cb-ctas.nomcta 
           b-cfgbal.periodo = S-PERIODO 
           b-cfgbal.nromes  = S-NROMES .           
        END.  
        ASSIGN
        b-cfgbal.MayorD    = b-cfgbal.MayorD + impca4 /* - b-cfgbal.ReiD */
        b-cfgbal.MayorH    = b-cfgbal.MayorH + impca5 /* - b-cfgbal.ReiH */.
      END.
END.



HIDE FRAME F-MENSAJE.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

RUN Imp-Total.

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
  {src/adm/template/snd-list.i "cb-cfgbal"}

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

