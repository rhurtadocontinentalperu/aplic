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
DEFINE SHARED VAR s-codcia AS INT.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-orden-anulada) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE orden-anulada Procedure 
PROCEDURE orden-anulada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDiv AS CHAR.                       
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

/*
    pCodDoc : (O/D, OTR, O/M)
    pCodDiv : puede ser vacio
    pRetVal : Retorna ---- OK : si la orden esta anulada
                           Orden no existe
                           El estado de la orden (flgest)
*/

IF TRUE <> (pCodDiv > "") THEN DO:
    /* Sin division */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.coddoc = pCodDoc AND
                                faccpedi.nroped = pNroDOc NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.coddoc = pCodDiv AND
                                faccpedi.coddoc = pCodDoc AND
                                faccpedi.nroped = pNroDOc NO-LOCK NO-ERROR.

END.

IF AVAILABLE faccpedi THEN DO:
    IF faccpedi.flgest = "A" THEN DO:
        pRetVal = 'OK'.
    END.
    ELSE DO:
        pRetVal = faccpedi.flgest.
    END.
END.
ELSE pRetval = "Orden no existe!!!".

END PROCEDURE.
/*
        FOR EACH almcmov USE-INDEX almc07 WHERE almcmov.codcia = s-codcia
            AND almcmov.codref = pCodDoc
            AND almcmov.nroref = pNroDoc
            AND almcmov.tipmov = s-tipmov 
            AND almcmov.codmov = s-codmov
            AND Almcmov.flgest <> "A" NO-LOCK:
 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-orden-sin-hruta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE orden-sin-hruta Procedure 
PROCEDURE orden-sin-hruta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

/*
*/

/* Busco el pedido */
DEFINE VAR x-codpedido AS CHAR.
DEFINE VAR x-nropedido AS CHAR.
DEF VAR s-tipmov AS CHAR INIT 'S' NO-UNDO.
DEF VAR s-codmov AS INT  INIT 03  NO-UNDO.      /* Salida por transferencia */


FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
    faccpedi.coddoc = pCodDoc AND
    faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.

IF AVAILABLE faccpedi THEN DO:
    pRetVal = "La orden debe ser PED,P/M,OTR !!!".
    CASE TRUE:
        WHEN faccpedi.codref = 'PED' OR faccpedi.codref = 'P/M' THEN DO:
            x-codpedido = faccpedi.codref.
            x-nropedido = faccpedi.nroref.

            pRetVal = "OK".

            CON_HOJA_RUTA:
            /* las guias (G/R) de la O/D que esten facturadas */
            FOR EACH ccbcdocu USE-INDEX llave15 WHERE ccbcdocu.codcia = s-codcia  AND 
                            (ccbcdocu.codped = x-codpedido AND ccbcdocu.nroped = x-nropedido)  NO-LOCK :

                IF ccbcdocu.coddoc = 'G/R' AND (ccbcdocu.libre_c01 = pCodDoc AND ccbcdocu.libre_c02 = pNroDoc )
                    AND Ccbcdocu.flgest = "F" THEN DO:
                    /* consistencia en otros documentos */
                    FOR EACH di-rutad USE-INDEX llave02 NO-LOCK WHERE di-rutad.codcia = s-codcia
                        AND di-rutad.coddoc = 'H/R'
                        AND di-rutad.codref = ccbcdocu.coddoc
                        AND di-rutad.nroref = ccbcdocu.nrodoc ,
                        FIRST di-rutac OF di-rutad NO-LOCK:

                        IF di-rutac.flgest = "E" OR di-rutac.flgest = "P" OR di-rutac.flgest = "X" THEN DO:    
                            pRetVal = "Documento ya se encuentra registrado en la H.R.:" + di-rutac.nrodoc.
                            LEAVE CON_HOJA_RUTA.
                        END.
                        IF di-rutac.flgest = "C"  AND di-rutad.flgest = "C" THEN DO:
                            pRetVal = "Documento ya se encuentra registrado en la H.R.:" + di-rutac.nrodoc.
                            LEAVE CON_HOJA_RUTA.
                        END.
                    END.                
                END.
            END.
        END.
        WHEN faccpedi.codref = 'R/A' OR (faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'OPEN') THEN DO:
            pRetVal = "OK".

            CON_HOJA_RUTA2:
            /* Busco las G/R de la OTR y que no esten anulada */
            FOR EACH almcmov USE-INDEX almc07 WHERE almcmov.codcia = s-codcia
                AND almcmov.codref = pCodDoc
                AND almcmov.nroref = pNroDoc
                AND almcmov.tipmov = s-tipmov 
                AND almcmov.codmov = s-codmov
                AND Almcmov.flgest <> "A" NO-LOCK:

                /* Si no esta en otra H/R */
                FOR EACH di-rutag USE-INDEX llave02 NO-LOCK WHERE di-rutag.codcia = s-codcia
                    AND di-rutag.coddoc = "H/R"
                    AND di-rutag.serref = almcmov.nroser
                    AND di-rutag.nroref = almcmov.nrodoc,
                    FIRST di-rutac OF di-rutag NO-LOCK:
                    IF di-rutac.flgest = "E" OR di-rutac.flgest = "P" THEN DO:
                        pRetVal = "Documento ya se encuentra registrado en la H.R.:" + di-rutac.nrodoc.
                        LEAVE CON_HOJA_RUTA2.
                    END.
                    IF di-rutac.flgest = "C"  AND di-rutag.flgest = "C" THEN DO:
                        pRetVal = "Documento ya se encuentra registrado en la H.R.:" + di-rutac.nrodoc.
                        LEAVE CON_HOJA_RUTA2.
                    END.
                END.
            END.
        END.
    END CASE.


