TRIGGER PROCEDURE FOR WRITE OF VtaListaMinGn OLD BUFFER OldListaMinGn.

DEFINE SHARED VAR s-CodCia AS INT.

/* RHC 04/03/2019 Log General */
{TRIGGERS/i-logtransactions.i &TableName="vtalistamingn" &Event="WRITE"}

/* ************************************************************************************** */
/* RHC 22/08/19 NUEVAS TABLAS */
/* ************************************************************************************** */
DEF VAR f-PrecioLista AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR s-CanalVenta AS CHAR.

FIND Almmmatg OF VtaListaMinGn NO-LOCK NO-ERROR.
IF (VtaListaMinGn.PreOfi <> OldListaMinGn.PreOfi) AND AVAILABLE Almmmatg THEN DO:
    ASSIGN
        s-CanalVenta = 'MIN'.   /* Lista de Precios UTILEX */
    f-PrecioLista = VtaListaMinGn.PreOfi.
    /*IF Almmmatg.MonVta = 2 THEN f-PrecioLista = f-PrecioLista * Almmmatg.TpoCmb.*/
    /* Actualizamos VtaDctoPromMin: Promociones Vigentes */
    FOR EACH VtaDctoPromMin EXCLUSIVE-LOCK WHERE VtaDctoPromMin.CodCia = VtaListaMinGn.CodCia 
        AND VtaDctoPromMin.CodMat = VtaListaMinGn.CodMat 
        AND (TODAY >= VtaDctoPromMin.FchIni AND TODAY <= VtaDctoPromMin.FchFin),
        FIRST gn-divi OF VtaDctoPromMin NO-LOCK /*WHERE LOOKUP(gn-divi.CanalVenta, s-CanalVenta) > 0*/:
        ASSIGN
            VtaDctoPromMin.Precio = ROUND(f-PrecioLista * (1 - (VtaDctoPromMin.Descuento  / 100)), 4).
    END.
    /* Actualizamos VtaDctoPromMin: Promociones Proyectadas */
    FOR EACH VtaDctoPromMin EXCLUSIVE-LOCK WHERE VtaDctoPromMin.CodCia = VtaListaMinGn.CodCia 
        AND VtaDctoPromMin.CodMat = VtaListaMinGn.CodMat 
        AND VtaDctoPromMin.FchIni > TODAY,
        FIRST gn-divi OF VtaDctoPromMin NO-LOCK /*WHERE LOOKUP(gn-divi.CanalVenta, s-CanalVenta) > 0*/:
        ASSIGN
            VtaDctoPromMin.Precio = ROUND(f-PrecioLista * (1 - (VtaDctoPromMin.Descuento  / 100)), 4).
    END.
    /* Actualizamos Precio por Volumen */
    DO x-Item = 1 TO 10:
        IF VtaListaMinGn.DtoVolD[x-Item] <> 0 THEN
            ASSIGN VtaListaMinGn.DtoVolP[x-Item] = ROUND(f-PrecioLista * (1 - (VtaListaMinGn.DtoVolD[x-Item]  / 100)), 4).
    END.
/*     /* Actualizamos VtaDctoVol */                                                                                */
/*     FOR EACH VtaDctoVol EXCLUSIVE-LOCK WHERE VtaDctoVol.CodCia = VtaListaMinGn.CodCia AND                        */
/*         VtaDctoVol.CodMat = VtaListaMinGn.CodMat AND                                                             */
/*         (TODAY >= VtaDctoVol.FchIni OR TODAY <= VtaDctoVol.FchFin),                                              */
/*         FIRST gn-divi OF VtaDctoVol NO-LOCK WHERE LOOKUP(gn-divi.CanalVenta, s-CanalVenta) > 0:                  */
/*         DO x-Item = 1 TO 10:                                                                                     */
/*             VtaDctoVol.DtoVolP[x-Item] = ROUND(f-PrecioLista * ( 1 - ( VtaDctoVol.DtoVolD[x-Item] / 100 ) ), 4). */
/*         END.                                                                                                     */
/*     END.                                                                                                         */
    /* Actualizamos VtaDctoVolSaldo */
