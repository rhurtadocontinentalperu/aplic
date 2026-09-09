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

&SCOPED-DEFINE ARITMETICA-SUNAT YES


/* ***************************  Definitions  ************************** */
DEF TEMP-TABLE PEDI NO-UNDO LIKE Facdpedi.

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER TABLE FOR PEDI. 
DEF INPUT PARAMETER pNroBultos AS INTE.     /* Bultos NUEVA OD */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = "".      /* Valor por defecto */


DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.
DEF BUFFER B-ADocu FOR CcbADocu.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN RETURN.
IF B-CPEDI.FlgEst <> "P" THEN RETURN.

DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-codcia AS INT.
DEF VAR s-coddiv AS CHAR.
DEF VAR s-coddoc AS CHAR.
DEF VAR s-NroSer AS INTEGER.
DEF VAR s-PorIgv LIKE Faccpedi.PorIgv.
DEF VAR s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEF VAR s-FlgBarras LIKE GN-DIVI.FlgBarras.
DEF VAR s-DiasVtoO_D LIKE GN-DIVI.DiasVtoO_D.

ASSIGN
    s-codcia = B-CPEDI.codcia
    s-coddiv = B-CPEDI.coddiv
    s-coddoc = B-CPEDI.coddoc
    s-nroser = INTEGER(SUBSTRING(B-CPEDI.nroped,1,3))
    s-porigv = B-CPEDI.porigv.

/* PARAMETROS DE COTIZACION PARA LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
ASSIGN
    s-FlgPicking = GN-DIVI.FlgPicking
    s-FlgBarras  = GN-DIVI.FlgBarras
    s-DiasVtoO_D = GN-DIVI.DiasVtoO_D.

FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

DEF BUFFER B-CBULT FOR Ccbcbult.

    /* Articulo impuesto a las bolas plasticas ICBPER */
    DEFINE VAR x-articulo-icbper AS CHAR.
    x-articulo-ICBPER = "099268".

