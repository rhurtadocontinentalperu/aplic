&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DI-RutaC NO-UNDO LIKE DI-RutaC
       FIELD CuentaODS AS INT
       FIELD CuentaHPK AS INT
       FIELD CuentaClientes AS INT
       FIELD SumaPeso AS DEC
       FIELD SumaVolumen AS DEC
       FIELD SumaImporte AS DEC
       FIELD CuentaItems AS INT
       FIELD Bultos AS INT.
DEFINE TEMP-TABLE T-VtaCDocu NO-UNDO LIKE VtaCDocu
       FIELD SumaPeso AS DEC
       FIELD SUmaVolumen AS DEC
       FIELD CuentaItems as INT
       FIELD SumaImporte AS DEC
       FIELD Estado AS CHAR
       FIELD Bultos AS INT
       .



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
DEF NEW SHARED VAR s-CodCia AS INTE INIT 001.
DEF NEW SHARED VAR cl-CodCia AS INTE INIT 000.
DEF NEW SHARED VAR pv-CodCia AS INTE INIT 000.
DEF NEW SHARED VAR s-CodDiv AS CHAR INIT '00000'.

DEF VAR s-Titulo AS CHAR INIT 'SEGUIMIENTO DE PEDIDOS' NO-UNDO FORMAT 'x(50)'.
DEF VAR pDias AS INTE INIT 90 NO-UNDO.
DEF VAR pArchivo AS CHAR NO-UNDO.
DEF VAR pMinutos AS INTE NO-UNDO.

ASSIGN
    pArchivo = "d:\tmp\spprueba.txt".

/* Capturamos parámetros de la tabla de configuraciones */
FIND TabGener WHERE TabGener.CodCia = s-codcia AND
    TabGener.Clave = "CFG_TXT_SP" NO-LOCK NO-ERROR.
IF AVAILABLE TabGener THEN DO:
    s-CodDiv    = TabGener.Libre_c01.
    pDias       = TabGener.Libre_d01.
    pArchivo    = TabGener.Libre_c02.
    pMinutos    = TabGener.Libre_d02.
    IF pMinutos = 0 THEN QUIT.

END.

