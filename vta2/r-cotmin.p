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

DEF SHARED VAR S-USER-ID AS CHAR. 
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR CL-codcia  AS INT.
DEF SHARED VAR s-codalm  AS CHAR.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR S-NomCia  AS CHAR.
DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR C-TitDoc  AS CHAR FORMAT "X(50)".
DEF        VAR XD        AS CHAR FORMAT "X(2)".
DEF        VAR I-NroItm  AS INTEGER.
DEF        VAR F-PreNet  AS DECIMAL.
DEF        VAR W-DIRALM  AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM  AS CHAR FORMAT "X(65)".

DEF        VAR F-PreUni  LIKE FacDPedi.Preuni.
DEF        VAR F-ImpLin  LIKE FacDPedi.ImpLin.
DEF        VAR F-ImpTot  LIKE FacCPedi.ImpTot.

DEF        VAR F-CodUbi  LIKE Almmmate.CodUbi.

DEFINE VARIABLE x-dscto AS DECIMAL.

DEFINE VARIABLE X-IMPIGV AS CHARACTER FORMAT "X(30)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.

FIND FacCPedi WHERE ROWID(FacCPedi) = X-ROWID NO-LOCK NO-ERROR.

IF NOT AVAILABLE FacCPedi THEN RETURN.

IF FacCPedi.CodDoc = "PED" THEN 
     C-TitDoc = "    PEDIDO :". 
ELSE C-TitDoc = "COTIZACION :". 

IF FacCpedi.Codmon = 2 THEN C-Moneda = "DOLARES US$.".
ELSE C-Moneda = "SOLES   S/. ".

C-NomVen = FacCPedi.CodVen.
C-NomCon = FacCPedi.FmaPgo.
XD       = STRING (FacCpedi.Fchven - FacCpedi.Fchped,"99").

IF FacCpedi.FlgIgv THEN DO:
   X-IMPIGV = "LOS PRECIOS INCLUYEN EL I.G.V.".
   F-ImpTot = FacCPedi.ImpTot.
END.
ELSE DO:
   X-IMPIGV = "LOS PRECIOS NO INCLUYEN EL IGV.".
   F-ImpTot = FacCPedi.ImpVta.
END.  

FIND gn-clie WHERE 
     gn-clie.codcia = CL-CODCIA AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
     
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.

FIND Almacen WHERE 
     Almacen.CodCia = S-CODCIA AND  
     Almacen.CodAlm = ENTRY (1, S-CODALM)
     NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN  W-DIRALM = Almacen.DirAlm. 
