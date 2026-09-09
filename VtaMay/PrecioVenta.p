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
         HEIGHT             = 2
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
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.

DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR CL-CODCIA AS INT INIT 0 NO-UNDO.
DEF VAR x-ClfCli AS CHAR NO-UNDO.
DEF VAR x-fch AS DATE INIT TODAY.

/* variable sacadas del include */
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
/************ Descuento Promocional ************/
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   


FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN CL-CODCIA = S-CODCIA.
FIND Almmmatg WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codmat = S-CODMAT NO-LOCK.

FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = S-CODCLI
    NO-LOCK NO-ERROR.
x-ClfCli = 'C'.     /* Valor por defecto */
IF AVAIL gn-clie AND gn-clie.clfcli <> '' THEN X-CLFCLI = gn-clie.clfcli.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = Almmmatg.TpoCmb.
/* ***************************************** */

/*RDP 17.08.10 Reduce a 4 decimales*/
RUN BIN/_ROUND1(F-PREbas,4,OUTPUT F-PreBas).
/****************/

{vtamay/precioventa.i &Catalogo = "Almmmatg"}

/* 13.11.09 RHC Clientes con listas especiales */
FIND Vtaclicam WHERE VtaCliCam.CodCia = cl-codcia
    AND VtaCliCam.CodCli = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtaclicam AND (TODAY >= 12/01/2009 AND TODAY <= 03/31/2010) THEN DO:
    FIND Vtacatcam WHERE Vtacatcam.codcia = s-codcia
        AND Vtacatcam.codmat = s-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Vtacatcam THEN DO:
        {vtamay/precioventa.i &Catalogo = "Vtacatcam"}
    END.
END.


    /* /* Determinamos el precio base */                                                  */
    /* IF S-CODMON = 1 THEN DO:                                                           */
    /*     IF Almmmatg.MonVta = 1 THEN                                                    */
    /*         ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.                              */
    /*     ELSE                                                                           */
    /*         ASSIGN F-PREBAS = Almmmatg.PreOfi * S-TPOCMB * F-FACTOR.                   */
    /* END.                                                                               */
    /* IF S-CODMON = 2 THEN DO:                                                           */
    /*     IF Almmmatg.MonVta = 2 THEN                                                    */
    /*         ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.                              */
    /*     ELSE                                                                           */
    /*         ASSIGN F-PREBAS = (Almmmatg.PreOfi / S-TPOCMB) * F-FACTOR.                 */
    /* END.                                                                               */
    /*                                                                                    */
    /*                                                                                    */
    /* ASSIGN                                                                             */
    /*     MaxCat = 0                                                                     */
    /*     MaxVta = 0.                                                                    */
    /* /* Descuento por Clasificacion */                                                  */
    /* FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.                  */
    /* IF AVAIL ClfClie THEN DO:                                                          */
    /*     IF Almmmatg.Chr__02 = "P"                                                      */
    /*     THEN MaxCat = ClfClie.PorDsc.                                                  */
    /*     ELSE MaxCat = ClfClie.PorDsc1.                                                 */
    /* END.                                                                               */
    /* /* Descuento por condicion de venta */                                             */
    /* FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA                                         */
    /*     AND  Dsctos.clfCli = Almmmatg.Chr__02                                          */
    /*     NO-LOCK NO-ERROR.                                                              */
    /* IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.                                       */
    /*                                                                                    */
    /* /* Definimos el precio de venta y el descuento aplicado */                         */
    /* IF NOT AVAIL ClfClie THEN                                                          */
    /*     F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.                                     */
    /* ELSE                                                                               */
    /*     F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.                */
    /* F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */   */
    /*                                                                                    */
    /* /* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */                   */
    /* Y-DSCTOS = 0.                                                                      */
    /* FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.                    */
    /* IF AVAILABLE gn-convt AND  gn-convt.totdias <= 15 THEN DO:                         */
    /*     DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.                                     */
    /*     DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.                                     */
    /*                                                                                    */
    /*     /************ Descuento Promocional ************/                              */
    /*     DEFINE VAR J AS INTEGER.                                                       */
    /*     DO J = 1 TO 10:                                                                */
    /*         IF Almmmatg.PromDivi[J] = S-CODDIV                                         */
    /*                 AND TODAY >= Almmmatg.PromFchD[J]                                  */
    /*                 AND TODAY <= Almmmatg.PromFchH[J] THEN DO:                         */
    /*             F-DSCTOS = Almmmatg.PromDto[J] .                                       */
    /*             F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).                  */
    /*             Y-DSCTOS = Almmmatg.PromDto[J] .                                       */
    /*             IF Almmmatg.Monvta = 1 THEN                                            */
    /*               ASSIGN X-PREVTA1 = F-PREVTA                                          */
    /*                      X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).              */
    /*             ELSE                                                                   */
    /*               ASSIGN X-PREVTA2 = F-PREVTA                                          */
    /*                      X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).              */
    /*             X-PREVTA1 = X-PREVTA1 * F-FACTOR.                                      */
    /*             X-PREVTA2 = X-PREVTA2 * F-FACTOR.                                      */
    /*          END.                                                                      */
    /*     END.                                                                           */
    /*                                                                                    */
    /*     /*************** Descuento por Volumen ****************/                       */
    /*     IF X-CANPED > 0 THEN DO:                                                       */
    /*         DEFINE VAR X-RANGO AS INTEGER INIT 0.                                      */
    /*         DEFINE VAR X-CANTI AS DECI    INIT 0.                                      */
    /*                                                                                    */
    /*         X-CANTI = X-CANPED * F-FACTOR .                                            */
    /*         DO J = 1 TO 10:                                                            */
    /*            IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO: */
    /*               IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].                  */
    /*               IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:                           */
    /*                 X-RANGO  = Almmmatg.DtoVolR[J].                                    */
    /*                 F-DSCTOS = Almmmatg.DtoVolD[J].                                    */
    /*                 F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).              */
    /*                 Y-DSCTOS = Almmmatg.DtoVolD[J] .                                   */
    /*                 IF Almmmatg.MonVta = 1 THEN                                        */
    /*                    ASSIGN X-PREVTA1 = F-PREVTA                                     */
    /*                           X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).         */
    /*                 ELSE                                                               */
    /*                    ASSIGN X-PREVTA2 = F-PREVTA                                     */
/*                           X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).         */
/*                 X-PREVTA1 = X-PREVTA1 * F-FACTOR.                                  */
/*                 X-PREVTA2 = X-PREVTA2 * F-FACTOR.                                  */
/*               END.                                                                 */
/*            END.                                                                    */
/*         END.                                                                       */
/*     END.                                                                           */
/*     IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:                                          */
/*         IF S-CODMON = 1                                                            */
/*         THEN F-PREVTA = X-PREVTA1.                                                 */
/*         ELSE F-PREVTA = X-PREVTA2.                                                 */
/*     END.                                                                           */
/* END.                                                                               */

/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


