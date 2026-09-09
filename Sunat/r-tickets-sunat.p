&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-bole01.p
    Purpose     : Impresion de Fact/Boletas 
    Syntax      :
    Description :
    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.
DEFINE INPUT PARAMETER pTipo   AS CHAR.
DEFINE INPUT PARAMETER pImpresora AS LOG.
/* pTipo:
    "O": ORIGINAL 
    "C": COPIA 
   pImpresora:
   YES: Pre-definida en el correlativo
   NO:  Seleccionar
*/    

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

/* 
    Ic - 21Dic2016, si no tiene HASH, intentar enviar el a PPLL
*/
DEFINE VAR lVeces AS INT.
DEFINE VAR lSec1 AS INT.
DEFINE VAR lRetVal AS CHAR.

lVeces = 5.
REPEAT lSec1 = 1 TO lVeces:
    FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND 
                                        FELogComprobantes.coddiv = ccbcdocu.coddiv AND 
                                        FELogComprobantes.coddoc = ccbcdocu.coddoc AND 
                                        FELogComprobantes.nrodoc = ccbcdocu.nrodoc
                                        NO-LOCK NO-ERROR.
    IF AVAILABLE FELogComprobantes THEN DO:
        lSec1 = lVeces + 5.
    END.
    ELSE DO:
        lRetVal = "".
        /*RUN sunat/progress-to-ppll(ROWID(ccbcdocu), OUTPUT lRetVal).*/
        RUN sunat/progress-to-ppll-v21(ROWID(ccbcdocu), INPUT-OUTPUT TABLE T-FELogErrores, OUTPUT lRetVal).
        RUN grabar-log-errores.
    END.
END.
/* Ic - 21Dic2016 - FIN  */

/* Ic - 28Nov2016, Verificar si el documento tiene HASH para la impresion */
FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND 
                                    FELogComprobantes.coddiv = ccbcdocu.coddiv AND 
                                    FELogComprobantes.coddoc = ccbcdocu.coddoc AND 
                                    FELogComprobantes.nrodoc = ccbcdocu.nrodoc
                                    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FELogComprobantes THEN DO:
    MESSAGE "Documento aun no ha sido enviado a SUNAT" SKIP(1)
        "Se procede a CERRAR el SISTEMA por SEGURIDAD. Volver a entrar y repita el proceso."
        VIEW-AS ALERT-BOX ERROR.
    QUIT.

END.
IF TRUE <> (FELogComprobantes.codhash > "") THEN DO:
    MESSAGE "El documento NO TIENE el timbre(HASH) de seguridad de la SUNAT " SKIP(1)
        "Se procede a CERRAR el SISTEMA por SEGURIDAD. Volver a entrar y repita el proceso."
        VIEW-AS ALERT-BOX ERROR.
    QUIT.

END.
/* Ic - 28Nov2016 - Fin */

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.

DEF VAR C-NomCon   AS CHAR FORMAT "X(40)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR x-Percepcion AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR X-Cheque   AS CHAR    NO-UNDO.
DEF VAR C-MONEDA   AS CHAR FORMAT "x(8)"  NO-UNDO.
DEF VAR N-Item     AS INTEGER NO-UNDO.
DEF VAR X-impbrt   AS DECIMAL NO-UNDO.
DEF VAR X-dscto1   AS DECIMAL NO-UNDO.
DEF VAR X-preuni   AS DECIMAL NO-UNDO.
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".
DEF VAR X-PUNTOS   AS CHAR FORMAT "X(40)".
DEF VAR X-LIN1     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN1A    AS CHAR FORMAT "X(40)".
DEF VAR X-LIN2     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN3     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN4     AS CHAR FORMAT "X(30)".
DEF VAR X-LIN4A    AS CHAR FORMAT "X(30)".
DEF VAR X-LIN5     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN6     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN7     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN8     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN9     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN10    AS CHAR FORMAT "X(30)".
DEF VAR X-LIN11    AS CHAR FORMAT "X(40)".
DEF VAR x-Lin12    AS CHAR FORMAT 'x(40)'.
DEF VAR x-lin13   AS CHAR FORMAT 'x(40)'.
DEF VAR X-MAQ      AS CHAR FORMAT "X(40)".
DEF VAR X-CANCEL   AS CHAR FORMAT "X(10)".

