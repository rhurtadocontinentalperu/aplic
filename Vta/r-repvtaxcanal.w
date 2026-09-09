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

DEF SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-datos 
    FIELDS t-nrofch LIKE evtdivi.nrofch
    FIELDS t-coddiv LIKE evtdivi.coddiv
    FIELDS t-codaux AS CHAR    
    FIELDS t-codfam LIKE almmmatg.codfam
    FIELDS t-qtytot AS DECIMAL
    FIELDS t-vtatot AS DECIMAL
    FIELDS t-ctotot AS DECIMAL.

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
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 x-periodo-1 x-mes-1 ~
x-periodo-2 x-mes-2 BUTTON-4 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS x-periodo-1 x-mes-1 x-periodo-2 x-mes-2 ~
x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-mes-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-mes-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-periodo-1 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-periodo-2 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 5.65.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-periodo-1 AT ROW 2.08 COL 28 COLON-ALIGNED WIDGET-ID 2
     x-mes-1 AT ROW 2.08 COL 52 COLON-ALIGNED WIDGET-ID 4
     x-periodo-2 AT ROW 3.69 COL 28 COLON-ALIGNED WIDGET-ID 6
     x-mes-2 AT ROW 3.69 COL 52 COLON-ALIGNED WIDGET-ID 8
     x-mensaje AT ROW 5.58 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     BUTTON-4 AT ROW 7.19 COL 48 WIDGET-ID 28
     BtnDone AT ROW 7.19 COL 64 WIDGET-ID 30
     "DESDE" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 2.35 COL 14 WIDGET-ID 38
          FONT 8
     "HASTA" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.96 COL 14 WIDGET-ID 40
          FONT 8
     RECT-2 AT ROW 1.27 COL 2 WIDGET-ID 34
     RECT-3 AT ROW 7 COL 2 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 8.38 WIDGET-ID 100.


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
         TITLE              = "Reporte de Ventas x Canal"
         HEIGHT             = 8.38
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Ventas x Canal */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Ventas x Canal */
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


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    ASSIGN x-mes-1 x-mes-2 x-periodo-1 x-periodo-2.
    RUN Excel. /*RUN Imprime.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga W-Win 
PROCEDURE Carga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iperiodo01 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iperiodo02 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cCodAux    AS CHARACTER   NO-UNDO.

    iperiodo01 = x-periodo-1 * 100 + x-mes-1.
    iperiodo02 = x-periodo-2 * 100 + x-mes-2.
    
    FOR EACH evtall01 WHERE evtall01.codcia = s-codcia       
        AND evtall01.coddiv = "00000"
        AND evtall01.nrofch >= iperiodo01
        AND evtall01.nrofch <= iperiodo02 NO-LOCK:

        CASE evtall01.codven:
            WHEN "015" OR WHEN "173" OR WHEN "901" OR WHEN "902" 
                THEN cCodAux = "20100".
            WHEN "151" THEN cCodAux = "20200".
            OTHERWISE cCodAux = "20300".                    
        END CASE.        
        
        FIND FIRST tt-datos WHERE t-nrofch = evtall01.nrofch
            AND t-coddiv = evtall01.coddiv
            AND t-codaux = cCodAux NO-ERROR.
        IF NOT AVAIL tt-datos THEN DO:
            CREATE tt-datos.
            ASSIGN
                t-nrofch = evtall01.nrofch
                t-coddiv = evtall01.coddiv
                t-codaux = cCodAux.
        END.
        ASSIGN
            t-qtytot = t-qtytot + EvtALL01.CanxMes
            t-vtatot = t-vtatot + EvtALL01.VtaxMesMn 
            t-ctotot = t-ctotot + EvtALL01.CtoxMesMn .

        DISPLAY
            "PROCESANDO DIVISION " + evtall01.coddiv @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

        PAUSE 0.

    END.        
    DISPLAY " "  @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
    DEFINE VARIABLE iperiodo01 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iperiodo02 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cCodAux    AS CHARACTER   NO-UNDO.

    iperiodo01 = x-periodo-1 * 100 + x-mes-1.
    iperiodo02 = x-periodo-2 * 100 + x-mes-2.
    
    Head:
    FOR EACH evtall01 USE-INDEX Indice04
        WHERE evtall01.codcia = s-codcia        
        AND evtall01.nrofch >= iperiodo01
        AND evtall01.nrofch <= iperiodo02 NO-LOCK,
        FIRST almmmatg OF evtall01 NO-LOCK:

        /*No considera Standford*/
        IF evtall01.codcli = "20511358907" THEN NEXT Head.

        CASE evtall01.coddiv:
            WHEN "00000" THEN DO:
                CASE evtall01.codven:
                    WHEN "015" OR WHEN "173" OR WHEN "901" OR WHEN "902" 
                        THEN cCodAux = "20100".

                    WHEN "151" THEN cCodAux = "20200".
                    OTHERWISE cCodAux = "20300".                    
                END CASE.
            END.
            OTHERWISE cCodAux = evtall01.coddiv.
        END CASE.
        
        FIND FIRST tt-datos WHERE t-nrofch = evtall01.nrofch
            AND t-coddiv = evtall01.coddiv
            AND t-codaux = cCodAux
            AND t-codfam = almmmatg.codfam NO-ERROR.
        IF NOT AVAIL tt-datos THEN DO:
            CREATE tt-datos.
            ASSIGN
                t-nrofch = evtall01.nrofch
                t-coddiv = evtall01.coddiv
                t-codaux = cCodAux
                t-codfam = almmmatg.codfam.
        END.
        ASSIGN
            t-qtytot = t-qtytot + EvtALL01.CanxMes
            t-vtatot = t-vtatot + EvtALL01.VtaxMesMn 
            t-ctotot = t-ctotot + EvtALL01.CtoxMesMn .

        DISPLAY
            "PROCESANDO DIVISION " + evtall01.coddiv @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

        PAUSE 0.

    END.    

    DISPLAY " "  @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY x-periodo-1 x-mes-1 x-periodo-2 x-mes-2 x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RECT-3 x-periodo-1 x-mes-1 x-periodo-2 x-mes-2 BUTTON-4 BtnDone 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cNameCanal AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDesFam    AS CHARACTER   NO-UNDO.

