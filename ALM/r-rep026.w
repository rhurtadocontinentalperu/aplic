&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE PikTareas
       FIELD horas AS INT
       FIELD minutos AS INT
       FIELD segundos AS INT
       FIELD ctiempo as CHAR
       FIELD FchPed AS DATE FORMAT '99/99/9999' LABEL 'Fecha Pedido'
       index idx01 is primary nroped codper.



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

DEFINE TEMP-TABLE tt-detalle LIKE detalle
    .

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-Horas AS INT NO-UNDO.
DEF VAR x-Minutos AS INT NO-UNDO.
DEF VAR x-Segundos AS INT NO-UNDO.
DEFINE VAR x-tiempo AS CHAR.

DEFINE VAR x-sort-direccion AS CHAR INIT "".
DEFINE VAR x-sort-column AS CHAR INIT "".

DEFINE TEMP-TABLE tt-excel
    FIELDS  fecha   AS  DATE        COLUMN-LABEL "Fecha"
    FIELDS  codper  AS  CHAR        FORMAT 'x(6)'   COLUMN-LABEL "Codigo"
    FIELDS  patper  AS  CHAR        FORMAT 'x(60)'  COLUMN-LABEL "Apellido Paterno"
    FIELDS  matper  AS  CHAR        FORMAT 'x(60)'  COLUMN-LABEL "Apellido Materno"
    FIELDS  nomper  AS  CHAR        FORMAT 'x(60)'  COLUMN-LABEL "Nombres"
    FIELDS  nroped  AS  CHAR        FORMAT 'x(15)'  COLUMN-LABEL 'Pedido'
    FIELD   fchped  AS  DATE        FORMAT '99/99/9999' COLUMN-LABEL 'Fecha Pedido'
    FIELDS  items   AS  DEC         FORMAT '->>,>>>,>>9'    COLUMN-LABEL "Items"
    FIELDS  peso    AS  DEC         FORMAT '->>,>>>,>>9.9999'   COLUMN-LABEL "Peso en Kgs"
    FIELDS  Volumen AS  DEC         FORMAT '->>,>>>,>>9.9999'   COLUMN-LABEL "Volmen en cm3"
    FIELDS  tiempo AS  CHAR         FORMAT 'x(10)' COLUMN-LABEL "Tiempo (hh:mm:ss)"
    FIELDS  codmon  AS  INT         FORMAT '->>,>>9'    COLUMN-LABEL "Nro SubOrdenes"
    FIELDS  staturno  AS  CHAR         FORMAT 'x(20)'    COLUMN-LABEL "Estado del Turno"
    .

DEF VAR x-FchPed AS DATE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES Detalle PL-PERS

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Detalle.FchInicio Detalle.CodPer ~
PL-PERS.patper PL-PERS.matper PL-PERS.nomper Detalle.FlgEst Detalle.Items ~
Detalle.Peso Detalle.Volumen ctiempo @ x-tiempo Detalle.CodMon ~
Detalle.NroPed Detalle.FchPed @ x-FchPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 Detalle.CodPer 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 Detalle
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 Detalle
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Detalle NO-LOCK, ~
      EACH PL-PERS OF Detalle NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Detalle NO-LOCK, ~
      EACH PL-PERS OF Detalle NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Detalle PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Detalle
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
BUTTON-1 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTiempo W-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Carga Temporal" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Detalle, 
      PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Detalle.FchInicio COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      Detalle.CodPer FORMAT "X(10)":U
      PL-PERS.patper FORMAT "X(40)":U WIDTH 16.86
      PL-PERS.matper FORMAT "X(40)":U WIDTH 17.43
      PL-PERS.nomper FORMAT "X(40)":U WIDTH 22.43
      Detalle.FlgEst COLUMN-LABEL "Estado" FORMAT "x(12)":U WIDTH 13.43
      Detalle.Items FORMAT ">>>,>>9":U WIDTH 4.86
      Detalle.Peso COLUMN-LABEL "Peso en kg" FORMAT "->>>,>>9.99":U
            WIDTH 8
      Detalle.Volumen COLUMN-LABEL "Volumen en m3" FORMAT "->>>,>>9.99":U
            WIDTH 11
      ctiempo @ x-tiempo COLUMN-LABEL "Tiempo!(hh:mm:ss)" WIDTH 7.72
      Detalle.CodMon COLUMN-LABEL "Nro.SubOrdenes" FORMAT ">,>>9":U
            WIDTH 10.72
      Detalle.NroPed COLUMN-LABEL "Pedido" FORMAT "x(15)":U WIDTH 16.29
      Detalle.FchPed @ x-FchPed COLUMN-LABEL "Fecha Pedido" FORMAT "99/99/9999":U
            WIDTH 10.72
  ENABLE
      Detalle.CodPer
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 165 BY 22.35
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1.54 COL 151 WIDGET-ID 12
     FILL-IN-Fecha-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Fecha-2 AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 1.38 COL 51 WIDGET-ID 10
     BROWSE-2 AT ROW 3.15 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 169.14 BY 24.81
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: Detalle T "?" NO-UNDO INTEGRAL PikTareas
      ADDITIONAL-FIELDS:
          FIELD horas AS INT
          FIELD minutos AS INT
          FIELD segundos AS INT
          FIELD ctiempo as CHAR
          FIELD FchPed AS DATE FORMAT '99/99/9999' LABEL 'Fecha Pedido'
          index idx01 is primary nroped codper
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte de Productividad"
         HEIGHT             = 24.81
         WIDTH              = 169.14
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 177.72
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 177.72
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
/* BROWSE-TAB BROWSE-2 BUTTON-1 F-Main */
ASSIGN 
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.Detalle,INTEGRAL.PL-PERS OF Temp-Tables.Detalle"
     _Options          = "NO-LOCK"
     _TblOptList       = ","
     _FldNameList[1]   > Temp-Tables.Detalle.FchInicio
