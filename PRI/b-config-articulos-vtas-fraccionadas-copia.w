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

DEFINE VAR x-tabla AS CHAR INIT "AR-VTA-FRACCION".
DEFINE VAR x-tabla-fraccion AS CHAR INIT "AR-FRACCION-ACTIVA".

DEFINE SHARED VAR pRCID AS INT.

DEFINE BUFFER x-almmmatg FOR almmmatg.
DEFINE BUFFER x-factabla FOR factabla.
DEFINE BUFFER x-VtaListaMinGn FOR VtaListaMinGn.

DEFINE VAR x-cargar-defaults AS LOG.
DEFINE VAR x-edit-on AS LOG INIT NO.

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
&Scoped-define INTERNAL-TABLES FacTabla Almmmatg VtaListaMinGn

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacTabla.Codigo Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.UndBas VtaListaMinGn.Chr__01 FacTabla.Campo-D[1] ~
FacTabla.Campo-D[2] FacTabla.Campo-L[1] FacTabla.Campo-L[2] ~
FacTabla.Campo-L[3] FacTabla.Campo-L[4] FacTabla.Campo-L[5] ~
FacTabla.Campo-L[6] FacTabla.Campo-L[7] FacTabla.Campo-L[8] ~
FacTabla.Campo-L[9] FacTabla.Campo-L[10] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacTabla.Codigo ~
FacTabla.Campo-D[1] FacTabla.Campo-D[2] FacTabla.Campo-L[1] ~
FacTabla.Campo-L[2] FacTabla.Campo-L[3] FacTabla.Campo-L[4] ~
FacTabla.Campo-L[5] FacTabla.Campo-L[6] FacTabla.Campo-L[7] ~
FacTabla.Campo-L[8] FacTabla.Campo-L[9] FacTabla.Campo-L[10] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacTabla
&Scoped-define QUERY-STRING-br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND factabla.codcia = s-codcia and ~
factabla.tabla = x-tabla NO-LOCK, ~
      FIRST Almmmatg WHERE almmmatg.codcia = s-codcia and ~
almmmatg.codmat = factabla.codigo NO-LOCK, ~
      FIRST VtaListaMinGn OF Almmmatg OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND factabla.codcia = s-codcia and ~
factabla.tabla = x-tabla NO-LOCK, ~
      FIRST Almmmatg WHERE almmmatg.codcia = s-codcia and ~
almmmatg.codmat = factabla.codigo NO-LOCK, ~
      FIRST VtaListaMinGn OF Almmmatg OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacTabla Almmmatg VtaListaMinGn
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table VtaListaMinGn


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
      FacTabla, 
      Almmmatg, 
      VtaListaMinGn SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacTabla.Codigo COLUMN-LABEL "Cod!Articulo" FORMAT "x(8)":U
            WIDTH 6.86 LABEL-FGCOLOR 9 LABEL-BGCOLOR 6 LABEL-FONT 6
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 31.43
      Almmmatg.DesMar FORMAT "X(30)":U WIDTH 20.43
      Almmmatg.UndBas COLUMN-LABEL "Unidad!Base" FORMAT "X(8)":U
            WIDTH 5.43
      VtaListaMinGn.Chr__01 COLUMN-LABEL "Uni.Vta!Minorista" FORMAT "X(8)":U
            WIDTH 6.86
      FacTabla.Campo-D[1] COLUMN-LABEL "Vigencia!Desde" FORMAT "99/99/9999":U
            WIDTH 8.43 COLUMN-BGCOLOR 14 LABEL-FGCOLOR 9 LABEL-FONT 6
      FacTabla.Campo-D[2] COLUMN-LABEL "Vigencia!Hasta" FORMAT "99/99/9999":U
            WIDTH 8.43 COLUMN-BGCOLOR 14 LABEL-FGCOLOR 9 LABEL-BGCOLOR 6 LABEL-FONT 6
      FacTabla.Campo-L[1] COLUMN-LABEL "TIT01" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[2] COLUMN-LABEL "TIT02" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[3] COLUMN-LABEL "TIT03" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[4] COLUMN-LABEL "TIT04" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[5] COLUMN-LABEL "TIT05" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[6] COLUMN-LABEL "TIT06" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[7] COLUMN-LABEL "TIT07" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[8] COLUMN-LABEL "TIT08" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[9] COLUMN-LABEL "TIT09" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[10] COLUMN-LABEL "TIT10" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
  ENABLE
      FacTabla.Codigo
      FacTabla.Campo-D[1]
      FacTabla.Campo-D[2]
      FacTabla.Campo-L[1]
      FacTabla.Campo-L[2]
      FacTabla.Campo-L[3]
      FacTabla.Campo-L[4]
      FacTabla.Campo-L[5]
      FacTabla.Campo-L[6]
      FacTabla.Campo-L[7]
      FacTabla.Campo-L[8]
      FacTabla.Campo-L[9]
      FacTabla.Campo-L[10]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 130.86 BY 13.58
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.14
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
         HEIGHT             = 13.65
         WIDTH              = 131.
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
     _TblList          = "INTEGRAL.FacTabla,INTEGRAL.Almmmatg WHERE INTEGRAL.FacTabla ...,INTEGRAL.VtaListaMinGn OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _Where[1]         = "factabla.codcia = s-codcia and
