&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
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
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-tabla AS CHAR INIT "CONFIG-FE-BIZLINKS".

DEFINE SHARED VAR s-user-id AS CHAR.

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
&Scoped-define INTERNAL-TABLES FacTabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 FacTabla.Codigo FacTabla.Campo-C[1] ~
FacTabla.Campo-C[2] FacTabla.Valor[1] FacTabla.Campo-C[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH FacTabla ~
      WHERE FacTabla.CodCia = s-codcia and ~
factabla.tabla = 'CONFIG-FE-BIZLINKS' NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacTabla ~
      WHERE FacTabla.CodCia = s-codcia and ~
factabla.tabla = 'CONFIG-FE-BIZLINKS' NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-4 BROWSE-2 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-division FILL-IN-ip ~
FILL-IN-puerto FILL-IN-url FILL-IN-tope 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Modificar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Nuevo" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Grabar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "Eliminar" 
     SIZE 11 BY .92.

DEFINE VARIABLE COMBO-BOX-division AS CHARACTER FORMAT "X(8)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ip AS CHARACTER FORMAT "X(20)":U 
     LABEL "IP del Servidor" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-puerto AS CHARACTER FORMAT "X(6)":U 
     LABEL "Puerto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-tope AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Tope Boleta de venta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-url AS CHARACTER FORMAT "X(150)":U 
     LABEL "URL documento electronico" 
     VIEW-AS FILL-IN 
     SIZE 75.43 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      FacTabla.Codigo COLUMN-LABEL "Division" FORMAT "x(6)":U WIDTH 8.43
      FacTabla.Campo-C[1] COLUMN-LABEL "IP servidor" FORMAT "x(20)":U
      FacTabla.Campo-C[2] COLUMN-LABEL "Puerto" FORMAT "x(6)":U
      FacTabla.Valor[1] COLUMN-LABEL "Monto BV" FORMAT "->,>>>,>>9.99":U
      FacTabla.Campo-C[3] COLUMN-LABEL "URL consulta documento electronico" FORMAT "x(150)":U
            WIDTH 64.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 115 BY 12.12
         FONT 3 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 15.04 COL 51.86 WIDGET-ID 28
     BROWSE-2 AT ROW 1.38 COL 3 WIDGET-ID 200
     COMBO-BOX-division AT ROW 13.88 COL 25.14 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-ip AT ROW 15.04 COL 25 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-puerto AT ROW 16.08 COL 25 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-url AT ROW 17.12 COL 25 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-tope AT ROW 18.15 COL 25 COLON-ALIGNED WIDGET-ID 16
     BUTTON-1 AT ROW 14.85 COL 72.57 WIDGET-ID 22
     BUTTON-2 AT ROW 14.81 COL 87.86 WIDGET-ID 24
     BUTTON-3 AT ROW 14.81 COL 103 WIDGET-ID 26
     "Monto minimo no obligatorio DNI" VIEW-AS TEXT
          SIZE 29.29 BY .62 AT ROW 18.31 COL 42.14 WIDGET-ID 18
          FGCOLOR 4 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 118.57 BY 19.04 WIDGET-ID 100.


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
         TITLE              = "Parametros Facturacion electronica - BIZLINKS"
         HEIGHT             = 19.04
         WIDTH              = 118.57
         MAX-HEIGHT         = 19.04
         MAX-WIDTH          = 118.57
         VIRTUAL-HEIGHT     = 19.04
         VIRTUAL-WIDTH      = 118.57
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
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ip IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-puerto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tope IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-url IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.FacTabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "FacTabla.CodCia = s-codcia and
factabla.tabla = 'CONFIG-FE-BIZLINKS'"
     _FldNameList[1]   > INTEGRAL.FacTabla.Codigo
"FacTabla.Codigo" "Division" "x(6)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacTabla.Campo-C[1]
"FacTabla.Campo-C[1]" "IP servidor" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacTabla.Campo-C[2]
"FacTabla.Campo-C[2]" "Puerto" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacTabla.Valor[1]
"FacTabla.Valor[1]" "Monto BV" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacTabla.Campo-C[3]
"FacTabla.Campo-C[3]" "URL consulta documento electronico" "x(150)" "character" ? ? ? ? ? ? no ? no no "64.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Parametros Facturacion electronica - BIZLINKS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Parametros Facturacion electronica - BIZLINKS */
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
ON ENTRY OF BROWSE-2 IN FRAME F-Main
DO:
    DISABLE button-1.
    ENABLE button-2.
    DISABLE button-3.
    DISABLE button-4.

    DISABLE COMBO-BOX-division.
    DISABLE FILL-in-ip.
    DISABLE FILL-in-puerto.
    DISABLE FILL-in-url.
    DISABLE FILL-in-tope.

  IF AVAILABLE factabla THEN DO:
      DO WITH FRAME {&FRAME-NAME}:
          combo-box-division:SCREEN-VALUE = factabla.codigo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
          FILL-in-ip:SCREEN-VALUE = factabla.campo-c[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
          FILL-in-puerto:SCREEN-VALUE = factabla.campo-c[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
          FILL-in-url:SCREEN-VALUE = factabla.campo-c[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
          FILL-in-tope:SCREEN-VALUE = factabla.valor[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

          ENABLE button-1.
          ENABLE button-2.
          DISABLE button-3.
          ENABLE button-4.

          DISABLE COMBO-BOX-division.
          DISABLE FILL-in-ip.
          DISABLE FILL-in-puerto.
          DISABLE FILL-in-url.
          DISABLE FILL-in-tope.
      END.      
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:
    DISABLE button-1.
    ENABLE button-2.
    DISABLE button-3.
    DISABLE button-4.

    DISABLE COMBO-BOX-division.
    DISABLE FILL-in-ip.
    DISABLE FILL-in-puerto.
    DISABLE FILL-in-url.
    DISABLE FILL-in-tope.

    IF AVAILABLE factabla THEN DO:
        DO WITH FRAME {&FRAME-NAME}:
            combo-box-division:SCREEN-VALUE = factabla.codigo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
            FILL-in-ip:SCREEN-VALUE = factabla.campo-c[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
            FILL-in-puerto:SCREEN-VALUE = factabla.campo-c[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
            FILL-in-url:SCREEN-VALUE = factabla.campo-c[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
            FILL-in-tope:SCREEN-VALUE = factabla.valor[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

            ENABLE button-1.
            ENABLE button-2.
            DISABLE button-3.
            ENABLE button-4.

            DISABLE COMBO-BOX-division.
            DISABLE FILL-in-ip.
            DISABLE FILL-in-puerto.
            DISABLE FILL-in-url.
            DISABLE FILL-in-tope.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Modificar */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        DISABLE button-1.
        DISABLE button-2.
        ENABLE button-3.
        DISABLE button-4.
        
        ENABLE FILL-in-ip.
        ENABLE FILL-in-puerto.
        DISABLE FILL-in-url.
        DISABLE FILL-in-tope.
        IF combo-box-division:SCREEN-VALUE = "TODOS" THEN DO:
            ENABLE FILL-in-url.
            ENABLE FILL-in-tope.
        END.
        
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Nuevo */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        DISABLE button-1.
        DISABLE button-2.
        ENABLE button-3.
        DISABLE button-4.

        ENABLE COMBO-BOX-division.
        ENABLE FILL-in-ip.
        ENABLE FILL-in-puerto.
        ENABLE FILL-in-url.
        ENABLE FILL-in-tope.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Grabar */
DO:

    ASSIGN combo-box-division FILL-IN-ip fill-in-puerto fill-in-url FILL-in-tope.
    IF TRUE <> (fill-in-ip > "") THEN DO:
        MESSAGE "Ingrese la IP del servidor" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF TRUE <> (fill-in-puerto > "") THEN DO:
        MESSAGE "Ingrese la IP del servidor" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF combo-box-division = 'TODOS' THEN DO:
        IF TRUE <> (fill-in-url > "") THEN DO:
            MESSAGE "Ingrese el URL del documento electronico" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF fill-in-tope <= 0 THEN DO:
            MESSAGE "Ingrese el Tope Boleta de venta" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.

    END.

    DO WITH FRAME {&FRAME-NAME}:

        DEFINE BUFFER b-factabla FOR factabla.        

        FIND FIRST b-factabla WHERE b-factabla.codcia = s-codcia AND
                                        b-factabla.tabla = x-tabla AND
                                        b-factabla.codigo = combo-box-division NO-LOCK NO-ERROR.
        IF COMBO-BOX-division:SENSITIVE = YES THEN DO:
            /* NUEVO REGISTRO */
            IF AVAILABLE b-factabla THEN DO:
                MESSAGE "Registro YA EXISTE" VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
            END.            
            CREATE b-factabla.
                ASSIGN b-factabla.codcia = s-codcia 
                        b-factabla.tabla = x-tabla
                        b-factabla.codigo = combo-box-division
                        b-factabla.campo-c[1] = fill-in-ip
                        b-factabla.campo-c[2] = fill-in-puerto
                        b-factabla.campo-c[3] = fill-in-url
                        b-factabla.valor[1] = fill-in-tope
                        b-factabla.campo-c[15] = s-user-id
                        b-factabla.campo-c[16] = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
                .
        END.
        ELSE DO:
            /* MODIFICACION */
            IF NOT AVAILABLE b-factabla THEN DO:
                MESSAGE "Registro NO EXISTE" VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
            END.
            FIND CURRENT b-factabla EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN b-factabla.campo-c[1] = fill-in-ip
                b-factabla.campo-c[2] = fill-in-puerto
                b-factabla.campo-c[3] = fill-in-url
                b-factabla.valor[1] = fill-in-tope
                b-factabla.campo-c[17] = s-user-id
                b-factabla.campo-c[18] = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
            .
        END.
        RELEASE b-factabla.
        
        DISABLE button-1.
        ENABLE button-2.
        DISABLE button-3.
        DISABLE button-4.

        DISABLE COMBO-BOX-division.
        DISABLE FILL-in-ip.
        DISABLE FILL-in-puerto.
        DISABLE FILL-in-url.
        DISABLE FILL-in-tope.
    END.

    {&open-query-browse-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Eliminar */
DO:
	MESSAGE "Seguro de Eliminar la division(" + COMBO-BOX-division:SCREEN-VALUE IN FRAME {&FRAME-NAME} + ")?" VIEW-AS ALERT-BOX QUESTION
	        BUTTONS YES-NO UPDATE rpta AS LOG.
	IF rpta = NO THEN RETURN NO-APPLY.
  
    ASSIGN combo-box-division FILL-IN-ip fill-in-puerto fill-in-url FILL-in-tope.

    DEFINE BUFFER b-factabla FOR factabla.        

    FIND FIRST b-factabla WHERE b-factabla.codcia = s-codcia AND
                                    b-factabla.tabla = x-tabla AND
                                    b-factabla.codigo = combo-box-division EXCLUSIVE-LOCK NO-ERROR.

    IF LOCKED b-factabla THEN DO:
        MESSAGE "Imposible ELIMINAR" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    IF AVAILABLE b-factabla THEN DO:
        DELETE b-factabla.
    END.
    RELEASE b-factabla.

    {&open-query-browse-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-division W-Win
ON VALUE-CHANGED OF COMBO-BOX-division IN FRAME F-Main /* Division */
DO:
    DO WITH FRAME {&FRAME-NAME} :
        IF CAPS(combo-box-division:SCREEN-VALUE) = "TODOS" THEN DO:
            ENABLE FILL-in-url.
            ENABLE FILL-in-tope.
        END.
        ELSE DO:
            DISABLE FILL-in-url.
            DISABLE FILL-in-tope.
        END.
    END.
  
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
  DISPLAY COMBO-BOX-division FILL-IN-ip FILL-IN-puerto FILL-IN-url FILL-IN-tope 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-4 BROWSE-2 BUTTON-2 
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
/*
  FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                                factabla.tabla = ''
*/

  DO WITH FRAME {&FRAME-NAME}.
      COMBO-BOX-division:DELIMITER = "|".
  END.
  COMBO-BOX-division:DELETE(COMBO-BOX-division:NUM-ITEMS).
  IF NOT (TRUE <> (COMBO-BOX-division:LIST-ITEM-PAIRS > "")) THEN COMBO-BOX-division:DELETE(COMBO-BOX-division:LIST-ITEM-PAIRS).

  COMBO-BOX-division:ADD-LAST('Todos',"TODOS").
  COMBO-BOX-division:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'TODOS'.

  FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
      COMBO-BOX-division:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv, gn-divi.coddiv).
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacTabla"}

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

