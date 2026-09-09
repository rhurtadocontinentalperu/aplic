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

/* Pre-procesador para estandarizar el manejo de errores */
&Scoped-define CHECK-ERROR ~
    IF ERROR-STATUS:ERROR THEN DO: ~
        MESSAGE "FALLO EN SISTEMA:" RETURN-VALUE VIEW-AS ALERT-BOX ERROR. ~
        RETURN. ~
    END.

/* pedido_master.i - Definición centralizada */

DEFINE TEMP-TABLE ttPedido NO-UNDO
    FIELD IdPedido  AS INTEGER   LABEL "ID"
    FIELD Articulo  AS CHARACTER LABEL "Artículo"
    FIELD Cantidad  AS INTEGER   LABEL "Cant."
    FIELD Precio    AS DECIMAL   LABEL "Precio"
    FIELD Total     AS DECIMAL   LABEL "Total"
    INDEX idxMain IS PRIMARY UNIQUE IdPedido.

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


