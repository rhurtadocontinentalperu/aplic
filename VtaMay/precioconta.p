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
         HEIGHT             = 5.62
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER S-CODCIA AS INT.
DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF INPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-FLGSIT AS CHAR.
DEF INPUT PARAMETER S-UNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER SW-LOG1  AS LOGI.

DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
DEFINE VARIABLE X-FACTOR  AS DECI NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

DEF VAR CL-CODCIA AS INT INIT 0 NO-UNDO.
/* variables sacadas del include */
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN CL-CODCIA = S-CODCIA.
FIND Almmmatg WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codmat = S-CODMAT NO-LOCK.

ASSIGN
    X-FACTOR = 1
    X-PREVTA1 = 0
    X-PREVTA2 = 0
    SW-LOG1 = FALSE.

/*RDP 17.08.10 Reduce a 4 decimales*/
RUN BIN/_ROUND1(F-PREbas,4,OUTPUT F-PreBas).
/**************************/

{vtamay/precioconta.i &Catalogo = "Almmmatg"}

/* 13.11.09 RHC Clientes con listas especiales */
FIND Vtaclicam WHERE VtaCliCam.CodCia = cl-codcia
    AND VtaCliCam.CodCli = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtaclicam AND (TODAY >= 12/01/2009 AND TODAY <= 03/31/2010) THEN DO:
    FIND Vtacatcam WHERE Vtacatcam.codcia = s-codcia
        AND Vtacatcam.codmat = s-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Vtacatcam THEN DO:
        {vtamay/precioconta.i &Catalogo = "Vtacatcam"}
    END.
END.


/* /****   PRECIO C    ****/                                                      */
/* IF Almmmatg.UndC <> "" AND NOT SW-LOG1 THEN DO:                                */
/*     FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas                     */
/*         AND  Almtconv.Codalter = Almmmatg.UndC                                 */
/*         NO-LOCK NO-ERROR.                                                      */
/*     IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.                    */
/*     IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:                     */
/*         SW-LOG1 = TRUE.                                                        */
/*         F-DSCTOS = Almmmatg.dsctos[3].                                         */
/*         IF Almmmatg.MonVta = 1 THEN                                            */
/*           ASSIGN X-PREVTA1 = Almmmatg.Prevta[4]                                */
/*                  X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).             */
/*         ELSE                                                                   */
/*           ASSIGN X-PREVTA2 = Almmmatg.Prevta[4]                                */
/*                  X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).             */
/*         X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.                         */
/*         X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.                         */
/*     END.                                                                       */
/* END.                                                                           */
/* /****   PRECIO B    ****/                                                      */
/* IF Almmmatg.UndB <> "" AND NOT SW-LOG1 THEN DO:                                */
/*     FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas                     */
/*         AND  Almtconv.Codalter = Almmmatg.UndB                                 */
/*         NO-LOCK NO-ERROR.                                                      */
/*     IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.                    */
/*     IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:                     */
/*         SW-LOG1 = TRUE.                                                        */
/*         F-DSCTOS = Almmmatg.dsctos[2].                                         */
/*         IF Almmmatg.MonVta = 1 THEN                                            */
/*           ASSIGN X-PREVTA1 = Almmmatg.Prevta[3]                                */
/*                  X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).             */
/*         ELSE                                                                   */
/*           ASSIGN X-PREVTA2 = Almmmatg.Prevta[3]                                */
/*                  X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).             */
/*         X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.                         */
/*         X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.                         */
/*     END.                                                                       */
/* END.                                                                           */
/* /****   PRECIO A    ****/                                                      */
/* IF Almmmatg.UndA <> "" AND NOT SW-LOG1 THEN DO:                                */
/*     FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas                     */
/*         AND  Almtconv.Codalter = Almmmatg.UndA                                 */
/*         NO-LOCK NO-ERROR.                                                      */
/*     IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.                    */
/*     IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:                     */
/*         SW-LOG1 = TRUE.                                                        */
/*         F-DSCTOS = Almmmatg.dsctos[1].                                         */
/*         IF Almmmatg.MonVta = 1 THEN                                            */
/*           ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]                                */
/*                  X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).             */
/*         ELSE                                                                   */
/*           ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]                                */
/*                  X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).             */
/*         X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.                         */
/*         X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.                         */
/*     END.                                                                       */
/*     ELSE DO:                                                                   */
/*         SW-LOG1 = TRUE.                                                        */
/*         F-DSCTOS = Almmmatg.dsctos[1].                                         */
/*         IF Almmmatg.MonVta = 1 THEN                                            */
/*           ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]                                */
/*                  X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).             */
/*         ELSE                                                                   */
/*           ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]                                */
/*                  X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).             */
/*         X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.                         */
/*         X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.                         */
/*     END.                                                                       */
/* END.                                                                           */
/*                                                                                */
/* /* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */               */
/* Y-DSCTOS = 0.                                                                  */
/*                                                                                */
/* /************ Descuento Promocional ************/                              */
/* DEFINE VAR J AS INTEGER.                                                       */
/* DO J = 1 TO 10:                                                                */
/*     IF Almmmatg.PromDivi[J] = S-CODDIV                                         */
/*             AND TODAY >= Almmmatg.PromFchD[J]                                  */
/*             AND TODAY <= Almmmatg.PromFchH[J] THEN DO:                         */
/*         F-DSCTOS = Almmmatg.PromDto[J] .                                       */
/*         F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).                  */
/*         Y-DSCTOS = Almmmatg.PromDto[J] .                                       */
/*         SW-LOG1 = TRUE.                                                        */
/*         IF Almmmatg.Monvta = 1 THEN                                            */
/*           ASSIGN X-PREVTA1 = F-PREVTA                                          */
/*                  X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).              */
/*         ELSE                                                                   */
/*           ASSIGN X-PREVTA2 = F-PREVTA                                          */
/*                  X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).              */
/*         FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas                 */
/*             AND Almtconv.Codalter = s-UndVta                                   */
/*             NO-LOCK NO-ERROR.                                                  */
/*         IF AVAILABLE Almtconv                                                  */
/*         THEN x-Factor = Almtconv.Equival.                                      */
/*         ELSE x-Factor = 1.                                                     */
/*         X-PREVTA1 = X-PREVTA1 * X-FACTOR.                                      */
/*         X-PREVTA2 = X-PREVTA2 * X-FACTOR.                                      */
/*      END.                                                                      */
/* END.                                                                           */
/* /*************** Descuento por Volumen ****************/                       */
/* IF X-CANPED > 0 THEN DO:                                                       */
/*     DEFINE VAR X-RANGO AS INTEGER INIT 0.                                      */
/*     DEFINE VAR X-CANTI AS DECI    INIT 0.                                      */
/*                                                                                */
/*     FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas                     */
/*         AND Almtconv.Codalter = s-UndVta                                       */
/*         NO-LOCK NO-ERROR.                                                      */
/*     IF AVAILABLE Almtconv                                                      */
/*     THEN ASSIGN                                                                */
/*             X-FACTOR = Almtconv.Equival.                                       */
/*     ELSE ASSIGN                                                                */
/*             X-FACTOR = 1.                                                      */
/*     X-CANTI = X-CANPED * X-FACTOR.                                             */
/*     DO J = 1 TO 10:                                                            */
/*        IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO: */
/*           IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].                  */
/*           IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:                           */
/*             X-RANGO  = Almmmatg.DtoVolR[J].                                    */
/*             F-DSCTOS = Almmmatg.DtoVolD[J].                                    */
/*             F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).              */
/*             Y-DSCTOS = Almmmatg.DtoVolD[J] .                                   */
/*             SW-LOG1 = TRUE.                                                    */
/*             IF Almmmatg.MonVta = 1 THEN                                        */
/*                ASSIGN X-PREVTA1 = F-PREVTA                                     */
/*                       X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).         */
/*             ELSE                                                               */
/*                ASSIGN X-PREVTA2 = F-PREVTA                                     */
/*                       X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).         */
/*             X-PREVTA1 = X-PREVTA1 * F-FACTOR.                                  */
/*             X-PREVTA2 = X-PREVTA2 * F-FACTOR.                                  */
/*           END.                                                                 */
/*        END.                                                                    */
/*     END.                                                                       */
/* END.                                                                           */


IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 
    THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
END.      

/* RHC INCREMENTO AL PRECIO UNITARIO POR PAGAR CON TARJETA DE CREDITO */
/* Calculamos el margen de utilidad */
DEF VAR x-MargenUtilidad AS DEC NO-UNDO.
DEF VAR x-ImporteCosto AS DEC NO-UNDO.

x-ImporteCosto = Almmmatg.Ctotot.
IF s-CODMON <> Almmmatg.Monvta THEN DO:
    x-ImporteCosto = IF s-CODMON = 1 
                THEN Almmmatg.Ctotot * Almmmatg.Tpocmb
                ELSE Almmmatg.Ctotot / Almmmatg.Tpocmb.
END.
IF x-ImporteCosto > 0
THEN x-MargenUtilidad = ( (f-PreVta / f-Factor) - x-ImporteCosto ) / x-ImporteCosto * 100.
IF x-MargenUtilidad < 0 THEN x-MargenUtilidad = 0.

/*************************************************/
CASE s-FlgSit:
    WHEN 'T' THEN DO:
        /* BUSCAMOS EL RANGO ADECUADO */
        FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
                AND FacTabla.Tabla = 'TC'
                AND FacTabla.Codigo BEGINS '00':
            IF x-MargenUtilidad >= FacTabla.Valor[1]
                    AND x-MargenUtilidad < FacTabla.Valor[2] THEN DO:
                f-PreVta = f-Prevta * (1 + FacTabla.Valor[3] / 100).
                LEAVE.
            END.
        END.                
    END.
END CASE.

/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
ASSIGN
    F-DSCTOS = ABSOLUTE(F-DSCTOS)
    Y-DSCTOS = ABSOLUTE(Y-DSCTOS).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


