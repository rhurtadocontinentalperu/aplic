&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-COCmp FOR LG-COCmp.
DEFINE BUFFER B-DOCmp FOR LG-DOCmp.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

&SCOPED-DEFINE CONDICION ( LG-COCmp.CodCia = S-CODCIA AND ~
                           LG-COCmp.CodDiv BEGINS S-CODDIV AND ~
                           LOOKUP(LG-COCmp.FlgSit, S-SITOC, '|') > 0 AND ~
                           LG-COCmp.CodAlm BEGINS FILL-IN-CodAlm)

&SCOPED-DEFINE CODIGO LG-COCmp.NroDoc 

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( LG-COCmp.NomPro BEGINS FILL-IN-filtro )
&SCOPED-DEFINE FILTRO2 ( INDEX ( LG-COCmp.NomPro , FILL-IN-filtro ) <> 0 )

DEF VAR X AS DEC.
DEFINE TEMP-TABLE Detalle
    FIELD FchDoc LIKE LG-COCmp.Fchdoc 
    FIELD CodAlm LIKE LG-COCmp.CodAlm 
    FIELD NroDoc LIKE LG-COCmp.NroDoc
    FIELD CodPro LIKE LG-COCmp.CodPro 
    FIELD NomPro LIKE LG-COCmp.NomPro 
    FIELD CodMat LIKE LG-DOCmp.Codmat 
    FIELD DesMat LIKE Almmmatg.DesMat 
    FIELD CodFam LIKE Almmmatg.CodFam 
    FIELD SubFam LIKE Almmmatg.SubFam
    FIELD CanPedi LIKE LG-DOCmp.CanPedi     COLUMN-LABEL "Solicitado"
    FIELD CanAten LIKE LG-DOCmp.CanAten     COLUMN-LABEL "Recibido"
    FIELD Saldo AS DEC                      COLUMN-LABEL "x Recibir"
    FIELD UndCmp LIKE LG-DOCmp.UndCmp
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
&Scoped-define INTERNAL-TABLES LG-COCmp

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table LG-COCmp.CodAlm LG-COCmp.NroDoc ~
LG-COCmp.FchEnt LG-COCmp.FchVto LG-COCmp.FchAte LG-COCmp.NomPro ~
ENTRY ( LOOKUP (LG-COCmp.FlgSit,'A,P,T,V') ,'Anulado,Pendiente,Aten.Total,Vencidas, ') @ LG-COCmp.Userid-com 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH LG-COCmp WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH LG-COCmp WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table LG-COCmp
&Scoped-define FIRST-TABLE-IN-QUERY-br_table LG-COCmp


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS s-SitOc BUTTON-1 FILL-IN-CodAlm BUTTON-2 ~
CMB-filtro FILL-IN-filtro br_table 
&Scoped-Define DISPLAYED-OBJECTS s-SitOc FILL-IN-CodAlm CMB-filtro ~
FILL-IN-filtro 

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
Nombres que inicien con|y|y|INTEGRAL.LG-COCmp.NomPro
Nombres que contengan|y|y|INTEGRAL.LG-COCmp.NomPro
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con,Nombres que contengan",
     Keys-Supplied = "Nombres que inicien con,Nombres que contengan"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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
NroDoc|y||INTEGRAL.LG-COCmp.NroDoc|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'NroDoc' + '",
     SortBy-Case = ':U + 'NroDoc').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "INGRESOS AL ALMACEN" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 5 BY 1.35.

