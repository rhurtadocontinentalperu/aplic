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
         HEIGHT             = 5.65
         WIDTH              = 45.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF INPUT PARAMETER s-CodBco AS CHAR.
DEF INPUT PARAMETER s-Tarjeta AS CHAR.
DEF INPUT PARAMETER s-CodPro AS CHAR.
DEF INPUT PARAMETER s-NroVale AS CHAR.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.

/* VARIABLES GLOBALES */
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* VARIABLES LOCALES */
DEF VAR s-MonVta LIKE Almmmatg.MonVta NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR x-ClfCli  AS CHAR NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR NO-UNDO.      /* Clasificacion para productos de terceros */
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
/************ Descuento Promocional ************/
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   


/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Producto' s-CodMat 'NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

ASSIGN
    MaxCat = 0
    MaxVta = 0
    F-PreBas = Almmmatg.PreOfi.

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
/* NOTA: 13/02/2013 Hasta la fecha SOLO se usa la Lista Mayorista General */
CASE gn-divi.VentaMinorista:
    WHEN 1 THEN DO:
        RUN Precio-Empresa.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
    WHEN 2 THEN DO:
        RUN Precio-Division.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
END CASE.
/* RUTINA DONDE SE DEFINEN LOS DESCUENTOS POR VALES CONTINENTAL */
/* RHC 29/02/2016 Ya no funciona
RUN Descuentos-Promocionales.
*/

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Descuentos-Promocionales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Promocionales Procedure 
PROCEDURE Descuentos-Promocionales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF s-FlgSit = "" THEN RETURN.
  IF x-TipDto = "PROM" THEN RETURN.

  
  DEF VAR x-Familias-sin-Dsctos AS CHAR NO-UNDO.

  x-Familias-sin-Dsctos = "000,011,008".

  /*MESSAGE 'Z-Dsctos' z-Dsctos VIEW-AS ALERT-BOX ERROR.*/

  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
      AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
  CASE s-FlgSit:
/*       WHEN "T" THEN DO:                                                          */
/*           /* RHC Promociones por Bancos */                                       */
/*           CASE s-CodBco:                                                         */
/*               WHEN "WI" THEN DO:            /* Scotiabank */                     */
/*                   IF TODAY <= 03/10/2011 THEN DO:                                */
/*                       /* Definimos el mejor descuento */                         */
/*                       IF MAXIMUM( y-Dsctos, z-Dsctos ) < 10                      */
/*                           AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0 */
/*                       THEN ASSIGN                                                */
/*                                 y-Dsctos = 0                                     */
/*                                 z-Dsctos = 10                                    */
/*                                 x-TipDto = "T,WI".                               */
/*                   END.                                                           */
/*               END.                                                               */
/*               WHEN "CR" THEN DO:            /* Banco de Credito */               */
/*                   /* Solo Cuenta Sueldo */                                       */
/*                   IF s-Tarjeta = "05" AND TODAY <= 12/31/2011 THEN DO:           */
/*                       /* Definimos el mejor descuento */                         */
/*                       IF MAXIMUM( y-Dsctos, z-Dsctos ) < 10                      */
/*                           AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0 */
/*                       THEN ASSIGN                                                */
/*                                 y-Dsctos = 0                                     */
/*                                 z-Dsctos = 10                                    */
/*                                 x-TipDto = "T,CR,05".                            */
/*                   END.                                                           */
/*               END.                                                               */
/*           END CASE.                                                              */
/*       END.                                                                       */
/*       WHEN "V" THEN DO:                                                          */
/*           /* Definimos el mejor descuento */                                     */
/*           IF MAXIMUM( y-Dsctos, z-Dsctos ) < 10                                  */
/*               AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0             */
/*           THEN ASSIGN                                                            */
/*                     y-Dsctos = 0                                                 */
/*                     z-Dsctos = 10                                                */
/*                     x-TipDto = "V".                                              */
/*       END.                                                                       */
/*       WHEN "X" THEN DO:                                                          */
/*           /* Definimos el mejor descuento */                                     */
/*           IF MAXIMUM( y-Dsctos, z-Dsctos ) < 10                                  */
/*               AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0             */
/*           THEN ASSIGN                                                            */
/*                     y-Dsctos = 0                                                 */
/*                     z-dsctos = 10                                                */
/*                     x-TipDto = "X".                                              */
/*       END.                                                                       */
      WHEN "KC" THEN DO:
          IF s-codpro = '10003814' AND s-NroVale BEGINS '0001' THEN DO:     /* Tickets CONTINENTAL */
              /* Definimos el mejor descuento */
              IF MAXIMUM( y-Dsctos, z-Dsctos ) < 10
                  AND LOOKUP(Almmmatg.codfam, "000,008,011") = 0
              THEN ASSIGN
                        y-Dsctos = 0
                        z-Dsctos = 10
                        x-TipDto = "K".
                /*MESSAGE 'Z-Dsctos 2' z-Dsctos VIEW-AS ALERT-BOX ERROR.*/
          END.
          IF s-codpro = '10003814' AND s-NroVale BEGINS '0002' THEN DO:     /* Tickets CONTINENTAL */
              /* Definimos el mejor descuento */
              IF MAXIMUM( y-Dsctos, z-Dsctos ) < 10
                  AND LOOKUP(Almmmatg.codfam, "000,007,008,011") = 0
              THEN ASSIGN
                        y-Dsctos = 0
                        z-Dsctos = 10
                        x-TipDto = "K".
          END.
          IF s-codpro = '10003814' AND s-NroVale BEGINS '0003' THEN DO:     /* Tickets PERSONAL CONTINENTAL */
              /* Ic - 18Feb2015 Campaña 2015 */
              IF LOOKUP(Almmmatg.codfam, "001,002,003,004,005,010,012,013") > 0
                  AND NOT ( Almmmatg.CodFam = "001" AND Almmmatg.SubFam = "007" ) 
                  AND NOT ( Almmmatg.CodFam = "013" AND Almmmatg.SubFam = "015" ) 
                  AND (y-Dsctos = 0 AND z-Dsctos = 0)
                  THEN ASSIGN
                        y-Dsctos = 0
                        z-Dsctos = 15
                        x-TipDto = "KC".
              IF Almmmatg.codfam = '007' AND LOOKUP(Almmmatg.subfam, '001,021') > 0 
                  AND (y-Dsctos = 0 AND z-Dsctos = 0)
                  THEN ASSIGN
                          y-Dsctos = 0
                          z-Dsctos = 10
                          x-TipDto = "KC".
          END.
          IF s-codpro = '10003814' AND s-NroVale BEGINS '0004' THEN DO:     /* Tickets 2014 */
              IF LOOKUP(Almmmatg.codfam, "000,011,007") = 0 AND
                  NOT (Almmmatg.codfam = '013' AND almmmatg.subfam = '015') AND
                  y-Dsctos = 0 THEN DO:
                  ASSIGN
                        y-Dsctos = 0
                        z-Dsctos = 10
                        x-TipDto = "KC".
              END.
              IF Almmmatg.codfam = '007' AND LOOKUP(Almmmatg.subfam, '001,021') > 0 
                  AND y-Dsctos = 0
                  THEN ASSIGN
                          y-Dsctos = 0
                          z-Dsctos = 10
                          x-TipDto = "KC".
          END.
      END.
/*       WHEN "KC" THEN DO:    /* Tickets Continental para el personal */  */
/*           IF s-codpro = "10003814" AND s-NroVale BEGINS "0003" THEN DO: */
/*               IF LOOKUP(Almmmatg.codfam, "010,012") > 0                 */
/*                   AND MAXIMUM( y-Dsctos, z-Dsctos ) < 15                */
/*                   THEN ASSIGN                                           */
/*                         y-Dsctos = 0                                    */
/*                         z-Dsctos = 15                                   */
/*                         x-TipDto = "KC".                                */
/*               IF LOOKUP(Almmmatg.codfam, "000,008,011,010,012") = 0     */
/*                   AND MAXIMUM( y-Dsctos, z-Dsctos ) < 10                */
/*                   THEN ASSIGN                                           */
/*                         y-Dsctos = 0                                    */
/*                         z-Dsctos = 10                                   */
/*                         x-TipDto = "KC".                                */
/*           END.                                                          */
/*       END.                                                              */
      WHEN "CD" THEN DO:        /* ENCARTE (Cupón de Descuento) */