DEFINE VAR dPesoTotal AS DEC.

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
    FIND CURRENT B-CPEDI EXCLUSIVE-LOCK NO-ERROR.   /* OD Original */
    IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN.

    {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
    /* **************************** */
    /* NOTA: el campo Importe[1] e Importe[2] sirven para determinar el redondeo
      Importe[1]: Importe original del pedido
      Importe[2]: Importe del redondeo
    */

 
    DEFINE VAR cNuevaOrden AS CHAR.

    CREATE FacCPedi.
    BUFFER-COPY B-CPEDI 
        TO FacCPedi
        ASSIGN 
          FacCPedi.CodDoc = s-coddoc 
          FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          /* 26/8/24: NO usar porque se cruza con MIBANCO 
          FacCPedi.Libre_c02 = B-CPEDI.CodDoc   /* Orden de despacho ORIGINAL */
          FacCPedi.Libre_c03 = B-CPEDI.NroPed
          */
          FacCPedi.Hora = STRING(TIME,"HH:MM")
          FacCPedi.Usuario = s-User-Id.

        cNuevaOrden = FacCPedi.NroPed.

    /* **************************************************************************** */
    /* 29/08/2025: Debe registrarse automáticamente a la PHR de la O/D u OTR ORIGEN */
    /* **************************************************************************** */
    /* Barremos las PHR por fecha y no anuladas */
    DEF VAR cNroDoc AS CHAR NO-UNDO.
    cNroDoc = "".
    FOR EACH Di-RutaD NO-LOCK WHERE Di-RutaD.codcia = s-codcia 
        AND Di-RutaD.coddoc = "PHR"
        AND Di-RutaD.codref = B-CPEDI.coddoc
        AND Di-RutaD.nroref = B-CPEDI.nroped
        AND Di-RutaD.coddiv = B-CPEDI.divdes,
        FIRST Di-RutaC OF Di-RutaD NO-LOCK WHERE Di-RutaC.flgest <> "A"
        BY Di-RutaD.nrodoc:
        cNroDoc = Di-RutaC.nrodoc.
    END.
    IF cNroDoc > "" THEN DO:
        FIND Di-RutaC WHERE Di-RutaC.codcia = s-codcia 
            AND Di-RutaC.coddiv = B-CPEDI.divdes
            AND Di-RutaC.coddoc = "PHR"
            AND Di-RutaC.nrodoc = cNroDoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE Di-RutaC THEN DO:
            CREATE Di-RutaD.
            BUFFER-COPY Di-RutaC TO Di-RutaD
                ASSIGN
                Di-RutaD.codref = Faccpedi.coddoc
                Di-RutaD.nroref = Faccpedi.nroped.
            RELEASE Di-RutaD.
        END.
    END.
    /* **************************************************************************** */
    /* **************************************************************************** */

    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* 26/08/2024: Nuevo control para FRACCIONAMIENTO */
    CREATE LogisLogControl.
    ASSIGN
        LogisLogControl.CodCia = s-codcia
        LogisLogControl.CodDiv = s-coddiv
        LogisLogControl.CodDoc = Faccpedi.coddoc
        LogisLogControl.NroDoc = Faccpedi.nroped
        LogisLogControl.Evento = "OD_FRACCIONADA"
        LogisLogControl.Fecha  = TODAY
        LogisLogControl.Hora   = STRING(TIME,'HH:MM:SS')
        LogisLogControl.Libre_c01 = B-CPEDI.coddoc
        LogisLogControl.Libre_c02 = B-CPEDI.nroped
        LogisLogControl.Usuario = s-user-id.
    RELEASE LogisLogControl.
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
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND Ccbadocu WHERE Ccbadocu.codcia = B-CPEDI.codcia
        AND Ccbadocu.coddiv = B-CPEDI.coddiv
        AND Ccbadocu.coddoc = B-CPEDI.coddoc
        AND Ccbadocu.nrodoc = B-CPEDI.nroped
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        CREATE B-ADOCU.
        BUFFER-COPY Ccbadocu TO B-ADOCU
            ASSIGN
              B-ADOCU.CodDiv = FacCPedi.CodDiv
              B-ADOCU.CodDoc = FacCPedi.CodDoc
              B-ADOCU.NroDoc = FacCPedi.NroPed.
    END.
    /* ******************************** */
    ASSIGN 
        FacCPedi.UsrAprobacion = S-USER-ID
        FacCPedi.FchAprobacion = TODAY.

    /* RHC 29/10/2015 Copiamos los bultos */
    /* 07/10/2023 Distrubuimos los bultos */
    BULTOS:
    FOR EACH Ccbcbult EXCLUSIVE-LOCK WHERE CcbCBult.CodCia = B-CPEDI.codcia
        AND CcbCBult.CodDoc = B-CPEDI.coddoc
        AND CcbCBult.NroDoc = B-CPEDI.nroped
        ON ERROR UNDO, THROW:
        CREATE B-CBULT.
        BUFFER-COPY Ccbcbult TO B-CBULT ASSIGN B-CBULT.NroDoc = Faccpedi.NroPed NO-ERROR.
        ASSIGN
            CcbCBult.Bultos = CcbCBult.Bultos - pNroBultos
            B-CBULT.Bultos = pNroBultos.
        IF ERROR-STATUS:ERROR = YES THEN UNDO BULTOS, NEXT BULTOS.
    END.
    /* ********************************** */

    dPesoTotal = 0.
    RUN Genera-Pedido.    /* Detalle del pedido */ 

    /* Ic - 12Nov2025, actualizar el peso */
    ASSIGN Faccpedi.peso = dPesoTotal.

    /*{vta2/graba-totales-cotizacion-cred.i}*/
    /* ****************************************************************************************** */
    /* 23/04/2024: F.Perez valores acumulados por OD al fraccionarla */
    /* ****************************************************************************************** */
    &IF {&ARITMETICA-SUNAT} &THEN
      {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
      /* ****************************************************************************************** */
      /* Importes SUNAT */
      /* ****************************************************************************************** */
      DEF VAR hProc AS HANDLE NO-UNDO.
      RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
      RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   OUTPUT pMensaje).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE PROCEDURE hProc.
    &ELSE
      {vta2/graba-totales-cotizacion-cred.i}
      /* ****************************************************************************************** */
      /* Importes SUNAT */
      /* NO graba importes Progress */
      /* ****************************************************************************************** */
      DEF VAR hProc AS HANDLE NO-UNDO.
      RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
      RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   OUTPUT pMensaje).
      IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
      DELETE PROCEDURE hProc.
    &ENDIF
    /* ****************************************************************************************** */
    /* ****************************************************************************************** */

    RUN Actualiza-Pedido.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo actualizar los importes del " + B-CPEDI.CodDoc + " " + B-CPEDI.NroPed.
        UNDO, RETURN 'ADM-ERROR'.
    END.

    IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
    IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
    IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
    IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.
    IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.

    pMensaje = "nueva orden|" + cNuevaOrden. 
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Actualiza-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido Procedure 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  /* RHC 04/02/2013 Cambiamos la lógica */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND Faccpedi WHERE ROWID(Faccpedi) = ROWID(B-CPEDI) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.
      FOR EACH PEDI, FIRST Facdpedi OF Faccpedi EXCLUSIVE-LOCK WHERE Facdpedi.codmat = PEDI.CodMat ON ERROR UNDO, THROW:
          ASSIGN Facdpedi.canped = Facdpedi.canped - PEDI.canped.
          IF Facdpedi.canped <= 0 THEN DELETE Facdpedi.
      END.
      /*{vta2/graba-totales-cotizacion-cred.i}*/
     /* ****************************************************************************************** */
     /* 23/04/2024: F.Perez valores acumulados por OD al fraccionarla */
     /* ****************************************************************************************** */
     &IF {&ARITMETICA-SUNAT} &THEN
       {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
       /* ****************************************************************************************** */
       /* Importes SUNAT */
       /* ****************************************************************************************** */
       DEF VAR hProc AS HANDLE NO-UNDO.
       RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
       RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                    INPUT Faccpedi.CodDoc,
                                    INPUT Faccpedi.NroPed,
                                    OUTPUT pMensaje).
       IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
       DELETE PROCEDURE hProc.
     &ELSE
       {vta2/graba-totales-cotizacion-cred.i}
       /* ****************************************************************************************** */
       /* Importes SUNAT */
       /* NO graba importes Progress */
       /* ****************************************************************************************** */
       DEF VAR hProc AS HANDLE NO-UNDO.
       RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
       RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                    INPUT Faccpedi.CodDoc,
                                    INPUT Faccpedi.NroPed,
                                    OUTPUT pMensaje).
       IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
       DELETE PROCEDURE hProc.
     &ENDIF
     /* ****************************************************************************************** */
     /* ****************************************************************************************** */
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido Procedure 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    

    dPesoTotal = 0.

   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

   FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK:
       IF PEDI.CanAte <= 0 THEN DO:
           DELETE PEDI.
           NEXT.
       END.
       ASSIGN
           PEDI.CanPed = PEDI.CanAte
           PEDI.CanAte = 0
           PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                                 ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                                 ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                                 ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
       IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
           THEN PEDI.ImpDto = 0.
       ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
       ASSIGN
           PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
           PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
       IF PEDI.AftIsc 
           THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
       ELSE PEDI.ImpIsc = 0.
       IF PEDI.AftIgv 
           THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
       ELSE PEDI.ImpIgv = 0.

       dPesoTotal = dPesoTotal + (PEDI.canate * PEDI.factor * almmmatg.pesmat).
   END.


   FOR EACH PEDI BY PEDI.NroItm:
       /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */
       I-NITEM = I-NITEM + 1.
       CREATE FacDPedi. 
       BUFFER-COPY PEDI 
           TO FacDPedi
           ASSIGN  
           FacDPedi.CodCia  = FacCPedi.CodCia 
           FacDPedi.coddiv  = FacCPedi.coddiv 
           FacDPedi.coddoc  = FacCPedi.coddoc 
           FacDPedi.NroPed  = FacCPedi.NroPed 
           FacDPedi.FchPed  = FacCPedi.FchPed
           FacDPedi.Hora    = FacCPedi.Hora 
           FacDPedi.FlgEst  = FacCPedi.FlgEst
           FacDPedi.NroItm  = I-NITEM.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