DEFINE VARIABLE CMB-filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 23 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-filtro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE s-SitOc AS CHARACTER INITIAL "P|T|V|A" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "P|T|V|A",
"Pendientes", "P",
"Atendidos", "T",
"Vencidos", "V",
"Anulados", "A"
     SIZE 58 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      LG-COCmp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      LG-COCmp.CodAlm FORMAT "x(3)":U
      LG-COCmp.NroDoc COLUMN-LABEL "Numero" FORMAT "999999":U
      LG-COCmp.FchEnt FORMAT "99/99/9999":U
      LG-COCmp.FchVto COLUMN-LABEL "Fecha Vencimiento" FORMAT "99/99/9999":U
      LG-COCmp.FchAte COLUMN-LABEL "Fecha Atencion" FORMAT "99/99/9999":U
      LG-COCmp.NomPro FORMAT "X(50)":U
      ENTRY ( LOOKUP (LG-COCmp.FlgSit,'A,P,T,V') ,'Anulado,Pendiente,Aten.Total,Vencidas, ') @ LG-COCmp.Userid-com COLUMN-LABEL "Estado"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 97 BY 6.69
         FONT 4
         TITLE "ORDENES DE COMPRA".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     s-SitOc AT ROW 1.27 COL 11 NO-LABEL WIDGET-ID 2
     BUTTON-1 AT ROW 1.27 COL 78 WIDGET-ID 18
     FILL-IN-CodAlm AT ROW 2.35 COL 9 COLON-ALIGNED WIDGET-ID 14
     BUTTON-2 AT ROW 2.54 COL 92 WIDGET-ID 20
     CMB-filtro AT ROW 3.42 COL 11 NO-LABEL WIDGET-ID 8
     FILL-IN-filtro AT ROW 3.42 COL 35 NO-LABEL WIDGET-ID 10
     br_table AT ROW 4.5 COL 1
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.54 COL 5 WIDGET-ID 16
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
      TABLE: B-COCmp B "?" ? INTEGRAL LG-COCmp
      TABLE: B-DOCmp B "?" ? INTEGRAL LG-DOCmp
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
         HEIGHT             = 11.88
         WIDTH              = 107.14.
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
/* BROWSE-TAB br_table FILL-IN-filtro F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CMB-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-filtro IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.LG-COCmp"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.LG-COCmp.CodAlm
     _FldNameList[2]   > INTEGRAL.LG-COCmp.NroDoc
"LG-COCmp.NroDoc" "Numero" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.LG-COCmp.FchEnt
     _FldNameList[4]   > INTEGRAL.LG-COCmp.FchVto
"LG-COCmp.FchVto" "Fecha Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.LG-COCmp.FchAte
"LG-COCmp.FchAte" "Fecha Atencion" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.LG-COCmp.NomPro
"LG-COCmp.NomPro" ? "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"ENTRY ( LOOKUP (LG-COCmp.FlgSit,'A,P,T,V') ,'Anulado,Pendiente,Aten.Total,Vencidas, ') @ LG-COCmp.Userid-com" "Estado" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* ORDENES DE COMPRA */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* ORDENES DE COMPRA */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* ORDENES DE COMPRA */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* INGRESOS AL ALMACEN */
DO:
  IF AVAILABLE lg-cocmp THEN RUN lgc/d-con001a ( ROWID(lg-cocmp) ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
   RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CMB-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CMB-filtro B-table-Win
ON VALUE-CHANGED OF CMB-filtro IN FRAME F-Main
DO:
    IF CMB-filtro = CMB-filtro:SCREEN-VALUE AND
        FILL-IN-filtro = FILL-IN-filtro:SCREEN-VALUE THEN RETURN.
    ASSIGN
        FILL-IN-filtro
        CMB-filtro.
    IF CMB-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + CMB-filtro).
    RUN Procesa-Parametros IN lh_handle ('Browses').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodAlm B-table-Win
ON LEAVE OF FILL-IN-CodAlm IN FRAME F-Main /* Almacen */
DO:
  IF FILL-IN-CodAlm = FILL-IN-CodAlm:SCREEN-VALUE THEN RETURN.
  ASSIGN FILL-IN-CodAlm.
  FIND Almacen WHERE 
       Almacen.CodCia = S-CODCIA AND
       Almacen.CodAlm = FILL-IN-CodAlm NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen OR FILL-IN-CodAlm = "" THEN 
         RUN Procesa-Parametro IN lh_handle ('Browses').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-filtro B-table-Win
ON LEAVE OF FILL-IN-filtro IN FRAME F-Main
DO:
    APPLY "VALUE-CHANGED" TO CMB-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s-SitOc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-SitOc B-table-Win