DEF TEMP-TABLE DETALLE
    FIELD NroDoc LIKE DI-RutaC.NroDoc LABEL 'PreHoja'
    FIELD FchDoc AS DATE FORMAT '99/99/9999' LABEL 'Fecha'
    FIELD Observ AS CHAR FORMAT 'x(60)' LABEL 'Descripcion'
    FIELD CuentaODS AS INT LABEL 'O/D'
    FIELD CuentaClientes AS INT LABEL 'Nro Clientes'
    FIELD Bultos AS INT LABEL 'Bultos'
    FIELD NroPed AS CHAR FORMAT 'x(12)' LABEL 'HPK'
    FIELD FchPed AS DATE FORMAT '99/99/9999' LABEL 'Fecha'
    FIELD Hora   AS CHAR FORMAT 'x(8)' LABEL 'Hora'
    FIELD CodTer AS CHAR FORMAT 'x(20)' LABEL 'Tipo'
    FIELD CodRef AS CHAR FORMAT 'x(3)' LABEL 'Codigo'
    FIELD NroRef AS CHAR FORMAT 'x(15)' LABEL 'Número'
    FIELD FchRef AS DATE FORMAT '99/99/9999' LABEL 'Fecha'
    FIELD HorRef AS CHAR FORMAT 'x(10)' LABEL 'Hora'
    FIELD Departamento AS CHAR FORMAT 'x(30)' LABEL 'Departamento'
    FIELD Distrito AS CHAR FORMAT 'x(30)' LABEL 'Distrito'
    FIELD CuentaItems AS INT LABEL 'Items'
    FIELD SumaPeso AS DEC LABEL 'Peso'
    FIELD SumaVolumen AS DEC LABEL 'Volumen'
    FIELD Estado AS CHAR FORMAT 'x(20)' LABEL 'Estado'
    FIELD BultosDetalle AS INT LABEL 'Bultos'
    FIELD NomCli AS CHAR FORMAT 'x(60)' LABEL 'Nombre'
    FIELD FchEnt AS DATE FORMAT '99/99/9999' LABEL 'Fecha Entrega'
    FIELD UsrSac AS CHAR FORMAT 'x(15)' LABEL 'Picador'
    FIELD NomSac AS CHAR FORMAT 'x(60)' LABEL 'Nombre'
    FIELD ZonaPickeo AS CHAR FORMAT 'x(8)' LABEL 'Zona Pickeo'
    FIELD CodAlm AS CHAR FORMAT 'x(8)' LABEL 'Almacen'
    FIELD fFinPicking AS CHAR FORMAT 'x(10)' LABEL 'Fecha Picking Completo'
    FIELD hFinPicking AS CHAR FORMAT 'x(10)' LABEL 'Hora Picking Completo'
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fDepartamento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDepartamento Procedure 
FUNCTION fDepartamento RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fDistrito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistrito Procedure 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fEstado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado Procedure 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DI-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
      ADDITIONAL-FIELDS:
          FIELD CuentaODS AS INT
          FIELD CuentaHPK AS INT
          FIELD CuentaClientes AS INT
          FIELD SumaPeso AS DEC
          FIELD SumaVolumen AS DEC
          FIELD SumaImporte AS DEC
          FIELD CuentaItems AS INT
          FIELD Bultos AS INT
      END-FIELDS.
      TABLE: T-VtaCDocu T "?" NO-UNDO INTEGRAL VtaCDocu
      ADDITIONAL-FIELDS:
          FIELD SumaPeso AS DEC
          FIELD SUmaVolumen AS DEC
          FIELD CuentaItems as INT
          FIELD SumaImporte AS DEC
          FIELD Estado AS CHAR
          FIELD Bultos AS INT
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR x-Mensaje AS CHAR VIEW-AS EDITOR INNER-CHARS 50 INNER-LINES 5.
DEFINE FRAME f-Mensaje
    SKIP(1)
    x-Mensaje AT 5 BGCOLOR 11 FGCOLOR 0 FONT 1 SKIP(1) 
    "Presione F10 para cerrar esta ventana..." FGCOLOR 15 SKIP
    "Presione F12 para cerrar el programa...." FGCOLOR 15 SKIP
    WITH AT COLUMN 50 ROW 1 NO-LABELS NO-HELP OVERLAY
        TITLE s-Titulo
        WIDTH 60
        VIEW-AS DIALOG-BOX BGCOLOR 1.

/* loop buscando informacion nueva */
/* Tiempo remanente antes que termina la pausa */
DEFINE VARIABLE timeRemain AS INT64 NO-UNDO.
/* Cantidad de milisegundos antes que termina la pausa */
DEFINE VARIABLE endTime    AS INT64 NO-UNDO.
/* Variable que guarda la hora actual */
DEFINE VARIABLE currTime   AS INT64 NO-UNDO.

PRINCIPAL:
REPEAT:
    RUN Texto.
/*     IF CAN-FIND(FIRST DETALLE NO-LOCK) THEN DO:       */
/*         /* AVISO AL USUARIO */                        */
/*         ASSIGN                                        */
/*             x-Mensaje = 'Se generó el archivo texto'. */
/*         DISPLAY x-Mensaje WITH FRAME f-Mensaje.       */
/*         READKEY.                                      */
/*         REPEAT WHILE LASTKEY <> KEYCODE("F10"):       */
/*             READKEY.                                  */
/*             IF LASTKEY = KEYCODE("F12")               */
/*             THEN LEAVE PRINCIPAL.                     */
/*         END.                                          */
/*         HIDE FRAME f-Mensaje NO-PAUSE.                */
/*     END.                                              */
    /* Rutina que pausa el programa por n minutos */
    /* Evita que el proceso sea cancelado por un usuario con una combinación de teclas */
