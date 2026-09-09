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
DEFINE INPUT PARAMETER x-file AS CHARACTER.

DEF SHARED VARIABLE S-USER-ID  AS CHAR. 
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-CODCIA AS INTEGER.
DEF SHARED VAR s-codalm AS CHAR.
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

DEF        VAR F-PreUni  LIKE FacDPedi.Preuni.
DEF        VAR F-ImpLin  LIKE FacDPedi.ImpLin.
DEF        VAR F-ImpTot  LIKE FacCPedi.ImpTot.

DEFINE VARIABLE X-IMPIGV AS CHARACTER FORMAT "X(30)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.

FIND FacCPedi WHERE ROWID(FacCPedi) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN.

IF FacCPedi.CodDoc = "PED" THEN C-TitDoc = "    PEDIDO :". 
ELSE C-TitDoc = "COTIZACION :". 

IF FacCpedi.Codmon = 2 THEN C-Moneda = "DOLARES US$.".
ELSE C-Moneda = "SOLES   S/. ".

C-NomVen = FacCPedi.CodVen.
C-NomCon = FacCPedi.FmaPgo.
XD       = STRING (FacCpedi.Fchven - FacCpedi.Fchped,"99").
IF FacCpedi.FlgIgv THEN  
   ASSIGN 
   X-IMPIGV = "LOS PRECIOS INCLUYEN EL I.G.V."
   F-IMPTOT =  FacCPedi.ImpTot.
ELSE ASSIGN
   X-IMPIGV = "LOS PRECIOS NO INCLUYEN EL IGV."
   F-IMPTOT = FacCPedi.ImpVta.


FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
              AND  gn-clie.codcli = FacCPedi.codcli 
             NO-LOCK.

FIND gn-ven WHERE gn-ven.CodCia = FacCPedi.CodCia 
             AND  gn-ven.CodVen = FacCPedi.CodVen 
            NO-LOCK NO-ERROR.
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.

FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
              AND  Almacen.CodAlm = S-CODALM 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN
    W-DIRALM = Almacen.DirAlm. 
W-TLFALM = Almacen.TelAlm. 




