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

DEFINE INPUT PARAMETER pcLibre_c01 AS CHAR.
DEFINE INPUT PARAMETER pcLibre_c02 AS CHAR.
DEFINE INPUT PARAMETER pcLibre_c03 AS CHAR.
DEFINE INPUT PARAMETER pTipoDato AS CHAR.       /* C:Caracter, N:Numerico, D:Date */
DEFINE INPUT PARAMETER pDatoDefault AS CHAR.  
DEFINE OUTPUT PARAMETER pReturnDato AS CHAR.

/* 

    Retorna:

    C: libre_c01
    N: String(Valor[1])
    D: string(Rango_fecha[1],"99/99/9999")
*/

DEFINE VAR cTabla AS CHAR INIT "CONFIG-GRE".

DEFINE SHARED VAR s-codcia AS INT.

pReturnDato = "ERROR".

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
         HEIGHT             = 8.73
         WIDTH              = 40.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/*
    C: libre_c01
    N: String(Valor[1])
    D: string(Rango_fecha[1],"99/99/9999")
*/

IF LOOKUP(pTipoDato,"C,N,D") = 0 THEN DO:
    RETURN "ADM-ERROR".
END.
        
/* cTabla = "CONFIG-GRE". */

FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = cTabla AND
                            vtatabla.llave_c1 = pcLibre_c01 AND 
                            vtatabla.llave_c2 = pcLibre_c02 AND 
                            vtatabla.llave_c3 = pcLibre_c03 NO-LOCK NO-ERROR.

IF LOCKED vtatabla THEN DO:      
    RETURN "ADM-ERROR".
END.

IF NOT AVAILABLE vtatabla THEN DO:
  CREATE vtatabla.
    ASSIGN vtatabla.codcia = s-codcia
            vtatabla.tabla = cTabla
            vtatabla.llave_c1 = pcLibre_c01
            vtatabla.llave_c2 = pcLibre_c02
            vtatabla.llave_c3 = pcLibre_c03.

    CASE pTipoDato:
        WHEN "N" THEN DO:
            IF TRUE <> (pDatoDefault > "") THEN pDatoDefault = "0".
            ASSIGN vtatabla.valor[1] = DECIMAL(pDatoDefault).
        END.
        WHEN "D" THEN DO:
            IF TRUE <> (pDatoDefault > "") THEN pDatoDefault = STRING(TODAY,"99/99/9999").
            ASSIGN vtatabla.rango_fecha[1] = DATE(pDatoDefault).
        END.
        WHEN "C" THEN DO:
            ASSIGN vtatabla.libre_c01 = pDatoDefault.
        END.
    END CASE.
END.

CASE pTipoDato:
  WHEN "N" THEN DO:
      pReturnDato = STRING(vtatabla.valor[1]).
  END.
  WHEN "D" THEN DO:
      pReturnDato = STRING(vtatabla.rango_fecha[1],"99/99/9999").
  END.
  WHEN "C" THEN DO:
      pReturnDato = vtatabla.libre_c01.
  END.
END CASE.

RELEASE vtatabla NO-ERROR.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


