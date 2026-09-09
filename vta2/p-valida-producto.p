&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Validar que el producto se pueda vender

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodMat AS CHAR.

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.

DEF VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
s-VentaMayorista = GN-DIVI.VentaMayorista.

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

/* VALIDAMOS QUE EXISTA EN EL CATALOGO DE PRODUCTOS */
FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia
    AND Almmmatg.CodMat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Producto' pCodMat 'NO registrado en el catálogo'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* ROTACION AUTORIZADA */
IF NOT (Almmmatg.TpoArt <= s-FlgRotacion) THEN DO:
  MESSAGE "Producto no autorizado para venderse" 
      "Tipo de rotación:" Almmmatg.TpoArt
      VIEW-AS ALERT-BOX ERROR.
  RETURN "ADM-ERROR".
END.

/* VALIDA LA LINEA */
FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
IF AVAILABLE Almtfami AND Almtfami.SwComercial = NO THEN DO:
  MESSAGE 'El producto pertenece a una familia NO autorizada para ventas'
      'Familia:' Almtfami.codfam
      VIEW-AS ALERT-BOX ERROR.
  RETURN 'ADM-ERROR'.
END.
FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
IF AVAILABLE Almsfami AND AlmSFami.SwDigesa = YES 
  AND (Almmmatg.VtoDigesa = ? OR Almmmatg.VtoDigesa < TODAY) THEN DO:
  MESSAGE 'La fecha de DIGESA ya venció o no se ha registrado su vencimiento'
      'Vencimiento:' Almmmatg.VtoDigesa
      VIEW-AS ALERT-BOX ERROR.
  RETURN 'ADM-ERROR'.
END.

/* REGISTRADO EN LA LISTA DE PRECIOS MAYORISTA POR DIVISION */
IF s-VentaMayorista = 2 THEN DO:
    FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaListaMay THEN DO:
        MESSAGE 'El producto no está registrado en la lista de precios mayorista por división'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
END.


RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


