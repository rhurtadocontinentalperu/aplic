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

DEFINE TEMP-TABLE tt-regLPN
    FIELDS ttCodLPN AS CHAR FORMAT 'x(20)'
    FIELDS ttFchent AS DATE
    FIELDS ttTienda AS CHAR FORMAT 'x(100)'
    FIELDS tt4digi AS CHAR FORMAT 'x(6)'
    FIELDS ttCodCli AS CHAR FORMAT 'x(15)'.

DEFINE VAR rpta AS LOG.
DEF STREAM REPORTE.

DEFINE VAR pOrdenCompra AS CHAR INIT ''.
DEFINE VAR pCuales AS INT INIT 2.

DEFINE VAR x-codcli AS CHAR.

x-codcli = '20100070970'. 

/* El LPN se genera luego de haberse facturado */
&SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.ControlOD.CodCia = s-codcia AND ~
            integral.ControlOD.Codcli = x-codcli  AND ~
            (integral.ControlOD.nrofac <> '' AND integral.ControlOD.nrofac <> ? )  AND ~
            (( pCuales = 2 AND integral.controlOD.lpn = 'POR DEFINIR') OR ~
             ( pCuales = 1 AND integral.controlOD.lpn <> 'POR DEFINIR'))  AND ~
            ( pOrdenCompra = '' OR INTEGRAL.ControlOD.OrdCmp BEGINS pOrdenCompra ))

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
&Scoped-define INTERNAL-TABLES ControlOD

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ControlOD.OrdCmp ControlOD.CodDoc ~
ControlOD.NroDoc ControlOD.NroFac ControlOD.LPN ControlOD.NroEtq ~
ControlOD.FchChq ControlOD.HorChq 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ControlOD ~
      WHERE {&CONDICION} NO-LOCK ~
    BY ControlOD.FchChq DESCENDING ~
       BY ControlOD.HorChq DESCENDING
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ControlOD ~
      WHERE {&CONDICION} NO-LOCK ~
    BY ControlOD.FchChq DESCENDING ~
       BY ControlOD.HorChq DESCENDING.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ControlOD
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ControlOD


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-cliente txtOrdenCompra ~
btnImpresion rbCuales BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-cliente txtOrdenCompra rbCuales 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnFiltrar 
     LABEL "Filtrar" 
     SIZE 13.86 BY .88.

DEFINE BUTTON btnImpresion 
     LABEL "Procesar LPN" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtOrdenCompra AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-cliente AS CHARACTER INITIAL "20100070970" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "SUPERMERCADOS - LIMA", "20100070970",
"SUPERMERCADOS - ORIENTE", "20601233488"
     SIZE 53 BY .77
     FONT 4 NO-UNDO.

