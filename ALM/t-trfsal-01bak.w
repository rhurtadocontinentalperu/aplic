&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE Almdmov.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-tipmov AS CHAR.
DEF SHARED VAR s-Reposicion AS LOG.
DEF SHARED VAR s-CodRef AS CHAR.
DEF SHARED VAR s-AlmDes LIKE Almcmov.almdes.

DEF NEW SHARED VAR s-CodMat AS CHAR.

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
&Scoped-define INTERNAL-TABLES ITEM Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ITEM.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.UndBas ITEM.CanDes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM.codmat ITEM.CanDes 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table ITEM Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje 

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
DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     LABEL "Importando" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ITEM, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ITEM.codmat COLUMN-LABEL "<Codigo>" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(4)":U
      ITEM.CanDes FORMAT "ZZZ,ZZ9.9999":U
  ENABLE
      ITEM.codmat
      ITEM.CanDes HELP "F8: ver stocks"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85 BY 9.96
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Mensaje AT ROW 11.23 COL 9 COLON-ALIGNED WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL Almdmov
   END-TABLES.
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
         HEIGHT             = 13.19
         WIDTH              = 85.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

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

/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ITEM,INTEGRAL.Almmmatg OF Temp-Tables.ITEM"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.ITEM.codmat
"ITEM.codmat" "<Codigo>" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ITEM.CanDes
"ITEM.CanDes" ? "ZZZ,ZZ9.9999" "decimal" ? ? ? ? ? ? yes "F8: ver stocks" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

/*   RUN GET-ATTRIBUTE('adm-new-record').                                                         */
/*   IF RETURN-VALUE = 'yes' THEN   ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name} = '015849'. */

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


&Scoped-define SELF-NAME ITEM.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.codmat IN BROWSE br_table /* <Codigo> */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '999999')
        NO-ERROR.
    IF s-Reposicion = YES AND LOOKUP(SELF:SCREEN-VALUE, '015849,033278') = 0 THEN DO:
        MESSAGE 'Solo están permitidos los siguientes códigos: 015849 033278' SKIP
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "Material NO registrado en el catálogo" VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = ''.
       RETURN NO-APPLY.   
    END.
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND  Almmmate.CodAlm = S-CODALM 
        AND  Almmmate.CodMat = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
       MESSAGE "Material no asignado al Almacen" s-codalm VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = ''.
       RETURN NO-APPLY.   
    END.
    DISPLAY
        Almmmatg.DesMar Almmmatg.DesMat Almmmatg.UndBas
        WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.CanDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CanDes br_table _BROWSE-COLUMN B-table-Win
ON F8 OF ITEM.CanDes IN BROWSE br_table /* Cantidad */
DO:
    DEF VAR l-ok AS LOG NO-UNDO.
    RUN gn/c-uniofi ('Consulta de saldos', ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},OUTPUT l-ok).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'return':U OF ITEM.codmat
DO:
    APPLY 'tab':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-desde-Excel B-table-Win 
PROCEDURE Importar-desde-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF s-AlmDes = '' THEN DO:
      MESSAGE 'Debe ingresar primero al ALMACEN DESTINO'
          VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.


DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

/* SOLICITAR EL ARCHIVO DE EXCEL */
DEF VAR pFileName AS CHAR NO-UNDO.
DEF VAR pLogical  AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE pFileName
    FILTERS "*.xls" "*.xls"
    RETURN-TO-START-DIR
    TITLE "Seleccione el archivo Excel"
    UPDATE pLogical.
IF plogical = NO THEN RETURN.
IF SEARCH(pFileName) = ? THEN DO:
    MESSAGE 'Archivo no existe' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Datos a recuperar */
DEFINE VARIABLE cCampo1 AS CHAR NO-UNDO.
DEFINE VARIABLE cCampo2 AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iNumLinea AS INTEGER NO-UNDO.
DEFINE VARIABLE iError AS INTEGER NO-UNDO.
DEFINE VARIABLE cError AS CHARACTER NO-UNDO.
DEFINE VARIABLE lProcesar AS LOGICAL NO-UNDO.

