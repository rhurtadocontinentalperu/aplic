&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF STREAM REPORTE.
DEF TEMP-TABLE detalle NO-UNDO
    FIELD dia       AS DATE
    FIELD hora      AS CHAR 
    FIELD cantidad  AS INT
    .

DEF TEMP-TABLE T-Detalle LIKE Detalle.

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
&Scoped-Define ENABLED-OBJECTS BtnDone FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
COMBO-BOX-Lista BUTTON-Preparar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
COMBO-BOX-Lista FILL-IN-Invitados FILL-IN-PorcVisita FILL-IN-Visitantes ~
FILL-IN-PorcClientes FILL-IN-Clientes FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Salir" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-LIMPIAR 
     LABEL "LIMPIAR TODO" 
     SIZE 30 BY 1.12.

DEFINE BUTTON BUTTON-Preparar 
     LABEL "PREPARAR INFORMACION" 
     SIZE 30 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Lista AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Clientes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "# de Clientes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Invitados AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "# Invitados" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-PorcClientes AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "% Conversión Clientes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-PorcVisita AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "% Conversión Visita" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Visitantes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "# Visitantes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.27 COL 83 WIDGET-ID 10
     FILL-IN-Fecha-1 AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-2 AT ROW 1.54 COL 43 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-Lista AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 22
     BUTTON-Preparar AT ROW 3.96 COL 21 WIDGET-ID 30
     BUTTON-LIMPIAR AT ROW 3.96 COL 51 WIDGET-ID 28
     FILL-IN-Invitados AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-PorcVisita AT ROW 5.31 COL 53 COLON-ALIGNED WIDGET-ID 36
     BUTTON-Excel AT ROW 5.31 COL 71 WIDGET-ID 32
     FILL-IN-Visitantes AT ROW 6.38 COL 19 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-PorcClientes AT ROW 6.38 COL 53 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-Clientes AT ROW 7.46 COL 19 COLON-ALIGNED WIDGET-ID 34
     FILL-IN-Mensaje AT ROW 8.81 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.29 BY 9 WIDGET-ID 100.


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
         TITLE              = "ESTADISTICAS DE PEDIDOS COMERCIALES"
         HEIGHT             = 9
         WIDTH              = 108.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 108.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 108.29
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR BUTTON BUTTON-Excel IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-LIMPIAR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Clientes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Invitados IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PorcClientes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PorcVisita IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Visitantes IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ESTADISTICAS DE PEDIDOS COMERCIALES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ESTADISTICAS DE PEDIDOS COMERCIALES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Salir */
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


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel W-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* Button 2 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-LIMPIAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-LIMPIAR W-Win
ON CHOOSE OF BUTTON-LIMPIAR IN FRAME F-Main /* LIMPIAR TODO */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-Invitados  = 0.
      FILL-IN-Visitantes = 0.
      ENABLE BUTTON-Preparar COMBO-BOX-Lista FILL-IN-Fecha-1.
      DISABLE BUTTON-Excel BUTTON-LIMPIAR .
      FILL-IN-Mensaje:SCREEN-VALUE = ''.
      DISPLAY FILL-IN-Invitados FILL-IN-Visitantes.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Preparar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Preparar W-Win
ON CHOOSE OF BUTTON-Preparar IN FRAME F-Main /* PREPARAR INFORMACION */
DO:
  ASSIGN COMBO-BOX-Lista FILL-IN-Fecha-1 FILL-IN-Fecha-2.
  /* Cargamos la informacion al temporal */
  EMPTY TEMP-TABLE Detalle.
  RUN Carga-Temporal.
  DISABLE COMBO-BOX-Lista FILL-IN-Fecha-1 FILL-IN-Fecha-2 BUTTON-Preparar WITH FRAME {&FRAME-NAME}.
  ENABLE BUTTON-Excel BUTTON-LIMPIAR WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NomPro LIKE gn-prov.nompro NO-UNDO.
DEF VAR x-NomVen LIKE gn-ven.nomven NO-UNDO.

EMPTY TEMP-TABLE Detalle.

ASSIGN
    FILL-IN-Invitados = 0
    FILL-IN-Visitantes = 0
    FILL-IN-Clientes = 0.
ASSIGN
    FILL-IN-PorcClientes = 0
    FILL-IN-PorcVisita = 0.
