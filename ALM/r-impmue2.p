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
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id LIKE ccbcterm.codter.

DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR C-NomVen AS CHAR FORMAT "X(21)".
DEF VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF VAR C-Codcli AS CHAR FORMAT "X(11)".
DEF VAR C-RucTra AS CHAR FORMAT "X(30)".
DEF VAR C-NomTra AS CHAR FORMAT "X(30)".
DEF VAR C-DirTra AS CHAR FORMAT "X(30)".
DEF VAR C-DirCon AS CHAR FORMAT "X(30)".
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-DEPART LIKE TabDepto.NomDepto.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-FchRef LIKE Almcmov.fchdoc.
DEF VAR X-Lugent AS CHAR NO-UNDO.

DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER B-ALMACEN FOR Almacen.

FIND Almcmov WHERE ROWID(Almcmov) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcmov THEN RETURN.


FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
    AND  gn-clie.codcli = Almcmov.codcli
    NO-LOCK no-error.
IF AVAILABLE GN-CLIE THEN c-DirCon = GN-CLIE.DirCli.
IF Substring(Almcmov.codcli,1,1) = 'A' THEN DO:
    IF AVAILABLE gn-clie 
    THEN ASSIGN
        C-NomCon = gn-clie.Nomcli
        C-DirCon = gn-clie.Dircli
        C-Codcli = gn-clie.Ruc.
END.
ELSE ASSIGN C-NomCon = Almcmov.Nomref
            C-Codcli = Almcmov.Codcli.
            
X-senal  = "X".
C-NomVen = Almcmov.CodVen.
C-RucTra = Almcmov.CodTra.

FIND gn-ven WHERE gn-ven.CodCia = Almcmov.CodCia 
             AND  gn-ven.CodVen = Almcmov.CodVen 
            NO-LOCK NO-ERROR.
IF AVAILABLE gn-ven THEN C-NomVen = gn-ven.NomVen.

FIND admrutas WHERE admruta.CodPro = Almcmov.CodTra NO-LOCK NO-ERROR.
IF AVAILABLE admrutas THEN C-NomTra = admrutas.NomTra.

FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND
      gn-prov.codpro = C-RucTra NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN C-DirTra = gn-prov.DirPro.

FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
              AND  Almacen.CodAlm = Almcmov.CodAlm 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugPar = Almacen.DirAlm.

FIND b-Almacen WHERE b-Almacen.CodCia = Almcmov.CodCia 
                AND  b-Almacen.CodAlm = Almcmov.AlmDes
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugPar = Almacen.DirAlm.

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(0 /*Almcmov.imptot*/, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF Almcmov.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/


DEFINE FRAME F-HdrGui
    HEADER
    SKIP(7)
    x-LugPar AT 12 FORMAT 'x(70)' SKIP
    c-DirCon AT 12 FORMAT 'x(70)' SKIP
    C-Nomcon AT 12 FORMAT "X(70)" SKIP
    C-Dircon AT 12 FORMAT "X(50)" SKIP
    C-Codcli AT 12 FORMAT "X(11)" SKIP
    /*'NUEVO R.U.C 20100038146' AT 92  FORMAT "X(20)" SKIP*/
     Almcmov.Codcli AT 12 FORMAT "X(11)" SKIP
    C-NomTra   AT 92 FORMAT "X(25)" SKIP
    C-DirTra   AT 92 FORMAT "X(40)" SKIP
    C-RucTra   AT 92 FORMAT "X(11)" SKIP
    "8 Muestras " AT 7 FORMAT "X(15)" SKIP
    "G/R " AT 96 FORMAT "X(4)" (STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999")) FORMAT "X(10)"
    Almcmov.fchdoc AT 115 FORMAT "99/99/9999" SKIP(3) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaGui
    Almdmov.Codalm  AT 01 FORMAT "99"
    I-NroItm        AT 04 FORMAT "Z9"
    Almdmov.codmat  AT 10 FORMAT "999999"
    almmmatg.desmat AT 27 FORMAT "X(40)"
    almmmatg.desmar AT 69 FORMAT "X(10)"
    Almdmov.candes  AT 81 FORMAT ">>>>,>>9.99"
    Almdmov.CodUnd  AT 93 FORMAT "X(3)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui
    HEADER
    SKIP(2)
    'TRASLADO  ' /*Almcmov.NroOrd*/ SKIP
    'SALIDA  : ' (TRIM(Almcmov.CodAlm) + "-" + Almacen.Descripcion) FORMAT 'X(38)' SKIP
    'DESTINO : ' (TRIM(Almcmov.AlmDes) + "-" + b-Almacen.Descripcion) FORMAT 'X(50)' SKIP
    'Glosa   : ' Almcmov.Observ FORMAT 'X(30)' SKIP
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
/* FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA             */
/*                AND  FacCorre.CodDiv = S-CODDIV             */
/*                AND  FacCorre.CodDoc = "G/R"                */
/*                AND  FacCorre.NroSer = Almcmov.NroSer       */
/*               NO-LOCK.                                     */
/* RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name). */
/* IF s-port-name = '' THEN RETURN.                           */
/* {lib/_printer-to.i 42}                                     */

DEF VAR l-Ok AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE l-Ok.
IF l-Ok = NO THEN RETURN.
OUTPUT TO PRINTER PAGED PAGE-SIZE 42.

PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

x-lugent = ''.
/*IF Almcmov.Lugent2  <> '' THEN DO:
 *    x-lugent = 'PTO.LLEGADA - 2:' + Almcmov.lugent2.
 * END.*/

I-NroItm = 0.
FOR EACH Almdmov OF Almcmov NO-LOCK , 
    FIRST almmmatg OF Almdmov NO-LOCK
                   BREAK BY Almdmov.nrodoc
                         BY Almdmov.NroItm
                         BY Almdmov.codmat 
/*
 *                          BY almmmatg.desmat*/:
        VIEW FRAME F-HdrGui.
        VIEW FRAME F-FtrGui.
        I-NroItm = I-NroItm + 1.
        DISPLAY Almdmov.Codalm
                I-NroItm 
                Almdmov.codmat 
                almmmatg.desmat 
                almmmatg.desmar
                Almdmov.candes 
                Almdmov.CodUnd 
/*                Almmmatg.PreOfi */
                WITH FRAME F-DetaGui.

        IF LAST-OF(Almdmov.nrodoc)
        THEN DO:
            PAGE.
        END.
END.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


