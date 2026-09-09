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
         HEIGHT             = 5.46
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DO iItem = 1 TO NUM-ENTRIES(cListaDocCargo):
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.flgest = "{&FlgEst}" AND
        Ccbcdocu.coddoc = ENTRY(iItem,cListaDocCargo) AND
        Ccbcdocu.sdoact > 0:
        CREATE Detalle.
        ASSIGN
            Detalle.coddoc = Ccbcdocu.coddoc
            Detalle.nrodoc = Ccbcdocu.nrodoc
            Detalle.codref = Ccbcdocu.codref
            Detalle.nroref = Ccbcdocu.nroref
            Detalle.codcli = Ccbcdocu.codcli
            Detalle.nomcli = Ccbcdocu.nomcli
            Detalle.ruccli = Ccbcdocu.ruccli
            Detalle.fmapgo = Ccbcdocu.fmapgo
            Detalle.codven = Ccbcdocu.codven
            Detalle.fchdoc = Ccbcdocu.fchdoc
            Detalle.fchvto = Ccbcdocu.fchvto
            Detalle.Fotocopia = 0
            .
        CASE Ccbcdocu.codmon:
            WHEN 1 THEN ASSIGN Detalle.ImpMn = Ccbcdocu.imptot Detalle.SdoMn = Ccbcdocu.sdoact.
            WHEN 2 THEN ASSIGN Detalle.ImpMe = Ccbcdocu.imptot Detalle.SdoMe = Ccbcdocu.sdoact.
        END CASE.
        ASSIGN
            Detalle.coddiv = Ccbcdocu.divori.
        IF TRUE <> (Detalle.coddiv > "") THEN Detalle.coddiv = Ccbcdocu.coddiv.

        CASE TRUE:
            WHEN Ccbcdocu.coddoc = "LET" THEN DO:
                CASE Ccbcdocu.flgubi:
                    WHEN 'C' THEN Detalle.Ubicacion = "CARTERA".
                    WHEN 'B' THEN DO:
                        Detalle.Ubicacion = "BANCO".
/*                         FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia                 */
/*                             AND cb-ctas.Codcta = Ccbcdocu.codcta NO-LOCK NO-ERROR.    */
/*                         IF AVAILABLE cb-ctas THEN DO:                                 */
/*                             Detalle.banco = cb-ctas.Nomcta.                           */
/*                             FIND cb-tabl WHERE cb-tabl.tabla = "04" AND               */
/*                                 cb-tabl.codigo = cb-ctas.codbco NO-LOCK NO-ERROR.     */
/*                             IF AVAILABLE cb-tabl THEN Detalle.banco = cb-tabl.nombre. */
/*                         END.                                                          */
/*                         Detalle.NroUnico = Ccbcdocu.nrosal.                           */
                    END.
                END CASE.
                /* Datos del banco */
                FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia 
                    AND cb-ctas.Codcta = Ccbcdocu.codcta NO-LOCK NO-ERROR.
                IF AVAILABLE cb-ctas THEN DO:
                    Detalle.banco = cb-ctas.Nomcta.
                    FIND cb-tabl WHERE cb-tabl.tabla = "04" AND
                        cb-tabl.codigo = cb-ctas.codbco NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-tabl THEN Detalle.banco = cb-tabl.nombre.
                END.
                Detalle.NroUnico = Ccbcdocu.nrosal.

                CASE Ccbcdocu.flgsit:
                    WHEN 'T' THEN Detalle.Situacion = 'Transito'.
                    WHEN 'C' THEN Detalle.Situacion = 'Cobranza Libre'.
                    WHEN 'G' THEN Detalle.Situacion = 'Cobranza Garantia'.
                    WHEN 'D' THEN Detalle.Situacion = 'Descuento'.
                    WHEN 'P' THEN Detalle.Situacion = 'Protestada'.
                END CASE.
            END.
        END CASE.

        Detalle.Estado = "PENDIENTE".
        IF Ccbcdocu.flgest = 'J' THEN Detalle.Estado = "COBRANZA DUDOSA".

        /* Fotocopias (en S/): NO Anticipos NI servicios */
        IF LOOKUP(Ccbcdocu.coddoc, "FAC,BOL,FAI") > 0 AND LOOKUP(CcbCdocu.TpoFac, 'A,S') = 0 THEN DO:
            FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK,
                FIRST Almmmatg OF Ccbddocu NO-LOCK WHERE Almmmatg.codfam = '011':
                Detalle.Fotocopia = Detalle.Fotocopia + Ccbddocu.implin.
            END.
            IF Detalle.Fotocopia > 0 AND Ccbcdocu.codmon = 2 THEN DO:
                FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                IF AVAILABLE gn-tcmb THEN
                    ASSIGN
                    x-TpoCmbCmp = gn-tcmb.compra 
                    x-TpoCmbVta = gn-tcmb.venta.
                ASSIGN Detalle.Fotocopia = Detalle.Fotocopia * x-TpoCmbVta.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


