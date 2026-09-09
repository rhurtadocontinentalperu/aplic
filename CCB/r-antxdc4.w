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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

DEF VAR s-task-no AS INT  NO-UNDO.
DEF VAR cDivi     AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-2 x-Desde x-Hasta BUTTON-6 ~
x-FchDoc rs-opcion BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS F-Division x-Desde x-Hasta x-FchDoc ~
rs-opcion x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 2" 
     SIZE 12 BY 1.5.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 3" 
     SIZE 12 BY 1.5.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 6" 
     SIZE 12 BY 1.5.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Corte" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 80 BY .81 NO-UNDO.

DEFINE VARIABLE rs-opcion AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Division", 1,
"Resumnido", 2
     SIZE 21 BY 1.12 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Division AT ROW 1.81 COL 14 COLON-ALIGNED WIDGET-ID 26
     BUTTON-1 AT ROW 1.81 COL 60 WIDGET-ID 18
     BUTTON-2 AT ROW 2.08 COL 73 WIDGET-ID 52
     x-Desde AT ROW 2.85 COL 14 COLON-ALIGNED WIDGET-ID 58
     x-Hasta AT ROW 2.85 COL 36 COLON-ALIGNED WIDGET-ID 60
     BUTTON-6 AT ROW 3.69 COL 73 WIDGET-ID 62
     x-FchDoc AT ROW 3.92 COL 14 COLON-ALIGNED WIDGET-ID 42
     rs-opcion AT ROW 5.04 COL 16 NO-LABEL WIDGET-ID 64
     BUTTON-3 AT ROW 5.31 COL 73 WIDGET-ID 54
     x-mensaje AT ROW 6.92 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.86 BY 8.42
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
         TITLE              = "Reporte Documentos por Cobrar"
         HEIGHT             = 8.42
         WIDTH              = 87.86
         MAX-HEIGHT         = 19.69
         MAX-WIDTH          = 97.29
         VIRTUAL-HEIGHT     = 19.69
         VIRTUAL-WIDTH      = 97.29
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
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Documentos por Cobrar */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Documentos por Cobrar */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    ASSIGN F-Division x-Desde x-FchDoc x-Hasta.

    RUN IMPRIMIR.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
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
    ASSIGN F-Division x-Desde x-FchDoc x-Hasta rs-opcion.
    IF rs-opcion = 1 THEN RUN Excel.
    ELSE RUN Excel-R.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* Division */
DO:
/*    Find gn-divi where gn-divi.codcia = s-codcia and gn-divi.coddiv = F-Division:screen-value no-lock no-error.
 *     If available gn-divi then
 *         F-DesDiv:screen-value = gn-divi.desdiv.
 *     else
 *         F-DesDiv:screen-value = "".*/
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

DEFINE VAR XDOCINI AS CHAR.
DEFINE VAR XDOCFIN AS CHAR.

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

DEFINE VARIABLE cNomcli AS CHARACTER NO-UNDO.
DEFINE VARIABLE dImpLC AS DECIMAL NO-UNDO.
DEFINE VARIABLE iAge_period AS INTEGER NO-UNDO.
DEFINE VARIABLE iAge_days AS INTEGER EXTENT 5 INITIAL [15, 30, 45, 60, 90].
DEFINE VARIABLE iInd AS INTEGER NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

DEFINE VARIABLE FSdoAct LIKE integral.CcbCDocu.sdoact NO-UNDO.
DEFINE VARIABLE FImpTot LIKE integral.CcbCDocu.imptot NO-UNDO.
DEFINE VARIABLE cFlgEst AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDivi AS CHARACTER   NO-UNDO.

cDivi = f-Division:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

MESSAGE cDivi.

