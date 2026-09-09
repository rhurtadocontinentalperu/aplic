&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEF SHARED VAR s-Periodo AS INT.
DEF VAR l-CodPln AS INT.
DEF VAR l-CodPln-m AS INT.

DEFINE VARIABLE db-work AS CHARACTER NO-UNDO.

DEFINE VARIABLE FILL-IN-msj   AS CHARACTER FORMAT "X(256)":U 
    VIEW-AS FILL-IN SIZE 45.57 BY .81 NO-UNDO.

DEFINE FRAME F-mensaje
    FILL-IN-msj AT ROW 1.73 COL 2 NO-LABEL
    "Procesando para:" VIEW-AS TEXT
    SIZE 12.72 BY .5 AT ROW 1.15 COL 2
    SPACE(34.13) SKIP(1.19)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE FONT 4
    TITLE "Espere un momento por favor..." CENTERED.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-Periodo Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE x-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 8 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     x-Periodo AT ROW 1.96 COL 16 COLON-ALIGNED
     Btn_OK AT ROW 1.5 COL 52
     Btn_Cancel AT ROW 2.69 COL 52
     SPACE(1.13) SKIP(1.95)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "REPORTE DEL PERSONAL CONSOLIDADO  ANUAL"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* REPORTE DEL PERSONAL CONSOLIDADO  ANUAL */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
    ASSIGN x-Periodo.

    DEFINE VARIABLE L-OK AS LOGICAL.
    DEFINE VARIABLE db-model AS CHARACTER NO-UNDO.

    IF CONNECTED( "db-work") THEN DISCONNECT db-work.
    FILE-INFO:FILE-NAME = ".".
   
    GET-KEY-VALUE SECTION "Planillas" KEY "Directorio de programas" VALUE db-model.

    db-model = db-model + "db-work".
    db-work = SESSION:TEMP-DIRECTORY + "db-work.db".
    CREATE DATABASE db-work FROM db-model REPLACE.
    CONNECT VALUE( db-work ) -1 -ld db-work.

    L-OK = NO.
  
    /*RUN Carga-Temporal.*/
    RUN pln/p-dbwork (x-Periodo).
    
    IF CONNECTED( "db-work") THEN DISCONNECT db-work.
    
    RUN pln/w-rpl-3( "Maestro", TRUE, 3, "" ).
    
    IF CONNECTED( "db-work") THEN DISCONNECT db-work.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add-Mensual D-Dialog 
PROCEDURE Add-Mensual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    l-CodPln-m = 1.
    FOR EACH integral.PL-FLG-MES WHERE
        integral.PL-FLG-MES.codcia  = S-codcia AND
        integral.PL-FLG-MES.periodo = x-periodo AND
        integral.PL-FLG-MES.codpln  = L-codpln-m AND
        integral.PL-FLG-MES.nromes  >= 1 AND
        integral.PL-FLG-MES.nromes  <= 12:
        RUN pl-mensual.
    END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PfCias D-Dialog 
PROCEDURE ADD-PfCias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
/*
    Compa¤¡a
*/

    FIND integral.PF-CIAS WHERE integral.PF-CIAS.CodCia = S-CodCia NO-LOCK.
    CREATE DB-WORK.PF-CIAS.
    ASSIGN 
        db-work.PF-CIAS.CodCia  = integral.PF-CIAS.CodCia
        db-work.PF-CIAS.DirCia  = integral.PF-CIAS.DirCia
        db-work.PF-CIAS.NomCia  = integral.PF-CIAS.NomCia
        db-work.PF-CIAS.RegPat  = integral.PF-CIAS.RegPat
        db-work.PF-CIAS.RucCia  = integral.PF-CIAS.RucCia
        db-work.PF-CIAS.TlflCia = integral.PF-CIAS.TlflCia.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PL-AFP D-Dialog 
