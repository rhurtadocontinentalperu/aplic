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

{bin/s-global.i}
/*{pln/s-global.i}*/

DEFINE  SHARED VARIABLE s-periodo AS INTEGER   FORMAT "9999".
DEFINE  SHARED VARIABLE s-NroMes  AS INTEGER   FORMAT "99".
DEFINE  SHARED VARIABLE s-NroSem  AS INTEGER   FORMAT "9999".

DEFINE VARIABLE x-Nombre AS CHARACTER.

DEFINE BUFFER B-MAQHH FOR LPRMHRHM.

s-periodo = year(today).
s-nromes  = month(today).

DEFINE TEMP-TABLE T-MAQ
  FIELDS CODMAQ LIKE LPRMAQUI.CODMAQ 
  FIELDS DESMAQ LIKE LPRMAQUI.DESPRO
  FIELDS CODPER LIKE PL-PERS.CODPER
  FIELDS NOMPER LIKE PL-PERS.PATPER FORMAT 'X(50)'.

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
&Scoped-define EXTERNAL-TABLES LPRMAQUI
&Scoped-define FIRST-EXTERNAL-TABLE LPRMAQUI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LPRMAQUI.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES LPRMHRHM

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table LPRMHRHM.CodPer x-nombre @ x-nombre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table LPRMHRHM.CodPer 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodPer ~{&FP2}CodPer ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table LPRMHRHM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table LPRMHRHM
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH LPRMHRHM WHERE LPRMHRHM.CodCia = LPRMAQUI.CodCia ~
  AND LPRMHRHM.CodMaq = LPRMAQUI.CodMaq NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table LPRMHRHM
&Scoped-define FIRST-TABLE-IN-QUERY-br_table LPRMHRHM


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
      LPRMHRHM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      LPRMHRHM.CodPer COLUMN-LABEL "Código Personal"
      x-nombre @ x-nombre COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(85)"
  ENABLE
      LPRMHRHM.CodPer
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 78 BY 8.08
         FONT 4
         TITLE "Personal".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.19 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.LPRMAQUI
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
         HEIGHT             = 8.96
         WIDTH              = 81.57.
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
     _TblList          = "INTEGRAL.LPRMHRHM WHERE INTEGRAL.LPRMAQUI <external> ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "LPRMHRHM.CodCia = LPRMAQUI.CodCia
  AND LPRMHRHM.CodMaq = LPRMAQUI.CodMaq"
     _FldNameList[1]   > INTEGRAL.LPRMHRHM.CodPer
"LPRMHRHM.CodPer" "Código Personal" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > "_<CALC>"
"x-nombre @ x-nombre" "Apellidos y Nombres" "x(85)" ? ? ? ? ? ? ? no ?
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

