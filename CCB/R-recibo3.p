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
DEFINE SHARED VAR CL-CODCIA       AS INT.

DEF VAR X-EnLetras AS CHAR FORMAT "X(60)" NO-UNDO.
DEF VAR X-Nomcli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-Dircli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-Mon      AS CHAR FORMAT "X(4)"  NO-UNDO.
DEF VAR X-Total    AS DECIMAL INIT 0.
DEF VAR X-RUCCLI   AS CHAR FORMAT "X(11)" NO-UNDO.
DEF VAR Y-Nomcli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR Y-Dircli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR Y-Mon      AS CHAR FORMAT "X(4)"  NO-UNDO.
DEF VAR Y-Total    AS DECIMAL INIT 0.

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
DEF VAR X-RUCCIA   AS CHAR INIT "20100038146" FORMAT "X(11)".
               
FIND CCbCcaja WHERE ROWID(CCbCcaja) = X-ROWID NO-LOCK NO-ERROR.
     IF NOT AVAILABLE CCbCcaja THEN RETURN.
     
 N-RECIBX = CcbCcaja.NroDoc.
 N-RECIBY = CcbCcaja.NroDoc.
 
 F-FECHAX = CcbcCaja.FchDoc.
 F-FECHAY = CcbcCaja.FchDoc.
 X-TIPO   = CcbcCaja.TpoCmb.
 
     
 FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA AND
      gn-clie.codcli = CCbCcaja.codcli NO-LOCK NO-ERROR.
 IF AVAILABLE gn-clie THEN DO:
    IF gn-clie.codcli <> "11111111" THEN DO:
       X-Nomcli = CCbCcaja.codcli + " " + gn-clie.NomCli. 
       X-Dircli = gn-clie.DirCli. 
       Y-Nomcli = gn-clie.NomCli. 
       y-Dircli = gn-clie.DirCli.
       X-RUCCLI = gn-clie.Ruc.
    END.   
    ELSE DO:
       X-Nomcli = CCbCcaja.codcli + " " + CcbCcaja.NomCli. 
       X-Dircli = "". 
       Y-Nomcli = CcbCcaja.NomCli. 
       y-Dircli = "".
       X-RUCCLI = "".
    END.   
 END.

 FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                    Gn-Divi.Coddiv = S-CODDIV NO-LOCK NO-ERROR.
 IF NOT AVAILABLE Gn-Divi THEN DO:
    MESSAGE "Division " + S-CODDIV + " No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
    RETURN .
 END.

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
         HEIGHT             = 4.08
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
/* FIND ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND               */
/*      CcbDTerm.CodDoc = CCbCcaja.coddoc AND                       */
/*      CcbDTerm.CodDiv = s-coddiv AND                              */
/*      CcbDTerm.CodTer = s-codter AND                              */
/*      CcbDTerm.NroSer = INTEGER(SUBSTRING(CcbCcaja.NroDoc, 1, 3)) */
/*      NO-LOCK.                                                    */
/* FIND FacCorre WHERE                                              */
/*      FacCorre.CodCia = S-CODCIA AND                              */
/*      FacCorre.CodDiv = S-CODDIV AND                              */
/*      FacCorre.CodDoc = CCbCcaja.coddoc AND                       */
/*      FacCorre.NroSer = CcbDTerm.NroSer NO-LOCK.                  */
/* RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).       */
/* IF s-port-name = '' THEN RETURN.                                 */

DEFINE FRAME F-FtrCot
   HEADER
   "TOTAL IMPORTE   ---------->" /*FORMAT "x(30)"*/ AT 30 
   X-TOTAL FORMAT "->>>,>>9.99" AT 75
   Y-TOTAL FORMAT "->>>,>>9.99" AT 100 SKIP
   "---------------------------------------------------------------------------------------------------------------" SKIP
   "FORMA DE PAGO                     BANCO        # DOCUMENTO    " SKIP
   "Efectivo       "      AT 1   /*FORMAT "X(15)" */
   CcbCCaja.ImpNac[1]     AT 75  FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[1]     AT 100 FORMAT "->>>,>>9.99" SKIP

   "Cheque del Dia "      AT 1   /*FORMAT "X(15)"*/
   CcbCCaja.CodBco[2]     AT 35  FORMAT "X(5)" 
   CcbCCaja.FchVto[2]     AT 42 
   CcbCCaja.Voucher[2]    AT 55 
   CcbCCaja.ImpNac[2]     AT 75  FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[2]     AT 100 FORMAT "->>>,>>9.99" SKIP

   "Cheque Diferido"      AT 1   /*FORMAT "X(15)"*/
   CcbCCaja.CodBco[3]     AT 35  FORMAT "X(5)"
   CcbCCaja.FchVto[3]     AT 42
   CcbCCaja.Voucher[3]    AT 55 
   CcbCCaja.ImpNac[3]     AT 75  FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[3]     AT 100 FORMAT "->>>,>>9.99" SKIP

   "Nota de Credito"      AT 1   /*FORMAT "X(15)"*/
   CcbCCaja.CodBco[6]     AT 35  FORMAT "X(5)"
   CcbCCaja.FchVto[6]     AT 42
   CcbCCaja.Voucher[6]    AT 55 
   CcbCCaja.ImpNac[6]     AT 75  FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[6]     AT 100 FORMAT "->>>,>>9.99" SKIP

   "Depositos      "      AT 1   /*FORMAT "X(15)"*/
   CcbCCaja.CodBco[5]     AT 35  FORMAT "X(5)"
   CcbCCaja.FchVto[5]     AT 42
   CcbCCaja.Voucher[5]    AT 55 
   CcbCCaja.ImpNac[5]     AT 75  FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[5]     AT 100 FORMAT "->>>,>>9.99" SKIP

   "Anticipo       "      AT 1   /*FORMAT "X(15)"*/
   CcbCCaja.Voucher[7]    AT 55 
   CcbCCaja.ImpNac[7]     AT 75  FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[7]     AT 100 FORMAT "->>>,>>9.99" SKIP

   "Comision       "      AT 1   /*FORMAT "X(15)"*/
   CcbCCaja.Voucher[8]    AT 55 
   CcbCCaja.ImpNac[8]     AT 75  FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[8]     AT 100 FORMAT "->>>,>>9.99" SKIP

   "Retenciones    "      AT 1   /*FORMAT "X(15)"*/
   CcbCCaja.ImpNac[9]     AT 75  FORMAT "->>>,>>9.99" SKIP

   "Vales Consumo  "      AT 1   /*FORMAT "X(15)"*/
   CcbCCaja.ImpNac[10]    AT 75  FORMAT "->>>,>>9.99"
   CcbCCaja.ImpUsa[10]    AT 100 FORMAT "->>>,>>9.99" SKIP
   "---------------------------------------------------------------------------------------------------------------" SKIP
   "Este Documento no tiene Validez sin la Firma y Sello de Caja" AT 30 /*FORMAT "X(100)"        */
   WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 250.

