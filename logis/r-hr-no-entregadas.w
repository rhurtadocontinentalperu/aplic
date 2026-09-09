&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tw-report NO-UNDO LIKE w-report.



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
    FIELD CodDoc    AS CHAR     FORMAT 'x(5)'       LABEL 'Doc.'
    FIELD NroDoc    AS CHAR     FORMAT 'x(15)'      LABEL 'Nro. HR'
    FIELD CodCli    AS CHAR     FORMAT 'x(15)'      LABEL 'Cliente'
    FIELD NomCli    AS CHAR     FORMAT 'x(100)'     LABEL 'Nombre del cliente'
    FIELD Motivo    AS CHAR     FORMAT 'x(40)'      LABEL 'Motivo'
    FIELD Estado    AS CHAR     FORMAT 'x(15)'      LABEL 'Estado'
    FIELD Glosa     AS CHAR     FORMAT 'x(50)'      LABEL 'Glosa'
    FIELD CodRef    AS CHAR     FORMAT 'x(5)'       LABEL 'Ref.'
    FIELD NroRef    AS CHAR     FORMAT 'x(15)'      LABEL 'Nro. Referencia'
    FIELD rspta     AS CHAR     FORMAT 'x(25)'      LABEL 'Respuesta SUNAT'
    .

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tw-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tw-report.Campo-C[1] ~
tw-report.Campo-C[2] tw-report.Campo-C[3] tw-report.Campo-C[4] ~
tw-report.Campo-C[5] tw-report.Campo-C[6] tw-report.Campo-C[7] ~
tw-report.Campo-C[10] tw-report.Campo-C[11] tw-report.Campo-C[12] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tw-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tw-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tw-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tw-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnDone FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 ~
BUTTON-1 BROWSE-2 BUTTON-Cargar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 

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
     SIZE 10 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "CARGAR INFORMACION" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-Cargar 
     IMAGE-UP FILE "IMG/balance.ico":U
     LABEL "Exportar a TEXTO" 
     SIZE 11 BY 1.62 TOOLTIP "Exportar a TEXTO".

DEFINE VARIABLE FILL-IN_FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hojas de Ruta CERRADAS desde el" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta el" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tw-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tw-report.Campo-C[1] COLUMN-LABEL "Doc" FORMAT "X(8)":U WIDTH 4.43
      tw-report.Campo-C[2] COLUMN-LABEL "Nro. HR" FORMAT "X(15)":U
            WIDTH 10.43
      tw-report.Campo-C[3] COLUMN-LABEL "Cliente" FORMAT "X(15)":U
      tw-report.Campo-C[4] COLUMN-LABEL "Nombre del cliente" FORMAT "X(80)":U
            WIDTH 40.86
      tw-report.Campo-C[5] COLUMN-LABEL "Motivo" FORMAT "X(40)":U
            WIDTH 30.43
      tw-report.Campo-C[6] COLUMN-LABEL "Estado" FORMAT "X(12)":U
            WIDTH 15.14
      tw-report.Campo-C[7] COLUMN-LABEL "Glosa" FORMAT "X(50)":U
            WIDTH 37.72
      tw-report.Campo-C[10] COLUMN-LABEL "Ref." FORMAT "X(5)":U
      tw-report.Campo-C[11] COLUMN-LABEL "Nro. Referencia" FORMAT "X(15)":U
            WIDTH 11
      tw-report.Campo-C[12] COLUMN-LABEL "Respuesta SUNAT" FORMAT "X(25)":U
            WIDTH 9.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 188 BY 22.35
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.54 COL 171 WIDGET-ID 12
     FILL-IN_FchDoc-1 AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_FchDoc-2 AT ROW 2.35 COL 29 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.54 COL 51 WIDGET-ID 6
     BROWSE-2 AT ROW 3.96 COL 3 WIDGET-ID 200
     BUTTON-Cargar AT ROW 1.54 COL 160 WIDGET-ID 10
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
      TABLE: tw-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE HOJAS DE RUTA CERRADAS Y NO ENTREGADAS"
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
/* BROWSE-TAB BROWSE-2 BUTTON-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tw-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tw-report.Campo-C[1]
"Campo-C[1]" "Doc" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tw-report.Campo-C[2]
"Campo-C[2]" "Nro. HR" "X(15)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tw-report.Campo-C[3]
"Campo-C[3]" "Cliente" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tw-report.Campo-C[4]
"Campo-C[4]" "Nombre del cliente" "X(80)" "character" ? ? ? ? ? ? no ? no no "40.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tw-report.Campo-C[5]
"Campo-C[5]" "Motivo" "X(40)" "character" ? ? ? ? ? ? no ? no no "30.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tw-report.Campo-C[6]
"Campo-C[6]" "Estado" "X(12)" "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tw-report.Campo-C[7]
"Campo-C[7]" "Glosa" "X(50)" "character" ? ? ? ? ? ? no ? no no "37.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tw-report.Campo-C[10]
"Campo-C[10]" "Ref." "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tw-report.Campo-C[11]
"Campo-C[11]" "Nro. Referencia" "X(15)" "character" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tw-report.Campo-C[12]
"Campo-C[12]" "Respuesta SUNAT" "X(25)" "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE HOJAS DE RUTA CERRADAS Y NO ENTREGADAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE HOJAS DE RUTA CERRADAS Y NO ENTREGADAS */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CARGAR INFORMACION */
DO:
  ASSIGN FILL-IN_FchDoc-1 FILL-IN_FchDoc-2.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE 'Carga terminada' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Cargar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Cargar W-Win
