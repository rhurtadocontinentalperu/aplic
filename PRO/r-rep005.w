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
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR PR-CODCIA AS INT NO-UNDO.

FIND FIRST EMPRESAS WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN PR-CODCIA = S-CODCIA.

DEFINE TEMP-TABLE Reporte NO-UNDO
     FIELDS NumLiq LIKE PR-LIQC.NUMLIQ
     FIELDS FchLiq LIKE PR-LIQC.FCHLIQ
     FIELDS NumOrd LIKE PR-LIQC.NUMORD
     FIELDS FchOrd LIKE PR-ODPC.FCHORD            
     FIELDS CodMat LIKE PR-LIQD1.CODMAT
     FIELDS DesMat LIKE ALMMMATG.DESMAT  FORMAT "X(70)"
     FIELDS DesMar LIKE ALMMMATG.DESMAR  FORMAT "X(15)"
     FIELDS UndBas LIKE ALMMMATG.UNDBAS FORMAT "X(5)"
     FIELDS CanDes LIKE PR-LIQD1.CANDES  FORMAT "->>>>999".


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
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-fecha FILL-IN-fecha-2 BUTTON-1 ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-fecha FILL-IN-fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.54 TOOLTIP "Aceptar".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.54 TOOLTIP "Cancelar".

DEFINE VARIABLE FILL-IN-fecha AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha Liquidación Inicio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha Liquidación Fin" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-fecha AT ROW 1.77 COL 20 COLON-ALIGNED
     FILL-IN-fecha-2 AT ROW 2.92 COL 20 COLON-ALIGNED
     BUTTON-1 AT ROW 1.77 COL 34
     BUTTON-2 AT ROW 3.5 COL 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 53.72 BY 6.12
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Materiales por Ordenes de Trabajo"
         HEIGHT             = 6.12
         WIDTH              = 53.57
         MAX-HEIGHT         = 6.12
         MAX-WIDTH          = 53.72
         VIRTUAL-HEIGHT     = 6.12
         VIRTUAL-WIDTH      = 53.72
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
/* SETTINGS FOR FRAME F-Main
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
ON END-ERROR OF W-Win /* Materiales por Ordenes de Trabajo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Materiales por Ordenes de Trabajo */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN FILL-IN-fecha FILL-IN-fecha-2.
    RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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

    FOR EACH Reporte:
        DELETE Reporte.
    END.
    
    FOR EACH PR-LIQC NO-LOCK 
        WHERE PR-LIQC.CODCIA = s-codcia AND
        PR-LIQC.FCHLIQ >= FILL-IN-fecha AND 
        PR-LIQC.FCHLIQ <= FILL-IN-fecha-2 AND
        PR-LIQC.FlgEst <> "A", 
        EACH PR-LIQD1 OF PR-LIQC NO-LOCK,
        EACH ALMMMATG NO-LOCK
        WHERE ALMMMATG.CodCia = PR-LIQD1.CodCia AND
        ALMMMATG.CODMAT = PR-LIQD1.CODMAT,        
        EACH PR-ODPC NO-LOCK
        WHERE PR-ODPC.NUMORD = PR-LIQC.NUMORD
        BREAK BY PR-LIQC.NUMLIQ:
        
        CREATE Reporte.
        ASSIGN 
            Reporte.NumLiq = PR-LIQC.NUMLIQ
            Reporte.FchLiq = PR-LIQC.FCHLIQ
            Reporte.NumOrd = PR-LIQC.NUMORD
            Reporte.FchOrd = PR-ODPC.FCHORD            
            Reporte.CodMat = PR-LIQD1.CODMAT
            Reporte.DesMat = ALMMMATG.DESMAT
            Reporte.DesMar = ALMMMATG.DESMAR
            Reporte.UndBas = ALMMMATG.UNDBAS
            Reporte.CanDes = PR-LIQD1.CANDES.
        
        DISPLAY
            Reporte.NumLiq @ Fi-Mensaje
            LABEL "  Cargando Orden" FORMAT "X(13)"
            WITH FRAME F-Proceso.
    END.
    HIDE FRAME F-Proceso.
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
  DISPLAY FILL-IN-fecha FILL-IN-fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-fecha FILL-IN-fecha-2 BUTTON-1 BUTTON-2 
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

 /*   DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

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
    chWorkSheet:Range(cRange):Value =
        "REPORTE DE EMPLEADOS DE " +
        CAPS(COMBO-BOX-Mes) + " A " +
        CAPS(COMBO-BOX-Mes-2) + " DE " +
        STRING(COMBO-BOX-Periodo,"9999").
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "CÓDIGO".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "APELLIDO PATERNO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "APELLIDO MATERNO".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRE(S)".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA INGRESO".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "CARGO".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "SECCIÓN".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLASE".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "SUELDO BÁSICO".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("B"):ColumnWidth = 30.
    chWorkSheet:Columns("C"):ColumnWidth = 30.
    chWorkSheet:Columns("D"):ColumnWidth = 30.
    chWorkSheet:Columns("F"):ColumnWidth = 30.
    chWorkSheet:Columns("G"):ColumnWidth = 30.
    chWorkSheet:Columns("H"):ColumnWidth = 30.
    chWorkSheet:Range("A1:I2"):Font:Bold = TRUE.

    FOR EACH wrk_report NO-LOCK:
        
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_codper.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_patper.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_matper.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_nomper.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_fecing.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_cargo.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_seccion.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_clase.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = wrk_basico.
        DISPLAY
            wrk_codper @ FI-MENSAJE LABEL "  Procesando Empleado" FORMAT "X(12)"
            WITH FRAME F-PROCESO.

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
        VIEW-AS ALERT-BOX INFORMA.*/

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
    DEFINE FRAME F-REPORTE
        Reporte.NumOrd COLUMN-LABEL "Num!Orden"
        Reporte.FchOrd COLUMN-LABEL "Fecha!Orden" 
        Reporte.NumLiq COLUMN-LABEL "Num!Liquid."
        Reporte.FchLiq COLUMN-LABEL "Fecha!Liquid"
        Reporte.CodMat COLUMN-LABEL "Código!Material"
        Reporte.DesMat COLUMN-LABEL "Descripcion Material" FORMAT "X(40)"
        Reporte.DesMar COLUMN-LABEL "Marca"         FORMAT "X(15)"
        Reporte.UndBas COLUMN-LABEL "Unidad"
        Reporte.CanDes COLUMN-LABEL "Cantidad"      FORMAT "->>>,>>9.99"
        HEADER
        "MATERIALES POR ORDENES DE TRABAJO" AT 40 SKIP (3)
        "DESDE EL" FILL-IN-Fecha "HASTA EL" FILL-IN-Fecha-2 SKIP (2)
        WITH STREAM-IO DOWN WIDTH 320.
    
    FOR EACH Reporte NO-LOCK
        BREAK BY Reporte.NumLiq
        BY Reporte.NumOrd:
        DISPLAY STREAM REPORT
            Reporte.NumOrd  WHEN FIRST-OF (Reporte.NumOrd)
            Reporte.FchOrd  WHEN FIRST-OF (Reporte.NumOrd)
            Reporte.NumLiq  WHEN FIRST-OF (Reporte.NumLiq)
            Reporte.FchLiq  WHEN FIRST-OF (Reporte.NumLiq)            
            Reporte.CodMat
            Reporte.DesMat
            Reporte.DesMar
            Reporte.UndBas
            Reporte.CanDes
        WITH FRAME F-Reporte.
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
    DEF VAR x-NameArch AS CHAR.
    DEF VAR OKpressed AS LOGICAL INIT TRUE.

    /*Guardar Archivo en la ruta D*/ 
    SYSTEM-DIALOG GET-FILE x-NameArch
        TITLE      "Guardar Archivo"
        FILTERS    "(*.txt)"   "*.txt"
        ASK-OVERWRITE
        DEFAULT-EXTENSION ".txt"
        INITIAL-DIR "D:"
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
      
    IF OKpressed <> TRUE THEN RETURN.

    RUN Carga-Temporal.
    
    FIND FIRST Reporte NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE Reporte THEN DO:
        MESSAGE
            "No hay registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    OUTPUT STREAM REPORT TO VALUE (x-NameArch).
    RUN FORMATO.
    MESSAGE "Proceso Terminado" VIEW-AS ALERT-BOX INFORMATION.
    OUTPUT STREAM REPORT CLOSE.

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
        ASSIGN
            FILL-IN-FECHA = DATE(MONTH(TODAY),1,YEAR(TODAY))
            FILL-IN-FECHA-2 = TODAY.

    END.

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


