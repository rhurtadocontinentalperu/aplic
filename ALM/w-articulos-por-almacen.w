&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-Almmmatg NO-UNDO LIKE Almmmatg.



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

DEF VAR s-pagina-actual AS INTE INIT 1 NO-UNDO.
DEF VAR LocalCadena AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-codalm AS CHAR.

DEF VAR x-Tipo AS CHAR INIT "" NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\search.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmate t-Almmmatg Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Almmmate.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.TpoArt Almmmate.StkAct Almmmate.CodUbi ~
Almmmate.StkRep 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Almmmate ~
      WHERE Almmmate.CodCia = s-codcia ~
 AND Almmmate.CodAlm = s-codalm NO-LOCK, ~
      FIRST t-Almmmatg OF Almmmate OUTER-JOIN NO-LOCK, ~
      FIRST Almmmatg OF Almmmate ~
      WHERE (R-Tipo = "T" OR Almmmatg.TpoArt = R-Tipo) NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Almmmate ~
      WHERE Almmmate.CodCia = s-codcia ~
 AND Almmmate.CodAlm = s-codalm NO-LOCK, ~
      FIRST t-Almmmatg OF Almmmate OUTER-JOIN NO-LOCK, ~
      FIRST Almmmatg OF Almmmate ~
      WHERE (R-Tipo = "T" OR Almmmatg.TpoArt = R-Tipo) NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Almmmate t-Almmmatg Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Almmmate
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 t-Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-70 RECT-71 RECT-72 F-CodMat ~
BUTTON-Filtrar Btn-Asigna F-Filtro BUTTON-Filtrar-2 BUTTON-1 R-Tipo ~
BROWSE-2 
&Scoped-Define DISPLAYED-FIELDS Almmmate.FchIng Almmmate.AlmDes 
&Scoped-define DISPLAYED-TABLES Almmmate
&Scoped-define FIRST-DISPLAYED-TABLE Almmmate
&Scoped-Define DISPLAYED-OBJECTS F-CodMat F-Filtro R-Tipo FILL-IN_CodFam ~
FILL-IN-DesFam FILL-IN_subfam F-DesSub F-Empaque F-UndMed FILL-IN_UndStk ~
FILL-IN_UndBas 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-Btn-Asigna 
       MENU-ITEM m_Por_Articulos LABEL "Por Articulos" 
       MENU-ITEM m_Por_Familias LABEL "Por Familias"  
       MENU-ITEM m_Por_Proveedor LABEL "Por Proveedor" 
       MENU-ITEM m_Por_Marca    LABEL "Por Marca"     .


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Asigna 
     LABEL "A&SIGNAR" 
     SIZE 12 BY 1.08 TOOLTIP "Presione el boton derecho"
     FONT 6.

DEFINE BUTTON BUTTON-1 
     LABEL "ELIMINAR REGISTRO" 
     SIZE 20 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Filtrar-2 
     LABEL "LIMPIAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE F-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE F-Empaque AS CHARACTER FORMAT "X(256)":U 
     LABEL "Empaque" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE F-Filtro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripcion" 
     VIEW-AS FILL-IN 
     SIZE 49.29 BY .88 NO-UNDO.

DEFINE VARIABLE F-UndMed AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN_subfam AS CHARACTER FORMAT "X(3)" 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88.

DEFINE VARIABLE FILL-IN_UndBas AS CHARACTER FORMAT "X(6)" 
     LABEL "Unidad Basica" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE FILL-IN_UndStk AS CHARACTER FORMAT "X(6)" 
     LABEL "Unidad de Medida" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE R-Tipo AS CHARACTER INITIAL "T" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activos", "A",
