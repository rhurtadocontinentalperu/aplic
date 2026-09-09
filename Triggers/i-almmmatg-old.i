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

/* ************************************************************************************** */
/* RHC 22/08/19 NUEVAS TABLAS */
/* ************************************************************************************** */
DEFINE VARIABLE s-CanalVenta AS CHAR.

ASSIGN
    s-CanalVenta = 'ATL,HOR,INS,MOD,PRO,TDA,INT,B2C,MIN'.   /* Lista de Precios LIMA */

DEF VAR f-PrecioLista AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.

IF (Almmmatg.PreVta[1] <> OldAlmmmatg.PreVta[1]) OR
    (Almmmatg.PreOfi <> OldAlmmmatg.PreOfi) OR
    (Almmmatg.MonVta <> OLDAlmmmatg.MonVta) OR
    (Almmmatg.TpoCmb <> OLDAlmmmatg.TpoCmb) THEN DO:
    /* TODO EN SOLES */
    f-PrecioLista = Almmmatg.PreVta[1].    /* >>>> OJO <<<< */
    IF Almmmatg.MonVta = 2 THEN f-PrecioLista = f-PrecioLista * Almmmatg.TpoCmb.
    /* Actualizamos VtaDctoProm: Promociones Vigentes */
    FOR EACH VtaDctoProm EXCLUSIVE-LOCK WHERE VtaDctoProm.CodCia = Almmmatg.CodCia 
        AND VtaDctoProm.CodMat = Almmmatg.CodMat 
        AND (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin),
        FIRST gn-divi OF VtaDctoProm NO-LOCK WHERE /*LOOKUP(gn-divi.CanalVenta, s-CanalVenta) > 0
        AND*/ gn-divi.ventamayorista = 1:     /* OJO >>> Lista General */
        ASSIGN
            VtaDctoProm.Precio = ROUND(f-PrecioLista * (1 - (VtaDctoProm.Descuento  / 100)), 4).
    END.
    /* Actualizamos VtaDctoProm: Promociones Proyectadas */
    FOR EACH VtaDctoProm EXCLUSIVE-LOCK WHERE VtaDctoProm.CodCia = Almmmatg.CodCia 
        AND VtaDctoProm.CodMat = Almmmatg.CodMat 
        AND VtaDctoProm.FchIni > TODAY,
        FIRST gn-divi OF VtaDctoProm NO-LOCK WHERE /*LOOKUP(gn-divi.CanalVenta, s-CanalVenta) > 0
        AND*/ gn-divi.ventamayorista = 1:     /* OJO >>> Lista General */
        ASSIGN
            VtaDctoProm.Precio = ROUND(f-PrecioLista * (1 - (VtaDctoProm.Descuento  / 100)), 4).
    END.
    /* Actualizamos VtaDctoVol: Vigentes */
    FOR EACH VtaDctoVol EXCLUSIVE-LOCK WHERE VtaDctoVol.CodCia = Almmmatg.CodCia AND
        VtaDctoVol.CodMat = Almmmatg.CodMat AND
        (TODAY >= VtaDctoVol.FchIni OR TODAY <= VtaDctoVol.FchFin),
        FIRST gn-divi OF VtaDctoVol NO-LOCK WHERE gn-divi.ventamayorista = 1:     /* OJO >>> Lista General */
        DO x-Item = 1 TO 10:
            VtaDctoVol.DtoVolP[x-Item] = ROUND(f-PrecioLista * ( 1 - ( VtaDctoVol.DtoVolD[x-Item] / 100 ) ), 4).
        END.
    END.
    /* Actualizamos VtaDctoVol: Proyectadas */
    FOR EACH VtaDctoVol EXCLUSIVE-LOCK WHERE VtaDctoVol.CodCia = Almmmatg.CodCia AND
        VtaDctoVol.CodMat = Almmmatg.CodMat AND
        VtaDctoVol.FchIni > TODAY,
        FIRST gn-divi OF VtaDctoVol NO-LOCK WHERE gn-divi.ventamayorista = 1:     /* OJO >>> Lista General */
        DO x-Item = 1 TO 10:
            VtaDctoVol.DtoVolP[x-Item] = ROUND(f-PrecioLista * ( 1 - ( VtaDctoVol.DtoVolD[x-Item] / 100 ) ), 4).
        END.
    END.
