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

{&ListaSeries} = "".
FOR EACH INTEGRAL.FacCorre NO-LOCK WHERE INTEGRAL.FacCorre.CodCia = {&CodCia}
    AND INTEGRAL.FacCorre.CodDiv = {&CodDiv}
    AND INTEGRAL.FacCorre.CodDoc = {&CodDoc}
    AND ({&FlgEst} = "TODOS" OR INTEGRAL.FacCorre.FlgEst = YES):
    IF INTEGRAL.FacCorre.CodDoc = "G/R" AND INTEGRAL.FacCorre.NroSer = 000 THEN NEXT.
    IF LOOKUP({&CodDoc}, 'FAC,BOL') > 0 AND TRUE <> (INTEGRAL.FacCorre.ID_Pos > "") THEN NEXT.
    IF {&Tipo} > "" AND INTEGRAL.FacCorre.ID_Pos <> {&Tipo} THEN NEXT.
    IF {&ListaSeries} = "" THEN {&ListaSeries} = STRING(INTEGRAL.FacCorre.NroSer,"999").
    ELSE {&ListaSeries} = {&ListaSeries} + "," + STRING(INTEGRAL.FacCorre.NroSer,"999").
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
         HEIGHT             = 4.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


