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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Barra COMBO-BOX-Prioridad ~
COMBO-BOX-Embalaje COMBO-BOX-Mesa BUTTON-37 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Barra FILL-IN-6 FILL-IN_CodDoc ~
FILL-IN_NroPed FILL-IN_NroItems FILL-IN_NomCli FILL-IN_CrossDocking ~
FILL-IN_AlmacenXD COMBO-BOX-Prioridad COMBO-BOX-Embalaje COMBO-BOX-Mesa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/error.ico":U
     LABEL "&Done" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-37 
     IMAGE-UP FILE "img/ok.ico":U
     LABEL "Button 37" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Embalaje AS LOGICAL FORMAT "SI/NO":U INITIAL NO 
     LABEL "Embalado especial" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Yes","No" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mesa AS CHARACTER FORMAT "X(256)":U 
     LABEL "Asignar Mesa" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Prioridad AS CHARACTER FORMAT "X(256)":U INITIAL "Normal" 
     LABEL "Prioridad" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Normal","Urgente" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(50)":U INITIAL "SOLO HPK" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .96
     FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-Barra AS CHARACTER FORMAT "X(256)":U 
     LABEL "CODIGO DE BARRA" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1.62
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN_AlmacenXD AS CHARACTER FORMAT "x(10)" 
     LABEL "Destino Final" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY 1.38.

DEFINE VARIABLE FILL-IN_Cantidad1 AS INTEGER FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Jaba" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY 1.38
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_Cantidad2 AS INTEGER FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Paleta" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY 1.38
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_Cantidad3 AS INTEGER FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Carrito" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY 1.38
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_CodDoc AS CHARACTER FORMAT "x(3)" 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1.38.

DEFINE VARIABLE FILL-IN_CrossDocking AS LOGICAL FORMAT "SI/NO" INITIAL NO 
     LABEL "CrossDocking" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1.38.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 72 BY 1.38.

DEFINE VARIABLE FILL-IN_NroItems AS INTEGER FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Cantidad de Items" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1.38.

DEFINE VARIABLE FILL-IN_NroPed AS CHARACTER FORMAT "X(15)" 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Barra AT ROW 1.81 COL 35 COLON-ALIGNED WIDGET-ID 46
     FILL-IN-6 AT ROW 2.35 COL 75 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     FILL-IN_CodDoc AT ROW 4.23 COL 35 COLON-ALIGNED WIDGET-ID 56
     FILL-IN_NroPed AT ROW 4.23 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     FILL-IN_NroItems AT ROW 5.85 COL 35 COLON-ALIGNED WIDGET-ID 60
     FILL-IN_NomCli AT ROW 7.46 COL 35 COLON-ALIGNED HELP
          "Nombre del Cliente" WIDGET-ID 16
     FILL-IN_CrossDocking AT ROW 9.08 COL 35 COLON-ALIGNED WIDGET-ID 58
     FILL-IN_AlmacenXD AT ROW 10.69 COL 35 COLON-ALIGNED WIDGET-ID 48
     FILL-IN_Cantidad1 AT ROW 12.31 COL 35 COLON-ALIGNED WIDGET-ID 50
     FILL-IN_Cantidad2 AT ROW 12.31 COL 59 COLON-ALIGNED WIDGET-ID 52
     FILL-IN_Cantidad3 AT ROW 12.31 COL 84 COLON-ALIGNED WIDGET-ID 54
     COMBO-BOX-Prioridad AT ROW 13.92 COL 35 COLON-ALIGNED WIDGET-ID 42
     COMBO-BOX-Embalaje AT ROW 15.54 COL 35 COLON-ALIGNED WIDGET-ID 38
     COMBO-BOX-Mesa AT ROW 17.15 COL 35 COLON-ALIGNED WIDGET-ID 40
     BUTTON-37 AT ROW 19.04 COL 56 WIDGET-ID 66
     BtnDone AT ROW 19.04 COL 71 WIDGET-ID 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111.72 BY 20.38
         FONT 9 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 20.38
         WIDTH              = 111.72
         MAX-HEIGHT         = 20.38
         MAX-WIDTH          = 111.72
         VIRTUAL-HEIGHT     = 20.38
         VIRTUAL-WIDTH      = 111.72
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
/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_AlmacenXD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Cantidad1 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN_Cantidad1:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_Cantidad2 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN_Cantidad2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_Cantidad3 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN_Cantidad3:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_CodDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CrossDocking IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroItems IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
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