factabla.tabla = x-tabla"
     _JoinCode[2]      = "almmmatg.codcia = s-codcia and
almmmatg.codmat = factabla.codigo"
     _FldNameList[1]   > INTEGRAL.FacTabla.Codigo
"FacTabla.Codigo" "Cod!Articulo" ? "character" ? ? ? 6 9 6 yes ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "31.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" ? ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad!Base" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaListaMinGn.Chr__01
"VtaListaMinGn.Chr__01" "Uni.Vta!Minorista" ? "character" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacTabla.Campo-D[1]
"FacTabla.Campo-D[1]" "Vigencia!Desde" "99/99/9999" "date" 14 ? ? ? 9 6 yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacTabla.Campo-D[2]
"FacTabla.Campo-D[2]" "Vigencia!Hasta" "99/99/9999" "date" 14 ? ? 6 9 6 yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacTabla.Campo-L[1]
"FacTabla.Campo-L[1]" "TIT01" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacTabla.Campo-L[2]
"FacTabla.Campo-L[2]" "TIT02" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacTabla.Campo-L[3]
"FacTabla.Campo-L[3]" "TIT03" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacTabla.Campo-L[4]
"FacTabla.Campo-L[4]" "TIT04" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[12]   > INTEGRAL.FacTabla.Campo-L[5]
"FacTabla.Campo-L[5]" "TIT05" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[13]   > INTEGRAL.FacTabla.Campo-L[6]
"FacTabla.Campo-L[6]" "TIT06" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[14]   > INTEGRAL.FacTabla.Campo-L[7]
"FacTabla.Campo-L[7]" "TIT07" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[15]   > INTEGRAL.FacTabla.Campo-L[8]
"FacTabla.Campo-L[8]" "TIT08" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[16]   > INTEGRAL.FacTabla.Campo-L[9]
"FacTabla.Campo-L[9]" "TIT09" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[17]   > INTEGRAL.FacTabla.Campo-L[10]
"FacTabla.Campo-L[10]" "TIT10" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
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


&Scoped-define SELF-NAME FacTabla.Codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Codigo br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF FacTabla.Codigo IN BROWSE br_table /* Cod!Articulo */
DO:
    ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?          /* Rowid */
      output-var-2 = ''
      output-var-3 = ''
    .

    RUN lkup/c-catart.r ('Tipo de documentos').
    IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.

    self:screen-value = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

DEF VAR t_col_br AS INT NO-UNDO INITIAL 11. 
DEF VAR t_col_eti AS INT NO-UNDO INITIAL 2. 

DEF VAR t_celda_br AS WIDGET-HANDLE EXTENT 50 NO-UNDO. 
DEF VAR t_cual_celda AS WIDGET-HANDLE NO-UNDO. 
DEF VAR t_n_cols_browse AS INT NO-UNDO.  
DEF VAR t_col_act AS INT NO-UNDO. 
DEFINE VAR t_col  AS HANDLE.
DEFINE VAR cColumnName AS CHAR.

