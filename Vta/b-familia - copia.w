&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
IF NOT connected('cissac')
    THEN CONNECT -db integral -ld cissac -N TCP -S 65030 -H 192.168.100.210 NO-ERROR.
    /*THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.*/
IF ERROR-STATUS:ERROR THEN DO:
  MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
      'NO podemos capturar el stock (2)'
      VIEW-AS ALERT-BOX WARNING.
END.


DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

DEF TEMP-TABLE Detalle LIKE integral.Almmmatg
    FIELD StockConti   AS DEC EXTENT 30
    FIELD StockCissac  AS DEC EXTENT 30
    FIELD CtoUniConti  AS DEC 
    FIELD CtoUniCissac AS DEC    
/*RD01- Stock Comprometido*/
    FIELD StockComp    AS DEC EXTENT 7
    FIELD MndCosto     AS CHAR
    FIELD CtoLista     LIKE integral.almmmatg.ctolis.

DEF VAR x-AlmConti AS CHAR NO-UNDO.
DEF VAR x-AlmCissac AS CHAR NO-UNDO.

ASSIGN
    x-AlmConti = '10,10a,11,21,22,40,40a,17,18,03,04,05,45,45s,27,83b,35,35a,500,501,85'
    x-AlmCissac = '11,22,40,40a,45,45s,27,85'.

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
&Scoped-define INTERNAL-TABLES Almtfami

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almtfami.desfam Almtfami.codfam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH Almtfami WHERE ~{&KEY-PHRASE} ~
      AND almtfami.codcia = 1 NO-LOCK ~
    BY Almtfami.desfam
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almtfami WHERE ~{&KEY-PHRASE} ~
      AND almtfami.codcia = 1 NO-LOCK ~
    BY Almtfami.desfam.
&Scoped-define TABLES-IN-QUERY-br_table Almtfami
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almtfami


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS f-mensaje 

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
DEFINE VARIABLE f-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almtfami SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almtfami.desfam FORMAT "X(30)":U WIDTH 40.57
      Almtfami.codfam FORMAT "X(3)":U WIDTH 6.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 51.14 BY 6.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.27 COL 6.86
     f-mensaje AT ROW 8.23 COL 9.43 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 9.27
         WIDTH              = 77.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:SELECTABLE IN FRAME F-Main             = TRUE.

