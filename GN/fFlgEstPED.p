&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : FLag s Estado del PED

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

DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.

/*
    En desuso, ver vta2/p-faccpedi-flgest 27Nov2019
*/

CASE pFlgEst:
    WHEN 'A' THEN pEstado = 'ANULADO'.
    WHEN 'X' THEN pEstado = 'POR APROBAR'.
    WHEN 'P' THEN pEstado = 'APROBADO'.
    WHEN 'C' THEN pEstado = 'CON O/D'.
    WHEN 'F' THEN pEstado = 'FACTURADO'.
    WHEN 'E' THEN pEstado = 'CERRADO'.
    WHEN 'G' THEN pEstado = 'EMITIDO'.
    OTHERWISE pEstado = pFlgEst.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


