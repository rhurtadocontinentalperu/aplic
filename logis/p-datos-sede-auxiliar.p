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

DEF INPUT PARAMETER pClfAux AS CHAR.        /* @CL o @PV */     /* Ubigeo[2] */
DEF INPUT PARAMETER pCodAux AS CHAR.                            /* Ubigeo[3] */
DEF INPUT PARAMETER pSede AS CHAR.                              /* Ubigeo[1] */
DEF OUTPUT PARAMETER pUbigeo AS CHAR.
DEF OUTPUT PARAMETER pLongitud AS DEC.
DEF OUTPUT PARAMETER pLatitud AS DEC.

pUbigeo = ''.
pLongitud = 0.
pLatitud = 0.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
CASE pClfAux:
    WHEN "@CL" THEN DO:
        FIND FIRST Gn-ClieD WHERE Gn-ClieD.CodCia = cl-CodCia AND
            Gn-ClieD.CodCli = pCodAux AND
            Gn-ClieD.Sede = pSede
            NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-ClieD THEN
            ASSIGN
            pUbigeo = TRIM(Gn-ClieD.CodDept) + TRIM(Gn-ClieD.CodProv) + TRIM(Gn-ClieD.CodDist)
            pLongitud = Gn-ClieD.Longitud 
            pLatitud = Gn-ClieD.Latitud.
    END.
    WHEN "@PV" THEN DO:
        FIND FIRST Gn-ProvD WHERE Gn-ProvD.CodCia = pv-CodCia AND
            Gn-ProvD.CodPro = pCodAux AND
            Gn-ProvD.Sede = pSede
            NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-ProvD THEN
            ASSIGN
            pUbigeo = TRIM(Gn-ProvD.CodDept) + TRIM(Gn-ProvD.CodProv) + TRIM(Gn-ProvD.CodDist)
            pLongitud = Gn-ProvD.Longitud 
            pLatitud = Gn-ProvD.Latitud.
    END.
    WHEN "@ALM" THEN DO:
        FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = pCodAux NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN DO:
            FIND gn-divi WHERE gn-divi.codcia = Almacen.codcia
                AND gn-divi.coddiv = Almacen.CodDiv NO-LOCK NO-ERROR.
            IF AVAILABLE gn-divi THEN DO:
                pUbigeo = TRIM(gn-divi.Campo-Char[3]) + TRIM(gn-divi.Campo-Char[4]) + TRIM(gn-divi.Campo-Char[5]).
                pLongitud = gn-divi.Campo-Dec[6].
                pLatitud  = gn-divi.Campo-Dec[7].
            END.
        END.
    END.
END CASE.
IF TRUE <> (pUbigeo > '') THEN
    ASSIGN
            pUbigeo = '150101'
            pLongitud = 0
            pLatitud = 0.

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
         HEIGHT             = 5.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


