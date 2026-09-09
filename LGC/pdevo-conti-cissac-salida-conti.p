&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER BCMOV FOR INTEGRAL.Almcmov.
DEFINE TEMP-TABLE CDEVO NO-UNDO LIKE INTEGRAL.Almcmov.
DEFINE TEMP-TABLE CDOCU NO-UNDO LIKE INTEGRAL.CcbCDocu.
DEFINE TEMP-TABLE CTRANSF NO-UNDO LIKE INTEGRAL.Almcmov.
DEFINE TEMP-TABLE DDEVO NO-UNDO LIKE INTEGRAL.Almdmov.
DEFINE TEMP-TABLE DDOCU NO-UNDO LIKE INTEGRAL.CcbDDocu.
DEFINE TEMP-TABLE DMOV NO-UNDO LIKE INTEGRAL.Almdmov.
DEFINE TEMP-TABLE DTRANSF NO-UNDO LIKE INTEGRAL.Almdmov.
DEFINE TEMP-TABLE RDOCU NO-UNDO LIKE INTEGRAL.CcbDDocu.



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
DEF INPUT PARAMETER TABLE FOR DMOV.
DEF INPUT PARAMETER TABLE FOR RDOCU.
DEF OUTPUT PARAMETER TABLE FOR CDEVO.
DEF OUTPUT PARAMETER TABLE FOR DDEVO.
DEF INPUT-OUTPUT PARAMETER TABLE FOR CDOCU.
DEF INPUT-OUTPUT PARAMETER TABLE FOR DDOCU.
DEF OUTPUT PARAMETER TABLE FOR CTRANSF.
DEF OUTPUT PARAMETER TABLE FOR DTRANSF.

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
      TABLE: CDEVO T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: CTRANSF T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: DDEVO T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: DMOV T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: DTRANSF T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: RDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
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
    
    RUN Salida-por-Devolucion.
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
    FIND integral.Almtdocm WHERE integral.Almtdocm.CodCia = S-CODCIA 
        AND integral.Almtdocm.CodAlm = "21"
        AND integral.Almtdocm.TipMov = "I" 
        AND integral.Almtdocm.CodMov = 03
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquer el correlativo por Almacén: 21'
            VIEW-AS ALERT-BOX ERROR TITLE "ERROR: Ingreso por transferencia".
        UNDO trloop, RETURN 'ADM-ERROR'.
    END.
    FOR EACH CTRANSF:
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
            integral.Almcmov.HorRcp  = "23:59:59"
            /*integral.Almcmov.NomRef  = F-NomDes:SCREEN-VALUE IN FRAME {&FRAME-NAME}            */
            integral.Almcmov.Nrorf1  = STRING(CTRANSF.NroSer,"999") + STRING(CTRANSF.NroDoc)
            /*integral.Almcmov.Nrorf2  = integral.Almcmov.Nrorf2:SCREEN-VALUE IN FRAME {&FRAME-NAME}*/
            integral.Almcmov.NroRf3 = STRING(COMBO-BOX-Periodo, "9999") + STRING(COMBO-BOX-NroMes, "99")
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
                integral.almdmov.AlmOri = integral.Almcmov.AlmDes 
                integral.almdmov.CodMon = integral.Almcmov.CodMon 
                integral.almdmov.FchDoc = integral.Almcmov.FchDoc 
                integral.almdmov.TpoCmb = integral.Almcmov.TpoCmb 
                integral.almdmov.codmat = DTRANSF.codmat 
                integral.almdmov.CanDes = DTRANSF.CanDes 
                integral.almdmov.CodUnd = DTRANSF.CodUnd 
                integral.almdmov.Factor = DTRANSF.Factor 
                integral.almdmov.ImpCto = DTRANSF.ImpCto 
                integral.almdmov.PreUni = DTRANSF.PreUni 
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
            BCMOV.HorRcp  = "23:59:59"
            BCMOV.NroRf2  = STRING(integral.Almcmov.NroDoc).
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Salida-por-Devolucion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Salida-por-Devolucion Procedure 
PROCEDURE Salida-por-Devolucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Se va a devolver por cada Factura comenzando con las mas recientes */                                                           
DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.
DEF VAR x-CanDev AS DEC NO-UNDO.
DEF VAR s-NroSer AS INT INIT 921 NO-UNDO.   /* OJO */
DEF VAR x-NroDoc AS INT NO-UNDO.
DEF VAR r-Rowid  AS ROWID NO-UNDO.

