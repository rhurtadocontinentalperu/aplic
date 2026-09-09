&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-bole01.p
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

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR C-NomCon   AS CHAR FORMAT "X(40)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR X-Cheque   AS CHAR    NO-UNDO.
DEF VAR C-MONEDA   AS CHAR FORMAT "x(8)"  NO-UNDO.
DEF VAR N-Item     AS INTEGER NO-UNDO.
DEF VAR X-impbrt   AS DECIMAL NO-UNDO.
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

C-MONEDA = IF ccbcdocu.codmon = 1 THEN "SOLES" ELSE "DOLARES".

C-NomCon = "".

FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
IF AVAIL CcbDdocu THEN DO:
    FIND Almacen WHERE Almacen.CodCia = ccbcdocu.codcia 
                  AND  Almacen.CodAlm = CcbDDocu.AlmDes 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN 
        ASSIGN C-DESALM = Almacen.CodAlm + " - " + Almacen.Descripcion.
END.
ELSE DO:
    FIND Almacen WHERE Almacen.CodCia = ccbcdocu.codcia 
                  AND  Almacen.CodAlm = ccbcdocu.codalm 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN 
        ASSIGN C-DESALM = Almacen.CodAlm + " - " + Almacen.Descripcion.
END.

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN 
   ASSIGN C-NomCon = gn-ConVt.Nombr.

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/
/*    "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" format "x(150)" skip
 *     "         1         2         3         4         5         6         7         8         9        10        11        12        13        14" format "x(150)" skip*/
 
/* Verifica que la cancelación se realizó con CHEQUE */
x-cheque = "".
IF CcbCDocu.Flgest = 'C' THEN DO:
   FIND FIRST CcbDCaja WHERE CcbDCaja.CodCia = s-codcia 
                        AND  CcbDCaja.CodRef = CcbCDocu.Coddoc 
                        AND  CcbDCaja.NroRef = CcbCDocu.Nrodoc 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE CcbDCaja THEN DO:
      FIND CcbCCaja OF CcbDCaja NO-LOCK NO-ERROR.
      IF AVAILABLE CcbCCaja THEN DO:
         x-cheque = TRIM(CcbCCaja.Voucher[2]) + TRIM(CcbCCaja.Voucher[3]).
         IF CcbCCaja.CodBco[2] <> '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = CcbCCaja.CodBco[2]
                         NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN
               x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
         END.
         IF CcbCCaja.CodBco[3] <> '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = CcbCCaja.CodBco[3]
                         NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN 
               x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
         END.
      END.
   END.
END.

DEFINE VAR x-imptot AS CHAR.
 
DEFINE FRAME F-HdrBol
    HEADER
    SKIP(5)
    ccbcdocu.nomcli AT 15  FORMAT "x(50)" 
    ccbcdocu.fchdoc AT 75  FORMAT "99/99/9999" C-Moneda AT 95 ccbcdocu.CodVen AT 110 S-User-Id  AT 121 SKIP
    ccbcdocu.dircli AT 20  FORMAT "x(50)" SKIP
    C-NomCon        AT 15  FORMAT "X(25)"
    STRING(TIME,"HH:MM:SS") AT 75
    ccbcdocu.CodCli AT 95 
    ccbcdocu.nrodoc AT 110 FORMAT "XXX-XXXXXX" 
    CcbCDocu.NroPed AT 122 FORMAT "X(10)"  SKIP(2)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 150.

/*DEFINE FRAME F-DetaBol
 *     N-Item          AT 7   FORMAT "Z9"
 *     ccbddocu.codmat AT 13
 *     almmmatg.desmat AT 24  FORMAT "x(30)"
 *     almmmatg.desmar AT 61  FORMAT "x(10)"
 *     ccbddocu.undvta AT 78
 *     ccbddocu.candes AT 85  FORMAT ">>>>,>>9.99"
 *     ccbddocu.preuni AT 105 FORMAT ">>>,>>9.99"
 *     ccbddocu.pordto AT 116 FORMAT ">9.99"
 *     ccbddocu.implin AT 122 FORMAT ">>>,>>>9.99" 
 *     WITH NO-LABELS NO-BOX STREAM-IO WIDTH 150.*/

