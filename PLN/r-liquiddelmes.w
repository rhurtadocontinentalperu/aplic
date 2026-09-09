&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MOV-MES FOR PL-MOV-MES.



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

DEF VAR x-Meses AS CHAR INIT "ENERO,FEBRERO,MARZO,ABRIL,MAYO,JUNIO,JULIO,AGOSTO,SETIEMBRE,~
    OCTUBRE,NOVIEMBRE,DICIEMBRE" NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS cb-periodo cb-nromes BUTTON-4 BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS cb-periodo cb-nromes x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBoleta W-Win 
FUNCTION fBoleta RETURNS DECIMAL
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDevQuinta W-Win 
FUNCTION fDevQuinta RETURNS DECIMAL
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE VARIABLE cb-nromes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
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
     cb-periodo AT ROW 1.38 COL 14 COLON-ALIGNED WIDGET-ID 4
     cb-nromes AT ROW 2.54 COL 14 COLON-ALIGNED WIDGET-ID 6
     x-mensaje AT ROW 3.88 COL 7 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-4 AT ROW 4.85 COL 69 WIDGET-ID 10
     BUTTON-5 AT ROW 4.85 COL 80 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.72 BY 5.69 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MOV-MES B "?" ? INTEGRAL PL-MOV-MES
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "LIQUIDACIONES DEL MES"
         HEIGHT             = 5.69
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
ON END-ERROR OF W-Win /* LIQUIDACIONES DEL MES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* LIQUIDACIONES DEL MES */
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
    ASSIGN cb-nromes cb-periodo.
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
  DISPLAY cb-periodo cb-nromes x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cb-periodo cb-nromes BUTTON-4 BUTTON-5 
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

DEFINE VAR lxFiler AS DEC.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

SESSION:SET-WAIT-STATE('GENERAL').

/*set the column names for the Worksheet*/
chWorkSheet:Range("A1"):Value = "LIQUIDACIONES DEL MES DE " + TRIM(ENTRY(INTEGER(cb-nromes), x-Meses)) + " " + cb-periodo.
chWorkSheet:Range("A2"):Value = "Código".
chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:Range("B2"):Value = "Ap. Paterno".
chWorkSheet:Range("C2"):Value = "Ap. Materno".
chWorkSheet:Range("D2"):Value = "Nombres".
chWorkSheet:Range("E2"):Value = "Cargo".
chWorkSheet:Range("F2"):Value = "Area".
chWorkSheet:Range("G2"):Value = "Fecha Ing".
chWorkSheet:COLUMNS("G"):NumberFormat = "dd/MM/yyyy".
chWorkSheet:Range("H2"):Value = "Fecha Cese".
chWorkSheet:COLUMNS("H"):NumberFormat = "dd/MM/yyyy".
chWorkSheet:Range("I2"):Value = "CTS".
chWorkSheet:Range("J2"):Value = "Vac. Truncas".
chWorkSheet:Range("K2"):Value = "SNP".
chWorkSheet:Range("L2"):Value = "AFP".
chWorkSheet:Range("M2"):Value = "Cta. Cte.".
chWorkSheet:Range("N2"):Value = "Ret. Jud.".
chWorkSheet:Range("O2"):Value = "Gratif. Truncas".
chWorkSheet:Range("P2"):Value = "Bonif. Extr.".
chWorkSheet:Range("Q2"):Value = "Importe Neto".
chWorkSheet:Range("R2"):Value = "Boleta".
chWorkSheet:Range("S2"):Value = "Devol. Renta 5ta.".
chWorkSheet:Range("T2"):Value = "TOTAL".

DEF VAR x-AFP AS DEC NO-UNDO.
DEF VAR x-Total AS DEC NO-UNDO.

DISPLAY 'GENERANDO EXCEL...' @ x-mensaje WITH FRAME {&FRAME-NAME}.
FOR EACH pl-mov-mes NO-LOCK WHERE pl-mov-mes.codcia = s-codcia
    AND pl-mov-mes.periodo = INTEGER(cb-periodo)
    AND pl-mov-mes.nromes = INTEGER(cb-nromes)
    AND PL-MOV-MES.codpln = 01
    AND PL-MOV-MES.codcal = 005,
    FIRST pl-flg-mes OF pl-mov-mes NO-LOCK,
    FIRST pl-pers NO-LOCK WHERE pl-pers.codper = pl-flg-mes.codper
    BREAK BY pl-mov-mes.codper BY pl-mov-mes.codmov:
    IF FIRST-OF(pl-mov-mes.codper) THEN DO:
        x-Afp = 0.
        x-Total = 0.
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.codper.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.patper.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.matper.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.nomper.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.cargo.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.seccion.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.fecing.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.vcontr.
    END.
    CASE pl-mov-mes.codmov:
    WHEN 114 THEN DO:
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-mov-mes.valcal-mes.
    END.
    WHEN 431 THEN DO:
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-mov-mes.valcal-mes.
    END.
    WHEN 202 THEN DO:
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-mov-mes.valcal-mes.
    END.
    WHEN 221 OR WHEN 222 OR WHEN 225 THEN DO:
        x-Afp = x-Afp + pl-mov-mes.valcal-mes.
    END.
    WHEN 217 THEN DO:
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-mov-mes.valcal-mes.
    END.
    WHEN 139 THEN DO:
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-mov-mes.valcal-mes.
    END.
    WHEN 144 THEN DO:
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-mov-mes.valcal-mes.
    END.
    WHEN 704 THEN DO:
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-mov-mes.valcal-mes.
        x-Total = x-Total + pl-mov-mes.valcal-mes.
    END.
    END CASE.
    IF LAST-OF(pl-mov-mes.codper) THEN DO:
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = x-Afp.

        lxFiler = 0.
        lxFiler = fBoleta(pl-mov-mes.codper).
        lxFiler = IF(lxFiler = ?) THEN 0 ELSE lxFiler.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = lxFiler.
        x-Total = x-Total + lxFiler. /*fBoleta(pl-mov-mes.codper).*/

        lxFiler = 0.
        lxFiler = fDevQuinta(pl-mov-mes.codper).
        lxFiler = IF(lxFiler = ?) THEN 0 ELSE lxFiler.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = lxFiler.
        x-Total = x-Total + lxFiler. /*fDevQuinta(pl-mov-mes.codper).*/
    END.
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Total.

