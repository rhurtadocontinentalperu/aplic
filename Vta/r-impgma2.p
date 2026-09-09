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
DEF SHARED VAR PV-CODCIA AS INTEGER.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id LIKE ccbcterm.codter.


DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF VAR C-RucTra AS CHAR FORMAT "X(30)".
DEF VAR C-NomTra AS CHAR FORMAT "X(30)".
DEF VAR C-DirTra AS CHAR FORMAT "X(30)".
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-FchRef LIKE ccbcdocu.fchdoc.
DEF VAR X-Lugent AS CHAR NO-UNDO.
DEF VAR c-NomCli AS CHAR.
DEF VAR x-Glosa  AS CHAR VIEW-AS EDITOR INNER-CHARS 40 INNER-LINES 3.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

x-Senal  = "X".

FIND GN-PROV WHERE gn-prov.codcia = pv-codcia AND
                   GN-PROV.CODPRO = CcbCDocu.CodAge NO-LOCK NO-ERROR.
IF AVAILABLE GN-PROV THEN DO:
    C-NomTra = GN-PROV.NOMPRO.
    C-DirTra = gn-prov.DirPro.
    C-RucTra = gn-prov.Ruc.
END.

FIND Almacen WHERE Almacen.CodCia = CcbCDocu.CodCia 
              AND  Almacen.CodAlm = CcbCDocu.CodAlm 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugPar = Almacen.DirAlm.
FIND Almacen WHERE Almacen.CodCia = CcbCDocu.CodCia 
              AND  Almacen.CodAlm = CcbCDocu.LugEnt 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen 
THEN ASSIGN
        X-LugEnt = Almacen.DirAlm
        c-NomCli = Almacen.Descripcion.

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

DEFINE FRAME F-HdrGui
    HEADER
    skip(6)
    x-LugPar AT 12 FORMAT 'x(70)' SKIP
    x-LugEnt AT 12 FORMAT 'x(70)' SKIP
    c-NomCli AT 12 FORMAT 'x(70)' SKIP(2)
    "GUIA # "     AT 07 FORMAT "X(9)" ccbcdocu.nrodoc 
    C-NomTra   AT 103 FORMAT "X(28)" SKIP
    C-DirTra   AT 87 FORMAT "X(40)" SKIP
    C-RucTra   AT 87 FORMAT "X(11)" SKIP
    "Placa : " at 78 ccbcdocu.codref FORMAT 'x(10)' SKIP(2)
    ccbcdocu.fchdoc  AT 119
    SKIP(2) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaGui
    ccbcdocu.codalm  AT 02 FORMAT "99"
    I-NroItm         AT 04 FORMAT "Z9"
    ccbddocu.codmat  AT 11 FORMAT "999999"
    almmmatg.desmat  AT 27 FORMAT "X(40)"
    almmmatg.desmar  AT 91 FORMAT "X(10)"
    ccbddocu.candes  AT 108 FORMAT ">>>,>>9.99"
    ccbddocu.UndVta  AT 119 FORMAT "X(8)" SKIP
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(2)
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
DEF VAR iLargo AS INT NO-UNDO.
DEF VAR i      AS INT NO-UNDO.
DEF VAR x-Ok   AS LOG INIT NO NO-UNDO.

RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = CcbCDocu.CodDoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))  
              NO-LOCK.

IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").

/*SYSTEM-DIALOG PRINTER-SETUP  NUM-COPIES s-nro-copias UPDATE x-ok.
 * IF x-Ok = NO THEN RETURN.*/
  
OUTPUT TO VALUE(s-port-name) PAGE-SIZE 43.
/*OUTPUT TO PRINTER PAGE-SIZE 43.*/
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

x-lugent = ''.
IF CcbCDocu.Lugent2  <> '' THEN DO:
   x-lugent = 'PTO.LLEGADA - 2:' + CcbCDocu.lugent2.
END.

I-NroItm = 0.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK , 
    FIRST almmmatg OF ccbddocu NO-LOCK
                   BREAK BY ccbddocu.nrodoc 
                         BY almmmatg.desmat:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    I-NroItm = I-NroItm + 1.
    FIND ccbgdocu OF ccbddocu NO-LOCK NO-ERROR.
    IF AVAILABLE ccbgdoc THEN x-Glosa = ccbgdocu.glosa.
    DISPLAY ccbcdocu.codalm
            I-NroItm 
            ccbddocu.codmat 
            almmmatg.desmat 
            almmmatg.desmar
            ccbddocu.candes 
            ccbddocu.undvta 
            WITH FRAME F-DetaGui.
    IF AVAILABLE ccbgdocu AND x-glosa <> ''
    THEN DO:
        iLargo = LENGTH(TRIM(ccbgdocu.glosa)).
        iLargo = INTEGER(iLargo / 40).
        DO i = 1 TO iLargo:
            PUT SUBSTRING(ccbgdocu.glosa,(40 * (iLargo - 1) + 1),40) FORMAT 'x(40)' AT 20 SKIP.
        END.
    END.
    IF LAST-OF(ccbddocu.nrodoc)
    THEN DO:
        PAGE.
    END.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