PROCEDURE ADD-PL-AFP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
/*
    AFP
*/

    FOR EACH integral.PL-AFPS NO-LOCK:
        CREATE DB-WORK.PL-AFPS.
        DB-WORK.PL-AFPS.codafp                  = integral.PL-AFPS.codafp.
        DB-WORK.PL-AFPS.Comision-Fija-AFP       = integral.PL-AFPS.Comision-Fija-AFP.
        DB-WORK.PL-AFPS.Comision-Porcentual-AFP = integral.PL-AFPS.Comision-Porcentual-AFP.
        DB-WORK.PL-AFPS.desafp                  = integral.PL-AFPS.desafp.
        DB-WORK.PL-AFPS.Fondo-AFP               = integral.PL-AFPS.Fondo-AFP.
        DB-WORK.PL-AFPS.Seguro-Invalidez-AFP    = integral.PL-AFPS.Seguro-Invalidez-AFP.
        DB-WORK.PL-AFPS.banco                   = integral.PL-AFPS.banco.
        DB-WORK.PL-AFPS.ctacte-afp              = integral.PL-AFPS.nroctacte-afp.
        DB-WORK.PL-AFPS.ctacte-fondo            = integral.PL-AFPS.nroctacte-fondo.
    END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PL-CFG D-Dialog 
PROCEDURE ADD-PL-CFG :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
/*
    Configuración
*/

    DEFINE VARIABLE L-DesPln AS CHARACTER.

    L-CodPln = 0.
    L-DesPln = "".
    CREATE DB-WORK.PL-CFG.
    ASSIGN
        DB-WORK.PL-CFG.CodCia   = S-CodCia
        DB-WORK.PL-CFG.Periodo  = S-Periodo
        DB-WORK.PL-CFG.CodPln   = L-CodPln
        DB-WORK.PL-CFG.DesPln   = L-DesPln.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-SEMANAL D-Dialog 
