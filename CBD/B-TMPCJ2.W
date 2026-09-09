&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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

/* Shared Variable Definitions ---                                       */
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CB-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-PERIODO  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
/*DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.*/
DEFINE SHARED VARIABLE S-CODPRO   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-FCHDOC   AS DATE.
DEFINE SHARED VARIABLE S-CONDIC   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE VAR I-NROSER AS INTEGER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VAR X-VENCTO AS CHAR NO-UNDO.
DEFINE BUFFER B-MVTO FOR MVTO.
DEFINE VAR x-saldo AS DECIMAL NO-UNDO.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

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
&Scoped-define INTERNAL-TABLES MVTO

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table MVTO.Codcta MVTO.CodRef MVTO.NroRef MVTO.FchEmi MVTO.FchVto MVTO.ImpTot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table MVTO.CodCta ~
MVTO.CodRef ~
MVTO.NroRef ~
MVTO.FchEmi ~
MVTO.FchVto ~
MVTO.ImpTot   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table MVTO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table MVTO
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH MVTO WHERE       MVTO.TpoRef = "P" NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH MVTO WHERE       MVTO.TpoRef = "P" NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table MVTO
&Scoped-define FIRST-TABLE-IN-QUERY-br_table MVTO


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-11 
&Scoped-Define DISPLAYED-OBJECTS F-ImpTot 

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
DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 1.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      MVTO SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      MVTO.Codcta COLUMN-LABEL 'Cuenta!Contable  ' FORMAT 'X(8)' 
      MVTO.CodRef COLUMN-LABEL "Cod!Doc."
      MVTO.NroRef COLUMN-LABEL "<<<Numero>>>"      FORMAT 'x(11)'
      MVTO.FchEmi COLUMN-LABEL "  F.Emision   "      
      MVTO.FchVto COLUMN-LABEL " F.Vencimiento"      
      MVTO.ImpTot COLUMN-LABEL "  Importe Total"
  ENABLE
      MVTO.CodCta
      MVTO.CodRef
      MVTO.NroRef
      MVTO.FchEmi
      MVTO.FchVto
      MVTO.ImpTot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 58 BY 4.04
         FONT 4
         TITLE "CUENTAS POR PAGAR".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-ImpTot AT ROW 5.5 COL 42.86 COLON-ALIGNED NO-LABEL
     "Importe Total" VIEW-AS TEXT
          SIZE 9.86 BY .5 AT ROW 5.5 COL 33.43
     RECT-11 AT ROW 5.23 COL 31
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
         HEIGHT             = 5.42
         WIDTH              = 60.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

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
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH MVTO WHERE
      MVTO.TpoRef = "P" NO-LOCK.
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
ON ANY-PRINTABLE OF br_table IN FRAME F-Main /* CUENTAS POR PAGAR */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* CUENTAS POR PAGAR */
DO:
  /* This code `isplays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* CUENTAS POR PAGAR */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* CUENTAS POR PAGAR */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF MVTO.CodCta, MVTO.Codref,MVTO.NroRef, MVTO.ImpTot
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF MVTO.CodCta DO:
  IF MVTO.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' THEN RETURN.
  FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
        cb-ctas.Codcta = MVTO.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-ctas THEN DO:
      MESSAGE 'Cuenta Contable no existe' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO MVTO.CodCta.
      RETURN NO-APPLY.
  END.
END.

ON "LEAVE":U OF MVTO.Codref DO:
   FIND cb-tabl WHERE cb-tabl.Tabla = '02' AND
        cb-tabl.Codigo = MVTO.Codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
   IF NOT AVAILABLE cb-tabl THEN DO:
      MESSAGE 'Codigo de documento no existe' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO MVTO.CodRef.
      RETURN NO-APPLY.
   END.
END.

