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

DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-LugPar LIKE Almacen.DirAlm.
DEF VAR X-FchRef LIKE ccbcdocu.fchdoc.
DEF VAR X-TRANS  LIKE FACCPEDI.Libre_c01.
DEF VAR X-DIREC  LIKE FACCPEDI.Libre_c02.
DEF VAR X-LUGAR  LIKE FACCPEDI.Libre_c03.
DEF VAR X-CONTC  LIKE FACCPEDI.Libre_c04.
DEF VAR X-HORA   LIKE FACCPEDI.Libre_c05.
/* RHC 20/07/2015 DATOS DEL TRANSPORTISTA */
DEF VAR f-CodAge AS CHAR NO-UNDO.
DEF VAR f-NomTra AS CHAR NO-UNDO.
DEF VAR f-RucAge AS CHAR NO-UNDO.
DEF VAR f-Marca  AS CHAR NO-UNDO.
DEF VAR f-NroLicencia AS CHAR NO-UNDO.
DEF VAR f-Placa  AS CHAR NO-UNDO.
DEF VAR f-Certificado AS CHAR NO-UNDO.
/* ************************************** */
DEFINE SHARED VARIABLE X-CTRANS  AS CHAR. 
DEFINE SHARED VARIABLE X-RTRANS  AS CHAR. 
DEFINE SHARED VARIABLE X-DTRANS  AS CHAR. 
DEFINE BUFFER B-DOCU FOR ccbcdocu.

DEFINE VAR dPesTot AS DEC NO-UNDO.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.
FIND B-DOCU WHERE B-DOCU.CODCIA = ccbcdocu.CodCia 
             AND  B-DOCU.CodDoc = ccbcdocu.CodRef 
             AND  B-DOCU.NroDoc = ccbcdocu.NroRef 
            NO-LOCK NO-ERROR.
IF AVAILABLE B-DOCU THEN X-FchRef = B-DOCU.FchDoc.
ELSE X-FchRef = ?.

FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA 
    AND gn-clie.codcli = ccbcdocu.codcli 
    NO-LOCK.
    
/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

DEF VAR x-PuntoPartida AS CHAR NO-UNDO.
DEF VAR x-PuntoLlegada AS CHAR NO-UNDO.
DEF VAR x-Nombre       AS CHAR NO-UNDO.
DEF VAR x-NomTra       AS CHAR NO-UNDO.
DEF VAR x-Ruc          AS CHAR NO-UNDO.
DEF VAR x-RucTra       AS CHAR NO-UNDO.
DEF VAR x-CodCli       AS CHAR NO-UNDO.

RUN Carga-Variables.

DEFINE FRAME F-HdrGui
    HEADER
    SKIP(6)
    x-PuntoPartida  AT 12 FORMAT 'x(100)' SKIP
    x-PuntoLlegada  AT 12 FORMAT "X(100)" SKIP
    x-Nombre        AT 12 FORMAT "X(70)" SKIP
    x-Ruc           AT 12 FORMAT "X(11)" 
    x-CodCli        AT 12 FORMAT "X(11)" 
    f-NomTra        AT 90 FORMAT "X(40)" SKIP
    "O/DESPACHO # "     AT 17 CcbCDocu.NroPed 
    "( " AT 42 CcbCDocu.CodRef AT 45  CcbCDocu.NroRef FORMAT "XXX-XXXXXXXXX" X-FchRef  " )"
    f-RucAge        AT 87 FORMAT "X(11)" 
    f-Marca         AT 120 SKIP
    f-NroLicencia   AT 90 FORMAT 'x(15)'
    f-Placa         AT 115 SKIP
    x-Senal         AT 5 FORMAT 'x' 
    f-Certificado   AT 95 f-Certificado FORMAT 'x(30)' SKIP(1)
    CcbCDocu.CodVen AT 85 FORMAT "X(3)"
    "G/R "          AT 91 
    ccbcdocu.nrodoc AT 95 FORMAT "XXX-XXXXXX"
    ccbcdocu.fchdoc AT 119
    SKIP(2) 
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
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(2)
    'Contacto : ' X-CONTC FORMAT 'X(25)' 'Hora Aten :' X-HORA FORMAT 'X(10)'SKIP
    'PRIMER TRAMO  : '     SKIP
    'Transport: ' X-NomTra FORMAT 'X(50)' SKIP
    'RUC      : ' X-RucTra    FORMAT 'X(11)' dPesTot AT 58 SKIP
    'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP
    'SEGUNDO TRAMO  : '    SKIP
    'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP
    'Observ   : ' CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" 
    ' ' AT 75 SKIP
