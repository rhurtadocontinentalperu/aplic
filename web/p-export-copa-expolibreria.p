&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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

DEF VAR s-codcia AS INTE INIT 001.
DEF VAR pv-codcia AS INTE INIT 000.
DEF VAR cl-codcia AS INTE INIT 000.
DEF VAR s-coddiv AS CHAR INIT '10015'.
s-coddiv = '00015'.

DEF STREAM Reporte.

DEF TEMP-TABLE t-Transacciones NO-UNDO
    FIELD Lista_de_Precios LIKE FacCPedi.Lista_de_Precios
    FIELD coddiv LIKE Faccpedi.coddiv 
    FIELD coddoc LIKE Faccpedi.coddoc
    FIELD nroped LIKE Faccpedi.nroped
    FIELD fchped LIKE Faccpedi.fchped
    FIELD codcli LIKE Faccpedi.codcli
    FIELD codven LIKE Faccpedi.codven
    FIELD codmat LIKE Facdpedi.codmat
    FIELD canped LIKE Facdpedi.canped
    FIELD implin LIKE Facdpedi.implin
    FIELD codprm AS CHAR FORMAT 'x(15)'
    FIELD codpro AS CHAR FORMAT 'x(15)'
    .

DEF TEMP-TABLE t-Resumen NO-UNDO
    FIELD coddiv LIKE Faccpedi.coddiv 
    FIELD desdiv AS CHAR FORMAT 'x(100)'
    FIELD coddoc LIKE Faccpedi.coddoc
    FIELD nroped LIKE Faccpedi.nroped
    FIELD fchped LIKE Faccpedi.fchped
    FIELD codcli LIKE Faccpedi.codcli
    FIELD nomcli AS CHAR FORMAT 'x(100)'
    FIELD codven LIKE Faccpedi.codven
    FIELD nomven AS CHAR FORMAT 'x(100)'
    FIELD codmat LIKE Facdpedi.codmat
    FIELD desmat AS CHAR FORMAT 'x(100)'
    FIELD codmar AS CHAR FORMAT 'x(10)'
    FIELD desmar AS CHAR FORMAT 'x(50)'
    FIELD undstk LIKE Almmmatg.undstk
    FIELD canped LIKE Facdpedi.canped
    FIELD implin LIKE Facdpedi.implin
    FIELD codprm AS CHAR FORMAT 'x(15)'
    FIELD nomprm AS CHAR FORMAT 'x(80)'
    FIELD codpro AS CHAR FORMAT 'x(15)'
    FIELD nompro AS CHAR FORMAT 'x(100)'
    FIELD codfam AS CHAR FORMAT 'x(5)'
    FIELD desfam AS CHAR FORMAT 'x(50)'
    .

DEF VAR cDelimitador AS CHAR INIT ';' NO-UNDO.

/* Variables para el pase al MySQL */
DEF VAR x-Carpeta AS CHAR NO-UNDO.
DEF VAR x-CodDiv AS CHAR NO-UNDO.
DEF VAR x-FchPed-1 AS DATE NO-UNDO.
DEF VAR x-FchPed-2 AS DATE NO-UNDO.

x-Carpeta = "/u/backup/IN/ON_IN_CO/log".
x-CodDiv = s-CodDiv.

x-FchPed-2 = TODAY.             /* Fecha final del evento */
/*x-FchPed-2 = DATE(01,05,2024).*/
x-FchPed-1 = x-FchPed-2 - 4.

/* Capturamos las vigencias del evento */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
    gn-divi.coddiv = x-coddiv NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN DO:
    IF gn-divi.campo-date[1] <> ? AND gn-divi.campo-date[2] <> ? 
        THEN ASSIGN x-FchPed-1 = gn-divi.campo-date[1] x-FchPed-2 = gn-divi.campo-date[2].
END.

DEFINE VARIABLE comm-line AS CHARACTER FORMAT "x(70)".
DEFINE VARIABLE x-Url AS CHAR NO-UNDO.

