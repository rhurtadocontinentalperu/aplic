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
DEFINE INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.     /* Puede ser vacio tambien */
DEFINE INPUT PARAMETER pCoddoc AS CHAR NO-UNDO.     /* COT,PED,P/M,O/M,O/D */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO. 

DEFINE SHARED VAR s-codcia AS INTE.   

/* Tablas a usar */ 
DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-facdpedi FOR facdpedi.

DEFINE BUFFER z-faccpedi FOR faccpedi.

DEFINE BUFFER b-faccpedi FOR faccpedi. 
DEFINE BUFFER b-facdpedi FOR facdpedi. 

/* Temporales */
DEFINE TEMP-TABLE t-faccpedi LIKE faccpedi.
DEFINE TEMP-TABLE t-facdpedi LIKE facdpedi.

/* Impuesto a la bolsas plasticas */
DEFINE VAR x-articulo-ICBPER AS CHAR.
DEFINE VAR x-linea-bolsas-plastica AS CHAR.
DEFINE VAR x-precio-ICBPER AS DEC.
DEFINE VAR x-TotalImpuestoBolsaPlastica AS DECI INIT 0 NO-UNDO.

x-articulo-ICBPER = "099268".
x-linea-bolsas-plastica = "086".
/**/
DEFINE VAR x-es-transferencia-gratuita AS LOG.
DEFINE VAR x-tasaigv AS DEC.
DEFINE VAR x-existe-icbper AS LOG.

DEFINE VAR x-tabla AS CHAR INIT "FACCPEDI".

DEFINE VAR cPlataforma AS CHAR.
DEFINE VAR cDivVta AS CHAR.
DEFINE VAR dImpTot AS DEC.  /* Importe Total para caso Riqra */

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
         HEIGHT             = 5.15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

pRetVal = "OK". 

IF TRUE <> (pCodDiv > "") THEN DO: 
    /* Sin division */ 
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = pCodDoc AND
                                x-faccpedi.nroped = pNroDOc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-faccpedi THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " No existe".
        RETURN "ADM-ERROR". 
    END.  
    IF x-faccpedi.flgest = 'A' THEN DO: 
        pRetVal = pCodDoc + "-" + pNroDOc + " Esta ANULADO".  
        RETURN "ADM-ERROR".
    END. 
END. 
ELSE DO:    
    /* Con division */ 
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddiv = pCodDiv AND
                                x-faccpedi.coddoc = pCodDoc AND
                                x-faccpedi.nroped = pNroDOc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-faccpedi THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " Division :" + pCodDiv + " No existe".
        RETURN "ADM-ERROR".
    END.
    IF x-faccpedi.flgest = 'A' THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " Division :" + pCodDiv + " Esta ANULADO".
        RETURN "ADM-ERROR".    
    END.
END. 

DEFINE VAR cNroCotizacion AS CHAR.
DEFINE VAR cNroPedido AS CHAR.

/* Verificar si viene desde RIQRA */
IF x-faccpedi.coddoc = 'COT' THEN DO:
    cPlataforma = x-faccpedi.CodOrigen.
    dImpTot = x-faccpedi.imptot.
END.
ELSE DO:
    IF x-faccpedi.coddoc = 'O/D' THEN DO:
        cNroPedido = x-faccpedi.nroref.      /* El PED */
        FIND FIRST z-faccpedi WHERE z-faccpedi.codcia = 1 AND z-faccpedi.coddoc = 'PED' AND 
                                z-faccpedi.nroped = cNroPedido NO-LOCK NO-ERROR.
        IF AVAILABLE z-faccpedi THEN DO:
            cNroCotizacion = z-faccpedi.nroref.
        END.
    END.
    IF x-faccpedi.coddoc = 'PED' THEN DO:
        cNroCotizacion = x-faccpedi.nroref.
    END.
    FIND FIRST z-faccpedi WHERE z-faccpedi.codcia = 1 AND z-faccpedi.coddoc = 'COT' AND 
                            z-faccpedi.nroped = cNroCotizacion NO-LOCK NO-ERROR.
    IF AVAILABLE z-faccpedi THEN DO:
        cPlataforma = z-faccpedi.CodOrigen.
        dImpTot = z-faccpedi.imptot.
    END.
END.
cDivVta = x-faccpedi.coddiv.

/* Calculos */
x-tabla = "FACCPEDI".
RUN calculo-de-importes(OUTPUT pRetVal).
IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.

/* GRABAR DATA */
RUN grabar-importes(OUTPUT pRetVal).
IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.

RETURN "OK".


{sunat/sunat-calculo-importes-calcular.i &CabeceraBuffer="b-FacCpedi" ~
    &DetalleBuffer="b-FacDpedi" ~
    &CabeceraX="x-FacCpedi" ~
    &DetalleX="x-FacDpedi" ~
    &CabeceraTempo="t-FacCpedi" ~
    &DetalleTempo="t-FacDpedi" ~
    &Cantidad="canped" ~
    &nrodoc="nroped" ~
    &fechaemision="fchped"}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


