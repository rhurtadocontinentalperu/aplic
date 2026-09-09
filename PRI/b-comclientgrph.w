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

DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.


DEF VAR x-Log AS CHAR FORMAT 'x(40)' NO-UNDO.

DEF SHARED VAR lh_handle AS HANDLE.

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD Descrip AS CHAR FORMAT 'x(40)' LABEL 'Descripción del grupo'
    FIELD CodDiv AS CHAR FORMAT 'x(8)' LABEL 'División'
    FIELD DesDiv AS CHAR FORMAT 'x(40)' LABEL 'Descripción división'
    FIELD CodCli AS CHAR FORMAT 'x(15)' LABEL 'Cod. dliente'
    FIELD NomCli AS CHAR FORMAT 'x(80)' LABEL 'Nombre del cliente'
    FIELD Principal AS CHAR FORMAT 'x(2)' LABEL 'Principal?'
    .

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
&Scoped-define INTERNAL-TABLES pri_comclientgrp_h GN-DIVI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table pri_comclientgrp_h.Descrip ~
pri_comclientgrp_h.CodDiv GN-DIVI.DesDiv fLog() @ x-Log 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table pri_comclientgrp_h.Descrip ~
pri_comclientgrp_h.CodDiv 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table pri_comclientgrp_h
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table pri_comclientgrp_h
&Scoped-define QUERY-STRING-br_table FOR EACH pri_comclientgrp_h WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST GN-DIVI WHERE GN-DIVI.CodCia = s-codcia  ~
  AND GN-DIVI.CodDiv = pri_comclientgrp_h.CodDiv OUTER-JOIN NO-LOCK ~
    BY pri_comclientgrp_h.Descrip
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH pri_comclientgrp_h WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST GN-DIVI WHERE GN-DIVI.CodCia = s-codcia  ~
  AND GN-DIVI.CodDiv = pri_comclientgrp_h.CodDiv OUTER-JOIN NO-LOCK ~
    BY pri_comclientgrp_h.Descrip.
&Scoped-define TABLES-IN-QUERY-br_table pri_comclientgrp_h GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table pri_comclientgrp_h
&Scoped-define SECOND-TABLE-IN-QUERY-br_table GN-DIVI


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON_Texto 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Descrip 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLog B-table-Win 
FUNCTION fLog RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON_Down 
     IMAGE-UP FILE "img/caret-down-regular-24.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.08 TOOLTIP "Siguiente"
     BGCOLOR 15 FGCOLOR 0 .

DEFINE BUTTON BUTTON_Exit 
     IMAGE-UP FILE "img/exit-regular-24.bmp":U
     LABEL "Button 4" 
     SIZE 4 BY 1.08 TOOLTIP "Regresar".

DEFINE BUTTON BUTTON_Texto 
     IMAGE-UP FILE "img/list.ico":U
     IMAGE-INSENSITIVE FILE "img/block.ico":U
     LABEL "Exportar a Texto" 
     SIZE 5.72 BY 1.62.

DEFINE BUTTON BUTTON_Up 
     IMAGE-UP FILE "img/caret-up-regular-24.bmp":U
     LABEL "Button 3" 
     SIZE 4 BY 1.08 TOOLTIP "Previo"
     BGCOLOR 15 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_Descrip AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 35 BY 1.62
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      pri_comclientgrp_h, 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      pri_comclientgrp_h.Descrip COLUMN-LABEL "Descripción" FORMAT "x(80)":U
            WIDTH 40
      pri_comclientgrp_h.CodDiv FORMAT "x(8)":U WIDTH 9.86
      GN-DIVI.DesDiv COLUMN-LABEL "Nombre de la División" FORMAT "X(40)":U
      fLog() @ x-Log COLUMN-LABEL "LOG" WIDTH 40
  ENABLE
      pri_comclientgrp_h.Descrip
      pri_comclientgrp_h.CodDiv
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 126 BY 9.96
         FONT 4
         TITLE "GRUPO DE CLIENTES".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON_Texto AT ROW 1 COL 128 WIDGET-ID 20
     FILL-IN_Descrip AT ROW 9.62 COL 126 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BUTTON_Down AT ROW 9.62 COL 149 WIDGET-ID 14
     BUTTON_Up AT ROW 9.62 COL 153 WIDGET-ID 16
     BUTTON_Exit AT ROW 9.62 COL 157 WIDGET-ID 18
     RECT-2 AT ROW 9.35 COL 127 WIDGET-ID 12
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
         HEIGHT             = 12.69
         WIDTH              = 163.29.
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

