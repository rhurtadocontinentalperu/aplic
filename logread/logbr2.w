&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME hwin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS hwin 
/*------------------------------------------------------------------------

  File: logread/logbr2.w

  Description: This is the Log Browse window

  Parameters:
    htt       - [IN] handle of the temp-table containing the log file
    cFileName - [IN] name of the log file
    cTitle    - [IN] title of the Log Browse window
    cWhere    - [IN] text of initial log filter query to use
    irows     - [IN] number of rows in the log file temp-table
    hproc     - [IN] handle of this log file's log type handler  
    hcopywin  - [IN] handle of log browse window to copy UI from.

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT PARAM htt AS HANDLE NO-UNDO.
DEF INPUT PARAM cFileName AS CHAR NO-UNDO.
DEF INPUT PARAM cTitle AS CHAR NO-UNDO.
DEF INPUT PARAM cWhere AS CHARACTER  NO-UNDO.
DEF INPUT PARAM irows AS INT NO-UNDO.
DEF INPUT PARAM hproc AS HANDLE NO-UNDO.
DEF INPUT PARAM hcopywin AS HANDLE NO-UNDO.

/* global variables */
{logread/logglob.i " "}

/* help context ids */
{logread/loghelp.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hframe AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbr AS HANDLE     NO-UNDO.
DEFINE VARIABLE htxt AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbut AS HANDLE     NO-UNDO.
DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
DEFINE VARIABLE ifld AS INTEGER    NO-UNDO.
DEFINE VARIABLE lLoaded AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hutilmenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE hqrymenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE hcolmenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE hmainmenu AS HANDLE     NO-UNDO.
DEFINE VARIABLE hsrchwin AS HANDLE     NO-UNDO.
DEFINE VARIABLE hsrchqry AS HANDLE     NO-UNDO.
DEFINE VARIABLE hsrchbuf AS HANDLE     NO-UNDO.
DEFINE VARIABLE csrchqry AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cutilfunc AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cutilqry AS CHARACTER  NO-UNDO.
DEFINE VARIABLE chidcol AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ctxtcols AS CHARACTER  NO-UNDO.
DEFINE VARIABLE clogtype AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iwinh AS INTEGER    NO-UNDO.
DEFINE VARIABLE isplitx AS INTEGER    NO-UNDO.
DEFINE VARIABLE isplity AS INTEGER    NO-UNDO.
DEFINE VARIABLE ibrminh AS INTEGER    NO-UNDO.
DEFINE VARIABLE itxtminh AS INTEGER INIT 2 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR hwin AS WIDGET-HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 16.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW hwin ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16
         WIDTH              = 80
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW hwin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(hwin)
THEN hwin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME hwin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hwin hwin
ON END-ERROR OF hwin
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN 
  DO:
      RUN endProc.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hwin hwin
ON WINDOW-CLOSE OF hwin
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hwin hwin
ON WINDOW-RESIZED OF hwin
DO:
    DEFINE VARIABLE imovey AS INTEGER    NO-UNDO.

    imovey = hwin:HEIGHT-PIXELS - iwinh.
    
    IF (imovey < 0) THEN
        ASSIGN 
        hbr:HEIGHT-PIXELS = hbr:HEIGHT-PIXELS + imovey 
        htxt:Y = htxt:Y + imovey
        hbut:Y = hbut:Y + imovey
        hframe:HEIGHT-PIXELS = hwin:HEIGHT-PIXELS
        hframe:VIRTUAL-HEIGHT-PIXELS = hframe:HEIGHT-PIXELS
        .
    ELSE IF (imovey > 0) THEN
        ASSIGN 
        hframe:HEIGHT-PIXELS = hwin:HEIGHT-PIXELS
        hframe:VIRTUAL-HEIGHT-PIXELS = hframe:HEIGHT-PIXELS
        hbut:Y = hbut:Y + imovey
        hbr:HEIGHT-PIXELS = hbr:HEIGHT-PIXELS + imovey 
        htxt:Y = htxt:Y + imovey
        .

  ASSIGN 
      hframe:WIDTH-PIXELS = hwin:WIDTH-PIXELS
      hframe:VIRTUAL-WIDTH-PIXELS = hframe:WIDTH-PIXELS
      hbr:WIDTH-PIXELS = hframe:WIDTH-PIXELS - (hframe:BORDER-LEFT-PIXELS + hframe:BORDER-RIGHT-PIXELS)
      htxt:WIDTH-PIXELS = hbr:WIDTH-PIXELS 
      hbut:WIDTH-PIXELS = hbr:WIDTH-PIXELS
      .

  iwinh = hwin:HEIGHT-PIXELS.
  RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DEFAULT-FRAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME hwin
ON HELP OF FRAME DEFAULT-FRAME
DO:
  RUN displayHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK hwin 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
DO:
    RUN endProc.
    RETURN NO-APPLY.
END.

/* create dynamic menus */
RUN initialiseMenu.
/* get utility and query information from the handler */
RUN getHandlerInfo.
/* create dynamic browse for log file rows */
RUN createBrowser.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    VIEW FRAME DEFAULT-FRAME IN WINDOW hwin.
    VIEW hwin.
    APPLY "entry":U TO hbr.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyMsgs hwin 
PROCEDURE copyMsgs :
/*------------------------------------------------------------------------------
  Purpose:     Copies selected messages to the clipboard
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cclip AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE irow AS INTEGER    NO-UNDO.

  OUTPUT TO "CLIPBOARD".
  /* for each, dump list of fields */  
  DO irow = 1 TO hbr:NUM-SELECTED-ROWS:
      hbr:FETCH-SELECTED-ROW(irow).
      DO ictr = 1 TO hbuf:NUM-FIELDS:
          hfld = hbuf:BUFFER-FIELD(ictr).
          PUT UNFORMATTED hfld:BUFFER-VALUE " " .
      END.
      PUT UNFORMATTED CHR(13) SKIP.
  END.
  OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowser hwin 
PROCEDURE createBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Creates the dynamic browse for the log file, and the 
               splitter and editor for the log browse window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CREATE QUERY hqry.

    DEFINE VARIABLE itxth AS INTEGER INIT 50   NO-UNDO.
    DEFINE VARIABLE ibuth AS INTEGER INIT 8   NO-UNDO.
    DEFINE VARIABLE howin AS HANDLE /* INIT ? */  NO-UNDO.
    DEFINE VARIABLE hobr AS HANDLE /* INIT ? */  NO-UNDO.
    DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hocol AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cbrcol AS CHARACTER INIT ? NO-UNDO.
    DEFINE VARIABLE cedcol AS CHARACTER INIT ? NO-UNDO.

    
    CREATE BUFFER hbuf FOR TABLE htt:DEFAULT-BUFFER-HANDLE.
    hqry:SET-BUFFERS(hbuf).
    RUN queryReOpen(cWhere).

    ASSIGN 
        howin = ?
        hobr = ? NO-ERROR.
    /* get the UI from hcopywin, if passed */
    IF VALID-HANDLE(hcopywin) AND 
        (CAN-DO(hcopywin:INTERNAL-ENTRIES,"getUIInfo")) THEN
    DO:
        RUN getUIInfo IN hcopywin(OUTPUT howin,OUTPUT hobr,OUTPUT ctxtcols,OUTPUT itxth).
        /* set the window height */
        ASSIGN 
            hwin:HEIGHT-PIXELS = howin:HEIGHT-PIXELS
            hwin:WIDTH-PIXELS = howin:WIDTH-PIXELS
            hframe:HEIGHT-PIXELS = hwin:HEIGHT-PIXELS
            hframe:WIDTH-PIXELS = hwin:WIDTH-PIXELS
            hframe:VIRTUAL-HEIGHT-PIXELS = hframe:HEIGHT-PIXELS            
            hframe:VIRTUAL-WIDTH-PIXELS = hframe:WIDTH-PIXELS            
            .
    END.
    ELSE
    DO:
        /* get browse and editor columns from saved attributes */
        RUN getHandlerAttribute IN ghlogutils(hproc,?,"browsecols",OUTPUT cbrcol).
        RUN getHandlerAttribute IN ghlogutils(hproc,?,"editorcols",OUTPUT cedcol).
        IF cedcol <> ? THEN
            ctxtcols = cedcol.
    END.

    /* create the editor window */
    CREATE EDITOR htxt
        ASSIGN FRAME = hframe
               WIDTH-PIXELS = hframe:WIDTH-PIXELS - (hframe:BORDER-LEFT-PIXELS + hframe:BORDER-RIGHT-PIXELS)
               HEIGHT-PIXELS = itxth 
               X = hframe:BORDER-LEFT-PIXELS
               Y = hframe:HEIGHT-PIXELS - hframe:BORDER-BOTTOM-PIXELS - itxth
               SCROLLBAR-VERTICAL = TRUE
               SCROLLBAR-HORIZONTAL = FALSE
               WORD-WRAP = TRUE
               SENSITIVE = TRUE
               READ-ONLY = TRUE
               VISIBLE = FALSE
        TRIGGERS:
            ON 'CTRL-F':U 
                PERSISTENT RUN startSearch IN THIS-PROCEDURE.
            ON 'CTRL-L':U
                PERSISTENT RUN setFilter IN THIS-PROCEDURE.
        END TRIGGERS.

    /* create the "splitter" button, hardcoded height, position above the editor */
    CREATE BUTTON hbut
        ASSIGN FRAME = hframe
               WIDTH-PIXELS = hframe:WIDTH-PIXELS - (hframe:BORDER-LEFT-PIXELS + hframe:BORDER-RIGHT-PIXELS)
               HEIGHT-PIXELS = ibuth /* hardcoded */
               X = hframe:BORDER-LEFT-PIXELS
               Y = htxt:Y - ibuth 
               MOVABLE = TRUE
               SENSITIVE = TRUE
               VISIBLE = FALSE
               NO-FOCUS = TRUE
               FLAT-BUTTON = TRUE
        TRIGGERS:
          ON 'start-move':U 
              PERSISTENT RUN splitterStartMove IN THIS-PROCEDURE.
          ON 'end-move':U 
              PERSISTENT RUN splitterEndMove IN THIS-PROCEDURE.
        END TRIGGERS.

    /* create the browse, position above the "splitter" button */
    CREATE BROWSE hbr
        ASSIGN FRAME = hframe 
               X = hframe:BORDER-LEFT-PIXELS
               Y = hframe:BORDER-TOP-PIXELS
               WIDTH-PIXELS = hframe:WIDTH-PIXELS - (hframe:BORDER-LEFT-PIXELS + hframe:BORDER-RIGHT-PIXELS)
               HEIGHT-PIXELS = hbut:Y - hframe:BORDER-TOP-PIXELS 
               QUERY = hqry
               SENSITIVE = TRUE
               VISIBLE = FALSE
               READ-ONLY = FALSE
               SEPARATORS = TRUE
               COLUMN-RESIZABLE = TRUE
               COLUMN-MOVABLE = TRUE
               ROW-MARKERS = FALSE
               EXPANDABLE = TRUE
               MAX-DATA-GUESS = irows
               MULTIPLE = TRUE
            TRIGGERS:
              ON 'CTRL-C':U 
                  PERSISTENT RUN copyMsgs IN THIS-PROCEDURE.
              ON 'CTRL-F':U 
                  PERSISTENT RUN startSearch IN THIS-PROCEDURE.
              ON 'CTRL-L':U
                  PERSISTENT RUN setFilter IN THIS-PROCEDURE.
              ON VALUE-CHANGED
                  PERSISTENT RUN showRowInfo IN THIS-PROCEDURE.
            END TRIGGERS.
    
    /* add columns to the browse */
    DO ifld = 1 TO hbuf:NUM-FIELDS:
        hcol = hbr:ADD-LIKE-COLUMN(hbuf:BUFFER-FIELD(ifld),ifld).
        /* if we are copying another browse, set the width and 
         * visibility from that */
        IF VALID-HANDLE(hobr) THEN
        DO:
            /* find this column's field in hobr
             * assuming they are in the same order as the fields
             * in hbuf, which they should be */ 
            hocol = hobr:GET-BROWSE-COLUMN(ifld).
            ASSIGN 
                /* set the width */
                hcol:WIDTH-PIXELS = hocol:WIDTH-PIXELS
                /* set the visibility */
                hcol:VISIBLE = hocol:VISIBLE.
        END.
        ELSE
        DO:
            /* set visible browse columns */
            /* if there were saved attributes for browse cols, use these instead */
            IF (cbrcol <> ?) THEN
            DO:
                /* hide the column if not in cbrcol */
                IF (LOOKUP(hbuf:BUFFER-FIELD(ifld):NAME,cbrcol) = 0) THEN
                    RUN showColumn(?,hbuf:BUFFER-FIELD(ifld):NAME,FALSE).
            END.
            ELSE
            DO:
                /* set visible browse column if not a hidden column */
                IF (lookup(hbuf:buffer-field(ifld):name,chidcol) > 0) THEN
                    RUN showColumn(?,hbuf:buffer-field(ifld):name,FALSE).
            END.
            /* set visible editor columns */
            /* if there were no saved attributes for the editor cols, display all */
            IF (cedcol = ?) THEN
                ctxtcols = ctxtcols + (IF ctxtcols = "" THEN "" ELSE ",") + 
                    hbuf:BUFFER-FIELD(ifld):NAME.
        END.
    END.
    
    IF (NOT VALID-HANDLE(hobr)) THEN
        RUN resizeCols.

    ASSIGN 
        hbr:VISIBLE = TRUE 
        htxt:VISIBLE = TRUE
        hbut:VISIBLE = TRUE
        .

    /* and fix up the window size, so we can resize */
    ASSIGN
        hwin:MAX-HEIGHT  = 160
        hwin:MAX-WIDTH   = 320
        hwin:TITLE       = cTitle
        ibrminh = (hbr:ROW-HEIGHT-PIXELS * 6)
        iwinh = hwin:HEIGHT-PIXELS
        hwin:MIN-HEIGHT-PIXELS = 
            hbut:HEIGHT-PIXELS + htxt:HEIGHT-PIXELS +
            ibrminh
        .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI hwin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(hwin)
  THEN DELETE WIDGET hwin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayHelp hwin 
PROCEDURE displayHelp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&LOGREADHELP} {&Log_Browse_window} .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI hwin  _DEFAULT-ENABLE
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
  VIEW FRAME DEFAULT-FRAME IN WINDOW hwin.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW hwin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endProc hwin 
