&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DPedi LIKE FacDPedi.



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

DEFINE INPUT PARAMETER pcCodDoc AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcNroDoc AS CHARACTER NO-UNDO.

DEFINE SHARED VARIABLE s-User-Id AS CHARACTER.

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
   Temp-Tables and Buffers:
      TABLE: T-DPedi T "SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
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

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":
    FOR EACH T-DPedi NO-LOCK:
        CREATE trmovhist.
        ASSIGN
            trmovhist.canate = T-DPedi.canate
            trmovhist.CanPed = T-DPedi.canped
            trmovhist.CanPick = T-DPedi.CanPick
            trmovhist.CodCia = T-DPedi.CodCia
            trmovhist.CodDoc = pcCodDoc
            trmovhist.codmat = T-DPedi.codmat
            trmovhist.fecha = DATETIME(TODAY, MTIME)
            trmovhist.FlgEst = T-DPedi.FlgEst
            trmovhist.Libre_c01 = T-DPedi.Libre_c01
            trmovhist.Libre_c02 = T-DPedi.Libre_c02
            trmovhist.Libre_c03 = T-DPedi.Libre_c03
            trmovhist.Libre_c04 = T-DPedi.Libre_c04
            trmovhist.Libre_c05 = T-DPedi.Libre_c05
            trmovhist.Libre_d01 = T-DPedi.Libre_d01
            trmovhist.Libre_d02 = T-DPedi.Libre_d02
            trmovhist.Libre_f01 = T-DPedi.Libre_f01
            trmovhist.Libre_f02 = T-DPedi.Libre_f02
            trmovhist.NroDoc = pcNroDoc
            trmovhist.NroItm = T-DPedi.NroItm
            trmovhist.PorDto = T-DPedi.PorDto
            trmovhist.PorDto2 = T-DPedi.PorDto2
            trmovhist.PreBas = T-DPedi.PreBas
            trmovhist.PreUni = T-DPedi.PreUni
            trmovhist.PreVta[1] = T-DPedi.PreVta[1]
            trmovhist.PreVta[2] = T-DPedi.PreVta[2]
            trmovhist.PreVta[3] = T-DPedi.PreVta[3]
            trmovhist.programa = PROGRAM-NAME(1)
            trmovhist.tpotrans = "APROB_SUPER"
            trmovhist.trnbr = NEXT-VALUE(trMovSeq01)
            trmovhist.usuario = s-user-id.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


