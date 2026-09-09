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
DEFINE SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE x-almacenes AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-FchCorte  AS DATE        NO-UNDO.
DEFINE VARIABLE c-ArtDesde  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ArtHasta  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-Almacenes AS CHARACTER   NO-UNDO.

DEF TEMP-TABLE Detalle 
    FIELD CodCia    LIKE Almmmate.codcia
    FIELD CodMat    LIKE Almmmatg.codmat LABEL 'Material'
    FIELD DesMat    LIKE Almmmatg.desmat LABEL 'Descripción'
    FIELD DesMar    LIKE Almmmatg.DesMar LABEL 'Marca'
    FIELD UndBas    LIKE Almmmatg.undstk LABEL 'Unidad'
    FIELD DesFam       AS CHAR LABEL 'Linea'
    FIELD SubFam       AS CHAR LABEL 'Sub-Linea'
    FIELD CodAlm    LIKE Almmmate.codalm LABEL 'Almacén'
    FIELD StkACt    LIKE Almmmate.stkact LABEL 'Stock'
    FIELDS FechaVta     AS DATE LABEL 'Última venta'
    FIELDS CtoPro       AS DEC LABEL "Costo Unitario con IGV (S/.)"
    FIELDS CtoRep       AS DEC LABEL "Costo Promedio Kardex"
    FIELD CodBrr    LIKE Almmmatg.codbrr LABEL 'Código ENA13'
    FIELD Barras1   LIKE Almmmatg.codbrr LABEL 'Código ENA14(1)'
    FIELD Barras2   LIKE Almmmatg.codbrr LABEL 'Código ENA14(2)'
    FIELD Barras3   LIKE Almmmatg.codbrr LABEL 'Código ENA14(3)'
    FIELD PreVta    AS DEC LABEL "Precio Venta S/."
    FIELD TpoArt    LIKE Almmmatg.tpoart LABEL 'Estado'
    INDEX Llave01 AS PRIMARY codcia CodAlm CodMat.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-CodAlm BUTTON-3 txt-Desde ~
txt-Hasta txt-fchcorte tg-stock rs-estado txt-codfam Btn-Excel BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodAlm rs-tipo txt-Desde txt-Hasta ~
txt-fchcorte tg-stock rs-estado txt-codfam F-mensaje F-mnje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 6" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .96.

DEFINE VARIABLE F-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88
     BGCOLOR 8 FGCOLOR 14 FONT 0 NO-UNDO.

DEFINE VARIABLE F-mnje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88
     BGCOLOR 8 FGCOLOR 14 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(1000)":U 
     LABEL "Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codfam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Desde AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-fchcorte AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Corte" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Hasta AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE rs-estado AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activo", "A",
"Desactivo", "D",
"Todos", ""
     SIZE 29 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-tipo AS CHARACTER INITIAL "D" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Detallado", "D",
"Resumen", "R"
     SIZE 21 BY 1.69 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.43 BY 9.35.

