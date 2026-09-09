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
         HEIGHT             = 4.96
         WIDTH              = 53.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodDiv AS CHAR.                                    
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pResumen AS CHAR.

DEFINE VARIABLE x-ProPro AS DECIMAL     NO-UNDO.
DEFINE VARIABLE x-ProFot AS DECIMAL     NO-UNDO.
DEFINE VARIABLE x-ProOtr AS DECIMAL     NO-UNDO.

/* 09Jul2013 - Ic */ 
DEFINE VARIABLE x-Pesos AS DECIMAL     NO-UNDO.
DEFINE VARIABLE x-Volumen AS DECIMAL     NO-UNDO.

/* CALCULO DEL STOCK COMPROMETIDO */
DEF SHARED VAR s-codcia AS INT.

/*CUENTA ARTICULOS POR FAMILIA*/
ASSIGN
    x-ProPro = 0
    x-ProFot = 0
    x-ProOtr = 0
    x-Pesos = 0
    x-Volumen = 0.
    
/*    16Ago2013 - Ic
    El documento lo buscamos solo por CodCia - Codigo - Nro
    no incluimos la division por que habian casos que las guias
    son emitidas x otra division que no es igual a la division de la H/R
*/

DEF BUFFER B-CcbDDocu FOR CcbDDocu.

FOR EACH CcbDDocu WHERE ccbddocu.codcia = s-codcia
    AND ccbddocu.coddoc = pCodDoc
    AND ccbddocu.nrodoc = pNroDoc NO-LOCK:
    FIND FIRST almmmatg WHERE almmmatg.codcia = CcbDDocu.CodCia
        AND almmmatg.codmat = CcbDDocu.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        CASE almmmatg.codfam:
            WHEN '010' OR WHEN '012' THEN x-ProPro = x-ProPro + CcbDDocu.ImpLin.
            WHEN '011' THEN x-ProFot = x-ProFot + CcbDDocu.ImpLin.
            OTHERWISE x-ProOtr = x-ProOtr + CcbDDocu.ImpLin.
        END CASE.
        IF almmmatg.libre_d02 <> ? THEN DO:
            x-Volumen = x-Volumen + (CcbDDocu.candes * CcbDDocu.factor * (almmmatg.libre_d02 / 1000000)).
        END.
        IF Almmmatg.PesMat <> ? THEN DO:
            x-Pesos = x-Pesos + (CcbDDocu.candes * CcbDDocu.factor * almmmatg.pesmat).
        END.
    END.
/*     FIND FIRST b-CcbDDocu WHERE ROWID(b-CcbDDocu) = ROWID(CcbDDocu) EXCLUSIVE NO-ERROR.       */
/*     IF AVAILABLE b-CcbDDocu THEN DO:                                                          */
/*         ASSIGN b-CcbDDocu.PesMat = (b-CcbDDocu.candes * b-CcbDDocu.factor * almmmatg.pesmat). */
/*         x-Pesos = x-Pesos + b-CcbDDocu.PesMat.                                                */
/*     END.                                                                                      */
END.
RELEASE b-CcbDDocu.

pResumen = '(PP ' + STRING(x-propro) + '/ PF ' + STRING(x-ProFot) + 
    '/ PO ' + STRING(x-prootr) + '/ PS ' + STRING(x-Pesos) +
    '/ VL ' + STRING(x-Volumen,'>,>>>,>>9.99') + 
     ')'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


