&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE TEMP-TABLE tt-doc-hdr NO-UNDO LIKE w-report
       FIELDS  diremision     AS CHAR
       FIELDS  serie           AS CHAR
       FIELDS  numero          AS CHAR
       FIELDS  nomcli          AS CHAR
       FIELDS  dircli1         AS CHAR
       FIELDS  dircli2         AS CHAR
       FIELDS  ruc_dni         AS CHAR
       FIELDS  femision        AS DATE
       FIELDS  no-pedido       AS CHAR
       FIELDS  no-guia         AS CHAR
       FIELDS  fmapago         AS CHAR
       FIELDS  tipomoneda      AS CHAR
       FIELDS  tipovta         AS CHAR
       FIELDS  fvcto           AS DATE
       FIELDS  vendedor        AS CHAR
       FIELDS  hora            AS CHAR
       FIELDS  cajera          AS CHAR.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-fact01.p
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

DEFINE TEMP-TABLE tt-documento-hdr
    FIELDS  dir-emision     AS CHAR INIT ""
    FIELDS  dir-fiscal      AS CHAR INIT ""
    FIELDS  serie           AS CHAR INIT ""
    FIELDS  numero          AS CHAR INIT ""
    FIELDS  nomcli          AS CHAR INIT ""
    FIELDS  dircli1         AS CHAR INIT ""
    FIELDS  dircli2         AS CHAR INIT ""
    FIELDS  ruc_dni         AS CHAR INIT ""
    FIELDS  femision        AS DATE
    FIELDS  no-pedido       AS CHAR INIT ""
    FIELDS  no-guia         AS CHAR INIT ""
    FIELDS  t-filer1        AS CHAR INIT ""
    FIELDS  fmapago         AS CHAR INIT ""
    FIELDS  tipomoneda      AS CHAR INIT ""
    FIELDS  tipovta         AS CHAR INIT ""
    FIELDS  fvcto           AS DATE
    FIELDS  vendedor        AS CHAR INIT ""
    FIELDS  hora            AS CHAR INIT ""
    FIELDS  cajera          AS CHAR INIT "".

DEFINE TEMP-TABLE tt-documento-dtl
    FIELDS  n-item          AS INT  INIT 0
    FIELDS  cantidad        AS DEC  INIT 0
    FIELDS  codpro          AS CHAR INIT ""
    FIELDS  descripcion     AS CHAR INIT ""
    FIELDS  marca           AS CHAR INIT ""
    FIELDS  umedida         AS CHAR INIT ""
    FIELDS  punitario       AS DEC  INIT 0
    FIELDS  descuento       AS DEC  INIT 0
    FIELDS  imptotal        AS DEC  INIT 0.

DEFINE TEMP-TABLE tt-documento-totales
    FIELDS  txtmsgcol1      AS CHAR INIT "" FORMAT 'x(99)'
    FIELDS  txtmsgcol2      AS CHAR INIT "" FORMAT 'x(13)'
    FIELDS  txtmsgcol3      AS CHAR INIT "" FORMAT 'x(2)'
    FIELDS  imptecol4       AS CHAR INIT "" FORMAT 'x(12)'.

/**/
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
/*DEF SHARED VAR s-codter  LIKE ccbcterm.codter.*/
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR CL-CODCIA AS INT.

DEF VAR x-impbrt   AS DECIMAL NO-UNDO.
DEF VAR x-dscto1   AS DECIMAL NO-UNDO.
DEF VAR x-preuni   AS DECIMAL NO-UNDO.
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEFINE VAR lLineasTotales AS INT.

DEFINE VAR x-reimpresion AS CHAR INIT "".
DEFINE VAR x-telefonos AS CHAR INIT "".

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

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK NO-ERROR.

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
FIND gn-divi WHERE gn-divi.codcia = s-codcia
                    AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.

RUN bin/_numero( (ccbcdocu.imptot - ccbcdocu.acubon[5]) , 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN "  SOLES" ELSE " DOLARES AMERICANOS").


DEFINE VAR lnombredoc AS CHAR.
DEFINE VAR lnumerodoc AS CHAR.
DEFINE VAR lpTotPaginas AS INT.
DEFINE VAR lpPagina AS INT.
DEFINE VAR lpLineas AS CHAR.
DEFINE VAR lpcPagina AS CHAR INIT "Pagina".
DEFINE VAR lpcDe AS CHAR INIT "De".
DEFINE VAR lpcMone AS CHAR INIT "".

DEFINE VAR lxMone1 AS CHAR.
DEFINE VAR lxMone2 AS CHAR.
DEFINE VAR lxMone3 AS CHAR.
DEFINE VAR lxMone4 AS CHAR.
DEFINE VAR lxMone5 AS CHAR.
DEFINE VAR lxMone6 AS CHAR.
DEFINE VAR lxMone7 AS CHAR.
DEFINE VAR lxMone8 AS CHAR.

lpLineas = FILL("-",139).

DEFINE FRAME f-documento-hdr
    SKIP(4)
    tt-documento-hdr.dir-emision AT 1 FORMAT 'x(85)'
    x-reimpresion AT 86 FORMAT 'x(54)' SKIP

    x-telefonos AT 1 FORMAT 'x(85)'
    lnombredoc AT 86 FORMAT 'x(54)' SKIP

    tt-documento-hdr.dir-fiscal AT 1 FORMAT 'x(85)'
    lnumerodoc AT 86 FORMAT 'x(54)' SKIP    
    SKIP(2)
    tt-documento-hdr.nomcli FORMAT 'x(70)' AT 10
    tt-documento-hdr.femision AT 112 SKIP
    tt-documento-hdr.dircli1 FORMAT 'x(70)' AT 10
    tt-documento-hdr.no-pedido FORMAT 'x(15)' AT 112 SKIP 
    tt-documento-hdr.dircli2 FORMAT 'x(70)' AT 10
    tt-documento-hdr.no-guia AT 112 FORMAT 'x(15)' SKIP
    tt-documento-hdr.ruc_dni FORMAT 'x(15)' AT 10
    tt-documento-hdr.t-filer1 AT 112 FORMAT 'x(15)'
    SKIP(2)
    tt-documento-hdr.fmapago FORMAT 'x(18)' AT 1
    tt-documento-hdr.tipomoneda FORMAT 'x(15)' AT 22
    tt-documento-hdr.tipovta FORMAT 'x(21)'  AT 40
    tt-documento-hdr.fvcto AT 64
    tt-documento-hdr.vendedor FORMAT 'x(14)' AT 83
    tt-documento-hdr.hora FORMAT 'x(14)' AT 100
    tt-documento-hdr.cajera FORMAT 'x(15)' AT 115 SKIP
    SKIP(3) SKIP
