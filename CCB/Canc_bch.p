&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

DEFINE INPUT  PARAMETER X-Rowid AS ROWID.
DEF OUTPUT PARAMETER x-nrodoc LIKE CcbCDocu.NroDoc.
DEF OUTPUT PARAMETER X-OK    AS LOGICAL.

DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
MESSAGE "TERCERO" VIEW-AS ALERT-BOX.
DEFINE QUERY CANCELA FOR FacCPedM.
OPEN QUERY CANCELA FOR EACH FacCPedM WHERE ROWID(FacCPedM) = X-ROWID NO-LOCK.
MESSAGE "CUARTO" VIEW-AS ALERT-BOX.

  GET FIRST CANCELA NO-LOCK.
/*  IF S-USER-ID = 'COMPUTO' THEN 
 *      RUN ccb/d-cancpr (FacCPedM.codmon, FacCPedM.imptot,FacCPedM.Cmpbnte,FacCPedM.CodCli, OUTPUT X-OK).
 *   ELSE*/
     RUN ccb/d-canc03 (FacCPedM.codmon, FacCPedM.imptot,FacCPedM.Cmpbnte,FacCPedM.CodCli, OUTPUT x-nrodoc, OUTPUT X-OK).
MESSAGE "QUINTO" VIEW-AS ALERT-BOX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


