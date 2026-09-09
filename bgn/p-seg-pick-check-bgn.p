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
DEFINE TEMP-TABLE t-report-2 NO-UNDO LIKE w-report.
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

DEF VAR s-Titulo AS CHAR INIT 'PRODUCCION PICADOR CHEQUEADOR' NO-UNDO FORMAT 'x(50)'.
DEF VAR pArchivo AS CHAR NO-UNDO.
DEF VAR pInicio AS DATE NO-UNDO.
DEF VAR pFin AS DATE NO-UNDO.


ASSIGN
    pArchivo = "d:\tmp\spprueba.txt".

/* Capturamos parámetros de la tabla de configuraciones */
FIND TabGener WHERE TabGener.CodCia = s-codcia AND
    TabGener.Clave = "CFG_TXT_PKCK" NO-LOCK NO-ERROR.
IF AVAILABLE TabGener THEN DO:
    s-CodDiv    = TabGener.Libre_c01.
    pArchivo    = TabGener.Libre_c02.
END.

/* Solo el día de hoy */
ASSIGN
    pInicio = TODAY
    pFin = TODAY.
/* ASSIGN                         */
/*     pInicio = DATE(03,25,2021) */
/*     pFin = DATE(03,25,2021).   */

DEF TEMP-TABLE Seg-Pedidos
    FIELD Tipo AS CHAR FORMAT 'x(15)'                   LABEL 'TIPO'
    FIELD Codigo AS CHAR FORMAT 'x(5)'                  LABEL 'CODIGO'
    FIELD Numero AS CHAR FORMAT 'x(15)'                 LABEL 'NUMERO'
    FIELD Fecha AS DATE FORMAT '99/99/9999'             LABEL 'FECHA DE P/C'
    FIELD Hora  AS CHAR FORMAT 'x(10)'                  LABEL 'HORA DE P/C'
    FIELD CodPer AS CHAR FORMAT 'x(15)'                 LABEL 'CODIGO DEL P/C'
    FIELD NomPer AS CHAR FORMAT 'x(60)'                 LABEL 'NOMBRE DEL P/C'
    FIELD Items AS INTE FORMAT '>>>,>>9'                LABEL 'ITEMS'
    FIELD Peso AS DECI FORMAT '>>>,>>9.99'              LABEL 'PESO'
    FIELD Volumen AS DECI FORMAT '>>>,>>9.9999'         LABEL 'VOLUMEN'
    FIELD Llave AS CHAR FORMAT 'x(15)'                  LABEL 'LLAVE'
    FIELD Bultos AS INTE FORMAT '>>>9'                  LABEL 'BULTOS'
    FIELD EmpaqEspec AS LOG FORMAT 'SI/NO'              LABEL 'EMPAQUE ESPECIAL'
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
      TABLE: t-report-2 T "?" NO-UNDO INTEGRAL w-report
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
         HEIGHT             = 6.85
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
    LEAVE.      /* El tiempo se va a controlar por Administrador de Tareas de Windows */
END.
QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

    RUN bgn/p-seg-pick-check (INPUT pInicio,
                              INPUT pFin,
                              INPUT s-CodDiv,
                              OUTPUT TABLE t-report-2).

    FIND FIRST t-report-2 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-report-2 THEN RETURN.

    EMPTY TEMP-TABLE Seg-Pedidos.
    FOR EACH t-report-2 NO-LOCK:
        CREATE Seg-Pedidos.
        ASSIGN
            Seg-Pedidos.Tipo = t-report-2.Llave-C
            Seg-Pedidos.NomPer = t-report-2.campo-c[2]
            Seg-Pedidos.Codigo = t-report-2.campo-c[3]
            Seg-Pedidos.Numero = t-report-2.campo-c[4]
            Seg-Pedidos.Fecha = t-report-2.campo-d[1]
            Seg-Pedidos.Hora = t-report-2.campo-c[5]
            Seg-Pedidos.CodPer = t-report-2.campo-c[1]
            Seg-Pedidos.Items = t-report-2.campo-f[1]
            Seg-Pedidos.Peso = t-report-2.campo-f[2]
            Seg-Pedidos.Volumen = t-report-2.campo-f[3]
            Seg-Pedidos.Llave = t-report-2.campo-c[6]
            Seg-Pedidos.Bultos = t-report-2.campo-i[1]
            Seg-Pedidos.EmpaqEspec = t-report-2.Campo-L[1]
            .
    END.

    DEF VAR cArchivo AS CHAR NO-UNDO.
    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    RUN lib/tt-file (TEMP-TABLE Seg-Pedidos:HANDLE, cArchivo, pOptions).
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

