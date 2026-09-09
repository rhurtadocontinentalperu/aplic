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

DEF VAR pError AS CHAR NO-UNDO.

DEF BUFFER B-MATGEXT FOR AlmmmatgExt.

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
         HEIGHT             = 8.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/* ************************************************************************************** */
/* RHC 14/07/21: Registro reflejo */
/* ************************************************************************************** */
RUN MATG_Registro-Reflejo.

IF OldAlmmmatg.CtoTotMarco <> Almmmatg.CtoTotMarco THEN DO:
    RUN MATG_Costo-Marco.
    IF RETURN-VALUE ='ADM-ERROR' THEN UNDO, RETURN ERROR.
END.
/* 27/04/2022: LOG DE CONTROL */
IF OldAlmmmatg.codmat > '' THEN DO:
    /* LOG de control */
    CREATE Logmmatg.
    BUFFER-COPY Almmmatg TO Logmmatg
        ASSIGN
            Logmmatg.LogDate = TODAY
            Logmmatg.LogTime = STRING(TIME, 'HH:MM:SS')
            Logmmatg.LogUser = s-user-id
            Logmmatg.FlagFechaHora = DATETIME(TODAY, MTIME)
            Logmmatg.FlagUsuario = s-user-id
            Logmmatg.flagestado = "U".
END.
ELSE DO:
    /* LOG de control */
    CREATE Logmmatg.
    BUFFER-COPY Almmmatg TO Logmmatg
        ASSIGN
            Logmmatg.LogDate = TODAY
            Logmmatg.LogTime = STRING(TIME, 'HH:MM:SS')
            Logmmatg.LogUser = s-user-id
            Logmmatg.FlagFechaHora = DATETIME(TODAY, MTIME)
            Logmmatg.FlagUsuario = s-user-id
            Logmmatg.flagestado = "I".
    pRowid = ROWID(Almmmatg).
    RUN alm/p-logmmatg-cissac (pRowid, "I", s-user-id) NO-ERROR.
END.

/* ************************************************************************************** */
/* Existen 4 caso:
1. Se compra en Soles y se vende en Soles
2. Se compra en Soles y se vende en Dólares
3. Se compra en Dólares y se vende en Dólares
4. Se compra en Dólares y se vende en Soles
*/
/* ************************************************************************************** */

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.

DEF VAR f-PrecioListaVta AS DECI NO-UNDO.
DEF VAR f-PrecioListaCmp AS DECI NO-UNDO.
DEF VAR x-Aplica-TC      AS LOG  NO-UNDO.
DEF VAR x-Item           AS INTE NO-UNDO.
DEF VAR f-PreVta         LIKE Almmmatg.PreVta NO-UNDO.
DEF VAR f-PreAlt         LIKE Almmmatg.PreAlt NO-UNDO.

FIND FIRST B-MATGEXT OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
FIND FIRST Almtfami OF Almmmatg NO-LOCK NO-ERROR.

IF Almtfami.Libre_c05 = "SI" THEN x-Aplica-TC = YES.
ELSE x-Aplica-TC = NO.

/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
/* 27/04/2022: CAMBIO EN EL IMPORTE DE COSTO : ACTUALIZA PRECIOS MANTENIENDO EL MARGEN */
/* NOTA: Solo se da al momento de actualizar CALCULAR COSTO MONEDA */
/* Por ahora solo productos de terceros */
/* ***************************************************************************************************** */
IF OLDAlmmmatg.CtoTot <> Almmmatg.CtoTot AND Almmmatg.CHR__02 = "T" THEN DO:
     RUN MATG_Actualiza-Precios.
     RUN MATG_Actualiza-Descuentos.
     RETURN.    /* OJO */
END.
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
ASSIGN
    f-PrecioListaVta = Almmmatg.PreVta[1]           /* En la moneda de venta */
    f-PreVta[2]      = Almmmatg.PreVta[2]           /* A */
    f-PreVta[3]      = Almmmatg.PreVta[3]           /* B */
    f-PreVta[4]      = Almmmatg.PreVta[4]           /* C */
    f-PrecioListaCmp = B-MATGEXT.PrecioLista.     /* En la moneda de compra */
/* ***************************************************************************************************** */
/* EN CASO SE ACTUALICE EL TIPO DE CAMBIO */
/* NOTA: El cambio de la Moneda de LP y el Tipo de Cambio se dan en dos momentos diferentes */
/* ***************************************************************************************************** */
IF OldAlmmmatg.TpoCmb <> Almmmatg.TpoCmb THEN DO:
    RUN MATG_Actualiza-TC (OUTPUT pError).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pError = 'ERROR al actualizar el TC en las listas de precios' + CHR(10) + pError.
        MESSAGE pError VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN ERROR.
    END.
    /* 27/04/2022 Terminada la rutina regresamos */
    RETURN.
END.
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
/* EN CASO SE ACTUALICE LA MONEDA DE LA LISTA DE PRECIOS */
/* NOTA: El cambio de la Moneda de LP y el Tipo de Cambio se dan en dos momentos diferentes */
/* ***************************************************************************************************** */
IF OldAlmmmatg.MonVta <> Almmmatg.MonVta THEN DO:
    RUN MATG_Actualiza-Moneda-LP.
END.
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
/* ACTUALIZA DESCUENTOS */
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
IF OLDAlmmmatg.PreVta[1] <> Almmmatg.PreVta[1] THEN DO:
    RUN MATG_Actualiza-Descuentos.
END.
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
/* RHC 30.01.2013 AGREGAMOS LOG DE CONTROL PARA OPENORANGE */
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
DEF VAR f-Precio AS DEC NO-UNDO.
IF OldAlmmmatg.codmat > '' THEN DO:
    /* LOG de control */
