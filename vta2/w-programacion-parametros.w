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
DEFINE SHARED VAR pRCID AS INT.

DEFINE VAR lDivisiones AS CHAR.
DEFINE VAR lTotCotizaciones AS DEC.

DEFINE TEMP-TABLE tt-ccbcdocu LIKE ccbcdocu.

DEFINE TEMP-TABLE tt-cabecera
        FIELDS tt-coddiv AS CHAR
        FIELDS tt-fproceso AS DATE
        FIELDS tt-totcotiz AS DEC
        FIELDS tt-ndias AS INT
        FIELDS tt-meta AS DEC
        FIELDS tt-fdesde AS DATE
        FIELDS tt-fhasta AS DATE
        FIELDS tt-div-vtas AS CHAR EXTENT 50
        FIELDS tt-ndivisiones AS INT
            INDEX idx01 IS PRIMARY tt-coddiv tt-fproceso.

DEFINE TEMP-TABLE tt-detalle
        FIELDS tt-coddiv AS CHAR
        FIELDS tt-sec AS INT
        FIELDS tt-dia-sem AS INT
        FIELDS tt-fecha AS DATE
        FIELDS tt-div-imp AS DEC EXTENT 50
        FIELDS tt-tot-dia AS DEC
        FIELDS tt-tot-acu AS DEC
        FIELDS tt-meta-dia AS DEC
        FIELDS tt-por-ava AS DEC
            INDEX idx01 IS PRIMARY tt-coddiv tt-sec.

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
&Scoped-Define ENABLED-OBJECTS RECT-4 txtDesde txtHasta chkPreventa ~
btnProcesar chkExpolibreria chkCanalModerno chkProvincia 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta chkPreventa ~
chkExpolibreria chkCanalModerno chkProvincia txtMsg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Grabar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE txtMsg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.57 BY 4.27.

DEFINE VARIABLE chkCanalModerno AS LOGICAL INITIAL no 
     LABEL "Canal Moderno" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .77 NO-UNDO.

DEFINE VARIABLE chkExpolibreria AS LOGICAL INITIAL no 
     LABEL "Expo Libreria" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .77 NO-UNDO.

DEFINE VARIABLE chkPreventa AS LOGICAL INITIAL no 
     LABEL "Preventas" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .77 NO-UNDO.

DEFINE VARIABLE chkProvincia AS LOGICAL INITIAL no 
     LABEL "Provincia" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtDesde AT ROW 2.5 COL 18 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 2.5 COL 46.57 COLON-ALIGNED WIDGET-ID 4
     chkPreventa AT ROW 5.04 COL 19 WIDGET-ID 6
     btnProcesar AT ROW 5.92 COL 55 WIDGET-ID 14
     chkExpolibreria AT ROW 6 COL 19 WIDGET-ID 8
     chkCanalModerno AT ROW 6.92 COL 19 WIDGET-ID 10
     chkProvincia AT ROW 7.88 COL 19 WIDGET-ID 12
     txtMsg AT ROW 9.08 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     "Divisiones" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 4.08 COL 18 WIDGET-ID 20
     RECT-4 AT ROW 4.77 COL 17.43 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.58 WIDGET-ID 100.


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
         TITLE              = "Programacion de Ventas"
         HEIGHT             = 9.58
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
/* SETTINGS FOR FILL-IN txtMsg IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Programacion de Ventas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Programacion de Ventas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar W-Win
ON CHOOSE OF btnProcesar IN FRAME F-Main /* Grabar */
DO:
    lDivisiones = "".
    
    ASSIGN txtDesde txtHasta
      chkPreventa chkExpolibreria chkCanalmoderno chkProvincia.

  IF chkPreventa = YES THEN lDivisiones = "00015".
  IF chkExpolibreria = YES THEN DO:
      IF lDivisiones = "" THEN DO:
          lDivisiones = "10015".
      END.
      ELSE lDivisiones = lDivisiones + ",10015".
  END.
  IF chkCanalModerno = YES THEN DO:
      IF lDivisiones = "" THEN DO:
          lDivisiones = "00017".
      END.
      ELSE lDivisiones = lDivisiones + ",00017".
  END.
  IF chkProvincia = YES THEN DO:
      IF lDivisiones = "" THEN DO:
          lDivisiones = "00018".
      END.
      ELSE lDivisiones = lDivisiones + ",00018".
  END.
  IF lDivisiones = "" THEN DO:
      MESSAGE "Seleccione Divisiones..." VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

  IF txtDesde > txtHasta THEN DO:
      MESSAGE "Rango de Fecha ERRADA" VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  IF (chkPreventa = NO AND chkExpolibreria = NO AND chkCanalModerno = NO
      AND chkProvincia = NO ) THEN DO:
      MESSAGE "Seleccione a menos una Division" VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  /*RUN ue-procesar.*/
  RUN ue-grabar.  
  SESSION:SET-WAIT-STATE('').

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
  DISPLAY txtDesde txtHasta chkPreventa chkExpolibreria chkCanalModerno 
          chkProvincia txtMsg 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-4 txtDesde txtHasta chkPreventa btnProcesar chkExpolibreria 
         chkCanalModerno chkProvincia 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  chkPreventa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no'.
  chkExpoLibreria:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no'.
  chkCanalModerno:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no'.
  chkProvincia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no'.

  FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
      factabla.tabla = 'RV' AND factabla.codigo = 'RV0001' 
      NO-LOCK NO-ERROR.

  IF NOT AVAILABLE factabla THEN DO:
      txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 30,"99/99/9999").
      txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").
  END.
  ELSE DO:
      txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(factabla.campo-d[1],"99/99/9999").
      txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(factabla.campo-d[2],"99/99/9999").  

      IF factabla.campo-c[1]='00015' THEN chkPreventa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'yes'.
      IF factabla.campo-c[2]='10015' THEN chkExpoLibreria:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'yes'.
      IF factabla.campo-c[3]='00017' THEN chkCanalModerno:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'yes'.
      IF factabla.campo-c[4]='00018' THEN chkProvincia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'yes'.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Generando el Excel...' .

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE x-signo                 AS DECI.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

