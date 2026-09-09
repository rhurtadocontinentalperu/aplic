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

/* Variables Generales */
DEF NEW SHARED VAR s-Create-Record AS LOG.
DEF NEW SHARED VAR s-Write-Record AS LOG.
DEF NEW SHARED VAR s-Delete-Record AS LOG.
DEF NEW SHARED VAR s-Confirm-Record AS LOG.
DEF NEW SHARED VAR s-CodMnu AS CHAR.

DEF SHARED VAR s-Aplic-Id AS CHAR.
DEF SHARED VAR s-User-Id AS CHAR.
DEF SHARED VAR s-Prog-Name AS CHAR.
DEF SHARED VAR s-Seguridad AS CHAR.
/*DEF SHARED VAR s-CodMnu AS CHAR.*/

ASSIGN
    s-Create-Record = NO
    s-Write-Record = NO
    s-Delete-Record = NO
    s-Confirm-Record = NO.

/* Buscamos permisos */
FIND pf-g007 WHERE pf-g007.Aplic-Id = s-aplic-id AND
    pf-g007.CodMnu = s-codmnu AND
    pf-g007.USER-ID = s-user-id
    NO-LOCK NO-ERROR.
IF AVAILABLE pf-g007 THEN
    ASSIGN
    s-Create-Record = pf-g007.p_Create 
    s-Write-Record = pf-g007.p_Write 
    s-Delete-Record = pf-g007.p_Delete 
    s-Confirm-Record = pf-g007.p_Confirm.

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
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


