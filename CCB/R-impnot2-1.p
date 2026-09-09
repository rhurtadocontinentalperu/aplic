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
DEF SHARED VAR cl-codcia AS INT.

DEF VAR X-Nomcli AS CHAR NO-UNDO.
DEF VAR X-Dircli AS CHAR NO-UNDO.
DEF VAR X-Ruccli AS CHAR NO-UNDO.
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR I-NroItm AS INTEGER .
DEF VAR X-TOTAL  AS DECIMAL NO-UNDO.
DEF VAR X-DESCRI AS CHAR .
DEF VAR I-NroSer AS INTEGER .
DEF VAR X-DESMOV AS CHAR FORMAT "x(30)".
DEF /*SHARED*/ VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
DEF BUFFER T-CCBCDOCU FOR CCBCDOCU.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.
ASSIGN
    x-NomCli = Ccbcdocu.nomcli
    x-DirCli = Ccbcdocu.dircli
    x-RucCli = Ccbcdocu.ruccli.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
     gn-clie.codcli = ccbcdocu.codcli NO-LOCK.
IF AVAILABLE gn-clie THEN DO:
    IF x-nomcli = '' THEN X-Nomcli = gn-clie.nomcli.
    IF x-dircli = '' THEN X-Dircli = gn-clie.dircli.
    IF x-ruccli = '' THEN X-Ruccli = gn-clie.ruc.
END.

FIND T-CCBCDOCU WHERE T-CCBCDOCU.CODCIA = S-CODCIA AND 
                      T-CCBCDOCU.CODDOC = CCBCDOCU.CODREF AND
                      T-CCBCDOCU.NRODOC = CCBCDOCU.NROREF NO-ERROR.
IF NOT AVAILABLE T-ccbcdocu THEN RETURN.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF ccbcdocu.codcli = FacCfgGn.CliVar 
THEN ASSIGN       
      X-Nomcli = Ccbcdocu.nomcli
      X-Dircli = Ccbcdocu.dircli
      X-Ruccli = Ccbcdocu.ruccli.

FIND Almtmovm WHERE 
     Almtmovm.CodCia = ccbcdocu.codCia AND
     Almtmovm.Codmov = ccbcdocu.codmov NO-LOCK NO-ERROR.
IF AVAILABLE Almtmovm THEN X-DESMOV = Almtmovm.Desmov.
      
/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
DEFINE FRAME F-HdrN/C
    HEADER
    SKIP(5)
    gn-divi.dirdiv AT 12 FORMAT 'x(80)' WHEN gn-divi.coddiv = '00501' SKIP
    x-NomCli AT 12 FORMAT "x(40)" SKIP(1)
    x-DirCli AT 12 FORMAT "x(50)" SKIP(1)
    x-RucCli AT 12 FORMAT "x(11)"  
    CcbCDocu.CodCli AT 60 
    CcbCDocu.nroref AT 97  FORMAT "XXX-XXXXXX"
    T-CCBCDOCU.FchDoc AT 120 FORMAT "99/99/9999" 
    T-CCBCDOCU.ImpTot AT 140 FORMAT ">>>,>>9.99" skip(2)
    CcbCDocu.Glosa  AT 20  FORMAT 'x(70)'
    CcbCDocu.NRODOC AT 97  FORMAT "XXX-XXXXXX"
    S-User-Id + "/" + S-CODTER  AT 120 FORMAT "X(20)"
    CcbCDocu.FchDoc             AT 140 FORMAT "99/99/9999"  SKIP(1.5)
    WITH PAGE-TOP WIDTH 255 NO-LABELS NO-BOX STREAM-IO DOWN .