DEF VAR X-SOL      AS DECI INIT 0.
DEF VAR X-DOL      AS DECI INIT 0.
DEF VAR X-VUE      AS DECI INIT 0.
DEF VAR x-TarCreSol AS DEC INIT 0 NO-UNDO.
DEF VAR x-TarCreDol AS DEC INIT 0 NO-UNDO.


/*Variables Promociones*/
DEF VAR x-promo01 AS CHARACTER NO-UNDO FORMAT 'X(40)'.
DEF VAR x-promo02 AS CHARACTER NO-UNDO FORMAT 'X(40)'.


C-MONEDA = IF ccbcdocu.codmon = 1 THEN "SOLES" ELSE "DOLARES".

C-NomCon = "".


FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
IF AVAIL CcbDdocu THEN DO:
    FIND Almacen WHERE Almacen.CodCia = ccbcdocu.codcia 
                  AND  Almacen.CodAlm = CcbDDocu.AlmDes 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN 
        ASSIGN C-DESALM = Almacen.CodAlm + " - " + Almacen.Descripcion.
END.
ELSE DO:
    FIND Almacen WHERE Almacen.CodCia = ccbcdocu.codcia 
                  AND  Almacen.CodAlm = ccbcdocu.codalm 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN 
        ASSIGN C-DESALM = Almacen.CodAlm + " - " + Almacen.Descripcion.
END.

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN 
   ASSIGN C-NomCon = gn-ConVt.Nombr.

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").
 
/*MLR* 28/12/07 ***/
DEF VAR cNroIC LIKE CcbDCaja.Nrodoc NO-UNDO.

/* Verifica que la cancelación se realizó con CHEQUE */
x-cheque = "".
IF CcbCDocu.Flgest = 'C' THEN DO:
    FOR EACH CcbDCaja WHERE
        CcbDCaja.CodCia = s-codcia AND
        CcbDCaja.CodRef = CcbCDocu.Coddoc AND
        CcbDCaja.NroRef = CcbCDocu.Nrodoc NO-LOCK,
        FIRST ccbccaja WHERE
        ccbccaja.codcia = ccbdcaja.codcia AND
        ccbccaja.coddiv = ccbdcaja.coddiv AND
        ccbccaja.coddoc = ccbdcaja.coddoc AND
        ccbccaja.nrodoc = ccbdcaja.nrodoc NO-LOCK:
        cNroIC = CcbDCaja.Nrodoc.

         x-cheque = TRIM(CcbCCaja.Voucher[2]) + TRIM(CcbCCaja.Voucher[3]).
         IF CcbCCaja.CodBco[2] <> '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = CcbCCaja.CodBco[2]
                         NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN
               x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
         END.
         IF CcbCCaja.CodBco[3] <> '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = CcbCCaja.CodBco[3]
                         NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN 
               x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
         END.
         IF CcbcCaja.ImpNac[1] + CcbCCaja.ImpUsa[1] > 0 Then x-cancel = x-cancel + ",Efectivo".
         IF CcbcCaja.ImpNac[2] + CcbCCaja.ImpUsa[2] + CcbcCaja.ImpNac[3] + CcbCCaja.ImpUsa[3] > 0 Then x-cancel = x-cancel + ",Cheque".
         IF CcbcCaja.ImpNac[4] + CcbCCaja.ImpUsa[4] > 0 Then x-cancel = x-cancel + ",Tarjeta".
         x-sol = CcbcCaja.ImpNac[1] + CcbcCaja.ImpNac[2] + CcbcCaja.ImpNac[3] + CcbcCaja.ImpNac[4].
         x-dol = CcbcCaja.ImpUsa[1] + CcbcCaja.ImpUsa[2] + CcbcCaja.ImpUsa[3] + CcbcCaja.ImpUsa[4].
         x-vue = CcbCCaja.VueNac .
         x-TarCreSol = CcbcCaja.ImpNac[4].
         x-TarCreDol = CcbcCaja.ImpUsa[4].
   END.

  FIND FIRST CcbDCaja WHERE
        CcbDCaja.CodCia = s-codcia AND
        CcbDCaja.CodRef = CcbCDocu.Coddoc AND
        CcbDCaja.NroRef = CcbCDocu.Nrodoc NO-LOCK.
  IF AVAILABLE CcbDCaja THEN DO:
      FIND FIRST ccbccaja OF ccbdcaja NO-LOCK.
  END.
        
