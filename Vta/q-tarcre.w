FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu gn-clie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.NroDoc CcbCDocu.NomCli CcbCDocu.CodVen CcbCDocu.FchDoc CcbCDocu.FchVto X-PAG @ X-PAG X-MON @ X-MON CcbCDocu.ImpTot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table CASE COMBO-BOX-8:SCREEN-VALUE IN FRAME {&FRAME-NAME} :      WHEN "Fechas" THEN DO :         OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}              AND CcbCDocu.CodCia = S-CODCIA              AND CcbCDocu.CodDiv = S-CODDIV              AND CcbCDocu.CodDoc = S-CODDOC              AND SubString(CcbCDocu.NroDoc, ~
      1, ~
      1) <> "S"              AND CcbCDocu.nomcli BEGINS wclient              AND CcbCDocu.FlgEst = "P"              AND CcbCDocu.FchDoc >= F-DesFch              AND CCbCDocu.FchDoc <= F-HasFch NO-LOCK, ~
                    FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK              {&SORTBY-PHRASE}.      END.      OTHERWISE DO :         OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}              AND CcbCDocu.CodCia = S-CODCIA              AND CcbCDocu.CodDiv = S-CODDIV              AND CcbCDocu.CodDoc = S-CODDOC              AND SubString(CcbCDocu.NroDoc, ~
      1, ~
      1) <> "S"              AND CcbCDocu.nomcli BEGINS wclient              AND CcbCDocu.FlgEst = "P" NO-LOCK, ~
                    FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK              {&SORTBY-PHRASE}.      END. END CASE.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table COMBO-BOX-8 F-DesFch wclient wguia ~
F-HasFch BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-8 F-DesFch wclient wguia ~
F-HasFch 

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
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print":U
     LABEL "Button 1" 
     SIZE 7.72 BY 1.12.

DEFINE VARIABLE COMBO-BOX-8 AS CHARACTER FORMAT "X(256)":U INITIAL "Guía" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Guía","Cliente","Fechas" 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE F-DesFch AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .77 NO-UNDO.

DEFINE VARIABLE F-HasFch AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .77 NO-UNDO.

DEFINE VARIABLE wclient AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .77 NO-UNDO.

DEFINE VARIABLE wguia AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "# Guía" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.NroDoc COLUMN-LABEL " Guia" FORMAT "XXX-XXXXXXXX"
      CcbCDocu.NomCli FORMAT "x(44)"
      CcbCDocu.CodVen COLUMN-LABEL "Vend." FORMAT "x(5)"
      CcbCDocu.FchDoc COLUMN-LABEL "     Fecha    !     Emisión"
      CcbCDocu.FchVto COLUMN-LABEL "   Fecha   !Vencimiento"
      X-PAG @ X-PAG COLUMN-LABEL "Tip.!Vta." FORMAT "X(4)"
      X-MON @ X-MON COLUMN-LABEL "Mon." FORMAT "XXX"
      CcbCDocu.ImpTot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 86.57 BY 13.04
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.73 COL 1
     COMBO-BOX-8 AT ROW 1.35 COL 8.14 COLON-ALIGNED NO-LABEL
     F-DesFch AT ROW 1.42 COL 28.86 COLON-ALIGNED
     wclient AT ROW 1.46 COL 28.86 COLON-ALIGNED
     wguia AT ROW 1.46 COL 28.86 COLON-ALIGNED
     F-HasFch AT ROW 1.42 COL 50.57 COLON-ALIGNED
     BUTTON-1 AT ROW 1.23 COL 77.57
     "Buscar x" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 1.5 COL 2
          FONT 6
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
         HEIGHT             = 14.81
         WIDTH              = 87.29.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
CASE COMBO-BOX-8:SCREEN-VALUE IN FRAME {&FRAME-NAME} :
     WHEN "Fechas" THEN DO :
        OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}
             AND CcbCDocu.CodCia = S-CODCIA
             AND CcbCDocu.CodDiv = S-CODDIV
             AND CcbCDocu.CodDoc = S-CODDOC
             AND SubString(CcbCDocu.NroDoc,1,1) <> "S"
             AND CcbCDocu.nomcli BEGINS wclient
             AND CcbCDocu.FlgEst = "P"
             AND CcbCDocu.FchDoc >= F-DesFch
             AND CCbCDocu.FchDoc <= F-HasFch NO-LOCK,
             FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK
             {&SORTBY-PHRASE}.
     END.
     OTHERWISE DO :
        OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu WHERE {&KEY-PHRASE}
             AND CcbCDocu.CodCia = S-CODCIA
             AND CcbCDocu.CodDiv = S-CODDIV
             AND CcbCDocu.CodDoc = S-CODDOC
             AND SubString(CcbCDocu.NroDoc,1,1) <> "S"
             AND CcbCDocu.nomcli BEGINS wclient
             AND CcbCDocu.FlgEst = "P" NO-LOCK,
             FIRST gn-clie WHERE gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK
             {&SORTBY-PHRASE}.
     END.
END CASE.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
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

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
   RUN vta\d-guipen.r(CcbCDocu.NroDoc,"G/R").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  RUN Formato.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-8 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-8 IN FRAME F-Main
DO:
  wguia:HIDDEN    = yes.
  wclient:HIDDEN  = yes.
  F-DesFch:HIDDEN = yes.
  F-HasFch:HIDDEN = yes.
  ASSIGN COMBO-BOX-8.
  CASE COMBO-BOX-8:
       WHEN "Cliente" THEN
            wclient:HIDDEN = not wclient:HIDDEN.
       WHEN "Guía" THEN
            wguia:HIDDEN = not wguia:HIDDEN.
       WHEN "Fechas" THEN DO :
            F-DesFch:HIDDEN = not F-DesFch:HIDDEN.     
            F-HasFch:HIDDEN = not F-HasFch:HIDDEN.
       END.     
  END CASE.
  ASSIGN COMBO-BOX-8.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-HasFch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-HasFch B-table-Win
ON LEAVE OF F-HasFch IN FRAME F-Main /* Hasta */
or "RETURN":U of F-HasFch
DO:
  ASSIGN F-DesFch F-HasFch.
  RUN ABRIR-QUERY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wclient
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wclient B-table-Win
