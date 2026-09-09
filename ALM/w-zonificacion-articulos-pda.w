&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-Almmmate NO-UNDO LIKE Almmmate.



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
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR lLimitexZona AS INT INITIAL 25.
DEFINE VAR lCuentaxZona AS INT INITIAL 0.

DEF VAR s-task-no AS INT.
DEF VAR pMensaje AS CHAR NO-UNDO.

FIND FIRST almacen WHERE codcia = s-codcia AND codalm = s-codalm NO-LOCK NO-ERROR.

IF NOT AVAILABLE almacen /*OR campo-c[10] = 'X'*/ THEN DO:
    /*MESSAGE 'Almacen NO Habilitado para ZONIFICACION' VIEW-AS ALERT-BOX ERROR.*/
    MESSAGE 'Almacen NO esta registrado en el maestro' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

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
&Scoped-define INTERNAL-TABLES tt-Almmmate

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-Almmmate.Libre_d02 ~
tt-Almmmate.codmat tt-Almmmate.desmat 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-Almmmate NO-LOCK ~
    BY tt-Almmmate.Libre_d02 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tt-Almmmate NO-LOCK ~
    BY tt-Almmmate.Libre_d02 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-Almmmate


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtCodUbi txtCodEan btnGrabar btnSalir ~
BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS txtCodUbi txtCodEan edtDesmat txtDesUbi ~
txtCodAlm txtDesAlm 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnGrabar 
     LABEL "Grabar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnSalir 
     LABEL "Salir" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE edtDesmat AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 63.86 BY 2.38
     BGCOLOR 15 FGCOLOR 4 FONT 8 NO-UNDO.

DEFINE VARIABLE txtCodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY 1
     FGCOLOR 1 FONT 11 NO-UNDO.

DEFINE VARIABLE txtCodEan AS CHARACTER FORMAT "X(20)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 42.86 BY 1.27
     FONT 8 NO-UNDO.

DEFINE VARIABLE txtCodUbi AS CHARACTER FORMAT "X(8)":U 
     LABEL "Ubicación" 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY 1
     BGCOLOR 15 FGCOLOR 12 FONT 11 NO-UNDO.

DEFINE VARIABLE txtDesAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 11 NO-UNDO.

DEFINE VARIABLE txtDesUbi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1
     BGCOLOR 15 FGCOLOR 12 FONT 11 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-Almmmate SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tt-Almmmate.Libre_d02 COLUMN-LABEL "Itm" FORMAT ">>9":U WIDTH 4.14
      tt-Almmmate.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U
            WIDTH 11.86
      tt-Almmmate.desmat COLUMN-LABEL "Descripcion" FORMAT "x(45)":U
            WIDTH 43.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 63.72 BY 15.31
         FONT 11 ROW-HEIGHT-CHARS .85 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtCodUbi AT ROW 2.35 COL 9 COLON-ALIGNED WIDGET-ID 6
     txtCodEan AT ROW 3.42 COL 9 COLON-ALIGNED WIDGET-ID 10 AUTO-RETURN 
     edtDesmat AT ROW 4.77 COL 1.57 NO-LABEL WIDGET-ID 12
     txtDesUbi AT ROW 2.35 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     txtCodAlm AT ROW 1.27 COL 2.57 WIDGET-ID 2
     txtDesAlm AT ROW 1.23 COL 16.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     btnGrabar AT ROW 22.88 COL 33 WIDGET-ID 16
     btnSalir AT ROW 22.88 COL 49 WIDGET-ID 14
     BROWSE-3 AT ROW 7.23 COL 1.86 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.29 BY 23.31 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-Almmmate T "?" NO-UNDO INTEGRAL Almmmate
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Articulos por Zonas - PDA"
         HEIGHT             = 23.31
         WIDTH              = 65.29
         MAX-HEIGHT         = 39.12
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 39.12
         VIRTUAL-WIDTH      = 274.29
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-3 btnSalir F-Main */
/* SETTINGS FOR EDITOR edtDesmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtCodAlm IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txtDesAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesUbi IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tt-Almmmate"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-Almmmate.Libre_d02|yes"
     _FldNameList[1]   > Temp-Tables.tt-Almmmate.Libre_d02
"tt-Almmmate.Libre_d02" "Itm" ">>9" "decimal" ? ? ? ? ? ? no ? no no "4.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-Almmmate.codmat
"tt-Almmmate.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-Almmmate.desmat
"tt-Almmmate.desmat" "Descripcion" ? "character" ? ? ? ? ? ? no ? no no "43.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Articulos por Zonas - PDA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Articulos por Zonas - PDA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-3 IN FRAME F-Main
DO:

    DEFINE VAR s-Registro-Actual AS ROWID.
    
    IF ROWID(tt-almmmate) = ? THEN DO:
        /**/
    END.
    ELSE DO:
        MESSAGE "Seguro de ELIMINAR el Codigo(" + tt-almmmate.codmat + ") ?" VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        DELETE tt-almmmate.
        {&OPEN-QUERY-BROWSE-3}

        /*
        IF tt-almmmate.libre_c01 <> 'RETIRAR' THEN DO:
            MESSAGE "Seguro de ELIMINAR el Codigo(" + tt-almmmate.codmat + ") ?" VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.

        END.

        IF tt-almmmate.libre_c01 = 'RETIRAR' THEN DO:
            ASSIGN tt-almmmate.libre_c01 = "".
        END.
        ELSE DO:
            ASSIGN tt-almmmate.libre_c01 = "RETIRAR".
        END.

        s-Registro-Actual = ROWID(tt-almmmate).
        {&OPEN-QUERY-BROWSE-3}
         REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
         */
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-Almmmate.Libre_d02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-Almmmate.Libre_d02 BROWSE-3 _BROWSE-COLUMN W-Win
ON ANY-PRINTABLE OF tt-Almmmate.Libre_d02 IN BROWSE BROWSE-3 /* Itm */
DO:
  ASSIGN tt-almmmate.libre_c01 = 'ORDEN'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-Almmmate.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-Almmmate.codmat BROWSE-3 _BROWSE-COLUMN W-Win
