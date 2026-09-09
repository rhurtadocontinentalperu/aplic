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

DEFINE INPUT PARAMETER s-codcia  LIKE integral.cb-dmov.codcia.
DEFINE INPUT PARAMETER x-CodCta  LIKE integral.cb-dmov.codcta.
DEFINE INPUT PARAMETER x-CodDiv  LIKE integral.cb-dmov.coddiv.
DEFINE INPUT PARAMETER x-Periodo LIKE integral.cb-dmov.periodo.
DEFINE INPUT PARAMETER x-NroMes  LIKE integral.cb-dmov.nromes.
DEFINE INPUT PARAMETER x-CodMon  LIKE integral.cb-dmov.codmon.
DEFINE INPUT PARAMETER x-tipo    LIKE integral.cb-dmov.codmon.
/* x-Tipo = 1 Mensual  2 Acumulado */
DEFINE INPUT PARAMETER x-Cco     LIKE integral.cb-dmov.cco.
DEFINE INPUT PARAMETER x-CodOpe  LIKE integral.cb-cmov.codope.

DEFINE OUTPUT PARAMETER ImpCal1  AS DECIMAL.
DEFINE OUTPUT PARAMETER ImpCal2  AS DECIMAL.
DEFINE OUTPUT PARAMETER ImpCal3  AS DECIMAL.
DEFINE OUTPUT PARAMETER ImpCal4  AS DECIMAL.
DEFINE OUTPUT PARAMETER ImpCal5  AS DECIMAL.
DEFINE OUTPUT PARAMETER ImpCal6  AS DECIMAL.

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
         HEIGHT             = 4.12
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE x-ImpDbe AS DECIMAL.
DEFINE VARIABLE x-ImpHbe AS DECIMAL.

ImpCal1 = 0.  /*  Debe del Mes     */
ImpCal2 = 0.  /*  Haber del Mes    */
ImpCal3 = 0.  /*  Saldo del Mes    */
ImpCal4 = 0.  /*  Debe Acumulado   */
ImpCal5 = 0.  /*  Haber Acumulado  */
ImpCal6 = 0.  /*  Saldo Acumulado  */ 

/* Saldo Inicial  = Saldo Acumulado (Impcal6) - Saldo del Mes (Impcal3) */ 
/* Saldo Actual   = Saldo Inicial  + Debe (Impcal1)  - Haber (Impcal2)  */
                            
IF X-tipo <> 1  THEN        /* ACUMULADO */
    FOR EACH cb-dmov WHERE cb-dmov.codcia     =  s-codcia
                        AND   cb-dmov.periodo =  x-periodo
                        AND   cb-dmov.coddiv  BEGINS ( x-coddiv )
                        AND   cb-dmov.codcta  BEGINS ( x-codcta )
                        AND   cb-dmov.nromes <=  x-nromes
                        AND   cb-dmov.cco     BEGINS ( x-cco )
                        AND (x-CodOpe = "" OR cb-dmov.codope = x-CodOpe)
                        NO-LOCK:
       x-ImpDbe = 0.
       x-ImpHbe = 0.
                        
       CASE x-codmon:                                
       
        WHEN 1 THEN DO:           
            IF NOT cb-dmov.tpomov then x-ImpDbe = cb-dmov.ImpMn1.
                                  else x-ImpHbe = cb-dmov.ImpMn1.
        END.
        WHEN 2 THEN DO:
            IF NOT cb-dmov.tpomov then x-ImpDbe = cb-dmov.ImpMn2.
                                  else x-ImpHbe = cb-dmov.ImpMn2.
        END.
        WHEN 3 THEN DO:
            IF NOT cb-dmov.tpomov then x-ImpDbe = cb-dmov.ImpMn3.
                                  else x-ImpHbe = cb-dmov.ImpMn3.
        END.
        END CASE.
        ImpCal4 = ImpCal4 + x-ImpDbe.
        ImpCal5 = ImpCal5 + x-ImpHbe.
        IF cb-dmov.nromes =  x-NroMes 
        THEN DO:
            ImpCal1 = ImpCal1 + x-ImpDbe.
            ImpCal2 = ImpCal2 + x-ImpHbe.
        END.
    END.                        
ELSE
    FOR EACH cb-dmov WHERE cb-dmov.codcia     =  s-codcia
                        AND   cb-dmov.periodo =  x-periodo
                        AND   cb-dmov.coddiv  BEGINS ( x-coddiv )
                        AND   cb-dmov.codcta  BEGINS ( x-codcta )
                        AND   cb-dmov.nromes  =  x-nromes
                        AND   cb-dmov.cco     BEGINS ( x-cco )
                        AND (x-CodOpe = "" OR cb-dmov.codope = x-CodOpe)
                        NO-LOCK:
       x-ImpDbe = 0.
       x-ImpHbe = 0.
                        
       CASE x-codmon:
        WHEN 1 THEN DO:           
            IF NOT cb-dmov.tpomov then x-ImpDbe = cb-dmov.ImpMn1.
                                  else x-ImpHbe = cb-dmov.ImpMn1.
        END.
        WHEN 2 THEN DO:
            IF NOT cb-dmov.tpomov then x-ImpDbe = cb-dmov.ImpMn2.
                                  else x-ImpHbe = cb-dmov.ImpMn2.
        END.
        WHEN 3 THEN DO:
            IF NOT cb-dmov.tpomov then x-ImpDbe = cb-dmov.ImpMn3.
                                  else x-ImpHbe = cb-dmov.ImpMn3.
        END.
        END CASE.
        ImpCal4 = ImpCal4 + x-ImpDbe.
        ImpCal5 = ImpCal5 + x-ImpHbe.
        IF cb-dmov.nromes =  x-NroMes 
        THEN DO:
            ImpCal1 = ImpCal1 + x-ImpDbe.
            ImpCal2 = ImpCal2 + x-ImpHbe.
        END.
    END.

ImpCal3 = ImpCal1 - ImpCal2.
ImpCal6 = ImpCal4 - ImpCal5.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


