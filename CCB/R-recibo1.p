&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : R-Recibo.p
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.
DEFINE SHARED VAR S-CODCIA        AS INT.
DEFINE SHARED VAR S-CODDIV        LIKE gn-divi.coddiv.
DEFINE SHARED VAR S-CODTER        LIKE ccbcterm.codter.
DEFINE SHARED VAR S-NOMCIA        AS CHAR.

DEF VAR X-EnLetras AS CHAR FORMAT "X(60)" NO-UNDO.
DEF VAR X-Nomcli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-Dircli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-Mon      AS CHAR FORMAT "X(4)"  NO-UNDO.
DEF VAR X-Total    AS DECIMAL.

DEF VAR Y-Nomcli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR Y-Dircli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR Y-Mon      AS CHAR FORMAT "X(4)"  NO-UNDO.
DEF VAR Y-Total    AS DECIMAL.

DEFINE VAR E-VISUAL AS CHARACTER VIEW-AS EDITOR SIZE 50 BY 2.
DEFINE VAR Y-VISUAL AS CHARACTER VIEW-AS EDITOR SIZE 50 BY 2.

DEF VAR X-Descri   AS CHAR FORMAT "X(40)" NO-UNDO.
DEF VAR X-Direcc   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-Telefo   AS CHAR FORMAT "X(10)" NO-UNDO.
DEF VAR X-Desdiv   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR N-RECIBX   AS CHAR FORMAT "X(10)"  NO-UNDO.
DEF VAR N-RECIBY   AS CHAR FORMAT "X(10)"  NO-UNDO.
DEF VAR F-FECHAX   AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR F-FECHAY   AS DATE FORMAT "99/99/9999" NO-UNDO.

DEF VAR X-Codig    AS CHAR NO-UNDO.
DEF VAR Y-Codig    AS CHAR NO-UNDO.
DEF VAR X-CoRef    AS CHAR FORMAT "XX" NO-UNDO.
DEF VAR Y-CoRef    AS CHAR FOrmat "XX" NO-UNDO.        
DEF VAR X-NoRef    AS CHAR FORMAT "XXX-XXXXXX" NO-UNDO.
DEF VAR Y-NoRef    AS CHAR FORMAT "XXX-XXXXXX" NO-UNDO.                
DEF VAR x-tipo     AS deci FORMAT ">>9.9999" .                

               
FIND CCbCcaja WHERE ROWID(CCbCcaja) = X-ROWID NO-LOCK NO-ERROR.
     IF NOT AVAILABLE CCbCcaja THEN RETURN.
     
 N-RECIBX = CcbCcaja.NroDoc.
 N-RECIBY = CcbCcaja.NroDoc.
 
 F-FECHAX = CcbcCaja.FchDoc.
 F-FECHAY = CcbcCaja.FchDoc.
 X-TIPO   = CcbcCaja.TpoCmb.
 
     
 FIND gn-clie WHERE gn-clie.codcia = 0 AND
      gn-clie.codcli = CCbCcaja.codcli NO-LOCK NO-ERROR.
 IF AVAILABLE gn-clie THEN DO:
    IF gn-clie.codcli <> "11111111" THEN DO:
       X-Nomcli = CCbCcaja.codcli + " " + gn-clie.NomCli. 
       X-Dircli = gn-clie.DirCli. 
       Y-Nomcli = gn-clie.NomCli. 
       y-Dircli = gn-clie.DirCli.
    END.   
    ELSE DO:
       X-Nomcli = CCbCcaja.codcli + " " + CcbCcaja.NomCli. 
       X-Dircli = "". 
       Y-Nomcli = CcbCcaja.NomCli. 
       y-Dircli = "".
    END.   
 END.

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
FIND ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND
     CcbDTerm.CodDoc = CCbCcaja.coddoc AND
     CcbDTerm.CodDiv = s-coddiv AND
     CcbDTerm.CodTer = s-codter AND
     CcbDTerm.NroSer = INTEGER(SUBSTRING(CcbCcaja.NroDoc, 1, 3))
     NO-LOCK.
FIND FacCorre WHERE 
     FacCorre.CodCia = S-CODCIA AND 
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.CodDoc = CCbCcaja.coddoc AND
     FacCorre.NroSer = CcbDTerm.NroSer NO-LOCK.
     
IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").

DEFINE VARIABLE S-DETALLE AS CHAR EXTENT 2 FORMAT "X(30)".
S-DETALLE[1] = "   " + s-codter + "   " + S-CODDIV.
S-DETALLE[2] = "   " + s-codter + "   " + S-CODDIV.

DEFINE FRAME F-HdrFac
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(30)" 
    {&PRN2} + {&PRN7A} + {&PRN6A} + "REC No. " AT 45 FORMAT "X(15)" N-RECIBX + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "XXX-XXXXXX" AT 60  SKIP
    {&PRN3} + {&PRN6A} + "Papeleria, Articulos de Escritorio Jugueteria" + {&PRN3} + {&PRN6B} FORMAT "X(50)" AT 1 SKIP
/*    {&PRN2} + {&PRN6A} + " " SKIP*/
    "Fecha :"  format "x(10)" at 90 string(F-FECHAX,"99/99/9999")  FORMAT "X(25)" at 105 SKIP
    "Recibi de       :" X-Nomcli FORMAT "X(41)" 
    "T/C   :"  format "x(10)" at 90 string(X-TIPO,">>9.9999")      FORMAT "X(25)" at 105 SKIP
    "Por Concepto de :" X-Codig  SKIP
    "---------------------------------------------------------------------------------------------------------------"  SKIP
    "        Tipo     Numero                 Mon                     Importe                                        "  SKIP
    "---------------------------------------------------------------------------------------------------------------"  

    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 250.
    
