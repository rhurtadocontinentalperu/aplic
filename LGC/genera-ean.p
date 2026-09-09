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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT PARAMETER pRowid AS ROWID.

DEFINE STREAM s-Archivo.

DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE cLinePrint AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPv-codcia AS INTEGER NO-UNDO.
DEFINE VARIABLE iNroItem AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE x-PreNet AS DEC DECIMALS 3 NO-UNDO.
DEFINE VARIABLE x-PreUni AS DEC DECIMALS 3 NO-UNDO.
DEFINE VARIABLE x-PreVta AS DEC DECIMALS 3 NO-UNDO.
DEFINE VARIABLE cItemCode AS CHARACTER NO-UNDO.

FIND Lg-COCmp WHERE ROWID(Lg-cocmp) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Lg-cocmp THEN RETURN.

FIND Empresas WHERE Empresas.codcia = Lg-cocmp.codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodPro THEN iPv-codcia = Lg-cocmp.codcia.

FIND Gn-aprov WHERE
    Gn-aprov.codcia = iPv-codcia AND
    Gn-aprov.codpro = Lg-cocmp.codpro NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-aprov THEN DO:
    MESSAGE
        'El proveedor' Lg-cocmp.codpro
        'NO tiene configurado su código de localización IBC'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

SYSTEM-DIALOG 
    GET-FILE cFileName  
    FILTERS '*.txt' '*.txt'  
    ASK-OVERWRITE 
    DEFAULT-EXTENSION 'txt'  
    MUST-EXIST  
    RETURN-TO-START-DIR 
    SAVE-AS  
    UPDATE lOk.
IF lOk = NO THEN RETURN.

OUTPUT STREAM s-Archivo TO VALUE(cFileName).
    
/* ENCABEZADO */
cLinePrint = 'ENC,' +
    '7750822370104,' +
    TRIM(SUBSTRING(Gn-AProv.CodEan,1,35)) + ',' +
    STRING(Lg-cocmp.nrodoc,'999999') + ',' +
    '220' + ',' +
    STRING(Lg-cocmp.nrodoc,'999999') + ',' +
    'ORDERS' + ',' + '9'.
PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.

cLinePrint = 'DTM,' +
    STRING(YEAR(Lg-cocmp.fchdoc), '9999') +
    STRING(MONTH(Lg-cocmp.fchdoc), '99') +
    STRING(DAY(Lg-cocmp.fchdoc), '99') +
    '0000' + ',,,' +
    STRING(YEAR(Lg-cocmp.fchvto), '9999') +
    STRING(MONTH(Lg-cocmp.fchvto), '99') +
    STRING(DAY(Lg-cocmp.fchvto), '99') +
    '0000'.
PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.

cLinePrint = 'BYOC,' + '7750822370104,,,7750822370104'.
PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.

cLinePrint = 'SUSR,' + TRIM(SUBSTRING(Gn-AProv.CodEan,1,35)).
PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.

cLinePrint = 'DPGR,' + '7750822370104'.
PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.

cLinePrint = 'IVAD,' + '7750822370104'.
PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.

cLinePrint = 'ITO,' + '7750822370104'.
PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.

cLinePrint = 'TAXMOA,' + TRIM(STRING(LG-COCmp.ImpIgv,'>>>>>>>>>>>9.999')).
PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.

cLinePrint = 'CUX,' + IF Lg-cocmp.codmo = 1 THEN 'PEN' ELSE 'USD'.
PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.

/* DETALLE */
FOR EACH Lg-docmp OF Lg-cocmp NO-LOCK,
    FIRST Almmmatg OF Lg-docmp NO-LOCK:

    /* Caso Faber Castell */
    IF LG-COCmp.CodPro = "10005035" THEN
        cItemCode = Almmmatg.CodMat.
    ELSE
        cItemCode = Almmmatg.CodBrr.

    cLinePrint = 'LIN,' +
        TRIM(STRING(iNroItem, '>>>>>9')) + ',' +
        TRIM(SUBSTRING(cItemCode,1,35)) + ',' + 'EN' + ',,' +
        TRIM(SUBSTRING(Almmmatg.CodMat,1,35)).
    PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.
    cLinePrint = 'QTY,' + TRIM(STRING(LG-DOCmp.CanPedi,'>>>>>>>>>>>9.999')).
    PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.
    x-PreUni = LG-DOCmp.PreUni.
    x-PreNet = Lg-docmp.PreUni *
        (1 - (Lg-docmp.Dsctos[1] / 100)) *
        (1 - (Lg-docmp.Dsctos[2] / 100)) *
        (1 - (Lg-docmp.Dsctos[3] / 100)).
    cLinePrint = 'MOA,' + TRIM(STRING(Lg-docmp.ImpTot),'>>>>>>>>>>>9.999').
    PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.
    cLinePrint = 'PRI,' +
        TRIM(STRING(x-PreUni),'>>>>>>>>>>>9.999') + ',' +
        TRIM(STRING(x-PreNet),'>>>>>>>>>>>9.999').
    PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.
    x-PreVta = x-PreNet * Lg-docmp.CanPedi.
    cLinePrint = 'TAXMOA,,' +
        TRIM(STRING(LG-DOCmp.ImpTot - (x-PreVta),'>>>>>>>>>>>>>>9.999')).
    PUT STREAM s-Archivo UNFORMATTED cLinePrint SKIP.
    iNroItem = iNroItem + 1.
END.
PUT STREAM s-Archivo UNFORMATTED "" SKIP.
OUTPUT STREAM s-Archivo CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


