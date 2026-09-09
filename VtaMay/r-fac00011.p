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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR CL-CODCIA AS INT.

DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR x-impbrt   AS DECIMAL NO-UNDO.
DEF VAR x-dscto1   AS DECIMAL NO-UNDO.
DEF VAR x-preuni   AS DECIMAL NO-UNDO.
DEF VAR C-NomCon   AS CHAR FORMAT "X(40)".
DEF VAR N-ITEM     AS INTEGER INIT 0 NO-UNDO.

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
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/
DEFINE FRAME F-HdrFac
    HEADER
    SKIP(5)
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
    "OFICINA" AT 24
    CcbCDocu.FchVto AT 50
    CcbCDocu.CodVen AT 70
    STRING(TIME,"HH:MM:SS") AT 90
    S-User-Id  AT 115 FORMAT "X(20)"
    SKIP(2)    
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
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.
    
imptotfac = ccbcdocu.imptot.

DEFINE FRAME F-Ftrfac
    HEADER
    X-EnLetras   AT 07 SKIP /*(2)*/
    "EN CASO DE NO SER PAGADO AL VCTO. SE COBRARAN GASTOS E INTERESES COMPENSATORIOS Y MORATORIOS DE ACUERDO A LEY" SKIP(1)
    "Almacen : " AT 07 C-DESALM SKIP
    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" AT 3
    CcbCDocu.ImpBrt AT 68 FORMAT ">>>,>>9.99"  
    CcbCDocu.ImpDto AT 88 FORMAT ">>>,>>9.99"
    ccbcdocu.impvta AT 122 FORMAT ">>>,>>9.99" SKIP
    ccbcdocu.PorIgv AT 76 FORMAT ">>9.99" "%" SKIP  
    x-nrocaja       AT 10 
    "/"             AT 20
    CcbCDocu.Nrosal AT 21  
    "Tarjeta :" AT 31 Ccbcdocu.NroCard  
    ccbcdocu.impigv AT 68 FORMAT ">>>,>>9.99"
    imptotfac AT 88 FORMAT ">>>,>>9.99"
    IF ccbcdocu.codmon = 1 THEN "S/."  ELSE "US$." AT 117 FORMAT "XXXX"
    ccbcdocu.imptot AT 122 FORMAT ">>>,>>9.99"  SKIP
    /*x-contipuntos*/ SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200.

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
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = ccbcdocu.coddoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(Ccbcdocu.NroDoc,1,3))
              NO-LOCK.
RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.

    /*OUTPUT TO PRINTER VALUE(s-port-name) PAGE-SIZE 42 .*/
    {lib/_printer-to.i 42}
    PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     


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
    x-preuni = ccbddocu.preuni.
    x-dscto1 = CcbDDocu.Por_Dsctos[1].
    IF CcbDDocu.Por_Dsctos[1] < 0 THEN DO:
       x-preuni = ccbddocu.implin / ccbddocu.candes .
       x-dscto1 = 0.  
    END.

    DISPLAY ccbddocu.almdes
            n-item 
            ccbddocu.codmat
            almmmatg.desmat
            almmmatg.desmar
            ccbddocu.candes
            ccbddocu.undvta
            x-preuni @ ccbddocu.preuni
            x-dscto1 @ ccbddocu.pordto
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


