&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEF VAR s-tipmov AS CHAR INIT 'I' NO-UNDO.
DEF VAR s-codmov AS INT INIT 03 NO-UNDO.

DEFINE NEW SHARED VARIABLE C-CODMOV AS CHAR INIT '14'.  /* Reclasificación */
DEFINE NEW SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE NEW SHARED VARIABLE lh_Handle AS HANDLE.
DEFINE NEW SHARED VARIABLE L-NROSER AS CHAR.    /* Nº Serie Válidos */

DEFINE VAR x-tabla AS CHAR INIT "PACKS-ECOMERCE".

DEFINE TEMP-TABLE x-tt-w-report LIKE tt-w-report.
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER B-DMOV FOR Almdmov.

DEFINE TEMP-TABLE ttItemSalidas
    FIELD   tCodMat     AS  CHAR    FORMAT 'x(6)'
    FIELD   tCodpack    AS  CHAR    FORMAT 'x(6)'
    FIELD   tCant       AS  DEC INIT 0
    FIELD   tundStk     AS  CHAR.
DEFINE TEMP-TABLE ttItemIngresos
    FIELD   tCodpack    AS  CHAR    FORMAT 'x(6)'
    FIELD   tCant       AS  DEC INIT 0
    FIELD   tundStkpack AS  CHAR.

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
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-w-report.Campo-C[3] ~
tt-w-report.Campo-C[4] tt-w-report.Campo-C[5] tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-F[1] tt-w-report.Campo-F[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-C[11] ~
       BY tt-w-report.Campo-C[10] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-C[11] ~
       BY tt-w-report.Campo-C[10] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 BUTTON-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS txtMSG 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Refrescar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Generar Movimientos" 
     SIZE 20 BY 1.15.

DEFINE VARIABLE txtMSG AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 86.86 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-w-report.Campo-C[3] COLUMN-LABEL "Cod.Pack" FORMAT "X(6)":U
            WIDTH 10.14
      tt-w-report.Campo-C[4] COLUMN-LABEL "Descripcion-Pack" FORMAT "X(60)":U
            WIDTH 38.43 COLUMN-FONT 1
      tt-w-report.Campo-C[5] COLUMN-LABEL "Cant." FORMAT "X(12)":U
      tt-w-report.Campo-C[1] COLUMN-LABEL "CodMat" FORMAT "X(6)":U
            WIDTH 9.43
      tt-w-report.Campo-C[2] COLUMN-LABEL "Descripcion" FORMAT "X(60)":U
            WIDTH 38.43 COLUMN-FONT 1
      tt-w-report.Campo-F[1] COLUMN-LABEL "Cant." FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.72
      tt-w-report.Campo-F[2] COLUMN-LABEL "Stock" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 10.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 134 BY 23.65 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.73 COL 3 WIDGET-ID 200
     txtMSG AT ROW 25.73 COL 1.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BUTTON-2 AT ROW 25.77 COL 92 WIDGET-ID 4
     BUTTON-1 AT ROW 25.81 COL 117 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 136.86 BY 26.12 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reclasificacion INVERSA"
         HEIGHT             = 26.12
         WIDTH              = 136.86
         MAX-HEIGHT         = 26.12
         MAX-WIDTH          = 137.43
         VIRTUAL-HEIGHT     = 26.12
         VIRTUAL-WIDTH      = 137.43
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
/* BROWSE-TAB BROWSE-2 1 F-Main */
/* SETTINGS FOR FILL-IN txtMSG IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST,"
     _OrdList          = "Temp-Tables.tt-w-report.Campo-C[11]|yes,Temp-Tables.tt-w-report.Campo-C[10]|yes"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Cod.Pack" "X(6)" "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Descripcion-Pack" "X(60)" "character" ? ? 1 ? ? ? no ? no no "38.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Cant." "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "CodMat" "X(6)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Descripcion" "X(60)" "character" ? ? 1 ? ? ? no ? no no "38.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-F[1]
"tt-w-report.Campo-F[1]" "Cant." "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-F[2]
"tt-w-report.Campo-F[2]" "Stock" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reclasificacion INVERSA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reclasificacion INVERSA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Refrescar */
DO:
  RUN cargar-informacion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Generar Movimientos */
DO:
        MESSAGE 'Seguro de gemerar movimientos?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN genera-movimiento.

    RUN cargar-informacion.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-informacion W-Win 
PROCEDURE cargar-informacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").                     
                     
EMPTY TEMP-TABLE tt-w-report.
EMPTY TEMP-TABLE x-tt-w-report.

FOR EACH vtadtabla WHERE vtadtabla.codcia = s-codcia AND
                            vtadtabla.tabla = x-tabla NO-LOCK:

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = vtadtabla.llavedetalle
                        NO-LOCK NO-ERROR.

    FIND FIRST vtactabla WHERE vtactabla.codcia = vtadtabla.codcia AND
                                vtactabla.tabla = vtadtabla.tabla AND 
                                vtactabla.llave = vtadtabla.llave 
                                NO-LOCK NO-ERROR.

    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND 
                                almmmate.codalm = s-codalm AND
                                almmmate.codmat = vtadtabla.llavedetalle
                                NO-LOCK NO-ERROR.

    IF AVAILABLE almmmate AND almmmate.stkact > 0 THEN DO:
        CREATE tt-w-report.
        ASSIGN tt-w-report.campo-c[1] = vtadtabla.llavedetalle
                tt-w-report.campo-c[2] = IF(AVAILABLE almmmatg) THEN almmmatg.desmat ELSE "<< ERROR >>"
                tt-w-report.campo-f[1] = vtadtabla.libre_d01
                tt-w-report.campo-f[2] = almmmate.stkact
                tt-w-report.campo-c[3] = IF(AVAILABLE vtactabla) THEN vtactabla.llave ELSE "<< ERROR >>"
                tt-w-report.campo-c[4] = IF(AVAILABLE vtactabla) THEN vtactabla.descripcion ELSE "<< ERROR >>"
                tt-w-report.campo-f[3] = IF(AVAILABLE vtactabla) THEN vtactabla.libre_d01 ELSE 0
                tt-w-report.campo-c[5] = STRING(tt-w-report.campo-f[3],">>>,>>9.99")
                tt-w-report.campo-c[10] = vtadtabla.llavedetalle
                tt-w-report.campo-c[11] = IF(AVAILABLE vtactabla) THEN vtactabla.llave ELSE "<< ERROR >>".

    END.
END.

DEFINE VAR x-pack AS CHAR INIT "".

FOR EACH tt-w-report :
    IF tt-w-report.campo-c[11] <> x-pack THEN DO:
        /**/
    END.
    ELSE DO:
        ASSIGN tt-w-report.campo-c[3] = ""
        tt-w-report.campo-c[4] = ""
        tt-w-report.campo-f[3] = 0
        tt-w-report.campo-c[5] = "".

    END.

    x-pack = tt-w-report.campo-c[11].
END.

{&OPEN-QUERY-BROWSE-2}

SESSION:SET-WAIT-STATE("").

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
  DISPLAY txtMSG 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-2 BUTTON-2 BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera-movimiento W-Win 
PROCEDURE genera-movimiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ttItemSalidas.
EMPTY TEMP-TABLE ttItemIngresos.

DEFINE VAR x-cont AS INT.
DEFINE VAR x-total AS INT.

DEFINE VAR x-codmat AS CHAR.
DEFINE VAR x-codpack AS CHAR.

DEFINE VAR x-stkact AS DEC.
DEFINE VAR x-cant-sugerida AS DEC.
DEFINE VAR x-cant AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

/*  */
DO WITH FRAME {&FRAME-NAME}:
    x-total = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO x-Cont = 1 TO x-total :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-cont) THEN DO:
            x-codmat = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[1].
            x-codpack = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-c[11].

            x-cant-sugerida = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[1].
            x-stkact = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[2].

            /* Salidas */
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                        almmmatg.codmat = x-codmat
                                        NO-LOCK NO-ERROR.
            FIND FIRST ttItemSalidas WHERE ttItemSalidas.tcodmat = x-codmat AND
                                    ttItemSalidas.tcodpack = x-codpack NO-ERROR.
            IF NOT AVAILABLE ttItemSalidas THEN DO:
                CREATE ttItemSalidas.
                ASSIGN ttItemSalidas.tcodmat = x-codmat
                        ttItemSalidas.tcodpack = x-codpack
                        ttItemSalidas.tUndStk = IF (AVAILABLE almmmatg) THEN almmmatg.undstk ELSE "UNI".
            END.
            ASSIGN ttItemSalidas.tcant = ttItemSalidas.tCant + x-stkact.

            /* Ingresos */
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                        almmmatg.codmat = x-codpack
                                        NO-LOCK NO-ERROR.
            FIND FIRST ttItemIngresos WHERE ttItemIngresos.tcodpack = x-codpack NO-ERROR.
            IF NOT AVAILABLE ttItemIngresos THEN DO:
                CREATE ttItemIngresos.
                ASSIGN ttItemIngresos.tcodpack = x-codpack
                        ttItemIngresos.tUndStkPack = IF (AVAILABLE almmmatg) THEN almmmatg.undstk ELSE "UNI".
            END.
            ASSIGN ttItemIngresos.tcant = ttItemIngresos.tCant + x-stkact.

        END.
    END.
