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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pUserId AS CHAR.
DEF OUTPUT PARAMETER pDtoMax AS DEC.

DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-codcia AS INT.

DEF VAR s-nivel AS CHAR NO-UNDO.

FIND FacUsers WHERE Facusers.codcia = s-codcia
    AND FacUsers.Usuario = pUserId
    NO-LOCK.
s-nivel = SUBSTRING(FacUsers.Niveles,1,2).

/*ML01* Inicio de bloque ***/
FIND gn-clieds WHERE gn-clieds.CodCia = cl-CodCia 
    AND gn-clieds.CodCli = pCodCli 
    AND ( (gn-clieds.fecini = ? AND gn-clieds.fecfin = ?) 
          OR (gn-clieds.fecini = ? AND gn-clieds.fecfin >= TODAY) 
          OR (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin = ?) 
          OR (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin >= TODAY))
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clieds THEN DO:
    pDtoMax = gn-clieds.dscto.
END.
ELSE DO:
    /*ML01* Fin de bloque ***/
    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    FIND Almtabla WHERE almtabla.Tabla =  "NA" 
        AND almtabla.Codigo = s-nivel
        NO-LOCK NO-ERROR.
    CASE almtabla.Codigo:
        WHEN "D1" THEN pDtoMax = FacCfgGn.DtoMax.
        WHEN "D2" THEN pDtoMax = FacCfgGn.DtoDis.
        WHEN "D3" THEN pDtoMax = FacCfgGn.DtoMay.
        WHEN "D4" THEN pDtoMax = FacCfgGn.DtoPro.
        OTHERWISE DO:
            MESSAGE "Nivel de Usuario no existe : " s-nivel
                VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


