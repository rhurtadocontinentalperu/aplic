&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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
{BIN/S-GLOBAL.I}
{AJT/AJGLOBAL.I}

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
&Scoped-define INTERNAL-TABLES cb-cfgc

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table cb-cfgc.CodCta cb-cfgc.CtaAft ~
cb-cfgc.CtrCta cb-cfgc.Metodo cb-cfgc.Origen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table cb-cfgc.CodCta ~
cb-cfgc.CtaAft cb-cfgc.CtrCta cb-cfgc.Metodo cb-cfgc.Origen 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodCta ~{&FP2}CodCta ~{&FP3}~
 ~{&FP1}CtaAft ~{&FP2}CtaAft ~{&FP3}~
 ~{&FP1}CtrCta ~{&FP2}CtrCta ~{&FP3}~
 ~{&FP1}Metodo ~{&FP2}Metodo ~{&FP3}~
 ~{&FP1}Origen ~{&FP2}Origen ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table cb-cfgc
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table cb-cfgc
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH cb-cfgc ~
      WHERE codcia = cb-codcia and ~
codcfg = 1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table cb-cfgc
&Scoped-define FIRST-TABLE-IN-QUERY-br_table cb-cfgc


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      cb-cfgc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      cb-cfgc.CodCta
      cb-cfgc.CtaAft COLUMN-LABEL "Cuenta Afecta"
      cb-cfgc.CtrCta COLUMN-LABEL "Contra Cuenta"
      cb-cfgc.Metodo COLUMN-LABEL "M‚todo"
      cb-cfgc.Origen
  ENABLE
      cb-cfgc.CodCta
      cb-cfgc.CtaAft
      cb-cfgc.CtrCta
      cb-cfgc.Metodo HELP ""
      cb-cfgc.Origen
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 43.72 BY 14.54
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .

 

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
         HEIGHT             = 14.54
         WIDTH              = 43.72.
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
     _TblList          = "integral.cb-cfgc"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "codcia = cb-codcia and
codcfg = 1"
     _FldNameList[1]   > integral.cb-cfgc.CodCta
"cb-cfgc.CodCta" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.cb-cfgc.CtaAft
"cb-cfgc.CtaAft" "Cuenta Afecta" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[3]   > integral.cb-cfgc.CtrCta
"cb-cfgc.CtrCta" "Contra Cuenta" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[4]   > integral.cb-cfgc.Metodo
"cb-cfgc.Metodo" "M‚todo" ? "character" ? ? ? ? ? ? yes ""
     _FldNameList[5]   > integral.cb-cfgc.Origen
"cb-cfgc.Origen" ? ? "logical" ? ? ? ? ? ? yes ?
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


&Scoped-define SELF-NAME cb-cfgc.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgc.CodCta br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-cfgc.CodCta IN BROWSE br_table /* Cuenta */
OR "F8":U OF cb-cfgc.Codcta DO:
   run get-cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfgc.CtaAft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgc.CtaAft br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-cfgc.CtaAft IN BROWSE br_table /* Cuenta Afecta */
OR "F8":U OF cb-cfgc.CtaAft DO:
   run get-cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfgc.CtrCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgc.CtrCta br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-cfgc.CtrCta IN BROWSE br_table /* Contra Cuenta */
OR "F8":U OF cb-cfgc.CtrCta DO :
   run get-cta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfgc.Metodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgc.Metodo br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-cfgc.Metodo IN BROWSE br_table /* M‚todo */
OR "F8":U OF CB-CFGC.METODO DO:
  def var p-val as char.
  def var p-desval as char.
  def var p-return as char.
  p-val     = "S,A".
  P-desval =  "Saldo por Partida,Agotamiento".
  RUN ADM/H-CONS01.W ( P-VAL, P-DESVAL , OUTPUT P-RETURN ).
  if p-return <>  "" AND P-RETURN <> ? THEN SELF:SCREEN-VALUE = P-RETURN.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfgc.Origen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgc.Origen br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-cfgc.Origen IN BROWSE br_table /* Origen */
