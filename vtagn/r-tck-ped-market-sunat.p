&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-bole01.p
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

FIND Faccpedi WHERE ROWID(Faccpedi) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

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
         HEIGHT             = 5.69
         WIDTH              = 58.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ******************************************************************** */
/* IMPRESORA START MICRONICS                                            */
/* ***************************  Main Block  *************************** */
DEF VAR x-Tienda AS CHAR FORMAT 'x(50)'.
DEF VAR x-Lineas AS INT NO-UNDO INIT 0.
DEF VAR X-LIN7     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN8     AS CHAR FORMAT "X(40)".
DEF VAR x-lin13   AS CHAR FORMAT 'x(40)'.

FIND Gn-Divi WHERE Gn-Divi.codcia = Faccpedi.codcia
    AND Gn-Divi.coddiv = Faccpedi.coddiv
    NO-LOCK NO-ERROR.
IF AVAILABLE Gn-Divi THEN 
    ASSIGN 
        x-Tienda = CAPS(GN-DIVI.DesDiv).

/* AGREGAMOS LOS TITULOS Y PIE DE PAGINA */
x-Lineas = 20.
x-lin7 = "Cliente: " + Faccpedi.nomcli.
x-lin8 = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
x-lin13 = "TOTAL: S/" + STRING(FacCPedi.TotalVenta, ">>>,>>9.99").

DEF VAR rpta AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT TO PRINTER.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(x-Lineas) + {&PRN4}.
PUT CONTROL Chr(27) + Chr(112) + Chr(48) .
PUT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
DISPLAY 
    {&PRN3} + {&PRN6B} + x-Tienda  NO-LABEL AT 5 FORMAT "X(60)" SKIP
    "Especialista en utiles " AT 10 FORMAT "X(50)" SKIP 
    "escolares y de oficina" AT 10 FORMAT "X(50)" SKIP 
    'Continental S.A.C.' AT 1 FORMAT "X(50)" NO-LABEL SKIP(2)
    x-lin7 NO-LABEL 
    x-lin8 NO-LABEL 
    SKIP.
PUT "--------------------------------------" SKIP.
PUT x-lin13  AT 10 SKIP.
PUT "GRACIAS POR SU COMPRA" AT 12 SKIP.
PUT "STANDFORD - CONTI" AT 14 SKIP(5).
PUT CONTROL CHR(27) + 'm'.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


