&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Almacen FOR Almacen.
DEFINE BUFFER B-Almmmatg FOR Almmmatg.
DEFINE BUFFER B-Almtfami FOR Almtfami.
DEFINE BUFFER B-CREPO FOR almcrepo.
DEFINE BUFFER B-DREPO FOR almdrepo.
DEFINE BUFFER B-FacCfgGn FOR FacCfgGn.
DEFINE BUFFER B-FacCfgVta FOR FacCfgVta.
DEFINE BUFFER B-FacCPedi FOR FacCPedi.
DEFINE BUFFER B-FacDPedi FOR FacDPedi.
DEFINE BUFFER B-FacTabla FOR FacTabla.
DEFINE BUFFER B-gre_detail FOR gre_detail.
DEFINE BUFFER B-gre_header FOR gre_header.
DEFINE BUFFER B-VtaAlmDiv FOR VtaAlmDiv.
DEFINE BUFFER B-VtaTabla FOR VtaTabla.



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

DEF INPUT PARAMETER pTabla AS CHAR NO-UNDO.
DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.

DEF SHARED VAR s-codcia AS INTE.

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
      TABLE: B-Almacen B "?" ? INTEGRAL Almacen
      TABLE: B-Almmmatg B "?" ? INTEGRAL Almmmatg
      TABLE: B-Almtfami B "?" ? INTEGRAL Almtfami
      TABLE: B-CREPO B "?" ? INTEGRAL almcrepo
      TABLE: B-DREPO B "?" ? INTEGRAL almdrepo
      TABLE: B-FacCfgGn B "?" ? INTEGRAL FacCfgGn
      TABLE: B-FacCfgVta B "?" ? INTEGRAL FacCfgVta
      TABLE: B-FacCPedi B "?" ? INTEGRAL FacCPedi
      TABLE: B-FacDPedi B "?" ? INTEGRAL FacDPedi
      TABLE: B-FacTabla B "?" ? INTEGRAL FacTabla
      TABLE: B-gre_detail B "?" ? INTEGRAL gre_detail
      TABLE: B-gre_header B "?" ? INTEGRAL gre_header
      TABLE: B-VtaAlmDiv B "?" ? INTEGRAL VtaAlmDiv
      TABLE: B-VtaTabla B "?" ? INTEGRAL VtaTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VAR LocalDiasComprometido AS DECI INIT 30 NO-UNDO.      /* Exagerando */
DEFINE VAR x-flg-reserva-stock AS CHAR NO-UNDO.
DEFINE VAR x-fecha AS DATE NO-UNDO.

DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.
DEF VAR TimeLimit AS CHARACTER NO-UNDO.
/* Definimos rango de fecha y hora */
DEF VAR dtDesde AS DATETIME NO-UNDO.
DEF VAR fDesde AS DATE NO-UNDO.
DEF VAR cHora  AS CHAR NO-UNDO.

FIND FIRST B-VtaTabla WHERE B-VtaTabla.CodCia = s-codcia AND 
    B-VtaTabla.Tabla = 'CONFIG-VTAS' AND 
    B-VtaTabla.Llave_c1 = 'STOCK-COMPROMETIDO'
    NO-LOCK NO-ERROR.
IF AVAILABLE B-VtaTabla AND B-VtaTabla.Valor[01] > 0 THEN LocalDiasComprometido = B-VtaTabla.Valor[01].
x-fecha = (TODAY - LocalDiasComprometido).

FIND FIRST B-FacCfgGn WHERE B-FacCfgGn.codcia = s-codcia NO-LOCK NO-ERROR. 
IF NOT AVAILABLE B-FacCfgGn THEN RETURN.