END.

FIND FIRST ttItemSalidas NO-ERROR.
IF NOT AVAILABLE ttItemSalidas THEN DO:
    MESSAGE "No existen movimientos para reclasificar".
    RETURN "ADM-ERROR".
END.

/* CONSISTENCIA DE MOVIMIENTOS */
FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
    AND Almtdocm.CodAlm = s-codalm
    AND Almtdocm.TipMov = 'I'
    AND Almtdocm.CodMov = INTEGER (c-codmov)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'Movimiento de entrada' c-codmov 'NO configurado en el almacén' s-codalm
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
    AND Almtdocm.CodAlm = s-codalm
    AND Almtdocm.TipMov = 'S'
    AND Almtdocm.CodMov = INTEGER (c-codmov)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'Movimiento de salida' c-codmov 'NO configurado en el almacén' s-codalm
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* */

DEFINE VAR f-TPOCMB AS DEC.
DEFINE VAR cMensaje AS CHAR.

FIND LAST gn-tcmb NO-LOCK NO-ERROR.
IF AVAILABLE gn-tcmb THEN f-TPOCMB = gn-tcmb.compra.

FIND FIRST Almtdocm WHERE Almtdocm.CodCia = S-CODCIA 
    AND Almtdocm.CodAlm = S-CODALM 
    AND Almtdocm.TipMov = "S" 
    AND LOOKUP(STRING(Almtdocm.CodMov, '99'), C-CODMOV) > 0
    NO-LOCK NO-ERROR.

