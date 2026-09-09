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

DEFINE INPUT PARAMETER X-ROWID AS ROWID.
FIND FacCPedi WHERE ROWID(FacCPedi) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN.

DEF SHARED VAR S-USER-ID AS CHAR. 
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR CL-codcia  AS INT.
DEF SHARED VAR pv-codcia  AS INT.
DEF SHARED VAR s-codalm  AS CHAR.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR S-NomCia  AS CHAR.

DEF VAR s-Task-No AS INT NO-UNDO.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR C-TitDoc  AS CHAR FORMAT "X(50)".
DEF        VAR XD        AS CHAR FORMAT "X(2)".
DEF        VAR I-NroItm  AS INTEGER.
DEF        VAR F-PreNet  AS DECIMAL.
DEF        VAR W-DIRALM  AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM  AS CHAR FORMAT "X(65)".

DEF        VAR F-PreUni  LIKE FacDPedi.Preuni.
DEF        VAR F-ImpLin  LIKE FacDPedi.ImpLin.
DEF        VAR F-ImpTot  LIKE FacCPedi.ImpTot.

DEF        VAR F-CodUbi  LIKE Almmmate.CodUbi.

DEFINE VARIABLE x-dscto AS DECIMAL.

DEFINE VARIABLE X-IMPIGV AS CHARACTER FORMAT "X(30)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR X-Percepcion AS CHAR FORMAT "x(60)" NO-UNDO.

IF FacCPedi.CodDoc = "PED" THEN C-TitDoc = "    PEDIDO :". 
ELSE C-TitDoc = "COTIZACION :".
C-TitDoc = "    PEDIDO :".

IF FacCpedi.Codmon = 2 THEN C-Moneda = "US$.".
ELSE C-Moneda = "S/  ".

C-NomVen = FacCPedi.CodVen.
C-NomCon = FacCPedi.FmaPgo.
XD       = STRING (FacCpedi.Fchven - FacCpedi.Fchped,"999").

IF FacCpedi.FlgIgv THEN DO:
   X-IMPIGV = "LOS PRECIOS INCLUYEN EL I.G.V.".
   F-ImpTot = FacCPedi.TotalVenta.
END.
ELSE DO:
   X-IMPIGV = "LOS PRECIOS NO INCLUYEN EL IGV.".
   F-ImpTot = FacCPedi.TotalValorVenta.
END.  

FIND FIRST gn-clie WHERE 
     gn-clie.codcia = CL-CODCIA AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
     
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.

FIND FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.

FIND Almacen WHERE 
     Almacen.CodCia = S-CODCIA AND  
     Almacen.CodAlm = Faccpedi.CODALM 
     NO-LOCK NO-ERROR.
IF AVAILABLE Almacen 
    THEN ASSIGN
    W-DIRALM = Almacen.DirAlm
    W-TLFALM = Almacen.TelAlm. 
