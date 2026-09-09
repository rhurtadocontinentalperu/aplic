&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE TEMP-TABLE tControlOD NO-UNDO LIKE ControlOD.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

DEFINE TEMP-TABLE txControlOD LIKE controlOD.

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pNroBultos AS INTE.
DEF OUTPUT PARAMETER pRpta AS CHAR.
DEF OUTPUT PARAMETER TABLE FOR txControlOD.


/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.

pRpta = "ADM-ERROR".

DEF NEW SHARED VAR lh_handle AS HANDLE.

DEFINE VAR iCriterioMostrar AS INT INIT 1.
DEFINE VAR cSimbolo AS CHAR INIT '[ X ]'.

DEFINE BUFFER tPEDI FOR PEDI.

DEFINE TEMP-TABLE tBultoArticulo
    FIELD codmat    AS  CHAR    FORMAT  'x(10)'  
    FIELD cbulto    AS  CHAR    FORMAT  'x(50)'

    INDEX idx01 codmat cbulto
    INDEX idx02 cbulto codmat.

DEFINE BUFFER ttControlOD FOR tControlOD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-20

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tControlOD PEDI Almmmatg

/* Definitions for BROWSE BROWSE-20                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-20 tControlOD.Sede tControlOD.NroEtq ~
tControlOD.PesArt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-20 
&Scoped-define QUERY-STRING-BROWSE-20 FOR EACH tControlOD ~
      WHERE iCriterioMostrar = 1 or ~
iCriterioMostrar = 2 and tControlOD.sede = cSimbolo or ~
iCriterioMostrar = 3 and tControlOD.sede = "" ~
 NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-20 OPEN QUERY BROWSE-20 FOR EACH tControlOD ~
      WHERE iCriterioMostrar = 1 or ~
iCriterioMostrar = 2 and tControlOD.sede = cSimbolo or ~
iCriterioMostrar = 3 and tControlOD.sede = "" ~
 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-20 tControlOD
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-20 tControlOD


/* Definitions for BROWSE BROWSE-21                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-21 PEDI.codmat Almmmatg.DesMat ~
PEDI.UndVta PEDI.CanPed PEDI.canate PEDI.Pesmat 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-21 
&Scoped-define QUERY-STRING-BROWSE-21 FOR EACH PEDI NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-21 OPEN QUERY BROWSE-21 FOR EACH PEDI NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-21 PEDI Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-21 PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-21 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-20}~
    ~{&OPEN-QUERY-BROWSE-21}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-20 BROWSE-21 RADIO-SET-cuales ~
BUTTON-39 BUTTON-41 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Bultos-1 FILL-IN_Bultos-2 ~
RADIO-SET-cuales FILL-IN-peso FILL-IN-bultos-seleccion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-39 
     LABEL "Desmarcar todos" 
     SIZE 19 BY .92.

DEFINE BUTTON BUTTON-40 
     LABEL "Filtrar" 
     SIZE 11 BY .77.

DEFINE BUTTON BUTTON-41 
     LABEL "Procesar bultos seleccionados" 
     SIZE 25 BY .77.

DEFINE VARIABLE FILL-IN-articulo AS CHARACTER FORMAT "X(10)":U 
     LABEL "Filtrar bultos del articulos" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-bultos-seleccion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Bultos seleccionados" 
      VIEW-AS TEXT 
     SIZE 12 BY .77
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-peso AS DECIMAL FORMAT "**,***,**9.99":U INITIAL 0 
     LABEL "Peso de la nueva OD" 
      VIEW-AS TEXT 
     SIZE 15.86 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN_Bultos-1 AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "# de Bultos Actual OD" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_Bultos-2 AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "# de Bultos Nueva OD" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cuales AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Solo los marcados", 2,
"Solo los desmarcados", 3
     SIZE 45.86 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-20 FOR 
      tControlOD SCROLLING.

DEFINE QUERY BROWSE-21 FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-20 D-Dialog _STRUCTURED
  QUERY BROWSE-20 NO-LOCK DISPLAY
      tControlOD.Sede COLUMN-LABEL "Sele" FORMAT "x(6)":U COLUMN-FONT 6
      tControlOD.NroEtq COLUMN-LABEL "Bulto" FORMAT "x(50)":U WIDTH 20.86
      tControlOD.PesArt COLUMN-LABEL "Peso!Kgrs" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 14.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 COLUMN-FONT 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 46 BY 10.38
         FONT 4
         TITLE "Bultos de la Orden" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-21
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-21 D-Dialog _STRUCTURED
  QUERY BROWSE-21 NO-LOCK DISPLAY
      PEDI.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 7.43
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 36.86
      PEDI.UndVta COLUMN-LABEL "Und!Vta" FORMAT "x(8)":U
      PEDI.CanPed COLUMN-LABEL "Cantidad!Total" FORMAT ">,>>>,>>9.9999":U
            WIDTH 10.14
      PEDI.canate COLUMN-LABEL "Cantidad!Fraccion" FORMAT ">,>>>,>>9.9999":U
            WIDTH 15.43 COLUMN-BGCOLOR 11 COLUMN-FONT 6
      PEDI.Pesmat COLUMN-LABEL "Peso!Kgrs" FORMAT "->>,>>9.9999":U
            WIDTH 10.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 COLUMN-FONT 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 92.43 BY 10.88
         FONT 4
         TITLE "Articulos de la Orden" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-20 AT ROW 1.12 COL 3 WIDGET-ID 200
     BROWSE-21 AT ROW 1.15 COL 50.57 WIDGET-ID 300
     FILL-IN-articulo AT ROW 11.73 COL 19 COLON-ALIGNED WIDGET-ID 14
     BUTTON-40 AT ROW 11.77 COL 32.57 WIDGET-ID 16
     FILL-IN_Bultos-1 AT ROW 12.35 COL 62 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_Bultos-2 AT ROW 12.35 COL 94 COLON-ALIGNED WIDGET-ID 4
     RADIO-SET-cuales AT ROW 12.92 COL 3.14 NO-LABEL WIDGET-ID 8
     BUTTON-39 AT ROW 13.77 COL 3 WIDGET-ID 6
     BUTTON-41 AT ROW 14.08 COL 58 WIDGET-ID 20
     Btn_OK AT ROW 14.27 COL 102
     Btn_Cancel AT ROW 14.27 COL 117
     FILL-IN-peso AT ROW 12.42 COL 142.29 RIGHT-ALIGNED WIDGET-ID 12
     FILL-IN-bultos-seleccion AT ROW 14.08 COL 42 COLON-ALIGNED WIDGET-ID 18
     SPACE(89.13) SKIP(1.60)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "FRANCCIONAMIENTO DE ORDENES"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
      TABLE: tControlOD T "?" NO-UNDO INTEGRAL ControlOD
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB BROWSE-20 1 D-Dialog */
/* BROWSE-TAB BROWSE-21 BROWSE-20 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-40 IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-40:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-articulo IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-articulo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-bultos-seleccion IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-peso IN FRAME D-Dialog
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       FILL-IN-peso:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_Bultos-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Bultos-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-20
/* Query rebuild information for BROWSE BROWSE-20
     _TblList          = "Temp-Tables.tControlOD"
     _Options          = "NO-LOCK"
     _Where[1]         = "iCriterioMostrar = 1 or
iCriterioMostrar = 2 and tControlOD.sede = cSimbolo or
iCriterioMostrar = 3 and tControlOD.sede = """"
"
     _FldNameList[1]   > Temp-Tables.tControlOD.Sede
"tControlOD.Sede" "Sele" "x(6)" "character" ? ? 6 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tControlOD.NroEtq
"tControlOD.NroEtq" "Bulto" "x(50)" "character" ? ? ? ? ? ? no ? no no "20.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tControlOD.PesArt
"tControlOD.PesArt" "Peso!Kgrs" ? "decimal" 14 0 6 ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-20 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-21
/* Query rebuild information for BROWSE BROWSE-21
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.Almmmatg OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "36.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" "Und!Vta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" "Cantidad!Total" ? "decimal" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.canate
"PEDI.canate" "Cantidad!Fraccion" ? "decimal" 11 ? 6 ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDI.Pesmat
"PEDI.Pesmat" "Peso!Kgrs" ? "decimal" 14 0 6 ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-21 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* FRANCCIONAMIENTO DE ORDENES */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-20
&Scoped-define SELF-NAME BROWSE-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-20 D-Dialog
ON MOUSE-SELECT-DBLCLICK OF BROWSE-20 IN FRAME D-Dialog /* Bultos de la Orden */
DO:
    DEFINE VAR cSigno AS CHAR.

    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.
    DEFINE VAR addRow AS INT.
    
    /* See if there are ANY rows in view... */
    IF SELF:NUM-ITERATIONS = 0 THEN 
    DO:
       /* No rows, the user clicked on an empty browse widget */ 
       RETURN NO-APPLY. 
    END.
    
    /* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
    SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
    hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
    iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
    iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
    iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */
    
    /* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
    dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
    iRow       = 1 + TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).
    
    /* Si tiene activo la barra de titulo en el browse cambia a 1 el addRow*/
    addRow = 1.
    
    IF iRow = 1  THEN DO:
        IF dRow > 1  THEN DO:
            iRow = iRow + addRow.
        END.
    END.
    ELSE DO:
        iRow = iRow + addRow.
    END.
    IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
    DO:
      /* The user clicked on a populated row */
      /*Your coding here, for example:*/
        SELF:DESELECT-ROWS().   /* Cuando esta activo multiseleccion del browse */
        SELF:SELECT-ROW(iRow).
    
        IF tControlOD.sede = '' THEN DO:
            ASSIGN tControlOD.sede = cSimbolo.
            cSigno = "+".
        END.
        ELSE DO:
            ASSIGN tControlOD.sede = ''.
            cSigno = '-'.
        END.

        RUN calcula-nuevo-bulto(tControlOD.nroetq, cSigno).

        RUN actualiza-pesos.
        
        {&open-query-browse-21}

        browse-20:REFRESH().
        
    END.
    ELSE DO:
      /* The click was on an empty row. */
      /*SELF:DESELECT-ROWS().*/
    
      RETURN NO-APPLY.
    END.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-20 D-Dialog
