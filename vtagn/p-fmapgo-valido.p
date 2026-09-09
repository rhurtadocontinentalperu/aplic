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
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Lista de Precios o División */

DEF OUTPUT PARAMETER pFmaPgo AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE BUFFER x-vtatabla FOR vtatabla.

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
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR i AS INT NO-UNDO.

pFmaPgo = ''.

/* ************************************************************************************************* */
/* Valores por Defecto: Condiciones de venta contado */
/* ************************************************************************************************* */
DEF VAR x-Contado AS CHAR INIT '001,002,899,900' NO-UNDO.

DO i = 1 TO NUM-ENTRIES(x-Contado):
    FIND FIRST gn-convt WHERE gn-convt.codig = ENTRY(i, x-Contado) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt OR gn-convt.Estado <> "A" THEN NEXT.
    IF pFmaPgo = '' 
        THEN pFmaPgo = ENTRY(i, x-Contado).
    ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, x-Contado).
END.
/* ************************************************************************************************* */
/* Condiciones de ventas del cliente */
/* ************************************************************************************************* */
FIND FIRST gn-clie WHERE codcia = cl-codcia AND codcli = pCodCli NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN DO:
    DO i = 1 TO NUM-ENTRIES(gn-clie.CndVta):
        /* RHC 09/05/2014 SOLO condiciones de ventas válidas */
        FIND FIRST gn-convt WHERE gn-convt.codig = ENTRY(i, gn-clie.CndVta) NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt AND gn-convt.Estado <> "A" THEN NEXT.
        IF LOOKUP ( ENTRY(i, gn-clie.CndVta), pFmaPgo ) = 0 AND ENTRY(i, gn-clie.CndVta) <> "000"
            THEN IF pFmaPgo = '' 
                    THEN pFmaPgo = ENTRY(i, gn-clie.CndVta).
                    ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, gn-clie.CndVta).
    END.
END.
/* ************************************************************************************************* */
/* Agregamos Transferencias Gratuita */
/* RHC 11.07.2012 SOLO CLIENTE 11111111112 */
/* ************************************************************************************************* */
IF pCodCli = '11111111112' THEN DO:
    FIND FIRST gn-convt WHERE gn-convt.codig = '899' NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt AND gn-convt.Estado = "A" THEN pFmaPgo = '899'.
END.
/* ************************************************************************************************* */
/* RHC 04/07/2015 */
CASE TRUE:
    WHEN pTpoPed = "E" THEN DO:       /* Eventos */
        /* Contados */
        pFmaPgo = ''.
        DO i = 1 TO NUM-ENTRIES(x-Contado):
            FIND FIRST gn-convt WHERE gn-convt.codig = ENTRY(i, x-Contado) NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-convt OR gn-convt.Estado <> "A" THEN NEXT.
            IF pFmaPgo = '' 
                THEN pFmaPgo = ENTRY(i, x-Contado).
            ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, x-Contado).
        END.
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
/* ************************************************************************************************* */
/* 
    Ic - 02Feb2021 , condiciones de ventas para la division
*/
/* ************************************************************************************************* */
DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-llave_c1 AS CHAR INIT "DIV.VTA-COND.VTA".
DEFINE VAR x-llave_c2 AS CHAR INIT "".

FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = x-tabla AND
                            x-vtatabla.llave_c1 = x-llave_c1 AND
                            x-vtatabla.llave_c2 = pCodDiv NO-LOCK :
    FIND FIRST gn-convt WHERE gn-convt.codig = x-vtatabla.llave_c3 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt OR gn-convt.Estado <> "A" THEN NEXT.
    IF pFmaPgo = '' THEN DO:
        pFmaPgo = x-vtatabla.llave_c3.
    END.
    ELSE DO:
        pFmaPgo = pFmaPgo + ',' + x-vtatabla.llave_c3.
    END.    
END.

/* 06/03/2023: Venta Ininerante D.Llican */
IF LOOKUP(pCodDiv, '00600,00610') > 0 THEN pFmaPgo = '001'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Nueva-Rutina) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Nueva-Rutina Procedure 
PROCEDURE Nueva-Rutina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solicitado por Carka Tenazoa, pero aún está en evaluación
------------------------------------------------------------------------------*/

/* ***************************  Main Block  *************************** */
DEF VAR i AS INT NO-UNDO.

/* 19/09/2024: Carla Tenazoa, debe ir primero la condición de venta del cliente
Solo condiciones de ventas ACTIVAS 
*/
/* ************************************************************************************************* */
/* 1) Las condiciones de venta del cliente y en ese orden */
/* ************************************************************************************************* */
DEF VAR cFmaPgo AS CHAR NO-UNDO.