/* Dividimos el proceso de acuerdo a la tabla */
CASE pTabla:
    WHEN "FacDPedi" THEN DO:
        FIND B-FacDPedi WHERE ROWID(B-FacDPedi) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacDPedi THEN RETURN.
        IF B-FacDPedi.FlgEst <> "P" THEN RETURN.    /* OJO */

        FIND B-FacCPedi OF B-FacDPedi NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacCPedi THEN RETURN.

        CASE B-FacDPedi.CodDoc:
            WHEN "O/D" THEN DO:
                FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
                    B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
                    CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                             B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND 
                             B-VtaAlmDiv.codalm = B-FacCPedi.CodAlm NO-LOCK)    /* OJO */
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE B-FacTabla THEN RETURN.

                /* Estados Válidos */
                /* Para disparar la rutina a RIQRA solo se van a tener en cuenta 
                    los siguientes estados:
                    X: Procesando
                    P: Por facturar
                    A: Anulado
                */
                x-flg-reserva-stock = "X,P,A".                    
                IF LOOKUP(B-FacCPedi.FlgEst,x-Flg-Reserva-Stock) = 0 THEN RETURN.

                /*RUN Insert-Data-Log-Ped.*/
                RUN Insert-Data-Log (B-FacCPedi.CodAlm,
                                     B-FacCPedi.CodDoc,
                                     B-FacCPedi.NroPed,
                                     B-FaCDPedi.CodMat).
            END.
            WHEN "OTR" THEN DO:
                FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
                    B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
                    CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                             B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND 
                             B-VtaAlmDiv.codalm = B-FacCPedi.CodAlm NO-LOCK)    /* OJO */
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE B-FacTabla THEN RETURN.
    
                /* Estados Válidos */
                /* Para disparar la rutina a RIQRA solo se van a tener en cuenta 
                    los siguientes estados:
                    P: Aprobado
                    A: Anulado
                */
                x-flg-reserva-stock = "P,A".                    
                IF LOOKUP(B-FacCPedi.FlgEst,x-Flg-Reserva-Stock) = 0 THEN RETURN.
                /*RUN Insert-Data-Log-Ped.*/
                RUN Insert-Data-Log (B-FacCPedi.CodAlm,
                                     B-FacCPedi.CodDoc,
                                     B-FacCPedi.NroPed,
                                     B-FaCDPedi.CodMat).
            END.
            WHEN "PED" THEN DO:
                FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
                    B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
                    CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                             B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND 
                             B-VtaAlmDiv.codalm = B-FacDPedi.AlmDes NO-LOCK)    /* OJO */
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE B-FacTabla THEN RETURN.
                /* Estados Válidos */
                /* Para disparar la rutina a RIQRA solo se van a tener en cuenta 
                    los siguientes estados:
                    G: Generado
                    A: Anulado
                    R: Rechazado
                */
                x-flg-reserva-stock = "G,R,A".                    
                /*x-flg-reserva-stock = "G,X,P,W,WX,WL,A".    /* OJO: Se agrega A (ANULADO) */*/
                IF LOOKUP(B-FacCPedi.FlgEst,x-Flg-Reserva-Stock) = 0 THEN RETURN.

                IF B-FacDPedi.FchPed >= x-Fecha AND
                    B-FacCPedi.FchVen >= TODAY AND
                    B-FacDPedi.canate < B-FacDPedi.canped
                    THEN DO:
                    /*RUN Insert-Data-Log-Ped.*/
                    RUN Insert-Data-Log (B-FacDPedi.AlmDes,
                                         B-FacCPedi.CodDoc,
                                         B-FacCPedi.NroPed,
                                         B-FacDPedi.CodMat).
                END.
            END.
            WHEN "P/M" THEN DO:
                FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
                    B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
                    CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                             B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND 
                             B-VtaAlmDiv.codalm = B-FacDPedi.AlmDes NO-LOCK)    /* OJO */
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE B-FacTabla THEN RETURN.
                /* Estados Válidos */
                x-flg-reserva-stock = "P,A".    /* OJO: Se agrega A (ANULADO) */
                IF LOOKUP(B-FacCPedi.FlgEst,x-Flg-Reserva-Stock) = 0 THEN RETURN.

                /* 07/03/2023 Tiempos de Reserva */
                /* Tiempo por defecto fuera de campaña (segundos) */
                TimeOut = (B-FacCfgGn.Dias-Res * 24 * 3600) +
                    (B-FacCfgGn.Hora-Res * 3600) + 
                    (B-FacCfgGn.Minu-Res * 60).

                FIND FIRST B-FacCfgVta WHERE B-FacCfgVta.CodCia = s-codcia AND
                    B-FacCfgVta.CodDoc = "P/M" AND
                    (TODAY >= B-FacCfgVta.FechaD AND TODAY <= B-FacCfgVta.FechaH)
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-FacCfgVta THEN 
                    TimeOut = (B-FacCfgVta.Dias-Res * 24 * 3600) +
                        (B-FacCfgVta.Hora-Res * 3600) + 
                        (B-FacCfgVta.Minu-Res * 60).
                
                dtDesde = ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds').
                fDesde = DATE(dtDesde).
                cHora  = ENTRY(2,STRING(dtDesde, '99/99/9999 HH:MM'), ' ').
                IF B-FacDPedi.fchped >= fDesde AND B-FacDPedi.fchped <= TODAY THEN DO:
                    IF B-FacDPedi.fchped = fDesde AND B-FacDPedi.hora < cHora THEN RETURN.
                    /*RUN Insert-Data-Log-Ped.*/
                    RUN Insert-Data-Log (B-FacDPedi.AlmDes,
                                         B-FacCPedi.CodDoc,
                                         B-FacCPedi.NroPed,
                                         B-FacDPedi.CodMat).
                END.
            END.
            WHEN "COT" THEN DO:
                FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
                    B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
                    CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                             B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND 
                             B-VtaAlmDiv.codalm = B-FacDPedi.AlmDes NO-LOCK)    /* OJO */
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE B-FacTabla THEN RETURN.
                /* Estados Válidos */
                /* Para disparar la rutina a RIQRA solo se van a tener en cuenta 
                    los siguientes estados:
                    PV: Por aprobar
                    PA: Por aprobador administrador
                    E: Por aprobar supervisor
                    DA: Descuento administrador
                    P: Pendiente de pedido logístico
                    X: Cerrado manualmente
                    A: Anulado
                */
                x-flg-reserva-stock = "PV,PA,E,DA,P,X,A".
                FIND FIRST B-VtaTabla WHERE B-VtaTabla.codcia = s-codcia AND
                    B-VtaTabla.tabla = "CONFIG-VTAS" AND
                    B-VtaTabla.llave_c1 = "PEDIDO.COMERCIAL" AND
                    B-VtaTabla.llave_c2 = "FLG.RESERVA.STOCK" AND
                    B-VtaTabla.llave_c3 = B-FacCPedi.coddiv NO-LOCK NO-ERROR.     /* division */
                IF AVAILABLE B-VtaTabla THEN DO:
                    IF NOT (TRUE <> (B-VtaTabla.llave_c4 > "")) THEN DO:
                        x-flg-reserva-stock = TRIM(B-VtaTabla.llave_c4).
                    END.
                END.
                IF LOOKUP(B-FacCPedi.FlgEst,x-Flg-Reserva-Stock) = 0 THEN RETURN.
    
                /* Verificamos si reserva stock */
                FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-CodCia AND
                    B-FacTabla.tabla = 'GN-DIVI' AND
                    B-FacTabla.codigo = B-FacCPedi.coddiv AND
                    B-FacTabla.campo-l[2] = YES AND
                    B-FacTabla.Valor[1] > 0
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE B-FacTabla THEN RETURN.
    
                /* RHC 21/05/2020 Ahora tiene horas y/o hora tope */
                /* Pasada esa hora NO vale la Cotización */
                TimeLimit = ''.
                IF B-FacTabla.campo-c[1] > '' AND B-FacTabla.campo-c[1] > '0000' THEN DO:
                    TimeLimit = STRING(B-FacTabla.campo-c[1], 'XX:XX').
                    IF STRING(TIME, 'HH:MM') > TimeLimit THEN RETURN.
                END.
                TimeOut = 0.
                IF B-FacTabla.valor[1] > 0 THEN TimeOut = (B-FacTabla.Valor[1] * 3600).       /* Tiempo máximo en segundos */
                dtDesde = ADD-INTERVAL(NOW, (-1 * TimeOut) , 'seconds').
                fDesde = DATE(dtDesde).
                cHora  = ENTRY(2,STRING(dtDesde, '99/99/9999 HH:MM'), ' ').
    
                IF B-FacDPedi.fchped >= fDesde AND 
                    B-FacDPedi.fchped <= TODAY AND 
                    B-FacDPedi.canate < B-FacDPedi.canped THEN DO:
                    IF B-FacDPedi.fchped = fDesde AND B-FacDPedi.hora < cHora THEN RETURN.
                    /*RUN Insert-Data-Log-Ped.*/
                    RUN Insert-Data-Log (B-FacDPedi.AlmDes,
                                         B-FacCPedi.CodDoc,
                                         B-FacCPedi.NroPed,
                                         B-FacDPedi.CodMat).
                END.
            END.
        END CASE.
    END.
    WHEN "Gre_Detail" THEN DO:
        FIND B-gre_detail WHERE ROWID(B-gre_detail) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-gre_detail THEN RETURN.
        IF B-gre_detail.reserva_stock <> "SI" THEN RETURN.

        FIND B-gre_header WHERE B-gre_header.ncorrelatio = B-gre_detail.ncorrelativo NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-gre_header THEN RETURN.

        /* Verificamos que sea una división válida */
        FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
            B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
            CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                     B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND 
                     B-VtaAlmDiv.codalm = B-gre_header.m_codalm NO-LOCK)    /* OJO */
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacTabla THEN RETURN.

        /*RUN Insert-Data-Log-GR.*/
        RUN Insert-Data-Log (B-gre_header.m_codalm,
                             "GRE",
                             STRING(B-gre_detail.ncorrelativo, '99999999'),
                             B-gre_detail.CodMat).
    END.
    WHEN "Almdrepo" THEN DO:
        FIND B-DREPO WHERE ROWID(B-DREPO) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-DREPO THEN RETURN.
        IF B-DREPO.FlgEst <> "P" THEN RETURN.    /* OJO */

        FIND B-CREPO WHERE B-CREPO.codcia = B-DREPO.codcia AND 
            B-CREPO.codalm = B-DREPO.codalm AND
            B-CREPO.tipmov = B-DREPO.tipmov AND
            B-CREPO.nroser = B-DREPO.nroser AND
            B-CREPO.nrodoc = B-DREPO.nrodoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CREPO THEN RETURN.
        /* Estados Válidos */
        DEF VAR x-TipMov AS CHAR INIT 'A,M,RAN,INC' NO-UNDO.

        /* Estados Válidos */
        /* Para disparar la rutina a RIQRA solo se van a tener en cuenta 
            los siguientes estados:
            P: Pendiente
            A: Anulado
            R: Rechazado
            X: ???
        */
        x-flg-reserva-stock = "P,X,A,R".
        IF LOOKUP(B-CREPO.flgest, x-flg-reserva-stock) = 0 THEN NEXT.
        IF LOOKUP(B-CREPO.tipmov, x-TipMov) = 0 THEN RETURN.

        FIND B-Almacen WHERE B-Almacen.codcia = B-CREPO.codcia AND 
            B-Almacen.codalm = B-CREPO.codalm NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-Almacen THEN RETURN.

        /* Verificamos que sea una división válida */
        FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
            B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
            CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                     B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND 
                     B-VtaAlmDiv.codalm = B-CREPO.almped NO-LOCK)    /* OJO */
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacTabla THEN RETURN.

        /*RUN Insert-Data-Log-RAN.*/
        RUN Insert-Data-Log (B-CREPO.almped,
                             B-DREPO.tipmov,
                             STRING(B-DREPO.nroser, '999') + STRING(B-DREPO.nrodoc),
                             B-DREPO.codmat).
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Insert-Data-Log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Insert-Data-Log Procedure 
PROCEDURE Insert-Data-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pCodAlm AS CHAR.
    DEF INPUT PARAMETER pCodDoc AS CHAR.
    DEF INPUT PARAMETER pNroDoc AS CHAR.
    DEF INPUT PARAMETER pCodMat AS CHAR.

    CREATE logmovdisp.
    ASSIGN
        logmovdisp.codalm = pCodAlm
        logmovdisp.coddoc = pCodDoc
        logmovdisp.codmat = pCodMat
        logmovdisp.fechareg = TODAY
        logmovdisp.flgest = "P"
        logmovdisp.horareg = STRING(TIME,'HH:MM:SS')
        logmovdisp.nrodoc = pNroDoc
        logmovdisp.origen = "RIQRA-HORIZONTAL"
        .
    /* Ejecutammos el API */
    DEF VAR pMensaje AS CHAR NO-UNDO.
    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN web/web-library.p PERSISTENT SET hProc.

    RUN web_api-riqra-stock-disponible IN hProc (pCodAlm, pCodMat, OUTPUT pMensaje).

    DELETE PROCEDURE hProc.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
    END.
    ELSE logmovdisp.flgest = "C".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Insert-Data-Log-GR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Insert-Data-Log-GR Procedure 
