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
DEF INPUT PARAMETER pLlave AS CHAR NO-UNDO.
DEF INPUT PARAMETER pCanDesNew AS DECI NO-UNDO.
DEF INPUT PARAMETER pCanDesOld AS DECI NO-UNDO.
DEF INPUT PARAMETER pEvento AS CHAR NO-UNDO.    /* W: WRITE    D: DELETE */

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
DEFIN VAR x-Factor AS INTE INIT 0 NO-UNDO.

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
DEF VAR cCodDoc AS CHAR NO-UNDO.
DEF VAR cNroPed AS CHAR NO-UNDO.
DEF VAR cCodMat AS CHAR NO-UNDO.
DEF VAR cCodAlm AS CHAR NO-UNDO.
DEF VAR cTipMov AS CHAR NO-UNDO.
DEF VAR cNroSer AS INTE NO-UNDO.
DEF VAR cNroDoc AS INTE NO-UNDO.
DEF VAR cAlmPed AS CHAR NO-UNDO.
DEF VAR cCodMov AS INTE NO-UNDO.

CASE pTabla:
    WHEN "FacDPedi" THEN DO:
        ASSIGN
            cCodDoc = ENTRY(1,pLlave,":")
            cNroPed = ENTRY(2,pLlave,":")
            cCodMat = ENTRY(3,pLlave,":")
            cCodAlm = ENTRY(4,pLlave,":")
            .
        /* Filtro de documentos */
        DEF VAR cDocumentos AS CHAR INIT "PED" NO-UNDO.
        IF LOOKUP(cCodDoc, cDocumentos) = 0  THEN RETURN.        

        CASE cCodDoc:
            WHEN "PED" THEN DO:
                /* Solo afecta almacenes relacionados con RIQRA */
                FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
                    B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
                    CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                             B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND 
                             B-VtaAlmDiv.codalm = cCodAlm NO-LOCK)    /* OJO */
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE B-FacTabla THEN RETURN.

                x-Factor = -1.  /* Valor por Defecto */
                /* DELETE */
                IF pEvento = "D" THEN x-Factor = 1.
                RUN Insert-Data-Log (cCodAlm,
                                     cCodDoc,
                                     cNroPed,
                                     cCodMat,
                                     x-Factor * ( pCanDesNew - pCanDesOld )
                                     ).
            END.
        END CASE.
    END.
    WHEN "Almdrepo" THEN DO:
        /* Estados Válidos */
        DEF VAR x-TipMov AS CHAR INIT 'A,M,RAN,INC' NO-UNDO.

        ASSIGN
            cCodAlm = ENTRY(1,pLlave,":")
            cTipMov = ENTRY(2,pLlave,":")
            cNroSer = INTEGER(ENTRY(3,pLlave,":"))
            cNroDoc = INTEGER(ENTRY(4,pLlave,":"))
            cCodMat = ENTRY(5,pLlave,":")
            cAlmPed = ENTRY(6,pLlave,":")
            .
        IF LOOKUP(cTipMov, x-TipMov) = 0 THEN RETURN.

        /* Verificamos que sea una división válida */
        FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
            B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
            CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                     B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND
                     B-VtaAlmDiv.codalm = cAlmPed NO-LOCK)    /* OJO */
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacTabla THEN RETURN.

        x-Factor = -1.  /* Valor por Defecto */
        /* DELETE */
        IF pEvento = "D" THEN x-Factor = 1.
        RUN Insert-Data-Log (cAlmPed,
                             cTipMov,
                             cCodAlm + "-" + STRING(cNroSer,'999') + "-" + STRING(cNroDoc),
                             cCodMat,
                             x-Factor * ( pCanDesNew - pCanDesOld )
                             ).
    END.
    WHEN "Almdmov" THEN DO:
        /* Solo movimientos válidos */
        ASSIGN
            cCodAlm = ENTRY(1,pLlave,":")
            cTipMov = ENTRY(2,pLlave,":")
            cCodMov = INTEGER(ENTRY(3,pLlave,":"))
            cNroSer = INTEGER(ENTRY(4,pLlave,":"))
            cNroDoc = INTEGER(ENTRY(5,pLlave,":"))
            cCodMat = ENTRY(6,pLlave,":")
            .

        IF cTipMov = "S" AND cCodMov = 03 THEN RETURN.
        IF cTipMov = "S" AND cCodMov = 02 THEN RETURN.

        /* Verificamos que sea una división válida */
        FIND FIRST B-FacTabla WHERE B-FacTabla.codcia = s-codcia AND
            B-FacTabla.Tabla = "CFG_VTAHOR_RIQRA" AND
            CAN-FIND(FIRST B-VtaAlmDiv WHERE B-VtaAlmDiv.codcia = s-codcia AND
                     B-VtaAlmDiv.coddiv = B-FacTabla.Codigo AND
                     B-VtaAlmDiv.codalm = cCodAlm NO-LOCK)    /* OJO */
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacTabla THEN RETURN.
        
        x-Factor = -1.  /* Valor por Defecto */
        IF cTipMov = "I" THEN x-Factor = 1.
        IF cTipMov = "S" THEN x-Factor = -1.

        /* DELETE */
        IF pEvento = "D" THEN x-Factor = -1 * x-Factor.
        
        RUN Insert-Data-Log (cCodAlm,
                             cTipMov + STRING(cCodMov,'99'),
                             STRING(cNroSer,'999') + "-" + STRING(cNroDoc),
                             cCodMat,
                             x-Factor * ( pCanDesNew - pCanDesOld )
                             ).
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
    DEF INPUT PARAMETER pCanDes AS DECI.

    IF pCanDes = 0 THEN RETURN.

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
        logmovdisp.cantidad = pCanDes
        .
    CASE pEvento:
        WHEN "W" THEN logmovdisp.detonante = "WRITE".
        WHEN "D" THEN logmovdisp.detonante = "DELETE".
    END CASE.
    /* Ejecutammos el API */
    DEF VAR pMensaje AS CHAR NO-UNDO.
    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN web/web-library.p PERSISTENT SET hProc.

    RUN web_api-riqra-stock-disponible IN hProc (pCodAlm, pCodMat, pCanDes, OUTPUT pMensaje).

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
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCantidad AS DECI.

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
        logmovdisp.cantidad = pCantidad
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

