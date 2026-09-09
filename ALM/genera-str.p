&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Generacion de STR Solicitud de Transferencia

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
DEF SHARED VAR s-user-id AS CHAR.

FIND Almcrepo WHERE ROWID(Almcrepo) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcrepo THEN RETURN 'ADM-ERROR'.

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

/*
  Tabla: "Almacen"
  Condicion: "Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm"
  Bloqueo: "EXCLUSIVE-LOCK (NO-WAIT)"
  Accion: "RETRY" | "LEAVE"
  Mensaje: "YES" | "NO"
  TipoError: ""ADM-ERROR"" | "ERROR"
*/

DEF VAR s-coddiv AS CHAR NO-UNDO.
DEF VAR s-coddoc AS CHAR NO-UNDO.
DEF VAR s-codalm AS CHAR NO-UNDO.
DEF VAR s-tpoped AS CHAR NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.

DEF BUFFER B-Almacen FOR Almacen.

/* ALMACEN SOLICITANTE */
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = Almcrepo.codalm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    MESSAGE 'Almacén' Almcrepo.codalm 'NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* ALMACEN DE DESPACHO */
FIND B-Almacen WHERE B-Almacen.codcia = s-codcia
    AND B-Almacen.codalm = Almcrepo.almped
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-Almacen THEN DO:
    MESSAGE 'Almacén' Almcrepo.almped 'NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Datos del almacen de despacho */
ASSIGN
    s-coddiv = B-Almacen.coddiv
    s-coddoc = "STR"
    s-codalm = B-Almacen.codalm.

FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.flgest = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'Correlativo doc' s-coddoc 'div' s-coddiv 'NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

ASSIGN
    s-nroser = Faccorre.nroser.

/*
{lib/lock-generico.i &Bloqueo="EXCLUSIVE-LOCK NO-WAIT" ~
    &Tabla="FacCorre" ~
    &Condicion="FacCorre.codcia = s-codcia AND FacCorre.coddoc = 'STR' ~
    AND FacCorre.coddiv = Almacen.coddiv ~
    AND FacCorre.FlgEst = YES" ~
    &Accion="LEAVE" ~
    &Mensaje="YES" ~
    &TipoError=""ADM-ERROR""}
*/

{vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

CREATE FacCPedi.

ASSIGN 
    FacCPedi.CodCia = S-CODCIA
    FacCPedi.CodDiv = S-CODDIV
    FacCPedi.CodDoc = s-coddoc 
    FacCPedi.CodAlm = s-CodAlm
    FacCPedi.DivDes = s-CodDiv  
    FacCPedi.CodCli = Almcrepo.CodAlm       /* Almacén de destino */
    FacCPedi.NomCli = Almacen.Descripcion
    FacCPedi.DirCli = Almacen.DirAlm
    FacCPedi.LugEnt = Almacen.DirAlm
    FacCPedi.FchPed = TODAY 
    FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
    FacCPedi.TpoPed = s-TpoPed
    FacCPedi.FlgEst = "P"     /* APROBADO */
    FacCPedi.CodRef = "R/A"
    FacCPedi.NroRef = STRING(almcrepo.NroSer, '999') + STRING(almcrepo.NroDoc)
    FacCPedi.fchven = FacCPedi.FchPed
    FacCPedi.Hora = STRING(TIME, "HH:MM:SS")
    FacCPedi.usuario = s-user-id.
ASSIGN
    FacCorre.Correlativo = FacCorre.Correlativo + 1.

DEF VAR I-NITEM AS INT INIT 0 NO-UNDO.

FOR EACH Almdrepo OF Almcrepo NO-LOCK, FIRST Almmmatg OF Almdrepo NO-LOCK:
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedi.
    ASSIGN
        FacDPedi.AlmDes = FacCPedi.CodAlm
        FacDPedi.CanApr = almdrepo.CanApro 
        FacDPedi.CanSol = almdrepo.CanReq
        FacDPedi.CanPed = almdrepo.CanApro 
        FacDPedi.codmat = almdrepo.CodMat
        FacDPedi.Factor = 1
        FacDPedi.UndVta = Almmmatg.UndBas
        FacDPedi.CodCia = FacCPedi.CodCia
        FacDPedi.CodDiv = FacCPedi.CodDiv
        FacDPedi.coddoc = FacCPedi.coddoc
        FacDPedi.NroPed = FacCPedi.NroPed
        FacDPedi.FchPed = FacCPedi.FchPed
        FacDPedi.Hora   = FacCPedi.Hora 
        FacDPedi.FlgEst = FacCPedi.FlgEst
        FacDPedi.NroItm = I-NITEM.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.
IF AVAILABLE(FacDPedi) THEN RELEASE FacDPedi.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


