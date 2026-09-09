&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : p-bgrg_r.p
    Purpose     : Avisa que una guia de remision está para facturar

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 6.38
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF SHARED VAR s-CodCia AS INT .
DEF SHARED VAR s-codcli AS CHAR .
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF STREAM REPORTE.
DEF VAR OK-WAIT-STATE AS LOG NO-UNDO.

DEFINE VARIABLE dimp AS DECIMAL     NO-UNDO.

s-CodCia = INTEGER(SESSION:PARAMETER).
s-codcia = 001.
DEF VAR s-Titulo AS CHAR INIT 'CIA. NO IDENTIFICADA' NO-UNDO FORMAT 'x(70)'.

FIND GN-CIAS WHERE GN-CIAS.CodCia = s-CodCia NO-LOCK NO-ERROR.
IF AVAILABLE GN-CIAS THEN s-Titulo = TRIM(GN-CIAS.NomCia) + 
                                    ': ESTADISTICA DE VENTAS 1 AL 31 Marzo 2010'.

/* loop buscando informacion nueva */
x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".
OK-WAIT-STATE = NO.
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
DISPLAY STREAM REPORTE "CONTINENTAL - ESTADISTICA DE VENTAS 1 AL 31 Marzo 2010".
FOR EACH w-report WHERE w-report.task-no = 9900
    AND w-report.llave-c = s-codcli NO-LOCK,
    FIRST almmmatg WHERE almmmatg.codcia = 1
        AND almmmatg.codmat = w-report.campo-c[1] NO-LOCK
        BREAK BY w-report.task-no
              BY w-report.llave-c
              BY w-report.campo-c[1]:
    DISPLAY STREAM REPORTE
        w-report.campo-c[1] COLUMN-LABEL 'Codigo'
        almmmatg.desmat
        almmmatg.desmar
        w-report.campo-f[1] COLUMN-LABEL 'Cantidad'
        w-report.campo-f[2] COLUMN-LABEL 'Importe'
        WITH STREAM-IO NO-BOX WIDTH 320.
    dimp = dimp + w-report.campo-f[2].
    PAUSE 0.
    OK-WAIT-STATE = YES.    
    /*DISPLAY 'Cargando Información ' WITH FRAME f-mensaje.*/
END.

PUT STREAM reporte dimp AT 108.

OUTPUT STREAM REPORTE CLOSE.
IF OK-WAIT-STATE = YES THEN RUN lib/w-readme (x-Archivo).
OS-DELETE VALUE (x-Archivo).
 .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


