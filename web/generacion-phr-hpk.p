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

DEFINE INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.     /* PED */
DEFINE INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pNewCodPHR AS CHAR NO-UNDO.     /* O/D */
DEFINE OUTPUT PARAMETER pNewNroPHR AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.
DEFINE NEW SHARED VARIABLE pv-codcia AS INT INIT 1.

DEFINE NEW SHARED VARIABLE S-CODCIA   AS INTEGER INIT 1.
DEFINE NEW SHARED VARIABLE S-CODDIV   AS CHAR.
DEF NEW SHARED VAR cl-codcia AS INT.    
DEF NEW SHARED VAR s-user-id AS CHAR. 

/* PRODUCTOS POR ROTACION */
DEFINE NEW SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE NEW SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE NEW SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE NEW SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.
DEFINE NEW SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE NEW SHARED VAR s-TpoPed AS CHAR.

DEFINE VAR nameProceso AS CHAR INIT "GENERACION DE PHR-HPK".
DEFINE VAR generarLogTxt AS LOG INIT NO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pMensaje AS CHAR NO-UNDO.         
DEF VAR existeError AS LOG.

pNewCodPHR = "".
pNewNroPHR = "". 

FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia AND faccpedi.coddoc = pCodDoc AND
                        faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
                                          
IF NOT AVAILABLE Faccpedi THEN DO:
    pRetVal = "generacion-orden-despacho" + CHR(10) +
        "Documento " + pCodDoc + " " + pNroDoc + " no existe".
    RETURN "ADM-ERROR".
END.

IF NOT (Faccpedi.flgest = 'P' AND Faccpedi.flgsit = 'K') THEN DO:
    pRetVal = "Documento " + pCodDoc + " " + pNroDoc + " debe estar pendiente (fgest = 'P' y por generar PHR/HPK (flgsit = 'K') " + CHR(10) +
        "actualmente tiene estado (" + Faccpedi.flgest + ")".
    RETURN "ADM-ERROR".
END.

IF generarLogTxt THEN RUN lib/p-write-log-txt.r(nameProceso, pCodDoc + " " + pNroDoc).

/* Ic - 23Jun2020 - FIN */
DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR pFchEnt AS DATE NO-UNDO.
DEF VAR cReturn AS CHAR.

x-Rowid = ROWID(Faccpedi).
S-CODDIV = Faccpedi.coddiv.

DISABLE TRIGGERS FOR LOAD OF di-rutaC. 
/*DISABLE TRIGGERS FOR LOAD OF di-rutaD. */
 
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN vtagn/ventas-library PERSISTENT SET hProc.

RUN lib/p-write-log-txt.r(nameProceso, pCodDoc + " " + pNroDoc + " ejecuta VTA_Genera-PHR_y_HPK").

pMensaje = "".
/*RUN VTA_Genera-PHR_y_HPK IN hProc (INPUT rowid(Faccpedi), OUTPUT pMensaje) NO-ERROR.*/
RUN VTA_Genera-PHR_y_HPK_riqra IN hProc (INPUT pCodDoc, INPUT pNroDoc, OUTPUT pNewCodPHR, OUTPUT pNewNroPHR, OUTPUT pMensaje) NO-ERROR.

IF ERROR-STATUS:ERROR THEN DO:
    pMensaje = pMensaje + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
    cReturn = "ADM-ERROR".
END.

cReturn = RETURN-VALUE.

RUN lib/p-write-log-txt.r(nameProceso, pCodDoc + " " + pNroDoc + " termino VTA_Genera-PHR_y_HPK (" + pMensaje + ")").

IF cReturn = "ADM-ERROR" THEN RETURN cReturn.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Fecha-Entrega) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fecha-Entrega Procedure 
PROCEDURE Fecha-Entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER pFchEnt    AS DATE.
DEF OUTPUT PARAMETER pMensaje   AS CHAR.

/* LA RUTINA VA A DECIDIR SI EL CALCULO ES POR UBIGEO O POR GPS */
RUN logis/p-fecha-de-entrega (
    FacCPedi.CodDoc,              /* Documento actual */
    FacCPedi.NroPed,
    INPUT-OUTPUT pFchEnt,
    OUTPUT pMensaje).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