OR "F8":U OF CB-CFGC.ORIGEN DO:
  def var p-val as char.
  def var p-desval as char.
  def var p-return as char.
  p-val     = "CTB,OTR".
  P-desval =  "Contabilidad,Otros Sistemas".
  RUN ADM/H-CONS01.W ( P-VAL, P-DESVAL , OUTPUT P-RETURN ).
  if p-return <>  ? AND P-RETURN <> "" THEN SELF:SCREEN-VALUE = P-RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CREAR-REGISTRO B-table-Win 
PROCEDURE CREAR-REGISTRO :
CREATE CB-CFGC.
ASSIGN CB-CFGC.CODCIA = CB-CODCIA
       CB-CFGC.CODCFG = 1.
       REPOSITION {&BROWSE-NAME} TO ROWID ROWID(CB-CFGC).
       RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-cta B-table-Win 
PROCEDURE get-cta :
DEFINE   variable    P-CODCTA    AS CHAR.  
    run adm/h-ctas03.w (   s-codcia       , 
                                  0       ,
                        SELF:SCREEN-VALUE ,
                        OUTPUT P-CODCTA   
                      ).
     IF P-CODCTA <> ? AND P-CODCTA <> "" THEN
        SELF:SCREEN-VALUE = P-CODCTA.                        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime B-table-Win 
PROCEDURE imprime :
DEFINE FRAME f-cab 
  
  Cb-cfgC.CodCta  column-label "Cuenta"           format "x(10)"
  Cb-cfgC.CtaAft  column-label "Cuenta de!Ajuste" format "x(10)"
  Cb-cfgC.CtrCta  column-label "Contra!Cuenta   " format "x(10)"
  Cb-cfgC.Metodo  column-label "M‚todo"           
  Cb-cfgC.Origen  column-label "Origen"
    
  HEADER  
     "CONFIGURACION DE CUENTAS AFECTAS A INFLACION" SKIP(2)
                  
  WITH DOWN NO-BOX STREAM-IO  WIDTH 255. 

OUTPUT TO PRINTER.
FOR EACH integral.cb-cfgc
      NO-LOCK
      WHERE codcia = cb-codcia and
      codcfg = 1 :
      DISPLAY
      Cb-cfgC.CodCta 
      Cb-cfgC.CtaAft 
      Cb-cfgC.CtrCta 
      Cb-cfgC.Metodo 
      Cb-cfgC.Origen 
      WITH FRAME F-CAB.
     
END.
OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
RUN VALIDA.
  IF RETURN-VALUE = "ERROR" THEN RETURN.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
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
  {src/adm/template/snd-list.i "cb-cfgc"}

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

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDA B-table-Win 
PROCEDURE VALIDA :
DEF VAR C1 AS CHAR.
DEF VAR C2 AS CHAR.
DEF VAR C3 AS CHAR.
DEF VAR C4 AS CHAR.


C1 = CB-CFGC.CODCTA:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
C2 = CB-CFGC.CtaAft:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
C3 = CB-CFGC.CtrCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
C4 = CB-CFGC.METODO:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

IF NOT CAN-FIND ( CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
                                CB-CTAS.CODCTA = C1)
THEN DO:                                
     MESSAGE "Invalido c¢digo de cuenta " C1
     VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO CB-CFGC.CODCTA IN BROWSE {&BROWSE-NAME}.
     RETURN "ERROR".
END.

IF NOT CAN-FIND ( CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
                                CB-CTAS.CODCTA = C2)
THEN DO:                                
     MESSAGE "Invalido c¢digo de cuenta " C2
     VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO CB-CFGC.CtaAft IN BROWSE {&BROWSE-NAME}.
     RETURN "ERROR".
END.

IF NOT CAN-FIND ( CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
                                CB-CTAS.CODCTA = C3)
THEN DO:                                
     MESSAGE "Invalido c¢digo de cuenta " C3
     VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO CB-CFGC.CtrCta IN BROWSE {&BROWSE-NAME}.
     RETURN "ERROR".
END.
IF INDEX("SA",C4) = 0 THEN DO:
   MESSAGE "Invalido Metodo " C4
   VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY":U TO CB-CFGC.METODO IN BROWSE {&BROWSE-NAME}.
   RETURN "ERROR".
END. 
RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