&Scoped-define SELF-NAME BUTTON-37
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-37 W-Win
ON CHOOSE OF BUTTON-37 IN FRAME F-Main /* Button 37 */
DO:
    ASSIGN COMBO-BOX-Embalaje COMBO-BOX-Mesa COMBO-BOX-Prioridad.
    IF COMBO-BOX-Mesa = ? OR COMBO-BOX-Mesa = "" THEN DO:
      MESSAGE "Seleccione Mesa, por favor".
      RETURN NO-APPLY.
  END.

  RUN Graba-Registro.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      RETURN NO-APPLY.
  END.
  RUN Limpia-Pantalla.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Barra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Barra W-Win
ON LEAVE OF FILL-IN-Barra IN FRAME F-Main /* CODIGO DE BARRA */
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

    DEFINE VAR hProc AS HANDLE NO-UNDO.
    /* Levantamos la libreria a memoria */
    RUN dist/chk-librerias PERSISTENT SET hProc.

    /* Consistencia */
    DEF VAR x-CodDoc AS CHAR NO-UNDO.
    DEF VAR x-NroPed AS CHAR NO-UNDO.
    DEF VAR x-NroItems AS INT NO-UNDO.

    RUN lee-barra-orden IN hProc (SELF:SCREEN-VALUE, OUTPUT x-CodDoc, OUTPUT x-NroPed) .

    DELETE PROCEDURE hProc.

    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE 'Código de Barra errado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF LOOKUP(x-CodDoc, 'HPK') = 0 THEN DO:
        MESSAGE 'Código de Barra errado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    FIND FIRST vtacdocu WHERE vtacdocu.codcia = s-codcia AND
        vtacdocu.coddiv = s-coddiv AND
        vtacdocu.codped = x-coddoc AND
        vtacdocu.nroped = x-nroped NO-LOCK NO-ERROR.
    IF NOT AVAILABLE vtacdocu THEN DO:
        MESSAGE 'NO registrada en el sistema' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF NOT (vtacdocu.FlgEst = "P" AND vtacdocu.FlgSit = "P") THEN DO:
        IF Vtacdocu.FlgSit = "TX" THEN MESSAGE 'Picking Incompleto' VIEW-AS ALERT-BOX ERROR.
        ELSE MESSAGE 'Orden no puede Ingresa, revisar su estado en la Consulta de Pedidos' 
            VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    x-NroItems = vtacdocu.items.
    DISPLAY
        vtacdocu.Codped @ FILL-IN_CodDoc 
        vtacdocu.NroPed @ FILL-IN_NroPed
        vtacdocu.NomCli @ FILL-IN_NomCli 
        "NO" @ FILL-IN_CrossDocking 
        "" @ FILL-IN_AlmacenXD 
        WITH FRAME {&FRAME-NAME}.            
    COMBO-BOX-Embalaje = VtaCDocu.EmpaqEspec.
    DISPLAY COMBO-BOX-Embalaje WITH FRAME {&FRAME-NAME}.

    DISPLAY x-NroItems @ FILL-IN_NroItems WITH FRAME {&FRAME-NAME}.
    ENABLE FILL-IN_Cantidad1 FILL-IN_Cantidad2 FILL-IN_Cantidad3 WITH FRAME {&FRAME-NAME}.
    APPLY 'ENTRY':U TO FILL-IN_Cantidad1.
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
  DISPLAY FILL-IN-Barra FILL-IN-6 FILL-IN_CodDoc FILL-IN_NroPed FILL-IN_NroItems 
          FILL-IN_NomCli FILL-IN_CrossDocking FILL-IN_AlmacenXD 
          COMBO-BOX-Prioridad COMBO-BOX-Embalaje COMBO-BOX-Mesa 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Barra COMBO-BOX-Prioridad COMBO-BOX-Embalaje COMBO-BOX-Mesa 
         BUTTON-37 BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registro W-Win 