DEFINE VARIABLE tg-stock AS LOGICAL INITIAL yes 
     LABEL "Solo Con Stock" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodAlm AT ROW 1.62 COL 14 COLON-ALIGNED WIDGET-ID 4
     BUTTON-3 AT ROW 1.69 COL 71 WIDGET-ID 6
     rs-tipo AT ROW 2.81 COL 16 NO-LABEL WIDGET-ID 8
     txt-Desde AT ROW 4.73 COL 14 COLON-ALIGNED WIDGET-ID 12
     txt-Hasta AT ROW 4.73 COL 41 COLON-ALIGNED WIDGET-ID 14
     txt-fchcorte AT ROW 5.81 COL 14 COLON-ALIGNED WIDGET-ID 16
     tg-stock AT ROW 5.85 COL 43 WIDGET-ID 32
     rs-estado AT ROW 6.65 COL 43 NO-LABEL WIDGET-ID 34
     txt-codfam AT ROW 6.92 COL 14 COLON-ALIGNED WIDGET-ID 30
     Btn-Excel AT ROW 8.19 COL 53.29 WIDGET-ID 18
     BUTTON-2 AT ROW 8.19 COL 61.14 WIDGET-ID 28
     F-mensaje AT ROW 8.73 COL 2 NO-LABEL WIDGET-ID 20
     F-mnje AT ROW 8.73 COL 69.57 NO-LABEL WIDGET-ID 24
     RECT-1 AT ROW 1.08 COL 1.57 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.43 BY 9.65 WIDGET-ID 100.


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
         TITLE              = "Reporte Articulos"
         HEIGHT             = 9.65
         WIDTH              = 78.43
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
/* SETTINGS FOR FILL-IN F-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-mnje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RADIO-SET rs-tipo IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       rs-tipo:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Articulos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Excel W-Win
ON CHOOSE OF Btn-Excel IN FRAME F-Main /* Button 6 */
DO:
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
  
    RUN lib/tt-file-to-text (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    ASSIGN 
        txt-Desde txt-Hasta txt-fchcorte rs-tipo txt-codfam tg-stock rs-estado.
        
    IF txt-desde = "" THEN c-ArtDesde = '000000'. ELSE c-ArtDesde = txt-Desde.
    IF txt-hasta = "" THEN c-ArtHasta = '999999'. ELSE c-ArtHasta = txt-Hasta.

/*     CASE rs-tipo:                  */
/*         WHEN "D" THEN RUN Excel.   */
/*         WHEN "R" THEN RUN Excel-R. */
/*     END CASE.                      */

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    pOptions = pOptions + CHR(1) + "SkipList:CodCia".

    RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).

    MESSAGE 'Proceso Terminado'.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
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
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = FILL-IN-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).
    FILL-IN-CodAlm:SCREEN-VALUE = x-almacenes.
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

    DEFINE VARIABLE x-Orden AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cDesFam AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDesSub AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dTpoCmb AS DECIMAL     NO-UNDO.

    EMPTY TEMP-TABLE detalle.
    c-almacenes = FILL-IN-CodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    /* STOCKS CONTI */
    FOR EACH integral.almmmate NO-LOCK WHERE integral.almmmate.codcia = s-codcia
        AND integral.almmmate.codmat >=  c-ArtDesde
        AND integral.almmmate.codmat <=  c-ArtHasta
        AND LOOKUP(integral.almmmate.codalm,c-almacenes) > 0,
        FIRST integral.almmmatg OF integral.almmmate NO-LOCK
        WHERE integral.almmmatg.codfam BEGINS txt-codfam
        AND integral.almmmatg.tpoart BEGINS rs-estado:

        IF tg-stock AND integral.almmmate.stkact = 0 THEN NEXT.

        FIND FIRST almtfam WHERE almtfam.codcia = s-codcia
            AND almtfam.codfam = almmmatg.codfam NO-LOCK NO-ERROR.
        IF AVAIL almtfam THEN cDesFam = almtfam.codfam + "-" + almtfam.desfam.
        ELSE cDesFam = ''.

        FIND FIRST almsfam WHERE almsfam.codcia = s-codcia
            AND almsfam.codfam = almmmatg.codfam 
            AND almsfam.subfam = almmmatg.subfam NO-LOCK NO-ERROR.
        IF AVAIL almsfam THEN cDesSub = almsfam.subfam + "-" + almsfam.dessub.
        ELSE cDesSub = ''.

        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Conti >> ' +
            integral.almmmatg.codmat + ' ' +
            integral.almmmatg.desmat.

        f-mnje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' .... '.

          IF integral.almmmatg.MonVta <> 1 THEN dTpoCmb = integral.almmmatg.tpocmb.
          ELSE dTpoCmb = 1.

          FIND detalle OF integral.almmmate EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN CREATE detalle.
          BUFFER-COPY 
              integral.almmmatg TO detalle
              ASSIGN 
              Detalle.CodAlm        = Almmmate.codalm
              Detalle.DesFam        = cDesFam
              Detalle.SubFam        = cDesSub
              Detalle.StkAct        = integral.Almmmate.stkact
              Detalle.CtoPro        = integral.Almmmatg.CtoTot * dTpoCmb
              Detalle.PreVta        = integral.Almmmatg.PreOfi * dTpoCmb.
          FIND LAST integral.almstkal WHERE integral.almstkal.codcia = s-codcia
              AND integral.almstkal.codmat = integral.almmmatg.codmat
              AND integral.almstkal.codalm = integral.almmmate.codalm
              AND integral.almstkal.fecha <= txt-fchcorte NO-LOCK NO-ERROR.
          IF AVAIL integral.almstkal THEN Detalle.CtoRep = integral.AlmStkal.CtoUni.
          /* BARRAS EAN 14 */
          FIND FIRST almmmat1 OF Almmmatg NO-LOCK NO-ERROR.
          IF AVAIL almmmat1 THEN DO:
              ASSIGN
                  Barras1 = Almmmat1.Barras[1] 
                  Barras2 = Almmmat1.Barras[2] 
                  Barras3 = Almmmat1.Barras[3].
          END.
    END.
  
    /*Busca Ultima venta*/
    FOR EACH detalle NO-LOCK:
        FIND LAST almdmov USE-INDEX almd02 WHERE almdmov.codci = s-codcia
            AND almdmov.codmat = detalle.codmat
            AND almdmov.fchdoc <= txt-fchcorte
            AND almdmov.tipmov = 'S'
            AND almdmov.codmov = 02 NO-LOCK NO-ERROR.
        IF AVAIL almdmov THEN detalle.FechaVta = almdmov.fchdoc.
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' << Ventas >> '.
        f-mnje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' .... '.
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
  DISPLAY FILL-IN-CodAlm rs-tipo txt-Desde txt-Hasta txt-fchcorte tg-stock 
          rs-estado txt-codfam F-mensaje F-mnje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 FILL-IN-CodAlm BUTTON-3 txt-Desde txt-Hasta txt-fchcorte 
         tg-stock rs-estado txt-codfam Btn-Excel BUTTON-2 
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
DEFINE VARIABLE t-Column                AS INTEGER.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE cLetra                  AS CHAR.
DEFINE VARIABLE cLetra2                 AS CHAR.
DEFINE VARIABLE xOrden                  AS INT.

RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A2"):Value = "Material".
chWorkSheet:Range("B2"):Value = "Descripcion".
chWorkSheet:Range("C2"):Value = "Marca".
chWorkSheet:Range("D2"):Value = "Unidad".
chWorkSheet:Range("E2"):Value = "Linea".
chWorkSheet:Range("F2"):Value = "Sub-linea".
chWorkSheet:Range("G2"):Value = "Almacen".
chWorkSheet:Range("H2"):Value = "Stock".
chWorkSheet:Range("I2"):Value = "Última Venta".
chWorkSheet:Range("J2"):Value = "Costo Unitario con IGV (S/.)".
chWorkSheet:Range("K2"):Value = "Costo Promedio Kardex".
chWorkSheet:Range("L2"):Value = "Codigo EAN13".
chWorkSheet:Range("M2"):Value = "Codigo EAN14(1)".
chWorkSheet:Range("N2"):Value = "Codigo EAN14(2)".
chWorkSheet:Range("O2"):Value = "Codigo EAN14(3)".
chWorkSheet:Range("P2"):Value = "Precio Venta S/.".
chWorkSheet:Range("Q2"):Value = "Estado".

t-column = 2.

loopREP:
FOR EACH Detalle ,
    FIRST Almmmatg OF Detalle NO-LOCK
    BREAK BY Detalle.CodAlm BY Detalle.CodMat:

/*     IF FIRST-OF(Detalle.CodAlm) THEN DO:                                                  */
/*         FIND FIRST Almacen WHERE Almacen.CodCia = Detalle.CodCia                          */
/*             AND Almacen.CodAlm = Detalle.CodAlm NO-LOCK NO-ERROR.                         */
/*         IF AVAIL Almacen THEN DO:                                                         */
/*             t-column = t-column + 2.                                                      */
/*             /* DATOS DEL PRODUCTO */                                                      */
/*             cColumn = STRING(t-Column).                                                   */
/*             cRange = "B" + cColumn.                                                       */
/*             chWorkSheet:Range(cRange):Value = Almacen.CodAlm + "-" + Almacen.Descripcion. */
/*         END.                                                                              */
/*     END.                                                                                  */

    t-column = t-column + 1.
    /* DATOS DEL PRODUCTO */    
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.UndBas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.DesFam.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.SubFam.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodAlm.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StkAct.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.FechaVta.

    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoPro.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoRep.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Almmmatg.CodBrr.

    FIND FIRST almmmat1 OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAIL almmmat1 THEN DO:
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Almmmat1.Barras[1] .
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Almmmat1.Barras[2] .
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Almmmat1.Barras[3] .

    END.

    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.PreVta.
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.TpoArt.

    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '<< Generando Excel >> ' .
    f-mnje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' .... '.
    
    PAUSE 0.
END.    

iCount = iCount + 2.

HIDE FRAME f-mensajes NO-PAUSE.

f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' .
f-mnje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' '.

MESSAGE "Proceso Terminado".

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


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
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE cLetra                  AS CHAR.
DEFINE VARIABLE cLetra2                 AS CHAR.
DEFINE VARIABLE xOrden                  AS INT.

RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A2"):Value = "Material".
chWorkSheet:Range("B2"):Value = "Descripcion".
chWorkSheet:Range("C2"):Value = "Marca".
chWorkSheet:Range("D2"):Value = "Unidad".
chWorkSheet:Range("E2"):Value = "Linea".
chWorkSheet:Range("F2"):Value = "Sub-linea".
chWorkSheet:Range("G2"):Value = "Stock".
chWorkSheet:Range("H2"):Value = "Costo Unitario con IGV (S/.)".
chWorkSheet:Range("I2"):Value = "Costo Promedio Kardex".

chWorkSheet:Range("J2"):Value = "Codigo EAN13".
chWorkSheet:Range("K2"):Value = "Codigo EAN14(1)".
chWorkSheet:Range("L2"):Value = "Codigo EAN14(2)".
chWorkSheet:Range("M2"):Value = "Codigo EAN14(3)".
chWorkSheet:Range("N2"):Value = "Precio Venta S/.".
chWorkSheet:Range("O2"):Value = "Estado".

t-column = 2.

loopREP:
FOR EACH Detalle ,
    FIRST Almmmatg OF Detalle NO-LOCK
    BREAK BY Detalle.CodMat:

    ACCUMULATE Detalle.StkAct (TOTAL BY Detalle.codmat).

    IF LAST-OF(Detalle.CodMat) THEN DO:
        t-column = t-column + 1.
        /* DATOS DEL PRODUCTO */    
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle.CodMat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmatg.DesMat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmatg.DesMar.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmatg.UndBas.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.DesFam.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.SubFam.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY Detalle.codmat Detalle.StkAct.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.CtoPro.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.CtoRep.

        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Almmmatg.CodBrr.

        FIND FIRST almmmat1 OF Almmmatg NO-LOCK NO-ERROR.
        IF AVAIL almmmat1 THEN DO:
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + Almmmat1.Barras[1] .
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + Almmmat1.Barras[2] .
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + Almmmat1.Barras[3] .

        END.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.PreVta.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmatg.TpoArt.


    END.

    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '<< Generando Excel >> ' .
    f-mnje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' .... '.
    
    PAUSE 0.
END.    

iCount = iCount + 2.

HIDE FRAME f-mensajes NO-PAUSE.

f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' .
f-mnje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ' '.

MESSAGE "Proceso Terminado".

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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN txt-fchcorte = TODAY.
      DISPLAY txt-fchcorte.
  END.

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

