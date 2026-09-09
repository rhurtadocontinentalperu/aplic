&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR S-CodDoc AS CHAR INITIAL "BBC".
DEF NEW SHARED VAR S-CodCta LIKE cb-ctas.codcta.
DEF NEW SHARED VAR S-CodBco LIKE cb-ctas.codbco.
DEF NEW SHARED VAR S-CodMon  AS INTEGER.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  AS CHARACTER.
DEF SHARED VAR S-CodTer  AS CHAR.      
DEF SHARED VAR S-User-Id AS CHAR.


DEFINE NEW SHARED VARIABLE s-Der AS LOGICAL.
DEFINE NEW SHARED VARIABLE s-Izq AS LOGICAL.

DEFINE NEW SHARED TEMP-TABLE T-CcbDMvto LIKE CcbDMvto.
DEFINE NEW SHARED TEMP-TABLE T-CcbDMvt1 LIKE CcbDMvto.
DEFINE NEW SHARED VARIABLE G-Fecha AS DATE INITIAL TODAY.

DEF VAR x-desc AS CHARACTER.
DEF VAR x-nrochq AS CHARACTER.
DEF VAR W-MONEDA AS INTEGER.

DEFINE new SHARED VARIABLE input-var-1 AS CHARACTER.
DEFINE new SHARED VARIABLE input-var-2 AS CHARACTER.
DEFINE new SHARED VARIABLE input-var-3 AS CHARACTER.
DEFINE new SHARED VARIABLE output-var-1 AS ROWID.
DEFINE new SHARED VARIABLE output-var-2 AS CHARACTER.
DEFINE new SHARED VARIABLE output-var-3 AS CHARACTER.

FIND FIRST FacCorre WHERE 
           FacCorre.CodCia = S-CodCia AND  
           FacCorre.CodDiv = S-CodDiv AND  
           FacCorre.CodDoc = S-CodDoc NO-LOCK NO-ERROR.
IF NOT AVAIL FacCorre THEN DO:
   MESSAGE "Codigo de movimiento no configurado " S-CodDoc VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCCaja

/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH CcbCCaja SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main CcbCCaja


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 F-Banco B-Add B-Remove BUTTON-5 ~
F-Fecha F-Cta RECT-3 B-Select2 RECT-2 B-Select1 B-Deselect1 B-Deselect2 ~
BUTTON-7 
&Scoped-Define DISPLAYED-OBJECTS w-divi F-Banco FILL-IN-16 F-Fecha F-Cta ~
FILL-IN-17 X-USER 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-bovbco AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tm_bb1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tm_bb2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97-2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Add 
     LABEL "&Adicionar>>" 
     SIZE 15.72 BY .77
     FONT 0.

DEFINE BUTTON B-Deselect1 
     LABEL "&Deseleccionar Todo" 
     SIZE 15.14 BY .85.

DEFINE BUTTON B-Deselect2 
     LABEL "&Deseleccionar Todo" 
     SIZE 15.14 BY .85.

DEFINE BUTTON B-Remove 
     LABEL "<< &Remover" 
     SIZE 15.72 BY .77
     FONT 0.

DEFINE BUTTON B-Select1 
     LABEL "&Seleccionar Todo" 
     SIZE 15.14 BY .85.

DEFINE BUTTON B-Select2 
     LABEL "&Seleccionar Todo" 
     SIZE 16.29 BY .85.

DEFINE BUTTON BUTTON-5 
     LABEL "Aceptar Deposito" 
     SIZE 16.57 BY 1.15
     FONT 6.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img\b-print":U
     LABEL "Button 7" 
     SIZE 6.29 BY 1.62.

DEFINE VARIABLE F-Banco AS CHARACTER FORMAT "X(3)":U 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE F-Cta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-Fecha AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-16 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-17 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.72 BY .81 NO-UNDO.

