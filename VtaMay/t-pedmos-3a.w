&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM NO-UNDO LIKE Facdpedm.
DEFINE TEMP-TABLE ITEM-1 NO-UNDO LIKE Facdpedm.



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
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE S-FLGSIT  AS CHAR.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.

/* Variable de control porque falla el browse cuando esá activo
    Add-Multiple-Records 
*/    
DEFINE VARIABLE s-local-new-record AS CHAR INIT 'YES'.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE S-UNDBAS AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE SW-LOG1  AS LOGI NO-UNDO.

DEFINE BUFFER B-ITEM-1 FOR ITEM-1.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE NEW SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE NEW SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.

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
&Scoped-define INTERNAL-TABLES ITEM-1 Almmmatg AlmSFami

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ITEM-1.NroItm ITEM-1.codmat ~
Almmmatg.DesMat Almmmatg.DesMar ITEM-1.Libre_c01 ITEM-1.UndVta ~
ITEM-1.AlmDes ITEM-1.Libre_d01 ITEM-1.CanPed ITEM-1.PorDto ITEM-1.PreUni ~
ITEM-1.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM-1.AlmDes ITEM-1.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM-1
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM-1
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM-1 NO-LOCK, ~
      EACH AlmSFami OF Almmmatg ~
      WHERE (AlmSFami.SwDigesa = NO OR Almmmatg.VtoDigesa >= TODAY) NO-LOCK ~
    BY ITEM-1.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ITEM-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM-1 NO-LOCK, ~
      EACH AlmSFami OF Almmmatg ~
      WHERE (AlmSFami.SwDigesa = NO OR Almmmatg.VtoDigesa >= TODAY) NO-LOCK ~
    BY ITEM-1.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table ITEM-1 Almmmatg AlmSFami
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM-1
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table AlmSFami


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table x-Grupo BUTTON-FILTRAR RECT-11 
&Scoped-Define DISPLAYED-OBJECTS x-Grupo F-PorDes F-TotBrt F-ImpExo ~
F-ImpDes F-ValVta F-ImpIsc F-ImpIgv F-ImpTot 

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
DEFINE BUTTON BUTTON-FILTRAR 
     LABEL "FILTRAR POR GRUPO" 
     SIZE 19 BY 1.12.

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

DEFINE VARIABLE x-Grupo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Selecciona el grupo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 2.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ITEM-1, 
      Almmmatg, 
      AlmSFami SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ITEM-1.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      ITEM-1.codmat COLUMN-LABEL "Articulo" FORMAT "X(8)":U
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(12)":U
      ITEM-1.Libre_c01 COLUMN-LABEL "Característica" FORMAT "x(20)":U
      ITEM-1.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U
      ITEM-1.AlmDes COLUMN-LABEL "Alm!Des" FORMAT "x(3)":U
      ITEM-1.Libre_d01 COLUMN-LABEL "Stock Disponible" FORMAT "->>>,>>>,>>9.99":U
      ITEM-1.CanPed COLUMN-LABEL "Cantidad!Aprobada" FORMAT ">>,>>9.99":U
      ITEM-1.PorDto FORMAT "->>9.99":U
      ITEM-1.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.9999":U
      ITEM-1.ImpLin FORMAT ">,>>>,>>9.99":U
  ENABLE
      ITEM-1.AlmDes
      ITEM-1.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 129 BY 6.46
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.35 COL 1
     x-Grupo AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 34
     BUTTON-FILTRAR AT ROW 1 COL 98 WIDGET-ID 36
     F-PorDes AT ROW 9.08 COL 11 COLON-ALIGNED WIDGET-ID 12
     F-TotBrt AT ROW 10.42 COL 13 NO-LABEL WIDGET-ID 14
     F-ImpExo AT ROW 10.42 COL 25 NO-LABEL WIDGET-ID 4
     F-ImpDes AT ROW 10.46 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     F-ValVta AT ROW 10.42 COL 47.14 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     F-ImpIsc AT ROW 10.42 COL 59.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     F-ImpIgv AT ROW 10.42 COL 72.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     F-ImpTot AT ROW 10.42 COL 85 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 9.85 COL 77.14 WIDGET-ID 30
     "Total Importe" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 9.85 COL 87.14 WIDGET-ID 24
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 9.88 COL 37.57 WIDGET-ID 20
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 9.85 COL 25.43 WIDGET-ID 22
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 9.85 COL 65.57 WIDGET-ID 28
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.85 COL 14.86 WIDGET-ID 32
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 9.88 COL 50.86 WIDGET-ID 26
     RECT-11 AT ROW 8.88 COL 1 WIDGET-ID 18
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
      TABLE: ITEM T "SHARED" NO-UNDO INTEGRAL Facdpedm
      TABLE: ITEM-1 T "?" NO-UNDO INTEGRAL Facdpedm
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
         HEIGHT             = 11.54
         WIDTH              = 132.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
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
     _TblList          = "Temp-Tables.ITEM-1,INTEGRAL.Almmmatg OF Temp-Tables.ITEM-1,INTEGRAL.AlmSFami OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ",,"
     _OrdList          = "Temp-Tables.ITEM-1.NroItm|yes"
     _Where[3]         = "(AlmSFami.SwDigesa = NO OR Almmmatg.VtoDigesa >= TODAY)"
     _FldNameList[1]   > Temp-Tables.ITEM-1.NroItm
