&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


DEFINE INPUT PARAMETER x-Periodo AS INT.

DEF SHARED VAR s-codcia AS INT.
/*DEF SHARED VAR s-Periodo AS INT.*/
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


/* ***************************  Main Block  *************************** */

    RUN add-semanal.
    RUN add-mensual.

    RUN add-pl-cfg.
    RUN add-pfcias.
    RUN add-pl-afp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add-Mensual Procedure 
PROCEDURE Add-Mensual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    l-CodPln-m = 1.
    FOR EACH integral.PL-FLG-MES WHERE
        integral.PL-FLG-MES.codcia  = S-codcia AND
        integral.PL-FLG-MES.periodo = x-periodo AND
        integral.PL-FLG-MES.codpln  = L-codpln-m AND
        integral.PL-FLG-MES.nromes  >= 1 AND
        integral.PL-FLG-MES.nromes  <= 12:
        RUN pl-mensual.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PFCIAS Procedure 
PROCEDURE ADD-PFCIAS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PL-AFP Procedure 
PROCEDURE ADD-PL-AFP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ADD-PL-CFG Procedure 
PROCEDURE ADD-PL-CFG :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    Configuración
*/

    DEFINE VARIABLE L-DesPln AS CHARACTER.

    L-CodPln = 0.
    L-DesPln = "".
    CREATE DB-WORK.PL-CFG.
    ASSIGN
        DB-WORK.PL-CFG.CodCia   = S-CodCia
/*        DB-WORK.PL-CFG.Periodo  = S-Periodo*/
        DB-WORK.PL-CFG.Periodo  = x-Periodo
        DB-WORK.PL-CFG.CodPln   = L-CodPln
        DB-WORK.PL-CFG.DesPln   = L-DesPln.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Add-Semanal Procedure 
PROCEDURE Add-Semanal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    l-CodPln = 2.
    FOR EACH integral.PL-FLG-SEM WHERE
        integral.PL-FLG-SEM.codcia  = s-codcia AND
        integral.PL-FLG-SEM.periodo = x-periodo AND
        integral.PL-FLG-SEM.codpln  = l-codpln AND
        integral.PL-FLG-SEM.nrosem  >= 1 AND
        integral.PL-FLG-SEM.nrosem  <= 52:
        RUN pl-semanal.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PL-Mensual Procedure 
PROCEDURE PL-Mensual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PL-Semanal Procedure 
PROCEDURE PL-Semanal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


