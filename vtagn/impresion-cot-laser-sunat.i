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
         HEIGHT             = 5.69
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle Include 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-pordto AS DEC NO-UNDO.

I-NroItm = 0.
s-Task-No = 0.
FOR EACH FacDPedi OF FacCPedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK
    BY FacDPedi.NroItm:
    I-NroItm = I-NroItm + 1.
    IF s-Task-No = 0 THEN REPEAT:
        s-Task-No =RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
            THEN LEAVE.
    END.
    CREATE w-report.
    w-report.task-no = s-task-no.
    /* calculamos descuento */
    x-PorDto = FacDPedi.FactorDescuento * 100.
    ASSIGN
        w-report.Llave-c    = "A"
        w-report.Campo-I[1] = I-NroItm
        w-report.Campo-C[1] = Facdpedi.codmat
        w-report.Campo-F[1] = Facdpedi.canped
        w-report.Campo-C[2] = Facdpedi.undvta
        w-report.Campo-C[3] = Almmmatg.desmat
        w-report.Campo-C[4] = Almmmatg.desmar
        w-report.Campo-F[2] = FacDPedi.ImporteUnitarioConImpuesto
        w-report.Campo-F[3] = x-PorDto
        w-report.Campo-F[4] = FacDPedi.cImporteTotalConImpuesto
        w-report.Campo-C[6] = x-Percepcion
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Promociones-2016 Include 
PROCEDURE Carga-Promociones-2016 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pMensaje AS CHAR NO-UNDO.

FOR EACH Facdpedi NO-LOCK WHERE FacDPedi.CodCia = Faccpedi.codcia AND
    FacDPedi.CodDiv = Faccpedi.coddiv AND 
    FacDPedi.CodDoc = 'cbo' AND
    FacDPedi.NroPed = Faccpedi.nroped,
    FIRST Almmmatg OF Facdpedi NO-LOCK:
    CREATE w-report.
    w-report.task-no = s-task-no.
    w-report.Llave-c    = "B".
    i-NroItm = i-NroItm + 1.
    ASSIGN
        w-report.Campo-I[1] = i-NroItm.
    ASSIGN
        w-report.campo-c[1] = Facdpedi.codmat
        w-report.Campo-F[1] = w-report.Campo-F[1] + Facdpedi.canped
        w-report.Campo-C[2] = Facdpedi.undvta
        w-report.Campo-F[5] = Facdpedi.factor.
/*     FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND      */
/*         Almmmatg.codmat = Facdpedi.codmat NO-LOCK NO-ERROR. */
    IF AVAILABLE Almmmatg THEN 
        ASSIGN 
        w-report.Campo-C[2] = (IF TRUE <> (Facdpedi.UndVta > '') THEN Almmmatg.CHR__01 ELSE Facdpedi.UndVta)
        w-report.Campo-C[3] = Almmmatg.desmat.
    /**IF Facdpedi.DesMatWeb > '' THEN w-report.Campo-C[3] = Facdpedi.DesMatWeb.*/
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Datos-Adicionales Include 
PROCEDURE Datos-Adicionales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
    ASSIGN
        w-report.Llave-I = s-CodCia
        w-report.Campo-C[10] = Faccpedi.coddoc
        w-report.Campo-C[11] = Faccpedi.nroped.
    x-listprecio = "".
    IF FacCpedi.libre_c01 <> ? THEN DO:
        x-listprecio = FacCpedi.libre_c01.
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = x-listprecio NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN DO:
            x-listprecio = x-listprecio + " " + gn-divi.desdiv.
        END.
    END.
    w-report.Campo-C[12] = x-listprecio.
    w-report.Campo-C[13] = c-descli.
    FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA AND  
        gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
    w-report.Campo-C[14] = gn-clie.dircli.
    w-report.Campo-d[1] = Faccpedi.FchPed.
    w-report.Campo-d[2] = Faccpedi.FchEnt.
    w-report.Campo-d[3] = Faccpedi.FchVen.
    w-report.Campo-C[15] = gn-clie.ruc.
    w-report.Campo-C[16] = c-NomVen.
    w-report.Campo-C[17] = C-NomCon.
    w-report.Campo-C[18] = C-Moneda.
    w-report.Campo-C[19] = FacCPedi.Glosa.
    w-report.Campo-C[20] = C-OBS[1].
    w-report.Campo-C[21] = C-OBS[2].
    w-report.Campo-C[22] = C-OBS[3].
    w-report.Campo-F[10] = FacCPedi.ImpDto.
    w-report.Campo-F[11] = f-ImpTot.


END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

