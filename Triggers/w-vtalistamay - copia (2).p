TRIGGER PROCEDURE FOR WRITE OF VtaListaMay OLD BUFFER OldListaMay.

DEFINE SHARED VAR s-CodCia AS INT.

/* RHC 04/03/2019 Log General */
{TRIGGERS/i-logtransactions.i &TableName="vtalistamay" &Event="WRITE"}

/* ************************************************************************************** */
/* RHC 22/08/19 NUEVAS TABLAS */
/* ************************************************************************************** */
DEF VAR f-PrecioLista AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
IF (VtaListaMay.PreOfi <> OldListaMay.PreOfi) THEN DO:
    FIND Almmmatg OF VtaListaMay NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        f-PrecioLista = VtaListaMay.PreOfi.
        /*IF Almmmatg.MonVta = 2 THEN f-PrecioLista = f-PrecioLista * Almmmatg.TpoCmb.*/
    END.
    /* Actualizamos VtaDctoProm: Promociones Vigentes */
    FOR EACH VtaDctoProm OF VtaListaMay EXCLUSIVE-LOCK WHERE (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin):
        IF VtaDctoProm.DescuentoVIP > 0 THEN VtaDctoProm.PrecioVIP = ROUND(f-PrecioLista * (1 - (VtaDctoProm.DescuentoVIP / 100)), 4).
        IF VtaDctoProm.DescuentoMR  > 0 THEN VtaDctoProm.PrecioMR  = ROUND(f-PrecioLista * (1 - (VtaDctoProm.DescuentoMR / 100)), 4).
        IF VtaDctoProm.Descuento    > 0 THEN VtaDctoProm.Precio    = ROUND(f-PrecioLista * (1 - (VtaDctoProm.Descuento / 100)), 4).
    END.
    /* Actualizamos VtaDctoProm: Promociones Proyectadas */
    FOR EACH VtaDctoProm OF VtaListaMay EXCLUSIVE-LOCK WHERE VtaDctoProm.FchIni > TODAY:
        IF VtaDctoProm.DescuentoVIP > 0 THEN VtaDctoProm.PrecioVIP = ROUND(f-PrecioLista * (1 - (VtaDctoProm.DescuentoVIP / 100)), 4).
        IF VtaDctoProm.DescuentoMR  > 0 THEN VtaDctoProm.PrecioMR  = ROUND(f-PrecioLista * (1 - (VtaDctoProm.DescuentoMR / 100)), 4).
        IF VtaDctoProm.Descuento    > 0 THEN VtaDctoProm.Precio    = ROUND(f-PrecioLista * (1 - (VtaDctoProm.Descuento / 100)), 4).
    END.
    /* Actualizamos Precio por Volumen */
    DO x-Item = 1 TO 10:
        IF VtaListaMay.DtoVolD[x-Item] <> 0 THEN
            ASSIGN VtaListaMay.DtoVolP[x-Item] = ROUND(f-PrecioLista * (1 - (VtaListaMay.DtoVolD[x-Item]  / 100)), 4).
    END.
    /* Actualizamos VtaDctoVol */
/*     FOR EACH VtaDctoVol OF VTaListaMay EXCLUSIVE-LOCK WHERE                                                      */
/*         (TODAY >= VtaDctoVol.FchIni OR TODAY <= VtaDctoVol.FchFin):                                              */
/*         DO x-Item = 1 TO 10:                                                                                     */
/*             VtaDctoVol.DtoVolP[x-Item] = ROUND(f-PrecioLista * ( 1 - ( VtaDctoVol.DtoVolD[x-Item] / 100 ) ), 4). */
/*         END.                                                                                                     */
/*     END.                                                                                                         */
    /* Actualizamos VtaDctoVolSaldo */
