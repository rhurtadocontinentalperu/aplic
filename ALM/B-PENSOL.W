&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEFINE STREAM REPORTE.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-NROSER AS INTEGER.
DEFINE NEW SHARED VAR S-CODVEN AS CHAR.
DEFINE SHARED VAR S-CODDIV AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almcrequ Almacen

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almcrequ.CodAlm Almcrequ.NroSer ~
Almcrequ.NroDoc Almcrequ.FchDoc Almcrequ.HorGen Almcrequ.Observ ~
Almcrequ.Usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH Almcrequ WHERE ~{&KEY-PHRASE} ~
      AND Almcrequ.CodCia = S-CODCIA ~
 AND Almcrequ.CodAlm BEGINS FILL-IN-codalm ~
 AND Almcrequ.FlgEst = "P" ~
 AND Almcrequ.Almdes = S-CODALM NO-LOCK, ~
      FIRST Almacen WHERE Almacen.CodAlm = Almcrequ.Almdes NO-LOCK ~
    BY Almcrequ.FchDoc DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almcrequ WHERE ~{&KEY-PHRASE} ~
      AND Almcrequ.CodCia = S-CODCIA ~
 AND Almcrequ.CodAlm BEGINS FILL-IN-codalm ~
 AND Almcrequ.FlgEst = "P" ~
 AND Almcrequ.Almdes = S-CODALM NO-LOCK, ~
      FIRST Almacen WHERE Almacen.CodAlm = Almcrequ.Almdes NO-LOCK ~
    BY Almcrequ.FchDoc DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table Almcrequ Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almcrequ
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almacen


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 FILL-IN-codalm br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codalm FILL-IN-desalm 

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
DEFINE BUTTON BUTTON-2 
     LABEL "FILTRAR" 
     SIZE 11.29 BY 1
     FONT 1.

DEFINE VARIABLE FILL-IN-codalm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen Solicitante" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-desalm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almcrequ, 
      Almacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almcrequ.CodAlm COLUMN-LABEL "Solicita" FORMAT "x(3)":U
      Almcrequ.NroSer COLUMN-LABEL "Nro.!Serie" FORMAT "999":U
      Almcrequ.NroDoc COLUMN-LABEL "Pedido" FORMAT "99999999":U
      Almcrequ.FchDoc COLUMN-LABEL "      Fecha     !      Emision" FORMAT "99/99/9999":U
      Almcrequ.HorGen COLUMN-LABEL "Hora!Emision" FORMAT "X(8)":U
      Almcrequ.Observ FORMAT "X(45)":U
      Almcrequ.Usuario FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 76.57 BY 5.27
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1.15 COL 65.57
     FILL-IN-codalm AT ROW 1.31 COL 14.43 COLON-ALIGNED
     FILL-IN-desalm AT ROW 1.31 COL 21.43 COLON-ALIGNED NO-LABEL
     br_table AT ROW 2.27 COL 1.43
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 6.69
         WIDTH              = 78.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table FILL-IN-desalm F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-desalm IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.Almcrequ,integral.Almacen WHERE integral.Almcrequ ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "integral.Almcrequ.FchDoc|no"
     _Where[1]         = "integral.Almcrequ.CodCia = S-CODCIA
 AND integral.Almcrequ.CodAlm BEGINS FILL-IN-codalm
 AND integral.Almcrequ.FlgEst = ""P""
 AND integral.Almcrequ.Almdes = S-CODALM"
     _JoinCode[2]      = "integral.Almacen.CodAlm = integral.Almcrequ.Almdes"
     _FldNameList[1]   > integral.Almcrequ.CodAlm
"Almcrequ.CodAlm" "Solicita" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.Almcrequ.NroSer
"Almcrequ.NroSer" "Nro.!Serie" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.Almcrequ.NroDoc
"Almcrequ.NroDoc" "Pedido" "99999999" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.Almcrequ.FchDoc
"Almcrequ.FchDoc" "      Fecha     !      Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.Almcrequ.HorGen
"Almcrequ.HorGen" "Hora!Emision" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.Almcrequ.Observ
"Almcrequ.Observ" ? "X(45)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = integral.Almcrequ.Usuario
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
/*  RUN alm\d-penrep.r(Almcrequ.NroDoc).*/
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* FILTRAR */
DO:
   ASSIGN 
      Fill-in-codalm
      FILL-IN-desalm.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codalm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codalm B-table-Win
