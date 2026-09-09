&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Rutinas para PUNTOS MUNDIAL 2018

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* SINTAXIS:

DEFINE VAR hProc AS HANDLE NO-UNDO.

/* Cargamos en memoria las librerias */
RUN vtagn/puntos-vamos-mundial.p PERSISTENT SET hProc NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pCodError = "ERROR en las librerias de la Promoción VAMOS AL MUNDIAL" + CHR(10) +
        "Salir del Sistema, volver a entrar y repetir el proceso".
    RETURN "ADM-ERROR".
END.

IF VALID-HANDLE(hSocket) THEN DELETE OBJECT hSocket.
CREATE SOCKET hSocket.

/* AQUI VAN LAS RUTINAS PROPIAS DEL PROGRAMA */

/* ***************************************** */

/* Borramos de la memoria las librerias antes cargadas */
DELETE PROCEDURE hProc.

************************************************************************** */

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
         HEIGHT             = 6.31
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-carga-puntos-por-cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-puntos-por-cliente Procedure 
PROCEDURE carga-puntos-por-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Se va a procesar siempre el día anterior */
DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pFchDoc AS DATE.

DISABLE TRIGGERS FOR LOAD OF VtaCTabla.
DISABLE TRIGGERS FOR LOAD OF VtaDTabla.

DEF VAR pPuntos AS INT NO-UNDO.

/* Borramos cualquier dato registrado anteriormente */
FOR EACH VtaDTabla EXCLUSIVE-LOCK WHERE VtaDTabla.CodCia = pCodCia
    AND VtaDTabla.Tabla  = "VAMOS_AL_MUNDIAL"
    AND VtaDTabla.Libre_f01 = pFchDoc:
    DELETE VtaDTabla.
END.
/* Actualizamos la información */
FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.codcia = pCodCia:
    FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = GN-DIVI.CodCia
        AND CcbCDocu.CodDiv = GN-DIVI.CodDiv
        AND LOOKUP(CcbCDocu.CodDoc, 'FAC,BOL') > 0
        AND CcbCDocu.FlgEst <> "A"
        AND CcbCDocu.FchDoc = pFchDoc:
        RUN puntos-por-doc (INPUT ROWID(CcbCDocu), OUTPUT pPuntos).
        IF pPuntos > 0 THEN DO:
            FIND VtaCTabla WHERE VtaCTabla.CodCia = pCodCia
                AND VtaCTabla.Tabla  = "VAMOS_AL_MUNDIAL"
                AND VtaCTabla.Llave  = CcbCDocu.CodCli
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE VtaCTabla THEN DO:
                CREATE VtaCTabla.
                ASSIGN
                    VtaCTabla.CodCia = pCodCia
                    VtaCTabla.Tabla  = "VAMOS_AL_MUNDIAL"
                    VtaCTabla.Llave  = CcbCDocu.CodCli.
            END.
            CREATE VtaDTabla.
            ASSIGN
                VtaDTabla.CodCia = VtaCTabla.CodCia
                VtaDTabla.Tabla  = VtaCTabla.Tabla 
                VtaDTabla.Llave  = VtaCTabla.Llave
                VtaDTabla.Tipo   = CcbCDocu.CodDoc
                VtaDTabla.LlaveDetalle = CcbCDocu.NroDoc
                VtaDTabla.Libre_c01 = CcbCDocu.DivOri
                VtaDTabla.Libre_f01 = CcbCDocu.FchDoc
                VtaDTabla.Libre_d01 = pPuntos               /* Puntos Acumulados */
                VtaDTabla.FchCreacion = TODAY.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-puntos-por-doc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE puntos-por-doc Procedure 
PROCEDURE puntos-por-doc :
/*------------------------------------------------------------------------------
  Purpose:     Calculamos los puntos por cada comprobante
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.            
DEF OUTPUT PARAMETER pPuntos AS INT.

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-DDOCU FOR Ccbddocu.
DEF BUFFER B-TABLA FOR VtaTabla.

pPuntos = 0.
FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR THEN RETURN.

/* NO cliente varios */
FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = B-CDOCU.codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn AND FacCfgGn.CliVar > '' THEN DO:
    IF B-CDOCU.CodCli = FacCfgGn.CliVar THEN RETURN.
END.
/* Por división origen */
FIND FIRST GN-DIVI WHERE GN-DIVI.CodCia = B-CDOCU.CodCia
    AND GN-DIVI.CodDiv = B-CDOCU.DivOri
    AND LOOKUP(GN-DIVI.CanalVenta, 'TDA,PRO,HOR') > 0
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE GN-DIVI THEN RETURN.

DEF VAR x-Puntos AS INT EXTENT 20 NO-UNDO.      /* Suponiendo que hay 20 como máximo */
DEF VAR x-Nivel AS INT NO-UNDO.
DEF VAR x-ImpLin AS DEC NO-UNDO.
DEF VAR x-ImpTot  AS de NO-UNDO.

FOR EACH B-DDOCU OF B-CDOCU NO-LOCK,
    FIRST B-TABLA NO-LOCK WHERE B-TABLA.codcia = B-CDOCU.codcia
        AND B-TABLA.Tabla = "VAMOS_AL_MUNDIAL"
        AND B-TABLA.Llave_c1 = B-DDOCU.codmat:
    x-ImpLin = B-DDOCU.ImpLin - B-DDOCU.ImpDto2.
    IF B-CDOCU.CodMon = 2 THEN DO:
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= B-CDOCU.FchDoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb THEN x-ImpLin = x-ImpLin * gn-tcmb.compra.
    END.
    pPuntos = pPuntos + ROUND(x-ImpLin / B-TABLA.Valor[1] * B-TABLA.Valor[2], 0).
END.

/*
DEF VAR x-Puntos AS INT EXTENT 20 NO-UNDO.      /* Suponiendo que hay 20 como máximo */
DEF VAR x-Nivel AS INT NO-UNDO.
DEF VAR x-ImpLin AS DEC NO-UNDO.
DEF VAR x-ImpTot  AS de NO-UNDO.

x-Nivel = 0.
FOR EACH B-DDOCU OF B-CDOCU NO-LOCK,
    FIRST B-TABLA NO-LOCK WHERE B-TABLA.codcia = B-CDOCU.codcia
        AND B-TABLA.Tabla = "VAMOS_AL_MUNDIAL"
        AND B-TABLA.Llave_c1 = B-DDOCU.codmat
    BREAK BY B-TABLA.Valor[1]:
    IF FIRST-OF(B-TABLA.Valor[1]) THEN DO:
        x-Nivel = x-Nivel + 1.
        IF x-Nivel > 20 THEN LEAVE.
        x-ImpTot = 0.
    END.
    x-ImpLin = B-DDOCU.ImpLin - B-DDOCU.ImpDto2.
    IF B-CDOCU.CodMon = 2 THEN DO:
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= B-CDOCU.FchDoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-tcmb THEN x-ImpLin = x-ImpLin * gn-tcmb.compra.
    END.
    x-ImpTot = x-ImpTot + x-ImpLin.
    IF LAST-OF(B-TABLA.Valor[1]) THEN DO:
        x-Puntos[x-Nivel] = TRUNCATE(x-ImpTot / B-TABLA.Valor[1], 0) * B-TABLA.Valor[2].
    END.
END.
DO x-Nivel = 1 TO 20:
    pPuntos = pPuntos + x-Puntos[x-Nivel].
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

