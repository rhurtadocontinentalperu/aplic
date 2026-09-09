&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DCMP LIKE LG-DOCmp.



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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-PROVEE AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.
DEFINE SHARED VARIABLE S-CODMON AS INTEGER.
DEFINE SHARED VARIABLE s-contrato-marco AS LOG.

DEFINE BUFFER OCMP FOR DCMP.

DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.

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
&Scoped-define INTERNAL-TABLES DCMP Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DCMP.Codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.TipArt DCMP.CanPedi DCMP.UndCmp DCMP.PreUni ~
DCMP.Dsctos[1] DCMP.Dsctos[2] DCMP.Dsctos[3] DCMP.IgvMat DCMP.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DCMP.Codmat DCMP.CanPedi ~
DCMP.PreUni DCMP.Dsctos[1] DCMP.Dsctos[2] DCMP.Dsctos[3] DCMP.IgvMat 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DCMP
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DCMP
&Scoped-define QUERY-STRING-br_table FOR EACH DCMP WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF DCMP NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DCMP WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF DCMP NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table DCMP Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DCMP
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-27 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS F-ImpBrt F-ImpDes F-ValVta F-ImpIgv ~
F-ImpIsc F-ImpExo F-ImpTot 

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
DEFINE BUTTON BUTTON-1 
     LABEL "Captura Excel" 
     SIZE 11 BY 1.12.

DEFINE VARIABLE F-ImpBrt AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpDes AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpExo AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIgv AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIsc AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ValVta AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 1.54.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DCMP, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DCMP.Codmat FORMAT "x(8)":U
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "x(15)":U
      Almmmatg.TipArt COLUMN-LABEL "Rotación" FORMAT "X(1)":U
      DCMP.CanPedi COLUMN-LABEL "Cantidad" FORMAT "ZZZ,ZZ9.99":U
      DCMP.UndCmp COLUMN-LABEL "Unidad" FORMAT "X(6)":U
      DCMP.PreUni COLUMN-LABEL "Unitario" FORMAT ">>>>9.9999":U
      DCMP.Dsctos[1] COLUMN-LABEL "%Dcto1" FORMAT ">>9.99":U
      DCMP.Dsctos[2] COLUMN-LABEL "%Dcto2" FORMAT ">>9.99":U
      DCMP.Dsctos[3] COLUMN-LABEL "%Dcto3" FORMAT ">>9.99":U
      DCMP.IgvMat FORMAT ">>9.99":U
      DCMP.ImpTot COLUMN-LABEL "Importe" FORMAT ">>>>,>>9.99":U
            WIDTH 7
  ENABLE
      DCMP.Codmat
      DCMP.CanPedi
      DCMP.PreUni
      DCMP.Dsctos[1]
      DCMP.Dsctos[2]
      DCMP.Dsctos[3]
      DCMP.IgvMat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 114 BY 7.31
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON-1 AT ROW 8.69 COL 103 WIDGET-ID 34
     F-ImpBrt AT ROW 9.19 COL 13 NO-LABEL WIDGET-ID 36
     F-ImpDes AT ROW 9.19 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     F-ValVta AT ROW 9.19 COL 31.57 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     F-ImpIgv AT ROW 9.19 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     F-ImpIsc AT ROW 9.19 COL 52.29 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     F-ImpExo AT ROW 9.19 COL 64.57 NO-LABEL WIDGET-ID 40
     F-ImpTot AT ROW 9.19 COL 72.86 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.69 COL 14.57 WIDGET-ID 62
     "Total Importe" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 8.69 COL 75.43 WIDGET-ID 64
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 8.69 COL 48.57 WIDGET-ID 52
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 8.69 COL 59.57 WIDGET-ID 54
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8.69 COL 65.14 WIDGET-ID 56
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.69 COL 35.57 WIDGET-ID 58
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8.69 COL 24.14 WIDGET-ID 60
     RECT-27 AT ROW 8.5 COL 1 WIDGET-ID 66
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
      TABLE: DCMP T "SHARED" ? INTEGRAL LG-DOCmp
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
         HEIGHT             = 10.5
         WIDTH              = 116.
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

