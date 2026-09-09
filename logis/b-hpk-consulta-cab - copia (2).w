&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR VtaCDocu.
DEFINE TEMP-TABLE T-DI-RutaC NO-UNDO LIKE DI-RutaC
       FIELD CuentaODS AS INT
       FIELD CuentaHPK AS INT
       FIELD CuentaClientes AS INT
       FIELD SumaPeso AS DEC
       FIELD SumaVolumen AS DEC
       FIELD SumaImporte AS DEC
       FIELD CuentaItems AS INT
       FIELD Bultos AS INT.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR x-CuentaODS AS INT NO-UNDO.
DEF VAR x-CuentaHPK AS INT NO-UNDO.
DEF VAR x-CuentaClientes AS INT NO-UNDO.
DEF VAR x-SumaPeso AS DEC NO-UNDO.
DEF VAR x-SumaVolumen AS DEC NO-UNDO.
DEF VAR x-SumaImporte AS DEC NO-UNDO.
DEF VAR x-CuentaItems AS INT NO-UNDO.

DEF VAR x-FlgEst AS CHAR INIT "P" NO-UNDO.
DEF VAR x-FchDoc-1 AS DATE NO-UNDO.
DEF VAR x-FchDoc-2 AS DATE NO-UNDO.
DEF VAR x-NroPed AS CHAR NO-UNDO.
DEF VAR x-NroHPK AS CHAR NO-UNDO.
DEF VAR x-NomCli AS CHAR NO-UNDO.
DEF VAR x-Bultos AS INT NO-UNDO.
DEF VAR x-FchEnt-1 AS DATE NO-UNDO.
DEF VAR x-FchEnt-2 AS DATE NO-UNDO.

&SCOPED-DEFINE Condicion (DI-RutaC.CodCia = s-CodCia AND ~
    DI-RutaC.CodDiv = s-CodDiv AND ~
    DI-RutaC.CodDoc = "PHR" AND ~
    (DI-RutaC.FchDoc >= x-FchDoc-1 AND ~
    DI-RutaC.FchDoc <= x-FchDoc-2) AND ~
    LOOKUP(SUBSTRING(DI-RutaC.FlgEst,1,1), x-FlgEst) > 0 )

DEF VAR s-Task-No AS INT NO-UNDO.

DEF VAR x-Clientes AS CHAR NO-UNDO.

IF USERID("DICTDB") = 'MASTER' OR USERID("DICTDB") = 'ADMIN' THEN DO:
    /*s-coddiv = '00040'.*/
END.

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
&Scoped-define INTERNAL-TABLES T-DI-RutaC DI-RutaC

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DI-RutaC.NroDoc DI-RutaC.FchDoc ~
DI-RutaC.Observ T-DI-RutaC.CuentaODS @ x-CuentaODS ~
T-DI-RutaC.CuentaClientes @ x-CuentaClientes T-DI-RutaC.Bultos @ x-Bultos 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST DI-RutaC OF T-DI-RutaC NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST DI-RutaC OF T-DI-RutaC NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-DI-RutaC DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DI-RutaC
&Scoped-define SECOND-TABLE-IN-QUERY-br_table DI-RutaC


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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPicador B-table-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DI-RutaC, 
      DI-RutaC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DI-RutaC.NroDoc COLUMN-LABEL "PreHoja" FORMAT "X(12)":U
      DI-RutaC.FchDoc FORMAT "99/99/9999":U
      DI-RutaC.Observ COLUMN-LABEL "Descripcion" FORMAT "x(60)":U
            WIDTH 32.14
      T-DI-RutaC.CuentaODS @ x-CuentaODS COLUMN-LABEL "O/D"
      T-DI-RutaC.CuentaClientes @ x-CuentaClientes COLUMN-LABEL "Nro Clientes"
      T-DI-RutaC.Bultos @ x-Bultos COLUMN-LABEL "Bultos" FORMAT ">,>>9":U
            WIDTH 6.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 78 BY 6.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.04 COL 1.14
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
      TABLE: B-CDocu B "?" ? INTEGRAL VtaCDocu
      TABLE: T-DI-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
      ADDITIONAL-FIELDS:
          FIELD CuentaODS AS INT
          FIELD CuentaHPK AS INT
          FIELD CuentaClientes AS INT
          FIELD SumaPeso AS DEC
          FIELD SumaVolumen AS DEC
          FIELD SumaImporte AS DEC
          FIELD CuentaItems AS INT
          FIELD Bultos AS INT
      END-FIELDS.
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
         HEIGHT             = 6.85
         WIDTH              = 133.
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
     _TblList          = "Temp-Tables.T-DI-RutaC,INTEGRAL.DI-RutaC OF Temp-Tables.T-DI-RutaC"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > INTEGRAL.DI-RutaC.NroDoc
