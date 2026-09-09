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

DEFINE BUFFER b-almmmatg FOR almmmatg.
DEFINE BUFFER b-VtaDctoProm FOR VtaDctoProm.
DEFINE BUFFER b-VtaDctoPromMin FOR VtaDctoPromMin.
DEFINE BUFFER b-VtaListaMinGn FOR VtaListaMinGn.

DEF STREAM RPT-ERRORES.

DEFINE VAR x-Archivo-errores AS CHAR.

DEFINE VAR x-total AS INT NO-UNDO.
DEFINE VAR x-procesados AS INT NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 BUTTON-2 TOGGLE-clear ~
FILL-IN-txt BROWSE-2 TOGGLE-prom-may TOGGLE-vol-may TOGGLE-vol-utilex ~
TOGGLE-prom-utilex BUTTON-1 FILL-IN-ruta-errores BUTTON-9 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-clear FILL-IN-txt EDITOR-msg ~
TOGGLE-prom-may TOGGLE-vol-may TOGGLE-vol-utilex TOGGLE-prom-utilex ~
FILL-IN-ruta-errores FILL-IN_Mensaje FILL-IN-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "..." 
     SIZE 3.57 BY .77.

DEFINE BUTTON BUTTON-9 
     LABEL "..." 
     SIZE 3.57 BY .77.

DEFINE VARIABLE EDITOR-msg AS CHARACTER INITIAL "No aplica a  : 1.- Descuentos por VOLUMEN por DIVISION" 
     VIEW-AS EDITOR NO-BOX
     SIZE 38.57 BY 2.04
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(100)":U INITIAL "ELIMINAR DESCUENTOS PROMOCIONALES y/o VOLUMEN" 
      VIEW-AS TEXT 
     SIZE 80 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-ruta-errores AS CHARACTER FORMAT "X(150)":U 
     LABEL "Ruta ARTICULOS no procesados" 
     VIEW-AS FILL-IN 
     SIZE 72 BY .73
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-txt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 72 BY .73
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN_Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 98 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY 3.46.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53 BY .15.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 1 BY 3.46.

