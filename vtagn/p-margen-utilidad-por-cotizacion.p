&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Determinar el margen de utilidad de la venta

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* PARAMETROS */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pVerError AS LOG.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.        /* Se relaciona con el parámetro pVerError */

pError = "OK".

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

/* RHC 24.07.2014 Verifica margen mínimo por división */
FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
    /*AND gn-divi.coddiv = Faccpedi.coddiv*/
    AND gn-divi.coddiv = Faccpedi.Lista_de_Precios
    NO-LOCK NO-ERROR.
IF NOT (AVAILABLE gn-divi AND gn-divi.Libre_L02 = YES
    AND gn-divi.Libre_D02 > 0) THEN RETURN.

IF Faccpedi.TpoPed = "E" THEN RETURN.   /* EVENTOS */

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
         HEIGHT             = 4.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* ACUMULAMOS LOS MARGENES DE UTRILIDAD Y EVALUAMOS EL TOTAL */

DEF VAR pMonVta AS INT NO-UNDO.
DEF VAR pCosto  AS DEC NO-UNDO.
DEF VAR pVenta  AS DEC NO-UNDO.

DEF VAR X-COSTO AS DEC NO-UNDO.
DEF VAR X-MARGEN AS DEC NO-UNDO.
DEF VAR X-LIMITE AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

ASSIGN
    pMonVta = Faccpedi.CodMon
    pCosto  = 0
    pVenta  = 0.

FOR EACH Facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = Facdpedi.UndVta:
    IF pMonVta = 1 THEN DO:
       IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-COSTO = (Almmmatg.Ctotot).
       ELSE
          ASSIGN 
              X-COSTO = (Almmmatg.Ctotot) * Almmmatg.TpoCmb.     /*pTpoCmb.*/
    END.        
    IF pMonVta = 2 THEN DO:
       IF Almmmatg.MonVta = 2 THEN
          ASSIGN X-COSTO = (Almmmatg.Ctotot).
       ELSE
          ASSIGN X-COSTO = (Almmmatg.Ctotot) / Almmmatg.TpoCmb.     /*pTpoCmb .*/
    END.      
    ASSIGN
        f-Factor = Almtconv.Equival / Almmmatg.FacEqu
        pVenta = pVenta + Facdpedi.ImpLin
        pCosto = pCosto + ( X-COSTO / f-Factor * Facdpedi.CanPed ).
END.
ASSIGN
    X-MARGEN = ( (pVenta / pCosto) - 1 ) * 100.


IF X-MARGEN < gn-divi.Libre_D02 THEN DO:
    IF pVerError = YES 
        THEN MESSAGE 'MARGEN DE UTILIDAD MUY BAJO' SKIP
            'El margen es de' x-Margen '%, no debe ser menor a' gn-divi.Libre_D02 '%'
            VIEW-AS ALERT-BOX WARNING.
    pError = "ADM-ERROR".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


