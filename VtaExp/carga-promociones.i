&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  DEF VAR x-ImpTot AS DEC NO-UNDO.
  DEF VAR x-Factor AS INT NO-UNDO.
  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR i-NroItm AS INT INIT 1 NO-UNDO.
  
  /* Acumulamos los comprobantes en S/. */
  FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    FIND DDOCU WHERE DDOCU.CodCia = Facdpedi.codcia
        AND DDOCU.CodMat = Facdpedi.codmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DDOCU THEN CREATE DDOCU.
    ASSIGN
        DDOCU.CodCia = Facdpedi.codcia
        DDOCU.CodMat = Facdpedi.codmat.
    IF Faccpedi.CodMon = 1
    THEN ASSIGN
            DDOCU.ImpLin = DDOCU.ImpLin + Facdpedi.ImpLin.
    ELSE ASSIGN
            DDOCU.ImpLin = DDOCU.ImpLin + Facdpedi.ImpLin * Faccpedi.TpoCmb.
  END.

  /* PROMOCION NORMAL */
  PROMOCION:
  FOR EACH Expcprom NO-LOCK WHERE ExpCProm.CodCia = s-codcia AND ExpCProm.FlgEst = 'A'
      AND ExpCProm.CodPro <> '10005035':
    /* CIERRA PUERTAS */
      IF Faccpedi.fchped >= 01/05/2010 AND Faccpedi.fchped <= 01/06/2010 THEN DO:
          IF ExpCProm.NroDoc < 66 THEN NEXT PROMOCION.
      END.
    /* ************** */
    x-ImpTot = 0.
    FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'P':
        FIND DDOCU WHERE DDOCU.codmat = Expdprom.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DDOCU THEN NEXT.
        x-ImpTot = x-ImpTot + DDOCU.ImpLin.
    END.
    IF Expcprom.codmon = 2
    THEN x-ImpTot = x-ImpTot / Faccpedi.tpocmb.
    IF x-ImpTot < ExpCProm.Importe THEN NEXT PROMOCION.
    x-Factor = TRUNCATE(x-ImpTot / Expcprom.importe, 0).
    FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'G', 
            FIRST Almmmatg OF Expdprom NO-LOCK:
        FIND DETA WHERE DETA.Clave = 'B'
            AND DETA.CodMat = Expdprom.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE DETA THEN DO:
            CREATE DETA.
            i-NroItm = i-NroItm + 1.
            ASSIGN
                DETA.NroItm = i-NroItm.
        END.
        ASSIGN
            DETA.clave  = 'B'
            DETA.codcia = s-codcia
            DETA.codmat = Expdprom.codmat
            DETA.canped = DETA.canped + (ExpDProm.Cantidad * x-Factor)
            DETA.undvta = Almmmatg.undbas
            DETA.factor = 1.
    END.
  END.
  
  /* PROMOCION FABER */
  SELECCION:
  FOR EACH Expcprom NO-LOCK WHERE ExpCProm.CodCia = s-codcia AND ExpCProm.FlgEst = 'A'
      AND ExpCProm.CodPro = '10005035':
    /* CIERRA PUERTAS */
      IF Faccpedi.fchped >= 01/05/2010 AND Faccpedi.fchped <= 01/06/2010 THEN DO:
          IF ExpCProm.NroDoc < 66 THEN NEXT SELECCION.
      END.
    /* ************** */
    x-ImpTot = 0.
    FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'P':
        FIND DDOCU WHERE DDOCU.codmat = Expdprom.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DDOCU THEN NEXT.
        x-ImpTot = x-ImpTot + DDOCU.ImpLin.
    END.
    IF Expcprom.codmon = 2
    THEN x-ImpTot = x-ImpTot / Faccpedi.tpocmb.
/*     IF x-ImpTot < ExpCProm.Importe THEN NEXT SELECCION. */
    IF x-ImpTot > ExpCProm.Importe THEN NEXT SELECCION.
    CREATE T-PROM.
    BUFFER-COPY Expcprom TO T-PROM.
    LEAVE.
  END.
  /* barremos las promociones por proveedor */
  PROMOCION:
  FOR EACH T-PROM BREAK BY T-PROM.CodPro BY T-PROM.Importe DESC:
      IF FIRST-OF(T-PROM.CodPro) AND FIRST-OF(T-PROM.Importe) THEN DO:
/*           x-ImpTot = 0.                                                  */
/*           FOR EACH Expdprom OF T-PROM NO-LOCK WHERE Expdprom.Tipo = 'P': */
/*               FIND DDOCU WHERE DDOCU.codmat = Expdprom.codmat            */
/*                   NO-LOCK NO-ERROR.                                      */
/*               IF NOT AVAILABLE DDOCU THEN NEXT.                          */
/*               x-ImpTot = x-ImpTot + DDOCU.ImpLin.                        */
/*           END.                                                           */
/*           IF T-PROM.codmon = 2                                           */
/*           THEN x-ImpTot = x-ImpTot / Faccpedi.tpocmb.                    */
/*           x-Factor = TRUNCATE(x-ImpTot / T-PROM.importe, 0).             */
          x-Factor = 1.     /* OJO */
          FOR EACH Expdprom OF T-PROM NO-LOCK WHERE Expdprom.Tipo = 'G', 
                  FIRST Almmmatg OF Expdprom NO-LOCK:
              FIND DETA WHERE DETA.Clave = 'B'
                  AND DETA.CodMat = Expdprom.codmat EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE DETA THEN DO:
                  CREATE DETA.
                  i-NroItm = i-NroItm + 1.
                  ASSIGN
                      DETA.NroItm = i-NroItm.
              END.
              ASSIGN
                  DETA.clave  = 'B'
                  DETA.codcia = s-codcia
                  DETA.codmat = Expdprom.codmat
                  DETA.canped = DETA.canped + (ExpDProm.Cantidad * x-Factor)
                  DETA.undvta = Almmmatg.undbas
                  DETA.factor = 1.
          END.
      END.
  END.
  /* *************** */

  
  /*
  /* barremos las promociones */
  /* determinamos la mejor promocion */
  SELECCION:
  FOR EACH Expcprom NO-LOCK WHERE ExpCProm.CodCia = s-codcia AND ExpCProm.FlgEst = 'A':
    x-ImpTot = 0.
    FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'P':
        FIND DDOCU WHERE DDOCU.codmat = Expdprom.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DDOCU THEN NEXT.
        x-ImpTot = x-ImpTot + DDOCU.ImpLin.
    END.
    IF Expcprom.codmon = 2
    THEN x-ImpTot = x-ImpTot / Faccpedi.tpocmb.
    IF x-ImpTot < ExpCProm.Importe THEN NEXT SELECCION.
    CREATE T-PROM.
    BUFFER-COPY Expcprom TO T-PROM.
  END.
  /* barremos las promociones por proveedor */
  PROMOCION:
  FOR EACH T-PROM BREAK BY T-PROM.CodPro BY T-PROM.Importe DESC:
      IF FIRST-OF(T-PROM.CodPro) AND FIRST-OF(T-PROM.Importe) THEN DO:
          x-ImpTot = 0.
          FOR EACH Expdprom OF T-PROM NO-LOCK WHERE Expdprom.Tipo = 'P':
              FIND DDOCU WHERE DDOCU.codmat = Expdprom.codmat
                  NO-LOCK NO-ERROR.
              IF NOT AVAILABLE DDOCU THEN NEXT.
              x-ImpTot = x-ImpTot + DDOCU.ImpLin.
          END.
          IF T-PROM.codmon = 2
          THEN x-ImpTot = x-ImpTot / Faccpedi.tpocmb.
          x-Factor = TRUNCATE(x-ImpTot / T-PROM.importe, 0).
          FOR EACH Expdprom OF T-PROM NO-LOCK WHERE Expdprom.Tipo = 'G', 
                  FIRST Almmmatg OF Expdprom NO-LOCK:
              FIND DETA WHERE DETA.Clave = 'B'
                  AND DETA.CodMat = Expdprom.codmat EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE DETA THEN DO:
                  CREATE DETA.
                  i-NroItm = i-NroItm + 1.
                  ASSIGN
                      DETA.NroItm = i-NroItm.
              END.
              ASSIGN
                  DETA.clave  = 'B'
                  DETA.codcia = s-codcia
                  DETA.codmat = Expdprom.codmat
                  DETA.canped = DETA.canped + (ExpDProm.Cantidad * x-Factor)
                  DETA.undvta = Almmmatg.undbas
                  DETA.factor = 1.
          END.
      END.
  END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


