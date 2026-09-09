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
DEF SHARED VAR PV-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter LIKE ccbcterm.codter.
DEF SHARED VAR S-NomCia AS CHAR.
DEF        VAR C-NomVen AS CHAR FORMAT "X(30)".
DEF        VAR C-Moneda AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF        VAR C-TitDoc AS CHAR FORMAT "X(50)".
DEF        VAR I-NroItm AS INTEGER.
DEF        VAR F-PreNet AS DECIMAL.
DEF        VAR W-DIRALM AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM AS CHAR FORMAT "X(13)".
DEF        VAR X-Nombre LIKE gn-prov.NomPro.
DEF        VAR X-ruc    LIKE gn-prov.Ruc.
DEF        VAR X-TRANS  LIKE FACCPEDI.Libre_c01.
DEF        VAR X-DIREC  LIKE FACCPEDI.Libre_c02.
DEF        VAR X-LUGAR  LIKE FACCPEDI.Libre_c03.
DEF        VAR X-CONTC  LIKE FACCPEDI.Libre_c04.
DEF        VAR X-HORA   LIKE FACCPEDI.Libre_c05.
DEF        VAR X-FECHA  LIKE FACCPEDI.Libre_f01.
DEF        VAR X-OBSER  LIKE FACCPEDI.Observa.

DEFINE VARIABLE x-dscto AS DECIMAL.
/*DEFINE VARIABLE x-Bultos AS DECIMAL.*/
DEFINE VARIABLE x-Bultos AS CHAR FORMAT "X(10)".

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

IF AVAILABLE FACCPEDI THEN DO: 
           X-TRANS = FACCPEDI.Libre_c01.
           X-DIREC = FACCPEDI.Libre_c02.
           X-LUGAR = FACCPEDI.Libre_c03.
           X-CONTC = FACCPEDI.Libre_c04.
           X-HORA  = FACCPEDI.Libre_c05.
           X-FECHA = FACCPEDI.Libre_f01.
           X-OBSER = FACCPEDI.Observa.
END.
FIND gn-prov WHERE 
          gn-prov.CodCia = PV-CODCIA AND
          gn-prov.CodPro = X-TRANS 
          NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN                                     
          ASSIGN 
              X-Nombre = gn-prov.NomPro
              X-ruc    = gn-prov.Ruc.
FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
              AND  Almacen.CodAlm = S-CODALM 
              NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN
    W-DIRALM = Almacen.DirAlm. 
W-TLFALM = Almacen.TelAlm. 




