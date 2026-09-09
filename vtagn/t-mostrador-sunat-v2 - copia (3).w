&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE t-Almmmatg NO-UNDO LIKE Almmmatg.



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

&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE s-nrodec AS INT.
DEFINE SHARED VARIABLE s-FlgSit AS CHAR.
DEFINE SHARED VARIABLE s-PorIgv AS DECI.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE s-NroPed AS CHAR.
DEFINE SHARED VARIABLE s-Cmpbnte AS CHAR.

DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DECI NO-UNDO.

DEFINE VARIABLE pMensaje AS CHAR NO-UNDO.


DEFINE VARIABLE s-AlmDes AS CHAR NO-UNDO.       /* OJO */

DEF TEMP-TABLE t-Matg
    FIELD codmat AS CHAR.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-CodDiv  NO-LOCK.


/* DEF VAR hProc AS HANDLE NO-UNDO.               */
/* RUN web/web-library.p PERSISTENT SET hProc.    */
/*                                                */
/* DEF VAR x-StkMax LIKE Almmmatg.StkMax NO-UNDO. */
/* DEF VAR x-PreVta LIKE Almmmatg.PreVta NO-UNDO. */


DEF VAR hWebLibrary AS HANDLE NO-UNDO.
RUN web/web-library.p PERSISTENT SET hWebLibrary.

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
&Scoped-define INTERNAL-TABLES t-Almmmatg ITEM

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-Almmmatg.codmat t-Almmmatg.DesMat ~
t-Almmmatg.DesMar ITEM.AlmDes ITEM.CanPed ITEM.UndVta t-Almmmatg.StkMax ~
t-Almmmatg.UndA t-Almmmatg.Prevta[1] ITEM.PreUni ITEM.Por_Dsctos[1] ~
ITEM.Por_Dsctos[2] ITEM.Por_Dsctos[3] ITEM.ImpDto ITEM.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM
&Scoped-define QUERY-STRING-br_table FOR EACH t-Almmmatg WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST ITEM OF t-Almmmatg NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-Almmmatg WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST ITEM OF t-Almmmatg NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-Almmmatg ITEM
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-br_table ITEM


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
      t-Almmmatg, 
      ITEM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-Almmmatg.codmat COLUMN-LABEL "Articulo" FORMAT "X(14)":U
            WIDTH 7.43
      t-Almmmatg.DesMat FORMAT "X(100)":U WIDTH 58.43
      t-Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 10.43
      ITEM.AlmDes COLUMN-LABEL "Alm!Desp" FORMAT "x(5)":U WIDTH 4.43
      ITEM.CanPed FORMAT ">>>,>>9.99":U WIDTH 7.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      ITEM.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U WIDTH 6.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      t-Almmmatg.StkMax COLUMN-LABEL "Stock!Disponible" FORMAT "Z,ZZZ,ZZ9.99":U
            WIDTH 8.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      t-Almmmatg.UndA FORMAT "X(8)":U WIDTH 5.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      t-Almmmatg.Prevta[1] COLUMN-LABEL "Precio A" FORMAT ">>,>>9.999999":U
            WIDTH 10.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      ITEM.PreUni COLUMN-LABEL "Precio Unitario!Calculado" FORMAT ">>,>>9.999999":U
            WIDTH 10.43
      ITEM.Por_Dsctos[1] COLUMN-LABEL "% Dscto.!Admins" FORMAT "->>9.9999":U
      ITEM.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Otros" FORMAT "->>9.9999":U
      ITEM.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.9999":U
      ITEM.ImpDto COLUMN-LABEL "Importe!Dcto." FORMAT "->>>,>>9.99":U
            WIDTH 7.29
      ITEM.ImpLin COLUMN-LABEL "Importe!con IGV" FORMAT ">,>>>,>>9.99":U
            WIDTH 7.14
  ENABLE
      ITEM.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 181 BY 17.77
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
   Temp-Tables and Buffers:
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: t-Almmmatg T "?" NO-UNDO INTEGRAL Almmmatg
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
         HEIGHT             = 17.96
         WIDTH              = 182.
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
     _TblList          = "Temp-Tables.t-Almmmatg,Temp-Tables.ITEM OF Temp-Tables.t-Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > Temp-Tables.t-Almmmatg.codmat