DEFINE VARIABLE w-divi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE X-USER AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .81
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 8  NO-FILL 
     SIZE 19 BY 4.58.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 6 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 1.62.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93.14 BY 2.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     w-divi AT ROW 1.12 COL 7.43 COLON-ALIGNED
     F-Banco AT ROW 2.04 COL 7.57 COLON-ALIGNED
     FILL-IN-16 AT ROW 2.04 COL 12.57 COLON-ALIGNED NO-LABEL
     B-Add AT ROW 8 COL 18.14
     B-Remove AT ROW 8 COL 39.43
     BUTTON-5 AT ROW 15.65 COL 36.86
     F-Fecha AT ROW 1.12 COL 46 COLON-ALIGNED
     F-Cta AT ROW 2 COL 46 COLON-ALIGNED
     FILL-IN-17 AT ROW 2.04 COL 57.43 COLON-ALIGNED NO-LABEL
     B-Select2 AT ROW 15.77 COL 57.57
     X-USER AT ROW 1.19 COL 77 COLON-ALIGNED
     B-Select1 AT ROW 4.73 COL 77.14
     B-Deselect1 AT ROW 5.69 COL 77.14
     B-Deselect2 AT ROW 15.77 COL 76.43
     BUTTON-7 AT ROW 11.08 COL 85.72
     RECT-4 AT ROW 1 COL 1
     RECT-3 AT ROW 15.38 COL 54.86
     RECT-2 AT ROW 3.19 COL 75.14
     "Imprimir" VIEW-AS TEXT
          SIZE 5.43 BY .5 AT ROW 12.73 COL 86.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.57 BY 16
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "TRANSFERENCIA DE BOVEDA A BANCO"
         HEIGHT             = 16
         WIDTH              = 93.43
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 108.57
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 108.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-16 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-17 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN w-divi IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-USER IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "integral.CcbCCaja"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* TRANSFERENCIA DE BOVEDA A BANCO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* TRANSFERENCIA DE BOVEDA A BANCO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Add W-Win
ON CHOOSE OF B-Add IN FRAME F-Main /* Adicionar>> */
DO:
    ASSIGN 
       F-Banco F-Cta.
    IF F-Banco = ' '  THEN DO:
       MESSAGE 'No se encuentra registrado el codigo del Banco' VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO F-Banco.
       RETURN NO-APPLY.
    END.
    IF F-Cta =  ' '  THEN DO:
       MESSAGE 'No se encuentra regsitrada la cuenta contable' VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO F-Cta.
       RETURN NO-APPLY.
    END.
    RUN dispatch IN h_b-tm_bb1 ('asigna-temporal':U).
    RUN dispatch IN h_b-tm_bb1 ('open-query':U).
    
    IF S-Izq THEN DO:
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
    END.

     RUN Procesa-Handle IN lh_Handle ('Activa').  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Deselect1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Deselect1 W-Win
