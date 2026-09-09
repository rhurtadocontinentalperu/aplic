&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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

DEF INPUT PARAMETER pFlgSit AS CHAR.

/* Valores:
    T: En zona de Piqueo
    P: En zona de Chequeo
*/    
    
    
DEFINE NEW SHARED VARIABLE S-FLGSIT AS CHAR.
s-FlgSit = pFlgSit.

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
&Scoped-Define ENABLED-OBJECTS TOGGLE-doble-ubicacion COMBO-BOX-CodRef ~
FILL-IN-NroRef FILL-IN-CodUbi FILL-IN-NroPed RADIO-SET-Tipo txtDesde ~
txtHasta BUTTON-13 BUTTON-14 COMBO-BOX-Sector COMBO-BOX-PHR RECT-2 RECT-1 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-doble-ubicacion COMBO-BOX-CodRef ~
FILL-IN-NroRef FILL-IN-CodUbi FILL-IN-NroPed RADIO-SET-Tipo txtDesde ~
txtHasta COMBO-BOX-Sector COMBO-BOX-PHR 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-impresion-hpk AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-impresion-hpk-det AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-13 
     LABEL "APLICAR FILTROS" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON-14 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 14" 
     SIZE 7.43 BY 1.62.

DEFINE VARIABLE COMBO-BOX-CodRef AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "Referencia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "TODOS","O/D","OTR" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-PHR AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "PHR" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "TODOS" 
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Sector AS CHARACTER FORMAT "X(256)":U INITIAL "TODOS" 
     LABEL "Sector" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "TODOS" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodUbi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zona" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nro. de HPK" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde Fecha de Pedido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NO Impresos", 0,
"Impresos", 1
     SIZE 12 BY 1.65
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 149 BY 2.69
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 149 BY 1.88
     BGCOLOR 15 FGCOLOR 0 .

DEFINE VARIABLE TOGGLE-doble-ubicacion AS LOGICAL INITIAL no 
     LABEL "Considera doble ubicacion" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     TOGGLE-doble-ubicacion AT ROW 16.38 COL 113 WIDGET-ID 128
     COMBO-BOX-CodRef AT ROW 2.35 COL 35 COLON-ALIGNED WIDGET-ID 120
     FILL-IN-NroRef AT ROW 2.35 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     FILL-IN-CodUbi AT ROW 1.27 COL 81 COLON-ALIGNED WIDGET-ID 118
     FILL-IN-NroPed AT ROW 2.35 COL 11 COLON-ALIGNED WIDGET-ID 116
     RADIO-SET-Tipo AT ROW 1.27 COL 62 NO-LABEL WIDGET-ID 110
     txtDesde AT ROW 1.27 COL 21 COLON-ALIGNED WIDGET-ID 22
     txtHasta AT ROW 1.27 COL 40 COLON-ALIGNED WIDGET-ID 24
     BUTTON-13 AT ROW 1.27 COL 132 WIDGET-ID 4
     BUTTON-14 AT ROW 14.19 COL 113 WIDGET-ID 104
     COMBO-BOX-Sector AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 38
     COMBO-BOX-PHR AT ROW 4.23 COL 44 COLON-ALIGNED WIDGET-ID 46
     "Filtro dinámico" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 3.69 COL 3 WIDGET-ID 52
          BGCOLOR 9 FGCOLOR 15 
     RECT-2 AT ROW 3.69 COL 2 WIDGET-ID 48
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 108
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 151.43 BY 27
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "IMPRESION DE HOJAS DE PICKING"
         HEIGHT             = 27
         WIDTH              = 151.43
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 158.86
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 158.86
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPRESION DE HOJAS DE PICKING */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPRESION DE HOJAS DE PICKING */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* APLICAR FILTROS */
DO:
    ASSIGN txtDesde txtHasta RADIO-SET-Tipo.
    ASSIGN FILL-IN-CodUbi FILL-IN-NroPed.
    ASSIGN COMBO-BOX-CodRef FILL-IN-NroRef.

    RUN Recibe-Parametros IN h_b-impresion-hpk
    ( INPUT txtDesde /* DATE */,
      INPUT txtHasta /* DATE */,
      INPUT RADIO-SET-Tipo,
      INPUT FILL-IN-NroPed,
      INPUT FILL-IN-CodUbi,
      INPUT COMBO-BOX-CodRef,
      INPUT FILL-IN-NroRef
      ).

    /* Actualizamos combo de sectores */
    DEF VAR pSector AS CHAR NO-UNDO.

    COMBO-BOX-Sector:DELETE(COMBO-BOX-Sector:LIST-ITEMS).
    RUN Actualiza-Sectores IN h_b-impresion-hpk ( OUTPUT pSector /* CHARACTER */).
    pSector = 'TODOS' + (IF TRUE <> (pSector > '') THEN '' ELSE ',') + pSector.
    COMBO-BOX-Sector:ADD-LAST(pSector).
    COMBO-BOX-Sector:SCREEN-VALUE = 'TODOS'.

    /* Actualizamos combo de PHR */
    DEF VAR pPHR AS CHAR NO-UNDO.

    COMBO-BOX-PHR:DELETE(COMBO-BOX-PHR:LIST-ITEMS).
    RUN Actualiza-PHR IN h_b-impresion-hpk ( OUTPUT pPHR /* CHARACTER */).
    pPHR = 'TODOS' + (IF TRUE <> (pPHR > '') THEN '' ELSE ',') + pPHR.
    COMBO-BOX-PHR:ADD-LAST(pPHR).
    COMBO-BOX-PHR:SCREEN-VALUE = 'TODOS'.

    RUN dispatch IN h_b-impresion-hpk ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 W-Win
