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


DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pTpoPed AS CHAR.
/*DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Lista de Precios o División */*/
DEF OUTPUT PARAMETER pFmaPgo AS CHAR.

DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

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
DEF VAR i AS INT NO-UNDO.

pFmaPgo = ''.
/* Condiciones de ventas del cliente */
FIND gn-clie WHERE codcia = cl-codcia AND codcli = pCodCli NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN DO:
    DO i = 1 TO NUM-ENTRIES(gn-clie.CndVta):
        /* RHC 09/05/2014 SOLO condiciones de ventas válidas */
        FIND gn-convt WHERE gn-convt.codig = ENTRY(i, gn-clie.CndVta) NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt AND gn-convt.Estado <> "A" THEN NEXT.
        IF LOOKUP ( ENTRY(i, gn-clie.CndVta), pFmaPgo ) = 0 
            AND ENTRY(i, gn-clie.CndVta) <> "000"
            THEN IF pFmaPgo = '' 
                    THEN pFmaPgo = ENTRY(i, gn-clie.CndVta).
                    ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, gn-clie.CndVta).
    END.
END.
/* Valores por Defecto: Condiciones de venta contado */
DEF VAR x-Contado AS CHAR INIT '001,002,899' NO-UNDO.
DO i = 1 TO NUM-ENTRIES(x-Contado):
    FIND gn-convt WHERE gn-convt.codig = ENTRY(i, x-Contado) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt OR gn-convt.Estado <> "A" THEN NEXT.
    IF pFmaPgo = '' 
        THEN pFmaPgo = ENTRY(i, x-Contado).
    ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, x-Contado).
END.
/* FOR EACH gn-convt NO-LOCK WHERE LOOKUP(Codig, '001,002,899') > 0: */
/*     IF pFmaPgo = ''                                               */
/*         THEN pFmaPgo = gn-convt.codig.                            */
/*         ELSE pFmaPgo = pFmaPgo + ',' + gn-convt.codig.            */
/* END.                                                              */
/* Agregamos Transferencias Gratuita */
/* RHC 11.07.2012 SOLO CLIENTE 11111111112 */
IF pCodCli = '11111111112' THEN DO:
    FIND gn-convt WHERE gn-convt.codig = '899' NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt AND gn-convt.Estado = "A" THEN pFmaPgo = '899'.
END.
/* RHC 04/07/2015 */
CASE TRUE:
    WHEN pTpoPed = "E" THEN DO:       /* Eventos */
        /* Contados */
        pFmaPgo = ''.
        DO i = 1 TO NUM-ENTRIES(x-Contado):
            FIND gn-convt WHERE gn-convt.codig = ENTRY(i, x-Contado) NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-convt OR gn-convt.Estado <> "A" THEN NEXT.
            IF pFmaPgo = '' 
                THEN pFmaPgo = ENTRY(i, x-Contado).
            ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, x-Contado).
        END.
        /*pFmaPgo = "001,002,899".*/
        /* Eventos */
        FOR EACH gn-convt WHERE gn-convt.Estado = "A" AND gn-convt.TipVta = "2" AND
            gn-convt.Libre_L02 = YES:
            IF pFmaPgo = '' 
                    THEN pFmaPgo = gn-ConVt.Codig.
                    ELSE pFmaPgo = pFmaPgo + ',' + gn-ConVt.Codig.

        END.
        /* Anticipo Campaña */
        FOR EACH gn-convt WHERE gn-convt.Estado = "A" AND gn-convt.TipVta = "1" AND
            gn-convt.Libre_L03 = YES:
            IF pFmaPgo = '' 
                    THEN pFmaPgo = gn-ConVt.Codig.
                    ELSE pFmaPgo = pFmaPgo + ',' + gn-ConVt.Codig.

        END.
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


