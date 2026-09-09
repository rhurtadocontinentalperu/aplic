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
DEF SHARED VAR s-coddiv AS CHAR.

/*Tabla Temporal*/
DEFINE TEMP-TABLE tmp-datos
    FIELDS codmat LIKE almmmatg.codmat
    FIELDS desmat LIKE almmmatg.desmat
    FIELDS canmat AS DECIMAL EXTENT 55.

DEFINE VARIABLE iSem AS INTEGER     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 x-Periodo-1 x-NroSem-1 x-Periodo-2 ~
x-NroSem-2 BUTTON-3 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo-1 x-NroSem-1 x-Periodo-2 ~
x-NroSem-2 txt-msj 

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
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.62.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-NroSem-1 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "desde la semana" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE x-NroSem-2 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "hasta la semana" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo-1 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Desde el periodo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo-2 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Hasta el periodo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 3.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Periodo-1 AT ROW 3.42 COL 20 COLON-ALIGNED WIDGET-ID 12
     x-NroSem-1 AT ROW 3.42 COL 52 COLON-ALIGNED HELP
          "Ingresar un número entre 1 y 52" WIDGET-ID 10
     x-Periodo-2 AT ROW 4.5 COL 20 COLON-ALIGNED WIDGET-ID 16
     x-NroSem-2 AT ROW 4.5 COL 52 COLON-ALIGNED HELP
          "Ingresar un número entre 1 y 52" WIDGET-ID 14
     BUTTON-3 AT ROW 6.38 COL 3 WIDGET-ID 20
     BtnDone AT ROW 6.38 COL 11 WIDGET-ID 22
     txt-msj AT ROW 6.77 COL 21 NO-LABEL WIDGET-ID 2
     "ENTREGAR MERCADERIA" VIEW-AS TEXT
          SIZE 25 BY .54 AT ROW 2.08 COL 5 WIDGET-ID 18
          BGCOLOR 7 FGCOLOR 15 
     RECT-1 AT ROW 2.35 COL 3 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.69 WIDGET-ID 100.


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
         TITLE              = "COTIZACIONES PENDIENTES POR SEMANA"
         HEIGHT             = 7.69
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* COTIZACIONES PENDIENTES POR SEMANA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* COTIZACIONES PENDIENTES POR SEMANA */
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  ASSIGN
      x-NroSem-1 x-NroSem-2 x-Periodo-1 x-Periodo-2.

  isem = 0.
  /* VALIDACION */
  IF x-Periodo-1 > x-Periodo-2 THEN DO:
      MESSAGE 'Ingrese los periodos correctamente'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FIND Evtsemanas WHERE codcia = s-codcia
      AND periodo = x-Periodo-1
      AND nrosem = x-NroSem-1
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Evtsemanas THEN DO:
      MESSAGE 'NO está configurado el cuadro de semanas para el' x-Periodo-1 'semana' x-NroSem-1
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FIND Evtsemanas WHERE codcia = s-codcia
      AND periodo = x-Periodo-2
      AND nrosem = x-NroSem-2
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Evtsemanas THEN DO:
      MESSAGE 'NO está configurado el cuadro de semanas para el' x-Periodo-2 'semana' x-NroSem-2
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  
  IF x-periodo-1 = x-periodo-2 THEN DO:
      IF x-NroSem-2 < x-NroSem-1 THEN DO:
          MESSAGE 'Información ingresada es incorrecta'
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          APPLY 'ENTRY' TO x-NroSem-2.
          RETURN NO-APPLY.
      END.

      IF (x-NroSem-2 - x-NroSem-1) > 8 THEN DO:
          MESSAGE 'El rango de semanas no puede ser mayor a 8'
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          APPLY 'ENTRY' TO x-NroSem-2.
          RETURN NO-APPLY.
      END.
      iSem = (x-NroSem-2 - x-NroSem-1) + 1.
  END.
  ELSE DO:
      FIND LAST evtsemanas WHERE evtsemanas.codcia = s-codcia
          AND evtsemanas.periodo = x-periodo-1 NO-LOCK NO-ERROR.
      IF AVAIL evtsemanas THEN iSem = (evtsemanas.nrosem - x-nrosem-1).
      isem = (isem + x-NroSem-2) + 1.
      IF isem > 8 THEN DO:
          MESSAGE 'El rango de semanas no puede ser mayor a 8'
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          APPLY 'ENTRY' TO x-NroSem-2.
          RETURN NO-APPLY.
          isem = 0.
      END.
  END.
  RUN Excel.
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroSem-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroSem-1 W-Win
ON LEAVE OF x-NroSem-1 IN FRAME F-Main /* desde la semana */
DO:
  IF NOT ( INPUT {&self-name} >= 1 AND INPUT {&self-name} <= 52 ) THEN DO:
      MESSAGE 'Debe ingresar un valor entre 1 y 52'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroSem-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroSem-2 W-Win
