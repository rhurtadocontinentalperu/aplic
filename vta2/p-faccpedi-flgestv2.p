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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fPorAvance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPorAvance Procedure 
FUNCTION fPorAvance RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 4.19
         WIDTH              = 46.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pEstado AS CHAR.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR NO-WAIT.
IF NOT AVAILABLE Faccpedi THEN RETURN.
DEF VAR pFlgEst AS CHAR NO-UNDO.
DEF VAR pCodPed AS CHAR NO-UNDO.
ASSIGN
    pCodPed = Faccpedi.coddoc
    pFlgEst = Faccpedi.FlgEst.
pEstado = pFlgEst.
CASE pCodPed:
    WHEN 'COT' THEN DO:
        CASE pFlgEst:
            WHEN 'E' THEN pEstado = "POR APROBAR".
            WHEN 'P' THEN pEstado = "PENDIENTE".
            WHEN 'PP' THEN pEstado = "EN PROCESO".
            WHEN 'V' THEN pEstado = "VENCIDA".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "ATENDIDA TOTAL".
            WHEN 'S' THEN pEstado = "SUSPENDIDA".
            WHEN 'X' THEN pEstado = "CERRADA MANUALMENTE".
            WHEN 'T' THEN pEstado = "EN REVISION".
            WHEN 'ST' THEN pEstado = "SALDO TRANSFERIDO".
        END CASE.
/*         IF pFlgEst = "P" THEN DO:                                                               */
/*             FIND FIRST Facdpedi OF Faccpedi WHERE facdpedi.canate > 0 NO-LOCK NO-ERROR NO-WAIT. */
/*             IF AVAILABLE Facdpedi THEN pEstado = "EN PROCESO".                                  */
/*         END.                                                                                    */
/*         IF pFlgEst = "C" THEN DO:                                                               */
/*             IF fPorAvance() < 100 THEN pEstado = "EN PROCESO".                                  */
/*         END.                                                                                    */
    END.
    WHEN 'PED' THEN DO:
        CASE pFlgEst:
            WHEN 'G' THEN pEstado = "GENERADO".
            WHEN 'X' THEN pEstado = "POR APROBAR X CRED. & COB.".
            WHEN 'T' THEN pEstado = "POR APROBAR X TESORERIA".
            WHEN 'W' THEN pEstado = "POR APROBAR POR SECR. GG.".
            WHEN 'WX' THEN pEstado = "POR APROBAR POR GG.".
            WHEN 'WL' THEN pEstado = "POR APROBAR POR LOGISTICA".
            WHEN 'P' THEN pEstado = "APROBADO".
            WHEN 'V' THEN pEstado = "VENCIDO".
            WHEN 'F' THEN pEstado = "FACTURADO".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "CON ORDEN DE DESPACHO".
            WHEN 'S' THEN pEstado = "SUSPENDIDO".
            WHEN 'E' THEN pEstado = "CERRADO MANUALMENTE".
            WHEN "O" THEN pEstado = "OTR en proceso".
        END CASE.
    END.
    WHEN 'PET' THEN DO:     /* PRE-COTIZACION EXPO */
        CASE pFlgEst:
            WHEN "A" THEN pEstado = " ANULADO " .
            WHEN "C" THEN pEstado = "ATENDIDO " .
            WHEN "P" THEN pEstado = "PENDIENTE" .
            WHEN "V" THEN pEstado = " VENCIDO " .
            WHEN "X" THEN pEstado = " CERRADA " .
        END CASE.
    END.
    WHEN 'O/D' THEN DO:
        CASE pFlgEst:
            WHEN 'P' THEN pEstado = "POR FACTURAR".
            WHEN 'V' THEN pEstado = "VENCIDO".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "FACTURADO".
            WHEN 'S' THEN pEstado = "SUSPENDIDO".
            WHEN 'E' THEN pEstado = "CERRADO MANUALMENTE".
            WHEN "O" THEN pEstado = "OTR en proceso".
            WHEN "WL" THEN pEstado = "POR APROBAR LOGISTICA".
        END CASE.
    END.
    WHEN 'SUI' THEN DO: /* USO INTERNO */
        CASE pFlgEst:
            WHEN 'T' THEN pEstado = "POR APROBAR".
            WHEN 'WL' THEN pEstado = "POR APROBAR POR CONTRALORIA".
            WHEN 'P' THEN pEstado = "APROBADO".
            WHEN 'V' THEN pEstado = "VENCIDO".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "ATENDIDO TOTALMENTE".
            WHEN 'S' THEN pEstado = "SUSPENDIDO".
            WHEN 'E' THEN pEstado = "CERRADO MANUALMENTE".
        END CASE.
    END.
    OTHERWISE DO:
        CASE pFlgEst:
            WHEN 'T' THEN pEstado = "POR APROBAR".
            WHEN 'X' THEN pEstado = "POR APROBAR X CRED. & COB.".
            WHEN 'W' THEN pEstado = "POR APROBAR POR SECR. GG.".
            WHEN 'WX' THEN pEstado = "POR APROBAR POR GG.".
            WHEN 'WL' THEN pEstado = "POR APROBAR POR LOGISTICA".
            WHEN 'P' THEN pEstado = "APROBADO".
            WHEN 'V' THEN pEstado = "VENCIDO".
            WHEN 'F' THEN pEstado = "FACTURADO".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "ATENDIDO TOTALMENTE".
            WHEN 'S' THEN pEstado = "SUSPENDIDO".
            WHEN 'E' THEN pEstado = "CERRADO MANUALMENTE".
            WHEN 'G' THEN pEstado = "GENERADO".
        END CASE.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fPorAvance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPorAvance Procedure 
