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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codcia   AS INT.
DEFINE SHARED VAR s-periodo  AS INT.
DEFINE SHARED VAR s-nromes   AS INT.

DEFINE TEMP-TABLE tt-datos 
    FIELDS t-codare AS CHAR    
    FIELDS t-codper LIKE pl-pers.codper
    FIELDS t-patper LIKE pl-pers.patper
    FIELDS t-matper LIKE pl-pers.matper
    FIELDS t-nomper LIKE pl-pers.nomper
    FIELDS t-cargo  AS CHAR
    FIELDS t-monto1 AS DECIMAL
    FIELDS t-monto2 AS DECIMAL
    FIELDS t-fching AS DATE
    FIELDS t-fecini AS DATE
    FIELDS t-fecfin AS DATE.

DEFINE BUFFER b-flg-mes FOR pl-flg-mes.

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
&Scoped-Define ENABLED-OBJECTS cb-areas cb-periodo BUTTON-4 BUTTON-5 ~
cb-nromes 
&Scoped-Define DISPLAYED-OBJECTS cb-areas cb-periodo cb-nromes x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 4" 
     SIZE 11 BY 1.5.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 5" 
     SIZE 11 BY 1.5.

DEFINE VARIABLE cb-areas AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Areas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE cb-nromes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo AS CHARACTER FORMAT "X(4)":U INITIAL "0" 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 68 BY .88
     FONT 2 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-areas AT ROW 1.81 COL 14 COLON-ALIGNED WIDGET-ID 2
     cb-periodo AT ROW 3.15 COL 14 COLON-ALIGNED WIDGET-ID 4
     BUTTON-4 AT ROW 3.96 COL 63 WIDGET-ID 10
     BUTTON-5 AT ROW 3.96 COL 75 WIDGET-ID 12
     cb-nromes AT ROW 4.5 COL 14 COLON-ALIGNED WIDGET-ID 6
     x-mensaje AT ROW 5.85 COL 7 COLON-ALIGNED NO-LABEL WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.72 BY 6.85 WIDGET-ID 100.


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
         TITLE              = "Personal por Areas"
         HEIGHT             = 6.85
         WIDTH              = 91.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 154
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 154
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Personal por Areas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Personal por Areas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    ASSIGN cb-areas cb-nromes cb-periodo.
    RUN Genera-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Personal W-Win 
PROCEDURE Carga-Personal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAreas      AS CHARACTER   NO-UNDO.

    IF cb-areas BEGINS 'Todas' THEN cAreas = ''.
    ELSE cAreas = SUBSTRING(cb-areas,1,3).
    
    EMPTY TEMP-TABLE tt-datos.
    
    Tabla:
    FOR EACH TabPerArea WHERE TabPerArea.CodCia = s-codcia
        AND TabPerArea.CodArea BEGINS cAreas NO-LOCK, 
        FIRST pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia
            AND pl-flg-mes.codper = TabPerArea.CodPer
            AND pl-flg-mes.NroMes = INT(cb-nromes)
            AND pl-flg-mes.Periodo = INT(cb-periodo) NO-LOCK,
            FIRST Pl-Pers WHERE Pl-Pers.CodCia = TabPerArea.CodCia
                AND Pl-Pers.CodPer = pl-flg-mes.CodPer NO-LOCK:

        FIND FIRST tt-datos WHERE tt-datos.t-codper = pl-pers.codper 
            NO-LOCK NO-ERROR.
        IF AVAIL tt-datos THEN NEXT Tabla.
        CREATE tt-datos.
        ASSIGN
            t-codare = TabPerArea.CodArea
            t-codper = pl-pers.codper
            t-patper = pl-pers.patper
            t-matper = pl-pers.matper
            t-nomper = pl-pers.nomper
            t-fching = pl-flg-mes.fecing
            t-cargo  = pl-flg-mes.cargo.

        /*Busca Sueldo y prestaciones alimentarias*/
        FOR EACH pl-mov-mes WHERE pl-mov-mes.CodCia = pl-pers.codcia
            AND pl-mov-mes.codper = pl-pers.codper
            AND pl-mov-mes.codpln = 001
            AND pl-mov-mes.Periodo = INT(cb-periodo)
            AND pl-mov-mes.NroMes  = INT(cb-nromes)
            AND pl-mov-mes.codcal = 000 
            AND (pl-mov-mes.CodMov = 101
                 OR pl-mov-mes.CodMov = 111) NO-LOCK:
            CASE pl-mov-mes.CodMov:
                WHEN 101 THEN t-monto1 = pl-mov-mes.valcal-mes.
                WHEN 111 THEN t-monto2 = pl-mov-mes.valcal-mes.
            END CASE.
        END.

        /*Busca Ultimo Contrato*/
        FIND LAST b-flg-mes WHERE b-flg-mes.codcia = pl-pers.codcia
            AND b-flg-mes.codper = pl-pers.codper
            AND b-flg-mes.vcontr <> ? NO-LOCK NO-ERROR.
        IF AVAIL b-flg-mes THEN 
            ASSIGN
                t-fecini = b-flg-mes.fecing
                t-fecfin = b-flg-mes.vcontr.
        
        DISPLAY 'CARGANDO INFORMACION...' @ x-mensaje 
            WITH FRAME {&FRAME-NAME}.

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
  DISPLAY cb-areas cb-periodo cb-nromes x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cb-areas cb-periodo BUTTON-4 BUTTON-5 cb-nromes 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel W-Win 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

