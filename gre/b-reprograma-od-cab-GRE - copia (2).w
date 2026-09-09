&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-AlmCDocu FOR AlmCDocu.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu
       FIELD EstadoHR AS CHAR.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE CcbDDocu.



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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.

DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.

DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE TEMP-TABLE T-DPEDI  LIKE Facdpedi.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.

DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodDiv LIKE CcbCDOcu.CodDiv 
    FIELD CodDoc LIKE CcbCDocu.CodDoc
    FIELD NroDoc LIKE CcbCDocu.Nrodoc
    INDEX Llave01 codcia coddiv coddoc nrodoc.

DEF BUFFER B-ADocu FOR CcbADocu.
DEF BUFFER OD_ORIGINAL  FOR Faccpedi.
DEF BUFFER b-faccpedi  FOR Faccpedi.
DEF BUFFER PED_ORIGINAL FOR Faccpedi.
DEF BUFFER ORDEN        FOR Faccpedi.

DEF VAR iSerieNC AS INT NO-UNDO.        /* Serie de la N/C que el usuario va a elegir */
DEF VAR fFchEnt  AS DATE NO-UNDO.
DEF VAR fFchEntOri AS DATE NO-UNDO.

DEFINE TEMP-TABLE OD_reprogramadas
    FIELD tcoddoc   AS  CHAR    FORMAT 'x(5)'       /* O/D */
    FIELD tcoddiv   AS  CHAR    FORMAT 'x(8)'
    FIELD tnrodoc   AS  CHAR    FORMAT 'x(15)'
    FIELD tcodped   AS  CHAR    FORMAT 'x(5)'
    FIELD tnroped   AS  CHAR    FORMAT 'x(15)'
    FIELD tcodcot   AS  CHAR    FORMAT 'x(5)'
    FIELD tnrocot   AS  CHAR    FORMAT 'x(15)'
    FIELD tfchent   AS  DATE                        /* La nueva fecha de entrega */
    INDEX Idx01 tcoddiv tcoddoc tnrodoc.

DEF VAR x-NroRep AS INT NO-UNDO.        /* Nro. de reprogramaciones */

&SCOPED-DEFINE Condicion (AlmCDocu.CodCia = s-CodCia ~
 AND AlmCDocu.CodLlave = s-CodDiv ~
 AND AlmCDocu.CodDoc = s-CodDoc ~
 AND AlmCDocu.FlgEst = "P")


/* GRE */
DEF BUFFER x-faccpedi  FOR Faccpedi.
DEFINE BUFFER x-AlmCDocu FOR AlmCDocu.
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-gre_cmpte FOR gre_cmpte.
DEFINE BUFFER b-gre_cmpte FOR gre_cmpte.

DEFINE VAR lGeneraControlParaGenerarPGRE AS LOG INIT NO.

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
&Scoped-define INTERNAL-TABLES AlmCDocu FacCPedi almtabla gn-ven CcbCBult

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table fNroRep() @ x-NroRep ~
AlmCDocu.FchDoc AlmCDocu.CodDoc AlmCDocu.NroDoc FacCPedi.CodDiv ~
AlmCDocu.Libre_c01 AlmCDocu.Libre_c02 FacCPedi.CodCli FacCPedi.NomCli ~
AlmCDocu.Libre_d01 AlmCDocu.Libre_d02 AlmCDocu.Libre_d03 CcbCBult.Bultos ~
almtabla.Nombre gn-ven.NomVen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH AlmCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = AlmCDocu.CodCia ~
  AND FacCPedi.CodDoc = AlmCDocu.CodDoc ~
  AND FacCPedi.NroPed = AlmCDocu.NroDoc NO-LOCK, ~
      FIRST almtabla WHERE almtabla.Codigo = AlmCDocu.Libre_c03 ~
      AND almtabla.Tabla = "HR" ~
 AND almtabla.NomAnt = "N" OUTER-JOIN NO-LOCK, ~
      FIRST gn-ven OF FacCPedi OUTER-JOIN NO-LOCK, ~
      FIRST CcbCBult WHERE CcbCBult.CodCia = FacCPedi.CodCia ~
  AND CcbCBult.CodDoc = FacCPedi.CodDoc ~
  AND CcbCBult.NroDoc = FacCPedi.NroPed OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH AlmCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = AlmCDocu.CodCia ~
  AND FacCPedi.CodDoc = AlmCDocu.CodDoc ~
  AND FacCPedi.NroPed = AlmCDocu.NroDoc NO-LOCK, ~
      FIRST almtabla WHERE almtabla.Codigo = AlmCDocu.Libre_c03 ~
      AND almtabla.Tabla = "HR" ~
 AND almtabla.NomAnt = "N" OUTER-JOIN NO-LOCK, ~
      FIRST gn-ven OF FacCPedi OUTER-JOIN NO-LOCK, ~
      FIRST CcbCBult WHERE CcbCBult.CodCia = FacCPedi.CodCia ~
  AND CcbCBult.CodDoc = FacCPedi.CodDoc ~
  AND CcbCBult.NroDoc = FacCPedi.NroPed OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table AlmCDocu FacCPedi almtabla gn-ven ~
CcbCBult
&Scoped-define FIRST-TABLE-IN-QUERY-br_table AlmCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table almtabla
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table gn-ven
&Scoped-define FIFTH-TABLE-IN-QUERY-br_table CcbCBult


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
NroDoc|y||INTEGRAL.AlmCDocu.NroDoc|yes
NomCli|||INTEGRAL.FacCPedi.NomCli|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'NroDoc,NomCli' + '",
     SortBy-Case = ':U + 'NroDoc').

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNroRep B-table-Win 
FUNCTION fNroRep RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      AlmCDocu, 
      FacCPedi, 
      almtabla
    FIELDS(almtabla.Nombre), 
      gn-ven
    FIELDS(gn-ven.NomVen), 
      CcbCBult
    FIELDS(CcbCBult.Bultos) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      fNroRep() @ x-NroRep COLUMN-LABEL "Reprog." FORMAT ">>9":U
            WIDTH 6.43
      AlmCDocu.FchDoc COLUMN-LABEL "Fecha Cierre" FORMAT "99/99/9999":U
      AlmCDocu.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U WIDTH 3.86
      AlmCDocu.NroDoc FORMAT "X(12)":U
      FacCPedi.CodDiv FORMAT "x(5)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      AlmCDocu.Libre_c01 COLUMN-LABEL "Doc" FORMAT "x(3)":U
      AlmCDocu.Libre_c02 COLUMN-LABEL "Hoja de Ruta" FORMAT "x(12)":U
      FacCPedi.CodCli FORMAT "x(11)":U WIDTH 10.86
      FacCPedi.NomCli FORMAT "x(100)":U WIDTH 31.72
      AlmCDocu.Libre_d01 COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
      AlmCDocu.Libre_d02 COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
            WIDTH 5.43
      AlmCDocu.Libre_d03 COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
            WIDTH 6.72
      CcbCBult.Bultos FORMAT ">>>9":U
      almtabla.Nombre COLUMN-LABEL "Motivo" FORMAT "x(40)":U WIDTH 21.14
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 9
      gn-ven.NomVen FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 140 BY 6.69
         FONT 4.


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
      TABLE: B-AlmCDocu B "?" ? INTEGRAL AlmCDocu
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: DETA T "?" ? INTEGRAL CcbDDocu
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          FIELD EstadoHR AS CHAR
      END-FIELDS.
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
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
         WIDTH              = 143.72.
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