WITH NO-LABELS NO-BOX STREAM-IO WIDTH 150.

DEFINE FRAME f-documento-dtl
    tt-documento-dtl.n-item AT 1 FORMAT 'ZZ9'
    tt-documento-dtl.cantidad AT 5 FORMAT 'ZZ,ZZ9.99'
    tt-documento-dtl.codpro AT 15 FORMAT 'x(6)'
    tt-documento-dtl.descripcion AT 26 FORMAT 'x(59)'
    tt-documento-dtl.marca AT 87 FORMAT 'x(11)'
    tt-documento-dtl.umedida AT 100 FORMAT 'x(5)'
    tt-documento-dtl.punitario AT 105 FORMAT 'ZZZ,ZZ9.9999'
    tt-documento-dtl.descuento AT 118 FORMAT '->>9.9999' 
    tt-documento-dtl.imptotal AT 128 FORMAT 'ZZZ,ZZ9.99' SKIP
WITH NO-LABELS NO-BOX STREAM-IO WIDTH 150.

DEFINE FRAME f-documento-totales
    tt-documento-totales.txtmsgcol1 AT 1    FORMAT 'x(99)'
    tt-documento-totales.txtmsgcol2 AT 101  FORMAT 'x(13)'
    tt-documento-totales.txtmsgcol3 AT 115  FORMAT 'x(2)'
    tt-documento-totales.imptecol4 AT 118 FORMAT 'x(12)' SKIP  /*'Z,ZZZ,ZZ9.99'*/
WITH NO-LABELS NO-BOX STREAM-IO WIDTH 150.

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

&IF DEFINED(EXCLUDE-fget-descripcion-articulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-descripcion-articulo Procedure 
FUNCTION fget-descripcion-articulo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pCodDoc AS CHAR, INPUT pCondCred AS CHAR, INPUT pTipoFac AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-documento-origen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-documento-origen Procedure 
FUNCTION fget-documento-origen RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-fecha-emision-ref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-fecha-emision-ref Procedure 
FUNCTION fget-fecha-emision-ref RETURNS DATE
  (INPUT lxDoctoRef AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-prefijo-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-prefijo-documento Procedure 
FUNCTION fget-prefijo-documento RETURNS CHARACTER
    (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR)  FORWARD.

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
      TABLE: tt-doc-hdr T "?" NO-UNDO INTEGRAL w-report
      ADDITIONAL-FIELDS:
          FIELDS  diremision     AS CHAR
          FIELDS  serie           AS CHAR
          FIELDS  numero          AS CHAR
          FIELDS  nomcli          AS CHAR
          FIELDS  dircli1         AS CHAR
          FIELDS  dircli2         AS CHAR
          FIELDS  ruc_dni         AS CHAR
          FIELDS  femision        AS DATE
          FIELDS  no-pedido       AS CHAR
          FIELDS  no-guia         AS CHAR
          FIELDS  fmapago         AS CHAR
          FIELDS  tipomoneda      AS CHAR
          FIELDS  tipovta         AS CHAR
          FIELDS  fvcto           AS DATE
          FIELDS  vendedor        AS CHAR
          FIELDS  hora            AS CHAR
          FIELDS  cajera          AS CHAR
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.92
         WIDTH              = 55.72.
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

/*   */
EMPTY TEMP-TABLE tt-documento-hdr.
EMPTY TEMP-TABLE tt-documento-dtl.
EMPTY TEMP-TABLE tt-documento-totales.

/*   */
RUN pGen-Cabecera.
RUN pGen-Detalle.

/* Lineas x pagina */
lLineasTotales = 0.
RUN pGen-Footer.

IF pImpresora = YES THEN DO: 
    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND  FacCorre.CodDiv = S-CODDIV 
        AND  FacCorre.CodDoc = ccbcdocu.coddoc 
        AND  FacCorre.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3)) 
        NO-LOCK NO-ERROR.
    IF USERID("integral") = "MASTER" THEN DO:
        RUN lib/_port-name ('Facturas', OUTPUT s-port-name).
    END.
    ELSE DO:
        RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
    END.
    IF s-port-name = '' THEN DO:
        MESSAGE 'NO está definida la impresora por defecto' SKIP
            'División:' Ccbcdocu.coddiv SKIP
            'Documento:' Ccbcdocu.coddoc SKIP
            'N° Serie:' SUBSTRING(CcbCDocu.NroDoc, 1, 3) 
            'Impresora:' FacCorre.Printer
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    /****   Formato Chico   ****/
    {lib/_printer-to.i 40}                                  /* Lineas a imprimir */
END.
ELSE DO:
    DEF VAR answer AS LOGICAL NO-UNDO.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
    IF NOT answer THEN RETURN.
    OUTPUT TO PRINTER PAGE-SIZE 40.
END.


PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     /* Lineas x Pagina */

/* Variables */
DEFINE VAR lTotItems AS INT.
DEFINE VAR lLineasxPag AS INT.  /* Cuantos lineas se va imprimir */
DEFINE VAR lLinea AS INT.
DEFINE VAR lSec AS INT.
DEFINE VAR lTotPags AS INT.
DEFINE VAR lxTotPags AS INT.
DEFINE VAR lPagina AS INT.
DEFINE VAR lNumPag AS INT.
DEFINE VAR lItemsxPagina AS INT.
DEFINE VAR lNroItem AS INT.


lTotItems = 0.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK :
    lTotItems = lTotItems + 1.
END.

/*  */
lLinea = 0.
lPagina = 0.
lItemsxPagina = 19.

/* Pagina Completas */
lTotPags = TRUNCATE(lTotItems / lItemsxPagina,0).
lxTotPags = TRUNCATE(lTotItems / lItemsxPagina,0).
/* Si quedan items adicionales */
IF (lTotPags * lItemsxPagina) <> lTotItems   THEN lTotPags = lTotPags + 1.
/* Si los totales van a ir en otra pagina */
IF (lTotItems - (lxTotPags * lItemsxPagina)) > (lItemsxPagina - lLineasTotales) THEN lTotPags = lTotPags + 1.

lNroItem = 0.
FOR EACH tt-documento-dtl :
    IF lNroItem = 0 THEN DO:
        /* Imprimir cabecera */
        RUN ue-imprime-cabecera.
        lNroItem = 0.
    END.

    lNroItem = lNroItem + 1.
    DISPLAY tt-documento-dtl.n-item
            tt-documento-dtl.cantidad
            tt-documento-dtl.codpro
            tt-documento-dtl.descripcion
            tt-documento-dtl.marca
            tt-documento-dtl.umedida
            tt-documento-dtl.punitario
            tt-documento-dtl.descuento WHEN tt-documento-dtl.descuento <> 0
            tt-documento-dtl.imptotal
    WITH FRAME f-documento-dtl.

   IF lNroItem = lItemsxPagina THEN DO:
       /* Pie de Pagina y Salto */
       PUT UNFORMATTED FILL("-",137).
       PUT UNFORMATTED FILL(" ",115) + "Pagina " + STRING(lPagina,">>9") + 
                   " de " + STRING(lTotPags,">>9") SKIP.        
       lNroItem = 0.
   END.