FOR EACH integral.CcbCDocu NO-LOCK WHERE
    integral.CcbCDocu.codcia = s-codcia AND
    LOOKUP(integral.CcbCDocu.coddiv,cDivi) > 0 AND
    integral.CcbCDocu.fchdoc >= x-Desde AND
    integral.CcbCDocu.fchdoc <= x-Hasta AND
    LOOKUP(integral.CcbCDocu.flgest,"P,J") > 0 AND
    LOOKUP(integral.CcbCDocu.coddoc,"FAC,BOL,N/C,N/D,LET,A/R,BD") > 0 /*AND*/
    /*integral.CcbCDocu.nrodoc >= ""*/
    BREAK BY integral.CcbCDocu.codcia
    BY integral.CcbCDocu.codcli
    BY integral.CcbCDocu.flgest
    BY integral.CcbCDocu.coddoc
    BY integral.CcbCDocu.nrodoc:

    IF FIRST-OF(integral.CcbCDocu.codcli) THEN DO:
        cNomcli = "".
        dImpLC = 0.
        lEnCampan = FALSE.
        FIND integral.gn-clie WHERE
            integral.gn-clie.CodCia = cl-codcia AND
            integral.gn-clie.CodCli = integral.CcbCDocu.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE integral.gn-clie THEN DO:
            /* Línea Crédito Campaña */
            FOR EACH integral.gn-clieL WHERE
                integral.gn-clieL.CodCia = integral.gn-clie.codcia AND
                integral.gn-clieL.CodCli = integral.gn-clie.codcli AND
                integral.gn-clieL.FchIni >= TODAY AND
                integral.gn-clieL.FchFin <= TODAY NO-LOCK:
                dImpLC = dImpLC + integral.gn-clieL.ImpLC.
                lEnCampan = TRUE.
            END.
            /* Línea Crédito Normal */
            IF NOT lEnCampan THEN dImpLC = integral.gn-clie.ImpLC.
            cNomcli = integral.gn-clie.nomcli.
        END.
    END.

    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST integral.w-report WHERE
            integral.w-report.task-no = s-task-no AND
            integral.w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
    END.

    /*Mensaje*/
    DISPLAY  "   Cargando información para" + integral.CcbCDocu.codcli  @ x-mensaje
        WITH FRAME {&FRAME-NAME}.

    FSdoAct = integral.CcbCDocu.sdoact.
    FImpTot = integral.CcbCDocu.imptot.

    IF lookup(integral.CcbCDocu.coddoc, "N/C,A/R,BD") > 0 THEN DO:
        FSdoAct = FSdoAct * -1.
        FImpTot = FImpTot * -1.
    END.

    CREATE integral.w-report.
    ASSIGN
        integral.w-report.Task-No = s-task-no                         /* ID Tarea */
        integral.w-report.Llave-C = s-user-id                         /* ID Usuario */
        integral.w-report.Campo-C[1] = integral.CcbCDocu.codcli       /* Cliente */
        integral.w-report.Campo-C[2] = cNomcli                        /* Nombre  */
        integral.w-report.Campo-C[8] = integral.CcbCDocu.coddiv       /* Código Documento */
        integral.w-report.Campo-C[3] = integral.CcbCDocu.coddoc       /* Código Documento */
        integral.w-report.Campo-C[4] = integral.CcbCDocu.nrodoc       /* Número Documento */        
        integral.w-report.Campo-I[1] = integral.CcbCDocu.codmon       /* Moneda */        
        integral.w-report.Campo-D[1] = integral.CcbCDocu.fchdoc       /* Fecha Emisión */
        integral.w-report.Campo-D[2] = integral.CcbCDocu.fchvto       /* Fecha Vencimiento */
        integral.w-report.Campo-D[3] = integral.CcbCDocu.fchcbd.      /* Fecha Recepción */
    /*Incluir lïnea de crédito*/
    ASSIGN integral.w-report.Campo-F[1] = dImpLC.        /* Línea de Crédito */
    IF integral.CcbCDocu.codmon = 2 THEN DO:
        integral.w-report.Campo-F[2] = FImpTot.              /* Importe Dólares */
        integral.w-report.Campo-F[3] = FSdoAct.              /* Saldo Dólares */
    END.
    ELSE DO:
        integral.w-report.Campo-F[4] = FImpTot.              /* Importe Soles */
        integral.w-report.Campo-F[5] = FSdoAct.              /* Saldo Soles */
    END.

    IF integral.CcbCDocu.coddoc = "LET" THEN DO:
        CASE integral.CcbCDocu.flgsit:
            WHEN "C" THEN integral.w-report.Campo-C[5] = "COBRANZA LIBRE".
            WHEN "D" THEN integral.w-report.Campo-C[5] = "DESCUENTO".
            WHEN "G" THEN integral.w-report.Campo-C[5] = "GARANTIA".
            WHEN "P" THEN integral.w-report.Campo-C[5] = "PROTESTADA".
        END CASE.
        /* Documentos en Banco */
        IF integral.CcbCDocu.flgubi = "B" THEN DO:
            integral.w-report.Campo-C[6] = integral.CcbCDocu.nrosal.      /* Letra en Banco */
            IF integral.CcbCDocu.CodCta <> "" THEN DO:
                FIND FIRST integral.cb-ctas WHERE
                    integral.cb-ctas.CodCia = cb-codcia AND
                    integral.cb-ctas.Codcta = integral.CcbCDocu.CodCta
                    NO-LOCK NO-ERROR.
                IF AVAILABLE integral.cb-ctas THEN DO:
                    FIND integral.cb-tabl WHERE
                        integral.cb-tabl.Tabla  = "04" AND
                        integral.cb-tabl.Codigo = integral.cb-ctas.codbco
                    NO-LOCK NO-ERROR.
                    IF AVAILABLE integral.cb-tabl THEN
                    integral.w-report.Campo-C[7] = integral.cb-tabl.Nombre.   /* Banco */
                END.
            END.
        END.
    END.

    /* Documentos Vencidos */
    IF integral.CcbCDocu.fchvto < TODAY THEN DO:
        IF integral.CcbCDocu.coddoc = "LET" THEN DO:
            IF integral.CcbCDocu.flgubi = "C" THEN
                integral.w-report.Campo-F[6] = FSdoAct.      /* Vencido Cartera */
            ELSE
                integral.w-report.Campo-F[7] = FSdoAct.      /* Vencido Banco */
        END.
        ELSE integral.w-report.Campo-F[6] = FSdoAct.         /* Vencido Cartera */
    END.
    /* Documentos por Vencer */
    ELSE DO:
        IF integral.CcbCDocu.coddoc = "LET" THEN DO:
            IF integral.CcbCDocu.flgubi = "C" THEN
                integral.w-report.Campo-F[8] = FSdoAct.      /* Por Vencer Cartera */
            ELSE
                integral.w-report.Campo-F[9] = FSdoAct.      /* Por Vencer Banco */
        END.
        ELSE integral.w-report.Campo-F[8] = FSdoAct.         /* Por Vencer Cartera */
    END.

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
  DISPLAY F-Division x-Desde x-Hasta x-FchDoc rs-opcion x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 BUTTON-2 x-Desde x-Hasta BUTTON-6 x-FchDoc rs-opcion BUTTON-3 
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

    DEFINE VARIABLE dSdoAct-1 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE dSdoAct-2 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE cNomCli   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE x-factor  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dTotal    AS DECIMAL    NO-UNDO EXTENT 4.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN Carga-Temporal.

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "RESUMEN DOCUMENTOS POR COBRAR AL " + STRING(x-FchDoc ).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESDE: " + STRING(x-Desde).
    cColumn = STRING(iCount).
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "HASTA: " + STRING(x-Hasta).

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "DIV".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOS IMPORTE S/.".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOC IMPORTE $".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE S/.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE $".
    iCount = iCount + 1.

    FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no
        AND w-report.Llave-C = s-user-id 
        BREAK BY w-report.Campo-C[8]
            BY w-report.Campo-C[1] :

        IF lookup(w-report.Campo-C[3],"N/C,A/R,BD") > 0  THEN x-Factor = -1.
        ELSE x-Factor = 1.

        IF FIRST-OF(w-report.Campo-C[1]) THEN DO:
            dSdoAct-1 = 0.
            dSdoAct-2 = 0.
        END.

        IF w-report.Campo-D[2] < TODAY THEN DO:
            CASE w-report.Campo-I[1]:
                WHEN 1 THEN dSdoAct-1[1] = (w-report.Campo-F[3] * x-factor) + dSdoAct-1[1].
                WHEN 2 THEN dSdoAct-1[2] = (w-report.Campo-F[5] * x-factor) + dSdoAct-1[2].
            END CASE.
        END.
        ELSE DO:
            CASE w-report.Campo-I[1]:
                WHEN 1 THEN dSdoAct-2[1] = (w-report.Campo-F[3] * x-factor) + dSdoAct-2[1].
                WHEN 2 THEN dSdoAct-2[2] = (w-report.Campo-F[5] * x-factor) + dSdoAct-2[2].
            END CASE.
        END.

        IF LAST-OF(w-report.Campo-C[1]) THEN DO:
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + integral.w-report.Campo-C[8].
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + integral.w-report.Campo-C[1].
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = integral.w-report.Campo-C[2].
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-1[1].
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-1[2].
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-2[1].
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-2[2].
            iCount = iCount + 1.
        END.
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.
    
    FOR EACH integral.w-report WHERE
        integral.w-report.task-no = s-task-no AND
        integral.w-report.Llave-C = s-user-id:
        DELETE integral.w-report.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-R W-Win 