DEFINE VARIABLE TOGGLE-clear AS LOGICAL INITIAL no 
     LABEL "LIMPIAR antes de cargar" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.86 BY .77
     FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE TOGGLE-prom-may AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-prom-utilex AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-vol-may AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-vol-utilex AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Codigo" FORMAT "X(8)":U
            WIDTH 5.43
      tt-w-report.Campo-C[2] COLUMN-LABEL "Descripcion del Articulo" FORMAT "X(80)":U
            WIDTH 42.29
      tt-w-report.Campo-C[3] COLUMN-LABEL "Marca" FORMAT "X(25)":U
            WIDTH 21.86
      tt-w-report.Campo-C[4] COLUMN-LABEL "Linea" FORMAT "X(60)":U
            WIDTH 29.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 104 BY 13.85
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 2.27 COL 75.43 WIDGET-ID 28
     TOGGLE-clear AT ROW 2.27 COL 81 WIDGET-ID 30
     FILL-IN-txt AT ROW 2.31 COL 1.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     BROWSE-2 AT ROW 3.23 COL 2.43 WIDGET-ID 200
     EDITOR-msg AT ROW 17.35 COL 62.43 NO-LABEL WIDGET-ID 40
     TOGGLE-prom-may AT ROW 18.58 COL 36.72 WIDGET-ID 6
     TOGGLE-vol-may AT ROW 18.62 COL 51.14 WIDGET-ID 10
     TOGGLE-vol-utilex AT ROW 19.5 COL 51.14 WIDGET-ID 12
     TOGGLE-prom-utilex AT ROW 19.54 COL 36.86 WIDGET-ID 8
     BUTTON-1 AT ROW 19.58 COL 63.43 WIDGET-ID 24
     FILL-IN-ruta-errores AT ROW 20.92 COL 24 COLON-ALIGNED WIDGET-ID 44
     BUTTON-9 AT ROW 20.92 COL 99 WIDGET-ID 46
     FILL-IN_Mensaje AT ROW 21.73 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     FILL-IN-2 AT ROW 1.19 COL 10.43 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     "TIENDAS MINORISTAS" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 19.62 COL 10.43 WIDGET-ID 34
          FGCOLOR 9 
     "TIENDAS MAYORISTAS" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 18.73 COL 10.43 WIDGET-ID 32
          FGCOLOR 9 
     "PROMOCIONES" VIEW-AS TEXT
          SIZE 11.72 BY .62 AT ROW 17.54 COL 32.86 WIDGET-ID 14
          FGCOLOR 4 
     "VOLUMEN" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 17.54 COL 47.43 WIDGET-ID 16
          FGCOLOR 4 
     RECT-1 AT ROW 17.27 COL 7.43 WIDGET-ID 18
     RECT-2 AT ROW 18.31 COL 7.43 WIDGET-ID 20
     RECT-3 AT ROW 17.27 COL 30.43 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 106 BY 21.77
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "ELIMINAR descuentos por PROMOCION y VOLUMEN"
         HEIGHT             = 21.77
         WIDTH              = 106
         MAX-HEIGHT         = 21.77
         MAX-WIDTH          = 109.86
         VIRTUAL-HEIGHT     = 21.77
         VIRTUAL-WIDTH      = 109.86
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
/* BROWSE-TAB BROWSE-2 FILL-IN-txt F-Main */
/* SETTINGS FOR EDITOR EDITOR-msg IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       EDITOR-msg:RETURN-INSERTED IN FRAME F-Main  = TRUE
       EDITOR-msg:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-ruta-errores:READ-ONLY IN FRAME F-Main        = TRUE.

ASSIGN 
       FILL-IN-txt:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_Mensaje IN FRAME F-Main
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
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Descripcion del Articulo" "X(80)" "character" ? ? ? ? ? ? no ? no no "42.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "Marca" "X(25)" "character" ? ? ? ? ? ? no ? no no "21.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Linea" "X(60)" "character" ? ? ? ? ? ? no ? no no "29.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ELIMINAR descuentos por PROMOCION y VOLUMEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ELIMINAR descuentos por PROMOCION y VOLUMEN */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:

    FIND FIRST tt-w-report NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-w-report THEN DO:
        MESSAGE "Cargue Articulos para poder procesar!!!"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN fill-in-ruta-errores.
    END.

    IF TRUE <> (fill-in-ruta-errores > "") THEN DO:
        MESSAGE "Seleccione una RUTA en donde grabar el archivo de texto" SKIP
                "con los articulos que no se pudieron procesar"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    

    DO WITH FRAME {&FRAME-NAME} :
        ASSIGN toggle-prom-may toggle-vol-may.
        ASSIGN toggle-prom-utilex toggle-vol-utilex.
    END.
    
    IF toggle-prom-may = NO AND toggle-vol-may = NO AND
        toggle-prom-utilex = NO AND toggle-vol-utilex = NO THEN DO:
        MESSAGE "Seleccione al menos una opcion PROMOCIONES y/o VOLUMENES"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    MESSAGE 'Seguro de realizar con el proceso?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

        
    RUN Procesar.

    IF x-procesados = x-total THEN DO:
    MESSAGE "Se procesaron la cantidad de :" SKIP
            STRING(x-procesados) + " de " + STRING(x-total) + " Articulos"
            VIEW-AS ALERT-BOX INFORMATION.
    END.
    ELSE DO:
        MESSAGE "Se procesaron la cantidad de :" SKIP
            STRING(x-procesados) + " de " + STRING(x-total) + " Articulos" SKIP
            "Los ARTICULOS NO PROCESADOS se guardaron en : " SKIP 
            x-Archivo-errores
            VIEW-AS ALERT-BOX INFORMATION.
    END.
