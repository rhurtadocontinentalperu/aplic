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

DEFINE VAR lwCorre AS CHARACTER.


/* BLOQUEAMOS Sí o Sí el correlativo */
REPEAT:
  FIND FIRST wmigcorr WHERE wmigcorr.Proceso = "RV"
      AND wmigcorr.Periodo = YEAR(Ccbcdocu.fchdoc)
      AND wmigcorr.Mes = MONTH(Ccbcdocu.fchdoc)
      EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF NOT AVAILABLE wmigcorr THEN DO:
      IF NOT LOCKED wmigcorr THEN DO:
          /* CREAMOS EL CONTROL */
          CREATE wmigcorr.
          ASSIGN
              wmigcorr.Correlativo = 1
              wmigcorr.Mes = MONTH(Ccbcdocu.fchdoc)
              wmigcorr.Periodo = YEAR(Ccbcdocu.fchdoc)
              wmigcorr.Proceso = "RV"
              NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO, RETRY.
          LEAVE.
      END.
      ELSE UNDO, RETRY.
  END.
  LEAVE.
END.
IF NOT AVAILABLE wmigcorr THEN RETURN 'ADM-ERROR'.
FOR EACH T-WMIGRV NO-LOCK:
  CREATE WMIGRV.
  BUFFER-COPY T-WMIGRV
      TO WMIGRV.

      lwcorre = STRING(wmigcorr.Periodo, '9999') + STRING(wmigcorr.Mes, '99') + 
                  STRING(wmigcorr.Correlativo, '999999').
      lwCorre = SUBSTRING(lwCorre,3).

      ASSIGN
      wmigrv.FlagFecha = DATETIME(TODAY - 1, MTIME)
      wmigrv.FlagTipo = "I"
      wmigrv.FlagUsuario = s-user-id
        /*
      wmigrv.wcorre = STRING(wmigcorr.Periodo, '9999') + STRING(wmigcorr.Mes, '99') + 
                      STRING(wmigcorr.Correlativo, '9999')
                      */
      wmigrv.wcorre = lwCorre
      wmigrv.wsecue = 0001
      wmigrv.wvejer = wmigcorr.Periodo
      wmigrv.wvperi = wmigcorr.Mes.
  ASSIGN
      wmigcorr.Correlativo = wmigcorr.Correlativo + 1.
END.
IF AVAILABLE(wmigcorr) THEN RELEASE wmigcorr.
IF AVAILABLE(wmigrv)   THEN RELEASE wmigrv.
EMPTY TEMP-TABLE T-WMIGRV.
RETURN 'OK'.

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