PROCEDURE endProc :
/*------------------------------------------------------------------------------
  Purpose:     Closes this log browse window, and destroys associated objects
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* delete the buffer */
  DELETE OBJECT hbuf.
  /* delete any search objects */
  IF VALID-HANDLE(hsrchqry) THEN
  DO:
      hsrchqry:QUERY-CLOSE().
      DELETE OBJECT hsrchqry.
      DELETE OBJECT hsrchbuf.
      IF VALID-HANDLE(hsrchwin) THEN
          DELETE PROCEDURE hsrchwin.
  END.
  /* delete the log browse from the parent's list */
  RUN deleteViewer IN ghlogutils(THIS-PROCEDURE,cTitle).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCurrentBuffer hwin 
PROCEDURE getCurrentBuffer :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle to a buffer containin the 
               first selected row in the browse
  Parameters:
    hobuf - [OUT] handle to selected buffer
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM hobuf AS HANDLE NO-UNDO.
    IF hbr:NUM-SELECTED-ROWS < 1 THEN
        hobuf = ?.
    ELSE
    DO:
        hbr:FETCH-SELECTED-ROW(1).
        hobuf = hbuf .
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFileName hwin 
PROCEDURE getFileName :
/*------------------------------------------------------------------------------
  Purpose:     Returns the name of the file being displayed by this 
               Log Browse Window
  Parameters:  
    coFileName - [OUT] file name of log file
  Notes:       For use by other procedures to get the file name.
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM coFileName AS CHAR NO-UNDO.
    coFileName = cFileName.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHandlerInfo hwin 
PROCEDURE getHandlerInfo :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves information from this log file's log type handler,
               and builds Utility and Query menus
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hmenuitem AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hlogbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ctmp AS CHARACTER  NO-UNDO.

  /* some initial handle setup first */
  ASSIGN 
      hframe = FRAME Default-frame:HANDLE.

  /* this info all contained in ttlogtype buffer */
  RUN getHandlerInfo IN ghlogutils(INPUT ?,INPUT hproc,INPUT cFileName, OUTPUT hlogbuf).
  IF VALID-HANDLE(hlogbuf) THEN
  DO:
      ASSIGN
          hfld = hlogbuf:BUFFER-FIELD("utilfunc")
          cutilfunc = hfld:BUFFER-VALUE.
      ASSIGN
          hfld = hlogbuf:BUFFER-FIELD("utilqry")
          cutilqry = hfld:BUFFER-VALUE.
      ASSIGN
          hfld = hlogbuf:BUFFER-FIELD("chidcols")
          chidcol = hfld:BUFFER-VALUE.
      ASSIGN 
          hfld = hlogbuf:BUFFER-FIELD("logtype")
          clogtype = hfld:BUFFER-VALUE.

      /* default query if necessary */
      IF cWhere = ? THEN
      DO:
          IF hproc <> ? THEN 
          DO:
              IF can-do(hproc:INTERNAL-ENTRIES,"getQuery") THEN
                  RUN getQuery IN hproc(INPUT "Default",OUTPUT cWhere).
              ELSE 
                  cWhere = "TRUE". /* default if no default given */
          END.
          ELSE
          DO:
              RUN getPseudoTypeQuery IN ghlogutils(INPUT "Default",INPUT cFileName,OUTPUT cWhere).
              IF cWhere = "" OR cWhere = "" THEN
                  cWhere = "true". /* default if no default given */
          END.
      END.
  END.

  /* create utilities menu */
  IF cutilfunc <> "" AND cutilfunc <> ? THEN
  DO:
    DO ictr = 1 TO NUM-ENTRIES(cutilfunc):
        ctmp = ENTRY(ictr,cutilfunc).
        CREATE MENU-ITEM hmenuitem
            ASSIGN PARENT = hutilmenu
            LABEL = ctmp
            TRIGGERS:
              ON choose
                  PERSISTENT RUN runUtility IN THIS-PROCEDURE (ctmp).
            END TRIGGERS.
    END.
  END.
  ELSE
      /* disable queries menu */
      hutilmenu:SENSITIVE = FALSE.

  /* create queries menu */
  IF cutilqry <> "" AND cutilqry <> ? THEN
  DO:
    DO ictr = 1 TO NUM-ENTRIES(cutilqry):
        ctmp = ENTRY(ictr,cutilqry).
        CREATE MENU-ITEM hmenuitem
            ASSIGN 
            PARENT = hqrymenu
            LABEL = ctmp
            TRIGGERS:
              ON CHOOSE
                  PERSISTENT RUN runQuery IN THIS-PROCEDURE (ctmp).
            END TRIGGERS.
    END.
  END.
  ELSE
      /* disable utils menu */
      hqrymenu:SENSITIVE = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUIInfo hwin 
