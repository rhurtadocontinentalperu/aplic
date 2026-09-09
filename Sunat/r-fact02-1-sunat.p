&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
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

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR CL-CODCIA AS INT.

DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR x-Percepcion AS CHAR FORMAT 'x(60)' NO-UNDO.
DEF VAR x-Percepcion-2 AS CHAR FORMAT 'x(60)' NO-UNDO.
DEF VAR x-ImpPercep-21 LIKE ccbcdocu.imptot NO-UNDO.
DEF VAR x-ImpPercep-22 LIKE ccbcdocu.imptot NO-UNDO.
DEF VAR x-impbrt   AS DECIMAL NO-UNDO.
DEF VAR x-dscto1   AS DECIMAL NO-UNDO.
DEF VAR x-preuni   AS DECIMAL NO-UNDO.
DEF VAR C-NomCon   AS CHAR FORMAT "X(40)".
DEF VAR N-ITEM     AS INTEGER INIT 0 NO-UNDO.
DEF VAR X-Cheque   AS CHAR NO-UNDO.
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".
DEF VAR X-PUNTOS AS CHAR   FORMAT "X(40)".
DEF VAR imptotfac like ccbcdocu.imptot.
DEF VAR x-nrocaja AS CHAR FORMAT "X(9)" .
DEFINE VARIABLE x-dscto AS DECIMAL.
DEF VAR x-Contipuntos AS CHAR NO-UNDO FORMAT 'x(20)'.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.


FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK NO-ERROR.

C-NomCon = "".

X-PUNTOS = IF CcbCDocu.NroCard <> "" THEN "Puntos Cliente Exclusivo :" + STRING(CcbCDocu.AcuBon[1],"999999") ELSE "".
IF Ccbcdocu.NroCard <> '' AND CcbCDocu.puntos > 0
THEN x-Contipuntos = 'CONTIPUNTOS: ' + STRING(ccbcdocu.puntos, '>>>9').

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
RUN bin/_numero( (ccbcdocu.imptot - ccbcdocu.acubon[5]) , 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN "  SOLES" ELSE " DOLARES AMERICANOS").
x-Percepcion = "".
x-Percepcion-2 = "".
IF ccbcdocu.acubon[5] > 0 THEN x-Percepcion = "* Operación sujeta a percepción del IGV".
IF ccbcdocu.acubon[5] > 0 AND LOOKUP(ccbcdocu.fmapgo, '000,002') > 0 THEN 
    ASSIGN
    x-Percepcion-2 = "Comprobante de Percepcion - Venta Interna"
    x-ImpPercep-21 = ccbcdocu.imptot
    x-ImpPercep-22 = ccbcdocu.acubon[5].

/************************  DEFINICION DE FRAMES  *******************************/
/* Verifica que la cancelación se realizó con CHEQUE */
x-cheque = "".
x-nrocaja = "".
IF CcbCDocu.Flgest = 'C' THEN DO:
   FIND FIRST CcbDCaja WHERE CcbDCaja.CodCia = s-codcia 
                        AND  CcbDCaja.CodRef = CcbCDocu.Coddoc 
                        AND  CcbDCaja.NroRef = CcbCDocu.Nrodoc 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE CcbDCaja THEN DO:
      FIND CcbCCaja OF CcbDCaja NO-LOCK NO-ERROR.
      IF AVAILABLE CcbCCaja THEN DO:
         x-cheque = TRIM(CcbCCaja.Voucher[2]) + TRIM(CcbCCaja.Voucher[3]).
         x-nrocaja = CcbCcaja.NroDoc.
         IF CcbCCaja.CodBco[2] <> '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" 
                          AND  cb-tabl.codigo = CcbCCaja.CodBco[2]
                         NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN 
               x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
         END.
         IF CcbCCaja.CodBco[3] <> '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" 
                          AND  cb-tabl.codigo = CcbCCaja.CodBco[3]
                         NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN 
               x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
         END.
      END.
   END.
END.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.

