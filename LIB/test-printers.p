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
DEFINE VARIABLE s-pagina-final     AS INTEGER.
DEFINE VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE VARIABLE s-salida-impresion AS INTEGER.
DEFINE VARIABLE s-printer-name     AS CHARACTER.
DEFINE VARIABLE s-printer-port     AS CHARACTER.
DEFINE VARIABLE s-print-file       AS CHARACTER.
DEFINE VARIABLE s-nro-copias       AS INTEGER.
DEFINE VARIABLE s-orientacion      AS INTEGER.

DEFINE VARIABLE cPrinter-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPort-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPrinter-count AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

ASSIGN
    s-printer-name = ""
    s-printer-port = ""
    s-print-file = ""
    s-nro-copias = 1.


    RUN aderb/_prlist(
        OUTPUT cPrinter-list,
        OUTPUT cPort-list,
        OUTPUT iPrinter-count).

    MESSAGE cprinter-list SKIP
        cport-list SKIP
        iprinter-count.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


