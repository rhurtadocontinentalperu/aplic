&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME nW-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE CcbCDocu
       field Proyeccion as dec extent 4
       field Canal      as character
       field Vencido    as dec
       field PorVencer  as dec.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS nW-Win 
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

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv  AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-FchVto BUTTON-3 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division x-FchVto f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado nW-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT cFlgEst AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSituacion nW-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUbicacion nW-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT cFlgUbi AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR nW-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 8 BY 1.92
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.88.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(100)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-FchVto AS DATE FORMAT "99/99/99":U 
     LABEL "Inicio de vencimientos" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.27 COL 65 WIDGET-ID 4
     FILL-IN-Division AT ROW 1.38 COL 18 COLON-ALIGNED WIDGET-ID 6
     x-FchVto AT ROW 2.35 COL 18 COLON-ALIGNED WIDGET-ID 8
     BUTTON-3 AT ROW 4.23 COL 11 WIDGET-ID 10
     Btn_Done AT ROW 4.23 COL 20 WIDGET-ID 12
     f-Mensaje AT ROW 6.38 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 6.58
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: Detalle T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          field Proyeccion as dec extent 4
          field Canal      as character
          field Vencido    as dec
          field PorVencer  as dec
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW nW-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PROYECCION DE COBRANZAS POR SEMANA"
         HEIGHT             = 6.58
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB nW-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW nW-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(nW-Win)
THEN nW-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME nW-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nW-Win nW-Win
ON END-ERROR OF nW-Win /* PROYECCION DE COBRANZAS POR SEMANA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nW-Win nW-Win
ON WINDOW-CLOSE OF nW-Win /* PROYECCION DE COBRANZAS POR SEMANA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done nW-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 nW-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = FILL-IN-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    FILL-IN-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 nW-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN
        FILL-IN-Division
        x-FchVto.
  IF x-FchVto = ? THEN RETURN NO-APPLY.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Excel.
  SESSION:SET-WAIT-STATE('').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Division nW-Win
ON LEAVE OF FILL-IN-Division IN FRAME F-Main /* División */
DO:
    ASSIGN FILL-IN-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchVto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchVto nW-Win
ON LEAVE OF x-FchVto IN FRAME F-Main /* Inicio de vencimientos */
DO:
  IF INPUT {&self-name} = ? OR WEEKDAY ( INPUT {&self-name} ) <> 2 THEN DO:
      MESSAGE 'La fecha debe corresponder a un día lunes'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK nW-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects nW-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available nW-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal nW-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-CodDiv AS CHAR NO-UNDO.
DEF VAR dFchVto LIKE Ccbcdocu.fchvto NO-UNDO.
DEF VAR x-Signo AS INT NO-UNDO.
DEF VAR i AS INT NO-UNDO.


