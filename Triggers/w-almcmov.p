TRIGGER PROCEDURE FOR WRITE OF Almcmov OLD BUFFER OldAlmcmov.

/* Verificamos la Fecha de Cierre de Almacenes */
DEF SHARED VAR s-codcia AS INT.
FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = "CIERRE"
    AND TabGener.Codigo = "ALMACEN"
    NO-LOCK NO-ERROR.
IF AVAILABLE TabGener AND TabGener.Libre_f01 <> ? THEN DO:
    IF OldAlmcmov.FchDoc <> ? AND OldAlmcmov.FchDoc <= TabGener.Libre_f01 THEN DO:
        MESSAGE "NO se pueden modificar/anular movimientos de almacén generados hasta el" TabGener.Libre_f01
            VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
END.

/* RHC 06/06/2017 Solicitado por Martin Salcedo */
DEF SHARED VAR s-user-id AS CHAR.
IF NEW Almcmov THEN
    ASSIGN
    Almcmov.DateUpdate = TODAY
    Almcmov.HourUpdate = STRING(TIME,'HH:MM:SS')
    Almcmov.UserUpdate = s-user-id.

/* RHC 18/12/2020 Fecha de Registro */
/*IF NEW Almcmov THEN ASSIGN Almcmov.FchCbd = TODAY.*/

/* ************************************************************************************ */
/* 06/02/2026 RUTINAS PARA EL SAP */
/* ************************************************************************************ */
/* CONTROL SAP */
/* &SCOPED-DEFINE SAP_ENABLE YES              */
/*                                            */
/* &IF {&SAP_ENABLE} &THEN                    */
/* {sap/interface_sap.i &input_table=almcmov} */
/* &ENDIF                                     */
/* ************************************************************************************ */
/* ************************************************************************************ */