DEF VAR x-CorrSal LIKE Almacen.CorrSal NO-UNDO.
DEF VAR x-CorrIng LIKE Almacen.CorrIng NO-UNDO.

cMensaje = "".

tGrabarMovimientos:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
  {lib/lock-genericov3.i 
      &Tabla="Almacen "
      &Condicion="Almacen.CodCia = s-CodCia AND Almacen.CodAlm = s-CodAlm"
      &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
      &Accion="RETRY"
      &Mensaje="NO"
      &txtMensaje="cMensaje"
      &TipoError="UNDO, RETURN 'ADM-ERROR'"}
  /* ********************************************************************************* */
  /* CABECERAS */
  /* ********************************************************************************* */
  SALIDAS:
  REPEAT:
      ASSIGN
          x-CorrSal = Almacen.CorrSal.
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                      AND Almcmov.codalm = Almtdocm.CodAlm
                      AND Almcmov.tipmov = "S"
                      AND Almcmov.codmov = Almtdocm.CodMov
                      AND Almcmov.nroser = s-NroSer
                      AND Almcmov.nrodoc = x-CorrSal
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          Almacen.CorrSal = Almacen.CorrSal + 1.
  END.
  INGRESOS:
  REPEAT:
      ASSIGN
          x-CorrIng = Almacen.CorrIng.
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                      AND Almcmov.codalm = Almtdocm.CodAlm
                      AND Almcmov.tipmov = "I"
                      AND Almcmov.codmov = Almtdocm.CodMov
                      AND Almcmov.nroser = s-NroSer
                      AND Almcmov.nrodoc = x-CorrIng
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          Almacen.CorrIng = Almacen.CorrIng + 1.
  END.

    txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Creando SALIDA".
    /* MOVIMIENTO DE SALIDA */
    CREATE Almcmov.
    ASSIGN 
      Almcmov.CodCia = Almtdocm.CodCia 
      Almcmov.CodAlm = Almtdocm.CodAlm 
      Almcmov.TipMov = 'S'
      Almcmov.CodMov = Almtdocm.CodMov
      Almcmov.NroSer = S-NROSER
      Almcmov.Nrodoc  = Almacen.CorrSal
      Almcmov.HorSal = STRING(TIME,"HH:MM:SS")
      Almcmov.TpoCmb  = F-TPOCMB
      Almcmov.NroRf1 = ""
      Almcmov.usuario = S-USER-ID NO-ERROR.

    IF ERROR-STATUS:ERROR = YES THEN DO:
        UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
    END.

    txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Creando INGRESO".
  /* MOVIMIENTO DE ENTRADA */
  CREATE B-CMOV.
  BUFFER-COPY Almcmov 
      TO B-CMOV
      ASSIGN
      B-CMOV.TipMov = "I"
      B-CMOV.Nrodoc = Almacen.CorrIng
      B-CMOV.NroRef = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999') NO-ERROR.
  IF ERROR-STATUS:ERROR = YES THEN DO:
      UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
  END.

  ASSIGN 
      Almcmov.NroRef = STRING(B-CMOV.nroser, '999') + STRING(B-CMOV.nrodoc, '9999999').
  ASSIGN
      Almacen.CorrSal = Almacen.CorrSal + 1
      Almacen.CorrIng = Almacen.CorrIng + 1.
  ASSIGN 
      Almcmov.usuario = S-USER-ID.

  /* ********************************************************************************* */
  /* DETALLES */
  /* ********************************************************************************* */
  DEF VAR N-Itm AS INTEGER NO-UNDO.
  DEF VAR r-Rowid AS ROWID NO-UNDO.
  DEF VAR pComprometido AS DEC.

  txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Creando SALIDAS detalle".

  /* SALIDAS */
  N-Itm = 0.
  FOR EACH ttItemSalidas NO-LOCK:

      N-Itm = N-Itm + 1.
      CREATE almdmov.
      ASSIGN 
          Almdmov.CodCia = Almcmov.CodCia 
          Almdmov.CodAlm = Almcmov.CodAlm 
          Almdmov.TipMov = Almcmov.TipMov 
          Almdmov.CodMov = Almcmov.CodMov 
          Almdmov.NroSer = Almcmov.NroSer 
          Almdmov.NroDoc = Almcmov.NroDoc 
          Almdmov.CodMon = Almcmov.CodMon 
          Almdmov.FchDoc = Almcmov.FchDoc 
          Almdmov.TpoCmb = Almcmov.TpoCmb
          Almdmov.codmat = ttItemSalidas.tcodmat
          Almdmov.CanDes = ttItemSalidas.tCant
          Almdmov.CodUnd = ttItemSalidas.tUndStk
          Almdmov.Factor = 1
          Almdmov.PreBas = 0
          Almdmov.ImpCto = 0
          Almdmov.PreUni = 0
          Almdmov.NroItm = N-Itm
          Almdmov.CodAjt = ''
          Almdmov.HraDoc = almcmov.HorSal
          R-ROWID = ROWID(Almdmov) NO-ERROR.

        IF ERROR-STATUS:ERROR = YES THEN DO:
            UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
        END.

      FIND Almmmatg OF Almdmov NO-LOCK NO-ERROR.
      IF NOT AVAILABLE almmmatg THEN DO:
        UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          Almdmov.CodUnd = Almmmatg.UndStk.

      txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Creando SALIDAS detalle - almdcstk".
      RUN alm/almdcstk (R-ROWID).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.

      txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Creando SALIDAS detalle - almacpr1".
      RUN ALM\ALMACPR1 (R-ROWID,"U").
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
  END.

  txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Creando INGRESO detalle".
  /* INGRESOS */
  N-Itm = 0.
  FOR EACH ttItemIngresos NO-LOCK:

      txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Creando INGRESO detalle(" + ttItemIngresos.tCodPack + ")".

      N-Itm = N-Itm + 1.
      CREATE almdmov.
      ASSIGN 
          Almdmov.CodCia = B-CMOV.CodCia 
          Almdmov.CodAlm = B-CMOV.CodAlm 
          Almdmov.TipMov = B-CMOV.TipMov 
          Almdmov.CodMov = B-CMOV.CodMov 
          Almdmov.NroSer = B-CMOV.NroSer 
          Almdmov.NroDoc = B-CMOV.NroDoc 
          Almdmov.CodMon = B-CMOV.CodMon 
          Almdmov.FchDoc = B-CMOV.FchDoc 
          Almdmov.TpoCmb = B-CMOV.TpoCmb
          Almdmov.codmat = ttItemIngresos.tCodPack
          Almdmov.CanDes = ttItemIngresos.tCant
          Almdmov.CodUnd = ttItemIngresos.tUndStkPack
          Almdmov.Factor = 1
          Almdmov.PreBas = 0
          Almdmov.ImpCto = 0
          Almdmov.PreUni = 0
          Almdmov.NroItm = N-Itm
          Almdmov.CodAjt = ''
          Almdmov.HraDoc = B-CMOV.HorSal
          R-ROWID = ROWID(Almdmov) NO-ERROR.

      IF ERROR-STATUS:ERROR = YES THEN DO:
          UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
      END.

      FIND Almmmatg OF Almdmov NO-LOCK NO-ERROR.
      IF NOT AVAILABLE almmmatg THEN DO:
        UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
      END.

      ASSIGN
          Almdmov.CodUnd = Almmmatg.UndStk.
      /*
      ASSIGN 
          Almdmov.CanDes = Almdmov.candes + ITEM.CanDes
          Almdmov.ImpCto = ITEM.ImpCto
          Almdmov.PreUni = (ITEM.ImpCto / ITEM.CanDes).
      */
      /* fin de valorizaciones */
      FIND FIRST Almtmovm WHERE Almtmovm.CodCia = B-CMOV.CodCia 
          AND  Almtmovm.Tipmov = B-CMOV.TipMov 
          AND  Almtmovm.Codmov = B-CMOV.CodMov 
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtmovm AND Almtmovm.PidPCo 
          THEN ASSIGN Almdmov.CodAjt = "A".
      ELSE ASSIGN Almdmov.CodAjt = ''.

      txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Creando INGRESOS detalle - almdcstk".
      RUN ALM\ALMACSTK (R-ROWID).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.

      txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Creando INGRESOS detalle - almacpr1".
      RUN ALM\ALMACPR1 (R-ROWID,"U").
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'. 

  END.
END.

RELEASE almdmov.
RELEASE almcmov.
RELEASE B-CMOV.
RELEASE B-DMOV.
RELEASE Almacen.

SESSION:SET-WAIT-STATE('').

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
  {src/adm/template/snd-list.i "tt-w-report"}

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

