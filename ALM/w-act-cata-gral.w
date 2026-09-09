&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CatVtaD NO-UNDO LIKE AlmCatVtaD.
DEFINE TEMP-TABLE T-TABLA NO-UNDO LIKE logtabla.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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

DEF SHARED VAR s-codcia AS INT.

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEFINE VAR RADIO-SET-Valor AS INT.

DEFINE TEMP-TABLE ttBrws NO-UNDO
    FIELD BrwsHdl AS HANDLE
    FIELD BrwsName AS CHARACTER
    INDEX BrwsHdl IS PRIMARY UNIQUE BrwsHdl.

DEFINE TEMP-TABLE ttCol NO-UNDO
    FIELD BrwsHdl AS HANDLE
    FIELD ColHdl AS HANDLE
    FIELD ColName AS CHARACTER
    FIELD ColWidth AS DECIMAL
    FIELD ColFormat AS CHARACTER
    FIELD ColDatTyp AS CHARACTER
    FIELD ColLabel AS CHARACTER
    INDEX BrwsCol IS PRIMARY UNIQUE BrwsHdl ColHdl.

DEFINE VAR x-desmat-col AS CHAR.

DEFINE VAR x-tipo-dato AS CHAR INIT 'N'.     /* N:Numerico, C:Caracter */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-11

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-TABLA T-CatVtaD

