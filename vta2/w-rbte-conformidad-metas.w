&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-rbte_cliente NO-UNDO LIKE rbte_cliente.



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
DEFINE SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEFINE VAR x-proceso AS CHAR.
DEFINE VAR x-existen-cambios AS LOG.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'REBATE' NO-LOCK NO-ERROR.

IF NOT AVAILABLE factabla THEN DO:
    MESSAGE "Aun no se han creado el/los proceso(s) de Rebate"
        VIEW-AS ALERT-BOX INFORMATION.
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
&Scoped-define BROWSE-NAME BROWSE-7

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-rbte_cliente gn-clie

/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 tt-rbte_cliente.campo-c[3] ~
tt-rbte_cliente.codcli gn-clie.NomCli tt-rbte_cliente.codagrupa ~
tt-rbte_cliente.ruc tt-rbte_cliente.metas[1] tt-rbte_cliente.metas[2] ~
tt-rbte_cliente.metas[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 tt-rbte_cliente.campo-c[3] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-7 tt-rbte_cliente
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-7 tt-rbte_cliente
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH tt-rbte_cliente NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.codcia = 0 and ~
integral.gn-clie.codcli = tt-rbte_cliente.codcli OUTER-JOIN NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH tt-rbte_cliente NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.codcia = 0 and ~
integral.gn-clie.codcli = tt-rbte_cliente.codcli OUTER-JOIN NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 tt-rbte_cliente gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 tt-rbte_cliente
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-7 gn-clie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-procesos BUTTON-cargar BROWSE-7 ~
BUTTON-cancelar BUTTON-grabar BUTTON-Desaprobar BUTTON-aprobar 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-procesos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-aprobar 
     LABEL "Aprobar a todos" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-cancelar 
     LABEL "SALIR sin grabar" 
     SIZE 16.72 BY 1.12.

DEFINE BUTTON BUTTON-cargar 
     LABEL "Aceptar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Desaprobar 
     LABEL "Desaprobar a todos" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-grabar 
     LABEL "Grabar conformidad" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-procesos AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procesos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 45.57 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-7 FOR 
      tt-rbte_cliente, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      tt-rbte_cliente.campo-c[3] COLUMN-LABEL "Aprobado?" FORMAT "x(3)":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "SI","NO" 
                      DROP-DOWN-LIST 
      tt-rbte_cliente.codcli COLUMN-LABEL "Cliente" FORMAT "x(11)":U
            WIDTH 11.43
      gn-clie.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "x(80)":U
            WIDTH 37.43
      tt-rbte_cliente.codagrupa COLUMN-LABEL "Agrupador" FORMAT "x(25)":U
            WIDTH 19.43
      tt-rbte_cliente.ruc COLUMN-LABEL "R.U.C." FORMAT "x(11)":U
            WIDTH 13.43
      tt-rbte_cliente.metas[1] COLUMN-LABEL "Meta #1" FORMAT "->,>>>,>>9.99":U
      tt-rbte_cliente.metas[2] COLUMN-LABEL "Meta #2" FORMAT "->,>>>,>>9.99":U
      tt-rbte_cliente.metas[3] COLUMN-LABEL "Meta #3" FORMAT "->,>>>,>>9.99":U
            WIDTH 6.86
  ENABLE
      tt-rbte_cliente.campo-c[3]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 125 BY 17.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-procesos AT ROW 1.23 COL 10 COLON-ALIGNED WIDGET-ID 2
     BUTTON-cargar AT ROW 1.12 COL 71.14 WIDGET-ID 20
     BROWSE-7 AT ROW 2.58 COL 3 WIDGET-ID 200
     BUTTON-cancelar AT ROW 20.58 COL 94 WIDGET-ID 24
     BUTTON-grabar AT ROW 20.58 COL 111.72 WIDGET-ID 10
     BUTTON-Desaprobar AT ROW 20.5 COL 35.72 WIDGET-ID 28
     BUTTON-aprobar AT ROW 20.5 COL 18.57 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 129.72 BY 20.96
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-rbte_cliente T "?" NO-UNDO INTEGRAL rbte_cliente
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Conformidad Metas del Cliente"
         HEIGHT             = 20.96
         WIDTH              = 129.72
         MAX-HEIGHT         = 27.12
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.12
         VIRTUAL-WIDTH      = 195.14
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
/* BROWSE-TAB BROWSE-7 BUTTON-cargar F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.tt-rbte_cliente,INTEGRAL.gn-clie WHERE Temp-Tables.tt-rbte_cliente ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", OUTER"
     _JoinCode[2]      = "integral.gn-clie.codcia = 0 and
integral.gn-clie.codcli = tt-rbte_cliente.codcli"
     _FldNameList[1]   > Temp-Tables.tt-rbte_cliente.campo-c[3]
"tt-rbte_cliente.campo-c[3]" "Aprobado?" "x(3)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," "SI,NO" ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-rbte_cliente.codcli
"tt-rbte_cliente.codcli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" "Nombre del Cliente" "x(80)" "character" ? ? ? ? ? ? no ? no no "37.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-rbte_cliente.codagrupa
"tt-rbte_cliente.codagrupa" "Agrupador" ? "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-rbte_cliente.ruc
"tt-rbte_cliente.ruc" "R.U.C." ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-rbte_cliente.metas[1]
"tt-rbte_cliente.metas[1]" "Meta #1" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-rbte_cliente.metas[2]
"tt-rbte_cliente.metas[2]" "Meta #2" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-rbte_cliente.metas[3]
"tt-rbte_cliente.metas[3]" "Meta #3" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Conformidad Metas del Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Conformidad Metas del Cliente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
&Scoped-define SELF-NAME BROWSE-7
&Scoped-define SELF-NAME tt-rbte_cliente.campo-c[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rbte_cliente.campo-c[3] BROWSE-7 _BROWSE-COLUMN W-Win
ON LEAVE OF tt-rbte_cliente.campo-c[3] IN BROWSE BROWSE-7 /* Aprobado? */
DO:
  DEFINE VAR x-dato AS CHAR.

  x-dato = SELF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

  


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-aprobar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-aprobar W-Win
ON CHOOSE OF BUTTON-aprobar IN FRAME F-Main /* Aprobar a todos */
DO:
  RUN marcar-desmarcar(INPUT YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-cancelar W-Win
ON CHOOSE OF BUTTON-cancelar IN FRAME F-Main /* SALIR sin grabar */
DO:
    /*
    DEFINE VAR x-existen-cambios AS LOG.

    RUN get-existen-cambios IN h_b-rbte-config-linea-movimiento(OUTPUT x-existen-cambios).
    */
    IF x-existen-cambios = YES THEN DO:
        MESSAGE 'Existen cambios realizados!!' SKIP
                'Esta seguro de PERDER los cambios?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    END.


    RUN browse-off.
    APPLY 'ENTRY':U TO combo-box-procesos IN FRAME {&FRAME-NAME}.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-cargar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-cargar W-Win
ON CHOOSE OF BUTTON-cargar IN FRAME F-Main /* Aceptar */
DO:    
    RUN cargar-data.  
    RUN browse-on.

    {&open-query-browse-7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Desaprobar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Desaprobar W-Win
ON CHOOSE OF BUTTON-Desaprobar IN FRAME F-Main /* Desaprobar a todos */
DO:
  RUN marcar-desmarcar(INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-grabar W-Win
ON CHOOSE OF BUTTON-grabar IN FRAME F-Main /* Grabar conformidad */
DO:
    /*RUN grabar IN h_b-rbte-config-linea-movimiento.*/

    RUN grabar-data.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-procesos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-procesos W-Win
ON ENTRY OF COMBO-BOX-procesos IN FRAME F-Main /* Procesos */
DO:
  RUN browse-off.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON 'value-changed':U OF tt-rbte_cliente.campo-c[3] IN BROWSE BROWSE-7
DO:
    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    DEFINE VAR cColumnName AS CHAR.

    DEFINE VAR x-dato AS CHAR.
    DEFINE VAR x-dato-anterior AS CHAR.

    ASSIGN hColumn = SELF:HANDLE.
    cColumnName = CAPS(hColumn:NAME).   

    x-dato = SELF:SCREEN-VALUE.
    x-dato-anterior = tt-rbte_cliente.campo-c[11].

    IF x-dato <> x-dato-anterior THEN x-existen-cambios = YES.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browse-off W-Win 
PROCEDURE browse-off :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-handle AS HANDLE.

    DO WITH FRAME {&FRAME-NAME} :
        
        BROWSE-7:VISIBLE = NO.

        button-cancelar:VISIBLE = NO.
        button-grabar:VISIBLE = NO.
        button-aprobar:VISIBLE = NO.
        button-desaprobar:VISIBLE = NO.

        ENABLE combo-box-procesos.
        ENABLE button-cargar.

                
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browse-on W-Win 
PROCEDURE browse-on :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-handle AS HANDLE.

    DO WITH FRAME {&FRAME-NAME} :
        
        BROWSE-7:VISIBLE = YES.

        button-cancelar:VISIBLE = YES.
        button-grabar:VISIBLE = YES.
        button-aprobar:VISIBLE = YES.
        button-desaprobar:VISIBLE = YES.

        DISABLE combo-box-procesos.
        DISABLE button-cargar.

                
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-procesos W-Win 
PROCEDURE carga-procesos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-nombre AS CHAR INIT "".

  DO WITH FRAME {&FRAME-NAME} :

      IF NOT (TRUE <> (COMBO-BOX-procesos:LIST-ITEM-PAIRS > "")) THEN COMBO-BOX-procesos:DELETE(COMBO-BOX-procesos:LIST-ITEM-PAIRS).

      FOR EACH factabla WHERE factabla.codcia = s-codcia AND
                                factabla.tabla = "REBATE" NO-LOCK:
          COMBO-BOX-procesos:ADD-LAST(factabla.nombre, factabla.codigo).
          IF TRUE <> (COMBO-BOX-procesos:SCREEN-VALUE > "") THEN DO:

            x-nombre = factabla.codigo.
            ASSIGN COMBO-BOX-procesos:SCREEN-VALUE = x-nombre.
          END.

      END.

      APPLY 'VALUE-CHANGED':U TO COMBO-BOX-procesos.
      
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-data W-Win 
PROCEDURE cargar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-sec AS INT.    
    
SESSION:SET-WAIT-STATE("GENERAL").
    
EMPTY TEMP-TABLE tt-rbte_cliente.
x-proceso = combo-box-procesos:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

FOR EACH rbte_cliente WHERE rbte_cliente.codcia = s-codcia AND
                                rbte_cliente.codproceso = x-proceso NO-LOCK:

    CREATE tt-rbte_cliente.
        BUFFER-COPY rbte_cliente TO tt-rbte_cliente.

        x-sec = x-sec + 1.

    ASSIGN tt-rbte_cliente.campo-c[11] = tt-rbte_cliente.campo-c[3].    

    IF TRUE <> (tt-rbte_cliente.campo-c[3] > "") THEN DO:
        ASSIGN tt-rbte_cliente.campo-c[3] = "NO".        
        x-existen-cambios = YES.
    END.

END.

SESSION:SET-WAIT-STATE("").

/*MESSAGE x-sec.*/

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
  DISPLAY COMBO-BOX-procesos 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-procesos BUTTON-cargar BROWSE-7 BUTTON-cancelar 
         BUTTON-grabar BUTTON-Desaprobar BUTTON-aprobar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-data W-Win 
PROCEDURE grabar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").

MESSAGE 'ESTA SEGURO DE GRABAR?' SKIP
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta1 AS LOG.

IF rpta1 = YES THEN DO:
    MESSAGE 'DESEA DAR POR CERRADO, LAS METAS PARA EL REBATE?' SKIP
            'SI : Ya no permitira actualizar las metas por parte de comercial!!!'
            VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.

    DEFINE VAR x-valor AS CHAR.

    FOR EACH tt-rbte_cliente WHERE tt-rbte_cliente.campo-c[11] <> tt-rbte_cliente.campo-c[3].

        FIND FIRST rbte_cliente WHERE rbte_cliente.codcia = s-codcia AND
                                        rbte_cliente.codproceso = x-proceso AND 
                                        rbte_cliente.codcli = tt-rbte_cliente.codcli 
                                        EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE rbte_cliente THEN DO:

            x-valor = rbte_cliente.campo-c[3].

            ASSIGN rbte_cliente.campo-c[3] = tt-rbte_cliente.campo-c[3].        

            CREATE LogTabla.
            ASSIGN
              logtabla.codcia = s-codcia
              logtabla.Dia = TODAY
              logtabla.Evento = 'WRITE'
              logtabla.Hora = STRING(TIME, 'HH:MM:SS')
              logtabla.Tabla = 'rbte_cliente'
              logtabla.Usuario = USERID("DICTDB")
              logtabla.ValorLlave = STRING(rbte_cliente.codcia, '999') + '|' +
                                      STRING(rbte_cliente.codcli, 'x(11)') + '|' +
                                      "ANTERIOR(" + x-valor + ")|NUEVO(" + tt-rbte_cliente.campo-c[3] + ")".
           RELEASE LogTabla. 
           RELEASE rbte_cliente.

        END.

    END.

    x-existen-cambios = NO.

    FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                                factabla.tabla = "RBTE-AUTORIZA" AND
                                factabla.codigo = "CONTROLER" EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE factabla THEN DO:
        CREATE factabla.
        ASSIGN factabla.codcia = s-codcia
                factabla.tabla = "RBTE-AUTORIZA"
                factabla.codigo = "CONTROLER".
    END.
    ASSIGN factabla.campo-l[1] = rpta.

    RELEASE factabla.

    SESSION:SET-WAIT-STATE("").

    MESSAGE "Los cambios se grabaron CORRECTAMENTE"
            VIEW-AS ALERT-BOX INFORMATION TITLE "".
END.

/*MESSAGE x-sec.*/


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
  COMBO-BOX-procesos:DELETE(COMBO-BOX-procesos:NUM-ITEMS) IN FRAME {&FRAME-NAME}.

  RUN carga-procesos.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE marcar-desmarcar W-Win 
PROCEDURE marcar-desmarcar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pSwitch AS LOG.

SESSION:SET-WAIT-STATE("GENERAL").

DO WITH FRAME {&FRAME-NAME}:
    GET FIRST browse-7.
    DO  WHILE AVAILABLE tt-rbte_cliente:
        IF pSwitch = YES THEN DO:
            ASSIGN {&FIRST-TABLE-IN-QUERY-browse-7}.campo-c[3]:SCREEN-VALUE IN BROWSE browse-7 = "SI".
            ASSIGN tt-rbte_cliente.campo-c[3] = "SI".
        END.
        ELSE DO:            
            ASSIGN {&FIRST-TABLE-IN-QUERY-browse-7}.campo-c[3]:SCREEN-VALUE IN BROWSE browse-7 = "NO".
            ASSIGN tt-rbte_cliente.campo-c[3] = "NO".
        END.
        
        GET NEXT browse-7.

        x-existen-cambios = YES.

    END.
END.

{&open-query-browse-7}

SESSION:SET-WAIT-STATE("").


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
  {src/adm/template/snd-list.i "tt-rbte_cliente"}
  {src/adm/template/snd-list.i "gn-clie"}

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

