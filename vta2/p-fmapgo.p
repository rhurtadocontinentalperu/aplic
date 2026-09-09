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
         HEIGHT             = 3.73
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pTpoPed AS CHAR.
DEF OUTPUT PARAMETER pFmaPgo AS CHAR.

DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR i AS INT NO-UNDO.

/* Condiciones de ventas del cliente */
pFmaPgo = ''.
FIND gn-clie WHERE codcia = cl-codcia
    AND codcli = pCodCli NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN RETURN.
DO i = 1 TO NUM-ENTRIES(gn-clie.CndVta):
    /* RHC 09/05/2014 SOLO condiciones de ventas válidas */
    FIND gn-convt WHERE gn-convt.codig = ENTRY(i, gn-clie.CndVta) NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt AND gn-convt.Estado <> "A" THEN NEXT.

    IF LOOKUP ( ENTRY(i, gn-clie.CndVta), pFmaPgo ) = 0 AND ENTRY(i, gn-clie.CndVta) <> "000"
    THEN IF pFmaPgo = '' 
        THEN pFmaPgo = ENTRY(i, gn-clie.CndVta).
        ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, gn-clie.CndVta).
END.

/* Condiciones de venta contado */
FOR EACH gn-convt NO-LOCK WHERE LOOKUP(Codig, '000,001,002,900') > 0:
/*FOR EACH gn-convt NO-LOCK WHERE LOOKUP(Codig, '000,001,002') > 0:*/
    IF LOOKUP ( gn-convt.codig, pFmaPgo ) = 0 
    THEN IF pFmaPgo = '' 
        THEN pFmaPgo = gn-convt.codig.
        ELSE pFmaPgo = pFmaPgo + ',' + gn-convt.codig.
END.
/* Agregamos Transferencias Gratuita */
/* RHC 11.07.2012 SOLO CLIENTE 11111111112 */
IF pCodCli = '11111111112' THEN pFmaPgo = '900'.

/* RHC 04/07/2015 */
CASE TRUE:
    WHEN pTpoPed = "E" THEN DO:       /* Eventos */
        /* 10Ago2016 - Cond.Vta 411 */
        /* Ic - Correo 
            10Ago2017 de Julissa Calderon(Camus) Add 376,381 
        */
        pFmaPgo = '001,002,400,401,403,404,405,406,407,410,411,377,900,899,376,381'.
        /* Correo Julissa Calderon 18/09/2017 */
        /*pFmaPgo = '001,404'.*/
    END.
    WHEN s-CodDiv = '20060' THEN DO:    /* Arequipa */
        pFmaPgo = '001,400,401,403,404,405,406,407,410,377,505'.
    END.
    WHEN pCodCli = 'SYS00000001' THEN DO:   /* Cliente para pruebas */
        pFmaPgo = ''.
        FOR EACH gn-convt NO-LOCK WHERE gn-convt.estado = "A":
            pFmaPgo = pFmaPgo + (IF pFmaPgo = '' THEN '' ELSE ',') + gn-ConVt.Codig.
      END.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


