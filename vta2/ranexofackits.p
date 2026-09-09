&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-fact01.p
    Purpose     : Impresion de Fact/Boletas 

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR CL-CODCIA AS INTEGER.

DEF BUFFER b-almmmatg FOR almmmatg.

FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND  gn-clie.codcli = ccbcdocu.codcli 
    NO-LOCK NO-ERROR.

DEF TEMP-TABLE Detalle LIKE ccbddocu
    FIELD tipo    AS CHAR
    FIELD desmat  LIKE almmmatg.desmat
    FIELD desmar  LIKE almmmatg.desmar
    FIELD codmat2 LIKE ccbddocu.codmat
    FIELD desmat2 LIKE almmmatg.desmat
    FIELD desmar2 LIKE almmmatg.desmar
    FIELD candes2 LIKE ccbddocu.candes
    FIELD undvta2 LIKE ccbddocu.undvta
    INDEX Idx00 AS PRIMARY tipo codmat codmat2.

/************************  DEFINICION DE FRAMES  *******************************/
DEFINE FRAME F-HdrFac
    HEADER
    "DOCUMENTO: " ccbcdocu.coddoc ccbcdocu.nrodoc SKIP
    "EMISION:" ccbcdocu.fchdoc SKIP
    "CLIENTE:" ccbcdocu.codcli ccbcdocu.nomcli SKIP
    "PEDIDO:" ccbcdocu.codped ccbcdocu.nroped SKIP(2)
    "ITEM CODIGO DESCRIPCION                                                  MARCA                UNIDAD CANTIDAD   TOTAL     " SKIP
    "---- ------ ------------------------------------------------------------ -------------------- ------ ---------- ----------" SKIP
   /*         1         2         3         4         5         6         7         8         9        10        11
     123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     >>>9 123456 123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456 >>>,>>9.99 
                 123456 12345678901234567890123456789012345678901234567890    12345678901234567890 123456 >>>,>>9.99 >>>,>>9.99
     >>>9 123456 123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456            >>>,>>9.99
   */
    WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaKit
    detalle.nroitm  FORMAT ">>>9"       
    detalle.codmat2                     AT 13                     
    detalle.desmat2 FORMAT "x(50)"      
    detalle.desmar2 FORMAT "X(20)"      AT 74
    detalle.undvta2 FORMAT "X(6)"       
    detalle.candes  FORMAT ">>>,>>9.99" 
    detalle.candes2 FORMAT ">>>,>>9.99" 
    WITH NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaRes
    detalle.nroitm  FORMAT ">>>9"       
    detalle.codmat                      
    detalle.desmat   FORMAT "x(60)"      
    detalle.desmar   FORMAT "X(20)"       AT 74
    detalle.undvta   FORMAT "X(6)"       
    detalle.candes   FORMAT ">>>,>>9.99" 
    detalle.candes2  FORMAT ">>>,>>9.99" 
    WITH NO-BOX NO-LABELS /*NO-UNDERLINE*/ STREAM-IO WIDTH 200.

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
         HEIGHT             = 5.38
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
DEF VAR answer AS LOGICAL NO-UNDO.
DEF VAR numcopias AS INT NO-UNDO.
DEF VAR n-Item AS INT INIT 0 NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP NUM-COPIES numcopias UPDATE answer.
IF NOT answer THEN RETURN.

RUN Carga-Kits.
FIND FIRST detalle NO-LOCK NO-ERROR.
IF NOT AVAILABLE detalle THEN RETURN.

OUTPUT TO PRINTER NUM-COPIES VALUE(numcopias) PAGED PAGE-SIZE 30.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.    
VIEW FRAME F-HdrFac.
FOR EACH detalle NO-LOCK BREAK BY detalle.tipo BY detalle.codmat:
    IF FIRST-OF(detalle.tipo) THEN DO:
        n-Item = 0.
        PUT " " SKIP.
        DISPLAY
            detalle.tipo @ detalle.desmat
            WITH FRAME f-DetaRes 1 DOWN.
        PUT FILL("=", LENGTH(detalle.tipo)) AT 13 SKIP.
    END.
    IF FIRST-OF(detalle.tipo) OR FIRST-OF(detalle.codmat)
        THEN DO:
        IF detalle.tipo = "KITS" THEN DO:
            n-Item = n-Item + 1.
            DISPLAY
                n-Item @ detalle.nroitm
                detalle.codmat 
                detalle.desmat 
                detalle.desmar 
                detalle.undvta 
                detalle.candes 
                WITH FRAME f-DetaRes.
        END.
    END.
    IF detalle.tipo = "RESUMEN" THEN DO:
        n-Item = n-Item + 1.
        DISPLAY 
            n-Item @ detalle.nroitm
            detalle.codmat 
            detalle.desmat 
            detalle.desmar 
            detalle.undvta 
            detalle.candes2 
            WITH FRAME F-DetaRes.
    END.
    IF detalle.tipo = "KITS" THEN
        DISPLAY 
        detalle.codmat2 
        detalle.desmat2 
        detalle.desmar2 
        detalle.undvta2 
        detalle.factor @ detalle.candes
        detalle.candes2 
        WITH FRAME F-DetaKit.
END.
PAGE.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Kits) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Kits Procedure 
PROCEDURE Carga-Kits :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1ro cargamos resumen de componentes del kit */
n-Item = 1.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
    FIRST Almckits OF ccbddocu NO-LOCK,
    EACH almdkits OF almckits NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = ccbddocu.codcia 
    AND Almmmatg.codmat = almdkits.codmat2
    BY ccbddocu.nroitm:
    FIND detalle WHERE detalle.tipo = "RESUMEN"
        AND detalle.codmat = AlmDKits.codmat2 NO-ERROR.
    IF NOT AVAILABLE detalle THEN DO:
        CREATE detalle.
        ASSIGN
            detalle.tipo   = "RESUMEN"
            detalle.codcia = ccbddocu.codcia
            detalle.codmat = almdkits.codmat2
            detalle.desmat = almmmatg.desmat
            detalle.desmar = almmmatg.desmar
            detalle.undvta = almmmatg.undstk
            detalle.nroitm = n-Item
            n-Item = n-Item + 1.
    END.
    ASSIGN
        detalle.candes2 = detalle.candes2 + ccbddocu.candes * ccbddocu.factor *  AlmDKits.Cantidad.
END.

/* 2do cargamos kits y componentes */
n-Item = 1.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
    FIRST b-almmmatg OF ccbddocu NO-LOCK,
    FIRST Almckits OF ccbddocu NO-LOCK,
    EACH almdkits OF almckits NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = ccbddocu.codcia 
    AND Almmmatg.codmat = almdkits.codmat2
    BY ccbddocu.nroitm:
    CREATE detalle.
    ASSIGN
        detalle.tipo   = "KITS"
        detalle.codcia = ccbddocu.codcia
        detalle.codmat = ccbddocu.codmat
        detalle.desmat = b-almmmatg.desmat
        detalle.desmar = b-almmmatg.desmar
        detalle.undvta = ccbddocu.undvta
        detalle.candes = ccbddocu.candes
        detalle.codmat2 = almdkits.codmat2
        detalle.desmat2 = almmmatg.desmat
        detalle.desmar2 = almmmatg.desmar
        detalle.undvta2 = almmmatg.undstk
        detalle.candes2 = ccbddocu.candes * ccbddocu.factor *  AlmDKits.Cantidad
        detalle.factor  = AlmDKits.Cantidad
        detalle.nroitm = n-Item
        n-Item = n-Item + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

