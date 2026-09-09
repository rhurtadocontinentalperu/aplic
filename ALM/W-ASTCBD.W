&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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
SESSION:DATE-FORMAT = "dmy".

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR s-codcia  AS INTEGER.
DEFINE SHARED VAR s-nomcia  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE NEW SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5" .
DEFINE NEW SHARED VARIABLE CB-MaxNivel AS INTEGER .

DEFINE VAR cb-codcia AS INTEGER INITIAL 0 NO-UNDO.

DEFINE NEW SHARED TEMP-TABLE t-prev
    FIELD Tipo AS CHAR
    FIELD Subalm AS CHAR
    FIELD Codmov AS INTEGER
    FIELD NroGui AS CHAR
    FIELD Periodo LIKE cb-dmov.periodo
    FIELD NroMes LIKE cb-dmov.nromes
    FIELD Codope LIKE cb-dmov.codope
    FIELD Codcta LIKE cb-dmov.codcta
    FIELD CodDiv LIKE cb-dmov.coddiv
    FIELD Codmon LIKE cb-dmov.codmon
    FIELD Fchdoc LIKE cb-dmov.fchdoc
    FIELD Coddoc LIKE cb-dmov.coddoc
    FIELD Nrodoc LIKE cb-dmov.nrodoc
    FIELD Glodoc LIKE cb-dmov.glodoc
    FIELD Tpocmb LIKE cb-dmov.tpocmb
    FIELD TpoMov LIKE cb-dmov.tpomov
    FIELD ImpMn1 LIKE cb-dmov.impmn1 
    FIELD ImpMn2 LIKE cb-dmov.impmn2
    FIELD cco    LIKE cb-dmov.cco  
    FIELD clfaux LIKE cb-dmov.Clfaux
    FIELD codaux LIKE cb-dmov.Codaux
    FIELD Codref LIKE cb-dmov.codref
    FIELD Nroref LIKE cb-dmov.nroref
    INDEX IDX01 Tipo.

RUN ADM/CB-NIVEL.P (S-CODCIA , OUTPUT CB-Niveles , OUTPUT CB-MaxNivel ).

DEFINE VAR Lista AS CHAR NO-UNDO.
DEFINE VARIABLE s-NroMesCie AS LOGICAL INITIAL YES.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
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
&Scoped-Define ENABLED-OBJECTS RECT-15 RECT-13 RECT-14 RECT-17 ~
B-Pre-asiento RADIO-SET-1 F-DIVISION FILL-IN-Subalm FILL-IN-Periodo ~
BUTTON-4 FILL-IN-codmov C-mes BUTTON-5 C-Pre-asiento 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 F-DIVISION FILL-IN-Desdiv ~
FILL-IN-Dessub FILL-IN-Subalm FILL-IN-Periodo FILL-IN-codmov FILL-IN-desmov ~
C-mes FILL-IN-fchast C-Pre-asiento 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-astcbd AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Pre-asiento 
     LABEL "Generar Pre-asiento" 
     SIZE 15.57 BY .85.

DEFINE BUTTON B-Transferir 
     LABEL "Transferir Asiento" 
     SIZE 15.57 BY .85.

DEFINE BUTTON BUTTON-4 
     LABEL "Salir" 
     SIZE 15.57 BY .85.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\b-print":U
     LABEL "Imprimir" 
     SIZE 8.14 BY 2.15.

DEFINE VARIABLE C-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6.72 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-Pre-asiento AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pre-asiento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-codmov AS CHARACTER FORMAT "XX":U 
     LABEL "Cod.Mov." 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Desdiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-desmov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Dessub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fchast AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Subalm AS CHARACTER FORMAT "xxx":U 
     LABEL "Sub-Almacen" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ingreso", "I",
"Salida", "S"
     SIZE 9.14 BY 1.27 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 1.65.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.57 BY 3.85.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 1.46.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 2.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     B-Pre-asiento AT ROW 1.42 COL 69.29
     RADIO-SET-1 AT ROW 1.58 COL 5.57 NO-LABEL
     F-DIVISION AT ROW 1.73 COL 20.29
     FILL-IN-Desdiv AT ROW 1.73 COL 34 COLON-ALIGNED NO-LABEL
     B-Transferir AT ROW 2.38 COL 69.29
     FILL-IN-Dessub AT ROW 2.62 COL 34 COLON-ALIGNED NO-LABEL
     FILL-IN-Subalm AT ROW 2.65 COL 28.29 COLON-ALIGNED
     FILL-IN-Periodo AT ROW 3.23 COL 8.57 COLON-ALIGNED
     BUTTON-4 AT ROW 3.5 COL 69.29
     FILL-IN-codmov AT ROW 3.58 COL 28.29 COLON-ALIGNED
     FILL-IN-desmov AT ROW 3.58 COL 34 COLON-ALIGNED NO-LABEL
     C-mes AT ROW 4.12 COL 8.57 COLON-ALIGNED
     BUTTON-5 AT ROW 4.5 COL 73.43
     FILL-IN-fchast AT ROW 5.62 COL 46.43 COLON-ALIGNED
     C-Pre-asiento AT ROW 5.73 COL 14.86 COLON-ALIGNED
     RECT-15 AT ROW 5.31 COL 3.14
     RECT-13 AT ROW 1.35 COL 3.14
     RECT-14 AT ROW 1.31 COL 18.57
     RECT-17 AT ROW 3.04 COL 3.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.57 BY 17
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
         TITLE              = "Generacion de Asiento Contable"
         HEIGHT             = 15.35
         WIDTH              = 87.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 91.43
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

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON B-Transferir IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DIVISION IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-Desdiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-desmov IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Dessub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-fchast IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de Asiento Contable */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Asiento Contable */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Pre-asiento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Pre-asiento W-Win
ON CHOOSE OF B-Pre-asiento IN FRAME F-Main /* Generar Pre-asiento */
DO:
  ASSIGN
     FILL-IN-codmov FILL-IN-fchast FILL-IN-Periodo FILL-IN-Subalm F-Division C-mes RADIO-SET-1.

  IF C-mes = 0 THEN DO:
     MESSAGE 'Mes no asignado' VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO C-mes.
     RETURN NO-APPLY.
  END.
  IF FILL-IN-fchast = ? THEN DO:
     MESSAGE 'Fecha no asignada' VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO FILL-IN-fchast.
     RETURN NO-APPLY.
  END.
