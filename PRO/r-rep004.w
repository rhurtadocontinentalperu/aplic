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
    FIELDS Item AS INTEGER
    FIELDS NumLiq   LIKE PR-LIQC.NumLiq
    FIELDS FchLiq   LIKE PR-LIQC.FchLiq
    FIELDS NumOrd   LIKE PR-LIQC.NumOrd
    FIELDS FchOrd   LIKE PR-ODPC.FchOrd
    FIELDS CenCon   LIKE PR-ODPC.CodPro
    FIELDS CodArt   LIKE PR-ODPCX.CodArt
    FIELDS DesArt   LIKE ALMMMATG.DesMat
    FIELDS UndMed   LIKE ALMMMATG.UndBas
    FIELDS CanReq   LIKE PR-ODPCX.CanPed    
    FIELDS CanPro   LIKE PR-LIQCX.CanFin    
    FIELDS CodMat   LIKE PR-LIQCX.CodArt
    FIELDS DesMat   LIKE ALMMMATG.DesMat
    FIELDS UndBas   LIKE ALMMMATG.UndBas
    FIELDS PrcUni   LIKE PR-LIQD1.PreUni    
    FIELDS CanMat   LIKE PR-LIQCX.CanFin    
    FIELDS NumPed   LIKE PR-RQPROC.NroDoc.

