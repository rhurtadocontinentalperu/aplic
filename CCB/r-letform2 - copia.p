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
         HEIGHT             = 3.35
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
    PUT CONTROL {&Prn0} + {&Prn5A} + CHR(27) + {&Prn4}.
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
            SPACE(25) campo-c[1]  FORMAT "XXX-XXXXXXXXX"
            SPACE(8)  campo-c[2]  FORMAT "XXXXXXXXXXXX"
            SPACE(15) "LIMA"
            SPACE(12) campo-d[1]  FORMAT "99/99/9999"
            SPACE(10) campo-d[2]  FORMAT "99/99/9999"
            SPACE(10) campo-c[3]  FORMAT "XXX"
            campo-f[1] FORMAT ">>>,>>>,>>9.99"
            SKIP(3).
        PUT UNFORMATTED
            SPACE(28) campo-c[4]  SKIP(1.8) 
            SPACE(40) campo-c[5]  SKIP
            SPACE(40) campo-c[20] SKIP(1)
            SPACE(40) campo-c[7]  SPACE(20) campo-c[8] SKIP
            SPACE(40) campo-c[21] SPACE(20) campo-c[22] SKIP
            SPACE(31) campo-c[6]  SKIP
            SPACE(31) campo-c[23].
            
        PUT SKIP (1.5)
            SKIP (0.3).   /*1*/
        PUT UNFORMATTED
            SPACE(40) campo-c[9]  SKIP
            SPACE(40) campo-c[13] SKIP
            SPACE(38) campo-c[16] SPACE(30) campo-c[12] SKIP
            SPACE(38) campo-c[17] SPACE(35) SKIP
            SPACE(38) campo-c[10] .
        PAGE.
    END.

END PROCEDURE.

/*
    FOR EACH w-report WHERE
        Task-No = para_task-no AND
        Llave-C = para_user-id NO-LOCK:

        IF TRIM(campo-c[2]) = "-" THEN cGuion = "    -".
        ELSE cGuion = campo-c[2].

        PUT
            SKIP(3)
            SPACE(25) campo-c[1]  FORMAT "XXX-XXXXXXXXX"
            SPACE(8)  campo-c[2]  FORMAT "XXXXXXXXXXXX"
            SPACE(15) "LIMA"
            SPACE(12) campo-d[1]  FORMAT "99/99/9999"
            SPACE(10) campo-d[2]  FORMAT "99/99/9999"
            SPACE(10) campo-c[3]  FORMAT "XXX"
            campo-f[1]
            SKIP(2.1)
            SKIP(0.3).
        PUT UNFORMATTED
            SPACE(28) campo-c[4]  SKIP(1.8) 
            SPACE(40) campo-c[5]  SKIP(1) 
            SPACE(40) campo-c[7]  SPACE(20) campo-c[8] SKIP(1.5)
            SPACE(31) campo-c[6]  .
            
        PUT SKIP (2)
            SKIP (0.3).   /*1*/
        PUT UNFORMATTED
            SPACE(40) campo-c[9]  SKIP
            SPACE(40) campo-c[13] SKIP
            SPACE(38) campo-c[16] SPACE(30) campo-c[12] SKIP
            SPACE(38) campo-c[17] SPACE(35) SKIP
            SPACE(38) campo-c[10] .
        PAGE.
    END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

