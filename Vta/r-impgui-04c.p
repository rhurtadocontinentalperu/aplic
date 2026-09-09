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
DEF SHARED VAR cl-CODCIA AS INTEGER.
DEF SHARED VAR pv-CODCIA AS INTEGER.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id LIKE ccbcterm.codter.

DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR C-NomVen AS CHAR FORMAT "X(21)".
DEF VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF VAR C-RucTra AS CHAR FORMAT "X(11)".
DEF VAR C-NomTra AS CHAR FORMAT "X(35)".
DEF VAR C-DirTra AS CHAR FORMAT "X(40)".
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-DEPART LIKE TabDepto.NomDepto.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-FchRef LIKE ccbcdocu.fchdoc.
DEF VAR X-Lugent AS CHAR NO-UNDO.
DEF VAR codalm   AS CHARACTER NO-UNDO.
DEFINE BUFFER B-DOCU FOR ccbcdocu.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND B-DOCU WHERE B-DOCU.CODCIA = ccbcdocu.CodCia 
             AND  B-DOCU.CodDoc = ccbcdocu.CodRef 
             AND  B-DOCU.NroDoc = ccbcdocu.NroRef 
            NO-LOCK NO-ERROR.
IF AVAILABLE B-DOCU AND ccbcdocu.codref <> '' 
THEN X-FchRef = B-DOCU.FchDoc.
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


FIND Ccbadocu OF Ccbcdocu NO-LOCK NO-ERROR.
IF AVAILABLE Ccbadocu THEN DO:
    /* TRANSPORTISTA */
    ASSIGN
        c-NomTra = Ccbadocu.Libre_c[4]
        c-RucTra = Ccbadocu.Libre_c[5].
    FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
        AND gn-prov.CODPRO = Ccbadocu.Libre_c[3]
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-PROV THEN C-DirTra = gn-prov.DirPro.
END.

FIND Almacen WHERE Almacen.CodCia = CcbCDocu.CodCia 
              AND  Almacen.CodAlm = CcbCDocu.CodAlm 
             NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugPar = Almacen.DirAlm.

FIND TabDepto WHERE TabDepto.CodDepto = CcbCDocu.CodDpto NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN X-DEPART = TabDepto.NomDepto.


/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/


DEFINE FRAME F-HdrGui
    HEADER
    SKIP(4)
    x-LugPar        AT 5 FORMAT 'x(70)'
    'Cliente: ' + ccbcdocu.nomcli AT 5 FORMAT "X(70)" 
    ccbcdocu.fchdoc AT 110 SKIP
    'Dirección: ' + ccbcdocu.dircli AT 5 FORMAT "X(50)" 
    string(ccbcdocu.horcie,'x(8)') at 122 SKIP
    'RUC: ' + ccbcdocu.RucCli AT 5 FORMAT "X(11)"  SKIP
    'Vendedor: ' + C-NomTra   AT 5 FORMAT "X(35)" SKIP 
    "O/DESPACHO # " AT 5 FORMAT "X(8)" CcbCDocu.NroDoc 
    SKIP(1)
    "-------------------------------------------------------------------------------------------------------------------------" SKIP
    " Item    Código  Descripción                                               Marca                  Unidad      Cantidad   " SKIP
    "-------------------------------------------------------------------------------------------------------------------------" SKIP 
    WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME F-DetaGui
    I-NroItm          FORMAT "Z9"
    ccbddocu.codmat   FORMAT "999999"
    almmmatg.desmat   FORMAT "X(70)"
    almmmatg.desmar   FORMAT "X(20)"
    ccbddocu.UndVta   FORMAT "X(8)"
    ccbddocu.candes   FORMAT ">>>,>>9.99"
    WITH WIDTH 400 NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO DOWN .

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
         WIDTH              = 40.57.
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
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodDoc = CcbCDocu.CodDoc 
               AND  FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))  
              NO-LOCK.

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

VIEW FRAME F-HdrGui.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK , 
    EACH almmmatg NO-LOCK WHERE
         almmmatg.codcia = ccbddocu.codcia AND
         almmmatg.codmat = ccbddocu.codmat,
         FIRST almmmate NO-LOCK  
             WHERE almmmate.CodCia = CcbDDocu.CodCia 
               AND almmmate.CodAlm = CcbCDocu.CodAlm 
               AND almmmate.CodMat = CcbDDocu.CodMat
                   BREAK BY Almmmate.CodUbi
                         BY ccbddocu.Codmat:
        
       /* VIEW FRAME F-FtrGui.*/
        I-NroItm = I-NroItm + 1.
        DISPLAY I-NroItm 
                ccbddocu.codmat 
                almmmatg.desmat 
                almmmatg.desmar
                ccbddocu.UndVta
                ccbddocu.candes 
                WITH FRAME F-DetaGui.
/*
        IF LAST-OF(ccbddocu.nrodoc)
        THEN DO:
            PAGE.
        END.*/
END.


OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