/*
DEFINE FRAME F-HdrFac
    HEADER
    SKIP(6)
    gn-divi.faxdiv FORMAT 'x(50)' WHEN AVAILABLE gn-divi SKIP
    ccbcdocu.nomcli AT 11 FORMAT "x(50)" 
    CcbCDocu.CodCli AT 62    
    ccbcdocu.dircli AT 11 FORMAT "x(50)" SKIP
    ccbcdocu.RucCli AT 11 FORMAT "X(11)"     
    C-NomCon        AT 62 FORMAT "X(15)" 
    ccbcdocu.nrodoc AT 100 FORMAT "XXX-XXXXXX" SKIP(2)    
    ccbcdocu.fchdoc AT 01
    CcbCDocu.NroPed AT 18 FORMAT "X(10)" SKIP
    /* RHC 06.01.10 AGENTE RETENEDOR */
    'Incorp. al reg. de agentes de retencion de IGV (RS:265-2009) a partir del 01/01/10' SKIP(1.5)
    IF ccbcdocu.codmon = 1 THEN "SOLES"  ELSE "DOLARES" AT 01 FORMAT "X(8)"
    "MOSTRADOR" AT 24
    CcbCDocu.FchVto AT 50
    CcbCDocu.CodVen AT 70
    STRING(TIME,"HH:MM:SS") AT 90
    S-User-Id + "/" + S-CODTER  AT 115 FORMAT "X(20)"
    SKIP(1)    
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaFac
    Ccbddocu.Almdes FORMAT "X(2)"
    N-Item          AT 6 FORMAT "Z9"
    ccbddocu.codmat AT 12
    almmmatg.desmat AT 22   FORMAT "x(40)"
    almmmatg.desmar AT 64   FORMAT "x(10)"
    ccbddocu.undvta AT 76   FORMAT "X(10)"
    ccbddocu.candes AT 90   FORMAT ">>>>,>>9.99"
    ccbddocu.preuni AT 102  FORMAT ">,>>9.99"
    ccbddocu.pordto AT 111  FORMAT "->>9.99"
    ccbddocu.implin AT 124  FORMAT ">>>,>>9.99"
    x-percepcion            FORMAT "X"
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.
    
imptotfac = ccbcdocu.imptot - ccbcdocu.acubon[5].

DEFINE FRAME F-Ftrfac
    HEADER
    (IF CcbCDocu.Libre_C05 <> "" THEN "Promocion:" ELSE "") AT 07 FORMAT "X(10)"
    CcbCDocu.Libre_C05 AT 18 FORMAT "X(70)" SKIP
    X-EnLetras   AT 07 SKIP
    x-Percepcion AT 07 x-Percepcion-2 AT 80 SKIP
    " Monto Cobrado   Importe de la Percepción" AT 80 WHEN x-Percepcion-2 <> '' SKIP
    x-ImpPercep-21 AT 80 WHEN x-Percepcion-2 <> ''
    x-ImpPercep-22 AT 95 WHEN x-Percepcion-2 <> '' SKIP(1)
    "Almacen : " AT 07 C-DESALM SKIP
    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" AT 3
    CcbCDocu.ImpBrt AT 68 FORMAT ">>>,>>9.99"  
    CcbCDocu.ImpDto AT 88 FORMAT ">>>,>>9.99"
    ccbcdocu.impvta AT 122 FORMAT ">>>,>>9.99" SKIP(1)
    ccbcdocu.PorIgv AT 76 FORMAT ">>9.99" "%" FORMAT "X(1)" 
    "PERCEPCION" AT 100 ccbcdocu.acubon[4] FORMAT ">9.99" "%"
        SKIP  
    x-nrocaja       AT 10 
    "/"             AT 20
    CcbCDocu.Nrosal AT 21  
    "Tarjeta :" AT 31 Ccbcdocu.NroCard  
    ccbcdocu.impigv AT 68 FORMAT ">>>,>>9.99"
    imptotfac AT 88 FORMAT ">>>,>>9.99"
    ccbcdocu.acubon[5] AT 100 FORMAT ">>>,>>9.99"
    IF ccbcdocu.codmon = 1 THEN "S/"  ELSE "US$." AT 117 FORMAT "XXXX"
    ccbcdocu.imptot AT 122 FORMAT ">>>,>>9.99"  SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200.
  */

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
         HEIGHT             = 8.5
         WIDTH              = 43.57.
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

FIND ccbdterm WHERE CcbDTerm.CodCia = s-codcia 
               AND  CcbDTerm.CodDoc = ccbcdocu.coddoc 
               AND  CcbDTerm.CodDiv = s-coddiv 
               AND  CcbDTerm.CodTer = s-codter 
               AND  CcbDTerm.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3))
              NO-LOCK NO-ERROR.
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = ccbcdocu.coddoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3)) /*CcbDTerm.NroSer */
              NO-LOCK NO-ERROR.