/* Definitions for BROWSE BROWSE-11                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-11 T-TABLA.NumId T-TABLA.Tabla ~
descripcion-articulo(t-tabla.tabla) @ x-desmat-col T-TABLA.Evento ~
T-TABLA.ValorLlave 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-11 
&Scoped-define QUERY-STRING-BROWSE-11 FOR EACH T-TABLA NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-11 OPEN QUERY BROWSE-11 FOR EACH T-TABLA NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-11 T-TABLA
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-11 T-TABLA


/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 T-CatVtaD.Libre_c01 ~
T-CatVtaD.codmat T-CatVtaD.Libre_c04 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9 
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH T-CatVtaD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH T-CatVtaD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 T-CatVtaD
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 T-CatVtaD


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-11}~
    ~{&OPEN-QUERY-BROWSE-9}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 BUTTON-5 BUTTON-6 ~
COMBO-BOX-campo BROWSE-11 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-campo FILL-IN-msg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD descripcion-articulo W-Win 
FUNCTION descripcion-articulo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-5 
     LABEL "IMPORTAR EXCEL" 
     SIZE 16 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "Procesar" 
     SIZE 11.29 BY 1.12.

DEFINE VARIABLE COMBO-BOX-campo AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Empaque Master",1,
                     "Empaque Inner",2,
                     "Marca",3,
                     "Indice Comercial",4,
                     "Familia y Sub-Familia",5,
                     "Categoria Contable",6,
                     "Proveedor",7,
                     "Activar/Desactivar",8
     DROP-DOWN-LIST
     SIZE 21.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 99 BY 5.77
     BGCOLOR 15 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109.57 BY .15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-11 FOR 
      T-TABLA SCROLLING.

DEFINE QUERY BROWSE-9 FOR 
      T-CatVtaD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-11 W-Win _STRUCTURED
  QUERY BROWSE-11 NO-LOCK DISPLAY
      T-TABLA.NumId COLUMN-LABEL "" FORMAT ">>>9":U
      T-TABLA.Tabla COLUMN-LABEL "Articulo" FORMAT "x(12)":U
      descripcion-articulo(t-tabla.tabla) @ x-desmat-col COLUMN-LABEL "Descripcion" FORMAT "x(50)":U
            WIDTH 42.29
      T-TABLA.Evento COLUMN-LABEL "Valor Viejo" FORMAT "x(100)":U
            WIDTH 23.43
      T-TABLA.ValorLlave COLUMN-LABEL "Valor nuevo" FORMAT "x(100)":U
            WIDTH 44.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 18.08
         FONT 4 ROW-HEIGHT-CHARS .65 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 W-Win _STRUCTURED
  QUERY BROWSE-9 NO-LOCK DISPLAY
      T-CatVtaD.Libre_c01 COLUMN-LABEL "1" FORMAT "x(3)":U WIDTH 2.43
      T-CatVtaD.codmat COLUMN-LABEL "A      !Articulo" FORMAT "X(6)":U
            WIDTH 11
      T-CatVtaD.Libre_c04 COLUMN-LABEL "B               !Valor" FORMAT "x(60)":U
            WIDTH 14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 92.86 BY 4.23
         FONT 4
         TITLE "FORMATO DEL ARCHIVO EXCEL" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-5 AT ROW 1.19 COL 82 WIDGET-ID 2
     BUTTON-6 AT ROW 1.19 COL 98.72 WIDGET-ID 14
     COMBO-BOX-campo AT ROW 1.31 COL 29.57 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-msg AT ROW 1.31 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     BROWSE-11 AT ROW 2.73 COL 2 WIDGET-ID 200
     BROWSE-9 AT ROW 21.31 COL 3.14 WIDGET-ID 300
     "Campo a Actualizar ?" VIEW-AS TEXT
          SIZE 28.86 BY .77 AT ROW 1.27 COL 2.14 WIDGET-ID 12
          FGCOLOR 4 FONT 11
     "LA PRIMERA LINEA SOLO DEBE CONTENER LOS ENCABEZADOS DE LOS CAMPOS" VIEW-AS TEXT
          SIZE 61 BY .5 AT ROW 25.85 COL 4.14 WIDGET-ID 10
          BGCOLOR 1 FGCOLOR 15 
     RECT-2 AT ROW 20.92 COL 2 WIDGET-ID 8
     RECT-3 AT ROW 2.46 COL 1.43 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 133.43 BY 25.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CatVtaD T "?" NO-UNDO INTEGRAL AlmCatVtaD
      TABLE: T-TABLA T "?" NO-UNDO INTEGRAL logtabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ACTUALIZACION DEL CATALOGO DE ARTICULOS"
         HEIGHT             = 25.85
         WIDTH              = 133.43
         MAX-HEIGHT         = 31.35
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 31.35
         VIRTUAL-WIDTH      = 164.57
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-11 FILL-IN-msg F-Main */
/* BROWSE-TAB BROWSE-9 BROWSE-11 F-Main */
/* SETTINGS FOR BROWSE BROWSE-9 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-msg IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-11
/* Query rebuild information for BROWSE BROWSE-11
     _TblList          = "Temp-Tables.T-TABLA"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.T-TABLA.NumId
"T-TABLA.NumId" "" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-TABLA.Tabla
"T-TABLA.Tabla" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"descripcion-articulo(t-tabla.tabla) @ x-desmat-col" "Descripcion" "x(50)" ? ? ? ? ? ? ? no ? no no "42.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-TABLA.Evento
"T-TABLA.Evento" "Valor Viejo" "x(100)" "character" ? ? ? ? ? ? no ? no no "23.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-TABLA.ValorLlave
"T-TABLA.ValorLlave" "Valor nuevo" "x(100)" "character" ? ? ? ? ? ? no ? no no "44.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-11 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _TblList          = "Temp-Tables.T-CatVtaD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-CatVtaD.Libre_c01
"T-CatVtaD.Libre_c01" "1" "x(3)" "character" ? ? ? ? ? ? no ? no no "2.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-CatVtaD.codmat
"T-CatVtaD.codmat" "A      !Articulo" ? "character" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CatVtaD.Libre_c04
"T-CatVtaD.Libre_c04" "B               !Valor" ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-9 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ACTUALIZACION DEL CATALOGO DE ARTICULOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ACTUALIZACION DEL CATALOGO DE ARTICULOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-11
&Scoped-define SELF-NAME BROWSE-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-11 W-Win
ON ROW-DISPLAY OF BROWSE-11 IN FRAME F-Main
DO:
  RUN rowDisplay ( INPUT SELF, INPUT "*" ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
    ASSIGN combo-box-campo.

    RADIO-SET-Valor = combo-box-campo.

    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
    DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

    SYSTEM-DIALOG GET-FILE x-Archivo
        FILTERS "Archivos Excel (*.xls)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        RETURN-TO-START-DIR 
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.
    RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Procesar */
