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
DEFINE     SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE     SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE     SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR wtotsol AS DEC NO-UNDO.
DEF VAR wtotdol AS DEC NO-UNDO.
DEF VAR wtotcts AS DEC NO-UNDO.
DEF VAR wtotctd AS DEC NO-UNDO.
DEF VAR wtotcrs AS DEC NO-UNDO.
DEF VAR wtotcrd AS DEC NO-UNDO.
DEF VAR wtipcam AS DEC NO-UNDO.

DEF VAR wfactor AS DECIMAL NO-UNDO.
DEF VAR I       AS INT NO-UNDO.

DEF VAR w-perio AS INT NO-UNDO.
DEF VAR w-mes   AS INT NO-UNDO.
DEF VAR w-dia   AS INT NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
wtipcam = FacCfgGn.Tpocmb[1] .

  DEFINE VARIABLE procname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ARCHIVO AS CHARACTER NO-UNDO.
  DEFINE VARIABLE OKpressed AS LOGICAL INITIAL TRUE.
  DEFINE TEMP-TABLE tempo LIKE Almmmatg.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 x-archivo BUTTON-FILE ~
BUTTON-12 BUTTON-13 BUTTON-14 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-2 FILL-IN-1 x-archivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-12 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Cerrar" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON BUTTON-13 AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON BUTTON-14 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "help" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON BUTTON-FILE 
     LABEL "..." 
     SIZE 3.86 BY .85.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 33.14 BY 4.23
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.29 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-archivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo" 
     VIEW-AS FILL-IN 
     SIZE 19.14 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.43 BY 7.54.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.14 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-2 AT ROW 1.19 COL 2 NO-LABEL
     FILL-IN-1 AT ROW 7.12 COL 2.14 NO-LABEL
     x-archivo AT ROW 5.77 COL 6.72 COLON-ALIGNED
     BUTTON-FILE AT ROW 5.77 COL 30.14
     BUTTON-12 AT ROW 1.46 COL 36
     BUTTON-13 AT ROW 3.38 COL 36
     BUTTON-14 AT ROW 5.31 COL 36
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 5.5 COL 2
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
         TITLE              = "Importar Catalogo de Materiales Ofimax"
         HEIGHT             = 7.5
         WIDTH              = 48.43
         MAX-HEIGHT         = 32.5
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 32.5
         VIRTUAL-WIDTH      = 164.57
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
                                                                        */
ASSIGN 
       BUTTON-FILE:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR EDITOR EDITOR-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       EDITOR-2:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Importar Catalogo de Materiales Ofimax */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Importar Catalogo de Materiales Ofimax */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Cerrar */
DO:
  ASSIGN
        x-archivo.
        
  MESSAGE " Esta seguro de importar Catalago de Materiales " VIEW-AS ALERT-BOX QUESTION 
  BUTTONS yes-no
  UPDATE wresp AS LOGICAL.
  CASE wresp:
       WHEN yes THEN DO:
            IF x-archivo = "" then DO:
               MESSAGE " Digite nombre de archivo" VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO x-archivo.
               return NO-APPLY.  
            END.   
            IF session:set-wait-state("GENERAL") THEN.
            RUN Importar-catalogo.
            IF session:set-wait-state(" ") then.
             MESSAGE " Proceso Terminado " VIEW-AS ALERT-BOX INFORMATION. 
         END.  
       WHEN no  THEN 
            RETURN.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON ENTRY OF BUTTON-12 IN FRAME F-Main /* Cerrar */
DO:
   IF BUTTON-12:LOAD-MOUSE-POINTER("GLOVE") THEN . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON ENTRY OF BUTTON-13 IN FRAME F-Main /* Cancelar */
DO:
  IF BUTTON-13:LOAD-MOUSE-POINTER("GLOVE") THEN . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 W-Win
ON ENTRY OF BUTTON-14 IN FRAME F-Main /* help */
DO:
  IF BUTTON-14:LOAD-MOUSE-POINTER("GLOVE") THEN. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-FILE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-FILE W-Win
ON CHOOSE OF BUTTON-FILE IN FRAME F-Main /* ... */
DO:
  procname = ?.
  SYSTEM-DIALOG GET-FILE procname
        TITLE      "Archivo ..."
        FILTERS    "Archivo de Texto (*.Txt)"   "*.txt"
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
      
    IF OKpressed = TRUE THEN DO:
        RUN adecomm/_osprefx.p ( procname, output procname, output archivo ).
        FILE-INFO:FILE-NAME = procname + archivo.
        IF INDEX(FILE-INFO:FILE-TYPE,"F") = 0 OR FILE-INFO:FILE-TYPE = ?
        THEN DO:
            MESSAGE "Invalido Archivo Ingresado" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        procname = FILE-INFO:FULL-PATHNAME.
    END.
    
    if procname <> "" THEN DO:
        DISPLAY procname @ x-archivo WITH FRAME {&FRAME-NAME}.
    end.
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
  DISPLAY EDITOR-2 FILL-IN-1 x-archivo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 x-archivo BUTTON-FILE BUTTON-12 BUTTON-13 BUTTON-14 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Catalogo W-Win 
PROCEDURE Importar-Catalogo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DISABLE TRIGGERS FOR LOAD OF Almmmatg.
    
  IF x-archivo <> "" THEN DO:
     FOR EACH tempo:
         DELETE tempo.
     END.
     INPUT FROM VALUE(x-archivo).
     REPEAT:   
        CREATE Tempo.
        IMPORT delimiter "|" tempo. 
     END.
     FOR EACH Tempo:
       FIND Almmmatg WHERE Almmmatg.Codcia = tempo.codcia and
                           Almmmatg.CodMat = tempo.codmat
                           NO-ERROR.
       IF NOT AVAILABLE Almmmatg THEN DO:
          CREATE Almmmatg.       
          RAW-TRANSFER Tempo TO Almmmatg.
          Almmmatg.UndBas = "UNI".
          Almmmatg.UndStk = "UNI".
          Almmmatg.UndCmp = "UNI".
          Almmmatg.Almacenes = "17".
          Almmmatg.MonVta = 1.
       END.   
     END.
 
 END.
 INPUT CLOSE.

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
  editor-2 = "   Este proceso importa el Catalogo de Materiales   
  a partir de un archivo de texto que tendrá que indicar al sistema.
  Antes de proceder verificar que  los  usuarios  se  retiren del 
  sistema".
  DISPLAY EDITOR-2 WITH FRAME {&FRAME-NAME}.
  
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


