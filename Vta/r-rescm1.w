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
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VARIABLE X-SINANT AS DECI INIT 0.
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR cl-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.

 DEFINE VAR ESTADO AS CHARACTER.

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
&Scoped-Define ENABLED-OBJECTS RECT-48 RECT-72 r-sortea R-Condic R-Estado ~
FILL-IN-Serie x-CodDiv f-tipo f-clien f-vende FILL-IN-CndVta f-hasta ~
f-desde txt-msj btn-excel BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS r-sortea R-Condic R-Estado FILL-IN-Serie ~
x-CodDiv f-tipo f-clien f-nomcli f-vende f-nomven FILL-IN-CndVta ~
FILL-IN-Descripcion f-hasta f-desde txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAdelando W-Win 
FUNCTION fAdelando RETURNS DECIMAL
  ( INPUT pCodCia AS INTEGER, INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-excel AUTO-GO 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 6" 
     SIZE 13 BY 1.5.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE f-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Tipo Cmpbte." 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Todos","Boleta","Factura","N/C","N/D","Letras","Ticket" 
     DROP-DOWN-LIST
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "x(5)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.57 BY .85 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.72 BY .85 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CndVta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cond. Venta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .85 NO-UNDO.

DEFINE VARIABLE FILL-IN-Descripcion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .85 NO-UNDO.

DEFINE VARIABLE FILL-IN-Serie AS CHARACTER FORMAT "X(4)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 86 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE R-Condic AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "C/Totales", 1,
"S/Totales", 2
     SIZE 14 BY 1.12
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE R-Estado AS CHARACTER INITIAL "C" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pendientes", "P",
"Anulados", "A",
"Cancelados", "C",
"Todos", ""
     SIZE 14 BY 2.27
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE r-sortea AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Documento", 1,
"Cliente", 2
     SIZE 14 BY 1.12
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 10.58.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 2.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     r-sortea AT ROW 1.46 COL 36.43 NO-LABEL WIDGET-ID 76
     R-Condic AT ROW 1.46 COL 52 NO-LABEL WIDGET-ID 66
     R-Estado AT ROW 1.46 COL 67.72 NO-LABEL WIDGET-ID 70
     FILL-IN-Serie AT ROW 2.42 COL 9.72 COLON-ALIGNED WIDGET-ID 64
     x-CodDiv AT ROW 3.5 COL 9.72 COLON-ALIGNED WIDGET-ID 88
     f-tipo AT ROW 3.5 COL 45.72 COLON-ALIGNED WIDGET-ID 56
     f-clien AT ROW 4.58 COL 9.72 COLON-ALIGNED WIDGET-ID 46
     f-nomcli AT ROW 4.58 COL 21.14 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     f-vende AT ROW 5.62 COL 9.72 COLON-ALIGNED WIDGET-ID 58
     f-nomven AT ROW 5.62 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     FILL-IN-CndVta AT ROW 6.73 COL 9.72 COLON-ALIGNED WIDGET-ID 60
     FILL-IN-Descripcion AT ROW 6.73 COL 19.72 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     f-hasta AT ROW 8.85 COL 27.43 COLON-ALIGNED WIDGET-ID 50
     f-desde AT ROW 8.88 COL 9.72 COLON-ALIGNED WIDGET-ID 48
     txt-msj AT ROW 10.69 COL 3 NO-LABEL WIDGET-ID 90
     btn-excel AT ROW 12.04 COL 46 WIDGET-ID 96
     BUTTON-3 AT ROW 12.04 COL 59 WIDGET-ID 92
     BUTTON-4 AT ROW 12.04 COL 74 WIDGET-ID 94
     "Ordenado Por :" VIEW-AS TEXT
          SIZE 12.57 BY .62 AT ROW 1.58 COL 23.29 WIDGET-ID 82
          BGCOLOR 8 FONT 6
     " Rango de Fechas" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 8.08 COL 11.72 WIDGET-ID 86
          BGCOLOR 8 FONT 6
     RECT-48 AT ROW 1.19 COL 2 WIDGET-ID 80
     RECT-72 AT ROW 11.77 COL 2 WIDGET-ID 98
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 13.35
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
         TITLE              = "Resumen de Comprobantes"
         HEIGHT             = 13.35
         WIDTH              = 90.14
         MAX-HEIGHT         = 13.35
         MAX-WIDTH          = 90.14
         VIRTUAL-HEIGHT     = 13.35
         VIRTUAL-WIDTH      = 90.14
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Descripcion IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       RECT-48:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen de Comprobantes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen de Comprobantes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel W-Win
ON CHOOSE OF btn-excel IN FRAME F-Main /* Button 6 */
DO:
    RUN Asigna-Variables.

    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    IF r-sortea = 1 THEN RUN Excel-Doc.
    ELSE IF r-sortea = 2 THEN RUN Excel.  
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    RUN Asigna-Variables.    

    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    RUN Imprimir.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
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


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien W-Win
ON LEAVE OF f-clien IN FRAME F-Main /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-vende
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-vende W-Win
ON LEAVE OF f-vende IN FRAME F-Main /* Vendedor */
DO:
  F-vende = "".
  IF F-vende:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = F-vende:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CndVta W-Win
ON LEAVE OF FILL-IN-CndVta IN FRAME F-Main /* Cond. Venta */
DO:
  FILL-IN-Descripcion:SCREEN-VALUE = ''.
  FIND gn-convt WHERE gn-convt.codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN FILL-IN-Descripcion:SCREEN-VALUE = gn-ConVt.Nombr.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN f-Desde f-hasta f-vende f-clien f-tipo r-sortea R-Estado R-Condic
        FILL-IN-CndVta FILL-IN-Descripcion FILL-IN-Serie
        x-CodDiv.
    
        IF f-desde = ? then do: MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
         APPLY "ENTRY":U to f-desde.
         RETURN NO-APPLY.   
        END.
        IF f-hasta = ? then do: MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
         APPLY "ENTRY":U to f-hasta.
         RETURN NO-APPLY.   
        END.   
        IF f-desde > f-hasta then do: MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
         APPLY "ENTRY":U to f-desde.
         RETURN NO-APPLY.
        END.
        
        CASE f-tipo:screen-value :
           WHEN "Todos" THEN DO:
                f-tipos  = "".
                T-cmpbte = "  RESUMEN DE COMPROBANTES   ". 
           END.     
           WHEN "Boleta"  THEN DO: 
                f-tipos = "BOL". 
                T-cmpbte = "     RESUMEN DE BOLETAS     ". 
           END.            
           WHEN "Factura" THEN DO: 
                f-tipos = "FAC".
                T-cmpbte = "     RESUMEN DE FACTURAS    ". 
           END.     
           WHEN "N/C"      THEN DO: 
                f-tipos = "N/C".
                T-cmpbte = "RESUMEN DE NOTAS DE CREDITO ". 
           END.     
           WHEN "N/D"      THEN DO: 
                f-tipos = "N/D".
                T-cmpbte = " RESUMEN DE NOTAS DE DEBITO ". 
           END.
           WHEN "Letras"      THEN DO: 
                f-tipos = "LET".
                T-cmpbte = "      RESUMEN DE LETRAS     ". 
           END.                               
           WHEN "Ticket"      THEN DO: 
                f-tipos = "TCK".
                T-cmpbte = "      RESUMEN DE TICKETS    ". 
           END.                               
        END.          
        IF f-vende <> "" THEN T-vende = "Vendedor :  " + f-vende + "  " + f-nomven.
        IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
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
  DISPLAY r-sortea R-Condic R-Estado FILL-IN-Serie x-CodDiv f-tipo f-clien 
          f-nomcli f-vende f-nomven FILL-IN-CndVta FILL-IN-Descripcion f-hasta 
          f-desde txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-48 RECT-72 r-sortea R-Condic R-Estado FILL-IN-Serie x-CodDiv 
         f-tipo f-clien f-vende FILL-IN-CndVta f-hasta f-desde txt-msj 
         btn-excel BUTTON-3 BUTTON-4 
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

    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    
    DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
       WHEN "A" THEN ESTADO = "ANULADOS".
       WHEN "P" THEN ESTADO = "PENDIENTES".
       WHEN "C" THEN ESTADO = "CANCELADOS".
       WHEN "" THEN ESTADO = "TODOS".
    END CASE.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    {vta/header-excel.i}

    FOR EACH CcbcDocu NO-LOCK WHERE
             CcbcDocu.CodCia = S-CODCIA AND
             CcbcDocu.CodDiv = x-CODDIV AND
             CcbcDocu.FchDoc >= F-desde AND
             CcbcDocu.FchDoc <= F-hasta AND 
             CcbcDocu.CodDoc BEGINS f-tipos AND
             CcbcDocu.CodDoc <> "G/R"   AND
             CcbcDocu.Codcli BEGINS f-clien AND
             CcbcDocu.CodVen BEGINS f-vende AND
             CcbcDocu.FlgEst BEGINS R-Estado AND
             CcbCDocu.FmaPgo BEGINS FILL-IN-CndVta
             AND CcbCDocu.NroDoc BEGINS FILL-IN-serie
        BREAK BY CcbCDocu.NomCli:

        IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
           ELSE X-MON = "US$.".

        IF CcbcDocu.TipVta = "1" THEN X-TIP = "CT".
           ELSE X-TIP = "CR".   

        CASE CcbcDocu.FlgEst :
             WHEN "P" THEN DO:
                X-EST = "PEN".
                IF CcbcDocu.Codmon = 1 THEN DO:
                   w-totbru [1] = w-totbru [1] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [1] = w-totdsc [1] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [1] = w-totexo [1] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [1] = w-totval [1] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [1] = w-totisc [1] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [1] = w-totigv [1] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [1] = w-totven [1] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   END.   
                ELSE DO:  
                   w-totbru [2] = w-totbru [2] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [2] = w-totdsc [2] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [2] = w-totexo [2] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [2] = w-totval [2] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [2] = w-totisc [2] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [2] = w-totigv [2] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [2] = w-totven [2] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             END.   
             WHEN "C" THEN DO:
                X-EST = "CAN".
                IF CcbcDocu.Codmon = 1 THEN DO:
                   w-totbru [3] = w-totbru [3] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [3] = w-totdsc [3] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [3] = w-totexo [3] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [3] = w-totval [3] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [3] = w-totisc [3] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [3] = w-totigv [3] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [3] = w-totven [3] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   END.   
                ELSE DO:  
                   w-totbru [4] = w-totbru [4] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [4] = w-totdsc [4] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [4] = w-totexo [4] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [4] = w-totval [4] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [4] = w-totisc [4] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [4] = w-totigv [4] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [4] = w-totven [4] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.                
             END.   
             WHEN "A" THEN DO:
                X-EST = "ANU".       
                IF CcbcDocu.Codmon = 1 THEN DO:
                   w-totbru [5] = w-totbru [5] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [5] = w-totdsc [5] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [5] = w-totexo [5] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [5] = w-totval [5] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [5] = w-totisc [5] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [5] = w-totigv [5] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [5] = w-totven [5] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   END.   
                ELSE DO:  
                   w-totbru [6] = w-totbru [6] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totdsc [6] = w-totdsc [6] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totexo [6] = w-totexo [6] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totval [6] = w-totval [6] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totisc [6] = w-totisc [6] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totigv [6] = w-totigv [6] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                   w-totven [6] = w-totven [6] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.                
             END.   
        END.            
    
        /* set the column names for the Worksheet */
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbcDocu.CodDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(CcbcDocu.NroDoc,1,3) + "-" + SUBSTRING(CcbcDocu.NroDoc,4).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbcDocu.FchDoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbcDocu.NomCli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + CcbcDocu.RucCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + CcbcDocu.Codven.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = X-MON.
        cRange = "H" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpBrt * -1 ).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpBrt.
        cRange = "I" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpDto * -1).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpDto.
        cRange = "J" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpVta * -1).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpVta.
        cRange = "K" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpIgv * -1).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpIgv.
        cRange = "L" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpTot * -1).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpTot.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = X-EST.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.UsuAnu.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP.
    END.

    /***************************/
    iCount = iCount + 4.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL GENERAL".

    /*Totales Canceladas*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL CANCELADAS".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL PENDIENTES".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL ANULADAS".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".


    /*Detalle Totales Bruto*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Bruto".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[6].

    /*Detalle Totales Descuento*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descuento".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[6].

    /*Detalle Totales Exonerado*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Exonerado".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[6].

    /*Detalle Totales Valor Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Valor Venta".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[6]. 

    /*Detalle Totales ISC*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.S.C".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[6].  

    /*Detalle Totales IGV*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[6]. 

    /*Detalle Totales Precio de Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[6]. 

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-doc W-Win 
PROCEDURE Excel-doc :
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

    DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
    
    DEFINE VAR M-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
    DEFINE VAR M-TOTISC AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
    DEFINE VAR M-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
     
    DEFINE VAR fImpLin  AS DEC INIT 0 NO-UNDO.    
    DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
    IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

    CASE R-Estado:
       WHEN "A" THEN ESTADO = "ANULADOS".
       WHEN "P" THEN ESTADO = "PENDIENTES".
       WHEN "C" THEN ESTADO = "CANCELADOS".
       WHEN "" THEN ESTADO = "TODOS".
    END CASE.       

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).
    
    FOR EACH CcbcDocu NO-LOCK WHERE
        CcbcDocu.CodCia = S-CODCIA AND
        CcbcDocu.CodDiv = x-CODDIV AND
        CcbcDocu.FchDoc >= F-desde AND
        CcbcDocu.FchDoc <= F-hasta AND 
        CcbcDocu.CodDoc BEGINS f-tipos AND
        CcbcDocu.CodDoc <> "G/R" AND
        CcbcDocu.CodVen BEGINS f-vende AND
        CcbcDocu.Codcli BEGINS f-clien AND
        CcbcDocu.FlgEst BEGINS R-Estado AND
        CcbCDocu.FmaPgo BEGINS FILL-IN-CndVta
        AND CcbCDocu.NroDoc BEGINS FILL-IN-serie
        USE-INDEX LLAVE10
        BREAK BY CcbcDocu.CodCia
        BY CcbcDocu.CodDiv BY CcbcDocu.CodDoc BY CcbCDocu.NroDoc:
    
        IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
           ELSE X-MON = "US$.".
        IF CcbcDocu.TipVta = "1" THEN X-TIP = "CT".
           ELSE X-TIP = "CR".   
    
        {vta/resdoc.i}.
    
        C = C + 1.
        fImpLin = 0.
        FOR EACH ccbddocu OF ccbcdocu NO-LOCK WHERE implin < 0:
           fImpLin = fImpLin + ccbddocu.implin.
        END.
        X-SINANT = ABSOLUTE (fImpLin).

        IF FIRST-OF( CcbcDocu.CodDoc) THEN DO:
            {vta/header-excel.i}.
        END.

        /* set the column names for the Worksheet */
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbcDocu.CodDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + SUBSTRING(CcbcDocu.NroDoc,1,3) + "-" + SUBSTRING(CcbcDocu.NroDoc,4).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbcDocu.FchDoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbcDocu.NomCli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + CcbcDocu.RucCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + CcbcDocu.Codven.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = X-MON.
        cRange = "H" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpBrt * -1 ).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpBrt.
        cRange = "I" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpDto * -1).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpDto.
        cRange = "J" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN   
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpVta * -1).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpVta.
        cRange = "K" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpIgv * -1).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpIgv.
        cRange = "L" + cColumn.
        IF CcbcDocu.CodDoc = "N/C" THEN
            chWorkSheet:Range(cRange):Value = (CcbcDocu.ImpTot * -1).
        ELSE chWorkSheet:Range(cRange):Value = CcbcDocu.ImpTot.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = X-SINANT.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = X-TIP + " " + X-EST.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.UsuAnu.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.NroCard. 

        IF R-Condic = 1 THEN DO:
            IF LAST-OF(CcbcDocu.CodDoc) THEN DO:
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = "-----------".

                /***************************/
                iCount = iCount + 4.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL : ".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = CcbcDocu.CodDoc.

                /*Totales Canceladas*/
                iCount = iCount + 4.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL CANCELADAS".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = "SOLES".
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = "DOLARES".
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL PENDIENTES".
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = "SOLES".
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = "DOLARES".
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = "TOTAL ANULADAS".
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = "SOLES".
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = "DOLARES".

                /*Detalle Totales Bruto*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Total Bruto".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totbru[6].
                
                /*Detalle Totales Descuento*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Descuento".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totdsc[6].

                /*Detalle Totales Exonerado*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Exonerado".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totexo[6].

                /*Detalle Totales Valor Venta*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Valor Venta".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totval[6].         

                /*Detalle Totales ISC*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "I.S.C".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totisc[6].  
                
                /*Detalle Totales IGV*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "I.G.V".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totigv[6]. 

                /*Detalle Totales Precio de Venta*/
                iCount = iCount + 1.
                cColumn = STRING(iCount). 
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "Precio de Venta".
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[3].
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[1].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[2].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[5].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = m-totven[6]. 

                M-TOTBRU = 0.
                M-TOTDSC = 0.
                M-TOTEXO = 0.
                M-TOTVAL = 0.  
                M-TOTISC = 0.
                M-TOTIGV = 0.
                M-TOTVEN = 0.

                iCount = iCount + 1.
            END.
        END.
    END.

    /***************************/
    iCount = iCount + 4.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL GENERAL".

    /*Totales Canceladas*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL CANCELADAS".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL PENDIENTES".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL ANULADAS".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "SOLES".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOLARES".


    /*Detalle Totales Bruto*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Bruto".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totbru[6].

    /*Detalle Totales Descuento*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descuento".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totdsc[6].

    /*Detalle Totales Exonerado*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Exonerado".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totexo[6].

    /*Detalle Totales Valor Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Valor Venta".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totval[6]. 

    /*Detalle Totales ISC*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.S.C".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totisc[6].  

    /*Detalle Totales IGV*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totigv[6]. 

    /*Detalle Totales Precio de Venta*/
    iCount = iCount + 1.
    cColumn = STRING(iCount). 
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "I.G.V".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[3].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[4].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[5].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-totven[6]. 

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
        IF r-sortea = 1 THEN RUN prndoc.
        IF r-sortea = 2 THEN RUN prncli.   
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
    FOR EACH Gn-Divi WHERE Gn-Divi.codcia = s-codcia NO-LOCK:
        x-CodDiv:ADD-LAST(Gn-Divi.coddiv).
    END.
    x-CodDiv:SCREEN-VALUE = s-CodDiv.
    ASSIGN 
        f-desde = TODAY
        f-hasta = TODAY.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prncli W-Win 
