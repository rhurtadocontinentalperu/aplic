&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-impgui.p
    Purpose     : Impresion de Guias

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
DEF SHARED VAR CL-codcia  AS INT.
DEF SHARED VAR PV-codcia  AS INT.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id LIKE ccbcterm.codter.
DEF SHARED VAR X-NUMORD  AS CHAR.
DEF SHARED VAR X-obser  AS CHAR format "x(80)".


DEF VAR C-DirCli AS CHAR FORMAT "X(70)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR C-NomVen AS CHAR FORMAT "X(21)".
DEF VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF VAR C-RucTra AS CHAR FORMAT "X(30)".
DEF VAR C-NomTra AS CHAR FORMAT "X(30)".
DEF VAR C-DirTra AS CHAR FORMAT "X(30)".
DEF VAR C-Marca  AS CHAR FORMAT "X(30)".
DEF VAR C-Placa  AS CHAR FORMAT "X(10)".
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-DEPART LIKE TabDepto.NomDepto.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-Nombre LIKE gn-prov.NomPro.
DEF VAR X-ruc    LIKE gn-prov.Ruc.
DEF VAR X-TRANS  LIKE FACCPEDI.Libre_c01.
DEF VAR X-DIREC  LIKE FACCPEDI.Libre_c02.
DEF VAR X-LUGAR  LIKE FACCPEDI.Libre_c03.
DEF VAR X-CONTC  LIKE FACCPEDI.Libre_c04.
DEF VAR X-HORA   LIKE FACCPEDI.Libre_c05.
DEF VAR X-FchRef LIKE ccbcdocu.fchdoc.
DEF VAR X-Lugent AS CHAR NO-UNDO.
DEFINE SHARED VARIABLE X-CTRANS  AS CHAR. 
DEFINE SHARED VARIABLE X-RTRANS  AS CHAR. 
DEFINE SHARED VARIABLE X-DTRANS  AS CHAR. 

DEFINE VAR dPesTot AS DEC NO-UNDO.

DEFINE BUFFER B-DOCU FOR ccbcdocu.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND B-DOCU WHERE B-DOCU.CODCIA = ccbcdocu.CodCia 
             AND  B-DOCU.CodDoc = ccbcdocu.CodRef 
             AND  B-DOCU.NroDoc = ccbcdocu.NroRef 
            NO-LOCK NO-ERROR.
IF AVAILABLE B-DOCU THEN X-FchRef = B-DOCU.FchDoc.
ELSE X-FchRef = ?.

FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA 
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK.
    
X-senal  = "X".
C-NomVen = CcbCDocu.CodVen.
C-NomCon = CcbCDocu.FmaPgo.
/*C-RucTra = CcbCDocu.CodAge.*/

IF CcbCDocu.CodDpto <> "" AND CcbCDocu.CodProv <> "" AND CcbCDocu.CodDist <> "" THEN DO:
  IF CcbCDocu.CodDpto = "15" AND CcbCDocu.CodProv = "01" THEN do:
     FIND TabDistr WHERE TabDistr.CodDepto = "15" 
                    AND  TabDistr.CodProvi = "01" 
                    AND  TabDistr.CodDistr = CcbCDocu.CodDist 
                   NO-LOCK NO-ERROR.
     IF AVAILABLE TabDistr THEN X-ZONA = TabDistr.NomDistr.
  END.    
  ELSE DO:     
     FIND TabProvi WHERE TabProvi.CodDepto = CcbCDocu.CodDpto 
                    AND  TabProvi.CodProvi = CcbCDocu.CodProv 
                   NO-LOCK NO-ERROR.
     IF AVAILABLE TabProvi THEN X-ZONA = TabProvi.NomProvi.
  END.        
END.

FIND gn-ven WHERE gn-ven.CodCia = CcbCDocu.CodCia 
             AND  gn-ven.CodVen = CcbCDocu.CodVen 
            NO-LOCK NO-ERROR.
IF AVAILABLE gn-ven THEN C-NomVen = gn-ven.NomVen.

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = C-NomCon + " - " + gn-ConVt.Nombr.

