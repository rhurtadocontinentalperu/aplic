&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-impgui.p
    Purpose     : Impresion de Guias

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
DEF SHARED VAR cl-CODCIA AS INTEGER.
DEF SHARED VAR pv-CODCIA AS INTEGER.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id LIKE ccbcterm.codter.

DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR C-NomVen AS CHAR FORMAT "X(21)".
DEF VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF VAR C-RucTra AS CHAR FORMAT "X(11)".
DEF VAR C-NomTra AS CHAR FORMAT "X(35)".
DEF VAR C-DirTra AS CHAR FORMAT "X(40)".
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-FchRef LIKE ccbcdocu.fchdoc.
DEF VAR X-Lugent AS CHAR NO-UNDO.
DEFINE BUFFER B-DOCU FOR ccbcdocu.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND B-DOCU WHERE B-DOCU.CODCIA = ccbcdocu.CodCia 
             AND  B-DOCU.CodDoc = ccbcdocu.CodRef 
             AND  B-DOCU.NroDoc = ccbcdocu.NroRef 
            NO-LOCK NO-ERROR.
IF AVAILABLE B-DOCU AND ccbcdocu.codref <> '' 
THEN X-FchRef = B-DOCU.FchDoc.
ELSE X-FchRef = ?.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK.
    
X-senal  = "X".
C-NomVen = CcbCDocu.CodVen.
C-NomCon = CcbCDocu.FmaPgo.

FIND gn-ven WHERE gn-ven.CodCia = CcbCDocu.CodCia 
             AND  gn-ven.CodVen = CcbCDocu.CodVen 
            NO-LOCK NO-ERROR.
IF AVAILABLE gn-ven THEN C-NomVen = gn-ven.NomVen.

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = C-NomCon + " - " + gn-ConVt.Nombr.


FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND gn-prov.CODPRO = CcbCDocu.CodAge NO-LOCK NO-ERROR.
IF AVAILABLE GN-PROV 
THEN ASSIGN
        C-NomTra = GN-PROV.NomPRO
        C-DirTra = gn-prov.DirPro
        C-RucTra = gN-PROV.RUC.

FIND Almacen WHERE Almacen.CodCia = CcbCDocu.CodCia 
              AND  Almacen.CodAlm = CcbCDocu.CodAlm 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugPar = Almacen.DirAlm.

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/


DEFINE FRAME F-HdrGui
    HEADER
    SKIP(4)
    x-LugPar        AT 12 FORMAT 'x(70)'
    'R E M I T E N T E' AT 92  FORMAT "X(20)" SKIP
    ccbcdocu.dircli AT 12 FORMAT "X(50)" SKIP
    ccbcdocu.nomcli AT 12 FORMAT "X(70)" SKIP
    ccbcdocu.RucCli AT 12 FORMAT "X(11)"  
    CcbCDocu.CodCli AT 17 FORMAT "X(11)" SKIP
    "O/DESPACHO # "     AT 17 FORMAT "X(8)" CcbCDocu.NroPed 
    "( " AT 42 FORMAT "X(2)" CcbCDocu.CodRef AT 45  CcbCDocu.NroRef FORMAT "XXX-XXXXXX" X-FchRef  " )"
    C-NomTra   AT 90 FORMAT "X(35)" SKIP
    C-DirTra   AT 90 FORMAT "X(40)" SKIP
    C-RucTra   AT 87 FORMAT "X(11)" SKIP
    '1  Venta' AT 8 FORMAT "X(15)" SKIP(1)
    CcbCDocu.CodVen AT 80 FORMAT "X(3)"
    "G/R " AT 91 FORMAT "X(4)"
    ccbcdocu.nrodoc AT 95 FORMAT "XXX-XXXXXX"
    ccbcdocu.fchdoc AT 110
    STRING(ccbcdocu.horcie,'x(8)') at 122
    SKIP(3) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaGui
    ccbcdocu.codalm  AT 01 FORMAT "99"
    I-NroItm         AT 04 FORMAT "Z9"
    ccbddocu.codmat  AT 10 FORMAT "999999"
    Almmserv.desmat  AT 27 FORMAT "X(40)"
    ccbddocu.candes  AT 79 FORMAT ">>>,>>9.99"
    ccbddocu.UndVta  AT 90 FORMAT "X(8)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui
    HEADER
    'Obs: UNA VEZ RECIBIDA LA MERCADERIA, NO HAY LUGAR A DEVOLUCIONES Y/O RECLAMOS' FORMAT "X(100)" SKIP
    'O.Compra: ' CcbCDocu.NroOrd  SKIP
    'Salida  : ' X-Lugpar FORMAT 'X(38)' SKIP
    'Destino : ' CcbCDocu.LugEnt FORMAT 'X(50)' SKIP
    'Atencion: ' CcbCDocu.Nomcli FORMAT 'X(30)' SKIP
    'Glosa   : ' CcbCDocu.Glosa  FORMAT 'X(30)' SKIP
    'Salida Almacen : ' String(CcbCdocu.Nrosal,"999999") FORMAT 'X(30)'
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

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
         HEIGHT             = 2.15
         WIDTH              = 34.14.
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
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = CcbCDocu.CodDoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))  
              NO-LOCK.

RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.

/*OUTPUT TO VALUE(s-port-name) PAGE-SIZE 42.*/
{lib/_printer-to.i 42}

PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

x-lugent = ''.
IF CcbCDocu.Lugent2  <> '' THEN DO:
   x-lugent = 'PTO.LLEGADA - 2:' + CcbCDocu.lugent2.
END.

I-NroItm = 0.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK , 
    FIRST Almmserv OF ccbddocu NO-LOCK 
        BREAK BY ccbddocu.nrodoc 
        BY ccbddocu.nroitm:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    I-NroItm = I-NroItm + 1.
    DISPLAY ccbcdocu.codalm
            I-NroItm 
            ccbddocu.codmat 
            Almmserv.desmat 
            ccbddocu.candes 
            ccbddocu.undvta 
            WITH FRAME F-DetaGui.

    IF LAST-OF(ccbddocu.nrodoc)
    THEN DO:
        PAGE.
    END.
END.


OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