/* SETTINGS FOR BUTTON BUTTON_Down IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON_Down:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON_Exit IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON_Exit:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON_Up IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON_Up:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_Descrip IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN_Descrip:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       RECT-2:HIDDEN IN FRAME F-Main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.pri_comclientgrp_h,INTEGRAL.GN-DIVI WHERE INTEGRAL.pri_comclientgrp_h ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST OUTER USED"
     _OrdList          = "INTEGRAL.pri_comclientgrp_h.Descrip|yes"
     _JoinCode[2]      = "GN-DIVI.CodCia = s-codcia 
  AND GN-DIVI.CodDiv = pri_comclientgrp_h.CodDiv"
     _FldNameList[1]   > INTEGRAL.pri_comclientgrp_h.Descrip
"pri_comclientgrp_h.Descrip" "Descripción" ? "character" ? ? ? ? ? ? yes ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.pri_comclientgrp_h.CodDiv
"pri_comclientgrp_h.CodDiv" ? ? "character" ? ? ? ? ? ? yes ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "Nombre de la División" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fLog() @ x-Log" "LOG" ? ? ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* GRUPO DE CLIENTES */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* GRUPO DE CLIENTES */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* GRUPO DE CLIENTES */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pri_comclientgrp_h.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pri_comclientgrp_h.CodDiv br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF pri_comclientgrp_h.CodDiv IN BROWSE br_table /* División */
DO:
  FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
      gn-divi.coddiv = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN DISPLAY gn-divi.desdiv @ GN-DIVI.DesDiv WITH BROWSE {&browse-name}.
                                                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pri_comclientgrp_h.CodDiv br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF pri_comclientgrp_h.CodDiv IN BROWSE br_table /* División */
OR F8 OF pri_comclientgrp_h.CodDiv DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-divis.w('Divisiones').
    IF output-var-1 <> ? THEN DO:
        SELF:SCREEN-VALUE = output-var-2.
        DISPLAY output-var-3 @ GN-DIVI.DesDiv WITH BROWSE {&browse-name}.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Down
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Down B-table-Win
ON CHOOSE OF BUTTON_Down IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN FILL-IN_Descrip.

  DEF BUFFER b-pri_comclientgrp_h FOR pri_comclientgrp_h.

  DEF VAR h-Query AS WIDGET-HANDLE.
  CREATE QUERY h-Query.
  h-Query:SET-BUFFERS(BUFFER b-pri_comclientgrp_h:HANDLE).
  h-Query:QUERY-PREPARE("FOR EACH b-pri_comclientgrp_h NO-LOCK BY b-pri_comclientgrp_h.Descrip").
  h-Query:QUERY-OPEN.
  h-Query:REPOSITION-TO-ROWID(ROWID(pri_comclientgrp_h)).
  h-Query:GET-NEXT().
  h-Query:GET-NEXT().
  DO WHILE h-Query:QUERY-OFF-END = NO:
      IF INDEX(b-pri_comclientgrp_h.Descrip, FILL-IN_Descrip) > 0 THEN DO:
          REPOSITION {&browse-name} TO ROWID ROWID(b-pri_comclientgrp_h) NO-ERROR.
          RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
          LEAVE.
      END.
      h-Query:GET-NEXT().
  END.
  h-Query:QUERY-CLOSE().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Exit B-table-Win
