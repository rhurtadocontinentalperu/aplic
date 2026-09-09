&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS INTEGER.

DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHARACTER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHARACTER.
DEFINE SHARED VAR pv-CODCIA AS INTEGER.

DEFINE VARIABLE X-DESPRO AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESART AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESMAR AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-UNDVTA AS CHARACTER FORMAT "X(6)".
DEFINE VARIABLE X-NRO AS CHARACTER FORMAT "X(6)".
DEFINE VARIABLE X-DESALM AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESMAQ AS CHARACTER FORMAT "X(50)".

DEFINE STREAM Reporte.

FIND w-report WHERE w-report.task-no = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN RETURN.

FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia AND
                    Almmmatg.CodMat = w-report.Campo-C[3] NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN DO:
   X-DESART = Almmmatg.DesMat.
   X-DESMAR = Almmmatg.DesMat. 
   X-UNDVTA = Almmmatg.UndBas.
END.   
FIND Almacen WHERE Almacen.Codcia = S-CODCIA AND
                   Almacen.CodAlm = w-report.Campo-C[1]
                   No-LOCK No-ERROR.
IF AVAILABLE Almacen THEN X-DESALM = Almacen.Descripcion.

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
         HEIGHT             = 2.19
         WIDTH              = 36.43.
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
/*MLR* 26/11/07 ***
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).
* ***/

DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.


DEFINE FRAME F-DetaOD
    w-report.Campo-I[2] 
    w-report.Campo-C[2] FORMAT "X(8)"
    w-report.Campo-C[3] FORMAT "X(8)"
    Almmmatg.DesMat     FORMAT "X(40)"
    Almmmatg.DesMar     FORMAT "X(20)"
    Almmmatg.UndBas     FORMAT "X(3)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

DEFINE FRAME F-FtrOD
    HEADER
    {&PRN7A} + "LISTADO DE INVENTARIO" + {&PRN7B} + {&PRN3} AT 60 FORMAT "X(30)" SKIP
    'Almacen : ' AT 2 w-report.Campo-C[1] FORMAT 'X(5)' Almacen.Descripcion FORMAT "X(60)"  SKIP
    "Inventariador" AT 80 SKIP 
    "-----------------------------------------------------------------------------------------------------------------------" SKIP
    "Nro  Ubicación Código   Descripción                     Marca           Uni  Conteo     Ctos   Doc   Und   Observacion  " SKIP
    "-----------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.

DEFINE FRAME F-Footer
    HEADER
    "------------------------" AT 40 
    "------------------------" AT 100 SKIP
    "Almacenero" AT 48 
    "Almacenero" AT 112 SKIP    
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 160.


   OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 64.
   PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     

   VIEW STREAM Reporte FRAME F-Orden.

   FOR EACH w-report NO-LOCK
        BREAK BY w-report.Campo-C[1]
            BY w-report.Campo-I[1]
            BY w-report.Campo-I[2]:
    
        IF FIRST-OF (w-report.Campo-C[1]) THEN VIEW FRAME F-FtrOD.
    
        FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-codcia
            AND Almmmatg.CodMat = w-report.Campo-C[3] NO-LOCK NO-ERROR.
        DISPLAY STREAM Reporte
            w-report.Campo-I[2] 
            w-report.Campo-C[2] 
            w-report.Campo-C[3] 
            Almmmatg.DesMat
            Almmmatg.DesMar
            Almmmatg.UndBas WITH FRAME F-DetaOD.
        IF LAST-OF (w-report.Campo-C[1]) THEN VIEW FRAME F-Footer.
    END.
  OUTPUT STREAM Reporte CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