ESTADISTICAS:
FOR EACH ExpAsist NO-LOCK WHERE ExpAsist.CodCia = s-codcia AND 
    ExpAsist.CodDiv = s-coddiv AND
    (ExpAsist.FecPro >= FILL-IN-Fecha-1 AND ExpAsist.FecPro <= FILL-IN-Fecha-2) AND
    ExpAsist.Estado[1] <> "A":
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** RESUMIENDO ** " + ExpAsist.CodCli.
    /* VISITANTES */
    IF ExpAsist.Estado[1] = "C" AND
        (ExpAsist.FecAsi[1] >= FILL-IN-Fecha-1 AND ExpAsist.FecAsi[1] <= FILL-IN-Fecha-2)
        THEN DO:
        CREATE Detalle.
        ASSIGN
            Detalle.dia = ExpAsist.FecAsi[1]
            Detalle.hora = ExpAsist.HoraAsi[1]
            Detalle.cantidad = 1.
        FILL-IN-Visitantes = FILL-IN-Visitantes + 1.
    END.
    /* Invitados */
    IF LOOKUP(ExpAsist.Estado[1], "P,C") > 0 AND ExpAsist.Estado[2] <> "N"
        THEN DO:
        FILL-IN-Invitados = FILL-IN-Invitados + 1.
    END.
END.
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddiv = s-coddiv AND
    Faccpedi.libre_c01 = COMBO-BOX-Lista AND
    Faccpedi.fchped >= FILL-IN-Fecha-1 AND
    Faccpedi.fchped <= FILL-IN-Fecha-2 AND
    Faccpedi.flgest <> 'A'
    BREAK BY Faccpedi.codcli:
    IF FIRST-OF(Faccpedi.codcli) THEN FILL-IN-Clientes = FILL-IN-Clientes + 1.
END.
FILL-IN-PorcClientes = FILL-IN-Visitantes / FILL-IN-Clientes * 100.
FILL-IN-PorcVisita = FILL-IN-Visitantes / FILL-IN-Invitados * 100.
DISPLAY  FILL-IN-Invitados FILL-IN-Visitantes FILL-IN-Clientes 
    FILL-IN-PorcClientes FILL-IN-PorcVisita
    WITH FRAME {&FRAME-NAME}.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** INFORMACION LISTA **".

RETURN "OK".

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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista FILL-IN-Invitados 
          FILL-IN-PorcVisita FILL-IN-Visitantes FILL-IN-PorcClientes 
          FILL-IN-Clientes FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnDone FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista 
         BUTTON-Preparar 
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
DEF VAR x-Llave AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Formato003' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.


DEF VAR lFileXls AS CHAR NO-UNDO.
DEF VAR lNuevoFile AS LOG NO-UNDO.


GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta'  VALUE lFileXls.
lFileXls = lFileXls + 'plantilla_expolibreria_003.xltx'.
FILE-INFO:FILE-NAME = lFileXls.
IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
    MESSAGE 'La plantilla ' lFileXls SKIP 'NO existe' VIEW-AS ALERT-BOX.
    RETURN.
END.

SESSION:SET-WAIT-STATE('GENERAL').
/* Cargamos la informacion al temporal */
/* Programas que generan el Excel */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".

lNuevoFile = NO.    /* Abre la plantilla lFileXls */
{lib/excel-open-file.i}
/* ******************************************************************************** */
/* LOGICA PRINCIPAL: CARGA DEL EXCEL */
/* ******************************************************************************** */
/* Select a worksheet */
chWorkbook:Worksheets(1):Activate.
chWorksheet = chWorkbook:Worksheets(1).

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** ".
iRow = 1.
FOR EACH Detalle NO-LOCK:
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Dia.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Hora.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Cantidad.
END.
/* ******************************************************************************** */
/* ******************************************************************************** */
SESSION:SET-WAIT-STATE('').

lNuevoFile = YES.           /* Graba la plantilla en el nuevo archivo */
lFileXls = c-xls-file.
lCerrarAlTerminar = NO.     /* Se hace visible al terminar */
lMensajeAlTerminar = YES.   /* Aviso que terminó el proceso */
{lib/excel-close-file.i}
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable W-Win 
PROCEDURE local-disable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
      FILL-IN-Fecha-1 = TODAY
      FILL-IN-Fecha-2 = TODAY.     

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
      (gn-divi.campo-char[1] = 'L' OR gn-divi.campo-char[1] = 'A' ) AND
      gn-divi.campo-log[1] = NO
      WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Lista:ADD-LAST(gn-divi.coddiv, '999999') NO-ERROR.
  END.
  COMBO-BOX-Lista:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-coddiv.

  ENABLE COMBO-BOX-Lista WITH FRAME {&FRAME-NAME}.
  /*
  IF is-div-sele = 'X' THEN DO:
        /*COMBO-BOX-Lista:ENABLED IN FRAME {&FRAME-NAME} = NO .   */
      DISABLE COMBO-BOX-Lista WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
      /*COMBO-BOX-Lista:ENABLED IN FRAME {&FRAME-NAME} = YES .*/
      ENABLE COMBO-BOX-Lista WITH FRAME {&FRAME-NAME}.
  END.
  */
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

