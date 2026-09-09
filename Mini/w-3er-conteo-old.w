&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-DINV LIKE AlmDInv.



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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-adm-new-record AS LOG INIT NO NO-UNDO.
DEF VAR s-NroSecuencia AS INT NO-UNDO.

/* Control */
FIND FIRST Almcinv WHERE AlmCInv.Codcia = s-codcia
    AND AlmCInv.CodAlm = s-codalm
    AND AlmCInv.SwConteo = YES
    AND AlmCInv.SwReconteo = YES
    AND AlmCInv.Sw3Conteo = NO
    AND AlmCInv.NomCia = 'CONTI'
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcinv THEN DO:
    MESSAGE 'No se puede hacer el 3er. conteo' SKIP
        'No se ha configurado el inventario, no se ha hecho el segundo conteo o ya se hizo el conteo'
        VIEW-AS ALERT-BOX WARNING.
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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodUbi FILL-IN-CodMat FILL-IN-Qty ~
BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodUbi FILL-IN-CodMat ~
FILL-IN-UndBas EDITOR-DesMat FILL-IN-Factor FILL-IN-Qty FILL-IN-Cantidad 

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
     SIZE 6 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Grabar 
     IMAGE-UP FILE "img/tbldef.ico":U
     LABEL "GRABAR EN INVENTARIOS" 
     SIZE 6 BY 1.54 TOOLTIP "GRABAR EN INVENTARIOS".

DEFINE VARIABLE COMBO-BOX-CodUbi AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione" 
     LABEL "UBICACION" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Seleccione" 
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-DesMat AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 45 BY 3.85
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cantidad AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Total Inventario" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.35 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(20)":U 
     LABEL "ARTICULO" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.35 NO-UNDO.

DEFINE VARIABLE FILL-IN-Factor AS DECIMAL FORMAT ">>>,>>9.9999":U INITIAL 0 
     LABEL "Factor" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.35 NO-UNDO.

DEFINE VARIABLE FILL-IN-Qty AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.35 NO-UNDO.

DEFINE VARIABLE FILL-IN-UndBas AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1.35 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodUbi AT ROW 1.19 COL 21 COLON-ALIGNED WIDGET-ID 28
     FILL-IN-CodMat AT ROW 2.73 COL 21 COLON-ALIGNED WIDGET-ID 34 AUTO-RETURN 
     FILL-IN-UndBas AT ROW 2.73 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     EDITOR-DesMat AT ROW 4.27 COL 3 NO-LABEL WIDGET-ID 30
     FILL-IN-Factor AT ROW 8.31 COL 28 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-Qty AT ROW 9.65 COL 28 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-Cantidad AT ROW 11 COL 28 COLON-ALIGNED WIDGET-ID 32
     BUTTON-Grabar AT ROW 12.54 COL 38 WIDGET-ID 16
     BtnDone AT ROW 12.54 COL 44 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 49.43 BY 13.15
         FONT 8 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DINV T "?" ? INTEGRAL AlmDInv
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "3er. CONTEO"
         HEIGHT             = 13.15
         WIDTH              = 49.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
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
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-Grabar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Cantidad IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Factor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UndBas IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* 3er. CONTEO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* 3er. CONTEO */
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


&Scoped-define SELF-NAME BUTTON-Grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Grabar W-Win
ON CHOOSE OF BUTTON-Grabar IN FRAME F-Main /* GRABAR EN INVENTARIOS */
DO:
   IF NOT CAN-FIND(FIRST T-DINV NO-LOCK) THEN RETURN NO-APPLY.
   MESSAGE 'Se va a grabar todo lo registrado' SKIP
       'Procedemos?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
       UPDATE rpta AS LOG.
   IF rpta = NO THEN RETURN NO-APPLY.
   RUN Grabar NO-ERROR.
   IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
   DO WITH FRAME {&FRAME-NAME}:
       /* Control de lo ya ingresado */
       COMBO-BOX-CodUbi:DELETE(COMBO-BOX-CodUbi:SCREEN-VALUE).
       COMBO-BOX-CodUbi:SENSITIVE = YES.
       BUTTON-Grabar:SENSITIVE = NO.
       COMBO-BOX-CodUbi = 'Seleccione'.
       COMBO-BOX-CodUbi:SCREEN-VALUE = 'Seleccione'.
       APPLY 'ENTRY':U TO COMBO-BOX-CodUbi.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodUbi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodUbi W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodUbi IN FRAME F-Main /* UBICACION */
