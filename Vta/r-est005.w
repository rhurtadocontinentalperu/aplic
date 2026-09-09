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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-task-no AS INT NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR cl-codcia AS INT NO-UNDO.
FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

&SCOPED-DEFINE CONDICION Faccpedi.nroped >= x-NroPed-1 AND Faccpedi.nroped <= x-NroPed-2 ~
AND Faccpedi.FchPed >= x-FchDoc-1 AND Faccpedi.FchPed <= x-FchDoc-2 ~
AND Faccpedi.codcli BEGINS x-CodCli

DEF FRAME f-Mensaje
    'Cliente:' Faccpedi.nomcli SKIP
    '  Orden:' Faccpedi.nroped SKIP
    WITH VIEW-AS DIALOG-BOX NO-LABELS CENTERED OVERLAY TITLE 'Procesando'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-NroPed-1 x-NroPed-2 x-FchDoc-1 x-FchDoc-2 ~
x-CodCli x-Canal x-Situacion BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-NroPed-1 x-NroPed-2 x-FchDoc-1 ~
x-FchDoc-2 x-CodCli x-NomCli x-Canal x-NomCan x-Situacion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 1" 
     SIZE 7 BY 1.73.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\exit":U
     LABEL "Button 2" 
     SIZE 7 BY 1.73.

DEFINE VARIABLE x-Canal AS CHARACTER FORMAT "X(4)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCan AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroPed-1 AS CHARACTER FORMAT "x(9)":U 
     LABEL "O/D Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroPed-2 AS CHARACTER FORMAT "x(9)":U 
     LABEL "O/D Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-Situacion AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por sacar", 1,
"Por facturar", 2,
"Facturado", 3,
"Despachado", 4
     SIZE 47 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-NroPed-1 AT ROW 1.38 COL 11 COLON-ALIGNED
     x-NroPed-2 AT ROW 1.38 COL 29 COLON-ALIGNED
     x-FchDoc-1 AT ROW 2.35 COL 11 COLON-ALIGNED
     x-FchDoc-2 AT ROW 2.35 COL 29 COLON-ALIGNED
     x-CodCli AT ROW 3.31 COL 11 COLON-ALIGNED
     x-NomCli AT ROW 3.31 COL 25 COLON-ALIGNED NO-LABEL
     x-Canal AT ROW 4.27 COL 11 COLON-ALIGNED
     x-NomCan AT ROW 4.27 COL 21 COLON-ALIGNED NO-LABEL
     x-Situacion AT ROW 5.23 COL 13 NO-LABEL
     BUTTON-1 AT ROW 7.15 COL 6
     BUTTON-2 AT ROW 7.15 COL 15
     "Situacion:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.42 COL 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4.


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
         TITLE              = "SEGUIMIENTO DE PEDIDOS"
         HEIGHT             = 9.15
         WIDTH              = 71.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN x-NomCan IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* SEGUIMIENTO DE PEDIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* SEGUIMIENTO DE PEDIDOS */
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
  ASSIGN
    x-Canal x-CodCli x-FchDoc-1 x-FchDoc-2 x-NroPed-1 x-NroPed-2 x-Situacion.

  /* Consistencia */
  IF x-FchDoc-1 = ? OR x-FchDoc-2 = ? THEN DO:
    MESSAGE 'Ingrese las fecha correctamente' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  IF x-NroPed-1 = '' THEN DO:
    FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = 'O/D'
        AND Faccpedi.coddiv = s-coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN x-NroPed-1 = FAccpedi.nroped.
  END.
  IF x-NroPed-2 = '' THEN x-NroPed-2 = FILL('9',9).

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
/*{src/adm/template/cntnrwin.i}*/

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal W-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
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
  DEF VAR i AS INT NO-UNDO.
  
  s-task-no = 0.        /* OJO */
  CASE x-Situacion:
    WHEN 1 THEN RUN Carga-Temporal-1.
    WHEN 2 THEN RUN Carga-Temporal-2.
    WHEN 3 THEN RUN Carga-Temporal-3.
    WHEN 4 THEN RUN Carga-Temporal-4.
  END CASE.

  HIDE FRAME f-Mensaje.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-1 W-Win 
