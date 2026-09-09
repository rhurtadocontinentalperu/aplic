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

DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR x-impbrt   AS DECIMAL NO-UNDO.
DEF VAR C-NomCon   AS CHAR FORMAT "X(40)".
DEF VAR N-ITEM     AS INTEGER INIT 0 NO-UNDO.
DEF VAR X-Cheque   AS CHAR NO-UNDO.
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".

DEF VAR imptotfac like ccbcdocu.imptot.

DEFINE VARIABLE x-dscto AS DECIMAL.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = 0 
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK NO-ERROR.

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
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

/* Verifica que la cancelación se realizó con CHEQUE */
x-cheque = "".
IF CcbCDocu.Flgest = 'C' THEN DO:
   FIND FIRST CcbDCaja WHERE CcbDCaja.CodCia = s-codcia 
                        AND  CcbDCaja.CodRef = CcbCDocu.Coddoc 
                        AND  CcbDCaja.NroRef = CcbCDocu.Nrodoc 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE CcbDCaja THEN DO:
      FIND CcbCCaja OF CcbDCaja NO-LOCK NO-ERROR.
      IF AVAILABLE CcbCCaja THEN DO:
         x-cheque = TRIM(CcbCCaja.Voucher[2]) + TRIM(CcbCCaja.Voucher[3]).
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


DEFINE FRAME F-HdrFac
    HEADER
    SKIP(5)
    ccbcdocu.nomcli AT 11 FORMAT "x(50)" 
    CcbCDocu.CodCli AT 62
    
    ccbcdocu.dircli AT 11 FORMAT "x(50)" 
    ccbcdocu.RucCli AT 62
     
    C-NomCon        AT 62 FORMAT "X(15)" SKIP(2)
/*    ccbcdocu.nrodoc AT 110 FORMAT "XXX-XXXXXX" SKIP(2)*/
    
    ccbcdocu.fchdoc AT 01
    CcbCDocu.NroPed AT 18 FORMAT "X(10)"
/*    CcbCDocu.NroRef AT 18 FORMAT "X(10)"*/
    CcbCDocu.NroOrd AT 50 /*SKIP(2)*/
    ccbcdocu.nrodoc AT 110 FORMAT "XXX-XXXXXX" SKIP(2)
    
    IF ccbcdocu.codmon = 1 THEN "SOLES"  ELSE "DOLARES" AT 01 FORMAT "X(8)"
    "MOSTRADOR" AT 22
    CcbCDocu.CodVen AT 55
    STRING(TIME,"HH:MM:SS") AT 68
    SKIP(2)
    
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaFac
    N-Item          AT 3 FORMAT "Z9"
    ccbddocu.codmat AT 12
    almmmatg.desmat AT 22   FORMAT "x(40)"
    almmmatg.desmar AT 64   FORMAT "x(10)"
    ccbddocu.undvta AT 76   FORMAT "X(10)"
    ccbddocu.candes AT 90   FORMAT ">>>>,>>9.99"
    ccbddocu.preuni AT 105  FORMAT ">,>>9.99"
    ccbddocu.pordto AT 116  FORMAT "->>9.99"
    ccbddocu.implin AT 126  FORMAT ">>,>>>9.99"
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.
    
imptotfac = ccbcdocu.imptot.

DEFINE FRAME F-Ftrfac
    HEADER
    X-EnLetras AT 07 skip
    "Almacen : " AT 7 C-DESALM SKIP
    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" AT 3
    CcbCDocu.ImpBrt AT 68 FORMAT ">>>,>>9.99"
    CcbCDocu.ImpDto AT 88 FORMAT ">>>,>>9.99"
    ccbcdocu.impvta AT 122 FORMAT ">>>,>>9.99" SKIP(2)
    CcbDCaja.Nrodoc AT 15
    ccbcdocu.impigv AT 68 FORMAT ">>>,>>9.99"
    imptotfac AT 88 FORMAT ">>>,>>9.99"
    IF ccbcdocu.codmon = 1 THEN "S/."  ELSE "US$." AT 117 FORMAT "XXXX"
    ccbcdocu.imptot AT 122 FORMAT ">>>,>>9.99" SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
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
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).
FIND ccbdterm WHERE CcbDTerm.CodCia = s-codcia 
               AND  CcbDTerm.CodDoc = ccbcdocu.coddoc 
               AND  CcbDTerm.CodDiv = s-coddiv 
               AND  CcbDTerm.CodTer = s-codter 
               AND  CcbDTerm.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3))
              NO-LOCK.
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = ccbcdocu.coddoc 
               AND  FacCorre.NroSer = CcbDTerm.NroSer 
              NO-LOCK.

IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").
/*
OUTPUT TO VALUE(s-port-name) PAGE-SIZE 42 .
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     
*/

IF s-coddiv = "00001" THEN DO:
    OUTPUT TO VALUE(s-port-name) PAGE-SIZE 60.
    PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     
END.
ELSE DO: 
    OUTPUT TO VALUE(s-port-name) PAGE-SIZE 42 .
    PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     
END.
    

/* Detalle */

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
    
    DISPLAY n-item 
            ccbddocu.codmat 
            almmmatg.desmat 
            almmmatg.desmar
            ccbddocu.candes 
            ccbddocu.undvta 
            ccbddocu.preuni 
            ccbddocu.pordto - x-dscto @ ccbddocu.pordto
            ccbddocu.implin 
            WITH FRAME F-DetaFac.

    IF LAST-OF(ccbddocu.nrodoc)
    THEN DO:
        PAGE.
    END.
END.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