ON LEAVE OF FILL-IN-codalm IN FRAME F-Main /* Almacen Solicitante */
DO:
   IF SELF:SCREEN-VALUE <> "" THEN DO:
      FIND Almacen WHERE Almacen.CodCia = s-codcia AND
           Almacen.CodAlm = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almacen THEN DO:
         MESSAGE 'Almacen no existe' VIEW-AS ALERT-BOX.
         APPLY 'ENTRY':U TO SELF.
         RETURN NO-APPLY.
      END.
      FILL-IN-desalm = Almacen.Descripcion.
      DISPLAY 
         FILL-IN-desalm WITH FRAME {&FRAME-NAME}.
   END.     


/*  DO WITH FRAME {&FRAME-NAME}:
  END.*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abrir-query B-table-Win 
PROCEDURE abrir-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* Definimos impresoras */
  DEFINE VAR s-printer-list AS CHAR.
  DEFINE VAR s-port-list AS CHAR.
  DEFINE VAR s-port-name AS CHAR format "x(20)".
  DEFINE VAR s-printer-count AS INTEGER.

/*MLR* ***
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
*MLR* ***/
 
  FIND FIRST FacCorre WHERE 
       FacCorre.CodCia = S-CODCIA AND
       FacCorre.CodDoc = "REP"    AND
       FacCorre.CodDiv = S-CODDIV AND
       FacCorre.CodAlm = S-CODALM  NO-LOCK NO-ERROR.
/*MLR* 29/10/07 Nueva librearía de impresión ***/
RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
IF s-port-name = '' THEN RETURN.