"DI-RutaC.NroDoc" "PreHoja" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.DI-RutaC.FchDoc
     _FldNameList[3]   > INTEGRAL.DI-RutaC.Observ
"DI-RutaC.Observ" "Descripcion" ? "character" ? ? ? ? ? ? no ? no no "32.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"T-DI-RutaC.CuentaODS @ x-CuentaODS" "O/D" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"T-DI-RutaC.CuentaClientes @ x-CuentaClientes" "Nro Clientes" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"T-DI-RutaC.Bultos @ x-Bultos" "Bultos" ">,>>9" ? ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
/*     DEF VAR x-Ok AS LOG INIT NO NO-UNDO.                                                                      */
/*   /* Buscamos si la O/D está en algunas de las HPK */                                                         */
/*   IF x-NroPed > '' THEN DO:                                                                                   */
/*       FOR EACH DI-RutaD OF DI-RutaC NO-LOCK,                                                                  */
/*           EACH FacCPedi WHERE FacCPedi.CodCia = DI-RutaD.CodCia                                               */
/*           AND FacCPedi.CodDoc = DI-RutaD.CodRef                                                               */
/*           AND FacCPedi.NroPed = DI-RutaD.NroRef:                                                              */
/*           IF Faccpedi.NroPed = x-NroPed THEN DO:                                                              */
/*               x-Ok = YES.                                                                                     */
/*               LEAVE.                                                                                          */
/*           END.                                                                                                */
/*       END.                                                                                                    */
/*       IF x-Ok = NO THEN RETURN ERROR.                                                                         */
/*   END.                                                                                                        */
/*   /* ********************************************* */                                                         */
/*   ASSIGN                                                                                                      */
/*       x-CuentaODS = 0                                                                                         */
/*       x-CuentaHPK = 0                                                                                         */
/*       x-CuentaClientes = 0                                                                                    */
/*       x-SumaPeso = 0                                                                                          */
/*       x-SumaVolumen = 0                                                                                       */
/*       x-SumaImporte = 0                                                                                       */
/*       x-CuentaItems = 0                                                                                       */
/*       x-Clientes = ''.                                                                                        */
/*   FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,                                                                      */
/*       FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-Rutad.codcia AND                                      */
/*       Faccpedi.coddoc = Di-Rutad.codref AND                                                                   */
/*       Faccpedi.nroped = Di-Rutad.nroref:                                                                      */
/*       x-CuentaODS = x-CuentaODS + 1.                                                                          */
/*       IF TRUE <> (x-Clientes > '') THEN x-Clientes = Faccpedi.codcli.                                         */
/*       ELSE DO:                                                                                                */
/*           IF INDEX(x-Clientes, Faccpedi.codcli) = 0 THEN DO:                                                  */
/*               x-Clientes = x-Clientes + ',' + Faccpedi.codcli.                                                */
/*           END.                                                                                                */
/*       END.                                                                                                    */
/*       FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:                              */
/*           x-SumaPeso = x-SumaPeso + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat).                    */
/*           x-SumaVolumen = x-SumaVolumen + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.Libre_d02 / 1000000). */
/*           x-CuentaItems = x-CuentaItems + 1.                                                                  */
/*       END.                                                                                                    */
/*       x-SumaImporte = x-SumaImporte + Faccpedi.ImpTot.                                                        */
/*   END.                                                                                                        */
/*   x-CuentaClientes = NUM-ENTRIES(x-Clientes).                                                                 */
/*   FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.CodCia = Di-RutaC.CodCia AND                                         */
/*       B-CDOCU.CodOri = Di-RutaC.CodDoc   /* PHR */ AND                                                        */
/*       B-CDOCU.NroOri = Di-RutaC.NroDoc:                                                                       */
/*       IF B-CDOCU.CodDiv = Di-RutaC.CodDiv AND B-CDOCU.CodPed = 'HPK'                                          */
/*           THEN x-CuentaHPK = x-CuentaHPK  + 1.                                                                */
/*   END.                                                                                                        */

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/*     ON FIND OF Di-RutaC DO:                                                                                         */
/*         DEF VAR x-Ok AS LOG INIT NO NO-UNDO.                                                                        */
/*         /* Buscamos si la O/D está en algunas de las HPK */                                                         */
/*         IF x-NroPed > '' THEN DO:                                                                                   */
/*             FOR EACH DI-RutaD OF DI-RutaC NO-LOCK,                                                                  */
/*                 EACH FacCPedi WHERE FacCPedi.CodCia = DI-RutaD.CodCia                                               */
/*                 AND FacCPedi.CodDoc = DI-RutaD.CodRef                                                               */
/*                 AND FacCPedi.NroPed = DI-RutaD.NroRef:                                                              */
/*                 IF Faccpedi.NroPed = x-NroPed THEN DO:                                                              */
/*                     x-Ok = YES.                                                                                     */
/*                     LEAVE.                                                                                          */
/*                 END.                                                                                                */
/*             END.                                                                                                    */
/*             IF x-Ok = NO THEN RETURN ERROR.                                                                         */
/*         END.                                                                                                        */
/*     END.                                                                                                            */
/*     ON ROW-DISPLAY OF {&BROWSE-NAME} DO:                                                                            */
/*         /* ********************************************* */                                                         */
/*         ASSIGN                                                                                                      */
/*             x-CuentaODS = 0                                                                                         */
/*             x-CuentaHPK = 0                                                                                         */
/*             x-CuentaClientes = 0                                                                                    */
/*             x-SumaPeso = 0                                                                                          */
/*             x-SumaVolumen = 0                                                                                       */
/*             x-SumaImporte = 0                                                                                       */
/*             x-CuentaItems = 0                                                                                       */
/*             x-Clientes = ''.                                                                                        */
/*         FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,                                                                      */
/*             FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-Rutad.codcia AND                                      */
/*             Faccpedi.coddoc = Di-Rutad.codref AND                                                                   */
/*             Faccpedi.nroped = Di-Rutad.nroref:                                                                      */
/*             x-CuentaODS = x-CuentaODS + 1.                                                                          */
/*             IF TRUE <> (x-Clientes > '') THEN x-Clientes = Faccpedi.codcli.                                         */
/*             ELSE DO:                                                                                                */
/*                 IF INDEX(x-Clientes, Faccpedi.codcli) = 0 THEN DO:                                                  */
/*                     x-Clientes = x-Clientes + ',' + Faccpedi.codcli.                                                */
/*                 END.                                                                                                */
/*             END.                                                                                                    */
/*             FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:                              */
/*                 x-SumaPeso = x-SumaPeso + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.PesMat).                    */
/*                 x-SumaVolumen = x-SumaVolumen + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.Libre_d02 / 1000000). */
/*                 x-CuentaItems = x-CuentaItems + 1.                                                                  */
/*             END.                                                                                                    */
/*             x-SumaImporte = x-SumaImporte + Faccpedi.ImpTot.                                                        */
/*         END.                                                                                                        */
/*         x-CuentaClientes = NUM-ENTRIES(x-Clientes).                                                                 */
/*         FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.CodCia = Di-RutaC.CodCia AND                                         */
/*             B-CDOCU.CodOri = Di-RutaC.CodDoc   /* PHR */ AND                                                        */
/*             B-CDOCU.NroOri = Di-RutaC.NroDoc:                                                                       */
/*             IF B-CDOCU.CodDiv = Di-RutaC.CodDiv AND B-CDOCU.CodPed = 'HPK'                                          */
/*                 THEN x-CuentaHPK = x-CuentaHPK  + 1.                                                                */
/*         END.                                                                                                        */
/*     END.                                                                                                            */

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

