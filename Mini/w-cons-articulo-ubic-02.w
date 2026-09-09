&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
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
DEF SHARED VAR s-codalm AS CHAR.

DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodMat BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat FILL-IN-DesMat ~
FILL-IN-DesMar FILL-IN-StkAct FILL-IN-Ubicacion FILL-IN-StkTra ~
FILL-IN-UndStk FILL-IN-StkDis FILL-IN-UltIng FILL-IN-MaxCam FILL-IN-EmpRep ~
FILL-IN-MaxNoCam FILL-IN-UltVta 

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
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(14)":U 
     LABEL "Código" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-EmpRep AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Emp. Repos." 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-MaxCam AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Máximo Campaña" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-MaxNoCam AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Máximo no Campaña" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-StkAct AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Stock Actual" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-StkDis AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Stock Disponible" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-StkTra AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Stock en Tránsito" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Ubicacion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ubicación" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-UltIng AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Ult. Ingreso" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-UltVta AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Salidas x Ventas Ult. 15 días" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-UndStk AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodMat AT ROW 1.27 COL 14 COLON-ALIGNED WIDGET-ID 2
     BtnDone AT ROW 1 COL 68 WIDGET-ID 28
     FILL-IN-DesMat AT ROW 2.62 COL 14 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-DesMar AT ROW 3.96 COL 14 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-StkAct AT ROW 3.96 COL 55 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Ubicacion AT ROW 5.31 COL 14 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-StkTra AT ROW 5.31 COL 55 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-UndStk AT ROW 6.65 COL 14 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-StkDis AT ROW 6.65 COL 55 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-UltIng AT ROW 8 COL 14 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-MaxCam AT ROW 8 COL 55 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-EmpRep AT ROW 9.35 COL 14 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-MaxNoCam AT ROW 9.35 COL 55 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-UltVta AT ROW 10.69 COL 55 COLON-ALIGNED WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.43 BY 11.23
         FONT 10 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA RAPIDA DE ARTICULO"
         HEIGHT             = 11.23
         WIDTH              = 77.43
         MAX-HEIGHT         = 18.15
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 18.15
         VIRTUAL-WIDTH      = 80
         MAX-BUTTON         = no
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-DesMar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-EmpRep IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-MaxCam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-MaxNoCam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-StkAct IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-StkDis IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-StkTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Ubicacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UltIng IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UltVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UndStk IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA RAPIDA DE ARTICULO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA RAPIDA DE ARTICULO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
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



&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat W-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Código */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Pinta-Datos.
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON 'RETURN':U OF FILL-IN-CodMat
DO:
    RETURN.
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
  DISPLAY FILL-IN-CodMat FILL-IN-DesMat FILL-IN-DesMar FILL-IN-StkAct 
          FILL-IN-Ubicacion FILL-IN-StkTra FILL-IN-UndStk FILL-IN-StkDis 
          FILL-IN-UltIng FILL-IN-MaxCam FILL-IN-EmpRep FILL-IN-MaxNoCam 
          FILL-IN-UltVta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodMat BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Datos W-Win 
PROCEDURE Pinta-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pCodMat AS CHAR NO-UNDO.
DEF VAR x-Total AS DEC NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    pCodMat = FILL-IN-CodMat:SCREEN-VALUE.
    CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
    FILL-IN-CodMat:SCREEN-VALUE = pCodmat.
    FIND Almmmatg WHERE Almmmatg.CodCia = s-codcia
        AND Almmmatg.codmat = FILL-IN-CodMat:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN RETURN.
    DISPLAY
        Almmmatg.desmar @ FILL-IN-DesMar
        Almmmatg.desmat @ FILL-IN-DesMat
        Almmmatg.undstk @ FILL-IN-UndStk.
    FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia 
        AND Almmmate.codalm = s-codalm 
        AND Almmmate.codmat = FILL-IN-CodMat:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almmmate THEN RETURN.
    DISPLAY 
        almmmate.codubi @ FILL-IN-Ubicacion
        almmmate.stkact @ FILL-IN-StkAct 
        Almmmate.StkAct - Almmmate.StkComprometido @ FILL-IN-StkDis
        Almmmate.VCtMn1 @ FILL-IN-MaxCam
        Almmmate.VCtMn2 @ FILL-IN-MaxNoCam
        Almmmate.StkMax @ FILL-IN-EmpRep.
    /* En Tránsito */
    RUN alm\p-articulo-en-transito (
        Almmmate.CodCia,
        Almmmate.CodAlm,
        Almmmate.CodMat,
        INPUT-OUTPUT TABLE tmp-tabla,
        OUTPUT x-Total).
    DISPLAY
        x-Total @  FILL-IN-StkTra.
    FIND LAST Almdmov USE-INDEX Almd03 WHERE Almdmov.codcia = s-codcia
        AND Almdmov.codalm = s-codalm
        AND Almdmov.codmat = FILL-IN-CodMat:SCREEN-VALUE
        AND Almdmov.tipmov = "I"
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN DISPLAY Almdmov.fchdoc @ FILL-IN-UltIng.
    x-Total = 0.
    FOR EACH almdmov NO-LOCK USE-INDEX Almd03 WHERE almdmov.codcia = s-codcia
        AND almdmov.codalm = s-codalm
        AND almdmov.codmat = FILL-IN-CodMat:SCREEN-VALUE
        AND almdmov.fchdoc >= TODAY - 15
        AND almdmov.tipmov = 's'
        AND almdmov.codmov = 02:
        x-Total = x-Total + (almdmov.candes * almdmov.factor).
    END.
    DISPLAY
        x-Total @ FILL-IN-UltVta.
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

