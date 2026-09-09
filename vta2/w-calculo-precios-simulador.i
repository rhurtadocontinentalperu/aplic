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
         HEIGHT             = 5.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

CASE TRUE:
    WHEN pTipoVenta = "MOSTRADOR_MAYORISTA" THEN DO:
        RUN VALUE(Precio-de-Venta) (INPUT s-codcia,
                                    INPUT x-lista-de-precio, 
                                    INPUT x-codclie,
                                    INPUT x-moneda, 
                                    INPUT x-tpocmb,
                                    OUTPUT x-factor, 
                                    INPUT x-codmat, 
                                    INPUT "",
                                    INPUT x-undvta, 
                                    INPUT x-cantidad, 
                                    INPUT x-nro-dec, 
                                    INPUT "",
                                    OUTPUT x-prebas,
                                    OUTPUT x-prevta, 
                                    OUTPUT f-dsctos, 
                                    OUTPUT y-dsctos,
                                    OUTPUT x-tipdto, 
                                    OUTPUT x-flete-unitario, 
                                    OUTPUT x-mensaje).
    END.
    WHEN pTipoVenta = "MOSTRADOR_MINORISTA" THEN DO:
        RUN VALUE(Precio-de-Venta) (INPUT x-lista-de-precio, 
                                    INPUT x-moneda,
                                    INPUT x-tpocmb,
                                    OUTPUT x-undvta, 
                                    OUTPUT x-factor, 
                                    INPUT x-codmat, 
                                    INPUT x-cantidad, 
                                    INPUT x-nro-dec, 
                                    INPUT "",
                                    INPUT "",
                                    INPUT "",
                                    INPUT "",
                                    INPUT "",
                                    OUTPUT x-prebas,
                                    OUTPUT x-prevta, 
                                    OUTPUT f-dsctos, 
                                    OUTPUT y-dsctos,
                                    OUTPUT z-dsctos,
                                    OUTPUT x-tipdto, 
                                    OUTPUT x-mensaje).
    END.
    WHEN pTipoVenta = "CREDITOS" OR pTipoVenta = "EVENTOS" THEN DO:
        RUN VALUE(Precio-de-Venta) (INPUT x-tipo-pedido, 
                                    INPUT x-lista-de-precio, 
                                    INPUT x-codclie,
                                    INPUT x-moneda, 
                                    INPUT-OUTPUT x-undvta, 
                                    OUTPUT x-factor, 
                                    INPUT x-codmat, 
                                    INPUT x-cond-vta,
                                    INPUT x-cantidad, 
                                    INPUT x-nro-dec, 
                                    OUTPUT x-prebas,
                                    OUTPUT x-prevta, 
                                    OUTPUT f-dsctos, 
                                    OUTPUT y-dsctos,
                                    OUTPUT z-dsctos,
                                    OUTPUT x-tipdto, 
                                    INPUT x-clasificacion-cliente, 
                                    OUTPUT x-flete-unitario, 
                                    "",
                                    INPUT NO,
                                    OUTPUT x-mensaje).
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