/*     DEF VAR s-Divisiones AS CHAR NO-UNDO.      /* Divisiones válidas */                                                    */
/*     DEFINE VAR hProc AS HANDLE NO-UNDO.                                                                                    */
/*     RUN pri/pri-librerias PERSISTENT SET hProc.                                                                            */
/*     RUN PRI_Divisiones-Validas IN hProc (INPUT 3,                   /* Mayoristas por División */                          */
/*                                          OUTPUT s-Divisiones).                                                             */
/*     FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = VtaListaMay.codcia AND                                               */
/*         FacTabla.Tabla = 'DVXSALDOD' AND                                                                                   */
/*         FacTabla.Campo-C[1] = VtaListaMay.codmat,                                                                          */
/*         EACH VtaDctoVolSaldo EXCLUSIVE-LOCK WHERE VtaDctoVolSaldo.CodCia = FacTabla.CodCia AND                             */
/*         VtaDctoVolSaldo.Codigo = ENTRY(1,FacTabla.Codigo,'|') AND                                                          */
/*         VtaDctoVolSaldo.Tabla = 'DVXSALDOC' AND                                                                            */
/*         LOOKUP(VtaDctoVolSaldo.CodDiv, s-Divisiones) > 0 AND                                                               */
/*         (TODAY >= VtaDctoVolSaldo.FchIni OR TODAY <= VtaDctoVolSaldo.FchFin):                                              */
/*         DO x-Item = 1 TO 10:                                                                                               */
/*             VtaDctoVolSaldo.DtoVolP[x-Item] = ROUND(f-PrecioLista * ( 1 - ( VtaDctoVolSaldo.DtoVolD[x-Item] / 100 ) ), 4). */
/*         END.                                                                                                               */
/*     END.                                                                                                                   */
/*     RUN PRI_Divisiones-Validas IN hProc (INPUT 4,                   /* Mayoristas EVENTOS */                               */
/*                                          OUTPUT s-Divisiones).                                                             */
/*     FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = VtaListaMay.codcia AND                                               */
/*         FacTabla.Tabla = 'DVXSALDOD' AND                                                                                   */
/*         FacTabla.Campo-C[1] = VtaListaMay.codmat,                                                                          */
/*         EACH VtaDctoVolSaldo EXCLUSIVE-LOCK WHERE VtaDctoVolSaldo.CodCia = FacTabla.CodCia AND                             */
/*         VtaDctoVolSaldo.Codigo = ENTRY(1,FacTabla.Codigo,'|') AND                                                          */
/*         VtaDctoVolSaldo.Tabla = 'DVXSALDOC' AND                                                                            */
/*         LOOKUP(VtaDctoVolSaldo.CodDiv, s-Divisiones) > 0 AND                                                               */
/*         (TODAY >= VtaDctoVolSaldo.FchIni OR TODAY <= VtaDctoVolSaldo.FchFin):                                              */
/*         DO x-Item = 1 TO 10:                                                                                               */
/*             VtaDctoVolSaldo.DtoVolP[x-Item] = ROUND(f-PrecioLista * ( 1 - ( VtaDctoVolSaldo.DtoVolD[x-Item] / 100 ) ), 4). */
/*         END.                                                                                                               */
/*     END.                                                                                                                   */
/*     DELETE PROCEDURE hProc. */
END.

/* ************************************************************************************** */

IF VtaListaMay.CodDiv = "00506" THEN DO:
    DEF VAR x-PreNew LIKE VtaListaMay.PreOfi NO-UNDO.
    DEF VAR x-PreOld LIKE VtaListaMay.PreOfi NO-UNDO.
    DEF VAR pEstado AS CHAR NO-UNDO.
    ASSIGN
        x-PreNew = VtaListaMay.PreOfi
        x-PreOld = OldListaMay.PreOfi.
    IF VtaListaMay.MonVta = 2 THEN
        ASSIGN
        x-PreNew = x-PreNew * VtaListaMay.TpoCmb
        x-PreOld = x-PreOld * VtaListaMay.TpoCmb.
    RUN gn/p-ecommerce (INPUT "aplic/gn/p-ecommerce-precios.p",
                        INPUT STRING(s-CodCia) + ',' +
                        VtaListaMay.CodMat + ',' +
                        STRING(x-PreNew) + ',' +
                        STRING(x-PreOld) + ',' +
                        "E" + ',' +
                        STRING(VtaListaMay.TpoCmb) + ',' +
                        STRING(VtaListaMay.MonVta) + ',' +
                        s-User-Id,
                        OUTPUT pEstado).