/*     FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''. */
/*     EMPTY TEMP-TABLE tt-w-report.                             */
/*     {&OPEN-QUERY-{&BROWSE-NAME}}                              */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ... */
DO:
   DEFINE VAR X-archivo AS CHAR.
   DEFINE VAR OKpressed AS LOG.

          SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.txt)" "*.txt"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN RETURN. 

      fill-in-txt:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-archivo.

      RUN cargar-txt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* ... */
DO:
   DEFINE VAR X-ruta AS CHAR.

        SYSTEM-DIALOG GET-DIR x-ruta  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.
        IF x-ruta <> "" THEN DO:
        fill-in-ruta-errores:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-ruta.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-txt W-Win 
PROCEDURE cargar-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME} :
        ASSIGN fill-in-txt toggle-clear.
    END.

    IF toggle-clear = YES THEN DO:
        EMPTY TEMP-TABLE tt-w-report.
    END.
     
    DEFINE VAR xlineatextto AS CHAR.
    DEFINE VAR x-codmat AS CHAR.
                 
    IF SEARCH(FILL-IN-txt) <> ? THEN DO:
        OUTPUT TO VALUE(FILL-IN-txt) APPEND.
        PUT UNFORMATTED "?" CHR(10) SKIP.
        OUTPUT CLOSE.
        INPUT FROM VALUE(FILL-IN-txt).
        REPEAT:
            IMPORT UNFORMATTED xlineatextto.
            x-codmat = TRIM(xlineatextto).
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                        almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
            IF AVAILABLE almmmatg THEN DO:

                FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.

                FIND FIRST tt-w-report WHERE tt-w-report.task-no = 999 AND
                                                tt-w-report.llave-c = x-codmat EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE tt-w-report THEN DO:
                    CREATE tt-w-report.
                    ASSIGN tt-w-report.task-no = 999
                            tt-w-report.llave-c = x-codmat
                            tt-w-report.campo-c[1] = x-codmat
                            tt-w-report.campo-c[2] = almmmatg.desmat
                            tt-w-report.campo-c[3] = almmmatg.desmar
                            tt-w-report.campo-c[4] = almtfam.desfam.
                END.
            END.

            /*
            CREATE tt-articulos.
            
            ASSIGN t-codmat = SUBSTRING(xlineatextto,1,6)
                    t-cuantos = int(SUBSTRING(xlineatextto,7,1)).
            IF t-codmat = '' THEN ASSIGN t-codmat = "?".        
            */
        END.
        INPUT CLOSE.
    END.

    {&Open-query-browse-2}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-dscto-promo-mayorista W-Win 
PROCEDURE elimina-dscto-promo-mayorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMat AS CHAR.


FOR EACH VtaDctoProm WHERE VtaDctoProm.codcia = s-codcia AND
    VtaDctoProm.codmat = pCodMat NO-LOCK:

    FIND FIRST b-VtaDctoProm WHERE ROWID(VtaDctoProm) = ROWID(b-VtaDctoProm) EXCLUSIVE-LOCK NO-ERROR .
    IF AVAILABLE b-VtaDctoProm THEN DO:
        DELETE b-VtaDctoProm.
    END.
    ELSE DO:
        RETURN ERROR.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-dscto-promo-utilex W-Win 
PROCEDURE elimina-dscto-promo-utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMat AS CHAR.

FOR EACH VtaDctoPromMin WHERE VtaDctoPromMin.codcia = s-codcia AND
    VtaDctoPromMin.codmat = pCodMat NO-LOCK:

    FIND FIRST b-VtaDctoPromMin WHERE ROWID(VtaDctoPromMin) = ROWID(b-VtaDctoPromMin) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b-VtaDctoPromMin THEN DO:
        DELETE b-VtaDctoPromMin.
    END.
    ELSE DO:
        RETURN ERROR.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-dscto-vol-mayorista W-Win 
PROCEDURE elimina-dscto-vol-mayorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodMat AS CHAR.


DEFINE VAR x-sec AS INT.

FIND FIRST b-almmmatg WHERE b-almmmatg.codcia = s-codcia AND
    b-almmmatg.codmat = pCodmat EXCLUSIVE-LOCK NO-ERROR.
