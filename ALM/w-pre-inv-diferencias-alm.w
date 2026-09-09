&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE cc-AlmDPInv NO-UNDO LIKE INTEGRAL.AlmDPInv.
DEFINE TEMP-TABLE tt-AlmDPInv NO-UNDO LIKE INTEGRAL.AlmDPInv
       field desmat like almmmatg.desmat
       field codmar like almmmatg.codmar
       field undstk like almmmatg.undstk.



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
{src/bin/_prns.i}
DEF SHARED VAR s-user-id  AS CHAR.
DEF SHARED VAR s-nomcia   AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VARIABLE pRCID AS INT.
DEFINE VAR X-diferencia AS DEC.
DEFINE VAR x-OtrasZonas AS CHAR.

/* Reportes */
DEFINE VAR s-task-no AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "alm\rbalm.prl".

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
&Scoped-define INTERNAL-TABLES tt-AlmDPInv INTEGRAL.Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-AlmDPInv.codmat ~
tt-AlmDPInv.Libre_d01[1] tt-AlmDPInv.Libre_d01[2] tt-AlmDPInv.Libre_d01[3] ~
(tt-AlmDPInv.StkInv - tt-AlmDPInv.Libre_d01[3]) @ X-diferencia ~
INTEGRAL.Almmmatg.UndStk INTEGRAL.Almmmatg.DesMat INTEGRAL.Almmmatg.DesMar ~
fOtrasZonas(tt-AlmDPInv.codmat,tt-AlmDPInv.CodAlm, tt-AlmDPInv.CodUbi) @ x-OtrasZonas 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-AlmDPInv NO-LOCK, ~
      EACH INTEGRAL.Almmmatg WHERE INTEGRAL.Almmmatg.CodCia =  tt-AlmDPInv.CodCia and ~
 INTEGRAL.Almmmatg.codmat =  tt-AlmDPInv.codmat NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-AlmDPInv NO-LOCK, ~
      EACH INTEGRAL.Almmmatg WHERE INTEGRAL.Almmmatg.CodCia =  tt-AlmDPInv.CodCia and ~
 INTEGRAL.Almmmatg.codmat =  tt-AlmDPInv.codmat NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-AlmDPInv INTEGRAL.Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-AlmDPInv
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 INTEGRAL.Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnHojaReconteo BtnExcel txtCodUbi BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS txtCodUbi txtCodAlm txtDesAlm 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fOtrasZonas W-Win 
FUNCTION fOtrasZonas RETURNS CHARACTER
  ( INPUT lpCodmat AS CHAR, INPUT lpCodAlm AS CHAR, INPUT lpCodUbi AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnExcel 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnHojaReconteo 
     LABEL "Hoja de Reconteo" 
     SIZE 19 BY 1.12.

DEFINE VARIABLE txtCodAlm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCodUbi AS CHARACTER FORMAT "X(15)":U 
     LABEL "Ubicacion" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-AlmDPInv, 
      INTEGRAL.Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-AlmDPInv.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U
            WIDTH 8.14
      tt-AlmDPInv.Libre_d01[1] COLUMN-LABEL "Conteo" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 9
      tt-AlmDPInv.Libre_d01[2] COLUMN-LABEL "Re-Conteo" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 11.43
      tt-AlmDPInv.Libre_d01[3] COLUMN-LABEL "Stk.Sistema" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 10.86
      (tt-AlmDPInv.StkInv - tt-AlmDPInv.Libre_d01[3]) @ X-diferencia COLUMN-LABEL "Diferencia"
      INTEGRAL.Almmmatg.UndStk COLUMN-LABEL "U.M." FORMAT "X(4)":U
      INTEGRAL.Almmmatg.DesMat FORMAT "X(45)":U WIDTH 33.14
      INTEGRAL.Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
            WIDTH 23
      fOtrasZonas(tt-AlmDPInv.codmat,tt-AlmDPInv.CodAlm, tt-AlmDPInv.CodUbi) @ x-OtrasZonas COLUMN-LABEL "Otras Zonas" FORMAT "x(50)":U
            WIDTH 19.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 135.29 BY 22.73 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnHojaReconteo AT ROW 1.58 COL 97 WIDGET-ID 36
     BtnExcel AT ROW 3.12 COL 99 WIDGET-ID 34
     txtCodUbi AT ROW 3 COL 77 COLON-ALIGNED WIDGET-ID 6
     BROWSE-2 AT ROW 4.81 COL 1.72 WIDGET-ID 200
     txtCodAlm AT ROW 2.92 COL 9 COLON-ALIGNED WIDGET-ID 2
     txtDesAlm AT ROW 2.92 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     "    Diferencias -  Pre inventarios" VIEW-AS TEXT
          SIZE 43 BY .96 AT ROW 1.35 COL 26 WIDGET-ID 32
          BGCOLOR 7 FGCOLOR 15 FONT 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 137.57 BY 26.88 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: cc-AlmDPInv T "?" NO-UNDO INTEGRAL AlmDPInv
      TABLE: tt-AlmDPInv T "?" NO-UNDO INTEGRAL AlmDPInv
      ADDITIONAL-FIELDS:
          field desmat like almmmatg.desmat
          field codmar like almmmatg.codmar
          field undstk like almmmatg.undstk
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 26.88
         WIDTH              = 137.57
         MAX-HEIGHT         = 27.65
         MAX-WIDTH          = 137.57
         VIRTUAL-HEIGHT     = 27.65
         VIRTUAL-WIDTH      = 137.57
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 txtCodUbi F-Main */
/* SETTINGS FOR FILL-IN txtCodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-AlmDPInv,INTEGRAL.Almmmatg WHERE Temp-Tables.tt-AlmDPInv ..."
     _Options          = "NO-LOCK"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.CodCia =  Temp-Tables.tt-AlmDPInv.CodCia and
 INTEGRAL.Almmmatg.codmat =  Temp-Tables.tt-AlmDPInv.codmat"
     _FldNameList[1]   > Temp-Tables.tt-AlmDPInv.codmat
"tt-AlmDPInv.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-AlmDPInv.Libre_d01[1]
"tt-AlmDPInv.Libre_d01[1]" "Conteo" ? "decimal" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-AlmDPInv.Libre_d01[2]
"tt-AlmDPInv.Libre_d01[2]" "Re-Conteo" ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-AlmDPInv.Libre_d01[3]
"tt-AlmDPInv.Libre_d01[3]" "Stk.Sistema" ? "decimal" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"(tt-AlmDPInv.StkInv - tt-AlmDPInv.Libre_d01[3]) @ X-diferencia" "Diferencia" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.UndStk
"INTEGRAL.Almmmatg.UndStk" "U.M." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "33.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmatg.DesMar
"INTEGRAL.Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "23" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fOtrasZonas(tt-AlmDPInv.codmat,tt-AlmDPInv.CodAlm, tt-AlmDPInv.CodUbi) @ x-OtrasZonas" "Otras Zonas" "x(50)" ? ? ? ? ? ? ? no ? no no "19.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnExcel W-Win
ON CHOOSE OF BtnExcel IN FRAME F-Main /* Excel */
DO:
    ASSIGN txtCodAlm txtDesAlm txtCodUbi.

    RUN ue-excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHojaReconteo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHojaReconteo W-Win
ON CHOOSE OF BtnHojaReconteo IN FRAME F-Main /* Hoja de Reconteo */
DO:

ASSIGN txtCodAlm txtDesAlm txtCodUbi.

  /*RUN ue-hoja-reconteo.*/
    RUN ue-imprimir-hoja-reconteo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodUbi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodUbi W-Win
ON LEAVE OF txtCodUbi IN FRAME F-Main /* Ubicacion */
OR RETURN OF txtCodUbi
   
DO:
    txtcodubi:SCREEN-VALUE = REPLACE(txtcodubi:SCREEN-VALUE,"'","-").

    DEFINE VAR lOtrasZonas AS DEC.
    DEF BUFFER B-AlmDPinv FOR AlmDPinv.

    ASSIGN txtCodUbi.

    IF txtCodUbi <> "" THEN DO:            
        EMPTY TEMP-TABLE tt-AlmDPInv.
        EMPTY TEMP-TABLE cc-AlmDPInv.
        /* Guardo el Conteo */
        FOR EACH AlmDPInv WHERE AlmDPInv.codcia = s-codcia 
                AND AlmDPInv.codalm = s-codalm AND AlmDPInv.codubi = txtCodUbi
                NO-LOCK:
            CREATE tt-AlmDPInv.
                BUFFER-COPY AlmDPInv TO tt-AlmDPInv.

            lOtrasZonas = 0.
            /**/
            FOR EACH b-almdpinv WHERE b-almdpinv.codcia = s-codcia AND
                    b-almdpinv.codmat = almdpinv.codmat AND 
                    b-almdpinv.codalm = almdpinv.codalm AND 
                    b-almdpinv.codubi <> almdpinv.codubi NO-LOCK  :

                    lOtrasZonas = lOtrasZonas + B-almdpinv.stkinv.

            END.
            RELEASE b-almdpinv.

            ASSIGN tt-AlmDPInv.stkinv = tt-AlmDPInv.stkinv + lOtrasZonas.

            /**/

        END.
    
        {&OPEN-QUERY-BROWSE-2}
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
  DISPLAY txtCodUbi txtCodAlm txtDesAlm 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnHojaReconteo BtnExcel txtCodUbi BROWSE-2 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST Almacen WHERE almacen.codcia = s-codcia AND 
      almacen.codalm = s-codalm NO-LOCK NO-ERROR.

  txtCodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-codalm .
  txtDesAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF(AVAILABLE almacen) THEN almacen.descripcion ELSE "".


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
  {src/adm/template/snd-list.i "tt-AlmDPInv"}
  {src/adm/template/snd-list.i "INTEGRAL.Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-buscar-en-browse W-Win 
PROCEDURE ue-buscar-en-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-codigo-valido W-Win 
PROCEDURE ue-codigo-valido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lOtrasZonas AS CHAR.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

iColumn = 1.
cColumn = STRING(iColumn).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Almacen :" + txtCodAlm + " " + txtDesAlm.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Ubicacion-Zona :" + txtCodUbi.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Conteo".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value =  "Re-conteo".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value =  "Stk.Sistema".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Diferencia".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Otras Zonas".


GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE tt-AlmDPInv:
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    lOtrasZonas = fOtrasZonas(INPUT tt-almDPinv.codmat, INPUT tt-almDPinv.codalm, INPUT tt-almDPinv.codubi).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-almDPinv.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almmmatg.desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-almDPinv.libre_d01[1].
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value =  tt-almDPinv.libre_d01[2].
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value =  tt-almDPinv.libre_d01[3].
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = ( tt-almDPinv.stkinv - tt-almDPinv.libre_d01[3]).
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almmmatg.desmar.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + lOtrasZonas.

    GET NEXT {&BROWSE-NAME}.
END.

{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-hoja-reconteo W-Win 
PROCEDURE ue-hoja-reconteo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
DEFINE VAR lSele AS INT.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

iColumn = 1.
cColumn = STRING(iColumn).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = " HOJA DE RECONTEO".

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Almacen :" + txtCodAlm + " " + txtDesAlm.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Ubicacion-Zona :" + txtCodUbi.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "U.M.".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Reconteo".

DO lSele = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(lSele) THEN DO:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-almDPinv.codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.desmat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.desmar.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.undstk.
    END.
END.
{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imprimir-hoja-reconteo W-Win 
PROCEDURE ue-imprimir-hoja-reconteo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSele AS INT.
            
RUN bin/_prnctr.p.
IF s-salida-impresion = 0 THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* creo el temporal */ 
REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    AND w-report.llave-c = s-user-id NO-LOCK)
        THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
             w-report.llave-c = ''.
        LEAVE.
    END.
END.

DO lSele = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(lSele) THEN DO:
        CREATE w-report.
        ASSIGN w-report.task-no = s-task-no
                w-report.llave-c = tt-almDPinv.codmat
                w-report.campo-c[1] = almmmatg.desmat
                w-report.campo-c[2] = almmmatg.desmar 
                w-report.campo-c[3] = almmmatg.undstk .
    END.
END.

RB-INCLUDE-RECORDS = "O".
RB-FILTER = " w-report.task-no = " + STRING(s-task-no) + 
            " AND w-report.llave-c <> ''".
RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-almacen = Almacen :" + txtCodAlm + " " + txtDesAlm + 
                        "~ns-zona = Ubicacion-Zona :" + txtCodUbi.

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
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

ASSIGN
      RB-REPORT-NAME = "Hoja Reconteo - PRE-INVENTARIOS"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.

  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
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
                      "").

/* Borar el temporal */
DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.

MESSAGE "Impresion Enviada".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-registra-conteo-art W-Win 
PROCEDURE ue-registra-conteo-art :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-validar W-Win 
PROCEDURE ue-validar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fOtrasZonas W-Win 
FUNCTION fOtrasZonas RETURNS CHARACTER
  ( INPUT lpCodmat AS CHAR, INPUT lpCodAlm AS CHAR, INPUT lpCodUbi AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lSeparador AS CHAR.
    DEFINE VAR x-acumulado AS CHAR.

    lSeparador = "".
    x-acumulado = ''.
    FOR EACH almdpinv WHERE almdpinv.codcia = s-codcia AND
            almdpinv.codmat = lpCodmat AND 
            almdpinv.codalm = lpCodAlm AND 
            almdpinv.codubi <> lpCodUbi NO-LOCK  :
        
        x-acumulado = x-acumulado + lSeparador + TRIM(almdpinv.codubi) + "=" + 
                TRIM(STRING(almdpinv.stkinv,">,>>>,>>9.99")).
        lSeparador = " / ".
    END.

  RETURN x-acumulado.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