END.
IF lNroItem = 0 OR (lNroItem > (lItemsxPagina - lLineasTotales)) THEN DO:
    /* 
        Justo coincido el nro de items
        o todas las lineas de totales no entrar en una misma pagina
     */
    IF lNroItem > 0 THEN DO:
        
        REPEAT lSec = lNroItem TO lItemsxPagina - 1 :
            PUT UNFORMATTED FILL(" ",5) SKIP.
        END.
        PUT UNFORMATTED FILL("-",137).
        PUT UNFORMATTED FILL(" ",115) + "Pagina " + STRING(lPagina,">>9") + 
                    " de " + STRING(lTotPags,">>9") SKIP.
        
    END.
    RUN ue-imprime-cabecera.
END.

/* */
PUT UNFORMATTED FILL("-",137).
PUT UNFORMATTED FILL(" ",115) + "Pagina " + STRING(lPagina,">>9") + 
            " de " + STRING(lTotPags,">>9") SKIP.

/* Imprimir total finales */
RUN ue-imprime-total-final.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

&IF DEFINED(EXCLUDE-pGen-Cabecera) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pGen-Cabecera Procedure 
PROCEDURE pGen-Cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR lDirX AS CHAR.
    DEFINE VAR lDir1 AS CHAR.
    DEFINE VAR lDir2 AS CHAR.
    DEFINE VAR lRucCli AS CHAR.

    DEFINE VAR lFmaPgo AS CHAR.
    DEFINE VAR lMoneda AS CHAR.
    DEFINE VAR lGuia AS CHAR INIT "".

    lDirX = IF ( ccbcdocu.dircli = ?) THEN " " ELSE TRIM(ccbcdocu.dircli).
    lDirX = lDirX + FILL(" ",150).
    lDir1 = SUBSTRING(lDirX,1,70).
    lDir2 = SUBSTRING(lDirX,71,70).

    lFmaPgo = IF (AVAILABLE gn-convt) THEN TRIM(gn-convt.nombr) ELSE "".
    lFmaPgo = SUBSTRING(lFmaPgo + FILL(" ",25),1,18).

    lMoneda = IF (ccbcdocu.codmon = 2) THEN "DOLARES AMERICANOS" ELSE "SOLES".
    lMoneda = SUBSTRING(lMoneda + FILL(" ",20) ,1,15).

    lRucCli = IF (ccbcdocu.ruccli = ?) THEN "" ELSE trim(ccbcdocu.ruccli).
    lRucCli = IF (lRucCli = "") THEN TRIM(ccbcdocu.codant) ELSE lRucCli.
    lRucCli = IF (SUBSTRING(lRucCli,1,7) = "1111111") THEN "" ELSE lRucCli.
    lRucCli = lRucCli + FILL(" ",15).

    IF (ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D') THEN DO:
        /**/
    END.
    ELSE DO:
        DEFINE BUFFER bx-ccbcdocu FOR ccbcdocu.
        FOR EACH bx-ccbcdocu WHERE bx-ccbcdocu.codcia = s-codcia AND
                                    bx-ccbcdocu.coddoc = 'G/R' AND
                                    bx-ccbcdocu.codref = ccbcdocu.coddoc AND 
                                    bx-ccbcdocu.nroref = ccbcdocu.nrodoc
                                    NO-LOCK :
            lGuia = lGuia + IF(lGuia <> "") THEN " / " ELSE "".
            lGuia = lGuia + SUBSTRING(bx-ccbcdocu.nrodoc,1,3) + "-" + SUBSTRING(bx-ccbcdocu.nrodoc,4).
        END.
        RELEASE bx-ccbcdocu.
    END.

    CREATE tt-documento-hdr.

    ASSIGN  tt-documento-hdr.dir-emision = "LUGAR EMISION : " + TRIM(gn-div.dirdiv) + " " + TRIM(gn-div.faxdiv)
            tt-documento-hdr.dir-fiscal = "DIR.FISCAL : CAL.RENE DESCARTES Nro.114 URB.SANTA RAQUEL II ETAPA LIMA-LIMA-ATE" 
            tt-documento-hdr.serie  = fget-prefijo-documento(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.coddiv) + 
                                        SUBSTRING(ccbcdocu.nrodoc,1,3)
            tt-documento-hdr.numero    = SUBSTRING(ccbcdocu.nrodoc,4)
            tt-documento-hdr.nomcli     = ccbcdocu.nomcli
            tt-documento-hdr.dircli1    = lDir1
            tt-documento-hdr.dircli2    = lDir2
            tt-documento-hdr.ruc_dni    = lRucCli
            tt-documento-hdr.femision   = ccbcdocu.fchdoc
            tt-documento-hdr.no-pedido  = IF (ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D') THEN "" ELSE ccbcdocu.codped + " - " + ccbcdocu.nroped
            tt-documento-hdr.no-guia    = lGuia
            tt-documento-hdr.fmapago    = lFmaPgo
            tt-documento-hdr.tipomoneda = lMoneda
            tt-documento-hdr.tipovta    = ccbcdocu.tipo
            tt-documento-hdr.fvcto      = ccbcdocu.fchvto
            tt-documento-hdr.vendedor   = ccbcdocu.codven
            tt-documento-hdr.hora       = ccbcdocu.horcie
            tt-documento-hdr.cajera     = ccbcdocu.usuario
            tt-documento-hdr.t-filer1   = if TRUE <> (ccbcdocu.codalm > "") THEN "" ELSE "( " + TRIM(ccbcdocu.codalm) + " )".
            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pGen-Detalle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pGen-Detalle Procedure 
PROCEDURE pGen-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lxDesMat AS CHAR.
DEFINE VAR lxDesMar AS CHAR.
DEFINE VAR lxDescripcion AS CHAR.

FOR EACH ccbddocu OF ccbcdocu NO-LOCK 
        /*FIRST almmmatg OF ccbddocu NO-LOCK*/
        BREAK BY ccbddocu.nrodoc
        BY ccbddocu.NroItm:
    x-impbrt = ccbddocu.candes * ccbddocu.preuni.
    x-preuni = ccbddocu.preuni.
    x-dscto1 = ( 1 -  ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ) ) * 100.

    /* Detalle del Documento */
    lxDesMat = "".
    lxDesMar = "".
    FIND FIRST almmmatg OF ccbddocu NO-LOCK NO-ERROR.
    /*IF AVAILABLE almmmatg THEN lxDesMat = almmmatg.desmat.*/
    /*IF AVAILABLE almmmatg THEN lxDesMar = almmmatg.desmar.*/

    lxDescripcion = fget-descripcion-articulo(ccbddocu.codmat, ccbcdocu.coddoc, ccbcdocu.cndcre, ccbcdocu.tpofac).
    lxDesMat = ENTRY(1,lxDescripcion,"|").
    lxDesMar = ENTRY(2,lxDescripcion,"|").

    CREATE tt-documento-dtl.
        ASSIGN  tt-documento-dtl.n-item         = ccbddocu.NroItm
                tt-documento-dtl.cantidad       = ccbddocu.Candes
                tt-documento-dtl.codpro         = ccbddocu.codmat
                tt-documento-dtl.descripcion    = lxDesMat
                tt-documento-dtl.marca          = lxDesMar
                tt-documento-dtl.umedida        = ccbddocu.undvta
                tt-documento-dtl.punitario      = x-preuni
                tt-documento-dtl.descuento      = x-dscto1
                tt-documento-dtl.imptotal       = ccbddocu.implin.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pGen-Footer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pGen-Footer Procedure 
PROCEDURE pGen-Footer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lMsg1 AS CHAR INIT "".
DEFINE VAR lMsg2 AS CHAR INIT "".
DEFINE VAR lMsg3 AS CHAR INIT "".
DEFINE VAR lMsg4 AS CHAR INIT "".
DEFINE VAR lxURL AS CHAR INIT "".

DEFINE VAR lNombDocto AS CHAR.
DEFINE VAR lMoneda AS CHAR.
DEFINE VAR lxTipoNC_ND AS CHAR INIT "".
DEFINE VAR lxMotivoNC_ND AS CHAR INIT "".
DEFINE VAR lCodHash AS CHAR INIT "".
DEFINE VAR lDocumentoRef AS CHAR INIT "".
DEFINE VAR lReferencia AS CHAR INIT "".
DEFINE VAR lFEmisDocRef AS DATE.
DEFINE VAR lOrdenCompra AS CHAR INIT "".

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

/* Linea vacia */
CREATE tt-documento-totales.
    ASSIGN  tt-documento-totales.txtmsgcol1 = "".

IF ccbcdocu.coddoc  = 'N/C' OR ccbcdocu.coddoc = 'N/D' THEN DO:
    lDocumentoRef   = fget-documento-origen(ccbcdocu.coddoc, ccbcdocu.nrodoc).    /*F001002233*/
    /* Tipo de Motivo */
    lxTipoNC_ND     = 'Otros Conceptos'.     
    CREATE tt-documento-totales.
        ASSIGN  tt-documento-totales.txtmsgcol1 = "Tipo de Motivo : " + lxTipoNC_ND.

    /* Motivo */
    lxMotivoNC_ND   = IF (ccbcdocu.glosa = ?) THEN "ERROR EN EL REGISTRO DE LA INFORMACION" ELSE TRIM(ccbcdocu.glosa).
    IF ccbcdocu.cndcre <> 'D' THEN DO:
        FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                    ccbtabla.tabla = ccbcdocu.coddoc AND 
                                    ccbtabla.codigo = ccbcdocu.codcta
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE ccbtabla THEN DO:
            IF ccbtabla.libre_c01 <> ? AND ccbtabla.libre_c01 <> '' THEN lxTipoNC_ND = ccbtabla.libre_c01.
            /* Buscarlo en la tabla de la SUNAT  */
        END.
    END.
    CREATE tt-documento-totales.
        ASSIGN  tt-documento-totales.txtmsgcol1 = "Motivo         : " + lxMotivoNC_ND.

    /* Referencia */
    lFEmisDocRef    = fget-fecha-emision-ref(lDocumentoRef). /*lDocumentoRef = F001002233*/
    lReferencia     = IF(SUBSTRING(lDocumentoRef,1,1)="B") THEN "BOLETA DE VENTA ELECTRONICA"
                        ELSE "FACTURA ELECTRONICA".
    lReferencia     = lReferencia + " - " + SUBSTRING(lDocumentoRef,1,4) + " - " + SUBSTRING(lDocumentoRef,5).
    lReferencia     = lReferencia + " - " + IF(lFEmisDocRef = ?) THEN "" 
                                            ELSE STRING(lFEmisDocRef,"99/99/9999").
    CREATE tt-documento-totales.
        ASSIGN  tt-documento-totales.txtmsgcol1 = "Referencia     : " + lReferencia.

    /* Linea en blanco */
    CREATE tt-documento-totales.
        ASSIGN  tt-documento-totales.txtmsgcol1 = "".

END.

lxURL = "Este documento puede ser validado en : http://asp402r.paperless.com.pe/BoletaContinental/".
CASE ccbcdocu.coddoc:
    WHEN "FAC" THEN lxURL = lxURL + "".
    WHEN "BOL" THEN lxURL = lxURL + "".
    WHEN "TCK" THEN lxURL = lxURL + "".
    WHEN "N/D" THEN lxURL = lxURL + "".
    WHEN "N/C" THEN lxURL = lxURL + "".
END CASE.

IF ccbcdocu.NroOrd <> ? OR ccbcdocu.NroOrd <> '' THEN DO:
    lOrdenCompra = "O.COMPRA :" + TRIM(ccbcdocu.NroOrd).
END.

/* 899 : Operaciones Gratuitas */
lOpeGratuitas = 0.
lTotalPagar = ccbcdocu.imptot.
IF ccbcdocu.fmapgo = '899' THEN DO:
    lOpeGratuitas = ccbcdocu.impbrt.
END.
    
CREATE tt-documento-totales.
ASSIGN  tt-documento-totales.txtmsgcol1 = "SON : "  + X-EnLetras
        tt-documento-totales.txtmsgcol2 = "OP.GRAVADAS"
        tt-documento-totales.txtmsgcol3 = IF (ccbcdocu.codmon = 2) THEN "$." ELSE "S/"
        tt-documento-totales.imptecol4  = IF (ccbcdocu.porigv > 0) THEN STRING(ccbcdocu.impvta,"Z,ZZZ,ZZ9.99") ELSE STRING(0,"Z,ZZZ,ZZ9.99").

CREATE tt-documento-totales.
ASSIGN  tt-documento-totales.txtmsgcol1 = lOrdenCompra
     tt-documento-totales.txtmsgcol2 = "OP.GRATUITAS"
     tt-documento-totales.txtmsgcol3 = IF (ccbcdocu.codmon = 2) THEN "$." ELSE "S/"
     tt-documento-totales.imptecol4  = STRING(lOpeGratuitas,"Z,ZZZ,ZZ9.99").

CREATE tt-documento-totales.
ASSIGN  tt-documento-totales.txtmsgcol1 = 'Incorp. al reg. de agentes de retencion de IGV (RS:265-2009) a partir del 01/01/10'
     tt-documento-totales.txtmsgcol2 = "OP.EXONERADAS"
     tt-documento-totales.txtmsgcol3 = IF (ccbcdocu.codmon = 2) THEN "$." ELSE "S/"
     tt-documento-totales.imptecol4  = STRING(ccbcdocu.impexo,"Z,ZZZ,ZZ9.99").

CREATE tt-documento-totales.
ASSIGN  tt-documento-totales.txtmsgcol1 = "CODIGO HASH :" + lCodHash
    tt-documento-totales.txtmsgcol2 = "OP.INAFECTAS"
    tt-documento-totales.txtmsgcol3 = IF (ccbcdocu.codmon = 2) THEN "$." ELSE "S/"
    tt-documento-totales.imptecol4  = IF (ccbcdocu.porigv > 0) THEN STRING(0,"Z,ZZZ,ZZ9.99") ELSE STRING(ccbcdocu.impvta,"Z,ZZZ,ZZ9.99").

CREATE tt-documento-totales.
ASSIGN  tt-documento-totales.txtmsgcol1 = "Autorizado mediante Resolucion No. 018-005-0002649/SUNAT"
   tt-documento-totales.txtmsgcol2 = "TOT.DSCTO"
   tt-documento-totales.txtmsgcol3 = IF (ccbcdocu.codmon = 2) THEN "$." ELSE "S/"
   tt-documento-totales.imptecol4  = STRING(ccbcdocu.impdto2,"Z,ZZZ,ZZ9.99").

CREATE tt-documento-totales.
ASSIGN  tt-documento-totales.txtmsgcol1 = lxUrl
        tt-documento-totales.txtmsgcol2 = "I.S.C."
        tt-documento-totales.txtmsgcol3 = IF (ccbcdocu.codmon = 2) THEN "$." ELSE "S/"
        tt-documento-totales.imptecol4  = STRING(ccbcdocu.impisc,"Z,ZZZ,ZZ9.99").

CREATE tt-documento-totales.
ASSIGN  tt-documento-totales.txtmsgcol1 = ""
      tt-documento-totales.txtmsgcol2 = "I.G.V. " + STRING(ccbcdocu.porigv,"ZZ9") + "%"
      tt-documento-totales.txtmsgcol3 = IF (ccbcdocu.codmon = 2) THEN "$." ELSE "S/"
      tt-documento-totales.imptecol4  = STRING( ccbcdocu.impigv,"Z,ZZZ,ZZ9.99").

CREATE tt-documento-totales.
ASSIGN  tt-documento-totales.txtmsgcol1 = ""
      tt-documento-totales.txtmsgcol2 = "TOTAL A PAGAR"
      tt-documento-totales.txtmsgcol3 = IF (ccbcdocu.codmon = 2) THEN "$." ELSE "S/"
      tt-documento-totales.imptecol4  = STRING(lTotalPagar,"Z,ZZZ,ZZ9.99").

/* Cuantas lineas de totales existen */                                                                                
lLineasTotales = 0.
FOR EACH tt-documento-totales NO-LOCK:
    lLineasTotales = lLineasTotales + 1.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-imprime-cabecera) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imprime-cabecera Procedure 
