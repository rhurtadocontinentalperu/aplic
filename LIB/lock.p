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


Def input parameter     Filename as CHAR  NO-UNDO.
Def input parameter     R        as ROWID NO-UNDO.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

&SCOP   lock        When "~{&FileName}" then do :           ~
            Find ~{&Filename} where ROWID(~{&Filename}) = R ~
                          EXCLUSIVE-LOCK NO-ERROR NO-WAIT.  ~
            If LOCKED ~{&FileName} then                     ~
                          RETURN "ERROR".                   ~
            end.
            
CASE FileName :
    &SCOP Filename customer
        {&lock}
    &SCOP Filename order
        {&lock}
    &SCOP Filename invoice
        {&lock}
    &SCOP Filename salesrep
        {&lock}
    &SCOP Filename item
        {&lock}
    &SCOP Filename order-line
        {&lock}
    &SCOP Filename almacen
        {&lock}
    END CASE.

RETURN "".          /* To reset the Return status */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


