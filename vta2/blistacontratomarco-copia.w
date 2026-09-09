&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ListaPrecios FOR VtaListaPrecios.
DEFINE TEMP-TABLE T-LISTA NO-UNDO LIKE VtaListaPrecios.



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
DEF VAR x-MonCmp AS CHAR NO-UNDO.
DEF SHARED VAR s-user-id AS CHAR.

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
&Scoped-define EXTERNAL-TABLES VtaTabla
&Scoped-define FIRST-EXTERNAL-TABLE VtaTabla


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaTabla.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-LISTA Almmmatg VtaListaPrecios

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-LISTA.codmat Almmmatg.DesMat ~
Almmmatg.UndBas ~
IF (Almmmatg.MonVta = 2) THEN ('US$') ELSE ('S/.') @ x-MonCmp ~
Almmmatg.TpoCmb Almmmatg.DesMar ~
IF (Almmmatg.MonVta = 2) THEN (Almmmatg.CtoTot * Almmmatg.TpoCmb) ELSE (Almmmatg.CtoTot) @ Almmmatg.CtoTot ~
T-LISTA.CtoTot T-LISTA.Chr__01 T-LISTA.PreOfi VtaListaPrecios.Dec__01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-LISTA.codmat ~
T-LISTA.CtoTot T-LISTA.Chr__01 T-LISTA.PreOfi 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-LISTA
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-LISTA
&Scoped-define QUERY-STRING-br_table FOR EACH T-LISTA WHERE T-LISTA.CodCia = VtaTabla.CodCia ~
  AND T-LISTA.TpoPed = VtaTabla.Llave_c1 ~
  AND T-LISTA.NroLista = INTEGER(INTEGRAL.VtaTabla.Valor[1]) NO-LOCK, ~
      EACH Almmmatg OF T-LISTA NO-LOCK, ~
      EACH VtaListaPrecios OF T-LISTA NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-LISTA WHERE T-LISTA.CodCia = VtaTabla.CodCia ~
  AND T-LISTA.TpoPed = VtaTabla.Llave_c1 ~
  AND T-LISTA.NroLista = INTEGER(INTEGRAL.VtaTabla.Valor[1]) NO-LOCK, ~
      EACH Almmmatg OF T-LISTA NO-LOCK, ~
      EACH VtaListaPrecios OF T-LISTA NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-LISTA Almmmatg VtaListaPrecios
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-LISTA
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table VtaListaPrecios


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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Descuento_Promocional LABEL "Descuento Promocional".


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-LISTA, 
      Almmmatg, 
      VtaListaPrecios SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-LISTA.codmat COLUMN-LABEL "Articulo" FORMAT "X(13)":U WIDTH 6.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Almmmatg.DesMat FORMAT "X(60)":U
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(6)":U
      IF (Almmmatg.MonVta = 2) THEN ('US$') ELSE ('S/.') @ x-MonCmp COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      Almmmatg.TpoCmb COLUMN-LABEL "TC" FORMAT "Z9.9999":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      IF (Almmmatg.MonVta = 2) THEN (Almmmatg.CtoTot * Almmmatg.TpoCmb) ELSE (Almmmatg.CtoTot) @ Almmmatg.CtoTot COLUMN-LABEL "Costo Total!S/." FORMAT ">>>,>>9.9999":U
      T-LISTA.CtoTot COLUMN-LABEL "Costo Contrato Marco!S/." FORMAT "->>>,>>9.9999":U
            WIDTH 15.14 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      T-LISTA.Chr__01 COLUMN-LABEL "Und" FORMAT "X(6)":U COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      T-LISTA.PreOfi COLUMN-LABEL "Precio Oficina!S/." FORMAT ">,>>>,>>9.9999":U
            WIDTH 10.57 COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 12
      VtaListaPrecios.Dec__01 COLUMN-LABEL "% Uti Ofi" FORMAT "->>,>>9.99":U
  ENABLE
      T-LISTA.codmat
      T-LISTA.CtoTot
      T-LISTA.Chr__01
      T-LISTA.PreOfi
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 139 BY 18.27
         FONT 4 FIT-LAST-COLUMN.


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
   External Tables: INTEGRAL.VtaTabla
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-ListaPrecios B "?" ? INTEGRAL VtaListaPrecios
      TABLE: T-LISTA T "?" NO-UNDO INTEGRAL VtaListaPrecios
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
         HEIGHT             = 18.5
         WIDTH              = 139.57.
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

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-LISTA WHERE INTEGRAL.VtaTabla <external> ...,INTEGRAL.Almmmatg OF Temp-Tables.T-LISTA,INTEGRAL.VtaListaPrecios OF Temp-Tables.T-LISTA"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "Temp-Tables.T-LISTA.CodCia = INTEGRAL.VtaTabla.CodCia
  AND Temp-Tables.T-LISTA.TpoPed = INTEGRAL.VtaTabla.Llave_c1
  AND Temp-Tables.T-LISTA.NroLista = INTEGER(INTEGRAL.VtaTabla.Valor[1])"
     _FldNameList[1]   > Temp-Tables.T-LISTA.codmat
