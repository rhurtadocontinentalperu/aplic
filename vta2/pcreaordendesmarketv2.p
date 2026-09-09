&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.
DEF BUFFER B-ADocu FOR CcbADocu.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN RETURN 'ADM-ERROR'.
IF B-CPEDI.FlgEst <> "P" THEN RETURN 'OK'.
/* FIND FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.Libre_c03 = 'Si' NO-LOCK NO-ERROR. */
/* IF NOT AVAILABLE B-DPEDI THEN RETURN 'OK'.                                     */

/* CASE B-CPEDI.coddiv:          */
/*     WHEN '00024' THEN RETURN. */
/* END CASE.                     */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.
DEFINE VARIABLE s-DiasVtoO_D LIKE GN-DIVI.DiasVtoO_D.
DEFINE VARIABLE s-NroSer AS INTEGER.

/* PARAMETROS DE COTIZACION PARA LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

DEF VAR s-coddoc AS CHAR INIT "O/D".

CASE B-CPEDI.CodDoc:
    WHEN "PED" THEN s-CodDoc = "O/D".
    WHEN "P/M" OR WHEN "PPV" THEN s-CodDoc = "O/M".
END CASE.
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Correlativo del Documento no configurado:" s-coddoc VIEW-AS ALERT-BOX WARNING.
   RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-nroser = FacCorre.NroSer.

ASSIGN
    s-FlgPicking = GN-DIVI.FlgPicking
    s-FlgBarras  = GN-DIVI.FlgBarras
    s-DiasVtoO_D = GN-DIVI.DiasVtoO_D.

FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



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
         HEIGHT             = 5.69
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FIND CURRENT B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.

      {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
      /* **************************** */
      /* NOTA: el campo Importe[1] e Importe[2] sirven para determinar el redondeo
        Importe[1]: Importe original del pedido
        Importe[2]: Importe del redondeo
        NOTA. El campo TpoLic sirve para controlar cuando se aplica o no un adelanto de campaña
      */

      BUFFER-COPY B-CPEDI 
          EXCEPT 
            B-CPEDI.TpoPed
            B-CPEDI.FlgEst
            B-CPEDI.FlgSit
          TO FacCPedi
          ASSIGN 
            FacCPedi.CodCia = S-CODCIA
            FacCPedi.CodDiv = S-CODDIV
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.CodRef = B-CPEDI.CodDoc
            FacCPedi.NroRef = B-CPEDI.NroPed
            FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
            FacCPedi.FchPed = TODAY
            FacCPedi.FchVen = TODAY + s-DiasVtoO_D
            FacCPedi.Hora = STRING(TIME,"HH:MM")
            FacCPedi.FlgEst = "P".      /* APROBADO: revisar rutine Genera-Pedido */
      ASSIGN
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
      /* TRACKING */
      RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                              Faccpedi.CodDiv,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef,
                              s-User-Id,
                              'GOD',
                              'P',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Faccpedi.CodDoc,
                              Faccpedi.NroPed,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef).
      /* ******************************** */
      ASSIGN 
          FacCPedi.UsrAprobacion = S-USER-ID
          FacCPedi.FchAprobacion = TODAY.
      ASSIGN 
          B-CPEDI.FlgEst = "C".  /* Cerramos PPV */



      /* CONTROL DE OTROS PROCESOS POR DIVISION */
      FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
          AND gn-divi.coddiv = Faccpedi.divdes
          NO-LOCK.
      ASSIGN
          s-FlgPicking = GN-DIVI.FlgPicking
          s-FlgBarras  = GN-DIVI.FlgBarras.
      IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pickear en Almacén */
      IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Picking OK */
      IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Pre-Picking OK */

      RUN Genera-Pedido.    /* Detalle del pedido */ 

      IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
      IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
      IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
      IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
      IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.
      IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.
  END.
  RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Genera-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido Procedure 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

   FOR EACH B-DPEDI OF B-CPEDI /*WHERE B-DPEDI.Libre_c03 = 'Si'*/ BY B-DPEDI.NroItm:
       /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */
       I-NITEM = I-NITEM + 1.
       CREATE FacDPedi. 
       BUFFER-COPY B-DPEDI 
           EXCEPT B-DPEDI.CanAte
           TO FacDPedi
           ASSIGN  
           FacDPedi.CodCia  = FacCPedi.CodCia 
           FacDPedi.coddiv  = FacCPedi.coddiv 
           FacDPedi.coddoc  = FacCPedi.coddoc 
           FacDPedi.NroPed  = FacCPedi.NroPed 
           FacDPedi.FchPed  = FacCPedi.FchPed
           FacDPedi.Hora    = FacCPedi.Hora 
           FacDPedi.FlgEst  = FacCPedi.FlgEst
           FacDPedi.NroItm  = I-NITEM
           FacDPedi.CanSol  = FacDPedi.CanPed
           FacDPedi.CanPick = FacDPedi.CanPed.     /* <<< OJO <<< */
       ASSIGN
           B-DPEDI.Libre_c03 = 'No'.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

