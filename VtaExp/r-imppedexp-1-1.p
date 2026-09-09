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

DEF TEMP-TABLE DETA LIKE FacDPedi
    FIELD Clave AS CHAR
    INDEX Llave01 Clave NroItm.
DEF TEMP-TABLE DDOCU LIKE Ccbddocu.
DEF TEMP-TABLE T-PROM LIKE Expcprom.
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

FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
                  AND  Almacen.CodAlm = S-CODALM 
                  NO-LOCK NO-ERROR.
IF AVAILABLE Almacen 
THEN ASSIGN
    W-DIRALM = Almacen.DirAlm
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
         HEIGHT             = 4.35
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
    DEFINE FRAME F-HdrPed
        HEADER 
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        "( " + FacCPedi.CodDiv + ")" AT 1 W-DIRALM AT 10 
        {&PRN7A} + {&PRN6A} + C-TitDoc + {&PRN6B} + {&PRN7B} + {&PRN3} AT 82 FORMAT "X(22)" 
        {&PRN7A} + {&PRN6A} + FacCPedi.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 104 FORMAT "XXXXXX-XXXXXXXXXXXX" SKIP
        "TELEFAX. " AT 2 W-TLFALM AT 11  "Señor(es) : " TO 40 faccpedi.nomcli FORMAT "x(50)" SKIP 
        "Direccion : " TO 40 faccpedi.DirCli FORMAT "x(40)" "Emision         : " TO 100 FacCPedi.FchPed SKIP
        "R.U.C.    : " TO 40 faccpedi.Ruc    "Vencimiento     : " TO 100 FacCPedi.fchven FORMAT "99/99/9999" SKIP
        "<< OFICINA >> " TO 100
        "Vendedor  : " TO 40 C-NomVen       X-ORDCOM TO 100 FacCPedi.ordcmp SKIP
        "Cond.Venta: " TO 40 C-NomCon       "Moneda          : " TO 100 C-Moneda        SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "ITEM CODIGO  CANTIDAD UND.             D E S C R I P C I O N             M A R C A    PRECI_VTA  DSCTO  TOTAL NETO UBIC.  BULTOS         " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------" SKIP
    /*
         >>>9 123456 >>,>>9.99 1234 123456789012345678901234567890123456789012345 12345678901 >,>>9.9999 >>9.99% >>>,>>9.99 123456 123456789012345
    */
        WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.
    
    DEFINE FRAME F-DetaPed
        DETA.NroItm  FORMAT ">>>9"
        DETA.codmat  FORMAT "X(6)"
        DETA.CanPed  FORMAT ">>,>>9.99"
        DETA.undvta  FORMAT "X(4)"
        Almmmatg.desmat FORMAT "X(45)"
        Almmmatg.desmar FORMAT "X(11)"    
        DETA.preuni FORMAT ">,>>9.9999" 
        DETA.PorDto FORMAT ">>9.99%" 
        DETA.implin FORMAT ">>>,>>9.99"
        almmmate.codubi FORMAT "X(6)" 
        x-Bultos FORMAT 'x(15)' SKIP
        WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.
    
    /* DETERMINAMOS EL FRAM DE PIE DE PAGINA */
    ASSIGN
        X-TRANS = FACCPEDI.Libre_c01
        X-DIREC = FACCPEDI.Libre_c02
        X-LUGAR = FACCPEDI.Libre_c03
        X-CONTC = FACCPEDI.Libre_c04
        X-HORA  = FACCPEDI.Libre_c05
        X-FECHA = FACCPEDI.Libre_f01.
    FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
        AND gn-prov.CodPro = X-TRANS 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov 
        THEN  ASSIGN 
                  X-Nombre = gn-prov.NomPro
                  X-ruc    = gn-prov.Ruc.
    DEFINE FRAME F-FtrPed-1
        HEADER
        X-EnLetras AT 10 SKIP
        " DTO. GLOBAL : " TO 102 FacCPedi.PorDto FORMAT ">>9.99" "%" SKIP
        "NETO A PAGAR : " TO 102 SUBSTRING(C-MONEDA,9,4) FacCPedi.imptot FORMAT ">>,>>>,>>9.99" SKIP
        'PRIMER TRAMO  : ' 
        'SEGUNDO TRAMO  : ' AT 80 SKIP
        'Transport: ' X-Nombre FORMAT 'X(50)'
        'Destino  : ' AT 80  X-LUGAR  FORMAT 'X(50)' SKIP
        'RUC      : ' X-ruc    FORMAT 'X(11)'
        'Contacto : ' AT 80 X-CONTC FORMAT 'X(35)'  SKIP
        'Dirección: ' X-DIREC  FORMAT 'X(50)'
        'Hora Aten :' AT 80 X-HORA FORMAT 'X(10)' 'Fecha Entrega :' X-FECHA SKIP
        "OBSERVACIONES : " FacCPedi.Observa VIEW-AS TEXT FORMAT "X(80)" SKIP
        "GLOSA         : " FacCPedi.Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
        "                                                  " SKIP
        "                                                  " SKIP
        "                                                  " SKIP
        "                                                  " SKIP
        "                                                      -------------------     -------------------    -------------------" SKIP
        "                                                          Operador(a)         VoBo Jefe de Ventas       VoBo Cta.Cte.   " SKIP
        "HORA : " AT 1 STRING(TIME,"HH:MM")  S-USER-ID TO 67 SKIP 
        WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.
    