IF LOCKED b-almmmatg THEN DO:
    RETURN ERROR.
END.
IF AVAILABLE b-almmmatg THEN DO:
    REPEAT x-sec = 1 TO 10:
        ASSIGN 
            b-almmmatg.DtoVOLR[x-sec] = 0
            b-almmmatg.DtoVOLD[x-sec] = 0.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-dscto-vol-utilex W-Win 
PROCEDURE elimina-dscto-vol-utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMat AS CHAR.


DEFINE VAR x-sec AS INT.

FIND FIRST b-VtaListaMinGn WHERE b-VtaListaMinGn.codcia = s-codcia AND
    b-VtaListaMinGn.codmat = pCodmat EXCLUSIVE-LOCK NO-ERROR.
IF LOCKED b-VtaListaMinGn THEN DO:
    RETURN ERROR.
END.
IF AVAILABLE b-VtaListaMinGn THEN DO:
    REPEAT x-sec = 1 TO 10:
        ASSIGN 
            b-VtaListaMinGn.DtoVOLR[x-sec] = 0
            b-VtaListaMinGn.DtoVOLD[x-sec] = 0.
    END.
END.

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
  DISPLAY TOGGLE-clear FILL-IN-txt EDITOR-msg TOGGLE-prom-may TOGGLE-vol-may 
          TOGGLE-vol-utilex TOGGLE-prom-utilex FILL-IN-ruta-errores 
          FILL-IN_Mensaje FILL-IN-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 RECT-3 BUTTON-2 TOGGLE-clear FILL-IN-txt BROWSE-2 
         TOGGLE-prom-may TOGGLE-vol-may TOGGLE-vol-utilex TOGGLE-prom-utilex 
         BUTTON-1 FILL-IN-ruta-errores BUTTON-9 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-LogTabla W-Win 
PROCEDURE Graba-LogTabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER x-Procesados AS INTE.
  DEF INPUT PARAMETER x-Total AS INTE.

  CREATE LogTabla.
  ASSIGN
      logtabla.codcia = s-codcia
      logtabla.Dia = TODAY
      logtabla.Evento = 'ELIMINA-PROM-VOL'
      logtabla.Hora = STRING(TIME, 'HH:MM')
      logtabla.Tabla = 'ALMMMATG'
      logtabla.Usuario = USERID("DICTDB")
      logtabla.ValorLlave = "SE PROCESARON LA CANTIDAD DE " + STRING(x-procesados) + " de " + STRING(x-total) + " Articulos"
      .
  ASSIGN
      logtabla.ValorLlave = logtabla.ValorLlave + " - " + (IF TOGGLE-prom-may = YES THEN "Prom Mayoristas" ELSE "") + " " +
      (IF TOGGLE-vol-may = YES THEN "Vol Mayoristas" ELSE "") + " " +
      (IF TOGGLE-prom-utilex = YES THEN "Prom Minoristas" ELSE "") + " " +
      (IF TOGGLE-vol-utilex = YES THEN "Vol Minoristas" ELSE "").
      
 RELEASE LogTabla. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  editor-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO APLICA A  : " + CHR(13) + CHR(10) +
                              "   1.- Descuentos por VOLUMEN por DIVISION" + CHR(13) + CHR(10) +
                              "   2.- Listas de Precios".


  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    GRABANDO:
    DO TRANSACTION ON ERROR UNDO, LEAVE:
        /* Descuento x VOLUMEN MAYORISTAS */
        IF toggle-vol-may = YES THEN DO:    
            RUN elimina-dscto-vol-mayorista (INPUT tt-w-report.campo-c[1]) NO-ERROR.
            If ERROR-STATUS:ERROR THEN DO:
                UNDO GRABANDO, RETURN 'ADM-ERROR'.
            END.
        END.
        /* Descuento PROMOCIONAL MAYORISTAS */
        IF toggle-prom-may = YES THEN DO:
            RUN elimina-dscto-promo-mayorista (INPUT tt-w-report.campo-c[1]) NO-ERROR.
            If ERROR-STATUS:ERROR THEN DO:
                UNDO GRABANDO, RETURN 'ADM-ERROR'.
            END.
        END.
        /* Descuento x VOLUMEN UTILEX */
        IF toggle-vol-utilex = YES THEN DO:
            RUN elimina-dscto-vol-utilex (INPUT tt-w-report.campo-c[1]) NO-ERROR.
            If ERROR-STATUS:ERROR THEN DO:
                UNDO GRABANDO, RETURN 'ADM-ERROR'.
            END.

        END.
        /* Descuento PROMOCIONAL UTILEX */
        IF toggle-prom-utilex = YES THEN DO:
            RUN elimina-dscto-promo-utilex (INPUT tt-w-report.campo-c[1]) NO-ERROR.
            If ERROR-STATUS:ERROR THEN DO:
                UNDO GRABANDO, RETURN 'ADM-ERROR'.
            END.
        END.
    END.         
    IF AVAILABLE(b-almmmatg)        THEN RELEASE b-almmmatg.
    IF AVAILABLE(b-vtadctoprom)     THEN RELEASE b-VtaDctoProm.
    IF AVAILABLE(b-vtadctoprommin)  THEN RELEASE b-VtaDctoPromMin.
    IF AVAILABLE(b-vtalistamingn)   THEN RELEASE b-VtaListaMinGn.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesar W-Win 
