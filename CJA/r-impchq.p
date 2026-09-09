&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------

  ------------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER R-ROWID AS ROWID.
DEFINE SHARED VARIABLE s-user-id   AS CHARACTER.
DEFINE SHARED VARIABLE s-nomcia    AS CHARACTER FORMAT "X(50)".

FIND cb-cmov WHERE ROWID(cb-cmov) = R-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cmov THEN RETURN.
IF cb-cmov.ImpChq <= 0 THEN DO:
   MESSAGE "Verifique Importe del Cheque "
           VIEW-AS ALERT-BOX ERROR.
   RETURN.        
END.
DEFINE VARIABLE x-pos       AS INTEGER   NO-UNDO.
DEFINE VARIABLE x-nota1     AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-nota2     AS CHARACTER NO-UNDO.
DEFINE VARIABLE s-task-no   AS INTEGER   NO-UNDO.
DEFINE VARIABLE x-EnLetras  AS CHARACTER FORMAT "x(70)" NO-UNDO.
DEFINE VARIABLE x-girador   AS CHARACTER FORMAT "x(50)" NO-UNDO.

DEFINE VARIABLE RB-REPORT-LIBRARY AS CHAR. 
DEFINE VARIABLE RB-REPORT-NAME AS CHAR .
DEFINE VARIABLE RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEFINE VARIABLE RB-FILTER AS CHAR INITIAL "".
DEFINE VARIABLE RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEFINE VARIABLE RB-DB-CONNECTION AS CHAR INITIAL "".
DEFINE VARIABLE RB-MEMO-FILE AS CHAR INITIAL "".
DEFINE VARIABLE RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEFINE VARIABLE RB-PRINTER-NAME AS CHAR INITIAL "".
DEFINE VARIABLE RB-PRINTER-PORT AS CHAR INITIAL "".
DEFINE VARIABLE RB-OUTPUT-FILE AS CHAR INITIAL "".
DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEFINE VARIABLE RB-END-PAGE AS INTEGER INITIAL 0.
DEFINE VARIABLE RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEFINE VARIABLE RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEFINE VARIABLE RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEFINE VARIABLE RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEFINE VARIABLE RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEFINE VARIABLE S-REPORT-LIBRARY AS CHARACTER.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "cja\rbcja.prl".

FIND FIRST cb-ctas WHERE cb-ctas.codcta = cb-cmov.ctacja NO-LOCK NO-ERROR.
IF AVAILABLE cb-ctas THEN x-girador = cb-ctas.sector.

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
         HEIGHT             = 10.31
         WIDTH              = 39.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* Pantalla general de parametros de impresion */
/*RUN bin/_prnctr.p.*/
RUN lib/Imprimir2.
IF s-salida-impresion = 0 THEN RETURN.
  
RUN bin/_numero(cb-cmov.Impchq, 2, 1, OUTPUT X-EnLetras).
x-Enletras = X-Enletras + "" + FILL("*",70 - LENGTH(TRIM(X-Enletras))).

x-pos = R-INDEX(cb-cmov.NotAst,",").
x-nota1 = IF x-pos > 0 THEN SUBSTRING(cb-cmov.NotAst,1,x-pos - 1) ELSE cb-cmov.NotAst.
x-nota2 = IF x-pos > 0 THEN SUBSTRING(cb-cmov.NotAst,x-pos + 1) ELSE "".
 
s-task-no = RANDOM(1, 999999).

CREATE w-report.
ASSIGN
  w-report.task-no    = s-task-no
  w-report.llave-C    = s-user-id
  w-report.Campo-F[1] = cb-cmov.ImpChq
  w-report.Campo-C[1] = STRING(DAY(cb-cmov.fchAst),"99")
  w-report.Campo-C[2] = STRING(MONTH(cb-cmov.fchAst),"99")
  w-report.Campo-C[3] = STRING(YEAR(cb-cmov.fchAst),"9999")  
  w-report.campo-C[4] = cb-cmov.Girado
  w-report.campo-C[5] = x-enletras
/*MLR* A pedido del Sr. Walter Alegre ***
  w-report.campo-C[6] = TRIM(x-nota1)
* ***/
  w-report.campo-C[7] = TRIM(x-nota2)
  w-report.campo-C[8] = cb-cmov.nroast
  w-report.campo-C[9] = x-girador
/*MLR* A pedido del Sr. Walter Alegre ***
  w-report.campo-C[10] = s-nomcia
* ***/
  .

  /* test de impresion */
  RB-INCLUDE-RECORDS  = "O".
  RB-FILTER           = "w-report.task-no = " + STRING(s-task-no) +
                        " AND w-report.Llave-C = '" + s-user-id + "'".
  RB-OTHER-PARAMETERS = " ".
  RB-REPORT-NAME      = cb-cmov.ctacja.

  /* Captura parametros de impresion */
  ASSIGN
   RB-BEGIN-PAGE    = s-pagina-inicial
   RB-END-PAGE      = s-pagina-final
   RB-PRINTER-NAME  = s-printer-name
   RB-OUTPUT-FILE   = s-print-file
   RB-NUMBER-COPIES = s-nro-copias.

  CASE s-salida-impresion:
    WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
    WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
    WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.

  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

/*   RUN aderb/_prntrb2 (RB-REPORT-LIBRARY, */
/*                   RB-REPORT-NAME,        */
/*                   RB-DB-CONNECTION,      */
/*                   RB-INCLUDE-RECORDS,    */
/*                   RB-FILTER,             */
/*                   RB-MEMO-FILE,          */
/*                   RB-PRINT-DESTINATION,  */
/*                   RB-PRINTER-NAME,       */
/*                   RB-PRINTER-PORT,       */
/*                   RB-OUTPUT-FILE,        */
/*                   RB-NUMBER-COPIES,      */
/*                   RB-BEGIN-PAGE,         */
/*                   RB-END-PAGE,           */
/*                   RB-TEST-PATTERN,       */
/*                   RB-WINDOW-TITLE,       */
/*                   RB-DISPLAY-ERRORS,     */
/*                   RB-DISPLAY-STATUS,     */
/*                   RB-NO-WAIT,            */
/*                   RB-OTHER-PARAMETERS,   */
/*                   "").                   */

  FOR EACH w-report WHERE w-report.task-no = s-task-no AND  
      w-report.Llave-C = s-user-id:
      DELETE w-report.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