/*MLR* ***
  IF NOT AVAILABLE FacCorre OR LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
     MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.
  
  s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").  
*MLR* ***/
  
  DEFINE VARIABLE S-Tit  AS CHAR NO-UNDO.
  DEFINE VARIABLE S-Item AS INTEGER INIT 0.
  DEFINE VAR S-DesSol AS CHAR FORMAT "X(60)" NO-UNDO.
  DEFINE VAR S-CODUBI AS CHAR NO-UNDO.
  DEFINE VAR F-STOCK AS DECIMAL NO-UNDO.
  DEFINE FRAME F-FMT
         S-Item AT 2 FORMAT "Z9"
         Almdrequ.codmat AT 6   FORMAT "X(6)"
         S-CODUBI        AT 13  FORMAT "X(6)"
         Almmmatg.DesMat AT 21  FORMAT "X(40)"
         Almmmatg.DesMar AT 63  FORMAT "X(12)"
         Almmmatg.UndStk AT 76  FORMAT "X(4)"
         Almmmatg.CanEmp AT 81  FORMAT ">>,>>9.99"
         F-STOCK         AT 92  FORMAT ">>>,>>>.99"
         Almdrequ.CanReq AT 104 FORMAT ">,>>>,>>9.99"
         "------------" AT 118
         HEADER
         S-NOMCIA AT 1 "REPOSICION No. : " AT 99 STRING(Almcrequ.NroSer,"999") + STRING(Almcrequ.NroDoc,"999999") AT 119 FORMAT "XXX-XXXXXX" SKIP
         "( " + Almcrequ.CodAlm + " )" AT 2 "SOLICITUD DE REPOSICION INTERNO" AT 50  "PAG. " AT 99 PAGE-NUMBER(REPORTE) FORMAT ">>9" SKIP(1)
         "Solicitado      : "   AT 1 S-DESSOL AT 21 "Fecha      : " AT 87 Almcrequ.FchDoc AT 105 SKIP
         "Responsable     : "   AT 1 Almacen.EncAlm AT 21 "Hora       : " AT 87 Almcrequ.HorGen AT 105 SKIP
         "Observaciones   : "   AT 1 Almcrequ.Observ  AT 21 SKIP
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
         "ITEM CODIGO UB.FIS.               DESCRIPCION                    MARCA     UND   EMPAQUE   STOCK ACTUAL  SOLICITADO    APROBADO  " SKIP    
         "( " + S-CODALM + " )" AT 94 SKIP
         "---------------------------------------------------------------------------------------------------------------------------------" SKIP
          WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.

  /*OUTPUT STREAM Reporte TO VALUE( s-port-name ) PAGED PAGE-SIZE 30.  */
  
  {lib/_printer-stream-to.i 30 REPORTE PAGED}

  FIND FIRST Almdrequ WHERE 
             Almdrequ.CodCia = Almcrequ.CodCia AND
             Almdrequ.CodAlm = Almcrequ.CodAlm AND
             Almdrequ.NroDoc = Almcrequ.NroDoc NO-LOCK NO-ERROR.
  IF AVAILABLE Almdrequ THEN DO:
     S-DesSol = Almcrequ.AlmDes.
     FIND Almacen WHERE Almacen.CodCia = Almdrequ.CodCia AND
          Almacen.CodAlm = Almcrequ.AlmDes NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN  S-DesSol = S-DesSol + " " + Almacen.Descripcion.
     PUT STREAM Reporte CONTROL CHR(27) + CHR(67) + CHR(33).
     PUT STREAM Reporte CONTROL CHR(27) + CHR(15).
     FOR EACH Almdrequ NO-LOCK WHERE AVAILABLE Almdrequ AND
            Almdrequ.CodCia = Almcrequ.CodCia AND
            Almdrequ.CodAlm = Almcrequ.CodAlm AND
            Almdrequ.NroSer = Almcrequ.NroSer AND
            Almdrequ.NroDoc = Almcrequ.NroDoc ,
         FIRST Almmmatg OF Almdrequ NO-LOCK
         BREAK BY Almdrequ.AlmDes  BY Almmmatg.DesMat:
         /* BREAK BY Almdrequ.AlmDes BY Almmmate.CodUbi BY Almmmate.DesMat: */
         S-Item = S-Item + 1.     
         IF FIRST-OF ( Almdrequ.AlmDes ) THEN DO:
            FIND Almacen WHERE almacen.CodCia = Almdrequ.CodCia AND
                 almacen.CodAlm = Almdrequ.Almdes NO-LOCK NO-ERROR.
            S-Tit = "Almacen de Despacho : " + Almdrequ.Almdes.
         /* IF AVAILABLE almacen THEN S-Tit = S-Tit + " - " + Almacen.Descripcion.
            DISPLAY STREAM Reporte S-Tit @ Almmmatg.DesMat WITH FRAME F-FMT.
            DOWN 2 STREAM Reporte WITH FRAME F-FMT.*/
         END.
         /*
         IF FIRST-OF ( Almmmate.CodUbi ) THEN DO:
            FIND almtubic WHERE almtubic.CodCia = Almdrequ.CodCia AND
                 almtubic.CodAlm = Almdrequ.Almdes AND
                 almtubic.CodUbi = Almmmate.CodUbi NO-LOCK NO-ERROR.
            S-Tit = "          Articulos Ubicados en : " + Almmmate.CodUbi.
          /*IF AVAILABLE almtubic THEN S-Tit = S-Tit + almtubic.DesUbi.
            DISPLAY STREAM Reporte S-Tit @ Almmmatg.DesMat WITH FRAME F-FMT.
            DOWN 2 STREAM Reporte WITH FRAME F-FMT.*/
         END.
         */
         S-CODUBI = "".
         F-STOCK  = 0.
         FIND Almmmate WHERE almmmate.codcia = Almdrequ.Codcia AND
                             almmmate.codalm = S-CODALM AND
                             almmmate.codmat = Almdrequ.Codmat NO-LOCK NO-ERROR.
         IF AVAILABLE Almmmate THEN 
            ASSIGN S-CODUBI = Almmmate.CodUbi
                   F-STOCK  = Almmmate.StkAct.
         
         DISPLAY STREAM Reporte 
                   S-Item
                   Almdrequ.Codmat 
                   S-CODUBI 
                   Almmmatg.DesMat 
                   Almmmatg.DesMar 
                   Almmmatg.UndStk 
                   Almmmatg.CanEmp
                   F-STOCK  
                   Almdrequ.CanReq WITH FRAME F-FMT.
         DOWN STREAM Reporte WITH FRAME F-FMT.
     END.     
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 4 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "        ------------------                ------------------              ------------------  " AT 10 SKIP.
  PUT STREAM Reporte "             Operador                         Supervisor                        Vo.Bo.        " AT 10 SKIP.
  PUT STREAM Reporte Almcrequ.Usuario AT 24 " JEFE ALMACEN " AT 86 SKIP.     
  OUTPUT STREAM Reporte CLOSE.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

/*  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY
        S-CODALM @ FILL-IN-codalm.
  END.*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almcrequ"}
  {src/adm/template/snd-list.i "Almacen"}

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