DO:
  ASSIGN {&self-name}.
  FIND FIRST AlmCInv WHERE AlmCInv.CodCia = s-CodCia
      AND AlmCInv.CodAlm  = s-codalm
      AND AlmcInv.NomCia  = "CONTI"
      AND AlmCInv.CodAlma = COMBO-BOX-CodUbi
      NO-LOCK NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Cantidad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Cantidad W-Win
ON LEAVE OF FILL-IN-Cantidad IN FRAME F-Main /* Total Inventario */
OR ENTER OF FILL-IN-Cantidad
DO:
  IF FILL-IN-CodMat = '' THEN DO:
      APPLY 'ENTRY':U TO FILL-IN-CodMat.
      RETURN NO-APPLY.
  END.
  ASSIGN {&self-name}.
  IF FILL-IN-Cantidad = 0 THEN DO:
      MESSAGE 'La cantidad ingresada es 0' SKIP
          'Continuamos con la grabación?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          APPLY 'ENTRY':U TO FILL-IN-Qty.
          RETURN NO-APPLY.
      END.
  END.
  CREATE T-DINV.
  ASSIGN
      s-NroSecuencia = s-NroSecuencia + 1
      T-DINV.Codcia = s-codcia
      T-DINV.CodAlm = s-codalm
      T-DINV.codmat = Almmmatg.codmat
      T-DINV.CodUbi = COMBO-BOX-CodUbi
      T-DINV.NomCia = "CONTI"
      T-DINV.NroPagina = 1
      T-DINV.NroSecuencia = s-NroSecuencia
      T-DINV.QtyConteo = FILL-IN-Cantidad.
  s-adm-new-record = YES.
  PAUSE 1 NO-MESSAGE.
  ASSIGN
      FILL-IN-CodMat = ''
      EDITOR-DesMat = ''
      FILL-IN-Cantidad = 0
      FILL-IN-Factor = 1
      FILL-IN-Qty = 1
      BUTTON-Grabar:SENSITIVE = YES.
  DISPLAY FILL-IN-CodMat EDITOR-DesMat FILL-IN-CodMat FILL-IN-Cantidad  
      FILL-IN-Factor FILL-IN-Qty
      WITH FRAME {&FRAME-NAME}.
  APPLY 'ENTRY':U TO FILL-IN-CodMat.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat W-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* ARTICULO */
OR ENTER OF FILL-IN-CodMat
DO:
    ASSIGN {&self-name}.
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF COMBO-BOX-CodUbi = 'Seleccione' THEN DO:
        BELL.
        MESSAGE 'Seleccione una UBICACION' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO COMBO-BOX-CodUbi.
        RETURN NO-APPLY.
    END.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    DEF VAR pFactor AS DECI NO-UNDO.
    DEF VAR pCanPed AS DECI NO-UNDO.

    pCodMat = SELF:SCREEN-VALUE.
    pFactor = 1.
    pCanPed = 1.
    /*RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).*/
    RUN alm/p-codbrr (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pFactor, s-codcia).
    IF pCodMat = '' THEN DO:
        BELL.
        MESSAGE 'Código errado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    EDITOR-DesMat:SCREEN-VALUE = Almmmatg.desmat.
    FIND Almdinv WHERE Almdinv.CodCia = Almmmatg.codcia
        AND Almdinv.CodAlm = s-codalm
        AND Almdinv.codmat = Almmmatg.codmat
        AND Almdinv.codubi = COMBO-BOX-CodUbi
        AND Almdinv.nomcia = "CONTI"
        NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        BELL.
        MESSAGE 'No registrado en el almacén o en la ubicación' SKIP 
            'Almacén:' s-codalm SKIP 
            'Ubicación:' COMBO-BOX-CodUbi
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    ASSIGN
        COMBO-BOX-CodUbi:SENSITIVE = NO
        FILL-IN-Factor = pFactor
        FILL-IN-Qty = pCanPed
        FILL-IN-Cantidad = pCanPed * pFactor.
    DISPLAY
        Almmmatg.undstk @ FILL-IN-UndBas
        FILL-IN-Factor
        FILL-IN-Qty
        FILL-IN-Cantidad
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Factor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Factor W-Win
ON LEAVE OF FILL-IN-Factor IN FRAME F-Main /* Factor */
OR ENTER OF FILL-IN-Cantidad
DO:
  IF FILL-IN-CodMat = '' THEN DO:
      APPLY 'ENTRY':U TO FILL-IN-CodMat.
      RETURN NO-APPLY.
  END.
  ASSIGN {&self-name}.
  IF FILL-IN-Cantidad = 0 THEN DO:
      MESSAGE 'La cantidad ingresada es 0' SKIP
          'Continuamos con la grabación?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          APPLY 'ENTRY':U TO FILL-IN-CodMat.
          RETURN NO-APPLY.
      END.
  END.
  CREATE T-DINV.
  ASSIGN
      s-NroSecuencia = s-NroSecuencia + 1
      T-DINV.Codcia = s-codcia
      T-DINV.CodAlm = s-codalm
      T-DINV.codmat = Almmmatg.codmat
      T-DINV.CodUbi = COMBO-BOX-CodUbi
      T-DINV.NomCia = "CONTI"
      T-DINV.NroPagina = 1
      T-DINV.NroSecuencia = s-NroSecuencia
      T-DINV.QtyConteo = FILL-IN-Cantidad.
  s-adm-new-record = YES.
  PAUSE 1 NO-MESSAGE.
  ASSIGN
      FILL-IN-CodMat = ''
      EDITOR-DesMat = ''
      FILL-IN-Cantidad = 0
      BUTTON-Grabar:SENSITIVE = YES.
  DISPLAY FILL-IN-CodMat EDITOR-DesMat FILL-IN-CodMat FILL-IN-Cantidad WITH FRAME {&FRAME-NAME}.
  APPLY 'ENTRY':U TO FILL-IN-CodMat.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Qty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Qty W-Win