"t-Almmmatg.codmat" "Articulo" "X(14)" "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-Almmmatg.DesMat
"t-Almmmatg.DesMat" ? "X(100)" "character" ? ? ? ? ? ? no ? no no "58.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-Almmmatg.DesMar
"t-Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ITEM.AlmDes
"ITEM.AlmDes" "Alm!Desp" "x(5)" "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ITEM.CanPed
"ITEM.CanPed" ? ">>>,>>9.99" "decimal" 11 0 ? ? ? ? yes ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM.UndVta
"ITEM.UndVta" "Unidad" "x(10)" "character" 11 0 ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-Almmmatg.StkMax
"t-Almmmatg.StkMax" "Stock!Disponible" "Z,ZZZ,ZZ9.99" "decimal" 14 0 ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-Almmmatg.UndA
"t-Almmmatg.UndA" ? ? "character" 14 0 ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-Almmmatg.Prevta[1]
"t-Almmmatg.Prevta[1]" "Precio A" ">>,>>9.999999" "decimal" 14 0 ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ITEM.PreUni
"ITEM.PreUni" "Precio Unitario!Calculado" ">>,>>9.999999" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ITEM.Por_Dsctos[1]
"ITEM.Por_Dsctos[1]" "% Dscto.!Admins" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ITEM.Por_Dsctos[2]
"ITEM.Por_Dsctos[2]" "% Dscto!Otros" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ITEM.Por_Dsctos[3]
"ITEM.Por_Dsctos[3]" "% Dscto!Vol/Prom" "->>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.ITEM.ImpDto
"ITEM.ImpDto" "Importe!Dcto." "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.ITEM.ImpLin
"ITEM.ImpLin" "Importe!con IGV" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
/*     DEF VAR pComprometido AS DECI NO-UNDO.                                                              */
/*     DEF VAR s-TpoCmb AS DECI NO-UNDO.                                                                   */
/*     DEF VAR f-Factor AS DECI NO-UNDO.                                                                   */
/*     DEF VAR f-PreBas AS DECI NO-UNDO.                                                                   */
/*     DEF VAR f-PreVta AS DECI NO-UNDO.                                                                   */
/*     DEF VAR f-Dsctos AS DECI NO-UNDO.                                                                   */
/*     DEF VAR y-Dsctos AS DECI NO-UNDO.                                                                   */
/*     DEF VAR x-TipDto AS CHAR NO-UNDO.                                                                   */
/*     DEF VAR f-FleteUnitario AS DECI NO-UNDO.                                                            */
/*     DEF VAR pMensaje AS CHAR NO-UNDO.                                                                   */
/*     DEF VAR s-MonVta AS INTE NO-UNDO.                                                                   */
/*                                                                                                         */
/*     FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas                                           */
/*         AND Almtconv.Codalter = t-Almmmatg.UndA                                                         */
/*         NO-LOCK NO-ERROR.                                                                               */
/*     /* En unidades A */                                                                                 */
/*     ASSIGN                                                                                              */
/*         x-StkMax = t-Almmmatg.StkMax / Almtconv.Equival.                                                */
/*     /* Precio A B y C */                                                                                */
/*     ASSIGN                                                                                              */
/*         x-Prevta[1] = 0                                                                                 */
/*         x-Prevta[2] = 0                                                                                 */
/*         x-Prevta[3] = 0.                                                                                */
/*     /* Disparamos solo el primero */                                                                    */
/*     RUN web_api-pricing-preuni IN hProc (INPUT t-Almmmatg.CodMat,                                       */
/*                                          INPUT TRIM(STRING(INTEGER(GN-DIVI.Grupo_Divi_GG))),            */
/*                                          "C",                                                           */
/*                                          INPUT "000",           /* Contado */                           */
/*                                          OUTPUT s-MonVta,                                               */
/*                                          OUTPUT s-TpoCmb,                                               */
/*                                          OUTPUT f-PreVta,       /* Precio descontado ClfCli y CndVta */ */
/*                                          OUTPUT pMensaje).                                              */
/*     IF s-CodMon <> s-MonVta THEN DO:                                                                    */
/*         IF s-CodMon = 1 THEN f-PreVta = f-PreVta * s-TpoCmb.                                            */
/*         IF s-CodMon = 2 THEN f-PreVta = f-PreVta / s-TpoCmb.                                            */
/*     END.                                                                                                */
/*                                                                                                         */
/*     IF t-Almmmatg.UndA > '' THEN DO:                                                                    */
/*         FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas                                       */
/*             AND Almtconv.Codalter = t-Almmmatg.UndA                                                     */
/*             NO-LOCK NO-ERROR.                                                                           */
/*         IF AVAILABLE ALmtconv THEN DO:                                                                  */
/*             F-FACTOR = Almtconv.Equival.                                                                */
/*             x-Prevta[1] = (f-PreVta + f-FleteUnitario) * f-Factor.                                      */
/*         END.                                                                                            */
/*     END.                                                                                                */
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
ON LEAVE OF ITEM.CanPed IN BROWSE br_table /* Cantidad */
OR RETURN OF ITEM.CanPed
DO:
    IF SELF:SCREEN-VALUE = ? THEN RETURN.
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF ITEM.CanPed = DECIMAL(SELF:SCREEN-VALUE) THEN RETURN.

    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 t-Almmmatg.codmat,
                                 s-FlgSit,
                                 ITEM.undvta:SCREEN-VALUE IN BROWSE {&browse-name},
                                 DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}),
                                 s-NroDec,
                                 s-AlmDes,       /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    DISPLAY 
        F-PREVTA @ ITEM.PreUni 
        z-Dsctos @ ITEM.Por_Dsctos[2]
        y-Dsctos @ ITEM.Por_Dsctos[3]
        WITH BROWSE {&BROWSE-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.UndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.UndVta br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF ITEM.UndVta IN BROWSE br_table /* Unidad */
DO:
    IF TRUE <> (t-Almmmatg.codmat:SCREEN-VALUE IN BROWSE {&browse-name} > '') THEN RETURN.
    /****    Selecciona las unidades de medida   ****/
    RUN web/d-uniabc (t-Almmmatg.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                      s-codalm,
                      s-coddiv,
                      s-codcli,
                      s-tpocmb,
                      s-flgsit,
                      s-nrodec,
                      s-almdes,
                      OUTPUT output-var-2
                      ).
    SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.UndVta br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.UndVta IN BROWSE br_table /* Unidad */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  IF SELF:SCREEN-VALUE = "" THEN RETURN.

  /* SOLO se aceptan unidades válidas de este producto */
  DEF VAR x-Unidades AS CHAR.

  x-Unidades = TRIM(t-Almmmatg.UndA).
  IF t-Almmmatg.UndB <> '' THEN x-Unidades = x-unidades + ',' + TRIM(t-Almmmatg.UndB).
  IF t-Almmmatg.UndC <> '' THEN x-Unidades = x-unidades + ',' + TRIM(t-Almmmatg.UndC).
  IF LOOKUP(SELF:SCREEN-VALUE, x-Unidades) = 0 THEN DO:
      MESSAGE 'Solo se acepta la siguiente lista de unidades:' SKIP
          x-Unidades
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  RUN {&precio-venta-general} (s-CodCia,
                               s-CodDiv,
                               s-CodCli,
                               s-CodMon,
                               s-TpoCmb,
                               OUTPUT f-Factor,
                               t-Almmmatg.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
                               s-FlgSit,
                               ITEM.undvta:SCREEN-VALUE IN BROWSE {&browse-name},
                               DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}),
                               s-NroDec,
                               ITEM.almdes:SCREEN-VALUE IN BROWSE {&browse-name},   /* Necesario para REMATES */
                               OUTPUT f-PreBas,
                               OUTPUT f-PreVta,
                               OUTPUT f-Dsctos,
                               OUTPUT y-Dsctos,
                               OUTPUT x-TipDto,
                               OUTPUT f-FleteUnitario,
                               OUTPUT pMensaje
                               ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  DISPLAY 
      F-PREVTA @ ITEM.PreUni 
      z-Dsctos @ ITEM.Por_Dsctos[2]
      y-Dsctos @ ITEM.Por_Dsctos[3]
      WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.PreUni IN BROWSE br_table /* Precio Unitario!Calculado */
