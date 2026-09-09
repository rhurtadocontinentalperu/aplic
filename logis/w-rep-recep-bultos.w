&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-report NO-UNDO LIKE w-report.



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

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD NomCli AS CHAR FORMAT 'x(100)' LABEL 'NOMBRE DEL CLIENTE'
    FIELD HPK AS CHAR FORMAT 'x(15)' LABEL 'HPK'
    FIELD OD_OTR AS CHAR FORMAT 'x(15)' LABEL 'OD / OTR'
    FIELD Fecha AS DATE FORMAT '99/99/9999' LABEL 'FECHA'
    FIELD Hora AS CHAR FORMAT 'x(8)' LABEL 'HORA'
    FIELD Zona AS CHAR FORMAT 'x(15)' LABEL 'ZONA'
    FIELD Origen AS CHAR FORMAT 'x(40)' LABEL 'ORIGEN'
    FIELD Peso AS DECI DECIMALS 4 FORMAT '>>>,>>9.9999' LABEL 'PESO (kg)'
    FIELD Volumen AS DECI DECIMALS 4 FORMAT '>>>,>>9.9999' LABEL 'VOLUMEN (m3)'
    FIELD Usuario AS CHAR FORMAT 'x(15)' LABEL 'USUARIO'
    FIELD Almacen AS CHAR FORMAT 'x(40)' LABEL 'ALMACEN DE ORIGEN'
    FIELD Bultos AS INTE FORMAT '>>9' LABEL 'BULTOS'
    FIELD DirCli AS CHAR FORMAT 'x(120)' LABEL 'DIRECCION DEL CLIENTE'
    .

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
&Scoped-define INTERNAL-TABLES t-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-report.Campo-C[3] ~
t-report.Campo-C[2] t-report.Campo-C[4] t-report.Campo-D[1] ~
t-report.Campo-C[5] t-report.Campo-C[6] t-report.Campo-C[7] ~
t-report.Campo-F[1] t-report.Campo-F[2] t-report.Campo-C[8] ~
t-report.Campo-C[9] t-report.Campo-I[1] t-report.Campo-C[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-6 FILL-IN_Fecha-1 FILL-IN_Fecha-2 ~
BUTTON_Cargar BROWSE-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Fecha-1 FILL-IN_Fecha-2 

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
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 6" 
     SIZE 15 BY 1.62 TOOLTIP "EXPORTAR A TEXTO".

DEFINE BUTTON BUTTON_Cargar 
     LABEL "CARGA TEMPORAL" 
     SIZE 17 BY 1.12.

DEFINE VARIABLE FILL-IN_Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "RECEPCIONADOS DESDE" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "HASTA" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-report.Campo-C[3] COLUMN-LABEL "Nombre del cliente" FORMAT "X(80)":U
            WIDTH 50
      t-report.Campo-C[2] COLUMN-LABEL "HPK" FORMAT "X(15)":U
      t-report.Campo-C[4] COLUMN-LABEL "OD / OTR" FORMAT "X(15)":U
            WIDTH 15.43
      t-report.Campo-D[1] COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      t-report.Campo-C[5] COLUMN-LABEL "Hora" FORMAT "X(8)":U
      t-report.Campo-C[6] COLUMN-LABEL "Zona" FORMAT "X(10)":U
      t-report.Campo-C[7] COLUMN-LABEL "Origen" FORMAT "X(40)":U
      t-report.Campo-F[1] COLUMN-LABEL "Peso (kg)" FORMAT ">>>,>>9.9999":U
      t-report.Campo-F[2] COLUMN-LABEL "Volumen (m3)" FORMAT ">>>,>>9.9999":U
      t-report.Campo-C[8] COLUMN-LABEL "Usuario" FORMAT "X(10)":U
      t-report.Campo-C[9] COLUMN-LABEL "Almacén de Origen" FORMAT "X(40)":U
      t-report.Campo-I[1] COLUMN-LABEL "# Bultos" FORMAT ">>>,>>9":U
      t-report.Campo-C[10] COLUMN-LABEL "Dirección del cliente" FORMAT "X(80)":U
            WIDTH 80
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 23.15
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-6 AT ROW 1 COL 159 WIDGET-ID 14
     FILL-IN_Fecha-1 AT ROW 1.27 COL 23 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_Fecha-2 AT ROW 1.27 COL 45 COLON-ALIGNED WIDGET-ID 4
     BUTTON_Cargar AT ROW 1.27 COL 71 WIDGET-ID 6
     BROWSE-2 AT ROW 2.62 COL 2 WIDGET-ID 200
     BtnDone AT ROW 1 COL 176 WIDGET-ID 10
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
      TABLE: t-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE RECEPCION DE BULTOS DE DISTRIBUCION"
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 BUTTON_Cargar F-Main */
ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-report.Campo-C[3]
"Campo-C[3]" "Nombre del cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-report.Campo-C[2]
"Campo-C[2]" "HPK" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-report.Campo-C[4]
"Campo-C[4]" "OD / OTR" "X(15)" "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-report.Campo-D[1]
"Campo-D[1]" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-report.Campo-C[5]
"Campo-C[5]" "Hora" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-report.Campo-C[6]
"Campo-C[6]" "Zona" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-report.Campo-C[7]
"Campo-C[7]" "Origen" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-report.Campo-F[1]
"Campo-F[1]" "Peso (kg)" ">>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-report.Campo-F[2]
"Campo-F[2]" "Volumen (m3)" ">>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t-report.Campo-C[8]
"Campo-C[8]" "Usuario" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.t-report.Campo-C[9]
"Campo-C[9]" "Almacén de Origen" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.t-report.Campo-I[1]
"Campo-I[1]" "# Bultos" ">>>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.t-report.Campo-C[10]
"Campo-C[10]" "Dirección del cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE RECEPCION DE BULTOS DE DISTRIBUCION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE RECEPCION DE BULTOS DE DISTRIBUCION */
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



&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN ToTexto.
    SESSION:SET-WAIT-STATE('').
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Cargar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Cargar W-Win
ON CHOOSE OF BUTTON_Cargar IN FRAME F-Main /* CARGA TEMPORAL */
DO:
   RUN Carga-Temporal.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte W-Win 
PROCEDURE Carga-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

FOR EACH t-report NO-LOCK:
    CREATE Detalle.
    ASSIGN
        Detalle.nomcli = t-report.campo-C[3]
        Detalle.hpk = t-report.campo-C[2]
        Detalle.od_otr = t-report.campo-C[4]
        Detalle.fecha = t-report.campo-D[1]
        Detalle.hora = t-report.campo-C[5]
        Detalle.zona = t-report.campo-C[6]
        Detalle.origen = t-report.campo-C[7]
        Detalle.peso = t-report.campo-F[1]
        Detalle.volumen = t-report.campo-F[2]
        Detalle.usuario = t-report.campo-C[8]
        Detalle.almacen = t-report.campo-C[9]
        Detalle.bultos = t-report.campo-i[1]
        Detalle.dircli = t-report.campo-C[10]
        .
END.

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

EMPTY TEMP-TABLE t-report.

FOR EACH LogTabla NO-LOCK WHERE logtabla.codcia = s-codcia
    AND logtabla.Evento = "DIST_RECEP_BULTOS"
    AND logtabla.Tabla = "VTACDOCU"
    AND logtabla.Dia >= FILL-IN_Fecha-1
    AND logtabla.Dia <= FILL-IN_Fecha-2
    AND ENTRY(1,logtabla.ValorLlave,":") = s-coddiv:
    CREATE t-report.
    ASSIGN
        t-report.Campo-C[1] = ENTRY(2,logtabla.ValorLlave,":")      /* HPK */
        t-report.Campo-C[2] = ENTRY(3,logtabla.ValorLlave,":")
        .
    FIND Vtacdocu WHERE Vtacdocu.codcia = s-codcia
        AND Vtacdocu.coddiv = s-coddiv
        AND Vtacdocu.codped = t-report.Campo-C[1]
        AND Vtacdocu.nroped = t-report.Campo-C[2]
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        DELETE t-report.
        NEXT.
    END.
    FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = Vtacdocu.codref                   /* O/D u OTR */
        AND Faccpedi.nroped = Vtacdocu.nroref
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        DELETE t-report.
        NEXT.
    END.

    ASSIGN
        t-report.Campo-C[3] = Faccpedi.nomcli
        t-report.Campo-C[4] = Faccpedi.coddoc + "-" + Faccpedi.nroped
        t-report.Campo-D[1] = FacCPedi.FchPed 
        t-report.Campo-C[5] = FacCPedi.Hora
        t-report.Campo-C[6] = ENTRY(4,logtabla.ValorLlave,":")
        t-report.Campo-C[7] = FacCPedi.CodAlm
        t-report.Campo-F[1] = Vtacdocu.peso
        t-report.Campo-F[2] = Vtacdocu.volumen
        t-report.Campo-C[8] = logtabla.Usuario
        t-report.Campo-C[9] = FacCPedi.CodAlm
        .
    /* Origen */
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = Faccpedi.codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN DO:
        t-report.Campo-C[7] = Almacen.codalm + " " + Almacen.Descripcion.
        IF Faccpedi.coddiv <> s-coddiv THEN DO:
            FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Faccpedi.coddiv NO-LOCK.
            t-report.Campo-C[7] = GN-DIVI.DesDiv. 
        END.
        /* Almacén de origen */
        t-report.Campo-C[9] = Almacen.codalm + " " + Almacen.Descripcion.
    END.
    /* Bultos */
    FOR EACH Ccbcbult NO-LOCK WHERE CcbCBult.CodCia = s-codcia 
        AND CcbCBult.CodDoc = Faccpedi.coddoc
        AND CcbCBult.NroDoc = Faccpedi.nroped:
        t-report.Campo-i[1] = t-report.Campo-i[1] + CcbCBult.Bultos.
    END.
    t-report.campo-C[10] = Faccpedi.dircli.
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
  DISPLAY FILL-IN_Fecha-1 FILL-IN_Fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-6 FILL-IN_Fecha-1 FILL-IN_Fecha-2 BUTTON_Cargar BROWSE-2 
         BtnDone 
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
  FILL-IN_Fecha-1 = TODAY.
  FILL-IN_Fecha-2 = TODAY.

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
  {src/adm/template/snd-list.i "t-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ToTexto W-Win 
PROCEDURE ToTexto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').

    EMPTY TEMP-TABLE Detalle.
    RUN Carga-Reporte.

    /* Programas que generan el Excel */
    cArchivo = LC(pArchivo).
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    SESSION:SET-WAIT-STATE('').
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

