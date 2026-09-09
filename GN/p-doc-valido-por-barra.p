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
    Notes       : Comprobantes Grabados en la tabla CCBCDOCU
                    FAC BOL G/R N/C N/D
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodigoBarra AS CHAR.
DEF INPUT-OUTPUT PARAMETER pCodDoc AS CHAR.
DEF OUTPUT PARAMETER pNroDoc AS CHAR.

/* Notas:
- pCodDoc: acepta un código de documento sugerido en caso falle la búsqueda por la barra
- pNroDoc: se devuelve en blanco si no existe ningún comprobante
*/

DEF SHARED VAR s-codcia AS INT.

/* 1ro. buscamos el documento sugerido */
pCodDoc = TRIM(pCodDoc).
pNroDoc = ''.
IF pCodDoc > '' THEN DO:
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.coddoc = pCodDoc AND
        Ccbcdocu.nrodoc = pCodigoBarra NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        pNroDoc = Ccbcdocu.nrodoc.
        RETURN.
    END.
END.
/* 2do. determinamos cual es el documento y lo ubicamos */
DEF VAR k AS INTE NO-UNDO.
DEF VAR cCodBar AS CHAR NO-UNDO.
DEF VAR cNroDoc AS CHAR NO-UNDO.

DO k = 1 TO (LENGTH(pCodigoBarra) - 1):
    cCodBar = SUBSTRING(pCodigoBarra, 1, k).
    cNroDoc = SUBSTRING(pCodigoBarra, k + 1).
    FIND FIRST FacDocum WHERE FacDocum.CodCia = s-CodCia AND
        Facdocum.codcta[8] = cCodBar
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacDocum THEN DO:
        pCodDoc = FacDocum.CodDoc.
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
            Ccbcdocu.coddoc = pCodDoc AND
            Ccbcdocu.nrodoc = cNroDoc NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcdocu THEN DO:
            pNroDoc = Ccbcdocu.nrodoc.
            RETURN.
        END.
        ELSE DO:
            IF pCodDoc = "G/R" THEN DO:
                FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
                    Ccbcdocu.coddoc = pCodDoc AND
                    Ccbcdocu.nrodoc = SUBSTRING(cNroDoc,1,3) + STRING(INTEGER(SUBSTRING(cNroDoc,4)), '999999')
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Ccbcdocu THEN DO:
                    pNroDoc = Ccbcdocu.nrodoc.
                    RETURN.
                END.
            END.
        END.
    END.
END.

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
         HEIGHT             = 3.77
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


