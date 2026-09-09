&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE TEMP-TABLE Cabecera-FAC NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE Cabecera-FAI NO-UNDO LIKE CcbCDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE CcbDDocu
       FIELD CodMon LIKE Ccbcdocu.CodMon
       FIELD TpoCmb LIKE Ccbcdocu.TpoCmb.
DEFINE BUFFER GUIA FOR CcbCDocu.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE TEMP-TABLE T-ORIGEN NO-UNDO LIKE FacCPedi.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodDoc AS CHAR INIT 'COT' NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VAR x-faltan-guias AS LOG.
DEFINE VAR x-guias-no-entregados AS LOG.

/* Control de InvoiceCustomerGroup */
DEF TEMP-TABLE T-INVOICE
    FIELD InvoiceCustomerGroup LIKE Faccpedi.InvoiceCustomerGroup
    FIELD DeliveryGroup LIKE Faccpedi.DeliveryGroup
    FIELD CodCli LIKE Faccpedi.CodCli.

DEF TEMP-TABLE T-CLIENTE
    FIELD CodCli LIKE Faccpedi.CodCli
    FIELD nomCli LIKE Faccpedi.nomCli.

DEFINE VAR x-Grupo AS CHAR NO-UNDO.
DEFINE VAR x-NroSer AS INT NO-UNDO.

DEF TEMP-TABLE T-PECOS 
    FIELD DeliveryGroup LIKE FacCPedi.DeliveryGroup
    FIELD ordcmp LIKE FacCPedi.ordcmp
    FIELD OfficeCustomer LIKE FacCPedi.OfficeCustomer
    FIELD codmat LIKE FacDPedi.codmat
    .

DEF VAR x-agrupador AS CHAR NO-UNDO.

/*
20100047218 - BCP
20382036655 - MIBANCO
*/
DEF VAR x-Clientes AS CHAR INIT '20382036655,20100047218' NO-UNDO.

&SCOPED-DEFINE Condicion ( ~
    COTIZACION.codcia = s-codcia AND ~
    COTIZACION.codcli = COMBO-BOX-Clientes AND ~
    COTIZACION.coddoc = s-coddoc AND ~
    COTIZACION.fchped >= FILL-IN-FchSal-1 AND ~
    COTIZACION.fchped <= FILL-IN-FchSal-2 AND ~
    COTIZACION.coddiv = s-coddiv AND ~
    COTIZACION.flgest = 'P' AND ~
    (x-Agrupador = 'Sin Grupo' OR COTIZACION.DeliveryGroup = x-Agrupador) AND ~
    NOT CAN-FIND(FIRST Facdpedi OF COTIZACION WHERE Facdpedi.CanAte > 0 NO-LOCK) ~
    )


&SCOPED-DEFINE Condicion2 ( ~
    COTIZACION.codcia = s-codcia AND ~
    COTIZACION.codcli = COMBO-BOX-Clientes AND ~
    COTIZACION.coddoc = s-coddoc AND ~
    COTIZACION.fchped >= FILL-IN-FchSal-1 AND ~
    COTIZACION.fchped <= FILL-IN-FchSal-2 AND ~
    COTIZACION.coddiv = s-coddiv AND ~
    COTIZACION.flgest = 'P' AND ~
    ( ( x-Agrupador = 'Sin Grupo' AND TRUE <> (COTIZACION.DeliveryGroup > '') ) OR ~
        ( x-Agrupador <> 'Sin Grupo' AND COTIZACION.DeliveryGroup = x-Agrupador ) ) AND ~
    NOT CAN-FIND(FIRST Facdpedi OF COTIZACION WHERE Facdpedi.CanAte > 0 NO-LOCK) ~
    )

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-ORIGEN

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-ORIGEN