ON LEFT-MOUSE-DBLCLICK OF tt-Almmmate.codmat IN BROWSE BROWSE-3 /* Codigo */
DO:
  MESSAGE "CodMat".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-Almmmate.codmat BROWSE-3 _BROWSE-COLUMN W-Win
ON MOUSE-SELECT-DBLCLICK OF tt-Almmmate.codmat IN BROWSE BROWSE-3 /* Codigo */
DO:
  MESSAGE "XXX".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGrabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGrabar W-Win
ON CHOOSE OF btnGrabar IN FRAME F-Main /* Grabar */
DO:

    ASSIGN txtCodUbi.

  RUN ue-grabar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSalir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSalir W-Win
ON CHOOSE OF btnSalir IN FRAME F-Main /* Salir */
DO:

    /* Control de lo ya ingresado */
    IF CAN-FIND(FIRST tt-almmmate NO-LOCK) THEN DO:
        MESSAGE 'Aún no ha grabado la información registrada' SKIP
            'DESEA PERDERLA?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE rpta AS LOG.
        IF rpta = NO THEN DO:
            APPLY 'ENTRY':U TO txtCodEan IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
            
    END.


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


&Scoped-define SELF-NAME txtCodEan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodEan W-Win
ON LEAVE OF txtCodEan IN FRAME F-Main /* Articulo */
/*OR ENTER OF txtCodEan*/
DO:
    IF txtCodEan:SCREEN-VALUE <> "" THEN DO:

        ASSIGN txtCodUbi.

        DEFINE VAR pCodMat AS CHAR.
        DEFINE VAR pFactor AS DEC.
    
        ASSIGN
            pCodMat = SELF:SCREEN-VALUE.
            
        RUN alm/p-codbrr-inv (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pFactor, s-codcia).
    
        IF pCodMat = '' THEN DO:
            BELL.
            MESSAGE 'Código errado' VIEW-AS ALERT-BOX ERROR.
            SELF:SCREEN-VALUE = ''.
            RETURN NO-APPLY.
        END.
    
        /*IF LENGTH(SELF:SCREEN-VALUE) > 6 THEN pCodEan = SELF:SCREEN-VALUE.*/
    
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = pCodMat
            NO-LOCK.
        /* En caso de haber leido EAN14 */
        
        ASSIGN 
            edtDesMat:SCREEN-VALUE  = pCodMat + " " + Almmmatg.desmat.
    
        /*
        FIND Almmmate OF Almmmatg WHERE Almmmate.codalm = s-codalm
            NO-LOCK NO-ERROR.
        */
        FIND FIRST Almmmate WHERE   almmmate.codcia = s-codcia AND 
                                    Almmmate.codalm = s-codalm AND
                                    almmmate.codmat = pCodMat
                                    NO-LOCK NO-ERROR.
    
        FIND FIRST tt-almmmate WHERE tt-almmmate.codmat = pCodMat NO-ERROR.
        IF NOT AVAILABLE tt-almmmate THEN DO:
            lCuentaxZona = lCuentaxZona + 1.
            /***********************************************/
            CREATE tt-almmmate.
            IF AVAILABLE almmmate THEN DO:
                BUFFER-COPY almmmate TO tt-almmmate.
            END.                
            ELSE DO:
                ASSIGN tt-almmmate.codcia = s-codcia 
                        tt-almmmate.codalm = s-codalm                        
                        tt-almmmate.stkact = 0
                        tt-almmmate.stkmin = 0
                        tt-almmmate.stkmax = 0
                        tt-almmmate.stkrep = 0
                        tt-almmmate.stkini = 0
                        tt-almmmate.libre_d01 = 0
                        tt-almmmate.codmar = almmmatg.codmar
                        tt-almmmate.undvta = almmmatg.undbas
                        tt-almmmate.StkComprometido = 0.
            END.
            ASSIGN tt-almmmate.libre_c01 = ""   /* ELIMINAR, ADD */
                   tt-almmmate.libre_c02 = ""
                tt-almmmate.desmat = IF(AVAILABLE almmmatg) THEN almmmatg.desmat ELSE "** ERROR **"
                tt-almmmate.libre_d02 = lCuentaxZona
                tt-almmmate.codubi = txtCodUbi.

            {&OPEN-QUERY-BROWSE-3}

            SELF:SCREEN-VALUE = ''.
    
        END.
        ELSE DO:
            BELL.
            BELL.
            BELL.
        END.

        APPLY 'ENTRY':U TO txtCodEan IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodUbi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodUbi W-Win