PROCEDURE Carga-Temporal-1 :
/*------------------------------------------------------------------------------
  Purpose:     O/D sin guias de remision
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Cargamos las Ordenes de despacho */
  FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = 'O/D'
        AND Faccpedi.coddiv = s-coddiv
        AND Faccpedi.flgest = 'P'
        AND {&CONDICION},
        FIRST Gn-clie NO-LOCK WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = Faccpedi.codcli:
    DISPLAY
        Faccpedi.nomcli Faccpedi.nroped
        WITH FRAME f-Mensaje.
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = 'G/R'
        AND Ccbcdocu.codped = Faccpedi.coddoc
        AND Ccbcdocu.nroped = Faccpedi.nroped
        AND Ccbcdocu.flgest <> 'A'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN NEXT.
    IF s-task-no = 0 THEN DO:
        REPEAT:
            s-task-no = RANDOM(1, 999999).
            FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
            IF NOT AVAILABLE w-report THEN LEAVE.
        END.
    END.
    CREATE w-report.
    ASSIGN
        w-report.task-no    = s-task-no
        w-report.campo-c[1] = Faccpedi.nroped
        w-report.campo-d[1] = Faccpedi.fchped
        w-report.campo-c[2] = Faccpedi.codcli
        w-report.campo-c[3] = Faccpedi.nomcli
        w-report.campo-i[1] = Faccpedi.codmon
        w-report.campo-f[1] = Faccpedi.imptot.
     FIND almtabla WHERE almtabla.Tabla = 'CN' AND almtabla.Codigo = Gn-clie.canal NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN w-report.campo-c[4] = almtabla.nombre.
  END.        
  HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-2 W-Win 
PROCEDURE Carga-Temporal-2 :
/*------------------------------------------------------------------------------
  Purpose:     O/D con guias de remision NO facturada
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Cargamos las Ordenes de despacho */
  FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = 'O/D'
        AND Faccpedi.coddiv = s-coddiv
        AND Faccpedi.flgest <> 'A'
        AND {&CONDICION} ,
        FIRST Gn-clie NO-LOCK WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = Faccpedi.codcli:
    DISPLAY
        Faccpedi.nomcli Faccpedi.nroped
        WITH FRAME f-Mensaje.
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = 'G/R'
            AND Ccbcdocu.codped = Faccpedi.coddoc
            AND Ccbcdocu.nroped = Faccpedi.nroped
            AND Ccbcdocu.flgest = 'P':
        IF s-task-no = 0 THEN DO:
            REPEAT:
                s-task-no = RANDOM(1, 999999).
                FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
                IF NOT AVAILABLE w-report THEN LEAVE.
            END.
        END.
        CREATE w-report.
        ASSIGN
            w-report.task-no    = s-task-no
            w-report.campo-c[1] = Faccpedi.nroped
            w-report.campo-d[1] = Faccpedi.fchped
            w-report.campo-c[2] = Faccpedi.codcli
            w-report.campo-c[3] = Faccpedi.nomcli
            w-report.campo-i[1] = Faccpedi.codmon
            w-report.campo-f[1] = Faccpedi.imptot
            w-report.campo-c[5] = Ccbcdocu.nrodoc
            w-report.campo-d[2] = Ccbcdocu.fchdoc.
         FIND almtabla WHERE almtabla.Tabla = 'CN' AND almtabla.Codigo = Gn-clie.canal NO-LOCK NO-ERROR.
         IF AVAILABLE almtabla THEN w-report.campo-c[4] = almtabla.nombre.
    END.
  END.        
  HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-3 W-Win 
PROCEDURE Carga-Temporal-3 :
/*------------------------------------------------------------------------------
  Purpose:     O/D con guias de remision facturada pero que NO tiene H/Ruta
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF BUFFER B-DOCU FOR Ccbcdocu.
  
  /* Cargamos las Ordenes de despacho */
  FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = 'O/D'
        AND Faccpedi.coddiv = s-coddiv
        AND Faccpedi.flgest <> 'A'
        AND {&CONDICION},
        FIRST Gn-clie NO-LOCK WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = Faccpedi.codcli:
    DISPLAY
        Faccpedi.nomcli Faccpedi.nroped
        WITH FRAME f-Mensaje.
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = 'G/R'
            AND Ccbcdocu.codped = Faccpedi.coddoc
            AND Ccbcdocu.nroped = Faccpedi.nroped
            AND Ccbcdocu.flgest = 'F':
        IF LOOKUP(TRIM(Ccbcdocu.codref), 'FAC,BOL') = 0 THEN NEXT.
        /* Buscamos la FAC o BOL */
        FIND B-DOCU WHERE B-DOCU.codcia = s-codcia
            AND B-DOCU.coddoc = Ccbcdocu.codref
            AND B-DOCU.nrodoc = Ccbcdocu.nroref
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-DOCU THEN NEXT.
        /* Buscamos la Hoja de Ruta */
        FIND FIRST Di-RutaD WHERE Di-RutaD.codcia = s-codcia
            AND Di-RutaD.coddoc = 'H/R'
            AND Di-RutaD.codref = B-DOCU.coddoc
            AND Di-RutaD.nroref = B-DOCU.nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE Di-RutaD THEN NEXT.
        IF s-task-no = 0 THEN DO:
            REPEAT:
                s-task-no = RANDOM(1, 999999).
                FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
                IF NOT AVAILABLE w-report THEN LEAVE.
            END.
        END.
        CREATE w-report.
        ASSIGN
            w-report.task-no    = s-task-no
            w-report.campo-c[1] = Faccpedi.nroped
            w-report.campo-d[1] = Faccpedi.fchped
            w-report.campo-c[2] = Faccpedi.codcli
            w-report.campo-c[3] = Faccpedi.nomcli
            w-report.campo-i[1] = Faccpedi.codmon
            w-report.campo-f[1] = Faccpedi.imptot
            w-report.campo-c[5] = Ccbcdocu.nrodoc
            w-report.campo-d[2] = Ccbcdocu.fchdoc
            w-report.campo-c[6] = B-DOCU.nrodoc
            w-report.campo-d[3] = B-DOCU.fchdoc.
         FIND almtabla WHERE almtabla.Tabla = 'CN' AND almtabla.Codigo = Gn-clie.canal NO-LOCK NO-ERROR.
         IF AVAILABLE almtabla THEN w-report.campo-c[4] = almtabla.nombre.
    END.
  END.        
  HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-4 W-Win 
