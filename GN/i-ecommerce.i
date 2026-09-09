&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*    
    Description : Conectarse a la base de datos de interfaces con e-commerce
                  Crear un registro de log si ha habido cambio de precios
*/

/* Parámetros:
    &NewBuffer="VtaListaMay"
    &OldBuffer="OldVtaListaMay"
    &Origen="U"     Precio Utilex       "E" Precio E-Commerce

*/

/* IF {&NewBuffer}.PreOfi <> {&OldBuffer}.PreOfi AND {&NewBuffer}.CodMat > ''                          */
/*     THEN DO:                                                                                        */
/*     /* Conectar la base de datos primero */                                                         */
/*     IF CONNECTED("ecommerce") THEN DISCONNECT ecommerce.                                            */
/*     CONNECT -db ecommerce -ld ecommerce -N TCP -S 65020 -H 192.168.100.242 NO-ERROR.                */
/*     IF ERROR-STATUS:ERROR THEN DO:                                                                  */
/*         MESSAGE "NO se pudo conectar con la tabla intermedia para E-Commerce"                       */
/*             VIEW-AS ALERT-BOX ERROR.                                                                */
/*         RETURN ERROR.                                                                               */
/*     END.                                                                                            */
/*     CREATE ecommerce.ec_precios.                                                                    */
/*     ASSIGN                                                                                          */
/*         ecommerce.ec_precios.CodCia = s-CodCia                                                      */
/*         ecommerce.ec_precios.CodMat = {&NewBuffer}.CodMat                                           */
/*         ecommerce.ec_precios.FlagFechaHora = NOW                                                    */
/*         ecommerce.ec_precios.FlagMigracion = "N"                                                    */
/*         ecommerce.ec_precios.FlagUsuario = s-User-Id                                                */
/*         ecommerce.ec_precios.LogDate = TODAY                                                        */
/*         ecommerce.ec_precios.LogTime = STRING(TIME,'HH:MM:SS')                                      */
/*         ecommerce.ec_precios.LogUser = s-User-Id                                                    */
/*         ecommerce.ec_precios.TpoCmb = {&NewBuffer}.TpoCmb                                           */
/*         ecommerce.ec_precios.MonVta = {&NewBuffer}.MonVta                                           */
/*         ecommerce.ec_precios.Origen = "{&Origen}".                                                  */
/*     CASE ecommerce.ec_precios.Origen:                                                               */
/*         WHEN "E" THEN DO:   /* El origen es la lista de precio 00506 de la tabla vtalistamay */     */
/*             DEF BUFFER B-ListaMinGn FOR INTEGRAL.VtaListaMinGn.                                     */
/*             ecommerce.ec_precios.PreOfi506 = {&NewBuffer}.PreOfi.                                   */
/*             FIND B-ListaMinGn WHERE B-ListaMinGn.CodCia = s-CodCia AND                              */
/*                 B-ListaMinGn.codmat = {&NewBuffer}.CodMat                                           */
/*                 NO-LOCK NO-ERROR.                                                                   */
/*             IF AVAILABLE B-ListaMinGn THEN ecommerce.ec_precios.PreOfiUtilex = B-ListaMinGn.PreOfi. */
/*         END.                                                                                        */
/*         WHEN "U" THEN DO:   /* El origen es la lista de precio UTILEX de la tabla vtalistamingn */  */
/*             DEF BUFFER B-ListaMay FOR INTEGRAL.VtaListaMay.                                         */
/*             ecommerce.ec_precios.PreOfiUtilex = {&NewBuffer}.PreOfi.                                */
/*             FIND B-ListaMay WHERE B-ListaMay.CodCia = s-CodCia AND                                  */
/*                 B-ListaMay.CodDiv = "00506" AND                                                     */
/*                 B-ListaMay.CodMat = {&NewBuffer}.CodMat                                             */
/*                 NO-LOCK NO-ERROR.                                                                   */
/*             IF AVAILABLE B-ListaMay THEN ecommerce.ec_precios.PreOfi506 = B-ListaMay.PreOfi.        */
/*         END.                                                                                        */
/*     END CASE.                                                                                       */
/*     DISCONNECT ecommerce.                                                                           */
/* END.                                                                                                */

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
         HEIGHT             = 3.96
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


