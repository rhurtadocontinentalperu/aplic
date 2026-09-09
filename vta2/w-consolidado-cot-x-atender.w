&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
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

/* Vacio, significa todas las divisiones */
DEFINE INPUT PARAMETER p-Division      AS CHARACTER NO-UNDO.
DEFINE SHARED VAR s-codcia AS INT.

DEFINE TEMP-TABLE tt-diferencias
    FIELDS tt-codmat LIKE almmmatg.codmat
    FIELDS tt-DesMat LIKE almmmatg.desmat
    FIELDS tt-CodFam LIKE almmmatg.codfam
    FIELDS tt-desFam AS CHAR FORMAT 'X(80)'
    FIELDS tt-subFam LIKE almmmatg.subfam
    FIELDS tt-dessub AS CHAR FORMAT 'X(80)'
    FIELDS tt-codmar LIKE almmmatg.codmar
    FIELDS tt-desmar AS CHAR FORMAT 'X(80)'
    FIELDS tt-undstk LIKE almmmatg.undstk
    FIELDS tt-qty-pedida LIKE almmmatg.stkmax
    FIELDS tt-qty-atendida LIKE almmmatg.stkmax
    FIELDS tt-xatender LIKE almmmatg.stkmax
    FIELDS tt-stk-11s LIKE almmmatg.stkmax
    FIELDS tt-stk-21s LIKE almmmatg.stkmax
    FIELDS tt-stk-11 LIKE almmmatg.stkmax
    FIELDS tt-stk-35 LIKE almmmatg.stkmax
    FIELDS tt-stk-21 LIKE almmmatg.stkmax
    FIELDS tt-stk-38 LIKE almmmatg.stkmax

    INDEX idx01 IS PRIMARY tt-codmat.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtCliente txtDesde txtHasta btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtCliente txtDesClie txtDesde txtHasta ~
txtCodDiv txtDesDiv txtMsg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCliente AS CHARACTER FORMAT "X(11)":U 
     LABEL "De algun, Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesClie AS CHARACTER FORMAT "X(256)":U INITIAL "< Todos los Clientes >" 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY 1 NO-UNDO.

DEFINE VARIABLE txtMsg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCliente AT ROW 2.77 COL 21.43 COLON-ALIGNED WIDGET-ID 4
     txtDesClie AT ROW 2.77 COL 36.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     txtDesde AT ROW 4.08 COL 21.43 COLON-ALIGNED WIDGET-ID 6
     txtHasta AT ROW 4.08 COL 46.29 COLON-ALIGNED WIDGET-ID 8
     txtCodDiv AT ROW 5.46 COL 21.57 COLON-ALIGNED WIDGET-ID 16
     txtDesDiv AT ROW 5.46 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     btnProcesar AT ROW 6.81 COL 28 WIDGET-ID 10
     txtMsg AT ROW 8.08 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     "Consolidado de Articulos por atender - segun cotizaciones" VIEW-AS TEXT
          SIZE 53 BY .62 AT ROW 1.69 COL 12.43 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.29 BY 8.35 WIDGET-ID 100.


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
         TITLE              = "Consolidades de Articulos x Atender - COTIZACIONES"
         HEIGHT             = 8.35
         WIDTH              = 82.29
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.81
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txtCodDiv IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesClie IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesDiv IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMsg IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Consolidades de Articulos x Atender - COTIZACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Consolidades de Articulos x Atender - COTIZACIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar wWin
ON CHOOSE OF btnProcesar IN FRAME fMain /* Procesar */
DO:
  ASSIGN txtdesde txthasta txtcliente.
  IF txtdesde > txthasta THEN DO:
    MESSAGE 'Fechas estan incorrectas...' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  IF txtCliente <> "" THEN DO:  
    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = txtcliente NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'Cliente NO Existe...' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
  END.

  RUN um-procesar.
  RUN um-excel.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCliente wWin