/*
  IF FILL-IN-tpocmb = 0 THEN DO:
     MESSAGE 'Tipo de cambio no registrado' VIEW-AS ALERT-BOX.
     APPLY "ENTRY" TO FILL-IN-tpocmb.
     RETURN NO-APPLY.     
  END.
*/    
  Lista = ''.
  RUN Genera-Pre-asiento.
  
  DO WITH FRAME {&FRAME-NAME}:
     C-Pre-asiento:SENSITIVE = Yes.
  END.
  
  C-Pre-asiento:LIST-ITEMS = Lista.  
  C-Pre-asiento:SCREEN-VALUE = ENTRY(1,Lista).
  C-Pre-asiento = ENTRY(1,Lista).
  RUN dispatch IN h_p-updv10 ('view':U).
  RUN Abrir-browse IN h_b-astcbd
    (INPUT C-Pre-asiento).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Transferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Transferir W-Win
ON CHOOSE OF B-Transferir IN FRAME F-Main /* Transferir Asiento */
DO:
  FIND cb-peri WHERE cb-peri.CodCia  = s-codcia  AND
                     cb-peri.Periodo = FILL-IN-Periodo NO-LOCK.
  IF AVAILABLE cb-peri THEN
     s-NroMesCie = cb-peri.MesCie[C-mes + 1].
     
  IF s-NroMesCie THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  RUN Transferir-asiento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Salir */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Imprimir */
DO:
  RUN Pre-impresion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-mes W-Win
ON LEAVE OF C-mes IN FRAME F-Main /* Mes */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        CASE INPUT C-mes:
            WHEN 1 OR
                WHEN 3 OR
                WHEN 5 OR
                WHEN 7 OR
                WHEN 8 OR
                WHEN 10 OR
                WHEN 12 THEN
                DISPLAY DATE(INPUT C-mes,31,INPUT FILL-IN-periodo) @ FILL-IN-fchast.
            WHEN 4 OR
                WHEN 6 OR
                WHEN 7 OR
                WHEN 9 THEN
                DISPLAY DATE(INPUT C-mes,30,INPUT FILL-IN-periodo) @ FILL-IN-fchast.
            WHEN 2 THEN
                DISPLAY DATE(3,1,INPUT FILL-IN-periodo) - 1 @ FILL-IN-fchast.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-mes W-Win
ON VALUE-CHANGED OF C-mes IN FRAME F-Main /* Mes */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        CASE INPUT C-mes:
            WHEN 1 OR
                WHEN 3 OR
                WHEN 5 OR
                WHEN 7 OR
                WHEN 8 OR
                WHEN 10 OR
                WHEN 12 THEN
                DISPLAY DATE(INPUT C-mes,31, INPUT FILL-IN-periodo) @ FILL-IN-fchast.
            WHEN 4 OR
                WHEN 6 OR
                WHEN 7 OR
                WHEN 9 THEN
                DISPLAY DATE(INPUT C-mes,30, INPUT FILL-IN-periodo) @ FILL-IN-fchast.
            WHEN 2 THEN
                DISPLAY DATE(3,1,INPUT FILL-IN-periodo) - 1 @ FILL-IN-fchast.
        END.
        FIND gn-tcmb WHERE gn-tcmb.fecha = DATE(FILL-IN-fchast:SCREEN-VALUE) NO-LOCK NO-ERROR.
        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-Pre-asiento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Pre-asiento W-Win
ON VALUE-CHANGED OF C-Pre-asiento IN FRAME F-Main /* Pre-asiento */
DO:
  ASSIGN C-Pre-asiento.
  RUN Abrir-browse IN h_b-astcbd
  (INPUT C-Pre-asiento).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION W-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:
  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN F-DIVISION.
    FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                       Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-Divi THEN DO:
        MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
                "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.  
    DISPLAY Gn-Divi.DesDiv @ FILL-IN-DesDiv.  
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codmov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codmov W-Win
ON LEAVE OF FILL-IN-codmov IN FRAME F-Main /* Cod.Mov. */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF FILL-IN-codmov:SCREEN-VALUE <> '' THEN DO:
       FIND Almtmovm WHERE Almtmovm.CodCia = s-codcia AND
            Almtmovm.Tipmov = RADIO-SET-1:SCREEN-VALUE AND 
            Almtmovm.Codmov = INTEGER(FILL-IN-codmov:SCREEN-VALUE) NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almtmovm THEN DO:
          MESSAGE 'Codigo de movimiento no existe' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       FILL-IN-desmov:SCREEN-VALUE = Almtmovm.Desmov.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-fchast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-fchast W-Win
ON LEAVE OF FILL-IN-fchast IN FRAME F-Main /* Fecha */
DO:
  ASSIGN
     FILL-IN-fchast.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Subalm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Subalm W-Win
ON LEAVE OF FILL-IN-Subalm IN FRAME F-Main /* Sub-Almacen */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    IF SELF:SCREEN-VALUE <> '' THEN DO:
       FIND Almacen WHERE Almacen.CodCia = s-codcia AND 
            Almacen.CodAlm = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almacen THEN DO:
          MESSAGE 'Codigo de Almacen no existe' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       IF Almacen.CodDiv <> F-DIVISION THEN DO:
          MESSAGE 'Almacen No pertenece a Division ' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
       END.
       FILL-IN-Dessub:SCREEN-VALUE = Almacen.Descripcion.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 W-Win
