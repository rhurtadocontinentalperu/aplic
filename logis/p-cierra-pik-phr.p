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
DEF INPUT PARAMETER x-CodRef AS CHAR.   /* O/D OTR */
DEF INPUT PARAMETER x-NroRef AS CHAR.
DEF INPUT PARAMETER x-CodOri AS CHAR.   /* PHR */
DEF INPUT PARAMETER x-NroOri AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-CodCia AS INT.

DEF BUFFER B-RutaD FOR Di-RutaD.
DEF BUFFER ORDENES FOR Faccpedi.

pMensaje = ''.

/* Todos tiene que estar en FlgSit = 'C' */
DEF VAR x-Ok AS LOG NO-UNDO.
DEF VAR x-CuentaFallas AS INT INIT 0 NO-UNDO.

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* ****************************************************************** */
    /* 1ro. Verificamos si todas las O/D u OTR ya tienen sus HPK cerradas */
    /* ****************************************************************** */
    x-Ok = NO.
    x-CuentaFallas = 0.
    FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
        VtaCDocu.CodRef = x-CodRef AND      /* O/D OTR */
        VtaCDocu.NroRef = x-NroRef AND
        VtaCDocu.CodDiv = x-CodDiv AND
        VtaCDocu.CodPed = x-CodPed:         /* HPK */
        IF VtaCDocu.FlgSit <> "C" THEN x-CuentaFallas = x-CuentaFallas + 1.
    END.
    IF x-CuentaFallas = 0 THEN x-Ok = YES.
    IF x-Ok = YES THEN DO:
        RUN Cierra-OD-OTR.      /* ¿LISTO PARA FACTURAR? */
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ****************************************************************** */
    /* 2do. Verificamos si todas las HPK cerradas */
    /* ****************************************************************** */
    x-Ok = NO.
    x-CuentaFallas = -1.
    /* Buscamos si todos las ORDENES están cerradas por la PHR */
    /* OJO: no es confiable x-codorigen */
    /*MESSAGE 'uno' x-codref x-nroref.*/
    FOR EACH Di-RutaD NO-LOCK WHERE Di-RutaD.codcia = s-codcia 
        AND Di-RutaD.coddoc = "PHR"
        AND Di-RutaD.codref = x-CodRef 
        AND Di-RutaD.nroref = x-NroRef
        AND Di-RutaD.coddiv = x-CodDiv,
        FIRST Di-RutaC OF Di-RutaD NO-LOCK BY Di-RutaC.fchdoc DESC:
        IF Di-RutaC.flgest BEGINS "P" THEN DO:
            /* Tomamos la PHR correcta */
            x-CodOri = Di-RutaC.coddoc.     /* PHR */
            x-NroOri = Di-RutaC.nrodoc.
            x-CuentaFallas = 0.
            /* Ya tenemos la PHR ubicada, ahora veamos si todas las Ordenes están cerradas */
            FOR EACH B-RutaD OF Di-RutaC NO-LOCK, 
                FIRST ORDENES NO-LOCK WHERE ORDENES.codcia = s-codcia
                AND ORDENES.coddoc = B-RutaD.codref
                AND ORDENES.nroped = B-RutaD.nroref:
                IF ORDENES.FlgSit <> "C" THEN x-CuentaFallas = x-CuentaFallas + 1.
            END.
            LEAVE.  /* No buscamos más */
        END.
    END.
    /*MESSAGE 'dos' x-codref x-nroref x-codori x-nroori x-CuentaFallas.*/
/*     RLOOP:                                                                  */
/*     FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND          */
/*         VtaCDocu.CodOri = x-CodOri AND      /* PHR */                       */
/*         VtaCDocu.NroOri = x-NroOri AND                                      */
/*         VtaCDocu.CodDiv = x-CodDiv AND                                      */
/*         VtaCDocu.CodPed = x-CodPed:         /* HPK */                       */
/*         IF VtaCDocu.FlgSit <> "C" THEN x-CuentaFallas = x-CuentaFallas + 1. */
/*     END.                                                                    */
    IF x-CuentaFallas = 0 THEN x-Ok = YES.
    IF x-Ok = YES AND x-CodOri > '' THEN DO:
        RUN Cierra-PHR. /* POR FEDATEAR */
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.
IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
RETURN 'OK'.

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
         HEIGHT             = 6.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Cierra-OD-OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-OD-OTR Procedure 
PROCEDURE Cierra-OD-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Alcance="FIRST" ~
        &Condicion="Faccpedi.CodCia = s-CodCia and ~
        Faccpedi.CodDoc = x-CodRef and ~
        Faccpedi.NroPed = x-NroRef" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    ASSIGN
        Faccpedi.FlgSit = "C".     /* Listo para Facturar */
    RELEASE Faccpedi.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Cierra-PHR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-PHR Procedure 
PROCEDURE Cierra-PHR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR'.
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
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    ASSIGN
        DI-RutaC.FlgEst = "PF".     /* TODO en Distribución */
    /* Actualizamos las O/D Relacionadas con el FlgSit = "P" */
/*     RUN logis/actualiza-flgsit (ROWID(DI-RutaC)).                             */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                    */
/*         pMensaje = "NO se pudo actualizar el estado de las O/D relacionadas". */
/*         UNDO, LEAVE.                                                          */
/*     END.                                                                      */
    RELEASE DI-RutaC.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