PROCEDURE getUIInfo :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handles to the window and browse, 
               and the list of editor columns, in this Log Browse window
  Parameters:  
    howin   - [OUT] handle to the window
    hobr    - [OUT] handle to the browse
    cedcols - [OUT] CSV list of editor columns to display
  Notes:       This is to allow other Log Browse windows to resize themselves
               the same way as the current window.
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAM howin AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM hobr AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM cedcols AS CHAR NO-UNDO.
  DEF OUTPUT PARAM iotxth AS INT NO-UNDO.

  ASSIGN 
      howin = hwin
      hobr = hbr
      cedcols = ctxtcols
      iotxth = htxt:HEIGHT-PIXELS.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialiseMenu hwin 
PROCEDURE initialiseMenu :
/*------------------------------------------------------------------------------
  Purpose:     Creates the dynamic menubar for the Log Browse window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE htmpmenu AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htmpitem AS HANDLE     NO-UNDO.

  CREATE MENU hmainmenu.
  /* file menu */
  CREATE SUB-MENU htmpmenu
      ASSIGN 
      PARENT = hmainmenu
      LABEL = "&Log".
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Open New Browse"
      TRIGGERS:
      ON choose
          PERSISTENT RUN openViewer IN THIS-PROCEDURE.
  END TRIGGERS.
  CREATE MENU-ITEM htmpitem
    ASSIGN
    PARENT = htmpmenu
    LABEL = "&Filter..."
    ACCELERATOR = "CTRL-L"
    TRIGGERS:
    ON CHOOSE 
       PERSISTENT RUN setFilter IN THIS-PROCEDURE.
    END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "Filter as &New Log"
      TRIGGERS:
      ON choose
          PERSISTENT RUN setFilterAsLog IN THIS-PROCEDURE.
      END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Dump to File..."
      TRIGGERS:
      ON choose
          PERSISTENT RUN runDump IN THIS-PROCEDURE.
      END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Run Utility..."
      TRIGGERS:
      ON choose
          PERSISTENT RUN runProgram IN THIS-PROCEDURE.
      END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Close"
      TRIGGERS:
      ON choose
          PERSISTENT RUN endProc IN THIS-PROCEDURE.
      END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      SUBTYPE = "RULE" .
  CREATE MENU-ITEM htmpitem
      ASSIGN 
      PARENT = htmpmenu
      LABEL = "Log &Properties"
      TRIGGERS:
      ON CHOOSE
          PERSISTENT RUN showProperties IN THIS-PROCEDURE.
      END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN 
      PARENT = htmpmenu
      LABEL = "&Handler Info"
      TRIGGERS:
      ON choose
          PERSISTENT RUN showHandlerInfo IN THIS-PROCEDURE.
      END TRIGGERS.

  /* view menu */    
  CREATE SUB-MENU htmpmenu
      ASSIGN
      PARENT = hmainmenu
      LABEL = "&View".
  CREATE MENU-ITEM htmpitem
      ASSIGN
      PARENT = htmpmenu
      LABEL = "&Search"
      ACCELERATOR = "CTRL-F"
      TRIGGERS:
      ON choose
          PERSISTENT RUN startSearch IN THIS-PROCEDURE.
      END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN 
      PARENT = htmpmenu
      LABEL = "&Browse Columns..."
      TRIGGERS:
      ON choose
          PERSISTENT RUN selectBrowseColumns IN THIS-PROCEDURE.
      END TRIGGERS.
  CREATE MENU-ITEM htmpitem
      ASSIGN 
      PARENT = htmpmenu
      LABEL = "&Editor Columns..."
      TRIGGERS:
      ON choose
          PERSISTENT RUN selectEditorColumns IN THIS-PROCEDURE.
      END TRIGGERS.

  /* Utilities menu */
  CREATE SUB-MENU hutilmenu
      ASSIGN 
      PARENT = hmainmenu
      LABEL = "&Utilities".

  /* Queries Menu */
  CREATE SUB-MENU hqrymenu
      ASSIGN 
      PARENT = hmainmenu
      LABEL = "&Queries".

  /* help */
  CREATE SUB-MENU htmpmenu
      ASSIGN
      PARENT = hmainmenu
      LABEL = "&Help".
  CREATE MENU-ITEM htmpitem
      ASSIGN 
      PARENT = htmpmenu
      LABEL = "&Help"
      TRIGGERS:
      ON CHOOSE
          PERSISTENT RUN displayHelp IN THIS-PROCEDURE. 
      END TRIGGERS.

  hwin:MENUBAR = hmainmenu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE makeVisible hwin 
