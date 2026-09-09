&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-TABLA FOR VtaDctoProm.



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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR F-PRECIO AS DEC NO-UNDO.
DEF VAR F-Factor AS DEC NO-UNDO.    /* Factor aplicado a cada división y familia */
F-Factor = 1.

DEFINE SHARED VARIABLE s-CanalVenta AS CHAR.
DEFINE SHARED VARIABLE s-Divisiones AS CHAR.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE Almmmatg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almmmatg.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaDctoProm GN-DIVI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaDctoProm.CodDiv GN-DIVI.DesDiv ~
VtaDctoProm.FchIni VtaDctoProm.FchFin VtaDctoProm.Descuento ~
VtaDctoProm.Precio VtaDctoProm.Tipo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaDctoProm.CodDiv ~
VtaDctoProm.FchIni VtaDctoProm.FchFin VtaDctoProm.Descuento ~
VtaDctoProm.Precio 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaDctoProm
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaDctoProm
&Scoped-define QUERY-STRING-br_table FOR EACH VtaDctoProm OF Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND (VtaDctoProm.FchIni >= TODAY OR TODAY <= VtaDctoProm.FchFin) ~
 AND VtaDctoProm.FlgEst = "A" NO-LOCK, ~
      FIRST GN-DIVI OF VtaDctoProm ~
      WHERE /*LOOKUP(GN-DIVI.CanalVenta, s-CanalVenta) > 0 AND GN-DIVI.VentaMayorista = 1*/ ~
LOOKUP(GN-DIVI.CodDiv, s-Divisiones) > 0  NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaDctoProm OF Almmmatg WHERE ~{&KEY-PHRASE} ~
      AND (VtaDctoProm.FchIni >= TODAY OR TODAY <= VtaDctoProm.FchFin) ~
 AND VtaDctoProm.FlgEst = "A" NO-LOCK, ~
      FIRST GN-DIVI OF VtaDctoProm ~
      WHERE /*LOOKUP(GN-DIVI.CanalVenta, s-CanalVenta) > 0 AND GN-DIVI.VentaMayorista = 1*/ ~
LOOKUP(GN-DIVI.CodDiv, s-Divisiones) > 0  NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaDctoProm GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaDctoProm
&Scoped-define SECOND-TABLE-IN-QUERY-br_table GN-DIVI


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat FILL-IN-UndBas ~
FILL-IN-PrecioBase FILL-IN-DesMat 

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
DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-PrecioBase AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Precio Base" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-UndBas AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaDctoProm, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaDctoProm.CodDiv COLUMN-LABEL "División" FORMAT "x(8)":U
      GN-DIVI.DesDiv FORMAT "X(40)":U
      VtaDctoProm.FchIni FORMAT "99/99/9999":U
      VtaDctoProm.FchFin FORMAT "99/99/9999":U
      VtaDctoProm.Descuento COLUMN-LABEL "Descuento (%)" FORMAT "(>>>,>>9.999999)":U
      VtaDctoProm.Precio FORMAT ">>>,>>9.9999":U
      VtaDctoProm.Tipo FORMAT "x(15)":U
  ENABLE
      VtaDctoProm.CodDiv
      VtaDctoProm.FchIni
      VtaDctoProm.FchFin
      VtaDctoProm.Descuento
      VtaDctoProm.Precio
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 89.72 BY 15.08
         FONT 4
         TITLE "PROMOCIONES EN CONVIVENCIA".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodMat AT ROW 1.19 COL 4 NO-LABEL WIDGET-ID 12
     FILL-IN-UndBas AT ROW 1.19 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     FILL-IN-PrecioBase AT ROW 1.19 COL 62 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-DesMat AT ROW 1.96 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     br_table AT ROW 2.88 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.Almmmatg
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-TABLA B "?" ? INTEGRAL VtaDctoProm
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
         HEIGHT             = 18.69
         WIDTH              = 101.43.
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
/* BROWSE-TAB br_table FILL-IN-DesMat F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodMat IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PrecioBase IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UndBas IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaDctoProm OF INTEGRAL.Almmmatg,INTEGRAL.GN-DIVI OF INTEGRAL.VtaDctoProm"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "(VtaDctoProm.FchIni >= TODAY OR TODAY <= VtaDctoProm.FchFin)
 AND VtaDctoProm.FlgEst = ""A"""
     _Where[2]         = "/*LOOKUP(GN-DIVI.CanalVenta, s-CanalVenta) > 0 AND GN-DIVI.VentaMayorista = 1*/
LOOKUP(GN-DIVI.CodDiv, s-Divisiones) > 0 "
     _FldNameList[1]   > INTEGRAL.VtaDctoProm.CodDiv
