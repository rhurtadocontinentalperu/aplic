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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-existe-categoria-contable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-categoria-contable Procedure 
PROCEDURE existe-categoria-contable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCatgContable AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.
DEFINE BUFFER xy-almtabla FOR almtabla.
FIND FIRST xy-almtabla WHERE xy-almtabla.tabla = 'CC' AND
                                xy-almtabla.codigo = pCatgContable NO-LOCK NO-ERROR.
IF AVAILABLE xy-almtabla THEN pRetval = YES.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-ean13) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-ean13 Procedure 
PROCEDURE existe-ean13 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEAN AS CHAR.
DEFINE OUTPUT PARAMETER pCodmat AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

DEFINE VAR x-sec AS INT.

pRetVal = NO.
pCodMat = "".
DEFINE BUFFER xy-almmmatg FOR almmmatg.
FIND FIRST xy-almmmatg WHERE xy-almmmatg.codcia = s-codcia AND
                                xy-almmmatg.codbrr = pCodEAN NO-LOCK NO-ERROR.
IF AVAILABLE xy-almmmatg THEN DO:
    pRetval = YES.
    pCodMat = xy-almmmatg.codmat.
    RETURN.
END.  

/* Verifico si el EAN13 vaya estar como EAN14 */
REPEAT x-sec = 1 TO 5:
    DEFINE BUFFER xy-almmmat1 FOR almmmat1.
    FIND FIRST xy-almmmat1 WHERE xy-almmmat1.codcia = s-codcia AND
                                    xy-almmmat1.barras[x-sec] = pCodEAN NO-LOCK NO-ERROR.
    IF AVAILABLE xy-almmmat1 THEN DO:
        pRetval = YES.
        pCodMat = xy-almmmat1.codmat.
        /* Salir */
        x-sec = 15.
    END.  
    RELEASE xy-almmmat1.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-ean14) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-ean14 Procedure 
PROCEDURE existe-ean14 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEAN14 AS CHAR.
DEFINE OUTPUT PARAMETER pCodmat AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

DEFINE VAR x-sec AS INT INIT 1.

pRetVal = NO.
pCodMat = "".

/* Buscar si el EAN14 vaya estar como EAN13 */
DEFINE BUFFER xy-almmmatg FOR almmmatg.
FIND FIRST xy-almmmatg WHERE xy-almmmatg.codcia = s-codcia AND
                                xy-almmmatg.codbrr = pCodEAN14 NO-LOCK NO-ERROR.
IF AVAILABLE xy-almmmatg THEN DO:
    pRetval = YES.
    pCodMat = xy-almmmatg.codmat.
    RETURN.
END.  


LOOPEAN14:
REPEAT x-sec = 1 TO 5:
    DEFINE BUFFER xy-almmmat1 FOR almmmat1.
    FIND FIRST xy-almmmat1 WHERE xy-almmmat1.codcia = s-codcia AND
                                    xy-almmmat1.barras[x-sec] = pCodEAN14 NO-LOCK NO-ERROR.
    IF AVAILABLE xy-almmmat1 THEN DO:
        pRetval = YES.
        pCodMat = xy-almmmat1.codmat.
        /* Salir */
        x-sec = 15.
        LEAVE LOOPEAN14.
    END.  
    RELEASE xy-almmmat1.
END.

RELEASE xy-almmmatg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-familia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-familia Procedure 
PROCEDURE existe-familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodFam AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.
DEFINE BUFFER xy-almtfam FOR almtfam.
FIND FIRST xy-almtfam WHERE xy-almtfam.codcia = s-codcia AND
                                xy-almtfam.codfam = pCodfam NO-LOCK NO-ERROR.
IF AVAILABLE xy-almtfam THEN pRetval = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-flag-comercial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-flag-comercial Procedure 
PROCEDURE existe-flag-comercial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pFlgComercial AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.
DEFINE BUFFER xy-almtabla FOR almtabla.
FIND FIRST xy-almtabla WHERE xy-almtabla.tabla = 'IN_CO' AND
                                xy-almtabla.codigo = pFlgComercial NO-LOCK NO-ERROR.
IF AVAILABLE xy-almtabla THEN pRetval = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-licencia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-licencia Procedure 
PROCEDURE existe-licencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodLicencia AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.
DEFINE BUFFER xy-almtabla FOR almtabla.
FIND FIRST xy-almtabla WHERE xy-almtabla.tabla = 'LC' AND
                                xy-almtabla.codigo = pCodLicencia NO-LOCK NO-ERROR.
IF AVAILABLE xy-almtabla THEN pRetval = YES.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-marca) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-marca Procedure 
PROCEDURE existe-marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMarca AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.
DEFINE BUFFER xy-almtabla FOR almtabla.
FIND FIRST xy-almtabla WHERE xy-almtabla.tabla = 'MK' AND
                                xy-almtabla.codigo = pCodMarca NO-LOCK NO-ERROR.
IF AVAILABLE xy-almtabla THEN pRetval = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-proveedor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-proveedor Procedure 
PROCEDURE existe-proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodProveedor AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.
DEFINE BUFFER xy-gn-prov FOR gn-prov.
FIND FIRST xy-gn-prov WHERE xy-gn-prov.codcia = 0 AND
                                xy-gn-prov.codpro = pCodProveedor NO-LOCK NO-ERROR.
IF AVAILABLE xy-gn-prov THEN pRetval = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-subfamilia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-subfamilia Procedure 
PROCEDURE existe-subfamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodFam AS CHAR.
DEFINE INPUT PARAMETER pSubFam AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.
DEFINE BUFFER xy-almsfami FOR almsfami.
FIND FIRST xy-almsfami WHERE xy-almsfami.codcia = s-codcia AND
                                xy-almsfami.codfam = pCodfam AND
                                xy-almsfami.subfam = pSubfam NO-LOCK NO-ERROR.
IF AVAILABLE xy-almsfami THEN pRetval = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-subsubfamilia) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-subsubfamilia Procedure 
PROCEDURE existe-subsubfamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodFam AS CHAR.
DEFINE INPUT PARAMETER pSubFam AS CHAR.
DEFINE INPUT PARAMETER pSSubFam AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.
DEFINE BUFFER xy-almssfami FOR almssfami.
FIND FIRST xy-almssfami WHERE xy-almssfami.codcia = s-codcia AND
                                xy-almssfami.codfam = pCodfam AND
                                xy-almssfami.subfam = pSubfam AND
                                xy-almssfami.codssfam = pSSubfam NO-LOCK NO-ERROR.
IF AVAILABLE xy-almssfami THEN pRetval = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-existe-umedida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE existe-umedida Procedure 
PROCEDURE existe-umedida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pUndMedida AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS LOG.

pRetVal = NO.
DEFINE BUFFER xy-unidades FOR unidades.
FIND FIRST xy-unidades WHERE xy-unidades.codunid = pUndMedida NO-LOCK NO-ERROR.
/* Solo unidades activas */
IF AVAILABLE xy-unidades AND xy-unidades.libre_l01 = NO THEN pRetval = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

