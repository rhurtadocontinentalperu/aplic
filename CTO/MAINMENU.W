&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME mainmenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS mainmenu 
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
{BIN/S-GLOBAL.I}

DEFINE NEW SHARED VARIABLE  S-PERIODO    AS INTEGER FORMAT "9999" INIT 1996.
DEFINE NEW SHARED VARIABLE  S-NROMES     AS INTEGER FORMAT "9999" .
DEFINE NEW SHARED VARIABLE  s-CodFam     AS CHAR.
/* DEFINE NEW SHARED VARIABLE  CB-codcia    AS INTEGER INIT 0. */
/* DEFINE NEW SHARED VARIABLE  PV-codcia    AS INTEGER INIT 0. */
/* DEFINE NEW SHARED VARIABLE  CL-codcia    AS INTEGER INIT 0. */
DEFINE NEW SHARED VARIABLE  CB-MaxNivel  AS INTEGER.
DEFINE NEW SHARED VARIABLE  CB-Niveles   AS CHAR.
DEFINE NEW SHARED VARIABLE  xterm as char.
DEFINE NEW SHARED VARIABLE  S-CODALM     AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE  S-DESALM     AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE  S-CODDIV     AS CHAR INIT "".
DEFINE NEW SHARED VARIABLE  s-codter     AS CHAR.

DEFINE VAR NRO-POS AS INT .
DEFINE VARIABLE P-LIST AS CHAR NO-UNDO.

RUN cbd/cb-m000.r(OUTPUT P-LIST).
IF P-LIST = "" THEN DO:
   MESSAGE "No existen periodos asignados para " skip
            "la empresa" s-codcia VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
P-LIST = SUBSTRING ( P-LIST , 1, LENGTH(P-LIST) - 1 ).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartMenu
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-mmenu FILL-PERIODO-1 F-mes f-Div f-Term ~
CB-Almacen 
&Scoped-Define DISPLAYED-OBJECTS FILL-PERIODO-1 F-mes F-N-MES f-Div f-Term ~
CB-Almacen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR mainmenu AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE CB-Almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 7
     DROP-DOWN-LIST
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE f-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 6 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-Term AS CHARACTER FORMAT "X(30)":U 
     LABEL "Terminal" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-PERIODO-1 AS DECIMAL FORMAT "9999":U INITIAL ? 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-N-MES AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-mmenu
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113 BY 1.35
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-PERIODO-1 AT ROW 1.19 COL 6 COLON-ALIGNED
     F-mes AT ROW 1.19 COL 17 COLON-ALIGNED HELP
          "Mes Actual"
     F-N-MES AT ROW 1.19 COL 23 COLON-ALIGNED NO-LABEL
     f-Div AT ROW 1.19 COL 41 COLON-ALIGNED
     f-Term AT ROW 1.19 COL 57 COLON-ALIGNED
     CB-Almacen AT ROW 1.19 COL 73.28
     RECT-mmenu AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.29 BY 1.38
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartMenu
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW mainmenu ASSIGN
         HIDDEN             = YES
         TITLE              = "Costos"
         HEIGHT             = 1.46
         WIDTH              = 113.29
         MAX-HEIGHT         = 1.73
         MAX-WIDTH          = 113.29
         VIRTUAL-HEIGHT     = 1.73
         VIRTUAL-WIDTH      = 113.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT mainmenu:LOAD-ICON("img\climnu5":U) THEN
    MESSAGE "Unable to load icon: img\climnu5"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB mainmenu 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW mainmenu
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR COMBO-BOX CB-Almacen IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN F-N-MES IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(mainmenu)
THEN mainmenu:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME mainmenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mainmenu mainmenu
ON END-ERROR OF mainmenu /* Costos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
    /* This case occurs when the user presses the "Esc" key.
       In a persistently run window, just ignore this.  If we did not, the
       application would exit. */
    IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mainmenu mainmenu
ON WINDOW-CLOSE OF mainmenu /* Costos */
DO:
    /* This ADM code must be left here in order for the SmartWindow
       and its descendents to terminate properly on exit. */
    RUN SALIR.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-Almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-Almacen mainmenu
ON VALUE-CHANGED OF CB-Almacen IN FRAME F-Main /* Almacen */
DO:
  
  ASSIGN CB-Almacen.

  NRO-POS = INDEX(CB-Almacen, "-").
  S-CODALM = SUBSTRING(CB-Almacen,1,3,"CHARACTER").
