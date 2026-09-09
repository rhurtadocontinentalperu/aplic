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
DEF SHARED VAR pv-CODCIA AS INTEGER.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-user-id LIKE ccbcterm.codter.

DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR C-NomVen AS CHAR FORMAT "X(21)".
DEF VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF VAR C-RucTra AS CHAR FORMAT "X(30)".
DEF VAR C-NomTra AS CHAR FORMAT "X(30)".
DEF VAR C-DirTra AS CHAR FORMAT "X(30)".
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-DEPART LIKE TabDepto.NomDepto.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-FchRef LIKE ccbcdocu.fchdoc.
DEF VAR X-Lugent AS CHAR NO-UNDO.
DEF VAR X-MOTIVO AS CHAR.

DEFINE BUFFER B-CMOV FOR ccbcdocu.
DEFINE BUFFER B-ALMACEN FOR Almacen.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

X-senal  = "X".
C-NomVen = "".
C-NomCon = "".
C-RucTra = ccbcdocu.CodAge.
x-FchRef = ccbcdocu.fchdoc.

FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND
      gn-prov.codpro = C-RucTra NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov 
THEN ASSIGN
        C-NomTra = gn-prov.NomPro
        C-DirTra = gn-prov.DirPro
        c-RucTra = gn-prov.Ruc.

FIND Almacen WHERE Almacen.CodCia = ccbcdocu.CodCia 
              AND  Almacen.CodAlm = ccbcdocu.CodAlm 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugPar = Almacen.DirAlm.
/* RHC 13.06.06 */
x-LugPar = CcbCDocu.DirCli.

FIND b-Almacen WHERE b-Almacen.CodCia = ccbcdocu.CodCia 
                AND  b-Almacen.CodAlm = ccbcdocu.LugEnt
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugEnt = Almacen.DirAlm.


X-MOTIVO = "(3) Traslado entre...".

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(0, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/
DEFINE FRAME F-HdrGui
    HEADER
    SKIP(2)
    "Comprobante de pago emitido en contingencia" AT 20 FORMAT 'x(45)' SKIP
    "Emisor Electronico Obligado" AT 93 FORMAT 'x(27)'
    SKIP(2)
    /*SKIP(7)*/
    x-LugPar AT 12 FORMAT 'x(60)' SKIP
    CcbCDocu.LugEnt2 AT 12 FORMAT 'x(60)' SKIP
    CcbCDocu.NomCli  AT 12 FORMAT "X(70)" SKIP
    CcbCDocu.RucCli  AT 12 FORMAT 'x(11)' 
    x-FchRef         AT 60                SKIP(1)
    C-NomTra   AT 92 FORMAT "X(25)" SKIP
    /*C-DirTra   AT 92 FORMAT "X(40)" SKIP*/
    C-RucTra   AT 92 FORMAT "X(11)" SKIP(3)
    "G/R " AT 100 ccbcdocu.nrodoc FORMAT "X(15)"
    ccbcdocu.fchdoc FORMAT "99/99/9999" SKIP(2) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaGui
    I-NroItm        AT 04 FORMAT "Z9"
    ccbrdocu.codmat  AT 10 FORMAT "999999"
    ccbrdocu.desmat AT 30 FORMAT "X(40)"
    ccbrdocu.desmar AT 79 FORMAT "X(10)"
    ccbrdocu.candes  AT 90 FORMAT ">>,>>9.99" /*81*/
    ccbrdocu.UndVta  AT 108 FORMAT "X(3)"        /*99*/ 
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 230.

DEFINE FRAME F-FtrGui
    HEADER
    'SALIDA :' Almacen.Descripcion SKIP
    'DESTINO:' ccbcdocu.nomcli     SKIP
/*    'GLOSA  : ' CcbCDocu.Glosa FORMAT 'X(30)' SKIP(3)*/
    ' GLOSA : ' SUBSTRING(CcbCDocu.Glosa,1,40) FORMAT 'x(40)' SKIP
    SUBSTRING(CcbCDocu.Glosa,41,80)  AT 10 FORMAT 'x(40)' SKIP
    SUBSTRING(CcbCDocu.Glosa,81,120) AT 10 FORMAT 'x(40)' SKIP
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
         HEIGHT             = 5.62
         WIDTH              = 54.14.
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
DEF VAR i AS INT NO-UNDO.
DEF VAR x AS CHAR FORMAT 'x(40)' NO-UNDO.
DEF VAR x-Ok   AS LOG INIT NO NO-UNDO.

/*RUN aderb/_prlist.p(
 *     OUTPUT s-printer-list,
 *     OUTPUT s-port-list,
 *     OUTPUT s-printer-count).
 * 
 * FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
 *                AND  FacCorre.CodDiv = S-CODDIV 
 *                AND  FacCorre.CodDoc = "G/R"
 *                AND  FacCorre.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc,1,3))
 *               NO-LOCK.
 * 
 * IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
 *    MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
 *    RETURN ERROR.
 * END.
 * 
 * s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
 * s-port-name = REPLACE(S-PORT-NAME, ":", "").
 * 
 * OUTPUT TO VALUE(s-port-name) PAGE-SIZE 42.*/

SYSTEM-DIALOG PRINTER-SETUP  NUM-COPIES s-nro-copias UPDATE x-ok.
IF x-Ok = NO THEN RETURN.
  
OUTPUT TO PRINTER PAGE-SIZE 46.

PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

x-lugent = ''.
I-NroItm = 0.
FOR EACH ccbrdocu WHERE ccbrdocu.codcia = ccbcdocu.codcia
        AND ccbrdocu.coddoc = ccbcdocu.coddoc
        AND ccbrdocu.nrodoc = ccbcdocu.nrodoc NO-LOCK 
        BREAK BY ccbrdocu.nrodoc BY ccbrdocu.NroItm BY ccbrdocu.codmat:
        VIEW FRAME F-HdrGui.
        VIEW FRAME F-FtrGui.
        I-NroItm = I-NroItm + 1.
        DISPLAY 
                I-NroItm 
                ccbrdocu.codmat 
                ccbrdocu.desmat 
                ccbrdocu.desmar
                ccbrdocu.candes format '>>>,>>>,>>9.9999'
                ccbrdocu.UndVta
                WITH FRAME F-DetaGui.
        IF LAST-OF(ccbrdocu.nrodoc)
        THEN DO:
            PAGE.
        END.
END.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


