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
IF Local_Delta <> 0 THEN DO:
    /* Revisamos detalle por detalle a ver donde aplicamos la diferencia */
    FOR EACH {&DetalleAjuste} OF {&CabeceraAjuste} EXCLUSIVE-LOCK WHERE {&DetalleAjuste}.ImpLin <> {&DetalleAjuste}.cImporteTotalConImpuesto:
        CASE {&DetalleAjuste}.cTipoAfectacion:
            WHEN "EXONERADA" THEN {&DetalleAjuste}.cImporteVentaExonerado = {&DetalleAjuste}.cImporteVentaExonerado + Local_Delta.
            WHEN "GRATUITA" THEN {&DetalleAjuste}.cImporteVentaGratuito = {&DetalleAjuste}.cImporteVentaGratuito + Local_Delta.
            OTHERWISE DO:
                {&DetalleAjuste}.cImporteTotalConImpuesto = {&DetalleAjuste}.cImporteTotalConImpuesto + Local_Delta.
            END.
        END CASE.
/*         ASSIGN                                                                                                 */
/*             {&DetalleAjuste}.cImporteTotalConImpuesto = {&DetalleAjuste}.cImporteTotalConImpuesto + Local_Delta. */
        ASSIGN
            Local_TipoAfectacion = {&DetalleAjuste}.cTipoAfectacion.
        LEAVE.
    END.
    {&CabeceraAjuste}.TotalValorVenta = {&CabeceraAjuste}.TotalValorVenta + Local_Delta.
    {&CabeceraAjuste}.TotalPrecioVenta = {&CabeceraAjuste}.TotalPrecioVenta + Local_Delta.
    {&CabeceraAjuste}.TotalVenta = {&CabeceraAjuste}.TotalVenta + Local_Delta.
    CASE TRUE:
        WHEN Local_TipoAfectacion = "EXONERADA" AND {&CabeceraAjuste}.TotalValorVentaNetoOpExoneradas > 0 THEN {&CabeceraAjuste}.TotalValorVentaNetoOpExoneradas = {&CabeceraAjuste}.TotalValorVentaNetoOpExoneradas + Local_Delta.
        WHEN Local_TipoAfectacion = "GRATUITA" AND {&CabeceraAjuste}.totalValorVentaNetoOpGratuitas > 0 THEN {&CabeceraAjuste}.totalValorVentaNetoOpGratuitas = {&CabeceraAjuste}.totalValorVentaNetoOpGratuitas + Local_Delta.
        OTHERWISE DO:
            IF {&CabeceraAjuste}.TotalValorVentaNetoOpGravadas > 0 THEN {&CabeceraAjuste}.TotalValorVentaNetoOpGravadas = {&CabeceraAjuste}.TotalValorVentaNetoOpGravadas + Local_Delta.
        END.
    END CASE.
END.

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
         HEIGHT             = 4.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


