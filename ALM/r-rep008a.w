&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF VAR p        AS LOGICAL.
DEF VAR q        AS LOGICAL.
DEF VAR f-precio AS DECIMAL.

DEF BUFFER b-almdmov FOR almdmov.

DEF VAR PR-CODCIA AS INT NO-UNDO.
DEF VAR FILL-IN-CodMat AS CHAR INIT '' NO-UNDO.
DEF VAR FILL-IN-CodPro AS CHAR INIT '' NO-UNDO.

FIND FIRST EMPRESAS WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN PR-CODCIA = S-CODCIA.

DEFINE TEMP-TABLE Reporte  
    FIELDS CodAlm   LIKE Almdmov.CodAlm
    FIELDS CodMov   LIKE Almdmov.CodMov
    FIELDS NroMov   AS CHAR FORMAT "X(20)"
    FIELDS FchMov   LIKE Almdmov.FchDoc
    FIELDS Usuario  LIKE Almcmov.usuario
    FIELDS Estado   LIKE Almcmov.FlgEst    
    FIELDS NroRe1   LIKE Almcmov.NroRf1
    FIELDS NroRe2   LIKE Almcmov.NroRf2
    FIELDS NroRe3   LIKE Almcmov.NroRf2
    FIELDS AlmDes   LIKE Almcmov.AlmDes
    FIELDS CodMat   LIKE Almmmatg.CodMat
    FIELDS DesMat   LIKE Almmmatg.DesMat
    FIELDS UndBas   LIKE Almdmov.CodUnd
    FIELDS DesMar   LIKE Almmmatg.DesMar FORMAT "x(20)"
    FIELDS CodPro   LIKE Almcmov.CodPro
    FIELDS DesPro   LIKE Gn-Prov.Nombre
    FIELDS CanMat   LIKE Almdmov.CanDes
    FIELDS CosUni   AS DECIMAL FORMAT "->,>>>,>>9.9999"
    FIELDS CosTot   AS DECIMAL FORMAT "->>>,>>>,>>9.9999"
    FIELDS NueCos   LIKE Almdmov.VctoMn1
    FIELDS CatConta AS CHAR FORMAT 'x(3)'
    FIELDS NumLiq   AS CHAR
    FIELDS Observ LIKE almcmov.observ
    FIELDS Cco LIKE Almcmov.Cco
    FIELDS CodPr1 LIKE Almmmatg.CodPr1
    FIELDS CodPr2 LIKE Almmmatg.CodPr2
    FIELDS Moneda AS CHAR FORMAT 'x(3)'
    FIELDS TpoCmb LIKE Almdmov.TpoCmb
    FIELDS OrdDsp AS CHAR FORMAT 'x(20)'
    FIELDS GRemi  AS CHAR FORMAT 'x(20)'
    .


DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .
DEF VAR x-tipmov  AS CHAR FORMAT 'X(50)' NO-UNDO.

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
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-57 COMBO-BOX-almacen DesdeF HastaF ~
C-CodMov C-TipMov Btn_OK btn-excel Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-almacen DesdeF HastaF C-CodMov ~
C-TipMov x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-excel 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 6" 
     SIZE 11 BY 1.5.

DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5 TOOLTIP "Imprimir"
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-almacen AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacén" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE C-CodMov AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Codigo Movimiento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57.14 BY .81 NO-UNDO.