ON LEAVE OF txtCliente IN FRAME fMain /* De algun, Cliente */
DO:
    DEFINE VAR lCodClie AS CHAR.

    lCodClie = SELF:SCREEN-VALUE.

    IF lCodClie <> "" THEN DO:  
      FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = lCodClie NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
          /*txtDesClie:SCREEN-VALUE = ''.*/
          MESSAGE 'Cliente NO Existe...' VIEW-AS ALERT-BOX WARNING.
          RETURN NO-APPLY.
      END.
      txtDesClie:SCREEN-VALUE = gn-clie.nomcli.
    END.
    ELSE txtDesClie:SCREEN-VALUE = '< Todos los Clientes >'.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

    txtdesde:SCREEN-VALUE = STRING(TODAY - 30,'99/99/9999').
    txthasta:SCREEN-VALUE = STRING(TODAY,'99/99/9999').

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
  DISPLAY txtCliente txtDesClie txtDesde txtHasta txtCodDiv txtDesDiv txtMsg 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCliente txtDesde txtHasta btnProcesar 
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
DO WITH FRAME {&FRAME-NAME}:
    txtdesde:SCREEN-VALUE = STRING(TODAY - 30,'99/99/9999').
    txthasta:SCREEN-VALUE = STRING(TODAY,'99/99/9999').

    txtCodDiv:SCREEN-VALUE = p-division.

    IF p-division <> "" THEN DO:
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
            gn-divi.coddiv = p-division NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN DO:
            txtdesdiv:SCREEN-VALUE = gn-divi.desdiv.
        END.
        ELSE txtdesdiv:SCREEN-VALUE = '< ** DIVISION ERRADA ** >'.
    END.
    ELSE txtdesdiv:SCREEN-VALUE = '< Todas las divisiones >'.
    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros wWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros wWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-excel wWin 
PROCEDURE um-excel :
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
        DEFINE VARIABLE x-signo                 AS DECI.

SESSION:SET-WAIT-STATE('GENERAL').
DO WITH FRAME {&FRAME-NAME}:
    txtMsg:SCREEN-VALUE = 'Generando el Excel...'.
