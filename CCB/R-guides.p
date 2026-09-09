&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-guides.p
    Purpose     : Impresion de Guias de Despacho en su respectivo Almacen

    Syntax      :

    Description :

    Author(s)   : Carlos Quiroz
    Created     : 24/01/2000
    Notes       : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.
DEFINE INPUT PARAMETER X-NRODOC LIKE ccbddocu.nrodoc.
DEFINE INPUT PARAMETER Y-NRODOC LIKE Almcmov.NroDoc.
DEFINE INPUT PARAMETER X-CodCia LIKE ccbddocu.codcia.
DEFINE INPUT PARAMETER X-CODDIV LIKE Almacen.CodDiv.
DEFINE INPUT PARAMETER X-NROSER LIKE Almcmov.NroSer.


DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codmov  LIKE Almtmovm.Codmov.

DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR x-impbrt   AS DECIMAL NO-UNDO.
DEF VAR C-NomCon   AS CHAR FORMAT "X(40)".
DEF VAR N-ITEM     AS INTEGER INIT 0 NO-UNDO.
DEF VAR X-Cheque   AS CHAR NO-UNDO.

DEF VAR imptotfac like ccbcdocu.imptot.

DEFINE VARIABLE x-dscto AS DECIMAL.

DEF VAR DES-DIV AS CHARACTER FORMAT "X(25)".

FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CodCia 
              AND  GN-DIVI.CodDiv = X-CodDiv 
             NO-LOCK NO-ERROR.
IF AVAILABLE GN-DIVI THEN DES-DIV = GN-DIVI.DesDiv.
ELSE DES-DIV = "".

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.
FIND gn-clie WHERE gn-clie.codcia = 0 
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK NO-ERROR.

C-NomCon = "".


/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/



DEFINE FRAME F-DetaFac
    N-Item          FORMAT "Z9"
    ccbddocu.codmat FORMAT "X(6)"
    almmmatg.desmat FORMAT "x(25)"
    almmmatg.desmar FORMAT "x(15)"
    ccbddocu.undvta FORMAT "X(04)"
    ccbddocu.candes FORMAT "->>,>>9.99"
    Almmmate.CodUbi FORMAT "X(4)"
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

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
         HEIGHT             = 2
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

DEFINE FRAME F-HdrFac
    HEADER 
    {&PRN4} + "Vta.Mostrador" FORMAT "X(18)" SKIP
    DES-DIV FORMAT "X(25)" SKIP
/*    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP*/
    "Numero " {&PRN7A} + {&PRN6A} + ccbcdocu.coddoc + ": " + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(8)"
    {&PRN7A} + {&PRN6A} + ccbcdocu.nrodoc + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "XXXXXX-XXXXXXXXXXXX" SKIP
    "Guia Despacho : " Y-NRODOC
    TODAY AT 40 FORMAT "99/99/9999" STRING(TIME,"HH:MM:SS") SKIP
    "Cliente   : " CcbCDocu.NomCli FORMAT "x(40)"
    "Vendedor  : " CcbCDocu.CodVen SKIP
    "Direccion : " CcbCDocu.DirCli FORMAT "x(40)" SKIP
    "========================================================================" SKIP
    "   CODIGO   D E S C R I P C I O N    M A R C A      U.M.   CANTIDAD ZONA" SKIP
    "========================================================================" SKIP
  /* Z9 XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXX ->>,>>9.99 XXXX */
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.

/*    
FIND ccbdterm WHERE CcbDTerm.CodCia = s-codcia
               AND  CcbDTerm.CodDoc = ccbcdocu.coddoc
               AND  CcbDTerm.CodDiv = s-coddiv
               AND  CcbDTerm.CodTer = s-codter
               AND  CcbDTerm.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3))
              NO-LOCK.
*/
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = X-CODDIV 
               AND  FacCorre.CodDoc = "G/D"
               AND  FacCorre.NroSer = X-NROSER
              NO-LOCK.

IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").

OUTPUT TO VALUE(s-port-name) PAGE-SIZE 33.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(35) + {&PRN3}.     

FOR EACH  ccbddocu OF ccbcdocu NO-LOCK ,
    FIRST almmmatg OF ccbddocu NO-LOCK,
    FIRST almmmate WHERE Almmmate.CodCia = ccbddocu.codcia
                    AND  Almmmate.CodAlm = ccbddocu.almdes
                    AND  Almmmate.codmat = ccbddocu.codmat
                   NO-LOCK
                      BREAK BY ccbddocu.nrodoc 
                            BY ccbddocu.NroItm:
    VIEW FRAME F-HdrFac.

    n-item = n-item + 1.
    
    DISPLAY n-item 
            ccbddocu.codmat 
            almmmatg.desmat 
            almmmatg.desmar
            ccbddocu.candes
            ccbddocu.undvta
            Almmmate.CodUbi
            WITH FRAME F-DetaFac.

    IF LAST-OF(ccbddocu.nrodoc)
    THEN DO:
        PAGE.
    END.
END.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