/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(F-IMPTOT, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

DEFINE FRAME F-DetaPed
    I-NroItm FORMAT ">>>9"
    FacDPedi.codmat FORMAT "X(6)"
    FacDPedi.CanPed FORMAT ">>>,>>9.99"
    FacDPedi.undvta FORMAT "X(4)"
    almmmatg.desmat FORMAT "X(45)"
    almmmatg.desmar FORMAT "X(11)"    
    FacDPedi.preuni FORMAT ">>,>>9.99"
    FacDPedi.PorDto FORMAT ">9.99%" 
    F-PreNet        FORMAT ">>,>>9.99"
    FacDPedi.implin FORMAT ">,>>>,>>9.99" SKIP
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

DEFINE FRAME F-DetaCot
    I-NroItm FORMAT ">>>9"
    FacDPedi.codmat FORMAT "X(6)"
    FacDPedi.CanPed FORMAT ">>>,>>9.99"
    FacDPedi.undvta FORMAT "X(4)"
    almmmatg.desmat FORMAT "X(45)"
    almmmatg.desmar FORMAT "X(11)"
    FacDPedi.preuni FORMAT ">>,>>9.99"
    FacDPedi.PorDto FORMAT ">9.99 %"
    F-PreNet        FORMAT ">>,>>9.99"     
    FacDPedi.implin FORMAT ">,>>>,>>9.99" SKIP
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

DEFINE FRAME F-FtrPed
    HEADER
    X-EnLetras AT 10 SKIP
    "NETO A PAGAR : " TO 102 SUBSTRING(C-MONEDA,9,4) FacCPedi.imptot FORMAT ">>,>>>,>>9.99" SKIP(2)
    "OBSERVACIONES : " SKIP 
    FacCPedi.Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
/*    "Mercaderia viaja por cuenta y riesgo del cliente. " SKIP
 *     "--------------------------------------------------" SKIP
 *     "IMPUESTO          : LOS PRECIOS INCLUYEN EL I.G.V." SKIP
 *     "TIEMPO DE ENTREGA : INMEDIATO, DE ACUERDO A STOCK " SKIP
 *     "OFERTA VALIDA     : PROPUESTA VALIDA POR" XD "DIAS" SKIP*/
    "                                                  " SKIP
    "                                                  " SKIP
    "                                                  " SKIP
    "                                                  " SKIP
    "                                                  " SKIP
    "                                                      -------------------     -------------------    -------------------" SKIP
    "                                                          Operador(a)         VoBo Jefe de Ventas       VoBo Cta.Cte.   " SKIP
    "HORA : " TO 1 STRING(TIME,"HH:MM:SS")  S-USER-ID TO 67 SKIP 
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.

DEFINE FRAME F-FtrCot
    HEADER
    X-EnLetras AT 10 SKIP
    "NETO A PAGAR : " TO 102 SUBSTRING(C-MONEDA,9,4) FacCPedi.imptot FORMAT ">>,>>>,>>9.99" SKIP(2)
    "OBSERVACIONES : " SKIP 
    FacCPedi.Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
    "Mercaderia viaja por cuenta y riesgo del cliente. " SKIP
    "--------------------------------------------------" SKIP
    FacCPedi.Observa VIEW-AS TEXT FORMAT "X(150)" SKIP /*EDITOR 
    INNER-CHARS 40 INNER-LINES 3 */
/*    "IMPUESTO          :" X-IMPIGV SKIP
 *     "TIEMPO DE ENTREGA : INMEDIATO, DE ACUERDO A STOCK " SKIP
 *     "OFERTA VALIDA     : PROPUESTA VALIDA POR" XD "DIAS" SKIP */
    "--------------------------------------------------    -------------------     ------------------- " SKIP
    "                                                          Operador(a)         VoBo Jefe de Ventas " SKIP
    "HORA : " AT 1 STRING(TIME,"HH:MM:SS") S-USER-ID AT 67 SKIP  
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

def var cotfile as char init "".

cotfile = FacCPedi.coddoc + "-" + SUBSTRING(FacCPedi.NroPed,1,3) + "-" + SUBSTRING(FacCPedi.NroPed,4,7) + ".txt".

message skip
        "Vuestra Cotización ha sido guardado en la carpeta   C:\mis documentos\" + "        " skip
        /*SESSION:TEMP-DIRECTORY skip*/
        "con el nombre de archivo                                         "cotfile + "        " skip
        "NOTA: Para abrir el archivo en Excel utilize el delimitador | ó ALT+124" skip(2)
        "                                                           División de Sistemas 20/07/2000"
        view-as alert-box information 
        title cotfile.

x-file = "C:\mis documentos\" + 
         cotfile.


/*RUN aderb/_prlist.p(
 *     OUTPUT s-printer-list,
 *     OUTPUT s-port-list,
 *     OUTPUT s-printer-count).*/

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = FacCPedi.coddoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(FacCPedi.NroPed,1,3))  
              NO-LOCK.
  
/*IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
 *    MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
 *    RETURN ERROR.
 * END.*/

/*s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
 * s-port-name = REPLACE(S-PORT-NAME, ":", "").*/

DEFINE VARIABLE X-ORDCOM AS CHARACTER FORMAT "X(18)".

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Orden de Requeri: ".

DEFINE FRAME F-HdrPed
    HEADER 
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
    "( " + FacCPedi.CodDiv + ")" AT 1 W-DIRALM AT 10
    {&PRN7A} + {&PRN6A} + C-TitDoc + {&PRN6B} + {&PRN7B} + {&PRN3} AT 82 FORMAT "X(22)" 
    {&PRN7A} + {&PRN6A} + FacCPedi.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 104 FORMAT "XXXXXX-XXXXXXXXXXXX" SKIP
    "TELEFAX. " AT 2 W-TLFALM AT 11  "Señor(es) : " TO 40 gn-clie.nomcli FORMAT "x(50)" SKIP 
    "Direccion : " TO 40 gn-clie.DirCli FORMAT "x(40)" "Emision         : " TO 100 FacCPedi.FchPed SKIP
    "R.U.C.    : " TO 40 gn-clie.Ruc    "Vencimiento     : " TO 100 FacCPedi.fchven FORMAT "99/99/9999" SKIP
    "<< OFICINA >> " TO 6
    "Vendedor  : " TO 40 C-NomVen       X-ORDCOM TO 100 FacCPedi.ordcmp SKIP
    "Cond.Venta: " TO 40 C-NomCon       "Moneda          : " TO 100 C-Moneda        SKIP
    "------------------------------------------------------------------------------------------------------------------------------" SKIP
    "ITEM CODIGO   CANTIDAD UND.             D E S C R I P C I O N             M A R C A    Pr.LISTA  DSCTO   Pr. UNIT   TOTAL NETO" SKIP
    "------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.