DEF OUTPUT PARAMETER TABLE FOR T-DI-RutaC.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Filtros B-table-Win 
PROCEDURE Carga-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pFlgEst   AS CHAR.
DEF INPUT PARAMETER pFchDoc-1 AS DATE.
DEF INPUT PARAMETER pFchDoc-2 AS DATE.
DEF INPUT PARAMETER pNroPed   AS CHAR.
DEF INPUT PARAMETER pNroHPK   AS CHAR.
DEF INPUT PARAMETER pNomCli   AS CHAR.
DEF INPUT PARAMETER pFchEnt-1 AS DATE.
DEF INPUT PARAMETER pFchEnt-2 AS DATE.

x-FlgEst = pFlgEst.
x-FchDoc-1 = pFchDoc-1.
x-FchDoc-2 = pFchDoc-2.
x-NroPed = pNroPed.
x-NroHPK = pNroHPK.
x-NomCli = pNomCli.
x-FchEnt-1 = pFchEnt-1.
x-FchEnt-2 = pFchEnt-2.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reflejo B-table-Win 
PROCEDURE Carga-Reflejo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-Di-RutaC.

DEF VAR x-Ok AS LOG INIT NO NO-UNDO.
DEFINE VAR x-inicio AS CHAR.
DEFINE VAR x-termino AS CHAR.
DEFINE VAR x-flag AS LOG.