/*RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).*/
RUN lib/_port-name ('Facturas', OUTPUT s-port-name).

IF s-port-name = '' THEN DO:
    MESSAGE "No esta configurado la impresora :" + FacCorre.PRINTER SKIP
            "Para la division(" + S-CODDIV + "), documento(" + ccbcdocu.coddoc + ")".
    RETURN.
END.

/* Variables */
DEFINE VAR lTotItems AS INT.
DEFINE VAR lLineasxPag AS INT.  /* Cuantos lineas se va imprimir */
DEFINE VAR lLineasTotales AS INT.
DEFINE VAR lLinea AS INT.
DEFINE VAR lSec AS INT.
DEFINE VAR lTotPags AS INT.
DEFINE VAR lxTotPags AS INT.
DEFINE VAR lPagina AS INT.
DEFINE VAR lNumPag AS INT.

DEFINE VAR lItemsxPagina AS INT.
DEFINE VAR lNroItem AS INT.
DEFINE VAR lCodMat AS CHAR.
DEFINE VAR lDesMat AS CHAR.
DEFINE VAR lDesMar AS CHAR.

/****   Formato Chico   ****/

{lib/_printer-to.i 40}                                  /* Lineas a imprimir */
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(49) + {&PRN3}.     /* Lineas x Pagina */

lTotItems = 0.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK :
    lTotItems = lTotItems + 1.
END.

/*  */
lLinea = 0.
lPagina = 0.
lLineasTotales = 17.
lItemsxPagina = 19.
/* Pagina Completas */
lTotPags = TRUNCATE(lTotItems / lItemsxPagina,0).
lxTotPags = TRUNCATE(lTotItems / lItemsxPagina,0).
/* Si quedan items adicionales */
IF (lTotPags * lItemsxPagina) <> lTotItems   THEN lTotPags = lTotPags + 1.
/* Si los totales van a ir en otra pagina */
IF (lTotItems - (lxTotPags * lItemsxPagina)) > (lItemsxPagina - lLineasTotales) THEN lTotPags = lTotPags + 1.

FOR EACH ccbddocu OF ccbcdocu NO-LOCK ,
        FIRST almmmatg OF ccbddocu NO-LOCK
        BREAK BY ccbddocu.nrodoc
        BY ccbddocu.NroItm:

    IF lNroItem = 0 THEN DO:
        /* Imprimir cabecera */
        RUN ue-imprime-cabecera.
        lNroItem = 0.
    END.

    x-impbrt = ccbddocu.candes * ccbddocu.preuni.
    x-preuni = ccbddocu.preuni.
    x-dscto1 = ( 1 -  ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ) ) * 100.

    lCodMat = TRIM(ccbddocu.codmat).
    lCodMat = REPLACE(lCodMat,CHR(9),"").
    lCodMat = REPLACE(lCodMat,CHR(10),"").
    lCodMat = REPLACE(lCodMat,CHR(13),"").
    lCodMat = lCodMat + FILL(" ",10).

    lDesMat = TRIM(almmmatg.desmat).
    lDesMat = REPLACE(lDesMat,CHR(9),"").
    lDesMat = REPLACE(lDesMat,CHR(10),"").
    lDesMat = REPLACE(lDesMat,CHR(13),"").

    lDesMar = TRIM(almmmatg.desmar).
    lDesMar = REPLACE(lDesMar,CHR(9),"").
    lDesMar = REPLACE(lDesMar,CHR(10),"").
    lDesMar = REPLACE(lDesMar,CHR(13),"").

    /* Detalle del Documento */
    PUT UNFORMATTED STRING(ccbddocu.NroItm,"ZZ9") + FILL(" ",2) +           /* 6 */
        STRING(ccbddocu.Candes,"Z,ZZ9.99") + FILL(" ",2) +                 /* 12 */
        Substring(lCodmat,1,6) + FILL(" ",4) +                                       /* 9 */
        SUBSTRING(lDesMat + FILL(" ",60),1,59) + FILL(" ",2) +   /* 33 */
        SUBSTRING(lDesMar + FILL(" ",15),1,11) + FILL(" ",3) +   /* 18 */
        SUBSTRING(TRIM(ccbddocu.undvta) + FILL(" ",6),1,6) + FILL(" ",1) +     /* 6 */
        STRING(x-preuni,"ZZ,ZZ9.99") + FILL(" ",3) +                       /* 12 */
        IF x-dscto1 <> 0 THEN STRING(x-dscto1,">>9.9999") + FILL (" ",2)
            ELSE FILL(" ", 8) +                                            /* 11 */
        STRING(ccbddocu.implin,">>>,>>9.99") SKIP.

    lLinea = lLinea + 1.
    lNroItem = lNroItem + 1.

    IF lNroItem = lItemsxPagina THEN DO:
        /* Pie de Pagina y Salto */
        lLinea = 0.        

        PUT UNFORMATTED FILL("-",137).
        PUT UNFORMATTED FILL(" ",115) + "Pagina " + STRING(lPagina,">>9") + 
                    " de " + STRING(lTotPags,">>9") SKIP.
        
        /* Salto de pagina */
        /*PUT CONTROL CHR(12).*/
        lNroItem = 0.
    END.