ON CHOOSE OF BUTTON-14 IN FRAME F-Main /* Button 14 */
DO:

   ASSIGN toggle-doble-ubicacion.

   IF toggle-doble-ubicacion = YES THEN DO:
       RUN setDobleUbicacion IN h_b-impresion-hpk (INPUT 1).
       RUN dispatch IN h_b-impresion-hpk ('imprime':U).
       RUN setDobleUbicacion IN h_b-impresion-hpk (INPUT 2).
       RUN dispatch IN h_b-impresion-hpk ('imprime':U).
   END.
   ELSE DO:
        RUN setDobleUbicacion IN h_b-impresion-hpk (INPUT 0).
        RUN dispatch IN h_b-impresion-hpk ('imprime':U).
   END.
   
   /*RUN dispatch IN h_b-impresion-hpk ('imprime':U).*/
   /*RUN Formato IN h_b-impresion-hpk.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-PHR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-PHR W-Win
ON VALUE-CHANGED OF COMBO-BOX-PHR IN FRAME F-Main /* PHR */
DO:
    ASSIGN {&self-name}.
    RUN Captura-PHR IN h_b-impresion-hpk
      ( INPUT SELF:SCREEN-VALUE /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Sector
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Sector W-Win
ON VALUE-CHANGED OF COMBO-BOX-Sector IN FRAME F-Main /* Sector */
DO:
  ASSIGN {&self-name}.
  RUN Captura-Sector IN h_b-impresion-hpk
    ( INPUT SELF:SCREEN-VALUE /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
CASE s-FlgSit:
    WHEN "T" THEN {&WINDOW-NAME}:TITLE = "IMPRESION HPK EN PIQUEO".
    WHEN "P" THEN {&WINDOW-NAME}:TITLE = "IMPRESION HPK EN CHEQUEO".
END CASE.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-impresion-hpk.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-impresion-hpk ).
       RUN set-position IN h_b-impresion-hpk ( 5.85 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-impresion-hpk ( 8.12 , 149.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-impresion-hpk-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-impresion-hpk-det ).
       RUN set-position IN h_b-impresion-hpk-det ( 13.92 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-impresion-hpk-det ( 14.00 , 110.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-impresion-hpk-det. */
       RUN add-link IN adm-broker-hdl ( h_b-impresion-hpk , 'Record':U , h_b-impresion-hpk-det ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-impresion-hpk ,
             BUTTON-14:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-impresion-hpk-det ,
             h_b-impresion-hpk , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
  DISPLAY TOGGLE-doble-ubicacion COMBO-BOX-CodRef FILL-IN-NroRef FILL-IN-CodUbi 
          FILL-IN-NroPed RADIO-SET-Tipo txtDesde txtHasta COMBO-BOX-Sector 
          COMBO-BOX-PHR 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE TOGGLE-doble-ubicacion COMBO-BOX-CodRef FILL-IN-NroRef FILL-IN-CodUbi 
         FILL-IN-NroPed RADIO-SET-Tipo txtDesde txtHasta BUTTON-13 BUTTON-14 
         COMBO-BOX-Sector COMBO-BOX-PHR RECT-2 RECT-1 
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
  ASSIGN
      txtDesde = TODAY - 2
      txtHasta = TODAY.

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

