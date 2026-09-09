&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.



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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-PORIGV  LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE S-FLGSIT  AS CHAR.
DEFINE SHARED VARIABLE S-NROCOT  AS CHAR.
DEFINE SHARED VAR s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE x-CanPed AS DECI NO-UNDO.

DEFINE BUFFER B-ITEM FOR ITEM.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-define INTERNAL-TABLES ITEM Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ITEM.NroItm ITEM.codmat ~
Almmmatg.DesMat Almmmatg.DesMar ITEM.UndVta ITEM.AlmDes ITEM.CanPed ~
ITEM.Libre_d01 ITEM.PreUni ITEM.PorDto ITEM.Por_Dsctos[1] ~
ITEM.Por_Dsctos[3] ITEM.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM WHERE true NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.codmat = ITEM.codmat ~
  AND Almmmatg.CodCia = s-codcia NO-LOCK ~
    BY ITEM.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ITEM WHERE true NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.codmat = ITEM.codmat ~
  AND Almmmatg.CodCia = s-codcia NO-LOCK ~
    BY ITEM.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table ITEM Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-11 
&Scoped-Define DISPLAYED-OBJECTS F-PorDes F-TotBrt F-ImpExo F-ValVta ~
F-ImpIsc F-ImpIgv F-ImpTot F-ImpDes 

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

DEFINE VARIABLE F-PorDes AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "% Dscto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotBrt AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ValVta AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 121 BY 2.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ITEM, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ITEM.NroItm COLUMN-LABEL "No." FORMAT ">>9":U
      ITEM.codmat COLUMN-LABEL "Articulo" FORMAT "X(8)":U
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar FORMAT "X(12)":U
      ITEM.UndVta FORMAT "X(10)":U
      ITEM.AlmDes COLUMN-LABEL "Alm!Des" FORMAT "x(3)":U
      ITEM.CanPed COLUMN-LABEL "Cantidad!Aprobada" FORMAT ">>,>>9.99":U
      ITEM.Libre_d01 COLUMN-LABEL "Cantidad!Pedida" FORMAT ">>,>>9.99":U
      ITEM.PreUni FORMAT ">>,>>9.99999":U
      ITEM.PorDto COLUMN-LABEL "% Dscto.!Incluido" FORMAT ">>9.99":U
      ITEM.Por_Dsctos[1] COLUMN-LABEL "% Dscto!Manual" FORMAT ">>9.99":U
      ITEM.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Prom." FORMAT ">>9.99":U
      ITEM.ImpLin FORMAT ">,>>>,>>9.99":U
  ENABLE
      ITEM.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 121 BY 8.35
         FONT 4 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-PorDes AT ROW 9.54 COL 11 COLON-ALIGNED WIDGET-ID 12
     F-TotBrt AT ROW 10.88 COL 13 NO-LABEL WIDGET-ID 14
     F-ImpExo AT ROW 10.88 COL 25 NO-LABEL WIDGET-ID 4
     F-ValVta AT ROW 10.88 COL 47.14 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     F-ImpIsc AT ROW 10.88 COL 59.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     F-ImpIgv AT ROW 10.88 COL 72.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     F-ImpTot AT ROW 10.88 COL 85 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     F-ImpDes AT ROW 10.92 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 10.31 COL 65.57 WIDGET-ID 32
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.31 COL 14.86 WIDGET-ID 30
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 10.31 COL 77.14 WIDGET-ID 28
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 10.31 COL 25.43 WIDGET-ID 26
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 10.35 COL 37.57 WIDGET-ID 24
     "Total Importe" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 10.31 COL 87.14 WIDGET-ID 22
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.35 COL 50.86 WIDGET-ID 20
     RECT-11 AT ROW 9.35 COL 1 WIDGET-ID 18
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
      TABLE: ITEM T "SHARED" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 11.12
         WIDTH              = 133.29.
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
/* SETTINGS FOR FILL-IN F-PorDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotBrt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ValVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ITEM WHERE INTEGRAL.FacCPedi ...,INTEGRAL.Almmmatg WHERE Temp-Tables.ITEM ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.ITEM.NroItm|yes"
     _JoinCode[1]      = "true"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.codmat = Temp-Tables.ITEM.codmat
  AND INTEGRAL.Almmmatg.CodCia = s-codcia"
     _FldNameList[1]   > Temp-Tables.ITEM.NroItm
"ITEM.NroItm" "No." ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ITEM.codmat
"ITEM.codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ITEM.UndVta
"ITEM.UndVta" ? "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM.AlmDes
"ITEM.AlmDes" "Alm!Des" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ITEM.CanPed
"ITEM.CanPed" "Cantidad!Aprobada" ">>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ITEM.Libre_d01
"ITEM.Libre_d01" "Cantidad!Pedida" ">>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ITEM.PreUni
"ITEM.PreUni" ? ">>,>>9.99999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ITEM.PorDto
"ITEM.PorDto" "% Dscto.!Incluido" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ITEM.Por_Dsctos[1]
"ITEM.Por_Dsctos[1]" "% Dscto!Manual" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ITEM.Por_Dsctos[3]
"ITEM.Por_Dsctos[3]" "% Dscto!Prom." ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ITEM.ImpLin
"ITEM.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    IF NOT AVAILABLE ITEM THEN RETURN.
    IF ITEM.Libre_c01 = '*' AND ITEM.CanPed <> ITEM.Libre_d01 THEN DO:
        ASSIGN
            Almmmatg.DesMar:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11 
            Almmmatg.DesMat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.AlmDes:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.CanPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.codmat:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.ImpLin:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.Libre_d01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.NroItm:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.PorDto:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.PreUni:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11
            ITEM.UndVta:BGCOLOR IN BROWSE {&BROWSE-NAME} = 11.
        ASSIGN
            Almmmatg.DesMar:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            Almmmatg.DesMat:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.AlmDes:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.CanPed:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.codmat:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.ImpLin:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.Libre_d01:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.NroItm:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.PorDto:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.PreUni:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
            ITEM.UndVta:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME ITEM.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.CanPed IN BROWSE br_table /* Cantidad!Aprobada */
