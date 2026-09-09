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

DEF SHARED VAR s-codcia AS INTE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-Almmmatg

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 t-Almmmatg.codmat t-Almmmatg.DesMat ~
t-Almmmatg.DesMar t-Almmmatg.UndStk t-Almmmatg.Dec__01 t-Almmmatg.Dec__02 ~
t-Almmmatg.Libre_c03 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH t-Almmmatg NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH t-Almmmatg NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 t-Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 t-Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON_Texto COMBO-BOX_CodAlm ~
BUTTON_Texto-2 FILL-IN_Porcentaje BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Temporada COMBO-BOX_CodAlm ~
FILL-IN_Porcentaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1  NO-FOCUS
     LABEL "PROCESAR" 
     SIZE 33 BY 1.88
     BGCOLOR 14 FGCOLOR 0 FONT 8.

DEFINE BUTTON BUTTON_Texto 
     LABEL "TEXTO RA" 
     SIZE 25 BY 1.88 TOOLTIP "Texto para REPOSICION AUTOMATICA"
     BGCOLOR 10 FGCOLOR 0 FONT 8.

DEFINE BUTTON BUTTON_Texto-2 
     LABEL "TEXTO JJLL" 
     SIZE 25 BY 1.88 TOOLTIP "Texto para JEFES DE LINEA"
     BGCOLOR 10 FGCOLOR 0 FONT 8.

DEFINE VARIABLE COMBO-BOX_CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "11w" 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 90 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Temporada AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.15
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN_Porcentaje AS DECIMAL FORMAT ">>9.99":U INITIAL 30 
     LABEL "% del MAXIMO" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      t-Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      t-Almmmatg.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
      t-Almmmatg.DesMat FORMAT "X(45)":U WIDTH 103.57
      t-Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 24.43
      t-Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(8)":U WIDTH 12
      t-Almmmatg.Dec__01 COLUMN-LABEL "Stock Disponible" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 17.86
      t-Almmmatg.Dec__02 COLUMN-LABEL " Stock Máximo" FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U
            WIDTH 16.43
      t-Almmmatg.Libre_c03 COLUMN-LABEL "Eficiencia" FORMAT "x(10)":U
            WIDTH 11.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 199 BY 21.81 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 2.08 COL 125 WIDGET-ID 42
     FILL-IN-Temporada AT ROW 1 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     BUTTON_Texto AT ROW 1 COL 161 WIDGET-ID 44
     COMBO-BOX_CodAlm AT ROW 2.35 COL 29 COLON-ALIGNED WIDGET-ID 2
     BUTTON_Texto-2 AT ROW 2.88 COL 161 WIDGET-ID 46
     FILL-IN_Porcentaje AT ROW 3.42 COL 29 COLON-ALIGNED WIDGET-ID 40
     BROWSE-3 AT ROW 4.77 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 201.43 BY 25.85 WIDGET-ID 100.


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
         TITLE              = "ALERTA DE STOCK"
         HEIGHT             = 25.85
         WIDTH              = 201.43
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 201.43
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 201.43
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
/* BROWSE-TAB BROWSE-3 FILL-IN_Porcentaje F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Temporada IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.t-Almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-Almmmatg.codmat
"t-Almmmatg.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-Almmmatg.DesMat
"t-Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "103.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-Almmmatg.DesMar
"t-Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-Almmmatg.UndStk
"t-Almmmatg.UndStk" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-Almmmatg.Dec__01
"t-Almmmatg.Dec__01" "Stock Disponible" "(ZZZ,ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no "17.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-Almmmatg.Dec__02
"t-Almmmatg.Dec__02" " Stock Máximo" ? "decimal" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-Almmmatg.Libre_c03
"t-Almmmatg.Libre_c03" "Eficiencia" "x(10)" "character" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ALERTA DE STOCK */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ALERTA DE STOCK */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PROCESAR */
DO:
  ASSIGN COMBO-BOX_CodAlm FILL-IN_Porcentaje.
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto W-Win
ON CHOOSE OF BUTTON_Texto IN FRAME F-Main /* TEXTO RA */
DO:
  RUN Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto-2 W-Win
ON CHOOSE OF BUTTON_Texto-2 IN FRAME F-Main /* TEXTO JJLL */
DO:
  RUN Texto-JJLL.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CodMat AS CHAR NO-UNDO.
