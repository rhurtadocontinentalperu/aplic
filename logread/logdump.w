&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: logread/logdump.w

  Description: Dumps out log file contents to a text file

  Parameters:
    cWhere - [IN] log filter criteria for selecting and sorting records
    htt    - [IN] handle to log file's temp-table
    hbr    - [IN] handle to the Log Browse window's browser
    
  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT PARAM cWhere AS CHAR NO-UNDO.
DEF INPUT PARAM htt AS HANDLE NO-UNDO.
DEF INPUT PARAM hbr AS HANDLE NO-UNDO.

/* help context ids */
{logread/loghelp.i}

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cqry rDumpFrom cFields bBrowse cDumpFile ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS cqry rDumpFrom cFields cDumpFile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bBrowse 
     IMAGE-UP FILE "logread/image/open.bmp":U
     LABEL "..." 
     SIZE 6 BY 1.14.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cqry AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 61 BY 3.57 NO-UNDO.

DEFINE VARIABLE cDumpFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "File" 
     VIEW-AS FILL-IN 
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE rDumpFrom AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Dump Selected Rows", 1,
"Dump All In Query", 2
     SIZE 60 BY 1.19 NO-UNDO.

DEFINE VARIABLE cFields AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE NO-DRAG 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "barf","barf" 
     SIZE 61 BY 3.81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cqry AT ROW 2.19 COL 3 NO-LABEL
     rDumpFrom AT ROW 6 COL 3 NO-LABEL
     cFields AT ROW 8.14 COL 3 NO-LABEL
     bBrowse AT ROW 12.14 COL 58
     cDumpFile AT ROW 12.19 COL 5 COLON-ALIGNED
     Btn_OK AT ROW 13.62 COL 17
     Btn_Cancel AT ROW 13.62 COL 33
     "Fields to dump:" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 7.19 COL 3
     "Query:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.24 COL 3
     SPACE(54.19) SKIP(13.13)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Dump Log To File"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


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
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN 
       cqry:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Dump Log To File */
DO:

    ASSIGN cDumpFile cFields rDumpFrom.
    /* check the dump file is valid */
    IF cDumpFile = "" OR cDumpFile = ? THEN
    DO:
        MESSAGE "Please enter a dump file name" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

    /* check if the file exists */
    FILE-INFO:FILE-NAME = cDumpFile.
    IF FILE-INFO:FILE-TYPE MATCHES "*F*" THEN
    DO:
        /* existing file */
        MESSAGE "File " + cDumpFile + " exists. Overwrite?"
            VIEW-AS ALERT-BOX WARNING
            BUTTONS OK-CANCEL
            TITLE "File exists"
            UPDATE lOK AS LOGICAL.            
        IF NOT lOK THEN
            RETURN NO-APPLY.
    END.
    ELSE IF FILE-INFO:FILE-TYPE MATCHES "*D*" THEN
    DO:
        /* directory */
        MESSAGE cDumpFile " is a directory. Please enter a filename."
            VIEW-AS ALERT-BOX ERROR
            BUTTONS OK
            TITLE "Error".
        RETURN NO-APPLY.
    END.

    IF rDumpFrom = 1 THEN
        RUN dumpSelected.
    ELSE
        RUN dumpLog.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON HELP OF FRAME Dialog-Frame /* Dump Log To File */
DO:
  {&LOGREADHELP} {&Log_Dump_dialog_box} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Dump Log To File */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bBrowse Dialog-Frame
ON CHOOSE OF bBrowse IN FRAME Dialog-Frame /* ... */
DO:
    DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
  SYSTEM-DIALOG GET-FILE cFile
      TITLE "Dump File Browse"
      UPDATE lOK.
  IF lOK THEN
  DO:
      ASSIGN 
      cDumpFile = cFile
      cDumpFile:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFile.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

cqry = cWhere.

