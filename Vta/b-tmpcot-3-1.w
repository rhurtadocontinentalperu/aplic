&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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

DEFINE SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.
DEFINE SHARED VARIABLE s-import-ibc AS LOG.

DEFINE BUFFER B-PEDI FOR PEDI.

DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODIGV  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE X-NRODEC AS INTEGER.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE S-UNDBAS     AS CHARACTER NO-UNDO.
DEFINE VARIABLE I-ListPr     AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-OK         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NroItm     AS INTEGER   NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.

DEFINE VARIABLE F-PREVTA LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PorImp LIKE Almmmatg.PreBas NO-UNDO.


FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VARIABLE MaxCat LIKE ClfClie.PorDsc.
DEFINE VARIABLE MaxVta LIKE Dsctos.PorDto.

DEFINE VARIABLE x-password AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE VARIABLE X-CLFCLI AS CHARACTER.

DEFINE stream entra .

DEFINE VAR s-local-new-record AS CHAR INIT 'YES' NO-UNDO.

DEFINE VAR s-registro-activo AS LOG INIT NO NO-UNDO.

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
&Scoped-define INTERNAL-TABLES PEDI Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI.NroItm PEDI.codmat ~
Almmmatg.DesMat Almmmatg.DesMar PEDI.UndVta PEDI.CanPed PEDI.PreUni ~
PEDI.PorDto PEDI.Por_Dsctos[1] PEDI.Por_Dsctos[3] PEDI.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.codmat PEDI.CanPed ~
PEDI.PreUni 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI WHERE TRUE /* Join to FacCPedi incomplete */ NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK ~
    BY PEDI.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI WHERE TRUE /* Join to FacCPedi incomplete */ NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK ~
    BY PEDI.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table PEDI Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-11 
