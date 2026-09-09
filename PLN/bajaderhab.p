&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* variables a usar */
DEF VAR c-01 AS CHAR FORMAT 'x(2)'.
DEF VAR c-02 AS CHAR FORMAT 'x(15)'.
DEF VAR c-03 AS CHAR FORMAT 'x(2)'.
DEF VAR c-04 AS CHAR FORMAT 'x(15)'.
DEF VAR c-05 AS CHAR FORMAT 'x(3)'.
DEF VAR c-06 AS CHAR FORMAT 'x(10)'.
DEF VAR c-07 AS CHAR FORMAT 'x(40)'.
DEF VAR c-08 AS CHAR FORMAT 'x(40)'.
DEF VAR c-09 AS CHAR FORMAT 'x(40)'.
DEF VAR c-10 AS CHAR FORMAT 'x(2)'.
DEF VAR c-11 AS CHAR FORMAT 'x(10)'.
DEF VAR c-12 AS CHAR FORMAT 'x(2)'.

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
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER s-codcia AS INT.
DEF INPUT PARAMETER s-Periodo AS INT.
DEF INPUT PARAMETER s-NroMes AS INT.
DEF INPUT PARAMETER s-codpln AS INT.

DEF VAR x-Archivo AS CHAR.
DEF VAR rpta AS LOG.
DEF STREAM REPORTE.

ASSIGN
    x-Archivo = 'RD_20100038146_' + STRING (DAY(TODAY), '99') +
    STRING (MONTH(TODAY), '99') +
    STRING (YEAR(TODAY), '9999') +
    '_BAJA.txt'.
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS '*.txt' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Alta de Derechohabientes'
    USE-FILENAME
    UPDATE rpta.

OUTPUT STREAM REPORTE TO VALUE(x-Archivo).
FOR EACH pl-flg-mes NO-LOCK WHERE codcia = s-codcia
    AND periodo = s-periodo
    AND nromes = s-nromes
    AND codpln = s-codpln,
    FIRST pl-pers OF pl-flg-mes NO-LOCK,
    EACH pl-dhabiente OF pl-flg-mes NO-LOCK WHERE pl-dhabiente.sitderhab = '11':    /* de Baja */
    /* limpiamos variables */
    ASSIGN
        c-01 = ''
        c-02 = ''
        c-03 = ''
        c-04 = ''
        c-05 = ''
        c-06 = ''
        c-07 = ''
        c-08 = ''
        c-09 = ''
        c-10 = ''
        c-11 = ''
        c-12 = ''.
    ASSIGN
        c-01 = '01'   /* DNI */
        c-02 = pl-pers.nrodocid
        c-03 = pl-dhabiente.tpodocid
        c-04 = pl-dhabiente.nrodocid
        c-05 = '604'
        c-06 = STRING (pl-dhabiente.fecnac, '99/99/9999')
        c-07 = pl-dhabiente.patper
        c-08 = pl-dhabiente.matper
        c-09 = pl-dhabiente.nomper.
    CASE pl-dhabiente.vinculofam:
        WHEN '1' THEN c-10 = '05'.
        WHEN '2' THEN c-10 = '02'.
        WHEN '3' THEN c-10 = '03'.
        WHEN '4' THEN c-10 = '04'.
        OTHERWISE c-10 = ''.
    END CASE.
    IF PL-DHABIENTE.NroRelDir <> '' AND PL-DHABIENTE.VinculoFam = '1' 
        THEN ASSIGN
                c-10 = '06'. /* Hijo mayor edad con incapaciadad */
    ASSIGN
        c-11 = STRING (pl-dhabiente.fchbaja, '99/99/9999')
        c-12 = STRING (INTEGER (pl-dhabiente.tpobaja), '99').
    PUT STREAM REPORTE
        c-01  '|'
        c-02  '|'
        c-03  '|'
        c-04  '|'
        c-05  '|'
        c-06  '|'
        c-07  '|'
        c-08  '|'
        c-09  '|'
        c-10  '|'
        c-11  '|'
        c-12  '|'
        SKIP.

END.
OUTPUT STREAM REPORTE CLOSE.

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


