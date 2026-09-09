&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
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

DEF VAR x-CodFam LIKE Almtfam.codfam  NO-UNDO.
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-desalm AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.

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
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almtfami

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 Almtfami.codfam Almtfami.desfam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH Almtfami ~
      WHERE Almtfami.CodCia = 1 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH Almtfami ~
      WHERE Almtfami.CodCia = 1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 Almtfami
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 Almtfami


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BROWSE-4 ChkBaja optGrpCuales ~
optgrpStock BtnExcel txtCodMat BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS txtAlmacen ChkBaja optGrpCuales ~
optgrpStock txtPesoVol txtCodMat TxtDescripcion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnExcel 
     LABEL "Generar Excel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-1 
     LABEL "Peso y Vol." 
     SIZE 13 BY .88.

DEFINE VARIABLE txtAlmacen AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtCodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY 1 NO-UNDO.

DEFINE VARIABLE TxtDescripcion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtPesoVol AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1
     FGCOLOR 4 FONT 10 NO-UNDO.

DEFINE VARIABLE optGrpCuales AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos los articulos", 1,
"Solo con pesos y/o volumenes", 2,
"Que no tienen pesos y/o volumenes", 3
     SIZE 37 BY 2.15 NO-UNDO.

DEFINE VARIABLE optgrpStock AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"Con Stock", 2,
"Sin Stock", 3
     SIZE 15 BY 2.35 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 2.5.

DEFINE VARIABLE ChkBaja AS LOGICAL INITIAL no 
     LABEL "Excluir Articulos de BAJA" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      Almtfami SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 wWin _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      Almtfami.codfam FORMAT "X(3)":U WIDTH 8.43
      Almtfami.desfam FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 44 BY 11.65 ROW-HEIGHT-CHARS .65 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BROWSE-4 AT ROW 1.46 COL 3 WIDGET-ID 200
     txtAlmacen AT ROW 1.58 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     ChkBaja AT ROW 3.5 COL 49 WIDGET-ID 2
     optGrpCuales AT ROW 5.19 COL 49 NO-LABEL WIDGET-ID 10
     optgrpStock AT ROW 8.27 COL 58 NO-LABEL WIDGET-ID 14
     BtnExcel AT ROW 11.42 COL 57.86 WIDGET-ID 6
     txtPesoVol AT ROW 14.88 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     txtCodMat AT ROW 14.92 COL 9.29 COLON-ALIGNED WIDGET-ID 22
     TxtDescripcion AT ROW 15.96 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     BUTTON-1 AT ROW 16.08 COL 10.43 WIDGET-ID 30
     "Se considera los articulos que tenga peso y/o volumen, salvo que elija TODOS" VIEW-AS TEXT
          SIZE 71 BY .96 AT ROW 13.31 COL 3 WIDGET-ID 8
     RECT-1 AT ROW 14.65 COL 1.14 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.72 BY 16.27 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Listado de Pesos y Volumenes"
         HEIGHT             = 16.27
         WIDTH              = 89.72
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
/* BROWSE-TAB BROWSE-4 RECT-1 fMain */
/* SETTINGS FOR FILL-IN txtAlmacen IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN TxtDescripcion IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtPesoVol IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.Almtfami"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "INTEGRAL.Almtfami.CodCia = 1"
     _FldNameList[1]   > INTEGRAL.Almtfami.codfam
"Almtfami.codfam" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almtfami.desfam
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Listado de Pesos y Volumenes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Listado de Pesos y Volumenes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnExcel wWin
ON CHOOSE OF BtnExcel IN FRAME fMain /* Generar Excel */
DO:

  ASSIGN optgrpStock.

  RUN um_genexcel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Peso y Vol. */
DO:
  ASSIGN txtCodmat.

  RUN ue-peso-vol.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodMat wWin
ON LEAVE OF txtCodMat IN FRAME fMain /* Articulo */
DO:
  ASSIGN txtCodmat.

  RUN ue-peso-vol.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
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
  DISPLAY txtAlmacen ChkBaja optGrpCuales optgrpStock txtPesoVol txtCodMat 
          TxtDescripcion 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-1 BROWSE-4 ChkBaja optGrpCuales optgrpStock BtnExcel txtCodMat 
         BUTTON-1 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  txtAlmacen:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "ALMACEN :" + s-codalm + " " + s-desalm.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-peso-vol wWin 
PROCEDURE ue-peso-vol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

txtDescripcion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "<* Articulo NO EXISTE *>".
txtPesoVol:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                    almmmatg.codmat = txtCodMat
                    NO-LOCK NO-ERROR.