ON ENTRY OF txtCodUbi IN FRAME F-Main /* Ubicación */
DO:
  BROWSE-3:VISIBLE = NO.
  txtCodEan:VISIBLE = NO.
  edtDesMat:VISIBLE = NO.
  btnGrabar:VISIBLE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodUbi W-Win
ON LEAVE OF txtCodUbi IN FRAME F-Main /* Ubicación */
OR RETURN OF txtCodUbi

DO:
    txtcodubi:SCREEN-VALUE = REPLACE(txtcodubi:SCREEN-VALUE,"'","-").
    IF txtcodubi:SCREEN-VALUE <> "" THEN DO:
        DEFINE VAR lFiler AS CHAR.
        FIND FIRST almtubic WHERE almtubic.codcia = s-codcia AND
            almtubic.codalm = s-codalm AND
            almtubic.codubi = txtcodubi:SCREEN-VALUE NO-LOCK NO-ERROR.
        txtDesUbi:SCREEN-VALUE = IF (AVAILABLE almtubic) THEN almtubic.desubi ELSE "< ZONA INEXISTENTE >".
        IF NOT AVAILABLE almtubic THEN DO:
            /* Ic - 05Ene2022 validacion pedida por Max Ramos */
            MESSAGE 
                "Ubicación no existe o no pertenece al almacén" SKIP
                "--------------------------------------------" SKIP
                "Comuníquese con el administrador del almacén" SKIP
                "Muchas gracias" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.                
        txtCodEan:VISIBLE IN FRAME {&FRAME-NAME} = YES .        
        edtDesMat:VISIBLE IN FRAME {&FRAME-NAME} = YES.
        btnGrabar:VISIBLE IN FRAME {&FRAME-NAME} = YES.
        BROWSE-3:VISIBLE IN FRAME {&FRAME-NAME} = YES.

        txtCodUbi:SENSITIVE = NO.
        txtCodEan:SENSITIVE = YES .

        EMPTY TEMP-TABLE tt-almmmate.
        lCuentaxZona = 0.

        APPLY 'ENTRY':U TO txtCodEan IN FRAME {&FRAME-NAME}.
   END.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
                
ON 'RETURN':U OF  txtCodUbi, txtCodEan
DO:
    APPLY 'TAB'.
    RETURN NO-APPLY.