x-inicio = STRING(TIME,"HH:MM:SS").

FOR EACH Di-RutaC NO-LOCK WHERE DI-RutaC.CodCia = s-CodCia AND 
    DI-RutaC.CodDoc = "PHR" AND 
    (DI-RutaC.FchDoc >= x-FchDoc-1 AND 
    DI-RutaC.FchDoc <= x-FchDoc-2) AND
    DI-RutaC.CodDiv = s-CodDiv:
    IF NOT LOOKUP(TRIM(DI-RutaC.FlgEst), x-FlgEst) > 0 THEN NEXT.

    /* Buscamos si tiene al menos 1 registro en el detalle */
    FIND FIRST Vtacdocu USE-INDEX Llave08 WHERE Vtacdocu.CodCia = Di-RutaC.CodCia
        AND Vtacdocu.CodOri = Di-RutaC.CodDoc
        AND Vtacdocu.NroOri = Di-RutaC.NroDoc
        AND Vtacdocu.CodDiv = Di-RutaC.CodDiv
        AND Vtacdocu.CodPed = "HPK"
        AND Vtacdocu.FlgEst <> "A"
        AND Vtacdocu.FlgSit <> "C"
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN NEXT.

    /* Buscamos si la O/D está en algunas de las HPK */
    IF x-NroPed > '' OR x-NomCli > '' THEN DO:
        x-Ok = NO.
        FOR EACH DI-RutaD OF DI-RutaC NO-LOCK,
            FIRST FacCPedi WHERE FacCPedi.CodCia = DI-RutaD.CodCia
            AND FacCPedi.CodDoc = DI-RutaD.CodRef
            AND FacCPedi.NroPed = DI-RutaD.NroRef NO-LOCK:
            IF x-NroPed > '' AND Faccpedi.NroPed = x-NroPed THEN DO:
                x-Ok = YES.
                LEAVE.
            END.
            IF x-NomCli > '' AND INDEX(Faccpedi.NomCli, x-NomCli) > 0 THEN DO:
                x-Ok = YES.
                LEAVE.
            END.
        END.
        IF x-Ok = NO THEN NEXT.
    END.
    /* Por # HPK */
    IF x-NroHPK > '' THEN DO:
        x-Ok = NO.
        FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.CodCia = Di-RutaC.CodCia AND
            B-CDOCU.CodOri = Di-RutaC.CodDoc   /* PHR */ AND
            B-CDOCU.NroOri = Di-RutaC.NroDoc:
            IF B-CDOCU.CodDiv = Di-RutaC.CodDiv AND B-CDOCU.CodPed = 'HPK' AND
                B-CDOCU.NroPed = x-NroHPK THEN DO:
                x-Ok = YES.
                LEAVE.
            END.
        END.
        IF x-Ok = NO THEN NEXT.
    END.
    /* Por Fecha de Entrega */
    IF x-FchEnt-1 <> ? THEN DO:
        FIND FIRST B-CDOCU WHERE B-CDOCU.CodCia = Di-RutaC.CodCia AND
            B-CDOCU.CodOri = Di-RutaC.CodDoc   /* PHR */ AND
            B-CDOCU.NroOri = Di-RutaC.NroDoc AND
            B-CDOCU.CodPed = "HPK" AND 
            B-CDOCU.FchEnt >= x-FchEnt-1
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDOCU THEN NEXT.
    END.
    
    IF x-FchEnt-2 <> ? THEN DO:
        FIND LAST B-CDOCU WHERE B-CDOCU.CodCia = Di-RutaC.CodCia AND
            B-CDOCU.CodOri = Di-RutaC.CodDoc   /* PHR */ AND
            B-CDOCU.NroOri = Di-RutaC.NroDoc AND
            B-CDOCU.CodPed = "HPK" AND 
            B-CDOCU.FchEnt <= x-FchEnt-2
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDOCU THEN NEXT.
    END.

    /* ******************** */
    CREATE T-Di-RutaC.
    BUFFER-COPY Di-RutaC TO T-Di-RutaC.
END.

x-flag = NO.

