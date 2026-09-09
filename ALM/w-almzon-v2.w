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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE TEMP-TABLE tt-data
    FIELDS  CodAlm  AS      CHAR    FORMAT 'x(6)'   LABEL 'Almacen'
    FIELDS  Descripcion AS  CHAR    FORMAT 'x(40)'  LABEL 'Descripcion'
    FIELDS  Sector  AS      CHAR    FORMAT 'x(10)'  LABEL "Sector"
    FIELDS  codubi  AS      CHAR    FORMAT 'x(10)'  LABEL "Ubicacion"
    FIELDS  CodArt  AS      CHAR    FORMAT 'x(10)'  LABEL "Cod.Mat"
    FIELDS  Desmat  AS      CHAR    FORMAT 'x(60)'  LABEL "Descripcion"
    FIELDS  Marca   AS      CHAR    FORMAT 'x(25)'  LABEL "Marca"
    FIELDS  UndStk  AS      CHAR    FORMAT 'x(10)'  LABEL "U.M. Stk"
    FIELDS  Stock   AS      DEC     FORMAT "->>,>>>,>>9.99"   LABEL "Stock"
    FIELDS  Peso    AS      DEC     FORMAT "->>,>>>,>>9.9999" LABEL "Peso"
    FIELDS  Vol     AS      DEC     FORMAT "->>,>>>,>>9.9999" LABEL "Volumen"
    FIELDS  Estado  AS      CHAR    FORMAT 'x' LABEL 'Estado'
    FIELDS CodFam   AS      CHAR    FORMAT 'x(6)' LABEL 'Línea'
    FIELDS SubFam   AS      CHAR    FORMAT 'x(6)' LABEL 'SubLínea'
    .

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS TOGGLE-1 BUTTON-4 BUTTON-5 BUTTON-1 BUTTON-2 ~
BUTTON-3 BUTTON-6 BtnDone C-Tipo 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-1 EDITOR_Almacenes EDITOR_Sectores ~
Zona-D Zona-H FILL-IN_Lineas FILL-IN_SubLineas EDITOR_Marca R-Tipo C-Tipo 

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
     SIZE 15 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "Button 2" 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "Button 3" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "Button 4" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "Button 5" 
     SIZE 5 BY 1.12.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 6" 
     SIZE 15 BY 1.88 TOOLTIP "EXPORTAR A TEXTO".

DEFINE VARIABLE C-Tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Con-Stock" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Con-Stock","Todos" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR_Almacenes AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 70 BY 4
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE EDITOR_Marca AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 70 BY 4
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE EDITOR_Sectores AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 70 BY 4
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_Lineas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Linea(s)" 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_SubLineas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Linea(s)" 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE Zona-D AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ubicación del" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE Zona-H AS CHARACTER FORMAT "X(256)":U 
     LABEL "al" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ambos", "",