PROCEDURE ue-imprime-cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lTelfs AS CHAR INIT "".

FIND gn-divi WHERE gn-divi.codcia = s-codcia
                    AND gn-divi.coddiv = ccbcdocu.coddiv NO-LOCK NO-ERROR.

    lLinea = 19.
    lPagina = lPagina + 1.

    lnombredoc = "".

    CASE ccbcdocu.coddoc:
        WHEN 'FAC' THEN lnombredoc = "FACTURA ELECTRONICA".
        WHEN 'BOL' THEN lnombredoc = "BOLETA DE VENTA ELECTRONICA".
        WHEN 'TCK' THEN lnombredoc = "BOLETA DE VENTA ELECTRONICA".
        WHEN 'N/D' THEN lnombredoc = "NOTA DE DEBITO ELECTRONICA".
        WHEN 'N/C' THEN lnombredoc = "NOTA DE CREDITO ELECTRONICA".
    END CASE.    
    lnumerodoc = tt-documento-hdr.serie + " - No " + tt-documento-hdr.numero.    

    lTelfs = IF(AVAILABLE gn-div) THEN gn-div.teldiv ELSE lTelfs.
    lTelfs = IF(lTelfs = ?) THEN "" ELSE "Telefonos : " + lTelfs.
    lTelfs = TRIM(lTelfs).

    x-reimpresion = IF(pTipo = 'C') THEN "RE-IMPRESION" ELSE FILL(" " , 54).
    x-telefonos = lTelfs.

    DISPLAY /*SKIP(4)*/
            fcentrado(tt-documento-hdr.dir-emision,90) @ dir-emision
            fcentrado(x-reimpresion,54) @ x-reimpresion
            fcentrado(x-telefonos,90) @ x-telefonos
            fcentrado(lnombredoc,54) @ lnombredoc
            fcentrado(tt-documento-hdr.dir-fiscal,90) @ dir-fiscal
            fcentrado(lnumerodoc,54) @ lnumerodoc
            /*SKIP(2)*/
            tt-documento-hdr.nomcli
            tt-documento-hdr.femision
            tt-documento-hdr.dircli1
            tt-documento-hdr.no-pedido
            tt-documento-hdr.dircli2
            tt-documento-hdr.no-guia
            tt-documento-hdr.ruc_dni
            tt-documento-hdr.t-filer1
            /*SKIP(2)*/
            tt-documento-hdr.fmapago
            tt-documento-hdr.tipomoneda
            tt-documento-hdr.tipovta
            tt-documento-hdr.fvcto
            tt-documento-hdr.vendedor
            tt-documento-hdr.hora
            tt-documento-hdr.cajera
        WITH FRAME f-documento-hdr.
    

