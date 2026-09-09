&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE pt-Facdpedi NO-UNDO LIKE FacDPedi.



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
/* Sintaxis 
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.
RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .
DELETE PROCEDURE hProc.
*/

/* ***************************  Definitions  ************************** */

DEFINE SHARED VAR s-codcia AS INT. 
DEFINE SHARED VAR cl-codcia AS INT. 
DEFINE SHARED VAR pv-codcia AS INTE. 
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-coddiv AS CHAR.   
DEFINE SHARED VAR s-user-id AS CHAR.

/* Se va usar como parametro en la impresion de rotulos */
DEFINE TEMP-TABLE ttitems-pickeados NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE xtitems-pickeados NO-UNDO LIKE w-report.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.
DEFINE VAR x-coddiv AS CHAR.

DEFINE VAR x-el-chequeador AS CHAR.     /* Si programa es invocado en el proceso de checking y aun no cierra la orden */

DEFINE TEMP-TABLE rr-w-report NO-UNDO LIKE w-report.

DEFINE BUFFER x-vtaddocu FOR vtaddocu.
DEFINE BUFFER x-vtacdocu FOR vtacdocu.
DEFINE BUFFER x-faccpedi FOR faccpedi.

DEFINE BUFFER od-faccpedi FOR faccpedi.
DEFINE BUFFER ped-faccpedi FOR faccpedi.
DEFINE BUFFER x-ccbAdocu FOR ccbAdocu.

DEF STREAM REPORTE.

{src/bin/_prns.i}
DEFINE VAR s-task-no AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/vta2/rbvta2.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.

RB-REPORT-LIBRARY = s-report-library + "vta2\rbvta2.prl".

DEFINE VAR x-origen AS CHAR.
DEFINE VAR x-bulto AS CHAR.
DEFINE VAR x-qbulto AS INT.

DEF TEMP-TABLE pt-Resumen-HPK
    FIELD CodCia LIKE Facdpedi.CodCia
    FIELD Tipo   LIKE VtaDTabla.Tipo
    FIELD CodDoc LIKE Facdpedi.CodDoc
    FIELD NroPed LIKE Facdpedi.NroPed
    FIELD AlmDes LIKE Facdpedi.AlmDes
    FIELD CodMat LIKE Facdpedi.CodMat
    FIELD CanPed LIKE Facdpedi.CanPed
    FIELD Factor LIKE Facdpedi.Factor
    FIELD UndVta LIKE Facdpedi.UndVta
    FIELD ImpLin LIKE Facdpedi.ImpLin
    FIELD Sector AS CHAR
    FIELD Caso LIKE LogisConsolidaHpk.Caso
    .

DEF BUFFER pt-Resumen-HPK-2 FOR pt-Resumen-HPK.

DEFINE VAR cPrinterName AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fChequeador) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fChequeador Procedure 
FUNCTION fChequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fpeso-orden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fpeso-orden Procedure 
FUNCTION fpeso-orden RETURNS DECIMAL
  ( INPUT pCodOrden AS CHAR, INPUT pNroOrden AS CHAR, 
    INPUT pCodHPK AS CHAR, INPUT pNroPHK AS CHAR,
    INPUT pCodBulto AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lugar-entrega) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lugar-entrega Procedure 
FUNCTION lugar-entrega RETURNS CHARACTER
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: pt-Facdpedi T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 18.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Estado-Logistico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Estado-Logistico Procedure 
PROCEDURE Estado-Logistico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.    /* HPK */
DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF INPUT PARAMETER pFlgSit AS CHAR.
DEF INPUT PARAMETER pValor AS CHAR. /* "E": estado  "S: situación */
DEF OUTPUT PARAMETER pRetorno AS CHAR NO-UNDO.

pRetorno = ''.
CASE pValor:
    WHEN "S" THEN DO:
        pRetorno = pFlgSit.
        CASE pFlgEst:
            WHEN "P" THEN DO:
                IF pFlgSit = "C" THEN pRetorno = "EN DISTRIBUCION".
                IF pFlgSit = "PC" THEN pRetorno = "CHEQUEADO".
                IF pFlgSit = "TX" THEN pRetorno = "PICKING OBSERVADO".
                IF pFlgSit = "TI" THEN pRetorno = "PICKING ASIGNADO".
                IF pFlgSit = "PE" THEN pRetorno = "EMBALADO ESPECIAL".
                IF pFlgSit = "P" THEN pRetorno = "PICKING COMPLETO".
                IF pFlgSit = "PO" THEN pRetorno = "CHECKING OBSERVADO".
                IF pFlgSit = "PT" THEN pRetorno = "CHEQUEO INICIADO".
                IF pFlgSit = "T" THEN pRetorno = "SIN EMPEZAR".
                IF pFlgSit = "TP" THEN pRetorno = "PICKING INICIADO".
            END.
        END CASE.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ffFlgSitPedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ffFlgSitPedido Procedure 
PROCEDURE ffFlgSitPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodPed AS CHAR.
DEF INPUT PARAMETER pFlgSit AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.

  pEstado = "".
  CASE pCodPed:
      WHEN "O/D" OR WHEN "OTR" OR WHEN "O/M" THEN DO:
          FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND
              FacTabla.Tabla = 'CFG_FLGSIT_LOG' AND
              FacTabla.Codigo = pFlgSit NO-LOCK NO-ERROR.
          IF AVAILABLE FacTabla THEN pEstado = FacTabla.Nombre.
      END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulos Procedure 
PROCEDURE imprimir-rotulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pxCodDiv AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pxCodDoc AS CHAR NO-UNDO.     /* HPK */
DEFINE INPUT PARAMETER pxNroDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttitems-pickeados.
DEFINE INPUT PARAMETER pxSource AS CHAR NO-UNDO.    
/* pxSource - De donde fue invocado :
    CHEQUEO, 
    ORDENES TERMINADAS, 
    ROTULOS BCP ZEBRA,
    ROTULOS MI BANCO ZEBRA,
    ROTULOS BCP, 
    ROTULOS MI BANCO,
    ROTULOS DESPACHO
    SECTORES CIERREBULTO                |######         ######:codigo de bulto
    SECTORES CIERREORDEN
    SECTORES ORDEN
*/
    
x-coddoc = UPPER(pxCodDoc).
x-nrodoc = UPPER(pxNroDoc).
x-coddiv = UPPER(pxCodDiv).  
x-origen = UPPER(pxSource).

x-qbulto = 0.

IF pxSource BEGINS "SECTORES" THEN DO:

    IF NUM-ENTRIES(x-origen,"|") > 1 THEN DO:
        x-origen = ENTRY(1,pxSource,"|").
        x-bulto = ENTRY(2,pxSource,"|").
    END.
    /*
    IF NUM-ENTRIES(x-origen,"|") > 2 THEN DO:
        x-qbulto = INTEGER(ENTRY(3,pxSource,"|")) NO-ERROR.
    END.
    IF x-qbulto = ? THEN x-qbulto = 0.
    */
    /* Rotulos picking sectores */
    RUN rotulos-sectores.

    RETURN.
END.

DEFINE VAR x-coddoc-nrodoc AS CHAR.

FIND FIRST chktareas WHERE chktareas.codcia = s-codcia AND
                        chktareas.coddiv = x-coddiv AND
                        chktareas.coddoc = x-coddoc AND
                        chktareas.nroped = x-nrodoc NO-LOCK NO-ERROR.                           

IF NOT AVAILABLE chktareas THEN DO:
  RETURN.
END.

x-coddoc-nrodoc = chktareas.coddoc + "-" + chktareas.nroped.

DEFINE VAR dPeso        AS DECIMAL   NO-UNDO.
DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
DEFINE VAR cDir         AS CHARACTER NO-UNDO.
DEFINE VAR cSede        AS CHARACTER NO-UNDO.
DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

DEFINE VAR lCodRef AS CHAR.
DEFINE VAR lNroRef AS CHAR.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

DEFINE VAR lCodRef2 AS CHAR.
DEFINE VAR lNroRef2 AS CHAR.

DEFINE VAR x-almfinal AS CHAR.
DEFINE VAR x-cliente-final AS CHAR.
DEFINE VAR x-cliente-intermedio AS CHAR.
DEFINE VAR x-direccion-final AS CHAR.
DEFINE VAR x-direccion-intermedio AS CHAR.
DEFINE VAR lFiler1 AS CHAR.

DEFINE BUFFER x-almacen FOR almacen.
DEFINE BUFFER x-pedido FOR faccpedi.
DEFINE BUFFER x-cotizacion FOR faccpedi.
DEFINE BUFFER hpk-vtacdocu FOR vtacdocu.

EMPTY TEMP-TABLE rr-w-report.

/* BCP */
FIND FIRST ttitems-pickeados NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttitems-pickeados THEN RETURN.

IF pxSource BEGINS "ROTULOS BCP" THEN DO:
    RUN imprimir-rotulos-bcp.
    RETURN.
END.
IF pxSource BEGINS "ROTULOS MI BANCO" THEN DO:
    RUN imprimir-rotulos-mi-banco.
    RETURN.
END.

DEFINE VAR i-nro AS INT.

DEFINE VAR x-total-bultos-orden AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

/*  */
FIND FIRST hpk-vtacdocu WHERE hpk-vtacdocu.codcia = s-codcia AND
                                    hpk-vtacdocu.codped = chktareas.coddoc AND
                                    hpk-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.

/* Total bultos  */
/*x-total-bultos-orden = cantidad-bultos(chktareas.coddoc, chktareas.nroped).*/

DEFINE VAR x-es-correcto AS LOG.

FOR EACH ttitems-pickeados WHERE ttitems-pickeados.campo-l[1] = YES 
            BREAK BY ttitems-pickeados.campo-c[1] BY ttitems-pickeados.campo-c[2]:

    IF FIRST-OF(ttitems-pickeados.campo-c[1]) OR FIRST-OF(ttitems-pickeados.campo-c[2]) THEN DO:
        
        x-total-bultos-orden = 0.
        i-nro = 0.
        
        FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND
                                    controlOD.coddoc = ttitems-pickeados.campo-c[1] AND
                                    controlOD.nrodoc = ttitems-pickeados.campo-c[2] NO-LOCK:
            x-es-correcto = YES.
            IF chktareas.coddoc = 'HPK' THEN DO:
                x-es-correcto = NO. 
                IF controlOD.nroetq BEGINS x-coddoc-nrodoc THEN x-es-correcto = YES.
            END.
            IF x-es-correcto = YES THEN x-total-bultos-orden = x-total-bultos-orden + 1.
        END.
        /*IF x-total-bultos-orden = 0 THEN NEXT. */     /* ojooooo */
    END.

    x-el-chequeador = ttitems-pickeados.campo-c[30].        /* Si no esta vacio es que viene del checking en linea */
    IF TRUE <> (x-el-chequeador > "") THEN x-el-chequeador = "".

    /* Ubico la orden */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = ttitems-pickeados.campo-c[1]
        AND faccpedi.nroped = ttitems-pickeados.campo-c[2]
        NO-LOCK NO-ERROR.

    /*IF NOT AVAILABLE tt-w-report THEN NEXT.*/
    IF NOT AVAILABLE faccpedi THEN NEXT.

    cNomCHq = "".
    lCodDoc = "".
    lNroDoc = "".
    dPeso = 0.      /**ControlOD.PesArt.*/
    lCodRef2 = ttitems-pickeados.campo-c[1].
    lNroRef2 = ttitems-pickeados.campo-c[2].

    x-cliente-final = faccpedi.nomcli.
    x-direccion-final = faccpedi.dircli.
    x-cliente-intermedio = "".
    x-direccion-intermedio = "".

    /* CrossDocking almacen FINAL */
    x-almfinal = "".
    IF faccpedi.crossdocking = YES THEN DO:
        lCodRef2 = faccpedi.codref.
        lNroRef2 = faccpedi.nroref.
        lCodDoc = "(" + faccpedi.coddoc.
        lNroDoc = faccpedi.nroped + ")".

        x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
        x-direccion-intermedio = faccpedi.dircli.

        IF faccpedi.codref = 'R/A' THEN DO:
            FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                        x-almacen.codalm = faccpedi.almacenxD
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion).
            IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm).
        END.
    END.
    /* RHC 15/06/2020 */
    RUN logis/p-lugar-de-entrega.r (Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-Cliente-Intermedio).


    /* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
    /* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
    /* Crossdocking */
    IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
        lCodDoc = "(" + ttitems-pickeados.campo-c[1].
        lNroDoc = ttitems-pickeados.campo-c[2] + ")".
        lCodRef = faccpedi.codref.
        lNroRef = faccpedi.nroref.
        RELEASE faccpedi.

        FIND faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.coddoc = lCodRef
            AND faccpedi.nroped = lNroRef
            NO-LOCK NO-ERROR.
        IF NOT AVAIL faccpedi THEN DO:
            MESSAGE "Pedido de Referencia de la OTR no existe" lCodRef lNroRef
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "ADM-ERROR".
        END.
        x-cliente-final = "".
        IF faccpedi.CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
        x-cliente-final = x-cliente-final + faccpedi.nomcli.
        x-direccion-final = faccpedi.dircli.
    END.
    /* ************************************************************************* */
    /* RHC 15/06/2020 */
    /* Direccion de entrega */
    /* ************************************************************************* */
    IF AVAILABLE Faccpedi THEN DO:
        FIND gn-clied WHERE Gn-ClieD.CodCia = cl-codcia AND
            Gn-ClieD.CodCli = Faccpedi.codcli AND 
            Gn-ClieD.Sede = Faccpedi.sede NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN DO:
            x-direccion-final = Gn-ClieD.DirCli .
            IF NUM-ENTRIES(Gn-ClieD.DirCli, '|') > 1 THEN
                x-direccion-final = ENTRY(2,Gn-ClieD.DirCli,'|').
        END.
    END.
    /* ************************************************************************* */
    /* ************************************************************************* */
    /* Ic - 02Dic2016 - FIN */
    /* Datos Sede de Venta */
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.  /*faccpedi.coddiv*/
    IF AVAIL gn-divi THEN 
        ASSIGN 
            cDir = INTEGRAL.GN-DIVI.DirDiv
            cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
    FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = s-CodAlm
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

    /**/
    lFiler1 = ttitems-pickeados.campo-c[3].
    IF Chktareas.coddoc = 'HPK' THEN DO:
        /*
        lFiler1 = REPLACE(lFiler1,"-","").
        lFiler1 = REPLACE(lFiler1," ","").
        */
    END.
    /* ************************************************************** */
    /* PESO */
    /* ************************************************************** */
    dPeso = fPeso-orden(INPUT ttitems-pickeados.campo-c[1], 
                        INPUT ttitems-pickeados.campo-c[2], 
                        INPUT chktareas.coddoc, 
                        INPUT chktareas.nroped, 
                        INPUT ttitems-pickeados.campo-c[3]).
    /* ************************************************************** */
    cNomChq = fChequeador(INPUT chktareas.coddoc, INPUT chktareas.nroped).

    CREATE rr-w-report.
    ASSIGN         
        i-nro             = i-nro + 1
        rr-w-report.Llave-C  = "01" + faccpedi.nroped
        rr-w-report.Campo-C[1] = faccpedi.ruc
        rr-w-report.Campo-C[2] = x-cliente-final   
        rr-w-report.Campo-C[3] = x-direccion-final  
        rr-w-report.Campo-C[4] = cNomChq
        rr-w-report.Campo-D[1] = faccpedi.fchped
        rr-w-report.Campo-C[5] = STRING(x-total-bultos-orden)
        rr-w-report.Campo-F[1] = dPeso     /* Peso */
        rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 /*faccpedi.nroped*/
        rr-w-report.Campo-I[1] = i-nro
        rr-w-report.Campo-C[8] = cDir
        rr-w-report.Campo-C[9] = cSede
        rr-w-report.Campo-C[10] = lFiler1   /*tt-w-report.campo-c[3] /* ControlOD.NroEtq*/*/
        rr-w-report.Campo-D[2] = faccpedi.fchent
        rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
        rr-w-report.campo-c[12] = x-cliente-intermedio
        rr-w-report.campo-c[13] = ""    /*STRING(pNroBulto)+ "-" + pGraficoRotulo + "-" + STRING(i-nro,"999")*/
        rr-w-report.campo-c[14] = ""
        rr-w-report.campo-c[19] = ttitems-pickeados.campo-c[1]    /* O/D */
        rr-w-report.campo-c[20] = ttitems-pickeados.campo-c[2]    /* Nro */
        .
    
    IF chktareas.coddoc = 'HPK' THEN DO:
        IF faccpedi.crossdocking = NO THEN DO:
            IF AVAILABLE hpk-vtacdocu THEN rr-w-report.campo-c[14] = hpk-vtacdocu.codori + " " + hpk-vtacdocu.nroori.
        END.       
    END.
    
    /* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
    IF s-coddiv = '00506' THEN DO:
        /* Busco el Pedido */
        FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                    x-pedido.coddoc = faccpedi.codref AND 
                                    x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE x-pedido THEN DO:
            /* Busco la Cotizacion */
            FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                        x-cotizacion.coddoc = x-pedido.codref AND 
                                        x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE x-cotizacion THEN DO:
                ASSIGN w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref)
                        rr-w-report.campo-c[14] = "".
            END.
        END.
    END.

