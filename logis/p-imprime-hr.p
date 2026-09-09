&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER FACTURA FOR CcbCDocu.
DEFINE TEMP-TABLE t-CcbCDocu NO-UNDO LIKE CcbCDocu.
DEFINE BUFFER x-ccbcdocu FOR CcbCDocu.



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

DEF INPUT PARAMETER pRowid AS ROWID.

DEF VAR cResponsable AS CHAR.
DEF VAR cAyudante AS CHAR.
DEF VAR cChofer AS CHAR.

FIND di-rutac WHERE ROWID(di-rutac) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE di-rutac THEN RETURN.

/* RESPONSABLE Y AYUDANTES */
DEF VAR FILL-IN-Responsable AS CHAR NO-UNDO.
DEF VAR FILL-IN-Ayudante-1 AS CHAR NO-UNDO.
DEF VAR FILL-IN-Ayudante-2 AS CHAR NO-UNDO.
DEF VAR FILL-IN-Ayudante-3 AS CHAR NO-UNDO.
DEF VAR FILL-IN-Ayudante-4 AS CHAR NO-UNDO.
DEF VAR FILL-IN-Ayudante-5 AS CHAR NO-UNDO.
DEF VAR FILL-IN-Ayudante-6 AS CHAR NO-UNDO.
DEF VAR FILL-IN-Ayudante-7 AS CHAR NO-UNDO.

DEF VAR pNombre AS CHAR NO-UNDO.
DEF VAR pOrigen AS CHAR NO-UNDO.

pNombre = ''.
RUN logis/p-busca-por-dni ( INPUT DI-RutaC.responsable,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).
IF pOrigen <> 'ERROR' THEN ASSIGN FILL-IN-Responsable = pNombre cResponsable = pNombre.
pNombre = ''.
RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-1,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).
IF pOrigen <> 'ERROR' THEN ASSIGN FILL-IN-Ayudante-1 = pNombre cAyudante = pNombre.
pNombre = ''.
RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-2,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).
IF pOrigen <> 'ERROR' THEN FILL-IN-Ayudante-2 = pNombre.
pNombre = ''.
RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-3,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).
IF pOrigen <> 'ERROR' THEN FILL-IN-Ayudante-3 = pNombre.
pNombre = ''.
RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-4,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).
IF pOrigen <> 'ERROR' THEN FILL-IN-Ayudante-4 = pNombre.
pNombre = ''.
RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-5,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).
IF pOrigen <> 'ERROR' THEN FILL-IN-Ayudante-5 = pNombre.
pNombre = ''.
RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-6,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).
IF pOrigen <> 'ERROR' THEN FILL-IN-Ayudante-6 = pNombre.
pNombre = ''.
RUN logis/p-busca-por-dni ( INPUT DI-RutaC.ayudante-7,
                            OUTPUT pNombre,
                            OUTPUT pOrigen).
IF pOrigen <> 'ERROR' THEN FILL-IN-Ayudante-7 = pNombre.


cChofer = "".
FIND FIRST vtatabla WHERE vtatabla.codcia = Di-RutaC.codcia 
    AND vtatabla.tabla = 'BREVETE' 
    AND vtatabla.llave_c1 = DI-RutaC.libre_c01 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN cChofer = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.

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
      TABLE: FACTURA B "?" ? INTEGRAL CcbCDocu
      TABLE: t-CcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: x-ccbcdocu B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.54
         WIDTH              = 59.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-nomcia AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR s-task-no AS INT.

RUN Carga-Reporte.


DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "logis/rblogis.prl".
RB-REPORT-NAME = "Hoja de Ruta".
RB-INCLUDE-RECORDS = "O".
RB-FILTER = "w-report.task-no = " + STRING(s-task-no).

/* Datos de Impresión */
DEF VAR cGen AS CHAR NO-UNDO.
DEF VAR cCerr AS CHAR NO-UNDO.
DEF VAR cImp AS CHAR NO-UNDO.

FIND FIRST LogTabla WHERE logtabla.codcia = s-codcia AND
    logtabla.Evento = "WRITE" AND
    logtabla.Tabla = "DI-RUTAC" AND
    logtabla.ValorLlave = di-rutac.coddiv + '|' + di-rutac.coddoc + '|' + di-rutac.nrodoc
    NO-LOCK NO-ERROR.
IF AVAILABLE LogTabla THEN cGen = logtabla.Usuario.
cCerr = DI-RutaC.UsrCierre.
cImp = s-User-Id.

DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR cHostName = ? OR cNetworkProto = ? OR cPortNumber = ?) THEN DO:

    DEFINE VAR x-rb-user AS CHAR.
    DEFINE VAR x-rb-pass AS CHAR.

    RUN lib/RB_credenciales(OUTPUT x-rb-user, OUTPUT x-rb-pass).

    IF x-rb-user = "**NOUSER**" THEN DO:
        MESSAGE "No se pudieron ubicar las credenciales para" SKIP
                "la conexion del REPORTBUILDER" SKIP
                "--------------------------------------------" SKIP
                "Comunicarse con el area de sistemas - desarrollo"
            VIEW-AS ALERT-BOX INFORMATION.

        RETURN "ADM-ERROR".
    END.

   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter +
       "-U " + x-rb-user  + cDelimeter + cDelimeter +
       "-P " + x-rb-pass + cDelimeter + cDelimeter.

        /*
       "-U usrddigger"  + cDelimeter + cDelimeter +
       "-P udd1456" + cDelimeter + cDelimeter.
       */

   IF cOtherParams > '' THEN cNewConnString = cNewConnString + cOtherParams + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

/* Pies de página */
RB-OTHER-PARAMETERS = "cGen=" + cGen + 
    "~ncCerr=" + cCerr +
    "~ncImp=" + cImp + 
    "~ns-nomcia=" + s-nomcia +
    "~ncResponsable=" + cResponsable + 
    "~ncAyudante=" + cAyudante + 
    "~ncChofer=" + cChofer.

RUN lib/_imprime2 (INPUT RB-REPORT-LIBRARY,
                   INPUT RB-REPORT-NAME,
                   INPUT RB-INCLUDE-RECORDS,
                   INPUT RB-FILTER,
                   INPUT RB-OTHER-PARAMETERS).
 
RUN Borra-Reporte.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Borra-Reporte) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Reporte Procedure 
PROCEDURE Borra-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
      DELETE w-report.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Reporte) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte Procedure 
