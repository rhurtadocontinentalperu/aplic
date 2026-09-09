&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DDET LIKE cb-ddetr.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR lh_handle AS HANDLE.

DEF BUFFER B-CDET FOR Cb-cdetr.

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
&Scoped-define EXTERNAL-TABLES cb-cdetr
&Scoped-define FIRST-EXTERNAL-TABLE cb-cdetr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-cdetr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-cdetr.NroLot cb-cdetr.Fchdoc ~
cb-cdetr.CodMon cb-cdetr.Observaciones 
&Scoped-define ENABLED-TABLES cb-cdetr
&Scoped-define FIRST-ENABLED-TABLE cb-cdetr
&Scoped-Define DISPLAYED-FIELDS cb-cdetr.NroLot cb-cdetr.Fchdoc ~
cb-cdetr.CodMon cb-cdetr.usuario cb-cdetr.Observaciones 
&Scoped-define DISPLAYED-TABLES cb-cdetr
&Scoped-define FIRST-DISPLAYED-TABLE cb-cdetr
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado 

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
DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-cdetr.NroLot AT ROW 1.19 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     FILL-IN-Estado AT ROW 1.19 COL 39 COLON-ALIGNED
     cb-cdetr.Fchdoc AT ROW 1.19 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     cb-cdetr.CodMon AT ROW 2.15 COL 13 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .81
     cb-cdetr.usuario AT ROW 2.15 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     cb-cdetr.Observaciones AT ROW 3.12 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 2.35 COL 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.cb-cdetr
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DDET T "SHARED" ? INTEGRAL cb-ddetr
   END-TABLES.
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
         HEIGHT             = 3.88
         WIDTH              = 89.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{aplic/cbd/cbglobal.i}
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

