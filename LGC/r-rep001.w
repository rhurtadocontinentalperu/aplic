&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
    Modificó    Fecha       Objetivo
    --------    ----------- --------------------------------------------
    MLR-1       26/Set/2008 Despliega campo situación en salida a Excel.
          
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
DEF SHARED VAR s-nomcia AS CHAR.

DEF TEMP-TABLE DETALLE LIKE Lg-cocmp
    FIELD DesCnd   AS CHAR FORMAT 'x(30)'
    FIELD ImpTot-1 AS DEC FORMAT '->>>,>>>,>>9.99'
    FIELD ImpTot-2 AS DEC FORMAT '->>>,>>>,>>9.99'.

DEF TEMP-TABLE DETALLE-1 
    FIELD CndCmp   LIKE Lg-cocmp.cndcmp
    FIELD DesCnd   AS CHAR FORMAT 'x(30)'
    FIELD ImpTot-1 AS DEC FORMAT '->>>,>>>,>>9.99'
    FIELD ImpTot-2 AS DEC FORMAT '->>>,>>>,>>9.99'.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME mF-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_Excel x-FchDoc-1 x-FchDoc-2 ~
RADIO-SET-tipo Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-FchDoc-1 x-FchDoc-2 RADIO-SET-tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 13 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 3" 
     SIZE 15 BY 1.5 TOOLTIP "Salida a archivo".

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 13 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumido por Modalidad", 1,
"Detallado", 2
     SIZE 21 BY 1.54 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME mF-Main
     Btn_Excel AT ROW 5.62 COL 15
     x-FchDoc-1 AT ROW 2.35 COL 17 COLON-ALIGNED
     x-FchDoc-2 AT ROW 3.31 COL 17 COLON-ALIGNED
     RADIO-SET-tipo AT ROW 2.54 COL 34 NO-LABEL
     Btn_OK AT ROW 5.62 COL 31
     Btn_Cancel AT ROW 5.62 COL 45
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 7.27
         FONT 4.


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
         TITLE              = "Resumen por Proveedor"
         HEIGHT             = 7.27
         WIDTH              = 71.86
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME mF-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen por Proveedor */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen por Proveedor */
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
ON CHOOSE OF Btn_Cancel IN FRAME mF-Main /* Cancelar */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME mF-Main /* Button 3 */
DO:
    ASSIGN x-FchDoc-1 x-FchDoc-2.
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME mF-Main /* Aceptar */
DO:
  ASSIGN x-FchDoc-1 x-FchDoc-2.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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

  DEF VAR x-ImpTot-1 AS DEC NO-UNDO.
  DEF VAR x-ImpTot-2 AS DEC NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN RADIO-SET-tipo.
    END.

  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  FOR EACH DETALLE-1:
    DELETE DETALLE-1.
  END.
  
  FOR EACH Lg-cocmp NO-LOCK WHERE Lg-cocmp.codcia = s-codcia
/*MLR-1* ***
        AND LOOKUP(TRIM(Lg-cocmp.flgsit), 'T,P') > 0
*MLR-1* ***/
        AND Lg-cocmp.fchdoc >= x-FchDoc-1
        AND Lg-cocmp.fchdoc <= x-FchDoc-2,
        FIRST Gn-concp NO-LOCK WHERE Gn-concp.codig = LG-COCmp.CndCmp
        BREAK BY Lg-cocmp.codcia
            BY Lg-cocmp.codpro 
            BY LG-COCmp.CndCmp 
            BY Lg-cocmp.modadq:
    DISPLAY     
        Lg-cocmp.nrodoc @ Fi-Mensaje WITH FRAME f-Proceso.
        
    ASSIGN
        x-ImpTot-1 = 0
        x-ImpTot-2 = 0.
    IF Lg-cocmp.codmon = 1
    THEN x-ImpTot-1 = Lg-cocmp.imptot.
    ELSE x-ImpTot-2 = Lg-cocmp.imptot.
    ACCUMULATE x-ImpTot-1 (TOTAL BY Lg-cocmp.modadq).
    ACCUMULATE x-ImpTot-2 (TOTAL BY Lg-cocmp.modadq).