RUN populateFieldList.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enableUI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dumpLog Dialog-Frame 
PROCEDURE dumpLog :
/*------------------------------------------------------------------------------
  Purpose:     Dumps the contents of the selected fields from all records 
               to nominated text file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.

  /* cFields is list of fields to dump */
  /* MESSAGE "Dumping log to " cDumpFile VIEW-AS ALERT-BOX. */

  /* create the query */
  CREATE QUERY hqry.
  /* hbuf = htt:DEFAULT-BUFFER-HANDLE. */
  CREATE BUFFER hbuf FOR TABLE htt:DEFAULT-BUFFER-HANDLE.
  hqry:SET-BUFFERS(hbuf).
  hqry:QUERY-PREPARE("for each " + hbuf:NAME + " where " + cWhere).
  hqry:QUERY-OPEN.

  /* output to the dumpfile */
  OUTPUT TO VALUE(cDumpFile).
  /* for each, dump list of fields */  
  REPEAT:
      hqry:GET-NEXT().
      IF hqry:QUERY-OFF-END THEN LEAVE.
      DO ictr = 1 TO NUM-ENTRIES(cFields):
          hfld = hbuf:BUFFER-FIELD(ENTRY(ictr,cFields)).
          IF VALID-HANDLE(hfld) THEN
          DO:
              PUT UNFORMATTED hfld:STRING-VALUE " ".
          END.
      END.
      PUT UNFORMATTED SKIP.
  END.

  OUTPUT CLOSE.
  DELETE OBJECT hbuf.

  MESSAGE "Log dumped to " cDumpFile VIEW-AS ALERT-BOX.
  APPLY 'GO':U TO FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dumpSelected Dialog-Frame 
PROCEDURE dumpSelected :
/*------------------------------------------------------------------------------
  Purpose:     Dumps the contents of the selected fields from selected records 
               to nominated text file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hqry AS HANDLE     NO-UNDO.
  DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.
  DEFINE VARIABLE irow AS INTEGER    NO-UNDO.

  /* cFields is list of fields to dump */

  hqry = hbr:QUERY.
  hbuf = hqry:GET-BUFFER-HANDLE(1).

  /* output to the dumpfile */
  OUTPUT TO VALUE(cDumpFile).
  
  /* for each selected record, dump list of fields */  
  DO irow = 1 TO hbr:NUM-SELECTED-ROWS:
      hbr:FETCH-SELECTED-ROW(irow).
      DO ictr = 1 TO NUM-ENTRIES(cFields):
          hfld = hbuf:BUFFER-FIELD(ENTRY(ictr,cFields)).
          IF VALID-HANDLE(hfld) THEN
          DO:
              PUT UNFORMATTED hfld:STRING-VALUE " ".
          END.
      END.
      PUT UNFORMATTED SKIP.
  END.

  OUTPUT CLOSE.

  MESSAGE "Log dumped to " cDumpFile VIEW-AS ALERT-BOX.
  APPLY 'GO':U TO FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableUI Dialog-Frame 
PROCEDURE enableUI :
/*------------------------------------------------------------------------------
  Purpose:     Enables the UI. Only enables the Dump From raedio-set if the
               user has selected rows in the Log Browse Window.
  Parameters:  <none>
  Notes:       calls enable_UI
------------------------------------------------------------------------------*/

   /* check selected rows in hbr */
   ASSIGN 
       rDumpFrom = 
           (IF hbr:NUM-SELECTED-ROWS > 0 THEN 1 ELSE 2).
   RUN enable_UI.
   IF hbr:NUM-SELECTED-ROWS = 0 THEN 
       rDumpFrom:SENSITIVE IN FRAME dialog-frame = FALSE.

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
  DISPLAY cqry rDumpFrom cFields cDumpFile 
      WITH FRAME Dialog-Frame.
  ENABLE cqry rDumpFrom cFields bBrowse cDumpFile Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateFieldList Dialog-Frame 
PROCEDURE populateFieldList :
/*------------------------------------------------------------------------------
  Purpose:     Displays the columns in the table in the Fields list.
               Allows the user to select which fields to dump.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hbuf AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hfld AS HANDLE     NO-UNDO.
   DEFINE VARIABLE ictr AS INTEGER    NO-UNDO.

   /* empty the field list first ? */
   cFields:DELETE(1) IN FRAME {&FRAME-NAME}.

   hbuf = htt:DEFAULT-BUFFER-HANDLE.
   DO ictr = 1 TO hbuf:NUM-FIELDS:
       hfld = hbuf:BUFFER-FIELD(ictr).
       cFields:ADD-LAST(hfld:NAME + " (" + hfld:DATA-TYPE + ")",
                        hfld:NAME) IN FRAME {&FRAME-NAME}.
       /* select all fields */
       cFields = cFields + hfld:NAME + ",".
   END.
   
   /* remove trailing , */
   IF cfields <> "" THEN
       cfields = SUBSTRING(cfields,1,LENGTH(cfields) - 1).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

