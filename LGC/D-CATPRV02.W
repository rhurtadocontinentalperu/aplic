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

DEFINE SHARED VAR s-codcia  AS INT.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE t-titulo AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS f-giro r-sortea BUTTON-4 BUTTON-6 BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS f-giro d-giro r-sortea f-msje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/api-ve.ico":U
     LABEL "Button 4" 
     SIZE 9 BY 1.62.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 5" 
     SIZE 9 BY 1.62.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 6" 
     SIZE 9 BY 1.62.

DEFINE VARIABLE d-giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49.14 BY .88 NO-UNDO.

DEFINE VARIABLE f-giro AS CHARACTER FORMAT "XXXX":U 
     LABEL "Giro del Negocio" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE f-msje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 74.29 BY .88
     BGCOLOR 8 FGCOLOR 7 FONT 0 NO-UNDO.

DEFINE VARIABLE r-sortea AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "General", 1,
"Nacional", 2,
"Extranjero", 3
     SIZE 36.72 BY .77
     FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     f-giro AT ROW 2.08 COL 18.14 COLON-ALIGNED WIDGET-ID 2
     d-giro AT ROW 2.08 COL 25.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     r-sortea AT ROW 3.23 COL 20 NO-LABEL WIDGET-ID 6
     f-msje AT ROW 4.73 COL 2.72 NO-LABEL WIDGET-ID 16
     BUTTON-4 AT ROW 6.04 COL 47.57 WIDGET-ID 10
     BUTTON-6 AT ROW 6.04 COL 57.29 WIDGET-ID 14
     BUTTON-5 AT ROW 6.04 COL 67.29 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 76.86 BY 7.38 WIDGET-ID 100.


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
         TITLE              = "Catalogo de Proveedores"
         HEIGHT             = 7.38
         WIDTH              = 76.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 83.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 83.57
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
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN d-giro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-msje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Catalogo de Proveedores */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Catalogo de Proveedores */
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
  
    ASSIGN r-sortea f-giro d-giro.
 
    RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
  
    ASSIGN r-sortea f-giro d-giro.
    
    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-sortea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-sortea W-Win
ON VALUE-CHANGED OF r-sortea IN FRAME F-Main
DO: 
    ASSIGN R-SORTEA.
    CASE R-SORTEA:
        WHEN 3 THEN
           ASSIGN F-GIRO:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  
        OTHERWISE
           ASSIGN F-GIRO:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatPex W-Win 
PROCEDURE CatPex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab 
        gn-prov.ruc        AT 1   FORMAT "X(8)"
        gn-prov.nompro     AT 10  FORMAT "X(40)"
        gn-prov.Dirpro     AT 52  FORMAT "X(30)"
        D-Distrito         AT 84  FORMAT "X(15)"
        gn-prov.Telfnos[1] AT 100 FORMAT "X(13)"
        gn-prov.faxpro     AT 114 FORMAT "X(10)"
        gn-prov.E-mail     AT 125 FORMAT "X(20)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.             PROVEEDORES                   DIRECCION                       DISTRITO        TELEFONO      F A X       E - M A I L      " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 FOR EACH gn-prov NO-LOCK WHERE gn-prov.codcia = PV-CODCIA 
     AND gn-prov.Girpro BEGINS f-giro AND integral.gn-prov.TpoPro = "E"
        BY gn-prov.nompro:

     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-prov.CodDept 
         AND Tabdistr.Codprovi = gn-prov.codprov
         AND Tabdistr.Coddistr = gn-prov.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN D-Distrito = Tabdistr.Nomdistr.
     ELSE D-Distrito = "".     
                  
     DISPLAY STREAM REPORT 
         gn-prov.ruc
         gn-prov.nompro
         gn-prov.Dirpro
         gn-prov.Telfnos[1]
         gn-prov.faxpro
         gn-prov.E-mail
         D-Distrito
         WITH FRAME F-Cab.
        
 END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatPna W-Win 
PROCEDURE CatPna :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab 
        gn-prov.ruc        AT 1   FORMAT "X(8)"
        gn-prov.nompro     AT 10  FORMAT "X(40)"
        gn-prov.Dirpro     AT 52  FORMAT "X(30)"
        D-Distrito         AT 84  FORMAT "X(15)"
        gn-prov.Telfnos[1] AT 100 FORMAT "X(13)"
        gn-prov.faxpro     AT 114 FORMAT "X(10)"
        gn-prov.E-mail     AT 125 FORMAT "X(20)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.             PROVEEDORES                   DIRECCION                       DISTRITO        TELEFONO      F A X       E - M A I L      " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 FOR EACH gn-prov NO-LOCK WHERE gn-prov.codcia = PV-CODCIA 
     AND gn-prov.Girpro BEGINS f-giro AND integral.gn-prov.TpoPro = "N"
        BY gn-prov.nompro:

     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-prov.CodDept 
         AND Tabdistr.Codprovi = gn-prov.codprov
         AND Tabdistr.Coddistr = gn-prov.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN D-Distrito = Tabdistr.Nomdistr.
     ELSE D-Distrito = "".     

     DISPLAY STREAM REPORT 
         gn-prov.ruc
         gn-prov.nompro
         gn-prov.Dirpro
         gn-prov.Telfnos[1]
         gn-prov.faxpro
         gn-prov.E-mail
         D-Distrito
         WITH FRAME F-Cab.
        
 END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CatPrv W-Win 