"Activados", "A",
"Desactivados", "D"
     SIZE 20 BY 3 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Solo SIN ubicacion ( vacio ó G-0)" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     TOGGLE-1 AT ROW 1.81 COL 21 WIDGET-ID 46
     EDITOR_Almacenes AT ROW 2.88 COL 21 NO-LABEL WIDGET-ID 22
     BUTTON-4 AT ROW 2.88 COL 91 WIDGET-ID 20
     EDITOR_Sectores AT ROW 6.92 COL 21 NO-LABEL WIDGET-ID 26
     BUTTON-5 AT ROW 6.92 COL 91 WIDGET-ID 30
     Zona-D AT ROW 10.96 COL 19 COLON-ALIGNED WIDGET-ID 48
     Zona-H AT ROW 10.96 COL 44 COLON-ALIGNED WIDGET-ID 50
     FILL-IN_Lineas AT ROW 12.04 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 12.04 COL 91 WIDGET-ID 6
     FILL-IN_SubLineas AT ROW 13.12 COL 19 COLON-ALIGNED WIDGET-ID 8
     BUTTON-2 AT ROW 13.12 COL 91 WIDGET-ID 10
     EDITOR_Marca AT ROW 14.19 COL 21 NO-LABEL WIDGET-ID 12
     BUTTON-3 AT ROW 14.19 COL 91 WIDGET-ID 14
     R-Tipo AT ROW 18.5 COL 21 NO-LABEL WIDGET-ID 32
     BUTTON-6 AT ROW 21.46 COL 73 WIDGET-ID 40
     BtnDone AT ROW 21.46 COL 89 WIDGET-ID 44
     C-Tipo AT ROW 21.73 COL 19 COLON-ALIGNED WIDGET-ID 38
     "Estado:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 18.5 COL 13 WIDGET-ID 36
     "Marca(s):" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 14.19 COL 12 WIDGET-ID 16
     "Almacén(es):" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 2.88 COL 9 WIDGET-ID 24
     "Sector(es):" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 6.92 COL 11 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 106.29 BY 22.58 WIDGET-ID 100.


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
         TITLE              = "ARTICULOS ZONIFICADOS POR ALMACEN"
         HEIGHT             = 22.58
         WIDTH              = 106.29
         MAX-HEIGHT         = 23.46
         MAX-WIDTH          = 110.86
         VIRTUAL-HEIGHT     = 23.46
         VIRTUAL-WIDTH      = 110.86
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
/* SETTINGS FOR EDITOR EDITOR_Almacenes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR_Marca IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR_Sectores IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Lineas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SubLineas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET R-Tipo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Zona-D IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Zona-H IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ARTICULOS ZONIFICADOS POR ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ARTICULOS ZONIFICADOS POR ALMACEN */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  DEF VAR pLineas AS CHAR NO-UNDO.

  pLineas = FILL-IN_Lineas:SCREEN-VALUE.

  RUN gn/d-filtro-lineas.w (INPUT-OUTPUT pLineas,
                            INPUT "Seleccione una o más Líneas").
  /* Control */
  IF NUM-ENTRIES(pLineas) > 5 THEN DO:
      MESSAGE 'Usted ha seleccionado más de 5 líneas' SKIP
          pLineas VIEW-AS ALERT-BOX INFORMATION.
  END.


  FILL-IN_Lineas:SCREEN-VALUE = pLineas.
  IF NUM-ENTRIES(pLineas) > 1 THEN FILL-IN_SubLineas:SCREEN-VALUE = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  DEF VAR pCodFam AS CHAR NO-UNDO.
  DEF VAR pSUbFam AS CHAR NO-UNDO.

  pCodFam = FILL-IN_Lineas:SCREEN-VALUE.
  pSubFam = FILL-IN_SubLineas:SCREEN-VALUE.

  IF NUM-ENTRIES(pCodFam) = 1 THEN DO:
      RUN gn/d-filtro-sublineas.w (INPUT pCodFam,
                                   INPUT-OUTPUT pSubFam,
                                   INPUT "Seleccione Sub-Líneas").
      FILL-IN_SubLineas:SCREEN-VALUE = pSubFam.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    DEF VAR pMarcas AS CHAR NO-UNDO.

    pMarcas = EDITOR_Marca:SCREEN-VALUE.

    RUN gn/d-filtro-Marcas.w (INPUT-OUTPUT pMarcas,
                              INPUT "Seleccione una o más Líneas").
    /* Control */
    IF NUM-ENTRIES(pMarcas) > 5 THEN DO:
        MESSAGE 'Usted ha seleccionado más de 5 marcas' SKIP
            pMarcas VIEW-AS ALERT-BOX INFORMATION.
    END.

    EDITOR_Marca:SCREEN-VALUE = pMarcas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    DEF VAR pAlmacenes AS CHAR NO-UNDO.

    pAlmacenes = EDITOR_Almacenes:SCREEN-VALUE.

    RUN gn/d-filtro-almacenes.w (INPUT s-CodDiv,
                                 INPUT-OUTPUT pAlmacenes,
                                 INPUT "Seleccione una o más Almacenes").
    /* Control */
    IF NUM-ENTRIES(pAlmacenes) > 5 THEN DO:
        MESSAGE 'Usted ha seleccionado más de 5 almacenes' SKIP
            pAlmacenes VIEW-AS ALERT-BOX INFORMATION.
    END.

    EDITOR_Almacenes:SCREEN-VALUE = pAlmacenes.
    IF NUM-ENTRIES(pAlmacenes) > 1 THEN EDITOR_Sectores:SCREEN-VALUE = ''.
    IF NUM-ENTRIES(pAlmacenes) > 1 OR NUM-ENTRIES(EDITOR_Sectores:SCREEN-VALUE) > 1 THEN DO:
        DISABLE Zona-D Zona-H WITH FRAME {&FRAME-NAME}.
        Zona-D:SCREEN-VALUE = ''.
        Zona-H:SCREEN-VALUE = ''.
    END.
    ELSE DO:
        IF NUM-ENTRIES(pAlmacenes) = 1 AND NUM-ENTRIES(EDITOR_Sectores:SCREEN-VALUE) = 1 
            THEN ENABLE Zona-D Zona-H WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
    DEF VAR pCodAlm AS CHAR NO-UNDO.
    DEF VAR pSectores AS CHAR NO-UNDO.

    pCodAlm = EDITOR_Almacenes:SCREEN-VALUE.

    IF NUM-ENTRIES(pCodAlm) = 1 THEN DO:
        pSectores = EDITOR_Sectores:SCREEN-VALUE.
        RUN alm/d-tsectores.w (INPUT pCodAlm,
                               INPUT-OUTPUT pSectores).
        EDITOR_Sectores:SCREEN-VALUE = pSectores.
    END.
    IF NUM-ENTRIES(pCodAlm) > 1 OR NUM-ENTRIES(pSectores) > 1 THEN DO:
        DISABLE Zona-D Zona-H WITH FRAME {&FRAME-NAME}.
        Zona-D:SCREEN-VALUE = ''.
        Zona-H:SCREEN-VALUE = ''.
    END.
    ELSE DO:
        IF NUM-ENTRIES(pCodAlm) = 1 AND NUM-ENTRIES(pSectores) = 1 
            THEN ENABLE Zona-D Zona-H WITH FRAME {&FRAME-NAME}.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
  ASSIGN 
      C-Tipo EDITOR_Almacenes EDITOR_Marca EDITOR_Sectores 
      FILL-IN_Lineas FILL-IN_SubLineas R-Tipo.
  ASSIGN
      TOGGLE-1.
  ASSIGN
      Zona-D Zona-H.
  /* Control */
  IF TRUE <> (EDITOR_Almacenes > '') THEN DO:
      MESSAGE 'Debe seleccionar al menos 1 almacén' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO EDITOR_Almacenes.
      RETURN NO-APPLY.
  END.
  /*IF TOGGLE-1 = NO AND TRUE <> (FILL-IN_Lineas > '') THEN DO:*/
  IF TRUE <> (FILL-IN_Lineas > '') THEN DO:
      MESSAGE 'Debe seleccionar al menos 1 línea' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_Lineas.
      RETURN NO-APPLY.
  END.

  RUN ue-txt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-1 W-Win
