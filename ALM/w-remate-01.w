&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER CMOV FOR Almcmov.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE Almmmate.
DEFINE TEMP-TABLE ITEM LIKE Almdmov.
DEFINE TEMP-TABLE T-CMOV LIKE Almcmov.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-AlmDes AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Detalle Almmmatg

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 Detalle.CodAlm Detalle.codmat ~
Almmmatg.DesMat Almmmatg.UndStk Detalle.StkAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH Detalle NO-LOCK, ~
      EACH Almmmatg OF Detalle NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH Detalle NO-LOCK, ~
      EACH Almmmatg OF Detalle NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 Detalle Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 Detalle
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 Almmmatg


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-AlmDes BUTTON-1 BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-AlmDes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "IMPORTAR EXCEL" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GENERAR TRANSFERENCIA" 
     SIZE 28 BY 1.12.

DEFINE VARIABLE COMBO-BOX-AlmDes AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un almacén" 
     LABEL "Almacén de Remate" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Seleccione un almacén" 
     DROP-DOWN-LIST
     SIZE 70 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      Detalle, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 wWin _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      Detalle.CodAlm COLUMN-LABEL "Almacén!Origen" FORMAT "x(3)":U
      Detalle.codmat COLUMN-LABEL "Producto" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 57.43
      Almmmatg.UndStk COLUMN-LABEL "Unidad!Stock" FORMAT "X(4)":U
      Detalle.StkAct COLUMN-LABEL "Cantidad" FORMAT "ZZZ,ZZZ,ZZ9.99":U
            WIDTH 12.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 96 BY 11.85 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-AlmDes AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 2.88 COL 5 WIDGET-ID 4
     BUTTON-2 AT ROW 2.88 COL 25 WIDGET-ID 6
     BROWSE-3 AT ROW 4.23 COL 5 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 102.72 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: CMOV B "?" ? INTEGRAL Almcmov
      TABLE: Detalle T "?" NO-UNDO INTEGRAL Almmmate
      TABLE: ITEM T "?" ? INTEGRAL Almdmov
      TABLE: T-CMOV T "?" ? INTEGRAL Almcmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "CARGA AUTOMATICA DE LOS ALMACENES DE REMATE"
         HEIGHT             = 17
         WIDTH              = 102.72
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 BUTTON-2 fMain */
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.Detalle,INTEGRAL.Almmmatg OF Temp-Tables.Detalle"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.Detalle.CodAlm
"Detalle.CodAlm" "Almacén!Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.Detalle.codmat
"Detalle.codmat" "Producto" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "57.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad!Stock" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.Detalle.StkAct
"Detalle.StkAct" "Cantidad" "ZZZ,ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CARGA AUTOMATICA DE LOS ALMACENES DE REMATE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CARGA AUTOMATICA DE LOS ALMACENES DE REMATE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* IMPORTAR EXCEL */
DO:
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* GENERAR TRANSFERENCIA */
DO:
  RUN Generar-Transferencia.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-AlmDes wWin
ON VALUE-CHANGED OF COMBO-BOX-AlmDes IN FRAME fMain /* Almacén de Remate */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Cab AS CHAR NO-UNDO.
    DEF VAR x-Linea AS CHAR FORMAT 'x(100)'.
    DEF VAR Rpta AS LOG NO-UNDO.
    DEF VAR DiasTrabajados AS INTEGER NO-UNDO.

    /* SOLICITAMOS ARCHIVO */
    SYSTEM-DIALOG GET-FILE x-Cab 
        FILTERS 'Excel (*.xls)' '*.xls' INITIAL-FILTER 1
        RETURN-TO-START-DIR 
        TITLE 'Carga del almacén de Remate'
        UPDATE Rpta.
    IF Rpta = NO THEN RETURN.

    EMPTY TEMP-TABLE Detalle.

    /*  ********************************* EXCEL ***************************** */
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
    DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
    DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.

    chWorkbook = chExcelApplication:Workbooks:OPEN(x-Cab).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    /* EL FORMATO DEBE TENER 3 COLUMNAS
        ALMACEN ORIGEN     CODIGO DE ARTICULO      CANTIDAD
    */
    iCountLine = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        iCountLine = iCountLine + 1.
        cRange = "A" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
        /* ALMACEN ORIGEN */
        cRange = "A" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = cValue
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen THEN DO:
            ASSIGN
                cValue = STRING(INTEGER(cValue), '99')
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                ASSIGN
                    cValue = STRING(cValue, 'x(3)').
            END.
            FIND Almacen WHERE Almacen.codcia = s-codcia
                AND Almacen.codalm = cValue
                NO-LOCK NO-ERROR.
        END.
        IF NOT AVAILABLE Almacen THEN DO:
            MESSAGE 'Valor del almacén no registrado:' cValue VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        CREATE Detalle.
        ASSIGN
            Detalle.CodCia = s-codcia
            Detalle.CodAlm = cValue.
        /* PRODUCTO */
        cRange = "B" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            Detalle.CodMat = STRING(INTEGER(cValue), '999999')
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor del producto no reconocido:' cValue SKIP VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = Detalle.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN DO:
            MESSAGE 'Producto' Detalle.codmat 'no registrado' VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
        /* CANTIDAD */
        cRange = "C" + TRIM(STRING(iCountLine)).
        cValue = chWorkSheet:Range(cRange):VALUE.
        ASSIGN
            Detalle.StkAct = DECIMAL (cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Valor de la cantidad no reconocido:' cValue VIEW-AS ALERT-BOX ERROR.
            NEXT.
        END.
    END.
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 
    /* ********************************************************************** */
    /* CONSISTENCIA */
    FOR EACH Detalle:
        FIND Almacen OF Detalle NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen THEN DO:
            DELETE Detalle.
            NEXT.
        END.
        FIND Almmmatg OF Detalle NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN DO:
            DELETE Detalle.
            NEXT.
        END.
    END.
    FIND FIRST DETALLE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN DO:
        MESSAGE 'Error en el archivo EXCEL' SKIP
            'Haga una copia del archivo y vuelva a intentarlo'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}

    ASSIGN
        button-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO
        button-2:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-AlmDes 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-AlmDes BUTTON-1 BROWSE-3 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Transferencia wWin 