W-TLFALM = 'Telemarketing:(511) 349-2351 / 349-2444  Fax:349-4670'.  
/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(F-IMPTOT, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF FacCPedi.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").
x-Percepcion = "".
IF Faccpedi.acubon[5] > 0 THEN x-Percepcion = "* Operación sujeta a percepción del IGV: " +
    (IF FacCPedi.codmon = 1 THEN "S/." ELSE "US$") + TRIM(STRING(Faccpedi.acubon[5], '>>>,>>9.99')).

DEFINE VARIABLE C-OBS AS CHAR EXTENT 3.
DEFINE VARIABLE K AS INTEGER.
IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
END.

DEFINE BUFFER x-vtatabla FOR vtatabla.

/* DEF TEMP-TABLE DETA LIKE FacDPedi                                     */
/*     FIELD Clave AS CHAR                                               */
/*     INDEX Llave01 Clave NroItm.                                       */
/*                                                                       */
/* DEF TEMP-TABLE DDOCU LIKE Ccbddocu.                                   */
/* DEF TEMP-TABLE T-PROM LIKE Expcprom.                                  */
/*                                                                       */
/* DEF TEMP-TABLE Resumen                                                */
/*     FIELD CodPro AS CHAR FORMAT 'x(11)'                               */
/*     FIELD NomPro AS CHAR FORMAT 'x(40)'                               */
/*     FIELD Cantidad AS INT.                                            */
/*                                                                       */
/*   DEF TEMP-TABLE Detalle                                              */
/*       FIELD codmat LIKE FacDPedi.codmat                               */
/*       FIELD canped LIKE FacDPedi.canped                               */
/*       FIELD implin LIKE FacDPedi.implin                               */
/*       FIELD impmin AS DEC         /* Importes y cantidades minimas */ */
/*       FIELD canmin AS DEC.                                            */
/*                                                                       */
/*   DEF TEMP-TABLE Promocion LIKE FacDPedi.                             */
/*                                                                       */

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
         HEIGHT             = 4.77
         WIDTH              = 65.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Definimos impresoras */

DEFINE VARIABLE X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEFINE VARIABLE Rpta     AS LOG NO-UNDO.
DEFINE VARIABLE x-Disney AS DEC FORMAT '>>>,>>>,>>9.99' NO-UNDO.
DEFINE VARIABLE x-Propios AS DEC FORMAT '>>>,>>>,>>9.99' NO-UNDO.
DEFINE VARIABLE x-Terceros AS DEC FORMAT '>>>,>>>,>>9.99' NO-UNDO.

DEFINE VAR x-listprecio AS CHAR.

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".
    
C-OBS[1] = '- LOS PRECIOS INCLUYEN IGV'.
C-OBS[2] = '- GARANTIZAMOS NUESTROS PRODUCTOS CON CERTIFICADOS DE CALIDAD'.
C-OBS[3] = '- SUJETO A DISPONIBILIDAD DE STOCK'.
/************************  DEFINICION DE FRAMES  *******************************/
/* CARGAMOS PRODUCTOS DISNEY */
x-Disney = 0.
FOR EACH FacDPedi OF FacCPedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK
    WHERE LOOKUP( TRIM (Almmmatg.Licencia[1]), '001,009,011,012,013,019,024,025,028,031,032') > 0:
    x-Disney = x-Disney + Facdpedi.ImpLin.
END.
FOR EACH FacDPedi OF FacCPedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK:
    IF LOOKUP(Almmmatg.codfam, '001,002,005') > 0 
        THEN x-Terceros = x-Terceros + Facdpedi.implin.
        ELSE x-Propios = x-Propios + Facdpedi.implin.
END.
/* RHC 10/01/2014 SOLO PARA AREQUIPA */
DEF VAR x-ImporteFaber AS DEC NO-UNDO.
DEF VAR x-ImporteCipsa AS DEC NO-UNDO.
DEF VAR x-CuponesGratis AS INT NO-UNDO.

/* Lista de Precio */
x-listprecio = "".
IF FacCpedi.libre_c01 <> ? THEN DO:
    x-listprecio = FacCpedi.libre_c01.
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = x-listprecio NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        x-listprecio = x-listprecio + " " + gn-divi.desdiv.
    END.
END.

/* CARGA TEMPORALES */
RUN Carga-Detalle.
RUN Carga-Promociones-2016.
RUN Datos-Adicionales.

DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta2/rbvta2.prl".
/*
IF s-coddiv = "00101" THEN DO:
   
    RB-REPORT-NAME = "Impresion Cotizacion Pdf-Utlx".
END.
ELSE DO:
    RB-REPORT-NAME = "Impresion Cotizacion Pdf".
END.
*/

RB-REPORT-NAME = "Impresion Cotizacion Pdf".

/* Codigo DURO autorizado por Daniel Llican el 03Feb2021 - Ventas Whatsapp */
FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = 'CONFIG-VTAS' AND
                            x-vtatabla.llave_c1 = 'PEDIDO-COMERCIAL-EN-PDF' AND
                            x-vtatabla.llave_c2 = s-coddiv NO-LOCK NO-ERROR.
IF AVAILABLE x-vtatabla THEN DO:
    RB-REPORT-NAME = TRIM(x-vtatabla.llave_c3).
END.


RB-INCLUDE-RECORDS = "O".
RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
RB-OTHER-PARAMETERS = "s-NomCia = " + s-NomCia + 
                        "~nx-EnLetras = " + x-EnLetras +
                        "~nx-Disney = " + STRING(x-Disney) +
                        "~nx-Propios = " + STRING(x-Propios) +
                        "~nx-Terceros = " + STRING(x-Terceros) +
                        "~nc-Moneda = " + c-Moneda.

DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "" NO-UNDO.
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "" NO-UNDO.
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "" NO-UNDO.
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "" NO-UNDO.
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "" NO-UNDO.
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "" NO-UNDO.
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1 NO-UNDO.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0 NO-UNDO.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0 NO-UNDO.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "" NO-UNDO.
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES NO-UNDO.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES NO-UNDO.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL YES NO-UNDO.
DEF VAR RB-STATUS-FILE AS CHAR INITIAL "" NO-UNDO.

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

IF NOT (cDatabaseName = ? OR
    cHostName = ? OR
    cNetworkProto = ? OR
    cPortNumber = ?) THEN DO:
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
    RB-DB-CONNECTION = cNewConnString.
END.

ASSIGN
    RB-PRINT-DESTINATION = ""           /* Impresora */
    RB-PRINTER-NAME = "PDFCreator".

RUN aderb/_prntrb2(
    RB-REPORT-LIBRARY,
    RB-REPORT-NAME,
    RB-DB-CONNECTION,
    RB-INCLUDE-RECORDS,
    RB-FILTER,
    RB-MEMO-FILE,
    RB-PRINT-DESTINATION,
    RB-PRINTER-NAME,
    RB-PRINTER-PORT,
    RB-OUTPUT-FILE,
    RB-NUMBER-COPIES,
    RB-BEGIN-PAGE,
    RB-END-PAGE,
    RB-TEST-PATTERN,
    RB-WINDOW-TITLE,
    RB-DISPLAY-ERRORS,
    RB-DISPLAY-STATUS,
    RB-NO-WAIT,
    RB-OTHER-PARAMETERS,
    RB-STATUS-FILE
    ).

/* ************************************************************************************ */
/* Librerias Impresión SUNAT */
/* ************************************************************************************ */
{vtagn/impresion-cot-laser-sunat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


