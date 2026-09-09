&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* 
    PRIMERA PARTE: Actualiza la lista de Precios A, B y C 
    NOTA: Compilar LISTA DE PRECIOS POR PROVEEDOR y LISTA DE PRECIOIS MAYORISTA
*/    

  F-Factor = 1.
  IF Almmmatg.UndA <> "" THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatg.UndA
        NO-LOCK NO-ERROR.
    IF AVAILABLE ALmtconv THEN F-FACTOR = Almtconv.Equival.
  END.

  Almmmatg.PreVta[1] = IF Almmmatg.Chr__02 = "T"  THEN Almmmatg.PreVta[2] / F-FACTOR ELSE Almmmatg.PreVta[1].

  IF Almmmatg.AftIgv THEN 
    Almmmatg.PreBas = ROUND(Almmmatg.PreVta[1] / ( 1 + FacCfgGn.PorIgv / 100), 6).

  Almmmatg.MrgUti = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100. 

  F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
  IF Almmmatg.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                       AND  Almtconv.Codalter = Almmmatg.UndA
                      NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        Almmmatg.Dsctos[1] =  (((Almmmatg.Prevta[2] / F-FACTOR)/ Almmmatg.Prevta[1]) - 1 ) * 100. 
  END.


  F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
  IF Almmmatg.UndB <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                       AND  Almtconv.Codalter = Almmmatg.UndB
                      NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        Almmmatg.Dsctos[2] =  (((Almmmatg.Prevta[3] / F-FACTOR)/ Almmmatg.Prevta[1]) - 1 ) * 100. 
  END.

  F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
  IF Almmmatg.UndC <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                       AND  Almtconv.Codalter = Almmmatg.UndC
                      NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
        Almmmatg.Dsctos[3] =  (((Almmmatg.Prevta[4] / F-FACTOR)/ Almmmatg.Prevta[1]) - 1 ) * 100. 
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


