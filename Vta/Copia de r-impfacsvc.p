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
DEF SHARED VAR cl-CODCIA AS INTEGER.
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
DEF VAR imptotfac like ccbcdocu.imptot.
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".
DEF VAR C-INTERE   AS CHAR NO-UNDO FORMAT "X(100)" INIT " ".

DEFINE VARIABLE x-dscto AS DECIMAL.

IF S-CODDIV <> "00000" THEN DO:
 C-INTERE = "INTERES POR DIA VENCIDO 0.059%        RECIBI CONFORME : .................................." .
END.
FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
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
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
DEFINE FRAME F-HdrFac
    HEADER
    SKIP(3)
    gn-divi.faxdiv FORMAT 'x(50)' WHEN AVAILABLE gn-divi SKIP
    ccbcdocu.nomcli AT 11 FORMAT "x(50)" 
    CcbCDocu.CodCli AT 62
    
    ccbcdocu.dircli AT 11 FORMAT "x(50)" 
    /*ccbcdocu.RucCli AT 62 FORMAT "x(11)"*/
    ccbcdocu.RucCli AT 11 FORMAT "x(11)"
    
    C-NomCon        AT 62 FORMAT "X(15)" SKIP(1)
      '                       ' AT 92  FORMAT "X(20)" SKIP

    ccbcdocu.fchdoc AT 01
    CcbCDocu.NroPed AT 18 FORMAT "X(10)"
    CcbCDocu.NroRef AT 38 FORMAT "X(20)" SKIP
    /* RHC 06.01.10 AGENTE RETENEDOR */
    'Incorp. al reg. de agentes de retencion de IGV (RS:265-2009) a partir del 01/01/10' SKIP(1)
    
    IF ccbcdocu.codmon = 1 THEN "SOLES"  ELSE "DOLARES" AT 01 FORMAT "X(8)"
    "OFICINA" AT 22
    CcbCDocu.FchVto AT 38 FORMAT "99/99/9999"
    CcbCDocu.CodVen AT 55
    STRING(TIME,"HH:MM:SS") AT 68
    S-USER-ID AT 90
    ccbcdocu.nrodoc AT 120 FORMAT "XXX-XXXXXX" SKIP(2)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaFac
    N-Item          AT 3   FORMAT "Z9"
    ccbddocu.codmat AT 12
    almmserv.desmat AT 22  FORMAT "x(40)"
    ccbddocu.undvta AT 76  FORMAT "X(10)"
    ccbddocu.candes AT 86  FORMAT ">>>>,>>9.99"
    ccbddocu.preuni AT 98  FORMAT ">>>>>>9.99"
    ccbddocu.pordto /*AT 109*/ FORMAT "->>9.99"
    ccbddocu.implin AT 120 FORMAT ">>>>>>9.99" SKIP
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

imptotfac = ccbcdocu.imptot.

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
         HEIGHT             = 3.62
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
DEF VAR x-Contador AS INT.
DEF VAR k AS INT.
DEF VAR x-Linea AS CHAR.

FIND FacCorre WHERE
    FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.CodDoc = CcbCDocu.CodDoc AND
    FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3)) NO-LOCK.

DEF VAR answer AS LOGICAL NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.

DEFINE FRAME F-DetaFac-1
    x-linea AT 22  FORMAT "x(50)" SKIP
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-Ftrfac
    HEADER
    "SON : " X-EnLetras AT 07 SKIP(4) 
    'O.Compra: ' AT 3 CcbCDocu.NroOrd 
     CcbCDocu.ImpBrt AT 65 FORMAT ">>>,>>9.99"
    CcbCDocu.ImpDto AT 85 FORMAT ">>>,>>9.99"
    ccbcdocu.impvta AT 120 FORMAT ">>>,>>9.99" SKIP
    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" AT 3
    ccbcdocu.PorIgv AT 73  FORMAT ">>9.99" "%" FORMAT "X(1)" SKIP(1)
    ccbcdocu.impigv AT 65 FORMAT ">>>,>>9.99"
    imptotfac AT 85 FORMAT ">>>,>>9.99"
    IF ccbcdocu.codmon = 1 THEN "S/."  ELSE "US$" AT 102 FORMAT "XXX"
    {&PRN2} + {&PRN6A}  ccbcdocu.imptot  {&PRN6B}  + {&PRN3}  AT 106 FORMAT ">,>>>,>>9.99" SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200.
    

    OUTPUT TO PRINTER PAGE-SIZE 42.
    PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.    

FOR EACH ccbddocu OF ccbcdocu NO-LOCK ,
        FIRST almmserv OF ccbddocu 
        NO-LOCK
        BREAK BY ccbddocu.nrodoc 
              BY ccbddocu.NroItm:

    VIEW FRAME F-HdrFac.
    VIEW FRAME F-FtrFac.
    
    N-Item = N-Item + 1.
    x-impbrt = ccbddocu.preuni * ccbddocu.candes.
    DISPLAY n-item 
            ccbddocu.codmat 
            almmserv.desmat 
            ccbddocu.candes 
            ccbddocu.undvta 
            ccbddocu.preuni 
            CcbDDocu.Por_Dsctos[1] @ ccbddocu.pordto
            ccbddocu.implin SKIP
            WITH FRAME F-DetaFac.
    /* imprimimos detalle */
    IF CcbDDocu.Flg_Factor <> '' THEN DO:
        x-Linea = ''.
        DO k = 1 TO LENGTH(CcbDDocu.Flg_Factor):
            x-Linea = x-Linea + SUBSTRING(CcbDDocu.Flg_Factor, k , 1).
            IF SUBSTRING(CcbDDocu.Flg_Factor, k , 1) = CHR(10) 
                OR SUBSTRING(CcbDDocu.Flg_Factor, k , 1) = CHR(12) 
                OR SUBSTRING(CcbDDocu.Flg_Factor, k , 1) = CHR(13) 
                OR (k >= 50 AND k MODULO 50 = 0) THEN DO:
                DISPLAY x-linea WITH FRAME f-Detafac-1.
                DOWN WITH FRAME f-Detafac-1.
                x-linea = ''.
            END.
        END.
        IF x-linea <> '' THEN DO:
            DISPLAY x-linea WITH FRAME f-Detafac-1.
            DOWN WITH FRAME f-Detafac-1.
        END.
    END.
    /* ****************** */
    IF LAST-OF(ccbddocu.nrodoc)
    THEN DO:
        PAGE.
    END.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


