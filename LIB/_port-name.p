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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fCentrado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCentrado Procedure 
FUNCTION fCentrado RETURNS CHARACTER
  ( INPUT pDatos AS CHAR, INPUT pWidth AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 3.58
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER s-printer-name AS CHAR.
DEF OUTPUT PARAMETER s-port-name   AS CHAR.

DEF VAR s-printer-list  AS CHAR NO-UNDO.
DEF VAR s-port-list     AS CHAR NO-UNDO.
DEF VAR s-printer-count AS INT  NO-UNDO.

s-port-name = ''.

IF s-printer-name = '' THEN DO:
    MESSAGE 'No hay una impresora definida' SKIP
        'Revise la configuración de documentos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Definimos impresoras */
RUN aderb/_prlist ( OUTPUT s-printer-list,
                    OUTPUT s-port-list,
                    OUTPUT s-printer-count ).

IF s-printer-count = 0 THEN DO:
    MESSAGE 'No hay impresoras configuradas' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEF VAR x-OpSys AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.

GET-KEY-VALUE SECTION 'Startup' KEY 'OpSysVersion' VALUE x-OpSys.

/* CASE x-OpSys:             */
/*     WHEN 'WINNT' THEN DO: */
       /*MESSAGE 'uno' x-opsys SKIP s-printer-count SKIP s-printer-list SKIP s-port-name.*/
        iloop:
        DO i = 1 TO s-printer-count:
            IF INDEX(ENTRY(i, s-printer-list), s-printer-name) > 0
            THEN DO:
                /* Caso Impresión en Graphon */
                IF INDEX(s-printer-list,"@") > 0 THEN DO:
                    s-port-name = ENTRY(i, s-printer-list).
                    s-port-name = REPLACE(S-PORT-NAME, ":", "").
                    IF NUM-ENTRIES(s-port-name, "-") > 2 THEN LEAVE iloop.
                END.
                /* Caso Windows XP */
                ELSE DO:
                    s-port-name = ENTRY(i, s-port-list).
                    s-port-name = REPLACE(S-PORT-NAME, ":", "").
                    IF LOOKUP(s-port-name, 'LPT1,LPT2,LPT3,LPT4,LPT5,LPT6') = 0 THEN s-port-name = ENTRY(i, s-printer-list).
                    IF NUM-ENTRIES(s-port-name, "-") > 1 THEN LEAVE iloop.
                END.
            END.
        END.
        IF s-port-name = '' THEN DO:
           MESSAGE "Impresora" s-printer-name "NO está instalada" VIEW-AS ALERT-BOX ERROR.
           RETURN.
        END.
/*     END.                                                                                   */
/*     OTHERWISE DO:                                                                          */
/*         IF LOOKUP(s-printer-name, s-printer-list) = 0 THEN DO:                             */
/*            MESSAGE "Impresora" s-printer-name "NO está instalada" VIEW-AS ALERT-BOX ERROR. */
/*            RETURN.                                                                         */
/*         END.                                                                               */
/*         s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).          */
/*         s-port-name = REPLACE(S-PORT-NAME, ":", "").                                       */
/*     END.                                                                                   */
/* END CASE.                                                                                  */

/* Caso Impresión en Graphon */
/*MESSAGE 'dos' s-printer-list SKIP s-port-name.*/
IF INDEX(s-port-name,"@") > 0 THEN DO:
    IF NUM-ENTRIES(s-port-name, "-") > 2 THEN
        s-port-name =
            "\\" +
            TRIM(ENTRY(2, s-port-name, "-")) +
            "\" +
            TRIM(ENTRY(1, s-port-name, "-")).
    ELSE DO:
        IF NUM-ENTRIES(s-port-name, "-") > 1 THEN
            s-port-name =
                "\\" +
                TRIM(ENTRY(2, s-port-name, '@')) +
                "\" +
                TRIM(ENTRY(1, s-port-name, "-")).
    END.
END.

/* MESSAGE s-printer-list SKIP  */
/*         s-port-list SKIP     */
/*         s-printer-count SKIP */
/*         s-port-name.         */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fCentrado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCentrado Procedure 
FUNCTION fCentrado RETURNS CHARACTER
  ( INPUT pDatos AS CHAR, INPUT pWidth AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lDato AS CHAR.
    DEFINE VAR lRetVal AS CHAR.                                                
    DEFINE VAR lLenDato AS INT.

    lDato = TRIM(pdatos).
    lLenDato = LENGTH(lDato).
    IF LENGTH(lDato) <= pWidth THEN DO:
        lRetVal = FILL(" ", INTEGER(pWidth / 2) - INTEGER(lLenDato / 2) ) + lDato.
    END.
    ELSE lRetVal = SUBSTRING(lDato,1,pWidth).

  RETURN lRetVal.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