/*     /* Actualizamos VtaDctoVolSaldo */                                                                                     */
/*     DEF VAR s-Divisiones AS CHAR NO-UNDO.      /* Divisiones válidas */                                                    */
/*     DEFINE VAR hProc AS HANDLE NO-UNDO.                                                                                    */
/*     RUN pri/pri-librerias PERSISTENT SET hProc.                                                                            */
/*     RUN PRI_Divisiones-Validas IN hProc (INPUT 1,                   /* Mayoristas Contado y Crédito */                     */
/*                                          OUTPUT s-Divisiones).                                                             */
/*     DELETE PROCEDURE hProc.                                                                                                */
/*     FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = Almmmatg.codcia AND                                                  */
/*         FacTabla.Tabla = 'DVXSALDOD' AND                                                                                   */
/*         FacTabla.Campo-C[1] = Almmmatg.codmat,                                                                             */
/*         EACH VtaDctoVolSaldo EXCLUSIVE-LOCK WHERE VtaDctoVolSaldo.CodCia =FacTabla.CodCia AND                              */
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

/* RHC 30.01.2013 AGREGAMOS LOG DE CONTROL PARA OPENORANGE */
IF OldAlmmmatg.codmat <> '' THEN DO:
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
    /* ** CUALQUIER CAMBIO DEBE REFLEJARSE EN LA OTRAS LISTAS DE PRECIOS ** */
    IF Almmmatg.UndBas <>  OldAlmmmatg.UndBas
        OR Almmmatg.UndStk <> OldAlmmmatg.UndStk
        OR Almmmatg.DesMat <> OldAlmmmatg.DesMat
        OR Almmmatg.CodBrr <> OldAlmmmatg.CodBrr
        OR Almmmatg.MonVta <>  OldAlmmmatg.MonVta
        OR Almmmatg.PreOfi <> OldAlmmmatg.PreOfi
        OR Almmmatg.TpoCmb <> OldAlmmmatg.TpoCmb
        OR Almmmatg.CtoLis <> OldAlmmmatg.CtoLis
        OR Almmmatg.CtoTot <> OldAlmmmatg.CtoTot
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
        DEF VAR f-Precio AS DEC NO-UNDO.
        f-Precio = Almmmatg.PreVta[1].
        IF Almmmatg.MonVta = 2 THEN F-PRECIO = Almmmatg.Prevta[1] * Almmmatg.TpoCmb.
        FOR EACH VtaTabla WHERE VtaTabla.codcia = Almmmatg.codcia
            AND VtaTabla.Tabla = "DTOPROLIMA"
            AND VtaTabla.llave_c1 = Almmmatg.codmat:
            VtaTabla.Valor[2] = ROUND(F-PRECIO * ( 1 - ( VtaTabla.Valor[1] / 100 ) ),4).
        END.
        /* ********* RHC MARGENES LISTAS DE PRECIOS ************** */
        IF Almmmatg.UndBas <>  OldAlmmmatg.UndBas
            OR Almmmatg.MonVta <>  OldAlmmmatg.MonVta
            OR Almmmatg.TpoCmb <> OldAlmmmatg.TpoCmb
            OR Almmmatg.CtoTot <> OldAlmmmatg.CtoTot
            THEN DO:
            /* LISTA MINORISTA GENERAL (UTILEX) */
            FOR EACH vtalistaminGn WHERE vtalistaminGn.codcia = Almmmatg.CodCia
                AND vtalistaminGn.codmat = Almmmatg.codmat:
                x-CtoTot = Almmmatg.ctotot.
                f-Factor = 1.
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = vtalistaminGn.Chr__01
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN DO:
                    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                END.  
                ASSIGN
                    vtalistaminGn.Dec__01 = ( (vtalistaminGn.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100. 
            END.
            /* LISTA MAYORISTA POR DIVISION */
            /* RHC 06/11/2013 LA MONEDA Y TIPO DE CAMBIO ESTAN EL ALMMMATG */
            FOR EACH VtaListaMay WHERE VtaListaMay.codcia = Almmmatg.codcia
                AND VtaListaMay.codmat = Almmmatg.codmat:
                ASSIGN
                    VtaListaMay.MonVta = Almmmatg.MonVta
                    VtaListaMay.TpoCmb = Almmmatg.TpoCmb
                    x-CtoTot           = Almmmatg.CtoTot
                    f-Factor = 1.
                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
                    AND Almtconv.Codalter = VtaListaMay.Chr__01
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                ASSIGN
                    VtaListaMay.Dec__01 = ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100. 
            END.
        END.
    END.
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