ON "LEAVE":U OF MVTO.Nroref DO :
   IF MVTO.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' THEN RETURN.
   FIND FIRST cb-dmov WHERE cb-dmov.CodCia = s-codcia AND
        cb-dmov.Periodo = s-periodo                   AND 
        cb-dmov.Codcta  = MVTO.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
        cb-dmov.codaux  = S-CODPRO                    AND  
        cb-dmov.coddoc  = MVTO.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}  AND
        cb-dmov.nrodoc  = MVTO.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-dmov THEN DO:
      MESSAGE 'Documento no se encuentra provisionado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   RUN Saldo-Pendiente(MVTO.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                       MVTO.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                       MVTO.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                       OUTPUT x-saldo).
   DISPLAY 
      x-saldo @ MVTO.Imptot WITH BROWSE {&BROWSE-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Articulos B-table-Win 
PROCEDURE Asignar-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN F-ImpTot = 0.
/*  FOR EACH B-MVTO:
 *     IF B-MVTO.TpoRef = 'P' THEN
 *        F-ImpTot = F-ImpTot + B-MVTO.ImpTot.
 *   END.*/

  FOR EACH B-MVTO WHERE B-MVTO.TpoRef = 'P':
    IF s-CodMon = 1
    THEN f-ImpTot = f-ImpTot + B-MVTO.DepNac[1].
    ELSE f-ImpTot = f-ImpTot + B-MVTO.DepUsa[1].
  END.

  DISPLAY F-ImpTot WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-PRECIO AS DECIMAL NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  ASSIGN 
    MVTO.CodCia = S-CODCIA
    MVTO.Coddoc = s-coddoc
    MVTO.Tporef = 'P'.
  /* definimos la moneda de acuerdo a la cuenta */
  DEF VAR x-CodMon AS INT.

  x-CodMon = Cb-Ctas.CodMon.
  IF x-CodMon = 3 THEN x-CodMon = s-CodMon.
  IF x-CodMon = 1
  THEN ASSIGN
            MVTO.DepNac[1] = MVTO.ImpTot
            MVTO.DepUsa[1] = MVTO.ImpTot / s-TpoCmb.
  ELSE ASSIGN
            MVTO.DepUsa[1] = MVTO.ImpTot
            MVTO.DepNac[1] = MVTO.ImpTot * s-TpoCmb.

/*   IF Cb-ctas.codmon = 1                              */
/*   THEN ASSIGN                                        */
/*             MVTO.DepNac[1] = MVTO.ImpTot             */
/*             MVTO.DepUsa[1] = MVTO.ImpTot / s-TpoCmb. */
/*   ELSE ASSIGN                                        */
/*             MVTO.DepUsa[1] = MVTO.ImpTot             */
/*             MVTO.DepNac[1] = MVTO.ImpTot * s-TpoCmb. */
            
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
  
  RUN Imp-Total.
  
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
        WHEN "" THEN ASSIGN input-var-1 = ''.
        WHEN "CodCta" THEN
            ASSIGN
                input-var-1 = '42,43'
                input-var-2 = ''
                input-var-3 = ''.
        WHEN "codref" THEN 
            ASSIGN 
                input-var-1 = '02'
                input-var-2 = ''
                input-var-3 = ''.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldo-Pendiente B-table-Win 
PROCEDURE Saldo-Pendiente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-codcta AS CHAR.
DEFINE INPUT PARAMETER x-coddoc AS CHAR.
DEFINE INPUT PARAMETER x-nrodoc AS CHAR.
DEFINE OUTPUT PARAMETER x-import AS DECIMAL.

DEFINE VAR x-codmon AS INTEGER NO-UNDO.


FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
     cb-ctas.Codcta = x-codcta NO-LOCK NO-ERROR.
x-CodMon = Cb-Ctas.CodMon.
IF x-CodMon = 3 THEN x-CodMon = s-CodMon.
/*IF AVAILABLE cb-ctas THEN x-codmon = IF cb-ctas.codmon = 1 THEN 1 ELSE 2.*/

/* Saldo pendiente de acuerdo a provision */
x-import = 0.
FOR EACH cb-dmov WHERE cb-dmov.CodCia = s-codcia AND
    cb-dmov.Periodo = s-periodo AND cb-dmov.Codcta = x-codcta AND
    cb-dmov.codaux  = S-CODPRO  AND cb-dmov.coddoc = x-coddoc AND
    cb-dmov.nrodoc  = x-nrodoc NO-LOCK :
    IF x-codmon = 1 THEN DO:
       IF cb-dmov.tpomov THEN x-import = x-import + cb-dmov.impmn1.
       ELSE x-import = x-import - cb-dmov.impmn1.           
       END.    
    ELSE DO:
       IF cb-dmov.tpomov THEN x-import = x-import + cb-dmov.impmn2.
       ELSE x-import = x-import - cb-dmov.impmn2.           
    END.
END.
/* RHC 16.05.07
IF S-CODMON <> x-codmon THEN DO:
   IF S-CODMON = 1 THEN x-import = x-import * S-TPOCMB.
   ELSE x-import = ROUND(x-import / S-TPOCMB, 2).
END.
*/

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
  {src/adm/template/snd-list.i "MVTO"}

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
IF MVTO.Codcta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Cuenta en blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO MVTO.Codcta.
   RETURN "ADM-ERROR".   
END.
FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
     cb-ctas.Codcta = MVTO.Codcta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-ctas THEN
   FIND cb-ctas WHERE cb-ctas.CodCia = S-CODCIA AND
        cb-ctas.Codcta = MVTO.Codcta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-ctas THEN DO:
   MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO MVTO.Codcta.
   RETURN "ADM-ERROR".   
END. 
IF MVTO.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de Documento en blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO MVTO.CodRef.
   RETURN "ADM-ERROR".
END.
IF MVTO.Nroref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "No.de Documento en blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO MVTO.Nroref.
   RETURN "ADM-ERROR".
END.
IF DECIMAL(MVTO.ImpTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Documento con importe igual a cero" VIEW-AS ALERT-BOX ERROR.
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
IF NOT AVAILABLE MVTO THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