ON LEAVE OF RADIO-SET-1 IN FRAME F-Main
DO:
    ASSIGN RADIO-SET-1.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/b-astcbd.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-astcbd ).
       RUN set-position IN h_b-astcbd ( 6.85 , 1.72 ) NO-ERROR.
       RUN set-size IN h_b-astcbd ( 7.92 , 86.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv10.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 14.92 , 15.29 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.42 , 57.72 ) NO-ERROR.

       /* Links to SmartBrowser h_b-astcbd. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-astcbd ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-astcbd ,
             C-Pre-asiento:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             h_b-astcbd , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anula-asto W-Win 
PROCEDURE anula-asto :
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.

DEFINE BUFFER C-DMOV FOR CB-DMOV.

FOR EACH CB-DMOV WHERE
    CB-DMOV.codcia  = p-codcia AND
    CB-DMOV.periodo = p-periodo AND
    CB-DMOV.nromes  = p-mes AND
    CB-DMOV.codope  = p-codope AND
    CB-DMOV.nroast  = p-nroast:
    FOR EACH C-DMOV WHERE C-DMOV.RELACION = RECID(CB-DMOV) :
        RUN cbd/cb-acmd.p(RECID(C-DMOV),NO,YES).
        DELETE C-DMOV.
    END.
    RUN cbd/cb-acmd.p(RECID(CB-DMOV),NO,YES).
    DELETE CB-DMOV.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anula-temporal W-Win 
PROCEDURE anula-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-codcia  AS INTEGER.
DEFINE INPUT PARAMETER p-periodo AS INTEGER.
DEFINE INPUT PARAMETER p-mes     AS INTEGER.
DEFINE INPUT PARAMETER p-codope  AS CHARACTER.
DEFINE INPUT PARAMETER p-nroast  AS CHARACTER.
FOR EACH T-CB-DMOV WHERE
    T-CB-DMOV.codcia  = p-codcia AND
    T-CB-DMOV.periodo = p-periodo AND
    T-CB-DMOV.nromes  = p-mes AND
    T-CB-DMOV.codope  = p-codope AND
    T-CB-DMOV.nroast  = p-nroast:
    DELETE T-CB-DMOV.
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
  DISPLAY RADIO-SET-1 F-DIVISION FILL-IN-Desdiv FILL-IN-Dessub FILL-IN-Subalm 
          FILL-IN-Periodo FILL-IN-codmov FILL-IN-desmov C-mes FILL-IN-fchast 
          C-Pre-asiento 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-15 RECT-13 RECT-14 RECT-17 B-Pre-asiento RADIO-SET-1 F-DIVISION 
         FILL-IN-Subalm FILL-IN-Periodo BUTTON-4 FILL-IN-codmov C-mes BUTTON-5 
         C-Pre-asiento 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pre-asiento W-Win 
PROCEDURE Genera-Pre-asiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH t-prev:
  DELETE t-prev.
END.



IF FILL-IN-Subalm = '' THEN 
   IF FILL-IN-codmov = '' THEN
      FOR EACH Almacen WHERE Almacen.codcia = S-CODCIA   AND
                             Almacen.Coddiv = F-DIVISION AND
                             Almacen.FlgRep = YES NO-LOCK:
         
         
         FOR EACH Almtmovm WHERE Almtmovm.CodCia = s-codcia AND
                                 Almtmovm.tipmov = RADIO-SET-1 AND
                                 Almtmovm.Movtrf = NO NO-LOCK:
            
            RUN Proc-Almacen (Almacen.CodAlm, 
                              Almacen.CodDiv, 
                              Almtmovm.Codmov, 
                              Almtmovm.MovCmp).
         END.
      END.
   ELSE DO:
      FIND Almtmovm WHERE Almtmovm.codcia = s-codcia AND  
                          Almtmovm.tipmov = RADIO-SET-1 AND  
                          Almtmovm.codmov = INTEGER(FILL-IN-codmov) AND
                          Almtmov.Movtrf  = NO NO-LOCK NO-ERROR.
      IF AVAILABLE Almtmovm THEN DO:

         FOR EACH Almacen WHERE Almacen.codcia = S-CODCIA   AND
                                Almacen.Coddiv = F-DIVISION AND
                                Almacen.FlgRep = YES NO-LOCK:
    
            RUN Proc-Almacen (Almacen.CodAlm, 
                              Almacen.CodDiv, 
                              Almtmovm.Codmov, 
                              Almtmovm.MovCmp).
         END.
      END.
   END.
ELSE DO:
   FIND Almacen WHERE Almacen.codcia = S-CODCIA AND 
                      Almacen.codalm = FILL-IN-Subalm AND
                      Almacen.FlgRep = YES NO-LOCK NO-ERROR.
   IF AVAILABLE Almacen THEN DO:

      IF FILL-IN-codmov = '' THEN
         FOR EACH Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND 
                                 Almtmovm.tipmov = RADIO-SET-1 AND
                                 Almtmov.MovTrf  = NO NO-LOCK:

            RUN Proc-Almacen (Almacen.CodAlm, 
                              Almacen.CodDiv, 
                              Almtmovm.Codmov, 
                              Almtmovm.MovCmp).
         END.
      ELSE DO:
         FIND Almtmovm WHERE Almtmovm.codcia = S-CODCIA AND  
                             Almtmovm.tipmov = RADIO-SET-1 AND  
                             Almtmovm.codmov = INTEGER(FILL-IN-codmov) AND
                             Almtmov.MovTrf  = NO NO-LOCK NO-ERROR.
         IF AVAILABLE Almtmovm THEN
      
            RUN Proc-Almacen (Almacen.CodAlm, 
                              Almacen.CodDiv, 
                              Almtmovm.Codmov, 
                              Almtmovm.MovCmp).
      END.
   END.

END.
HIDE FRAME F-Proceso.

FOR EACH t-prev BREAK BY t-prev.tipo :
    IF FIRST-OF(t-prev.tipo) THEN DO:
         Lista = Lista + ',' + t-prev.tipo.
    END.
END.

DO WITH FRAME {&FRAME-NAME}:
   B-transferir:SENSITIVE = TRUE.
END.

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
DEFINE VAR I-nroitm AS INTEGER NO-UNDO.
DEFINE VAR x-debe   AS DECIMAL NO-UNDO.
DEFINE VAR x-haber  AS DECIMAL NO-UNDO.

FIND FIRST Almacen WHERE Almacen.codcia = s-codcia NO-LOCK NO-ERROR.
FIND FIRST Almtmovm WHERE Almtmovm.codcia = s-codcia NO-LOCK NO-ERROR.
   
DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 110 TODAY SKIP(1)
    {&PRN6A} + "PRE-ASIENTO - MOVIMIENTOS DE ALMACEN" + {&PRN6B} + {&PRND} AT 50 FORMAT "X(45)" SKIP(1)
    "Sub-almacen    : " Almacen.CodAlm  SPACE(2) Almacen.Descripcion FORMAT "x(40)" SKIP
    "Tipo Movimiento: " Almtmovm.Tipmov "Cod.Movimiento : "  AT 65 Almtmovm.Codmov SPACE(2) Almtmovm.Desmov FORMAT "x(40)" SKIP
    "Operacion      : " Almtmovm.codope SKIP
    "Fecha          : " FILL-IN-fchast SPACE(10) SKIP
    "---------------------------------------------------------------------------------------------------------------------------" SKIP
    "           CUENTA   CLF  CODIGO        COD.  NUMERO                                   TIP                                  " SKIP
    "DIVISION  CONTABLE  AUX AUXILIAR  CC.  DOC. DOCUMENTO     C O N C E P T O             MOV           DEBE          HABER    " SKIP
    "---------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
   
DEFINE FRAME F-Detalle
    I-NroItm       AT 1   FORMAT ">>9" 
    t-prev.coddiv  
    t-prev.codcta  
    t-prev.clfaux  
    t-prev.codaux
    t-prev.cco
    t-prev.coddoc
    t-prev.nrodoc
    t-prev.glodoc
    t-prev.tpomov
    x-debe  FORMAT ">>>>,>>>,>>9.99" 
    x-haber FORMAT ">>>>,>>>,>>9.99" 
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 


 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.

I-NroItm = 0.
FOR EACH t-prev BREAK BY t-prev.tipo BY t-prev.nrodoc BY t-prev.tpomov:
    FIND Almacen WHERE Almacen.codcia = s-codcia AND
         Almacen.codalm = t-prev.subalm NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN MESSAGE 'Subalmacen no existe ' + t-prev.subalm VIEW-AS ALERT-BOX. 
    FIND Almtmovm WHERE Almtmovm.CodCia = s-codcia AND 
         Almtmovm.tipmov = RADIO-SET-1 AND
         Almtmovm.Codmov = t-prev.codmov NO-LOCK NO-ERROR.
    VIEW FRAME F-Header.
    IF FIRST-OF(t-prev.tipo) THEN I-NroItm = 0.
    I-Nroitm = I-Nroitm + 1.
    x-debe   = 0.
    x-haber  = 0.
    IF t-prev.tpomov THEN x-haber = t-prev.impmn1.
    ELSE x-debe = t-prev.impmn1.
    ACCUMULATE x-debe (SUB-TOTAL BY t-prev.tipo).
    ACCUMULATE x-haber (SUB-TOTAL BY t-prev.tipo).
    DISPLAY 
        I-NroItm       AT 1   FORMAT ">>9" 
        t-prev.coddiv  
        t-prev.codcta  
        t-prev.clfaux  
        t-prev.codaux
        t-prev.cco
        t-prev.coddoc
        t-prev.nrodoc
        t-prev.glodoc
        t-prev.tpomov
        x-debe  WHEN x-debe <> 0
        x-haber WHEN x-haber <> 0
        WITH FRAME F-Detalle.
    IF LAST-OF(t-prev.tipo) THEN DO:
        UNDERLINE 
            x-debe
            x-haber
            WITH FRAME F-Detalle.
        x-debe =  ACCUM SUB-TOTAL BY t-prev.tipo x-debe.
        x-haber = ACCUM SUB-TOTAL BY t-prev.tipo x-haber.
        DISPLAY 
            "        TOTAL " @ t-prev.glodoc
            x-debe
            x-haber
            WITH FRAME F-Detalle.
        PAGE.
    END.
END.    
OUTPUT CLOSE.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     FIND FIRST Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Gn-Divi THEN DO:
      MESSAGE "No existen Divisiones para Compañia" VIEW-AS ALERT-BOX .
      RETURN.
     END.
     F-DIVISION = Gn-Divi.CodDiv.
     FILL-IN-periodo:SCREEN-VALUE = STRING(YEAR(TODAY)).
     C-Pre-asiento:SENSITIVE = No.
     DISPLAY F-DIVISION
             Gn-Divi.DesDiv @ FILL-IN-DESDIV.

     RUN dispatch IN h_p-updv10 ('hide':U).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pre-impresion W-Win 
PROCEDURE Pre-impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
   
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
   
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
   
  RUN Imprimir.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
  END CASE.   
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proc-Almacen W-Win 
PROCEDURE Proc-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: De acuerdo al codigo del movimiento,
         si es relacionado a un ingreso por compra se realiza el c lculo en base
         al precio unitario la cantidad y el factor;
         si no hace referencia a una compra se toma el valor de los campos 
         importe en soles e importe en d¢lares
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER Xscodalm AS CHAR.
DEFINE INPUT PARAMETER Xscoddiv AS CHAR.
DEFINE INPUT PARAMETER Xscodmov AS INTEGER.
DEFINE INPUT PARAMETER Xsmovcmp AS LOGICAL.

DEFINE VAR Xscodope   AS CHAR.
DEFINE VAR Xsdetalle  AS LOGICAL.
DEFINE VAR Xsctadbe   AS CHAR NO-UNDO.
DEFINE VAR XsctaHbe   AS CHAR NO-UNDO.
DEFINE VAR Xsfecha1   AS DATE NO-UNDO.
DEFINE VAR Xsfecha2   AS DATE NO-UNDO.
DEFINE VAR Xsnrogui   AS CHAR NO-UNDO.
DEFINE VAR Xscodaux   AS CHAR NO-UNDO.
DEFINE VAR x-glosa    AS CHAR NO-UNDO.
DEFINE VAR x-item     AS INTE NO-UNDO.
DEFINE VAR Xscatconta AS CHAR NO-UNDO.

Xsfecha1 = DATE(C-MES, 01, FILL-IN-Periodo).
IF C-MES = 12 THEN 
   Xsfecha2 = DATE(01,01, FILL-IN-periodo + 1) - 1.
ELSE 
   Xsfecha2 = DATE(C-MES + 1, 01,FILL-IN-periodo) - 1.

FOR EACH Almcmov WHERE Almcmov.CodCia = s-codcia 
                  AND  Almcmov.CodAlm = xscodalm 
                  AND  Almcmov.TipMov = RADIO-SET-1 
                  AND  Almcmov.CodMov = xscodmov 
                  AND  (ALmcmov.fchdoc >= xsfecha1 
                  AND   Almcmov.fchdoc <= xsfecha2)
                 NO-LOCK:
    IF Almcmov.flgest = 'A' THEN NEXT.
    DISPLAY 'Documento ' + Almcmov.Codalm + '-' + STRING(Almcmov.CodMov, '99') +
            STRING(Almcmov.NroDoc, '999999')  @ Fi-Mensaje LABEL "MOVIMIENTOS"
            FORMAT "X(16)" WITH FRAME F-Proceso.

    x-glosa   = Almtmovm.Desmov.    
    Xsmovcmp  = Almtmov.MovCmp .
    
    FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.codcia 
                      AND  Almdmov.CodAlm = Almcmov.codalm 
                      AND  Almdmov.TipMov = Almcmov.tipmov 
                      AND  Almdmov.CodMov = Almcmov.codmov 
                      AND  Almdmov.nrodoc = Almcmov.nrodoc 
                     NO-LOCK:
        
        x-item = x-item + 1.
        /* Verifico si el producto es Grabado o Exonerado */
        FIND Almmmatg WHERE Almmmatg.CodCia = s-codcia 
                       AND  Almmmatg.codmat = Almdmov.codmat 
                      NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DO:
           
           IF Almmmatg.Catconta[1] = "" THEN DO:
             MESSAGE 'Articulo ' + Almdmov.Codmat + ' Sin Categoria Contable.. ' VIEW-AS ALERT-BOX ERROR.
             NEXT.        
           END.
           
           FIND Cb-cfgalm WHERE Cb-cfgalm.Codcia   = S-CODCIA AND
                                Cb-cfgalm.Tipmov   = Almtmovm.Tipmov AND
                                Cb-cfgalm.Codmov   = Almtmovm.Codmov AND
                                Cb-cfgalm.catconta = Almmmatg.Catconta[1] NO-LOCK NO-ERROR.

           IF NOT AVAILABLE Cb-cfgalm OR Cb-cfgalm.CodCtaD[1] = "" OR Cb-cfgalm.CodCtaD[2] = "" OR
                                         Cb-cfgalm.CodCtaH[1] = "" OR Cb-cfgalm.CodCtaH[2] = "" OR
                                         Cb-cfgalm.Codope = "" THEN DO:
              MESSAGE Almtmovm.Tipmov + STRING(Almtmovm.Codmov,"99") + " " + Almtmovm.DesMov  + "-" + Almmmatg.Catconta[1] SKIP
                      "Articulo : " + Almdmov.CodMat + "  No Configurado" VIEW-AS ALERT-BOX ERROR.
              NEXT.        
           
           END.                                                            
           
           Xsdetalle  = Cb-cfgalm.Detalle .           
           Xscodope   = Cb-cfgalm.Codope .
           Xscatconta = Cb-cfgalm.catconta.

           IF Almmmatg.AftIgv THEN
              ASSIGN
                 Xsctadbe = Cb-cfgalm.CodCtaD[1]
                 Xsctahbe = Cb-cfgalm.CodCtaH[1].
           ELSE
              ASSIGN
                 Xsctadbe = Cb-cfgalm.CodCtaD[2]        
                 Xsctahbe = Cb-cfgalm.CodCtaH[2].
        
        END.
        ELSE DO:
             MESSAGE 'Articulo ' + Almdmov.Codmat + ' no existe ' VIEW-AS ALERT-BOX ERROR.
             NEXT.        
        END.
        
        IF Xsdetalle THEN
           ASSIGN
           Xscodaux = Almcmov.CodPro
           Xsnrogui = STRING(Almdmov.nrodoc).
        ELSE
           ASSIGN
           Xscodaux = "".
           Xsnrogui = "".            

        /*   D  E  B  E  */
        
        FIND FIRST t-prev WHERE t-prev.codope = Xscodope 
                           AND  t-prev.tipo   = Xscodalm + RADIO-SET-1 + STRING(Xscodmov, '99') + Xscatconta
                           AND  t-prev.tpomov = FALSE
                           AND  t-prev.codaux = Xscodaux 
                          NO-LOCK NO-ERROR.
        
        
        IF NOT AVAILABLE t-prev THEN DO:
           CREATE t-prev.
           ASSIGN
              t-prev.tipo    = Xscodalm + RADIO-SET-1 + STRING(Xscodmov, '99') + Xscatconta
              t-prev.subalm  = Xscodalm
              t-prev.codmov  = Xscodmov
              t-prev.nrogui  = Xsnrogui
              t-prev.periodo = FILL-IN-periodo
              t-prev.nromes  = c-mes
              t-prev.codope  = xscodope
              t-prev.coddiv  = xscoddiv
              t-prev.codmon  = 1
              t-prev.codcta  = xsctadbe
              t-prev.fchdoc  = FILL-IN-fchast
              t-prev.tpomov  = FALSE
              t-prev.glodoc  = x-glosa
              t-prev.clfaux  = '@PV'.
           IF Xscodaux <> '' THEN
              ASSIGN
                 t-prev.codaux  = Xscodaux                 
                 /*
                 t-prev.coddoc = 'OC'
                 t-prev.nrodoc = TRIM(Almcmov.NroRf1)
                 */
                 t-prev.glodoc = Xscodaux + "-" + Xscatconta.
        END.
        IF Xsmovcmp  THEN
           IF Almdmov.codmon = 1 THEN
              ASSIGN
                 t-prev.impmn1  = t-prev.impmn1 + (Almdmov.Preuni * Almdmov.Candes * Factor).
           ELSE
              ASSIGN
                 t-prev.impmn1  = t-prev.impmn1 + ((Almdmov.Preuni * Almdmov.Candes * Factor) * Almdmov.tpocmb).
        ELSE
           ASSIGN
              t-prev.impmn1  = t-prev.impmn1 + Almdmov.ImpMn1.
    
        /*   H  A  B  E  R   */
        FIND FIRST t-prev WHERE t-prev.codope = Xscodope 
                           AND  t-prev.tipo = Xscodalm + RADIO-SET-1 + STRING(Xscodmov, '99') + Xscatconta
                           AND  t-prev.tpomov = TRUE 
                           AND  t-prev.codaux = Xscodaux 
                          NO-LOCK NO-ERROR.
        IF NOT AVAILABLE t-prev THEN DO:
           CREATE t-prev.
           ASSIGN
              t-prev.tipo    = Xscodalm + RADIO-SET-1 + STRING(Xscodmov, '99') + Xscatconta
              t-prev.subalm  = Xscodalm
              t-prev.codmov  = Xscodmov
              t-prev.nrogui  = Xsnrogui
              t-prev.periodo = FILL-IN-periodo
              t-prev.nromes  = c-mes
              t-prev.codope  = xscodope
              t-prev.coddiv  = xscoddiv
              t-prev.codmon  = 1
              t-prev.codcta  = xsctahbe
              t-prev.fchdoc  = FILL-IN-fchast
              t-prev.Tpocmb  = 0
              t-prev.tpomov  = TRUE
              t-prev.glodoc  = x-glosa
              t-prev.clfaux  = '@PV'.
        IF Xscodaux <> '' THEN
              ASSIGN
                 t-prev.codaux  = Xscodaux
                 /*
                 t-prev.coddoc = 'OC'
                 t-prev.nrodoc = TRIM(Almcmov.NroRf1)                  
                 t-prev.codref = '09'
                 t-prev.nroref = TRIM(Almcmov.NroRf2)
                 */
                 t-prev.glodoc = Xscodaux + "-" + Xscatconta.
        END.
        IF Xsmovcmp THEN
           IF Almdmov.codmon = 1 THEN
              ASSIGN
                 t-prev.impmn1  = t-prev.impmn1 + (Almdmov.Preuni * Almdmov.Candes * Factor).
           ELSE
              ASSIGN
                 t-prev.impmn1  = t-prev.impmn1 + ((Almdmov.Preuni * Almdmov.Candes * Factor) * Almdmov.tpocmb).
        ELSE
           ASSIGN
              t-prev.impmn1  = t-prev.impmn1 + Almdmov.ImpMn1.

    END.
