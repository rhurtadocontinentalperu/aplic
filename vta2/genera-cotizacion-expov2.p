&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE VtaDDocu.
DEFINE TEMP-TABLE ITEM-1 NO-UNDO LIKE VtaDDocu.



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

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF OUTPUT PARAMETER pNroPed AS CHAR.

DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEF VAR s-coddoc AS CHAR INIT "COT" NO-UNDO.
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR s-tpoped AS CHAR NO-UNDO.
DEF VAR s-codmon LIKE faccpedi.codmon NO-UNDO.
DEF VAR s-nrodec AS INT NO-UNDO.
DEF VAR s-tpocmb AS DEC NO-UNDO.
DEF VAR s-porigv AS DEC NO-UNDO.

DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.       /* DESCUENTO EXPOLIBRERIA */
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.

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
      TABLE: ITEM T "?" NO-UNDO INTEGRAL VtaDDocu
      TABLE: ITEM-1 T "?" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Primero solicitamos el EXCEL de productos propios */
DEF VAR cCarpeta AS CHAR NO-UNDO.

/* Ic 24Nov2015
/* 1ro. veamos si se ha definido la variable ExpoExcel */
GET-KEY-VALUE SECTION "Startup" KEY "" VALUE cCarpeta.
IF LOOKUP("ExpoExcel", cCarpeta) > 0 THEN DO:
    /* 2do. capturamos la carpeta donde están guardados los excel */
    GET-KEY-VALUE SECTION "Startup" KEY "ExpoExcel" VALUE cCarpeta.
END.
DEF VAR cArchivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKselected AS LOGICAL NO-UNDO.
DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
SYSTEM-DIALOG GET-FILE cArchivo
    FILTERS "*.xls,*.xlsx" "*.xls,*.xlsx"
    INITIAL-DIR cCarpeta
    MUST-EXIST 
    TITLE "SELECCIONE EN EXCEL DE PEDIDO A IMPORTAR"
    UPDATE OKselected.
IF OKselected = NO THEN DO:
    MESSAGE "No ha seleccionado ningún archivo EXCEL" SKIP
        "Continuamos con la generación de la Cotización?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE OKpressed.
    IF OKPressed = NO THEN RETURN "ADM-ERROR".
END.
Ic 24Nov2015 */


EMPTY TEMP-TABLE ITEM.
EMPTY TEMP-TABLE ITEM-1.
DEFINE VARIABLE I-NroItm AS INTEGER INIT 1 NO-UNDO.
/* Ic 24Nov2015
IF OKSelected THEN DO:  /* Cargamos el Excel */
     RUN Importar-Excel-Pedidos (cArchivo).
END.
 Ic 24Nov2015 */


PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Cargamos Digitados */
    I-NroItm = 1.
    FOR EACH ITEM:
        I-NroItm = I-NroItm + 1.
        ASSIGN
            ITEM.CodCia = Vtacdocu.codcia
            ITEM.CodDiv = Vtacdocu.coddiv
            ITEM.CodPed = Vtacdocu.codped
            ITEM.NroPed = Vtacdocu.nroped
            ITEM.FchPed = Vtacdocu.fchped.
    END.
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

    {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}

    CREATE Faccpedi.
    BUFFER-COPY Vtacdocu TO Faccpedi
        ASSIGN 
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = VtaCDocu.Libre_c02
        FacCPedi.Atencion = VtaCDocu.DniCli.
    ASSIGN
        pNroPed = FacCPedi.NroPed
        s-TpoPed = FacCPedi.TpoPed
        s-CodMon = FacCPedi.CodMon
        s-NroDec = FacCPedi.Libre_d01
        s-TpoCmb = FacCPedi.TpoCmb
        s-PorIgv = FacCPedi.PorIgv
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN 
       FacCPedi.Hora = STRING(TIME,"HH:MM")
       FacCPedi.Usuario = S-USER-ID.
    FOR EACH ITEM NO-LOCK, FIRST Almmmatg OF ITEM NO-LOCK
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
        RUN vta2/PrecioListaxMayorCredito (
            Faccpedi.TpoPed,
            pCodDiv,
            Faccpedi.CodCli,
            Faccpedi.CodMon,
            INPUT-OUTPUT s-UndVta,
            OUTPUT f-Factor,
            Facdpedi.CodMat,
            Faccpedi.fmapgo,
            Facdpedi.CanPed,
            4,
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT f-Dsctos,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            "",
            FALSE
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE 'Precio NO definido para el artículo' Facdpedi.codmat SKIP
                'Proceso abortado'
                VIEW-AS ALERT-BOX ERROR.
            DELETE Facdpedi.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.

        ASSIGN
            Facdpedi.UndVta = s-UndVta
            Facdpedi.Factor = f-Factor
            Facdpedi.PorDto = f-Dsctos
            Facdpedi.PorDto2 = 0
            Facdpedi.PreUni = f-PreVta
            Facdpedi.PreBas = f-PreBas
            Facdpedi.Por_Dsctos[1] = 0
            Facdpedi.Por_DSCTOS[2] = z-Dsctos
            Facdpedi.Por_Dsctos[3] = Y-DSCTOS
            Facdpedi.Libre_c04 = X-TIPDTO.
        ASSIGN
            Facdpedi.ImpLin = Facdpedi.CanPed * Facdpedi.PreUni * 
                          ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                          ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                          ( 1 - Facdpedi.Por_Dsctos[3] / 100 ).
        IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
            THEN Facdpedi.ImpDto = 0.
            ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
        ASSIGN
            Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
            Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
        ASSIGN 
            Facdpedi.AftIgv = Almmmatg.AftIgv
            Facdpedi.AftIsc = Almmmatg.AftIsc.
        IF Facdpedi.AftIsc THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
        IF Facdpedi.AftIgv THEN  Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (FacCPedi.PorIgv / 100)),4).
    END.

    /* RHC 07/11/2013 DESCUENTOS ESPECIALES POR VOLUMEN DE VENTAS */
    RUN Descuentos-Finales-01.
    RUN Descuentos-Finales-02.
    /* ********************************************************** */
    /* RHC DESCUENTOS ESPECIALES SOLO CAMPAÑA */
    RUN Descuentos-solo-campana.

    {vta2/graba-totales-cotizacion-cred.i}

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
    /* ******************** */
END.

/* Procedemos a copiar el excel */
DEF VAR cDestino AS CHAR NO-UNDO.
DEF VAR cComando AS CHAR NO-UNDO.

/*  Ic - 24Nov2015
IF OKSelected THEN DO:
    GET-KEY-VALUE SECTION "Startup" KEY "" VALUE cDestino.
    IF LOOKUP("ExpoPreCot", cDestino) > 0 THEN DO:
        /* 2do. capturamos la carpeta donde están guardados los excel */
        GET-KEY-VALUE SECTION "Startup" KEY "ExpoPreCot" VALUE cDestino.
    END.
    ELSE cDestino = cCarpeta.
    cDestino = TRIM(cDestino).
    IF R-INDEX(cDestino,'\') <> LENGTH(cDestino)  THEN cDestino = cDestino + '\'.
    cDestino = cDestino + TRIM(CAPS(Faccpedi.coddoc)) + TRIM(CAPS(Faccpedi.nroped)) +
        SUBSTRING(cArchivo, R-INDEX(cArchivo, '.xl')).
    cComando = "copy " + cArchivo + ' ' + TRIM(cDestino).
    OS-COMMAND 
        SILENT 
        VALUE(cComando).
    OS-DELETE VALUE(cArchivo).
END.
 Ic - 24Nov2015 */
  
RELEASE Vtacdocu.
RELEASE FacCorre.
RELEASE Faccpedi.
RELEASE Facdpedi.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Descuentos-Finales-01) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-01 Procedure 
PROCEDURE Descuentos-Finales-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxlinearesumida.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Descuentos-Finales-02) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-02 Procedure 
PROCEDURE Descuentos-Finales-02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxsaldosresumida.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Descuentos-solo-campana) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-solo-campana Procedure 
PROCEDURE Descuentos-solo-campana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuento-solo-campana.i}

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