/*
DEFINE FRAME F-HdrN/C
    HEADER
    SKIP(5)
    CcbCDocu.NomCli AT 12 FORMAT "x(40)" SKIP(1.5)
    CcbCDocu.DirCli AT 12 FORMAT "x(50)" SKIP(1.0)
    CcbCDocu.RucCli AT 12 FORMAT "x(11)"  
    CcbCDocu.CodCli AT 60 SKIP
    CcbCDocu.nroref AT 97  FORMAT "XXX-XXXXXX"
    T-CCBCDOCU.FchDoc AT 120 FORMAT "99/99/9999" 
    T-CCBCDOCU.ImpTot AT 140 FORMAT ">>>,>>9.99" skip(1.5)
    CcbCDocu.Glosa  AT 20  FORMAT 'x(70)'
    CcbCDocu.NRODOC AT 97  FORMAT "XXX-XXXXXX"
    S-User-Id + "/" + S-CODTER  AT 120 FORMAT "X(20)"
    CcbCDocu.FchDoc             AT 140 FORMAT "99/99/9999"  SKIP(1.5)
    WITH PAGE-TOP WIDTH 255 NO-LABELS NO-BOX STREAM-IO DOWN .
*/

/*
DEFINE FRAME F-FtrN/C
    HEADER
    "Son : " X-EnLetras SKIP(1)
    ccbcdocu.impvta FORMAT ">>>,>>9.99" AT 140 SKIP
    IF ccbcdocu.codmon = 1 THEN "S/." ELSE "US$"  FORMAT "X(4)" AT 130
    ccbcdocu.imptot FORMAT ">>>,>>9.99" AT 140 SKIP(4) 
    WITH PAGE-BOTTOM WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
*/

DEFINE FRAME F-FtrN/C
    HEADER
    "Son : " X-EnLetras SKIP(1)
    ccbcdocu.impvta FORMAT ">>>,>>9.99" AT 115
    ccbcdocu.PorIgv AT 130 FORMAT ">>9.99" "%" 
    ccbcdocu.impigv FORMAT ">>>,>>9.99" AT 140 SKIP(1)
    IF ccbcdocu.codmon = 1 THEN "S/" ELSE "US$"  FORMAT "X(4)" AT 130
    ccbcdocu.imptot FORMAT ">>>,>>9.99" AT 140 SKIP(2) 
    WITH PAGE-BOTTOM WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

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
         HEIGHT             = 3.46
         WIDTH              = 41.86.
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
/* FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND               */
/*      FacCorre.CodDiv = S-CODDIV AND                              */
/*      FacCorre.CodDoc = ccbcdocu.coddoc AND                       */
/*      FacCorre.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3)) */
/*      NO-LOCK NO-ERROR.                                           */
/* IF AVAILABLE FacCorre THEN                                       */
/*    ASSIGN I-NroSer = FacCorre.NroSer.                            */
/* ELSE RETURN.                                                     */
/* RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).       */
/*                                                                  */
/* IF s-port-name = '' THEN RETURN.                                 */

DEF VAR rpta AS LOG NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

DEFINE FRAME F-DetaN/C
    I-NroItm FORMAT ">>>9" AT 5
    ccbddocu.codmat AT  18
    Almmmatg.Desmat AT  35 FORMAT "x(45)"
    ccbddocu.candes AT  100 FORMAT ">>,>>>,>>9.99" 
    ccbddocu.undvta AT  115 
    ccbddocu.preuni AT 125 FORMAT ">>>,>>9.99" 
    /*CcbDDocu.Por_Dsctos[1] FORMAT ">>9.99" 
    " %"*/
    ccbddocu.implin AT 140 FORMAT ">>>,>>9.99"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.


    /*{lib/_printer-stream-to.i 42 REPORT}*/
    OUTPUT STREAM REPORT TO PRINTER PAGE-SIZE 42.

PUT STREAM REPORT CONTROL {&PRN0} + {&PRN5A} + CHR(44) + {&PRN4} .

I-NroItm = 0.
    FOR EACH ccbddocu OF ccbcdocu ,
            FIRST Ccbtabla where
                Ccbtabla.codcia = ccbddocu.codcia AND
                Ccbtabla.Tabla  = ccbddocu.codDoc AND
                Ccbtabla.codigo = ccbddocu.codmat
               BREAK BY ccbddocu.nrodoc
                     BY ccbddocu.codmat: 
          VIEW STREAM REPORT FRAME F-HdrN/C.            
          VIEW STREAM REPORT FRAME F-FtrN/C.
          I-NroItm = I-NroItm + 1.
          X-TOTAL = X-TOTAL + ccbddocu.implin.
          DISPLAY STREAM REPORT 
                  I-NroItm 
                  ccbddocu.codmat 
                  CcbTabla.nombre @ almmmatg.desmat 
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


