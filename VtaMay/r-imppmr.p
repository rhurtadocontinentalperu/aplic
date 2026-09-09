&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-ImpPed.p
    Purpose     : Impresion de Pedidos y Cotizaciones

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

DEFINE SHARED VARIABLE S-USER-ID  AS CHAR. 
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR CL-codcia AS INT.
/*DEF SHARED VAR s-codalm AS CHAR.*/
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter LIKE ccbcterm.codter.
DEF SHARED VAR S-NomCia AS CHAR.
DEF        VAR C-NomVen AS CHAR FORMAT "X(30)".
DEF        VAR C-Moneda AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF        VAR C-TitDoc AS CHAR FORMAT "X(50)".
DEF        VAR XD AS CHAR FORMAT "X(2)".
DEF        VAR I-NroItm AS INTEGER.
DEF        VAR F-PreNet AS DECIMAL.
DEF        VAR W-DIRALM AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM AS CHAR FORMAT "X(13)".

DEFINE VARIABLE x-dscto AS DECIMAL.

DEFINE VARIABLE X-IMPIGV AS CHARACTER FORMAT "X(30)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.

FIND FacCPedi WHERE ROWID(FacCPedi) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN.
FIND CcbCDocu WHERE ccbcdocu.codcia = faccpedi.codcia
    AND ccbcdocu.coddoc = FacCPedi.Cmpbnte
    AND ccbcdocu.nrodoc = faccpedi.nroref
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CcbCDocu THEN RETURN.

C-TitDoc = "PRESUPUESTO :". 

IF FacCpedi.Codmon = 2 THEN C-Moneda = "DOLARES US$".
ELSE C-Moneda = "SOLES   S/ ".

C-NomVen = FacCPedi.CodVen.
C-NomCon = FacCPedi.FmaPgo.
XD       = STRING (FacCpedi.Fchven - FacCpedi.Fchped,"->>>9").
X-IMPIGV = IF FacCpedi.FlgIgv THEN "LOS PRECIOS INCLUYEN EL I.G.V."
           ELSE "LOS PRECIOS NO INCLUYEN EL IGV.".


FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA 
              AND  gn-clie.codcli = FacCPedi.codcli 
             NO-LOCK.

FIND gn-ven WHERE gn-ven.CodCia = FacCPedi.CodCia 
             AND  gn-ven.CodVen = FacCPedi.CodVen 
            NO-LOCK NO-ERROR.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.

/* FIND Almacen WHERE Almacen.CodCia = S-CODCIA */
/*               AND  Almacen.CodAlm = S-CODALM */
/*              NO-LOCK NO-ERROR.               */
/* IF AVAILABLE Almacen THEN                    */
/*     W-DIRALM = Almacen.DirAlm.               */
/* W-TLFALM = Almacen.TelAlm.                   */




/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(FacCPedi.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF FacCPedi.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

DEFINE FRAME F-DetaPed
    I-NroItm FORMAT ">>>9"
    FacDPedi.codmat FORMAT "X(6)"
    FacDPedi.CanPed FORMAT "->>>,>>9.99"
    FacDPedi.undvta FORMAT "X(4)"
    almmmatg.desmat FORMAT "X(45)"
    almmmatg.desmar FORMAT "X(11)"    
    FacDPedi.preuni FORMAT "->>,>>9.9999"
    FacDPedi.implin FORMAT "->,>>>,>>9.99" SKIP
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

DEFINE FRAME F-DetaCot
    I-NroItm FORMAT ">>>9"
    FacDPedi.codmat FORMAT "X(6)"
    FacDPedi.CanPed FORMAT "->>>,>>9.99"
    FacDPedi.undvta FORMAT "X(4)"
    almmmatg.desmat FORMAT "X(45)"
    almmmatg.desmar FORMAT "X(11)"
    FacDPedi.preuni FORMAT "->,>>>,>>9.9999"
    FacDPedi.PorDto FORMAT "->>9.99 %"
    FacDPedi.implin FORMAT "->,>>>,>>9.9999" SKIP
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

DEFINE FRAME F-FtrPed
    HEADER
    "PERCPECION   : " TO 102 SUBSTRING(C-MONEDA,9,4) Faccpedi.AcuBon[5]                                         FORMAT "->>,>>>,>>9.99" SKIP
    "NETO A PAGAR : " TO 102 SUBSTRING(C-MONEDA,9,4) FacCPedi.imptot + Faccpedi.AcuBon[5]                       FORMAT "->>,>>>,>>9.99" SKIP(1)
    "DIFERENCIAL  : " TO 102 SUBSTRING(C-MONEDA,9,4) (CcbCDocu.ImpTot - FacCPedi.ImpTot - Faccpedi.AcuBon[5])   FORMAT "->>,>>>,>>9.99" SKIP(5)
    "HORA : " TO 1 STRING(TIME,"HH:MM:SS")  S-USER-ID TO 67 SKIP 
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.

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
         HEIGHT             = 5.77
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
DEF VAR x-Ok AS LOG INIT FALSE.

SYSTEM-DIALOG PRINTER-SETUP
  UPDATE x-Ok.
IF x-Ok = NO THEN RETURN.

/* ******************* RHC **********************
/* Definimos impresoras */
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = FacCPedi.coddoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(FacCPedi.NroPed,1,3))  
              NO-LOCK.
  
IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").
******************************************* */

DEFINE VARIABLE X-ORDCOM AS CHARACTER FORMAT "X(18)".

DEFINE FRAME F-HdrPed
    HEADER 
    {&PRN7A} + {&PRN6A} + C-TitDoc + {&PRN6B} + {&PRN7B} + {&PRN3} AT 82 FORMAT "X(22)" 
    {&PRN7A} + {&PRN6A} + FacCPedi.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 104 FORMAT "XXXXXX-XXXXXXXXXXXX" SKIP
    "Señor(es) : " TO 40 faccpedi.nomcli FORMAT "x(50)" SKIP 
    "Direccion : " TO 40 faccpedi.DirCli FORMAT "x(40)" "Emision         : " TO 100 FacCPedi.FchPed SKIP
    "Codigo    : " TO 40 faccpedi.CodCli "No. Tarjeta     : " TO 100 CcbCDocu.NroCard  SKIP
    "Vendedor  : " TO 40 C-NomVen        "Referencia Doc. : " TO 100 CcbCDocu.CodDoc CcbCDocu.NroDoc FORMAT 'x(12)' SKIP
    "Cond.Venta: " TO 40 C-NomCon        "Moneda          : " TO 100 C-Moneda        SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "ITEM CODIGO   CANTIDAD UND.             D E S C R I P C I O N             M A R C A      PRECI_VTA        TOTAL NETO                    " SKIP
    "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.


OUTPUT TO PRINTER PAGE-SIZE 30.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.     

I-NroItm = 0.
FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = FacCPedi.CodCia 
                           AND  FacDPedi.CodDoc = FacCPedi.CodDoc 
                           AND  FacDPedi.NroPed = FacCPedi.NroPed , 
      FIRST almmmatg OF FacDPedi NO-LOCK,
      FIRST almmmate WHERE almmmate.codcia = facdpedi.codcia
          AND almmmate.codalm = facdpedi.almdes
          AND almmmate.codmat = facdpedi.codmat
      BREAK BY FacDPedi.NroPed
      BY FacDPedi.NroItm:
    I-NroItm = I-NroItm + 1.
    F-PreNet = FacDPedi.preuni * ( 1 - FacDPedi.PorDto / 100 ).
    VIEW FRAME F-HdrPed.
    VIEW FRAME F-FtrPed.

  x-dscto = 0.
  IF FacDPedi.undvta = Almmmatg.UndA THEN 
      x-dscto = Almmmatg.dsctos[1]. ELSE 
  IF FacDPedi.undvta = Almmmatg.UndB THEN
      x-dscto = Almmmatg.dsctos[2]. ELSE 
  IF FacDPedi.undvta = Almmmatg.UndC THEN
      x-dscto = Almmmatg.dsctos[3].

    DISPLAY I-NroItm
            FacDPedi.codmat
            FacDPedi.CanPed
            FacDPedi.undvta
            almmmatg.desmat
            almmmatg.desmar
            FacDPedi.preuni
            FacDPedi.implin 
            WITH FRAME F-DetaPed.
    IF LAST-OF(FacDPedi.NroPed) THEN DO:
         PAGE.
    END.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


