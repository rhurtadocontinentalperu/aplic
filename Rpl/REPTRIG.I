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
         HEIGHT             = 3.77
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/* Revisa tambien la rutina qoocostos.p */
   CREATE RepLog.
   ASSIGN RepLog.TransactionID = NEXT-VALUE(LogID)
          RepLog.TableName = "{&Table}"
          RepLog.KeyValue  = {&Key}
          RepLog.Event = "{&Event}"
          RepLog.LogDate = DATETIME(TODAY, MTIME)
          RepLog.FlgDB0 = {&FlgDb0}
          RepLog.FlgDB1 = {&FlgDb1}
          RepLog.FlgDB2 = {&FlgDb2}
          RepLog.FlgDB3 = {&FlgDb3}
          RepLog.FlgDB4 = {&FlgDb4}
          RepLog.FlgDB5 = {&FlgDb5}
          RepLog.FlgDB6 = {&FlgDb6}
          RepLog.FlgDB7 = {&FlgDb7}
          RepLog.FlgDB8 = {&FlgDb8}
          RepLog.FlgDB9 = {&FlgDb9}
          RepLog.FlgDB10 = {&FlgDb10}
          RepLog.FlgDB11 = {&FlgDb11}
          RepLog.FlgDB12 = {&FlgDb12}
          RepLog.FlgDB13 = {&FlgDb13}
          RepLog.FlgDB14 = {&FlgDb14}
          RepLog.FlgDB15 = {&FlgDb15}
          RepLog.FlgDB16 = {&FlgDb16}
          RepLog.FlgDB17 = {&FlgDb17}
          RepLog.FlgDB18 = {&FlgDb18}
          RepLog.FlgDB19 = {&FlgDb19}
          RepLog.FlgDB20 = {&FlgDb20}
          RepLog.FlgDB30 = {&FlgDb30}
          RepLog.RunProgram = "{&Prg}".

   RAW-TRANSFER {&Table} TO RepLog.DataRecord.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