END.
/* CONTROL PARA MIGRACION A SPEED */
IF OldListaMay.codmat <> '' THEN DO:
    IF VtaListaMay.PreOfi <> OldListaMay.PreOfi
        OR VtaListaMay.CHR__01 <> OldListaMay.CHR__01
        OR VtaListaMay.DtoVolD[1] <> OldListaMay.DtoVolD[1] 
        OR VtaListaMay.DtoVolD[2] <> OldListaMay.DtoVolD[2]  
        OR VtaListaMay.DtoVolD[3] <> OldListaMay.DtoVolD[3] 
        OR VtaListaMay.DtoVolD[4] <> OldListaMay.DtoVolD[4] 
        OR VtaListaMay.DtoVolD[5] <> OldListaMay.DtoVolD[5] 
        OR VtaListaMay.DtoVolD[6] <> OldListaMay.DtoVolD[6] 
        OR VtaListaMay.DtoVolD[7] <> OldListaMay.DtoVolD[7] 
        OR VtaListaMay.DtoVolD[8] <> OldListaMay.DtoVolD[8] 
        OR VtaListaMay.DtoVolD[9] <> OldListaMay.DtoVolD[9] 
        OR VtaListaMay.DtoVolD[10] <> OldListaMay.DtoVolD[10] 
        OR VtaListaMay.DtoVolR[1] <> OldListaMay.DtoVolR[1] 
        OR VtaListaMay.DtoVolR[2] <> OldListaMay.DtoVolR[2]
        OR VtaListaMay.DtoVolR[3] <> OldListaMay.DtoVolR[3]
        OR VtaListaMay.DtoVolR[4] <> OldListaMay.DtoVolR[4]
        OR VtaListaMay.DtoVolR[5] <> OldListaMay.DtoVolR[5]
        OR VtaListaMay.DtoVolR[6] <> OldListaMay.DtoVolR[6]
        OR VtaListaMay.DtoVolR[7] <> OldListaMay.DtoVolR[7]
        OR VtaListaMay.DtoVolR[8] <> OldListaMay.DtoVolR[8]
        OR VtaListaMay.DtoVolR[9] <> OldListaMay.DtoVolR[9]
        OR VtaListaMay.DtoVolR[10] <> OldListaMay.DtoVolR[10] 
        OR VtaListaMay.PromDto <> OldListaMay.PromDto
        OR VtaListaMay.PromFchD <> OldListaMay.PromFchD
        OR VtaListaMay.PromFchH <> OldListaMay.PromFchH
        THEN DO:
        /* LOG de control */
        CREATE LogVtaListaMay.
        BUFFER-COPY VtaListaMay TO LogVtaListaMay
            ASSIGN
                LogVtaListaMay.LogEvento = "UPDATE"
                LogVtaListaMay.LogDate = TODAY
                LogVtaListaMay.LogTime = STRING(TIME, 'HH:MM:SS')
                LogVtaListaMay.LogUser = s-user-id.
    END.
END.
ELSE DO:
    /* LOG de control */
    CREATE LogVtaListaMay.
    BUFFER-COPY VtaListaMay TO LogVtaListaMay
        ASSIGN
            LogVtaListaMay.LogEvento = "CREATE"
            LogVtaListaMay.LogDate = TODAY
            LogVtaListaMay.LogTime = STRING(TIME, 'HH:MM:SS')
            LogVtaListaMay.LogUser = s-user-id.
END.