FOR EACH T-Di-RutaC EXCLUSIVE-LOCK, FIRST Di-RutaC OF T-Di-RutaC NO-LOCK:
    /* ********************************************* */
    ASSIGN
        x-CuentaODS = 0
        x-CuentaHPK = 0
        x-CuentaClientes = 0
        x-SumaPeso = 0
        x-SumaVolumen = 0
        x-SumaImporte = 0
        x-CuentaItems = 0
        x-Clientes = ''
        x-Bultos = 0.
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
        FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-Rutad.codcia AND
        Faccpedi.coddoc = Di-Rutad.codref AND
        Faccpedi.nroped = Di-Rutad.nroref:

        x-CuentaODS = x-CuentaODS + 1.
        IF TRUE <> (x-Clientes > '') THEN x-Clientes = Faccpedi.codcli.
        ELSE DO:
            IF INDEX(x-Clientes, Faccpedi.codcli) = 0 THEN DO:
                x-Clientes = x-Clientes + ',' + Faccpedi.codcli.
            END.
        END.
        /* 06/04/2022 */
        FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-codcia AND
            CcbCBult.CodDiv = s-coddiv AND
            CcbCBult.CodDoc = Faccpedi.coddoc AND
            CcbCBult.NroDoc = Faccpedi.nroped :
            x-Bultos = x-Bultos + CcbCBult.Bultos.
        END.
        x-SumaImporte = x-SumaImporte + Faccpedi.ImpTot.
    END.    

    x-CuentaClientes = NUM-ENTRIES(x-Clientes).
    ASSIGN
        T-Di-RutaC.CuentaODS = x-CuentaODS
        T-Di-RutaC.CuentaHPK = x-CuentaHPK
        T-Di-RutaC.CuentaClientes = x-CuentaClientes
        T-Di-RutaC.SumaPeso = x-SumaPeso
        T-Di-RutaC.SumaVolumen = x-SumaVolumen
        T-Di-RutaC.SumaImporte = x-SumaImporte
        T-Di-RutaC.CuentaItems = x-CuentaItems
        T-Di-RutaC.Bultos = x-Bultos.
END.
FOR EACH T-Di-RutaC WHERE T-Di-RutaC.CuentaODS = 0:
    DELETE T-Di-RutaC.
END.

x-termino = STRING(TIME,"HH:MM:SS").

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

DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF INPUT PARAMETER pFlgSit AS CHAR.

DEF VAR x-SumaPeso AS DEC NO-UNDO.
DEF VAR x-SumaVolumen AS DEC NO-UNDO.
DEF VAR x-CuentaItems AS INT NO-UNDO.

FOR EACH VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = Di-RutaC.CodCia AND
    VtaCDocu.CodOri = Di-RutaC.CodDoc AND
    VtaCDocu.NroOri = Di-RutaC.NroDoc AND
    VtaCDocu.CodDiv = Di-RutaC.CodDiv AND
    VtaCDocu.CodPed = "HPK":
    /* FILTROS */
    IF NOT ( TRUE <> (pFlgEst > '') OR VtaCDocu.FlgEst = pFlgEst ) THEN NEXT.
    IF NOT ( TRUE <> (pFlgSit > '') OR LOOKUP(VtaCDocu.FlgSit, pFlgSit) > 0 ) THEN NEXT.
    /* RHC 29/11/2019 O/D y OTR NO anuladas */
    IF CAN-FIND(FIRST Faccpedi WHERE Faccpedi.codcia = VtaCDocu.CodCia AND
                Faccpedi.coddoc = Vtacdocu.codref AND
                Faccpedi.nroped = Vtacdocu.nroref AND
                Faccpedi.flgest = "A" NO-LOCK)
        THEN NEXT.
    IF s-Task-No = 0 THEN REPEAT:
        s-Task-No = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN LEAVE.
    END.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.Llave-C = Di-RutaC.NroDoc + " " + DI-RutaC.Observ
        .
    ASSIGN
        x-SumaPeso = 0
        x-SumaVolumen = 0
        x-CuentaItems = 0.
