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

DEF INPUT PARAMETER pDNI AS CHAR.
DEF OUTPUT PARAMETER pNombre AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pOrigen AS CHAR.

DEF SHARED VAR s-codcia AS INT.

pNombre = ''.
pOrigen = ''.

IF TRUE <> (pDNI > '') THEN RETURN.

pOrigen = 'ERROR'.  /* Valor por defecto */

/* 1ro buscamos en TERCEROS */
FIND FIRST rut-per-terc WHERE rut-per-terc.CodCia = s-codcia AND
    rut-per-terc.DNI = pDNI 
    NO-LOCK NO-ERROR.
IF AVAILABLE rut-per-terc THEN DO:
    pNombre = rut-per-terc.NomPer.
    pOrigen = "TERCERO".
    IF rut-per-terc.Activo = NO THEN pOrigen = "ERROR".     /* INactivo */
    RETURN.
END.

/* 2do buscamos en la planilla activa */
pOrigen = "ERROR".
FOR EACH PL-PERS NO-LOCK WHERE PL-PERS.NroDocId = pDNI AND PL-PERS.CodCia = s-CodCia:
    /* Captura el nombre así no esté activo */
    RUN gn/nombre-personal (s-CodCia, INPUT pl-pers.CodPer, OUTPUT pNombre).
    FIND LAST PL-FLG-MES USE-INDEX Idx02 WHERE PL-FLG-MES.CodCia = s-codcia AND
        PL-FLG-MES.codper = pl-pers.codper NO-LOCK NO-ERROR.
    IF AVAILABLE PL-FLG-MES AND PL-FLG-MES.vcontr <> ? THEN NEXT.
    /*RUN gn/nombre-personal (s-CodCia, INPUT pl-pers.CodPer, OUTPUT pNombre).*/
    pOrigen = "PROPIO".
    LEAVE.
END.

/*
FIND LAST PL-PERS WHERE PL-PERS.CodCia = s-CodCia AND
    PL-PERS.NroDocId = pDNI NO-LOCK NO-ERROR.
IF AVAILABLE PL-PERS THEN DO:
    FIND LAST PL-FLG-MES WHERE PL-FLG-MES.CodCia = s-codcia AND
        PL-FLG-MES.codper = pl-pers.codper NO-LOCK NO-ERROR.
    IF AVAILABLE PL-FLG-MES AND PL-FLG-MES.vcontr <> ?  THEN DO:
        pOrigen = "ERROR".
        RETURN.
    END.
    RUN gn/nombre-personal (s-CodCia, INPUT pl-pers.CodPer, OUTPUT pNombre).
    pOrigen = "PROPIO".
END.
ELSE DO:
    pOrigen = "ERROR".
END.
*/

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
         HEIGHT             = 3.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


