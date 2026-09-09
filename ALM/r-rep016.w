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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.


DEF VAR x-Almacenes AS CHAR NO-UNDO.


DEF TEMP-TABLE Detalle
    FIELD codmat LIKE Almmmatg.codmat
    FIELD desmat LIKE Almmmatg.desmat
    FIELD desmar LIKE Almmmatg.desmar
    FIELD codfam LIKE Almmmatg.codfam
    FIELD subfam LIKE Almmmatg.subfam
    FIELD undbas AS CHAR FORMAT 'x(7)'   /*LIKE Almmmatg.UndBas*/
    FIELD codpro LIKE Almmmatg.codpr1
    FIELD nompro LIKE gn-prov.nompro
    FIELD codmon AS CHAR
    FIELD tpocmb LIKE almmmatg.tpocmb
    FIELD preuni LIKE almmmatg.preofi
    FIELD stkgen AS DEC
    FIELD stkalm AS DEC EXTENT 200.

DEF TEMP-TABLE Detalle2 LIKE Detalle.

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
&Scoped-Define ENABLED-OBJECTS x-FchCie x-Familias x-CodPro RADIO-SET-1 ~
TOGGLE-1 TOGGLE-2 BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS x-FchCie x-Familias x-CodPro x-NomPro ~
RADIO-SET-1 TOGGLE-1 TOGGLE-2 f-Mensaje 

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
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 8 BY 1.62.

