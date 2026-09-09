&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-ImpPed.p
    Purpose     : Impresion de Pedidos y Cotizaciones

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/*DEFINE INPUT PARAMETER X-ROWID AS ROWID.*/
DEFINE SHARED VARIABLE  S-USER-ID AS CHAR.
DEFINE INPUT  PARAMETER s-task-no AS INT.
DEFINE OUTPUT PARAMETER xxx       AS LOGICAL.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR cl-CODCIA AS INTEGER.
DEF SHARED VAR s-codalm  AS CHAR.
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter LIKE ccbcterm.codter.
DEF SHARED VAR S-NomCia AS CHAR.
DEF        VAR C-NomVen AS CHAR FORMAT "X(30)".
DEF        VAR C-Moneda AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF        VAR C-TitDoc AS CHAR FORMAT "X(50)".
DEF        VAR XD AS CHAR FORMAT "X(2)".
DEF        VAR I-NroItm AS INTEGER.
DEF        VAR F-PreNet AS DECIMAL.
DEF        VAR W-DIRALM AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM AS CHAR FORMAT "X(13)".
DEF        VAR F-Pesmat AS DECIMAL NO-UNDO.

DEFINE STREAM Reporte.

FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN RETURN.

C-TitDoc = "". 
                
DEFINE FRAME F-Deta
    w-report.llave-c    FORMAT "X(6)"
    almmmatg.desmat     
    almmmatg.desmar
    w-report.Campo-C[2] FORMAT "X(3)"
    w-report.Campo-F[1] FORMAT ">>,>>>,>>9.99"
    w-report.Campo-F[2] FORMAT ">>,>>>,>>9.99"
    w-report.Campo-F[3] FORMAT ">>,>>>,>>9.99"
    /*WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.*/
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.

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
         HEIGHT             = 2
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
/* Definimos impresoras */

DEF VAR rpta AS LOG NO-UNDO.
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
xxx = rpta.
IF rpta = NO THEN RETURN.

DEFINE FRAME F-HdrOD
    HEADER   
    {&PRN7A} + 'IMPRESION DIFENRENCIA EN PICKING' + {&PRN7B} + {&PRN3} AT 20 FORMAT "X(50)"  SKIP(2)
    "FECHA     : " TODAY 
    "PEDIDO    : " AT 70 w-report.Campo-C[1] FORMAT 'XXXXXXXXX' SKIP    
    "---------------------------------------------------------------------------------------------------------------------------" SKIP
    " CODIGO   D E S C R I P C I O N                        MARCA          UND    CANT. PED        CANT PICK      CANT DIF      " SKIP
    "---------------------------------------------------------------------------------------------------------------------------" SKIP
    /*
      xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxx ">>,>>>,>>9.99" ">>,>>>,>>9.99" ">>,>>>,>>9.99"
    */

    /*WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.*/
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.         
/*    
OUTPUT TO PRINTER PAGE-SIZE 60.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(35) + {&PRN3}.     
PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     
*/
OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 64.
PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}. 

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK
    BREAK BY w-report.llave-c:
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = w-report.Llave-C  NO-LOCK NO-ERROR.
    IF FIRST (w-report.llave-c) THEN VIEW STREAM Reporte FRAME F-HdrOD.

    DISPLAY STREAM Reporte
        w-report.llave-c
        almmmatg.desmat     FORMAT 'X(40)'
        almmmatg.desmar     FORMAT 'X(20)'
        w-report.Campo-C[2]
        w-report.Campo-F[1]
        w-report.Campo-F[2]
        w-report.Campo-F[3]
        WITH FRAME f-Deta.
END.

PUT STREAM Reporte SKIP(8).
PUT STREAM Reporte "-----------------------------" AT 15.
PUT STREAM Reporte "Administrador" AT 20 .

OUTPUT STREAM Reporte CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