DEFINE FRAME F-DetaBol
    N-Item          AT 7   FORMAT "Z9"
    ccbddocu.codmat AT 13
    almmmatg.desmat AT 24  FORMAT "x(40)"
    almmmatg.desmar AT 66  FORMAT "x(10)"
    ccbddocu.undvta AT 78  FORMAT "X(8)"
    ccbddocu.candes AT 89  FORMAT ">>>>,>>9.99"
    ccbddocu.preuni AT 109 FORMAT ">>>,>>9.99"
    ccbddocu.pordto AT 120 FORMAT ">9.99"
    ccbddocu.implin AT 126 FORMAT ">>>,>>>9.99" 
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 150.

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
         HEIGHT             = 2.01
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
FIND ccbdterm WHERE 
     CcbDTerm.CodCia = S-CodCia AND
     CcbDTerm.CodDoc = CcbCDocu.CodDoc AND
     CcbDTerm.CodDiv = S-CodDiv AND
     CcbDTerm.CodTer = S-CodTer AND
     CcbDTerm.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc, 1, 3)) NO-LOCK.
     
FIND FacCorre WHERE 
     FacCorre.CodCia = S-CODCIA AND 
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.CodDoc = ccbcdocu.coddoc AND
     FacCorre.NroSer = CcbDTerm.NroSer NO-LOCK.
     
IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.
   
s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").

x-imptot = STRING(ccbcdocu.imptot, ">>>,>>9.99").

DEFINE FRAME F-FtrBol
    HEADER
    X-EnLetras AT 15 SKIP
    "Almacen : " AT 15 C-DESALM SKIP
    CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(50)" AT 7 SKIP
    if x-cheque <> "" THEN "CHEQUE" ELSE "      "
    AT 6 x-cheque FORMAT "X(20)" SKIP
    CcbDCaja.Nrodoc AT 15
    IF ccbcdocu.codmon = 1 THEN "S/."  ELSE "US$" AT 117 FORMAT "XXXX"
    ccbcdocu.imptot AT 122 FORMAT ">>>,>>9.99" SKIP(1)

/*    IF ccbcdocu.codmon = 1 THEN "S/."  ELSE "US$" AT 117 FORMAT "XXXX"
 * /*    {&PRN8A} + {&PRN6A} + x-imptot  + {&PRN6B} + {&PRN8B} FORMAT "X(10)"  /*AT 122*/  SKIP(1)*/
 *     {&PRN6A} +  x-imptot + {&PRN6B} FORMAT "X(20)"  AT 122  SKIP(1)*/
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 150.

OUTPUT TO VALUE(s-port-name) PAGE-SIZE 33.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(36) + {&PRN4}.

/* Detalle */
FOR EACH ccbddocu OF ccbcdocu NO-LOCK , 
        FIRST almmmatg OF ccbddocu NO-LOCK
        BREAK BY ccbddocu.nrodoc 
        BY ccbddocu.NroItm:
    VIEW FRAME F-HdrBol.
    VIEW FRAME F-FtrBol.
    n-item = n-item + 1.
    x-impbrt = ccbddocu.candes * ccbddocu.preuni.
    DISPLAY n-item 
            ccbddocu.codmat 
            almmmatg.desmat 
            almmmatg.desmar
            ccbddocu.undvta 
            ccbddocu.candes 
            ccbddocu.preuni 
            0 @ ccbddocu.pordto 
            ccbddocu.implin 
            WITH FRAME F-DetaBol.
    IF LAST-OF(ccbddocu.nrodoc) THEN DO:
       PAGE.
    END.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


