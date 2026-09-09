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
         HEIGHT             = 3.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* RHC 14/10/2013 Se busca el último registro válido */    

/* Trata de bloquear hasta 5 veces */
{lib/lock.i &Tabla="FacCorre" &Condicion="FacCorre.CodCia = s-CodCia AND ~
    FacCorre.CodDoc = {&Codigo} AND ~
    FacCorre.NroSer = {&Serie}"}

IF FacCorre.FlgCic = NO THEN DO:
    IF FacCorre.NroFin > 0 AND FacCorre.Correlativo > FacCorre.NroFin THEN DO:
        MESSAGE 'Se ha llegado al límite del correlativo:' FacCorre.NroFin SKIP
            'No se puede generar el documento' {&Codigo} 'serie' {&Serie}
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
END.

IF FacCorre.FlgCic = YES THEN DO:
    /* REGRESAMOS AL NUMERO 1 */
    IF FacCorre.NroFin > 0 AND FacCorre.Correlativo > FacCorre.NroFin THEN DO:
        IF FacCorre.NroIni > 0 THEN FacCorre.Correlativo = FacCorre.NroIni.
        ELSE FacCorre.Correlativo = 1.
    END.
END.

REPEAT:
    IF NOT CAN-FIND(FIRST FacCPedi WHERE FacCPedi.codcia = s-codcia
                    AND FacCPedi.coddiv = FacCorre.coddiv
                    AND FacCPedi.coddoc = FacCorre.coddoc
                    AND FacCPedi.nroped = STRING(FacCorre.nroser, '999') + 
                    STRING(FacCorre.correlativo, '999999')
                    NO-LOCK)
        THEN LEAVE.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
END.

/* CASE FacCorre.coddoc:                                                          */
/*     WHEN "COT" OR WHEN "PED" OR WHEN "P/M" THEN DO:                            */
/*         REPEAT:                                                                */
/*             IF NOT CAN-FIND(FIRST FacCPedi WHERE FacCPedi.codcia = s-codcia    */
/*                         AND FacCPedi.coddiv = FacCorre.coddiv                  */
/*                         AND FacCPedi.coddoc = FacCorre.coddoc                  */
/*                         AND FacCPedi.nroped = STRING(FacCorre.nroser, '999') + */
/*                         STRING(FacCorre.correlativo, '999999')                 */
/*                         NO-LOCK)                                               */
/*                 THEN LEAVE.                                                    */
/*             ASSIGN                                                             */
/*                 FacCorre.Correlativo = FacCorre.Correlativo + 1.               */
/*         END.                                                                   */
/*     END.                                                                       */
/* END CASE.                                                                      */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


