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
DEF SHARED VAR s-user-id AS CHAR.
DEF VAR C-NomCon AS CHAR FORMAT "X(40)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR x-Percepcion AS CHAR FORMAT 'x(60)' NO-UNDO.
DEF VAR x-Percepcion-2 AS CHAR FORMAT 'x(60)' NO-UNDO.
DEF VAR D-EXO AS CHAR FORMAT "X(1)".
DEF VAR N-ITEM AS INTEGER INIT 0.
DEFINE VAR SUB-TOT AS DECIMAL INIT 0.
DEF VAR x-impbrt AS DECIMAL NO-UNDO.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK NO-ERROR.

C-NomCon = CcbCDocu.FmaPgo.

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = C-NomCon + " - " + gn-ConVt.Nombr.

/* Definimos impresoras */
/*DEFINE VAR s-printer-list AS CHAR.
DEFINE VAR s-port-list AS CHAR.
DEFINE VAR s-port-name AS CHAR format "x(20)".
DEFINE VAR s-printer-count AS INTEGER.*/


/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot - ccbcdocu.acubon[5] -  ccbcdocu.imptot2, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").
x-Percepcion = "".
x-Percepcion-2 = "".
IF ccbcdocu.acubon[5] > 0 THEN x-Percepcion = "* Operación sujeta a percepción del IGV".
IF ccbcdocu.acubon[5] > 0 AND LOOKUP(ccbcdocu.fmapgo, '000,002') > 0 
    THEN x-Percepcion-2 = "Comprobante de Percepcion - Venta Interna".

/************************  DEFINICION DE FRAMES  *******************************/
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
DEFINE FRAME F-HdrBol
    HEADER
    SKIP(2)
    gn-divi.dirdiv AT 11 FORMAT 'x(80)' WHEN gn-divi.coddiv = '00501' SKIP
    gn-divi.faxdiv FORMAT 'x(50)' WHEN AVAILABLE gn-divi SKIP
    ccbcdocu.nomcli AT 10 FORMAT "x(50)" 
    ccbcdocu.fchdoc AT 65 
    ( IF ccbcdocu.codmon = 1 THEN "SOLES" ELSE "DOLARES" ) AT 80 
    ccbcdocu.codven AT 95 SKIP
    ccbcdocu.dircli AT 10 FORMAT "x(50)" SKIP
    ccbcdocu.nrodoc AT 10 FORMAT "XXX-XXXXXX" 
    ccbcdocu.codant AT 43 FORMAT 'x(11)'
    CcbCDocu.NroRef AT 100 FORMAT "X(45)" SKIP
    ccbcdocu.libre_c01 FORMAT 'x(3)' AT 10 ccbcdocu.libre_c02 FORMAT 'XXX-XXXXXX' SKIP(1)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 150.

DEFINE FRAME F-DetaBol
    N-Item              AT  1 FORMAT "Z9"
    ccbddocu.codmat     AT  6
    almmmatg.desmat     AT 14 FORMAT "x(30)"
    almmmatg.desmar     AT 46  FORMAT "x(10)"
    ccbddocu.undvta     AT 60 
    ccbddocu.candes     FORMAT ">>>>,>>9.99"
    ccbddocu.preuni     AT  89 FORMAT ">>>9.99999"
    ccbddocu.implin     AT 100 FORMAT "->>,>>>9.99" 
    x-percepcion           FORMAT "X"
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 150.

DEFINE FRAME F-FtrBol
    HEADER
    "SON : "  AT 07
    X-EnLetras AT 13  SKIP
    /* RHC 06.01.10 AGENTE RETENEDOR */
    'Incorp. al reg. de agentes de retencion de IGV (RS:265-2009) a partir del 01/01/10' SKIP
    x-Percepcion x-Percepcion-2 AT 80 SKIP(1)
    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" AT 1
    ccbcdocu.impvta AT 100 FORMAT "->>>,>>9.99" SKIP(1) 
    /*"ADELANTO" AT 85 WHEN Ccbcdocu.ImpTot2 > 0 SKIP*/
    "PERCEPCION" AT 85 ccbcdocu.acubon[4] FORMAT ">9.99" "%" WHEN Ccbcdocu.AcuBon[4] > 0 SKIP
    ccbcdocu.impigv AT 65  FORMAT "->>>,>>9.99"
    /*Ccbcdocu.ImpTot2 AT 80 FORMAT ">>>,>>9.99" WHEN Ccbcdocu.ImpTot2 > 0*/
    Ccbcdocu.AcuBon[5] AT 80 FORMAT ">>>,>>9.99" WHEN Ccbcdocu.AcuBon[5] > 0
    IF ccbcdocu.codmon = 1 THEN "S/"  ELSE "US$." AT 95 FORMAT "XXXX"
    ( ccbcdocu.imptot - ccbcdocu.imptot2 ) AT 100 FORMAT "->>>,>>9.99" SKIP(2)
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 150.

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
         HEIGHT             = 3.58
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
/*MLR* 21/11/07 ***
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).
* ***/
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA
               AND  FacCorre.CodDiv = S-CODDIV
               AND  FacCorre.CodDoc = CcbCDocu.CodDoc
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))
              NO-LOCK.
/*MLR* 21/11/07 ***
IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").
* ***/

/*Momentaneo ***
RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.
* ***/

DEF VAR answer AS LOGICAL NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.

OUTPUT TO PRINTER PAGE-SIZE 33.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(35) + {&PRN3}.     

/*PUT CONTROL CHR(27) "@" CHR(27) "C" CHR(33) CHR(18) CHR(27) "M".*/
      
      FOR EACH ccbddocu OF ccbcdocu NO-LOCK , 
              FIRST almmmatg OF ccbddocu NO-LOCK
              BREAK BY ccbddocu.nrodoc 
                    BY ccbddocu.NroItm:
          VIEW FRAME F-HdrBol.
          VIEW FRAME F-FtrBol.
          SUB-TOT = ccbcdocu.imptot.
          n-item = n-item + 1.
          x-impbrt = ccbddocu.candes * ccbddocu.preuni.
          DISPLAY n-item
                  ccbddocu.codmat
                  almmmatg.desmat
                  almmmatg.desmar
                  ccbddocu.candes
                  ccbddocu.undvta
                 /* ccbddocu.pesmat*/
                  ccbddocu.preuni
                 /* x-impbrt
                  ccbddocu.pordto
                  ccbddocu.pordto2*/
                  ccbddocu.implin
                  "*" WHEN ccbddocu.impdcto_adelanto[5] > 0 @ x-percepcion  
                  WITH FRAME F-DetaBol.
          IF LAST-OF(ccbddocu.nrodoc) THEN DO:
             PAGE.
          END.
      END.
      
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


