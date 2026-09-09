&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE BUFFER i-Almmmate FOR Almmmate.
DEFINE SHARED TEMP-TABLE T-DREPO LIKE almdrepo.



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

DEF NEW SHARED VAR s-CodMat AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-nivel-acceso AS INT.

DEF BUFFER bt-drepo FOR t-drepo.

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
&Scoped-define INTERNAL-TABLES T-DREPO Almmmatg Almmmate i-Almmmate

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DREPO.CodMat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.UndBas T-DREPO.AlmPed T-DREPO.CanReq ~
T-DREPO.CanGen T-DREPO.Origen Almmmate.StkAct Almmmate.StkMin ~
Almmmate.StkMax Almmmatg.tiprot[1] ~
T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot ~
i-Almmmate.StkAct i-Almmmate.StkMin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-DREPO.CodMat ~
T-DREPO.CanReq 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-DREPO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-DREPO
&Scoped-define QUERY-STRING-br_table FOR EACH T-DREPO WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-DREPO  NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-codalm NO-LOCK, ~
      FIRST i-Almmmate OF Almmmatg ~
      WHERE i-Almmmate.CodAlm = '65s' NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DREPO WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-DREPO  NO-LOCK, ~
      FIRST Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-codalm NO-LOCK, ~
      FIRST i-Almmmate OF Almmmatg ~
      WHERE i-Almmmate.CodAlm = '65s' NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-DREPO Almmmatg Almmmate ~
