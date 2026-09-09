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
DEF NEW SHARED VAR S-CodDoc AS CHAR INITIAL "PXD".
DEF NEW SHARED VAR S-CodCta LIKE cb-ctas.codcta.
DEF NEW SHARED VAR S-CodMon  AS INTEGER.
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-coddiv  AS CHARACTER.
DEF SHARED VAR S-CodTer  AS CHAR.      
DEF SHARED VAR S-User-Id AS CHAR.


DEFINE NEW SHARED VARIABLE s-Der AS LOGICAL.
DEFINE NEW SHARED VARIABLE s-Izq AS LOGICAL.

DEFINE NEW SHARED TEMP-TABLE T-CcbDMvt1 LIKE CcbDMvto.
DEFINE NEW SHARED TEMP-TABLE T-CcbDMvto LIKE CcbDMvto.
DEFINE NEW SHARED TEMP-TABLE T-CcbPenDep LIKE CcbPenDep.
DEFINE NEW SHARED VARIABLE G-Fecha AS DATE INITIAL TODAY.

DEF VAR x-desc AS CHARACTER.
DEF VAR x-nrochq AS CHARACTER.

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
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-2 B-Select1 F-Fecha B-Deselect1 ~
B-Add B-Remove BUTTON-5 RECT-3 B-Select2 B-Deselect2 
&Scoped-Define DISPLAYED-OBJECTS w-divi F-CJA F-Fecha X-USER 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-depbo1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-depbov AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-pendep AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97-2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Add 
     LABEL "&Adicionar>>" 
     SIZE 10 BY .85.

DEFINE BUTTON B-Deselect1 
     LABEL "&Deseleccionar Todo" 
     SIZE 15.14 BY .85.

DEFINE BUTTON B-Deselect2 
     LABEL "&Deseleccionar Todo" 
     SIZE 15.14 BY .85.

DEFINE BUTTON B-Print 
     IMAGE-UP FILE "img\b-print":U
     LABEL "Button 1" 
     SIZE 6.43 BY 1.62.

DEFINE BUTTON B-Remove 
     LABEL "<< &Remover" 
     SIZE 10 BY .85.

DEFINE BUTTON B-Select1 
     LABEL "&Seleccionar Todo" 
     SIZE 15.14 BY .85.

DEFINE BUTTON B-Select2 
     LABEL "&Seleccionar Todo" 
     SIZE 15.14 BY .85.

DEFINE BUTTON BUTTON-5 
     LABEL "Aceptar Deposito" 
     SIZE 19.86 BY .85
     FONT 6.

