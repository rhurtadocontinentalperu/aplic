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
DEF VAR C-RucTra AS CHAR FORMAT "X(30)".
DEF VAR C-NomTra AS CHAR FORMAT "X(30)".
DEF VAR C-DirTra AS CHAR FORMAT "X(30)".
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-DEPART LIKE TabDepto.NomDepto.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-FchRef LIKE Almcmov.fchdoc.
DEF VAR X-Lugent AS CHAR NO-UNDO.
DEF VAR X-MOTIVO AS CHAR.
DEF VAR cCodUbi  AS CHAR.

DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER B-ALMACEN FOR Almacen.
DEFINE VAR lPesoMat AS DEC.

FIND Almcmov WHERE ROWID(Almcmov) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcmov THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
              AND  gn-clie.codcli = Almcmov.codcli 
             NO-LOCK no-error.
    
X-senal  = "X".
C-NomVen = Almcmov.CodVen.
C-NomCon = "".
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
IF AVAILABLE b-Almacen THEN X-LugEnt = b-Almacen.DirAlm.

/* RHC 26/01/2004 Cancelado por solicitud de Susana Leon
X-MOTIVO = IF LOOKUP(Almcmov.AlmDes,"11,83") > 0 THEN  "(3) Traslado entre..." ELSE "6 Trasformación ".
*/
X-MOTIVO = IF LOOKUP(Almcmov.AlmDes,"11,83") > 0 THEN  "(3) Traslado entre..." ELSE " ".

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(0 /*Almcmov.imptot*/, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF Almcmov.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

DEFINE FRAME F-HdrGui
    HEADER
    SKIP(6)
    x-LugPar AT 12 FORMAT 'x(60)' SKIP
    x-LugEnt AT 12 FORMAT 'x(60)' SKIP
    b-Almacen.Descripcion AT 12 FORMAT "X(70)" SKIP
    /*b-Almacen.DirAlm AT 12 FORMAT "X(50)" SKIP*/
    b-Almacen.CodCli AT 12 FORMAT "X(11)" SKIP
    /*'NUEVO R.U.C 20100038146' AT 92  FORMAT "X(20)" SKIP(1)*/
    "Nro. Req." AT 17 FORMAT "X(10)"  Almcmov.NroRf1  FORMAT "X(10)"
    C-NomTra   AT 92 FORMAT "X(25)" SKIP
    Almcmov.codref AT 45  Almcmov.nroref
    C-DirTra   AT 92 FORMAT "X(40)" SKIP
    C-RucTra   AT 92 FORMAT "X(11)" SKIP
    X-MOTIVO SKIP(2)
    "G/R " AT 96 FORMAT "X(4)" (STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999")) FORMAT "X(10)"
    Almcmov.fchdoc AT 115 FORMAT "99/99/9999" SKIP(2) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

/*RD01 - Cambio Detalle de Guia
DEFINE FRAME F-DetaGui
    Almdmov.Codalm  AT 01 FORMAT "99"
    I-NroItm        AT 04 FORMAT "Z9"
    Almdmov.codmat  AT 10 FORMAT "999999"
    almmmatg.desmat AT 27 FORMAT "X(45)"
    almmmatg.desmar /*AT 69*/ FORMAT "X(10)"
    Almdmov.candes  /*AT 81*/ FORMAT ">>>,>>>,>>9.99"
    Almdmov.CodUnd  /*AT 91*/ FORMAT "X(3)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.
**********/    
DEFINE FRAME F-DetaGui
    CCodUbi         AT 01 FORMAT "X(6)"
    I-NroItm        AT 07 FORMAT "Z9"
    Almdmov.codmat  AT 12 FORMAT "999999"
    almmmatg.desmat AT 27 FORMAT "X(45)"
    almmmatg.desmar /*AT 69*/ FORMAT "X(10)"
    Almdmov.candes  /*AT 81*/ FORMAT ">>>,>>>,>>9.99"
    Almdmov.CodUnd  /*AT 91*/ FORMAT "X(3)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.
   

DEFINE FRAME F-FtrGui
    HEADER
    /*SKIP(4)*/
    SKIP(3)
    lPesoMat AT 58 SKIP(1)
    'TRASLADO  ' SKIP
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
         HEIGHT             = 3.88
         WIDTH              = 35.43.
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
/*RUN aderb/_prlist.p(
 *     OUTPUT s-printer-list,
 *     OUTPUT s-port-list,
 *     OUTPUT s-printer-count).
 */
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
                AND  FacCorre.CodDiv = S-CODDIV 
                AND  FacCorre.CodDoc = "G/R"
                AND  FacCorre.NroSer = Almcmov.NroSer
               NO-LOCK.
/* *** 
 * IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
 *    MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
 *    RETURN ERROR.
 * END.
 * 
 * s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
 * s-port-name = REPLACE(S-PORT-NAME, ":", "").
 */

/*
/*MLR* 07/12/07 Nueva librería de impresión ***/
RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.

OUTPUT TO VALUE(s-port-name) PAGE-SIZE 44.
*/

DEF VAR Rpta-1 AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE Rpta-1.
IF Rpta-1 = NO THEN RETURN.

OUTPUT TO PRINTER PAGE-SIZE 44.

PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

/*x-lugent = ''.
 * IF Almcmov.Lugent2  <> '' THEN DO:
 *    x-lugent = 'PTO.LLEGADA - 2:' + Almcmov.lugent2.
 * END.*/

I-NroItm = 0.
lPesoMat = 0.
FOR EACH Almdmov OF Almcmov NO-LOCK , 
    FIRST almmmatg OF Almdmov NO-LOCK
                   BREAK BY Almdmov.nrodoc
                         BY Almdmov.NroItm
                         BY Almdmov.codmat:
        VIEW FRAME F-HdrGui.
        VIEW FRAME F-FtrGui.
        /*Impresion de Ubicacion*/
        FIND FIRST almmmate WHERE almmmate.codcia = almcmov.codcia
            AND almmmate.codalm = almdmov.codalm
            AND almmmate.codmat = almdmov.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE almmmate THEN cCodUbi = almmmate.codubi.
        ELSE cCodUbi = "".

        I-NroItm = I-NroItm + 1.
        lPesoMat = lPesoMat + almdmov.pesmat.
        DISPLAY /*RD01  Almdmov.Codalm */
/*RD01 Cod Ubi*/ cCodUbi
                I-NroItm 
                Almdmov.codmat 
                almmmatg.desmat 
                almmmatg.desmar
                Almdmov.candes 
                Almdmov.CodUnd 
                WITH FRAME F-DetaGui.
        IF LAST-OF(Almdmov.nrodoc)
        THEN DO:
            PAGE.
        END.
END.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