i-Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DREPO
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table i-Almmmate


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-1 br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 f-Mensaje 

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
Codigo|y||INTEGRAL.Almmmatg.codmat|yes
Familia|||INTEGRAL.Almmmatg.codfam|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'Codigo,Familia' + '",
     SortBy-Case = ':U + 'Codigo').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Codigo" 
     LABEL "Ordenado por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Codigo","Familia" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DREPO, 
      Almmmatg, 
      Almmmate, 
      i-Almmmate SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-DREPO.CodMat COLUMN-LABEL "<Codigo>" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 45
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U WIDTH 9.43
      Almmmatg.UndBas COLUMN-LABEL "Unidad" FORMAT "X(7)":U WIDTH 8.43
      T-DREPO.AlmPed COLUMN-LABEL "Almacén!Despacho" FORMAT "x(3)":U
      T-DREPO.CanReq COLUMN-LABEL "Cantidad!Requerida" FORMAT "ZZZ,ZZ9.9999":U
            WIDTH 8.43
      T-DREPO.CanGen FORMAT "ZZZ,ZZ9.9999":U WIDTH 7.43 COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      T-DREPO.Origen FORMAT "x(3)":U
      Almmmate.StkAct COLUMN-LABEL "Stock!Actual 65" FORMAT "(ZZZ,ZZ9.99)":U
            WIDTH 7.14
      Almmmate.StkMin COLUMN-LABEL "Stock!Mínimo 65" FORMAT "ZZ,ZZ9.99":U
            WIDTH 6.72
      Almmmate.StkMax COLUMN-LABEL "Empaque" FORMAT "ZZZ,ZZ9.99":U
      Almmmatg.tiprot[1] COLUMN-LABEL "Clasif." FORMAT "x(1)":U
      T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot COLUMN-LABEL "Costo de!Reposición"
            WIDTH 9.72
      i-Almmmate.StkAct COLUMN-LABEL "Stock !Actual 65s" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 10.57
      i-Almmmate.StkMin COLUMN-LABEL "Stock!Minimo 65s" FORMAT "Z,ZZZ,ZZ9.99":U
  ENABLE
      T-DREPO.CodMat
      T-DREPO.CanReq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 141 BY 13.19
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-1 AT ROW 1 COL 12 COLON-ALIGNED WIDGET-ID 6
     f-Mensaje AT ROW 1 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     br_table AT ROW 2.08 COL 1
     "F8: Consulta de stocks             Doble Clic: Consulta de Movimientos" VIEW-AS TEXT
          SIZE 48 BY .5 AT ROW 15.54 COL 2 WIDGET-ID 8
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
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: i-Almmmate B "?" ? INTEGRAL Almmmate
      TABLE: T-DREPO T "SHARED" ? INTEGRAL almdrepo
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
         HEIGHT             = 16.42
         WIDTH              = 142.29.
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
/* BROWSE-TAB br_table f-Mensaje F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-DREPO,INTEGRAL.Almmmatg OF Temp-Tables.T-DREPO ,INTEGRAL.Almmmate OF INTEGRAL.Almmmatg,i-Almmmate OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST, FIRST"
     _Where[3]         = "INTEGRAL.Almmmate.CodAlm = s-codalm"
     _Where[4]         = "INTEGRAL.i-Almmmate.CodAlm = '65s'"
     _FldNameList[1]   > Temp-Tables.T-DREPO.CodMat
"T-DREPO.CodMat" "<Codigo>" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" "X(7)" "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DREPO.AlmPed
"T-DREPO.AlmPed" "Almacén!Despacho" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DREPO.CanReq
"T-DREPO.CanReq" "Cantidad!Requerida" ? "decimal" ? ? ? ? ? ? yes ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DREPO.CanGen
"T-DREPO.CanGen" ? ? "decimal" 11 9 ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.T-DREPO.Origen
     _FldNameList[9]   > INTEGRAL.Almmmate.StkAct
"Almmmate.StkAct" "Stock!Actual 65" "(ZZZ,ZZ9.99)" "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.Almmmate.StkMin
"Almmmate.StkMin" "Stock!Mínimo 65" "ZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.Almmmate.StkMax
"Almmmate.StkMax" "Empaque" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.Almmmatg.tiprot[1]
"Almmmatg.tiprot[1]" "Clasif." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot) @ Almmmatg.CtoTot" "Costo de!Reposición" ? ? ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.i-Almmmate.StkAct
"i-Almmmate.StkAct" "Stock !Actual 65s" ? "decimal" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.i-Almmmate.StkMin
"i-Almmmate.StkMin" "Stock!Minimo 65s" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON F8 OF br_table IN FRAME F-Main
DO:
    S-CODMAT = Almmmatg.CodMat.
    RUN vta/d-stkalm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:
    RUN ALM/D-DETMOV.R (s-codalm, almmmatg.codmat, almmmatg.desmat).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' 
      THEN T-DREPO.CanReq:SCREEN-VALUE IN BROWSE {&browse-name} = '0.00'.


/*   IF AVAILABLE T-DREPO AND T-DREPO.Origen = 'AUT'                 */
/*   THEN DO:                                                        */
/*       ASSIGN                                                      */
/*           T-DREPO.CodMat:READ-ONLY = YES                          */
/*           T-DREPO.AlmPed:READ-ONLY = YES.                         */
/*       APPLY 'entry':U TO T-DREPO.CanReq IN BROWSE {&browse-name}. */
/*   END.                                                            */
/*   ELSE DO:                                                        */
/*       ASSIGN                                                      */
/*           T-DREPO.CodMat:READ-ONLY = NO                           */
/*           T-DREPO.AlmPed:READ-ONLY = NO.                          */
/*       APPLY 'entry':U TO T-DREPO.CodMat IN BROWSE {&browse-name}. */
/*   END.                                                            */
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


&Scoped-define SELF-NAME T-DREPO.CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DREPO.CodMat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DREPO.CodMat IN BROWSE br_table /* <Codigo> */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),'999999')
        NO-ERROR.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' AND T-DREPO.Origen = 'AUT' AND SELF:SCREEN-VALUE <>  T-DREPO.CodMat THEN DO:
        MESSAGE 'NO está permitido cambiar el producto' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = T-DREPO.CodMat .
        RETURN NO-APPLY.
    END.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'Producto NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    DISPLAY
        Almmmatg.DesMar Almmmatg.DesMat Almmmatg.UndBas
        s-codalm @  T-DREPO.AlmPed 
        WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DREPO.AlmPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DREPO.AlmPed br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DREPO.AlmPed IN BROWSE br_table /* Almacén!Despacho */
