&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tgn-clie NO-UNDO LIKE gn-clie.



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
DEF SHARED VAR cl-codcia AS INTE.

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
&Scoped-define INTERNAL-TABLES Gn-ClieD gn-clie GN-DIVI gn-ven TabDistr

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Gn-ClieD.CodCli gn-clie.NomCli ~
gn-clie.CodDiv GN-DIVI.DesDiv gn-clie.CodVen gn-ven.NomVen ~
TabDistr.NomDistr gn-clie.Canal gn-clie.GirCli gn-clie.ClfCom ~
gn-clie.E-Mail gn-clie.Telfnos[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Gn-ClieD ~
      WHERE Gn-ClieD.CodCia = cl-codcia ~
 AND Gn-ClieD.Sede = "@@@" ~
 AND Gn-ClieD.CodDept = COMBO-BOX_CodDept NO-LOCK, ~
      FIRST gn-clie OF Gn-ClieD ~
      WHERE gn-clie.Flgsit = "A" NO-LOCK, ~
      FIRST GN-DIVI WHERE GN-DIVI.CodDiv = gn-clie.CodDiv ~
      AND GN-DIVI.CodCia = s-codcia OUTER-JOIN NO-LOCK, ~
      FIRST gn-ven WHERE gn-ven.CodVen = gn-clie.CodVen ~
      AND gn-ven.CodCia = s-codcia OUTER-JOIN NO-LOCK, ~
      FIRST TabDistr WHERE TabDistr.CodDepto = Gn-ClieD.CodDept ~
  AND TabDistr.CodProvi = Gn-ClieD.CodProv ~
  AND TabDistr.CodDistr = Gn-ClieD.CodDist OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Gn-ClieD ~
      WHERE Gn-ClieD.CodCia = cl-codcia ~
 AND Gn-ClieD.Sede = "@@@" ~
 AND Gn-ClieD.CodDept = COMBO-BOX_CodDept NO-LOCK, ~
      FIRST gn-clie OF Gn-ClieD ~
      WHERE gn-clie.Flgsit = "A" NO-LOCK, ~
      FIRST GN-DIVI WHERE GN-DIVI.CodDiv = gn-clie.CodDiv ~
      AND GN-DIVI.CodCia = s-codcia OUTER-JOIN NO-LOCK, ~
      FIRST gn-ven WHERE gn-ven.CodVen = gn-clie.CodVen ~
      AND gn-ven.CodCia = s-codcia OUTER-JOIN NO-LOCK, ~
      FIRST TabDistr WHERE TabDistr.CodDepto = Gn-ClieD.CodDept ~
  AND TabDistr.CodProvi = Gn-ClieD.CodProv ~
  AND TabDistr.CodDistr = Gn-ClieD.CodDist OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Gn-ClieD gn-clie GN-DIVI gn-ven ~
TabDistr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Gn-ClieD
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 gn-clie
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 GN-DIVI
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE-2 gn-ven
&Scoped-define FIFTH-TABLE-IN-QUERY-BROWSE-2 TabDistr


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_CodDept BUTTON-1 FILL-IN_FchFac ~
BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodDept FILL-IN_FchFac 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "FILTRAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX_CodDept AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione el departamento" 
     VIEW-AS COMBO-BOX INNER-LINES 30
     LIST-ITEM-PAIRS "15","15"
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchFac AS DATE FORMAT "99/99/9999":U 
     LABEL "Sin Facturación desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Gn-ClieD
    FIELDS(Gn-ClieD.CodCli), 
      gn-clie
    FIELDS(gn-clie.NomCli
      gn-clie.CodDiv
      gn-clie.CodVen
      gn-clie.Canal
      gn-clie.GirCli
      gn-clie.ClfCom
      gn-clie.E-Mail
      gn-clie.Telfnos[1]), 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv), 
      gn-ven
    FIELDS(gn-ven.NomVen), 
      TabDistr
    FIELDS(TabDistr.NomDistr) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Gn-ClieD.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 11.43
      gn-clie.NomCli FORMAT "x(100)":U
      gn-clie.CodDiv FORMAT "x(8)":U
      GN-DIVI.DesDiv FORMAT "X(40)":U
      gn-clie.CodVen COLUMN-LABEL "Vendedor" FORMAT "X(8)":U
      gn-ven.NomVen FORMAT "X(40)":U
      TabDistr.NomDistr FORMAT "X(30)":U
      gn-clie.Canal COLUMN-LABEL "Grupo" FORMAT "x(8)":U
      gn-clie.GirCli COLUMN-LABEL "Giro" FORMAT "X(8)":U
      gn-clie.ClfCom COLUMN-LABEL "Sector!Econ." FORMAT "x(8)":U
      gn-clie.E-Mail COLUMN-LABEL "Correo !Contacto" FORMAT "X(20)":U
            WIDTH 19
      gn-clie.Telfnos[1] COLUMN-LABEL "Telefono 1" FORMAT "X(13)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 23.42
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_CodDept AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 10
     BUTTON-1 AT ROW 1.27 COL 75 WIDGET-ID 14
     FILL-IN_FchFac AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 12
     BROWSE-2 AT ROW 3.15 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tgn-clie T "?" NO-UNDO INTEGRAL gn-clie
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PADRON DE CLIENTES ACTIVOS SIN FACTURACION DESDE UNA FECHA"
         HEIGHT             = 26.15
         WIDTH              = 191.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN_FchFac F-Main */
ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.Gn-ClieD,INTEGRAL.gn-clie OF INTEGRAL.Gn-ClieD,INTEGRAL.GN-DIVI WHERE INTEGRAL.gn-clie ...,INTEGRAL.gn-ven WHERE INTEGRAL.gn-clie ...,INTEGRAL.TabDistr WHERE INTEGRAL.Gn-ClieD ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED, FIRST USED, FIRST OUTER USED, FIRST OUTER USED, FIRST OUTER USED"
     _Where[1]         = "INTEGRAL.Gn-ClieD.CodCia = cl-codcia
 AND INTEGRAL.Gn-ClieD.Sede = ""@@@""
 AND Gn-ClieD.CodDept = COMBO-BOX_CodDept"
     _Where[2]         = "gn-clie.Flgsit = ""A"""
     _JoinCode[3]      = "INTEGRAL.GN-DIVI.CodDiv = gn-clie.CodDiv"
     _Where[3]         = "INTEGRAL.GN-DIVI.CodCia = s-codcia"
     _JoinCode[4]      = "INTEGRAL.gn-ven.CodVen = gn-clie.CodVen"
     _Where[4]         = "INTEGRAL.gn-ven.CodCia = s-codcia"
     _JoinCode[5]      = "TabDistr.CodDepto = Gn-ClieD.CodDept
  AND TabDistr.CodProvi = Gn-ClieD.CodProv
  AND TabDistr.CodDistr = Gn-ClieD.CodDist"
     _FldNameList[1]   > INTEGRAL.Gn-ClieD.CodCli
