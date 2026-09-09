&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER GUIAS FOR CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : Anulación de Comprobantes

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCia AS INTE.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT PARAMETER s-User-Id AS CHAR.

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

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
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: GUIAS B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND B-CDOCU WHERE B-CDOCU.codcia = pCodCia AND
    B-CDOCU.coddoc = pCodDoc AND
    B-CDOCU.nrodoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CDOCU THEN DO:
    pMensaje = "Comprobante " + pCodDoc + " " + pNroDoc + " no está registrado".
    RETURN 'ADM-ERROR'.
END.
IF B-CDOCU.FlgEst = "A" THEN RETURN "OK".   /* Ya está anulado */

/* *************************************************************************** */
/* Verificamos si fue rechazado por SUNAT */
/* *************************************************************************** */
DEF VAR x-estado-bizlinks AS CHAR NO-UNDO.
DEF VAR x-estado-sunat AS CHAR NO-UNDO.
DEF VAR x-estado-doc AS CHAR NO-UNDO.
DEF VAR x-cod-estado-doc AS CHAR NO-UNDO.

x-estado-bizlinks = "".
x-estado-sunat = "".
x-estado-doc = "".
x-cod-estado-doc = "".
RUN gn/p-estado-documento-electronico (INPUT B-CDOCU.CodDoc,
                                       INPUT B-CDOCU.NroDoc,
                                       INPUT B-CDOCU.CodDiv,
                                       OUTPUT x-estado-bizlinks,
                                       OUTPUT x-estado-sunat,
                                       OUTPUT x-estado-doc).
IF NUM-ENTRIES(x-estado-sunat,"|") > 0 THEN x-cod-estado-doc = CAPS(ENTRY(1,x-estado-sunat,"|")).

IF TRUE <> (x-estado-doc > "") OR x-cod-estado-doc = "RC_05" THEN DO:
    /* Si ha sido rechazado por SUNAT entonces se anula de todas maneras */
    /*RUN _Anula_Comprobante.*/
    RUN _Anula_Comprobante (ROWID(B-CDOCU)).

    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    RETURN 'OK'.
END.
/* *************************************************************************** */
/* Cierre Contable */
/* *************************************************************************** */
DEF VAR dFchCie AS DATE NO-UNDO.

/* Sunat por defecto */
dFchCie = TODAY - 3.
/* Contable por defecto */
FIND FIRST cb-peri WHERE cb-peri.codcia = pCodCia AND 
    cb-peri.periodo = YEAR(B-CDOCU.FchDoc)
    NO-LOCK NO-ERROR.
IF AVAILABLE cb-peri AND cb-peri.MesCie[MONTH(B-CDOCU.FchDoc) + 1] = YES THEN DO:
    dFchCie = ADD-INTERVAL(B-CDOCU.FchDoc, 1, 'month').
    dFchCie = dFchCie - DAY(dFchCie) + 1.
END.
/*RUN gn/fecha-de-cierre (OUTPUT dFchCie).*/
IF B-CDOCU.fchdoc < dFchCie THEN DO:
    pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
        'NO se puede anular ningun comprobante antes del ' + STRING(dFchCie + 1) + CHR(10) +
        'por limitaciones de SUNAT***'.
    RETURN 'ADM-ERROR'.
END.
/* *************************************************************************** */
/* Canje por letra */
/* *************************************************************************** */
IF B-CDOCU.FlgSit = "X" THEN DO:
    pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
        "Tiene un CANJE por LETRA en trámite".
    RETURN "ADM-ERROR".
END.
/* *************************************************************************** */
/* Verificamos si se encuentra registrado, una de sus guias, en una H/R */
/* *************************************************************************** */
DEF VAR pHojRut   AS CHAR.
DEF VAR pFlgEst-1 AS CHAR.
DEF VAR pFlgEst-2 AS CHAR.
DEF VAR pFchDoc   AS DATE.