ON VALUE-CHANGED OF BROWSE-20 IN FRAME D-Dialog /* Bultos de la Orden */
DO:
/*
    IF NOT AVAILABLE tControlOD THEN RETURN.

    /* MESSAGE tControlOD.nroetq.*/
        DEFINE VAR cSigno AS CHAR.
    
        IF tControlOD.sede = '' THEN DO:
            ASSIGN tControlOD.sede = cSimbolo.
            cSigno = "+".
        END.
        ELSE DO:
            ASSIGN tControlOD.sede = ''.
            cSigno = '-'.
        END.

        RUN calcula-nuevo-bulto(tControlOD.nroetq, cSigno).

        RUN actualiza-pesos.
        
        {&open-query-browse-21}

        browse-20:REFRESH().  
    */

    DO WITH FRAME {&FRAME-NAME}:
        fill-in-bultos-seleccion:SCREEN-VALUE = STRING(browse-20:NUM-SELECTED-ROWS,"->>,>>>,>>9").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-21
&Scoped-define SELF-NAME BROWSE-21
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-21 D-Dialog
ON MOUSE-SELECT-DBLCLICK OF BROWSE-21 IN FRAME D-Dialog /* Articulos de la Orden */
DO:
  
    DEFINE VAR cSigno AS CHAR.

    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.
    DEFINE VAR addRow AS INT.
    
    /* See if there are ANY rows in view... */
    IF SELF:NUM-ITERATIONS = 0 THEN 
    DO:
       /* No rows, the user clicked on an empty browse widget */ 
       RETURN NO-APPLY. 
    END.
    
    /* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
    SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
    hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
    iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
    iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
    iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */
    
    /* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
    dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
    iRow       = 1 + TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).
    
    /* Si tiene activo la barra de titulo en el browse cambia a 1 el addRow*/
    addRow = 1.
    
    IF iRow = 1  THEN DO:
        IF dRow > 1  THEN DO:
            iRow = iRow + addRow.
        END.
    END.
    ELSE DO:
        iRow = iRow + addRow.
    END.
    IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
    DO:
      
      /* The user clicked on a populated row */
      /*Your coding here, for example:*/

        SELF:DESELECT-ROWS().   /* Cuando esta activo multiseleccion del browse */
        SELF:SELECT-ROW(iRow).        

        FOR EACH tBultoArticulo WHERE tBultoArticulo.codmat = pedi.codmat NO-LOCK:
            FIND FIRST ttControlOD WHERE ttControlOD.nroetq = tBultoArticulo.cbulto EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE ttControlOD THEN DO:
                IF ttControlOD.sede = '' THEN DO:
                    ASSIGN ttControlOD.sede = cSimbolo.
                    cSigno = "+".
                END.
                ELSE DO:
                    ASSIGN ttControlOD.sede = ''.
                    cSigno = '-'.
                END.
        
                RUN calcula-nuevo-bulto(ttControlOD.nroetq, cSigno).
        
                RUN actualiza-pesos.
            END.
        END.

        {&open-query-browse-21}

        browse-20:REFRESH().

    END.
    ELSE DO:
      /* The click was on an empty row. */
      /*SELF:DESELECT-ROWS().*/
    
      RETURN NO-APPLY.
    END.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    DEF VAR x-item AS INT NO-UNDO INIT 0.

    FIND faccfggn WHERE faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.

    FOR EACH pedi NO-LOCK WHERE PEDI.CanAte > 0:
        x-item = x-item + 1.
    END.
    IF x-Item = 0 THEN DO:
        MESSAGE 'NO hay registros que facturar' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    ASSIGN FILL-IN_Bultos-1 FILL-IN_Bultos-2.
    IF FILL-IN_Bultos-2 = 0 OR FILL-IN_Bultos-2 > FILL-IN_Bultos-1  THEN DO:
        MESSAGE 'Ingrese correctamente el # de Bultos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN_Bultos-2.
        RETURN NO-APPLY.
    END.

    MESSAGE 'Continúa con el Fraccionamiento de la OD?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE x-Rpta AS LOG.
    IF x-Rpta = NO THEN RETURN NO-APPLY.

    FOR EACH tControlOD WHERE tControlOD.sede = cSimbolo NO-LOCK:
        CREATE txControlOD.
        BUFFER-COPY tControlOD TO txControlOD.
    END.

    pNroBultos = FILL-IN_Bultos-2.
    pRpta = "OK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-39
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-39 D-Dialog
ON CHOOSE OF BUTTON-39 IN FRAME D-Dialog /* Desmarcar todos */
DO:

    DEFINE VAR cSigno AS CHAR.

    FOR EACH tControlOD:     

        IF tControlOD.sede = cSimbolo THEN DO:
            cSigno = '-'.

            RUN calcula-nuevo-bulto(tControlOD.nroetq, cSigno).
            ASSIGN tControlOD.sede = "".
        END.
        /*
        IF tControlOD.sede = '' THEN DO:
            ASSIGN tControlOD.sede = cSimbolo.
            cSigno = "+".
        END.
        ELSE DO:
            ASSIGN tControlOD.sede = ''.
            cSigno = '-'.
        END.

        ASSIGN tControlOD.sede = "".

        RUN calcula-nuevo-bulto(tControlOD.nroetq, cSigno).
        */
    END.

    RUN actualiza-pesos.
    
    {&open-query-browse-21}

    browse-20:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-41
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-41 D-Dialog
ON CHOOSE OF BUTTON-41 IN FRAME D-Dialog /* Procesar bultos seleccionados */
DO:
    DEFINE VAR cSigno AS CHAR.
    DEFINE VAR cOldSigno AS CHAR.

    DEFINE VAR iConteo AS INT.
    /*
    FOR EACH tControlOD:     
        IF tControlOD.sede = '' THEN DO:
            ASSIGN tControlOD.sede = cSimbolo.
            cSigno = "+".
        END.
        ELSE DO:
            ASSIGN tControlOD.sede = ''.
            cSigno = '-'.
        END.

        /*ASSIGN tControlOD.sede = "".*/

        RUN calcula-nuevo-bulto(tControlOD.nroetq, cSigno).
        
    END.
    */

    DO WITH FRAME {&FRAME-NAME}:

        DO iConteo = 1 TO browse-20:NUM-SELECTED-ROWS:
            IF browse-20:FETCH-SELECTED-ROW(iConteo) THEN DO:
                cOldSigno = {&FIRST-TABLE-IN-QUERY-browse-20}.sede:SCREEN-VALUE IN BROWSE browse-20.
                IF cOldSigno = "" THEN DO:
                    ASSIGN tControlOD.sede = cSimbolo.
                    cSigno = "+". 
                END.
                ELSE DO:
                    ASSIGN tControlOD.sede = ''.
                    cSigno = '-'. 
                END.

                RUN calcula-nuevo-bulto(tControlOD.nroetq, cSigno).

            END.
        END.
        /*
        GET FIRST browse-20.
        DO  WHILE AVAILABLE tControlOD:
            cOldSigno = {&FIRST-TABLE-IN-QUERY-browse-20}.sede:SCREEN-VALUE IN BROWSE browse-20.
            IF cOldSigno = "" THEN DO:
                ASSIGN tControlOD.sede = cSimbolo.
                cSigno = "+".
            END.
            ELSE DO:
                ASSIGN tControlOD.sede = ''.
                cSigno = '-'.
            END.
            /*
            ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.aftisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "NO".
            ASSIGN pedi.aftisc = NO.
            */
            GET NEXT browse-20.
        END.
        */
    END.


    RUN actualiza-pesos.
    
    {&open-query-browse-21}

    browse-20:REFRESH().  