/*                                  
    DEFINE VAR lNroDoc AS CHAR.
    DEFINE VAR lImpNroDoc AS CHAR.
    DEFINE VAR lDirX AS CHAR.
    DEFINE VAR lDir1 AS CHAR.
    DEFINE VAR lDir2 AS CHAR.
    DEFINE VAR lRucCli AS CHAR.
    DEFINE VAR lNomCli AS CHAR.

    DEFINE VAR lFmaPgo AS CHAR.
    DEFINE VAR lMoneda AS CHAR.
    DEFINE VAR lTipoVta AS CHAR.
    DEFINE VAR lVcto AS CHAR.
    DEFINE VAR lVendedor AS CHAR.
    DEFINE VAR lHora AS CHAR.
    DEFINE VAR lCajera AS CHAR.

    lNroDoc = IF (ccbcdocu.coddoc = "FAC") THEN "F" ELSE "B".
    lNroDoc = lNroDoc +  SUBSTRING(ccbcdocu.nrodoc,1,3) + " - No " + SUBSTRING(ccbcdocu.nrodoc,4).

    lImpNroDoc  = IF (ccbcdocu.coddoc = "FAC") THEN "FACTURA ELECTRONICA" ELSE "BOLETA DE VENTA ELECTRONICA".

    lDirX = IF ( ccbcdocu.dircli = ?) THEN " " ELSE TRIM(ccbcdocu.dircli).
    lDirX = lDirX + FILL(" ",150).
    lDir1 = SUBSTRING(lDirX,1,70).
    lDir2 = SUBSTRING(lDirX,71,70).

    lRucCli = IF (ccbcdocu.ruccli = ?) THEN "" ELSE trim(ccbcdocu.ruccli).
    lRucCli = IF (lRucCli = "") THEN TRIM(ccbcdocu.codant) ELSE lRucCli.
    lRucCli = IF (SUBSTRING(lRucCli,1,7) = "1111111") THEN "" ELSE lRucCli.
    lRucCli = lRucCli + FILL(" ",15).
    
    /**/
    lFmaPgo = IF (AVAILABLE gn-convt) THEN TRIM(gn-convt.nombr) ELSE "".
    lFmaPgo = SUBSTRING(lFmaPgo + FILL(" ",25),1,18).

    lMoneda = IF (ccbcdocu.codmon = 2) THEN "DOLARES AMERICANOS" ELSE "SOLES".
    lMoneda = SUBSTRING(lMoneda + FILL(" ",20) ,1,15).

    lTipoVta = IF( ccbcdocu.tipo = ?) THEN "" ELSE TRIM(ccbcdocu.tipo).
    lTipoVta = SUBSTRIN(lTipoVta + FILL(" ",25),1,21).

    lVcto   = IF ( ccbcdocu.fchvto = ?) THEN "" ELSE STRING(fchvto,"99/99/9999").
    lVcto   = SUBSTRIN(lVcto + FILL(" ",20),1,14).

    lVendedor = IF(ccbcdocu.codven = ?) THEN "" ELSE TRIM(ccbcdocu.codven).
    lVendedor   = SUBSTRIN(lVendedor + FILL(" ",20),1,14).

    lHora = IF(ccbcdocu.horcie = ?) THEN "" ELSE TRIM(ccbcdocu.horcie).
    lHora   = SUBSTRIN(lHora + FILL(" ",20),1,14).

    lCajera = IF(ccbcdocu.usuario = ?) THEN "" ELSE TRIM(ccbcdocu.usuario).
    lCajera   = SUBSTRIN(lCajera + FILL(" ",25),1,15).

    lNomCli = TRIM(ccbcdocu.nomcli) + FILL(" ",80).
    lNomCli = SUBSTRING(lNomCli,1,70).

    /* Imprimir Cabecera */
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED fCentrado("Lugar de Emision :" + TRIM(gn-div.dirdiv) ,90) SKIP.
    PUT UNFORMATTED FILL(" ",86) + CHR(27) + CHR(69) + fCentrado(lImpNroDoc,54) + CHR(27) + CHR(70) SKIP.    
    PUT UNFORMATTED FILL(" ",86) + CHR(27) + CHR(69) + fCentrado(lNroDoc,54) + CHR(27) + CHR(70) SKIP.    
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED FILL(" ",10) + lNomCli + FILL(" ",30) + STRING(ccbcdocu.fchdoc,"99/99/9999") SKIP.
    PUT UNFORMATTED FILL(" ",10) + lDir1 + FILL(" ",30) + ccbcdocu.codref + " - " + ccbcdocu.nroref SKIP.
    PUT UNFORMATTED FILL(" ",10) + lDir2 SKIP.
    PUT UNFORMATTED FILL(" ",10) + lRucCli + FILL(" ",75) + "..." SKIP.
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED lFmaPgo + FILL(" ",4) + lMoneda + FILL(" ",3) + lTipoVta +
                    FILL(" ",2) + lVcto + FILL(" ",3) + lVendedor + FILL(" ",2) + 
                    lHora + FILL(" ",3) + lCajera  SKIP.
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED "   " SKIP.
    PUT UNFORMATTED "   " SKIP.

    /* lLinea debe la cantidad de lineas a imprimir en la Cabecera */
    lLinea = 19.
    lPagina = lPagina + 1.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-imprime-total-final) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imprime-total-final Procedure 
