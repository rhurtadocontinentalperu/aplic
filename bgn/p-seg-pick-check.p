&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report-2 NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE t-Vtacdocu NO-UNDO LIKE VtaCDocu.
DEFINE TEMP-TABLE t-Vtacdocu-2 NO-UNDO LIKE VtaCDocu.
DEFINE BUFFER x-vtacdocu FOR VtaCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

DEF SHARED VAR s-codcia AS INTE.

DEF INPUT PARAMETER pInicio AS DATE.
DEF INPUT PARAMETER pFin    AS DATE.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF OUTPUT PARAMETER TABLE FOR t-report-2.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-report-2 T "?" NO-UNDO INTEGRAL w-report
      TABLE: t-Vtacdocu T "?" NO-UNDO INTEGRAL VtaCDocu
      TABLE: t-Vtacdocu-2 T "?" NO-UNDO INTEGRAL VtaCDocu
      TABLE: x-vtacdocu B "?" ? INTEGRAL VtaCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  EMPTY TEMP-TABLE t-report-2.

  DEFINE VAR x-fecha-desde AS DATETIME.
  DEFINE VAR x-fecha-hasta AS DATETIME.

  /* Cargamos Picadores */
  DEF VAR x-UsrSac AS CHAR NO-UNDO.
  DEF VAR x-FchSac AS DATE NO-UNDO.
  /* ----------------------------------------------------- */

  DEF VAR x-Item AS INTE NO-UNDO.
  DEF VAR x-Peso AS DECI NO-UNDO.
  DEF VAR x-Volumen AS DECI NO-UNDO.
  DEF VAR x-Contador AS INTE NO-UNDO.

  x-fecha-desde = DATETIME(STRING(pInicio,"99/99/9999") + " 00:00:00").
  x-fecha-hasta = DATETIME(STRING(pFin,"99/99/9999") + " 23:59:59").
  
  /* ************************************************************************************************** */
  /* PASO 1: PICADORES */
  /* ************************************************************************************************** */
  FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-CodCia AND 
      LogTrkDocs.CodDiv = pCodDiv AND
      (LogTrkDocs.fecha >= x-fecha-desde AND  LogTrkDocs.fecha <= x-fecha-hasta) AND
      LogTrkDocs.Clave = 'TRCKHPK' :
      
      IF NOT (LogTrkDocs.CodDoc = "HPK" AND LogTrkDocs.Codigo = 'PK_COM') THEN NEXT.

      FIND FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
          VtaCDocu.CodDiv = pCodDiv AND 
          VtaCDocu.CodPed = LogTrkDocs.CodDoc AND 
          VtaCDocu.NroPed = LogTrkDocs.NroDoc AND 
          ( VtaCDocu.Libre_c03 > '' AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3 ) NO-ERROR.

      IF NOT AVAILABLE vtacdocu THEN NEXT.      

      IF ( VtaCDocu.Libre_c03 > '' AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3 )
          OR ( VtaCDocu.UsrSac > '' ) THEN DO:

          IF NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3 THEN x-UsrSac = ENTRY(3,VtaCDocu.Libre_c03,'|').
          ELSE x-UsrSac = VtaCDocu.UsrSac.

          CREATE t-report-2.
          ASSIGN 
              t-report-2.Llave-C = "PICADOR"
              t-report-2.campo-c[1] = x-UsrSac
              t-report-2.campo-c[3] = VtaCDocu.CodPed 
              t-report-2.campo-c[4] = VtaCDocu.NroPed
              t-report-2.campo-d[1] = LogTrkDocs.Fecha
              t-report-2.campo-c[5] = SUBSTRING(ENTRY(2, STRING(LogTrkDocs.Fecha), ' '),1,5)
              t-report-2.Campo-F[1] = VtaCDocu.Items
              t-report-2.Campo-F[2] = VtaCDocu.Peso
              t-report-2.Campo-F[3] = VtaCDocu.Volumen
              t-report-2.Campo-c[6] = 'PK_COM'
              t-report-2.Campo-L[1] = VtaCDocu.EmpaqEspec
              .
      END.
  END.
  /* ************************************************************************************************** */
  /* Buscamos su nombre */
  /* ************************************************************************************************** */
  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

/*   FOR EACH t-report-2:                                            */
/*       RUN logis/p-busca-por-dni ( INPUT t-report-2.campo-c[1],    */
/*                                   OUTPUT pNombre,                 */
/*                                   OUTPUT pOrigen).                */
/*       IF pOrigen <> 'ERROR' THEN t-report-2.campo-c[2] = pNombre. */
/*   END.                                                            */
  /* ************************************************************************************************** */
  /* ************************************************************************************************** */
  /* ************************************************************************************************** */
  /* PASO 2: CHEQUEADORES */
  /* ************************************************************************************************** */
  FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-CodCia AND 
      LogTrkDocs.CodDiv = pCodDiv AND
      (LogTrkDocs.fecha >= x-fecha-desde AND  LogTrkDocs.fecha <= x-fecha-hasta) AND
      LogTrkDocs.Clave = 'TRCKHPK' :
      IF NOT (LogTrkDocs.CodDoc = "HPK" AND LogTrkDocs.Codigo = 'CK_CH') THEN NEXT.
      
      FIND FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
          VtaCDocu.CodDiv = pCodDiv AND 
          VtaCDocu.CodPed = LogTrkDocs.CodDoc AND 
          VtaCDocu.NroPed = LogTrkDocs.NroDoc AND 
          ( VtaCDocu.Libre_c04 > '' AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 3 ) NO-ERROR.
      IF NOT AVAILABLE vtacdocu THEN NEXT.      

      IF VtaCDocu.Libre_c04 > '' AND NUM-ENTRIES(VtaCDocu.Libre_c04,'|') >= 3 THEN DO:
          CREATE t-report-2.
          ASSIGN 
              t-report-2.Llave-C = "CHEQUEADOR"
              t-report-2.campo-c[1] = ENTRY(1,VtaCDocu.Libre_c04,'|')
              t-report-2.campo-c[3] = VtaCDocu.CodPed 
              t-report-2.campo-c[4] = VtaCDocu.NroPed
              t-report-2.campo-d[1] = LogTrkDocs.Fecha
              t-report-2.campo-c[5] = SUBSTRING(ENTRY(2, STRING(LogTrkDocs.Fecha), ' '),1,5)
              t-report-2.Campo-F[1] = VtaCDocu.Items
              t-report-2.Campo-F[2] = VtaCDocu.Peso
              t-report-2.Campo-F[3] = VtaCDocu.Volumen
              t-report-2.Campo-c[6] = 'CK_CH'
              t-report-2.Campo-L[1] = VtaCDocu.EmpaqEspec
              .
      END.
  END.