ON VALUE-CHANGED OF s-SitOc IN FRAME F-Main
DO:
    ASSIGN {&self-name}.
    RUN Procesa-Parametros IN lh_handle ('Browses').
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Nombres que inicien con':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'NroDoc':U THEN DO:
           &Scope SORTBY-PHRASE BY LG-COCmp.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que inicien con */
    WHEN 'Nombres que contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'NroDoc':U THEN DO:
           &Scope SORTBY-PHRASE BY LG-COCmp.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
    END. /* Nombres que contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
       RUN get-attribute ('SortBy-Case':U).
       CASE RETURN-VALUE:
         WHEN 'NroDoc':U THEN DO:
           &Scope SORTBY-PHRASE BY LG-COCmp.NroDoc DESCENDING
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END.
         OTHERWISE DO:
           &Undefine SORTBY-PHRASE
           {&OPEN-QUERY-{&BROWSE-NAME}}
         END. /* OTHERWISE...*/
       END CASE.
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

    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR lOptions AS CHAR.
    DEF VAR cArchivo AS CHAR.

    ASSIGN
        pOptions = "".
    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE Detalle.

    FOR EACH Lg-cocmp NO-LOCK WHERE {&Condicion}:
        FOR EACH Lg-docmp OF Lg-cocmp NO-LOCK, FIRST Almmmatg OF Lg-docmp NO-LOCK:
            CREATE Detalle.
            BUFFER-COPY Lg-cocmp
                TO Detalle
                ASSIGN
                Detalle.CodMat = Lg-docmp.codmat
                Detalle.desmat = Almmmatg.desmat
                Detalle.codfam = Almmmatg.codfam
                Detalle.subfam = Almmmatg.subfam
                Detalle.canpedi = Lg-docmp.canpedi
                Detalle.canaten = Lg-docmp.canaten
                Detalle.saldo = Detalle.canpedi - Detalle.canaten
                Detalle.undcmp = Lg-docmp.undcmp.
        END.
    END.

/*     GET FIRST {&browse-name}.                                                      */
/*     REPEAT WHILE AVAILABLE(LG-COCMP):                                              */
/*         FOR EACH Lg-docmp OF Lg-cocmp NO-LOCK, FIRST Almmmatg OF Lg-docmp NO-LOCK: */
/*             CREATE Detalle.                                                        */
/*             BUFFER-COPY Lg-cocmp                                                   */
/*                 TO Detalle                                                         */
/*                 ASSIGN                                                             */
/*                 Detalle.CodMat = Lg-docmp.codmat                                   */
/*                 Detalle.desmat = Almmmatg.desmat                                   */
/*                 Detalle.codfam = Almmmatg.codfam                                   */
/*                 Detalle.subfam = Almmmatg.subfam                                   */
/*                 Detalle.canpedi = Lg-docmp.canpedi                                 */
/*                 Detalle.canaten = Lg-docmp.canaten                                 */
/*                 Detalle.saldo = Detalle.canpedi - Detalle.canaten                  */
/*                 Detalle.undcmp = Lg-docmp.undcmp.                                  */
/*         END.                                                                       */
/*         GET NEXT {&browse-name}.                                                   */
/*     END.                                                                           */

    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    /* Definimos los campos a mostrar */
/*     ASSIGN lOptions = "FieldList:".                                                             */
/*     lOptions = lOptions + "coddiv,libre_c01,nroped,fchped,fchven,fchent,nomcli," +              */
/*         "lincre,sdoant,codven,imptot,estado,avance,items,peso,cuota,atendido,pendiente,codalm". */
/*     pOptions = pOptions + CHR(1) + lOptions.                                                    */

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    /*SESSION:DATE-FORMAT = "mdy".*/
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    /*SESSION:DATE-FORMAT = "dmy".*/
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN get-attribute ('Keys-Accepted').

  IF RETURN-VALUE <> "" AND RETURN-VALUE <> ? THEN
      ASSIGN
          CMB-filtro:LIST-ITEMS IN FRAME {&FRAME-NAME} =
          CMB-filtro:LIST-ITEMS + "," + RETURN-VALUE
          CMB-filtro:SCREEN-VALUE =  ENTRY(2,CMB-filtro:LIST-ITEMS)
          CMB-filtro =  ENTRY(2,CMB-filtro:LIST-ITEMS).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "Nombres que inicien con" "LG-COCmp" "NomPro"}
  {src/adm/template/sndkycas.i "Nombres que contengan" "LG-COCmp" "NomPro"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "LG-COCmp"}

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

