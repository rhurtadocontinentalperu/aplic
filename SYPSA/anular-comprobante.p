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
         HEIGHT             = 4.15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* RUTINA GENERAL PARA ANULAR DOCUMENTOS EN EL SPEED */

DEF INPUT PARAMETER pRowid AS ROWID.

/* RHC 02/10/2012 YA NO PASA AL SPEED */
RETURN "OK".
/* ********************************** */

FIND Ccbcdocu WHERE ROWID(Ccbcdocu) = pRowid NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'No se ubicó el comprobante al anular el documento en el SPEED'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* NO PARA UTILEX */
IF LOOKUP(Ccbcdocu.coddiv, '00023,00027,00501,00502') >0 THEN RETURN "OK".

/* VARIABLES PARA EL SPEED */
DEFINE VARIABLE chAppCom    AS COM-HANDLE.
DEFINE VAR lValor           AS CHAR.

CREATE "sp_db2.Speed400db2" chAppCom NO-ERROR.

IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE "ERROR al crear el 'conector' sp_db2.Speed400db2"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
lValor = "OK".
CASE Ccbcdocu.coddoc:
    WHEN 'FAC' THEN lValor = chAppCom:GetAnular(1,"FC", Ccbcdocu.nrodoc).
    WHEN 'BOL' THEN lValor = chAppCom:GetAnular(1,"BV", Ccbcdocu.nrodoc).
    WHEN 'TCK' THEN lValor = chAppCom:GetAnular(1,"TK", Ccbcdocu.nrodoc).
    WHEN 'N/C' THEN lValor = chAppCom:GetAnular(1,"NC", Ccbcdocu.nrodoc).
    WHEN 'N/D' THEN lValor = chAppCom:GetAnular(1,"ND", Ccbcdocu.nrodoc).
    WHEN 'LET' THEN lValor = chAppCom:GetAnular(1,"LT", Ccbcdocu.nrodoc).
END CASE.
RELEASE OBJECT chAppCom NO-ERROR.

IF lValor <> "OK" THEN DO:
    MESSAGE 'NO se pudo anular el documento en el SPEED' SKIP
        Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP(1)
        'Mensaje de error:' lValor
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