"T-LISTA.codmat" "Articulo" "X(13)" "character" 14 0 ? ? ? ? yes ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"IF (Almmmatg.MonVta = 2) THEN ('US$') ELSE ('S/.') @ x-MonCmp" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.TpoCmb
"Almmmatg.TpoCmb" "TC" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"IF (Almmmatg.MonVta = 2) THEN (Almmmatg.CtoTot * Almmmatg.TpoCmb) ELSE (Almmmatg.CtoTot) @ Almmmatg.CtoTot" "Costo Total!S/." ">>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-LISTA.CtoTot
"T-LISTA.CtoTot" "Costo Contrato Marco!S/." ? "decimal" 14 0 ? ? ? ? yes ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-LISTA.Chr__01
"T-LISTA.Chr__01" "Und" "X(6)" "character" 12 15 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-LISTA.PreOfi
"T-LISTA.PreOfi" "Precio Oficina!S/." ? "decimal" 12 15 ? ? ? ? yes ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.VtaListaPrecios.Dec__01
"VtaListaPrecios.Dec__01" "% Uti Ofi" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME T-LISTA.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-LISTA.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-LISTA.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = pCodMat
        NO-LOCK NO-ERROR.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = "YES" AND AVAILABLE Almmmatg
        THEN DO:
        DISPLAY
            IF (Almmmatg.MonVta = 2) THEN ('S/.') ELSE ('US$') @ x-MonCmp
            IF (Almmmatg.MonVta = 2) THEN (Almmmatg.CtoTot * Almmmatg.TpoCmb) ELSE (Almmmatg.CtoTot) @ Almmmatg.CtoTot
            Almmmatg.DesMar 
            Almmmatg.DesMat 
            Almmmatg.TpoCmb 
            Almmmatg.UndBas
            Almmmatg.UndBas @ T-LISTA.Chr__01
            WITH BROWSE {&browse-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-LISTA.Chr__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-LISTA.Chr__01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-LISTA.Chr__01 IN BROWSE br_table /* Und */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Descuento_Promocional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Descuento_Promocional B-table-Win
ON CHOOSE OF MENU-ITEM m_Descuento_Promocional /* Descuento Promocional */
DO:
    IF AVAILABLE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN
     RUN VtaGn/D-DtoProm-Insti ({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codmat).
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

ON 'RETURN':U OF T-LISTA.Chr__01, T-LISTA.codmat, T-LISTA.CtoTot, T-LISTA.PreOfi
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
  {src/adm/template/row-list.i "VtaTabla"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaTabla"}

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

EMPTY TEMP-TABLE T-LISTA.
IF NOT AVAILABLE VtaTabla THEN RETURN.

FOR EACH VtaListaPrecios WHERE VtaListaPrecios.CodCia = VtaTabla.CodCia
    AND VtaListaPrecios.TpoPed = VtaTabla.Llave_c1
    AND VtaListaPrecios.NroLista = INTEGER(VtaTabla.Valor[1]) NO-LOCK,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = VtaListaPrecios.codcia
    AND Almmmatg.codmat = VtaListaPrecios.codmat:
    CREATE T-LISTA.
    BUFFER-COPY VtaListaPrecios TO T-LISTA.
    IF Almmmatg.MonVta = 2 THEN
        ASSIGN
        T-LISTA.CtoTot = T-LISTA.CtoTot * Almmmatg.TpoCmb
        T-LISTA.PreOfi = T-LISTA.PreOfi * Almmmatg.TpoCmb.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-CToTot AS DEC NO-UNDO.
  DEF VAR f-Factor AS DEC NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      ASSIGN
          T-LISTA.CodCia = s-CodCia
          T-LISTA.TpoPed = VtaTabla.Llave_c1
          T-LISTA.NroLista = INTEGER(VtaTabla.Valor[1]).
      CREATE VtaListaPrecios.
      BUFFER-COPY T-LISTA
          TO VtaListaPrecios
          ASSIGN
          VtaListaPrecios.FchCreacion = TODAY
          VtaListaPrecios.UsrCreacion = s-user-id.
  END.
  ELSE DO: 
      FIND CURRENT VtaListaPrecios EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF ERROR-STATUS:ERROR THEN DO:
           RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
           UNDO, RETURN 'ADM-ERROR'.
      END.
      BUFFER-COPY T-LISTA 
          TO VtaListaPrecios
          ASSIGN
          VtaListaPrecios.FchActualizacion = TODAY
          VtaListaPrecios.UsrActualizacion = s-user-id.
  END.
  /* GRABAMOS MONEDAS Y TIPOS DE CAMBIO */
/*   ASSIGN                                        */
/*       VtaListaPrecios.TpoCmb = Almmmatg.TpoCmb  */
/*       VtaListaPrecios.MonVta = Almmmatg.MonVta. */
  IF Almmmatg.MonVta = 2 THEN
      ASSIGN
      VtaListaPrecios.PreOfi = VtaListaPrecios.PreOfi / Almmmatg.TpoCmb
      VtaListaPrecios.CtoTot = VtaListaPrecios.CtoTot / Almmmatg.TpoCmb.
  /* MARGEN */
  x-CtoTot = VtaListaPrecios.CtoTot.    /* OJO */
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = VtaListaPrecios.Chr__01
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
  ASSIGN
      VtaListaPrecios.Dec__01 = ( (VtaListaPrecios.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100
      VtaListaPrecios.PreVta[1] = VtaListaPrecios.PreOfi.

  FIND CURRENT VtaListaPrecios NO-LOCK NO-ERROR.

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
  FIND B-ListaPrecios WHERE ROWID(B-ListaPrecios) = ROWID (VtaListaPrecios)
      EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF ERROR-STATUS:ERROR THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DELETE B-ListaPrecios.


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
   RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

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
  {src/adm/template/snd-list.i "VtaTabla"}
  {src/adm/template/snd-list.i "T-LISTA"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "VtaListaPrecios"}

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

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = T-LISTA.codmat:SCREEN-VALUE IN BROWSE {&browse-name} 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Código del producto NO registrado'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-LISTA.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
  
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = T-LISTA.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE "Equivalencia NO definida" SKIP
        "Unidad base :" Almmmatg.undbas SKIP
        "Unidad venta:" T-LISTA.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-LISTA.Chr__01 IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
IF DECIMAL (T-LISTA.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}) = 0 THEN DO:
    MESSAGE 'Debe ingresar el precio de venta'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-LISTA.PreOfi IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES'
    AND CAN-FIND(VtaListaPrecios WHERE VtaListaPrecios.CodCia = VtaTabla.CodCia
                 AND VtaListaPrecios.TpoPed = VtaTabla.Llave_c1
                 AND VtaListaPrecios.NroLista = INTEGER(VtaTabla.Valor[1])
                 AND VtaListaPrecios.CodMat = T-LISTA.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
                 NO-LOCK)
    THEN DO:
    MESSAGE 'Artículo repetido' VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-LISTA.codmat IN BROWSE {&browse-name}.
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

