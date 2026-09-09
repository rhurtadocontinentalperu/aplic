&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Controlar y el correlativo del documento

    Syntax      : {vtagn/i-faccorre-01.i 
                    &Codigo = <codigo del documento> 
                    &Serie = <número de serie> }

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    
/* FIND INTEGRAL.FacCorre WHERE                                                            */
/*     INTEGRAL.FacCorre.CodCia = s-CodCia AND                                             */
/*     INTEGRAL.FacCorre.CodDoc = {&Codigo} AND                                            */
/*     INTEGRAL.FacCorre.NroSer = {&Serie}                                                 */
/*     EXCLUSIVE-LOCK NO-ERROR.                                                   */
/* IF NOT AVAILABLE INTEGRAL.FacCorre THEN DO:                                             */
/*     MESSAGE "No se pudo actualizar el control de correlativos (INTEGRAL.FacCorre)" SKIP */
/*         "para el documento" {&Codigo} "y la serie" {&Serie}                    */
/*         VIEW-AS ALERT-BOX ERROR.                                               */
/*     UNDO, RETURN "ADM-ERROR".                                                  */
/* END.                                                                           */

/* Trata de bloquear hasta 5 veces */
{lib/lock.i &Tabla="INTEGRAL.FacCorre" &Condicion="INTEGRAL.FacCorre.CodCia = s-CodCia AND ~
    INTEGRAL.FacCorre.CodDoc = {&Codigo} AND ~
    INTEGRAL.FacCorre.NroSer = {&Serie}"}

IF INTEGRAL.FacCorre.FlgCic = NO THEN DO:
    IF INTEGRAL.FacCorre.NroFin > 0 AND INTEGRAL.FacCorre.Correlativo > INTEGRAL.FacCorre.NroFin THEN DO:
        MESSAGE 'Se ha llegado al límite del correlativo:' INTEGRAL.FacCorre.NroFin SKIP
            'No se puede generar el documento' {&Codigo} 'serie' {&Serie}
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
END.

IF INTEGRAL.FacCorre.FlgCic = YES THEN DO:
    /* REGRESAMOS AL NUMERO 1 */
    IF INTEGRAL.FacCorre.NroFin > 0 AND INTEGRAL.FacCorre.Correlativo > INTEGRAL.FacCorre.NroFin THEN DO:
        IF INTEGRAL.FacCorre.NroIni > 0 THEN INTEGRAL.FacCorre.Correlativo = INTEGRAL.FacCorre.NroIni.
        ELSE INTEGRAL.FacCorre.Correlativo = 1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