DEFINE FRAME F-HdrFac
    HEADER
    {&PRN6A} + S-NOMCIA      AT 01 FORMAT "X(30)" SKIP
    "No RUC   : " AT 01 /*FORMAT "X(10)"*/ X-RUCCIA FORMAT "X(11)" AT 15  
    "RECIBO No: " AT 80 /*FORMAT "X(10)"*/ N-RECIBX FORMAT "XXX-XXXXXX" AT 95 SKIP
    "DIVISION : " AT 01 /*FORMAT "X(10)"*/ Gn-Divi.DesDiv    FORMAT "X(30)" AT 15 
    "CAJERO   : " AT 80 /*FORMAT "X(10)"*/ CcbCCaja.Usuario  FORMAT "X(10)" AT 95 SKIP
    "---------------------------------------------------------------------------------------------------------------" SKIP
    "SEÑOR(es)                                                            RUC / D.N.I      FECHA            T/C  " SKIP
    X-NOMCLI  AT 10 FORMAT "X(50)"
    X-RUCCLI  AT 70 FORMAT "X(11)"
    STRING(F-FECHAX,"99/99/9999") FORMAT "X(15)" AT 85 
    CcbCCaja.Tpocmb AT 103 FORMAT "->>>.9999" SKIP
    "---------------------------------------------------------------------------------------------------------------" SKIP
    "         TD       NUM.DOC         FECHA VCMTO           MORA                 NUEVOS SOLES          US$ DOLARES "  SKIP
    "---------------------------------------------------------------------------------------------------------------"  
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 250.
    
DEFINE FRAME F-DetaFac1
    CcbDCaja.Codref AT 10  FORMAT "X(5)"  
    CcbDCaja.Nroref AT 18  FORMAT "XXX-XXXXXXXX" 
    CcbCDocu.FchVto AT 35  FORMAT "99/99/9999"
    X-Total         AT 75  FORMAT "->>>,>>9.99" 
    Y-Total         AT 100 FORMAT "->>>,>>9.99" 
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

/*OUTPUT TO PRINTER VALUE(s-port-name) PAGE-SIZE 24.*/
/*
{lib/_printer-to.i 24}
*/

DEF VAR lStatus AS LOG NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE lStatus .
IF lStatus = NO THEN RETURN.

OUTPUT TO PRINTER PAGE-SIZE 24.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     

VIEW FRAME F-HdrFac.

FOR EACH CcbDCaja OF CCbCcaja  NO-LOCK 
    BREAK BY CcbDCaja.NroDoc :
    
    FIND CcbCDocu WHERE CcbcDocu.Codcia = S-CODCIA AND
                        CcbcDocu.CodCli = CcbCCaja.CodCli AND
                        CcbcDocu.CodDoc = CcbDCaja.Codref AND
                        CcbcDocu.Nrodoc = CcbDCaja.Nroref NO-LOCK NO-ERROR.                                   

    IF CcbcDocu.CodDoc = "N/C" THEN DO:
        IF CcbdCaja.Codmon = 1 THEN X-TOTAL = X-TOTAL - CcbDCaja.Imptot.
        ELSE Y-TOTAL = Y-TOTAL - CcbDCaja.Imptot.
    END.
    ELSE DO:
        IF CcbdCaja.Codmon = 1 THEN X-TOTAL = X-TOTAL + CcbDCaja.Imptot.
        ELSE Y-TOTAL = Y-TOTAL + CcbDCaja.Imptot .
    END.
    DISPLAY CcbDCaja.Codref 
            CcbDCaja.Nroref
            CcbCDocu.FchVto
            CcbDCaja.ImpTot WHEN CcbDCaja.Codmon = 01 @ X-TOTAL
            CcbDCaja.ImpTot WHEN CcbDCaja.Codmon = 02 @ Y-TOTAL
            WITH FRAME F-DetaFac1.
            
END.

VIEW FRAME F-FtrCot.




OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


