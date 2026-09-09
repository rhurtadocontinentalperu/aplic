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

FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = s-codcia AND 
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
    MESSAGE 'Generamos el XML y ENVIAR a SUNAT?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN "OK".      
END.      
DEF SHARED VAR s-nomcia AS CHAR.               

DEFINE VAR pDivision AS CHAR.
DEFINE VAR x-enviar-guia-remision AS LOG.

pDivision = B-CDOCU.divori.
x-enviar-guia-remision = NO.

IF LOOKUP(B-CDOCU.coddoc,"FAC,BOL") > 0 THEN DO:
    RUN sunat/p-consignar-guia-de-remision.r(INPUT pDivision, OUTPUT x-enviar-guia-remision).

    IF x-enviar-guia-remision = YES THEN DO:
        /* 
            La division de origen (venta) esta configurado para que el comprobante
            tenga referencia GRE. 
            Solo genera el comprobante y luego se envia a Sunat
        */
        RETURN "OK".
    END.
END.

/* *********************************************************** */
/* RHC 01/03/19 Rutina de control para N/C programado por C.I. */
/* *********************************************************** */
IF B-CDOCU.CodDoc = "N/C" THEN DO:
    RLOOP:
    DO:
        IF B-CDOCU.TpoFac = "LF" THEN LEAVE RLOOP.  /* NO Para LF (Lista Express) */
        RUN gn/p-documento-aceptado-en-sunat.r (INPUT B-CDOCU.CodRef,
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
/* RHC 18/11/2019 SOLO se está trabajando con BizLinks */
&IF {&ARITMETICA-SUNAT} &THEN
        DEF VAR pOtros AS CHAR NO-UNDO.
        RUN sunat/progress-to-bz-arimetica.r (pCodDiv,
                                             pCodDoc,
                                             pNroDoc,
                                             INPUT-OUTPUT TABLE T-FELogErrores,
                                             OUTPUT pCodError,
                                             INPUT-OUTPUT pOtros).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
        IF RETURN-VALUE = 'ERROR-EPOS' THEN RETURN 'ERROR-EPOS'.
        IF RETURN-VALUE = 'PLAN-B' THEN RETURN 'PLAN-B'.
&ELSE
        DEF VAR pOtros AS CHAR NO-UNDO.
        RUN sunat/progress-to-bz.r (pCodDiv,
                                  pCodDoc,
                                  pNroDoc,
                                  INPUT-OUTPUT TABLE T-FELogErrores,
                                  OUTPUT pCodError,
                                  INPUT-OUTPUT pOtros).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
        IF RETURN-VALUE = 'ERROR-EPOS' THEN RETURN 'ERROR-EPOS'.
        IF RETURN-VALUE = 'PLAN-B' THEN RETURN 'PLAN-B'.
&ENDIF

/* *********************************************************** */
/* Buscamos configuración de Proveedor de Fact. Electroc. */
/* FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = s-CodCia AND                                      */
/*     VtaDTabla.Tabla = 'SUNATPRV' AND                                                            */
/*     VtaDTabla.Tipo = pCodDiv AND                                                                */
/*     CAN-FIND(FIRST VtaCTabla OF VtaDTabla NO-LOCK)                                              */
/*     NO-LOCK NO-ERROR.                                                                           */
/* CASE TRUE:                                                                                      */
/*     WHEN (AVAILABLE VtaDTabla AND VtaDTabla.Llave = "BL") THEN DO:                              */
/*         /* Proveedor BIZLINKS */                                                                */
/*         DEF VAR pOtros AS CHAR NO-UNDO.                                                         */
/*         RUN sunat/progress-to-bz (pCodDiv,                                                      */
/*                                   pCodDoc,                                                      */
/*                                   pNroDoc,                                                      */
/*                                   INPUT-OUTPUT TABLE T-FELogErrores,                            */
/*                                   OUTPUT pCodError,                                             */
/*                                   INPUT-OUTPUT pOtros).                                         */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.                                  */
/*         IF RETURN-VALUE = 'ERROR-EPOS' THEN RETURN 'ERROR-EPOS'.                                */
/*     END.                                                                                        */
/*     OTHERWISE DO:                                                                               */
/*         MESSAGE 'División NO configurada para facturación electrónica' VIEW-AS ALERT-BOX ERROR. */
/*         RETURN 'ADM-ERROR'.                                                                     */
/*     END.                                                                                        */
/*     /*                                                                                          */
/*     WHEN (AVAILABLE VtaDTabla AND VtaDTabla.Llave = "PPLL") THEN DO:                            */
/*         /* Proveedor PAPERLESS */                                                               */
/*         RUN sunat/progress-to-paperless (pCodDiv,                                               */
/*                                          pCodDoc,                                               */
/*                                          pNroDoc,                                               */
/*                                          INPUT-OUTPUT TABLE T-FELogErrores,                     */
/*                                          OUTPUT pCodError).                                     */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.                                  */
/*         IF RETURN-VALUE = 'ERROR-EPOS' THEN RETURN 'ERROR-EPOS'.                                */
/*     END.                                                                                        */
/*     OTHERWISE DO:                                                                               */
/*         /* Cualquier otro caso PAPERLESS */                                                     */
/*         RUN sunat/progress-to-paperless (pCodDiv,                                               */
/*                                          pCodDoc,                                               */
/*                                          pNroDoc,                                               */
/*                                          INPUT-OUTPUT TABLE T-FELogErrores,                     */
/*                                          OUTPUT pCodError).                                     */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.                                  */
/*         IF RETURN-VALUE = 'ERROR-EPOS' THEN RETURN 'ERROR-EPOS'.                                */
/*     END.                                                                                        */
/*     */                                                                                          */
/* END CASE.                                                                                       */
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