"ITEM-1.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ITEM-1.codmat
"ITEM-1.codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ITEM-1.Libre_c01
"ITEM-1.Libre_c01" "Característica" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM-1.UndVta
"ITEM-1.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ITEM-1.AlmDes
"ITEM-1.AlmDes" "Alm!Des" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ITEM-1.Libre_d01
"ITEM-1.Libre_d01" "Stock Disponible" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ITEM-1.CanPed
"ITEM-1.CanPed" "Cantidad!Aprobada" ">>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ITEM-1.PorDto
"ITEM-1.PorDto" ? "->>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ITEM-1.PreUni
"ITEM-1.PreUni" "Precio!Unitario" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ITEM-1.ImpLin
"ITEM-1.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME ITEM-1.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM-1.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF s-local-new-record = 'NO' AND SELF:SCREEN-VALUE = ITEM-1.codmat THEN RETURN.
    ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
        NO-ERROR.
    /* Valida Maestro Productos */
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.codmat = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF Almmmatg.TpoArt <> "A" THEN DO:
       MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    /* Valida Maestro Productos x Almacen */
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.CodAlm = TRIM(S-CODALM) 
        AND Almmmate.CodMat = TRIM(SELF:SCREEN-VALUE) 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
       MESSAGE "Articulo no esta asignado al" SKIP
               "    ALMACEN : " S-CODALM VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.   
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM-1.AlmDes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF ITEM-1.AlmDes IN BROWSE br_table /* Alm!Des */
DO:
    IF ITEM-1.codmat:SCREEN-VALUE IN BROWSE {&browse-name} = '' THEN RETURN.
    IF s-local-new-record = 'YES' THEN RETURN.
    /****    Selecciona las unidades de medida   ****/
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = ITEM-1.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK.
    RUN gn/c-uniabc ("Unidades de Venta",
                        Almmmatg.CodMat
                        ).
    IF output-var-2 = ? THEN DO:
        output-var-2 = Almmmatg.undbas.
    END.
    F-Factor = 1.
    FIND Almtconv WHERE 
         Almtconv.CodUnid = Almmmatg.UndBas AND  
         Almtconv.Codalter = output-var-2 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    ELSE DO:
         MESSAGE "Equivalencia no Registrado"
                 VIEW-AS ALERT-BOX.
         APPLY "ENTRY" TO ITEM-1.CodMat IN BROWSE {&BROWSE-NAME}.
         RETURN NO-APPLY.
    END.
    /************************************************/
    ASSIGN 
        S-UNDBAS = Almmmatg.UndBas
        X-CANPED = 1
        F-PreBas = output-var-4
        F-PreVta = output-var-4
        F-Dsctos = ABSOLUTE(output-var-5)
        Y-Dsctos = 0.
    DISPLAY Almmmatg.DesMat @ Almmmatg.DesMat 
            Almmmatg.DesMar @ Almmmatg.DesMar 
            output-var-2 @ ITEM-1.UndVta
            s-codalm @ ITEM-1.AlmDes
            F-DSCTOS @ ITEM-1.PorDto
            F-PREVTA @ ITEM-1.PreUni 
            WITH BROWSE {&BROWSE-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM-1.AlmDes IN BROWSE br_table /* Alm!Des */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND Almacen WHERE Almacen.CodCia = S-CodCia 
        AND Almacen.CodAlm = ITEM-1.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
       MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO ITEM-1.AlmDes IN BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.
    END.
    /* 08.09.09 Almacenes de despacho */
    IF s-codalm <> SELF:SCREEN-VALUE THEN DO:
        FIND almrepos WHERE almrepos.codalm = s-codalm
            AND almrepos.almped = SELF:SCREEN-VALUE
            AND almrepos.tipmat = 'VTA'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almrepos THEN DO:
            MESSAGE 'Almacen NO AUTORIZADO para ventas' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO ITEM-1.AlmDes IN BROWSE {&BROWSE-NAME}.
            RETURN NO-APPLY.
        END.
    END.
    /* STOCK DISPONIBLE */
    FIND Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = ITEM-1.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        AND Almmmate.codmat = ITEM-1.CodMat
        NO-LOCK.
    DEF VAR pComprometido AS DEC NO-UNDO.
    RUN gn/stock-comprometido (ITEM-1.CodMat,
                               ITEM-1.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                               OUTPUT pComprometido).
    DISPLAY
        ( Almmmate.stkact - pComprometido ) @ ITEM-1.Libre_d01
        WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.AlmDes br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF ITEM-1.AlmDes IN BROWSE br_table /* Alm!Des */
OR F8 OF ITEM-1.AlmDes
DO:
  ASSIGN
      input-var-1 = s-codalm
      input-var-2 = 'VTA'
      input-var-3 = ''.
  RUN lkup/c-almrep ('Almacenes de Despacho').
  IF output-var-1 <> ? THEN DO:
      SELF:SCREEN-VALUE = output-var-2.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM-1.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM-1.CanPed IN BROWSE br_table /* Cantidad!Aprobada */
DO:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = ITEM-1.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK.
    FIND Almtconv WHERE 
         Almtconv.CodUnid  = Almmmatg.UndBas AND  
         Almtconv.Codalter = ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO ITEM-1.CodMat IN BROWSE {&BROWSE-NAME}.
        RETURN NO-APPLY.
    END.
    IF Almtconv.Multiplos <> 0 THEN DO:
         IF DEC(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos <> 
            INT(DEC(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos) THEN DO:
            MESSAGE " La Cantidad debe de ser un, " SKIP
                    " multiplo de : " Almtconv.Multiplos
                    VIEW-AS ALERT-BOX WARNING.
              APPLY 'ENTRY':U TO ITEM-1.CodMat.
            RETURN NO-APPLY.
         END.
    END.
    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    x-CanPed = DEC(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    RUN vtamay/PrecioConta (s-CodCia,
                        s-CodDiv,
                        s-CodCli,
                        s-CodMon,
                        s-TpoCmb,
                        f-Factor,
                        Almmmatg.CodMat,
                        s-FlgSit,
                        ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                        x-CanPed,
                        4,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos,
                        OUTPUT SW-LOG1).

    DISPLAY 
        F-DSCTOS @ ITEM-1.PorDto
        F-PREVTA @ ITEM-1.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM-1.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM-1.PreUni IN BROWSE br_table /* Precio!Unitario */
DO:
    IF F-PREVTA > DEC(ITEM-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
       MESSAGE "No Autorizado para modificar Precio " 
       VIEW-AS ALERT-BOX ERROR.
       DISPLAY F-PREVTA @ ITEM-1.PreUni WITH BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.   
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-FILTRAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-FILTRAR B-table-Win
ON CHOOSE OF BUTTON-FILTRAR IN FRAME F-Main /* FILTRAR POR GRUPO */
DO:
  ASSIGN x-Grupo.
  RUN Carga-Temporal.
  x-Grupo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  BUTTON-FILTRAR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ITEM-1.AlmDes, ITEM-1.CodMat, ITEM-1.CanPed
DO:
    APPLY 'TAB':U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH ITEM-1:
    DELETE ITEM-1.
END.
FOR EACH Vtadfammat NO-LOCK WHERE VtaDFamMat.CodCia = s-codcia
    AND VtaDFamMat.grupo = x-Grupo,
    FIRST Almmmatg OF Vtadfammat NO-LOCK:
    IF Almmmatg.Chr__01 = "" THEN NEXT.
    /* Valida Maestro Productos x Almacen */
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.CodAlm = TRIM(S-CODALM) 
        AND Almmmate.CodMat = Vtadfammat.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN NEXT.
    FIND FIRST ITEM WHERE ITEM.codmat = VTadfammat.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN NEXT.
    CREATE ITEM-1.
    ASSIGN
        ITEM-1.CodCia = s-codcia
        ITEM-1.NroItm = VtaDFamMat.Secuencia
        ITEM-1.AlmDes = s-codalm
        ITEM-1.CodMat = VtaDFamMat.codmat
        ITEM-1.UndVta = Almmmatg.UndBas
        ITEM-1.Libre_c01 = VtaDFamMat.Descripcion
        ITEM-1.Libre_d01 = Almmmate.StkAct.
    DEF VAR pComprometido AS DEC NO-UNDO.
    RUN gn/stock-comprometido (ITEM-1.CodMat,
                               s-codalm,
                               OUTPUT pComprometido).
    ASSIGN
        ITEM-1.Libre_d01 = ITEM-1.Libre_d01 - pComprometido.

END.
RUN dispatch IN THIS-PROCEDURE ('open-query').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temporal B-table-Win 
PROCEDURE Graba-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i AS INT NO-UNDO.

i = 1.
FOR EACH ITEM BY ITEM.NroItm:
    i = ITEM.NroItm + 1.
END.
FOR EACH ITEM-1 WHERE ITEM-1.CanPed > 0:
    CREATE ITEM.
    BUFFER-COPY ITEM-1 
        EXCEPT ITEM-1.Libre_d01 ITEM-1.Libre_c01
        TO ITEM
        ASSIGN ITEM.NroItm = i.
    i = i + 1.
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
    F-ValVta = 0
    F-PorDes = 0.
  FOR EACH B-ITEM-1:
    F-ImpTot = F-ImpTot + B-ITEM-1.ImpLin.
    F-Igv = F-Igv + B-ITEM-1.ImpIgv.
    F-Isc = F-Isc + B-ITEM-1.ImpIsc.
    /*F-ImpDes = F-ImpDes + B-ITEM-1.ImpDto.*/
    IF NOT B-ITEM-1.AftIgv THEN F-ImpExo = F-ImpExo + B-ITEM-1.ImpLin.
    IF B-ITEM-1.AftIgv = YES
    THEN F-ImpDes = F-ImpDes + ROUND(B-ITEM-1.ImpDto / (1 + FacCfgGn.PorIgv / 100), 2).
    ELSE F-ImpDes = F-ImpDes + B-ITEM-1.ImpDto.
  END.
  F-ImpIgv = ROUND(F-Igv,2).
  F-ImpIsc = ROUND(F-Isc,2).
/*  F-TotBrt = F-ImpTot - F-ImpIgv - F-ImpIsc + F-ImpDes - F-ImpExo.
 *   F-ValVta = F-TotBrt -  F-ImpDes.*/
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
/*     ITEM-1.CodCia = Faccpedm.codcia */
/*     ITEM-1.CodDiv = Faccpedm.coddiv */
/*     ITEM-1.CodDoc = Faccpedm.coddoc */
/*     ITEM-1.NroPed = Faccpedm.nroped */
    ITEM-1.CodCia = s-CodCia
    ITEM-1.Factor = F-FACTOR
    ITEM-1.NroItm = I-NroItm
    ITEM-1.PreBas = F-PreBas 
    ITEM-1.AftIgv = Almmmatg.AftIgv 
    ITEM-1.AftIsc = Almmmatg.AftIsc 
    ITEM-1.Flg_factor = IF SW-LOG1 THEN "1" ELSE "0"   /* Add by C.Q. 23/03/2000 */
    ITEM-1.PreUni = DEC(ITEM-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    ITEM-1.PorDto = DEC(ITEM-1.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    ITEM-1.Por_DSCTOS[2] = Almmmatg.PorMax    /* Add by C.Q. 23/03/2000 */
    ITEM-1.Por_Dsctos[3] = Y-DSCTOS
    ITEM-1.ImpDto = ROUND( ITEM-1.PreUni * (ITEM-1.Por_Dsctos[1] / 100) * (IF SW-LOG1 THEN ITEM-1.CanPed ELSE (ITEM-1.CanPed * F-FACTOR)), 2 )
    ITEM-1.ImpLin = ROUND( ITEM-1.PreUni * (IF SW-LOG1 THEN ITEM-1.CanPed ELSE (ITEM-1.CanPed * F-FACTOR)) , 2 ) - ITEM-1.ImpDto.
    ITEM-1.UndVta = ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

  IF ITEM-1.AftIsc 
  THEN ITEM-1.ImpIsc = ROUND(ITEM-1.PreBas * (IF SW-LOG1 THEN ITEM-1.CanPed ELSE (ITEM-1.CanPed * F-FACTOR)) * (Almmmatg.PorIsc / 100),4).
  IF ITEM-1.AftIgv 
  THEN ITEM-1.ImpIgv = ITEM-1.ImpLin - ROUND(ITEM-1.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).

  ITEM-1.Libre_d01 = DECIMAL(ITEM-1.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}).

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
  s-local-new-record = 'YES'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Head'). 

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
  APPLY 'entry':u TO ITEM-1.almdes IN BROWSE {&browse-name}.

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
  s-local-new-record = 'YES'.

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
  FOR EACH B-ITEM-1:
    F-FACTOR = B-ITEM-1.Factor.
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = B-ITEM-1.CODCIA AND  
         Almmmatg.codmat = B-ITEM-1.codmat 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        x-CanPed = B-ITEM-1.CanPed.
        RUN vtamay/PrecioConta (s-CodCia,
                            s-CodDiv,
                            s-CodCli,
                            s-CodMon,
                            s-TpoCmb,
                            f-Factor,
                            Almmmatg.CodMat,
                            s-FlgSit,
                            B-ITEM-1.UndVta,
                            x-CanPed,
                            4,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos,
                            OUTPUT SW-LOG1).

        ASSIGN 
            B-ITEM-1.PreBas = F-PreBas 
            B-ITEM-1.AftIgv = Almmmatg.AftIgv 
            B-ITEM-1.AftIsc = Almmmatg.AftIsc
            B-ITEM-1.PreUni = F-PREVTA
            B-ITEM-1.PorDto = F-DSCTOS
            B-ITEM-1.Por_Dsctos[2] = Almmmatg.PorMax
            B-ITEM-1.Por_Dsctos[3] = Y-DSCTOS 
            B-ITEM-1.ImpDto = ROUND( B-ITEM-1.PreBas * (F-DSCTOS / 100) * B-ITEM-1.CanPed , 2).
            B-ITEM-1.ImpLin = ROUND( B-ITEM-1.PreUni * B-ITEM-1.CanPed , 2 ).
       IF B-ITEM-1.AftIsc THEN 
          B-ITEM-1.ImpIsc = ROUND(B-ITEM-1.PreBas * B-ITEM-1.CanPed * (Almmmatg.PorIsc / 100),4).
       IF B-ITEM-1.AftIgv THEN  
          B-ITEM-1.ImpIgv = B-ITEM-1.ImpLin - ROUND(B-ITEM-1.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
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
  {src/adm/template/snd-list.i "ITEM-1"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "AlmSFami"}

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
  DEFINE VARIABLE F-STKRET AS DECIMAL NO-UNDO.
  DEFINE VARIABLE S-OK AS LOG NO-UNDO.
  DEFINE VARIABLE S-StkComprometido AS DECIMAL NO-UNDO.
  DEFINE VARIABLE S-StkDis AS DECIMAL NO-UNDO.
  DEFINE BUFFER BUF-ALMMMATE FOR ALMMMATE.
  
/*   IF (i-NroItm) > FacCfgGn.Items_PedMos                                       */
/*       THEN DO:                                                                */
/*      MESSAGE "El Numero de Items No Puede Ser Mayor a " FacCfgGn.Items_PedMos */
/*              VIEW-AS ALERT-BOX ERROR.                                         */
/*      RETURN "ADM-ERROR".                                                      */
/*   END.                                                                        */

  IF ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
      OR INTEGER(ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
      MESSAGE "Codigo de Articulo no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM-1.CodMat.
      RETURN "ADM-ERROR".
  END.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND  Almmmatg.codmat = ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de articulo no existe" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF ITEM-1.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
    MESSAGE "Almacen de Despacho no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO ITEM-1.AlmDes.
    RETURN "ADM-ERROR".
  END.
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = ITEM-1.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND  Almmmate.codmat = ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Articulo no asignado al almacen " ITEM-1.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
           VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM-1.CodMat.
      RETURN "ADM-ERROR".
  END.
  IF DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0.125 THEN DO:
       MESSAGE "Cantidad debe ser mayor o igual a 0.25" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM-1.CanPed.
       RETURN "ADM-ERROR".
  END.
  IF DECIMAL(ITEM-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM-1.PreUni.
       RETURN "ADM-ERROR".
  END.
  IF ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
       APPLY 'ENTRY':U TO ITEM-1.CodMat.
  END.
  FIND B-ITEM-1 WHERE B-ITEM-1.CODCIA = S-CODCIA 
    AND  B-ITEM-1.CodMat = ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
    NO-LOCK NO-ERROR.
  IF AVAILABLE  B-ITEM-1 AND ROWID(B-ITEM-1) <> ROWID(ITEM-1) THEN DO:
       MESSAGE "Codigo de Articulo repetido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
  END.

  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
      NO-LOCK NO-ERROR.
  f-Factor = Almtconv.Equival / Almmmatg.FacEqu.
  x-CanPed = DEC(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * f-Factor.

  RUN gn/Stock-Comprometido (ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                             ITEM-1.AlmDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                             OUTPUT s-StkComprometido).
  IF s-adm-new-record = 'NO' THEN DO:
      FIND Facdpedm WHERE Facdpedm.codcia = s-codcia
          AND Facdpedm.coddoc = s-coddoc
          AND Facdpedm.nroped = s-nroped
          AND Facdpedm.codmat = ITEM-1.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          NO-LOCK NO-ERROR.
      IF AVAILABLE Facdpedm THEN DO:
          s-StkComprometido = s-StkComprometido - Facdpedm.CanPed * Facdpedm.Factor.
      END.
  END.
  s-StkDis = Almmmate.StkAct - s-StkComprometido.

  IF s-StkDis < x-CanPed THEN DO:
        MESSAGE "No hay STOCK suficiente" SKIP(1)
                "       STOCK ACTUAL : " Almmmate.StkAct Almmmatg.undbas SKIP
                "  STOCK COMPROMETIDO: " s-StkComprometido Almmmatg.undbas SKIP
                "   STOCK DISPONIBLE : " S-STKDIS Almmmatg.undbas SKIP
                VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO ITEM-1.CanPed.
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
IF AVAILABLE ITEM-1
THEN ASSIGN
        i-nroitm = ITEM-1.NroItm
        f-Factor = ITEM-1.Factor
        f-PreBas = ITEM-1.PreBas
        f-PreVta = ITEM-1.PreUni
        f-Dsctos = ITEM-1.PorDto
        y-Dsctos = ITEM-1.Por_Dsctos[3].

s-local-new-record = 'NO'.
RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

