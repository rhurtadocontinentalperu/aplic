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

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pComprometido AS DEC.

/* CALCULO DEL STOCK COMPROMETIDO */
FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccfggn THEN RETURN.

/* Stock comprometido por PEDIDOS ACTIVOS MOSTRADOR */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

/* Tiempo por defecto fuera de campaña */
TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
          (FacCfgGn.Hora-Res * 3600) + 
          (FacCfgGn.Minu-Res * 60).

pComprometido = 0.
DEF VAR i AS INT NO-UNDO.
DEF VAR x-CodAlm AS CHAR NO-UNDO.

DO i = 1 TO NUM-ENTRIES(pCodAlm):
    x-CodAlm = ENTRY(i, pCodAlm).
    /**********   Barremos para los PEDIDOS MOSTRADOR ***********************/ 
    FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.CodCia = s-codcia
        AND Facdpedi.AlmDes = x-CodAlm
        AND Facdpedi.codmat = pcodmat
        AND Facdpedi.coddoc = 'P/M'
        AND Facdpedi.FlgEst = "P":
        FIND FIRST Faccpedi OF Facdpedi WHERE Faccpedi.FlgEst = "P" NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN NEXT.

        TimeNow = (TODAY - FacCPedi.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedi.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(FacCPedi.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                /* cantidad en reservacion */
                pComprometido = pComprometido + FacDPedi.Factor * FacDPedi.CanPed.
            END.
        END.
    END.
    FIND Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = x-CodAlm
        AND Almmmate.codmat = pCodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN pComprometido = pComprometido + Almmmate.StkComprometido.
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
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