PROCEDURE Insert-Data-Log-GR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE logmovdisp.
    ASSIGN
        logmovdisp.codalm = B-gre_detail.codalm
        logmovdisp.coddoc = "GRE"
        logmovdisp.codmat = B-gre_detail.codmat
        logmovdisp.fechareg = TODAY
        logmovdisp.flgest = "P"
        logmovdisp.horareg = STRING(TIME,'HH:MM:SS')
        logmovdisp.nrodoc = STRING(B-gre_detail.ncorrelativo, '99999999')
        logmovdisp.origen = "RIQRA-HORIZONTAL"
        .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Insert-Data-Log-Ped) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Insert-Data-Log-Ped Procedure 
PROCEDURE Insert-Data-Log-Ped :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE logmovdisp.
    ASSIGN
        logmovdisp.codalm = B-FacCPedi.codalm
        logmovdisp.coddoc = B-FacDPedi.coddoc 
        logmovdisp.codmat = B-FacDPedi.codmat
        logmovdisp.fechareg = TODAY
        logmovdisp.flgest = "P"
        logmovdisp.horareg = STRING(TIME,'HH:MM:SS')
        logmovdisp.nrodoc = B-FacDPedi.nroped
        logmovdisp.origen = "RIQRA-HORIZONTAL"
        .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Insert-Data-Log-RAN) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Insert-Data-Log-RAN Procedure 
PROCEDURE Insert-Data-Log-RAN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE logmovdisp.
    ASSIGN
        logmovdisp.codalm = B-DREPO.codalm
        logmovdisp.coddoc = B-DREPO.tipmov
        logmovdisp.codmat = B-DREPO.codmat
        logmovdisp.fechareg = TODAY
        logmovdisp.flgest = "P"
        logmovdisp.horareg = STRING(TIME,'HH:MM:SS')
        logmovdisp.nrodoc = STRING(B-DREPO.nroser, '999') + STRING(B-DREPO.nrodoc)
        logmovdisp.origen = "RIQRA-HORIZONTAL"
        .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

