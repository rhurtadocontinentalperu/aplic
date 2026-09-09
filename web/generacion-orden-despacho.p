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
DEFINE OUTPUT PARAMETER pNewCodOD AS CHAR NO-UNDO.     /* O/D */
DEFINE OUTPUT PARAMETER pNewNroOD AS CHAR NO-UNDO.
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

DEFINE VAR grabarmsgLog AS LOG.
grabarmsgLog = YES.

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

pNewCodOD = "".
pNewNroOD = "".  

FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia AND faccpedi.coddoc = pCodDoc AND
                        faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
                                          
IF NOT AVAILABLE Faccpedi THEN DO:
    pRetVal = "generacion-orden-despacho" + CHR(10) +
        "Documento " + pCodDoc + " " + pNroDoc + " no existe".
    RETURN "ADM-ERROR".
END.

IF Faccpedi.flgest <> "G" THEN DO:
    pRetVal = "Documento " + pCodDoc + " " + pNroDoc + " ya NO esta para aprobar (flgest = 'G') " + CHR(10) +
        "actualmente tiene estado (" + Faccpedi.flgest + ")".
    RETURN "ADM-ERROR".
END.

IF grabarmsgLog = YES THEN RUN lib/p-write-log-txt.r("Generacion de O/D", pCodDoc + " " + pNroDoc).

/* 
    Ic - 23Jun2020, para casos de pedido de 002 - CONTADO ANTICIPADO
    que aun no haya actualizado la BD
*/

DEFINE VAR x-fmapago AS CHAR.
DEFINE VAR x-boleta-deposito AS CHAR.

x-fmapago = faccpedi.fmapgo.
x-boleta-deposito = faccpedi.libre_c03.

IF x-fmapago = '002' THEN DO:
    IF TRUE <> (x-boleta-deposito > "") THEN DO:
        pRetVal = "Imposible realizar despacho" + CHR(10) +
                "para CONTADO ANTICIPADO, debe asignar" + CHR(10) +
                "la BD APROBADO ".
        RETURN "ADM-ERROR".
    END.
END.

/* Ic - 23Jun2020 - FIN */
DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR pFchEnt AS DATE NO-UNDO.

x-Rowid = ROWID(Faccpedi).
S-CODDIV = Faccpedi.coddiv.

IF grabarmsgLog = YES THEN RUN lib/p-write-log-txt.r("Generacion de O/D", pCodDoc + " " + pNroDoc + " Inicia Transaccion").

DISABLE TRIGGERS FOR LOAD OF di-rutaC. 
DISABLE TRIGGERS FOR LOAD OF di-rutaD. 
/* Triggers */
DISABLE TRIGGERS FOR LOAD OF faccorre.
DISABLE TRIGGERS FOR LOAD OF vtactrkped.
DISABLE TRIGGERS FOR LOAD OF vtadtrkped.
DISABLE TRIGGERS FOR LOAD OF vtaddocu.
DISABLE TRIGGERS FOR LOAD OF vtacdocu.

GRABAR_OD:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Fecha de Entrega */
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE" ~
        }
    /* ****************************************************************************** */
    /* Reactualizamos la Fecha de Entrega                                             */
    /* ****************************************************************************** */
    pFchEnt = FacCPedi.FchEnt.      /* OJO */
    IF FacCPedi.Ubigeo[2] <> "@PV" THEN DO:
        pFchEnt = FacCPedi.Libre_f02.   /* Pactada con el cliente */
        RUN Fecha-Entrega (INPUT-OUTPUT pFchEnt, OUTPUT pMensaje).
        IF pMensaje > '' THEN DO:
            
            pRetVal = pMensaje.
            UNDO GRABAR_OD, RETURN 'ADM-ERROR'. 
        END.            
    END.
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.

    /* Generación de O/D */
    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN vtagn/ventas-library PERSISTENT SET hProc.

    IF grabarmsgLog = YES THEN RUN lib/p-write-log-txt.r("Generacion de O/D", pCodDoc + " " + pNroDoc + " PED_Despachar_Pedido_Riqra").

    pMensaje = "".
    RUN PED_Despachar_Pedido_Riqra IN hProc (INPUT Faccpedi.coddoc,
                                             INPUT faccpedi.nroped,
                                             OUTPUT pNewCodOD,
                                             OUTPUT pNewNroOD,
                                            OUTPUT pMensaje) NO-ERROR.

    IF grabarmsgLog = YES THEN RUN lib/p-write-log-txt.r("Generacion de O/D", pCodDoc + " " + pNroDoc + " PED_Despachar_Pedido_Riqra - FIN (" + pMensaje + ")").

    existeError = NO.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "PED_Despachar_Pedido_Riqra" + CHR(10) + pMensaje + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).       
        existeError = YES.
    END.

    DELETE PROCEDURE hProc.
    pRetVal = pMensaje.
    IF RETURN-VALUE = 'ADM-ERROR' OR existeError = YES THEN DO:        
        UNDO GRABAR_OD, RETURN "ADM-ERROR".
    END.
        
END.

IF grabarmsgLog = YES THEN RUN lib/p-write-log-txt.r("Generacion de O/D", pCodDoc + " " + pNroDoc + " Termino OK, -  O/D " + pNewCodOD + " " + pNewNroOD).

RELEASE Faccpedi NO-ERROR.

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