END.

IF pxSource = "ROTULOS DESPACHO" OR pxSource = "CHEQUEO ROTULO" THEN DO:
    RUN imprimir-rotulos-despacho.
    SESSION:SET-WAIT-STATE("").

    RETURN.
END.

/*  */
RUN imprirmir.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulos-bcp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulos-bcp Procedure 
PROCEDURE imprimir-rotulos-bcp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').
/* creo el temporal */ 
IF x-origen = "ROTULOS BCP ZEBRA" THEN DO:
    s-task-no = 0.
    EMPTY TEMP-TABLE rr-w-report.
END.
ELSE DO:
    REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                        AND w-report.llave-c = USERID("DICTDB") NO-LOCK)
            THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no.
            LEAVE.
        END.
    END.
END.

/*DEFINE VAR x-cotizaciones-prueba AS INT.*/
DEFINE VAR x-cotizacion AS CHAR.
DEFINE VAR x-cotizaciones-sec AS INT.

DEFINE VAR x-bultos AS INT.

/*x-cotizaciones-prueba = 519000101.*/
x-cotizaciones-sec = 0.

/* Cuantos Bultos en total de la orden */
FOR EACH ttitems-pickeados NO-LOCK:
    x-bultos = x-bultos + 1.
END.

DEFINE VAR x-nro-etiqueta AS INT INIT 1.
DEFINE VAR x-pos-etiqueta AS INT INIT 0.

FOR EACH ttitems-pickeados WHERE ttitems-pickeados.campo-l[1] = YES :

    /*x-cotizaciones-prueba = x-cotizaciones-prueba + x-cotizaciones-sec.*/

    x-pos-etiqueta = 0.
    IF x-nro-etiqueta = 2 THEN x-pos-etiqueta = 10.

    /* Busco el PED segun O/D */

    /*x-cotizacion = STRING(x-cotizaciones-prueba).*/
    FIND FIRST od-faccpedi WHERE od-faccpedi.codcia = s-codcia AND
                                od-faccpedi.coddoc = ttitems-pickeados.campo-c[1] AND      /* O/D */
                                od-faccpedi.nroped = ttitems-pickeados.campo-c[2] NO-LOCK NO-ERROR.
    IF NOT AVAILABLE od-faccpedi THEN NEXT.

    FIND FIRST ped-faccpedi WHERE ped-faccpedi.codcia = s-codcia AND
                                ped-faccpedi.coddoc = od-faccpedi.codref AND      /* PED */
                                ped-faccpedi.nroped = od-faccpedi.nroref NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ped-faccpedi THEN NEXT.

    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.coddoc = ped-faccpedi.codref AND      /* COT */
                                faccpedi.nroped = ped-faccpedi.nroref NO-LOCK NO-ERROR.

    IF AVAILABLE faccpedi THEN DO:
        IF x-origen = "ROTULOS BCP" THEN DO:
            /* Papel Bond */
            IF x-pos-etiqueta = 0 THEN DO:
                CREATE w-report.
                ASSIGN
                    w-report.task-no = s-task-no
                    w-report.llave-c = USERID("DICTDB").
            END.
            ASSIGN
                w-report.campo-c[x-pos-etiqueta + 1] = TRIM(faccpedi.officecustomerName)
                w-report.campo-c[x-pos-etiqueta + 2] = TRIM(faccpedi.CustomerStockDepoName)
                w-report.campo-c[x-pos-etiqueta + 3] = TRIM(faccpedi.CustomerRequest)
                w-report.campo-c[x-pos-etiqueta + 4] = TRIM(faccpedi.Region1Name)
                w-report.campo-c[x-pos-etiqueta + 5] = TRIM(faccpedi.Region2Name)
                w-report.campo-c[x-pos-etiqueta + 6] = TRIM(faccpedi.Region3Name)
                w-report.campo-c[x-pos-etiqueta + 7] = STRING(ttitems-pickeados.campo-i[1]) + "/" + STRING(x-bultos)
                w-report.campo-c[x-pos-etiqueta + 8] = TRIM(faccpedi.CustomerPurchaseOrder)
                w-report.campo-c[x-pos-etiqueta + 9] = TRIM(faccpedi.officecustomer) + TRIM(faccpedi.CustomerStockDepo)
                w-report.campo-c[x-pos-etiqueta + 10] = TRIM(faccpedi.DeliveryGroup)
                w-report.campo-f[x-pos-etiqueta + 1] = 0
            .
            FIND FIRST controlOD WHERE controlOD.codcia = s-codcia AND
                                        controlOD.nroetq = ttitems-pickeados.campo-c[3] NO-LOCK NO-ERROR.
            IF AVAILABLE controlOD THEN DO:
                ASSIGN w-report.campo-f[x-pos-etiqueta + 1] = controlOD.pesart.
            END.
            IF x-pos-etiqueta = 10 THEN RELEASE w-report.

            IF x-nro-etiqueta = 2 THEN DO:
                x-nro-etiqueta = 1.
            END.
            ELSE DO:
                x-nro-etiqueta = x-nro-etiqueta + 1.
            END.
        END.
        ELSE DO:
            /* ZEBRA */
            s-task-no = s-task-no + 1.
            CREATE rr-w-report.
                ASSIGN rr-w-report.task-no = s-task-no
                rr-w-report.llave-c = USERID("DICTDB").

                ASSIGN
                    rr-w-report.campo-c[1] = TRIM(faccpedi.officecustomerName)
                    rr-w-report.campo-c[2] = TRIM(faccpedi.CustomerStockDepoName)
                    rr-w-report.campo-c[3] = TRIM(faccpedi.CustomerRequest)
                    rr-w-report.campo-c[4] = TRIM(faccpedi.Region1Name)
                    rr-w-report.campo-c[5] = TRIM(faccpedi.Region2Name)
                    rr-w-report.campo-c[6] = TRIM(faccpedi.Region3Name)
                    rr-w-report.campo-c[7] = STRING(ttitems-pickeados.campo-i[1]) + "/" + STRING(x-bultos)
                    rr-w-report.campo-c[8] = TRIM(faccpedi.CustomerPurchaseOrder)
                    rr-w-report.campo-c[9] = TRIM(faccpedi.officecustomer) + TRIM(faccpedi.CustomerStockDepo)
                    rr-w-report.campo-c[10] = TRIM(faccpedi.DeliveryGroup)
                    rr-w-report.campo-f[1] = 0
                .
                FIND FIRST controlOD WHERE controlOD.codcia = s-codcia AND
                                            controlOD.nroetq = ttitems-pickeados.campo-c[3] NO-LOCK NO-ERROR.
                IF AVAILABLE controlOD THEN DO:
                    ASSIGN rr-w-report.campo-f[1] = controlOD.pesart.
                END.
                RELEASE w-report.
        END.
    END.
    x-cotizaciones-sec = x-cotizaciones-sec + 1.
END.

SESSION:SET-WAIT-STATE('').

IF x-origen = "ROTULOS BCP ZEBRA" THEN DO:
    
    /* Rotulos por Zebra */
    /*RUN imprimir-rotulos-bcp-zebra.*/
    RUN imprimir-rotulos-bcp-zebra-v2.

    RETURN.
END.


/*
DEFINE VAR x-bulto AS INT INIT 0.

FOR EACH tt-bcp-extraordinarios WHERE tt-bcp-extraordinarios.CodigoBulto <> "" NO-LOCK:
    /*
    x-total-bultos = 0.
    FOR EACH x-tt-w-report WHERE x-tt-w-report.campo-c[1] = tt-bcp-extraordinarios.CodigoBulto NO-LOCK:
        x-total-bultos = x-total-bultos + 1.
    END.
    */

    x-bulto = 0.
    FOR EACH x-tt-w-report WHERE x-tt-w-report.campo-c[1] = tt-bcp-extraordinarios.CodigoBulto NO-LOCK:
        
        x-bulto = x-tt-w-report.campo-i[1].

        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = USERID("DICTDB")
            w-report.campo-c[1] = "IMPRESIONES"
            w-report.campo-c[2] = ""
            w-report.campo-c[3] = caps(trim(tt-bcp-extraordinarios.NombreReceptor))
            w-report.campo-c[4] = caps(trim(tt-bcp-extraordinarios.NombreCentro))
            w-report.campo-c[5] = caps(trim(tt-bcp-extraordinarios.CentroCostos))
            w-report.campo-c[6] = caps(trim(tt-bcp-extraordinarios.Departamento))
            w-report.campo-c[7] = caps(trim(tt-bcp-extraordinarios.Provincia))
            w-report.campo-c[8] = caps(trim(tt-bcp-extraordinarios.Distrito))

            w-report.campo-c[9] = STRING(x-bulto) + " de " +  STRING(x-total-bultos)
            w-report.campo-c[10] = caps(trim(tt-bcp-extraordinarios.Pedidocompra))
            w-report.campo-c[11] = TRIM( STRING(x-tt-w-report.campo-f[1],"->>,>>>,>>9.99"))
        .
    END.
END.

SESSION:SET-WAIT-STATE('').

*/

DEFINE VAR s-printer-port AS CHAR.


RUN bin/_prnctr.p.  
/*RUN lib/Imprimir-Rb.*/
IF s-salida-impresion = 0 THEN RETURN.



RB-INCLUDE-RECORDS = "O".

RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
              " AND w-report.llave-c = '" + USERID("DICTDB") + "'".
RB-OTHER-PARAMETERS = "s-nomcia = 1 " +
                        "~ns-division = Nombre de la division".

/*RUNTIME-PARAMETER("s-nomcia")*/

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR
   cHostName = ? OR
   cNetworkProto = ? OR
   cPortNumber = ?) THEN DO:
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

ASSIGN
      /* RB-REPORT-NAME = "rotulo bcp v2"*/
      RB-REPORT-NAME = "rotulo bcp v3"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  /*
  FIND FIRST DI-RutaD OF DI-RutaC NO-LOCK NO-ERROR.

  IF AVAILABLE DI-RutaD THEN
  */
  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,
                      "").

/* Borar el temporal */
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulos-bcp-zebra) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulos-bcp-zebra Procedure 
PROCEDURE imprimir-rotulos-bcp-zebra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST rr-w-report NO-LOCK NO-ERROR.

IF NOT AVAILABLE rr-w-report THEN RETURN.

DEFINE VAR x-papel AS LOG.

x-papel = YES.

IF x-papel = YES THEN DO:
    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.
END.
ELSE DO:
    DEFINE VAR x-file-zpl AS CHAR.

    x-file-zpl = SESSION:TEMP-DIRECTORY + "RotuloBcp.txt".

    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
END.
/*
DEFINE VAR rpta AS LOG.

SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.
*/

DEFINE VAR x-centro1 AS CHAR.
DEFINE VAR x-centro2 AS CHAR.
DEFINE VAR x-dir1 AS CHAR.
DEFINE VAR x-dir2 AS CHAR.
DEFINE VAR x-dpto1 AS CHAR.
DEFINE VAR x-dpto2 AS CHAR.
DEFINE VAR x-prov1 AS CHAR.
DEFINE VAR x-prov2 AS CHAR.
DEFINE VAR x-dist1 AS CHAR.
DEFINE VAR x-dist2 AS CHAR.
DEFINE VAR x-solpe1 AS CHAR.
DEFINE VAR x-solpe2 AS CHAR.


