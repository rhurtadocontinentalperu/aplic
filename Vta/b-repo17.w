&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE CPedi LIKE INTEGRAL.FacCPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'COT' NO-UNDO.

DEF TEMP-TABLE Detalle LIKE integral.Almmmatg
    FIELD Saldo AS DEC
    FIELD SaldoPed AS DEC EXTENT 50
    FIELD StockConti AS DEC EXTENT 25
    FIELD StockCissac AS DEC EXTENT 25
    FIELD CtoUniConti AS DEC
    FIELD CtoUniCissac AS DEC.

/*
DEF VAR x-AlmConti AS CHAR NO-UNDO.
DEF VAR x-AlmCissac AS CHAR NO-UNDO.

ASSIGN
    x-AlmConti = '11,22,22a,130,35a,36a,40,40a,40c,15,17,18,03,03c,04,05,05c,42,42a,42b,83b'
    x-AlmCissac = '11,22,22a,130,40,40a,15,42'.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CPedi.NroPed CPedi.FchPed ~
CPedi.fchven CPedi.CodCli CPedi.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table CPedi.NroPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table CPedi
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table CPedi
&Scoped-define QUERY-STRING-br_table FOR EACH CPedi WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CPedi WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CPedi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-almconti x-almcissac br_table 
&Scoped-Define DISPLAYED-OBJECTS x-almconti x-almcissac 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE x-almcissac AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes StandFord" 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

DEFINE VARIABLE x-almconti AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes Continental" 
     VIEW-AS FILL-IN 
     SIZE 59 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CPedi.NroPed COLUMN-LABEL "Cotizacion" FORMAT "X(9)":U
      CPedi.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      CPedi.fchven COLUMN-LABEL "Vencimiento" FORMAT "99/99/99":U
      CPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U
      CPedi.NomCli FORMAT "x(40)":U
  ENABLE
      CPedi.NroPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 90 BY 14.81
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-almconti AT ROW 1.27 COL 17 COLON-ALIGNED WIDGET-ID 6
     x-almcissac AT ROW 2.15 COL 17 COLON-ALIGNED WIDGET-ID 8
     br_table AT ROW 5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: CPedi T "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 19.27
         WIDTH              = 93.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table x-almcissac F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.CPedi"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.CPedi.NroPed
"CPedi.NroPed" "Cotizacion" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.CPedi.FchPed
"CPedi.FchPed" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.CPedi.fchven
"CPedi.fchven" "Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.CPedi.CodCli
"CPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.CPedi.NomCli
"CPedi.NomCli" ? "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ASSIGN 
    x-almconti = '11,22,22a,130,35a,36a,40,40a,40c,15,17,18,03,03c,04,05,05c,42,42a,42b,83b'
    x-almcissac = '11,22,22a,130,40,40a,15,42'.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Orden AS INT NO-UNDO INIT 1.
  DEF VAR x-CanPed AS DEC NO-UNDO.

  FOR EACH Detalle:
      DELETE Detalle.
  END.
  /* SALDO DE PEDIDOS */
  FOR EACH CPEDI BY CPEDI.NroPed:
      FOR EACH integral.Facdpedi OF CPEDI NO-LOCK WHERE CanPed - CanAte > 0, 
            FIRST integral.Almmmatg OF integral.Facdpedi NO-LOCK:
          FIND Detalle WHERE Detalle.codmat = integral.Facdpedi.codmat
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE Detalle THEN DO:
              CREATE Detalle.
              BUFFER-COPY integral.Almmmatg TO Detalle.
          END.
          ASSIGN
              x-CanPed = (integral.Facdpedi.canped - integral.Facdpedi.canate) * integral.Facdpedi.factor
              Detalle.Saldo = Detalle.Saldo + x-CanPed
              Detalle.SaldoPed[x-Orden] = x-CanPed.
      END.
      x-Orden = x-Orden + 1.
  END.

  /* STOCKS CONTI */
  DO x-Orden = 1 TO NUM-ENTRIES(x-AlmConti):
      FOR EACH Detalle:
          FIND integral.Almmmate WHERE integral.Almmmate.codcia = s-codcia
              AND integral.Almmmate.codalm = ENTRY(x-Orden, x-AlmConti)
              AND integral.Almmmate.codmat = Detalle.codmat
              NO-LOCK NO-ERROR.
          IF AVAILABLE integral.Almmmate THEN Detalle.StockConti[x-Orden] = integral.Almmmate.stkact.
      END.
  END.
  /* STOCKS CISSAC */
  IF CONNECTED('cissac') THEN DO:
      DO x-Orden = 1 TO NUM-ENTRIES(x-AlmCissac):
          FOR EACH Detalle:
              FIND cissac.Almmmate WHERE cissac.Almmmate.codcia = s-codcia
                  AND cissac.Almmmate.codalm = ENTRY(x-Orden, x-AlmCissac)
                  AND cissac.Almmmate.codmat = Detalle.codmat
                  NO-LOCK NO-ERROR.
              IF AVAILABLE cissac.Almmmate THEN Detalle.StockCissac[x-Orden] = cissac.Almmmate.stkact.
          END.
      END.
  END.
  