/*  S-DESALM = SUBSTRING(CB-Almacen,7,LENGTH(CB-Almacen,"CHARACTER") - 6,"CHARACTER").*/
  S-DESALM = SUBSTRING(CB-Almacen,(NRO-POS + 2),LENGTH(CB-Almacen,"CHARACTER") - 6,"CHARACTER").
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
       Almacen.CodDiv = S-CODDIV AND
       Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
  /*IF AVAILABLE Almacen THEN S-CODDIV = Almacen.CodDiv.*/
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-Div
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-Div mainmenu
ON VALUE-CHANGED OF f-Div IN FRAME F-Main /* Division */
DO:

 /*Almacenes*/    
  S-CODDIV = f-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  DEFINE VAR LIST-ALM AS CHAR INIT "".
  FIND FIRST AlmUsers WHERE AlmUsers.CodCia = S-CODCIA AND
             AlmUsers.User-Id = S-User-Id NO-LOCK NO-ERROR.
  IF AVAILABLE AlmUsers THEN DO:
        FOR EACH AlmUsers NO-LOCK WHERE AlmUsers.CodCia = S-CODCIA AND
            AlmUsers.User-Id = S-User-Id:
            FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
                 Almacen.CodDiv = S-CODDIV AND
                 Almacen.CodAlm = AlmUsers.CodAlm NO-LOCK NO-ERROR.
            IF AVAILABLE  Almacen THEN 
               LIST-ALM = LIST-ALM + "," + AlmUsers.CodAlm + 
                          " - " + REPLACE(Almacen.Descripcion,","," ").
        END.
        IF LIST-ALM <> "" THEN DO WITH FRAME {&FRAME-NAME}:
           LIST-ALM = SUBSTRING(LIST-ALM,2,LENGTH(LIST-ALM,"CHARACTER") - 1,"CHARACTER").
           CB-Almacen:LIST-ITEMS = LIST-ALM.
           CB-Almacen:SCREEN-VALUE = ENTRY(1,LIST-ALM).
           ASSIGN CB-Almacen.
           NRO-POS = INDEX(CB-Almacen, "-").
           S-CODALM = SUBSTRING(CB-Almacen,1,3,"CHARACTER").
           S-DESALM = SUBSTRING(CB-Almacen,(NRO-POS + 2),LENGTH(CB-Almacen,"CHARACTER") - 6,"CHARACTER").
        END.
  END.
  ELSE DO:
        FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = S-CODCIA AND
            Almacen.CodDiv = S-CODDIV:
            LIST-ALM = LIST-ALM + "," + Almacen.CodAlm + " - " + REPLACE(Almacen.Descripcion,","," ").
        END.
        IF LIST-ALM <> "" THEN DO WITH FRAME {&FRAME-NAME}:
           LIST-ALM = SUBSTRING(LIST-ALM,2,LENGTH(LIST-ALM,"CHARACTER") - 1,"CHARACTER").
           CB-Almacen:LIST-ITEMS = LIST-ALM.
           CB-Almacen:SCREEN-VALUE = ENTRY(1,LIST-ALM).
           ASSIGN CB-Almacen.
           NRO-POS = INDEX(CB-Almacen, "-").
           S-CODALM = SUBSTRING(CB-Almacen,1,3,"CHARACTER").
           S-DESALM = SUBSTRING(CB-Almacen,(NRO-POS + 2),LENGTH(CB-Almacen,"CHARACTER") - 6,"CHARACTER").
        END.
  END.
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
       Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN S-CODDIV = Almacen.CodDiv.
  
  /*Terminales*/
    DEFINE VAR LIST-TERM AS CHAR INIT "".
    S-CODTER = F-TERM:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    FOR EACH CcbCTerm NO-LOCK WHERE CcbCTerm.CodCia = s-CodCia AND
        CcbCTerm.CodDiv = s-CodDiv:
        LIST-TERM = LIST-TERM + "," + CcbCTerm.CodTer.
    END.         
    IF LIST-TERM <> "" THEN DO WITH FRAME {&FRAME-NAME}:
       LIST-TERM = SUBSTRING(LIST-TERM,2,LENGTH(LIST-TERM,"CHARACTER") - 1,"CHARACTER").
       f-Term:LIST-ITEMS = LIST-TERM.
       f-Term:SCREEN-VALUE = ENTRY(1,LIST-TERM).
       ASSIGN f-Term.
       s-Codter = F-TERM:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    END.
    ELSE f-Term:LIST-ITEMS = "".
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-mes mainmenu
ON VALUE-CHANGED OF F-mes IN FRAME F-Main /* Mes */
DO:
    Assign f-mes.
    s-nromes = f-mes.
    run bin/_mes( f-mes , 1 , output f-n-mes ).
    display f-n-mes with frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-Term
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-Term mainmenu
ON VALUE-CHANGED OF f-Term IN FRAME F-Main /* Terminal */
DO:
    s-codter = f-term:screen-value in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-PERIODO-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-PERIODO-1 mainmenu
