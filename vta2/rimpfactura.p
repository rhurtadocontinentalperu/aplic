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

DEF TEMP-TABLE Detalle LIKE Ccbddocu
    FIELD DesMat LIKE Almmmatg.DesMat
    FIELD DesMar LIKE Almmmatg.DesMar
    INDEX llave01 AS PRIMARY NroItm.

DEF VAR C-NomCon AS CHAR FORMAT "X(40)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(90)" NO-UNDO.
DEF VAR N-ITEM AS INTEGER INIT 0.
DEF VAR x-dscto1 AS DECIMAL NO-UNDO.
DEF VAR imptotfac like ccbcdocu.imptot.
DEF VAR imptotres LIKE ccbcdocu.imptot2 NO-UNDO.
DEF VAR chcondi   AS INTEGER NO-UNDO INIT 0.

DEFINE VARIABLE x-dscto AS DECIMAL.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

C-NomCon = "".
FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN ASSIGN C-NomCon = gn-ConVt.Nombr.
N-ITEM = 0.

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot - ccbcdocu.imptot2, 2, 1, OUTPUT X-EnLetras).   /* ANTICIPOS */
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/
DEFINE FRAME F-HdrFac
    HEADER
    SKIP(4)
    ccbcdocu.nomcli AT 11 FORMAT "x(50)" 
    CcbCDocu.CodCli AT 62
    ccbcdocu.dircli AT 11 FORMAT "x(50)" 
    ccbcdocu.RucCli AT 11 FORMAT "x(11)"
    C-NomCon        AT 62 FORMAT "X(15)" SKIP(1)
    '                       ' AT 92 SKIP
    ccbcdocu.fchdoc AT 01
    CcbCDocu.NroPed AT 18 FORMAT "X(10)"
    CcbCDocu.NroRef AT 45 FORMAT "X(20)" SKIP
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
    ccbddocu.preuni AT 103 FORMAT "->,>>9.99"
    ccbddocu.pordto AT 112 FORMAT "->>9.99"
    ccbddocu.implin AT 124 FORMAT "->>>,>>9.99" 
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

imptotfac = ccbcdocu.imptot.

DEFINE BUFFER B-CcbCDocu FOR CcbCDocu.
DEFINE BUFFER B-CcbDDocu FOR CcbDDocu.

/*RDP Saldo de Factura Adelantada*/
/* FIND Ccbdmov WHERE Ccbdmov.codcia = CcbCDocu.CodCia                 */
/*         AND ccbdmov.coddoc = 'FAC'      /* FACTURA ADELANTADA */    */
/*         AND Ccbdmov.codref = Ccbcdocu.coddoc                        */
/*         AND Ccbdmov.nroref = Ccbcdocu.nrodoc                        */
/*         NO-LOCK NO-ERROR.                                           */
/* IF AVAILABLE Ccbdmov THEN DO:                                       */
/*     FIND FIRST B-CcbCDocu WHERE B-CcbCDocu.CodCia = CcbCDocu.CodCia */
/*             AND B-CcbCDocu.coddoc = Ccbdmov.coddoc                  */
/*             AND B-CcbCDocu.nrodoc = Ccbdmov.nrodoc                  */
/*             AND B-CcbCDocu.tpofac = 'A'                             */
/*         EXCLUSIVE-LOCK NO-ERROR.                                    */
/*     IF NOT AVAILABLE B-CcbCDocu THEN UNDO, RETURN "ADM-ERROR".      */
/*     IF B-CcbCDocu.CodMon = Ccbdmov.CodMon                           */
/*         THEN DO:                                                    */
/*         ASSIGN imptotres = B-ccbcdocu.imptot2.                      */
/*         chcondi = 1.                                                */
/*     END.                                                            */
/* END.                                                                */

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
DEF VAR answer AS LOGICAL NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.

