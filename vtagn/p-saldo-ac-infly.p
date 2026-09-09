&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-FacCPedi FOR FacCPedi.
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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
  DEF OUTPUT PARAMETER x-Saldo AS DECI.

  DEF SHARED VAR s-codcia AS INTE.

  FIND b-Faccpedi WHERE ROWID(b-Faccpedi) = pRowid NO-LOCK NO-ERROR.
  IF NOT AVAILABLE b-Faccpedi OR b-Faccpedi.TpoLic = NO THEN RETURN.

  /* Control de Facturas Adelantadas */
  DEFINE VARIABLE x-ImpTot AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpPED AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpOD  AS DECI NO-UNDO.
  DEFINE VARIABLE x-ImpAC  AS DECI NO-UNDO.

  ASSIGN
      x-Saldo = 0
      x-ImpTot = 0.

  /* 1ro Buscamos los A/C por aplicar pero que tengan la misma moneda que el pedido */
  ASSIGN
      x-ImpAC = 0.
  FOR EACH Ccbcdocu USE-INDEX Llave06 NO-LOCK WHERE Ccbcdocu.codcia = b-Faccpedi.codcia
      AND Ccbcdocu.codcli = b-Faccpedi.CodCli
      AND Ccbcdocu.flgest = "P"
      AND Ccbcdocu.coddoc = "A/C"
      AND Ccbcdocu.CodMon = b-Faccpedi.CodMon:
      IF Ccbcdocu.SdoAct > 0 
          THEN ASSIGN 
                    x-Saldo = x-Saldo + Ccbcdocu.SdoAct 
                    x-ImpAC = x-ImpAC + Ccbcdocu.SdoAct.
  END.
  IF x-Saldo <= 0 THEN DO:
      RETURN.
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
              AND PEDIDO.codcli = b-Faccpedi.codcli:
              IF NOT (PEDIDO.fchven >= TODAY
                      AND PEDIDO.codmon = b-Faccpedi.codmon
                      AND PEDIDO.TpoLic = YES) 
                  THEN NEXT.
              x-Saldo = x-Saldo - PEDIDO.imptot.
              x-ImpPED = x-ImpPED + PEDIDO.ImpTot.
          END.
      END.
  END.

  ASSIGN
      x-ImpOD = 0.
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia,
      EACH ORDEN NO-LOCK WHERE ORDEN.codcia = s-codcia 
      AND ORDEN.coddiv = gn-divi.coddiv
      AND ORDEN.coddoc = "O/D"
      AND ORDEN.codcli = b-Faccpedi.codcli
      AND ORDEN.flgest = "P"
      AND ORDEN.codmon = b-Faccpedi.codmon,
      FIRST PEDIDO NO-LOCK WHERE PEDIDO.codcia = ORDEN.codcia
      AND PEDIDO.coddoc = ORDEN.codref
      AND PEDIDO.nroped = ORDEN.nroref:
      IF PEDIDO.TpoLic = NO THEN NEXT.
      x-Saldo = x-Saldo - ORDEN.imptot.
      x-ImpOD = x-ImpOD + ORDEN.ImpTot.
  END.
  
  IF x-Saldo <= 0 THEN x-Saldo = 0.

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
      TABLE: b-FacCPedi B "?" ? INTEGRAL FacCPedi
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