END.

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
  DISPLAY txtCodUbi txtCodEan edtDesmat txtDesUbi txtCodAlm txtDesAlm 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtCodUbi txtCodEan btnGrabar btnSalir BROWSE-3 
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

  FIND FIRST almacen WHERE almacen.codcia = s-codcia 
      AND almacen.codalm = s-codalm NO-LOCK NO-ERROR.

  txtcodalm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-codalm.
  txtdesalm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF(AVAILABLE almacen) THEN almacen.descripcion ELSE "".

  APPLY 'ENTRY':U TO txtCodUbi IN FRAME {&FRAME-NAME}.

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
  {src/adm/template/snd-list.i "tt-Almmmate"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-add-articulo W-Win 
PROCEDURE ue-add-articulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
  DEFINE VAR ltxtCodMat AS CHAR.
  DEFINE VAR lMsgBuscar AS CHAR.
  DEFINE VAR lCodMat AS CHAR.

  DEFINE VAR s-Registro-Actual AS ROWID.

    ltxtCodMat = txtCodMatAdd.
    lMsgBuscar = "".

  RUN ue-buscar-en-browse(INPUT lTxtCodMat, OUTPUT lMsgBuscar, OUTPUT lCodMat).

  IF lMsgBuscar<> "" AND lMsgBuscar="OK" THEN DO:
      /*
      lMsgBuscar = "Codigo ya esta registrado".
      MESSAGE lMsgBuscar VIEW-AS ALERT-BOX.
      */
      RETURN NO-APPLY.
  END.

  IF lMsgBuscar<> "" THEN DO:
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
        almmmatg.codmat = lCodMat NO-LOCK NO-ERROR.

    IF NOT AVAILABLE almmmatg THEN DO:
        MESSAGE "Codigo de Articulo INEXISTENTE" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND 
        almmmate.codalm = s-codalm AND almmmate.codmat = lCodmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almmmate THEN DO:
        MESSAGE "Codigo de Articulo no existe en el ALMACEN (" + s-codalm + ")" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.
    IF almmmate.codubi = ? OR almmmate.codubi = "" OR caps(almmmate.codubi) = 'G-0' THEN DO:
        /* Ok */
    END.
    ELSE DO:
        IF almmmate.codubi = txtCodUbi THEN DO:
            RETURN NO-APPLY.
        END.
        MESSAGE "El Articulo(" + lCodmat + ") se ubica en (" + almmmate.codubi + "), Seguro de cambiarlo?" VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta2 AS LOG.
            IF rpta2 = NO THEN RETURN NO-APPLY.

    END.

    IF ChkBxConfirmar = YES THEN DO:
        MESSAGE 'Seguro de Agregar/Cambiar el Articulo?' VIEW-AS ALERT-BOX QUESTION
                    BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.

    END.

    /* llevar la Cuenta */
    lCuentaxZona = lCuentaxZona + 1.

    CREATE tt-almmmate.

    ASSIGN tt-almmmate.codcia = s-codcia
            tt-almmmate.codalm = s-codalm
            tt-almmmate.undvta = almmmatg.Chr__01
            tt-almmmate.codubi = txtCodUbi
            tt-almmmate.desmat = almmmatg.desmat
            tt-almmmate.codmat = almmmatg.codmat
            tt-almmmate.codmar = almmmatg.codmar
            tt-almmmate.stkact = almmmate.Stkact
            tt-almmmate.libre_d02 = lCuentaxZona
            tt-almmmate.libre_c01 = 'NUEVO'
            tt-almmmate.libre_c02 = if(AVAILABLE almmmate) THEN almmmate.codubi ELSE "".            

    s-Registro-Actual = ROWID(tt-almmmate).

    {&OPEN-QUERY-BROWSE-3}

     REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
    

    /*IF NOT AVAILABLE almmmate THEN DO:
        
        CREATE tt-almmmate.
        
        ASSIGN tt-almmmate.codcia = s-codcia
                tt-almmmate.codalm = s-codalm
                tt-almmmate.undvta = almmmatg.Chr__01
                tt-almmmate.codubi = txtCodUbi
                tt-almmmate.desmat = almmmatg.desmat
                tt-almmmate.codmat = almmmatg.codmat
                tt-almmmate.codmar = almmmatg.codmar
                tt-almmmate.libre_c01 = 'NUEVO'.
        
    END.
    ELSE DO: 
        ASSIGN tt-almmmate.libre_c01 = 'CAMBIO'
                tt-almmmate.libre_c02 = almmmate.codubi.
    END.
*/


  END.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-barras-zonas W-Win 
PROCEDURE ue-barras-zonas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE L-Ubica   AS LOGICAL INIT YES NO-UNDO.        
DEFINE VARIABLE lEtq AS INT.
DEFINE VAR lRegs AS INT.
/*
IF txtUbicDesde = "" OR txtUbicHasta = "" THEN DO:
    RETURN NO-APPLY.
END.

REPEAT WHILE L-Ubica:
       s-task-no = RANDOM(900000,999999).
       FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
       IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

letq = 100.
lRegs = 0.
FOR EACH almtubic WHERE almtubic.codcia = s-codcia AND 
        almtubic.codalm = s-codalm AND
        (almtubic.codubi >= txtUbicDesde AND almtubic.codubi <= txtUbicHasta) 
        NO-LOCK :
    IF letq > 3  THEN DO:
        lRegs = lRegs + 1.
        lEtq = 1.
        CREATE w-report.
            ASSIGN w-report.Task-No  = s-task-no
                w-report.Llave-C  = "01-" + STRING(lRegs,"9999999").
    END.
    ASSIGN w-report.Campo-C[lEtq] = "*" + almtubic.codubi + "*"
            w-report.Campo-C[lEtq + 4] = almtubic.codubi
            w-report.Campo-C[4] = "Alm : " + s-codalm.

    lEtq = lEtq + 1.
END.

    /* Code placed here will execute PRIOR to standard behavior. */
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'.
    /*RB-REPORT-NAME = 'RotuloxPedidos-1'.*/
    RB-REPORT-NAME = 'Ubicacion almacenes barras'.
    RB-INCLUDE-RECORDS = 'O'.

    RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
    RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                       RB-REPORT-NAME,
                       RB-INCLUDE-RECORDS,
                       RB-FILTER,
                       RB-OTHER-PARAMETERS).


