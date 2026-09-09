&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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

DEFINE SHARED VARIABLE S-CODCIA  AS INT.
DEFINE SHARED VARIABLE PV-CODCIA AS INT.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODTER  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.

DEFINE TEMP-TABLE Detalle LIKE Vtadtickets.

/* Variables para migrar a Excel */
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCierr

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbCierr.FchCie CcbCierr.HorCie ~
CcbCierr.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND (s-user-id = 'ADMIN' OR CcbCierr.usuario = s-user-id) ~
 AND CcbCierr.FchCie = FILL-IN-FchCie NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND (s-user-id = 'ADMIN' OR CcbCierr.usuario = s-user-id) ~
 AND CcbCierr.FchCie = FILL-IN-FchCie NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbCierr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbCierr


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchCie BROWSE-2 BUTTON-1 BtnDone ~
BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchCie 

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
     SIZE 7 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 1" 
     SIZE 7 BY 1.65.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 7 BY 1.73.

DEFINE VARIABLE FILL-IN-FchCie AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de cierre" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbCierr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      CcbCierr.FchCie FORMAT "99/99/9999":U
      CcbCierr.HorCie COLUMN-LABEL "Hora de Cierre" FORMAT "x(8)":U
      CcbCierr.usuario COLUMN-LABEL "Cajero" FORMAT "x(10)":U WIDTH 14.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 41 BY 4.81 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchCie AT ROW 1.38 COL 19 COLON-ALIGNED WIDGET-ID 2
     BROWSE-2 AT ROW 3.15 COL 4 WIDGET-ID 200
     BUTTON-1 AT ROW 1.27 COL 49 WIDGET-ID 4
     BtnDone AT ROW 1.19 COL 63 WIDGET-ID 6
     BUTTON-3 AT ROW 1.19 COL 56 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70 BY 7.92 WIDGET-ID 100.


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
         TITLE              = "ANEXO DE VALES CONTINENTAL"
         HEIGHT             = 7.92
         WIDTH              = 70
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 82.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 82.86
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 FILL-IN-FchCie F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.CcbCierr"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "CcbCierr.CodCia = s-codcia
 AND (s-user-id = 'ADMIN' OR CcbCierr.usuario = s-user-id)
 AND CcbCierr.FchCie = FILL-IN-FchCie"
     _FldNameList[1]   = INTEGRAL.CcbCierr.FchCie
     _FldNameList[2]   > INTEGRAL.CcbCierr.HorCie
"HorCie" "Hora de Cierre" "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCierr.usuario
"usuario" "Cajero" ? "character" ? ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ANEXO DE VALES CONTINENTAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ANEXO DE VALES CONTINENTAL */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN FILL-IN-FchCie.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  ASSIGN FILL-IN-FchCie.
  /* Excel */
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Excel.
  SESSION:SET-WAIT-STATE('').
  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

  MESSAGE 'Proceso terminado'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchCie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchCie W-Win
ON LEAVE OF FILL-IN-FchCie IN FRAME F-Main /* Fecha de cierre */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

