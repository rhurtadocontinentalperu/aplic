DEF VAR s-codcia AS INT INIT 001 NO-UNDO.
DEF VAR cb-codcia AS INT INIT 000 NO-UNDO.
DEF VAR pv-codcia AS INT INIT 000 NO-UNDO.

DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Texto (*.txt)" "*.txt", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

DEF TEMP-TABLE detalle LIKE OpenVentas.

DEF VAR x-Linea AS CHAR NO-UNDO.

/* 1ro Migramos la información a Detalle */
RUN Carga-Temporal.

/* 2do Cargamos Tablas Progress */
/* FOR EACH Detalle:                              */
/*     DISPLAY detalle WITH 2 COL WITH STREAM-IO. */
/* END.                                           */

RUN Carga-Progress.

MESSAGE 'FIN DEL PROCESO'.


PROCEDURE Carga-Temporal:

INPUT FROM VALUE(FILL-IN-file).
REPEAT:
    IMPORT UNFORMATTED x-linea.
    IF x-linea = '' THEN LEAVE.
    IF x-linea BEGINS 'DIVISION' THEN NEXT.
    CREATE Detalle.
    ASSIGN
        Detalle.CodCia = s-codcia
        Detalle.CodDiv = ENTRY(1, x-Linea, '|')
        Detalle.CodDoc = "TCK"      /* ENTRY(2, x-Linea, '|') */
        Detalle.NroDoc = REPLACE(ENTRY(3, x-Linea, '|'), "-", "")
        Detalle.FchDoc = DATE(ENTRY(4, x-Linea, '|'))
        Detalle.CodCli = ENTRY(5, x-Linea, '|')
        Detalle.NomCli = ENTRY(6, x-Linea, '|')
        Detalle.DirCli = ENTRY(7, x-Linea, '|')
        Detalle.TpoDoc = ENTRY(8, x-Linea, '|')
        Detalle.RucCli = ENTRY(9, x-Linea, '|').
    ASSIGN
        Detalle.ImpBrt = DECIMAL(ENTRY(10, x-Linea, '|'))
        Detalle.ImpExo = DECIMAL(ENTRY(11, x-Linea, '|'))
        Detalle.PorIgv = DECIMAL(ENTRY(12, x-Linea, '|'))
        Detalle.ImpIgv = DECIMAL(ENTRY(13, x-Linea, '|'))
        Detalle.ImpDto = DECIMAL(ENTRY(14, x-Linea, '|'))
        Detalle.ImpVta = DECIMAL(ENTRY(15, x-Linea, '|'))
        Detalle.ImpTot = DECIMAL(ENTRY(16, x-Linea, '|')).
    ASSIGN
        Detalle.FlgEst = ENTRY(17, x-Linea, '|')
        Detalle.usuario = ENTRY(18, x-Linea, '|')
        Detalle.HorCie = ENTRY(19, x-Linea, '|')
        Detalle.CodMon = INTEGER(ENTRY(20, x-Linea, '|'))
        Detalle.TpoCmb = DECIMAL(ENTRY(21, x-Linea, '|'))
        Detalle.CodAlm = ENTRY(22, x-Linea, '|')
        Detalle.CodVen = ENTRY(23, x-Linea, '|')
        Detalle.Glosa  = ENTRY(24, x-Linea, '|')
        Detalle.UsuAnu = ENTRY(25, x-Linea, '|').
    ASSIGN
        Detalle.NroItm = INTEGER(ENTRY(26, x-Linea, '|'))
        Detalle.codmat = ENTRY(27, x-Linea, '|')
        Detalle.CanDes = DECIMAL(ENTRY(28, x-Linea, '|'))
        Detalle.UndVta = ENTRY(29, x-Linea, '|')
        Detalle.PreUni = DECIMAL(ENTRY(30, x-Linea, '|'))
        Detalle.Por_Dsctos1 = DECIMAL(ENTRY(31, x-Linea, '|'))
        Detalle.Por_Dsctos2 = DECIMAL(ENTRY(32, x-Linea, '|'))
        Detalle.Por_Dsctos3 = DECIMAL(ENTRY(33, x-Linea, '|'))
        Detalle.ImpIgvLin   = DECIMAL(ENTRY(34, x-Linea, '|'))
        Detalle.ImpIsc = DECIMAL(ENTRY(35, x-Linea, '|'))
        Detalle.ImpLin = DECIMAL(ENTRY(36, x-Linea, '|'))
        Detalle.AftIgv = IF ENTRY(37, x-Linea, '|') = "SI" THEN YES ELSE NO
        Detalle.AftIsc = IF ENTRY(38, x-Linea, '|') = "SI" THEN YES ELSE NO
        Detalle.Factor = DECIMAL(ENTRY(39, x-Linea, '|')).
    ASSIGN
        Detalle.ImpNac1 = DECIMAL(ENTRY(40, x-Linea, '|'))
        Detalle.ImpNac2 = DECIMAL(ENTRY(41, x-Linea, '|'))
        Detalle.ImpNac3 = DECIMAL(ENTRY(42, x-Linea, '|'))
        Detalle.ImpNac4 = DECIMAL(ENTRY(43, x-Linea, '|'))
        Detalle.ImpNac5 = DECIMAL(ENTRY(44, x-Linea, '|'))
        Detalle.ImpNac6 = DECIMAL(ENTRY(45, x-Linea, '|'))
        Detalle.ImpNac7 = DECIMAL(ENTRY(46, x-Linea, '|'))
        Detalle.ImpUsa1 = DECIMAL(ENTRY(47, x-Linea, '|'))
        Detalle.ImpUsa2 = DECIMAL(ENTRY(48, x-Linea, '|'))
        Detalle.ImpUsa3 = DECIMAL(ENTRY(49, x-Linea, '|'))
        Detalle.ImpUsa4 = DECIMAL(ENTRY(50, x-Linea, '|'))
        Detalle.ImpUsa5 = DECIMAL(ENTRY(51, x-Linea, '|'))
        Detalle.ImpUsa6 = DECIMAL(ENTRY(52, x-Linea, '|'))
        Detalle.ImpUsa7 = DECIMAL(ENTRY(53, x-Linea, '|'))
        Detalle.VueNac  = 0     /* DECIMAL(ENTRY(54, x-Linea, '|')) */
        Detalle.VueUsa  = 0     /* DECIMAL(ENTRY(55, x-Linea, '|')) */
        Detalle.Voucher1 = ENTRY(56, x-Linea, '|')
        Detalle.Voucher2 = ENTRY(57, x-Linea, '|')
        Detalle.Voucher3 = ENTRY(58, x-Linea, '|')
        Detalle.Voucher4 = ENTRY(59, x-Linea, '|')
        Detalle.Voucher5 = ENTRY(60, x-Linea, '|')
        Detalle.Voucher6 = ENTRY(61, x-Linea, '|')
        Detalle.Voucher7 = ENTRY(62, x-Linea, '|')
        Detalle.Voucher8 = ENTRY(63, x-Linea, '|')
        Detalle.Voucher9 = REPLACE(ENTRY(64, x-Linea, '|'), "-", "")
        Detalle.FechaCarga = DATE(ENTRY(65, x-Linea, '|'))
        Detalle.HoraCarga = ENTRY(66, x-Linea, '|')
        Detalle.UsuarioCarga = ENTRY(67, x-Linea, '|')
        Detalle.CodCaja = ENTRY(68, x-Linea, '|')
        Detalle.Voucher10 = ENTRY(69, x-Linea, '|').
    /* Chequeamos BANCO */
/*     FIND cb-tabl WHERE tabla = '04'                              */
/*         AND cb-tabl.Nombre = Detalle.Voucher6                    */
/*         NO-LOCK NO-ERROR.                                        */
/*     IF AVAILABLE cb-tabl THEN Detalle.Voucher6 = cb-tabl.Codigo. */
END.
INPUT CLOSE.

END PROCEDURE.

PROCEDURE Carga-Progress:

FOR EACH Detalle:
    CREATE OpenVentas.
    BUFFER-COPY Detalle TO OpenVentas.
    DELETE Detalle.
END.

END PROCEDURE.
