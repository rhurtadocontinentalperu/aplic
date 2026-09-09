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
         HEIGHT             = 3.77
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.


CASE pFlgEst:
    WHEN 'A' THEN pEstado = 'ANULADO'.
    WHEN 'C' THEN pEstado = 'CANCELADO'.
    WHEN 'E' THEN pEstado = 'POR APROBAR'.   /*'EMITIDO'.*/
    WHEN 'F' THEN pEstado = 'FACTURADO'.
    WHEN 'J' THEN pEstado = 'LEGAL'.
    WHEN 'P' THEN pEstado = 'PENDIENTE'.        /* Para PNC es aprobado */
    WHEN 'R' THEN pEstado = 'RECHAZADO'.
    WHEN 'S' THEN pEstado = 'CASTIGADO'.
    WHEN 'T' THEN pEstado = 'GENERADA'.         
    WHEN 'D' THEN pEstado = 'EN PROCESO'.
    WHEN 'AP' THEN pEstado = 'ACEPTACION PARCIAL'.
    WHEN 'X' THEN pEstado = 'CERRADO'.

    OTHERWISE pEstado = pFlgEst.
END CASE.
/*
   
   Falta definir estos estados(P,R,G,A,AP) para la PNC
   
    x-codigo-estados = "E,T,D,P,R,G,A,AP".
    x-descripcion-estados = "POR APROBAR,GENERADA,EN PROCESO,APROBADO,RECHAZADO,N/C GENERADA,ANULADA,ACEPTACION PARCIAL".
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


