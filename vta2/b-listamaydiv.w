&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER MATG FOR Almmmatg.



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
/*DEF SHARED VAR s-coddiv AS CHAR.*/
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-local-adm-record AS LOG NO-UNDO.

DEF VAR x-Margen AS DEC NO-UNDO.

DEF SHARED VAR pCodDiv AS CHAR.

DEF VAR s-CodDiv LIKE pCodDiv NO-UNDO.

s-CodDiv = pCodDiv.

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
&Scoped-define INTERNAL-TABLES VtaListaMay Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaListaMay.codmat ~
VtaListaMay.DesMat VtaListaMay.DesMar VtaListaMay.codfam VtaListaMay.MonVta ~
VtaListaMay.TpoCmb VtaListaMay.Chr__01 VtaListaMay.PreOfi ~
fMargen() @ x-Margen VtaListaMay.CanEmp Almmmatg.UndBas 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaListaMay.codmat ~
VtaListaMay.MonVta VtaListaMay.TpoCmb VtaListaMay.Chr__01 ~
VtaListaMay.PreOfi VtaListaMay.CanEmp 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaListaMay
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaListaMay
&Scoped-define QUERY-STRING-br_table FOR EACH VtaListaMay WHERE ~{&KEY-PHRASE} ~
      AND VtaListaMay.CodCia = s-codcia ~
 AND VtaListaMay.CodDiv = s-coddiv NO-LOCK, ~
      EACH Almmmatg OF VtaListaMay NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaListaMay WHERE ~{&KEY-PHRASE} ~
      AND VtaListaMay.CodCia = s-codcia ~
 AND VtaListaMay.CodDiv = s-coddiv NO-LOCK, ~
      EACH Almmmatg OF VtaListaMay NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table VtaListaMay Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaListaMay
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMargen B-table-Win 
FUNCTION fMargen RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Descuento_Promocional LABEL "Descuento Promocional".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Buscar código" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaListaMay, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaListaMay.codmat FORMAT "X(6)":U
      VtaListaMay.DesMat FORMAT "X(60)":U
      VtaListaMay.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      VtaListaMay.codfam FORMAT "X(3)":U
      VtaListaMay.MonVta FORMAT "9":U WIDTH 8.86 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Soles",1,
                                      "Dolares",2
                      DROP-DOWN-LIST 
      VtaListaMay.TpoCmb FORMAT "Z9.9999":U COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      VtaListaMay.Chr__01 COLUMN-LABEL "Unidad" FORMAT "X(6)":U
            COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      VtaListaMay.PreOfi COLUMN-LABEL "Precio Venta" FORMAT ">,>>>,>>9.9999":U
            COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      fMargen() @ x-Margen COLUMN-LABEL "Margen %" FORMAT "(ZZZ,ZZ9.9999)":U
      VtaListaMay.CanEmp COLUMN-LABEL "Empaque" FORMAT "->>,>>9.99":U
            COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      Almmmatg.UndBas FORMAT "X(6)":U
  ENABLE
      VtaListaMay.codmat
      VtaListaMay.MonVta
      VtaListaMay.TpoCmb
      VtaListaMay.Chr__01
      VtaListaMay.PreOfi
      VtaListaMay.CanEmp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 145 BY 16.96
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodMat AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 10
     br_table AT ROW 2.35 COL 1
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
   Temp-Tables and Buffers:
      TABLE: MATG B "?" ? INTEGRAL Almmmatg
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
         HEIGHT             = 19.96
         WIDTH              = 145.43.
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
/* BROWSE-TAB br_table FILL-IN-CodMat F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* SETTINGS FOR FILL-IN FILL-IN-CodMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaListaMay,INTEGRAL.Almmmatg OF INTEGRAL.VtaListaMay"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "INTEGRAL.VtaListaMay.CodCia = s-codcia
 AND INTEGRAL.VtaListaMay.CodDiv = s-coddiv"
     _FldNameList[1]   > INTEGRAL.VtaListaMay.codmat
"VtaListaMay.codmat" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaListaMay.DesMat
"VtaListaMay.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaListaMay.DesMar
"VtaListaMay.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.VtaListaMay.codfam
     _FldNameList[5]   > INTEGRAL.VtaListaMay.MonVta
"VtaListaMay.MonVta" ? ? "integer" 11 9 ? ? ? ? yes ? no no "8.86" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Soles,1,Dolares,2" 5 no 0 no no
     _FldNameList[6]   > INTEGRAL.VtaListaMay.TpoCmb
"VtaListaMay.TpoCmb" ? ? "decimal" 11 9 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaListaMay.Chr__01
"VtaListaMay.Chr__01" "Unidad" "X(6)" "character" 11 9 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.VtaListaMay.PreOfi
"VtaListaMay.PreOfi" "Precio Venta" ? "decimal" 11 9 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fMargen() @ x-Margen" "Margen %" "(ZZZ,ZZ9.9999)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.VtaListaMay.CanEmp
"VtaListaMay.CanEmp" "Empaque" ? "decimal" 11 9 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" ? "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME VtaListaMay.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaListaMay.codmat IN BROWSE br_table /* Codigo Articulo */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    IF s-local-adm-record = NO THEN RETURN.
    DEF VAR pCodMat AS CHAR.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK.
    DISPLAY
        almmmatg.desmat @ vtalistamay.desmat
        almmmatg.undbas
        WITH BROWSE {&browse-name}.
    IF VtaListaMay.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name} = '' THEN DO:
        DISPLAY
            almmmatg.CHR__01 @ VtaListaMay.Chr__01
            almmmatg.canemp @ Vtalistamay.canemp
            WITH BROWSE {&browse-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaListaMay.Chr__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaListaMay.Chr__01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF VtaListaMay.Chr__01 IN BROWSE br_table /* Unidad */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat B-table-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Buscar código */
DO:
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
    SELF:SCREEN-VALUE = pCodMat.
    SELF:SENSITIVE = NO.
    IF pCodMat = '' THEN RETURN NO-APPLY.
    RUN local-busca.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Descuento_Promocional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuento_Promocional B-table-Win
ON CHOOSE OF MENU-ITEM m_Descuento_Promocional /* Descuento Promocional */
DO:
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
     RUN VtaGn/D-DtoProm-May ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
     RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF VtaListaMay.codmat, VtaListaMay.Chr__01,
    VtaListaMay.MonVta, VtaListaMay.PreOfi, VtaListaMay.TpoCmb,
    VtaListaMay.CanEmp
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Buscar B-table-Win 
PROCEDURE Buscar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-CodMat:SENSITIVE = YES.
    APPLY 'entry' TO FILL-IN-CodMat.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar B-table-Win 
PROCEDURE Eliminar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  MESSAGE 'Se va a borrar TODA la lista de precios' SKIP
      'Continuamos?' VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  FOR EACH VtaListaMay WHERE codcia = s-codcia
      AND coddiv = s-coddiv:
      DELETE Vtalistamay.
  END.
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
  /*F-CodMat:SENSITIVE IN FRAME {&FRAME-NAME} = NO.*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  s-local-adm-record = YES.

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
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "yes" 
      THEN ASSIGN
            VtaListaMay.CodCia = s-codcia
            VtaListaMay.CodDiv = s-coddiv
            VtaListaMay.FchIng = TODAY.
  ASSIGN
      VtaListaMay.codfam = Almmmatg.codfam
      VtaListaMay.DesMar = Almmmatg.desmar
      VtaListaMay.DesMat = Almmmatg.desmat
      VtaListaMay.subfam = Almmmatg.subfam
      VtaListaMay.FchAct  = TODAY
      VtaListaMay.usuario = s-user-id.

  DEF VAR x-CToTot AS DEC NO-UNDO.

  IF ALmmmatg.monvta = VTalistamay.monvta THEN x-CtoTot = Almmmatg.CtoTot.
  ELSE IF Vtalistamay.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
  ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.

  DEF VAR f-Factor AS DEC NO-UNDO.
  
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = VtaListaMay.Chr__01
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtconv THEN DO:
      F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
  END.  
  ASSIGN
      VtaListaMay.Dec__01 = ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100. 
  RUN dispatch IN THIS-PROCEDURE ('display-fields').

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
      FIND FIRST VtaListaMay WHERE VtaListaMay.codcia = s-codcia
          AND VTaListaMay.CodDiv = s-coddiv
          AND VtaListaMay.codmat = FILL-IN-CodMat:SCREEN-VALUE IN FRAME {&FRAME-NAME}
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaListaMay THEN output-var-1 = ROWID(VTaListaMay).
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
  s-local-adm-record = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Migracion B-table-Win 
PROCEDURE Migracion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-CodFam AS CHAR NO-UNDO.
  DEF VAR x-Tipo AS INT NO-UNDO.

  RUN vtagn/d-listamay (OUTPUT x-CodFam, OUTPUT x-Tipo).
  IF x-CodFam = '' OR x-CodFam BEGINS 'Sel' THEN RETURN.

  FOR EACH Almmmatg NO-LOCK WHERE codcia = s-codcia
      AND codfam BEGINS x-CodFam:
      FIND Vtalistamay OF Almmmatg WHERE coddiv = s-coddiv EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Vtalistamay THEN DO:
          CREATE Vtalistamay.
          ASSIGN
              Vtalistamay.codcia = Almmmatg.codcia
              Vtalistamay.codmat = Almmmatg.codmat
              Vtalistamay.coddiv = s-coddiv
              VtaListaMay.FchIng = TODAY
              VtaListaMay.usuario = s-user-id.
      END.
      IF Almmmatg.TpoArt = 'D' THEN DO:
          DELETE VtaListaMay.
          NEXT.
      END.
      ASSIGN
          VtaListaMay.codfam = Almmmatg.codfam
          VtaListaMay.DesMar = Almmmatg.desmar
          VtaListaMay.DesMat = Almmmatg.desmat
          VtaListaMay.subfam = Almmmatg.subfam.
      IF x-Tipo = 1 THEN DO:
          ASSIGN
              Vtalistamay.monvta = Almmmatg.monvta
              Vtalistamay.tpocmb = Almmmatg.tpocmb
              Vtalistamay.preofi = Almmmatg.preofi
              VtaListaMay.Chr__01 = Almmmatg.CHR__01
              VtaListaMay.Dec__01 = Almmmatg.DEC__01
              VtaListaMay.CanEmp = Almmmatg.DEC__03.
              /*VtaListaMay.CanEmp = Almmmatg.CanEmp.*/
          ASSIGN
              VtaListaMay.FchAct  = TODAY
              VtaListaMay.usuario = s-user-id.
      END.

      DEF VAR x-CtoTot AS DEC NO-UNDO.
      DEF VAR f-Factor AS DEC NO-UNDO INIT 1.

      IF Almmmatg.monvta = Vtalistamay.monvta THEN x-CtoTot = Almmmatg.CtoTot.
      ELSE IF Vtalistamay.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
      ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.
      FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
          AND Almtconv.Codalter = VtaListaMay.Chr__01
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtconv THEN DO:
          F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
      END.
      ASSIGN
          VtaListaMay.Dec__01 = ( (VtaListaMay.PreOfi / (x-Ctotot *  f-Factor) ) - 1 ) * 100. 
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query').

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
  {src/adm/template/snd-list.i "VtaListaMay"}
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
     APPLY 'entry' TO VtaListaMay.PreOfi IN BROWSE {&browse-name}.
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

IF VtaListaMay.MonVta:SCREEN-VALUE IN BROWSE {&Browse-name} = '' THEN DO:
    MESSAGE 'Debe seleccionar la moneda de venta'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO VtaListaMay.MonVta IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
IF DECIMAL (VtaListaMay.TpoCmb:SCREEN-VALUE IN BROWSE {&Browse-name}) = 0 THEN DO:
    MESSAGE 'Debe ingresar el tipo de cambio'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO VtaListaMay.TpoCmb IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = VtaListaMay.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE "Equivalencia NO definida" SKIP
        "Unidad base :" Almmmatg.undbas SKIP
        "Unidad venta:" VtaListaMay.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO VtaListaMay.Chr__01 IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
IF DECIMAL (VtaListaMay.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}) = 0 THEN DO:
    MESSAGE 'Debe ingresar el precio de venta'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO VtaListaMay.PreOfi IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
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
s-local-adm-record = YES.
/*F-CodMat:SENSITIVE IN FRAME {&FRAME-NAME} = NO.*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMargen B-table-Win 
FUNCTION fMargen RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE VtaListaMay THEN RETURN 0.
  IF NOT AVAILABLE Almmmatg    THEN RETURN 0.

  DEF VAR x-CtoTot AS DEC NO-UNDO.
  DEF VAR f-Factor AS DEC INIT 1 NO-UNDO.

  IF Almmmatg.monvta = Vtalistamay.monvta THEN x-CtoTot = Almmmatg.CtoTot.
  ELSE IF Vtalistamay.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
  ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = VtaListaMay.Chr__01
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtconv THEN DO:
      F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
  END.  

  RETURN ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