DO:
/*     FIND Almmmatg WHERE Almmmatg.codcia = s-codcia                                                   */
/*         AND Almmmatg.codmat = T-DREPO.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} NO-LOCK NO-ERROR. */
/*     IF AVAILABLE Almmmatg                                                                            */
/*         THEN DISPLAY Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndBas                                 */
/*                   WITH BROWSE {&browse-name}.                                                        */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DREPO.AlmPed br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF T-DREPO.AlmPed IN BROWSE br_table /* Almacén!Despacho */
OR f8 OF t-drepo.almped
DO:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DREPO.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN RETURN NO-APPLY.
  ASSIGN
      input-var-1 = s-codalm
      input-var-2 = almmmatg.CHR__02
      input-var-3 = ''.
  RUN lkup/c-almrep ('Almacenes de Reposicion').
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME F-Main /* Ordenado por */
DO:
    RUN set-attribute-list('SortBy-Case=' + SELF:SCREEN-VALUE).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'return':U OF T-DREPO.AlmPed, T-DREPO.CodMat
DO:
    APPLY 'tab':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'Codigo':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.codmat
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Familia':U THEN DO:
      &Scope SORTBY-PHRASE BY Almmmatg.codfam
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pMarca  AS CHAR.
DEF INPUT PARAMETER pCodFam AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

EMPTY TEMP-TABLE t-drepo.

DEF VAR pRowid AS ROWID.
DEF VAR pDiasUtiles AS INT.
DEF VAR pVentaDiaria AS DEC.
DEF VAR pDiasMinimo AS INT.
DEF VAR pReposicion AS DEC.
DEF VAR pComprometido AS DEC.

DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-Item AS INT INIT 1 NO-UNDO.
DEF VAR x-CanReq LIKE T-DREPO.CanReq.
DEF VAR x-StkAct LIKE Almmmate.StkAct NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE t-drepo.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Buscando información, un momento por favor'.

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia 
    AND Almmmate.codalm = s-codalm,
    FIRST almmmatg OF almmmate NO-LOCK WHERE Almmmatg.TpoArt <> 'D'
    AND Almmmatg.codpr1 BEGINS pCodPro
    AND Almmmatg.desmar BEGINS pMarca:
    /* FILTROS */
    IF pCodFam <> '' THEN DO:
        IF LOOKUP(Almmmatg.codfam, pCodFam) = 0 THEN NEXT.
    END.
    /* ******* */
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + Almmmate.codmat.

    /* Venta Diaria */
    ASSIGN
        pDiasMinimo = AlmCfgGn.DiasMinimo
        pDiasUtiles = AlmCfgGn.DiasUtiles.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov AND gn-prov.StkMin > 0 THEN pDiasMinimo = gn-prov.StkMin.

    /* VA A HABER 2 FORMAS DE CALCULARLO:
        MANUAL: SIEMPRE Y CUANDO EL CAMPO ALMMMATE.STKMIN > 0 
        POR HISTORICOS: CUANDO EL CAMPO ALMMMATE.STKMIN = 0
        */
    IF Almmmate.StkMin = 0 THEN DO:     /* DEL HISTORICO */
        ASSIGN
            pRowid = ROWID(Almmmate)
            /*pVentaDiaria = Almmmate.StkRep*/
            pVentaDiaria = DECIMAL(Almmmate.Libre_c04).
        /* Stock Minimo */
        ASSIGN
            x-StockMinimo = pDiasMinimo * pVentaDiaria
            x-StkAct = Almmmate.StkAct.
        IF pCodAlm <> '' THEN DO:
            DO k = 1 TO NUM-ENTRIES(pCodAlm):
                IF ENTRY(k, pCodAlm) = s-codalm THEN NEXT.   /* NO del almacen activo */
                FIND B-MATE WHERE B-MATE.codcia = s-codcia
                    AND B-MATE.codalm = ENTRY(k, pCodAlm)
                    AND B-MATE.codmat = Almmmate.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MATE THEN x-StkAct = x-StkAct + B-MATE.StkAct.
            END.
        END.
        IF x-StkAct >= x-StockMinimo THEN NEXT.
        /* Cantidad de Reposicion */
        RUN gn/cantidad-de-reposicion (pRowid, pVentaDiaria, OUTPUT pReposicion).
        IF pReposicion <= 0 THEN NEXT.
        /* RHC 15/10/2012 Tiene venta diaria pero no historico */
        /*IF Almmmate.StkRep > 0 AND Almmmate.Libre_d01 > 0 THEN DO:*/
        /* RHC 05/12/2012 NO tiene histórico */
        IF Almmmate.Libre_C01 = "SIN HISTORICO" THEN DO:
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "997"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = pReposicion
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
            NEXT.
        END.
    END.
    IF Almmmate.StkMin > 0 THEN DO:     /* MANUAL */
        /* Stock Minimo */
        ASSIGN
            x-StockMinimo = Almmmate.StkMin
            x-StkAct = Almmmate.StkAct.
        IF pCodAlm <> '' THEN DO:
            DO k = 1 TO NUM-ENTRIES(pCodAlm):
                IF ENTRY(k, pCodAlm) = s-codalm THEN NEXT.   /* NO del almacen activo */
                FIND B-MATE WHERE B-MATE.codcia = s-codcia
                    AND B-MATE.codalm = ENTRY(k, pCodAlm)
                    AND B-MATE.codmat = Almmmate.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE B-MATE THEN x-StkAct = x-StkAct + B-MATE.StkAct.
            END.
        END.
        IF x-StkAct >= x-StockMinimo THEN NEXT.
        /* Cantidad de Reposicion */
        pReposicion = x-StockMinimo - x-StkAct.
    END.
    /* distribuimos el pedido entre los almacenes de despacho */
    IF Almmmatg.Chr__02 = "P" THEN x-TipMat = "P". ELSE x-TipMat = "T".
    FOR EACH Almrepos NO-LOCK WHERE  almrepos.CodCia = s-codcia
        AND almrepos.CodAlm = Almmmate.codalm 
        AND almrepos.AlmPed <> Almmmate.codalm
        AND almrepos.TipMat = x-TipMat      /* Propios o Terceros */
        AND pReposicion > 0 /* <<< OJO <<< */
        BY almrepos.Orden:
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codmat = Almmmate.codmat
            AND B-MATE.codalm = Almrepos.almped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN NEXT.
/*         RUN vta2/Stock-Comprometido (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido). */
        RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almrepos.AlmPed, OUTPUT pComprometido).
        x-StockDisponible = B-MATE.StkAct - x-StockMinimo - pComprometido.
        IF x-StockDisponible <= 0 THEN NEXT.
        /* Se solicitará la reposición de acuerdo al empaque del producto */
        x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
        IF Almmmatg.CanEmp > 0 THEN DO:
            /*x-CanReq = TRUNCATE(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.*/
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
        /* Redondeamos la cantidad a enteros */
        IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
            x-CanReq = TRUNCATE(x-CanReq,0) + 1.
        END.
        /* ********************************* */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.Origen = 'AUT'
            T-DREPO.CodCia = s-codcia 
            T-DREPO.CodAlm = s-codalm 
            T-DREPO.Item = x-Item
            T-DREPO.AlmPed = Almrepos.almped
            T-DREPO.CodMat = Almmmate.codmat
            T-DREPO.CanReq = x-CanReq
            T-DREPO.CanGen = x-CanReq
            T-DREPO.StkAct = x-StockDisponible.
        ASSIGN
            x-Item = x-Item + 1
            pReposicion = pReposicion - T-DREPO.CanReq.
    END.
    /* RHC 15/10/2012 si queda un saldo lo pintamos en el almacén 998 */
    IF pReposicion > 0 THEN DO:
        x-CanReq = pReposicion.
        IF Almmmatg.CanEmp > 0 THEN DO:
            /*x-CanReq = TRUNCATE(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.*/
            x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
        END.
        IF x-CanReq > 0 THEN DO:
            /* Redondeamos la cantidad a enteros */
            IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                x-CanReq = TRUNCATE(x-CanReq,0) + 1.
            END.
            /* ********************************* */
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm
                T-DREPO.Item = x-Item
                T-DREPO.AlmPed = "998"
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = 0
                T-DREPO.CanGen = x-CanReq
                /*T-DREPO.CanGen = pReposicion*/
                T-DREPO.StkAct = 0.
            x-Item = x-Item + 1.
        END.
    END.