PROCEDURE Generar-Transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Valida.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.


DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN Transferencia-Salida.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RUN Transferencia-Ingreso.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(Almacen)  THEN RELEASE Almacen.
IF AVAILABLE(Almdmov)  THEN RELEASE Almdmov.
IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.

FOR EACH Detalle:
    DELETE Detalle.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}
ASSIGN
    BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    BUTTON-2:SENSITIVE IN FRAME {&FRAME-NAME} = NO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDataObjects wWin 
PROCEDURE initializeDataObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER plDeep AS LOGICAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT plDeep).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Almacen NO-LOCK WHERE codcia = s-codcia
          AND Campo-c[3] = "Si":
          COMBO-BOX-AlmDes:ADD-LAST(Almacen.codalm + ' - ' + Almacen.Descripcion).
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferencia-Ingreso wWin 
PROCEDURE Transferencia-Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR r-Rowid AS ROWID NO-UNDO.

FOR EACH T-CMOV TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND Almtdocm WHERE Almtdocm.CodCia = S-CODCIA 
        AND Almtdocm.CodAlm = s-AlmDes
        AND Almtdocm.TipMov = "I" 
        AND Almtdocm.CodMov = 03
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'No se pudo bloquear el correlativo de ingreso por tansferencia' SKIP
            'Almacén:' s-almdes
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = T-CMOV.codalm
        NO-LOCK.
    CREATE Almcmov.
    ASSIGN 
        Almcmov.usuario = S-USER-ID
        Almcmov.NroDoc  = Almtdocm.NroDoc
        Almtdocm.NroDoc = Almtdocm.NroDoc + 1
        Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.CodAlm  = Almtdocm.CodAlm 
        Almcmov.TipMov  = Almtdocm.TipMov 
        Almcmov.CodMov  = Almtdocm.CodMov 
        Almcmov.NroSer  = 000
        Almcmov.FlgSit  = ""
        Almcmov.FchDoc  = TODAY
        Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        Almcmov.NomRef  = Almacen.Descripcion
        Almcmov.AlmDes  = T-CMOV.CodAlm
        Almcmov.NroRf1  = STRING(T-CMOV.NroSer,"999") + STRING(T-CMOV.NroDoc,"999999").

    FOR EACH ITEM OF T-CMOV:
        CREATE almdmov.
        ASSIGN Almdmov.CodCia = Almcmov.CodCia 
               Almdmov.CodAlm = Almcmov.CodAlm 
               Almdmov.TipMov = Almcmov.TipMov 
               Almdmov.CodMov = Almcmov.CodMov 
               Almdmov.NroSer = Almcmov.NroSer 
               Almdmov.NroDoc = Almcmov.NroDoc 
               Almdmov.CodMon = Almcmov.CodMon 
               Almdmov.FchDoc = Almcmov.FchDoc 
               Almdmov.TpoCmb = Almcmov.TpoCmb 
               Almdmov.codmat = ITEM.codmat 
               Almdmov.CanDes = ITEM.CanDes 
               Almdmov.CodUnd = ITEM.CodUnd 
               Almdmov.Factor = ITEM.Factor 
               Almdmov.ImpCto = ITEM.ImpCto 
               Almdmov.PreUni = ITEM.PreUni 
               Almdmov.AlmOri = Almcmov.AlmDes 
               Almdmov.CodAjt = '' 
               Almdmov.HraDoc = Almcmov.HorRcp
                      R-ROWID = ROWID(Almdmov).

        RUN ALM\ALMACSTK (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        RUN alm/almacpr1 (R-ROWID, 'U').
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    END.

    FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
        AND  CMOV.CodAlm = Almcmov.AlmDes 
        AND  CMOV.TipMov = "S" 
        AND  CMOV.CodMov = 03
        AND  CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
        AND  CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4,6)) 
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    IF CMOV.FlgSit <> "T" THEN DO:
        MESSAGE 'NO se puede hacer la transferencia' SKIP
            'La guia ha sido alterada' SKIP
            'Revisar el documento original en el sistema'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
    ASSIGN 
        CMOV.FlgSit  = "R" 
        CMOV.HorRcp  = STRING(TIME,"HH:MM:SS")
        CMOV.NroRf2  = STRING(Almcmov.NroDoc, "999999").
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferencia-Salida wWin 
PROCEDURE Transferencia-Salida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NroDoc LIKE Almcmov.nrodoc INIT 0 NO-UNDO.
DEF VAR s-NroSer AS INT INIT 000 NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR r-Rowid AS ROWID NO-UNDO.

