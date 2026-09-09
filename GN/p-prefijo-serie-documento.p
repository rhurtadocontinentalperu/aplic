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
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.             /* Acepta vacio */
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE SHARED VAR s-codcia AS INT.

/**/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fget-doc-original) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-doc-original Procedure 
FUNCTION fget-doc-original RETURNS CHARACTER
      ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-prefijo-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-prefijo-serie Procedure 
FUNCTION fget-prefijo-serie RETURNS CHARACTER
    (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


DEFINE VAR lxRet AS CHAR.

lxRet = fGet-Prefijo-Serie(pCodDoc, pNroDoc, pCodDiv).

pRetVal = lxRet.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fget-doc-original) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-doc-original Procedure 
FUNCTION fget-doc-original RETURNS CHARACTER
      ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR) :
    /*------------------------------------------------------------------------------
      Purpose:  Se debe enviar N/C o N/D
        Notes:  
    ------------------------------------------------------------------------------*/
        DEFINE VAR lRetVal AS CHAR.

        DEFINE VAR lDocFactura AS CHAR.
        DEFINE VAR lDocBoleta AS CHAR.
        DEFINE VAR lDocLetra AS CHAR.

        lRetVal = ?.

        DEFINE BUFFER fx-ccbcdocu FOR ccbcdocu.
        DEFINE BUFFER fx-ccbdmvto FOR ccbdmvto.

        FIND FIRST fx-ccbcdocu USE-INDEX llave01 WHERE fx-ccbcdocu.codcia = s-codcia AND 
                                        fx-ccbcdocu.coddoc = pTipoDoc AND 
                                        fx-ccbcdocu.nrodoc = pNroDoc 
                                        NO-LOCK NO-ERROR.
        IF AVAILABLE fx-ccbcdocu THEN DO:    
            /*DISPLAY fx-ccbcdocu.coddoc fx-ccbcdocu.nrodoc fx-ccbcdocu.codref fx-ccbcdocu.nroref.*/
            IF fx-ccbcdocu.codref = 'FAC' OR fx-ccbcdocu.codref = 'BOL' OR 
                    fx-ccbcdocu.codref = 'TCK' THEN DO:

                IF fx-ccbcdocu.codref = 'FAC' THEN lRetVal = 'F' + fx-ccbcdocu.nroref.
                IF fx-ccbcdocu.codref = 'BOL' OR fx-ccbcdocu.codref = 'TCK' THEN lRetVal = 'B' + fx-ccbcdocu.nroref.        

            END.
            ELSE DO:            
                IF fx-ccbcdocu.codref = 'LET' THEN DO:
                    /* Como Referencia - LETRA */
                    lRetVal = fget-doc-original(fx-ccbcdocu.codref, fx-ccbcdocu.nroref).
                END.
                ELSE DO:
                    IF fx-ccbcdocu.codref = 'CJE' OR fx-ccbcdocu.codref = 'RNV' OR fx-ccbcdocu.codref = 'REF' THEN DO:
                        /* Si en CANJE, RENOVACION y REFINANCIACION */
                        lDocFactura = "".
                        lDocBoleta = "".
                        lDocLetra = "".
                        /*DISPLAY pTipoDoc pNroDoc.*/                    
                        FOR EACH fx-ccbdmvto WHERE fx-ccbdmvto.codcia = s-codcia AND 
                                                    fx-ccbdmvto.coddoc = fx-ccbcdocu.codref AND 
                                                    fx-ccbdmvto.nrodoc = fx-ccbcdocu.nroref NO-LOCK:                        

                            IF fx-ccbdmvto.nroref <> pnroDoc THEN DO:
                                IF fx-ccbdmvto.codref = 'FAC' OR fx-ccbdmvto.codref = 'BOL' THEN DO:
                                    IF fx-ccbdmvto.codref = 'FAC' AND lDocFactura = "" THEN lDocFactura = "F" + fx-ccbdmvto.nroref.
                                    IF fx-ccbdmvto.codref = 'BOL' AND lDocBoleta = "" THEN lDocBoleta = "B" + fx-ccbdmvto.nroref.
                                    LEAVE.
                                END.
                                ELSE DO:
                                    IF fx-ccbdmvto.codref = 'LET' THEN  DO:                                    
                                        lRetVal = fget-doc-original("LET", fx-ccbdmvto.nroref).
                                        /*DISPLAY fx-ccbdmvto.codref fx-ccbdmvto.nroref lRetVal.*/
                                        IF SUBSTRING(lRetVal,1,1) = 'F' OR SUBSTRING(lRetVal,1,1) = 'B' THEN DO:
                                            IF SUBSTRING(lRetVal,1,1)='F' AND lDocFactura = "" THEN lDocFactura = lRetVal.
                                            IF SUBSTRING(lRetVal,1,1)="B" AND lDocBoleta = "" THEN lDocBoleta = lRetVal.
                                            LEAVE.
                                        END.
                                    END.
                                END.
                            END.
                        END.

                        IF lDocFactura  = "" AND lDocBoleta = "" AND lDocLetra <> "" THEN DO:
                            /* es una LETRA */
                            /*lRetVal = fget-doc-original("LET", lDocLetra).*/
                        END.
                        ELSE DO:
                            IF lDocBoleta  <> "" THEN lRetVal = lDocBoleta.
                            IF lDocFactura  <> "" THEN lRetVal = lDocFactura.
                        END.
                    END.
                    /* 
                        Puede que hayan CLA : Canje x letra adelantada, pero el dia que salte ese error
                        ya se programa...
                    */
                    IF fx-ccbcdocu.codref = 'CLA' THEN DO:
                        /* Buscar el A/R */
                        DEFINE BUFFER zx-ccbcdocu FOR ccbcdocu.
                        FIND FIRST zx-ccbcdocu WHERE  zx-ccbcdocu.codcia = s-codcia AND 
                                                    zx-ccbcdocu.coddoc = 'A/R' AND 
                                                    zx-ccbcdocu.codref = "CLA" AND
                                                    zx-ccbcdocu.nroref = fx-ccbcdocu.nroref 
                                                    NO-LOCK NO-ERROR.
                        IF AVAILABLE zx-ccbcdocu THEN DO:
                            /**/
                            DEFINE BUFFER zx-ccbdmov FOR ccbdmov.
                            FIND FIRST zx-ccbdmov WHERE zx-ccbdmov.codcia = s-codcia AND 
                                                    zx-ccbdmov.coddoc = 'A/R' AND 
                                                    zx-ccbdmov.nrodoc = zx-ccbcdocu.nrodoc
                                                    NO-LOCK NO-ERROR.
                            IF AVAILABLE zx-ccbdmov THEN DO:
                                /* Caja */
                                DEFINE BUFFER zx-ccbdcaja FOR ccbdcaja.
                                FOR EACH zx-ccbdcaja WHERE zx-ccbdcaja.codcia = s-codcia AND 
                                                            zx-ccbdcaja.coddoc = zx-ccbdmov.codref AND 
                                                            zx-ccbdcaja.nrodoc = zx-ccbdmov.nroref
                                                            NO-LOCK:
                                    IF zx-ccbdcaja.codref = 'FAC' OR zx-ccbdcaja.codref = 'BOL' THEN DO:
                                        IF zx-ccbdcaja.codref = 'FAC' THEN lRetVal = "F" + zx-ccbdcaja.nroref.
                                        IF zx-ccbdcaja.codref = 'BOL' THEN lRetVal = "B" + zx-ccbdcaja.nroref.
                                        LEAVE.
                                    END.
                                END.
                                RELEASE zx-ccbdcaja.
                            END.
                            RELEASE zx-ccbdmov.
                        END.
                        RELEASE zx-ccbcdocu.
                    END.
                END.
            END.
        END.

        RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-prefijo-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-prefijo-serie Procedure 
