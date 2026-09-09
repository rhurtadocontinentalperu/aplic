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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE SHARED VAR x-tipo AS CHAR.

DEFINE VAR x-qletras AS INT.

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
&Scoped-define INTERNAL-TABLES ccbmovlet gn-clie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ccbmovlet.codclie gn-clie.NomCli ~
ccbmovlet.fchmov ccbmovlet.qletras 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ccbmovlet.codclie ~
ccbmovlet.fchmov ccbmovlet.qletras 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ccbmovlet
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ccbmovlet
&Scoped-define QUERY-STRING-br_table FOR EACH ccbmovlet WHERE ~{&KEY-PHRASE} ~
      AND ccbmovlet.codcia = s-codcia and  ~
ccbmovlet.tpomov = x-tipo NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.codcia = 0 and  ~
INTEGRAL.gn-clie.CodCli =  ccbmovlet.codclie NO-LOCK ~
    BY ccbmovlet.fchmov
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ccbmovlet WHERE ~{&KEY-PHRASE} ~
      AND ccbmovlet.codcia = s-codcia and  ~
ccbmovlet.tpomov = x-tipo NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.codcia = 0 and  ~
INTEGRAL.gn-clie.CodCli =  ccbmovlet.codclie NO-LOCK ~
    BY ccbmovlet.fchmov.
&Scoped-define TABLES-IN-QUERY-br_table ccbmovlet gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ccbmovlet
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie


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
      ccbmovlet, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ccbmovlet.codclie FORMAT "x(11)":U WIDTH 13.43
      gn-clie.NomCli FORMAT "x(250)":U WIDTH 52.86
      ccbmovlet.fchmov FORMAT "99/99/9999":U
      ccbmovlet.qletras FORMAT "->,>>>,>>9":U
  ENABLE
      ccbmovlet.codclie
      ccbmovlet.fchmov
      ccbmovlet.qletras
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 91 BY 17.69
         FONT 4.


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
         HEIGHT             = 17.88
         WIDTH              = 91.14.
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
     _TblList          = "INTEGRAL.ccbmovlet,INTEGRAL.gn-clie WHERE INTEGRAL.ccbmovlet ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.ccbmovlet.fchmov|yes"
     _Where[1]         = "ccbmovlet.codcia = s-codcia and 
ccbmovlet.tpomov = x-tipo"
     _JoinCode[2]      = "INTEGRAL.gn-clie.codcia = 0 and 
INTEGRAL.gn-clie.CodCli =  INTEGRAL.ccbmovlet.codclie"
     _FldNameList[1]   > INTEGRAL.ccbmovlet.codclie
"ccbmovlet.codclie" ? ? "character" ? ? ? ? ? ? yes ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "52.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.ccbmovlet.fchmov
"ccbmovlet.fchmov" ? ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.ccbmovlet.qletras
"ccbmovlet.qletras" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccbmovlet.fchmov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccbmovlet.fchmov br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF ccbmovlet.fchmov IN BROWSE br_table /* Fch. Mov */
DO:
    IF ccbmovlet.fchmov:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN
  ccbmovlet.fchmov:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(TODAY,"99/99/9999").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'return':U OF ccbmovlet.codclie, ccbmovlet.fchmov, ccbmovlet.qletras
