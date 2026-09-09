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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEF VAR x-Margen AS DEC NO-UNDO.

DEF VAR x-Canal AS CHAR NO-UNDO.
DEF VAR x-Grupo AS CHAR NO-UNDO.
DEF VAR x-Linea AS CHAR NO-UNDO.
DEF VAR x-SubLinea AS CHAR NO-UNDO.
DEF VAR x-CodPro AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion (prilistaprecios.CodCia = s-CodCia AND ~
prilistaprecios.Canal = x-Canal AND ~
prilistaprecios.Grupo = x-Grupo)

DEF VAR F-MrgUti-B AS DEC NO-UNDO.
DEF VAR F-FACTOR AS DEC NO-UNDO.
DEF VAR F-Prevta-B AS DEC NO-UNDO.
DEF VAR X-CTOUND AS DEC NO-UNDO.
DEF VAR F-MrgUti-C AS DEC NO-UNDO.
DEF VAR F-Prevta-C AS DEC NO-UNDO.

DEF SHARED VAR lh_handle AS HANDLE.

DEF TEMP-TABLE Detalle
    FIELD CodMat        AS CHAR     FORMAT 'x(10)'          LABEL 'SKU'
    FIELD DesMat        AS CHAR     FORMAT 'x(80)'          LABEL 'DESCRIPCION'
    FIELD DesMar        AS CHAR     FORMAT 'x(30)'          LABEL 'MARCA'
    FIELD CodFam        AS CHAR     FORMAT 'x(40)'          LABEL 'LINEA'
    FIELD SubFam        AS CHAR     FORMAT 'x(40)'          LABEL 'SUBLINEA'
    FIELD CodPro        AS CHAR     FORMAT 'x(50)'          LABEL 'SUBLINEA'
    FIELD Canal         AS CHAR     FORMAT 'x(40)'          LABEL 'CANAL'
    FIELD Grupo         AS CHAR     FORMAT 'x(40)'          LABEL 'GRUPO'
    FIELD CtoTot        AS DEC      FORMAT '>>>,>>9.9999'   LABEL 'COSTO REPOSICION'
    FIELD PreUni        AS DEC      FORMAT '>>>,>>9.9999'   LABEL 'PRECIO BASE'
    FIELD MrgUti        AS DEC      FORMAT '->>>,>>9.99'    LABEL 'MARGEN'
    FIELD UndBas        AS CHAR     FORMAT 'x(10)'          LABEL 'UNIDAD'
    FIELD MrgUti-A      AS DEC      FORMAT '->>>,>>9.999999'    LABEL '% MARGEN A'
    FIELD Precio-A      AS DEC      FORMAT '>>>,>>9.9999'   LABEL 'PRECIO A'
    FIELD UndA          AS CHAR     FORMAT 'x(8)'           LABEL 'UNIDAD A'
    FIELD MrgUti-B      AS DEC      FORMAT '->>>,>>9.999999'    LABEL '% MARGEN B'
    FIELD Precio-B      AS DEC      FORMAT '>>>,>>9.9999'   LABEL 'PRECIO B'
    FIELD UndB          AS CHAR     FORMAT 'x(8)'           LABEL 'UNIDAD B'
    FIELD MrgUti-C      AS DEC      FORMAT '->>>,>>9.999999'    LABEL '% MARGEN C'
    FIELD Precio-C      AS DEC      FORMAT '>>>,>>9.9999'   LABEL 'PRECIO C'
    FIELD UndC          AS CHAR     FORMAT 'x(8)'           LABEL 'UNIDAD C'
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
&Scoped-define INTERNAL-TABLES prilistaprecios Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table prilistaprecios.CodMat ~
Almmmatg.DesMat Almmmatg.DesMar prilistaprecios.UndBas ~
prilistaprecios.CtoTot prilistaprecios.PreUni prilistaprecios.MrgUti ~
prilistaprecios.UndA prilistaprecios.Precio-A prilistaprecios.MrgUti-A ~
prilistaprecios.UndB prilistaprecios.Precio-B prilistaprecios.MrgUti-B ~
prilistaprecios.UndC prilistaprecios.Precio-C prilistaprecios.MrgUti-C 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table prilistaprecios.PreUni ~
prilistaprecios.MrgUti prilistaprecios.Precio-A prilistaprecios.MrgUti-A ~
prilistaprecios.Precio-B prilistaprecios.MrgUti-B prilistaprecios.Precio-C ~
prilistaprecios.MrgUti-C 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table prilistaprecios
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table prilistaprecios
&Scoped-define QUERY-STRING-br_table FOR EACH prilistaprecios WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF prilistaprecios NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH prilistaprecios WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF prilistaprecios NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table prilistaprecios Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table prilistaprecios
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
      prilistaprecios, 
      Almmmatg
    FIELDS(Almmmatg.DesMat
      Almmmatg.DesMar) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      prilistaprecios.CodMat COLUMN-LABEL "Articulo" FORMAT "X(15)":U
            WIDTH 7.43
      Almmmatg.DesMat FORMAT "X(80)":U WIDTH 56.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 11.43
      prilistaprecios.UndBas COLUMN-LABEL "Unidad" FORMAT "x(8)":U
            WIDTH 5.86
      prilistaprecios.CtoTot COLUMN-LABEL "Costo!(S/ c/IGV)" FORMAT ">>>,>>9.9999":U
            WIDTH 8
      prilistaprecios.PreUni COLUMN-LABEL "Unitario!(S/ c/IGV)" FORMAT ">>>,>>9.9999":U
            WIDTH 7.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      prilistaprecios.MrgUti COLUMN-LABEL "% Utilidad" FORMAT "->>>,>>9.999999":U
            WIDTH 9
      prilistaprecios.UndA COLUMN-LABEL "Und A" FORMAT "x(8)":U
            WIDTH 5.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      prilistaprecios.Precio-A COLUMN-LABEL "Precio A" FORMAT ">>>,>>9.9999":U
            WIDTH 7.86 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      prilistaprecios.MrgUti-A COLUMN-LABEL "% Util A" FORMAT "->>,>>9.999999":U
            WIDTH 8.43
      prilistaprecios.UndB COLUMN-LABEL "Und B" FORMAT "x(8)":U
            WIDTH 6 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      prilistaprecios.Precio-B COLUMN-LABEL "Precio B" FORMAT ">>>,>>9.9999":U
            WIDTH 8.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      prilistaprecios.MrgUti-B COLUMN-LABEL "% Util B" FORMAT "->>,>>9.999999":U
            WIDTH 8.43
      prilistaprecios.UndC COLUMN-LABEL "Und C" FORMAT "x(8)":U
            WIDTH 6.86 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      prilistaprecios.Precio-C COLUMN-LABEL "Precio C" FORMAT ">>>,>>9.9999":U
            WIDTH 8.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      prilistaprecios.MrgUti-C COLUMN-LABEL "% Util C" FORMAT "->>,>>9.999999":U
            WIDTH 7.43
  ENABLE
      prilistaprecios.PreUni
      prilistaprecios.MrgUti
      prilistaprecios.Precio-A
      prilistaprecios.MrgUti-A
      prilistaprecios.Precio-B
      prilistaprecios.MrgUti-B
      prilistaprecios.Precio-C
      prilistaprecios.MrgUti-C
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 187 BY 6.46
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
         HEIGHT             = 6.88
         WIDTH              = 187.72.
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
     _TblList          = "INTEGRAL.prilistaprecios,INTEGRAL.Almmmatg OF INTEGRAL.prilistaprecios"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.prilistaprecios.CodMat