PROCEDURE ADD-SEMANAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    l-CodPln = 2.
    FOR EACH integral.PL-FLG-SEM WHERE
        integral.PL-FLG-SEM.codcia  = s-codcia AND
        integral.PL-FLG-SEM.periodo = x-periodo AND
        integral.PL-FLG-SEM.codpln  = l-codpln AND
        integral.PL-FLG-SEM.nrosem  >= 1 AND
        integral.PL-FLG-SEM.nrosem  <= 52:
        RUN pl-semanal.
    END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    RUN add-semanal.
    RUN add-mensual.

    RUN add-pl-cfg.
    RUN add-pfcias.
    RUN add-pl-afp.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY x-Periodo 
      WITH FRAME D-Dialog.
  ENABLE x-Periodo Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
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
    FOR EACH CB-PERI WHERE CB-PERI.codcia = s-codcia NO-LOCK:
        x-Periodo:ADD-LAST(STRING(CB-PERI.Periodo, '9999')).
    END.
    x-Periodo:DELETE(1).
    x-Periodo:SCREEN-VALUE = STRING(s-Periodo, '9999').
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PL-Mensual D-Dialog 
PROCEDURE PL-Mensual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
/*
    Planilla mensual
*/

    DEFINE VARIABLE x-nromes AS INTEGER.
    DEFINE VARIABLE x-valcal AS DECIMAL.
    
    /* CREANDO EL REGISTRO TEMPORAL DE PERSONAL */
    FIND db-work.PL-PERS WHERE
        db-work.PL-PERS.codper = integral.PL-FLG-MES.codper EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE db-work.PL-PERS THEN CREATE DB-WORK.PL-PERS.
    ASSIGN
        db-work.PL-PERS.codper       = integral.PL-FLG-MES.codper
        db-work.PL-PERS.codpln       = integral.PL-FLG-MES.codpln
        db-work.PL-PERS.cargos       = integral.PL-FLG-MES.cargos 
        db-work.PL-PERS.ccosto       = integral.PL-FLG-MES.ccosto 
        db-work.PL-PERS.Clase        = integral.PL-FLG-MES.Clase 
        db-work.PL-PERS.cnpago       = integral.PL-FLG-MES.cnpago 
        db-work.PL-PERS.nrodpt       = integral.PL-FLG-MES.nrodpt
        db-work.PL-PERS.codafp       = integral.PL-FLG-MES.codafp 
        db-work.PL-PERS.CodDiv       = integral.PL-FLG-MES.CodDiv 
        db-work.PL-PERS.Conyugue     = integral.PL-FLG-MES.Conyugue 
        db-work.PL-PERS.fecing       = integral.PL-FLG-MES.fecing 
        db-work.PL-PERS.finvac       = integral.PL-FLG-MES.finvac 
        db-work.PL-PERS.CTS          = integral.PL-FLG-MES.CTS 
        db-work.PL-PERS.nrodpt-cts   = integral.PL-FLG-MES.nrodpt-cts 
        db-work.PL-PERS.inivac       = integral.PL-FLG-MES.inivac 
        db-work.PL-PERS.Nro-de-Hijos = integral.PL-FLG-MES.Nro-de-Hijos 
        db-work.PL-PERS.nroafp       = integral.PL-FLG-MES.nroafp 
        db-work.PL-PERS.Proyecto     = integral.PL-FLG-MES.Proyecto 
        db-work.PL-PERS.seccion      = integral.PL-FLG-MES.seccion
        db-work.PL-PERS.SitAct       = integral.PL-FLG-MES.SitAct 
        db-work.PL-PERS.vcontr       = integral.PL-FLG-MES.vcontr.

    FIND integral.PL-PROY WHERE
        integral.PL-PROY.PROYECTO = integral.PL-FLG-MES.PROYECTO NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PROY THEN
        ASSIGN db-work.PL-PERS.RegPat = integral.PL-PROY.RegPat.

    FIND integral.PL-AFPS WHERE
        integral.PL-AFPS.CODAFP = integral.PL-FLG-MES.CODAFP NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-AFPS THEN
        ASSIGN db-work.PL-PERS.AFP = integral.PL-AFPS.DesAfp.

    FIND integral.PL-CTS WHERE
        integral.PL-CTS.CTS = integral.PL-FLG-MES.CTS NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CTS THEN
        ASSIGN db-work.PL-PERS.MONEDA-CTS = integral.PL-CTS.MONEDA-CTS.

    FIND integral.PL-PERS WHERE
        integral.PL-PERS.codper = integral.PL-FLG-MES.codper NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PERS THEN DO:
        db-work.PL-PERS.CodBar    = integral.PL-PERS.CodBar.
        db-work.PL-PERS.CodCia    = s-codcia.
        db-work.PL-PERS.ctipss    = integral.PL-PERS.ctipss.
        db-work.PL-PERS.dirper    = integral.PL-PERS.dirper.
        db-work.PL-PERS.distri    = integral.PL-PERS.distri.
        db-work.PL-PERS.ecivil    = integral.PL-PERS.ecivil.
        db-work.PL-PERS.fecnac    = integral.PL-PERS.fecnac.
        db-work.PL-PERS.lelect    = integral.PL-PERS.NroDocId.
        db-work.PL-PERS.lmilit    = integral.PL-PERS.lmilit.
        db-work.PL-PERS.localidad = integral.PL-PERS.localidad.
        db-work.PL-PERS.matper    = integral.PL-PERS.matper.
        db-work.PL-PERS.nacion    = integral.PL-PERS.nacion.
        db-work.PL-PERS.nomper    = integral.PL-PERS.nomper.
        db-work.PL-PERS.patper    = integral.PL-PERS.patper.
        db-work.PL-PERS.profesion = integral.PL-PERS.profesion.
        db-work.PL-PERS.provin    = integral.PL-PERS.provin.
        db-work.PL-PERS.sexper    = integral.PL-PERS.sexper.
        db-work.PL-PERS.telefo    = integral.PL-PERS.telefo.
        db-work.PL-PERS.titulo    = integral.PL-PERS.titulo.
        db-work.PL-PERS.TpoPer    = integral.PL-PERS.TpoPer.
    END.

    FILL-IN-msj = db-work.PL-PERS.codper + " " +
        db-work.PL-PERS.PATPER + " " +
        db-work.PL-PERS.MATPER + ", " +
        db-work.PL-PERS.NOMPER.

    DISPLAY FILL-IN-msj WITH FRAME F-mensaje.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PL-Semanal D-Dialog 
