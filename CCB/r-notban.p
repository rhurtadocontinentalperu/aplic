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

FIND FIRST ccbcmvto WHERE ROWID(ccbcmvto) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcmvto THEN RETURN.

/* Definimos impresoras */
DEF VAR Rpta AS LOG NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE Rpta.
IF Rpta = NO THEN RETURN.

DEF VAR c-Moneda AS CHAR FORMAT 'x(7)' NO-UNDO.
DEF SHARED VAR s-nomcia AS CHAR FORMAT 'x(50)'.

/************************  DEFINICION DE FRAMES  *******************************/
c-Moneda = IF ccbcmvto.codmon = 1 THEN 'Soles' ELSE 'Dolares'.
DEFINE FRAME F-Header
    HEADER
    s-NomCia 
    'NOTAS BANCARIAS' TO 80 SKIP(1)
    'Numero:' TO 20 ccbcmvto.nrodoc
    'Fecha:'  TO 60 ccbcmvto.fchdoc SKIP
    'Division:' TO 20 ccbcmvto.coddiv
    'Fecha Contable:' TO 60 ccbcmvto.FchCbd SKIP
    'Referencia:' TO 20 ccbcmvto.nroref
    'Cuenta Contable:' TO 60 ccbcmvto.codcta SKIP
    'Moneda:' TO 20 c-Moneda
    'Tipo de Cambio:' TO 60 ccbcmvto.tpocmb SKIP
/*MLR* *13/Mar/2008* */
    'Ingresos:' TO 20 ccbcmvto.Libre_dec[1] FORMAT "->,>>>,>>9.99"
    'Cuenta Ingresos:' to 60 ccbcmvto.Libre_chr[1] SKIP
    'Egresos:' TO 20 ccbcmvto.Libre_dec[2] FORMAT "->,>>>,>>9.99"
    'Cuenta Egresos:' to 60 ccbcmvto.Libre_chr[2] SKIP
    'Observaciones:' TO 20 ccbcmvto.glosa SKIP
    'Usuario:' TO 20 ccbcmvto.usuario SKIP
    WITH PAGE-TOP NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN WIDTH 92.
DEFINE FRAME F-Detail
    ccbdcaja.codref COLUMN-LABEL 'Codigo'
    ccbdcaja.nroref COLUMN-LABEL 'Numero'
    ccbcdocu.fchdoc COLUMN-LABEL 'Fch. Documento'
    ccbcdocu.fchvto COLUMN-LABEL 'Fch.Vencimiemto'
    ccbcdocu.sdoact COLUMN-LABEL 'Saldo'
    ccbdcaja.imptot COLUMN-LABEL 'Pago'
    CcbCMvto.ImpTot COLUMN-LABEL 'Importe Total' SKIP
    WITH NO-BOX STREAM-IO DOWN WIDTH 92.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 1.69
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
  OUTPUT TO PRINTER PAGE-SIZE 30.
  PUT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn2}.

  FOR EACH Ccbdcaja NO-LOCK WHERE Ccbdcaja.codcia = Ccbcmvto.codcia
        AND Ccbdcaja.coddoc = Ccbcmvto.coddoc
        AND Ccbdcaja.nrodoc = Ccbcmvto.nrodoc,
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdcaja.codcia
            AND Ccbcdocu.coddoc = Ccbdcaja.codref
            AND Ccbcdocu.nrodoc = Ccbdcaja.nroref
            BREAK BY Ccbdcaja.nrodoc:
    VIEW FRAME F-Header.
    DISPLAY
        ccbdcaja.codref
        ccbdcaja.nroref
        ccbcdocu.fchdoc
        ccbcdocu.fchvto
        ccbcdocu.sdoact
        ccbdcaja.imptot
        CcbCMvto.ImpTot WHEN LAST-OF(Ccbdcaja.nrodoc)
        WITH FRAME F-Detail.
  END.
  PAGE.
  OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


