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

/* 1ro. Verificamos que los códigos sean los correctos */
DEF VAR x-CtoTot AS DEC NO-UNDO.
FOR EACH Detalle:
    FIND Almmmatg WHERE Almmmatg.codcia = s-CodCia AND
        Almmmatg.codmat = Detalle.CodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        CREATE T-Errores.
        ASSIGN
            T-Errores.Fila = Detalle.Fila
            T-Errores.CodMat = Detalle.CodMat
            T-Errores.Glosa = "Error en el valor del SKU: " + Detalle.CodMat.
        DELETE Detalle.
        NEXT.
    END.
    /* Costo */
    /* NOTA: El costos sigue siendo el base */
    x-ctotot = (IF monvta = 2 THEN Almmmatg.ctotot * Almmmatg.tpocmb ELSE Almmmatg.ctotot).
    ASSIGN
        Detalle.CtoTot = x-CtoTot.
    /* Canal */
    FIND FIRST pricanal WHERE pricanal.codcia = s-codcia AND
        pricanal.canal = Detalle.Canal NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PriCanal THEN DO:
        CREATE T-Errores.
        ASSIGN
            T-Errores.Fila = Detalle.Fila
            T-Errores.CodMat = Detalle.CodMat
            T-Errores.Glosa = "Error en el código del CANAL: " + Detalle.Canal.
        DELETE Detalle.
        NEXT.
    END.
    ASSIGN
        Detalle.Canal = pricanal.Canal.
    FIND FIRST prigrupo WHERE prigrupo.codcia = s-codcia AND
        prigrupo.grupo = Detalle.Grupo NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PriGrupo THEN DO:
        CREATE T-Errores.
        ASSIGN
            T-Errores.Fila = Detalle.Fila
            T-Errores.CodMat = Detalle.CodMat
            T-Errores.Glosa = "Error en el código del GRUPO: " + Detalle.Grupo.
        DELETE Detalle.
        NEXT.
    END.
    ASSIGN
        Detalle.Grupo = prigrupo.Grupo.
END.
/* 2do. Lineas-SubLineas válidas por usuario */
FOR EACH Detalle, FIRST Almmmatg OF Detalle NO-LOCK:
    IF NOT CAN-FIND(FIRST priuserlineasublin WHERE priuserlineasublin.CodCia = s-codcia AND
                    priuserlineasublin.USER-ID = s-user-id AND 
                    priuserlineasublin.CodFam = Almmmatg.codfam AND
                    priuserlineasublin.SubFam = Almmmatg.subfam NO-LOCK)
        THEN DO:
        CREATE T-Errores.
        ASSIGN
            T-Errores.Fila = Detalle.Fila
            T-Errores.CodMat = Detalle.CodMat
            T-Errores.Glosa = "Error en el código de línea/sublínea: " + Almmmatg.codfam + " " + Almmmatg.subfam.
        DELETE Detalle.
        NEXT.
    END.
    ASSIGN
        Detalle.PreCanal = ROUND(Detalle.FactorCanal * Detalle.PreBas / 100, 4)
        Detalle.PreGrupo = ROUND(Detalle.PreCanal * Detalle.FactorGrupo / 100, 4)
        Detalle.PreUni = Detalle.PreGrupo.
END.

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


