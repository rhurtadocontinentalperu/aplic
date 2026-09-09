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

  /* guardamos la ultima ubicacion del activo */
  ASSIGN
      ac-parti.UbiAct = '@@'
      ac-parti.NroPap = ''
      AC-PARTI.TipMov = ''.
  FOR EACH b-dpape OF ac-parti USE-INDEX Llave02 NO-LOCK,
      FIRST b-cpape OF b-dpape NO-LOCK WHERE b-cpape.flag <> 'A':
      ASSIGN
          AC-PARTI.DivAct = b-cpape.CodDiv
          AC-PARTI.TipMov = b-cpape.TipMov
          AC-PARTI.NroPap = STRING(b-dpape.nroser, '999') + STRING(b-dpape.nrodoc, '999999')
          AC-PARTI.UbiAct = b-cpape.CCosto_Destino.
  END.
  RELEASE ac-parti.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


