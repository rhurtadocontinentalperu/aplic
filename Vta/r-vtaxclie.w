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

DEF SHARED VAR s-codcia   AS INT.
DEF SHARED VAR cl-codcia  AS INT.
DEF SHARED VAR s-coddiv   AS CHAR.

DEFINE TEMP-TABLE tt-vtacli
    FIELDS tt-codven LIKE gn-ven.codven
    FIELDS tt-codcli LIKE gn-clie.codcli
    FIELDS tt-montomes AS DECIMAL FORMAT "->>>,>>>,>>9.99" EXTENT 12.

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
&Scoped-Define ENABLED-OBJECTS f-vendedor BUTTON-1 f-periodo r-moneda ~
btn-ok BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS f-vendedor f-periodo r-moneda x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-ok 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 4 BY .81.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 5" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE f-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-vendedor AS CHARACTER FORMAT "X(50)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71 BY 1 NO-UNDO.

DEFINE VARIABLE r-moneda AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 26 BY 1.08 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-vendedor AT ROW 2.08 COL 14 COLON-ALIGNED WIDGET-ID 98
     BUTTON-1 AT ROW 2.15 COL 62 WIDGET-ID 142
     f-periodo AT ROW 3.15 COL 14 COLON-ALIGNED WIDGET-ID 144
     r-moneda AT ROW 4.77 COL 19 NO-LABEL WIDGET-ID 146
     btn-ok AT ROW 7.19 COL 18 WIDGET-ID 152
     BUTTON-5 AT ROW 7.19 COL 35 WIDGET-ID 154
     x-mensaje AT ROW 9.88 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 156
     "Moneda:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 4.96 COL 8.14 WIDGET-ID 150
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.58 WIDGET-ID 100.


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
         TITLE              = "Reporte Clientes por Vendedor"
         HEIGHT             = 11.58
         WIDTH              = 80
         MAX-HEIGHT         = 11.58
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 11.58
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
ON END-ERROR OF W-Win /* Reporte Clientes por Vendedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Clientes por Vendedor */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-ok W-Win
ON CHOOSE OF btn-ok IN FRAME F-Main /* Button 4 */
DO:
  ASSIGN f-periodo f-vendedor r-moneda.
  RUN Excel.
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal W-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-vtacli:
        DELETE tt-vtacli.
    END.

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
    DEFINE VARIABLE cLisVen     AS CHARACTER   NO-UNDO.
    cLisVen = f-vendedor:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    FOR EACH Gn-Divi WHERE Gn-Divi.CodCia = s-CodCia NO-LOCK:
        FOR EACH EvtAll04 
            WHERE EvtAll04.CodCia = s-CodCia
            AND EvtAll04.CodDiv = Gn-Divi.CodDiv
            AND Lookup(EvtAll04.CodVen,cLisVen) > 0
            AND INT(SUBSTRING(STRING(EvtAll04.Codano),1,4)) = f-periodo NO-LOCK:

            FIND FIRST tt-vtacli WHERE tt-vtacli.tt-codven = Evtall04.CodVen
                AND tt-vtacli.tt-codcli = EvtAll04.CodCli NO-ERROR.

            IF NOT AVAIL tt-vtacli THEN DO:
                CREATE tt-vtacli.
                ASSIGN
                    tt-vtacli.tt-codven = EvtAll04.CodVen
                    tt-vtacli.tt-codcli = EvtAll04.CodCli.
            END.
            CASE r-moneda:
                WHEN 1 THEN ASSIGN tt-montomes[EvtAll04.codmes] = tt-montomes[EvtAll04.codmes] + EvtAll04.VtaxMesMn.
                WHEN 2 THEN ASSIGN tt-montomes[EvtAll04.codmes] = tt-montomes[EvtAll04.codmes] + EvtAll04.VtaxMesMe.
            END CASE.            

            DISPLAY "Procesando: " + EvtAll04.CodVen + " - " + EvtAll04.CodCli @ x-mensaje
                WITH FRAME {&FRAME-NAME}.
            PAUSE 0.
        END.        
    END.
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

    DEFINE VARIABLE cLisVen     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iNroFchi    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNroFchf    AS INTEGER     NO-UNDO.
    
    iNroFchi = (f-periodo * 100 + 1).
    iNroFchf = (f-periodo * 100 + 12).
    cLisVen = f-vendedor:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    FOR EACH EvtAll01 USE-INDEX Indice05
        WHERE EvtAll01.CodCia = s-CodCia
        AND EvtAll01.CodDiv = s-coddiv
        AND Lookup(EvtAll01.CodVen,cLisVen) > 0
        AND EvtALL01.NroFch >= iNroFchi
        AND EvtALL01.NroFch <= iNroFchf NO-LOCK:
        
        FIND FIRST tt-vtacli WHERE tt-vtacli.tt-codven = Evtall01.CodVen
            AND tt-vtacli.tt-codcli = EvtAll01.CodCli NO-ERROR.

        IF NOT AVAIL tt-vtacli THEN DO:
            CREATE tt-vtacli.
            ASSIGN
                tt-vtacli.tt-codven = EvtAll01.CodVen
                tt-vtacli.tt-codcli = EvtAll01.CodCli.
        END.
        CASE r-moneda:
            WHEN 1 THEN ASSIGN tt-montomes[EvtAll01.codmes] = tt-montomes[EvtAll01.codmes] + EvtALL01.VtaxMesMn.
            WHEN 2 THEN ASSIGN tt-montomes[EvtAll01.codmes] = tt-montomes[EvtAll01.codmes] + EvtALL01.VtaxMesMe.
        END CASE.            

        DISPLAY "Procesando: " + EvtAll01.CodVen + " - " + EvtAll01.CodCli @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
        PAUSE 0.
    END.        
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cargando W-Win 
PROCEDURE Cargando :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cLisVen     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iNroFchi    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNroFchf    AS INTEGER     NO-UNDO.
    cLisVen = f-vendedor:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    iNroFchi = (f-periodo * 100 + 1).
    iNroFchf = (f-periodo * 100 + 12).

    FOR EACH EvtAll01 
        WHERE EvtAll01.CodCia = s-CodCia
        AND EvtALL01.NroFch >= iNroFchi 
        AND EvtALL01.NroFch <= iNroFchf NO-LOCK:

        IF LOOKUP(EvtAll01.CodVen,cLisVen) = 0 THEN NEXT.
        FIND FIRST tt-vtacli WHERE tt-vtacli.tt-codven = Evtall01.CodVen
            AND tt-vtacli.tt-codcli = EvtAll01.CodCli NO-ERROR.

        IF NOT AVAIL tt-vtacli THEN DO:
            CREATE tt-vtacli.
            ASSIGN
                tt-vtacli.tt-codven = EvtAll01.CodVen
                tt-vtacli.tt-codcli = EvtAll01.CodCli.
        END.
        CASE r-moneda:
            WHEN 1 THEN ASSIGN tt-montomes[EvtAll01.codmes] = tt-montomes[EvtAll01.codmes] + EvtALL01.VtaxMesMn.
            WHEN 2 THEN ASSIGN tt-montomes[EvtAll01.codmes] = tt-montomes[EvtAll01.codmes] + EvtALL01.VtaxMesMe.
        END CASE.            

        DISPLAY "Procesando: " + EvtAll01.CodVen + " - " + EvtAll01.CodCli @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
        PAUSE 0.        
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
  DISPLAY f-vendedor f-periodo r-moneda x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE f-vendedor BUTTON-1 f-periodo r-moneda btn-ok BUTTON-5 
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
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE dTotal AS DECIMAL  NO-UNDO EXTENT 12.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN Borra-Temporal.
    RUN Carga-Temporal.
    
    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "VENTAS POR VENDEDOR".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "PERIODO: " + STRING(f-periodo).

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "CODVEN".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "VENDEDOR".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CODCLI".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "ENERO".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "FEBRERO".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "MARZO".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "ABRIL".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "MAYO".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "JUNIO".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "JULIO".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "AGOSTO".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "SETIEMBRE".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "OCTUBRE".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOVIEMBRE".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "DICIEMBRE".

    FOR EACH tt-vtacli NO-LOCK BREAK BY tt-vtacli.tt-codven BY tt-vtacli.tt-codcli :

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = tt-vtacli.tt-codcli NO-LOCK NO-ERROR.

        FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = tt-vtacli.tt-codven NO-LOCK NO-ERROR.

        ACCUMULATE  tt-montomes[1] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[2] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[3] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[4] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[5] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[6] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[7] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[8] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[9] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[10] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[11] (TOTAL BY tt-vtacli.tt-codcli).
        ACCUMULATE  tt-montomes[12] (TOTAL BY tt-vtacli.tt-codcli).

        dTotal[1]  = dTotal[1]  + tt-montomes[1] .
        dTotal[2]  = dTotal[2]  + tt-montomes[2] .
        dTotal[3]  = dTotal[3]  + tt-montomes[3] .
        dTotal[4]  = dTotal[4]  + tt-montomes[4] .
        dTotal[5]  = dTotal[5]  + tt-montomes[5] .
        dTotal[6]  = dTotal[6]  + tt-montomes[6] .
        dTotal[7]  = dTotal[7]  + tt-montomes[7] .
        dTotal[8]  = dTotal[8]  + tt-montomes[8] .
        dTotal[9]  = dTotal[9]  + tt-montomes[9] .
        dTotal[10] = dTotal[10] + tt-montomes[10].
        dTotal[11] = dTotal[11] + tt-montomes[11].
        dTotal[12] = dTotal[12] + tt-montomes[12].

        IF LAST-OF(tt-vtacli.tt-codcli) THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + tt-vtacli.tt-codven.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = gn-ven.nomven.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + tt-vtacli.tt-codcli.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = gn-clie.nomcli.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[1].
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[2].
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[3].
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[4].            
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[5].
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[6].
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[7].
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[8].            
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[9].
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[10].
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[11].
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY tt-vtacli.tt-codcli tt-vtacli.tt-montomes[12].            
        END.
        IF LAST(tt-vtacli.tt-codven) THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = "TOTAL".
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[1].
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[2].
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[3].
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[4].            
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[5].
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[6].
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[7].
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[8].            
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[9].
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[10].
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[11].
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[12].            

        END.
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
    ASSIGN f-periodo = YEAR(TODAY).
    
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

