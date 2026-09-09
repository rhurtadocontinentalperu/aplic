&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

DEFINE SHARED VAR s-codcia  AS INT.
DEFINE SHARED VAR s-codalm  AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-Parametro AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE t-dinv LIKE AlmDInv
    FIELDS tNroPag AS INT
    FIELDS tNroSec AS INT.

DEFINE BUFFER b-dinv FOR almdinv.
DEFINE VAR s-registro-activo AS LOG INIT NO NO-UNDO.

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
&Scoped-define INTERNAL-TABLES AlmDInv Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table AlmDInv.CodUbi AlmDInv.codmat ~
Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndBas AlmDInv.NroPagina ~
AlmDInv.NroSecuencia 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table AlmDInv.CodUbi ~
AlmDInv.codmat 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table AlmDInv
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table AlmDInv
&Scoped-define QUERY-STRING-br_table FOR EACH AlmDInv WHERE ~{&KEY-PHRASE} ~
      AND AlmDInv.Codcia = s-codcia ~
 AND AlmDInv.CodAlm = s-Parametro ~
and AlmDinv.NroPagina >= 8000 NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = AlmDInv.Codcia ~
  AND Almmmatg.codmat = AlmDInv.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH AlmDInv WHERE ~{&KEY-PHRASE} ~
      AND AlmDInv.Codcia = s-codcia ~
 AND AlmDInv.CodAlm = s-Parametro ~
and AlmDinv.NroPagina >= 8000 NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = AlmDInv.Codcia ~
  AND Almmmatg.codmat = AlmDInv.codmat NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table AlmDInv Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table AlmDInv
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


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
      AlmDInv, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      AlmDInv.CodUbi FORMAT "x(6)":U
      AlmDInv.codmat FORMAT "xxxxxx":U
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(4)":U
      AlmDInv.NroPagina FORMAT "->,>>>,>>9":U
      AlmDInv.NroSecuencia FORMAT "->,>>>,>>9":U
  ENABLE
      AlmDInv.CodUbi
      AlmDInv.codmat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85 BY 15.77
         FONT 4
         TITLE "Ingreso Manual de Articulos por Ubicación".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


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
         HEIGHT             = 15.92
         WIDTH              = 86.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.AlmDInv,INTEGRAL.Almmmatg WHERE INTEGRAL.AlmDInv ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ","
     _Where[1]         = "AlmDInv.Codcia = s-codcia
 AND AlmDInv.CodAlm = s-Parametro
and AlmDinv.NroPagina >= 8000"
     _JoinCode[2]      = "Almmmatg.CodCia = AlmDInv.Codcia
  AND Almmmatg.codmat = AlmDInv.codmat"
     _FldNameList[1]   > INTEGRAL.AlmDInv.CodUbi
"AlmDInv.CodUbi" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.AlmDInv.codmat
"AlmDInv.codmat" ? "xxxxxx" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.AlmDInv.NroPagina
     _FldNameList[7]   = INTEGRAL.AlmDInv.NroSecuencia
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Ingreso Manual de Articulos por Ubicación */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Ingreso Manual de Articulos por Ubicación */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Ingreso Manual de Articulos por Ubicación */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME AlmDInv.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AlmDInv.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF AlmDInv.codmat IN BROWSE br_table /* Codigo Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN .
    /*IF s-registro-activo = NO THEN RETURN.*/
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iUltPag AS INTEGER     NO-UNDO INIT 8000.
  DEFINE VARIABLE iUltSec AS INTEGER     NO-UNDO INIT 1.
  
  /* Code placed here will execute PRIOR to standard behavior. */
    
  FIND LAST almdinv WHERE almdinv.codcia = s-codcia
      AND almdinv.codalm = s-parametro /*"11x"*/
      AND almdinv.nropag = 8000 /*
      AND almdinv.nropag < 9000*/ NO-LOCK NO-ERROR.
  IF AVAIL almdinv THEN 
      ASSIGN 
        iUltPag = almdinv.nropag
        iUltSec = almdinv.nrosec + 1.
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    
  ASSIGN 
      AlmDInv.Codcia     = s-codcia
      AlmDInv.CodAlm     = s-parametro /*"11x"*/
      AlmDInv.NomCia     = 'CONTISTAND'
      AlmDInv.NroPagina  = iUltPag
      almdinv.nrosec     = iUltSec
      AlmDInv.QtyFisico  = 0.

  /*Crea Cabecera*/
  FIND FIRST almcinv WHERE almcinv.codcia = s-codcia
      AND almcinv.codalm = s-parametro  /*"11x" */
      AND almcinv.nropag = 8000
      AND almcinv.nomcia = 'CONTISTAND' EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAIL almcinv THEN DO:
      CREATE almcinv.
      ASSIGN 
          AlmCInv.Codcia     = s-codcia
          AlmCInv.CodAlm     = s-parametro /*"11x"*/
          AlmCInv.NomCia     = 'CONTISTAND'
          AlmCInv.NroPagina  = 8000
          AlmCInv.CodUser    = s-user-id.
  END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Renumera-Secuencia B-table-Win 