/*OUTPUT TO VALUE(s-port-name) PAGE-SIZE 62.
 * PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     */

OUTPUT STREAM REPORT TO VALUE(x-file) PAGE-SIZE 62.

I-NroItm = 0.
CASE FacCPedi.coddoc:
     WHEN "PED" THEN DO:
/*          FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = FacCPedi.CodCia 
 *                                      AND  FacDPedi.CodDoc = FacCPedi.CodDoc 
 *                                      AND  FacDPedi.NroPed = FacCPedi.NroPed , 
 *               FIRST almmmatg OF FacDPedi NO-LOCK 
 *                                     BREAK BY FacDPedi.NroPed
 *                                           BY FacDPedi.CodMat:
 *               I-NroItm = I-NroItm + 1.
 *               F-PreNet = FacDPedi.preuni * ( 1 - FacDPedi.PorDto / 100 ).
 *               VIEW FRAME F-HdrPed.
 *               VIEW FRAME F-FtrPed.
 *               DISPLAY I-NroItm
 *                       FacDPedi.codmat
 *                       FacDPedi.CanPed
 *                       FacDPedi.undvta
 *                       almmmatg.desmat
 *                       almmmatg.desmar
 *                       FacDPedi.preuni
 *                       FacDPedi.PorDto  WHEN (FacDPedi.PorDto > 0)
 *                       F-PreNet FacDPedi.implin WITH FRAME F-DetaPed.
 *               IF LAST-OF(FacDPedi.NroPed) THEN DO:
 *                    PAGE.
 *               END.
 *           END.*/
     END.
     WHEN "COT" THEN DO:

          PUT STREAM REPORT '"' S-NOMCIA FORMAT "X(45)" '"' SKIP.

          PUT STREAM REPORT '"("' FacCPedi.CodDiv '") |'.
          PUT STREAM REPORT '"' W-DIRALM '"|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '"' C-TitDoc '"|'.
          PUT STREAM REPORT '"' FacCPedi.NroPed FORMAT "XXXXXX-XXXXXXXXXXXX" '"' SKIP.
          
          PUT STREAM REPORT '"TELEFAX. "|'.
          PUT STREAM REPORT '"' W-TLFALM  '"|'.
          PUT STREAM REPORT '"Señor(es) : "|'.
          PUT STREAM REPORT '"' gn-clie.nomcli '"' SKIP .
          
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '"Direccion : "|'.
          PUT STREAM REPORT '"' gn-clie.DirCli '"|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '"Emision         : "|'.
          PUT STREAM REPORT '"' FacCPedi.FchPed FORMAT "99/99/9999" '"' SKIP.
          
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '"R.U.C.    : "|'.
          PUT STREAM REPORT '"' gn-clie.Ruc '"|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '"Vencimiento     : "|'.
          PUT STREAM REPORT '"' FacCPedi.fchven FORMAT "99/99/9999" '"' SKIP.
          
