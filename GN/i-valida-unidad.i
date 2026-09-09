&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Validación de la unidad de medida

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Buscamos la unidad el la tabla de unidades */
FIND Unidades WHERE Unidades.Codunid = {&Unidad} NO-LOCK NO-ERROR.
IF NOT AVAILABLE Unidades THEN DO:
    MESSAGE 'TRIGGER WRITE: Unidad ' + {&Unidad} ' NO registrada' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF Unidades.Libre_l01 = YES THEN DO:
    MESSAGE 'TRIGGER WRITE: Unidad ' + {&Unidad} ' inactivada' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* Control de las Unidades Base */
IF (INDEX("{&Unidad}", "UndBas") > 0 OR INDEX("{&Unidad}", "UndStk") > 0)
    AND Unidades.Libre_l03 = NO THEN DO:
    MESSAGE 'TRIGGER WRITE: Unidad ' + {&Unidad} ' NO es una unidad base' 
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

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
         HEIGHT             = 4.04
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