PROCEDURE ue-imprime-total-final :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH tt-documento-totales NO-LOCK:
      PUT UNFORMATTED tt-documento-totales.txtmsgcol1 AT 1.
      PUT UNFORMATTED tt-documento-totales.txtmsgcol2 AT 101.
      PUT UNFORMATTED tt-documento-totales.txtmsgcol3 AT 115.
      PUT UNFORMATTED tt-documento-totales.imptecol4 AT 118 SKIP.
  END.

  
  /*
    DISPLAY
        tt-documento-footer.txtmoneda        
        IF (ccbcdocu.codmon = 1) THEN "S/"  ELSE "$." @ lxMone1
        tt-documento-footer.op-gravadas
        tt-documento-footer.txtmsg0
        IF (ccbcdocu.codmon = 1) THEN "S/"  ELSE "$." @ lxMone2
        tt-documento-footer.op-gratuitas
        IF (ccbcdocu.codmon = 1) THEN "S/"  ELSE "$." @ lxMone3
        tt-documento-footer.op-exoneradas
        IF (ccbcdocu.codmon = 1) THEN "S/"  ELSE "$." @ lxMone4
        tt-documento-footer.op-inafectas
        tt-documento-footer.txtmsg1
        IF (ccbcdocu.codmon = 1) THEN "S/"  ELSE "$." @ lxMone5
        tt-documento-footer.tot-dscto
        tt-documento-footer.txtmsg2
        IF (ccbcdocu.codmon = 1) THEN "S/"  ELSE "$." @ lxMone6
        tt-documento-footer.isc
        tt-documento-footer.txtmsg3
        tt-documento-footer.igv_factor
        IF (ccbcdocu.codmon = 1) THEN "S/"  ELSE "$." @ lxMone7
        tt-documento-footer.igv-impte
        tt-documento-footer.txtmsg4
        IF (ccbcdocu.codmon = 1) THEN "S/"  ELSE "$." @ lxMone8
        tt-documento-footer.totpagar
        tt-documento-footer.codhash
        tt-documento-footer.autorizacion
        tt-documento-footer.txtrepresenta
        tt-documento-footer.txt-url
    WITH FRAME f-documento-ftr.
*/
  
