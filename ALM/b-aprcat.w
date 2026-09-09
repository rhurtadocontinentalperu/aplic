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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR lh_Handle AS HANDLE.

DEF BUFFER MATG FOR Almmmatg.

DEF VAR lComerciales AS LOG INIT ? NO-UNDO.

&SCOPED-DEFINE Condicion (lComerciales = ? OR Almtfami.SwComercial = lComerciales)

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
&Scoped-define INTERNAL-TABLES almtmatg Almtfami

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table almtmatg.codmat almtmatg.DesMat ~
almtmatg.DesMar almtmatg.UndStk 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH almtmatg WHERE ~{&KEY-PHRASE} ~
      AND almtmatg.CodCia = s-codcia ~
 AND almtmatg.FlgAut = "P" NO-LOCK, ~
      EACH Almtfami OF almtmatg ~
      WHERE {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH almtmatg WHERE ~{&KEY-PHRASE} ~
      AND almtmatg.CodCia = s-codcia ~
 AND almtmatg.FlgAut = "P" NO-LOCK, ~
      EACH Almtfami OF almtmatg ~
      WHERE {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table almtmatg Almtfami
&Scoped-define FIRST-TABLE-IN-QUERY-br_table almtmatg
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almtfami


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
      almtmatg, 
      Almtfami SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      almtmatg.codmat FORMAT "X(6)":U
      almtmatg.DesMat FORMAT "X(60)":U
      almtmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      almtmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85 BY 6.69
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
         HEIGHT             = 6.81
         WIDTH              = 98.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.almtmatg,INTEGRAL.Almtfami OF INTEGRAL.almtmatg"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "INTEGRAL.almtmatg.CodCia = s-codcia
 AND INTEGRAL.almtmatg.FlgAut = ""P"""
     _Where[2]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.almtmatg.codmat
     _FldNameList[2]   > INTEGRAL.almtmatg.DesMat
"almtmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.almtmatg.DesMar
"almtmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.almtmatg.UndStk
"almtmatg.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    
    RUN Procesa-Handle IN lh_Handle ('almacenes').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

IF AVAILABLE almtmatg THEN DO:
    RUN Procesa-Handle IN lh_Handle ('almacenes').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Cissac B-table-Win 
PROCEDURE Actualiza-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 12/06/2015 Las tablas se han replicado en CONTINENTAL */
/* DEF VAR pProfile AS CHAR INIT 'cissac.pf' NO-UNDO.                               */
/*                                                                                  */
/* IF NOT CONNECTED("cissac") THEN DO:                                              */
/*     CONNECT -db integral -ld cissac -H 192.168.100.202 -N TCP -S 65030 NO-ERROR. */
/*     IF ERROR-STATUS:ERROR THEN DO:                                               */
/*         MESSAGE 'NO se pudo conectar la base de CISSAC' SKIP                     */
/*             'Comunicar al administrador de base de datos'                        */
/*             VIEW-AS ALERT-BOX ERROR.                                             */
/*         RETURN ERROR.                                                            */
/*     END.                                                                         */
/* END.                                                                             */
/* IF NOT CONNECTED("cissac") THEN DO:                                              */
/*     MESSAGE 'NO se pudo migrar la información a CISSAC' SKIP                     */
/*         'Avisar a Sistemas'                                                      */
/*         VIEW-AS ALERT-BOX WARNING.                                               */
/*     RETURN ERROR.                                                                */
/* END.                                                                             */

RUN alm/p-catcontiacissac (ROWID(Almmmatg)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ACTUALIZA-MAT-x-ALM B-table-Win 
PROCEDURE ACTUALIZA-MAT-x-ALM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = Almmmatg.codcia AND Almacen.TdoArt
    TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:

    /* CONSISTENCIA POR PRODUCTO Y ALMACEN */
    IF Almmmatg.TpoMrg <> '' AND Almacen.Campo-c[2] <> '' THEN DO:
        IF Almmmatg.TpoMrg <> Almacen.Campo-c[2] THEN NEXT.
    END.
    /* *********************************** */
    FIND Almmmate WHERE Almmmate.CodCia = Almmmatg.codcia AND 
         Almmmate.CodAlm = Almacen.CodAlm AND 
         Almmmate.CodMat = Almmmatg.CodMat NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
       CREATE Almmmate.
       ASSIGN Almmmate.CodCia = Almmmatg.codcia
              Almmmate.CodAlm = Almacen.CodAlm
              Almmmate.CodMat = Almmmatg.CodMat.
    END.
    ASSIGN Almmmate.DesMat = Almmmatg.DesMat
           Almmmate.FacEqu = Almmmatg.FacEqu
           Almmmate.UndVta = Almmmatg.UndStk
           Almmmate.CodMar = Almmmatg.CodMar.
    FIND FIRST almautmv WHERE 
         almautmv.CodCia = Almmmatg.codcia AND
         almautmv.CodFam = Almmmatg.codfam AND
         almautmv.CodMar = Almmmatg.codMar AND
         almautmv.Almsol = Almmmate.CodAlm NO-LOCK NO-ERROR.
    IF AVAILABLE almautmv THEN 
       ASSIGN Almmmate.AlmDes = almautmv.Almdes
              Almmmate.CodUbi = almautmv.CodUbi.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar B-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  DEF VAR x-NroCor AS INT NO-UNDO.
  DEF VAR x-OrdMat AS INTEGER NO-UNDO.
  DEF VAR C-ALM    AS CHAR NO-UNDO.

  DEFINE VAR lCodMat AS CHAR.
  
  DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} 
      TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
      IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
          FIND CURRENT Almtmatg EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE Almtmatg THEN NEXT.
          /* RHC 24-09-2013 ACTUALIZAMOS TIPO DE CAMBIO */
          FIND Almtfami OF Almtmatg NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almtfami OR (Almtfami.tpocmb <= 0 AND almtfami.swcomercial = YES) THEN DO:
              MESSAGE "La familia no tiene ingresado el tipo de Cambio " SKIP 
                         "Debe ingresarlo para el COSTEO".
              NEXT.
          END.
              
          /* ************************************************************ */
          /* Capturamos Correlativo */
          FIND LAST MATG WHERE MATG.CodCia = S-CODCIA NO-LOCK NO-ERROR.
          IF AVAILABLE MATG THEN x-NroCor = INTEGER(MATG.codmat) + 1.
          ELSE x-NroCor = 1.
          FIND LAST MATG WHERE MATG.Codcia = S-CODCIA 
              AND  MATG.CodFam = Almtmatg.Codfam
              USE-INDEX Matg08 NO-LOCK NO-ERROR.
          IF AVAILABLE MATG 
          THEN x-ordmat = MATG.Orden + 3.
          ELSE x-ordmat = 1.
          CREATE Almmmatg.
          BUFFER-COPY Almtmatg 
              TO Almmmatg
              ASSIGN
                  Almmmatg.codmat = STRING(x-NroCor,"999999")
                  Almmmatg.orden  = x-ordmat
                  Almmmatg.ordlis = x-ordmat
                  Almmmatg.tpoart = 'A'     /* Activo */
                  Almmmatg.FchIng = TODAY
                  Almmmatg.FchAct = TODAY
                  Almmmatg.Libre_C05 = s-user-id + "|" + STRING(TODAY, '99/99/9999').
          /* Actualizamos las SUBCATEGORIAS */
          FOR EACH webscmatt NO-LOCK WHERE webscmatt.CodCia = s-codcia
              AND webscmatt.codmat = Almtmatg.codmat:
              CREATE webscmatg.
              ASSIGN
                  webscmatg.CodCia = webscmatt.CodCia 
                  webscmatg.codmat = Almmmatg.codmat
                  webscmatg.Subcategoria = webscmatt.Subcategoria.
          END.
          /* Actualizamos la lista de Almacenes */ 
          /*ALM = TRIM(Almmmatg.almacenes).*/
          C-ALM = ''.
          FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = Almmmatg.codcia AND Almacen.TdoArt:
              /* CONSISTENCIA POR PRODUCTO Y ALMACEN */
              IF Almmmatg.TpoMrg <> '' AND Almacen.Campo-c[2] <> '' THEN DO:
                  IF Almmmatg.TpoMrg <> Almacen.Campo-c[2] THEN NEXT.
              END.
              /* *********************************** */
              IF C-ALM = "" THEN C-ALM = TRIM(Almacen.CodAlm).
              IF LOOKUP(TRIM(Almacen.CodAlm),C-ALM) = 0 THEN C-ALM = C-ALM + "," + TRIM(Almacen.CodAlm).
          END.
          ASSIGN 
              Almmmatg.almacenes = C-ALM.
          /* RHC 24-09-2013 ACTUALIZAMOS MONEDA DE VENTA Y TIPO DE CAMBIO */
          FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
          IF AVAILABLE Almtfami THEN DO:
             ASSIGN
                 Almmmatg.tpocmb = Almtfami.tpocmb
                 Almmmatg.catconta[1] = Almtfami.Libre_c01.
          END.
          IF NOT (Almmmatg.MonVta = 1 OR Almmmatg.MonVta = 2)
              THEN Almmmatg.MonVta = 1.
          /* ************************************************************ */
          /* RHC 27.11.09 REPOSICIONES AUTOMATICAS */
          FIND Vtapmatg WHERE Vtapmatg.codcia = s-codcia
              AND Vtapmatg.codmat = 'T' + Almtmatg.codmat
              EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE Vtapmatg THEN DO:
              ASSIGN
                  Vtapmatg.codmat = Almmmatg.codmat
                  NO-ERROR.
          END.

          RUN ACTUALIZA-MAT-x-ALM NO-ERROR.  
          IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.

          /* Ic - 22May2015  -  Minimos */
          lCodMat = "aprobacion" + almmmatg.codmat.
          RUN Procesa-Handle IN lh_Handle (lCodmat).
          IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.

          /* ACTUALIZA CISSAC */
          RUN Actualiza-Cissac NO-ERROR.
          IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.

          /* Actualizamos FLAGS */
          ASSIGN
              Almtmatg.FlgAut = 'A'
              Almtmatg.FchAut = TODAY
              Almtmatg.UsrAut = s-user-id
              Almtmatg.CodNew = Almmmatg.CodMat.
      END.
  END.
  IF AVAILABLE(Vtapmatg) THEN RELEASE Vtapmatg.
  IF AVAILABLE(Almmmatg) THEN RELEASE Almmmatg.
  IF AVAILABLE(Almtmatg) THEN RELEASE Almtmatg.
  IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.
  IF AVAILABLE(webscmatg) THEN RELEASE webscmatg.

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Filtro-Comerciales B-table-Win 
PROCEDURE Filtro-Comerciales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pFiltro AS INT.

CASE pFiltro:
    WHEN 1 THEN lComerciales = YES.
    WHEN 2 THEN lComerciales = NO.
    WHEN 0 THEN lComerciales = ?.
END CASE.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'VALUE-CHANGED':U TO {&BROWSE-NAME} IN FRAME {&FRAME-NAME}.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar B-table-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    RECHAZADO:
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
            FIND CURRENT Almtmatg EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Almtmatg THEN NEXT RECHAZADO.
            /* Actualizamos FLAGS */
            ASSIGN
                Almtmatg.FlgAut = 'R'
                Almtmatg.FchAut = TODAY
                Almtmatg.UsrAut = s-user-id.
            RELEASE Almtmatg.
        END.
    END.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
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
  {src/adm/template/snd-list.i "almtmatg"}
  {src/adm/template/snd-list.i "Almtfami"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue_Linea B-table-Win 
PROCEDURE ue_Linea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pch_CodFam AS CHAR.

IF NOT AVAILABLE Almtmatg THEN RETURN.
pch_CodFam = almtmatg.codfam.

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

