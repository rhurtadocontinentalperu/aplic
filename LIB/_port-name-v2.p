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
         HEIGHT             = 3.92
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pPrinterName AS CHAR.
DEF OUTPUT PARAMETER pPortName   AS CHAR.

pPortName = ''.     /* Valor por defecto */

IF pPrinterName = '' THEN DO:
    MESSAGE 'No hay una impresora definida' SKIP
        'Revise la configuración de documentos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEF VAR cPrinterList  AS CHAR NO-UNDO.
DEF VAR cPortList     AS CHAR NO-UNDO.
DEF VAR iPrinterCount AS INT  NO-UNDO.

/* Lista de Impresoras */
RUN aderb/_prlist ( OUTPUT cPrinterList,
                    OUTPUT cPortList,
                    OUTPUT iPrinterCount ).
IF iPrinterCount = 0 THEN DO:
    MESSAGE 'No hay impresoras configuradas' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEF VAR cWindowSystem AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.

cWindowSystem = SESSION:WINDOW-SYSTEM.
iloop:
DO i = 1 TO iPrinterCount:
    IF INDEX(ENTRY(i, cPrinterList), pPrinterName) > 0 THEN DO:
        /* Se encontró una posible impresora */
        pPortName = ENTRY(i, cPortList).
        CASE cWindowSystem:
            WHEN "MS-WINXP" OR WHEN "MS-WIN95" THEN DO:
                /* Sistemas operativos: WinXP y Win7 */
                pPortName = ENTRY(i, cPrinterList).
            END.
            OTHERWISE DO:
/*             WHEN "MS-WIN95" THEN DO: */
                /* Sistemas operativos: Win Server */
                pPortName = ENTRY(i, cPortList).
            END.
        END CASE.
        /* Caso Impresión en Graphon */
        IF INDEX(ENTRY(i, cPrinterList),"@") > 0 THEN DO:
            pPortName = ENTRY(i, cPrinterList).
        END.
        IF NOT pPortName BEGINS 'LPT' THEN pPortName = REPLACE(pPortName, ":", "").
    END.
END.
IF pPortName = '' THEN DO:
   MESSAGE "Impresora" pPrinterName "NO está instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