FOR EACH rr-w-report NO-LOCK:

    x-centro1 = rr-w-report.campo-c[1].
    x-centro2 = "".
    IF LENGTH(rr-w-report.campo-c[1]) > 33 THEN DO:
        x-centro1 = SUBSTRING(rr-w-report.campo-c[1],1,33).
        x-centro2 = SUBSTRING(rr-w-report.campo-c[1],34,33).
    END.
    x-dir1 = rr-w-report.campo-c[2].
    x-dir2 = "".
    IF LENGTH(rr-w-report.campo-c[2]) > 33 THEN DO:
        x-dir1 = SUBSTRING(rr-w-report.campo-c[2],1,33).
        x-dir2 = SUBSTRING(rr-w-report.campo-c[2],34,33).
    END.
    x-dpto1 = rr-w-report.campo-c[4].
    x-dpto2 = "".
    IF LENGTH(rr-w-report.campo-c[4]) > 14 THEN DO:
        x-dpto1 = SUBSTRING(rr-w-report.campo-c[4],1,14).
        x-dpto2 = SUBSTRING(rr-w-report.campo-c[4],15,14).
    END.
    x-prov1 = rr-w-report.campo-c[5].
    x-prov2 = "".
    IF LENGTH(rr-w-report.campo-c[5]) > 14 THEN DO:
        x-prov1 = SUBSTRING(rr-w-report.campo-c[5],1,14).
        x-prov2 = SUBSTRING(rr-w-report.campo-c[5],15,14).
    END.
    x-dist1 = rr-w-report.campo-c[6].
    x-dist2 = "".
    IF LENGTH(rr-w-report.campo-c[6]) > 13 THEN DO:
        x-dist1 = SUBSTRING(rr-w-report.campo-c[6],1,13).
        x-dist2 = SUBSTRING(rr-w-report.campo-c[6],14,13).
    END.
    x-solpe1 = rr-w-report.campo-c[3].
    x-solpe2 = "".
    IF LENGTH(rr-w-report.campo-c[3]) > 6 THEN DO:
        x-solpe1 = SUBSTRING(rr-w-report.campo-c[3],1,6).
        x-solpe2 = SUBSTRING(rr-w-report.campo-c[3],7,6).
    END.

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.
    
    PUT STREAM REPORTE "^XA" SKIP.
    PUT STREAM REPORTE "^FO10,20^GB790,580,3^FS" SKIP.
    
    PUT STREAM REPORTE "^FO10,140^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,230^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,310^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,370^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,470^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,530^GB790,2.2^FS" SKIP.
    
    PUT STREAM REPORTE "^FO400,20^GB1,120,3^FS" SKIP.
    PUT STREAM REPORTE "^FO170,140^GB1,170,3^FS" SKIP.
    
    PUT STREAM REPORTE "^FO120,310^GB1,160,3^FS" SKIP.
    PUT STREAM REPORTE "^FO350,310^GB1,160,3^FS" SKIP.
    PUT STREAM REPORTE "^FO580,310^GB1,160,3^FS" SKIP.
    
    PUT STREAM REPORTE "^FO260,470^GB1,130,3^FS" SKIP.
    PUT STREAM REPORTE "^FO530,470^GB1,130,3^FS" SKIP.
    
    PUT STREAM REPORTE "^FT410,100" SKIP.
    PUT STREAM REPORTE "^AUN^FDCONTINENTAL SAC^FS" SKIP.
    
    PUT STREAM REPORTE "^FT100,70" SKIP.
    PUT STREAM REPORTE "^ASN^FDNOMBRE DEL^FS" SKIP.
    PUT STREAM REPORTE "^FT110,105" SKIP.
    PUT STREAM REPORTE "^ASN^FDPROVEEDOR^FS" SKIP.
    
    PUT STREAM REPORTE "^FT35,200" SKIP.
    PUT STREAM REPORTE "^ARN^FDCENTRO^FS" SKIP.
    PUT STREAM REPORTE "^FT190,180" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD" + x-centro1 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT190,215" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD" + x-centro2 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FT25,280" SKIP.
    PUT STREAM REPORTE "^ARN^FDALMACEN^FS" SKIP.
    PUT STREAM REPORTE "^FT190,265" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD".
    PUT STREAM REPORTE x-dir1 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS"  SKIP.
    PUT STREAM REPORTE "^FT190,300" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD".
    PUT STREAM REPORTE x-dir2 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FT25,350" SKIP.
    PUT STREAM REPORTE "^ARN^FDSOLPE^FS" SKIP.
    PUT STREAM REPORTE "^FT20,410" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-solpe1 FORMAT 'x(6)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT20,450" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-solpe2 FORMAT 'x(6)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT140,350" SKIP.
    PUT STREAM REPORTE "^AR^FDDEPARTAMENTO^FS" SKIP.
    PUT STREAM REPORTE "^FT125,410" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dpto1 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT125,450" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dpto2 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT390,350" SKIP.
    PUT STREAM REPORTE "^AR^FDPROVINCIA^FS" SKIP.
    PUT STREAM REPORTE "^FT355,410" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-prov1 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT355,450" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-prov2 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT630,350" SKIP.
    PUT STREAM REPORTE "^AR^FDDISTRITO^FS" SKIP.
    PUT STREAM REPORTE "^FT585,410" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dist1 FORMAT 'x(13)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT585,450" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dist2 FORMAT 'x(13)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FT35,510" SKIP.
    PUT STREAM REPORTE "^AQN^FDNUMERO DE BULTOS^FS" SKIP.
    PUT STREAM REPORTE "^FT50,575" SKIP.
    PUT STREAM REPORTE "^ARN^FD".
    PUT STREAM REPORTE rr-w-report.campo-c[7] FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT270,510" SKIP.
    PUT STREAM REPORTE "^ARN^FDPEDIDO DE COMPRA^FS" SKIP.
    PUT STREAM REPORTE "^FT300,575" SKIP.
    PUT STREAM REPORTE "^ARN^FD".
    PUT STREAM REPORTE rr-w-report.campo-c[8] FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT590,510" SKIP.
    PUT STREAM REPORTE "^ARN^FDPESO KG^FS" SKIP.
    PUT STREAM REPORTE "^FT580,575" SKIP.
    PUT STREAM REPORTE "^ARN^FD".
    PUT STREAM REPORTE STRING(rr-w-report.campo-f[1],"->,>>>,>>9.99") + " KG" FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^XZ" SKIP.
END.

OUTPUT STREAM REPORTE CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulos-bcp-zebra-v2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulos-bcp-zebra-v2 Procedure 
PROCEDURE imprimir-rotulos-bcp-zebra-v2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST rr-w-report NO-LOCK NO-ERROR.

IF NOT AVAILABLE rr-w-report THEN RETURN.

DEFINE VAR x-papel AS LOG.

x-papel = YES.

IF x-papel = YES THEN DO:
    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.
END.
ELSE DO:
    DEFINE VAR x-file-zpl AS CHAR.

    x-file-zpl = SESSION:TEMP-DIRECTORY + "RotuloBcp.txt".

    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
END.
/*
DEFINE VAR rpta AS LOG.

SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.
*/

DEFINE VAR x-centro1 AS CHAR.
DEFINE VAR x-centro2 AS CHAR.
DEFINE VAR x-dir1 AS CHAR.
DEFINE VAR x-dir2 AS CHAR.
DEFINE VAR x-dpto1 AS CHAR.
DEFINE VAR x-dpto2 AS CHAR.
DEFINE VAR x-prov1 AS CHAR.
DEFINE VAR x-prov2 AS CHAR.
DEFINE VAR x-dist1 AS CHAR.
DEFINE VAR x-dist2 AS CHAR.
DEFINE VAR x-solpe1 AS CHAR.
DEFINE VAR x-solpe2 AS CHAR.
DEFINE VAR x-llave AS CHAR.
DEFINE VAR x-grupo-reparto AS CHAR.

FOR EACH rr-w-report NO-LOCK:

    x-llave = TRIM(rr-w-report.campo-c[9]).
    x-grupo-reparto = TRIM(rr-w-report.campo-c[10]).

    x-centro1 = rr-w-report.campo-c[1].
    x-centro2 = "".
    IF LENGTH(rr-w-report.campo-c[1]) > 33 THEN DO:
        x-centro1 = SUBSTRING(rr-w-report.campo-c[1],1,33).
        x-centro2 = SUBSTRING(rr-w-report.campo-c[1],34,33).
    END.
    x-dir1 = rr-w-report.campo-c[2].
    x-dir2 = "".
    IF LENGTH(rr-w-report.campo-c[2]) > 33 THEN DO:
        x-dir1 = SUBSTRING(rr-w-report.campo-c[2],1,33).
        x-dir2 = SUBSTRING(rr-w-report.campo-c[2],34,33).
    END.
    x-dpto1 = rr-w-report.campo-c[4].
    x-dpto2 = "".
    IF LENGTH(rr-w-report.campo-c[4]) > 14 THEN DO:
        x-dpto1 = SUBSTRING(rr-w-report.campo-c[4],1,14).
        x-dpto2 = SUBSTRING(rr-w-report.campo-c[4],15,14).
    END.
    x-prov1 = rr-w-report.campo-c[5].
    x-prov2 = "".
    IF LENGTH(rr-w-report.campo-c[5]) > 14 THEN DO:
        x-prov1 = SUBSTRING(rr-w-report.campo-c[5],1,14).
        x-prov2 = SUBSTRING(rr-w-report.campo-c[5],15,14).
    END.
    x-dist1 = rr-w-report.campo-c[6].
    x-dist2 = "".
    IF LENGTH(rr-w-report.campo-c[6]) > 13 THEN DO:
        x-dist1 = SUBSTRING(rr-w-report.campo-c[6],1,13).
        x-dist2 = SUBSTRING(rr-w-report.campo-c[6],14,13).
    END.
    x-solpe1 = rr-w-report.campo-c[3].
    x-solpe2 = "".
    IF LENGTH(rr-w-report.campo-c[3]) > 6 THEN DO:
        x-solpe1 = SUBSTRING(rr-w-report.campo-c[3],1,6).
        x-solpe2 = SUBSTRING(rr-w-report.campo-c[3],7,6).
    END.

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.
    
    PUT STREAM REPORTE "^XA" SKIP.
    PUT STREAM REPORTE "^FO10,20^GB790,580,3^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FO10,105^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,185^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,240^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,320^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,390^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,470^GB790,2.2^FS" SKIP.   
    PUT STREAM REPORTE "^FO10,540^GB790,2.2^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FO400,20^GB1,85,3^FS" SKIP.
    PUT STREAM REPORTE "^FO170,105^GB1,215,3^FS" SKIP.
    /**/    
    PUT STREAM REPORTE "^FO120,320^GB1,280,3^FS" SKIP.
    PUT STREAM REPORTE "^FO350,320^GB1,150,3^FS" SKIP.
    PUT STREAM REPORTE "^FO580,320^GB1,150,3^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FO260,470^GB1,130,3^FS" SKIP.
    PUT STREAM REPORTE "^FO530,470^GB1,130,3^FS" SKIP.
    /**/
    
    PUT STREAM REPORTE "^FT410,70" SKIP.
    PUT STREAM REPORTE "^AUN^FDCONTINENTAL SAC^FS" SKIP.
    
    PUT STREAM REPORTE "^FT100,60" SKIP.
    PUT STREAM REPORTE "^ASN^FDNOMBRE DEL^FS" SKIP.
    PUT STREAM REPORTE "^FT110,95" SKIP.
    PUT STREAM REPORTE "^ASN^FDPROVEEDOR^FS" SKIP.
    
    PUT STREAM REPORTE "^FT35,160" SKIP.
    PUT STREAM REPORTE "^ARN^FDCENTRO^FS" SKIP.
    PUT STREAM REPORTE "^FT190,140" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD" + x-centro1 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT190,175" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD" + x-centro2 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT40,225" SKIP.
    PUT STREAM REPORTE "^ARN^FDLLAVE^FS" SKIP.
    PUT STREAM REPORTE "^FT190,225" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD" + x-llave FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT25,300" SKIP.
    PUT STREAM REPORTE "^ARN^FDALMACEN^FS" SKIP.
    PUT STREAM REPORTE "^FT190,275" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD".
    PUT STREAM REPORTE x-dir1 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS"  SKIP.
    PUT STREAM REPORTE "^FT190,310" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD".
    PUT STREAM REPORTE x-dir2 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT25,370" SKIP.
    PUT STREAM REPORTE "^ARN^FDSOLPE^FS" SKIP.
    PUT STREAM REPORTE "^FT20,425" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-solpe1 FORMAT 'x(6)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT20,460" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-solpe2 FORMAT 'x(6)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT140,370" SKIP.
    PUT STREAM REPORTE "^AR^FDDEPARTAMENTO^FS" SKIP.
    PUT STREAM REPORTE "^FT125,425" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dpto1 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT125,460" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dpto2 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT390,370" SKIP.
    PUT STREAM REPORTE "^AR^FDPROVINCIA^FS" SKIP.
    PUT STREAM REPORTE "^FT355,425" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-prov1 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT355,460" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-prov2 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT630,370" SKIP.
    PUT STREAM REPORTE "^AR^FDDISTRITO^FS" SKIP.
    PUT STREAM REPORTE "^FT585,425" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dist1 FORMAT 'x(13)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT585,460" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dist2 FORMAT 'x(13)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT20,500" SKIP.
    PUT STREAM REPORTE "^AQN^FDGRUPO DE^FS" SKIP.
    PUT STREAM REPORTE "^FT20,530" SKIP.
    PUT STREAM REPORTE "^AQN^FDREPARTO^FS" SKIP.
    PUT STREAM REPORTE "^FT45,585" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-grupo-reparto FORMAT 'x(10)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT135,500" SKIP.
    PUT STREAM REPORTE "^AQN^FDNUMERO DE^FS" SKIP.
    PUT STREAM REPORTE "^FT155,530" SKIP.
    PUT STREAM REPORTE "^AQN^FDBULTOS^FS" SKIP.
    PUT STREAM REPORTE "^FT180,585" SKIP.
    PUT STREAM REPORTE "^ARN^FD".
    PUT STREAM REPORTE rr-w-report.campo-c[7] FORMAT 'x(10)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT270,510" SKIP.
    PUT STREAM REPORTE "^ARN^FDPEDIDO DE COMPRA^FS" SKIP.
    PUT STREAM REPORTE "^FT300,585" SKIP.
    PUT STREAM REPORTE "^ARN^FD".
    PUT STREAM REPORTE rr-w-report.campo-c[8] FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /**/
    PUT STREAM REPORTE "^FT590,510" SKIP.
    PUT STREAM REPORTE "^ARN^FDPESO KG^FS" SKIP.
    PUT STREAM REPORTE "^FT580,585" SKIP.
    PUT STREAM REPORTE "^ARN^FD".
    PUT STREAM REPORTE STRING(rr-w-report.campo-f[1],"->,>>>,>>9.99") + " KG" FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^XZ" SKIP.