"Gn-ClieD.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? "x(100)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.gn-clie.CodDiv
"gn-clie.CodDiv" ? "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.GN-DIVI.DesDiv
     _FldNameList[5]   > INTEGRAL.gn-clie.CodVen
"gn-clie.CodVen" "Vendedor" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.gn-ven.NomVen
     _FldNameList[7]   = INTEGRAL.TabDistr.NomDistr
     _FldNameList[8]   > INTEGRAL.gn-clie.Canal
"gn-clie.Canal" "Grupo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.gn-clie.GirCli
"gn-clie.GirCli" "Giro" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.gn-clie.ClfCom
"gn-clie.ClfCom" "Sector!Econ." "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.gn-clie.E-Mail
"gn-clie.E-Mail" "Correo !Contacto" ? "character" ? ? ? ? ? ? no ? no no "19" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.gn-clie.Telfnos[1]
"gn-clie.Telfnos[1]" "Telefono 1" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PADRON DE CLIENTES ACTIVOS SIN FACTURACION DESDE UNA FECHA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PADRON DE CLIENTES ACTIVOS SIN FACTURACION DESDE UNA FECHA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* FILTRAR */
DO:
  ASSIGN COMBO-BOX_CodDept FILL-IN_FchFac.
/*   RUN Carga-Temporal. */
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON FIND OF gn-clie DO:
    IF CAN-FIND(FIRST Ccbcdocu 
                USE-INDEX Llave06 
                WHERE Ccbcdocu.codcia = s-codcia AND
                Ccbcdocu.codcli = gn-clie.codcli AND
                Ccbcdocu.fchdoc >= FILL-IN_FchFac AND
                (Ccbcdocu.coddoc = 'FAC' OR Ccbcdocu.coddoc = 'BOL')
                NO-LOCK)
        THEN RETURN ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tgn-clie.

FOR EACH gn-clied FIELD(codcia codcli sede coddept) 
    NO-LOCK WHERE gn-clied.codcia = cl-codcia AND
    gn-clied.sede = "@@@" AND
    gn-clied.coddept = COMBO-BOX_CodDept,
    FIRST gn-clie FIELD(codcia codcli canal clfcom coddiv codven gircli nomcli telfnos)
    OF gn-clied NO-LOCK WHERE gn-clie.flgsit = "A":
    IF NOT CAN-FIND(FIRST Ccbcdocu USE-INDEX Llave06 WHERE Ccbcdocu.codcia = s-codcia AND 
                    Ccbcdocu.codcli = gn-clie.codcli AND
                    Ccbcdocu.fchdoc >= FILL-IN_FchFac AND
                    (Ccbcdocu.coddoc = 'FAC' OR Ccbcdocu.coddoc = 'BOL')
                    NO-LOCK)
        THEN DO:
        CREATE tgn-clie.
        ASSIGN
            tgn-clie.codcia       = gn-clie.codcia
            tgn-clie.Canal        = gn-clie.canal
            tgn-clie.ClfCom       = gn-clie.clfcom
            tgn-clie.CodCli       = gn-clie.codcli
            tgn-clie.CodDiv       = gn-clie.coddiv
            tgn-clie.CodVen       = gn-clie.codven
            tgn-clie.GirCli       = gn-clie.gircli
            tgn-clie.NomCli       = gn-clie.nomcli
            tgn-clie.Telfnos[1]   = gn-clie.telfnos[1]
            .
    END.
END.

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
  DISPLAY COMBO-BOX_CodDept FILL-IN_FchFac 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX_CodDept BUTTON-1 FILL-IN_FchFac BROWSE-2 
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_CodDept:DELETE(1).
      FOR EACH TabDepto NO-LOCK:
          COMBO-BOX_CodDept:ADD-LAST(TabDepto.CodDepto + " - " + TabDepto.NomDepto, TabDepto.CodDepto).
      END.
      COMBO-BOX_CodDept = "15".
      FILL-IN_FchFac = 01/01/2018.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Gn-ClieD"}
  {src/adm/template/snd-list.i "gn-clie"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "gn-ven"}
  {src/adm/template/snd-list.i "TabDistr"}

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