END.

FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESO TERMINADO ***'.

RUN dispatch IN THIS-PROCEDURE ('adm-open-query').

SESSION:SET-WAIT-STATE('').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.
/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().
/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Titulos */
chWorkSheet:Range("A2"):VALUE = "Código".
chWorkSheet:Range("B2"):VALUE = "Descripcion".
chWorkSheet:Range("C2"):VALUE = "Marca".
chWorkSheet:Range("D2"):VALUE = "Unidad".
chWorkSheet:Range("E2"):VALUE = "Almacén Despacho".
chWorkSheet:Range("F2"):VALUE = "Cantidad Requerida".
chWorkSheet:Range("G2"):VALUE = "Cantidad Generada".
chWorkSheet:Range("H2"):VALUE = "Origen".
chWorkSheet:Range("I2"):VALUE = "Zona".
chWorkSheet:Range("J2"):VALUE = "Clasificacion".
chWorkSheet:Range("K2"):VALUE = "Costo de Reposicion".

/*chWorkSheet:COLUMNS("B"):NumberFormat = "dd/MM/yyyy".*/
chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
/* Encabezado de Control */
chWorkSheet:Range("A1"):VALUE = "PEDIDO DE REPOSICION - " + TRIM(s-CodAlm).
t-Row = 2.
chWorkSheet = chExcelApplication:Sheets:Item(1).
FOR EACH bt-drepo NO-LOCK, FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codalm = s-codalm AND Almmmate.codmat = bt-drepo.codmat:
    t-Row = t-Row + 1.
    t-Column = 1.
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = BT-DREPO.CodMat NO-LOCK NO-ERROR.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.CodMat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMar.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.UndBas.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.AlmPed.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.CanReq.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.CanGen.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = BT-DREPO.Origen.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmate.codubi.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.TipRot[1].
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-DREPO.CanGen * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot).
END.
/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel B-table-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE FILL-IN-Archivo AS CHAR         NO-UNDO.
    DEFINE VARIABLE OKpressed       AS LOG          NO-UNDO.
    DEFINE VARIABLE chExcelApplication          AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook                  AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet                 AS COM-HANDLE.
    DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
    DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
    DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
    DEFINE VARIABLE pMensaje        AS CHAR         NO-UNDO.

    /* RUTINA GENERAL */
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.

    /* CREAMOS LA HOJA EXCEL */
    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    SESSION:SET-WAIT-STATE('GENERAL').

    ASSIGN
        t-Column = 0
        t-Row = 1.    
    /* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
    cValue = chWorkSheet:Cells(1,1):VALUE.
    IF cValue = "" OR cValue = ? THEN DO:
        MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF NOT cValue = "PEDIDO DE REPOSICION - " + TRIM(s-CodAlm) THEN DO:
        MESSAGE 'Formato del archivo Excel errado' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    /* ******************* */
    /* CARGAMOS TEMPORALES */
    EMPTY TEMP-TABLE T-DREPO.
    ASSIGN
        pMensaje = ""
        t-Row = 2.     /* Saltamos el encabezado de los campos */
    REPEAT:
        ASSIGN
            t-Row    = t-Row + 1.
        t-column = 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
        /* CODIGO */
        CREATE T-DREPO.
        ASSIGN
            T-DREPO.codcia = s-codcia
            T-DREPO.codmat = cValue
            T-DREPO.Origen = 'MAN'.
        /* ALMACEN */
        t-Column = 5.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DREPO.almped = cValue.
        /* CANTIDAD */        
        t-Column = 7.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DREPO.CanReq = DECIMAL(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "Cantidad Requerida".
            LEAVE.
        END.
        ASSIGN
            T-DREPO.CanGen = T-DREPO.CanReq.
    END.
    IF pMensaje <> "" THEN DO:
        EMPTY TEMP-TABLE T-DREPO.
        RETURN.
    END.
    /* DEPURAMOS */
    FOR EACH T-DREPO:
        IF T-DREPO.CanReq = 0 THEN DO:
            DELETE T-DREPO.
            NEXT.
        END.
        FIND Almmmatg OF T-DREPO NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN DO:
            DELETE T-DREPO.
            NEXT.
        END.
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = T-DREPO.AlmPed
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen THEN DO:
            DELETE T-DREPO.
            NEXT.
        END.
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = T-DREPO.AlmPed
            AND Almmmate.codmat = T-DREPO.CodMat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            DELETE T-DREPO.
            NEXT.
        END.
    END.
    SESSION:SET-WAIT-STATE('').

    /* CERRAMOS EL EXCEL */
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    /* Mensaje de error de carga */
    IF pMensaje <> "" THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        EMPTY TEMP-TABLE T-DREPO.
    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).


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
  IF s-nivel-acceso <> 1 THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  COMBO-BOX-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
  DEF VAR x-Item AS INT NO-UNDO INIT 1.
  
  FOR EACH BT-DREPO BY BT-DREPO.Item:
      x-Item = BT-DREPO.ITEM + 1.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
       T-DREPO.CodCia = s-codcia
      T-DREPO.AlmPed = T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' 
      THEN ASSIGN
            T-DREPO.Origen = 'MAN'
            T-DREPO.ITEM   = x-Item.
  IF T-DREPO.Origen = 'MAN' THEN T-DREPO.CanGen = T-DREPO.CanReq.

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
  COMBO-BOX-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
