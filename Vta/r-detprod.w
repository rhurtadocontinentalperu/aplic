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

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/* Local Variable Definitions ---                                       */
DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

DEFINE VAR s-subtitu AS CHAR FORMAt "X(60)" .

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
&Scoped-Define ENABLED-OBJECTS BUTTON-4 BUTTON-6 BUTTON-7 F-DIVISION ~
RECT-70 RECT-71 DesdeC f-desde f-hasta 
&Scoped-Define DISPLAYED-OBJECTS F-DIVISION F-DESDIV DesdeC F-DESMAT ~
f-desde f-hasta txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-cancel.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 4" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/b-ok.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 6" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "IMG/excel.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 7" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-DESDIV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.72 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-DESMAT AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.43 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.57 BY 5.96.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.43 BY 1.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 7.35 COL 56 WIDGET-ID 26
     BUTTON-6 AT ROW 7.35 COL 41 WIDGET-ID 98
     BUTTON-7 AT ROW 7.35 COL 26 WIDGET-ID 118
     F-DIVISION AT ROW 1.81 COL 9 COLON-ALIGNED WIDGET-ID 114
     F-DESDIV AT ROW 1.81 COL 17.57 COLON-ALIGNED NO-LABEL WIDGET-ID 110
     DesdeC AT ROW 3.15 COL 9 COLON-ALIGNED WIDGET-ID 106
     F-DESMAT AT ROW 3.15 COL 17.29 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     f-desde AT ROW 4.5 COL 9 COLON-ALIGNED WIDGET-ID 108
     f-hasta AT ROW 4.5 COL 27 COLON-ALIGNED WIDGET-ID 116
     txt-msj AT ROW 6.12 COL 2 NO-LABEL WIDGET-ID 30
     RECT-70 AT ROW 1.23 COL 1.57 WIDGET-ID 20
     RECT-71 AT ROW 7.19 COL 1.72 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.72 BY 8.35
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Detalle de Venta x Articulo"
         HEIGHT             = 8.35
         WIDTH              = 72.72
         MAX-HEIGHT         = 8.35
         MAX-WIDTH          = 72.72
         VIRTUAL-HEIGHT     = 8.35
         VIRTUAL-WIDTH      = 72.72
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

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN F-DESDIV IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DESMAT IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Detalle de Venta x Articulo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Detalle de Venta x Articulo */
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
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
    ASSIGN f-Desde f-hasta f-division Desdec.

    IF f-desde = ? then do:
       MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.   
    END.

    IF f-hasta = ? then do:
       MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-hasta.
       RETURN NO-APPLY.   
    END.   

    IF f-desde > f-hasta then do:
       MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.
    END.

    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = DESDEC 
                        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY":U to DesdeC.
       RETURN NO-APPLY.

    END.                    
    s-subtitu = "Articulo : " + DESDEC +  " " + Almmmatg.DesMat .

    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    RUN Imprimir.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
    ASSIGN f-Desde f-hasta f-division Desdec.

    IF f-desde = ? then do:
       MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.   
    END.

    IF f-hasta = ? then do:
       MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-hasta.
       RETURN NO-APPLY.   
    END.   

    IF f-desde > f-hasta then do:
       MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.
    END.

    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
                        Almmmatg.CodMat = DESDEC 
                        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY":U to DesdeC.
       RETURN NO-APPLY.

    END.                    
    s-subtitu = "Articulo : " + DESDEC +  " " + Almmmatg.DesMat .

    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    RUN Excel.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:

  IF SELF:SCREEN-VALUE =  "" THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

  IF SELF:SCREEN-VALUE <> "" THEN DO:
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                   AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    F-DESMAT = Almmmatg.DesMat.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY F-DESMAT  @ F-DESMAT.
  END.

  ASSIGN DESDEC.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:

 DO WITH FRAME {&FRAME-NAME}:
    ASSIGN F-DIVISION.
    IF F-DIVISION <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
       END.
       F-DESDIV =  Gn-Divi.Desdiv .           
    END.
    DISPLAY F-DESDIV @ F-DESDIV .
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
  DISPLAY F-DIVISION F-DESDIV DesdeC F-DESMAT f-desde f-hasta txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-4 BUTTON-6 BUTTON-7 F-DIVISION RECT-70 RECT-71 DesdeC f-desde 
         f-hasta 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.

DEFINE VAR X-NROSAL AS CHAR .

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

cColumn = STRING(t-Column).
chWorkSheet:Range("A2"):Value = S-NOMCIA.
chWorkSheet:Range("A3"):Value = "( " + F-DIVISION + ")".
chWorkSheet:Range("B3"):Value = "DETALLE DE VENTA X ARTICULO" .
chWorkSheet:Range("I3"):Value = "Desde : " + STRING(F-DESDE,"99/99/9999").
chWorkSheet:Range("J3"):Value = "Desde : " + STRING(F-HASTA,"99/99/9999").
chWorkSheet:Range("A4"):Value = s-subtitu .