"Inactivos", "D",
"Ambos", "T"
     SIZE 31 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 3.5.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 3.5.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 133 BY 4.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Almmmate, 
      t-Almmmatg, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Almmmate.codmat FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 69.86
      Almmmatg.DesMar FORMAT "X(30)":U
      Almmmatg.TpoArt FORMAT "X(1)":U
      Almmmate.StkAct FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
      Almmmate.CodUbi FORMAT "x(7)":U
      Almmmate.StkRep FORMAT "ZZ,ZZZ,ZZ9.99":U WIDTH 6.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 133 BY 18.31
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodMat AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 2
     BUTTON-Filtrar AT ROW 1.54 COL 71 WIDGET-ID 12
     Btn-Asigna AT ROW 2.08 COL 119 WIDGET-ID 18
     F-Filtro AT ROW 2.35 COL 11 COLON-ALIGNED WIDGET-ID 4
     BUTTON-Filtrar-2 AT ROW 2.88 COL 71 WIDGET-ID 16
     BUTTON-1 AT ROW 3.15 COL 111 WIDGET-ID 22
     R-Tipo AT ROW 3.42 COL 13.43 NO-LABEL WIDGET-ID 6
     BROWSE-2 AT ROW 4.5 COL 2 WIDGET-ID 200
     FILL-IN_CodFam AT ROW 23.35 COL 9 COLON-ALIGNED WIDGET-ID 36
     FILL-IN-DesFam AT ROW 23.35 COL 16.43 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     Almmmate.FchIng AT ROW 23.35 COL 71.43 COLON-ALIGNED WIDGET-ID 32 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     FILL-IN_subfam AT ROW 24.23 COL 9 COLON-ALIGNED WIDGET-ID 38
     F-DesSub AT ROW 24.23 COL 16.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     F-Empaque AT ROW 24.23 COL 71.43 COLON-ALIGNED WIDGET-ID 28
     F-UndMed AT ROW 24.23 COL 80.43 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     Almmmate.AlmDes AT ROW 25.12 COL 16.43 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .88
     FILL-IN_UndStk AT ROW 25.12 COL 71.43 COLON-ALIGNED WIDGET-ID 42
     FILL-IN_UndBas AT ROW 25.96 COL 16.43 COLON-ALIGNED WIDGET-ID 40
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.54 COL 6 WIDGET-ID 10
          FONT 4
     RECT-70 AT ROW 1 COL 2 WIDGET-ID 14
     RECT-71 AT ROW 1 COL 91 WIDGET-ID 20
     RECT-72 AT ROW 22.81 COL 2 WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 134.57 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-Almmmatg T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ARTICULOS POR ALMACEN"
         HEIGHT             = 26.15
         WIDTH              = 134.57
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 R-Tipo F-Main */
/* SETTINGS FOR FILL-IN Almmmate.AlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       Btn-Asigna:POPUP-MENU IN FRAME F-Main       = MENU POPUP-MENU-Btn-Asigna:HANDLE.

/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Empaque IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-UndMed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmate.FchIng IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_subfam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndBas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndStk IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.Almmmate,Temp-Tables.t-Almmmatg OF INTEGRAL.Almmmate,INTEGRAL.Almmmatg OF INTEGRAL.Almmmate"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST"
     _Where[1]         = "Almmmate.CodCia = s-codcia
 AND Almmmate.CodAlm = s-codalm"
     _Where[3]         = "(R-Tipo = ""T"" OR Almmmatg.TpoArt = R-Tipo)"
     _FldNameList[1]   = INTEGRAL.Almmmate.codmat
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "69.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMar
     _FldNameList[4]   = INTEGRAL.Almmmatg.TpoArt
     _FldNameList[5]   = INTEGRAL.Almmmate.StkAct
     _FldNameList[6]   = INTEGRAL.Almmmate.CodUbi
     _FldNameList[7]   > INTEGRAL.Almmmate.StkRep
"Almmmate.StkRep" ? ? "decimal" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ARTICULOS POR ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ARTICULOS POR ALMACEN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:
  IF AVAILABLE Almmmate THEN DO:
      DISPLAY 
          Almmmatg.codfam @ FILL-IN_CodFam
          Almmmatg.UndStk @ FILL-IN_UndStk 
          Almmmatg.UndStk @ F-UndMed
          Almmmatg.CanEmp @ F-Empaque
          Almmmatg.subfam @ FILL-IN_subfam 
          Almmmatg.undbas @ FILL-IN_UndBas
          Almmmate.FchIng
          Almmmate.AlmDes 
          WITH FRAME {&FRAME-NAME}.
      FIND Almtfami WHERE Almtfami.CodCia = Almmmate.CodCia AND 
          Almtfami.codfam = Almmmatg.codfam NO-LOCK NO-ERROR.
      IF AVAILABLE Almtfami THEN 
          DISPLAY Almtfami.desfam @ FILL-IN-DesFam WITH FRAME {&FRAME-NAME}.
      FIND AlmSFami WHERE AlmSFami.CodCia = Almmmate.CodCia AND
          AlmSFami.codfam = Almmmatg.codfam AND
          AlmSFami.subfam = Almmmatg.subfam NO-LOCK NO-ERROR.
      IF AVAILABLE AlmSFami THEN 
          DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Asigna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Asigna W-Win
ON CHOOSE OF Btn-Asigna IN FRAME F-Main /* ASIGNAR */
DO:
   MESSAGE "Presione el boton derecho" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ELIMINAR REGISTRO */