END.

IF lNroItem = 0 OR (lNroItem > (lItemsxPagina - lLineasTotales)) THEN DO:
    /* 
        Justo coincido el nro de items
        o todas las lineas de totales no entrar en una misma pagina
     */
    /*lTotPags = lTotPags + 1.*/
    /*PUT CONTROL CHR(12).*/
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

/*
FIND ccbdterm WHERE CcbDTerm.CodCia = s-codcia 
               AND  CcbDTerm.CodDoc = ccbcdocu.coddoc 
               AND  CcbDTerm.CodDiv = s-coddiv 
               AND  CcbDTerm.CodTer = s-codter 
               AND  CcbDTerm.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3))
              NO-LOCK NO-ERROR.
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = ccbcdocu.coddoc 
               AND  FacCorre.NroSer = CcbDTerm.NroSer 
              NO-LOCK NO-ERROR.
CASE Ccbcdocu.coddiv:
    WHEN "00000" THEN DO:
        RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
        IF s-port-name = '' THEN RETURN.
        /****   Formato Grande  ****/
        {lib/_printer-to.i 60}
        PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     
    END.
/*     WHEN "00005" THEN DO:       /* JESUS OBRERO */          */
/*         MESSAGE "Se van a Imprimir FACTURAS" SKIP           */
/*             "Escoja la impresora"                           */
/*             VIEW-AS ALERT-BOX WARNING.                      */
/*         DEF VAR rpta AS LOG NO-UNDO.                        */
/*         SYSTEM-DIALOG PRINTER-SETUP  UPDATE rpta.           */
/*         IF rpta = NO THEN RETURN.                           */
/*         OUTPUT TO PRINTER PAGE-SIZE 43.                     */
/*         PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}. */
/*     END.                                                    */
    OTHERWISE DO:
        RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
        IF s-port-name = '' THEN RETURN.
        /****   Formato Chico   ****/
        {lib/_printer-to.i 43}
        PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     
    END.
END CASE.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK ,
        FIRST almmmatg OF ccbddocu NO-LOCK
        BREAK BY ccbddocu.nrodoc
        BY ccbddocu.NroItm:
    VIEW FRAME F-HdrFac.
    VIEW FRAME F-FtrFac.

    x-dscto = 0.
    IF CcbDDocu.undvta = Almmmatg.UndA THEN
        x-dscto = Almmmatg.dsctos[1]. ELSE
    IF CcbDDocu.undvta = Almmmatg.UndB THEN
        x-dscto = Almmmatg.dsctos[2]. ELSE
    IF CcbDDocu.undvta = Almmmatg.UndC THEN
        x-dscto = Almmmatg.dsctos[3].

    x-impbrt = ccbddocu.candes * ccbddocu.preuni.
    n-item = n-item + 1.
    x-preuni = ccbddocu.preuni.
    x-dscto1 = ( 1 -  ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ) ) * 100.

    DISPLAY ccbddocu.almdes
            n-item      
            ccbddocu.codmat
            almmmatg.desmat
            almmmatg.desmar
            ccbddocu.candes
            ccbddocu.undvta
            x-preuni @ ccbddocu.preuni
            x-dscto1 WHEN x-dscto1 <> 0 @ ccbddocu.pordto
            ccbddocu.implin
            "*" WHEN ccbddocu.impdcto_adelanto[5] > 0 @ x-percepcion  
            WITH FRAME F-DetaFac.

    IF LAST-OF(ccbddocu.nrodoc)
    THEN DO:
        PAGE.
    END.
END.

OUTPUT CLOSE.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ue-imprime-cabecera) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imprime-cabecera Procedure 
PROCEDURE ue-imprime-cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

