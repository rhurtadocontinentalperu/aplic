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

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.    /* Almacenes separados por comas */
DEF OUTPUT PARAMETER pComprometido AS DEC.

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


/* CALCULO DEL STOCK COMPROMETIDO */
DEF SHARED VAR s-codcia AS INT.

FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccfggn THEN RETURN.

/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

/* Tiempo por defecto fuera de campaña */
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).

FOR EACH Vtaddocu NO-LOCK WHERE codcia = s-codcia
    AND codmat = pCodMat
    AND LOOKUP (Vtaddocu.flgest, "X,P") > 0,
    FIRST Vtacdocu OF Vtaddocu NO-LOCK WHERE LOOKUP (Vtacdocu.flgest, "X,P") > 0:
    IF LOOKUP(Vtaddocu.almdes , pCodAlm) = 0 THEN NEXT.
    CASE Vtaddocu.codped:
        WHEN 'P/M' THEN DO:
            TimeNow = (TODAY - Vtacdocu.FchPed) * 24 * 3600.
            TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(Vtacdocu.Hora, 1, 2)) * 3600) +
                      (INTEGER(SUBSTRING(Vtacdocu.Hora, 4, 2)) * 60) ).
            IF TimeOut > 0 THEN DO:
                IF TimeNow <= TimeOut   /* Dentro de la valides */
                THEN DO:
                    /* cantidad en reserva */
                    pComprometido = pComprometido + Vtaddocu.Factor * Vtaddocu.CanPed.
                END.
            END.
        END.
        WHEN 'PED' THEN DO:
            pComprometido = pComprometido + Vtaddocu.Factor * (Vtaddocu.CanPed - Vtaddocu.canate).
        END.
        WHEN 'O/D' THEN DO:
            pComprometido = pComprometido + Vtaddocu.Factor * (Vtaddocu.CanPed - Vtaddocu.canate).
        END.
    END CASE.
END.

/* Stock Comprometido por Pedidos por Reposicion Automatica */
FOR EACH Almcrepo NO-LOCK WHERE Almcrepo.codcia = s-codcia
    AND Almcrepo.TipMov = 'A'
    AND LOOKUP (Almcrepo.AlmPed, pCodAlm ) > 0
    AND Almcrepo.FlgEst = 'P',
    /*AND Almcrepo.FlgSit = 'A',*/
    EACH Almdrepo OF Almcrepo NO-LOCK WHERE Almdrepo.codmat = pCodMat
    AND almdrepo.CanApro > almdrepo.CanAten:
    pComprometido = pComprometido + (Almdrepo.CanApro - Almdrepo.CanAten).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