DO:
   RUN Delete-Record.
   /*IF RETURN-VALUE <> 'ADM-ERROR' THEN APPLY 'CHOOSE':U TO BUTTON-Filtrar-2 IN FRAME {&FRAME-NAME}.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTRO */
DO:
  ASSIGN 
      F-CodMat F-Filtro R-Tipo.
  x-Tipo = R-Tipo.
  IF x-Tipo = 'T' THEN x-Tipo = ''.
  /* Preparamos el query de acuerdo a las condiciones */
  DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.
  DEFINE VAR x-sql AS CHAR.

  hQueryHandle = BROWSE {&BROWSE-NAME}:QUERY.

  CASE TRUE:
      WHEN F-CodMat > '' THEN DO:
          hQueryHandle:QUERY-CLOSE().
          x-sql = "FOR EACH Almmmate WHERE Almmmate.codcia = " + STRING(s-codcia) + " AND ".
          x-sql = x-sql + "Almmmate.codalm = '" + s-codalm + "' AND ".
          x-sql = x-sql + "Almmmate.codmat = '" + F-CodMat + "' NO-LOCK, ".
          x-sql = x-sql + "FIRST t-Almmmatg OF Almmmate OUTER-JOIN NO-LOCK, ".
          x-sql = x-sql + "FIRST Almmmatg OF Almmmate NO-LOCK WHERE Almmmatg.tpoart BEGINS '" + x-Tipo + "' ".
          /*MESSAGE x-sql. RETURN.*/
          hQueryHandle:QUERY-PREPARE(x-sql).   
          hQueryHandle:QUERY-OPEN().
      END.
      WHEN F-Filtro > '' THEN DO:
          /* OJO: Este método es muy lento */
          DEF VAR LocalOrden AS INTE NO-UNDO.

          LocalCadena = "".
          DO LocalOrden = 1 TO NUM-ENTRIES(F-Filtro, " "):
              LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") + 
                  "*" + TRIM(ENTRY(LocalOrden,F-Filtro, " ")) + "*".
          END.

          Fi-Mensaje = "FILTRANDO INFORMACION".
          DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

          /* Preparamos el temporal */
          EMPTY TEMP-TABLE t-Almmmatg.
          FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND
              Almmmatg.desmat MATCHES LocalCadena AND
              Almmmatg.tpoart BEGINS x-Tipo:
              CREATE t-Almmmatg.
              BUFFER-COPY Almmmatg USING codcia codmat TO t-Almmmatg.
          END.

          hQueryHandle:QUERY-CLOSE().

          x-sql = "FOR EACH Almmmate WHERE Almmmate.codcia = " + STRING(s-codcia) + " AND ".
          x-sql = x-sql + "Almmmate.codalm = '" + s-codalm + "' NO-LOCK, ".
          x-sql = x-sql + "FIRST t-Almmmatg WHERE t-Almmmatg.codcia = Almmmate.codcia AND ".
          x-sql = x-sql + "t-Almmmatg.codmat = Almmmate.codmat NO-LOCK, ".
          x-sql = x-sql + "FIRST Almmmatg WHERE Almmmatg.codcia = Almmmate.codcia AND ".
          X-sql = X-sql + "Almmmatg.codmat = Almmmate.codmat NO-LOCK ".

          hQueryHandle:QUERY-PREPARE(x-sql).   
          hQueryHandle:QUERY-OPEN().

          HIDE FRAME F-Proceso.
      END.
      OTHERWISE DO:
          {&OPEN-QUERY-{&BROWSE-NAME}}
      END.
  END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar-2 W-Win