END.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        /* set the column names for the Worksheet */
        
        chWorkSheet:Range("b1:b1"):Font:Bold = TRUE.
        chWorkSheet:Range("b2:b2"):Font:Bold = TRUE.
        chWorkSheet:Range("b3:b3"):Font:Bold = TRUE.
        /*
        chWorkSheet:Range("A1"):Value = "Cliente :".
        chWorkSheet:Range("A2"):Value = "Division :".
        chWorkSheet:Range("A3"):Value = "Fechas :".
        */
        DO WITH FRAME {&FRAME-NAME}:
            chWorkSheet:Range("B1"):Value = "Cliente  : " + txtCliente:SCREEN-VALUE + " " + 
                            txtDesClie:SCREEN-VALUE.
            chWorkSheet:Range("B2"):Value = "Division : " + txtCodDiv:SCREEN-VALUE + " " + 
                            txtDesDiv:SCREEN-VALUE.
            chWorkSheet:Range("B3"):Value = "Fechas   : Desde : " + txtDesde:SCREEN-VALUE + 
                            "     Hasta : " + txtHasta:SCREEN-VALUE.
        END.
        chWorkSheet:Range("A4:R4"):Font:Bold = TRUE.
        chWorkSheet:Range("A4"):Value = "CODIGO".
        chWorkSheet:Range("B4"):Value = "Descrpcion Articulo".
        chWorkSheet:Range("C4"):Value = "Familia".
        chWorkSheet:Range("D4"):Value = "SubFamilia".
        chWorkSheet:Range("E4"):Value = "Marca".
        chWorkSheet:Range("F4"):Value = "U.Medida".

        chWorkSheet:Range("G4"):Value = "Cant.Pedida".
        chWorkSheet:Range("H4"):Value = "Cant.Atendida".
        chWorkSheet:Range("I4"):Value = "Cant.x Atender".

        chWorkSheet:Range("J4"):Value = "'11S".
        chWorkSheet:Range("K4"):Value = "'21S".
        chWorkSheet:Range("L4"):Value = "Total 11S + 21S".
        chWorkSheet:Range("M4"):Value = "'11".
        chWorkSheet:Range("N4"):Value = "'35".
        chWorkSheet:Range("O4"):Value = "'21".
        chWorkSheet:Range("P4"):Value = "'38".
        chWorkSheet:Range("Q4"):Value = "Total CDs".
            
    iColumn = 4.

         FOR EACH tt-diferencias:
     
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-diferencias.tt-codmat.
             cRange = "B" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-diferencias.tt-desmat.
             cRange = "C" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-diferencias.tt-codfam.
             cRange = "D" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-diferencias.tt-subfam.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-diferencias.tt-codmar.
             cRange = "F" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-diferencias.tt-undstk.

             cRange = "G" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-qty-pedida.

             cRange = "H" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-qty-atendida.

             cRange = "I" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-xatender.

             cRange = "J" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-stk-11s.
             cRange = "K" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-stk-21s.
             cRange = "L" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-stk-11S + tt-diferencias.tt-stk-21S.

             cRange = "M" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-stk-11.
             cRange = "N" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-stk-35.
             cRange = "O" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-stk-21.
             cRange = "P" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-stk-38.

             cRange = "Q" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-diferencias.tt-stk-11 + 
                                            tt-diferencias.tt-stk-35 + 
                                            tt-diferencias.tt-stk-21 +
                                            tt-diferencias.tt-stk-38.

     END.
     chExcelApplication:Visible = TRUE.
        chExcelApplication:DisplayAlerts = False.
/*      chExcelApplication:Quit().*/


        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

    SESSION:SET-WAIT-STATE('').

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-procesar wWin 
PROCEDURE um-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lDife AS DECIMAL.
DEFINE VAR lStk AS DECIMAL.

EMPTY TEMP-TABLE tt-diferencias.

DO WITH FRAME {&FRAME-NAME}:
    txtMsg:SCREEN-VALUE = 'Procesando Cotizaciones....'.
END.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH FacCPedi WHERE FacCPedi.codcia = s-codcia AND 
    FacCPedi.coddoc = 'COT' AND 
    (FacCPedi.fchped >= txtdesde AND FacCPedi.fchped <= txthasta) AND 
    (FacCPedi.flgest = 'E' OR FacCPedi.flgest = 'P') NO-LOCK:
    IF (txtCliente = "" OR txtCliente = FacCPedi.codcli) THEN DO:
        IF (p-division = "" OR FacCPedi.coddiv = p-division) THEN DO:
            FOR EACH FacDPedi OF FacCPedi NO-LOCK WHERE FacDpedi.canate < FacDPedi.canped:
                lDife = FacDPedi.canped - FacDpedi.canate.

                FIND tt-diferencias WHERE tt-diferencias.tt-codmat = FacDPedi.codmat EXCLUSIVE NO-ERROR.
                IF NOT AVAILABLE tt-diferencias THEN DO:
                   CREATE tt-diferencias.
                    ASSIGN tt-codmat = FacDPedi.codmat.
                    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = FacDPedi.codmat NO-LOCK NO-ERROR.
                    IF AVAILABLE almmmatg THEN DO:
                        
                        FIND FIRST almtfami WHERE almtfami.codcia = s-codcia AND 
                            almtfami.codfam = almmmatg.codfam NO-LOCK NO-ERROR.
                        FIND FIRST almsfami WHERE almsfami.codcia = s-codcia AND 
                            almsfami.codfam = almmmatg.codfam AND
                            almsfami.subfam = almmmatg.subfam NO-LOCK NO-ERROR.
                        FIND FIRST almtabla WHERE almtabla.tabla = 'MK' AND 
                            almtabla.codigo = almmmatg.codmar NO-LOCK NO-ERROR.

                        ASSIGN tt-desmat    = almmmatg.desmat
                            tt-codfam       = almmmatg.codfam + IF(AVAILABLE almtfami) THEN " " + almtfami.desfam ELSE ""
                            tt-subfam       = almmmatg.subfam + IF(AVAILABLE almsfami) THEN " " + almsfami.dessub ELSE ""
                            tt-codmar       = almmmatg.codmar + IF(AVAILABLE almtabla) THEN " " + almtabla.nombre ELSE ""
                            tt-undstk       = almmmatg.undstk.
                    END.

                END.
                ASSIGN tt-diferencias.tt-xatender = tt-diferencias.tt-xatender + lDife
                    tt-diferencias.tt-qty-pedida = tt-diferencias.tt-qty-pedida + FacDPedi.canped
                    tt-diferencias.tt-qty-atendida = tt-diferencias.tt-qty-atendida + FacDpedi.canate.
            END.
        END.
    END.
