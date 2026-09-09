&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-fact01.p
    Purpose     : Impresion de Fact/Boletas 

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

FIND CCBCMVTO WHERE ROWID(CCBCMVTO) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE CCBCMVTO THEN RETURN.

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR CL-CODCIA AS INTEGER.

DEF VAR X-EnLetras AS CHAR FORMAT "x(150)" NO-UNDO.
DEF VAR x-NroSer AS CHAR FORMAT 'x(3)' NO-UNDO.
DEF VAR x-NroDoc AS CHAR FORMAT 'x(9)' NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.
DEF VAR x-Total  AS DEC NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND  gn-clie.codcli = ccbcmvto.codcli 
    NO-LOCK NO-ERROR.

x-Total = 0.
FOR EACH ccbdmvto NO-LOCK WHERE ccbdmvto.codcia = ccbcmvto.codcia
    AND ccbdmvto.coddiv = ccbcmvto.coddiv
    AND ccbdmvto.coddoc = ccbcmvto.coddoc
    AND ccbdmvto.nrodoc = ccbcmvto.nrodoc:
    x-Total = x-Total + ccbdmvto.imptot.
END.

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(x-Total, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + " NUEVOS SOLES".
/************************  DEFINICION DE FRAMES  *******************************/

DEF VAR c-DirCli AS CHAR NO-UNDO.

c-DirCli = TRIM(gn-clie.dircli).

FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto THEN c-DirCli = c-DirCli + ' - ' + TRIM(TabDepto.NomDepto).
/*
FIND TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept 
    AND TabProvi.CodProvi = gn-clie.CodProv NO-LOCK NO-ERROR.
IF AVAILABLE TabProvi THEN c-DirCli = c-DirCli + ' - ' + TRIM(TabProvi.NomProvi).
FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept 
    AND TabDistr.CodProvi = gn-clie.CodProv
    AND TabDistr.CodDistr = gn-clie.CodDist NO-LOCK NO-ERROR.
IF AVAILABLE TabDistr THEN  c-DirCli = c-DirCli + ' - ' + TRIM(TabDistr.NomDistr).
*/

DEFINE FRAME F-HdrFac
    HEADER
    SKIP(2)
    Ccbcmvto.coddiv FORMAT 'x(5)' AT 70 Ccbcmvto.nrodoc FORMAT 'x(9)'
    SKIP(2)
    gn-clie.nomcli  AT 15 FORMAT "x(100)" 
    c-dircli        AT 15 FORMAT "x(150)" 
    gn-clie.Ruc     AT 15 FORMAT "x(11)"
    ccbcmvto.fchdoc AT 15 FORMAT '99/99/9999'
    SKIP(3)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaFac
    FacDocum.CodCbd                 FORMAT 'x(3)'
    x-NroSer         AT 15          FORMAT 'x(3)'
    x-NroDoc         AT 30          FORMAT 'x(9)'
    ccbcdocu.fchdoc  AT 50          FORMAT '99/99/9999'
    ccbdmvto.impdoc  AT 70          FORMAT '(>>>,>>9.99)'
    ccbdmvto.impint  AT 90         FORMAT '(>>9.99)'
    ccbdmvto.imptot  AT 102         FORMAT '(>>>,>>9.99)'
    x-ImpTot         AT 125         FORMAT '(>>>,>>9.99)' 
    WITH NO-LABELS NO-BOX STREAM-IO WIDTH 200.

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
         HEIGHT             = 5.38
         WIDTH              = 52.57.
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
DEFINE FRAME F-Ftrfac
    HEADER
    "SON : " X-EnLetras AT 07 SKIP(1)
    x-Total AT 100  FORMAT "(>>>,>>9.99)" SKIP(3)
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 200.

OUTPUT TO PRINTER PAGE-SIZE 30.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.
FOR EACH ccbdmvto NO-LOCK WHERE ccbdmvto.codcia = ccbcmvto.codcia
    AND ccbdmvto.coddiv = ccbcmvto.coddiv
    AND ccbdmvto.coddoc = ccbcmvto.coddoc
    AND ccbdmvto.nrodoc = ccbcmvto.nrodoc,
    FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = ccbdmvto.codcia
    AND ccbcdocu.coddoc = ccbdmvto.codref
    AND ccbcdocu.nrodoc = ccbdmvto.nroref,
    FIRST facdocum OF ccbcdocu NO-LOCK
    BREAK BY Ccbdmvto.codcia:
    VIEW FRAME F-HdrFac.
    VIEW FRAME F-FtrFac.
    ASSIGN
        x-NroSer = SUBSTRING(ccbcdocu.nrodoc,1,3)
        x-NroDoc = SUBSTRING(ccbcdocu.nrodoc,4)
        x-ImpTot = ccbdmvto.impdoc + ccbdmvto.imptot.
    DISPLAY 
        FacDocum.CodCbd
        /*ccbdmvto.codref                 */
        x-NroSer                        
        x-NroDoc                        
        ccbcdocu.fchdoc                 
        ccbdmvto.impdoc                 
        ccbdmvto.impint                 
        ccbdmvto.imptot                 
        x-ImpTot                        
        WITH FRAME F-DetaFac.
    IF LAST-OF(Ccbdmvto.codcia) THEN PAGE.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