FOR EACH GUIAS NO-LOCK WHERE GUIAS.CodCia = B-CDOCU.codcia
    AND GUIAS.CodDoc = "G/R"
    AND GUIAS.CodRef = B-CDOCU.coddoc
    AND GUIAS.NroRef = B-CDOCU.nrodoc
    AND GUIAS.FlgEst <> 'A':
    RUN dist/p-rut002 ("G/R",
                       GUIAS.coddoc,
                       GUIAS.nrodoc,
                       "",
                       "",
                       "",
                       0,
                       0,
                       OUTPUT pHojRut,
                       OUTPUT pFlgEst-1,     /* de Di-RutaC */
                       OUTPUT pFlgEst-2,     /* de Di-RutaG */
                       OUTPUT pFchDoc).
    /* 01/03/2024: Verificar el estado de la GR en la HR */
    /*              N: no entegrado
                    T: devolución parcial
    */                    
    /*IF pHojRut > '' AND pFlgEst-1 <> "A" THEN DO:*/
    IF pHojRut > '' AND pFlgEst-1 <> "A" AND LOOKUP(pFlgEst-2, 'N,T') = 0 THEN DO:
        pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
            "La " + GUIAS.coddoc + " " + GUIAS.nrodoc + " se encuentra registrada en la H/R " + pHojRut.
        RETURN 'ADM-ERROR'.
    END.
END.

/* ************************************************************************************************ */
/* 01/03/2024: Rastreo por GRE */
/* ************************************************************************************************ */
FIND FIRST gre_header WHERE gre_header.m_coddoc = B-CDOCU.CodDoc AND
    gre_header.m_nroser = INTEGER(SUBSTRING(B-CDOCU.NroDOc,1,3)) AND
    gre_header.m_nrodoc = INTEGER(SUBSTRING(B-CDOCU.NroDOc,4))
    NO-LOCK NO-ERROR.
/*MESSAGE 'dos' INTEGER(SUBSTRING(B-CDOCU.NroDOc,1,3)) INTEGER(SUBSTRING(B-CDOCU.NroDOc,4)).*/
IF AVAILABLE gre_header AND LOOKUP(gre_header.m_rspta_sunat, 'ACEPTADO POR SUNAT') > 0 THEN DO:
    /*MESSAGE 'tres' gre_header.m_rspta_sunat.*/
    pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
        "La " + "G/R" + " " + STRING(gre_header.serieGuia,'999') + STRING(gre_header.numeroGuia, '9999999999') +
        " se encuentra ACEPTADO POR SUNAT".
    RETURN 'ADM-ERROR'.
END.
/* ************************************************************************************************ */

/* *************************************************************************** */
/* Amortizaciones */
/* *************************************************************************** */
DEF VAR x-Adelantos AS DEC NO-UNDO.

x-Adelantos = 0.
FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = B-CDOCU.codcia
    AND Ccbdcaja.coddoc = 'A/C'
    AND Ccbdcaja.codref = B-CDOCU.coddoc
    AND Ccbdcaja.nroref = B-CDOCU.nrodoc :
    x-Adelantos = x-Adelantos + CcbDCaja.ImpTot.
END.
IF LOOKUP(B-CDOCU.FmaPgo, "899,900") = 0 THEN DO:          /* NO TRANSFERENCIA GRATUITA */
    /* B-CDOCU.ImpTot2 : Aplicaciones de anticipos de campaña A/C */
    IF B-CDOCU.SdoAct <> ((B-CDOCU.ImpTot + B-CDOCU.ImpTot2) - x-Adelantos) THEN DO:
        pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
            'Registra amortizaciones'.
        RETURN 'ADM-ERROR'.
    END.