ON VALUE-CHANGED OF TOGGLE-1 IN FRAME F-Main /* Solo SIN ubicacion ( vacio ó G-0) */
DO:
  ASSIGN {&self-name}.
  IF TOGGLE-1 = YES THEN DO WITH FRAME {&FRAME-NAME}:
      DISABLE BUTTON-5.
      EDITOR_Sectores:SCREEN-VALUE = ''.
  END.
  ELSE DO WITH FRAME {&FRAME-NAME}:
      ENABLE BUTTON-5.
  END.
/*   IF TOGGLE-1 = YES THEN DO WITH FRAME {&FRAME-NAME}:                            */
/*       DISABLE BUTTON-3 BUTTON-1 BUTTON-2 Zona-D Zona-H WITH FRAME {&FRAME-NAME}. */
/*       EDITOR_Marca:SCREEN-VALUE = ''.                                            */
/*       FILL-IN_Lineas:SCREEN-VALUE = ''.                                          */
/*       FILL-IN_SubLineas:SCREEN-VALUE = ''.                                       */
/*   END.                                                                           */
/*   ELSE DO:                                                                       */
/*       ENABLE BUTTON-3 BUTTON-1 BUTTON-2 WITH FRAME {&FRAME-NAME}.                */
/*   END.                                                                           */
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
  DISPLAY TOGGLE-1 EDITOR_Almacenes EDITOR_Sectores Zona-D Zona-H FILL-IN_Lineas 
          FILL-IN_SubLineas EDITOR_Marca R-Tipo C-Tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE TOGGLE-1 BUTTON-4 BUTTON-5 BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-6 BtnDone 
         C-Tipo 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-txt W-Win 
PROCEDURE ue-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pOptions AS CHAR NO-UNDO.
DEF VAR pArchivo AS CHAR NO-UNDO.

DEF VAR OKpressed AS LOG.
DEF VAR pNombre AS CHAR NO-UNDO.
DEF VAR pOrigen AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE pArchivo
    FILTERS "Archivo txt" "*.txt"
    ASK-OVERWRITE 
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".txt"
    SAVE-AS
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN NO-APPLY.

ASSIGN
    pOptions = "FileType:TXT" + CHR(1) + ~
          "Grid:ver" + CHR(1) + ~ 
          "ExcelAlert:false" + CHR(1) + ~
          "ExcelVisible:false" + CHR(1) + ~
          "Labels:yes".


DEFINE VAR lVolZona AS CHAR.
DEFINE VAR lDesZona AS CHAR.
DEFINE VAR F-STKALM AS DECI NO-UNDO.
DEFINE VAR F-PESALM AS DECI NO-UNDO.
DEFINE VAR F-CM3 AS DECI NO-UNDO.