/*     'Peso Aproximado(Kg.): ' AT 75 dPesTot AT 100 SKIP */
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui2
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(6)
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui3
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(1)
    dPesTot AT 58 SKIP
    'PRIMER TRAMO  : '     SKIP
    'Transport: ' X-NomTra FORMAT 'X(50)' SKIP
    'RUC      : ' X-RucTra    FORMAT 'X(11)' SKIP
    'Dirección: ' X-DIREC  FORMAT 'X(50)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui4
    HEADER
    "LA MERCADERIA VIAJA POR CUENTA Y RIESGO DEL CLIENTE, EL DESPACHO DE MERCADERIA ABARCA HASTA LA AGENCIA DE TRANSPORTE" skip(1)  
    dPesTot AT 58 SKIP
    'SEGUNDO TRAMO  : '    SKIP
    'Destino  : ' X-LUGAR  FORMAT 'X(50)' SKIP
    'Observ   : ' CcbCDocu.Glosa VIEW-AS TEXT FORMAT "X(60)" SKIP
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
         WIDTH              = 53.29.
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
DEFINE VAR pStatus AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE pStatus.
IF pStatus = NO THEN RETURN.

OUTPUT TO PRINTER PAGE-SIZE 43.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     


/*Peso Totales*/
ASSIGN
    dPesTot = 0
    I-NroItm = 0.
FOR EACH Ccbddocu  OF Ccbcdocu NO-LOCK, 
    FIRST almmmatg OF ccbddocu NO-LOCK
    BREAK BY ccbddocu.nrodoc BY ccbddocu.nroitm:
    VIEW FRAME F-HdrGui.
    dPesTot = dPesTot + CcbDDocu.pesmat.
    IF X-TRANS <> '' AND  X-LUGAR <> '' THEN VIEW FRAME F-FtrGui.
    IF X-TRANS <> '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui3.
    IF X-TRANS = '' AND X-LUGAR <> '' THEN VIEW FRAME F-FtrGui4.
    IF X-TRANS = '' AND X-LUGAR = '' THEN VIEW FRAME F-FtrGui2.
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
    IF LAST-OF(ccbddocu.nrodoc) THEN PAGE.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Variables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Variables Procedure 
PROCEDURE Carga-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-PuntoPartida AS CHAR NO-UNDO.

ASSIGN
    x-PuntoLlegada = Ccbcdocu.lugent    /* Sede del cliente o del transpoprtista */
    x-Nombre       = Ccbcdocu.nomcli
    x-Ruc          = Ccbcdocu.ruccli
    x-CodCli       = Ccbcdocu.codcli.
/* Buscamos Agencia de Transporte */
IF CcbCDocu.CodAge > '' THEN DO:
    FIND FIRST gn-prov WHERE gn-prov.CodCia = pv-codcia AND
        gn-prov.CodPro = CcbCDocu.CodAge NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN
        ASSIGN
        x-PuntoLlegada = Ccbcdocu.LugEnt2
        x-Nombre = gn-prov.NomPro 
        x-Ruc    = gn-prov.Ruc.
END.


ASSIGN
    X-senal  = "X".

FIND Ccbadocu OF Ccbcdocu NO-LOCK NO-ERROR.
IF AVAILABLE Ccbadocu THEN DO:
    /* Primer Tramo */
    ASSIGN
        x-Trans = CcbADocu.Libre_C[9]
        x-Direc = CcbADocu.Libre_C[12].
    /* Segundo Tramo */
    ASSIGN
        x-Lugar = CcbADocu.Libre_C[13]
        x-Contc = CcbADocu.Libre_C[14]
        x-Hora  = CcbADocu.Libre_C[15].
    /* Datos del Transportista/Conductor */
    ASSIGN
        f-CodAge = Ccbadocu.Libre_C[3]
        f-NomTra = Ccbadocu.Libre_C[4]
        f-RucAge = Ccbadocu.Libre_C[5]
        f-Marca  = Ccbadocu.Libre_C[2]
        f-NroLicencia = Ccbadocu.Libre_C[6]
        f-Placa  = Ccbadocu.Libre_C[1]
        f-Certificado = CcbADocu.Libre_C[17].
END.
FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA
    AND gn-prov.CodPro = X-TRANS
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN
     ASSIGN
           X-NomTra = gn-prov.NomPro
           X-RucTra = gn-prov.Ruc.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = Ccbcdocu.coddiv
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN x-LugPar = TRIM(GN-DIVI.DirDiv) + " " + gn-divi.faxdiv.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