PROCEDURE PL-Semanal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
/*
    Crea registros de semana
*/
    DEFINE VARIABLE x-nrosem AS INTEGER.
    DEFINE VARIABLE x-valcal AS DECIMAL.

    /* CREANDO EL REGISTRO TEMPORAL DE PERSONAL */
    FIND db-work.PL-PERS WHERE
        db-work.PL-PERS.codper = integral.PL-FLG-SEM.codper EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE db-work.PL-PERS THEN CREATE DB-WORK.PL-PERS.
    ASSIGN
        db-work.PL-PERS.codper       = integral.PL-FLG-SEM.codper
        db-work.PL-PERS.codpln       = integral.PL-FLG-SEM.codpln
        db-work.PL-PERS.cargos       = integral.PL-FLG-SEM.cargos 
        db-work.PL-PERS.ccosto       = integral.PL-FLG-SEM.ccosto 
        db-work.PL-PERS.Clase        = integral.PL-FLG-SEM.Clase 
        db-work.PL-PERS.cnpago       = integral.PL-FLG-SEM.cnpago 
        db-work.PL-PERS.nrodpt       = integral.PL-FLG-SEM.nrodpt
        db-work.PL-PERS.codafp       = integral.PL-FLG-SEM.codafp 
        db-work.PL-PERS.CodDiv       = integral.PL-FLG-SEM.CodDiv 
        db-work.PL-PERS.Conyugue     = integral.PL-FLG-SEM.Conyugue 
        db-work.PL-PERS.fecing       = integral.PL-FLG-SEM.fecing 
        db-work.PL-PERS.finvac       = integral.PL-FLG-SEM.finvac 
        db-work.PL-PERS.CTS          = integral.PL-FLG-SEM.CTS 
        db-work.PL-PERS.nrodpt-cts   = integral.PL-FLG-SEM.nrodpt-cts 
        db-work.PL-PERS.inivac       = integral.PL-FLG-SEM.inivac 
        db-work.PL-PERS.Nro-de-Hijos = integral.PL-FLG-SEM.Nro-de-Hijos 
        db-work.PL-PERS.nroafp       = integral.PL-FLG-SEM.nroafp 
        db-work.PL-PERS.Proyecto     = integral.PL-FLG-SEM.Proyecto 
        db-work.PL-PERS.seccion      = integral.PL-FLG-SEM.seccion
        db-work.PL-PERS.SitAct       = integral.PL-FLG-SEM.SitAct 
        db-work.PL-PERS.vcontr       = integral.PL-FLG-SEM.vcontr.

    FIND integral.PL-PROY WHERE
        integral.PL-PROY.PROYECTO = integral.PL-FLG-SEM.proyecto NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PROY THEN
        ASSIGN db-work.PL-PERS.RegPat = integral.PL-PROY.RegPat.

    FIND integral.PL-CTS WHERE
        integral.PL-CTS.CTS = integral.PL-FLG-SEM.CTS NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CTS THEN
        ASSIGN db-work.PL-PERS.MONEDA-CTS = integral.PL-CTS.MONEDA-CTS.

    FIND integral.PL-AFPS WHERE
        integral.PL-AFPS.CODAFP = integral.PL-FLG-MES.CODAFP NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-AFPS THEN
        ASSIGN db-work.PL-PERS.AFP = integral.PL-AFPS.DesAfp.

    FIND integral.PL-PERS WHERE
        integral.PL-PERS.codper = integral.PL-FLG-SEM.codper NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-PERS THEN DO:
        db-work.PL-PERS.CodBar    = integral.PL-PERS.CodBar.
        db-work.PL-PERS.CodCia    = s-codcia.
        db-work.PL-PERS.ctipss    = integral.PL-PERS.ctipss.
        db-work.PL-PERS.dirper    = integral.PL-PERS.dirper.
        db-work.PL-PERS.distri    = integral.PL-PERS.distri.
        db-work.PL-PERS.ecivil    = integral.PL-PERS.ecivil.
        db-work.PL-PERS.fecnac    = integral.PL-PERS.fecnac.
        db-work.PL-PERS.lelect    = integral.PL-PERS.NroDocId.
        db-work.PL-PERS.lmilit    = integral.PL-PERS.lmilit.
        db-work.PL-PERS.localidad = integral.PL-PERS.localidad.
        db-work.PL-PERS.matper    = integral.PL-PERS.matper.
        db-work.PL-PERS.nacion    = integral.PL-PERS.nacion.
        db-work.PL-PERS.nomper    = integral.PL-PERS.nomper.
        db-work.PL-PERS.patper    = integral.PL-PERS.patper.
        db-work.PL-PERS.profesion = integral.PL-PERS.profesion.
        db-work.PL-PERS.provin    = integral.PL-PERS.provin.
        db-work.PL-PERS.sexper    = integral.PL-PERS.sexper.
        db-work.PL-PERS.telefo    = integral.PL-PERS.telefo.
        db-work.PL-PERS.titulo    = integral.PL-PERS.titulo.
        db-work.PL-PERS.TpoPer    = integral.PL-PERS.TpoPer.
    END.

    FILL-IN-msj = db-work.PL-PERS.codper + " " +
        db-work.PL-PERS.PATPER + " " +
        db-work.PL-PERS.MATPER + ", " +
        db-work.PL-PERS.NOMPER.

    DISPLAY FILL-IN-msj WITH FRAME F-mensaje.

*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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