PROCEDURE makeVisible :
/*------------------------------------------------------------------------------
  Purpose:     Makes the Log Browse window visible or hidden
  Parameters: 
    lvisible - [IN] TRUE if window is to be made visible,
                    FALSE if window is to be hidden
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM lvisible AS LOG NO-UNDO.

    IF (lvisible) THEN
    DO:
        /* make window visible if it isn't */
        IF hwin:WINDOW-STATE = WINDOW-MINIMIZED THEN
            hwin:WINDOW-STATE = WINDOW-NORMAL.
        /* bring window to top */
        hwin:MOVE-TO-TOP().
        /* shift focus to this window */
        APPLY "entry" TO hbr.
    END.
    ELSE
    DO:
        /* hide window */
        hwin:WINDOW-STATE = WINDOW-MINIMIZED.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openViewer hwin 
PROCEDURE openViewer :
/*------------------------------------------------------------------------------
  Purpose:     Opens a new Log Browse window for this log file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN openViewer IN ghlogutils(INPUT cFileName,INPUT cWhere, INPUT THIS-PROCEDURE).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryReOpen hwin 
PROCEDURE queryReOpen :
/*------------------------------------------------------------------------------
  Purpose:     Re-opens the query on this log file's temp-table, using new
               log filter where criteria.
  Parameters:  
    cwhere - [IN] new where clause text for the log filter
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT PARAM cwhere AS CHAR NO-UNDO.
   DEFINE VARIABLE cqry AS CHARACTER  NO-UNDO.

   IF VALID-HANDLE(hqry) THEN
       hqry:QUERY-CLOSE().
   cqry = "preselect each " + hbuf:NAME + " no-lock where " + 
       (IF cwhere = "" OR cwhere = ? THEN "true" ELSE cwhere).
   hqry:QUERY-PREPARE(cqry).
   hqry:QUERY-OPEN.
   RUN showStatusLine.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeCols hwin 
PROCEDURE resizeCols :
/*------------------------------------------------------------------------------
  Purpose:     Resizes columns in this Log Browse window's browse to match 
               the column sizes of another Log Browse window's browse
  Parameters:  <none>
  Notes:       Experimental, currently under development
               Intention is to size a new Log Browse window the same as an 
               existing log browse window, e.g. when called from 
               File->Open New Browse.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.
  DEFINE VARIABLE icol AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hcol2 AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lold AS LOGICAL INIT FALSE   NO-UNDO.
  DEFINE VARIABLE holdbrs AS HANDLE     NO-UNDO.

  hcol = hbr:FIRST-COLUMN.
  IF valid-handle(holdbrs) THEN
      ASSIGN 
      lold = TRUE
      hcol2 = holdbrs:FIRST-COLUMN.
  DO WHILE valid-handle(hcol):
      IF lold THEN
          ASSIGN
          hcol:WIDTH-CHARS = hcol2:WIDTH-CHARS
          hcol2 = hcol2:NEXT-COLUMN.
      ELSE
          hcol:WIDTH-CHARS = 12.
      hcol = hcol:NEXT-COLUMN.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runDump hwin 
PROCEDURE runDump :
/*------------------------------------------------------------------------------
  Purpose:     Run the Log Dump window for this log file
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN logread/logdump.w(INPUT cWhere, INPUT htt, INPUT hbr).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runProgram hwin 
PROCEDURE runProgram :
/*------------------------------------------------------------------------------
  Purpose:     Runs a utility program, from the File->Run Utility menu
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cProgName AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cerr AS CHARACTER  NO-UNDO.
    
    RUN logread/runudlg.w(OUTPUT cProgName,?,OUTPUT lOK).

    IF NOT lOK THEN
        RETURN.

    IF lOK THEN
    DO:
        RUN VALUE(cProgName) (INPUT htt, INPUT hproc, INPUT ghlogutils) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
        DO:

          DO ictr = 1 TO ERROR-STATUS:NUM-MESSAGES:
              cerr = cerr + ERROR-STATUS:GET-MESSAGE(ictr) + CHR(10).
          END.
          MESSAGE "Error(s) running procedure" cProgName ":" SKIP
              cerr VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runQuery hwin 
PROCEDURE runQuery :
/*------------------------------------------------------------------------------
  Purpose:     Sets the current log filter to the new query, selected from the 
               Queries menu.
  Parameters:  
    cQryName - [IN] name of the query to run, from the list of queries provided
               by the handler.
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cQryName AS CHAR NO-UNDO.

  IF VALID-HANDLE(hproc) THEN
      RUN getQuery IN hproc(cQryName, OUTPUT cWhere).
  ELSE
      /* pseudo type */
      RUN getPseudoTypeQuery IN ghlogutils(INPUT SELF:LABEL,INPUT cFileName, OUTPUT cWhere).
  MESSAGE "Setting query to " cWhere VIEW-AS ALERT-BOX.
  RUN queryReOpen(cWhere).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runUtility hwin 