DO:
    APPLY 'TAB'.
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
  /*
  ccbmovlet.codclie = "Ingrese Cli".
  ccbmovlet.fchmov = TODAY.
  ccbmovlet.qletras = 0.
  */
 

  x-qletras = 0.


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

  DEFINE VAR y-signo AS INT INIT 1.

  ASSIGN ccbmovlet.codcia = s-codcia
            ccbmovlet.tpomov = x-Tipo.
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "NO" THEN DO:
      /* Esta MODIFICANDO - Valor anterior*/
      /* R : Recepcion resta, M : Malogradas suma */
      IF x-Tipo = "R" THEN y-signo = -1.
      IF x-Tipo = "M" THEN y-signo = 1.
      ASSIGN ccbmovlet.fchmod = NOW
              ccbmovlet.usrmod = s-user-id.

      /* Stock */
      x-qletras = x-qletras * y-signo.
      RUN ccb/recepcion-letras-anticipadas-stock.r(INPUT ccbmovlet.codclie, INPUT x-qletras) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE 'NO se pudo actualizar los STOCKS de las letras' .
          UNDO, RETURN 'ADM-ERROR'.
      END.

  END.
  
    /* X el nuevo valor */
    /* R : Recepcion Suma, M : Malogradas Resta */
    IF x-Tipo = "R" THEN y-signo = 1.
    IF x-Tipo = "M" THEN y-signo = -1.
    
    ASSIGN ccbmovlet.fchcrea = NOW
          ccbmovlet.usrcrea = s-user-id.

  

  /* Stock */
  RUN ccb/recepcion-letras-anticipadas-stock.r(INPUT ccbmovlet.codclie, INPUT ccbmovlet.qletras * y-signo) NO-ERROR.

  IF ERROR-STATUS:ERROR THEN DO:
      UNDO, RETURN 'ADM-ERROR'.
      MESSAGE 'NO se pudo actualizar los STOCKS de las letras' .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE ccbmovlet THEN RETURN "ADM-ERROR".  

  DEFINE VAR x-clie AS CHAR.
  DEFINE VAR x-qlet AS INT.

  DEFINE VAR y-signo AS INT.

  y-signo = -1.
  IF x-tipo = 'M' THEN y-signo = 1.   /* Malogradas/Deterioradas cuando elimina incrementa stock */

  x-clie = ccbmovlet.codclie.
  x-qlet = ccbmovlet.qletras * y-signo.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN ccb/recepcion-letras-anticipadas-stock.r(INPUT x-clie, INPUT x-qlet).

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
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "NO" THEN DO:
   /* Esta MODIFICANDO */
   {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codclie:READ-ONLY 
       IN BROWSE {&BROWSE-NAME}= YES.   
   x-qletras = ccbmovlet.qletras.
  END.
  ELSE DO:
        /* Esta ADICIONADO */
   {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codclie:READ-ONLY 
       IN BROWSE {&BROWSE-NAME}= NO.
    x-qletras = 0.
    
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
  {src/adm/template/snd-list.i "ccbmovlet"}
  {src/adm/template/snd-list.i "gn-clie"}

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

DEFINE VAR x-codclie AS CHAR.
DEFINE VAR x-fchmov AS CHAR.
DEFINE VAR x-qty AS CHAR.

DEFINE VAR y-fchmov AS DATE.
DEFINE VAR y-qty AS DEC.

DEFINE VAR x-rowid AS ROWID.

DEFINE BUFFER x-ccbmovlet FOR ccbmovlet.
DEFINE BUFFER x-gn-clie FOR gn-clie.

x-codclie = ccbmovlet.codclie:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
x-fchmov = ccbmovlet.fchmov:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
x-qty = ccbmovlet.qletras:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

IF TRUE <> (x-codclie > "") THEN DO:
    MESSAGE 'Debe ingresar codigo de CLIENTE' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO ccbmovlet.codclie IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.
IF TRUE <> (x-fchmov > "") THEN DO:
    MESSAGE 'Debe ingresar fecha movimiento' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO ccbmovlet.fchmov IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.
IF TRUE <> (x-qty > "") THEN DO:
    MESSAGE 'Debe ingresar Cantidad' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO ccbmovlet.qletras IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.

/* -------------------------------------------------------------------------- */
y-qty = DECIMAL(x-qty).
y-fchmov = DATE(x-fchmov) NO-ERROR.

FIND FIRST x-gn-clie WHERE x-gn-clie.codcia = 0 AND 
                        x-gn-clie.codcli = x-codclie NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-gn-clie THEN DO:
    MESSAGE 'Codigo de CLIENTE no existe' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO ccbmovlet.codclie IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.

IF (TODAY - y-fchmov) < 0 OR (TODAY - y-fchmov) > 15  THEN DO:
    MESSAGE 'Fecha movimiento no puede ser mayor de 15 dias de antiguedad' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO ccbmovlet.fchmov IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.

IF y-qty < 1  THEN DO:
    MESSAGE 'Cantidad debe ser mayor a CERO' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO ccbmovlet.qletras IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.

x-rowid = ROWID(ccbmovlet).

FIND FIRST x-ccbmovlet WHERE x-ccbmovlet.codcia = s-codcia AND 
                                x-ccbmovlet.codclie = x-codclie AND
                                x-ccbmovlet.fchmov = y-fchmov AND
                                x-ccbmovlet.tpomov = x-tipo
                                NO-LOCK NO-ERROR.
IF AVAILABLE x-ccbmovlet THEN DO:
    IF x-rowid <> ROWID(x-ccbmovlet) THEN DO:
        MESSAGE 'Registro ya existe para ese cliente en la fecha indicada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO ccbmovlet.fchmov IN BROWSE {&BROWSE-NAME}.
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ccbmovlet THEN RETURN "ADM-ERROR".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