/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(FacCPedi.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

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
DEF VAR x-Ok AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
IF x-Ok = NO THEN RETURN.
  
DEFINE VARIABLE X-ORDCOM AS CHARACTER FORMAT "X(18)".

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".
/************************  DEFINICION DE FRAMES  *******************************/

DEFINE FRAME F-DetaPed
    I-NroItm FORMAT ">>>9"
    FacDPedi.codmat FORMAT "X(6)"
    FacDPedi.CanPed FORMAT ">>,>>9.99"
    FacDPedi.undvta FORMAT "X(4)"
    almmmatg.desmat FORMAT "X(45)"
    almmmatg.desmar FORMAT "X(11)"    
    FacDPedi.preuni FORMAT ">,>>9.9999" 
    FacDPedi.PorDto FORMAT ">>9.99%" 
    FacDPedi.implin FORMAT ">>>,>>9.99"
    almmmate.codubi FORMAT "X(6)" 
    x-Bultos        FORMAT 'x(15)' SKIP
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

DEFINE FRAME F-FtrPed
    HEADER
    X-EnLetras AT 10 SKIP
    " DTO. GLOBAL : " TO 102 FacCPedi.PorDto FORMAT ">>9.99" "%" SKIP
    "NETO A PAGAR : " TO 102 SUBSTRING(C-MONEDA,9,4) FacCPedi.imptot FORMAT ">>,>>>,>>9.99" SKIP(1)
    'PRIMER TRAMO  : '     SKIP
    'Transport: ' X-Nombre FORMAT 'X(50)' SKIP
    'RUC      : ' X-ruc    FORMAT 'X(11)' SKIP
    'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP
    'SEGUNDO TRAMO  : '    SKIP
    'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP
    'Contacto : ' X-CONTC FORMAT 'X(35)' 'Hora Aten :' X-HORA FORMAT 'X(10)' 'Fecha Entrega :' X-FECHA SKIP
    "OBSERVACIONES : " FacCPedi.Observa VIEW-AS TEXT FORMAT "X(80)" SKIP
    "GLOSA         : " FacCPedi.Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
    "                                                  " SKIP
    "                                                  " SKIP
    "                                                  " SKIP
    "                                                  " SKIP
    "                                                  " SKIP
    "                                                      -------------------     -------------------    -------------------" SKIP
    "                                                          Operador(a)         VoBo Jefe de Ventas       VoBo Cta.Cte.   " SKIP
    "HORA : " TO 1 STRING(TIME,"HH:MM")  S-USER-ID TO 67 SKIP 
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.

DEFINE FRAME F-HdrPed
    HEADER 
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
    "( " + FacCPedi.CodDiv + ")" AT 1 W-DIRALM AT 10 
    {&PRN7A} + {&PRN6A} + C-TitDoc + {&PRN6B} + {&PRN7B} + {&PRN3} AT 82 FORMAT "X(22)" 
    {&PRN7A} + {&PRN6A} + FacCPedi.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 104 FORMAT "XXXXXX-XXXXXXXXXXXX" SKIP
    "TELEFAX. " AT 2 W-TLFALM AT 11  "Señor(es) : " TO 40 faccpedi.nomcli FORMAT "x(50)" SKIP 
    "Direccion : " TO 40 faccpedi.DirCli FORMAT "x(40)" "Emision         : " TO 100 FacCPedi.FchPed SKIP
    "R.U.C.    : " TO 40 faccpedi.Ruc    "Vencimiento     : " TO 100 FacCPedi.fchven FORMAT "99/99/9999" SKIP
    "<< OFICINA >> " TO 6
    "Vendedor  : " TO 40 C-NomVen       X-ORDCOM TO 100 FacCPedi.ordcmp SKIP
    "Cond.Venta: " TO 40 C-NomCon       "Moneda          : " TO 100 C-Moneda        SKIP
    "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "ITEM CODIGO  CANTIDAD UND.             D E S C R I P C I O N             M A R C A    PRECI_VTA  DSCTO  TOTAL NETO UBIC.  BULTOS         " SKIP
    "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
     >>>9 123456 >>,>>9.99 1234 123456789012345678901234567890123456789012345 12345678901 >,>>9.9999 >>9.99% >>>,>>9.99 123456 123456789012345
*/
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.


OUTPUT TO PRINTER PAGE-SIZE 62.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     

I-NroItm = 0.
CASE FacCPedi.coddoc:
     WHEN "PED" THEN DO:
          FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = FacCPedi.CodCia 
                                     AND  FacDPedi.CodDoc = FacCPedi.CodDoc 
                                     AND  FacDPedi.NroPed = FacCPedi.NroPed , 
                FIRST almmmatg OF FacDPedi NO-LOCK,
                FIRST almmmate WHERE almmmate.codcia = facdpedi.codcia
                    AND almmmate.codalm = facdpedi.almdes
                    AND almmmate.codmat = facdpedi.codmat
                BREAK BY FacDPedi.NroPed
                BY FacDPedi.CodMat:
              I-NroItm = I-NroItm + 1.
              F-PreNet = FacDPedi.preuni * ( 1 - FacDPedi.PorDto / 100 ).
              VIEW FRAME F-HdrPed.
              VIEW FRAME F-FtrPed.

            x-dscto = 0.
            x-bultos = ''.
            IF FacDPedi.undvta = Almmmatg.UndA THEN 
                x-dscto = Almmmatg.dsctos[1]. ELSE 
            IF FacDPedi.undvta = Almmmatg.UndB THEN
                x-dscto = Almmmatg.dsctos[2]. ELSE 
            IF FacDPedi.undvta = Almmmatg.UndC THEN
                x-dscto = Almmmatg.dsctos[3].
            IF Almmmatg.dec__03 > 0 AND Almmmatg.dec__03 < (Facdpedi.canped * Facdpedi.factor) THEN DO:
                x-Bultos = TRIM(STRING(TRUNCATE((Facdpedi.canped * Facdpedi.factor) / Almmmatg.dec__03, 0), '999') + ' PAQ').
                IF (Facdpedi.canped * Facdpedi.factor) MODULO Almmmatg.dec__03 > 0 THEN DO:
                    x-Bultos = x-Bultos + ' y ' + TRIM(STRING((Facdpedi.canped * Facdpedi.factor) MODULO Almmmatg.dec__03, '999')) + ' ' + Almmmatg.undbas.
                END. 
            END.
            DISPLAY I-NroItm
                      FacDPedi.codmat
                      FacDPedi.CanPed
                      FacDPedi.undvta
                      almmmatg.desmat
                      almmmatg.desmar
                      FacDPedi.preuni
                      FacDPedi.PorDto - x-dscto @ FacDPedi.PorDto
                      FacDPedi.implin
                      almmmate.codubi
                      x-Bultos
                      WITH FRAME F-DetaPed.
              IF LAST-OF(FacDPedi.NroPed) THEN DO:
                   PAGE.
              END.
          END.
     END.
END CASE.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