END.

  

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
        WHEN FILL-IN-codmov THEN
           ASSIGN 
              input-var-1 = RADIO-SET-1.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferir-asiento W-Win 
PROCEDURE Transferir-asiento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VAR p-codcia  AS INTE NO-UNDO.
DEFINE VAR p-periodo AS INTE NO-UNDO.
DEFINE VAR p-mes     AS INTE NO-UNDO.
DEFINE VAR p-codope  AS CHAR NO-UNDO.
DEFINE VAR p-nroast  AS CHAR NO-UNDO.
DEFINE VAR x-nroast  AS INTE NO-UNDO.
DEFINE VAR p-fchast  AS DATE NO-UNDO.
DEFINE VAR d-uno     AS DECI NO-UNDO.
DEFINE VAR d-dos     AS DECI NO-UNDO.
DEFINE VAR h-uno     AS DECI NO-UNDO.
DEFINE VAR h-dos     AS DECI NO-UNDO.
DEFINE VAR x-clfaux  AS CHAR NO-UNDO.
DEFINE VAR x-coddoc  AS LOGI NO-UNDO.
DEFINE VAR x-genaut  AS INTE NO-UNDO.
DEFINE VAR I         AS INTE NO-UNDO.
DEFINE VAR J         AS INTE NO-UNDO.