/*     CREATE Logmmatg.                                        */
/*     BUFFER-COPY Almmmatg TO Logmmatg                        */
/*         ASSIGN                                              */
/*             Logmmatg.LogDate = TODAY                        */
/*             Logmmatg.LogTime = STRING(TIME, 'HH:MM:SS')     */
/*             Logmmatg.LogUser = s-user-id                    */
/*             Logmmatg.FlagFechaHora = DATETIME(TODAY, MTIME) */
/*             Logmmatg.FlagUsuario = s-user-id                */
/*             Logmmatg.flagestado = "U".                      */
    /* ** CUALQUIER CAMBIO DEBE REFLEJARSE EN LA OTRAS LISTAS DE PRECIOS ** */
    IF Almmmatg.UndBas <>  OldAlmmmatg.UndBas
        OR Almmmatg.UndStk <> OldAlmmmatg.UndStk
        OR Almmmatg.Chr__01 <> OldAlmmmatg.CHR__01
        OR Almmmatg.DesMat <> OldAlmmmatg.DesMat
        OR Almmmatg.CodBrr <> OldAlmmmatg.CodBrr
        OR Almmmatg.MonVta <>  OldAlmmmatg.MonVta
        OR Almmmatg.PreOfi <> OldAlmmmatg.PreOfi
        OR Almmmatg.TpoCmb <> OldAlmmmatg.TpoCmb
        OR Almmmatg.CtoLis <> OldAlmmmatg.CtoLis
        OR Almmmatg.CtoTot <> OldAlmmmatg.CtoTot        /* OJO */
        OR Almmmatg.PreVta[1] <> OldAlmmmatg.PreVta[1]
        OR Almmmatg.PreVta[2] <> OldAlmmmatg.PreVta[2]
        OR Almmmatg.PreVta[3] <> OldAlmmmatg.PreVta[3]
        OR Almmmatg.PreVta[4] <> OldAlmmmatg.PreVta[4]
        OR Almmmatg.DtoVolD[1] <> OldAlmmmatg.DtoVolD[1] 
        OR Almmmatg.DtoVolD[2] <> OldAlmmmatg.DtoVolD[2]  
        OR Almmmatg.DtoVolD[3] <> OldAlmmmatg.DtoVolD[3] 
        OR Almmmatg.DtoVolD[4] <> OldAlmmmatg.DtoVolD[4] 
        OR Almmmatg.DtoVolD[5] <> OldAlmmmatg.DtoVolD[5] 
        OR Almmmatg.DtoVolD[6] <> OldAlmmmatg.DtoVolD[6] 
        OR Almmmatg.DtoVolD[7] <> OldAlmmmatg.DtoVolD[7] 
        OR Almmmatg.DtoVolD[8] <> OldAlmmmatg.DtoVolD[8] 
        OR Almmmatg.DtoVolD[9] <> OldAlmmmatg.DtoVolD[9] 
        OR Almmmatg.DtoVolD[10] <> OldAlmmmatg.DtoVolD[10] 
        OR Almmmatg.DtoVolR[1] <> OldAlmmmatg.DtoVolR[1] 
        OR Almmmatg.DtoVolR[2] <> OldAlmmmatg.DtoVolR[2]
        OR Almmmatg.DtoVolR[3] <> OldAlmmmatg.DtoVolR[3]
        OR Almmmatg.DtoVolR[4] <> OldAlmmmatg.DtoVolR[4]
        OR Almmmatg.DtoVolR[5] <> OldAlmmmatg.DtoVolR[5]
        OR Almmmatg.DtoVolR[6] <> OldAlmmmatg.DtoVolR[6]
        OR Almmmatg.DtoVolR[7] <> OldAlmmmatg.DtoVolR[7]
        OR Almmmatg.DtoVolR[8] <> OldAlmmmatg.DtoVolR[8]
        OR Almmmatg.DtoVolR[9] <> OldAlmmmatg.DtoVolR[9]
        OR Almmmatg.DtoVolR[10] <> OldAlmmmatg.DtoVolR[10] 
        OR Almmmatg.PromDivi[1] <> OldAlmmmatg.PromDivi[1]
        OR Almmmatg.PromDivi[2] <> OldAlmmmatg.PromDivi[2]
        OR Almmmatg.PromDivi[3] <> OldAlmmmatg.PromDivi[3]
        OR Almmmatg.PromDivi[4] <> OldAlmmmatg.PromDivi[4]
        OR Almmmatg.PromDivi[5] <> OldAlmmmatg.PromDivi[5]
        OR Almmmatg.PromDivi[6] <> OldAlmmmatg.PromDivi[6]
        OR Almmmatg.PromDivi[7] <> OldAlmmmatg.PromDivi[7]
        OR Almmmatg.PromDivi[8] <> OldAlmmmatg.PromDivi[8]
        OR Almmmatg.PromDivi[9] <> OldAlmmmatg.PromDivi[9]
        OR Almmmatg.PromDivi[10] <> OldAlmmmatg.PromDivi[10]
        OR Almmmatg.PromDto[1] <> OldAlmmmatg.PromDto[1]
        OR Almmmatg.PromDto[2] <> OldAlmmmatg.PromDto[2]
        OR Almmmatg.PromDto[3] <> OldAlmmmatg.PromDto[3]
        OR Almmmatg.PromDto[4] <> OldAlmmmatg.PromDto[4]
        OR Almmmatg.PromDto[5] <> OldAlmmmatg.PromDto[5]
        OR Almmmatg.PromDto[6] <> OldAlmmmatg.PromDto[6]
        OR Almmmatg.PromDto[7] <> OldAlmmmatg.PromDto[7]
        OR Almmmatg.PromDto[8] <> OldAlmmmatg.PromDto[8]
        OR Almmmatg.PromDto[9] <> OldAlmmmatg.PromDto[9]
        OR Almmmatg.PromDto[10] <> OldAlmmmatg.PromDto[10]
        OR Almmmatg.PromFchD[1] <> OldAlmmmatg.PromFchD[1]
        OR Almmmatg.PromFchD[2] <> OldAlmmmatg.PromFchD[2]
        OR Almmmatg.PromFchD[3] <> OldAlmmmatg.PromFchD[3]
        OR Almmmatg.PromFchD[4] <> OldAlmmmatg.PromFchD[4]
        OR Almmmatg.PromFchD[5] <> OldAlmmmatg.PromFchD[5]
        OR Almmmatg.PromFchD[6] <> OldAlmmmatg.PromFchD[6]
        OR Almmmatg.PromFchD[7] <> OldAlmmmatg.PromFchD[7]
        OR Almmmatg.PromFchD[8] <> OldAlmmmatg.PromFchD[8]
        OR Almmmatg.PromFchD[9] <> OldAlmmmatg.PromFchD[9]
        OR Almmmatg.PromFchD[10]<> OldAlmmmatg.PromFchD[10] 
        OR Almmmatg.PromFchH[1] <> OldAlmmmatg.PromFchH[1]
        OR Almmmatg.PromFchH[2] <> OldAlmmmatg.PromFchH[2]
        OR Almmmatg.PromFchH[3] <> OldAlmmmatg.PromFchH[3]
        OR Almmmatg.PromFchH[4] <> OldAlmmmatg.PromFchH[4]
        OR Almmmatg.PromFchH[5] <> OldAlmmmatg.PromFchH[5]
        OR Almmmatg.PromFchH[6] <> OldAlmmmatg.PromFchH[6]
        OR Almmmatg.PromFchH[7] <> OldAlmmmatg.PromFchH[7]
        OR Almmmatg.PromFchH[8] <> OldAlmmmatg.PromFchH[8]
        OR Almmmatg.PromFchH[9] <> OldAlmmmatg.PromFchH[9]
        OR Almmmatg.PromFchH[10] <> OldAlmmmatg.PromFchH[10]
        THEN DO:
        pRowid = ROWID(Almmmatg).
        RUN alm/p-logmmatg-cissac (pRowid, "U", s-user-id) NO-ERROR.
        /* ***** RHC NUEVO DESCUENTOS PROMOCIONAL X DIVISION ***** */
        f-Precio = Almmmatg.PreVta[1].
        FOR EACH VtaTabla WHERE VtaTabla.codcia = Almmmatg.codcia
            AND VtaTabla.Tabla = "DTOPROLIMA"
            AND VtaTabla.llave_c1 = Almmmatg.codmat:
            VtaTabla.Valor[2] = ROUND(F-PRECIO * ( 1 - ( VtaTabla.Valor[1] / 100 ) ),4).
        END.
        /* ********* RHC MARGENES LISTAS DE PRECIOS ************** */
        IF Almmmatg.UndBas <>  OldAlmmmatg.UndBas
            OR Almmmatg.MonVta <>  OldAlmmmatg.MonVta
            OR Almmmatg.TpoCmb <> OldAlmmmatg.TpoCmb
            OR Almmmatg.CHR__01 <> OldAlmmmatg.CHR__01
            OR Almmmatg.CtoTot <> OldAlmmmatg.CtoTot
            THEN DO:
            /* LISTA MINORISTA GENERAL (UTILEX) */
            FOR EACH VtaListaMinGn WHERE VtaListaMinGn.codcia = Almmmatg.CodCia
                AND VtaListaMinGn.codmat = Almmmatg.codmat EXCLUSIVE-LOCK:
                x-CtoTot = Almmmatg.ctotot.
                f-Factor = 1.
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = Almmmatg.Chr__01
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN DO:
                    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                END.  
                ASSIGN
                    VtaListaMinGn.MonVta = Almmmatg.MonVta
                    VtaListaMinGn.TpoCmb = Almmmatg.TpoCmb
                    VtaListaMinGn.CHR__01 = Almmmatg.CHR__01
                    VtaListaMinGn.Dec__01 = ROUND(( (VtaListaMinGn.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100,6). 
            END.
            IF AVAILABLE(VtaListaMinGn) THEN RELEASE VtaListaMinGn.
            /* LISTA MAYORISTA POR DIVISION */
            /* RHC 06/11/2013 LA MONEDA Y TIPO DE CAMBIO ESTAN EL ALMMMATG */
            FOR EACH VtaListaMay WHERE VtaListaMay.codcia = Almmmatg.codcia
                AND VtaListaMay.codmat = Almmmatg.codmat EXCLUSIVE-LOCK:
                ASSIGN
                    VtaListaMay.MonVta = Almmmatg.MonVta
                    VtaListaMay.TpoCmb = Almmmatg.TpoCmb
                    VtaListaMay.CHR__01 = Almmmatg.CHR__01.
                ASSIGN
                    x-CtoTot           = Almmmatg.CtoTot
                    f-Factor = 1.
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = VtaListaMay.Chr__01
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                ASSIGN
                    VtaListaMay.Dec__01 = ROUND( ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100, 6). 
            END.
            IF AVAILABLE(VtaListaMay) THEN RELEASE VtaListaMay.
            /* LISTA CONTRATO MARCO */
            /* RHC 06/11/2013 LA MONEDA Y TIPO DE CAMBIO ESTAN EL ALMMMATG */
            FOR EACH Almmmatp WHERE Almmmatp.codcia = Almmmatg.codcia
                AND Almmmatp.codmat = Almmmatg.codmat EXCLUSIVE-LOCK:
                ASSIGN
                    Almmmatp.MonVta = Almmmatg.MonVta
                    Almmmatp.TpoCmb = Almmmatg.TpoCmb
                    Almmmatp.CHR__01 = Almmmatg.CHR__01
                    f-Factor = 1.
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = Almmmatp.Chr__01
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                ASSIGN
                    Almmmatp.Dec__01 = ROUND (( (Almmmatp.PreOfi / (Almmmatp.Ctotot * f-Factor) ) - 1 ) * 100, 6). 
            END.
            IF AVAILABLE(Almmmatp) THEN RELEASE Almmmatp.
        END.
    END.
    /* RHC 21/10/2021 Grabar importe sin igv */
    FIND FIRST Sunat_Fact_Electr_Taxs  WHERE Sunat_Fact_Electr_Taxs.TaxTypeCode = "IGV"
        AND Sunat_Fact_Electr_Taxs.Disabled = NO
        AND TODAY >= Sunat_Fact_Electr_Taxs.Start_Date 
        AND TODAY <= Sunat_Fact_Electr_Taxs.End_Date 
        AND Sunat_Fact_Electr_Taxs.Tax > 0
        NO-LOCK NO-ERROR.
    IF AVAILABLE Sunat_Fact_Electr_Taxs THEN DO:
        RUN MATG_Importe-sin-igv.
    END.
END.
ELSE DO:
    /* LOG de control */
/*     CREATE Logmmatg.                                             */
/*     BUFFER-COPY Almmmatg TO Logmmatg                             */
/*         ASSIGN                                                   */
/*             Logmmatg.LogDate = TODAY                             */
/*             Logmmatg.LogTime = STRING(TIME, 'HH:MM:SS')          */
/*             Logmmatg.LogUser = s-user-id                         */
/*             Logmmatg.FlagFechaHora = DATETIME(TODAY, MTIME)      */
/*             Logmmatg.FlagUsuario = s-user-id                     */
/*             Logmmatg.flagestado = "I".                           */
/*     pRowid = ROWID(Almmmatg).                                    */
/*     RUN alm/p-logmmatg-cissac (pRowid, "I", s-user-id) NO-ERROR. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MATG_Actualiza-Descuentos Include 
PROCEDURE MATG_Actualiza-Descuentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
/* Actualizamos VtaDctoProm: Promociones Vigentes */
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
ASSIGN
    f-PrecioListaVta = Almmmatg.PreVta[1]           /* En la moneda de venta */
    .
FOR EACH VtaDctoProm EXCLUSIVE-LOCK WHERE VtaDctoProm.CodCia = Almmmatg.CodCia 
    AND VtaDctoProm.CodMat = Almmmatg.CodMat 
    AND (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin),
    FIRST gn-divi OF VtaDctoProm NO-LOCK WHERE gn-divi.ventamayorista = 1:     /* OJO >>> Lista General */
    ASSIGN
        VtaDctoProm.Precio = ROUND(f-PrecioListaVta * (1 - (VtaDctoProm.Descuento  / 100)), 4).
END.
/* ***************************************************************************************************** */
/* Actualizamos VtaDctoProm: Promociones Proyectadas */
/* ***************************************************************************************************** */
FOR EACH VtaDctoProm EXCLUSIVE-LOCK WHERE VtaDctoProm.CodCia = Almmmatg.CodCia 
    AND VtaDctoProm.CodMat = Almmmatg.CodMat 
    AND VtaDctoProm.FchIni > TODAY,
    FIRST gn-divi OF VtaDctoProm NO-LOCK WHERE gn-divi.ventamayorista = 1:     /* OJO >>> Lista General */
    ASSIGN
        VtaDctoProm.Precio = ROUND(f-PrecioListaVta * (1 - (VtaDctoProm.Descuento  / 100)), 4).
END.
IF AVAILABLE(VtaDctoProm) THEN RELEASE VtaDctoProm.
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
/* Actualizamos VtaDctoVol: Almmmatg */
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
DO x-Item = 1 TO 10:
    IF Almmmatg.DtoVolD[x-Item] <> 0 THEN
        ASSIGN Almmmatg.DtoVolP[x-Item] = ROUND(f-PrecioListaVta * (1 - (Almmmatg.DtoVolD[x-Item]  / 100)), 4).
END.
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
/* Actualizamos VtaDctoVol: Vigentes */
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
FOR EACH VtaDctoVol EXCLUSIVE-LOCK WHERE VtaDctoVol.CodCia = Almmmatg.CodCia AND
    VtaDctoVol.CodMat = Almmmatg.CodMat AND
    (TODAY >= VtaDctoVol.FchIni OR TODAY <= VtaDctoVol.FchFin),
    FIRST gn-divi OF VtaDctoVol NO-LOCK WHERE gn-divi.ventamayorista = 1:     /* OJO >>> Lista General */
    DO x-Item = 1 TO 10:
        VtaDctoVol.DtoVolP[x-Item] = ROUND(f-PrecioListaVta * ( 1 - ( VtaDctoVol.DtoVolD[x-Item] / 100 ) ), 4).
    END.
END.
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
/* Actualizamos VtaDctoVol: Proyectadas */
/* ***************************************************************************************************** */
/* ***************************************************************************************************** */
FOR EACH VtaDctoVol EXCLUSIVE-LOCK WHERE VtaDctoVol.CodCia = Almmmatg.CodCia AND
    VtaDctoVol.CodMat = Almmmatg.CodMat AND
    VtaDctoVol.FchIni > TODAY,
    FIRST gn-divi OF VtaDctoVol NO-LOCK WHERE gn-divi.ventamayorista = 1:     /* OJO >>> Lista General */
    DO x-Item = 1 TO 10:
        VtaDctoVol.DtoVolP[x-Item] = ROUND(f-PrecioListaVta * ( 1 - ( VtaDctoVol.DtoVolD[x-Item] / 100 ) ), 4).
    END.
END.
IF AVAILABLE(VtaDctoVol) THEN RELEASE VtaDctoVol.
/* ***************************************************************************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MATG_Actualiza-Moneda-LP Include 
PROCEDURE MATG_Actualiza-Moneda-LP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       El cambio de Moneda de LP afecta los precios de las listas x División,
                Contrato Marco y Remates
------------------------------------------------------------------------------*/

/* Afectamos los precios de la lista de precios x división */
FOR EACH VtaListaMay OF Almmmatg EXCLUSIVE-LOCK:
    IF Almmmatg.MonVta = 1 THEN     /* Antes en US$ ahora en S/. */
        ASSIGN VtaListaMay.PreOfi = VtaListaMay.PreOfi * Almmmatg.TpoCmb.
    ELSE                            /* Antes en S/. ahora en US$ */
        ASSIGN VtaListaMay.PreOfi = VtaListaMay.PreOfi / Almmmatg.TpoCmb.
    ASSIGN
        VtaListaMay.MonVta = Almmmatg.MonVta.
END.
IF AVAILABLE(VtaListaMay) THEN RELEASE VtaListaMay.
/* Afectamos los precios de la lista de precios contrato marco */
FOR EACH Almmmatp OF Almmmatg EXCLUSIVE-LOCK:
    IF Almmmatg.MonVta = 1 THEN     /* Antes en US$ ahora en S/. */
        ASSIGN 
            Almmmatp.CtoTot = Almmmatp.CtoTot * Almmmatg.TpoCmb
            Almmmatp.PreOfi = Almmmatp.PreOfi * Almmmatg.TpoCmb.
    ELSE                            /* Antes en S/. ahora en US$ */
        ASSIGN 
            Almmmatp.CtoTot = Almmmatp.CtoTot / Almmmatg.TpoCmb
            Almmmatp.PreOfi = Almmmatp.PreOfi / Almmmatg.TpoCmb.
    ASSIGN
        Almmmatp.MonVta = Almmmatg.MonVta.
END.
IF AVAILABLE(Almmmatp) THEN RELEASE Almmmatp.
/* Afectamos los precios de la lista de precios de remates */
FOR EACH VtaTabla EXCLUSIVE WHERE VtaTabla.CodCia = Almmmatg.codcia
    AND VtaTabla.Tabla = "REMATES"
    AND VtaTabla.Llave_c1= Almmmatg.CodMat:
    IF Almmmatg.MonVta = 1 THEN     /* Antes en US$ ahora en S/. */
        ASSIGN VtaTabla.Valor[1] = VtaTabla.Valor[1] * Almmmatg.TpoCmb.
    ELSE                            /* Antes en S/. ahora en US$ */
        ASSIGN VtaTabla.Valor[1] = VtaTabla.Valor[1] / Almmmatg.TpoCmb.
END.
IF AVAILABLE(VtaTabla) THEN RELEASE VtaTabla.
/* Afectamos los precios de la lista de precios UTILEX */
FOR EACH VtaListaMinGn OF Almmmatg EXCLUSIVE-LOCK:
    IF Almmmatg.MonVta = 1 THEN     /* Antes en US$ ahora en S/. */
        ASSIGN 
            VtaListaMinGn.PreOfi = VtaListaMinGn.PreOfi * Almmmatg.TpoCmb.
    ELSE                            /* Antes en S/. ahora en US$ */
        ASSIGN 
            VtaListaMinGn.PreOfi = VtaListaMinGn.PreOfi / Almmmatg.TpoCmb.
    ASSIGN
        VtaListaMinGn.MonVta = Almmmatg.MonVta.
END.
IF AVAILABLE(VtaListaMinGn) THEN RELEASE VtaListaMinGn.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MATG_Actualiza-Precios Include 
PROCEDURE MATG_Actualiza-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ************************************************************************************** */
/* Precio Mayoristas */
/* ************************************************************************************** */
DEF VAR F-FACTOR AS DECI INIT 1 NO-UNDO.
DEF VAR F-MrgUti-A AS DECI NO-UNDO.
DEF VAR F-MrgUti-B AS DECI NO-UNDO.
DEF VAR F-MrgUti-C AS DECI NO-UNDO.
DEF VAR X-CTOUND AS DECI NO-UNDO.

F-MrgUti-A = Almmmatg.MrgUti-A.
F-MrgUti-B = Almmmatg.MrgUti-B.
F-MrgUti-C = Almmmatg.MrgUti-C.
X-CTOUND   = Almmmatg.CtoTot.

/* Para el precio lista determinamos el factor */
DEF VAR X-FACTOR AS DECI NO-UNDO.
IF OLDAlmmmatg.CtoTot > 0 THEN DO:
    X-FACTOR = (OLDAlmmmatg.PreVta[1] - OLDAlmmmatg.CtoTot) / OLDAlmmmatg.CtoTot.
    Almmmatg.PreVta[1] = ROUND( X-CTOUND * (1 + X-FACTOR), 6).
END.

F-FACTOR = 1.
IF Almmmatg.UndA > '' THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatg.UndA
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    Almmmatg.PreVta[2] = ROUND(( X-CTOUND * (1 + F-MrgUti-A / 100) ), 6) * F-FACTOR.
END.
F-FACTOR = 1.
IF Almmmatg.UndB > '' THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatg.UndB
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    Almmmatg.PreVta[3] = ROUND(( X-CTOUND * (1 + F-MrgUti-B / 100) ), 6) * F-FACTOR.
END.
F-FACTOR = 1.
IF Almmmatg.UndC > '' THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatg.UndC
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    Almmmatg.PreVta[4] = ROUND(( X-CTOUND * (1 + F-MrgUti-C / 100) ), 6) * F-FACTOR.
END.
F-FACTOR = 1.
IF Almmmatg.CHR__01 > '' THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatg.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
    Almmmatg.PreOfi = ROUND(( X-CTOUND * (1 + Almmmatg.DEC__01 / 100) ), 6) * F-FACTOR.
END.
/* ************************************************************************************** */
/* Precios por División */
/* ************************************************************************************** */
DEF VAR F-MrgUti AS DECI NO-UNDO.
DEF VAR F-PreVta AS DECI NO-UNDO.

FOR EACH VtaListaMay EXCLUSIVE-LOCK WHERE VtaListaMay.CodCia = Almmmatg.codcia
    AND VtaListaMay.codmat = Almmmatg.codmat:
    F-MrgUti = VtaListaMay.DEC__01.
    IF F-MrgUti <= 0 THEN NEXT.
    F-FACTOR = 1.
    F-PreVta = 0.
    /****   Busca el Factor de conversion   ****/
    FIND FIRST Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = VtaListaMay.CHR__01
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv OR Almtconv.Equival <= 0 THEN NEXT.
    F-FACTOR = Almtconv.Equival.
    F-PreVta = ROUND(( X-CTOUND * (1 + F-MrgUti / 100) ), 6) * F-FACTOR.
    RUN lib/RedondearMas ( F-PreVta, 4, OUTPUT F-PreVta).
    VtaListaMay.PreOfi = F-PreVta.
END.
/* ************************************************************************************** */
/* Precios Minoristas */
/* ************************************************************************************** */
FOR EACH VtaListaMinGn EXCLUSIVE-LOCK WHERE VtaListaMinGn.CodCia = Almmmatg.codcia
    AND VtaListaMinGn.codmat = Almmmatg.codmat:
    F-FACTOR = 1.
    /****   Busca el Factor de conversion   ****/
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatg.CHR__01
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN NEXT.
    F-FACTOR = Almtconv.Equival.
    VtaListaMinGn.PreOfi = ROUND(( X-CTOUND * (1 + VtaListaMinGn.Dec__01 / 100) ), 6) * F-FACTOR.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MATG_Actualiza-TC Include 
PROCEDURE MATG_Actualiza-TC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEF VAR f-Factor AS DECI NO-UNDO.
DEF VAR fmot   AS DECI NO-UNDO.
DEF VAR MrgMin AS DECI NO-UNDO.
DEF VAR MrgOfi AS DECI NO-UNDO.
DEF VAR MaxCat AS DECI NO-UNDO.
DEF VAR MaxVta AS DECI NO-UNDO.
DEF VAR Pre-Ofi AS DECI NO-UNDO.
DEF VAR F-MrgUti-A AS DECIMAL NO-UNDO.
DEF VAR F-MrgUti-B AS DECIMAL NO-UNDO.
DEF VAR F-MrgUti-C AS DECIMAL NO-UNDO.
DEF VAR X-CTOUND AS DECIMAL NO-UNDO.


DEF BUFFER b-VtaListaMay FOR VtaListaMay.
DEF BUFFER b-VtaListaMinGn FOR VtaListaMinGn.
DEF BUFFER b-Almmmatp FOR Almmmatp.

DEF VAR LocalCuentaBloqueos AS INTE NO-UNDO.
DEF VAR LocalCuentaErrores  AS INTE NO-UNDO.

FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.

/* Se actualiza el precio unitario compra */
CASE TRUE:
    WHEN Almmmatg.DsctoProm[1] = 2 AND Almmmatg.MonVta = 1 THEN DO:
        ASSIGN
            Almmmatg.CtoLis = Almmmatg.CtoLis / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb
            Almmmatg.CtoTot = Almmmatg.CtoTot / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb.
            .
    END.
    WHEN Almmmatg.DsctoProm[1] = 1 AND Almmmatg.MonVta = 2 THEN DO:
        ASSIGN
            Almmmatg.CtoLis = Almmmatg.CtoLis * OldAlmmmatg.TpoCmb / Almmmatg.TpoCmb
            Almmmatg.CtoTot = Almmmatg.CtoTot * OldAlmmmatg.TpoCmb / Almmmatg.TpoCmb
            .
    END.
END CASE.

CASE x-Aplica-TC:
    /* NO AFECTAR SOLES por TC */
    WHEN NO THEN DO:
/*             WHEN B-MATGEXT.MonCmp = 2 AND Almmmatg.MonVta = 1 THEN DO:                                     */
/*                 /* Se actualiza el precio unitario compra */                                                 */
/*                 ASSIGN                                                                                       */
/*                     B-MATGEXT.PrecioLista = B-MATGEXT.PrecioLista * OldAlmmmatg.TpoCmb / Almmmatg.TpoCmb */
/*                     .                                                                                        */
/*             END.                                                                                             */
    END.
    /* AFECTAR SOLES por TC */
    WHEN YES THEN DO:
        CASE TRUE:
            /* Costo en Dólares y Venta en Soles */
            WHEN Almmmatg.DsctoProm[1] = 2 AND Almmmatg.MonVta = 1 THEN DO:
                /* Se actualiza el precio unitario venta */
                ASSIGN
                    x-CtoUnd = Almmmatg.DsctoProm[2] * Almmmatg.TpoCmb.
                /* Mayorista */
                ASSIGN
                    Almmmatg.PreVta[1] = Almmmatg.PreVta[1] / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb
                    Almmmatg.PreVta[2] = Almmmatg.PreVta[2] / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb
                    Almmmatg.PreVta[3] = Almmmatg.PreVta[3] / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb
                    Almmmatg.PreVta[4] = Almmmatg.PreVta[4] / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb
                    Almmmatg.PreOfi    = Almmmatg.Preofi    / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb
                    .
                F-Factor = 1.
                IF Almmmatg.UndA <> "" THEN DO:
                    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                        AND  Almtconv.Codalter = Almmmatg.UndA
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
                END.
                IF Almmmatg.AftIgv THEN
                    Almmmatg.PreBas = ROUND(Almmmatg.PreVta[1] / ( 1 + FacCfgGn.PorIgv / 100), 6).
                Almmmatg.MrgUti = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100.
                F-FACTOR = 1.
                IF Almmmatg.UndA <> "" THEN DO:
                    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                        AND  Almtconv.Codalter = Almmmatg.UndA
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
                    Almmmatg.Dsctos[1] =  (((Almmmatg.Prevta[2] / F-FACTOR)/ Almmmatg.Prevta[1]) - 1 ) * 100.
                    F-MrgUti-A = ROUND(((((Almmmatg.Prevta[2] / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
                END.
                F-FACTOR = 1.
                IF Almmmatg.UndB <> "" THEN DO:
                    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                        AND  Almtconv.Codalter = Almmmatg.UndB
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
                    Almmmatg.Dsctos[2] =  (((Almmmatg.Prevta[3] / F-FACTOR)/ Almmmatg.Prevta[1]) - 1 ) * 100.
                    F-MrgUti-B = ROUND(((((Almmmatg.Prevta[3] / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
                END.
                F-FACTOR = 1.
                IF Almmmatg.UndC <> "" THEN DO:
                    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                        AND  Almtconv.Codalter = Almmmatg.UndC
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
                    Almmmatg.Dsctos[3] =  (((Almmmatg.Prevta[4] / F-FACTOR)/ Almmmatg.Prevta[1]) - 1 ) * 100.
                    F-MrgUti-C = ROUND(((((Almmmatg.Prevta[4] / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
                END.
                ASSIGN
                    Almmmatg.MrgUti-A = F-MrgUti-A
                    Almmmatg.MrgUti-B = F-MrgUti-B
                    Almmmatg.MrgUti-C = F-MrgUti-C.
                fmot   = 0.
                MrgMin = 5000.
                MrgOfi = 0.
                F-FACTOR = 1.
                MaxCat = 4.
                MaxVta = 3.
                CASE Almmmatg.Chr__02 :
                    WHEN "T" THEN DO:
                        /*  TERCEROS  */
                        IF F-MrgUti-A < MrgMin AND F-MrgUti-A <> 0 THEN MrgMin = F-MrgUti-A.
                        IF F-MrgUti-B < MrgMin AND F-MrgUti-B <> 0 THEN MrgMin = F-MrgUti-B.
                        IF F-MrgUti-C < MrgMin AND F-MrgUti-C <> 0 THEN MrgMin = F-MrgUti-C.
                        fmot = (1 + MrgMin / 100) / ((1 - MaxCat / 100) * (1 - MaxVta / 100)).
                        IF F-MrgUti-A = 0 AND F-MrgUti-B = 0 AND F-MrgUti-C = 0 THEN fMot = 1.
                        pre-ofi = X-CTOUND * fmot * F-FACTOR .
                        MrgOfi = ROUND((fmot - 1) * 100, 6).
                    END.
                    WHEN "P" THEN DO:
                        /* PROPIOS */
                       pre-ofi = Almmmatg.Prevta[1] * F-FACTOR.
                       MrgOfi = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100.
                    END.
                END.
                ASSIGN
                    Almmmatg.DEC__01 = MrgOfi.
                /* Utilex */
                F-Factor = 1.
                FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                    AND  Almtconv.Codalter = Almmmatg.CHR__01
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
                FOR EACH VtaListaMinGn NO-LOCK WHERE VtaListaMinGn.CodCia = Almmmatg.codcia
                    AND VtaListaMinGn.codmat = ALmmmatg.codmat:
                    LocalCuentaBloqueos = 0.
                    REPEAT:
                        FIND FIRST b-VtaListaMinGn WHERE ROWID(b-VtaListaMinGn) = ROWID(VtaListaMinGn) 
                            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                        IF AVAILABLE b-VtaListaMinGn THEN LEAVE.
                        LocalCuentaBloqueos = LocalCuentaBloqueos + 1.
                        IF LocalCuentaBloqueos > 1000 THEN DO:
                            {lib/mensaje-de-error.i &CuentaError="LocalCuentaErrores" &MensajeError="pError"}
                            UNDO, RETURN 'ADM-ERROR'.
                        END.
                    END.
                    ASSIGN
                        b-VtaListaMinGn.PreOfi = b-VtaListaMinGn.PreOfi / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb
                        b-VtaListaMinGn.Dec__01 = ROUND(((((b-VtaListaMinGn.PreOfi / F-FACTOR) / X-CTOUND) - 1) * 100), 6)
                        .
                END.
                IF AVAILABLE(b-VtaListaMinGn) THEN RELEASE b-VtaListaMinGn.
                /* Lista de Precios por División */
                FOR EACH VtaListaMay NO-LOCK WHERE VtaListaMay.CodCia = Almmmatg.codcia
                    AND VtaListaMay.codmat = Almmmatg.codmat:
                    LocalCuentaBloqueos = 0.
                    REPEAT:
                        FIND FIRST b-VtaListaMay WHERE ROWID(b-VtaListaMay) = ROWID(VtaListaMay) 
                            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                        IF AVAILABLE b-VtaListaMay THEN LEAVE.
                        LocalCuentaBloqueos = LocalCuentaBloqueos + 1.
                        IF LocalCuentaBloqueos > 1000 THEN DO:
                            {lib/mensaje-de-error.i &CuentaError="LocalCuentaErrores" &MensajeError="pError"}
                            UNDO, RETURN 'ADM-ERROR'.
                        END.
                    END.
                    F-Factor = 1.
                    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
                        AND Almtconv.Codalter = b-VtaListaMay.Chr__01
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
                    ASSIGN
                        b-VtaListaMay.PreOfi = b-VtaListaMay.PreOfi / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb
                        b-VtaListaMay.Dec__01 = ROUND( ( (b-VtaListaMay.PreOfi / (x-CtoUnd * f-Factor) ) - 1 ) * 100, 4)
                        .
                END.
                IF AVAILABLE(b-VtaListaMay) THEN RELEASE b-VtaListaMay.
                /* LISTA CONTRATO MARCO */
                FOR EACH Almmmatp NO-LOCK WHERE Almmmatp.codcia = Almmmatg.codcia 
                        AND Almmmatp.codmat = Almmmatg.codmat:
                    LocalCuentaBloqueos = 0.
                    REPEAT:
                        FIND FIRST b-Almmmatp WHERE ROWID(b-Almmmatp) = ROWID(Almmmatp) 
                            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                        IF AVAILABLE b-Almmmatp THEN LEAVE.
                        LocalCuentaBloqueos = LocalCuentaBloqueos + 1.
                        IF LocalCuentaBloqueos > 1000 THEN DO:
                            {lib/mensaje-de-error.i &CuentaError="LocalCuentaErrores" &MensajeError="pError"}
                            UNDO, RETURN 'ADM-ERROR'.
                        END.
                    END.
                    F-Factor = 1.
                    ASSIGN
                        b-Almmmatp.PreOfi = b-Almmmatp.PreOfi / OldAlmmmatg.TpoCmb * Almmmatg.TpoCmb
                        b-Almmmatp.Dec__01 = ( (b-Almmmatp.PreOfi / (b-Almmmatp.Ctotot * f-Factor) ) - 1 ) * 100. 
                        .
                END.
                IF AVAILABLE(b-Almmmatp) THEN RELEASE b-Almmmatp.
            END.
        END CASE.
    END.
END CASE.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MATG_Costo-Marco Include 
PROCEDURE MATG_Costo-Marco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN
        Almmmatg.CtoLisMarco = OldAlmmmatg.CtoLisMarco / OldAlmmmatg.CtoTotMarco * Almmmatg.CtoTotMarco.
    FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatp THEN DO:
        FIND CURRENT Almmmatp EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN RETURN 'ADM-ERROR'.
        ASSIGN
            Almmmatp.CtoTot = Almmmatg.CtoTotMarco.
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = Almmmatp.Chr__01
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
        END.
        ASSIGN
            Almmmatp.Dec__01 = ROUND ( ( (Almmmatp.PreOfi / (Almmmatp.Ctotot * f-Factor) ) - 1 ) * 100, 6).
        RELEASE Almmmatp.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MATG_Importe-sin-igv Include 
PROCEDURE MATG_Importe-sin-igv :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Precio A */    
DEF VAR k AS INTE NO-UNDO.

IF Almmmatg.Prevta[2] <> OLDAlmmmatg.Prevta[2] 
    OR Almmmatg.Prevta[3] <> OLDAlmmmatg.Prevta[3] 
    OR Almmmatg.Prevta[4] <> OLDAlmmmatg.Prevta[4] 
    OR Almmmatg.PreOfi <> OLDAlmmmatg.PreOfi
    THEN DO:
    ASSIGN
        Almmmatg.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        Almmmatg.ImporteUnitarioSinImpuesto = ROUND(Almmmatg.PreOfi / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        Almmmatg.ImporteUnitarioImpuesto = Almmmatg.PreOfi - Almmmatg.ImporteUnitarioSinImpuesto
        Almmmatg.ImporteUnitarioSinImpuesto_A = ROUND(Almmmatg.Prevta[2] / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        Almmmatg.ImporteUnitarioImpuesto_A = Almmmatg.Prevta[2] - Almmmatg.ImporteUnitarioSinImpuesto_A
        Almmmatg.ImporteUnitarioSinImpuesto_B = ROUND(Almmmatg.Prevta[3] / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        Almmmatg.ImporteUnitarioImpuesto_B = Almmmatg.Prevta[3] -  Almmmatg.ImporteUnitarioSinImpuesto_B
        Almmmatg.ImporteUnitarioSinImpuesto_C = ROUND(Almmmatg.Prevta[4] / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        Almmmatg.ImporteUnitarioImpuesto_C = Almmmatg.Prevta[4] - Almmmatg.ImporteUnitarioSinImpuesto_C
        .
END.
DO k = 1 TO 10:
    IF Almmmatg.DtoVolP[k] <> OLDAlmmmatg.DtoVolP[k] THEN 
        ASSIGN
        Almmmatg.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        Almmmatg.DtoVolPSinImpuesto[k] = ROUND(Almmmatg.DtoVolP[k] / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        Almmmatg.DtoVolPImpuesto[k] = Almmmatg.DtoVolP[k] - Almmmatg.DtoVolPSinImpuesto[k]
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MATG_Registro-Reflejo Include 
PROCEDURE MATG_Registro-Reflejo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ************************************************************************************** */
/* RHC 14/07/21: Registro reflejo */
/* ************************************************************************************** */
FIND FIRST B-MATGEXT OF Almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-MATGEXT THEN DO:
    CREATE B-MATGEXT.
    ASSIGN
        B-MATGEXT.MonCmp = Almmmatg.MonVta
        B-MATGEXT.CodCia = Almmmatg.CodCia
        B-MATGEXT.CodMat = Almmmatg.CodMat
        B-MATGEXT.CtoLis = Almmmatg.CtoLis
        B-MATGEXT.CtoTot = Almmmatg.CtoTot
        B-MATGEXT.TpoCmb = Almmmatg.TpoCmb
        B-MATGEXT.FlagActualizacion = 0       /* NO exportar */
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR = YES THEN DELETE B-MATGEXT.
END.
IF AVAILABLE(B-MATGEXT) THEN RELEASE B-MATGEXT.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