END.

OUTPUT STREAM REPORTE CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulos-despacho) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulos-despacho Procedure 
PROCEDURE imprimir-rotulos-despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN DO:
    RETURN.
END.

DEFINE VAR lbarra AS CHAR.
DEFINE VAR lSede AS CHAR.
DEFINE VAR lSede2 AS CHAR.
DEFINE VAR lpedido AS CHAR.
DEFINE VAR lpedido1 AS CHAR.
DEFINE VAR lpedido2 AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lCliente2 AS CHAR.
DEFINE VAR lChequeador AS CHAR.
DEFINE VAR lChequeador2 AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lFechaEnt AS DATE.
DEFINE VAR lEtiqueta AS CHAR.
DEFINE VAR lpeso AS DEC.
DEFINE VAR lBultos AS CHAR.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lRefOtr AS CHAR.
DEFINE VAR x-almfinal AS CHAR.

DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud AS DEC NO-UNDO.

DEFINE VAR x-dpto AS CHAR.
DEFINE VAR x-prov AS CHAR.
DEFINE VAR x-dist AS CHAR.
DEFINE VAR x-dpto1 AS CHAR.
DEFINE VAR x-prov1 AS CHAR.
DEFINE VAR x-dist1 AS CHAR.

DEFINE VAR x-clieFinalPart1 AS CHAR.
DEFINE VAR x-clieFinalPart2 AS CHAR.
DEFINE VAR x-es-LPG AS LOG.

DEFINE VAR rpta AS LOG.

DEFINE VAR x-Bulto AS CHAR.

IF USERID("DICTDB") = "CIRH" OR USERID("DICTDB") = "MASTER" OR USERID("DICTDB") = "ADMIN" THEN DO:

    /* ---------------------------------------- */
    DEFINE VAR x-file-zpl AS CHAR.
    
    x-file-zpl = SESSION:TEMP-DIRECTORY + REPLACE("HPK","/","") + "-" + "PRUEBA" + ".txt".
    
    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).

END.
ELSE DO:
    IF TRUE <> (cPrinterName > "") THEN DO:
        SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
        IF rpta = NO THEN RETURN.

        OUTPUT STREAM REPORTE TO PRINTER.
    END.
    ELSE DO:
        SESSION:PRINTER-NAME = cPrinterName.
        OUTPUT STREAM REPORTE TO PRINTER.
        /*
        s-printer-name = cPrinterName.
        s-salida-impresion = 2.
        /* Falta verificar que la impresora exista */
    
        RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).        
        */
    END.
END.

FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = chktareas.coddoc AND
                                    x-vtacdocu.nroped = chktareas.nroped NO-LOCK NO-ERROR.
FOR EACH rr-w-report WHERE NO-LOCK BREAK BY rr-w-report.campo-c[19] BY rr-w-report.campo-c[20]:

    /* Los valores */   
    lSede = rr-w-report.campo-c[9].
    lPedido = rr-w-report.campo-c[7].
    lCliente = rr-w-report.campo-c[2].
    lChequeador = rr-w-report.campo-c[4].
    lFecha = rr-w-report.campo-d[1].
    lFechaEnt = rr-w-report.campo-d[2].
    lEtiqueta = rr-w-report.campo-c[10]. 
    lPeso = rr-w-report.campo-f[1].
    lBultos = STRING(rr-w-report.campo-i[1]) + " / " + rr-w-report.campo-c[5].   /*TRIM(rr-w-report.campo-c[13])*/
    lBarra = STRING(rr-w-report.llave-c,"99999999999") + STRING(rr-w-report.campo-i[1],"9999").    
    /*
    MESSAGE lEtiqueta SKIP
            SUBSTRING(lEtiqueta,4,12).
    */
    lRefOtr = "".
    IF AVAILABLE x-vtacdocu THEN lRefOtr = x-vtacdocu.nroori.

    /* Ic 08Nov2019, a pedido de Max Ramos */
    lEtiqueta = REPLACE(lEtiqueta,"-","").
    lEtiqueta = REPLACE(lEtiqueta," ","").
    lEtiqueta = REPLACE(lEtiqueta,"B","-").

    lCliente2 = "".
    IF LENGTH(lCliente) > 24 THEN DO:
        lCliente2 = SUBSTRING(lCliente,25,24).
        lCliente = SUBSTRING(lCliente,1,24).
    END.
    lChequeador2 = "".
    IF LENGTH(lChequeador) > 12 THEN DO:
        lChequeador2 = SUBSTRING(lChequeador,13).
        lChequeador = SUBSTRING(lChequeador,1,12).
    END.
    lSede2 = "".
    IF LENGTH(lSede) > 15 THEN DO:
        lSede2 = SUBSTRING(lSede,17).
        lSede = SUBSTRING(lSede,1,16).
    END.
    lpedido2 = "".
    lPedido1 = lPedido.
    IF NUM-ENTRIES(lPedido,"-") > 1 THEN DO:
        lpedido1 = TRIM(ENTRY(1,lPedido,"-")).
        lPedido2 = TRIM(ENTRY(2,lPedido,"-")).
    END.

    pUbigeo = "".
    pLongitud = 0.
    pLatitud = 0.

    x-dpto = "".
    x-prov = "".
    x-dist = "".
    x-dpto1 = "".
    x-prov1 = "".
    x-dist1 = "".
    x-clieFinalPart2 = "".
    x-clieFinalPart1 = "".
    x-es-LPG = NO.

    lPedido2 = TRIM(lPedido2).
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = rr-w-report.campo-c[19] AND
                                x-faccpedi.nroped = rr-w-report.campo-c[20] NO-LOCK NO-ERROR.

    IF AVAILABLE x-faccpedi THEN DO:

        IF x-faccpedi.coddiv = '00524' THEN x-es-LPG = YES.

        RUN logis/p-datos-sede-auxiliar.r (
            x-FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
            x-FacCPedi.Ubigeo[3],   /* Auxiliar */
            x-FacCPedi.Ubigeo[1],   /* Sede */
            OUTPUT pUbigeo,
            OUTPUT pLongitud,
            OUTPUT pLatitud
            ).

        FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
        IF AVAILABLE TabDepto THEN DO:
            x-dpto =TabDepto.NomDepto.
            FIND TabProv WHERE TabProv.CodDepto = SUBSTRING(pUbigeo,1,2) AND
                                TabProv.CodProv = SUBSTRING(pUbigeo,3,2) NO-LOCK NO-ERROR.
            IF AVAILABLE TabProv THEN DO:
                x-prov =TabProv.NomPRov.
                FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2) AND
                                    TabDistr.CodProv = SUBSTRING(pUbigeo,3,2) AND
                                    TabDistr.Coddistr = SUBSTRING(pUbigeo,5,2) NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr THEN DO:
                    x-dist = TabDistr.NomDistr.
                END.

            END.
        END.        
        /* Para LPG (Winner) dato del cliente final final */
        FIND FIRST x-ccbAdocu WHERE x-ccbAdocu.codcia = s-codcia AND
                                        x-ccbAdocu.coddiv = x-faccpedi.coddiv AND
                                        x-ccbAdocu.coddoc = x-faccpedi.codref AND   /* PED */
                                        x-ccbAdocu.nrodoc = x-faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE x-ccbAdocu THEN DO:                                                 
            IF NOT( TRUE <> (x-ccbAdocu.libre_c[14] > "") ) THEN DO:
                x-clieFinalPart1 = TRIM(x-ccbAdocu.libre_c[14]).
                IF LENGTH(x-clieFinalPart1) > 18 THEN DO:
                    x-clieFinalPart2 = SUBSTR(x-clieFinalPart1,19,18).
                    x-clieFinalPart1 = SUBSTR(x-clieFinalPart1,1,18).
                END.
            END.
        END.

    END.

    IF LENGTH(x-dpto) > 14 THEN DO:
        x-dpto = SUBSTRING(x-dpto,1,14).
    END.
    IF LENGTH(x-prov) > 14 THEN DO:
        x-prov = SUBSTRING(x-prov,1,14).
    END.
    IF LENGTH(x-dist) > 15 THEN DO:
        x-dist1 = SUBSTRING(x-dist,16).
        x-dist = SUBSTRING(x-dist,1,15).
    END.

    lBarra = lEtiqueta.

    /* Ic - 10Set2018, realmente es el destino Intermedio */
    x-almfinal = TRIM(rr-w-report.campo-c[12]).
    IF s-coddiv <> '00506' THEN DO:
        IF x-almfinal <> "" THEN x-almfinal = "D.INTERMEDIO:" + x-almfinal.
    END.    
    IF rr-w-report.campo-c[14] <> "" THEN DO:
        /* Se imprime el HPR */
        x-almfinal = rr-w-report.campo-c[14].
    END.

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.
    PUT STREAM REPORTE "^XA^LRY" SKIP.

    PUT STREAM REPORTE "^FO10,20^GB790,580,3^FS" SKIP.
    PUT STREAM REPORTE "^FO13,23" SKIP.
    PUT STREAM REPORTE "^GB784,40,40^FS" SKIP.
    PUT STREAM REPORTE "^FO150,23^AS" SKIP.
    PUT STREAM REPORTE "^FDEMPRESA^FS" SKIP.
    PUT STREAM REPORTE "^FO600,23^AS" SKIP.
    PUT STREAM REPORTE "^FDFECHA^FS" SKIP.

    PUT STREAM REPORTE "^FO100,70^AS" SKIP.
    PUT STREAM REPORTE "^FDCONTINENTAL SAC^FS" SKIP.
    PUT STREAM REPORTE "^FO500,63^GB3,53,3^FS" SKIP.

    PUT STREAM REPORTE "^FO560,70^AT" SKIP.
    PUT STREAM REPORTE "^FD" + STRING(TODAY,"99/99/9999") FORMAT 'X(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO13,116" SKIP.
    PUT STREAM REPORTE "^GB784,60,40^FS" SKIP.
    PUT STREAM REPORTE "^FO80,125^AT" SKIP.
    PUT STREAM REPORTE "^FDPHR^FS" SKIP.
    PUT STREAM REPORTE "^FO300,125^AT" SKIP.
    /*PUT STREAM REPORTE "^FDOTR^FS" SKIP.*/    
    PUT STREAM REPORTE "^FD" + lPedido1 FORMAT 'x(6)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO590,125^AT" SKIP.
    PUT STREAM REPORTE "^FDHPK^FS" SKIP.

    PUT STREAM REPORTE "^FO30,180^AT" SKIP.
    PUT STREAM REPORTE "^FD" + lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO230,176^GB3,53,3^FS" SKIP.
    PUT STREAM REPORTE "^FO260,180^AT" SKIP.
    PUT STREAM REPORTE "^FD" + lPedido2 FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO460,176^GB3,53,3^FS" SKIP.
    PUT STREAM REPORTE "^FO473,180^AT" SKIP.
    PUT STREAM REPORTE "^FD" + SUBSTRING(lEtiqueta,4) FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    IF x-es-LPG = YES THEN DO:
        PUT STREAM REPORTE "^FO13,233" SKIP.
        PUT STREAM REPORTE "^GB784,40,40^FS" SKIP.
        PUT STREAM REPORTE "^FO150,233^AS" SKIP.
        PUT STREAM REPORTE "^FDCONSULTOR" SKIP.
        PUT STREAM REPORTE "^FS" SKIP.
        PUT STREAM REPORTE "^FO600,233^AS" SKIP.
        PUT STREAM REPORTE "^FDCLIENTE" SKIP.
        PUT STREAM REPORTE "^FS" SKIP.

        PUT STREAM REPORTE "^FO460,230^GB3,130,3^FS" SKIP.
        PUT STREAM REPORTE "^FO25,280^AS" SKIP.
        PUT STREAM REPORTE "^FD" + lCliente FORMAT 'x(30)' SKIP.
        PUT STREAM REPORTE "^FS" SKIP.

        PUT STREAM REPORTE "^FO25,320^AS" SKIP.
        PUT STREAM REPORTE "^FD" + lCliente2 FORMAT 'x(30)' SKIP.
        PUT STREAM REPORTE "^FS" SKIP.

        PUT STREAM REPORTE "^FO470,280^AS" SKIP.
        PUT STREAM REPORTE "^FD" + x-clieFinalPart1 FORMAT 'x(25)' SKIP.
        PUT STREAM REPORTE "^FS" SKIP.
        PUT STREAM REPORTE "^FO470,320^AS" SKIP.
        PUT STREAM REPORTE "^FD" + x-clieFinalPart2 FORMAT 'x(25)' SKIP.
        PUT STREAM REPORTE "^FS" SKIP.
    END.
    ELSE DO:        

        PUT STREAM REPORTE "^FO13,229^GB783,2.2^FS" SKIP.

        PUT STREAM REPORTE "^FO40,240^AU" SKIP.
        PUT STREAM REPORTE "^FD" + lCliente FORMAT 'x(30)' SKIP.
        PUT STREAM REPORTE "^FS" SKIP.

        PUT STREAM REPORTE "^FO40,300^AU" SKIP.
        PUT STREAM REPORTE "^FD" + lCliente2 FORMAT 'x(30)' SKIP.
        PUT STREAM REPORTE "^FS" SKIP.
    END.
    PUT STREAM REPORTE "^FO738,230^GB3,130,3^FS" SKIP.
    /*^FO750,250^A0R,25,25^FD001 / 034^FS*/
    PUT STREAM REPORTE "^FO745,250^ARR" SKIP.
    PUT STREAM REPORTE "^FD" + lBultos FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO13,360" SKIP.
    PUT STREAM REPORTE "^GB784,40,40^FS" SKIP.
    PUT STREAM REPORTE "^FO20,362^AS" SKIP.
    PUT STREAM REPORTE "^FDCHEQUEADOR^FS" SKIP.
    PUT STREAM REPORTE "^FO310,362^AS" SKIP.
    PUT STREAM REPORTE "^FDPESO KG^FS" SKIP.
    PUT STREAM REPORTE "^FO630,362^AS" SKIP.
    PUT STREAM REPORTE "^FDSEDE^FS" SKIP.

    PUT STREAM REPORTE "^FO250,401^GB3,70,3^FS" SKIP.
    PUT STREAM REPORTE "^FO25,405^AR" SKIP.
    PUT STREAM REPORTE "^FD" + lChequeador FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO25,435^AR" SKIP.
    PUT STREAM REPORTE "^FD" + lChequeador2 FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO500,401^GB3,195,3^FS" SKIP.
    PUT STREAM REPORTE "^FO280,415^AT" SKIP.
    PUT STREAM REPORTE "^FD" STRING(lPeso,"Z,ZZZ,ZZ9.99") FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO502,473^GB783,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO520,400^AS" SKIP.
    PUT STREAM REPORTE "^FD" + lSede FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO520,430^AS" SKIP.
    PUT STREAM REPORTE "^FD" + lSede2 FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO13,472" SKIP.
    PUT STREAM REPORTE "^GB487,40,40^FS" SKIP.
    PUT STREAM REPORTE "^FO30,473^AS" SKIP.
    PUT STREAM REPORTE "^FDDPTO/PROV^FS" SKIP.
    PUT STREAM REPORTE "^FO290,473^AS" SKIP.
    PUT STREAM REPORTE "^FDDISTRITO^FS" SKIP.

    /**/
    PUT STREAM REPORTE "^FO20,520^AR" SKIP.
    PUT STREAM REPORTE "^FD" + x-dpto FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO20,555^AR" SKIP.
    PUT STREAM REPORTE "^FD" + x-prov FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO250,513^GB3,83,3^FS" SKIP.
    PUT STREAM REPORTE "^FO260,520^AR" SKIP.
    PUT STREAM REPORTE "^FD" + x-dist FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO260,555^AR" SKIP.
    PUT STREAM REPORTE "^FD" + x-dist1 FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    /**/
    PUT STREAM REPORTE "^FO520,490^BY2" SKIP.
    /*PUT STREAM REPORTE "^BUN,70,Y,N,Y" SKIP.*/
    /*PUT STREAM REPORTE "^FD" + SUBSTRING(lEtiqueta,4,11) FORMAT 'x(20)'  SKIP.*/
    /*PUT STREAM REPORTE "^B2N,70,Y,N,N" SKIP.*/    
    PUT STREAM REPORTE "^BCN,80,Y,N,N" SKIP.
    PUT STREAM REPORTE "^FD" + lPedido2 FORMAT 'x(12)'  SKIP.
    
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.