EMPTY TEMP-TABLE Detalle.
DO i = 1 TO NUM-ENTRIES(FILL-IN-Division):
    x-CodDiv = ENTRY(i, FILL-IN-Division).
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddiv = x-CodDiv
        AND LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL,LET,CHQ,N/D,N/C,A/R,A/C,BD') > 0
        AND Ccbcdocu.flgest = 'P':
        /*IF Ccbcdocu.coddoc = 'LET' AND Ccbcdocu.flgsit = "D" THEN NEXT.*/
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " *** PROCESANDO " +
            ccbcdocu.coddiv + " " +
            ccbcdocu.coddoc + " " +
            ccbcdocu.nrodoc + " " +
            STRING(ccbcdocu.fchdoc) + " ***".
        CREATE Detalle.
        BUFFER-COPY CCbcdocu TO Detalle.
        ASSIGN
            dFchVto = Ccbcdocu.fchvto
            x-Signo = +1.
        IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D,BD,A/R,A/C,CHQ') > 0 THEN dFchVto = Ccbcdocu.fchdoc.
        IF LOOKUP(Ccbcdocu.coddoc, 'N/C,BD,A/R,A/C') > 0 THEN x-Signo = -1.
        ASSIGN
            Detalle.FchVto = dFchVto
            Detalle.ImpTot = x-Signo * Ccbcdocu.ImpTot
            Detalle.SdoAct = x-Signo * Ccbcdocu.SdoAct.
        CASE TRUE:
            WHEN dFchVto < x-FchVto 
                THEN Detalle.Vencido = Detalle.SdoAct.
            WHEN ( dFchVto >= x-FchVto AND dFchVto <= x-FchVto + 6 )
                THEN Detalle.Proyeccion[1] = Detalle.SdoAct.
            WHEN ( dFchVto >= ( x-FchVto + 7 ) AND dFchVto <= ( x-FchVto + 7 + 6 ) )
                THEN Detalle.Proyeccion[2] = Detalle.SdoAct.
            WHEN ( dFchVto >= ( x-FchVto + 7 * 2 ) AND dFchVto <= ( x-FchVto + 7 * 2 + 6 ) )
                THEN Detalle.Proyeccion[3] = Detalle.SdoAct.
            WHEN ( dFchVto >= ( x-FchVto + 7 * 3 ) AND dFchVto <= ( x-FchVto + 7 * 3 + 6 ) )
                THEN Detalle.Proyeccion[4] = Detalle.SdoAct.
            WHEN dFchVto > ( x-FchVto + 7 * 3 + 6 ) 
                THEN Detalle.PorVencer = Detalle.SdoAct * x-Signo.
        END CASE.
