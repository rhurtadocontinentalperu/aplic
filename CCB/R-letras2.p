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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

Def var x-fchdoc as date.
Def var x-fchvto as date.
Def var x-imptot as decimal.
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR detalle as char format "x(30)".
DEF VAR X-MONEDA as char format "x(4)".
DEF VAR C-NomCli LIKE gn-clie.nomcli NO-UNDO.
DEF VAR C-DirCli LIKE gn-clie.dircli NO-UNDO.
DEF VAR C-RucCli LIKE gn-clie.Ruc    NO-UNDO.
DEF VAR C-TlfCli LIKE gn-clie.Telfnos[1] NO-UNDO.

DEF VAR C-NomAva LIKE gn-clie.nomcli NO-UNDO.
DEF VAR C-DirAva LIKE gn-clie.dircli NO-UNDO.
DEF VAR C-RucAva LIKE gn-clie.Ruc    NO-UNDO.
DEF VAR C-TlfAva LIKE gn-clie.Telfnos[1] NO-UNDO.
DEF VAR X-FECHAE  AS CHAR.
DEF VAR X-FECHAV  AS CHAR.

DEF VAR C-DESDIR as char format "x(20)".

FIND FIRST ccbcmvto WHERE ROWID(ccbcmvto) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcmvto THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
     gn-clie.codcli = ccbcmvto.codcli NO-LOCK.

FIND FIRST CCBDMVTO WHERE CCBDMVTO.codcia = ccbcmvto.codcia and
                          CCBDMVTO.nrodoc = ccbcmvto.nrodoc NO-LOCK NO-ERROR.

/* Definimos impresoras */
DEFINE VAR s-printer-list AS CHAR.
DEFINE VAR s-port-list AS CHAR.
DEFINE VAR s-port-name AS CHAR format "x(20)".
DEFINE VAR s-printer-count AS INTEGER.

/*RUN aderb/_prlist.p(
 *     OUTPUT s-printer-list,
 *     OUTPUT s-port-list,
 *     OUTPUT s-printer-count).
 * 
 * FIND FacCorre WHERE 
 *      FacCorre.CodCia = S-CODCIA AND 
 *      FacCorre.CodDiv = S-CODDIV AND
 *      FacCorre.CodDoc = ccbcmvto.coddoc AND
 *      FacCorre.NroSer = INTEGER(SUBSTRING(ccbcmvto.nrodoc, 1, 3)) NO-LOCK. 
 * 
 * IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
 *    MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
 *    RETURN.
 * END.
 * 
 * s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
 * s-port-name = REPLACE(S-PORT-NAME, ":", "").*/

DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.

/************************  PUNTEROS EN POSICION  *******************************/
DEFINE new SHARED VAR s-pagina-final AS INTEGER.
DEFINE new SHARED VAR s-pagina-inicial AS INTEGER.
DEFINE new SHARED VAR s-salida-impresion AS INTEGER.
DEFINE new SHARED VAR s-printer-name AS CHAR.
DEFINE new SHARED VAR s-print-file AS CHAR.
DEFINE new SHARED VAR s-nro-copias AS INTEGER.
DEFINE new SHARED VAR s-orientacion AS INTEGER.


DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/ccb/rbccb.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Letras".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "ccb\rbccb.prl".

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
         HEIGHT             = 1.69
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  
  FOR EACH CCBDMVTO NO-LOCK WHERE 
              CCBDMVTO.codcia = ccbcmvto.codcia AND
              CCBDMVTO.CodCli = ccbcmvto.codcli AND
              CcbDMvto.CodDoc = CcbcMvto.CodDoc AND
              CCBDMVTO.nrodoc = ccbcmvto.nrodoc AND
              CCBDMVTO.codRef = "LET"               
              BREAK BY ccbdmvto.nroref :

      RUN bin/_numero(ccbdmvto.imptot, 2, 1, OUTPUT X-EnLetras).
      X-EnLetras = X-EnLetras + (IF ccbcmvto.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
      X-FECHAE = STRING(DAY(CCBDMVTO.FCHEMI),"99") + "/" + STRING(MONTH(CCBDMVTO.FCHEMI),"99") + "/" + STRING(YEAR(CCBDMVTO.FCHEMI),"9999").
      X-FECHAV = STRING(DAY(CCBDMVTO.FCHVTO),"99") + "/" + STRING(MONTH(CCBDMVTO.FCHVTO),"99") + "/" + STRING(YEAR(CCBDMVTO.FCHVTO),"9999").
      IF ccbcmvto.codmon = 1 THEN  X-MONEDA = "S/.".
      ELSE X-MONEDA = "US$".
      ASSIGN C-NomCli = ""
             C-DirCli = ""
             C-DESDIR = "".
      FIND gn-clie WHERE 
           gn-clie.CodCia = cl-codcia AND 
           gn-clie.CodCli = CCBDMVTO.CodCli NO-LOCK NO-ERROR.
    
    
      IF AVAILABLE gn-clie THEN
         ASSIGN 
                C-NomCli = gn-clie.NomCli 
                C-DirCli = gn-clie.DirCli 
                C-RucCli = gn-clie.Ruc 
                C-TlfCli = gn-clie.Telfnos[1]
                
                C-NomAva = gn-clie.Aval1[1] 
                C-DirAva = gn-clie.Aval1[2] 
                C-RucAva = gn-clie.Aval1[3] 
                C-TlfAva = gn-clie.Aval1[4].
      
      IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no 
                                        AND  w-report.Llave-C = s-user-id 
                                        NO-LOCK)
        THEN LEAVE.
      END.
      CREATE w-report.
      ASSIGN
          w-report.Task-No = s-task-no
          w-report.Llave-C = s-user-id
          w-report.Campo-C[1] = ccbdmvto.NroRef 
          w-report.Campo-C[2] = ccbdmvto.codcli
          w-report.Campo-C[3] = X-FECHAE
          w-report.Campo-C[4] = X-FECHAV
          w-report.Campo-C[5] = X-MONEDA 
          w-report.Campo-C[6] = X-EnLetras 
          w-report.Campo-C[7] = C-NomCli 
          w-report.Campo-C[8] = C-RucCli
          w-report.Campo-C[9] = C-TlfCli
          w-report.Campo-C[10] = C-DirCli
          w-report.Campo-C[11] = C-NomAva 
          w-report.Campo-C[12] = C-Dirava 
          w-report.Campo-C[13] = C-RucAva
          w-report.Campo-C[14] = C-TlfAva
          w-report.Campo-F[1] = ccbdmvto.imptot.

/*                C-TlfAva
                C-DirAva           
                 
*/
          



 END.  
/* LOGICA PRINCIPAL */
/*  /* Pantalla general de parametros de impresion */
 *   RUN bin/_prnctr.p.
 *   IF s-salida-impresion = 0 THEN RETURN.*/

DEF VAR cRpta AS LOG NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE cRpta.
IF cRpta = NO THEN RETURN.
OUTPUT TO PRINTER.

    
  /* test de impresion */
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +
              " AND  w-report.Llave-C = '" + s-user-id + "'" .
  RB-OTHER-PARAMETERS = " ".

  /* Captura parametros de impresion */
  ASSIGN
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  
  RUN aderb/_printrb (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS).    
    
  FOR EACH w-report WHERE w-report.task-no = s-task-no 
                        AND  w-report.Llave-C = s-user-id:
                        DELETE w-report.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