"prilistaprecios.CodMat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(80)" "character" ? ? ? ? ? ? no ? no no "56.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.prilistaprecios.UndBas
"prilistaprecios.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.prilistaprecios.CtoTot
"prilistaprecios.CtoTot" "Costo!(S/ c/IGV)" ">>>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.prilistaprecios.PreUni
"prilistaprecios.PreUni" "Unitario!(S/ c/IGV)" ">>>,>>9.9999" "decimal" 11 0 ? ? ? ? yes ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.prilistaprecios.MrgUti
"prilistaprecios.MrgUti" "% Utilidad" ? "decimal" ? ? ? ? ? ? yes ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.prilistaprecios.UndA
"prilistaprecios.UndA" "Und A" ? "character" 14 0 ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.prilistaprecios.Precio-A
"prilistaprecios.Precio-A" "Precio A" ? "decimal" 14 0 ? ? ? ? yes ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.prilistaprecios.MrgUti-A
"prilistaprecios.MrgUti-A" "% Util A" ? "decimal" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.prilistaprecios.UndB
"prilistaprecios.UndB" "Und B" ? "character" 10 0 ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.prilistaprecios.Precio-B
"prilistaprecios.Precio-B" "Precio B" ? "decimal" 10 0 ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.prilistaprecios.MrgUti-B
"prilistaprecios.MrgUti-B" "% Util B" ? "decimal" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.prilistaprecios.UndC
"prilistaprecios.UndC" "Und C" ? "character" 11 0 ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.prilistaprecios.Precio-C
"prilistaprecios.Precio-C" "Precio C" ? "decimal" 11 0 ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.prilistaprecios.MrgUti-C
"prilistaprecios.MrgUti-C" "% Util C" ? "decimal" ? ? ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME prilistaprecios.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prilistaprecios.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF prilistaprecios.PreUni IN BROWSE br_table /* Unitario!(S/ c/IGV) */
DO:
  x-Margen = 0.
  IF prilistaprecios.CtoTot <> 0 THEN
      x-Margen = (DECIMAL(SELF:SCREEN-VALUE) - prilistaprecios.CtoTot) / prilistaprecios.CtoTot * 100.
  DISPLAY 
      x-Margen @ prilistaprecios.MrgUti 
      x-Margen @ prilistaprecios.MrgUti-A
      SELF:SCREEN-VALUE @ prilistaprecios.Precio-A
      WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prilistaprecios.Precio-B
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prilistaprecios.Precio-B br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF prilistaprecios.Precio-B IN BROWSE br_table /* Precio B */
DO:
     X-CTOUND = prilistaprecios.CtoTot.
     F-FACTOR = 1.
     F-MrgUti-B = 0.
     F-PreVta-B = DECIMAL(SELF:SCREEN-VALUE).
     /****   Busca el Factor de conversion   ****/
     IF prilistaprecios.UndB > "" THEN DO:
         FIND Almtconv WHERE Almtconv.CodUnid = prilistaprecios.UndBas
             AND  Almtconv.Codalter = prilistaprecios.UndB
             NO-LOCK NO-ERROR.
         IF NOT AVAILABLE Almtconv THEN DO:
             MESSAGE "Codigo de unidad de CONVERSION no existe" VIEW-AS ALERT-BOX ERROR.
             RETURN NO-APPLY.
         END.
         F-FACTOR = Almtconv.Equival.
         F-MrgUti-B = ROUND( ( (F-PreVta-B / F-FACTOR / X-CTOUND) - 1 ) * 100, 6).
     END.
     DISPLAY F-MrgUti-B @ prilistaprecios.MrgUti-B WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prilistaprecios.Precio-C
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prilistaprecios.Precio-C br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF prilistaprecios.Precio-C IN BROWSE br_table /* Precio C */
DO:
    X-CTOUND = prilistaprecios.CtoTot.
    F-FACTOR = 1.
    F-MrgUti-C = 0.
    F-PreVta-C = DECIMAL(SELF:SCREEN-VALUE).
    /****   Busca el Factor de conversion   ****/
    IF prilistaprecios.UndC > "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = prilistaprecios.UndBas
            AND  Almtconv.Codalter = prilistaprecios.UndC
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE "Codigo de unidad de CONVERSION no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti-C = ROUND(( (F-PreVta-C / F-FACTOR / X-CTOUND) - 1 ) * 100, 6).
    END.
    DISPLAY F-MrgUti-C @ prilistaprecios.MrgUti-C WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON FIND OF PriListaPrecios DO:
    IF NOT x-Linea = 'Todas' AND 
        NOT CAN-FIND(FIRST Almmmatg OF PriListaPrecios WHERE Almmmatg.CodFam = x-Linea NO-LOCK)
        THEN RETURN ERROR.
    IF x-CodPro > '' AND 
        NOT CAN-FIND(FIRST Almmmatg OF PriListaPrecios WHERE Almmmatg.CodPr1 = x-CodPro NO-LOCK)
        THEN RETURN ERROR.
    x-Margen = 0.
    IF prilistaprecios.CtoTot <> 0 THEN
        x-Margen = (prilistaprecios.PreUni - prilistaprecios.CtoTot) / prilistaprecios.CtoTot * 100.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aplicar-Filtros B-table-Win 