/* SETTINGS FOR FILL-IN F-ImpBrt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ImpDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpExo IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpIsc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ValVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.DCMP,INTEGRAL.Almmmatg OF Temp-Tables.DCMP"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.DCMP.Codmat
"DCMP.Codmat" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.TipArt
"Almmmatg.TipArt" "Rotación" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.DCMP.CanPedi
"DCMP.CanPedi" "Cantidad" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.DCMP.UndCmp
"DCMP.UndCmp" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.DCMP.PreUni
"DCMP.PreUni" "Unitario" ">>>>9.9999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.DCMP.Dsctos[1]
"DCMP.Dsctos[1]" "%Dcto1" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.DCMP.Dsctos[2]
"DCMP.Dsctos[2]" "%Dcto2" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.DCMP.Dsctos[3]
"DCMP.Dsctos[3]" "%Dcto3" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.DCMP.IgvMat
"DCMP.IgvMat" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.DCMP.ImpTot
"DCMP.ImpTot" "Importe" ">>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME DCMP.Codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DCMP.Codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF DCMP.Codmat IN BROWSE br_table /* Codigo */
DO:
    IF DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN RETURN.
    DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF Almmmatg.Tpoart <> "A" THEN DO:
       MESSAGE "Articulo Desactivado" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    DISPLAY 
        Almmmatg.DesMat @ Almmmatg.DesMat 
        Almmmatg.TipArt @ Almmmatg.TipArt
        Almmmatg.DesMar @ Almmmatg.DesMar
        Almmmatg.UndCmp @ DCMP.UndCmp
        WITH BROWSE {&BROWSE-NAME}.          
    F-FACTOR = 1.
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatg.UndCmp
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no exixte en tabla de Equivalencias"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    ELSE F-FACTOR = Almtconv.Equival.
    /***** Se Usara con lista de Precios Proveedor Original *****/
    FIND lg-dmatpr WHERE lg-dmatpr.codcia = s-codcia
        AND lg-dmatpr.codmat = SELF:SCREEN-VALUE
        AND CAN-FIND(lg-cmatpr WHERE lg-cmatpr.codcia = s-codcia
                     AND lg-cmatpr.nrolis = lg-dmatpr.nrolis
                     AND lg-cmatpr.codpro = s-provee
                     AND lg-cmatpr.flgest = 'A' NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE LG-dmatpr THEN DO:
        MESSAGE "codigo de articulo no esta asignado al proveedor" SKIP
            "desea continua " VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO
            UPDATE Rpta AS LOGICAL.
        IF NOT Rpta THEN RETURN NO-APPLY.
    END.
    IF AVAILABLE LG-dmatpr THEN DO:
        DISPLAY 
            LG-dmatpr.Dsctos[1] @ DCMP.Dsctos[1]
            LG-dmatpr.Dsctos[2] @ DCMP.Dsctos[2]
            LG-dmatpr.Dsctos[3] @ DCMP.Dsctos[3]
            LG-dmatpr.IgvMat    @ DCMP.IgvMat 
            WITH BROWSE {&BROWSE-NAME}.
        IF S-CODMON = 1 THEN DO:
            IF LG-dmatpr.CodMon = 1 THEN
                DISPLAY LG-dmatpr.PreAct @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.
            ELSE 
                DISPLAY ROUND(LG-dmatpr.PreAct * S-TPOCMB,4) @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.
        END.
        ELSE DO:
            IF LG-dmatpr.CodMon = 2 THEN
                DISPLAY LG-dmatpr.PreAct @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.     
            ELSE 
                DISPLAY ROUND(LG-dmatpr.PreAct / S-TPOCMB,4) @ DCMP.PreUni WITH BROWSE {&BROWSE-NAME}.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DCMP.CanPedi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DCMP.CanPedi br_table _BROWSE-COLUMN B-table-Win
ON F8 OF DCMP.CanPedi IN BROWSE br_table /* Cantidad */
DO:
    DEF VAR L-OK AS LOG.
    RUN lkup\c-uniofi ( "Unidades de Venta",
                        DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                        OUTPUT L-OK ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Captura Excel */
DO:
  RUN Captura-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON "RETURN":U OF DCMP.Codmat, /*DCMP.UndCmp,*/ DCMP.CanPedi,DCMP.PreUni,DCMP.Dsctos[1],DCMP.Dsctos[2],DCMP.Dsctos[3],DCMP.IgvMat
DO:
   APPLY "TAB":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Articulos B-table-Win 
PROCEDURE Asignar-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF S-PROVEE = "" THEN DO:
     MESSAGE "Codigo de proveedor no registrado" VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
  RUN lgc\C-AsgArt.R("Maestro de Articulos").
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Excel B-table-Win 
PROCEDURE Captura-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF S-PROVEE = "" THEN DO:
     MESSAGE "No registró al proveedor" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

  DEF VAR x-Archivo AS CHAR.
  DEF VAR OKpressed AS LOG.
  DEF VAR x-Linea AS CHAR FORMAT 'x(30)' NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE x-Archivo
      FILTERS "Archivo (*.xls,*.xlsx)" "*.xls,*.xlsx"
      MUST-EXIST
      TITLE "Seleccione archivo EXCEL (xls xlsx)"
      UPDATE OKpressed.   
  IF OKpressed = NO THEN RETURN ERROR.

  EMPTY TEMP-TABLE DCMP.

  /* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
  DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
  DEFINE VARIABLE chWorkbook AS COM-HANDLE.
  DEFINE VARIABLE chWorksheet AS COM-HANDLE.

  DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
  DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
  DEFINE VARIABLE t-Row           AS INTEGER INIT 11.

  DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

  CREATE "Excel.Application" chExcelApplication.

  chWorkbook = chExcelApplication:Workbooks:OPEN(x-Archivo).
  chWorkSheet = chExcelApplication:Sheets:ITEM(1).

  t-Row = 1.        /* Saltamos el encabezado de los campos */
  REPEAT:
      ASSIGN
          t-Column = 1
          t-Row    = t-Row + 1
          cValue = ''
          dValue = 0.
      /* Código del producto  */ 
      cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
      IF cValue = "" OR cValue = ? THEN LEAVE.
      CREATE DCMP.
      ASSIGN
          DCMP.CodCia = s-codcia
          DCMP.codmat = cValue
          NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, NEXT.

      /* Cantidad */
      t-Column = t-Column + 1.
      cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
      ASSIGN
          dValue = DECIMAL(cValue)
          NO-ERROR.
      ASSIGN
          DCMP.canpedi = dValue.
  END.
  chExcelApplication:QUIT().
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet. 

  FOR EACH DCMP:
      FIND Almmmatg OF DCMP NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN DO:
          DELETE DCMP.
          NEXT.
      END.
      /* Lista del Proveedor */
      FIND lg-dmatpr WHERE lg-dmatpr.codcia = s-codcia
          AND lg-dmatpr.codmat = DCMP.CodMat
          AND CAN-FIND(lg-cmatpr WHERE lg-cmatpr.codcia = s-codcia
                       AND lg-cmatpr.nrolis = lg-dmatpr.nrolis
                       AND lg-cmatpr.codpro = s-provee
                       AND lg-cmatpr.flgest = 'A' NO-LOCK)
          NO-LOCK NO-ERROR.
      IF AVAILABLE LG-dmatpr THEN DO:
          ASSIGN
              DCMP.PreUni    = LG-dmatpr.PreAct
              /*DCMP.CanAten   = LG-dmatpr.CodMon*/
              DCMP.Dsctos[1] = LG-dmatpr.Dsctos[1]
              DCMP.Dsctos[2] = LG-dmatpr.Dsctos[2]
              DCMP.Dsctos[3] = LG-dmatpr.Dsctos[3]
              DCMP.IgvMat    = LG-dmatpr.IgvMat.
          IF S-CODMON = 1 THEN DO:
             IF LG-dmatpr.CodMon = 2 THEN
                DCMP.PreUni = ROUND( DCMP.PreUni * S-TPOCMB,4).
          END.
          ELSE DO:
             IF LG-dmatpr.CodMon = 1 THEN
                DCMP.PreUni = ROUND( DCMP.PreUni / S-TPOCMB,4).
          END.
      END.
      ASSIGN 
          DCMP.ArtPro = ""
          DCMP.UndCmp = Almmmatg.UndStk
          DCMP.ArtPro = Almmmatg.ArtPro
          /*DCmp.CanAten = S-Codmon*/
          DCMP.ImpTot = ROUND(DCmp.CanPedi * ROUND(DCMP.PreUni * 
                                  (1 - (DCMP.Dsctos[1] / 100)) *
                                  (1 - (DCMP.Dsctos[2] / 100)) *
                                  (1 - (DCMP.Dsctos[3] / 100)) *
                                  (1 + (DCMP.IgvMat / 100)) , 4),2).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importe-Total B-table-Win 
PROCEDURE Importe-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:  
  ASSIGN F-ImpDes = 0
         F-ImpExo = 0
         F-ImpIgv = 0
         F-ImpIsc = 0
         F-ImpTot = 0
         F-ImpBrt = 0
         F-ValVta = 0.
  FOR EACH OCMP NO-LOCK:
         F-ImpTot = F-ImpTot + OCMP.ImpTot.
         IF OCMP.IgvMat = 0 THEN F-ImpExo = F-ImpExo + OCMP.ImpTot.
  END.
  FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
  ASSIGN F-ImpIgv = (F-ImpTot - F-ImpExo) - 
                    ROUND((F-ImpTot - F-ImpExo)/ (1 + LG-CFGIGV.PorIgv / 100),2)
         F-ImpBrt = F-ImpTot - F-ImpExo - F-ImpIgv
         F-ImpDes = 0
         F-ValVta = F-ImpTot - F-ImpDes - F-ImpExo - F-ImpIgv.
  DISPLAY F-ImpDes  F-ImpExo  F-ImpIgv  F-ImpIsc  F-ImpTot  F-ImpBrt  F-ValVta.
END.

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
  DEF VAR x-Items AS INT INIT 0 NO-UNDO.

  IF S-PROVEE = "" THEN DO:
     MESSAGE "No registró al proveedor" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

  FOR EACH OCMP:
      x-Items = x-Items + 1.
  END.
  
  IF x-Items >= 17 THEN DO:
      MESSAGE 'Máximo 17 Items' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  DEF VAR x-Importe LIKE Lg-docmp.preuni NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
       Almmmatg.CodMat = DCMP.Codmat NO-LOCK NO-ERROR.
  
  ASSIGN DCMP.CodCia = S-CODCIA 
         DCMP.ArtPro = ""
         DCMP.UndCmp = Almmmatg.UndStk
         DCMP.ArtPro = Almmmatg.ArtPro
         /*DCmp.CanAten = S-Codmon*/
         x-Importe = DCmp.CanPedi * DCMP.PreUni.
  ASSIGN
         DCMP.ImpTot = ROUND(x-Importe * 
                                (1 - (DCMP.Dsctos[1] / 100)) *
                                (1 - (DCMP.Dsctos[2] / 100)) *
                                (1 - (DCMP.Dsctos[3] / 100)) *
                                (1 + (DCMP.IgvMat / 100)), 2).

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
  /* Si el proveedor es CISSAC */
  IF s-Provee = '51135890' THEN
      ASSIGN
          DCMP.Dsctos[1]:READ-ONLY IN BROWSE {&browse-name} = YES
          DCMP.Dsctos[2]:READ-ONLY IN BROWSE {&browse-name} = YES
          DCMP.Dsctos[3]:READ-ONLY IN BROWSE {&browse-name} = YES
          DCMP.PreUni:READ-ONLY IN BROWSE {&browse-name} = YES.
  ELSE ASSIGN
          DCMP.Dsctos[1]:READ-ONLY IN BROWSE {&browse-name} = NO
          DCMP.Dsctos[2]:READ-ONLY IN BROWSE {&browse-name} = NO
          DCMP.Dsctos[3]:READ-ONLY IN BROWSE {&browse-name} = NO
          DCMP.PreUni:READ-ONLY IN BROWSE {&browse-name} = NO.

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
  RUN Importe-Total.

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
  RUN Importe-Total.

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
        WHEN "PreUni" THEN ASSIGN input-var-1 = DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
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
  {src/adm/template/snd-list.i "DCMP"}
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

IF DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo en blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF DECIMAL(DCMP.CanPedi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = DCMP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Código NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
IF Almmmatg.TpoArt <> 'A' THEN DO:
    MESSAGE 'Artículo no válido para compras' VIEW-AS ALERT-BOX ERROR.
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

