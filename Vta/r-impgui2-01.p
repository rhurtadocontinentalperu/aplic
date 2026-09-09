&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-impgui2.p
    Purpose     : Impresion de Guias con codigo EAM

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
DEF SHARED VAR PV-CODCIA AS INTEGER.
DEF SHARED VAR cl-CODCIA AS INTEGER.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id LIKE ccbcterm.codter.

DEF VAR C-DirCli AS CHAR FORMAT "X(70)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR C-NomVen AS CHAR FORMAT "X(21)".
DEF VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF VAR C-RucTra AS CHAR FORMAT "X(11)".
DEF VAR C-NomTra AS CHAR FORMAT "X(35)".
DEF VAR C-DirTra AS CHAR FORMAT "X(40)".
DEF VAR C-Marca  AS CHAR FORMAT "X(30)".
DEF VAR C-Placa  AS CHAR FORMAT "X(10)".
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-DEPART LIKE TabDepto.NomDepto.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-FchRef LIKE ccbcdocu.fchdoc.
DEF VAR X-Lugent AS CHAR NO-UNDO.
DEF VAR X-Nombre LIKE gn-prov.NomPro.
DEF VAR X-ruc    LIKE gn-prov.Ruc.
DEF VAR X-TRANS  LIKE FACCPEDI.Libre_c01.
DEF VAR X-DIREC  LIKE FACCPEDI.Libre_c02.
DEF VAR X-LUGAR  LIKE FACCPEDI.Libre_c03.
DEF VAR X-CONTC  LIKE FACCPEDI.Libre_c04.
DEF VAR X-HORA   LIKE FACCPEDI.Libre_c05.
DEFINE BUFFER B-DOCU FOR ccbcdocu.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND B-DOCU WHERE B-DOCU.CODCIA = ccbcdocu.CodCia 
             AND  B-DOCU.CodDoc = ccbcdocu.CodRef 
             AND  B-DOCU.NroDoc = ccbcdocu.NroRef 
            NO-LOCK NO-ERROR.
IF AVAILABLE B-DOCU THEN X-FchRef = B-DOCU.FchDoc.
ELSE X-FchRef = ?.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
              AND  gn-clie.codcli = ccbcdocu.codcli 
             NO-LOCK.
    
X-senal  = "X".
C-NomVen = CcbCDocu.CodVen.
C-NomCon = CcbCDocu.FmaPgo.

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


FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND gn-prov.CODPRO = CcbCDocu.CodAge NO-LOCK NO-ERROR.
     IF AVAILABLE GN-PROV THEN
     do:
      C-NomTra = GN-PROV.NomPRO.
      C-DirTra = gn-prov.DirPro.
      C-RucTra = gN-PROV.RUC.
      c-Marca  = ccbcdocu.codcta.
      c-Placa  = ccbcdocu.nrocard.
     end.

/*FIND gn-prov WHERE gn-prov.codcia = 0 AND
    gn-prov.codpro = C-RucTra NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN C-DirTra = gn-prov.DirPro.*/

