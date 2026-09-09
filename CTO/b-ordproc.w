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

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM AS CHAR .
DEFINE SHARED VAR lh_Handle AS HANDLE.

DEFINE VARIABLE S-CODART AS CHAR INIT "".
DEFINE VARIABLE S-CODFOR AS CHAR INIT "01".

DEFINE BUFFER B-PR-ODPC FOR PR-ODPC.

DEFINE BUFFER B-ODPCX FOR PR-ODPCX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES PR-ODPC
&Scoped-define FIRST-EXTERNAL-TABLE PR-ODPC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PR-ODPC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PR-ODPCX Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PR-ODPCX.codart Almmmatg.DesMat ~
PR-ODPCX.CodFor PR-ODPCX.CodUnd PR-ODPCX.CanPed Almmmatg.DesMar 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PR-ODPCX OF PR-ODPC  WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = PR-ODPCX.Codcia ~
  AND Almmmatg.codmat = PR-ODPCX.codart NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table PR-ODPCX Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PR-ODPCX


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PR-ODPCX, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PR-ODPCX.codart COLUMN-LABEL "Codigo !Articulo"
      Almmmatg.DesMat
      PR-ODPCX.CodFor COLUMN-LABEL "Formula"
      PR-ODPCX.CodUnd
      PR-ODPCX.CanPed
      Almmmatg.DesMar COLUMN-LABEL "Marca"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 83 BY 4.12
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.PR-ODPC
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
         HEIGHT             = 4.12
         WIDTH              = 83.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.PR-ODPCX OF INTEGRAL.PR-ODPC ,INTEGRAL.Almmmatg WHERE INTEGRAL.PR-ODPCX ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.CodCia = INTEGRAL.PR-ODPCX.Codcia
  AND INTEGRAL.Almmmatg.codmat = INTEGRAL.PR-ODPCX.codart"
     _FldNameList[1]   > INTEGRAL.PR-ODPCX.codart
"PR-ODPCX.codart" "Codigo !Articulo" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   > INTEGRAL.PR-ODPCX.CodFor
"PR-ODPCX.CodFor" "Formula" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   = INTEGRAL.PR-ODPCX.CodUnd
     _FldNameList[5]   = INTEGRAL.PR-ODPCX.CanPed
     _FldNameList[6]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ?
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF PR-ODPCX.Codart, PR-ODPCX.CodFor, PR-ODPCX.CanPed
DO:
   
  IF PR-ODPCX.Codart:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
     APPLY "ENTRY" TO PR-ODPCX.Codart IN BROWSE {&BROWSE-NAME}.
     RETURN NO-APPLY.
  END.

   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF PR-ODPCX.Codart
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
   FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                  AND  Almmmatg.codmat = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF Almmmatg.TpoArt <> "A" THEN DO:
      MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
/*
   FIND B-ODPCX WHERE B-ODPCX.Codcia = S-CODCIA AND
                      B-ODPCX.NumOrd = PR-ODPC.NumOrd AND
                      B-ODPCX.Codart = SELF:SCREEN-VALUE
                      NO-LOCK NO-ERROR.
   IF AVAILABLE B-ODPCX THEN DO:
      MESSAGE "Articulo Duplicado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.

   END.
*/                         
   DISPLAY Almmmatg.DesMat @ Almmmatg.DesMat 
           Almmmatg.UndStk @ PR-ODPCX.Codund
           S-CODFOR        @ PR-ODPCX.CodFor
           WITH BROWSE {&BROWSE-NAME}.


   FIND FIRST PR-FORMC WHERE PR-FORMC.CodCia = S-CODCIA AND
                           PR-FORMC.CodArt = SELF:SCREEN-VALUE 
                           NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-FORMC THEN DO:
      MESSAGE "Codigo de Articulo no presenta formula" 
      VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-ODPCX.CodArt.
      RETURN NO-APPLY.           
   END.

   FIND FIRST PR-FORMD OF PR-FORMC NO-LOCK NO-ERROR. 
   
   IF NOT AVAILABLE PR-FORMC THEN DO:
      MESSAGE "Codigo de Articulo no presenta Materiales en formula" 
      VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-ODPCX.Codart.
      RETURN "ADM-ERROR".           
   END.

   APPLY "ENTRY" TO PR-ODPCX.CodFor IN BROWSE {&BROWSE-NAME}.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF PR-ODPCX.CodFor
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   
   FIND FIRST PR-FORMC WHERE PR-FORMC.CodCia = S-CODCIA AND
                           PR-FORMC.CodArt = PR-ODPCX.CodArt:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
                           PR-FORMC.CodFor = SELF:SCREEN-VALUE 
                           NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-FORMC THEN DO:
      MESSAGE "Codigo de Articulo no presenta formula" 
      VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-ODPCX.CodFor.
      RETURN NO-APPLY.           
   END.

   FIND FIRST PR-FORMD OF PR-FORMC NO-LOCK NO-ERROR. 
   IF NOT AVAILABLE PR-FORMC THEN DO:
      MESSAGE "Codigo de Articulo no presenta Materiales en formula" 
      VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO PR-ODPCX.CodFor.
      RETURN NO-APPLY.           
   END.


   APPLY "ENTRY" TO PR-ODPCX.CanPed IN BROWSE {&BROWSE-NAME}.
   RETURN NO-APPLY.

