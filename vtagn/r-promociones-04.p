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

DEFINE INPUT PARAMETER x-rowid AS ROWID.
DEFINE OUTPUT PARAMETER cMessage AS CHARACTER   NO-UNDO.

DEFINE VARIABLE dTotProm AS DECIMAL NO-UNDO.
DEFINE VARIABLE iCant    AS INTEGER     NO-UNDO.

DEFINE BUFFER b-DPromo FOR ProDProm.

DEFINE TEMP-TABLE tabla
    FIELDS codmat LIKE almmmatg.codmat
    FIELDS desmat LIKE almmmatg.desmat
    FIELDS canmat AS DECIMAL.

FOR EACH tabla:
    DELETE tabla.
END.

/* Pedidos Mostrador (P/M) */
FIND FacCPedi WHERE ROWID(FacCPedi) = x-rowid NO-LOCK NO-ERROR.       
FOR EACH ProCProm WHERE ProCProm.CodCia = FacCPedi.CodCia
    AND ProCProm.CodDoc = FacCPedi.CodDoc
    AND ProCProm.FlgEst = "A"
    AND ProCProm.FechaI <= FacCPedi.FchPed 
    AND ProCProm.FechaF >= FacCPedi.FchPed NO-LOCK:   
    dTotProm = 0.    
    FOR EACH FacDPedi OF FacCPedi NO-LOCK:
        FIND ProDProm OF ProCProm WHERE ProdProm.Tipo = "P"                  
            AND FacDPedi.CodMat = ProDProm.CodMat NO-LOCK NO-ERROR.
        IF AVAIL ProDProm THEN DO:
            IF FacCPedi.CodMon = ProCProm.CodMon THEN
                dTotProm = dTotProm + FacDPedi.ImpLin.
            ELSE DO:
                CASE FacCPedi.CodMon:
                    WHEN 1 THEN 
                        dTotProm = dTotProm + (FacDPedi.ImpLin / FacCPedi.TpoCmb).
                    WHEN 2 THEN
                        dTotProm = dTotProm + (FacDPedi.ImpLin * FacCPedi.TpoCmb).
                END CASE.
            END.

        END.
    END.

    IF dTotProm >= ProCProm.Importe THEN 
        iCant = TRUNCATE(dTotProm / ProCProm.Importe , 0).
    ELSE iCant = 0.
    
    IF iCant <> 0 THEN 
    FOR EACH b-dpromo OF ProCProm 
        WHERE b-dpromo.tipo = "R" NO-LOCK:
        FIND FIRST Almmmatg WHERE Almmmatg.codcia = ProCProm.CodCia
            AND Almmmatg.codmat = b-dpromo.codmat NO-LOCK NO-ERROR.
        FIND FIRST tabla WHERE tabla.codmat = b-dpromo.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL tabla THEN DO: 
            CREATE tabla.
            ASSIGN tabla.codmat = b-dpromo.codmat
                tabla.desmat = almmmatg.DesMat.
        END.                        
        ASSIGN tabla.canmat = tabla.canmat + (iCant * b-dpromo.Cantidad).
    END.
END.

FOR EACH tabla:
    cmessage = cmessage + STRING(tabla.canmat) + " " + tabla.desmat +  ".".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