/*           IF TODAY <= 03/03/2013 THEN DO:                                                            */
/*               IF MAXIMUM(y-Dsctos, z-Dsctos) < 10 AND LOOKUP(Almmmatg.codfam, "000,007,008,011") = 0 */
/*               THEN ASSIGN                                                                            */
/*                         y-Dsctos = 0                                                                 */
/*                         z-Dsctos = 10                                                                */
/*                         x-TipDto = "CD".                                                             */
/*           END.                                                                                       */
      END.
  END CASE.

  /*MESSAGE 'Z-Dsctos 333' z-Dsctos VIEW-AS ALERT-BOX ERROR.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Division) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Division Procedure 
PROCEDURE Precio-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST VtaListaMin OF Almmmatg WHERE VtaListaMin.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMin THEN DO:
    MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios de la división' s-CodDiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-UndVta = VtaListaMin.Chr__01.

/*{vtagn/preciolistaminorista-1.i &Tabla = VtaListaMin}.*/

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = VtaListaMin.TpoCmb.     /* ¿? */

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF VtaListaMin.MonVta = 1 
    THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
    ELSE ASSIGN F-PREBAS = VtaListaMin.PreOfi * S-TPOCMB.
END.
IF S-CODMON = 2 THEN DO:
    IF VtaListaMin.MonVta = 2 
    THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
    ELSE ASSIGN F-PREBAS = (VtaListaMin.PreOfi / S-TPOCMB).
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */


IF s-FlgSit = "C" AND (TODAY >= 02/19/2011 AND TODAY <= 03/05/2011) THEN DO:
    /* DESCUENTOS ESPECIALES POR PROMOCIONES */
    ASSIGN
        F-DSCTOS = 0.
    IF LOOKUP(Almmmatg.codfam, '000,011,008') = 0 THEN DO:
        ASSIGN
            Y-DSCTOS = 10.  /* << OJO >> */
    END.
    FIND FIRST VtaListaMin OF Almmmatg WHERE VtaListaMin.CodDiv = "99999" NO-LOCK NO-ERROR.
    IF AVAILABLE VtaListaMin THEN DO:
        ASSIGN
            Y-DSCTOS = 0.   /* << OJO >> */
        /* PRECIO BASE  */
        IF S-CODMON = 1 THEN DO:
            IF VtaListaMin.MonVta = 1 
            THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
            ELSE ASSIGN F-PREBAS = VtaListaMin.PreOfi * S-TPOCMB.
        END.
        IF S-CODMON = 2 THEN DO:
            IF VtaListaMin.MonVta = 2 
            THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
            ELSE ASSIGN F-PREBAS = (VtaListaMin.PreOfi / S-TPOCMB).
        END.
        /* Definimos el precio de venta y el descuento aplicado */    
        F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
    END.
    /* ************************************* */
END.
ELSE DO:
    /* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
    Y-DSCTOS = 0.        
    /************ Descuento Promocional ************/ 
    IF GN-DIVI.FlgDtoProm = YES THEN DO:
        IF TODAY >= VtaListaMin.PromFchD AND TODAY <= VtaListaMin.PromFchH THEN DO:
            ASSIGN
                F-DSCTOS = 0
                F-PREVTA = VtaListaMin.PreOfi
                Y-DSCTOS = VtaListaMin.PromDto
                X-TIPDTO = "PROM".
            IF VtaListaMin.Monvta = 1 THEN 
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / VtaListaMin.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * VtaListaMin.TpoCmb,6).
            X-PREVTA1 = X-PREVTA1.
            X-PREVTA2 = X-PREVTA2.
         END.   
    END.
    /*************** Descuento por Volumen ****************/
    IF GN-DIVI.FlgDtoVol = YES THEN DO:
        X-CANTI = X-CANPED.
        DO J = 1 TO 10:
            IF X-CANTI >= VtaListaMin.DtoVolR[J] AND VtaListaMin.DtoVolR[J] > 0  THEN DO:
                IF X-RANGO  = 0 THEN X-RANGO = VtaListaMin.DtoVolR[J].
                IF X-RANGO <= VtaListaMin.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = VtaListaMin.DtoVolR[J]
                        F-DSCTOS = 0
                        F-PREVTA = VtaListaMin.PreOfi
                        Y-DSCTOS = VtaListaMin.DtoVolD[J] 
                        X-TIPDTO = "VOL".
                    IF VtaListaMin.MonVta = 1 THEN 
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / VtaListaMin.TpoCmb,6).
                    ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * VtaListaMin.TpoCmb,6).
                    X-PREVTA1 = X-PREVTA1.
                    X-PREVTA2 = X-PREVTA2.
                END.   
            END.   
        END.
    END.
    /* PRECIO FINAL */
    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 
        THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
        IF S-CODMON = 1 
        THEN F-PREBAS = X-PREVTA1.
        ELSE F-PREBAS = X-PREVTA2.     
    END.    
    /************************************************/