/*
DEFINE VAR lMsg1 AS CHAR.
DEFINE VAR lMsg2 AS CHAR.
DEFINE VAR lMsg3 AS CHAR.
DEFINE VAR lMsg4 AS CHAR.

DEFINE VAR lNombDocto AS CHAR.
DEFINE VAR lMoneda AS CHAR.

DEFINE VAR lCodHash AS CHAR INIT "".

FIND FIRST gn-convt WHERE gn-convt.codig = ccbcdocu.fmapgo NO-LOCK NO-ERROR.
FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND
                                    FELogComprobantes.coddiv = ccbcdocu.coddiv AND 
                                    FELogComprobantes.coddoc = ccbcdocu.coddoc AND 
                                    FELogComprobantes.nrodoc = ccbcdocu.nrodoc
                                    NO-LOCK NO-ERROR.
IF AVAILABLE FELogComprobantes THEN DO:
    lCodHash =  IF (FELogComprobantes.codhash = ?) THEN "" ELSE TRIM(FELogComprobantes.codhash).
END.

lMoneda = IF (ccbcdocu.codmon = 2) THEN "US$" ELSE "S/ ".
lNombDocto = IF (ccbcdocu.coddoc = "FAC") THEN "FACTURA ELECTRONICA" ELSE "BOLETA DE VENTA ELECTRONICA".

lMsg1 = 'Incorp. al reg. de agentes de retencion de IGV (RS:265-2009) a partir del 01/01/10'.

PUT UNFORMATTED "    " SKIP.
PUT UNFORMATTED SUBSTRING("Son :" + X-EnLetras + FILL(" ",100),1,100) + "OP.GRAVADAS   " + lMoneda + IF (ccbcdocu.porigv > 0) THEN STRING(ccbcdocu.impvta,"Z,ZZZ,ZZ9.99") ELSE STRING(0,"Z,ZZZ,ZZ9.99") SKIP.
                              PUT UNFORMATTED FILL(" ",100) + "OP.GRATUITAS  " + lMoneda + STRING(0,"Z,ZZZ,ZZ9.99") SKIP.
                              PUT UNFORMATTED FILL(" ",100) + "OP.EXONERADAS " + lMoneda + STRING(ccbcdocu.impexo,"Z,ZZZ,ZZ9.99") SKIP.
                              PUT UNFORMATTED FILL(" ",100) + "OP.INAFECTAS  " + lMoneda + IF (ccbcdocu.porigv > 0) THEN STRING(0,"Z,ZZZ,ZZ9.99") ELSE STRING(ccbcdocu.impvta,"Z,ZZZ,ZZ9.99") SKIP.
                              PUT UNFORMATTED FILL(" ",100) + "TOT.DSCTO     " + lMoneda + STRING(ccbcdocu.impdto2,"Z,ZZZ,ZZ9.99") SKIP.
                              PUT UNFORMATTED FILL(" ",100) + "I.S.C         " + lMoneda + STRING(ccbcdocu.impisc,"Z,ZZZ,ZZ9.99") SKIP.
                              PUT UNFORMATTED FILL(" ",100) + "I.G.V.  " + STRING(ccbcdocu.porigv,"Z9") + "%   " + lMoneda + STRING(ccbcdocu.impigv,"Z,ZZZ,ZZ9.99") SKIP.
       PUT UNFORMATTED SUBSTRING(lMsg1 + FILL(" ",100),1,100) + "TOTAL A PAGAR " + lMoneda + STRING(ccbcdocu.imptot,"Z,ZZZ,ZZ9.99") SKIP.

IF LENGTH(lMsg2) > 0  THEN PUT UNFORMATTED lMsg2 SKIP.
IF LENGTH(lMsg3) > 0  THEN PUT UNFORMATTED lMsg3 SKIP.
IF LENGTH(lMsg4) > 0  THEN PUT UNFORMATTED lMsg4 SKIP.

PUT UNFORMATTED lCodHash SKIP.

PUT UNFORMATTED "    " SKIP.
PUT UNFORMATTED CHR(15) + "Autorizadoo mediante Resolucion No.XXXX-XXXX/SUNAT" + CHR(18) SKIP.
PUT UNFORMATTED CHR(15) + "Representacion impresa de la " + lNombDocto + CHR(18) SKIP.
PUT UNFORMATTED CHR(15) + "Este documento puede ser validado en : http://www.conti.facturas/" + CHR(18) SKIP.

/* 17 Lineas de Totales */
*/

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