iError = 1.
cError = "Error indeterminado, no se ha importado".
DO TRANSACTION ON ERROR UNDO, LEAVE:
    CREATE "Excel.Application" chExcelApplication.

    chWorkbook = chExcelApplication:Workbooks:OPEN(pFileName) NO-ERROR.
    /* Seleccionamos la 1ra. hoja solamente */
    chWorkSheet = chExcelApplication:Sheets:ITEM(1) NO-ERROR.
    /* Comprobamos que las hojas no esten en blanco */
    IF (chWorkSheet:Cells(1,1):VALUE = ? OR chWorkSheet:Cells(1,1):VALUE = '') THEN DO:
        iError = 2.
        cError = "El Excel está en blanco".
        UNDO, LEAVE.
    END.
    iNumLinea = 2.
    lProcesar = TRUE.
    REPEAT WHILE lProcesar:
        ASSIGN
            cCampo1 = STRING (chWorkSheet:Cells(iNumLinea,1):VALUE, '999999')
            cCampo2 = DECIMAL (chWorkSheet:Cells(iNumLinea,2):VALUE) 
            NO-ERROR.
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cCampo1 + ' ' + string(cCampo2).
        IF cCampo1 = ? OR cCampo1 = "" THEN DO:
            lProcesar = FALSE.
            iNumLinea = iNumLinea - 2.
        END.
        ELSE DO:
            /* PROCESAR INFORMACION */
            FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
                AND Almmmatg.codmat = cCampo1
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmatg THEN DO:
                cError = "Material " + cCampo1 + " NO registrado en el catálogo".
                UNDO, LEAVE.
            END.
            FIND almmmate WHERE almmmate.codcia = s-codcia
                AND Almmmate.codalm = s-almdes
                AND almmmate.codmat = cCampo1
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmate THEN DO:
                cError = 'Código ' + cCampo1 + ' NO asignado al almacén ' + s-almdes.
                UNDO, LEAVE.
            END.
            FIND almmmate WHERE almmmate.codcia = s-codcia
                AND Almmmate.codalm = s-codalm
                AND almmmate.codmat = cCampo1
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmate THEN DO:
                cError = 'Código ' + cCampo1 + ' NO asignado al almacén ' +  s-codalm.
                UNDO, LEAVE.
            END.
            FIND FIRST ITEM WHERE ITEM.codmat = cCampo1 NO-LOCK NO-ERROR.
            IF AVAILABLE ITEM THEN DO:
                cError = "Material " + cCampo1 + " YA registrado".
                UNDO, LEAVE.
            END.
            CREATE ITEM.
            ASSIGN 
                ITEM.CodMat = cCampo1
                ITEM.CanDes = cCampo2
                ITEM.Factor = 1
                ITEM.CodCia = S-CODCIA 
                ITEM.CodAlm = S-CODALM
                ITEM.TipMov = s-TipMov
                ITEM.CodUnd = Almmmatg.UndBas
                NO-ERROR.

            /* Aumentar la linea */
            iNumLinea = iNumLinea + 1.
        END.
    END.
    chWorkBook:CLOSE(FALSE,,) NO-ERROR. /* cierra archivo sin grabar cambios */
    chExcelApplication:QUIT NO-ERROR.
    RELEASE OBJECT chWorkSheet no-error.
    RELEASE OBJECT chWorkBook no-error.
    RELEASE OBJECT chExcelApplication no-error.
    chExcelApplication = ?.
    chWorkBook = ?.
    chWorkSheet = ?.
    /* Todo Correcto */
    iError = 0.
    cError = "Lineas Procesadas: " + STRING(iNumLinea).
END.
MESSAGE cError. 
RUN dispatch IN THIS-PROCEDURE ('open-query').


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
/*   IF s-Reposicion = YES THEN DO:     */
/*       MESSAGE 'Acceso Denegado'      */
/*           VIEW-AS ALERT-BOX WARNING. */
/*       RETURN "ADM-ERROR".            */
/*   END.                               */
  IF s-AlmDes = '' THEN DO:
      MESSAGE 'Debe ingresar primero al ALMACEN DESTINO'
          VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.

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
      ITEM.Factor = 1
      ITEM.CodCia = S-CODCIA 
      ITEM.CodAlm = S-CODALM
      ITEM.TipMov = s-TipMov
      ITEM.CodUnd = Almmmatg.UndBas:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   IF s-Reposicion = YES                                      */
/*   THEN ITEM.codmat:READ-ONLY IN BROWSE {&browse-name} = YES. */
/*   ELSE ITEM.codmat:READ-ONLY IN BROWSE {&browse-name} = NO.  */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'yes' 
  THEN DO:
      ITEM.codmat:READ-ONLY IN BROWSE {&browse-name} = NO.
  END.
  ELSE DO:
      ITEM.codmat:READ-ONLY IN BROWSE {&browse-name} = YES.
  END.

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
  {src/adm/template/snd-list.i "ITEM"}
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
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pComprometido AS DEC.
DEF VAR x-Stock-Disponible AS DEC NO-UNDO.

FIND almmmate WHERE almmmate.codcia = s-codcia
    AND Almmmate.codalm = s-almdes
    AND almmmate.codmat = ITEM.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
    MESSAGE 'Código NO asignado al almacén' s-almdes VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
FIND almmmate WHERE almmmate.codcia = s-codcia
    AND Almmmate.codalm = s-codalm
    AND almmmate.codmat = ITEM.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
    MESSAGE 'Código NO asignado al almacén' s-codalm VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
RUN gn/stock-comprometido (Almmmate.codmat, Almmmate.codalm, OUTPUT pComprometido).
IF s-Reposicion = NO THEN DO:
    /* CONSISTENCIA NORMAL */
    IF DECIMAL(ITEM.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > (Almmmate.stkact - pComprometido)
        THEN DO:
        MESSAGE 'NO se puede transferir mas de' (Almmmate.stkact - pComprometido)
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
END.
ELSE DO:
    CASE s-CodRef:
        WHEN 'R/A' THEN DO:
            pComprometido = pComprometido - ITEM.StkAct.
            x-Stock-Disponible = MINIMUM( (Almmmate.stkact - pComprometido), ITEM.StkAct ).
            IF DECIMAL(ITEM.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > x-Stock-Disponible
                THEN DO:
                MESSAGE 'NO se puede transferir mas de' x-Stock-Disponible
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
        END.
        WHEN 'REP' THEN DO:
            x-Stock-Disponible = MINIMUM( (Almmmate.stkact - pComprometido), ITEM.StkAct ).
            IF DECIMAL(ITEM.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > x-Stock-Disponible
                THEN DO:
                MESSAGE 'NO se puede transferir mas de' x-Stock-Disponible
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
        END.
    END CASE.
END.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

