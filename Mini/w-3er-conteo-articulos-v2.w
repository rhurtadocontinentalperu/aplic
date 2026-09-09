&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CINV NO-UNDO LIKE InvcPDA.
DEFINE TEMP-TABLE T-DINV LIKE InvdPDA.



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

/*
    p-Conteo    = 2 : Reconteo
                  3 : 3erConteo
*/

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-Conteo AS INT NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-adm-new-record AS LOG INIT NO NO-UNDO.
DEF VAR s-NroSecuencia AS INT NO-UNDO.

DEF VAR pCodMat AS CHAR NO-UNDO.
DEF VAR pFactor AS DECI NO-UNDO.
DEF VAR pCanPed AS DECI NO-UNDO.
DEF VAR pCodEan AS CHAR NO-UNDO.

DEFINE VAR pRowCurrent AS INT INIT 0.

DEFINE VAR pCodInventariador AS CHAR NO-UNDO.

RUN MINI\d-ingreso-inventariador.r(OUTPUT pCodInventariador).

IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN ERROR.

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
&Scoped-define INTERNAL-TABLES InvCargaInicial Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 InvCargaInicial.CodMat ~
Almmmatg.DesMat Almmmatg.DesMar 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH InvCargaInicial ~
      WHERE InvCargaInicial.codcia = s-codcia and  ~
InvCargaInicial.codalm = s-codalm and ~
((p-conteo = 2 and InvCargaInicial.sRecontar = 'S') or  ~
(p-conteo = 3 and InvCargaInicial.s3erRecontar = 'S')) and ~
(InvCargaInicial.swrksele[p-conteo] = '' or InvCargaInicial.swrksele[p-conteo] = ?) ~
 ~
 NO-LOCK, ~
      FIRST Almmmatg OF InvCargaInicial NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH InvCargaInicial ~
      WHERE InvCargaInicial.codcia = s-codcia and  ~
InvCargaInicial.codalm = s-codalm and ~
((p-conteo = 2 and InvCargaInicial.sRecontar = 'S') or  ~
(p-conteo = 3 and InvCargaInicial.s3erRecontar = 'S')) and ~
(InvCargaInicial.swrksele[p-conteo] = '' or InvCargaInicial.swrksele[p-conteo] = ?) ~
 ~
 NO-LOCK, ~
      FIRST Almmmatg OF InvCargaInicial NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 InvCargaInicial Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 InvCargaInicial
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 BUTTON-3 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS txtCodInv txtZonas 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 11 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     LABEL "Refrescar" 
     SIZE 15 BY 1.12
     BGCOLOR 8 FONT 1.

DEFINE VARIABLE txtCodInv AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 9 NO-UNDO.