FIND FIRST tt-cabecera NO-LOCK NO-ERROR.

 iColumn = 4.

 cRange = "C1".
 chWorkSheet:Range(cRange):Value = "Total".
 cRange = "D1".
 chWorkSheet:Range(cRange):Value = tt-totcotiz.
 cRange = "C2".
 chWorkSheet:Range(cRange):Value = "Dias".
 cRange = "D2".
 chWorkSheet:Range(cRange):Value = tt-ndias.
 cRange = "C3".
 chWorkSheet:Range(cRange):Value = "Meta".
 cRange = "D3".
 chWorkSheet:Range(cRange):Value = tt-meta.

cRange = "A4".
chWorkSheet:Range(cRange):Value = "Sec".
cRange = "B4".
chWorkSheet:Range(cRange):Value = "Dia.Sem".
cRange = "C4".
chWorkSheet:Range(cRange):Value = "Dia".

REPEAT iIndex = 1 TO tt-ndivisiones :
    cRange = CHR(67 + iIndex) + "4".
    chWorkSheet:Range(cRange):Value = "'" + tt-div-vtas[iIndex].
END.

cRange = CHR(67 + iIndex) + "4".
chWorkSheet:Range(cRange):Value = "Total Dia".
iIndex = iIndex + 1.
cRange = CHR(67 + iIndex) + "4".
chWorkSheet:Range(cRange):Value = "Total Acumulado".
iIndex = iIndex + 1.
cRange = CHR(67 + iIndex) + "4".
chWorkSheet:Range(cRange):Value = "Meta".
iIndex = iIndex + 1.
cRange = CHR(67 + iIndex) + "4".
chWorkSheet:Range(cRange):Value = "%".

FOR EACH tt-detalle :
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-sec.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-dia-sem.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-fecha.

    REPEAT iIndex = 1 TO tt-cabecera.tt-ndivisiones :
        cRange = CHR(67 + iIndex) + cColumn.
        chWorkSheet:Range(cRange):Value = tt-div-imp[iIndex].
    END.

    cRange = CHR(67 + iIndex) + cColumn.
    chWorkSheet:Range(cRange):Value = tt-tot-dia.
    iIndex = iIndex + 1.
    cRange = CHR(67 + iIndex) + cColumn.
    chWorkSheet:Range(cRange):Value = tt-tot-acu.
    iIndex = iIndex + 1.
    cRange = CHR(67 + iIndex) + cColumn.
    chWorkSheet:Range(cRange):Value = tt-meta-dia.
    iIndex = iIndex + 1.
    cRange = CHR(67 + iIndex) + cColumn.
    chWorkSheet:Range(cRange):Value = tt-por-ava.