ASSIGN 
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.AlmCDocu,INTEGRAL.FacCPedi WHERE INTEGRAL.AlmCDocu ...,INTEGRAL.almtabla WHERE INTEGRAL.AlmCDocu ...,INTEGRAL.gn-ven OF INTEGRAL.FacCPedi,INTEGRAL.CcbCBult WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER USED, FIRST OUTER USED, FIRST OUTER USED"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "FacCPedi.CodCia = AlmCDocu.CodCia
  AND FacCPedi.CodDoc = AlmCDocu.CodDoc
  AND FacCPedi.NroPed = AlmCDocu.NroDoc"
     _JoinCode[3]      = "INTEGRAL.almtabla.Codigo = AlmCDocu.Libre_c03"
     _Where[3]         = "almtabla.Tabla = ""HR""
 AND almtabla.NomAnt = ""N"""
     _JoinCode[5]      = "INTEGRAL.CcbCBult.CodCia = FacCPedi.CodCia
  AND INTEGRAL.CcbCBult.CodDoc = FacCPedi.CodDoc
  AND INTEGRAL.CcbCBult.NroDoc = FacCPedi.NroPed"
     _FldNameList[1]   > "_<CALC>"
"fNroRep() @ x-NroRep" "Reprog." ">>9" ? ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.AlmCDocu.FchDoc
"AlmCDocu.FchDoc" "Fecha Cierre" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.AlmCDocu.CodDoc
"AlmCDocu.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no "3.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.AlmCDocu.NroDoc
"AlmCDocu.NroDoc" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.CodDiv
"FacCPedi.CodDiv" ? ? "character" 10 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.AlmCDocu.Libre_c01
"AlmCDocu.Libre_c01" "Doc" "x(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.AlmCDocu.Libre_c02
"AlmCDocu.Libre_c02" "Hoja de Ruta" "x(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "31.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.AlmCDocu.Libre_d01
"AlmCDocu.Libre_d01" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.AlmCDocu.Libre_d02
"AlmCDocu.Libre_d02" "Peso" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.AlmCDocu.Libre_d03
"AlmCDocu.Libre_d03" "Volumen" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.CcbCBult.Bultos
"CcbCBult.Bultos" ? ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.almtabla.Nombre
"almtabla.Nombre" "Motivo" ? "character" 9 15 ? ? ? ? no ? no no "21.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   = INTEGRAL.gn-ven.NomVen
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
    IF NOT AVAILABLE Almcdocu THEN RETURN.
    IF fNroRep() >= 2 THEN DO:
        ASSIGN
            AlmCDocu.CodDoc:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            AlmCDocu.FchDoc:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            AlmCDocu.Libre_c01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            AlmCDocu.Libre_c02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            AlmCDocu.Libre_d01:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            AlmCDocu.Libre_d02:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            AlmCDocu.Libre_d03:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            AlmCDocu.NroDoc:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            FacCPedi.CodCli:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            FacCPedi.NomCli:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            almtabla.Nombre:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14 
            .
        ASSIGN
            AlmCDocu.CodDoc:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0
            AlmCDocu.FchDoc:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
            AlmCDocu.Libre_c01:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0
            AlmCDocu.Libre_c02:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
            AlmCDocu.Libre_d01:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
            AlmCDocu.Libre_d02:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
            AlmCDocu.Libre_d03:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
            AlmCDocu.NroDoc:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0
            FacCPedi.CodCli:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0
            FacCPedi.NomCli:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
            almtabla.Nombre:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0 
            .
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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
    DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    CASE hSortColumn:NAME:
        WHEN "NroDoc" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NroDoc').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "NomCli" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NomCli').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
    END CASE.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ACTUALIZA_FECHA_ENTREGA B-table-Win 
PROCEDURE ACTUALIZA_FECHA_ENTREGA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR.
DEFINE VAR pCuenta AS INTE NO-UNDO.


/***/
/*
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = 'd:\xpciman\OtrapruebaZZ.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer OD_REPROGRAMADAS:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer OD_REPROGRAMADAS:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.
*/

pMensaje = "".

ACT_FECHA:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH OD_REPROGRAMADAS :
        /* O/D */
        FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND
            b-faccpedi.coddoc = OD_REPROGRAMADAS.tcoddoc AND
            b-faccpedi.nroped = OD_REPROGRAMADAS.tnrodoc EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            pMensaje = "ERROR O/D:" + CHR(10) + pMensaje.
            UNDO ACT_FECHA, RETURN 'ADM-ERROR'.
        END.
        ASSIGN 
            b-faccpedi.fchent = OD_REPROGRAMADAS.tfchent.
        /* 09/02/2023: Actualizamos control de bultos CHR_01 = "C" a CHR_01 = "P"*/
        FOR EACH CcbCBult EXCLUSIVE-LOCK WHERE CcbCBult.CodCia = s-codcia AND 
            CcbCBult.CodDoc = b-faccpedi.coddoc AND
            CcbCBult.NroDoc = b-faccpedi.nroped AND
            CcbCBult.Chr_01 = "C":
            ASSIGN CcbCBult.Chr_01 = "P".
        END.
        IF AVAILABLE(CcbCBult) THEN RELEASE CcbCBult.

        /*MESSAGE b-faccpedi.coddoc b-faccpedi.nroped b-faccpedi.fchent.*/
        /* PED */
        FIND FIRST PEDIDO WHERE PEDIDO.codcia = s-codcia AND
            PEDIDO.coddoc = b-faccpedi.codref AND
            PEDIDO.nroped = b-faccpedi.nroref EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            pMensaje = "ERROR PED:" + CHR(10) + pMensaje.
            UNDO ACT_FECHA, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            PEDIDO.FchEnt = OD_REPROGRAMADAS.tfchent.
        /*MESSAGE pedido.coddoc pedido.nroped pedido.fchent.*/
        ASSIGN
            OD_REPROGRAMADAS.tcodped = PEDIDO.coddoc
            OD_REPROGRAMADAS.tnroped = PEDIDO.nroped.
        /* COT */
        ASSIGN 
            OD_REPROGRAMADAS.tcodcot = PEDIDO.codref
            OD_REPROGRAMADAS.tnrocot = PEDIDO.nroref.

/*         FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND                      */
/*             b-faccpedi.coddoc = OD_REPROGRAMADAS.tcodped AND                              */
/*             b-faccpedi.nroped = OD_REPROGRAMADAS.tnroped EXCLUSIVE-LOCK NO-ERROR NO-WAIT. */
/*         IF ERROR-STATUS:ERROR = YES THEN DO:                                              */
/*             {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}      */
/*             pMensaje = "ERROR PED:" + CHR(10) + pMensaje.                                 */
/*             UNDO ACT_FECHA, RETURN 'ADM-ERROR'.                                           */
/*         END.                                                                              */
/*         ASSIGN                                                                            */
/*             b-faccpedi.fchent = OD_REPROGRAMADAS.tfchent.                                 */
/*         /* COTIZACION */                                                                  */
/*         ASSIGN                                                                            */
/*             OD_REPROGRAMADAS.tcodcot = b-faccpedi.codref                                  */
/*             OD_REPROGRAMADAS.tnrocot = b-faccpedi.nroref.                                 */
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
    WHEN 'NroDoc':U THEN DO:
      &Scope SORTBY-PHRASE BY AlmCDocu.NroDoc
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NomCli
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar B-table-Win 
PROCEDURE Eliminar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR x-Total-1 AS DEC NO-UNDO.
DEF VAR x-Total-2 AS DEC NO-UNDO.

IF NOT AVAILABLE Almcdocu THEN RETURN 'ADM-ERROR'.

DEF BUFFER FACTURA FOR Ccbcdocu.
DEF BUFFER PEDIDO FOR Faccpedi.
DEF BUFFER ORDENES FOR Faccpedi.

SESSION:SET-WAIT-STATE("GENERAL").

/* Barremos una por una */
DEF VAR LocalItem AS INT NO-UNDO.
DO LocalItem = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(LocalItem) THEN DO:
        /* Llaves de Control */
        ASSIGN
            x-Rowid = ROWID(AlmCDocu).
        /* BLOQUEAMOS EL REGISTRO DE CONTROL */
        {lib/lock-genericov3.i ~
            &Tabla="AlmCDocu" ~
            &Condicion="ROWID(AlmCDocu) = x-Rowid" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        ASSIGN
            AlmCDocu.FchAnulacion = TODAY
            AlmCDocu.FlgEst = "A"
            AlmCDocu.UsrAnulacion = s-user-id.
        /* ************************************************************************************** */
        /* 19/10/2023: Verificamos si tiene P.I. */
        /* ************************************************************************************** */
        /* Cargamos la información del parte ingreso al almacén */
        FIND ORDENES WHERE ORDENES.codcia = s-codcia AND
            ORDENES.coddoc = Almcdocu.coddoc AND
            ORDENES.nroped = Almcdocu.nrodoc 
            NO-LOCK NO-ERROR.
        IF AVAILABLE ORDENES THEN DO:
            FIND FIRST FACTURA WHERE FACTURA.codcia = s-codcia AND
                LOOKUP(FACTURA.coddoc, 'FAC,BOL') > 0 AND
                FACTURA.codped = ORDENES.codref AND
                FACTURA.nroped = ORDENES.nroref AND
                FACTURA.libre_c01 = ORDENES.coddoc AND
                FACTURA.libre_c02 = ORDENES.nroped AND
                FACTURA.flgest <> "A"
                NO-LOCK NO-ERROR.
            IF AVAILABLE FACTURA THEN DO:
                ASSIGN x-Total-1 = 0 x-Total-2 = 0.
                FOR EACH Ccbddocu OF FACTURA NO-LOCK:
                    x-Total-1 = x-Total-1 + (Ccbddocu.candes * Ccbddocu.factor).
                END.
                FOR FIRST Almcmov NO-LOCK WHERE Almcmov.codcia = FACTURA.codcia AND
                    Almcmov.tipmov = "I" AND 
                    Almcmov.codmov = 09 AND
                    Almcmov.codref = FACTURA.coddoc AND
                    Almcmov.nroref = FACTURA.nrodoc AND
                    Almcmov.flgest <> 'A',
                    EACH Almdmov OF Almcmov NO-LOCK:
                    x-Total-2 = x-Total-2 + (Almdmov.candes * Almdmov.factor).
                END.
                IF x-Total-1 <> x-Total-2 THEN DO:
                    pMensaje = 'NO se ha devuelto TOTALMENTE la ' + FACTURA.coddoc + ' ' + FACTURA.nrodoc.
                    UNDO, RETURN 'ADM-ERROR'.
                END.
            END.
            ELSE DO:    /* NO se ubicó la FACTURA */
                pMensaje = 'NO se ha devuelto TOTALMENTE la ' + Almcdocu.coddoc + ' ' + Almcdocu.nrodoc.
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
        /* ************************************************************************************** */
        /* ************************************************************************************** */
        /* RHC 08/03/2019 ACTUALIZA PHR */
        /* Levantamos la libreria a memoria */
        /* ************************************************************************************** */
        DEFINE VAR hProc AS HANDLE NO-UNDO.
        RUN dist/dist-librerias PERSISTENT SET hProc.
        RUN PHR-FlgEst IN hProc (INPUT ROWID(Almcdocu), INPUT "C").     /* CERRADO */
        DELETE PROCEDURE hProc.
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
        /* ************************************************************************************** */

        /* Ic - 27Ago2020, Las O/D de la PHR */
        RUN GUIAS_REMISION.
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.

        /* ************************************************************ */
        /*  Ic - 27Ago202, grabar el tracking comercial                 */
        /* ************************************************************ */
        RUN TRACKING_COMERCIAL(INPUT "NRPRG").
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.

        /* 
            Ic - 27Ago202, A requerimiento de Max Ramos, el registro solo debe quedarse
                        marcado como ANULADO y NO eliminarlo fisicamente
        */
        /* DELETE Almcdocu.*/    /* RHC 21/05/2018: va a ser necesario eliminarla completamente */
    END.
END.
RELEASE Almcdocu.

SESSION:SET-WAIT-STATE("").

/*MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.*/
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION B-table-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-Rowid AS ROWID.

/* Rescato el comprobante */
FIND FIRST x-almcdocu WHERE ROWID(x-almcdocu) = x-RowId NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-almcdocu THEN DO:
    pMensaje = "No existe O/D reprogramada".
    RETURN "ADM-ERROR".
END.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND x-faccpedi.coddoc = x-almcdocu.coddoc AND /* O/D */
                            x-faccpedi.nroped = x-almcdocu.nrodoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMensaje = "No existe O/D :" + x-almcdocu.coddoc + " " + x-almcdocu.nrodoc.
    RETURN "ADM-ERROR".
END.

DEFINE VAR cCodDoc AS CHAR INIT "".
DEFINE VAR cNroDoc AS CHAR INIT "".
DEFINE VAR cDivVta AS CHAR INIT "".

/* Busco el comprobante tomando como referencia el PEDIDO LOGISTICO */
FOR EACH x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND 
    x-ccbcdocu.codped = x-faccpedi.codref AND   /* PED */
    x-ccbcdocu.nroped = x-faccpedi.nroref AND 
    x-ccbcdocu.libre_c01 = x-almcdocu.coddoc AND /* O/D */
    x-ccbcdocu.libre_c02 = x-almcdocu.nrodoc AND 
    x-ccbcdocu.codcli = x-faccpedi.codcli AND
    x-ccbcdocu.flgest <> 'A' NO-LOCK :
    IF x-ccbcdocu.coddoc = 'FAC' OR x-ccbcdocu.coddoc = 'BOL' OR x-ccbcdocu.coddoc = 'FAI' THEN DO:
        cCodDoc = x-ccbcdocu.coddoc.
        cNroDoc = x-ccbcdocu.nrodoc.
        cDivVta = x-ccbcdocu.divori.
        LEAVE.
    END.
END.

IF cCodDoc = "" THEN DO:
    pMensaje = "La O/D :" + x-almcdocu.coddoc + " " + x-almcdocu.nrodoc + " no tiene comprobante emitido".
    RETURN "ADM-ERROR".
END.    

FIND FIRST gre_cmpte WHERE gre_cmpte.coddoc = cCodDoc AND gre_cmpte.nrodoc = cNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE gre_cmpte THEN DO:
    /*
    pMensaje = "El comprobante " + cCodDoc + " " + cNroDoc + " no existe GRE".
    RETURN "ADM-ERROR".
    */
END.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    pMensaje = "".
    /*     /* LIMPIAMOS EL REGISTRO DE CONTROL DE G/R */                         */
    /*     EMPTY TEMP-TABLE Reporte.       /* Aquí guardamos las N/C generada */ */
    /* BLOQUEAMOS EL REGISTRO DE CONTROL */
    {lib/lock-genericov3.i ~
        &Tabla="AlmCDocu" ~
        &Condicion="ROWID(AlmCDocu) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        
    /* 06/10/2023: NO se genera CONTROL DE COMPROBANTES GRE */
    IF lGeneraControlParaGenerarPGRE = YES THEN DO:
        /* 13Oct2023: Ic - para dejado en tienda debe generar CONTROL DE COMPROBANTES GRE */
        /* Si no es dejado en tienda debe ir a la opcion de DAR DE BAJA EN SUNAT y esa opcion genera en automatico el CONTROL */
        CREATE b-gre_cmpte.
            ASSIGN b-gre_cmpte.coddoc = cCodDoc
                    b-gre_cmpte.nrodoc = cNroDoc
                    b-gre_cmpte.coddivvta = cDivVta
                    b-gre_cmpte.coddivdesp = s-coddiv
                    b-gre_cmpte.estado_sunat = IF (NOT AVAILABLE gre_cmpte) THEN "ACEPTADO POR SUNAT" ELSE gre_cmpte.estado_sunat
                    b-gre_cmpte.estado = "CMPTE GENERADO"
                    b-gre_cmpte.fechaemision = IF (NOT AVAILABLE gre_cmpte) THEN x-ccbcdocu.fchdoc ELSE gre_cmpte.fechaemision NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = ERROR-STATUS:GET-MESSAGE(1).
            UNDO RLOOP.
            RETURN 'ADM-ERROR'.
        END.
    END.
    
    ASSIGN
        AlmCDocu.FchAprobacion = TODAY
        AlmCDocu.UsrAprobacion = s-user-id 
        AlmCDocu.FlgEst = "C".
    /* ************************************************************************************** */
    /* RHC 08/03/2019 ACTUALIZA PHR */
    /* Levantamos la libreria a memoria */
    /* ************************************************************************************** */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    RUN dist/dist-librerias PERSISTENT SET hProc.
    RUN PHR-FlgEst IN hProc (INPUT ROWID(Almcdocu),
                             INPUT "R").     /* REPROGRAMADO */
    DELETE PROCEDURE hProc.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.

    /* ************************************************************ */
    /*  Ic - 27Ago2020, cambiar la fecha de entrega de las O/D y PED */
    /* ************************************************************ */
    RUN ACTUALIZA_FECHA_ENTREGA.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO RLOOP, RETURN 'ADM-ERROR'.

    /* ************************************************************ */
    /*  Ic - 27Ago2020, grabar el tracking comercial                 */
    /* ************************************************************ */
    RUN TRACKING_COMERCIAL(INPUT "RPROG").
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.


    /* ************************************************************************************** */
    /* Registro de Control */
    CREATE LogTabla.
    ASSIGN
        logtabla.codcia = s-codcia
        logtabla.Dia = TODAY
        logtabla.Evento = "REPROGRAMACION"
        logtabla.Hora = STRING(TIME, 'HH:MM:SS')
        logtabla.Tabla = 'ALMCDOCU'
        logtabla.Usuario = s-user-id
        /*00000|O/D|001000001|H/R|011000001*/
        logtabla.ValorLlave = AlmCDocu.CodLlave + '|' + AlmCDocu.CodDoc + '|' + AlmCDocu.NroDoc + '|' +
        AlmCDocu.Libre_c01 + '|' + AlmCDocu.Libre_c02.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION-OLD B-table-Win 
PROCEDURE FIRST-TRANSACTION-OLD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo genera una N/C a la vez
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-Rowid AS ROWID.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    pMensaje = "".
    /*     /* LIMPIAMOS EL REGISTRO DE CONTROL DE G/R */                         */
    /*     EMPTY TEMP-TABLE Reporte.       /* Aquí guardamos las N/C generada */ */
    /* BLOQUEAMOS EL REGISTRO DE CONTROL */
    {lib/lock-genericov3.i ~
        &Tabla="AlmCDocu" ~
        &Condicion="ROWID(AlmCDocu) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    /* ************************************************************* */        
    /* GENERAMOS G/R: copia de las originales */
    /* ************************************************************* */        
    FOR EACH T-CDOCU NO-LOCK, FIRST B-CDOCU OF T-CDOCU NO-LOCK:
        /* GENERAMOS LA G/R */    
        RUN Genera-GR (INPUT iSerieNC).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la G/R nueva para la " +
                B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
    END.
    ASSIGN
        AlmCDocu.FchAprobacion = TODAY
        AlmCDocu.UsrAprobacion = s-user-id 
        AlmCDocu.FlgEst = "C".
    /* ************************************************************************************** */
    /* RHC 08/03/2019 ACTUALIZA PHR */
    /* Levantamos la libreria a memoria */
    /* ************************************************************************************** */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    RUN dist/dist-librerias PERSISTENT SET hProc.
    RUN PHR-FlgEst IN hProc (INPUT ROWID(Almcdocu),
                             INPUT "R").     /* REPROGRAMADO */
    DELETE PROCEDURE hProc.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.

    /* ************************************************************ */
    /*  Ic - 27Ago2020, cambiar la fecha de entrega de las O/D y PED */
    /* ************************************************************ */
    RUN ACTUALIZA_FECHA_ENTREGA.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO RLOOP, RETURN 'ADM-ERROR'.

    /* ************************************************************ */
    /*  Ic - 27Ago2020, grabar el tracking comercial                 */
    /* ************************************************************ */
    RUN TRACKING_COMERCIAL(INPUT "RPROG").
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.


    /* ************************************************************************************** */
    /* Registro de Control */
    CREATE LogTabla.
    ASSIGN
        logtabla.codcia = s-codcia
        logtabla.Dia = TODAY
        logtabla.Evento = "REPROGRAMACION"
        logtabla.Hora = STRING(TIME, 'HH:MM:SS')
        logtabla.Tabla = 'ALMCDOCU'
        logtabla.Usuario = s-user-id
        /*00000|O/D|001000001|H/R|011000001*/
        logtabla.ValorLlave = AlmCDocu.CodLlave + '|' + AlmCDocu.CodDoc + '|' + AlmCDocu.NroDoc + '|' +
        AlmCDocu.Libre_c01 + '|' + AlmCDocu.Libre_c02.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION-OTR B-table-Win 
PROCEDURE FIRST-TRANSACTION-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-Rowid AS ROWID.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    pMensaje = "".
    /* BLOQUEAMOS EL REGISTRO DE CONTROL */
    {lib/lock-genericov3.i ~
        &Tabla="AlmCDocu" ~
        &Condicion="ROWID(AlmCDocu) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    /* ************************************************************* */        
    /* Marcamos las SALIDAS POR TRANSFERENCIAS como REPROGRAMADAS */
    /* ************************************************************* */        
    FOR EACH Almcmov EXCLUSIVE-LOCK WHERE Almcmov.codcia = s-codcia
        AND Almcmov.codref = Faccpedi.coddoc
        AND Almcmov.nroref = Faccpedi.nroped
        AND Almcmov.tipmov = 'S'
        AND Almcmov.codmov = 03
        AND Almcmov.flgsit = "T"
        ON ERROR UNDO, THROW:
        Almcmov.FlgSit = "R".   /* RECEPCIONADO */
        Almcmov.FlgEst = "R".   /* REPROGRAMADO (Afectará otros procesos?) */
    END.

    /* ************************************************************* */        
    /* ************************************************************* */        
    /* Ingreso por Devolución de OTR */
    /* ************************************************************* */   
    RUN logis/ing-devo-otr ( ROWID(Faccpedi), OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la nueva O/D y PED'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* ************************************************************* */        
    /* DESBLOQUEA OTR */
    /* ************************************************************* */        
    RUN Genera-PED-OD.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la nueva O/D y PED'.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        AlmCDocu.FchAprobacion = TODAY
        AlmCDocu.UsrAprobacion = s-user-id 
        AlmCDocu.FlgEst = "C".
    /* ************************************************************************************** */
    /* RHC 08/03/2019 ACTUALIZA PHR */
    /* Levantamos la libreria a memoria */
    /* ************************************************************************************** */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    RUN dist/dist-librerias PERSISTENT SET hProc.
    RUN PHR-FlgEst IN hProc (INPUT ROWID(Almcdocu),
                             INPUT "R").     /* REPROGRAMADO */
    DELETE PROCEDURE hProc.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    /* ************************************************************************************** */
    /* Registro de Control */
    CREATE LogTabla.
    ASSIGN
        logtabla.codcia = s-codcia
        logtabla.Dia = TODAY
        logtabla.Evento = "REPROGRAMACION"
        logtabla.Hora = STRING(TIME, 'HH:MM:SS')
        logtabla.Tabla = 'ALMCDOCU'
        logtabla.Usuario = s-user-id
        /*00000|O/D|001000001|H/R|011000001*/
        logtabla.ValorLlave = AlmCDocu.CodLlave + '|' + AlmCDocu.CodDoc + '|' + AlmCDocu.NroDoc + '|' +
        AlmCDocu.Libre_c01 + '|' + AlmCDocu.Libre_c02.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle B-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 05/12/2022 Puede que no coincidan los items por GR al momento de REPROGRAMAR */
FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.

/* 01/12/2022 Formato de impresión configurable a 13 o 36 líneas MAX RAMOS */
DEF VAR LocalItems_Guias AS INTE INIT 13 NO-UNDO.

IF AVAILABLE FacCfgGn AND FacCfgGn.Items_Guias > 0 THEN LocalItems_Guias = FacCfgGn.Items_Guias.

FIND FIRST FacTabla WHERE FacTabla.CodCia = s-codcia AND
    FacTabla.Tabla = "CFG_FMT_GR" AND
    FacTabla.Codigo = CcbcDocu.CodDiv
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN ASSIGN LocalItems_Guias = INTEGER(FacTabla.Campo-C[1]) NO-ERROR.

DEF VAR x-Item AS INT INIT 0 NO-UNDO.

FOR EACH T-DDOCU EXCLUSIVE-LOCK:
    IF x-Item >= LocalItems_Guias THEN LEAVE.
    CREATE Ccbddocu.
    BUFFER-COPY T-DDOCU TO Ccbddocu
        ASSIGN 
              CcbDDocu.CodCia = CcbCDocu.CodCia 
              CcbDDocu.Coddoc = CcbCDocu.Coddoc
              CcbDDocu.NroDoc = CcbCDocu.NroDoc 
              CcbDDocu.FchDoc = CcbCDocu.FchDoc
              CcbDDocu.CodDiv = CcbcDocu.CodDiv.
    x-Item = x-Item + 1.
    DELETE T-DDOCU.
END.

/* FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:             */
/*                                                  */
/*     CREATE Ccbddocu.                             */
/*     BUFFER-COPY B-DDOCU TO Ccbddocu              */
/*         ASSIGN                                   */
/*               CcbDDocu.CodCia = CcbCDocu.CodCia  */
/*               CcbDDocu.Coddoc = CcbCDocu.Coddoc  */
/*               CcbDDocu.NroDoc = CcbCDocu.NroDoc  */
/*               CcbDDocu.FchDoc = CcbCDocu.FchDoc  */
/*               CcbDDocu.CodDiv = CcbcDocu.CodDiv. */
/* END.                                             */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-GR B-table-Win 
PROCEDURE Genera-GR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* La serie es seleccionada por el usuario */
DEF INPUT PARAMETER s-NroSer AS INT.

/* Consistencia */
DEF VAR s-Sunat-Activo AS LOG INIT NO.
DEF VAR s-CodDoc AS CHAR INIT 'G/R' NO-UNDO.

FIND gn-divi WHERE GN-DIVI.CodCia = s-codcia AND GN-DIVI.CodDiv = s-coddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'NO está configurada la división ' + s-coddiv.
    RETURN 'ADM-ERROR'.
END.
s-Sunat-Activo = gn-divi.campo-log[10].

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDiv = S-CODDIV
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.NroSer = s-NroSer
    AND FacCorre.FlgEst = YES   /* Debe estar activa */
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Serie " + s-CodDoc + ": " + STRING(s-NroSer, '999') + " no configurado para la división " + s-CodDiv.
   RETURN 'ADM-ERROR'.
END.
RUN sunat/p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCfgGn THEN DO:
    pMensaje = "NO configurada la configuración general" .
    RETURN 'ADM-ERROR'.
END.
/* ************************************************************************************************************** */
/* 05/12/2022 Items para la GR nueva(s) */
/* ************************************************************************************************************** */
EMPTY TEMP-TABLE T-DDOCU.
FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
    CREATE T-DDOCU.
    BUFFER-COPY B-DDOCU TO T-DDOCU.
END.
/* ************************************************************************************************************** */
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 05/12/2022 Puede que no coincidan los items por GR al momento de REPROGRAMAR */
    FIND FIRST T-DDOCU NO-ERROR.
    REPEAT WHILE AVAILABLE T-DDOCU:
        {lib/lock-genericov3.i ~
            &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = S-CODCIA ~
                        AND FacCorre.CodDiv = S-CODDIV ~
                        AND FacCorre.CodDoc = S-CODDOC ~
                        AND FacCorre.NroSer = s-NroSer" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" }

        CREATE Ccbcdocu.
        BUFFER-COPY B-CDOCU     /* G/R */
            TO CcbCDocu
            ASSIGN 
            CcbCDocu.CodCia = S-CODCIA
            CcbCDocu.CodDiv = S-CODDIV
            CcbCDocu.CodDoc = S-CODDOC          /* G/R */
            CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                                STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
            CcbCDocu.FchDoc = TODAY
            CcbCDocu.FchVto = TODAY
            CcbCDocu.TpoFac = "M"   /* MANUAL */
            CcbCDocu.usuario = S-USER-ID
            CcbCDocu.Tipo   = "OFICINA"
            CcbCDocu.TipVta = "2"
            CcbCDocu.FlgEst = "F"
            CcbCDocu.FlgSit = "P"
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "NO se pudo generar la G/R nueva para la " + B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        /* ************* */
        /* Transportista */
        /* ************* */
        FIND FIRST B-ADOCU OF B-CDOCU NO-LOCK NO-ERROR.
        IF AVAILABLE B-ADOCU THEN DO:
            CREATE CcbADocu.
            BUFFER-COPY B-ADOCU TO CcbADocu
                ASSIGN
                CcbADocu.CodCia = CcbCDocu.CodCia
                CcbADocu.CodDiv = CcbCDocu.CodDiv
                CcbADocu.CodDoc = CcbCDocu.CodDoc
                CcbADocu.NroDoc = CcbCDocu.NroDoc
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "NO se pudo migrar el TRANSPORTISTA a la G/R nueva para la " + B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
        END.
        /* ************************ */
        /* Control de G/R generadas */
        /* ************************ */
        CREATE Reporte.
        BUFFER-COPY Ccbcdocu TO Reporte.
        /* ************************ */
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.

        /* ---------------------------------------------------------------- */
        /* Ic - 27Ago2020, guardo las O/D para el cambio de fecha           */
        /* ---------------------------------------------------------------- */
        FIND FIRST OD_reprogramadas WHERE   OD_reprogramadas.tcoddiv = B-CDOCU.divori AND
                                            OD_reprogramadas.tcoddoc = B-CDOCU.libre_c01 AND
                                            OD_reprogramadas.tnrodoc = B-CDOCU.libre_c02 EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE OD_reprogramadas THEN DO:
            CREATE OD_reprogramadas.
                ASSIGN OD_reprogramadas.tcoddiv = B-CDOCU.divori
                        OD_reprogramadas.tcoddoc = B-CDOCU.libre_c01
                        OD_reprogramadas.tnrodoc = B-CDOCU.libre_c02
                        OD_reprogramadas.tcodped = B-CDOCU.codped
                        OD_reprogramadas.tfchent = fFchEnt
                        OD_reprogramadas.tnroped = B-CDOCU.nroped NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "NO se pudo grabar en temporal de O/D reprogramadas " +
                B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
        END.
        /* */
        RUN Genera-Detalle.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN
                pMensaje = "NO se pudo generar el detalle de la G/R nueva para la " +
                B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.

        RUN Graba-Totales.

    END.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC B-table-Win 
PROCEDURE Genera-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       TODO NACE ANULADO 
------------------------------------------------------------------------------*/

/* La serie es seleccionada por el usuario */
DEF INPUT PARAMETER s-NroSer AS INT.

/* Consistencia */
DEF VAR s-Sunat-Activo AS LOG INIT NO.
DEF VAR s-CodDoc AS CHAR INIT 'N/C' NO-UNDO.
DEF VAR s-codalm AS CHAR NO-UNDO.

FIND gn-divi WHERE GN-DIVI.CodCia = s-codcia AND GN-DIVI.CodDiv = s-coddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'NO está configurada la división ' + s-coddiv.
    RETURN 'ADM-ERROR'.
END.
s-Sunat-Activo = gn-divi.campo-log[10].

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDiv = S-CODDIV
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.NroSer = s-NroSer
    AND FacCorre.FlgEst = YES   /* Debe estar activa */
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Serie " + s-CodDoc + ": " + STRING(s-NroSer, '999') + " no configurado para la división " + s-CodDiv.
   RETURN 'ADM-ERROR'.
END.
RUN sunat/p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).
ASSIGN
    s-CodAlm = B-CDOCU.CodAlm.
/* ******************************************** */
/* RHC 08/05/2019 En caso de "DEJADO EN TIENDA" */
/* ******************************************** */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia AND
    Almacen.codalm = s-codalm NO-LOCK.
IF Almacen.coddiv <> s-CodDiv THEN DO:
    /* Tomamos la del almacén pricipal */
    FIND FIRST Almacen WHERE Almacen.codcia = s-codcia AND
        Almacen.coddiv = s-CodDiv AND
        Almacen.AlmPrincipal = YES AND
        Almacen.Campo-c[9] <> "I" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
        pMensaje = 'La división ' + s-CodDiv + ' NO tiene un almacén principal definido'.
        RETURN 'ADM-ERROR'.
    END.
    s-CodAlm = Almacen.CodAlm.
END.
/* ******************************************** */
FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCfgGn THEN DO:
    pMensaje = "NO configurada la configuración general" .
    RETURN 'ADM-ERROR'.
END.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = S-CODCIA ~
                    AND FacCorre.CodDiv = S-CODDIV ~
                    AND FacCorre.CodDoc = S-CODDOC ~
                    AND FacCorre.NroSer = s-NroSer" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    
    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU     /* La FAC o BOL */
        EXCEPT B-CDOCU.Glosa B-CDOCU.NroOrd
        TO CcbCDocu
        ASSIGN 
        CcbCDocu.CodCia = S-CODCIA
        CcbCDocu.CodDiv = S-CODDIV
        CcbCDocu.CodDoc = S-CODDOC          /* N/C */
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
        CcbCDocu.CodRef = B-CDOCU.CodDoc    /* FAC o BOL */
        CcbCDocu.NroRef = B-CDOCU.NroDoc
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
        CcbCDocu.FlgEst = "P"
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.TpoFac = "LI"  /* Logística Inversa */
        CcbCDocu.CndCre = 'D'
        CcbCDocu.Tipo   = "CREDITO"
        CcbCDocu.CodCaja= ''    /*s-CodTer*/
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.SdoAct = B-CDOCU.ImpTot
        CcbCDocu.ImpTot2 = 0
        CcbCDocu.ImpDto2 = 0
        CcbCDocu.CodMov = 09     /* INGRESO POR DEVOLUCION DEL CLIENTE */
        CcbCDocu.CodAlm = s-CodAlm
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "NO se pudo generar la N/C para la " + B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* RHC 22/08/18 Parche */
    IF CcbCDocu.CodRef = "BOL" AND TRUE <> (CcbCDocu.CodAnt > '') THEN CcbCDocu.CodAnt = '12345678'.
    /* ************************ */
    /* Control de N/C generadas */
    /* ************************ */
    CREATE Reporte.
    BUFFER-COPY Ccbcdocu TO Reporte.
    /* ************************ */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
    FIND GN-VEN WHERE gn-ven.codcia = s-codcia AND gn-ven.codven = B-CDOCU.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN Ccbcdocu.cco = gn-ven.cco.

    RUN Genera-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN
            pMensaje = "NO se pudo generar el detalle de la N/C para la " +
            B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    
    /* Generamos el movimiento de almacén por devolución de mercadería */
    RUN vta2/ing-devo-utilex (ROWID(Ccbcdocu)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "NO se pudo generar el ingreso por devolución de la " + B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    
    RUN Graba-Totales.
    
    /* ******************************************************* */
    /* MARCAMOS TODOS LOS DOCUMENTOS COMO ANULADOS POR DEFECTO */
    /* ******************************************************* */
    ASSIGN
        Ccbcdocu.FlgEst = "A".
    FIND FIRST Almcmov WHERE Almcmov.codcia = s-codcia
        AND Almcmov.codref = Ccbcdocu.coddoc
        AND Almcmov.nroref = Ccbcdocu.nrodoc
        AND Almcmov.flgest = "C"
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        Almcmov.FlgEst = "A".
    /* ******************************************************* */
    /* ******************************************************* */
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-PED-OD B-table-Win 
PROCEDURE Genera-PED-OD :
/*----------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 25/06/18 Se va a cambiar el estado de la O/D original */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i &Tabla="OD_ORIGINAL" ~
        &Alcance="FIRST" ~
        &Condicion="OD_ORIGINAL.codcia = Almcdocu.codcia ~
        AND OD_ORIGINAL.coddoc = Almcdocu.coddoc ~
        AND OD_ORIGINAL.nroped = Almcdocu.nrodoc"
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    ASSIGN
        OD_ORIGINAL.FlgEst = "P"    /* Reactivamos la O/D */
        OD_ORIGINAL.FlgSit = "C".
    FOR EACH Facdpedi OF OD_ORIGINAL EXCLUSIVE-LOCK:
        ASSIGN
            Facdpedi.canate = 0
            Facdpedi.flgest = "P".
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores B-table-Win 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales B-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/graba-totales-factura-cred.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GUIAS_REMISION B-table-Win 
PROCEDURE GUIAS_REMISION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE T-CDOCU.
EMPTY TEMP-TABLE OD_reprogramadas.

/* ********************************************************************************************* */
/* CARGAMOS LA G/R RELACIONADAS: NO ENTREGAS O DEJADAS EN TIENDA DE LA O/D SELECCIONADA */
/* ********************************************************************************************* */
FOR EACH Di-RutaD NO-LOCK WHERE DI-RutaD.CodCia = s-CodCia
        AND DI-RutaD.CodDoc = AlmCDocu.Libre_c01    /* H/R */
        AND DI-RutaD.NroDoc = AlmCDocu.Libre_c02
        AND DI-RutaD.CodRef = "G/R"
        AND ( (DI-RutaD.FlgEst = "N" AND DI-RutaD.Libre_c02 = "R") OR DI-RutaD.FlgEst = "T" ),
    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-CodCia
        AND B-CDOCU.coddoc = DI-RutaD.CodRef        /* G/R */
        AND B-CDOCU.nrodoc = DI-RutaD.NroRef:
/*         AND B-CDOCU.libre_c01 = AlmCDocu.CodDoc     /* O/D */ */
/*         AND B-CDOCU.libre_c02 = AlmCDocu.NroDoc:              */

    /* Ic - 20Feb2020 me aseguro que sea No entregado/Reprogramado y Dejado en Tienda */
    IF B-CDOCU.flgest = 'NE' OR B-CDOCU.flgest = 'DT' THEN DO:
        CREATE T-CDOCU.
        BUFFER-COPY B-CDOCU TO T-CDOCU.
        CASE TRUE:
            WHEN (DI-RutaD.FlgEst = "N" AND DI-RutaD.Libre_c02 = "R") THEN T-CDOCU.EstadoHR = "NE".
            WHEN DI-RutaD.FlgEst = "T" THEN T-CDOCU.EstadoHR = "DT".
        END CASE.
    END.
    
END.  
/*
IF NOT CAN-FIND(FIRST T-CDOCU NO-LOCK) THEN DO:
    /*
    MESSAGE 'NO hay comprobantes válidos' AlmCDocu.Libre_c01 AlmCDocu.Libre_c02
        VIEW-AS ALERT-BOX ERROR.
    */
    RETURN 'ADM-ERROR'. 
END.
*/

/* ---------------------------------------------------------------- */
/* Ic - 27Ago2020, guardo las O/D para el LOG comercial             */
/* ---------------------------------------------------------------- */
/* 24/8/23 */
FOR EACH T-CDOCU :
    FIND FIRST OD_reprogramadas WHERE   OD_reprogramadas.tcoddiv = T-CDOCU.divori AND
                                        OD_reprogramadas.tcoddoc = T-CDOCU.libre_c01 AND
                                        OD_reprogramadas.tnrodoc = T-CDOCU.libre_c02 EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE OD_reprogramadas THEN DO:
        CREATE OD_reprogramadas.
            ASSIGN OD_reprogramadas.tcoddiv  = T-CDOCU.divori
                    OD_reprogramadas.tcoddoc = T-CDOCU.libre_c01
                    OD_reprogramadas.tnrodoc = T-CDOCU.libre_c02
                    OD_reprogramadas.tcodped = T-CDOCU.codped
                    OD_reprogramadas.tfchent = fFchEnt
                    OD_reprogramadas.tnroped = T-CDOCU.nroped NO-ERROR.
    END.
END.
/* FOR EACH T-CDOCU :                                                                                            */
/*     FIND FIRST OD_reprogramadas WHERE   OD_reprogramadas.tcoddiv = B-CDOCU.divori AND                         */
/*                                         OD_reprogramadas.tcoddoc = B-CDOCU.libre_c01 AND                      */
/*                                         OD_reprogramadas.tnrodoc = B-CDOCU.libre_c02 EXCLUSIVE-LOCK NO-ERROR. */
/*                                                                                                               */
/*     IF NOT AVAILABLE OD_reprogramadas THEN DO:                                                                */
/*         CREATE OD_reprogramadas.                                                                              */
/*             ASSIGN OD_reprogramadas.tcoddiv = B-CDOCU.divori                                                  */
/*                     OD_reprogramadas.tcoddoc = B-CDOCU.libre_c01                                              */
/*                     OD_reprogramadas.tnrodoc = B-CDOCU.libre_c02                                              */
/*                     OD_reprogramadas.tcodped = B-CDOCU.codped                                                 */
/*                     OD_reprogramadas.tfchent = fFchEnt                                                        */
/*                     OD_reprogramadas.tnroped = B-CDOCU.nroped NO-ERROR.                                       */
/*     END.                                                                                                      */
/* END.                                                                                                          */


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION B-table-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR x-NroPed AS CHAR NO-UNDO.
DEF VAR x-CodO_D AS CHAR NO-UNDO.
DEF VAR x-NroO_D AS CHAR NO-UNDO.
DEF VAR iSerieGuia AS INT.
DEF VAR iNroGuia AS INT.

/* ************************************************************************ */
/* ************************************************************************ */
/* Llaves de Control */
/* ************************************************************************ */
ASSIGN
    x-CodPed = Faccpedi.CodRef      /* PED */
    x-NroPed = Faccpedi.NroRef
    x-CodO_D = Faccpedi.CodDoc      /* O/D */
    x-NroO_D = Faccpedi.NroPed
    x-Rowid = ROWID(AlmCDocu).

EMPTY TEMP-TABLE T-CDOCU.
EMPTY TEMP-TABLE T-FELogErrores.
EMPTY TEMP-TABLE OD_reprogramadas.

lGeneraControlParaGenerarPGRE = NO.

/* ********************************************************************************************* */
/* CARGAMOS LA G/R RELACIONADAS: NO ENTREGAS O DEJADAS EN TIENDA DE LA O/D SELECCIONADA */
/* ********************************************************************************************* */
FOR EACH Di-RutaD NO-LOCK WHERE DI-RutaD.CodCia = s-CodCia
        AND DI-RutaD.CodDoc = AlmCDocu.Libre_c01    /* H/R */
        AND DI-RutaD.NroDoc = AlmCDocu.Libre_c02
        AND DI-RutaD.CodRef = "G/R"
        AND ( (DI-RutaD.FlgEst = "N" AND DI-RutaD.Libre_c02 = "R") OR DI-RutaD.FlgEst = "T" ),
    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-CodCia
        AND B-CDOCU.coddoc = DI-RutaD.CodRef        /* G/R */
        AND B-CDOCU.nrodoc = DI-RutaD.NroRef
        AND B-CDOCU.libre_c01 = AlmCDocu.CodDoc     /* O/D */ 
        AND B-CDOCU.libre_c02 = AlmCDocu.NroDoc:

    /* Ic - 20Feb2020 me aseguro que No entregado/Reprogramado y Dejado en Tienda */
    IF B-CDOCU.flgest = 'NE' OR B-CDOCU.flgest = 'DT' THEN DO:

        /* ************************************************************************ */
        /* 
            06/10/2023: La GRE debe estar RECHAZADO POR SUNAT o BAJA SUNAT o ANULADO 
            13Oct2023 : Contemplar los casos de DEJADO EN TIENDA
        */
        /* ************************************************************************ */        

        IF B-CDOCU.flgest = 'NE' THEN DO:               

            iSerieGuia = INTEGER(SUBSTRING(DI-RutaD.NroRef,1,3)).        /* G/R */
            iNroGuia = INTEGER(SUBSTRING(DI-RutaD.NroRef,4)).

            FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
                LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0 AND
                CcbCDocu.CodPed = Faccpedi.CodRef AND   /* PED */
                CcbCDocu.NroPed = Faccpedi.NroRef AND
                CcbCDocu.Libre_c01 = Faccpedi.CodDoc AND    /* OTR */
                CcbCDocu.Libre_c02 = Faccpedi.NroPed AND
                Ccbcdocu.flgest <> 'A':
                FOR EACH gre_header NO-LOCK WHERE gre_header.m_coddoc = Ccbcdocu.coddoc AND
                    gre_header.m_nroser = INTEGER(SUBSTRING(Ccbcdocu.nrodoc,1,3)) AND
                    gre_header.m_nrodoc = INTEGER(SUBSTRING(Ccbcdocu.nrodoc,4)) AND
                    gre_header.serieGuia = iSerieGuia AND gre_header.numeroGuia = iNroGuia:                    
                    IF LOOKUP(gre_header.m_rspta_sunat, 'ANULADO,RECHAZADO POR SUNAT,BAJA EN SUNAT') = 0
                        THEN DO:
                        MESSAGE 'Se ha detectado que la GRE' SKIP
                            'Serie: ' gre_header.serieGuia 'Número:' gre_header.numeroGuia SKIP
                            'Referente a' Faccpedi.CodDoc Faccpedi.NroPed SKIP
                            'Se encuentra ' gre_header.m_rspta_sunat SKIP(1)
                            'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
                        RETURN 'ADM-ERROR'. 
                    END.
                END.
            END.
        END.
        lGeneraControlParaGenerarPGRE = YES.
        CREATE T-CDOCU.
        BUFFER-COPY B-CDOCU TO T-CDOCU.
        CASE TRUE:
            WHEN (DI-RutaD.FlgEst = "N" AND DI-RutaD.Libre_c02 = "R") THEN T-CDOCU.EstadoHR = "NE".
            WHEN DI-RutaD.FlgEst = "T" THEN T-CDOCU.EstadoHR = "DT".
        END CASE.
    END.
    
END.  
IF NOT CAN-FIND(FIRST T-CDOCU NO-LOCK) THEN DO:
    MESSAGE 'NO hay comprobantes válidos' AlmCDocu.Libre_c01 AlmCDocu.Libre_c02
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'. 
END.

/* ********************************************************************************************* */
/* PASO 1: GENERAMOS LAS GUIAS DE REMISION MANUALES SIMILARES A LAS GUIAS ANULADAS */
/* ********************************************************************************************* */
PRINCIPAL:
DO:
    RUN FIRST-TRANSACTION (x-Rowid).    /* AlmCDocu */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo reprogramar".
        LEAVE PRINCIPAL.
    END.
END.
IF pMensaje > '' THEN pMensaje = pMensaje + CHR(10) + 'Proceso Abortado'.
/* ********************************************************************************************* */
/* ********************************************************************************************* */
/* liberamos tablas */
IF AVAILABLE(Almcdocu) THEN RELEASE Almcdocu.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDocu.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.

IF pMensaje > '' THEN DO:
    /*MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.*/
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION-OTR B-table-Win 
PROCEDURE MASTER-TRANSACTION-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR x-NroPed AS CHAR NO-UNDO.
DEF VAR x-CodO_D AS CHAR NO-UNDO.
DEF VAR x-NroO_D AS CHAR NO-UNDO.

/* Llaves de Control */
ASSIGN
    x-CodPed = Faccpedi.CodRef      /* R/A */
    x-NroPed = Faccpedi.NroRef
    x-CodO_D = Faccpedi.CodDoc      /* OTR */
    x-NroO_D = Faccpedi.NroPed
    x-Rowid = ROWID(AlmCDocu).

EMPTY TEMP-TABLE T-CDOCU.   /* NO SE GENERAN N/C */
EMPTY TEMP-TABLE T-FELogErrores.

PRINCIPAL:
DO:
    RUN FIRST-TRANSACTION-OTR (x-Rowid).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo reprogramar".
        LEAVE PRINCIPAL.
    END.
END.
IF pMensaje > '' THEN pMensaje = pMensaje + CHR(10) + 'Proceso Abortado'.
/* ********************************************************************************************* */
/* ********************************************************************************************* */
/* liberamos tablas */
IF AVAILABLE(Almcdocu) THEN RELEASE Almcdocu.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDocu.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.

IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Nueva-OD B-table-Win 
PROCEDURE Nueva-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pRowid AS ROWID.

DEF BUFFER B-Vtaddocu   FOR Vtaddocu.
DEF BUFFER B-ControlOD  FOR ControlOD.
DEF BUFFER B-CcbCBult   FOR CcbCBult.
DEF BUFFER B-CcbADocu   FOR CcbADocu.

DEF VAR s-CodDoc AS CHAR NO-UNDO.
DEF VAR s-NroSer AS INT NO-UNDO.

s-CodDoc = "O/D".
s-NroSer = INTEGER(SUBSTRING(OD_ORIGINAL.NroPed,1,3)).
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. La Nueva Orden de Despacho */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="Faccorre.codcia = s-codcia ~
        AND Faccorre.coddoc = s-coddoc ~
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    CREATE ORDEN.
    BUFFER-COPY OD_ORIGINAL
        TO ORDEN
        ASSIGN
        ORDEN.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        ORDEN.FchPed = TODAY
        ORDEN.FchEnt = fFchEnt
        ORDEN.FlgEst = "P"      /* Por Facturar */
        ORDEN.FlgSit = "C"      /* Chequeada */
        ORDEN.Usuario = s-user-id
        ORDEN.FecAct = TODAY
        ORDEN.HorAct= STRING(TIME,'HH:MM:SS')
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "ERROR en el correlativo del documento: " + s-CodDoc + '-' + STRING(s-NroSer,'999').
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        pRowid = ROWID(ORDEN).
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* TRACKING */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            ORDEN.CodDoc,
                            ORDEN.NroPed,
                            s-User-Id,
                            'GNP',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            ORDEN.CodDoc,
                            ORDEN.NroPed,
                            ORDEN.CodRef,
                            ORDEN.NroRef).
    EMPTY TEMP-TABLE T-DPEDI.
    FOR EACH Facdpedi OF OD_ORIGINAL NO-LOCK:
        CREATE T-DPEDI.
        BUFFER-COPY Facdpedi TO T-DPEDI.
    END.
    FOR EACH T-DPEDI NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY T-DPEDI TO Facdpedi
            ASSIGN
            Facdpedi.coddiv = ORDEN.coddiv
            Facdpedi.coddoc = ORDEN.coddoc
            Facdpedi.nroped = ORDEN.nroped
            FacDPedi.FchPed = ORDEN.fchped
            Facdpedi.FlgEst  = 'P'
            Facdpedi.canate = 0.
    END.
    /* *************************************************************** */
    /* RHC 21/11/2016 DATOS DEL CIERRE DE LA OTR EN LA DIVISION ORIGEN */
    /* *************************************************************** */
    FOR EACH Vtaddocu NO-LOCK WHERE VtaDDocu.CodCia = OD_ORIGINAL.CodCia
        AND VtaDDocu.CodDiv = OD_ORIGINAL.CodDiv
        AND VtaDDocu.CodPed = OD_ORIGINAL.CodDoc
        AND VtaDDocu.NroPed = OD_ORIGINAL.NroPed:
        CREATE B-Vtaddocu.
        BUFFER-COPY Vtaddocu TO B-Vtaddocu
            ASSIGN 
            B-Vtaddocu.CodDiv = s-CodDiv
            B-Vtaddocu.CodPed = ORDEN.CodDoc
            B-Vtaddocu.NroPed = ORDEN.NroPed
            B-Vtaddocu.CodCli = ORDEN.CodCli
            NO-ERROR.
    END.
    FOR EACH ControlOD NO-LOCK WHERE ControlOD.CodCia = OD_ORIGINAL.CodCia
        AND ControlOD.CodDiv = OD_ORIGINAL.CodDiv
        AND ControlOD.CodDoc = OD_ORIGINAL.CodDoc
        AND ControlOD.NroDoc = OD_ORIGINAL.NroPed:
        CREATE B-ControlOD.
        BUFFER-COPY ControlOD TO B-ControlOD
            ASSIGN
            B-ControlOD.CodDiv = s-CodDiv
            B-ControlOD.CodDoc = ORDEN.CodDoc
            B-ControlOD.NroDoc = ORDEN.NroPed
            B-ControlOD.CodAlm = ORDEN.CodAlm
            B-ControlOD.CodCli = ORDEN.CodCli
            NO-ERROR.
    END.
    FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = OD_ORIGINAL.CodCia
        AND CcbCBult.CodDiv = OD_ORIGINAL.CodDiv
        AND CcbCBult.CodDoc = OD_ORIGINAL.CodDoc
        AND CcbCBult.NroDoc = OD_ORIGINAL.NroPed:
        CREATE B-CcbCBult.
        BUFFER-COPY CcbCBult TO B-CcbCBult
            ASSIGN
            B-CcbCBult.CodDiv = s-CodDiv
            B-CcbCBult.CodDoc = ORDEN.CodDoc
            B-CcbCBult.NroDoc = ORDEN.NroPed
            B-CcbCBult.CodCli = ORDEN.CodCli
            NO-ERROR.
    END.
    /* RHC 21/05/2018 TRANSPORTISTA */
    FOR EACH CcbADocu NO-LOCK WHERE CcbADocu.CodCia = OD_ORIGINAL.CodCia
        AND CcbADocu.CodDiv = OD_ORIGINAL.CodDiv
        AND CcbADocu.CodDoc = OD_ORIGINAL.CodDoc
        AND CcbADocu.NroDoc = OD_ORIGINAL.NroPed:
        CREATE B-CcbADocu.
        BUFFER-COPY 
            CcbADocu TO B-CcbADocu
            ASSIGN
            B-CcbADocu.CodDiv = s-CodDiv
            B-CcbADocu.CodDoc = ORDEN.CodDoc
            B-CcbADocu.NroDoc = ORDEN.NroPed
            NO-ERROR.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Nuevo-PED B-table-Win 
PROCEDURE Nuevo-PED :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-CodDoc AS CHAR NO-UNDO.
DEF VAR s-NroSer AS INT NO-UNDO.

s-CodDoc = "PED".
s-NroSer = INTEGER(SUBSTRING(PED_ORIGINAL.NroPed,1,3)).
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. La Nueva Orden de Despacho */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="Faccorre.codcia = s-codcia ~
        AND Faccorre.coddoc = s-coddoc ~
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    CREATE PEDIDO.
    BUFFER-COPY PED_ORIGINAL
        TO PEDIDO
        ASSIGN
            PEDIDO.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            PEDIDO.FchPed = TODAY
            PEDIDO.FlgEst = "C"
            PEDIDO.Usuario = s-user-id
            PEDIDO.FecAct = TODAY
            PEDIDO.HorAct= STRING(TIME,'HH:MM:SS')
            NO-ERROR
            .
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "ERROR en el correlativo del documento: " + s-CodDoc + '-' + STRING(s-NroSer,'999').
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN
        ORDEN.CodRef = PEDIDO.CodDoc
        ORDEN.NroRef = PEDIDO.NroPed.
    EMPTY TEMP-TABLE T-DPEDI.
    FOR EACH Facdpedi OF ORDEN NO-LOCK:
        CREATE T-DPEDI.
        BUFFER-COPY Facdpedi TO T-DPEDI.
    END.
    FOR EACH T-DPEDI NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY T-DPEDI TO Facdpedi
            ASSIGN
                Facdpedi.coddiv = PEDIDO.coddiv
                Facdpedi.coddoc = PEDIDO.coddoc
                Facdpedi.nroped = PEDIDO.nroped
                FacDPedi.FchPed = PEDIDO.fchped
                Facdpedi.FlgEst  = 'C'
                Facdpedi.canate = T-DPEDI.canped.
    END.
END.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE REPROGRAMAR B-table-Win 
PROCEDURE REPROGRAMAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR x-NroPed AS CHAR NO-UNDO.
DEF VAR x-CodO_D AS CHAR NO-UNDO.
DEF VAR x-NroO_D AS CHAR NO-UNDO.
DEF VAR x-Ok AS LOG NO-UNDO.

IF NOT AVAILABLE Almcdocu THEN DO:
    MESSAGE 'No hay registros seleccionados' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

/* Parámetros de generación de G/R */
fFchEnt = TODAY + 1.
fFchEntOri = Faccpedi.FchEnt.
RUN gre/d-reprograma-od-gre.r(OUTPUT iSerieNC, INPUT-OUTPUT fFchEnt) NO-ERROR.
/*IF ERROR-STATUS:ERROR OR iSerieNC = 0 THEN RETURN 'ADM-ERROR'.*/
IF ERROR-STATUS:ERROR OR fFchEnt = ? THEN DO:
    RETURN 'ADM-ERROR'.
END.
    


/* Barremos una por una */
/* LIMPIAMOS EL REGISTRO DE CONTROL DE G/R */
EMPTY TEMP-TABLE Reporte.       /* Aquí guardamos las G/R generada */

SESSION:SET-WAIT-STATE("GENERAL").

DEF VAR LocalItem AS INT NO-UNDO.
pMensaje = "".
DO LocalItem = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(LocalItem) THEN DO:
        RUN MASTER-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "Proceso Abortado".
            LEAVE.
        END.
    END.
END.

SESSION:SET-WAIT-STATE("").

IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
pMensaje = ''.
FOR EACH Reporte NO-LOCK:
    pMensaje = pMensaje + (IF TRUE <> (pMensaje > '') THEN '' ELSE CHR(10)) +
        Reporte.coddoc + " " + Reporte.nrodoc.
END.
MESSAGE 'Pre-Guias Generadas:' SKIP pMensaje VIEW-AS ALERT-BOX INFORMATION.
/*MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE REPROGRAMAR-OTR B-table-Win 
PROCEDURE REPROGRAMAR-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR x-NroPed AS CHAR NO-UNDO.
DEF VAR x-CodO_D AS CHAR NO-UNDO.
DEF VAR x-NroO_D AS CHAR NO-UNDO.
DEF VAR x-Ok AS LOG NO-UNDO.

IF NOT AVAILABLE Almcdocu THEN DO:
    MESSAGE 'No hay registros seleccionados' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* Parámetros de generación de N/C */
fFchEnt = TODAY + 1.
fFchEntOri = Faccpedi.FchEnt.
/* Barremos una por una */
DEF VAR LocalItem AS INT NO-UNDO.
DO LocalItem = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(LocalItem) THEN DO:
        RUN MASTER-TRANSACTION-OTR.
        IF RETURN-VALUE = 'ADM-ERROR' THEN LEAVE.
    END.
END.
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION B-table-Win 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-Rowid AS ROWID.

RLOOP:
FOR EACH Reporte NO-LOCK, FIRST B-CDOCU OF Reporte NO-LOCK:
    pMensaje = "Registro " + B-CDOCU.CodDoc + " " + B-CDOCU.NroDoc + " en uso por otro usuario".
    /* BLOQUEAMOS EL REGISTRO DE CONTROL */
    {lib/lock-genericov3.i ~
        &Tabla="Ccbcdocu" ~
        &Condicion="ROWID(Ccbcdocu) = ROWID(B-CDOCU)" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        
    pMensaje = "".
    FIND Almcmov WHERE Almcmov.codcia = s-codcia
        AND Almcmov.codref = Ccbcdocu.coddoc
        AND Almcmov.nroref = Ccbcdocu.nrodoc
        AND Almcmov.flgest = "A"        /* OJO */
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "PASO 2: Ingreso al almacén por la " + B-CDOCU.CodDoc + " " + B-CDOCU.NroDoc + " en uso por otro usuario".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FIND AlmCDocu WHERE ROWID(AlmCDocu) = x-Rowid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "PASO 2: Control de Reprogramación en uso por otro usuario".
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    ASSIGN Ccbcdocu.FlgEst = "P".
    RUN sunat/progress-to-ppll-v3  ( INPUT Ccbcdocu.coddiv,
                                     INPUT Ccbcdocu.coddoc,
                                     INPUT Ccbcdocu.nrodoc,
                                     INPUT-OUTPUT TABLE T-FELogErrores,
                                     OUTPUT pMensaje ).
    /* RHC 16/04/2018 En TODOS los casos: ANULAMOS los movimientos */
    IF RETURN-VALUE <> "OK" THEN DO:
        ASSIGN
            AlmCDocu.FchAprobacion = ?
            AlmCDocu.UsrAprobacion = ''
            AlmCDocu.FlgEst = "P".  /* Estado Original */
        ASSIGN 
            Ccbcdocu.FlgEst = "A".
        FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK:
            DELETE Almdmov.
        END.
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR confirmación de ePos comprobante " + 
            Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc.
        LEAVE RLOOP.
    END.
    /* Activamos los comprobantes */
    ASSIGN
        Ccbcdocu.FlgEst = "P".
    ASSIGN
        Almcmov.FlgEst = "C".
    /* Actualizamos Almacenes */
    FOR EACH Almdmov OF Almcmov NO-LOCK:
        RUN alm/almdcstk (ROWID(Almdmov)).
    END.
END.
RETURN 'OK'.

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
  {src/adm/template/snd-list.i "AlmCDocu"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "almtabla"}
  {src/adm/template/snd-list.i "gn-ven"}
  {src/adm/template/snd-list.i "CcbCBult"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE THIRD-TRANSACTION B-table-Win 
PROCEDURE THIRD-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Es solo una N/C 
------------------------------------------------------------------------------*/

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* BLOQUEAMOS LA O/D (BUFFER B-CPEDI) */
    {lib/lock-genericov3.i ~
        &Tabla="B-CPEDI" ~
        &Condicion="B-CPEDI.codcia = AlmCDocu.CodCia ~
        AND B-CPEDI.coddoc = AlmCDocu.CodDoc ~      /* O/D */
        AND B-CPEDI.nroped = AlmCDocu.NroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}

    FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte EXCLUSIVE-LOCK:
        /* Anulamos N/C */
        ASSIGN
            Ccbcdocu.FlgEst = "A"
            Ccbcdocu.FchAnu = TODAY
            CcbCDocu.UsuAnu = s-user-id.
        /* ACTUALIZAMOS EL SALDO  DE LA O/D */
        ASSIGN
            B-CPEDI.FchEnt = fFchEntOri     /* Su fecha original */
            B-CPEDI.FlgEst = "C".
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK,
            FIRST B-DPEDI OF B-CPEDI EXCLUSIVE-LOCK WHERE B-DPEDI.CodMat = Ccbddocu.CodMat:
            ASSIGN
                B-DPEDI.CanAte = B-DPEDI.CanAte + Ccbddocu.CanDes.
        END.
        IF CAN-FIND(FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanPed > B-DPEDI.CanAte NO-LOCK) 
                    THEN B-CPEDI.FlgEst = "P".  /* Aún queda por despachar */
        /* ACTUALIZAMOS SALDO DE LA FAC o BOL */
        ASSIGN
            B-CDOCU.SdoAct = B-CDOCU.SdoAct + Ccbcdocu.ImpTot
            B-CDOCU.FchCan = ?
            B-CDOCU.FlgEst = "P".       /* FAC o BOL */
        FOR EACH Ccbdcaja EXCLUSIVE-LOCK WHERE Ccbdcaja.codcia = B-CDOCU.codcia
            AND Ccbdcaja.coddoc = Ccbcdocu.coddoc
            AND Ccbdcaja.nrodoc = Ccbcdocu.nrodoc
            AND Ccbdcaja.codref = B-CDOCU.coddoc
            AND Ccbdcaja.nroref = B-CDOCU.nrodoc:
            DELETE Ccbdcaja.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TRACKING_COMERCIAL B-table-Win 
PROCEDURE TRACKING_COMERCIAL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodUbic AS CHAR.

DEFINE VAR x-data AS CHAR.

pMensaje = "".

TRACKING:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH OD_REPROGRAMADAS NO-LOCK:

        x-data = "".
        IF pCodUbic = "RPROG" THEN x-data = STRING(OD_REPROGRAMADAS.tfchent,"99/99/9999").

        /* TRACKING COMERCIAL*/
        RUN vtagn/pTracking-04 (s-CodCia,
                          s-CodDiv,
                          OD_REPROGRAMADAS.tcodped,     /* PED */
                          OD_REPROGRAMADAS.tnroped,
                          s-User-Id,
                          pCodUbic,
                          'P',
                          DATETIME(TODAY, MTIME),
                          DATETIME(TODAY, MTIME),
                          OD_REPROGRAMADAS.tcoddoc,     /* O/D */
                          OD_REPROGRAMADAS.tnrodoc,
                          OD_REPROGRAMADAS.tcodcot + "|" + OD_REPROGRAMADAS.tnrocot,
                          x-data).

    END.
END.

RETURN "OK".

END PROCEDURE.
/*
DEF INPUT PARAMETER pCodCia AS INT.     /* Código de empresa */
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Division de seguimiento de tracking */
DEF INPUT PARAMETER pCodDoc AS CHAR.    /* P/M o PED */
DEF INPUT PARAMETER pNroPed AS CHAR.    /* Número de pedido */
DEF INPUT PARAMETER pUsuario AS CHAR.   /* Usuario responsable */
DEF INPUT PARAMETER pCodUbi AS CHAR.    /* Detalle del Ciclo */
DEF INPUT PARAMETER pFlgSit AS CHAR.    /* Situacion (P) en proceso, (A) anulacion */
DEF INPUT PARAMETER pFechaI AS DATETIME.    /* Inicio del ciclo */
DEF INPUT PARAMETER pFechaT AS DATETIME.    /* Termino del ciclo */
DEF INPUT PARAMETER pCodRef1 AS CHAR.    /* Documento Actual */
DEF INPUT PARAMETER pNroRef1 AS CHAR.    /* Documento Actual */
DEF INPUT PARAMETER pCodRef2 AS CHAR.    /* Documento Anterior */
DEF INPUT PARAMETER pNroRef2 AS CHAR.    /* Documento Anterior */

*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNroRep B-table-Win 
FUNCTION fNroRep RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNroRep AS INT NO-UNDO.

  FOR EACH logtabla NO-LOCK WHERE logtabla.codcia = s-codcia
      AND logtabla.Evento = "REPROGRAMACION"
      AND logtabla.Tabla = 'ALMCDOCU'
      AND logtabla.ValorLlave BEGINS AlmCDocu.CodLlave + '|' + AlmCDocu.CodDoc + '|' + AlmCDocu.NroDoc:
      pNroRep = pNroRep + 1.
  END.
  RETURN pNroRep.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