/* SETTINGS FOR FILL-IN f-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almtfami"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.Almtfami.desfam|yes"
     _Where[1]         = "integral.almtfami.codcia = 1"
     _FldNameList[1]   > INTEGRAL.Almtfami.desfam
"desfam" ? ? "character" ? ? ? ? ? ? no ? no no "40.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almtfami.codfam
"codfam" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal B-table-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Orden AS INT NO-UNDO INIT 1.
  DEF VAR x-CanPed AS DEC NO-UNDO.

  DEF VAR iCont AS INT INIT 0.
  DEF VAR iTCont AS INT INIT 0.
  DEF VAR cComa AS CHARACTER.
  DEF VAR cFami AS CHARACTER.

  DEF VAR X-codfam AS CHARACTER.

  DEF VAR pComprometido AS DECIMAL NO-UNDO.
  DEF VAR cCodAlm1 AS CHAR NO-UNDO.
  DEF VAR cCodAlm2 AS CHAR NO-UNDO.
  DEF VAR cCodAlm3 AS CHAR NO-UNDO.
  DEF VAR cCodAlm4 AS CHAR NO-UNDO.
  DEF VAR cCodAlm5 AS CHAR NO-UNDO.
  DEF VAR cCodAlm6 AS CHAR NO-UNDO.

  /*Caso expolibreria*/
  cCodAlm1 = "40".
  cCodAlm2 = "45".
  cCodAlm3 = "35a".
  cCodAlm4 = "35".
  cCodAlm5 = "11".
  cCodAlm6 = "22".


  IF NOT connected('cissac')
      THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
        'NO podemos capturar el stock'
        VIEW-AS ALERT-BOX WARNING.
  END.
  /*LOOKUP*/
  EMPTY TEMP-TABLE detalle.

  /* Familias Seleccionadas */
  x-codfam = "".
  cComa = "".
  DO WITH FRAME {&FRAME-NAME}:
    /*DO iCont = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:*/
    iTCont = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO iCont = 1 TO iTCont :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(icont) THEN DO:
                cFami = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codfam.
                X-codfam = x-codfam + cComa + cFami.
                cComa = ",".
        END.
    END.
  END.

  /* STOCKS CONTI */
  DO x-Orden = 1 TO NUM-ENTRIES(x-AlmConti):
      FOR EACH integral.almmmate NO-LOCK WHERE integral.almmmate.codcia = s-codcia
          AND integral.almmmate.codalm = ENTRY(x-Orden, x-AlmConti)
          AND integral.almmmate.stkact <> 0,
          /*FIRST integral.almmmatg OF integral.almmmate NO-LOCK WHERE integral.almmmatg.codfam = x-codfam:*/
          FIRST integral.almmmatg OF integral.almmmate NO-LOCK WHERE lookup(integral.almmmatg.codfam,x-codfam) > 0:
          DO WITH FRAME {&FRAME-NAME}:
            f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Conti >> ' +
                integral.almmmatg.codmat + ' ' +
                 integral.almmmatg.desmat.
          END.
          FIND detalle OF integral.almmmatg EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO: 
              CREATE detalle.
              BUFFER-COPY integral.almmmatg TO detalle.
              FIND integral.gn-prov WHERE integral.gn-prov.codcia = pv-codcia
                  AND integral.gn-prov.codpro = integral.almmmatg.codpr1
                  NO-LOCK NO-ERROR.
              IF AVAILABLE integral.gn-prov THEN detalle.codpr1 = integral.gn-prov.codpro + ' ' + integral.gn-prov.nompro.
          END.
          ASSIGN 
          Detalle.StockConti[x-Orden] = integral.Almmmate.stkact + Detalle.StockConti[x-Orden]
          Detalle.CtoLista            = integral.Almmmatg.CtoLis.
          IF integral.almmmatg.monvta = 1 THEN Detalle.MndCosto = "S/.".
          ELSE Detalle.MndCosto = "$".
      END.
  END.
  /* STOCKS CISSAC */
  DO x-Orden = 1 TO NUM-ENTRIES(x-AlmCissac):
      FOR EACH cissac.almmmate NO-LOCK WHERE cissac.almmmate.codcia = s-codcia
          AND cissac.almmmate.codalm = ENTRY(x-Orden, x-AlmCissac)
          AND cissac.almmmate.stkact <> 0,
          /*FIRST cissac.almmmatg OF cissac.almmmate NO-LOCK WHERE cissac.almmmatg.codfam = x-codfam:*/
          FIRST cissac.almmmatg OF cissac.almmmate NO-LOCK WHERE lookup(cissac.almmmatg.codfam,x-codfam) > 0 :
          f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Conti >> ' +
              cissac.almmmatg.codmat + ' ' +
              cissac.almmmatg.desmat.
          FIND detalle OF cissac.almmmatg EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              BUFFER-COPY cissac.almmmatg TO detalle.
              FIND cissac.gn-prov WHERE cissac.gn-prov.codcia = pv-codcia
                  AND cissac.gn-prov.codpro = cissac.almmmatg.codpr1
                  NO-LOCK NO-ERROR.
              IF AVAILABLE cissac.gn-prov THEN detalle.codpr1 = cissac.gn-prov.codpro + ' ' + cissac.gn-prov.nompro.
          END.
          ASSIGN 
              Detalle.StockCissac[x-Orden] = cissac.Almmmate.stkact + Detalle.StockCissac[x-Orden] .

          IF Detalle.CtoLista <= 0 THEN DO:
              ASSIGN Detalle.CtoLista  = cissac.Almmmatg.CtoLis.
              IF cissac.almmmatg.monvta = 1 THEN Detalle.MndCosto = "S/.".
              ELSE Detalle.MndCosto = "$".
          END.
      END.
  END.
  /* COSTO PROMEDIO */
  FOR EACH Detalle:
      FIND LAST integral.almstkge WHERE integral.almstkge.codcia = s-codcia
          AND integral.almstkge.codmat = detalle.codmat
          AND integral.almstkge.fecha <= TODAY
          NO-LOCK NO-ERROR.
      IF AVAILABLE integral.almstkge THEN detalle.ctouniconti = INTEGRAL.AlmStkge.CtoUni.
      FIND LAST cissac.almstkge WHERE cissac.almstkge.codcia = s-codcia
          AND cissac.almstkge.codmat = detalle.codmat
          AND cissac.almstkge.fecha <= TODAY
          NO-LOCK NO-ERROR.
      IF AVAILABLE cissac.almstkge THEN detalle.ctounicissac = cissac.AlmStkge.CtoUni.
      /*Calculo Stock Comprometido*/
      RUN vtagn/stock-comprometido (Detalle.codmat, cCodAlm1, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[1] = pComprometido.

      RUN vtagn/stock-comprometido (Detalle.codmat, cCodAlm2, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[2] = pComprometido.

      RUN vtagn/stock-comprometido (Detalle.codmat, cCodAlm3, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[3] = pComprometido.

      RUN vtagn/stock-comprometido (Detalle.codmat, cCodAlm4, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[4] = pComprometido.

      RUN vtagn/stock-comprometido (Detalle.codmat, cCodAlm5, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[5] = pComprometido.

      RUN vtagn/stock-comprometido (Detalle.codmat, cCodAlm6, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[6] = pComprometido.
  END.
  
  f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excel B-table-Win 
PROCEDURE excel :
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
chWorkSheet:Range("G2"):Value = "Proveedor".

t-Letra = ASC('H').
t-column = 2.
cLetra2 = ''.

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
cColumn = STRING(t-Column).
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Cto. Prom. Conti".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
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
cColumn = STRING(t-Column).
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Cto. Prom. Cissac".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stock Comprometido Alm 40".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stock Comprometido Alm 45".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stock Comprometido Alm 35a".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stock Comprometido Alm 35".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stock Comprometido Alm 11".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stock Comprometido Alm 22".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Mnd".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Costo (Sin I.G.V)".

loopREP:
FOR EACH Detalle BY Detalle.CodMat:
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
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodPr1.
    
    t-Letra = ASC('H').
    cLetra2 = ''.
    xOrden = 1.
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
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoUniConti.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
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
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoUniCissac.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[1].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[2].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[3].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[4].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[5].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[6].

    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.MndCosto.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoLista.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */
    CASE HANDLE-CAMPO:name:
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.


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
  {src/adm/template/snd-list.i "Almtfami"}

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

