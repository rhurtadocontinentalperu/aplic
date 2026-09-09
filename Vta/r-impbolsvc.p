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
DEF VAR D-EXO AS CHAR FORMAT "X(1)".
DEF VAR N-ITEM AS INTEGER INIT 0.
DEFINE VAR SUB-TOT AS DECIMAL INIT 0.
DEF VAR x-impbrt AS DECIMAL NO-UNDO.

/*RD01 Campo DNI*/ DEF VAR X-EMI01    AS CHAR NO-UNDO FORMAT "X(30)".

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK NO-ERROR.

C-NomCon = CcbCDocu.FmaPgo.

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = C-NomCon + " - " + gn-ConVt.Nombr.

/*RD01 - Campo DNI*/
IF Ccbcdocu.codant <> '' THEN x-Emi01 = 'DNI: ' + Ccbcdocu.codant.

/* Definimos impresoras */
/*DEFINE VAR s-printer-list AS CHAR.
DEFINE VAR s-port-list AS CHAR.
DEFINE VAR s-port-name AS CHAR format "x(20)".
DEFINE VAR s-printer-count AS INTEGER.*/


/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
DEFINE FRAME F-HdrBol
    HEADER
    SKIP(2)
    gn-divi.faxdiv FORMAT 'x(50)' WHEN AVAILABLE gn-divi SKIP
    X-EMI01 AT 70 FORMAT "X(20)"
      '                       ' AT 92  FORMAT "X(20)" SKIP
    
    ccbcdocu.nomcli AT 10 FORMAT "x(50)" 
    ccbcdocu.fchdoc AT 65 
    IF ccbcdocu.codmon = 1 THEN "SOLES" ELSE "DOLARES"  AT 80 SKIP
    ccbcdocu.dircli AT 10 FORMAT "x(50)" SKIP
    ccbcdocu.nrodoc AT 10  FORMAT "XXX-XXXXXX" 
    ccbcdocu.codant AT 80 
    CcbCDocu.NroRef AT 100 FORMAT "X(45)" SKIP(2)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 150.

DEFINE FRAME F-DetaBol
    N-Item              AT  1 FORMAT "Z9"
    ccbddocu.codmat     AT  6
    almmserv.desmat     AT 14 FORMAT "x(30)"
    ccbddocu.undvta     AT 60 
    ccbddocu.candes     FORMAT ">>>>,>>9.99"
    ccbddocu.preuni     AT  88 FORMAT ">>>>>9.99"
    ccbddocu.implin     AT 100 FORMAT ">>>>>9.99" SKIP
    CcbDDocu.Flg_Factor AT 16 VIEW-AS EDITOR INNER-CHARS 60 INNER-LINES 10
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 150.

DEFINE FRAME F-FtrBol
    HEADER
    "SON : "  AT 07
    X-EnLetras AT 13  SKIP

    /* RHC 06.01.10 AGENTE RETENEDOR */
    'Incorp. al reg. de agentes de retencion de IGV (RS:265-2009) a partir del 01/01/10' SKIP(2)

    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" AT 1
    ccbcdocu.impvta AT 100 FORMAT ">>>,>>9.99" SKIP(2) 
    ccbcdocu.impigv AT 65  FORMAT ">>>,>>9.99"
    IF ccbcdocu.codmon = 1 THEN "S/"  ELSE "US$." AT 95 FORMAT "XXXX"
    ccbcdocu.imptot AT 100 FORMAT ">>>,>>9.99" SKIP(2)
    /*S-USER-ID  AT 39 STRING(TIME,"HH:MM:SS") AT 54 SKIP(1)*/
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
         HEIGHT             = 4.81
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

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA
               AND  FacCorre.CodDiv = S-CODDIV
               AND  FacCorre.CodDoc = CcbCDocu.CodDoc
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))
              NO-LOCK.

DEF VAR answer AS LOGICAL NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.

DEFINE FRAME F-DetaFac-1
    x-linea AT 22  FORMAT "x(50)" SKIP
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

OUTPUT TO PRINTER PAGE-SIZE 33.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(35) + {&PRN3}.     

      
FOR EACH ccbddocu OF ccbcdocu NO-LOCK , 
      FIRST almmserv OF ccbddocu NO-LOCK
      BREAK BY ccbddocu.nrodoc 
            BY ccbddocu.NroItm:
    VIEW FRAME F-HdrBol.
    VIEW FRAME F-FtrBol.
    SUB-TOT = ccbcdocu.imptot.
    n-item = n-item + 1.
    x-impbrt = ccbddocu.candes * ccbddocu.preuni.
    DISPLAY n-item
            ccbddocu.codmat
            almmserv.desmat
            ccbddocu.candes
            ccbddocu.undvta
            ccbddocu.preuni
            ccbddocu.implin
            CcbDDocu.Flg_Factor
            WITH FRAME F-DetaBol.
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
    IF LAST-OF(ccbddocu.nrodoc) THEN DO:
       PAGE.
    END.
END.
      
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