/*   /* ************************************************************************************************** */ */
/*   /* Buscamos su nombre */                                                                                 */
/*   /* ************************************************************************************************** */ */
/*   FOR EACH t-report-2 WHERE TRUE <> (t-report-2.campo-c[2] > ''):                                          */
/*       RUN gn/nombre-personal (s-CodCia, t-report-2.campo-c[1], OUTPUT pNombre).                            */
/*       IF pOrigen <> 'ERROR' THEN t-report-2.campo-c[2] = pNombre.                                          */
/*   END.                                                                                                     */

  /* ************************************************************************************************** */
  /* PASO 3: INICIO DE PIQUEO */
  /* ************************************************************************************************** */
  FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-CodCia AND 
      LogTrkDocs.CodDiv = pCodDiv AND
      (LogTrkDocs.fecha >= x-fecha-desde AND  LogTrkDocs.fecha <= x-fecha-hasta) AND
      LogTrkDocs.Clave = 'TRCKHPK' :
      
      IF NOT (LogTrkDocs.CodDoc = "HPK" AND LogTrkDocs.Codigo = 'PK_INI') THEN NEXT.

      FIND FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-CodCia AND
          /*VtaCDocu.CodDiv = pCodDiv AND */
          VtaCDocu.CodPed = LogTrkDocs.CodDoc AND 
          VtaCDocu.NroPed = LogTrkDocs.NroDoc AND 
          ( VtaCDocu.Libre_c03 > '' AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3 ) NO-ERROR.

      IF NOT AVAILABLE vtacdocu THEN NEXT.      

      IF ( VtaCDocu.Libre_c03 > '' AND NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3 )
          OR ( VtaCDocu.UsrSac > '' ) THEN DO:

          IF NUM-ENTRIES(VtaCDocu.Libre_c03,'|') >= 3 THEN x-UsrSac = ENTRY(3,VtaCDocu.Libre_c03,'|').
          ELSE x-UsrSac = VtaCDocu.UsrSac.

          CREATE t-report-2.
          ASSIGN 
              t-report-2.Llave-C = "PICADOR"
              t-report-2.campo-c[1] = x-UsrSac
              t-report-2.campo-c[3] = VtaCDocu.CodPed 
              t-report-2.campo-c[4] = VtaCDocu.NroPed
              t-report-2.campo-d[1] = LogTrkDocs.Fecha
              t-report-2.campo-c[5] = SUBSTRING(ENTRY(2, STRING(LogTrkDocs.Fecha), ' '),1,5)
              t-report-2.Campo-F[1] = VtaCDocu.Items
              t-report-2.Campo-F[2] = VtaCDocu.Peso
              t-report-2.Campo-F[3] = VtaCDocu.Volumen
              t-report-2.Campo-c[6] = 'PK_INI'
              t-report-2.Campo-L[1] = VtaCDocu.EmpaqEspec
              .
      END.
  END.
  /* ************************************************************************************************** */
  /* ************************************************************************************************** */
  /* Buscamos su nombre */
  /* ************************************************************************************************** */
  FOR EACH t-report-2 WHERE TRUE <> (t-report-2.campo-c[2] > ''):
      RUN gn/nombre-personal (s-CodCia, t-report-2.campo-c[1], OUTPUT pNombre).
      IF pOrigen <> 'ERROR' THEN t-report-2.campo-c[2] = pNombre.
  END.

  /* ************************************************************************************************** */
  /* Buscamos su nombre */
  /* ************************************************************************************************** */
/*   DEF VAR pNombre AS CHAR NO-UNDO. */
/*   DEF VAR pOrigen AS CHAR NO-UNDO. */

  FOR EACH t-report-2:
      RUN logis/p-busca-por-dni ( INPUT t-report-2.campo-c[1],
                                  OUTPUT pNombre,
                                  OUTPUT pOrigen).
      IF pOrigen <> 'ERROR' THEN t-report-2.campo-c[2] = pNombre.
  END.
  /* ************************************************************************************************** */
  /* Bultos */
  /* ************************************************************************************************** */
  DEF VAR x-col-bultos AS INTE NO-UNDO.
  DEF VAR x-coddoc-nrodoc AS CHAR NO-UNDO.

  FOR EACH t-report-2:
      x-col-bultos = 0.
      x-coddoc-nrodoc = t-report-2.campo-c[3] + "-" + t-report-2.campo-c[4].
      FOR EACH ControlOD WHERE ControlOD.codcia = s-codcia AND 
          controlOD.nroetq BEGINS x-coddoc-nrodoc NO-LOCK:
          x-col-bultos =  x-col-bultos + 1.
      END.
      t-report-2.campo-i[1] = x-col-bultos.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