DEFINE BUFFER detalle FOR CB-DMOV.

p-codcia  = s-codcia.
p-periodo = FILL-IN-periodo.
p-mes     = c-mes.

FIND FIRST t-prev NO-ERROR.
IF NOT AVAILABLE t-prev THEN DO:
   BELL.
   MESSAGE "No se ha generado " SKIP "ning£n preasiento" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FIND cb-cfga WHERE cb-cfga.codcia = cb-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
   BELL.
   MESSAGE "Plan de cuentas no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

/* Limpio la informaci¢n de los movimientos transferidos anteriormente
   a contabilidad                                                   */
 FIND FIRST cb-control WHERE cb-control.CodCia  = s-codcia AND
                             cb-control.Coddiv  = F-DIVISION AND
                             cb-control.tipo    = '@AL' AND
                             cb-control.periodo = P-Periodo AND
                             cb-control.nromes  = P-Mes NO-LOCK NO-ERROR.
 IF AVAILABLE cb-control THEN DO:
    MESSAGE
        "Asientos contables del mes ya existen "  SKIP
        "        ¨Desea reemplazarlo? "
        VIEW-AS ALERT-BOX WARNING
        BUTTONS YES-NO UPDATE sigue AS LOGICAL.
    IF NOT sigue THEN RETURN.
 END.
 FOR EACH cb-control WHERE cb-control.CodCia  = s-codcia AND
                           cb-control.Coddiv  = F-DIVISION AND
                           cb-control.tipo    = '@AL' AND
                           cb-control.periodo = P-Periodo AND
                           cb-control.nromes  = P-Mes NO-LOCK :
     FIND cb-cmov WHERE
          cb-cmov.codcia  = p-codcia AND
          cb-cmov.coddiv  = F-DIVISION AND
          cb-cmov.PERIODO = p-periodo AND
          cb-cmov.NROMES  = p-mes AND
          cb-cmov.CODOPE  = cb-control.codope AND
          cb-cmov.NROAST  = cb-control.nroast NO-ERROR.
     IF AVAILABLE cb-cmov THEN 
        RUN anula-asto(
            p-codcia,
            p-periodo,
            p-mes,
            cb-control.codope,
            cb-control.nroast ).
     /* Elimino la informacion del temporal */
     RUN anula-temporal(
         p-codcia,
         p-periodo,
         p-mes,
         cb-control.codope,
         cb-control.nroast ).
 END.   