END.
/*
/**/
iColumn = iColumn + 2.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Div.Origen".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Division".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Cod.Doc".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Nro Dcto".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Fecha Emision".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Importe".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):VALUE = "Tipo Fac".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):VALUE = "CndCre.".

FOR EACH tt-ccbcdocu :
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "'" + tt-ccbcdocu.divori.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "'" + tt-ccbcdocu.coddiv.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "'" + tt-ccbcdocu.coddoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "'" + tt-ccbcdocu.nrodoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-ccbcdocu.fchdoc.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-ccbcdocu.imptot.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-ccbcdocu.tpofac.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = tt-ccbcdocu.cndcre.
END.
*/
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

/*chExcelApplication:Quit().*/
chExcelApplication:Visible = TRUE.


/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-grabar W-Win 
PROCEDURE ue-grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
      factabla.tabla = 'RV' AND factabla.codigo = 'RV0001' 
      EXCLUSIVE NO-ERROR.

  IF NOT AVAILABLE factabla THEN DO:
      CREATE factabla.
        ASSIGN factabla.codcia = s-codcia
                factabla.tabla = 'RV'
                factabla.codigo = 'RV0001'.
        
  END.
  ASSIGN factabla.campo-c[1] = ""
        factabla.campo-c[2] = ""
        factabla.campo-c[3] = ""
        factabla.campo-c[4] = "".

  IF chkPreventa = YES THEN ASSIGN factabla.campo-c[1] = '00015'.
  IF chkExpoLibreria = YES THEN ASSIGN factabla.campo-c[2] = '10015'.
  IF chkCanalModerno = YES THEN ASSIGN factabla.campo-c[3] = '00017'.
  IF chkProvincia = YES THEN ASSIGN factabla.campo-c[4] = '00018'.

  ASSIGN factabla.campo-d[1] = txtDesde
            factabla.campo-d[2] = txtHasta
            factabla.valor[1] = pRCID.

  MESSAGE "Se Grabo OK" VIEW-AS ALERT-BOX.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar W-Win 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lSec AS INT.
DEFINE VAR lSec1 AS INT.
DEFINE VAR lDia AS DATE.

EMPTY TEMP-TABLE tt-cabecera.
EMPTY TEMP-TABLE tt-detalle.

txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Calculando los importe de las Cotizaciones' .

/* Sumando las Cotizaciones */
FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND 
    faccpedi.coddoc = 'COT' AND 
    (faccpedi.fchped  >= txtDesde AND faccpedi.fchped <= txtHasta ) AND
    LOOKUP (faccpedi.coddiv,lDivisiones) > 0 AND
    (faccpedi.flgest <> 'A')
    NO-LOCK :

    lTotCotizaciones = lTotCotizaciones + faccpedi.imptot.

END.

/* Cabecera */
CREATE tt-cabecera.
    ASSIGN tt-fproceso = TODAY
            tt-totcotiz = lTotCotizaciones
            tt-ndias    = (txtHasta - txtDesde) + 1
            tt-cabecera.tt-meta     = (lTotCotizaciones / tt-ndias)
            tt-fdesde   = txtDesde
            tt-fhasta   = txtHasta.
REPEAT lSec = 1 TO 50 : 
    ASSIGN tt-div-vtas[lSec] = "".
END.


/* Detalle x Dia*/
lSec =  0.
REPEAT lDia = txtDesde TO txtHasta:
    lSec = lSec + 1.
    CREATE tt-detalle.
        ASSIGN  tt-sec = lSec
                tt-dia-sem = WEEKDAY(lDia)
                tt-fecha = lDia
                tt-tot-dia = 0 
                tt-tot-acu = 0
                tt-meta-dia = 0
                tt-por-ava = 0.

        lSec1 = 0.
     REPEAT lSec1 = 1 TO 50 : 
         ASSIGN tt-div-imp[lSec1] = 0.
     END.       
END.