PROCEDURE runUtility :
/*------------------------------------------------------------------------------
  Purpose:     Runs the selected utility procedure from the Utilities menu
  Parameters:  
    cUtilName - [IN] Name of the utility procedure to run
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM cUtilName AS CHAR NO-UNDO.

  RUN VALUE("util_" + cUtilname) IN hproc(INPUT htt, THIS-PROCEDURE,ghlogutils).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE searchNext hwin 
PROCEDURE searchNext :
/*------------------------------------------------------------------------------
  Purpose:     Provides the Search->Next functionality, locating the next row
               in the browse that matches the search expression, within the
               set of records selected (and sorted) by the filter query.
  Parameters:  
    ctxt - [IN] Search query to use (4GL syntax)
    ldir - [IN] direction to search (TRUE is up)
  Notes:       If the current record does not match the search criteria, 
               uses a rudimentary binary search to select the next closest 
               record that matches the criteria.
               Search respects both the log filter query and the search query.
               It generates a second query, involving the criteria from both
               the log filter query and the search query (applying any BY phrase).
               Using a second query is initially costly when opening the query, 
               but should yield faster results when doing Next. Search query is 
               only re-opened when the search criteria text is changed. 
------------------------------------------------------------------------------*/
  DEF INPUT PARAM ctxt AS CHAR NO-UNDO.
  DEF INPUT PARAM ldir AS LOG NO-UNDO.

  DEFINE VARIABLE cwhr AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cby AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ipos AS INTEGER INIT 0   NO-UNDO.
  DEFINE VARIABLE irow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE isrchrow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rrow AS ROWID      NO-UNDO.
  DEFINE VARIABLE rsrchrow AS ROWID      NO-UNDO.
  DEFINE VARIABLE itmprow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ltmpok AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ihirow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ilorow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lfound AS LOGICAL INIT NO  NO-UNDO.
  DEFINE VARIABLE lfocus AS LOGICAL    NO-UNDO.


  /* set up the search query, if it doesn't exist */
  IF NOT VALID-HANDLE(hsrchqry) THEN
  DO:
      IF NOT VALID-HANDLE(hsrchbuf) THEN
          CREATE BUFFER hsrchbuf FOR TABLE htt:DEFAULT-BUFFER-HANDLE.
      CREATE QUERY hsrchqry.
      hsrchqry:SET-BUFFERS(hsrchbuf).
  END.

  /* if the search query text has changed, rebuild the query */
  IF ctxt <> csrchqry THEN
  DO:
      /* close hsrchqry if open */
      IF valid-handle(hsrchqry) THEN
          hsrchqry:QUERY-CLOSE().

      /* insert into filter query */

      /* find any "by" phrase in the query */
      IF cwhere BEGINS "by " THEN
          ipos = 1.
      ELSE 
          ipos = INDEX(cwhere, " by ").
      /* split filter into where and by phrases */
      IF ipos = 0 THEN
          ASSIGN 
          cwhr = cwhere
          cby = "".
      ELSE IF ipos = 1 THEN
          ASSIGN 
          cwhr = "true"
          cby = cwhere.
      ELSE
          ASSIGN 
              cwhr = SUBSTRING(cwhere,1,ipos)
              cby = SUBSTRING(cwhere,ipos + 1).
      /* add search criteria to where */
      cwhr = "( " + cwhr + " ) and ( " + ctxt + " ) " + cby.

      /* create query string */
      hsrchqry:QUERY-PREPARE("preselect each " + hsrchbuf:NAME + 
                             " no-lock where " + cwhr).

      /* open the query */
      hsrchqry:QUERY-OPEN().
      /* go to the first record */
      hsrchqry:GET-NEXT().

      csrchqry = ctxt.
  END.  /* if ctxt <> csrchtxt */

  /* turn off refreshable to stop flashing */
  hbr:REFRESHABLE = FALSE.

  /* find the current query row */
  /* due to something I don't understand...
   * if the current row is not selected (i.e. only has focus),
   * hqry:current-result-row and hbuf refer to the row at the 
   * top of the browse viewport.
   * if the current row is selected, then hqry:current-result-row and hbuf
   * refer to the current row
   */
  lfocus = hbr:FOCUSED-ROW-SELECTED.
  IF NOT lfocus THEN
      hbr:SELECT-FOCUSED-ROW().
  ASSIGN
      irow = hqry:CURRENT-RESULT-ROW
      rrow = hbuf:ROWID.
  IF NOT lfocus THEN
      hbr:DESELECT-FOCUSED-ROW().

  /* save the current search row */
  ASSIGN 
      isrchrow = hsrchqry:CURRENT-RESULT-ROW
      rsrchrow = hsrchbuf:ROWID.

  /* see if we can find the current row in the search buffer */
  ltmpok = hsrchqry:REPOSITION-TO-ROWID(rrow) NO-ERROR.
  IF ltmpok /* hsrchqry:REPOSITION-TO-ROWID(rrow) = TRUE */ THEN
  DO:
      /* get the rrow record */
      hsrchqry:GET-NEXT().

      IF ldir THEN
          hsrchqry:GET-PREV().
      ELSE
          hsrchqry:GET-NEXT().

      /* check hsrchbuf:rowid for ?, to see if we fell off the end */
      IF hsrchbuf:ROWID = ? THEN
      DO:
          MESSAGE "Search text not found. Restart search from"
              (IF ldir THEN "end?" ELSE "top?")
              VIEW-AS ALERT-BOX INFORMATION
              BUTTONS YES-NO
              TITLE "Not Found"
              UPDATE lWrap AS LOGICAL.
          IF lWrap THEN
          DO:
              /* wrap to end/top */
              IF ldir THEN
              DO:
                  /* wrap to end */
                  hsrchqry:GET-LAST().
              END.
              ELSE
              DO:
                  /* wrap to top */
                  hsrchqry:GET-FIRST().
              END.
          END.
          ELSE
          DO:
              /* put browse and result list back where they were? */
              hbr:REFRESHABLE = TRUE.
              APPLY 'entry':U TO hwin.
              RETURN.
          END.
      END.

      hbr:REFRESHABLE = TRUE.
      hqry:REPOSITION-TO-ROWID(hsrchbuf:ROWID) NO-ERROR.
      /* redraw the browse */
      hbr:REFRESH().
  END. /* if reposition-to-rowid(rrow) */
  ELSE
  DO:  /* if not reposition-to-rowid(rrow) */
      /* current hqry row not in search query. 
       * locate the rows in hsrchqry it fits between, if any */

      /* remove selection on focused row */
      IF lfocus THEN
          hbr:DESELECT-FOCUSED-ROW().

      /* get the first hsrchqry row */
      hsrchqry:GET-FIRST().
      /* find where hsrchbuf:rowid is in hqry */
      ltmpok = hqry:REPOSITION-TO-ROWID(hsrchbuf:ROWID) NO-ERROR.
      IF ltmpok THEN
      DO:
          hqry:GET-NEXT().
          /* find the row number */
          ilorow = hqry:CURRENT-RESULT-ROW.
      END.
      
      /* get the last hsrchqry row */
      hsrchqry:GET-LAST().
      ltmpok = hqry:REPOSITION-TO-ROWID(hsrchbuf:ROWID) NO-ERROR.
      IF ltmpok THEN
      DO:
          hqry:GET-NEXT().
          ihirow = hqry:CURRENT-RESULT-ROW.
      END.

      IF irow < ilorow AND NOT ldir THEN
      DO:
          /* if before first hsrchqry, and searching down, move to first hsrchqry */
          ASSIGN 
              irow = ilorow - 1.
              lfound = TRUE.
      END.
      ELSE IF irow > ihirow AND ldir THEN
      DO:
          /* if after last hsrchqry, and searching up, move to last hsrchqry */
          ASSIGN 
              irow = ihirow
              lfound = TRUE.
      END.
      ELSE IF (irow < ilorow) OR (irow > ihirow) THEN
      DO:
          /* off end of result list, ask to wrap */
          MESSAGE "Search text not found. Restart search from"
              (IF ldir THEN "end?" ELSE "top?")
              VIEW-AS ALERT-BOX INFORMATION
              BUTTONS YES-NO
              TITLE "Not Found"
              UPDATE lWrap1 AS LOGICAL.
          IF lWrap1 THEN
          DO:
              IF ldir THEN
                  ASSIGN 
                      irow = ihirow
                      lfound = TRUE.
              ELSE
                  ASSIGN 
                      irow = ilorow
                      lfound = TRUE.
          END.
          ELSE
          DO:
              /* user cancelled search, reset to where we were? */
              lfound = TRUE.
          END.
      END.
      
      IF lfound THEN
      DO:
          hbr:REFRESHABLE = TRUE.
          hqry:REPOSITION-TO-ROW(irow).
          hqry:GET-NEXT().
          hbr:REFRESH().
          /* RETURN. */
      END.
      ELSE
      DO:
          ASSIGN 
              ilorow = 1
              ihirow = hsrchqry:NUM-RESULTS.
          REPEAT:
              IF ihirow = ilorow + 1 THEN
                  LEAVE.
              itmprow = (ihirow + ilorow) / 2.
              /* find the itmprow-th row in hsrchqry */
              hsrchqry:REPOSITION-TO-ROW(itmprow) NO-ERROR.
              hsrchqry:GET-NEXT().
              /* find this row in hqry */
              hqry:REPOSITION-TO-ROWID(hsrchbuf:ROWID) NO-ERROR.
              IF irow < hqry:CURRENT-RESULT-ROW THEN 
                  ihirow = itmprow.
              ELSE
                  ilorow = itmprow.
          END.
          /* should only get here when we identify two records */
          hsrchqry:REPOSITION-TO-ROW(ihirow) NO-ERROR.
          IF ldir THEN
              hsrchqry:GET-PREV().
          ELSE
              hsrchqry:GET-NEXT().
          hbr:REFRESHABLE = TRUE.
          hqry:REPOSITION-TO-ROWID(hsrchbuf:ROWID) NO-ERROR.
          hqry:GET-NEXT().
          hbr:REFRESH().
      END.  /* if not lfound */
  END.  /* if not reposition-to-rowid(rrow) */

  /* apply focus to this window, so we see the current row cursor */
  APPLY 'entry':U TO hwin.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectBrowseColumns hwin 
