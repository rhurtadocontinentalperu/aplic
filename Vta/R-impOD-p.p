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
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR cl-CODCIA AS INTEGER.
DEF SHARED VAR s-codalm  AS CHAR.
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
DEF        VAR F-Pesmat AS DECIMAL NO-UNDO.
DEF        VAR lKits    AS LOGICAL NO-UNDO.
DEF        VAR cDesMat  LIKE almmmatg.desmat NO-UNDO.

/*Verificar si le pertenece un Kits*/
DEFINE TEMP-TABLE t-kits
    FIELDS t-codmat     LIKE almmmatg.codmat
    FIELDS t-codmat2    LIKE almmmatg.codmat
    FIELDS t-cantidad   AS DECIMAL.

DEFINE BUFFER b-almmmatg FOR almmmatg.

DEF VAR X-Glosa    AS CHAR VIEW-AS EDITOR SIZE 60 BY 2.
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR X-desmat   AS CHAR NO-UNDO.
DEF VAR X-ubi   AS CHAR NO-UNDO.
DEF VAR X-Lugent   AS CHAR NO-UNDO.

FIND FacCPedi WHERE ROWID(FacCPedi) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN.

C-TitDoc = "C O T I Z A C I O N". 
                
IF FacCpedi.Codmon = 2 THEN C-Moneda = "DOLARES US$.".
ELSE C-Moneda = "SOLES   S/. ".

C-NomVen = FacCPedi.CodVen.
C-NomCon = FacCPedi.FmaPgo.
XD       = STRING (FacCpedi.Fchven - FacCpedi.Fchped,"99").

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
              AND  Almacen.CodAlm = FacCPedi.codalm 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN              
   ASSIGN 
        W-DIRALM = Almacen.DirAlm
        W-TLFALM = Almacen.TelAlm. 

DEFINE VAR I         AS INTEGER NO-UNDO.
DEFINE VAR I-control AS INTEGER NO-UNDO.
DEFINE VAR I-Nombre  AS CHAR    NO-UNDO.
DEFINE VAR I-fecha   AS CHAR    NO-UNDO.
DEFINE VAR I-mes     AS CHAR    NO-UNDO.

IF NUM-ENTRIES(FacCpedi.Observa) > 0  THEN DO:
   IF LENGTH(ENTRY(NUM-ENTRIES(FacCPedi.Observa),FacCPedi.Observa)) > 1 THEN
      I-Nombre = ENTRY(NUM-ENTRIES(FacCPedi.Observa),FacCPedi.Observa).