DEFINE VARIABLE C-TipMov AS CHARACTER INITIAL "I" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ingresos", "I",
"Salidas", "S"
     SIZE 13.29 BY 1.81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 63 BY 1.77
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62.57 BY 7.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-almacen AT ROW 1.81 COL 19 COLON-ALIGNED
     DesdeF AT ROW 2.88 COL 19 COLON-ALIGNED
     HastaF AT ROW 2.88 COL 36 COLON-ALIGNED
     C-CodMov AT ROW 3.96 COL 19 COLON-ALIGNED
     C-TipMov AT ROW 5.04 COL 21 NO-LABEL
     x-mensaje AT ROW 7.35 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     Btn_OK AT ROW 8.65 COL 28.72
     btn-excel AT ROW 8.65 COL 40 WIDGET-ID 2
     Btn_Cancel AT ROW 8.65 COL 51.29
     "Mov. 88 para todos los movimientos" VIEW-AS TEXT
          SIZE 30 BY .65 AT ROW 4.04 COL 28 WIDGET-ID 4
          FONT 6
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1 COL 6.43
          FONT 6
     "Tipo de Movimiento" VIEW-AS TEXT
          SIZE 13.72 BY .5 AT ROW 5.19 COL 6.86
     RECT-57 AT ROW 1.19 COL 1.43
     RECT-46 AT ROW 8.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63.72 BY 9.46
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
         TITLE              = "Reporte de Entrada o Salida de Material"
         HEIGHT             = 9.46
         WIDTH              = 63.72
         MAX-HEIGHT         = 9.46
         MAX-WIDTH          = 63.72
         VIRTUAL-HEIGHT     = 9.46
         VIRTUAL-WIDTH      = 63.72
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
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Reporte de Entrada o Salida de Material */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Entrada o Salida de Material */
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
  /*
  IF C-CodMov = 00 THEN DO:
      MESSAGE "Ingrese Movimiento Valido" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  */
  IF COMBO-BOX-almacen:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Todos" 
      THEN RUN Carga-Temporal2.
  ELSE RUN Carga-Temporal.

  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:

    RUN Asigna-Variables.
    /*
    IF C-CodMov = 00 THEN DO:
        MESSAGE "Ingrese Movimiento Valido" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    */
    FIND FIRST Almtmovm WHERE Almtmovm.CodCia = s-codcia
        AND Almtmovm.Tipmov = c-tipmov
        AND Almtmovm.CodMov = INT(STRING(c-codmov,'99')) NO-LOCK NO-ERROR.
    IF AVAIL Almtmovm THEN x-tipmov = Almtmovm.Desmov. 

    RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-TipMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-TipMov W-Win
ON VALUE-CHANGED OF C-TipMov IN FRAME F-Main
DO:
   
 
  /* for each Almtmovm no-lock where Almtmovm.CodCia = s-codcia and
 *         Almtmovm.TipMov = C-TipMov.
 *         if COMBO-BOX-Mov:list-items = " " then 
 *        q = COMBO-BOX-Mov:add-last(STRING(Almtmovm.CodMov)).
 *     end.*/
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
    ASSIGN  
        COMBO-BOX-almacen
        DesdeF 
        HastaF 
        c-tipmov
        C-CodMov.
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000. 
  
END.

    



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

    DEF VAR x-Tipo AS CHAR.
    DEF VAR x-NroDoc AS CHARACTER.
    DEF VAR x-Valor AS DEC.

    x-Tipo = C-TipMov:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    FOR EACH Reporte:
        DELETE Reporte.
    END.

    FOR EACH Almacen NO-LOCK WHERE
        Almacen.CodCia = s-codcia AND
        Almacen.CodAlm = combo-box-almacen: 
        {APLIC/ALM/i-AlmEntradaSalida.i}
        DISPLAY "CARGANDO INFORMACION PARA ALMACEN " + Almacen.CodAlm
            @ x-mensaje  WITH FRAME {&FRAME-NAME}.
    END. 

    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal2 W-Win 
PROCEDURE Carga-Temporal2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Tipo AS CHAR.
    DEF VAR x-NroDoc AS CHARACTER.
    DEF VAR x-Valor AS DEC.

    x-Tipo = C-TipMov:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        
    FOR EACH Reporte:
        DELETE Reporte.
    END.

    FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = s-codcia: 
        IF Almacen.FlgRep = NO THEN NEXT.
        IF Almacen.AlmCsg = YES THEN NEXT.
        {APLIC/ALM/i-AlmEntradaSalida.i}

        DISPLAY "CARGANDO INFORMACION PARA ALMACEN " + Almacen.CodAlm
            @ x-mensaje  WITH FRAME {&FRAME-NAME}.
    END.

    HIDE FRAME F-PROCESO.

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
  DISPLAY COMBO-BOX-almacen DesdeF HastaF C-CodMov C-TipMov x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 COMBO-BOX-almacen DesdeF HastaF C-CodMov C-TipMov Btn_OK 
         btn-excel Btn_Cancel 
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

    DEF VAR cNomProv LIKE Gn-Prov.Nombre NO-UNDO.
    DEF VAR x-totales AS DECIMAL FORMAT "(>>,>>>,>>>,>>9.9999)".    
    DEF VAR x-cantidades    AS DECIMAL FORMAT "(>>,>>>,>>>,>>9.9999)".

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /*Formato de Celda*/
    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("S"):NumberFormat = "@".

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE ENTRADA O SALIDA DE MATERIAL".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Desde: ".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = DesdeF.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Hasta: ".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = HastaF.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "MOVIMIENTO:".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = x-tipmov.

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Alm".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod Mov".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nº Mov".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fch. Mov.".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Usuario".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Est. Mat".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Referencia1".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Referencia2".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Alm. Destino".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod Material".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripción".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Und. Base".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
/*RD01****    
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Proveedor".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nombre Proveedor".  
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cantidad".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Promedio".
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = "Categoria Contable".
    iCount = iCount + 1.
*********/  


    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cantidad".