&Scoped-Define DISPLAYED-OBJECTS F-TotBrt F-ImpExo F-ImpDes F-ValVta ~
F-ImpIsc F-ImpIgv F-ImpTot f-PesMat 

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
DEFINE VARIABLE F-ImpDes AS DECIMAL FORMAT "-Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpExo AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIgv AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIsc AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE f-PesMat AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Peso" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE F-TotBrt AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ValVta AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 2.69.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI.NroItm COLUMN-LABEL "No" FORMAT "ZZ9":U
      PEDI.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(50)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      PEDI.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U
      PEDI.CanPed FORMAT ">>>,>>9.99":U
      PEDI.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.9999":U
      PEDI.PorDto COLUMN-LABEL "% Dscto.!Incluido" FORMAT ">>9.99":U
      PEDI.Por_Dsctos[1] COLUMN-LABEL "% Dscto!Manual" FORMAT ">>9.99":U
      PEDI.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Prom." FORMAT ">>9.99":U
      PEDI.ImpLin FORMAT ">>>,>>9.99":U
  ENABLE
      PEDI.codmat
      PEDI.CanPed
      PEDI.PreUni
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 117 BY 6.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-TotBrt AT ROW 8.46 COL 2.72 NO-LABEL WIDGET-ID 14
     F-ImpExo AT ROW 8.5 COL 18 NO-LABEL WIDGET-ID 4
     F-ImpDes AT ROW 8.5 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     F-ValVta AT ROW 8.5 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     F-ImpIsc AT ROW 8.5 COL 60 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     F-ImpIgv AT ROW 8.5 COL 74 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     F-ImpTot AT ROW 8.5 COL 88 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     f-PesMat AT ROW 9.31 COL 88 COLON-ALIGNED WIDGET-ID 12
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8 COL 49.29 WIDGET-ID 28
     "Total Importe" VIEW-AS TEXT
          SIZE 9.29 BY .5 AT ROW 8 COL 90.72 WIDGET-ID 24
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8 COL 34 WIDGET-ID 26
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .42 AT ROW 8 COL 78.57 WIDGET-ID 22
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 8 COL 64.86 WIDGET-ID 32
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 7.96 COL 4.14 WIDGET-ID 30
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 8 COL 18.86 WIDGET-ID 20
     RECT-11 AT ROW 7.73 COL 2 WIDGET-ID 18
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
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 9.54
         WIDTH              = 129.29.
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
/* SETTINGS FOR FILL-IN f-PesMat IN FRAME F-Main
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
     _TblList          = "Temp-Tables.PEDI Where INTEGRAL.FacCPedi ...,INTEGRAL.Almmmatg OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "Temp-Tables.PEDI.NroItm|yes"
     _FldNameList[1]   > Temp-Tables.PEDI.NroItm
"PEDI.NroItm" "No" "ZZ9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Articulo" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" ? ">>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDI.PreUni
"PEDI.PreUni" "Precio!Unitario" ">>,>>9.9999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.PEDI.PorDto
"PEDI.PorDto" "% Dscto.!Incluido" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.PEDI.Por_Dsctos[1]
"PEDI.Por_Dsctos[1]" "% Dscto!Manual" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.PEDI.Por_Dsctos[3]
"PEDI.Por_Dsctos[3]" "% Dscto!Prom." ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.PEDI.ImpLin
"PEDI.ImpLin" ? ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  DISPLAY I-NroItm @ PEDI.NroItm WITH BROWSE {&BROWSE-NAME}.
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


&Scoped-define SELF-NAME PEDI.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN .
    IF s-registro-activo = NO THEN RETURN.
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999") NO-ERROR.
    /* Valida Maestro Productos */
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.codmat = SELF:SCREEN-VALUE 
        USE-INDEX matg01 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF Almmmatg.TpoArt = "D" THEN DO:
        MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF Almmmatg.Chr__01 = "" THEN DO:
        MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* Valida Maestro Productos x Almacen */
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.CodAlm = S-CODALM 
        AND Almmmate.CodMat = SELF:SCREEN-VALUE 
        USE-INDEX mate01 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        MESSAGE "Articulo no esta asignado al" SKIP
            "    ALMACEN : " S-CODALM VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.   
    END.

    S-UNDBAS = Almmmatg.UndBas.
    F-FACTOR = 1.
    IF s-import-ibc = NO THEN DO:
        RUN vta/PrecioVenta-3 (s-CodCia,
                                  s-CodDiv,
                                  s-CodCli,
                                  s-CodMon,
                                  s-TpoCmb,
                                  f-Factor,
                                  Almmmatg.CodMat,
                                  s-CndVta,
                                  x-nrodec,
                                  OUTPUT f-PreBas,
                                  OUTPUT f-PreVta,
                                  OUTPUT f-Dsctos,
                                  OUTPUT y-Dsctos,
                                  OUTPUT x-TipDto).
    END.
    DISPLAY 
        Almmmatg.DesMat @ Almmmatg.DesMat 
        Almmmatg.DesMar @ Almmmatg.DesMar 
        Almmmatg.Chr__01 @ PEDI.UndVta 
        F-DSCTOS @ PEDI.PorDto
        F-PREVTA @ PEDI.PreUni 
        y-Dsctos @ PEDI.Por_Dsctos[3]
    WITH BROWSE {&BROWSE-NAME}.
END.