ON LEAVE OF FILL-IN-Qty IN FRAME F-Main /* Cantidad */
OR ENTER OF FILL-IN-Qty
DO:
  IF FILL-IN-CodMat = '' THEN DO:
      APPLY 'ENTRY':U TO FILL-IN-CodMat.
      RETURN NO-APPLY.
  END.
  ASSIGN {&self-name} FILL-IN-Cantidad = FILL-IN-Factor * FILL-IN-Qty.
  DISPLAY
      FILL-IN-Cantidad
      WITH FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO FILL-IN-Cantidad.
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
  DISPLAY COMBO-BOX-CodUbi FILL-IN-CodMat FILL-IN-UndBas EDITOR-DesMat 
          FILL-IN-Factor FILL-IN-Qty FILL-IN-Cantidad 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodUbi FILL-IN-CodMat FILL-IN-Qty BtnDone 
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
/*
      T-DINV.Codcia = s-codcia
      T-DINV.CodAlm = s-codalm
      T-DINV.codmat = Almmmatg.codmat
      T-DINV.CodUbi = COMBO-BOX-CodUbi
      T-DINV.NomCia = "CONTI"
*/

DEFINE VARIABLE lDif AS LOGICAL INITIAL NO NO-UNDO.

FOR EACH T-DINV BREAK BY T-DINV.CodMat
    TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR: 
    IF FIRST-OF(T-DINV.CodMat) THEN DO:
        {lib/lock-genericov2.i &Tabla="Almdinv" ~
            &Condicion="Almdinv.codcia = T-DINV.codcia ~
            AND Almdinv.codalm = T-DINV.codalm ~
            AND Almdinv.codmat = T-DINV.codmat ~
            AND Almdinv.codubi = T-DINV.codubi ~
            AND Almdinv.nomcia = 'CONTI'" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="RETURN ERROR"
            }
    END.
    ASSIGN
        Almdinv.Libre_d02 = Almdinv.Libre_d02 + T-DINV.QtyConteo
        Almdinv.Libre_d01 = Almdinv.QtyConteo
        Almdinv.Libre_c01 = s-user-id. 
    IF LAST-OF(T-DINV.CodMat) THEN DO:
        IF (AlmDInv.Libre_d02 - AlmDInv.QtyFisico) <> 0 THEN lDif = YES.
        FIND FIRST AlmCInv WHERE AlmCInv.CodCia = s-CodCia
            AND AlmCInv.CodAlm  = s-codalm
            AND AlmcInv.NomCia  = "CONTI"
            AND AlmCInv.CodAlma = AlmDInv.CodUbi
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Almcinv THEN UNDO, RETURN ERROR.
        ASSIGN
            AlmCInv.Sw3Conteo    = YES 
            AlmCInv.CodUser      = s-user-id 
            AlmCInv.CodUserRec   = s-user-id
            AlmCInv.SwDiferencia = lDif.
    END.
    DELETE T-DINV.
END.
IF AVAILABLE Almcinv THEN RELEASE Almcinv.
IF AVAILABLE Almdinv THEN RELEASE Almdinv.

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
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH AlmCInv NO-LOCK WHERE AlmCInv.CodCia = s-CodCia
          AND AlmCInv.CodAlm  = s-codalm
          AND AlmcInv.NomCia  = "CONTI"
          AND AlmCInv.SwConteo = YES
          AND AlmCInv.SwReconteo = YES
          AND AlmCInv.Sw3Conteo = NO:
          COMBO-BOX-CodUbi:ADD-LAST(AlmCInv.CodAlma).
      END.
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