&IF DEFINED(EXCLUDE-fget-descripcion-articulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-descripcion-articulo Procedure 
FUNCTION fget-descripcion-articulo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pCodDoc AS CHAR, INPUT pCondCred AS CHAR, INPUT pTipoFac AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  22Jul2016 : Segungo valor es la MARCA Descripcion|Marca
------------------------------------------------------------------------------*/

    DEFINE VAR lRetVal AS CHAR INIT " | ".

    DEFINE BUFFER bz-almmmatg FOR almmmatg.

    FIND FIRST bz-almmmatg WHERE bz-almmmatg.codcia = s-codcia AND 
                                bz-almmmatg.codmat = pCodMat
                                NO-LOCK NO-ERROR.
    IF AVAILABLE bz-almmmatg THEN lRetVal = TRIM(almmmatg.desmat) + "|" + TRIM(almmmatg.desmar).

    IF pCoddoc = 'N/C' OR pCoddoc = 'N/D' THEN DO:
        /* Notas de Credito / Debito que no es devolucion de Mercaderia */
        IF pCondCred <> 'D' THEN DO:
            FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                        ccbtabla.tabla = pCoddoc AND 
                                        ccbtabla.codigo = pCodmat
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE ccbtabla THEN DO:
                lRetVal = TRIM(ccbtabla.nombre) + "| ".
            END.
        END.
    END.
    ELSE DO:
        IF pTipoFac = 'S' /*OR pTipoFac = 'A' */ THEN DO:
            /* Factura de Servicios o Anticipo de campaña */
            FIND FIRST almmserv WHERE almmserv.codcia = s-codcia AND 
                                        almmserv.codmat = pCodMat 
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almmserv THEN DO:
                lRetVal = TRIM(almmserv.desmat) + "| ".
            END.
        END.        
    END.

    RELEASE bz-almmmatg.


  RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-documento-origen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-documento-origen Procedure 
FUNCTION fget-documento-origen RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Se debe enviar N/C o N/D
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lRetVal AS CHAR.

    DEFINE VAR lDocFactura AS CHAR.
    DEFINE VAR lDocBoleta AS CHAR.
    DEFINE VAR lDocLetra AS CHAR.

    lRetVal = "?".

    DEFINE BUFFER fx-ccbcdocu FOR ccbcdocu.
    DEFINE BUFFER fx-ccbdmvto FOR ccbdmvto.

    FIND FIRST fx-ccbcdocu USE-INDEX llave01 WHERE fx-ccbcdocu.codcia = s-codcia AND 
                                    fx-ccbcdocu.coddoc = pTipoDoc AND 
                                    fx-ccbcdocu.nrodoc = pNroDoc 
                                    NO-LOCK NO-ERROR.
    IF AVAILABLE fx-ccbcdocu THEN DO:    
        IF fx-ccbcdocu.codref = 'FAC' OR fx-ccbcdocu.codref = 'BOL' OR 
                fx-ccbcdocu.codref = 'TCK' THEN DO:

            IF fx-ccbcdocu.codref = 'FAC' THEN lRetVal = 'F' + fx-ccbcdocu.nroref.
            IF fx-ccbcdocu.codref = 'BOL' OR fx-ccbcdocu.codref = 'TCK' THEN lRetVal = 'B' + fx-ccbcdocu.nroref.        

        END.
        ELSE DO:
            IF fx-ccbcdocu.codref = 'LET' THEN DO:
                /* No deberia darse, pero x siaca */
                lRetVal = fget-documento-origen(fx-ccbcdocu.codref, fx-ccbcdocu.nroref).
            END.
            ELSE DO:
                IF fx-ccbcdocu.codref = 'CJE' OR fx-ccbcdocu.codref = 'RNV' OR fx-ccbcdocu.codref = 'REF' THEN DO:
                    /* Si en CANJE, RENOVACION y REFINANCIACION */
                    lDocFactura = "".
                    lDocBoleta = "".
                    lDocLetra = "".
                    FOR EACH fx-ccbdmvto WHERE fx-ccbdmvto.codcia = s-codcia AND 
                                                fx-ccbdmvto.coddoc = fx-ccbcdocu.codref AND 
                                                fx-ccbdmvto.nrodoc = fx-ccbcdocu.nroref NO-LOCK:
                        IF fx-ccbdmvto.nroref <> pnroDoc THEN DO:
                            IF fx-ccbdmvto.codref = 'FAC' AND lDocFactura = "" THEN lDocFactura = "F" + fx-ccbdmvto.nroref.
                            IF fx-ccbdmvto.codref = 'BOL' AND lDocBoleta = "" THEN lDocBoleta = "B" + fx-ccbdmvto.nroref.
                            IF fx-ccbdmvto.codref = 'LET' AND lDocLetra = "" THEN lDocLetra = fx-ccbdmvto.nroref.
                        END.
                    END.
                    IF lDocFactura  = "" AND lDocBoleta = "" AND lDocLetra <> "" THEN DO:
                        /* es una LETRA */
                        lRetVal = fget-documento-origen("LET", lDocLetra).
                    END.
                    ELSE DO:
                        IF lDocBoleta  <> "" THEN lRetVal = lDocBoleta.
                        IF lDocFactura  <> "" THEN lRetVal = lDocFactura.
                    END.
                END.
                /* 
                    Puede que hayan CLA : Canje x letra adelantada, pero el dia que salte ese error
                    ya se programa...
                */
            END.
        END.
    END.

    RELEASE fx-ccbcdocu.
    RELEASE fx-ccbdmvto.

    RETURN lRetVal.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-fecha-emision-ref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-fecha-emision-ref Procedure 
FUNCTION fget-fecha-emision-ref RETURNS DATE
  (INPUT lxDoctoRef AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
/* Fecha de Emision de la referencia */
DEFINE VAR lxCodRef AS CHAR INIT "".
DEFINE VAR lxNroRef AS CHAR INIT "".
DEFINE VAR lxlDate AS DATE INIT ?.

IF SUBSTRING(lxDoctoRef,1,1)="F" THEN DO:
    lxCodRef = 'FAC'.
END.
lxNroRef = SUBSTRING(lxDoctoRef,2,3) + SUBSTRING(lxDoctoRef,5).

DEFINE BUFFER ix-ccbcdocu FOR ccbcdocu.

/* Lo busco como FACTURA */
FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                ix-ccbcdocu.coddoc = lxCodRef AND 
                                ix-ccbcdocu.nrodoc = lxNroRef
                                NO-LOCK NO-ERROR.
IF NOT AVAILABLE ix-ccbcdocu THEN DO:
    IF SUBSTRING(lxDoctoRef,1,1)="B" THEN DO:
        /* Lo busco como BOLETA */
        lxCodRef = 'BOL'.
        FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                        ix-ccbcdocu.coddoc = lxCodRef AND 
                                        ix-ccbcdocu.nrodoc = lxNroRef
                                        NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ix-ccbcdocu THEN DO:
            /* Lo busco como TICKET */
            lxCodRef = 'TCK'.
            FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                            ix-ccbcdocu.coddoc = lxCodRef AND 
                                            ix-ccbcdocu.nrodoc = lxNroRef
                                            NO-LOCK NO-ERROR.
        END.
    END.
END.

IF AVAILABLE ix-ccbcdocu THEN DO:
    lxlDate = ix-ccbcdocu.fchdoc.
END.

RELEASE ix-ccbcdocu.

RETURN lxlDate.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-prefijo-documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-prefijo-documento Procedure 
FUNCTION fget-prefijo-documento RETURNS CHARACTER
    (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR) :

        DEFINE VAR lxRet AS CHAR.

        lxRet = '?'.

        IF pTipoDoc = 'N/C' OR pTipoDoc = 'N/D' THEN DO:

            DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.            

            IF pDivision <> "" THEN DO:
                FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                            z-ccbcdocu.coddiv = pDivision AND
                                            z-ccbcdocu.coddoc = pTipoDoc AND 
                                            z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
            END.
            ELSE DO:
                FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                            z-ccbcdocu.coddoc = pTipoDoc AND 
                                            z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
            END.

            IF AVAILABLE z-ccbcdocu THEN DO:
                IF z-ccbcdocu.codref = 'LET' THEN DO:
                    /* la Referencia es una LETRA, es un CANJE */
                    /* Devuelve el documento Original F001001255 o B145001248 */
                    lxRet = fget-documento-origen(z-ccbcdocu.codref, z-ccbcdocu.nroref).
                    lxRet = SUBSTRING(lxRet,1,1).
                END.
                ELSE lxRet = fGet-Prefijo-documento(z-ccbcdocu.codref, z-ccbcdocu.nroref, "").
            END.

            RELEASE z-ccbcdocu.
        END.
        ELSE DO:
            IF pTipoDoc = 'FAC' THEN lxRet = 'F'.
            IF pTipoDoc = 'BOL' OR pTipoDoc = 'TCK' THEN lxRet = 'B'.        
        END.


      RETURN lxRet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