PROCEDURE Aplicar-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCanal AS CHAR.
DEF INPUT PARAMETER pGrupo AS CHAR.
DEF INPUT PARAMETER pLinea AS CHAR.
DEF INPUT PARAMETER pCodPro AS CHAR.

IF TRUE <> (pCanal > '') THEN RETURN.
IF TRUE <> (pGrupo > '') THEN RETURN.

ASSIGN
    x-Canal = pCanal
    x-Grupo = pGrupo
    x-Linea = pLinea
    x-CodPro = pCodPro.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Lista-Precios B-table-Win 
PROCEDURE Carga-Temporal-Lista-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF VAR x-margen AS DEC.

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE PriListaPrecios:
    FIND FIRST Almmmatg OF PriListaPrecios NO-LOCK NO-ERROR.
    CREATE Detalle.
    BUFFER-COPY PriListaPrecios TO Detalle.
    ASSIGN
        Detalle.DesMat = (IF AVAILABLE Almmmatg THEN Almmmatg.DesMat ELSE '')
        Detalle.DesMar = (IF AVAILABLE Almmmatg THEN Almmmatg.DesMar ELSE '')
        Detalle.CodFam = (IF AVAILABLE Almmmatg THEN Almmmatg.CodFam ELSE '')
        Detalle.SubFam = (IF AVAILABLE Almmmatg THEN Almmmatg.SubFam ELSE '').
    FIND PriCanal WHERE pricanal.CodCia = prilistaprecios.CodCia AND 
        pricanal.Canal = prilistaprecios.Canal
        NO-LOCK NO-ERROR.
    IF AVAILABLE PriCanal THEN Detalle.Canal = pricanal.Canal + " - " + pricanal.Descripcion.
    FIND PriGrupo WHERE prigrupo.CodCia = prilistaprecios.CodCia AND
        prigrupo.Grupo = prilistaprecios.Grupo
        NO-LOCK NO-ERROR.
    IF AVAILABLE PriGrupo THEN Detalle.Grupo = prigrupo.Grupo + " - " + prigrupo.Descripcion.
    /* Datos adicionales */
    FIND FIRST Almtfami OF Almmmatg NO-LOCK NO-ERROR.
    FIND FIRST Almsfami OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almtfami THEN Detalle.CodFam = Almtfami.codfam + ' ' + Almtfami.desfam.
    IF AVAILABLE Almsfami THEN Detalle.CodFam = Almsfami.subfam + ' ' + AlmSFami.dessub.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = Almmmatg.codpr1 NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN Detalle.codpro = gn-prov.CodPro + ' ' + gn-prov.NomPro.

    GET NEXT {&browse-name}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Lista-Precios B-table-Win 
