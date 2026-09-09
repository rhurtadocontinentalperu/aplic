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

DEFINE BUFFER b-gre_header FOR gre_header.
DEFINE BUFFER b-gre_cmpte FOR gre_cmpte.
DEFINE BUFFER b-faccpedi FOR faccpedi.

DEFINE NEW GLOBAL SHARED VAR s-codcia AS INT INIT 1.
DEFINE NEW GLOBAL SHARED VAR s-user-id AS CHAR INIT "BATCH".

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

DEFINE VAR cValorDeRetorno AS CHAR NO-UNDO.
DEFINE VAR iMaximoDiasAntiguedadPGRE AS INT NO-UNDO.
DEFINE VAR dFechaEmisionPGRE AS DATE NO-UNDO.
DEFINE VAR iDiasAntiguedadPGRE AS INT NO-UNDO.

DEFINE VAR cRetval AS CHAR NO-UNDO.

RUN lib/p-write-log-txt.p("ANULAR_PGRE_EXCESO_TIEMPO","************************************************************").
RUN lib/p-write-log-txt.p("ANULAR_PGRE_EXCESO_TIEMPO","INICIO").

RUN gre/get-parametro-config-gre("PARAMETRO","TIEMPO_VIDA_PGRE","DIAS","N","2",OUTPUT cValorDeRetorno).

If cValorDeRetorno =  "ERROR" then DO:
   RUN lib/p-write-log-txt.p("ANULAR_PGRE_EXCESO_TIEMPO","ERROR AL RECUPERAR EL PARAMETRO TIEMPO DE VIDA PGRE").
END.
ELSE DO:
    
    iMaximoDiasAntiguedadPGRE = INTEGER(cValorDeRetorno).

    RUN lib/p-write-log-txt.p("ANULAR_PGRE_EXCESO_TIEMPO","PARAMETRO MAXIMO TIEMPO DE VIDA PGRE(" + STRING(iMaximoDiasAntiguedadPGRE) + ")").

    FOR EACH gre_header WHERE gre_header.m_rspta_sunat = 'SIN ENVIAR' NO-LOCK:
        dFechaEmisionPGRE = DATE(gre_header.m_fechahorareg).
        iDiasAntiguedadPGRE = INTERVAL(TODAY,dFechaEmisionPGRE,'days').        

        IF iDiasAntiguedadPGRE > iMaximoDiasAntiguedadPGRE THEN DO:
            RUN lib/p-write-log-txt.p("ANULAR_PGRE_EXCESO_TIEMPO","     PGRE Nro." + STRING(gre_header.ncorrelatio) + ", antiguedad(" + STRING(iDiasAntiguedadPGRE) + ")").

           cRetval = "".
           RUN anular-PGRE(gre_header.ncorrelatio, OUTPUT cRetval).

           RUN lib/p-write-log-txt.p("ANULAR_PGRE_EXCESO_TIEMPO","     " + cRetval).
           RUN lib/p-write-log-txt.p("ANULAR_PGRE_EXCESO_TIEMPO","     ------------------------------------------------------------------------------------------------------------------").
        END.
    END.
END.

RUN lib/p-write-log-txt.p("ANULAR_PGRE_EXCESO_TIEMPO","FINAL").

QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-anular-PGRE) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anular-PGRE Procedure 
PROCEDURE anular-PGRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER piNroPGRE AS INT NO-UNDO.
DEFINE OUTPUT PARAMETER pcRetval AS CHAR NO-UNDO.

DEFINE VAR cNroCmpte AS CHAR NO-UNDO.
DEFINE VAR cNroDoc AS CHAR NO-UNDO.

FIND FIRST b-gre_header WHERE b-gre_header.ncorrelatio = piNroPGRE EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    
IF ERROR-STATUS:ERROR THEN DO:
    pcRetval = ERROR-STATUS:GET-MESSAGE(1).
    RETURN 'ADM-ERROR'.
END.

pcRetval = "PROCESANDO ANULAR-PGRE".

