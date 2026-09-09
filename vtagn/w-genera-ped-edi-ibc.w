&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE tt-FacCPedi NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE x-FacDPedi NO-UNDO LIKE FacDPedi.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodDoc AS CHAR INIT 'PED' NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR s-CodAlm AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion ( FacCPedi.CodCia = s-codcia ~
AND FacCPedi.CodDoc = 'COT' ~
AND FacCPedi.CodDiv = s-coddiv ~
AND FacCPedi.FlgEst = 'P' ~
AND (FacCPedi.CodCli = FILL-IN-CodCli) ~
AND (Faccpedi.ordcmp = txtOrdenCompra) ~
)


IF NOT CAN-FIND(FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia 
    AND FacCorre.CodDoc = s-CodDoc 
    AND FacCorre.CodDiv = s-CodDiv 
    AND FacCorre.FlgEst = YES NO-LOCK) THEN DO:
    MESSAGE 'NO definido un correlativo para el documento' s-coddoc 'en la división' s-coddiv SKIP
        'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DEF VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.

/* RHC 31/01/2018 Valores por defecto pero dependen de la COTIZACION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    s-DiasVtoPed = GN-DIVI.DiasVtoPed
    s-FlgEmpaque = GN-DIVI.FlgEmpaque.

DEF VAR s-PorIgv AS DECI NO-UNDO.
DEF VAR s-FmaPgo AS CHAR NO-UNDO.
DEF VAR s-CodMon AS INTE NO-UNDO.
DEF VAR s-TpoPed AS CHAR NO-UNDO.
DEF VAR s-CodCli AS CHAR NO-UNDO.
DEF VAR pMensajeFinal AS CHAR NO-UNDO.
DEF VAR s-Tipo-Abastecimiento AS CHAR NO-UNDO.

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-FacCPedi

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-FacCPedi.CodDoc ~
tt-FacCPedi.NroPed tt-FacCPedi.FchPed tt-FacCPedi.fchven tt-FacCPedi.FchEnt ~
tt-FacCPedi.CodCli tt-FacCPedi.NomCli tt-FacCPedi.ImpTot tt-FacCPedi.FmaPgo ~
tt-FacCPedi.Glosa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-FacCPedi NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-FacCPedi NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-57 COMBO-BOX_CodAlm BUTTON-FILTRAR ~
COMBO-NroSer BUTTON-LIMPIAR FILL-IN-CodCli txtOrdenCompra BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodAlm COMBO-NroSer ~
FILL-IN-CodCli FILL-IN-NomCli txtOrdenCompra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-FILTRAR 
     LABEL "FILTRAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-GENERAR 
     LABEL "GENERAR PEDIDOS LOGISTICOS" 
     SIZE 29 BY 1.12.

DEFINE BUTTON BUTTON-LIMPIAR 
     LABEL "LIMPIAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX_CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione Almacén Despacho" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 50 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Nro. de Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Filtrar por Código del cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE txtOrdenCompra AS CHARACTER FORMAT "X(15)":U 
     LABEL "Nro. Orden de Compra" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 139 BY 4.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      tt-FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-FacCPedi.CodDoc COLUMN-LABEL "T.Doc" FORMAT "x(3)":U
      tt-FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
            WIDTH 9.57
      tt-FacCPedi.FchPed COLUMN-LABEL "Fch.Emision" FORMAT "99/99/9999":U
      tt-FacCPedi.fchven COLUMN-LABEL "Vcto" FORMAT "99/99/99":U
            WIDTH 8
      tt-FacCPedi.FchEnt COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            WIDTH 9.43
      tt-FacCPedi.CodCli FORMAT "x(11)":U WIDTH 10
      tt-FacCPedi.NomCli FORMAT "x(100)":U WIDTH 30.14
      tt-FacCPedi.ImpTot COLUMN-LABEL "Imp.Total" FORMAT "->>,>>>,>>9.99":U
      tt-FacCPedi.FmaPgo COLUMN-LABEL "Cnd.Vta" FORMAT "X(8)":U
      tt-FacCPedi.Glosa FORMAT "X(50)":U WIDTH 34.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-COLUMN-SCROLLING SEPARATORS SIZE 139 BY 19.12
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_CodAlm AT ROW 1.27 COL 26 COLON-ALIGNED WIDGET-ID 2
     BUTTON-FILTRAR AT ROW 1.27 COL 124 WIDGET-ID 34
     COMBO-NroSer AT ROW 2.35 COL 18.28 WIDGET-ID 30
     BUTTON-LIMPIAR AT ROW 2.62 COL 124 WIDGET-ID 186
     FILL-IN-CodCli AT ROW 3.42 COL 26 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-NomCli AT ROW 3.42 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     txtOrdenCompra AT ROW 4.5 COL 26 COLON-ALIGNED WIDGET-ID 24
     BROWSE-4 AT ROW 5.58 COL 2 WIDGET-ID 200
     BUTTON-GENERAR AT ROW 24.96 COL 2 WIDGET-ID 188
     RECT-57 AT ROW 1 COL 2 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141 BY 25.38
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: tt-FacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: x-FacDPedi T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE PEDIDOS COMERCIALES"
         HEIGHT             = 25.38
         WIDTH              = 141
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
/* BROWSE-TAB BROWSE-4 txtOrdenCompra F-Main */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR BUTTON BUTTON-GENERAR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-FacCPedi.CodDoc
"tt-FacCPedi.CodDoc" "T.Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-FacCPedi.NroPed
"tt-FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-FacCPedi.FchPed
"tt-FacCPedi.FchPed" "Fch.Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-FacCPedi.fchven
"tt-FacCPedi.fchven" "Vcto" ? "date" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-FacCPedi.FchEnt
"tt-FacCPedi.FchEnt" "Entrega" ? "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-FacCPedi.CodCli
"tt-FacCPedi.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-FacCPedi.NomCli
"tt-FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "30.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-FacCPedi.ImpTot
"tt-FacCPedi.ImpTot" "Imp.Total" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-FacCPedi.FmaPgo
"tt-FacCPedi.FmaPgo" "Cnd.Vta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-FacCPedi.Glosa
"tt-FacCPedi.Glosa" ? ? "character" ? ? ? ? ? ? no ? no no "34.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE PEDIDOS COMERCIALES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE PEDIDOS COMERCIALES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-FILTRAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-FILTRAR W-Win
ON CHOOSE OF BUTTON-FILTRAR IN FRAME F-Main /* FILTRAR */
DO:
    ASSIGN
        FILL-IN-CodCli txtOrdenCompra.

    IF NOT CAN-FIND(FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                    AND gn-clie.codcli = FILL-IN-CodCli NO-LOCK)
        THEN DO:
        MESSAGE 'Cliente NO registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN-CodCli.
        RETURN NO-APPLY.
    END.
    IF TRUE <> (FILL-IN-Codcli > "") OR TRUE <> (txtOrdenCompra > "") THEN DO:
        MESSAGE "Ingrese codigo Cliente y Orden de Compra" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    
    RUN cargar-cotizaciones.

    {&OPEN-QUERY-{&BROWSE-NAME}}

    IF CAN-FIND(FIRST tt-Faccpedi NO-LOCK) THEN DO:
        FILL-IN-CodCli:SENSITIVE = NO.
        txtOrdenCompra:SENSITIVE = NO.
        BUTTON-GENERAR:SENSITIVE = YES.
        BUTTON-FILTRAR:SENSITIVE = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-GENERAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-GENERAR W-Win