"VtaDctoProm.CodDiv" "División" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.GN-DIVI.DesDiv
     _FldNameList[3]   > INTEGRAL.VtaDctoProm.FchIni
"VtaDctoProm.FchIni" ? ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaDctoProm.FchFin
"VtaDctoProm.FchFin" ? ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaDctoProm.Descuento
"VtaDctoProm.Descuento" "Descuento (%)" "(>>>,>>9.999999)" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.VtaDctoProm.Precio
"VtaDctoProm.Precio" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.VtaDctoProm.Tipo
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* PROMOCIONES EN CONVIVENCIA */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* PROMOCIONES EN CONVIVENCIA */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* PROMOCIONES EN CONVIVENCIA */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoProm.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoProm.CodDiv br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaDctoProm.CodDiv IN BROWSE br_table /* División */
DO:
  FIND gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN DISPLAY GN-DIVI.DesDiv WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoProm.CodDiv br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF VtaDctoProm.CodDiv IN BROWSE br_table /* División */
OR F8 OF VtaDCtoProm.CodDiv DO:
  ASSIGN
      /*input-var-1 = s-CanalVenta*/
      input-var-1 = s-Divisiones
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  /*RUN lkup/c-divi-lima ('Divisiones').*/
  RUN lkup/c-pri-divisiones ('Divisiones').
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoProm.Descuento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoProm.Descuento br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaDctoProm.Descuento IN BROWSE br_table /* Descuento (%) */
DO:
    DISPLAY ROUND( (F-PRECIO * F-FACTOR) * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ),4) @ VtaDctoProm.Precio
        WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoProm.Precio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoProm.Precio br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaDctoProm.Precio IN BROWSE br_table /* Precio */
