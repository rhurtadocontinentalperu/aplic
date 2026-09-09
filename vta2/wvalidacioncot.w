&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE FacDPedi
       FIELD TotItm AS INT.



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

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

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
&Scoped-define INTERNAL-TABLES Detalle

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Detalle.NroPed Detalle.NroItm ~
Detalle.CanPick Detalle.CodCli Detalle.codmat Detalle.UndVta Detalle.ImpLin ~
Detalle.Libre_d01 Detalle.Libre_d02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Detalle NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Detalle NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Detalle
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Detalle


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Divisiones BUTTON-1 BUTTON-2 ~
FILL-IN-CodCli Desde Hasta FILL-IN-Variacion BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Divisiones FILL-IN-CodCli ~
FILL-IN-NomCli Desde Hasta FILL-IN-Variacion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "VALIDAR" 
     SIZE 15 BY 1.73.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 15 BY 1.73.

DEFINE VARIABLE COMBO-BOX-Divisiones AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione" 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Seleccione una división","Seleccione"
     DROP-DOWN-LIST
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Código Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Variacion AS DECIMAL FORMAT ">>9.99":U INITIAL 5 
     LABEL "% Variación" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Detalle SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Detalle.NroPed COLUMN-LABEL "Número" FORMAT "X(15)":U WIDTH 8.43
      Detalle.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U WIDTH 3.43
      Detalle.CanPick COLUMN-LABEL "Total!Items" FORMAT ">,>>9":U
      Detalle.CodCli COLUMN-LABEL "Cliente" FORMAT "x(60)":U WIDTH 37.29
      Detalle.codmat COLUMN-LABEL "Articulo" FORMAT "X(60)":U WIDTH 42.43
      Detalle.UndVta FORMAT "x(8)":U WIDTH 5.86
      Detalle.ImpLin COLUMN-LABEL "Importe del!Articulo" FORMAT "->>,>>>,>>9.99":U
            WIDTH 8.43
      Detalle.Libre_d01 COLUMN-LABEL "Importe de!la Cotización" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 9.57
      Detalle.Libre_d02 COLUMN-LABEL "%!Variación" FORMAT ">>>,>>9.99":U
            WIDTH 7.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 135 BY 21.04
         FONT 4 ROW-HEIGHT-CHARS .42 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Divisiones AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.38 COL 107 WIDGET-ID 10
     BUTTON-2 AT ROW 1.38 COL 122 WIDGET-ID 12
     FILL-IN-CodCli AT ROW 2.08 COL 11 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-NomCli AT ROW 2.08 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     Desde AT ROW 2.88 COL 11 COLON-ALIGNED WIDGET-ID 6
     Hasta AT ROW 2.88 COL 31 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Variacion AT ROW 3.69 COL 11 COLON-ALIGNED WIDGET-ID 14
     BROWSE-2 AT ROW 4.77 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 137.43 BY 25.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: Detalle T "?" NO-UNDO INTEGRAL FacDPedi
      ADDITIONAL-FIELDS:
          FIELD TotItm AS INT
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "VALIDACION DE COTIZACIONES"
         HEIGHT             = 25.85
         WIDTH              = 137.43
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
/* BROWSE-TAB BROWSE-2 FILL-IN-Variacion F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.Detalle"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.Detalle.NroPed
"Detalle.NroPed" "Número" "X(15)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.Detalle.NroItm
"Detalle.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.Detalle.CanPick
"Detalle.CanPick" "Total!Items" ">,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.Detalle.CodCli
"Detalle.CodCli" "Cliente" "x(60)" "character" ? ? ? ? ? ? no ? no no "37.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.Detalle.codmat
"Detalle.codmat" "Articulo" "X(60)" "character" ? ? ? ? ? ? no ? no no "42.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.Detalle.UndVta
"Detalle.UndVta" ? ? "character" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.Detalle.ImpLin
"Detalle.ImpLin" "Importe del!Articulo" ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.Detalle.Libre_d01
"Detalle.Libre_d01" "Importe de!la Cotización" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.Detalle.Libre_d02
"Detalle.Libre_d02" "%!Variación" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VALIDACION DE COTIZACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VALIDACION DE COTIZACIONES */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* VALIDAR */
DO:
  /* Filtros */
    ASSIGN COMBO-BOX-Divisiones Desde Hasta FILL-IN-Variacion FILL-IN-CodCli.
    IF COMBO-BOX-Divisiones BEGINS 'Seleccione' THEN DO:
        MESSAGE 'Debe seleccionar una división' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF Desde = ? OR Hasta = ? OR Desde > Hasta THEN DO:
        MESSAGE 'Corrija el rango de fechas' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF FILL-IN-Variacion = 0 THEN DO:
        MESSAGE 'Corrija el % de variación' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').
    {&OPEN-QUERY-{&BROWSE-NAME}}
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Código Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
  ELSE FILL-IN-NomCli:SCREEN-VALUE = "".
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

    EMPTY TEMP-TABLE Detalle.

    FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddiv = COMBO-BOX-Divisiones
        AND faccpedi.coddoc = 'COT'
        AND faccpedi.fchped >= Desde
        AND faccpedi.fchped <= Hasta
        AND faccpedi.flgest <> 'A'
        AND (TRUE <> (FILL-IN-CodCli > '') OR faccpedi.codcli = FILL-IN-CodCli),
        FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = faccpedi.codcli:
        FOR EACH facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF facdpedi NO-LOCK:
            IF (facdpedi.implin / faccpedi.imptot) * 100 > FILL-IN-Variacion
                THEN DO:
                CREATE Detalle.
                ASSIGN
                    Detalle.CodCia = faccpedi.codcia
                    Detalle.CodDiv = faccpedi.coddiv
                    Detalle.CodDoc = faccpedi.coddoc
                    Detalle.NroPed = faccpedi.nroped
                    Detalle.FchPed = faccpedi.fchped
                    Detalle.FlgEst = faccpedi.flgest
                    Detalle.Hora   = faccpedi.hora
                    Detalle.CodCli = gn-clie.codcli + ' - ' + gn-clie.nomcli
                    Detalle.NroItm = facdpedi.nroitm
                    Detalle.codmat = almmmatg.codmat + ' - ' + almmmatg.desmat
                    Detalle.CanPed = facdpedi.canped
                    Detalle.UndVta = facdpedi.undvta
                    Detalle.Factor = facdpedi.factor
                    Detalle.ImpLin = facdpedi.implin
                    Detalle.Libre_d01 = faccpedi.imptot
                    Detalle.Libre_d02 = (facdpedi.implin / faccpedi.imptot) * 100.
            END.
        END.

    END.
    /* Contamos Items por pedido */
    FOR EACH detalle:
        FOR EACH facdpedi NO-LOCK WHERE facdpedi.codcia = detalle.codcia
            AND facdpedi.coddiv = detalle.coddiv
            AND facdpedi.coddoc = detalle.coddoc
            AND facdpedi.nroped = detalle.nroped:
            detalle.totitm = detalle.totitm + 1.
            detalle.canpick = detalle.canpick + 1.
        END.
    END.
    /* Borramos  no deseados */
    FOR EACH detalle WHERE detalle.totitm <= 2:
        DELETE detalle.
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
  DISPLAY COMBO-BOX-Divisiones FILL-IN-CodCli FILL-IN-NomCli Desde Hasta 
          FILL-IN-Variacion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Divisiones BUTTON-1 BUTTON-2 FILL-IN-CodCli Desde Hasta 
         FILL-IN-Variacion BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR lNuevoFile AS LOG INIT YES NO-UNDO.
    DEF VAR lFileXls AS CHAR NO-UNDO.

    DEF VAR t-Row    AS INT NO-UNDO.
    DEF VAR t-Column AS INT NO-UNDO.

    {lib/excel-open-file.i}


    /* set the column names for the Worksheet */
    ASSIGN
        chWorkSheet:Range("A1"):Value = CAPS(s-nomcia) + " - VALIDACION DE COTIZACIONES" 
        chWorkSheet:Range("A2"):Value = "DEL " + STRING(Desde,"99/99/9999") + " AL " + STRING(Desde,"99/99/9999")
        chWorkSheet:Range("A3"):Value = "DIVISION " + COMBO-BOX-Divisiones:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        chWorkSheet:Range("A4"):Value = "% VARIACION " + STRING(FILL-IN-Variacion) + "%"
        chWorkSheet:Range("A5"):Value = "Número"
        chWorkSheet:Range("B5"):Value = "Item"
        chWorkSheet:Range("C5"):Value = "Total Items"
        chWorkSheet:Range("D5"):Value = "Cliente"
        chWorkSheet:Range("E5"):Value = "Artículo"
        chWorkSheet:Range("F5"):Value = "Unidad"
        chWorkSheet:Range("G5"):Value = "Importe del Artículo"
        chWorkSheet:Range("H5"):Value = "Importe de la Cotización"
        chWorkSheet:Range("I5"):Value = "% de Variación".
        .
    ASSIGN
        chWorkSheet:COLUMNS("A"):NumberFormat = "@".

    ASSIGN
        t-Row = 5.
    FOR EACH Detalle NO-LOCK, FIRST gn-divi OF Detalle:
        ASSIGN
            t-Column = 0
            t-Row    = t-Row + 1.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.NroPed.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.NroItm.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.TotItm.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.CodCli.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.CodMat.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.UndVta.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.ImpLin.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.Libre_d01.
        ASSIGN
            t-Column = t-Column + 1
            chWorkSheet:Cells(t-Row, t-Column):VALUE = Detalle.Libre_d02.
    END.


    {lib/excel-close-file.i}

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
      Desde = TODAY - DAY(TODAY) + 1
      Hasta = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
          COMBO-BOX-Divisiones:ADD-LAST(GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
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
  {src/adm/template/snd-list.i "Detalle"}

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