DEFINE VARIABLE rbCuales AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Para imprimir", 1,
"Para imprimir - Nuevo Formato", 3,
"Para Generar LPN", 2
     SIZE 68 BY 1.15 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ControlOD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ControlOD.OrdCmp FORMAT "X(12)":U WIDTH 13.43
      ControlOD.CodDoc COLUMN-LABEL "Tipo!Doc" FORMAT "x(3)":U
            WIDTH 5.43
      ControlOD.NroDoc FORMAT "X(9)":U WIDTH 11.43
      ControlOD.NroFac COLUMN-LABEL "Nro!Factura" FORMAT "x(12)":U
      ControlOD.LPN FORMAT "x(18)":U WIDTH 26.43
      ControlOD.NroEtq COLUMN-LABEL "Bulto" FORMAT "x(25)":U WIDTH 21.86
      ControlOD.FchChq FORMAT "99/99/9999":U
      ControlOD.HorChq FORMAT "x(10)":U WIDTH 12.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 119 BY 19.38 ROW-HEIGHT-CHARS .65 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-cliente AT ROW 2.46 COL 29.14 NO-LABEL WIDGET-ID 16
     txtOrdenCompra AT ROW 2.92 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     btnImpresion AT ROW 2.92 COL 102 WIDGET-ID 4
     rbCuales AT ROW 3.38 COL 29 NO-LABEL WIDGET-ID 12
     BtnFiltrar AT ROW 4 COL 8.43 WIDGET-ID 10
     BROWSE-2 AT ROW 5 COL 2 WIDGET-ID 200
     "Orden de Compra" VIEW-AS TEXT
          SIZE 15.86 BY .62 AT ROW 2.31 COL 7.43 WIDGET-ID 8
     "Impresion/Generacion de etiquetas LPN - SUPERMERCADOS PERUANOS" VIEW-AS TEXT
          SIZE 93 BY .96 AT ROW 1.19 COL 10 WIDGET-ID 2
          FGCOLOR 4 FONT 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 120.72 BY 23.77 WIDGET-ID 100.


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
         TITLE              = "Impresion de Etiquetas LPN"
         HEIGHT             = 23.77
         WIDTH              = 120.72
         MAX-HEIGHT         = 23.77
         MAX-WIDTH          = 120.72
         VIRTUAL-HEIGHT     = 23.77
         VIRTUAL-WIDTH      = 120.72
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 BtnFiltrar F-Main */
/* SETTINGS FOR BUTTON BtnFiltrar IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.ControlOD"
     _Options          = "NO-LOCK"
     _OrdList          = "INTEGRAL.ControlOD.FchChq|no,INTEGRAL.ControlOD.HorChq|no"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > INTEGRAL.ControlOD.OrdCmp
"ControlOD.OrdCmp" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ControlOD.CodDoc
"ControlOD.CodDoc" "Tipo!Doc" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.ControlOD.NroDoc
"ControlOD.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.ControlOD.NroFac
"ControlOD.NroFac" "Nro!Factura" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.ControlOD.LPN
"ControlOD.LPN" ? ? "character" ? ? ? ? ? ? no ? no no "26.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ControlOD.NroEtq
"ControlOD.NroEtq" "Bulto" ? "character" ? ? ? ? ? ? no ? no no "21.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.ControlOD.FchChq
     _FldNameList[8]   > INTEGRAL.ControlOD.HorChq
"ControlOD.HorChq" ? ? "character" ? ? ? ? ? ? no ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Impresion de Etiquetas LPN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Impresion de Etiquetas LPN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFiltrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFiltrar W-Win
ON CHOOSE OF BtnFiltrar IN FRAME F-Main /* Filtrar */
DO:
    
    ASSIGN txtOrdenCompra rbCuales.

    pOrdenCompra = "".
    pCuales = rbCuales.
    IF txtOrdenCompra <> "" THEN pOrdenCompra = trim(txtOrdenCompra) .

    {&OPEN-QUERY-BROWSE-2}   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnImpresion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnImpresion W-Win
ON CHOOSE OF btnImpresion IN FRAME F-Main /* Procesar LPN */
DO:
  ASSIGN txtOrdenCompra rbCuales.
  RUN ue-procesar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-cliente W-Win
ON VALUE-CHANGED OF RADIO-SET-cliente IN FRAME F-Main
DO:
    ASSIGN txtOrdenCompra rbCuales radio-set-cliente.

    x-codcli = radio-set-cliente.
    pOrdenCompra = "".
    pCuales = IF (rbCuales = 2) THEN rbCuales ELSE 1.
    IF txtOrdenCompra <> "" THEN pOrdenCompra = trim(txtOrdenCompra) .

    {&OPEN-QUERY-BROWSE-2}   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rbCuales
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rbCuales W-Win
ON VALUE-CHANGED OF rbCuales IN FRAME F-Main
DO:
    ASSIGN txtOrdenCompra rbCuales radio-set-cliente.

    x-codcli = radio-set-cliente.
    pOrdenCompra = "".
    pCuales = IF (rbCuales = 2) THEN rbCuales ELSE 1.
    IF txtOrdenCompra <> "" THEN pOrdenCompra = trim(txtOrdenCompra) .

    {&OPEN-QUERY-BROWSE-2}   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtOrdenCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtOrdenCompra W-Win