PROCEDURE Procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DISABLE TRIGGERS FOR LOAD OF VtaDctoProm.
DISABLE TRIGGERS FOR LOAD OF VtaDctoPromMin.
DISABLE TRIGGERS FOR LOAD OF Almmmatg.
DISABLE TRIGGERS FOR LOAD OF VtaListaMinGn.

/**/
SESSION:SET-WAIT-STATE("GENERAL").

ASSIGN
    x-Total = 0
    x-Procesados = 0.
FOR EACH tt-w-report TRANSACTION:
    ASSIGN tt-w-report.campo-c[10] = "X".

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
        almmmatg.codmat = tt-w-report.campo-c[1] NO-LOCK NO-ERROR.

    x-total = x-total + 1.
    IF NOT AVAILABLE Almmmatg THEN NEXT.

    FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        "PROCESANDO >>> " + STRING(x-Total) + " - " + Almmmatg.codmat + " " + Almmmatg.desmat.

    RUN MASTER-TRANSACTION.
    IF RETURN-VALUE <> 'ADM-ERROR' THEN DO:
        ASSIGN tt-w-report.campo-c[10] = "".
    END.

    x-procesados = x-procesados + 1.
END.

RUN Graba-LogTabla (INPUT x-Procesados, INPUT x-Total).

RUN Report-Error (INPUT x-Procesados, INPUT x-Total).

SESSION:SET-WAIT-STATE("").

FILL-IN_Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Report-Error W-Win 
PROCEDURE Report-Error :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-Procesados AS INTE.
DEF INPUT PARAMETER x-Total AS INTE.

x-Archivo-errores = "".

IF x-procesados < x-total THEN DO:    
    x-Archivo-errores = STRING(TODAY,"99/99/9999") + "_" + STRING(TIME,"HH:MM:SS").
    x-Archivo-errores = REPLACE(x-Archivo-errores,"/","-").
    x-Archivo-errores = REPLACE(x-Archivo-errores,":","-").
    x-Archivo-errores = "NO-PROCESADOS-" + x-Archivo-errores.
    
    x-Archivo-errores = TRIM(fill-in-ruta-errores) + "\" + x-Archivo-errores + ".txt".

    OUTPUT STREAM RPT-errores TO VALUE (x-Archivo-errores).

    FOR EACH tt-w-report WHERE tt-w-report.campo-c[10] = "X":
        PUT STREAM RPT-ERRORES TRIM(tt-w-report.campo-c[1]) SKIP.
        ASSIGN tt-w-report.campo-c[10] = "".
    END.

    OUTPUT STREAM RPT-errores CLOSE.
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