PROCEDURE Excel-Lista-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Plantilla_Lista_Precios' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

/* ******************************************************************************** */
/* Buscamos la plantilla */
/* ******************************************************************************** */
DEF VAR lFileXls AS CHAR NO-UNDO.
DEF VAR lNuevoFile AS LOG NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta'  VALUE lFileXls.
lFileXls = lFileXls + 'Plantilla_Lista_Precios.xltx'.
FILE-INFO:FILE-NAME = lFileXls.
IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
    MESSAGE 'La plantilla ' lFileXls SKIP 'NO existe' VIEW-AS ALERT-BOX.
    RETURN.
END.
SESSION:SET-WAIT-STATE('GENERAL').
/* ******************************************************************************** */
/* Cargamos la informacion al temporal */
/* ******************************************************************************** */
EMPTY TEMP-TABLE Detalle.
RUN Carga-Temporal-Lista-Precios.
/* ******************************************************************************** */
/* Programas que generan el Excel */
/* ******************************************************************************** */
lNuevoFile = NO.    /* Abre la plantilla lFileXls */
{lib/excel-open-file.i}
/* ******************************************************************************** */
/* LOGICA PRINCIPAL: CARGA DEL EXCEL */
/* ******************************************************************************** */
/* Select a worksheet */
chWorkbook:Worksheets(1):Activate.
chWorksheet = chWorkbook:Worksheets(1).
/* Cargamos al revés */
DEF VAR LocalRow AS INT NO-UNDO.
iRow = 2.
LocalRow = 2.
FOR EACH Detalle NO-LOCK 
    BY Detalle.Canal DESCENDING BY Detalle.Grupo DESCENDING BY Detalle.CodMat DESCENDING:
    /*Agrega Row*/
    chWorkSheet:Range("A2"):EntireRow:INSERT.
    /* Grabar */
    /*iRow = iRow + 1.*/
    LocalRow = LocalRow + 1.
    cColumn = STRING(iRow).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CodFam.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.SubFam.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CodPro.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Canal.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Grupo.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoTot.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.PreUni.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.MrgUti.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.UndBas.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.MrgUti-A.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Precio-A.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.UndA.
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.MrgUti-B.
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Precio-B.
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.UndB.
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.MrgUti-C.
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Precio-C.
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.UndC.
END.
/* Borramos librerias de la memoria */
/* Delete Row*/
chWorkSheet:Range("A" + STRING(LocalRow)):EntireRow:DELETE.
SESSION:SET-WAIT-STATE('').
lNuevoFile = YES.           /* Graba la plantilla en el nuevo archivo */
lFileXls = c-xls-file.
lCerrarAlTerminar = YES.     /* NO Se hace visible al terminar */
lMensajeAlTerminar = YES.   /* Aviso que terminó el proceso */
{lib/excel-close-file.i}


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
  x-Margen = 0.
  IF prilistaprecios.CtoTot <> 0 THEN
      x-Margen = (prilistaprecios.PreUni - prilistaprecios.CtoTot) / prilistaprecios.CtoTot * 100.
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
  ASSIGN
      prilistaprecios.MrgUti:READ-ONLY IN BROWSE {&browse-name} = YES
      prilistaprecios.Precio-A:READ-ONLY IN BROWSE {&browse-name} = YES
      prilistaprecios.MrgUti-A:READ-ONLY IN BROWSE {&browse-name} = YES
      prilistaprecios.MrgUti-B:READ-ONLY IN BROWSE {&browse-name} = YES
      prilistaprecios.MrgUti-C:READ-ONLY IN BROWSE {&browse-name} = YES.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      IF TRUE <> (prilistaprecios.UndA > '') THEN prilistaprecios.Precio-A:READ-ONLY IN BROWSE {&browse-name} = YES.
      IF TRUE <> (prilistaprecios.UndB > '') THEN prilistaprecios.Precio-B:READ-ONLY IN BROWSE {&browse-name} = YES.
      IF TRUE <> (prilistaprecios.UndC > '') THEN prilistaprecios.Precio-C:READ-ONLY IN BROWSE {&browse-name} = YES.
  END.
  ELSE DO:
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
  RUN Open-Browses IN lh_handle.

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
  {src/adm/template/snd-list.i "prilistaprecios"}
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

    /* Ic - 12Dic2016, Validar el MARGEN DE UTILIDAD */
    FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia AND 
        VtaTabla.tabla = 'MMLX' AND 
        VtaTabla.llave_c1 = PriListaPrecios.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE vtatabla THEN DO:
        /* El Articulo no esta en la tabla de Excepcion de Margen de Utilidad */
        IF DECIMAL(PriListaPrecios.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
           MESSAGE "Margen Utilidad C Negativo......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO PriListaPrecios.Precio-C.
           RETURN "ADM-ERROR".      
        END.
        IF DECIMAL(PriListaPrecios.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
           MESSAGE "Margen Utilidad B Negativo......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO PriListaPrecios.Precio-B.
           RETURN "ADM-ERROR".      
        END.

        IF DECIMAL(PriListaPrecios.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
           MESSAGE "Margen Utilidad Negativo......" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO PriListaPrecios.PreUni.
           RETURN "ADM-ERROR".      
        END.

       IF DECIMAL(PriListaPrecios.MrgUti-C:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > DECIMAL(PriListaPrecios.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
          MESSAGE "Margen de util. C es mayor que el margen de util. B" SKIP
                "Margen Utilidad Incorrecto......" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO PriListaPrecios.Precio-C.
          RETURN "ADM-ERROR".      
       END.
    
       IF DECIMAL(PriListaPrecios.MrgUti-B:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > DECIMAL(PriListaPrecios.MrgUti-A:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
          MESSAGE "Margen de util. B es mayor que el margen de util. A" SKIP
                "Margen Utilidad Incorrecto......" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO PriListaPrecios.Precio-B.
          RETURN "ADM-ERROR".      
       END.

    END.


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

