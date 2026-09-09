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
    FIELD CodPed AS CHAR FORMAT 'x(5)'      LABEL 'Doc'
    FIELD NroPed AS CHAR FORMAT 'x(15)'     LABEL 'Numero'
    FIELD CodDoc AS CHAR FORMAT 'x(5)'      LABEL 'Doc'
    FIELD NroDoc AS CHAR FORMAT 'x(15)'     LABEL 'Numero'
    FIELD CodMat AS CHAR FORMAT 'x(8)'      LABEL 'Articulo'
    FIELD DesMat AS CHAR FORMAT 'x(100)'    LABEL 'Descripcion'
    FIELD Motivo AS CHAR FORMAT 'x(8)'      LABEL 'Motivo'
    FIELD DesMot AS CHAR FORMAT 'x(30)'     LABEL 'Descripcion'
    FIELD CanPed AS DECI FORMAT '->>>,>>>,>>9.99'   LABEL 'Cantidad Pedida'
    FIELD CanPic AS DECI FORMAT '->>>,>>>,>>9.99'   LABEL 'Cantidad Pickeada'
    FIELD UsrSac AS CHAR FORMAT 'x(15)'     LABEL 'Picador'
    FIELD NomSac AS CHAR FORMAT 'x(80)'     LABEL 'Nombre'
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
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-report

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 t-report.Campo-C[1] ~
t-report.Campo-C[2] t-report.Campo-C[3] t-report.Campo-C[4] ~
t-report.Campo-C[5] t-report.Campo-C[7] t-report.Campo-C[6] ~
t-report.Campo-C[8] t-report.Campo-F[1] t-report.Campo-F[2] ~
t-report.Campo-C[9] t-report.Campo-C[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH t-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH t-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 t-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 t-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-16 FILL-IN-FchPicking-1 ~
FILL-IN-FchPicking-2 BUTTON-15 BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchPicking-1 FILL-IN-FchPicking-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-15 
     LABEL "FILTRAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-16 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 16" 
     SIZE 8 BY 1.88 TOOLTIP "Exportar a TEXTO".

DEFINE VARIABLE FILL-IN-FchPicking-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Pickeados desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPicking-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      t-report
    FIELDS(t-report.Campo-C[1]
      t-report.Campo-C[2]
      t-report.Campo-C[3]
      t-report.Campo-C[4]
      t-report.Campo-C[5]
      t-report.Campo-C[7]
      t-report.Campo-C[6]
      t-report.Campo-C[8]
      t-report.Campo-F[1]
      t-report.Campo-F[2]
      t-report.Campo-C[9]
      t-report.Campo-C[10]) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      t-report.Campo-C[1] COLUMN-LABEL "Doc" FORMAT "X(5)":U
      t-report.Campo-C[2] COLUMN-LABEL "Número" FORMAT "X(15)":U
      t-report.Campo-C[3] COLUMN-LABEL "Doc" FORMAT "X(5)":U
      t-report.Campo-C[4] COLUMN-LABEL "Número" FORMAT "X(15)":U
      t-report.Campo-C[5] COLUMN-LABEL "Artículo" FORMAT "X(8)":U
      t-report.Campo-C[7] COLUMN-LABEL "Descripcion" FORMAT "X(80)":U
            WIDTH 50.29
      t-report.Campo-C[6] COLUMN-LABEL "Motivo" FORMAT "X(8)":U
      t-report.Campo-C[8] COLUMN-LABEL "Descripcion" FORMAT "X(30)":U
      t-report.Campo-F[1] COLUMN-LABEL "Cantidad Pedida" FORMAT "->>>,>>>,>>9.99":U
      t-report.Campo-F[2] COLUMN-LABEL "Cantidad Pickeada" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 14
      t-report.Campo-C[9] COLUMN-LABEL "Picador" FORMAT "X(12)":U
      t-report.Campo-C[10] COLUMN-LABEL "Nombre" FORMAT "X(80)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 22.35
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-16 AT ROW 1.27 COL 143 WIDGET-ID 8
     FILL-IN-FchPicking-1 AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-FchPicking-2 AT ROW 2.35 COL 29 COLON-ALIGNED WIDGET-ID 4
     BUTTON-15 AT ROW 2.08 COL 51 WIDGET-ID 6
     BROWSE-4 AT ROW 3.69 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.14 BY 26.15
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
         TITLE              = "REPORTE DE PICKINGS OBSERVADOS"
         HEIGHT             = 26.15
         WIDTH              = 191.14
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
/* BROWSE-TAB BROWSE-4 BUTTON-15 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.t-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED, FIRST OUTER USED"
     _FldNameList[1]   > Temp-Tables.t-report.Campo-C[1]
"t-report.Campo-C[1]" "Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-report.Campo-C[2]
"t-report.Campo-C[2]" "Número" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-report.Campo-C[3]
"t-report.Campo-C[3]" "Doc" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-report.Campo-C[4]
"t-report.Campo-C[4]" "Número" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-report.Campo-C[5]
"t-report.Campo-C[5]" "Artículo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-report.Campo-C[7]
"t-report.Campo-C[7]" "Descripcion" "X(80)" "character" ? ? ? ? ? ? no ? no no "50.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-report.Campo-C[6]
"t-report.Campo-C[6]" "Motivo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-report.Campo-C[8]
"t-report.Campo-C[8]" "Descripcion" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-report.Campo-F[1]
"t-report.Campo-F[1]" "Cantidad Pedida" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t-report.Campo-F[2]
"t-report.Campo-F[2]" "Cantidad Pickeada" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.t-report.Campo-C[9]
"t-report.Campo-C[9]" "Picador" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.t-report.Campo-C[10]
"t-report.Campo-C[10]" "Nombre" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE PICKINGS OBSERVADOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE PICKINGS OBSERVADOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-15 W-Win
ON CHOOSE OF BUTTON-15 IN FRAME F-Main /* FILTRAR */
DO:
  ASSIGN FILL-IN-FchPicking-1 FILL-IN-FchPicking-2.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 W-Win
ON CHOOSE OF BUTTON-16 IN FRAME F-Main /* Button 16 */
DO:
    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').

    EMPTY TEMP-TABLE Detalle.
    FOR EACH t-report NO-LOCK:
        CREATE Detalle.
        ASSIGN
            Detalle.codped = t-report.Campo-C[1]
            Detalle.nroped = t-report.Campo-C[2]
            Detalle.coddoc = t-report.Campo-C[3]
            Detalle.nrodoc = t-report.Campo-C[4]
            Detalle.codmat = t-report.Campo-C[5]
            Detalle.desmat = t-report.Campo-C[7]
            Detalle.motivo = t-report.Campo-C[6]
            Detalle.desmot = t-report.Campo-C[8]
            Detalle.canped = t-report.Campo-F[1]
            Detalle.canpic = t-report.Campo-F[2]
            Detalle.usrsac = t-report.Campo-C[9]
            Detalle.nomsac = t-report.Campo-C[10]
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
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Fin de la exportación' VIEW-AS ALERT-BOX INFORMATION.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-report.

FOR EACH LogTabla NO-LOCK WHERE logtabla.codcia = s-codcia 
    AND logtabla.Evento = "CORRECCION" 
    AND logtabla.Tabla = "FACDPEDI"
    AND logtabla.Dia >= FILL-IN-FchPicking-1
    AND logtabla.Dia <= FILL-IN-FchPicking-2:
    IF NUM-ENTRIES(logtabla.ValorLlave,'|') < 8 THEN NEXT.

    FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = ENTRY(1,logtabla.ValorLlave,'|')
        AND Faccpedi.nroped = ENTRY(2,logtabla.ValorLlave,'|')
        AND Faccpedi.divdes = s-coddiv
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN NEXT.

    CREATE t-report.
    ASSIGN
        t-report.Campo-C[1] = ENTRY(1,logtabla.ValorLlave,'|')              /* OTR O/D */
        t-report.Campo-C[2] = ENTRY(2,logtabla.ValorLlave,'|')
        t-report.Campo-C[5] = ENTRY(3,logtabla.ValorLlave,'|')              /* SKU */
        t-report.Campo-F[1] = DECIMAL(ENTRY(4,logtabla.ValorLlave,'|'))
        t-report.Campo-F[2] = DECIMAL(ENTRY(5,logtabla.ValorLlave,'|'))     /* Pickeado */
        .
    IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 6 
        THEN t-report.Campo-C[3] = ENTRY(6,logtabla.ValorLlave,'|').        /* HPK */
    IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 7
        THEN t-report.Campo-C[4] = ENTRY(7,logtabla.ValorLlave,'|').
    IF NUM-ENTRIES(logtabla.ValorLlave,'|') >= 8
        THEN t-report.Campo-C[6] = ENTRY(8,logtabla.ValorLlave,'|').        /* Motivo */
END.

DEF VAR pNombre AS CHAR NO-UNDO.
DEF VAR pOrigen AS CHAR NO-UNDO.

FOR EACH t-report:
    FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-codcia
        AND Almmmatg.codmat = t-report.Campo-C[5]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN t-report.Campo-C[7] = Almmmatg.desmat.

    FIND Almtabla WHERE almtabla.Tabla = "HPK"
        AND almtabla.NomAnt  = "PO"
        AND almtabla.Codigo = t-report.Campo-C[6]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN t-report.Campo-C[8] = almtabla.Nombre.

    FIND Vtacdocu WHERE Vtacdocu.codcia = s-codcia 
        AND Vtacdocu.codped = t-report.Campo-C[3]
        AND Vtacdocu.nroped = t-report.Campo-C[4]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtacdocu THEN DO:
        RUN logis/p-busca-por-dni (VtaCDocu.UsrSac,
                                   OUTPUT pNombre,
                                   OUTPUT pOrigen).
        ASSIGN
            t-report.Campo-C[9]  = VtaCDocu.UsrSac
            t-report.Campo-C[10] = pNombre.
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
  DISPLAY FILL-IN-FchPicking-1 FILL-IN-FchPicking-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-16 FILL-IN-FchPicking-1 FILL-IN-FchPicking-2 BUTTON-15 BROWSE-4 
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
  FILL-IN-FchPicking-1 = ADD-INTERVAL(TODAY,-1,'month').
  FILL-IN-FchPicking-2 = TODAY.

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

