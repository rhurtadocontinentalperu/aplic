&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER BCMOV FOR INTEGRAL.Almcmov.
DEFINE TEMP-TABLE CTRANSF NO-UNDO LIKE INTEGRAL.Almcmov.
DEFINE TEMP-TABLE CTRANSF-UNO NO-UNDO LIKE INTEGRAL.Almcmov.
DEFINE TEMP-TABLE DTRANSF NO-UNDO LIKE INTEGRAL.Almdmov.
DEFINE TEMP-TABLE DTRANSF-UNO NO-UNDO LIKE INTEGRAL.Almdmov.



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

DEF INPUT PARAMETER COMBO-BOX-NroMes AS INT.
DEF INPUT PARAMETER COMBO-BOX-Periodo AS INT.
DEF INPUT PARAMETER TABLE FOR CTRANSF-UNO.
DEF INPUT PARAMETER TABLE FOR DTRANSF-UNO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DISABLE TRIGGERS FOR LOAD OF integral.almcmov.
DISABLE TRIGGERS FOR LOAD OF integral.almdmov.
DISABLE TRIGGERS FOR LOAD OF integral.Almtdocm.
DISABLE TRIGGERS FOR LOAD OF integral.Almacen.

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
   Temp-Tables and Buffers:
      TABLE: BCMOV B "?" ? INTEGRAL Almcmov
      TABLE: CTRANSF T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: CTRANSF-UNO T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: DTRANSF T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: DTRANSF-UNO T "?" NO-UNDO INTEGRAL Almdmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN Salida-por-Transferencia.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    RUN Ingreso-por-Transferencia.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Ingreso-por-Transferencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ingreso-por-Transferencia Procedure 
