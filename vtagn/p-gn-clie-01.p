&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Verificar que el cliente sea válido

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

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
         HEIGHT             = 3.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = pCodCli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE 'Cliente' pCodCli 'no registrado en el Maestro General de Clientes'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF gn-clie.FlgSit = "B" THEN DO:
    MESSAGE "Cliente esta Bloqueado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF gn-clie.FlgSit = "C" THEN DO:
    MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

CASE pCodDoc:
    WHEN 'COT' OR WHEN 'C/M' OR WHEN 'PET' THEN DO:
        FIND Vtalnegra WHERE Vtalnegra.codcia = s-codcia
            AND Vtalnegra.codcli = pCodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtalnegra THEN DO:            
            /* 25Jul2016, correo de Julissa Calderon */
            /*MESSAGE "Cliente en la lista negra, bloqueado para emitir Cotizaciones" VIEW-AS ALERT-BOX ERROR.*/
            /* 25Jul2016, correo de Julissa Calderon */
            MESSAGE "Cliente en la LISTA NEGRA del Area de Créditos" SKIP(1)
                'Comunicarse con el Gestor Créditos y Cobranzas'
                VIEW-AS ALERT-BOX INFORMATION
                TITLE 'VERIFICACION DEL CLIENTE'.
            RETURN "ADM-ERROR".
        END.
    END.
END CASE.

/* SOLO OPENORANGE */
/* DEF VAR pClienteOpenOrange AS LOG NO-UNDO.                                         */
/* RUN gn/clienteopenorange (cl-codcia, pCodCli, pCodDoc, OUTPUT pClienteOpenOrange). */
/*                                                                                    */
/* IF pClienteOpenOrange = YES THEN DO:                                               */
/*   MESSAGE "Cliente NO se puede atender por Continental" SKIP                       */
/*       "Solo se le puede atender por OpenOrange"                                    */
/*       VIEW-AS ALERT-BOX ERROR.                                                     */
/*   RETURN "ADM-ERROR".                                                              */
/* END.                                                                               */

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


