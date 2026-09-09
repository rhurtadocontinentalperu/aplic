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
/*DEF INPUT PARAMETER pCodDiv AS CHAR.*/

/* Parameters Definitions ---                                           */

DEFINE SHARED VAR s-codcia  AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-coddiv  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE x-rowid AS ROWID.
DEFINE VARIABLE s-task-no AS INT.

DEF BUFFER B-TURNO FOR ExpTurno.

DEFINE VARIABLE cBlock  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodVen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomVen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNroTur AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iTurno  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iDigita AS INTEGER     NO-UNDO.

DEFINE VARIABLE s-Nuevo-Turno AS LOG NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-11 ~
FILL-IN-4 FILL-IN-8 FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-9 FILL-IN-10 ~
FILL-IN-17 rs-docu tg-print txt-codven BUTTON-3 BUTTON-2 BUTTON-4 RECT-1 ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-11 ~
FILL-IN-4 FILL-IN-8 FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-9 FILL-IN-10 ~
FILL-IN-17 rs-docu FILL-IN-15 tg-print FILL-IN-14 FILL-IN-16 txt-codven ~
txt-nomven 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print-2.ico":U
     IMAGE-INSENSITIVE FILE "img/block.ico":U
     LABEL "Button 1" 
     SIZE 10 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 10 BY 1.62.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/save.ico":U
     LABEL "Button 3" 
     SIZE 10 BY 1.62.

DEFINE BUTTON BUTTON-4 
     LABEL "BORRAR TODO" 
     SIZE 17 BY 1.12.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Ingrese el Código de Barras" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 0 FGCOLOR 14 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-10 AS CHARACTER FORMAT "X(256)":U 
     LABEL "E-Mail" 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-11 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Tarjeta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-14 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Turno" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-15 AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Entrega" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-16 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Digitación" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-17 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Nº Asistentes" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre o Razon Social" 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Codigo de Cliente / RUC" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Referencias" 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Persona Contacto" 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Telefono" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion Entrega" 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-9 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Celular" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codven AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE txt-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1 NO-UNDO.

DEFINE VARIABLE rs-docu AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Factura", "Factura",
"Boleta", "Boleta"
     SIZE 24 BY 1.08 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 10.23.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 110 BY 2.96.

DEFINE VARIABLE tg-print AS LOGICAL INITIAL yes 
     LABEL "Imprimir" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77
     FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-1 AT ROW 2.62 COL 34 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-2 AT ROW 4.23 COL 25 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-3 AT ROW 5.31 COL 25 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-11 AT ROW 5.31 COL 68 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-4 AT ROW 6.38 COL 25 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-8 AT ROW 7.46 COL 25 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-5 AT ROW 8.54 COL 25 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-6 AT ROW 9.62 COL 25 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-7 AT ROW 10.69 COL 25 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-9 AT ROW 10.69 COL 68 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-10 AT ROW 11.77 COL 25 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-17 AT ROW 12.85 COL 25 COLON-ALIGNED WIDGET-ID 62
     rs-docu AT ROW 14.42 COL 17 NO-LABEL WIDGET-ID 34
     FILL-IN-15 AT ROW 14.54 COL 56 COLON-ALIGNED WIDGET-ID 58
     tg-print AT ROW 14.54 COL 91 WIDGET-ID 42
     FILL-IN-14 AT ROW 15.62 COL 82.43 COLON-ALIGNED WIDGET-ID 56
     FILL-IN-16 AT ROW 15.62 COL 101 COLON-ALIGNED WIDGET-ID 60
     txt-codven AT ROW 15.69 COL 15 COLON-ALIGNED WIDGET-ID 52
     txt-nomven AT ROW 15.69 COL 22.14 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     BUTTON-3 AT ROW 1.54 COL 81 WIDGET-ID 44
     BUTTON-1 AT ROW 1.54 COL 91 WIDGET-ID 26
     BUTTON-2 AT ROW 1.54 COL 101 WIDGET-ID 28
     BUTTON-4 AT ROW 2.62 COL 51 WIDGET-ID 66
     "---------------------------------------" VIEW-AS TEXT
          SIZE 16 BY .35 AT ROW 1.81 COL 4 WIDGET-ID 64
     "DATOS CLIENTE" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 1.27 COL 5 WIDGET-ID 2
          FONT 6
     RECT-1 AT ROW 3.96 COL 2 WIDGET-ID 30
     RECT-2 AT ROW 14.27 COL 2 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112.72 BY 16.5 WIDGET-ID 100.


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
         TITLE              = "Datos del Cliente"
         HEIGHT             = 16.5
         WIDTH              = 112.72
         MAX-HEIGHT         = 32.23
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.23
         VIRTUAL-WIDTH      = 205.72
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
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-14 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-15 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-16 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Datos del Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Datos del Cliente */
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
    RUN Asigna-Variables.
    RUN Imprimir.
    RUN Limpia-Campos.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    RUN Asigna-Variables.  
    RUN Valida-Datos.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    RUN Graba-Datos.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    RUN Limpia-Campos.
    APPLY "entry" TO fill-in-1.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* BORRAR TODO */
