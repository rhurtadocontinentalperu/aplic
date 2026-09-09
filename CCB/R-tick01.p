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
DEF VAR X-dscto1   AS DECIMAL NO-UNDO.
DEF VAR X-preuni   AS DECIMAL NO-UNDO.
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".
DEF VAR X-PUNTOS   AS CHAR FORMAT "X(40)".
DEF VAR X-LIN1     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN2     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN3     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN4     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN5     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN6     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN7     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN8     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN9     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN10    AS CHAR FORMAT "X(40)".
DEF VAR X-LIN11    AS CHAR FORMAT "X(40)".
DEF VAR X-MAQ      AS CHAR FORMAT "X(40)".
DEF VAR X-CANCEL   AS CHAR FORMAT "X(10)".

DEF VAR X-SOL      AS DECI INIT 0.
DEF VAR X-DOL      AS DECI INIT 0.
DEF VAR X-VUE      AS DECI INIT 0.

/*MLR* 28/12/07 ***/
DEF VAR cNroIC LIKE CcbDCaja.Nrodoc NO-UNDO.

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

 
/* Verifica que la cancelación se realizó con CHEQUE */
x-cheque = "".
IF CcbCDocu.Flgest = 'C' THEN DO:
/*MLR* 28/12/07 ***
   FIND FIRST CcbDCaja WHERE CcbDCaja.CodCia = s-codcia 
                        AND  CcbDCaja.CodRef = CcbCDocu.Coddoc 
                        AND  CcbDCaja.NroRef = CcbCDocu.Nrodoc 
                       NO-LOCK NO-ERROR.
   IF AVAILABLE CcbDCaja THEN DO:
      FIND CcbCCaja OF CcbDCaja NO-LOCK NO-ERROR.
      IF AVAILABLE CcbCCaja THEN DO:
* ***/
/*MLR* 28/12/07 ***/
    FOR EACH CcbDCaja WHERE
        CcbDCaja.CodCia = s-codcia AND
        CcbDCaja.CodRef = CcbCDocu.Coddoc AND
        CcbDCaja.NroRef = CcbCDocu.Nrodoc NO-LOCK,
        FIRST ccbccaja WHERE
        ccbccaja.codcia = ccbdcaja.codcia AND
        ccbccaja.coddiv = ccbdcaja.coddiv AND
        ccbccaja.coddoc = ccbdcaja.coddoc AND
        ccbccaja.nrodoc = ccbdcaja.nrodoc NO-LOCK:
        cNroIC = CcbDCaja.Nrodoc.

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
         IF CcbcCaja.ImpNac[1] + CcbCCaja.ImpUsa[1] > 0 Then x-cancel = x-cancel + ",Efectivo".
         IF CcbcCaja.ImpNac[2] + CcbCCaja.ImpUsa[2] + CcbcCaja.ImpNac[3] + CcbCCaja.ImpUsa[3] > 0 Then x-cancel = x-cancel + ",Cheque".
         IF CcbcCaja.ImpNac[4] + CcbCCaja.ImpUsa[4] > 0 Then x-cancel = x-cancel + ",Tarjeta".
         x-sol = CcbcCaja.ImpNac[1] + CcbcCaja.ImpNac[2] + CcbcCaja.ImpNac[3] + CcbcCaja.ImpNac[4].
         x-dol = CcbcCaja.ImpUsa[1] + CcbcCaja.ImpUsa[2] + CcbcCaja.ImpUsa[3] + CcbcCaja.ImpUsa[4].
         x-vue = CcbCCaja.VueNac .
/*MLR* 28/12/07 ***         
      END.
* ***/
   END.
END.
 
DEFINE FRAME F-HdrBol
    HEADER
    SKIP(2)
    'L A U   C H U N' AT 10 SKIP
    "OFIMAX PERU SAC"  AT 15 SKIP 
    "Av.General Canevaro 388 Of 503 Lince" AT 1 SKIP
    "Lima-Peru" AT 15 SKIP
    "Telefono : 3444444" AT 15 SKIP
    "R.U.C. 20503843812" AT 15 SKIP
    "Ticket No : " AT 1 
    ccbcdocu.nrodoc AT 15 FORMAT "XXX-XXXXXX" 
    TODAY AT 30 SKIP
    STRING(TIME,"HH:MM:SS") AT 30
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 150.

DEFINE FRAME F-DetaBol
    ccbddocu.codmat AT 1
    almmmatg.desmat AT 8   FORMAT "x(15)"
    ccbddocu.undvta AT 25  FORMAT "X(4)"
    ccbddocu.candes AT 30  FORMAT ">>>99"
    ccbddocu.implin AT 36  FORMAT ">>,>>>9.99" 
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 150.

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

