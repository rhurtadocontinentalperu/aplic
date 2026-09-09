&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* ***************************  Definitions  ************************** */
/* CAMBIO EN LA RUTINA:
    DE ACUERDO A LA DIVISIÓN SE DISPARA POR BIZLINKS O PAPERLESS 
*/


DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR T-FELogErrores.
DEFINE OUTPUT PARAMETER pCodError AS CHAR NO-UNDO.

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcia AS INT.

DEF BUFFER B-CDOCU FOR Ccbcdocu.

FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia AND 
    B-CDOCU.coddiv = pCodDiv AND 
    B-CDOCU.coddoc = pCodDoc AND
    B-CDOCU.nrodoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CDOCU THEN DO:
    MESSAGE "Documento (" + pCodDoc + "-" + pNroDoc + ") NO EXISTE".
    RETURN "ADM-ERROR".
END.
IF LOOKUP(B-CDOCU.CodDoc, 'FAC,BOL,N/C,N/D') = 0 THEN RETURN "OK".
IF B-CDOCU.flgest = 'A' THEN DO:
    MESSAGE "Documento (" + pCodDoc + "-" + pNroDoc + ") esta ANULADO".
    RETURN "ADM-ERROR".
END.
/* ??????????????????????????? */
/* BLOQUEADO PARA SISTEMAS */
IF s-user-id = 'ADMIN' THEN DO:
    MESSAGE 'Generamos el XML para SUNAT?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN "OK".      
END.      
DEF SHARED VAR s-nomcia AS CHAR.               

/* *********************************************************** */
/* RHC 01/03/19 Rutina de control para N/C programado por C.I. */
/* *********************************************************** */
IF B-CDOCU.CodDoc = "N/C" THEN DO:
    RLOOP:
    DO:
        IF B-CDOCU.TpoFac = "LF" THEN LEAVE RLOOP.  /* NO Para LF (Lista Express) */
        RUN gn/p-documento-aceptado-en-sunat (INPUT B-CDOCU.CodRef,
                                              INPUT B-CDOCU.NroRef,
                                              INPUT "",
                                              OUTPUT pCodError).
        IF pCodError <> "OK" THEN DO:
            /*RETURN "OK".*/
            MESSAGE pCodError SKIP 
                'Documento no esta aceptado por sunat' SKIP  
                'Vuelva a intentar en unos minutos'
                VIEW-AS ALERT-BOX INFORMATION.
            pCodError = ''.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
/* *********************************************************** */
MESSAGE 'inicio'.

DEF VAR pOtros AS CHAR NO-UNDO.
RUN sunat/progress-to-bz-arimetica-pruebas (pCodDiv,
                                     pCodDoc,
                                     pNroDoc,
                                     INPUT-OUTPUT TABLE T-FELogErrores,
                                     OUTPUT pCodError,
                                     INPUT-OUTPUT pOtros).
MESSAGE RETURN-VALUE pcoderror.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
IF RETURN-VALUE = 'ERROR-EPOS' THEN RETURN 'ERROR-EPOS'.
IF RETURN-VALUE = 'PLAN-B' THEN RETURN 'PLAN-B'.


RETURN 'OK'.

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
   Temp-Tables and Buffers:
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.58
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/** ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


