&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CMvto NO-UNDO LIKE CcbCMvto.
DEFINE TEMP-TABLE T-DMvto NO-UNDO LIKE CcbDMvto.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Genereción de comprobantes de Percepción

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

FIND Ccbccaja WHERE ROWID(Ccbccaja) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbccaja THEN RETURN "ADM-ERROR".

/* Control de correlativos */
DEF VAR s-coddoc AS CHAR INIT "PER" NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.

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
   Temp-Tables and Buffers:
      TABLE: T-CMvto T "?" NO-UNDO INTEGRAL CcbCMvto
      TABLE: T-DMvto T "?" NO-UNDO INTEGRAL CcbDMvto
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND Ccbcmvto WHERE CcbCMvto.CodCia = s-codcia
        AND CcbCMvto.CodDiv = s-coddiv
        AND CcbCMvto.CodDoc = s-coddoc
        AND CcbCMvto.CodCli = Ccbccaja.codcli
        AND CcbCMvto.Libre_chr[1] = Ccbccaja.coddoc
        AND CcbCMvto.Libre_chr[2] = Ccbccaja.nrodoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcmvto THEN RETURN 'OK'.
    FOR EACH Ccbdmvto WHERE Ccbdmvto.codcia = Ccbcmvto.codcia
        AND Ccbdmvto.coddiv = Ccbcmvto.coddiv
        AND Ccbdmvto.coddoc = Ccbcmvto.coddoc
        AND Ccbdmvto.nrodoc = Ccbcmvto.nrodoc:
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = Ccbdmvto.codope
            AND Ccbcdocu.nrodoc = Ccbdmvto.nroast
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN
            Ccbcdocu.sdoact = Ccbcdocu.sdoact + Ccbdmvto.imptot.
        Ccbcdocu.flgest = "X".
    END.
    ASSIGN
        Ccbcmvto.flgest = "A".
    IF AVAILABLE(Ccbcmvto) THEN RELEASE Ccbcmvto.
    IF AVAILABLE(Ccbdmvto) THEN RELEASE Ccbdmvto.
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