PROCEDURE selectBrowseColumns :
/*------------------------------------------------------------------------------
  Purpose:     Allows user to select which columns are visible in the browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ccols AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE icnt AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lfirst AS LOGICAL INIT YES   NO-UNDO.
  
  /* create a CSV list of visible columns */
  DO icnt = 1 TO hbr:NUM-COLUMNS:
      hcol = hbr:GET-BROWSE-COLUMN(icnt).
      hfld = hcol:BUFFER-FIELD.
      IF hcol:VISIBLE THEN
          ASSIGN 
              ccols = ccols + (IF lfirst THEN "" ELSE ",") + hfld:NAME
              lfirst = NO.
  END.

  /* run column selection dialog */
  RUN logread/coldlg.w (INPUT hbuf,INPUT-OUTPUT ccols,"Visible Browse Columns").

  /* set column visibility based on the return from the dialog */
  DO icnt = 1 TO hbr:NUM-COLUMNS:
      hcol = hbr:GET-BROWSE-COLUMN(icnt).
      hfld = hcol:BUFFER-FIELD.
      ASSIGN hcol:VISIBLE = CAN-DO(ccols,hfld:NAME).
  END.

  /* set this as the default columns for the log type */
  RUN setHandlerAttribute IN ghlogutils(
      INPUT hproc,
      INPUT ?,
      INPUT "browsecols",
      INPUT ccols).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectEditorColumns hwin 