DO:
  RUN Limpia-Campos.
  APPLY "entry" TO fill-in-1.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-1 W-Win
ON LEAVE OF FILL-IN-1 IN FRAME F-Main /* Ingrese el Código de Barras */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    DEFINE VARIABLE s-codcli LIKE gn-clie.codcli NO-UNDO.
    DEFINE VARIABLE l-regist AS LOGICAL          NO-UNDO INIT NO.
  
    ASSIGN FILL-IN-1.
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = fill-in-1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'Cliente NO registrado en el maestro de clientes' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /** Verifica si se ingreso su asistencia **/
    FIND LAST ExpAsist WHERE ExpAsist.Codcia = s-codcia
        AND ExpAsist.CodDiv    = s-CodDiv
        AND ExpAsist.CodCli    = fill-in-1
        AND ExpAsist.Estado[1] = "C" 
        AND (ExpAsist.Fecha >= (TODAY - 7))
        NO-LOCK NO-ERROR.
    IF NOT AVAIL ExpAsist THEN DO:
        MESSAGE "Cliente no tiene registrado Asistencia"
            VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /*******/
    ASSIGN
        FILL-IN-2   = gn-clie.NomCli
        FILL-IN-3   = gn-clie.Ruc 
        FILL-IN-4   = gn-clie.DirCli 
        FILL-IN-5   = gn-clie.Referencias 
        FILL-IN-6   = gn-clie.RepLeg[3] 
        FILL-IN-7   = gn-clie.Telfnos[1] 
        FILL-IN-8   = gn-clie.DirEnt 
        FILL-IN-9   = gn-clie.Telfnos[3] 
        FILL-IN-10  = gn-clie.E-Mail
        FILL-IN-11  = gn-clie.NroCard
        x-rowid = ROWID(gn-clie)
        txt-codven  = ''
        txt-nomven  = ''
        fill-in-14  = 0
        fill-in-16  = 0.
    IF TRUE <> (FILL-IN-3 > '') THEN FILL-IN-3 = gn-clie.codcli.

    FIND LAST ExpTurno WHERE ExpTurno.CodCia = s-codcia
        AND ExpTurno.CodDiv  = s-coddiv
        AND ExpTurno.Fecha   = TODAY
        AND ExpTurno.CodCli  = fill-in-1 NO-LOCK NO-ERROR.
    /* RHC 08/01/2014 QUE PASA SI REGRESA NUEVAMENTE */
    DEF VAR rpta AS LOG NO-UNDO.
    rpta = NO.
    s-Nuevo-Turno = YES.    /* VA A PEDIR UN TURNO SIEMPRE */
    IF AVAILABLE ExpTurno THEN DO:
        MESSAGE 'El cliente ya tiene un turno asignado el día de hoy' SKIP
            '  Vendedor:' ExpTurno.BLOCK + "-" + ExpTurno.CodVen SKIP
            '     Turno:' ExpTurno.Turno SKIP
            'Digitación:' ExpTurno.NroDig SKIP(1)
            'Seleccione:' SKIP
            'SI: para REIMPRIMIR FICHA' SKIP
            'NO: para NUEVO TURNO DE ATENCIÓN'
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL
            UPDATE rpta.
        IF rpta = ? THEN RETURN NO-APPLY.
        IF rpta = YES THEN s-Nuevo-Turno = NO.  /* SOLO REIMPRESION DE FORMATO */
    END.
    /*IF AVAIL ExpTurno THEN DO:*/
    IF s-Nuevo-Turno = NO THEN DO:  /* REIMPRESION */
        BUTTON-1:SENSITIVE = YES.
        txt-codven = ExpTurno.BLOCK + '-' + ExpTurno.Codven.            
        FIND FIRST gn-ven WHERE gn-ven.codcia = ExpTurno.CodCia
            AND gn-ven.CodVen = ExpTurno.CodVen NO-LOCK NO-ERROR.
        ASSIGN 
            txt-codven  = ExpTurno.BLOCK + "-" + ExpTurno.CodVen
            txt-nomven  = gn-ven.nomven
            fill-in-14  = ExpTurno.Turno
            fill-in-16  = ExpTurno.NroDig
            txt-codven:SENSITIVE = NO.
    END.
    ELSE ASSIGN 
            BUTTON-1:SENSITIVE = NO
            txt-codven:SENSITIVE = YES.

    /*Fecha Entrega*/
    FIND LAST ExpAsist WHERE ExpAsist.CodCia = s-codcia
        AND ExpAsist.CodDiv = s-CodDiv
        AND ExpAsist.CodCli = fill-in-1
        AND ExpAsist.Fecha = TODAY NO-LOCK NO-ERROR.
    IF AVAIL ExpAsist THEN 
        ASSIGN 
            fill-in-15 = ExpAsist.Libre_f01
            fill-in-17 = ExpAsist.Asistentes
            rs-docu:SCREEN-VALUE = ExpAsist.libre_c02.
    DISPLAY 
        FILL-IN-2 FILL-IN-3 FILL-IN-4 FILL-IN-5 FILL-IN-6 FILL-IN-7 
        FILL-IN-8 FILL-IN-9 FILL-IN-10 FILL-IN-11 FILL-IN-14 FILL-IN-15 
        FILL-IN-16 FILL-IN-17 rs-docu txt-codven txt-nomven
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-codven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-codven W-Win
ON MOUSE-SELECT-DBLCLICK OF txt-codven IN FRAME F-Main /* Vendedor */
DO:

    /**
    RUN VtaExp/w-exp007.w (fill-in-1, OUTPUT cBlock, OUTPUT cCodVen, OUTPUT cNomVen, OUTPUT iTurno, OUTPUT iDigita).
    **/

    RUN VtaExp/w-exp007-1 (fill-in-1, OUTPUT cBlock, OUTPUT cCodVen, OUTPUT cNomVen, OUTPUT iTurno).
    
    IF cBlock <> '' THEN
        ASSIGN 
            txt-codven = cBlock + '-' + cCodVen
            fill-in-14 = iTurno.

    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
        gn-ven.codven = ENTRY(2,txt-CodVen,'-') NO-LOCK NO-ERROR.
    IF AVAIL gn-ven THEN txt-nomven = Gn-ven.NomVen.
    DISPLAY txt-codven txt-nomven fill-in-14 WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN 
            FILL-IN-1 FILL-IN-10 FILL-IN-11 FILL-IN-2 FILL-IN-3 FILL-IN-4 
            FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 FILL-IN-9 rs-docu 
            txt-codven tg-print FILL-IN-14 FILL-IN-15 FILL-IN-16 FILL-IN-17.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Temporal W-Win 
