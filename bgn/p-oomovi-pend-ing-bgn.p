&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report-2 NO-UNDO LIKE w-report.



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

DEF VAR s-Titulo AS CHAR INIT 'MOVIMIENTOS POR PROCESAR' NO-UNDO FORMAT 'x(50)'.
DEF VAR pArchivo AS CHAR NO-UNDO.
DEF VAR pTipMov AS CHAR NO-UNDO.
DEF VAR pCodMov AS CHAR NO-UNDO.
DEF VAR pCodAlm AS CHAR NO-UNDO.

ASSIGN
    pTipMov  = "I"
    pCodMov  = "09,90,03"
    pCodAlm  = "11"
    pArchivo = "d:\tmp\spprueba.txt".

/* Capturamos parámetros de la tabla de configuraciones */
FIND TabGener WHERE TabGener.CodCia = s-codcia AND
    TabGener.Clave = "CFG_TXT_OOMOVI_ING" NO-LOCK NO-ERROR.
IF AVAILABLE TabGener THEN DO:
    pTipMov  = TabGener.Libre_c01.
    pCodMov  = TabGener.Libre_c02.
    pCodAlm  = TabGener.Libre_c03.
    pArchivo = TabGener.Libre_c04.
END.

DEF TEMP-TABLE Seg-Pedidos
    FIELD CodAlm        AS CHAR FORMAT 'x(8)'               LABEL 'ALMACEN'
    FIELD CodMat        AS CHAR FORMAT 'x(8)'               LABEL 'ARTICULO'
    FIELD DesMat        AS CHAR FORMAT 'x(100)'             LABEL 'DESCRIPCION'
    FIELD DesMar        AS CHAR FORMAT 'x(30)'              LABEL 'MARCA'
    FIELD CodFam        AS CHAR FORMAT 'x(8)'               LABEL 'LINEA'
    FIELD SubFam        AS CHAR FORMAT 'x(8)'               LABEL 'SUBLINEA'
    FIELD UndStk        AS CHAR FORMAT 'x(8)'               LABEL 'UNIDAD'
    FIELD Cantidad      AS DECI FORMAT '>>>,>>>,>>9.99'     LABEL 'CANTIDAD'
    FIELD CodUbi        AS CHAR FORMAT 'x(15)'              LABEL 'UBICACION'
    FIELD CodZona       AS CHAR FORMAT 'x(15)'              LABEL 'ZONA'
    FIELD NroSer        AS INTE                             LABEL 'SERIE'
    FIELD NroDoc        AS INTE FORMAT '>>>>>>>>>>>9'       LABEL 'CORRELATIVO'
    FIELD FchDoc        AS DATE FORMAT '99/99/9999'         LABEL 'FECHA'
    FIELD TipMov        AS CHAR FORMAT 'x(8)'               LABEL 'TIP MOV'
    FIELD CodMov        AS CHAR FORMAT 'x(8)'               LABEL 'COD MOV'
    .

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
    DEF VAR pOrigen AS CHAR NO-UNDO.

    /* pArchivo debe llevar la ruta y el nombre del archivo texto */
    ASSIGN
        pOptions = "FileType:TXT" + CHR(1) + ~
              "Grid:ver" + CHR(1) + ~ 
              "ExcelAlert:false" + CHR(1) + ~
              "ExcelVisible:false" + CHR(1) + ~
              "Labels:yes".

    /* Capturamos información de la cabecera y el detalle */
    RUN bgn/p-oomovi-pend-ing (INPUT pTipMov,
                               INPUT pCodMov,
                               INPUT pCodAlm,
                               OUTPUT TABLE t-report-2).

    FIND FIRST t-report-2 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-report-2 THEN RETURN.

    EMPTY TEMP-TABLE Seg-Pedidos.
    FOR EACH t-report-2 NO-LOCK:
        CREATE Seg-Pedidos.
        ASSIGN
            Seg-Pedidos.CodAlm    = t-report-2.Campo-C[1]
            Seg-Pedidos.CodMat    = t-report-2.Campo-C[2]
            Seg-Pedidos.DesMat    = t-report-2.Campo-C[3]
            Seg-Pedidos.DesMar    = t-report-2.Campo-C[4]
            Seg-Pedidos.CodFam    = t-report-2.Campo-C[5]
            Seg-Pedidos.SubFam    = t-report-2.Campo-C[6]
            Seg-Pedidos.UndStk    = t-report-2.Campo-C[7]
            Seg-Pedidos.Cantidad  = decimal(t-report-2.Campo-C[8])
            Seg-Pedidos.CodUbi    = t-report-2.Campo-C[9]
            Seg-Pedidos.CodZona   = t-report-2.Campo-C[10]
            Seg-Pedidos.NroSer    = INTEGER(t-report-2.Campo-C[11])
            Seg-Pedidos.NroDoc    = integer(t-report-2.Campo-C[12])
            Seg-Pedidos.FchDoc    = date(t-report-2.Campo-C[13])
            Seg-Pedidos.TipMov    = t-report-2.Campo-C[14]
            Seg-Pedidos.CodMov    = t-report-2.Campo-C[15]
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

