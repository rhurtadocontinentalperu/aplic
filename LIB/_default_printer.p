&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Identifica la impresora por defecto

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* 1 */
DEF OUTPUT PARAMETER pPrinterName AS CHARACTER FORMAT "x(45)".
DEF OUTPUT PARAMETER pPortName AS CHARACTER FORMAT "x(20)".
DEF OUTPUT PARAMETER success AS LOGICAL.

/* 2 */
DEF VAR pPortList AS CHAR NO-UNDO.

RUN aderb/_prdef.p (OUTPUT pPrinterName, OUTPUT pPortList, OUTPUT success).

IF NOT pPortList BEGINS "LPT" THEN pPortList = REPLACE(pPortList, ":", "").
pPortName = pPortList.

/* CASE SESSION:WINDOW-SYSTEM:                                                 */
/*     WHEN "MS-WINXP" THEN pPortName = pPrinterName.                          */
/*     WHEN "MS-WIN95" THEN pPortName = pPortList.                             */
/* END CASE.                                                                   */

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
         HEIGHT             = 3.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