END.
/* *************************************************************************** */
/* Consistencia N/C y N/D */
/* *************************************************************************** */
FIND FIRST GUIAS WHERE GUIAS.codcia = B-CDOCU.codcia
    AND LOOKUP(GUIAS.coddoc, 'N/C,N/D') > 0
    AND GUIAS.codref = B-CDOCU.coddoc
    AND GUIAS.nroref = B-CDOCU.nrodoc
    AND GUIAS.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF AVAILABLE GUIAS THEN DO:
    pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
        "Es referenciado por la " + GUIAS.coddoc + " " + GUIAS.nrodoc.
    RETURN 'ADM-ERROR'.
END.
/* *************************************************************************** */
/* Devolución de mercadería */
/* *************************************************************************** */
FIND FIRST B-DDOCU OF B-CDOCU WHERE B-DDOCU.CanDev > 0 NO-LOCK NO-ERROR.
IF AVAILABLE B-DDOCU THEN DO:
    pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
        "Tiene una devolución de mercadería".
    RETURN "ADM-ERROR".
END.
/* ******************************************************************** */
/* RHC 09/07/2015 NO se puede anular un comprobante cuyo TpoFac = "FAI" */
/* ******************************************************************** */
DEF VAR x-Lista AS CHAR NO-UNDO.
DEF VAR x-FAIs  AS CHAR NO-UNDO.

x-Lista = ''.
/* 1er caso: Por Referencia */
CASE TRUE:
    WHEN B-CDOCU.CodRef = "FAI" AND B-CDOCU.NroRef > '' THEN DO:
        x-FAIs = B-CDOCU.NroRef.     /* Delimitados por "|" */
        x-Lista = ''.
        FOR EACH GUIAS NO-LOCK WHERE GUIAS.codcia = B-CDOCU.codcia
            AND GUIAS.codref = B-CDOCU.codref       /* FAI */
            AND GUIAS.nroref = B-CDOCU.nroref
            AND GUIAS.coddoc = B-CDOCU.coddoc       /* FAC */
            AND GUIAS.codcli = B-CDOCU.codcli
            AND GUIAS.flgest <> 'A':
            x-Lista = x-Lista + (IF x-Lista = '' THEN '' ELSE CHR(10)) +
                GUIAS.coddoc + ' ' + GUIAS.nrodoc.
        END.
    END.
    WHEN B-CDOCU.CodRef = "FAI" AND (TRUE <> (B-CDOCU.NroRef > '')) THEN DO:
        x-FAIs = ''.
        x-Lista = B-CDOCU.coddoc + ' ' + B-CDOCU.nrodoc.    /* Valor por defecto */
        FOR EACH GUIAS NO-LOCK WHERE GUIAS.CodCia = B-CDOCU.CodCia 
            AND GUIAS.CodDoc = "FAI" 
            AND GUIAS.CodCli = B-CDOCU.CodCli 
            AND GUIAS.FlgEst = "C" 
            AND GUIAS.Libre_c03 = B-CDOCU.CodDoc    /* FAC */
            AND GUIAS.Libre_c04 = B-CDOCU.NroDoc:
            x-FAIs = x-FAIs + (IF TRUE <> (x-FAIs > '') THEN '' ELSE '|') + GUIAS.NroDoc.
        END.
    END.
    OTHERWISE DO:
        x-FAIs = "".
        x-Lista = B-CDOCU.coddoc + ' ' + B-CDOCU.nrodoc.    /* Valor por defecto */
    END.