END.

OUTPUT STREAM REPORTE CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulos-mi-banco) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulos-mi-banco Procedure 
PROCEDURE imprimir-rotulos-mi-banco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').
/* creo el temporal */ 
IF x-origen = "ROTULOS MI BANCO ZEBRA" THEN DO:
    s-task-no = 0.
    EMPTY TEMP-TABLE rr-w-report.
END.
ELSE DO:
    REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                        AND w-report.llave-c = USERID("DICTDB") NO-LOCK)
            THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no.
            LEAVE.
        END.
    END.
END.

/*DEFINE VAR x-cotizaciones-prueba AS INT.*/
DEFINE VAR x-cotizacion AS CHAR.
DEFINE VAR x-cotizaciones-sec AS INT.

DEFINE VAR x-bultos AS INT.

/*x-cotizaciones-prueba = 519000101.*/
x-cotizaciones-sec = 0.

/* Cuantos Bultos en total de la orden */
FOR EACH ttitems-pickeados NO-LOCK:
    x-bultos = x-bultos + 1.
END.

DEFINE VAR x-nro-etiqueta AS INT INIT 1.
DEFINE VAR x-pos-etiqueta AS INT INIT 0.

FOR EACH ttitems-pickeados WHERE ttitems-pickeados.campo-l[1] = YES :

    /*x-cotizaciones-prueba = x-cotizaciones-prueba + x-cotizaciones-sec.*/

    x-pos-etiqueta = 0.
    IF x-nro-etiqueta = 2 THEN x-pos-etiqueta = 10.

    /* Busco el PED segun O/D */

    /*x-cotizacion = STRING(x-cotizaciones-prueba).*/
    FIND FIRST od-faccpedi WHERE od-faccpedi.codcia = s-codcia AND
                                od-faccpedi.coddoc = ttitems-pickeados.campo-c[1] AND      /* O/D */
                                od-faccpedi.nroped = ttitems-pickeados.campo-c[2] NO-LOCK NO-ERROR.
    IF NOT AVAILABLE od-faccpedi THEN NEXT.

    FIND FIRST ped-faccpedi WHERE ped-faccpedi.codcia = s-codcia AND
                                ped-faccpedi.coddoc = od-faccpedi.codref AND      /* PED */
                                ped-faccpedi.nroped = od-faccpedi.nroref NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ped-faccpedi THEN NEXT.

    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.coddoc = ped-faccpedi.codref AND      /* COT */
                                faccpedi.nroped = ped-faccpedi.nroref NO-LOCK NO-ERROR.

    IF AVAILABLE faccpedi THEN DO:
        IF x-origen = "ROTULOS MI BANCO" THEN DO:
            IF x-pos-etiqueta = 0 THEN DO:
                CREATE w-report.
                ASSIGN
                    w-report.task-no = s-task-no
                    w-report.llave-c = USERID("DICTDB").
            END.
            ASSIGN
                w-report.campo-c[x-pos-etiqueta + 1] = TRIM(faccpedi.officecustomerName)
                w-report.campo-c[x-pos-etiqueta + 2] = TRIM(faccpedi.DeliveryAddress) /*faccpedi.CustomerStockDepoName*/
                w-report.campo-c[x-pos-etiqueta + 3] = TRIM(faccpedi.OfficeCustomer)   /*CustomerRequest*/
                w-report.campo-c[x-pos-etiqueta + 4] = TRIM(faccpedi.Region1Name)
                w-report.campo-c[x-pos-etiqueta + 5] = TRIM(faccpedi.Region2Name)
                w-report.campo-c[x-pos-etiqueta + 6] = TRIM(faccpedi.Region3Name)
                w-report.campo-c[x-pos-etiqueta + 7] = STRING(ttitems-pickeados.campo-i[1]) + "/" + STRING(x-bultos)
                w-report.campo-c[x-pos-etiqueta + 8] = TRIM(faccpedi.CustomerPurchaseOrder)
                w-report.campo-f[x-pos-etiqueta + 1] = 0
            .
            FIND FIRST controlOD WHERE controlOD.codcia = s-codcia AND
                                        controlOD.nroetq = ttitems-pickeados.campo-c[3] NO-LOCK NO-ERROR.
            IF AVAILABLE controlOD THEN DO:
                ASSIGN w-report.campo-f[x-pos-etiqueta + 1] = controlOD.pesart.
            END.
            IF x-pos-etiqueta = 10 THEN RELEASE w-report.

            IF x-nro-etiqueta = 2 THEN DO:
                x-nro-etiqueta = 1.
            END.
            ELSE DO:
                x-nro-etiqueta = x-nro-etiqueta + 1.
            END.
        END.
        ELSE DO:
            /* DATA PARA LA ZEBRA */
            s-task-no = s-task-no + 1.
            CREATE rr-w-report.
            ASSIGN
                rr-w-report.task-no = s-task-no
                rr-w-report.llave-c = USERID("DICTDB").          

            ASSIGN
                rr-w-report.campo-c[1] = TRIM(faccpedi.officecustomerName)
                rr-w-report.campo-c[2] = TRIM(faccpedi.DeliveryAddress) /*faccpedi.CustomerStockDepoName*/
                rr-w-report.campo-c[3] = TRIM(faccpedi.OfficeCustomer)   /*CustomerRequest*/
                rr-w-report.campo-c[4] = TRIM(faccpedi.Region1Name)
                rr-w-report.campo-c[5] = TRIM(faccpedi.Region2Name)
                rr-w-report.campo-c[6] = TRIM(faccpedi.Region3Name)
                rr-w-report.campo-c[7] = STRING(ttitems-pickeados.campo-i[1]) + " de " + STRING(x-bultos)
                rr-w-report.campo-c[8] = TRIM(faccpedi.CustomerPurchaseOrder)
                rr-w-report.campo-f[1] = 0
            .
            FIND FIRST controlOD WHERE controlOD.codcia = s-codcia AND
                                        controlOD.nroetq = ttitems-pickeados.campo-c[3] NO-LOCK NO-ERROR.
            IF AVAILABLE controlOD THEN DO:
                ASSIGN rr-w-report.campo-f[1] = controlOD.pesart.
            END.

            RELEASE rr-w-report.
        END.
    END.
    x-cotizaciones-sec = x-cotizaciones-sec + 1.
END.

SESSION:SET-WAIT-STATE('').

IF x-origen = "ROTULOS MI BANCO ZEBRA" THEN DO:
    
    /* Rotulos por Zebra */
    RUN imprimir-rotulos-mi-banco-zebra.

    RETURN.
END.

DEFINE VAR s-printer-port AS CHAR.


RUN bin/_prnctr.p.  
/*RUN lib/Imprimir-Rb.*/
IF s-salida-impresion = 0 THEN RETURN.

RB-INCLUDE-RECORDS = "O".

RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
              " AND w-report.llave-c = '" + USERID("DICTDB") + "'".
RB-OTHER-PARAMETERS = "s-nomcia = 1 " +
                        "~ns-division = Nombre de la division".

/*RUNTIME-PARAMETER("s-nomcia")*/

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR
   cHostName = ? OR
   cNetworkProto = ? OR
   cPortNumber = ?) THEN DO:
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

ASSIGN
      RB-REPORT-NAME = "rotulo mi banco"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  /*
  FIND FIRST DI-RutaD OF DI-RutaC NO-LOCK NO-ERROR.

  IF AVAILABLE DI-RutaD THEN
  */
  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,
                      "").

/* Borar el temporal */
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulos-mi-banco-zebra) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulos-mi-banco-zebra Procedure 
PROCEDURE imprimir-rotulos-mi-banco-zebra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST rr-w-report NO-LOCK NO-ERROR.

IF NOT AVAILABLE rr-w-report THEN RETURN.

/**/
DEFINE VAR x-papel AS LOG.

x-papel = YES.   

IF x-papel = YES THEN DO:
    DEFINE VAR rpta AS LOG.

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.
END.
ELSE DO:
    DEFINE VAR x-file-zpl AS CHAR.

    x-file-zpl = SESSION:TEMP-DIRECTORY + "RotuloMiBanco.txt".

    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
END.


/**/
/*
DEFINE VAR rpta AS LOG.

SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.
*/

DEFINE VAR x-centro1 AS CHAR.
DEFINE VAR x-centro2 AS CHAR.
DEFINE VAR x-dir1 AS CHAR.
DEFINE VAR x-dir2 AS CHAR.
DEFINE VAR x-dpto1 AS CHAR.
DEFINE VAR x-dpto2 AS CHAR.
DEFINE VAR x-prov1 AS CHAR.
DEFINE VAR x-prov2 AS CHAR.
DEFINE VAR x-dist1 AS CHAR.
DEFINE VAR x-dist2 AS CHAR.

/*OUTPUT STREAM REPORTE TO PRINTER.*/