END.

/* Caracteres x Linea */
DEFINE VAR lCaracxlinea AS INT INIT 38.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fCentrado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCentrado Procedure 
FUNCTION fCentrado RETURNS CHARACTER
  ( INPUT pDatos AS CHAR, INPUT pWidth AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCentrar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCentrar Procedure 
FUNCTION fCentrar RETURNS INTEGER
    ( INPUT pDatos AS CHAR, INPUT pWidth AS INT )  FORWARD.

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
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.69
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
IF pImpresora = YES THEN DO:
    FIND FacCorre WHERE 
         FacCorre.CodCia = Ccbcdocu.codcia AND 
         FacCorre.CodDiv = Ccbcdocu.coddiv AND
         FacCorre.CodDoc = ccbcdocu.coddoc AND
         FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc, 1, 3)) NO-LOCK.

    IF USERID("integral") = "MASTER" THEN DO:
        RUN lib/_port-name ("Tickets", OUTPUT s-port-name).
    END.
    ELSE DO:
        RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
    END.
    IF s-port-name = '' THEN DO:
        MESSAGE 'NO está definida la impresora por defecto' SKIP
            'División:' Ccbcdocu.coddiv SKIP
            'Documento:' Ccbcdocu.coddoc SKIP
            'N° Serie:' SUBSTRING(CcbCDocu.NroDoc, 1, 3) SKIP
            'Impresora:' FacCorre.Printer
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    IF s-OpSys = 'WinVista'
    THEN OUTPUT TO PRINTER VALUE(s-port-name).
    ELSE OUTPUT TO VALUE(s-port-name).
END.
ELSE DO:
    DEF VAR answer AS LOGICAL NO-UNDO.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
    IF NOT answer THEN RETURN.
    OUTPUT TO PRINTER.
END.

DEFINE VAR lNombreTienda AS CHAR.
DEFINE VAR lSlogan AS CHAR.
DEFINE VAR lSlogan2 AS CHAR.
DEFINE VAR lEmpresa AS CHAR.
DEFINE VAR lRUC AS CHAR.
DEFINE VAR lDirEmpresa AS CHAR.
DEFINE VAR lDirEmpresa2 AS CHAR.
DEFINE VAR lDirTienda AS CHAR.
DEFINE VAR lDirTienda1 AS CHAR.
DEFINE VAR lDirTienda2 AS CHAR.
DEFINE VAR lTelfTienda AS CHAR.

DEFINE VAR lNombreDocumento AS CHAR.
DEFINE VAR lNroDocumento AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lDocCliente AS CHAR.

DEFINE VAR lFiler1 AS CHAR.
DEFINE VAR lTotRecibido AS DEC.
DEFINE VAR lFpagosx AS DEC.

DEFINE VAR lCajera AS CHAR.
DEFINE VAR x-Lineas AS INT.
DEFINE VAR x-LinxArt AS INT.
DEF VAR x-codbrr  AS CHARACTER   NO-UNDO FORMAT 'X(60)'.
DEFINE VAR lMoneda AS CHAR.
DEFINE VAR lCodHash AS CHAR INIT "".
DEFINE VAR x-reimpresion AS CHAR INIT "".
DEFINE VAR x-tienda-nro AS CHAR INIT "".

DEFINE VAR lOpeGratuitas AS DEC.
DEFINE VAR lTotalPagar AS DEC.

FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND
                                    FELogComprobantes.coddiv = ccbcdocu.coddiv AND 
                                    FELogComprobantes.coddoc = ccbcdocu.coddoc AND 
                                    FELogComprobantes.nrodoc = ccbcdocu.nrodoc
                                    NO-LOCK NO-ERROR.
IF AVAILABLE FELogComprobantes THEN DO:
    lCodHash =  IF (FELogComprobantes.codhash = ?) THEN "" ELSE TRIM(FELogComprobantes.codhash).
END.


lEmpresa    = "CONTINENTAL S.A.C.".
lRuc        = "20100038146".
lDirEmpresa = "CAL. RENE DESCARTES Nro. 114 URBANIZA.".
lDirEmpresa2= "SANTA RAQUEL II ETAPA  - LIMA-LIMA-ATE".
lSlogan     = "Especialista en Utiles".
lSlogan2    = "escolares y de oficina".
x-reimpresion = IF (pTipo = 'C') THEN "RE-IMPRESION" ELSE "".
x-tienda-nro = SUBSTRING(TRIM(ccbcdocu.coddiv) + FILL(" ",5),1,5).