END.

/*
    DO WITH FRAME {&FRAME-NAME}:
        GET FIRST {&BROWSE-NAME}.
        DO  WHILE AVAILABLE PEDI:
            ASSIGN {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.aftisc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "NO".
            ASSIGN pedi.aftisc = NO.
            GET NEXT {&BROWSE-NAME}.
        END.
    END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-articulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-articulo D-Dialog
ON LEAVE OF FILL-IN-articulo IN FRAME D-Dialog /* Filtrar bultos del articulos */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-cuales
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-cuales D-Dialog
ON VALUE-CHANGED OF RADIO-SET-cuales IN FRAME D-Dialog
DO:
  ASSIGN {&self-name}.

    iCriterioMostrar = {&self-name}.

    {&OPEN-QUERY-BROWSE-20}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-20
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

{src/adm/template/dialogmn.i}
/*
ON FIND OF tControlOD DO:
        /*
    If Condicion Then do:
        return error.
    end.

    RETURN.
    */
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualiza-pesos D-Dialog 
PROCEDURE actualiza-pesos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR dPesoTotal AS DEC.    
DEFINE VAR dCantidad AS DEC.

FOR EACH tPEDI WHERE tPEDI.canate > 0 NO-LOCK:

    dPesoTotal = dPesoTotal + tPEDI.pesmat.