END.

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(FacCPedi.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

DEFINE FRAME F-DetaOD
    I-NroItm FORMAT ">>9"
    FacDPedi.codmat FORMAT "X(6)"
    X-desmat FORMAT "X(50)"
    Almmmatg.Desmar FORMAT "x(10)"
    FacDPedi.undvta  FORMAT "X(4)"
    FacDPedi.CanPed  FORMAT ">>>,>>9.99"
    FacDpedi.Codmat FORMAT "x(6)"
    Almmmate.codubi FORMAT "x(6)"
    /*FacDPedi.Pesmat FORMAT ">>>>,>>9.99"*/
       WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

DEFINE FRAME F-FtrOD
    HEADER
    "-----------------------------------------------------------------------------------------------" SKIP
    'PTO.PARTIDA : '  AT 2 W-DIRALM FORMAT 'X(60)' SKIP
    'PTO.LLEGADA : ' AT 2 FacCPedi.LugEnt FORMAT 'X(60)' SKIP
    x-lugent   AT 2 FORMAT 'X(60)' SKIP
    S-USER-ID  AT 2 STRING(TIME,"HH:MM:SS") AT 30 SKIP
    'IMPORTE:' AT 2 Faccpedi.ImpTot FORMAT '(ZZZ,ZZZ,ZZ9.99)' SKIP
    "-----------------------------------------------------------------------------------------------" 

    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.

DEFINE FRAME F-Detalle
    t-codmat2
    cDesMat    
    t-cantidad
       WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

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

DEF VAR rpta AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

x-lugent = ''.
lKits    = NO.
IF FacCPedi.Lugent2  <> '' THEN DO:
   x-lugent = 'PTO.LLEGADA - 2:' + FacCPedi.lugent2.
END.

/*Borra Temporal de Kits*/
FOR EACH t-kits:
    DELETE t-kits.
END.

I-fecha = 'LIMA, ' + STRING(DAY(FacCPedi.FchPed),'99') + ' DE ' + I-mes + ' DE ' + STRING(YEAR(FacCPedi.FchPed),'9999').

DEFINE FRAME F-HdrOD
    HEADER 
    {&PRN2} + {&PRN7A} + {&PRN6A} + 'ORDEN DE DESPACHO' + {&PRN6B} + {&PRN7B} + {&PRN2} AT 20 FORMAT "X(30)" 
    {&PRN2} + {&PRN7A} + {&PRN6A}  + 'No : ' AT 55 FacCPedi.NroPed + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "XXX-XXXXXX" SKIP(1)

    "FECHA     : " FacCPedi.Fchped  
    "PEDIDO    : " AT 70 FacCPedi.NroRef FORMAT 'XXX-XXXXXX' SKIP
    "CLIENTE   : " FacCPedi.nomcli FORMAT "x(45)" SKIP
    "O/COMPRA  : " AT 70 FacCPedi.OrdCmp SKIP
    "DIRECCION : " FacCPedi.Dircli FORMAT "x(60)" SKIP 
    "RUC       : " FacCPedi.Ruccli FORMAT "x(11)" 
    "FCH VENC. : " AT 70 FacCPedi.FchVen AT 85 SKIP
    "ATENCION  : " FacCPedi.Atencion FORMAT "x(30)" 
    "HORA      : " AT 70 FacCPedi.Hora AT 85 FORMAT "x(10)"  SKIP
    "GLOSA     : " FaccPedi.Glosa VIEW-AS TEXT FORMAT "X(50)"
    "USUARIO   : " AT 70 FacCPedi.Usuario AT 85 FORMAT "x(10)" SKIP
    "-----------------------------------------------------------------------------------------------" SKIP
    "ITEM CODIGO   D E S C R I P C I O N                          MARCA       UND   CANTIDAD   ZONA " SKIP
    "-----------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.
    
OUTPUT TO PRINTER PAGE-SIZE 60.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN2}.     
I-NroItm = 0.
          FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = FacCPedi.CodCia 
                                     AND  FacDPedi.CodDoc = FacCPedi.CodDoc 
                                     AND  FacDPedi.NroPed = FacCPedi.NroPed,

              First almmmatg OF FacDPedi NO-LOCK, 
              FIRST Almmmate WHERE almmmate.codcia = facdpedi.codcia
                                AND almmmate.codmat = facdpedi.codmat
                                AND almmmate.codalm = facdpedi.almdes NO-LOCK BREAK BY FacDPedi.NroPed
                                          BY FacDPedi.CodMat:
                                          
              I-NroItm = I-NroItm + 1.
              RUN bin/_numero(FacDPedi.canped, 2, 1, OUTPUT X-EnLetras). 
              X-EnLetras = REPLACE(X-EnLetras, "CON 00/100", '').
              x-desmat =  Almmmatg.desmat.
              VIEW FRAME F-HdrOD.
              VIEW FRAME F-FtrOD.
              
              DISPLAY I-NroItm  
                      FacDPedi.codmat  
                      x-desmat
                      Almmmatg.Desmar FORMAT "x(10)"
                      FacDPedi.undvta
                      FacDPedi.CanPed  
                      Almmmate.codubi
                     WITH FRAME F-DetaOD.
              /*Verificando si le corresponde algun Kits*/
/*               FIND FIRST AlmCKits WHERE AlmCKits.CodCia = FacDPedi.CodCia       */
/*                   AND AlmCKits.CodMat = FacDPedi.CodMat NO-LOCK NO-ERROR.       */
/*               IF AVAIL AlmCKits THEN DO:                                        */
/*                   FOR EACH AlmDKits WHERE AlmCKits.CodCia = AlmDKits.CodCia     */
/*                       AND AlmCKits.CodMat = AlmDKits.CodMat NO-LOCK:            */
/*                       FIND FIRST t-kits WHERE t-codmat = AlmDKits.CodMat        */
/*                           AND t-codmat2 = AlmDKits.CodMat2 NO-LOCK NO-ERROR.    */
/*                       IF NOT AVAIL t-kits THEN DO:                              */
/*                           CREATE t-kits.                                        */
/*                           ASSIGN                                                */
/*                               t-codmat   = AlmCKits.CodMat                      */
/*                               t-codmat2  = AlmDKits.CodMat2                     */
/*                               t-cantidad = AlmDKits.Cantidad * FacDPedi.CanPed. */
/*                           lKits = YES.                                          */
/*                       END.                                                      */
/*                   END.                                                          */
/*               END.                                                              */
              IF LAST-OF(FacDPedi.NroPed) THEN DO:
                  IF lKits THEN DO:
                      DISPLAY '*********  KITS PROMOCIONALES  *********'.
                      FOR EACH t-kits:                                  
                          FIND FIRST b-almmmatg WHERE b-almmmatg.codcia = s-CodCia
                              AND b-almmmatg.codmat = t-codmat2 NO-LOCK NO-ERROR.
                          IF AVAIL b-almmmatg THEN cDesMat = b-almmmatg.DesMat.
                          DISPLAY
                              t-codmat2
                              cDesMat
                              t-cantidad
                              WITH FRAME F-Detalle.
                      END.
                  END.                      
                 PAGE.
              END.
          END.
          
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