FIND Gn-Divi WHERE Gn-Divi.codcia = Ccbcdocu.codcia
    AND Gn-Divi.coddiv = Ccbcdocu.coddiv
    NO-LOCK NO-ERROR.
IF AVAILABLE Gn-Divi THEN 
    ASSIGN 
        lNombreTienda   = CAPS(GN-DIVI.DesDiv)
        lDirTienda      = TRIM(GN-DIVI.DirDiv)
        lDirTienda2     = GN-DIVI.FaxDiv
        lTelfTienda     = gn-divi.teldiv.

lDirTienda1 = "".
IF LENGTH(lDirTienda) > lCaracxlinea  THEN DO:
    lDirTienda1 = SUBSTRING(lDirTienda,lCaracxlinea + 1).
    lDirTienda = SUBSTRING(lDirTienda,1,lCaracxlinea).
END.

lNroDocumento = "B".
lNombreDocumento = "BOLETA".
lCliente = "".

IF LENGTH(ccbcdocu.ruccli) = 11 THEN DO:
    lDocCliente = "RUC - " + TRIM(ccbcdocu.ruccli).
END.

IF TRIM(ccbcdocu.nomcli) <> ". ., ." THEN DO:
    lCliente = TRIM(ccbcdocu.nomcli).
END.
IF (ccbcdocu.codcli="11111111111") THEN DO:
   lDocCliente =  "DNI - 00000000".
END.
ELSE DO:
    lDocCliente = "DNI - " + TRIM(ccbcdocu.RucCli).
END.

IF ccbcdocu.coddoc = 'FAC' THEN DO :
    lNombreDocumento = "FACTURA".
    lNroDocumento = "F".    
    lDocCliente = "RUC - " + TRIM(ccbcdocu.ruccli).
END.

lNombreDocumento = lNombreDocumento + " DE VENTA ELECTRONICA".
lNroDocumento = lNroDocumento + SUBSTRING(ccbcdocu.nrodoc,1,3) + 
                    "-" + SUBSTRING(ccbcdocu.nrodoc,4).

/* CONTAMOS CUANTAS LINEAS TIENE LA IMPRESION */
FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
    /* El articulo se va imprimir en 3 o 4(si tiene descuentos) lineas */
    x-LinxArt = 3.
    IF Ccbddocu.Por_Dsctos[3] > 0 THEN x-LinxArt = x-LinxArt + 1.
    x-Lineas = x-Lineas + x-LinxArt.
END.
/* AGREGAMOS LOS TITULOS Y PIE DE PAGINA */
x-Lineas = x-Lineas + 62.