/*   /* COSTO PROMEDIO */                                                                    */
/*   FOR EACH Detalle:                                                                       */
/*       FIND LAST integral.almstkge WHERE integral.almstkge.codcia = s-codcia               */
/*           AND integral.almstkge.codmat = detalle.codmat                                   */
/*           AND integral.almstkge.fecha <= TODAY                                            */
/*           NO-LOCK NO-ERROR.                                                               */
/*       IF AVAILABLE integral.almstkge THEN detalle.ctouniconti = INTEGRAL.AlmStkge.CtoUni. */
/*       FIND LAST cissac.almstkge WHERE cissac.almstkge.codcia = s-codcia                   */
/*           AND cissac.almstkge.codmat = detalle.codmat                                     */
/*           AND cissac.almstkge.fecha <= TODAY                                              */
/*           NO-LOCK NO-ERROR.                                                               */
/*       IF AVAILABLE cissac.almstkge THEN detalle.ctouniconti = cissac.AlmStkge.CtoUni.     */
/*   END.                                                                                    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
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
DEFINE VARIABLE t-Column                AS INTEGER.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE cLetra                  AS CHAR.
DEFINE VARIABLE cLetra2                 AS CHAR.
DEFINE VARIABLE xOrden                  AS INT.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        x-almconti
        x-almcissac.
END.

RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A2"):Value = "Material".
chWorkSheet:Range("B2"):Value = "Descripcion".
chWorkSheet:Range("C2"):Value = "Marca".
chWorkSheet:Range("D2"):Value = "Unidad".
chWorkSheet:Range("E2"):Value = "Linea".
chWorkSheet:Range("F2"):Value = "Sub-linea".
chWorkSheet:Range("G2"):Value = "Saldo".
t-Letra = ASC('H').
t-column = 2.
cLetra2 = ''.
FOR EACH CPEDI BY CPEDI.NroPed:
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + CPEDI.NroPed.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
END.
DO xOrden = 1 TO NUM-ENTRIES(x-AlmConti):
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + ENTRY(xOrden, x-AlmConti).
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.

END.
DO xOrden = 1 TO NUM-ENTRIES(x-AlmCissac):
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + ENTRY(xOrden, x-AlmCissac).
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.

END.

loopREP:
FOR EACH Detalle BREAK BY Detalle.CodMat:
    t-column = t-column + 1.
    /* DATOS DEL PRODUCTO */    
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.UndBas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodFam.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.SubFam.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Saldo.
    
    t-Letra = ASC('H').
    cLetra2 = ''.
    xOrden = 1.
    FOR EACH CPEDI BY CPEDI.NroPed:
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.SaldoPed[xOrden].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
        xOrden = xOrden + 1.
    END.
    DO xOrden = 1 TO NUM-ENTRIES(x-AlmConti):
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockConti[xOrden].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
    END.
    DO xOrden = 1 TO NUM-ENTRIES(x-AlmCissac):
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockCissac[xOrden].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
    END.
END.    
iCount = iCount + 2.

HIDE FRAME f-mensajes NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  BUFFER-COPY integral.Faccpedi TO CPEDI.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CPedi"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND LAST integral.Faccpedi WHERE integral.Faccpedi.codcia = s-codcia 
      /*AND integral.Faccpedi.coddiv = s-coddiv*/
      AND integral.Faccpedi.coddoc = s-coddoc   
      AND integral.Faccpedi.nroped = CPedi.NroPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND integral.Faccpedi.flgest <> "A"
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE integral.Faccpedi THEN DO:
      MESSAGE 'Cotización NO registrado' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /*Considerar todas las cotizaciones menos las anuladas*/
  IF integral.Faccpedi.flgest = 'A' THEN DO:
      MESSAGE 'Cotización Anulada' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  /***
  IF integral.Faccpedi.flgest <> 'P' THEN DO:
      MESSAGE 'Cotización NO esta pendiente de atender' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  ***/
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

