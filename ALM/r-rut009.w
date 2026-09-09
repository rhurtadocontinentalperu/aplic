&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE detalle LIKE DI-RutaD
       field fchdoc like di-rutac.fchdoc.



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

DEF TEMP-TABLE resumen LIKE detalle.
DEF BUFFER b-detalle FOR detalle.
DEF STREAM REPORTE.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha-1 BUTTON-2 BtnDone ~
FILL-IN-Fecha-2 FILL-IN-Salidas 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
FILL-IN-Salidas FILL-IN-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Salidas AS INTEGER FORMAT ">9":U INITIAL 3 
     LABEL "Cantidad de salidas" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-Fecha-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-2 AT ROW 1.27 COL 63 WIDGET-ID 8
     BtnDone AT ROW 1.27 COL 70 WIDGET-ID 2
     FILL-IN-Fecha-2 AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Salidas AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-mensaje AT ROW 4.5 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 4.85 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: detalle T "?" ? INTEGRAL DI-RutaD
      ADDITIONAL-FIELDS:
          field fchdoc like di-rutac.fchdoc
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "ENTREGAS NO EFECTIVAS"
         HEIGHT             = 4.85
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* ENTREGAS NO EFECTIVAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* ENTREGAS NO EFECTIVAS */
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
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
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
      FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-Salidas.
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

EMPTY TEMP-TABLE detalle.
EMPTY TEMP-TABLE resumen.

/* Hojas de ruta cerradas y con guias no entregadas */
/* Hojas de ruta no cerradas aun */
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
    FOR EACH di-rutac NO-LOCK WHERE di-rutac.codcia = s-codcia
        AND di-rutac.coddiv = gn-divi.coddiv
        AND di-rutac.fchdoc >= FILL-IN-Fecha-1
        AND di-rutac.fchdoc <= FILL-IN-Fecha-2
        AND di-rutac.flgest <> 'A':
        FILL-IN-mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
             "** PROCESANDO " + di-rutac.coddiv +
             ' ' + di-rutac.nrodoc + 
             ' ' + STRING(di-rutac.fchdoc) + " **".
        /* guias de venta */
        FOR EACH di-rutad OF di-rutac NO-LOCK:
            IF di-rutad.flgest <> 'C' THEN DO:
                CREATE detalle.
                ASSIGN
                    detalle.codcia = di-rutac.codcia
                    detalle.coddiv = di-rutac.coddiv
                    detalle.fchdoc = di-rutac.fchdoc
                    detalle.coddoc = di-rutac.coddoc
                    detalle.nrodoc = di-rutac.nrodoc
                    detalle.codref = di-rutad.codref
                    detalle.nroref = di-rutad.nroref
                    detalle.libre_c01 = di-rutac.flgest
                    detalle.flgest = di-rutad.flgest
                    detalle.flgestdet = DI-RutaD.FlgEstDet.
            END.
        END.
        /* guias de transferencias */
        FOR EACH di-rutag OF di-rutac NO-LOCK:
            IF di-rutag.flgest <> 'C' THEN DO:
                CREATE detalle.
                ASSIGN
                    detalle.codcia = di-rutac.codcia
                    detalle.coddiv = di-rutac.coddiv
                    detalle.fchdoc = di-rutac.fchdoc
                    detalle.coddoc = di-rutac.coddoc
                    detalle.nrodoc = di-rutac.nrodoc
                    detalle.codref = 'G/R'
                    detalle.nroref = STRING( Di-RutaG.serref, '999') + STRING( Di-RutaG.nroref, '999999')
                    detalle.libre_c01 = di-rutac.flgest
                    detalle.flgest = di-rutag.flgest
                    detalle.flgestdet = DI-RutaG.FlgEstDet.
            END.
        END.
        /* guias itinerantes */
        FOR EACH di-rutadg OF di-rutac NO-LOCK:
            IF di-rutadg.flgest <> 'C' THEN DO:
                CREATE detalle.
                ASSIGN
                    detalle.codcia = di-rutac.codcia
                    detalle.coddiv = di-rutac.coddiv
                    detalle.fchdoc = di-rutac.fchdoc
                    detalle.coddoc = di-rutac.coddoc
                    detalle.nrodoc = di-rutac.nrodoc
                    detalle.codref = di-rutadg.codref
                    detalle.nroref = di-rutadg.nroref
                    detalle.libre_c01 = di-rutac.flgest
                    detalle.flgest = di-rutadg.flgest
                    detalle.flgestdet = DI-RutaDG.FlgEstDet.
            END.
        END.
    END.