PROCEDURE Ingreso-por-Transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR r-Rowid AS ROWID NO-UNDO.
DEF VAR x-NroDoc AS INT NO-UNDO.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FOR EACH CTRANSF:
        FIND integral.Almtdocm WHERE integral.Almtdocm.CodCia = S-CODCIA 
            AND integral.Almtdocm.CodAlm = CTRANSF.AlmDes
            AND integral.Almtdocm.TipMov = "I" 
            AND integral.Almtdocm.CodMov = 03
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'NO se pudo bloquear el correlativo de ingreso almacén' CTRANSF.AlmDes
                VIEW-AS ALERT-BOX TITLE 'Ingreso por Transferencia CONTINENTAL'.
            UNDO trloop, RETURN 'ADM-ERROR'.
        END.
        x-NroDoc = integral.Almtdocm.NroDoc.
        REPEAT:
            IF NOT CAN-FIND(FIRST integral.Almcmov WHERE integral.Almcmov.CodCia = integral.Almtdocm.CodCia 
                            AND integral.Almcmov.CodAlm = integral.Almtdocm.CodAlm 
                            AND integral.Almcmov.TipMov = integral.Almtdocm.TipMov 
                            AND integral.Almcmov.CodMov = integral.Almtdocm.CodMov 
                            AND integral.Almcmov.NroSer = 000
                            AND integral.Almcmov.NroDoc = x-NroDoc
                            NO-LOCK)
                THEN LEAVE.
            x-NroDoc = x-NroDoc + 1.
        END.
        CREATE integral.Almcmov.
        ASSIGN
            integral.Almcmov.CodCia  = integral.Almtdocm.CodCia 
            integral.Almcmov.CodAlm  = integral.Almtdocm.CodAlm 
            integral.Almcmov.TipMov  = integral.Almtdocm.TipMov 
            integral.Almcmov.CodMov  = integral.Almtdocm.CodMov 
            integral.Almcmov.NroSer  = 000
            integral.Almcmov.NroDoc  = x-NroDoc
            integral.Almcmov.AlmDes  = CTRANSF.CodAlm
            integral.Almcmov.FlgSit  = ""
            integral.Almcmov.FchDoc  = CTRANSF.FchDoc
            integral.Almcmov.HorRcp  = "00:01:01"
            /*integral.Almcmov.NomRef  = F-NomDes:SCREEN-VALUE IN FRAME {&FRAME-NAME}            */
            integral.Almcmov.Nrorf1  = STRING(CTRANSF.NroSer,"999") + STRING(CTRANSF.NroDoc)
            /*integral.Almcmov.Nrorf2  = integral.Almcmov.Nrorf2:SCREEN-VALUE IN FRAME {&FRAME-NAME}*/
            integral.Almcmov.NroRf3 = STRING(COMBO-BOX-Periodo, '9999') + STRING(COMBO-BOX-NroMes, '99')
            integral.Almcmov.CodDoc = "DEVCOCI"
            integral.Almcmov.usuario = S-USER-ID. 
        ASSIGN
            integral.Almtdocm.NroDoc = x-NroDoc + 1.

        FOR EACH DTRANSF OF CTRANSF:
            CREATE integral.almdmov.
            ASSIGN 
                integral.almdmov.CodCia = integral.Almcmov.CodCia 
                integral.almdmov.CodAlm = integral.Almcmov.CodAlm 
                integral.almdmov.TipMov = integral.Almcmov.TipMov 
                integral.almdmov.CodMov = integral.Almcmov.CodMov 
                integral.almdmov.NroSer = integral.Almcmov.NroSer 
                integral.almdmov.NroDoc = integral.Almcmov.NroDoc 
                integral.almdmov.CodMon = integral.Almcmov.CodMon 
                integral.almdmov.FchDoc = integral.Almcmov.FchDoc 
                integral.almdmov.TpoCmb = integral.Almcmov.TpoCmb 
                integral.almdmov.codmat = DTRANSF.codmat 
                integral.almdmov.CanDes = DTRANSF.CanDes 
                integral.almdmov.CodUnd = DTRANSF.CodUnd 
                integral.almdmov.Factor = DTRANSF.Factor 
                integral.almdmov.ImpCto = DTRANSF.ImpCto 
                integral.almdmov.PreUni = DTRANSF.PreUni 
                integral.almdmov.AlmOri = integral.Almcmov.AlmDes 
                integral.almdmov.CodAjt = '' 
                integral.almdmov.HraDoc = integral.Almcmov.HorRcp
                R-ROWID = ROWID(integral.almdmov).

/*             RUN ALM\ALMACSTK (R-ROWID).                                  */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*                                                                          */
/*             RUN alm/almacpr1 (R-ROWID, 'U').                             */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */

            /*F-TOTDES = F-TOTDES + integral.almdmov.CanDes.*/
        END.
        FIND BCMOV OF CTRANSF EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE BCMOV THEN UNDO trloop, RETURN "ADM-ERROR".
        ASSIGN 
            BCMOV.FlgSit  = "R" 
            BCMOV.HorRcp  = "00:01:01"
            BCMOV.NroRf2  = STRING(integral.Almcmov.NroDoc).
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Salida-por-Transferencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Salida-por-Transferencia Procedure 
PROCEDURE Salida-por-Transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Retornamos la mercadería del almacén 21  a los demás
------------------------------------------------------------------------------*/

DEF VAR x-NroDoc AS INT INIT 000000 NO-UNDO.
DEF VAR s-NroSer AS INT INIT 000    NO-UNDO.
DEF VAR r-Rowid  AS ROWID NO-UNDO.
DEF VAR x-Item   AS INT INIT 0 NO-UNDO.
DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.

RUN src/bin/_dateif (COMBO-BOX-NroMes, COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).
x-FechaH = x-FechaH + 1.