PROCEDURE Excel-R :
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

    DEFINE VARIABLE dSdoAct-1 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE dSdoAct-2 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE cNomCli   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE x-factor  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dTotal    AS DECIMAL    NO-UNDO EXTENT 4.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN Carga-Temporal.

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "RESUMEN DOCUMENTOS POR COBRAR AL " + STRING(x-FchDoc ).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESDE: " + STRING(x-Desde).
    cColumn = STRING(iCount).
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "HASTA: " + STRING(x-Hasta).

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    /*
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "DIV".
    */
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOS IMPORTE S/.".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOC IMPORTE $".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE S/.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE $".
    iCount = iCount + 1.

    FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no
        AND w-report.Llave-C = s-user-id 
        BREAK BY w-report.task-no
            BY w-report.Llave-C
            BY w-report.Campo-C[1] :

        IF w-report.Campo-D[2] < TODAY THEN DO:
            CASE w-report.Campo-I[1]:
                WHEN 1 THEN dSdoAct-1[1] = (w-report.Campo-F[3] * x-factor) + dSdoAct-1[1].
                WHEN 2 THEN dSdoAct-1[2] = (w-report.Campo-F[5] * x-factor) + dSdoAct-1[2].
            END CASE.
        END.
        ELSE DO:
            CASE w-report.Campo-I[1]:
                WHEN 1 THEN dSdoAct-2[1] = (w-report.Campo-F[3] * x-factor) + dSdoAct-2[1].
                WHEN 2 THEN dSdoAct-2[2] = (w-report.Campo-F[5] * x-factor) + dSdoAct-2[2].
            END CASE.
        END.

        IF LAST-OF(w-report.Campo-C[1]) THEN DO:
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + integral.w-report.Campo-C[1].
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = integral.w-report.Campo-C[2].
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-1[1].
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-1[2].
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-2[1].
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-2[2].
            iCount = iCount + 1.
        END.
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.
    
    FOR EACH integral.w-report WHERE
        integral.w-report.task-no = s-task-no AND
        integral.w-report.Llave-C = s-user-id:
        DELETE integral.w-report.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    DEFINE VARIABLE dSdoAct-1 AS DECIMAL NO-UNDO EXTENT 2.
    DEFINE VARIABLE dSdoAct-2 AS DECIMAL NO-UNDO EXTENT 2.
    DEFINE VARIABLE cNomCli   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-factor  AS DECIMAL   NO-UNDO.

    DEFINE FRAME F-Titulo
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN4} + {&PRN6B} FORMAT "X(45)" 
        {&PRN6A} + "PAG.  : " AT 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "RESUMEN DOCUMENTOS POR COBRAR AL " AT 50 x-FchDoc  AT 85 
        "FECHA : " AT 115 TODAY SKIP     
        "DESDE : " x-Desde 
        "HASTA : " AT 115 x-Hasta SKIP     
        "------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                              Documentos  Vencidos            Documentos por Vencer                                    " SKIP
        "Div   Cliente      Razon Social                                           Importe S/.      Importe $.      Importe S/.      Importe $.          " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16
         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123 XXX-XXXXXX 99/99/9999 99/99/9999 (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) 
