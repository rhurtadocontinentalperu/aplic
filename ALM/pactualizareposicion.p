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

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pTipo  AS CHAR.     /* D: descarga(-)  C: carga(+) */
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
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.
IF Faccpedi.CodRef <> "R/A" THEN DO:
    pError = "La referencia del Pedido NO es una R/A".
    RETURN 'ADM-ERROR'.
END.
/* ************** */
/* RHC 01/02/2018 Parche Cross Docking */
DEF VAR cCodAlm AS CHAR NO-UNDO.
cCodAlm = Faccpedi.CodCli.      /* Valor por defecto */
IF Faccpedi.CrossDocking = YES THEN cCodAlm = Faccpedi.AlmacenXD.
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Actualizamos R/A */
    {lib/lock-genericov3.i
        &Tabla="Almcrepo"
        &Alcance="FIRST"
        &Condicion="Almcrepo.codcia = Faccpedi.codcia ~
        AND Almcrepo.codalm = cCodAlm ~
        /*AND LOOKUP(Almcrepo.tipmov, 'A,M') > 0 ~*/
        AND Almcrepo.nroser = INTEGER(SUBSTRING(Faccpedi.NroRef,1,3)) ~
        AND Almcrepo.nrodoc = INTEGER(SUBSTRING(Faccpedi.NroRef,4))"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pError"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almdrepo OF Almcrepo EXCLUSIVE-LOCK WHERE Almdrepo.codmat = Facdpedi.codmat:
        CASE pTipo:
            WHEN "D" THEN Almdrepo.CanAten = Almdrepo.CanAten - Facdpedi.CanPed.
            WHEN "C" THEN DO:
                Almdrepo.CanAten = Almdrepo.CanAten + Facdpedi.CanPed.
                /* CONTROL DE ATENCIONES */
                IF Almdrepo.CanAten > Almdrepo.CanApro THEN DO:
                    pError = 'Se ha detectado un error el el producto ' + Almdrepo.codmat + CHR(10) +
                            'Los despachos superan a lo solicitado' + CHR(10) +
                    'Cant. solicitada: ' + STRING(Almdrepo.CanApro, '->>>,>>9.99') + CHR(10) +
                    'Total atendida  : ' + STRING(Almdrepo.CanAten, '->>>,>>9.99') + CHR(10) +
                    'FIN DEL PROCESO'.
                    UNDO PRINCIPAL, RETURN "ADM-ERROR".
                END.
            END.
        END CASE.
    END.
END.
IF AVAILABLE Almcrepo THEN RELEASE Almcrepo.
IF AVAILABLE Almdrepo THEN RELEASE Almdrepo.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