EMPTY TEMP-TABLE CTRANSF.
EMPTY TEMP-TABLE DTRANSF.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Buscamos el correlativo de almacenes */
    FIND integral.Almacen WHERE integral.Almacen.CodCia = s-CodCia
        AND integral.Almacen.CodAlm = "21"
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almacen THEN DO: 
        MESSAGE 'NO se pudo bloquer el correlativo por Almacen' 
            VIEW-AS ALERT-BOX ERROR TITLE 'Salidas por Transferencia Alm 21 CONTINENTAL'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FOR EACH CTRANSF-UNO NO-LOCK:
        ASSIGN 
            x-Nrodoc  = integral.Almacen.CorrSal.
        REPEAT:
            IF NOT CAN-FIND(FIRST integral.Almcmov WHERE integral.Almcmov.CodCia = s-CodCia 
                            AND integral.Almcmov.CodAlm = "21"
                            AND integral.Almcmov.TipMov = "S"
                            AND integral.Almcmov.CodMov = 03
                            AND integral.Almcmov.NroSer = s-nroser
                            AND integral.Almcmov.NroDoc = x-NroDoc
                            NO-LOCK)
                THEN LEAVE.
            x-NroDoc = x-NroDoc + 1.
        END.
        CREATE integral.Almcmov.
        ASSIGN 
            integral.Almcmov.CodCia = s-CodCia 
            integral.Almcmov.CodAlm = "21"
            integral.Almcmov.TipMov = "S"
            integral.Almcmov.CodMov = 03
            integral.Almcmov.NroSer = s-nroser
            integral.Almcmov.NroDoc = x-NroDoc
            integral.Almcmov.AlmDes = CTRANSF-UNO.CodAlm
            integral.Almcmov.FlgSit = "T"      /* Recepcionado */
            integral.Almcmov.FchDoc = x-FechaH
            integral.Almcmov.HorSal = "00:01:01"
            integral.Almcmov.HraDoc = "00:01:01"
            integral.Almcmov.CodRef = ""
            integral.Almcmov.NomRef = ""
            integral.Almcmov.NroRf1 = ""
            integral.Almcmov.NroRf2 = ""
            integral.Almcmov.NroRf3 = STRING(COMBO-BOX-Periodo, '9999') + STRING(COMBO-BOX-NroMes, '99')
            integral.Almcmov.CodDoc = "DEVCOCI"
            integral.Almcmov.usuario = S-USER-ID.
        ASSIGN
            integral.Almacen.CorrSal = x-NroDoc + 1.
        x-Item = 1.
        CREATE CTRANSF.
        BUFFER-COPY integral.Almcmov TO CTRANSF.
        FOR EACH DTRANSF-UNO OF CTRANSF-UNO NO-LOCK:
            CREATE integral.Almdmov.
            BUFFER-COPY DTRANSF-UNO
                TO integral.Almdmov
                ASSIGN 
                integral.almdmov.CodCia = integral.Almcmov.CodCia 
                integral.almdmov.CodAlm = integral.Almcmov.CodAlm 
                integral.almdmov.TipMov = integral.Almcmov.TipMov 
                integral.almdmov.CodMov = integral.Almcmov.CodMov 
                integral.almdmov.NroSer = integral.Almcmov.NroSer
                integral.almdmov.NroDoc = integral.Almcmov.NroDoc 
                integral.almdmov.CodMon = integral.Almcmov.CodMon 
                integral.almdmov.FchDoc = integral.Almcmov.FchDoc 
                integral.almdmov.HraDoc = integral.Almcmov.HraDoc
                integral.almdmov.TpoCmb = integral.Almcmov.TpoCmb
                integral.almdmov.AlmOri = integral.Almcmov.AlmDes 
                integral.almdmov.HraDoc = integral.Almcmov.HorSal
                integral.almdmov.NroItm = x-Item
                R-ROWID = ROWID(integral.almdmov).
            x-Item = x-Item + 1.
            CREATE DTRANSF.
            BUFFER-COPY integral.Almdmov TO DTRANSF.
    /*     RUN almdcstk (R-ROWID).                                      */
    /*     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
    /*     RUN almacpr1 (R-ROWID, "U").                                 */
    /*     IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
        END.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