ON CHOOSE OF BUTTON-GENERAR IN FRAME F-Main /* GENERAR PEDIDOS LOGISTICOS */
DO:
  MESSAGE 'Seguro de GENERAR los Pedidos?' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  s-CodAlm = ENTRY(1, COMBO-BOX_CodAlm, " - ").
  
  RUN MASTER-TRANSACTION.

  APPLY 'CHOOSE':U TO BUTTON-LIMPIAR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-LIMPIAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-LIMPIAR W-Win
ON CHOOSE OF BUTTON-LIMPIAR IN FRAME F-Main /* LIMPIAR FILTRO */
DO:
  CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
  EMPTY TEMP-TABLE tt-Faccpedi.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  FILL-IN-CodCli:SENSITIVE = YES.
  txtOrdenCompra:SENSITIVE = YES.
  BUTTON-GENERAR:SENSITIVE = NO.
  BUTTON-FILTRAR:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Nro. de Serie */
DO:
    ASSIGN COMBO-NroSer.
    s-NroSer = INTEGER(COMBO-NroSer).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Filtrar por Código del cliente */
DO:
  FILL-IN-NomCli:SCREEN-VALUE = ''.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = FILL-IN-CodCli:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cargar-Cotizaciones W-Win 
PROCEDURE Cargar-Cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-faccpedi.

