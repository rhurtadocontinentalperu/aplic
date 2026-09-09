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
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* División Origen */

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
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = pCodCli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN DO:
    MESSAGE 'Cliente' pCodCli 'no registrado en el Maestro General de Clientes' SKIP(1)
        'Comunicarse con el Administrador o' SKIP
        'con el Gestor del Maestro de Clientes'
        VIEW-AS ALERT-BOX INFORMATION
        TITLE 'VERIFICACION DEL CLIENTE'.
    RETURN "ADM-ERROR".
END.

IF gn-clie.Libre_f01 <> ? AND gn-clie.Libre_f01 >= TODAY THEN DO:
    MESSAGE 'NO podemos emitir comprobantes el día de hoy porque el RUC aún NO está activo en SUNAT' SKIP
        'Fecha de inscrición SUNAT:' gn-clie.Libre_f01
        VIEW-AS ALERT-BOX INFORMATION
        TITLE 'VERIFICACION SUNAT'.
    RETURN 'ADM-ERROR'.
END.

/* *********************************************************** */
/* RHC 22/07/2020 El cliente cesado se va a ver por cada canal */
/* *********************************************************** */
DEF VAR LocalValidaCliente AS LOG NO-UNDO.

LocalValidaCliente = YES.
FIND gn-divi WHERE gn-divi.codcia = s-CodCia
    AND gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN DO:
    FIND Vtamcanal WHERE Vtamcanal.Codcia = s-CodCia 
        AND Vtamcanal.CanalVenta = gn-divi.CanalVenta
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtamcanal THEN LocalValidaCliente = Vtamcanal.ValidaCliente.
END.
IF LocalValidaCliente = YES THEN DO:
    IF gn-clie.FlgSit = "B" THEN DO:
        MESSAGE "Cliente esta Bloqueado" SKIP(1)
            'Comunicarse con el Gestor del Maestro de Clientes'
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'VERIFICACION DEL CLIENTE'.
        RETURN "ADM-ERROR".
    END.
    IF gn-clie.FlgSit = "I" THEN DO:
        MESSAGE "Cliente esta Inactivo" SKIP(1)
            'Comunicarse con el Administrador o' SKIP
            'con el Gestor del Maestro de Clientes'
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'VERIFICACION DEL CLIENTE'.
                    RETURN "ADM-ERROR".
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
        MESSAGE "Cliente esta Cesado" SKIP(1)
            'Comunicarse con el Administrador o' SKIP
            'con el Gestor del Maestro de Clientes'
            VIEW-AS ALERT-BOX INFORMATION
            TITLE 'VERIFICACION DEL CLIENTE'.
        RETURN "ADM-ERROR".
    END.
END.
/* *********************************************************** */
/* *********************************************************** */
CASE pCodDoc:
    WHEN 'COT' OR WHEN 'C/M' OR WHEN 'PET' THEN DO:
        FIND Vtalnegra WHERE Vtalnegra.codcia = s-codcia
            AND Vtalnegra.codcli = pCodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtalnegra THEN DO:            
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
DEF VAR pClienteOpenOrange AS LOG NO-UNDO.
RUN gn/clienteopenorange (cl-codcia, pCodCli, pCodDoc, OUTPUT pClienteOpenOrange).
IF pClienteOpenOrange = YES THEN DO:
    MESSAGE "Cliente NO se puede atender por Continental" SKIP
        "Solo se le puede atender por OpenOrange" SKIP(1)
        'Comunicarse con el Administrador o' SKIP
        'con el Gestor del Maestro de Clientes'
        VIEW-AS ALERT-BOX INFORMATION
        TITLE 'VERIFICACION DEL CLIENTE'.
    RETURN "ADM-ERROR".   
END.

/* 15/05/2023: Datos obligatorios
    Solo en caso de NO ser un cliente varios
 */
/* FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.                                                      */
/* IF AVAILABLE FacCfgGn AND FacCfgGn.CliVar <> gn-clie.codcli THEN DO:                                                        */
/*     DEF VAR x-Campos AS CHAR NO-UNDO.                                                                                       */
/*                                                                                                                             */
/*     IF TRUE <> (gn-clie.E-Mail > '') OR                                                                                     */
/*         TRUE <> (gn-clie.Transporte[4] > '') OR                                                                             */
/*         TRUE <> (gn-clie.Telfnos[1] > '') OR                                                                                */
/*         TRUE <> (gn-clie.Canal > '') OR                                                                                     */
/*         TRUE <> (gn-clie.GirCli > '') OR                                                                                    */
/*         TRUE <> (gn-clie.ClfCom > '') THEN DO:                                                                              */
/*         x-Campos = "Los siguientes datos NO están registrados en el Maestro General de Clientes:" + CHR(10).                */
/*         IF TRUE <> (gn-clie.E-Mail > '') THEN x-Campos = x-Campos + "- E-mail de contacto" + CHR(10).                       */
/*         IF TRUE <> (gn-clie.Transporte[4] > '') THEN x-Campos = x-Campos + "- E-mail de facturación electrónica" + CHR(10). */
/*         IF TRUE <> (gn-clie.Telfnos[1] > '') THEN x-Campos = x-Campos + "- Teléfono #1" + CHR(10).                          */
/*         IF TRUE <> (gn-clie.Canal > '') THEN x-Campos = x-Campos + "- Grupo de cliente" + CHR(10).                          */
/*         IF TRUE <> (gn-clie.GirCli > '') THEN x-Campos = x-Campos + "- Giro" + CHR(10).                                     */
/*         IF TRUE <> (gn-clie.ClfCom > '') THEN x-Campos = x-Campos + "- Sector económico" + CHR(10).                         */
/*         x-Campos = x-Campos + chr(10) +                                                                                     */
/*             'Comunicarse con el Administrador o' + CHR(10) +                                                                */
/*             'Comunicarse con el Gestor del Maestro de Clientes'.                                                            */
/*         MESSAGE x-Campos VIEW-AS ALERT-BOX INFORMATION TITLE 'VERIFICACION DEL CLIENTE'.                                    */
/*         RETURN "ADM-ERROR".                                                                                                 */
/*     END.                                                                                                                    */
/* END.                                                                                                                        */


RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


