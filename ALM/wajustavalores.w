&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DMOV NO-UNDO LIKE Almdmov
       INDEX Idx01 AS PRIMARY codalm tipmov codmov nroser nrodoc codmat.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR I-FchDoc AS DATE NO-UNDO.

def var x-signo  as deci no-undo.  
def var x-ctomed as deci no-undo.
def var x-stkgen as deci no-undo.
def var x-cto    as deci no-undo.
def var x-factor as inte no-undo.
def var f-candes as deci no-undo.

def buffer B-STKAL FOR AlmStkAl.
def buffer B-STKGE FOR AlmStkGe.
def buffer b-mov   FOR Almtmov.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DMOV Almdmov Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-DMOV.CodAlm T-DMOV.CodMov ~
T-DMOV.NroSer T-DMOV.NroDoc T-DMOV.FchDoc T-DMOV.codmat Almmmatg.DesMat ~
Almdmov.CanDes Almdmov.PreUni Almdmov.ImpCto T-DMOV.PreUni T-DMOV.ImpCto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-DMOV NO-LOCK, ~
      EACH Almdmov WHERE Almdmov.CodCia = T-DMOV.CodCia ~
  AND Almdmov.CodAlm = T-DMOV.CodAlm ~
  AND Almdmov.TipMov = T-DMOV.TipMov ~
  AND Almdmov.CodMov = T-DMOV.CodMov ~
  AND Almdmov.NroSer = T-DMOV.NroSer ~
  AND Almdmov.NroDoc = T-DMOV.NroDoc ~
  AND Almdmov.codmat = T-DMOV.codmat NO-LOCK, ~
      EACH Almmmatg OF T-DMOV NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-DMOV NO-LOCK, ~
      EACH Almdmov WHERE Almdmov.CodCia = T-DMOV.CodCia ~
  AND Almdmov.CodAlm = T-DMOV.CodAlm ~
  AND Almdmov.TipMov = T-DMOV.TipMov ~
  AND Almdmov.CodMov = T-DMOV.CodMov ~
  AND Almdmov.NroSer = T-DMOV.NroSer ~
  AND Almdmov.NroDoc = T-DMOV.NroDoc ~
  AND Almdmov.codmat = T-DMOV.codmat NO-LOCK, ~
      EACH Almmmatg OF T-DMOV NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-DMOV Almdmov Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-DMOV
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almdmov
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-2 BtnDone BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Proceso 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "1) IMPORTAR EXCEL" 
     SIZE 20 BY 1.35
     FONT 6.

DEFINE BUTTON BUTTON-2 
     LABEL "2) GENERAR MOVIMIENTO" 
     SIZE 27 BY 1.35
     FONT 6.

