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

IF NOT connected('cissac')
    THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
  MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
      'NO podemos capturar el stock'
      VIEW-AS ALERT-BOX WARNING.
END.


DEFINE SHARED VAR s-codcia AS INT.

DEFINE TEMP-TABLE tt-temp
    FIELDS t-codmat LIKE integral.almmmatg.codmat
    FIELDS t-desmat LIKE integral.almmmatg.desmat
    FIELDS t-contad AS INT
    FIELDS t-ubicon LIKE integral.almmmate.codubi EXTENT 10
    FIELDS t-ubistn LIKE integral.almmmate.codubi EXTENT 10.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-4 BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS x-mensaje 

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
     SIZE 9 BY 1.35.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/exit.ico":U NO-CONVERT-3D-COLORS
     LABEL "Button 5" 
     SIZE 9 BY 1.35.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56.29 BY .81
     FONT 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-mensaje AT ROW 3.15 COL 3.72 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-4 AT ROW 4.5 COL 42 WIDGET-ID 4
     BUTTON-5 AT ROW 4.5 COL 52 WIDGET-ID 6
     "Ubicaciones de Articulo por Almacenes" VIEW-AS TEXT
          SIZE 37 BY .62 AT ROW 2.08 COL 5 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.29 BY 5.5 WIDGET-ID 100.


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
         TITLE              = "Ubicacion de Articulos"
         HEIGHT             = 5.5
         WIDTH              = 64.29
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
ON END-ERROR OF W-Win /* Ubicacion de Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ubicacion de Articulos */
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
  RUN Excel.
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca-Cissac W-Win 
PROCEDURE Busca-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT connected('cissac')
        THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
          'NO podemos capturar el stock'
          VIEW-AS ALERT-BOX WARNING.
    END.    
    
    FOR EACH cissac.almdinv WHERE cissac.almdinv.codcia = s-codcia
        AND lookup(cissac.almdinv.codalm,"11,22,85") > 0
        AND cissac.almdinv.nomcia = "stand" NO-LOCK,
        FIRST cissac.almmmatg OF cissac.almdinv NO-LOCK
        BREAK BY cissac.almdinv.codalm:

        DISPLAY "PROCESANDO: " + cissac.almmmatg.desmat @ 
            x-mensaje WITH FRAME {&FRAME-NAME}.

        FIND FIRST tt-temp WHERE tt-temp.t-codmat = cissac.almdinv.codmat NO-ERROR.
        IF NOT AVAIL tt-temp THEN DO:
            CREATE tt-temp.
            ASSIGN 
                tt-temp.t-codmat = cissac.almdinv.codmat
                tt-temp.t-desmat = cissac.almmmatg.desmat.
        END.
        CASE cissac.almdinv.codalm:
            WHEN "11" THEN DO: 
                IF cissac.almdinv.codubi <> "" THEN
                    ASSIGN 
                        tt-temp.t-ubistn[1] = cissac.almdinv.codubi
                        tt-temp.t-contad    = tt-temp.t-contad + 1.
            END.
            WHEN "22" THEN DO:
                IF cissac.almdinv.codubi <> "" THEN
                    ASSIGN 
                        tt-temp.t-ubistn[2] = cissac.almdinv.codubi
                        tt-temp.t-contad    = tt-temp.t-contad + 1.
            END.
            WHEN "85" THEN DO: 
                IF cissac.almdinv.codubi <> "" THEN
                    ASSIGN 
                        tt-temp.t-ubistn[3] = cissac.almdinv.codubi
                        tt-temp.t-contad    = tt-temp.t-contad + 1.
            END.
        END CASE.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca-Ubicaciones W-Win 
PROCEDURE Busca-Ubicaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT connected('cissac')
        THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
            'NO podemos capturar el stock'
            VIEW-AS ALERT-BOX WARNING.
    END.

    RUN Busca-Cissac.

    FOR EACH integral.almdinv WHERE integral.almdinv.codcia = s-codcia
        AND lookup(integral.almdinv.codalm,"11,22,85") > 0
        AND integral.almdinv.nomcia = "conti" NO-LOCK,
        FIRST integral.almmmatg OF integral.almdinv NO-LOCK
        BREAK BY integral.almdinv.codalm:

        DISPLAY "PROCESANDO: " + integral.almmmatg.desmat @ 
            x-mensaje WITH FRAME {&FRAME-NAME}.

        FIND FIRST tt-temp WHERE tt-temp.t-codmat = integral.almdinv.codmat NO-ERROR.
        IF NOT AVAIL tt-temp THEN DO:
            CREATE tt-temp.
            ASSIGN 
                tt-temp.t-codmat = integral.almdinv.codmat
                tt-temp.t-desmat = integral.almmmatg.desmat.
                
        END.
        CASE integral.almdinv.codalm:
            WHEN "11" THEN DO: 
                IF integral.almdinv.codubi <> "" THEN
                    ASSIGN 
                        tt-temp.t-ubicon[1] = integral.almdinv.codubi
                        tt-temp.t-contad    = tt-temp.t-contad + 1.
            END.
            WHEN "22" THEN DO: 
                IF integral.almdinv.codubi <> "" THEN
                    ASSIGN 
                        tt-temp.t-ubicon[2] = integral.almdinv.codubi
                        tt-temp.t-contad    = tt-temp.t-contad + 1.
            END.
            WHEN "85" THEN DO: 
                IF integral.almdinv.codubi <> "" THEN
                    ASSIGN 
                        tt-temp.t-ubicon[3] = integral.almdinv.codubi
                        tt-temp.t-contad    = tt-temp.t-contad + 1.
            END.
        END CASE.
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
  DISPLAY x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-4 BUTTON-5 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 4.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.


RUN Busca-Ubicaciones.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).


/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".

/* set the column names for the Worksheet */
 cColumn = STRING(t-Column).
 cRange = "A" + cColumn.
 chWorkSheet:Range(cRange):Value = "Código".
 cRange = "B" + cColumn.
 chWorkSheet:Range(cRange):Value = "Descripción                        ".
 cRange = "C" + cColumn.
 chWorkSheet:Range(cRange):Value = "Conti 11".
 cRange = "D" + cColumn.
 chWorkSheet:Range(cRange):Value = "Conti 22".
 cRange = "E" + cColumn.
 chWorkSheet:Range(cRange):Value = "Conti 85".
 cRange = "F" + cColumn.
 chWorkSheet:Range(cRange):Value = "Cissac 11".
 cRange = "G" + cColumn.
 chWorkSheet:Range(cRange):Value = "Cissac 22".
 cRange = "H" + cColumn.
 chWorkSheet:Range(cRange):Value = "Cissac 85".
 cRange = "I" + cColumn.
 chWorkSheet:Range(cRange):Value = "Nro Ubic".


 FOR EACH tt-temp NO-LOCK WHERE t-contad >= 2 :
     t-Column = t-Column + 1.
     cColumn = STRING(t-Column).
     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = t-codmat.
     cRange = "B" + cColumn.
     chWorkSheet:Range(cRange):Value = t-desmat.        
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = t-ubicon[1].
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = t-ubicon[2].        
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value = t-ubicon[3].
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = t-ubistn[1].        
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value = t-ubistn[2].
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value = t-ubistn[3].        
     cRange = "I" + cColumn.
     chWorkSheet:Range(cRange):Value = t-contad.        
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