PROCEDURE prncli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.

DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

 CASE R-Estado:
    WHEN "A" THEN ESTADO = "ANULADOS".
    WHEN "P" THEN ESTADO = "PENDIENTES".
    WHEN "C" THEN ESTADO = "CANCELADOS".
    WHEN "" THEN ESTADO = "TODOS".
 END CASE.

 DEFINE FRAME f-cab
        CcbcDocu.CodDoc FORMAT "XXX"
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli FORMAT "X(23)"
        CcbcDocu.RucCli FORMAT "X(11)"
        CcbcDocu.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        CcbcDocu.ImpBrt FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpDto FORMAT "->,>>9.99"
        CcbcDocu.ImpVta FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpIgv FORMAT "->,>>9.99"
        CcbcDocu.ImpTot FORMAT "->>>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        CcbCDocu.UsuAnu FORMAT "X(8)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + CcbcDocu.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP
        Titulo SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                   T O T A L      TOTAL       VALOR             P R E C I O         USUARIO " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E               R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A   ESTADO ANULAC. " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.         
         
         
 FOR EACH CcbcDocu NO-LOCK WHERE
          CcbcDocu.CodCia = S-CODCIA AND
          /*CcbcDocu.CodDiv = S-CODDIV AND*/
          CcbcDocu.CodDiv = x-CODDIV AND
          CcbcDocu.FchDoc >= F-desde AND
          CcbcDocu.FchDoc <= F-hasta AND 
          CcbcDocu.CodDoc BEGINS f-tipos AND
          CcbcDocu.CodDoc <> "G/R"   AND
          CcbcDocu.Codcli BEGINS f-clien AND
          CcbcDocu.CodVen BEGINS f-vende AND
          CcbcDocu.FlgEst BEGINS R-Estado AND
          CcbCDocu.FmaPgo BEGINS FILL-IN-CndVta
