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

/* Rutina que devuelve el LUGAR DE ENTREGA */
DEF INPUT PARAMETER pCodPed AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF OUTPUT PARAMETER pLugEnt AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.

pLugEnt = ''.
IF LOOKUP(pCodPed, 'PED,O/D,OTR,P/M') = 0 THEN RETURN.
FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddoc = pCodPed AND
    Faccpedi.nroped = pNroPed NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.
CASE TRUE:
    WHEN Faccpedi.CodDoc = 'OTR' AND Faccpedi.CrossDocking = YES AND Faccpedi.AlmacenXD > '' 
        THEN DO:
        FIND Almacen WHERE Almacen.codcia = s-codcia AND
            Almacen.codalm = Faccpedi.AlmacenXD
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN pLugEnt = Almacen.Descripcion + '|' + Almacen.DirAlm.
    END.
    WHEN Faccpedi.Ubigeo[2] = "@ALM" THEN DO:
        FIND Almacen WHERE Almacen.codcia = s-codcia AND
            Almacen.codalm = Faccpedi.Ubigeo[3]
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN pLugEnt = Almacen.Descripcion + '|' + Almacen.DirAlm.
    END.
    WHEN Faccpedi.Ubigeo[2] = "@CL" THEN DO:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = Faccpedi.Ubigeo[3]
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            pLugEnt = gn-clie.dircli.
            FIND gn-clied OF gn-clie WHERE Gn-ClieD.Sede = Faccpedi.Ubigeo[1]
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN pLugEnt = gn-clie.NomCli + '|' + Gn-ClieD.DirCli.
        END.
    END.
    WHEN Faccpedi.Ubigeo[2] = "@PV" THEN DO:
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND
            gn-prov.codpro = Faccpedi.Ubigeo[3]
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN DO:
            pLugEnt = gn-prov.dirpro.
            FIND gn-provd OF gn-prov WHERE gn-provD.Sede = Faccpedi.Ubigeo[1]
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-provd THEN pLugEnt = gn-prov.NomPro + '|' + gn-provD.DirPro.
        END.
    END.
END CASE.

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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