pFmaPgo = ''.
cFmaPgo = ''.
FIND FIRST gn-clie WHERE codcia = cl-codcia AND codcli = pCodCli NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie AND NUM-ENTRIES(gn-clie.CndVta) > 0 THEN DO:
    DO i = 1 TO NUM-ENTRIES(gn-clie.CndVta):
        /* RHC 09/05/2014 SOLO condiciones de ventas válidas */
        FIND FIRST gn-convt WHERE gn-convt.codig = ENTRY(i, TRIM(gn-clie.CndVta)) NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-convt THEN NEXT.
        IF gn-convt.Estado <> "A" THEN NEXT.
        IF gn-convt.Codig = '000' THEN NEXT.

        cFmaPgo = cFmaPgo +
            (IF TRUE <> (cFmaPgo > '') THEN '' ELSE ',') +
            TRIM(ENTRY(i, gn-clie.CndVta)).

    END.
END.
/* ************************************************************************************************* */
/* 2) Ordenamos: primero Crédito y después contado */
/* ************************************************************************************************* */
IF cFmaPgo > "" THEN DO:
    /* Crédito */
    FOR EACH gn-convt NO-LOCK WHERE gn-convt.Estado = "A" AND gn-ConVt.TipVta = "2" AND LOOKUP(TRIM(gn-ConVt.Codig),cFmaPgo) > 0:
        pFmaPgo = pFmaPgo +
            (IF TRUE <> (pFmaPgo > '') THEN '' ELSE ',') +
            TRIM(gn-ConVt.Codig).
    END.
    /* Contado */
    FOR EACH gn-convt NO-LOCK WHERE gn-convt.Estado = "A" AND gn-ConVt.TipVta = "1" AND LOOKUP(TRIM(gn-ConVt.Codig),cFmaPgo) > 0:
        pFmaPgo = pFmaPgo +
            (IF TRUE <> (pFmaPgo > '') THEN '' ELSE ',') +
            TRIM(gn-ConVt.Codig).
    END.
END.
/* ************************************************************************************************* */
/* 3) Las condiciones de venta al contado excepto la 000 que se usa exclusivamente en ventas mostrador 
        y la 899 solo para transferencias gratuitas 
*/
/* ************************************************************************************************* */
FOR EACH gn-convt NO-LOCK WHERE gn-ConVt.Estado = "A" AND 
        gn-ConVt.TipVta = "1" AND 
        LOOKUP(TRIM(gn-ConVt.Codig),"000,899") = 0:
    IF gn-convt.Libre_L02 = YES THEN NEXT.      /* OJO: NO CONDICION VENTA UNICA CAMPAÑA */
    IF gn-convt.Libre_L03 = YES THEN NEXT.      /* OJO: NO ANTICIPO CAMPAÑA */
    IF LOOKUP(TRIM(gn-ConVt.Codig), pFmaPgo) > 0 THEN NEXT.
    pFmaPgo = pFmaPgo +
        (IF TRUE <> (pFmaPgo > '') THEN '' ELSE ',') +
        TRIM(gn-ConVt.Codig).
END.
/* ************************************************************************************************* */
/* 4) EVENTOS */
/* ************************************************************************************************* */
/* RHC 04/07/2015 */
CASE TRUE:
    WHEN pTpoPed = "E" THEN DO:       /* Eventos */
        /* EVENTOS & CAMPAÑA */
        FOR EACH gn-convt NO-LOCK WHERE gn-convt.Estado = "A" AND (gn-convt.Libre_L02 = YES OR gn-convt.Libre_L03 = YES):
            IF LOOKUP(TRIM(gn-ConVt.Codig), pFmaPgo) > 0 THEN NEXT.
            pFmaPgo = pFmaPgo +
                (IF TRUE <> (pFmaPgo > '') THEN '' ELSE ',') +
                TRIM(gn-ConVt.Codig).
        END.
    END.
    WHEN pCodCli = 'SYS00000001' THEN DO:   /* Cliente para pruebas */
        pFmaPgo = ''.
        FOR EACH gn-convt NO-LOCK WHERE gn-convt.estado = "A":
            pFmaPgo = pFmaPgo + (IF pFmaPgo = '' THEN '' ELSE ',') + gn-ConVt.Codig.
      END.
    END.
END CASE.
/* ************************************************************************************************* */
/* 5) Ic - 02Feb2021 , condiciones de ventas para la division */
/* ************************************************************************************************* */
DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-llave_c1 AS CHAR INIT "DIV.VTA-COND.VTA".
DEFINE VAR x-llave_c2 AS CHAR INIT "".

FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
    x-vtatabla.tabla = x-tabla AND
    x-vtatabla.llave_c1 = x-llave_c1 AND
    x-vtatabla.llave_c2 = pCodDiv NO-LOCK :
    FIND FIRST gn-convt WHERE gn-convt.codig = x-vtatabla.llave_c3 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt OR gn-convt.Estado <> "A" THEN NEXT.
    IF LOOKUP(TRIM(gn-ConVt.Codig), pFmaPgo) > 0 THEN NEXT.
    pFmaPgo = pFmaPgo +
        (IF TRUE <> (pFmaPgo > '') THEN '' ELSE ',') +
        TRIM(x-vtatabla.llave_c3).
END.

/* ************************************************************************************************* */
/* 6) Agregamos Transferencias Gratuita */
/* RHC 11.07.2012 SOLO CLIENTE 11111111112 */
/* ************************************************************************************************* */
IF pCodCli = '11111111112' THEN DO:
    FIND FIRST gn-convt WHERE gn-convt.codig = '899' NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt AND gn-convt.Estado = "A" THEN pFmaPgo = '899'.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Vieja-Rutina) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Vieja-Rutina Procedure 
PROCEDURE Vieja-Rutina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ***************************  Main Block  *************************** */
DEF VAR i AS INT NO-UNDO.

pFmaPgo = ''.

/* ************************************************************************************************* */
/* Valores por Defecto: Condiciones de venta contado */
/* ************************************************************************************************* */
DEF VAR x-Contado AS CHAR INIT '001,002,899,900' NO-UNDO.

DO i = 1 TO NUM-ENTRIES(x-Contado):
    FIND FIRST gn-convt WHERE gn-convt.codig = ENTRY(i, x-Contado) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt OR gn-convt.Estado <> "A" THEN NEXT.
    IF pFmaPgo = '' 
        THEN pFmaPgo = ENTRY(i, x-Contado).
    ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, x-Contado).
END.
/* ************************************************************************************************* */
/* Condiciones de ventas del cliente */
/* ************************************************************************************************* */
FIND FIRST gn-clie WHERE codcia = cl-codcia AND codcli = pCodCli NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN DO:
    DO i = 1 TO NUM-ENTRIES(gn-clie.CndVta):
        /* RHC 09/05/2014 SOLO condiciones de ventas válidas */
        FIND FIRST gn-convt WHERE gn-convt.codig = ENTRY(i, gn-clie.CndVta) NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt AND gn-convt.Estado <> "A" THEN NEXT.
        IF LOOKUP ( ENTRY(i, gn-clie.CndVta), pFmaPgo ) = 0 AND ENTRY(i, gn-clie.CndVta) <> "000"
            THEN IF pFmaPgo = '' 
                    THEN pFmaPgo = ENTRY(i, gn-clie.CndVta).
                    ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, gn-clie.CndVta).
    END.
END.
/* ************************************************************************************************* */
/* Agregamos Transferencias Gratuita */
/* RHC 11.07.2012 SOLO CLIENTE 11111111112 */
/* ************************************************************************************************* */
IF pCodCli = '11111111112' THEN DO:
    FIND FIRST gn-convt WHERE gn-convt.codig = '899' NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt AND gn-convt.Estado = "A" THEN pFmaPgo = '899'.
END.
/* ************************************************************************************************* */
/* RHC 04/07/2015 */
CASE TRUE:
    WHEN pTpoPed = "E" THEN DO:       /* Eventos */
        /* Contados */
        pFmaPgo = ''.
        DO i = 1 TO NUM-ENTRIES(x-Contado):
            FIND FIRST gn-convt WHERE gn-convt.codig = ENTRY(i, x-Contado) NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-convt OR gn-convt.Estado <> "A" THEN NEXT.
            IF pFmaPgo = '' 
                THEN pFmaPgo = ENTRY(i, x-Contado).
            ELSE pFmaPgo = pFmaPgo + ',' + ENTRY(i, x-Contado).
        END.
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
/* ************************************************************************************************* */
/* 
    Ic - 02Feb2021 , condiciones de ventas para la division
*/
/* ************************************************************************************************* */
DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-llave_c1 AS CHAR INIT "DIV.VTA-COND.VTA".
DEFINE VAR x-llave_c2 AS CHAR INIT "".

FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = x-tabla AND
                            x-vtatabla.llave_c1 = x-llave_c1 AND
                            x-vtatabla.llave_c2 = pCodDiv NO-LOCK :
    FIND FIRST gn-convt WHERE gn-convt.codig = x-vtatabla.llave_c3 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-convt OR gn-convt.Estado <> "A" THEN NEXT.
    IF pFmaPgo = '' THEN DO:
        pFmaPgo = x-vtatabla.llave_c3.
    END.
    ELSE DO:
        pFmaPgo = pFmaPgo + ',' + x-vtatabla.llave_c3.
    END.    
END.

/* 06/03/2023: Venta Ininerante D.Llican */
IF LOOKUP(pCodDiv, '00600,00610') > 0 THEN pFmaPgo = '001'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