W-TLFALM = Almacen.TelAlm. 
/************************  PUNTEROS EN POSICION  *******************************/
/*RUN bin/_numero(FacCPedi.imptot, 2, 1, OUTPUT X-EnLetras).*/
RUN bin/_numero(F-IMPTOT, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

DEFINE FRAME F-DetaCot
    I-NroItm FORMAT ">>>9"
    FacDPedi.codmat FORMAT "X(6)"
    FacDPedi.CanPed FORMAT ">>>,>>9.99"
    FacDPedi.undvta FORMAT "X(4)"
    almmmatg.desmat FORMAT "X(45)"
    almmmatg.desmar FORMAT "X(11)"
    F-PreUni FORMAT "->,>>>,>>9.9999"
    FacDPedi.PorDto FORMAT "->>9.99 %"
    F-ImpLin FORMAT "->,>>>,>>9.9999" 
    almmmate.CodUbi SKIP
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.


DEFINE VARIABLE C-OBS AS CHAR EXTENT 2.
DEFINE VARIABLE K AS INTEGER.
IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
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
/* Definimos impresoras */
/*RUN aderb/_prlist.p(
 *     OUTPUT s-printer-list,
 *     OUTPUT s-port-list,
 *     OUTPUT s-printer-count).
 * 
 *  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
 *  s-port-name = REPLACE(S-PORT-NAME, ":", "").*/

DEF VAR rpta AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

DEFINE VARIABLE X-ORDCOM AS CHARACTER FORMAT "X(18)".

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".
    

C-OBS[1] = '- LOS PRECIOS INCLUYEN IGV'.
C-OBS[2] = '- GARANTIZAMOS NUESTROS PRODUCTOS CON CERTIFICADOS DE CALIDAD'.

DEFINE FRAME F-FtrCot
    HEADER
    X-EnLetras   FORMAT "x(100)" SKIP 
    "  DTO.GLOBAL :" AT 70 FacCPedi.ImpDto FORMAT '->>>,>>9.99' SKIP
    "NETO A PAGAR : "  AT 70  FORMAT "x(20)" 
    SUBSTRING(C-MONEDA,9,4)   FORMAT "X(10)" 
    STRING(F-ImpTot,">>,>>>,>>9.99")  FORMAT "x(20)" SKIP    
    "OBSERVACIONES : "  FORMAT "x(20)" SKIP 
    FacCPedi.Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
    "--------------------------------------------------" SKIP
    C-OBS[1] VIEW-AS TEXT FORMAT "X(315)"  SKIP 
    C-OBS[2] VIEW-AS TEXT FORMAT "X(315)"  SKIP 
    "--------------------------------------------------                            ------------------- " SKIP
    "                                                                              VoBo Jefe de Ventas " SKIP
    "HORA : " AT 1 STRING(TIME,"HH:MM:SS") "  " S-USER-ID SKIP  
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 360.
    

DEFINE FRAME F-HdrPed
    HEADER 
    skip(4)
    "Page:" AT 110 PAGE-NUMBER FORMAT ">>9" skip
    S-NOMCIA FORMAT "X(45)" SKIP
    W-DIRALM  at 1 FORMAT "x(55)" 
    W-TLFALM  at 60 FORMAt "x(65)" SKIP
    C-TitDoc  AT 80 FORMAT "X(22)" 
    FacCPedi.NroPed AT 102 FORMAT "XXX-XXXXXX" SKIP
   
    "Señor(es) : " TO 25 C-Descli       FORMAT "x(40)" "Emision         : " TO 100 FacCPedi.FchPed SKIP
    "Direccion : " TO 25 Faccpedi.DirCli FORMAT "x(40)" "Entrega         : " TO 100 FacCPedi.FchEnt SKIP
    "R.U.C.    : " TO 25 Faccpedi.RucCli "Vencimiento     : " TO 100 FacCPedi.fchven FORMAT "99/99/9999" SKIP
    "<OFICINA> "   TO 6
    "Vendedor  : " TO 25 C-NomVen       X-ORDCOM TO 100 FacCPedi.ordcmp SKIP
    "Cond.Venta: " TO 25 C-NomCon       "Moneda          : " TO 100 C-Moneda        SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    "ITEM CODIGO   CANTIDAD UND.             D E S C R I P C I O N             M A R C A      PRECI_VTA     DSCTOS.    TOTAL NETO   " SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP

    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.
                         
/*OUTPUT  TO VALUE(s-port-name) PAGE-SIZE 48.*/
OUTPUT  TO PRINTER PAGE-SIZE 48.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     
              
DEF VAR x-PorDto AS DEC NO-UNDO.
I-NroItm = 0.
FOR EACH FacDPedi NO-LOCK WHERE 
         FacDPedi.CodCia = FacCPedi.CodCia AND  
         FacDPedi.CodDoc = FacCPedi.CodDoc AND  
         FacDPedi.NroPed = FacCPedi.NroPed, 
         FIRST almmmatg OF FacDPedi NO-LOCK
         BREAK BY FacDPedi.NroItm:
    VIEW  FRAME F-HdrPed.

    I-NroItm = I-NroItm + 1.
    F-PreNet = FacDPedi.preuni * ( 1 - FacDPedi.PorDto / 100 ).
    x-dscto = 0.

    IF FacCpedi.FlgIgv THEN DO:
       F-PreUni = FacDPedi.PreUni.
       F-ImpLin = FacDPedi.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).
       F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
    END.  
    x-PorDto = ( 1 -  ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                ( 1 - Facdpedi.Por_Dsctos[3] / 100 ) ) * 100.
    DISPLAY  
            I-NroItm  
            FacDPedi.codmat
            FacDPedi.CanPed
            FacDPedi.undvta
            almmmatg.desmat
            almmmatg.desmar
            F-PreUni
            x-PorDto WHEN x-PorDto > 0 @ FacDPedi.PorDto
            F-ImpLin 
            WITH FRAME F-DetaCot.  
END.
VIEW  FRAME F-FtrCot.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