END.

FILL-in-peso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(dPesoTotal,"->>,>>>,>>9.99").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula-nuevo-bulto D-Dialog 
PROCEDURE calcula-nuevo-bulto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pEtiqueta AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pSigno AS CHAR NO-UNDO.

FOR EACH logisdchequeo WHERE logisdchequeo.codcia = 1 AND 
                            logisdchequeo.etiqueta = pEtiqueta NO-LOCK :
    FIND FIRST PEDI WHERE PEDI.codmat = logisdchequeo.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE PEDI THEN DO:
        IF pSigno = "-" THEN DO:
            ASSIGN PEDI.canate = PEDI.canate - logisdchequeo.canped.
        END.
        ELSE DO:
            ASSIGN PEDI.canate = PEDI.canate + logisdchequeo.canped.
        END.

          FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND almmmatg.codmat = PEDI.codmat NO-LOCK NO-ERROR.
          IF AVAILABLE almmmatg THEN DO:
              ASSIGN PEDI.pesmat = ((PEDI.canate * PEDI.factor) * almmmatg.pesmat).
          END.

    END.
END.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN FILL-IN_bultos-2.
    IF pSigno = "-" THEN DO:
        FILL-IN_bultos-2 = FILL-IN_bultos-2 - 1.
    END.
    ELSE DO:
        FILL-IN_bultos-2 = FILL-IN_bultos-2 + 1.
    END.

    IF FILL-IN_bultos-2 < 0 THEN FILL-IN_bultos-2 = 0.

    FILL-IN_bultos-2:SCREEN-VALUE = STRING(FILL-IN_bultos-2,"->>,>>>,>>9").
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga D-Dialog 
PROCEDURE carga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR iItems AS INT.                                                
                                                
    FOR EACH PEDI WHERE PEDI.canate > 0 NO-LOCK:
        iItems = iItems + 1.
    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK.

  EMPTY TEMP-TABLE tControlOD.

  FOR EACH controlOD WHERE controlOD.codcia = faccpedi.codcia AND
                            controlOD.coddoc = faccpedi.coddoc AND
                            controlOD.nrodoc = faccpedi.nroped NO-LOCK:

      IF NOT TRUE <> (controlOD.ordcmp > "") THEN NEXT.

      CREATE tControlOD.
      BUFFER-COPY controlOD TO tControlOD.
      ASSIGN tControlOD.sede = cSimbolo.
      
  END.

  EMPTY TEMP-TABLE PEDI.
  FOR EACH facdpedi OF faccpedi NO-LOCK WHERE facdpedi.canped - facdpedi.canate > 0:
      CREATE PEDI.
      BUFFER-COPY facdpedi TO PEDI
          ASSIGN
            PEDI.canped = facdpedi.canped - facdpedi.canate
            PEDI.canate = facdpedi.canped - facdpedi.canate.
  END.

  FOR EACH Ccbcbult NO-LOCK WHERE CcbCBult.CodCia = Faccpedi.codcia AND
      CcbCBult.CodDoc = Faccpedi.coddoc AND
      CcbCBult.NroDoc = Faccpedi.nroped:
      FILL-IN_Bultos-1 = FILL-IN_Bultos-1 + CcbCBult.Bultos.
      FILL-IN_Bultos-2 = FILL-IN_Bultos-2 + CcbCBult.Bultos.
  END.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE  tBultoArticulo.
    FOR EACH tControlOD NO-LOCK:
        FOR EACH PEDI NO-LOCK:
            FIND FIRST logisdchequeo USE-INDEX idx02 WHERE logisdchequeo.codcia = tControlOD.codcia AND
                                            logisdchequeo.etiqueta = tControlOD.nroetq AND 
                                            logisdchequeo.codmat = pedi.codmat NO-LOCK NO-ERROR.
            IF AVAILABLE logisdchequeo THEN DO:
                CREATE tBultoArticulo.
                ASSIGN tBultoArticulo.codmat = pedi.codmat
                        tBultoArticulo.cbulto = tControlOD.nroetq.
            END.
        END.
    END.
    SESSION:SET-WAIT-STATE('').

