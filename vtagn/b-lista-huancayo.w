&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATG LIKE Almmmatg.



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
DEF VAR x-Division AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR F-MrgUti AS DEC NO-UNDO.
DEF VAR X-CTOUND AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR F-PreVta AS DEC NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-MATG Almmmatg VtaListaMay

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-MATG.codmat Almmmatg.DesMat ~
Almmmatg.UndStk Almmmatg.DesMar T-MATG.CtoTot T-MATG.Chr__01 T-MATG.Dec__01 ~
T-MATG.PreOfi T-MATG.Date__01 T-MATG.Date__02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-MATG.codmat T-MATG.CtoTot ~
T-MATG.Dec__01 T-MATG.PreOfi T-MATG.Date__01 T-MATG.Date__02 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-MATG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define QUERY-STRING-br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-MATG NO-LOCK, ~
      EACH VtaListaMay OF T-MATG ~
      WHERE VtaListaMay.CodDiv = x-Division NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-MATG WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-MATG NO-LOCK, ~
      EACH VtaListaMay OF T-MATG ~
      WHERE VtaListaMay.CodDiv = x-Division NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-MATG Almmmatg VtaListaMay
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-MATG
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table VtaListaMay


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
      T-MATG, 
      Almmmatg, 
      VtaListaMay SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-MATG.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 7.43
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 60.43
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)":U WIDTH 6.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 20.43
      T-MATG.CtoTot COLUMN-LABEL "Costo Total!S/." FORMAT ">>>,>>9.9999":U
      T-MATG.Chr__01 COLUMN-LABEL "UM Ofic" FORMAT "X(6)":U WIDTH 7
      T-MATG.Dec__01 COLUMN-LABEL "% Uti Ofi" FORMAT "->>>,>>9.9999":U
      T-MATG.PreOfi COLUMN-LABEL "Precio Oficina!S/." FORMAT ">>>,>>9.9999":U
            WIDTH 9.43
      T-MATG.Date__01 COLUMN-LABEL "Vigencia!Desde" FORMAT "99/99/9999":U
            WIDTH 10.14
      T-MATG.Date__02 COLUMN-LABEL "Vigencia!Hasta" FORMAT "99/99/9999":U
            WIDTH 5
  ENABLE
      T-MATG.codmat
      T-MATG.CtoTot
      T-MATG.Dec__01
      T-MATG.PreOfi
      T-MATG.Date__01
      T-MATG.Date__02
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 159 BY 19.65
         FONT 4 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


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
   Temp-Tables and Buffers:
      TABLE: T-MATG T "?" ? INTEGRAL Almmmatg
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
         HEIGHT             = 21.92
         WIDTH              = 165.29.
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
     _TblList          = "Temp-Tables.T-MATG,INTEGRAL.Almmmatg OF Temp-Tables.T-MATG,INTEGRAL.VtaListaMay OF Temp-Tables.T-MATG"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST,"
     _Where[3]         = "INTEGRAL.VtaListaMay.CodDiv = x-Division"
     _FldNameList[1]   > Temp-Tables.T-MATG.codmat