GRABAR:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    
    IF b-gre_header.m_rspta_sunat = 'SIN ENVIAR' THEN DO:
        dFechaEmisionPGRE = DATE(b-gre_header.m_fechahorareg).
        iDiasAntiguedadPGRE = INTERVAL(TODAY,dFechaEmisionPGRE,'days').        

        IF iDiasAntiguedadPGRE > iMaximoDiasAntiguedadPGRE THEN DO:
            ASSIGN  b-gre_header.m_rspta_sunat = "ANULADO"
                    b-gre_header.m_motivo_de_rechazo = "ANULADO POR PROCESO NOCTURO-EXCESO TIEMPO DE VIDA(" + STRING(iDiasAntiguedadPGRE) + ")" NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:
                pcRetval = "1.- " + ERROR-STATUS:GET-MESSAGE(1).
                UNDO GRABAR, LEAVE.
            END.

            /* La PGRE proviene de un comprobante */
            IF LOOKUP(b-gre_header.m_coddoc,"FAC,BOL,FAI") > 0 THEN DO:

                cNroCmpte = STRING(b-gre_header.m_nroser,"999") + STRING(b-gre_header.m_nrodoc,"99999999").
                IF b-gre_header.m_coddoc = "FAI" THEN cNroCmpte = STRING(b-gre_header.m_nroser,"999") + STRING(b-gre_header.m_nrodoc,"999999").

                FIND FIRST b-gre_cmpte WHERE b-gre_cmpte.coddoc = b-gre_header.m_coddoc AND 
                                            b-gre_cmpte.nrodoc = cNroCmpte AND 
                                            b-gre_cmpte.estado = "PGRE GENERADA" EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF LOCKED(b-gre_cmpte) THEN DO:
                    /* Bloqueado */
                    pcRetval = "2.- " + ERROR-STATUS:GET-MESSAGE(1).
                    UNDO GRABAR, LEAVE.
                END.
                IF AVAILABLE b-gre_cmpte THEN DO:
                    ASSIGN b-gre_cmpte.estado = "CMPTE GENERADO" NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN DO:
                        pcRetval = "3.- " + ERROR-STATUS:GET-MESSAGE(1).
                        UNDO GRABAR, LEAVE.
                    END.
                END.
                RELEASE b-gre_cmpte NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    pcRetval = "4.- " + ERROR-STATUS:GET-MESSAGE(1).
                    UNDO GRABAR, LEAVE.
                END.
            END.
            /* Si es OTR */
            IF b-gre_header.m_coddoc = 'OTR' THEN DO:
                cNroDoc = STRING(b-gre_header.m_nroser,"999") + 
                        STRING(b-gre_header.m_nrodoc,"999999").
                FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = 1 AND b-faccpedi.coddoc = b-gre_header.m_CodDoc AND b-faccpedi.nroped = cNroDoc NO-LOCK NO-ERROR.
                IF AVAILABLE b-faccpedi THEN DO:
                    FIND CURRENT b-faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF LOCKED b-faccpedi THEN DO:
                        RELEASE b-faccpedi NO-ERROR.
                        pcRetval = "5.- La tabla FACCPEDI esta bloqueada...imposible actualizar flag situacion de la OTR".
                        UNDO GRABAR, LEAVE.
                    END.
                    ELSE DO:
                        IF AVAILABLE b-faccpedi THEN DO:
                            ASSIGN b-faccpedi.flgsit = 'C'.
                        END.
                    END.
                END.
            END.
        END.
        /* -- */
        RELEASE b-faccpedi NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pcRetval = "8.- " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, LEAVE.
        END.
        RELEASE b-gre_header NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pcRetval = "9.- " + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABAR, LEAVE.
        END.
    END.

    pcRetval = "OK".
END.

IF pcRetval = "OK" THEN DO:
    RETURN "OK".
END.
ELSE DO:
    /*pcRetval = "6.- " + ERROR-STATUS:GET-MESSAGE(1).*/
    RETURN 'ADM-ERROR'.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

