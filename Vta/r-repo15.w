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
DEFINE NEW SHARED VAR s-coddoc  AS CHAR INIT 'COT'.
DEFINE SHARED VAR s-coddiv      AS CHAR.
DEFINE SHARED VAR s-codcia      AS INT.
DEFINE SHARED VAR cl-codcia     AS INT.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE tmp-tempo
    FIELD t-codcia LIKE Almmmatg.codcia
    FIELD t-coddoc LIKE ccbcdocu.coddoc
    FIELD t-nrodoc LIKE ccbcdocu.nrodoc
    FIELD t-fchped LIKE faccpedi.fchped
    FIELD t-codven LIKE faccpedi.codven
    FIELD t-nomcli LIKE faccpedi.nomcli
    FIELD t-codmat LIKE Almmmatg.codmat
    FIELD t-desmat LIKE Almmmatg.desmat
    FIELD t-desmar LIKE Almmmatg.desmar
    FIELD t-undbas LIKE Almmmatg.undbas
    FIELD t-canped LIKE FacDPedi.CanPed 
    FIELD t-canate LIKE INTEGRAL.FacDPedi.canate
    FIELD t-codcli LIKE faccpedi.codcli
    INDEX llave01 t-codcia t-coddoc t-nrodoc.

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
&Scoped-Define ENABLED-OBJECTS txt-cliente txt-cotiza DesdeF HastaF ~
Btn_Excel Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS txt-coddiv txt-cliente x-NomCli txt-cotiza ~
DesdeF HastaF x-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Salida a Excel".

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE txt-cliente AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE txt-coddiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE txt-cotiza AS CHARACTER FORMAT "X(9)":U 
     LABEL "Cotizacion" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-coddiv AT ROW 1.65 COL 9 COLON-ALIGNED WIDGET-ID 32
     txt-cliente AT ROW 2.62 COL 9 COLON-ALIGNED WIDGET-ID 12
     x-NomCli AT ROW 2.62 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     txt-cotiza AT ROW 3.58 COL 9 COLON-ALIGNED WIDGET-ID 18
     DesdeF AT ROW 4.5 COL 9 COLON-ALIGNED WIDGET-ID 20
     HastaF AT ROW 4.5 COL 28 COLON-ALIGNED WIDGET-ID 22
     Btn_Excel AT ROW 6.12 COL 11 WIDGET-ID 2
     Btn_Cancel AT ROW 6.12 COL 31 WIDGET-ID 4
     x-Mensaje AT ROW 7.73 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.43 BY 7.73
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "REPORTE COT PENDIENTES DE ATENDER"
         HEIGHT             = 7.73
         WIDTH              = 73.43
         MAX-HEIGHT         = 7.73
         MAX-WIDTH          = 73.43
         VIRTUAL-HEIGHT     = 7.73
         VIRTUAL-WIDTH      = 73.43
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
/* SETTINGS FOR FILL-IN txt-coddiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE COT PENDIENTES DE ATENDER */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE COT PENDIENTES DE ATENDER */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:                            
    ASSIGN
        DesdeF txt-cliente txt-cotiza HastaF .
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Excel. 
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-cliente W-Win
ON LEAVE OF txt-cliente IN FRAME F-Main /* Cliente */
DO:
    ASSIGN {&SELF-NAME}.
    IF {&SELF-NAME} <> '' THEN DO:
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = TRIM({&SELF-NAME}) NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN DISPLAY gn-clie.nomcli @ x-NomCli WITH FRAME {&FRAME-NAME}.
    END.
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

    EMPTY TEMP-TABLE tmp-tempo.    
    FOR EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = S-CODCIA
        AND FacCPedi.CodDiv = S-CODDIV
        AND FacCPedi.CodDoc = S-CODDOC
        AND (FacCPedi.FlgEst = "P" OR FacCPedi.FlgEst = "E")
        AND faccpedi.fchped >= DesdeF
        AND faccpedi.fchped <= HastaF
        AND (txt-cliente = '' OR faccpedi.codcli = txt-cliente)
        AND (txt-cotiza = '' OR faccpedi.nroped = txt-cotiza),
        EACH facdpedi OF faccpedi NO-LOCK,
        FIRST Almmmatg OF Facdpedi NO-LOCK:
        /* filtros */
        IF (facdpedi.canped - facdpedi.canate) <= 0 THEN NEXT.
        /*IF FaccPedi.FchVen < TODAY AND Faccpedi.flgest = 'P' THEN NEXT.*/
    
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** PROCESANDO " + faccpedi.nroped + " **".
    
        CREATE tmp-tempo.
        ASSIGN 
            t-codcia = faccpedi.codcia 
            t-coddoc = faccpedi.coddoc
            t-nrodoc = faccpedi.nroped
            t-fchped = faccpedi.fchped
            t-codven = faccpedi.codven
            t-codmat = facdpedi.codmat
            t-canped = facdpedi.canped
            t-canate = facdpedi.canate
            t-codcli = faccpedi.codcli
            t-nomcli = faccpedi.nomcli
            t-desmat = almmmatg.desmat
            t-desmar = almmmatg.desmar
            t-undbas = almmmatg.undbas.
    
    END.
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIND DEL PROCESO **".

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
  DISPLAY txt-coddiv txt-cliente x-NomCli txt-cotiza DesdeF HastaF x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-cliente txt-cotiza DesdeF HastaF Btn_Excel Btn_Cancel 
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

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

RUN Carga-temporal.

/*Cabecera*/

t-column = t-column + 1. 
cColumn = STRING(t-Column).                                           
cRange = "E" + cColumn.                                                                                             
chWorkSheet:Range(cRange):Value = 'Reporte de Cotizaciones pendientes'. 

/*Formato*/
chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".
chWorkSheet:Columns("F"):NumberFormat = "@".

/*Cabecera de Listado*/
t-column = t-column + 2. 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CodDoc".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Cotizacion".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Fecha".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Vendedor".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Cliente".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CodMat".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "UND.".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Cant.Pedida".
cRange = "K" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Cant.Atendida".
cRange = "L" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "Pendiente por atender".

FOR EACH tmp-tempo,
    FIRST gn-ven NO-LOCK WHERE gn-ven.codcia = s-codcia
    AND gn-ven.codven = tmp-tempo.t-codven
    BY t-nrodoc BY t-fchped :
    t-column = t-column + 1.                                                                                  
    cColumn = STRING(t-Column).                                           
    cRange = "A" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = t-coddoc. 
    cRange = "B" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = t-nrodoc.                                                                  
    cRange = "C" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = t-fchped.             
    cRange = "D" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = tmp-tempo.t-codven + ' ' + gn-ven.nomven.
    cRange = "E" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = t-nomcli.             
    cRange = "F" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = t-codmat.             
    cRange = "G" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = t-desmat.             
    cRange = "H" + cColumn.                                                                                             
    chWorkSheet:Range(cRange):Value = t-desmar.
    cRange = "I" + cColumn.                                                                                   
    chWorkSheet:Range(cRange):Value = t-undbas.
    cRange = "J" + cColumn.                                                                                   
    chWorkSheet:Range(cRange):Value = t-canped.
    cRange = "K" + cColumn.                                       
    chWorkSheet:Range(cRange):Value = t-canate.
    cRange = "L" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = (t-canped - t-canate).
END.
HIDE FRAME F-Proceso NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

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
      DesdeF = TODAY - DAY(TODAY) + 1
      HastaF = TODAY
      txt-coddiv = s-coddiv.
  /*DISPLAY s-coddiv @ txt-coddiv WITH FRAME {&FRAME-NAME}.*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "x-subfam" THEN
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
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