EMPTY TEMP-TABLE tt-data.
/*SESSION:SET-WAIT-STATE('GENERAL').*/

DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR k AS INTE NO-UNDO.

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND (TRUE <> (FILL-IN_Lineas > '') OR LOOKUP(TRIM(Almmmatg.codfam), FILL-IN_Lineas) > 0 )
    AND (TRUE <> (FILL-IN_SubLineas > '') OR LOOKUP(TRIM(Almmmatg.subfam), FILL-IN_SubLineas) > 0 )
    AND (TRUE <> (EDITOR_Marca > '') OR LOOKUP(TRIM(Almmmatg.desmar), EDITOR_Marca) > 0 )
    AND (TRUE <> (R-Tipo > '') OR Almmmatg.TpoArt = R-tipo):
    DO k = 1 TO NUM-ENTRIES(EDITOR_Almacenes):
        x-CodAlm = ENTRY(k, EDITOR_Almacenes).
        FOR EACH Almmmate OF Almmmatg NO-LOCK WHERE Almmmate.codalm = x-CodAlm
            AND (C-tipo = "Todos" OR Almmmate.StkAct > 0),
            FIRST Almacen OF Almmmate NO-LOCK:
            /* Filtro */
            IF TOGGLE-1 = YES THEN DO:
                IF Almmmate.codubi > '' AND Almmmate.codubi <> 'G-0' THEN NEXT.
            END.
            IF TOGGLE-1 = NO THEN DO:
                IF Zona-D > '' AND Almmmate.CodUbi < Zona-D THEN NEXT.
                IF Zona-H > '' AND Almmmate.CodUbi > Zona-H THEN NEXT.
            END.
            /* Mensaje Pantalla */    
            DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Código de Articulo " FORMAT "X(11)" WITH FRAME F-Proceso.
            lDesZona = "".
            F-STKALM = Almmmate.StkAct.
            FIND almtubic WHERE almtubic.CodCia = Almmmate.codcia
                AND  almtubic.CodAlm = Almmmate.codalm
                AND  almtubic.CodUbi = Almmmate.CodUbi NO-LOCK NO-ERROR.
            IF AVAILABLE almtubic THEN lDesZona = almtubic.DesUbi.
            F-PESALM = F-STKALM * Almmmatg.Pesmat.
            F-CM3 = F-STKALM * (almmmatg.libre_d02 / 1000000).   /* El volumen esta expresado en CM3 */
            CREATE tt-data.
            ASSIGN  
                tt-data.codalm = Almmmate.codalm
                tt-data.descripcion = Almacen.Descripcion
                tt-data.sector  = (IF AVAILABLE Almtubic THEN almtubic.CodZona ELSE '')
                tt-data.codubi  = Almmmate.CodUbi
                tt-data.CodArt  = Almmmatg.codmat
                tt-data.Desmat  = Almmmatg.Desmat
                tt-data.Marca   = Almmmatg.Desmar
                tt-data.UndStk  = Almmmatg.UndStk
                tt-data.Stock   = F-STKALM
                tt-data.Peso    = F-PESALM
                tt-data.Vol     = F-CM3
                tt-data.estado = Almmmatg.TpoArt
                tt-data.codfam = Almmmatg.codfam
                tt-data.subfam = Almmmatg.subfam
                .      
        END.
    END.
END.
/*SESSION:SET-WAIT-STATE('').*/

/* Imprimir */
FIND FIRST tt-data NO-LOCK NO-ERROR.
IF NOT AVAILABLE tt-data THEN DO:
    MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
END.

DEF VAR cArchivo AS CHAR NO-UNDO.
/* El archivo se va a generar en un archivo temporal de trabajo antes 
de enviarlo a su directorio destino */
DISPLAY "" @ Fi-Mensaje LABEL "Generando TXT " FORMAT "X(20)" WITH FRAME F-Proceso.
cArchivo = LC(pArchivo).
/*SESSION:SET-WAIT-STATE('GENERAL').*/
RUN lib/tt-filev2 (TEMP-TABLE tt-data:HANDLE, cArchivo, pOptions).
/*SESSION:SET-WAIT-STATE('').*/
/* ******************************************************* */
HIDE FRAME F-PROCESO.
MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-txt-old W-Win 
PROCEDURE ue-txt-old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pOptions AS CHAR NO-UNDO.
DEF VAR pArchivo AS CHAR NO-UNDO.