/*RD01 ***
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Total".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Costo Promedio".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Categoria Contable".
    IF c-TipMov = "I" AND c-CodMov = 50 THEN DO:
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = "Num. Liq".
    END.
*****/    

    iCount = iCount + 1.

  FOR EACH Reporte NO-LOCK BREAK BY Reporte.CodAlm
      BY Reporte.CodMov:
      cNomProv = "".
      IF Reporte.CodPro <> "" THEN DO:
          FIND FIRST GN-PROV WHERE
              Gn-Prov.CodCia = pv-codcia AND
              Gn-Prov.CodPro = Reporte.CodPro
              NO-LOCK NO-ERROR.
          IF AVAILABLE GN-PROV THEN cNomProv = Gn-Prov.NomPro.
      END.
        
      Reporte.CosTot = (Reporte.CanMat * Reporte.CosUni).
      x-cantidades = x-cantidades + Reporte.CanMat.
      cColumn = STRING(iCount).
      cRange = "A" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CodAlm.
      cRange = "B" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CodMov.
      cRange = "C" + cColumn.
      chWorkSheet:Range(cRange):Value = "'" + Reporte.NroMov.
      cRange = "D" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.FchMov.
      cRange = "E" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.Usuario.
      cRange = "F" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.Estado.
      cRange = "G" + cColumn.
      chWorkSheet:Range(cRange):Value = "'" + Reporte.NroRe1.
      cRange = "H" + cColumn.
      chWorkSheet:Range(cRange):Value = "'" + Reporte.NroRe2.
      cRange = "I" + cColumn.
      chWorkSheet:Range(cRange):Value = "'" + Reporte.AlmDes.
      cRange = "J" + cColumn.
      chWorkSheet:Range(cRange):Value = "'" + Reporte.CodMat.
      cRange = "K" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.DesMat.
      cRange = "L" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.UndBas.
      cRange = "M" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.DesMar.
/*RD01****************
      cRange = "N" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CodPro.
      cRange = "O" + cColumn.
      chWorkSheet:Range(cRange):Value = cNomProv.
      cRange = "P" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CanMat.
      cRange = "Q" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CosUni.
      cRange = "R" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.NueCos.
      cRange = "S" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CatConta.
      iCount = iCount + 1.
***********************/

      cRange = "N" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CanMat.
/*RD01******
      cRange = "O" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CosUni.
      cRange = "P" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CosTot.
      cRange = "Q" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.NueCos.
      cRange = "R" + cColumn.
      chWorkSheet:Range(cRange):Value = Reporte.CatConta.

      IF c-TipMov = "I" AND c-CodMov = 50 THEN DO:
          cRange = "S" + cColumn.
          chWorkSheet:Range(cRange):Value = Reporte.NumLiq.
      END.
*********/      
      iCount = iCount + 1.
      IF (Reporte.CosTot <> ?) THEN x-totales = x-totales + Reporte.CosTot.

      DISPLAY "CARGANDO EXCEL ... " @ x-mensaje  WITH FRAME {&FRAME-NAME}.

    END.

/*RD01 *******
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTALES: ".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL: ".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = x-totales.
*******************/
    DISPLAY " " @ x-mensaje  WITH FRAME {&FRAME-NAME}.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
  Modifico  :   Rosa Diaz P. RDP01
  Fecha     :   04/12/2009
  Motivo    :   Cambio de campos en la impresión
------------------------------------------------------------------------------*/

    DEF VAR cNomProv        LIKE Gn-Prov.Nombre NO-UNDO.
    DEF VAR x-totales       AS DECIMAL FORMAT "(>>,>>>,>>>,>>9.9999)". 
    DEF VAR x-cantidades    AS DECIMAL FORMAT "(>>,>>>,>>>,>>9.9999)".

    DEFINE FRAME F-REPORTE
                Reporte.CodAlm   COLUMN-LABEL "Alm."
                Reporte.CodMov   COLUMN-LABEL "Código!Movim."
                Reporte.NroMov   COLUMN-LABEL "Número!Movim."
                Reporte.FchMov   COLUMN-LABEL "Fech!Movim."
                Reporte.Usuario  COLUMN-LABEL "Usuario"
                Reporte.Estado   COLUMN-LABEL "Estado!Material"
                Reporte.NroRe1   COLUMN-LABEL "Referencia1"
                Reporte.NroRe2   COLUMN-LABEL "Referencia2"
                Reporte.AlmDes   COLUMN-LABEL "Almacén!Destino"
                Reporte.CodMat   COLUMN-LABEL "Código!Material"
                Reporte.DesMat   COLUMN-LABEL "Descripción"
                Reporte.UndBas   COLUMN-LABEL "Unidad!Base"
                Reporte.DesMar   COLUMN-LABEL "Descripción!Marca"                
