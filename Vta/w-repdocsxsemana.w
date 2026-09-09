&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

DEFINE SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE x-coddiv LIKE gn-divi.coddiv   NO-UNDO.
DEFINE VARIABLE iDesde   AS INTEGER            NO-UNDO.
DEFINE VARIABLE iHasta   AS INTEGER            NO-UNDO.

DEFINE TEMP-TABLE tt-detalle 
    FIELDS coddiv  LIKE gn-divi.coddiv
    FIELDS periodo AS INT
    FIELDS nrosem  AS INT
    FIELDS codmat  LIKE almmmatg.codmat
    FIELDS canped  AS DEC
    FIELDS imptot  AS DEC
    INDEX Llave01 IS PRIMARY coddiv periodo nrosem codmat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-divisiones txt-desde txt-hasta BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS cb-divisiones txt-desde txt-hasta txt-mnje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 11 BY 2.42.

DEFINE VARIABLE cb-divisiones AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE txt-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-mnje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.29 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-divisiones AT ROW 1.81 COL 13 COLON-ALIGNED WIDGET-ID 2
     txt-desde AT ROW 3.15 COL 13 COLON-ALIGNED WIDGET-ID 4
     txt-hasta AT ROW 3.15 COL 37 COLON-ALIGNED WIDGET-ID 6
     BUTTON-1 AT ROW 4.77 COL 66 WIDGET-ID 10
     txt-mnje AT ROW 5.31 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 6.88 WIDGET-ID 100.


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
         TITLE              = "Detalle Articulos por Semana"
         HEIGHT             = 6.88
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR FILL-IN txt-mnje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Detalle Articulos por Semana */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Detalle Articulos por Semana */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  
    ASSIGN cb-divisiones txt-desde txt-hasta.

    IF cb-divisiones BEGINS 'Todo' THEN x-coddiv = ''.
    ELSE x-coddiv = SUBSTRING(cb-divisiones,1,5).

    iDesde = (YEAR(txt-desde) * 10000) + (MONTH(txt-desde) * 100) + DAY(txt-desde).
    iHasta = (YEAR(txt-Hasta) * 10000) + (MONTH(txt-Hasta) * 100) + DAY(txt-Hasta).
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos W-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE periodo AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNroSem AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iSigno  AS INTEGER     NO-UNDO.

    DEFINE VARIABLE cAnio   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cMes    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDia    AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE cFecha AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-detalle.

    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv BEGINS x-coddiv NO-LOCK:
        FOR EACH dwh_ventas_mat WHERE dwh_ventas_mat.CodCia = s-codcia
            AND dwh_ventas_mat.CodDiv = gn-divi.coddiv
            AND dwh_ventas_mat.Fecha  >= iDesde
            AND dwh_ventas_mat.Fecha  <= iHasta NO-LOCK:

            FIND FIRST dwh_tiempo WHERE dwh_tiempo.CodCia = s-codcia
                AND dwh_tiempo.Fecha   = dwh_ventas_mat.fecha NO-LOCK NO-ERROR.

            IF AVAIL dwh_tiempo THEN DO:
                cFecha = STRING(dwh_tiempo.nrodia,"99") + '/' +

                         STRING(dwh_tiempo.nromes,"99") + '/' +
                         STRING(dwh_tiempo.periodo,"9999").

                FIND FIRST evtsemanas WHERE evtsemanas.codcia = s-codcia
                    AND evtsemanas.fecini <= DATE(cFecha)
                    AND evtsemanas.fecfin >= DATE(cFecha) NO-LOCK NO-ERROR.

                IF AVAIL evtsemanas THEN
                    ASSIGN
                        iNroSem = EvtSemanas.NroSem
                        Periodo = EvtSemanas.Periodo.
                ELSE
                    ASSIGN
                        iNroSem = 0
                        Periodo = 0.
            END.

            FIND FIRST tt-detalle WHERE tt-detalle.coddiv = dwh_ventas_mat.CodDiv
                AND tt-detalle.nrosem = iNroSem
                AND tt-detalle.codmat = dwh_ventas_mat.CodMat NO-ERROR.
            IF NOT AVAIL tt-detalle THEN DO:
                CREATE tt-detalle.
                ASSIGN 
                    tt-detalle.coddiv  = dwh_ventas_mat.CodDiv
                    tt-detalle.periodo = Periodo
                    tt-detalle.nrosem  = iNroSem
                    tt-detalle.codmat  = dwh_ventas_mat.CodMat.
            END.

            ASSIGN 
                tt-detalle.canped = tt-detalle.canped + dwh_ventas_mat.Cantidad
                tt-detalle.imptot = tt-detalle.imptot + dwh_ventas_mat.ImpNacCIGV.

            DISPLAY "<<   CARGANDO INFORMACION  >>" @ txt-mnje WITH FRAME {&FRAME-NAME}.

            PAUSE 0.

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
  DISPLAY cb-divisiones txt-desde txt-hasta txt-mnje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cb-divisiones txt-desde txt-hasta BUTTON-1 
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
SESSION:SET-WAIT-STATE('GENERAL').