END.

/* *********************************** */
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
/* *********************************** */

/* DESCUENTOS ADICIONALES POR DIVISION */
z-Dsctos = 0.
            
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Empresa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Empresa Procedure 
PROCEDURE Precio-Empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMinGn THEN DO:
    MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios minorista'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-UndVta = VtaListaMinGn.Chr__01.

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival. /* / Almmmatg.FacEqu.*/

/* RHC 12.06.08 tipo de cambio de la familia */
ASSIGN
/*     s-tpocmb = VtaListaMinGn.TpoCmb  */
/*     s-monvta = VtaListaMinGn.MonVta. */
    s-TpoCmb = Almmmatg.TpoCmb
    s-MonVta = Almmmatg.MonVta.

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF s-MonVta = 1
    THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
    ELSE ASSIGN F-PREBAS = VtaListaMinGn.PreOfi * S-TPOCMB.
END.
IF S-CODMON = 2 THEN DO:
    IF s-MonVta = 2
    THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
    ELSE ASSIGN F-PREBAS = (VtaListaMinGn.PreOfi / S-TPOCMB).
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* RHC 13/02/2014 PRODUCTOS SIN NINGUN TIPO DE DESCUENTO (SELLO ROJO )*/ 
DEF VAR x-Dia-de-Hoy AS DATE NO-UNDO.

x-Dia-de-Hoy = TODAY.
/* IF ( TODAY >= 02/15/2014 AND TODAY <= 03/02/2014 )        */
/*     OR LOOKUP(s-user-id, 'ADMIN,U2014') > 0               */
/*     THEN DO:     /* Vigente hasta el 2 de Marzo 2014 */   */
/*     FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia  */
/*         AND VtaTabla.Tabla = "UTILEX-ROJO"                */
/*         AND VtaTabla.Llave_c1 = Almmmatg.CodMat           */
/*         NO-LOCK NO-ERROR.                                 */
/*     IF AVAILABLE VtaTabla THEN x-Dia-de-Hoy = 02/15/2014. */
/* END.                                                      */

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.tabla = "DTOPROUTILEX"
    AND VtaTabla.llave_c1 = s-codmat
    AND VtaTabla.llave_c2 = s-CodDiv
    AND TODAY >= VtaTabla.Rango_Fecha[1]
    AND TODAY <= VtaTabla.Rango_Fecha[2]
    NO-LOCK NO-ERROR.

ASSIGN
    Y-DSCTOS = 0
    Z-DSCTOS = 0.
IF AVAILABLE VtaTabla THEN Y-DSCTOS = VtaTabla.Valor[1].
/* IF GN-DIVI.FlgDtoProm = YES THEN DO: */
/*     DO J = 1 TO 10:                                         */
/*         IF VtaListaMinGn.PromDivi[J] = S-CODDIV             */
/*             AND x-Dia-de-Hoy >= VtaListaminGn.PromFchD[J]   */
/*             AND TODAY <= VtaListaminGn.PromFchH[J] THEN DO: */
/*             Y-DSCTOS = VtaListaMinGn.PromDto[J].            */
/*         END.                                                */
/*     END.                                                    */
/* END.                                */
/* IF GN-DIVI.FlgDtoVol = YES THEN DO: */
    X-CANTI = X-CANPED * F-Factor.
    
    /* Determinamos el mejor descuento */
    ASSIGN
        X-RANGO = 0.
    DO J = 1 TO 10:
        IF X-CANTI >= VtaListaMinGn.DtoVolR[J] AND VtaListaMinGn.DtoVolR[J] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = VtaListaMinGn.DtoVolR[J].
            IF X-RANGO <= VtaListaMinGn.DtoVolR[J] THEN DO:
                Z-DSCTOS = VtaListaMinGn.DtoVolD[J].
            END.   
        END.   
    END.