IF AVAILABLE almmmatg THEN DO:
    txtDescripcion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almmmatg.desmat.
    txtPesoVol:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        "PESO :" + STRING(almmmatg.pesmat,"->>,>>>,>>9.99999") + "   " +
        "VOLUMEN :" + STRING(almmmatg.libre_d02,"->>,>>>,>>9.99999").
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_genexcel wWin 
PROCEDURE um_genexcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE lStk                    AS DEC.
        DEFINE VARIABLE lFecha                  AS DATE.

        DEFINE VARIABLE k AS INTEGER.

    SESSION:SET-WAIT-STATE('GENERAL').

    /**/
    ASSIGN
            x-CodFam = ''.

    DO k = 1 TO BROWSE-4:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} :
        IF BROWSE-4:FETCH-SELECTED-ROW(k) IN FRAME {&FRAME-NAME}
            THEN x-CodFam = x-CodFam + (IF x-CodFam = '' THEN '' ELSE ',') + almtfam.CodFam.
    END.

    IF x-CodFam = '' THEN DO:
        MESSAGE 'Seleccione al menos una familia' VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.

   ASSIGN ChkBaja OptGrpCuales.

    /**/

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

    chWorkSheet:Range("A1"):VALUE = 'Codigo'.
    chWorkSheet:Range("B1"):VALUE = 'Descripcion'.
    chWorkSheet:Range("C1"):VALUE = 'Marca'.
    chWorkSheet:Range("D1"):VALUE = 'Peso'.
    chWorkSheet:Range("E1"):VALUE = 'Volumen'.
    chWorkSheet:Range("F1"):VALUE = 'Familia'.
    chWorkSheet:Range("G1"):VALUE = 'SubFamilia'.
    chWorkSheet:Range("H1"):VALUE = 'Estado'.
    chWorkSheet:Range("I1"):VALUE = 'Stock'.
    chWorkSheet:Range("J1"):VALUE = 'Empaque'.
    chWorkSheet:Range("K1"):VALUE = 'Zona'.
    chWorkSheet:Range("L1"):VALUE = 'Costo Prom'.
    chWorkSheet:Range("M1"):VALUE = 'CodProv'.
    chWorkSheet:Range("N1"):VALUE = 'Nombre Proveedor'.
    chWorkSheet:Range("O1"):VALUE = 'Categ. Contable'.
    chWorkSheet:Range("P1"):VALUE = 'Propio/Tercero'.
    chWorkSheet:Range("Q1"):VALUE = 'Nacional/Importado'.
    chWorkSheet:Range("R1"):VALUE = 'Master'.
    chWorkSheet:Range("S1"):VALUE = 'Inner'.
    chWorkSheet:Range("T1"):VALUE = 'Und.Basica'.
    chWorkSheet:Range("U1"):VALUE = 'Und.Stock'.

    /* ---------------------------------------------------  */    
    iColumn = 1.
    FOR EACH almmmate WHERE almmmate.codcia = s-codcia AND 
                        almmmate.codalm = s-codalm NO-LOCK :

        lStk = almmmate.stkact.
        lStk = IF (lStk = ?) THEN 0 ELSE lStk.

        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = almmmate.codmat AND
            LOOKUP(almmmatg.codfam,x-CodFam) > 0 NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO:
            IF (OptGrpCuales = 1) OR 
                (OptGrpCuales = 2 AND (almmmatg.pesmat <> 0 OR almmmatg.libre_d02 <> 0)) OR 
                (OptGrpCuales = 3 AND (almmmatg.pesmat = ? OR almmmatg.pesmat = 0 OR almmmatg.libre_d02 = ? OR almmmatg.libre_d02 = 0)) THEN DO:
                IF (almmmatg.tpoart <> 'D') OR (ChkBaja = NO) THEN DO:
                    IF (optgrpStock = 1) OR (optgrpStock = 2 AND lStk <> 0) OR
                        (optgrpStock = 3 AND lStk = 0) THEN DO:

                        FIND FIRST almtabla WHERE tabla = 'MK' AND almtabla.codigo = almmmatg.codmar NO-LOCK NO-ERROR.
                        iColumn = iColumn + 1.
                        cColumn = STRING(iColumn).

                        cRange = "A" + cColumn.
                        chWorkSheet:Range(cRange):Value = "'" + almmmatg.codmat.
                        cRange = "B" + cColumn.
                        chWorkSheet:Range(cRange):Value = almmmatg.desmat.
                        cRange = "C" + cColumn.
                        chWorkSheet:Range(cRange):Value = IF (AVAILABLE almtabla) THEN almtabla.nombre ELSE "".
                        cRange = "D" + cColumn.
                        chWorkSheet:Range(cRange):Value = almmmatg.pesmat.
                        cRange = "E" + cColumn.
                        chWorkSheet:Range(cRange):Value = almmmatg.libre_d02.
                        cRange = "F" + cColumn.
                        chWorkSheet:Range(cRange):Value = "'" + almmmatg.codfam.
                        cRange = "G" + cColumn.
                        chWorkSheet:Range(cRange):Value = "'" + almmmatg.subfam.
                        cRange = "H" + cColumn.
                        chWorkSheet:Range(cRange):Value = almmmatg.tpoart.
                        cRange = "I" + cColumn.
                        chWorkSheet:Range(cRange):Value = lStk.
                        cRange = "J" + cColumn.
                        chWorkSheet:Range(cRange):Value = almmmatg.canemp.
                        cRange = "K" + cColumn.
                        chWorkSheet:Range(cRange):Value = almmmate.codubi.

                        /*Costo Promedio Kardex*/                        
                        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
                            AND AlmStkGe.codmat = Almmmatg.codmat
                            AND AlmStkGe.fecha <= TODAY
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE AlmStkGe THEN DO:
                            cRange = "L" + cColumn.
                            chWorkSheet:Range(cRange):Value = AlmStkge.CtoUni. 
                        END.
                        FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND 
                            gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.
                        IF AVAILABLE gn-prov THEN DO:
                            cRange = "M" + cColumn.
                            chWorkSheet:Range(cRange):Value = "'" + almmmatg.codpr1.
                            cRange = "N" + cColumn.
                            chWorkSheet:Range(cRange):Value = gn-prov.nompro.                           
                        END.

                        cRange = "O" + cColumn.
                        chWorkSheet:Range(cRange):Value = Almmmatg.catconta[1].
                        cRange = "P" + cColumn.
                        chWorkSheet:Range(cRange):Value = Almmmatg.CHR__02.
                        cRange = "Q" + cColumn.
                        chWorkSheet:Range(cRange):Value = Almmmatg.TpoPro.
                        cRange = "R" + cColumn.
                        chWorkSheet:Range(cRange):Value = Almmmatg.canemp.
                        cRange = "S" + cColumn.
                        chWorkSheet:Range(cRange):Value = Almmmatg.stkrep.
                        cRange = "T" + cColumn.
                        chWorkSheet:Range(cRange):Value = "'" + Almmmatg.UndBas.
                        cRange = "U" + cColumn.
                        chWorkSheet:Range(cRange):Value = "'" + Almmmatg.UndStk.

                    END.
                END.
            END.

        END.
    END.
    /* ---------------------------------------------------  */
    /*
    iColumn = 1.
    FOR EACH almmmatg WHERE almmmatg.codcia = 001 AND LOOKUP(almmmatg.codfam,x-CodFam) > 0 :
        IF (OptGrpCuales = 1) OR 
            (OptGrpCuales = 2 AND (almmmatg.pesmat <> 0 OR almmmatg.libre_d02 <> 0)) OR 
            (OptGrpCuales = 3 AND (almmmatg.pesmat = 0 OR almmmatg.libre_d02 = 0)) THEN DO:
            IF (almmmatg.tpoart <> 'D') OR (ChkBaja = NO) THEN DO:            
                lStk    = 0.
                lFecha  = TODAY.
                /* Calculo Stock */
                FIND LAST almmmate WHERE almstkge.codcia = almmmatg.codcia AND 
                        almmmate.codalm = s-codalm AND almmmate.codmat = almmmatg.codmat
                        NO-LOCK NO-ERROR.
                IF AVAILABLE almstkge THEN lStk = almstkge.stkact.

                IF (optgrpStock = 1) OR (optgrpStock = 2 AND lStk <> 0) OR
                    (optgrpStock = 3 AND lStk = 0) THEN DO:
                    iColumn = iColumn + 1.
                    cColumn = STRING(iColumn).

                    cRange = "A" + cColumn.
                    chWorkSheet:Range(cRange):Value = "'" + almmmatg.codmat.
                    cRange = "B" + cColumn.
                    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
                    cRange = "C" + cColumn.
                    chWorkSheet:Range(cRange):Value = almmmatg.pesmat.
                    cRange = "D" + cColumn.
                    chWorkSheet:Range(cRange):Value = almmmatg.libre_d02.
                    cRange = "E" + cColumn.
                    chWorkSheet:Range(cRange):Value = "'" + almmmatg.codfam.
                    cRange = "F" + cColumn.
                    chWorkSheet:Range(cRange):Value = "'" + almmmatg.subfam.
                    cRange = "G" + cColumn.
                    chWorkSheet:Range(cRange):Value = almmmatg.tpoart.
                    cRange = "H" + cColumn.
                    chWorkSheet:Range(cRange):Value = lStk.
                END.

           END.
        END.
    END.
    */
     MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
    chExcelApplication:Visible = TRUE.
    SESSION:SET-WAIT-STATE('').

        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

    

       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