x-Url = 'http://192.168.0.232:7000/evento/cargardata'.

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-Almmmatg NO-UNDO LIKE Almmmatg.
DEFINE TEMP-TABLE t-AlmSFami NO-UNDO LIKE AlmSFami.
DEFINE TEMP-TABLE t-almtabla NO-UNDO LIKE almtabla.
DEFINE TEMP-TABLE t-Almtfami NO-UNDO LIKE Almtfami.
DEFINE TEMP-TABLE t-gn-clie NO-UNDO LIKE gn-clie.
DEFINE TEMP-TABLE t-gn-divi NO-UNDO LIKE GN-DIVI.
DEFINE TEMP-TABLE t-gn-prov NO-UNDO LIKE gn-prov.
DEFINE TEMP-TABLE t-gn-ven NO-UNDO LIKE gn-ven.
DEFINE TEMP-TABLE t-Promotores NO-UNDO LIKE VtaTabla.

FIND Vtatabla WHERE Vtatabla.codcia = s-codcia AND
    Vtatabla.tabla = 'CONFIG-VTAS' AND
    Vtatabla.llave_c1 = 'EXPOLIBRERIA' AND
    Vtatabla.llave_c2 = 'URL' AND
    Vtatabla.llave_c3 = 'DWH'
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtatabla THEN x-Url = Vtatabla.llave_c4.

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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 12.65
         WIDTH              = 63.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
PUT 'INICIO: ' NOW SKIP.
RUN Exporta-Transacciones.
PUT 'FIN TRANSACCIONES ' NOW SKIP.
RUN Exporta-SKUs.
PUT 'FIN ARTICULOS ' NOW SKIP.
RUN Exporta-Clientes.
PUT 'FIN CLIENTES ' NOW SKIP.
RUN Exporta-Proveedores.
PUT 'FIN PROVEEDORES ' NOW SKIP.
RUN Exporta-Promotores.
PUT 'FIN PROMOTORES ' NOW SKIP.
RUN Exporta-Vendedores.
PUT 'FIN VENDEDORES ' NOW SKIP.
RUN Exporta-Lineas.
PUT 'FIN LINEAS ' NOW SKIP.
RUN Exporta-Marcas.
PUT 'FIN MARCAS ' NOW SKIP.
RUN Exporta-Divisiones.
PUT 'FIN DIVISIONES ' NOW SKIP.
RUN Exporta-Fechas.
PUT 'FIN FECHAS ' NOW SKIP.

RUN Exporta-Resumen.
PUT 'PROCESO TERMINADO ' NOW SKIP.

QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Exporta-Clientes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Clientes Procedure 
PROCEDURE Exporta-Clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-NomCli AS CHAR NO-UNDO.

EMPTY TEMP-TABLE t-gn-clie.

FOR EACH t-Transacciones NO-LOCK,
    FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND
    gn-clie.codcli = t-Transacciones.codcli NO-LOCK
    BREAK BY t-Transacciones.codcli:
    IF FIRST-OF(t-Transacciones.codcli) THEN DO:
        x-NomCli = REPLACE(gn-clie.nomcli,cDelimitador,' ').
        CREATE t-gn-clie.
        BUFFER-COPY gn-clie TO t-gn-clie ASSIGN t-gn-clie.NomCli = x-NomCli.
    END.
END.

x-Archivo = x-Carpeta + "/clientes.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-gn-clie NO-LOCK:
    PUT STREAM Reporte UNFORMATTED 
        t-gn-clie.CodCli cDelimitador
        t-gn-clie.NomCli cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
IF CAN-FIND(FIRST t-gn-clie NO-LOCK) 
    THEN OS-COMMAND VALUE(comm-line) SILENT.    /* NO-CONSOLE   .*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-Divisiones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Divisiones Procedure 
PROCEDURE Exporta-Divisiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-DesDiv AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "/divisiones.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
    gn-divi.canalventa = 'FER' AND
    gn-divi.campo-log[1] = NO:
    x-DesDiv = REPLACE(gn-divi.desdiv,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED
        gn-divi.coddiv cDelimitador
        x-DesDiv cDelimitador
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
OS-COMMAND VALUE(comm-line) SILENT. /* NO-CONSOLE   .*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-Fechas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Fechas Procedure 
PROCEDURE Exporta-Fechas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Fecha AS DATE NO-UNDO.

x-Archivo = x-Carpeta + "/fechas.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
DO x-Fecha = x-FchPed-1 TO x-FchPed-2:
    PUT STREAM Reporte UNFORMATTED
        (STRING(YEAR(x-Fecha),'9999') + '-' + 
        STRING(MONTH(x-Fecha),'99') + '-' +
        STRING(DAY(x-Fecha),'99')) cDelimitador
        STRING(YEAR(x-Fecha),'9999') cDelimitador
        STRING(MONTH(x-Fecha),'99') cDelimitador
        STRING(DAY(x-Fecha),'99') cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
OS-COMMAND VALUE(comm-line) SILENT. /* NO-CONSOLE   .*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-Lineas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Lineas Procedure 
PROCEDURE Exporta-Lineas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-DesFam AS CHAR NO-UNDO.

/* LINEAS */
EMPTY TEMP-TABLE t-almtfami.

FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:
    CREATE t-almtfami.
    BUFFER-COPY Almtfami TO t-almtfami.
END.

x-Archivo = x-Carpeta + "/lineas.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-almtfami NO-LOCK:
    x-DesFam = REPLACE(t-almtfami.desfam,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED
        t-almtfami.codfam cDelimitador
        x-DesFam cDelimitador
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
OS-COMMAND VALUE(comm-line) SILENT. /* NO-CONSOLE .*/

/* SUB-LINEAS */
EMPTY TEMP-TABLE t-almsfami.

FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia:
    CREATE t-almsfami.
    BUFFER-COPY Almsfami TO t-almsfami.
END.

DEF VAR x-DesSub AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "/sublineas.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-almsfami NO-LOCK:
    x-DesSub = REPLACE(t-almsfami.dessub,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED
        t-almsfami.codfam cDelimitador
        t-almsfami.subfam cDelimitador
        x-DesSub cDelimitador
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
OS-COMMAND VALUE(comm-line) SILENT. /* NO-CONSOLE   .*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-Marcas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Marcas Procedure 
PROCEDURE Exporta-Marcas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-DesMar AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "/marcas.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-almtabla NO-LOCK WHERE t-almtabla.tabla = 'MK':
    x-DesMar = REPLACE(t-almtabla.nombre,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED
        t-almtabla.codigo cDelimitador
        x-DesMar cDelimitador
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
OS-COMMAND VALUE(comm-line) SILENT. /* NO-CONSOLE   .*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-Promotores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Promotores Procedure 
PROCEDURE Exporta-Promotores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Proveedor AS CHAR NO-UNDO.
DEF VAR x-Promotor AS CHAR NO-UNDO.

/* Carga inicial promotores */
EMPTY TEMP-TABLE t-Promotores.

FOR EACH VtaTabla WHERE VtaTabla.CodCia = s-codcia 
    AND VtaTabla.Tabla = 'EXPOPROMOTOR' NO-LOCK:
    CREATE t-Promotores.
    BUFFER-COPY VtaTabla TO t-Promotores.
END.
FOR EACH t-Transacciones WHERE t-Transacciones.codprm > '' NO-LOCK,
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = t-Transacciones.codmat NO-LOCK:
    IF Almmmatg.codpr1 > '' THEN DO:
        FIND t-Promotores WHERE t-Promotores.codcia = s-codcia AND
            t-Promotores.Tabla = 'EXPOPROMOTOR' AND
            t-Promotores.Llave_c1 = t-Transacciones.Lista_de_Precios AND
            t-Promotores.llave_c2 = Almmmatg.codpr1 AND
            t-Promotores.llave_c3 = t-Transacciones.codprm
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE t-Promotores THEN DO:
            CREATE t-Promotores.
            ASSIGN
                t-Promotores.CodCia = s-codcia 
                t-Promotores.Tabla = 'EXPOPROMOTOR'
                t-Promotores.Llave_c1 = t-Transacciones.Lista_de_Precios
                t-Promotores.Llave_c2 = Almmmatg.codpr1
                t-Promotores.LLave_c3 = t-Transacciones.codprm.
        END.
    END.
END.

x-Archivo = x-Carpeta + "/promotores.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-Promotores NO-LOCK:
    PUT STREAM Reporte UNFORMATTED 
        t-Promotores.Llave_c1 cDelimitador
        t-Promotores.Llave_c2 cDelimitador
        t-Promotores.LLave_c3 cDelimitador
        t-Promotores.Libre_c01 cDelimitador
        t-Promotores.Libre_c02 cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
IF CAN-FIND(FIRST t-Promotores NO-LOCK) 
    THEN OS-COMMAND  VALUE(comm-line) SILENT.   /* NO-CONSOLE  .*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-Proveedores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Proveedores Procedure 
PROCEDURE Exporta-Proveedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Proveedor AS CHAR NO-UNDO.
DEF VAR x-Promotor AS CHAR NO-UNDO.
DEF VAR x-NomPro AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "/proveedores.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-gn-prov NO-LOCK:
    x-NomPro = REPLACE(t-gn-prov.nompro,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED 
        t-gn-prov.codpro cDelimitador
        x-NomPro cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
IF CAN-FIND(FIRST t-gn-prov NO-LOCK) 
    THEN OS-COMMAND VALUE(comm-line) SILENT.    /* NO-CONSOLE   .*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-Resumen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Resumen Procedure 
PROCEDURE Exporta-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.

EMPTY TEMP-TABLE t-Resumen.

FOR EACH t-Transacciones NO-LOCK,
    FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
        gn-divi.coddiv = t-Transacciones.coddiv NO-LOCK,
    FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = t-Transacciones.codcli NO-LOCK,
    FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND
        gn-ven.codven = t-Transacciones.codven NO-LOCK,
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = t-Transacciones.codmat NO-LOCK:
    CREATE t-Resumen.
    BUFFER-COPY t-Transacciones TO t-Resumen
        ASSIGN
        t-Resumen.desdiv = gn-divi.desdiv
        t-Resumen.nomcli = gn-clie.nomcli
        t-Resumen.nomven = gn-ven.nomven
        t-Resumen.desmat = Almmmatg.desmat
        t-Resumen.codmar = TRIM(Almmmatg.codmar)
        t-Resumen.undstk = Almmmatg.undstk
        t-Resumen.codfam = Almmmatg.codfam
        .
    FIND FIRST Almtabla WHERE Almtabla.Tabla = "MK" AND
        Almtabla.Codigo = TRIM(Almmmatg.codmar) NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN t-Resumen.desmar = REPLACE(TRIM(Almtabla.Nombre),cDelimitador," ").
    IF t-Resumen.codpro > '' THEN DO:
        FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND
            gn-prov.codpro = t-Resumen.codpro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN t-Resumen.nompro = REPLACE(gn-prov.nompro,cDelimitador," ").
    END.
    IF t-Resumen.codprm > '' THEN DO:
        FIND Vtatabla WHERE Vtatabl.CodCia = s-codcia AND
            Vtatabla.Tabla = 'EXPOPROMOTOR' AND
            Vtatabla.Llave_c1 = t-Transacciones.coddiv AND
            Vtatabla.Llave_c2 = Almmmatg.codpr1 AND
            Vtatabla.LLave_c3 = t-Resumen.codprm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtatabla THEN t-Resumen.nomprm = REPLACE(Vtatabla.libre_c01,cDelimitador," ").
    END.
    FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almtfami THEN t-Resumen.desfam = Almtfami.desfam.
END.

x-Archivo = x-Carpeta + "/resumen.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-Resumen NO-LOCK:
    PUT STREAM Reporte UNFORMATTED
        t-Resumen.coddiv cDelimitador 
        t-Resumen.desdiv cDelimitador 
        t-Resumen.coddoc cDelimitador 
        t-Resumen.nroped cDelimitador 
        (STRING(YEAR(t-Resumen.fchped),'9999') + '-' + 
        STRING(MONTH(t-Resumen.fchped),'99') + '-' +
        STRING(DAY(t-Resumen.fchped),'99')) cDelimitador
        t-Resumen.codcli cDelimitador 
        t-Resumen.nomcli cDelimitador 
        t-Resumen.codven cDelimitador 
        t-Resumen.nomven cDelimitador 
        t-Resumen.codmat cDelimitador 
        t-Resumen.desmat cDelimitador 
        t-Resumen.codmar cDelimitador 
        t-Resumen.desmar cDelimitador 
        t-Resumen.undstk cDelimitador 
        t-Resumen.canped cDelimitador 
        t-Resumen.implin cDelimitador 
        t-Resumen.codprm cDelimitador 
        t-Resumen.nomprm cDelimitador 
        t-Resumen.codpro cDelimitador 
        t-Resumen.nompro cDelimitador 
        t-Resumen.codfam cDelimitador 
        t-Resumen.desfam cDelimitador 
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
IF CAN-FIND(FIRST t-Resumen NO-LOCK) 
    THEN OS-COMMAND  VALUE(comm-line) SILENT.   /* NO-CONSOLE  .*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-SKUs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-SKUs Procedure 
PROCEDURE Exporta-SKUs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-DesMat AS CHAR NO-UNDO.

EMPTY TEMP-TABLE t-Almmmatg.

FOR EACH t-Transacciones NO-LOCK, 
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
        Almmmatg.codmat = t-Transacciones.codmat NO-LOCK
    BREAK BY t-Transacciones.codmat:
    IF FIRST-OF(t-Transacciones.codmat) THEN DO:
        x-DesMat = REPLACE(Almmmatg.desmat,cDelimitador,' ').
        CREATE t-Almmmatg.
        ASSIGN
            t-Almmmatg.codcia = Almmmatg.codcia 
            t-Almmmatg.codmat = Almmmatg.codmat
            t-Almmmatg.DesMat = x-DesMat
            t-Almmmatg.CodMar = TRIM(Almmmatg.codmar)
            t-Almmmatg.codfam = Almmmatg.codfam
            t-Almmmatg.subfam = Almmmatg.subfam
            t-Almmmatg.CodPr1 = Almmmatg.codpr1
            t-Almmmatg.CHR__02 = Almmmatg.CHR__02
            t-Almmmatg.undstk = Almmmatg.undstk
            .
    END.
END.

x-Archivo = x-Carpeta + "/articulos.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-Almmmatg NO-LOCK:
    PUT STREAM Reporte UNFORMATTED 
        t-Almmmatg.codmat cDelimitador
        t-Almmmatg.DesMat cDelimitador
        t-Almmmatg.codfam cDelimitador
        t-Almmmatg.CodMar cDelimitador
        t-Almmmatg.subfam cDelimitador
        t-Almmmatg.undstk cDelimitador      /* Unidad de stock */
        t-Almmmatg.CHR__02 cDelimitador     /* Tipo (T o P) */
        t-Almmmatg.CodPr1 cDelimitador      /* Proveedor */
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
IF CAN-FIND(FIRST t-Almmmatg NO-LOCK) 
    THEN OS-COMMAND VALUE(comm-line) SILENT.    /* NO-CONSOLE   .*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-Transacciones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Transacciones Procedure 
PROCEDURE Exporta-Transacciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Proveedor AS CHAR NO-UNDO.
DEF VAR x-Promotor AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "/transacciones.txt".

EMPTY TEMP-TABLE t-Transacciones.
EMPTY TEMP-TABLE t-gn-prov.
EMPTY TEMP-TABLE t-almtabla.

DEF VAR x-DesMat AS CHAR NO-UNDO.
DEF VAR x-NomCli AS CHAR NO-UNDO.
DEF VAR x-NomVen AS CHAR NO-UNDO.

/* Carga inicial promotores */
FOR EACH VtaTabla WHERE VtaTabla.CodCia = s-codcia 
    AND VtaTabla.Tabla = 'EXPOPROMOTOR' NO-LOCK:
    CREATE t-Promotores.
    BUFFER-COPY VtaTabla TO t-Promotores.
END.

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddiv = x-CodDiv AND
    Faccpedi.coddoc = "COT" AND
    Faccpedi.fchped >= x-FchPed-1 AND
    Faccpedi.fchped <= x-FchPed-2 AND
    Faccpedi.flgest <> "A",
    EACH Facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK:

    x-Proveedor = Almmmatg.codpr1.
    x-Promotor = "".
    IF NUM-ENTRIES(Facdpedi.Libre_c03, '|') >= 3 THEN DO:
        ASSIGN
            x-Proveedor = ENTRY(1, Facdpedi.libre_c03, '|')
            x-Promotor  = ENTRY(2, Facdpedi.libre_c03, '|').
    END.
    PUT STREAM Reporte UNFORMATTED 
        Faccpedi.coddiv cDelimitador
        Faccpedi.coddoc cDelimitador
        Faccpedi.nroped cDelimitador
        /*Faccpedi.fchped cDelimitador*/
        (STRING(YEAR(Faccpedi.fchped),'9999') + '-' + 
        STRING(MONTH(Faccpedi.fchped),'99') + '-' +
        STRING(DAY(Faccpedi.fchped),'99')) cDelimitador
        Facdpedi.codmat cDelimitador
        (Facdpedi.canped * Facdpedi.factor) cDelimitador
        Facdpedi.implin cDelimitador
        Faccpedi.codcli cDelimitador
        Faccpedi.codven cDelimitador
        x-Promotor      cDelimitador
        /*x-Proveedor cDelimitador*/
        SKIP
        .
    CREATE t-Transacciones.
    ASSIGN
        t-Transacciones.Lista_de_Precios = FacCPedi.Lista_de_Precios
        t-Transacciones.coddiv = Faccpedi.coddiv
        t-Transacciones.coddoc = Faccpedi.coddoc
        t-Transacciones.nroped = Faccpedi.nroped
        t-Transacciones.fchped = Faccpedi.fchped
        t-Transacciones.codcli = Faccpedi.codcli
        t-Transacciones.codven = Faccpedi.codven
        t-Transacciones.codmat = Facdpedi.codmat
        t-Transacciones.canped = (Facdpedi.canped * Facdpedi.factor)
        t-Transacciones.implin = Facdpedi.implin
        t-Transacciones.codprm = x-Promotor
        t-Transacciones.codpro = x-Proveedor
        .
    /* Proveedores */
    FIND t-gn-prov WHERE t-gn-prov.codcia = pv-codcia AND
        t-gn-prov.codpro = x-Proveedor
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE t-gn-prov THEN DO:
        CREATE t-gn-prov.
        ASSIGN
            t-gn-prov.codcia = pv-codcia
            t-gn-prov.codpro = x-Proveedor.
    END.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND
        gn-prov.codpro = x-Proveedor
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN DO:
        BUFFER-COPY gn-prov TO t-gn-prov.
    END.
    /* Marcas */
    FIND t-Almtabla WHERE t-almtabla.Tabla = "MK" AND
        t-almtabla.Codigo = TRIM(Almmmatg.codmar)
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE t-Almtabla THEN DO:
        CREATE t-almtabla.
        ASSIGN
            t-almtabla.Tabla = "MK" 
            t-almtabla.Codigo = TRIM(Almmmatg.codmar)
            .
    END.
    FIND Almtabla WHERE almtabla.Tabla = "MK" AND
        almtabla.Codigo = TRIM(Almmmatg.codmar) NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN t-almtabla.nombre = Almtabla.nombre.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
IF CAN-FIND(FIRST t-Transacciones NO-LOCK) 
    THEN OS-COMMAND VALUE(comm-line) SILENT.    /* NO-CONSOLE .*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Exporta-Vendedores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Vendedores Procedure 
PROCEDURE Exporta-Vendedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-NomVen AS CHAR NO-UNDO.

EMPTY TEMP-TABLE t-gn-ven.

FOR EACH t-Transacciones NO-LOCK BREAK BY t-Transacciones.codven:
    IF FIRST-OF(t-Transacciones.codven) THEN DO:
        FIND t-gn-ven WHERE t-gn-ven.CodCia = s-codcia AND 
            t-gn-ven.CodVen = t-Transacciones.codven
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE t-gn-ven THEN DO:
            CREATE t-gn-ven.
            ASSIGN
                t-gn-ven.codcia = s-codcia 
                t-gn-ven.CodVen = t-Transacciones.codven.
        END.
        FIND gn-ven WHERE gn-ven.codcia = s-codcia AND
            gn-ven.codven = t-Transacciones.codven NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN DO:
            x-NomVen = REPLACE(gn-ven.nomven,cDelimitador,' ').
            BUFFER-COPY gn-ven TO t-gn-ven ASSIGN t-gn-ven.NomVen = x-NomVen.
        END.

    END.
END.

x-Archivo = x-Carpeta + "/vendedores.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-gn-ven NO-LOCK:
    PUT STREAM Reporte UNFORMATTED 
        t-gn-ven.CodVen cDelimitador
        t-gn-ven.NomVen cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    'file=@' + x-Archivo + ' ' + 
    x-Url.
IF CAN-FIND(FIRST t-gn-ven NO-LOCK) 
    THEN OS-COMMAND VALUE(comm-line) SILENT.    /* NO-CONSOLE   .*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