/*     ASSIGN                                                                                           */
/*         currTime   = MTIME                                                                           */
/*         endTime    = currTime + pMinutos * 60 * 1000    /* 5 minutos = 5 * 60 * 1000 milisegundos */ */
/*         timeRemain = (endTime - currTime) / 1000.       /* En segundos */                            */
/*     REPEAT ON ENDKEY UNDO, NEXT ON STOP UNDO, NEXT:                                                  */
/*         PAUSE timeRemain BEFORE-HIDE NO-MESSAGE.                                                     */
/*         /* PAUSE eiher ended naturally or was interrupted, recalculate the time left to be paused    */
/*         */                                                                                           */
/*         ASSIGN                                                                                       */
/*             timeRemain = (endTime - MTIME) / 1000.                                                   */
/*         /* Pause time has expired, exit */                                                           */
/*         IF timeRemain < 0 OR MTIME > endTime THEN LEAVE.                                             */
/*     END.                                                                                             */
    LEAVE PRINCIPAL.      /* El tiempo se va a controlar por Administrador de Tareas de Windows */
END.

QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Captura-Temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal Procedure 
PROCEDURE Captura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FchDoc-1 AS DATE NO-UNDO.
DEF VAR x-FchDoc-2 AS DATE NO-UNDO.
DEF VAR x-FlgEst AS CHAR INIT "P,PK,PF,PX" NO-UNDO.

ASSIGN
    x-FchDoc-1 = TODAY - pDias
    x-FchDoc-2 = TODAY.

EMPTY TEMP-TABLE T-Di-RutaC.

FOR EACH Di-RutaC NO-LOCK WHERE DI-RutaC.CodCia = s-CodCia AND 
    DI-RutaC.CodDoc = "PHR" AND 
    (DI-RutaC.FchDoc >= x-FchDoc-1 AND 
    DI-RutaC.FchDoc <= x-FchDoc-2) AND
    DI-RutaC.CodDiv = s-CodDiv :

    IF NOT LOOKUP(TRIM(DI-RutaC.FlgEst), x-FlgEst) > 0 THEN NEXT.

    /* Buscamos si tiene al menos 1 registro en el detalle */
    FIND FIRST Vtacdocu USE-INDEX Llave08 WHERE Vtacdocu.CodCia = Di-RutaC.CodCia
        AND Vtacdocu.CodOri = Di-RutaC.CodDoc
        AND Vtacdocu.NroOri = Di-RutaC.NroDoc
        AND Vtacdocu.CodDiv = Di-RutaC.CodDiv
        AND Vtacdocu.CodPed = "HPK"
        AND Vtacdocu.FlgEst <> "A"
        AND Vtacdocu.FlgSit <> "C"
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN NEXT.

    CREATE T-Di-RutaC.
    BUFFER-COPY Di-RutaC TO T-Di-RutaC.
END.

DEF VAR x-CuentaODS AS INT NO-UNDO.
DEF VAR x-CuentaHPK AS INT NO-UNDO.
DEF VAR x-CuentaClientes AS INT NO-UNDO.
DEF VAR x-SumaPeso AS DEC NO-UNDO.
DEF VAR x-SumaVolumen AS DEC NO-UNDO.
DEF VAR x-SumaImporte AS DEC NO-UNDO.
DEF VAR x-CuentaItems AS INT NO-UNDO.
DEF VAR x-Clientes AS CHAR NO-UNDO.
DEF VAR x-Bultos AS INT NO-UNDO.