ON CHOOSE OF BUTTON_Exit IN FRAME F-Main /* Button 4 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      DISABLE BUTTON_Down BUTTON_Exit BUTTON_Up FILL-IN_Descrip .
      HIDE BUTTON_Down BUTTON_Exit BUTTON_Up FILL-IN_Descrip RECT-2.
      RUN Procesa-handle IN lh_handle ('Enable-Updv').
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto B-table-Win
ON CHOOSE OF BUTTON_Texto IN FRAME F-Main /* Exportar a Texto */
DO:
    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').

    EMPTY TEMP-TABLE Detalle.
    FOR EACH pri_comclientgrp_h NO-LOCK,
        FIRST gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pri_comclientgrp_h.CodDiv:
        IF NOT CAN-FIND(FIRST pri_comclientgrp_d WHERE pri_comclientgrp_d.IdGroup = pri_comclientgrp_h.IdGroup 
                        NO-LOCK)
            THEN DO:
            CREATE Detalle.
            ASSIGN
                Detalle.Descrip = pri_comclientgrp_h.Descrip
                Detalle.CodDiv  = pri_comclientgrp_h.CodDiv
                Detalle.DesDiv  = GN-DIVI.DesDiv.
        END.
        ELSE DO:
            FOR EACH pri_comclientgrp_d NO-LOCK WHERE pri_comclientgrp_d.IdGroup = pri_comclientgrp_h.IdGroup,
                FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia AND
                gn-clie.codcli = pri_comclientgrp_d.CodCli:
                CREATE Detalle.
                ASSIGN
                    Detalle.Descrip = pri_comclientgrp_h.Descrip
                    Detalle.CodDiv  = pri_comclientgrp_h.CodDiv
                    Detalle.DesDiv  = GN-DIVI.DesDiv
                    Detalle.CodCli  = pri_comclientgrp_d.CodCli 
                    Detalle.NomCli  = gn-clie.NomCli
                    Detalle.Principal = (IF pri_comclientgrp_d.Principal THEN "SI" ELSE "NO").
            END.
        END.
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Up B-table-Win
ON CHOOSE OF BUTTON_Up IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN FILL-IN_Descrip.

    DEF BUFFER b-pri_comclientgrp_h FOR pri_comclientgrp_h.

    DEF VAR h-Query AS WIDGET-HANDLE.
    CREATE QUERY h-Query.
    h-Query:SET-BUFFERS(BUFFER b-pri_comclientgrp_h:HANDLE).
    h-Query:QUERY-PREPARE("FOR EACH b-pri_comclientgrp_h NO-LOCK BY b-pri_comclientgrp_h.Descrip DESC").
    h-Query:QUERY-OPEN.
    h-Query:REPOSITION-TO-ROWID(ROWID(pri_comclientgrp_h)).
    h-Query:GET-NEXT().
    h-Query:GET-NEXT().
    DO WHILE h-Query:QUERY-OFF-END = NO:
        IF INDEX(b-pri_comclientgrp_h.Descrip, FILL-IN_Descrip) > 0 THEN DO:
            REPOSITION {&browse-name} TO ROWID ROWID(b-pri_comclientgrp_h) NO-ERROR.
            RUN dispatch IN THIS-PROCEDURE ('row-changed':U).
            LEAVE.
        END.
        h-Query:GET-NEXT().
    END.
    h-Query:QUERY-CLOSE().
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
  RUN Procesa-Handle IN lh_handle ('Disable_Detail').
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
      pri_comclientgrp_h.Descrip = CAPS(pri_comclientgrp_h.Descrip).
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  DEF VAR pEvento AS CHAR NO-UNDO.

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN pEvento = 'CREATE'.
  ELSE pEvento = 'UPDATE'.

  RUN lib/logtabla ('pri_comclientgrp_h',
                    STRING(pri_comclientgrp_h.idgroup) + "|" +
                    pri_comclientgrp_h.Descrip,
                    pEvento).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      ENABLE BUTTON_Down BUTTON_Exit BUTTON_Up FILL-IN_Descrip RECT-2.
      APPLY 'ENTRY':U TO FILL-IN_Descrip.
  END.
  RUN Procesa-handle IN lh_handle ('Disable-Updv').


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
  RUN Procesa-Handle IN lh_handle ('Enable_Detail').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record B-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      pri_comclientgrp_h.IdGroup = NEXT-VALUE(SEQ_COMCLIENTGRP).

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
  FOR EACH pri_comclientgrp_d EXCLUSIVE-LOCK WHERE pri_comclientgrp_d.IdGroup = pri_comclientgrp_h.IdGroup:
      RUN aplic/lib/logtabla.p ('pri_comclientgrp_d',
                                ( STRING(pri_comclientgrp_d.idgroup) + "|" +
                                  pri_comclientgrp_d.CodCli + "|" +
                                  STRING(pri_comclientgrp_d.Principal) ),
                                "DELETE").
      DELETE pri_comclientgrp_d.
  END.
  RUN aplic/lib/logtabla.p ('pri_comclientgrp_h',
                            ( STRING(pri_comclientgrp_h.idgroup) + "|" +
                              pri_comclientgrp_h.Descrip ),
                            "DELETE").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable_Detail').
  ENABLE BUTTON_Texto WITH FRAME {&FRAME-NAME}. 

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
  RUN Procesa-Handle IN lh_handle ('Disable_Detail').
  DISABLE BUTTON_Texto WITH FRAME {&FRAME-NAME}. 

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
  {src/adm/template/snd-list.i "pri_comclientgrp_h"}
  {src/adm/template/snd-list.i "GN-DIVI"}

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

DEF BUFFER b-pri_comclientgrp_h FOR pri_comclientgrp_h.

RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = "YES" THEN DO:
    IF CAN-FIND(b-pri_comclientgrp_h WHERE b-pri_comclientgrp_h.Descrip = pri_comclientgrp_h.Descrip:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK) THEN DO:
        MESSAGE 'Descripción del grupo ya registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO pri_comclientgrp_h.Descrip.
        RETURN 'ADM-ERROR'.
    END.
END.
ELSE DO:
    IF CAN-FIND(b-pri_comclientgrp_h WHERE b-pri_comclientgrp_h.Descrip = pri_comclientgrp_h.Descrip:SCREEN-VALUE IN BROWSE {&browse-name}
                AND ROWID(b-pri_comclientgrp_h) <> ROWID(pri_comclientgrp_h) NO-LOCK) 
        THEN DO:
        MESSAGE 'Descripción del grupo ya registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO pri_comclientgrp_h.Descrip.
        RETURN 'ADM-ERROR'.
    END.
END.
IF NOT CAN-FIND(FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                gn-divi.coddiv = pri_comclientgrp_h.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK)
    THEN DO:
    MESSAGE 'División NO registrada' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO pri_comclientgrp_h.CodDiv.
    RETURN 'ADM-ERROR'.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLog B-table-Win 
FUNCTION fLog RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF AVAILABLE pri_comclientgrp_h THEN DO:
      FIND LAST LogTabla USE-INDEX Llave01 WHERE LogTabla.codcia = s-codcia AND 
          LogTabla.tabla = 'pri_comclientgrp_h' AND
          LogTabla.ValorLlave BEGINS STRING(pri_comclientgrp_h.IdGroup) NO-LOCK NO-ERROR.
      IF AVAILABLE LogTabla THEN RETURN LogTabla.Usuario + " " +
          STRING(LogTabla.Dia) + " " +
          LogTabla.Hora + " " +
          LogTabla.Evento.
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