PROCEDURE Renumera-Secuencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iNroPag AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNroSec AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE t-dinv.

    DO TRANSACTION ON ERROR UNDO, RETURN "adm-error":

        iNroSec = 1.    
        FIND LAST almcinv WHERE almcinv.codcia = s-codcia
            AND almcinv.codalm = s-parametro /*"11x"*/
            AND almcinv.nropagina > 8000
            AND almcinv.nropagina < 9000 NO-LOCK NO-ERROR.
        IF AVAIL almcinv THEN ASSIGN iNroPag = almcinv.nropag + 1.
        ELSE ASSIGN iNroPag = 8001.
        
        /*Nuevos Ingresos*/
        FOR EACH almdinv WHERE almdinv.codcia = s-codcia
            AND almdinv.codalm = s-parametro  /*"11x" */
            AND almdinv.nropagina = 8000 NO-LOCK,
            FIRST almmmatg WHERE almmmatg.codcia = almdinv.codcia
                AND almmmatg.codmat = almdinv.codmat NO-LOCK
            BREAK BY almdinv.codubi
                BY almdinv.codmat:

            CREATE t-dinv.
            BUFFER-COPY almdinv TO t-dinv
                ASSIGN 
                    t-dinv.NroPag = iNroPag
                    t-dinv.NroSec = iNroSec.

            iNroSec = iNroSec + 1.              /*Incrementa Secuencia*/

            IF LAST-OF(almdinv.codubi) OR iNroSec = 26 THEN DO:
                /*Crea Cabecera*/
                FIND FIRST almcinv WHERE almcinv.codcia = s-codcia
                    AND almcinv.codalm = s-parametro  /*"11x"*/
                    AND almcinv.nropag = iNroPag
                    AND almcinv.nomcia = 'CONTISTAND' EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL almcinv THEN DO:
                    CREATE almcinv.
                    ASSIGN 
                        AlmCInv.Codcia      = s-codcia
                        AlmCInv.CodAlm      = s-parametro  /*"11x"*/
                        AlmCInv.CodUser     = s-user-id
                        AlmCInv.NomCia      = "CONTISTAND"
                        AlmCInv.NroPagina   = iNroPag.
                END.
                ASSIGN 
                    iNroPag = iNroPag + 1
                    iNroSec = 1.                
            END.
        END.

        /*Borra Ingresos Manuales*/
        FOR EACH almdinv WHERE almdinv.codcia = s-codcia
            AND almdinv.codalm = s-parametro  /*"11x"*/
            AND almdinv.nropag = 8000 EXCLUSIVE-LOCK:
            DELETE almdinv.
        END.

        FOR EACH t-dinv NO-LOCK:
            CREATE almdinv.
            BUFFER-COPY t-dinv TO almdinv.
        END.

    END.   /*Do Transaction...*/

    MESSAGE "Renumeración Terminada"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    RUN adm-open-query.




/*DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':*/




/*     /*Actualiza Tabla*/                                       */
/*     FOR EACH t-dinv NO-LOCK:                                  */
/*         FIND FIRST AlmDInv OF t-dinv EXCLUSIVE-LOCK NO-ERROR. */
/*         IF AVAIL AlmDInv THEN                                 */
/*             ASSIGN                                            */
/*                 AlmDInv.NroPag = t-dinv.tNroPag               */
/*                 AlmDInv.NroSec = t-dinv.tNroSec.              */
/*     END.                                                      */

    
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
  {src/adm/template/snd-list.i "AlmDInv"}
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

    /*Verifica si el articulo existe en esa ubicacion*/
    FIND FIRST b-dinv WHERE b-dinv.codcia = s-codcia
        AND b-dinv.codalm = s-parametro  /*"11x"*/
        AND b-dinv.nomcia = "CONTISTAND"
        AND b-dinv.codubi = almdinv.codubi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
        AND b-dinv.codmat = almdinv.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
        NO-LOCK NO-ERROR.
    IF AVAIL b-dinv THEN DO:
        MESSAGE "Articulo ya se encuentra registrado" SKIP
                "         Para esta ubicación       " SKIP
                "         " + STRING(b-dinv.nropag) + "      "
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "entry" TO almdinv.codmat.
        RETURN "adm-error".
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
    /*RETURN "OK".*/
    RETURN "adm-error".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

