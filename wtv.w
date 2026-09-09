&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}


DEF TEMP-TABLE t-nodo NO-UNDO
    FIELD nodo AS CHAR
    FIELD coddiv AS CHAR.

DEF VAR x-coddiv AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almacen

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Almacen.CodAlm Almacen.Descripcion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Almacen ~
      WHERE Almacen.CodCia = 1 ~
 AND Almacen.CodDiv = x-coddiv NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Almacen ~
      WHERE Almacen.CodCia = 1 ~
 AND Almacen.CodDiv = x-coddiv NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Almacen


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS lTraceEvents BROWSE-2 edMsg 
&Scoped-Define DISPLAYED-OBJECTS lTraceEvents edMsg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addToEdMsg wWin 
FUNCTION addToEdMsg RETURNS LOGICAL
  (pcTxt AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_pure4gltv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE edMsg AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 119 BY 6.92
     FONT 0 NO-UNDO.

DEFINE VARIABLE lTraceEvents AS LOGICAL INITIAL yes 
     LABEL "Trace events" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY 1.19 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Almacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Almacen.CodAlm FORMAT "x(5)":U
      Almacen.Descripcion FORMAT "X(40)":U WIDTH 45.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 57 BY 14
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     lTraceEvents AT ROW 1.54 COL 131 WIDGET-ID 4
     BROWSE-2 AT ROW 4.5 COL 131 WIDGET-ID 200
     edMsg AT ROW 21.19 COL 3 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 188.86 BY 27.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 27.85
         WIDTH              = 188.86
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 188.86
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 188.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 lTraceEvents fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.Almacen"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Almacen.CodCia = 1
 AND Almacen.CodDiv = x-coddiv"
     _FldNameList[1]   = INTEGRAL.Almacen.CodAlm
     _FldNameList[2]   > INTEGRAL.Almacen.Descripcion
"Descripcion" ? ? "character" ? ? ? ? ? ? no ? no no "45.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lTraceEvents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lTraceEvents wWin
ON VALUE-CHANGED OF lTraceEvents IN FRAME fMain /* Trace events */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'src/treeviewsource/pure4gltv.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'wineModeAutomaticwindowsSkinAutomaticpicCacheCoef1labCacheCoef1tvIterationHeight17TreeStyle3FocSelNodeBgColor1UnfSelNodeBgColor8tvnodeDefaultFont1FocSelNodeFgColor15UnfSelNodeFgColor0resizeVertical?resizeHorizontal?DragSourcenoneautoSortnoMSkeyScrollForcePaintyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_pure4gltv ).
       RUN repositionObject IN h_pure4gltv ( 1.54 , 3.00 ) NO-ERROR.
       RUN resizeObject IN h_pure4gltv ( 19.38 , 127.00 ) NO-ERROR.

       /* Links to pure4glTv h_pure4gltv. */
       RUN addLink ( h_pure4gltv , 'tvNodeEvent':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_pure4gltv ,
             lTraceEvents:HANDLE IN FRAME fMain , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY lTraceEvents edMsg 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE lTraceEvents BROWSE-2 edMsg 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR X AS INTE.
  DEF VAR Y AS CHAR.
  DEF VAR z AS INTE.
  DEF VAR k AS CHAR.

  EMPTY TEMP-TABLE t-nodo.
  FOR EACH gn-divi NO-LOCK WHERE codcia = 1:
      X = X + 1.
      Y = "n" + TRIM(STRING(X)).
      RUN addNode IN h_pure4gltv  (Y,"",GN-DIVI.CodDiv + " " + GN-DIVI.DesDiv,"","")             NO-ERROR.
      z = 0.
      k = ''.
/*       FOR EACH almacen NO-LOCK WHERE almacen.codcia = 1 AND almacen.coddiv = gn-divi.coddiv:                       */
/*           z = z + 1.                                                                                               */
/*           k = Y + TRIM(STRING(z)).                                                                                 */
/*           RUN addNode IN h_pure4gltv  (k,Y,almacen.codalm + " " + Almacen.Descripcion,"","")             NO-ERROR. */
/*       END.                                                                                                         */
      CREATE t-nodo.
      t-nodo.nodo = Y.
      t-nodo.coddiv = gn-divi.coddiv.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeEvent wWin 
PROCEDURE tvNodeEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcEvent   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcnodeKey AS CHARACTER  NO-UNDO.

DEFINE VARIABLE nCust     AS INTEGER    NO-UNDO.
DEFINE VARIABLE norder    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cSalesrep AS CHARACTER  NO-UNDO.
DEFINE VARIABLE icustnum  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iorder AS INTEGER    NO-UNDO.


IF lTraceEvents THEN addToEdMsg(STRING(pcEvent,FILL("X",25)) + pcnodeKey + "~n").
 
CASE pcEvent:
  WHEN "addOnExpand" THEN RUN tvNodeaddOnExpand (pcnodeKey).
  WHEN "select"      THEN RUN tvNodeSelect (pcnodeKey).
  
  WHEN "rightClick"  THEN DO:
      RUN tvNodeCreatePopup (pcnodeKey) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN RETURN RETURN-VALUE.
      ELSE MESSAGE "tvNodeCreatePopup failed with the following message:" RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.
  
  /* place to handle the Menu event */
  WHEN "MenuAddChildNode"
   OR WHEN "MenuAddSR"
   OR WHEN "MenuAddCustomer"
   OR WHEN "MenuAddOrder"
   OR WHEN "MenuAddOrderLine"
   THEN addToEdMsg("Menu item event fired: " + pcEvent + " for key " + pcnodeKey + "~n").
   
   WHEN "MenuHelloWorld" THEN MESSAGE "Hello World!" SKIP
      "Node key parent of the popup menu item:" + pcNodeKey
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
   
   WHEN "DragBegin" THEN DO:
       /* sample with Large tree (1000 nodes), the node keys are of type "k<n>" 
         by returning "yourself" the treview will be the drop target to move a node
         to another location in the tree */
       IF pcnodeKey BEGINS "k" THEN RETURN "dropOnYourself".
       
       /* see node n4 in small TV */
       IF pcnodeKey = "n4" THEN RETURN "cancelDrag".
       
       /* drop target frame is in another window */
       IF pcnodeKey = "n1" THEN DO:
           /* to test that, use PRO*Tools/run to run C:\BabouSoft\tv4gl\OtherDropTargetWin.w
             with the persistent option before running this test container */
           DEFINE VARIABLE hTargetFrame AS HANDLE     NO-UNDO.
           PUBLISH "getOtherWinTargetFrame" (OUTPUT hTargetFrame).
           IF VALID-HANDLE(hTargetFrame) THEN RETURN STRING(hTargetFrame).
       END.

       /* for the other samle, the target is this container */
       RETURN STRING(FRAME fMain:HANDLE).
   END.
   
   OTHERWISE IF pcEvent BEGINS "DropEnd," THEN RUN tvNodeDropEnd (pcEvent, pcNodeKey).
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeSelect wWin 
PROCEDURE tvNodeSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
  Purpose: example to use tvNodeEvent procedure with pure4GlTv
  Parameters: 
  Notes: I use this procedure for mulitple demo treeview
     Note that I rely on pcnodeKey to distinguish the different
     sample treeview
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcnodeKey AS CHARACTER  NO-UNDO.

DEFINE VARIABLE nCust     AS INTEGER    NO-UNDO.
DEFINE VARIABLE norder    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cSalesrep  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE icustnum   AS INTEGER    NO-UNDO.
DEFINE VARIABLE ccustname  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iorder     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cparentKey AS CHARACTER  NO-UNDO.
DEFINE VARIABLE optn       AS CHARACTER  NO-UNDO.

FIND t-nodo WHERE t-nodo.nodo = pcnodekey.
IF AVAILABLE t-nodo THEN DO:
    x-coddiv = t-nodo.coddiv.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/*========= For text treview sample, nodeKey beings 'n' ================*/


/*======== For data treeview example on salesrep customer order orderline: ========*/



/*-------------- add more customers to salesrep --------------*/
IF pcNodeKey BEGINS "MoreCust=" THEN DO:
    /*
    ASSIGN
     icustnum = INT(ENTRY(2,pcNodeKey,"="))
     cparentKey = DYNAMIC-FUNCTION('getNodeParentKey' IN h_pure4glTv, pcNodeKey)
     cSalesrep = ENTRY(2,cparentKey,"=").
    FIND customer NO-LOCK WHERE customer.custnum = icustnum.
    cCustName = customer.name.
    
    FOR EACH customer NO-LOCK WHERE
     customer.salesrep = cSalesrep
     AND customer.name >= cCustName
     BY customer.name:
        nCust = nCust + 1.
        IF nCust > giRowsToBatch THEN DO:
            RUN addNode IN h_pure4gltv ("MoreCust=" + STRING(customer.custnum)
                                       ,cparentKey
                                       ,"More..."
                                       ,""
                                       ,"InViewPortIfPossible").
            LEAVE.
        END.
        optn = "InViewPortIfPossible".
        IF nCust = 1 THEN optn = optn + CHR(1) + "selected".
        IF CAN-FIND(FIRST order OF customer)
         THEN optn = optn + CHR(1) + "addOnExpand".
        
        RUN addNode IN h_pure4gltv ("cust=" + STRING(customer.custnum)
                                   ,cParentKey
                                   ,customer.name
                                   ,"tvpics/smile56.bmp"
                                   ,optn).
    END.  /* for each customer */
    
    RUN deleteNode IN h_Pure4glTv (pcNodeKey, "refresh").
    */
END. /* add more customers to salesrep node */


/*-------------- add more orders to customer --------------*/
IF pcNodeKey BEGINS "MoreOrder=" THEN DO:
    /*
    ASSIGN
     iorder = INT(ENTRY(2,pcNodeKey,"="))
     cparentKey = DYNAMIC-FUNCTION('getNodeParentKey' IN h_pure4glTv, pcNodeKey)
     icustnum = INT(ENTRY(2,cparentKey,"=")).
     
    FOR EACH order NO-LOCK WHERE
     order.custnum = icustnum
     AND order.ordernum >= iorder
     BY order.ordernum:
        norder = nOrder + 1.
        IF norder > giRowsToBatch THEN DO:
            RUN addNode IN h_pure4gltv ("MoreOrder=" + STRING(order.ordernum)
                                       ,cparentKey
                                       ,"More..."
                                       ,""
                                       ,"InViewPortIfPossible").
            LEAVE.
        END.
        optn = "InViewPortIfPossible".
        IF norder = 1 THEN optn = optn + CHR(1) + "selected".
        IF CAN-FIND(FIRST orderline OF order)
         THEN optn = optn + CHR(1) + "addOnExpand".
        
        RUN addNode IN h_pure4gltv ("order=" + STRING(order.ordernum)
                                   ,cparentKey
                                   ,STRING(order.ordernum) + " (" + STRING(order.orderdate) + ")"
                                   ,"tvpics/book02.bmp"
                                   ,optn).
    END.  /* for each customer */
    RUN deleteNode IN h_Pure4glTv (pcNodeKey, "refresh").
    */
END. /* add customers to salesrep node */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addToEdMsg wWin 
FUNCTION addToEdMsg RETURNS LOGICAL
  (pcTxt AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


  IF edMsg:LENGTH IN FRAME fMain > 31000 THEN edMsg:SCREEN-VALUE =
    SUBSTR(edMsg:SCREEN-VALUE,1000).
       
  edmsg:CURSOR-OFFSET = edmsg:LENGTH + 1.
  edMsg:INSERT-STRING(pcTxt).
  
  RETURN YES.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