END.
DISPLAY '' @ x-mensaje WITH FRAME {&FRAME-NAME}.
SESSION:SET-WAIT-STATE('').

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBoleta W-Win 
FUNCTION fBoleta RETURNS DECIMAL
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF PL-FLG-MES.cnpago = "EFECTIVO" THEN RETURN 0.00.

FIND B-MOV-MES WHERE B-MOV-MES.codcia = s-codcia
    AND B-MOV-MES.codper = pCodPer
    AND B-MOV-MES.periodo = INTEGER(cb-periodo)
    AND B-MOV-MES.nromes = INTEGER(cb-nromes)
    AND B-MOV-MES.codcal = 001
    AND B-MOV-MES.codmov = 403
    NO-LOCK NO-ERROR.
IF AVAILABLE B-MOV-MES THEN RETURN B-MOV-MES.valcal-mes.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDevQuinta W-Win 
FUNCTION fDevQuinta RETURNS DECIMAL
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR Y-UIT AS DEC INIT 0 NO-UNDO.
    DEFINE VAR UIT-27 AS DEC INIT 0 NO-UNDO.
    DEFINE VAR UIT-54 AS DEC INIT 0 NO-UNDO.
    DEFINE VAR RBRUTA AS DEC INIT 0 NO-UNDO.
    DEFINE VAR Renta-Imponible AS DEC INIT 0 NO-UNDO.
    DEFINE VAR SALDO AS DEC INIT 0 NO-UNDO.

    FIND LAST PL-VAR-MES WHERE PL-VAR-MES.Periodo = INTEGER(cb-periodo)
        AND PL-VAR-MES.NroMes  = INTEGER(cb-nromes) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-var-mes THEN RETURN 0.00.
    Y-UIT = PL-VAR-MES.ValVar-Mes[2] * 7 .
    UIT-27 = Y-UIT / 7 * 27.
    UIT-54 = Y-UIT / 7 * 54.

    FOR EACH B-MOV-MES NO-LOCK WHERE B-MOV-MES.codcia = s-codcia
        AND B-MOV-MES.codper = pCodPer
        AND B-MOV-MES.periodo = INTEGER(cb-periodo)
        AND B-MOV-MES.nromes <= INTEGER(cb-nromes)
        AND B-MOV-MES.codcal = 001
        AND B-MOV-MES.codmov = 405:
        RBRUTA = RBRUTA + B-MOV-MES.valcal-mes.
    END.
    FOR EACH B-MOV-MES NO-LOCK WHERE B-MOV-MES.codcia = s-codcia
        AND B-MOV-MES.codper = pCodPer
        AND B-MOV-MES.periodo = INTEGER(cb-periodo)
        AND B-MOV-MES.nromes <= INTEGER(cb-nromes)
        AND B-MOV-MES.codcal = 004:
        IF B-MOV-MES.codmov = 212 THEN RBRUTA = RBRUTA + B-MOV-MES.valcal-mes.
        IF B-MOV-MES.codmov = 144 THEN RBRUTA = RBRUTA + B-MOV-MES.valcal-mes.
    END.
    FOR EACH B-MOV-MES NO-LOCK WHERE B-MOV-MES.codcia = s-codcia
        AND B-MOV-MES.codper = pCodPer
        AND B-MOV-MES.periodo = INTEGER(cb-periodo)
        AND B-MOV-MES.nromes <= INTEGER(cb-nromes)
        AND B-MOV-MES.codcal = 000
        AND B-MOV-MES.codmov = 137:
        RBRUTA = RBRUTA + B-MOV-MES.valcal-mes.
    END.
    IF RBRUTA < Y-UIT THEN Renta-Imponible = 0.
    ELSE Renta-Imponible = RBRUTA - Y-UIT.

    IF Renta-Imponible <= uit-27 THEN SALDO = Renta-Imponible * 0.15.
    ELSE IF Renta-Imponible <= uit-54 THEN SALDO = (uit-27 * 0.15) + ((Renta-Imponible - uit-27) * 0.21).
    ELSE SALDO = (uit-27 * 0.15) + (uit-27 * 0.21) + ((Renta-Imponible - uit-54) * 0.30).
    SALDO = ROUND(SALDO, 0).

    FOR EACH B-MOV-MES NO-LOCK WHERE B-MOV-MES.codcia = s-codcia
        AND B-MOV-MES.codper = pCodPer
        AND B-MOV-MES.periodo = INTEGER(cb-periodo)
        AND B-MOV-MES.nromes <= INTEGER(cb-nromes)
        AND B-MOV-MES.codcal = 001
        AND B-MOV-MES.codmov = 215:
        SALDO = SALDO - B-MOV-MES.valcal-mes.
    END.
    RETURN ABSOLUTE(SALDO).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