/* END. */

IF Y-DSCTOS <> 0 OR Z-DSCTOS <> 0 THEN DO:
    IF Y-DSCTOS > Z-DSCTOS THEN DO:
        /* DESCUENTO PROMOCIONAL */
        IF GN-DIVI.FlgDtoProm = YES THEN DO:
            DO J = 1 TO 10:
                IF VtaListaMinGn.PromDivi[J] = S-CODDIV 
                    AND x-Dia-de-Hoy >= VtaListaminGn.PromFchD[J] 
                    AND TODAY <= VtaListaminGn.PromFchH[J] 
                    AND VtaListaMinGn.PromDto[J] <> 0
                    THEN DO:
                    ASSIGN
                        F-DSCTOS = 0
                        F-PREVTA = VtaListaMinGn.PreOfi
                        Y-DSCTOS = VtaListaMinGn.PromDto[J]
                        X-TIPDTO = "PROM".
                    IF s-Monvta = 1 THEN
                      ASSIGN X-PREVTA1 = F-PREVTA
                             X-PREVTA2 = ROUND(F-PREVTA / s-TpoCmb,6).
                    ELSE
                      ASSIGN X-PREVTA2 = F-PREVTA
                             X-PREVTA1 = ROUND(F-PREVTA * s-TpoCmb,6).
                    X-PREVTA1 = X-PREVTA1.
                    X-PREVTA2 = X-PREVTA2.
                END.
            END.
        END.
    END.
    ELSE DO:
        /* DESCUENTO POR VOLUMEN */
        ASSIGN
            X-CANTI = X-CANPED * F-Factor
            X-RANGO = 0.
        DO J = 1 TO 10:
            IF X-CANTI >= VtaListaMinGn.DtoVolR[J] AND VtaListaMinGn.DtoVolR[J] > 0  THEN DO:
                /* Determinamos cuál es mayor, el Promocional o Por Volúmen */
                IF X-RANGO  = 0 THEN X-RANGO = VtaListaMinGn.DtoVolR[J].
                IF X-RANGO <= VtaListaMinGn.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = VtaListaMinGn.DtoVolR[J]
                        F-DSCTOS = 0
                        F-PREVTA = VtaListaMinGn.PreOfi
                        Y-DSCTOS = VtaListaMinGn.DtoVolD[J] 
                        X-TIPDTO = "VOL".
                    IF s-MonVta = 1 THEN
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / s-TpoCmb,6).
                    ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * s-TpoCmb,6).
                    X-PREVTA1 = X-PREVTA1.
                    X-PREVTA2 = X-PREVTA2.
                END.   
            END.   
        END.
    END.
    /* PRECIO FINAL */
    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
        IF S-CODMON = 1 THEN F-PREBAS = X-PREVTA1.
        ELSE F-PREBAS = X-PREVTA2.     
        /* RECALCULAMOS PRECIOS EN CASO DE PROMOCIONAL */
        /* RHC 29/02/2016 No modificamos el precio unitario */
/*         IF x-TipDto = "PROM" THEN DO:                      */
/*             ASSIGN                                         */
/*                 F-PREVTA = F-PREBAS * (1 - Y-DSCTOS / 100) */
/*                 Y-DSCTOS = 0.                              */
/*         END.                                               */
    END.    
END.


/* *********************************** */
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
/* *********************************** */
/* DESCUENTOS ADICIONALES POR DIVISION */
ASSIGN
    z-Dsctos = 0.

/* RHC 13/02/2014 PRODUCTOS SIN NINGUN TIPO DE DESCUENTO ENCARTE (SELLO ROJO )*/
/* IF ( TODAY >= 02/15/2015 AND TODAY <= 03/15/2015 ) THEN DO:     /* Vigente hasta el 2 de Marzo 2014 */ */
/*     FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia                                               */
/*         AND VtaTabla.Tabla = "UTILEX-ROJO"                                                             */
/*         AND VtaTabla.Llave_c1 = Almmmatg.CodMat                                                        */
/*         NO-LOCK NO-ERROR.                                                                              */
/*     IF AVAILABLE VtaTabla THEN x-TipDto = "UTILEX-ROJO".                                               */
/* END.                                                                                                   */
RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