/*     DEF VAR s-Divisiones AS CHAR NO-UNDO.      /* Divisiones válidas */                                                    */
/*     DEFINE VAR hProc AS HANDLE NO-UNDO.                                                                                    */
/*     RUN pri/pri-librerias PERSISTENT SET hProc.                                                                            */
/*     RUN PRI_Divisiones-Validas IN hProc (INPUT 2,                   /* Minorista Contado UTILEX */                         */
/*                                          OUTPUT s-Divisiones).                                                             */
/*     DELETE PROCEDURE hProc.                                                                                                */
/*     FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = Almmmatg.codcia AND                                                  */
/*         FacTabla.Tabla = 'DVXSALDOD' AND                                                                                   */
/*         FacTabla.Campo-C[1] = Almmmatg.codmat,                                                                             */
/*         EACH VtaDctoVolSaldo EXCLUSIVE-LOCK WHERE VtaDctoVolSaldo.CodCia = FacTabla.CodCia AND                             */
/*         VtaDctoVolSaldo.Codigo = ENTRY(1,FacTabla.Codigo,'|') AND                                                          */
/*         VtaDctoVolSaldo.Tabla = 'DVXSALDOC' AND                                                                            */
/*         LOOKUP(VtaDctoVolSaldo.CodDiv, s-Divisiones) > 0 AND                                                               */
/*         (TODAY >= VtaDctoVolSaldo.FchIni OR TODAY <= VtaDctoVolSaldo.FchFin):                                              */
/*         DO x-Item = 1 TO 10:                                                                                               */
/*             VtaDctoVolSaldo.DtoVolP[x-Item] = ROUND(f-PrecioLista * ( 1 - ( VtaDctoVolSaldo.DtoVolD[x-Item] / 100 ) ), 4). */
/*         END.                                                                                                               */
/*     END.                                                                                                                   */
END.

/* ************************************************************************************** */


DEF VAR x-CtoTot AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

DEF VAR x-PreNew LIKE VtaListaMinGn.PreOfi NO-UNDO.
DEF VAR x-PreOld LIKE VtaListaMinGn.PreOfi NO-UNDO.
DEF VAR pEstado AS CHAR NO-UNDO.
ASSIGN
    x-PreNew = VtaListaMinGn.PreOfi
    x-PreOld = OldListaMinGn.PreOfi.
IF VtaListaMinGn.MonVta = 2 THEN
    ASSIGN
    x-PreNew = x-PreNew * VtaListaMinGn.TpoCmb
    x-PreOld = x-PreOld * VtaListaMinGn.TpoCmb.
RUN gn/p-ecommerce (INPUT "aplic/gn/p-ecommerce-precios.p",
                    INPUT STRING(s-CodCia) + ',' +
                    VtaListaMinGn.CodMat + ',' +
                    STRING(x-PreNew) + ',' +
                    STRING(x-PreOld) + ',' +
                    "U" + ',' +
                    STRING(VtaListaMinGn.TpoCmb) + ',' +
                    STRING(VtaListaMinGn.MonVta) + ',' +
                    s-User-Id,
                    OUTPUT pEstado).

