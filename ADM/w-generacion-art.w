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
    DEFINE VAR lContador  AS INT INIT 0.
    DEFINE VAR lArchivoSalida AS CHARACTER INIT "".
    DEFINE SHARED VAR s-codcia AS INT.

    DEF TEMP-TABLE tt-txt
        FIELD Codigo AS CHAR FORMAT 'x(15)'.

    DEFINE TEMP-TABLE tt-almmmatg LIKE almmmatg
        INDEX idx01 IS PRIMARY codmat.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodArt BUTTON-procesar BUTTON-1 ~
BUTTON-salir 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodArt FILL-IN-msg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Borrar todo lo leido anteriormente" 
     SIZE 36 BY 1.08.

DEFINE BUTTON BUTTON-procesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-salir 
     LABEL "Salir" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-CodArt AS CHARACTER FORMAT "X(25)":U 
     LABEL "Codigo Articulo" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1
     FGCOLOR 4 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodArt AT ROW 2.08 COL 10.14 WIDGET-ID 10
     FILL-IN-msg AT ROW 4.23 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     BUTTON-procesar AT ROW 4.23 COL 43 WIDGET-ID 14
     BUTTON-1 AT ROW 7.46 COL 13 WIDGET-ID 8
     BUTTON-salir AT ROW 7.46 COL 63 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.57 BY 9.46 WIDGET-ID 100.


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
         TITLE              = "Verificar y listar Articulos"
         HEIGHT             = 9.46
         WIDTH              = 80.57
         MAX-HEIGHT         = 17.23
         MAX-WIDTH          = 80.57
         VIRTUAL-HEIGHT     = 17.23
         VIRTUAL-WIDTH      = 80.57
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
/* SETTINGS FOR FILL-IN FILL-IN-CodArt IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-msg IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Verificar y listar Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Verificar y listar Articulos */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Borrar todo lo leido anteriormente */
DO:
    
        MESSAGE 'Seguro de Borrar TODO ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
            IF rpta = NO THEN RETURN NO-APPLY.

      FOR EACH tt-almmmatg:
                DELETE tt-almmmatg.
      END.
    
      lContador = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-procesar W-Win
ON CHOOSE OF BUTTON-procesar IN FRAME F-Main /* Procesar */
DO:
  
    IF lContador > 0 THEN DO:
        RUN procesa.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-salir W-Win
ON CHOOSE OF BUTTON-salir IN FRAME F-Main /* Salir */
DO:
  APPLY  "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodArt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodArt W-Win
ON LEAVE OF FILL-IN-CodArt IN FRAME F-Main /* Codigo Articulo */
OR RETURN OF FILL-IN-CodArt
 DO:
    DEFINE VAR lCodArt AS CHARACTER.
    DEFINE VAR lCodTxt AS CHARACTER.
    DEFINE VAR lContStr AS CHARACTER.

    lCodTxt = FILL-IN-CodArt:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    IF lCodTxt = ? OR TRIM(lCodTxt)="" THEN RETURN.

    /* Lo busco x codigo Interno */
    FIND almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = lCodTxt NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almmmatg THEN DO:
        /* Lo busco x codigo de BARRA */
        FIND almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.CodBrr = lCodTxt NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN DO:
            MESSAGE 'NO existe el ARTICULO' VIEW-AS ALERT-BOX ERROR.
            /*RETURN NO-APPLY.*/
             APPLY 'ENTRY':U TO FILL-IN-CodArt IN FRAME {&FRAME-NAME}.
             RETURN NO-APPLY.
        END.
    END.
    /* Lo busco en la tabla temporal */
    lCodArt = almmmatg.codmat.
    FIND tt-almmmatg WHERE tt-almmmatg.codmat = lCodArt EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-almmmatg THEN DO:
        CREATE tt-almmmatg.
        BUFFER-COPY almmmatg TO tt-almmmatg.
        lContador = lContador + 1.
        lContStr = trim(STRING(lContador)) + " Articulo(s)" .
        DISPLAY lContStr @ FILL-IN-msg WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        /*MESSAGE 'ARTICULO ya esta Registrado' VIEW-AS ALERT-BOX WARNING.*/
    END.
    APPLY 'ENTRY':U TO FILL-IN-CodArt IN FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_articulos W-Win 