OR RETURN OF ITEM.CanPed
DO:
    FIND FIRST ITEM WHERE ITEM.CodMat = t-Almmmatg.codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ITEM THEN CREATE ITEM.
    FIND CURRENT ITEM EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN
        ITEM.CodCia = s-CodCia
        ITEM.CodMat = t-Almmmatg.codmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON 'RETURN':U OF ITEM.CanPed, ITEM.UndVta
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal B-table-Win 
PROCEDURE Captura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR ITEM.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Precios B-table-Win 
PROCEDURE Carga-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pComprometido AS DECI NO-UNDO.
DEF VAR s-TpoCmb AS DECI NO-UNDO.
DEF VAR f-Factor AS DECI NO-UNDO.
DEF VAR f-PreBas AS DECI NO-UNDO.
DEF VAR f-CtoUni AS DECI NO-UNDO.
DEF VAR f-PreVta AS DECI NO-UNDO.
DEF VAR f-Dsctos AS DECI NO-UNDO.
DEF VAR y-Dsctos AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR s-MonVta AS INTE NO-UNDO.


FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-CodDiv  NO-LOCK.

/* DEF VAR hWebLibrary AS HANDLE NO-UNDO.            */
/* RUN web/web-library.p PERSISTENT SET hWebLibrary. */