DEFINE FRAME F-DetaFac1
    X-CoRef AT 10 FORMAT "XXXX"  space(2)
    X-Noref FORMAT "XXX-XXXXXX"  SPACE(15) 
    X-mon 
    X-Total AT 50     FORMAT "->>>,>>9.99" 
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-Ftrfac
    HEADER
   "---------------------------------------------------------------------------------------------------------------"  SKIP
   "                                 Soles                 Dolares             Referencia                          "  SKIP
   "---------------------------------------------------------------------------------------------------------------"  SKIP
   "  Efectivo          " AT 5  FORMAT "X(20)" 
   CcbCCaja.ImpNac[1]     AT 30 FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[1]     AT 50 FORMAT "->>>,>>9.99" SKIP
   "  Cheque            " AT 5 FORMAT "X(20)"
   CcbCCaja.ImpNac[2]     AT 30 FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[2]     AT 50 FORMAT "->>>,>>9.99" 
   CcbCCaja.CodBco[2]     AT 70 FORMAT "X(8)" 
   CcbCCaja.FchVto[2]     AT 80 
   CcbCCaja.Voucher[2]    AT 100 SKIP
   "  Cheque Diferido   " AT 5 FORMAT "X(20)"
   CcbCCaja.ImpNac[3]     AT 30 FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[3]     AT 50 FORMAT "->>>,>>9.99" 
   CcbCCaja.CodBco[3]     AT 70 FORMAT "X(8)"
   CcbCCaja.FchVto[3]     AT 80
   CcbCCaja.Voucher[3]    AT 100 SKIP
   "  Nota de Credito   " AT 5 FORMAT "X(20)"
   CcbCCaja.ImpNac[6]     AT 30 FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[6]     AT 50 FORMAT "->>>,>>9.99" 
   CcbCCaja.CodBco[6]     AT 70 FORMAT "X(8)"
   CcbCCaja.FchVto[6]     AT 80
   CcbCCaja.Voucher[6]    AT 100 SKIP
   "  Deposito          " AT 5 FORMAT "X(20)"
   CcbCCaja.ImpNac[5]     AT 30 FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[5]     AT 50 FORMAT "->>>,>>9.99" 
   CcbCCaja.CodBco[5]     AT 70 FORMAT "X(8)"
   CcbCCaja.FchVto[5]     AT 80
   CcbCCaja.Voucher[5]    AT 100 SKIP
   "  Vuelto            " AT 5  FORMAT "X(20)" 
   CcbCCaja.VueNac        AT 30 FORMAT "->>>,>>9.99"
   CcbCCaja.VueUsa        AT 50 FORMAT "->>>,>>9.99" SKIP
   "---------------------------------------------------------------------------------------------------------------"  SKIP(2)
/*
    " T O T A L    >>>> " AT 30 
    X-TOTAL   AT 50 FORMAT "->>>,>>9.99" SKIP(2)
    /*"SON : " X-ENLETRAS SKIP(2)*/
 */   
    space(20) "------------------" space(50) "------------------"  SKIP
    space(20) "    C A J E R O   " space(50) "   C L I E N T E  "  SKIP
    "HORA : " AT 1 STRING(TIME,"HH:MM:SS") S-DETALLE[1]  
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200.    
    
OUTPUT TO VALUE(s-port-name) PAGE-SIZE 30.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     
    VIEW FRAME F-HdrFac.
    /*VIEW FRAME F-Ftrfac.*/
    FOR EACH CcbDCaja OF CCbCcaja  NO-LOCK BREAK BY CcbDCaja.NroDoc:
        X-Codig = CcbDcaja.CodDoc.
        Y-Codig = CcbDcaja.CodDoc.
        X-CoRef = CcbDcaja.CodREF.
        Y-CoRef = CcbDcaja.CodREF.        
        X-NoRef = CcbDcaja.NroRef.
        Y-NoRef = CcbDcaja.NroRef.                
        X-Total = X-TOTAL + CcbDCaja.Imptot.
        Y-Total = CcbDCaja.Imptot.  
        IF CcbdCaja.Codmon = 1 THEN DO: X-mon = "S/.". Y-mon = "S/.". END.
        ELSE DO: X-mon = "US$.". Y-mon = "US$.". END.
           
        /******** PUNTEROS EN POSICION  *******************************/
        RUN bin/_numero(CCbDcaja.imptot, 2, 1, OUTPUT X-EnLetras).
        X-EnLetras = X-EnLetras + (IF CCbDcaja.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
        E-VISUAL = X-ENLETRAS.
        Y-VISUAL = X-ENLETRAS.    
        DISPLAY X-CoRef  
                X-NoRef  
                X-Mon
                CcbDCaja.Imptot WITH FRAME F-DetaFac1.
        IF LAST-OF(CcbDCaja.Nrodoc) THEN DO:
          RUN bin/_numero(X-TOTAL, 2, 1, OUTPUT X-EnLetras).
          X-EnLetras = X-EnLetras + (IF CCbDcaja.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
          VIEW FRAME F-Ftrfac.
          PAGE.
       END.
    END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