/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cdetr.usuario IN FRAME F-Main
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
  {src/adm/template/row-list.i "cb-cdetr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-cdetr"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-DDET:
    DELETE T-DDET.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Borra-Temporal.
  FOR EACH cb-ddetr OF Cb-cdetr NO-LOCK:
    CREATE T-DDET.
    BUFFER-COPY Cb-ddetr TO T-DDET.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Constancia-de-detraccion V-table-Win 
PROCEDURE Constancia-de-detraccion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE cb-cdetr OR cb-cdetr.flgest <> "C" THEN RETURN ERROR.

/* solicitamos el archivo texto */
DEF VAR x-Archivo AS CHAR.
DEF VAR l-Archivo AS CHAR.
DEF VAR rpta AS LOG.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS '*.txt' '*.txt'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    DEFAULT-EXTENSION 'txt'
    MUST-EXIST
    RETURN-TO-START-DIR
    TITLE 'Archivo SUNAT CONSTANCIA DE DETRACCION'
    UPDATE rpta.
IF rpta = NO THEN RETURN.
x-Archivo = SEARCH(x-Archivo).
IF x-Archivo = ? THEN DO:
    MESSAGE 'Archivo errado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
/* eliminamos caracteres especiales */
/* RUN lib/fileold-to-filenew (x-Archivo, OUTPUT l-Archivo). */
/* x-Archivo = l-Archivo.                                    */

/* verificamos si es el correcto */
DEF VAR x-linea AS CHAR FORMAT 'x(100)'.

INPUT FROM VALUE(x-Archivo).
REPEAT:
    IMPORT UNFORMATTED x-linea.
    IF x-linea = 'CONSTANCIA DE DEPOSITO MASIVO' THEN LEAVE.
END.
IF x-linea <> 'CONSTANCIA DE DEPOSITO MASIVO' THEN DO:
    MESSAGE 'Archivo errado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* comienza la carga */
DEF VAR x-NroConstancia AS CHAR.
DEF VAR x-RucProveedor  AS CHAR.
DEF VAR x-CodigoBien    AS CHAR.
DEF VAR x-MontoDeposito AS CHAR.
DEF VAR f-MontoDeposito AS DEC.
DEF VAR x-Texto         AS CHAR.

INPUT FROM VALUE(x-Archivo).
REPEAT:
    IMPORT UNFORMATTED x-linea.
    x-Texto = 'Numero de operacion'.
    IF x-linea BEGINS x-Texto THEN DO:
        FOR EACH cb-ddetr OF cb-cdetr:
            cb-ddetr.Sunat_NroOperacion = TRIM(SUBSTRING(x-linea, LENGTH(x-Texto) + 1)).
        END.
    END.
    x-Texto = 'Numero de constancia'.
    IF x-linea BEGINS x-Texto THEN x-NroConstancia = TRIM(SUBSTRING(x-linea, LENGTH(x-Texto) + 1)).
    x-Texto = 'RUC Proveedor'.
    IF x-linea BEGINS x-Texto THEN x-RucProveedor = TRIM(SUBSTRING(x-linea, LENGTH(x-Texto) + 1)).
    x-Texto = 'Codigo bien o servicio'.
    IF x-linea BEGINS x-Texto THEN x-CodigoBien = TRIM(SUBSTRING(x-linea, LENGTH(x-Texto) + 1)).
    x-Texto = 'Monto deposito'.
    IF x-linea BEGINS x-Texto THEN x-MontoDeposito = TRIM(SUBSTRING(x-linea, LENGTH(x-Texto) + 1)).
    IF x-linea BEGINS 'Monto deposito' THEN DO:
        ASSIGN
            f-MontoDeposito = DECIMAL(x-MontoDeposito)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
            LEAVE.
        END.
        /* buscamos el registro */
        FOR EACH cb-ddetr OF cb-cdetr WHERE cb-ddetr.CodBien = x-CodigoBien,
            FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = cb-ddetr.CodPro
            AND gn-prov.Ruc = x-RucProveedor:
            IF ABSOLUTE (ROUND(cb-ddetr.ImpDep, 0) - f-MontoDeposito) <= 1 
                THEN cb-ddetr.Sunat_NroConstancia = x-NroConstancia.
        END.
    END.
END.
INPUT CLOSE.
RUN Procesa-Handle IN lh_handle ('browse').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Numero AS INT NO-UNDO.

  x-Numero = INTEGER(SUBSTRING(STRING(s-Periodo, '9999'), 3, 2) + '0001').
  FIND LAST B-CDET WHERE B-CDET.codcia = s-codcia
        AND B-CDET.periodo = s-periodo
        NO-LOCK NO-ERROR.
  IF AVAILABLE B-CDET THEN x-Numero = B-CDET.NroLot + 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY     
        x-Numero @ cb-cdetr.NroLot
        TODAY @ cb-cdetr.Fchdoc
        s-user-id @ cb-cdetr.usuario.
  END.
  RUN Borra-Temporal.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
  RUN Procesa-Handle IN lh_handle ('browse-add').

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
  ASSIGN
    Cb-cdetr.ImpTot = 0.
  FOR EACH Cb-ddetr OF Cb-cdetr:
    DELETE Cb-ddetr.
  END.
  FOR EACH T-DDET:
    CREATE Cb-ddetr.
    BUFFER-COPY T-DDET TO Cb-ddetr
        ASSIGN
            Cb-ddetr.codcia = Cb-cdetr.codcia
            Cb-ddetr.periodo = Cb-cdetr.periodo
            Cb-ddetr.nrolot = Cb-cdetr.nrolot.
    Cb-cdetr.ImpTot = Cb-cdetr.ImpTot + cb-ddetr.ImpDep.
  END.
  
  RUN Procesa-Handle IN lh_handle ('pagina1').
  RUN Procesa-Handle IN lh_handle ('browse').
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  RUN Procesa-Handle IN lh_handle ('Pagina1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Numero AS INT NO-UNDO.
  
  x-Numero = INTEGER(SUBSTRING(STRING(s-Periodo, '9999'), 3, 2) + '0001').
  FIND LAST B-CDET WHERE B-CDET.codcia = s-codcia
        AND B-CDET.periodo = s-periodo
        EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-CDET THEN x-Numero = B-CDET.NroLot + 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    cb-cdetr.CodCia = s-codcia
    cb-cdetr.Periodo = s-periodo
    cb-cdetr.NroLot = x-Numero
    cb-cdetr.usuario = s-user-id.
  RELEASE B-CDET.
  
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
  IF cb-cdetr.FlgEst <> 'P' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.
  FOR EACH Cb-ddetr OF Cb-cdetr:
    DELETE Cb-ddetr.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  IF AVAILABLE Cb-cdetr THEN DO WITH FRAME {&FRAME-NAME}:
    CASE Cb-cdetr.flgest:
        WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'Emitido'.
        WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'Aprobado'.
        WHEN 'C' THEN FILL-IN-Estado:SCREEN-VALUE = 'Cerrado'.
        OTHERWISE FILL-IN-Estado:SCREEN-VALUE = ''.
    END.
  END.

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
  DO WITH FRAME {&FRAME-NAME}:
    cb-cdetr.Fchdoc:SENSITIVE = NO.
    cb-cdetr.NroLot:SENSITIVE = NO.
    cb-cdetr.CodMon:SENSITIVE = NO.
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
  DEF VAR s-print-ok AS LOG INIT NO NO-UNDO.
  DEF VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.
  DEF VAR i AS INT NO-UNDO.
  DEF VAR x-ImpDep AS DEC NO-UNDO.
  
  IF NOT AVAILABLE Cb-cdetr THEN RETURN.
  x-Moneda = IF cb-cdetr.codmon = 1 THEN 'S/.' ELSE 'US$'.
  
  SYSTEM-DIALOG PRINTER-SETUP 
  UPDATE s-print-ok.
  
  IF s-print-ok = NO THEN RETURN.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE FRAME f-Detalle
      /*cb-ddetr.CodPro     COLUMN-LABEL 'Proveedor'*/
      gn-prov.ruc         COLUMN-LABEL 'Proveedor'
      gn-prov.nompro    FORMAT 'x(40)'
      cb-ddetr.CtaPro 
      cb-ddetr.ImpDep
      cb-ddetr.CodBien 
      cb-ddetr.TipOpe
      cb-ddetr.Provi_Periodo COLUMN-LABEL 'Periodo'
      cb-ddetr.Provi_Nromes COLUMN-LABEL 'Mes'
      cb-ddetr.Provi_Codope COLUMN-LABEL 'Operacion'
      cb-ddetr.Provi_NroAst COLUMN-LABEL 'Asiento'
    WITH NO-BOX STREAM-IO WIDTH 320 DOWN.

  DEFINE FRAME f-Header
    HEADER
        S-NOMCIA FORMAT "X(45)" SKIP
        "DETRACCIONES A PROVEEDORES POR DEPOSITAR EN EL BCO DE LA NACION" AT 20 SKIP
        "LOTE:" TO 17 cb-cdetr.NroLot 
        "FECHA DE EMISION:" TO 100 cb-cdetr.fchdoc SKIP
        "MONEDA:" TO 17 x-Moneda SKIP
        "OBSERVACIONES:" TO 17 cb-cdetr.observaciones SKIP(1)
        WITH PAGE-TOP NO-LABEL NO-UNDERLINE NO-BOX STREAM-IO WIDTH 146 DOWN.

  OUTPUT TO PRINTER PAGE-SIZE 30.
  PUT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN4}.    
  DO i = 1 TO 2:
    x-ImpDep = 0.
    FOR EACH Cb-ddetr OF Cb-cdetr NO-LOCK,
          FIRST Gn-prov NO-LOCK WHERE Gn-prov.codcia = pv-codcia
              AND Gn-prov.codpro = cb-ddetr.CodPro:
      VIEW FRAME f-Header.
      DISPLAY  
          /*cb-ddetr.CodPro*/
          gn-prov.ruc
          gn-prov.nompro
          cb-ddetr.CtaPro 
          cb-ddetr.ImpDep
          cb-ddetr.CodBien 
          cb-ddetr.TipOpe
          cb-ddetr.Provi_Periodo 
          cb-ddetr.Provi_Nromes 
          cb-ddetr.Provi_Codope 
          cb-ddetr.Provi_NroAst
          WITH FRAME f-Detalle.
        x-ImpDep = x-ImpDep + cb-ddetr.ImpDep.
    END.
    PUT '----------' AT 78 SKIP.
    PUT x-ImpDep FORMAT '>>>,>>9.99' AT 78 SKIP.
    PAGE.
  END.
  OUTPUT CLOSE.
  
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
  {src/adm/template/snd-list.i "cb-cdetr"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto V-table-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo Aprobados
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR FORMAT 'x(22)' NO-UNDO.
  DEF VAR x-Ok AS LOG NO-UNDO.
  DEF VAR x-Importe AS DEC INIT 0.
  DEF VAR x-Ruc AS CHAR FORMAT 'x(11)' NO-UNDO.
  
  IF NOT AVAILABLE Cb-cdetr OR Cb-cdetr.flgest <> "A" THEN RETURN.

  FIND gn-cias WHERE gn-cias.codcia = s-codcia NO-LOCK.
  x-Ruc = GN-CIAS.LIBRE-C[1].
  /*x-Archivo = 'D' + '20100038146' + STRING(Cb-cdetr.nrolot, '999999') + '.txt'.*/
  x-Archivo = 'D' + STRING(x-Ruc, 'x(11)') + STRING(Cb-cdetr.nrolot, '999999') + '.txt'.
                
  SYSTEM-DIALOG GET-FILE x-Archivo  FILTERS '*.txt' '*.txt'  
      ASK-OVERWRITE 
      CREATE-TEST-FILE  
      DEFAULT-EXTENSION 'txt'  
      RETURN-TO-START-DIR 
      SAVE-AS  
      TITLE 'Guardar como...' 
      USE-FILENAME  
      UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.

  MESSAGE 'Este es el archivo definitivo para la SUNAT?' SKIP(1)
      '(Si es afirmativo se procederá a cerrar la detracción)'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = YES THEN DO:
      FIND CURRENT Cb-cdetr EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Cb-cdetr THEN RETURN ERROR.
      ASSIGN
          Cb-cdetr.FlgEst = 'C'.
      FIND CURRENT Cb-cdetr NO-LOCK NO-ERROR.
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  END.
  /* Cabecera */
  OUTPUT TO VALUE(x-Archivo).
  /*PUT '*' '20100038146' */
  PUT '*' x-Ruc
    SUBSTRING(s-nomcia, 1, 35) FORMAT 'x(35)' 
    STRING(Cb-cdetr.nrolot, '999999') FORMAT 'x(6)'
    STRING(Cb-cdetr.ImpTot * 100, '999999999999999') FORMAT 'x(15)'
    SKIP.
  /* Detalle */
  FOR EACH Cb-ddetr OF Cb-cdetr NO-LOCK,
      FIRST Gn-prov NO-LOCK WHERE Gn-prov.codcia = pv-codcia
        AND Gn-prov.codpro = Cb-ddetr.codpro
      BREAK BY cb-ddetr.codpro 
            BY cb-ddetr.codbien 
            BY cb-ddetr.tipope 
            BY cb-ddetr.Periodo
            BY cb-ddetr.Provi_Periodo 
            BY cb-ddetr.Provi_NroMes
            BY cb-ddetr.Provi_CodOpe:
      ACCUMULATE cb-ddetr.impdep (SUB-TOTAL BY cb-ddetr.codpro 
                                  BY cb-ddetr.codbien 
                                  BY cb-ddetr.tipope 
                                  BY cb-ddetr.Periodo
                                  BY cb-ddetr.Provi_Periodo 
                                  BY cb-ddetr.Provi_Nromes 
                                  BY cb-ddetr.Provi_Codope ).
      x-Importe = x-Importe + cb-ddetr.impdep.
      IF LAST-OF(cb-ddetr.codpro) OR 
          LAST-OF(cb-ddetr.codbien) OR 
          LAST-OF(cb-ddetr.tipope) OR 
          LAST-OF(cb-ddetr.Periodo) OR
          LAST-OF(cb-ddetr.Provi_Periodo) OR
          LAST-OF(cb-ddetr.Provi_NroMes) OR
          LAST-OF(cb-ddetr.Provi_CodOpe)
          THEN DO:
          /*x-Importe = ACCUM SUB-TOTAL BY cb-ddetr.tipope cb-ddetr.impdep.*/
          PUT 
              STRING(gn-prov.Ruc, 'x(11)')        FORMAT 'x(11)'
              STRING(cb-ddetr.Proforma, 'x(9)')   FORMAT 'x(9)'
              STRING(cb-ddetr.CodBien, 'x(3)')    FORMAT 'x(3)'
              STRING(cb-ddetr.CtaPro, 'x(11)')    FORMAT 'x(11)'
              /*STRING(cb-ddetr.ImpDep * 100, '999999999999999')    FORMAT 'x(15)'*/
              STRING(x-Importe * 100, '999999999999999')    FORMAT 'x(15)'
              STRING(cb-ddetr.TipOpe, 'x(2)')     FORMAT 'x(2)'
              STRING(cb-ddetr.Provi_Periodo, '9999') FORMAT 'x(4)'
              STRING(cb-ddetr.Provi_Nromes, '99') FORMAT 'x(2)'
              SKIP.
          x-Importe = 0.
      END.
  END.              
  OUTPUT CLOSE.
  MESSAGE 'LISTO' VIEW-AS ALERT-BOX INFORMATION.
 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
  IF LOOKUP(cb-cdetr.FlgEst, 'P,C') = 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('pagina2').
  IF cb-cdetr.flgest = "C" THEN RUN Procesa-Handle IN lh_handle ('pagina3').
  RUN Procesa-Handle IN lh_handle ('browse-add').
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