/* CARGA TEMPORALES */
RUN Carga-Detalle.
RUN Carga-Promociones.
/* **************** */
OUTPUT TO PRINTER PAGE-SIZE 62.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     

    FOR EACH DETA, FIRST Almmmatg OF DETA NO-LOCK, 
        FIRST almmmate WHERE almmmate.codcia = DETA.codcia
            AND almmmate.codalm = DETA.almdes
            AND almmmate.codmat = DETA.codmat
        BREAK BY DETA.CodCia BY DETA.Clave BY DETA.NroItm:
        VIEW FRAME F-HdrPed.
        VIEW FRAME F-FtrPed-1.
        x-dscto = 0.
        x-bultos = ''.
        IF DETA.undvta = Almmmatg.UndA THEN 
            x-dscto = Almmmatg.dsctos[1]. ELSE 
        IF DETA.undvta = Almmmatg.UndB THEN
            x-dscto = Almmmatg.dsctos[2]. ELSE 
        IF DETA.undvta = Almmmatg.UndC THEN
            x-dscto = Almmmatg.dsctos[3].
        IF Almmmatg.dec__03 > 0 AND Almmmatg.dec__03 < (DETA.canped * DETA.factor) THEN DO:
            x-Bultos = TRIM(STRING(TRUNCATE((DETA.canped * DETA.factor) / Almmmatg.dec__03, 0), '999') + ' PAQ').
            IF (DETA.canped * DETA.factor) MODULO Almmmatg.dec__03 > 0 THEN DO:
                x-Bultos = x-Bultos + ' y ' + TRIM(STRING((DETA.canped * DETA.factor) MODULO Almmmatg.dec__03, '999')) + ' ' + Almmmatg.undbas.
            END. 
        END.
        IF FIRST-OF(DETA.Clave) AND DETA.Clave = 'B'
        THEN DO:
            DOWN 2 WITH FRAME F-DetaPed.
            DISPLAY
                'PROMOCIONES' @ Almmmatg.desmat
                WITH FRAME F-DetaCot.
            UNDERLINE
                Almmmatg.desmat 
                WITH FRAME F-DetaPed.
        END.
        DISPLAY 
            DETA.NroItm  
            DETA.codmat
            DETA.CanPed
            DETA.undvta
            Almmmatg.desmat
            Almmmatg.desmar
            DETA.preuni             WHEN DETA.Clave = 'A'
            DETA.PorDto             WHEN DETA.Clave = 'A' @ DETA.PorDto 
            DETA.implin             WHEN DETA.Clave = 'A'
            almmmate.codubi
            x-Bultos
            WITH FRAME F-DetaPed.
        IF LAST-OF(DETA.CodCia) THEN DO:
            PAGE.
            HIDE FRAME F-FtrPed-1.
        END.
    END.
    OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Detalle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle Procedure 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR i-NroItm AS INT NO-UNDO.
DEF VAR x-pordto AS DEC NO-UNDO.

I-NroItm = 0.
FOR EACH FacDPedi OF FacCPedi NO-LOCK BY FacDPedi.CodMat:
    I-NroItm = I-NroItm + 1.
    CREATE DETA.
    BUFFER-COPY FacDPedi TO DETA
        ASSIGN 
            Deta.Clave = 'A'
            Deta.NroItm = i-NroItm.
    /* calculamos descuento */
    x-PorDto = ( 1 -  ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                 ( 1 - Facdpedi.Por_Dsctos[3] / 100 ) ) * 100.
    DETA.PorDto = x-pordto.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Promociones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Promociones Procedure 
PROCEDURE Carga-Promociones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {vtaexp/carga-promociones.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