FOR EACH T-Di-RutaC EXCLUSIVE-LOCK, FIRST Di-RutaC OF T-Di-RutaC NO-LOCK:
    /* ********************************************* */
    ASSIGN
        x-CuentaODS = 0
        x-CuentaHPK = 0
        x-CuentaClientes = 0
        x-SumaPeso = 0
        x-SumaVolumen = 0
        x-SumaImporte = 0
        x-CuentaItems = 0
        x-Clientes = ''
        x-Bultos = 0.

    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-Rutad.codcia AND
        Faccpedi.coddoc = Di-Rutad.codref AND
        Faccpedi.nroped = Di-Rutad.nroref:

        x-CuentaODS = x-CuentaODS + 1.
        IF TRUE <> (x-Clientes > '') THEN x-Clientes = Faccpedi.codcli.
        ELSE DO:
            IF INDEX(x-Clientes, Faccpedi.codcli) = 0 THEN DO:
                x-Clientes = x-Clientes + ',' + Faccpedi.codcli.
            END.
        END.
        FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-codcia AND
            CcbCBult.CodDiv = s-coddiv AND
            CcbCBult.CodDoc = Faccpedi.coddoc AND
            CcbCBult.NroDoc = Faccpedi.nroped :
            x-Bultos = x-Bultos + CcbCBult.Bultos.
        END.
        x-SumaImporte = x-SumaImporte + Faccpedi.ImpTot.
    END.    

    x-CuentaClientes = NUM-ENTRIES(x-Clientes).
    ASSIGN
        T-Di-RutaC.CuentaODS = x-CuentaODS
        T-Di-RutaC.CuentaHPK = x-CuentaHPK
        T-Di-RutaC.CuentaClientes = x-CuentaClientes
        T-Di-RutaC.SumaPeso = x-SumaPeso
        T-Di-RutaC.SumaVolumen = x-SumaVolumen
        T-Di-RutaC.SumaImporte = x-SumaImporte
        T-Di-RutaC.CuentaItems = x-CuentaItems
        T-Di-RutaC.Bultos = x-Bultos.
END.
FOR EACH T-Di-RutaC WHERE T-Di-RutaC.CuentaODS = 0:
    DELETE T-Di-RutaC.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Captura-Temporal-2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal-2 Procedure 
PROCEDURE Captura-Temporal-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

DEF BUFFER B-RutaC FOR DI-RutaC.
DEF BUFFER B-Vtacdocu FOR Vtacdocu.
DEF BUFFER B-Vtaddocu FOR Vtaddocu.

DEF VAR x-CuentaODS AS INT NO-UNDO.
DEF VAR x-CuentaHPK AS INT NO-UNDO.
DEF VAR x-CuentaClientes AS INT NO-UNDO.
DEF VAR x-SumaPeso AS DEC NO-UNDO.
DEF VAR x-SumaVolumen AS DEC NO-UNDO.
DEF VAR x-SumaImporte AS DEC NO-UNDO.
DEF VAR x-CuentaItems AS INT NO-UNDO.
DEF VAR x-Bultos AS INT NO-UNDO.
DEF VAR x-Clientes AS CHAR NO-UNDO.
DEF VAR x-FchEnt AS DATE NO-UNDO.
DEF VAR x-Estado AS CHAR NO-UNDO.

FIND B-RutaC WHERE ROWID(B-RutaC) = pRowid NO-LOCK.