"Temp-Tables.Detalle.FchInicio" "Fecha" "99/99/9999" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.Detalle.CodPer
"Temp-Tables.Detalle.CodPer" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.PL-PERS.patper
"INTEGRAL.PL-PERS.patper" ? ? "character" ? ? ? ? ? ? no ? no no "16.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PL-PERS.matper
"INTEGRAL.PL-PERS.matper" ? ? "character" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.PL-PERS.nomper
"INTEGRAL.PL-PERS.nomper" ? ? "character" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.Detalle.FlgEst
"Temp-Tables.Detalle.FlgEst" "Estado" "x(12)" "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.Detalle.Items
"Temp-Tables.Detalle.Items" ? ? "integer" ? ? ? ? ? ? no ? no no "4.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.Detalle.Peso
"Temp-Tables.Detalle.Peso" "Peso en kg" ? "decimal" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.Detalle.Volumen
"Temp-Tables.Detalle.Volumen" "Volumen en m3" ? "decimal" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"ctiempo @ x-tiempo" "Tiempo!(hh:mm:ss)" ? ? ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.Detalle.CodMon
"Temp-Tables.Detalle.CodMon" "Nro.SubOrdenes" ">,>>9" "integer" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.Detalle.NroPed
"Temp-Tables.Detalle.NroPed" "Pedido" ? "character" ? ? ? ? ? ? no ? no no "16.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"Detalle.FchPed @ x-FchPed" "Fecha Pedido" "99/99/9999" ? ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Productividad */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Productividad */
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
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    hSortColumn = BROWSE BROWSE-2:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    IF CAPS(lColumName) <> CAPS(x-sort-column) THEN DO:
        x-sort-direccion = "".
    END.
    ELSE DO:
        IF x-sort-direccion = "" THEN DO:
            x-sort-direccion = "DESC".
        END.
        ELSE DO:            
            x-sort-direccion = "".
        END.
    END.
    x-sort-column = lColumName.


    hQueryHandle = BROWSE BROWSE-2:QUERY.
    hQueryHandle:QUERY-CLOSE().
    hQueryHandle:QUERY-PREPARE("FOR EACH Detalle NO-LOCK, EACH INTEGRAL.PL-PERS OF Detalle NO-LOCK BY " + lColumName + " " + x-sort-direccion).
    hQueryHandle:QUERY-OPEN().

/*
EACH Temp-Tables.Detalle NO-LOCK,
      EACH INTEGRAL.PL-PERS OF Temp-Tables.Detalle NO-LOCK INDEXED-REPOSITION
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Carga Temporal */
DO:
   ASSIGN FILL-IN-Fecha-1 FILL-IN-Fecha-2.
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Carga-Temporal.
   {&OPEN-QUERY-{&BROWSE-NAME}}
   SESSION:SET-WAIT-STATE('').
   MESSAGE 'Listo' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Excel */