"Temp-Tables.T-MATG.codmat" "Articulo" ? "character" ? ? ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"INTEGRAL.Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "60.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.UndStk
"INTEGRAL.Almmmatg.UndStk" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"INTEGRAL.Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MATG.CtoTot
"Temp-Tables.T-MATG.CtoTot" "Costo Total!S/." ">>>,>>9.9999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MATG.Chr__01
"Temp-Tables.T-MATG.Chr__01" "UM Ofic" "X(6)" "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.Dec__01
"Temp-Tables.T-MATG.Dec__01" "% Uti Ofi" "->>>,>>9.9999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-MATG.PreOfi
"Temp-Tables.T-MATG.PreOfi" "Precio Oficina!S/." ">>>,>>9.9999" "decimal" ? ? ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-MATG.Date__01
"Temp-Tables.T-MATG.Date__01" "Vigencia!Desde" ? "date" ? ? ? ? ? ? yes ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-MATG.Date__02
"Temp-Tables.T-MATG.Date__02" "Vigencia!Hasta" ? "date" ? ? ? ? ? ? yes ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME T-MATG.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    DEF VAR pCodMat AS CHAR.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE NO-LOCK.
    DISPLAY
        almmmatg.ctotot @ T-MATG.ctotot
        almmmatg.desmat
        almmmatg.desmar
        almmmatg.undstk
        WITH BROWSE {&browse-name}.
    IF Almmmatg.monvta = 2 THEN
        DISPLAY 
        Almmmatg.CtoTot * Almmmatg.TpoCmb @ T-MATG.CtoTot 
        WITH BROWSE {&browse-name}.

    /* VALORES POR DEFECTO */
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        DISPLAY
            almmmatg.UndBas @ T-MATG.Chr__01
            WITH BROWSE {&browse-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.Dec__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.Dec__01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.Dec__01 IN BROWSE br_table /* % Uti Ofi */
DO:
    ASSIGN
        F-MrgUti = DECIMAL(T-MATG.DEC__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    IF F-MrgUti <= 0 THEN RETURN.
    F-FACTOR = 1.
    F-PreVta = 0.
    /****   Busca el Factor de conversion   ****/
    FIND FIRST Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = T-MATG.CHR__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv OR Almtconv.Equival <= 0 THEN DO:
        MESSAGE "Error en el factor de equivalencia " VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-FACTOR = Almtconv.Equival.
    F-PreVta = ROUND(( X-CTOUND * (1 + F-MrgUti / 100) ), 6) * F-FACTOR.
    RUN lib/RedondearMas ( F-PreVta, 4, OUTPUT F-PreVta).
    DISPLAY F-PreVta @ T-MATG.PreOfi WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-MATG.PreOfi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-MATG.PreOfi br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-MATG.PreOfi IN BROWSE br_table /* Precio Oficina!S/. */
DO:
    ASSIGN
        F-PreVta = DECIMAL(T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        X-CTOUND = DECIMAL(T-MATG.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    F-FACTOR = 1.
    F-MrgUti = 0.    
    /****   Busca el Factor de conversion   ****/
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-MATG.codmat:SCREEN-VALUE NO-LOCK.
    FIND FIRST Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = T-MATG.CHR__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-FACTOR = Almtconv.Equival.
    F-MrgUti = ROUND(((((F-PreVta / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    /*******************************************/
    DISPLAY F-MrgUti @ T-MATG.Dec__01 WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF T-MATG.CodMat, T-MATG.Chr__01, T-MATG.PreOfi, T-MATG.dec__01
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pLinea AS CHAR.
DEF INPUT PARAMETER pSubLinea AS CHAR.
DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pDesMat AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.

x-Division = ENTRY(1, pCodDiv, ' - ').

EMPTY TEMP-TABLE T-MATG.

&SCOPED-DEFINE Condicion Almmmatg.codcia = s-codcia ~
AND (pLinea = 'Todas' OR Almmmatg.codfam = ENTRY(1, pLinea, ' - ') ) ~
AND (pSubLinea = 'Todas' OR Almmmatg.subfam = ENTRY(1, pSubLinea, ' - ') ) ~
AND ( ( TRUE <> (pCodPro > "") ) OR Almmmatg.CodPr1 = pCodPro ) ~
AND ( ( TRUE <> (pDesMat > "") ) OR INDEX(Almmmatg.desmat, pDesMat) > 0 )

EMPTY TEMP-TABLE T-MATG.

/* CASO DE SOLICITAR UN CODIGO ESPECÍFICO */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codMat = pCodMat
    NO-LOCK NO-ERROR.
FIND FIRST VtaListaMay WHERE VtaListaMay.codcia = s-codcia
    AND VtaListaMay.codmat = pCodMat
    AND VtaListaMay.CodDiv = x-Division
    NO-LOCK NO-ERROR.
IF pCodMat <> '' AND AVAILABLE Almmmatg AND AVAILABLE VtaListaMay THEN DO:
    /* Limpiamos otros filtros */
    ASSIGN
        pLinea = 'TODAS'
        pSublinea = 'TODAS'
        pCodPro = ''
        pDesMat = ''.
    CREATE T-MATG.
    BUFFER-COPY Almmmatg 
        TO T-MATG
        ASSIGN
        T-MATG.PreOfi = VtaListaMay.PreOfi
        T-MATG.CHR__01 = VtaListaMay.CHR__01
        T-MATG.DEC__01 = VtaListaMay.DEC__01
        T-MATG.Date__01 = VtaListaMay.PromFchD
        T-MATG.Date__02 = VtaListaMay.PromFchH.
END.
ELSE DO:
    FOR EACH VtaListaMay NO-LOCK WHERE VtaListaMay.codcia = s-codcia
        AND VtaListaMay.coddiv = x-Division,
        FIRST Almmmatg OF VtaListaMay NO-LOCK WHERE {&Condicion}:
        CREATE T-MATG.
        BUFFER-COPY Almmmatg 
            TO T-MATG
            ASSIGN
            T-MATG.PreOfi = VtaListaMay.PreOfi
            T-MATG.CHR__01 = VtaListaMay.CHR__01
            T-MATG.DEC__01 = VtaListaMay.DEC__01
            T-MATG.Date__01 = VtaListaMay.PromFchD
            T-MATG.Date__02 = VtaListaMay.PromFchH.
    END.
END.

/* EL PRECIO DE OFICINA YA ESTAN EN SOLES */
FOR EACH T-MATG WHERE T-MATG.MonVta = 2:
    ASSIGN
        T-MATG.CtoLis = T-MATG.CtoLis * T-MATG.TpoCmb
        T-MATG.CtoTot = T-MATG.CtoTot * T-MATG.TpoCmb
        .
END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-CtoTot AS DEC NO-UNDO.
  DEF VAR f-Factor AS DEC NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
      IF CAN-FIND(VtaListaMay WHERE VtaListaMay.codcia = s-codcia
                  AND VtaListaMay.coddiv = x-Division
                  AND VtaListaMay.codmat = T-MATG.codmat
                  NO-LOCK)
          THEN DO:
          MESSAGE 'Código ya registrado' VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          T-MATG.CodCia = s-codcia.
      CREATE VtaListaMay.
      ASSIGN
          VtaListaMay.CodCia = s-codcia
          VtaListaMay.CodDiv = x-Division
          VtaListaMay.codmat = T-MATG.codmat.
  END.
  ELSE DO:
      FIND CURRENT VtaListaMay EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF ERROR-STATUS:ERROR THEN DO:
           RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
           UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  ASSIGN
      VtaListaMay.TpoCmb = Almmmatg.TpoCmb
      VtaListaMay.MonVta = 1        /* OJO >>> Siempre en Soles */
      VtaListaMay.FchAct = TODAY
      VtaListaMay.DEC__01 = T-MATG.DEC__01
      VtaListaMay.CHR__01 = Almmmatg.CHR__01
      VtaListaMay.PreOfi  = T-MATG.PreOfi
      VtaListaMay.usuario = s-user-id
      VtaListaMay.PromFchD = T-MATG.Date__01 
      VtaListaMay.PromFchH = T-MATG.Date__02.
  /* MARGEN */
  IF Almmmatg.monvta = Vtalistamay.monvta THEN x-CtoTot = Almmmatg.CtoTot.
  ELSE IF Vtalistamay.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
  ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.
  F-FACTOR = 1.
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = VtaListaMay.Chr__01
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival.
  ASSIGN
      VtaListaMay.Dec__01 = ROUND( ( (VtaListaMay.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100, 4)
      T-MATG.Dec__01 = VtaListaMay.Dec__01
      T-MATG.CHR__01 = VtaListaMay.CHR__01.

  FIND CURRENT VtaListaMay NO-LOCK NO-ERROR.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  IF NOT AVAILABLE T-MATG THEN RETURN 'ADM-ERROR'.

  FIND FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia AND
      VtaListaMay.CodDiv = x-Division AND
      VtaListaMay.codmat = T-MATG.codmat NO-LOCK NO-ERROR.
  IF AVAILABLE VtaListaMay THEN DO:
      FIND CURRENT VtaListaMay EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE VtaListaMay THEN DO:
          DELETE VtaListaMay.
          RELEASE VtaListaMay.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  IF RETURN-VALUE = 'YES' THEN T-MATG.codmat:READ-ONLY IN BROWSE {&browse-name} = NO .
  ELSE T-MATG.codmat:READ-ONLY IN BROWSE {&browse-name} = YES.
  T-MATG.CtoTot:READ-ONLY IN BROWSE {&browse-name} = YES.

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

RUN vtagn/p-margen-utilidad-v2 (pCodDiv,
                                pCodMat,
                                pPreUni,
                                pUndVta,
                                1,                      /* Moneda */
                                pTpoCmb,
                                YES,                     /* Muestra error? */
                                "",                     /* Almacén */
                                OUTPUT x-Margen,        /* Margen de utilidad */
                                OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                                OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                                ).

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
  {src/adm/template/snd-list.i "T-MATG"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "VtaListaMay"}

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
    AND Almmmatg.codmat = T-MATG.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Artículo NO registrado en el catálogo'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-MATG.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.

FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = T-MATG.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE "Equivalencia NO definida" SKIP
        "Unidad base :" Almmmatg.undbas SKIP
        "Unidad venta:" T-MATG.Chr__01:SCREEN-VALUE IN BROWSE {&browse-name}
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-MATG.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
IF DECIMAL (T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}) = 0 THEN DO:
    MESSAGE 'Debe ingresar el precio de venta'
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-MATG.PreOfi IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.

DEF VAR x-Limite AS DEC NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.
RUN Margen-de-Utilidad (x-Division,
                        T-MATG.CodMat:SCREEN-VALUE IN BROWSE {&browse-name},
                        DECIMAL (T-MATG.PreOfi:SCREEN-VALUE IN BROWSE {&Browse-name}),
                        T-MATG.CHR__01:SCREEN-VALUE IN BROWSE {&Browse-name},
                        Almmmatg.TpoCmb,
                        OUTPUT x-Limite,        /* Margen mínimo de utilidad */
                        OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
                        ).
IF pError = "ADM-ERROR" THEN DO:
    APPLY 'entry' TO T-MATG.codmat IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.

/* RHC Verificación si es una línea válida para el usuario */
IF NOT CAN-FIND(FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia AND
                VtaTabla.tabla = "LP" AND
                VtaTabla.llave_c1 = s-user-id AND
                VtaTabla.llave_c2 = Almmmatg.codfam NO-LOCK)
    THEN DO:
    MESSAGE 'La línea del artículo NO está configurada para su usuario' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO T-MATG.codmat IN BROWSE {&browse-name}.
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

