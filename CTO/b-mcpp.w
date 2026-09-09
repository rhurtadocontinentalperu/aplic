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
&Scoped-define INTERNAL-TABLES Pr-Mcpp Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Pr-Mcpp.codmat Pr-Mcpp.ProPro ~
Pr-Mcpp.ProVta Pr-Mcpp.ProVtaCan[1] Pr-Mcpp.ProVtaCan[2] ~
Pr-Mcpp.ProVtaCan[3] Pr-Mcpp.ProVtaCan[5] Pr-Mcpp.ProVtaCan[8] ~
Pr-Mcpp.ProVtaCan[11] Pr-Mcpp.ProVtaCan[12] Pr-Mcpp.ProVtaCan[14] ~
Pr-Mcpp.ProVtaCan[15] Pr-Mcpp.ProVtaCan[16] Pr-Mcpp.ProVtaCanAte[1] ~
Pr-Mcpp.ProVtaCanAte[2] Pr-Mcpp.ProVtaCanAte[3] Pr-Mcpp.ProVtaCanAte[4] ~
Pr-Mcpp.ProVtaCanAte[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Pr-Mcpp WHERE ~{&KEY-PHRASE} ~
      AND Pr-Mcpp.CodCia = s-codcia ~
 AND Pr-Mcpp.Periodo = x-periodo NO-LOCK, ~
      EACH Almmmatg OF Pr-Mcpp NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Pr-Mcpp Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Pr-Mcpp


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-Periodo br_table 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-DesMat 

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
DEFINE VARIABLE x-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripcion" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.

DEFINE VARIABLE x-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 15 FGCOLOR 9 FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Pr-Mcpp, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Pr-Mcpp.codmat COLUMN-LABEL "Codigo de!Articulo"
      Pr-Mcpp.ProPro COLUMN-LABEL "Proyeccion !de Produccion" FORMAT ">>>>,>>9.99"
      Pr-Mcpp.ProVta COLUMN-LABEL "Proyeccion !de Venta" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[1] COLUMN-LABEL "00001!Ucayali" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[2] COLUMN-LABEL "00002!Andahuaylas" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[3] COLUMN-LABEL "00003!Paruro" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[5] COLUMN-LABEL "00005!Jesus Obrero" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[8] COLUMN-LABEL "00008!Miro Quesada" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[11] COLUMN-LABEL "00011!San Juan de M." FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[12] COLUMN-LABEL "00012!San Miguel" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[14] COLUMN-LABEL "00014!Vta. Horizontal" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[15] COLUMN-LABEL "00015!Expolibreria" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCan[16] COLUMN-LABEL "00016!Villa el Salvador" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCanAte[1] COLUMN-LABEL "Ate!Provincia" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCanAte[2] COLUMN-LABEL "Ate!Autoservicio" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCanAte[3] COLUMN-LABEL "Ate!Oficina" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCanAte[4] COLUMN-LABEL "Ate!Estatal" FORMAT ">>>,>>9.99"
      Pr-Mcpp.ProVtaCanAte[10] COLUMN-LABEL "Ate!Varios" FORMAT ">>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 143 BY 20.96
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Periodo AT ROW 1.19 COL 11 COLON-ALIGNED
     br_table AT ROW 2.35 COL 1
     x-DesMat AT ROW 23.5 COL 13 COLON-ALIGNED
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
         HEIGHT             = 23.85
         WIDTH              = 144.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
/* BROWSE-TAB br_table x-Periodo F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* SETTINGS FOR FILL-IN x-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Pr-Mcpp,INTEGRAL.Almmmatg OF INTEGRAL.Pr-Mcpp"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "INTEGRAL.Pr-Mcpp.CodCia = s-codcia
 AND INTEGRAL.Pr-Mcpp.Periodo = x-periodo"
     _FldNameList[1]   > INTEGRAL.Pr-Mcpp.codmat
"Pr-Mcpp.codmat" "Codigo de!Articulo" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > INTEGRAL.Pr-Mcpp.ProPro
"Pr-Mcpp.ProPro" "Proyeccion !de Produccion" ">>>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[3]   > INTEGRAL.Pr-Mcpp.ProVta
"Pr-Mcpp.ProVta" "Proyeccion !de Venta" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[4]   > INTEGRAL.Pr-Mcpp.ProVtaCan[1]
"Pr-Mcpp.ProVtaCan[1]" "00001!Ucayali" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[5]   > INTEGRAL.Pr-Mcpp.ProVtaCan[2]
"Pr-Mcpp.ProVtaCan[2]" "00002!Andahuaylas" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[6]   > INTEGRAL.Pr-Mcpp.ProVtaCan[3]
"Pr-Mcpp.ProVtaCan[3]" "00003!Paruro" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[7]   > INTEGRAL.Pr-Mcpp.ProVtaCan[5]
"Pr-Mcpp.ProVtaCan[5]" "00005!Jesus Obrero" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[8]   > INTEGRAL.Pr-Mcpp.ProVtaCan[8]
"Pr-Mcpp.ProVtaCan[8]" "00008!Miro Quesada" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[9]   > INTEGRAL.Pr-Mcpp.ProVtaCan[11]
"Pr-Mcpp.ProVtaCan[11]" "00011!San Juan de M." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[10]   > INTEGRAL.Pr-Mcpp.ProVtaCan[12]
"Pr-Mcpp.ProVtaCan[12]" "00012!San Miguel" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[11]   > INTEGRAL.Pr-Mcpp.ProVtaCan[14]
"Pr-Mcpp.ProVtaCan[14]" "00014!Vta. Horizontal" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[12]   > INTEGRAL.Pr-Mcpp.ProVtaCan[15]
"Pr-Mcpp.ProVtaCan[15]" "00015!Expolibreria" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[13]   > INTEGRAL.Pr-Mcpp.ProVtaCan[16]
"Pr-Mcpp.ProVtaCan[16]" "00016!Villa el Salvador" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[14]   > INTEGRAL.Pr-Mcpp.ProVtaCanAte[1]
"Pr-Mcpp.ProVtaCanAte[1]" "Ate!Provincia" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[15]   > INTEGRAL.Pr-Mcpp.ProVtaCanAte[2]
"Pr-Mcpp.ProVtaCanAte[2]" "Ate!Autoservicio" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[16]   > INTEGRAL.Pr-Mcpp.ProVtaCanAte[3]
"Pr-Mcpp.ProVtaCanAte[3]" "Ate!Oficina" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[17]   > INTEGRAL.Pr-Mcpp.ProVtaCanAte[4]
"Pr-Mcpp.ProVtaCanAte[4]" "Ate!Estatal" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[18]   > INTEGRAL.Pr-Mcpp.ProVtaCanAte[10]
"Pr-Mcpp.ProVtaCanAte[10]" "Ate!Varios" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
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
    IF AVAILABLE Almmmatg THEN 
  x-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Pr-Mcpp.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Pr-Mcpp.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Pr-Mcpp.codmat IN BROWSE br_table /* Codigo de!Articulo */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(DECIMAL(SELF:SCREEN-VALUE), '999999')
    NO-ERROR.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE ALmmmatg THEN x-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Periodo B-table-Win
ON LEAVE OF x-Periodo IN FRAME F-Main /* Periodo */
DO:
  ASSIGN {&SELF-NAME}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF Pr-Mcpp.codmat, Pr-Mcpp.ProPro, Pr-Mcpp.ProVta, 
    Pr-Mcpp.ProVtaCanAte[1], Pr-Mcpp.ProVtaCanAte[2], Pr-Mcpp.ProVtaCanAte[3],
    Pr-Mcpp.ProVtaCanAte[4], 
    Pr-Mcpp.ProVtaCan[1], Pr-Mcpp.ProVtaCan[2], Pr-Mcpp.ProVtaCan[3],
    Pr-Mcpp.ProVtaCan[5], Pr-Mcpp.ProVtaCan[8], Pr-Mcpp.ProVtaCan[11], 
    Pr-Mcpp.ProVtaCan[12], Pr-Mcpp.ProVtaCan[14], Pr-Mcpp.ProVtaCan[15], 
    Pr-Mcpp.ProVtaCan[16] DO:
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  x-Periodo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
    Pr-Mcpp.CodCia = s-codcia
    Pr-Mcpp.Periodo = x-Periodo.

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
  x-Periodo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatg THEN 
  x-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.desmat.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  x-Periodo = YEAR(TODAY).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*  DO WITH FRAME {&FRAME-NAME}:
 *     FOR EACH Cb-Peri WHERE Cb-Peri.codcia = s-codcia NO-LOCK:
 *         x-Periodo:ADD-LAST(STRING(Cb-Peri.Periodo, '9999')).
 *     END.
 *     ASSIGN
 *         x-Periodo:SCREEN-VALUE = STRING(YEAR(TODAY), '9999').
 *   END.
 * */
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
  x-Periodo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
  {src/adm/template/snd-list.i "Pr-Mcpp"}
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
    AND Almmmatg.codmat = Pr-Mcpp.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Material no registrado' VIEW-AS ALERT-BOX ERROR.
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
  x-Periodo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


