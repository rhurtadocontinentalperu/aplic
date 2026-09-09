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
DEFINE VAR x-tabla AS CHAR.

DEFINE BUFFER b-vtatabla FOR vtatabla.

DEFINE VAR x-total-digitos AS INT INIT 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-F[1] tt-w-report.Campo-C[3] ~
tt-w-report.Campo-C[4] tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] ~
tt-w-report.Campo-C[7] tt-w-report.Campo-C[8] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-nro-vale BROWSE-6 EDITOR-motivo ~
BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-2 FILL-IN-nro-vale EDITOR-motivo ~
FILL-IN-digitos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "DESACTIVAR VALES" 
     SIZE 18 BY 1.12.

DEFINE VARIABLE EDITOR-motivo AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 56 BY 2.46 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(100)":U INITIAL "DESACTIVACION DE VALES DE UTILEX" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-digitos AS CHARACTER FORMAT "X(4)":U INITIAL "0" 
      VIEW-AS TEXT 
     SIZE 7 BY .62
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-nro-vale AS INTEGER FORMAT ">>>>>>>>>9":U INITIAL 0 
     LABEL "Digite Nro del Vale" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .81
     FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 W-Win _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "Producto" FORMAT "X(6)":U
            WIDTH 6.43
      tt-w-report.Campo-C[2] COLUMN-LABEL "Nro d Vale" FORMAT "X(10)":U
            WIDTH 12.43
      tt-w-report.Campo-F[1] COLUMN-LABEL "Importe!Vale" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8.86
      tt-w-report.Campo-C[3] COLUMN-LABEL "Usuario!Activacion" FORMAT "X(15)":U
            WIDTH 9
      tt-w-report.Campo-C[4] COLUMN-LABEL "Fecha Hora!Activacion" FORMAT "X(20)":U
            WIDTH 16.43
      tt-w-report.Campo-C[5] COLUMN-LABEL "Cod.Doc!Activacion" FORMAT "X(4)":U
      tt-w-report.Campo-C[6] COLUMN-LABEL "Nro. Doc!Activacion" FORMAT "X(15)":U
            WIDTH 10
      tt-w-report.Campo-C[7] COLUMN-LABEL "Cod.Cliente" FORMAT "X(11)":U
            WIDTH 8.43
      tt-w-report.Campo-C[8] COLUMN-LABEL "Nombre de Cliente" FORMAT "X(80)":U
            WIDTH 19
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107.29 BY 14.04
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-2 AT ROW 1.19 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-nro-vale AT ROW 2.35 COL 15 COLON-ALIGNED WIDGET-ID 2
     BROWSE-6 AT ROW 3.5 COL 1.72 WIDGET-ID 200
     EDITOR-motivo AT ROW 18.27 COL 4 NO-LABEL WIDGET-ID 4
     BUTTON-1 AT ROW 18.69 COL 65 WIDGET-ID 6
     FILL-IN-digitos AT ROW 17.62 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     "Motivo de la desactivacion (maximo 200 caracteres)" VIEW-AS TEXT
          SIZE 37.43 BY .5 AT ROW 17.73 COL 4.57 WIDGET-ID 10
          BGCOLOR 15 FGCOLOR 12 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.86 BY 19.96
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
         TITLE              = "DESACTIVACION vales de utilex"
         HEIGHT             = 19.96
         WIDTH              = 108.86
         MAX-HEIGHT         = 19.96
         MAX-WIDTH          = 108.86
         VIRTUAL-HEIGHT     = 19.96
         VIRTUAL-WIDTH      = 108.86
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* BROWSE-TAB BROWSE-6 FILL-IN-nro-vale F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-digitos IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"Campo-C[1]" "Producto" "X(6)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"Campo-C[2]" "Nro d Vale" "X(10)" "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-F[1]
"Campo-F[1]" "Importe!Vale" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[3]
"Campo-C[3]" "Usuario!Activacion" "X(15)" "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[4]
"Campo-C[4]" "Fecha Hora!Activacion" "X(20)" "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[5]
"Campo-C[5]" "Cod.Doc!Activacion" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[6]
"Campo-C[6]" "Nro. Doc!Activacion" "X(15)" "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-C[7]
"Campo-C[7]" "Cod.Cliente" "X(11)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-C[8]
"Campo-C[8]" "Nombre de Cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "19" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DESACTIVACION vales de utilex */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DESACTIVACION vales de utilex */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* DESACTIVAR VALES */
DO:
  ASSIGN editor-motivo.

  FIND FIRST tt-w-report NO-LOCK NO-ERROR.
  IF NOT AVAILABLE tt-w-report THEN DO:
      MESSAGE "No hay vales para desactivar"
          VIEW-AS ALERT-BOX INFORMATION.
  END.

  IF TRUE <> (editor-motivo > "") THEN DO:
      MESSAGE "Ingrese el motivo de la desactivacion de los vales"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  IF x-total-digitos > 200 THEN DO:
      MESSAGE "El motivo solo debe tener maximo 200 caracteres"
          VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  MESSAGE 'Seguro de la desactivacion de los vales de utilex?' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  SESSION:SET-WAIT-STATE("GENERAL").

  x-tabla = "VUTILEXTCK".
  FOR EACH tt-w-report:

      ASSIGN tt-w-report.campo-c[10] = "".

      /* Que no este consumido */
      FIND FIRST vtadtickets WHERE vtadtickets.codcia = 1 AND
                                      vtadtickets.producto = tt-w-report.campo-c[1] AND
                                      vtadtickets.nrotck = tt-w-report.campo-c[2] NO-LOCK NO-ERROR.

      IF AVAILABLE vtadtickets THEN DO:     /* VALE ESTA CONSUMIDO */
          ASSIGN tt-w-report.campo-c[10] = "X".
          NEXT.
      END.

      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla AND
                                vtatabla.llave_c5 = tt-w-report.campo-c[2] EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE vtatabla THEN DO:
          ASSIGN vtatabla.libre_c03 = 'ANULADO' 
                  vtatabla.llave_c7 = STRING(TODAY,"99/99/9999") + ' ' + STRING(TIME,"HH:MM AM")
                  vtatabla.llave_c8 = USERID("DICTDB").

          /**/
          CREATE b-vtatabla.

              ASSIGN b-vtatabla.codcia = s-codcia
                      b-vtatabla.tabla = 'VUTILEX-EXTRAVIADOS'
                      b-vtatabla.llave_c1 = vtatabla.llave_c5 /*'000152842'*/
                      b-vtatabla.libre_c01 = editor-motivo   /* Motivo */
                      b-vtatabla.rango_fecha[1] = TODAY.

      END.
      ELSE DO:
          ASSIGN tt-w-report.campo-c[10] = "X".
      END.

      RELEASE vtatabla NO-ERROR.
      RELEASE b-vtatabla NO-ERROR.
                                
  END.

  FOR EACH tt-w-report:
        IF tt-w-report.campo-c[10] = "" THEN DO:
            DELETE tt-w-report.
        END.
  END.

  {&open-query-browse-6}

  SESSION:SET-WAIT-STATE("").

  FIND FIRST tt-w-report NO-LOCK NO-ERROR.
  IF AVAILABLE tt-w-report THEN DO:
      MESSAGE "Se quedaron algunos vales sin desactivar vuelva a intentar"
            VIEW-AS ALERT-BOX INFORMATION.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EDITOR-motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR-motivo W-Win
