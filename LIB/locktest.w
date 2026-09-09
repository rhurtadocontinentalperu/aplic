&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          sports           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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

Def var hCustomer   as Handle no-undo.
Def var hOrder      as Handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Customer Order

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 Customer.Cust-Num Customer.Name 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH Customer NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH Customer NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 Customer
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 Customer


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Order.Order-Date Order.Order-num ~
Order.Instructions 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Order ~
      WHERE Order.Cust-Num = customer.cust-Num NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Order ~
      WHERE Order.Cust-Num = customer.cust-Num NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Order
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Order


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BROWSE-1 INFO BUTTON-1 BROWSE-2 ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS INFO 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Lock this customer" 
     SIZE 21.86 BY 1.15.

DEFINE BUTTON BUTTON-2 
     LABEL "Lock this order" 
     SIZE 21.86 BY 1.15.

DEFINE VARIABLE INFO AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 52.43 BY 13.85
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 0    
     SIZE 13.57 BY .81
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      Customer SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      Order SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      Customer.Cust-Num FORMAT ">>>>9":U
      Customer.Name FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 36 BY 8.77 TOOLTIP "Select customer.".

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 C-Win _STRUCTURED
  QUERY BROWSE-2 DISPLAY
      Order.Order-Date FORMAT "99/99/99":U
      Order.Order-num FORMAT ">>>>9":U
      Order.Instructions FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 36.86 BY 4.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BROWSE-1 AT ROW 1.81 COL 4.86
     INFO AT ROW 2.69 COL 69.57 NO-LABEL
     BUTTON-1 AT ROW 4.81 COL 44
     BROWSE-2 AT ROW 11.42 COL 4.57
     BUTTON-2 AT ROW 12.65 COL 44
     " Lock status." VIEW-AS TEXT
          SIZE 13.43 BY .81 AT ROW 1.58 COL 69.86
          BGCOLOR 3 FGCOLOR 10 
     RECT-1 AT ROW 1.77 COL 70.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 123 BY 16.


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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Locking test."
         HEIGHT             = 16
         WIDTH              = 123.86
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 123.86
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 123.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 RECT-1 DEFAULT-FRAME */
/* BROWSE-TAB BROWSE-2 BUTTON-1 DEFAULT-FRAME */
ASSIGN 
       INFO:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "sports.Customer"
     _FldNameList[1]   = sports.Customer.Cust-Num
     _FldNameList[2]   = sports.Customer.Name
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "sports.Order"
     _Where[1]         = "Order.Cust-Num = customer.cust-Num"
     _FldNameList[1]   = sports.Order.Order-Date
     _FldNameList[2]   = sports.Order.Order-num
     _FldNameList[3]   = sports.Order.Instructions
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Locking test. */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
  
    If valid-Handle( hCustomer ) then do :
                 DELETE PROCEDURE hCustomer.    /* RELEASE Customer lock.  */
                 INFO:Screen-Value in frame {&FRAME-NAME} = INFO:Screen-Value
                                + chr(10) +  "     Customer lock is now released.".
                 If Valid-Handle( hOrder ) then do :
                        DELETE PROCEDURE hOrder.
                        INFO:Screen-Value = INFO:Screen-Value
                                + chr(10) +  "     Order lock is now released.".
                        end.
                        
                 END.
     INFO:MOVE-TO-EOF().
                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Locking test. */
DO:
  /* This event will close the window and terminate the procedure.  */
  
      If valid-Handle( hCustomer ) then do :
                 DELETE PROCEDURE hCustomer.    /* RELEASE Customer lock.  */
                 INFO:Screen-Value in frame {&FRAME-NAME} = INFO:Screen-Value
                                + chr(10) +  "     Customer lock is now released.".
                 If Valid-Handle( hOrder ) then do :
                        DELETE PROCEDURE hOrder.
                        INFO:Screen-Value = INFO:Screen-Value
                                + chr(10) +  "     Order lock is now released.".
                        end.
                        
                 END.
     INFO:MOVE-TO-EOF().
     
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 C-Win
ON VALUE-CHANGED OF BROWSE-1 IN FRAME DEFAULT-FRAME
DO:
  {&OPEN-QUERY-Browse-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 C-Win
ON CHOOSE OF BUTTON-1 IN FRAME DEFAULT-FRAME /* Lock this customer */
DO:
  If valid-Handle( hCustomer ) then do :
                 DELETE PROCEDURE hCustomer.    /* RELEASE Customer lock.  */
                 INFO:Screen-Value = INFO:Screen-Value
                                + chr(10) +  "     Customer lock is now released.".
                 If Valid-Handle( hOrder ) then do :
                        DELETE PROCEDURE hOrder.
                        INFO:Screen-Value = INFO:Screen-Value
                                + chr(10) +  "     Order lock is now released.".
                        end.
                        
                 END.
                 
  Run lib/lock.p PERSISTENT set hCustomer  
             ("Customer", Rowid(Customer) ).
             
  IF RETURN-VALUE > "" then do :
            MESSAGE "Unable to lock" Customer.Name
                    skip
                    "It appears to be already locked."
                    view-as alert-box INFO
                                      Title "4GL: Tooltip #1".
            DELETE PROCEDURE hCustomer.
            end.
  ELSE
            INFO:Screen-Value = INFO:Screen-Value
                                + chr(10) + Customer.Name + ": Lock active.".
                                
 
 
  INFO:SCREEN-VALUE = INFO:SCREEN-VALUE + chr(10)
                        + "               " + string(TRANSACTION, "TRANSACTION ACTIVE/no transaction.").
  INFO:MOVE-TO-EOF().                             
                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 C-Win
ON CHOOSE OF BUTTON-2 IN FRAME DEFAULT-FRAME /* Lock this order */
DO:

If not available Order then do :
        Message "No order is currently available."
                skip(1)
                "(no changes have been made to current lock status)"
                view-as alert-box INFO.
        Return no-apply.
        end.
        
If Valid-Handle( hOrder ) then do :
       DELETE PROCEDURE hOrder.
       INFO:Screen-Value = INFO:Screen-Value
               + chr(10) +  "     Order lock is now released.".
       end.
                        

                 
  Run lib/lock.p PERSISTENT set hOrder  
             ("Order", Rowid(Order) ).
             
  IF RETURN-VALUE > "" then do :
            MESSAGE "Unable to lock order" Order-Num
                    skip
                    "It appears to be already locked."
                    view-as alert-box INFO
                                      Title "4GL: Tooltip #1".
            DELETE PROCEDURE hOrder.
            end.
  ELSE
            INFO:Screen-Value = INFO:Screen-Value
                                + chr(10) + "     Order " + string(Order-Num) + ". Lock active.".
                                
                               
  INFO:MOVE-TO-EOF().                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY INFO 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-1 BROWSE-1 INFO BUTTON-1 BROWSE-2 BUTTON-2 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