PROCEDURE carga_articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* Desde el temporal, lo llevo a EXCEL */

        DEFINE VAR cArticulo AS CHARACTER.

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.


        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = TRUE.

        /* create a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

    cRange = "A1".
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "B1".
    chWorkSheet:Range(cRange):Value = "DESCRIPCION".
    cRange = "C1".
    chWorkSheet:Range(cRange):Value = "UND STOCK".
    cRange = "D1".
    chWorkSheet:Range(cRange):Value = "COD. BARRA".
    cRange = "E1".
    chWorkSheet:Range(cRange):Value = "PRECIO".

iColumn = 2.

FOR EACH tt-almmmatg NO-LOCK:

    cArticulo = tt-almmmatg.codmat.
    DISPLAY cArticulo @ FILL-IN-msg WITH FRAME {&FRAME-NAME}.

    cRange = "A" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.codmat.
    cRange = "B" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.DesMat.
    cRange = "C" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndStk.
    cRange = "D" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.CodBrr.

    FIND vtalistamingn WHERE vtalistamingn.codcia = tt-almmmatg.codcia AND vtalistamingn.codmat = tt-almmmatg.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE vtalistamingn THEN DO:
        cRange = "E" + STRING(iColumn).
        chWorkSheet:Range(cRange):Value = vtalistamingn.preofi.
    END.
    iColumn = iColumn + 1.
END.

    chWorkSheet:SaveAs(lArchivoSalida).
        chExcelApplication:DisplayAlerts = False.
        chExcelApplication:Quit().


        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_articulos_precio W-Win 
PROCEDURE carga_articulos_precio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* Desde el temporal, lo llevo a EXCEL */
/*
        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.


        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = TRUE.

        /* create a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

    cRange = "A1".
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "B1".
    chWorkSheet:Range(cRange):Value = "DESCRIPCION".
    cRange = "C1".
    chWorkSheet:Range(cRange):Value = "UND BASE".
    cRange = "D1".
    chWorkSheet:Range(cRange):Value = "UND STOCK".
    cRange = "E1".
    chWorkSheet:Range(cRange):Value = "UND. COMPRA". 
    cRange = "F1".
    chWorkSheet:Range(cRange):Value = "MND VENTA".
    cRange = "G1".
    chWorkSheet:Range(cRange):Value = "PRECIO OFICINA".

iColumn = 2.

FOR EACH tt-almmmatg NO-LOCK:
    cRange = "A" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.codmat.
    cRange = "B" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.DesMat.
    cRange = "C" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndBas.
    cRange = "D" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndStk.
    cRange = "E" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndCmp.                                       
    cRange = "F" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + STRING(tt-almmmatg.MonVta).
    cRange = "G" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-almmmatg.PreOfi.

    iColumn = iColumn + 1.
END.

    chWorkSheet:SaveAs(lArchivoSalida).
        chExcelApplication:DisplayAlerts = False.
        chExcelApplication:Quit().


        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_clientes W-Win 
PROCEDURE carga_clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_proveedores W-Win 
PROCEDURE carga_proveedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  DISPLAY FILL-IN-CodArt FILL-IN-msg 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-CodArt BUTTON-procesar BUTTON-1 BUTTON-salir 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa W-Win 
PROCEDURE procesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lRutaFile AS CHARACTER.
    DEFINE VAR rpta AS LOGICAL.
    DEFINE VAR x-Archivo AS CHARACTER.

    /*
        En donde alojo el archvio procesado
    */
        SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'Texto (*.XLS)' '*.XLS'
            ASK-OVERWRITE
            CREATE-TEST-FILE
            DEFAULT-EXTENSION '.xls'
            RETURN-TO-START-DIR
            SAVE-AS
            TITLE 'Exportar a XLS'
            UPDATE rpta.

        IF rpta = NO OR x-Archivo = '' THEN RETURN.

        lArchivoSalida = x-Archivo.

        RUN carga_articulos.
        
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

