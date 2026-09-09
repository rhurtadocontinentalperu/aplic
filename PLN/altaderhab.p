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
DEF VAR c-10 AS CHAR FORMAT 'x(1)'.
DEF VAR c-11 AS CHAR FORMAT 'x(2)'.
DEF VAR c-12 AS CHAR FORMAT 'x(2)'.
DEF VAR c-13 AS CHAR FORMAT 'x(20)'.
DEF VAR c-14 AS CHAR FORMAT 'x(6)'.
DEF VAR c-15 AS CHAR FORMAT 'x(2)'.
DEF VAR c-16 AS CHAR FORMAT 'x(20)'.
DEF VAR c-17 AS CHAR FORMAT 'x(4)'.
DEF VAR c-18 AS CHAR FORMAT 'x(4)'.
DEF VAR c-19 AS CHAR FORMAT 'x(4)'.
DEF VAR c-20 AS CHAR FORMAT 'x(4)'.
DEF VAR c-21 AS CHAR FORMAT 'x(4)'.
DEF VAR c-22 AS CHAR FORMAT 'x(4)'.
DEF VAR c-23 AS CHAR FORMAT 'x(4)'.
DEF VAR c-24 AS CHAR FORMAT 'x(4)'.
DEF VAR c-25 AS CHAR FORMAT 'x(2)'.
DEF VAR c-26 AS CHAR FORMAT 'x(20)'.
DEF VAR c-27 AS CHAR FORMAT 'x(40)'.
DEF VAR c-28 AS CHAR FORMAT 'x(6)'.
DEF VAR c-29 AS CHAR FORMAT 'x(2)'.
DEF VAR c-30 AS CHAR FORMAT 'x(20)'.
DEF VAR c-31 AS CHAR FORMAT 'x(4)'.
DEF VAR c-32 AS CHAR FORMAT 'x(4)'.
DEF VAR c-33 AS CHAR FORMAT 'x(4)'.
DEF VAR c-34 AS CHAR FORMAT 'x(4)'.
DEF VAR c-35 AS CHAR FORMAT 'x(4)'.
DEF VAR c-36 AS CHAR FORMAT 'x(4)'.
DEF VAR c-37 AS CHAR FORMAT 'x(4)'.
DEF VAR c-38 AS CHAR FORMAT 'x(4)'.
DEF VAR c-39 AS CHAR FORMAT 'x(2)'.
DEF VAR c-40 AS CHAR FORMAT 'x(20)'.
DEF VAR c-41 AS CHAR FORMAT 'x(40)'.
DEF VAR c-42 AS CHAR FORMAT 'x(6)'.
DEF VAR c-43 AS CHAR FORMAT 'x(1)'.
DEF VAR c-44 AS CHAR FORMAT 'x(2)'.
DEF VAR c-45 AS CHAR FORMAT 'x(10)'.
DEF VAR c-46 AS CHAR FORMAT 'x(50)'.

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
    '_ALTA.txt'.
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
    EACH pl-dhabiente OF pl-flg-mes NO-LOCK WHERE pl-dhabiente.sitderhab = '10':    /* Activos */
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
        c-12 = ''
        c-13 = ''
        c-14 = ''
        c-15 = ''
        c-16 = ''
        c-17 = ''
        c-18 = ''
        c-19 = ''
        c-20 = ''
        c-21 = ''
        c-22 = ''
        c-23 = ''
        c-24 = ''
        c-25 = ''
        c-26 = ''
        c-27 = ''
        c-28 = ''
        c-29 = ''
        c-30 = ''
        c-31 = ''
        c-32 = ''
        c-33 = ''
        c-34 = ''
        c-35 = ''
        c-36 = ''
        c-37 = ''
        c-38 = ''
        c-39 = ''
        c-40 = ''
        c-41 = ''
        c-42 = ''
        c-43 = ''
        c-44 = ''
        c-45 = ''
        c-46 = ''.

    ASSIGN
        c-01 = '01'   /* DNI */
        c-02 = pl-pers.nrodocid
        c-03 = pl-dhabiente.tpodocid
        c-04 = pl-dhabiente.nrodocid
        c-05 = '604'
        c-06 = STRING (pl-dhabiente.fecnac, '99/99/9999')
        c-07 = pl-dhabiente.patper
        c-08 = pl-dhabiente.matper
        c-09 = pl-dhabiente.nomper
        c-10 = pl-dhabiente.sexo.
    CASE pl-dhabiente.vinculofam:
        WHEN '1' THEN c-11 = '05'.
        WHEN '2' THEN c-11 = '02'.
        WHEN '3' THEN c-11 = '03'.
        WHEN '4' THEN c-11 = '04'.
        OTHERWISE c-11 = ''.
    END CASE.
    CASE PL-DHABIENTE.TpoDocPat:
        WHEN '1' THEN c-12 = '01'.
        WHEN '2' THEN c-12 = '03'.
        WHEN '3' THEN c-12 = '02'.
        OTHERWISE c-12 = ''.
    END CASE.
    ASSIGN 
        c-13 = PL-DHABIENTE.NroDocPat.
    IF PL-DHABIENTE.NroRelDir <> '' AND PL-DHABIENTE.VinculoFam = '1' 
        THEN ASSIGN
                c-11 = '06' /* Hijo mayor edad con incapaciadad */
                c-12 = '04'
                c-13 = PL-DHABIENTE.NroRelDir.
    IF ( c-11 = '05' AND c-03 = '01' )      /* Hijo menor de edad con DNI */
        OR ( c-11 <> '05' AND LOOKUP(c-03, '07,04') > 0 )   /* Pasaporte o carnet de extranjeria */
    THEN ASSIGN
            c-15 = pl-dhabiente.tpovia
            c-16 = pl-dhabiente.nomvia
            c-17 = pl-dhabiente.nrovia
            c-19 = pl-dhabiente.intvia
            c-25 = pl-dhabiente.tpozon
            c-26 = pl-dhabiente.nomzon
            c-27 = pl-dhabiente.dirreferen
            c-28 = '01'.    /* Lima */
    ASSIGN
        c-43 = '1'
        c-44 = '1'
        c-45 = pl-pers.telefo
        c-46 = pl-pers.e-mail.
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
        c-13  '|'
        c-14  '|'
        c-15  '|'
        c-16  '|'
        c-17  '|'
        c-18  '|'
        c-19  '|'
        c-20  '|'
        c-21  '|'
        c-22  '|'
        c-23  '|'
        c-24  '|'
        c-25  '|'
        c-26  '|'
        c-27  '|'
        c-28  '|'
        c-29  '|'
        c-30  '|'
        c-31  '|'
        c-32  '|'
        c-33  '|'
        c-34  '|'
        c-35  '|'
        c-36  '|'
        c-37  '|'
        c-38  '|'
        c-39  '|'
        c-40  '|'
        c-41  '|'
        c-42  '|'
        c-43  '|'
        c-44  '|'
        c-45  '|'
        c-46  '|'
        SKIP.

END.
OUTPUT STREAM REPORTE CLOSE.

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