DEFINE TEMP-TABLE Reporte-1 NO-UNDO
    FIELDS Item AS INTEGER
    FIELDS NumLiq   LIKE PR-LIQC.NumLiq
    FIELDS FchLiq   LIKE PR-LIQC.FchLiq
    FIELDS NumOrd   LIKE PR-LIQC.NumOrd
    FIELDS FchOrd   LIKE PR-ODPC.FchOrd
    FIELDS CenCon   LIKE PR-ODPC.CodPro
    FIELDS CodArt   LIKE PR-ODPCX.CodArt
    FIELDS DesArt   LIKE ALMMMATG.DesMat
    FIELDS UndMed   LIKE ALMMMATG.UndBas
    FIELDS CanReq   LIKE PR-ODPCX.CanPed    
    FIELDS CanPro   LIKE PR-LIQCX.CanFin    
    FIELDS CodMat   LIKE PR-LIQCX.CodArt
    FIELDS DesMat   LIKE ALMMMATG.DesMat
    FIELDS UndBas   LIKE ALMMMATG.UndBas
    FIELDS PrcUni   LIKE PR-LIQD1.PreUni 
    FIELDS CanMat   LIKE PR-LIQCX.CanFin    
    FIELDS NumPed   LIKE PR-RQPROC.NroDoc.

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
     FILL-IN-fecha AT ROW 1.77 COL 19 COLON-ALIGNED
     FILL-IN-fecha-2 AT ROW 2.73 COL 19 COLON-ALIGNED
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
         TITLE              = "Liquidación de Ordenes de Producción"
         HEIGHT             = 6.12
         WIDTH              = 53.57
         MAX-HEIGHT         = 27.62
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.62
         VIRTUAL-WIDTH      = 146.29
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
ON END-ERROR OF W-Win /* Liquidación de Ordenes de Producción */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Liquidación de Ordenes de Producción */
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
    
    DEF VAR x-Item AS INT NO-UNDO.
    
    FOR EACH Reporte:
        DELETE Reporte.
    END.

    /* CABECERA  */
    FOR EACH PR-LIQC NO-LOCK WHERE 
        PR-LIQC.CODCIA = s-codcia AND 
        PR-LIQC.FCHLIQ >= FILL-IN-fecha AND
        PR-LIQC.FCHLIQ <= FILL-IN-fecha-2 AND
        PR-LIQC.FlgEst <> 'A',
        EACH PR-ODPC NO-LOCK WHERE
        PR-ODPC.CodCia = PR-LIQC.CodCia AND
        PR-ODPC.NumOrd = PR-LIQC.NumOrd   
        BREAK BY PR-LIQC.NumLiq:
        
        IF FIRST-OF(PR-LIQC.NumLiq)
        THEN x-Item = 1.
        CREATE Reporte.      
        ASSIGN
            Reporte.Item     = x-Item
            Reporte.NumLiq   = PR-LIQC.NumLiq
            Reporte.FchLiq   = PR-LIQC.FchLiq
            Reporte.NumOrd   = PR-LIQC.NumOrd
            Reporte.FchOrd   = PR-ODPC.FchOrd
          
       x-Item = x-Item + 1.
        DISPLAY
            Reporte.NumLiq @ Fi-Mensaje
            LABEL "  Cargando Liquidación" FORMAT "X(13)"
            WITH FRAME F-Proceso.
         
      END.  
       
  /*REQUERIMIENTOS DE MATERIAL*/ 

   FOR EACH Reporte-1:
        DELETE Reporte-1.
   END.
       
    FOR EACH PR-LIQC NO-LOCK WHERE 
        PR-LIQC.CODCIA = s-codcia AND 
        PR-LIQC.FCHLIQ >= FILL-IN-fecha AND
        PR-LIQC.FCHLIQ <= FILL-IN-fecha-2 AND
        PR-LIQC.FlgEst <> 'A', 
        EACH PR-LIQCX OF PR-LIQC NO-LOCK,
            FIRST PR-ODPC NO-LOCK WHERE
            PR-ODPC.NumOrd = PR-LIQC.NumOrd AND
            PR-ODPC.CodCia = PR-LIQC.CodCia,
            EACH PR-ODPCX OF PR-ODPC NO-LOCK WHERE
            PR-ODPCX.CodArt = PR-LIQCX.CodArt,
            EACH ALMMMATG NO-LOCK WHERE
            ALMMMATG.CodCia = PR-ODPC.CodCia AND
            ALMMMATG.CodMat = PR-ODPCX.CodArt:
            
        CREATE Reporte-1.
        ASSIGN
            Reporte-1.NumLiq = PR-LIQC.NumLiq
            Reporte-1.CenCon = PR-ODPC.CodPro
            Reporte-1.CodArt = PR-ODPCX.CodArt
            Reporte-1.DesArt = ALMMMATG.DesMat
            Reporte-1.UndMed = ALMMMATG.UndBas   
            Reporte-1.CanReq = PR-ODPCX.CanPed
            Reporte-1.CanPro = PR-LIQCX.CanFin.
    END.
        
    
    /*ASIGNAR VALORES*/
    FOR EACH Reporte-1 BREAK BY Reporte-1.NumLiq:
        IF FIRST-OF(Reporte-1.NumLiq)
        THEN x-Item = 1.
        FIND FIRST Reporte WHERE Reporte.NumLiq = Reporte-1.NumLiq
            AND Reporte.Item = x-Item
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Reporte THEN DO:
            CREATE Reporte.
            ASSIGN
                Reporte.NumLiq = Reporte-1.NumLiq
                Reporte.Item   = x-Item.
         END.
            ASSIGN
            Reporte.CenCon = Reporte-1.CenCon 
            Reporte.CodArt = Reporte-1.CodArt
            Reporte.DesArt = Reporte-1.DesArt
            Reporte.UndMed = Reporte-1.UndMed           
            Reporte.CanReq = Reporte-1.CanReq  
            Reporte.CanPro = Reporte-1.CanPro.
            
             x-Item = x-Item + 1.
                
        DISPLAY
            Reporte.NumLiq @ Fi-Mensaje
            LABEL "  Cargando Liquidación" FORMAT "X(13)"
            WITH FRAME F-Proceso.    
    END.
    
     /*MATERIALES PARA LA PRODUCCION*/ 

   FOR EACH Reporte-1:
        DELETE Reporte-1.
   END.
       
    FOR EACH PR-LIQC NO-LOCK WHERE 
        PR-LIQC.CODCIA = s-codcia AND 
        PR-LIQC.FCHLIQ >= FILL-IN-fecha AND
        PR-LIQC.FCHLIQ <= FILL-IN-fecha-2 AND
        PR-LIQC.FlgEst <> 'A', 
        EACH PR-LIQD1 OF PR-LIQC NO-LOCK,
            EACH ALMMMATG NO-LOCK WHERE
            ALMMMATG.CodCia = PR-LIQC.CODCIA AND
            ALMMMATG.CodMat = PR-LIQD1.CodMat:       
        CREATE Reporte-1.
        ASSIGN
            Reporte-1.NumLiq = PR-LIQC.NumLiq
            Reporte-1.CodMat = PR-LIQD1.CodMat
            Reporte-1.DesMat = ALMMMATG.DesMat
            Reporte-1.UndBas = ALMMMATG.UndBas
            Reporte-1.PrcUni = PR-LIQD1.PreUni
            Reporte-1.CanMat = PR-LIQD1.CanDes.
    END.
    
    /*ASIGNAR VALORES*/
    FOR EACH Reporte-1 BREAK BY Reporte-1.NumLiq:
        IF FIRST-OF(Reporte-1.NumLiq)
        THEN x-Item = 1.
        FIND FIRST Reporte WHERE Reporte.NumLiq = Reporte-1.NumLiq
            AND Reporte.Item = x-Item
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Reporte THEN DO:
            CREATE Reporte.
            ASSIGN
                Reporte.NumLiq = Reporte-1.NumLiq
                Reporte.Item   = x-Item.
         END.
            ASSIGN
                Reporte.CodMat = Reporte-1.CodMat
                Reporte.DesMat = Reporte-1.DesMat
                Reporte.UndBas = Reporte-1.UndBas
                Reporte.PrcUni = Reporte-1.PrcUni
                Reporte.CanMat = Reporte-1.CanMat.
                
             x-Item = x-Item + 1.
                
        DISPLAY
            Reporte.NumLiq @ Fi-Mensaje
            LABEL "  Cargando Liquidación" FORMAT "X(13)"
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
        Reporte.NumLiq   COLUMN-LABEL "Num!Liquida"     
        Reporte.FchLiq   COLUMN-LABEL "Fecha!Liquidac"
        Reporte.NumOrd   COLUMN-LABEL "Num!Orden"
        Reporte.FchOrd   COLUMN-LABEL "Fecha!Orden"
        Reporte.CenCon   COLUMN-LABEL "Centro!Convers"
        Reporte.CodArt   COLUMN-LABEL "Código!Articulo"
        Reporte.DesArt   COLUMN-LABEL "Descripción!Articulo"
        Reporte.UndMed   COLUMN-LABEL "Und!Med"
        Reporte.CanReq   COLUMN-LABEL "Cantidad!Requerida"  FORMAT "->>>,>>9.99"
        Reporte.CanPro   COLUMN-LABEL "Cantidad!Producida"  FORMAT "->>>,>>9.99"
        Reporte.CodMat   COLUMN-LABEL "Código!Material"
        Reporte.DesMat   COLUMN-LABEL "Descripción!Material"
        Reporte.UndBas   COLUMN-LABEL "Und!Bas"
        Reporte.CanMat   COLUMN-LABEL "Cantidad"            FORMAT "->>>,>>9.99"
        Reporte.PrcUni   COLUMN-LABEL "Precio!Unit."            FORMAT "->>>,>>9.9999"
        HEADER
        "REPORTE DE ORDENDES LIQUIDADAS" AT 30 SKIP(3)
        "DESDE EL" FILL-IN-Fecha "HASTA EL" FILL-IN-Fecha-2 SKIP(2)
        WITH STREAM-IO DOWN WIDTH 320.
        /* Te faltó poner  STREAM-IO DOWN ponlo please y me avisas */

    /*DEFINE FRAME F-HEADER
 *         HEADER
 *         SKIP (4)
 *         "REPORTE DE ORDENDES LIQUIDADAS" AT 30
 *         "Pag.  : " AT 70 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
 *         "Fecha : " AT 70 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
 *         "Hora  : " AT 70 STRING(TIME,"HH:MM:SS") SKIP
 *         "DESDE EL" FILL-IN-Fecha "HASTA EL" FILL-IN-Fecha-2 SKIP
 *         WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE.
 *     VIEW STREAM REPORT FRAME F-HEADER.*/
    
    FOR EACH Reporte NO-LOCK
        BREAK BY Reporte.NumLiq  
        BY Reporte.Item:
        DISPLAY STREAM REPORT      
            Reporte.NumLiq  WHEN FIRST-OF (Reporte.NumLiq)   
            Reporte.FchLiq  /*WHEN FIRST-OF (Reporte.NumLiq)*/   
            Reporte.NumOrd  /*WHEN FIRST-OF (Reporte.NumLiq) */  
            Reporte.FchOrd  /*WHEN FIRST-OF (Reporte.NumLiq)*/   
            Reporte.CenCon  /*WHEN FIRST-OF (Reporte.NumLiq)*/
            Reporte.CodArt  
            Reporte.DesArt
            Reporte.UndMed
            Reporte.CanReq  WHEN Reporte.CanReq <> 0
            Reporte.CanPro  WHEN Reporte.CanPro <> 0
            Reporte.CodMat
            Reporte.DesMat
            Reporte.UndBas
            Reporte.PrcUni  
            Reporte.CanMat  
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
        RETURN-TO-START-DIR
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