chWorkSheet:Range("A5"):Value = "CODIGO" .
chWorkSheet:Range("B5"):Value = "NUMERO" .
chWorkSheet:Range("C5"):Value = "FECHA ENTREGA" .
chWorkSheet:Range("D5"):Value = "COD REFE".
chWorkSheet:Range("E5"):Value = "NUM REFE" .
chWorkSheet:Range("F5"):Value = "OTROS" .
chWorkSheet:Range("G5"):Value = "UNIDAD" .
chWorkSheet:Range("H5"):Value = "PRECIO UNIT" .
chWorkSheet:Range("I5"):Value = "CANTIDAD" .
chWorkSheet:Range("J5"):Value = "IMPORTE" .
chWorkSheet:Range("K5"):Value = "MONEDA" .

FOR EACH Ccbddocu NO-LOCK WHERE Ccbddocu.CodCia = S-CODCIA 
    AND Ccbddocu.CodDiv = f-Division 
    AND Ccbddocu.CodMat = DesdeC   
    AND Ccbddocu.FchDoc >= F-desde 
    AND Ccbddocu.FchDoc <= F-hasta
    BY Ccbddocu.FchDoc:

    /*{&new-page}.*/ 
    FIND Ccbcdocu of ccbddocu NO-LOCK NO-ERROR.
    IF LOOKUP(Ccbddocu.Coddoc,"FAC,BOL,N/C,N/D") = 0 THEN NEXT.
    
    X-NROSAL = Ccbcdocu.CodAlm + "-" + STRING(Ccbcdocu.NroSal,"999999").

    IF CcbCdocu.Codref = "G/R" THEN X-NROSAL = "".
    
    IF Ccbcdocu.Codmon = 1 THEN X-MON = "S/.".
    ELSE X-MON = "US$.".

    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = Ccbddocu.Coddoc .
    cRange = "B" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = "'" + Ccbddocu.NroDoc .
    cRange = "C" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = Ccbddocu.FchDoc .
    cRange = "D" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = Ccbcdocu.CodRef .
    cRange = "E" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = "'" + CcbCdocu.NroRef .
    cRange = "F" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = X-NROSAL        .

    cRange = "G" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = Ccbddocu.Undvta .
    cRange = "H" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = Ccbddocu.PreUni .
    cRange = "I" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = Ccbddocu.CanDes .
    cRange = "J" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = Ccbddocu.ImpLin .
    cRange = "K" + cColumn.                                                                                    
    chWorkSheet:Range(cRange):Value = X-MON .

    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.
   
    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".        

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.        
        RUN Procesa.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
      ASSIGN F-DIVISION = S-CODDIV
          F-DESDE   = TODAY
          F-HASTA   = TODAY.  
  END.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa W-Win 
PROCEDURE Procesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR X-NROSAL AS CHAR .
     
 DEFINE FRAME f-cab
        Ccbddocu.Coddoc FORMAT "X(5)"
        Ccbddocu.NroDoc FORMAt "XXX-XXXXXX"
        Ccbddocu.FchDoc FORMAT "99/99/9999"
        Ccbcdocu.CodRef FORMAT "X(5)"
        CcbCdocu.NroRef FORMAT "XXX-XXXXXX"
        X-NROSAL        FORMAT "X(12)"
        Ccbddocu.Undvta FORMAT "X(5)"
        Ccbddocu.PreUni FORMAT "->,>>>,>>9.9999"
        Ccbddocu.CanDes FORMAT "->,>>>,>>9.99"
        Ccbddocu.ImpLin FORMAT "->,>>>,>>9.99"
        X-MON           FORMAT "X(4)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + F-DIVISION + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "DETALLE DE VENTA X ARTICULO"  AT 42 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 96 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 109 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        s-subtitu AT 1 FORMAT "X(60)" "Hora  : " AT 124 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------" SKIP
        "                   FECHA       COD   NUMERO                       PRECIO                                        " SKIP
        "  CODIGO  NUMERO   EMISION     REF   REF      OTROS    UNIDAD     UNITARIO     CANTIDAD     IMPORTE     MONEDA  " SKIP
        "----------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 

 FOR EACH Ccbddocu NO-LOCK WHERE
     Ccbddocu.CodCia = S-CODCIA AND
     /*Ccbddocu.CodDiv = S-CODDIV AND*/
     Ccbddocu.CodDiv = f-Division AND
     Ccbddocu.CodMat = DesdeC   AND
     Ccbddocu.FchDoc >= F-desde AND
     Ccbddocu.FchDoc <= F-hasta
     BY Ccbddocu.FchDoc:

     /*{&new-page}.*/ 
     FIND Ccbcdocu of ccbddocu NO-LOCK NO-ERROR.
     IF LOOKUP(Ccbddocu.Coddoc,"FAC,BOL,N/C,N/D") = 0 THEN NEXT.
 
     X-NROSAL = Ccbcdocu.CodAlm + "-" + STRING(Ccbcdocu.NroSal,"999999").
     
     IF CcbCdocu.Codref = "G/R" THEN X-NROSAL = "".
     
          
     IF Ccbcdocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
              
     DISPLAY STREAM REPORT 
        Ccbddocu.Coddoc 
        Ccbddocu.NroDoc 
        Ccbddocu.FchDoc 
        Ccbcdocu.CodRef 
        CcbCdocu.NroRef 
        X-NROSAL        
        Ccbddocu.Undvta 
        Ccbddocu.PreUni 
        Ccbddocu.CanDes 
        Ccbddocu.ImpLin 
        X-MON                   
        WITH FRAME F-Cab.

 END.

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
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
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

