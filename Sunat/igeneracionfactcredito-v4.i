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

    /* Crea Detalle */
    CREATE T-DDOCU.
    BUFFER-COPY PEDI TO T-DDOCU
    ASSIGN
        T-DDOCU.NroItm = iCountItem
        T-DDOCU.CodCia = T-CDOCU.CodCia
        T-DDOCU.CodDiv = T-CDOCU.CodDiv
        T-DDOCU.Coddoc = T-CDOCU.Coddoc
        T-DDOCU.NroDoc = T-CDOCU.NroDoc 
        T-DDOCU.FchDoc = T-CDOCU.FchDoc
        T-DDOCU.CanDes = PEDI.CanAte
        T-DDOCU.impdcto_adelanto[4] = PEDI.Libre_d02.  /* Flete Unitario */
    ASSIGN
        T-DDOCU.Pesmat = Almmmatg.Pesmat * (T-DDOCU.Candes * T-DDOCU.Factor).
    /* CORREGIMOS IMPORTES: El Precio Unitario ya está afectado con el FLETE */
    ASSIGN
        T-DDOCU.ImpLin = ROUND ( T-DDOCU.CanDes * T-DDOCU.PreUni * 
                                  ( 1 - T-DDOCU.Por_Dsctos[1] / 100 ) *
                                  ( 1 - T-DDOCU.Por_Dsctos[2] / 100 ) *
                                  ( 1 - T-DDOCU.Por_Dsctos[3] / 100 ), 2 ).
    IF T-DDOCU.Por_Dsctos[1] = 0 AND T-DDOCU.Por_Dsctos[2] = 0 AND T-DDOCU.Por_Dsctos[3] = 0 
        THEN T-DDOCU.ImpDto = 0.
    ELSE T-DDOCU.ImpDto = T-DDOCU.CanDes * T-DDOCU.PreUni - T-DDOCU.ImpLin.
    ASSIGN
        T-DDOCU.ImpLin = ROUND(T-DDOCU.ImpLin, 2)
        T-DDOCU.ImpDto = ROUND(T-DDOCU.ImpDto, 2).
    IF T-DDOCU.AftIsc 
        THEN T-DDOCU.ImpIsc = ROUND(T-DDOCU.PreBas * T-DDOCU.CanDes * (Almmmatg.PorIsc / 100),4).
    ELSE T-DDOCU.ImpIsc = 0.
    IF T-DDOCU.AftIgv 
        THEN T-DDOCU.ImpIgv = T-DDOCU.ImpLin - ROUND( T-DDOCU.ImpLin  / ( 1 + (T-CDOCU.PorIgv / 100) ), 4 ).
    ELSE T-DDOCU.ImpIgv = 0.
    /* Actualiza Detalle de la Orden de Despacho */
    FIND FIRST Facdpedi WHERE Facdpedi.codcia = ITEM.codcia
        AND Facdpedi.coddiv = ITEM.coddiv
        AND Facdpedi.coddoc = ITEM.coddoc
        AND Facdpedi.nroped = ITEM.nroped
        AND Facdpedi.codmat = ITEM.codmat
        AND Facdpedi.libre_c05 = ITEM.libre_c05    /* Campo de control adicional */
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    /* En caso de Lista Express puede que no este registrado el producto */
    IF NOT AVAILABLE Facdpedi THEN DO:
        pMensaje = 'NO se pudo bloquear el código ' + PEDI.codmat + ' de la O/D'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        Facdpedi.canate = Facdpedi.canate + PEDI.canate.
    /* CONTROL DE ATENCIONES */
    /* RHC 07/02/2017 NO se aplica para Lista Express */
    IF COTIZACION.TpoPed <> "LF" THEN DO:
        IF Facdpedi.CanAte > Facdpedi.CanPed THEN DO:
            pMensaje = 'Se ha detectado un error en el producto ' + Facdpedi.codmat + CHR(10) +
                'Lo facturado supera a lo cotizado' + CHR(10) +
                'Cant. cotizada : ' + STRING(Facdpedi.CanPed, '->>>,>>9.99') + CHR(10) +
                'Total facturado: ' + STRING(Facdpedi.CanAte, '->>>,>>9.99') + CHR(10) +
                'FIN DEL PROCESO'.
            UNDO RLOOP, RETURN "ADM-ERROR".
        END.
    END.
    iCountItem = iCountItem + 1.
    /* LLEVAMOS EL SALDO EN EL ARCHIVO DE CONTROL */
    DELETE ITEM.

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
         HEIGHT             = 3.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