DO:

    DEFINE VAR x-archivo    AS CHAR.
    DEFINE VAR rpta         AS LOG.

        SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'Excel (*.xlsx)' '*.xlsx'
            ASK-OVERWRITE
            CREATE-TEST-FILE
            DEFAULT-EXTENSION '.xlsx'
            RETURN-TO-START-DIR
            SAVE-AS
            TITLE 'Exportar a Excel'
            UPDATE rpta.
        IF rpta = NO OR x-Archivo = '' THEN RETURN.

    SESSION:SET-WAIT-STATE('GENERAL').
  
    EMPTY TEMP-TABLE tt-excel.

    CREATE tt-excel.
    ASSIGN  tt-excel.patper     = "Fecha de Proceso"
            tt-excel.matper     = "Desde :" + STRING(FILL-IN-fecha-1,"99-99-9999")
            tt-excel.nomper     = "Hasta :" + STRING(FILL-IN-fecha-2,"99-99-9999").


    GET FIRST BROWSE-2.
    DO  WHILE AVAILABLE detalle:
        CREATE tt-excel.
        ASSIGN  tt-excel.fecha      = detalle.fchinicio
                tt-excel.codper     = detalle.codper
                tt-excel.patper     = pl-pers.patper
                tt-excel.matper     = pl-pers.matper
                tt-excel.nomper     = pl-pers.nomper
                tt-excel.items      = detalle.items
                tt-excel.peso       = detalle.peso
                tt-excel.volumen    = detalle.volumen
                /*tt-excel.importe    = detalle.importe*/
                tt-excel.tiempo     = detalle.ctiempo
                tt-excel.codmon     = detalle.codmon
                tt-excel.staturno   = detalle.flgest.
        ASSIGN
            tt-excel.nroped = Detalle.nroped
            tt-excel.fchped = Detalle.fchped.

        GET NEXT BROWSE-2.
    END.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */

    c-xls-file = x-archivo.

    run pi-crea-archivo-csv IN hProc (input  buffer tt-excel:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                            input  c-csv-file,
                            output c-xls-file) .

    DELETE PROCEDURE hProc.

    SESSION:SET-WAIT-STATE('').

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.


/*
DEFINE TEMP-TABLE tt-excel
    FIELDS  codper  AS  CHAR        FORMAT 'x(6)'   COLUMN-LABEL "Codigo"
    FIELDS  patper  AS  CHAR        FORMAT 'x(60)'  COLUMN-LABEL "Apellido Paterno"
    FIELDS  matper  AS  CHAR        FORMAT 'x(60)'  COLUMN-LABEL "Apellido Materno"
    FIELDS  nomper  AS  CHAR        FORMAT 'x(60)'  COLUMN-LABEL "Nombres"
    FIELDS  items   AS  DEC         FORMAT '->>,>>>,>>9'    COLUMN-LABEL "Items"
    FIELDS  peso    AS  DEC         FORMAT '->>,>>>,>>9.9999'   COLUMN-LABEL "Peso en Kgs"
    FIELDS  Volumen AS  DEC         FORMAT '->>,>>>,>>9.9999'   COLUMN-LABEL "Volmen en cm3"
    FIELDS  importe AS  DEC         FORMAT '->>,>>9.99' COLUMN-LABEL "Horas"
    FIELDS  codmon  AS  INT         FORMAT '->>,>>9'    COLUMN-LABEL "Nro SubOrdenes".

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ASSIGN detalle.codper:READ-ONLY IN BROWSE BROWSE-2 = TRUE.

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
PROCEDURE Carga-Temporal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR Ts AS INT NO-UNDO.
DEF VAR Tm AS INT NO-UNDO.
DEF VAR Th AS INT NO-UNDO.
DEF VAR Td AS INT NO-UNDO.

DEFINE VAR x-qsubordenes AS INT.
DEFINE VAR x-fecha AS CHAR.

EMPTY TEMP-TABLE Detalle.

FOR EACH PikSacadores NO-LOCK WHERE PikSacadores.CodCia = s-codcia
    AND PikSacadores.CodDiv = s-coddiv
    /*AND PikSacadores.FlgEst = "C"*/
    AND DATE(PikSacadores.Fecha) >= FILL-IN-Fecha-1 
    AND DATE(PikSacadores.Fecha) <= FILL-IN-Fecha-2
    BREAK BY PikSacadores.CodPer:
    IF FIRST-OF(PikSacadores.CodPer) THEN DO:
        /*
        CREATE Detalle.
        ASSIGN
            Detalle.codper     = PikSacadores.CodPer
            detalle.codmon     = 0 .
        */
    END.
    FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = PikSacadores.CodCia
        AND VtaCDocu.DivDes = PikSacadores.CodDiv
        AND VtaCDocu.UsrSac = PikSacadores.CodPer
        AND (VtaCDocu.FchInicio >= PikSacadores.Fecha AND VtaCDocu.FchInicio <= PikSacadores.FchCierre)
        AND VtaCDocu.FchFin <> ? AND LOOKUP(vtacdocu.codped,"ODC,OTC,OMC") = 0 :

        x-fecha = STRING(VtaCDocu.FchInicio,"99/99/9999").

        FIND FIRST detalle WHERE detalle.nroped = x-fecha AND 
                                detalle.codper = PikSacadores.CodPer NO-ERROR.
        IF NOT AVAILABLE detalle THEN DO:
            CREATE Detalle.
            ASSIGN
                detalle.nroped     = x-fecha
                detalle.fchinicio  = VtaCDocu.FchInicio
                Detalle.codper     = PikSacadores.CodPer
                detalle.codmon     = 0 
                detalle.flgest     = if(PikSacadores.FlgEst = 'C') THEN 'CERRADO' ELSE 'SIN CERRAR'.

        END.

        ASSIGN
            Detalle.Items   = Detalle.Items   + VtaCDocu.Items
            Detalle.Peso    = Detalle.Peso    + IF (VtaCDocu.Peso = ?) THEN 0 ELSE VtaCDocu.Peso
            Detalle.Volumen = Detalle.Volumen + VtaCDocu.Volumen.
        Ts = ( VtaCDocu.FchFin - VtaCDocu.FchInicio ) / 1000.         /* En segundos */
        Td = TRUNCATE(Ts / 86400, 0).                   /* En dias */
        Ts = Ts - ( Td * 86400 ).                       /* Segundos remanentes */
        Th = TRUNCATE(Ts / 3600, 0).                    /* En horas */
        Ts = Ts - ( Th * 3600 ).                        /* Segundos remanentes */
        Tm = TRUNCATE(Ts / 60, 0).                      /* En minutos */
        Ts = Ts - ( Tm * 60 ).                          /* Segundos remanentes */
        ASSIGN
            Detalle.Horas = Detalle.Horas + Th + (24 * Td)
            Detalle.Minutos = Detalle.Minutos + Tm
            Detalle.Segundos = Detalle.Segundos + Ts
            detalle.codmon = detalle.codmon + 1.

        /* 06/11/2024 Susana León: datos de la O/D u OTR */
        ASSIGN
            Detalle.NroPed = Vtacdocu.codped + " " + Vtacdocu.nroped
            Detalle.FchPed = Vtacdocu.fchped.

    END.
