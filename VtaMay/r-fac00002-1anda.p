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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR CL-codcia AS INT.
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter LIKE ccbcterm.codter.
DEF SHARED VAR S-USER-ID AS CHAR.

DEF VAR C-NomCon AS CHAR FORMAT "X(40)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(90)" NO-UNDO.
DEF VAR D-EXO AS CHAR FORMAT "X(1)".
DEF VAR N-ITEM AS INTEGER INIT 0.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-VCMTOS LIKE gn-ConVt.Vencmtos.
DEF VAR A-VCMTOS AS CHAR EXTENT 10 FORMAT "X(10)".
DEF VAR O-VCMTOS AS CHAR FORMAT "X(15)".
DEF VAR x-impbrt AS DECIMAL NO-UNDO.
DEF VAR x-BRUTO  AS DECIMAL NO-UNDO.
DEF VAR x-DTOESP AS DECIMAL NO-UNDO.
DEF VAR x-IMPDTO AS DECIMAL NO-UNDO.
DEF VAR x-dscto1 AS DECIMAL NO-UNDO.
DEF VAR x-preuni AS DECIMAL NO-UNDO.
DEF VAR imptotfac like ccbcdocu.imptot.
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".
DEFINE VARIABLE x-dscto AS DECIMAL.
DEF VAR x-DirRef   LIKE Gn-clie.dirref NO-UNDO.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK NO-ERROR.

C-NomCon = "".
IF AVAILABLE GN-clie THEN x-DirRef = GN-clie.dirref.


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
   ASSIGN C-NomCon = gn-ConVt.Nombr
          X-VCMTOS = gn-ConVt.Vencmtos.

DO N-ITEM = 1 TO NUM-ENTRIES(X-VCMTOS):
   IF N-ITEM <= 10 THEN 
      A-VCMTOS[N-ITEM] = STRING(ccbcdocu.fchdoc + INTEGER(ENTRY(N-ITEM,X-VCMTOS)),"99/99/9999").
   ELSE
      O-VCMTOS = O-VCMTOS + "," + STRING(ccbcdocu.fchdoc + INTEGER(ENTRY(N-ITEM,X-VCMTOS)),"99/99/9999").
END.
A-VCMTOS[10] = A-VCMTOS[10] + O-VCMTOS.
N-ITEM = 0.

IF CcbCDocu.CodDpto <> "" AND CcbCDocu.CodProv <> "" AND CcbCDocu.CodDist <> "" THEN DO:
   FIND TabDistr WHERE TabDistr.CodDepto = CcbCDocu.CodDpto 
                  AND  TabDistr.CodProvi = CcbCDocu.CodProv 
                  AND  TabDistr.CodDistr = CcbCDocu.CodDist 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE TabDistr THEN X-ZONA = TabDistr.NomDistr.
   FIND TabProvi WHERE TabProvi.CodDepto = CcbCDocu.CodDpto 
                  AND  TabProvi.CodProvi = CcbCDocu.CodProv 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE TabProvi THEN X-ZONA = X-ZONA + " - " + TabProvi.NomProvi.
END.

