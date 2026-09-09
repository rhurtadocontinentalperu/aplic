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

DEF SHARED VAR s-CodCia AS INT.

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
         HEIGHT             = 5.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Flag-Situacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Flag-Situacion Procedure 
PROCEDURE Flag-Situacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFlgSit AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.

CASE pFlgSit:
    WHEN "PR" THEN pEstado = "POR ASIGNAR CHEQUEO".     /* Recepcionado */
    WHEN "PT" THEN pEstado = "EN COLA DE CHEQUEO".      /* Se le asignó una mesa */
    WHEN "PX" THEN pEstado = "EN PROCESO DE CHEQUEO".   /* Lo están chequeando */
    WHEN "PE" THEN pEstado = "CHEQUEADO".               /* Pero necesita EMBALADO */
    WHEN "PC" THEN pEstado = "TERMINADO".               /* Listo para despachar */
    WHEN "C" THEN pEstado = "DESPACHO".                 /* Salida de Distribución */
    OTHERWISE pEstado = pFlgSit + ": POR DEFINIR".
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Lee-Barra-Orden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Lee-Barra-Orden Procedure 
PROCEDURE Lee-Barra-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodBarra AS CHAR.
DEF OUTPUT PARAMETER pCodDoc AS CHAR.
DEF OUTPUT PARAMETER pNroDoc AS CHAR.

/* Buscamos si el código de documento está registrado */
DEF VAR LocalItem AS INT NO-UNDO.
DEF VAR LocalCodigo AS CHAR NO-UNDO.

DO LocalItem = 1 TO LENGTH(pCodBarra):
    LocalCodigo = SUBSTRING(pCodBarra,1,LocalItem).
    FIND FIRST FacDocum WHERE FacDocum.CodCia = s-CodCia AND
        Facdocum.codcta[8] = LocalCodigo
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacDocum THEN DO:
        pCodDoc = FacDocum.CodDoc.
        pNroDoc = SUBSTRING(ENTRY(1,pCodBarra,'-'),LocalItem + 1).
        LEAVE.
    END.
END.
IF NOT AVAILABLE FacDocum THEN RETURN 'ADM-ERROR'.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