ON VALUE-CHANGED OF FILL-PERIODO-1 IN FRAME F-Main /* Periodo */
DO:
   DEF VAR OLD-PERIODO AS INTEGER INIT 1.
   
   OLD-PERIODO = FILL-PERIODO-1.
   
   ASSIGN S-PERIODO      = INPUT FILL-PERIODO-1.
  
   IF S-PERIODO < OLD-PERIODO THEN DO:
      Assign f-mes = 12
             f-mes:screen-value = "12"
             s-nromes = 12.
             run bin/_mes( f-mes , 1 , output f-n-mes ).
             display f-n-mes with frame {&FRAME-NAME}. 
   END.
   ELSE DO:
        IF S-PERIODO > YEAR(TODAY) THEN S-NROMES =  1.
        ELSE S-NROMES = 12.
        Assign f-mes = S-NROMES.
        run bin/_mes( f-mes , 1 , output f-n-mes ).
        display f-mes f-n-mes with frame {&FRAME-NAME}. 
   END.    

   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK mainmenu 


/* ***************************  Main Block  *************************** */
/* Include custom  Main Block code for SmartWindows. */

{adm-vm/method/vmmenu.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects mainmenu  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available mainmenu  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI mainmenu  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(mainmenu)
  THEN DELETE WIDGET mainmenu.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI mainmenu  _DEFAULT-ENABLE
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
  DISPLAY FILL-PERIODO-1 F-mes F-N-MES f-Div f-Term CB-Almacen 
      WITH FRAME F-Main IN WINDOW mainmenu.
  ENABLE RECT-mmenu FILL-PERIODO-1 F-mes f-Div f-Term CB-Almacen 
      WITH FRAME F-Main IN WINDOW mainmenu.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW mainmenu.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit mainmenu 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize mainmenu 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  /*Periodos*/ 
  FILL-PERIODO-1 = ?.
  DO WITH FRAME {&FRAME-NAME} :
     FILL-PERIODO-1:LIST-ITEMS = P-LIST.
     FILL-PERIODO-1:SCREEN-VALUE = ENTRY(LOOKUP(STRING(YEAR(TODAY)),P-LIST) , P-LIST).  /* INTEGER(ENTRY(NUM-ENTRIES(P-LIST) , P-LIST)). */
     FILL-PERIODO-1 = INTEGER(ENTRY(LOOKUP(STRING(YEAR(TODAY)),P-LIST) , P-LIST)).
     S-Periodo    = FILL-PERIODO-1.
     IF S-PERIODO = YEAR( TODAY ) THEN S-NROMES = MONTH ( TODAY).
     ELSE DO:
          IF S-PERIODO > YEAR(TODAY) THEN S-NROMES =  1.
          ELSE S-NROMES = 12.
     END.    
     F-mes = S-NROMES.
     run bin/_mes( f-mes , 1 , output f-n-mes ).
     display F-mes f-n-mes.
  END.

  /*Divisiones*/  
  DEFINE VAR LIST-DIVI AS CHAR INIT "".
  DEFINE VAR p as logical no-undo.
  s-CodDiv = f-Div:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  
  FIND FIRST FacUsers WHERE FacUsers.CodCia = s-codcia AND
       FacUsers.Usuario = s-user-id NO-LOCK NO-ERROR.
  IF AVAILABLE FacUsers THEN DO:
    FOR EACH FacUsers WHERE FacUsers.CodCia = S-Codcia AND
        FacUsers.Usuario = S-user-id:
        FIND Gn-Divi WHERE Gn-Divi.CodCia = s-codCia AND
             Gn-Divi.CodDiv = FacUser.CodDiv NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-Divi THEN 
            LIST-DIVI = LIST-DIVI + "," + FacUsers.CodDiv.
    END.
    IF LIST-DIVI <> "" THEN DO WITH FRAME {&FRAME-NAME}:
       LIST-DIVI = SUBSTRING(LIST-DIVI,2,LENGTH(LIST-DIVI,"CHARACTER") - 1,"CHARACTER").
       f-Div:LIST-ITEMS = LIST-DIVI.
       f-Div:SCREEN-VALUE = ENTRY(1,LIST-DIVI).
       ASSIGN f-Div.
       S-CodDiv = f-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    END.
  END.

  /*Cargar los terminales*/   
  DEFINE VAR LIST-TERM AS CHAR INIT "".
  S-CODTER = F-TERM:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  FOR EACH CcbCTerm NO-LOCK WHERE CcbCTerm.CodCia = s-CodCia AND
      CcbCTerm.CodDiv = S-CodDiv:
      LIST-TERM = LIST-TERM + "," + CcbCTerm.CodTer.
  END.         
  IF LIST-TERM <> "" THEN DO WITH FRAME {&FRAME-NAME}:
     LIST-TERM = SUBSTRING(LIST-TERM,2,LENGTH(LIST-TERM,"CHARACTER") - 1,"CHARACTER").
     f-Term:LIST-ITEMS = LIST-TERM.
     f-Term:SCREEN-VALUE = ENTRY(1,LIST-TERM).
     ASSIGN f-Term.
     s-Codter = F-TERM:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  END.
  
  /*Almacenes*/
  S-CODDIV = f-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  DEFINE VAR LIST-ALM AS CHAR INIT "".
  FIND FIRST AlmUsers WHERE AlmUsers.CodCia = S-CODCIA AND
             AlmUsers.User-Id = S-User-Id NO-LOCK NO-ERROR.
  IF AVAILABLE AlmUsers THEN DO:
        FOR EACH AlmUsers NO-LOCK WHERE AlmUsers.CodCia = S-CODCIA AND
            AlmUsers.User-Id = S-User-Id:
            FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
                 Almacen.CodDiv = S-CODDIV AND
                 Almacen.CodAlm = AlmUsers.CodAlm NO-LOCK NO-ERROR.
            IF AVAILABLE  Almacen THEN 
               LIST-ALM = LIST-ALM + "," + AlmUsers.CodAlm + 
                          " - " + REPLACE(Almacen.Descripcion,","," ").
        END.
        IF LIST-ALM <> "" THEN DO WITH FRAME {&FRAME-NAME}:
           LIST-ALM = SUBSTRING(LIST-ALM,2,LENGTH(LIST-ALM,"CHARACTER") - 1,"CHARACTER").
           CB-Almacen:LIST-ITEMS = LIST-ALM.
           CB-Almacen:SCREEN-VALUE = ENTRY(1,LIST-ALM).
           ASSIGN CB-Almacen.
           NRO-POS = INDEX(CB-Almacen, "-").
           S-CODALM = SUBSTRING(CB-Almacen,1,3,"CHARACTER").
           S-DESALM = SUBSTRING(CB-Almacen,(NRO-POS + 2),LENGTH(CB-Almacen,"CHARACTER") - 6,"CHARACTER").
        END.
  END.
  ELSE DO:
        FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = S-CODCIA AND
            Almacen.CodDiv = S-CODDIV:
            LIST-ALM = LIST-ALM + "," + Almacen.CodAlm + " - " + REPLACE(Almacen.Descripcion,","," ").
        END.
        IF LIST-ALM <> "" THEN DO WITH FRAME {&FRAME-NAME}:
           LIST-ALM = SUBSTRING(LIST-ALM,2,LENGTH(LIST-ALM,"CHARACTER") - 1,"CHARACTER").
           CB-Almacen:LIST-ITEMS = LIST-ALM.
           CB-Almacen:SCREEN-VALUE = ENTRY(1,LIST-ALM).
           ASSIGN CB-Almacen.
           NRO-POS = INDEX(CB-Almacen, "-").
           S-CODALM = SUBSTRING(CB-Almacen,1,3,"CHARACTER").
           S-DESALM = SUBSTRING(CB-Almacen,(NRO-POS + 2),LENGTH(CB-Almacen,"CHARACTER") - 6,"CHARACTER").
        END.
  END.
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
       Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN S-CODDIV = Almacen.CodDiv.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records mainmenu  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartMenu, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed mainmenu 
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

