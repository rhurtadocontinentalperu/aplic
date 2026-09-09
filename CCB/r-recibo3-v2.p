&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : R-Recibo.p
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.

DEFINE SHARED VAR S-CODCIA        AS INT.
DEFINE SHARED VAR S-CODDIV        LIKE gn-divi.coddiv.
DEFINE SHARED VAR S-CODTER        LIKE ccbcterm.codter.
DEFINE SHARED VAR S-NOMCIA        AS CHAR.
DEFINE SHARED VAR S-RUCCIA        AS INTEGER.
DEFINE SHARED VAR CL-CODCIA       AS INT.

DEF VAR X-EnLetras AS CHAR FORMAT "X(60)" NO-UNDO.
DEF VAR X-Nomcli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-Dircli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-Mon      AS CHAR FORMAT "X(4)"  NO-UNDO.
DEF VAR X-Total    AS DECIMAL INIT 0.
DEF VAR X-RUCCLI   AS CHAR FORMAT "X(11)" NO-UNDO.
DEF VAR Y-Nomcli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR Y-Dircli   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR Y-Mon      AS CHAR FORMAT "X(4)"  NO-UNDO.
DEF VAR Y-Total    AS DECIMAL INIT 0.
DEF VAR x-NomDiv    AS CHAR NO-UNDO.

DEFINE VAR E-VISUAL AS CHARACTER VIEW-AS EDITOR SIZE 50 BY 2.
DEFINE VAR Y-VISUAL AS CHARACTER VIEW-AS EDITOR SIZE 50 BY 2.

DEF VAR X-Descri   AS CHAR FORMAT "X(40)" NO-UNDO.
DEF VAR X-Direcc   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-Telefo   AS CHAR FORMAT "X(10)" NO-UNDO.
DEF VAR X-Desdiv   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR N-RECIBX   AS CHAR FORMAT "X(10)"  NO-UNDO.
DEF VAR N-RECIBY   AS CHAR FORMAT "X(10)"  NO-UNDO.
DEF VAR F-FECHAX   AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR F-FECHAY   AS DATE FORMAT "99/99/9999" NO-UNDO.

DEF VAR X-Codig    AS CHAR NO-UNDO.
DEF VAR Y-Codig    AS CHAR NO-UNDO.
DEF VAR X-CoRef    AS CHAR FORMAT "XX" NO-UNDO.
DEF VAR Y-CoRef    AS CHAR FOrmat "XX" NO-UNDO.        
DEF VAR X-NoRef    AS CHAR FORMAT "XXX-XXXXXX" NO-UNDO.
DEF VAR Y-NoRef    AS CHAR FORMAT "XXX-XXXXXX" NO-UNDO.                
DEF VAR x-tipo     AS deci FORMAT ">>9.9999" .                
DEF VAR X-RUCCIA   AS CHAR INIT "20100038146" FORMAT "X(11)".

FIND gn-cias WHERE gn-cias.codcia = s-codcia NO-LOCK.
x-RucCia = gn-cias.libre-c[1].
               
FIND CCbCcaja WHERE ROWID(CCbCcaja) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE CCbCcaja THEN RETURN.
     
 N-RECIBX = CcbCcaja.NroDoc.
 N-RECIBY = CcbCcaja.NroDoc.
 
 F-FECHAX = CcbcCaja.FchDoc.
 F-FECHAY = CcbcCaja.FchDoc.
 X-TIPO   = CcbcCaja.TpoCmb.
 
     
 FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA AND
      gn-clie.codcli = CCbCcaja.codcli NO-LOCK NO-ERROR.
 IF AVAILABLE gn-clie THEN DO:
    IF gn-clie.codcli <> "11111111" THEN DO:
       X-Nomcli = CCbCcaja.codcli + " " + gn-clie.NomCli. 
       X-Dircli = gn-clie.DirCli. 
       Y-Nomcli = gn-clie.NomCli. 
       y-Dircli = gn-clie.DirCli.
       X-RUCCLI = gn-clie.Ruc.
    END.   
    ELSE DO:
       X-Nomcli = CCbCcaja.codcli + " " + CcbCcaja.NomCli. 
       X-Dircli = "". 
       Y-Nomcli = CcbCcaja.NomCli. 
       y-Dircli = "".
       X-RUCCLI = "".
    END.   
 END.

 FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                    Gn-Divi.Coddiv = S-CODDIV NO-LOCK NO-ERROR.
 IF NOT AVAILABLE Gn-Divi THEN DO:
    MESSAGE "Division " + S-CODDIV + " No Existe " SKIP
            "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
    RETURN .
 END.
 x-NomDiv = GN-DIVI.DesDiv.

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
         HEIGHT             = 4.5
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


/* ***************************  Main Block  *************************** */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl".
  RB-REPORT-NAME = "Liquidacion de cobranza".
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "Ccbccaja.codcia = " + STRING(Ccbccaja.codcia) + " AND " +
      "Ccbccaja.coddiv = '" + Ccbccaja.coddiv + "' AND " +
      "Ccbccaja.coddoc = '" + Ccbccaja.coddoc + "' AND " +
      "Ccbccaja.nrodoc = '" + Ccbccaja.nrodoc + "'".
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
      "~ns-ruccia = " + x-ruccia + 
      "~ns-nomcli = " + x-nomcli +
      "~ns-ruccli = " + x-ruccli +
      "~ns-nomdiv = " + x-nomdiv.
  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