EMPTY TEMP-TABLE Detalle.
FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia
    AND Ccbccaja.flgcie = "C"
    AND (s-user-id = 'ADMIN' OR Ccbccaja.usuario = s-user-id)
    AND Ccbccaja.fchcie = Ccbcierr.fchcie
    AND Ccbccaja.horcie = Ccbcierr.horcie,
    EACH Vtadtickets NO-LOCK WHERE Vtadtickets.codcia = s-codcia
    AND Vtadtickets.codref = Ccbccaja.coddoc
    AND Vtadtickets.nroref = Ccbccaja.nrodoc:
    CREATE Detalle.
    BUFFER-COPY Vtadtickets TO Detalle.
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
  DISPLAY FILL-IN-FchCie 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-FchCie BROWSE-2 BUTTON-1 BtnDone BUTTON-3 
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


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
ASSIGN
    chWorkSheet:Range("A1"):Value = CAPS(s-nomcia) + " - ANEXO DE VALES CONTINENTAL"
    chWorkSheet:Range("A2"):Value = "Division"
    chWorkSheet:Range("B2"):Value = "Doc"
    chWorkSheet:Range("C2"):Value = "Numero"
    chWorkSheet:Range("D2"):Value = "Fecha de Emision"
    chWorkSheet:Range("E2"):Value = "Usuario"
    chWorkSheet:Range("F2"):Value = "Producto"
    chWorkSheet:Range("G2"):Value = "Proveedor"
    chWorkSheet:Range("H2"):Value = "Nombre"
    chWorkSheet:Range("I2"):Value = "Ticket N°"
    chWorkSheet:Range("J2"):Value = "Importe"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Columns("D"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Columns("F"):NumberFormat = "@"
    chWorkSheet:Columns("G"):NumberFormat = "@"
    chWorkSheet:Columns("I"):NumberFormat = "@"
    .

ASSIGN
    t-Row = 2.
FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia
    AND Ccbccaja.flgcie = "C"
    AND Ccbccaja.fchcie = Ccbcierr.fchcie
    AND Ccbccaja.horcie = Ccbcierr.horcie,
    EACH Vtadtickets NO-LOCK WHERE Vtadtickets.codcia = s-codcia
    AND Vtadtickets.codref = Ccbccaja.coddoc
    AND Vtadtickets.nroref = Ccbccaja.nrodoc,
    FIRST VtaCTickets OF Vtadtickets NO-LOCK,
    FIRST gn-prov NO-LOCK WHERE gn-prov.codcia = pv-codcia
    AND gn-prov.codpro = Vtactickets.codpro:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.CodDiv.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.CodRef.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.NroRef.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Fecha.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Usuario.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaCTickets.Producto.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaCTickets.CodPro.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = gn-prov.NomPro.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.NroTck.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Valor.
END.
chExcelApplication:VISIBLE = TRUE.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* CONTAMOS CUANTAS LINEAS TIENE LA IMPRESION */
DEF VAR x-Lineas AS INT NO-UNDO.

FOR EACH Detalle:
    x-Lineas = x-Lineas + 1.
END.


/* AGREGAMOS LOS TITULOS Y PIE DE PAGINA */
x-Lineas = x-Lineas + 30.

IF s-user-id = "ADMIN" THEN OUTPUT TO PRINTER.
ELSE DO:
    IF s-OpSys = 'WinVista'
    THEN OUTPUT TO PRINTER VALUE(s-port-name).
    ELSE OUTPUT TO VALUE(s-port-name).
END.

PUT CONTROL CHR(27) + CHR(112) + CHR(48) .
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(x-Lineas) + {&PRN4}.

/* Resumen de productos */
PUT UNFORMATTED
    s-NomCia SKIP(1)
    "Term/Usr    : " S-CODTER "/" s-User-Id SKIP
    "Cierre      : " Ccbcierr.FchCie " " Ccbcierr.HorCie SKIP
    "Comprobante : " STRING(Ccbcierr.FchCie, '99999999') + REPLACE(Ccbcierr.HorCie, ":", "")
    SKIP(1)
    "Proveedor                                Producto  Importe S/." SKIP
    "--------------------------------------------------------------" SKIP.
   /*12345678901234567890123456789012345678901234567890123456789012345678901234567890*/
   /*1234567890123456789012345678901234567890 123456789 >>>,>>9.99*/
FOR EACH Detalle, FIRST Vtactickets OF Detalle NO-LOCK,
    FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = Vtactickets.codpro
    BREAK BY Vtactickets.CodCia BY Vtactickets.Producto:
    ACCUMULATE Detalle.Valor (TOTAL BY Vtactickets.CodCia).
    ACCUMULATE Detalle.Valor (SUB-TOTAL BY Vtactickets.Producto).
    IF LAST-OF(Vtactickets.Producto) THEN DO:
        PUT
            gn-prov.NomPro FORMAT 'x(40)' ' '
            Vtactickets.producto ' '
            (ACCUM SUB-TOTAL BY Vtactickets.Producto Detalle.Valor) FORMAT '>>>,>>9.99'
            SKIP.
    END.
    IF LAST-OF(Vtactickets.CodCia) THEN DO:
        PUT
            '-----------' AT 52 SKIP
            'TOTAL' AT 42
            ACCUM TOTAL BY Vtactickets.CodCia Detalle.Valor AT 51 FORMAT '>>>,>>9.99'
            SKIP.
    END.
END.
PUT ' ' SKIP.
/* Detalle */
PUT UNFORMATTED
    "Número          Importe S/.  Doc Número  " SKIP
    "-----------------------------------------" SKIP.
   /*1234567890123456789012345678901234567890*/
   /*123456789012 >>>,>>9.99 123 123456789012*/
FOR EACH Detalle BREAK BY Detalle.Producto BY Detalle.NroTck:
    ACCUMULATE Detalle.Valor (SUB-TOTAL BY Detalle.Producto).
    IF FIRST-OF(Detalle.Producto) THEN DO:
        PUT 
            "PRODUCTO: " Detalle.Producto 
            SKIP.
    END.
    PUT
        Detalle.NroTck  FORMAT 'x(12)' ' '
        Detalle.Valor   FORMAT ">>>,>>9.99" ' '
        Detalle.CodRef  FORMAT 'x(3)' ' '
        Detalle.NroRef  FORMAT 'x(12)'
        SKIP.
    IF LAST-OF(Detalle.Producto) THEN DO:
        PUT
            'SUB-TOTAL' AT 2
            (ACCUM SUB-TOTAL BY Detalle.Producto Detalle.Valor) AT 14 FORMAT '>>>,>>9.99'
            SKIP.
    END.
END.
PUT UNFORMATTED
    SKIP(3)
    "---------------------------------------" SKIP
    "                CAJERO                 " SKIP(4)
    "---------------------------------------" SKIP
    "             ADMINISTRADOR             " SKIP.

OUTPUT CLOSE.

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

IF s-user-id <> "ADMIN" THEN DO:
    FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = S-CodCia AND
        CcbDTerm.CodDoc = "TCK" AND
        CcbDTerm.CodDiv = S-CodDiv AND
        CcbDTerm.CodTer = s-CodTer
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbdterm THEN DO:
        MESSAGE 'No tiene una ticketera configurada para este terminal:' s-CodTer
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND 
        FacCorre.CodDiv = S-CODDIV AND
        FacCorre.CodDoc = "TCK" AND
        FacCorre.NroSer = CcbDTerm.NroSer NO-LOCK.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE 'No tiene una ticketera configurada para este terminal:' s-CodTer CcbDTerm.NroSer
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
    IF s-port-name = '' THEN DO:
        MESSAGE 'NO hay una impresora (ticketera) configurada para este terminal' s-CodTer CcbDTerm.NroSer
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.
ELSE DO:
    DEF VAR rpta AS LOG NO-UNDO.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.
END.

RUN Carga-Temporal.
FIND FIRST Detalle NO-LOCK NO-ERROR.
IF NOT AVAILABLE Detalle THEN DO:
    MESSAGE 'Fin de archivo' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

RUN Formato.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCierr"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

