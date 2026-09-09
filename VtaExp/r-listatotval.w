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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-codalm AS CHAR.

DEFINE VARIABLE x-art01 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-art02 AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-datos LIKE almcatvtad
    FIELDS desmar LIKE almmmatg.desmar    
    FIELDS premat AS DEC
    FIELDS imptot AS DEC
    FIELDS stktot AS DEC.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 x-desde x-hasta BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-desde x-hasta x-mensaje 

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
     SIZE 9 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 9 BY 1.62.

DEFINE VARIABLE x-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 7.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-desde AT ROW 2.08 COL 21 COLON-ALIGNED WIDGET-ID 2
     x-hasta AT ROW 3.42 COL 21 COLON-ALIGNED WIDGET-ID 4
     x-mensaje AT ROW 5.31 COL 10 NO-LABEL WIDGET-ID 14
     BUTTON-1 AT ROW 6.38 COL 40 WIDGET-ID 10
     BUTTON-2 AT ROW 6.38 COL 51 WIDGET-ID 12
     RECT-1 AT ROW 1.15 COL 2 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63.86 BY 7.65 WIDGET-ID 100.


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
         TITLE              = "Lista Articulos"
         HEIGHT             = 7.65
         WIDTH              = 63.86
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

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("adeicon/sqlexp.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/sqlexp.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Lista Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Lista Articulos */
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
   ASSIGN 
       x-desde
       x-hasta.

   RUN Genera_Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
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

    /*Borra Temporales*/
    FOR EACH tt-datos:
        DELETE tt-datos.
    END.

    FOR EACH almcatvtad WHERE almcatvtad.codcia = s-codcia
        AND almcatvtad.coddiv = s-coddiv NO-LOCK:
                
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = almcatvtad.codmat NO-LOCK NO-ERROR.
        CREATE tt-datos.
        BUFFER-COPY almcatvtad TO tt-datos
            ASSIGN 
                tt-datos.desmar = almmmatg.desmar
                tt-datos.undbas = almmmatg.undbas
                tt-datos.premat = almmmatg.prealt[4].
    END.

    FOR EACH vtacdocu WHERE vtacdocu.codcia = s-codcia 
        AND vtacdocu.coddiv = s-coddiv
        AND vtacdocu.fchped >= x-desde
        AND vtacdocu.fchped <= x-hasta
        AND vtacdocu.flgest <> 'A' NO-LOCK,
        EACH vtaddocu WHERE vtaddocu.codcia = vtacdocu.codcia
        AND vtaddocu.coddiv = vtacdocu.coddiv
        AND vtaddocu.codped = vtacdocu.codped
        AND vtaddocu.nroped = vtacdocu.nroped NO-LOCK:        
        FIND FIRST tt-datos WHERE tt-datos.codmat = vtaddocu.codmat NO-ERROR.
        IF NOT AVAIL tt-datos THEN NEXT.
        ASSIGN 
            tt-datos.imptot = vtaddocu.implin + tt-datos.imptot.
            tt-datos.stktot = vtaddocu.canped + tt-datos.stktot.                
        DISPLAY 'CARGANDO....' + vtaddocu.codmat @ x-mensaje WITH FRAME {&FRAME-NAME}.
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
  DISPLAY x-desde x-hasta x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 x-desde x-hasta BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera_Excel W-Win 
PROCEDURE Genera_Excel :
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE cLetra                  AS CHAR.
DEFINE VARIABLE cLetra2                 AS CHAR.
DEFINE VARIABLE xOrden                  AS INT.
DEFINE VARIABLE xNumAlm                 AS INT     NO-UNDO.

RUN Carga-Datos.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
cRange = "E" + '2'.
chWorkSheet:Range(cRange):Value = "CATALOGO VALORIZADO".
cRange = "K" + '2'.
chWorkSheet:Range(cRange):Value = TODAY.

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".

/* set the column names for the Worksheet */
chWorkSheet:Range('A3'):Value = "Cod.Proveedor".
chWorkSheet:Range('B3'):Value = "Nro.Pag".
chWorkSheet:Range('C3'):Value = "Nro.Sec".
chWorkSheet:Range('D3'):Value = "Codigo".
chWorkSheet:Range('E3'):Value = "Descripcion".
chWorkSheet:Range('F3'):Value = "Marca".
chWorkSheet:Range('G3'):Value = "Unidad".
chWorkSheet:Range('H3'):Value = "Precio Unit S/.".
chWorkSheet:Range('I3'):Value = "Imp. Total S/.".
chWorkSheet:Range('J3'):Value = "Cantidad Total".

t-Letra  = ASC('K').
t-column = 3.
cLetra2  = ''.
xNumAlm  = 0.

FOR EACH almacen WHERE almacen.codcia = s-codcia 
    AND Almacen.AutMov = YES NO-LOCK:
    xNumAlm = xNumAlm + 1.
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = almacen.codalm.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
END.

FOR EACH tt-datos NO-LOCK:
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.codpro.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(tt-datos.nropag,'999').
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(tt-datos.nrosec,'999').
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.codmat.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.desmat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.desmar.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.undbas.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.premat.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.imptot.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.stktot.

    t-Letra = ASC('K').
    cLetra2 = ''.

    FOR EACH almacen WHERE almacen.codcia = s-codcia
        AND Almacen.AutMov = YES NO-LOCK:
        FIND FIRST almmmate WHERE almmmate.codcia = s-codcia
            AND almmmate.codmat = tt-datos.codmat
            AND almmmate.codalm = almacen.codalm NO-LOCK NO-ERROR. 

        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        IF AVAIL almmmate THEN DO:            
            chWorkSheet:Range(cRange):Value = almmmate.stkact.
        END.
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
                THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.                
    END.
    DISPLAY 'GENERANDO EXCEL .... ' @ x-mensaje WITH FRAME {&FRAME-NAME}.
    PAUSE 0.
END.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

 DISPLAY '' @ x-mensaje WITH FRAME {&FRAME-NAME}.

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

