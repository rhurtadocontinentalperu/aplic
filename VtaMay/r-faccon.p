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

FIND Ccbcmvto WHERE ROWID(Ccbcmvto) = x-Rowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcmvto THEN RETURN.

FIND ccbcdocu WHERE ccbcdocu.codcia = ccbcmvto.codcia
    AND ccbcdocu.coddoc = SUBSTRING(ccbcmvto.nroref,1,3)
    AND ccbcdocu.nrodoc = SUBSTRING(ccbcmvto.nroref,4) NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA 
    AND  gn-clie.codcli = ccbcdocu.codcli 
    NO-LOCK NO-ERROR.

C-NomCon = "".

/*FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
 * IF AVAIL CcbDdocu THEN DO:
 *     FIND Almacen WHERE Almacen.CodCia = ccbcdocu.codcia 
 *                   AND  Almacen.CodAlm = CcbDDocu.AlmDes 
 *                  NO-LOCK NO-ERROR.
 *     IF AVAILABLE Almacen THEN 
 *         ASSIGN C-DESALM = Almacen.CodAlm + " - " + Almacen.Descripcion.
 * END.
 * ELSE DO:
 *     FIND Almacen WHERE Almacen.CodCia = ccbcdocu.codcia 
 *                   AND  Almacen.CodAlm = ccbcdocu.codalm 
 *                  NO-LOCK NO-ERROR.
 *     IF AVAILABLE Almacen THEN 
 *         ASSIGN C-DESALM = Almacen.CodAlm + " - " + Almacen.Descripcion.
 * END.*/
FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
c-DesAlm = gn-divi.dirdiv.

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
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
/*X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").*/

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
         HEIGHT             = 2.08
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
DEF VAR rpta AS LOG NO-UNDO.

/* Definimos impresoras */
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

DEF VAR x-NroDoc AS CHAR NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.

x-ImpTot = Ccbcmvto.imptot.
x-NroDoc = STRING(ccbcdocu.nrodoc, 'XXX-XXXXXX').

/************************  DEFINICION DE FRAMES  *******************************/
DEFINE FRAME F-HdrFac
    HEADER
    SPACE(1) SKIP(6)
    ccbcdocu.nomcli AT 20 FORMAT "x(50)" 
    CcbCDocu.CodCli AT 70 FORMAT "x(11)" SKIP
    ccbcdocu.dircli AT 20 FORMAT "x(50)" 
    ccbcdocu.RucCli AT 70 FORMAT "x(11)"
    {&PRN6A} + {&PRN7A} + x-nrodoc + {&PRN6B} + {&PRN7B}  AT 100 FORMAT 'x(15)' SKIP
    ccbcmvto.glosa  AT 20 FORMAT 'x(20)'
    C-NomCon        AT 77 FORMAT "X(15)" SKIP(2)
    ccbcdocu.nrodoc AT 16 FORMAT 'XXX-XXXXXX'
    ccbcdocu.fchdoc AT 35
    (IF ccbcdocu.codmon = 1 THEN "S/."  ELSE "US$") AT 62 FORMAT "X(3)"
    ccbcdocu.imptot
    c-desalm        AT 84  FORMAT 'x(20)' 
    ccbcmvto.codage AT 111 FORMAT 'x(20)' SKIP(2)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 320.

DEFINE FRAME F-DetaFac
    N-Item          AT 12   FORMAT "Z9"
    ccbddocu.codmat AT 23
    almmmatg.desmat AT 33  FORMAT "x(50)"
    ccbddocu.undvta AT 87  FORMAT "X(10)"
    ccbddocu.candes AT 100  FORMAT ">>>,>>9.99"
    ccbddocu.preuni AT 114 FORMAT ">,>>9.99"
    ccbddocu.implin AT 129 FORMAT ">>,>>9.99" 
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 320.

DEF VAR x-NroCuo AS CHAR FORMAT 'X' EXTENT 3.
DEF VAR x-ImpCuo AS DEC  FORMAT '>>>,>>>,>>9.99' EXTENT 3.
DEF VAR x-VtoCuo AS DATE EXTENT 3.

FOR EACH Ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia
        AND ccbdmvto.coddoc = ccbcmvto.coddoc
        AND ccbdmvto.nrodoc = ccbcmvto.nrodoc NO-LOCK:
    CASE ccbdmvto.tporef:
        WHEN '1' THEN ASSIGN
                        x-NroCuo[1] = '1'
                        x-ImpCuo[1] = ccbdmvto.imptot
                        x-VtoCuo[1] = ccbdmvto.fchvto.
        WHEN '2' THEN ASSIGN
                        x-NroCuo[2] = '2'
                        x-ImpCuo[2] = ccbdmvto.imptot
                        x-VtoCuo[2] = ccbdmvto.fchvto.
        WHEN '3' THEN ASSIGN
                        x-NroCuo[3] = '3'
                        x-ImpCuo[3] = ccbdmvto.imptot
                        x-VtoCuo[3] = ccbdmvto.fchvto.
    END CASE.
END.
        
DEFINE FRAME F-Ftrfac
    HEADER
    ccbcmvto.imptot AT 129 FORMAT ">>,>>9.99" SKIP
    {&PRN4} AT 1
    gn-clie.nomcli  AT 135 SKIP
    x-NroCuo[1] AT 20
    x-ImpCuo[1] AT 45
    x-VtoCuo[1] AT 85
    ccbcdocu.nomcli AT 130 SKIP
    x-NroCuo[2] AT 20
    x-ImpCuo[2] AT 45
    x-VtoCuo[2] AT 85
    gn-clie.repleg[1] AT 130 FORMAT 'x(20)' SKIP
    x-NroCuo[3] AT 20
    x-ImpCuo[3] AT 45
    x-VtoCuo[3] AT 85
    ccbcmvto.glosa AT 115 SKIP    
    ccbcdocu.dircli AT 118 SKIP
    x-imptot AT 145 FORMAT '>>,>>9.99' SKIP
    x-enletras AT 111 SKIP(2)
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 320.

OUTPUT TO PRINTER PAGE-SIZE 45.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(51) + {&PRN3}.     

FOR EACH ccbddocu OF ccbcdocu NO-LOCK ,
        FIRST almmmatg OF ccbddocu 
        NO-LOCK
        BREAK BY ccbddocu.nrodoc 
              BY ccbddocu.NroItm:
    VIEW FRAME F-HdrFac.
    VIEW FRAME F-FtrFac.
    
    N-Item = N-Item + 1.
    x-impbrt = ccbddocu.preuni * ccbddocu.candes.
    x-preuni = ccbddocu.preuni.
    x-dscto1 = ccbddocu.pordto.
    /* RHC 03.11.04 cambio del campo de % descuento
    x-dscto1 = CcbDDocu.Por_Dsctos[1].
    IF CcbDDocu.Por_Dsctos[1] < 0 THEN DO:
       x-preuni = ccbddocu.implin / ccbddocu.candes .
       x-dscto1 = 0.  
    END.
    *************** */
    DISPLAY 
            n-item 
            ccbddocu.codmat 
            almmmatg.desmat 
            ccbddocu.undvta 
            ccbddocu.candes 
            x-preuni @ ccbddocu.preuni
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