FIND Almacen WHERE Almacen.CodCia = s-CodCia 
    AND Almacen.CodAlm = s-AlmDes NO-LOCK.

EMPTY TEMP-TABLE T-CMOV.
EMPTY TEMP-TABLE ITEM.

FOR EACH detalle BREAK BY detalle.codalm TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR'
    ON STOP UNDO, RETURN 'ADM-ERROR':
    IF FIRST-OF(detalle.codalm) THEN DO:
        /* Buscamos el correlativo de almacenes */
        FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
            AND Almacen.CodAlm = detalle.CodAlm 
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen THEN DO: 
            MESSAGE 'NO se pudo bloquer el correlativo por almacen' VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN 
            x-Nrodoc  = Almacen.CorrSal
            Almacen.CorrSal = Almacen.CorrSal + 1.
        CREATE Almcmov.
        ASSIGN 
            Almcmov.CodCia = s-CodCia 
            Almcmov.CodAlm = detalle.CodAlm 
            Almcmov.AlmDes = s-AlmDes
            Almcmov.TipMov = "S"
            Almcmov.CodMov = 03
            Almcmov.FlgSit = "T"      /* Transferido pero no Recepcionado */
            Almcmov.NroSer = s-nroser
            Almcmov.NroDoc = x-NroDoc
            Almcmov.FchDoc = TODAY
            Almcmov.HorSal = STRING(TIME,"HH:MM")
            Almcmov.HraDoc = STRING(TIME,"HH:MM")
            Almcmov.NomRef = Almacen.Descripcion
            Almcmov.usuario = S-USER-ID
            x-Item = 1.
        CREATE T-CMOV.
        BUFFER-COPY Almcmov TO T-CMOV.
    END.
    CREATE almdmov.
    ASSIGN 
        Almdmov.CodCia = Almcmov.CodCia 
        Almdmov.CodAlm = Almcmov.CodAlm 
        Almdmov.TipMov = Almcmov.TipMov 
        Almdmov.CodMov = Almcmov.CodMov 
        Almdmov.NroSer = Almcmov.NroSer
        Almdmov.NroDoc = Almcmov.NroDoc 
        Almdmov.CodMon = Almcmov.CodMon 
        Almdmov.FchDoc = Almcmov.FchDoc 
        Almdmov.HraDoc = Almcmov.HraDoc
        Almdmov.TpoCmb = Almcmov.TpoCmb
        Almdmov.codmat = detalle.codmat
        Almdmov.CanDes = detalle.stkact
        Almdmov.CodUnd = almmmatg.UndStk
        Almdmov.Factor = 1
        Almdmov.ImpCto = 0
        Almdmov.PreUni = 0
        Almdmov.AlmOri = Almcmov.AlmDes 
        Almdmov.CodAjt = ''
        Almdmov.HraDoc = Almcmov.HorSal
        Almdmov.NroItm = x-Item
        R-ROWID = ROWID(Almdmov)
        x-Item = x-Item + 1.
    CREATE ITEM.
    BUFFER-COPY Almdmov TO ITEM.
    RUN alm/almdcstk (R-ROWID).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN alm/almacpr1 (R-ROWID, "U").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida wWin 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pComprometido AS DEC NO-UNDO.

IF COMBO-BOX-AlmDes BEGINS 'Selecc' THEN DO:
    MESSAGE 'Seleccione un almacén de Remate' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
s-AlmDes = ENTRY(1, COMBO-BOX-AlmDes, ' - ').

FOR EACH Detalle:
    FIND almmmate WHERE almmmate.codcia = s-codcia
        AND Almmmate.codalm = s-almdes
        AND almmmate.codmat = detalle.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        MESSAGE 'Código' detalle.codmat 'NO asignado al almacén' s-almdes VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    FIND almmmate WHERE almmmate.codcia = s-codcia
        AND Almmmate.codalm = detalle.codalm
        AND almmmate.codmat = detalle.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        MESSAGE 'Código NO asignado al almacén' detalle.codalm VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    RUN vtagn/stock-comprometido (Almmmate.codmat, Almmmate.codalm, OUTPUT pComprometido).
    IF detalle.stkact > (Almmmate.stkact - pComprometido)
        THEN DO:
        MESSAGE 'NO se puede transferir mas de' (Almmmate.stkact - pComprometido) SKIP
            'para el producto' detalle.codmat SKIP
            'del almacén' detalle.codalm
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

