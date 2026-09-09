&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE s-printer-list  AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-list     AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-name     AS CHAR FORMAT "X(20)" NO-UNDO.
DEFINE VARIABLE s-printer-count AS INTEGER NO-UNDO.

DEFINE NEW SHARED VAR s-pagina-final     AS INTEGER.
DEFINE NEW SHARED VAR s-pagina-inicial   AS INTEGER.
DEFINE NEW SHARED VAR s-salida-impresion AS INTEGER.
DEFINE NEW SHARED VAR s-printer-name     AS CHAR.
DEFINE NEW SHARED VAR s-print-file       AS CHAR.
DEFINE NEW SHARED VAR s-nro-copias       AS INTEGER.
DEFINE NEW SHARED VAR s-orientacion      AS INTEGER.

DEFINE STREAM REPORT.

&GLOBAL-DEFINE Prn0 CHR(27) + CHR(64)
&GLOBAL-DEFINE Prn1 CHR(18) + CHR(27) + CHR(80)
&GLOBAL-DEFINE Prn2 CHR(18) + CHR(64) + CHR(77)
&GLOBAL-DEFINE Prn3 CHR(27) + CHR(80) + CHR(15)
&GLOBAL-DEFINE Prn4 CHR(27) + CHR(77) + CHR(15)
&GLOBAL-DEFINE Prn5A CHR(27) + CHR(67)
&GLOBAL-DEFINE Prn5B ""
&GLOBAL-DEFINE Prn6A CHR(27) + CHR(71)
&GLOBAL-DEFINE Prn6B CHR(27) + CHR(72)
&GLOBAL-DEFINE Prn7A CHR(14)
&GLOBAL-DEFINE Prn7B CHR(20)
&GLOBAL-DEFINE Prn8A CHR(27) + CHR(48)
&GLOBAL-DEFINE Prn8B CHR(27) + CHR(50)
&GLOBAL-DEFINE Prn9A CHR(27) + CHR(119) + "1"
&GLOBAL-DEFINE Prn9AB CHR(27) + CHR(119) + "0"

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