DO t_n_cols_browse = 1 TO br_table:NUM-COLUMNS:    
    t_celda_br[t_n_cols_browse] = br_table:GET-BROWSE-COLUMN(t_n_cols_browse). 
    t_cual_celda = t_celda_br[t_n_cols_browse].
    cColumnName = CAPS(t_cual_celda:NAME).
    IF INDEX(cColumnName,"CAMPO-L") > 0 THEN DO:
        t_cual_celda:LABEL = "".
    END.
END.

ON 'RETURN':U OF factabla.codigo, factabla.campo-d[1], factabla.campo-d[2], factabla.campo-L[1] IN BROWSE {&BROWSE-NAME} DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.
ON ENTRY OF BROWSE {&BROWSE-NAME} ANYWHERE DO:
    DEFINE VARIABLE hColumn AS HANDLE NO-UNDO.
    DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.

    RUN custom-titles-fields.
    RUN custom-default-fields.

END.
ON 'VALUE-CHANGED' OF BROWSE {&BROWSE-NAME}  DO:
    RUN custom-titles-fields.
END.

PROCEDURE custom-titles-fields:    

    IF AVAILABLE factabla THEN DO:
        DEFINE VAR ar-fracciones AS CHAR EXTENT 20 INIT "".
        DEFINE VAR ar-fracciones-pos AS INT EXTENT 20 INIT 0.
        DEFINE VAR x-posicion-array AS INT INIT 0.

        FOR EACH x-factabla WHERE x-factabla.codcia = s-codcia AND
                                x-factabla.tabla = 'AR-VALORES-VTAS' NO-LOCK:
            x-posicion-array = x-factabla.valor[2].
            ar-fracciones[x-posicion-array] = TRIM(x-factabla.codigo).
        END.
        DO WITH FRAME {&FRAME-NAME}:
            x-posicion-array = 0.
            DO t_n_cols_browse = 1 TO br_table:NUM-COLUMNS:    
                t_celda_br[t_n_cols_browse] = br_table:GET-BROWSE-COLUMN(t_n_cols_browse). 
                t_cual_celda = t_celda_br[t_n_cols_browse].
                cColumnName = CAPS(t_cual_celda:NAME).
                IF INDEX(cColumnName,"CAMPO-L") > 0 THEN DO:
                    x-posicion-array = x-posicion-array + 1.
                    t_cual_celda:LABEL = ar-fracciones[x-posicion-array].
                    t_cual_celda:WIDTH = 4.
                END.
            END.
        END.
    END.

END PROCEDURE.