IF OldListaMinGn.codmat <> '' THEN DO:
    IF VtaListaMinGn.CHR__01 <>  OldListaMinGn.CHR__01
        OR VtaListaMinGn.MonVta <>  OldListaMinGn.MonVta
        OR VtaListaMinGn.PreOfi <> OldListaMinGn.PreOfi
        OR VtaListaMinGn.TpoCmb <> OldListaMinGn.TpoCmb
        OR VtaListaMinGn.DtoVolD[1] <> OldListaMinGn.DtoVolD[1] 
        OR VtaListaMinGn.DtoVolD[2] <> OldListaMinGn.DtoVolD[2]  
        OR VtaListaMinGn.DtoVolD[3] <> OldListaMinGn.DtoVolD[3] 
        OR VtaListaMinGn.DtoVolD[4] <> OldListaMinGn.DtoVolD[4] 
        OR VtaListaMinGn.DtoVolD[5] <> OldListaMinGn.DtoVolD[5] 
        OR VtaListaMinGn.DtoVolD[6] <> OldListaMinGn.DtoVolD[6] 
        OR VtaListaMinGn.DtoVolD[7] <> OldListaMinGn.DtoVolD[7] 
        OR VtaListaMinGn.DtoVolD[8] <> OldListaMinGn.DtoVolD[8] 
        OR VtaListaMinGn.DtoVolD[9] <> OldListaMinGn.DtoVolD[9] 
        OR VtaListaMinGn.DtoVolD[10] <> OldListaMinGn.DtoVolD[10] 
        OR VtaListaMinGn.DtoVolR[1] <> OldListaMinGn.DtoVolR[1] 
        OR VtaListaMinGn.DtoVolR[2] <> OldListaMinGn.DtoVolR[2]
        OR VtaListaMinGn.DtoVolR[3] <> OldListaMinGn.DtoVolR[3]
        OR VtaListaMinGn.DtoVolR[4] <> OldListaMinGn.DtoVolR[4]
        OR VtaListaMinGn.DtoVolR[5] <> OldListaMinGn.DtoVolR[5]
        OR VtaListaMinGn.DtoVolR[6] <> OldListaMinGn.DtoVolR[6]
        OR VtaListaMinGn.DtoVolR[7] <> OldListaMinGn.DtoVolR[7]
        OR VtaListaMinGn.DtoVolR[8] <> OldListaMinGn.DtoVolR[8]
        OR VtaListaMinGn.DtoVolR[9] <> OldListaMinGn.DtoVolR[9]
        OR VtaListaMinGn.DtoVolR[10] <> OldListaMinGn.DtoVolR[10] 
        OR VtaListaMinGn.PromDivi[1] <> OldListaMinGn.PromDivi[1]
        OR VtaListaMinGn.PromDivi[2] <> OldListaMinGn.PromDivi[2]
        OR VtaListaMinGn.PromDivi[3] <> OldListaMinGn.PromDivi[3]
        OR VtaListaMinGn.PromDivi[4] <> OldListaMinGn.PromDivi[4]
        OR VtaListaMinGn.PromDivi[5] <> OldListaMinGn.PromDivi[5]
        OR VtaListaMinGn.PromDivi[6] <> OldListaMinGn.PromDivi[6]
        OR VtaListaMinGn.PromDivi[7] <> OldListaMinGn.PromDivi[7]
        OR VtaListaMinGn.PromDivi[8] <> OldListaMinGn.PromDivi[8]
        OR VtaListaMinGn.PromDivi[9] <> OldListaMinGn.PromDivi[9]
        OR VtaListaMinGn.PromDivi[10] <> OldListaMinGn.PromDivi[10]
        OR VtaListaMinGn.PromDto[1] <> OldListaMinGn.PromDto[1]
        OR VtaListaMinGn.PromDto[2] <> OldListaMinGn.PromDto[2]
        OR VtaListaMinGn.PromDto[3] <> OldListaMinGn.PromDto[3]
        OR VtaListaMinGn.PromDto[4] <> OldListaMinGn.PromDto[4]
        OR VtaListaMinGn.PromDto[5] <> OldListaMinGn.PromDto[5]
        OR VtaListaMinGn.PromDto[6] <> OldListaMinGn.PromDto[6]
        OR VtaListaMinGn.PromDto[7] <> OldListaMinGn.PromDto[7]
        OR VtaListaMinGn.PromDto[8] <> OldListaMinGn.PromDto[8]
        OR VtaListaMinGn.PromDto[9] <> OldListaMinGn.PromDto[9]
        OR VtaListaMinGn.PromDto[10] <> OldListaMinGn.PromDto[10]
        OR VtaListaMinGn.PromFchD[1] <> OldListaMinGn.PromFchD[1]
        OR VtaListaMinGn.PromFchD[2] <> OldListaMinGn.PromFchD[2]
        OR VtaListaMinGn.PromFchD[3] <> OldListaMinGn.PromFchD[3]
        OR VtaListaMinGn.PromFchD[4] <> OldListaMinGn.PromFchD[4]
        OR VtaListaMinGn.PromFchD[5] <> OldListaMinGn.PromFchD[5]
        OR VtaListaMinGn.PromFchD[6] <> OldListaMinGn.PromFchD[6]
        OR VtaListaMinGn.PromFchD[7] <> OldListaMinGn.PromFchD[7]
        OR VtaListaMinGn.PromFchD[8] <> OldListaMinGn.PromFchD[8]
        OR VtaListaMinGn.PromFchD[9] <> OldListaMinGn.PromFchD[9]
        OR VtaListaMinGn.PromFchD[10]<> OldListaMinGn.PromFchD[10] 
        OR VtaListaMinGn.PromFchH[1] <> OldListaMinGn.PromFchH[1]
        OR VtaListaMinGn.PromFchH[2] <> OldListaMinGn.PromFchH[2]
        OR VtaListaMinGn.PromFchH[3] <> OldListaMinGn.PromFchH[3]
        OR VtaListaMinGn.PromFchH[4] <> OldListaMinGn.PromFchH[4]
        OR VtaListaMinGn.PromFchH[5] <> OldListaMinGn.PromFchH[5]
        OR VtaListaMinGn.PromFchH[6] <> OldListaMinGn.PromFchH[6]
        OR VtaListaMinGn.PromFchH[7] <> OldListaMinGn.PromFchH[7]
        OR VtaListaMinGn.PromFchH[8] <> OldListaMinGn.PromFchH[8]
        OR VtaListaMinGn.PromFchH[9] <> OldListaMinGn.PromFchH[9]
        OR VtaListaMinGn.PromFchH[10] <> OldListaMinGn.PromFchH[10]
        THEN DO:
        /* LOG de control */
        CREATE LogListaMinGn.
        BUFFER-COPY VtaListaMinGn TO LogListaMinGn
            ASSIGN
                LogListaMinGn.NumId = pRCID
                LogListaMinGn.LogDate = TODAY
                LogListaMinGn.LogTime = STRING(TIME, 'HH:MM:SS')
                LogListaMinGn.LogUser = s-user-id
                LogListaMinGn.FlagFechaHora = DATETIME(TODAY, MTIME)
                /*LogListaMinGn.FlagMigracion */
                LogListaMinGn.FlagUsuario = s-user-id
                LogListaMinGn.FlagEstado = "U".
    END.
END.
ELSE DO:
    /* LOG de control */
    CREATE LogListaMinGn.
    BUFFER-COPY VtaListaMinGn TO LogListaMinGn
        ASSIGN
            LogListaMinGn.NumId = pRCID
            LogListaMinGn.LogDate = TODAY
            LogListaMinGn.LogTime = STRING(TIME, 'HH:MM:SS')
            LogListaMinGn.LogUser = s-user-id
            LogListaMinGn.FlagFechaHora = DATETIME(TODAY, MTIME)
            /*LogListaMinGn.FlagMigracion */
            LogListaMinGn.FlagUsuario = s-user-id
            LogListaMinGn.FlagEstado = "I".
END.

/* RHC 28/06/2017 Solicitado por Martin Salcedo */
ASSIGN
    VtaListaMinGn.DateUpdate = TODAY
    VtaListaMinGn.HourUpdate = STRING(TIME,'HH:MM:SS')
    VtaListaMinGn.UserUpdate = s-user-id.