DEFINE FRAME F-Ftrfac
    HEADER
    "SON : " X-EnLetras AT 07 SKIP
    "Sirvanse Abonar a la Cta. Recaudadora del Banco de Credito" "Moneda Nacional  191-1532467-0-63" "Moneda Extranjera 191-1524222-1-91" SKIP
    "En caso de no ser pagado al vto. se cobrar'a gastos e int. compensatorios y moratorios" SKIP(1) 
    'O.Compra: ' AT 3 CcbCDocu.NroOrd 
    CcbCDocu.ImpBrt AT 65 FORMAT "->>>>>,>>9.99"
    CcbCDocu.ImpDto AT 85 FORMAT "->>>,>>9.99"
    ccbcdocu.impvta AT 120 FORMAT ">>>>>,>>9.99" SKIP
    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" AT 3
    ccbcdocu.PorIgv AT 73  FORMAT ">>9.99" "%"  SKIP
    "ADELANTO" AT 105 WHEN Ccbcdocu.ImpTot2 > 0 SKIP
    /*'Sdo Rest.:' AT 1 imptotres */
    ccbcdocu.impigv AT 65 FORMAT ">>>>,>>9.99"
    imptotfac AT 85 FORMAT ">>>>>,>>9.99"
    Ccbcdocu.ImpTot2 AT 102 FORMAT "->>>>,>>9.99" WHEN Ccbcdocu.ImpTot2 > 0
    (IF ccbcdocu.codmon = 1 THEN "S/."  ELSE "US$") FORMAT 'x(3)' AT 116 
    ( ccbcdocu.imptot -  ccbcdocu.imptot2 ) AT 120 FORMAT "->>>,>>9.99" SKIP(1)
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200.


RUN Carga-Temporal.

FIND FIRST Detalle NO-LOCK NO-ERROR.
IF NOT AVAILABLE Detalle THEN DO:
    MESSAGE 'NO hay registros que imprimir' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

OUTPUT TO PRINTER PAGE-SIZE 42.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.    
FOR EACH Detalle NO-LOCK BREAK BY Detalle.nrodoc BY Detalle.NroItm:
    VIEW FRAME F-HdrFac.
    VIEW FRAME F-FtrFac.
    N-Item = N-Item + 1.
    x-dscto1 = ( 1 -  ( 1 - Detalle.Por_Dsctos[1] / 100 ) *
                ( 1 - Detalle.Por_Dsctos[2] / 100 ) *
                ( 1 - Detalle.Por_Dsctos[3] / 100 ) ) * 100.
    DISPLAY 
        n-item 
        Detalle.codmat @ Ccbddocu.codmat
        Detalle.desmat @ Almmmatg.desmat
        Detalle.desmar @ almmmatg.desmar 
        Detalle.undvta @ ccbddocu.undvta 
        Detalle.candes WHEN Detalle.candes > 0 @ ccbddocu.candes 
        Detalle.preuni WHEN Detalle.preuni > 0 @ ccbddocu.preuni 
        x-dscto1 WHEN x-dscto1 <> 0 @ ccbddocu.pordto
        Detalle.implin @ ccbddocu.implin 
        WITH FRAME F-DetaFac.
    IF LAST-OF(Detalle.nrodoc) THEN PAGE.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal Procedure 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k        AS INT NO-UNDO.
DEF VAR n-Item   AS INT INIT 0 NO-UNDO.
DEF VAR x-DesMat LIKE Almmmatg.desmat NO-UNDO.

EMPTY TEMP-TABLE Detalle.

FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST almmmatg OF ccbddocu NO-LOCK:
    n-Item = n-Item + 1.
    CREATE Detalle.
    BUFFER-COPY Ccbddocu 
        TO Detalle
        ASSIGN 
        Detalle.DesMat = Almmmatg.DesMat
        Detalle.DesMar = Almmmatg.DesMar.
END.
/* Cargamos los descuentos por adelantos */
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE
    ( CcbDDocu.ImpDcto_Adelanto[1] > 0
      OR CcbDDocu.ImpDcto_Adelanto[2] > 0
      OR CcbDDocu.ImpDcto_Adelanto[3] > 0
      OR CcbDDocu.ImpDcto_Adelanto[4] > 0
      OR CcbDDocu.ImpDcto_Adelanto[5] > 0 ):
    /* buscamos los descuentos */
    DO k = 1 TO 5:
        IF CcbDDocu.ImpDcto_Adelanto[k] > 0 THEN DO:
            x-DesMat = "DESCUENTO " + STRING(CcbDDocu.PorDcto_Adelanto[k], '>>9.99') + "%".
            FIND Detalle WHERE Detalle.desmat = x-desmat NO-ERROR.
            IF NOT AVAILABLE Detalle THEN DO:
                CREATE Detalle.
                n-Item = n-Item + 1.
            END.
            ASSIGN
                Detalle.NroDoc = Ccbddocu.NroDoc
                Detalle.NroItm = n-Item
                Detalle.DesMat = x-DesMat
                Detalle.ImpLin = Detalle.ImpLin - CcbDDocu.ImpDcto_Adelanto[k].
        END.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