FOR EACH rr-w-report NO-LOCK:

    x-centro1 = rr-w-report.campo-c[1].
    x-centro2 = "".
    IF LENGTH(rr-w-report.campo-c[1]) > 33 THEN DO:
        x-centro1 = SUBSTRING(rr-w-report.campo-c[1],1,33).
        x-centro2 = SUBSTRING(rr-w-report.campo-c[1],34).
    END.
    x-dir1 = rr-w-report.campo-c[2].
    x-dir2 = "".
    IF LENGTH(rr-w-report.campo-c[2]) > 33 THEN DO:
        x-dir1 = SUBSTRING(rr-w-report.campo-c[2],1,33).
        x-dir2 = SUBSTRING(rr-w-report.campo-c[2],34).
    END.
    x-dpto1 = rr-w-report.campo-c[4].
    x-dpto2 = "".
    IF LENGTH(rr-w-report.campo-c[4]) > 14 THEN DO:
        x-dpto1 = SUBSTRING(rr-w-report.campo-c[4],1,14).
        x-dpto2 = SUBSTRING(rr-w-report.campo-c[4],15).
    END.
    x-prov1 = rr-w-report.campo-c[5].
    x-prov2 = "".
    IF LENGTH(rr-w-report.campo-c[5]) > 14 THEN DO:
        x-prov1 = SUBSTRING(rr-w-report.campo-c[5],1,14).
        x-prov2 = SUBSTRING(rr-w-report.campo-c[5],15).
    END.
    x-dist1 = rr-w-report.campo-c[6].
    x-dist2 = "".
    IF LENGTH(rr-w-report.campo-c[6]) > 13 THEN DO:
        x-dist1 = SUBSTRING(rr-w-report.campo-c[6],1,13).
        x-dist2 = SUBSTRING(rr-w-report.campo-c[6],14).
    END.

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.
    
    PUT STREAM REPORTE "^XA" SKIP.
    PUT STREAM REPORTE "^FO10,20^GB790,580,3^FS" SKIP.
    
    PUT STREAM REPORTE "^FO10,140^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,230^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,310^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,370^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,470^GB790,2.2^FS" SKIP.
    PUT STREAM REPORTE "^FO10,530^GB790,2.2^FS" SKIP.
    
    PUT STREAM REPORTE "^FO400,20^GB1,120,3^FS" SKIP.
    PUT STREAM REPORTE "^FO170,140^GB1,170,3^FS" SKIP.
    
    PUT STREAM REPORTE "^FO120,310^GB1,160,3^FS" SKIP.
    PUT STREAM REPORTE "^FO350,310^GB1,160,3^FS" SKIP.
    PUT STREAM REPORTE "^FO580,310^GB1,160,3^FS" SKIP.
    
    PUT STREAM REPORTE "^FO260,470^GB1,130,3^FS" SKIP.
    PUT STREAM REPORTE "^FO530,470^GB1,130,3^FS" SKIP.
    
    PUT STREAM REPORTE "^FT410,100" SKIP.
    PUT STREAM REPORTE "^AUN^FDCONTINENTAL SAC^FS" SKIP.
    
    PUT STREAM REPORTE "^FT100,70" SKIP.
    PUT STREAM REPORTE "^ASN^FDNOMBRE DEL^FS" SKIP.
    PUT STREAM REPORTE "^FT110,105" SKIP.
    PUT STREAM REPORTE "^ASN^FDPROVEEDOR^FS" SKIP.
    
    PUT STREAM REPORTE "^FT35,200" SKIP.
    PUT STREAM REPORTE "^ARN^FDCENTRO^FS" SKIP.
    PUT STREAM REPORTE "^FT190,180" SKIP.
    /*PUT STREAM REPORTE "^A@N,25,15^FD" + x-centro1 + "^FS" FORMAT 'x(33)' SKIP.*/
    PUT STREAM REPORTE "^A@N,25,15^FD" SKIP.
    PUT STREAM REPORTE x-centro1 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS"  SKIP.
    PUT STREAM REPORTE "^FT190,215" SKIP.
    /*PUT STREAM REPORTE "^A@N,25,15^FD" + x-centro2 + "^FS" FORMAT 'x(33)' SKIP.*/
    PUT STREAM REPORTE "^A@N,25,15^FD" SKIP.
    PUT STREAM REPORTE x-centro2 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FT25,280" SKIP.
    PUT STREAM REPORTE "^ARN^FDDIRECCION^FS" SKIP.
    PUT STREAM REPORTE "^FT190,265" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD".
    PUT STREAM REPORTE x-dir1 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS"  SKIP.
    PUT STREAM REPORTE "^FT190,300" SKIP.
    PUT STREAM REPORTE "^A@N,25,15^FD".
    PUT STREAM REPORTE x-dir2 FORMAT 'x(33)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FT25,350" SKIP.
    PUT STREAM REPORTE "^ARN^FDTOPAZ^FS" SKIP.
    PUT STREAM REPORTE "^FT20,420" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE rr-w-report.campo-c[3] FORMAT 'x(6)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT140,350" SKIP.
    PUT STREAM REPORTE "^AR^FDDEPARTAMENTO^FS" SKIP.
    PUT STREAM REPORTE "^FT125,410" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dpto1 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT125,450" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dpto2 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT390,350" SKIP.
    PUT STREAM REPORTE "^AR^FDPROVINCIA^FS" SKIP.
    PUT STREAM REPORTE "^FT355,410" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-prov1 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT355,450" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-prov2 FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT630,350" SKIP.
    PUT STREAM REPORTE "^AR^FDDISTRITO^FS" SKIP.
    PUT STREAM REPORTE "^FT585,410" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dist1 FORMAT 'x(13)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FT585,450" SKIP.
    PUT STREAM REPORTE "^AR^FD".
    PUT STREAM REPORTE x-dist2 FORMAT 'x(13)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FT35,510" SKIP.
    PUT STREAM REPORTE "^AQN^FDNUMERO DE BULTOS^FS" SKIP.
    PUT STREAM REPORTE "^FT50,575" SKIP.
    PUT STREAM REPORTE "^ARN^FD".
    PUT STREAM REPORTE rr-w-report.campo-c[7] FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT270,510" SKIP.
    PUT STREAM REPORTE "^ARN^FDPEDIDO DE COMPRA^FS" SKIP.
    PUT STREAM REPORTE "^FT300,575" SKIP.
    PUT STREAM REPORTE "^ARN^FD".
    PUT STREAM REPORTE rr-w-report.campo-c[8] FORMAT 'x(14)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FT590,510" SKIP.
    PUT STREAM REPORTE "^ARN^FDPESO KG^FS" SKIP.
    PUT STREAM REPORTE "^FT580,575" SKIP.
    PUT STREAM REPORTE "^ARN^FD".
    PUT STREAM REPORTE STRING(rr-w-report.campo-f[1],"->,>>>,>>9.99") + " KG" FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^XZ" SKIP.
END.

OUTPUT STREAM REPORTE CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulos-online) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulos-online Procedure 
PROCEDURE imprimir-rotulos-online :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pxCodDiv AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pxCodDoc AS CHAR NO-UNDO.     /* HPK */
DEFINE INPUT PARAMETER pxNroDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR xtitems-pickeados.
DEFINE INPUT PARAMETER pxSource AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pxNamePrinter AS CHAR NO-UNDO.
/* pxSource - De donde fue invocado :
    CHEQUEO, 
    ORDENES TERMINADAS, 
    ROTULOS BCP ZEBRA,
    ROTULOS MI BANCO ZEBRA,
    ROTULOS BCP, 
    ROTULOS MI BANCO,
    ROTULOS DESPACHO
*/
    
cPrinterName = pxNamePrinter.

RUN imprimir-rotulos(INPUT pxCodDiv, INPUT pxCodDoc, INPUT pxNroDoc, INPUT TABLE xtitems-pickeados, INPUT pxSource ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulos-por-otr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulos-por-otr Procedure 
PROCEDURE imprimir-rotulos-por-otr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pxCodDiv AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pxCodDoc AS CHAR NO-UNDO.     /* OTR */
DEFINE INPUT PARAMETER pxNroDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttitems-pickeados.

x-coddoc = UPPER(pxCodDoc).
x-nrodoc = UPPER(pxNroDoc).
x-coddiv = UPPER(pxCodDiv).  

x-qbulto = 0.

EMPTY TEMP-TABLE rr-w-report.

RUN rotulos-data-otr-compras.

FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN RETURN.   /* No hay data */

RUN rotulos-sectores-imprimir.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprirmir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprirmir Procedure 
PROCEDURE imprirmir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN DO:
    RETURN.
END.

DEFINE VAR lDireccion1 AS CHAR.
DEFINE VAR lDireccion2 AS CHAR.
DEFINE VAR lDirPart1 AS CHAR.
DEFINE VAR lDirPart2 AS CHAR.
DEFINE VAR lbarra AS CHAR.
DEFINE VAR lSede AS CHAR.
DEFINE VAR lRuc AS CHAR.
DEFINE VAR lpedido AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lChequeador AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lFechaEnt AS DATE.
DEFINE VAR lEtiqueta AS CHAR.
DEFINE VAR lpeso AS DEC.
DEFINE VAR lBultos AS CHAR.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lRefOtr AS CHAR.
DEFINE VAR x-almfinal AS CHAR.

DEFINE VAR rpta AS LOG.

DEFINE VAR x-Bulto AS CHAR.

IF USERID("DICTDB") = "CIRH" OR USERID("DICTDB") = "MASTER" OR USERID("DICTDB") = "ADMIN" THEN DO:

    /* ---------------------------------------- */
    DEFINE VAR x-file-zpl AS CHAR.
    
    x-file-zpl = SESSION:TEMP-DIRECTORY + REPLACE("HPK","/","") + "-" + "PRUEBA" + ".txt".
    
    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).

END.
ELSE DO:
    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.

END.

FOR EACH rr-w-report WHERE NO-LOCK BREAK BY rr-w-report.campo-c[19] BY rr-w-report.campo-c[20]:

    /* Los valores */
    lDireccion1 = rr-w-report.campo-c[8].
    lSede = rr-w-report.campo-c[9].
    lRuc = rr-w-report.campo-c[1].
    lPedido = rr-w-report.campo-c[7].
    lCliente = rr-w-report.campo-c[2].
    lDireccion2 = rr-w-report.campo-c[3].
    lChequeador = rr-w-report.campo-c[4].
    lFecha = rr-w-report.campo-d[1].
    lFechaEnt = rr-w-report.campo-d[2].
    lEtiqueta = rr-w-report.campo-c[10]. 
    lPeso = rr-w-report.campo-f[1].
    lBultos = STRING(rr-w-report.campo-i[1]) + " / " + rr-w-report.campo-c[5].   /*TRIM(rr-w-report.campo-c[13])*/
    lBarra = STRING(rr-w-report.llave-c,"99999999999") + STRING(rr-w-report.campo-i[1],"9999").    
    lRefOtr = TRIM(rr-w-report.campo-c[11]).

    /* Ic 08Nov2019, a pedido de Max Ramos */
    lEtiqueta = REPLACE(lEtiqueta,"-","").
    lEtiqueta = REPLACE(lEtiqueta," ","").

    lBarra = lEtiqueta.

    /* Ic - 10Set2018, realmente es el destino Intermedio */
    x-almfinal = TRIM(rr-w-report.campo-c[12]).
    IF s-coddiv <> '00506' THEN DO:
        IF x-almfinal <> "" THEN x-almfinal = "D.INTERMEDIO:" + x-almfinal.
    END.    
    IF rr-w-report.campo-c[14] <> "" THEN DO:
        /* Se imprime el HPR */
        x-almfinal = rr-w-report.campo-c[14].
    END.

    lDireccion2 = TRIM(lDireccion2) + FILL(" ",90).
    lDirPart1 = SUBSTRING(lDireccion2,1,45).
    lDirPart2 = SUBSTRING(lDireccion2,46).

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^FO025,20" SKIP.
    PUT STREAM REPORTE "^ADN,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "CONTINENTAL S.A.C." SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,020" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FDBULTO : " + rr-w-report.campo-c[1] FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */

    PUT STREAM REPORTE "^FO020,050" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FD".
    /*PUT STREAM REPORTE "BULTO : " + lBultos FORMAT 'x(67)' SKIP.*/
    PUT STREAM REPORTE lEtiqueta FORMAT 'x(67)' SKIP.    
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO035,130" SKIP.  /*080*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Direccion:" + lDireccion1 FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,160" SKIP. /*110*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Sede :" + lSede FORMAT 'x(60)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO690,030^BY2" SKIP. 
    PUT STREAM REPORTE "^B3R,N,80,N" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lBarra FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO035,190" SKIP. /*150*/
    PUT STREAM REPORTE "^A0N,60,45" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Nro. " + lPedido FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS".
    /*
    PUT STREAM REPORTE "^FO400,200" SKIP.  /*150*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "RUC:" + lRuc FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO035,250" SKIP.  /*200*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "DESTINO" FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,280" SKIP. /*230*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lCliente FORMAT 'x(70)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,320" SKIP.  /*270*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.  
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart1 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,350" SKIP.   /*320*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart2 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,350" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Chequeador :" + lChequeador FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO035,400" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Fecha :" + STRING(lFecha,"99/99/9999") FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO280,400" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Etiqueta :" + lEtiqueta FORMAT 'x(30)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,450" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTOS : " + lbultos FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO370,450" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "PESO :" + STRING(lPeso,"ZZ,ZZZ,ZZ9.99") FORMAT 'x(19)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,500" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Entrega :" + STRING(lFechaEnt,"99/99/9999") FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
 
    PUT STREAM REPORTE "^FO280,500" SKIP.
    PUT STREAM REPORTE "^A0N,40,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Chequeador : " + lChequeador FORMAT 'x(48)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE x-almfinal FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.

END.

OUTPUT STREAM REPORTE CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lugar-de-entrega) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lugar-de-entrega Procedure 
PROCEDURE lugar-de-entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodPed AS CHAR. /* PED,O/D, OTR */
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE OUTPUT PARAMETER pLugEnt AS CHAR.
DEFINE OUTPUT PARAMETER pUbigeo AS CHAR.
DEFINE OUTPUT PARAMETER pRefer AS CHAR.

pLugEnt = lugar-entrega(pCodPed, pNroped).
pUbigeo = "||".
pRefer = "".

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                    x-faccpedi.coddoc = pCodPed AND
                    x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:
    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
        gn-clie.codcli = x-Faccpedi.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:       
        FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = x-Faccpedi.Ubigeo[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN DO:
            pRefer = TRIM(gn-clieD.referencias).
            pUbigeo = TRIM(gn-clied.coddept) + "|" + TRIM(gn-clied.codprov) + "|" + TRIM(gn-clied.coddist).
        END.            
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rotulos-data-otr-compras) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulos-data-otr-compras Procedure 
PROCEDURE rotulos-data-otr-compras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR dPeso        AS INTEGER   NO-UNDO.
    DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
    DEFINE VAR cDir         AS CHARACTER NO-UNDO.
    DEFINE VAR cSede        AS CHARACTER NO-UNDO.
    DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

    DEFINE VAR lCodRef AS CHAR.
    DEFINE VAR lNroRef AS CHAR.
    DEFINE VAR lCodDoc AS CHAR.
    DEFINE VAR lNroDoc AS CHAR.

    DEFINE VAR lCodRef2 AS CHAR.
    DEFINE VAR lNroRef2 AS CHAR.

    DEFINE VAR x-almfinal AS CHAR.
    DEFINE VAR x-cliente-final AS CHAR.
    DEFINE VAR x-cliente-intermedio AS CHAR.
    DEFINE VAR x-direccion-final AS CHAR.
    DEFINE VAR x-direccion-intermedio AS CHAR.

    DEFINE BUFFER x-almacen FOR almacen.
    DEFINE BUFFER x-pedido FOR faccpedi.
    DEFINE BUFFER x-cotizacion FOR faccpedi.

    DEFINE VAR x-lugar-entrega AS CHAR.
    DEFINE VAR x-referencia AS CHAR.
    DEFINE VAR x-ubigeo AS CHAR.

    DEFINE VAR i-nro AS INT.

    FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia 
        AND Faccpedi.coddiv = x-coddiv
        AND Faccpedi.coddoc = x-coddoc
        AND Faccpedi.nroped = x-nrodoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN RETURN.

    /* NOTA: En estos casos solo hay UN registro de bultos por cada OTR */
    FIND FIRST Ccbcbult WHERE Ccbcbult.codcia = Faccpedi.codcia
        AND Ccbcbult.coddiv = Faccpedi.coddiv
        AND Ccbcbult.coddoc = Faccpedi.coddoc
        AND Ccbcbult.nrodoc = Faccpedi.nroped
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcbult THEN RETURN.

    i-nro = 0.
    /* Vamos a dar tantas vueltas como # de bultos estén registrados,
        además se va a autogenerar la etiqueta del bulto */
    DO i-Nro = 1 TO CcbCBult.Bultos:
        cNomCHq = "".
        lCodDoc = "(" + Ccbcbult.coddoc.
        lNroDoc = Ccbcbult.nrodoc + ")".
        lCodRef = Faccpedi.codref.
        lNroRef = Faccpedi.nroref.
        IF CcbCBult.Chr_02 <> "" THEN DO:
            FIND FIRST Pl-pers WHERE pl-pers.codcia = s-codcia
                AND Pl-pers.codper = CcbCBult.Chr_02  NO-LOCK NO-ERROR.
            IF AVAILABLE Pl-pers 
                THEN cNomCHq = Pl-pers.codper + "-" + TRIM(Pl-pers.patper) + ' ' +
                TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).                
        END.
        /* O/D, OTR, O/M */
        dPeso = Faccpedi.Peso.
        lCodRef2 = Ccbcbult.coddoc.
        lNroRef2 = Ccbcbult.nrodoc.

        RUN lugar-de-entrega(INPUT faccpedi.codref, 
                             INPUT faccpedi.nroref, 
                             OUTPUT x-lugar-entrega, 
                             OUTPUT x-ubigeo, 
                             OUTPUT x-referencia).
        x-cliente-final = faccpedi.nomcli.
        x-direccion-final = x-lugar-entrega.
        x-cliente-intermedio = "".
        x-direccion-intermedio = "".

        /* 19/6/2025: Imprimir el P.I. */
        x-direccion-final = "P.I. " + REPLACE(Faccpedi.NroOrigen,":","-").

        /* CrossDocking almacen FINAL */
        x-almfinal = "".

        /*Datos Sede de Venta*/
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
        IF AVAIL gn-divi THEN 
            ASSIGN 
                cDir = GN-DIVI.DirDiv
                cSede = GN-DIVI.CodDiv + " " + GN-DIVI.DesDiv.
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = s-CodAlm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

        CREATE rr-w-report.
        ASSIGN 
            rr-w-report.Task-No  = s-task-no
            rr-w-report.Llave-C  = "01" + faccpedi.nroped
            rr-w-report.Campo-C[1] = faccpedi.ruc
            rr-w-report.Campo-C[2] = x-cliente-final 
            rr-w-report.Campo-C[3] = x-direccion-final
            rr-w-report.Campo-C[4] = cNomChq
            rr-w-report.Campo-D[1] = faccpedi.fchped
            rr-w-report.Campo-C[5] = STRING(Ccbcbult.bultos,'9999')
            rr-w-report.Campo-F[1] = dPeso
            rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2
            rr-w-report.Campo-I[1] = i-nro
            rr-w-report.Campo-C[8] = cDir
            rr-w-report.Campo-C[9] = cSede
            rr-w-report.Campo-C[10] = "CO" + STRING(i-Nro,'999')
            rr-w-report.Campo-D[2] = Faccpedi.fchent
            rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
            rr-w-report.campo-c[12] = x-cliente-intermedio   /*x-almfinal.*/
            rr-w-report.campo-c[13] = Faccpedi.ordcmp.

    END.
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rotulos-sectores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulos-sectores Procedure 
PROCEDURE rotulos-sectores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE rr-w-report.