/*     FOR EACH VtaDDocu OF VtaCDocu NO-LOCK, FIRST Almmmatg OF VtaDDocu NO-LOCK:                              */
/*         x-SumaPeso = x-SumaPeso + (Vtaddocu.CanPed * Vtaddocu.Factor * Almmmatg.PesMat).                    */
/*         x-SumaVolumen = x-SumaVolumen + (Vtaddocu.CanPed * Vtaddocu.Factor * Almmmatg.Libre_d02 / 1000000). */
/*         x-CuentaItems = x-CuentaItems + 1.                                                                  */
/*     END.                                                                                                    */
    ASSIGN
        x-SumaPeso = VtaCDocu.Peso 
        x-SumaVolumen = VtaCDocu.Volumen 
        x-CuentaItems = VtaCDocu.Items.

    ASSIGN
        w-report.Campo-C[1] = VtaCDocu.CodPed 
        w-report.Campo-C[2] = VtaCDocu.NroPed
        w-report.Campo-C[9] = VtaCDocu.CodRef
        w-report.Campo-C[10] = VtaCDocu.NroRef
        .
    ASSIGN
        w-report.Campo-F[1] = x-CuentaItems
        w-report.Campo-F[2] = x-SumaPeso
        w-report.Campo-F[3] = x-SumaVolumen
        .
    FIND Faccpedi WHERE Faccpedi.codcia = VtaCDocu.CodCia AND
        Faccpedi.coddoc = Vtacdocu.codref AND
        Faccpedi.nroped = Vtacdocu.nroref
        NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN w-report.Campo-D[1] = Faccpedi.fchent.
    FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = VtaCDocu.CodCia
        AND LogTrkDocs.CodDoc = VtaCDocu.CodPed
        AND LogTrkDocs.NroDoc = VtaCDocu.NroPed
        AND LogTrkDocs.Clave = "TRCKHPK",
        EACH TabTrkDocs WHERE TabTrkDocs.CodCia = LogTrkDocs.CodCia
        AND TabTrkDocs.Clave = LogTrkDocs.Clave
        AND TabTrkDocs.Codigo = LogTrkDocs.Codigo NO-LOCK:
        IF LogTrkDocs.Codigo = "PK_SEM" THEN   /* MRC 23/11/2020 */
            ASSIGN w-report.Campo-C[4] = STRING(LogTrkDocs.Fecha, '99/99/9999 HH:MM:SS').
        ASSIGN
            w-report.Campo-C[3] = TabTrkDocs.NomCorto
            /*w-report.Campo-C[4] = STRING(LogTrkDocs.Fecha, '99/99/9999 HH:MM:SS')*/
            w-report.Campo-C[5] =  VtaCDocu.CodTer      /* TIPO */
            w-report.Campo-C[6] = fPicador(VtaCDocu.UsrSac)
            .
        FIND FIRST ChkTareas WHERE ChkTareas.CodCia = VtaCDocu.CodCia
            AND ChkTareas.CodDiv = VtaCDocu.CodDiv
            AND ChkTareas.CodDoc = VtaCDocu.CodPed
            AND ChkTareas.NroPed = VtaCDocu.NroPed
            NO-LOCK NO-ERROR.
        IF AVAILABLE ChkTareas THEN w-report.Campo-C[7] = ChkTareas.Mesa.
        ELSE w-report.Campo-C[7] = ''.
    END.
    /* Bultos por HPK */
    FOR EACH logisdchequeo NO-LOCK WHERE logisdchequeo.CodCia = s-codcia AND
        logisdchequeo.CodDiv = s-coddiv AND 
        logisdchequeo.CodPed = Vtacdocu.codped AND
        logisdchequeo.NroPed = Vtacdocu.nroped 
        BREAK BY logisdchequeo.Etiqueta:
        IF FIRST-OF(logisdchequeo.Etiqueta) THEN w-report.Campo-F[4] = w-report.Campo-F[4] + 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-2 B-table-Win 
PROCEDURE Carga-Temporal-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-SumaPeso    AS DEC NO-UNDO.
DEF VAR x-SumaVolumen AS DEC NO-UNDO.
DEF VAR x-SumaImporte AS DEC NO-UNDO.
DEF VAR x-CuentaItems AS INT NO-UNDO.
DEF VAR x-Bultos      AS DEC NO-UNDO.
DEF VAR x-Estado      AS CHAR NO-UNDO.

