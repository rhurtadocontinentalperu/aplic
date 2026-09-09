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
               
FIND CcbCCob WHERE ROWID(CcbCCob) = X-ROWID NO-LOCK NO-ERROR.
     IF NOT AVAILABLE CcbCCob THEN RETURN.
     
 N-RECIBX = CcbCCob.NroDoc.
 N-RECIBY = CcbCCob.NroDoc.
 
 F-FECHAX = CcbCCob.FchDoc.
 F-FECHAY = CcbCCob.FchDoc.
 X-TIPO   = CcbCCob.TpoCmb.
 
     
 FIND gn-cob WHERE gn-cob.codcia = S-CODCIA AND
                   gn-cob.codcob  = CcbCCob.codcob NO-LOCK NO-ERROR.
 IF AVAILABLE gn-cob THEN DO:
       X-Nomcli = Gn-cob.Nomcob. 
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
    
FIND FacCorre WHERE 
     FacCorre.CodCia = S-CODCIA AND 
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.Coddoc = CcbCCob.Coddoc NO-LOCK NO-ERROR.
     
IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").

DEFINE FRAME F-FtrCot
   HEADER
    "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
   "TOTAL IMPORTE   ---------->" FORMAT "x(30)" AT 10 
    CcbCCob.ImpNac[1] AT 50  FORMAT "->>>,>>9.99" 
    CcbCCob.ImpUsa[1] AT 65  FORMAT "->>>,>>9.99"
    CcbCCob.ImpNac[2] AT 80  FORMAT "->>>,>>9.99"
    CcbCCob.ImpUsa[2] AT 95  FORMAT "->>>,>>9.99"
    CcbCCob.ImpNac[5] AT 110  FORMAT "->>>,>>9.99"
    CcbCCob.ImpUsa[5] AT 125 FORMAT "->>>,>>9.99" SKIP   
    "----------------------------------------------------------------------------------------------------------------------------------------" SKIP(2)
    "                 ----------------------                                  ----------------------   " SKIP
    "                       Firma1                                                   Firma2            "
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 360.

DEFINE FRAME F-HdrFac
    HEADER
    {&PRN6A} + S-NOMCIA      AT 01 FORMAT "X(30)" SKIP
    "No RUC   : " AT 01 FORMAT "X(10)" X-RUCCIA FORMAT "X(11)" AT 15  
    "REMITO No: " AT 80 FORMAT "X(10)" N-RECIBX FORMAT "XXX-XXXXXX" AT 95 SKIP
    "DIVISION : " AT 01 FORMAT "X(10)" Gn-Divi.DesDiv    FORMAT "X(30)" AT 15 
    "FECHA      : " AT 80 FORMAT "X(10)" STRING(CcbCCob.FchDoc,"99/99/9999") FORMAT "X(15)" AT 95 SKIP
    "COBRADOR   : " AT 01 FORMAT "X(10)" X-NOMCLI  FORMAT "X(60)" AT 15 SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "                                                        E F E C T I V O               C H E Q U E S                D E P O S I T O S    " SKIP
    "    CLIENTE      NOMBRE/RAZON SOCIAL                   SOLES         DOLARES         SOLES        DOLARES         SOLES         DOLARES " SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------"  
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 250.
    
DEFINE FRAME F-DetaFac1
    CcbDCob.Codcli AT 2   FORMAT "X(11)"  
    CcbDCob.Nomcli AT 14  FORMAT "X(35)"
    CcbDCob.ImpNac[1] AT 50  FORMAT "->>>,>>9.99" 
    CcbDCob.ImpUsa[1] AT 65  FORMAT "->>>,>>9.99"
    CcbDCob.ImpNac[2] AT 80  FORMAT "->>>,>>9.99"
    CcbDCob.ImpUsa[2] AT 95  FORMAT "->>>,>>9.99"
    CcbDCob.ImpNac[5] AT 110  FORMAT "->>>,>>9.99"
    CcbDCob.ImpUsa[5] AT 125 FORMAT "->>>,>>9.99"
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

OUTPUT TO VALUE(s-port-name) PAGE-SIZE 24.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     

VIEW FRAME F-HdrFac.

FOR EACH CcbDCob OF CcbCCob  NO-LOCK 
    BREAK BY CcbDCob.NroDoc :
    
    DISPLAY CcbDCob.Codcli 
            CcbDCob.Nomcli
            CcbDCob.ImpNac[1] WHEN CcbDCob.ImpNac[1] <> 0
            CcbDCob.ImpUsa[1] WHEN CcbDCob.ImpUsa[1] <> 0
            CcbDCob.ImpNac[2] WHEN CcbDCob.ImpNac[2] <> 0
            CcbDCob.ImpUsa[2] WHEN CcbDCob.ImpUsa[2] <> 0
            CcbDCob.ImpNac[5] WHEN CcbDCob.ImpNac[5] <> 0
            CcbDCob.ImpUsa[5] WHEN CcbDCob.ImpUsa[5] <> 0
            WITH FRAME F-DetaFac1.
            
END.

VIEW FRAME F-FtrCot.




OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