*/

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

DEFINE INPUT PARAMETER ptxtCodMatBuscar AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER pMsgBuscar AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER ptxtCodMat AS CHAR    NO-UNDO.

pMsgBuscar = "".

IF ptxtCodMatBuscar = "" THEN DO:
    RETURN NO-APPLY.
END.

DEFINE VAR lCodMat AS CHAR.
DEFINE VAR lCodEan AS CHAR.
DEFINE VAR s-Registro-Actual AS ROWID.

lCodMat = trim(ptxtCodMatBuscar).
lCodEan = "".
ptxtCodMat = lCodMat.

IF LENGTH(lCodMat) > 6 THEN DO:
    lCodEan = lCodMat.
    /* Lo Busco como EAN13 */
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
        almmmatg.codbrr = lCodEan NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN lCodMat = almmmatg.codmat.

    IF lCodEan = lCodMat THEN DO:
        /* Lo busco como EAN14 */
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
            almmmat1.barras[1] = lCodEan NO-LOCK NO-ERROR.
        IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.

        IF lCodEan = lCodMat THEN DO:
            FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
                almmmat1.barras[2] = lCodEan NO-LOCK NO-ERROR.
            IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.
        END.
        IF lCodEan = lCodMat THEN DO:
            FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
                almmmat1.barras[3] = lCodEan NO-LOCK NO-ERROR.
            IF AVAILABLE almmmat1 THEN lCodMat = almmmat1.codmat.
        END.
    END.
    ptxtCodMat = lCodMat.
    IF lCodEan = lCodMat THEN DO:
        /*MESSAGE "Codigo EAN no existe" VIEW-AS ALERT-BOX.*/
        pMsgBuscar = "Codigo EAN no existe".
        RETURN NO-APPLY.
    END.
END.

FIND FIRST tt-almmmate WHERE tt-almmmate.codmat = lCodMat 
    NO-LOCK NO-ERROR.

IF NOT AVAILABLE tt-almmmate THEN DO:
    pMsgBuscar = "No existe Codigo".
    /*MESSAGE "No existe Codigo" VIEW-AS ALERT-BOX.*/
    RETURN NO-APPLY.
END.

ptxtCodMat = lCodMat.
pMsgBuscar = "OK".  /* Existe en el Browse */

s-Registro-Actual = ROWID(tt-almmmate).

REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cargar-data W-Win 
PROCEDURE ue-cargar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-almmmate.

SESSION:SET-WAIT-STATE('GENERAL').

lCuentaxZona = 0.