PROCEDURE Carga-Temporal-4 :
/*------------------------------------------------------------------------------
  Purpose:     O/D con guias de remision facturada pero que tiene H/Ruta
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF BUFFER B-DOCU FOR Ccbcdocu.
  DEF VAR x-Estado AS CHAR NO-UNDO.
  
  /* Cargamos las Ordenes de despacho */
  FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = 'O/D'
        AND Faccpedi.coddiv = s-coddiv
        AND Faccpedi.flgest <> 'A'
        AND {&CONDICION},
        FIRST Gn-clie NO-LOCK WHERE Gn-clie.codcia = cl-codcia
            AND Gn-clie.codcli = Faccpedi.codcli:
    DISPLAY
        Faccpedi.nomcli Faccpedi.nroped
        WITH FRAME f-Mensaje.
    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = 'G/R'
            AND Ccbcdocu.codped = Faccpedi.coddoc
            AND Ccbcdocu.nroped = Faccpedi.nroped
            AND Ccbcdocu.flgest = 'F':
        IF LOOKUP(TRIM(Ccbcdocu.codref), 'FAC,BOL') = 0 THEN NEXT.
        /* Buscamos la FAC o BOL */
        FIND B-DOCU WHERE B-DOCU.codcia = s-codcia
            AND B-DOCU.coddoc = Ccbcdocu.codref
            AND B-DOCU.nrodoc = Ccbcdocu.nroref
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-DOCU THEN NEXT.
        /* Buscamos la Hoja de Ruta */
        FOR EACH Di-RutaD NO-LOCK WHERE Di-RutaD.codcia = s-codcia
                AND Di-RutaD.coddoc = 'H/R'
                AND Di-RutaD.codref = B-DOCU.coddoc
                AND Di-RutaD.nroref = B-DOCU.nrodoc,
                FIRST Di-RutaC OF Di-RutaD NO-LOCK:
            IF s-task-no = 0 THEN DO:
                REPEAT:
                    s-task-no = RANDOM(1, 999999).
                    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE w-report THEN LEAVE.
                END.
            END.
            RUN alm/f-flgrut ("D", Di-RutaD.flgest, OUTPUT x-Estado).
            CREATE w-report.
            ASSIGN
                w-report.task-no    = s-task-no
                w-report.campo-c[1] = Faccpedi.nroped
                w-report.campo-d[1] = Faccpedi.fchped
                w-report.campo-c[2] = Faccpedi.codcli
                w-report.campo-c[3] = Faccpedi.nomcli
                w-report.campo-i[1] = Faccpedi.codmon
                w-report.campo-f[1] = Faccpedi.imptot
                w-report.campo-c[5] = Ccbcdocu.nrodoc
                w-report.campo-d[2] = Ccbcdocu.fchdoc
                w-report.campo-c[6] = B-DOCU.nrodoc
                w-report.campo-d[3] = B-DOCU.fchdoc
                w-report.campo-c[7] = Di-RutaC.nrodoc
                w-report.campo-d[4] = Di-RutaC.fchdoc
                w-report.campo-c[8] = x-Estado.
             FIND almtabla WHERE almtabla.Tabla = 'CN' AND almtabla.Codigo = Gn-clie.canal NO-LOCK NO-ERROR.
             IF AVAILABLE almtabla THEN w-report.campo-c[4] = almtabla.nombre.
        END.
    END.
  END.        
  HIDE FRAME f-Mensaje.

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
  DISPLAY x-NroPed-1 x-NroPed-2 x-FchDoc-1 x-FchDoc-2 x-CodCli x-NomCli x-Canal 
          x-NomCan x-Situacion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-NroPed-1 x-NroPed-2 x-FchDoc-1 x-FchDoc-2 x-CodCli x-Canal 
         x-Situacion BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

    RUN Carga-Temporal.
    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta\rbvta.prl"
        RB-REPORT-NAME = 'Seguimiento de Pedidos'
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
        RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.
    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    RUN Borra-Temporal.

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
    x-FchDoc-1 = TODAY - DAY(TODAY) + 1
    x-FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-Parametros W-Win 
PROCEDURE procesa-Parametros :
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