DO:
    DISPLAY ROUND ( ( 1 -  DECIMAL(SELF:SCREEN-VALUE) / (F-PRECIO * F-FACTOR) ) * 100, 6 ) @  VtaDctoProm.Descuento
        WITH BROWSE {&browse-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF VtaDctoProm.CodDiv, 
    VtaDctoProm.Descuento, 
    VtaDctoProm.FchFin, 
    VtaDctoProm.FchIni, 
    VtaDctoProm.Precio
    DO:
    APPLY 'TAB':U.
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almmmatg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable-Columns B-table-Win 
PROCEDURE Disable-Columns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR hBrowse AS HANDLE NO-UNDO.
DEF VAR hColumn AS HANDLE NO-UNDO.
DEF VAR iCounter AS INT NO-UNDO.

ASSIGN hBrowse = BROWSE {&BROWSE-NAME}:HANDLE.

DO iCounter = 1 TO hBrowse:NUM-COLUMNS:
    hColumn = hBrowse:GET-BROWSE-COLUMN(iCounter).
    IF hColumn:READ-ONLY = YES THEN NEXT.
    hColumn:READ-ONLY = TRUE.
END.

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
  F-FACTOR = 1.

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
      VtaDctoProm.CodCia = Almmmatg.CodCia
      VtaDctoProm.CodMat = Almmmatg.CodMat.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN
      ASSIGN
        VtaDctoProm.FchCreacion = TODAY
        VtaDctoProm.HoraCreacion = STRING(TIME,'HH:MM:SS')
        VtaDctoProm.UsrCreacion = s-user-id.
  ELSE DO:
      ASSIGN
        VtaDctoProm.FchModificacion = TODAY
        VtaDctoProm.HoraModificacion = STRING(TIME,'HH:MM:SS')
        VtaDctoProm.UsrModificacion = s-user-id.
/*       FIND B-TABLA WHERE ROWID(B-TABLA) = ROWID(VtaDctoProm) EXCLUSIVE-LOCK NO-ERROR. */
/*       IF ERROR-STATUS:ERROR = YES THEN UNDO, RETURN 'ADM-ERROR'.                      */
/*       CREATE B-TABLA.                                                                 */
/*       BUFFER-COPY VtaDctoProm TO B-TABLA                                              */
/*       ASSIGN                                                                          */
/*           B-TABLA.FchModificacion = TODAY                                             */
/*           B-TABLA.HoraModificacion = STRING(TIME, 'HH:MM:SS')                         */
/*           B-TABLA.UsrModificacion = s-user-id                                         */
/*           B-TABLA.FlgEst = "A".                                                       */
/*       ASSIGN                                                                          */
/*           VtaDctoProm.FchAnulacion = TODAY                                            */
/*           VtaDctoProm.HoraAnulacion = STRING(TIME,'HH:MM:SS')                         */
/*           VtaDctoProm.UsrAnulacion = s-user-id                                        */
/*           VtaDctoProm.FlgEst = 'I'.                                                   */
/*       FIND VtaDctoProm WHERE ROWID(VtaDctoProm) = ROWID(B-TABLA) NO-LOCK NO-ERROR.    */
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
  IF NOT AVAILABLE {&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN RETURN 'ADM-ERROR'.
  FIND CURRENT {&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}} EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR = YES THEN RETURN 'ADM-ERROR'.
  ASSIGN
      {&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}.FchAnulacion = TODAY
      {&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}.HoraAnulacion = STRING(TIME,'HH:MM:SS')
      {&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}.UsrAnulacion = s-user-id
      {&FIRST-ENABLED-TABLE-IN-QUERY-{&BROWSE-NAME}}.FlgEst = 'I'.
  IF {&BROWSE-NAME}:DELETE-CURRENT-ROW() IN FRAME {&FRAME-NAME} THEN DO:
      RUN new-state ('delete-complete':U). /* Tell all to reset/refresh */
  END.
  ELSE UNDO, RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO'
      THEN ASSIGN
            VtaDctoProm.CodDiv:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES
            VtaDctoProm.FchFin:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES
            VtaDctoProm.FchIni:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  ELSE ASSIGN
        VtaDctoProm.CodDiv:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO
        VtaDctoProm.FchFin:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO
        VtaDctoProm.FchIni:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.

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
  IF AVAILABLE Almmmatg THEN DO:
      F-PRECIO = Almmmatg.PreVta[1].
      ASSIGN
          FILL-IN-CodMat = Almmmatg.codmat
          FILL-IN-DesMat = Almmmatg.desmat
          FILL-IN-UndBas = Almmmatg.undbas
          FILL-IN-PrecioBase = F-PRECIO.
      DISPLAY 
          FILL-IN-CodMat
          FILL-IN-DesMat
          FILL-IN-UndBas
          FILL-IN-PrecioBase
          WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Margen-de-Utilidad B-table-Win 
PROCEDURE Margen-de-Utilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pPreUni AS DEC.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER pTpoCmb AS DEC.
DEF OUTPUT PARAMETER x-Limite AS DEC.
DEF OUTPUT PARAMETER pError AS CHAR.

DEF VAR x-Margen AS DEC NO-UNDO.    /* Margen de utilidad */

pError = ''.

RUN vtagn/p-margen-utilidad-v11 (pCodDiv,
                                 pCodMat,
                                 pPreUni,
                                 pUndVta,
                                 1,                      /* Moneda */
                                 pTpoCmb,
                                 NO,                     /* Muestra error? */
                                 "",                     /* Almacén */
                                 OUTPUT x-Margen,        /* Margen de utilidad */
                                 OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                 OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                 ).
/* Versión nueva NO aprobada */
/* RUN vtagn/p-margen-utilidad-v2 (pCodDiv,                                                           */
/*                                 pCodMat,                                                           */
/*                                 pPreUni,                                                           */
/*                                 pUndVta,                                                           */
/*                                 1,                      /* Moneda */                               */
/*                                 pTpoCmb,                                                           */
/*                                 NO,                     /* Muestra error? */                       */
/*                                 "",                     /* Almacén */                              */
/*                                 OUTPUT x-Margen,        /* Margen de utilidad */                   */
/*                                 OUTPUT x-Limite,        /* Margen mínimo de utilidad */            */
/*                                 OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */ */
/*                                 ).                                                                 */

IF RETURN-VALUE = 'ADM-ERROR' THEN pError = 'ADM-ERROR'.

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
        WHEN "CodDiv" THEN 
            ASSIGN
            input-var-1 = s-CanalVenta
            input-var-2 = ""
            input-var-3 = "".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Replica-Plantilla B-table-Win 
PROCEDURE Replica-Plantilla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pDivisiones AS CHAR.

IF pDivisiones = "" THEN RETURN.
IF NOT AVAILABLE VtaDctoProm THEN RETURN.

DEF BUFFER B-TABLA-2 FOR VtaDctoProm.

DEF VAR x-CodDiv LIKE gn-divi.coddiv NO-UNDO.
DEF VAR k AS INT NO-UNDO.

DO k = NUM-ENTRIES(pDivisiones) TO 1 BY -1:
    x-CodDiv = ENTRY(k, pDivisiones).
    IF VtaDctoProm.CodDiv = x-CodDiv THEN NEXT.
    FIND FIRST B-TABLA-2 WHERE B-TABLA-2.codcia = s-codcia
        AND B-TABLA-2.codmat = VtaDctoProm.codmat
        AND B-TABLA-2.coddiv = x-CodDiv
        AND B-TABLA-2.Descuento = VtaDctoProm.Descuento 
        AND B-TABLA-2.FchFin = VtaDctoProm.FchFin 
        AND B-TABLA-2.FchIni = VtaDctoProm.FchIni
        NO-ERROR.
    IF AVAILABLE B-TABLA-2 THEN DO:
        FIND CURRENT B-TABLA-2 EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN NEXT.
        ASSIGN
            B-TABLA-2.FchAnulacion = TODAY
            B-TABLA-2.UsrAnulacion = s-user-id
            B-TABLA-2.HoraAnulacion = STRING(TIME, 'HH:MM:SS')
            B-TABLA-2.FlgEst = "I".
    END.
    CREATE B-TABLA-2.
    BUFFER-COPY VtaDctoProm
        TO B-TABLA-2
        ASSIGN B-TABLA-2.coddiv = x-CodDiv.

/*     FIND FIRST B-TABLA-2 WHERE B-TABLA-2.codcia = s-codcia */
/*         AND B-TABLA-2.codmat = VtaDctoProm.codmat          */
/*         AND B-TABLA-2.coddiv = x-CodDiv                    */
/*         AND B-TABLA-2.Descuento = VtaDctoProm.Descuento    */
/*         AND B-TABLA-2.FchFin = VtaDctoProm.FchFin          */
/*         AND B-TABLA-2.FchIni = VtaDctoProm.FchIni          */
/*         NO-ERROR.                                          */
/*     IF NOT AVAILABLE B-TABLA-2 THEN CREATE B-TABLA-2.      */
/*     BUFFER-COPY VtaDctoProm                                */
/*         TO B-TABLA-2                                       */
/*         ASSIGN B-TABLA-2.coddiv = x-CodDiv.                */
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "VtaDctoProm"}
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