PROCEDURE Graba-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR'
    WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN_AlmacenXD 
        FILL-IN_Cantidad1 FILL-IN_Cantidad2 FILL-IN_Cantidad3 
        FILL-IN_CodDoc FILL-IN_CrossDocking FILL-IN_NomCli FILL-IN_NroItems 
        FILL-IN_NroPed FILL-IN-Barra.
    {lib/lock-genericov3.i ~
        &Tabla="Vtacdocu" ~
        &Condicion="vtacdocu.codcia = s-codcia AND ~
        vtacdocu.codped = FILL-IN_CodDoc AND ~
        vtacdocu.nroped = FILL-IN_NroPed" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    IF NOT (vtacdocu.FlgEst = "P" AND vtacdocu.FlgSit = "P") THEN DO:
        MESSAGE 'Orden no puede Ingresa, revisar su estado en la Consulta de Pedidos' 
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Ultimo control */
    CREATE ChkControl.
    ASSIGN
        ChkControl.CodCia = s-CodCia
        ChkControl.CodDiv = s-CodDiv
        ChkControl.CodDoc = FILL-IN_CodDoc
        ChkControl.NroPed = FILL-IN_NroPed
        ChkControl.AlmacenXD = FILL-IN_AlmacenXD 
        ChkControl.Cantidad[1] = FILL-IN_Cantidad1
        ChkControl.Cantidad[2] = FILL-IN_Cantidad2
        ChkControl.Cantidad[3] = FILL-IN_Cantidad3
        ChkControl.CrossDocking = FILL-IN_CrossDocking
        ChkControl.NroItems = FILL-IN_NroItems
        ChkControl.Peso = vtacdocu.peso
        .
    ASSIGN
        vtacdocu.FlgSit = "PR".     /* <<< OJO <<< */

    /* ************************************************************************ */
    /* ASIGNAMOS MESA */
    /* ************************************************************************ */
    CREATE ChkTareas.
    ASSIGN
        ChkTareas.CodCia = s-CodCia
        ChkTareas.CodDiv = s-CodDiv
        ChkTareas.CodDoc = ChkControl.CodDoc
        ChkTareas.NroPed = ChkControl.NroPed
        ChkTareas.Embalaje = COMBO-BOX-Embalaje
        ChkTareas.FechaInicio = TODAY
        ChkTareas.FlgEst = "P"      /* Valor por Defecto */
        ChkTareas.HoraInicio = STRING(TIME, 'HH:MM:SS')
        ChkTareas.Mesa = COMBO-BOX-Mesa
        ChkTareas.Prioridad = COMBO-BOX-Prioridad
        ChkTareas.UsuarioInicio = s-User-Id.
    /* ************************************************************************ */
    /* TABLAS RELACIONADAS */
    /* ************************************************************************ */
    ASSIGN
        vtacdocu.FlgSit = "PT".     /* EN COLA DE CHEQUEO */
    ASSIGN
        ChkControl.FlgEst = "T".    /* Tarea Asignada */
END.
IF AVAILABLE(vtacdocu) THEN RELEASE vtacdocu.
IF AVAILABLE(ChkControl) THEN RELEASE ChkControl.
IF AVAILABLE(ChkTareas) THEN RELEASE ChkTareas.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpia-Pantalla W-Win 
PROCEDURE Limpia-Pantalla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
APPLY 'ENTRY':U TO FILL-IN-Barra.

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
      COMBO-BOX-Mesa:DELETE(1).
      FOR EACH ChkChequeador NO-LOCK WHERE ChkChequeador.codcia = s-codcia
          AND ChkChequeador.coddiv = s-coddiv
          AND ChkChequeador.flgest = 'A'
          BREAK BY ChkChequeador.Mesa:
          /* Ic - 31Ago2018, verificamos que la mesa tenga asignado chequeador */
          IF FIRST-OF(ChkChequeador.Mesa) THEN DO:
              COMBO-BOX-Mesa = ChkChequeador.Mesa.
              COMBO-BOX-Mesa:ADD-LAST(ChkChequeador.Mesa).
          END.
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