FOR EACH DI-RutaD OF DI-RutaC NO-LOCK,
    EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = DI-RutaD.CodCia
    AND FacCPedi.CodDoc = DI-RutaD.CodRef
    AND FacCPedi.NroPed = DI-RutaD.NroRef:
    /* RHC 29/11/2019 O/D y OTR NO anuladas */
    IF Faccpedi.flgest = "A" THEN NEXT.

    IF s-Task-No = 0 THEN REPEAT:
        s-Task-No = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN LEAVE.
    END.
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.Llave-C = Di-RutaC.NroDoc + " " + DI-RutaC.Observ
        w-report.Campo-C[1] = Faccpedi.CodDoc
        w-report.Campo-C[2] = Faccpedi.NroPed
        w-report.Campo-C[10] = Faccpedi.NomCli.
    ASSIGN
        x-SumaPeso = 0
        x-SumaVolumen = 0
        x-SumaImporte = 0
        x-CuentaItems = 0
        x-Bultos = 0
        .
    RUN gn/p-status-pedido (Faccpedi.coddoc, Faccpedi.nroped, OUTPUT x-Estado).
    FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-codcia AND
        LogTrkDocs.CodDoc = Faccpedi.CodDoc AND
        LogTrkDocs.NroDoc = Faccpedi.NroPed AND
        LogTrkDocs.Clave = 'TRCKPED' AND
        LogTrkDocs.Codigo = x-Estado,
        FIRST TabTrkDocs NO-LOCK WHERE TabTrkDocs.CodCia = LogTrkDocs.CodCia AND
        TabTrkDocs.Clave = LogTrkDocs.Clave AND
        TabTrkDocs.Codigo = LogTrkDocs.Codigo
        BY LogTrkDocs.Orden BY LogTrkDocs.Fecha:
        IF x-Estado = "PK_SEM" THEN    /* MRC 23/11/2020 */
            ASSIGN w-report.Campo-C[4] = STRING(LogTrkDocs.Fecha, '99/99/9999 HH:MM:SS').
        ASSIGN
            w-report.Campo-C[3] = TabTrkDocs.NomCorto
            /*w-report.Campo-C[4] = STRING(LogTrkDocs.Fecha, '99/99/9999 HH:MM:SS')*/
            .
    END.
    ASSIGN
        x-SumaPeso = Faccpedi.Peso
        x-SumaVolumen = Faccpedi.Volumen
        x-CuentaItems = FacCPedi.Items
        x-SumaImporte = Faccpedi.AcuBon[8].
    ASSIGN
        w-report.Campo-F[1] = x-CuentaItems
        w-report.Campo-F[2] = x-SumaPeso
        w-report.Campo-F[3] = x-SumaVolumen
        .
    ASSIGN
        x-Bultos = Faccpedi.AcuBon[9].
    ASSIGN
        w-report.Campo-F[4] = x-Bultos.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Un registro a la vez
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE DI-RutaC THEN RETURN.

  DEF INPUT PARAMETER pTipo AS INT.

  DEF VAR k AS INT NO-UNDO.

  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  CASE pTipo:
      WHEN 1 THEN DO:     /* Página 1 */
          SESSION:SET-WAIT-STATE('GENERAL').
          s-Task-No = 0.
          DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
              IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN RUN Carga-Temporal ("","").
          END.
          SESSION:SET-WAIT-STATE('').
          GET-KEY-VALUE SECTION 'StartUp' KEY 'Base' VALUE RB-REPORT-LIBRARY.
          RB-REPORT-LIBRARY  = RB-REPORT-LIBRARY + "logis/rblogis.prl".
          RB-REPORT-NAME     = "Consulta General de Pedidos".
          RB-INCLUDE-RECORDS = "O".
          RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
          RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.
      END.
      WHEN 2 THEN DO:     /* Página 2 */
          SESSION:SET-WAIT-STATE('GENERAL').
          s-Task-No = 0.
          DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
              IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN RUN Carga-Temporal-2.
          END.
          SESSION:SET-WAIT-STATE('').
          GET-KEY-VALUE SECTION 'StartUp' KEY 'Base' VALUE RB-REPORT-LIBRARY.
          RB-REPORT-LIBRARY  = RB-REPORT-LIBRARY + "logis/rblogis.prl".
          RB-REPORT-NAME     = "Consulta General de Pedidos 2".
          RB-INCLUDE-RECORDS = "O".
          RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
          RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.
      END.
  END CASE.
  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Todo B-table-Win 
