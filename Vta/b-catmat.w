&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEF SHARED VAR s-codcia AS INT.

&SCOPED-DEFINE CONDICION Almmmatg.codpr1 BEGINS x-CodPro ~
AND Almmmatg.desmar BEGINS x-DesMar ~
AND Almmmatg.codfam BEGINS x-CodFam ~
AND Almmmatg.subfam BEGINS x-SubFam

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCtMat Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCtMat.codmat Almmmatg.DesMat ~
Almmmatg.DesMar FacCtMat.Categoria 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacCtMat.codmat ~
FacCtMat.Categoria 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}codmat ~{&FP2}codmat ~{&FP3}~
 ~{&FP1}Categoria ~{&FP2}Categoria ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacCtMat
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacCtMat
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCtMat WHERE ~{&KEY-PHRASE} ~
      AND FacCtMat.CodCia = s-codcia NO-LOCK, ~
      EACH Almmmatg OF FacCtMat ~
      WHERE {&CONDICION} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacCtMat Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCtMat


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-CodPro x-DesMar x-CodFam x-SubFam br_table 
&Scoped-Define DISPLAYED-OBJECTS x-CodPro x-NomPro x-DesMar x-CodFam ~
x-DesFam x-SubFam x-DesSub 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "x(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-DesMar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE x-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCtMat, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCtMat.codmat COLUMN-LABEL "<Codigo>"
      Almmmatg.DesMat
      Almmmatg.DesMar COLUMN-LABEL "Marca"
      FacCtMat.Categoria FORMAT "x(2)"
  ENABLE
      FacCtMat.codmat
      FacCtMat.Categoria HELP "1, 2, 3 o 4"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 74 BY 12.5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodPro AT ROW 1.19 COL 11 COLON-ALIGNED
     x-NomPro AT ROW 1.19 COL 23 COLON-ALIGNED NO-LABEL
     x-DesMar AT ROW 2.15 COL 11 COLON-ALIGNED
     x-CodFam AT ROW 3.12 COL 11 COLON-ALIGNED
     x-DesFam AT ROW 3.12 COL 23 COLON-ALIGNED NO-LABEL
     x-SubFam AT ROW 4.08 COL 11 COLON-ALIGNED
     x-DesSub AT ROW 4.08 COL 23 COLON-ALIGNED NO-LABEL
     br_table AT ROW 5.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 16.62
         WIDTH              = 87.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
/* BROWSE-TAB br_table x-DesSub F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCtMat,INTEGRAL.Almmmatg OF INTEGRAL.FacCtMat"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "INTEGRAL.FacCtMat.CodCia = s-codcia"
     _Where[2]         = "{&CONDICION}"
     _FldNameList[1]   > INTEGRAL.FacCtMat.codmat
"FacCtMat.codmat" "<Codigo>" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > INTEGRAL.FacCtMat.Categoria
"FacCtMat.Categoria" ? "x(2)" "character" ? ? ? ? ? ? yes "1, 2, 3 o 4"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCtMat.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCtMat.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF FacCtMat.codmat IN BROWSE br_table /* <Codigo> */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999') 
    NO-ERROR.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg
  THEN DISPLAY Almmmatg.desmat Almmmatg.desmar WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodFam B-table-Win
ON LEAVE OF x-CodFam IN FRAME F-Main /* Familia */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Almtfami WHERE Almtfami.codcia = s-codcia
    AND Almtfami.codfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtfami THEN DO:
    MESSAGE 'Códio de familia no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  x-DesFam:SCREEN-VALUE = Almtfami.desfam.
  IF {&SELF-NAME} <> SELF:SCREEN-VALUE THEN RUN Filtrado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro B-table-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
  IF {&SELF-NAME} <> SELF:SCREEN-VALUE THEN RUN Filtrado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-DesMar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-DesMar B-table-Win
ON LEAVE OF x-DesMar IN FRAME F-Main /* Marca */
DO:
  IF {&SELF-NAME} <> SELF:SCREEN-VALUE THEN RUN Filtrado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-SubFam B-table-Win
ON LEAVE OF x-SubFam IN FRAME F-Main /* Sub-Familia */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Almsfami WHERE Almsfami.codcia = s-codcia
    AND Almsfami.codfam = x-codfam:SCREEN-VALUE  
    AND Almsfami.subfam = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almsfami THEN DO:
    MESSAGE 'Código de sub-familia no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  x-DesSub:SCREEN-VALUE = AlmSFami.dessub.
  IF {&SELF-NAME} <> SELF:SCREEN-VALUE THEN RUN Filtrado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF FacCtMat.codmat DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Filtrado B-table-Win 
PROCEDURE Filtrado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN FRAME {&FRAME-NAME}
    x-CodFam x-CodPro x-DesFam x-DesMar x-DesSub x-NomPro x-SubFam.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
    x-CodFam = ''
    x-CodPro = ''
    x-DesFam = ''
    x-DesMar = ''
    x-DesSub = ''
    x-NomPro = ''
    x-SubFam = ''
    x-CodFam:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-CodPro:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-DesFam:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-DesMar:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-DesSub:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-NomPro:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-SubFam:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  DISPLAY
    x-CodFam x-CodPro x-DesFam x-DesMar x-DesSub x-NomPro x-SubFam
    WITH FRAME {&FRAME-NAME}.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    Facctmat.codcia = s-codcia.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    x-CodFam:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-CodPro:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-DesFam:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-DesMar:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-DesSub:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-NomPro:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-SubFam:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  DISPLAY
    x-CodFam x-CodPro x-DesFam x-DesMar x-DesSub x-NomPro x-SubFam
    WITH FRAME {&FRAME-NAME}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    x-CodFam:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-CodPro:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-DesFam:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-DesMar:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-DesSub:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-NomPro:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    x-SubFam:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
PROCEDURE procesa-parametros :
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "FacCtMat"}
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = FacCtMat.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Material no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
/*  IF LOOKUP(FacCtMat.Categoria:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, '1,2,3,4,5') = 0
 *   THEN DO:
 *     MESSAGE 'La Categoria debe ser: 1, 2, 3, 4 ó 5' VIEW-AS ALERT-BOX ERROR.
 *     RETURN 'ADM-ERROR'.
 *   END.*/
  IF FacCtMat.Categoria:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' THEN DO:
    MESSAGE 'Ingrese la categoria' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  RETURN "OK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN
    x-CodFam:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-CodPro:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-DesFam:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-DesMar:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-DesSub:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-NomPro:SENSITIVE IN FRAME {&FRAME-NAME} = NO
    x-SubFam:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


