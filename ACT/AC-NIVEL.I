&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     : MCWADA
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


DEFINE VARIABLE Ac-NivFam  AS CHAR.
DEFINE VARIABLE Ac-NivMax  AS INTEGER.
DEFINE SHARED VAR s-CodCia AS INTEGER.
DEFINE VAR Nivel           AS INTEGER.
DEFINE VAR j               AS INTEGER.

FIND FIRST AC-CNFG WHERE AC-CNFG.CodCia = s-CodCia AND 
                         AC-CNFG.TpoCfg = "G"      AND
                         AC-CNFG.CodCfg = "FAM" NO-LOCK NO-ERROR.
                         
IF AVAILABLE AC-CNFG THEN DO :   
   REPEAT j = 1 TO NUM-ENTRIES( AC-CNFG.CodFam, "." ) :
          Nivel = Nivel + LENGTH( ENTRY ( j, AC-CNFG.CodFam, "." ) ).
          IF Ac-NivFam <> "" THEN Ac-NivFam = Ac-NivFam + ",".
          Ac-NivFam = Ac-NivFam + STRING ( Nivel , "9").
   END.        
   Ac-NivMax = Nivel.
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
         HEIGHT             = 2.01
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