/* REPARTIMOS LAS CANTIDADES A DEVOLVER POR CADA FACTURA 
   DESDE LA MAS RECIENTE A LA MAS ANTIGUA 
*/   
FOR EACH RDOCU WHERE RDOCU.CanDev > 0:
    x-CanDev = RDOCU.CanDev.
    FOR EACH DDOCU WHERE DDOCU.codmat = RDOCU.codmat,
        FIRST CDOCU OF DDOCU BY CDOCU.FchDoc DESC:
        ASSIGN
            DDOCU.CanDev = MINIMUM(DDOCU.CanDes, x-CanDev).
        ASSIGN
            x-CanDev = x-CanDev - DDOCU.CanDev.
        IF x-CanDev <= 0 THEN LEAVE.
    END.
END.
FOR EACH DDOCU WHERE DDOCU.CanDev <= 0:
    DELETE DDOCU.
END.
/* ****************************************************** */

RUN src/bin/_dateif (COMBO-BOX-NroMes, COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).

EMPTY TEMP-TABLE CDEVO.
EMPTY TEMP-TABLE DDEVO.
trloop:                                                                                  
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST integral.FacCorre WHERE integral.FacCorre.CodCia = S-CODCIA 
        AND integral.FacCorre.CodDoc = "G/R" 
        AND integral.FacCorre.CodDiv = "00021"
        AND integral.FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquer el correlativo de la G/R:' s-nroser
            VIEW-AS ALERT-BOX ERROR TITLE "ERROR: Salida por devolución a CISSAC".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Generamos la salida por devolucion a proveedor */
    FOR EACH CDOCU, EACH DDOCU OF CDOCU BREAK BY CDOCU.NroDoc:
        IF FIRST-OF(CDOCU.NroDoc) THEN DO:
            ASSIGN
                x-NroDoc = integral.FacCorre.Correlativo.
            REPEAT:
                IF NOT CAN-FIND(FIRST integral.Almcmov WHERE integral.Almcmov.CodCia = s-CodCia
                                AND integral.Almcmov.CodAlm = "21"
                                AND integral.Almcmov.TipMov = "S"
                                AND integral.Almcmov.CodMov = 09
                                AND integral.Almcmov.NroSer = s-NroSer
                                AND integral.Almcmov.NroDoc = x-NroDoc
                                NO-LOCK)
                    THEN LEAVE.
                x-NroDoc = x-NroDoc + 1.
            END.
            CREATE integral.Almcmov.
            ASSIGN 
                integral.Almcmov.CodCia  = s-CodCia 
                integral.Almcmov.CodAlm  = "21"
                integral.Almcmov.TipMov  = "S"
                integral.Almcmov.CodMov  = 09
                integral.Almcmov.NroSer = S-NROSER
                integral.Almcmov.NroDoc = x-NroDoc
                integral.Almcmov.CodRef  = CDOCU.CodDoc     /* OJO: Referenciamos la FAC */
                integral.Almcmov.NroRef  = CDOCU.NroDoc
                integral.Almcmov.NroRf3 = STRING(COMBO-BOX-Periodo, "9999") + STRING(COMBO-BOX-NroMes, "99")
                integral.Almcmov.CodDoc = "DEVCOCI"
                integral.Almcmov.FchDoc  = x-FechaH
                integral.Almcmov.HorRcp  = "23:59:59"
                integral.Almcmov.CodPro  = "51135890"       /* CISSAC */
                integral.Almcmov.CodMon  = CDOCU.CodMon.
            ASSIGN
                integral.FacCorre.Correlativo = x-NroDoc + 1.
            FIND integral.gn-prov WHERE integral.gn-prov.CodCia = pv-codcia 
                AND integral.gn-prov.CodPro = integral.Almcmov.CodPro NO-LOCK NO-ERROR.
            IF AVAILABLE integral.gn-prov THEN integral.Almcmov.nomref = integral.gn-prov.NomPro.
            FIND LAST integral.gn-tcmb WHERE integral.gn-tcmb.fecha <= integral.Almcmov.FchDoc NO-LOCK NO-ERROR.
            IF AVAILABLE integral.gn-tcmb THEN integral.Almcmov.TpoCmb = integral.gn-tcmb.venta.
            ASSIGN 
                integral.Almcmov.usuario = S-USER-ID
                integral.Almcmov.ImpIgv  = 0
                integral.Almcmov.ImpMn1  = 0
                integral.Almcmov.ImpMn2  = 0.
        END.
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
            integral.almdmov.HraDoc = integral.Almcmov.HorRcp
            integral.almdmov.TpoCmb = integral.Almcmov.TpoCmb
            integral.almdmov.IgvMat = CDOCU.PorIgv
            integral.almdmov.codmat = DDOCU.codmat
            integral.almdmov.CanDes = DDOCU.CanDev      /* OJO */
            integral.almdmov.CodUnd = DDOCU.UndVta
            integral.almdmov.Factor = DDOCU.Factor
            integral.almdmov.PreUni = DDOCU.PreUni / ( 1 + CDOCU.PorIgv / 100 )
            integral.almdmov.ImpCto = ROUND(integral.almdmov.CanDes * integral.almdmov.PreUni,2)      /* OJO */
            /*integral.almdmov.PreLis = DDOCU.PreLis*/
            integral.almdmov.Dsctos[1] = 0
            integral.almdmov.Dsctos[2] = 0
            integral.almdmov.Dsctos[3] = 0
            integral.almdmov.CodAjt = ' '
            R-ROWID = ROWID(integral.almdmov).

        CREATE DDEVO.
        BUFFER-COPY integral.almdmov TO DDEVO.

