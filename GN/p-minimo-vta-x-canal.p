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


DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pListaPrecio AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pFecha AS DATE.         /* Acepta Nulos ? */
DEF OUTPUT PARAMETER pImpMin AS DEC.

/* Verificar si es lista de Precio */
pImpMin = 0.00.
FIND FIRST gn-divi WHERE gn-divi.codcia = pCodCia AND 
                            gn-divi.coddiv = pListaPrecio NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN DO:
    IF gn-divi.canalventa <> "FER" THEN DO:
        RETURN.
    END.
    /*LOOKUP(gn-divi.campo-char[1],"L,A") = 0*/
END.

DEFINE VAR x-tabla AS CHAR INIT "IMP-MINIMO-VTA".

IF pFecha = ? THEN pFecha = TODAY.

pImpMin = 999999999.00.
BUSCAR:
FOR EACH vtatabla WHERE vtatabla.codcia = pCodCia AND
                        vtatabla.tabla = x-tabla AND 
                        vtatabla.llave_c1 = pListaPrecio AND
                        vtatabla.llave_c2 = pCodDoc NO-LOCK:
    IF pFecha >= vtatabla.rango_fecha[1] AND pFecha <= vtatabla.rango_fecha[2] THEN DO:
        pImpMin = vtatabla.valor[1].
        LEAVE BUSCAR.
    END.
END.

RETURN.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


