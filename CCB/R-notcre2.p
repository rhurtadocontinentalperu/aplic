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
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.

DEF VAR X-Nomcli AS CHAR NO-UNDO.
DEF VAR X-Dircli AS CHAR NO-UNDO.
DEF VAR X-Ruccli AS CHAR NO-UNDO.
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR I-NroItm AS INTEGER .
DEF VAR X-TOTAL  AS DECIMAL NO-UNDO.
DEF VAR X-DESCRI AS CHAR .
DEF VAR I-NroSer AS INTEGER .
DEF VAR X-DESMOV AS CHAR FORMAT "x(30)".
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
DEF BUFFER T-CCBCDOCU FOR CCBCDOCU.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.
FIND gn-clie WHERE gn-clie.codcia = 0 AND
     gn-clie.codcli = ccbcdocu.codcli NO-LOCK.
IF AVAILABLE gn-clie THEN
   ASSIGN
      X-Nomcli = gn-clie.nomcli
      X-Dircli = gn-clie.dircli
      X-Ruccli = gn-clie.ruc.

FIND T-CCBCDOCU WHERE T-CCBCDOCU.CODCIA = S-CODCIA AND 
                      T-CCBCDOCU.CODDOC = CCBCDOCU.CODREF AND
                      T-CCBCDOCU.NRODOC = CCBCDOCU.NROREF NO-ERROR.
IF NOT AVAILABLE T-ccbcdocu THEN RETURN.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

IF ccbcdocu.codcli = FacCfgGn.CliVar THEN
   ASSIGN       
      X-Nomcli = Ccbcdocu.nomcli
      X-Dircli = Ccbcdocu.dircli
      X-Ruccli = Ccbcdocu.ruccli.

FIND Almtmovm WHERE 
     Almtmovm.CodCia = ccbcdocu.codCia AND
     Almtmovm.Codmov = ccbcdocu.codmov NO-LOCK NO-ERROR.
IF AVAILABLE Almtmovm THEN X-DESMOV = Almtmovm.Desmov.
      
/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

DEFINE FRAME F-HdrN/C
    HEADER
    SKIP(5)
    CcbCDocu.NomCli /*X-nomcli*/ AT 12 FORMAT "x(40)" SKIP(1.5)
    CcbCDocu.DirCli /*X-dircli*/ AT 12 FORMAT "x(50)" SKIP(1.5)
    CcbCDocu.RucCli /*X-ruccli*/ AT 12 FORMAT "x(11)"  
    CcbCDocu.CodCli AT 60 
    CcbCDocu.nroref AT 97  FORMAT "XXX-XXXXXX"
    T-CCBCDOCU.FchDoc AT 120 FORMAT "99/99/9999" 
    T-CCBCDOCU.ImpTot AT 140 FORMAT ">>>,>>9.99" skip(1.5)
    "DEVOLUCION DE MERCADERIA" AT 24 FORMAT "X(30)" 
    "NRO. DEV" CcbCDocu.NroOrd FORMAT "XXX-XXXXXX"
    CcbCDocu.NRODOC AT 97  FORMAT "XXX-XXXXXX"
    S-User-Id + "/" + S-CODTER  AT 120 FORMAT "X(20)"
    CcbCDocu.FchDoc             AT 140 FORMAT "99/99/9999"  SKIP(2)
    WITH PAGE-TOP WIDTH 255 NO-LABELS NO-BOX STREAM-IO DOWN .



    
DEFINE FRAME F-FtrN/C
    HEADER
    "Son : " X-EnLetras   
    ccbcdocu.PorIgv AT 140 FORMAT ">>9.99" "%" FORMAT "X(1)" SKIP
    ccbcdocu.impvta FORMAT ">>>,>>9.99" AT 115
    ccbcdocu.impigv FORMAT ">>>,>>9.99" AT 140 SKIP
    IF ccbcdocu.codmon = 1 THEN "S/." ELSE "US$"  FORMAT "X(4)" AT 130
    ccbcdocu.imptot FORMAT ">>>,>>9.99" AT 140 SKIP(2) 
    WITH PAGE-BOTTOM WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

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
         HEIGHT             = 1.77
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

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND 
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.CodDoc = ccbcdocu.coddoc AND
     FacCorre.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3)) 
     NO-LOCK NO-ERROR.

IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.


IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").

DEFINE FRAME F-DetaN/C
    I-NroItm FORMAT ">>>9" AT 5
    ccbddocu.codmat AT  18
    Almmmatg.Desmat AT  35 FORMAT "x(45)"
    ccbddocu.candes AT  100 FORMAT ">>,>>>,>>9.99" 
    ccbddocu.undvta AT  115 
    ccbddocu.preuni AT 125 FORMAT ">>>,>>9.99" 
    /*CcbDDocu.Por_Dsctos[1] FORMAT ">>9.99" 
    " %"*/
    ccbddocu.implin AT 140 FORMAT ">>>,>>>9.99"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

OUTPUT STREAM REPORT TO VALUE(s-port-name) PAGE-SIZE 42.
PUT STREAM REPORT CONTROL {&PRN0} + {&PRN5A} + CHR(44) + {&PRN4} .


I-NroItm = 0.
      FOR EACH ccbddocu OF ccbcdocu ,
               FIRST almmmatg OF ccbddocu
               BREAK BY ccbddocu.nrodoc
                     BY ccbddocu.codmat: 
          VIEW STREAM REPORT FRAME F-HdrN/C.            
          VIEW STREAM REPORT FRAME F-FtrN/C.
          I-NroItm = I-NroItm + 1.
          X-TOTAL = X-TOTAL + ccbddocu.implin.
          DISPLAY STREAM REPORT 
                  I-NroItm 
                  ccbddocu.codmat 
                  almmmatg.desmat 
                  ccbddocu.candes 
                  ccbddocu.undvta 
                  ccbddocu.preuni 
                  /*CcbDDocu.Por_Dsctos[1]*/
                  ccbddocu.implin
                  WITH FRAME F-DetaN/C.
          IF LAST-OF(ccbddocu.nrodoc) THEN DO:
             PAGE STREAM REPORT.
          END.
      END.

OUTPUT STREAM REPORT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


