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
 
DEFINE VAR s-codcia AS INT INIT 1.   

/* Tablas a usar */
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu. 
DEFINE BUFFER x-ccbddocu FOR ccbddocu. 

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu. 
DEFINE BUFFER b-ccbddocu FOR ccbddocu.

/* Temporales */
DEFINE TEMP-TABLE t-ccbcdocu LIKE ccbcdocu.
DEFINE TEMP-TABLE t-ccbddocu LIKE ccbddocu.

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

DEFINE VAR x-tabla AS CHAR INIT "CCBCDOCU".

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
         HEIGHT             = 5.19
         WIDTH              = 69.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
        
IF TRUE <> (pCodDiv > "") THEN DO:
    /* Sin division */
    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                x-ccbcdocu.coddoc = pCodDoc AND
                                x-ccbcdocu.nrodoc = pNroDOc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-ccbcdocu THEN DO:
        pRetVal = "COMPROBANTE " + pCodDoc + "-" + pNroDOc + " No existe".
        RETURN "ADM-ERROR".
    END. 
    IF x-ccbcdocu.flgest = 'A' THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " Esta ANULADO".  
        RETURN "ADM-ERROR".        
    END.  
END.
ELSE DO:  
    /* Con division */
    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                x-ccbcdocu.coddiv = pCodDiv AND
                                x-ccbcdocu.coddoc = pCodDoc AND
                                x-ccbcdocu.nrodoc = pNroDOc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-ccbcdocu THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " Division :" + pCodDiv + " No existe".
        RETURN "ADM-ERROR".
    END.
    IF x-ccbcdocu.flgest = 'A' THEN DO:
        pRetVal = pCodDoc + "-" + pNroDOc + " Division :" + pCodDiv + " Esta ANULADO".
        RETURN "ADM-ERROR".  
    END.
END.

/* Calculos */
x-tabla = "CCBCDOCU".
RUN calculo-de-importes(OUTPUT pRetVal).
/*MESSAGE 'uno >>>' pretval.*/
IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.

/* GRABAR DATA */
RUN grabar-importes(OUTPUT pRetVal).
/*MESSAGE 'dos >>>' pretval.*/
IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.

RETURN "OK".


{sunat/sunat-calculo-importes-continental.i ~
    &CabeceraBuffer="b-Ccbcdocu" ~
    &DetalleBuffer="b-Ccbddocu" ~
    &CabeceraX="x-Ccbcdocu" ~
    &DetalleX="x-Ccbddocu" &CabeceraTempo="t-Ccbcdocu" ~
    &DetalleTempo="t-Ccbddocu" ~
    &cantidad = "candes" ~
    &nrodoc = "nrodoc" ~
    &fechaemision = "fchdoc"}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


