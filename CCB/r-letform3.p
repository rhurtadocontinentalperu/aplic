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

DEFINE INPUT PARAMETER para_task-no AS INTEGER.
DEFINE INPUT PARAMETER para_user-id AS CHARACTER.

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
         HEIGHT             = 5.15
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

DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

RUN lib/Imprimir2.
IF s-salida-impresion = 0 THEN RETURN.

IF s-salida-impresion = 1 THEN 
    s-print-file = SESSION:TEMP-DIRECTORY +
    STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN
            OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 54.
        WHEN 2 THEN
            OUTPUT TO PRINTER PAGED PAGE-SIZE 54. /* Impresora */
    END CASE.
    PUT CONTROL {&Prn0} + {&Prn5A} + CHR(28) + {&Prn4}.
    RUN Formato.
    OUTPUT CLOSE.
END.
OUTPUT CLOSE.

CASE s-salida-impresion:
    WHEN 1 OR WHEN 3 THEN DO:
        RUN LIB/W-README.R(s-print-file).
        IF s-salida-impresion = 1 THEN
            OS-DELETE VALUE(s-print-file).
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Formato) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato Procedure 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cGuion AS CHARACTER NO-UNDO.

    FOR EACH w-report WHERE
        Task-No = para_task-no AND
        Llave-C = para_user-id NO-LOCK:

        IF TRIM(campo-c[2]) = "-" THEN cGuion = "    -".
        ELSE cGuion = campo-c[2].

        PUT
            SKIP(3)
            campo-c[1] FORMAT "XXX-XXXXXXXXX"   AT 25
            campo-c[2]  FORMAT "XXXXXXXXXXXX"   AT 46
            "LIMA"                              AT 65
            campo-c[3]  FORMAT "XXX"            AT 125 
            campo-f[1]                          SKIP
            campo-d[1]  FORMAT "99/99/9999"     AT 85
            campo-d[2]  FORMAT "99/99/9999"     AT 105
            SKIP(1.5).
        PUT UNFORMATTED
            campo-c[4]                          AT 28 SKIP(1) 
            campo-c[5]                          AT 40 SKIP(1) 
            campo-c[7]                          AT 40
            campo-c[8]                          AT 65 SKIP(1)
            campo-c[6]                          AT 40 SKIP(2).
        PUT UNFORMATTED
            campo-c[9]          AT 35 SKIP(1)
            campo-c[11]         AT 35 
            campo-c[12]         AT 65 SKIP(1)
            campo-c[10]         AT 35.
        PAGE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