RUN rotulos-sectores-data.

FIND FIRST rr-w-report NO-LOCK NO-ERROR.

IF NOT AVAILABLE rr-w-report THEN RETURN.   /* No hay data */

RUN rotulos-sectores-imprimir.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rotulos-sectores-data) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulos-sectores-data Procedure 
PROCEDURE rotulos-sectores-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*  
    SECTORES CIERREBULTO
    SECTORES CIERREORDEN
    SECTORES
*/

DEFINE VAR cOrigen AS CHAR.

cOrigen = REPLACE(x-origen,"SECTORES","").
cOrigen = REPLACE(cOrigen," ","").

IF cOrigen = "CIERREBULTO" THEN DO:    
    RUN rotulos-sectores-data-bulto.
END.
ELSE DO:
    RUN rotulos-sectores-data-orden.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rotulos-sectores-data-bulto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulos-sectores-data-bulto Procedure 
PROCEDURE rotulos-sectores-data-bulto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR dPeso        AS INTEGER   NO-UNDO.
    DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
    DEFINE VAR cDir         AS CHARACTER NO-UNDO.
    DEFINE VAR cSede        AS CHARACTER NO-UNDO.
    DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

    DEFINE VAR lCodRef AS CHAR.
    DEFINE VAR lNroRef AS CHAR.
    DEFINE VAR lCodDoc AS CHAR.
    DEFINE VAR lNroDoc AS CHAR.

    DEFINE VAR lCodRef2 AS CHAR.
    DEFINE VAR lNroRef2 AS CHAR.

    DEFINE VAR x-almfinal AS CHAR.
    DEFINE VAR x-cliente-final AS CHAR.
    DEFINE VAR x-cliente-intermedio AS CHAR.
    DEFINE VAR x-direccion-final AS CHAR.
    DEFINE VAR x-direccion-intermedio AS CHAR.

    DEFINE BUFFER x-almacen FOR almacen.
    DEFINE BUFFER x-pedido FOR faccpedi.
    DEFINE BUFFER x-cotizacion FOR faccpedi.

    DEFINE VAR x-lugar-entrega AS CHAR.
    DEFINE VAR x-referencia AS CHAR.
    DEFINE VAR x-ubigeo AS CHAR.

    DEFINE VAR x-UsrChq AS CHAR.

    cNomCHq = "".
    lCodDoc = "".
    lNroDoc = "".

    x-UsrChq = s-user-id.

    FIND FIRST _user WHERE _user._userid = x-UsrChq NO-LOCK NO-ERROR.
    IF AVAILABLE _user THEN DO:
        cNomCHq = x-UsrChq + "-" + _user._User-Name.
    END.
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.divdes = s-coddiv
        AND faccpedi.coddoc = x-coddoc      /* O/D, OTR, P/M */
        AND faccpedi.nroped = x-nrodoc NO-LOCK NO-ERROR. 

    IF NOT AVAILABLE faccpedi THEN RETURN "ADM-ERROR".

    dPeso = 0.
    x-qbulto = 0.
    x-bulto = "".
    FOR EACH ttitems-pickeados NO-LOCK BREAK BY Campo-C[4]:
        FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND almmmatg.codmat = ttitems-pickeados.Campo-C[2] NO-LOCK NO-ERROR.

        IF FIRST-OF(ttitems-pickeados.Campo-C[4]) THEN DO:
            dPeso = 0.
            x-qbulto = ttitems-pickeados.Campo-i[15].
            x-bulto = ttitems-pickeados.Campo-C[4].
        END.

        IF AVAILABLE almmmatg THEN DO:
            dPeso = dPeso + ((ttitems-pickeados.Campo-F[2] * ttitems-pickeados.Campo-F[3]) * almmmatg.pesmat).
        END.
        IF LAST-OF(ttitems-pickeados.Campo-C[4]) THEN DO:
            /* dPeso = 0* sumar los pesos DEL tempo*/
            lCodRef2 = x-coddoc.
            lNroRef2 = x-nrodoc.

            RUN lugar-de-entrega(INPUT faccpedi.codref, INPUT faccpedi.nroref, 
                                 OUTPUT x-lugar-entrega, OUTPUT x-ubigeo, OUTPUT x-referencia).

            x-cliente-final = faccpedi.nomcli.
            /*x-direccion-final = faccpedi.dircli.*/
            x-direccion-final = x-lugar-entrega.

            x-cliente-intermedio = "".
            x-direccion-intermedio = "".

            /* CrossDocking almacen FINAL */
            x-almfinal = "".

            /* CrossDocking almacen FINAL */
            x-almfinal = "".
            IF faccpedi.crossdocking = YES THEN DO: 
                lCodRef2 = faccpedi.codref.
                lNroRef2 = faccpedi.nroref.
                lCodDoc = "(" + x-coddoc.
                lNroDoc = x-nrodoc + ")".

                x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
                x-direccion-intermedio = faccpedi.dircli.

                IF faccpedi.codref = 'R/A' THEN DO:
                    FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                                x-almacen.codalm = faccpedi.almacenxD
                                                NO-LOCK NO-ERROR.
                    IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion). /*x-almfinal = TRIM(x-almacen.descripcion).*/
                    IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm). /*x-almfinal = TRIM(x-almacen.descripcion).*/
                END.
            END.

            /* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
            /* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
            /* Crossdocking */
            IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
                lCodDoc = "(" + x-coddoc.
                lNroDoc = x-nrodoc + ")".
                lCodRef = faccpedi.codref.
                lNroRef = faccpedi.nroref.
                RELEASE faccpedi.

                FIND faccpedi WHERE faccpedi.codcia = s-codcia
                    AND faccpedi.coddoc = lCodRef
                    AND faccpedi.nroped = lNroRef
                    NO-LOCK NO-ERROR.
                IF NOT AVAIL faccpedi THEN DO:
                    /*"Pedido de Referencia de la OTR no existe" lCodRef lNroRef*/
                    RETURN "ADM-ERROR".
                END.
                x-cliente-final = "".
                IF x-CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
                x-cliente-final = x-cliente-final + faccpedi.nomcli.
                x-direccion-final = faccpedi.dircli.
            END.
            /* Ic - 02Dic2016 - FIN */

            /*Datos Sede de Venta*/
            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
                AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
            IF AVAIL gn-divi THEN 
                ASSIGN 
                    cDir = INTEGRAL.GN-DIVI.DirDiv
                    cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
            FIND Almacen WHERE Almacen.codcia = s-codcia
                AND Almacen.codalm = s-CodAlm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

            CREATE rr-w-report.
            ASSIGN 
                /*i-nro             = 0 i-nro + 1*/
                rr-w-report.Task-No  = s-task-no
                rr-w-report.Llave-C  = "01" + faccpedi.nroped
                rr-w-report.Campo-C[1] = faccpedi.ruc
                rr-w-report.Campo-C[2] = x-cliente-final   /*faccpedi.nomcli*/
                rr-w-report.Campo-C[3] = x-direccion-final   /*faccpedi.dircli*/
                rr-w-report.Campo-C[4] = cNomChq
                rr-w-report.Campo-D[1] = faccpedi.fchped
                rr-w-report.Campo-C[5] = "0"   /*STRING(Ccbcbult.bultos,'9999')*/
                rr-w-report.Campo-F[1] = dPeso
                rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 /*faccpedi.nroped*/
                rr-w-report.Campo-I[1] = x-qbulto /* i-nro */
                rr-w-report.Campo-C[8] = cDir
                rr-w-report.Campo-C[9] = cSede
                rr-w-report.Campo-C[10] = x-bulto
                rr-w-report.Campo-D[2] = faccpedi.fchent
                rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
                rr-w-report.campo-c[12] = x-cliente-intermedio   /*x-almfinal.*/
                rr-w-report.campo-c[13] = faccpedi.ordcmp.

            /* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
            /*MESSAGE "pedido" faccpedi.nroref.*/
            IF s-coddiv = '00506' THEN DO:
                /* Busco el Pedido */
                FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                            x-pedido.coddoc = faccpedi.codref AND 
                                            x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
                IF AVAILABLE x-pedido THEN DO:
                    /*MESSAGE "cotizacion" x-pedido.nroref.*/
                    /* Busco la Cotizacion */
                    FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                                x-cotizacion.coddoc = x-pedido.codref AND 
                                                x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
                    IF AVAILABLE x-cotizacion THEN DO:
                        /*MESSAGE "Ref " x-cotizacion.nroref.*/
                        ASSIGN rr-w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref).
                    END.
                END.
            END.
        END.
    END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rotulos-sectores-data-orden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulos-sectores-data-orden Procedure 