END.

DEFINE VAR xTiempo AS CHAR.

FOR EACH Detalle:
    IF Detalle.Segundos > 60 THEN DO:
        Tm = TRUNCATE(Detalle.Segundos / 60, 0).
        Detalle.Minutos = Detalle.Minutos + Tm.
        Detalle.Segundos = Detalle.Segundos - (Tm * 60).
    END.
    IF Detalle.Minutos > 60 THEN DO:
        Th = TRUNCATE(Detalle.Minutos / 60, 0).
        Detalle.Horas = Detalle.Horas + Th.
        Detalle.Minutos = Detalle.Minutos - (Th * 60).
    END.
    xTiempo = STRING(Detalle.Horas,"99") + ":" + STRING(Detalle.minutos,"99") + ":" + STRING(Detalle.segundos,"99").
    ASSIGN detalle.ctiempo = xtiempo.

    /* Fraccion de Hora */
    /*detalle.importe = Detalle.Horas + (Detalle.Minutos / 60).*/
    /*detalle.importe = Detalle.Horas + (Detalle.Minutos / 100).*/

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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 FILL-IN-Fecha-1 FILL-IN-Fecha-2 BUTTON-1 BROWSE-2 
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
      FILL-IN-Fecha-1 = ADD-INTERVAL(TODAY,-30,'days')
      FILL-IN-Fecha-2 = TODAY.

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
  {src/adm/template/snd-list.i "Detalle"}
  {src/adm/template/snd-list.i "PL-PERS"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTiempo W-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-Tiempo AS CHAR.
  IF AVAILABLE VtaCDocu 
  THEN DO: 
      IF VtaCDocu.FchFin <> ? THEN RUN lib/_time-passed (VtaCDocu.FchInicio, VtaCDocu.FchFin, OUTPUT x-Tiempo).
      ELSE RUN lib/_time-passed (VtaCDocu.FchInicio, DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).
  END.
  ELSE x-Tiempo = "".   /* Function return value. */
  RETURN x-Tiempo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

