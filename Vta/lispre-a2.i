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

  IF vtacatcam.UndA <> "" THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = vtacatcam.UndBas
        AND  Almtconv.Codalter = vtacatcam.UndA
        NO-LOCK NO-ERROR.
    F-FACTOR = Almtconv.Equival.
  END.

  vtacatcam.PreVta[1] = IF vtacatcam.Chr__02 = "T"  THEN vtacatcam.PreVta[2] / F-FACTOR ELSE vtacatcam.PreVta[1].

  IF vtacatcam.AftIgv THEN 
    vtacatcam.PreBas = ROUND(vtacatcam.PreVta[1] / ( 1 + FacCfgGn.PorIgv / 100), 6).

  vtacatcam.MrgUti = ((vtacatcam.Prevta[1] / vtacatcam.Ctotot) - 1 ) * 100. 

  F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
  IF vtacatcam.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = vtacatcam.UndBas
                       AND  Almtconv.Codalter = vtacatcam.UndA
                      NO-LOCK NO-ERROR.
        F-FACTOR = Almtconv.Equival.
        vtacatcam.Dsctos[1] =  (((vtacatcam.Prevta[2] / F-FACTOR)/ vtacatcam.Prevta[1]) - 1 ) * 100. 
  END.


  F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
  IF vtacatcam.UndB <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = vtacatcam.UndBas
                       AND  Almtconv.Codalter = vtacatcam.UndB
                      NO-LOCK NO-ERROR.
        F-FACTOR = Almtconv.Equival.
        vtacatcam.Dsctos[2] =  (((vtacatcam.Prevta[3] / F-FACTOR)/ vtacatcam.Prevta[1]) - 1 ) * 100. 
  END.

  F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
  IF vtacatcam.UndC <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = vtacatcam.UndBas
                       AND  Almtconv.Codalter = vtacatcam.UndC
                      NO-LOCK NO-ERROR.
        F-FACTOR = Almtconv.Equival.
        vtacatcam.Dsctos[3] =  (((vtacatcam.Prevta[4] / F-FACTOR)/ vtacatcam.Prevta[1]) - 1 ) * 100. 
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