ON LEAVE OF EDITOR-motivo IN FRAME F-Main
DO:

    

    x-total-digitos = LENGTH(SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  fill-in-digitos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "200/" + STRING(x-total-digitos).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-nro-vale
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-nro-vale W-Win
ON LEAVE OF FILL-IN-nro-vale IN FRAME F-Main /* Digite Nro del Vale */
DO:

    ASSIGN fill-in-nro-vale.

  IF fill-in-nro-vale > 0 THEN DO:

      RUN verificar-vale.

      RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* TAB AUTOMATICO */
ON 'RETURN':U OF fill-in-nro-vale DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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
  DISPLAY FILL-IN-2 FILL-IN-nro-vale EDITOR-motivo FILL-IN-digitos 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-nro-vale BROWSE-6 EDITOR-motivo BUTTON-1 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificar-vale W-Win 
PROCEDURE verificar-vale :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-nro-vale AS CHAR.
DEFINE VAR x-producto AS CHAR.

x-nro-vale = STRING(fill-in-nro-vale,"999999999").
x-tabla = "VUTILEXTCK".

VALIDACION:
DO:
    FIND FIRST tt-w-report WHERE tt-w-report.campo-c[2] = x-nro-vale NO-LOCK NO-ERROR.
    IF AVAILABLE tt-w-report THEN DO:
        MESSAGE "El Nro. de vale YA lo registro, hace unos instantes"
            VIEW-AS ALERT-BOX INFORMATION.
        LEAVE VALIDACION.
    END.

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla AND
                                vtatabla.llave_c5 = x-nro-vale NO-LOCK NO-ERROR.
    IF NOT AVAILABLE vtatabla THEN DO:
        MESSAGE "El Nro. de vale no existe"
            VIEW-AS ALERT-BOX INFORMATION.
        LEAVE VALIDACION.
    END.

    IF vtatabla.libre_c03 = "ANULADO" OR vtatabla.libre_c03 = "BAJA" THEN DO:
        MESSAGE "El Nro. de vale esta declarado como ANULADO " SKIP
                "el dia " + TRIM(vtatabla.llave_c7) + ", por " + TRIM(vtatabla.llave_c8)
            VIEW-AS ALERT-BOX INFORMATION.
        LEAVE VALIDACION.
    END.

    IF TRUE <> (vtatabla.libre_c02 > "") OR TRUE <> (vtatabla.libre_c03 > "") THEN DO:
        MESSAGE "El Nro. de vale aun no esta ACTIVADO"
            VIEW-AS ALERT-BOX INFORMATION.
        LEAVE VALIDACION.
    END.

    x-producto = vtatabla.llave_c3.
    x-tabla = "VUTILEX-EXTRAVIADOS".

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla AND
                                vtatabla.llave_c1 = x-nro-vale NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        MESSAGE "El Nro. de vale esta declarado como PERDIDO"
            VIEW-AS ALERT-BOX INFORMATION.
        LEAVE VALIDACION.
    END.

    /* Si fue consumido */
    FIND FIRST vtadtickets WHERE vtadtickets.codcia = s-codcia AND
                                    vtadtickets.producto = x-producto AND
                                    vtadtickets.nrotck = x-nro-vale NO-LOCK NO-ERROR.
    IF AVAILABLE vtadtickets THEN DO:
        MESSAGE "El Nro. de vale ya fue consumido "
                "El dia " + STRING(vtadtickets.fecha,"99/99/9999 HH:MM:SS") + " por la tienda :" + TRIM(vtadtickets.coddiv)
                "La cajera es " + TRIM(vtadtickets.usuario) + " y cuyo nro de ingreso a caja es " + TRIM(vtadtickets.nroref)
            VIEW-AS ALERT-BOX INFORMATION.
        LEAVE VALIDACION.
    END.

    /**/

    x-tabla = "VUTILEXTCK".

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = x-tabla AND
                                vtatabla.llave_c5 = x-nro-vale NO-LOCK NO-ERROR.

    DEFINE VAR x-coddoc AS CHAR.
    DEFINE VAR x-nrodoc AS CHAR.

    x-coddoc = ENTRY(1,vtatabla.libre_c03,"|") NO-ERROR.
    x-nrodoc = ENTRY(2,vtatabla.libre_c03,"|") NO-ERROR.

    CREATE tt-w-report.
    ASSIGN tt-w-report.campo-c[1] = x-producto
            tt-w-report.campo-c[2] = x-nro-vale
            tt-w-report.campo-f[1] = DECIMAL(TRIM(vtatabla.llave_c4)) / 100
            tt-w-report.campo-c[3] = ENTRY(1,vtatabla.libre_c02,"|")
            tt-w-report.campo-c[4] = ENTRY(2,vtatabla.libre_c02,"|") + " " + ENTRY(3,vtatabla.libre_c02,"|")
            tt-w-report.campo-c[5] = x-coddoc
            tt-w-report.campo-c[6] = x-nrodoc.

    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                ccbcdocu.coddoc = x-coddoc AND
                                ccbcdocu.nrodoc = x-nrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        ASSIGN tt-w-report.campo-c[7] = ccbcdocu.codcli
                tt-w-report.campo-c[8] = ccbcdocu.nomcli.
    END.

    {&open-query-browse-6}
END.

fill-in-nro-vale:SET-SELECTION(1,LENGTH(x-nro-vale)) IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

