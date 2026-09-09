&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

DEFINE BUFFER CROL FOR cp-crol.
DEFINE VAR X-NroRol AS INTEGER NO-UNDO.
{BIN/S-GLOBAL.I}
{CXP/CPGLOBAL.I}

DEFINE STREAM report.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cp-crol
&Scoped-define FIRST-EXTERNAL-TABLE cp-crol


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cp-crol.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cp-crol.Fch-pgo-1 cp-crol.Fch-pgo-2 ~
cp-crol.CodDiv cp-crol.Observ 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}Fch-pgo-1 ~{&FP2}Fch-pgo-1 ~{&FP3}~
 ~{&FP1}Fch-pgo-2 ~{&FP2}Fch-pgo-2 ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}Observ ~{&FP2}Observ ~{&FP3}
&Scoped-define ENABLED-TABLES cp-crol
&Scoped-define FIRST-ENABLED-TABLE cp-crol
&Scoped-Define ENABLED-OBJECTS RECT-16 
&Scoped-Define DISPLAYED-FIELDS cp-crol.Nrorol cp-crol.Fch-pgo-1 ~
cp-crol.Fch-pgo-2 cp-crol.CodDiv cp-crol.Fecha cp-crol.Observ 

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
DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63.86 BY 2.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cp-crol.Nrorol AT ROW 1.23 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .69
     cp-crol.Fch-pgo-1 AT ROW 1.23 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .69
     cp-crol.Fch-pgo-2 AT ROW 1.23 COL 48.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .69
     cp-crol.CodDiv AT ROW 1.96 COL 9 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .69
     cp-crol.Fecha AT ROW 1.96 COL 48.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .69
     cp-crol.Observ AT ROW 2.88 COL 2.43
          VIEW-AS FILL-IN 
          SIZE 49.43 BY .69
     RECT-16 AT ROW 1 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.cp-crol
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 2.92
         WIDTH              = 64.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cp-crol.Fecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cp-crol.Nrorol IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cp-crol.Observ IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "cp-crol"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cp-crol"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Numero-Rol.
  
  DISPLAY X-NroRol @ cp-crol.Nrorol WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
     RUN Numero-Rol.
     ASSIGN cp-crol.CodCia  = S-CODCIA
            cp-crol.Periodo = S-PERIODO
            cp-crol.nromes  = S-NROMES
            cp-crol.Nrorol  = X-NroRol
            cp-crol.tpocmb  = 1
            cp-crol.Usuario = S-USER-ID
            cp-crol.Fecha   = TODAY.
     FIND LAST Gn-Tcmb WHERE Gn-Tcmb.fecha <=  cp-crol.Fecha
                             NO-LOCK NO-ERROR.
     IF AVAILABLE Gn-Tcmb THEN cp-crol.tpocmb  = Gn-tcmb.Compra.
  END.
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
  IF AVAILABLE CP-CROL AND CP-CROL.FLGEST THEN DO:
     MESSAGE "Cronograma cerrado ..." VIEW-AS ALERT-BOX WARNING.
     RETURN ERROR.
  END.
  
  MESSAGE "Se eliminara el Rol de pagos" skip
          "y todos los documentos correspondientes " skip
          "del cronograma" skip
          "Desa Continuar ? "
          VIEW-AS ALERT-BOX WARNING
          BUTTONS YES-NO UPDATE RPTA AS LOGICAL.
  IF NOT RPTA THEN RETURN ERROR.
  FOR EACH cp-brol WHERE cp-brol.CodCia  = cp-crol.codcia  AND
                         cp-brol.Nrorol  = cp-crol.nrorol  AND
                         cp-brol.Periodo = cp-crol.periodo:
      FOR EACH cp-drol WHERE cp-drol.CodCia  = cp-brol.codcia  AND
                             cp-drol.Nrorol  = cp-brol.nrorol  AND
                             cp-drol.Periodo = cp-brol.periodo AND
                             cp-drol.ctabco  = cp-brol.ctabco:
          DELETE cp-drol.
      END.
      DELETE cp-brol.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  

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
  DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
    IF NOT answer THEN RETURN ERROR.

    DEFINE VARIABLE x-codmon   AS CHARACTER FORMAT "X(3)".
    DEFINE VARIABLE x-monbco   AS CHARACTER FORMAT "X(3)".
    DEFINE VARIABLE x-nombco   AS CHARACTER FORMAT "X(30)".
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-ImpPgo   AS DECIMAL   FORMAT "(ZZ,ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-Importe  AS DECIMAL   FORMAT "(ZZ,ZZZ,ZZZ,ZZ9.99)".

    DEFINE FRAME f-cab
        cp-drol.Codaux  COLUMN-LABEL "Código!Aux."
        cp-drol.NomAux  COLUMN-LABEL "Nombre" FORMAT "X(30)"
        cp-drol.Coddoc  COLUMN-LABEL "Cod!Doc"
        cp-drol.Nrodoc  COLUMN-LABEL "Número de!documento"
        cp-drol.FchDoc  COLUMN-LABEL "Fecha!doc."
        cp-drol.FchVto  COLUMN-LABEL "Fecha!vcto."
        x-codmon        COLUMN-LABEL "Mon!doc"
        x-Importe COLUMN-LABEL "Importe!documento"
        x-imppgo  COLUMN-LABEL "Importe!pago"
        cp-drol.Codcta  COLUMN-LABEL "Código!cuenta"
      HEADER
        "Nro. Cronograma  : " cp-crol.nrorol 
        "Fecha : " TO 70 cp-crol.fecha  SKIP
        "Tipo de Cambio   : " cp-crol.tpocmb SKIP
        "División         : " cp-crol.CodDiv SKIP
        "Detalle          : " cp-crol.Observ FORMAT "X(20)" SKIP (2)
        
    WITH WIDTH 180 NO-BOX STREAM-IO DOWN.
    
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 60.    
/*    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33).
 *     PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.*/
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.

    x-con-reg = 0.

    FOR EACH cp-drol NO-LOCK WHERE cp-drol.codcia = cp-crol.codcia
            AND cp-drol.periodo = cp-crol.periodo
            AND cp-drol.NroMes  = cp-crol.NroMes
            AND cp-drol.nrorol  = cp-crol.nrorol
            BREAK BY cp-drol.ctabco BY cp-drol.codaux:
        IF FIRST-OF(cp-drol.ctabco)
        THEN DO:
            FIND cb-ctas WHERE cb-ctas.codcia = CB-codcia AND
                cb-ctas.codcta = cp-drol.ctabco NO-LOCK NO-ERROR.
            IF AVAIL cb-ctas THEN x-nombco = cb-ctas.nomcta.
            CASE cp-drol.codmon:
                WHEN 1 THEN x-codmon = "S/.".
                WHEN 2 THEN x-codmon = "US$".
                WHEN 3 THEN x-codmon = "S/.".
            END CASE.
            CASE cp-drol.monbco:
                WHEN 1 THEN x-monbco = "S/.".
                WHEN 2 THEN x-monbco = "US$".
                WHEN 3 THEN x-monbco = "S/.".
            END CASE.
            PUT STREAM REPORT CONTROL {&Prn6a}.
            DISPLAY STREAM REPORT
                cp-drol.ctabco @ cp-drol.codaux
                x-nombco @ cp-drol.nomaux 
                WITH FRAME F-Cab.
            PUT STREAM REPORT CONTROL {&Prn6b}.
            DOWN STREAM REPORT WITH FRAME F-Cab.
        END.
        IF cp-drol.TpoMov THEN DO:
           x-ImpPgo  = cp-drol.ImpPgo.
           x-Importe = cp-drol.Importe.
        END.
        ELSE DO :
           x-ImpPgo  = cp-drol.ImpPgo * -1.
           x-Importe = cp-drol.Importe * -1.
        END.
        ACCUMULATE x-importe (SUB-TOTAL BY cp-drol.ctabco).
        ACCUMULATE x-imppgo  (SUB-TOTAL BY cp-drol.ctabco).
        ACCUMULATE x-importe (SUB-TOTAL BY cp-drol.codaux).
        ACCUMULATE x-imppgo  (SUB-TOTAL BY cp-drol.codaux).
        DISPLAY STREAM report
            cp-drol.Coddoc
            cp-drol.Nrodoc
            cp-drol.FchDoc
            cp-drol.FchVto
            cp-drol.Codaux
            cp-drol.NomAux
            x-codmon
            x-Importe
            x-imppgo
            cp-drol.Codcta
            WITH FRAME f-cab.
        x-con-reg = x-con-reg + 1.
        IF LAST-OF (cp-drol.codaux)
        THEN DO:
            DOWN STREAM report 1 WITH FRAME f-cab.
            UNDERLINE STREAM report x-importe
                x-imppgo WITH FRAME f-cab.
            DISPLAY STREAM report
                'SUB-TOTAL POR PROVEEDOR:' @ cp-drol.nomaux
                    ACCUM SUB-TOTAL BY (cp-drol.codaux)
                        x-importe  @ x-importe
                    ACCUM SUB-TOTAL BY (cp-drol.codaux)
                        x-imppgo @ x-imppgo
                WITH FRAME f-cab.
            DOWN STREAM report 1 WITH FRAME f-cab.
        END.
        IF LAST-OF (cp-drol.ctabco) AND x-con-reg > 0
        THEN DO:
            x-con-reg = 0.
            DOWN STREAM report 1 WITH FRAME f-cab.
            UNDERLINE STREAM report x-importe
                x-imppgo WITH FRAME f-cab.
            DISPLAY STREAM report
                'TOTAL POR BANCO:' @ cp-drol.nomaux
                    ACCUM SUB-TOTAL BY (cp-drol.ctabco)
                        x-importe  @ x-importe
                    ACCUM SUB-TOTAL BY (cp-drol.ctabco)
                        x-imppgo @ x-imppgo
                WITH FRAME f-cab.
            DOWN STREAM report 1 WITH FRAME f-cab.
        END.
    END.
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "-----------------       -----------------        ----------------- "  AT 30 SKIP.
    PUT STREAM report "      HECHO                 REVISADO              Vo.Bo.Gerencia    " AT 30.
    OUTPUT STREAM report CLOSE.
    
