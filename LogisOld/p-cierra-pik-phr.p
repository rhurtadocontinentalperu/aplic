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
DEF INPUT PARAMETER x-CodPed AS CHAR.   /* HPK */
DEF INPUT PARAMETER x-CodDiv AS CHAR.
DEF INPUT PARAMETER x-CodOri AS CHAR.   /* PHR */
DEF INPUT PARAMETER x-NroOri AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = ''.

/* Todos tiene que estar en FlgSit = 'P' */
DEF SHARED VAR s-CodCia AS INT.
DEF VAR x-Ok AS LOG INIT YES NO-UNDO.

FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
    VtaCDocu.CodDiv = x-CodDiv AND
    VtaCDocu.CodPed = x-CodPed AND
    VtaCDocu.CodOri = x-CodOri AND
    VtaCDocu.NroOri = x-NroOri:
    IF VtaCDocu.FlgSit <> "P" THEN x-Ok = NO.
END.

IF x-Ok = YES THEN DO:
    {lib/lock-genericov3.i ~
        &Tabla="Di-RutaC" ~
        &Alcance="FIRST" ~
        &Condicion="DI-RutaC.CodCia = s-CodCia and ~
        DI-RutaC.CodDiv = x-CodDiv and ~
        DI-RutaC.CodDoc = x-CodOri and ~
        DI-RutaC.NroDoc = x-NroOri" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN"}
    ASSIGN
        DI-RutaC.FlgEst = "PC".     /* Piqueo OK */
    RELEASE DI-RutaC.
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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


