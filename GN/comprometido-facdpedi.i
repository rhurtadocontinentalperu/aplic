&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

DEF VAR pComprometido AS DEC NO-UNDO.

DEF BUFFER B-DPEDI FOR Facdpedi.
DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-MATE  FOR Almmmate.
DEF BUFFER B-CREPO FOR Almcrepo.
DEF BUFFER B-DREPO FOR Almdrepo.

LOOPGENERAL:
DO:
    FIND FacCfgGn WHERE faccfggn.codcia = {&pCodCia} NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccfggn THEN LEAVE.
    pComprometido = 0.
    /**********   Barremos para los PEDIDOS AL CREDITO   ***********************/ 
    FOR EACH B-DPEDI USE-INDEX Llave04 NO-LOCK WHERE B-DPEDI.codcia = {&pCodCia}
        AND B-DPEDI.almdes = {&pCodAlm}
        AND B-DPEDI.codmat = {&pCodMat}
        AND B-DPEDI.coddoc = 'PED'
        AND B-DPEDI.flgest = 'P',
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE LOOKUP(B-CPEDI.FlgEst, "G,X,P,W,WX,WL") > 0:
        pComprometido = pComprometido + B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate).
    END.
    /* ORDENES DE DESPACHO CREDITO */
    FOR EACH B-DPEDI USE-INDEX Llave04 NO-LOCK WHERE B-DPEDI.codcia = {&pCodCia}
        AND B-DPEDI.almdes = {&pCodAlm}
        AND B-DPEDI.codmat = {&pCodMat}
        AND B-DPEDI.coddoc = 'O/D'
        AND LOOKUP(B-DPEDI.flgest, 'WL,P') > 0, /* Aprobadas y por Aprobar */
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.flgest = 'P':
        pComprometido = pComprometido + B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.canate).
    END.
    /* Stock Comprometido por Pedidos por Reposicion Automatica */
    /* OJO ver tambien el programa vtamay/c-conped.w */
    FOR EACH B-DREPO USE-INDEX Llave03 NO-LOCK WHERE B-DREPO.codcia = {&pCodCia}
        AND B-DREPO.codmat = {&pCodMat}
        AND B-DREPO.CanApro > B-DREPO.CanAten,
        FIRST B-CREPO OF B-DREPO NO-LOCK WHERE B-CREPO.AlmPed = {&pCodAlm}
        AND B-CREPO.FlgEst = 'P':
        /*AND LOOKUP(B-CREPO.FlgSit, 'P') > 0:    /* x Aprobar */*/
        pComprometido = pComprometido + (B-DREPO.CanApro - B-DREPO.CanAten).
    END.
    /* POR ORDENES DE TRANSFERENCIA */
    FOR EACH B-DPEDI USE-INDEX Llave04 NO-LOCK WHERE B-DPEDI.codcia = {&pCodCia}
        AND B-DPEDI.almdes = {&pCodAlm}
        AND B-DPEDI.codmat = {&pCodMat}
        AND B-DPEDI.coddoc = 'OTR'
        AND B-DPEDI.flgest = 'P',
        FIRST B-CPEDI OF B-DPEDI NO-LOCK WHERE B-CPEDI.flgest = 'P':
        pComprometido = pComprometido + B-DPEDI.Factor * (B-DPEDI.CanPed - B-DPEDI.CanAte).
    END.
    /* Actualizamos Stock Comprometido */
    IF CAN-FIND(B-MATE WHERE B-MATE.codcia = {&pCodCia} AND B-MATE.codalm = {&pCodAlm} AND B-MATE.codmat = {&pCodMat}
                NO-LOCK) 
        THEN DO:
        {lib\lock-genericov21.i ~
            &Tabla="B-MATE" ~
            &Condicion="B-MATE.codcia = {&pCodCia} AND B-MATE.codalm = {&pCodAlm} AND B-MATE.codmat = {&pCodMat}" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TipoError="RETURN ERROR" ~
            }
        ASSIGN
            B-MATE.StkComprometido = pComprometido.
        RELEASE B-MATE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