ON CHOOSE OF BUTTON-Cargar IN FRAME F-Main /* Exportar a TEXTO */
DO:
    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').

    /* Cargamos la informacion al temporal */
    EMPTY TEMP-TABLE Detalle.

    FOR EACH tw-report NO-LOCK:
        CREATE Detalle.
        ASSIGN
            Detalle.CodDoc = tw-report.campo-c[1]   
            Detalle.NroDoc = tw-report.campo-c[2]   
            Detalle.CodCli = tw-report.campo-c[3]   
            Detalle.NomCli = tw-report.campo-c[4]  
            Detalle.Motivo = tw-report.campo-c[5]   
            Detalle.Estado = tw-report.campo-c[6]   
            Detalle.Glosa  = tw-report.campo-c[7]   
            Detalle.CodRef = tw-report.campo-c[10]   
            Detalle.NroRef = tw-report.campo-c[11]   
            Detalle.rspta  = tw-report.campo-c[12]   
            .
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tw-report.

FOR EACH DI-RutaC NO-LOCK WHERE DI-RutaC.CodCia = s-codcia AND
        DI-RutaC.CodDiv = s-coddiv AND
        DI-RutaC.CodDoc = "H/R" AND
        DI-RutaC.FlgEst = "C" AND
        DI-RutaC.FchDoc >= FILL-IN_FchDoc-1 AND
        DI-RutaC.FchDoc <= FILL-IN_FchDoc-2,
    EACH DI-RutaD OF DI-RutaC NO-LOCK,
    FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia AND
        CcbCDocu.CodDoc = DI-RutaD.CodRef AND   /* G/R */
        CcbCDocu.NroDoc = DI-RutaD.NroRef:
    IF DI-RutaD.FlgEst = "N" THEN DO:
        Fi-Mensaje = "Procesando HR " + DI-RutaC.NroDoc + " GR " + DI-RutaD.NroRef.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        CREATE tw-report.
        ASSIGN
            tw-report.Campo-C[1] = DI-RutaC.CodDoc
            tw-report.Campo-C[2] = DI-RutaC.NroDoc
            tw-report.Campo-C[3] = CcbCDocu.CodCli 
            tw-report.Campo-C[4] = CcbCDocu.NomCli.
        FIND Almtabla WHERE almtabla.Tabla = "HR" AND
            almtabla.NomAnt = "N" AND
            almtabla.CodCta1 <> "I" AND
            almtabla.Codigo =  DI-RutaD.FlgEstDet
            NO-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE Almtabla THEN tw-report.Campo-C[5] = almtabla.Nombre.
        tw-report.Campo-C[6] = (IF DI-RutaD.Libre_c02 = "R" THEN "REPROGRAMADO" ELSE "NO REPROGRAMADO").
        tw-report.Campo-C[7] = DI-RutaD.Libre_c03.
        /* Datos de la GR */
        ASSIGN
            tw-report.Campo-C[10] = DI-RutaD.CodRef
            tw-report.Campo-C[11] = DI-RutaD.NroRef
            .
        /* Respuesta SUNAT */
        FIND gre_header WHERE gre_header.serieGuia = INTEGER(SUBSTRING(DI-RutaD.NroRef,1,3)) AND
            gre_header.numeroGuia = INTEGER(SUBSTRING(DI-RutaD.NroRef,4))
            NO-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE gre_header THEN  tw-report.Campo-C[12] = gre_header.m_rspta_sunat.

    END.
END.
HIDE FRAME F-Proceso.

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
  DISPLAY FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnDone FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 BUTTON-1 BROWSE-2 
         BUTTON-Cargar 
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
  FILL-IN_FchDoc-1 = TODAY.
  FILL-IN_FchDoc-2 = TODAY.

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
  {src/adm/template/snd-list.i "tw-report"}

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