DO:
    /*
  IF radio-set-valor > 5 THEN DO:
      MESSAGE "Opcion aun no implementado" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
    */
    MESSAGE 'Esta seguro de procesar?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN cargar-valores.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-campo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-campo W-Win
ON VALUE-CHANGED OF COMBO-BOX-campo IN FRAME F-Main
DO:
    ASSIGN combo-box-campo.

    radio-set-valor = combo-box-campo.

    fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    IF radio-set-valor = 5 THEN DO:
        fill-in-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "( Ejm FFF-SSS )".
    END.

    RUN consistencias.
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

RUN GetColInfo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* PRIMERO BORRAMOS TODO EL DETALLE */
EMPTY TEMP-TABLE T-TABLA.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 7.

DEFINE VAR x-filer1 AS CHAR.
DEFINE VAR x-filer2 AS CHAR.

DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(x-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

t-Row = 1.     /* Saltamos el encabezado de los campos */

SESSION:SET-WAIT-STATE('GENERAL').

REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    /* ARTICULO */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):TEXT.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    ASSIGN
        cValue = STRING(INTEGER(cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN NEXT.

    CREATE T-TABLA.
    ASSIGN T-TABLA.codcia = s-codcia
        T-TABLA.Tabla = cValue.
    /* VALOR */
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):TEXT.
    ASSIGN
        T-TABLA.ValorLlave = cValue.    
END.

chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

DEFINE VAR x-delete AS LOG.

/* Consistencias */
FOR EACH T-TABLA:

    x-tipo-dato = 'N'.

    x-delete = NO.
    IF radio-set-valor = 3 THEN DO:

        x-tipo-dato = 'C'.

        /* Verificar si el codigo de Marca existe */
        FIND FIRST almtabla WHERE almtabla.tabla = 'MK' AND
                                    almtabla.codigo = T-TABLA.ValorLlave NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtabla THEN DO:
            DELETE T-TABLA.
            x-delete = YES.            
        END.
        ELSE DO:            
            ASSIGN T-TABLA.usuario = T-TABLA.ValorLlave
                    T-TABLA.ValorLlave = T-TABLA.ValorLlave + " " + almtabla.nombre.
        END.
    END.
    IF radio-set-valor = 4 THEN DO:
        /* Indice comercial */
        
        x-tipo-dato = 'C'.

        FIND FIRST almtabla WHERE almtabla.tabla = "IN_CO" AND
                                    almtabla.codigo = T-TABLA.ValorLlave NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtabla THEN DO:
            DELETE T-TABLA.
            x-delete = YES.            
        END.
        ELSE DO:            
            ASSIGN T-TABLA.usuario = T-TABLA.ValorLlave
                    T-TABLA.ValorLlave = T-TABLA.ValorLlave + " " + almtabla.nombre.
        END.
                                        
    END.
    IF radio-set-valor = 5 THEN DO:
        /* Familia y Sub-Familia */
        
        x-tipo-dato = 'C'.
        x-filer1 = ENTRY(1,T-TABLA.ValorLlave,"-") NO-ERROR.
        x-filer2 = ENTRY(2,T-TABLA.ValorLlave,"-") NO-ERROR.

        FIND FIRST almsfam WHERE almsfam.codcia = s-codcia AND
                                    almsfam.codfam = x-filer1 AND
                                    almsfam.subfam = x-filer2 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almsfam THEN DO:
            DELETE T-TABLA.
            x-delete = YES.            
        END.
        ELSE DO:            

            FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND
                                        almtfam.codfam = x-filer1 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE almtfam THEN DO:
                DELETE T-TABLA.
                x-delete = YES.            
            END.
            ELSE DO:
                ASSIGN T-TABLA.usuario = T-TABLA.ValorLlave.
                    T-TABLA.ValorLlave = T-TABLA.ValorLlave + " " + almtfam.desfam + "/" + almsfam.dessub.
            END.
        END.                                        
    END.
    IF radio-set-valor = 6 THEN DO:
        /* Categoria Contable */
        
        x-tipo-dato = 'C'.

        FIND FIRST almtabla WHERE almtabla.tabla = "CC" AND
                                    almtabla.codigo = T-TABLA.ValorLlave NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almtabla THEN DO:
            DELETE T-TABLA.
            x-delete = YES.            
        END.
        ELSE DO:            
            ASSIGN T-TABLA.usuario = T-TABLA.ValorLlave
                    T-TABLA.ValorLlave = T-TABLA.ValorLlave + " " + almtabla.nombre.
        END.
                                        
    END.
    IF radio-set-valor = 7 THEN DO:
        /* Proveedor */
        
        x-tipo-dato = 'C'.

        FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND 
                                    gn-prov.codpro = T-TABLA.ValorLlave NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN DO:
            DELETE T-TABLA.
            x-delete = YES.            
        END.
        ELSE DO:            
            ASSIGN T-TABLA.usuario = T-TABLA.ValorLlave
                    T-TABLA.ValorLlave = T-TABLA.ValorLlave + " " + gn-prov.nompro.
        END.
                                        
    END.
    IF radio-set-valor = 8 THEN DO:
        /* Activar / Desactivar */
        IF LOOKUP(T-TABLA.ValorLlave,"A,D,B") = 0 THEN DO:
            DELETE T-TABLA.
            x-delete = YES.            
        END.
        ELSE DO:
            x-filer1 = "OK".
            IF T-TABLA.ValorLlave = 'D' THEN DO:
                STOCKS:
                FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
                    AND Almmmate.codmat = T-TABLA.Tabla:
                    IF Almmmate.stkact <> 0 THEN DO:
                        x-filer1 = "ERROR".
                        LEAVE STOCKS.
                    END.
                END.
            END.
            IF x-filer1 <> "OK" THEN DO:
                DELETE T-TABLA.
                x-delete = YES.            
            END.
            ELSE DO:
                /**/
                ASSIGN T-TABLA.usuario = T-TABLA.ValorLlave.
                IF T-TABLA.ValorLlave = 'A' THEN ASSIGN T-TABLA.ValorLlave = T-TABLA.ValorLlave + " ACTIVAR".
                IF T-TABLA.ValorLlave = 'B' THEN ASSIGN T-TABLA.ValorLlave = T-TABLA.ValorLlave + " BAJA ROTACION".
                IF T-TABLA.ValorLlave = 'D' THEN ASSIGN T-TABLA.ValorLlave = T-TABLA.ValorLlave + " DESACTIVAR".
            END.
        END.
    END.

    IF x-delete = NO THEN DO:
        IF NOT CAN-FIND(Almmmatg WHERE Almmmatg.codcia = s-codcia
                        AND Almmmatg.codmat = T-TABLA.Tabla
                        NO-LOCK) THEN DO:
            DELETE T-TABLA.            
        END.
            
    END.
END.

t-Row = 1.
FOR EACH T-TABLA:
    ASSIGN t-tabla.numid = t-row.
    IF (T-TABLA.ValorLlave = ? OR T-TABLA.ValorLlave = "") THEN ASSIGN T-TABLA.ValorLlave = '0'.
    t-row = t-row + 1.
END.

RUN consistencias.

{&OPEN-QUERY-BROWSE-11}

SESSION:SET-WAIT-STATE('').

MESSAGE 'Importación terminada OK.' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-valores W-Win 
PROCEDURE cargar-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST t-tabla NO-ERROR.

IF NOT AVAILABLE t-tabla THEN DO:
    MESSAGE "No hay data que grabar".
    RETURN "ADM-ERROR".
END.
          
MESSAGE 'Seguro de GRABAR los datos?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

DEFINE VAR lValorNum AS DEC.
DEFINE VAR lValorTxt AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR nDatoNumOld AS DEC.
DEFINE VAR nDatoNumCur AS DEC.
DEFINE VAR cDatoStrOld AS CHAR.
DEFINE VAR cDatoStrCur AS CHAR.

DEFINE VAR nTotal AS INT INIT 0.
DEFINE VAR nActualizados AS INT INIT 0.
DEFINE VAR nOmitidos AS INT INIT 0.

/* Log */
DEFINE VAR cTabla AS CHAR.
DEFINE VAR cLlave AS CHAR.
DEFINE VAR cEvento AS CHAR.

ctabla = 'ALMMMATG'.

FOR EACH t-tabla :
    nTotal = nTotal + 1.
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                            almmmatg.codmat = t-tabla.tabla EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:

        cDatoStrOld = TRIM(t-tabla.Evento).
        nDatoNumOld = DEC(cDatoStrOld) NO-ERROR.

        cDatoStrCur = TRIM(t-tabla.ValorLlave).        
        nDatoNumCur = DEC(cDatoStrCur) NO-ERROR.

        IF (x-tipo-dato = 'N' AND nDatoNumOld <> nDatoNumCur) OR
            (x-tipo-dato = 'C' AND cDatoStrOld <> cDatoStrCur) THEN DO:

            nActualizados = nActualizados + 1.

            lValorTxt = TRIM(t-tabla.ValorLlave).
            lValorNum = DEC(lValorTxt) NO-ERROR.

            IF radio-set-valor = 1 THEN DO:
                /* Master */
                ASSIGN almmmatg.canemp = lValorNum.

                cEvento = 'MASTER'.
                cLlave = "Articulo(" + t-tabla.tabla + "), Valor Anterior(" + cDatoStrOld + "), " + 
                            "Valor Actual(" + cDatoStrCur + ")".
                RUN lib/logtabla.r(INPUT cTabla, INPUT cLlave, INPUT cEvento).

            END.
            IF radio-set-valor = 2 THEN DO:
                /* Inner */
                ASSIGN almmmatg.stkrep = lValorNum.

                cEvento = 'INNER'.
                cLlave = "Articulo(" + t-tabla.tabla + "), Valor Anterior(" + cDatoStrOld + "), " + 
                            "Valor Actual(" + cDatoStrCur + ")".
                RUN lib/logtabla.r(INPUT cTabla, INPUT cLlave, INPUT cEvento).
            END.
            IF radio-set-valor = 3 THEN DO:
                /* Marca */
                ASSIGN almmmatg.codmar = t-tabla.usuario.

                FIND FIRST almtabla WHERE almtabla.tabla = 'MK' AND
                                            almtabla.codigo = T-TABLA.usuario NO-LOCK NO-ERROR.
                IF AVAILABLE almtabla THEN DO:
                    ASSIGN almmmatg.desmar = almtabla.nombre.
                END.

                cEvento = 'MARCA'.
                cLlave = "Articulo(" + t-tabla.tabla + "), Valor Anterior(" + cDatoStrOld + "), " + 
                            "Valor Actual(" + cDatoStrCur + ")".
                RUN lib/logtabla.r(INPUT cTabla, INPUT cLlave, INPUT cEvento).
            END.
            IF radio-set-valor = 4 THEN DO:
                /* Indice Comercial */
                ASSIGN almmmatg.flgcomercial = t-tabla.usuario.

                cEvento = 'INDICE COMERCIAL'.
                cLlave = "Articulo(" + t-tabla.tabla + "), Valor Anterior(" + cDatoStrOld + "), " + 
                            "Valor Actual(" + cDatoStrCur + ")".
                RUN lib/logtabla.r(INPUT cTabla, INPUT cLlave, INPUT cEvento).
            END.
            IF radio-set-valor = 5 THEN DO:
                /* Familia y Sub-familia */
                ASSIGN almmmatg.codfam = ENTRY(1,t-tabla.usuario,"-")
                        almmmatg.subfam = ENTRY(2,t-tabla.usuario,"-").

                cEvento = 'FAMILIA_SUBFAMILIA'.
                cLlave = "Articulo(" + t-tabla.tabla + "), Valor Anterior(" + cDatoStrOld + "), " + 
                            "Valor Actual(" + cDatoStrCur + ")".
                RUN lib/logtabla.r(INPUT cTabla, INPUT cLlave, INPUT cEvento).
            END.
            IF radio-set-valor = 6 THEN DO:
                /* Categoria Contable */
                ASSIGN almmmatg.catconta[1] = t-tabla.usuario.

                cEvento = 'CATEGORIA CONTABLE'.
                cLlave = "Articulo(" + t-tabla.tabla + "), Valor Anterior(" + cDatoStrOld + "), " + 
                            "Valor Actual(" + cDatoStrCur + ")".
                RUN lib/logtabla.r(INPUT cTabla, INPUT cLlave, INPUT cEvento).
            END.
            IF radio-set-valor = 7 THEN DO:
                /* Proveedor */
                ASSIGN almmmatg.codpr1 = t-tabla.usuario.

                cEvento = 'PROVEEDOR'.
                cLlave = "Articulo(" + t-tabla.tabla + "), Valor Anterior(" + cDatoStrOld + "), " + 
                            "Valor Actual(" + cDatoStrCur + ")".
                RUN lib/logtabla.r(INPUT cTabla, INPUT cLlave, INPUT cEvento).
            END.
            IF radio-set-valor = 8 THEN DO:
                /* Activar / Desactivar */
                ASSIGN almmmatg.tpoart = t-tabla.usuario.

                cEvento = 'ACTIVAR/DESACTIVAR'.
                cLlave = "Articulo(" + t-tabla.tabla + "), Valor Anterior(" + cDatoStrOld + "), " + 
                            "Valor Actual(" + cDatoStrCur + ")".
                RUN lib/logtabla.r(INPUT cTabla, INPUT cLlave, INPUT cEvento).
            END.


        END.
        ELSE nOmitidos = nOmitidos + 1.
    END.
    ELSE nOmitidos = nOmitidos + 1.
    RELEASE almmmatg.
END.

/* Limpiamos temporal */
EMPTY TEMP-TABLE T-TABLA.
{&OPEN-QUERY-BROWSE-11}

SESSION:SET-WAIT-STATE('').

MESSAGE "   Total Registros :" + STRING(nTotal) SKIP 
        "Total Actualizados :" + STRING(nActualizados) SKIP
        "    Total Omitidos :" + STRING(nOmitidos).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consistencias W-Win 
PROCEDURE consistencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* Consistencias */
FOR EACH T-TABLA:
    FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
                    AND Almmmatg.codmat = T-TABLA.Tabla
                    NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        IF radio-set-valor = 1 THEN DO:
            /* Master */
            ASSIGN t-tabla.Evento = STRING(almmmatg.canemp).
            x-tipo-dato = 'N'.
        END.
        IF radio-set-valor = 2 THEN DO:
            /* Inner */
            ASSIGN t-tabla.evento = STRING(almmmatg.stkrep).
            x-tipo-dato = 'N'.
        END.
        IF radio-set-valor = 3 THEN DO:
            /* Marca */
            ASSIGN t-tabla.evento = STRING(almmmatg.codmar + " " + almmmatg.desmar).
            x-tipo-dato = 'C'.
        END.
        IF radio-set-valor = 4 THEN DO:
            /* Indice Comercial */
            ASSIGN t-tabla.evento = STRING(almmmatg.flgcomercial).
            x-tipo-dato = 'C'.
        END.        
        IF radio-set-valor = 5 THEN DO:
            /* Familia y Subfamilia */
            ASSIGN t-tabla.evento = STRING(almmmatg.codfam + "-" + almmmatg.subfam).
            x-tipo-dato = 'C'.
        END.        
        IF radio-set-valor = 6 THEN DO:

            /* Categoria Contable */
            ASSIGN t-tabla.evento = STRING(almmmatg.catconta[1]).
            x-tipo-dato = 'C'.
        END.
        IF radio-set-valor = 7 THEN DO:
            /* Proveedor */
            ASSIGN t-tabla.evento = STRING(almmmatg.codpr1).
            x-tipo-dato = 'C'.
        END.        
        IF radio-set-valor = 8 THEN DO:
            /* Activar/Desactivar */
            ASSIGN t-tabla.evento = STRING(almmmatg.tpoart).
            x-tipo-dato = 'C'.
        END.        

    END.
END.

FIND FIRST t-tabla NO-ERROR.

{&OPEN-QUERY-BROWSE-11}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-campo FILL-IN-msg 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RECT-3 BUTTON-5 BUTTON-6 COMBO-BOX-campo BROWSE-11 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetColInfo W-Win 
PROCEDURE GetColInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hBrws AS HANDLE NO-UNDO.
DEFINE VARIABLE hCol AS HANDLE NO-UNDO.

ASSIGN hBrws = BROWSE {&BROWSE-NAME}:HANDLE
       hCol = hBrws:FIRST-COLUMN.

CREATE ttBrws.

ASSIGN ttBrws.BrwsHdl = BROWSE {&BROWSE-NAME}:HANDLE
       ttBrws.BrwsName = ttBrws.BrwsHdl:NAME.

DO WHILE VALID-HANDLE(hCol):
    IF NOT CAN-FIND(FIRST ttCol WHERE ttCol.BrwsHdl = hBrws AND ttCol.ColHdl = hCol) THEN
        DO:
            CREATE ttCol.
            ASSIGN ttCol.BrwsHdl = hBrws
                   ttCol.ColHdl = hCol
                   ttCol.ColName = hCol:NAME
                   ttCol.ColWidth = hCol:WIDTH
                   ttCol.ColFormat = hCol:FORMAT
                   ttCol.ColDatTyp = hCol:DATA-TYPE
                   ttCol.ColLabel = hCol:LABEL.
        END.
        hCol = hCol:NEXT-COLUMN.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowdisplay W-Win 
PROCEDURE rowdisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phBrwsHdl AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER pcColList AS CHARACTER NO-UNDO.
    
DEFINE VAR nDatoNumOld AS DEC.
DEFINE VAR nDatoNumCur AS DEC.
DEFINE VAR cDatoStrOld AS CHAR.
DEFINE VAR cDatoStrCur AS CHAR.

cDatoStrOld = TRIM(t-tabla.Evento).
cDatoStrCur = TRIM(t-tabla.ValorLlave).
nDatoNumOld = DEC(cDatoStrOld) NO-ERROR.
nDatoNumCur = DEC(cDatoStrCur) NO-ERROR.

IF nDatoNumOld <> nDatoNumCur THEN DO:            
    FOR EACH ttCol NO-LOCK WHERE ttCol.BrwsHdl = phBrwsHdl:        
        IF CAN-DO(pcColList,ttCol.ColName) OR pcColList = "*" THEN
            ASSIGN ttCol.ColHdl:BGCOLOR = 14
                   /*ttCol.ColHdl:FGCOLOR = iFGColor*/.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-CatVtaD"}
  {src/adm/template/snd-list.i "T-TABLA"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION descripcion-articulo W-Win 
FUNCTION descripcion-articulo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS CHAR INIT "".

  FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                            almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
  IF AVAILABLE almmmatg THEN DO:
      x-retval = almmmatg.desmat.
  END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