/*     IF faccpedi.codref = 'PED' OR faccpedi.codref = 'P/M' THEN DO:                                                      */
/*         x-codpedido = faccpedi.codref.                                                                                  */
/*         x-nropedido = faccpedi.nroref.                                                                                  */
/*                                                                                                                         */
/*         pRetVal = "OK".                                                                                                 */
/*                                                                                                                         */
/*         CON_HOJA_RUTA:                                                                                                  */
/*         /* las guias (G/R) de la O/D que esten facturadas */                                                            */
/*         FOR EACH ccbcdocu USE-INDEX llave15 WHERE ccbcdocu.codcia = s-codcia  AND                                       */
/*                         (ccbcdocu.codped = x-codpedido AND ccbcdocu.nroped = x-nropedido)  NO-LOCK :                    */
/*                                                                                                                         */
/*             IF ccbcdocu.coddoc = 'G/R' AND (ccbcdocu.libre_c01 = pCodDoc AND ccbcdocu.libre_c02 = pNroDoc )             */
/*                 AND Ccbcdocu.flgest = "F" THEN DO:                                                                      */
/*                 /* consistencia en otros documentos */                                                                  */
/*                 FOR EACH di-rutad USE-INDEX llave02 NO-LOCK WHERE di-rutad.codcia = s-codcia                            */
/*                     AND di-rutad.coddoc = 'H/R'                                                                         */
/*                     AND di-rutad.codref = ccbcdocu.coddoc                                                               */
/*                     AND di-rutad.nroref = ccbcdocu.nrodoc ,                                                             */
/*                     FIRST di-rutac OF di-rutad NO-LOCK:                                                                 */
/*                                                                                                                         */
/*                     IF di-rutac.flgest = "E" OR di-rutac.flgest = "P" OR di-rutac.flgest = "X" THEN DO:                 */
/*                         pRetVal = "Documento ya se encuentra registrado en la H.R.:" + di-rutac.nrodoc.                 */
/*                         LEAVE CON_HOJA_RUTA.                                                                            */
/*                     END.                                                                                                */
/*                     IF di-rutac.flgest = "C"  AND di-rutad.flgest = "C" THEN DO:                                        */
/*                         pRetVal = "Documento ya se encuentra registrado en la H.R.:" + di-rutac.nrodoc.                 */
/*                         LEAVE CON_HOJA_RUTA.                                                                            */
/*                     END.                                                                                                */
/*                 END.                                                                                                    */
/*             END.                                                                                                        */
/*         END.                                                                                                            */
/*     END.                                                                                                                */
/*     IF faccpedi.codref = 'R/A'                                                                                          */
/*         OR (faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'OPEN') THEN DO:  /* Ic, 21Dic20222 - CrossDocking Compras */ */
/*                                                                                                                         */
/*         pRetVal = "OK".                                                                                                 */
/*                                                                                                                         */
/*         CON_HOJA_RUTA2:                                                                                                 */
/*         /* Busco las G/R de la OTR y que no esten anulada */                                                            */
/*         FOR EACH almcmov USE-INDEX almc07 WHERE almcmov.codcia = s-codcia                                               */
/*             AND almcmov.codref = pCodDoc                                                                                */
/*             AND almcmov.nroref = pNroDoc                                                                                */
/*             AND almcmov.tipmov = s-tipmov                                                                               */
/*             AND almcmov.codmov = s-codmov                                                                               */
/*             AND Almcmov.flgest <> "A" NO-LOCK:                                                                          */
/*                                                                                                                         */
/*             /* Si no esta en otra H/R */                                                                                */
/*             FOR EACH di-rutag USE-INDEX llave02 NO-LOCK WHERE di-rutag.codcia = s-codcia                                */
/*                 AND di-rutag.coddoc = "H/R"                                                                             */
/*                 AND di-rutag.serref = almcmov.nroser                                                                    */
/*                 AND di-rutag.nroref = almcmov.nrodoc,                                                                   */
/*                 FIRST di-rutac OF di-rutag NO-LOCK:                                                                     */
/*                 IF di-rutac.flgest = "E" OR di-rutac.flgest = "P" THEN DO:                                              */
/*                     pRetVal = "Documento ya se encuentra registrado en la H.R.:" + di-rutac.nrodoc.                     */
/*                     LEAVE CON_HOJA_RUTA2.                                                                               */
/*                 END.                                                                                                    */
/*                 IF di-rutac.flgest = "C"  AND di-rutag.flgest = "C" THEN DO:                                            */
/*                     pRetVal = "Documento ya se encuentra registrado en la H.R.:" + di-rutac.nrodoc.                     */
/*                     LEAVE CON_HOJA_RUTA2.                                                                               */
/*                 END.                                                                                                    */
/*             END.                                                                                                        */
/*         END.                                                                                                            */
/*     END.                                                                                                                */
END.
ELSE DO:
    pRetVal = "La Orden NO EXISTE !!!".
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