FOR EACH t-Almmmatg EXCLUSIVE-LOCK:
    /* Precio A B y C */
    ASSIGN
        t-Almmmatg.Prevta[1] = 0
        t-Almmmatg.Prevta[2] = 0
        t-Almmmatg.Prevta[3] = 0.
    /* Disparamos solo el primero */
    RUN web_api-pricing-preuni-ctouni IN hWebLibrary (INPUT t-Almmmatg.CodMat,
                                                INPUT TRIM(STRING(INTEGER(GN-DIVI.Grupo_Divi_GG))),
                                                "C",
                                                INPUT "000",           /* Contado */
                                                OUTPUT s-MonVta,
                                                OUTPUT s-TpoCmb,
                                                OUTPUT f-PreVta,       /* Precio descontado ClfCli y CndVta */
                                                OUTPUT f-CtoUni,
                                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' OR f-PreVta <= 0 THEN DO:
        DELETE t-Almmmatg.
        NEXT.
    END.
    IF s-CodMon <> s-MonVta THEN DO:
        IF s-CodMon = 1 THEN ASSIGN f-PreVta = f-PreVta * s-TpoCmb f-CtoUni = f-CtoUni * s-TpoCmb.
        IF s-CodMon = 2 THEN ASSIGN f-PreVta = f-PreVta / s-TpoCmb f-CtoUni = f-CtoUni / s-TpoCmb.
    END.

    IF t-Almmmatg.UndA > '' THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas
            AND Almtconv.Codalter = t-Almmmatg.UndA
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            DELETE t-Almmmatg.
            NEXT.
        END.
        F-FACTOR = Almtconv.Equival.
        t-Almmmatg.Prevta[1] = (f-PreVta + f-FleteUnitario) * f-Factor.
        t-Almmmatg.CtoUnd = f-CtoUni * f-Factor.
    END.
/*     IF t-Almmmatg.UndB > '' THEN DO:                                    */
/*         FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas       */
/*             AND Almtconv.Codalter = t-Almmmatg.UndB                     */
/*             NO-LOCK NO-ERROR.                                           */
/*         IF NOT AVAILABLE Almtconv THEN DO:                              */
/*             DELETE t-Almmmatg.                                          */
/*             NEXT.                                                       */
/*         END.                                                            */
/*         F-FACTOR = Almtconv.Equival.                                    */
/*         t-Almmmatg.Prevta[2] = (f-PreVta + f-FleteUnitario) * f-Factor. */
/*     END.                                                                */
/*     IF t-Almmmatg.UndC > '' THEN DO:                                    */
/*         FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas       */
/*             AND Almtconv.Codalter = t-Almmmatg.UndC                     */
/*             NO-LOCK NO-ERROR.                                           */
/*         IF NOT AVAILABLE Almtconv THEN DO:                              */
/*             DELETE t-Almmmatg.                                          */
/*             NEXT.                                                       */
/*         END.                                                            */
/*         F-FACTOR = Almtconv.Equival.                                    */
/*         t-Almmmatg.Prevta[3] = (f-PreVta + f-FleteUnitario) * f-Factor. */
/*     END.                                                                */
END.
/* DELETE PROCEDURE hWebLibrary. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Stock B-table-Win 
PROCEDURE Carga-Stock :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodAlm AS CHAR.

&SCOPED-DEFINE CONDICION2 ( Almmmate.codcia = t-Almmmatg.codcia AND ~
Almmmate.codalm = pCodAlm AND ~
Almmmate.codmat = t-Almmmatg.codmat )

DEF VAR pComprometido AS DECI NO-UNDO.

FOR EACH t-Almmmatg EXCLUSIVE-LOCK:
    /* En unidades A */
    FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas 
        AND Almtconv.Codalter = t-Almmmatg.UndA
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        DELETE t-Almmmatg.
        NEXT.
    END.
    IF t-Almmmatg.UndB > '' THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas 
            AND Almtconv.Codalter = t-Almmmatg.UndB
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            DELETE t-Almmmatg.
            NEXT.
        END.
    END.
    IF t-Almmmatg.UndC > '' THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas 
            AND Almtconv.Codalter = t-Almmmatg.UndC
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            DELETE t-Almmmatg.
            NEXT.
        END.
    END.

    t-Almmmatg.StkMax = 0.
    FIND FIRST Almmmate WHERE {&CONDICION2} NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN DO:
        IF Almmmate.StkAct <= 0 THEN DO:
            DELETE t-Almmmatg.
            NEXT.
        END.
        ASSIGN t-Almmmatg.StkMax = Almmmate.StkAct.
        RUN gn/stock-comprometido-v2 (t-Almmmatg.CodMat,
                                      pCodAlm,
                                      FALSE,
                                      OUTPUT pComprometido).
        ASSIGN t-Almmmatg.StkMax = t-Almmmatg.StkMax - pComprometido.
    END.
    IF t-Almmmatg.StkMax <= 0 THEN DELETE t-Almmmatg.
END.
RELEASE t-Almmmatg.

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

DEF INPUT PARAMETER pCodMat AS CHAR NO-UNDO.
DEF INPUT PARAMETER pCodFam AS CHAR NO-UNDO.
DEF INPUT PARAMETER pCodAlm AS CHAR NO-UNDO.
DEF INPUT PARAMETER pMarca AS CHAR NO-UNDO.
DEF INPUT PARAMETER CMB-filtro AS CHAR NO-UNDO.
DEF INPUT PARAMETER pFiltro AS CHAR NO-UNDO.

s-AlmDes = pCodAlm.

EMPTY TEMP-TABLE t-Matg.
EMPTY TEMP-TABLE t-Almmmatg.

DEF VAR LocalCadena AS CHAR NO-UNDO.
DEF VAR LocalOrden AS INTE NO-UNDO.
DEF VAR c-CodMat AS CHAR.

SESSION:SET-WAIT-STATE('GENERAL').
CASE TRUE:
    WHEN pCodMat > '' THEN DO:
        DECLARE cur-CodMat-01 CURSOR FOR 
        SELECT Almmmatg.codmat 
            FROM Almmmatg, Almtfami, Almmmate
            WHERE (Almmmatg.codcia = s-codcia AND 
            Almmmatg.codmat = pCodMat AND
            Almmmatg.tpoart <> "D") AND
            (Almtfami.codcia = Almmmatg.codcia AND
            Almtfami.codfam = Almmmatg.codfam AND
            Almtfami.swcomercial = YES) AND
            (Almmmate.codcia = Almmmatg.codcia AND 
            Almmmate.codalm = pCodAlm AND 
            Almmmate.codmat = Almmmatg.codmat AND
            Almmmate.stkact > 0)
            .
        OPEN cur-CodMat-01.
        FETCH cur-CodMat-01 INTO c-CodMat.
        REPEAT:
            CREATE t-Matg.
            ASSIGN t-Matg.CodMat = c-CodMat.
            FETCH cur-CodMat-01 INTO c-CodMat.
        END.
        CLOSE cur-CodMat-01.
    END.
    WHEN CMB-filtro = 'Nombres que inicien con' AND pFiltro > '' THEN DO:
        pFiltro = pFiltro + "%".
        IF pMarca > '' THEN pMarca = "%" + pMarca + "%".
        DECLARE cur-CodMat-02 CURSOR FOR 
        SELECT Almmmatg.codmat
            FROM Almmmatg, Almtfami, Almmmate
            WHERE (Almmmatg.codcia = s-codcia AND 
            Almmmatg.desmat LIKE pFiltro AND
            Almmmatg.tpoart <> "D" AND
            ( pMarca = '' OR Almmmatg.desmar LIKE pMarca ) AND
            (pCodFam = 'Todos' OR Almmmatg.codfam = pCodFam)) AND
            (Almtfami.codcia = Almmmatg.codcia AND
            Almtfami.codfam = Almmmatg.codfam AND
            Almtfami.swcomercial = YES) AND
            (Almmmate.codcia = Almmmatg.codcia AND 
            Almmmate.codalm = pCodAlm AND 
            Almmmate.codmat = Almmmatg.codmat AND
            Almmmate.stkact > 0)
            .
        OPEN cur-CodMat-02.
        FETCH cur-CodMat-02 INTO c-CodMat.
        REPEAT:
            CREATE t-Matg.
            ASSIGN t-Matg.CodMat = c-CodMat.
            FETCH cur-CodMat-02 INTO c-CodMat.
        END.
        CLOSE cur-CodMat-02.
    END.
    WHEN CMB-filtro = 'Nombres que contengan' AND pFiltro > '' THEN DO:
        DO LocalOrden = 1 TO NUM-ENTRIES(pFiltro, " "):
            LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") + 
                TRIM(ENTRY(LocalOrden,pFiltro, " ")) + "*".
        END.
        IF pMarca > '' THEN pMarca = "%" + pMarca + "%".
        DECLARE cur-CodMat-03 CURSOR FOR 
        SELECT Almmmatg.codmat
            FROM Almmmatg, Almtfami, Almmmate
            WHERE (Almmmatg.codcia = s-codcia AND 
            Almmmatg.DesMat CONTAINS LocalCadena  AND
            Almmmatg.tpoart <> "D" AND
            (pMarca = '' OR Almmmatg.desmar LIKE pMarca) AND
            (pCodFam = 'Todos' OR Almmmatg.codfam = pCodFam)) AND
            (Almtfami.codcia = Almmmatg.codcia AND
            Almtfami.codfam = Almmmatg.codfam AND
            Almtfami.swcomercial = YES AND
            Almmmate.codcia = Almmmatg.codcia AND 
            Almmmate.codalm = pCodAlm AND 
            Almmmate.codmat = Almmmatg.codmat AND
            Almmmate.stkact > 0)
            .
        OPEN cur-CodMat-03.
        FETCH cur-CodMat-03 INTO c-CodMat.
        REPEAT:
            CREATE t-Matg.
            ASSIGN t-Matg.CodMat = c-CodMat.
            FETCH cur-CodMat-03 INTO c-CodMat.
        END.
        CLOSE cur-CodMat-03.
    END.
    OTHERWISE DO:
        DECLARE cur-CodMat-04 CURSOR FOR 
        SELECT Almmmatg.codmat 
            FROM Almmmatg, Almtfami, Almmmate
            WHERE (Almmmatg.codcia = s-codcia AND 
            Almmmatg.tpoart <> "D" AND
            (pMarca = '' OR Almmmatg.desmar BEGINS pMarca) AND
            (pCodFam = 'Todos' OR Almmmatg.codfam = pCodFam)) AND
            (Almtfami.codcia = Almmmatg.codcia AND
            Almtfami.codfam = Almmmatg.codfam AND
            Almtfami.swcomercial = YES) AND
            (Almmmate.codcia = Almmmatg.codcia AND 
            Almmmate.codalm = pCodAlm AND 
            Almmmate.codmat = Almmmatg.codmat AND
            Almmmate.stkact > 0)
            .
        OPEN cur-CodMat-04.
        FETCH cur-CodMat-04 INTO c-CodMat.
        REPEAT:
            CREATE t-Matg.
            ASSIGN t-Matg.CodMat = c-CodMat.
            FETCH cur-CodMat-04 INTO c-CodMat.
        END.
        CLOSE cur-CodMat-04.
    END.
END CASE.

FOR EACH t-Matg NO-LOCK, 
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = t-Matg.codmat:
    CREATE t-Almmmatg.
    BUFFER-COPY Almmmatg TO t-Almmmatg.
END.

RUN Carga-Stock (pCodAlm).

RUN Carga-Precios.

FOR EACH t-Almmmatg EXCLUSIVE-LOCK:
    FIND Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas
        AND Almtconv.Codalter = t-Almmmatg.UndA
        NO-LOCK NO-ERROR.
    /* En unidades A */
    IF AVAILABLE Almtconv THEN t-Almmmatg.StkMax = t-Almmmatg.StkMax / Almtconv.Equival.
    /* Cargamos la tabla ITEM */
    FIND FIRST ITEM WHERE ITEM.codcia = s-codcia AND ITEM.codmat = t-Almmmatg.codmat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ITEM THEN DO:
        CREATE ITEM.
        ASSIGN
            ITEM.codcia = s-codcia
            ITEM.codmat = t-Almmmatg.codmat
            ITEM.UndVta = t-Almmmatg.UndA.
        RELEASE ITEM.
    END.
END.
RELEASE t-Almmmatg.

SESSION:SET-WAIT-STATE('').

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Old B-table-Win 
PROCEDURE Carga-Temporal-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR NO-UNDO.
DEF INPUT PARAMETER pCodFam AS CHAR NO-UNDO.
DEF INPUT PARAMETER pCodAlm AS CHAR NO-UNDO.
DEF INPUT PARAMETER pMarca AS CHAR NO-UNDO.
DEF INPUT PARAMETER CMB-filtro AS CHAR NO-UNDO.
DEF INPUT PARAMETER pFiltro AS CHAR NO-UNDO.

s-AlmDes = pCodAlm.

&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

&SCOPED-DEFINE GENERAL ( Almmmatg.CodCia = S-CODCIA  AND ~
(pCodFam = 'Todos' OR Almmmatg.CodFam = pCodFam) AND ~
Almmmatg.tpoart <> "D" AND ~
CAN-FIND(FIRST Almtfami OF Almmmatg WHERE Almtfami.SwComercial = YES NO-LOCK) )

&SCOPED-DEFINE CONDICION ( ( TRUE <> (pCodMat > '') OR Almmmatg.codmat = pCodMat ) ~
AND ( TRUE <> (pMarca > '') OR Almmmatg.DesMar BEGINS pMarca) )

&SCOPED-DEFINE CONDICION2 ( Almmmate.codcia = Almmmatg.codcia AND ~
Almmmate.codalm = pCodAlm AND ~
Almmmate.codmat = Almmmatg.codmat )

&SCOPED-DEFINE FILTRO1 ( Almmmatg.CodCia = S-CODCIA  AND Almmmatg.DesMat BEGINS pFiltro )

&SCOPED-DEFINE FILTRO2 ( Almmmatg.CodCia = S-CODCIA  AND INDEX(Almmmatg.DesMat, pFiltro) > 0 )

&SCOPED-DEFINE FILTRO3 ( Almmmatg.CodCia = S-CODCIA  AND Almmmatg.DesMar BEGINS pMarca )

EMPTY TEMP-TABLE t-Almmmatg.

DEF VAR LocalCadena AS CHAR NO-UNDO.
DEF VAR LocalOrden AS INTE NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
CASE TRUE:
    WHEN pCodMat > '' THEN DO:
        FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat:
            IF NOT {&GENERAL} THEN NEXT.
            CREATE t-Almmmatg.
            BUFFER-COPY Almmmatg TO t-Almmmatg.
        END.
    END.
    WHEN CMB-filtro = 'Nombres que inicien con' AND pFiltro > '' THEN DO:
        FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA  AND Almmmatg.DesMat BEGINS pFiltro:
            IF NOT {&GENERAL} THEN NEXT.
            IF NOT {&CONDICION} THEN NEXT.
            CREATE t-Almmmatg.
            BUFFER-COPY Almmmatg TO t-Almmmatg.
        END.
    END.
    WHEN CMB-filtro = 'Nombres que contengan' AND pFiltro > '' THEN DO:
        DO LocalOrden = 1 TO NUM-ENTRIES(pFiltro, " "):
            LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") + 
                TRIM(ENTRY(LocalOrden,pFiltro, " ")) + "*".
        END.
        FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.DesMat CONTAINS LocalCadena :
            IF NOT {&GENERAL} THEN NEXT.
            IF NOT {&CONDICION} THEN NEXT.
            CREATE t-Almmmatg.
            BUFFER-COPY Almmmatg TO t-Almmmatg.
        END.
/*         LocalCadena = "*" + TRIM(pFiltro) + "*".                              */
/*         FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.DesMat MATCHES LocalCadena : */
/*             IF NOT {&GENERAL} THEN NEXT.                                      */
/*             IF NOT {&CONDICION} THEN NEXT.                                    */
/*             CREATE t-Almmmatg.                                                */
/*             BUFFER-COPY Almmmatg TO t-Almmmatg.                               */
/*         END.                                                                  */
    END.
    WHEN pMarca > '' THEN DO:
        FOR EACH Almmmatg NO-LOCK WHERE {&FILTRO3}:
            IF NOT ({&GENERAL}) THEN NEXT.
            CREATE t-Almmmatg.
            BUFFER-COPY Almmmatg TO t-Almmmatg.
        END.
    END.
    OTHERWISE DO:
        FOR EACH Almmmatg NO-LOCK WHERE {&GENERAL} AND {&CONDICION}:
            CREATE t-Almmmatg.
            BUFFER-COPY Almmmatg TO t-Almmmatg.
        END.
    END.
END CASE.

RUN Carga-Stock (pCodAlm).

RUN Carga-Precios.

SESSION:SET-WAIT-STATE('').

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devuelve-Temporal B-table-Win 
PROCEDURE Devuelve-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR ITEM.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* REASEGURAMOS EL FACTOR DE EQUIVALENCIA */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND Almmmatg.codmat = ITEM.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      pMensaje = 'Código ' + ITEM.codmat + ' NO registrado en el Catálogo' + CHR(10) + CHR(10) +
          'Grabación abortada'.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  FIND Almtfami OF Almmmatg NO-LOCK.

  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = ITEM.UndVta
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
          'Unidad de venta: ' + ITEM.UndVta + CHR(10) +
          'Grabación abortada'.
      APPLY 'ENTRY':U TO ITEM.UndVta IN BROWSE {&browse-name}.
      UNDO, RETURN "ADM-ERROR".
  END.
  F-FACTOR = Almtconv.Equival.
  ASSIGN 
      ITEM.CodCia = S-CODCIA
      ITEM.AlmDes = s-AlmDes
      ITEM.Factor = F-FACTOR
      ITEM.PorDto = f-Dsctos
      ITEM.PreBas = F-PreBas 
      ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
      ITEM.AftIgv = Almmmatg.AftIgv
      ITEM.AftIsc = Almmmatg.AftIsc
      ITEM.Libre_c04 = x-TipDto.
  ASSIGN 
      ITEM.PreUni = DEC(ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[1] = DEC(ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[2] = DEC(ITEM.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Por_Dsctos[3] = DEC(ITEM.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      ITEM.Libre_d02     = f-FleteUnitario.
  /* ***************************************************************** */
  {vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
  /* ***************************************************************** */
/*   ASSIGN                                                                                                                                          */
/*       ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni *                                                                                           */
/*                     ( 1 - ITEM.Por_Dsctos[1] / 100 ) *                                                                                            */
/*                     ( 1 - ITEM.Por_Dsctos[2] / 100 ) *                                                                                            */
/*                     ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).                                                                                        */
/*   IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0                                                                 */
/*       THEN ITEM.ImpDto = 0.                                                                                                                       */
/*       ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.                                                                                 */
/*   IF f-FleteUnitario > 0 THEN DO:                                                                                                                 */
/*       /* El flete afecta el monto final */                                                                                                        */
/*       IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */                                                                           */
/*           ASSIGN                                                                                                                                  */
/*               ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */                                            */
/*               ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.                                                                                            */
/*       END.                                                                                                                                        */
/*       ELSE DO:      /* CON descuento promocional o volumen */                                                                                     */
/*           /* El flete afecta al precio unitario resultante */                                                                                     */
/*           DEF VAR x-PreUniFin LIKE Facdpedi.PreUni NO-UNDO.                                                                                       */
/*           DEF VAR x-PreUniTeo LIKE Facdpedi.PreUni NO-UNDO.                                                                                       */
/*                                                                                                                                                   */
/*           x-PreUniFin = ITEM.ImpLin / ITEM.CanPed.          /* Valor resultante */                                                                */
/*           x-PreUniFin = x-PreUniFin + f-FleteUnitario.      /* Unitario Afectado al Flete */                                                      */
/*                                                                                                                                                   */
/*           x-PreUniTeo = x-PreUniFin / ( ( 1 - ITEM.Por_Dsctos[1] / 100 ) * ( 1 - ITEM.Por_Dsctos[2] / 100 ) * ( 1 - ITEM.Por_Dsctos[3] / 100 ) ). */
/*                                                                                                                                                   */
/*           ASSIGN                                                                                                                                  */
/*               ITEM.PreUni = ROUND(x-PreUniTeo, s-NroDec).                                                                                         */
/*       END.                                                                                                                                        */
/*       ASSIGN                                                                                                                                      */
/*           ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni *                                                                                       */
/*                         ( 1 - ITEM.Por_Dsctos[1] / 100 ) *                                                                                        */
/*                         ( 1 - ITEM.Por_Dsctos[2] / 100 ) *                                                                                        */
/*                         ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).                                                                                    */
/*       IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0                                                             */
/*           THEN ITEM.ImpDto = 0.                                                                                                                   */
/*           ELSE ITEM.ImpDto = (ITEM.CanPed * ITEM.PreUni) - ITEM.ImpLin.                                                                           */
/*   END.                                                                                                                                            */
/*   /* ***************************************************************** */                                                                         */
/*                                                                                                                                                   */
/*   ASSIGN                                                                                                                                          */
/*       ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)                                                                                                         */
/*       ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).                                                                                                        */
/*   IF ITEM.AftIsc                                                                                                                                  */
/*   THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).                                                                */
/*   ELSE ITEM.ImpIsc = 0.                                                                                                                           */
/*   IF ITEM.AftIgv                                                                                                                                  */
/*   THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).                                                           */
/*   ELSE ITEM.ImpIgv = 0.                                                                                                                           */

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
  APPLY 'ENTRY':U TO ITEM.CanPed IN BROWSE {&BROWSE-NAME}.

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
  {src/adm/template/snd-list.i "t-Almmmatg"}
  {src/adm/template/snd-list.i "ITEM"}

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

  /* Se omite cantidades en cero */                                                                                     
  IF DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 
      OR ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ? THEN RETURN 'OK'.

  /* *********************************************************************************** */
  /* UNIDAD */
  /* *********************************************************************************** */
  DEFINE VAR pCanPed AS DEC NO-UNDO.
  DEFINE VAR pMensaje AS CHAR NO-UNDO.
  DEFINE VAR hProc AS HANDLE NO-UNDO.

  RUN vtagn/ventas-library PERSISTENT SET hProc.

  pCanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  RUN VTA_Valida-Cantidad IN hProc (INPUT t-Almmmatg.CodMat,
                                    INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                    INPUT-OUTPUT pCanPed,
                                    OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pCanPed).
      APPLY 'ENTRY':U TO ITEM.CanPed.
      RETURN "ADM-ERROR".
  END.
  DELETE PROCEDURE hProc.
  
  /* *********************************************************************************** */
  /* STOCK COMPROMETIDO */
  /* *********************************************************************************** */
  DEF VAR x-StkDis AS DECI NO-UNDO.
  DEF VAR x-Factor AS DECI NO-UNDO.

  /* FACTOR DE EQUIVALENCIA */
  FIND FIRST Almtconv WHERE Almtconv.CodUnid  = t-Almmmatg.UndBas
      AND Almtconv.Codalter = t-Almmmatg.UndA
      NO-LOCK.
  x-FACTOR = Almtconv.Equival.
  ASSIGN 
      x-CanPed = DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * f-Factor
      x-StkDis = t-Almmmatg.StkMax * x-Factor.
  IF x-StkDis < x-CanPed
      THEN DO:
        MESSAGE "No hay STOCK suficiente" SKIP(1)
                "   STOCK DISPONIBLE : " x-StkDis / f-Factor ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} SKIP
                VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO ITEM.CanPed.
        RETURN "ADM-ERROR".
  END.
  /* *********************************************************************************** */
  /* *********************************************************************************** */
  /* *********************************************************************************** */
  /* RHC 09/11/2012 NO CONTINUAMOS SI ES UN ALMACEN DE REMATE */
  /* *********************************************************************************** */
  FIND Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = s-AlmDes
      NO-LOCK.
  IF Almacen.Campo-C[3] = "Si" THEN RETURN "OK".
  /* *********************************************************************************** */
  /* *********************************************************************************** */
  /* *********************************************************************************** */
  /* EMPAQUE */
  /* *********************************************************************************** */
  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.
  pCanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  RUN vtagn/p-cantidad-sugerida-v2 (INPUT s-CodDiv,
                                    INPUT s-CodDiv,
                                    INPUT t-Almmmatg.codmat,
                                    INPUT pCanPed,
                                    INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                    INPUT s-CodCli,
                                    OUTPUT pSugerido,
                                    OUTPUT pEmpaque,
                                    OUTPUT pMensaje).
  IF pMensaje > '' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(pSugerido).
      APPLY 'ENTRY':U TO ITEM.CanPed.
      RETURN "ADM-ERROR".
  END.

  /* ************************************************************************************* */
  /* ********************************* MARGEN DE UTILIDAD ******************************* */
  /* CONTRATO MARCO, REMATES, EXPOLIBRERIA, LISTA EXPRESS: NO TIENE MINIMO NI MARGEN DE UTILIDAD */
  /* ************************************************************************************* */
  /* 14/12/2022: El control es por Pricing */
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.

  x-PreUni = DECIMAL ( ITEM.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) *
      ( 1 - DECIMAL (ITEM.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) *
      ( 1 - DECIMAL (ITEM.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} )/ 100 ) *
      ( 1 - DECIMAL (ITEM.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) .

  RUN pri/pri-librerias PERSISTENT SET hProc.
  RUN PRI_Valida-Margen-Utilidad-Flash IN hProc (INPUT s-CodDiv,
                                                 INPUT t-Almmmatg.codmat,
                                                 INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                                                 INPUT x-PreUni,
                                                 INPUT t-Almmmatg.CtoUnd,
                                                 OUTPUT x-Margen,
                                                 OUTPUT x-Limite,
                                                 OUTPUT pMensaje).
/*   RUN PRI_Valida-Margen-Utilidad IN hProc (INPUT s-CodDiv,                                          */
/*                                            INPUT t-Almmmatg.codmat,                                 */
/*                                            INPUT ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, */
/*                                            INPUT x-PreUni,                                          */
/*                                            INPUT s-CodMon,                                          */
/*                                            OUTPUT x-Margen,                                         */
/*                                            OUTPUT x-Limite,                                         */
/*                                            OUTPUT pMensaje).                                        */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      /* Error crítico */
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "0.00".
      APPLY 'ENTRY':U TO ITEM.CanPed.
      RETURN "ADM-ERROR".
  END.
  DELETE PROCEDURE hProc.

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