ON CHOOSE OF B-Deselect1 IN FRAME F-Main /* Deseleccionar Todo */
DO:
    RUN dispatch IN h_b-tm_bb1 ('Deselect-All':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Deselect2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Deselect2 W-Win
ON CHOOSE OF B-Deselect2 IN FRAME F-Main /* Deseleccionar Todo */
DO:
    RUN dispatch IN h_b-tm_bb2 ('Deselect-All':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Remove W-Win
ON CHOOSE OF B-Remove IN FRAME F-Main /* << Remover */
DO:
    RUN dispatch IN h_b-tm_bb2 ('asigna-temporal':U).
    RUN dispatch IN h_b-tm_bb2 ('open-query':U).
    RUN dispatch IN h_b-tm_bb1 ('open-query':U).
    
    IF NOT S-Izq THEN DO:
     RUN Procesa-Handle IN lh_Handle ('Pagina1').
     RUN Procesa-Handle IN lh_Handle ('browse').
    END.

     RUN Procesa-Handle IN lh_Handle ('Activa').  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Select1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Select1 W-Win
ON CHOOSE OF B-Select1 IN FRAME F-Main /* Seleccionar Todo */
DO:
    RUN dispatch IN h_b-tm_bb1 ('Select-All':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Select2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Select2 W-Win
ON CHOOSE OF B-Select2 IN FRAME F-Main /* Seleccionar Todo */
DO:
    RUN dispatch IN h_b-tm_bb2 ('Select-All':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Aceptar Deposito */
DO:
    RUN dispatch IN h_b-tm_bb2 ('asigna-deposito':U).
    RUN dispatch IN h_b-tm_bb2 ('open-query':U).
    RUN dispatch IN h_b-tm_bb1 ('open-query':U).
    
    IF NOT S-Izq THEN DO:
     RUN Procesa-Handle IN lh_Handle ('Pagina1').
     RUN Procesa-Handle IN lh_Handle ('browse').
     RUN dispatch IN h_b-tm_bb1 ('open-query':U).
    END.
    /******************/
    RUN _carga-tmp.
    RUN dispatch IN h_b-tm_bb1 ('asigna-temporal':U).
    RUN dispatch IN h_b-tm_bb1 ('open-query':U).
    RUN dispatch IN h_b-bovbco ('open-query':U).
    /******************/
    RUN Procesa-Handle IN lh_Handle ('Activa').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
 RUN dispatch IN h_b-bovbco ('imprime':U).
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco W-Win
ON ENTRY OF F-Banco IN FRAME F-Main /* Banco */
DO:
  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
    G-Fecha = F-Fecha.
    S-CODBCO = F-Banco.
    G-Fecha = F-Fecha.
    S-CODBCO = F-Banco.
  RUN _carga-tmp.
  RUN dispatch IN h_b-tm_bb1 ('open-query':U).
  RUN dispatch IN h_b-bovbco ('open-query':U).
  RUN Procesa-Handle IN lh_Handle ('Activa').    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco W-Win
ON LEAVE OF F-Banco IN FRAME F-Main /* Banco */
DO:

  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
    G-Fecha = F-Fecha.
    S-CODBCO = F-Banco.
    S-CODCTA = F-Cta.
  
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ F-Banco 
        "" @ FILL-IN-16 
        WITH FRAME {&FRAME-NAME}.
     RETURN.
  END.
  FIND cb-tabl WHERE cb-tabl.Tabla  = "04"
                AND  cb-tabl.Codigo = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-tabl THEN DO:
    MESSAGE "Banco no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  DISPLAY 
    cb-tabl.Codigo @ F-Banco 
    cb-tabl.Nombre @ FILL-IN-16 
    WITH FRAME {&FRAME-NAME}.  
  
  RUN _carga-tmp.
  RUN dispatch IN h_b-bovbco ('open-query':U).
  RUN dispatch IN h_b-tm_bb1 ('open-query':U).
  RUN Procesa-Handle IN lh_Handle ('Activa').
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Banco W-Win
ON MOUSE-SELECT-DBLCLICK OF F-Banco IN FRAME F-Main /* Banco */
DO:
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = "04"
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    RUN LKUP/C-Tablas.r("").
    IF OUTPUT-VAR-1 <> ? THEN DO:
        FIND cb-tabl WHERE ROWID(cb-tabl) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
        DISPLAY 
          cb-tabl.Codigo @ F-Banco 
          cb-tabl.Nombre @ FILL-IN-16 
          WITH FRAME {&FRAME-NAME}.  
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cta W-Win
ON LEAVE OF F-Cta IN FRAME F-Main /* Cuenta */
DO:
  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
    G-Fecha = F-Fecha.
    S-CODBCO = F-Banco.
    S-CODCTA = F-Cta.
    
  IF SELF:SCREEN-VALUE = "" THEN DO:
     DISPLAY 
        "" @ F-Cta 
        "" @ FILL-IN-17  
        WITH FRAME {&FRAME-NAME}.
     RETURN .
  END.
                 
  FIND cb-ctas WHERE cb-ctas.codcia = 0 
                AND  cb-ctas.Codcta = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-ctas THEN DO:
    MESSAGE "Cuenta no registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY. 
  END.
  ASSIGN s-codmon = cb-ctas.codmon.
            
/*  CcbBolDep.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cb-ctas.Codmon).*/
  DISPLAY 
    cb-ctas.Codcta @ F-Cta 
    cb-ctas.Nomcta @ FILL-IN-17  
    WITH FRAME {&FRAME-NAME}.  
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Cta W-Win
ON MOUSE-SELECT-DBLCLICK OF F-Cta IN FRAME F-Main /* Cuenta */
DO:
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = "10"
          input-var-2 = F-Banco:SCREEN-VALUE
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    RUN LKUP/C-Cuenta.r("Cuentas").
    IF OUTPUT-VAR-1 <> ? THEN DO:
        FIND cb-ctas WHERE ROWID(cb-ctas) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
        DISPLAY 
          cb-ctas.Codcta @ F-Cta 
          cb-ctas.Nomcta @ FILL-IN-17 
          WITH FRAME {&FRAME-NAME}.  
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha W-Win
ON ENTRY OF F-Fecha IN FRAME F-Main /* Fecha */
DO:
  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
    G-Fecha = F-Fecha.
    S-CODBCO = F-Banco.
  RUN _carga-tmp.
  RUN dispatch IN h_b-tm_bb1 ('open-query':U).
  RUN dispatch IN h_b-bovbco ('open-query':U).
  RUN Procesa-Handle IN lh_Handle ('Activa').  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha W-Win
ON LEAVE OF F-Fecha IN FRAME F-Main /* Fecha */
DO:
  ASSIGN
    F-Banco 
    F-Cta
    F-Fecha.
    G-Fecha = F-Fecha.
    S-CODBCO = F-Banco.
    S-CODCTA = F-Cta.
    
  RUN _carga-tmp.
  RUN dispatch IN h_b-bovbco ('open-query':U).
  RUN dispatch IN h_b-tm_bb1 ('open-query':U).
  RUN Procesa-Handle IN lh_Handle ('Activa').
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'ccb/b-tm_bb1.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tm_bb1 ).
       RUN set-position IN h_b-tm_bb1 ( 3.15 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.54 , 73.72 ) */

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'ccb/b-bovbco.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-bovbco ).
       RUN set-position IN h_b-bovbco ( 9.12 , 1.29 ) NO-ERROR.
       /* Size in UIB:  ( 5.85 , 83.43 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 15.50 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.35 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-bovbco. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_b-bovbco ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'ccb/b-tm_bb2.r':U ,
             INPUT  {&WINDOW-NAME} ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tm_bb2 ).
       RUN set-position IN h_b-tm_bb2 ( 9.12 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.92 , 79.43 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97-2 ).
       RUN set-position IN h_p-updv97-2 ( 15.58 , 1.29 ) NO-ERROR.
       RUN set-size IN h_p-updv97-2 ( 1.35 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-tm_bb2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97-2 , 'TableIO':U , h_b-tm_bb2 ).

    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 2 ).

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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY w-divi F-Banco FILL-IN-16 F-Fecha F-Cta FILL-IN-17 X-USER 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-4 F-Banco B-Add B-Remove BUTTON-5 F-Fecha F-Cta RECT-3 B-Select2 
         RECT-2 B-Select1 B-Deselect1 B-Deselect2 BUTTON-7 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
      ASSIGN 
        F-Fecha:SCREEN-VALUE = STRING(TODAY, "99/99/9999").
     /* F-Cja:SCREEN-VALUE = S-CODTER.  */
  END.
  ASSIGN lh_Handle = THIS-PROCEDURE
         W-DIVI:SCREEN-VALUE = S-CODDIV
         x-user:SCREEN-VALUE = S-USER-ID.
  RUN Procesa-Handle ("Pagina1").
  APPLY "ENTRY" TO F-Banco IN FRAME {&FRAME-NAME}.
  RUN Procesa-Handle ('Activa').  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER L-Handle AS CHAR.
CASE L-Handle:
    WHEN "browse" THEN DO:
          RUN dispatch IN h_b-bovbco ('open-query':U).
          RUN dispatch IN h_b-tm_bb2 ('open-query':U).
      END.
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
         RUN dispatch IN h_b-bovbco ('open-query':U).
      END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
      END.
    WHEN "Activa"  THEN DO WITH FRAME {&FRAME-NAME}:
         BUTTON-5:SENSITIVE = S-Izq.
         B-Add:SENSITIVE = S-Der.
         B-Remove:SENSITIVE = S-Izq.
         B-Select1:SENSITIVE = S-Der.
         B-Deselect1:SENSITIVE = S-Der.
         B-Select2:SENSITIVE = S-Izq.
         B-Deselect2:SENSITIVE = S-Izq.
         F-Banco:SENSITIVE = NOT S-Izq.
         F-Cta:SENSITIVE = NOT S-Izq.
         F-Fecha:SENSITIVE = NOT S-Izq.
         IF NOT S-Izq THEN DO:
            RUN _Borra-temporal.
         END.
      END.      
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCCaja"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Borra-temporal W-Win 
PROCEDURE _Borra-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH T-CcbDMvt1:
    DELETE T-CcbDMvt1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _carga-tmp W-Win 
PROCEDURE _carga-tmp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH t-CcbDMvto:
    DELETE t-CcbDMvto.
  END.
  /* CARGAMOS EN EL TEMPORAL LOS PENDIENTES POR DEPOSITAR */
  FOR EACH CcbDMvto WHERE 
           CcbDMvto.codcia = S-CodCia AND
           CcbDMvto.coddoc = "PXD"    AND
           CcbDMvto.codcli = S-CodDiv AND
           CcbDMvto.flgest = "P"
/*                   AND  CcbDMvto.fchcie <= F-Fecha                   */
/*                   AND  (CcbDMvto.DepNac[3] + CcbDMvto.DepUsa[3] > 0)*/
                    NO-LOCK:
/*
        IF LOOKUP(CcbDMvto.CodRef, "EFEC,TARC") = 0 THEN DO:
            IF CcbDMvto.TpoRef <> S-CODBCO THEN NEXT.
        END.
*/        
        CREATE t-CcbDMvto.
        ASSIGN
            t-CcbDMvto.CodCia  = CcbDMvto.CodCia 
            t-CcbDMvto.CodDiv  = CcbDMvto.CodDiv
            t-CcbDMvto.CodDoc  = CcbDMvto.CodDoc 
            t-CcbDMvto.CodCli  = CcbDMvto.CodCli
            t-CcbDMvto.NroDoc  = CcbDMvto.NroDoc
            t-CcbDMvto.CodRef  = CcbDMvto.CodRef
            t-CcbDMvto.NroRef  = CcbDMvto.NroRef
            t-CcbDMvto.TpoRef  = CcbDMvto.TpoRef
            t-CcbDMvto.FlgEst  = CcbDMvto.FlgEst
            t-CcbDMvto.DepNac[1] = CcbDMvto.DepNac[1]
            t-CcbDMvto.DepUsa[1] = CcbDMvto.DepUsa[1]
            t-CcbDMvto.DepNac[2] = CcbDMvto.DepNac[2]
            t-CcbDMvto.DepUsa[2] = CcbDMvto.DepUsa[2]
            t-CcbDMvto.DepNac[3] = CcbDMvto.DepNac[3]
            t-CcbDMvto.DepUsa[3] = CcbDMvto.DepUsa[3]
            t-CcbDMvto.FchVto  = CcbDMvto.FchVto
            t-CcbDMvto.FchCie  = CcbDMvto.FchCie
            t-CcbDMvto.HorCie  = CcbDMvto.HorCie
            t-CcbDMvto.usuario = CcbDMvto.usuario.

  END.

  FIND FIRST t-CcbDMvto NO-ERROR.
  IF AVAIL t-CcbDMvto THEN S-Der = TRUE.
  ELSE S-Der = FALSE.

  FIND FIRST T-CcbDMvt1 NO-ERROR.
  IF AVAIL T-CcbDMvt1 THEN S-Izq = TRUE.
  ELSE S-Izq = FALSE.

  RUN dispatch IN h_b-tm_bb1 ('open-query':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