/*   IF AVAILABLE T-DREPO AND T-DREPO.Origen = 'AUT' THEN DO: */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.   */
/*       RETURN 'ADM-ERROR'.                                  */
/*   END.                                                     */

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
  IF RETURN-VALUE = 'NO' THEN DO:
      IF T-DREPO.Origen = 'AUT' 
          THEN ASSIGN 
                T-DREPO.CodMat:READ-ONLY IN BROWSE {&browse-name} = YES.
                /*T-DREPO.AlmPed:READ-ONLY IN BROWSE {&browse-name} = YES.*/
          ELSE ASSIGN
                T-DREPO.CodMat:READ-ONLY IN BROWSE {&browse-name} = NO.
                /*T-DREPO.AlmPed:READ-ONLY IN BROWSE {&browse-name} = NO.*/

  END.
  ELSE DO:
      T-DREPO.CodMat:READ-ONLY IN BROWSE {&browse-name} = NO.
      /*T-DREPO.AlmPed:READ-ONLY IN BROWSE {&browse-name} = NO.*/
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
  COMBO-BOX-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
        WHEN "AlmPed" THEN 
            ASSIGN
                input-var-1 = s-codalm
                input-var-2 = ""
                input-var-3 = "".
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
  {src/adm/template/snd-list.i "T-DREPO"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "i-Almmmate"}

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

DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.