FIND GN-PROV WHERE gn-prov.codcia = PV-CODCIA AND
                   GN-PROV.CODPRO = CcbCDocu.CodAge NO-LOCK NO-ERROR.
IF AVAILABLE GN-PROV THEN DO:
    c-NomTra = GN-PROV.NOMPRO.
    c-DirTra = gn-prov.DirPro.
    c-RucTra = gn-prov.Ruc.
    c-Marca  = ccbcdocu.codcta.
    c-Placa  = ccbcdocu.nrocard.
END.

/* puntero en posicion */
CASE B-DOCU.CodPed:
    WHEN 'PED' THEN DO:
        FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.coddoc = B-DOCU.codped
            AND Faccpedi.nroped = B-DOCU.nroped
            NO-LOCK NO-ERROR.
        IF AVAILABLE FACCPEDI THEN DO: 
             X-TRANS = FACCPEDI.Libre_c01.
             X-DIREC = FACCPEDI.Libre_c02.
             X-LUGAR = FACCPEDI.Libre_c03.
             X-CONTC = FACCPEDI.Libre_c04.
             X-HORA  = FACCPEDI.Libre_c05.
        END.
    END.
    WHEN 'P/M' THEN DO:
        FIND Faccpedm WHERE Faccpedm.codcia = s-codcia
            AND Faccpedm.coddoc = B-DOCU.codped
            AND Faccpedm.nroped = B-DOCU.nroped
            NO-LOCK NO-ERROR.
        IF AVAILABLE FACCPEDM THEN DO: 
             X-TRANS = FACCPEDM.Libre_c01.
             X-DIREC = FACCPEDM.Libre_c02.
             X-LUGAR = FACCPEDM.Libre_c03.
             X-CONTC = FACCPEDM.Libre_c04.
             X-HORA  = FACCPEDM.Libre_c05.
        END.
    END.
END CASE.

/* FIND FACCPEDI WHERE                        */
/*      FACCPEDI.CODCIA = CcbCDocu.CodCia AND */
/*      FACCPEDI.CODDOC = "PED" AND           */
/*      FACCPEDI.NROPED = CcbCDocu.NROPED     */
/*      NO-LOCK NO-ERROR.                     */
/* IF AVAILABLE FACCPEDI THEN DO:             */
/*      X-TRANS = FACCPEDI.Libre_c01.         */
/*      X-DIREC = FACCPEDI.Libre_c02.         */
/*      X-LUGAR = FACCPEDI.Libre_c03.         */
/*      X-CONTC = FACCPEDI.Libre_c04.         */
/*      X-HORA  = FACCPEDI.Libre_c05.         */
/* END.                                       */
/* FIND FACCPEDM WHERE                        */
/*      FACCPEDM.CODCIA = CcbCDocu.CodCia AND */
/*      FACCPEDM.CODDOC = "P/M" AND           */
/*      FACCPEDM.NROPED = CcbCDocu.NROPED     */
/*      NO-LOCK NO-ERROR.                     */
/* IF AVAILABLE FACCPEDM THEN DO:             */
/*      X-TRANS = FACCPEDM.Libre_c01.         */
/*      X-DIREC = FACCPEDM.Libre_c02.         */
/*      X-LUGAR = FACCPEDM.Libre_c03.         */
/*      X-CONTC = FACCPEDM.Libre_c04.         */
/*      X-HORA  = FACCPEDM.Libre_c05.         */
/* END.                                       */

FIND gn-prov WHERE 
     gn-prov.CodCia = PV-CODCIA AND
     gn-prov.CodPro = X-TRANS 
     NO-LOCK NO-ERROR.

IF AVAILABLE gn-prov THEN                                     
     ASSIGN 
           X-Nombre = gn-prov.NomPro
           X-ruc    = gn-prov.Ruc.

FIND Almacen WHERE Almacen.CodCia = CcbCDocu.CodCia 
              AND  Almacen.CodAlm = CcbCDocu.CodAlm 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugPar = Almacen.DirAlm.