/*          PUT STREAM REPORT '""|'.
 *           PUT STREAM REPORT '""|'.
 *           PUT STREAM REPORT '"Vendedor  : "|'.
 *           PUT STREAM REPORT '"' C-NomVen       X-ORDCOM TO 100 FacCPedi.ordcmp SKIP*/

          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '"Cond.Venta: "|'.
          PUT STREAM REPORT '"' C-NomCon  '"|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '"Moneda          : "|'.
          PUT STREAM REPORT '"' C-Moneda '"' SKIP(3).
          

          PUT STREAM REPORT '"ITEM"|'.
          PUT STREAM REPORT '"CODIGO"|'.
          PUT STREAM REPORT '"DESCRIPCION"|'.
          PUT STREAM REPORT '"MARCA"|'.
          PUT STREAM REPORT '"CANTIDAD"|'.
          PUT STREAM REPORT '"U/M"|'.
          PUT STREAM REPORT '"PR.LISTA"|'.
          PUT STREAM REPORT '"%DSCTO"|'.
          PUT STREAM REPORT '"TOTAL NETO"' SKIP(2).

          FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = FacCPedi.CodCia 
                                     AND  FacDPedi.CodDoc = FacCPedi.CodDoc 
                                     AND  FacDPedi.NroPed = FacCPedi.NroPed , 
              FIRST almmmatg OF FacDPedi NO-LOCK
                                    BREAK BY FacDPedi.NroPed
                                          BY FacDPedi.NroItm:
              I-NroItm = I-NroItm + 1.
              F-PreNet = FacDPedi.preuni * ( 1 - FacDPedi.PorDto / 100 ).

              IF FacCpedi.FlgIgv THEN DO:
                   F-PreUni = FacDPedi.PreUni.
                   F-ImpLin = FacDPedi.ImpLin. 
              END.
              ELSE DO:
                   F-PreUni = ROUND(FacDPedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).
                   F-ImpLin = ROUND(FacDPedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
              END.  





/*              VIEW FRAME F-HdrPed.
 *               VIEW FRAME F-FtrCot.
 *               DISPLAY BY FacDPedi.NroItm  
 *                       FacDPedi.codmat
 *                       FacDPedi.CanPed
 *                       FacDPedi.undvta
 *                       almmmatg.desmat
 *                       almmmatg.desmar
 *                       FacDPedi.preuni
 *                       FacDPedi.PorDto  WHEN (FacDPedi.PorDto > 0)
 *                       F-PreNet FacDPedi.implin 
 *                       WITH FRAME F-DetaCot.*/

                PUT STREAM REPORT FacDPedi.NroItm '|'.
                PUT STREAM REPORT '"' FacDPedi.codmat '"|'.
                PUT STREAM REPORT '"' almmmatg.desmat '"|'.
                PUT STREAM REPORT '"' almmmatg.desmar '"|'.

                PUT STREAM REPORT FacDPedi.CanPed FORMAT "->>>>>>>>>9.99" '|'.
                PUT STREAM REPORT FacDPedi.undvta '|'.
                PUT STREAM REPORT F-preuni FORMAT "->>>>>>>>>9.9999" '|'.
               /* PUT STREAM REPORT FacDPedi.PorDto FORMAT "->>9.99" '|'.*/
                PUT STREAM REPORT 0.
                PUT STREAM REPORT F-implin FORMAT "->>>>>>>>>9.9999".
                PUT STREAM REPORT SKIP.

              IF LAST-OF(FacDPedi.NroPed) THEN DO:
                  PAGE.
              END.
          END.

          /**** iMPRIME EL PIE DE PAGINA    ****/
          PUT STREAM REPORT SKIP(3).
          PUT STREAM REPORT '"' X-EnLetras '"' SKIP.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '"TOTAL"|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '""|'.
          PUT STREAM REPORT '"' SUBSTRING(C-MONEDA,9,4) '"|'.
          PUT STREAM REPORT F-IMPTOT FORMAT "->>>>>>>>>9.9999" SKIP(3).

          PUT STREAM REPORT '"OBSERVACIONES : "' SKIP .
          PUT STREAM REPORT '"' FacCPedi.Glosa '"' FORMAT "X(80)" SKIP(1).
          PUT STREAM REPORT '"Mercaderia viaja por cuenta y riesgo del cliente."' SKIP.
          PUT STREAM REPORT '"-------------------------------------------------"' SKIP.
          PUT STREAM REPORT '"' FacCPedi.Observa '"' FORMAT "X(350)" SKIP.
          PUT STREAM REPORT '"-------------------------------------------------"' SKIP(3).
          PUT STREAM REPORT '"Atentamente"' SKIP(5).
          PUT STREAM REPORT '"LUIS GONZALES M."' SKIP.
          PUT STREAM REPORT '"Jefe de Ventas"' SKIP(5).

/*
    "                                                          Operador(a)         VoBo Jefe de Ventas " SKIP
    "HORA : " AT 1 STRING(TIME,"HH:MM:SS") S-USER-ID AT 67 SKIP  
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.
*/          
          /*************************************/
     END.
END CASE.

OUTPUT STREAM REPORT CLOSE.

/*
OUTPUT CLOSE.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


