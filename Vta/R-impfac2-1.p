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
DEF SHARED VAR CL-CODCIA AS INTEGER.
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter LIKE ccbcterm.codter.
DEF SHARED VAR S-USER-ID AS CHAR.

DEF VAR C-NomCon AS CHAR FORMAT "X(40)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(90)" NO-UNDO.
DEF VAR x-Percepcion AS CHAR FORMAT 'x(150)' NO-UNDO.
DEF VAR x-ImpPercep-21 LIKE ccbcdocu.imptot NO-UNDO.
DEF VAR x-ImpPercep-22 LIKE ccbcdocu.imptot NO-UNDO.
DEF VAR D-EXO AS CHAR FORMAT "X(1)".
DEF VAR N-ITEM AS INTEGER INIT 0.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-VCMTOS LIKE gn-ConVt.Vencmtos.
DEF VAR A-VCMTOS AS CHAR EXTENT 10 FORMAT "X(10)".
DEF VAR O-VCMTOS AS CHAR FORMAT "X(15)".
DEF VAR x-impbrt AS DECIMAL NO-UNDO.
DEF VAR x-dscto1 AS DECIMAL NO-UNDO.
DEF VAR imptotfac like ccbcdocu.imptot.
DEF VAR imptotres LIKE ccbcdocu.imptot2 NO-UNDO.
DEF VAR chcondi   AS INTEGER NO-UNDO INIT 0.
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".
DEF VAR C-INTERE   AS CHAR NO-UNDO FORMAT "X(100)" INIT " ".
DEF VAR x-UsrRef AS CHAR FORMAT 'x(10)'.
DEF VAR x-NroRef AS CHAR FORMAT 'x(12)' NO-UNDO.

DEFINE VARIABLE x-dscto AS DECIMAL.

IF S-CODDIV <> "00000" THEN DO:
 C-INTERE = "INTERES POR DIA VENCIDO 0.059%        RECIBI CONFORME : .................................." .
END.
FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND  gn-clie.codcli = ccbcdocu.codcli 
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

FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddiv = Ccbcdocu.divori
    AND Faccpedi.coddoc = Ccbcdocu.codped
    AND Faccpedi.nroped = Ccbcdocu.nroped
    NO-LOCK NO-ERROR.
IF AVAILABLE Faccpedi THEN x-UsrRef = Faccpedi.usuario.

IF Ccbcdocu.CodRef = 'G/R' THEN x-NroRef = Ccbcdocu.NroRef.
ELSE x-NroRef = "".

/************************  PUNTEROS EN POSICION  *******************************/
IF ccbcdocu.imptot2 > 0 THEN
    RUN bin/_numero(ccbcdocu.imptot - ccbcdocu.imptot2, 2, 1, OUTPUT X-EnLetras).