RUN Carga-Temporal.
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("B2"):Value = "REPORTE DE VENTAS".

chWorkSheet:Range("A3"):Value = "Periodo".
chWorkSheet:Range("B3"):Value = "Mes".
chWorkSheet:Range("C3"):Value = "Division".
chWorkSheet:Range("D3"):Value = "Familia".
chWorkSheet:Range("E3"):Value = "Cantidad".
chWorkSheet:Range("F3"):Value = "Importe S/.".
chWorkSheet:Range("G3"):Value = "Costo S/.".
chWorkSheet:Range("H3"):Value = "Canal".

/*Formato*/
chWorkSheet:Columns("C"):NumberFormat = "@".

FOR EACH tt-datos NO-LOCK
    BREAK BY t-nrofch
        BY t-coddiv BY t-codaux BY t-codfam :    

    CASE t-coddiv:
        WHEN "00000" THEN DO:
            CASE t-codaux:
                WHEN "20100" THEN cNameCanal = "PROVINCIAS".
                WHEN "20200" THEN cNameCanal = "SUPERMERCADOS".
                WHEN "20300" THEN cNameCanal = "INSTITUCIONAL".
            END CASE.

        END.
        WHEN "00014" THEN cNameCanal = "HORIZONTAL".
        OTHERWISE cNameCanal = "TIENDAS".
    END CASE.

    FIND FIRST almtfam WHERE almtfam.codcia = s-codcia
        AND almtfam.codfam = t-codfam NO-LOCK NO-ERROR.
    IF AVAIL almtfam THEN cDesFam = almtfam.desfam.
    ELSE cDesFam = "".

    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = SUBSTRING(STRING(t-nrofch),1,4).                      
    cRange = "B" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = STRING(SUBSTRING(STRING(t-nrofch),5),"99").
    cRange = "C" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = t-coddiv.   
    cRange = "D" + cColumn.                                                    
    chWorkSheet:Range(cRange):Value = t-codfam + "-" + cDesFam.   
    cRange = "E" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = t-qtytot.                      
    cRange = "F" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = t-vtatot. 
    cRange = "G" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = t-ctotot. 
    cRange = "H" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = cNameCanal.
END.

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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          x-periodo-1 = YEAR(TODAY)
          x-periodo-2 = YEAR(TODAY)
          x-mes-1 = 1
          x-mes-2 = MONTH(TODAY).
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