PROCEDURE Imprimir-Todo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE DI-RutaC THEN RETURN.

  DEF INPUT PARAMETER pTipo AS INT.

  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  CASE pTipo:
      WHEN 1 THEN DO:     /* Página 1 */
          SESSION:SET-WAIT-STATE('GENERAL').
          s-Task-No = 0.
          FOR EACH T-DI-RutaC NO-LOCK, FIRST DI-RutaC OF T-DI-RutaC NO-LOCK:
              RUN Carga-Temporal ("","").
          END.
          SESSION:SET-WAIT-STATE('').
          GET-KEY-VALUE SECTION 'StartUp' KEY 'Base' VALUE RB-REPORT-LIBRARY.
          RB-REPORT-LIBRARY  = RB-REPORT-LIBRARY + "logis/rblogis.prl".
          RB-REPORT-NAME     = "Consulta General de Pedidos".
          RB-INCLUDE-RECORDS = "O".
          RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
          RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.
      END.
      WHEN 2 THEN DO:     /* Página 2 */
          SESSION:SET-WAIT-STATE('GENERAL').
          s-Task-No = 0.
          FOR EACH T-DI-RutaC NO-LOCK, FIRST DI-RutaC OF T-DI-RutaC NO-LOCK:
              RUN Carga-Temporal-2.
          END.
          SESSION:SET-WAIT-STATE('').
          GET-KEY-VALUE SECTION 'StartUp' KEY 'Base' VALUE RB-REPORT-LIBRARY.
          RB-REPORT-LIBRARY  = RB-REPORT-LIBRARY + "logis/rblogis.prl".
          RB-REPORT-NAME     = "Consulta General de Pedidos 2".
          RB-INCLUDE-RECORDS = "O".
          RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
          RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.
      END.
  END CASE.
  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir-Todo-Almacen B-table-Win 
PROCEDURE Imprimir-Todo-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE DI-RutaC THEN RETURN.

  DEF INPUT PARAMETER pTipo AS INT.

  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  CASE pTipo:
      WHEN 1 THEN DO:     /* Página 1 */
          SESSION:SET-WAIT-STATE('GENERAL').
          s-Task-No = 0.
          FOR EACH T-DI-RutaC NO-LOCK, FIRST DI-RutaC OF T-DI-RutaC NO-LOCK:
              RUN Carga-Temporal ("P","TI,T,TP,TX,P,PT,PO,PC,PE").
          END.
          SESSION:SET-WAIT-STATE('').
          GET-KEY-VALUE SECTION 'StartUp' KEY 'Base' VALUE RB-REPORT-LIBRARY.
          RB-REPORT-LIBRARY  = RB-REPORT-LIBRARY + "logis/rblogis.prl".
          RB-REPORT-NAME     = "Consulta General de Pedidos".
          RB-INCLUDE-RECORDS = "O".
          RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
          RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.
      END.
      WHEN 2 THEN DO:     /* Página 2 */
          SESSION:SET-WAIT-STATE('GENERAL').
          s-Task-No = 0.
          FOR EACH T-DI-RutaC NO-LOCK, FIRST DI-RutaC OF T-DI-RutaC NO-LOCK:
              RUN Carga-Temporal-2.
          END.
          SESSION:SET-WAIT-STATE('').
          GET-KEY-VALUE SECTION 'StartUp' KEY 'Base' VALUE RB-REPORT-LIBRARY.
          RB-REPORT-LIBRARY  = RB-REPORT-LIBRARY + "logis/rblogis.prl".
          RB-REPORT-NAME     = "Consulta General de Pedidos 2".
          RB-INCLUDE-RECORDS = "O".
          RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
          RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.
      END.
  END CASE.
  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').

  GET-KEY-VALUE SECTION 'StartUp' KEY 'Base' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY  = RB-REPORT-LIBRARY + "logis/rblogis.prl".
  RB-REPORT-NAME     = "Consulta General de Pedidos".
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
  RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.

  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  SESSION:SET-WAIT-STATE('GENERAL').

  DEFINE VAR x-inicio AS CHAR.
  DEFINE VAR x-termino AS CHAR.

  x-inicio = STRING(TIME,"HH:MM:SS").

  RUN Carga-Reflejo.
  SESSION:SET-WAIT-STATE('').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  x-termino = STRING(TIME,"HH:MM:SS").

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
  {src/adm/template/snd-list.i "T-DI-RutaC"}
  {src/adm/template/snd-list.i "DI-RutaC"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    /* Cargamos su status */
    DEF VAR x-Status AS CHAR NO-UNDO.
    RUN gn/p-status-pedido (Faccpedi.coddoc, Faccpedi.nroped, OUTPUT x-Status).
    FIND TabTrkDocs WHERE TabTrkDocs.CodCia = s-codcia AND
        TabTrkDocs.Clave = 'TRCKPED' AND
        TabTrkDocs.Codigo = x-Status
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabTrkDocs  THEN x-Status = TabTrkDocs.NomCorto.
    RETURN x-Status.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPicador B-table-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  RUN logis/p-busca-por-dni.p (pDNI, OUTPUT pNombre, OUTPUT pOrigen).
  RETURN pNombre.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