FOR EACH B-Vtacdocu NO-LOCK WHERE B-Vtacdocu.CodCia = B-RutaC.CodCia
    AND B-Vtacdocu.CodOri = B-RutaC.CodDoc
    AND B-Vtacdocu.NroOri = B-RutaC.NroDoc
    AND B-Vtacdocu.CodDiv = B-RutaC.CodDiv
    AND B-Vtacdocu.CodPed = "HPK"
    AND B-Vtacdocu.FlgEst <> "A"
    AND B-Vtacdocu.FlgSit <> "C":
    CREATE T-Vtacdocu.
    BUFFER-COPY B-Vtacdocu TO T-Vtacdocu.
    ASSIGN
        x-CuentaODS = 0
        x-CuentaHPK = 0
        x-CuentaClientes = 0
        x-SumaPeso = 0
        x-SumaVolumen = 0
        x-SumaImporte = 0
        x-CuentaItems = 0
        x-Clientes = ''
        x-Bultos = 0
        x-FchEnt = ?.

    x-CuentaClientes = NUM-ENTRIES(x-Clientes).

    x-Estado = fEstado(B-Vtacdocu.CodPed, B-Vtacdocu.NroPed).

    FOR EACH B-VtaDDocu OF B-Vtacdocu NO-LOCK, FIRST Almmmatg OF B-VtaDDocu NO-LOCK:
        x-SumaPeso = x-SumaPeso + (B-VtaDDocu.CanPed * B-VtaDDocu.Factor * Almmmatg.PesMat).
        x-SumaVolumen = x-SumaVolumen + (B-VtaDDocu.CanPed * B-VtaDDocu.Factor * Almmmatg.Libre_d02 / 1000000).
        x-CuentaItems = x-CuentaItems + 1.
        x-SumaImporte = x-SumaImporte + B-VtaDDocu.ImpLin.
    END.
    FOR EACH Ccbcbult NO-LOCK USE-INDEX llave03 WHERE CcbCBult.CodCia = B-Vtacdocu.codcia AND
        CcbCBult.CodDoc = B-Vtacdocu.codref AND
        CcbCBult.NroDoc = B-Vtacdocu.nroref:
        x-Bultos = x-Bultos + CcbCBult.Bultos.
    END.
    FIND FIRST Faccpedi WHERE Faccpedi.codcia = B-Vtacdocu.codcia AND
        Faccpedi.coddoc = B-Vtacdocu.codref AND
        Faccpedi.nroped = B-Vtacdocu.nroref
        NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN x-FchEnt = Faccpedi.FchEnt.

    ASSIGN
        T-Vtacdocu.SumaPeso = x-SumaPeso
        T-Vtacdocu.SumaVolumen = x-SumaVolumen
        T-Vtacdocu.CuentaItems = x-CuentaItems
        T-Vtacdocu.SumaImporte = x-SumaImporte
        T-Vtacdocu.FchEnt = x-FchEnt
        T-Vtacdocu.Estado = x-Estado
        T-Vtacdocu.Bultos = x-Bultos.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Texto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto Procedure 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR pOptions AS CHAR NO-UNDO.

    DEF VAR OKpressed AS LOG.
    DEF VAR pNombre AS CHAR NO-UNDO.
    DEF VAR porigen AS CHAR NO-UNDO.

    /* pArchivo debe llevar la ruta y el nombre del archivo texto */
    
    ASSIGN
        pOptions = "FileType:TXT" + CHR(1) + ~
              "Grid:ver" + CHR(1) + ~ 
              "ExcelAlert:false" + CHR(1) + ~
              "ExcelVisible:false" + CHR(1) + ~
              "Labels:yes".


    /* Capturamos información de la cabecera y el detalle */
    EMPTY TEMP-TABLE DETALLE.
    RUN Captura-Temporal.

    FOR EACH T-DI-RutaC NO-LOCK, FIRST DI-RutaC OF T-DI-RutaC NO-LOCK:
        EMPTY TEMP-TABLE T-VtaCDocu.
        RUN Captura-Temporal-2 ( INPUT ROWID(DI-RutaC) ).

        IF NOT CAN-FIND(FIRST T-VtaCDocu WHERE T-VtaCDocu.CodCia = DI-RutaC.CodCia
                        AND T-VtaCDocu.CodOri = DI-RutaC.CodDoc
                        AND T-VtaCDocu.NroOri = DI-RutaC.NroDoc
                        AND T-VtaCDocu.CodDiv = DI-RutaC.CodDiv
                        AND T-VtaCDocu.CodPed = "HPK" NO-LOCK)
            THEN DO:
            CREATE DETALLE.
            BUFFER-COPY T-DI-RutaC TO DETALLE.
            NEXT.
        END.
        FOR EACH T-VtaCDocu WHERE T-VtaCDocu.CodCia = DI-RutaC.CodCia
            AND T-VtaCDocu.CodOri = DI-RutaC.CodDoc
            AND T-VtaCDocu.NroOri = DI-RutaC.NroDoc
            AND T-VtaCDocu.CodDiv = DI-RutaC.CodDiv
            AND T-VtaCDocu.CodPed = "HPK" NO-LOCK,
            FIRST VtaCDocu WHERE VtaCDocu.CodCia = T-VtaCDocu.CodCia
            AND VtaCDocu.CodDiv = T-VtaCDocu.CodDiv
            AND VtaCDocu.CodPed = T-VtaCDocu.CodPed
            AND VtaCDocu.NroPed = T-VtaCDocu.NroPed NO-LOCK:
            CREATE DETALLE.
            BUFFER-COPY T-DI-RutaC TO DETALLE.
            BUFFER-COPY T-VtaCDocu EXCEPT T-VtaCDocu.Bultos
                TO DETALLE 
                ASSIGN 
                DETALLE.BultosDetalle = T-VtaCDocu.Bultos
                DETALLE.CodAlm = T-VtaCDocu.CodAlm
                DETALLE.ZonaPickeo = T-VtaCDocu.ZonaPickeo
                .
            /* Cargamos Departamento y Distrito */
            FIND FIRST Faccpedi WHERE Faccpedi.codcia = T-VtaCDocu.codcia
                AND Faccpedi.coddoc = T-VtaCDocu.codref
                AND Faccpedi.nroped = T-VtaCDocu.nroref
                NO-LOCK NO-ERROR.
            IF AVAILABLE Faccpedi THEN DO:
                DETALLE.Departamento = fDepartamento().
                DETALLE.Distrito = fDistrito().
            END.
            /* 16/03/2022 Datos MR */
            IF AVAILABLE Faccpedi THEN DO:
                ASSIGN
                    DETALLE.FchRef = Faccpedi.FchPed
                    DETALLE.HorRef = Faccpedi.Hora
                    .
            END.
            ASSIGN
                DETALLE.UsrSac = Vtacdocu.UsrSac.
            RUN logis/p-busca-por-dni (Vtacdocu.UsrSac, OUTPUT pNombre, OUTPUT pOrigen).
            ASSIGN
                DETALLE.NomSac = pNombre.
        END.
    END.

