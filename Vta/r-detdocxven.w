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
DEF SHARED VAR cl-codcia AS INT.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-Desde x-Hasta BUTTON-5 BUTTON-6 
&Scoped-Define DISPLAYED-OBJECTS f-vendedor x-Desde x-Hasta txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY 1.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 5" 
     SIZE 10 BY 1.62.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 6" 
     SIZE 10 BY 1.62.

DEFINE VARIABLE f-vendedor AS CHARACTER FORMAT "X(100)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71.29 BY 1 NO-UNDO.

DEFINE VARIABLE x-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-vendedor AT ROW 2.35 COL 15 COLON-ALIGNED WIDGET-ID 98
     BUTTON-1 AT ROW 2.35 COL 64 WIDGET-ID 142
     x-Desde AT ROW 4.23 COL 15 COLON-ALIGNED WIDGET-ID 6
     x-Hasta AT ROW 4.23 COL 40 COLON-ALIGNED WIDGET-ID 8
     txt-msj AT ROW 6.38 COL 3.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     BUTTON-5 AT ROW 8 COL 53 WIDGET-ID 12
     BUTTON-6 AT ROW 8 COL 64 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.62 WIDGET-ID 100.


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
         TITLE              = "Documentos por Vendedor"
         HEIGHT             = 9.62
         WIDTH              = 80
         MAX-HEIGHT         = 9.62
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 9.62
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
/* SETTINGS FOR FILL-IN f-vendedor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Documentos por Vendedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Documentos por Vendedor */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Vendedores AS CHAR.
    x-Vendedores = f-vendedor:SCREEN-VALUE.
    RUN vta/d-lisven (INPUT-OUTPUT x-Vendedores).
    f-vendedor:SCREEN-VALUE = x-Vendedores.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
    ASSIGN
        f-vendedor x-Desde x-Hasta.
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
  
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
  DISPLAY f-vendedor x-Desde x-Hasta txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 x-Desde x-Hasta BUTTON-5 BUTTON-6 
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
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
DEFINE VARIABLE iCount             AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn            AS CHARACTER.
DEFINE VARIABLE cRange             AS CHARACTER.

DEFINE VARIABLE cListVen           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-TpoCmbCmp        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE x-TpoCmbVta        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE x-TpoCmb           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE x-factor           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE x-depto            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-provin           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-distri           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-tipodoc          AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(iCount).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "COD VEN".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "VENDEDOR".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "DIVISION".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "DOCUMENTO".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "NRO DOC".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "CODIGO".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "CLIENTE".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "ARTICULO".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "MARCA".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "FAMILIA".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "SUBFAMILIA".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "CANT SOL.".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "IMPORTE".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "FECHA".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "DEPARTAMENTO".
cRange = "Q" + cColumn.
chWorkSheet:Range(cRange):Value = "PROVINCIA".
cRange = "R" + cColumn.
chWorkSheet:Range(cRange):Value = "DISTRITO".
cRange = "S" + cColumn.
chWorkSheet:Range(cRange):Value = "TIPO DOC".
cRange = "T" + cColumn.
chWorkSheet:Range(cRange):Value = "NRO O/C".


chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".
chWorkSheet:Columns("F"):NumberFormat = "@".
chWorkSheet:Columns("H"):NumberFormat = "@".
chWorkSheet:Columns("H"):NumberFormat = "@".
chWorkSheet:Columns("K"):NumberFormat = "@".
chWorkSheet:Columns("L"):NumberFormat = "@".
chWorkSheet:Columns("T"):NumberFormat = "@".
chWorkSheet:Columns("G"):ColumnWidth = 45.
chWorkSheet:Columns("I"):ColumnWidth = 45.
chWorkSheet:Range("A1:T1"):Font:Bold = TRUE.

cListVen = f-vendedor:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

Master:
FOR EACH ccbcdocu WHERE ccbcdocu.codcia = 1
    AND lookup(ccbcdocu.codven,cListVen) > 0
    AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C") > 0
    AND ccbcdocu.flgest <> "A"
    AND ccbcdocu.fchdoc >= x-Desde
    AND ccbcdocu.fchdoc <= x-Hasta
    AND ccbcdocu.tpofac <> "A" NO-LOCK,
    EACH ccbddocu OF ccbcdocu NO-LOCK,
    FIRST almmmatg OF ccbddocu NO-LOCK:
    
    IF ccbcdocu.tpofac = "S" THEN NEXT Master.

    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = ccbcdocu.codven NO-LOCK NO-ERROR.

    /*Tipo Documento*/
    IF ccbcdocu.coddoc = "N/C" AND CcbCDocu.Cndcre = "D" THEN x-tipodoc = "DEVOLUCION".
    ELSE x-tipodoc = "".

    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.
    IF AVAIL gn-clie THEN DO:
        FIND FIRST TabDepto WHERE  TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
        IF AVAIL TabDepto THEN x-depto =  TabDepto.NomDepto. ELSE x-depto = "".

        FIND FIRST TabProvi WHERE TabProvi.CodDepto = gn-clie.CodDept
            AND TabProvi.CodProvi = gn-clie.CodProv NO-LOCK NO-ERROR.
        IF AVAIL TabProvi THEN x-provin =  TabProvi.NomProvi. ELSE x-provin = "".

        FIND FIRST TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept
            AND TabDistr.CodProvi  =  gn-clie.CodProv
            AND TabDistr.CodDistr  =  gn-clie.CodDist NO-LOCK NO-ERROR.
        IF AVAIL TabDistr THEN x-distri = TabDistr.NomDistr. ELSE x-distri = "".
    END.

    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
        USE-INDEX Cmb01 NO-LOCK NO-ERROR.
    IF NOT AVAIL Gn-Tcmb THEN 
        FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
    IF AVAIL Gn-Tcmb THEN 
        ASSIGN
            x-TpoCmbCmp = Gn-Tcmb.Compra
            x-TpoCmbVta = Gn-Tcmb.Venta.

    IF CcbcDocu.CodMon = 2 THEN x-TpoCmb = x-TpoCmbVta.
    ELSE x-TpoCmb = 1.

    IF CcbCDocu.CodDoc = "N/C" THEN x-factor = -1.
    ELSE x-factor = 1.        

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbcDocu.CodVen.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-ven.nomven.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbcdocu.coddiv.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbddocu.coddoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbcdocu.nrodoc.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbcdocu.codcli.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbcdocu.nomcli.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = ccbddocu.codmat.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.codfam.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.subfam.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.CanDes.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.ImpLin * x-TpoCmb * x-factor.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbCDocu.FchDoc.
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = x-depto.
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = x-provin.
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = x-distri.
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = x-tipodoc.
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbCDocu.NroOrd.

    DISPLAY "Cargando:  " + CcbCDocu.CodDoc + " - " + CcbCDocu.NroDoc @ txt-msj
        WITH FRAME {&FRAME-NAME}.

    PAUSE 0.

END.

DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.


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
   
   ASSIGN 
       x-Desde = TODAY - DAY(TODAY) + 1
       x-Hasta = TODAY.
            

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

