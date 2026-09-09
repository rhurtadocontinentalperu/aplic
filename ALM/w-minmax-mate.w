&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATE NO-UNDO LIKE Almmmate.



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
DEF SHARED VAR pv-codcia AS INT.

DEF TEMP-TABLE Detalle
    FIELD FchDoc AS DATE
    FIELD CanDes AS DEC
    INDEX Llave01 AS PRIMARY FchDoc.

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
&Scoped-define INTERNAL-TABLES T-MATE Almmmatg

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 T-MATE.CodAlm T-MATE.codmat ~
Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndBas T-MATE.StkMin T-MATE.StkMax 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 T-MATE.StkMin T-MATE.StkMax 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-3 T-MATE
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-3 T-MATE
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-MATE NO-LOCK, ~
      EACH Almmmatg OF T-MATE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-MATE NO-LOCK, ~
      EACH Almmmatg OF T-MATE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-MATE Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-MATE
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodAlm BUTTON-1 BUTTON-2 BUTTON-3 ~
BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/proces.bmp":U
     LABEL "" 
     SIZE 12 BY 1.35 TOOLTIP "Calcular mínimos y máximos".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/tbldef.ico":U
     LABEL "Button 2" 
     SIZE 10 BY 1.35 TOOLTIP "Asignar mínimos y máximos".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 3" 
     SIZE 10 BY 1.35 TOOLTIP "Salir".

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione almacén" 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Seleccione almacén" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 79 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      T-MATE, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      T-MATE.CodAlm FORMAT "x(3)":U
      T-MATE.codmat FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 52.57
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 21
      Almmmatg.UndBas FORMAT "X(4)":U
      T-MATE.StkMin FORMAT "Z,ZZZ,ZZ9.99":U
      T-MATE.StkMax FORMAT "Z,ZZZ,ZZZ,ZZ9.99":U WIDTH 10
  ENABLE
      T-MATE.StkMin
      T-MATE.StkMax
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 115 BY 13.73
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodAlm AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.27 COL 72 WIDGET-ID 4
     BUTTON-2 AT ROW 1.27 COL 84 WIDGET-ID 6
     BUTTON-3 AT ROW 1.27 COL 94 WIDGET-ID 8
     BROWSE-3 AT ROW 2.88 COL 2 WIDGET-ID 200
     FILL-IN-Mensaje AT ROW 16.88 COL 2 NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 120.29 BY 17
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATE T "?" NO-UNDO INTEGRAL Almmmate
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "MINIMOS Y MAXIMOS POR ALMACEN"
         HEIGHT             = 17
         WIDTH              = 120.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 120.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 120.29
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
/* BROWSE-TAB BROWSE-3 BUTTON-3 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-MATE,INTEGRAL.Almmmatg OF Temp-Tables.T-MATE"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.T-MATE.CodAlm
     _FldNameList[2]   = Temp-Tables.T-MATE.codmat
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "52.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "21" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.Almmmatg.UndBas
     _FldNameList[6]   > Temp-Tables.T-MATE.StkMin
"T-MATE.StkMin" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATE.StkMax
"T-MATE.StkMax" ? ? "decimal" ? ? ? ? ? ? yes ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* MINIMOS Y MAXIMOS POR ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* MINIMOS Y MAXIMOS POR ALMACEN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main
DO:
    RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  MESSAGE 'Transferimos los máximos y mínimos?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Transfiere-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN local-exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME F-Main /* Almacén */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR pRowid AS ROWID.
DEF VAR pDiasUtiles AS INT.
DEF VAR pVentaDiaria AS DEC.
DEF VAR pDiasMaximo AS INT.
DEF VAR pDiasMinimo AS INT.
DEF VAR pReposicion AS DEC.
DEF VAR pComprometido AS DEC.
DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StockMaximo AS DEC NO-UNDO.

IF COMBO-BOX-CodAlm BEGINS 'Selecc' THEN RETURN.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

x-CodAlm = ENTRY(1, COMBO-BOX-CodAlm, " - "). 

FOR EACH T-MATE:
    DELETE T-MATE.
END.

FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codalm = x-CodAlm,
    FIRST Almmmatg OF Almmmate NO-LOCK:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO: " + Almmmatg.codmat + " " + Almmmatg.desmat.
    /* Valores por defecto */
    ASSIGN
        pDiasMaximo = AlmCfgGn.DiasMaximo
        pDiasMinimo = AlmCfgGn.DiasMinimo
        pDiasUtiles = AlmCfgGn.DiasUtiles.
    /* Buscamos parametros del proveedor */
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov AND (gn-prov.stkmin > 0 AND gn-prov.stkmax > 0) THEN DO:
        ASSIGN
            pDiasMaximo = gn-prov.stkmax
            pDiasMinimo = gn-prov.stkmin.
    END.
    ASSIGN
        x-StockMinimo = 0
        x-StockMaximo = 0.
    IF Almmmatg.TpoArt <> "D" THEN DO:
        /* Venta Diaria */
        pRowid = ROWID(Almmmate).
        RUN venta-diaria (pRowid, pDiasUtiles, Almmmate.CodAlm, OUTPUT pVentaDiaria).
        /* Stock Minimo y Maximo */
        x-StockMinimo = ROUND (pDiasMinimo * pVentaDiaria, 0).
        x-StockMaximo = ROUND (pDiasMaximo * pVentaDiaria, 0).
        /* EMPAQUE */
        DEF VAR f-Canped AS DEC NO-UNDO.
        IF Almmmatg.CanEmp > 0 THEN DO:
            IF x-StockMinimo > 0 THEN DO:
                f-CanPed = x-StockMinimo.
                f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.CanEmp),0) * Almmmatg.CanEmp).
                x-StockMinimo = f-CanPed.
            END.
            IF x-StockMaximo > 0 THEN DO:
                f-CanPed = x-StockMaximo.
                f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.CanEmp),0) * Almmmatg.CanEmp).
                x-StockMaximo = f-CanPed.
            END.
        END.
    END.
    IF x-StockMinimo > 0 OR x-StockMaximo > 0 THEN DO:
        CREATE T-MATE.
        BUFFER-COPY Almmmate TO T-MATE
            ASSIGN
            T-MATE.StkMin = x-StockMinimo
            T-MATE.StkMax = x-StockMaximo.
    END.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}

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
  DISPLAY COMBO-BOX-CodAlm FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodAlm BUTTON-1 BUTTON-2 BUTTON-3 BROWSE-3 
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
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Almacen NO-LOCK WHERE codcia = s-codcia:
          /* Almacenes que NO son propios */
          IF Almacen.FlgRep = NO THEN NEXT.
          /* RHC 09.09.04 EL ALMACEN DE CONSIGN. NO TIENE MOVIMIENTO CONTABLE  */
          IF Almacen.AlmCsg = YES THEN NEXT.

          COMBO-BOX-CodAlm:ADD-LAST(Almacen.codalm + ' - ' + Almacen.Descripcion).
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-MATE"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transfiere-Temporal W-Win 
PROCEDURE Transfiere-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

                          
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    FIND FIRST T-MATE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MATE THEN RETURN.
    /* Borramos lo anterior */
    FOR EACH Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = T-MATE.codalm:
        ASSIGN
            Almmmate.stkmin = 0
            Almmmate.stkmax = 0.
    END.
    /* Actualizamos información */
    FOR EACH T-MATE:
        FIND Almmmate OF T-MATE EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN NEXT.
        ASSIGN
            Almmmate.StkMin = T-MATE.StkMin
            Almmmate.StkMax = T-MATE.StkMax.
        DELETE T-MATE.
    END.
    RELEASE Almmmate.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE venta-diaria W-Win 
PROCEDURE venta-diaria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pDiasUtiles AS INT.
DEF INPUT PARAMETER pAlmacenes AS CHAR.
DEF OUTPUT PARAMETER pVentaDiaria AS DEC.

FIND Almmmate WHERE ROWID(Almmmate) = pRowid
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN RETURN.

FIND Almmmatg OF Almmmate NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pAlmacenes NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN RETURN.

/* determinamos las fechas de venta */
DEF VAR x-FchIni-Ant AS DATE NO-UNDO.
DEF VAR x-FchFin-Ant AS DATE NO-UNDO.
DEF VAR x-FchIni-Hoy AS DATE NO-UNDO.
DEF VAR x-FchFin-Hoy AS DATE NO-UNDO.
DEF VAR x-Venta-Ant AS DEC NO-UNDO.
DEF VAR x-Venta-Hoy AS DEC NO-UNDO.
DEF VAR x-Venta-Mes AS DEC NO-UNDO.

DEF VAR x-Mes AS INT NO-UNDO.
DEF VAR x-Ano AS INT NO-UNDO.
DEF VAR x-Meses AS INT INIT 3 NO-UNDO.      /* Meses de estudio estadístico */

/* 21.08.09 ahora hay que retroceder 36 dias */
x-FchFin-Ant = TODAY - 365.
x-FchIni-Ant = x-FchFin-Ant - x-Meses * 30.

/*RUN Venta-Diaria-Promedio-Estadistica (x-FchIni-Ant, x-FchFin-Ant, OUTPUT x-Venta-Ant).*/
RUN vtagn/ventas-promedio-01 (x-FchIni-Ant, x-FchFin-Ant, pAlmacenes, Almmmatg.codmat, OUTPUT x-Venta-Ant).

/* 21.08.09 ahora hay que retroceder 36 dias */
x-FchFin-Hoy = TODAY.
x-FchIni-Hoy = x-FchFin-Hoy - x-Meses * 30.

/*RUN Venta-Diaria-Promedio-Estadistica (x-FchIni-Hoy, x-FchFin-Hoy, OUTPUT x-Venta-Hoy).*/
RUN vtagn/ventas-promedio-01 (x-FchIni-Hoy, x-FchFin-Hoy, pAlmacenes, Almmmatg.codmat, OUTPUT x-Venta-Hoy).

/* 21.08.09 ahora hay que retroceder 365 dias */
x-FchFin-Ant = TODAY - 365.
x-FchIni-Ant = x-FchFin-Ant - 30.

/*RUN Venta-Diaria-Promedio-Estadistica (x-FchIni-Ant, x-FchFin-Ant, OUTPUT x-Venta-Mes).*/
RUN vtagn/ventas-promedio-01 (x-FchIni-Ant, x-FchFin-Ant, pAlmacenes, Almmmatg.codmat, OUTPUT x-Venta-Mes).

IF x-Venta-Ant <= 0 THEN DO:
    pVentaDiaria = x-Venta-Hoy.
    RETURN.
END.
IF ( x-Venta-Hoy / x-Venta-Ant ) > 3 OR ( x-Venta-Hoy / x-Venta-Ant ) < (1 / 3) THEN DO: 
    pVentaDiaria = x-Venta-Hoy.
    RETURN.
END.
IF ( x-Venta-Hoy / x-Venta-Mes ) > 3 OR ( x-Venta-Hoy / x-Venta-Mes ) < (1 / 3) THEN DO: 
    pVentaDiaria = x-Venta-Hoy.
    RETURN.
END.
pVentaDiaria = x-Venta-Hoy / x-Venta-Ant * x-Venta-Mes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