DEFINE VARIABLE txtZonas AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 56.14 BY 1.73
     BGCOLOR 9 FGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      InvCargaInicial, 
      Almmmatg
    FIELDS(Almmmatg.DesMat
      Almmmatg.DesMar) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      InvCargaInicial.CodMat COLUMN-LABEL "Codigo" FORMAT "X(6)":U
            WIDTH 12.43
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 55 BY 12.58
         FONT 19 ROW-HEIGHT-CHARS .81 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtCodInv AT ROW 16.46 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     BROWSE-2 AT ROW 1.31 COL 2 WIDGET-ID 200
     BUTTON-3 AT ROW 16.38 COL 2 WIDGET-ID 68
     BtnDone AT ROW 16.27 COL 44 WIDGET-ID 50
     txtZonas AT ROW 14.12 COL 1.29 NO-LABEL WIDGET-ID 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 57.43 BY 17.35
         FONT 8 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CINV T "?" NO-UNDO INTEGRAL InvcPDA
      TABLE: T-DINV T "?" ? INTEGRAL InvdPDA
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONTEO SELECTIVO - LISTA"
         HEIGHT             = 17.35
         WIDTH              = 57.43
         MAX-HEIGHT         = 17.35
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17.35
         VIRTUAL-WIDTH      = 80
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
/* BROWSE-TAB BROWSE-2 1 F-Main */
/* SETTINGS FOR FILL-IN txtCodInv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtZonas IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.InvCargaInicial,INTEGRAL.Almmmatg OF INTEGRAL.InvCargaInicial"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _Where[1]         = "InvCargaInicial.codcia = s-codcia and 
InvCargaInicial.codalm = s-codalm and
((p-conteo = 2 and InvCargaInicial.sRecontar = 'S') or 
(p-conteo = 3 and InvCargaInicial.s3erRecontar = 'S')) and
(InvCargaInicial.swrksele[p-conteo] = '' or InvCargaInicial.swrksele[p-conteo] = ?)

"
     _FldNameList[1]   > INTEGRAL.InvCargaInicial.CodMat
"InvCargaInicial.CodMat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONTEO SELECTIVO - LISTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONTEO SELECTIVO - LISTA */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main
DO:
    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.

    DEFINE VARIABLE lRowCurrent AS INTEGER.
    
    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.
    
    /* See if there are ANY rows in view... */
    
    IF SELF:NUM-ITERATIONS = 0 THEN 
    DO:
       /* No rows, the user clicked on an empty browse widget */
       RETURN NO-APPLY. 
    END.
    
    /* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
    lRowCurrent = SELF:CURRENT-RESULT-ROW.
    SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
    hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
    iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
    iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
    iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */
    
    /* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
    dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
    iRow       = TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).
        
    IF iRow = 1  THEN DO:
        IF dRow > 1  THEN DO:
            iRow = iRow + 1.
        END.
    END.
    ELSE DO:
        iRow = iRow + 1.
    END.
    
    IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
    DO:
      /* The user clicked on a populated row */
      /*Your coding here, for example:*/
        SELF:SELECT-ROW(iRow).
        DEFINE VAR lxZonas AS CHAR.

        DEFINE VAR lyZonas AS CHAR INIT ''.

          txtZonas:SCREEN-VALUE IN FRAM {&FRAME-NAME}= ''.
          FOR EACH invCPDA WHERE invCPDA.codcia = s-codcia AND 
                                invCPDA.codalm = invCargaInicial.codalm AND 
                                invCPDA.codmat = invCargaInicial.Codmat AND 
                                invCPDA.sconteo = (p-Conteo - 1) NO-LOCK:
                IF lyZonas <> '' THEN lyZonas = lyZonas + ",".
                lyZonas = lyZonas + TRIM(invCPDA.CZONA).
          END.
        txtZonas:SCREEN-VALUE  IN FRAM {&FRAME-NAME} = lyZonas.
        ASSIGN txtZonas.
        
        lxZonas = txtZonas:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

        IF lxZonas <> '' AND lxZonas <> ? THEN DO:
            RUN MINI\w-3er-conteo-selectivo-v2.r(INPUT p-Conteo, 
                                              INPUT invCargaInicial.Codmat, 
                                              INPUT lxZonas,
                                              INPUT pCodInventariador
                                              ).
        END.
      
    END.
    ELSE DO:
      /* The click was on an empty row. */
      SELF:DESELECT-ROWS().
    
      RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:

    DEFINE VAR lxZonas AS CHAR INIT ''.

  txtZonas:SCREEN-VALUE IN FRAM {&FRAME-NAME}= ''.
  FOR EACH invCPDA WHERE invCPDA.codcia = s-codcia AND 
                        invCPDA.codalm = invCargaInicial.codalm AND 
                        invCPDA.codmat = invCargaInicial.Codmat AND 
                        invCPDA.sconteo = (p-Conteo - 1) NO-LOCK:
        IF lxZonas <> '' THEN lxZonas = lxZonas + ",".
        lxZonas = lxZonas + TRIM(invCPDA.CZONA).
  END.
    txtZonas:SCREEN-VALUE  IN FRAM {&FRAME-NAME} = lxZonas.
    ASSIGN txtZonas.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
    /* Control de lo ya ingresado */
    IF CAN-FIND(FIRST T-DINV NO-LOCK) THEN DO:
        MESSAGE 'Aún no ha grabado la información registrada' SKIP
            'Continuamos?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Refrescar */
DO:
  {&OPEN-QUERY-BROWSE-2}
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
  DISPLAY txtCodInv txtZonas 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-2 BUTTON-3 BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar W-Win 