DEF VAR j AS INTE NO-UNDO.
DEF VAR pComprometido AS DECI NO-UNDO.
DEF VAR x-StkAct AS DECI NO-UNDO.
DEF VAR x-Inicio AS DATETIME NO-UNDO.
DEF VAR x-Fin AS DATETIME NO-UNDO.
DEF VAR x-Texto AS CHAR NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE t-Almmmatg.
FOR EACH ListaExpressArticulos NO-LOCK WHERE listaexpressarticulos.codcia = s-codcia:
    DO j = 1 TO 2:
        x-Inicio = NOW.
        ETIME(TRUE).

        IF j = 1 THEN x-CodMat = ListaExpressArticulos.CodProdPremium.
        IF j = 2 THEN x-CodMat = ListaExpressArticulos.CodProdStandard.
        IF TRUE <> (x-CodMat > '') THEN NEXT.
        IF CAN-FIND(FIRST t-Almmmatg WHERE t-Almmmatg.CodCia = s-codcia and
                    t-Almmmatg.codmat = x-CodMat NO-LOCK)
            THEN NEXT.
        /* stock */
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
            Almmmatg.codmat = x-CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.
        /* SOLO los que tengan definido STOCK MAXIMO */
        FIND Almmmate WHERE Almmmate.CodCia = s-codcia AND
            Almmmate.CodAlm = COMBO-BOX_CodAlm AND
            Almmmate.codmat = x-CodMat /*AND
            Almmmate.VCtMn1 > 0*/
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN NEXT.
        /* comprometido */
        RUN gn/stock-comprometido-v2 (x-CodMat,
                                      COMBO-BOX_CodAlm,
                                      YES,
                                      OUTPUT pComprometido).
        /* Stock disponible */
        x-StkAct = Almmmate.StkAct - pComprometido.
        
        RUN lib/_time-passed.p (x-Inicio, x-Fin, OUTPUT x-Texto).

        /*RUN lib/_time-in-hours (ETIME / 1000, OUTPUT x-Texto).*/
        x-Fin = NOW.

        /* Verificamos */
        IF FILL-IN-Temporada = "CAMPAÑA" THEN DO:
            IF x-StkAct <= TRUNCATE(Almmmate.VCtMn1 * FILL-IN_Porcentaje / 100, 0) THEN DO:
                CREATE t-Almmmatg.
                BUFFER-COPY Almmmatg TO t-Almmmatg
                    ASSIGN
                    t-Almmmatg.Dec__01 = x-StkAct
                    t-Almmmatg.Dec__02 = Almmmate.VCtMn1
                    t-Almmmatg.Libre_c01 = STRING(x-Inicio, '99/99/9999 HH:MM:SS')
                    t-Almmmatg.Libre_c02 = STRING(x-Fin, '99/99/9999 HH:MM:SS')
                    t-Almmmatg.Libre_c03 = x-Texto.
            END.
        END.
        IF FILL-IN-Temporada = "NO CAMPAÑA" THEN DO:
            IF x-StkAct <= TRUNCATE(Almmmate.VCtMn2 * FILL-IN_Porcentaje / 100, 0) THEN DO:
                CREATE t-Almmmatg.
                BUFFER-COPY Almmmatg TO t-Almmmatg
                    ASSIGN
                    t-Almmmatg.Dec__01 = x-StkAct
                    t-Almmmatg.Dec__02 = Almmmate.VCtMn2
                    t-Almmmatg.Libre_c01 = STRING(x-Inicio, '99/99/9999 HH:MM:SS')
                    t-Almmmatg.Libre_c02 = STRING(x-Fin, '99/99/9999 HH:MM:SS')
                    t-Almmmatg.Libre_c03 = x-Texto.
            END.
        END.
    END.
END.
SESSION:SET-WAIT-STATE('').

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
  DISPLAY FILL-IN-Temporada COMBO-BOX_CodAlm FILL-IN_Porcentaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 BUTTON_Texto COMBO-BOX_CodAlm BUTTON_Texto-2 
         FILL-IN_Porcentaje BROWSE-3 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      FIND Almcfggn WHERE Almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
      CASE TRUE:
          WHEN NOT AVAILABLE Almcfggn OR AlmCfgGn.Temporada = '' THEN FILL-IN-Temporada = "NO DEFINIDA".
          WHEN Almcfggn.Temporada = "C" THEN FILL-IN-Temporada = "CAMPAÑA".
          WHEN Almcfggn.Temporada = "NC" THEN FILL-IN-Temporada = "NO CAMPAÑA".
      END CASE.
      COMBO-BOX_CodAlm:DELIMITER = "|".
      FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia AND
          Almacen.Campo-C[9] <> "I" AND
          Almacen.Campo-c[3] <> "Si" AND
          Almacen.Campo-c[6] = "Si" AND
          Almacen.AlmCsg = NO AND
          Almacen.Campo-c[1] = "ALMACEN":
          COMBO-BOX_CodAlm:ADD-LAST(Almacen.CodAlm + " - " + Almacen.Descripcion, Almacen.CodAlm).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "t-Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR pOptions AS CHAR NO-UNDO.
    DEF VAR pArchivo AS CHAR NO-UNDO.

    DEF VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE pArchivo
        FILTERS "Archivo txt" "*.txt"
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".txt"
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.
    /* ******************************************************* */
    OUTPUT TO VALUE(pArchivo).
    FOR EACH t-Almmmatg NO-LOCK:
        PUT UNFORMATTED t-Almmmatg.codmat SKIP.
    END.
    OUTPUT CLOSE.
    /* ******************************************************* */
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto-JJLL W-Win 
PROCEDURE Texto-JJLL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR pOptions AS CHAR NO-UNDO.
    DEF VAR pArchivo AS CHAR NO-UNDO.

    DEF VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE pArchivo
        FILTERS "Archivo txt" "*.txt"
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".txt"
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.
    /* ******************************************************* */
    OUTPUT TO VALUE(pArchivo).
    PUT UNFORMATTED 'ARTICULO|DESCRIPCION|MARCA|LINEA|DESCRIP LINEA|STOCK DISPONIBLE|STOCK MAXIMO|UNIDAD'
        SKIP.
    FOR EACH t-Almmmatg NO-LOCK, FIRST Almtfami OF t-Almmmatg NO-LOCK:
        PUT UNFORMATTED 
            t-Almmmatg.codmat    '|'
            t-Almmmatg.DesMat    '|'
            t-Almmmatg.DesMar    '|'
            t-Almmmatg.codfam    '|'
            Almtfami.desfam      '|'
            t-Almmmatg.Dec__01   '|'
            t-Almmmatg.Dec__02   '|'
            t-Almmmatg.UndStk
            SKIP.
    END.
    OUTPUT CLOSE.
    /* ******************************************************* */
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

