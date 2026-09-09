&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: logread/logopen.w

  Description: The dialog for selecting log files to open, and 
               for displaying opened log fiel properties

  Parameters:
      cLogFile     - [IN-OUT] name of log file
      coLogType    - [IN-OUT] name of log type
      iDateFmtix   - [IN-OUT] date format index in date format array (see logread/logdate.i)
      doTimeAdj    - [IN-OUT] number of milliseconds to adjust time by
      coSrcLang    - [IN-OUT] language to use for interpreting dates with MMM,
                     if not English (typically from ublog file formats)
      coCodePage   - [IN-OUT] codepage to use when reading log file
      coSrgMsgs    - [IN-OUT] path of source promsgs file to use when translating 
                     log messages
      coTrgMsgs    - [IN-OUT] path of target promsgs file to use when translating 
                     log messages
      doStartDate  - [IN-OUT] date to start reading log messages
      doStartTime  - [IN-OUT] time to start reading log messages
      doEndDate    - [IN-OUT] date to stop reading log messages
      doEndTime    - [IN-OUT] time to stop reading log messages      
      lOpen        - [IN] Whether the dialog is running in open mode (to select
                     a log file to open), or in view mode (to display the
                     properties of a already opened log file).
      lpOpenBrowse - [OUT] indicate whether a Log Browse window should be opened
                     once the log file is loaded.

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* ttlogtype definition */
{logread/logtype.i " " }

/* DEF INPUT PARAM TABLE FOR ttlogtype. */
DEF INPUT-OUTPUT PARAM cLogFile AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM coLogType AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM iDateFmtix AS INT NO-UNDO.
DEF INPUT-OUTPUT PARAM doTimeAdj AS DEC NO-UNDO.
DEF INPUT-OUTPUT PARAM coSrcLang AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM coCodePage AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM coSrcMsgs AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM coTrgMsgs AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM doStartDate AS DATE NO-UNDO.
DEF INPUT-OUTPUT PARAM doStartTime AS DEC NO-UNDO.
DEF INPUT-OUTPUT PARAM doEndDate AS DATE NO-UNDO.
DEF INPUT-OUTPUT PARAM doEndtime AS DEC NO-UNDO.
DEF INPUT PARAM lOpen AS LOG NO-UNDO.
/* DEF INPUT PARAM hwin AS HANDLE NO-UNDO. */
DEF OUTPUT PARAM loOpenBrowse AS LOG NO-UNDO.

/* Global Variables */
{logread/logglob.i " " }