END CASE.
/* *************************************************************************** */
/* LOGICA PRINCIPAL */
/* *************************************************************************** */
DEF VAR k AS INTE NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    DO k = 1 TO NUM-ENTRIES(x-Lista,CHR(10)):
        FIND B-CDOCU WHERE B-CDOCU.codcia = pCodCia
            AND B-CDOCU.coddoc = ENTRY(1,ENTRY(k, x-Lista, CHR(10)),' ')
            AND B-CDOCU.nrodoc = ENTRY(2,ENTRY(k, x-Lista, CHR(10)),' ')
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDOCU THEN DO:
            UNDO PRINCIPAL, RETURN "ADM-ERROR".
        END.
        RUN _Anula_Comprobante (ROWID(B-CDOCU)).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.

        /* Extornamos los FAIs */
        DEF VAR j AS INTE NO-UNDO.

        IF NUM-ENTRIES(x-FAIs,'|') >= 1 THEN DO j = 1 TO NUM-ENTRIES(x-FAIs,'|'):
            FIND GUIAS WHERE GUIAS.codcia = pCodCia
                AND GUIAS.coddoc = "FAI"
                AND GUIAS.nrodoc = ENTRY(j,x-FAIs,'|')
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE GUIAS THEN DO:
                UNDO PRINCIPAL, RETURN "ADM-ERROR".
            END.
            ASSIGN
                GUIAS.FlgEst = "P"
                GUIAS.SdoAct = GUIAS.ImpTot.
            FOR EACH Ccbdcaja WHERE Ccbdcaja.codcia = pCodCia
                AND Ccbdcaja.codref = GUIAS.coddoc
                AND Ccbdcaja.nroref = GUIAS.nrodoc:
                DELETE Ccbdcaja.
            END.
        END.
        RELEASE GUIAS.
    END.