END.


ON "LEAVE":U OF PR-ODPCX.CanPed
DO:
   IF DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN NO-APPLY.
   

END.


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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "PR-ODPC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PR-ODPC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Costos B-table-Win 
PROCEDURE Costos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        /*
        /*********Costo Promedio************/
        FIND LAST Almdmov WHERE Almdmov.CodCia = S-CODCIA AND
                                Almdmov.CodMat = PR-FORMD.CodMat AND
                                Almdmov.fchdoc <= TODAY 
                                USE-INDEX Almd02 NO-LOCK NO-ERROR.
         IF AVAILABLE Almdmov THEN 
           F-STKGEN = Almdmov.StkAct.
         ELSE 
           F-STKGEN = 0.
   
         IF AVAILABLE Almdmov AND ICodMon = 1 THEN F-VALCTO = Almdmov.VctoMn1.
         IF AVAILABLE Almdmov AND ICodMon = 2 THEN F-VALCTO = Almdmov.VctoMn2.
         F-VALCTO = IF F-STKGEN <> 0 THEN F-VALCTO ELSE 0.
         X-COSTO  = IF (F-STKGEN > 0) THEN ROUND(F-VALCTO / F-STKGEN,2) ELSE 0.     
         /*******************************************/
         
         /************Reposicion****************/
         FIND LAST Almdmov WHERE Almdmov.CodCia = PR-FORMD.CodCia 
                            AND  Almdmov.CodMat = PR-FORMD.CodMat 
                            AND  Almdmov.fchdoc <= TODAY 
                            AND  Almdmov.TipMov = "I"
                            AND  lookup(string(Almdmov.CodMov,'99'),"00,02,06,17") gt 0
                            AND  Almdmov.Preuni * Almdmov.tpocmb ne 0
                            USE-INDEX Almd02 NO-LOCK NO-ERROR.
         IF AVAILABLE Almdmov THEN DO:
             X-COSTO = Almdmov.PreUni.
             IF ICodMon <> almdmov.codmon THEN DO:
                IF ICodMon = 1 THEN X-COSTO = X-COSTO * almdmov.TpoCmb. 
                IF ICodMon = 2 THEN X-COSTO = X-COSTO / almdmov.TpoCmb. 
             END.
         END.
         ELSE X-COSTO = 0.
         /****************************************************/  
         */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden B-table-Win 