RUN GET-ATTRIBUTE('adm-new-record').
IF RETURN-VALUE = 'yes' THEN DO:
    FIND FIRST bt-drepo WHERE bt-drepo.codmat = T-DREPO.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
        AND BT-DREPO.AlmPed = T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
        AND ROWID(BT-DREPO) <> ROWID(T-DREPO)
        NO-LOCK NO-ERROR.
    IF AVAILABLE bt-drepo THEN DO:
        MESSAGE 'Material ya registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO T-DREPO.CodMat IN BROWSE {&browse-name}.
        RETURN 'ADM-ERROR'.
    END.
END.
ELSE DO:
/*     IF T-DREPO.CanGen > 0 AND DECIMAL(T-DREPO.CanReq:SCREEN-VALUE IN BROWSE {&browse-name}) > T-DREPO.CanGen */
/*     THEN DO:                                                                                                 */
/*         MESSAGE 'La cantidad no puede ser mayor a la generada autoáticamente'                                */
/*             VIEW-AS ALERT-BOX ERROR.                                                                         */
/*         APPLY 'entry':U TO T-DREPO.CanReq IN BROWSE {&browse-name}.                                          */
/*         RETURN 'ADM-ERROR'.                                                                                  */
/*     END.                                                                                                     */
END.
IF DECIMAL(T-DREPO.CanReq:SCREEN-VALUE IN BROWSE {&browse-name}) < 0 THEN DO:
    MESSAGE 'La cantidad debe ser mayor o igual a cero' VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry':U TO T-DREPO.CanReq IN BROWSE {&browse-name}.
    RETURN 'ADM-ERROR'.
END.
/* Dos casos:
Automático: debe ser un almacén de reposición
Manual: debe ser un almacén de venta
*/
RUN GET-ATTRIBUTE('adm-new-record').
CASE TRUE:
    WHEN RETURN-VALUE = 'YES' OR T-DREPO.Origen:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "MAN" 
        THEN DO:
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen OR Almacen.Campo-C[6] = "No" THEN DO:
            MESSAGE 'Almacén NO válido' VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry':U TO T-DREPO.AlmPed IN BROWSE {&browse-name}.
            RETURN 'ADM-ERROR'.
        END.
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
            AND Almmmate.codmat = T-DREPO.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            MESSAGE 'Código NO asignado en el almacén' T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry':U TO T-DREPO.CodMat IN BROWSE {&browse-name}.
            RETURN 'ADM-ERROR'.
        END.
        /* Control de stock */
        ASSIGN
            x-StkAct = Almmmate.StkAct.
        /* DESCONTAMOS LO COMPROMETIDO */
/*         RUN vta2/Stock-Comprometido (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT pComprometido). */
        RUN vta2/Stock-Comprometido-v2 (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT pComprometido).
        x-StkAct = x-StkAct - pComprometido.
        IF x-StkAct < INPUT T-DREPO.CanReq THEN DO:
            MESSAGE 'NO hay stock suficiente' SKIP
                '      Stock actual:' Almmmate.StkACt SKIP
                'Stock comprometido:' pComprometido
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry':U TO T-DREPO.CanReq IN BROWSE {&browse-name}.
            RETURN 'ADM-ERROR'.
        END.
    END.
    OTHERWISE DO:
        FIND Almrepos WHERE almrepos.CodCia = s-codcia
            AND almrepos.TipMat = Almmmatg.Chr__02
            AND almrepos.CodAlm = s-codalm
            AND almrepos.AlmPed = T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almrepos THEN DO:
            MESSAGE 'Almacén' T-DREPO.AlmPed:SCREEN-VALUE IN BROWSE {&browse-name}
                'no es válido' VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry':U TO T-DREPO.AlmPed IN BROWSE {&browse-name}.
            RETURN 'ADM-ERROR'.
        END.
    END.
END CASE.


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

IF T-DREPO.Origen = 'AUT' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
IF LOOKUP(T-DREPO.AlmPed, '997,998') > 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
COMBO-BOX-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