END.

DEF VAR x-Cuentas AS INT.

FOR EACH detalle NO-LOCK BREAK BY detalle.codref BY detalle.nroref:
    FILL-IN-mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "** RESUMIENDO " + detalle.coddiv +
        ' ' + detalle.nrodoc + 
        ' ' + STRING(detalle.fchdoc) + " **".
    IF FIRST-OF(detalle.codref) OR FIRST-OF(detalle.nroref) THEN x-Cuentas = 0.
    x-Cuentas = x-Cuentas + 1.
    IF ( LAST-OF(detalle.codref) OR LAST-OF(detalle.nroref) ) 
        AND x-Cuentas >= FILL-IN-Salidas
        THEN DO:
        FOR EACH b-detalle NO-LOCK WHERE b-detalle.codref = detalle.codref
            AND b-detalle.nroref = detalle.nroref:
            CREATE resumen.
            BUFFER-COPY b-detalle TO resumen.
        END.
    END.
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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-Salidas FILL-IN-mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN-Fecha-1 BUTTON-2 BtnDone FILL-IN-Fecha-2 FILL-IN-Salidas 
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


DEF VAR x-Llave AS CHAR FORMAT 'x(1000)'.
DEF VAR i-Campo AS INT INIT 1 NO-UNDO.
DEF VAR x-Campo AS CHAR NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(500)'.
DEF VAR l-Titulo AS LOG INIT NO NO-UNDO.
DEF VAR x-Cuenta-Registros AS INT INIT 0.
DEF VAR x-Estado AS CHAR FORMAT 'x(10)'.

RUN Carga-Temporal.
IF NOT CAN-FIND(FIRST resumen NO-LOCK) THEN DO:
    MESSAGE 'Fin de archivo' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Titulo = 'Division|Fecha|Hoja de ruta|Estado Hoja de ruta|Documento|Situacion|Motivo|'.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE x-Titulo SKIP.
FOR EACH resumen NO-LOCK,
    FIRST gn-divi OF resumen NO-LOCK
    BY resumen.codref BY resumen.nroref BY resumen.fchdoc:
    x-Llave = resumen.coddiv + ' ' + gn-divi.desdiv + '|'.
    x-Llave = x-Llave + STRING(resumen.fchdoc, '99/99/9999') + '|'.
    x-Llave = x-Llave + resumen.coddoc + ' ' + resumen.nrodoc + '|'.
    CASE resumen.libre_c01:
        WHEN 'E' THEN x-Llave = x-Llave + 'Emitida' + '|'.
        WHEN 'P' THEN x-Llave = x-Llave + 'Pendiente' + '|'.
        WHEN 'C' THEN x-Llave = x-Llave + 'Cerrada' + '|'.
        WHEN 'A' THEN x-Llave = x-Llave + 'Anulada' + '|'.
        OTHERWISE x-Llave = x-Llave + '|'.
    END CASE.
    x-Llave = x-Llave + resumen.codref + ' ' + resumen.nroref + '|'.
    RUN alm/f-flgrut ("D", resumen.flgest, OUTPUT x-Estado).
    x-Llave = x-Llave + x-Estado + '|'.
    FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
        AND AlmTabla.Codigo = resumen.flgestdet
        AND almtabla.NomAnt = 'N'
        NO-LOCK NO-ERROR.
    IF AVAILABLE AlmTabla THEN x-Llave = x-Llave + almtabla.Nombre + '|'.
    ELSE x-Llave = x-Llave + '|'.
    x-Llave = REPLACE(x-Llave, '|', CHR(9)).
    PUT STREAM REPORTE x-LLave SKIP.
    /* RHC 01.04.11 control de registros */
    x-Cuenta-Registros = x-Cuenta-Registros + 1.
    IF x-Cuenta-Registros > 65000 THEN DO:
        MESSAGE 'Se ha llegado al tope de 65000 registros que soporta el Excel' SKIP
            'Carga abortada' VIEW-AS ALERT-BOX WARNING.
        LEAVE.
    END.
END.
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Hoja de ruta', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

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
  ASSIGN
      FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-Fecha-2 = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