/*
DEF INPUT PARAMETER S-CODCIA AS INT.
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.CanPed br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF PEDI.CanPed IN BROWSE br_table /* Cantidad */
DO:
    IF s-registro-activo = NO THEN RETURN.
    IF pedi.codmat:SCREEN-VALUE IN BROWSE {&browse-name} = '' THEN RETURN.
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.CodAlm = S-CODALM 
        AND Almmmate.CodMat = PEDI.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        USE-INDEX mate01 NO-LOCK NO-ERROR.
    DEFINE VAR L-OK AS LOGICAL.
    RUN gn\c-uniofi ( "Unidades de Venta",
                       Almmmate.CodMat,
                       OUTPUT L-OK ).
    IF NOT L-OK THEN DO:
        /*PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "".*/
        RETURN NO-APPLY.
    END.

    S-UNDBAS = Almmmatg.UndBas.
    F-FACTOR = 1.
    IF s-import-ibc = NO 
        THEN RUN vta/PrecioVenta-3 (s-CodCia,
                              s-CodDiv,
                              s-CodCli,
                              s-CodMon,
                              s-TpoCmb,
                              f-Factor,
                              Almmmatg.CodMat,
                              s-CndVta,
                              x-nrodec,
                              OUTPUT f-PreBas,
                              OUTPUT f-PreVta,
                              OUTPUT f-Dsctos,
                              OUTPUT y-Dsctos,
                              OUTPUT x-TipDto).

    DISPLAY 
        Almmmatg.DesMat @ Almmmatg.DesMat 
        Almmmatg.DesMar @ Almmmatg.DesMar 
        Almmmatg.Chr__01 @ PEDI.UndVta 
        F-DSCTOS @ PEDI.PorDto
        F-PREVTA @ PEDI.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.CanPed IN BROWSE br_table /* Cantidad */