PROCEDURE Genera-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR X-TOTCTO AS DECI INIT 0.
  DEFINE VAR X-COSTO AS DECI INIT 0.
  DEFINE VAR F-STKGEN AS DECI INIT 0.
  DEFINE VAR F-VALCTO AS DECI INIT 0.
  DEFINE VAR ICODMON  AS INTEGER INIT 0.
  ICODMON = PR-ODPC.CodMon.
  
  FOR EACH PR-ODPD OF PR-ODPC EXCLUSIVE-LOCK 
      ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE PR-ODPD.
  END.
  FOR EACH PR-ODPCX OF PR-ODPC: 
      FIND B-ODPCX WHERE B-ODPCX.Codcia = PR-ODPCX.Codcia AND
                         B-ODPCX.CodArt = PR-ODPCX.Codart AND
                         B-ODPCX.CodFor = PR-ODPCX.CodFor
                         EXCLUSIVE-LOCK NO-ERROR.
                         
      FIND PR-FORMC WHERE PR-FORMC.CodCia = S-CODCIA AND
                          PR-FORMC.CodArt = PR-ODPCX.CodArt AND 
                          PR-FORMC.CodFor = PR-ODPCX.CodFor
                          NO-LOCK NO-ERROR.

      IF AVAILABLE PR-FORMC THEN DO:
        X-TOTCTO = 0.
        FOR EACH PR-FORMD OF PR-FORMC NO-LOCK :              
            /**************Comercial*********************/  
            FIND FIRST Almmmatg WHERE Almmmatg.codcia = PR-FORMD.CodCia 
                                 AND  Almmmatg.CodMat = PR-FORMD.CodMat 
                                 NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN DO:
                X-COSTO = Almmmatg.Ctolis.
                IF ICodMon <> Almmmatg.monvta THEN DO:
                   IF ICodMon = 1 THEN X-COSTO = X-COSTO * Almmmatg.tpocmb. 
                   IF ICodMon = 2 THEN X-COSTO = X-COSTO / Almmmatg.tpocmb. 
                END.
            END.
            ELSE X-COSTO = 0.    
            /****************************************************/      
            FIND PR-ODPD WHERE PR-ODPD.Codcia = PR-ODPCX.Codcia AND
                               PR-ODPD.NumOrd = PR-ODPCX.NumOrd AND
                               PR-ODPD.Codmat = PR-FORMD.Codmat
                               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE PR-ODPD THEN DO:                      
                CREATE PR-ODPD.      
                ASSIGN 
                PR-ODPD.CodCia = PR-ODPCX.CodCia
                PR-ODPD.NumOrd = PR-ODPCX.NumOrd
                PR-ODPD.CodMat = PR-FORMD.CodMat
                PR-ODPD.CodUnd = PR-FORMD.Codund
                PR-ODPD.CtoPro = X-COSTO.
            END.
            PR-ODPD.CanPed = PR-ODPD.CanPed + PR-FORMD.CanPed * PR-ODPCX.CanPed .
            PR-ODPD.CtoTot = PR-ODPD.CtoTot + X-COSTO * PR-FORMD.CanPed * PR-ODPCX.CanPed .
        END.     
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE PR-ODPC THEN RETURN.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO:  
     DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
        PR-ODPCX.Codcia = S-CODCIA
        PR-ODPCX.NumOrd = PR-ODPC.NumOrd
        PR-ODPCX.CodUnd = Almmmatg.UndStk.
        
        /*
        PR-ODPCX.CanPed = PR-ODPCX.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        PR-ODPCX.Codart = PR-ODPCX.Codart:SCREEN-VALUE
        PR-ODPCX.Codfor = PR-ODPCX.Codfor:SCREEN-VALUE.
        */
     END.
  END.

  RUN Genera-Orden.  


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE PR-ODPCX THEN RETURN "ADM-ERROR".

  IF PR-ODPC.FlgEst = "A" THEN RETURN "ADM-ERROR".
  
  IF PR-ODPC.FlgEst = "C" THEN DO:
     MESSAGE "Orden de Produccion ya fue Liquidada, no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.

  IF PR-ODPC.FlgEst = "C" THEN DO:
     MESSAGE "Orden de Produccion ya fue Liquidada, no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
  IF PR-ODPC.CanAte <> 0 THEN DO:
     MESSAGE "Orden presenta avance en Produccion, no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.

  /*
  IF PR-ODPC.FlgEst = "P" THEN DO:
     MESSAGE "Orden de Produccion presenta atenciones no puede ser eliminado" VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
  */
  FOR EACH PR-ODPD OF PR-ODPC NO-LOCK :
      IF PR-ODPD.CanDes <> 0 THEN DO:
         MESSAGE "Orden presenta despachos , no puede ser eliminado" 
         VIEW-AS ALERT-BOX.
         RETURN "ADM-ERROR".
      END.
      IF PR-ODPD.CanAte <> 0 THEN DO:
         MESSAGE "Orden presenta materiales consumidos, no puede ser eliminado" 
         VIEW-AS ALERT-BOX.
         RETURN "ADM-ERROR".
      END.

  END  .


  FOR EACH PR-ODPD OF PR-ODPC EXCLUSIVE-LOCK 
      ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE PR-ODPD.
  END.
  FOR EACH PR-ODPDG OF PR-ODPC EXCLUSIVE-LOCK 
      ON ERROR UNDO, RETURN "ADM-ERROR":
      DELETE PR-ODPDG.
  END.

  FIND B-ODPCX WHERE B-ODPCX.Codcia = PR-ODPCX.Codcia AND
                     B-ODPCX.NumOrd = PR-ODPCX.NumOrd AND
                     B-ODPCX.CodArt = PR-ODPCX.Codart AND
                     B-ODPCX.CodFor = PR-ODPCX.CodFor
                     EXCLUSIVE-LOCK NO-ERROR.
  
  DELETE B-ODPCX.
  RELEASE B-ODPCX.
  
  RUN Genera-Orden.  

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
  {src/adm/template/snd-list.i "PR-ODPC"}
  {src/adm/template/snd-list.i "PR-ODPCX"}
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
  /* RHC 16-01-04 No se debe repetir */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN DO:
    FIND FIRST B-ODPCX OF PR-ODPC WHERE b-odpcx.codart = pr-odpcx.codart:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-ODPCX
    THEN DO:
        MESSAGE "Código del Artículo ya ha sido registrado"
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
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
IF NOT AVAILABLE PR-ODPC THEN RETURN "ADM-ERROR".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


