&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* RHC 09/02/17 Luis Urbano solo para condciones de pago 403 */
  ASSIGN
    Faccpedi.TpoLic = NO.

  FIND FIRST gn-convt WHERE gn-ConVt.Codig = Faccpedi.FmaPgo NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-convt OR gn-ConVt.Libre_l03 = NO THEN RETURN 'OK'.

  /* Control de Facturas Adelantadas */
  DEFINE VARIABLE x-Saldo  AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpTot AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpPED AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpOD  AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpAC  AS DECI NO-UNDO.
  DEFIN BUFFER b-Faccpedi FOR Faccpedi.

  ASSIGN
      x-Saldo = 0
      x-ImpTot = 0.
  FOR EACH Reporte NO-LOCK, FIRST b-Faccpedi NO-LOCK WHERE b-Faccpedi.codcia = s-codcia
      AND b-Faccpedi.coddoc = Reporte.coddoc
      AND b-Faccpedi.nroped = Reporte.nroped:
      x-ImpTot = x-ImpTot + b-Faccpedi.ImpTot.
  END.
  /* 1ro Buscamos los A/C por aplicar pero que tengan la misma moneda que el pedido */
  ASSIGN
      pMensajeFinal = ''
      x-ImpAC = 0.
  FOR EACH Ccbcdocu USE-INDEX Llave06 NO-LOCK WHERE Ccbcdocu.codcia = Faccpedi.codcia
      AND Ccbcdocu.codcli = Faccpedi.CodCli
      AND Ccbcdocu.flgest = "P"
      AND Ccbcdocu.coddoc = "A/C"
      AND Ccbcdocu.CodMon = Faccpedi.CodMon:
      IF Ccbcdocu.SdoAct > 0 
          THEN ASSIGN 
                    x-Saldo = x-Saldo + Ccbcdocu.SdoAct 
                    x-ImpAC = x-ImpAC + Ccbcdocu.SdoAct.
  END.

  /* Ajustamos el saldo del A/C */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN x-Saldo = x-Saldo + x-ImpTot.

  IF x-Saldo <= 0 THEN DO:
      pMensaje = "NO hay A/C por aplicar".
      RETURN 'ADM-ERROR'.
  END.
  /* 2do Buscamos PED y O/D en trámite */
  DEF VAR x-EstadosValidos AS CHAR NO-UNDO.
  DEF VAR x-FlgEst AS CHAR NO-UNDO.
  DEF VAR k AS INTE NO-UNDO.

  ASSIGN
      x-EstadosValidos = "G,X,T,W,WX,WL,WC,P".
  ASSIGN
      x-ImpPED = 0.
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
      DO k = 1 TO NUM-ENTRIES(x-EstadosValidos):
          x-FlgEst = ENTRY(k, x-EstadosValidos).
          FOR EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia 
              AND PEDIDO.coddiv = gn-divi.coddiv
              AND PEDIDO.coddoc = "PED"
              AND PEDIDO.flgest = x-FlgEst
              AND PEDIDO.codcli = Faccpedi.codcli:
              IF NOT (PEDIDO.fchven >= TODAY
                      AND PEDIDO.codmon = Faccpedi.codmon
                      AND PEDIDO.TpoLic = YES) 
                  THEN NEXT.
              x-Saldo = x-Saldo - PEDIDO.imptot.
              x-ImpPED = x-ImpPED + PEDIDO.ImpTot.
          END.
      END.
  END.
  /* Ajustamos el saldo de los PEDIDOS */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN x-ImpPED = x-ImpPED - x-ImpTot.

  ASSIGN
      x-ImpOD = 0.
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
      EACH ORDEN NO-LOCK WHERE ORDEN.codcia = s-codcia 
      AND ORDEN.coddiv = gn-divi.coddiv
      AND ORDEN.coddoc = "O/D"
      AND ORDEN.codcli = Faccpedi.codcli
      AND ORDEN.flgest = "P"
      /*AND ORDEN.fchven >= TODAY*/
      AND ORDEN.codmon = Faccpedi.codmon,
      FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = ORDEN.codcia
      AND PEDIDO.coddoc = ORDEN.codref
      AND PEDIDO.nroped = ORDEN.nroref:
      IF PEDIDO.TpoLic = NO THEN NEXT.
      x-Saldo = x-Saldo - ORDEN.imptot.
      x-ImpOD = x-ImpOD + ORDEN.ImpTot.
  END.
  IF x-Saldo < x-ImpTot THEN DO:
      pMensaje = "SALDO INSUFICIENTE DEL A/C" + CHR(10) + CHR(10) + 
          "Saldo del A/C:                                 " + STRING(x-ImpAC,'ZZZ,ZZZ,ZZ9.99') + CHR(10) +
          "Ped.Logísticos en trámite:             " + STRING(x-ImpPED,'ZZZ,ZZZ,ZZ9.99') + CHR(10) +
          "Ordenes de Despacho en trámite: " + STRING(x-ImpOD,'ZZZ,ZZZ,ZZ9.99') + CHR(10) +
          "---------------------------------------------------" + CHR(10) +
          "SALDO DISPONIBLE:                       " + STRING(x-Saldo,'ZZZ,ZZZ,ZZ9.99') .
      RETURN 'ADM-ERROR'.
  END.
  /* Actualizamos flag de  control */
  ASSIGN
/*       pMensajeFinal = pMensajeFinal + CHR(10) + 'Saldo Disponible: ' + (IF Faccpedi.CodMon = 1 THEN "S/." ELSE "US$") + */
/*                         STRING(x-Saldo, '>>>,>>>,>>9.99')                                                               */
      Faccpedi.TpoLic = YES.

  RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


