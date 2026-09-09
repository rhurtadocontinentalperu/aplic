&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DTPED FOR vtadtrkped.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : pTracking-04
    Purpose     : Nuevo control de tracking

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       : Este nuevo tracking NO bloquea el proceso, solo registra el movimiento
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCia AS INT.     /* Código de empresa */
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Division de seguimiento de tracking */
DEF INPUT PARAMETER pCodDoc AS CHAR.    /* P/M o PED */
DEF INPUT PARAMETER pNroPed AS CHAR.    /* Número de pedido */
DEF INPUT PARAMETER pUsuario AS CHAR.   /* Usuario responsable */
DEF INPUT PARAMETER pCodUbi AS CHAR.    /* Detalle del Ciclo */
DEF INPUT PARAMETER pFlgSit AS CHAR.    /* Situacion (P) en proceso, (A) anulacion */
DEF INPUT PARAMETER pFechaI AS DATETIME.    /* Inicio del ciclo */
DEF INPUT PARAMETER pFechaT AS DATETIME.    /* Termino del ciclo */
DEF INPUT PARAMETER pCodRef1 AS CHAR.    /* Documento Actual */
DEF INPUT PARAMETER pNroRef1 AS CHAR.    /* Documento Actual */
DEF INPUT PARAMETER pCodRef2 AS CHAR.    /* Documento Anterior */
DEF INPUT PARAMETER pNroRef2 AS CHAR.    /* Documento Anterior */

/*
CASE pCodDoc:
    WHEN 'P/M' THEN DO:
        FIND Faccpedi WHERE Faccpedi.codcia = pcodcia
            AND Faccpedi.coddoc = pcoddoc
            AND Faccpedi.nroped = pnroped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN RETURN 'OK'.
    END.
    WHEN 'PED' THEN DO:
        FIND Faccpedi WHERE Faccpedi.codcia = pcodcia
            AND Faccpedi.coddoc = pcoddoc
            AND Faccpedi.nroped = pnroped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN RETURN 'OK'.
    END.
    OTHERWISE RETURN 'ADM-ERROR'.
END CASE.

/* Verificamos si está configurada el tracking */
FIND TabGener WHERE TabGener.codcia = pCodCia
    AND TabGener.Clave = 'TRKPED'
    AND TabGener.Codigo = pCodUbi
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    RETURN 'ADM-ERROR'.
END.
*/

/* - */

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
      TABLE: B-DTPED B "?" ? INTEGRAL vtadtrkped
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* CABECERA */
    FIND VtaCTrkPed WHERE Vtactrkped.codcia = pcodcia
        AND Vtactrkped.coddiv = pcoddiv
        AND Vtactrkped.coddoc = pcoddoc
        AND Vtactrkped.nroped = pnroped
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtactrkped THEN DO:
        CREATE VtaCTrkPed.
        ASSIGN
            vtactrkped.CodCia = pCodCia
            vtactrkped.CodDiv = pCodDiv
            vtactrkped.CodDoc = pCodDoc
            vtactrkped.NroPed = pNroPed
            vtactrkped.FechaI = pFechaI.
    END.
    ASSIGN
        vtactrkped.CodUbic = pcodubi
        vtactrkped.FechaT = pfechat.
    /* DETALLE */
    CREATE Vtadtrkped.
    ASSIGN
        vtadtrkped.CodCia = pcodcia
        vtadtrkped.CodDiv = pcoddiv
        vtadtrkped.CodDoc = pcoddoc
        vtadtrkped.NroPed = pnroped
        vtadtrkped.CodUbic = pcodubi
        vtadtrkped.FechaI = pfechai
        vtadtrkped.CodRef = pCodRef1
        vtadtrkped.NroRef = pNroRef1.
    ASSIGN
        vtadtrkped.FechaT = pfechat
        vtadtrkped.FlgSit = pFlgSit
        vtadtrkped.Usuario = pusuario.
    ASSIGN
        vtadtrkped.Libre_C01 = ENTRY(1, pCodRef2, '|')                                          /* H/R */.
    IF NUM-ENTRIES(pCodRef2, '|') = 2 THEN vtadtrkped.Libre_C02 = ENTRY(2, pCodRef2, '|').      /* # H/R */
    ASSIGN
        vtadtrkped.Libre_C03 = ENTRY(1, pNroRef2, '|').                                         /* FlgEst */
    IF NUM-ENTRIES(pNroRef2, '|') = 2 THEN vtadtrkped.Libre_C04 = ENTRY(2, pNroRef2, '|').      /* FlgEstDet */

    IF AVAILABLE Vtactrkped THEN RELEASE Vtactrkped.
    IF AVAILABLE Vtadtrkped THEN RELEASE Vtadtrkped.
END.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