RUN ue-ventas.
RUN ue-totales.
RUN ue-excel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-totales W-Win 
PROCEDURE ue-totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iIndex AS INT.
DEFINE VAR lTotDia AS DEC.
DEFINE VAR lImpAnt AS DEC.
DEFINE VAR lAcuAnt AS DEC.

txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Calculando los Totales...' .

FIND FIRST tt-cabecera NO-LOCK NO-ERROR.

lImpAnt = 0.
lAcuAnt = 0.

FOR EACH tt-detalle :
    REPEAT iIndex = 1 TO tt-ndivisiones :
        ASSIGN tt-tot-dia = tt-tot-dia + tt-div-imp[iIndex].
    END.
    ASSIGN tt-tot-acu = lImpAnt + tt-tot-dia
        tt-meta-dia = (tt-cabecera.tt-totcotiz - lAcuAnt) / (tt-cabecera.tt-ndias - (tt-sec - 1) ) 
        tt-por-ava = (tt-tot-acu / tt-cabecera.tt-totcotiz) * 100 .
    lImpAnt = lImpAnt + tt-tot-dia.
    lAcuAnt = tt-tot-acu.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas W-Win 
PROCEDURE ue-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lDiv-vtas AS CHAR.
DEFINE VAR ldiv-pos AS INT.
DEFINE VAR lDiv-sec AS INT.
DEFINE VAR lSigno AS INT.
DEFINE VAR lDocOk AS LOG.
DEFINE VAR lTipoCamb AS DEC.

ldiv-sec = 0.
lDiv-vtas = "".

FOR EACH tt-detalle :
    txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Calculando las ventas del dia ' + STRING(tt-detalle.tt-fecha,"99/99/9999") .
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        (ccbcdocu.coddoc = 'TCK' OR ccbcdocu.coddoc = 'BOL' OR 
         ccbcdocu.coddoc = 'FAC' OR ccbcdocu.coddoc = 'N/C' OR
         ccbcdocu.coddoc = 'N/D') AND
        ccbcdocu.fchdoc = tt-detalle.tt-fecha AND
        ccbcdocu.flgest <> 'A' AND 
        LOOKUP(ccbcdocu.divori,lDivisiones) > 0 :

        /* Excepciones */
        /* si la N/C es por PRONTO PAGO, GO EFECTIVO ETC*/
        IF (ccbcdocu.coddoc = 'N/C' AND ccbcdocu.cndcre = 'N') THEN NEXT. 
        /* Si la Factura es por Adelanto de Campaña o Servicio. */
        IF ccbcdocu.coddoc = 'FAC' AND (ccbcdocu.tpofac = 'A' OR ccbcdocu.tpofac = 'S') THEN NEXT.

        lSigno = 1.
        IF ccbcdocu.coddoc = 'N/C' THEN lSigno = -1.
        /* Ubico la division */
        ldiv-pos = LOOKUP(ccbcdocu.coddiv,lDiv-vtas).

        /* Grabo la DIVISION en la cabecera */
        IF lDiv-Pos = 0 THEN DO:
            /* Si no existe */
            ldiv-sec = ldiv-sec + 1.
            IF lDiv-vtas = "" THEN DO:
                /* La primera DIV */
                lDiv-vtas = TRIM(ccbcdocu.coddiv).
            END.
            ELSE DO:
                lDiv-vtas = lDiv-vtas + "," + TRIM(ccbcdocu.coddiv).
            END.
            lDiv-pos = ldiv-sec.
            /* Actualizo la cabecera la lista de las divisiones */
            FIND FIRST tt-cabecera.
                ASSIGN tt-div-vtas[lDiv-pos] = TRIM(ccbcdocu.coddiv)
                    tt-ndivisiones = ldiv-sec .
        END.
        /* Acumulo Importes del detalle*/
        lDocOk = NO.

        lTipoCamb = 1.
        IF ccbcdocu.codmon <> 1 THEN lTipoCamb = ccbcdocu.tpocmb.
        FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
            ASSIGN tt-div-imp[lDiv-pos] = tt-div-imp[lDiv-pos] + ((ccbddocu.implin * lSigno) * lTipoCamb).
            lDocOk = YES.
        END.

        IF lDocOk = YES THEN DO:
            CREATE tt-ccbcdocu.
            BUFFER-COPY Ccbcdocu TO tt-ccbcdocu.
        END.

    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