/************************  PUNTEROS EN POSICION  *******************************/
/*RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).*/
RUN bin/_numero( ( ccbcdocu.imptot - ccbcdocu.imptot2 ), 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").


imptotfac = ccbcdocu.imptot.

X-DTOESP =  CcbCDocu.ImpDto - (CcbCDocu.AcuBon[2] + CcbCDocu.AcuBon[3]) .
X-DTOESP = IF X-DTOESP < 0 THEN 0 ELSE X-DTOESP.
X-IMPDTO = IF CcbCDocu.ImpDto < 0 THEN 0 ELSE CcbCDocu.ImpDto.
X-BRUTO  = IF X-IMPDTO = 0 THEN CcbCDocu.Impvta ELSE CcbCDocu.ImpBrt.

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
         HEIGHT             = 4.15
         WIDTH              = 45.
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
DEF VAR x-Contipuntos AS CHAR NO-UNDO FORMAT 'x(20)'.

IF Ccbcdocu.NroCard <> '' AND CcbCDocu.puntos > 0
THEN x-Contipuntos = 'CONTIPUNTOS: ' + STRING(ccbcdocu.puntos, '>>>>>>>9').

/************************  DEFINICION DE FRAMES  *******************************/
DEFINE FRAME F-HdrFac
    HEADER
    SPACE(1) SKIP(4.5)
    gn-clie.aval1[5]    SKIP
    ccbcdocu.nomcli AT 11 FORMAT "x(50)" 
    CcbCDocu.CodCli AT 62 FORMAT "x(11)" SKIP
    ccbcdocu.dircli AT 11 FORMAT "x(50)" SKIP
    ccbcdocu.RucCli AT 11 FORMAT "x(11)" 
    C-NomCon        AT 62 FORMAT "X(15)" SKIP
    '' AT 92  FORMAT "X(20)" SKIP(2)
    ccbcdocu.fchdoc AT 01
    CcbCDocu.NroPed AT 18 FORMAT "X(10)"
    CcbCDocu.NroOrd AT 50 SKIP
    /* RHC 06.01.10 AGENTE RETENEDOR */
    'Incorp. al reg. de agentes de retencion de IGV (RS:265-2009) a partir del 01/01/10' SKIP(1.5)
    
    IF ccbcdocu.codmon = 1 THEN "SOLES"  ELSE "DOLARES" AT 01 FORMAT "X(8)"
    "OFICINA" AT 22
    CcbCDocu.FchVto AT 38 FORMAT "99/99/9999"
    CcbCDocu.CodVen AT 55
    STRING(TIME,"HH:MM:SS") AT 68
    S-USER-ID AT 90
    ccbcdocu.nrodoc AT 122 FORMAT "XXX-XXXXXX" SKIP(1)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaFac
    Ccbddocu.almdes format "x(2)"  
    N-Item          AT 6   FORMAT "Z9"
    ccbddocu.codmat AT 12
    almmmatg.desmat AT 22  FORMAT "x(40)"
    almmmatg.desmar AT 64  FORMAT "x(10)"
    ccbddocu.undvta AT 76  FORMAT "X(10)"
    ccbddocu.candes AT 90  FORMAT ">>>,>>9.99"
    ccbddocu.preuni AT 103 FORMAT "->,>>9.99"
    ccbddocu.pordto AT 112 FORMAT "->>9.99"
    ccbddocu.implin AT 124 FORMAT "->>>,>>9.99" 
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-Ftrfac
    HEADER
    X-EnLetras AT 07 SKIP(1) 
    {&PRN6A} + "INTERES POR DIA VENCIDO 0.059%        RECIBI CONFORME : .................................." + {&PRN6B} FORMAT "X(100)" AT 7  SKIP /*(1)*/
    "EN CASO DE NO SER PAGADO AL VCTO. SE COBRARAN GASTOS E INTERESES COMPENSATORIOS Y MORATORIOS DE ACUERDO A LEY" SKIP
    "Almacen : " AT 7 C-DESALM SKIP     /****   Add by C.Q. 17/03/2000  *****/
    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" AT 3
    X-BRUTO         AT 68 FORMAT ">>>,>>9.99"
    CcbCDocu.PorDto AT 79 FORMAT "->9.99"
    "%" FORMAT "X(1)"
    X-IMPDTO        AT 88 FORMAT ">>>,>>9.99"
    ccbcdocu.impvta AT 122 FORMAT ">>>,>>9.99" SKIP(1)
    ccbcdocu.PorIgv AT 72 FORMAT ">>9.99" "%" FORMAT "X(1)"
    "ADELANTO" AT 105 WHEN Ccbcdocu.ImpTot2 > 0 SKIP
    ccbcdocu.nrosal at 15 
    "Tarjeta :" AT 31 Ccbcdocu.NroCard  
    ccbcdocu.impigv AT 68 FORMAT ">>>,>>>,>>9.99"
    imptotfac AT 88 FORMAT ">>>,>>>,>>9.99"
    Ccbcdocu.ImpTot2 AT 105 FORMAT ">>>,>>9.99" WHEN Ccbcdocu.ImpTot2 > 0
    IF ccbcdocu.codmon = 1 THEN "S/."  ELSE "US$." AT 117 FORMAT "XXXX"
    ( ccbcdocu.imptot -  ccbcdocu.imptot2 ) AT 122 FORMAT ">>>,>>>,>>9.99"
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = CcbCDocu.CodDoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))  
              NO-LOCK.
RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.
{lib/_printer-to.i 42}
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

FOR EACH ccbddocu OF ccbcdocu NO-LOCK ,
        FIRST almmmatg OF ccbddocu NO-LOCK
        BREAK BY ccbddocu.nrodoc 
              BY ccbddocu.NroItm:
    VIEW FRAME F-HdrFac.
    VIEW FRAME F-FtrFac.
    
    N-Item = N-Item + 1.
    x-impbrt = ccbddocu.preuni * ccbddocu.candes.
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
            WITH FRAME F-DetaFac.
    IF LAST-OF(ccbddocu.nrodoc)
    THEN DO:
        PAGE.
    END.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