/*         IF Ccbcdocu.fchvto >= x-FchVto AND Ccbcdocu.FchVto <= x-FchVto + 6                         */
/*             THEN Detalle.Proyeccion[1] = Ccbcdocu.SdoAct.                                          */
/*         IF Ccbcdocu.fchvto >= ( x-FchVto + 7 ) AND Ccbcdocu.FchVto <= ( x-FchVto + 7 + 6 )         */
/*             THEN Detalle.Proyeccion[2] = Ccbcdocu.SdoAct.                                          */
/*         IF Ccbcdocu.fchvto >= ( x-FchVto + 7 * 2 ) AND Ccbcdocu.FchVto <= ( x-FchVto + 7 * 2 + 6 ) */
/*             THEN Detalle.Proyeccion[3] = Ccbcdocu.SdoAct.                                          */
/*         IF Ccbcdocu.fchvto >= ( x-FchVto + 7 * 3 ) AND Ccbcdocu.FchVto <= ( x-FchVto + 7 * 3 + 6 ) */
/*             THEN Detalle.Proyeccion[4] = Ccbcdocu.SdoAct.                                          */
/*         /* Vencidos y por vencer */                                                                */
/*         IF Ccbcdocu.fchvto < x-FchVto THEN Detalle.Vencido = Ccbcdocu.SdoAct.                      */
/*         IF Ccbcdocu.fchvto > ( x-FchVto + 7 * 3 + 6 ) THEN Detalle.PorVencer = Ccbcdocu.SdoAct.    */
        /*Canal Cliente*/
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN DO:
            FIND almtabla WHERE almtabla.Tabla = 'CN' 
                AND  almtabla.Codigo = gn-clie.Canal NO-LOCK NO-ERROR.
            IF AVAILABLE almtabla THEN Detalle.Canal = almtabla.nombre.
            IF Detalle.nomcli = '' THEN Detalle.nomcli = gn-clie.nomcli.
        END.
    END.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI nW-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(nW-Win)
  THEN DELETE WIDGET nW-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI nW-Win  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-Division x-FchVto f-Mensaje 
      WITH FRAME F-Main IN WINDOW nW-Win.
  ENABLE BUTTON-1 x-FchVto BUTTON-3 Btn_Done 
      WITH FRAME F-Main IN WINDOW nW-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW nW-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel nW-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    /* Cargamos temporal */
    RUN Carga-Temporal.

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE
            'No hay registro a imprimir'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

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

    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "DOC".
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NUMERO".
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "EMISION".
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "VENCIMIENTO".
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "MON".
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "IMPORTE".
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "MORA".
    cRange = "J" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "VENCIDOS".
    cRange = "K" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "REPROGRAMACION".
    cRange = "L" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Del " + STRING(x-FchVto, '99/99/99') + " al " + STRING(x-FchVto + 6, '99/99/99').
    cRange = "M" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Del " + STRING(x-FchVto + 7, '99/99/99') + " al " + STRING(x-FchVto + 7 + 6, '99/99/99').
    cRange = "N" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Del " + STRING(x-FchVto + 7 * 2, '99/99/99') + " al " + STRING(x-FchVto + 7 * 2 + 6, '99/99/99').
    cRange = "O" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "Del " + STRING(x-FchVto + 7 * 3, '99/99/99') + " al " + STRING(x-FchVto + 7 * 3 + 6, '99/99/99').
    cRange = "P" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "POR VENCER".
    cRange = "Q" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "CANAL CLIENTE".
    cRange = "R" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "UBICACION".
    cRange = "S" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "SITUACION".

    FOR EACH Detalle:
        t-column = t-column + 1.                                                                                                                               
        cColumn = STRING(t-Column).                                                                                        
        cRange = "A" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.coddoc.
        cRange = "B" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + detalle.nrodoc.
        IF detalle.fchdoc <> ? THEN DO:
            cRange = "C" + cColumn.                                                                                                                                
            chWorkSheet:Range(cRange):Value = detalle.fchdoc.
        END.
        IF detalle.fchvto<> ? THEN DO:
            cRange = "D" + cColumn.                                                                                                                                
            chWorkSheet:Range(cRange):Value = detalle.fchvto.
        END.
        cRange = "E" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = "'" + detalle.codcli.
        cRange = "F" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.nomcli.
        cRange = "G" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.codmon.
        cRange = "H" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.imptot.
        cRange = "I" + cColumn.                                                                                                                                
        IF detalle.fchvto <> ? THEN DO:
            chWorkSheet:Range(cRange):Value = TODAY - detalle.fchvto.
            cRange = "J" + cColumn.                                                                                                                                
        END.
        chWorkSheet:Range(cRange):Value = detalle.vencido.
        cRange = "L" + cColumn.     
        chWorkSheet:Range(cRange):Value = detalle.proyeccion[1].
        cRange = "M" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = detalle.proyeccion[2].
        cRange = "N" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = detalle.proyeccion[3].
        cRange = "O" + cColumn.                                                                                    
        chWorkSheet:Range(cRange):Value = detalle.proyeccion[4].
        cRange = "P" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.porvencer.
        cRange = "Q" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = detalle.canal.
        IF Detalle.CodDoc = "LET" THEN DO:
            cRange = "R" + cColumn.                                                                                                                                
            chWorkSheet:Range(cRange):Value = fUbicacion(detalle.flgubi).
            cRange = "S" + cColumn.                                                                                                                                
            chWorkSheet:Range(cRange):Value = fSituacion(detalle.flgsit).
        END.
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit nW-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize nW-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  x-FchVto = TODAY.
  REPEAT WHILE WEEKDAY(x-FchVto) <> 2:
      x-FchVto = x-FchVto - 1.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records nW-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed nW-Win 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado nW-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT cFlgEst AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cFlgEst:
    WHEN 'P' THEN RETURN 'PEN'.
    WHEN 'A' THEN RETURN 'ANU'.
    WHEN 'C' THEN RETURN 'CAN'.
  END CASE.
  RETURN cFlgEst.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSituacion nW-Win 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cflgsit:
    WHEN 'T' THEN RETURN 'Transito'.
    WHEN 'C' THEN RETURN 'Cobranza Libre'.
    WHEN 'G' THEN RETURN 'Cobranza Garantia'.
    WHEN 'D' THEN RETURN 'Descuento'.
    WHEN 'P' THEN RETURN 'Protestada'.
  END CASE.
  RETURN cflgsit.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUbicacion nW-Win 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT cFlgUbi AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cflgubi:
    WHEN 'C' THEN RETURN 'Cartera'.
    WHEN 'B' THEN RETURN 'Banco'.
  END CASE.
  RETURN cflgubi.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