END.

DO WITH FRAME {&FRAME-NAME}:
    txtMsg:SCREEN-VALUE = 'Calculando Saldos de Almacenes...'.
END.

FOR EACH tt-diferencias EXCLUSIVE :
    /* 11S */
    lStk = 0.
    RUN um-saldos-almacen (INPUT '11S', INPUT tt-diferencias.tt-codmat, INPUT TODAY, 
                           OUTPUT lstk).
    ASSIGN tt-diferencias.tt-stk-11s = tt-diferencias.tt-stk-11s + lStk.
    /* 21S */
    lStk = 0.
    RUN um-saldos-almacen (INPUT '21S', INPUT tt-diferencias.tt-codmat, INPUT TODAY, 
                           OUTPUT lstk).
    ASSIGN tt-diferencias.tt-stk-21s = tt-diferencias.tt-stk-21s + lStk.
    /* 11 */
    lStk = 0.
    RUN um-saldos-almacen (INPUT '11', INPUT tt-diferencias.tt-codmat, INPUT TODAY, 
                           OUTPUT lstk).
    ASSIGN tt-diferencias.tt-stk-11 = tt-diferencias.tt-stk-11 + lStk.
    /* 35 */
    lStk = 0.
    RUN um-saldos-almacen (INPUT '35', INPUT tt-diferencias.tt-codmat, INPUT TODAY, 
                           OUTPUT lstk).
    ASSIGN tt-diferencias.tt-stk-35 = tt-diferencias.tt-stk-35 + lStk.
    /* 21 */
    lStk = 0.
    RUN um-saldos-almacen (INPUT '21', INPUT tt-diferencias.tt-codmat, INPUT TODAY, 
                           OUTPUT lstk).
    ASSIGN tt-diferencias.tt-stk-21 = tt-diferencias.tt-stk-21 + lStk.
    /* 38 */
    lStk = 0.
    RUN um-saldos-almacen (INPUT '38', INPUT tt-diferencias.tt-codmat, INPUT TODAY, 
                           OUTPUT lstk).
    ASSIGN tt-diferencias.tt-stk-38 = tt-diferencias.tt-stk-38 + lStk.
END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-saldos-almacen wWin 
PROCEDURE um-saldos-almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-almacen AS CHAR.
DEFINE INPUT PARAMETER p-codmat AS CHAR.
DEFINE INPUT PARAMETER p-fecha AS DATE.
DEFINE OUTPUT PARAMETER p-Stock AS DECIMAL.

p-stock = 0.
FIND LAST almstkal WHERE almstkal.codcia = s-codcia AND 
    almstkal.codalm = p-almacen AND almstkal.codmat = p-codmat AND
    almstkal.fecha <= p-fecha NO-LOCK NO-ERROR.
IF AVAILABLE almstkal THEN DO:
    p-stock = almstkal.stkact.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

