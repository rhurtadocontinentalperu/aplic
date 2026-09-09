&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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
DEF INPUT PARAMETER pRowid AS ROWID.

/* DISABLE TRIGGERS FOR LOAD OF cissac.almmmatg.                           */
/*                                                                         */
/* FIND integral.Almmmatg WHERE ROWID(integral.Almmmatg) = pRowid NO-LOCK. */
/* FIND cissac.almmmatg OF integral.almmmatg NO-LOCK NO-ERROR.             */
/* IF NOT AVAILABLE cissac.almmmatg THEN DO:                               */
/*     CREATE cissac.Almmmatg.                                             */
/*     BUFFER-COPY integral.Almmmatg                                       */
/*         TO cissac.Almmmatg                                              */
/*         ASSIGN                                                          */
/*         cissac.Almmmatg.Libre_d05 = 1.                                  */
/* END.                                                                    */

/* RHC 12/06/2015 */
FIND Almmmatg WHERE ROWID(Almmmatg) = pRowid NO-LOCK.
FIND almmmatgci OF almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE almmmatgci THEN DO:
    CREATE Almmmatgci.
    BUFFER-COPY Almmmatg
        TO AlmmmatgCi
        ASSIGN
        AlmmmatgCi.Libre_d05 = 1.
END.

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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