*/

        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 250 STREAM-IO DOWN.

    DEFINE FRAME F-Detalle
        DETALLE.CodDiv 
        DETALLE.CodCli FORMAT "XXXXXXXXXXX"
        DETALLE.NomCli 
        dSdoAct-1[1]   FORMAT "->>>,>>>,>>9.99"  
        dSdoAct-1[2]   FORMAT "->>>,>>>,>>9.99"  
        dSdoAct-2[1]   FORMAT "->>>,>>>,>>9.99"
        dSdoAct-2[2]   FORMAT "->>>,>>>,>>9.99"
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 190 STREAM-IO DOWN.

    FOR EACH DETALLE NO-LOCK 
        BREAK BY DETALLE.CodCia
        BY DETALLE.CodDiv
        BY DETALLE.CodCli:
        
        VIEW STREAM REPORT FRAME F-Titulo.

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = detalle.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN cNomCli = gn-clie.nomcli.
        ELSE cNomCli = "".

        IF lookup(Detalle.CodDoc,"N/C,A/R,BD,CHQ") > 0  THEN x-Factor = -1.
        ELSE x-Factor = 1.
        
        IF FIRST-OF(Detalle.CodCli) THEN DO:
            dSdoAct-1 = 0.
            dSdoAct-2 = 0.
        END.

        IF Detalle.FchVto < TODAY THEN DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN dSdoAct-1[1] = (Detalle.SdoAct * x-factor) + dSdoAct-1[1].
                WHEN 2 THEN dSdoAct-1[2] = (Detalle.SdoAct * x-factor) + dSdoAct-1[2].
            END CASE.
        END.
        ELSE DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN dSdoAct-2[1] = (Detalle.SdoAct * x-factor) + dSdoAct-2[1].
                WHEN 2 THEN dSdoAct-2[2] = (Detalle.SdoAct * x-factor) + dSdoAct-2[2].
            END CASE.
        END.

        IF LAST-OF(Detalle.CodCli) THEN
            DISPLAY STREAM Report
                Detalle.CodDiv
                Detalle.CodCli
                cNomCli @ Detalle.NomCli
                dSdoAct-1[1]
                dSdoAct-1[2]
                dSdoAct-2[1]
                dSdoAct-2[2]
                WITH FRAME f-Detalle.     
    END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir W-Win 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   

    RUN Carga-Temporal.

    /*subtit-1 = 'FECHA DE CORTE: ' + STRING(x-FchDoc).*/

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

        RUN Formato-1.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  DEF VAR xx as logical.
  x-fchdoc = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
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