/*        RUN almdcstk (R-ROWID).                                      */
/*        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*                                                                     */
/*        RUN ALMACPR1 (R-ROWID,"U").                                  */
/*        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */

       IF integral.almdmov.CodMon = 1 THEN DO:
            integral.Almcmov.ImpIgv  = integral.Almcmov.ImpIgv  + ROUND(integral.almdmov.ImpCto * integral.almdmov.IgvMat / 100 ,2).
            ASSIGN integral.Almcmov.ImpMn1  = integral.Almcmov.ImpMn1 + integral.almdmov.ImpCto.
            IF integral.almdmov.TpoCmb > 0 THEN 
               ASSIGN  integral.Almcmov.ImpMn2  = integral.Almcmov.ImpMn2 + ROUND(integral.almdmov.ImpCto / integral.almdmov.TpoCmb,2).
         END.
       ELSE  DO:
         ASSIGN integral.Almcmov.ImpMn1  = integral.Almcmov.ImpMn1 + ROUND(integral.almdmov.ImpCto * integral.almdmov.TpoCmb,2)
                integral.Almcmov.ImpMn2  = integral.Almcmov.ImpMn2 + integral.almdmov.ImpCto
                integral.Almcmov.ImpIgv  = integral.Almcmov.ImpIgv  + ROUND(integral.almdmov.ImpCto * integral.almdmov.TpoCmb * integral.almdmov.IgvMat / 100 ,2).
       END.
       IF LAST-OF(CDOCU.NroDoc) THEN DO:
           CREATE CDEVO.
           BUFFER-COPY integral.Almcmov TO CDEVO.
       END.
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
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NroDoc AS INT INIT 000000 NO-UNDO.
DEF VAR s-NroSer AS INT INIT 000    NO-UNDO.
DEF VAR r-Rowid  AS ROWID NO-UNDO.
DEF VAR x-Item   AS INT INIT 0 NO-UNDO.
DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.

RUN src/bin/_dateif (COMBO-BOX-NroMes, COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).