FOR EACH almmmate WHERE almmmate.codcia = s-codcia AND almmmate.codalm = s-codalm 
    AND almmmate.codubi = txtCodUbi NO-LOCK:

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
        almmmatg.codmat = almmmate.codmat NO-LOCK NO-ERROR.

    lCuentaxZona = lCuentaxZona + 1.

    CREATE tt-almmmate.
        BUFFER-COPY almmmate TO tt-almmmate.

        ASSIGN tt-almmmate.libre_c01 = ""   /* ELIMINAR, ADD */
               tt-almmmate.libre_c02 = ""
            tt-almmmate.desmat = IF(AVAILABLE almmmatg) THEN almmmatg.desmat ELSE "** ERROR **".
        IF tt-almmmate.libre_d02 = 0 THEN DO:
            ASSIGN tt-almmmate.libre_d02 = lCuentaxZona
                    tt-almmmate.libre_c01 = 'ORDEN'.
        END.
    
END.

FIND FIRST tt-almmmate NO-LOCK NO-ERROR.

{&OPEN-QUERY-BROWSE-3}

SESSION:SET-WAIT-STATE('').

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

MESSAGE "Seguro de Generar Excel?" VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.


        DEFINE VARIABLE lFileXls                 AS CHARACTER.
        DEFINE VARIABLE lNuevoFile               AS LOG.

        lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
        lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

        {lib\excel-open-file.i}

        iColumn = 1.
    cColumn = STRING(iColumn).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Almacen:" + txtCodAlm + " - " + txtDesAlm + " / Ubicacion :" + txtCodUbi.

    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "CodArticulo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Accion".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Ubic.Anterior".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Stock".


        FOR EACH tt-almmmate NO-LOCK :
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-almmmate.codmat.
             cRange = "B" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-almmmate.desmat.
             cRange = "C" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-almmmate.libre_c01.
             cRange = "D" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-almmmate.libre_c02.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-almmmate.Stkact.

        END.

        {lib\excel-close-file.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar W-Win 
PROCEDURE ue-grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE "Seguro de Grabar?" VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

FIND FIRST almtubic WHERE almtubic.codcia = s-codcia AND
    almtubic.codalm = s-codalm AND
    almtubic.codubi = txtcodubi NO-ERROR.

IF NOT AVAILABLE almtubic THEN DO:
    CREATE almtubic.
        ASSIGN almtubic.codcia = s-codcia
                almtubic.codalm = s-codalm
                almtubic.codubi = txtCodUbi
                almtubic.desubi = "CREADO X ZONIFICACION"
                almtubic.codzona = 'G-0'.
END.

RELEASE almtubic.

DEF VAR x-CodUbiIni AS CHAR NO-UNDO.
DEF VAR x-CodUbiFin AS CHAR NO-UNDO.
FOR EACH tt-almmmate  :
    x-CodUbiIni = ''.
    FIND FIRST almmmate WHERE almmmate.codcia = tt-almmmate.codcia AND
            almmmate.codalm = tt-almmmate.codalm AND
            almmmate.codmat = tt-almmmate.codmat EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE almmmate THEN DO:
        CREATE almmmate.                
        ASSIGN  
            almmmate.codcia = s-codcia
            almmmate.stkact = 0
            almmmate.stkmin = 0
            almmmate.stkmax = 0
            almmmate.stkrep = 0
            almmmate.stkini = 0
            almmmate.libre_d01 = 0
            almmmate.stkcomprometido  = 0.
    END.
    ELSE x-CodUbiIni = Almmmate.CodUbi.
    ASSIGN 
        almmmate.codubi = tt-almmmate.codubi
        almmmate.desmat = tt-almmmate.desmat
        almmmate.codmar = tt-almmmate.codmar
        almmmate.undvta = tt-almmmate.undvta
        almmmate.libre_d02 = tt-almmmate.libre_d02.
    ASSIGN 
        tt-almmmate.libre_c01 = "".
    /* ****************************************************************************** */
    /* Control de MultiUbicaciones */
    /* ****************************************************************************** */
    x-CodUbiFin = Almmmate.CodUbi.
    /* 11/08/2022
    {alm/i-logubimat-01.i &iAlmmmate="Almmmate"}
    */
    /* ****************************************************************************** */
END.

RELEASE almmmate.

EMPTY TEMP-TABLE tt-almmmate.
{&OPEN-QUERY-BROWSE-3}

txtCodUbi:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
APPLY 'ENTRY':U TO txtCodUbi IN FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