PROCEDURE Carga-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-codfac AS CHAR.
  DEFINE VAR x-nrofac AS CHAR.
  DEFINE VAR x-Cancelado AS CHAR NO-UNDO.
  DEFINE VAR x-DeliveryGroup AS CHAR.
  DEFINE VAR x-InvoiCustomerGroup AS CHAR.

  DEFINE VAR x-filer AS INT NO-UNDO.
  DEFINE VAR f-Bultos AS INT NO-UNDO.
  DEFINE VAR x-Bultos AS INT NO-UNDO.
  DEFINE VAR x-Clientes AS INT NO-UNDO.

  DEFINE VAR hProc AS HANDLE NO-UNDO.           /* Handle Libreria */
  RUN logis\logis-librerias.p PERSISTENT SET hProc.

  /* *************************************************************************************** */
  /* Guias de Remisión POR VENTAS */
  /* *************************************************************************************** */
  DEF VAR x-Graba-Bultos AS LOG NO-UNDO.
  s-Task-no = 0.
  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
      AND CcbCDocu.CodDoc = DI-RutaD.CodRef       /* G/R */
      AND CcbCDocu.NroDoc = DI-RutaD.NroRef
      /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP
      FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
        AND FACTURA.coddoc = Ccbcdocu.codref
        AND FACTURA.nrodoc = Ccbcdocu.nroref,
      FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo
      */
      BREAK BY Ccbcdocu.NomCli BY Ccbcdocu.nroPed BY Ccbcdocu.Libre_c02 BY Ccbcdocu.NroDoc:
      IF FIRST-OF(Ccbcdocu.NomCli) OR FIRST-OF(Ccbcdocu.NroPed) OR FIRST-OF(Ccbcdocu.Libre_c02)
          THEN x-Graba-Bultos = YES.
      IF FIRST-OF(Ccbcdocu.NomCli) THEN x-Clientes = x-Clientes + 1.
      /* ********************************************************************************* */
      /* Definimos la G/R válidas */
      /* ********************************************************************************* */
      x-codfac = "".
      x-nrofac = "".
      x-Cancelado = ''.
      EMPTY TEMP-TABLE t-ccbcdocu.
      RUN Grupo-reparto IN hProc (INPUT ccbcdocu.libre_c01, 
                                  INPUT ccbcdocu.libre_c02,     /* O/D */
                                  OUTPUT x-DeliveryGroup, 
                                  OUTPUT x-InvoiCustomerGroup).             
      IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:        
          FIND FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
              AND FACTURA.coddoc = Ccbcdocu.codref
              AND FACTURA.nrodoc = Ccbcdocu.nroref NO-ERROR.
          IF NOT AVAILABLE FACTURA THEN NEXT.
          FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo NO-ERROR.
          IF NOT AVAILABLE gn-convt THEN NEXT.
          ASSIGN
              x-codfac = FACTURA.coddoc
              x-nrofac = FACTURA.nrodoc
              x-cancelado = (IF FACTURA.FlgEst = "C" THEN "CANCELADO" ELSE "").
          CREATE t-ccbcdocu.
          BUFFER-COPY ccbcdocu TO t-ccbcdocu.
      END.
      ELSE DO:
          /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP */
          /* No esta facturado las G/R */
          /* Todas las FAIS del grupos de reparto */
          x-filer = 0.
          FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
              x-ccbcdocu.coddoc = 'FAI' AND 
              x-ccbcdocu.codref = ccbcdocu.coddoc AND /* G/R */
              x-ccbcdocu.nroref = ccbcdocu.nrodoc AND
              x-ccbcdocu.flgest <> 'A' NO-LOCK:
              FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = x-ccbcdocu.fmapgo NO-ERROR.
              IF NOT AVAILABLE gn-convt THEN NEXT.
              x-filer = x-filer + 1.
              CREATE t-ccbcdocu.
              BUFFER-COPY x-ccbcdocu TO t-ccbcdocu.
          END.
      END.
      /* ********************************************************************************* */
      /* ********************************************************************************* */
      FOR EACH t-ccbcdocu NO-LOCK,
          FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = t-ccbcdocu.codcia 
          AND Faccpedi.coddoc = t-ccbcdocu.libre_c01
          AND Faccpedi.nroped = t-ccbcdocu.libre_c02
          BREAK BY t-Ccbcdocu.NomCli BY t-Ccbcdocu.nroPed BY t-Ccbcdocu.Libre_c02 BY t-Ccbcdocu.NroDoc:
          IF s-Task-No = 0 THEN REPEAT:
              s-Task-No = RANDOM(1,999999).
              IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-Task-No NO-LOCK) THEN LEAVE.
          END.
          CREATE w-report.
          ASSIGN
              w-report.task-no = s-Task-No
              w-report.Llave-F = 9999
              w-report.Campo-i[30] = 1.     /* O/D */
          /* BULTOS */
          IF x-Graba-Bultos = YES THEN DO:
              RUN logis/p-numero-de-bultos (INPUT FacCPedi.DivDes,
                                            INPUT FacCPedi.CodDoc,
                                            INPUT FacCPedi.NroPed,
                                            OUTPUT f-Bultos).
              w-report.Campo-I[5] = f-Bultos.
              x-Graba-Bultos = NO.
          END.
          FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = t-ccbcdocu.codcli NO-LOCK NO-ERROR.
          IF AVAILABLE gn-clie THEN DO:
              FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
                  AND VtaUbiDiv.CodDiv = Di-RutaC.coddiv
                  AND VtaUbiDiv.CodDept = gn-clie.CodDept 
                  AND VtaUbiDiv.CodProv = gn-clie.CodProv 
                  AND VtaUbiDiv.CodDist = gn-clie.CodDist
                  NO-LOCK NO-ERROR.
              IF AVAILABLE VtaUbiDiv THEN w-report.Llave-F = VtaUbiDiv.Libre_d01.
          END.
          ASSIGN
              w-report.Llave-I = Di-RutaC.CodCia
              w-report.Llave-C = Di-RutaC.CodDiv
              w-report.Campo-C[1] = Di-RutaC.CodDoc
              w-report.Campo-C[2] = Di-RutaC.NroDoc.
          ASSIGN
              w-report.Campo-C[3] = t-Ccbcdocu.NomCli
              w-report.Campo-C[25]= t-Ccbcdocu.CodPed
              w-report.Campo-C[4] = t-Ccbcdocu.NroPed         /* PED */
              w-report.Campo-C[26]= t-Ccbcdocu.Libre_c01
              w-report.Campo-C[5] = t-Ccbcdocu.Libre_c02.     /* O/D */
          /* AYUDANTES */
          w-report.Campo-C[6] = FILL-IN-Responsable.
          w-report.Campo-C[7] = FILL-IN-Ayudante-1.
          w-report.Campo-C[8] = FILL-IN-Ayudante-2.
          w-report.Campo-C[9] = FILL-IN-Ayudante-3.
          w-report.Campo-C[10] = FILL-IN-Ayudante-4.
          w-report.Campo-C[11] = FILL-IN-Ayudante-5.
          w-report.Campo-C[12] = FILL-IN-Ayudante-6.
          w-report.Campo-C[13] = FILL-IN-Ayudante-7.
          /* DETALLE DI-RUTAD */
          IF t-Ccbcdocu.coddoc = 'G/R' THEN DO:
              ASSIGN
                  w-report.Campo-C[20] = t-Ccbcdocu.coddoc
                  w-report.Campo-C[21] = t-Ccbcdocu.nrodoc
                  w-report.Campo-C[22] = x-codfac   /*FACTURA.coddoc*/
                  w-report.Campo-C[23] = x-nrofac + " " + x-Cancelado  /*FACTURA.nrodoc*/
                  w-report.Campo-C[24] = gn-ConVt.Nombr
                  .
          END.
          ELSE DO:
              ASSIGN
                  w-report.Campo-C[20] = t-Ccbcdocu.coddoc      /* FAI */
                  w-report.Campo-C[21] = t-Ccbcdocu.nrodoc
                  w-report.Campo-C[22] = t-Ccbcdocu.codref   /*FACTURA.coddoc*/     /* G/R */
                  w-report.Campo-C[23] = t-Ccbcdocu.nroref   /*FACTURA.nrodoc*/
                  w-report.Campo-C[24] = gn-ConVt.Nombr.
          END.
          /* PESO y VOLUMEN */
          /* 27/02/2023 Datos acumulados por el trigger */
          ASSIGN
              w-report.Campo-F[3] = w-report.Campo-F[3] + t-Ccbcdocu.Libre_d01
              w-report.Campo-F[4] = w-report.Campo-F[4] + t-Ccbcdocu.Libre_d02.
      END.
  END.
  DELETE PROCEDURE hProc.                       /* Release Libreria */
  /* *************************************************************************************** */
  /* GIAS DE REMISION POR TRANSFERENCIA */
  /* *************************************************************************************** */
  FOR EACH Di-RutaG OF Di-RutaC NO-LOCK,
      FIRST Almcmov WHERE Almcmov.CodCia = Di-RutaG.CodCia
        AND Almcmov.CodAlm = Di-RutaG.CodAlm
        AND Almcmov.TipMov = Di-RutaG.Tipmov
        AND Almcmov.CodMov = Di-RutaG.Codmov
        AND Almcmov.NroSer = Di-RutaG.serref
        AND Almcmov.NroDoc = Di-RutaG.nroref,
      FIRST Almacen NO-LOCK WHERE Almacen.CodCia = Almcmov.CodCia
        AND Almacen.CodAlm = Almcmov.AlmDes,
      FIRST gn-divi NO-LOCK WHERE gn-divi.CodCia = Almacen.CodCia 
        AND gn-divi.CodDiv = Almacen.CodDiv
      BREAK BY Almacen.Descripcion BY Almcmov.CodRef BY Almcmov.NroRef
        BY STRING(Almcmov.NroSer, '999') + STRING(Almcmov.NroDoc, '999999999'):
      IF FIRST-OF(Almacen.Descripcion) THEN x-Clientes = x-Clientes + 1.
      IF s-Task-No = 0 THEN REPEAT:
          s-Task-No = RANDOM(1,999999).
          IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-Task-No NO-LOCK) THEN LEAVE.
      END.
      CREATE w-report.
      ASSIGN
          w-report.task-no = s-Task-No
          w-report.Llave-F = 9999
          w-report.Campo-i[30] = 2.     /* OTR */
      /* ************************************************************************************** */
      /* CABECERA: DI-RUTAC */
      /* ************************************************************************************** */
      FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
          AND VtaUbiDiv.CodDiv = Di-RutaC.coddiv
          AND VtaUbiDiv.CodDept = gn-divi.Campo-Char[3] 
          AND VtaUbiDiv.CodProv = gn-divi.Campo-Char[4] 
          AND VtaUbiDiv.CodDist = gn-divi.Campo-Char[5] 
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaUbiDiv THEN w-report.Llave-F = VtaUbiDiv.Libre_d01.
      ASSIGN
          w-report.Llave-I = Di-RutaC.CodCia
          w-report.Llave-C = Di-RutaC.CodDiv
          w-report.Campo-C[1] = Di-RutaC.CodDoc
          w-report.Campo-C[2] = Di-RutaC.NroDoc.
      ASSIGN
          w-report.Campo-C[3] = Almacen.Descripcion.
      FIND FIRST Faccpedi WHERE FacCPedi.CodCia = Almcmov.CodCia 
          AND FacCPedi.CodDoc = Almcmov.CodRef
          AND FacCPedi.NroPed = Almcmov.NroRef NO-LOCK NO-ERROR.
      IF AVAILABLE Faccpedi THEN
          ASSIGN
          w-report.Campo-C[25]= Faccpedi.CodRef
          w-report.Campo-C[4] = Faccpedi.NroRef         /* R/A */
          w-report.Campo-C[26]= Faccpedi.CodDoc
          w-report.Campo-C[5] = Faccpedi.NroPed.        /* OTR */
      ASSIGN
          w-report.Campo-C[6] = FILL-IN-Responsable
          w-report.Campo-C[7] = FILL-IN-Ayudante-1
          w-report.Campo-C[8] = FILL-IN-Ayudante-2
          w-report.Campo-C[9] = FILL-IN-Ayudante-3
          w-report.Campo-C[10] = FILL-IN-Ayudante-4
          w-report.Campo-C[11] = FILL-IN-Ayudante-5
          w-report.Campo-C[12] = FILL-IN-Ayudante-6 
          w-report.Campo-C[13] = FILL-IN-Ayudante-7.
      /* DESTINO FINAL */
      ASSIGN
          w-report.Campo-C[28] = Almacen.DirAlm.
      /* Bultos */
      IF FIRST-OF(Almacen.Descripcion) OR FIRST-OF(Almcmov.NroRef) THEN DO:
          RUN logis/p-numero-de-bultos (INPUT Di-RutaC.CodDiv,
                                        INPUT Almcmov.CodRef ,
                                        INPUT Almcmov.NroRef,
                                        OUTPUT f-Bultos).
          w-report.Campo-I[5] = f-Bultos.
      END.
      /* ************************************************************************************** */
      /* DETALLE Di-RutaG */
      /* ************************************************************************************** */
      ASSIGN
          w-report.Campo-C[20] = "G/R"
          w-report.Campo-C[21] = STRING(Almcmov.NroSer, '999') + STRING(Almcmov.NroDoc, '999999999')
          w-report.Campo-C[22] = ''
          w-report.Campo-C[23] = ''
          w-report.Campo-C[24] = ''.
      /* 27/02/2023 Datos acumulados por el trigger */
      ASSIGN
          w-report.Campo-F[3] = w-report.Campo-F[3] + Almcmov.Libre_d01
          w-report.Campo-F[4] = w-report.Campo-F[4] + Almcmov.Libre_d02.
  END.
  /* *************************************************************************************** */
  /* ITINIRANTES */
  /* *************************************************************************************** */
  FOR EACH Di-RutaDG OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
        AND CcbCDocu.CodDoc = Di-RutaDG.CodRef       /* G/R */
        AND CcbCDocu.NroDoc = Di-RutaDG.NroRef
      BREAK BY Ccbcdocu.NomCli BY Ccbcdocu.nroPed BY Ccbcdocu.Libre_c02 BY Ccbcdocu.nrodoc:
      IF FIRST-OF(Ccbcdocu.NomCli) THEN x-Clientes = x-Clientes + 1.
      IF s-Task-No = 0 THEN REPEAT:
          s-Task-No = RANDOM(1,999999).
          IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-Task-No NO-LOCK) THEN LEAVE.
      END.
      CREATE w-report.
      ASSIGN
          w-report.task-no = s-Task-No
          w-report.Llave-F = 9999
          w-report.Campo-i[30] = 3.     /* G/R ITINERANTE */
      /* ************************************************************************************** */
      /* CABECERA: DI-RUTAC */
      /* ************************************************************************************** */
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = ccbcdocu.codcli
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie THEN DO:
          FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
              AND VtaUbiDiv.CodDiv = Di-RutaC.coddiv
              AND VtaUbiDiv.CodDept = gn-clie.CodDept 
              AND VtaUbiDiv.CodProv = gn-clie.CodProv 
              AND VtaUbiDiv.CodDist = gn-clie.CodDist
              NO-LOCK NO-ERROR.
          IF AVAILABLE VtaUbiDiv THEN w-report.Llave-F = VtaUbiDiv.Libre_d01.
      END.
      ASSIGN
          w-report.Llave-I = Di-RutaC.CodCia
          w-report.Llave-C = Di-RutaC.CodDiv
          w-report.Campo-C[1] = Di-RutaC.CodDoc
          w-report.Campo-C[2] = Di-RutaC.NroDoc.
      ASSIGN
          w-report.Campo-C[3] = Ccbcdocu.NomCli
          w-report.Campo-C[25]= Ccbcdocu.CodPed
          w-report.Campo-C[4] = Ccbcdocu.NroPed         /* PED */
          w-report.Campo-C[26]= Ccbcdocu.Libre_c01
          w-report.Campo-C[5] = Ccbcdocu.Libre_c02.     /* O/D */
      ASSIGN
          w-report.Campo-C[6] = FILL-IN-Responsable
          w-report.Campo-C[7] = FILL-IN-Ayudante-1
          w-report.Campo-C[8] = FILL-IN-Ayudante-2
          w-report.Campo-C[9] = FILL-IN-Ayudante-3
          w-report.Campo-C[10] = FILL-IN-Ayudante-4
          w-report.Campo-C[11] = FILL-IN-Ayudante-5
          w-report.Campo-C[12] = FILL-IN-Ayudante-6
          w-report.Campo-C[13] = FILL-IN-Ayudante-7.
      /* Bultos */
      IF FIRST-OF(Ccbcdocu.NomCli) OR FIRST-OF(Ccbcdocu.NroPed) OR 
          FIRST-OF(Ccbcdocu.Libre_c02) THEN DO:
          RUN logis/p-numero-de-bultos (INPUT Di-RutaC.CodDiv,
                                        INPUT Ccbcdocu.Libre_c01,
                                        INPUT Ccbcdocu.Libre_c02,
                                        OUTPUT f-Bultos).
          w-report.Campo-I[5] = f-Bultos.
      END.
      /* ************************************************************************************** */
      /* DETALLE Di-RutaDG */
      /* ************************************************************************************** */
      ASSIGN
          w-report.Campo-C[20] = Ccbcdocu.coddoc
          w-report.Campo-C[21] = Ccbcdocu.nrodoc.
      /* 27/02/2023 Datos acumulados por el trigger */