/*
DEFINE TEMP-TABLE tBultoArticulo
    FIELD codmat    AS  CHAR    FORMAT  'x(10)'  
    FIELD cbulto    AS  CHAR    FORMAT  'x(50)'
*/


  /*
  EMPTY TEMP-TABLE PEDI.
  FOR EACH facdpedi OF faccpedi NO-LOCK WHERE facdpedi.canped - facdpedi.canate > 0:
      CREATE PEDI.
      BUFFER-COPY facdpedi TO PEDI
          ASSIGN
            PEDI.canped = facdpedi.canped - facdpedi.canate
            PEDI.canate = facdpedi.canped - facdpedi.canate.
  END.
  FOR EACH Ccbcbult NO-LOCK WHERE CcbCBult.CodCia = Faccpedi.codcia AND
      CcbCBult.CodDoc = Faccpedi.coddoc AND
      CcbCBult.NroDoc = Faccpedi.nroped:
      FILL-IN_Bultos-1 = FILL-IN_Bultos-1 + CcbCBult.Bultos.
      FILL-IN_Bultos-2 = FILL-IN_Bultos-2 + CcbCBult.Bultos.
  END.
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN_Bultos-1 FILL-IN_Bultos-2 RADIO-SET-cuales FILL-IN-peso 
          FILL-IN-bultos-seleccion 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-20 BROWSE-21 RADIO-SET-cuales BUTTON-39 BUTTON-41 Btn_OK 
         Btn_Cancel 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN actualiza-pesos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle D-Dialog 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN "Disable-All" THEN DO:
        DISABLE Btn_Cancel Btn_OK FILL-IN_Bultos-2  WITH FRAME {&FRAME-NAME}.
    END.
    WHEN "Enable-All" THEN DO:
        ENABLE Btn_Cancel Btn_OK FILL-IN_Bultos-2 WITH FRAME {&FRAME-NAME}.
    END.
END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "PEDI"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "tControlOD"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

