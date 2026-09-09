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

DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF INPUT PARAMETER pCodPed AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.

CASE pCodPed:
    WHEN 'COT' THEN DO:
        CASE pFlgEst:
            WHEN 'X' THEN pEstado = 'POR APROBAR'.
            WHEN 'P' THEN pEstado = 'APROBADO'.
            WHEN 'R' THEN pEstado = 'RECHAZADO'.
            WHEN 'A' THEN pEstado = 'ANULADO'.
            WHEN 'C' THEN pEstado = 'ATENDIDO'.
            WHEN 'T' THEN pEstado = 'EN TRAMITE'.
            WHEN 'S' THEN pEstado = 'SUSPENDIDO'.
            OTHERWISE pEstado = pFlgEst.
        END CASE.
    END.
    WHEN 'PED' THEN DO:
        CASE pFlgEst:
            WHEN 'X' THEN pEstado = 'POR APROBAR'.
            WHEN 'P' THEN pEstado = 'PENDIENTE'.
            WHEN 'R' THEN pEstado = 'RECHAZADO'.
            WHEN 'A' THEN pEstado = 'ANULADO'.
            WHEN 'C' THEN pEstado = 'CON O/DESPACHO'.
            WHEN 'S' THEN pEstado = 'SUSPENDIDO'.
            WHEN 'F' THEN pEstado = 'FACTURADO'.
            OTHERWISE pEstado = pFlgEst.
        END CASE.
    END.
    WHEN 'O/D' THEN DO:
        CASE pFlgEst:
            WHEN 'X' THEN pEstado = 'POR PICKEAR'.
            WHEN 'P' THEN pEstado = 'PICKEADO'.
            WHEN 'R' THEN pEstado = 'RECHAZADO'.
            WHEN 'A' THEN pEstado = 'ANULADO'.
            WHEN 'C' THEN pEstado = 'CERRADO'.
            WHEN 'S' THEN pEstado = 'SUSPENDIDO'.
            OTHERWISE pEstado = pFlgEst.
        END CASE.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