/*
x-posicion-array = 0.
DO t_n_cols_browse = 1 TO br_table:NUM-COLUMNS:    
    t_celda_br[t_n_cols_browse] = br_table:GET-BROWSE-COLUMN(t_n_cols_browse). 
    t_cual_celda = t_celda_br[t_n_cols_browse].
    cColumnName = CAPS(t_cual_celda:NAME).
    IF INDEX(cColumnName,"CAMPO-L") > 0 THEN DO:
        x-posicion-array = x-posicion-array + 1.
        t_cual_celda:LABEL = ar-fracciones[x-posicion-array].
        IF ar-fracciones[x-posicion-array] = "" THEN DO:
            t_cual_celda:READ-ONLY = YES.
            t_cual_celda:VISIBLE = NO.
        END.
        ELSE DO:            
            t_cual_celda:READ-ONLY = NO.
            t_cual_celda:VISIBLE = YES.

            FOR EACH x-factabla WHERE x-factabla.codcia = s-codcia AND
                                        x-factabla.tabla = "AR-FRACCION-ACTIVA" NO-LOCK:
            END.
        END.
    END.
END.
*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE custom-default-fields B-table-Win 
PROCEDURE custom-default-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      IF x-cargar-defaults = NO THEN RETURN.

      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' THEN DO:

        DO WITH FRAME {&FRAME-NAME} :
            ASSIGN {&FIRST-TABLE-IN-QUERY-br_table}.codigo:SCREEN-VALUE IN BROWSE {&browse-name} = "".
            ASSIGN factabla.campo-d[1]:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(TODAY,"99/99/9999").
            ASSIGN factabla.campo-d[2]:SCREEN-VALUE IN BROWSE br_table = STRING(TODAY + 365,"99/99/9999").
            /*ASSIGN factabla.valor[1]:SCREEN-VALUE IN BROWSE {&browse-name} = "0.00".*/
        END.        
      END.

      x-cargar-defaults = NO.


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
    x-cargar-defaults = YES.

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

  ASSIGN factabla.codcia = s-codcia 
        factabla.tabla = x-tabla.

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      ASSIGN factabla.campo-c[1] = USERID("DICTDB")
                factabla.campo-c[2] = STRING(TODAY,"99/99/9999")+ " " + STRING(TIME, 'HH:MM:SS')
                factabla.campo-c[3] = String(pRCID,"999999999999")
                .
  END.
  ELSE DO:
      ASSIGN factabla.campo-c[4] = USERID("DICTDB")
                factabla.campo-c[5] = STRING(TODAY,"99/99/9999")+ " " + STRING(TIME, 'HH:MM:SS')
                factabla.campo-c[6] = String(pRCID,"999999999999").
  END.
    

  CREATE LogTabla.
  ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'WRITE'
    logtabla.Hora = STRING(TIME, 'HH:MM:SS')
    logtabla.Tabla = 'FACTABLA'
    logtabla.Usuario = USERID("DICTDB")
    logtabla.ValorLlave = x-tabla + "|" + factabla.codigo + "|" + 
                STRING(factabla.valor[1],">>,>>9.99") + "|" +
                    STRING(factabla.campo-d[1],"99/99/9999") + "|" +
                 STRING(factabla.campo-d[2],"99/99/9999") + "|PRIC:" + String(pRCID,"999999999999").

 RELEASE LogTabla. 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  x-edit-on = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  x-edit-on = YES.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "NO" THEN DO:    
   /* Esta MODIFICANDO */
   {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codigo:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
  END.
  ELSE DO:
        /* Esta ADICIONADO */
   {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codigo:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
    
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
  {src/adm/template/snd-list.i "FacTabla"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "VtaListaMinGn"}

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
DEFINE VAR x-codmat AS CHAR.
DEFINE VAR x-desde AS DATE.
DEFINE VAR x-hasta AS DATE.
DEFINE VAR x-multiplos AS DEC INIT 0.

DO WITH FRAME {&FRAME-NAME}:
    x-codmat = factabla.codigo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    x-desde = DATE(factabla.campo-d[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) NO-ERROR.
    x-hasta = DATE(factabla.campo-d[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) NO-ERROR.

    /*x-multiplos = DECIMAL(factabla.valor[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) NO-ERROR.*/
END.

RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
IF RETURN-VALUE = "YES" THEN DO:

    FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia AND
                                x-factabla.tabla = x-tabla AND
                                x-factabla.codigo = x-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE x-factabla THEN DO:
        MESSAGE "Codigo de Articulo ya esta registrado" 
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.

    FIND FIRST x-almmmatg WHERE x-almmmatg.codcia = s-codcia AND
                                x-almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-almmmatg THEN DO:
        MESSAGE "Codigo de Articulo esta registrado en el maestro de articulos" 
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.

    FIND FIRST x-VtaListaMinGn WHERE x-VtaListaMinGn.codcia = s-codcia AND
                                x-VtaListaMinGn.codmat = x-codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE x-VtaListaMinGn THEN DO:
        MESSAGE "Codigo de Articulo no es para venta UTILEX/MINORISTA" 
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END.
        
END.
/*
IF x-multiplos <= 0 THEN DO:
    MESSAGE "Valor de los multiplos debe ser mayor a CERO" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".

END.
*/
IF x-desde = ? OR x-hasta = ? THEN DO:
    MESSAGE "Las vigencias estan ERRADAS" 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

IF x-desde > x-hasta THEN DO:
    MESSAGE "La vigencia DESDE debe ser menor al HASTA" 
        VIEW-AS ALERT-BOX INFORMATION.
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