PUT UNFORMATTED {&PRN0} + {&PRN5A} + CHR(x-Lineas) + {&PRN4}.
PUT UNFORMATTED Chr(27) + Chr(112) + Chr(48) .
PUT UNFORMATTED {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} SKIP .
/* Titulo de la Boleta */
PUT UNFORMATTED fCentrado(lNombreTienda,lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado(lSlogan,lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado(lSlogan2,lCaracxlinea) SKIP.
PUT UNFORMATTED CHR(27) + CHR(69) + fCentrado(lEmpresa,lCaracxlinea) + CHR(27) + CHR(70) SKIP.
PUT UNFORMATTED fCentrado(lRuc,lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado(lDirEmpresa,lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado(lDirEmpresa2,lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado(lDirTienda,lCaracxlinea) SKIP.
IF lDirTienda1 <> "" THEN DO:
    PUT UNFORMATTED fCentrado(lDirTienda1,lCaracxlinea) SKIP.
END.
PUT UNFORMATTED fCentrado(lDirTienda2,lCaracxlinea) SKIP.

PUT UNFORMATTED CHR(27) + CHR(69) + fCentrado(lNombreDocumento,lCaracxlinea) + CHR(27) + CHR(70) SKIP.
PUT UNFORMATTED CHR(27) + CHR(69) + fCentrado(lNroDocumento,lCaracxlinea) + CHR(27) + CHR(70) SKIP .
IF x-reimpresion <> "" THEN DO:
    PUT UNFORMATTED CHR(27) + CHR(69) + fCentrado(x-reimpresion,lCaracxlinea) + CHR(27) + CHR(70) SKIP .
END.

PUT UNFORMATTED "Emision :" + STRING(ccbcdocu.fchdoc,"99/99/9999") + "   Hora :" + ccbcdoc.horcie SKIP.
PUT UNFORMATTED "Tda No  :" + x-tienda-nro + FILL(" ",5) + "   Telf :" + lTelfTienda SKIP .
PUT UNFORMATTED "Cajero  :" + ccbcdocu.usuario SKIP.
PUT UNFORMATTED "Cliente :" + lCliente  SKIP.
PUT UNFORMATTED "Docmnto :" + lDocCliente  SKIP.
PUT UNFORMATTED FILL("-",lCaracxlinea) SKIP .        
             /*  12345678901234567890123456789012345678 */
PUT UNFORMATTED "SKU    DESCRIPCION          IMPTE LIN." SKIP.
PUT UNFORMATTED "CODIGO EAN13  MARCA                   " SKIP.
PUT UNFORMATTED "U.MEDIDA      CANT          PRE.UNITAR" SKIP.
PUT UNFORMATTED "DSCTO         %DSCTO        IMPT.DSCTO" SKIP.
PUT UNFORMATTED FILL("-",lCaracxlinea) SKIP .

FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
    FIRST almmmatg OF ccbddocu NO-LOCK ,
    FIRST facdpedi NO-LOCK WHERE Facdpedi.codcia = Ccbcdocu.codcia
    /* AND Facdpedi.coddiv = Ccbcdocu.coddiv*/
    AND Facdpedi.coddoc = Ccbcdocu.codped
    AND Facdpedi.nroped = Ccbcdocu.nroped
    AND Facdpedi.codmat = ccbddocu.codmat
    BREAK BY Facdpedi.Libre_c05 BY Ccbddocu.NroItm:
    IF FIRST-OF(Facdpedi.Libre_c05) THEN DO:
        IF Facdpedi.Libre_c05 = 'OF' THEN DO:
            DISPLAY 'PROMOCIONES' SKIP.
        END.
    END.
    /* Lineas del articulo */
    X-lin1 = SUBSTRING(ccbddocu.codmat,1,6) + " " + SUBSTRING(almmmatg.desmat,1,20) + " " + STRING(Ccbddocu.implin,"ZZZ,ZZ9.99").
    x-codbrr = STRING(almmmatg.codbrr,'9999999999999') + " " + SUBSTRING(almmmatg.desmar,1,25).
    X-lin2 = SUBSTRING(Ccbddocu.undvta,1,3) + FILL(" ",11) + STRING(Ccbddocu.candes,"Z,ZZ9.99") + FILL(" ",6) + STRING(Ccbddocu.preuni,"ZZZ,ZZ9.99").
    PUT UNFORMATTED X-lin1 SKIP.
    PUT UNFORMATTED x-codbrr SKIP.
    PUT UNFORMATTED X-lin2 SKIP.

    /* ARMAMOS LA LINEA DE DESCUENTOS */    
    x-lin1A = ''.      /* LINEA DE DESCUENTOS */
    IF Ccbddocu.Por_Dsctos[3] > 0 THEN DO:
        x-lin1A = FILL(" ",14).
        IF facdpedi.libre_c04 <> '' AND facdpedi.libre_c04 <> ?  THEN DO:
            IF facdpedi.libre_c04 = 'VOL'  THEN x-lin1A = "DSCTO x VOLUM ".
            IF facdpedi.libre_c04 = 'PROM' THEN x-lin1A = "DSCTO PROMOC. ".
        END.
        x-lin1A = x-lin1A + STRING(Ccbddocu.Por_Dsctos[3],'ZZ9.99') + '% ' + FILL(" ",6) + STRING(Ccbddocu.impdto,'ZZZ,ZZ9.99').
    END.
    IF x-lin1A <> '' THEN DO:
        PUT UNFORMATTED X-lin1A SKIP.
    END.        
    /* FIN DE LINEA DE DESCUENTOS */
END.
/* Totales */
PUT UNFORMATTED "     " SKIP.
lMoneda = IF (ccbcdocu.codmon = 2) THEN "US$" ELSE "S/ ".

/* 899 : Operaciones Gratuitas */
lOpeGratuitas = 0.
lTotalPagar = ccbcdocu.imptot.
IF ccbcdocu.fmapgo = '899' THEN DO:
    lOpeGratuitas = ccbcdocu.impbrt.
END.


PUT UNFORMATTED FILL("-",lCaracxlinea) SKIP .
               /*12345678901234567890123456789012345678 */
/*                    XXXXXXXXXXXXXXXmndFFFFFF99,999.99*/
/*              "     I.G.V.   99%   " + lMoneda + FILL(" ",6) + STRING(ccbcdocu.impigv * 0,"ZZ,ZZ9.99").*/
PUT UNFORMATTED "     OP.GRAVADAS    " + lMoneda + FILL(" ",6) + IF (ccbcdocu.porigv > 0) THEN STRING(ccbcdocu.impvta,"ZZ,ZZ9.99") ELSE STRING(0,"ZZ,ZZ9.99") SKIP.
PUT UNFORMATTED "     OP.GRATUITAS   " + lMoneda + FILL(" ",6) + STRING(lOpeGratuitas,"ZZ,ZZ9.99") SKIP.
PUT UNFORMATTED "     OP.EXONERADAS  " + lMoneda + FILL(" ",6) + STRING(ccbcdocu.impexo,"ZZ,ZZ9.99") SKIP.
PUT UNFORMATTED "     OP.INAFECTAS   " + lMoneda + FILL(" ",6) + IF (ccbcdocu.porigv > 0) THEN STRING(0,"ZZ,ZZ9.99") ELSE STRING(ccbcdocu.impvta,"ZZ,ZZ9.99") SKIP.
PUT UNFORMATTED "     TOT.DSCTO      " + lMoneda + FILL(" ",6) + STRING(ccbcdocu.impdto2,"ZZ,ZZ9.99") SKIP.
PUT UNFORMATTED "     I.S.C.         " + lMoneda + FILL(" ",6) + STRING(ccbcdocu.impisc,"ZZ,ZZ9.99") SKIP.
PUT UNFORMATTED "     I.G.V.   " + STRING(ccbcdocu.porigv,"Z9") + "%   " + lMoneda + FILL(" ",6) + STRING(ccbcdocu.impigv,"ZZ,ZZ9.99") SKIP.
PUT UNFORMATTED "     TOTAL A PAGAR  " + lMoneda + FILL(" ",6) + STRING(lTotalPagar,"ZZ,ZZ9.99") SKIP.
PUT UNFORMATTED "     " SKIP.

/*                       12345678901234567890123456789012345678 */
/*                          XXXXXXXX  X               99,999.99 */

/* EFECTIVO */
lTotRecibido = 0.
lFpagosx    = 0.

IF TRIM(lMoneda) = 'S/' THEN DO:
    lFpagosx = IF (ccbccaja.impnac[1] > 0) THEN  ccbccaja.impnac[1] ELSE 0.
    lFpagosx = lFpagosx + IF (ccbccaja.impnac[5] > 0) THEN  ccbccaja.impnac[5] ELSE 0.
    lFpagosx = lFpagosx + IF (ccbccaja.impnac[7] > 0) THEN  ccbccaja.impnac[7] ELSE 0.
END.
ELSE DO:
    lFpagosx = IF (ccbccaja.impusa[1] > 0) THEN  ccbccaja.impusa[1] ELSE 0.
    lFpagosx = lFpagosx + IF (ccbccaja.impusa[5] > 0) THEN  ccbccaja.impusa[5] ELSE 0.
    lFpagosx = lFpagosx + IF (ccbccaja.impusa[7] > 0) THEN  ccbccaja.impusa[7] ELSE 0.
END.
lTotRecibido = lFpagosx.
IF TRIM(lMoneda) = 'S/' THEN DO:
    PUT UNFORMATTED "   EFECTIVO  SOLES (S/)      " + STRING(lFpagosx,"ZZ,ZZ9.99") SKIP. 
END.
ELSE DO:
    PUT UNFORMATTED "   EFECTIVO  DOLARES-$" + STRING(lFpagosx,"ZZ9") + FILL(" ",4) + STRING(lFpagosx * ccbccaja.tpocmb,"ZZ,ZZ9.99") SKIP.
END.

/* TARJETA */
IF ccbccaja.impnac[4] > 0 THEN DO:
    lFiler1 = SUBSTRING(TRIM(ccbccaja.voucher[9]) + FILL(" ",16),1,16).
    PUT UNFORMATTED "   TARJETA   " + lFiler1 + STRING(ccbccaja.impnac[4],"ZZ,ZZ9.99") SKIP.
    lTotRecibido = lTotRecibido + ccbccaja.impnac[4] .
END.
/* NOTA DE CREDITO */
IF ccbccaja.impnac[6] > 0 THEN DO:
    lFiler1 = SUBSTRING(FILL(" ",16),1,16).
    /* Buscar la N/C */
    DEFINE BUFFER ix-ccbdmov FOR ccbdmov.
    FIND FIRST ix-ccbdmov WHERE ix-ccbdmov.codcia = s-codcia AND 
                                    ix-ccbdmov.codref = ccbccaja.coddoc AND 
                                    ix-ccbdmov.nroref = ccbccaja.nrodoc AND 
                                    ix-ccbdmov.coddoc = 'N/C' NO-LOCK NO-ERROR.
    IF AVAILABLE ix-ccbdmov THEN DO:
        lFiler1 = SUBSTRING( SUBSTRING(ix-ccbdmov.nrodoc,1,3) + "-" + 
                             SUBSTRING(ix-ccbdmov.nrodoc,4) + FILL(" ",16),1,16).
    END.
    RELEASE ix-ccbdmov.

    PUT UNFORMATTED "   NOTA CRED " + lFiler1 + STRING(ccbccaja.impnac[6],"ZZ,ZZ9.99") SKIP.
    lTotRecibido = lTotRecibido + ccbccaja.impnac[6].
END.
/* VALES */
IF ccbccaja.impnac[10] > 0 THEN DO:
    lFiler1 = SUBSTRING(FILL(" ",16),1,16).
    PUT UNFORMATTED "   VALES     " + lFiler1 + STRING(ccbccaja.impnac[10],"ZZ,ZZ9.99") SKIP.
    lTotRecibido = lTotRecibido + ccbccaja.impnac[10].
END.

PUT UNFORMATTED "           TOTAL RECIBIDO    " +  STRING(lTotRecibido,"ZZ,ZZ9.99") SKIP.
IF ccbccaja.vuenac > 0  THEN DO:
    PUT UNFORMATTED "      CASH                   " +  STRING(ccbccaja.vuenac,"ZZ,ZZ9.99") SKIP.
END.                                           

PUT UNFORMATTED "               " SKIP.
PUT UNFORMATTED SUBSTRING(X-EnLetras,1,lCaracxlinea) SKIP.
IF LENGTH(x-EnLetras) > lCaracxLinea THEN DO:
    PUT UNFORMATTED SUBSTRING(X-EnLetras,lCaracxlinea + 1) SKIP.
END.
PUT UNFORMATTED FILL("-",lCaracxlinea) SKIP .
IF ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D' THEN DO:
    PUT UNFORMATTED "               " SKIP.
    PUT UNFORMATTED "Firma : ..............................." SKIP.
    PUT UNFORMATTED "Nombre y documento :                   " SKIP.
    PUT UNFORMATTED "               " SKIP.
    PUT UNFORMATTED FILL("-",lCaracxlinea) SKIP .
END.
PUT UNFORMATTED CHR(27) + CHR(69) + fCentrado(lCodHash,lCaracxlinea) + CHR(27) + CHR(70) SKIP.
PUT UNFORMATTED FILL("-",lCaracxlinea) SKIP .
PUT UNFORMATTED CHR(27) + CHR(69) + fCentrado("GRACIAS POR SU COMPRA",lCaracxlinea) + CHR(27) + CHR(70) SKIP.
PUT UNFORMATTED CHR(27) + CHR(69) + fCentrado("STANDFORD - CONTI",lCaracxlinea) + CHR(27) + CHR(70) SKIP.
PUT UNFORMATTED CHR(27) + CHR(69) + fCentrado("EN EL PERU",lCaracxlinea) + CHR(27) + CHR(70) SKIP.

PUT UNFORMATTED FILL("=",lCaracxlinea) SKIP .
PUT UNFORMATTED fCentrado("Autorizado mediante resolucion",lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado("Nro. 018-005-0002649/SUNAT",lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado("Representacion impresa",lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado(lNombreDocumento,lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado("Este documento puede ser validado en :",lCaracxlinea) SKIP.
/*PUT UNFORMATTED fCentrado("http://asp402r.paperless.com.pe/BoletaContinental/",lCaracxlinea) SKIP.*/
PUT UNFORMATTED fCentrado("http://asp402r.paperless.com.pe/",lCaracxlinea) SKIP.
PUT UNFORMATTED fCentrado("BoletaContinental/",lCaracxlinea) SKIP.
PUT UNFORMATTED "               " SKIP.
PUT UNFORMATTED "               " SKIP.
PUT UNFORMATTED "               " SKIP.
PUT UNFORMATTED "               " SKIP.
PUT UNFORMATTED "               " SKIP.
PUT UNFORMATTED "               " SKIP.
PUT UNFORMATTED "               " SKIP.
PUT UNFORMATTED "               " SKIP.


PUT CONTROL CHR(27) + 'm'.

OUTPUT CLOSE.

RUN Graba-Log.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Calcula-Promociones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Promociones Procedure 
PROCEDURE Calcula-Promociones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN.     /* NO VÁLIDA */

    DEFINE VARIABLE iDivision   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNroCupones AS INTEGER     NO-UNDO.
    x-promo01 = ''.
    x-promo02 = ''.

    iDivision = (ccbcdocu.imptot / 50).
    IF (INT(iDivision) > iDivision) THEN iDivision = INT(ccbcdocu.imptot / 50) - 1.
    ELSE iDivision = INT(iDivision).

    /*Numero de Vales*/    
    x-promo01 = STRING((iDivision) ,'99') + ' Ticket(s) de Sorteo'.
    /*Verifica cuantos*/
    FOR EACH b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia
        AND b-ccbcdocu.coddiv = s-coddiv 
        AND LOOKUP(b-ccbcdocu.coddoc,'FAC,BOL,TCK') > 0
        AND b-ccbcdocu.flgest <> 'A'
        /*AND b-ccbcdocu.codalm = s-codalm*/
        AND b-ccbcdocu.imptot >= 150.00
        AND b-ccbcdocu.fchdoc >= 01/01/2011 
        AND b-ccbcdocu.fchdoc <= 02/15/2011 NO-LOCK:
        iNroCupones = iNroCupones + 1.
    END.
    IF iNroCupones < 50 AND
        ccbcdocu.imptot >= 150.00 AND
        ccbcdocu.fchdoc >= 01/01/2011 AND
        ccbcdocu.fchdoc <= 02/15/2011 THEN x-promo02 = 'Una memoria KINGSTON de 4GB'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Log Procedure 
PROCEDURE Graba-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF pTipo = "C" THEN DO:
    RUN lib/logtabla ("ccbcdocu",ccbcdocu.coddoc + '|' + ccbcdocu.nrodoc, "REIMPRESION").
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-grabar-log-errores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-log-errores Procedure 
PROCEDURE grabar-log-errores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fCentrado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCentrado Procedure 
FUNCTION fCentrado RETURNS CHARACTER
  ( INPUT pDatos AS CHAR, INPUT pWidth AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lDato AS CHAR.
    DEFINE VAR lRetVal AS CHAR.                                                
    DEFINE VAR lLenDato AS INT.

    lDato = TRIM(pdatos).
    lLenDato = LENGTH(lDato).
    IF LENGTH(lDato) <= pWidth THEN DO:
        lRetVal = FILL(" ", INTEGER(pWidth / 2) - INTEGER(lLenDato / 2) ) + lDato.
    END.
    ELSE lRetVal = SUBSTRING(lDato,1,pWidth).

  RETURN lRetVal.          

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCentrar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCentrar Procedure 
FUNCTION fCentrar RETURNS INTEGER
    ( INPUT pDatos AS CHAR, INPUT pWidth AS INT ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/

      DEFINE VAR lDato AS CHAR.
      DEFINE VAR lRetVal AS INT.

      lDato = TRIM(pdatos).
      IF LENGTH(lDato) < pWidth THEN DO:
          lRetVal = INTEGER(pWidth / 2) - INTEGER(LENGTH(lDato) / 2).
      END.
      ELSE lRetVal = 1.

    RETURN lRetVal.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