ELSE 
    RUN bin/_numero(ccbcdocu.imptot - ccbcdocu.acubon[5], 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").
x-Percepcion = "".
IF ccbcdocu.acubon[5] > 0 THEN DO : 
    IF (CcbCDocu.FmaPgo = '000' OR CcbCDocu.FmaPgo = '002') THEN DO:
        /* Venta al Contado */
        x-Percepcion = "* Operación sujeta a percepción del IGV * " +
            FILL(" ", 40) + "Comprobante de Percepcion - Venta Interna".
        x-ImpPercep-21 = ccbcdocu.imptot.
        x-ImpPercep-22 = ccbcdocu.acubon[5].
    END.
    ELSE DO:
        /* Venta al Credito */
        x-Percepcion = "* Operación sujeta a percepción del IGV. Solo podrá usar la percepción " +
            "de esta factura una vez emitido el correspondiente comprobante de percepción".
    END.
END.

/************************  DEFINICION DE FRAMES  *******************************/
DEF VAR c-DirCli AS CHAR NO-UNDO.

c-DirCli = TRIM(Ccbcdocu.dircli).
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN c-DirCli = c-DirCli + ' - ' + TRIM(TabDepto.NomDepto).
FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
    AND TabProvi.CodProvi = gn-clie.CodProv NO-LOCK NO-ERROR.
IF AVAILABLE TabProvi THEN c-DirCli = c-DirCli + ' - ' + TRIM(TabProvi.NomProvi).
FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept 
    AND TabDistr.CodProvi = gn-clie.CodProv
    AND TabDistr.CodDistr = gn-clie.CodDist NO-LOCK NO-ERROR.
IF AVAILABLE TabDistr THEN  c-DirCli = c-DirCli + ' - ' + TRIM(TabDistr.NomDistr).

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
DEFINE FRAME F-HdrFac
    HEADER
    SKIP(4)
    gn-divi.dirdiv AT 11 FORMAT 'x(80)' WHEN gn-divi.coddiv = '00501' SKIP
    gn-divi.faxdiv FORMAT 'x(50)' WHEN AVAILABLE gn-divi SKIP(1)
    ccbcdocu.nomcli AT 11 FORMAT "x(50)" 
    CcbCDocu.CodCli AT 62
    c-dircli AT 11 FORMAT "x(150)" 
    ccbcdocu.RucCli AT 11 FORMAT "x(11)"
    C-NomCon        AT 62 FORMAT "X(15)" SKIP(1)
    ccbcdocu.fchdoc AT 01
    CcbCDocu.NroPed AT 18 FORMAT "X(10)"
    Ccbcdocu.DivOri FORMAT 'x(5)'
    x-UsrRef
    x-NroRef AT 50 FORMAT "X(20)" SKIP
    /* RHC 06.01.10 AGENTE RETENEDOR */
    "Incorp. al reg. de agentes de retencion de IGV (RS:265-2009) a partir del 01/01/10" SKIP(2)
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
    almmmatg.desmat AT 22  FORMAT "x(40)"
    almmmatg.desmar AT 64  FORMAT "x(10)"
    ccbddocu.undvta AT 76  FORMAT "X(10)"
    ccbddocu.candes AT 90  FORMAT ">>>,>>9.99"
    ccbddocu.preuni AT 102 FORMAT ">>>9.99999"
    ccbddocu.pordto AT 112 FORMAT "->>9.99"
    ccbddocu.implin AT 124 FORMAT "->>>,>>9.99" 
    x-percepcion           FORMAT "X"
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE BUFFER B-CcbCDocu FOR CcbCDocu.
DEFINE BUFFER B-CcbDDocu FOR CcbDDocu.

/*RDP Saldo de Factura Adelantada*/
FIND Ccbdmov WHERE Ccbdmov.codcia = CcbCDocu.CodCia
        AND ccbdmov.coddoc = 'FAC'      /* FACTURA ADELANTADA */
        AND Ccbdmov.codref = Ccbcdocu.coddoc
        AND Ccbdmov.nroref = Ccbcdocu.nrodoc
        NO-LOCK NO-ERROR.
IF AVAILABLE Ccbdmov THEN DO:
    FIND FIRST B-CcbCDocu WHERE B-CcbCDocu.CodCia = CcbCDocu.CodCia
            AND B-CcbCDocu.coddoc = Ccbdmov.coddoc
            AND B-CcbCDocu.nrodoc = Ccbdmov.nrodoc
            AND B-CcbCDocu.tpofac = 'A'
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CcbCDocu THEN UNDO, RETURN "ADM-ERROR".
    IF B-CcbCDocu.CodMon = Ccbdmov.CodMon
        THEN DO:   
        ASSIGN imptotres = B-ccbcdocu.imptot2.
        chcondi = 1.
    END.
END.

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
         HEIGHT             = 5.38
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
FIND FacCorre WHERE
    FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.CodDoc = CcbCDocu.CodDoc AND
    FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3)) NO-LOCK.

DEF VAR dmontores AS DECIMAL NO-UNDO.

DEF VAR answer AS LOGICAL NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.