PROCEDURE selectEditorColumns :
/*------------------------------------------------------------------------------
  Purpose:     Allows user to select which columns are visible in the editor.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ccols AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE icnt AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lfirst AS LOGICAL INIT YES   NO-UNDO.
  
  /* ctxtcols is a list of visible editor columns */

  /* run column selection dialog */
  RUN logread/coldlg.w (INPUT hbuf,INPUT-OUTPUT ctxtcols,"Visible Editor Columns").

  /* re-display the editor based on the return value of ctxtcols */
  RUN showRowInfo.

  /* set this as the default columns for the log type */
  RUN setHandlerAttribute IN ghlogutils(
      INPUT hproc,
      INPUT ?,
      INPUT "editorcols",
      INPUT ctxtcols).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFilter hwin 
PROCEDURE setFilter :
/*------------------------------------------------------------------------------
  Purpose:     Displays the Log Filter dialog, to allow the user to change the
               selection and sort criteria for the browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
        
  RUN logread/logfilter.w (INPUT-OUTPUT cWhere, htt, hproc, cFileName, OUTPUT lOK).
  IF lOK THEN
      RUN queryReOpen(cWhere).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFilterAsLog hwin 
PROCEDURE setFilterAsLog :
/*------------------------------------------------------------------------------
  Purpose:     Creates a new log file temp-table, based on the subset of rows
               identified by the current log filter query. This is the option
               File->Filter As New Log
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE htt3 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hqry2 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hbuf2 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hbuf3 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE ictr AS INTEGER    INIT 0 NO-UNDO.
    DEFINE VARIABLE cNewName AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE chdlrname AS CHARACTER  INIT "Unknown" NO-UNDO.
    DEFINE VARIABLE cdesc AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lok AS LOGICAL    NO-UNDO.

    /* new file name */
    ASSIGN 
        cNewName = "FILT" + STRING(giseq,"9999")
        cDesc = cFileName + " where " + 
            (IF cwhere = "" THEN "true" ELSE cwhere).
    
    /* make sure entered log name is unique */
    DO WHILE TRUE:
        RUN logread\newlog.w (INPUT-OUTPUT cNewName,"New Log",OUTPUT lok).
        IF (lok <> TRUE) THEN
            RETURN.
        RUN getLogInfo IN ghlogutils(cNewName,?,OUTPUT hbuf3).
        IF VALID-HANDLE(hbuf3) THEN
        DO:
            MESSAGE "Log with name" cNewName "already exists." SKIP
                "Please choose a new name."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            hbuf3:BUFFER-RELEASE.
        END.
        ELSE
            LEAVE.
    END.

    /* increment the sequence */
    giseq = giseq + 1.

    /* duplicate the table definition */
    CREATE TEMP-TABLE htt3 IN WIDGET-POOL "logpool".
    htt3:CREATE-LIKE(hbuf).
    htt3:TEMP-TABLE-PREPARE(hbuf:NAME).

    /* populate it with the current query */
    hbuf3 = htt3:DEFAULT-BUFFER-HANDLE.
    CREATE BUFFER hbuf2 FOR TABLE hbuf.

    CREATE QUERY hqry2.
    hqry2:SET-BUFFERS(hbuf2).
    hqry2:QUERY-PREPARE("for each " + hbuf2:NAME + " no-lock where " + 
       (IF cwhere = "" THEN "true" ELSE cwhere)).
    hqry2:QUERY-OPEN.

    REPEAT:
        hqry2:GET-NEXT().
        IF hqry2:QUERY-OFF-END THEN LEAVE.

        hbuf3:BUFFER-CREATE().
        hbuf3:BUFFER-COPY(hbuf2).
        ictr = ictr + 1.
    END.
    DELETE OBJECT hqry2.
    /* add this as a log, but we need a handler name */
    IF can-do(hproc:INTERNAL-ENTRIES,"getLogType") THEN
        RUN getLogType IN hproc(OUTPUT chdlrname).
    RUN addTT IN ghlogutils(INPUT cNewName,chdlrname,INPUT /* TABLE-HANDLE */ htt3 ,ictr,cdesc).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showColumn hwin 
PROCEDURE showColumn :
/*------------------------------------------------------------------------------
  Purpose:     Shows or hides a names column in the browse
  Parameters:  
    hmenuitem - [IN] column's menuitem from the View->Columns submenu
    ccolname  - [IN] name of the column
    lchecked  - [IN] whether the column is visible or not
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM hmenuitem AS HANDLE NO-UNDO.
  DEF INPUT PARAM ccolname AS CHAR NO-UNDO.
  DEF INPUT PARAM lchecked AS LOG NO-UNDO.

  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hcol AS HANDLE     NO-UNDO.

  /* find the column in hbr */
  hcol = hbr:FIRST-COLUMN.
  IF NOT valid-handle(hcol) THEN 
  DO:
      MESSAGE "failed to find first menuitem " ccolname VIEW-AS ALERT-BOX.
      RETURN.
  END.

  /* iterate through the browse columns, looking for this column */
  DO WHILE (valid-handle(hcol)):
      IF hcol:NAME = ccolname THEN LEAVE.
      hcol = hcol:NEXT-COLUMN.
  END.

  /* found the column? */
  IF (NOT valid-handle(hcol)) THEN 
  DO:
      MESSAGE "failed to find column '" + ccolname + "'" VIEW-AS ALERT-BOX.
      RETURN.
  END.

  IF lchecked THEN
  DO:
      /* make the column visible */
      ASSIGN 
          hcol:VISIBLE = TRUE.
  END.  /* if lchecked */
  ELSE
  DO:
      /* hide column */
      ASSIGN 
          hcol:VISIBLE = FALSE. 
  END.  /* if not lchecked */

  /* re-open the query */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showHandlerInfo hwin 