ELSE DO:
    /* buscamos el almacen en la tabla de correlativos */
    FIND FacCorre WHERE faccorre.codcia = ccbcdocu.codcia
        AND faccorre.coddoc = ccbcdocu.coddoc
        /*AND faccorre.coddiv = ccbcdocu.coddiv*/        
        AND faccorre.nroser = INTEGER(SUBSTRING(ccbcdocu.nrodoc,1,3))
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre
    THEN DO:
        FIND Almacen WHERE Almacen.codcia = ccbcdocu.codcia
            AND Almacen.codalm = Faccorre.codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN x-LugPar = Almacen.diralm.
    END.
END.

FIND TabDepto WHERE TabDepto.CodDepto = CcbCDocu.CodDpto NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN X-DEPART = TabDepto.NomDepto.

/* ********************* Direccion del cliente ************************************* */
c-DirCli = TRIM(Ccbcdocu.dircli).
FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN c-DirCli = c-DirCli + ' - ' + TRIM(TabDepto.NomDepto).
FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
    AND TabProvi.CodProvi = gn-clie.CodProv NO-LOCK NO-ERROR.
IF AVAILABLE TabProvi THEN c-DirCli = c-DirCli + ' - ' + TRIM(TabProvi.NomProvi).
FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept 
    AND TabDistr.CodProvi = gn-clie.CodProv
    AND TabDistr.CodDistr = gn-clie.CodDist NO-LOCK NO-ERROR.
IF AVAILABLE TabDistr THEN  c-DirCli = c-DirCli + ' - ' + TRIM(TabDistr.NomDistr).
/* ********************************************************************************* */

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/


DEFINE FRAME F-HdrGui
    HEADER
    SKIP(6)
    x-LugPar        AT 15 FORMAT 'x(70)' SKIP
    c-dircli        AT 15 FORMAT "X(70)" SKIP
    ccbcdocu.nomcli AT 15 FORMAT "X(70)" SKIP
    ccbcdocu.RucCli AT 15 FORMAT "X(11)" 
    CcbCDocu.CodCli AT 15 FORMAT "X(11)" 
    C-NomTra        AT 90 FORMAT "X(40)" SKIP
    ccbcdocu.nrodoc AT 35 FORMAT "XXX-XXXXXX" 
    C-RucTra        AT 87 FORMAT "X(11)" 
    c-Marca         AT 120 SKIP
    C-Placa         AT 115 SKIP(3)
    CcbCDocu.CodVen AT 85 FORMAT "X(3)"
    CcbCDocu.NroRef AT 99 FORMAT "XXX-XXXXXX" 
    ccbcdocu.fchdoc AT 119
    SKIP(2) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaGui
    ccbcdocu.codalm  AT 01 FORMAT "99"
    I-NroItm         AT 07 FORMAT "Z9"
    ccbddocu.codmat  AT 11 FORMAT "999999"
    almmmatg.desmat  AT 30 FORMAT "X(50)"
    almmmatg.desmar  AT 80 FORMAT "X(10)"
    ccbddocu.candes  AT 100 FORMAT ">>>,>>9.99"
    ccbddocu.UndVta  AT 115 FORMAT "X(8)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(2)
    'Contacto : ' X-CONTC FORMAT 'X(25)' 'Hora Aten :' X-HORA FORMAT 'X(10)'SKIP
    'PRIMER TRAMO  : '     SKIP
    'Transport: ' X-Nombre FORMAT 'X(50)' SKIP
    'RUC      : ' X-ruc    FORMAT 'X(11)' SKIP
    'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP
    'SEGUNDO TRAMO  : '    SKIP
    'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP
    'Observ   : ' FacCPedi.Observa VIEW-AS TEXT FORMAT "X(60)" 
    'Peso Aproximado(Kg.): ' AT 75 dPesTot AT 100 SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui2
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(6)
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui3
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(2)
    'PRIMER TRAMO  : '     SKIP
    'Transport: ' X-Nombre FORMAT 'X(50)' SKIP
    'RUC      : ' X-ruc    FORMAT 'X(11)' SKIP
    'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui4
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(2)
    'SEGUNDO TRAMO  : '    SKIP
    'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP
    'Observ   : ' FacCPedi.Observa VIEW-AS TEXT FORMAT "X(60)" SKIP
    /*'Peso Aproximado(Kg): ' AT 75 dPesTot AT 100 SKIP */
    'Contacto : ' X-CONTC FORMAT 'X(25)' 'Hora Aten :' X-HORA FORMAT 'X(10)'SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

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
         HEIGHT             = 5.96
         WIDTH              = 34.14.
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