END.
/* *************************************************************************** */
/* *************************************************************************** */

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-_Anula_Comprobante) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Anula_Comprobante Procedure 
PROCEDURE _Anula_Comprobante PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.

  /*DISABLE TRIGGERS FOR LOAD OF CcbCDocu.*/

  ELIMINACION:          
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      /* Bloqueamos el Comprobante */
      {lib/lock-genericov3.i ~
          &Tabla="CcbCDocu" ~
          &Condicion="ROWID(Ccbcdocu) = pRowid" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TipoError= "UNDO, RETURN 'ADM-ERROR'" ~
          }
      /* TRACKING FACTURAS */
      RUN vtagn/pTracking-04 (pCodCia,
                              CcbCDocu.CodDiv,
                              CcbCDocu.CodPed,
                              CcbCDocu.NroPed,
                              s-User-Id,
                              'EFAC',
                              'A',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              CcbCDocu.coddoc,
                              CcbCDocu.nrodoc,
                              CcbCDocu.codref,
                              CcbCDocu.nroref).
    
      /* EXTORNAMOS CONTROL DE PERCEPCIONES POR CARGOS */
      FOR EACH GUIAS EXCLUSIVE-LOCK WHERE GUIAS.codcia = CcbCDocu.codcia
          AND GUIAS.coddiv = CcbCDocu.coddiv
          AND GUIAS.coddoc = "PRC"
          AND GUIAS.codref = CcbCDocu.coddoc        /* FAC */
          AND GUIAS.nroref = CcbCDocu.nrodoc ON ERROR UNDO, THROW:
          DELETE GUIAS.
      END.
      IF AVAILABLE GUIAS THEN RELEASE GUIAS.
      
      /* RHC 12.07.2012 Anulamos el control de impresion en caja */
      FIND w-report WHERE w-report.Llave-I = CcbCDocu.codcia
          AND w-report.Campo-C[1] = CcbCDocu.coddoc
          AND w-report.Campo-C[2] = CcbCDocu.nrodoc      
          AND w-report.Llave-C = "IMPCAJA"
          AND w-report.Llave-D = CcbCDocu.fchdoc
          AND w-report.Task-No = INTEGER(CcbCDocu.coddiv)
          EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE w-report THEN DELETE w-report.
      
      /* ANULAMOS LA FACTURA EN PROGRESS */
      ASSIGN 
          CcbCDocu.FlgEst = "A"
          CcbCDocu.SdoAct = 0
          CcbCDocu.UsuAnu = S-USER-ID
          CcbCDocu.FchAnu = TODAY
          CcbCDocu.Glosa  = "A N U L A D O".

     /* RHC 05.10.05 Reversion de puntos bonus */
     FIND GN-CARD WHERE GN-CARD.nrocard = CcbCDocu.nrocard NO-ERROR.
     IF AVAILABLE GN-CARD THEN GN-CARD.AcuBon[10] = GN-CARD.AcuBon[10] - CcbCDocu.puntos.

     /* *********************************************************************** */
     /* RHC 12/10/2020 CONTROL MR: Control para el KPI de despachos por O/D */
     /* *********************************************************************** */
     DEFINE VAR hMaster AS HANDLE NO-UNDO.

     RUN gn/master-library PERSISTENT SET hMaster.
     RUN ML_Extorna-FAC-Control IN hMaster (INPUT ROWID(CcbCDocu),     /* FAC */
                                            OUTPUT pMensaje).
     IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
         pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) + pMensaje.
         UNDO, RETURN 'ADM-ERROR'.
     END.
     /* *********************************************************************** */
     /* RHC 14/10/2020 CONTROL MR: Control de kardex FIFO */
     /* *********************************************************************** */
     RUN ML_Extorna-Fifo-Control IN hMaster (INPUT ROWID(CcbCDocu),     /* FAC */
                                            OUTPUT pMensaje).
     IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
         pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) + pMensaje.
         UNDO, RETURN 'ADM-ERROR'.
     END.
     DELETE PROCEDURE hMaster.
     /* *********************************************************************** */
     /* *********************************************************************** */
     /* HAY RUTINAS QUE NO SE DEBEN HACER SI ES UNA FACTURA POR FAI */
     /* *********************************************************************** */
      IF CcbCDocu.CodRef = "FAI" THEN LEAVE.
     /* *********************************************************************** */
     /* *********************************************************************** */
      
      /* DESCARGA ALMACENES */
      RUN vta2/des_alm (ROWID(CcbCDocu)).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
              "No se pudo actualizar los saldos del almacén".
          UNDO, RETURN 'ADM-ERROR'.
      END.
      
      /* RHC 14/12/2015 FACTURAS SUPERMERCADOS -> PLAZA VEA */
      IF CcbCDocu.CndCre = "PLAZA VEA" THEN DO:
          /* RHC 12/12/2015 Actualizamos saldos */
          DEF VAR x-CanDes AS DEC NO-UNDO.
          DEF VAR x-CanAte AS DEC NO-UNDO.

          /* Barremos el control */
          FOR EACH ControlOD EXCLUSIVE-LOCK WHERE ControlOD.CodCia = pCodCia
              AND ControlOD.CodDiv = CcbCDocu.coddiv         /*s-coddiv*/
              AND ControlOD.NroFac = CcbCDocu.nrodoc ON ERROR UNDO, THROW:
              FOR EACH B-DDOCU OF CcbCDocu NO-LOCK:
                  x-CanDes = B-DDOCU.candes.
                  FOR EACH Vtaddocu EXCLUSIVE-LOCK WHERE VtaDDocu.CodCia = ControlOD.codcia
                      AND VtaDDocu.CodDiv = ControlOD.coddiv
                      AND VtaDDocu.CodPed = ControlOD.coddoc
                      AND VtaDDocu.NroPed = ControlOD.nrodoc
                      AND VtaDDocu.Libre_c01 = ControlOD.nroetq
                      AND VtaDDocu.CodMat = B-DDOCU.codmat,
                      FIRST Facdpedi EXCLUSIVE-LOCK WHERE Facdpedi.codcia = pCodCia
                      AND Facdpedi.coddoc = Vtaddocu.codped
                      AND Facdpedi.nroped = Vtaddocu.nroped
                      AND Facdpedi.codmat = Vtaddocu.codmat,
                      FIRST Faccpedi EXCLUSIVE-LOCK WHERE Faccpedi.codcia = Facdpedi.codcia
                      AND Faccpedi.coddiv = Facdpedi.coddiv
                      AND Faccpedi.coddoc = Facdpedi.coddoc
                      AND Faccpedi.nroped = Facdpedi.nroped ON ERROR UNDO, THROW:
                      x-CanAte = MINIMUM(VtaDDocu.CanAte, x-CanDes).
                      VtaDDocu.CanAte = VtaDDocu.CanAte - x-CanAte.
                      Facdpedi.CanAte = Facdpedi.CanAte - x-CanAte.
                      x-CanDes = x-CanDes - x-CanAte.
                      Faccpedi.FlgEst = "P".
                      IF x-CanDes <= 0 THEN LEAVE.
                  END.  /* Vtaddocu */
              END.  /* B-DDOCU */
              ASSIGN
                  ControlOD.NroFac = ''
                  ControlOD.FchFac = ?
                  ControlOD.UsrFac = ''.
          END.      /* ControlOD */
          IF AVAILABLE ControlOD THEN RELEASE ControlOD.
          IF AVAILABLE Faccpedi THEN RELEASE Faccpedi.
          IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
      END.
      ELSE DO:
          /* ACTUALIZAMOS ORDEN DE DESPACHO */
          IF CcbCDocu.Libre_c01 = 'O/D' THEN DO:
              FIND FIRST Faccpedi WHERE Faccpedi.codcia = CcbCDocu.codcia
                  AND Faccpedi.coddoc = CcbCDocu.Libre_c01
                  AND Faccpedi.nroped = CcbCDocu.Libre_c02
                  EXCLUSIVE-LOCK NO-ERROR.              
              IF NOT AVAILABLE Faccpedi THEN DO:                  
                  pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
                      "NO se pudo actualizar la ".
                  IF NOT (TRUE <> (CcbCDocu.Libre_c01 > "")) THEN pMensaje = pMensaje + " " + CcbCDocu.Libre_c01.
                  IF NOT (TRUE <> (CcbCDocu.Libre_c02 > "")) THEN pMensaje = pMensaje + " " + CcbCDocu.Libre_c02.
                  UNDO ELIMINACION, RETURN "ADM-ERROR".
              END.
              FOR EACH Ccbddocu OF CcbCDocu NO-LOCK:
                  FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK WHERE Facdpedi.codmat = Ccbddocu.codmat
                      ON ERROR UNDO, THROW:
                      Facdpedi.CanAte = (Facdpedi.CanAte -  Ccbddocu.CanDes).
                      IF Facdpedi.CanAte < 0  THEN Facdpedi.CanAte = 0.
                  END.
              END.
              ASSIGN Faccpedi.FlgEst = "P".
              IF AVAILABLE faccpedi THEN RELEASE Faccpedi.
              IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
          END.
      END.
      
      /* RHC 10.12.2010 ACTUALIZAMOS FACTURA ADELANTADA */
      RUN vtagn/p-extorna-factura-adelantada ( ROWID(CcbCDocu) ).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = "ERROR: Comprobante " + pCodDoc + " " + pNroDoc + CHR(10) +
              "No se pudo extornar las facturas adelantadas".
          UNDO, RETURN 'ADM-ERROR'.
      END.

      /* ANULAMOS LA GUIA DE REMISION */
      FOR EACH GUIAS EXCLUSIVE-LOCK WHERE GUIAS.CodCia = pCodCia
          AND GUIAS.CodDoc = "G/R"
          AND GUIAS.CodRef = CcbCDocu.CodDoc
          AND GUIAS.NroRef = CcbCDocu.NroDoc
          AND GUIAS.FlgEst = "F" ON ERROR UNDO, THROW:
          ASSIGN 
              GUIAS.FlgEst = "A"
              GUIAS.SdoAct = 0
              GUIAS.UsuAnu = S-USER-ID
              GUIAS.FchAnu = TODAY
              GUIAS.Glosa  = "A N U L A D O".
      END.
      IF AVAILABLE GUIAS THEN RELEASE GUIAS.
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