PROCEDURE CatPrv :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR D-Distrito AS CHAR.
 DEFINE FRAME f-cab 
        gn-prov.ruc        AT 1   FORMAT "X(8)"
        gn-prov.nompro     AT 10  FORMAT "X(40)"
        gn-prov.Dirpro     AT 52  FORMAT "X(30)"
        D-Distrito         AT 84  FORMAT "X(15)"
        gn-prov.Telfnos[1] AT 100 FORMAT "X(13)"
        gn-prov.faxpro     AT 114 FORMAT "X(10)"
        gn-prov.E-mail     AT 125 FORMAT "X(20)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 107 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + T-TITULO + {&PRN6B} + {&PRN3} AT 54 FORMAT "X(45)" 
        {&PRN3} + "Fecha : " AT 121 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  R.U.C.             PROVEEDORES                   DIRECCION                       DISTRITO        TELEFONO      F A X       E - M A I L      " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 FOR EACH gn-prov NO-LOCK WHERE gn-prov.codcia = PV-CODCIA 
     AND gn-prov.Girpro BEGINS f-giro
        BY gn-prov.nompro:

     FIND Tabdistr WHERE Tabdistr.CodDepto = gn-prov.CodDept 
         AND Tabdistr.Codprovi = gn-prov.codprov
         AND Tabdistr.Coddistr = gn-prov.coddist NO-LOCK NO-ERROR.
     IF AVAILABLE Tabdistr THEN D-Distrito = Tabdistr.Nomdistr.
     ELSE D-Distrito = "".     

     DISPLAY STREAM REPORT 
         gn-prov.ruc
         gn-prov.nompro
         gn-prov.Dirpro
         gn-prov.Telfnos[1]
         gn-prov.faxpro
         gn-prov.E-mail
         D-Distrito
         WITH FRAME F-Cab.
        
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
  DISPLAY f-giro d-giro r-sortea f-msje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE f-giro r-sortea BUTTON-4 BUTTON-6 BUTTON-5 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE d-distrito AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Range("B2"):Value = "CATALOGO DE PROVEEDORES".

chWorkSheet:Range("A4"):Value = "RUC".
chWorkSheet:Range("B4"):Value = "PROVEEDORES".
chWorkSheet:Range("C4"):Value = "DIRECCION".
chWorkSheet:Range("D4"):Value = "DISTRITO".
chWorkSheet:Range("E4"):Value = "TELEFONO".
chWorkSheet:Range("F4"):Value = "FAX".
chWorkSheet:Range("G4"):Value = "EMAIL".

t-Column = 4.

FOR EACH gn-prov NO-LOCK WHERE gn-prov.codcia = PV-CODCIA 
    AND gn-prov.Girpro BEGINS f-giro 
        BY gn-prov.nompro:

    CASE R-SORTEA :
        WHEN 2 THEN IF gn-prov.TpoPro <> "N" THEN NEXT.
        WHEN 3 THEN IF gn-prov.TpoPro <> "E" THEN NEXT.
    END CASE. 

    FIND Tabdistr WHERE Tabdistr.CodDepto = gn-prov.CodDept 
        AND Tabdistr.Codprovi = gn-prov.codprov
        AND Tabdistr.Coddistr = gn-prov.coddist NO-LOCK NO-ERROR.
    IF AVAILABLE Tabdistr THEN D-Distrito = Tabdistr.Nomdistr.
    ELSE D-Distrito = "".     

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + gn-prov.ruc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-prov.nompro.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-prov.Dirpro.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = D-Distrito.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-prov.Telfnos[1].
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-prov.faxpro.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-prov.E-mail.
        
    DISPLAY "PROCESANDO INFORMACION " @ f-msje WITH FRAME {&FRAME-NAME}.

 END.
 DISPLAY "" @ f-msje WITH FRAME {&FRAME-NAME}.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        DISPLAY "PROCESANDO INFORMACION " @ f-msje WITH FRAME {&FRAME-NAME}.
        CASE R-SORTEA :
            WHEN 1 THEN DO:    
                T-TITULO = " CATALOGO GENERAL DE PROVEEDORES ".
                RUN CatPrv.
            END.
            WHEN 2 THEN DO:    
                T-TITULO = "CATALOGO - PROVEEDORES NACIONALES ".
                RUN CatPna.
            END.       
            WHEN 3 THEN DO:    
                T-TITULO = "CATALOGO - PROVEEDORES EXTRANJEROS".
                RUN CatPex.                 
            END.  
        END CASE. 
        DISPLAY "" @ f-msje WITH FRAME {&FRAME-NAME}.

        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
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

