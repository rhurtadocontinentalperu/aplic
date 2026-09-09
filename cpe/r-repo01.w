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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF TEMP-TABLE Detalle
    FIELD codper LIKE cpetareas.codper
    FIELD fecha AS DATE
    FIELD totitems AS INT
    FIELD totimporte AS DEC
    FIELD codarea LIKE CpeTareas.CodArea
    FIELD tiempotarea AS DEC
    FIELD tiempootros AS DEC
    FIELD tiempototal AS DEC
    FIELD trabajado AS DEC
    FIELD muerto AS DEC
    FIELD fechainicio AS DATETIME
    FIELD fechareg AS DATETIME
    FIELD fechacier AS DATETIME
    FIELD Inicio AS DATETIME
    FIELD Termino AS DATETIME.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
BUTTON-2 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division FILL-IN-Mensaje ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Salir" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 68 BY 1
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.62
     BGCOLOR 11 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-Division AT ROW 1.27 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-Mensaje AT ROW 5.85 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-Fecha-1 AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-2 AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 6
     BUTTON-2 AT ROW 3.15 COL 61 WIDGET-ID 14
     BtnDone AT ROW 3.15 COL 69 WIDGET-ID 12
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.46 WIDGET-ID 100.


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
         TITLE              = "RESUMEN POR TRABAJADOR"
         HEIGHT             = 7.46
         WIDTH              = 80
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
   FRAME-NAME L-To-R,COLUMNS                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* RESUMEN POR TRABAJADOR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* RESUMEN POR TRABAJADOR */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Salir */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Button 2 */
DO:
  ASSIGN
      FILL-IN-Fecha-1 FILL-IN-Fecha-2.
  RUN Excel.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Tiempo AS DEC.

EMPTY TEMP-TABLE Detalle.

/* Buscamos los que trabajaron ese turno */
FOR EACH CpeTraSed NO-LOCK WHERE Cpetrased.codcia = s-codcia
    AND Cpetrased.coddiv = s-coddiv
    AND Cpetrased.flgest = 'C'
    AND DATE (Cpetrased.fechareg) >= FILL-IN-Fecha-1
    AND DATE (Cpetrased.fechareg) <= FILL-IN-Fecha-2:
    FIND Detalle WHERE Detalle.codper = Cpetrased.codper 
        AND Detalle.fecha = DATE (CpeTraSed.fechareg) NO-ERROR.
    IF NOT AVAILABLE Detalle THEN CREATE Detalle.
    ASSIGN
        Detalle.codper    = CpeTraSed.CodPer
        Detalle.inicio    = CpeTraSed.FechaReg
        Detalle.termino   = CpeTraSed.FechaCier
        Detalle.fecha     = DATE (CpeTraSed.FechaReg)
        Detalle.fechareg  = Cpetrased.fechareg
        Detalle.fechacier = Cpetrased.fechacier
        Detalle.trabajado = Detalle.trabajado + ( Detalle.fechacier - Detalle.fechareg ) / 1000.
    /* buscamos las tareas realizadas en ese turno */
    FOR EACH CpeTareas NO-LOCK WHERE CpeTareas.CodCia = s-codcia
        AND CpeTareas.CodDiv = s-coddiv 
        AND CpeTareas.FlgEst = "C"
        AND Cpetareas.CodPer = CpeTraSed.CodPer
        AND CpeTareas.FchInicio >= CpeTraSed.FechaReg
        AND CpeTareas.FchFin    <= CpeTraSed.FechaCier
        BREAK BY CpeTareas.NroOd
        BY STRING (CpeTareas.FchInicio, '99/99/9999 HH:MM') :
        IF FIRST-OF(STRING (CpeTareas.FchInicio, '99/99/9999 HH:MM')) 
            OR FIRST-OF(CpeTareas.NroOd)
            THEN DO:
            FIND Detalle WHERE Detalle.codper = CpeTareas.CodPer 
                AND Detalle.fecha = DATE (CpeTraSed.FechaReg) NO-ERROR.
            IF NOT AVAILABLE Detalle THEN CREATE Detalle.
            ASSIGN
                Detalle.codper = CpeTareas.CodPer
                Detalle.codarea = Cpetareas.CodArea
                Detalle.fecha  = DATE (CpeTraSed.FechaReg)
                Detalle.fechareg = CpeTareas.FchInicio.

            /* calculamos el tiempo transcurrido en segundos */
            x-Tiempo = ( CpeTareas.FchFin - CpeTareas.FchInicio ) / 1000.
            ASSIGN
                Detalle.totitems = Detalle.totitems + CpeTareas.TotItems
                Detalle.totimporte = Detalle.totimporte + CpeTareas.TotImporte.
            /* definimos si es tiempo por O/D u OTROS */
            FIND Vtatabla WHERE Vtatabla.codcia = s-codcia
                AND Vtatabla.tabla = 'CPETAREA'
                AND VtaTabla.Llave_c1 = CpeTareas.TpoTarea
                NO-LOCK.
            IF Vtatabla.Libre_c01 = 'Si' 
            THEN Detalle.tiempotarea = Detalle.tiempotarea + x-Tiempo.
            ELSE Detalle.tiempootros = Detalle.tiempootros + x-Tiempo.
        END.
    END.
END.