ON LEAVE OF txtOrdenCompra IN FRAME F-Main
DO:
     ASSIGN txtOrdenCompra rbCuales.

    pOrdenCompra = "".
    pCuales = rbCuales.
    IF txtOrdenCompra <> "" THEN pOrdenCompra = trim(txtOrdenCompra) .

    {&OPEN-QUERY-BROWSE-2}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DISPLAY RADIO-SET-cliente txtOrdenCompra rbCuales 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-cliente txtOrdenCompra btnImpresion rbCuales BROWSE-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.


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
  {src/adm/template/snd-list.i "ControlOD"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-generar-lpn W-Win 
PROCEDURE ue-generar-lpn :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lRowId AS ROWID.
DEFINE BUFFER b-controlOD FOR controlOD.
    
GET FIRST {&BROWSE-NAME}.
IF AVAILABLE controlOD THEN DO:

    {lib/lock-genericov2.i ~
        &Tabla="SupControlOC" ~
        &Condicion="SupControlOC.CodCia = s-codcia ~
        AND SupControlOC.CodDiv = '00017' ~
        AND SupControlOC.CodCli = controlOD.Codcli ~
        AND SupControlOC.OrdCmp = controlOD.ordcmp" ~         /*controlOD.LPN2*/
        &Bloqueo="EXCLUSIVE-LOCK" 
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN ERROR" ~
        }

    DO  WHILE AVAILABLE controlOD:
        lRowId = ROWID(controlOD).

        FIND FIRST b-controlOD WHERE lRowId = ROWID(b-controlOD) NO-ERROR.
        IF AVAILABLE b-controlOD THEN DO:
            ASSIGN
                b-ControlOD.LPN3 = STRING(SupControlOC.Correlativo + 1, '9999')
                b-ControlOD.LPN  = TRIM(b-ControlOD.LPN1) + TRIM(b-ControlOD.LPN2) + TRIM(b-ControlOD.LPN3).
            ASSIGN
                SupControlOC.Correlativo = SupControlOC.Correlativo + 1.
        END.
        GET NEXT {&BROWSE-NAME}.
    END.
END.

IF AVAILABLE b-ControlOD THEN RELEASE b-ControlOD.
IF AVAILABLE SupControlOC THEN RELEASE SupControlOC.

{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imp-etiqueta W-Win 
PROCEDURE ue-imp-etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*Empresa*/
PUT STREAM REPORTE '^XA^LH000,012' SKIP.
PUT STREAM REPORTE '^FO50,05' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
PUT STREAM REPORTE '^FDCONTINENTAL S.A.C.^FS' SKIP.
/* */
PUT STREAM REPORTE '^FO700,05' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  tt-regLPN.tt4digi FORMAT 'x(6)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.
/* Barras */
PUT STREAM REPORTE '^FO50,40' SKIP.
PUT STREAM REPORTE '^BY2^BCN,70,Y,N,N' SKIP.
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  tt-regLPN.ttCodLPN FORMAT 'x(18)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

/*PUT STREAM REPORTE '^FD500071009490520003^FS' SKIP.*/
/*Fecha entrega*/
PUT STREAM REPORTE '^FO550,50' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
PUT STREAM REPORTE '^FDFECHA ENTREGA^FS' SKIP.
PUT STREAM REPORTE '^FO580,90' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
/*PUT STREAM REPORTE '^FD99/99/9999^FS' SKIP.*/
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  tt-regLPN.ttfchent FORMAT '99/99/9999' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

/* Tienda */
PUT STREAM REPORTE '^FO50,140' SKIP.
PUT STREAM REPORTE '^AON,30,15' SKIP.
/*PUT STREAM REPORTE '^FDP119 SPSA PVEA PUENTE PIEDRA^FS' SKIP.*/
PUT STREAM REPORTE '^FD' SKIP.
PUT STREAM REPORTE  'TDA :' + tt-regLPN.ttTienda FORMAT 'x(80)' SKIP.
PUT STREAM REPORTE '^FS' SKIP.

PUT STREAM REPORTE '^PQ1' SKIP.
PUT STREAM REPORTE '^PR6' SKIP.
PUT STREAM REPORTE '^XZ' SKIP.

END PROCEDURE.

/*
DEFINE TEMP-TABLE tt-regLPN
    FIELDS ttCodLPN AS CHAR FORMAT 'x(15)'
    FIELDS ttFchent AS DATE
    FIELDS ttTienda AS CHAR FORMAT 'x(100)'
    FIELDS tt4digi AS CHAR FORMAT 'x(6)'.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imprime-nuevo-formato W-Win 
PROCEDURE ue-imprime-nuevo-formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pTexto AS CHAR.
    DEFINE INPUT PARAMETER pCodBarra AS CHAR.
    DEFINE INPUT PARAMETER pFecha AS CHAR.
    DEFINE INPUT PARAMETER pBarraLocal AS CHAR.

    DEFINE VAR xTexto AS CHAR.

    xTexto = REPLACE(pTexto,"SPSA PVEA","").
    xTexto = REPLACE(xTexto,"SPSA PLAZA VEA","").
    xTexto = REPLACE(xTexto,"  "," ").

    /* Inicio de Formato */
    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    /**/
    PUT STREAM REPORTE '^FO10,020' SKIP.
    PUT STREAM REPORTE '^AVN,80,50' SKIP. /*120,60*/
    
    PUT STREAM REPORTE '^FD' SKIP.
    PUT STREAM REPORTE  xTexto FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE '^FS' SKIP.

    /* Barras LOCAL */
    PUT STREAM REPORTE '^FO220,110' SKIP.    /*40,180*/
    PUT STREAM REPORTE '^BY2^BCN,100,Y,N,N' SKIP.
    PUT STREAM REPORTE '^FD' SKIP.
    PUT STREAM REPORTE  pBarraLocal FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE '^FS' SKIP.

    /* Barras LPN */
    PUT STREAM REPORTE '^FO50,260' SKIP.    /*40,180*/
    PUT STREAM REPORTE '^BY3^BCN,180,Y,N,N' SKIP.
    PUT STREAM REPORTE '^FD' SKIP.
    PUT STREAM REPORTE  pCodBarra FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE '^FS' SKIP.

    /* Fecha */
    PUT STREAM REPORTE '^FO220,500' SKIP.   /*160,420*/
    PUT STREAM REPORTE '^AVN,40,30' SKIP.    
    PUT STREAM REPORTE '^FD' SKIP.
    PUT STREAM REPORTE  pFecha FORMAT 'x(10)' SKIP.
    PUT STREAM REPORTE '^FS' SKIP.

    /* Fin */
    PUT STREAM REPORTE "^XZ" SKIP.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-imprimir W-Win 
PROCEDURE ue-imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iTCont AS INT INIT 0.                  
DEFINE VAR iCont AS INT INIT 0.                  
DEFINE VAR lOD AS CHAR.
DEFINE VAR lPED AS CHAR.
DEFINE VAR lCOT AS CHAR.
DEFINE VAR lNroEtq AS CHAR.

DEFINE VAR lCodDiv AS CHAR.
DEFINE VAR l4Dig AS CHAR.

EMPTY TEMP-TABLE tt-regLPN.
                  
/*&BROWSE-NAME*/

DO WITH FRAME {&FRAME-NAME}:
    iTCont = BROWSE-2:NUM-SELECTED-ROWS.
    DO iCont = 1 TO iTCont :
        IF BROWSE-2:FETCH-SELECTED-ROW(icont) THEN DO:
            lNroEtq = TRIM({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroEtq).

            l4Dig = '0000'.
            IF LENGTH(lNroEtq) > 6 THEN DO:
                l4Dig = SUBSTRING(lnroEtq,LENGTH(lNroEtq) - 3, 4).
            END.
           
            CREATE tt-regLPN.
                ASSIGN tt-regLPN.ttCodLPN = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.LPN.
                       tt-regLPN.tt4digi = l4Dig.

            lPED = "".
            lCOT = "".
            lOD = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.NroDoc.
            lCodDiv = ''.
            /* Ubico la orden de despacho para ver el PEDIDO*/
            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                    faccpedi.coddoc = 'O/D' AND 
                                    faccpedi.nroped = lOD NO-LOCK NO-ERROR.
            IF AVAILABLE faccpedi THEN do:
                ASSIGN tt-regLPN.ttFchent = faccpedi.fchent.
                lPED = faccpedi.nroref.
            END.
            /* Busco el PEDIDO  */
            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                    faccpedi.coddoc = 'PED' AND 
                                    faccpedi.nroped = lPED NO-LOCK NO-ERROR.
            IF AVAILABLE faccpedi THEN do:
                lCOT = faccpedi.nroref.
                lCodDiv = faccpedi.coddiv.
            END.
            /* COTIZACION */
            FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                    faccpedi.coddoc = 'COT' AND 
                                    faccpedi.nroped = lCOT AND 
                                    faccpedi.coddiv = lCodDiv NO-LOCK NO-ERROR.
            IF AVAILABLE faccpedi THEN do:
                ASSIGN tt-regLPN.ttTienda = faccpedi.ubigeo[1]
                        tt-regLPN.ttCodCli = faccpedi.codcli.
            END.            
            RELEASE faccpedi.
        END.
    END.
END.

FIND FIRST tt-regLPN NO-ERROR.
IF AVAILABLE tt-regLPN THEN DO:

    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.
    OUTPUT STREAM REPORTE TO PRINTER.

    DEFINE VAR x-fechaent AS CHAR.
    DEFINE VAR x-codtda AS CHAR.
    DEFINE VAR x-codbarratda AS CHAR.

    FOR EACH tt-regLPN :
        /* Formato antiguo */
        IF rbCuales = 1 THEN RUN ue-imp-etiqueta.

        /* Formato nuevo */
        IF rbCuales = 3 THEN DO:
            x-fechaent = STRING(tt-regLPN.ttFchent,"99/99/9999").
            x-fechaent = REPLACE(x-fechaent,"/","-").
            x-codtda = ENTRY(1,TRIM(tt-regLPN.ttTienda)," ").
            x-codbarratda = "".
            
            FIND FIRST gn-clieD WHERE gn-clieD.codcia = 0 AND 
                                        gn-clieD.codcli = tt-regLPN.ttcodcli AND 
                                        gn-clieD.sede = x-codtda NO-LOCK NO-ERROR.

            IF AVAILABLE gn-clieD THEN x-codbarratda = gn-clieD.libre_c02.
                        
            RUN ue-imprime-nuevo-formato(INPUT tt-regLPN.ttTienda, 
                            INPUT tt-regLPN.ttCodLPN, 
                            INPUT x-fechaent,
                            INPUT x-codbarratda).
            /*
            RUN pImprimeEtq(INPUT "P235 SPSA PVEA CUSCO SAN JERONIMO",
                            INPUT "500071012160650100","15-04-2017","F003ND00AAC").
            */
        END.
    END.
END.

OUTPUT STREAM REPORTE CLOSE.

/*
DEFINE TEMP-TABLE tt-regLPN
    FIELDS ttCodLPN AS CHAR FORMAT 'x(15)'
    FIELDS ttFchent AS DATE
    FIELDS ttTienda AS CHAR FORMAT 'x(100)'
    FIELDS tt4digi AS CHAR FORMAT 'x(6)'.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar W-Win 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Seguro de Procesar?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

IF rbCuales = 1 OR rbCuales = 3 THEN DO:
    RUN ue-imprimir.
END.
ELSE DO:
    IF txtOrdenCompra = '' THEN DO:
        MESSAGE "Debe indicar numero de Orden de Compra".
        RETURN NO-APPLY.
    END.
    ELSE DO:
        RUN ue-generar-lpn.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

