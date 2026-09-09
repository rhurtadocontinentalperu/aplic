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
DEFINE SHARED VAR s-CodCia  AS INT.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR s-User-Id AS CHAR.
DEFINE SHARED VAR cl-CodCia AS INT.

DEFINE VAR s-Copia-Registro AS LOG.
DEFINE TEMP-TABLE T-DACTI LIKE VtaDActi.

DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES VtaCActi
&Scoped-define FIRST-EXTERNAL-TABLE VtaCActi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCActi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCActi.CodActi VtaCActi.DesActi ~
VtaCActi.FechaD VtaCActi.FechaH 
&Scoped-define ENABLED-TABLES VtaCActi
&Scoped-define FIRST-ENABLED-TABLE VtaCActi
&Scoped-Define DISPLAYED-FIELDS VtaCActi.CodActi VtaCActi.FchActi ~
VtaCActi.DesActi VtaCActi.Usuario VtaCActi.FechaD VtaCActi.FechaH 
&Scoped-define DISPLAYED-TABLES VtaCActi
&Scoped-define FIRST-DISPLAYED-TABLE VtaCActi


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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fVtaTot V-table-Win 
FUNCTION fVtaTot RETURNS DECIMAL
  ( INPUT pCodCli AS CHAR,
    INPUT pDesde AS DATE,
    INPUT pHasta AS DATE,
    INPUT pMoneda AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaCActi.CodActi AT ROW 1.19 COL 15 COLON-ALIGNED
          LABEL "Código de Actividad"
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     VtaCActi.FchActi AT ROW 1.19 COL 74 COLON-ALIGNED
          LABEL "Fecha de Creación"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     VtaCActi.DesActi AT ROW 2.15 COL 15 COLON-ALIGNED
          LABEL "Descripción"
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     VtaCActi.Usuario AT ROW 2.15 COL 74 COLON-ALIGNED
          LABEL "Último Usuario"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     VtaCActi.FechaD AT ROW 3.12 COL 15 COLON-ALIGNED
          LABEL "Compras desde"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     VtaCActi.FechaH AT ROW 3.12 COL 31 COLON-ALIGNED
          LABEL "Hasta"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaCActi
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
         HEIGHT             = 4.15
         WIDTH              = 94.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN VtaCActi.CodActi IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCActi.DesActi IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCActi.FchActi IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCActi.FechaD IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCActi.FechaH IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCActi.Usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME VtaCActi.CodActi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCActi.CodActi V-table-Win
ON LEAVE OF VtaCActi.CodActi IN FRAME F-Main /* Código de Actividad */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

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
  {src/adm/template/row-list.i "VtaCActi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCActi"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel V-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE VtaCActi THEN RETURN.

  DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
  DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
  DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
  DEFINE VARIABLE chChart                 AS COM-HANDLE.
  DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
  DEFINE VARIABLE iCount                  AS INTEGER init 1.
  DEFINE VARIABLE iIndex                  AS INTEGER.
  DEFINE VARIABLE cColumn                 AS CHARACTER.
  DEFINE VARIABLE cRange                  AS CHARACTER.
  DEFINE VARIABLE t-Column                AS INTEGER INIT 3.

  DEFINE VAR x-Referencias LIKE GN-CLIE.Referencias.
  
  /* create a new Excel Application object */
  CREATE "Excel.Application" chExcelApplication.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* create a new Workbook */
  chWorkbook = chExcelApplication:Workbooks:Add().

  /* get the active Worksheet */
  chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 15.
chWorkSheet:Columns("B"):ColumnWidth = 10.
chWorkSheet:Columns("C"):ColumnWidth = 60.
chWorkSheet:Columns("D"):ColumnWidth = 50.
chWorkSheet:Columns("E"):ColumnWidth = 50.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 20.
chWorkSheet:Columns("H"):ColumnWidth = 20.
chWorkSheet:Columns("I"):ColumnWidth = 10.
chWorkSheet:Columns("J"):ColumnWidth = 10.
chWorkSheet:Columns("K"):ColumnWidth = 60.
chWorkSheet:Columns("L"):ColumnWidth = 15.
chWorkSheet:Columns("M"):ColumnWidth = 60.
/* Titulo */
chWorkSheet:Range("B1"):Value = vtacacti.codacti.
chWorkSheet:Range("C1"):Value = vtacacti.desacti.

chWorkSheet:Range("A3"):Value = "Cliente".
chWorkSheet:Range("B3"):Value = "Tarjeta".
chWorkSheet:Range("C3"):Value = "Nombre o razon social".
chWorkSheet:Range("D3"):Value = "Contacto".
chWorkSheet:Range("E3"):Value = "Direccion".
chWorkSheet:Range("F3"):Value = "Departamento".
chWorkSheet:Range("G3"):Value = "Provincia".
chWorkSheet:Range("H3"):Value = "Distrito".
chWorkSheet:Range("I3"):Value = "Telefono".
chWorkSheet:Range("J3"):Value = "Division".
chWorkSheet:Range("K3"):Value = "Referencias".
chWorkSheet:Range("L3"):Value = "Compras en US$".
chWorkSheet:Range("M3"):Value = "Observaciones".
chWorkSheet:Range("N3"):Value = "Linea de Credito".
chWorkSheet:Range("O3"):Value = "Fecha de Nacimiento".
chWorkSheet:Range("P3"):Value = "Impresiones de sobres".

FOR EACH vtadacti of vtacacti WHERE NO-LOCK,
        FIRST GN-CLIE WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = vtadacti.codcli NO-LOCK:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + vtadacti.codcli.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + gn-clie.nrocard.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-clie.nomcli.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-clie.contac.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-clie.dircli.
    /* Departamento */
    FIND  TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN DO:
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = TabDepto.NomDepto.
    END.        
    /* Provincia */
    FIND  Tabprovi WHERE Tabprovi.CodDepto = gn-clie.CodDept
        AND Tabprovi.Codprovi = gn-clie.codprov
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabProvi THEN DO:
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = TabProvi.NomProvi.
    END.        
    /* Distrito */
    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-clie.CodDept
        AND Tabdistr.Codprovi = gn-clie.codprov
        AND Tabdistr.Coddistr = gn-clie.coddist
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN DO:
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = TabDistr.NomDistr.
    END.

    /* Linea de Crédito */
    dImpLCred = 0.
    lEnCampan = FALSE.
    /* Línea Crédito Campaña */
    FOR EACH Gn-ClieL WHERE
        Gn-ClieL.CodCia = gn-clie.codcia AND
        Gn-ClieL.CodCli = gn-clie.codcli AND
        Gn-ClieL.FchIni >= TODAY AND
        Gn-ClieL.FchFin <= TODAY NO-LOCK:
        dImpLCred = dImpLCred + Gn-ClieL.ImpLC.
        lEnCampan = TRUE.
    END.
    /* Línea Crédito Normal */
    IF NOT lEnCampan THEN dImpLCred = gn-clie.ImpLC.

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + gn-clie.telfnos[1].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + gn-clie.coddiv.
    x-Referencias = REPLACE(gn-clie.referencias, CHR(10), '').
    cRange = "K" + cColumn.
    /*chWorkSheet:Range(cRange):Value = gn-clie.referencias.*/
    chWorkSheet:Range(cRange):Value = x-Referencias.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDActi.ImpVtaMe.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = VtaDActi.Observaciones.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = dImpLCred.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = Gn-Clie.FnRepr.
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = Vtadacti.Estado[1].
/*    FIND Gn-Card WHERE Gn-Card.NroCard = Gn-Clie.NroCard NO-LOCK NO-ERROR.
 *     IF AVAILABLE Gn-Card THEN DO:
 *         cRange = "O" + cColumn.
 *         chWorkSheet:Range(cRange):Value = Gn-Card.FchNac[1].
 *     END.        */
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Sobres V-table-Win 
PROCEDURE Imprimir-Sobres :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAILABLE Vtacacti THEN
RUN vtamay/d-cacti (ROWID(Vtacacti)).

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
  RUN Procesa-Handle IN lh_Handle ('Pagina-2').
  s-Copia-Registro = NO.

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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN VtaCActi.FchActi = TODAY.
  ASSIGN
    VtaCActi.codcia  = s-codcia
    VtaCActi.Usuario = s-user-id.
  /* En caso de copia */
  IF s-Copia-Registro = YES
  THEN DO:
    FOR EACH T-DACTI:
        CREATE VtaDActi.
        BUFFER-COPY T-DACTI TO VtaDActi
            ASSIGN
                vtadacti.codcia  = vtacacti.codcia
                vtadacti.codacti = vtacacti.codacti.
        /* Cargamos el importe de las compras */
        ASSIGN
          VtaDActi.ImpVtaMe = fVtaTot(vtadacti.codcli, vtacacti.fechad, vtacacti.fechah, 2).
        /* ********************************** */
        DELETE T-DACTI.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina-1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH T-DACTI:
    DELETE T-DACTI.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */       
  FOR EACH VtaDActi OF VtaCActi NO-LOCK:
    CREATE T-DACTI.
    BUFFER-COPY VTaDActi TO T-DACTI.
  END.
  s-Copia-Registro = YES.
  
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
  DEF VAR RPTA AS CHAR NO-UNDO.
  
  RPTA = "ERROR".        
  RUN ALM/D-CLAVE ('111111',OUTPUT RPTA). 
  IF RPTA = "ERROR" THEN DO:
      MESSAGE "No tiene Autorizacion Para Anular"
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN 'ADM-ERROR'.
  END.

  FIND FIRST VtaDActi OF VtaCActi NO-LOCK NO-ERROR.
  IF AVAILABLE VtaDActi
  THEN DO:
    MESSAGE "CUIDADO!!!" SKIP "Usted va a borrar TODA la actividad" SKIP
        "Desea continuar?" VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE rpta-1 AS LOG.
    IF rpta-1 = NO THEN RETURN 'ADM-ERROR'.
  END.
  FOR EACH VtaDActi OF VtaCActi:
    DELETE VtaDActi.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO'
  THEN DO WITH FRAME {&FRAME-NAME}: 
    ASSIGN  
        VtaCActi.CodActi:SENSITIVE = NO
        /*
        VtaCActi.FechaD:SENSITIVE = NO
        VtaCActi.FechaH:SENSITIVE = NO
        */   .
    APPLY 'ENTRY':U TO VtaCActi.DesActi.
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
  RUN Procesa-Handle IN lh_Handle ('Pagina-1').

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
  {src/adm/template/snd-list.i "VtaCActi"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
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
  DO WITH FRAME {&FRAME-NAME}:
    IF VtaCActi.CodActi:SCREEN-VALUE = ''
    THEN DO:
        MESSAGE 'Ingrese un código de actividad' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO VtaCActi.CodActi.
        RETURN 'ADM-ERROR'.
    END.
  END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
  RUN Procesa-Handle IN lh_Handle ('Pagina-2').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fVtaTot V-table-Win 
FUNCTION fVtaTot RETURNS DECIMAL
  ( INPUT pCodCli AS CHAR,
    INPUT pDesde AS DATE,
    INPUT pHasta AS DATE,
    INPUT pMoneda AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR x-TotVta   AS DECIMAL INIT 0 NO-UNDO.
  DEF VAR x-NroFch-1 AS INTEGER NO-UNDO.
  DEF VAR x-NroFch-2 AS INTEGER NO-UNDO.
  DEF VAR x-Dia      AS INTEGER NO-UNDO.
  DEF VAR x-Dia-1    AS DATE NO-UNDO.
  DEF VAR x-Dia-2    AS DATE NO-UNDO.
  DEF VAR x-Fecha    AS DATE NO-UNDO.
  
  x-NroFch-1 = YEAR(pDesde) * 100 + MONTH(pDesde).
  x-NroFch-2 = YEAR(pHasta) * 100 + MONTH(pHasta).

  FOR EACH GN-DIVI NO-LOCK WHERE gn-divi.codcia = s-codcia:
    FOR EACH EvtClie NO-LOCK WHERE evtclie.codcia = s-codcia
            AND evtclie.coddiv = gn-divi.coddiv
            AND evtclie.codcli = pCodCli
            AND evtclie.nrofch >= x-NroFch-1
            AND evtclie.nrofch <= x-NroFch-2:
        RUN bin/_dateif (EvtClie.Codmes, 
                        EvtClie.Codano, 
                        OUTPUT x-Dia-1,
                        OUTPUT x-Dia-2).
        DO x-Dia = 1 TO DAY(x-Dia-2):
            x-fecha = date(evtclie.codmes, x-dia, evtclie.codano).
            FIND LAST Gn-tcmb WHERE Gn-tcmb.Fecha <= x-fecha NO-LOCK NO-ERROR.
            IF x-fecha >= pDesde
                AND x-fecha <= pHasta
            THEN DO:
                IF pMoneda = 1
                THEN ASSIGN
                        x-TotVta = x-TotVta + EvtClie.VtaxDiaMn[x-Dia] +
                                            EvtClie.Vtaxdiame[x-Dia] * Gn-Tcmb.Venta.
                ELSE ASSIGN
                        x-TotVta = x-TotVta + EvtClie.VtaxDiaMe[x-Dia] +
                                            EvtClie.Vtaxdiamn[x-Dia] / Gn-Tcmb.Compra.
            END.
        END.
    END.        
  END.
  RETURN x-TotVta.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