/*RUN aderb/_prlist.p(
 *     OUTPUT s-printer-list,
 *     OUTPUT s-port-list,
 *     OUTPUT s-printer-count).*/
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
RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.
/*
 * IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
 *    MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
 *    RETURN.
 * END.
 *    
 * s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
 * s-port-name = REPLACE(S-PORT-NAME, ":", "").
 * */
IF s-OpSys = 'WinVista'
THEN OUTPUT TO PRINTER VALUE(s-port-name).
ELSE OUTPUT TO VALUE(s-port-name).

/*
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(36) + {&PRN4}.
*/
PUT CONTROL {&PRN4}.

/* Detalle */
x-lin3 = "Term/Usr :" + TRIM(S-CODTER) + "/" + SUBSTRING(TRIM(Ccbcdocu.Usuario),1,7) + "      " + STRING(TIME,"HH:MM:SS").
x-lin4 = "Total Importe : S/." + STRING(Ccbcdocu.ImpTot,">>>,>>9.99").
/*MLR* 28/12/07 ***
x-lin5 = "I/C,P/M,ALM:" + CcbDCaja.Nrodoc + "/" + Ccbcdocu.NroPed + "/" + Ccbcdocu.Nrosal .
* ***/
x-lin5 = "I/C,P/M,ALM:" + cNroIC + "/" + Ccbcdocu.NroPed + "/" + Ccbcdocu.Nrosal .
case s-codter :
     when "TERM01" Then x-maq = "A4UK016216".
     when "TERM02" Then x-maq = "A4UK016563".
     when "TERM03" Then x-maq = "A4UK016251".
     when "TERM05" Then x-maq = "A4UK016252".
end.

x-lin7 = "  Cliente: " + ccbcdocu.nomcli.
x-lin6 = "Direccion: " + ccbcdocu.dircli.
x-lin8 = "Maq. Registradora : " + x-maq. 
x-lin9 = "Pago : " + X-CANCEl .
x-lin10 = "  S/." + STRING(X-SOL,">>,>>9.99") + "    US$" + STRING(X-DOL,">>,>>9.99").
x-lin11 = "Vuelto S/." + STRING(X-VUE,">>,>>9.99") .
 
DISPLAY 
    'CONTINENTAL S.A.C.' AT 12 FORMAT "X(60)" SKIP
    "Especialista en utiles " AT 10 FORMAT "X(50)" SKIP 
    "escolares y de oficina" AT 10 FORMAT "X(50)" SKIP 
    "C.C. Plaza San Miguel Tda. 73 - Lima 32" AT 1 FORMAT "X(50)" SKIP
    "Calle Renee Descartes Mz.T LT.1 " AT 1 FORMAT "X(50)" SKIP
    "Ate - Vitarte " AT 14 FORMAT "X(50)" SKIP
    "Telf: 566-2499     R.U.C. 20100038146" AT 1 FORMAT "X(40)" SKIP
    "Ticket No : " AT 1 ccbcdocu.nrodoc AT 15 FORMAT "XXX-XXXXXX" NO-LABEL TODAY AT 30 SKIP
    x-lin7 No-LABEL SKIP
    x-lin6 No-LABEL SKIP
    x-lin8 No-LABEL SKIP
    x-lin5 NO-LABEL SKIP    
    x-lin3 NO-LABEL SKIP
    x-lin4 NO-LABEL SKIP
    x-lin9 NO-LABEL SKIP
    x-lin10 NO-LABEL SKIP
    x-lin11 NO-LABEL.     

FOR EACH ccbddocu OF ccbcdocu NO-LOCK , 
        FIRST almmmatg OF ccbddocu NO-LOCK
        BREAK BY ccbddocu.nrodoc 
        BY ccbddocu.NroItm:
        x-lin1 = TRIM(ccbddocu.codmat) + " " + SUBSTRING(TRIM(almmmatg.desmat),1,25) + " " + SUBSTRING(TRIM(almmmatg.desmar),1,6).
        x-lin2 = SUBSTRING(TRIM(ccbddocu.undvta),1,6) + " " + STRING(ccbddocu.candes,">,>>9.99") + " " + STRING(ccbddocu.preuni,">>>9.99") + " " + STRING(ccbddocu.implin,">>>,>>9.99").
    DISPLAY x-lin1 NO-LABEL 
            x-lin2 NO-LABEL.
END.
PUT "--------------------------------------" SKIP.
PUT "NO SE ACEPTAN CAMBIOS NI DEVOLUCIONES" SKIP.
PUT "GRACIAS POR SU COMPRA" AT 12 SKIP.
PUT "STANDFORD - CONTI" AT 14 SKIP.
PUT CONTROL CHR(27) + 'F'.  /*&& Corte de hoja*/
              
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