DEFINE VARIABLE FILL-IN-Proceso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-DMOV, 
      Almdmov, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-DMOV.CodAlm FORMAT "x(3)":U WIDTH 6.43
      T-DMOV.CodMov COLUMN-LABEL "Mov." FORMAT "99":U
      T-DMOV.NroSer COLUMN-LABEL "Serie" FORMAT "999":U WIDTH 4.14
      T-DMOV.NroDoc COLUMN-LABEL "Numero" FORMAT "9999999":U WIDTH 6.43
      T-DMOV.FchDoc COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
            WIDTH 8.43
      T-DMOV.codmat COLUMN-LABEL "Producto" FORMAT "X(6)":U WIDTH 7.72
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 42.43
      Almdmov.CanDes FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U WIDTH 8.43
      Almdmov.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT "(Z,ZZZ,ZZ9.9999)":U
            WIDTH 7 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Almdmov.ImpCto FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U WIDTH 8.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-DMOV.PreUni COLUMN-LABEL "Nuevo!Precio Unitario" FORMAT "(ZZZ,ZZ9.9999)":U
            WIDTH 10.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      T-DMOV.ImpCto COLUMN-LABEL "Nuevo Importe" FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U
            COLUMN-FGCOLOR 1 COLUMN-BGCOLOR 11
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 135 BY 15.08
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-1 AT ROW 1 COL 2 WIDGET-ID 2
     BUTTON-2 AT ROW 1 COL 22 WIDGET-ID 4
     BtnDone AT ROW 1 COL 50 WIDGET-ID 6
     FILL-IN-Proceso AT ROW 1.27 COL 69 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BROWSE-2 AT ROW 2.62 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 137.86 BY 17.12
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: T-DMOV T "?" NO-UNDO INTEGRAL Almdmov
      ADDITIONAL-FIELDS:
          INDEX Idx01 AS PRIMARY codalm tipmov codmov nroser nrodoc codmat
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "VALORIZACION DE INGRESOS AL ALMACEN"
         HEIGHT             = 17.12
         WIDTH              = 137.86
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 FILL-IN-Proceso fMain */
/* SETTINGS FOR FILL-IN FILL-IN-Proceso IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-DMOV,INTEGRAL.Almdmov WHERE Temp-Tables.T-DMOV ...,INTEGRAL.Almmmatg OF Temp-Tables.T-DMOV"
     _Options          = "NO-LOCK"
     _JoinCode[2]      = "INTEGRAL.Almdmov.CodCia = Temp-Tables.T-DMOV.CodCia
  AND INTEGRAL.Almdmov.CodAlm = Temp-Tables.T-DMOV.CodAlm
  AND INTEGRAL.Almdmov.TipMov = Temp-Tables.T-DMOV.TipMov
  AND INTEGRAL.Almdmov.CodMov = Temp-Tables.T-DMOV.CodMov
  AND INTEGRAL.Almdmov.NroSer = Temp-Tables.T-DMOV.NroSer
  AND INTEGRAL.Almdmov.NroDoc = Temp-Tables.T-DMOV.NroDoc
  AND INTEGRAL.Almdmov.codmat = Temp-Tables.T-DMOV.codmat"
     _FldNameList[1]   > Temp-Tables.T-DMOV.CodAlm
"T-DMOV.CodAlm" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DMOV.CodMov
"T-DMOV.CodMov" "Mov." ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DMOV.NroSer
"T-DMOV.NroSer" "Serie" ? "integer" ? ? ? ? ? ? no ? no no "4.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DMOV.NroDoc
"T-DMOV.NroDoc" "Numero" "9999999" "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DMOV.FchDoc
"T-DMOV.FchDoc" "Fecha" ? "date" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DMOV.codmat
"T-DMOV.codmat" "Producto" ? "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "42.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almdmov.CanDes
"Almdmov.CanDes" ? ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.Almdmov.PreUni
"Almdmov.PreUni" "Precio!Unitario" ? "decimal" 14 0 ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.Almdmov.ImpCto
"Almdmov.ImpCto" ? "(ZZZ,ZZZ,ZZ9.9999)" "decimal" 14 0 ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-DMOV.PreUni
"T-DMOV.PreUni" "Nuevo!Precio Unitario" "(ZZZ,ZZ9.9999)" "decimal" 11 0 ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-DMOV.ImpCto
"T-DMOV.ImpCto" "Nuevo Importe" "(ZZZ,ZZZ,ZZ9.9999)" "decimal" 11 1 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* VALORIZACION DE INGRESOS AL ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* VALORIZACION DE INGRESOS AL ALMACEN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* 1) IMPORTAR EXCEL */
DO:
   RUN Carga-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* 2) GENERAR MOVIMIENTO */
DO:
  RUN Ajusta-Valores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ajusta-Valores wWin 
PROCEDURE Ajusta-Valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Confirme la generación de movimientos de valorización' SKIP(1)
    'Continuamos?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF BUFFER b-cmov FOR almcmov.
DEF BUFFER b-dmov FOR almdmov.

