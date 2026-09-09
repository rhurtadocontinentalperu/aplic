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

            CREATE CcbDMvto.
            ASSIGN
                CcbDMvto.CodCia = CcbPenDep.CodCia
                CcbDMvto.CodDoc = CcbPenDep.CodRef
                CcbDMvto.NroDoc = CcbPenDep.NroRef
                CcbDMvto.TpoRef = CcbPenDep.CodDoc
                CcbDMvto.CodRef = CcbPenDep.CodDoc
                CcbDMvto.NroRef = CcbPenDep.NroDoc
                CcbDMvto.CodDiv = CcbPenDep.CodDiv
                CcbDMvto.NroDep = FILL-IN-NroOpe
                CcbDMvto.FchEmi = F-Fecha
                CcbDMvto.DepNac[1] = CcbPenDep.SdoNac
                CcbDMvto.DepUsa[1] = CcbPenDep.SdoUSA
                CcbDMvto.FchCie = CcbPenDep.FchCie
                CcbDMvto.HorCie = CcbPenDep.HorCie
                CcbDMvto.FlgEst = "C"   /* OJO: Confirmado */
                CcbDMvto.codbco = F-Banco
                CcbDMvto.CodCta = F-Cta
                CcbDMvto.usuario = s-user-id.
            IF AVAILABLE CcbCCaja THEN CcbDMvto.CodCli = CcbCCaja.CodCli.
            /* Actualiza Flag CcbPenDep */
            ASSIGN
                CcbPenDep.FlgEst = "C"
                CcbPenDep.SdoNac = 0
                CcbPenDep.SdoUSA = 0.

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
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