RUN Carga-Personal.

/*set the column names for the Worksheet*/
chWorkSheet:Columns("A"):ColumnWidth = 10.
chWorkSheet:Columns("B"):ColumnWidth = 30.
chWorkSheet:Columns("C"):ColumnWidth = 30.
chWorkSheet:Columns("D"):ColumnWidth = 30.
chWorkSheet:Columns("E"):ColumnWidth = 20.
chWorkSheet:Columns("F"):ColumnWidth = 25.
chWorkSheet:Columns("G"):ColumnWidth = 25.
chWorkSheet:Columns("H"):ColumnWidth = 25.
chWorkSheet:Columns("I"):ColumnWidth = 25.
chWorkSheet:Columns("J"):ColumnWidth = 25.

/* chWorkSheet:Range("A2"):Value = "Código".                    */
/* chWorkSheet:Range("B2"):Value = "Ap. Paterno".               */
/* chWorkSheet:Range("C2"):Value = "Ap. Materno".               */
/* chWorkSheet:Range("D2"):Value = "Nombres".                   */
/* chWorkSheet:Range("E2"):Value = "Cargo".                     */
/* chWorkSheet:Range("F2"):Value = "Sueldo Básico".             */
/* chWorkSheet:Range("G2"):Value = "Prestaciones Alimentarias". */
/* chWorkSheet:Range("H2"):Value = "Fecha de Ingreso".          */
/* chWorkSheet:Range("I2"):Value = "Fecha Inicio".              */
/* chWorkSheet:Range("J2"):Value = "Fecha de Cese".             */

t-column = t-column + 2.
FOR EACH tt-datos NO-LOCK,
    FIRST TabAreas WHERE TabAreas.CodCia = s-codcia
        AND TabAreas.CodArea = t-codare NO-LOCK
        BREAK BY tt-datos.t-codare:

    IF FIRST-OF(t-codare) THEN DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + t-codare.
        chWorkSheet:Range(cRange):Font:Bold = TRUE.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = TabAreas.DesArea.
        chWorkSheet:Range(cRange):Font:Bold = TRUE.

        t-column = t-column + 2.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "Código".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Ap. Paterno".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "Ap. Materno".
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "Nombres".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "Cargo".
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "Sueldo Básico".
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "Prestaciones Alimentarias".
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = "Fecha de Ingreso".
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "Fecha Inicio".
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = "Fecha de Cese".
    END.

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + t-codper.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-patper.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = t-matper.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = t-nomper.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = t-cargo.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = t-monto1.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = t-monto2.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = t-fching.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = t-fecini.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = t-fecfin.

    IF LAST-OF(t-codare) THEN t-column = t-column + 1.

    DISPLAY 'GENERANDO EXCEL...' @ x-mensaje 
        WITH FRAME {&FRAME-NAME}.

END.

DISPLAY '' @ x-mensaje WITH FRAME {&FRAME-NAME}.

MESSAGE
    "Proceso Terminado con Satisfactoriamente"
    VIEW-AS ALERT-BOX INFORMA.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


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
  DEFINE VARIABLE iInt AS INTEGER     NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH tabareas WHERE tabareas.codcia = s-codcia NO-LOCK:
          cb-areas:ADD-LAST(TabAreas.CodArea + '-' + TabAreas.DesArea).
      END.

      DO iInt = 0 TO 4:
          cb-periodo:ADD-LAST(STRING((s-periodo - iInt),'9999')).
      END.
      DO iInt = 1 TO 12:
          cb-nromes:ADD-LAST(STRING(iint,'99')).
      END.
      
      ASSIGN 
          cb-periodo = STRING(s-periodo,'9999')
          cb-nromes  = STRING(s-nromes,'99').
      DISPLAY 
          cb-periodo
          cb-nromes.
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

