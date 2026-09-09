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

    IF T-MATG.UndA <> "" THEN DO:
      FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
          AND Almtconv.Codalter = T-MATG.UndA
          NO-LOCK NO-ERROR.
      F-FACTOR = Almtconv.Equival.
    END.
    T-MATG.PreVta[1] = IF T-MATG.Chr__02 = "T"  THEN T-MATG.PreVta[2] / F-FACTOR ELSE T-MATG.PreVta[1].
    IF T-MATG.AftIgv THEN T-MATG.PreBas = ROUND(T-MATG.PreVta[1] / ( 1 + FacCfgGn.PorIgv / 100), 6).
    T-MATG.MrgUti = ((T-MATG.Prevta[1] / T-MATG.Ctotot) - 1 ) * 100. 

    F-FACTOR = 1.
      /****   Busca el Factor de conversion   ****/
    IF T-MATG.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
            AND  Almtconv.Codalter = T-MATG.UndA
            NO-LOCK NO-ERROR.
        F-FACTOR = Almtconv.Equival.
        T-MATG.Dsctos[1] =  (((T-MATG.Prevta[2] / F-FACTOR)/ T-MATG.Prevta[1]) - 1 ) * 100. 
    END.
    F-FACTOR = 1.
      /****   Busca el Factor de conversion   ****/
    IF T-MATG.UndB <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
            AND  Almtconv.Codalter = T-MATG.UndB
            NO-LOCK NO-ERROR.
        F-FACTOR = Almtconv.Equival.
        T-MATG.Dsctos[2] =  (((T-MATG.Prevta[3] / F-FACTOR)/ T-MATG.Prevta[1]) - 1 ) * 100. 
    END.
    F-FACTOR = 1.
      /****   Busca el Factor de conversion   ****/
    IF T-MATG.UndC <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = T-MATG.UndBas
            AND  Almtconv.Codalter = T-MATG.UndC
            NO-LOCK NO-ERROR.
        F-FACTOR = Almtconv.Equival.
        T-MATG.Dsctos[3] =  (((T-MATG.Prevta[4] / F-FACTOR)/ T-MATG.Prevta[1]) - 1 ) * 100. 
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