PROCEDURE Grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lDif AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE j AS INTE INIT 1 NO-UNDO.
DEFINE VARIABLE iSConteo AS INTE INIT 3 NO-UNDO.    /* 3er Conteo */
DEFINE VARIABLE dFechReg AS DATETIME NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /*
    /* Borramos las tablas */
    FOR EACH InvcPDA WHERE InvcPDA.CodCia = s-codcia
        AND InvcPDA.CodAlm = s-codalm
        AND InvcPDA.CZona = COMBO-BOX-CodUbi
        AND InvcPDA.SConteo = iSConteo:
        DELETE InvcPDA.
    END.
    FOR EACH InvdPDA WHERE InvdPDA.CodCia = s-codcia
        AND InvdPDA.CodAlm = s-codalm
        AND InvdPDA.CZona = COMBO-BOX-CodUbi
        AND InvdPDA.SConteo = iSConteo:
        DELETE InvdPDA.
    END.
    /* 1ro Cargamos InvdPDA */
    dFechReg = DATETIME(TODAY,MTIME).
    FOR EACH T-DINV BY T-DINV.CItem:
        CREATE InvdPDA.
        BUFFER-COPY T-DINV
            TO InvdPDA
            ASSIGN
            InvdPDA.CodCia  = s-codcia
            InvdPDA.CodAlm  = s-codalm
            InvdPDA.CItem   = j
            InvdPDA.SConteo = iSConteo
            InvdPDA.CUser   = s-user-id
            InvdPDA.FechReg = dFechReg.
        j = j + 1.
        DELETE T-DINV.
    END.
    /* 2do Cargamos InvcPDA */
    FOR EACH InvdPDA NO-LOCK WHERE InvdPDA.CodCia = s-codcia
        AND InvdPDA.CodAlm = s-codalm
        AND InvdPDA.CZona  = COMBO-BOX-CodUbi
        AND InvdPDA.SConteo = iSConteo:
        FIND FIRST InvcPDA WHERE InvcPDA.CodAlm = s-codalm
            AND InvcPDA.CodCia = s-codcia
            AND InvcPDA.CodMat = InvdPDA.CodMat
            AND InvcPDA.CZona = InvdPDA.CZona
            AND InvcPDA.SConteo = InvdPDA.SConteo
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE InvcPDA THEN CREATE InvcPDA.
        ASSIGN
            InvcPDA.CodAlm = s-codalm
            InvcPDA.CodCia = s-codcia
            InvcPDA.CodMat = InvdPDA.CodMat
            InvcPDA.CZona  = InvdPDA.CZona
            InvcPDA.QNeto  = InvcPDA.QNeto + InvdPDA.QNeto
            InvcPDA.SConteo = InvdPDA.SConteo.
    END.
    /* 3ro Marcamos la zona como ya procesada */
    FIND InvZonas WHERE InvZonas.CodCia = s-codcia
        AND InvZonas.CodAlm = s-codalm
        AND InvZonas.CZona = COMBO-BOX-CodUbi
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE InvZonas THEN InvZonas.SCont3 = YES.
    */
END.
IF AVAILABLE InvcPDA THEN RELEASE InvcPDA.
IF AVAILABLE InvdPDA THEN RELEASE InvdPDA.
IF AVAILABLE InvZonas THEN RELEASE InvZonas.

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
  EMPTY TEMP-TABLE T-DINV.
  s-adm-new-record = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   DO WITH FRAME {&FRAME-NAME}:                                   */
/*       FOR EACH InvZonas NO-LOCK WHERE InvZonas.CodCia = s-codcia */
/*           AND InvZonas.CodAlm = s-codalm                         */
/*           AND InvZonas.SCont1 = YES                              */
/*           AND InvZonas.SCont2 = YES                              */
/*           AND InvZonas.SCont3 = NO:                              */
/*           COMBO-BOX-CodUbi:ADD-LAST(InvZonas.CZona).             */
/*       END.                                                       */
/*   END.                                                           */

  txtCodInv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pCodInventariador.

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
  {src/adm/template/snd-list.i "InvCargaInicial"}
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

