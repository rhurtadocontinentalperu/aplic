&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

    BUFFER-COPY AlmCIncidencia TO {&Tabla}
        ASSIGN
        {&Tabla}.Estado = fEstado()
        {&Tabla}.DesOri = (IF AVAILABLE Almacen THEN Almacen.Descripcion ELSE '')
        {&Tabla}.DesDes = (IF AVAILABLE B-Almacen THEN B-Almacen.Descripcion ELSE '')
        .
    {&Tabla}.NomChkAlmOri = fNomPer(AlmCIncidencia.ChkAlmOri).
    {&Tabla}.NomChkAlmDes = fNomPer(AlmCIncidencia.ChkAlmDes).
    {&Tabla}.Motivo = fMotivo().
    {&Tabla}.Glosa  = AlmCIncidencia.GlosaRechazo.
    /* 07/04/2026: Michael Poma, datos adicionales */
    IF AlmcIncidencia.FlgEst = "C" THEN ASSIGN {&Tabla}.FchReg = AlmCIncidencia.FechaAprobacion {&Tabla}.UsrReceptor = AlmCIncidencia.UsrAprobacion.
    IF AlmcIncidencia.FlgEst = "A" THEN ASSIGN {&Tabla}.FchReg = AlmCIncidencia.FechaAnulacion {&Tabla}.UsrReceptor = AlmCIncidencia.UsrAnulacion.

    FIND gn-user WHERE gn-user.codcia = s-codcia AND gn-user.USER-ID = {&Tabla}.UsrReceptor NO-LOCK NO-ERROR.
    IF AVAILABLE gn-user THEN {&Tabla}.UsrReceptor = gn-users.User-Name.

    FIND gn-user WHERE gn-user.codcia = s-codcia AND gn-user.USER-ID = AlmCIncidencia.Usuario NO-LOCK NO-ERROR.
    IF AVAILABLE gn-user THEN {&Tabla}.UsrEmisor = gn-users.User-Name.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