IF LOOKUP(VtaDctoProm.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name}, s-Divisiones) = 0
    THEN DO:
    MESSAGE 'División NO registrada o no válida para esta lista de precios' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtaDctoProm.CodDiv.
    RETURN 'ADM-ERROR'.
END.
IF INPUT VtaDctoProm.FchIni = ? THEN DO:
    MESSAGE 'Fecha errada' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtaDctoProm.FchIni.
    RETURN 'ADM-ERROR'.
END.
IF INPUT VtaDctoProm.FchFin = ? THEN DO:
    MESSAGE 'Fecha errada' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtaDctoProm.FchFin.
    RETURN 'ADM-ERROR'.
END.
IF INPUT VtaDctoProm.FchFin < TODAY THEN DO:
    MESSAGE 'Fecha errada' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO VtaDctoProm.FchFin.
    RETURN 'ADM-ERROR'.
END.
IF (INPUT VtaDctoProm.FchIni > INPUT VtaDctoProm.FchFin) THEN DO:
    APPLY 'ENTRY':U TO VtaDctoProm.FchIni.
    RETURN 'ADM-ERROR'.
END.

/* ****************************************************************************************************** */
/* Control Margen de Utilidad */
/* ****************************************************************************************************** */
DEFINE VAR x-Margen AS DECI NO-UNDO.
DEFINE VAR x-Limite AS DECI NO-UNDO.
DEFINE VAR pError AS CHAR NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.

/* 1ro. Calculamos el margen de utilidad */
RUN pri/pri-librerias PERSISTENT SET hProc.
RUN PRI_Margen-Utilidad IN hProc (INPUT VtaDctoProm.CodDiv:SCREEN-VALUE IN BROWSE {&browse-name},
                                  INPUT FILL-IN-CodMat,
                                  INPUT FILL-IN-UndBas:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                  INPUT DECIMAL(VtaDctoProm.Precio:SCREEN-VALUE IN BROWSE {&browse-name}),
                                  INPUT Almmmatg.MonVta,        /*INPUT 1,*/
                                  OUTPUT x-Margen,
                                  OUTPUT x-Limite,
                                  OUTPUT pError).

IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    /* Error crítico */
    MESSAGE pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
    APPLY 'ENTRY':U TO VtaDctoProm.Descuento.
    RETURN 'ADM-ERROR'.
END.
/* Controlamos si el margen de utilidad está bajo a través de la variable pError */
IF pError > '' THEN DO:
    /* Error por margen de utilidad */
    /* 2do. Verificamos si solo es una ALERTA, definido por GG */
    DEF VAR pAlerta AS LOG NO-UNDO.
    RUN PRI_Alerta-de-Margen IN hProc (INPUT FILL-IN-CodMat,
                                       OUTPUT pAlerta).
    IF pAlerta = YES THEN MESSAGE pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.
    ELSE DO:
        MESSAGE pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
        APPLY 'ENTRY':U TO VtaDctoProm.Descuento.
        RETURN 'ADM-ERROR'.
    END.
END.
DELETE PROCEDURE hProc.

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