/*RD01*****
                Reporte.CodPro   COLUMN-LABEL "Código!Prov."
                cNomProv         COLUMN-LABEL "Nombre Proveedor"
**********/                
                Reporte.CanMat   COLUMN-LABEL "Cantidad" 
/*RD01****
                Reporte.CosUni   COLUMN-LABEL "Costo"
**********/                
                Reporte.CosUni   COLUMN-LABEL "Costo Promedio"
                Reporte.CosTot   COLUMN-LABEL "Costo Total"
                Reporte.NueCos   COLUMN-LABEL "Nuevo!Costo"
                Reporte.CatConta COLUMN-LABEL "Cat!Conta"
                Reporte.NumLiq   COLUMN-LABEL "Num!Liqui"
        HEADER
        "REPORTE DE ENTRADA O SALIDA DE MATERIAL" AT 50 SKIP(2)
        "DESDE EL" DesdeF "HASTA EL" HastaF SKIP
        "MOVIMIENTO: " x-tipmov SKIP(2)
        WITH STREAM-IO NO-BOX DOWN WIDTH 320.

    
    FOR EACH Reporte NO-LOCK
        BREAK BY Reporte.CodAlm
        BY Reporte.CodMov:

        cNomProv = "".
        IF Reporte.CodPro <> "" THEN DO:
            FIND GN-PROV WHERE
                Gn-Prov.CodCia = pv-codcia AND
                Gn-Prov.CodPro = Reporte.CodPro
                NO-LOCK NO-ERROR.
            IF AVAILABLE GN-PROV THEN
                cNomProv = Gn-Prov.NomPro.
        END.
        Reporte.CosTot = (Reporte.CanMat * Reporte.CosUni).

        DISPLAY STREAM REPORT      
                Reporte.CodAlm  WHEN FIRST-OF (Reporte.CodAlm)   
                Reporte.CodMov   
                Reporte.NroMov  
                Reporte.FchMov   
                Reporte.Usuario  
                Reporte.Estado   
                Reporte.NroRe1   
                Reporte.NroRe2   
                Reporte.AlmDes
                Reporte.CodMat
                Reporte.DesMat
                Reporte.UndBas
                Reporte.DesMar
/*RD01****
                Reporte.CodPro
                cNomProv
**********/                
                Reporte.CanMat
                Reporte.CosUni 
                Reporte.CosTot
                Reporte.NueCos
                Reporte.CatConta
                Reporte.NumLiq
            WITH FRAME F-REPORTE.
            IF (Reporte.CosTot <> ?) THEN x-totales = x-totales + Reporte.CosTot.
            x-cantidades = x-cantidades + Reporte.CanMat.

            DISPLAY "CARGANDO INFORMACION " @ x-mensaje  
                WITH FRAME {&FRAME-NAME}.

    END.
    PUT STREAM REPORT 'TOTALES: '   AT 160.
    PUT STREAM REPORT x-cantidades  AT 179.
    PUT STREAM REPORT x-totales     AT 212.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
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
    
    IF COMBO-BOX-almacen:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Todos"
        THEN RUN Carga-Temporal2.
        ELSE RUN Carga-Temporal.
    
    IF not Can-find (First Reporte) then do:
        message "No hay registros a imprimir" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    
    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) /*PAGED PAGE-SIZE 62*/ .
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
        RUN Formato.
        PAGE STREAM report.
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
        ASSIGN
            DesdeF = DATE(MONTH(TODAY),1,YEAR(TODAY))
            HastaF = TODAY.
    END.
    COMBO-BOX-almacen:list-items = "Todos".
    for each almacen NO-LOCK:
        IF Almacen.FlgRep = NO THEN NEXT.
        IF Almacen.AlmCsg = YES THEN NEXT.
       p = COMBO-BOX-almacen:add-last(almacen.codalm).
    end.
    
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
        WHEN "c-CodMov" THEN 
            ASSIGN
                input-var-1 = c-TipMov:SCREEN-VALUE IN FRAME {&FRAME-NAME}
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

