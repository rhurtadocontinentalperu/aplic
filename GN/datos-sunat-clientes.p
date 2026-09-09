&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Informacion de SUNAT

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEF INPUT  PARAMETER pRUC AS CHAR.
DEF OUTPUT PARAMETER pBajaSunat AS LOG.
DEF OUTPUT PARAMETER pName AS CHAR.
DEF OUTPUT PARAMETER pAddress AS CHAR.
DEF OUTPUT PARAMETER pUbigeo AS CHAR.
DEF OUTPUT PARAMETER pDateInscription AS DATE.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

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
         HEIGHT             = 6.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE x-url AS CHAR NO-UNDO.
DEFINE VARIABLE x-xml AS LONGCHAR NO-UNDO.
DEFINE VARIABLE x-texto AS CHAR NO-UNDO.
DEFINE VARIABLE x-status AS CHAR NO-UNDO.
DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.
DEFINE VARIABLE x-url-addressconsult AS CHAR NO-UNDO.
DEFINE VARIABLE x-DateInscription AS CHAR NO-UNDO.

DEFINE VAR cIPorigen AS CHAR.
DEFINE VAR cIPdestino AS CHAR.
DEFINE VAR cOtrosDatos AS CHAR.

cIPorigen = "192.168.100.221".

RUN lib/redireccionar-ip(cIPorigen, cOtrosDatos, OUTPUT cIPdestino).

x-url-addressconsult = "http://" + cIPdestino + ":7000/api/consult/SUNAT".
/*x-url-addressconsult = "http://192.168.100.221:7000/api/consult/SUNAT".*/

x-url = TRIM(x-url-addressconsult).
x-url = x-url + "/" + TRIM(pRUC) .

pError = "ERROR DE CONEXION" + CHR(10) + x-url-addressconsult.

CREATE X-DOCUMENT hDoc.

DEFINE VAR x-intentos AS INT.

COMSUME_WS:
REPEAT x-intentos = 1 TO 1:
    hDoc:LOAD("FILE", x-url, FALSE) NO-ERROR.
    
    IF ERROR-STATUS:ERROR = NO THEN DO:
        hDoc:SAVE("LONGCHAR",x-xml) NO-ERROR.

        x-texto = CAPS(STRING(x-xml)).

        IF INDEX(x-texto,"<NAME>") = 0 THEN DO:
            pError = "ERROR WEBSERVICE - NAME" + CHR(13) + CHR(10) + 
                        "URL :" + x-url + CHR(13) + CHR(10) + 
                        "RESPONSE : NO SE PUDO UBICAR EL CLIENTE"  .
            RETURN.
        END.
        
        IF ERROR-STATUS:ERROR = YES THEN DO:
            pError = "ERROR WEBSERVICE - metodo SAVE" + CHR(13) + CHR(10) + 
                        "URL :" + x-url + CHR(13) + CHR(10) + 
                        "RESPONSE : " + x-texto + CHR(13) + CHR(10) +
                        "ERROR : " + ERROR-STATUS:GET-MESSAGE(1).                        
        END.
        ELSE DO:
            IF INDEX(x-texto, 'NOT FOUND') > 0 THEN DO:
                pError = "NO SE ENCONTRO EN SUNAT".
                RETURN.
            END.

            /* Status */
            RUN ReturnValue ( "status", OUTPUT x-Status).
            pBajaSunat = (IF x-Status = 'ACTIVO' THEN NO ELSE YES).
            /* Nombre */
            RUN ReturnValue ( "name", OUTPUT pName).
            RUN Limpia-Texto ( INPUT-OUTPUT pName).
            /* Direccion */
            RUN ReturnValue ( "address", OUTPUT pAddress).
            RUN Limpia-Texto ( INPUT-OUTPUT pAddress).
            /* Ubigeo */
            RUN ReturnValue ( "ubigeo", OUTPUT pUbigeo).

            /* Fecha de Inscripción */
            RUN ReturnValue ( "dateinscription", OUTPUT x-DateInscription).
            ASSIGN
                pDateInscription = DATE(INTEGER(ENTRY(2,x-DateInscription,'-')),
                                        INTEGER(ENTRY(3,x-DateInscription,'-')),
                                        INTEGER(ENTRY(1,x-DateInscription,'-')))
                NO-ERROR.

            /* Armado de la dirección */
            FIND FIRST TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
            FIND FIRST TabProvi WHERE TabProvi.CodDepto = SUBSTRING(pUbigeo,1,2) AND
                TabProvi.CodProvi = SUBSTRING(pUbigeo,3,2) NO-LOCK NO-ERROR.
            FIND FIRST TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2) AND
                TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2) AND
                TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2) NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto AND AVAILABLE TabProvi AND AVAILABLE TabDistr THEN DO:
                pAddress = TRIM(pAddress) + ' ' + 
                            CAPS(TRIM(TabDepto.NomDepto)) + ' - ' +
                            CAPS(TRIM(TabProvi.NomProvi)) + ' - ' +
                            CAPS(TabDistr.NomDistr).
            END.
            pError = "".

        END.
    END.
    ELSE DO: 
        pError = "ERROR WEBSERICE - metodo LOAD" + CHR(13) + CHR(10) +
         "URL :" + x-url + CHR(13) + CHR(10) +
        "ERROR : " + ERROR-STATUS:GET-MESSAGE(1).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Limpia-Texto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpia-Texto Procedure 
PROCEDURE Limpia-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER pTexto AS CHAR.

pTexto = REPLACE(pTexto,"&quot;",'"').

pTexto = REPLACE(pTexto,"&lt;",'<').

pTexto = REPLACE(pTexto,"&gt;",'>').

pTexto = REPLACE(pTexto,"&amp;",'&').

pTexto = REPLACE(pTexto,"&apos;","'").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ReturnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReturnValue Procedure 
PROCEDURE ReturnValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pTipo AS CHAR.
    DEF OUTPUT PARAMETER pValor AS CHAR.

    DEFINE VARIABLE x-pos1 AS INT NO-UNDO.
    DEFINE VARIABLE x-pos2 AS INT NO-UNDO.

    pValor = ''.
    DEF VAR x-Marcador-1 AS CHAR NO-UNDO.
    DEF VAR x-Marcador-2 AS CHAR NO-UNDO.

    x-Marcador-1 = "<" + TRIM(pTipo) + ">".
    x-Marcador-2 = "</" + TRIM(pTipo) + ">".
    x-pos1 = INDEX(x-texto,x-Marcador-1).
    IF x-pos1 > 0 THEN DO:
        x-pos1 = x-pos1 + LENGTH(x-Marcador-1).
        x-pos2 = INDEX(x-texto,x-Marcador-2).
        pValor = TRIM(SUBSTRING(x-texto,x-pos1,x-pos2 - x-pos1)).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