PROCEDURE rotulos-sectores-data-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR dPeso        AS INTEGER   NO-UNDO.
    DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
    DEFINE VAR cDir         AS CHARACTER NO-UNDO.
    DEFINE VAR cSede        AS CHARACTER NO-UNDO.
    DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

    DEFINE VAR lCodRef AS CHAR.
    DEFINE VAR lNroRef AS CHAR.
    DEFINE VAR lCodDoc AS CHAR.
    DEFINE VAR lNroDoc AS CHAR.

    DEFINE VAR lCodRef2 AS CHAR.
    DEFINE VAR lNroRef2 AS CHAR.

    DEFINE VAR x-almfinal AS CHAR.
    DEFINE VAR x-cliente-final AS CHAR.
    DEFINE VAR x-cliente-intermedio AS CHAR.
    DEFINE VAR x-direccion-final AS CHAR.
    DEFINE VAR x-direccion-intermedio AS CHAR.

    DEFINE BUFFER x-almacen FOR almacen.
    DEFINE BUFFER x-pedido FOR faccpedi.
    DEFINE BUFFER x-cotizacion FOR faccpedi.

    DEFINE VAR x-lugar-entrega AS CHAR.
    DEFINE VAR x-referencia AS CHAR.
    DEFINE VAR x-ubigeo AS CHAR.

    DEFINE VAR i-nro AS INT.

    FIND FIRST CcbCBult WHERE CcbCBult.codcia = 1 AND CcbCBult.coddiv = x-coddiv AND
                                CcbCBult.coddoc = x-coddoc AND CcbCBult.nrodoc = x-nrodoc NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ccbcbult THEN RETURN.

    i-nro = 0.
    FOR EACH ControlOD NO-LOCK WHERE ControlOD.CodCia = CcbCBult.CodCia 
        AND ControlOD.CodDiv = CcbCBult.CodDiv 
        AND ControlOD.CodDoc = CcbCBult.CodDoc 
        AND ControlOD.NroDoc = CcbCBult.NroDoc:

        cNomCHq = "".
        lCodDoc = "".
        lNroDoc = "".
        IF CcbCBult.Chr_02 <> "" THEN DO:
            FIND FIRST Pl-pers WHERE pl-pers.codcia = s-codcia
                AND Pl-pers.codper = CcbCBult.Chr_02  NO-LOCK NO-ERROR.
            IF AVAILABLE Pl-pers 
                THEN cNomCHq = Pl-pers.codper + "-" + TRIM(Pl-pers.patper) + ' ' +
                    TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).                
        END.
        /* O/D, OTR, O/M */
        FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
            AND faccpedi.divdes = s-coddiv
            AND faccpedi.coddoc = Ccbcbult.coddoc   
            AND faccpedi.nroped = Ccbcbult.nrodoc NO-LOCK NO-ERROR. 
        IF NOT AVAIL faccpedi THEN DO:
            MESSAGE "Documento no registrado:" Ccbcbult.coddoc Ccbcbult.nrodoc
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "ADM-ERROR".
        END.
        dPeso = ControlOD.PesArt.  
        lCodRef2 = Ccbcbult.coddoc.
        lNroRef2 = Ccbcbult.nrodoc.

        RUN lugar-de-entrega(INPUT faccpedi.codref, INPUT faccpedi.nroref, 
                             OUTPUT x-lugar-entrega, OUTPUT x-ubigeo, OUTPUT x-referencia).

        x-cliente-final = faccpedi.nomcli.
        /*x-direccion-final = faccpedi.dircli.*/
        x-direccion-final = x-lugar-entrega.

        x-cliente-intermedio = "".
        x-direccion-intermedio = "".

        /* CrossDocking almacen FINAL */
        x-almfinal = "".
        IF faccpedi.crossdocking = YES THEN DO:
            lCodRef2 = faccpedi.codref.
            lNroRef2 = faccpedi.nroref.
            lCodDoc = "(" + Ccbcbult.coddoc.
            lNroDoc = Ccbcbult.nrodoc + ")".

            x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
            x-direccion-intermedio = faccpedi.dircli.

            IF faccpedi.codref = 'R/A' THEN DO:
                FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                            x-almacen.codalm = faccpedi.almacenxD
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion). /*x-almfinal = TRIM(x-almacen.descripcion).*/
                IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm). /*x-almfinal = TRIM(x-almacen.descripcion).*/
            END.
        END.

        /* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
        /* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
        /* Crossdocking */
        IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
            lCodDoc = "(" + Ccbcbult.coddoc.
            lNroDoc = Ccbcbult.nrodoc + ")".
            lCodRef = faccpedi.codref.
            lNroRef = faccpedi.nroref.
            RELEASE faccpedi.

            FIND faccpedi WHERE faccpedi.codcia = s-codcia
                AND faccpedi.coddoc = lCodRef
                AND faccpedi.nroped = lNroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAIL faccpedi THEN DO:
                MESSAGE "Pedido de Referencia de la OTR no existe" lCodRef lNroRef
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "ADM-ERROR".
            END.
            x-cliente-final = "".
            IF CcbCBult.CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
            x-cliente-final = x-cliente-final + faccpedi.nomcli.
            x-direccion-final = faccpedi.dircli.
        END.
        /* Ic - 02Dic2016 - FIN */

        /*Datos Sede de Venta*/
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
        IF AVAIL gn-divi THEN 
            ASSIGN 
                cDir = INTEGRAL.GN-DIVI.DirDiv
                cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = s-CodAlm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

        CREATE rr-w-report.
        ASSIGN 
            i-nro             = i-nro + 1
            rr-w-report.Task-No  = s-task-no
            rr-w-report.Llave-C  = "01" + faccpedi.nroped
            rr-w-report.Campo-C[1] = faccpedi.ruc
            rr-w-report.Campo-C[2] = x-cliente-final   /*faccpedi.nomcli*/
            rr-w-report.Campo-C[3] = x-direccion-final   /*faccpedi.dircli*/
            rr-w-report.Campo-C[4] = cNomChq
            rr-w-report.Campo-D[1] = faccpedi.fchped
            rr-w-report.Campo-C[5] = STRING(Ccbcbult.bultos,'9999')
            rr-w-report.Campo-F[1] = dPeso
            rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 /*faccpedi.nroped*/
            rr-w-report.Campo-I[1] = i-nro
            rr-w-report.Campo-C[8] = cDir
            rr-w-report.Campo-C[9] = cSede
            rr-w-report.Campo-C[10] = ControlOD.NroEtq
            rr-w-report.Campo-D[2] = faccpedi.fchent
            rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
            rr-w-report.campo-c[12] = x-cliente-intermedio   /*x-almfinal.*/
            rr-w-report.campo-c[13] = faccpedi.ordcmp.

            /* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
            /*MESSAGE "pedido" faccpedi.nroref.*/
            IF s-coddiv = '00506' THEN DO:
                /* Busco el Pedido */
                FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                            x-pedido.coddoc = faccpedi.codref AND 
                                            x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
                IF AVAILABLE x-pedido THEN DO:
                    /*MESSAGE "cotizacion" x-pedido.nroref.*/
                    /* Busco la Cotizacion */
                    FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                                x-cotizacion.coddoc = x-pedido.codref AND 
                                                x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
                    IF AVAILABLE x-cotizacion THEN DO:
                        /*MESSAGE "Ref " x-cotizacion.nroref.*/
                        ASSIGN rr-w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref).
                    END.
                END.
            END.

    END.
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rotulos-sectores-imprimir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulos-sectores-imprimir Procedure 
PROCEDURE rotulos-sectores-imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lDireccion1 AS CHAR.
DEFINE VAR lDireccion2 AS CHAR.
DEFINE VAR lDirPart1 AS CHAR.
DEFINE VAR lDirPart2 AS CHAR.
DEFINE VAR lbarra AS CHAR.
DEFINE VAR lSede AS CHAR.
DEFINE VAR lRuc AS CHAR.
DEFINE VAR lpedido AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lChequeador AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lFechaEnt AS DATE.
DEFINE VAR lEtiqueta AS CHAR.
DEFINE VAR lpeso AS DEC.
DEFINE VAR lBultos AS CHAR.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lRefOtr AS CHAR.
DEFINE VAR x-almfinal AS CHAR.

DEFINE VAR lOrdenCompra AS CHAR.

DEFINE VAR rpta AS LOG.

IF USERID("DICTDB") = "CIRH" OR USERID("DICTDB") = "MASTER" OR USERID("DICTDB") = "ADMIN" THEN DO:

    /* ---------------------------------------- */
    DEFINE VAR x-file-zpl AS CHAR.
    
    x-file-zpl = SESSION:TEMP-DIRECTORY + REPLACE("HPK","/","") + "-" + "PRUEBA" + ".txt".
    
    OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).

END.
ELSE DO:
    IF TRUE <> (cPrinterName > "") THEN DO:
        SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
        IF rpta = NO THEN RETURN.

        OUTPUT STREAM REPORTE TO PRINTER.
    END.
    ELSE DO:
        SESSION:PRINTER-NAME = cPrinterName.
        OUTPUT STREAM REPORTE TO PRINTER.
        /*
        s-printer-name = cPrinterName.
        s-salida-impresion = 2.
        /* Falta verificar que la impresora exista */
    
        RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).        
        */
    END.
END.

FOR EACH rr-w-report NO-LOCK:

    /* Los valores */
    lDireccion1 = rr-w-report.campo-c[8].
    lSede = rr-w-report.campo-c[9].
    lRuc = rr-w-report.campo-c[1].
    lPedido = rr-w-report.campo-c[7].
    lCliente = rr-w-report.campo-c[2].
    lDireccion2 = rr-w-report.campo-c[3].
    lChequeador = rr-w-report.campo-c[4].
    lFecha = rr-w-report.campo-d[1].
    lFechaEnt = rr-w-report.campo-d[2].
    lEtiqueta = rr-w-report.campo-c[10].
    lPeso = rr-w-report.campo-f[1].
    lBultos = STRING(rr-w-report.campo-i[1],"9999") + " / " + rr-w-report.campo-c[5].
    lBarra = STRING(rr-w-report.llave-c,"99999999999") + STRING(rr-w-report.campo-i[1],"9999").
    lFiler = "F-OPE-01-01".

    lRefOtr = TRIM(rr-w-report.campo-c[11]).
    lOrdenCompra = TRIM(rr-w-report.campo-c[13]).

    IF NOT (TRUE <> (lOrdenCompra > "")) THEN lOrdenCompra = "O/C.:" + lOrdenCompra.

    /* Ic - 10Set2018, realmente es el destino Intermedio */
    x-almfinal = TRIM(rr-w-report.campo-c[12]).
    IF s-coddiv <> '00506' THEN DO:
        IF x-almfinal <> "" THEN x-almfinal = "D.INTERMEDIO:" + x-almfinal.
    END.    

    lDireccion2 = TRIM(lDireccion2) + FILL(" ",90).
    lDirPart1 = SUBSTRING(lDireccion2,1,45).
    lDirPart2 = SUBSTRING(lDireccion2,46).

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^FO025,20" SKIP.
    PUT STREAM REPORTE "^ADN,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "CONTINENTAL S.A.C." SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,080" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Direccion:" + lDireccion1 FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,110" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Sede :" + lSede FORMAT 'x(60)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO690,030^BY2" SKIP.
    PUT STREAM REPORTE "^B3R,N,80,N" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lBarra FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO035,150" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Nro. " + lPedido FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO400,150" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "RUC:" + lRuc FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,200" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "DESTINO" FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO400,200" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lOrdenCompra FORMAT 'x(30)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,230" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lCliente FORMAT 'x(50)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,270" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.  
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart1 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,300" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart2 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,350" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Chequeador :" + lChequeador FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,400" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Fecha :" + STRING(lFecha,"99/99/9999") FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,400" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Etiqueta :" + lEtiqueta FORMAT 'x(28)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,450" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTOS :" + lbultos FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,450" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "PESO :" + STRING(lPeso,"ZZ,ZZZ,ZZ9.99") FORMAT 'x(19)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,500" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Entrega :" + STRING(lFechaEnt,"99/99/9999") FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO400,500" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lFiler FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO350,500" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.


    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE x-almfinal FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    /*
    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    /*
    PUT STREAM REPORTE "^FO400,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lFiler FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^XZ" SKIP.
END.

OUTPUT STREAM REPORTE CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rotulos-sectores-online) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rotulos-sectores-online Procedure 
PROCEDURE rotulos-sectores-online :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pxCodDiv AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pxCodDoc AS CHAR NO-UNDO.     /* HPK */
DEFINE INPUT PARAMETER pxNroDoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR xtitems-pickeados.
DEFINE INPUT PARAMETER pxSource AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pxNamePrinter AS CHAR NO-UNDO.
/* pxSource - De donde fue invocado :
    CHEQUEO, 
    ORDENES TERMINADAS, 
    ROTULOS BCP ZEBRA,
    ROTULOS MI BANCO ZEBRA,
    ROTULOS BCP, 
    ROTULOS MI BANCO,
    ROTULOS DESPACHO
    SECTORES CIERREBULTO|######         ######:codigo de bulto
    SECTORES CIERREORDEN
    SECTORES ORDEN
*/
    
cPrinterName = pxNamePrinter.

RUN imprimir-rotulos(INPUT pxCodDiv, INPUT pxCodDoc, INPUT pxNroDoc, INPUT TABLE xtitems-pickeados, INPUT pxSource ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fChequeador) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fChequeador Procedure 
FUNCTION fChequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR INIT "".
DEFINE VAR x-dni AS CHAR INIT "".
DEFINE VAR x-origen AS CHAR INIT "".


    IF pCodDoc = 'HPK' THEN DO:
        
        FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                        x-vtacdocu.codped = pCodDOc AND
                                        x-vtacdocu.nroped = pNroPEd NO-LOCK NO-ERROR.
        IF AVAILABLE x-vtacdocu THEN DO:
            IF NOT (TRUE <> (x-vtacdocu.libre_c04 > "")) THEN DO:
                x-dni = ENTRY(1,x-vtacdocu.libre_c04,"|").
                RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
            END.            
        END.
    END.
    ELSE DO:        
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                        x-faccpedi.coddoc = pCodDoc AND 
                                        x-faccpedi.nroped = pNroPed NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            IF NOT (TRUE <> (x-faccpedi.usrchq > "")) THEN DO:
                x-dni = x-faccpedi.usrchq.
                RUN logis/p-busca-por-dni.r(INPUT x-dni, OUTPUT x-retval, OUTPUT x-origen).
            END.            
        END.
    END.

    IF x-retval = "" THEN DO:
        
        /* Verificamos si fue invocado desde checking en linea */
        IF NOT (TRUE <> (x-el-chequeador > "")) THEN x-dni = TRIM(x-el-chequeador).

        /* buscarlo si existe en la maestra de personal */
        FIND FIRST pl-pers WHERE  pl-pers.codper = x-dni NO-LOCK NO-ERROR.
        IF  AVAILABLE pl-pers THEN DO:
            x-retval = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
        END.
    END.
    IF x-retval = "" THEN DO:
        x-retval = "(" + x-el-chequeador + ")".
    END.


RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fpeso-orden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fpeso-orden Procedure 
FUNCTION fpeso-orden RETURNS DECIMAL
  ( INPUT pCodOrden AS CHAR, INPUT pNroOrden AS CHAR, 
    INPUT pCodHPK AS CHAR, INPUT pNroPHK AS CHAR,
    INPUT pCodBulto AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS DEC INIT 0.
  DEFINE VAR x-bulto AS CHAR INIT "".

  IF pCodHPK = 'HPK' THEN DO:
      FOR EACH logisdchequeo WHERE logisdchequeo.codcia = s-codcia AND
                                    logisdchequeo.etiqueta = pCodBulto NO-LOCK,
            FIRST almmmatg OF logisdchequeo NO-LOCK:
            x-retval = x-retval + ROUND(logisdchequeo.canchk * logisdchequeo.factor * almmmatg.pesmat, 2).
      END.
  END.
  ELSE DO:
      FOR EACH x-vtaddocu WHERE x-vtaddocu.codcia = s-codcia AND
                                x-vtaddocu.codped = pCodOrden AND
                                x-vtaddocu.nroped = pNroOrden AND
                                x-vtaddocu.libre_c01 BEGINS x-bulto NO-LOCK,
          FIRST Almmmatg OF x-Vtaddocu NO-LOCK:
          /*x-retval = x-retval + (x-vtaddocu.pesmat * x-vtaddocu.canped).*/
          x-retval = x-retval + ROUND(x-vtaddocu.canped * x-vtaddocu.factor * Almmmatg.pesmat, 2).
      END.
  END.
  RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lugar-entrega) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lugar-entrega Procedure 
FUNCTION lugar-entrega RETURNS CHARACTER
  ( INPUT pCodPed AS CHAR, INPUT pNroPed AS CHAR ) :

    DEFINE VAR x-retval AS CHAR INIT "".

    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = pCodPed AND
                            x-faccpedi.nroped = pNroped NO-LOCK NO-ERROR.

    IF AVAILABLE x-faccpedi THEN DO:
    
        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
            gn-clie.codcli = x-Faccpedi.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            x-retval = "".  /*gn-clie.dircli.*/
            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = x-Faccpedi.Ubigeo[1]
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN x-retval = Gn-ClieD.DirCli.
        END.
    END.

  RETURN x-retval.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