DEFINE VARIABLE x-Familias AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Familias" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "x(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchCie AS DATE FORMAT "99/99/99":U 
     LABEL "A la fecha" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cantidades", 1,
"Valor promedio", 2
     SIZE 35 BY 1.08 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Resumido por proveedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-2 AS LOGICAL INITIAL no 
     LABEL "Solo stock contable" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-FchCie AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     x-Familias AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 8
     x-CodPro AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 12
     x-NomPro AT ROW 3.42 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     RADIO-SET-1 AT ROW 4.5 COL 21 NO-LABEL WIDGET-ID 16
     TOGGLE-1 AT ROW 5.85 COL 21 WIDGET-ID 20
     TOGGLE-2 AT ROW 6.92 COL 21 WIDGET-ID 22
     BUTTON-1 AT ROW 8.27 COL 11 WIDGET-ID 4
     BtnDone AT ROW 8.27 COL 21 WIDGET-ID 10
     f-Mensaje AT ROW 10.15 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 110 BY 10.73 WIDGET-ID 100.


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
         TITLE              = "REPORTE DE STOCKS POR ALMACENES VS CONTABLE"
         HEIGHT             = 10.73
         WIDTH              = 110
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 110
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 110
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE STOCKS POR ALMACENES VS CONTABLE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE STOCKS POR ALMACENES VS CONTABLE */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN x-fchcie x-Familias RADIO-SET-1 TOGGLE-1 TOGGLE-2 x-CodPro.
  IF x-FchCie >= TODAY THEN DO:
      MESSAGE 'Fecha errada' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Imprimir.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
  x-NomPro:SCREEN-VALUE = ''.
  FIND gn-prov WHERE codcia = pv-codcia
      AND codpro = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN x-nompro:SCREEN-VALUE =  gn-prov.NomPro.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* VARIABLES DEL REPORTE */
DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR x-CodFam AS CHAR NO-UNDO.
DEF VAR x-StkAlm AS DEC  NO-UNDO.
DEF VAR x-Item   AS INT  NO-UNDO.
DEF VAR x-moneda AS CHAR NO-UNDO.

FOR EACH Detalle:
    DELETE Detalle.
END.

FOR EACH Detalle2:
    DELETE Detalle2.
END.

/* DEFINIMOS TODOS LOS ALMACENES DE LA EMPRESA */
x-Almacenes = ''.
FOR EACH Almacen NO-LOCK WHERE codcia = s-codcia:
    /* Almacenes que NO son propios */
    IF Almacen.FlgRep = NO THEN NEXT.
    /* RHC 09.09.04 EL ALMACEN DE CONSIGN. NO TIENE MOVIMIENTO CONTABLE  */
    IF Almacen.AlmCsg = YES THEN NEXT.

    IF x-Almacenes = '' THEN x-Almacenes = TRIM(Almacen.codalm).
    ELSE x-Almacenes = x-Almacenes + ',' + TRIM(Almacen.codalm).
END.

IF TOGGLE-2 = YES THEN x-Almacenes = ''.

IF x-Familias <> 'Todas' THEN DO:
    x-CodFam = SUBSTRING(x-Familias, 1, INDEX(x-Familias, ' - ') - 1).
END.

/* BARREMOS TODOS LOS PRODUCTOS */
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND (x-Familias = 'Todas' OR Almmmatg.codfam = x-codfam)
    AND Almmmatg.codpr1 BEGINS x-CodPro
    BY Almmmatg.codmat:
    /* VERIFICAMOS SI HAY STOCK A ESA FECHA */
    x-StkAlm = 0.
    VERIFICA:
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
        AND LOOKUP(Almacen.codalm, x-Almacenes) > 0:
        FIND LAST Almstkal WHERE Almstkal.codcia = s-codcia
            AND Almstkal.codalm = Almacen.codalm
            AND Almstkal.codmat = Almmmatg.codmat
            AND Almstkal.fecha <= x-FchCie
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkal AND Almstkal.stkact <> 0 THEN DO:
            x-StkAlm = Almstkal.stkact.
            LEAVE VERIFICA.
        END.
    END.
    IF x-StkAlm = 0 THEN NEXT.
    /* *********************************** */
    IF almmmatg.monvta = 1 THEN x-moneda = "S/.".
    ELSE x-moneda = "$".

    /* *********************************** */
    CREATE Detalle.
    ASSIGN
        detalle.codmat = Almmmatg.codmat
        detalle.desmat = Almmmatg.desmat
        detalle.desmar = Almmmatg.desmar
        detalle.codfam = Almmmatg.codfam
        detalle.subfam = Almmmatg.subfam
        detalle.undbas = Almmmatg.undbas
        detalle.codmon = x-moneda
        detalle.tpocmb = almmmatg.tpocmb
        detalle.preuni = Almmmatg.preofi
        detalle.codpro = Almmmatg.codpr1.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN detalle.nompro = gn-prov.nompro.

    /* STOCKS POR ALMACEN */
    FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
        AND Almstkge.codmat = Almmmatg.codmat
        AND Almstkge.fecha <= x-FchCie
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkge THEN DO:
        IF RADIO-SET-1 = 1 
        THEN detalle.stkgen = AlmStkge.StkAct.
        ELSE detalle.stkgen = AlmStkge.StkAct * AlmStkge.CtoUni.
    END.
    DO x-Item = 1 TO NUM-ENTRIES(x-Almacenes):
        x-CodAlm = ENTRY(x-Item, x-Almacenes).
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Codigo: ' + Almmmatg.codmat + '  Almacen: ' + x-codalm.
        FIND LAST Almstkal WHERE Almstkal.codcia = s-codcia
            AND Almstkal.codalm = x-CodAlm
            AND Almstkal.codmat = Almmmatg.codmat
            AND Almstkal.fecha <= x-FchCie
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkal THEN DO:
            IF RADIO-SET-1 = 1 
            THEN detalle.stkalm[x-Item] = AlmStkal.StkAct.
            ELSE IF AVAILABLE AlmStkge THEN detalle.stkalm[x-Item] = AlmStkal.StkAct * AlmStkge.CtoUni.
        END.
    END.
END.

IF TOGGLE-1 = YES THEN DO:
    FOR EACH Detalle:
        FIND Detalle2 WHERE Detalle2.codpro = Detalle.codpro EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle2 THEN CREATE Detalle2.
        ASSIGN
            Detalle2.codpro = Detalle.codpro
            Detalle2.nompro = Detalle.nompro
            Detalle2.stkgen = Detalle2.stkgen + Detalle.stkgen.
        DO x-Item = 1 TO NUM-ENTRIES(x-Almacenes):
            Detalle2.stkalm[x-Item] = Detalle2.stkalm[x-Item] + detalle.stkalm[x-Item].
        END.
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
  DISPLAY x-FchCie x-Familias x-CodPro x-NomPro RADIO-SET-1 TOGGLE-1 TOGGLE-2 
          f-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-FchCie x-Familias x-CodPro RADIO-SET-1 TOGGLE-1 TOGGLE-2 BUTTON-1 
         BtnDone 
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
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE cFila1 AS CHAR FORMAT 'X' INIT ''.
DEFINE VARIABLE cFila2 AS CHAR FORMAT 'X' INIT ''.

/* VARIABLES DEL REPORTE */
DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "FECHA DE CORTE: " + STRING(x-FchCie).
t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "VALORES EXPRESADOS EN " + ( IF radio-set-1 = 1 THEN "CANTIDADES" ELSE "MONEDA NACIONAL" ).
t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVEEDOR".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NOMBRE".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CODIGO".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MARCA".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "LINEA".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "SUB-LINEA".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "UND".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MONEDA".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "TPO CAMBIO".
cRange = "K" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PRECIO UNIT".
cRange = "L" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "STOCK CONTABLE".
cFila1 = "M".
cFila2 = "".
DO x-Item = 1 TO NUM-ENTRIES(x-Almacenes):
    x-CodAlm = ENTRY(x-Item, x-Almacenes).
    cRange = cFila1 + cFila2 + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "ALM " + x-CodAlm.
    IF cFila2 = "" THEN DO:
        cFila1 = CHR(ASC(cFila1) + 1).
        IF ASC(cFila1) > 90 THEN DO:
            cFila1 = "A".
            cFila2 = "A".
        END.
    END.
    ELSE DO:
        cFila2 = CHR(ASC(cFila2) + 1).
        IF ASC(cFila2) > 90 THEN DO:
            cFila1 = CHR(ASC(cFila1) + 1).
            cFila2 = "A".
        END.
    END.
END.

/* BARREMOS TODOS LOS PRODUCTOS */
FOR EACH Detalle NO-LOCK:
    /* *********************************** */
    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + detalle.codpro.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle.nompro.                                                                                                     
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + detalle.codmat.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle.desmat.
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle.desmar.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + detalle.codfam.
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + detalle.subfam.
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + detalle.undbas.
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle.codmon.
    cRange = "J" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle.tpocmb.
    cRange = "K" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle.preuni.
    cRange = "L" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle.stkgen.
    cFila1 = "M".
    cFila2 = "".
    DO x-Item = 1 TO NUM-ENTRIES(x-Almacenes):
        cRange = cFila1 + cFila2 + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.stkalm[x-Item].
        IF cFila2 = "" THEN DO:
            cFila1 = CHR(ASC(cFila1) + 1).
            IF ASC(cFila1) > 90 THEN DO:
                cFila1 = "A".
                cFila2 = "A".
            END.
        END.
        ELSE DO:
            cFila2 = CHR(ASC(cFila2) + 1).
            IF ASC(cFila2) > 90 THEN DO:
                cFila1 = CHR(ASC(cFila1) + 1).
                cFila2 = "A".
            END.
        END.
    END.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel2 W-Win 
PROCEDURE Excel2 :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE cFila1 AS CHAR FORMAT 'X' INIT ''.
DEFINE VARIABLE cFila2 AS CHAR FORMAT 'X' INIT ''.

/* VARIABLES DEL REPORTE */
DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "FECHA DE CORTE: " + STRING(x-FchCie).
t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "VALORES EXPRESADOS EN " + ( IF radio-set-1 = 1 THEN "CANTIDADES" ELSE "MONEDA NACIONAL" ).
t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVEEDOR".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NOMBRE".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MONEDA".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "TPO CAMBIO".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PREUNI".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "STOCK CONTABLE".
cFila1 = "G".
cFila2 = "".
DO x-Item = 1 TO NUM-ENTRIES(x-Almacenes):
    x-CodAlm = ENTRY(x-Item, x-Almacenes).
    cRange = cFila1 + cFila2 + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "ALM " + x-CodAlm.
    IF cFila2 = "" THEN DO:
        cFila1 = CHR(ASC(cFila1) + 1).
        IF ASC(cFila1) > 90 THEN DO:
            cFila1 = "A".
            cFila2 = "A".
        END.
    END.
    ELSE DO:
        cFila2 = CHR(ASC(cFila2) + 1).
        IF ASC(cFila2) > 90 THEN DO:
            cFila1 = CHR(ASC(cFila1) + 1).
            cFila2 = "A".
        END.
    END.
END.

/* BARREMOS TODOS LOS PRODUCTOS */
FOR EACH Detalle2 NO-LOCK BREAK BY Detalle2.codpro:
    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + detalle2.codpro.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle2.nompro.                                                                                                     
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle2.codmon.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle2.tpocmb.    
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle2.preuni.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = detalle2.stkgen.    
    cFila1 = "G".
    cFila2 = "".
    DO x-Item = 1 TO NUM-ENTRIES(x-Almacenes):
        cRange = cFila1 + cFila2 + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle2.stkalm[x-Item].
        IF cFila2 = "" THEN DO:
            cFila1 = CHR(ASC(cFila1) + 1).
            IF ASC(cFila1) > 90 THEN DO:
                cFila1 = "A".
                cFila2 = "A".
            END.
        END.
        ELSE DO:
            cFila2 = CHR(ASC(cFila2) + 1).
            IF ASC(cFila2) > 90 THEN DO:
                cFila1 = CHR(ASC(cFila1) + 1).
                cFila2 = "A".
            END.
        END.
    END.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Carga-Temporal.
IF TOGGLE-1 = NO 
THEN RUN Excel.
ELSE RUN Excel2.

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
      x-FchCie = TODAY - 1.

  FOR EACH Almtfami WHERE Almtfami.codcia = s-codcia NO-LOCK:
      x-Familias:ADD-LAST(Almtfami.codfam + ' - ' + ALmtfami.desfam)  IN FRAME {&FRAME-NAME} .
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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