/* Definitions for BROWSE BROWSE-ORIGEN                                 */
&Scoped-define FIELDS-IN-QUERY-BROWSE-ORIGEN T-ORIGEN.CodDoc ~
T-ORIGEN.NroPed T-ORIGEN.ordcmp T-ORIGEN.FchPed T-ORIGEN.CodCli ~
T-ORIGEN.NomCli T-ORIGEN.Sede T-ORIGEN.DeliveryGroup T-ORIGEN.Region1Name ~
T-ORIGEN.Region2Name T-ORIGEN.Region3Name T-ORIGEN.DeliveryAddress 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-ORIGEN 
&Scoped-define QUERY-STRING-BROWSE-ORIGEN FOR EACH T-ORIGEN NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-ORIGEN OPEN QUERY BROWSE-ORIGEN FOR EACH T-ORIGEN NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-ORIGEN T-ORIGEN
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-ORIGEN T-ORIGEN


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-ORIGEN}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-ORIGEN FILL-IN-Sede ~
COMBO-BOX-Clientes FILL-IN-FchSal-1 FILL-IN-FchSal-2 BUTTON-Filtrar Btn_OK ~
BtnDone COMBO-BOX-grupo BUTTON-12 RECT-2 RECT-3 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-LugEnt FILL-IN-Sede ~
COMBO-BOX-Clientes FILL-IN-FchSal-1 FILL-IN-FchSal-2 FILL-IN-Division ~
COMBO-BOX-grupo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCentrar W-Win 
FUNCTION fCentrar RETURNS CHARACTER
  ( INPUT pParam AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     IMAGE-INSENSITIVE FILE "adeicon\unprog.ico":U
     LABEL "&Aceptar" 
     SIZE 12 BY 1.54.

DEFINE BUTTON BUTTON-12 
     LABEL "Refrescar Clientes" 
     SIZE 14 BY 1.08.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTROS" 
     SIZE 20 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Clientes AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un cliente" 
     LABEL "Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Seleccione un cliente","Seleccione un cliente"
     DROP-DOWN-LIST
     SIZE 69 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-grupo AS CHARACTER FORMAT "X(25)":U 
     LABEL "Grupo de Reparto" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1
     FONT 10 NO-UNDO.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1
     BGCOLOR 6 FGCOLOR 15 FONT 10 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchSal-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha emision - Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchSal-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-LugEnt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Sede AS CHARACTER FORMAT "X(8)":U 
     LABEL "Lugar de entrega" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 174 BY 1.92
     BGCOLOR 6 FGCOLOR 15 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 147 BY 3.5
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 174 BY 1.35
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 27 BY 3.5
     BGCOLOR 14 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-ORIGEN FOR 
      T-ORIGEN SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-ORIGEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-ORIGEN W-Win _STRUCTURED
  QUERY BROWSE-ORIGEN NO-LOCK DISPLAY
      T-ORIGEN.CodDoc COLUMN-LABEL "Cod." FORMAT "x(3)":U
      T-ORIGEN.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
      T-ORIGEN.ordcmp FORMAT "X(12)":U WIDTH 9.57
      T-ORIGEN.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      T-ORIGEN.CodCli COLUMN-LABEL "Codigo Cliente" FORMAT "x(11)":U
            WIDTH 11.72
      T-ORIGEN.NomCli FORMAT "x(100)":U WIDTH 39.43
      T-ORIGEN.Sede FORMAT "x(5)":U
      T-ORIGEN.DeliveryGroup FORMAT "x(10)":U
      T-ORIGEN.Region1Name FORMAT "x(10)":U WIDTH 11.43
      T-ORIGEN.Region2Name FORMAT "x(10)":U WIDTH 11.43
      T-ORIGEN.Region3Name FORMAT "x(10)":U WIDTH 11.43
      T-ORIGEN.DeliveryAddress FORMAT "x(80)":U WIDTH 80
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 174 BY 17.77
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-ORIGEN AT ROW 7.73 COL 2 WIDGET-ID 200
     FILL-IN-LugEnt AT ROW 6.65 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     FILL-IN-Sede AT ROW 6.65 COL 20 COLON-ALIGNED WIDGET-ID 68
     COMBO-BOX-Clientes AT ROW 4.23 COL 20 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-FchSal-1 AT ROW 3.15 COL 20 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-FchSal-2 AT ROW 3.15 COL 38.43 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-Division AT ROW 1.54 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-Filtrar AT ROW 4.23 COL 128 WIDGET-ID 38
     Btn_OK AT ROW 3.96 COL 151 WIDGET-ID 32
     BtnDone AT ROW 3.96 COL 163 WIDGET-ID 34
     COMBO-BOX-grupo AT ROW 5.31 COL 20 COLON-ALIGNED WIDGET-ID 58
     BUTTON-12 AT ROW 4.23 COL 92 WIDGET-ID 60
     "(1)" VIEW-AS TEXT
          SIZE 4 BY .81 AT ROW 3.15 COL 54 WIDGET-ID 72
          BGCOLOR 15 FGCOLOR 12 FONT 8
     "(2)" VIEW-AS TEXT
          SIZE 4 BY .81 AT ROW 4.23 COL 107 WIDGET-ID 76
          BGCOLOR 15 FGCOLOR 12 FONT 8
     "(3)" VIEW-AS TEXT
          SIZE 4 BY .81 AT ROW 4.23 COL 11 WIDGET-ID 78
          BGCOLOR 15 FGCOLOR 12 FONT 8
     "(4)" VIEW-AS TEXT
          SIZE 4 BY .81 AT ROW 5.31 COL 39 WIDGET-ID 80
          BGCOLOR 15 FGCOLOR 12 FONT 8
     "(5)" VIEW-AS TEXT
          SIZE 4 BY .81 AT ROW 5.31 COL 135 WIDGET-ID 82
          BGCOLOR 15 FGCOLOR 12 FONT 8
     "(6)" VIEW-AS TEXT
          SIZE 4 BY .81 AT ROW 6.65 COL 5 WIDGET-ID 84
          BGCOLOR 8 FGCOLOR 12 FONT 8
     "(7)" VIEW-AS TEXT
          SIZE 4 BY .81 AT ROW 3.15 COL 160 WIDGET-ID 86
          BGCOLOR 14 FGCOLOR 12 FONT 8
     RECT-2 AT ROW 1 COL 2 WIDGET-ID 10
     RECT-3 AT ROW 2.88 COL 2 WIDGET-ID 46
     RECT-4 AT ROW 6.38 COL 2 WIDGET-ID 66
     RECT-5 AT ROW 2.88 COL 149 WIDGET-ID 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 176.14 BY 25.04
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: Cabecera-FAC T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: Cabecera-FAI T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: Detalle T "?" NO-UNDO INTEGRAL CcbDDocu
      ADDITIONAL-FIELDS:
          FIELD CodMon LIKE Ccbcdocu.CodMon
          FIELD TpoCmb LIKE Ccbcdocu.TpoCmb
      END-FIELDS.
      TABLE: GUIA B "?" ? INTEGRAL CcbCDocu
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: T-ORIGEN T "?" NO-UNDO INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ACTUALIZACION DEL LUGAR DE ENTREGA x GRUPO DE REPARTO"
         HEIGHT             = 25.04
         WIDTH              = 176.14
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-ORIGEN 1 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-LugEnt IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-ORIGEN
/* Query rebuild information for BROWSE BROWSE-ORIGEN
     _TblList          = "Temp-Tables.T-ORIGEN"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST, FIRST, FIRST OUTER"
     _FldNameList[1]   > Temp-Tables.T-ORIGEN.CodDoc
"CodDoc" "Cod." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-ORIGEN.NroPed
"NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-ORIGEN.ordcmp
"ordcmp" ? ? "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-ORIGEN.FchPed
"FchPed" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-ORIGEN.CodCli
"CodCli" "Codigo Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-ORIGEN.NomCli
"NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "39.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.T-ORIGEN.Sede
     _FldNameList[8]   = Temp-Tables.T-ORIGEN.DeliveryGroup
     _FldNameList[9]   > Temp-Tables.T-ORIGEN.Region1Name
"Region1Name" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-ORIGEN.Region2Name
"Region2Name" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-ORIGEN.Region3Name
"Region3Name" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-ORIGEN.DeliveryAddress
"DeliveryAddress" ? "x(80)" "character" ? ? ? ? ? ? no ? no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-ORIGEN */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ACTUALIZACION DEL LUGAR DE ENTREGA x GRUPO DE REPARTO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ACTUALIZACION DEL LUGAR DE ENTREGA x GRUPO DE REPARTO */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN
        COMBO-BOX-Clientes combo-box-grupo.
    ASSIGN
        FILL-IN-Sede.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = COMBO-BOX-Clientes
        AND gn-clied.sede = FILL-IN-Sede NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clied THEN DO:
        MESSAGE 'El Lugar de Entrega NO existe para este cliente' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FILL-IN-Sede.
        RETURN NO-APPLY.
    END.

    MESSAGE "Se va aproceder a actualizar el lugar de entrega" SKIP 
        "¿Todos los datos son correctos?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta-2 AS LOGICAL.
    IF rpta-2 <> TRUE THEN RETURN NO-APPLY.

    /* UN SOLO PROCESO */
    pMensaje = "".
    SESSION:SET-WAIT-STATE('GENERAL').
    FOR EACH T-ORIGEN NO-LOCK ON ERROR UNDO, NEXT ON STOP UNDO, NEXT:
        FIND Faccpedi WHERE FacCPedi.CodCia = T-ORIGEN.codcia AND
            FacCPedi.CodDiv = T-ORIGEN.coddiv AND
            FacCPedi.CodDoc = T-ORIGEN.coddoc AND 
            FacCPedi.NroPed = T-ORIGEN.nroped
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE Faccpedi THEN DO:
            /* LOG */
            RUN lib/logtabla (INPUT 'FACCPEDI',
                              INPUT 'CodCia: ' + STRING(faccpedi.codcia) + '|' +
                              'CodDiv: ' + faccpedi.coddiv + '|' +
                              'CodDoc: ' + faccpedi.coddoc + '|' +
                              'NroPed: ' + faccpedi.nroped + '|' +
                              'Sede: ' + faccpedi.sede,    /* OJO: el valor antes de modificarlo */
                              'UPDATE_SEDE').
            /* Ahora sí grabamos */
            ASSIGN 
                Faccpedi.sede = FILL-IN-Sede.
            FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                AND gn-clied.codcli = Faccpedi.codcli
                AND gn-clied.sede = Faccpedi.sede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied AND Gn-ClieD.Codpos > '' THEN FacCPedi.CodPos = Gn-ClieD.Codpos.
            RELEASE Faccpedi.
        END.
    END.
    SESSION:SET-WAIT-STATE('').

    COMBO-BOX-Clientes = "Seleccione un cliente".
    DISPLAY COMBO-BOX-Clientes WITH FRAME {&FRAME-NAME}.
    APPLY 'VALUE-CHANGED':U TO COMBO-BOX-Clientes.
    EMPTY TEMP-TABLE T-ORIGEN.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    /*APPLY 'CHOOSE':U TO BUTTON-Filtrar.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Refrescar Clientes */
DO:
    ASSIGN fill-in-FchSal-1 fill-in-FchSal-2 .

    IF fill-in-FchSal-1 = ? OR fill-in-FchSal-2 = ? THEN DO:
        MESSAGE "Ingrese rango de fechas correctamente".
        RETURN NO-APPLY.
    END.
    IF fill-in-FchSal-1 > fill-in-FchSal-2 THEN DO:
        MESSAGE "El rango de fechas es incorrecto".
        RETURN NO-APPLY.
    END.

    RUN refresca-parametros.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTROS */
DO:
    ASSIGN COMBO-BOX-Clientes 
        FILL-IN-FchSal-1 FILL-IN-FchSal-2 combo-box-grupo .

    IF FILL-IN-FchSal-1 = ? OR FILL-IN-FchSal-2 = ? THEN DO:
        MESSAGE 'No ha ingresado todos los rangos de fecha' SKIP
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF COMBO-BOX-Clientes = "Seleccione un cliente" THEN DO:
        MESSAGE 'Seleccione Cliente por favor!!!!' SKIP
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    RUN Carga-Temporal ( INPUT COMBO-BOX-Clientes /* CHARACTER */,
      INPUT FILL-IN-FchSal-1 /* DATE */,
      INPUT FILL-IN-FchSal-2 /* DATE */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Clientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Clientes W-Win
ON VALUE-CHANGED OF COMBO-BOX-Clientes IN FRAME F-Main /* Cliente */
DO:
    ASSIGN COMBO-BOX-Clientes .

    /* Grupo de Reparto */
    REPEAT WHILE COMBO-BOX-grupo:NUM-ITEMS > 0:
        COMBO-BOX-grupo:DELETE(1).
    END.

    COMBO-BOX-grupo:SCREEN-VALUE = "".
    FOR EACH T-INVOICE NO-LOCK WHERE T-INVOICE.codcli = COMBO-BOX-Clientes:
        combo-box-grupo:ADD-LAST(TRIM(T-INVOICE.DeliveryGroup)).
    END.
    FILL-IN-LugEnt:SCREEN-VALUE = ''.
    FILL-IN-Sede:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-grupo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-grupo W-Win
ON VALUE-CHANGED OF COMBO-BOX-grupo IN FRAME F-Main /* Grupo de Reparto */
DO:
    EMPTY TEMP-TABLE T-ORIGEN.
  
    {&OPEN-QUERY-BROWSE-ORIGEN}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchSal-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchSal-1 W-Win
ON LEAVE OF FILL-IN-FchSal-1 IN FRAME F-Main /* Fecha emision - Desde */
DO:
  ASSIGN {&self-name}.
  IF {&self-name} < (TODAY - 30) THEN DO:
      MESSAGE 'NO retroceder mas de 30 días' VIEW-AS ALERT-BOX WARNING.
  END.
/*   IF {&self-name} < (TODAY - 30) THEN DO:                                   */
/*       MESSAGE 'NO puede retroceder mas de 30 días' VIEW-AS ALERT-BOX ERROR. */
/*       RETURN NO-APPLY.                                                      */
/*   END.                                                                      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchSal-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchSal-2 W-Win
ON LEAVE OF FILL-IN-FchSal-2 IN FRAME F-Main /* Hasta */
DO:
    ASSIGN {&self-name}.
    IF {&self-name} < (TODAY - 30) THEN DO:
        MESSAGE 'NO retroceder mas de 30 días' VIEW-AS ALERT-BOX WARNING.
    END.
/*     IF {&self-name} < (TODAY - 30) THEN DO:                                   */
/*         MESSAGE 'NO puede retroceder mas de 30 días' VIEW-AS ALERT-BOX ERROR. */
/*         RETURN NO-APPLY.                                                      */
/*     END.                                                                      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Sede
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Sede W-Win
ON LEAVE OF FILL-IN-Sede IN FRAME F-Main /* Lugar de entrega */
DO:
  FIND gn-clied WHERE gn-clied.codcia = cl-codcia
      AND gn-clied.codcli = COMBO-BOX-Clientes:SCREEN-VALUE
      AND gn-clied.sede = FILL-IN-Sede:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clied THEN FILL-IN-LugEnt:SCREEN-VALUE = Gn-ClieD.DirCli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Sede W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-Sede IN FRAME F-Main /* Lugar de entrega */
OR F8 OF FILL-IN-SEDE DO:
  ASSIGN
      input-var-1 = COMBO-BOX-Clientes:SCREEN-VALUE
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  RUN lkup/c-gn-clied-todo ('Sedes').
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
      FILL-IN-LugEnt:SCREEN-VALUE = output-var-3.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-ORIGEN
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

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pFchSal-1 AS DATE.
DEF INPUT PARAMETER pFchSal-2 AS DATE.

DEF VAR x-Orden AS INT NO-UNDO.
DEF VAR x-guia AS CHAR NO-UNDO.
DEF VAR x-entregado AS CHAR NO-UNDO.

EMPTY TEMP-TABLE T-ORIGEN.

/* Barremos todas las H/R cerradas y ese rango de fecha de salida */
SESSION:SET-WAIT-STATE('GENERAL').
x-Orden = 0.
x-faltan-guias = NO.
x-guias-no-entregados = NO.

/*DEFINE VAR x-Agrupador AS CHAR INIT "".*/

/*  */
FIND FIRST T-INVOICE WHERE T-INVOICE.DeliveryGroup = combo-box-grupo NO-LOCK NO-ERROR.
IF AVAILABLE T-INVOICE THEN x-Agrupador = T-INVOICE.DeliveryGroup.

FOR EACH COTIZACION NO-LOCK WHERE {&Condicion2}:
    CREATE T-ORIGEN.
    BUFFER-COPY COTIZACION TO T-ORIGEN NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DELETE T-ORIGEN.
END.

SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-BROWSE-ORIGEN}

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
  DISPLAY FILL-IN-LugEnt FILL-IN-Sede COMBO-BOX-Clientes FILL-IN-FchSal-1 
          FILL-IN-FchSal-2 FILL-IN-Division COMBO-BOX-grupo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-ORIGEN FILL-IN-Sede COMBO-BOX-Clientes FILL-IN-FchSal-1 
         FILL-IN-FchSal-2 BUTTON-Filtrar Btn_OK BtnDone COMBO-BOX-grupo 
         BUTTON-12 RECT-2 RECT-3 RECT-4 RECT-5 
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
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      RUN src/bin/_dateif(INPUT MONTH(TODAY),
                          INPUT YEAR(TODAY),
                          OUTPUT FILL-IN-FchSal-1,
                          OUTPUT FILL-IN-FchSal-2).
      FIND gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = s-coddiv
          NO-LOCK.
      FILL-IN-Division = "DIVISIÓN: " + gn-divi.coddiv + " " + GN-DIVI.DesDiv.
      COMBO-BOX-Clientes:DELIMITER = '|'.

      /*RUN refresca-parametros.*/

  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresca-parametros W-Win 
PROCEDURE refresca-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-CodCli AS CHAR NO-UNDO.
    DEF VAR k AS INTE NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL").

    /* Los Clientes, Ordenado por Cliente y Grupo de Reparto Cliente BCP */
    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN fill-in-FchSal-1 fill-in-FchSal-2.

        /* Grupo de Reparto */
        REPEAT WHILE COMBO-BOX-grupo:NUM-ITEMS > 0:
            COMBO-BOX-grupo:DELETE(1).
        END.
        COMBO-BOX-grupo:SCREEN-VALUE = "".

        EMPTY TEMP-TABLE T-INVOICE.

        /* InvoiceCustomerGroup: Código Agrupador OO */
        x-Agrupador = 'Sin Grupo'.
        FIND FIRST T-INVOICE WHERE T-INVOICE.DeliveryGroup = combo-box-grupo NO-LOCK NO-ERROR.
        IF AVAILABLE T-INVOICE THEN x-Agrupador = T-INVOICE.DeliveryGroup.

        DO k = 1 TO NUM-ENTRIES(x-Clientes):
            COMBO-BOX-clientes = ENTRY(k, x-Clientes).
            FOR EACH COTIZACION NO-LOCK WHERE {&Condicion}:
                FIND FIRST T-INVOICE WHERE T-INVOICE.codcli = COTIZACION.codcli AND
                    T-INVOICE.DeliveryGroup = (IF COTIZACION.DeliveryGroup > '' THEN COTIZACION.DeliveryGroup ELSE 'Sin Grupo')
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE T-INVOICE THEN DO:
                    CREATE T-INVOICE.
                    ASSIGN 
                        T-INVOICE.codcli =  COTIZACION.codcli
                        T-INVOICE.DeliveryGroup = (IF COTIZACION.DeliveryGroup > '' THEN COTIZACION.DeliveryGroup ELSE 'Sin Grupo').
                END.                                                       
                FIND FIRST T-CLIENTE WHERE T-CLIENTE.codcli = COTIZACION.codcli EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE T-CLIENTE THEN DO:
                    CREATE T-CLIENTE.
                        ASSIGN 
                            T-CLIENTE.codcli = COTIZACION.codcli
                            T-CLIENTE.nomcli =  COTIZACION.nomcli.

                END.
            END.
        END.
        /* Clientes */
        REPEAT WHILE COMBO-BOX-clientes:NUM-ITEMS > 0:
            COMBO-BOX-clientes:DELETE(1).
        END.
        COMBO-BOX-Clientes:ADD-LAST("Seleccione un cliente","Seleccione un cliente").
        COMBO-BOX-clientes:SCREEN-VALUE = "Seleccione un cliente".
    END.
    SESSION:SET-WAIT-STATE("").

    /**/
    FOR EACH T-CLIENTE NO-LOCK:
        COMBO-BOX-Clientes:ADD-LAST( T-CLIENTE.codcli + ' ' + T-CLIENTE.nomcli , T-CLIENTE.codcli ).
    END.

    EMPTY TEMP-TABLE T-ORIGEN.

    {&OPEN-QUERY-BROWSE-ORIGEN}

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
  {src/adm/template/snd-list.i "T-ORIGEN"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCentrar W-Win 
FUNCTION fCentrar RETURNS CHARACTER
  ( INPUT pParam AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR x-Var AS CHAR NO-UNDO.
RUN src/bin/_centrar (pParam, 10, OUTPUT x-Var).

  RETURN x-Var.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