ON LEAVE OF x-NroSem-2 IN FRAME F-Main /* hasta la semana */
DO:
    IF NOT ( INPUT {&self-name} >= 1 AND INPUT {&self-name} <= 52 ) THEN DO:
        MESSAGE 'Debe ingresar un valor entre 1 y 52'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
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
    DEFINE VARIABLE dDesde   AS DATE NO-UNDO.    
    DEFINE VARIABLE dHasta   AS DATE NO-UNDO.
    DEFINE VARIABLE dInicio  AS DATE NO-UNDO.
    DEFINE VARIABLE dFin     AS DATE NO-UNDO.
    DEFINE VARIABLE dSemanaI AS DATE NO-UNDO.
    DEFINE VARIABLE dSemanaF AS DATE NO-UNDO.
    DEFINE VARIABLE dInt     AS INT  NO-UNDO INIT 1.

    txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.

    RUN bin/_dateif (01, x-periodo-1, OUTPUT dInicio, OUTPUT dFin).

    dDesde = dInicio.
    FIND FIRST EvtSemanas WHERE EvtSemanas.CodCia = s-codcia
        AND EvtSemanas.Periodo = x-periodo-1
        AND EvtSemanas.NroSem  = x-nrosem-1 NO-LOCK NO-ERROR.
    IF AVAIL evtsemanas THEN dHasta = EvtSemanas.FecIni.

    /*Carga Documentos Vencidos*/
    FOR EACH FacCPedi WHERE FacCPedi.CodCia = s-CodCia
        AND FacCPedi.CodDiv =  s-coddiv 
        AND FacCPedi.CodDoc =  'COT'
        AND FacCPedi.FlgEst =  'P'        
        AND FacCPedi.fchent >= dDesde
        AND FacCPedi.fchent <  dHasta NO-LOCK,
        EACH FacDPedi OF FacCPedi NO-LOCK:
        FIND FIRST tmp-datos WHERE tmp-datos.codmat = FacDPedi.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAIL tmp-datos THEN DO:
            CREATE tmp-datos.
            ASSIGN tmp-datos.codmat = FacDPedi.codmat.
        END.
        ASSIGN tmp-datos.canmat[dInt] = tmp-datos.canmat[dInt] + ((FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.Factor ).
    END.
    /********************************/

    dDesde = dHasta.
    FIND FIRST EvtSemanas WHERE EvtSemanas.CodCia = s-codcia
        AND EvtSemanas.Periodo = x-periodo-2
        AND EvtSemanas.NroSem  = x-nrosem-2 NO-LOCK NO-ERROR.
    IF AVAIL evtsemanas THEN dHasta = EvtSemanas.FecFin.
    
    /*Carga Datos dentro del rango*/
    dInt = dInt + 1.
    IF x-periodo-1 = x-periodo-2 THEN DO:
        FOR EACH EvtSemanas WHERE EvtSemanas.codcia = s-codcia
            AND EvtSemanas.periodo =  x-periodo-1            
            AND EvtSemanas.NroSem  >= x-nrosem-1
            AND EvtSemanas.NroSem  <= x-nrosem-2 NO-LOCK:

            FOR EACH FacCPedi WHERE FacCPedi.CodCia = s-CodCia
                AND FacCPedi.CodDiv = s-coddiv 
                AND FacCPedi.CodDoc = 'COT'
                AND FacCPedi.FlgEst = 'P' 
                AND FacCPedi.fchent >= EvtSemanas.FecIni 
                AND FacCPedi.fchent <= EvtSemanas.FecFin NO-LOCK,
                EACH FacDPedi OF FacCPedi NO-LOCK:

                FIND FIRST tmp-datos WHERE tmp-datos.codmat = FacDPedi.CodMat NO-LOCK NO-ERROR.
                IF NOT AVAIL tmp-datos THEN DO:
                    CREATE tmp-datos.
                    ASSIGN tmp-datos.codmat = FacDPedi.codmat.
                END.
                ASSIGN tmp-datos.canmat[dInt] = tmp-datos.canmat[dInt] + ((FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.Factor).
            END.
            dInt = dInt + 1.
        END.
    END.
    ELSE DO:
        FOR EACH EvtSemanas WHERE EvtSemanas.codcia = s-codcia
            AND EvtSemanas.periodo = x-periodo-1            
            AND EvtSemanas.NroSem  >= x-nrosem-1 NO-LOCK:

            FOR EACH FacCPedi WHERE FacCPedi.CodCia = s-CodCia
                AND FacCPedi.CodDiv = s-coddiv 
                AND FacCPedi.CodDoc = 'COT'
                AND FacCPedi.FlgEst = 'P' 
                AND FacCPedi.fchent >= EvtSemanas.FecIni 
                AND FacCPedi.fchent <= EvtSemanas.FecFin NO-LOCK,
                EACH FacDPedi OF FacCPedi NO-LOCK:

                FIND FIRST tmp-datos WHERE tmp-datos.codmat = FacDPedi.CodMat NO-LOCK NO-ERROR.
                IF NOT AVAIL tmp-datos THEN DO:
                    CREATE tmp-datos.
                    ASSIGN tmp-datos.codmat = FacDPedi.codmat.
                END.
                ASSIGN tmp-datos.canmat[dInt] = tmp-datos.canmat[dInt] + ((FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.Factor).
            END.
            dInt = dInt + 1.
        END.

        FOR EACH EvtSemanas WHERE EvtSemanas.codcia = s-codcia
            AND EvtSemanas.periodo = x-periodo-2            
            AND EvtSemanas.NroSem  <= x-nrosem-2 NO-LOCK:

            FOR EACH FacCPedi WHERE FacCPedi.CodCia = s-CodCia
                AND FacCPedi.CodDiv = s-coddiv 
                AND FacCPedi.CodDoc = 'COT'
                AND FacCPedi.FlgEst = 'P' 
                AND FacCPedi.fchent >= EvtSemanas.FecIni 
                AND FacCPedi.fchent <= EvtSemanas.FecFin NO-LOCK,
                EACH FacDPedi OF FacCPedi NO-LOCK:

                FIND FIRST tmp-datos WHERE tmp-datos.codmat = FacDPedi.CodMat NO-LOCK NO-ERROR.
                IF NOT AVAIL tmp-datos THEN DO:
                    CREATE tmp-datos.
                    ASSIGN tmp-datos.codmat = FacDPedi.codmat.
                END.
                ASSIGN tmp-datos.canmat[dInt] = tmp-datos.canmat[dInt] + ((FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.Factor).
            END.
            dInt = dInt + 1.
        END.
    END.

    /*Carga Documentos x Vencidos*/
    RUN bin/_dateif (12, x-periodo-1, OUTPUT dInicio, OUTPUT dFin).
    dInt = 10.    
    FOR EACH FacCPedi WHERE FacCPedi.CodCia = s-CodCia
        AND FacCPedi.CodDiv = s-coddiv 
        AND FacCPedi.CodDoc =  'COT'
        AND FacCPedi.FlgEst =  'P'         
        AND FacCPedi.fchent >  dHasta 
        AND FacCPedi.fchent <= dFin NO-LOCK,
        EACH FacDPedi OF FacCPedi NO-LOCK:
        FIND FIRST tmp-datos WHERE tmp-datos.codmat = FacDPedi.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAIL tmp-datos THEN DO:
            CREATE tmp-datos.
            ASSIGN tmp-datos.codmat = FacDPedi.codmat.
        END.
        ASSIGN tmp-datos.canmat[dInt] = tmp-datos.canmat[dInt] + ((FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.Factor).
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
  DISPLAY x-Periodo-1 x-NroSem-1 x-Periodo-2 x-NroSem-2 txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 x-Periodo-1 x-NroSem-1 x-Periodo-2 x-NroSem-2 BUTTON-3 BtnDone 
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
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER     NO-UNDO.
RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("B2"):Value = "REPORTE COT PENDIENTES POR SEMANA".

chWorkSheet:Range("A3"):Value = "Material".
chWorkSheet:Range("B3"):Value = "Descripcion".
chWorkSheet:Range("C3"):Value = "Vencidos".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".

t-Letra  = ASC('D').
t-column = 3.
cletra   = ''.

IF x-periodo-1 = x-periodo-2 THEN DO:
    FOR EACH evtsemanas WHERE evtsemanas.codcia = s-codcia
        AND evtsemanas.periodo = x-periodo-1        
        AND evtsemanas.nrosem  >= x-nrosem-1
        AND evtsemanas.nrosem  <= x-nrosem-2 NO-LOCK:        
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange  = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = 'Semana ' + STRING(evtsemanas.nrosem) + ' del ' + STRING(x-periodo-1).        

        t-col = t-column + 1 .
        cRange  = cLetra2 + cLetra + STRING(t-col).
        chWorkSheet:Range(cRange):Value =  STRING(evtsemanas.fecini) + ' al ' + STRING(evtsemanas.fecfin).        

        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' THEN cLetra2 = 'A'.
        END.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
END.
ELSE DO:
    FOR EACH evtsemanas WHERE evtsemanas.codcia = s-codcia
        AND evtsemanas.periodo = x-periodo-1        
        AND evtsemanas.nrosem  >= x-nrosem-1 NO-LOCK:
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange  = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = 'Semana ' + STRING(evtsemanas.nrosem) + ' del ' + STRING(x-periodo-1).
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' THEN cLetra2 = 'A'.
        END.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    FOR EACH evtsemanas WHERE evtsemanas.codcia = s-codcia
        AND evtsemanas.periodo = x-periodo-2        
        AND evtsemanas.nrosem  <= x-nrosem-2 NO-LOCK:
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange  = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = 'Semana ' + STRING(evtsemanas.nrosem) + ' del ' + STRING(x-periodo-2).
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' THEN cLetra2 = 'A'.
        END.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
END.
cColumn = STRING(t-Column).
cLetra  = CHR(t-Letra).
cRange  = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = 'Por Vencer'.

t-column = 4.
FOR EACH tmp-datos NO-LOCK:
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.codmat = tmp-datos.codmat NO-LOCK NO-ERROR.

    t-Letra  = ASC('D').
    cletra   = ''.
    t-column = t-column + 1.
    /* DATOS DEL PRODUCTO */    
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.CodMat.
    IF AVAIL almmmatg THEN DO:
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    END.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.canmat[1].

    DO iInt = 2 TO (iSem + 1):
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange  = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-datos.canmat[iInt].        
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' THEN cLetra2 = 'A'.
        END.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange  = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.canmat[10].
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
  ASSIGN
      x-Periodo-1 = YEAR(TODAY)
      x-Periodo-2 = YEAR(TODAY)
      x-NroSem-1  = 1
      x-NroSem-2  = 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.

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

