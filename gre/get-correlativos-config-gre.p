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

DEFINE INPUT PARAMETER pcTabla AS CHAR.
DEFINE INPUT PARAMETER pcLibre_c01 AS CHAR.
DEFINE INPUT PARAMETER pcLibre_c02 AS CHAR.
DEFINE INPUT PARAMETER pcLibre_c03 AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER piCorrelativo AS INT.

/* 
    piCorrelativo si viene con valor mayor a cero
    significa que en caso no existiera se crea el 
    registro con ese valor x default.
*/

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
  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = pcTabla AND
                            vtatabla.llave_c1 = pcLibre_c01 AND 
                            vtatabla.llave_c2 = pcLibre_c02 AND 
                            vtatabla.llave_c3 = pcLibre_c03 NO-LOCK NO-ERROR.

  IF LOCKED vtatabla THEN DO:      
      piCorrelativo = -1.
      RELEASE vtatabla NO-ERROR.
      RETURN ERROR-STATUS:GET-MESSAGE(1).
  END.

  IF NOT AVAILABLE vtatabla THEN DO:
      /*
      FIND CURRENT vtatabla EXCLUSIVE-LOCK NO-ERROR.
      IF LOCKED vtatabla THEN DO:      
          piCorrelativo = -1.
          RELEASE vtatabla NO-ERROR.
          RETURN ERROR-STATUS:GET-MESSAGE(1).
      END.
     

      iCorrelativo = if(iCorrelativo < 0) THEN 0 ELSE iCorrelativo.
     */
      CREATE vtatabla.
        ASSIGN vtatabla.codcia = s-codcia
                vtatabla.tabla = pcTabla
                vtatabla.llave_c1 = pcLibre_c01
                vtatabla.llave_c2 = pcLibre_c02
                vtatabla.llave_c3 = pcLibre_c03
                vtatabla.valor[1] = piCorrelativo
            .
  END.

  iCorrelativo = vtatabla.valor[1].

  /*
  IF iCorrelativo = 0 THEN iCorrelativo = iCorrelativo + 1.

  ASSIGN vtatabla.valor[1] = iCorrelativo + 1.
  */

  RELEASE vtatabla NO-ERROR.

  piCorrelativo = iCorrelativo.

  RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


