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

DEFINE OUTPUT PARAMETER piCorrelativo AS INT.

DEFINE SHARED VAR s-codcia AS INT.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  /* Correlativo */
  DEFINE VAR iCorrelativo AS INT.
  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'config-gre' AND
                            vtatabla.llave_c1 = 'CORRELATIVOS' AND vtatabla.llave_c2 = 'PRE-GRE' EXCLUSIVE-LOCK NO-ERROR.

  IF LOCKED vtatabla THEN DO:      
      piCorrelativo = -1.
      RELEASE vtatabla NO-ERROR.
      RETURN ERROR-STATUS:GET-MESSAGE(1).
  END.

  IF NOT AVAILABLE vtatabla THEN DO:      
      CREATE vtatabla.
        ASSIGN vtatabla.codcia = s-codcia
                vtatabla.tabla = 'CONFIG-GRE'
                vtatabla.llave_c1 = 'CORRELATIVOS'
                vtatabla.llave_c2 = 'PRE-GRE'
                vtatabla.valor[1] = 0
            .
  END.

  iCorrelativo = vtatabla.valor[1].

  IF iCorrelativo = 0 THEN iCorrelativo = iCorrelativo + 1.

  ASSIGN vtatabla.valor[1] = iCorrelativo + 1.

  RELEASE vtatabla NO-ERROR.

  piCorrelativo = iCorrelativo.

  RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


