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

            CASE x-Forma:
                WHEN "UNICO" THEN DO:
                    ASSIGN 
                        Facdpedi.PorDto  = 0
                        Facdpedi.PorDto2 = 0            /* el precio unitario */
                        Facdpedi.ImpIsc = 0
                        Facdpedi.ImpIgv = 0.
                    ASSIGN
                        Facdpedi.Por_Dsctos[1] = 0      /* NO del administrador */
                        Facdpedi.Por_Dsctos[3] = 0.     /* NO Dcto Prom o Vol */
                END.
                WHEN "ACUMULATIVO" THEN DO:
                    ASSIGN 
                        Facdpedi.ImpIsc = 0
                        Facdpedi.ImpIgv = 0.
                END.
            END CASE.
            /* 04/03/2024: C.Camus y V.Gonzales */
            CASE x-Forma2:
                WHEN "EXCLUYENTE" THEN DO:
                    ASSIGN
                        Facdpedi.Por_Dsctos[2] = Y-DSCTOS
                        Facdpedi.Libre_c04 = x-TipDto.
                END.
                WHEN "ACUMULADO" THEN DO:
                    Y-DSCTOS2 = 100 * ( 1 - ( (1 - Facdpedi.Por_Dsctos[2] / 100) * (1 - Y-DSCTOS / 100) ) ).
                    ASSIGN
                        Facdpedi.Por_Dsctos[2] = Y-DSCTOS2
                        Facdpedi.Libre_c04 = Facdpedi.Libre_c04 + (IF TRUE <> (Facdpedi.Libre_c04 > '') 
                                                                   THEN '' ELSE ',') + x-TipDto.
                END.
            END CASE.

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