DO:
    IF DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
         MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO ITEM.CanPed IN BROWSE {&BROWSE-NAME}.
         RETURN NO-APPLY.
    END.
    FIND Almtconv WHERE 
         Almtconv.CodUnid  = Almmmatg.UndBas AND  
         Almtconv.Codalter = Almmmatg.Chr__01 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF Almtconv.Multiplos <> 0 THEN DO:
         IF DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos <> 
            INT(DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos) THEN DO:
            MESSAGE " La Cantidad debe de ser un, " SKIP
                    " multiplo de : " Almtconv.Multiplos
                    VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
         END.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-IGV AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-ISC AS DECIMAL INIT 0 NO-UNDO.

ASSIGN F-ImpDes = 0
       F-ImpExo = 0
       F-ImpIgv = 0
       F-ImpIsc = 0
       F-ImpTot = 0
       F-TotBrt = 0
       F-ValVta = 0.
FOR EACH B-ITEM:
    F-ImpTot = F-ImpTot + B-ITEM.ImpLin.
    F-Igv = F-Igv + B-ITEM.ImpIgv.
    F-Isc = F-Isc + B-ITEM.ImpIsc.
    IF NOT B-ITEM.AftIgv THEN F-ImpExo = F-ImpExo + B-ITEM.ImpLin.
    IF B-ITEM.AftIgv = YES
    THEN F-ImpDes = F-ImpDes + ROUND(B-ITEM.ImpDto / (1 + FacCfgGn.PorIgv / 100), 2).
    ELSE F-ImpDes = F-ImpDes + B-ITEM.ImpDto.
END.
  F-ImpIgv = ROUND(F-Igv,2).
  F-ImpIsc = ROUND(F-Isc,2).
  F-ValVta = F-ImpTot - F-ImpExo - F-ImpIgv.
  F-TotBrt = F-ValVta + F-ImpIsc + F-ImpDes + F-ImpExo.
DISPLAY F-ImpDes
        F-ImpExo
        F-ImpIgv
        F-ImpIsc
        F-ImpTot
        F-TotBrt
        F-ValVta WITH FRAME {&FRAME-NAME}.

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
  RETURN 'ADM-ERROR'.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
  IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
      THEN ITEM.ImpDto = 0.
      ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
  ASSIGN
      ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
      ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
  IF ITEM.AftIgv THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
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
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

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
  RUN Imp-Total.

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
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular B-table-Win 
PROCEDURE Recalcular :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  ASSIGN
      ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ).
  IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
      THEN ITEM.ImpDto = 0.
      ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
  ASSIGN
      ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
      ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
  IF ITEM.AftIgv 
  THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (FacCfgGn.PorIgv / 100) ), 4 ).


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
  {src/adm/template/snd-list.i "ITEM"}
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
     RUN Procesa-Handle IN lh_handle ('Disable-Head').
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
  DEFINE VARIABLE S-StkComprometido AS DECIMAL NO-UNDO.
  DEFINE VARIABLE s-SaldoCotizacion AS DECIMAL NO-UNDO.
  DEFINE VARIABLE S-StkDis AS DECIMAL NO-UNDO.
  
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND  Almmmate.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Articulo no asignado al almacen " ITEM.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
           VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  IF DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CanPed.
       RETURN "ADM-ERROR".
  END.

  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
      NO-LOCK NO-ERROR.
  f-Factor = Almtconv.Equival / Almmmatg.FacEqu.
  x-CanPed = DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * f-Factor.

  RUN gn/Stock-Comprometido (ITEM.CodMat,
                             ITEM.AlmDes,
                             OUTPUT s-StkComprometido).
  /* buscamos si ya está grabado */
  IF s-adm-new-record = 'NO' THEN DO:
      /*FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.CodMat NO-LOCK NO-ERROR.*/
      FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
          AND Facdpedi.coddoc = s-coddoc
          AND Facdpedi.nroped = s-nroped 
          AND Facdpedi.codmat = ITEM.CodMat NO-LOCK NO-ERROR.
      IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - (Facdpedi.CanPed * Facdpedi.Factor).
  END.
  /* *************************** */
  s-StkDis = Almmmate.StkAct - s-StkComprometido.
  IF s-StkDis < x-CanPed THEN DO:
        MESSAGE "No hay STOCK suficiente" SKIP(1)
                "       STOCK ACTUAL : " Almmmate.StkAct Almmmatg.undbas SKIP
                "  STOCK COMPROMETIDO: " s-StkComprometido Almmmatg.undbas SKIP
                "   STOCK DISPONIBLE : " S-STKDIS Almmmatg.undbas SKIP
                VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':u TO ITEM.CanPed.
        RETURN "ADM-ERROR".
  END.

  FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
      AND Facdpedi.coddiv = s-coddiv
      AND Facdpedi.coddoc = 'COT'
      AND Facdpedi.nroped = s-nrocot
      AND Facdpedi.codmat = ITEM.codmat
      NO-LOCK NO-ERROR.
  s-SaldoCotizacion = (Facdpedi.CanPed - Facdpedi.CanAte).
  IF ITEM.NroPed <> '' THEN s-SaldoCotizacion = s-SaldoCotizacion + ITEM.CanPed.
  IF DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > s-SaldoCotizacion THEN DO:
      MESSAGE 'No puede solicitar más de' s-SaldoCotizacion ITEM.UndVta
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'entry':u TO ITEM.CanPed.
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