DEF VAR x-preuni AS DEC NO-UNDO.
DEF VAR x-codmat AS CHAR NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
/* 1ro Borramos algun movimiento anterior */
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE T-DMOV ON STOP UNDO, RETURN:
    DISPLAY Almdmov.Codalm + "-" +
            Almdmov.tipmov + "-" +
            STRING(Almdmov.Codmov,"99") + "-" +
            STRING(Almdmov.Nrodoc,"9999999") + "-" +
            STRING(Almdmov.fchdoc,"99/99/9999")  @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.                    
    PAUSE 0.
    FIND almcmov OF t-dmov NO-LOCK NO-ERROR.
    IF AVAILABLE almcmov THEN DO:
        FIND b-cmov WHERE b-cmov.codcia = almcmov.codcia
            AND b-cmov.codalm = almcmov.codalm
            AND b-cmov.tipmov = almcmov.tipmov
            AND b-cmov.codmov = 55
            AND b-cmov.nroser = almcmov.nroser
            AND b-cmov.nrodoc = almcmov.nrodoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-cmov THEN DO:
            FOR EACH b-dmov OF b-cmov:
                DELETE b-dmov.
            END.
            DELETE b-cmov.
        END.
    END.
    GET NEXT {&browse-name}.
END.

/* 2do pasamos los movimientos */
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE T-DMOV:
    DISPLAY Almdmov.Codalm + "-" +
            Almdmov.tipmov + "-" +
            STRING(Almdmov.Codmov,"99") + "-" +
            STRING(Almdmov.Nrodoc,"9999999") + "-" +
            STRING(Almdmov.fchdoc,"99/99/9999")  @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.                    
    PAUSE 0.
    FIND almcmov OF t-dmov NO-LOCK NO-ERROR.
    IF AVAILABLE almcmov THEN DO:
        FIND b-cmov WHERE b-cmov.codcia = almcmov.codcia
            AND b-cmov.codalm = almcmov.codalm
            AND b-cmov.tipmov = almcmov.tipmov
            AND b-cmov.codmov = 55
            AND b-cmov.nroser = almcmov.nroser
            AND b-cmov.nrodoc = almcmov.nrodoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b-cmov THEN DO:
            CREATE b-cmov.
            BUFFER-COPY almcmov
                TO b-cmov
                ASSIGN
                b-cmov.codmov = 55
                b-cmov.hradoc = "23:59"
                b-cmov.usuario = s-user-id
                b-cmov.libre_f01 = TODAY.
        END.
        CREATE b-dmov.
        BUFFER-COPY almdmov
            TO b-dmov
            ASSIGN
            b-dmov.codmov = 55
            b-dmov.candes = 0
            b-dmov.hradoc   = "23:59"
            b-dmov.preuni = almdmov.candes * (T-DMOV.preuni - almdmov.preuni).
        /* ACTUALIZAMOS COSTO PROMEDIO */
        RUN alm/calc-costo-promedio (b-dmov.codmat, b-dmov.fchdoc).
    END.
    GET NEXT {&browse-name}.
END.

EMPTY TEMP-TABLE T-DMOV.
{&OPEN-QUERY-{&BROWSE-NAME}}

SESSION:SET-WAIT-STATE('').

MESSAGE 'Proceso concluido' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Excel wWin 
PROCEDURE Carga-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR.
DEF VAR OKpressed AS LOG.
DEF VAR x-Linea AS CHAR FORMAT 'x(30)' NO-UNDO.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS "Archivo (*.xls)" "*.xls"
    MUST-EXIST
    TITLE "Seleccione archivo EXCEL (xls)"
    UPDATE OKpressed.   
IF OKpressed = NO THEN RETURN ERROR.

EMPTY TEMP-TABLE T-DMOV.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER              NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER              NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER              NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL  DECIMALS 4  NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER  INIT 1      NO-UNDO.
DEFINE VARIABLE t-Row           AS INTEGER  INIT 1      NO-UNDO.
DEFINE VARIABLE i-Column        AS INTEGER              NO-UNDO.

CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(x-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

t-Row = 1.        /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-Column = 1
        t-Row    = t-Row + 1
        cValue = ''
        dValue = 0.
    /* Almacén */
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE ARCHIVO */
    CREATE T-DMOV.
    ASSIGN
        T-DMOV.CodCia = s-codcia
        T-DMOV.CodAlm = cValue
        T-DMOV.TipMov = "I".
    /* Cod. de movimiento */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        iValue = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, NEXT.
    ASSIGN
        T-DMOV.CodMov = iValue.
    /* Serie del movimiento */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        iValue = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, NEXT.
    ASSIGN
        T-DMOV.NroSer = iValue.
    /* Correlativo del movimiento */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        iValue = INTEGER(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, NEXT.
    ASSIGN
        T-DMOV.NroDoc = iValue.
    /* Orden de Producción */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* Producto */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        T-DMOV.CodMat = cValue.
    /* Descripción */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    /* Costo unitario */
    t-Column = t-Column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        dValue = DECIMAL(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, NEXT.
    ASSIGN
        T-DMOV.PreUni = dValue.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 


FOR EACH T-DMOV,
    EACH Almdmov NO-LOCK WHERE Almdmov.CodCia = T-DMOV.CodCia
    AND Almdmov.CodAlm = T-DMOV.CodAlm
    AND Almdmov.TipMov = T-DMOV.TipMov
    AND Almdmov.CodMov = T-DMOV.CodMov
    AND Almdmov.NroSer = T-DMOV.NroSer
    AND Almdmov.NroDoc = T-DMOV.NroDoc
    AND Almdmov.codmat = T-DMOV.codmat:
    ASSIGN
        T-DMOV.ImpCto = Almdmov.CanDes * T-DMOV.PreUni.
END.

{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Costo-Promedio wWin 
PROCEDURE Costo-Promedio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH AlmStkAl WHERE AlmStkAl.Codcia = S-CODCIA AND
                        AlmStkAl.CodMat = Almmmatg.CodMat AND
                        AlmStkAl.Fecha >= I-FchDoc:
    DELETE AlmStkAl.
END.                        

FOR EACH AlmStkGe WHERE AlmStkGe.Codcia = S-CODCIA AND
                        AlmStkGe.CodMat = Almmmatg.CodMat AND
                        AlmStkGe.Fecha >= I-FchDoc:
    DELETE AlmStkGe.
END.                        
                 
FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                        Almmmate.CodMat = Almmmatg.CodMat 
                        USE-INDEX Mate03:
    Almmmate.StkAct = 0.
END.

ASSIGN
x-stkgen = 0
x-ctomed = 0.
FIND LAST AlmStkGe WHERE AlmStkGe.Codcia = S-CODCIA AND
                         AlmStkGe.CodMat = Almmmatg.CodMat AND
                         AlmStkGe.Fecha  < I-Fchdoc
                         NO-LOCK NO-ERROR.
IF AVAILABLE AlmStkGe THEN DO:
   ASSIGN
   x-stkgen = AlmStkGe.StkAct
   x-ctomed = AlmStkGe.CtoUni.
END.                       

/*************Ordenes Movimiento por Producto y Fecha *******************/     
FOR EACH AlmDmov WHERE Almdmov.Codcia = S-CODCIA AND
                       Almdmov.CodMat = Almmmatg.CodMat AND
                       Almdmov.FchDoc >= I-FchDoc
                       USE-INDEX Almd02: 
   DISPLAY Almdmov.Codalm + "-" +
           Almdmov.tipmov + "-" +
           STRING(Almdmov.Codmov,"99") + "-" +
           STRING(Almdmov.Nrodoc,"9999999") + "-" +
           STRING(Almdmov.fchdoc,"99/99/9999")  @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.                    
   PAUSE 0.
   FIND first almacen where almacen.codcia = almdmov.codcia
                      and almacen.codalm = almdmov.codalm  
                      use-index alm01 no-lock no-error.
    FIND Almtmovm WHERE almtmovm.codcia = almdmov.codcia
        AND almtmovm.tipmov = almdmov.tipmov
        AND almtmovm.codmov = almdmov.codmov
        NO-LOCK NO-ERROR.
    IF AVAILABLE almtmovm AND almtmovm.movtrf = YES
    THEN x-Factor = 0.
    ELSE x-Factor = 1.

    /*if avail almacen and not almacen.flgrep then next.*/
    IF AVAILABLE Almacen AND Almacen.FlgRep = NO THEN x-Factor = 0.

   IF AVAILABLE Almacen AND Almacen.AlmCsg = YES
   THEN x-Factor = 0.
   
   if almdmov.tpocmb = 0 then do:
        find last gn-tcmb where  gn-tcmb.fecha <= almdmov.fchdoc
                          use-index cmb01 no-lock no-error.
        if avail gn-tcmb then do:
            if almdmov.tipmov = "i" then almdmov.tpocmb = gn-tcmb.venta.
            if almdmov.tipmov = "s" then almdmov.tpocmb = gn-tcmb.compra. 
        end.
   end.
                          

   f-candes = almdmov.candes * almdmov.factor.
   IF Almdmov.tipMov = "I" THEN x-signo = 1.
   IF Almdmov.tipMov = "S" THEN x-signo = -1.
   
   /***********Inicia Stock x Almacen********************/
   FIND AlmStkAl WHERE AlmStkAl.Codcia = S-CODCIA AND
                       AlmStkAl.CodAlm = Almdmov.CodAlm AND
                       AlmStkAl.CodMat = Almdmov.CodMat AND
                       AlmstkAl.Fecha  = Almdmov.FchDoc
                       NO-ERROR.

   IF NOT AVAILABLE AlmStkAl THEN DO:      
      CREATE AlmStkAl.
      ASSIGN
      AlmStkAl.Codcia = S-CODCIA 
      AlmStkAl.CodAlm = Almdmov.CodAlm
      AlmStkAl.CodMat = Almdmov.CodMat
      AlmStkAl.Fecha  = Almdmov.FchDoc.
                           
      FIND LAST B-STKAL WHERE B-STKAL.Codcia = S-CODCIA AND
                              B-STKAL.CodAlm = Almdmov.CodAlm AND
                              B-STKAL.CodMat = Almdmov.CodMat AND
                              B-STKAL.Fecha  < Almdmov.FchDoc
                              NO-ERROR.
      IF AVAILABLE B-STKAL THEN AlmStkAl.StkAct = AlmStkAl.StkAct + B-STKAL.StkAct.                         

   END.
   ASSIGN
   AlmStkAl.StkAct = AlmStkAl.StkAct + f-candes * x-signo.
   /***********Fin Stock x Almacen********************/

   find first almtmov of almdmov use-index mov01 no-lock no-error.
   /***********Inicia Stock x Compañia********************/       
   FIND AlmStkGe WHERE AlmStkGe.Codcia = S-CODCIA AND
                       AlmStkGe.CodMat = Almdmov.CodMat AND
                       AlmstkGe.Fecha  = Almdmov.FchDoc
                       NO-ERROR.

   IF NOT AVAILABLE AlmStkGe THEN DO:      
      CREATE AlmStkGe.
      ASSIGN
      AlmStkGe.Codcia = S-CODCIA 
      AlmStkGe.CodMat = Almdmov.CodMat
      AlmStkGe.Fecha  = Almdmov.FchDoc.
                           
      FIND LAST B-STKGE WHERE B-STKGE.Codcia = S-CODCIA AND
                              B-STKGE.CodMat = Almdmov.CodMat AND
                              B-STKGE.Fecha  < Almdmov.FchDoc
                              NO-ERROR.
      IF AVAILABLE B-STKGE THEN AlmStkGe.StkAct = AlmStkGe.StkAct + B-STKGE.StkAct.                         

   END.
   ASSIGN
   AlmStkGe.StkAct = AlmStkGe.StkAct + f-candes * x-signo * x-factor.
   /***********Fin Stock x Compañia********************/       


   /***********Inicia Calculo del Costo Promedio********************/       
   IF AVAILABLE AlmtMov THEN DO:
      IF almtmov.TipMov = "I" AND x-Factor <> 0 THEN DO:
         x-cto = 0.
         IF Almtmov.TpoCto = 0 OR Almtmov.TpoCto = 1 THEN DO:
            IF almdmov.codmon = 1 THEN x-cto = Almdmov.Preuni.
            IF almdmov.codmon = 2 THEN x-cto = Almdmov.Preuni * Almdmov.TpoCmb.
            /* RHC  22/01/2013 CASO DE "SOLO VALORES" */
            IF Almtmovm.MovVal = NO THEN DO:
                /*MESSAGE 'normal' x-cto x-ctomed f-candes.*/
                x-ctomed = ((x-cto * f-candes) + (x-ctomed * (AlmStkGe.StkAct - f-candes * x-signo))) / ( AlmStkGe.StkAct).
                /* PARCHE 12.01.10 */
                IF Almdmov.ImpCto = 0 THEN Almdmov.ImpCto = Almdmov.CanDes * Almdmov.PreUni.
                /* ****** */
            END.
            ELSE DO:
                /*MESSAGE 'valores' x-cto x-ctomed f-candes.*/
                x-ctomed = ( x-cto + (x-ctomed * AlmStkGe.StkAct) ) / AlmStkGe.StkAct.
                /* PARCHE 12.01.10 */
                IF Almdmov.ImpCto = 0 THEN Almdmov.ImpCto = Almdmov.PreUni.
                /* ****** */
            END.
            IF x-ctomed < 0 THEN x-ctomed = x-cto.
            IF AlmStkGe.StkAct < f-candes AND AlmStkGe.StkAct >= 0 THEN x-ctomed = x-cto.
         END.
      END.
      ASSIGN
          Almdmov.VctoMn1 = x-ctomed
          Almdmov.StkSub  = AlmStkAl.StkAct
          Almdmov.StkAct  = AlmStkGe.StkAct
          AlmStkGe.CtoUni = x-ctomed
          AlmStkAl.CtoUni = x-ctomed.
   END.
   ELSE DO:
      Almdmov.VctoMn1 = 0.
   END.
   /***********Fin    Calculo del Costo Promedio********************/       
   
END.
/*************                            *******************/     

FOR EACH Almacen WHERE Almacen.Codcia = S-CODCIA:
     FIND LAST AlmStkAl WHERE AlmStkAl.Codcia = Almacen.Codcia AND
                              AlmStkAl.CodAlm = Almacen.CodAlm AND
                              AlmStkAl.CodMat = Almmmatg.CodMat
                              NO-ERROR. 
     IF AVAILABLE AlmStkAl THEN DO:
        FIND FIRST Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                                  Almmmate.CodAlm = Almacen.CodAlm AND
                                  Almmmate.CodMat = Almmmatg.CodMat
                                  NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            CREATE Almmmate.
            ASSIGN
            almmmate.codcia = S-CODCIA
            almmmate.codalm = almacen.codalm
            almmmate.codmat = almmmatg.codmat
            almmmate.desmat = almmmatg.desmat
            almmmate.undvta = almmmatg.undstk
            almmmate.facequ = 1.
        END.
        Almmmate.Stkact = AlmStkAl.StkAct.  
                                  
     END.
                 
END.

FILL-IN-Proceso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN-Proceso 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-1 BUTTON-2 BtnDone BROWSE-2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