FOR EACH Faccpedi WHERE {&condicion} NO-LOCK:
    CREATE tt-faccpedi.
    BUFFER-COPY Faccpedi TO tt-faccpedi.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-detalle-cotizacion W-Win 
PROCEDURE cargar-detalle-cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.

EMPTY TEMP-TABLE PEDI.
FOR EACH Facdpedi OF tt-faccpedi NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0
        AND Facdpedi.CanAte >= 0,
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK
    BY Facdpedi.NroItm:
    CREATE PEDI.
    BUFFER-COPY FacDPedi 
        EXCEPT Facdpedi.CanSol Facdpedi.CanApr
        TO PEDI
        ASSIGN 
            PEDI.CodCia = s-codcia
            PEDI.CodDiv = s-coddiv
            PEDI.CodDoc = s-coddoc
            PEDI.NroPed = ''
            PEDI.CodCli = tt-faccpedi.CodCli
            PEDI.ALMDES = s-CodAlm  /* *** OJO *** */
            PEDI.NroItm = I-NPEDI
            PEDI.CanPed = (Facdpedi.CanPed - Facdpedi.CanAte)   /* << OJO << */
            PEDI.CanAte = 0.
    ASSIGN
        PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_d02 = (FacDPedi.CanPed - FacDPedi.CanAte)
        PEDI.Libre_c01 = '*'.
    IF PEDI.CanPed <> FacdPedi.CanPed THEN DO:
        ASSIGN
            PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                        ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[3] / 100 ).
        IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
            THEN PEDI.ImpDto = 0.
        ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
        ASSIGN
            PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
            PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
        IF PEDI.AftIsc 
            THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
        IF PEDI.AftIgv 
            THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (tt-Faccpedi.PorIgv / 100) ), 4 ).
    END.
    I-NPEDI = I-NPEDI + 1.