/* help context ids */
{logread/loghelp.i}

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lAdvanced AS LOGICAL INIT ?   NO-UNDO.
DEFINE VARIABLE dWinHeight AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dButRow AS DECIMAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 cFileName bLogBrowse cLogType ~
cDateFormat cDateLang 
&Scoped-Define DISPLAYED-OBJECTS cFileName cLogType cDateFormat cDateLang 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBaseName Dialog-Frame 
FUNCTION getBaseName RETURNS CHARACTER
  ( INPUT cLogFile AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bLogBrowse 
     IMAGE-UP FILE "logread/image/open.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE VARIABLE cDateFormat AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Date Format" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "mmm dd yyyy","1",
                     "mmm dd yyyy","2",
                     "yyyy/mm/dd","3",
                     "yy/mm/dd","4"
     DROP-DOWN-LIST
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE cDateLang AS CHARACTER FORMAT "X(256)":U 
     LABEL "Language" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "English","eng"
     DROP-DOWN-LIST
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE cLogType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Log Type" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "","barf"
     DROP-DOWN-LIST
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE cFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Log File Name" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81 BY 2.86.

DEFINE BUTTON bSrcBrowse 
     IMAGE-UP FILE "logread/image/open.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON bTrgBrowse 
     IMAGE-UP FILE "logread/image/open.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE VARIABLE cCodepage AS CHARACTER FORMAT "X(256)":U 
     LABEL "Code Page" 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE cEndTime AS CHARACTER FORMAT "99:99:99":U INITIAL "000000" 
     LABEL "Time" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cSrcMsgs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Source Promsgs" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE cStartTime AS CHARACTER FORMAT "99:99:99":U INITIAL "000000" 
     LABEL "Time" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cTrgMsgs AS CHARACTER FORMAT "X(256)":U 
     LABEL "Target Promsgs" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE dEndDate AS DATE FORMAT "99/99/9999":U 
     LABEL "End Date" 
     VIEW-AS FILL-IN 
     SIZE 17.4 BY 1 NO-UNDO.

DEFINE VARIABLE dStartDate AS DATE FORMAT "99/99/9999":U 
     LABEL "Start Date" 
     VIEW-AS FILL-IN 
     SIZE 17.4 BY 1 NO-UNDO.

DEFINE VARIABLE dTimeAdj AS CHARACTER FORMAT "99:99:99.999":U INITIAL "000000000" 
     LABEL "Time Adjust" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE lTimeDir AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "+", yes,
"-", no
     SIZE 12 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81 BY 2.38.

DEFINE VARIABLE tOpenBrowse AS LOGICAL INITIAL yes 
     LABEL "Open Browse Window" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .81 NO-UNDO.

DEFINE BUTTON bAdvanced 
     LABEL "Advanced" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bPreview 
     LABEL "Preview" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cFileName AT ROW 1.24 COL 18 COLON-ALIGNED
     bLogBrowse AT ROW 1.24 COL 77
     cLogType AT ROW 2.43 COL 18 COLON-ALIGNED
     cDateFormat AT ROW 3.91 COL 18 COLON-ALIGNED
     cDateLang AT ROW 5.1 COL 18 COLON-ALIGNED
     RECT-1 AT ROW 3.62 COL 1
     SPACE(0.59) SKIP(13.84)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Open Log File".

DEFINE FRAME fAdvanced
     dTimeAdj AT ROW 1.24 COL 18 COLON-ALIGNED
     lTimeDir AT ROW 2.43 COL 20 NO-LABEL
     cCodepage AT ROW 3.62 COL 18 COLON-ALIGNED
     cSrcMsgs AT ROW 4.81 COL 18 COLON-ALIGNED
     bSrcBrowse AT ROW 4.81 COL 77
     cTrgMsgs AT ROW 6 COL 18 COLON-ALIGNED
     bTrgBrowse AT ROW 6 COL 77
     dStartDate AT ROW 8.14 COL 17.6 COLON-ALIGNED
     cStartTime AT ROW 8.14 COL 43 COLON-ALIGNED
     dEndDate AT ROW 9.33 COL 17.6 COLON-ALIGNED
     cEndTime AT ROW 9.33 COL 43 COLON-ALIGNED
     tOpenBrowse AT ROW 11 COL 20.6
     "(HH:MM:SS.mmm)" VIEW-AS TEXT
          SIZE 19 BY .62 AT ROW 1.48 COL 40
     "Direction:" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 2.43 COL 10.4
     "(24 Hr)" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 9.57 COL 60
     "(24 Hr)" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 8.38 COL 60
     "Date Range Filter:" VIEW-AS TEXT
          SIZE 18 BY .62 AT ROW 7.43 COL 2
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 7.05
         SIZE 81.6 BY 11.52.

DEFINE FRAME fButtons
     Btn_OK AT ROW 1.24 COL 2
     bAdvanced AT ROW 1.24 COL 18
     bPreview AT ROW 1.24 COL 34
     Btn_Help AT ROW 1.24 COL 50.2
     Btn_Cancel AT ROW 1.24 COL 66.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 18.67
         SIZE 81.6 BY 1.67.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME fAdvanced:FRAME = FRAME Dialog-Frame:HANDLE
       FRAME fButtons:FRAME = FRAME Dialog-Frame:HANDLE.

/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME fAdvanced
                                                                        */
ASSIGN 
       cEndTime:READ-ONLY IN FRAME fAdvanced        = TRUE.

ASSIGN 
       cStartTime:READ-ONLY IN FRAME fAdvanced        = TRUE.

/* SETTINGS FOR FRAME fButtons
                                                                        */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fAdvanced
/* Query rebuild information for FRAME fAdvanced
     _Query            is NOT OPENED
*/  /* FRAME fAdvanced */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fButtons
/* Query rebuild information for FRAME fButtons
     _Query            is NOT OPENED
*/  /* FRAME fButtons */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Open Log File */
DO:
    DEFINE VARIABLE lOK AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE cerrtxt AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dtmpadjtime AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dtmpstarttime AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dtmpendtime AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE ccp AS CHARACTER  NO-UNDO.

    DO WITH FRAME Dialog-Frame:
        ASSIGN 
            cFileName cLogType cDateFormat cDateLang .
    END.
    IF ladvanced THEN
    DO WITH FRAME fAdvanced:
        ASSIGN dTimeAdj lTimeDir cCodepage cSrcMsgs cTrgMsgs
            dStartDate cStartTime dEndDate 
            cEndTime tOpenBrowse. 
    END.

    /* PERFORM VALIDATION */
    /* must specify filename */
    IF lopen AND cFileName = "" THEN
    DO:
        MESSAGE "Log File Name must be entered" VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO cFilename IN FRAME dialog-frame.
        RETURN NO-APPLY.
    END.
    /* must specify log type */
    IF lopen AND cLogType = "" THEN
    DO:
        MESSAGE "Log Type must be selected" VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO clogtype IN FRAME dialog-frame.
        RETURN NO-APPLY.
    END.
    /* must specify date format */
    IF lOpen AND cDateFormat = "0" THEN
    DO:
        MESSAGE "Date Format must be selected" VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO cDateFormat IN FRAME dialog-frame.
        RETURN NO-APPLY.
    END.
    /* only check the rest if fadvanced is visible */
    IF ladvanced THEN
    DO:
        /* time adjust value must be valid */
        IF dtimeadj <> "000000000" THEN
        DO:
            RUN validateTimeString IN ghlogutils(INPUT dtimeadj, OUTPUT dtmpadjtime,OUTPUT cerrtxt).
            IF cerrtxt <> "" THEN
            DO:
                MESSAGE cerrtxt VIEW-AS ALERT-BOX ERROR.
                APPLY 'entry':U TO dTimeAdj IN FRAME fAdvanced.
                RETURN NO-APPLY.
            END.
        END.

        /* This is currently not spec'd as a validation 
        /* check if codepage conversion available */
        IF ccodepage <> "" THEN
        DO:
            RUN checkCPConversion IN ghlogutils(INPUT ccodepage,OUTPUT ccp).
            IF ccp <> ccodepage THEN
            DO:
                MESSAGE "No conversion from" ccodepage "to" SESSION:CHARSET VIEW-AS ALERT-BOX ERROR.
                APPLY 'entry':U TO ccodepage IN FRAME fAdvanced.
                RETURN NO-APPLY.
            END.
        END.
        */

        /* csrcmsgs must be blank or a valid promsgs file */
        IF lopen AND csrcmsgs <> "" THEN
        DO:
            RUN checkPromsgsFile IN ghlogutils(INPUT csrcmsgs,OUTPUT lOK).
            IF NOT lOK THEN
            DO:
                MESSAGE "File " + csrcmsgs + " not a valid promsgs file" VIEW-AS ALERT-BOX ERROR.
                APPLY 'entry':U TO csrcmsgs IN FRAME fAdvanced.
                RETURN NO-APPLY.
            END.
        END.
        /* ctrgmsgs must be blank or a valid promsgs file */
        IF lopen AND ctrgmsgs <> "" THEN
        DO:
            RUN checkPromsgsFile IN ghlogutils(INPUT ctrgmsgs,OUTPUT lOK).
            IF NOT lOK THEN
            DO:
                MESSAGE "File " + ctrgmsgs + " not a valid promsgs file" VIEW-AS ALERT-BOX ERROR.
                APPLY 'entry':U TO ctrgmsgs IN FRAME fAdvanced.
                RETURN NO-APPLY.
            END.
        END.
        /* start date must be valid */
        /* start time must be a valid time */
        IF lopen AND cstarttime <> "000000" THEN
        DO:
            RUN validateTimeString IN ghlogutils(INPUT cstarttime, OUTPUT dtmpstarttime,OUTPUT cerrtxt).
            IF cerrtxt <> "" THEN
            DO:
                MESSAGE cerrtxt VIEW-AS ALERT-BOX ERROR.
                APPLY 'entry':U TO cStartTime IN FRAME fAdvanced.
                RETURN NO-APPLY.
            END.
        END.
        /* end date must be valid */
        /* end time must be a valid time */
        IF lopen AND cendtime <> "000000" THEN
        DO:
            RUN validateTimeString IN ghlogutils(INPUT cendtime, OUTPUT dtmpendtime,OUTPUT cerrtxt).
            IF cerrtxt <> "" THEN
            DO:
                MESSAGE cerrtxt VIEW-AS ALERT-BOX ERROR.
                APPLY 'entry':U TO cEndTime IN FRAME fAdvanced.
                RETURN NO-APPLY.
            END.
        END.
    END.  /* if ladvanced */
    /* END VALIDATION */
  IF (lOpen) THEN
  DO:
      ASSIGN 
          cLogFile = cFileName
          coLogType = cLogType
          iDateFmtix = INT(cDateFormat)
          coSrcLang = cDateLang
          loOpenBrowse = TRUE.  /* default to true, to open the log window */
      IF ladvanced THEN
      DO:
          ASSIGN
          doTimeAdj = dtmpadjtime * (IF lTimeDir THEN 1 ELSE -1)
          coCodePage = cCodePage
          coSrcMsgs = (IF cSrcMsgs <> "" THEN cSrcMsgs 
                       ELSE (IF cTrgMsgs <> "" THEN SEARCH(PROMSGS) ELSE ""))
          coTrgMsgs = (IF cTrgMsgs <> "" THEN cTrgMsgs 
                       ELSE (IF cSrcMsgs <> "" THEN SEARCH(PROMSGS) ELSE ""))
          loOpenBrowse = tOpenBrowse
          doStartDate = dStartDate
          doStartTime = dtmpStartTime
          doEndDate = dEndDate
          doEndTime = dtmpEndTime
          .
      END.
  END.
  ELSE
  DO:
      IF ladvanced THEN
      ASSIGN doTimeAdj = dtmpadjtime * (IF lTimeDir THEN 1 ELSE -1).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Open Log File */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fAdvanced
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fAdvanced Dialog-Frame
ON GO OF FRAME fAdvanced
DO:
  APPLY 'gi':U TO FRAME dialog-frame.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fButtons
&Scoped-define SELF-NAME bAdvanced
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bAdvanced Dialog-Frame
ON CHOOSE OF bAdvanced IN FRAME fButtons /* Advanced */
DO:
  RUN showAdvancedFrame(NOT lAdvanced). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define SELF-NAME bLogBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bLogBrowse Dialog-Frame
ON CHOOSE OF bLogBrowse IN FRAME Dialog-Frame
DO:
    DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
  SYSTEM-DIALOG GET-FILE cFile
      FILTERS "Log Files (*.log,*.lg)" "*.log,*.lg",
              "All Files (*.*)" "*.*"
      MUST-EXIST
      TITLE "Log File Browse"
      UPDATE lOK.
  IF lOK THEN
  DO:
      ASSIGN 
      cFileName = cFile
      cFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFile.
      RUN guessType.
      bPreview:SENSITIVE IN FRAME fButtons = (cFileName <> "").
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fButtons
&Scoped-define SELF-NAME bPreview
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bPreview Dialog-Frame
ON CHOOSE OF bPreview IN FRAME fButtons /* Preview */
DO :
    DEFINE VARIABLE ctext AS CHARACTER  INIT "" NO-UNDO.
    DEFINE VARIABLE irows AS INTEGER    INIT 0 NO-UNDO.
    DEFINE VARIABLE ichars AS INTEGER   INIT 0 NO-UNDO.
    DEFINE VARIABLE cline AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cfile AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iwidth AS INTEGER   NO-UNDO.
    DEFINE VARIABLE imaxwidth AS INTEGER INIT 0 NO-UNDO.
    DEFINE VARIABLE cincodepage AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE ccp AS CHARACTER  NO-UNDO.

    cfile = cfilename:SCREEN-VALUE IN FRAME Dialog-Frame.
    ccp = ccodepage:SCREEN-VALUE IN FRAME fAdvanced.
    IF ccp <> "" THEN
    DO:
        RUN checkCPConversion IN ghlogutils(INPUT ccp,OUTPUT cincodepage).
        /* Currently spec'd as not giving a message
        IF cincodepage <> ccp THEN
        DO:
            MESSAGE "No conversion from" ccp "to" SESSION:CHARSET VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
            cincodepage = SESSION:STREAM.
        END.
        */
    END.
    ELSE
        cincodepage = SESSION:STREAM.
    INPUT FROM VALUE(cfile) CONVERT SOURCE cincodepage NO-ECHO.
    REPEAT:
        IMPORT UNFORMATTED cline.
        ASSIGN 
            ctext = ctext + cline + CHR(10)
            irows = irows + 1
            iwidth = LENGTH(cline) 
            imaxwidth = (IF iwidth > imaxwidth THEN iwidth ELSE imaxwidth)
            ichars = ichars + iwidth.
        IF irows >= 50 OR ichars >= 10240 THEN
            LEAVE.
    END.
    INPUT CLOSE.
    RUN logread/txteddlg.w (INPUT ctext,10,imaxwidth,INPUT "Log File Preview - " + cfile).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fAdvanced
&Scoped-define SELF-NAME bSrcBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bSrcBrowse Dialog-Frame
ON CHOOSE OF bSrcBrowse IN FRAME fAdvanced
DO:
    DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
  SYSTEM-DIALOG GET-FILE cFile
      MUST-EXIST
      TITLE "Source Promsgs Browse"
      UPDATE lOK.
  IF lOK THEN
  DO:
      ASSIGN 
      cSrcMsgs = cFile
      cSrcMsgs:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFile.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fButtons
&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME fButtons /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
    IF (lopen) THEN
        {&LOGREADHELP} {&Open_Log_File_dialog_box} .
    ELSE
        {&LOGREADHELP} {&Log_Properties_dialog_box} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME fButtons /* OK */
DO:
  APPLY 'go':U TO FRAME dialog-frame.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fAdvanced
&Scoped-define SELF-NAME bTrgBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bTrgBrowse Dialog-Frame
ON CHOOSE OF bTrgBrowse IN FRAME fAdvanced
DO:
    DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
  SYSTEM-DIALOG GET-FILE cFile
      MUST-EXIST
      TITLE "Target Promsgs Browse"
      UPDATE lOK.
  IF lOK THEN
  DO:
      ASSIGN 
      cTrgMsgs = cFile
      cTrgMsgs:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFile.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define SELF-NAME cFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cFileName Dialog-Frame
ON LEAVE OF cFileName IN FRAME Dialog-Frame /* Log File Name */
DO:
    ASSIGN cFileName.
    
    IF cFileName <> "" THEN
    DO:
        RUN guessType.
        ASSIGN bPreview:SENSITIVE IN FRAME fButtons = TRUE.
    END.
    ELSE
        ASSIGN bPreview:SENSITIVE IN FRAME fButtons = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cLogType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cLogType Dialog-Frame
ON VALUE-CHANGED OF cLogType IN FRAME Dialog-Frame /* Log Type */
DO:
    DEFINE VARIABLE ifmtix AS INTEGER    NO-UNDO.

    FIND FIRST ttlogtype NO-LOCK WHERE
        ttlogtype.logtype = clogtype:SCREEN-VALUE NO-ERROR.
    IF AVAILABLE ttlogtype AND
        valid-handle(ttlogtype.hproc) AND 
        CAN-DO(ttlogtype.hproc:INTERNAL-ENTRIES,"getDateFormatix") THEN
    DO:
        RUN getDateFormatix IN ttlogtype.hproc(OUTPUT ifmtix).
        cDateFormat:SCREEN-VALUE = STRING(ifmtix).
    END.
    ELSE
        cDateFormat:SCREEN-VALUE = "0".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fAdvanced
&Scoped-define SELF-NAME dEndDate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dEndDate Dialog-Frame
ON LEAVE OF dEndDate IN FRAME fAdvanced /* End Date */
DO:
    ASSIGN dEndDate.
    IF dEndDate <> ? THEN
    DO:
        cEndTime:READ-ONLY = FALSE.  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dStartDate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dStartDate Dialog-Frame
ON LEAVE OF dStartDate IN FRAME fAdvanced /* Start Date */
DO:
    ASSIGN dStartDate.
    IF dStartDate <> ? THEN
    DO:
        cStartTime:READ-ONLY = FALSE.  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* populate the values of the combo boxes */
RUN populateComboValues.
RUN showPropertyValues.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enableUI.
  WAIT-FOR GO OF FRAME Dialog-Frame.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
  HIDE FRAME fAdvanced.
  HIDE FRAME fButtons.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableAdvancedFrame Dialog-Frame 
PROCEDURE enableAdvancedFrame :
/*------------------------------------------------------------------------------
  Purpose:     Displays and enables fields in the advanced frame, depending on
               whether we are in open mode or not.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  IF (lOpen) THEN
  DO:
      DISPLAY dTimeAdj lTimeDir cSrcMsgs cTrgMsgs cCodePage
              dStartDate cStartTime dEndDate cEndTime tOpenBrowse 
          WITH FRAME fAdvanced.
      ENABLE dTimeAdj lTimeDir bSrcBrowse cSrcMsgs bTrgBrowse cTrgMsgs cCodePage
             dStartDate cStartTime dEndDate cEndTime tOpenBrowse 
      WITH FRAME fAdvanced.
  END.
  ELSE
  DO:
      DISPLAY dTimeAdj lTimeDir ccodepage cSrcMsgs cTrgMsgs 
          dStartDate cStartTime dEndDate cEndTime 
          WITH FRAME fAdvanced.
      DO WITH FRAME fAdvanced:
          ASSIGN
              cCodepage:READ-ONLY = TRUE
              cSrcMsgs:READ-ONLY = TRUE
              cTrgMsgs:READ-ONLY = TRUE
              dStartDate:READ-ONLY = TRUE
              cStartTime:READ-ONLY = TRUE
              dEndDate:READ-ONLY = TRUE
              cEndTime:READ-ONLY = TRUE.
      END.
      DISABLE bSrcBrowse bTrgBrowse
          WITH FRAME fAdvanced.
      ENABLE dTimeAdj lTimeDir cCodePage cSrcMsgs cTrgMsgs
          dStartDate cStartTime dEndDate cEndTime
          WITH FRAME fAdvanced.
      DO WITH FRAME fAdvanced:
          ASSIGN 
              bSrcBrowse:VISIBLE = FALSE
              bTrgBrowse:VISIBLE = FALSE
              tOpenBrowse:VISIBLE = FALSE.
      END.
      DO WITH FRAME fbuttons:
          ASSIGN
              bAdvanced:VISIBLE = FALSE
              bPreview:VISIBLE = FALSE.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableBasicFrame Dialog-Frame 
PROCEDURE enableBasicFrame :
/*------------------------------------------------------------------------------
  Purpose:     Displays and enables fields in the basic frame, depending on
               whether we are in open mode or not.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableUI Dialog-Frame 
PROCEDURE enableUI :
/*------------------------------------------------------------------------------
  Purpose:     Override for the enable_UI procedure, so we can have more direct 
               control over whether to display the advanced frame or not, and 
               whether or not to enable the fields, based on whether we are in 
               open mode or not
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN 
      dWinHeight = FRAME Dialog-Frame:HEIGHT
      dButRow = FRAME fButtons:ROW.
  /* initially hide the advanced frame */
  RUN showAdvancedFrame(FALSE).

  IF (lOpen) THEN
  DO:
    DISPLAY cFileName cLogType cDateFormat cDateLang 
      WITH FRAME Dialog-Frame.
    ENABLE bLogBrowse cFileName cLogType cDateFormat cDateLang 
      WITH FRAME Dialog-Frame.
    FRAME Dialog-Frame:TITLE = "Open Log File".
  END.
  ELSE
  DO:
      DISPLAY cFileName cLogType cDateFormat cDateLang
        WITH FRAME Dialog-Frame.
      DISABLE bLogBrowse /* cFileName */ cLogType cDateFormat cDateLang
        WITH FRAME Dialog-Frame.
      DO WITH FRAME dialog-frame:
          ASSIGN 
              cFileName:READ-ONLY = TRUE
              /* cLogType:READ-ONLY = TRUE
              cDateFormat:READ-ONLY = TRUE
              cDateLang:READ-ONLY = TRUE */ .
      END.
      bLogBrowse:VISIBLE IN FRAME Dialog-Frame = FALSE.
      FRAME Dialog-Frame:TITLE = "Log Properties".
  END.
  VIEW FRAME Dialog-Frame.

  IF (lAdvanced) THEN
  DO:
    IF lOpen THEN
    DO:
        DISPLAY dTimeAdj lTimeDir cSrcMsgs cTrgMsgs cCodepage
              dStartDate cStartTime dEndDate cEndTime tOpenBrowse 
          WITH FRAME fAdvanced.
        ENABLE dTimeAdj lTimeDir bSrcBrowse cSrcMsgs bTrgBrowse cTrgMsgs 
               cCodePage dStartDate cStartTime dEndDate cEndTime tOpenBrowse 
            WITH FRAME fAdvanced.
    END.
  END.
  IF (lOpen) THEN
    ENABLE Btn_OK bAdvanced Btn_Help Btn_Cancel 
        WITH FRAME fButtons. 
  ELSE
      ENABLE Btn_OK Btn_Help Btn_Cancel 
          WITH FRAME fButtons. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY cFileName cLogType cDateFormat cDateLang 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-1 cFileName bLogBrowse cLogType cDateFormat cDateLang 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
  DISPLAY dTimeAdj lTimeDir cCodepage cSrcMsgs cTrgMsgs dStartDate cStartTime 
          dEndDate cEndTime tOpenBrowse 
      WITH FRAME fAdvanced.
  ENABLE RECT-2 dTimeAdj lTimeDir cCodepage cSrcMsgs bSrcBrowse cTrgMsgs 
         bTrgBrowse dStartDate cStartTime dEndDate cEndTime tOpenBrowse 
      WITH FRAME fAdvanced.
  {&OPEN-BROWSERS-IN-QUERY-fAdvanced}
  ENABLE Btn_OK bAdvanced bPreview Btn_Help Btn_Cancel 
      WITH FRAME fButtons.
  {&OPEN-BROWSERS-IN-QUERY-fButtons}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guessType Dialog-Frame 
PROCEDURE guessType :
/*------------------------------------------------------------------------------
  Purpose:     Auto-populate the Log Type combo, based on the name of the 
               selected log file.
  Parameters:  <none>
  Notes:       This uses the guessType procedure from the LogRead Handler API
               Runs the guessType procedure for all loaded handlers that have one.
               The first handler that returns lHandled = TRUE is suggested as  
               the handler for this log file in the Log Type combo.
------------------------------------------------------------------------------*/
    /* Possibly a procedure in the main function, instead of here */
    
    DEFINE VARIABLE lHandled AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE cBaseName AS CHARACTER  NO-UNDO.

    cBaseName = getBaseName(cFileName).

    /* try to guess the type of log */
    FOR EACH ttlogtype NO-LOCK:
        IF ttlogtype.guesstype THEN
        DO:
            RUN guessType IN ttlogtype.hproc(INPUT cBaseName,
                                          OUTPUT lHandled) NO-ERROR.
            IF lHandled THEN
            DO WITH FRAME {&FRAME-NAME}:
                cLogType:SCREEN-VALUE = ttlogtype.logtype.
                APPLY "value-changed":U TO cLogType.
                LEAVE.
            END.
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateComboValues Dialog-Frame 
PROCEDURE populateComboValues :
/*------------------------------------------------------------------------------
  Purpose:     Populates the possible values for the Log Type, Date Format and
               Date Language combo boxes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* populate log types */
  RUN populateLogTypes.

  /* populate date formats */
  RUN populateDateFormats.
  
  /* populate source languages */
  RUN populateLanguages.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateDateFormats Dialog-Frame 
PROCEDURE populateDateFormats :
/*------------------------------------------------------------------------------
  Purpose:     Populates the possible values for the Date Format combo.
  Parameters:  <none>
  Notes:       Possible date formats are extracted from the getDateFormats()
               procedure in the utilities handle. These formats are obtained
               from the date format array (see logread/logdate.i).
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFormats AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix AS INTEGER    NO-UNDO.
  
  cDateFormat:DELIMITER IN FRAME Dialog-Frame = "|":U.
  
  RUN getDateFormats IN ghlogutils (TRUE,OUTPUT cFormats).
  
  cDateFormat:LIST-ITEM-PAIRS IN FRAME Dialog-Frame = cFormats.
  cDateFormat:ADD-FIRST("","0") IN FRAME Dialog-Frame. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateLanguages Dialog-Frame 
PROCEDURE populateLanguages :
/*------------------------------------------------------------------------------
  Purpose:     Populates the posible values for the Date Languages combo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFormats AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix AS INTEGER    NO-UNDO.
  
  cDateLang:DELIMITER IN FRAME Dialog-Frame = "|":U.
  
  RUN getLanguages IN ghlogutils (TRUE,OUTPUT cFormats).
  
  cDateLang:LIST-ITEM-PAIRS IN FRAME Dialog-Frame = cFormats.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateLogTypes Dialog-Frame 
PROCEDURE populateLogTypes :
/*------------------------------------------------------------------------------
  Purpose:     Populates the possible values for the Log Type combo.
  Parameters:  <none>
  Notes:       List is comprised from all loaded handlers.
------------------------------------------------------------------------------*/
  cLogType:DELETE(1) IN FRAME {&FRAME-NAME}.
FOR EACH ttlogtype WHERE hproc <> ? BY loadix:
    IF cLogType:ADD-LAST(ttlogtype.typename,ttlogtype.logtype) IN FRAME {&FRAME-NAME} THEN.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showAdvancedFrame Dialog-Frame 
PROCEDURE showAdvancedFrame :
/*------------------------------------------------------------------------------
  Purpose:     Controls hiding and displaying the Advanced frame (fAdvanced)
  Parameters:  lAdv - indicates whether the advanced from is to be displayed or hidden
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM lAdv AS LOG NO-UNDO.

  IF (lAdv = lAdvanced) THEN RETURN.

  /* display advanced frame if not opening */
  IF (lAdv OR lOpen = FALSE) THEN
  DO:
      /* show advanced properties */
      FRAME Dialog-Frame:HEIGHT = dWinHeight.
      FRAME fButtons:ROW = dButRow.
      FRAME fAdvanced:VISIBLE = TRUE.
      bAdvanced:LABEL = "Basic <<".
      RUN enableAdvancedFrame.
      lAdv = TRUE.
  END.
  ELSE
  DO:
      /* hide advanced properties */
      FRAME fAdvanced:VISIBLE = FALSE.
      FRAME fButtons:ROW = FRAME fButtons:ROW - FRAME fAdvanced:HEIGHT.
      FRAME Dialog-Frame:HEIGHT = FRAME Dialog-Frame:HEIGHT - FRAME fAdvanced:HEIGHT.
      bAdvanced:LABEL = "Advanced >>".
  END.
  lAdvanced = lAdv.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showPropertyValues Dialog-Frame 
PROCEDURE showPropertyValues :
/*------------------------------------------------------------------------------
  Purpose:     Displays the input parameters in the fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      ASSIGN 
          cFileName = cLogFile
          cLogType = coLogType
          cDateFormat = string(iDateFmtix)
          cDateLang = coSrcLang
          cCodePage = coCodePage
          cSrcMsgs = coSrcMsgs
          cTrgMsgs = coTrgMsgs
          dStartDate = doStartDate
          dEndDate = doEndDate          
          /* blank cLogFile if this is an Open */
          cLogFile = (IF lOpen THEN "" ELSE cLogFile)
          .
      
      IF (doTimeAdj < 0) THEN
      DO:
          RUN getTimeString IN ghlogutils(doTimeAdj * -1,FALSE,OUTPUT dTimeAdj).
          lTimeDir = FALSE.
      END.
      ELSE
      DO:
          RUN getTimeString IN ghlogutils(doTimeAdj,FALSE,OUTPUT dTimeAdj).
          lTimeDir = TRUE.
      END.

      RUN getTimeString IN ghlogutils(doStartTime,false,OUTPUT cStartTime).
      RUN getTimeString IN ghlogutils(doEndTime,false,OUTPUT cEndTime).

      /* tooltip for cDateLang */
      ASSIGN 
          cDateLang:TOOLTIP IN FRAME dialog-frame = 
          "Language for interpreting months as words. Not used by all handlers."
          cDateFormat:TOOLTIP IN FRAME dialog-Frame = 
          "Format of dates in log file. Not used by all handlers.".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBaseName Dialog-Frame 
FUNCTION getBaseName RETURNS CHARACTER
  ( INPUT cLogFile AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Extracts the filename part of the log file name
            (i.e. removes the path)
    Notes:  Used when guessing the log file type (guessType).
------------------------------------------------------------------------------*/

  DEFINE VARIABLE ipos AS INTEGER    NO-UNDO.
  ipos = R-INDEX(cLogFile,"\").
  IF ipos = 0 THEN ipos = R-INDEX(cLogFile,"/").
  IF ipos > 0 THEN
      RETURN SUBSTRING(cLogFile,ipos + 1).
  RETURN cLogFile.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

