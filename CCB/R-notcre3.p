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
DEF VAR x-Percepcion AS CHAR FORMAT 'x(150)' NO-UNDO.
DEF VAR x-Percepcion1 AS CHAR FORMAT 'x(150)' NO-UNDO.
DEF VAR x-Percepcion2 AS CHAR FORMAT 'x(150)' NO-UNDO.
DEF VAR I-NroItm AS INTEGER .
DEF VAR X-TOTAL  AS DECIMAL NO-UNDO.
DEF VAR X-DESCRI AS CHAR .
DEF VAR I-NroSer AS INTEGER .
DEF VAR X-DESMOV AS CHAR FORMAT "x(30)".
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
DEF BUFFER T-CCBCDOCU FOR CCBCDOCU.

DEF VAR x-FchDoc AS DATE FORMAT "99/99/9999".
DEF VAR x-ImpTot AS DEC FORMAT ">>>,>>>,>>9.99".


FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
     gn-clie.codcli = ccbcdocu.codcli NO-LOCK.
IF AVAILABLE gn-clie THEN
   ASSIGN
      X-Nomcli = gn-clie.nomcli
      X-Dircli = gn-clie.dircli
      X-Ruccli = gn-clie.ruc.

FIND T-CCBCDOCU WHERE T-CCBCDOCU.CODCIA = S-CODCIA AND 
                      T-CCBCDOCU.CODDOC = CCBCDOCU.CODREF AND
                      T-CCBCDOCU.NRODOC = CCBCDOCU.NROREF NO-ERROR.
IF AVAILABLE T-ccbcdocu 
    THEN ASSIGN
            x-FchDoc = T-ccbcdocu.fchdoc
            x-ImpTot = T-ccbcdocu.imptot.

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
/* Mostrar importe SIN la percepción */
RUN bin/_numero(ccbcdocu.imptot - ccbcdocu.acubon[5], 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").
x-Percepcion = "".
x-Percepcion1 = "".
x-Percepcion2 = "".
IF ccbcdocu.acubon[5] > 0 THEN
    ASSIGN
    x-Percepcion = "* Operación sujeta a percepción *"
    x-Percepcion1 = "Los " + (IF ccbcdocu.codmon = 1 THEN "S/" ELSE "US$") +
    TRIM(STRING(ccbcdocu.acubon[5], '>>>,>>9.99')) +
    " podrán aplicarse en futuras percepciones"
    x-Percepcion2 = "Ley 29173 Título II Artículo 5 Párrafos 2 y 3".

/************************  DEFINICION DE FRAMES  *******************************/
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
DEFINE FRAME F-HdrN/C
    HEADER
    SKIP(3)
    gn-divi.dirdiv AT 12 FORMAT 'x(80)' WHEN gn-divi.coddiv = '00501' SKIP
    gn-divi.faxdiv FORMAT 'x(50)' WHEN AVAILABLE gn-divi SKIP
    CcbCDocu.NomCli AT 12 FORMAT "x(60)" SKIP(1.5)
    CcbCDocu.DirCli AT 12 FORMAT "x(50)" SKIP(1.0)
    CcbCDocu.RucCli AT 12 FORMAT "x(11)"  
    CcbCDocu.CodCli AT 60 SKIP
    CcbCDocu.nroref AT 97  FORMAT "XXX-XXXXXX"
    x-FchDoc AT 120 FORMAT "99/99/9999" 
    x-ImpTot AT 135 FORMAT ">>>,>>>,>>9.99" skip(1.5)
    Ccbcdocu.glosa AT 24 FORMAT 'x(60)'
    CcbCDocu.NRODOC AT 97  FORMAT "XXX-XXXXXX"
    S-User-Id + "/" + S-CODTER  AT 120 FORMAT "X(20)"
    CcbCDocu.FchDoc             AT 140 FORMAT "99/99/9999"  SKIP(1.5)
    WITH PAGE-TOP WIDTH 255 NO-LABELS NO-BOX STREAM-IO DOWN .
    
DEFINE FRAME F-FtrN/C
    HEADER
    "Son : " X-EnLetras SKIP
    x-Percepcion WHEN x-Percepcion <> "" SKIP
    x-Percepcion1 WHEN x-Percepcion1 <> "" SKIP
    x-Percepcion2 WHEN x-Percepcion2 <> "" SKIP
    ccbcdocu.PorIgv AT 130 FORMAT ">>9.99" "%" SKIP
    ccbcdocu.impvta FORMAT ">>>,>>9.99" AT 115
    ccbcdocu.impigv FORMAT ">>>,>>9.99" AT 137 SKIP(1)
    IF ccbcdocu.codmon = 1 THEN "S/" ELSE "US$"  FORMAT "X(4)" AT 130
    (ccbcdocu.imptot - ccbcdocu.acubon[5]) FORMAT ">>>,>>9.99" AT 140 SKIP(2)   /* SIN percepcion */
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
         HEIGHT             = 4.15
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

/* FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND               */
/*      FacCorre.CodDiv = S-CODDIV AND                              */
/*      FacCorre.CodDoc = ccbcdocu.coddoc AND                       */
/*      FacCorre.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3)) */
/*      NO-LOCK NO-ERROR.                                           */
/* IF AVAILABLE FacCorre THEN                                       */
/*    ASSIGN I-NroSer = FacCorre.NroSer.                            */
/* ELSE RETURN.                                                     */
/*                                                                  */
/* RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).       */
/* IF s-port-name = '' THEN RETURN.                                 */

/*OUTPUT STREAM REPORT TO VALUE(s-port-name) PAGE-SIZE 42.*/
/* {lib/_printer-stream-to.i 42 REPORT}                               */
/* PUT STREAM REPORT CONTROL {&PRN0} + {&PRN5A} + CHR(44) + {&PRN4} . */

DEF VAR answer AS LOGICAL NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.
OUTPUT STREAM REPORT TO PRINTER PAGE-SIZE 42.
PUT STREAM REPORT CONTROL {&PRN0} + {&PRN5A} + CHR(44) + {&PRN4} .

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
    x-percepcion           FORMAT "X"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

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
  "*" WHEN ccbddocu.impdcto_adelanto[5] > 0 @ x-percepcion  
          WITH FRAME F-DetaN/C.
  IF LAST-OF(ccbddocu.nrodoc) THEN DO:
     PAGE STREAM REPORT.
  END.
END.

OUTPUT STREAM REPORT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