/*       ASSIGN                                                              */
/*           w-report.Campo-F[3] = w-report.Campo-F[3] + Ccbcdocu.Libre_d01  */
/*           w-report.Campo-F[4] = w-report.Campo-F[4] + Ccbcdocu.Libre_d02. */
      /* 31/05/2023: Buscamos el GRE_HEADER */
      FIND gre_header WHERE gre_header.m_divorigen = Di-RutaC.coddiv AND
          gre_header.m_coddoc = "" AND      /* Guia "itinerante" en blanco */
          gre_header.SerieGuia = INTEGER(SUBSTRING(Di-RutaDG.NroRef,1,3)) AND
          gre_header.NumeroGuia = INTEGER(SUBSTRING(Di-RutaDG.NroRef,4)) AND
          gre_header.m_rspta_sunat = "ACEPTADO POR SUNAT"
          NO-LOCK NO-ERROR.
      IF AVAILABLE gre_header THEN w-report.Campo-F[3] = w-report.Campo-F[3] + gre_header.pesoBrutoTotalBienes.
  END.
  /* *************************************************************************************** */
  /* ESCALA y DESTINO FINAL */
  /* *************************************************************************************** */
  DEF VAR x-PuntoLlegada AS CHAR NO-UNDO.
  /* Sintaxis: < Nombre >|< Dirección > */
  FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
      FIND Di-RutaGRI WHERE Di-RutaGRI.CodCia = Di-RutaC.CodCia AND
          Di-RutaGRI.CodDiv = Di-RutaC.CodDiv AND
          Di-RutaGRI.CodDoc = Di-RutaC.CodDoc AND
          Di-RutaGRI.NroDoc = Di-RutaC.NroDoc AND 
          Di-RutaGRI.CodRef = w-report.Campo-C[25] AND
          Di-RutaGRI.NroRef = w-report.Campo-C[4]
          NO-LOCK NO-ERROR.
      IF AVAILABLE Di-RutaGRI THEN
          ASSIGN
          w-report.Campo-C[27] = Di-RutaGRI.Escala
          w-report.Campo-C[28] = Di-RutaGRI.Destino_Final
          w-report.Campo-C[29] = Di-RutaGRI.Contacto + " HORA: " + Di-RutaGRI.Hora
          w-report.Campo-C[30] = Di-RutaGRI.Referencia.
  END.
  /* *************************************************************************************** */
  /* Acumulados finales */
  /* *************************************************************************************** */
  DEF VAR x-Tot-Bultos AS DEC NO-UNDO.
  DEF VAR x-Tot-Volumen AS DEC NO-UNDO.
  DEF VAR x-Tot-Peso AS DEC NO-UNDO.

  FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-Task-No:
      ASSIGN
          x-Tot-Bultos = x-Tot-Bultos + w-report.Campo-I[5]
          x-Tot-Volumen = x-Tot-Volumen + w-report.Campo-F[4]
          x-Tot-Peso = x-Tot-Peso + w-report.Campo-F[3].
  END.
  FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-Task-No:
      w-report.Campo-F[1] = x-Tot-Peso.
      w-report.Campo-F[2] = x-Tot-Volumen.
      w-report.Campo-i[2] = x-Tot-Bultos.
      w-report.Campo-i[1] = x-Clientes.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE temporal Procedure 