{src/bin/_prns.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Personal */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Personal */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Personal */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LPRMHRHM.CodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LPRMHRHM.CodPer br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF LPRMHRHM.CodPer IN BROWSE br_table /* Código Personal */
DO:
/*  IF SELF:SCREEN-VALUE = "" THEN RETURN.
 *   FIND PL-PERS WHERE PL-PERS.CodCia = S-CodCia AND
 *        PL-PERS.codper = SELF:SCREEN-VALUE
 *        NO-LOCK NO-ERROR.
 *   IF NOT AVAILABLE PL-PERS THEN DO:
 *      MESSAGE "No existe empleado" VIEW-AS ALERT-BOX ERROR.
 *      RETURN NO-APPLY.
 *   END.
 *   ELSE 
 *    DISPLAY 
 *      PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper @ X-NOMBRE
 *   WITH BROWSE {&BROWSE-NAME}.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LPRMHRHM.CodPer br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF LPRMHRHM.CodPer IN BROWSE br_table /* Código Personal */
OR F8 OF LPRMHRHM.CodPer DO:

    DEFINE VARIABLE reg-act AS ROWID.
    RUN PLN/H-FLG-M-PR.R (1, OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
        FIND PL-FLG-MES WHERE ROWID(PL-FLG-MES) = reg-act NO-LOCK NO-ERROR.
        IF AVAILABLE PL-FLG-MES THEN
           LPRMHRHM.CodPEr:screen-value IN BROWSE {&BROWSE-NAME} = PL-FLG-MES.CodPer.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF LPRMHRHM DO:
  FIND PL-PERS WHERE PL-PERS.CodPer = LPRMHRHM.CodPer NO-LOCK NO-ERROR.
    IF AVAILABLE PL-PERS THEN
        ASSIGN
            x-Nombre = integral.PL-PERS.patper + " " +
            integral.PL-PERS.matper + ", " + integral.PL-PERS.nomper.
    ELSE ASSIGN x-Nombre = "".
END.

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
  {src/adm/template/row-list.i "LPRMAQUI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LPRMAQUI"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
/* FIND FIRST LPRMAQUI NO-LOCK NO-ERROR.
 *   IF AVAILABLE LPRMHRHM THEN DO:*/
 FOR EACH LPRMAQUI NO-LOCK,
     EACH LPRMHRHM NO-LOCK WHERE 
      LPRMHRHM.CODCIA = LPRMAQUI.CODCIA AND
      LPRMHRHM.CODMAQ = LPRMAQUI.CODMAQ,
      EACH PL-PERS NO-LOCK WHERE 
        PL-PERS.CODCIA = LPRMHRHM.CODCIA AND
        PL-PERS.CODPER = LPRMHRHM.CODPER
        BREAK BY LPRMAQUI.CodMaq:
           CREATE T-MAQ.
           ASSIGN
              T-MAQ.CODMAQ = LPRMAQUI.CODMAQ
              T-MAQ.DESMAQ = LPRMAQUI.DESPRO
              T-MAQ.CODPER = LPRMHRHM.CODPER
              T-MAQ.NOMPER = PL-PERS.PATPER + ' ' + PL-PERS.MATPER + ' ' + PL-PERS.NOMPER.
 END.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato B-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-Titulo1 AS CHAR.
DEFINE VAR x-Titulo2 AS CHAR.
   
DEFINE FRAME F-REPORTE
    T-MAQ.CodPer /*COLUMN-LABEL 'Código'*/
    T-MAQ.NomPer /*COLUMN-LABEL 'Apellidos y Nombres' FORMAT 'X(60)'*/
    WITH WIDTH 100 NO-BOX NO-LABELS STREAM-IO DOWN. 

  ASSIGN 
    x-Titulo1 = "LISTADO DE HOMBRES POR MAQUINA"
    x-Titulo2 = "".
    
  DEFINE FRAME F-HEADER
    HEADER
    S-NOMCIA FORMAT "X(50)" AT 1 SKIP
    X-Titulo1  AT 30 FORMAT "X(50)" SKIP 
    x-titulo2  FORMAT "X(60)"  SKIP
    /*"Maquinaria   : " T-MAQ.CodMaq "  " T-MAQ.DesMaq FORMAT "X(60)"  SKIP*/
    "Pagina : " TO 80 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha  : " TO 80 TODAY FORMAT "99/99/9999" SKIP SKIP
    WITH PAGE-TOP WIDTH 100 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
    
  DEFINE FRAME F-BODY
    SKIP(3)
    "Maquinaria: " LPRMAQUI.CodMaq " " LPRMAQUI.DesPro FORMAT "X(60)"  SKIP(1)
    "  Código     Apellidos y Nombres  "
    "-----------------------------------------------------------------------"
    WITH PAGE-TOP WIDTH 100 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.  
   
  FOR EACH LPRMAQUI NO-LOCK:
           VIEW STREAM REPORT FRAME F-HEADER.
            DISPLAY STREAM REPORT
                LPRMAQUI.CODMAQ
                LPRMAQUI.DESPRO
            WITH STREAM-IO NO-BOX WITH FRAME F-bODY. 
    FOR EACH T-MAQ WHERE
        T-MAQ.CODMAQ    = LPRMAQUI.CODMAQ AND 
        T-MAQ.CODPER    <> ""        
        BREAK BY T-MAQ.CODPER :
        DISPLAY STREAM REPORT 
            T-MAQ.CodPer  WHEN FIRST-OF(T-MAQ.CODPER)
            T-MAQ.NomPer  WHEN FIRST-OF(T-MAQ.CODPER)
        WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.
    END.
  END.
  
   
/*/*  FOR EACH T-MAQ BREAK BY T-MAQ.CODMAQ :
 *  *    VIEW STREAM REPORT FRAME F-HEADER.
 *  *    MESSAGE TQ-MAQ.CODMAQ VIEW-AS ALERT-BOX
 *  *    IF FIRST-OF (CODMAQ)
 *  *     THEN DO:
 *  *      DISPLAY STREAM REPORT
 *  *         T-MAQ.CODMAQ
 *  *         T-MAQ.DESMAQ
 *  *         WITH STREAM-IO NO-BOX WITH FRAME F-bODY. 
 *  *      
 *  *      DISPLAY STREAM REPORT 
 *  *       T-MAQ.CodPer
 *  *       T-MAQ.NomPer
 *  *       WITH FRAME F-REPORTE.
 *  *         /*DISPLAY NumOrd @ Fi-Mensaje LABEL "O/Produccion"
 *  *  *               FORMAT "X(11)" WITH FRAME F-PROCESO.*/
 *  *       DOWN STREAM REPORT WITH FRAME F-REPORTE.
 *  * /*   END.   */  
 *  *   END.*/*/
HIDE FRAME F-PROCESO.

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
  assign 
    LPRMHRHM.CodCia   = LPRMAQUI.CodCia
    LPRMHRHM.CodMaq   = LPRMAQUI.CodMaq
    LPRMHRHM.FchDoc   = TODAY
    LPRMHRHM.Usuario  = s-user-id.
  
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
  
  FIND FIRST PL-PERS WHERE
     PL-PERS.CodPer = LPRMHRHM.CodPer
     NO-LOCK NO-ERROR.
     IF AVAILABLE PL-PERS THEN DO:
       x-nombre =  PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper.
     END.
  
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
    
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    RUN Carga-Temporal.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) PAGED PAGE-SIZE 100.
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 500. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM report.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
  {src/adm/template/snd-list.i "LPRMAQUI"}
  {src/adm/template/snd-list.i "LPRMHRHM"}

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
  IF LPRMHRHM.CodPer:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}= "" THEN DO:
    MESSAGE "Código Inválido" VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO LPRMHRHM.CodPer.
    RETURN 'ADM-ERROR'.
  END.
  
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' AND
       CAN-FIND(FIRST B-MAQHH WHERE 
         B-MAQHH.CodCia = LPRMAQUI.CodCia AND
         B-MAQHH.CodMaq = LPRMAQUI.CodMaq AND
         B-MAQHH.CodPer = LPRMHRHM.CodPer:SCREEN-VALUE
         IN BROWSE {&BROWSE-NAME}
         NO-LOCK) THEN DO:
           MESSAGE "Personal ya registrado" VIEW-AS ALERT-BOX ERROR.
           APPLY 'ENTRY':U TO LPRMHRHM.CodPer.
           RETURN "ADM-ERROR".
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
 RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


