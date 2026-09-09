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

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "SELECCIONANDO: " + Almmmatg.codmat + " " + Almmmatg.desmat.
/* Filtro por Clasificación */
FIND FIRST FacTabla WHERE FacTabla.codcia = Almmmatg.codcia 
    AND FacTabla.tabla = 'RANKVTA' 
    AND FacTabla.codigo = Almmmatg.codmat
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN DO:
    IF s-Reposicion = YES /* Campaña */ THEN DO:
        IF COMBO-BOX-Tipo = "General" AND LOOKUP(factabla.campo-c[1],x-Clasificaciones) = 0 THEN NEXT.
        IF COMBO-BOX-Tipo = "Utilex" AND LOOKUP(factabla.campo-c[2],x-Clasificaciones) = 0 THEN NEXT.
        IF COMBO-BOX-Tipo = "Mayorista" AND LOOKUP(factabla.campo-c[3],x-Clasificaciones) = 0 THEN NEXT.
    END.
    ELSE DO:
        /* No Campaña */
        IF COMBO-BOX-Tipo = "General" AND LOOKUP(factabla.campo-c[4],x-Clasificaciones) = 0 THEN NEXT.
        IF COMBO-BOX-Tipo = "Utilex" AND LOOKUP(factabla.campo-c[5],x-Clasificaciones) = 0 THEN NEXT.
        IF COMBO-BOX-Tipo = "Mayorista" AND LOOKUP(factabla.campo-c[6],x-Clasificaciones) = 0 THEN NEXT.
    END.
END.
FIND FIRST T-MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE T-MATG THEN CREATE T-MATG.
BUFFER-COPY Almmmatg TO T-MATG.
RELEASE T-MATG.
PROCESS EVENTS.
IF Stop-It = YES THEN RETURN 'ADM-ERROR'.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


