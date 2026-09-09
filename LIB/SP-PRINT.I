&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : 
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
DEFINE NEW SHARED VARIABLE s-pagina-final     AS INTEGER.
DEFINE NEW SHARED VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE NEW SHARED VARIABLE s-salida-impresion AS INTEGER.
DEFINE NEW SHARED VARIABLE s-printer-name     AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-print-file       AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-nro-copias       AS INTEGER.
DEFINE NEW SHARED VARIABLE s-orientacion      AS INTEGER.

DEFINE STREAM S-OUT.

DEFINE VARIABLE s-Program-Name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE s-Page-Width    AS INTEGER   NO-UNDO.
DEFINE VARIABLE s-Page-Height   AS INTEGER   NO-UNDO.
DEFINE VARIABLE s-stop-report   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE s-Page-Header   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE s-Page-Number   AS INTEGER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-CONTROL-PAGINA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CONTROL-PAGINA Method-Library 
PROCEDURE CONTROL-PAGINA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF LINE-COUNTER( s-out ) > s-Page-Height  
    THEN DO:
        RUN IMPRIMIR-PAGINA-FIN.
        PAGE STREAM s-out.
        s-Page-Header = Yes.
    END.
    IF s-Page-Header
    THEN DO:
        s-Page-Number  = s-Page-Number + 1.

        IF s-Page-Number > s-Pagina-Final THEN RETURN ERROR.

        IF s-Page-Number = s-Pagina-Inicial THEN RUN IMPRIMIR-INICIO( TRUE ).

        DISPLAY s-Page-Number @ f-Page-Number WITH frame {&FRAME-NAME}.

        RUN IMPRIMIR-PAGINA-INICIO.
    END.
    s-Page-Header = No.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-IMPRIMIR-FIN) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR-FIN Method-Library 
PROCEDURE IMPRIMIR-FIN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OUTPUT STREAM S-OUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-IMPRIMIR-INICIO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR-INICIO Method-Library 
PROCEDURE IMPRIMIR-INICIO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER s-start-page AS LOGICAL NO-UNDO.

IF NOT s-start-page
THEN DO:
    OUTPUT STREAM S-OUT CLOSE.
    OUTPUT STREAM S-OUT TO NUL PAGED PAGE-SIZE 1000.
END.
ELSE 
DO:
    OUTPUT STREAM S-OUT CLOSE.
    OUTPUT STREAM S-OUT TO VALUE( s-print-file ) PAGED  PAGE-SIZE 1000.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-VISUALIZACION) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VISUALIZACION Method-Library 
PROCEDURE VISUALIZACION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CASE  s-salida-impresion:
    WHEN 1 THEN RUN APLIC/LIB/W-README.W( s-print-file  ).
    WHEN 2 THEN DO:
            DEFINE VARIABLE IX  AS INTEGER NO-UNDO.
            DEFINE VARIABLE COMANDO AS CHARACTER NO-UNDO.
            COMANDO = "TYPE " + s-print-file  + " >" + SESSION:PRINTER-PORT.
            DO ix = 1 TO s-nro-copias:
                OS-COMMAND SILENT VALUE( COMANDO ).
            END.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