END PROCEDURE.


/* FORMATO ANTIGUO ****************************************************
    DEFINE VARIABLE x-codmon   AS CHARACTER FORMAT "X(3)".
    DEFINE VARIABLE x-monbco   AS CHARACTER FORMAT "X(3)".
    DEFINE VARIABLE x-nombco   AS CHARACTER FORMAT "X(30)".
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-ImpPgo   AS DECIMAL   FORMAT "(ZZ,ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-Importe  AS DECIMAL   FORMAT "(ZZ,ZZZ,ZZZ,ZZ9.99)".

    DEFINE FRAME f-cab
        cp-drol.Coddoc  COLUMN-LABEL "Cod!Doc"
        cp-drol.Nrodoc  COLUMN-LABEL "Número de!documento"
        cp-drol.FchDoc  COLUMN-LABEL "Fecha!doc."
        cp-drol.FchVto  COLUMN-LABEL "Fecha!vcto."
        cp-drol.Codaux  COLUMN-LABEL "Código!Aux."
        cp-drol.NomAux  COLUMN-LABEL "Nombre" FORMAT "X(30)"
        x-codmon        COLUMN-LABEL "Mon!doc"
        x-Importe COLUMN-LABEL "Importe!documento"
        x-imppgo  COLUMN-LABEL "Importe!pago"
        cp-drol.Codcta  COLUMN-LABEL "Código!cuenta"
      HEADER
        "Nro. Cronograma  : " cp-crol.nrorol 
        "Fecha : " TO 70 cp-crol.fecha  SKIP
        "Tipo de Cambio   : " cp-crol.tpocmb SKIP
        "Banco            : " cp-drol.ctabco x-nombco SKIP
        "Moneda           : " x-monbco
        "División         : " cp-crol.CodDiv 
        "Nro Cheque       : " cp-crol.NroChq SKIP
        "Detalle          : " cp-crol.Observ FORMAT "X(20)" SKIP (2)
        
    WITH WIDTH 180 NO-BOX STREAM-IO DOWN.
    
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 33.    
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33).
    PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.

    x-con-reg = 0.

    FOR EACH cp-drol NO-LOCK WHERE cp-drol.codcia = cp-crol.codcia
        AND cp-drol.periodo = cp-crol.periodo
        AND cp-drol.NroMes  = cp-crol.NroMes
        AND cp-drol.nrorol  = cp-crol.nrorol
        BREAK BY ( cp-drol.ctabco ) ON ERROR UNDO, LEAVE:
        FIND cb-ctas WHERE cb-ctas.codcia = CB-codcia AND
            cb-ctas.codcta = cp-drol.ctabco NO-LOCK NO-ERROR.
        IF AVAIL cb-ctas THEN x-nombco = cb-ctas.nomcta.
        CASE cp-drol.codmon:
            WHEN 1 THEN x-codmon = "S/.".
            WHEN 2 THEN x-codmon = "US$".
            WHEN 3 THEN x-codmon = "S/.".
        END CASE.
        CASE cp-drol.monbco:
            WHEN 1 THEN x-monbco = "S/.".
            WHEN 2 THEN x-monbco = "US$".
            WHEN 3 THEN x-monbco = "S/.".
        END CASE.
        IF cp-drol.TpoMov THEN DO:
           x-ImpPgo  = cp-drol.ImpPgo.
           x-Importe = cp-drol.Importe.
        END.
        ELSE DO :
           x-ImpPgo  = cp-drol.ImpPgo * -1.
           x-Importe = cp-drol.Importe * -1.
        END.
        
        ACCUMULATE x-importe (SUB-TOTAL BY cp-drol.ctabco).
        ACCUMULATE x-imppgo  (SUB-TOTAL BY cp-drol.ctabco).
        DISPLAY STREAM report
            cp-drol.Coddoc
            cp-drol.Nrodoc
            cp-drol.FchDoc
            cp-drol.FchVto
            cp-drol.Codaux
            cp-drol.NomAux
            x-codmon
            x-Importe
            x-imppgo
            cp-drol.Codcta
            WITH FRAME f-cab.
        x-con-reg = x-con-reg + 1.
        IF LAST-OF (cp-drol.ctabco) AND x-con-reg > 0
        THEN DO:
            x-con-reg = 0.
            DOWN STREAM report 1 WITH FRAME f-cab.
            UNDERLINE STREAM report x-importe
                x-imppgo WITH FRAME f-cab.
            DISPLAY STREAM report
                    ACCUM SUB-TOTAL BY (cp-drol.ctabco)
                        x-importe  @ x-importe
                    ACCUM SUB-TOTAL BY (cp-drol.ctabco)
                        x-imppgo @ x-imppgo
                WITH FRAME f-cab.
            DOWN STREAM report 1 WITH FRAME f-cab.
        END.
    END.
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "-----------------       -----------------        ----------------- "  AT 30 SKIP.
    PUT STREAM report "      HECHO                 REVISADO              Vo.Bo.Gerencia    " AT 30.
    OUTPUT STREAM report CLOSE.

******************************************************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY 
        TODAY @ integral.cp-crol.Fecha.
  END.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-Rol V-table-Win 
PROCEDURE Numero-Rol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND LAST CROL WHERE CROL.Codcia = S-CODCIA AND 
     CROL.Periodo = S-PERIODO AND
     CROL.Nromes  = S-NROMES NO-LOCK NO-ERROR.
IF NOT AVAILABLE CROL THEN X-NroRol = 1.
ELSE X-NroRol = CROL.NroRol + 1.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cp-crol"}

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

  IF p-state = 'update-begin':U  AND AVAILABLE CP-CROL AND CP-CROL.FLGEST THEN DO:
     MESSAGE "Cronograma cerrado ..." VIEW-AS ALERT-BOX WARNING.
     RETURN ERROR.
  END.
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