/* FIND FACCPEDI WHERE                             */
/*           FACCPEDI.CODCIA = CcbCDocu.CodCia AND */
/*           FACCPEDI.CODDOC = "O/D" AND           */
/*           FACCPEDI.NROPED = CcbCDocu.NROPED     */
/*           NO-LOCK NO-ERROR.                     */
FIND FACCPEDI WHERE 
          FACCPEDI.CODCIA = CcbCDocu.CodCia AND
          FACCPEDI.CODDOC = CcbCDocu.CodPed AND
          FACCPEDI.NROPED = CcbCDocu.NroPed
          NO-LOCK NO-ERROR.
     IF AVAILABLE FACCPEDI THEN DO: 
          X-TRANS = FACCPEDI.Libre_c01.
          X-DIREC = FACCPEDI.Libre_c02.
          X-LUGAR = FACCPEDI.Libre_c03.
          X-CONTC = FACCPEDI.Libre_c04.
          X-HORA  = FACCPEDI.Libre_c05.
     END.
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
    x-LugPar        AT 12 FORMAT 'x(70)' SKIP
    c-dircli        AT 12 FORMAT "X(70)" SKIP
    ccbcdocu.nomcli AT 12 FORMAT "X(70)" SKIP
    ccbcdocu.RucCli AT 12 FORMAT "X(11)"  
    CcbCDocu.CodCli AT 17 FORMAT "X(11)" 
    C-NomTra        AT 90 FORMAT "X(40)" SKIP
    "O/DESPACHO # "     AT 17 FORMAT "X(8)" CcbCDocu.NroPed 
    "( " AT 42 FORMAT "X(2)" CcbCDocu.CodRef AT 45  CcbCDocu.NroRef FORMAT "XXX-XXXXXX" X-FchRef  " )"
    C-RucTra        AT 87 FORMAT "X(11)"
    c-Marca         AT 120 SKIP
    '1  Venta'      AT 8 FORMAT "X(15)" 
    C-Placa         AT 115 SKIP(3)
    CcbCDocu.CodVen AT 80 FORMAT "X(3)"
    "G/R " AT 91 FORMAT "X(4)"
    ccbcdocu.nrodoc AT 95 FORMAT "XXX-XXXXXX"
    ccbcdocu.fchdoc AT 110
    string(ccbcdocu.horcie,'x(8)') at 122
    SKIP(3) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaGui
    ccbcdocu.codalm  AT 01 FORMAT "99"
    I-NroItm         AT 04 FORMAT "Z9"
    ccbddocu.codmat  AT 10 FORMAT "999999"
    almmmatg.codbrr  AT 20 FORMAT 'x(15)'
    almmmatg.desmat  FORMAT "X(40)"
    almmmatg.desmar  FORMAT "X(10)"
    ccbddocu.candes  FORMAT ">>>,>>9.99"
    ccbddocu.UndVta  FORMAT "X(8)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui
    HEADER
    SKIP
    "Obs: UNA VEZ RECIBIDA LA MERCADERIA, NO HAY LUGAR A DEVOLUCIONES Y/O RECLAMOS" skip(1)
    'Contacto : ' X-CONTC FORMAT 'X(25)' 'Hora Aten :' X-HORA FORMAT 'X(10)'SKIP
    'PRIMER TRAMO  : '     SKIP
    'Transport: ' X-Nombre FORMAT 'X(50)' SKIP
    'RUC      : ' X-ruc    FORMAT 'X(11)' SKIP
    'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP
    'SEGUNDO TRAMO  : '    SKIP
    'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui2
    HEADER
    'Obs: UNA VEZ RECIBIDA LA MERCADERIA, NO HAY LUGAR A DEVOLUCIONES Y/O RECLAMOS' FORMAT "X(100)" SKIP
    'O.Compra: ' CcbCDocu.NroOrd  SKIP
    'Salida  : ' X-Lugpar FORMAT 'X(38)' SKIP
    'Destino : ' CcbCDocu.LugEnt FORMAT 'X(50)' SKIP
    'Atencion: ' CcbCDocu.Nomcli FORMAT 'X(30)' SKIP
    'Glosa   : ' CcbCDocu.Glosa  FORMAT 'X(30)' SKIP
    'Salida Almacen : ' String(CcbCdocu.Nrosal,"999999") FORMAT 'X(30)'
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
         HEIGHT             = 2.15
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
/*MLR* *21/11/07 ***
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).
* ***/
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = Ccbcdocu.CodDiv
               AND  FacCorre.CodDoc = CcbCDocu.CodDoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))  
              NO-LOCK.
/*MLR* ***
IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").
* ***/

RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.

/*OUTPUT TO VALUE(s-port-name) PAGE-SIZE 42.*/
{lib/_printer-to.i 42}
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

x-lugent = ''.
IF CcbCDocu.Lugent2  <> '' THEN DO:
   x-lugent = 'PTO.LLEGADA - 2:' + CcbCDocu.lugent2.
END.

I-NroItm = 0.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK , 
    FIRST almmmatg OF ccbddocu NO-LOCK
                   BREAK BY ccbddocu.nrodoc 
                         BY ccbddocu.nroitm
                         BY almmmatg.desmat:
        VIEW FRAME F-HdrGui.
        
        IF X-TRANS <> '' 
        THEN VIEW FRAME F-FtrGui.
        ELSE VIEW FRAME F-FtrGui2.

        I-NroItm = I-NroItm + 1.
        DISPLAY ccbcdocu.codalm
                I-NroItm 
                ccbddocu.codmat 
                almmmatg.codbrr
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