/*MLR* ***
    IF LAST-OF(Lg-cocmp.codpro) 
        OR LAST-OF(Lg-cocmp.cndcmp)
        OR LAST-OF(Lg-cocmp.modadq) THEN DO:
*MLR* ***/

    IF RADIO-SET-tipo = 2 THEN DO:
        CREATE DETALLE.
        BUFFER-COPY Lg-cocmp TO DETALLE
            ASSIGN
                DETALLE.DesCnd   = Gn-ConCp.Nombr
                DETALLE.ImpTot-1 = x-ImpTot-1
                DETALLE.ImpTot-2 = x-ImpTot-2.
    END.

    IF LAST-OF(Lg-cocmp.modadq) AND RADIO-SET-tipo = 1 THEN DO:
        CREATE DETALLE.
        BUFFER-COPY Lg-cocmp TO DETALLE
            ASSIGN
                DETALLE.DesCnd   = Gn-ConCp.Nombr
                DETALLE.ImpTot-1 = ACCUM TOTAL BY Lg-cocmp.modadq x-ImpTot-1
                DETALLE.ImpTot-2 = ACCUM TOTAL BY Lg-cocmp.modadq x-ImpTot-2.
    END.
  END.
  
  FOR EACH DETALLE BREAK BY DETALLE.cndcmp:
    ACCUMULATE DETALLE.ImpTot-1 (TOTAL BY DETALLE.cndcmp).
    ACCUMULATE DETALLE.ImpTot-2 (TOTAL BY DETALLE.cndcmp).
    IF LAST-OF(DETALLE.cndcmp) THEN DO:
        CREATE DETALLE-1.
        ASSIGN
            DETALLE-1.CndCmp = DETALLE.CndCmp
            DETALLE-1.DesCnd = DETALLE.DesCnd
            DETALLE-1.ImpTot-1 = ACCUM TOTAL BY DETALLE.cndcmp DETALLE.ImpTot-1
            DETALLE-1.ImpTot-2 = ACCUM TOTAL BY DETALLE.cndcmp DETALLE.ImpTot-2.
    END.
  END.
  HIDE FRAME f-Proceso.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY x-FchDoc-1 x-FchDoc-2 RADIO-SET-tipo 
      WITH FRAME mF-Main IN WINDOW W-Win.
  ENABLE Btn_Excel x-FchDoc-1 x-FchDoc-2 RADIO-SET-tipo Btn_OK Btn_Cancel 
      WITH FRAME mF-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-mF-Main}
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
/*MLR-1*/ DEFINE VARIABLE cStatus      AS CHARACTER NO-UNDO.

    RUN carga-temporal.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "ORDEN DE COMPRAS RESUMIDAS POR PROVEEDOR".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value =
        "DESDE EL " + STRING(x-FchDoc-1) +
        " HASTA EL " + STRING(x-FchDoc-2).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "CÓDIGO".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRE/RAZÓN SOCIAL".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro O/C".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "EMISIÓN".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "CONDICIÓN DE COMPRA".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "CA. CO.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE S/.".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE US$".
/*MLR-1*/ cRange = "I" + cColumn.
/*MLR-1*/ chWorkSheet:Range(cRange):Value = "Situación".
/*MLR-1*/ cRange = "J" + cColumn.
/*MLR-1*/ chWorkSheet:Range(cRange):Value = "Fecha Entrega".
/*MLR-1*/ cRange = "K" + cColumn.
/*MLR-1*/ chWorkSheet:Range(cRange):Value = "Comprador".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("B"):ColumnWidth = 30.
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("E"):ColumnWidth = 20.
/*MLR-1* ***
    chWorkSheet:Range("A1:H3"):Font:Bold = TRUE.
*MLR-1* ***/
/*MLR-1*/ chWorkSheet:Range("A1:K3"):Font:Bold = TRUE.

    FOR EACH DETALLE NO-LOCK
        BREAK BY DETALLE.codcia
        BY DETALLE.codpro
        BY DETALLE.cndcmp
        BY DETALLE.modadq:

/*MLR-1*/ cStatus = "".
/*MLR-1*/ cStatus = ENTRY(LOOKUP(DETALLE.FlgSit,"X,G,P,A,T,V,R,C"),
/*MLR-1*/   "Rechazado,Emitido,Aprobado,Anulado,Aten.Total,Vencida,En Revision,Cerrada").

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.codpro.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.nompro.
        IF RADIO-SET-tipo = 2 THEN DO:
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = DETALLE.nrodoc.
        END.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.fchdoc.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.descnd.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.modadq.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.imptot-1.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE.imptot-2.