PROCEDURE Crea-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iInt    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNroDig AS INTEGER     NO-UNDO.

    FILE-INFO:FILE-NAME = SEARCH('c:\newsie\on_in_co\test\logo-expo.bmp').
    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                        NO-LOCK)
        THEN LEAVE.
    END.

    DO iInt = 1 TO 2:
        FIND FIRST w-report WHERE task-no = s-task-no 
            AND llave-c = fill-in-1
            AND llave-i = iInt 
            NO-LOCK NO-ERROR.
        IF NOT AVAIL w-report THEN DO:
            CREATE w-report.
            ASSIGN 
                w-report.task-no     = s-task-no
                w-report.llave-i     = iInt     
                w-report.llave-c     = FILL-IN-1     
                w-report.Campo-C[1]  = FILL-IN-2     
                w-report.Campo-C[2]  = FILL-IN-3     
                w-report.Campo-C[3]  = FILL-IN-4     
                w-report.Campo-C[4]  = FILL-IN-5     
                w-report.Campo-C[5]  = FILL-IN-6     
                w-report.Campo-C[6]  = FILL-IN-7     
                w-report.Campo-C[7]  = FILL-IN-8     
                w-report.Campo-C[8]  = FILL-IN-9     
                w-report.Campo-C[9]  = FILL-IN-10    
                w-report.Campo-C[10] = FILL-IN-11  
                w-report.Campo-C[11] = rs-docu
                w-report.Campo-C[12] = SUBSTRING(txt-codven,1,1) + STRING(FILL-IN-14,'9999')
                w-report.Campo-C[20] = FILE-INFO:FULL-PATHNAME
                w-report.Campo-D[1]  = FILL-IN-15.
            /* Numero de Digitación */
            w-report.Campo-I[1] = FILL-IN-16.   /* OJO */