FOR EACH t-prev BREAK BY t-prev.tipo:
    IF FIRST-OF(t-prev.tipo) THEN DO:
       /* Verifico si el movimiento se realiz¢ anteriormente */
       FIND cb-control WHERE cb-control.CodCia  = s-codcia AND
                             cb-control.Coddiv  = F-DIVISION AND
                             cb-control.tipo    = '@AL' AND
                             cb-control.Periodo = FILL-IN-Periodo AND 
                             cb-control.Nromes  = C-mes AND
                             cb-control.CodAlm  = t-prev.subalm AND
                             cb-control.Tipmov  = RADIO-SET-1 AND
                             cb-control.Codmov  = t-prev.codmov NO-ERROR.
       IF AVAILABLE cb-control THEN 
          ASSIGN
             p-Codope = cb-control.Codope 
             p-nroast = cb-control.Nroast.
       ELSE DO:
          p-codope = t-prev.codope.
          RUN cbd/cbdnast.p(cb-codcia,
                            p-codcia, 
                            p-periodo, 
                            p-Mes, 
                            p-codope, 
                            OUTPUT x-nroast). 
          p-nroast = STRING(x-nroast, '999999').
          CREATE cb-control.
          ASSIGN
             cb-control.tipo    = '@AL'
             cb-control.CodCia  = p-codcia
             cb-control.Coddiv  = t-prev.coddiv
             cb-control.Periodo = p-periodo
             cb-control.Nromes  = p-mes 
             cb-control.CodAlm  = t-prev.subalm 
             cb-control.Tipmov  = RADIO-SET-1
             cb-control.Codmov  = t-prev.codmov 
             cb-control.Codope  = p-Codope
             cb-control.Nroast  = p-nroast.
       END.
       ASSIGN
          cb-control.Usuario = s-user-id
          cb-control.Fecha   = TODAY
          cb-control.Hora    = STRING(TIME,"HH:MM:SS").
       d-uno  = 0.
       d-dos  = 0.
       h-uno  = 0.
       h-dos  = 0.
    END.
    FIND cb-ctas WHERE
        cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = t-prev.codcta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN NEXT.
    x-clfaux = cb-ctas.clfaux.
    x-coddoc = cb-ctas.PidDoc.
    IF t-prev.impmn1 > 0 THEN DO:
        J = J + 1.
        CREATE CB-DMOV.
        CB-DMOV.codcia  = p-codcia.
        CB-DMOV.PERIODO = p-periodo.
        CB-DMOV.NROMES  = p-mes.
        CB-DMOV.CODOPE  = p-codope.
        CB-DMOV.NROAST  = p-nroast.
        CB-DMOV.NROITM  = J.
        CB-DMOV.codcta  = t-prev.codcta.
        CB-DMOV.coddiv  = t-prev.coddiv.
        CB-DMOV.cco     = t-prev.cco.
        Cb-dmov.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.
        Cb-dmov.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.
        CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        CB-DMOV.GLODOC  = t-prev.glodoc.
        CB-DMOV.tpomov  = t-prev.tpomov.
        CB-DMOV.impmn1  = t-prev.impmn1.
        CB-DMOV.impmn2  = t-prev.impmn2.
        CB-DMOV.FCHDOC  = p-fchast.
        CB-DMOV.FCHVTO  = p-fchast.
        CB-DMOV.FLGACT  = TRUE.
        CB-DMOV.RELACION = 0.
        CB-DMOV.codmon  = 1.
        CB-DMOV.tpocmb  = 0.
        RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
        IF CB-DMOV.tpomov THEN DO:
            h-uno = h-uno + CB-DMOV.impmn1.
            h-dos = h-dos + CB-DMOV.impmn2.
        END.
        ELSE DO:
            d-uno = d-uno + CB-DMOV.impmn1.
            d-dos = d-dos + CB-DMOV.impmn2.
        END.
        
        /* Carga el temporal */  
        CREATE T-CB-DMOV.
        T-CB-DMOV.codcia  = p-codcia.
        T-CB-DMOV.PERIODO = p-periodo.
        T-CB-DMOV.NROMES  = p-mes.
        T-CB-DMOV.CODOPE  = p-codope.
        T-CB-DMOV.NROAST  = p-nroast.
        T-CB-DMOV.NROITM  = J.
        T-CB-DMOV.codcta  = t-prev.codcta.
        T-CB-DMOV.coddiv  = t-prev.coddiv.
        T-CB-DMOV.cco     = t-prev.cco.
        T-CB-DMOV.Coddoc  = IF x-coddoc THEN t-prev.coddoc ELSE ''.
        T-CB-DMOV.Nrodoc  = IF x-coddoc THEN t-prev.nrodoc ELSE ''.
        T-CB-DMOV.clfaux  = IF x-clfaux <> '' THEN x-clfaux ELSE ''.
        T-CB-DMOV.codaux  = IF x-clfaux <> '' THEN t-prev.codaux ELSE ''.
        T-CB-DMOV.GLODOC  = t-prev.glodoc.
        T-CB-DMOV.tpomov  = t-prev.tpomov.
        T-CB-DMOV.impmn1  = t-prev.impmn1.
        T-CB-DMOV.impmn2  = t-prev.impmn2.
        T-CB-DMOV.FCHDOC  = p-fchast.
        T-CB-DMOV.FCHVTO  = p-fchast.
        T-CB-DMOV.FLGACT  = TRUE.
        T-CB-DMOV.RELACION = 0.
        T-CB-DMOV.codmon  = 1.
        T-CB-DMOV.tpocmb  = 0.

        x-GenAut = 0.
        /* Preparando para Autom ticas */
        /* Verificamos si la Cuenta genera automaticas de Clase 9 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
                    x-GenAut = 1.
                    LEAVE.
                END.
            END.
        END.
        /* Verificamos si la Cuenta genera automaticas de Clase 6 */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
                    x-GenAut = 2.
                    LEAVE.
                END.
           END.
        END.
        /* Verificamos si la Cuenta genera automaticas de otro tipo */
        DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
            IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
                IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
                    x-GenAut = 3.
                    LEAVE.
                END.
           END.
        END.
        cb-dmov.CtaAut = "".
        cb-dmov.CtrCta = "".
        CASE x-GenAut:
            /* Genera Cuentas Clase 9 */
            WHEN 1 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
            END.
            /* Genera Cuentas Clase 6 */
            WHEN 2 THEN DO:
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                IF cb-dmov.CtrCta = "" THEN
                    cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
            END.
            WHEN 3 THEN DO:
                cb-dmov.CtaAut = cb-ctas.An1Cta.
                cb-dmov.CtrCta = cb-ctas.Cc1Cta.
            END.
        END CASE.
        /* Chequendo las cuentas a generar en forma autom tica */
        IF x-GenAut > 0 THEN DO:
            IF NOT CAN-FIND(FIRST cb-ctas WHERE
                cb-ctas.CodCia = cb-codcia AND
                cb-ctas.CodCta = cb-dmov.CtaAut) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Cuenta" cb-dmov.CtaAut "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtaAut = "".
            END.
            IF NOT CAN-FIND( cb-ctas WHERE
                cb-ctas.CodCia = cb-codcia AND
                cb-ctas.CodCta = cb-dmov.CtrCta ) THEN DO:
                BELL.
                MESSAGE
                    "Cuentas Autom ticas a generar" SKIP
                    "Tienen mal registro, Contra Cuenta" cb-dmov.CtrCta "no existe"
                    VIEW-AS ALERT-BOX ERROR.
                cb-dmov.CtrCta = "".
            END.
        END. /*Fin del x-genaut > 0 */
        IF cb-dmov.CtaAut <> "" AND cb-dmov.CtrCta <> "" THEN DO:
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.CtaAut.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = cb-dmov.TpoMov.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
            J = J + 1.
            CREATE detalle.
            detalle.CodCia   = cb-dmov.CodCia.
            detalle.Periodo  = cb-dmov.Periodo.
            detalle.NroMes   = cb-dmov.NroMes.
            detalle.CodOpe   = cb-dmov.CodOpe.
            detalle.NroAst   = cb-dmov.NroAst.
            detalle.TpoItm   = "A".
            detalle.Relacion = RECID(cb-dmov).
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.NroItm   = cb-dmov.NroItm.
            detalle.Codcta   = cb-dmov.Ctrcta.
            detalle.CodDiv   = cb-dmov.CodDiv.
            detalle.ClfAux   = cb-dmov.ClfAux.
            detalle.CodAux   = cb-dmov.CodCta.
            detalle.NroRuc   = cb-dmov.NroRuc.
            detalle.CodDoc   = cb-dmov.CodDoc.
            detalle.NroDoc   = cb-dmov.NroDoc.
            detalle.GloDoc   = cb-dmov.GloDoc.
            detalle.CodMon   = cb-dmov.CodMon.
            detalle.TpoCmb   = cb-dmov.TpoCmb.
            detalle.TpoMov   = NOT cb-dmov.TpoMov.
            detalle.ImpMn1   = cb-dmov.ImpMn1.
            detalle.ImpMn2   = cb-dmov.ImpMn2.
            detalle.ImpMn3   = cb-dmov.ImpMn3.
            detalle.NroRef   = cb-dmov.NroRef.
            detalle.FchDoc   = cb-dmov.FchDoc.
            detalle.FchVto   = cb-dmov.FchVto.
            detalle.Tm       = cb-dmov.Tm.
            detalle.CCO      = cb-dmov.CCO.
            RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
            IF detalle.tpomov THEN DO:
                h-uno = h-uno + detalle.impmn1.
                h-dos = h-dos + detalle.impmn2.
            END.
            ELSE DO:
                d-uno = d-uno + CB-DMOV.impmn1.
                d-dos = d-dos + CB-DMOV.impmn2.
            END.
        END.
    END.
           
    IF LAST-OF(t-prev.tipo) THEN DO:
       FIND cb-cmov WHERE
           cb-cmov.codcia  = p-codcia AND
           cb-cmov.PERIODO = p-periodo AND
           cb-cmov.NROMES  = p-mes AND
           cb-cmov.CODOPE  = p-codope AND
           cb-cmov.NROAST  = p-nroast NO-ERROR.
       IF NOT AVAILABLE cb-cmov THEN DO:
           CREATE cb-cmov.
           cb-cmov.codcia  = p-codcia.
           cb-cmov.PERIODO = p-periodo.
           cb-cmov.NROMES  = p-mes.
           cb-cmov.CODOPE  = p-codope.
           cb-cmov.NROAST  = p-nroast. 
       END.
       ASSIGN
          cb-cmov.CodDiv = t-prev.coddiv
          cb-cmov.Fchast = FILL-IN-fchast
          cb-cmov.TOTITM = J
          cb-cmov.CODMON = 1
          cb-cmov.TPOCMB = 0
          cb-cmov.DBEMN1 = d-uno
          cb-cmov.DBEMN2 = d-dos
          cb-cmov.HBEMN1 = h-uno
          cb-cmov.HBEMN2 = h-dos.
       FIND Almtmovm WHERE Almtmovm.CodCia = s-codcia AND 
            Almtmovm.tipmov = RADIO-SET-1 AND
            Almtmovm.Codmov = t-prev.codmov NO-LOCK NO-ERROR.
       IF AVAILABLE Almtmov THEN
          ASSIGN
            cb-cmov.NOTAST = Almtmovm.desmov
            cb-cmov.GLOAST = Almtmovm.desmov.
    END.
END.
*/
MESSAGE ' Proceso Concluido ' VIEW-AS ALERT-BOX INFORMATION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