/*ML01*/  AND CcbCDocu.NroDoc BEGINS FILL-IN-serie
     BY CcbCDocu.NomCli:     
     IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
     
     IF CcbcDocu.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".   

     CASE CcbcDocu.FlgEst :
          WHEN "P" THEN DO:
             X-EST = "PEN".
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [1] = w-totdsc [1] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [1] = w-totexo [1] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [1] = w-totval [1] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [1] = w-totisc [1] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [1] = w-totigv [1] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [1] = w-totven [1] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [2] = w-totdsc [2] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [2] = w-totexo [2] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [2] = w-totval [2] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [2] = w-totisc [2] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [2] = w-totigv [2] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [2] = w-totven [2] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
             END.   
          END.   
          WHEN "C" THEN DO:
             X-EST = "CAN".
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [3] = w-totdsc [3] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [3] = w-totexo [3] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [3] = w-totval [3] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [3] = w-totisc [3] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [3] = w-totigv [3] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [3] = w-totven [3] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [4] = w-totdsc [4] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [4] = w-totexo [4] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [4] = w-totval [4] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [4] = w-totisc [4] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [4] = w-totigv [4] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [4] = w-totven [4] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
             END.                
          END.   
          WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [5] = w-totdsc [5] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [5] = w-totexo [5] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [5] = w-totval [5] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [5] = w-totisc [5] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [5] = w-totigv [5] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [5] = w-totven [5] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [6] = w-totdsc [6] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [6] = w-totexo [6] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [6] = w-totval [6] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [6] = w-totisc [6] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [6] = w-totigv [6] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [6] = w-totven [6] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
             END.                
          END.   
     END.        

     DISPLAY STREAM REPORT 
        CcbcDocu.CodDoc 
        CcbcDocu.NroDoc 
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli 
        CcbcDocu.RucCli 
        CcbcDocu.Codven
        X-MON           
        (CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpVta
        (CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpDto
        (CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpBrt
        (CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpIgv
        (CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpTot
        X-EST 
        CcbCDocu.UsuAnu
        X-TIP WITH FRAME F-Cab.
        
 END.
 
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END.   
 
 PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->>,>>9.99"    w-totbru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 116 FORMAT "->>,>>9.99"    w-totbru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->>,>>9.99"   w-totdsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 116 FORMAT "->>,>>9.99"   w-totdsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "Exonerado       :" AT 1 w-totexo[3] AT 19  FORMAT "->,>>>,>>9.99" w-totexo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Exonerado       :"
                                            w-totexo[1] AT 69  FORMAT "->>,>>9.99"   w-totexo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Exonerado       :"
                                            w-totexo[5] AT 116 FORMAT "->>,>>9.99"   w-totexo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->>,>>9.99"   w-totval[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 116 FORMAT "->>,>>9.99"   w-totval[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "I.S.C.          :" AT 1 w-totisc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totisc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "I.S.C.          :"
                                            w-totisc[1] AT 69  FORMAT "->>,>>9.99"   w-totisc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "I.S.C.          :"
                                            w-totisc[5] AT 116 FORMAT "->>,>>9.99"   w-totisc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->>,>>9.99"   w-totigv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 116 FORMAT "->>,>>9.99"   w-totigv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->>,>>9.99"   w-totven[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 116 FORMAT "->>,>>9.99"   w-totven[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prndoc W-Win 
PROCEDURE prndoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR M-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
 DEFINE VAR M-TOTISC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
 
 DEFINE VAR fImpLin  AS DEC INIT 0 NO-UNDO.

DEF VAR Titulo AS CHAR INIT '' FORMAT 'x(50)'.
IF FILL-IN-Descripcion <> '' THEN Titulo = 'CONDICION DE VENTA: ' + FILL-IN-Descripcion.

 C = 1.    
 
 CASE R-Estado:
    WHEN "A" THEN ESTADO = "ANULADOS".
    WHEN "P" THEN ESTADO = "PENDIENTES".
    WHEN "C" THEN ESTADO = "CANCELADOS".
    WHEN "" THEN ESTADO = "TODOS".
 END CASE.
 
 DEFINE FRAME f-cab
        CcbcDocu.CodDoc FORMAT "XXX"
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc FORMAT '99/99/99'
        CcbcDocu.NomCli FORMAT "X(20)"
        CcbcDocu.RucCli FORMAT "X(11)"
        CcbcDocu.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(3)"
        CcbcDocu.ImpBrt FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpDto FORMAT "->>>>9.99"
        CcbcDocu.ImpVta FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpIgv FORMAT "->>>>9.99"
        CcbcDocu.ImpTot FORMAT "->>>>,>>9.99"
        X-SINANT        FORMAT "->>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        CcbCDocu.UsuAnu FORMAT "X(8)"
        CcbCDocu.NroCard FORMAT "X(6)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + CcbcDocu.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP 
        Titulo SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                             T O T A L      TOTAL       VALOR             P R E C I O PRECIO VENTA        USUARIO        " SKIP
        "DOC  DOCUMENTO  EMISION C L I E N T E            R.U.C.  VEND MON    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A  SIN ANTICIPO ESTADO ANULAC. TARJETA" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
     /*  XXX XXX-XXXXXX 99/99/99 12345678901234567890 12345678901 1234 123 ->>>>,>>9.99 ->>>>9.99 ->>>>,>>9.99 ->>>>9.99 ->>>>,>>9.99 ->>>,>>9.99 XX XXX XXXXXXXX 123456
     */
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  
 FOR EACH CcbcDocu NO-LOCK WHERE
          CcbcDocu.CodCia = S-CODCIA AND
          /*CcbcDocu.CodDiv = S-CODDIV AND*/
          CcbcDocu.CodDiv = x-CODDIV AND
          CcbcDocu.FchDoc >= F-desde AND
          CcbcDocu.FchDoc <= F-hasta AND 
          CcbcDocu.CodDoc BEGINS f-tipos AND
          CcbcDocu.CodDoc <> "G/R" AND
          CcbcDocu.CodVen BEGINS f-vende AND
          CcbcDocu.Codcli BEGINS f-clien AND
          CcbcDocu.FlgEst BEGINS R-Estado AND
          CcbCDocu.FmaPgo BEGINS FILL-IN-CndVta
/*ML01*/  AND CcbCDocu.NroDoc BEGINS FILL-IN-serie
          USE-INDEX LLAVE10
     BREAK BY CcbcDocu.CodCia
           BY CcbcDocu.CodDiv
           BY CcbcDocu.CodDoc
     BY CcbCDocu.NroDoc:
     /*{&NEW-PAGE}.*/

     IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
     IF CcbcDocu.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".   

     {vta/resdoc.i}.

     C = C + 1.
     fImpLin = 0.
     FOR EACH ccbddocu OF ccbcdocu NO-LOCK WHERE implin < 0:
        fImpLin = fImpLin + ccbddocu.implin.
     END.
     X-SINANT = ABSOLUTE (fImpLin).
     DISPLAY STREAM REPORT 
        CcbcDocu.CodDoc 
        CcbcDocu.NroDoc 
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli 
        CcbcDocu.RucCli 
        CcbcDocu.Codven
        X-MON           
        (CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpVta
        (CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpDto
        (CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpBrt
        (CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpIgv
        (CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpTot
        X-SINANT 
        X-EST 
        X-TIP
        CcbCDocu.UsuAnu
        CcbCDocu.NroCard
         WITH FRAME F-Cab.

     IF R-Condic = 1 THEN DO:
        IF LAST-OF(CcbcDocu.CodDoc) THEN DO:
           UNDERLINE STREAM REPORT 
                     CcbcDocu.ImpVta
                     CcbcDocu.ImpDto
                     CcbcDocu.ImpBrt
                     CcbcDocu.ImpIgv
                     CcbcDocu.ImpTot
               WITH FRAME F-Cab.
               
            /***************************/
             DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
                PUT STREAM REPORT "" skip. 
             END.   
             
             PUT STREAM REPORT "TOTAL : " CcbcDocu.CodDoc SKIP.
             PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
             PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES    " SPACE(2) "TOTAL PENDIENTES      SOLES       DOLARES     " SPACE(2) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
             PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
             PUT STREAM REPORT "Total Bruto     :" AT 1 m-totbru[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totbru[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Total Bruto     :"      m-totbru[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totbru[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Total Bruto     :"      m-totbru[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totbru[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "Descuento       :" AT 1 m-totdsc[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totdsc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Descuento       :"      m-totdsc[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totdsc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Descuento       :"      m-totdsc[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totdsc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "Exonerado       :" AT 1 m-totexo[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totexo[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Exonerado       :"      m-totexo[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totexo[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Exonerado       :"      m-totexo[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totexo[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "Valor de Venta  :" AT 1 m-totval[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totval[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Valor de Venta  :"      m-totval[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totval[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Valor de Venta  :"      m-totval[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totval[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "I.S.C.          :" AT 1 m-totisc[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totisc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "I.S.C.          :"      m-totisc[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totisc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "I.S.C.          :"      m-totisc[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totisc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "I.G.V.          :" AT 1 m-totigv[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totigv[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "I.G.V.          :"      m-totigv[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totigv[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "I.G.V.          :"      m-totigv[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totigv[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "Precio de Venta :" AT 1 m-totven[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totven[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Precio de Venta :"      m-totven[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totven[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Precio de Venta :"      m-totven[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totven[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
            /*****************************/
            
            M-TOTBRU = 0.
            M-TOTDSC = 0.
            M-TOTEXO = 0.
            M-TOTVAL = 0.  
            M-TOTISC = 0.
            M-TOTIGV = 0.
            M-TOTVEN = 0.

         END.
     END.
 END.
 
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END.   
 
 PUT STREAM REPORT "" SKIP. 
 PUT STREAM REPORT "TOTAL GENERAL " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES    " SPACE(2) "TOTAL PENDIENTES      SOLES       DOLARES     " SPACE(2) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totbru[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Total Bruto     :"      w-totbru[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totbru[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Total Bruto     :"      w-totbru[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totbru[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totdsc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Descuento       :"      w-totdsc[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totdsc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Descuento       :"      w-totdsc[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totdsc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Exonerado       :" AT 1 w-totexo[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totexo[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Exonerado       :"      w-totexo[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totexo[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Exonerado       :"      w-totexo[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totexo[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totval[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Valor de Venta  :"      w-totval[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totval[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Valor de Venta  :"      w-totval[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totval[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.S.C.          :" AT 1 w-totisc[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totisc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.S.C.          :"      w-totisc[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totisc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.S.C.          :"      w-totisc[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totisc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totigv[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.G.V.          :"      w-totigv[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totigv[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.G.V.          :"      w-totigv[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totigv[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totven[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Precio de Venta :"      w-totven[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totven[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Precio de Venta :"      w-totven[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totven[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAdelando W-Win 
FUNCTION fAdelando RETURNS DECIMAL
  ( INPUT pCodCia AS INTEGER, INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR fImpLin AS DEC NO-UNDO.

  FOR EACH ccbddocu NO-LOCK WHERE ccbddocu.codcia = pcodcia
      AND ccbddocu.coddoc = pcoddoc
      AND ccbddocu.nrodoc = pnrodoc
      AND implin < 0:
      fImpLin = fImpLin + ccbddocu.implin.
  END.
  RETURN ABSOLUTE(fImpLin).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

