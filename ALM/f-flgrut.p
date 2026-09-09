&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
         HEIGHT             = 4.15
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* Estado de las hojas de ruta */

/* ***************************  Main Block  *************************** */
  DEF INPUT PARAMETER cOrigen  AS CHAR.
  DEF INPUT PARAMETER cFlgEst  AS CHAR.
  DEF OUTPUT PARAMETER cEstado AS CHAR.

  CASE cOrigen:
    WHEN 'C' THEN DO:       /* Cabecera de Hoja de Ruta */
        CASE cFlgEst:
            WHEN 'X' THEN cEstado = 'Falta registra G/R'.
            WHEN 'E' THEN cEstado = 'Falta chequear bultos'.
            WHEN 'P' THEN cEstado = 'Emitido'.
            WHEN 'C' THEN cEstado = 'Cerrado'.
            WHEN 'A' THEN cEstado = 'Anulado'.
            OTHERWISE cEstado = '?'.
        END CASE.
    END.
    WHEN 'D' THEN DO:       /* Detalle  de Hoja de Ruta */
        CASE cFlgEst:
            WHEN 'P' OR WHEN 'E' THEN cEstado = 'Por Entregar'.
            WHEN 'C' THEN cEstado = 'Entregado'.
            WHEN 'D' THEN cEstado = 'Devolucion Parcial'.
            WHEN 'X' THEN cEstado = 'Devolucion Total'.
            WHEN 'N' THEN cEstado = 'No Entregado'.
            WHEN 'R' THEN cEstado = 'Error de Documento'.
            WHEN 'NR' THEN cEstado = 'No Recibido'.
            WHEN 'T' THEN cEstado = 'Dejado en Tienda'.
            OTHERWISE cEstado = '?'.
        END CASE.
    END.
  END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