/*     FIND FIRST DETALLE NO-LOCK NO-ERROR. */
/*     IF NOT AVAILABLE DETALLE THEN DO:    */
/*         RETURN.                          */
/*     END.                                 */

    /* 07/02/2023: M.Ramos fecha de picking completado */
    FOR EACH DETALLE EXCLUSIVE-LOCK:
        FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-codcia AND
            LogTrkDocs.CodDoc = "HPK" AND 
            LogTrkDocs.NroDoc = DETALLE.nroped AND 
            LogTrkDocs.Clave = "TRCKHPK" AND 
            LogTrkDocs.Codigo = "PK_COM":
            DETALLE.fFinPicking = ENTRY(1,STRING(LogTrkDocs.Fecha),' ').
            DETALLE.hFinPicking = SUBSTRING(ENTRY(2,STRING(LogTrkDocs.Fecha),' '),1,8).
        END.
    END.

    DEF VAR cArchivo AS CHAR NO-UNDO.
    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    /*pArchivo = "d:\tmp\spprueba.txt".*/
    cArchivo = LC(pArchivo).
    /*cArchivo = "D:\tmp\uno.txt".*/
    RUN lib/tt-file (TEMP-TABLE DETALLE:HANDLE, cArchivo, pOptions).
    /* ******************************************************* */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fDepartamento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDepartamento Procedure 
FUNCTION fDepartamento RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pUbigeo AS CHAR NO-UNDO.
  DEF VAR pLongitud AS DEC NO-UNDO.
  DEF VAR pLatitud AS DEC NO-UNDO.
  DEF VAR pCuadrante AS CHAR NO-UNDO.

  RUN logis/p-datos-sede-auxiliar.r (
      FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
      FacCPedi.Ubigeo[3],   /* Auxiliar */
      FacCPedi.Ubigeo[1],   /* Sede */
      OUTPUT pUbigeo,
      OUTPUT pLongitud,
      OUTPUT pLatitud
      ).
  FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
  IF AVAILABLE TabDepto THEN RETURN TabDepto.NomDepto.
  ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fDistrito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDistrito Procedure 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pUbigeo AS CHAR NO-UNDO.
  DEF VAR pLongitud AS DEC NO-UNDO.
  DEF VAR pLatitud AS DEC NO-UNDO.
  DEF VAR pCuadrante AS CHAR NO-UNDO.

  RUN logis/p-datos-sede-auxiliar.r (
      FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
      FacCPedi.Ubigeo[3],   /* Auxiliar */
      FacCPedi.Ubigeo[1],   /* Sede */
      OUTPUT pUbigeo,
      OUTPUT pLongitud,
      OUTPUT pLatitud
      ).
  FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
      AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
      AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
      NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN RETURN TabDistr.NomDistr.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fEstado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado Procedure 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-Status AS CHAR.
RUN gn/p-status-hpk(pCodDoc, pNroPed, OUTPUT x-Status).
RETURN x-Status.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