ON CHOOSE OF BUTTON-Filtrar-2 IN FRAME F-Main /* LIMPIAR FILTRO */
DO:
    F-CodMat = "".
    F-Filtro = "".
    R-Tipo = "T".
    x-Tipo = "".

    DISPLAY F-CodMat F-Filtro R-Tipo WITH FRAME {&FRAME-NAME}.

    {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodMat W-Win
ON LEAVE OF F-CodMat IN FRAME F-Main /* Codigo */
DO:
  /*IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.*/
  IF SELF:SCREEN-VALUE > '' THEN
      ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
        NO-ERROR.
  ASSIGN F-CodMat. 
  RUN dispatch IN THIS-PROCEDURE ('open-query':U)  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Filtro W-Win
ON LEAVE OF F-Filtro IN FRAME F-Main /* Descripcion */
OR "RETURN":U OF F-Filtro
DO:
  IF F-Filtro = F-Filtro:SCREEN-VALUE THEN RETURN.
  ASSIGN F-Filtro .
  RUN dispatch IN THIS-PROCEDURE ('open-query':U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Por_Articulos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Por_Articulos W-Win
ON CHOOSE OF MENU-ITEM m_Por_Articulos /* Por Articulos */
DO:
   RUN Asigna-por-Articulos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Por_Familias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Por_Familias W-Win
ON CHOOSE OF MENU-ITEM m_Por_Familias /* Por Familias */
DO:
  RUN Asigna-por-Familia.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Por_Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Por_Marca W-Win
ON CHOOSE OF MENU-ITEM m_Por_Marca /* Por Marca */
DO:
  RUN Asigna-por-Marca.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Por_Proveedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Por_Proveedor W-Win
ON CHOOSE OF MENU-ITEM m_Por_Proveedor /* Por Proveedor */
DO:
  RUN Asigna-por-Proveedor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Tipo W-Win
ON VALUE-CHANGED OF R-Tipo IN FRAME F-Main
DO:
  assign r-tipo.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Articulos W-Win 
PROCEDURE Asigna-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSige AS CHAR.

/* 25May2015 - Ic, validacion para almacen 11M */
lSige = 'SI'.
IF S-CODALM = '11M' THEN DO: 
    lSige = 'NO'.
    FIND almtabla WHERE almtabla.tabla = S-CODALM AND
         almtabla.codigo = Almmmatg.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla THEN DO:
        lSige = 'SI'.
    END.
END.

DEFINE VAR pMensaje AS CHAR NO-UNDO.
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN alm/almacen-library.p PERSISTENT SET hProc.

IF lSige = 'SI' THEN DO:
    RUN ALM_Materiales-por-Almacen IN hProc (INPUT S-CODALM,
                                             INPUT Almmmatg.CodMat,
                                             "M",
                                             OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
END.
DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-por-Articulos W-Win 
PROCEDURE Asigna-por-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Consistencia 28/10/2022 */
  FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm NO-LOCK.
  
  ASSIGN 
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
  RUN ALM\C-ASIGNA ("Asignacion de Articulos").
  /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
  IF output-var-2 > '' THEN DO:
      APPLY 'CHOOSE':U TO BUTTON-Filtrar-2 IN FRAME {&FRAME-NAME}.
    
      DEF BUFFER b-matg FOR Almmmate.
      FIND b-matg WHERE b-matg.codcia = s-codcia AND 
          b-matg.codalm = s-codalm AND 
          b-matg.codmat = output-var-2 NO-LOCK NO-ERROR.
      IF AVAILABLE b-matg THEN REPOSITION {&browse-name} TO ROWID ROWID(b-matg) NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-por-Familia W-Win 
PROCEDURE Asigna-por-Familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Consistencia 28/10/2022 */
FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm NO-LOCK.
IF Almacen.TdoArt = YES THEN DO:
    MESSAGE 'El almacén está configurado como "Asignación Automática"' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

RUN LKUP\C-Famili.r("Maestro de Familias").
IF output-var-1 <> ? AND output-var-2 <> "" THEN DO:
   FOR EACH Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.codfam = output-var-2:
       RUN Asigna-Articulos.
   END.
   HIDE FRAME F-Proceso.
   /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
   APPLY 'CHOOSE':U TO BUTTON-Filtrar-2 IN FRAME {&FRAME-NAME}.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-por-Marca W-Win 
PROCEDURE Asigna-por-Marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Consistencia 28/10/2022 */
FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm NO-LOCK.
IF Almacen.TdoArt = YES THEN DO:
    MESSAGE 'El almacén está configurado como "Asignación Automática"'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

input-var-1 = "MK".
RUN LKUP\C-almtab.r("Marcas").
IF output-var-1 <> ? AND output-var-2 <> "" THEN DO:
   FOR EACH Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.codmar = output-var-2:
       RUN Asigna-Articulos.
   END.
   HIDE FRAME F-Proceso.
   /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
   APPLY 'CHOOSE':U TO BUTTON-Filtrar-2 IN FRAME {&FRAME-NAME}.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-por-Proveedor W-Win 
PROCEDURE Asigna-por-Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Consistencia 28/10/2022 */
FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm NO-LOCK.
IF Almacen.TdoArt = YES THEN DO:
    MESSAGE 'El almacén está configurado como "Asignación Automática"'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

RUN CBD\C-provee.r("Maestro de Proveedores").
IF output-var-1 <> ? AND output-var-2 <> "" THEN DO:
   FOR EACH Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND Almmmatg.CodPr1 = output-var-2:
       RUN Asigna-Articulos.
   END.
   HIDE FRAME F-Proceso.
   /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
   APPLY 'CHOOSE':U TO BUTTON-Filtrar-2 IN FRAME {&FRAME-NAME}.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Delete-Record W-Win 
PROCEDURE Delete-Record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE Almmmate THEN RETURN 'OK'.

  MESSAGE 'Desea eliminar el código' Almmmate.codmat 'del almacén' Almmmate.codalm '?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN 'ADM-ERROR'.
 
  DEFINE VAR C-ALM AS CHAR NO-UNDO.

  FIND Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia AND 
      Almdmov.CodAlm = Almmmate.CodAlm AND
      Almdmov.CodMat = Almmmate.CodMat NO-LOCK NO-ERROR.
  IF AVAILABLE Almdmov THEN DO:
     MESSAGE "Material tiene movimientos" SKIP "No se puede eliminar" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".   
  END.
  
  /* Verificamos que no exista stock actual */
  IF Almmmate.StkAct > 0 THEN DO:
     MESSAGE "Material con stock actual" SKIP "No se puede eliminar" VIEW-AS ALERT-BOX ERROR.
     RETURN 'ADM-ERROR'.
  END.
  
  /* Actualizamos la lista de Almacenes */ 
  FIND CURRENT Almmmate EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN RETURN 'ADM-ERROR'.

  FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND Almmmatg.CodMat = Almmmate.CodMat EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
     C-ALM = TRIM(Almmmate.CodAlm) + ",".
     IF INDEX(Almmmatg.almacenes,C-ALM) = 0 THEN C-ALM = TRIM(Almmmate.CodAlm).
     ASSIGN Almmmatg.almacenes = REPLACE(Almmmatg.almacenes,C-ALM,"").
     RELEASE Almmmatg.
  END.
  DELETE Almmmate.
  RELEASE Almmmatg.
  RELEASE Almmmate.
  {&BROWSE-NAME}:DELETE-SELECTED-ROW(1) IN FRAME {&FRAME-NAME}.

  RETURN 'OK'.

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
  DISPLAY F-CodMat F-Filtro R-Tipo FILL-IN_CodFam FILL-IN-DesFam FILL-IN_subfam 
          F-DesSub F-Empaque F-UndMed FILL-IN_UndStk FILL-IN_UndBas 
      WITH FRAME F-Main IN WINDOW W-Win.
  IF AVAILABLE Almmmate THEN 
    DISPLAY Almmmate.FchIng Almmmate.AlmDes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-70 RECT-71 RECT-72 F-CodMat BUTTON-Filtrar Btn-Asigna F-Filtro 
         BUTTON-Filtrar-2 BUTTON-1 R-Tipo BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Selecciona-Pagina W-Win 
PROCEDURE Selecciona-Pagina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Si hay datos => página 2
   caso contrario => página 1
*/

CASE TRUE:
    WHEN TRUE <> ( F-Filtro > '' ) THEN DO:
        s-pagina-actual = 1.
        RUN select-page('1').
        RETURN '1'.
    END.
    OTHERWISE DO:
        s-pagina-actual = 2.
        RUN select-page('2').
        RETURN '2'.
    END.
END CASE.

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
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "t-Almmmatg"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