FUNCTION fPorAvance RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR xPorcAvance AS DEC NO-UNDO.
  DEF VAR xImpPed AS DEC NO-UNDO.
  DEF VAR xImpAte AS DEC NO-UNDO.

  DEF BUFFER PEDIDOS  FOR Faccpedi.
  DEF BUFFER FACTURAS FOR Ccbcdocu.
  DEF BUFFER CREDITOS FOR Ccbcdocu.

  /* 17/12/2014 Probemos por cantidades */
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      xImpPed = xImpPed + Facdpedi.canped.
  END.
  FOR EACH PEDIDOS NO-LOCK WHERE PEDIDOS.codcia = Faccpedi.codcia
      AND PEDIDOS.coddoc = 'PED'
      AND PEDIDOS.codref = Faccpedi.coddoc
      AND PEDIDOS.nroref = Faccpedi.nroped
      AND PEDIDOS.fchped >= Faccpedi.fchped
      AND PEDIDOS.flgest <> "A",
      EACH FACTURAS NO-LOCK WHERE FACTURAS.codcia = Faccpedi.codcia
      AND LOOKUP(FACTURAS.coddoc, 'FAC,BOL') > 0
      AND FACTURAS.flgest <> "A"
      AND FACTURAS.codped = PEDIDOS.coddoc
      AND FACTURAS.nroped = PEDIDOS.nroped
      AND FACTURAS.fchdoc >= PEDIDOS.fchped:
      FOR EACH Ccbddocu OF FACTURAS NO-LOCK:
          ASSIGN xImpAte = xImpAte + Ccbddocu.CanDes.
      END.
      FOR EACH CREDITOS NO-LOCK WHERE CREDITOS.codcia = FACTURAS.codcia
          AND CREDITOS.coddoc = "N/C"
          AND CREDITOS.codref = FACTURAS.coddoc
          AND CREDITOS.nroref = FACTURAS.nrodoc
          AND CREDITOS.cndcre = "D"
          AND CREDITOS.flgest <> "A",
          EACH Ccbddocu OF CREDITOS NO-LOCK:
          ASSIGN xImpAte = xImpAte - Ccbddocu.CanDes.
      END.
  END.
  xPorcAvance = xImpAte / xImpPed * 100.
  IF xPorcAvance < 0 THEN xPorcAvance = 0.
  IF xPorcAvance > 100 THEN xPorcAvance = 100.

  RETURN xPorcAvance.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