/*             FIND LAST ExpTurno WHERE ExpTurno.CodCia = s-codcia */
/*                 AND ExpTurno.CodDiv = s-coddiv                  */
/*                 AND ExpTurno.Fecha  = TODAY NO-LOCK NO-ERROR.   */
/*             IF AVAIL ExpTurno THEN                              */
/*                 w-report.Campo-I[1]  = ExpTurno.NroDig.         */
        END.
    END.

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
  DISPLAY FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-11 FILL-IN-4 FILL-IN-8 FILL-IN-5 
          FILL-IN-6 FILL-IN-7 FILL-IN-9 FILL-IN-10 FILL-IN-17 rs-docu FILL-IN-15 
          tg-print FILL-IN-14 FILL-IN-16 txt-codven txt-nomven 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-11 FILL-IN-4 FILL-IN-8 FILL-IN-5 
         FILL-IN-6 FILL-IN-7 FILL-IN-9 FILL-IN-10 FILL-IN-17 rs-docu tg-print 
         txt-codven BUTTON-3 BUTTON-2 BUTTON-4 RECT-1 RECT-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Datos W-Win 
PROCEDURE Graba-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Turno AS INT INIT 1 NO-UNDO. 
DEF VAR iNroDig AS INT        NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST gn-clie WHERE ROWID(gn-clie) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE 'No se pudo localizar el cliente' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        gn-clie.NomCli       = FILL-IN-2   
        gn-clie.Ruc          = FILL-IN-3   
        gn-clie.DirCli       = FILL-IN-4   
        gn-clie.Referencias  = FILL-IN-5   
        gn-clie.RepLeg[3]    = FILL-IN-6   
        gn-clie.Telfnos[1]   = FILL-IN-7   
        gn-clie.DirEnt       = FILL-IN-8   
        gn-clie.Telfnos[3]   = FILL-IN-9   
        gn-clie.E-Mail       = FILL-IN-10  
        gn-clie.NroCard      = FILL-IN-11  
        gn-clie.CodVen       = SUBSTRING(txt-codven,3) .
    /*Graba Referencia*/
    FIND FIRST ExpAsist WHERE ExpAsist.CodCia = s-codcia
        AND ExpAsist.CodDiv = s-CodDiv
        AND ExpAsist.Fecha  = TODAY
        AND ExpAsist.CodCli = gn-clie.codcli EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF AVAIL ExpAsist THEN DO:
        ASSIGN
            ExpAsist.Libre_f01  = fill-in-15  /*Fecha Entrega*/
            ExpAsist.Asistentes = fill-in-17
            ExpAsist.libre_c02  = rs-docu.
        IF ExpAsist.Estado[1] <> "C" 
            THEN ASSIGN
                    ExpAsist.Estado[1]     = 'C'
                    ExpAsist.Fecha         = TODAY     /*Campo Referencial*/
                    ExpAsist.Hora          = STRING(TIME,"HH:MM:SS")
                    ExpAsist.usuario       = s-user-id.
    END.
    /*Graba Turno*/
    IF s-Nuevo-Turno = YES THEN DO:
        x-Turno = 1.
        FOR EACH B-TURNO NO-LOCK WHERE b-turno.codcia = s-CodCia
            AND b-turno.coddiv = s-coddiv
            AND b-turno.block  = SUBSTRING(txt-codven,1,1)
            AND b-turno.fecha  = TODAY
            AND b-turno.tipo   = 'V' BY B-TURNO.Turno:
            x-Turno = b-turno.turno + 1.
        END.
        CREATE ExpTurno.
        ASSIGN
            ExpTurno.CodCia  = s-CodCia
            ExpTurno.CodDiv  = s-CodDiv
            ExpTurno.Block   = SUBSTRING(txt-codven,1,1)
            ExpTurno.Fecha   = TODAY
            ExpTurno.Hora    = STRING(TIME, 'HH:MM')
            ExpTurno.Tipo    = 'V'
            ExpTurno.Usuario = s-user-id
            ExpTurno.CodVen  = SUBSTRING(txt-codven,3)
            ExpTurno.Turno   = x-Turno
            ExpTurno.CodCli  = fill-in-1
            ExpTurno.NroDig  = NEXT-VALUE(NumSecIngExp)
            ExpTurno.Libre_c01 = STRING (DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
            /*ExpTurno.Estado  = "G".       /* Por asignar digitador */*/
            ExpTurno.Estado  = "P".       /* Generado en recepción */
        ASSIGN
            FILL-IN-14 = ExpTurno.Turno
            FILL-IN-16 = ExpTurno.NroDig.
    END.
/*     x-Turno = 1.                                             */
/*     FOR EACH B-TURNO NO-LOCK WHERE b-turno.codcia = s-CodCia */
/*         AND b-turno.coddiv = s-coddiv                        */
/*         AND b-turno.block  = SUBSTRING(txt-codven,1,1)       */
/*         AND b-turno.fecha  = TODAY                           */
/*         AND b-turno.tipo   = 'V' BY B-TURNO.Turno:           */
/*         x-Turno = b-turno.turno + 1.                         */
/*     END.                                                     */
/*     FIND FIRST ExpTurno WHERE ExpTurno.CodCia = s-codcia                                */
/*         AND ExpTurno.CodDiv  = s-coddiv                                                 */
/*         AND ExpTurno.BLOCK   = SUBSTRING(txt-codven,1,1)                                */
/*         AND ExpTurno.Fecha   = TODAY                                                    */
/*         AND ExpTurno.CodCli  = fill-in-1 NO-LOCK NO-ERROR.                              */
/*     IF NOT AVAIL ExpTurno THEN DO:                                                      */
/*         CREATE ExpTurno.                                                                */
/*         ASSIGN                                                                          */
/*             ExpTurno.CodCia  = s-CodCia                                                 */
/*             ExpTurno.CodDiv  = s-CodDiv                                                 */
/*             ExpTurno.Block   = SUBSTRING(txt-codven,1,1)                                */
/*             ExpTurno.Fecha   = TODAY                                                    */
/*             ExpTurno.Hora    = STRING(TIME, 'HH:MM')                                    */
/*             ExpTurno.Tipo    = 'V'                                                      */
/*             ExpTurno.Usuario = s-user-id                                                */
/*             ExpTurno.CodVen  = SUBSTRING(txt-codven,3)                                  */
/*             ExpTurno.Turno   = x-Turno                                                  */
/*             ExpTurno.CodCli  = fill-in-1                                                */
/*             ExpTurno.NroDig  = NEXT-VALUE(NumSecIngExp)                                 */
/*             ExpTurno.Libre_c01 = STRING (DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS') */
/*             ExpTurno.Estado  = "P".       /* Generado en recepción */                   */
/*         ASSIGN                                                                          */
/*             FILL-IN-14 = ExpTurno.Turno                                                 */
/*             FILL-IN-16 = ExpTurno.NroDig.                                               */
/*     END.                                                                                */
END.
iNroDig = CURRENT-VALUE(NumSecIngExp).
IF AVAILABLE(ExpTurno) THEN RELEASE ExpTurno.
IF AVAILABLE(ExpAsist) THEN RELEASE ExpAsist.
IF AVAILABLE(gn-clie)  THEN RELEASE gn-clie.

RUN Imprimir.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Turno W-Win 
PROCEDURE Graba-Turno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Turno AS INT INIT 1 NO-UNDO. 
  DEF VAR iNroDig AS INT        NO-UNDO.
          
  FOR EACH B-TURNO NO-LOCK WHERE b-turno.codcia = s-CodCia
      AND b-turno.coddiv = s-coddiv
      AND b-turno.block  = SUBSTRING(txt-codven,1,1)
      AND b-turno.fecha  = TODAY
      AND b-turno.tipo   = 'V' BY B-TURNO.Turno:
      x-Turno = b-turno.turno + 1.
  END.
    
  /*Graba Turno*/
  FIND FIRST ExpTurno WHERE ExpTurno.CodCia = s-codcia
      AND ExpTurno.CodDiv  = s-coddiv
      AND ExpTurno.BLOCK   = SUBSTRING(txt-codven,1,1)
      AND ExpTurno.Fecha   = TODAY
      AND ExpTurno.CodCli  = fill-in-1 NO-LOCK NO-ERROR.
  IF NOT AVAIL ExpTurno THEN DO:
      CREATE ExpTurno.
      ASSIGN
          ExpTurno.CodCia  = s-CodCia
          ExpTurno.CodDiv  = s-CodDiv
          ExpTurno.Block   = SUBSTRING(txt-codven,1,1)
          ExpTurno.Fecha   = TODAY
          ExpTurno.Hora    = STRING(TIME, 'HH:MM')
          ExpTurno.Tipo    = 'V'
          ExpTurno.Usuario = s-user-id
          ExpTurno.CodVen  = SUBSTRING(txt-codven,3)
          ExpTurno.Turno   = x-Turno
          ExpTurno.CodCli  = fill-in-1
          ExpTurno.NroDig  = NEXT-VALUE(NumSecIngExp)
          ExpTurno.Libre_c01 = STRING (DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
          ExpTurno.Estado  = "P".       /* Generado en recepción */
  END.

  /*Graba Referencia*/
  FIND FIRST ExpAsist WHERE ExpAsist.CodCia = s-codcia
      AND ExpAsist.CodDiv = s-CodDiv
      AND ExpAsist.Fecha  = TODAY
      AND ExpAsist.CodCli = FILL-IN-1 NO-ERROR.
  IF AVAIL ExpAsist THEN DO:
      ASSIGN
        ExpAsist.Libre_f01  = fill-in-15  /*Fecha Entrega*/
        ExpAsist.Asistentes = fill-in-17
        ExpAsist.libre_c02  = rs-docu.
  END.
  IF AVAILABLE(ExpTurno) THEN RELEASE ExpTurno.
  IF AVAILABLE(ExpAsist) THEN RELEASE ExpAsist.

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
    
    RUN Crea-Temporal.
    
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE 'NO hay registros para imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
        
    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
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
    
    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'.
    RB-REPORT-NAME = 'Ticket Expo'.
    RB-INCLUDE-RECORDS = "O".
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                " AND w-report.llave-c = '" + FILL-IN-1 + "'".


/*     RUN lib/_imprime2 (RB-REPORT-LIBRARY,                 */
/*                        RB-REPORT-NAME,                    */
/*                        RB-INCLUDE-RECORDS,                */
/*                        RB-FILTER,                         */
/*                        RB-OTHER-PARAMETERS).              */
/*     FOR EACH w-report WHERE w-report.task-no = s-task-no: */
/*         DELETE w-report.                                  */
/*     END.                                                  */


    /* RHC 19/12/2013 USA LA IMPRESORA POR DEFECTO */
    DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

    GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
    GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

    ASSIGN cDelimeter = CHR(32).
    IF NOT (cDatabaseName = ? OR
        cHostName = ? OR
        cNetworkProto = ? OR
        cPortNumber = ?) THEN DO:

        DEFINE VAR x-rb-user AS CHAR.
        DEFINE VAR x-rb-pass AS CHAR.

        RUN lib/RB_credenciales(OUTPUT x-rb-user, OUTPUT x-rb-pass).

        IF x-rb-user = "**NOUSER**" THEN DO:
            MESSAGE "No se pudieron ubicar las credenciales para" SKIP
                    "la conexion del REPORTBUILDER" SKIP
                    "--------------------------------------------" SKIP
                    "Comunicarse con el area de sistemas - desarrollo"
                VIEW-AS ALERT-BOX INFORMATION.

            RETURN "ADM-ERROR".
        END.
        /*
        ASSIGN
            cNewConnString =
            "-db" + cDelimeter + cDatabaseName + cDelimeter +
            "-H" + cDelimeter + cHostName + cDelimeter +
            "-N" + cDelimeter + cNetworkProto + cDelimeter +
            "-S" + cDelimeter + cPortNumber + cDelimeter +
            "-U " + x-rb-user  + cDelimeter + cDelimeter +
            "-P " + x-rb-pass + cDelimeter + cDelimeter.
        */

        ASSIGN
            cNewConnString =
            "-db" + cDelimeter + cDatabaseName + cDelimeter +
            "-H" + cDelimeter + cHostName + cDelimeter +
            "-N" + cDelimeter + cNetworkProto + cDelimeter +
            "-S" + cDelimeter + cPortNumber + cDelimeter +
            "-U " + x-rb-user  + cDelimeter + cDelimeter +
            "-P " + x-rb-pass + cDelimeter + cDelimeter.
            /*
            "-U usrddigger" + cDelimeter + cDelimeter +
            "-P udd1456" + cDelimeter + cDelimeter.
            */
        RB-DB-CONNECTION = cNewConnString.
    END.
    RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                        RB-REPORT-NAME,
                        RB-DB-CONNECTION,
                        RB-INCLUDE-RECORDS,
                        RB-FILTER,
                        RB-MEMO-FILE,
                        RB-PRINT-DESTINATION,
                        RB-PRINTER-NAME,
                        RB-PRINTER-PORT,
                        RB-OUTPUT-FILE,
                        RB-NUMBER-COPIES,
                        RB-BEGIN-PAGE,
                        RB-END-PAGE,
                        RB-TEST-PATTERN,
                        RB-WINDOW-TITLE,
                        RB-DISPLAY-ERRORS,
                        RB-DISPLAY-STATUS,
                        RB-NO-WAIT,
                        RB-OTHER-PARAMETERS,
                        "").

    FOR EACH w-report WHERE w-report.task-no = s-task-no:
        DELETE w-report.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpia-Campos W-Win 
PROCEDURE Limpia-Campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
    button-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    
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

  DEFINE VARIABLE cNomVen AS CHARACTER   NO-UNDO FORMAT "X(100)".

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'ENTRY':U TO FILL-IN-1 IN FRAME {&FRAME-NAME}.

  /****

  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH ExpTermi WHERE ExpTermi.Codcia = s-codcia
          AND ExpTermi.CodDiv = s-coddiv NO-LOCK,
          FIRST gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = ExpTermi.CodVen NO-LOCK:
          cNomVen = gn-ven.codven + "-" + REPLACE(gn-ven.NomVen,",","").
          cb-codven:ADD-LAST(cNomVen).
      END.
  END.

  **********/
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
        WHEN "x-subfam" THEN
            ASSIGN
                input-var-1 = ""
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Datos W-Win 
PROCEDURE Valida-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iNroAte AS INTEGER     NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        /*Valida Fecha de Entrega*/
        IF fill-in-15 <> ? THEN
        FIND gn-divi WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
        IF AVAIL gn-divi THEN DO:
            iNroAte = 0.
            FOR EACH ExpAsist WHERE ExpAsist.CodCia = s-codcia
                AND ExpAsist.CodDiv = s-CodDiv
                AND ExpAsist.Libre_f01 = fill-in-15 NO-LOCK :
                iNroAte = iNroAte + 1.            
            END.
            IF iNroAte > GN-DIVI.DiasAmpCot THEN DO:
                MESSAGE "Número de Despacho Completo" SKIP
                        "Para el día " + STRING(FILL-IN-15)
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                APPLY "entry" TO fill-in-15.
                RETURN "adm-error".
            END.
        END.   

        /*Vendedor en Blanco*/
        FIND gn-ven WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = ENTRY(2,txt-codven,'-')
            NO-LOCK NO-ERROR.
        IF txt-codven = '' OR FILL-IN-14 = 0 OR NOT AVAILABLE gn-ven THEN DO:
            MESSAGE "Debe Separar TURNO Para Este Cliente"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY "entry" TO txt-codven.
            RETURN "adm-error".
        END.
        /* Terminal de Venta */
        FIND FIRST ExpTermi WHERE ExpTermi.CodCia = s-codcia
            AND ExpTermi.CodDiv = s-coddiv
            AND ExpTermi.BLOCK = ENTRY(1,txt-codven,'-')
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ExpTermi THEN DO:
            MESSAGE 'ERROR: Vuelva a ingresar el Vendedor' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO txt-codven.
            RETURN 'ADM-ERROR'.
        END.

        /* numero de card */
        IF fill-in-11 NE '' THEN DO:
            FIND gn-card WHERE gn-card.nrocard = fill-in-11 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-card THEN DO:
                MESSAGE 'Tarjeta no existe' VIEW-AS ALERT-BOX ERROR.
                APPLY 'entry' TO fill-in-11.
                RETURN 'ADM-ERROR'.
            END.
        END.

    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