EMPTY TEMP-TABLE CTRANSF.
EMPTY TEMP-TABLE DTRANSF.
trloop:
FOR EACH DMOV BREAK BY DMOV.codalm BY DMOV.codmat
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    IF FIRST-OF(DMOV.codalm) THEN DO:
        /* Buscamos el correlativo de almacenes */
        FIND integral.Almacen WHERE integral.Almacen.CodCia = DMOV.CodCia
            AND integral.Almacen.CodAlm = DMOV.CodAlm 
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE integral.Almacen THEN DO: 
            MESSAGE 'NO se pudo bloquer el correlativo por Almacén:' DMOV.CodAlm 
                VIEW-AS ALERT-BOX ERROR TITLE "ERROR: Salida por transferencia".
            UNDO, RETURN 'ADM-ERROR'.
        END.
/*         ASSIGN                                                       */
/*             x-Nrodoc  = integral.Almacen.CorrSal                     */
/*             integral.Almacen.CorrSal = integral.Almacen.CorrSal + 1. */
        x-NroDoc = integral.Almacen.CorrSal.
        REPEAT:
            IF NOT CAN-FIND(FIRST integral.Almcmov WHERE integral.Almcmov.CodCia = DMOV.CodCia 
                            AND integral.Almcmov.CodAlm = DMOV.CodAlm 
                            AND integral.Almcmov.TipMov = DMOV.TipMov
                            AND integral.Almcmov.CodMov = DMOV.CodMov
                            AND integral.Almcmov.NroSer = s-nroser
                            AND integral.Almcmov.NroDoc = x-NroDoc
                            NO-LOCK)
                THEN LEAVE.
            x-NroDoc = x-NroDoc + 1.
        END.

        CREATE integral.Almcmov.
        ASSIGN 
            integral.Almcmov.CodCia = DMOV.CodCia 
            integral.Almcmov.CodAlm = DMOV.CodAlm 
            integral.Almcmov.TipMov = DMOV.TipMov
            integral.Almcmov.CodMov = DMOV.CodMov
            integral.Almcmov.NroSer = s-nroser
            integral.Almcmov.NroDoc = x-NroDoc
            integral.Almcmov.AlmDes = DMOV.AlmOri
            integral.Almcmov.FlgSit = "T"      /* Transferido */
            integral.Almcmov.FchDoc = x-FechaH
            integral.Almcmov.HorSal = "23:59:59"
            integral.Almcmov.HraDoc = "23:59:59"
            integral.Almcmov.CodRef = ""
            integral.Almcmov.NomRef = ""
            integral.Almcmov.NroRf1 = ""
            integral.Almcmov.NroRf2 = ""
            integral.Almcmov.NroRf3 = STRING(COMBO-BOX-Periodo, "9999") + STRING(COMBO-BOX-NroMes, "99")
            integral.Almcmov.CodDoc = "DEVCOCI"
            integral.Almcmov.usuario = S-USER-ID.
        ASSIGN
            integral.Almacen.CorrSal = x-NroDoc + 1.
        x-Item = 1.
        CREATE CTRANSF.
        BUFFER-COPY integral.Almcmov TO CTRANSF.
    END.
    /* Grabamos Detalle */
    CREATE integral.almdmov.
    ASSIGN 
        integral.almdmov.CodCia = integral.Almcmov.CodCia 
        integral.almdmov.CodAlm = integral.Almcmov.CodAlm 
        integral.almdmov.AlmOri = integral.Almcmov.AlmDes 
        integral.almdmov.TipMov = integral.Almcmov.TipMov 
        integral.almdmov.CodMov = integral.Almcmov.CodMov 
        integral.almdmov.NroSer = integral.Almcmov.NroSer
        integral.almdmov.NroDoc = integral.Almcmov.NroDoc 
        integral.almdmov.CodMon = integral.Almcmov.CodMon 
        integral.almdmov.FchDoc = integral.Almcmov.FchDoc 
        integral.almdmov.HraDoc = integral.Almcmov.HraDoc
        integral.almdmov.TpoCmb = integral.Almcmov.TpoCmb
        integral.almdmov.codmat = DMOV.codmat
        integral.almdmov.CanDes = DMOV.CanDes
        integral.almdmov.CodUnd = DMOV.CodUnd
        integral.almdmov.Factor = DMOV.Factor
        integral.almdmov.CodAjt = ''
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
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

