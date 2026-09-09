TRIGGER PROCEDURE FOR DELETE OF Gn-ClieD.

/* ************************************************************************************ */
/* 06/02/2026 RUTINAS PARA EL SAP */
/* ************************************************************************************ */
DEFINE SHARED VAR s-user-id AS CHAR.

/* CONTROL SAP */
&SCOPED-DEFINE SAP_ENABLE YES 

&IF {&SAP_ENABLE} &THEN
DEFINE BUFFER bInterface_SAP FOR Interface_SAP.
DEFINE VAR LocalAccion AS CHAR INIT 'DELETE' NO-UNDO.

CREATE Interface_SAP.
ASSIGN
    Interface_SAP.division              = ""
    Interface_SAP.code_key              = "CLIED"
    Interface_SAP.number_key            = gn-clied.codcli + "," + gn-clied.sede
    Interface_SAP.serial_number         = 0
    Interface_SAP.correlative_number    = 0
    Interface_SAP.date_create           = TODAY
    Interface_SAP.hour_create           = STRING(TIME,'HH:MM:SS')
    Interface_SAP.origin                = ""
    Interface_SAP.user_create           = s-user-id
    Interface_SAP.libre_c01             = "gn-clied"
    Interface_SAP.libre_c02             = LocalAccion
    NO-ERROR.
RELEASE Interface_SAP.
&ENDIF
/* ************************************************************************************ */
/* ************************************************************************************ */