DO:
    IF s-registro-activo = NO THEN RETURN.
    IF DEC(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = PEDI.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN RETURN.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = Almmmatg.Chr__01 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF Almtconv.Multiplos <> 0 THEN DO:
        IF DEC(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos <> 
            INT(DEC(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos) THEN DO:
            MESSAGE " La Cantidad debe de ser un, " SKIP
                " multiplo de : " Almtconv.Multiplos
                VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
    END.
    S-UNDBAS = Almmmatg.UndBas.
    F-FACTOR = 1.
    /* RHC 16.12.2010 excepto para SUPERMERCADOS */
    IF s-import-ibc = NO THEN DO:
        RUN vta/PrecioVenta-3 (s-CodCia,
                                  s-CodDiv,
                                  s-CodCli,
                                  s-CodMon,
                                  s-TpoCmb,
                                  f-Factor,
                                  Almmmatg.CodMat,
                                  s-CndVta,
                                  x-nrodec,
                                  OUTPUT f-PreBas,
                                  OUTPUT f-PreVta,
                                  OUTPUT f-Dsctos,
                                  OUTPUT y-Dsctos,
                                  OUTPUT x-TipDto).
    END.
    DISPLAY 
        Almmmatg.DesMat @ Almmmatg.DesMat 
        Almmmatg.DesMar @ Almmmatg.DesMar 
        Almmmatg.Chr__01 @ PEDI.UndVta 
        F-DSCTOS @ PEDI.PorDto
        F-PREVTA @ PEDI.PreUni 
        y-Dsctos @ PEDI.Por_Dsctos[3]
    WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.PreUni br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF PEDI.PreUni IN BROWSE br_table /* Precio!Unitario */
DO:
    CASE x-NroDec:
        WHEN 2 THEN PEDI.PreUni:FORMAT IN BROWSE {&browse-name} = ">>,>>9.99" .
        WHEN 3 THEN PEDI.PreUni:FORMAT IN BROWSE {&browse-name} = ">>,>>9.999" .
        WHEN 4 THEN PEDI.PreUni:FORMAT IN BROWSE {&browse-name} = ">>,>>9.9999" .
    END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.PreUni IN BROWSE br_table /* Precio!Unitario */
DO:
    IF s-registro-activo = NO THEN RETURN.
    IF F-PREVTA > DEC(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
        MESSAGE "No Autorizado para modificar Precio " VIEW-AS ALERT-BOX ERROR.
        DISPLAY F-PREVTA @ PEDI.PreUni WITH BROWSE {&BROWSE-NAME}.
        RETURN NO-APPLY.   
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


ON "RETURN":U OF PEDI.codmat, PEDI.UndVta ,PEDI.CanPed ,PEDI.PorDto ,PEDI.PreUni
DO:
  IF PEDI.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       APPLY "ENTRY" TO PEDI.CodMat IN BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.
  END.
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-Precios-Supermercados B-table-Win 
PROCEDURE Calculo-Precios-Supermercados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   F-PorImp = 1.

   /* RHC 12.06.08 al tipo de cambio de la familia */
   IF S-CODMON = 1 THEN DO:
      IF Almmmatg.MonVta = 1 THEN
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
          ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * Almmmatg.TpoCmb * F-FACTOR.
   END.
   IF S-CODMON = 2 THEN DO:
      IF Almmmatg.MonVta = 2 THEN
         ASSIGN F-PREBAS = (Almmmatg.PreOfi * F-PorImp) * F-FACTOR.
      ELSE
         ASSIGN F-PREBAS = ((Almmmatg.PreOfi * F-PorImp) / Almmmatg.TpoCmb) * F-FACTOR.
   END.
   f-PreVta = f-PreBas.

   FIND FacTabla WHERE FacTabla.CodCia = s-codcia
       AND FacTabla.Tabla = 'AU' 
       AND FacTabla.Codigo = s-codcli
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Factabla THEN RETURN.

   IF Factabla.Valor[1] <> 0 
   THEN f-PreVta = f-PreBas * ( 1 - Factabla.Valor[1] / 100 ).
   ELSE f-PreVta = f-PreBas * ( 1 + Factabla.Valor[2] / 100 ).

    RUN src/BIN/_ROUND1(F-PREVTA, 2, OUTPUT F-PREVTA).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IBC-Diferencias B-table-Win 
PROCEDURE IBC-Diferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH T-DPEDI:
    DELETE T-DPEDI.
END.

FOR EACH PEDI:
    /* Valida Maestro Productos */
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = S-CODCIA AND  
         Almmmatg.codmat = PEDI.codmat
         USE-INDEX matg01
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN NEXT.
    IF Almmmatg.TpoArt = "D" THEN NEXT.
    IF Almmmatg.Chr__01 = "" THEN NEXT.
    FIND Almmmate WHERE 
         Almmmate.CodCia = S-CODCIA AND  
         Almmmate.CodAlm = S-CODALM AND  
         Almmmate.CodMat = PEDI.codmat
         USE-INDEX mate01
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN NEXT.
    F-FACTOR = 1.
    RUN Calculo-Precios-Supermercados.
    /* Solo si hay una diferencia mayor al 1% */
    IF ABSOLUTE(PEDI.PreUni - f-PreVta) / f-PreVta * 100 > 0.25 THEN DO:
        CREATE T-DPEDI.
        BUFFER-COPY PEDI TO T-DPEDI
            ASSIGN
                T-DPEDI.Libre_d01 = f-PreVta.
    END.

END.

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

  ASSIGN 
    F-ImpDes = 0
    F-ImpExo = 0
    F-ImpIgv = 0
    F-ImpIsc = 0
    F-ImpTot = 0
    F-TotBrt = 0
    F-ValVta = 0.
  FOR EACH B-PEDI:
    F-ImpTot = F-ImpTot + B-PEDI.ImpLin.
    F-Igv = F-Igv + B-PEDI.ImpIgv.
    F-Isc = F-Isc + B-PEDI.ImpIsc.
    IF NOT B-PEDI.AftIgv THEN F-ImpExo = F-ImpExo + B-PEDI.ImpLin.
    IF B-PEDI.AftIgv = YES
    THEN f-ImpDes = f-ImpDes + ROUND(B-PEDI.ImpDto / (1 + s-PorIgv / 100), 2).
    ELSE f-ImpDes = f-ImpDes + B-PEDI.ImpDto.
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
  IF s-import-ibc = YES THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  I-NroITm = 0.  
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-PEDI BY B-PEDI.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-PEDI.NroItm.
  END.
  IF (N-ITMS + 1) > FacCfgGn.Items_Pedido THEN DO:
     MESSAGE "El numero de items no puede ser mayor a "  FacCfgGn.Items_Pedido 
             VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  I-NroItm = I-NroItm + 1.
  s-local-new-record = 'YES'.
  s-registro-activo = YES.

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
  DEFINE VARIABLE F-PRECIO AS DECIMAL NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
      PEDI.CodCia = S-CODCIA
      PEDI.Factor = F-FACTOR
      PEDI.NroItm = I-NroItm
      PEDI.ALMDES = S-CODALM.
         
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND Almmmatg.codmat = PEDI.codmat 
      NO-LOCK NO-ERROR.
  ASSIGN 
    PEDI.UndVta = PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    PEDI.PreBas = F-PreBas 
    PEDI.AftIgv = Almmmatg.AftIgv 
    PEDI.AftIsc = Almmmatg.AftIsc 
    PEDI.PreUni = DEC(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI.PorDto = DEC(PEDI.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI.Por_Dsctos[3] = Y-DSCTOS
    PEDI.Libre_c04 = X-TIPDTO.
  ASSIGN
      PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                    ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
  IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
      ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
  ASSIGN
      PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
      PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
  IF PEDI.AftIgv 
  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  s-local-new-record = 'YES'.
  s-registro-activo = NO.
  RUN Imp-Total.

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
  s-registro-activo = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  s-local-new-record = 'YES'.
  s-registro-activo = NO.

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
/*   IF s-import-ibc = YES THEN DO:                         */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*       RETURN 'ADM-ERROR'.                                */
/*   END.                                                   */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.

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
  IF s-import-ibc = YES THEN DO:
      PEDI.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES. 
      PEDI.PreUni:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  END.
  ELSE DO:
      PEDI.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO. 
      PEDI.PreUni:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
  END.
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
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
                AND  gn-clie.CodCli = S-CODCLI 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN I-ListPr = INTEGER(gn-clie.TpoCli).
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH B-PEDI:
    F-FACTOR = B-PEDI.Factor.
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = B-PEDI.CODCIA AND  
         Almmmatg.codmat = B-PEDI.codmat 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        RUN vta/PrecioVenta-3 (s-CodCia,
                            s-CodDiv,
                            s-CodCli,
                            s-CodMon,
                            s-TpoCmb,
                            f-Factor,
                            Almmmatg.CodMat,
                            s-CndVta,
                            x-NroDec,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos,
                            OUTPUT x-TipDto).
        ASSIGN 
            B-PEDI.PreBas = F-PreBas 
            B-PEDI.AftIgv = Almmmatg.AftIgv 
            B-PEDI.AftIsc = Almmmatg.AftIsc
            B-PEDI.PreUni = F-PREVTA
            B-PEDI.PorDto = F-DSCTOS
            B-PEDI.Por_Dsctos[3] = Y-DSCTOS
            B-PEDI.Libre_c04 = X-TIPDTO.
        ASSIGN
            B-PEDI.ImpLin = B-PEDI.CanPed * B-PEDI.PreUni * 
                          ( 1 - B-PEDI.Por_Dsctos[1] / 100 ) *
                          ( 1 - B-PEDI.Por_Dsctos[2] / 100 ) *
                          ( 1 - B-PEDI.Por_Dsctos[3] / 100 ).
        IF B-PEDI.Por_Dsctos[1] = 0 AND B-PEDI.Por_Dsctos[2] = 0 AND B-PEDI.Por_Dsctos[3] = 0 
            THEN B-PEDI.ImpDto = 0.
            ELSE B-PEDI.ImpDto = B-PEDI.CanPed * B-PEDI.PreUni - B-PEDI.ImpLin.
        ASSIGN
            B-PEDI.ImpLin = ROUND(B-PEDI.ImpLin, 2)
            B-PEDI.ImpDto = ROUND(B-PEDI.ImpDto, 2).
        IF B-PEDI.AftIgv THEN B-PEDI.ImpIgv = B-PEDI.ImpLin - ROUND( B-PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
    END.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
    ASSIGN input-var-1 = S-CODCLI
           input-var-2 = STRING(s-tpocmb)
           input-var-3 = STRING(s-codmon).

    CASE HANDLE-CAMPO:name:
        WHEN "codmat" THEN 
            ASSIGN input-var-1 = S-CODCLI
                   input-var-2 = STRING(s-tpocmb)
                   input-var-3 = STRING(s-codmon).
        WHEN "UndVta" THEN ASSIGN input-var-1 = S-UNDBAS.
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
  {src/adm/template/snd-list.i "PEDI"}
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
  IF p-state = 'update-begin':U THEN APPLY 'ENTRY':U TO PEDI.codmat IN BROWSE {&browse-name}.
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

DEFINE VARIABLE F-STKRET AS DECIMAL NO-UNDO.

IF INTEGER(PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Codigo de Articulo no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF DECIMAL(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
IF PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
    AND  Almmmatg.codmat = PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
  FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almtfami AND Almtfami.SwComercial = NO THEN DO:
      MESSAGE 'El producto pertenece a una familia NO autorizada para ventas'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almsfami AND AlmSFami.SwDigesa = YES 
      AND (Almmmatg.VtoDigesa = ? OR Almmmatg.VtoDigesa < TODAY) THEN DO:
      MESSAGE 'La fecha de DIGESA ya venció o no se ha registrado su vencimiento'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
FIND B-PEDI WHERE B-PEDI.CODCIA = S-CODCIA 
    AND  B-PEDI.CodMat = PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
    NO-LOCK NO-ERROR.
IF AVAILABLE  B-PEDI AND ROWID(B-PEDI) <> ROWID(PEDI) THEN DO:
   MESSAGE "Codigo de Articulo repetido" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

  /* RHC 13.12.2010 Margen de Utilidad */
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.

  x-PreUni = DECIMAL ( PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) *
      ( 1 - DECIMAL (PEDI.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) *
      /*( 1 - PEDI.Por_Dsctos[2] / 100 ) **/
      ( 1 - DECIMAL (PEDI.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) .
  RUN vtagn/p-margen-utilidad (
      PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},      /* Producto */
      x-PreUni,  /* Precio de venta unitario */
      PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
      s-CodMon,       /* Moneda de venta */
      s-TpoCmb,       /* Tipo de cambio */
      YES,            /* Muestra el error */
      '',
      OUTPUT x-Margen,        /* Margen de utilidad */
      OUTPUT x-Limite,        /* Margen mínimo de utilidad */
      OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
      ).
  IF pError = "ADM-ERROR" THEN DO:
      APPLY 'ENTRY':U TO PEDI.CodMat.
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

IF NOT AVAILABLE PEDI THEN RETURN "ADM-ERROR".

CASE x-NroDec:
    WHEN 2 THEN PEDI.PreUni:FORMAT IN BROWSE {&browse-name} = ">>,>>9.99" .
    WHEN 3 THEN PEDI.PreUni:FORMAT IN BROWSE {&browse-name} = ">>,>>9.999" .
    WHEN 4 THEN PEDI.PreUni:FORMAT IN BROWSE {&browse-name} = ">>,>>9.9999" .
END CASE.
IF PEDI.CanAte > 0 THEN DO:
    MESSAGE 'Este item no se puede modificar, ya tiene atenciones parciales'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
    AND  Almmmatg.codmat = PEDI.codmat 
    NO-LOCK NO-ERROR.
ASSIGN
    f-PreBas = PEDI.PreBas
    f-PreVta = PEDI.PreUni
    F-DSCTOS = PEDI.PorDto
    S-UNDBAS = Almmmatg.UndBas
    F-FACTOR = PEDI.Factor
    I-NroItm = PEDI.NroItm
    y-Dsctos = PEDI.Por_Dsctos[3]
    x-TipDto = PEDI.Libre_c04.
ASSIGN
    s-local-new-record = 'NO'
    s-registro-activo = YES.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

