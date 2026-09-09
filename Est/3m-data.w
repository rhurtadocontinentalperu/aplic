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

DEFINE VAR lCodProv AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.

lCodProv = '10011922'.

DEFINE TEMP-TABLE tt-art-div
    FIELDS tt-codmat LIKE ventasxproducto.codmat
    FIELDS tt-coddiv LIKE ventasxproducto.coddiv
    FIELDS tt-cantidad AS DEC INIT 0
    FIELDS tt-importe AS DEC INIT 0
    INDEX idx01 IS PRIMARY tt-codmat tt-coddiv.

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
&Scoped-Define ENABLED-OBJECTS txtYear cboMes ChkVentas ChkInventarios ~
BtnPath BtnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtYear cboMes ChkVentas ChkInventarios ~
txtPath 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnPath 
     LABEL "..." 
     SIZE 4 BY .77.

DEFINE BUTTON BtnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE cboMes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE txtPath AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE txtYear AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE ChkInventarios AS LOGICAL INITIAL yes 
     LABEL "Inventarios" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .77 NO-UNDO.

DEFINE VARIABLE ChkVentas AS LOGICAL INITIAL yes 
     LABEL "Ventas" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtYear AT ROW 1.96 COL 13 COLON-ALIGNED WIDGET-ID 6
     cboMes AT ROW 2 COL 32 COLON-ALIGNED WIDGET-ID 10
     ChkVentas AT ROW 3.88 COL 17 WIDGET-ID 2
     ChkInventarios AT ROW 3.88 COL 33 WIDGET-ID 4
     BtnPath AT ROW 5.42 COL 42 WIDGET-ID 20
     txtPath AT ROW 6.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     BtnProcesar AT ROW 8.69 COL 48 WIDGET-ID 12
     "Elija el directorio donde grabar el resultado" VIEW-AS TEXT
          SIZE 38.72 BY .62 AT ROW 5.5 COL 3.29 WIDGET-ID 18
          FGCOLOR 9 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.72 BY 9.62 WIDGET-ID 100.


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
         TITLE              = "Informacion ( 3M )"
         HEIGHT             = 9.62
         WIDTH              = 66.72
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
/* SETTINGS FOR FILL-IN txtPath IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Informacion ( 3M ) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Informacion ( 3M ) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnPath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnPath wWin
ON CHOOSE OF BtnPath IN FRAME fMain /* ... */
DO:

        DEFINE VAR lDirectorio AS CHAR.

        lDirectorio = "".

        SYSTEM-DIALOG GET-DIR lDirectorio  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.
        IF lDirectorio <> ? AND lDirectorio <> "" THEN DO :
            txtPath:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lDirectorio.
        END.
               
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnProcesar wWin
ON CHOOSE OF BtnProcesar IN FRAME fMain /* Procesar */
DO:
  
    ASSIGN txtYear cboMes chkVentas ChkInventarios txtPath.

    IF txtPath <> "" THEN DO:
        RUN ue-procesar.
    END.
    ELSE DO:
        MESSAGE "Ingrese el directorio destinto".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY txtYear cboMes ChkVentas ChkInventarios txtPath 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtYear cboMes ChkVentas ChkInventarios BtnPath BtnProcesar 
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

  cboMes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(MONTH(TODAY),">9").
  txtYear:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(YEAR(TODAY),">999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-inventarios wWin 
PROCEDURE ue-inventarios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lDia AS INT.
DEFINE VAR lMes AS INT.
DEFINE VAR lYear AS INT.
DEFINE VAR lFecha AS DATE.

DEFINE VAR lFileNameXls AS CHAR.

DEFINE VAR lStock AS DEC.
DEFINE VAR lFileName AS CHAR.
DEFINE VAR fullname AS CHAR.

DEFINE VAR cIPorigen AS CHAR.
DEFINE VAR cIPdestino AS CHAR.
DEFINE VAR cOtrosDatos AS CHAR.

cIPorigen = "192.168.100.251".

RUN lib/redireccionar-ip(cIPorigen, cOtrosDatos, OUTPUT cIPdestino).

/*lfilename = "\\192.168.100.251\newsie\on_in_co\Plantillas\001B1_INVENTARIO_PE20100038146_LIMA_PLANTILLA.xls". */
lfilename = "\\" + cIPdestino + "\newsie\on_in_co\Plantillas\001B1_INVENTARIO_PE20100038146_LIMA_PLANTILLA.xls". 
/*
fullname = SEARCH(lfilename).

IF fullname = ? THEN DO:
    MESSAGE "No existe la plantilla :" + lfilename.
    RETURN NO-APPLY.
END.
*/
FullName = lFileName.

SESSION:SET-WAIT-STATE('GENERAL').

/* Ultimo dia del MES anterior */
lYear   = txtYear.
lMes    = cboMes.
lFecha = DATE(lMes,1,lYear).
lFecha = lFecha - 1.

/*lFileXls = "C:\Ciman\Atenciones\Temporales\001B1_INVENTARIO_PE20100038146_LIMA_PLANTILLA.xls".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */*/
lFileXls = FullName.
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /* Muestra el mensaje de "proceso terminado" al finalizar */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

/*chWorkSheet = chExcelApplication:Sheets:Item(2).  && HOJA 2*/

iColumn = 11.

FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia AND 
                    almmmatg.codpr1 = lCodProv NO-LOCK :

    lStock = 0.
    FOR EACH Almacen WHERE almacen.codcia = s-codcia NO-LOCK:
        IF almacen.codalm <> "11T" AND almacen.codalm <> "99" THEN DO:
            FIND LAST almstkal WHERE almstkal.codcia = s-codcia AND 
                        almstkal.codalm = almacen.codalm AND 
                        almstkal.codmat = almmmatg.codmat AND 
                        almstkal.fecha <= lFecha NO-LOCK NO-ERROR.
            IF AVAILABLE almstkal THEN DO:
                lStock = lStock + almstkal.stkact.
            END.
        END.        
    END.

    IF lStock > 0 THEN DO:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + substring(almmmatg.desmat,1,40).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = lStock.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.undstk.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + STRING(YEAR(lFecha),"9999") + "-" + 
                                            STRING(MONTH(lFecha),"99") + "-" +
                                            STRING(DAY(lFecha),"99").
    END.
END.

/*001B1_INVENTARIO_PE20100038146_LIMA_19012015_000000*/

lFileNameXls = txtPath + "\001B1_INVENTARIO_PE20100038146_LIMA_" + STRING(DAY(TODAY),"99") + 
                        STRING(MONTH(TODAY),"99") + STRING(YEAR(TODAY),"9999") + 
                        "_000000".

chExcelApplication:DisplayAlerts = False.
chWorkSheet:SaveAs(lFileNameXls).

{lib\excel-close-file.i}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar wWin 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR fullname AS CHAR.
DEFINE VAR lfilename AS CHAR.
/*
IF Chkinventarios = YES THEN DO:
    lfilename = "\\192.168.100.251\newsie\on_in_co\Plantillas\001B1_INVENTARIO_PE20100038146_LIMA_PLANTILLA.xls". 
    fullname = SEARCH(lfilename).
    
    IF fullname = ? THEN DO:
        MESSAGE "No existe la plantilla :" + lfilename.
        RETURN NO-APPLY.
    END.
END.

IF ChkVentas = YES THEN DO:
    lfilename = "\\192.168.100.251\newsie\on_in_co\Plantillas\001A1_VENTA_PE20100038146_LIMA_PLANTILLA.xls". 
    fullname = SEARCH(lfilename).
    
    IF fullname = ? THEN DO:
        MESSAGE "No existe la plantilla :" + lfilename.
        RETURN NO-APPLY.
    END.
END.
*/
IF ChkVentas = YES THEN DO:
    RUN ue-ventas.
END.
IF Chkinventarios = YES THEN DO:
    RUN ue-inventarios.
END.

MESSAGE "Concluido...".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-ventas wWin 
PROCEDURE ue-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lDia AS INT.
DEFINE VAR lMes AS INT.
DEFINE VAR lYear AS INT.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lDiaKey AS DATE.
DEFINE VAR lSec AS INT.
DEFINE VAR lDataKey AS CHAR.

DEFINE VAR lFileNameXls AS CHAR.
DEFINE VAR lFileName AS CHAR.
DEFINE VAR fullname AS CHAR.

DEFINE VAR cIPorigen AS CHAR.
DEFINE VAR cIPdestino AS CHAR.
DEFINE VAR cOtrosDatos AS CHAR.

cIPorigen = "192.168.100.251".

RUN lib/redireccionar-ip(cIPorigen, cOtrosDatos, OUTPUT cIPdestino).

lfilename = "\\" + cIPdestino + "\newsie\on_in_co\Plantillas\001A1_VENTA_PE20100038146_LIMA_PLANTILLA.xls". 
/*lfilename = "\\192.168.100.251\newsie\on_in_co\Plantillas\001A1_VENTA_PE20100038146_LIMA_PLANTILLA.xls". */
/*
fullname = SEARCH(lfilename).

IF fullname = ? THEN DO:
    MESSAGE "No existe la plantilla :" + lfilename.
    RETURN NO-APPLY.
END.
*/

FullName = lfilename.

SESSION:SET-WAIT-STATE('GENERAL').

/* Primer dia del MES anterior */
lYear   = txtYear.
lMes    = cboMes.

IF lMes = 1 THEN DO:
    lMes = 12.
    lYear = lYear - 1.
END.
ELSE DO:
    lMes = lMes - 1.
END.
lFecha = DATE(lMes,1,lYear).

/*MESSAGE FullName.*/

/*lFileXls = "C:\Ciman\Atenciones\Temporales\001A1_VENTA_PE20100038146_LIMA_PLANTILLA.xls".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */*/
lFileXls = FullName.
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /* Muestra el mensaje de "proceso terminado" al finalizar */
lCerrarAlTerminar = YES.        /* Si permanece abierto el Excel luego de concluir el proceso */

/*chWorkSheet = chExcelApplication:Sheets:Item(2).  && HOJA 2*/

iColumn = 11.

FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia AND 
                    almmmatg.codpr1 = lCodProv NO-LOCK :

    EMPTY TEMP-TABLE tt-art-div  .

    REPEAT lSec = 0 TO 31 :
      lDiaKey = lFecha + lSec.

      IF MONTH(lDiaKey) = MONTH(lFecha) THEN DO:
          /*
          lDataKey = STRING(DAY(lDiaKey),"99") + "/" + 
                    STRING(MONTH(lDiaKey),"99") + "/" + 
                    STRING(YEAR(lDiaKey),"9999").
            */                    
          FOR EACH estavtas.ventasxproducto WHERE ventasxproducto.datekey = lDiaKey AND 
                    ventasxproducto.codmat = almmmatg.codmat NO-LOCK:
                FIND tt-art-div WHERE tt-codmat = ventasxproducto.codmat AND
                                        tt-coddiv = ventasxproducto.divdes NO-ERROR.
                IF NOT AVAILABLE tt-art-div THEN DO:
                    CREATE tt-art-div.
                        ASSIGN tt-art-div.tt-codmat = ventasxproducto.codmat
                                tt-art-div.tt-coddiv = ventasxproducto.divdes
                                tt-art-div.tt-cantidad  = 0
                                tt-art-div.tt-importe = 0.
                END.
                ASSIGN tt-art-div.tt-cantidad = tt-art-div.tt-cantidad + ventasxproducto.cantidad
                        tt-art-div.tt-importe = tt-art-div.tt-importe + ventasxproducto.ImpNacCIgv.
          END.
      END.
    END.

    FOR EACH tt-art-div WHERE tt-art-div.tt-cantidad <> 0 OR tt-art-div.tt-importe <> 0:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + substring(almmmatg.desmat,1,40).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-art-div.tt-coddiv.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + "Tda" + tt-art-div.tt-coddiv.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-art-div.tt-cantidad.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.undstk.
        IF tt-art-div.tt-cantidad <> 0 THEN DO:
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = Round(tt-art-div.tt-importe / tt-art-div.tt-cantidad,4).
        END.
        ELSE DO:
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = 0.00.
        END.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-art-div.tt-importe.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "PEN".
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + STRING(YEAR(lFecha),"9999") + "-" + 
                                            STRING(MONTH(lFecha),"99") + "-" +
                                            STRING(DAY(lFecha),"99").

        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = "000-000000".
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = "FA".
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = "NONE".
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = "NONE".
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = "NONE".
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = "NONE".
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = "NONE".
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = "NONE".
    END.
END.

/*001A1_VENTA_PE20100038146_LIMA_19012015_000000*/

lFileNameXls = txtPath + "\001A1_VENTA_PE20100038146_LIMA_" + STRING(DAY(TODAY),"99") + 
                        STRING(MONTH(TODAY),"99") + STRING(YEAR(TODAY),"9999") + 
                        "_000000".

chExcelApplication:DisplayAlerts = False.
chWorkSheet:SaveAs(lFileNameXls).

{lib\excel-close-file.i}

SESSION:SET-WAIT-STATE('').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

