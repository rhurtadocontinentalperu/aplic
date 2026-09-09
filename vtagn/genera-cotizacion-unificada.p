&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE BONIFICACION LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-1 NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Generar cotizaciones

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/
&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorCredito.p

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF OUTPUT PARAMETER pNroPed AS CHAR.

DEFINE VAR s-user-id AS CHAR INIT 'VTA-15'.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR cl-codcia AS INT.

DEFINE VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

/* Por Lista de Precios */
CASE pCodDiv:
    WHEN '10072' THEN s-user-id = 'VTA-172'.
    WHEN '20067' OR WHEN '10067' THEN s-user-id = 'VTA-167'.
    WHEN '10060' OR WHEN '20060' THEN s-user-id = 'VTA-160'.
END CASE.
/* Por Lista de Precios y División */
CASE TRUE:
    WHEN pCodDiv = "10000" THEN DO:
        CASE s-CodDiv.
            WHEN "10011" THEN s-user-id = "VTA-111".
            WHEN "10031" THEN s-user-id = "VTA-131".
            WHEN "10032" THEN s-user-id = "VTA-132".
            WHEN "10038" THEN s-user-id = "VTA-138".
            WHEN "10039" THEN s-user-id = "VTA-139".
            WHEN "10041" THEN s-user-id = "VTA-141".
        END CASE.
    END.
END CASE.

DEF VAR s-coddoc AS CHAR INIT "COT" NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR s-tpoped AS CHAR NO-UNDO.
DEF VAR s-codmon LIKE faccpedi.codmon NO-UNDO.
DEF VAR s-nrodec AS INT NO-UNDO.
DEF VAR s-tpocmb AS DEC NO-UNDO.
DEF VAR s-porigv AS DEC NO-UNDO.
DEF VAR s-FmaPgo AS CHAR NO-UNDO.

FIND Vtacdocu WHERE ROWID(Vtacdocu) = pRowid NO-LOCK NO-ERROR.

IF NOT AVAILABLE Vtacdocu THEN DO:
    MESSAGE 'No se encontró la pre-cotización' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

FIND FIRST FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = s-coddoc
    AND  FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO está configurado el correlativo para el doc.' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-NroSer = FacCorre.NroSer.

DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

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
      TABLE: BONIFICACION T "?" ? INTEGRAL FacDPedi
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-1 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDI T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR s-Import-IBC AS LOG INIT NO NO-UNDO.
DEF VAR s-Import-B2B AS LOG INIT NO NO-UNDO.
DEF VAR s-Import-Cissac AS LOG INIT NO NO-UNDO.
DEF VAR s-CodCli AS CHAR NO-UNDO.
DEF VAR s-CndVta AS CHAR NO-UNDO.
DEF VAR s-Cmpbnte AS CHAR NO-UNDO. 

ASSIGN
    s-CodCli = Vtacdocu.codcli
    s-CndVta = Vtacdocu.fmapgo
    s-Cmpbnte = Vtacdocu.cmpbnte.

EMPTY TEMP-TABLE ITEM.
EMPTY TEMP-TABLE ITEM-1.
EMPTY TEMP-TABLE PEDI.