/* Cargamos el temporal */
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 2.

DEFINE VARIABLE cDesFam AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSubFam AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

RUN Carga-Datos.

/* Titulos */
chWorkSheet:Range("A1"):VALUE = "Reporte de Ventas".
chWorkSheet:Range("A2"):VALUE = "Division".
chWorkSheet:Range("B2"):VALUE = "Semana".
chWorkSheet:Range("C2"):VALUE = "Articulo".
chWorkSheet:Range("D2"):VALUE = "Descripcion".
chWorkSheet:Range("E2"):VALUE = "Marca".
chWorkSheet:Range("F2"):VALUE = "Familia".
chWorkSheet:Range("G2"):VALUE = "Sub Familia".
chWorkSheet:Range("H2"):VALUE = "Proveedor".
chWorkSheet:Range("I2"):VALUE = "Cantidad".
chWorkSheet:Range("J2"):VALUE = "Importe".

/*chWorkSheet:COLUMNS("B"):NumberFormat = "dd/MM/yyyy".*/
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH tt-detalle NO-LOCK BREAK BY tt-detalle.nrosem :

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = tt-detalle.coddiv NO-LOCK NO-ERROR.

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = tt-detalle.codmat NO-LOCK NO-ERROR.

    ASSIGN
        cDesFam = ''
        cSubFam = ''.


    FIND FIRST almtfami OF almmmatg NO-LOCK NO-ERROR.
    IF AVAIL almtfami THEN cDesFam = almmmatg.codfam + "-" + almtfami.desfam.

    FIND FIRST almsfami OF almmmatg NO-LOCK NO-ERROR.
    IF AVAIL almsfami THEN cSubFam = almmmatg.subfam + "-" + almsfami.dessub.


    t-Row = t-Row + 1.
    t-Column = 1.
    chWorkSheet:Cells(t-Row, t-Column) = tt-detalle.coddiv + '-' + gn-divi.desdiv.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = STRING(tt-detalle.periodo,"9999") + " " + STRING(tt-detalle.nrosem,"99").
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = tt-detalle.codmat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = almmmatg.desmat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = almmmatg.desmar.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = cDesFam.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = cSubFam.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = almmmatg.codpr1.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = tt-detalle.canped.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = tt-detalle.imptot.

    DISPLAY "<<   GENERANDO EXCEL   >>" @ txt-mnje WITH FRAME {&FRAME-NAME}.

    PAUSE 0.

END.

MESSAGE "Proceso Terminado"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
DISPLAY "" @ txt-mnje WITH FRAME {&FRAME-NAME}.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').



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
      FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
          cb-divisiones:ADD-LAST(gn-divi.coddiv + '-' + gn-divi.desdiv).          
      END.
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