PROCEDURE temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
  /* *************************************************************************************** */
  /* Guias de Remisión POR VENTAS */
  /* *************************************************************************************** */
  s-Task-no = 0.
  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
      AND CcbCDocu.CodDoc = DI-RutaD.CodRef       /* G/R */
      AND CcbCDocu.NroDoc = DI-RutaD.NroRef
      /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP
      FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
        AND FACTURA.coddoc = Ccbcdocu.codref
        AND FACTURA.nrodoc = Ccbcdocu.nroref,
      FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo
      */
      BREAK BY Ccbcdocu.NomCli BY Ccbcdocu.nroPed BY Ccbcdocu.Libre_c02:
      IF FIRST-OF(Ccbcdocu.NomCli) OR FIRST-OF(Ccbcdocu.NroPed) OR FIRST-OF(Ccbcdocu.Libre_c02)
          THEN EMPTY TEMP-TABLE tt-Ccbcdocu.
      /* ********************************************************************************* */
      /* Definimos la G/R válidas */
      /* ********************************************************************************* */
      x-codfac = "".
      x-nrofac = "".
      EMPTY TEMP-TABLE t-ccbcdocu.
      RUN Grupo-reparto IN hProc (INPUT ccbcdocu.libre_c01, 
                                  INPUT ccbcdocu.libre_c02,     /* O/D */
                                  OUTPUT x-DeliveryGroup, 
                                  OUTPUT x-InvoiCustomerGroup).             
      IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:        
          FIND FIRST FACTURA NO-LOCK WHERE FACTURA.codcia = Ccbcdocu.codcia
              AND FACTURA.coddoc = Ccbcdocu.codref
              AND FACTURA.nrodoc = Ccbcdocu.nroref NO-ERROR.
          IF NOT AVAILABLE FACTURA THEN NEXT.
          FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = FACTURA.fmapgo NO-ERROR.
          IF NOT AVAILABLE gn-convt THEN NEXT.
          ASSIGN
              x-codfac = FACTURA.coddoc
              x-nrofac = FACTURA.nrodoc.
          CREATE t-ccbcdocu.
          BUFFER-COPY ccbcdocu TO t-ccbcdocu.
          BUFFER-COPY ccbcdocu TO tt-ccbcdocu.
      END.
      ELSE DO:
          /* Ic - 02Oct2020 : G/R x grupo de reparto caso BCP */
          /* No esta facturado las G/R */
          /* Todas las FAIS del grupos de reparto */
          x-filer = 0.
          FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
              x-ccbcdocu.coddoc = 'FAI' AND 
              x-ccbcdocu.codref = ccbcdocu.coddoc AND /* G/R */
              x-ccbcdocu.nroref = ccbcdocu.nrodoc AND
              x-ccbcdocu.flgest <> 'A' NO-LOCK:
              FIND FIRST gn-convt NO-LOCK WHERE gn-ConVt.Codig = x-ccbcdocu.fmapgo NO-ERROR.
              IF NOT AVAILABLE gn-convt THEN NEXT.
              x-filer = x-filer + 1.
              CREATE t-ccbcdocu.
              BUFFER-COPY x-ccbcdocu TO t-ccbcdocu.
              BUFFER-COPY x-ccbcdocu TO tt-ccbcdocu.
          END.
      END.
      /* ********************************************************************************* */
      /* ********************************************************************************* */
      FOR EACH t-ccbcdocu NO-LOCK,
          FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = t-ccbcdocu.codcia 
          AND Faccpedi.coddoc = t-ccbcdocu.libre_c01
          AND Faccpedi.nroped = t-ccbcdocu.libre_c02
          BREAK BY t-Ccbcdocu.NomCli BY t-Ccbcdocu.nroPed BY t-Ccbcdocu.Libre_c02:
          IF s-Task-No = 0 THEN REPEAT:
              s-Task-No = RANDOM(1,999999).
              IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-Task-No NO-LOCK) THEN LEAVE.
          END.
          CREATE w-report.
          ASSIGN
              w-report.task-no = s-Task-No
              w-report.Llave-F = 9999
              w-report.Campo-i[30] = 1.     /* O/D */