FUNCTION fget-prefijo-serie RETURNS CHARACTER
    (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR) :

      DEFINE VAR lxRet AS CHAR.

      lxRet = "?".
      
      IF pTipoDoc = 'N/C' OR pTipoDoc = 'N/D' THEN DO:

          DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.            

          IF pDivision <> "" THEN DO:
              FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                          z-ccbcdocu.coddiv = pDivision AND
                                          z-ccbcdocu.coddoc = pTipoDoc AND 
                                          z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
          END.
          ELSE DO:
              FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                          z-ccbcdocu.coddoc = pTipoDoc AND 
                                          z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
          END.

          IF AVAILABLE z-ccbcdocu THEN DO:
              IF z-ccbcdocu.codref = 'LET' THEN DO:
                  /* la Referencia es una LETRA, es un CANJE */
                  /* Devuelve el documento Original F001001255 o B145001248 */
                  lxRet = fget-doc-original(z-ccbcdocu.codref, z-ccbcdocu.nroref).                
                  lxRet = SUBSTRING(lxRet,1,1).
              END.
              ELSE lxRet = fGet-Prefijo-Serie(z-ccbcdocu.codref, z-ccbcdocu.nroref, "").
          END.
          ELSE lxRet = "?".

          /*RELEASE z-ccbcdocu.*/
      END.
      ELSE DO:
          IF pTipoDoc = 'FAC' THEN lxRet = 'F'.
          IF pTipoDoc = 'BOL' OR pTipoDoc = 'TCK' THEN lxRet = 'B'.        
      END.
      
    RETURN lxRet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