DEFINE VARIABLE F-CJA AS CHARACTER FORMAT "X(256)":U 
     LABEL "Caja" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-Fecha AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE w-divi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE X-USER AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 8  NO-FILL 
     SIZE 38.43 BY 2.12.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 8  NO-FILL 
     SIZE 36.43 BY 2.12.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.57 BY 3.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     B-Select1 AT ROW 12.58 COL 5
     w-divi AT ROW 1.31 COL 6.57 COLON-ALIGNED
     F-CJA AT ROW 2.15 COL 6.57 COLON-ALIGNED
     F-Fecha AT ROW 2.96 COL 6.57 COLON-ALIGNED
     B-Deselect1 AT ROW 12.58 COL 20.72
     X-USER AT ROW 1.31 COL 22.86 COLON-ALIGNED
     B-Print AT ROW 1.35 COL 43.57
     B-Add AT ROW 12 COL 41.86
     B-Remove AT ROW 13.04 COL 41.72
     BUTTON-5 AT ROW 1.15 COL 55.14
     B-Select2 AT ROW 12.5 COL 57.29
     B-Deselect2 AT ROW 12.5 COL 73.29
     RECT-4 AT ROW 1 COL 1
     RECT-2 AT ROW 11.88 COL 1.14
     "Imprimir" VIEW-AS TEXT
          SIZE 5.43 BY .5 AT ROW 3.12 COL 44
     RECT-3 AT ROW 11.85 COL 54.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 13.04
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Transferencia de Dinero de Caja a Boveda"
         HEIGHT             = 13.04
         WIDTH              = 90.72
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 114.29
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
/* SETTINGS FOR BUTTON B-Print IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CJA IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Transferencia de Dinero de Caja a Boveda */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Transferencia de Dinero de Caja a Boveda */
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
    RUN dispatch IN h_b-pendep ('asigna-temporal':U).
    RUN dispatch IN h_b-pendep ('open-query':U).
    
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
    RUN dispatch IN h_b-pendep ('Deselect-All':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Deselect2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Deselect2 W-Win
ON CHOOSE OF B-Deselect2 IN FRAME F-Main /* Deseleccionar Todo */
DO:
    RUN dispatch IN h_b-depbo1 ('Deselect-All':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Print W-Win
ON CHOOSE OF B-Print IN FRAME F-Main /* Button 1 */
DO:
  RUN dispatch IN h_b-depbov ('imprime':U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Remove W-Win
ON CHOOSE OF B-Remove IN FRAME F-Main /* << Remover */
DO:
    RUN dispatch IN h_b-depbo1 ('asigna-temporal':U).
    RUN dispatch IN h_b-depbo1 ('open-query':U).
    RUN dispatch IN h_b-pendep ('open-query':U).
    
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
    RUN dispatch IN h_b-pendep ('Select-All':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Select2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Select2 W-Win
ON CHOOSE OF B-Select2 IN FRAME F-Main /* Seleccionar Todo */
DO:
    RUN dispatch IN h_b-depbo1 ('Select-All':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Aceptar Deposito */
DO:
    RUN dispatch IN h_b-depbo1 ('asigna-deposito':U).
    RUN dispatch IN h_b-depbo1 ('open-query':U).
    RUN dispatch IN h_b-pendep ('open-query':U).
    
    IF NOT S-Izq THEN DO:
     RUN Procesa-Handle IN lh_Handle ('Pagina1').
     RUN Procesa-Handle IN lh_Handle ('browse').
     RUN dispatch IN h_b-pendep ('open-query':U).
    END.
    /******************/
    RUN _carga-tmp.
    RUN dispatch IN h_b-pendep ('asigna-temporal':U).
    RUN dispatch IN h_b-pendep ('open-query':U).
    RUN dispatch IN h_b-depbov ('open-query':U).
    /******************/
    RUN Procesa-Handle IN lh_Handle ('Activa').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha W-Win
ON ENTRY OF F-Fecha IN FRAME F-Main /* Fecha */
DO:
  ASSIGN
    F-Fecha.
    G-Fecha = F-Fecha.
  RUN _carga-tmp.
  RUN dispatch IN h_b-pendep ('open-query':U).
  RUN dispatch IN h_b-depbov ('open-query':U).
  RUN Procesa-Handle IN lh_Handle ('Activa').  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Fecha W-Win
ON LEAVE OF F-Fecha IN FRAME F-Main /* Fecha */
DO:
  ASSIGN
    F-Fecha.
    G-Fecha = F-Fecha.
  RUN _carga-tmp.
  RUN dispatch IN h_b-depbov ('open-query':U).
  RUN dispatch IN h_b-pendep ('open-query':U).
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
             INPUT  'ccb/b-pendep.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-pendep ).
       RUN set-position IN h_b-pendep ( 4.04 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 7.81 , 38.43 ) */

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'ccb/b-depbov.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-depbov ).
       RUN set-position IN h_b-depbov ( 4.04 , 40.29 ) NO-ERROR.
       /* Size in UIB:  ( 7.81 , 50.57 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 2.08 , 51.14 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.54 , 34.00 ) NO-ERROR.

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'ccb/b-depbo1.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-depbo1 ).
       RUN set-position IN h_b-depbo1 ( 4.00 , 40.86 ) NO-ERROR.
       /* Size in UIB:  ( 7.81 , 50.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97-2 ).
       RUN set-position IN h_p-updv97-2 ( 2.15 , 52.86 ) NO-ERROR.
       RUN set-size IN h_p-updv97-2 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-depbo1. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97-2 , 'TableIO':U , h_b-depbo1 ).

    END. /* Page 2 */

  END CASE.

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
  DISPLAY w-divi F-CJA F-Fecha X-USER 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-4 RECT-2 B-Select1 F-Fecha B-Deselect1 B-Add B-Remove BUTTON-5 
         RECT-3 B-Select2 B-Deselect2 
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
        F-Fecha:SCREEN-VALUE = STRING(TODAY, "99/99/9999")
        F-Cja:SCREEN-VALUE = S-CODTER.
  END.
  ASSIGN lh_Handle = THIS-PROCEDURE
         W-DIVI:SCREEN-VALUE = S-CODDIV
         x-user:SCREEN-VALUE = S-USER-ID.
  RUN Procesa-Handle ("Pagina1").
  APPLY "ENTRY" TO F-Fecha IN FRAME {&FRAME-NAME}.
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
          RUN dispatch IN h_b-depbov ('open-query':U).
          RUN dispatch IN h_b-depbo1 ('open-query':U).
      END.
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
         RUN dispatch IN h_b-depbov ('open-query':U).
         B-Print:SENSITIVE = TRUE.
      END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
         B-Print:SENSITIVE = FALSE.
      END.
    WHEN "Activa"  THEN DO WITH FRAME {&FRAME-NAME}:
         B-Add:SENSITIVE = S-Der.
         B-Remove:SENSITIVE = S-Izq.
         B-Select1:SENSITIVE = S-Der.
         B-Deselect1:SENSITIVE = S-Der.
         B-Select2:SENSITIVE = S-Izq.
         B-Deselect2:SENSITIVE = S-Izq.
         BUTTON-5:SENSITIVE   = S-Izq.
         IF S-Izq THEN DO:
            F-Fecha:SENSITIVE = NOT S-Izq.
         END.
         ELSE DO:
            F-Fecha:SENSITIVE = NOT S-Izq.
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
FOR EACH T-CcbDMvto:
    DELETE T-CcbDMvto.
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
  FOR EACH t-ccbpendep:
    DELETE t-ccbpendep.
  END.
   
  FOR EACH CcbPendep WHERE CcbPendep.codcia = S-CodCia AND 
                     CcbPendep.coddoc  = S-CodDoc      AND 
                     CcbPendep.coddiv  = S-CodDiv      AND 
                     CcbPendep.flgest  = "P"           AND
                     CcbPendep.CodRef  <> "BOLD"        AND 
                     CcbPendep.fchcie <= F-Fecha NO-LOCK:
      FIND t-ccbpendep WHERE t-CcbPenDep.CodCia = CcbPendep.CodCia 
                       AND  t-CcbPenDep.CodDoc = CcbPendep.CodDoc 
                       AND  t-CcbPenDep.CodDiv = CcbPendep.CodDiv
                       AND  t-CcbPenDep.CodRef = CcbPenDep.CodRef
                       AND  t-CcbPenDep.NroRef = CcbPenDep.NroRef
                       AND  t-CcbPendep.FchCie = CcbPenDep.FchCie
                       NO-ERROR.
      IF NOT AVAIL t-CcbPenDep THEN DO:
        CREATE t-CcbPenDep.
        ASSIGN
            t-CcbPenDep.CodCia  = CcbPenDep.CodCia 
            t-CcbPenDep.CodDoc  = CcbPenDep.CodDoc 
            t-CcbPenDep.NroDoc  = CcbPenDep.NroDoc
            t-CcbPenDep.CodDiv  = CcbPenDep.CodDiv
            t-CcbPenDep.CodRef  = CcbPenDep.CodRef
            t-CcbPenDep.NroRef  = CcbPenDep.NroRef
            t-CcbPenDep.FlgEst  = CcbPenDep.FlgEst
            t-CcbPenDep.FchCie  = CcbPenDep.FchCie
            t-CcbPenDep.HorCie  = CcbPenDep.HorCie
            t-CcbPenDep.usuario = CcbPenDep.usuario.
      END.
      ASSIGN
          t-CcbPenDep.CodBco = CcbPenDep.CodBco
          t-CcbPenDep.FchVto = CcbPenDep.FchVto
          t-CcbPenDep.ImpNac = t-CcbPenDep.ImpNac + CcbPenDep.ImpNac
          t-CcbPenDep.SdoNac = t-CcbPenDep.SdoNac + CcbPenDep.SdoNac
          t-CcbPenDep.ImpUsa = t-CcbPenDep.ImpUsa + CcbPenDep.ImpUsa
          t-CcbPenDep.SdoUsa = t-CcbPenDep.SdoUsa + CcbPenDep.SdoUsa.
  END.
   
  FIND FIRST t-CcbPenDep NO-ERROR.
  IF AVAIL t-CcbPenDep THEN S-Der = TRUE.
  ELSE S-Der = FALSE.
   
  FIND FIRST T-CcbDMvto NO-ERROR.
  IF AVAIL T-CcbDMvto THEN S-Izq = TRUE.
  ELSE S-Izq = FALSE.
   
  RUN dispatch IN h_b-pendep ('open-query':U).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