DEF VAR OKpressed AS LOG.
DEF VAR pNombre AS CHAR NO-UNDO.
DEF VAR pOrigen AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE pArchivo
    FILTERS "Archivo txt" "*.txt"
    ASK-OVERWRITE 
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".txt"
    SAVE-AS
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN NO-APPLY.

ASSIGN
    pOptions = "FileType:TXT" + CHR(1) + ~
          "Grid:ver" + CHR(1) + ~ 
          "ExcelAlert:false" + CHR(1) + ~
          "ExcelVisible:false" + CHR(1) + ~
          "Labels:yes".


DEFINE VAR lVolZona AS CHAR.
DEFINE VAR lDesZona AS CHAR.
DEFINE VAR F-STKALM AS DECI NO-UNDO.
DEFINE VAR F-PESALM AS DECI NO-UNDO.
DEFINE VAR F-CM3 AS DECI NO-UNDO.

EMPTY TEMP-TABLE tt-data.
SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.TpoArt BEGINS R-tipo
    AND (TRUE <> (FILL-IN_Lineas > '') OR LOOKUP(TRIM(Almmmatg.codfam), FILL-IN_Lineas) > 0 )
    AND (TRUE <> (FILL-IN_SubLineas > '') OR LOOKUP(TRIM(Almmmatg.subfam), FILL-IN_SubLineas) > 0 )
    AND (TRUE <> (EDITOR_Marca > '') OR LOOKUP(TRIM(Almmmatg.desmar), EDITOR_Marca) > 0 ),
    EACH Almmmate NO-LOCK  WHERE Almmmate.Codcia = Almmmatg.Codcia 
    AND Almmmate.Codmat = Almmmatg.Codmat,
    FIRST Almacen OF Almmmate NO-LOCK WHERE Almacen.coddiv = s-coddiv
    AND (TRUE <> (EDITOR_Almacenes > '') OR LOOKUP(TRIM(Almacen.codalm), EDITOR_Almacenes) > 0 ):
    /* Filtro */
    IF TOGGLE-1 = YES THEN DO:
        IF Almmmate.codubi > '' AND Almmmate.codubi <> 'G-0' THEN NEXT.
    END.
    IF TOGGLE-1 = NO THEN DO:
        IF Zona-D > '' AND Almmmate.CodUbi < Zona-D THEN NEXT.
        IF Zona-H > '' AND Almmmate.CodUbi > Zona-H THEN NEXT.
    END.
    /* Mensaje Pantalla */    
    DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
        FORMAT "X(11)" WITH FRAME F-Proceso.
    lDesZona = "".
    F-STKALM = Almmmate.StkAct.
    IF (C-tipo = "Con-Stock" AND F-STKALM > 0) OR C-tipo = "Todos" THEN DO:
        FIND almtubic WHERE almtubic.CodCia = Almmmate.codcia
            AND  almtubic.CodAlm = Almmmate.codalm
            AND  almtubic.CodUbi = Almmmate.CodUbi NO-LOCK NO-ERROR.
        IF AVAILABLE almtubic THEN lDesZona = almtubic.DesUbi.
        F-PESALM = F-STKALM * Almmmatg.Pesmat.
        F-CM3 = F-STKALM * (almmmatg.libre_d02 / 1000000).   /* El volumen esta expresado en CM3 */
        CREATE tt-data.
        ASSIGN  
            tt-data.codalm = Almacen.codalm
            tt-data.descripcion = Almacen.Descripcion
            tt-data.sector  = (IF AVAILABLE Almtubic THEN almtubic.CodZona ELSE '')
            tt-data.codubi  = Almmmate.CodUbi
            tt-data.CodArt  = Almmmatg.codmat
            tt-data.Desmat  = Almmmatg.Desmat
            tt-data.Marca   = Almmmatg.Desmar
            tt-data.UndStk  = Almmmatg.UndStk
            tt-data.Stock   = F-STKALM
            tt-data.Peso    = F-PESALM
            tt-data.Vol     = F-CM3.      
    END.
END.
HIDE FRAME F-PROCESO.
SESSION:SET-WAIT-STATE('').

/* Imprimir */
FIND FIRST tt-data NO-LOCK NO-ERROR.
IF NOT AVAILABLE tt-data THEN DO:
    MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
END.

DEF VAR cArchivo AS CHAR NO-UNDO.
/* El archivo se va a generar en un archivo temporal de trabajo antes 
de enviarlo a su directorio destino */
cArchivo = LC(pArchivo).
SESSION:SET-WAIT-STATE('GENERAL').
RUN lib/tt-filev2 (TEMP-TABLE tt-data:HANDLE, cArchivo, pOptions).
SESSION:SET-WAIT-STATE('').
/* ******************************************************* */
MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