PROCEDURE showHandlerInfo :
/*------------------------------------------------------------------------------
  Purpose:     Displays information about the log type handler used in this 
               Log Browse window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN showHandlerInfo IN ghlogutils(INPUT clogtype).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showLogInfo hwin 
PROCEDURE showLogInfo :
/*------------------------------------------------------------------------------
  Purpose:     Displays a dialog showing information about the log file and
               its associated handler.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE ctmp AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE crdrinfo AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cloginfo AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hibuf AS HANDLE     NO-UNDO.

    crdrinfo = "Handler Info:~n  Reader: " + hproc:FILE-NAME.
    RUN getReaderInfo IN ghlogutils(?,hproc,OUTPUT hibuf).
    IF VALID-HANDLE(hibuf) THEN
    DO:
        ASSIGN ctmp = hibuf:BUFFER-FIELD("logtype"):BUFFER-VALUE NO-ERROR.
        crdrinfo = crdrinfo + "~n  Log Type: " + 
            (IF ctmp = ? THEN "" ELSE ctmp).
        ASSIGN ctmp = hibuf:BUFFER-FIELD("typename"):BUFFER-VALUE NO-ERROR.
        crdrinfo = crdrinfo + "~n  Type Name: " + ctmp.
            (IF ctmp = ? THEN "" ELSE ctmp).
    END.
    
    RUN getLogInfo IN ghlogutils(cFileName,?,OUTPUT hibuf).

    cloginfo = "Log Info:~n  Filename: " + cFileName + 
               "~n  Lines: " + STRING(irows).

    IF VALID-HANDLE(hibuf) THEN
    DO:
        ASSIGN ctmp = hibuf:BUFFER-FIELD("cdesc"):BUFFER-VALUE NO-ERROR.
        cloginfo = cLogInfo + "~n  Description: " + 
            (IF ctmp = ? THEN "" ELSE ctmp).
    END.

    MESSAGE cloginfo SKIP(1)
        crdrinfo SKIP(1)
        "Current Filter: " cWhere SKIP
        VIEW-AS ALERT-BOX.
        .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showProperties hwin 
PROCEDURE showProperties :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN showLogProperties IN ghlogutils(INPUT cFileName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showRowInfo hwin 
PROCEDURE showRowInfo :
/*------------------------------------------------------------------------------
  Purpose:     Displays the currently selected row in the editor htxt
  Parameters:  <none>
  Notes:       Only displays rows listed in the ctxtcols list. 
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE irow AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ctxt AS CHARACTER  NO-UNDO.

  /* only do first selected row */
  IF hbr:NUM-SELECTED-ROWS > 0 THEN
  DO:
      hbr:FETCH-SELECTED-ROW(1).
      DO ictr = 1 TO hbuf:NUM-FIELDS:
          hfld = hbuf:BUFFER-FIELD(ictr).
          IF (CAN-DO(ctxtcols,hfld:NAME)) THEN
          ctxt = ctxt + hfld:NAME + ": " + 
              (IF hfld:DATA-TYPE = "CHARACTER" then
               TRIM(hfld:BUFFER-VALUE) ELSE
               TRIM (hfld:STRING-VALUE))
               + CHR(10).
      END.
  END.
  ELSE
      ctxt = "".

  htxt:SCREEN-VALUE = ctxt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showStatusLine hwin 
PROCEDURE showStatusLine :
/*------------------------------------------------------------------------------
  Purpose:     Displays the status line in the window, containing the 
               number of rows in the temp-table, and the current log filter
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cmsg AS CHARACTER  NO-UNDO.

    cmsg = "Total Rows: " + STRING(irows).
    IF cWhere <> "true" THEN
        cmsg = cmsg + "    Filter: " + cWhere.
    STATUS DEFAULT cmsg IN WINDOW hwin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE splitterEndMove hwin 
PROCEDURE splitterEndMove :
/*------------------------------------------------------------------------------
  Purpose:     Resizes the browse and editor based on the amount the splitter
               hbut moved.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE idiffy AS INTEGER    NO-UNDO.

  ASSIGN 
      idiffy = hbut:Y - isplity.

  /* make sure the button does not make the size of the browse
   * smaller than its minimum height. If so, set the button to 
   * only move to the browse's min height.
   * NOTE: idiffy is -ve if moving up */
  IF (hbr:HEIGHT-PIXELS + idiffy < ibrminh) THEN
      ASSIGN 
          hbut:Y = ibrminh
          idiffy = hbut:Y - isplity
          .

  /* if moving splitter down, make sure we don't reduce the size of 
   * the editor below editor's min height */
  IF (htxt:HEIGHT-PIXELS - idiffy < itxtminh) THEN
      ASSIGN
        hbut:Y = hbut:Y - (idiffy - (htxt:HEIGHT-PIXELS - itxtminh))
        idiffy = hbut:Y - isplity.

  IF idiffy > 0 THEN
      ASSIGN 
          htxt:HEIGHT-PIXELS = htxt:HEIGHT-PIXELS - idiffy
          htxt:Y = htxt:Y + idiffy
          hbr:HEIGHT-PIXELS = hbr:HEIGHT-PIXELS + idiffy
          .
  ELSE
      ASSIGN 
          htxt:Y = htxt:Y + idiffy
          htxt:HEIGHT-PIXELS = htxt:HEIGHT-PIXELS - idiffy
          hbr:HEIGHT-PIXELS = hbr:HEIGHT-PIXELS + idiffy
          .
  /* set the new min-height of the window 
   * If moving the splitter down, this makes htxt smaller, 
   * so the min size of the window gets smaller by this amount
   * (you can make the window smaller without crushing the browse).
   * If moving the splitter up, htxt is bigger, so the min size of
   * the window is larger. */
  ASSIGN 
      hwin:MIN-HEIGHT-PIXELS = hwin:MIN-HEIGHT-PIXELS - idiffy.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE splitterStartMove hwin 
PROCEDURE splitterStartMove :
/*------------------------------------------------------------------------------
  Purpose:     Records the X and Y position of the splitter button hbut.
  Parameters:  <none>
  Notes:       Trigger procedure for START-MOVE of the splitter button hbut.
------------------------------------------------------------------------------*/
  ASSIGN 
      isplitx = hbut:X
      isplity = hbut:Y.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch hwin 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     Brings up the Search dialog
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(hsrchwin) THEN
        RUN logread/srchdlg.w PERSISTENT SET hsrchwin(INPUT THIS-PROCEDURE, INPUT htt).
    ELSE
        RUN showWindow IN hsrchwin (TRUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

