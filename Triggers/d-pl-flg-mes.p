TRIGGER PROCEDURE FOR DELETE OF pl-flg-mes.

FIND FIRST pl-pers WHERE pl-pers.codper = pl-flg-mes.codper
    NO-LOCK NO-ERROR.
IF AVAILABLE pl-pers THEN DO:
    CREATE TempusPers.                                            
    ASSIGN
        TempusPers.Apellido_materno     = pl-pers.matper
        TempusPers.Apellido_paterno     = pl-pers.patper
        TempusPers.Cargo                = pl-flg-mes.cargos
        TempusPers.Centro_de_costo      = pl-flg-mes.ccosto
        TempusPers.Codigo               = pl-flg-mes.codper
        TempusPers.DNI                  = pl-pers.nrodocid
        TempusPers.Empresa              = STRING(pl-flg-mes.codpln, '99')
        TempusPers.Fecha_de_cese        = pl-flg-mes.vcontr
        TempusPers.Fecha_de_ingreso     = pl-flg-mes.fecing
        TempusPers.Fecha_de_nacimiento  = pl-pers.fecnac
        TempusPers.Nombres              = pl-pers.nomper
        TempusPers.Seccion              = pl-flg-mes.seccion
        TempusPers.FechaHora_Progress   = DATETIME(TODAY, MTIME)
        TempusPers.FlagTipo             = "D".
END.