/**

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               /*AND  FacCorre.CodDiv = S-CODDIV */
               AND  FacCorre.CodDoc = CcbCDocu.CodDoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))  
              NO-LOCK.
***/
/*RD01 - Nueva libreria de impresion
/*MLR* 06/12/07 Nueva librearía de impresión ***/
RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.

{lib/_printer-to.i 43}

*/

/*RD01 - Nueva libreria de impresion*/
DEFINE VAR pStatus AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE pStatus.
IF pStatus = NO THEN RETURN.

OUTPUT TO PRINTER PAGE-SIZE 43.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

x-lugent = ''.
IF CcbCDocu.Lugent2  <> '' THEN DO:
   x-lugent = 'PTO.LLEGADA - 2:' + CcbCDocu.lugent2.
END.

/*Peso Totales*/
FOR EACH ccbddocu  OF B-DOCU NO-LOCK , 
    FIRST almmmatg OF ccbddocu NO-LOCK
    BREAK BY ccbddocu.nrodoc 
        BY ccbddocu.nroitm:
    dPesTot = dPesTot + (CcbDDocu.CanDes * CcbDDocu.Factor * Almmmatg.PesMat). 
END.
dPesTot = dPesTot.
/*********/
I-NroItm = 0.
FOR EACH ccbddocu  OF B-DOCU NO-LOCK , 
    FIRST almmmatg OF ccbddocu NO-LOCK
    BREAK BY ccbddocu.nrodoc 
        BY ccbddocu.nroitm:
     VIEW FRAME F-HdrGui.
     dPesTot = dPesTot + (CcbDDocu.CanDes * CcbDDocu.Factor * Almmmatg.PesMat).      
     IF X-TRANS <> '' AND  X-LUGAR <> '' THEN DO:
         VIEW FRAME F-FtrGui.
     END.
     IF X-TRANS <> '' AND X-LUGAR = '' THEN DO:
        VIEW FRAME F-FtrGui3.
     END.
     IF X-TRANS = '' AND X-LUGAR <> '' THEN DO:
        VIEW FRAME F-FtrGui4.
     END.
     IF X-TRANS = '' AND X-LUGAR = '' THEN DO:
        VIEW FRAME F-FtrGui2.
     END.
/*      CASE B-DOCU.CodPed:                                  */
/*          WHEN "PED" THEN DO:                              */
/*              IF X-TRANS <> '' AND  X-LUGAR <> '' THEN DO: */
/*                  VIEW FRAME F-FtrGui.                     */
/*              END.                                         */
/*              IF X-TRANS <> '' AND X-LUGAR = '' THEN DO:   */
/*                 VIEW FRAME F-FtrGui3.                     */
/*              END.                                         */
/*              IF X-TRANS = '' AND X-LUGAR <> '' THEN DO:   */
/*                 VIEW FRAME F-FtrGui4.                     */
/*              END.                                         */
/*              IF X-TRANS = '' AND X-LUGAR = '' THEN DO:    */
/*                 VIEW FRAME F-FtrGui2.                     */
/*              END.                                         */
/*          END.                                             */
/*          WHEN "P/M" THEN VIEW FRAME F-FtrGui2.            */
/*      END CASE.                                            */
     I-NroItm = I-NroItm + 1.     
     DISPLAY ccbcdocu.codalm
             I-NroItm 
             ccbddocu.codmat 
             almmmatg.desmat 
             almmmatg.desmar
             ccbddocu.candes 
             ccbddocu.undvta 
             WITH FRAME F-DetaGui.
     IF LAST-OF(ccbddocu.nrodoc)
     THEN DO:
         PAGE.
     END.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