/*
/* acumulamos el tiempo trabajado */
FOR EACH CpeTareas NO-LOCK WHERE CpeTareas.CodCia = s-codcia
    AND CpeTareas.CodDiv = s-coddiv 
    AND CpeTareas.FlgEst = "C"
    AND DATE (CpeTareas.FchInicio) >= FILL-IN-Fecha-1
    AND DATE (CpeTareas.FchInicio) <= FILL-IN-Fecha-2:
    FIND Detalle WHERE Detalle.codper = CpeTareas.CodPer 
        AND Detalle.fecha = DATE (CpeTareas.FchInicio) NO-ERROR.
    IF NOT AVAILABLE Detalle THEN CREATE Detalle.
    ASSIGN
        Detalle.codper = CpeTareas.CodPer
        Detalle.codarea = Cpetareas.CodArea
        Detalle.fecha  = DATE (CpeTareas.FchInicio)
        Detalle.fechareg = CpeTareas.FchInicio.
        
    /* calculamos el tiempo transcurrido en segundos */
    x-Tiempo = ( CpeTareas.FchFin - CpeTareas.FchInicio ) / 1000.
    ASSIGN
        Detalle.tiempotarea = Detalle.tiempotarea + x-Tiempo
        Detalle.totitems = Detalle.totitems + CpeTareas.TotItems
        Detalle.totimporte = Detalle.totimporte + CpeTareas.TotImporte.
END.

FOR EACH CpeTraSed NO-LOCK WHERE Cpetrased.codcia = s-codcia
    AND Cpetrased.coddiv = s-coddiv
    AND Cpetrased.flgest = 'C'
    AND DATE (Cpetrased.fechareg) >= FILL-IN-Fecha-1
    AND DATE (Cpetrased.fechareg) <= FILL-IN-Fecha-2:
    FIND Detalle WHERE Detalle.codper = Cpetrased.codper 
        AND Detalle.fecha = DATE (CpeTraSed.fechareg) NO-ERROR.
    IF NOT AVAILABLE Detalle THEN CREATE Detalle.
    ASSIGN
        Detalle.codper    = CpeTraSed.CodPer
        Detalle.inicio    = CpeTraSed.FechaReg
        Detalle.termino   = CpeTraSed.FechaCier
        Detalle.fecha     = DATE (CpeTraSed.FechaReg)
        Detalle.fechareg  = Cpetrased.fechareg
        Detalle.fechacier = Cpetrased.fechacier
        Detalle.tiempototal = Detalle.tiempototal + ( Detalle.fechacier - Detalle.fechareg ) / 1000.
END.

*/

FOR EACH Detalle:
    ASSIGN
        Detalle.tiempototal = Detalle.tiempotarea + Detalle.tiempootros
        Detalle.muerto = Detalle.trabajado - Detalle.tiempototal.
END.

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
  DISPLAY FILL-IN-Division FILL-IN-Mensaje FILL-IN-Fecha-1 FILL-IN-Fecha-2 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-1 FILL-IN-Fecha-1 FILL-IN-Fecha-2 BUTTON-2 BtnDone 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

/* Cargamos el temporal */
RUN Carga-Temporal.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1"):VALUE = "Personal".
chWorkSheet:Range("B1"):VALUE = "Fecha".
chWorkSheet:Range("C1"):VALUE = "Area".
chWorkSheet:Range("D1"):VALUE = "Inicio".
chWorkSheet:Range("E1"):VALUE = "Termino".
chWorkSheet:Range("F1"):VALUE = "Total Turno".
chWorkSheet:Range("G1"):VALUE = "Tiempo Trabajado".
chWorkSheet:Range("H1"):VALUE = "Tiempo otras tareas".
chWorkSheet:Range("I1"):VALUE = "Tiempo muerto".
chWorkSheet:Range("J1"):VALUE = "Items".
chWorkSheet:Range("K1"):VALUE = "Importe".

chWorkSheet:COLUMNS("B"):NumberFormat = "dd/MM/yyyy".

chWorkSheet = chExcelApplication:Sheets:Item(1).
SESSION:DATE-FORMAT = 'mdy'.
DEF VAR x-Horas AS CHAR.
FOR EACH Detalle, FIRST pl-pers WHERE pl-pers.codper = Detalle.codper NO-LOCK:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = Detalle.codper + ' ' + TRIM(pl-pers.patper) + ' ' + 
                                        TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    cRange = "B" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = DATE (Detalle.fechareg).
    cRange = "C" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Detalle.codarea.
    cRange = "D" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Detalle.inicio.
    cRange = "E" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Detalle.termino.
    cRange = "F" + cColumn.                                                
    /*RUN lib/_time-in-hours (Detalle.trabajado, OUTPUT x-horas).
    chWorkSheet:Range(cRange):Value = x-horas.*/
    chWorkSheet:Range(cRange):Value = ROUND(Detalle.trabajado / 3600, 2).
    cRange = "G" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = ROUND(Detalle.tiempotarea / 3600, 2).
    cRange = "H" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = ROUND(Detalle.tiempootros / 3600, 2).
    cRange = "I" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = ROUND(Detalle.muerto / 3600, 2).
    cRange = "J" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Detalle.totitems.
    cRange = "K" + cColumn.                                                
    chWorkSheet:Range(cRange):Value = Detalle.totimporte.
END.
SESSION:DATE-FORMAT = 'dmy'.
/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').

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
  FIND gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = s-coddiv
      NO-LOCK.
  FILL-IN-Division = "DIVISION: " + GN-DIVI.CodDiv + " " + GN-DIVI.DesDiv.
  FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1.
  FILL-IN-Fecha-2 = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