DEFINE VARIABLE I-NroItm AS INTEGER INIT 1 NO-UNDO.
DEFINE VARIABLE pMensaje AS CHAR NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Cargamos Digitados */
    I-NroItm = 1.
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
        FIND FIRST ITEM WHERE ITEM.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE ITEM THEN NEXT.
        CREATE ITEM.
        BUFFER-COPY Vtaddocu TO ITEM ASSIGN ITEM.NroItm = I-NroItm.
        I-NroItm = I-NroItm + 1.
    END.
    
    FIND CURRENT Vtacdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        MESSAGE "No se pudo bloquear la pre-cotización" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

    CREATE Faccpedi.
    BUFFER-COPY Vtacdocu 
        EXCEPT VtaCDocu.Libre_C02 VtaCDocu.Libre_C03 Vtacdocu.Libre_c05
        TO Faccpedi
        ASSIGN 
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = VtaCDocu.Libre_c02
        FacCPedi.Atencion = VtaCDocu.DniCli
        FacCPedi.FlgEst = "P"     /* APROBADO */
        FacCPedi.Libre_C02 = VtaCDocu.Libre_C03.    /* Última atención */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN
        pNroPed  = FacCPedi.NroPed
        s-TpoPed = FacCPedi.TpoPed
        s-CodMon = FacCPedi.CodMon
        s-NroDec = FacCPedi.Libre_d01
        s-TpoCmb = FacCPedi.TpoCmb
        s-PorIgv = FacCPedi.PorIgv
        s-FmaPgo = FacCPedi.FmaPgo.
    ASSIGN 
        FacCPedi.Hora = STRING(TIME,"HH:MM:SS")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.Libre_c01 = VtaCDocu.Libre_c01.    /* Lista de Precios */
    /* Recalculamos Precios de Venta */
    /*{vta2/recalcular-expo-v1.i}*/
    {vtagn/recalcular-cotizacion-unificada.i &pTpoPed=s-TpoPed}
    /* Generamos Detalle */
    FOR EACH ITEM NO-LOCK, 
        FIRST Almmmatg OF ITEM NO-LOCK
        BY ITEM.NroItm:
        CREATE Facdpedi.
        BUFFER-COPY ITEM TO Facdpedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst.
    END.

    /* ************************************************************************************** */
    /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
    /* ************************************************************************************** */
    RUN DESCUENTOS-FINALES (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************************************** */
    /* RHC 02/01/2020 Promociones proyectadas */
    /* ************************************************************************************** */
    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
    EMPTY TEMP-TABLE ITEM.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        CREATE ITEM.
        BUFFER-COPY Facdpedi TO ITEM.
    END.
    RUN vtagn/p-promocion-general (INPUT Faccpedi.CodDiv,
                                   INPUT Faccpedi.CodDoc,
                                   INPUT Faccpedi.NroPed,
                                   INPUT TABLE ITEM,
                                   OUTPUT TABLE BONIFICACION,
                                   OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

    I-NITEM = 0.
    FOR EACH BONIFICACION,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND 
        Almmmatg.codmat = BONIFICACION.codmat
        BY BONIFICACION.NroItm:
        I-NITEM = I-NITEM + 1.
        CREATE FacDPedi.
        BUFFER-COPY BONIFICACION
            TO FacDPedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = "CBO"   /* Bonificacion en COT */
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst
                FacDPedi.NroItm = I-NITEM.
    END.
    /* ****************************************************************************************** */
    {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ****************************************************************************************** */
    /* Renumeramos items */
    I-NroItm = 1.
    FOR EACH Facdpedi OF Faccpedi BY Facdpedi.nroitm:
        ASSIGN
            Facdpedi.NroItm = I-NroItm.
        I-NroItm = I-NroItm + 1.
    END.
    /* Referencias cruzadas */
    ASSIGN
        VtaCDocu.CodRef = FacCPedi.CodDoc
        VtaCDocu.NroRef = FacCPedi.NroPed
        FacCPedi.CodRef = VtaCDocu.CodPed
        FacCPedi.NroRef = VtaCDocu.NroPed
        Vtacdocu.FlgSit = "T".
END.

RELEASE Vtacdocu.
RELEASE FacCorre.
RELEASE Faccpedi.
RELEASE Facdpedi.

RETURN "OK".


{vtagn/i-cotizacion-general-v01.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-DESCUENTOS-FINALES) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DESCUENTOS-FINALES Procedure 
PROCEDURE DESCUENTOS-FINALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.
  RUN DCTO_VOL_LINEA IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO_EVENTO IN hProc (INPUT ROWID(Faccpedi),
                                      INPUT s-TpoPed,
                                      INPUT pCodDiv,
                                      OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Importar-Excel-Pedidos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel-Pedidos Procedure 
PROCEDURE Importar-Excel-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* DEFINE VARIABLE pArchivo AS CHAR NO-UNDO. */
/* DEFINE VARIABLE OKpressed AS LOG NO-UNDO.        */
/* DEFINE VARIABLE pMensaje AS CHAR NO-UNDO.        */
DEFINE INPUT PARAMETER pArchivo AS CHAR.

DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE k               AS INTEGER NO-UNDO.
DEFINE VARIABLE j               AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NroItm        AS INTEGER NO-UNDO.

/* SYSTEM-DIALOG GET-FILE pArchivo                                          */
/*     FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*" */
/*     TITLE "IMPORTAR EXCEL DE PEDIDOS"                                           */
/*     MUST-EXIST                                                                  */
/*     USE-FILENAME                                                                */
/*     UPDATE OKpressed.                                                           */
/* IF OKpressed = FALSE THEN RETURN.                                               */

/* CREAMOS LA HOJA EXCEL */
CREATE "Excel.Application" chExcelApplication.
chWorkbook  = chExcelApplication:Workbooks:OPEN(pArchivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).    /* HOJA 1 */

SESSION:SET-WAIT-STATE('GENERAL').
/*pMensaje = ''.*/

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */
cValue = chWorkSheet:Cells(1,1):VALUE.

/* *************************************************************************** */
/* ************************ PRIMERA HOJA LINEA 010 *************************** */
/* *************************************************************************** */
DEF VAR x-canped AS DEC NO-UNDO.
DEF VAR x-CodMat AS CHAR NO-UNDO.
   

ASSIGN
    I-NroItm = 1
    /*pMensaje = ""*/
    t-Column = 0
    t-Row = 4.     /* Saltamos el encabezado de los campos */
DO j = 1 TO 3:      /* HOJAS */
    chWorkSheet = chExcelApplication:Sheets:ITEM(j).    /* HOJA */
    DO t-Row = 8 TO 410:    /* FILAS */
        DO t-column = 5 TO 12:   /* COLUMNAS */
            ASSIGN
                x-canped = DECIMAL(chWorkSheet:Cells(t-Row, t-Column):VALUE)
                x-CodMat = STRING(INTEGER(chWorkSheet:Cells(t-Row, t-Column + 8):VALUE), '999999')
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN NEXT.
            IF x-CodMat = "" OR x-CodMat = ? OR x-canped = 0 OR x-canped = ? THEN NEXT.
            FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmatg THEN NEXT.
    
            CREATE ITEM-1.
            ASSIGN
                ITEM-1.nroitm = I-NroItm + ( (t-Column - 5) * 100000 )
                ITEM-1.codcia = s-codcia
                ITEM-1.codmat = x-codmat
                ITEM-1.canped = x-canped.
        END.
        I-NroItm = I-NroItm + 1.
    END.
END.
i-NroItm = 1.
FOR EACH ITEM-1 BY ITEM-1.NroItm:
    CREATE ITEM.
    BUFFER-COPY ITEM-1 TO ITEM ASSIGN ITEM.NroItm = i-NroItm.
    i-NroItm = i-NroItm + 1.
END.
/* CERRAMOS EL EXCEL */
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 
SESSION:SET-WAIT-STATE('').

/* EN CASO DE ERROR */
/* IF pMensaje <> "" THEN DO:                    */
/*     MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR. */
/* END.                                          */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