/*MLR-1*/ cRange = "I" + cColumn.
/*MLR-1*/ chWorkSheet:Range(cRange):Value = cStatus.
/*MLR-1*/ cRange = "J" + cColumn.
/*MLR-1*/ chWorkSheet:Range(cRange):Value = DETALLE.FchEnt.
/*MLR-1*/ cRange = "K" + cColumn.
/*MLR-1*/ chWorkSheet:Range(cRange):Value = DETALLE.Userid-com.
        DISPLAY
            DETALLE.codpro @ FI-MENSAJE FORMAT "X(12)"
            WITH FRAME F-PROCESO.
    END.

    iCount = iCount + 2.

    /* Resumen */
    FOR EACH DETALLE-1 NO-LOCK:

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE-1.descnd.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE-1.imptot-1.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = DETALLE-1.imptot-2.

    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

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
  DEFINE FRAME F-Hdr
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "O/C RESUMIDAS POR PROVEEDOR" AT 30
         "Pagina :" TO 130 PAGE-NUMBER(REPORT) TO 142 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 130 TODAY TO 142 FORMAT "99/99/9999" SKIP
         "Desde el" x-FchDoc-1 "hasta el" x-FChDoc-2 SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 
  
  DEFINE FRAME F-Deta
    DETALLE.codpro
    DETALLE.nompro      FORMAT 'x(50)'
    DETALLE.nrodoc
    DETALLE.fchdoc      COLUMN-LABEL 'Emision'
    DETALLE.descnd      COLUMN-LABEL 'Cond. de Compra'
    DETALLE.modadq      FORMAT 'x(3)'   COLUMN-LABEL 'Ca.Co.'
    DETALLE.imptot-1    COLUMN-LABEL 'Importe S/.'
    DETALLE.imptot-2    COLUMN-LABEL 'Importe US$'
  WITH WIDTH 250 NO-BOX STREAM-IO DOWN. 

  FOR EACH DETALLE NO-LOCK
        BREAK BY DETALLE.codcia BY DETALLE.codpro BY DETALLE.cndcmp BY DETALLE.modadq:
    VIEW STREAM REPORT FRAME F-Hdr.
    DISPLAY STREAM REPORT
        DETALLE.codpro
        DETALLE.nompro
        DETALLE.nrodoc WHEN RADIO-SET-tipo = 2
        DETALLE.fchdoc
        DETALLE.descnd
        DETALLE.modadq
        DETALLE.imptot-1
        DETALLE.imptot-2
        WITH FRAME F-Deta.
    ACCUMULATE DETALLE.imptot-1 (TOTAL BY DETALLE.codcia BY DETALLE.codpro).
    ACCUMULATE DETALLE.imptot-2 (TOTAL BY DETALLE.codcia BY DETALLE.codpro).
    IF LAST-OF(DETALLE.codpro) THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.imptot-1
            DETALLE.imptot-2
            WITH FRAME F-Deta.
        DISPLAY STREAM REPORT
            ACCUM TOTAL BY DETALLE.codpro DETALLE.imptot-1 @ DETALLE.imptot-1
            ACCUM TOTAL BY DETALLE.codpro DETALLE.imptot-2 @ DETALLE.imptot-2
            WITH FRAME F-Deta.
        DOWN STREAM REPORT 1 WITH FRAME f-Deta.
    END.
    IF LAST-OF(DETALLE.codcia) THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.imptot-1
            DETALLE.imptot-2
            WITH FRAME F-Deta.
        DISPLAY STREAM REPORT
            'TOTAL GENERAL' @ DETALLE.descnd
            ACCUM TOTAL BY DETALLE.codcia DETALLE.imptot-1 @ DETALLE.imptot-1
            ACCUM TOTAL BY DETALLE.codcia DETALLE.imptot-2 @ DETALLE.imptot-2
            WITH FRAME F-Deta.
        DOWN STREAM REPORT 3 WITH FRAME f-Deta.
        FOR EACH DETALLE-1:
            DISPLAY STREAM REPORT
                DETALLE-1.descnd @ DETALLE.descnd
                DETALLE-1.imptot-1 @ DETALLE.imptot-1
                DETALLE-1.imptot-2 @ DETALLE.imptot-2
                WITH FRAME F-Deta.
            DOWN STREAM REPORT 1 WITH FRAME F-Deta.
        END.
    END.
  END.

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

    RUN Carga-Temporal.

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
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT CLOSE.

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
  ASSIGN
    x-FchDoc-1 = TODAY - DAY(TODAY) + 1
    x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