/*           /* BULTOS */                                             */
/*           IF FIRST-OF(t-Ccbcdocu.NomCli)                           */
/*               OR FIRST-OF(t-Ccbcdocu.NroPed)                       */
/*               OR FIRST-OF(t-Ccbcdocu.Libre_c02)                    */
/*               THEN DO:                                             */
/*               RUN logis/p-numero-de-bultos (INPUT FacCPedi.DivDes, */
/*                                             INPUT FacCPedi.CodDoc, */
/*                                             INPUT FacCPedi.NroPed, */
/*                                             OUTPUT f-Bultos).      */
/*               w-report.Campo-I[5] = f-Bultos.                      */
/*           END.                                                     */
          FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = t-ccbcdocu.codcli NO-LOCK NO-ERROR.
          IF AVAILABLE gn-clie THEN DO:
              FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
                  AND VtaUbiDiv.CodDiv = Di-RutaC.coddiv
                  AND VtaUbiDiv.CodDept = gn-clie.CodDept 
                  AND VtaUbiDiv.CodProv = gn-clie.CodProv 
                  AND VtaUbiDiv.CodDist = gn-clie.CodDist
                  NO-LOCK NO-ERROR.
              IF AVAILABLE VtaUbiDiv THEN w-report.Llave-F = VtaUbiDiv.Libre_d01.
          END.
          ASSIGN
              w-report.Llave-I = Di-RutaC.CodCia
              w-report.Llave-C = Di-RutaC.CodDiv
              w-report.Campo-C[1] = Di-RutaC.CodDoc
              w-report.Campo-C[2] = Di-RutaC.NroDoc.
          ASSIGN
              w-report.Campo-C[3] = t-Ccbcdocu.NomCli
              w-report.Campo-C[25]= t-Ccbcdocu.CodPed
              w-report.Campo-C[4] = t-Ccbcdocu.NroPed         /* PED */
              w-report.Campo-C[26]= t-Ccbcdocu.Libre_c01
              w-report.Campo-C[5] = t-Ccbcdocu.Libre_c02.     /* O/D */
          /* AYUDANTES */
          w-report.Campo-C[6] = FILL-IN-Responsable.
          w-report.Campo-C[7] = FILL-IN-Ayudante-1.
          w-report.Campo-C[8] = FILL-IN-Ayudante-2.
          w-report.Campo-C[9] = FILL-IN-Ayudante-3.
          w-report.Campo-C[10] = FILL-IN-Ayudante-4.
          w-report.Campo-C[11] = FILL-IN-Ayudante-5.
          w-report.Campo-C[12] = FILL-IN-Ayudante-6.
          w-report.Campo-C[13] = FILL-IN-Ayudante-7.
          /* DETALLE DI-RUTAD */
          IF t-Ccbcdocu.coddoc = 'G/R' THEN DO:
              ASSIGN
                  w-report.Campo-C[20] = t-Ccbcdocu.coddoc
                  w-report.Campo-C[21] = t-Ccbcdocu.nrodoc
                  w-report.Campo-C[22] = x-codfac   /*FACTURA.coddoc*/
                  w-report.Campo-C[23] = x-nrofac   /*FACTURA.nrodoc*/
                  w-report.Campo-C[24] = gn-ConVt.Nombr.
          END.
          ELSE DO:
              ASSIGN
                  w-report.Campo-C[20] = t-Ccbcdocu.coddoc      /* FAI */
                  w-report.Campo-C[21] = t-Ccbcdocu.nrodoc
                  w-report.Campo-C[22] = t-Ccbcdocu.codref   /*FACTURA.coddoc*/     /* G/R */
                  w-report.Campo-C[23] = t-Ccbcdocu.nroref   /*FACTURA.nrodoc*/
                  w-report.Campo-C[24] = gn-ConVt.Nombr.
          END.
          /* PESO y VOLUMEN */
          FOR EACH Ccbddocu OF t-Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
              ASSIGN
                  w-report.Campo-F[3] = w-report.Campo-F[3] + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.pesmat)
                  w-report.Campo-F[4] = w-report.Campo-F[4] + (Ccbddocu.candes * Ccbddocu.factor * Almmmatg.libre_d02) / 1000000.
          END.
      END.
  END.
  DELETE PROCEDURE hProc.                       /* Release Libreria */
  
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