END.
IF NOT CAN-FIND(FIRST PEDI NO-LOCK) THEN DO:
    pMensaje = "NO hay detalle que cargar".
    /* Ic - 25Set2018, el pedido no creo ningun item */
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE crea-cabecera W-Win 
PROCEDURE crea-cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pRowid AS ROWID.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* Bloqueamos el correlativo para controlar las actualizaciones multiusuario */
  {lib/lock-genericov3.i
      &Tabla="FacCorre"
      &Alcance="FIRST"
      &Condicion="Faccorre.codcia = s-codcia ~
          AND Faccorre.coddoc = s-coddoc ~
          AND Faccorre.nroser = s-nroser"
      &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
      &Accion="RETRY"
      &Mensaje="NO"
      &txtMensaje="pMensaje"
      &TipoError="UNDO, RETURN 'ADM-ERROR'"
      }

  s-PorIgv = tt-Faccpedi.PorIgv.
  s-FmaPgo = tt-Faccpedi.FmaPgo.
  s-codmon = tt-Faccpedi.codmon.
  s-TpoPed = tt-Faccpedi.tpoped.
  s-codcli = tt-Faccpedi.codcli.

  CREATE Faccpedi.
  ASSIGN 
      Faccpedi.codcia = s-codcia
      Faccpedi.coddoc = s-CodDoc
      Faccpedi.nroped = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
      Faccpedi.TpoCmb = tt-Faccpedi.TpoCmb
      Faccpedi.FchPed = TODAY
      Faccpedi.Hora   = STRING(TIME,"HH:MM:SS")
      Faccpedi.coddiv = S-CODDIV
      Faccpedi.PorIgv = s-PorIgv
      Faccpedi.FlgEst = "X"       /* POR APROBAR POR CREDITOS Y COBRANZAS */
      Faccpedi.TpoPed = "CR"
      Faccpedi.tpocmb = tt-Faccpedi.TpoCmb
      Faccpedi.fchent = IF (tt-Faccpedi.FchEnt >= TODAY) THEN tt-Faccpedi.FchEnt ELSE TODAY
      Faccpedi.fchven = TODAY + s-DiasVtoPed
      Faccpedi.CodCli = tt-Faccpedi.CodCli
      Faccpedi.NomCli = tt-Faccpedi.NomCli
      Faccpedi.RucCli = tt-Faccpedi.RucCli
      Faccpedi.Atencion = tt-Faccpedi.Atencion
      Faccpedi.DirCli = tt-Faccpedi.Dircli
      Faccpedi.NroCard = tt-Faccpedi.NroCard
      Faccpedi.Sede   = tt-Faccpedi.Sede
      Faccpedi.CodVen = tt-Faccpedi.CodVen
      Faccpedi.FmaPgo = tt-Faccpedi.FmaPgo
      Faccpedi.Glosa  = tt-Faccpedi.Glosa
      Faccpedi.CodRef = tt-Faccpedi.CodDoc
      Faccpedi.NroRef = tt-Faccpedi.NroPed /* Nro Cotizacion */
      Faccpedi.OrdCmp = tt-Faccpedi.OrdCmp
      Faccpedi.FaxCli = tt-Faccpedi.FaxCli
      Faccpedi.CodPos = tt-Faccpedi.CodPos
      Faccpedi.Libre_c01 = tt-Faccpedi.Libre_c01
      Faccpedi.codalm = s-codalm
      Faccpedi.tipvta = ""     /* Cliente Recoge : Vacio = NO */
      Faccpedi.cmpbnte = tt-Faccpedi.cmpbnte
      Faccpedi.codmon = tt-Faccpedi.codmon
      Faccpedi.flgigv = tt-Faccpedi.flgigv
      Faccpedi.lugent = tt-Faccpedi.lugent
      Faccpedi.usuario = s-user-id 
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      {lib/mensaje-de-error.i &MensajeError="pMensaje"}
      UNDO, RETURN "ADM-ERROR".
  END.
  ASSIGN pRowid = ROWID(Faccpedi).
  /* *************************************************************************************** */
  /* INFORMACION PARA LISTA EXPRESS */
  /* *************************************************************************************** */
  ASSIGN
      FacCPedi.PorDto     = COTIZACION.PorDto      /* Descuento LISTA EXPRESS */
      FacCPedi.ImpDto2    = COTIZACION.ImpDto2     /* Importe Decto Lista Express */
      FacCPedi.Importe[2] = COTIZACION.Importe[2] /* Importe Dcto Lista Express SIN IGV */
      FacCPedi.Libre_c02 = s-Tipo-Abastecimiento  /* PCO o NORMAL */
      .
  /* *************************************************************************************** */
  /* RHC 09/04/2021 Datos del B2C y B2B */
  /* *************************************************************************************** */
  ASSIGN
      Faccpedi.CustomerPurchaseOrder = tt-Faccpedi.CustomerPurchaseOrder 
      Faccpedi.InvoiceCustomerGroup = tt-Faccpedi.InvoiceCustomerGroup
      FacCPedi.ContactReceptorName = tt-Faccpedi.ContactReceptorName 
      FacCPedi.TelephoneContactReceptor = tt-Faccpedi.TelephoneContactReceptor 
      FacCPedi.ReferenceAddress = tt-Faccpedi.ReferenceAddress 
      FacCPedi.DNICli = tt-Faccpedi.DNICli.
  /* *************************************************************************************** */
  ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
  /* ********************************************************************************************** */
  /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
  /* ********************************************************************************************** */
  FIND FIRST gn-clied WHERE gn-clied.codcia = cl-codcia
      AND gn-clied.codcli = Faccpedi.codcli
      AND gn-clied.sede = Faccpedi.sede
      NO-LOCK NO-ERROR.
  ASSIGN
      FacCPedi.Ubigeo[1] = FacCPedi.Sede
      FacCPedi.Ubigeo[2] = "@CL"
      FacCPedi.Ubigeo[3] = FacCPedi.CodCli.
  /* ********************************************************************************************** */
  /* TRACKING */
  /* ********************************************************************************************** */
  RUN vtagn/pTracking-04 (s-CodCia,
                    s-CodDiv,
                    Faccpedi.CodDoc,
                    Faccpedi.NroPed,
                    s-User-Id,
                    'GNP',
                    'P',
                    DATETIME(TODAY, MTIME),
                    DATETIME(TODAY, MTIME),
                    Faccpedi.CodDoc,
                    Faccpedi.NroPed,
                    Faccpedi.CodRef,
                    Faccpedi.NroRef).
  /* ********************************************************************************************** */
  /* Division destino */
  /* ********************************************************************************************** */
  FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN Faccpedi.DivDes = Almacen.CodDiv.
  /* ********************************************************************************************** */
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE crea-detalle-pedido W-Win 
PROCEDURE crea-detalle-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pEvento AS CHAR.
  DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* pEvento: CREATE o UPDATE */

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE f-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.

  DEF VAR LocalVerificaStock AS LOG NO-UNDO.

  /* RHC 24/04/2020 Validación VENTA DELIVERY */
  DEF VAR x-VentaDelivery AS LOG NO-UNDO.
  FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND
      FacTabla.Tabla = "GN-DIVI" AND
      FacTabla.Codigo = s-CodDiv AND
      FacTabla.Campo-L[3] = YES   /* Solo pedidos al 100% */
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN x-VentaDelivery = YES.
  ELSE x-VentaDelivery = NO.
       
  DETALLES:
  FOR EACH PEDI EXCLUSIVE-LOCK, 
      FIRST Almmmatg OF PEDI NO-LOCK,
      FIRST Almtfami OF Almmmatg NO-LOCK 
      BY PEDI.NroItm:
      /* RHC 13/06/2020 NO se verifica el stock de productos con Cat. Contab. = "SV" */
      /* el x-articulo-ICBPER es un impuesto clasificado coomo SV (servicio) */
      /* RHC 10/07/2020 NO se verifica el stock de productos Drop Shipping */
      IF Almtfami.Libre_c01 = "SV" THEN NEXT.
      FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
          VtaTabla.Tabla = "DROPSHIPPING" AND
          VtaTabla.Llave_c1 = PEDI.CodMat 
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaTabla THEN NEXT.
      /* **************************************************************************************** */
      /* VERIFICAMOS STOCK DISPONIBLE DE ALMACEN */
      /* **************************************************************************************** */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = PEDI.AlmDes
          AND Almmmate.codmat = PEDI.CodMat
          NO-LOCK NO-ERROR.
      /* RHC 15/03/2021 Decidimos cuándo verificamos el stock */
      LocalVerificaStock = NO.
      IF pEvento = "CREATE" THEN LocalVerificaStock = YES.
      IF pEvento = "UPDATE" THEN DO:
          /* Solo cuando hay una modificación de la cantidad: debe ser mayor a la solicitada anteriormente */
          FIND FIRST x-Facdpedi WHERE x-Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
          IF AVAILABLE x-Facdpedi AND PEDI.CanPed > x-Facdpedi.CanPed THEN LocalVerificaStock = YES.
      END.
      IF LocalVerificaStock = YES THEN DO:
          x-StkAct = 0.
          IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
          RUN gn/stock-comprometido-v2.p (PEDI.CodMat, PEDI.AlmDes, YES, OUTPUT s-StkComprometido).
          /* RHC 29/04/2020 Tener cuidado, las COT también comprometen mercadería */
          FIND FIRST FacTabla WHERE FacTabla.CodCia = COTIZACION.CodCia AND
              FacTabla.Tabla = "GN-DIVI" AND
              FacTabla.Codigo = COTIZACION.CodDiv AND
              FacTabla.Campo-L[2] = YES AND   /* Reserva Stock? */
              FacTabla.Valor[1] > 0           /* Horas de reserva */
              NO-LOCK NO-ERROR.
          IF AVAILABLE FacTabla THEN DO:
              /* Si ha llegado hasta acá es que está dentro de las horas de reserva */
              /* Afectamos lo comprometido: extornamos el comprometido */
              FIND FIRST Facdpedi OF COTIZACION WHERE Facdpedi.codmat = PEDI.codmat NO-LOCK NO-ERROR.
              IF AVAILABLE Facdpedi THEN
                  s-StkComprometido = s-StkComprometido - (Facdpedi.Factor * (Facdpedi.CanPed - Facdpedi.CanAte)).
          END.
          s-StkDis = x-StkAct - s-StkComprometido.
          IF s-StkDis <= 0 THEN DO:
              pMensajeFinal = pMensajeFinal + CHR(10) +
                  'El STOCK esta en CERO para el producto ' + PEDI.codmat + 
                  'en el almacén ' + PEDI.AlmDes + CHR(10).
              /* OJO: NO DESPACHAR */
              /* ******************************** */
              /* Venta Delivery NO DESPACHAR NADA */
              /* ******************************** */
              IF x-VentaDelivery = YES THEN DO:
                  pMensaje = "Venta Delivery".
                  RETURN "ADM-ERROR".
              END.
              /* ******************************** */
              DELETE PEDI.      /* << OJO << */
              NEXT DETALLES.    /* << OJO << */
          END.
          f-Factor = PEDI.Factor.
          x-CanPed = PEDI.CanPed * f-Factor.    /* Unidades de Stock */
          IF s-StkDis < x-CanPed THEN DO:
              /* ******************************** */
              /* Venta Delivery NO DESPACHAR NADA */
              /* ******************************** */
              IF x-VentaDelivery = YES THEN DO:
                  pMensaje = "Venta Delivery".
                  RETURN "ADM-ERROR".
              END.
              /* ******************************** */
              /* Ajustamos de acuerdo a los multiplos */
              PEDI.CanPed = ( s-StkDis - ( s-StkDis MODULO f-Factor ) ) / f-Factor.
              IF PEDI.CanPed <= 0 THEN DO:
                  DELETE PEDI.
                  NEXT DETALLES.
              END.
          END.
          /* EMPAQUE SUPERMERCADOS */
          FIND FIRST supmmatg WHERE supmmatg.codcia = FacCPedi.CodCia
              AND supmmatg.codcli = FacCPedi.CodCli
              AND supmmatg.codmat = PEDI.codmat 
              NO-LOCK NO-ERROR.
          x-CanPed = PEDI.CanPed * f-Factor.    /* Unidades de Stock */
          f-CanPed = PEDI.CanPed.               /* Unidades de Venta */
          IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
              x-CanPed = (TRUNCATE((x-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
              f-CanPed = ((x-CanPed - (x-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
          END.
          ELSE DO:    /* EMPAQUE OTROS */
              IF s-FlgEmpaque = YES THEN DO:
                  CASE TRUE:
                      WHEN s-Tipo-Abastecimiento = "PCO" THEN DO:
                          RUN vtagn/p-cantidad-sugerida-pco.p (PEDI.codmat, 
                                                               x-CanPed, 
                                                               OUTPUT pSugerido, 
                                                               OUTPUT pEmpaque).
                          x-CanPed = pSugerido.
                          f-CanPed = ((x-CanPed - (x-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
                      END.
                      OTHERWISE DO:
                          RUN vtagn/p-cantidad-sugerida.p (s-TpoPed,
                                                           PEDI.codmat, 
                                                           x-CanPed, 
                                                           OUTPUT pSugerido, 
                                                           OUTPUT pEmpaque).
                          x-CanPed = pSugerido.
                          f-CanPed = ((x-CanPed - (x-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
                      END.
                  END CASE.
              END.
          END.
          IF f-CanPed <> PEDI.CanPed THEN DO:
              /* ******************************** */
              /* Venta Delivery NO DESPACHAR NADA */
              /* ******************************** */
              IF x-VentaDelivery = YES THEN DO:
                  pMensaje = "Venta Delivery".
                  RETURN "ADM-ERROR".
              END.
              /* ******************************** */
          END.
          ASSIGN 
              PEDI.CanPed = f-CanPed.
          /* RECALCULAMOS */
          {vta2/calcula-linea-detalle.i &Tabla="PEDI"}
          IF PEDI.CanPed <= 0 THEN DO:
              DELETE PEDI.
          END.
      END.
      /* **************************************************************************************** */
  END.
  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI NO-LOCK, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          EXCEPT PEDI.TipVta    /* Campo con valor A, B, C o D */
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              /* Facdpedi.FlgEst = Faccpedi.FlgEst */ 
              Facdpedi.NroItm = I-NPEDI.

             /* 
                Ic - 23Jun2020, se coordino con Ruben para que no grabe el estado(flgest) 
                en el detalle ya que el storeprocedure lo hace    
             */
  END.
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi THEN DO:
      pMensaje = "NO hay stock suficiente para cubrir el pedido comercial".
      RETURN 'ADM-ERROR'.
  END.
  ELSE RETURN 'OK'.

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
  DISPLAY COMBO-BOX_CodAlm COMBO-NroSer FILL-IN-CodCli FILL-IN-NomCli 
          txtOrdenCompra 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 COMBO-BOX_CodAlm BUTTON-FILTRAR COMBO-NroSer BUTTON-LIMPIAR 
         FILL-IN-CodCli txtOrdenCompra BROWSE-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  VIEW FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fecha-Entrega W-Win 
PROCEDURE Fecha-Entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAMETER pFchEnt    AS DATE.
DEF OUTPUT PARAMETER pMensaje   AS CHAR.

/* LA RUTINA VA A DECIDIR SI EL CALCULO ES POR UBIGEO O POR GPS */
RUN logis/p-fecha-de-entrega (
    FacCPedi.CodDoc,              /* Documento actual */
    FacCPedi.NroPed,
    INPUT-OUTPUT pFchEnt,
    OUTPUT pMensaje).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION W-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
DEFINE VARIABLE s-StkComprometido AS DEC.
DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.

DEF VAR t-AlmDes AS CHAR NO-UNDO.
DEF VAR t-CanPed AS DEC NO-UNDO.
DEFINE VAR pFchEnt AS DATE.

GenerarPedido:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' :
    /* Bloqueamos el correlativo para controlar las actualizaciones multiusuario */
    {lib/lock-genericov3.i
        &Tabla="COTIZACION"
        &Alcance="FIRST"
        &Condicion="COTIZACION.codcia = tt-Faccpedi.codcia ~
        AND COTIZACION.coddiv = tt-Faccpedi.coddiv ~
        AND COTIZACION.coddoc = tt-Faccpedi.coddoc ~
        AND COTIZACION.nroped = tt-Faccpedi.nroped" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    IF COTIZACION.FlgEst <> "P" THEN DO:
        pMensaje = "YA no se encuentra pendiente".
        UNDO, RETURN "ADM-ERROR".
    END.
    /* Cargar el detalle de la cotizacion */
    RUN cargar-detalle-cotizacion (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO hay stock suficente".
        UNDO GenerarPedido, RETURN "ADM-ERROR".
    END.
    /* Cabecera */
    DEF VAR pRowid AS ROWID NO-UNDO.
    RUN crea-cabecera (OUTPUT pRowid, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la cabecera".
        UNDO GenerarPedido, RETURN "ADM-ERROR".
    END.
    /* Detalle del Pedido */
    FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid EXCLUSIVE-LOCK NO-ERROR.
    RUN crea-detalle-pedido (INPUT 'CREATE', OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar el detalle".
        UNDO GenerarPedido, RETURN "ADM-ERROR".
    END.
    /* Grabamos Totales */
    RUN Graba-Totales (OUTPUT pMensaje) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo grabar los totales".
        UNDO GenerarPedido, RETURN 'ADM-ERROR'.
    END.
    /* Actualizamos la cotizacion, enviando el ROWID del pedido */
    RUN vta2/pactualizacotizacion.r ( ROWID(faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo actualizar la cotización".
        UNDO GenerarPedido, RETURN 'ADM-ERROR'.
    END.               
    /* Reactualizamos la Fecha de Entrega */
    pFchEnt = faccpedi.FchEnt.
    pMensaje = ''.
    RUN Fecha-Entrega (INPUT-OUTPUT pFchEnt, OUTPUT pMensaje).
    IF pMensaje > '' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo actualizar la fecha de entrega".
          UNDO GenerarPedido, RETURN 'ADM-ERROR'.
    END.
    ASSIGN faccpedi.FchEnt = pFchEnt.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE graba-totales W-Win 
PROCEDURE graba-totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /*{vta2/graba-totales-cotizacion-cred.i}*/
  /* ****************************************************************************************** */
  /* ****************************************************************************************** */
  {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
  /* ****************************************************************************************** */
  /* Importes SUNAT */
  /* ****************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
  RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                               INPUT Faccpedi.CodDoc,
                               INPUT Faccpedi.NroPed,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN ERROR.
  DELETE PROCEDURE hProc.
  /* ****************************************************************************************** */
  /* ****************************************************************************************** */

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
  COMBO-BOX_CodAlm:DELIMITER IN FRAME {&FRAME-NAME} = '|'.
  COMBO-BOX_CodAlm:DELETE(1).
  FOR EACH VtaAlmDiv NO-LOCK WHERE VtaAlmDiv.CodCia = s-CodCia
      AND VtaAlmDiv.CodDiv = s-CodDiv,
      FIRST Almacen NO-LOCK WHERE Almacen.codcia = VtaAlmDiv.CodCia
          AND Almacen.codalm = VtaAlmDiv.CodAlm 
      BY VtaAlmDiv.Orden DESCENDING:
      COMBO-BOX_CodAlm:ADD-LAST(Almacen.codalm + ' - ' + Almacen.Descripcion, Almacen.codalm).
      COMBO-BOX_CodAlm = Almacen.CodAlm.
  END.
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  FOR EACH FacCorre NO-LOCK WHERE 
      FacCorre.CodCia = s-CodCia AND
      FacCorre.CodDoc = s-CodDoc AND
      FacCorre.CodDiv = s-CodDiv AND
      FacCorre.FlgEst = YES:
      IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
      ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-NroSer:LIST-ITEMS = cListItems.
      COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      s-NroSer = INTEGER(COMBO-NroSer).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR pMensaje AS CHAR NO-UNDO.
DEFINE VAR pMsgFinal AS CHAR NO-UNDO.    
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.NroSer = s-NroSer
    NO-LOCK.
IF FacCorre.FlgEst = NO THEN DO:
    MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

/* Lógica Principal */
SESSION:SET-WAIT-STATE('GENERAL').
PRINCIPAL:
FOR EACH tt-faccpedi NO-LOCK:
    /* Barremos Cotización por Cotización */
    RUN FIRST-TRANSACTION (OUTPUT pMensaje).
    IF pMensaje > '' THEN DO:
        pMsgFinal = pMsgFinal + (IF pMsgFinal > '' THEN CHR(10) ELSE '') + 
                tt-faccpedi.coddoc + ": " + tt-faccpedi.nroped + " ERROR: " + pMensaje.
    END.
END.
SESSION:SET-WAIT-STATE('').
IF pMsgFinal > '' THEN DO:
    MESSAGE pMsgFinal VIEW-AS ALERT-BOX WARNING.
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
  {src/adm/template/snd-list.i "tt-FacCPedi"}

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