DEF VAR ImprimePercepcion AS LOG NO-UNDO.

ASSIGN
    imptotfac = ccbcdocu.imptot - ccbcdocu.acubon[5]
    ImprimePercepcion = ( Ccbcdocu.AcuBon[5] > 0 AND 
                          (ccbcdocu.FmaPgo = '000' OR ccbcdocu.FmaPgo = '001' OR ccbcdocu.FmaPgo = '002')).

DEFINE FRAME F-Ftrfac
    HEADER
    SKIP
    "SON : " X-EnLetras AT 07 SKIP
    {&Prn4}  x-Percepcion  {&Prn3} SKIP
    "Sirvanse Abonar a la Cta. Recaudadora del Banco de Credito" 
    (IF x-ImpPercep-21 <> 0 THEN " Monto Cobrado   Importe de la Percepción" ELSE "")  FORMAT 'x(50)' AT 80 SKIP
    "Moneda Nacional  191-1532467-0-63 Moneda Extranjera 191-1524222-1-91" 
    (IF x-ImpPercep-21 <> 0 THEN STRING(x-ImpPercep-21, '>>>,>>9.99') ELSE '') FORMAT 'x(10)' AT 80 
    (IF x-ImpPercep-22 <> 0 THEN STRING(x-ImpPercep-22, '>>>,>>9.99') ELSE '') FORMAT 'x(10)' AT 95 SKIP
    "   En caso de no ser pagado al vto. se cobrara gastos e int. compensatorios y moratorios" SKIP(1) 
    'O.Compra: ' AT 3 CcbCDocu.NroOrd 
    CcbCDocu.ImpBrt AT 65 FORMAT "->>>>>,>>9.99"   
    CcbCDocu.ImpDto AT 85 FORMAT "->>>,>>9.99"
    ccbcdocu.impvta AT 120 FORMAT ">>>>>,>>9.99" 
    SKIP
    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" AT 3
    ccbcdocu.PorIgv AT 73  FORMAT ">>9.99" "%" 
    "PERCEPCION" AT 105 ccbcdocu.acubon[4] FORMAT ">9.99" "%" WHEN ImprimePercepcion
    SKIP
    Ccbcdocu.AcuBon[5] AT 102 FORMAT ">>>>>,>>9.99" WHEN ImprimePercepcion
    SKIP
    ccbcdocu.impigv AT 65 FORMAT ">>>>,>>9.99"
    imptotfac AT 85 FORMAT ">>>>>,>>9.99"
    "ADELANTO" AT 105 WHEN Ccbcdocu.ImpTot2 > 0
    ( IF ccbcdocu.codmon = 1 THEN "S/"  ELSE "US$" ) AT 116 FORMAT "XXX"
    ( ccbcdocu.imptot -  ccbcdocu.imptot2 ) AT 120 FORMAT ">>>>,>>9.99" 
    SKIP
    "Sdo Rest.:" AT 1 imptotres
    Ccbcdocu.ImpTot2 AT 102 FORMAT ">>>>>,>>9.99" WHEN Ccbcdocu.ImpTot2 > 0
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200.

OUTPUT TO PRINTER PAGE-SIZE 44.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.    
FOR EACH ccbddocu OF ccbcdocu NO-LOCK ,
        FIRST almmmatg OF ccbddocu 
        NO-LOCK
        BREAK BY ccbddocu.nrodoc 
              BY ccbddocu.NroItm:

    VIEW FRAME F-HdrFac.
    VIEW FRAME F-FtrFac.
    
    N-Item = N-Item + 1.
    x-impbrt = ccbddocu.preuni * ccbddocu.candes.
    x-dscto1 = ( 1 -  ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ) ) * 100.
    DISPLAY n-item 
            ccbddocu.codmat 
            almmmatg.desmat 
            almmmatg.desmar 
            ccbddocu.candes 
            ccbddocu.undvta 
            ccbddocu.preuni 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


